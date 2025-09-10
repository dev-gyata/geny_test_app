import 'package:flutter/material.dart';

typedef WidgetBuilder<T> = Widget Function(BuildContext context, T value);

class BusinessCard<T> extends StatelessWidget {
  const BusinessCard({
    required this.value,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.trailingBuilder,
    super.key,
  });
  final T value;
  final WidgetBuilder<T> titleBuilder;
  final WidgetBuilder<T> subtitleBuilder;
  final WidgetBuilder<T> trailingBuilder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: titleBuilder(context, value),
      subtitle: subtitleBuilder(context, value),
      trailing: trailingBuilder(context, value),
    );
  }
}
