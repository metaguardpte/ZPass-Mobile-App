import 'package:zpass/util/callback_funcation.dart';

class Events {
  static const String eventUserChanged = "user_changed";
}

class EventBus {
  EventBus._internal();
  factory EventBus() => _singleton;
  static final EventBus _singleton = EventBus._internal();

  // save event subscribers list，key: event-id，value: subscribers list
  final _emap = <Object, List<FunctionCallback>?>{};

  // register subscriber
  void on(eventName, FunctionCallback f) {
    _emap[eventName] ??=  <FunctionCallback>[];
    _emap[eventName]!.add(f);
  }

  // unregister subscriber
  void off(eventName, [FunctionCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // fire event, invoke all subscribers in list
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    // reverse iterate，avoid error index if subscriber remove itself
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}