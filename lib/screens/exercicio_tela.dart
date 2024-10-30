import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/_comum/my_colors.dart';
import 'package:gymapp/components/sentimento_dialog.dart';
import 'package:gymapp/models/exercicio_model.dart';
import 'package:gymapp/models/sentimento_model.dart';
import 'package:gymapp/services/exercicio_service.dart';
import 'package:gymapp/services/sentimento_service.dart';
import 'package:image_picker/image_picker.dart';

class ExercicioTela extends StatefulWidget {
  final ExercicioModel exercicioModel;
  const ExercicioTela({super.key, required this.exercicioModel});

  @override
  State<ExercicioTela> createState() => _ExercicioTelaState();
}

class _ExercicioTelaState extends State<ExercicioTela> {
  final SentimentoService _sentimentoService = SentimentoService();
  bool isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.azulTopoGradientePrimary,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Column(
          children: [
            Text(
              "${widget.exercicioModel.nome}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            Text(
              "${widget.exercicioModel.treino}",
              style: TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSentimentoDialog(context, idExercicio: widget.exercicioModel.id);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
                height: 250,
                child: (isUploadingImage)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (widget.exercicioModel.urlImagem != null)
                        ? Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                    future: FirebaseStorage.instance
                                        .ref(widget.exercicioModel.urlImagem)
                                        .getDownloadURL(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return Image.network(
                                        snapshot.data!,
                                        alignment: Alignment.center,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }

                                          if (loadingProgress
                                                  .expectedTotalBytes !=
                                              null) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  child:
                                                      LinearProgressIndicator(),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      " ${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toStringAsFixed(2)}%"),
                                                )
                                              ],
                                            );
                                          }

                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                    },
                                  )),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      ExercicioService()
                                          .removeImage(widget.exercicioModel);
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.orange,
                                    )),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _uploadImage(context, isCamera: false);
                                  },
                                  child: const Text("Enviar Foto")),
                              ElevatedButton(
                                  onPressed: () {
                                    _uploadImage(context, isCamera: true);
                                  },
                                  child: const Text("Tirar Foto")),
                            ],
                          )),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Como fazer?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.exercicioModel.descricao),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Como estou me sentindo?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            StreamBuilder(
                stream: _sentimentoService.streamSentimentos(
                    idExercicio: widget.exercicioModel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      final List<SentimentoModel> listaSentimentos = [];

                      for (var doc in snapshot.data!.docs) {
                        listaSentimentos
                            .add(SentimentoModel.fromMap(doc.data()));
                      }

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(listaSentimentos.length, (index) {
                            SentimentoModel sentimentoAgora =
                                listaSentimentos[index];
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.double_arrow),
                              title: Text(sentimentoAgora.sentimento),
                              subtitle: Text(sentimentoAgora.data),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showSentimentoDialog(context,
                                            idExercicio:
                                                widget.exercicioModel.id,
                                            sentimentoModel: sentimentoAgora);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        _sentimentoService.deleteSentimento(
                                            idExercicio:
                                                widget.exercicioModel.id,
                                            idsentimento: sentimentoAgora.id);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            );
                          }));
                    } else {
                      return Text(
                          "Você ainda não tem um sentimento adicionado, começe agora a adicionar!");
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  void _uploadImage(BuildContext context, {required bool isCamera}) async {
    setState(() {
      isUploadingImage = true;
    });
    ImagePicker imagePicker = ImagePicker();

    XFile? image = await imagePicker.pickImage(
      source: (isCamera) ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 2000,
      maxWidth: 2000,
    );

    if (image != null) {
      File file = File(image.path);

      await FirebaseStorage.instance
          .ref(widget.exercicioModel.id + image.name)
          .putFile(file);

      String url = widget.exercicioModel.id + image.name;

      setState(() {
        widget.exercicioModel.urlImagem = url;
        ExercicioService().addExercicio(widget.exercicioModel);
      });
    } else {
      showNoImageSnackbar();
    }

    setState(() {
      isUploadingImage = false;
    });
  }

  showNoImageSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Nenhuma imagem selecionada"),
      ),
    );
  }
}
