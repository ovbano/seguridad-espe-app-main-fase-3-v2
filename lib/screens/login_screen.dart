import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_maps_adv/widgets/logo_login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  static const String loginroute = 'login';

  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  color: const Color(
                      0xFF1F5545), // Color de fondo verde con código hexadecimal
                  padding: const EdgeInsets.all(
                      20.0), // Espacio interno del contenedor
                  height: 80, // Altura del contenedor
                  width: double.infinity, // Espacio interno del contenedor
                  child: const Text(
                    'Inicio de Sesión',
                    textAlign: TextAlign.center,
                    // Centrar el texto horizontalmente
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white, // Colors del texto
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 42, right: 42, top: 20), // Cambio en los márgenes
                  height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/Logo_iniciodesesion.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                      ),
                      SizedBox(height: 25),
                      _From(),
                      Labels(
                        ruta: 'register',
                        text: "¿No tienes cuenta?",
                        text2: "Crea una",
                      ),
                      SizedBox(height: 230),
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

class _From extends StatefulWidget {
  const _From();

  @override
  State<_From> createState() => __FromState();
}

class __FromState extends State<_From> {
  //provider

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final roomBloc = BlocProvider.of<RoomBloc>(context);
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    return Column(children: [
      CustonInput(
        icon: Icons.mail_outline,
        placeholder: "Email",
        keyboardType: TextInputType.emailAddress,
        textController: emailController,
      ),

      CustonInput(
        icon: Icons.lock_outline,
        placeholder: "Password",
        textController: passwordController,
        isPassword: true,
      ),
      const SizedBox(height: 15),
      BotonForm(
        text: "Continuar",
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            final result = await authBloc.login(
                emailController.text, passwordController.text);
            if (result) {
              await roomBloc.salasInitEvent();
              await publicationBloc.getAllPublicaciones();
              Navigator.pushReplacementNamed(
                  context, LoadingLoginScreen.loadingroute);
            } else {
              // ignore: use_build_context_synchronously
              mostrarAlerta(context, "Login incorrecto",
                  "Revise sus credenciales nuevamente");
            }
          } else {
            // Si los campos están vacíos, muestra una alerta o realiza alguna otra acción apropiada.
            mostrarAlerta(context, "Campos vacíos",
                "Por favor, complete todos los campos");
          }
        },
      ),
      //----or----
      const SizedBox(height: 10),
      const Text("O continue con"),
      const SizedBox(height: 10),
      BotonForm(
        text: "Google",
        onPressed: () async {
          try {
            FocusScope.of(context).unfocus();
            final result = await authBloc.signInWithGoogle();
            if (result) {
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(
                  context, LoadingLoginScreen.loadingroute);
            }
          } catch (e) {
            print(e);
          }
        },
      ),
      const SizedBox(height: 15),
      //cerrar sesion
    ]);
  }
}
