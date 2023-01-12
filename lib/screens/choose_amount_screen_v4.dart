// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:givt_app_kids/models/transaction.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_extended_screen.dart';
import 'package:givt_app_kids/providers/wallet_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';

class ChooseAmountScreenV4 extends StatefulWidget {
  static const String routeName = "/choose-ammount-v4";

  const ChooseAmountScreenV4({Key? key}) : super(key: key);

  @override
  State<ChooseAmountScreenV4> createState() => _ChooseAmountScreenStateV4();
}

class _ChooseAmountScreenStateV4 extends State<ChooseAmountScreenV4> {
  final List<double> _amountOptions = [2, 5, 7];

  final double addScrollThreshold = 500;

  int _currentAmountIndex = -1;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1EAE2),
        body: Container(
            child: mediaQuery.size.height < addScrollThreshold
                ? SingleChildScrollView(
                    child: _createMainLayout(context, true),
                  )
                : _createMainLayout(context, false)),
      ),
    );
  }

  Widget _createMainLayout(BuildContext context, bool addScroll) {
    var walletProvider = Provider.of<WalletProvider>(context);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF54A1EE),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 85),
                      Column(
                        children: [
                          Text(
                            Provider.of<AccountProvider>(context).name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "\$",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: walletProvider.totalAmount
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 2,
                  child: Image(
                    height: 75,
                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/images/wallet.png"),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 30),
              child: Text(
                "Presbyterian Church Tulsa",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B3240),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _createPickOptions(walletProvider),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ChooseAmountExtendedScreen.routeName);
                  },
                  child: Text(
                    "enter a different amount",
                    style: TextStyle(
                      color: Color(0xFF3B3240),
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
        if (!addScroll) Spacer(),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 30,
            bottom: 30,
            left: 50,
            right: 50,
          ),
          child: ElevatedButton(
            onPressed: _currentAmountIndex == -1
                ? null
                : () {
                    var giveAmount = _amountOptions[_currentAmountIndex];
                    if (giveAmount > walletProvider.totalAmount) {
                      giveAmount = walletProvider.totalAmount;
                    }
                    var transaction = Transaction(
                      timestamp: DateTime.now().millisecondsSinceEpoch,
                      amount: giveAmount,
                    );
                    walletProvider.createTransaction(transaction);

                    Navigator.of(context).pushNamed(
                      SuccessScreen.routeName,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF54A1EE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Text(
                "Give to this goal",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _createPickOptions(WalletProvider walletProvider) {
    const double pickItemSize = 65;

    List<Widget> result = [];

    for (var i = 0; i < _amountOptions.length; i++) {
      double currentOptionAmount;

      bool noMoreMoney = false;
      if (walletProvider.totalAmount <= _amountOptions[i]) {
        currentOptionAmount = walletProvider.totalAmount;
        noMoreMoney = true;
      } else {
        currentOptionAmount = _amountOptions[i];
      }

      String currentOptionAmountString = currentOptionAmount.toStringAsFixed(0);
      if (noMoreMoney && currentOptionAmount.toString().split(".").length > 1) {
        currentOptionAmountString = currentOptionAmount.toStringAsFixed(1);
      }

      result.add(
        GestureDetector(
          onTap: () {
            setState(() {
              if (_currentAmountIndex == i) {
                _currentAmountIndex = -1;
              } else {
                _currentAmountIndex = i;
              }
            });
          },
          child: Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.center,
            width: pickItemSize,
            height: pickItemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: i == _currentAmountIndex
                  ? Color(0xFF54A1EE)
                  : Color(0xFFBFDBFC),
            ),
            child: Text(
              "\$$currentOptionAmountString",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    i == _currentAmountIndex ? Colors.white : Color(0xFF3B3240),
              ),
            ),
          ),
        ),
      );
      if (noMoreMoney) {
        break;
      }
    }

    return result;
  }
}
