import '../model/item_fetch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewItem extends StatefulWidget {
  final String id;
  final String itemName;
  final double itemPrice;

  AddNewItem({@required this.id,@required this.itemName,@required this.itemPrice});

  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {

  FocusNode _amountFocusNode = FocusNode();
  String _name;
  double _price;
  bool isValidate =false;
  var form = GlobalKey<FormState>();
  String _initialItemName ='';
  String _intitialItemPrice = '';
  bool _onEditing =false;


  void checkForData() {

    if(widget.itemName == null && widget.itemPrice == 0.0 && widget.id == null) {
      _initialItemName = '';
      _intitialItemPrice ='';
      _onEditing = false;
    }
    else {
      int itemprice = widget.itemPrice.toInt();
      _initialItemName = widget.itemName;
      _intitialItemPrice = itemprice.toString();
      _onEditing =true;
    }
  }

@override
  void initState() {
    super.initState();
    checkForData();
  }

  void onDone(BuildContext context) {

    isValidate = form.currentState.validate();
    if(!isValidate)
      return;
    form.currentState.save();

    if(_onEditing)
    {
      if(_name == null)
        _name=widget.itemName;

      if(_price == null)
        _price = widget.itemPrice;

      _name = _name.substring(0,1).toUpperCase()+_name.substring(1,_name.length);

      Provider.of<ItemFetcher>(context,listen: false).updateItem(widget.id,_name,_price);
    }
    else {
      _name = _name.substring(0,1).toUpperCase()+_name.substring(1,_name.length);
      Provider.of<ItemFetcher>(context, listen: false).addItem(_name, _price);
    }
    Navigator.of(context).pop();

  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
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
                  initialValue: _initialItemName,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      hintText: "Enter Product Name",
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey)),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  textAlign: TextAlign.center,
                  onChanged: (String textTyped) {
                    _name = textTyped;

                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
                  },
                  validator: (value) {
                    if(value.isEmpty)
                      return 'Please Enter Item Name';
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _intitialItemPrice,
                  decoration: InputDecoration(
                      hintText: "Enter Product Price",
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey)),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  focusNode: _amountFocusNode,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  textAlign: TextAlign.center,
                  onChanged: (String textTyped) {
                    _price = double.parse(textTyped);
                  },
                  validator: (String value){
                    if(value.isEmpty)
                      return 'Please Enter Price';
                    if(double.parse(value) <= 0)
                      return 'Please Provide a value greater than 0';
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
