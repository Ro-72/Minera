import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Usuario autenticado, mostrar la página de reportes
          return const ReportesPageContent();
        } else {
          // Usuario no autenticado, mostrar mensaje y botón para login
          return const ReportesAuthRequired();
        }
      },
    );
  }
}

class ReportesAuthRequired extends StatelessWidget {
  const ReportesAuthRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Reportes de Análisis'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade100, Colors.grey.shade200],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Acceso Restringido',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Para acceder a la sección de reportes es necesario iniciar sesión con una cuenta válida.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                      // No need to do anything, StreamBuilder will handle the state change
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Los reportes contienen información sensible que requiere autenticación.',
                          style: TextStyle(
                            color: Color(0xFF2C2C2C),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportesPageContent extends StatefulWidget {
  const ReportesPageContent({super.key});

  @override
  State<ReportesPageContent> createState() => _ReportesPageContentState();
}

class _ReportesPageContentState extends State<ReportesPageContent> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();

  // Add a key to force Autocomplete widgets to rebuild
  Key _autocompleteKey = UniqueKey();

  // Simulación de base de datos de muestras usando un JSON
  final List<Map<String, dynamic>> muestrasJson = [
    {"id": "001", "tipo": "Mineral"},
    {"id": "002", "tipo": "Concentrado"},
    {"id": "003", "tipo": "Relave"},
    {"id": "004", "tipo": "Solución"},
    {"id": "005", "tipo": "Agua"},
    {"id": "006", "tipo": "Pulpa"},
  ];

  DateTime? _horaInicio;
  DateTime? _horaFin;
  String? _tiempoTranscurrido;

  bool _codigoSelected = false;
  bool _tipoSelected = false;

  void buscarPorCodigo(String codigo) {
    final muestra = muestrasJson.firstWhere(
      (e) => e['id'] == codigo,
      orElse: () => {},
    );
    if (muestra.isNotEmpty) {
      tipoController.text = muestra['tipo'];
    } else {
      tipoController.text = '';
    }
  }

  void buscarPorTipo(String tipo) {
    final muestra = muestrasJson.firstWhere(
      (e) => (e['tipo'] as String).toLowerCase().contains(tipo.toLowerCase()),
      orElse: () => {},
    );
    if (muestra.isNotEmpty) {
      codigoController.text = muestra['id'];
    }
  }

  void iniciarHora() {
    setState(() {
      _horaInicio = DateTime.now();
      horaInicioController.text =
          "${_horaInicio!.hour.toString().padLeft(2, '0')}:${_horaInicio!.minute.toString().padLeft(2, '0')}:${_horaInicio!.second.toString().padLeft(2, '0')}";
      _horaFin = null;
      _tiempoTranscurrido = null;
    });
  }

  void terminarHora() {
    if (_horaInicio == null) return;
    setState(() {
      _horaFin = DateTime.now();
      final duracion = _horaFin!.difference(_horaInicio!);
      _tiempoTranscurrido =
          "${duracion.inHours.toString().padLeft(2, '0')}:${(duracion.inMinutes % 60).toString().padLeft(2, '0')}:${(duracion.inSeconds % 60).toString().padLeft(2, '0')}";

      // Clear the start time when terminating
      horaInicioController.clear();
      _horaInicio = null;
    });
  }

  void desbloquearInputs() {
    // Resetea completamente los inputs y variables de estado
    setState(() {
      codigoController.clear();
      tipoController.clear();
      _codigoSelected = false;
      _tipoSelected = false;
      // Force Autocomplete widgets to rebuild with new key
      _autocompleteKey = UniqueKey();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // Opciones para autocompletar código y tipo
    final List<String> codigos =
        muestrasJson.map((e) => e['id'] as String).toList();
    final List<String> tipos =
        muestrasJson.map((e) => e['tipo'] as String).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Reportes de Análisis'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Botón para desbloquear ambos inputs
              if (_codigoSelected || _tipoSelected)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: desbloquearInputs,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Desbloquear Campos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B7355),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Card para inputs principales
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de la Muestra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Autocomplete para Código de muestra
                      Autocomplete<String>(
                        key: _autocompleteKey,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return codigos.where((String option) {
                            return option.contains(textEditingValue.text);
                          });
                        },
                        fieldViewBuilder: (
                          context,
                          controller,
                          focusNode,
                          onEditingComplete,
                        ) {
                          // ...existing code for controller listener and label logic...
                          controller.addListener(() {
                            if (controller.text != codigoController.text) {
                              codigoController.text = controller.text;
                            }
                            setState(() {});
                          });

                          String codigoLabel = 'Código de Muestra';
                          if (_tipoSelected) {
                            final muestra = muestrasJson.firstWhere(
                              (e) =>
                                  (e['tipo'] as String).toLowerCase() ==
                                  tipoController.text.toLowerCase(),
                              orElse: () => {},
                            );
                            codigoLabel =
                                muestra.isNotEmpty
                                    ? muestra['id']
                                    : 'ID Bloqueado';
                          }

                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            keyboardType: TextInputType.number,
                            enabled: !_tipoSelected,
                            decoration: InputDecoration(
                              labelText: codigoLabel,
                              hintText: 'Ingrese el código de muestra',
                              prefixIcon: const Icon(Icons.qr_code),
                            ),
                            // ...existing code for onChanged and onSubmitted...
                            onChanged: (value) {
                              final filtered = value.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              if (filtered != value) {
                                controller.text = filtered;
                                controller
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(offset: filtered.length),
                                );
                              }
                            },
                            onSubmitted: (value) {
                              final codigo = value.trim();
                              final muestra = muestrasJson.firstWhere(
                                (e) => e['id'] == codigo,
                                orElse: () => {},
                              );
                              setState(() {
                                tipoController.text =
                                    muestra.isNotEmpty ? muestra['tipo'] : '';
                                _codigoSelected = muestra.isNotEmpty;
                                if (_codigoSelected) _tipoSelected = false;
                              });
                              if (muestra.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'ID encontrado: ${muestra['id']} (${muestra['tipo']})',
                                    ),
                                    backgroundColor: const Color(0xFFD4AF37),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        // ...existing code for onSelected...
                        onSelected: (String value) {
                          final muestra = muestrasJson.firstWhere(
                            (e) => e['id'] == value,
                            orElse: () => {},
                          );
                          setState(() {
                            codigoController.text = value;
                            tipoController.text =
                                muestra.isNotEmpty ? muestra['tipo'] : '';
                            _codigoSelected = muestra.isNotEmpty;
                            if (_codigoSelected) _tipoSelected = false;
                          });
                          if (muestra.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'ID encontrado: ${muestra['id']} (${muestra['tipo']})',
                                ),
                                backgroundColor: const Color(0xFFD4AF37),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Autocomplete para Tipo de muestra
                      Autocomplete<String>(
                        key: ValueKey('tipo_$_autocompleteKey'),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return tipos.where((String option) {
                            return option.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },
                        optionsMaxHeight: 150, // Limit dropdown height
                        fieldViewBuilder: (
                          context,
                          controller,
                          focusNode,
                          onEditingComplete,
                        ) {
                          // ...existing code for controller listener and label logic...
                          controller.addListener(() {
                            if (controller.text != tipoController.text) {
                              tipoController.text = controller.text;
                            }
                            setState(() {});
                          });

                          String tipoLabel = 'Tipo de Muestra';
                          if (_codigoSelected) {
                            final muestra = muestrasJson.firstWhere(
                              (e) => e['id'] == codigoController.text,
                              orElse: () => {},
                            );
                            tipoLabel =
                                muestra.isNotEmpty
                                    ? muestra['tipo']
                                    : 'Tipo Bloqueado';
                          }

                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            enabled: !_codigoSelected,
                            decoration: InputDecoration(
                              labelText: tipoLabel,
                              hintText: 'Ingrese el tipo de muestra',
                              prefixIcon: const Icon(Icons.category),
                            ),
                            onChanged: (value) {
                              buscarPorTipo(value.trim());
                            },
                          );
                        },
                        onSelected: (String value) {
                          tipoController.text = value;
                          buscarPorTipo(value);
                          final muestra = muestrasJson.firstWhere(
                            (e) =>
                                (e['tipo'] as String).toLowerCase() ==
                                value.toLowerCase(),
                            orElse: () => {},
                          );
                          setState(() {
                            _tipoSelected = muestra.isNotEmpty;
                            if (_tipoSelected) _codigoSelected = false;
                          });
                          if (muestra.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Tipo encontrado: ${muestra['tipo']}',
                                ),
                                backgroundColor: const Color(0xFFD4AF37),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card para control de tiempo
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Control de Tiempo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Display area for start time
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Color(0xFF8B7355),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hora de Inicio',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B7355),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  horaInicioController.text.isEmpty
                                      ? 'Presione "Iniciar" para comenzar'
                                      : horaInicioController.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        horaInicioController.text.isEmpty
                                            ? Colors.grey.shade600
                                            : const Color(0xFF2C2C2C),
                                    fontWeight:
                                        horaInicioController.text.isEmpty
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: iniciarHora,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Iniciar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  (_horaInicio != null) ? terminarHora : null,
                              icon: const Icon(Icons.stop),
                              label: const Text('Terminar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B7355),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_tiempoTranscurrido != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFD4AF37)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 8),
                              Text(
                                'Tiempo transcurrido: $_tiempoTranscurrido',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ...existing methods remain the same...
}
