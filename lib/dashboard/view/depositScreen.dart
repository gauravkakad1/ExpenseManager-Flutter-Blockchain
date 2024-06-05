import 'package:blockchain_e_wallet/AppColors.dart';
import 'package:blockchain_e_wallet/dashboard/bloc/dash_board_bloc.dart';
import 'package:blockchain_e_wallet/model/TransactionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransferScreen extends StatefulWidget {
  final DashBoardBloc dashBoardBloc;
  const TransferScreen({super.key, required this.dashBoardBloc});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              'Deposit',
              style: TextStyle(
                fontSize: 32,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 184, 184, 184),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Transfer Details',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: 'Enter  Address',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: amountController,
                            decoration:
                                InputDecoration(hintText: 'Enter  Amount'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: reasonController,
                            decoration:
                                InputDecoration(hintText: 'Enter  Reason'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              widget.dashBoardBloc.add(DepositAmountEvent(
                                  TransactionModel(
                                      addressController.text,
                                      int.parse(amountController.text),
                                      reasonController.text,
                                      DateTime.now(),
                                      false)));
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green),
                              child: Center(
                                child: Text(
                                  '+ Deposit',
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
