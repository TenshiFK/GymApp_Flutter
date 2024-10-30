import 'package:flutter/material.dart';

class MyColors {
  static const Color azulEscuro = Color(0xFF0A6D92);

  static const Color azulGradiente = Color(0xFF00ADFA);

  static const Color azulBaixoGradiente = Color(0xFFBFF9FF);

  static const Color azulMaisEscuro = Color.fromARGB(255, 7, 72, 96);

  static const int _azulgradientePrimayValue = 0xFF00ADFA;

  static const int _azulgradienteAccentValue = 0xFFEAF4FF;

  static const int _azulbaixogradientePrimaryValue = 0xFFBFF9FF;

  static const int _azulbaixogradienteAccentValue = 0XFFFFFFFF;

  static const int _azulescuroPrimaryValue = 0XFF0A6D92;

  static const int _azulescuroAccentValue = 0XFF60B8FF;

  static const MaterialColor azulTopoGradientePrimary =
      MaterialColor(_azulgradientePrimayValue, <int, Color>{
    50: Color(0XFFE0F5FE),
    100: Color(0XFFB3E6FE),
    200: Color(0XFF80D6FD),
    300: Color(0XFF4DC6FB),
    400: Color(0XFF26B9FB),
    500: Color(_azulgradientePrimayValue),
    600: Color(0XFF00A6F9),
    700: Color(0XFF009CF9),
    800: Color(0XFF0093F8),
    900: Color(0XFF0083F6),
  });

  static const MaterialColor azulTopoGradienteAccent =
      MaterialColor(_azulgradienteAccentValue, <int, Color>{
    100: Color(0XFFFFFFFF),
    200: Color(_azulgradienteAccentValue),
    400: Color(0XFFB7D9FF),
    700: Color(0XFF9DCCFF),
  });

  static const MaterialColor azulBaixoGradientePrimary =
      MaterialColor(_azulbaixogradientePrimaryValue, <int, Color>{
    50: Color(0XFFF7FEFF),
    100: Color(0XFFECFDFF),
    200: Color(0XFFDFFCFF),
    300: Color(0XFFD2FBFF),
    400: Color(0XFFC9FAFF),
    500: Color(_azulbaixogradientePrimaryValue),
    600: Color(0XFFB9F8FF),
    700: Color(0XFFB1F7FF),
    800: Color(0XFFA9F6FF),
    900: Color(0XFF9BF5FF),
  });

  static const MaterialColor azulBaixoGradienteAccent =
      MaterialColor(_azulbaixogradienteAccentValue, <int, Color>{
    100: Color(0XFFFFFFFF),
    200: Color(_azulbaixogradienteAccentValue),
    400: Color(0XFFFFFFFF),
    700: Color(0XFFFFFFFF),
  });

  static const MaterialColor azulEscuroPrimary =
      MaterialColor(_azulescuroPrimaryValue, <int, Color>{
    50: Color(0XFFE2EDF2),
    100: Color(0XFFB6D3DE),
    200: Color(0XFF85B6C9),
    300: Color(0XFF5499B3),
    400: Color(0XFF2F83A2),
    500: Color(_azulescuroPrimaryValue),
    600: Color(0XFF09658A),
    700: Color(0XFF07547F),
    800: Color(0XFF055075),
    900: Color(0XFF033E63),
  });

  static const MaterialColor azulEscuroAccent =
      MaterialColor(_azulescuroAccentValue, <int, Color>{
    100: Color(0XFF93cfff),
    200: Color(_azulescuroAccentValue),
    400: Color(0XFF2DA1FF),
    700: Color(0XFF1496FF),
  });
}
