import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:geny_test_app/core/enums/data_fetching_state.dart';

class ItemFetcherModel<T> extends Equatable {
  const ItemFetcherModel({
    required this.connectionState,
    required this.error,
    required this.item,
    required this.stackTrace,
  });
  const ItemFetcherModel.initial({
    this.item,
    this.connectionState = DataFetchingState.initial,
    this.stackTrace,
    this.error = '',
  });

  const ItemFetcherModel.loading()
    : connectionState = DataFetchingState.inProgress,
      error = '',
      stackTrace = null,
      item = null;

  const ItemFetcherModel.failed(this.error, this.stackTrace)
    : item = null,
      connectionState = DataFetchingState.failure;

  const ItemFetcherModel.success(T this.item)
    : connectionState = DataFetchingState.success,
      error = '',
      stackTrace = null;

  final DataFetchingState connectionState;
  final String error;
  final T? item;
  final StackTrace? stackTrace;

  ItemFetcherModel<T> copyWith({
    T? item,
    DataFetchingState? connectionState,
    String? error,
    StackTrace? stackTrace,
  }) {
    return ItemFetcherModel<T>(
      item: item ?? this.item,
      connectionState: connectionState ?? this.connectionState,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  bool get hasError =>
      error.trim().isNotEmpty && (connectionState == DataFetchingState.failure);
  bool get isLoading => connectionState == DataFetchingState.inProgress;
  bool get hasData =>
      connectionState == DataFetchingState.success &&
      error.trim().isEmpty &&
      item != null;

  @override
  List<Object?> get props => [item, connectionState, error, stackTrace];

  // when method

  Widget when({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(T item) success,
    required Widget Function(String error, StackTrace? stackTrace) failed,
  }) {
    return switch (connectionState) {
      DataFetchingState.initial => initial(),
      DataFetchingState.inProgress => loading(),
      DataFetchingState.success => success(item as T),
      DataFetchingState.failure => failed(error, stackTrace),
    };
  }

  @override
  String toString() {
    return 'ItemFetcherModel(item: $item, connectionState: $connectionState,'
        ' error: $error,)';
  }
}
