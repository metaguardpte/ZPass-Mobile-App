import 'package:zpass/util/callback_funcation.dart';

class Events {
  static const String eventUserChanged = "user_changed";
}

class EventBus {
  EventBus._internal();
  factory EventBus() => _singleton;
  static final EventBus _singleton = EventBus._internal();

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = <Object, List<FunctionCallback>?>{};

  //添加订阅者
  void on(eventName, FunctionCallback f) {
    _emap[eventName] ??=  <FunctionCallback>[];
    _emap[eventName]!.add(f);
  }

  //移除订阅者
  void off(eventName, [FunctionCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}