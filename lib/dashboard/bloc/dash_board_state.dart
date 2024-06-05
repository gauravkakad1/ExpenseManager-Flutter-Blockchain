part of 'dash_board_bloc.dart';

@immutable
sealed class DashBoardState {}

final class DashBoardInitialState extends DashBoardState {}

class DashBoardLoadingState extends DashBoardState {}

class DashBoardErrorState extends DashBoardState {
  final String errorMsg;
  DashBoardErrorState(this.errorMsg);
}

class DashBoardSuccessState extends DashBoardState {
  final List<TransactionModel> transactions;
  final int Balance;

  DashBoardSuccessState(this.transactions, this.Balance);
}
