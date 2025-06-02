import 'package:flutter/material.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();

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
    });
  }

  void desbloquearInputs() {
    // Limpia los valores de los TextEditingController y fuerza reconstrucción
    codigoController.text = '';
    tipoController.text = '';
    FocusScope.of(
      context,
    ).unfocus(); // <-- fuerza perder el foco y refresca el input
    setState(() {
      _codigoSelected = false;
      _tipoSelected = false;
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
      appBar: AppBar(title: const Text('Reportes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Botón para desbloquear ambos inputs
            if (_codigoSelected || _tipoSelected)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: desbloquearInputs,
                  child: const Text('Desbloquear campos'),
                ),
              ),
            // Autocomplete para Código de muestra
            Autocomplete<String>(
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
                controller.addListener(() {
                  if (controller.text != codigoController.text) {
                    codigoController.text = controller.text;
                  }
                  setState(() {}); // Fuerza refresco para label dinámico
                });
                // Usar una sola variable para el labelText y refrescar siempre
                String codigoLabel = 'Código de muestra';
                if (_tipoSelected) {
                  final muestra = muestrasJson.firstWhere(
                    (e) =>
                        (e['tipo'] as String).toLowerCase() ==
                        tipoController.text.toLowerCase(),
                    orElse: () => {},
                  );
                  codigoLabel =
                      muestra.isNotEmpty ? muestra['id'] : 'ID bloqueado';
                }
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.number,
                  enabled: !_tipoSelected,
                  decoration: InputDecoration(
                    labelText: codigoLabel,
                    hintText: 'Ingrese el código',
                  ),
                  onChanged: (value) {
                    final filtered = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (filtered != value) {
                      controller.text = filtered;
                      controller.selection = TextSelection.fromPosition(
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
                    // Mostrar toast si se encontró el id
                    if (muestra.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'ID encontrado: ${muestra['id']} (${muestra['tipo']})',
                          ),
                        ),
                      );
                    }
                  },
                );
              },
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
                // Mostrar toast si se encontró el id
                if (muestra.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'ID encontrado: ${muestra['id']} (${muestra['tipo']})',
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // Autocomplete para Tipo de muestra
            Autocomplete<String>(
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
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onEditingComplete,
              ) {
                // Sincroniza el valor del controller con tipoController
                controller.addListener(() {
                  if (controller.text != tipoController.text) {
                    tipoController.text = controller.text;
                  }
                  setState(() {});
                });
                // Usar una sola variable para el labelText y refrescar siempre
                String tipoLabel = 'Tipo de muestra';
                if (_codigoSelected) {
                  final muestra = muestrasJson.firstWhere(
                    (e) => e['id'] == codigoController.text,
                    orElse: () => {},
                  );
                  tipoLabel =
                      muestra.isNotEmpty ? muestra['tipo'] : 'Tipo bloqueado';
                }
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: !_codigoSelected,
                  decoration: InputDecoration(
                    labelText: tipoLabel,
                    hintText: 'Ingrese el tipo',
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
                // Mostrar toast si se encontró el tipo
                if (muestra.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tipo encontrado: ${muestra['tipo']}'),
                    ),
                  );
                }
              },
            ),
            // --- ¿Cómo funciona? ---
            // Cuando seleccionas un código de muestra (id) por autocompletado o enter,
            // se actualiza el campo tipoController con el nombre correspondiente.
            // Además, el input de tipo de muestra se bloquea y su hintText muestra el nombre del tipo.
            // Si desbloqueas los campos, todo vuelve a estar editable.
            // El mismo comportamiento aplica a la inversa si seleccionas primero el tipo.
            // El placeholder se refresca correctamente porque se llama setState en cada cambio.
            // Además, se muestra un toast cuando se encuentra un dato por id o tipo.
            // -----------------------
            const SizedBox(height: 16),
            // Input Hora de inicio (solo lectura)
            TextField(
              controller: horaInicioController,
              decoration: const InputDecoration(
                labelText: 'Hora de inicio',
                hintText: 'Presione "Inicio"',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: iniciarHora,
                  child: const Text('Inicio'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: (_horaInicio != null) ? terminarHora : null,
                  child: const Text('Terminar'),
                ),
                const SizedBox(width: 16),
                if (_tiempoTranscurrido != null)
                  Text('Tiempo: $_tiempoTranscurrido'),
              ],
            ),
            const SizedBox(height: 32),
            // ...otros widgets si es necesario...
          ],
        ),
      ),
    );
  }
}
