import '../Models/transaction.dart';
import '../Widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  //Using listView
  /*
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Container(
      height: 300,
      child: ListView(
          children: transactions.map((tx) {
            //tx is transaction
            return Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '\$${tx.amount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.purple),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2)),
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tx.title,
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('yyyy/MM/dd').format(tx.date),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ));
          }).toList()),
    );
  }
  */

  //Using ListView Builder
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Container(
    //   //height: MediaQuery.of(context).size.height*0.6, //60% of available height
    //   child:
       return transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints){
            return Column(
              children: <Widget>[
                Text(
                  'No Transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: constraints.maxHeight*0.6,
                    child: Image.asset(
                      'assets/images/z1.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
       })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                //tx is transaction
                return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
              },
              itemCount: transactions.length,
    );
  }
}


