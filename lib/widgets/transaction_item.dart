// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:givt_app_kids/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({Key? key, required this.transaction})
      : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(transaction.timestamp);
    var dateString = DateFormat("MM/dd").format(dateTime);

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2DF7F),
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.goalName ?? 'Christ Pres Chruch -f',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF3B3240),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(
                dateString,
                style: TextStyle(
                  color: Color(0xFF3B3240),
                ),
              ),
              Spacer(),
              Text(
                "\$${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Color(0xFF3B3240),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
