import 'package:flutter/material.dart';

/// Border radius tokens for MoneyFlow.
///
/// Use these for all rounded corners on cards, buttons, chips,
/// dialogs, input fields, and containers.
abstract final class AppRadius {
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xl2 = 24.0;
  static const double full = 9999.0;

  // ---------------------------------------------------------------------------
  // BorderRadius convenience objects
  // ---------------------------------------------------------------------------
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXl2 = BorderRadius.all(Radius.circular(xl2));
  static const BorderRadius radiusFull =
      BorderRadius.all(Radius.circular(full));

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------
  static const BorderRadius card = radiusLg;
  static const BorderRadius button = radiusMd;
  static const BorderRadius chip = radiusFull;
  static const BorderRadius input = radiusMd;
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(xl2),
    topRight: Radius.circular(xl2),
  );
  static const BorderRadius dialog = radiusXl;
  static const BorderRadius avatar = radiusFull;
  static const BorderRadius badge = radiusFull;
}
