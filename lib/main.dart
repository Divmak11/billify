import './pages/edit_bill_page.dart';
import './pages/homepage.dart';
import './pages/saved_bills_page.dart';
import 'package:flutter/material.dart';
import './model/item_fetch.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ItemFetcher(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home:  SavedBills(),
        routes: {
          Screen.routename : (ctx) => Screen(),
          SavedBills.routename :(ctx)=> SavedBills(),
          EditBillPage.routename : (ctx)=> EditBillPage(),
//          SingleBillItem.routename : (ctx)=> SingleBillItem(null),
        },
      )
      );
  }
}


