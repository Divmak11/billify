
import '../dialogs/delete_item_dialog.dart';
import '../widgets/add_new_item.dart';
import 'package:flutter/material.dart';
import '../model/item_details.dart';
import '../model/item_fetch.dart';
import '../size_config.dart';
import '../widgets/single_item_view.dart';
import 'package:provider/provider.dart';
class EditListView extends StatefulWidget {


  @override
  EditListViewState createState() => EditListViewState();
}

class EditListViewState extends State<EditListView> {

  List<int> selectedItems =[];
  bool isSelected=false;
  final _textEditingController = TextEditingController();
  List<ItemDetails> items =[];
  List<ItemDetails> listDetails =[];
  List<String> itemsIdToDelete = [];
  int lengthOfList = 0;
  int listLength = 0;
  int counter = 0;
  bool isSelectAll = false;
  bool toDelete =false;

  @override
  void initState() {
    super.initState();
    listDetails = Provider.of<ItemFetcher>(context,listen: false).editableList;
    items = listDetails;
    lengthOfList =listDetails.length;
    listLength = listDetails.length;
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
  Widget searchBar() {
    return listLength > 0 ? isSelected ? Container(
      height: SizeConfig.screenHeight * 0.06,
    ) : Container(
      height: SizeConfig.screenHeight * 0.06,
      child: TextField(
        controller: _textEditingController,
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
  Widget customList() {
    listDetails = Provider.of<ItemFetcher>(context,listen:  false).editableList;
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
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context,i) {
                  return ChangeNotifierProvider.value(
                      value: items[i],
                      child: GestureDetector(
                          child: SingleItemListView(Color.fromRGBO(63, 224, 208, 1),isSelected)
                      ));
                }
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return   Column(
        children: <Widget>[
          SizedBox(height: 5,),
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
