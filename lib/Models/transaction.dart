//This is a transaction class similar to data class
import 'package:flutter/foundation.dart';

class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;

  //Construction
  Transaction({
      @required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
}
