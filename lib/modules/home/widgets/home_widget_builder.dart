import 'package:flutter/material.dart';

/// AppBar builder.
abstract class HomeWidgetBuilder {
  /// * [context] BuildContext instance;
  Widget build(BuildContext context);

  bool applyLeading() {
    return false;
  }
}