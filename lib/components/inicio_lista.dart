import 'package:flutter/material.dart';
import 'package:gymapp/_comum/my_colors.dart';
import 'package:gymapp/models/exercicio_model.dart';
import 'package:gymapp/services/exercicio_service.dart';

import 'my_modal.dart';
import '../screens/exercicio_tela.dart';

class InicioLista extends StatelessWidget {
  final ExercicioModel exercicioModel;
  final ExercicioService exercicioService;
  const InicioLista(
      {super.key,
      required this.exercicioModel,
      required this.exercicioService});

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExercicioTela(
              exercicioModel: exercicioModel,
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withAlpha(100),
              spreadRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                  color: MyColors.azulEscuro,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                child: Center(
                  child: Text(
                    exercicioModel.treino,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          exercicioModel.nome,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.azulEscuro,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showMyModal(context, exercicio: exercicioModel);
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                showCloseIcon: true,
                                closeIconColor: Colors.white,
                                content: Text(
                                    "Deseja mesmo excluir ${exercicioModel.nome}?"),
                                action: SnackBarAction(
                                    label: "Excluir",
                                    textColor: Colors.white,
                                    onPressed: () {
                                      exercicioService.deleteExercicio(
                                          exercicioModel: exercicioModel);
                                    }),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          exercicioModel.descricao,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
