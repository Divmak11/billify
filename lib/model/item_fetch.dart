import '../helpers/db_helper.dart';
import '../model/bill_details.dart';
import '../model/item_details.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
class ItemFetcher with ChangeNotifier{


  double totalAmount =0.0;
  List<ItemDetails> items =[

  ];
  List<BillDetails> bills =[];

  List<String> _itemId = [];
  List<ItemDetails> editingList = [];

  List<BillDetails> get billList
  {
    return [...bills];
  }

  List<ItemDetails> get itemList
  {
    return [...items];
  }
  List<ItemDetails> get editableList
  {
    return [...editingList];
  }


 List<ItemDetails> listByCounter() {

   List<ItemDetails> counterItems =[];
   items.forEach((element) {
     if(element.counter > 0)
       counterItems.add(element);
   });
    return counterItems;
  }


  void resetCounterAndTotal() {
    if(totalAmount>0)
      totalAmount = 0.0;

    for(var item in items)
      item.counter = 0;
    notifyListeners();
  }

  List<String> returnItemsId()
  {
   return _itemId;
  }

  void makeItemsIdList(List<String> itemsById)
  {
    _itemId.clear();
    _itemId.addAll(itemsById);
    notifyListeners();
  }

  void deleteItemById(String id)
  {
    var itemToDelete = items.firstWhere((element) => element.id == id);
    items.remove(itemToDelete);
    notifyListeners();
    DbHelper.deleteRecord('data',id);
  }


  void addItem(String name, double price)
  {
    var tempItem = ItemDetails(
        id: DateTime.now().toString(),
        name: name,
        price: price,
      counter: 0
    );
    items.add(
        tempItem
    );
    notifyListeners();
    DbHelper.insert(
        'data', {
      'id': tempItem.id,
      'item_name': tempItem.name,
      'item_price': tempItem.price,
      'counter': 0
    });
  }

  void updateItem(String id,String name,double price){

    var index = items.lastIndexWhere((element) => element.id == id);
    items[index].name =name;
    items[index].price =price;

    notifyListeners();

    DbHelper.updateItemRecord(
      'data',
      id,
      name,
      price
    );
  }

  void updateBill(String id,String name,double amount,List<ItemDetails> items){

    var index = bills.lastIndexWhere((element) => element.id == id);
    bills[index].username =name;
    bills[index].totalAmount =amount;
    bills[index].datetime_stamp = DateTime.now();
    bills[index].bill_items.clear();
    bills[index].bill_items.addAll(items);

    notifyListeners();

    String dateTime = bills[index].datetime_stamp.toString();
    String itemString = json.encode(items);

    DbHelper.updateBillRecord(
        'billdata',
        id,
        name,
        amount,
        dateTime,
        itemString
    );

  }

  void addBill(String username,List<ItemDetails> savedItems,double total){

    final tempBill =  BillDetails(
        id: DateTime.now().toString(),
        username: username,
        bill_items: savedItems,
        totalAmount: total,
        datetime_stamp: DateTime.now()
    );

    bills.add(tempBill);
    notifyListeners();

    String jsonEncodedBillItems = json.encode(savedItems);

    DbHelper.insert('billdata', {
      'id': tempBill.id,
      'bill_name': tempBill.username,
      'bill_items' : jsonEncodedBillItems,
      'bill_total': total.toString(),
      'bill_timestamp': tempBill.datetime_stamp.toString(),
    });
  }

  void makeEditableList(List<ItemDetails> list){
    editingList.clear();
    List<ItemDetails> tempList = [];
    tempList.addAll(items);
    totalAmount = 0;
    for(var listitem in list)
      {
        tempList.removeWhere((element) => element.id == listitem.id);
        totalAmount += listitem.price * listitem.counter;
      }
    editingList.addAll(list);
    editingList.addAll(tempList);
  }

  List<ItemDetails> billListByCounter() {

    List<ItemDetails> counterItems =[];
    editingList.forEach((element) {
      if(element.counter > 0)
        counterItems.add(element);
    });
    return counterItems;
  }

  BillDetails getBillById(String id) {
    var bill = bills.firstWhere((element) => element.id == id);
   return bill;
  }



  void deleteBillById(String id){

    var billToDelete = bills.firstWhere((element) => element.id == id);
    bills.remove(billToDelete);
    notifyListeners();
    DbHelper.deleteRecord('billdata',id);

  }

  void deleteAllBills()
  {
    bills.clear();
    notifyListeners();
  }


  Future<void> FetchAndSaveData() async{


    final dataList= await DbHelper.getData('data');
    items = dataList.map((item)=> ItemDetails(
      id: item['id'],
       name: item['item_name'],
        price: double.parse(item['item_price']),
      counter: item['counter'],
        )).toList();


    final billList= await DbHelper.getData('billdata');
    bills = billList.map((item){

      var billitemObjJson = jsonDecode(item['bill_items']) as List;
      List<ItemDetails> itemDetailObj = billitemObjJson.map((tagJson) => ItemDetails.fromJson(tagJson)).toList();

      return BillDetails(
        id: item['id'],
        username: item['bill_name'],
        bill_items: itemDetailObj,
        totalAmount: double.parse(item['bill_total']),
        datetime_stamp: DateTime.parse(item['bill_timestamp']),
      );
    }).toList();
    notifyListeners();
  }

  void IncToTotal(double amount)
  {
    totalAmount = totalAmount+amount;
    notifyListeners();
  }
  void RemFromTotal(double amount,int counter)
  {
    if(counter==0)
      return;
    totalAmount = totalAmount-amount;
    notifyListeners();
  }
}