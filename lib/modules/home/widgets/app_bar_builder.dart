import 'package:flutter/material.dart';

/// AppBar builder.
abstract class AppBarBuilder {
  /// * [context] BuildContext instance;
  PreferredSizeWidget build(BuildContext context);

  bool applyLeading() {
    return false;
  }
}