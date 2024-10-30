import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/_comum/my_colors.dart';
import 'package:gymapp/screens/autenticacao_tela.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymapp/screens/home.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: MyColors.azulEscuroPrimary,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: MyColors.azulEscuroPrimary,
            foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              foregroundColor:
                  WidgetStatePropertyAll<Color>(MyColors.azulMaisEscuro)),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: MyColors.azulEscuro,
          elevation: 0,
          toolbarHeight: 72,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
        ),
        useMaterial3: true,
      ),
      home: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [MyColors.azulGradiente, MyColors.azulBaixoGradiente],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
        RouterScreens(),
      ]),
    );
  }
}

class RouterScreens extends StatelessWidget {
  const RouterScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Home(
            user: snapshot.data!,
          );
        } else {
          return AutenticacaoTela();
        }
      },
    );
  }
}
