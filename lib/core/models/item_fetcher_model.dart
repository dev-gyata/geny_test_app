import 'package:equatable/equatable.dart';
import 'package:geny_test_app/core/enums/data_fetching_state.dart';

class ItemFetcherModel<T> extends Equatable {
  const ItemFetcherModel({
    required this.connectionState,
    required this.error,
    required this.item,
  });
  const ItemFetcherModel.initial({
    this.item,
    this.connectionState = DataFetchingState.initial,
    this.error = '',
  });

  const ItemFetcherModel.loading()
    : connectionState = DataFetchingState.inProgress,
      error = '',
      item = null;

  const ItemFetcherModel.failed(this.error)
    : item = null,
      connectionState = DataFetchingState.failure;

  const ItemFetcherModel.success(T this.item)
    : connectionState = DataFetchingState.success,
      error = '';
  final DataFetchingState connectionState;
  final String error;
  final T? item;

  ItemFetcherModel<T> copyWith({
    T? item,
    DataFetchingState? connectionState,
    String? error,
  }) {
    return ItemFetcherModel<T>(
      item: item ?? this.item,
      connectionState: connectionState ?? this.connectionState,
      error: error ?? this.error,
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
  List<Object?> get props => [item, connectionState, error];

  @override
  String toString() {
    return 'ItemFetcherModel(item: $item, connectionState: $connectionState,'
        ' error: $error,)';
  }
}
