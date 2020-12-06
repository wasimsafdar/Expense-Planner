import 'dart:io';
import 'package:expense_planner/Widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './Widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import 'Models/transaction.dart';
import 'Widgets/transactionList.dart';
import './Widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); //So it would run on all devices
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return Platform.isIOS? CupertinoApp(
    //   title: 'Personal Expenses',
    //   home: MyHomePage(),
    //   theme: CupertinoThemeData(
    //     prim
    //     primarySwatch: Colors.purple,
    //     accentColor: Colors.amber,
    //     fontFamily: 'OpenSans',
    //     appBarTheme: AppBarTheme(
    //         textTheme: ThemeData.light().textTheme.copyWith(
    //           title: TextStyle(
    //             fontFamily: 'Quicksand',
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold,
    //           ),
    //           button: TextStyle(color: Colors.white),
    //         )),
    //   ),
    // ):
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'OpenSans',
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  button: TextStyle(color: Colors.white),
                )),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;

  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'new shoes', amount: 99.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2', title: 'wrist watch', amount: 69.99, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

@override
  void initState() {
    // TODO: implement initState
  //Widget binding tells that whenever, my app life cycle changes add the observer
  // and the didChangeAppLifecycleState() is called.
  WidgetsBinding.instance.addObserver(this);
  super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void _addNewTransaction(String txtitle, double amount, DateTime chosenDate) {
    final nTx = Transaction(
        id: DateTime.now().toString(),
        title: txtitle,
        amount: amount,
        date: chosenDate);
    setState(() {
      _userTransactions.add(nTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction));
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }



  List <Widget> _buildLandscapeContent(MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txWidget) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
          //With adaptive, you can adjust to iOS look
          activeColor: Theme.of(context).accentColor,
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        ),
      ],
    ),  _showChart
        ? Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.7,
        child: Chart(_recentTransactions))
        : txWidget];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txWidget
    ];
  }

  Widget _buildCupertinoBar(){
    return  CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context))
      ],
    );
  }
  //////////////////////
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = (Platform.isIOS
        ? _buildCupertinoBar():_buildAppBar()) as PreferredSizeWidget;

    final txWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar, txWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            body: pageBody,
          );
  }
}
