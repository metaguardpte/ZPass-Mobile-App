
import 'package:common_utils/common_utils.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/dates.dart';

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
    return DateUtil.isToday(timeMs, isUtc: true);
  }

  @override
  int getGroupOrder(int timeMs) {
    return 102400;
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
    return 102300;
  }
}

class WeekGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    return "THIS WEEK";
  }

  @override
  bool supported(int timeMs) {
    if (timeMs < 0) {
      return false;
    }
    return DateUtil.isWeek(timeMs, isUtc: true);
  }

  @override
  int getGroupOrder(int timeMs) {
    return 102200;
  }
}

class MonthGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeMs);
    var year = dateTime.year;
    var month = dateTime.month;
    var monthName = Dates.mapIntToEngName(month);
    return  "$monthName $year";
  }

  @override
  bool supported(int timeMs) {
    return timeMs > 0;
  }

  @override
  int getGroupOrder(int timeMs) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timeMs);
    var year = dateTime.year;
    var month = dateTime.month;
    return (year*12 + month);
  }
}

class NullGroupFunc implements GroupFunc {

  @override
  String getKey(int timeMs) {
    return "OTHERS";
  }

  @override
  bool supported(int timeMs) {
    return timeMs < 1;
  }

  @override
  int getGroupOrder(int timeMs) {
    return -1;
  }
}

class Groups {
  static List<EntityGroup> grouping(List<VaultItemEntity> entities, SortBy sortBy) {
    var groupFuncs = <GroupFunc>[TodayGroupFunc(), YesterdayGroupFunc(), WeekGroupFunc(), MonthGroupFunc()];
    var keyToGroup = <String, EntityGroup>{};
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
          break;
        }
      }
    }
    var groups = keyToGroup.values.toList();
    groups.sort((a, b) => b.order.compareTo(a.order));
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