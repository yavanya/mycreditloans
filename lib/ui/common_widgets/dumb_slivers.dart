import 'package:flutter/material.dart';

class SliverGap extends StatelessWidget {
  const SliverGap({required this.height, Key? key}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
      ),
    );
  }
}

class SliverHorizontalDivider extends StatelessWidget {
  const SliverHorizontalDivider({required this.height, Key? key})
      : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Divider(
        height: height,
      ),
    );
  }
}
