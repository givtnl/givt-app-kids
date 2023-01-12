// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/providers/wallet_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';
import 'package:givt_app_kids/models/transaction.dart';

class ChooseAmountExtendedScreen extends StatefulWidget {
  static const String routeName = "/choose-ammount-exteded";

  const ChooseAmountExtendedScreen({Key? key}) : super(key: key);

  @override
  _ChooseAmountExtendedScreenState createState() =>
      _ChooseAmountExtendedScreenState();
}

class _ChooseAmountExtendedScreenState
    extends State<ChooseAmountExtendedScreen> {
  double _chosenAmount = 0;

  final TextEditingController _textController = TextEditingController(text: "");

  void _handleAmountChanged(String newValue) {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);

    double? amount = double.tryParse(newValue);
    if (amount != null) {
      if (amount > walletProvider.totalAmount) {
        amount = walletProvider.totalAmount;
        setState(() {
          _textController.text = amount.toString();
          _textController.selection =
              TextSelection.collapsed(offset: _textController.text.length);
        });
      }
    }
    setState(() {
      _chosenAmount = amount ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var walletProvider = Provider.of<WalletProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1EAE2),
        body: SingleChildScrollView(
          child: Column(
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
                margin: EdgeInsets.only(left: 50, right: 50, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFBFDBFC),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount to give",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3B3240),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 12, right: 5),
                          child: Text(
                            "\$",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF3B3240),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            controller: _textController,
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFF3B3240),
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "0",
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _handleAmountChanged(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, bottom: 15),
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            _chosenAmount > 0 ? Color(0xFF54A1EE) : Color(0xFFC4C4C4),
                      ),
                      child: IconButton(
                        alignment: Alignment.center,
                        onPressed: _chosenAmount > 0
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var giveAmount = _chosenAmount;
                                if (giveAmount > walletProvider.totalAmount) {
                                  giveAmount = walletProvider.totalAmount;
                                }
                                var transaction = Transaction(
                                  timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  amount: giveAmount,
                                );
                                walletProvider.createTransaction(transaction);

                                Navigator.of(context).pushNamed(
                                  SuccessScreen.routeName,
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
