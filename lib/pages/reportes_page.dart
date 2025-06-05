import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'auth_page.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  @override
  Widget build(BuildContext context) {
    // * StreamBuilder monitors Firebase authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ? Handle loading state while checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // * User is authenticated - show reports content
          return const ReportesPageContent();
        } else {
          // ! User not authenticated - show access restriction screen
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
                // * Lock icon to indicate restricted access
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
                // * Main authentication button - navigates to separate auth page
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // ? Navigate to dedicated authentication page
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                      // ! StreamBuilder automatically handles state changes
                      // TODO: Consider showing loading indicator during navigation
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
  Timer? _timer;
  String _tiempoEnVivo = "00:00:00";
  bool _reporteEnviado = false;

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
      _horaFin = null;
      _tiempoTranscurrido = null;
      _reporteEnviado = false;
      _tiempoEnVivo = "00:00:00";
    });

    // * Start live timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_horaInicio != null && _horaFin == null) {
        final duracion = DateTime.now().difference(_horaInicio!);
        setState(() {
          _tiempoEnVivo =
              "${duracion.inHours.toString().padLeft(2, '0')}:${(duracion.inMinutes % 60).toString().padLeft(2, '0')}:${(duracion.inSeconds % 60).toString().padLeft(2, '0')}";
        });
      }
    });
  }

  void terminarHora() {
    if (_horaInicio == null) return;

    // * Validate that we have sample information before saving
    if (codigoController.text.trim().isEmpty ||
        tipoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor complete la información de la muestra antes de terminar',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _horaFin = DateTime.now();
      final duracion = _horaFin!.difference(_horaInicio!);
      _tiempoTranscurrido =
          "${duracion.inHours.toString().padLeft(2, '0')}:${(duracion.inMinutes % 60).toString().padLeft(2, '0')}:${(duracion.inSeconds % 60).toString().padLeft(2, '0')}";
    });

    // * Stop timer
    _timer?.cancel();

    // * Show finish time toast
    String horaFinalizacion =
        "${_horaFin!.hour.toString().padLeft(2, '0')}:${_horaFin!.minute.toString().padLeft(2, '0')}:${_horaFin!.second.toString().padLeft(2, '0')}";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white),
            const SizedBox(width: 8),
            Text('Finalizado a las: $horaFinalizacion'),
          ],
        ),
        backgroundColor: const Color(0xFF8B7355),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // * Send report to Firestore
  Future<void> _enviarReporte() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _horaInicio == null || _horaFin == null) {
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // * Get user data from Firestore for complete report information
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      Map<String, dynamic> userData = {};
      if (userDoc.exists) {
        userData = userDoc.data() as Map<String, dynamic>;
      }

      // * Create report document
      Map<String, dynamic> reportData = {
        'sampleCode': codigoController.text.trim(),
        'sampleType': tipoController.text.trim(),
        'startTime': Timestamp.fromDate(_horaInicio!),
        'endTime': Timestamp.fromDate(_horaFin!),
        'processingDuration': _tiempoTranscurrido,
        'userInfo': {
          'uid': currentUser.uid,
          'name': userData['name'] ?? 'Usuario',
          'email': userData['email'] ?? currentUser.email ?? 'No disponible',
          'role': userData['role'] ?? 'No especificado',
        },
        'createdAt': FieldValue.serverTimestamp(),
        'reportDate': Timestamp.fromDate(DateTime.now()),
      };

      // * Save to Firestore reports collection
      await FirebaseFirestore.instance.collection('reports').add(reportData);

      // Hide loading indicator
      Navigator.pop(context);

      setState(() {
        _reporteEnviado = true;
      });

      // * Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Reporte enviado exitosamente'),
              ],
            ),
            backgroundColor: Color(0xFFD4AF37),
          ),
        );
      }

      // * Reset form after successful send
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _resetForm();
        }
      });
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // ! Error handling for Firestore operations
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // * Reset form to initial state
  void _resetForm() {
    setState(() {
      _horaInicio = null;
      _horaFin = null;
      _tiempoTranscurrido = null;
      _tiempoEnVivo = "00:00:00";
      _reporteEnviado = false;
      codigoController.clear();
      tipoController.clear();
      _codigoSelected = false;
      _tipoSelected = false;
      _autocompleteKey = UniqueKey();
    });
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Function to unlock both input fields
  void desbloquearInputs() {
    setState(() {
      _codigoSelected = false;
      _tipoSelected = false;
      _autocompleteKey = UniqueKey();
    });
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

                      // * Live timer display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              _horaInicio != null && _horaFin == null
                                  ? const Color(0xFFD4AF37).withOpacity(0.1)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _horaInicio != null && _horaFin == null
                                    ? const Color(0xFFD4AF37)
                                    : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color:
                                  _horaInicio != null && _horaFin == null
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFF8B7355),
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _horaInicio != null && _horaFin == null
                                      ? 'Tiempo Transcurrido'
                                      : _tiempoTranscurrido != null
                                      ? 'Tiempo Final'
                                      : 'Cronómetro',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        _horaInicio != null && _horaFin == null
                                            ? const Color(0xFFD4AF37)
                                            : const Color(0xFF8B7355),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _tiempoTranscurrido ?? _tiempoEnVivo,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color:
                                        _horaInicio != null && _horaFin == null
                                            ? const Color(0xFFD4AF37)
                                            : const Color(0xFF2C2C2C),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // * Control buttons
                      if (_horaFin == null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    _horaInicio == null ? iniciarHora : null,
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
                      ],

                      // * Send report button (shown after terminating)
                      if (_horaFin != null && !_reporteEnviado) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _enviarReporte,
                            icon: const Icon(Icons.send),
                            label: const Text('Enviar Reporte'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],

                      // * Report sent confirmation
                      if (_reporteEnviado) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Reporte enviado y guardado en la base de datos',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _resetForm,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Nuevo Reporte'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8B7355),
                              side: const BorderSide(color: Color(0xFF8B7355)),
                            ),
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
