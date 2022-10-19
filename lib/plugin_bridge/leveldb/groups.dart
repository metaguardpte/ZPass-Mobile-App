
import 'package:common_utils/common_utils.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';

class EntityGroup {
  late String name;
  late int order;
  List<VaultItemEntity> entities = <VaultItemEntity>[];

  void addEntity(VaultItemEntity entity) {
    entities.add(entity);
  }
}

abstract class GroupFunc {
  String getKey(int timeMs);
  bool supported(int timeMs);
  int getGroupOrder(int timeMs);
}

class TodayGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    return "TODAY";
  }

  @override
  bool supported(int timeMs) {
    if (timeMs < 0) {
      return false;
    }
    return DateUtil.isToday(timeMs);
  }

  @override
  int getGroupOrder(int timeMs) {
    return -2;
  }
}

class YesterdayGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    return "YESTERDAY";
  }

  @override
  bool supported(int timeMs) {
    if (timeMs < 0) {
      return false;
    }
    var localtimeMsMs = DateTime.now().millisecondsSinceEpoch;
    return DateUtil.isYesterdayByMs(timeMs, localtimeMsMs);
  }

  @override
  int getGroupOrder(int timeMs) {
    return -1;
  }
}

class WeekGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    return "WEEK";
  }

  @override
  bool supported(int timeMs) {
    if (timeMs < 0) {
      return false;
    }
    return DateUtil.isWeek(timeMs);
  }

  @override
  int getGroupOrder(int timeMs) {
    return 0;
  }
}

class MonthGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    var time = DateTime.fromMillisecondsSinceEpoch(timeMs);
    return "MONTH_${time.month}";
  }

  @override
  bool supported(int timeMs) {
    return timeMs > 0;
  }

  @override
  int getGroupOrder(int timeMs) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeMs);
    return dateTime.month;
  }
}

class NullGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    return "NULL";
  }

  @override
  bool supported(int timeMs) {
    return timeMs < 1;
  }

  @override
  int getGroupOrder(int timeMs) {
    return 13;
  }
}

class Groups {
  static List<EntityGroup> grouping(List<VaultItemEntity> entities, SortBy sortBy) {
    var groupFuncs = <GroupFunc>[TodayGroupFunc(), YesterdayGroupFunc(), WeekGroupFunc(), MonthGroupFunc()];
    var keyToGroup = new Map<String, EntityGroup>();
    for (var entity in entities) {
      int timeMs = _getTimeMs(entity, sortBy);
      for (var groupFunc in groupFuncs) {
        if (groupFunc.supported(timeMs)) {
          var key = groupFunc.getKey(timeMs);
          var group = keyToGroup[key];
          if (group == null) {
            group = EntityGroup();
            group.name = key;
            group.order = groupFunc.getGroupOrder(timeMs);
            keyToGroup[key] = group;
          }
          group.addEntity(entity);
        }
      }
    }
    var groups = keyToGroup.values.toList();
    groups.sort((a, b) => a.order.compareTo(b.order));
    return groups;
  }

  static int _getTimeMs(VaultItemEntity entity, SortBy sortBy) {
    int timeMs = entity.createTime;
    if (sortBy == SortBy.useTime) {
      var useTime = entity.useTime;
      if (useTime == null) {
        timeMs = -1;
      } else {
        timeMs = useTime;
      }
    }
    return timeMs;
  }
}