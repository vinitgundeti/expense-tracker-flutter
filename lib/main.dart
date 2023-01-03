import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:udemy_two_expense_tracker/widgets/chart.dart';
import '../models/transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';

void main() {
  // to prevent landscape mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  // );
  runApp(MaterialApp(
    title: 'Expense Tracker',
    theme: ThemeData(
      primarySwatch: Colors.purple,
      fontFamily: 'WorkSans',
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'Sevillana', fontSize: 30)),
      textTheme: ThemeData.light().textTheme.copyWith(
            titleLarge:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date!.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void addNewTransaction(
      String inputTitle, double inputAmount, DateTime selectedDate) {
    var newTx = Transaction(
      id: DateTime.now().toString(),
      title: inputTitle,
      amount: inputAmount,
      date: selectedDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: ((_) {
        return NewTransaction(addNewTransaction);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    var appBar = AppBar(
      title: const Text(
        'Expense Tracker',
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(Icons.add),
        )
      ],
    );

    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransction),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Chart'),
                  Switch.adaptive(
                      activeColor: Theme.of(context).primaryColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandScape)
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandScape) txListWidget,
            if (isLandScape)
              _showChart
                  ? SizedBox(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget,
          ],
        ),
      ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () {
                _startAddNewTransaction(context);
              },
              child: const Icon(Icons.add))
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
