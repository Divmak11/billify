import '../model/item_fetch.dart';
import '../size_config.dart';
import '../widgets/save_bill_with_name.dart';
import 'package:flutter/material.dart';
import '../widgets/add_new_item.dart';
import '../widgets/custom_list.dart';
import '../widgets/custom_row.dart';
import 'package:provider/provider.dart';

class Screen extends StatefulWidget {

  static const String routename = '/add-bill';
  const Screen({
    Key key,
  }) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool isSelect = false;
  int selectionCount = 0;
  bool isSelectAll =false;
  bool isDelete =false;
  int maxLength = 0;
  FocusNode searchNode = FocusNode();


  Future<bool> _backPressed() async{
    if(isSelect) {
      setState(() {
        isSelect = false;
      });
      return false;
    }
    Provider.of<ItemFetcher>(context,listen: false).resetCounterAndTotal();
    return true;
  }

    void _startAddItemProcess(BuildContext ctx)
    {

      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15))
          ),
          context: ctx, builder: (_) {
        return AddNewItem(
          id: null,
          itemName: null,
          itemPrice: 0.0,
        );
      });
    }

    void selectedItems(bool selection,int counter,int totalLength,bool selectAll)
    {


      if(!selectAll)
        isSelectAll = selectAll;

      maxLength =totalLength;
      setState(() {
        isSelect = selection;
        selectionCount = counter;
      });
    }

    void removeDeletion(bool value)
    {
        isDelete = value;
        setState(() {});
    }
    Widget SelectAll() {

      return IconButton(
          icon: Icon(Icons.select_all,color: Colors.white,size: 25,),
          onPressed: () {

            isSelectAll =true;
            selectionCount = maxLength;
            setState(() {});

          });
    }
  Widget Delete() {
            return  IconButton(icon:
            Icon(Icons.delete,color: Colors.white,size: 25,),
                  onPressed: () {
                isDelete =true;
                setState(() {
                });
            });
  }

    Widget buildAppbar(String title,Widget func1 , Widget func2) {

    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        leading: Container(
          child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            if(isSelect)
              {
                isSelect =false;
               isDelete =false;
               isSelectAll =false;
                setState(() {});
              }
            else
              {
                Provider.of<ItemFetcher>(context,listen: false).resetCounterAndTotal();
                Navigator.of(context).pop();
              }
          }),
        ),
        title:
        Text(title,style: TextStyle(fontSize: SizeConfig.screenWidth * 0.06,color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          func1,
          func2
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _backPressed,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:  isSelect ?
            buildAppbar(selectionCount.toString(),SelectAll(), Delete()):
          buildAppbar('Add bill', SaveBill(false,null,searchNode),
              IconButton(icon: Icon(Icons.add,color: Colors.white,size: 30,),
                  onPressed: () {
                searchNode.unfocus();
                _startAddItemProcess(context);
                  }
                  )),
          body:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8.0, right: 8.0,bottom: 8.0,top: 4),
                       child: SingleChildScrollView(
                          child: CustomListView(selectedItems,removeDeletion,isSelect,isSelectAll,isDelete,searchNode)
                    ),
                     ),
                ),
                CustomRow(),
              ]
          )
        ),
      ),
    );
  }
}

