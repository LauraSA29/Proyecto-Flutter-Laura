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
  late final ProductoBloc _productoBloc;

  @override
  void initState() {
    super.initState();
    _productoBloc = ProductoBloc()..add(CargarProductos());
  }

  final List<Widget> _pantallas = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pantallas.clear();
    _pantallas.addAll([
      const _PantallaHome(),
      const PantallaCarrito(),
      const PantallaPerfil(),
    ]);
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productoBloc,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final inFromRight = Tween<Offset>(
              begin: const Offset(0.2, 0),
              end: Offset.zero,
            ).animate(animation);

            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return SlideTransition(
              position: inFromRight,
              child: FadeTransition(opacity: fade, child: child),
            );
          },
          child: _pantallas[_selectedIndex],
        ),
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
      ),
    );
  }
}

// 🔹 HOME PRINCIPAL
class _PantallaHome extends StatefulWidget {
  const _PantallaHome();

  @override
  State<_PantallaHome> createState() => _PantallaHomeState();
}

class _PantallaHomeState extends State<_PantallaHome> {
  String categoriaSeleccionada = "Todos";
  String busqueda = "";

  void _filtrar(BuildContext context, String categoria) {
    setState(() => categoriaSeleccionada = categoria);
    if (categoria == "Todos") {
      context.read<ProductoBloc>().add(CargarProductos());
    } else {
      context.read<ProductoBloc>().add(FiltrarProductosPorCategoria(categoria));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // 🔹 Fondo decorativo
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

          // 🔹 Contenido principal
          BlocBuilder<ProductoBloc, ProductoEstado>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Buscador
                      TextField(
                        onChanged: (valor) {
                          setState(() => busqueda = valor);
                          context
                              .read<ProductoBloc>()
                              .add(FiltrarProductosPorNombre(valor.trim()));
                        },
                        decoration: InputDecoration(
                          hintText: "Buscar ropa...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Categorías
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _CategoriaItem(
                              icono: Icons.all_inclusive,
                              etiqueta: "Todos",
                              seleccionado: categoriaSeleccionada == "Todos",
                              onTap: () => _filtrar(context, "Todos"),
                            ),
                            _CategoriaItem(
                              icono: MdiIcons.tshirtCrew,
                              etiqueta: "Camisas",
                              seleccionado: categoriaSeleccionada == "Camisas",
                              onTap: () => _filtrar(context, "Camisas"),
                            ),
                            _CategoriaItem(
                              icono: MdiIcons.hanger,
                              etiqueta: "Pantalones",
                              seleccionado:
                                  categoriaSeleccionada == "Pantalones",
                              onTap: () => _filtrar(context, "Pantalones"),
                            ),
                            _CategoriaItem(
                              icono: MdiIcons.shoeSneaker,
                              etiqueta: "Zapatos",
                              seleccionado: categoriaSeleccionada == "Zapatos",
                              onTap: () => _filtrar(context, "Zapatos"),
                            ),
                            _CategoriaItem(
                              icono: MdiIcons.bagPersonal,
                              etiqueta: "Bolsos",
                              seleccionado: categoriaSeleccionada == "Bolsos",
                              onTap: () => _filtrar(context, "Bolsos"),
                            ),
                            _CategoriaItem(
                              icono: MdiIcons.hatFedora,
                              etiqueta: "Sombreros",
                              seleccionado:
                                  categoriaSeleccionada == "Sombreros",
                              onTap: () => _filtrar(context, "Sombreros"),
                            ),
                            _CategoriaItem(
                              icono: MdiIcons.watch,
                              etiqueta: "Accesorios",
                              seleccionado:
                                  categoriaSeleccionada == "Accesorios",
                              onTap: () => _filtrar(context, "Accesorios"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      const Text(
                        "Recomendados para ti",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Productos
                      if (state is ProductoCarga)
                        const Center(child: CircularProgressIndicator())
                      else if (state is ProductoCargado)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: state.productos.length,
                          itemBuilder: (context, index) {
                            return ProductoCard(
                                producto: state.productos[index]);
                          },
                        )
                      else if (state is ProductoError)
                        Center(child: Text(state.msg))
                      else
                        const SizedBox(),
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
}

// 🔹 Widget de categoría con animación
class _CategoriaItem extends StatefulWidget {
  final IconData icono;
  final String etiqueta;
  final bool seleccionado;
  final VoidCallback? onTap;

  const _CategoriaItem({
    required this.icono,
    required this.etiqueta,
    this.onTap,
    this.seleccionado = false,
  });

  @override
  State<_CategoriaItem> createState() => _CategoriaItemState();
}

class _CategoriaItemState extends State<_CategoriaItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorSeleccionado =
        widget.seleccionado ? const Color(0xFF7B6CF6) : Colors.white;
    final bordeSeleccionado = widget.seleccionado
        ? const Color(0xFF7B6CF6)
        : Colors.grey.shade400;

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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: colorSeleccionado,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: bordeSeleccionado, width: 2),
                  boxShadow: widget.seleccionado
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7B6CF6).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                width: 60,
                height: 60,
                child: Icon(
                  widget.icono,
                  size: 30,
                  color:
                      widget.seleccionado ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.etiqueta,
            style: TextStyle(
              fontSize: 12,
              color:
                  widget.seleccionado ? const Color(0xFF7B6CF6) : Colors.black,
              fontWeight:
                  widget.seleccionado ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
