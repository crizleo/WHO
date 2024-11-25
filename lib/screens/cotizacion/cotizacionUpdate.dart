import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';

class CotizacionUpdate extends StatefulWidget {
  final int cotizacionId;

  CotizacionUpdate({required this.cotizacionId});

  @override
  State<CotizacionUpdate> createState() => CotizacionUpdateState();
}

class CotizacionUpdateState extends State<CotizacionUpdate> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreClienteController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController ivaController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  Cotizacion? cotizacion;

  @override
  void initState() {
    super.initState();
    cargarCotizacion();
  }

  void cargarCotizacion() async {
    cotizacion = await firebaseService.readCotizacion(widget.cotizacionId);
    setState(() {
      codigoController.text = cotizacion?.codigo ?? '';
      nombreClienteController.text = cotizacion?.nombreCliente ?? '';
      fechaController.text = cotizacion?.fecha ?? '';
      ivaController.text = cotizacion?.iva.toString() ?? '';
      totalController.text = cotizacion?.total.toString() ?? '';
    });
  }

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
              primary: Colors.indigo[900]!, 
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo[900],
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
        title: Text(
          'Actualizar Cotización',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.indigo[900],
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
            SizedBox(height: 16),
            _buildInputField(
              controller: nombreClienteController,
              label: 'Nombre del Cliente',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
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
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: ivaController,
              label: 'IVA',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: totalController,
              label: 'Total',
              icon: Icons.payment,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("Actualizar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: actualizarCotizacion,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text("Eliminar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: eliminarCotizacion,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  void actualizarCotizacion() async {
    try {
      if (cotizacion != null) {
        // Convertir el String de fecha a DateTime
        DateTime fechaDateTime;
        try {
          fechaDateTime = dateFormat.parse(fechaController.text);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Formato de fecha inválido'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        cotizacion = Cotizacion(
          idCotizacion: widget.cotizacionId,
          idEstadoCoti: cotizacion!.idEstadoCoti,
          codigo: codigoController.text,
          nombreCliente: nombreClienteController.text,
          fecha: fechaController.text,
          iva: double.parse(ivaController.text),
          total: double.parse(totalController.text),
          imagen: cotizacion!.imagen,
        );

        await firebaseService.createOrUpdateCotizacion(cotizacion!);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la cotización: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void eliminarCotizacion() async {
    try {
      bool confirmar = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar eliminación'),
            content: Text('¿Está seguro que desea eliminar esta cotización?'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Eliminar'),
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          );
        },
      ) ?? false;

      if (confirmar) {
        await firebaseService.deleteCotizacion(widget.cotizacionId);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la cotización: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}