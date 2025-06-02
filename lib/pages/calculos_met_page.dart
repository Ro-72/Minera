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
      appBar: AppBar(title: const Text('Cálculos Metalúrgicos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // % de humedad
            const Text(
              '% de Humedad',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              'Fórmula: ((Peso inicial - Peso final) / Peso final) * 100',
            ),
            TextField(
              controller: pesoInicialController,
              decoration: const InputDecoration(labelText: 'Peso inicial'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: pesoFinalController,
              decoration: const InputDecoration(labelText: 'Peso final'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calcularHumedad,
              child: const Text('Calcular % de Humedad'),
            ),
            if (resultadoHumedad != null)
              Text('Resultado: ${resultadoHumedad!.toStringAsFixed(2)} %'),
            const Divider(height: 32),

            // Fuerza de cianuro
            const Text(
              'Fuerza de Cianuro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text('Fórmula: Gasto de solución de cianuro * factor'),
            TextField(
              controller: gastoSolucionController,
              decoration: const InputDecoration(
                labelText: 'Gasto de solución de cianuro',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: factorController,
              decoration: const InputDecoration(labelText: 'Factor'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calcularFuerzaCianuro,
              child: const Text('Calcular Fuerza de Cianuro'),
            ),
            if (resultadoFuerzaCianuro != null)
              Text('Resultado: ${resultadoFuerzaCianuro!.toStringAsFixed(4)}'),
            const Divider(height: 32),

            // % de cianuro
            const Text(
              '% de Cianuro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text(
              'Fórmula: (Fuerza de cianuro / 100) * volumen de muestra',
            ),
            TextField(
              controller: fuerzaCianuroController,
              decoration: const InputDecoration(labelText: 'Fuerza de cianuro'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: volumenMuestraController,
              decoration: const InputDecoration(
                labelText: 'Volumen de muestra',
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calcularPorcentajeCianuro,
              child: const Text('Calcular % de Cianuro'),
            ),
            if (resultadoPorcentajeCianuro != null)
              Text(
                'Resultado: ${resultadoPorcentajeCianuro!.toStringAsFixed(4)}',
              ),
          ],
        ),
      ),
    );
  }
}
