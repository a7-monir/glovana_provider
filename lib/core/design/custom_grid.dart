import 'package:flutter/material.dart';

class CustomSliverGrid extends StatelessWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount, crossCount;
  final EdgeInsetsGeometry? itemPadding, padding;

  const CustomSliverGrid({super.key, required this.itemBuilder, required this.itemCount, required this.crossCount, this.itemPadding, this.padding});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              crossCount,
              (i) => Expanded(
                child: (index * crossCount) + i >= itemCount
                    ? const SizedBox.shrink()
                    : Padding(padding: itemPadding ?? EdgeInsets.zero, child: itemBuilder(context, (index * crossCount) + i)),
              ),
            ),
          ),
          childCount: (itemCount / 2).ceilToDouble().toInt(),
        ),
      ),
    );
  }
}

class CustomGrid extends StatelessWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount, crossCount;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double? spacing,runSpacing;

  const CustomGrid({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.crossCount,
    this.spacing,
    this.runSpacing,

    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? EdgeInsets.zero,
      itemCount: (itemCount / 2).ceilToDouble().toInt(),
      itemBuilder: (context, index) =>
          LayoutBuilder(
          builder: (context, constraints) {
        final paddingWidth = padding?.horizontal ?? 0;
        final spacingWidth = (spacing ?? 0) * (crossCount - 1);
        final itemWidth = (constraints.maxWidth / crossCount - spacingWidth - paddingWidth).floorToDouble();

        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing:spacing??0 ,
          children: List.generate(
            crossCount,
            (i) => SizedBox(
              width: itemWidth,
              child: (index * crossCount) + i >= itemCount ? const SizedBox.shrink() : itemBuilder(context, (index * crossCount) + i),
            ),
          ),
        );
      }), separatorBuilder: (BuildContext context, int index) =>SizedBox(height: runSpacing),
    );
  }
}
