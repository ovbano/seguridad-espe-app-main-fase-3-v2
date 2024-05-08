import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/blocs/room/room_bloc.dart';
import 'package:flutter_maps_adv/helpers/page_route.dart';
import 'package:flutter_maps_adv/models/sales_response.dart';
import 'package:flutter_maps_adv/screens/chatsales_screen.dart';
import 'package:flutter_maps_adv/screens/code_add_sreen.dart';
import 'package:flutter_maps_adv/screens/code_create_sreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomsScreen extends StatelessWidget {
  static const String salasroute = 'salas';
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roonBloc = BlocProvider.of<RoomBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Color.fromARGB(221, 255, 255, 255)),
        centerTitle: false,
        backgroundColor: const Color(0xFF1F5545),
        title: const Text('Grupos',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
        elevation: 0.5,
        actions: const [IconModal()],
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1F5545),
              ),
            );
          }
          if (state.salas.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  //svg image de grupo
                  SvgPicture.asset(
                    'assets/info/charicons.svg',
                    width: 200,
                    height: 250,
                  ),
                  const Text('!Más seguro en grupo!',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      'Cree o únase a un grupo para que puedas estar informado de lo que reportan tus amigos y familiares.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  MaterialButton(
                    //todo el ancho posible
                    minWidth: MediaQuery.of(context).size.width * 0.95,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          CreateRoute.createRoute(CodigoAddGrupoScreen()));
                    },
                    color: Colors.white,
                    textColor: Colors.black87,
                    elevation: 5,
                    child: const Text(
                        'Unirse a un grupo'), // Aumenta la elevación del botón
                  ),
                  //Material boton para crear un grupo
                  MaterialButton(
                    //todo el ancho posible
                    minWidth: MediaQuery.of(context).size.width * 0.95,
                    //borde redondeado
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      Navigator.of(context).push(CreateRoute.createRoute(
                          const CodigoCreateGrupoScreen()));
                    },
                    color: const Color(0xFF6165FA),
                    textColor: Colors.white,
                    elevation: 5,
                    child: const Text('Crear un grupo'),
                  ),
                ],
              ),
            );
          }

          return Container(
            color: Colors.white,
            child: RefreshIndicator(
              onRefresh: () async {
                roonBloc.salasInitEvent();
              },
              color: const Color(0xFF6165FA),
              child: Column(
                children: [
                  //Si esta cargando un pequeño circulo de carga
                  // if (state.isLoading)
                  //   const Padding(
                  //     padding: EdgeInsets.only(top: 10),
                  //     child: SizedBox(
                  //       height: 3,
                  //       child: LinearProgressIndicator(
                  //         color: Color(0xFF6165FA),
                  //       ),
                  //     ),
                  //   ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 13),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.pushNamed(context,
                                  CodigoCreateGrupoScreen.codigoGruporoute);
                            },
                            child: const Row(
                              children: [
                                //icon de add grupo
                                Icon(
                                  FontAwesomeIcons.plus,
                                  color: Color(0xFF1F5545),
                                  size: 20,
                                ),

                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  'Crear un nuevo grupo',
                                  style: TextStyle(
                                      color: Color(0xFF1F5545), fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.salas.length,
                            itemBuilder: (context, index) {
                              return SalaListTitle(sala: state.salas[index]);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SalaListTitle extends StatelessWidget {
  final Sala sala;
  const SalaListTitle({super.key, required this.sala});

  @override
  Widget build(BuildContext context) {
    final salasService = BlocProvider.of<RoomBloc>(context);
    final membersBloc = BlocProvider.of<MembersBloc>(context);
    return ListTile(
      title: Text(sala.nombre),
      //total mensaje no leidos
      trailing: sala.mensajesNoLeidos == 0 || sala.mensajesNoLeidos == null
          ? const SizedBox()
          : Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red[500],
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Center(
                child: Text(
                  sala.mensajesNoLeidos.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
      subtitle: Text('${sala.totalUsuarios} miembros'),

      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(
                  '0xFF${sala.color.substring(0, 2)}DDBB${sala.color.substring(4)}')),
              Color(int.parse('0xFF${sala.color}')),
              const Color.fromARGB(255, 230, 116, 226),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            sala.nombre.substring(0, 2),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: () {
        print("sala seleccionada ${sala.nombre}");
        membersBloc.add(ChatInitEvent());
        salasService.add(SalaSelectEvent(sala));
        salasService.add(ResetTotalMensajesNoLeidosEvent(sala.uid));
        Navigator.of(context).push(CreateRoute.createRoute(const ChatScreen()));
      },
    );
  }
}

class IconModal extends StatelessWidget {
  const IconModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
          //boton de los tres puntos
          Icons.more_vert,
          color: Color.fromARGB(255, 255, 255, 255)),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              height: 120.0,
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                      ),
                      title: const Text('Crear un nuevo grupo'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, CodigoCreateGrupoScreen.codigoGruporoute);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.userGroup,
                        color: Colors.black,
                      ),
                      title: const Text('Unir a un grupo'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, CodigoAddGrupoScreen.codigoAddGruporoute);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
