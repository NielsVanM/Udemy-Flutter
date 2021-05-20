import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/models/transaction.dart';
import 'package:personal_finance/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> txList;

  const Chart({Key key, this.txList}) : super(key: key);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (i) {
      final weekDay = DateTime.now().subtract(
        Duration(days: i),
      );
      double totalSum = 0;

      for (int i = 0; i < txList.length; i++) {
        if (txList[i].date.day == weekDay.day &&
            txList[i].date.month == weekDay.month &&
            txList[i].date.year == weekDay.year) {
          totalSum += txList[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data["day"],
                spendingAmount: data["amount"],
                spendingPctOfTotal: maxSpending == 0.0
                    ? 0.0
                    : (data["amount"] as double) / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
