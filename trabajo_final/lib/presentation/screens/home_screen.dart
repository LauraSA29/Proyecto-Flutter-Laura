import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_bloc.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_evento.dart';
import 'package:trabajo_final/presentation/blocs/product/producto_estado.dart';
import 'package:trabajo_final/presentation/widgets/producto_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'shopping_cart.dart';
import 'profile.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _selectedIndex = 0;

  final List<Widget> _pantallas = [
    const _PantallaHome(),
    const PantallaCarrito(),
    const PantallaPerfil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B6CF6), Color(0xFFE96FFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconSize: 30,
          selectedFontSize: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }
}

class _PantallaHome extends StatelessWidget {
  const _PantallaHome();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductoBloc()..add(CargarProductos()),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          title: const Text(
            "¡ENCUENTRA TU PRENDA DE ROPA IDEAL!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B6CF6), Color(0xFFE96FFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            Positioned(
              top: -40,
              left: -50,
              child: Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFFBBA8FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 200,
              right: -70,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3B7FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: 30,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xFFD5C4FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 140,
              right: 30,
              child: Transform.rotate(
                angle: 0.4,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3B7FF).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar ropa...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CategoriaItem(icono: MdiIcons.tshirtCrew, etiqueta: "Camisas"),
                        _CategoriaItem(icono: MdiIcons.hanger, etiqueta: "Pantalones"),
                        _CategoriaItem(icono: MdiIcons.shoeSneaker, etiqueta: "Zapatos"),
                        _CategoriaItem(icono: MdiIcons.bagPersonal, etiqueta: "Bolsos"),
                        _CategoriaItem(icono: MdiIcons.hatFedora, etiqueta: "Sombreros"),
                        _CategoriaItem(icono: MdiIcons.watch, etiqueta: "Accesorios"),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Recomendados para ti",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    BlocBuilder<ProductoBloc, ProductoEstado>(
                      builder: (context, state) {
                        if (state is ProductoCarga) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ProductoCargado) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: state.productos.length,
                            itemBuilder: (context, index) {
                              return ProductoCard(producto: state.productos[index]);
                            },
                          );
                        } else if (state is ProductoError) {
                          return Text(state.msg);
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _CategoriaItem extends StatefulWidget {
  final IconData icono;
  final String etiqueta;
  final VoidCallback? onTap;

  const _CategoriaItem({
    required this.icono,
    required this.etiqueta,
    this.onTap,
  });

  @override
  State<_CategoriaItem> createState() => _CategoriaItemState();
}

class _CategoriaItemState extends State<_CategoriaItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.onTap,
            child: AnimatedScale(
              scale: _isPressed ? 0.93 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: const Color(0xFF7B6CF6).withOpacity(0.2),
                  highlightColor: const Color(0xFFE96FFF).withOpacity(0.1),
                  onTap: widget.onTap,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: Icon(widget.icono, size: 30, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.etiqueta,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
