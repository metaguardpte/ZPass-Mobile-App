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
  /// 条件过滤
  ///
  List<T> filterBy(EntityType entityType);

  ///
  /// 删除数据项
  ///
  bool remove(T item);

  ///
  /// 条件删除数据项
  ///
  bool removeBy(String condition);

  ///
  /// 增加数据项
  ///
  bool add(T item);

  ///
  /// 增加数据列表
  ///
  bool addAll(List<T> items);

  ///
  /// 写入数据，执行io操作
  ///
  Future<bool> flush();

  void close();
}