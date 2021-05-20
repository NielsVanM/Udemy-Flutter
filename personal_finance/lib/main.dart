import 'package:flutter/material.dart';
import 'package:personal_finance/models/transaction.dart';
import 'package:personal_finance/widgets/chart.dart';

import 'package:personal_finance/widgets/new_transaction.dart';
import 'package:personal_finance/widgets/transaction_list.dart';

void main() => runApp(PersonalFinanceApp());

class PersonalFinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            button: TextStyle(
              color: Colors.white,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showNewTransactionPopup(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(
          addCallbackFunc: _addNewTransaction,
        );
      },
    );
  }

  final List<Transaction> transactions = [
    Transaction(id: "a", amount: 20, title: 'Bread', date: DateTime.now()),
    Transaction(id: "b", amount: 30, title: 'Plant', date: DateTime.now()),
    Transaction(id: "c", amount: 10, title: 'Gimmicks', date: DateTime.now()),
    Transaction(id: "d", amount: 1420, title: 'PC', date: DateTime.now()),
    Transaction(id: "e", amount: 0.20, title: 'Air', date: DateTime.now()),
    Transaction(id: "f", amount: 0.20, title: 'Air', date: DateTime.now()),
    Transaction(id: "g", amount: 0.20, title: 'Air', date: DateTime.now()),
    Transaction(id: "h", amount: 0.20, title: 'Air', date: DateTime.now()),
    Transaction(id: "i", amount: 0.20, title: 'Air', date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return transactions
        .where(
          (element) => element.date.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final t = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      transactions.add(t);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showNewTransactionPopup(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(
            txList: _recentTransactions,
          ),
          TransactionList(
            transactions: transactions,
            deleteTransaction: _deleteTransaction,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showNewTransactionPopup(context),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
