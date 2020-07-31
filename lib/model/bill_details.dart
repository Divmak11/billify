import '../model/item_details.dart';
import 'package:flutter/foundation.dart';
class BillDetails with ChangeNotifier{

  final String id;
   String username;
   List<ItemDetails> bill_items;
   double totalAmount;
   DateTime datetime_stamp;

  BillDetails({
    @required this.id,
    @required this.username,
    @required this.bill_items,
    @required this.totalAmount,
    @required this.datetime_stamp

  });

  //Its not used in entire program as Bill is not saved as json only list of itemDetails is saved as json
  factory BillDetails.fromJson(dynamic json) {
    return BillDetails(
        id: json['id'] as String,
        username: json['username'] as String,
        bill_items : json['bill_items'] as List,
        totalAmount:  json['bill_total'] as double,
        datetime_stamp: json['datetime_stamp'] as DateTime);
  }

  Map toJson() {
    List<Map> billitems =
    this.bill_items != null ? this.bill_items.map((i) => i.toJson()).toList() : null;

    return {
      'id': id,
      'username': username,
      'bill_items': billitems,
      'bill_total': totalAmount,
      'datetime_stamp': datetime_stamp.toString()
    };
  }

}