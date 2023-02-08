// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:givt_app_kids/models/organisation.dart';

import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:givt_app_kids/screens/success_screen.dart';
import 'package:givt_app_kids/models/transaction.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/widgets/wallet.dart';
import 'package:givt_app_kids/widgets/back_button.dart' as custom_widgets;
import 'package:givt_app_kids/providers/profiles_provider.dart';

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
  final CurrencyTextInputFormatter _currencyTextFormatter =
      CurrencyTextInputFormatter(
    decimalDigits: 2,
    enableNegative: false,
    symbol: "\$",
  );

  @override
  void initState() {
    super.initState();
  }

  void _handleAmountChanged(String newValue) {
    var profilesProvider =
        Provider.of<ProfilesProvider>(context, listen: false);

    newValue = newValue.isNotEmpty ? newValue.substring(1) : "0";
    double? amount = double.tryParse(newValue);

    if (amount != null) {
      if (amount > profilesProvider.activeProfile!.balance) {
        amount = profilesProvider.activeProfile!.balance;
        setState(() {
          _textController.text =
              _currencyTextFormatter.format(amount!.toStringAsFixed(2));
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
    final organisation =
        ModalRoute.of(context)?.settings.arguments as Organisation;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1EAE2),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 25),
              Row(
                children: [
                  custom_widgets.BackButton(),
                  Spacer(),
                  Wallet(),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 25, bottom: 30),
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
                              hintText: "\$0",
                            ),
                            maxLines: 1,
                            inputFormatters: [_currencyTextFormatter],
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
                        color: _chosenAmount > 0
                            ? Color(0xFF54A1EE)
                            : Color(0xFFC4C4C4),
                      ),
                      child: IconButton(
                        alignment: Alignment.center,
                        onPressed: _chosenAmount > 0
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var profilesProvider =
                                    Provider.of<ProfilesProvider>(context,
                                        listen: false);

                                var giveAmount = _chosenAmount;
                                if (giveAmount >
                                    profilesProvider.activeProfile!.balance) {
                                  giveAmount =
                                      profilesProvider.activeProfile!.balance;
                                }
                                var transaction = Transaction(
                                    timestamp:
                                        DateTime.now().millisecondsSinceEpoch,
                                    amount: giveAmount,
                                    profileGuid:
                                        profilesProvider.activeProfile!.guid,
                                    goalName: organisation.name);

                                profilesProvider
                                    .createTransaction(transaction)
                                    .then((_) =>
                                        profilesProvider.fetchProfiles());

                                AnalyticsHelper.logButtonPressedEvent(
                                    "arrow icon button",
                                    ChooseAmountExtendedScreen.routeName);

                                Navigator.of(context).pushNamed(
                                    SuccessScreen.routeName,
                                    arguments: transaction);
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
