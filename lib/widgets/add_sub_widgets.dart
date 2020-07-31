import 'package:flutter/material.dart';
import '../model/item_details.dart';
import '../model/item_fetch.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';
class AddSubLogicWidget extends StatefulWidget {

  final ItemDetails data;
  final bool selected;
  AddSubLogicWidget(this.data,this.selected);
  @override
  _AddSubLogicWidgetState createState() => _AddSubLogicWidgetState();
}

class _AddSubLogicWidgetState extends State<AddSubLogicWidget> {


  //widget builds for add and remove widgets
  Widget buildLogicWidgets(IconData icon)
  {
    return Container(
        height: SizeConfig.screenWidth * 0.09,
        width: SizeConfig.screenWidth * 0.09,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black,width: 2),
            color: Colors.white
        ),
        child: Icon(icon,
          size: SizeConfig.screenWidth * 0.07,
          color: Colors.black,)
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      children: <Widget>[
        Container(
            height: SizeConfig.screenWidth * 0.08,
            width: SizeConfig.screenWidth * 0.08,
            child:  Align(
                alignment: Alignment.center,
                child: Text(widget.data.counter.toString(),
                  style: TextStyle(fontSize: SizeConfig.screenWidth * 0.06),)
            )
        ),
        Container(
          width: SizeConfig.screenWidth * 0.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if(!widget.selected) {
                    Provider.of<ItemFetcher>(context, listen: false)
                        .RemFromTotal(widget.data.price, widget.data.counter);
                    Provider.of<ItemDetails>(context, listen: false)
                        .decCounter();
                  }
                },
                child: buildLogicWidgets(Icons.remove)
              ),
              GestureDetector(
                onTap: () {
                  if(!widget.selected) {
                    Provider.of<ItemFetcher>(context, listen: false).IncToTotal(
                        widget.data.price);
                    Provider.of<ItemDetails>(context, listen: false)
                        .incCounter();
                  }
                },
                child: buildLogicWidgets(Icons.add)
              ),
            ],
          ),
        )
      ],
    );
  }
}
