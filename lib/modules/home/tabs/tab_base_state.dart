import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/provider/tab_base_provider.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/res/zpass_fonts_icons.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/common_widgets.dart';
import 'package:zpass/widgets/zpass_edittext.dart';

abstract class TabBasePageState<V extends StatefulWidget, T,
    P extends TabBaseProvider<T>> extends ProviderState<V, P> {
  String get emptyTips => "No Data";

  String get emptyImage => "ic_placeholder";

  Future get preloadFuture => Future.delayed(const Duration(milliseconds: 500));

  @override
  Widget buildContent(BuildContext context) {
    return Selector<P, bool>(
      builder: (_, loading, __) {
        if (loading) {
          return commonLoading(context);
        } else {
          return buildContentView();
        }
      },
      selector: (_, provider) => provider.loading,
    );
  }

  @protected
  Widget buildContentView() {
    return Selector<P, List<T>>(
        builder: (_, data, __) {
          if (data.isEmpty) {
            return buildEmptyView();
          } else {
            return buildDataView(data);
          }
        },
        selector: (_, provider) => provider.dataSource);
  }

  @protected
  Widget buildDataView(List<T> data) {
    return Container(
      color: context.backgroundColor,
      child: Column(children: [
        buildSearch(),
        Expanded(child: buildCollections(data))
      ],),
    );
  }

  @protected
  Widget buildSearch() {
    return Container(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
        child: ZPassEditText(
          hintText: "Search",
          height: 35,
          action: TextInputAction.search,
          onSubmitted: onSearchValueChanged,
          borderRadius: 17.25,
          bgColor: const Color(0xFFEAEBED),
          focusBgColor: Colors.white,
        ));
  }

  @protected
  Widget buildCollections(List<T> data) {
    return GroupedListView<T, String>(
      physics: const BouncingScrollPhysics(),
      elements: provider.dataSource,
      groupBy: listGroupBy,
      groupSeparatorBuilder: buildGroupSeparator,
      itemBuilder: buildListItem,
      separator: buildListSeparator(),
      useStickyGroupSeparators: stickyGroupSeparators,
      floatingHeader: floatingHeader,
      itemComparator: comparator,
      shrinkWrap: true,
      // itemExtent: 67.5,
      cacheExtent: 500,
    );
  }

  @protected
  Widget buildEmptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(ZPassFonts.logins, size: 100, color: Colours.unselected_item_color,),
          Gaps.vGap15,
          Text(
            emptyTips,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: Dimens.font_sp14),
          )
        ],
      ),
    );
  }

  ///
  /// 分组列表自定义 **** start
  ///
  @protected
  String listGroupBy(T element);

  @protected
  int comparator(T e1, T e2);

  @protected
  Widget buildGroupSeparator(String groupByValue) {
    return Container(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
        child: Text(
          groupByValue,
          style: TextStyles.textSize14.copyWith(color: const Color(0xFF959BA7)),
        ));
  }

  @protected
  Widget buildListItem(BuildContext context, T element);

  @protected
  Widget buildListSeparator() {
    // return const Divider(indent: 73.5, endIndent: 16,);
    return const SizedBox.shrink();
  }

  @protected
  bool get stickyGroupSeparators => false;

  @protected
  bool get floatingHeader => false;
  ///
  /// 分组列表自定义 **** end
  ///

  @protected
  void onSearchValueChanged(String changed) {
    provider.filterData(keyword: changed);
  }
}
