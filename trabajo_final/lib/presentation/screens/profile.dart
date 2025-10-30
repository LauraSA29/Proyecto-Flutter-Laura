import 'package:flutter/material.dart';
import 'package:trabajo_final/presentation/widgets/fondo_decorativo.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

//screen de perfil de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: FondoDecorativo(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              _buildProfilePhoto(),
              const SizedBox(height: 6),
              const Text(
                "Laura Salas", // Nombre de usuario (esto es fijo pero en una app real depende del usuario registrado)
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              const Text(
                "laurasalas@gmail.com", //correo de usuario
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),

              //Opciones del perfil
              _buildProfileOption(context, Icons.settings, "Configuración"),
              _buildProfileOption(context, Icons.shopping_bag, "Mis pedidos"),
              _buildProfileOption(context, Icons.favorite_border, "Favoritos"),
              _buildProfileOption(context, Icons.help_outline, "Ayuda"),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // appbar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "PERFIL DE USUARIO",
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
    );
  }

  // foto de perfil
  Widget _buildProfilePhoto() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF7B6CF6), Color(0xFFE96FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const CircleAvatar(
        radius: 90,
        backgroundImage: AssetImage("assets/img/foto.png"),
        backgroundColor: Colors.white,
      ),
    );
  }

  // opciones del perfil
  Widget _buildProfileOption(BuildContext context, IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF7B6CF6)),
          title: Text(
            texto,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("La opción '$texto' no está disponible aún."), //funionarian en cado real
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
