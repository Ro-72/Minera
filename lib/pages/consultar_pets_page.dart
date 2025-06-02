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
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.folder_open, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Consultar PETS'),
          ],
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header con información del PETS
                Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFD4AF37).withOpacity(0.1),
                          const Color(0xFF8B7355).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.security,
                          size: 48,
                          color: Color(0xFFD4AF37),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Procedimiento Escrito de Trabajo Seguro',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Preparación de Muestras para Análisis',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8B7355),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _expanded = List<bool>.filled(
                              _expanded.length,
                              false,
                            );
                          });
                        },
                        icon: const Icon(Icons.unfold_less),
                        label: const Text('Colapsar Todo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B7355),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _expanded = List<bool>.filled(
                              _expanded.length,
                              true,
                            );
                          });
                        },
                        icon: const Icon(Icons.unfold_more),
                        label: const Text('Expandir Todo'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ExpansionPanelList(
                  elevation: 2,
                  expandedHeaderPadding: const EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _expanded[index] = !_expanded[index];
                    });
                  },
                  children: [
                    _buildExpansionPanel(
                      0,
                      '1. RESPONSABLES',
                      Icons.people,
                      const Color(0xFFD4AF37),
                      '• Jefe de laboratorio\n'
                          '• Operadores de laboratorio\n'
                          '• Ingeniero de seguridad',
                    ),
                    _buildExpansionPanel(
                      1,
                      '2. EQUIPOS Y HERRAMIENTAS UTILIZADAS',
                      Icons.build,
                      const Color(0xFF8B7355),
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
                    _buildExpansionPanel(
                      2,
                      '3. EQUIPOS DE PROTECCIÓN PERSONAL (EPP)',
                      Icons.shield,
                      const Color(0xFF6B4423),
                      '• Casco de seguridad\n'
                          '• Tapones auditivos y orejeras\n'
                          '• Guantes anticorte\n'
                          '• Respirador con filtros mixtos (antipolvo y contra gases)\n'
                          '• Lentes de seguridad\n'
                          '• Ropa de trabajo\n'
                          '• Zapatos de seguridad',
                    ),
                    _buildExpansionPanel(
                      3,
                      '4. PROCEDIMIENTO ESCRITO DE TRABAJO SEGURO',
                      Icons.list_alt,
                      const Color(0xFF4A4A4A),
                      '• Recepción de muestras: Verificar el peso y las condiciones de la muestra de ingreso, registrar la muestra en el tablero de registro, almacenar la muestra para iniciar con el secado correspondiente.\n\n'
                          '• Secado: Colocar la muestra en bandejas y reducir las aglomeraciones que puedan existir, ingresar la bandeja a la estufa de secado a una temperatura entre 100°C y 110°C evitando el sobrecaliento de la misma para que sufra alteraciones.\n\n'
                          '• Chancado: Usar una chancadora de quijadas con el setting de ¼", introducir la muestra gradualmente para evitar atoramientos, posterior al ingreso de la muestra limpiar el equipo con cuarzo y pistola de aire para evitar contaminación cruzada.\n\n'
                          '• Pulverización: Usar la pulverizadora de discos, ingresar la muestra en la olla gradualmente y evitar derrames, el tiempo de pulverizado es aproximadamente de 15 minutos, el objetivo es llegar a una granulometría menor a la malla #200, evitar la sobrecarga del equipo para una correcta operación, por último, verificar la homogeneidad del pulverizado antes del cuarteo.\n\n'
                          '• Cuarteo: Utilizar la cruceta de cuarteo hasta poder obtener fracciones representativas (entre 500 y 600 g) almacenar las submuestras en bolsas correctamente rotuladas (prueba metalúrgica y análisis químico), almacenar y rotular las contramuestras.\n\n'
                          '• Limpieza de equipos y área: limpiar todos los equipos con brochas, cepillos y pistola de aire comprimido, disponer los residuos peligrosos y no peligrosos.',
                    ),
                    _buildExpansionPanel(
                      4,
                      '5. REGISTRO Y DOCUMENTACIÓN ASOCIADA',
                      Icons.assignment,
                      const Color(0xFF2E7D32),
                      '• Registro de recepción de muestras\n'
                          '• Bitácora de % de humedad de muestras\n'
                          '• Reporte de mantenciones\n'
                          '• Bitácora de tipo de mineral (yampo, óxido, sulfuro, etc.)\n'
                          '• Reporte de mantenciones',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExpansionPanel _buildExpansionPanel(
    int index,
    String title,
    IconData icon,
    Color color,
    String content,
  ) {
    return ExpansionPanel(
      headerBuilder:
          (context, isExpanded) => ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2C2C),
              ),
            ),
            onTap: () {
              setState(() {
                _expanded[index] = !_expanded[index];
              });
            },
          ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          content,
          style: const TextStyle(color: Color(0xFF2C2C2C), height: 1.5),
          textAlign: TextAlign.left,
        ),
      ),
      isExpanded: _expanded[index],
      canTapOnHeader: true,
    );
  }
}
