import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import 'package:microdosing_journal/model/model.dart';
import 'package:microdosing_journal/redux/actions.dart';

class DoseagePage extends StatefulWidget {
  final String title;
  final Store<AppState> store;

  DoseagePage({Key key, this.title, this.store}) : super(key: key);

  @override
  _DoseagePageState createState() => _DoseagePageState();
}

class _DoseagePageState extends State<DoseagePage> {
  String substanceSelection;

  String unit;
  int quantity;

  TextEditingController _quantityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Build DosagePage $unit, $quantity");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            this.widget.title,
            // style: TextStyle(color: Colors.black54),
          ),
          // bottomOpacity: 1.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: renderSelection(context));
  }

  Widget renderSelection(BuildContext context) {
    if (substanceSelection != null) {
      return renderSubstance();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DropdownButton<String>(
            hint: Text("Substance"),
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            // style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Theme.of(context).accentColor,
            ),
            onChanged: (String newValue) {
              setState(() => substanceSelection = newValue);
            },
            items: <String>[
              'Psilocybin',
              'LSD',
              'Cannabis',
              "Coffee"
            ] // TODO: should go in DB
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(29.0),
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                // TODO
                child: Icon(Icons.add),
                tooltip: "New Substance",
                // backgroundColor: Colors.blue,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderSubstance() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(substanceSelection),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    this.substanceSelection = null;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Quantity: "),
              SizedBox(
                  width: 60.0,
                  child: TextField(
                    controller: _quantityTextController,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownButton<String>(
                  hint: Text("Unit"),
                  value: unit,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  // style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 0,
                    color: Theme.of(context).accentColor,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      this.unit = newValue;
                      print("Setting Unit : $unit");
                    });
                  },
                  items: Unit().u.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: FloatingActionButton(
                child: Icon(
                  Icons.save,
                ),
                // color: Theme.of(context).accentColor,
                onPressed: () {
                  Dose d = Dose(
                      substance: substanceSelection,
                      attributes: Map(),
                      quantity:
                          double.parse(_quantityTextController.text.toString()),
                      timestamp: DateTime.now());
                  widget.store.dispatch(DoseAdd(d));
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
