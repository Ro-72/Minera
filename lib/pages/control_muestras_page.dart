import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'auth_page.dart';

class ControlMuestrasPage extends StatefulWidget {
  const ControlMuestrasPage({super.key});

  @override
  State<ControlMuestrasPage> createState() => _ControlMuestrasPageState();
}

class _ControlMuestrasPageState extends State<ControlMuestrasPage> {
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
          // * User is authenticated - show control content
          return const ControlMuestrasContent();
        } else {
          // ! User not authenticated - show access restriction screen
          return const ControlMuestrasAuthRequired();
        }
      },
    );
  }
}

class ControlMuestrasAuthRequired extends StatelessWidget {
  const ControlMuestrasAuthRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.science, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Control de Muestras'),
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
                  'Para acceder al control de muestras es necesario iniciar sesión con una cuenta válida.',
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
                          'El control de muestras contiene información sensible que requiere autenticación.',
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

class ControlMuestrasContent extends StatefulWidget {
  const ControlMuestrasContent({super.key});

  @override
  State<ControlMuestrasContent> createState() => _ControlMuestrasContentState();
}

class _ControlMuestrasContentState extends State<ControlMuestrasContent> {
  // * Current user instance
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // * User role verification
  String? _userRole;
  bool _isLoading = true;
  bool _hasAccess = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _checkUserAccess();
  }

  // * Check if user has required role access
  Future<void> _checkUserAccess() async {
    if (_currentUser == null) {
      setState(() {
        _isLoading = false;
        _hasAccess = false;
      });
      return;
    }

    try {
      // ? Get user data from Firestore to check role
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser!.uid)
              .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _userRole = userData['role'] ?? 'No especificado';

        // ! Only "Jefe de Laboratorio" role can access this page
        setState(() {
          _hasAccess = _userRole == 'Jefe de Laboratorio';
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasAccess = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasAccess = false;
        _isLoading = false;
      });
    }
  }

  // * Export reports to CSV (simpler alternative to Excel)
  Future<void> _exportToCSV() async {
    setState(() {
      _isExporting = true;
    });

    try {
      // * Get all reports from Firestore
      QuerySnapshot reportsSnapshot =
          await FirebaseFirestore.instance
              .collection('reports')
              .orderBy('createdAt', descending: true)
              .get();

      // * Create CSV content
      StringBuffer csvContent = StringBuffer();

      // * Add headers
      List<String> headers = [
        'Código de Muestra',
        'Tipo de Muestra',
        'Duración de Procesamiento',
        'Fecha del Reporte',
        'Hora de Inicio',
        'Hora de Finalización',
        'Nombre del Usuario',
        'Email del Usuario',
        'Rol del Usuario',
        'ID del Reporte',
      ];

      csvContent.writeln(headers.join(','));

      // * Add data rows
      for (var doc in reportsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> userInfo =
            data['userInfo'] as Map<String, dynamic>? ?? {};

        List<String> rowData = [
          '"${data['sampleCode'] ?? 'N/A'}"',
          '"${data['sampleType'] ?? 'N/A'}"',
          '"${data['processingDuration'] ?? 'N/A'}"',
          '"${_formatTimestamp(data['reportDate'])}"',
          '"${_formatTimestamp(data['startTime'])}"',
          '"${_formatTimestamp(data['endTime'])}"',
          '"${userInfo['name'] ?? 'N/A'}"',
          '"${userInfo['email'] ?? 'N/A'}"',
          '"${userInfo['role'] ?? 'N/A'}"',
          '"${doc.id}"',
        ];

        csvContent.writeln(rowData.join(','));
      }

      // * Save file to Downloads directory
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
        if (!downloadsDirectory.existsSync()) {
          downloadsDirectory = await getExternalStorageDirectory();
        }
      } else {
        downloadsDirectory = await getDownloadsDirectory();
      }

      String fileName =
          'reportes_muestras_${DateTime.now().millisecondsSinceEpoch}.csv';
      String filePath = '${downloadsDirectory!.path}/$fileName';

      File file = File(filePath);
      await file.writeAsString(csvContent.toString(), encoding: utf8);

      // * Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Archivo CSV exportado: $fileName'),
            backgroundColor: const Color(0xFFD4AF37),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.science, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Control de Muestras'),
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
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : !_hasAccess
                ? _buildAccessDenied()
                : _buildReportsView(),
      ),
    );
  }

  // * Widget for users without required role
  Widget _buildAccessDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 80, color: Colors.red.shade400),
            const SizedBox(height: 24),
            Text(
              'Acceso Denegado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Solo los usuarios con rol "Jefe de Laboratorio" pueden acceder a esta sección.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Text(
                'Rol actual: ${_userRole ?? "No especificado"}',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // * Main reports view for authorized users
  Widget _buildReportsView() {
    return Column(
      children: [
        // * Header with statistics and export button
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Panel de Control - Jefe de Laboratorio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vista completa de todos los reportes del sistema',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // * Export button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isExporting ? null : _exportToCSV,
                  icon:
                      _isExporting
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Icon(Icons.file_download),
                  label: Text(
                    _isExporting ? 'Exportando...' : 'Exportar a CSV',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFD4AF37),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // * Reports list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('reports')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar reportes',
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No hay reportes disponibles',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return _buildReportCard(doc.id, data);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // * Individual report card widget
  Widget _buildReportCard(String reportId, Map<String, dynamic> data) {
    final userInfo = data['userInfo'] as Map<String, dynamic>? ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.description, color: Colors.white, size: 20),
        ),
        title: Text(
          '${data['sampleCode']} - ${data['sampleType']}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2C2C),
          ),
        ),
        subtitle: Text(
          'Usuario: ${userInfo['name'] ?? 'Desconocido'} | '
          'Duración: ${data['processingDuration'] ?? 'N/A'}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  'Código de Muestra:',
                  data['sampleCode'] ?? 'N/A',
                ),
                _buildDetailRow(
                  'Tipo de Muestra:',
                  data['sampleType'] ?? 'N/A',
                ),
                _buildDetailRow(
                  'Duración de Procesamiento:',
                  data['processingDuration'] ?? 'N/A',
                ),
                _buildDetailRow(
                  'Fecha del Reporte:',
                  _formatTimestamp(data['reportDate']),
                ),
                _buildDetailRow(
                  'Hora de Inicio:',
                  _formatTimestamp(data['startTime']),
                ),
                _buildDetailRow(
                  'Hora de Finalización:',
                  _formatTimestamp(data['endTime']),
                ),

                const SizedBox(height: 12),
                const Text(
                  'Información del Usuario:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Nombre:', userInfo['name'] ?? 'N/A'),
                _buildDetailRow('Email:', userInfo['email'] ?? 'N/A'),
                _buildDetailRow('Rol:', userInfo['role'] ?? 'N/A'),
                _buildDetailRow('ID de Usuario:', userInfo['uid'] ?? 'N/A'),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fingerprint,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ID del Reporte: $reportId',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // * Helper widget for detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF8B7355),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF2C2C2C)),
            ),
          ),
        ],
      ),
    );
  }

  // * Format timestamp for display
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    try {
      if (timestamp is Timestamp) {
        DateTime date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year} '
            '${date.hour.toString().padLeft(2, '0')}:'
            '${date.minute.toString().padLeft(2, '0')}:'
            '${date.second.toString().padLeft(2, '0')}';
      }
      return 'N/A';
    } catch (e) {
      return 'N/A';
    }
  }
}
