import '../model/bill_details.dart';
import '../model/item_details.dart';
import '../model/item_fetch.dart';
import '../pages/single_bill_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class  SaveBillNameDialog extends StatefulWidget {

  bool isEditing;
  String id;
  SaveBillNameDialog(this.isEditing,this.id);
  @override
  _SaveBillNameDialogState createState() => _SaveBillNameDialogState();
}

class _SaveBillNameDialogState extends State<SaveBillNameDialog> {
  String _name;
  String _billusername;

  BillDetails bill;

  List<ItemDetails> tempItems;

  List<ItemDetails> _savedItems=[];

  List<BillDetails> bills;

  var form = GlobalKey<FormState>();

  FocusNode node = FocusNode();

  bool isValidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEditing) {
       bill = Provider.of<ItemFetcher>(context,listen: false).getBillById(widget.id);
      _billusername = bill.username;
      _name = bill.username;
    }
    else
      _billusername='';
  }


  void onDone(BuildContext context) {

    isValidate = form.currentState.validate();
    if(!isValidate)
      return;
    form.currentState.save();

    if(widget.isEditing)
      {
         _name = _name.substring(0,1).toUpperCase()+_name.substring(1,_name.length);
        tempItems = Provider.of<ItemFetcher>(context,listen: false).billListByCounter();
        try {
          for (ItemDetails value in tempItems)
            _savedItems.add(ItemDetails(id: value.id,
                name: value.name,
                price: value.price,
                counter: value.counter));
        }catch(e) {
          print(e.toString());
        }
        var totalAmount =  Provider.of<ItemFetcher>(context,listen: false).totalAmount;
        Provider.of<ItemFetcher>(context,listen: false).updateBill(bill.id,_name,totalAmount,_savedItems);
        node.unfocus();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx)=>SingleBillItem(bill.id)),
                (route) => route.isFirst);
      }
    else {
      _name = _name.substring(0,1).toUpperCase()+_name.substring(1,_name.length);
      tempItems =
          Provider.of<ItemFetcher>(context, listen: false).listByCounter();
      try {
        for (ItemDetails value in tempItems)
          _savedItems.add(ItemDetails(id: value.id,
              name: value.name,
              price: value.price,
              counter: value.counter));
      }catch(e) {
        print(e.toString());
      }
      double total = Provider.of<ItemFetcher>(context,listen: false).totalAmount;
      Provider.of<ItemFetcher>(context,listen: false).addBill(_name, _savedItems,total);
      Provider.of<ItemFetcher>(context,listen: false).resetCounterAndTotal();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top:10.0,
            left:10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom+10,
          ),
          child: Form(
            key: form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _billusername,
                  focusNode: node,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      hintText: "Enter Bill User Name",
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey)),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  textAlign: TextAlign.center,
                  onChanged: (String textTyped) {
                    _name = textTyped;
                  },
                  validator: (value) {
                    if(value.isEmpty)
                      return 'Please Enter Name';
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.black,
                                fontSize: MediaQuery.of(context).size.width* 0.05 )
                        )
                    ),
                    FlatButton(
                        onPressed: () {
                          onDone(context);
                        },
                        child: Text("Done",
                          style: TextStyle(color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width* 0.05),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}