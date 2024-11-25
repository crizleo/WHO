import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:who/screens/cotizacion/seleccionarItem.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';
import '../../models/modelCotizacionItem.dart';
import '../../models/modelProducto.dart';

class CotizacionUpdate extends StatefulWidget {
  final String cotizacionId;

  CotizacionUpdate({required this.cotizacionId});

  @override
  State<CotizacionUpdate> createState() => CotizacionUpdateState();
}

class CotizacionUpdateState extends State<CotizacionUpdate> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreClienteController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  Cotizacion? cotizacion;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$');

  @override
  void initState() {
    super.initState();
    cargarCotizacion();
  }

  void cargarCotizacion() async {
  try {
    final cotizacionCargada = await firebaseService.readCotizacion(widget.cotizacionId);
    if (mounted) {
      setState(() {
        cotizacion = cotizacionCargada;
        codigoController.text = cotizacion?.codigo ?? '';
        nombreClienteController.text = cotizacion?.nombreCliente ?? '';
        fechaController.text = cotizacion?.fecha != null 
            ? dateFormat.format(cotizacion!.fecha)
            : '';
        cotizacion?.recalcularTotales();
      });
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar la cotización: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
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

  void _agregarProducto() async {
    // Aquí deberías implementar la selección de producto, por ejemplo:
    final Producto? producto = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectorProducto(), // Implementar esta vista
      ),
    );

    if (producto != null && cotizacion != null) {
      setState(() {
        final item = CotizacionItem(
          producto: producto,
          cantidad: 1,
          subtotal: producto.precio,
        );
        cotizacion!.items.add(item);
        cotizacion!.recalcularTotales();
      });
    }
  }

  void _actualizarCantidad(int index, int nuevaCantidad) {
    if (cotizacion != null && nuevaCantidad >= 0) {
      setState(() {
        cotizacion!.items[index].cantidad = nuevaCantidad;
        cotizacion!.items[index].subtotal = 
            cotizacion!.items[index].producto.precio * nuevaCantidad;
        cotizacion!.recalcularTotales();
      });
    }
  }

  void _eliminarItem(int index) {
    if (cotizacion != null) {
      setState(() {
        cotizacion!.items.removeAt(index);
        cotizacion!.recalcularTotales();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Actualizar Cotización',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 24),
            _buildProductosSection(),
            const SizedBox(height: 24),
            _buildTotalesSection(),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarProducto,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
              onTap: () => _selectDate(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductosSection() {
    if (cotizacion == null) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cotizacion!.items.length,
            itemBuilder: (context, index) {
              final item = cotizacion!.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Imagen del producto
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item.producto.imagen),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Información del producto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.producto.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currencyFormat.format(item.producto.precio),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Control de cantidad
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _actualizarCantidad(
                              index,
                              item.cantidad - 1,
                            ),
                          ),
                          Text(item.cantidad.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _actualizarCantidad(
                              index,
                              item.cantidad + 1,
                            ),
                          ),
                        ],
                      ),
                      // Subtotal y botón eliminar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormat.format(item.subtotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarItem(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalesSection() {
    if (cotizacion == null) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', cotizacion!.subtotal),
            const SizedBox(height: 8),
            _buildTotalRow(
              'IVA (${cotizacion!.iva}%)',
              cotizacion!.total - cotizacion!.subtotal,
            ),
            const Divider(),
            _buildTotalRow('Total', cotizacion!.total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
        Text(
          currencyFormat.format(value),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Actualizar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: actualizarCotizacion,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text("Eliminar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: eliminarCotizacion,
          ),
        ),
      ],
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
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  void actualizarCotizacion() async {
    try {
      if (cotizacion != null) {
        DateTime fechaDateTime;
        try {
          fechaDateTime = dateFormat.parse(fechaController.text);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Formato de fecha inválido'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        cotizacion!.codigo = codigoController.text;
        cotizacion!.nombreCliente = nombreClienteController.text;
        cotizacion!.fecha = fechaDateTime;
        cotizacion!.iva = 19;
        cotizacion!.recalcularTotales();

        await firebaseService.createOrUpdateCotizacion(cotizacion!);
        Navigator.pop(context);
      }
    } catch (e) {
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
            title: const Text('Confirmar eliminación'),
            content: const Text('¿Está seguro que desea eliminar esta cotización?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Eliminar'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la cotización: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
