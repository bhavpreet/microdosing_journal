import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:microdosing_journal/model/model.dart';
import 'package:microdosing_journal/redux/actions.dart';

class MeasurementPage extends StatelessWidget {
  final String title;
  final Store<AppState> store;

  MeasurementPage({Key key, this.title, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _scaleAddTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
          // style: TextStyle(color: Colors.black54),
        ),
        // bottomOpacity: 1.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel model) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: <Widget>[
                  for (String title in model.m.m.keys.toList())
                    MeasurementUnit(model: model, title: title),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.add),
                        tooltip: "New Scale",
                        // backgroundColor: Colors.blue,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("New Scale"),
                                  content: TextField(
                                    controller: _scaleAddTextController,
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    MaterialButton(
                                      child: Text("Add"),
                                      onPressed: () {
                                        store.dispatch(MeasureAdd(
                                            _scaleAddTextController.text
                                                .toString()));
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.black),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      store.dispatch(MeasurementSave(Measurements(
                          m: store.state.m.m, timestamp: DateTime.now())));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeasurementGroup extends StatelessWidget {
  final _ViewModel model;
  final String title;

  const MeasurementGroup({Key key, @required this.model, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("${model.m.m[title]}");
    return Column(
      children: <Widget>[
        // Align(
        //     alignment: Alignment.centerLeft,
        //     child: Text(
        //       this.title,
        //       style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        //     )),
        for (var _ in model.m.m.keys.toList())
          MeasurementUnit(model: model, title: title),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "Add to scale",
            backgroundColor: Colors.blue,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class MeasurementUnit extends StatelessWidget {
  final _ViewModel model;
  final String title;

  MeasurementUnit({this.model, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          this.title,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_downward),
            Slider(
              min: 0.0,
              max: 5.0,
              value: model.m.m[title] as double,
              activeColor: Theme.of(context).accentColor,
              // inactiveColor: Colors.greenAccent,
              onChanged: (newVal) {
                model.onMeasurementChange(title, newVal);
              },
            ),
            Icon(Icons.arrow_upward),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete),
                tooltip: "Remove Scale",
                onPressed: () {
                  model.onMeasurementDelete(title);
                },
              ),
            )
          ],
        )
      ],
    );
  }
}

class _ViewModel {
  final Measurements m;
  final Function(String key, double val) onMeasurementChange;
  final Function(String title) onMeasurementDelete;
  final Function(String title) onMeasurementAdd;
  // final List<Item> items;
  // final Function(String) onAddItem;
  // final Function(Item) onRemoveItem;
  // final Function() onRemoveItems;

  _ViewModel(
      {this.m,
      this.onMeasurementChange,
      this.onMeasurementDelete,
      this.onMeasurementAdd
      // this.items,
      // this.onAddItem,
      // this.onRemoveItem,
      // this.onRemoveItems,
      });

  factory _ViewModel.create(Store<AppState> store) {
    _onMeasurementChange(String key, double val) {
      Measurements m = store.state.m;
      m.m[key] = val;
      store.dispatch(
          MeasureAction(new Measurements(m: m.m, timestamp: DateTime.now())));
    }

    _onMeasurementDelete(String title) {
      store.dispatch(MeasureDelete(title));
    }

    _onMeasurementAdd(String title) {
      store.dispatch(MeasureAdd(title));
    }
    // _onAddItem(String body) {
    //   store.dispatch(AddItemAction(body));
    // }

    // _onRemoveItem(Item item) {
    //   store.dispatch(RemoveItemAction(item));
    // }

    // _onRemoveItems() {
    //   store.dispatch(RemoveItemsAction());
    // }

    return _ViewModel(
        m: store.state.m,
        onMeasurementChange: _onMeasurementChange,
        onMeasurementAdd: _onMeasurementAdd,
        onMeasurementDelete: _onMeasurementDelete
        // items: store.state.items,
        // onAddItem: _onAddItem,
        // onRemoveItem: _onRemoveItem,
        // onRemoveItems: _onRemoveItems,
        );
  }
}
