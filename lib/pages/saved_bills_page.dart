
import '../model/bill_details.dart';
import '../model/item_fetch.dart';
import '../pages/single_bill_item.dart';
import '../size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../pages/homepage.dart';

import 'helper_page.dart';

class SavedBills extends StatefulWidget {
  static const String routename = '/saved-bills';

  @override
  _SavedBillsState createState() => _SavedBillsState();
}

class _SavedBillsState extends State<SavedBills> {


  List<int> selectedItems = [];
  bool isSelected = false;
  int _itemsLength = 0;
  List<String> billsToDeleteList = [];
  List<BillDetails> _bills;


  Widget buildRow() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                selectedItems.clear();
                billsToDeleteList.clear();
                isSelected = false;
                setState(() {});
              }),
          Text(selectedItems.length.toString(),
            style: TextStyle(color: Colors.white),),
          Expanded(child: Container(),),
          IconButton(icon: Icon(Icons.select_all, color: Colors.white,),
              onPressed: () {
                selectedItems.clear();
                billsToDeleteList.clear();
                for (int i = 0; i < _itemsLength; i++) {
                  selectedItems.add(i);
                  billsToDeleteList.add(_bills[i].id);
                }
                setState(() {});
              }),
          IconButton(icon: Icon(Icons.delete, color: Colors.white,),
              onPressed: () async {
                isSelected = false;
                bool value = await showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        backgroundColor: Colors.teal,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        title: Text(
                            "Confirmation!", style: TextStyle(color: Colors
                            .white,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.05)),
                        content: Text('Do you want to Delete it ?',
                          style: TextStyle(color: Colors.white,
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.05),),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.white,
                                      fontSize: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.05)
                              )
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text("Done",
                                style: TextStyle(color: Colors.white,
                                    fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.05),
                              ))
                        ],
                      );
                    });
                if (value) {
                  if (billsToDeleteList.length == _bills.length) {
                    Provider.of<ItemFetcher>(context, listen: false)
                        .deleteAllBills();
                  }
                  else {
                    for (int i = 0; i < billsToDeleteList.length; i++)
                      Provider.of<ItemFetcher>(context, listen: false)
                          .deleteBillById(
                          billsToDeleteList[i]);
                  }
                  setState(() {
                    selectedItems.clear();
                    billsToDeleteList.clear();
                  });
                }
              })

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ItemFetcher>(context, listen: false).FetchAndSaveData().then((
        value) {
      setState(() {});
    });
    checkForPermission();
  }

  Future<void> checkForPermission() async {
    var result = await Permission.storage.request();
    if (!result.isGranted)
      //show Error Snackbar for pdf
      print("error");
  }


  void toggleSelection(int index, String id) {
    if (selectedItems.length > 0) {
      bool notAdded = false;
      for (var item in selectedItems) {
        if (item == index) {
          notAdded = false;
          selectedItems.remove(item);
          billsToDeleteList.remove(id);
          break;
        }
        else
          notAdded = true;
      }

      if (notAdded) {
        billsToDeleteList.add(id);
        selectedItems.add(index);
      }
    }
    else {
      selectedItems.add(index);
      billsToDeleteList.add(id);
    }

    if (selectedItems.length > 0)
      isSelected = true;
    else
      isSelected = false;

    setState(() {});
  }

  Widget buildSelectedContainer(int index, String id) {
    return GestureDetector(
        onTap: () {
          toggleSelection(index, id);
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Card(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))
                ),
                elevation: 8,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('Items : \n ${_bills[index].bill_items[0]
                        .name} ${_bills[index].bill_items[0]
                        .price} x${_bills[index].bill_items[0].counter}..'
                      , style: TextStyle(color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.045),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,)),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              child: Container(
                width: SizeConfig.screenWidth * 0.40,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                color: Colors.grey,
                child: Text(
                  _bills[index].username,
                  style: TextStyle(fontSize: SizeConfig.screenWidth * 0.055,
                    color: Colors.white,),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget buildNormalContainer(int index, String id) {
    return GestureDetector(
        onTap: () {
          toggleSelection(index, id);
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))
                ),
                elevation: 8,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('Items : \n ${_bills[index].bill_items[0]
                        .name} ${_bills[index].bill_items[0]
                        .price} x${_bills[index].bill_items[0].counter}..'
                      , style: TextStyle(color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.045),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              child: Container(
                width: SizeConfig.screenWidth * 0.40,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                color: Colors.blueGrey,
                child: Text(
                  _bills[index].username,
                  style: TextStyle(fontSize: SizeConfig.screenWidth * 0.055,
                    color: Colors.white,),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget buildAppBar() {
    return
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Spacer(flex: 1),
        Align(
          alignment: Alignment.center,
          child: Text("Billify",
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.screenWidth * 0.06,
              fontWeight: FontWeight.w600,),
          ),
        ),
        Spacer(flex: 1),
        Container(
          width: 25,
          child: PopupMenuButton(
              onSelected: (selectedValue)
              {
                if(selectedValue == 0)
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx)=> HelpPage())
                  );
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
              PopupMenuItem(child: Text("Help",style: TextStyle(
                fontSize: 18
              ),),value: 0),
          ]
          )
    )
          ],
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
    _bills = Provider
        .of<ItemFetcher>(context, listen: true)
        .billList;
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: isSelected ?
            buildRow() :
            buildAppBar(),
            elevation: 6,
            backgroundColor: Colors.teal,
          ),
        ),
        body: _bills.length > 0 ? Padding(
          padding: const EdgeInsets.all(14.0),
          child: GridView.builder(
              itemCount: _bills.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (ctx, index) {
                if (selectedItems.length > 0) {
                  for (var item in selectedItems) {
                    if (item == index)
                      return buildSelectedContainer(index, _bills[index].id);
                  }

                  return buildNormalContainer(index, _bills[index].id);
                }
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (ctx) => SingleBillItem(_bills[index].id)));
                    },
                    onLongPress: () {
                      _itemsLength = _bills.length;
                      toggleSelection(index, _bills[index].id);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))
                            ),
                            elevation: 8,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Items : \n ${_bills[index].bill_items[0]
                                      .name} ${_bills[index].bill_items[0]
                                      .price} x${_bills[index].bill_items[0]
                                      .counter}..'
                                  , style: TextStyle(color: Colors.black,
                                    fontSize: SizeConfig.screenWidth * 0.045),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          child: Container(
                            width: SizeConfig.screenWidth * 0.40,
                            padding: EdgeInsets.symmetric(vertical: 5,
                                horizontal: 20),
                            color: Colors.blueGrey,
                            child: Text(
                              _bills[index].username,
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth * 0.055,
                                color: Colors.white,),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    )
                );
              }
          ),
        ) : Center(
          child: Text('No Bills Added Yet!',
            style: TextStyle(color: Colors.black,
                fontSize: SizeConfig.screenWidth * 0.06),),
        ),
        floatingActionButton: Container(
          height: SizeConfig.screenWidth * 0.15,
          width: SizeConfig.screenWidth * 0.15,
          child: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add, size: 30,),
            onPressed: () {
              Navigator.pushNamed(context, Screen.routename);
            },
          ),
        ),
      ),
    );
  }
}
