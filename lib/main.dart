import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const NumericalCalculator());
}

class NumericalCalculator extends StatelessWidget {
  const NumericalCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numerical Differentiation Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _functionController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _stepController = TextEditingController();

  String _result = "";
  String _method = "forward"; // default method

  double evaluateFunction(String expression, double xValue) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression.replaceAll("^", " ^ "));
      ContextModel cm = ContextModel()..bindVariable(Variable('x'), Number(xValue));
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      return double.nan;
    }
  }

  void calculate() {
    String function = _functionController.text.trim();
    double x0 = double.tryParse(_pointController.text) ?? 0.0;
    double h = double.tryParse(_stepController.text) ?? 0.1;

    double derivative;

    if (_method == "forward") {
      derivative = (evaluateFunction(function, x0 + h) - evaluateFunction(function, x0)) / h;
    } else {
      derivative = (evaluateFunction(function, x0 + h) - evaluateFunction(function, x0 - h)) / (2 * h);
    }

    setState(() {
      _result = "f'($x0) ≈ ${derivative.toStringAsFixed(6)} using $_method difference";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Numerical Differentiation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _functionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter function f(x) (e.g. x^2+3*x+2)",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pointController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter point x0",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter step size h",
              ),
            ),
            const SizedBox(height: 20),

            // Radio Buttons for Method
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Forward"),
                    value: "forward",
                    groupValue: _method,
                    onChanged: (value) {
                      setState(() => _method = value.toString());
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Central"),
                    value: "central",
                    groupValue: _method,
                    onChanged: (value) {
                      setState(() => _method = value.toString());
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculate,
              child: const Text("Calculate"),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
