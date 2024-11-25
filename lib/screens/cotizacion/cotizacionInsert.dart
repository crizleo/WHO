import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';

class CotizacionCreate extends StatefulWidget {
  @override
  State<CotizacionCreate> createState() => CotizacionCreateState();
}

class CotizacionCreateState extends State<CotizacionCreate> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreClienteController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate = fechaController.text.isNotEmpty 
          ? dateFormat.parse(fechaController.text)
          : DateTime.now();
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', ''),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        fechaController.text = dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Cotización',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(
              controller: codigoController,
              label: 'Código',
              icon: Icons.qr_code,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: nombreClienteController,
              label: 'Nombre del Cliente',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: fechaController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Fecha',
                hintText: 'DD/MM/YYYY',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: const Text("Agregar Cotización"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: agregarCotizacion,
            ),
          ],
        ),
      )
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(16),
      ),
    );
  }

  void agregarCotizacion() async {
  try {
    // Verificar que todos los campos requeridos estén llenos
    if (codigoController.text.isEmpty ||
        nombreClienteController.text.isEmpty ||
        fechaController.text.isEmpty
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convertir el String de fecha a DateTime
    DateTime fechaDateTime;
    try {
      // Si estás usando el DateFormat que definimos antes
      fechaDateTime = dateFormat.parse(fechaController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en el formato de la fecha'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Crear el objeto Cotizacion
    Cotizacion cotizacion = Cotizacion(
      idCotizacion: null,
      idEstadoCoti: 1,
      codigo: codigoController.text,
      nombreCliente: nombreClienteController.text,
      fecha: fechaDateTime,  // Usar el DateTime convertido
      iva: 19.0,
      total: 0.0
    );

    // Imprimir los valores para debug
    print('Fecha seleccionada: ${fechaDateTime.toString()}');
    print('Cotización a crear: ${cotizacion.toJson()}');

    await firebaseService.createOrUpdateCotizacion(cotizacion);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cotización creada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  } catch (e) {
    print('Error al crear la cotización: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al crear la cotización: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}