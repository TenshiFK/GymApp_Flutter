import 'package:flutter/material.dart';
import 'package:gymapp/_comum/my_colors.dart';
import 'package:gymapp/_comum/my_snack_bar.dart';
import 'package:gymapp/components/decoration_forms.dart';
import 'package:gymapp/services/auth.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool logar = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();

  Auth _authService = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [MyColors.azulGradiente, MyColors.azulBaixoGradiente],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/image.png",
                        height: 128,
                      ),
                      const Text(
                        "GymApp",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Visibility(
                          visible: !logar,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nomeController,
                                decoration:
                                    getAuthenticationInputDecoration("Nome:"),
                                validator: (value) {
                                  if (value == null) {
                                    return "O nome não deve estar vazio!";
                                  }
                                  if (value.length < 5) {
                                    return "Nome muito curto!";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getAuthenticationInputDecoration("E-mail:"),
                        validator: (value) {
                          if (value == null) {
                            return "O e-mail não deve estar vazio!";
                          }
                          if (value.length < 5) {
                            return "E-mail muito curto!";
                          }
                          if (!value.contains("@")) {
                            return "E-mail inválido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getAuthenticationInputDecoration("Senha:"),
                        obscureText: true,
                        validator: (value) {
                          if (value == null) {
                            return "A senha não deve estar vazia!";
                          }
                          if (value.length < 5) {
                            return "Senha muito curta!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // Visibility(
                      //     visible: !logar,
                      //     child: Column(
                      //       children: [
                      //         TextFormField(
                      //           decoration: getAuthenticationInputDecoration(
                      //               "Confirmar Senha:"),
                      //           obscureText: true,
                      //           validator: (value) {
                      //             if (value == null) {
                      //               return "A confirmação de senha não deve estar vazia!";
                      //             }
                      //             if (value.length < 5) {
                      //               return "Confirmação de senha muito curta!";
                      //             }
                      //             return null;
                      //           },
                      //         ),
                      //       ],
                      //     )),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            btnPrincipal();
                          },
                          child: Text((logar) ? "Entrar" : "Cadastrar")),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            logar = !logar;
                          });
                        },
                        child: Text((logar)
                            ? "Ainda não tem uma conta? Cadastre-se aqui!"
                            : "Já tem uma conta? Faça o login aqui!"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  btnPrincipal() {
    String nome = _nomeController.text;
    String senha = _senhaController.text;
    String email = _emailController.text;

    if (_formKey.currentState!.validate()) {
      if (logar) {
        print("Entrada validada");
        _authService
            .logarUser(senha: senha, email: email)
            .then((String? error) {
          if (error != null) {
            // ignore: use_build_context_synchronously
            showMySnackBar(context: context, text: error);
          }
        });
      } else {
        print("Cadastro validado");
        _authService
            .cadastrarUser(nome: nome, senha: senha, email: email)
            .then((String? error) {
          if (error != null) {
            // ignore: use_build_context_synchronously
            showMySnackBar(context: context, text: error);
          }
        });
      }
    } else {
      print("Form inválido");
    }
  }
}
