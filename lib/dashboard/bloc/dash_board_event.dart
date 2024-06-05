part of 'dash_board_bloc.dart';

@immutable
sealed class DashBoardEvent {}

class DashBoardInitialFetchEvent extends DashBoardEvent {}

class DepositAmountEvent extends DashBoardEvent {
  final TransactionModel transaction;

  DepositAmountEvent(this.transaction);
}

class WithdrawAmountEvent extends DashBoardEvent {
  final TransactionModel transaction;

  WithdrawAmountEvent(this.transaction);
}
