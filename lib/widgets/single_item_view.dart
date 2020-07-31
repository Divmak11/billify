
import 'package:flutter/material.dart';
import '../widgets/add_sub_widgets.dart';
import 'package:provider/provider.dart';
import '../model/item_details.dart';
import '../size_config.dart';

class SingleItemListView extends StatelessWidget{

  Color color;
  bool selected;
  SingleItemListView(this.color,this.selected);

  int clickedCounter=0;
  double totalAmnt=0.0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final data = Provider.of<ItemDetails>(context,listen: false);
    return Container(
      height: 75,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Align(
          alignment: Alignment.center,
          child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/billify_icon.png'),
              ),
            title: Text(
              data.name,
              style: TextStyle(fontSize: SizeConfig.screenWidth * 0.05),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              data.price.toStringAsFixed(2),
              style: TextStyle(fontSize: SizeConfig.screenWidth * 0.05),
            ),
            trailing:  Container(
                width: SizeConfig.screenWidth * 0.35,
                child: AddSubLogicWidget(data,selected)
              ),
          ),
        ),
      ),
    );
  }
}
