
import 'dart:io';
import '../model/item_details.dart';
import '../pages/edit_bill_page.dart';
import '../size_config.dart';
import '../widgets/pdf_maker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../model/item_fetch.dart';
import '../model/bill_details.dart';
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class SingleBillItem extends StatelessWidget {


  final String id;
  SingleBillItem(this.id);
  BillDetails _bill;


  Widget makeText(String text)
  {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: SizeConfig.screenWidth * 0.048,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );

  }

  Widget makeTitleText(String text)
  {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: SizeConfig.screenWidth * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.w500
      ),
    );

  }

  Widget buildMailTypeCard(BuildContext context, String data) {
    return Container(
      height: SizeConfig.screenHeight * 0.60,
      width: SizeConfig.screenWidth * 0.85,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: makeTitleText('Name :'),
                  title: makeText(_bill.username),
                ),
                Divider(thickness: 1,color: Colors.black54,),
                ListTile(
                  leading: makeTitleText('Generated \nOn :'),
                  title: makeText( DateFormat('yyyy-MM-dd \nkk:mm').format(_bill.datetime_stamp)),
                ),
                Divider(thickness: 1,color: Colors.black54,),
                ListTile(
                  leading: makeTitleText('Items:'),
                ),
                Container(
                  height: SizeConfig.screenHeight *0.15,
                  child: ListView.builder(
                    itemCount: _bill.bill_items.length,
                      itemBuilder: (context,index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: SizeConfig.screenWidth * 0.85 /3,
                              child: makeText(_bill.bill_items[index].name)),
                          Container(
                            width : SizeConfig.screenWidth * 0.85 /4,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                  child: makeText(_bill.bill_items[index].price.toStringAsFixed(2)))),
                          Container(
                            width: SizeConfig.screenWidth * 0.85 /5,
                              child: Align(
                                alignment: Alignment.center,
                                  child: makeText('x${_bill.bill_items[index].counter.toString()}'))),
                        ],
                      );
                      }),
                ),
                Divider(thickness: 1,color: Colors.black54,),
               ListTile(
                 leading: makeTitleText('Total Amount : '),
                 title: makeText(_bill.totalAmount.toStringAsFixed(2)),
               ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget buildMaterialCard(IconData icon,Function function,BuildContext ctx) {
    return Container(
      height: SizeConfig.screenWidth * 0.16,
      width: SizeConfig.screenWidth * 0.20,
      child: Align(
        alignment: Alignment.center,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: IconButton(
              onPressed: ()=> function(ctx),
            icon: Icon(icon),
          )
        ),
      ),
    );
  }

  void shareBill(BuildContext context)
  {
    String items='';
    for(ItemDetails i in _bill.bill_items)
      {
        items = items+' '+'${i.name}  ${i.price}  x${i.counter} \n';
      }
    String totalBillText = 'Your Bill is : '+'\n'+
                            'Name : ${_bill.username} \n ' +
                            'Items : \n'+
                             items+'\n'+'Total is : ${_bill.totalAmount} \n';
    final RenderBox box = context.findRenderObject();
    Share.share(
        totalBillText,
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) &
        box.size);
  }
  void editBill(BuildContext context)
  {
        Provider.of<ItemFetcher>(context,listen: false).makeEditableList(_bill.bill_items);
        Navigator.of(context).pushNamed(EditBillPage.routename,arguments: _bill.id);
    return;
  }
  void deleteBill(BuildContext context)
  {

    showDialog(
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
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width* 0.05 )
                  )
              ),
              FlatButton(
                  onPressed: () {
                    Provider.of<ItemFetcher>(context,listen: false).deleteBillById(_bill.id);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text("Done",
                    style: TextStyle(color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width* 0.05),
                  ))
            ],
          );
        });
  }

  void saveAsPDF(BuildContext ctx) async{

    Scaffold.of(ctx).hideCurrentSnackBar();
    String name = _bill.username.substring(0,1).toUpperCase()+_bill.username.substring(1,_bill.username.length);
    final snackbar = SnackBar(content: Text('Saved PDF to Storage/Billify/$name.pdf'
      ,style: TextStyle(
      fontSize: 17,
     ),
      textAlign: TextAlign.center,
     ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.floating,
    );

    final pdf = PdfMaker().makePdf(
      name: name,
      id: _bill.id,
      items: _bill.bill_items,
      timeStamp: _bill.datetime_stamp.toString(),
      total: _bill.totalAmount.toStringAsFixed(2)
    );

    var status  = await Permission.storage.request().isGranted;
    print(status);
    if(status)
    {
      //Created new folder in External Storage, makes new folder if not existed else works smoothly
      final myDir = new Directory('storage/emulated/0/Billify');
      myDir.exists().then((isThere) async{
        if(isThere)
        {
          final file = File('storage/emulated/0/Billify/${_bill.username}.pdf');
          await file.writeAsBytes(pdf.save()).then((value) => Scaffold.of(ctx).showSnackBar(snackbar));
        }
        else
        {
          new Directory('storage/emulated/0/Billify').create(recursive: true).then((value) async{
            final file = File('storage/emulated/0/Billify/${_bill.username}.pdf');
            await file.writeAsBytes(pdf.save()).then((value) => Scaffold.of(ctx).showSnackBar(snackbar));

          });
        }
      });
    }
    else
      {
        await Permission.storage.request();
      }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _bill = Provider.of<ItemFetcher>(context,listen: false).getBillById(id);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.tealAccent,
          body: Builder(
            builder: (ctx)=> Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: SizeConfig.screenHeight * 0.03,),
                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.arrow_back,size: 25,), onPressed: () {
                        Navigator.of(context).pop();
                      }),
                      SizedBox(width: 10,),
                      Text('Bill Details',style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.06,
                          color: Colors.black,fontWeight: FontWeight.w500
                      ),)

                    ],
                  ),
                  SizedBox(height: 20,),
                  buildMailTypeCard(context, "data"),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildMaterialCard(Icons.share,shareBill,context),
                      buildMaterialCard(Icons.edit,editBill,context),
                      buildMaterialCard(Icons.delete,deleteBill,context),
                      buildMaterialCard(Icons.file_download,saveAsPDF,ctx)
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

//To choose file from selected folder like downloads or any
//Use Uri.parse(pathProvider.getExternalStorage().pathname + nameOfFolder);
//Then pas this to onPressed using android_intent package
//pass this to intent dataType and pas setData if want to select particular type of files
