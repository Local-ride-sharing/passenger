import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle overline(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.overline?.copyWith(color: color),
    );
  }

  static TextStyle caption(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.caption?.copyWith(color: color),
    );
  }

  static TextStyle body({required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(color: color, fontWeight: FontWeight.normal),
    );
  }

  static TextStyle subTitle(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.subtitle1?.copyWith(color: color, height: 1),
    );
  }

  static TextStyle title(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(color: color, fontWeight: FontWeight.bold),
    );
  }

  static TextStyle miniHeadline(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(color: color, fontWeight: FontWeight.w300),
    );
  }

  static TextStyle subHeadline(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context)
          .textTheme
          .headline5
          ?.copyWith(color: color, fontWeight: FontWeight.w300),
    );
  }

  static TextStyle headline(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context)
          .textTheme
          .headline4
          ?.copyWith(color: color, fontWeight: FontWeight.w400),
    );
  }
  static TextStyle overlineBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context).textTheme.overline?.copyWith(color: color),
    );
  }

  static TextStyle captionBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context).textTheme.caption?.copyWith(color: color),
    );
  }

  static TextStyle bodyBN({required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(color: color, fontWeight: FontWeight.normal),
    );
  }

  static TextStyle subTitleBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context)
          .textTheme
          .subtitle1
          ?.copyWith(color: color, fontWeight: FontWeight.bold),
    );
  }

  static TextStyle titleBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(color: color, fontWeight: FontWeight.bold),
    );
  }

  static TextStyle miniHeadlineBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(color: color, fontWeight: FontWeight.w300),
    );
  }

  static TextStyle subHeadlineBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context)
          .textTheme
          .headline5
          ?.copyWith(color: color, fontWeight: FontWeight.w300),
    );
  }

  static TextStyle headlineBN(
      {required BuildContext context, required Color color}) {
    return GoogleFonts.hindSiliguri(
      textStyle: Theme.of(context)
          .textTheme
          .headline4
          ?.copyWith(color: color, fontWeight: FontWeight.w400),
    );
  }
}
