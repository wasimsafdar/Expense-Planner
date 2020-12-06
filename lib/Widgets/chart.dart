import 'package:expense_planner/Models/transaction.dart';
import 'package:expense_planner/Widgets/chat_bar.dart';
import 'package:flutter/material.dart';
import '../Models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions); //constructor

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      //With this we can get different days in Weekday
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      print(totalSum);
      print(DateFormat.E().format(weekday));

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(groupedTransactionValues);
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0
                        ? 0
                        : (data["amount"] as double) / totalSpending),
              );
            }).toList(),
          ),
        ),
    );
  }
}
