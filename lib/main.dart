//import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future load(Locale locale) => DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //initializeDateFormatting('fr_FR', null);
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // TODO: uncomment the line below after codegen
        //AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: [
        //const Locale('en', ''), // English, no country code
        const Locale('fr', 'FR'), // French, no country code
      ],
      title: 'La banque',
      theme: ThemeData(
        canvasColor: Colors.transparent,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color.fromARGB(255, 41, 45, 62),
        textTheme: Typography.whiteCupertino,
        accentColor: Colors.indigo[500],
        cardColor: Colors.black26,
        fontFamily: 'Calibri',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      double availableHeight, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ma semaine'),
          Switch(
            activeColor: Colors.indigo,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: availableHeight * 0.7, child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      double availableHeight, Widget txListWidget) {
    return [
      Container(
        height: availableHeight * 0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    //var safePadding = MediaQuery.of(context).padding.top;
    final availableHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    print(availableHeight);
    final txListWidget = Container(
      height: availableHeight * 0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('La banque'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: () => _startAddNewTransaction(context),
      //     ),
      //   ],
      // ),
      body: MyBody(isLandscape, availableHeight, txListWidget),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }

  SafeArea MyBody(
      bool isLandscape, double availableHeight, Container txListWidget) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(availableHeight, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(availableHeight, txListWidget),
          ],
        ),
      ),
    );
  }
}
