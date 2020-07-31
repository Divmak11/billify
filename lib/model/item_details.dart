import 'package:flutter/foundation.dart';

class ItemDetails with ChangeNotifier
{
  final String id;
   String name;
   double price;
  int counter;

  ItemDetails({@required this.id,@required this.name,@required this.price,@required this.counter});

  //Factory constructor which should be there to convert normal json to object
  factory ItemDetails.fromJson(dynamic json) {
    return ItemDetails(id: json['id'] as String,name: json['name'] as String,price : json['price'] as double,counter: json['counter'] as int);
  }

  //Function which must be there to convert object or list of object to json
  Map toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'counter' : counter
    };
  }

  void incCounter()
  {
    counter++;
    notifyListeners();
  }
  void decCounter()
  {
    if(counter == 0)
      return;
    counter--;
    notifyListeners();
  }



}
