import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/provider/tab_base_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_sort_type.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/common_widgets.dart';
import 'package:zpass/widgets/grouped_list/grouped_list.dart';
import 'package:zpass/widgets/zpass_edittext.dart';

abstract class TabBasePageState<V extends StatefulWidget, T,
    P extends TabBaseProvider<T>> extends AliveProviderState<V, P> {
  String get emptyTips => "No Data";

  String get emptyImage => "ic_placeholder";

  Future get preloadFuture => Future.delayed(const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchData(reset: true);
    });
  }

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
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
      child: Row(
        children: [_buildSearchInput(), Gaps.hGap8, _buildSorterDropdown()],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Expanded(
      child: ZPassEditText(
        hintText: "Search",
        height: 35,
        action: TextInputAction.search,
        onSubmitted: onSearchValueChanged,
        borderRadius: 17.25,
        bgColor: const Color(0xFFEAEBED),
        focusBgColor: Colors.white,
        textSize: 14,
      ),
    );
  }

  Widget _buildSorter(VaultItemSortType sortType) {
    return Row(
      children: [
        Selector<P, VaultItemSortType>(
          builder: (_, sortType, __) {
            return Text(
              sortType.desc,
              style: TextStyles.textSize14.copyWith(color: context.textColor1),
            );
          },
          selector: (_, provider) => provider.sortType,
        ),
        Gaps.hGap4,
        const Icon(
          ZPassIcons.icSort,
          size: 18,
          color: Color(0xFFC8CDD7),
        ),
      ],
    );
  }

  Widget _buildSorterDropdown() {
    menuContent(Widget text, bool selected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          selected
              ? const Icon(Icons.done, size: 15,)
              : const SizedBox(width: 15, height: 15,),
          Gaps.hGap5,
          text,
        ],
      );
    }
    return PopupMenuButton<VaultItemSortType>(
      constraints: const BoxConstraints(maxWidth: 150),
      offset: const Offset(0, 15),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (_) => [
        PopupMenuItem<VaultItemSortType>(
            enabled: false,
            height: 25,
            child: menuContent(
                Text(
                  "SORTED BY",
                  style: TextStyles.textSize14.copyWith(color: const Color(0xFF818183)),
                ),
                false)),
        PopupMenuItem<VaultItemSortType>(
            height: 37.5,
            value: VaultItemSortType.lastUsed,
            child: menuContent(Text(VaultItemSortType.lastUsed.desc),
                provider.sortType == VaultItemSortType.lastUsed)),
        const PopupMenuDivider(height: 1,),
        PopupMenuItem<VaultItemSortType>(
            height: 37.5,
            value: VaultItemSortType.createTime,
            child: menuContent(Text(VaultItemSortType.createTime.desc),
                provider.sortType == VaultItemSortType.createTime)),
      ],
      onSelected: (VaultItemSortType sortType) => provider.sortType = sortType,
      child: _buildSorter(provider.sortType),
    );
  }

  @protected
  Widget buildCollections(List<T> data) {
    return GroupedListView<T, String>(
      physics: const BouncingScrollPhysics(),
      elements: provider.dataSource,
      groupBy: listGroupBy,
      groupSeparatorBuilder: buildGroupSeparator,
      itemBuilder: buildListItem,
      groupItemBuilder: buildListGroupItem,
      separator: buildListSeparator(),
      useStickyGroupSeparators: stickyGroupSeparators,
      floatingHeader: floatingHeader,
      // itemComparator: comparator,
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
          const Icon(ZPassIcons.logins, size: 100, color: Colours.unselected_item_color,),
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
  Widget buildListGroupItem(BuildContext context, T element, bool groupStart, bool groupEnd) {
    return buildListItem(context, element);
  }

  @protected
  Widget buildListSeparator() {
    return Container(
      color: context.tertiaryBackground,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: const Divider(
        indent: 73,
      ),
    );
    // return const SizedBox.shrink();
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
