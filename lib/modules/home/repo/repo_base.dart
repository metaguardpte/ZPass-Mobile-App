import 'package:flutter/foundation.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';

abstract class RepoBase<T> {
  @protected
  List<T> rawData = [];

  ///
  /// 执行repo初始化
  ///
  Future<dynamic> init();

  ///
  /// 条件查询
  ///
  Future<List<T>> query(QueryContext queryContext);

  ///
  /// 删除数据项
  ///
  Future<bool> remove(T item);

  ///
  /// 条件删除数据项
  ///
  bool removeBy(String condition);

  ///
  /// 增加数据项
  ///
  Future<bool> add(T item);

  ///
  /// 增加数据列表
  ///
  bool addAll(List<T> items);

  ///
  /// 修改数据项
  ///
  Future<bool> update(T item);

  ///
  /// 写入数据，执行io操作
  ///
  Future<bool> flush();

  void close();
}