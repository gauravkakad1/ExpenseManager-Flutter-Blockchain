import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:blockchain_e_wallet/model/TransactionModel.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/credentials.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web3dart/web3dart.dart';

part 'dash_board_event.dart';
part 'dash_board_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitialState()) {
    on<DashBoardInitialFetchEvent>(_dashBoardInitialFetchEvent);
    on<DepositAmountEvent>(_depositAmountEvent);
    on<WithdrawAmountEvent>(_withdrawAmountEvent);
  }

  List<TransactionModel> transactions = [];
  int balance = 0;
  late EthereumAddress? ownerAddress;
  Web3Client? _web3client;
  late ContractAbi _contractAbi;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _credentials;

  // Functions
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> _dashBoardInitialFetchEvent(
      DashBoardInitialFetchEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    try {
      print('Initializing web3client');
      String ipAddress = '192.168.0.118';
      String rpcUrl =
          'http://${ipAddress}:7545'; // Replace with your host machine's IP address
      String socketUrl =
          'ws://${ipAddress}:7545'; // Replace with your host machine's IP address
      String privateKey =
          '0xd3f1e8c58e2d6ef61e472fac9e2387fbee3a5f8ca609107eb9fa295c8d26abf7';
      print("connecting to web3client");
      _web3client = Web3Client(rpcUrl, http.Client(), socketConnector: () {
        //for ganache
        return IOWebSocketChannel.connect(socketUrl).cast<String>();
      });

      // String apiKey = '0jNP62KsLVZMuZ4vEAbVvrWFDCshBDvx';
      // String httpUrl = 'https://eth-mainnet.g.alchemy.com/v2/${apiKey}';
      // String wsUrl = 'wss://eth-mainnet.g.alchemy.com/v2/${apiKey}';
      // _web3client = Web3Client(httpUrl, http.Client());

      print("connected to web3client");
      String abiFile = await rootBundle
          .loadString('build/contracts/ExpenseManagerContract.json');
      var jsonDecoded = jsonDecode(abiFile);
      print('here1');
      _contractAbi = ContractAbi.fromJson(
          jsonEncode(jsonDecoded['abi']), 'ExpenseManagerContract');
      print('here2');
      _contractAddress =
          EthereumAddress.fromHex('0x10C0aFF8d65246B2c4c0CfCD15c31Ed86CB8DdA8');
      print('here3');
      _credentials = EthPrivateKey.fromHex(privateKey);
      print('here4');

      _deployedContract = DeployedContract(_contractAbi, _contractAddress);
      print('here');

      _getBalance = _deployedContract.function('getBalance');
      _deposit = _deployedContract.function('depositAmount');
      _withdraw = _deployedContract.function('withdrawAmount');

      _getAllTransactions = _deployedContract.function('getAllTransactions');
      print("fetching transactions");
      final transactionsData = await _web3client!.call(
        contract: _deployedContract,
        function: _getAllTransactions,
        params: [],
      );
      print("transactions fetched: ${transactionsData.length} items");

      final bal = await _web3client!
          .call(contract: _deployedContract, function: _getBalance, params: [
        EthereumAddress.fromHex('0xD56C0e1c3d06F88065D47A378424A87ce2580683')
      ]);
      print("Balance : " + bal.toString());

      List<TransactionModel> trans = [];
      if (transactionsData.isNotEmpty) {
        for (var i = 0; i < transactionsData[0].length; i++) {
          print("Processing transaction $i");
          TransactionModel transaction = TransactionModel(
            transactionsData[0][i]?.toString() ??
                "", // Use null-safety operator
            transactionsData[1][i]?.toInt() ?? 0,
            transactionsData[2][i]?.toString() ?? "",
            DateTime.fromMillisecondsSinceEpoch(
                transactionsData[3][i]?.toInt() * 1000 ?? 0),
            transactionsData[4][i] ?? false,
          );
          trans.insert(0, transaction);
        }
      }
      transactions = trans;
      balance = bal[0].toInt();
      print("bal : " + balance.toString());
      print("transactions: ${transactions[0].reason}");
      ownerAddress =
          EthereumAddress.fromHex('0xD56C0e1c3d06F88065D47A378424A87ce2580683');
      emit(DashBoardSuccessState(transactions, balance));
    } catch (e, stack) {
      print('Error during dashboard initial fetch: ${e.toString()}');
      emit(DashBoardErrorState(e.toString()));
      log(e.toString());
      log(stack.toString());
    }
  }

  FutureOr<void> _withdrawAmountEvent(
      WithdrawAmountEvent event, Emitter<DashBoardState> emit) async {
    try {
      final transaction = Transaction.callContract(
        from: EthereumAddress.fromHex(
            "0xD56C0e1c3d06F88065D47A378424A87ce2580683"),
        contract: _deployedContract,
        function: _withdraw,
        parameters: [
          BigInt.from(event.transaction.amount),
          event.transaction.reason
        ],
      );

      final result = await _web3client!.sendTransaction(
          _credentials, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashBoardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _depositAmountEvent(
      DepositAmountEvent event, Emitter<DashBoardState> emit) async {
    try {
      final transaction = Transaction.callContract(
          from: EthereumAddress.fromHex(
              "0xD56C0e1c3d06F88065D47A378424A87ce2580683"),
          contract: _deployedContract,
          function: _deposit,
          parameters: [
            BigInt.from(event.transaction.amount),
            event.transaction.reason
          ],
          value: EtherAmount.inWei(BigInt.from(event.transaction.amount)));

      final result = await _web3client!.sendTransaction(
          _credentials, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      log(result.toString());
      add(DashBoardInitialFetchEvent());
    } catch (e) {
      log(e.toString());
    }
  }
}
