// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';

import 'package:givt_app_kids/providers/wallet_provider.dart';
import 'package:givt_app_kids/providers/account_provider.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final TextEditingController _nameTextController = TextEditingController();

  final double _changeWalletAmmountStep = 5;

  String _appVersion = "None";

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    var userName = Provider.of<AccountProvider>(context, listen: false).name;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _nameTextController.text = userName;
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    var walletProvider = Provider.of<WalletProvider>(context);
    var accountProvider = Provider.of<AccountProvider>(context);

    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Settings v$_appVersion",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 2,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextField(
                          controller: _nameTextController,
                          decoration: InputDecoration(hintText: "Name"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                          onChanged: (value) {
                            accountProvider.setName(value);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (accountProvider.age > 0) {
                                  accountProvider
                                      .setAge(accountProvider.age - 1);
                                }
                              },
                              icon: Icon(Icons.remove_circle_outline),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "${accountProvider.age} y.o.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                accountProvider.setAge(accountProvider.age + 1);
                              },
                              icon: Icon(Icons.add_circle_outline_outlined),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: walletProvider.totalAmount >= 0
                                  ? () {
                                      var newAmount =
                                          walletProvider.totalAmount -
                                              _changeWalletAmmountStep;
                                      if (newAmount < 0) {
                                        newAmount = 0;
                                      }
                                      walletProvider.setAmount(newAmount);
                                    }
                                  : null,
                              icon: Icon(Icons.remove_circle_outline),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "\$${walletProvider.totalAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                walletProvider.setAmount(
                                    walletProvider.totalAmount +
                                        _changeWalletAmmountStep);
                              },
                              icon: Icon(Icons.add_circle_outline_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Transactions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: walletProvider.transactions.isEmpty
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Are you sure you want to clear all transactions from the device?"),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    return Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("CANCEL"),
                                                  onPressed: () {
                                                    return Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        ).then((value) {
                                          if (value) {
                                            walletProvider.clearTransactions();
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      },
                                icon: Icon(Icons.delete),
                                label: Text(
                                  "Clear",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        if (walletProvider.transactions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "There are no trasactions. Please donate first.",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        if (walletProvider.transactions.isNotEmpty)
                          Column(
                            children:
                                walletProvider.transactions.map((transaction) {
                              var dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      transaction.timestamp);
                              var dateString = DateFormat("MMM dd hh:mm aaa")
                                  .format(dateTime);

                              return ListTile(
                                title: Text(
                                  dateString,
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Text(
                                  "\$${transaction.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
