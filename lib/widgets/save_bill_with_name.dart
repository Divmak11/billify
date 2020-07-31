import '../dialogs/save_bill_name_dialog.dart';
import '../model/item_fetch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SaveBill extends StatefulWidget {

  bool isEditing;
  String id;
  FocusNode node;
  SaveBill(this.isEditing,this.id,[this.node]);
  @override
  _SaveBillState createState() => _SaveBillState();
}

class _SaveBillState extends State<SaveBill> {

  final snackBar = SnackBar(
    duration: Duration(milliseconds: 800),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
      content: Text('Select Items First',style: TextStyle(
        fontSize: 17,
      ),
      textAlign: TextAlign.center,)
  );

// Find the Scaffold in the widget tree and use it to show a SnackBar.

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.save,size: 25,),
        onPressed: () {
     if(widget.node !=null)
       widget.node.unfocus();
      var list;
      if(widget.isEditing)
        list =  Provider.of<ItemFetcher>(context,listen: false).billListByCounter();
      else
          list =  Provider.of<ItemFetcher>(context,listen: false).listByCounter();

         if(list.length > 0)
           {
               showModalBottomSheet(
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(15),
                           topRight: Radius.circular(15))
                   ),
                   context: context, builder: (_) {
                 return SaveBillNameDialog(widget.isEditing, widget.id);
               });
             }
         else
           {
             Scaffold.of(context).showSnackBar(snackBar);
           }
    });
  }
}
