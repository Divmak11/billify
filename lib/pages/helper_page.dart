import 'package:flutter/material.dart';
class HelpPage extends StatelessWidget {


  Widget makeTitleText(String text)
  {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    );
  }
  Widget makeText(String text)
  {
    return Text(
      text,
      style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.normal
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Help',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                  child: makeTitleText("General Helper Questions!")),
              SizedBox(height: 10,),
              makeTitleText(
                'What does it do?'
              ),
              SizedBox(height: 5,),
              makeText(
                'This App generates a small bill according to the items '
                    'you select.'
              ),
              Divider(thickness: 2,),
              SizedBox(height: 10,),
              makeTitleText(
                  'How does it work ?'
              ),
              SizedBox(height: 5,),
              makeText(
                  'In Add Bill Screen, All the items you add retain permanently, '
                      'they are your list of items on which your future bills can be'
                      ' made. You can delete items, edit items or clear all.\n'
                      'Once you add an item it becomes part of your list.'
              ),
              Divider(thickness: 2,),
              SizedBox(height: 10,),
              makeTitleText(
                  'How to share the Bill ?'
              ),
              SizedBox(height: 5,),
              makeText(
                  'Once Bill is generated you can see it in details in Bill Details. '
                       'They you can share the bill, by default only text is shared as bill'
                      ' but you can also save it in PDF format and then share it from respective'
                      ' folder.'
              ),
              Divider(thickness: 2,),
              SizedBox(height: 10,),
              makeTitleText(
                  'What does "Can\'t edit while selected" means ?'
              ),
              SizedBox(height: 5,),
              makeText(
                  '"Item is selected" means its counter is greater than 0. '
                      'So you have to first make it 0 again in order to edit it. '
              )
            ],
          ),
        ),
      ),
    );
  }
}
