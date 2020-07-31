
import '../size_config.dart';
import 'package:flutter/material.dart';
import '../model/item_fetch.dart';
import 'package:provider/provider.dart';
class CustomRow extends StatefulWidget {
  @override
  _CustomRowState createState() => _CustomRowState();
}

class _CustomRowState extends State<CustomRow> {

  double total =0.0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black,blurRadius: 2,offset: Offset(0, 0.1)),
          BoxShadow(color: Colors.grey,blurRadius: 2,offset: Offset(0, 0.1)),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0,right: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Total Amount :',style: TextStyle(fontSize: SizeConfig.screenWidth * 0.06,color: Colors.black),),
            Spacer(flex: 1,),
            Expanded(
              child: Consumer<ItemFetcher>(
                builder: (ctx,data,ch) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black,width: 1),
                      color: Colors.white
                  ),
                  child: Text(data.totalAmount.toStringAsFixed(2),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.05,
                    ),),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
