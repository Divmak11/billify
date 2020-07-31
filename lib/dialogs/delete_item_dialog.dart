import 'package:flutter/material.dart';
import '../model/item_fetch.dart';
import 'package:provider/provider.dart';

class DialogShower extends StatelessWidget {

  void onConfirm(BuildContext context) {

    var itemsId = Provider.of<ItemFetcher>(context,listen: false).returnItemsId();
    for(var item in itemsId)
    Provider.of<ItemFetcher>(context,listen: false).deleteItemById(item);
  }

  Future<bool> awaitReturnValueFromSecondScreen(BuildContext context) async{
   return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.teal,
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Confirmation!", style: TextStyle(color: Colors.white,
                fontSize: MediaQuery.of(context).size.width* 0.05 )),
            content: Text('Do you want to Delete it ?', style: TextStyle(color: Colors.white,
                fontSize: MediaQuery.of(context).size.width* 0.05 ),),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context,false);
                  },
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width* 0.05 )
                  )
              ),
              FlatButton(
                  onPressed: () {
                    onConfirm(context);
                    Navigator.pop(context,true);
                  },
                  child: Text("Done",
                    style: TextStyle(color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width* 0.05),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
