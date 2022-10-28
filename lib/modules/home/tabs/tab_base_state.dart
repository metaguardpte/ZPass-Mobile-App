import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/provider/tab_base_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_sort_type.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/common_widgets.dart';
import 'package:zpass/widgets/grouped_list/grouped_list.dart';
import 'package:zpass/widgets/load_image.dart';
import 'package:zpass/widgets/zpass_edittext.dart';

abstract class TabBasePageState<V extends StatefulWidget, T,
    P extends TabBaseProvider<T>> extends AliveProviderState<V, P> {
  String get emptyTips => "No Data";

  String get emptyImage => "ic_placeholder";

  Future get preloadFuture => Future.delayed(const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.init().catchError(
          (e) => Log.e("provider init error: $e", tag: "TabBasePageState"));
      provider.fetchData(reset: true).catchError((e) {
        Log.e("fetchData error: $e", tag: "TabBasePageState");
        provider.loading = false;
      });
    });
  }

  @override
  Widget buildContent(BuildContext context) {
    return Selector<P, Tuple2<List<T>, bool>>(
      builder: (_, tuple, __) => buildContentView(tuple.item1, tuple.item2),
      selector: (_, provider) => Tuple2(provider.dataSource, provider.loading)
    );
  }

  @protected
  Widget buildContentView(List<T> data, bool loading) {
    return Container(
      color: context.backgroundColor,
      child: Column(
        children: [
          buildSearch(),
          Expanded(child: Stack(
            children: [
              Visibility(visible: data.isEmpty, child: buildEmptyView(),),
              Visibility(visible: data.isNotEmpty, child: buildCollections(data)),
              Visibility(visible: loading, child: commonLoading(context),)
            ],
          ))
        ],
      ),
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
        onChanged: onSearchValueChanged,
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
      itemBuilder: (_, item) =>
          _buildReactItem(item, buildListItem(context, item)),
      groupItemBuilder: (_, T item, bool groupStart, bool groupEnd) =>
          _buildReactItem(
              item, buildListGroupItem(context, item, groupStart, groupEnd)),
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
          LoadAssetImage(emptyImage, width: 120, height: 120,),
          Gaps.vGap5,
          Text(
            emptyTips,
            textAlign: TextAlign.center,
            style: TextStyles.textSize14.copyWith(color: context.textColor3),
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

  Widget _buildReactItem(T element, Widget child) {
    return InkWell(
      onTap: () => onItemClicked(element),
      child: child,
    );
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
        indent: 57.5,
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

  @protected
  void onItemClicked(T item) {
    // do something
  }
}
