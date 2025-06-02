import 'package:flutter/material.dart';

class CalculosMetPage extends StatefulWidget {
  const CalculosMetPage({super.key});

  @override
  State<CalculosMetPage> createState() => _CalculosMetPageState();
}

class _CalculosMetPageState extends State<CalculosMetPage> {
  // Controllers para las fórmulas
  final TextEditingController pesoInicialController = TextEditingController();
  final TextEditingController pesoFinalController = TextEditingController();
  double? resultadoHumedad;

  final TextEditingController gastoSolucionController = TextEditingController();
  final TextEditingController factorController = TextEditingController();
  double? resultadoFuerzaCianuro;

  final TextEditingController fuerzaCianuroController = TextEditingController();
  final TextEditingController volumenMuestraController =
      TextEditingController();
  double? resultadoPorcentajeCianuro;

  void calcularHumedad() {
    final double? pesoInicial = double.tryParse(pesoInicialController.text);
    final double? pesoFinal = double.tryParse(pesoFinalController.text);
    if (pesoInicial != null && pesoFinal != null && pesoFinal != 0) {
      setState(() {
        resultadoHumedad = ((pesoInicial - pesoFinal) / pesoFinal) * 100;
      });
    }
  }

  void calcularFuerzaCianuro() {
    final double? gastoSolucion = double.tryParse(gastoSolucionController.text);
    final double? factor = double.tryParse(factorController.text);
    if (gastoSolucion != null && factor != null) {
      setState(() {
        resultadoFuerzaCianuro = gastoSolucion * factor;
      });
    }
  }

  void calcularPorcentajeCianuro() {
    final double? fuerzaCianuro = double.tryParse(fuerzaCianuroController.text);
    final double? volumenMuestra = double.tryParse(
      volumenMuestraController.text,
    );
    if (fuerzaCianuro != null &&
        volumenMuestra != null &&
        volumenMuestra != 0) {
      setState(() {
        resultadoPorcentajeCianuro = (fuerzaCianuro / 100) * volumenMuestra;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.calculate, color: Color(0xFFD4AF37)),
            SizedBox(width: 8),
            Text('Cálculos Metalúrgicos'),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card para % de humedad
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Porcentaje de Humedad',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Fórmula: ((Peso inicial - Peso final) / Peso final) × 100',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pesoInicialController,
                        decoration: const InputDecoration(
                          labelText: 'Peso Inicial (g)',
                          prefixIcon: Icon(Icons.scale),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: pesoFinalController,
                        decoration: const InputDecoration(
                          labelText: 'Peso Final (g)',
                          prefixIcon: Icon(Icons.scale),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: calcularHumedad,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calcular % de Humedad'),
                        ),
                      ),
                      if (resultadoHumedad != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFD4AF37)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFFD4AF37),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Resultado: ${resultadoHumedad!.toStringAsFixed(2)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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

              const SizedBox(height: 16),

              // Card para Fuerza de cianuro
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B7355),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.science,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Fuerza de Cianuro',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Fórmula: Gasto de solución de cianuro × Factor',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: gastoSolucionController,
                        decoration: const InputDecoration(
                          labelText: 'Gasto de Solución de Cianuro',
                          prefixIcon: Icon(Icons.local_gas_station),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: factorController,
                        decoration: const InputDecoration(
                          labelText: 'Factor',
                          prefixIcon: Icon(Icons.functions),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: calcularFuerzaCianuro,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calcular Fuerza de Cianuro'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B7355),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      if (resultadoFuerzaCianuro != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B7355).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF8B7355)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF8B7355),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Resultado: ${resultadoFuerzaCianuro!.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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

              const SizedBox(height: 16),

              // Card para % de cianuro
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B4423),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.percent,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Porcentaje de Cianuro',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Fórmula: (Fuerza de cianuro / 100) × Volumen de muestra',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: fuerzaCianuroController,
                        decoration: const InputDecoration(
                          labelText: 'Fuerza de Cianuro',
                          prefixIcon: Icon(Icons.science),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: volumenMuestraController,
                        decoration: const InputDecoration(
                          labelText: 'Volumen de Muestra (ml)',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: calcularPorcentajeCianuro,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calcular % de Cianuro'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4423),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      if (resultadoPorcentajeCianuro != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B4423).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF6B4423)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF6B4423),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Resultado: ${resultadoPorcentajeCianuro!.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
}
