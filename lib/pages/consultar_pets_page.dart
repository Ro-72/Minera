import 'package:flutter/material.dart';

class ConsultarPetsPage extends StatefulWidget {
  const ConsultarPetsPage({super.key});

  @override
  State<ConsultarPetsPage> createState() => _ConsultarPetsPageState();
}

class _ConsultarPetsPageState extends State<ConsultarPetsPage> {
  List<bool> _expanded = [true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar PETS')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _expanded = List<bool>.filled(_expanded.length, false);
                    });
                  },
                  child: const Text('Colapsar todo'),
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _expanded[index] = !_expanded[index];
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder:
                        (context, isExpanded) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded[0] = !_expanded[0];
                            });
                          },
                          child: const ListTile(
                            contentPadding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('1. RESPONSABLES:'),
                            ),
                          ),
                        ),
                    body: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '• Jefe de laboratorio\n'
                          '• Operadores de laboratorio\n'
                          '• Ingeniero de seguridad',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    isExpanded: _expanded[0],
                  ),
                  ExpansionPanel(
                    headerBuilder:
                        (context, isExpanded) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded[1] = !_expanded[1];
                            });
                          },
                          child: const ListTile(
                            title: Text('2. EQUIPOS Y HERRAMIENTAS UTILIZADAS'),
                          ),
                        ),
                    body: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '• Estufa de secado de mineral\n'
                        '• Balanza de precisión\n'
                        '• Chancadora de quijada\n'
                        '• Pulverizadora de anillos\n'
                        '• Crucetas de cuarteo\n'
                        '• Tamices (malla #200)\n'
                        '• Herramientas manuales (bandejas, espátulas, brochas, etc.)\n'
                        '• Mineral de cuarzo\n'
                        '• Pistolas de aire\n'
                        '• Bolsas para muestras',
                      ),
                    ),
                    isExpanded: _expanded[1],
                  ),
                  ExpansionPanel(
                    headerBuilder:
                        (context, isExpanded) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded[2] = !_expanded[2];
                            });
                          },
                          child: const ListTile(
                            title: Text(
                              '3. EQUIPOS DE PROTECCION PERSONAL (EPP)',
                            ),
                          ),
                        ),
                    body: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '• Casco de seguridad\n'
                        '• Tapones auditivos y orejeras\n'
                        '• Guantes anticorte\n'
                        '• Respirador con filtros mixtos (antipolvo y contra gases)\n'
                        '• Lentes de seguridad\n'
                        '• Ropa de trabajo\n'
                        '• Zapatos de seguridad',
                      ),
                    ),
                    isExpanded: _expanded[2],
                  ),
                  ExpansionPanel(
                    headerBuilder:
                        (context, isExpanded) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded[3] = !_expanded[3];
                            });
                          },
                          child: const ListTile(
                            title: Text(
                              '4. PROCEDIMIENTO ESCRITO DE TRABAJO SEGURO:',
                            ),
                          ),
                        ),
                    body: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '• Recepción de muestras: Verificar el peso y las condiciones de la muestra de ingreso, registrar la muestra en el tablero de registro, almacenar la muestra para iniciar con el secado correspondiente.\n'
                        '• Secado: Colocar la muestra en bandejas en bandejas y reducir las aglomeraciones que puedan existir, ingresar la bandeja a la estufa de secado a una temperatura entre 100°C y 110°C evitando el sobrecaliento de la misma para que sufra alteraciones.\n'
                        '• Chancado: Usar una chancadora de quijadas con el setting de ¼”, introducir la muestra gradualmente para evitar atoramientos, posterior al ingreso de la muestra limpiar el equipo con cuarzo y pistola de aire para evitar contaminación cruzada\n'
                        '• pulverización: Usar la pulverizadora de discos, ingresar la muestra en la olla gradualmente y evitar derrames, el tiempo de pulverizado es aproximadamente de 15 minutos, el objetivo es llegar a una granulometría menor a la malla #200, evitar la sobrecarga del equipo para una correcta operación, por último, verificar la homogeneidad del pulverizado antes del cuarteo\n'
                        '• Cuarteo: Utilizar la cruceta de cuarteo hasta poder obtener facciones representativas (entre 500 y 600 g) almacenar las submuestras en bolsas correctamente rotuladas (prueba metalúrgica y análisis químico), almacenar y rotular las contramuestras.\n'
                        '• Limpieza de equipos y área: limpiar todos los equipos con brochas, cepillos y pistola de aire comprimido, disponer los residuos peligrosos y no peligrosos.',
                      ),
                    ),
                    isExpanded: _expanded[3],
                  ),
                  ExpansionPanel(
                    headerBuilder:
                        (context, isExpanded) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded[4] = !_expanded[4];
                            });
                          },
                          child: const ListTile(
                            title: Text(
                              '5. Registro y documentación asociada:',
                            ),
                          ),
                        ),
                    body: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '• Registro de recepción de muestras\n'
                        '• Bitácora de % de humedad de muestras\n'
                        '• Reporte de mantenciones\n'
                        '• Bitácora de tipo de mineral (yampo, oxido, sulfuro, etc.)\n'
                        '• Reporte de mantenciones',
                      ),
                    ),
                    isExpanded: _expanded[4],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
