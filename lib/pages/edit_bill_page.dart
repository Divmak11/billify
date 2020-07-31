
import '../model/item_fetch.dart';
import '../widgets/edit_list_view.dart';
import '../widgets/save_bill_with_name.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_row.dart';
import 'package:provider/provider.dart';

class EditBillPage extends StatefulWidget {

  static const String routename = '/edit-bill';

  @override
  _EditBillPageState createState() => _EditBillPageState();
}

class _EditBillPageState extends State<EditBillPage> {
  bool isSelect = false;
  int selectionCount = 0;
  bool isSelectAll =false;
  bool isDelete =false;

  int maxLength = 0;

  Widget buildAppbar(String title,Widget func1) {

    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        leading: Container(
          child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {

            Provider.of<ItemFetcher>(context,listen: false).resetCounterAndTotal();
              Navigator.of(context).pop();
          }),
        ),
        title:
        Text(title,style: TextStyle(fontSize: 22,color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          func1,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final String id = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:
          buildAppbar('Edit bill', SaveBill(true,id)),
          body:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0,bottom: 8.0),
                    child: SingleChildScrollView(
                        child: EditListView()
                    ),
                  ),
                ),
                CustomRow()
              ]
          )
      ),
    );
  }
}

