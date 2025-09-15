import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // Access screen width
  double get width => MediaQuery.sizeOf(this).width;

  // Access screen height
  double get height => MediaQuery.sizeOf(this).height;

  Orientation get orientation => MediaQuery.orientationOf(this);
}
