
import '../dialogs/delete_item_dialog.dart';
import '../widgets/add_new_item.dart';
import 'package:flutter/material.dart';
import '../model/item_details.dart';
import '../model/item_fetch.dart';
import '../size_config.dart';
import '../widgets/single_item_view.dart';
import 'package:provider/provider.dart';

class CustomListView extends StatefulWidget {

  Function function;
  Function removeDelFn;
  bool reset;
  bool toDelete;
  bool isSelectAll;
  FocusNode node;
  CustomListView(this.function,this.removeDelFn,this.reset,this.isSelectAll,this.toDelete,this.node);
  @override
  CustomListViewState createState() => CustomListViewState();
}

class CustomListViewState extends State<CustomListView> {

  List<int> selectedItems =[];
  bool isSelected=false;
  final _textEditingController = TextEditingController();
  List<ItemDetails> items =[];
  List<ItemDetails> listDetails =[];
  List<String> itemsIdToDelete = [];
  int lengthOfList = 0;
  int listLength = 0;
  int counter = 0;
  int _itemsLength =0;
  bool isSelectAll = false;
  bool toDelete =false;
  int showTime = 0;
  FocusNode searchNode ;

  final snackBar = SnackBar(
      duration: Duration(milliseconds: 800),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Text('Cannot Be Edited While Selected',style: TextStyle(
        fontSize: 17,
      ),
        textAlign: TextAlign.center,)
  );

  @override
  void initState() {
    super.initState();
    listDetails = Provider.of<ItemFetcher>(context,listen: false).itemList;
    items = listDetails;
    lengthOfList =listDetails.length;
    listLength = listDetails.length;
    searchNode = widget.node;
    _textEditingController.addListener(() {
      filterResults(_textEditingController.text);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void filterResults(String query) {

    List<ItemDetails> dummySearchList = List<ItemDetails>();
    dummySearchList.addAll(listDetails);
    if(query.isNotEmpty) {
      List<ItemDetails> dummyListData = List<ItemDetails>();
      dummySearchList.forEach((item) {
        if(item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(listDetails);
      });
    }
  }

  void toggleSelection(int index,String id)
  {
    if(selectedItems.length > 0)
    {
      if(isSelectAll)
        {
          isSelectAll =false;
        }
        bool notAdded = false;
        for (var item in selectedItems) {
          if (item == index) {
            notAdded = false;
            selectedItems.remove(item);
            itemsIdToDelete.remove(id);
            Provider.of<ItemFetcher>(context,listen: false).makeItemsIdList(itemsIdToDelete);
            break;
          }
          else
            notAdded = true;
        }

        if (notAdded) {
           itemsIdToDelete.add(id);
          selectedItems.add(index);
           Provider.of<ItemFetcher>(context,listen: false).makeItemsIdList(itemsIdToDelete);
        }
      }
    else {
      selectedItems.add(index);
      itemsIdToDelete.add(id);
      Provider.of<ItemFetcher>(context,listen: false).makeItemsIdList(itemsIdToDelete);
    }

    if(selectedItems.length > 0)
      isSelected = true;
    else
      isSelected = false;

    setState(() {});
  }

  Widget searchBar() {
    return listLength > 0 ? isSelected ? Container(
      height: SizeConfig.screenHeight * 0.06,
    ) : Container(
      height: SizeConfig.screenHeight * 0.06,
      child: TextField(
        controller: _textEditingController,
        focusNode: searchNode,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.only(left: 15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Search...",
       ),
      ),
    ): Container(
      height: SizeConfig.screenHeight * 0.06,
    );
  }
  void _startAddItemProcess(BuildContext ctx,String itemName,double itemPrice,String itemId)
  {

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15))
        ),
        context: ctx, builder: (_) {
      return AddNewItem(
        id: itemId,
        itemName: itemName,
        itemPrice: itemPrice,
      );
    });
  }

  Widget buildSelectedTile(int index,String id)
  {
    return  ChangeNotifierProvider.value(
        value: items[index],
        child: GestureDetector(

            onTap: () {
              if(isSelected) {
                toggleSelection(index, id);
                widget.function(isSelected,selectedItems.length,_itemsLength,isSelectAll);
              }
              else
              _startAddItemProcess(context, items[index].name, items[index].price,items[index].id);
            },
            child: SingleItemListView(Colors.grey,isSelected)
        ));
  }
  Widget buildNormalItem(int index,String id)
  {
    return ChangeNotifierProvider.value(
        value: items[index],
        child: GestureDetector(
            onTap: () {
              if(isSelected) {
                toggleSelection(index, id);
                widget.function(isSelected,selectedItems.length,_itemsLength,isSelectAll);
              }
              else
              _startAddItemProcess(context, items[index].name, items[index].price,items[index].id);
            },
            child: SingleItemListView(Color.fromRGBO(63, 224, 208, 1),isSelected)
        ));
  }

  Widget customList() {
   listDetails = Provider.of<ItemFetcher>(context,listen:  false).itemList;
   listLength = listDetails.length;
    if(listDetails.length > lengthOfList)
      {
        lengthOfList =listDetails.length;
        items = listDetails;
      }

    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          height: SizeConfig.screenHeight * 0.72,
          width: double.infinity,
          child: listDetails.length > 0 ? ListView.builder(
           itemCount: items.length,
           itemBuilder: (context,i) {

             if(selectedItems.length > 0)
               {
                 for(var item in selectedItems) {
                   if (item == i)
                     return buildSelectedTile(i,items[i].id);
                 }
                 return buildNormalItem(i,items[i].id);
               }
             return ChangeNotifierProvider.value(
                 value: items[i],
                 child: GestureDetector(
                     onLongPress: () {
                         setState(() {
                           searchNode.unfocus();
                           isSelected = true;
                           _itemsLength = listDetails.length;
                           toggleSelection(i,listDetails[i].id);
                           widget.function(isSelected,selectedItems.length,_itemsLength,isSelectAll);
                         });
                     },
                     onTap: () {
                       searchNode.unfocus();
                       if(items[i].counter > 0)
                         {
                           showTime++;
                           if(showTime > 2)
                             return;
                           else
                           Scaffold.of(context).showSnackBar(snackBar);
                         }
                       else {
                         showTime = 0;
                         _startAddItemProcess(
                             context, items[i].name, items[i].price,
                             items[i].id);
                       }
                     },
                     child: SingleItemListView(Color.fromRGBO(63, 224, 208, 1),isSelected)
                 ));
           }
          ): Center(
            child: Padding(
           padding: const EdgeInsets.all(4.0),
           child: Text('No Saved Products. Click Add to add Items!',
               style: TextStyle(color: Colors.black,fontSize: SizeConfig.screenWidth * 0.05)),
            ),
    )
        )
    );
  }

  void  deleteItem() async
  {
    widget.removeDelFn(false);
    if(isSelectAll)
      {

        for(int i=0;i<listDetails.length;i++) {
          itemsIdToDelete.add(listDetails[i].id);
        }
        Provider.of<ItemFetcher>(context, listen: false).makeItemsIdList(
            itemsIdToDelete);
      }
    bool value = await DialogShower().awaitReturnValueFromSecondScreen(context);
    if(value)
      setState(() {
        lengthOfList = 0;
        isSelected =false;
        selectedItems.clear();
        listDetails.clear();
        items.clear();
        listLength =  Provider.of<ItemFetcher>(context,listen:  false).itemList.length;
        isSelectAll =false;
        itemsIdToDelete.clear();
        widget.function(isSelected,selectedItems.length,_itemsLength,isSelectAll);
      });
  }
  @override
  Widget build(BuildContext context) {

    if(!widget.reset)
      {
        isSelected = false;
        selectedItems.clear();
      }
    if(widget.isSelectAll) {
      isSelectAll = true;
      selectedItems.clear();
      itemsIdToDelete.clear();
      for(int i=0;i<lengthOfList;i++)
      {
        selectedItems.add(i);
      }
    }

    if(widget.toDelete) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => deleteItem());
    }

    SizeConfig().init(context);
    return   Column(
        children: <Widget>[
         searchBar(),
         Consumer<ItemFetcher>(
           builder:(ctx,data,child) {
             return  customList();
           },
         )

        ]
    );
  }
}
