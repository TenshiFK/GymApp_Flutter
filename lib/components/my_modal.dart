import 'package:flutter/material.dart';
import 'package:gymapp/_comum/my_colors.dart';
import 'package:gymapp/components/decoration_forms.dart';
import 'package:gymapp/models/exercicio_model.dart';
import 'package:gymapp/models/sentimento_model.dart';
import 'package:gymapp/services/exercicio_service.dart';
import 'package:gymapp/services/sentimento_service.dart';
import 'package:uuid/uuid.dart';

showMyModal(BuildContext context, {ExercicioModel? exercicio}) {
  showModalBottomSheet(
    backgroundColor: MyColors.azulBaixoGradiente,
    isDismissible: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    context: context,
    builder: (context) {
      return ExercicioModal(
        exercicioModel: exercicio,
      );
    },
  );
}

class ExercicioModal extends StatefulWidget {
  final ExercicioModel? exercicioModel;
  const ExercicioModal({super.key, this.exercicioModel});

  @override
  State<ExercicioModal> createState() => _ExercicioModalState();
}

class _ExercicioModalState extends State<ExercicioModal> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _treinoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _sentimentoController = TextEditingController();

  bool isLoading = false;

  ExercicioService _exercicioService = ExercicioService();
  SentimentoService _sentimentoService = SentimentoService();

  @override
  void initState() {
    if (widget.exercicioModel != null) {
      _nomeController.text = widget.exercicioModel!.nome;
      _treinoController.text = widget.exercicioModel!.treino;
      _descricaoController.text = widget.exercicioModel!.descricao;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.exercicioModel != null)
                            ? "Editar ${widget.exercicioModel!.nome}"
                            : "Adicionar Exercício",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: MyColors.azulMaisEscuro),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: MyColors.azulMaisEscuro,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: MyColors.azulMaisEscuro,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration:
                          getAuthenticationInputDecoration("Nome do Exercício:",
                              icon: Icon(
                                Icons.edit_note,
                                color: MyColors.azulMaisEscuro,
                              )),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _treinoController,
                      decoration: getAuthenticationInputDecoration(
                          "Treino do Exercício:",
                          icon: Icon(
                            Icons.fitness_center,
                            color: MyColors.azulMaisEscuro,
                          )),
                    ),
                    Text(
                        "Exercícios pertencentes ao mesmo treino, devem ter o nome de treino igual!"),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: getAuthenticationInputDecoration(
                          "Descrição do Exercício:",
                          icon: Icon(
                            Icons.description,
                            color: MyColors.azulMaisEscuro,
                          )),
                      maxLines: null,
                    ),
                    Visibility(
                      visible: (widget.exercicioModel == null),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _sentimentoController,
                            decoration: getAuthenticationInputDecoration(
                                "O que você está sentido:",
                                icon: Icon(
                                  Icons.emoji_emotions,
                                  color: MyColors.azulMaisEscuro,
                                )),
                            maxLines: null,
                          ),
                          Text(
                              "O campo sentimento não precisa ser repondido nesse momento!"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                enviarForm();
              },
              child: (isLoading)
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                  : Text((widget.exercicioModel != null)
                      ? "Salvar edição"
                      : "Criar Exercício"),
            ),
          ],
        ),
      ),
    );
  }

  enviarForm() {
    setState(() {
      isLoading = true;
    });

    String nome = _nomeController.text;
    String treino = _treinoController.text;
    String descricao = _descricaoController.text;
    String sentimento = _sentimentoController.text;

    ExercicioModel exercicio = ExercicioModel(
        id: Uuid().v1(), nome: nome, treino: treino, descricao: descricao);

    if (widget.exercicioModel != null) {
      exercicio.id = widget.exercicioModel!.id;
    }

    _exercicioService.addExercicio(exercicio).then((value) {
      if (sentimento != "") {
        SentimentoModel sentimentoUsuario = SentimentoModel(
          id: Uuid().v1(),
          sentimento: sentimento,
          data: DateTime.now().toString(),
        );
        _sentimentoService
            .addSentimento(
          idExercicio: exercicio.id,
          sentimentoModel: sentimentoUsuario,
        )
            .then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
      }
    });
  }
}
