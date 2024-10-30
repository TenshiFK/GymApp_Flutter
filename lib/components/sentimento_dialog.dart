import "package:flutter/material.dart";
import "package:gymapp/models/sentimento_model.dart";
import "package:gymapp/services/sentimento_service.dart";
import "package:uuid/uuid.dart";

Future<dynamic> showSentimentoDialog(BuildContext context,
    {required String idExercicio, SentimentoModel? sentimentoModel}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController _sentimentoController = TextEditingController();

      if (sentimentoModel != null) {
        _sentimentoController.text = sentimentoModel.sentimento;
      }

      return AlertDialog(
        title: Text("Adicionar Sentimento:"),
        content: TextFormField(
          controller: _sentimentoController,
          decoration: InputDecoration(
            label: Text("Sentimento:"),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              SentimentoModel sentimento = SentimentoModel(
                id: Uuid().v1(),
                sentimento: _sentimentoController.text,
                data: DateTime.now().toString(),
              );

              if (sentimentoModel != null) {
                sentimento.id = sentimentoModel.id;
              }

              SentimentoService().addSentimento(
                  idExercicio: idExercicio, sentimentoModel: sentimento);

              Navigator.pop(context);
            },
            child: Text((sentimentoModel != null)
                ? "Editar sentimento"
                : "Criar sentimento"),
          ),
        ],
      );
    },
  );
}
