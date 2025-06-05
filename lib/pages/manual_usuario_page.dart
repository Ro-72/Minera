import 'package:flutter/material.dart';

class ManualUsuarioPage extends StatefulWidget {
  const ManualUsuarioPage({super.key});

  @override
  State<ManualUsuarioPage> createState() => _ManualUsuarioPageState();
}

class _ManualUsuarioPageState extends State<ManualUsuarioPage> {
  List<bool> _expanded = [true, true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Manual de Usuario'),
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
                // Header con información del manual
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
                        Icon(Icons.book, size: 48, color: Color(0xFFD4AF37)),
                        SizedBox(height: 12),
                        Text(
                          'Manual de Usuario',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sistema de Gestión Minera - Guía de Uso',
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
                      '1. INTRODUCCIÓN AL SISTEMA',
                      Icons.info,
                      const Color(0xFFD4AF37),
                      'El Sistema de Gestión Minera es una aplicación diseñada para el control integral de muestras y procesos en operaciones mineras.\n\n'
                          'Características principales:\n'
                          '• Control de tiempo de procesamiento de muestras\n'
                          '• Gestión de reportes de análisis\n'
                          '• Consulta de procedimientos de trabajo seguro (PETS)\n'
                          '• Cálculos metalúrgicos especializados\n'
                          '• Sistema de autenticación y roles de usuario\n'
                          '• Exportación de datos para análisis\n\n'
                          'La aplicación está optimizada para dispositivos móviles y tablets, permitiendo el uso en campo y laboratorio.',
                    ),
                    _buildExpansionPanel(
                      1,
                      '2. AUTENTICACIÓN Y ROLES DE USUARIO',
                      Icons.security,
                      const Color(0xFF8B7355),
                      'SISTEMA DE AUTENTICACIÓN:\n'
                          'Para acceder a las funcionalidades completas del sistema, es necesario crear una cuenta e iniciar sesión.\n\n'
                          'ROLES DISPONIBLES:\n'
                          '• Operador: Acceso básico a funciones generales\n'
                          '• Supervisor: Permisos de supervisión y seguimiento\n'
                          '• Analista: Acceso a herramientas de análisis\n'
                          '• Jefe de Laboratorio: Acceso completo al control de muestras y exportación de datos\n'
                          '• Gerente: Supervisión general del sistema\n'
                          '• Administrador: Control total del sistema\n\n'
                          'IMPORTANTE: Algunas funciones están restringidas según el rol del usuario. El acceso al "Control de Muestras" requiere específicamente el rol de "Jefe de Laboratorio".',
                    ),
                    _buildExpansionPanel(
                      2,
                      '3. NAVEGACIÓN PRINCIPAL',
                      Icons.navigation,
                      const Color(0xFF6B4423),
                      'PANTALLA DE INICIO:\n'
                          '• Muestra el estado de autenticación del usuario\n'
                          '• Información del perfil y rol asignado\n'
                          '• Recomendaciones para acceder al sistema\n\n'
                          'BARRA DE NAVEGACIÓN INFERIOR:\n'
                          '• Inicio: Pantalla principal con información del sistema\n'
                          '• Reportes: Gestión y creación de reportes de análisis\n'
                          '• Cálculos: Herramientas de cálculos metalúrgicos\n'
                          '• PETS: Consulta de procedimientos de trabajo seguro\n\n'
                          'MENÚ LATERAL (DRAWER):\n'
                          '• Control de Muestras: Gestión avanzada de muestras\n'
                          '• Notificaciones: Alertas y mensajes del sistema\n'
                          '• Perfil de Usuario: Información personal y configuración\n'
                          '• Configuración/Ayuda: Ajustes y soporte técnico',
                    ),
                    _buildExpansionPanel(
                      3,
                      '4. MÓDULO DE REPORTES (REQUIERE AUTENTICACIÓN)',
                      Icons.bar_chart,
                      const Color(0xFF4A4A4A),
                      'ACCESO:\n'
                          '⚠️ REQUIERE: Usuario autenticado (cualquier rol)\n\n'
                          'FUNCIONALIDADES:\n'
                          '• Registro de código y tipo de muestra con autocompletado\n'
                          '• Control de tiempo de procesamiento (inicio/fin)\n'
                          '• Cálculo automático de duración de procesamiento\n'
                          '• Guardado automático en base de datos al terminar proceso\n'
                          '• Validación de datos antes de guardar\n\n'
                          'TIPOS DE MUESTRA DISPONIBLES:\n'
                          '• Mineral\n'
                          '• Concentrado\n'
                          '• Relave\n'
                          '• Solución\n'
                          '• Agua\n'
                          '• Pulpa\n\n'
                          'INFORMACIÓN GUARDADA:\n'
                          '• Código y tipo de muestra\n'
                          '• Tiempos de inicio y finalización\n'
                          '• Duración total del procesamiento\n'
                          '• Datos del usuario que realizó el reporte',
                    ),
                    _buildExpansionPanel(
                      4,
                      '5. CONTROL DE MUESTRAS (SOLO JEFE DE LABORATORIO)',
                      Icons.science,
                      const Color(0xFF2E7D32),
                      'ACCESO RESTRINGIDO:\n'
                          '⚠️ REQUIERE: Usuario autenticado con rol "Jefe de Laboratorio"\n\n'
                          'FUNCIONALIDADES PRINCIPALES:\n'
                          '• Vista completa de todos los reportes del sistema\n'
                          '• Información detallada de cada muestra procesada\n'
                          '• Datos completos del usuario que realizó cada reporte\n'
                          '• Exportación de datos a archivo CSV\n'
                          '• Búsqueda y filtrado de reportes\n\n'
                          'INFORMACIÓN DISPONIBLE:\n'
                          '• Código y tipo de muestra\n'
                          '• Duración de procesamiento\n'
                          '• Fechas y horas de inicio/finalización\n'
                          '• Nombre, email y rol del usuario responsable\n'
                          '• ID único del reporte\n\n'
                          'EXPORTACIÓN:\n'
                          '• Formato CSV compatible con Excel\n'
                          '• Descarga automática en carpeta de descargas\n'
                          '• Incluye todos los datos de los reportes',
                    ),
                    _buildExpansionPanel(
                      5,
                      '6. OTRAS FUNCIONALIDADES',
                      Icons.apps,
                      const Color(0xFF7B1FA2),
                      'CÁLCULOS METALÚRGICOS:\n'
                          '• Herramientas especializadas para cálculos mineros\n'
                          '• Acceso libre sin restricciones\n\n'
                          'CONSULTAR PETS:\n'
                          '• Procedimientos escritos de trabajo seguro\n'
                          '• Información sobre preparación de muestras\n'
                          '• Equipos de protección personal requeridos\n'
                          '• Acceso libre para consulta\n\n'
                          'PERFIL DE USUARIO:\n'
                          '• Visualización de datos personales\n'
                          '• Información del rol asignado\n'
                          '• Fecha de registro en el sistema\n'
                          '• Opción para cerrar sesión\n\n'
                          'CONFIGURACIÓN Y AYUDA:\n'
                          '• Ajustes generales de la aplicación\n'
                          '• Información de contacto para soporte\n'
                          '• Preguntas frecuentes\n\n'
                          'NOTIFICACIONES:\n'
                          '• Sistema de alertas y mensajes\n'
                          '• Recordatorios importantes\n'
                          '• Actualizaciones del sistema',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Footer con información adicional
                Card(
                  elevation: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Información Importante',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Mantenga siempre actualizada su información de perfil\n'
                          '• Cierre sesión al finalizar el uso en dispositivos compartidos\n'
                          '• Contacte al administrador para cambios de rol\n'
                          '• Los reportes se guardan automáticamente en la base de datos\n'
                          '• El sistema requiere conexión a internet para funcionar completamente',
                          style: TextStyle(
                            color: Color(0xFF2C2C2C),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
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
