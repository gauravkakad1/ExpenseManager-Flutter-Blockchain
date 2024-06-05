import 'package:blockchain_e_wallet/AppColors.dart';
import 'package:blockchain_e_wallet/dashboard/bloc/dash_board_bloc.dart';
import 'package:blockchain_e_wallet/dashboard/view/depositScreen.dart';
import 'package:blockchain_e_wallet/dashboard/view/withdrawScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final DashBoardBloc _dashBoardBloc = DashBoardBloc();
  @override
  void initState() {
    _dashBoardBloc.add(DashBoardInitialFetchEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: BlocConsumer<DashBoardBloc, DashBoardState>(
          bloc: _dashBoardBloc,
          buildWhen: (previous, current) => current != previous,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case DashBoardInitialState:
                return Center(
                  child: SizedBox(),
                );
              case DashBoardErrorState:
                return Center(
                  child: Text('Error',
                      style: TextStyle(color: AppColors.whiteColor)),
                );
              case DashBoardLoadingState:
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                );
              case DashBoardSuccessState:
                final successState = state as DashBoardSuccessState;
                return SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Blockchain E-wallet',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: AppColors.whiteColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: AppColors.blackColor,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: AppColors.darkGreyColor,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      child: Icon(
                                        Icons.notifications_none_outlined,
                                        color: AppColors.whiteColor,
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: AppColors.lightGreyColor,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    color: AppColors.secondaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .account_balance_wallet_outlined,
                                                color: AppColors.blackColor,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  'Wallet Balance',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                (_dashBoardBloc.balance
                                                        .toString() +
                                                    " ETH"),
                                                style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: AppColors.blackColor,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: AppColors.secondaryColor,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                              child: Icon(
                                                Icons.visibility,
                                                color: AppColors.blackColor,
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address : ',
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _dashBoardBloc.ownerAddress.toString(),
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: AppColors.greyColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TransferScreen(
                                                dashBoardBloc: _dashBoardBloc,
                                              )));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: AppColors.blackColor,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: AppColors.darkGreyColor,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10),
                                        child: Icon(
                                          Icons.file_upload,
                                          color: Colors.amber,
                                        )),
                                  ),
                                ),
                              ),
                              Text(
                                'Deposit',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: AppColors.blackColor,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: AppColors.darkGreyColor,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.amber,
                                      )),
                                ),
                              ),
                              Text(
                                'Top up',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WithdrawScreen(
                                              dashBoardBloc: _dashBoardBloc,
                                            ))),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: AppColors.blackColor,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: AppColors.darkGreyColor,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10),
                                        child: Icon(
                                          Icons.download,
                                          color: Colors.amber,
                                        )),
                                  ),
                                ),
                              ),
                              Text(
                                'Withdraw',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 184, 184, 184),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Text(
                                          'Recent Transactions',
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0)
                                            .copyWith(right: 20),
                                        child: Icon(Icons.sort,
                                            color: AppColors.blackColor),
                                      )
                                    ],
                                  ),

                                  // List of transactions
                                  Expanded(
                                      child: ListView.builder(
                                    itemCount: successState.transactions.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        child: Card(
                                          color: AppColors.lightGreyColor,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  AppColors.greyColor,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      AppColors.lightGreyColor,
                                                  child: Icon(
                                                    Icons.arrow_upward_outlined,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              _dashBoardBloc
                                                  .transactions[index].address,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            subtitle: Text(_dashBoardBloc
                                                .transactions[index].timestamp
                                                .toString()),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${_dashBoardBloc.transactions[index].isWithdraw ? ' - ' : ' + '} ${_dashBoardBloc.transactions[index].amount} ETH',
                                                  style: TextStyle(
                                                      color: _dashBoardBloc
                                                              .transactions[
                                                                  index]
                                                              .isWithdraw
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  _dashBoardBloc
                                                          .transactions[index]
                                                          .isWithdraw
                                                      ? "Withdraw"
                                                      : "Deposit",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                                ],
                              )))
                    ],
                  ),
                );

              default:
                return Center(
                  child: Text('Default'),
                );
            }
          },
        ));
  }
}
