import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/_comum/my_colors.dart';
import 'package:gymapp/components/my_modal.dart';
import 'package:gymapp/components/inicio_lista.dart';
import 'package:gymapp/models/exercicio_model.dart';
import 'package:gymapp/services/auth.dart';
import 'package:gymapp/services/exercicio_service.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ExercicioService exercicioService = ExercicioService();
  bool isDrecescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Meus Exercícios",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isDrecescente = !isDrecescente;
                });
              },
              icon: Icon(
                Icons.sort_by_alpha,
                color: Colors.white,
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: MyColors.azulEscuro),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/6596121.png"),
              ),
              accountName: Text((widget.user.displayName != null)
                  ? widget.user.displayName!
                  : ""),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
              onTap: () {
                Auth().logoutUser();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showMyModal(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder(
          stream: exercicioService.streamExercicios(isDrecescente),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.docs.isNotEmpty) {
                List<ExercicioModel> listaExercicios = [];

                for (var doc in snapshot.data!.docs) {
                  listaExercicios.add(ExercicioModel.fromMap(doc.data()));
                }

                return ListView(
                  children: List.generate(
                    listaExercicios.length,
                    (index) {
                      ExercicioModel exercicioModel = listaExercicios[index];
                      return InicioLista(
                          exercicioModel: exercicioModel,
                          exercicioService: exercicioService);
                    },
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                        "Você ainda não possui nenhum exercício cadastrado, começe agora a cadastrar."),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
