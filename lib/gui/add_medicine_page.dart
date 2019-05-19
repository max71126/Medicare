///
/// `add_medicine_page.dart`
/// Class for medicine addition page GUI
///

import 'package:flutter/material.dart';
import 'package:mediccare/core/medicine_schedule.dart';
import 'package:mediccare/util/alert.dart';

class AddMedicinePage extends StatefulWidget {
  final Function _refreshState;

  AddMedicinePage(this._refreshState);

  @override
  State<StatefulWidget> createState() {
    return _AddMedicinePageState();
  }
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _controllerMedicineName = TextEditingController();
  static final TextEditingController _controllerDescription = TextEditingController();
  static final TextEditingController _controllerDoseAmount = TextEditingController();
  static final TextEditingController _controllerTotalAmount = TextEditingController();
  String _currentMedicineType = 'tablet';
  final MedicineSchedule _schedule = MedicineSchedule();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Add Medicine',
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.1,
      ),
      body: Form(
        key: this._formKey,
        child: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 30.0, top: 15.0, right: 30.0, bottom: 15.0),
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Medicine Name'),
                controller: _controllerMedicineName,
                validator: (String text) {
                  if (text.isEmpty) {
                    return 'Please fill medicine name';
                  }
                },
              ),
              TextFormField(
                controller: _controllerDescription,
                maxLines: 4,
                decoration: InputDecoration(hintText: 'Description'),
                validator: (String text) {
                  if (text.isEmpty) {
                    return 'Please fill description';
                  }
                },
              ),
              DropdownButton(
                isExpanded: true,
                value: this._currentMedicineType,
                items: [
                  DropdownMenuItem(
                    value: 'capsule',
                    child: Text('Capsule'),
                  ),
                  DropdownMenuItem(
                    value: 'cream',
                    child: Text('Cream / Ointment'),
                  ),
                  DropdownMenuItem(
                    value: 'drop',
                    child: Text('Drop'),
                  ),
                  DropdownMenuItem(
                    value: 'liquid',
                    child: Text('Liquid / Syrup'),
                  ),
                  DropdownMenuItem(
                    value: 'lozenge',
                    child: Text('Lozenge'),
                  ),
                  DropdownMenuItem(
                    value: 'spray',
                    child: Text('Spray'),
                  ),
                  DropdownMenuItem(
                    value: 'tablet',
                    child: Text('Tablet'),
                  ),
                ],
                onChanged: (String value) {
                  setState(() {
                    this._currentMedicineType = value;
                  });
                },
              ),
              TextFormField(
                controller: _controllerDoseAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Dose Amount'),
                validator: (String text) {
                  if (text.isEmpty) {
                    return 'Please fill dose amount';
                  } else {
                    try {
                      int _ = int.parse(text);
                      if (_ <= 0) {
                        return 'Dose amount must be at least 1';
                      }
                    } catch (e) {
                      return 'Dose amount must be integer';
                    }
                  }
                },
              ),
              TextFormField(
                controller: _controllerTotalAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Total Amount'),
                validator: (String text) {
                  if (text.isEmpty) {
                    return 'Please fill total amount';
                  } else {
                    try {
                      int _ = int.parse(text);
                      if (_ <= 0) {
                        return 'Total amount must be at least 1';
                      }
                    } catch (e) {
                      return 'Total amount must be integer';
                    }
                  }
                },
              ),
              SizedBox(height: 20.0),
              Text('Medicine Time'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.time[0],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.time[0] = value;
                              });
                            },
                          ),
                          Text('Breakfast'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.time[2],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.time[2] = value;
                              });
                            },
                          ),
                          Text('Dinner'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.time[1],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.time[1] = value;
                              });
                            },
                          ),
                          Text('Lunch'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.time[3],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.time[3] = value;
                              });
                            },
                          ),
                          Text('Bedtime'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text('Medicine Schedule'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[0],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[0] = value;
                              });
                            },
                          ),
                          Text('Monday'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[1],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[1] = value;
                              });
                            },
                          ),
                          Text('Tuesday'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[2],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[2] = value;
                              });
                            },
                          ),
                          Text('Wednesday'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[3],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[3] = value;
                              });
                            },
                          ),
                          Text('Thursday'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[4],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[4] = value;
                              });
                            },
                          ),
                          Text('Friday'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[5],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[5] = value;
                              });
                            },
                          ),
                          Text('Saturday'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: this._schedule.day[6],
                            onChanged: (bool value) {
                              setState(() {
                                this._schedule.day[6] = value;
                              });
                            },
                          ),
                          Text('Sunday'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Save'),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    if (int.parse(_controllerDoseAmount.text) >
                        int.parse(_controllerTotalAmount.text)) {
                      Alert.displayConfirm(
                        context: context,
                        title: 'Invalid Data',
                        content: 'Dose amount must be less than or equal to total amount.',
                      );
                    } else {
                      widget._refreshState();
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
