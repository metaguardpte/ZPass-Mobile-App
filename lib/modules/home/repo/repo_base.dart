import 'package:flutter/foundation.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';

abstract class RepoBase<T> {
  @protected
  List<T> rawData = [];

  ///
  /// for repo initializing
  ///
  Future<dynamic> init();

  ///
  /// query by conditions
  ///
  Future<List<T>> query(QueryContext queryContext);

  ///
  /// remove item
  ///
  Future<bool> remove(T item);

  ///
  /// remove item by condition
  ///
  bool removeBy(String condition);

  ///
  /// add item
  ///
  Future<bool> add(T item);

  ///
  /// add items
  ///
  bool addAll(List<T> items);

  ///
  /// update item
  ///
  Future<bool> update(T item);

  ///
  /// flush repo, for IO operating
  ///
  Future<bool> flush();

  void close();
}