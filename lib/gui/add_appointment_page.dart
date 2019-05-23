///
/// `add_appointment_page.dart`
/// Class for appointment addition page GUI
///

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediccare/core/appointment.dart';
import 'package:mediccare/core/doctor.dart';
import 'package:mediccare/core/user.dart';
import 'package:mediccare/util/alert.dart';
import 'package:mediccare/util/datetime_picker_formfield.dart';

class AddAppointmentPage extends StatefulWidget {
  Function _refreshState;
  User _user;
  Appointment _appointment;

  AddAppointmentPage({Function refreshState, User user}) {
    this._refreshState = refreshState;
  }

  AddAppointmentPage.editMode({Function refreshState, User user, Appointment appointment}) {
    this._refreshState = refreshState;
    this._appointment = appointment;
  }

  @override
  State<StatefulWidget> createState() {
    return _AddAppointmentPageState();
  }
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _controllerTitle = TextEditingController();
  static final TextEditingController _controllerDescription = TextEditingController();
  static final TextEditingController _controllerHospital = TextEditingController();
  Doctor _currentDoctor;
  DateTime _currentDateTime;

  void clearFields() {
    _controllerTitle.text = '';
    _controllerDescription.text = '';
    _controllerHospital.text = '';
    this._currentDoctor = null;
    this._currentDateTime = null;
  }

  void loadFields() {
    if (widget._appointment != null) {
      _controllerTitle.text = widget._appointment.title;
      _controllerDescription.text = widget._appointment.description;
      _controllerHospital.text = widget._appointment.hospital;
      this._currentDoctor = widget._appointment.doctor;
      this._currentDateTime = widget._appointment.dateTime;
    }
  }

  @override
  void initState() {
    super.initState();
    this.clearFields();
    this.loadFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          (widget._appointment == null) ? 'Add Appointment' : 'Edit Appointment',
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.1,
        actions: (widget._appointment == null)
            ? <Widget>[]
            : <Widget>[
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Alert.displayConfirmDelete(
                      context,
                      title: 'Delete Appointment?',
                      content:
                          'Deleting this appointment will permanently remove it from your appointment list.',
                      onPressedConfirm: () {
                        widget._user.appointmentList.remove(widget._appointment);
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        widget._refreshState();
                      },
                    );
                  },
                ),
              ],
      ),
      body: Form(
        key: this._formKey,
        child: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 30.0, top: 15.0, right: 30.0, bottom: 15.0),
            children: <Widget>[
              TextFormField(
                controller: _controllerTitle,
                decoration: InputDecoration(labelText: 'Appointment Title'),
                validator: (String text) {
                  if (text.isEmpty) {
                    return 'Please fill appointment title';
                  }
                },
              ),
              TextFormField(
                controller: _controllerDescription,
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Doctor'),
                // TODO: Implements doctor selection
              ),
              TextFormField(
                controller: _controllerHospital,
                decoration: InputDecoration(
                  labelText: 'Hospital',
                  helperText: 'Leave blank to use default hospital of the selected doctor.',
                ),
              ),
              DateTimePickerFormField(
                initialValue:
                    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 10),
                initialDate:
                    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 10),
                format: DateFormat('yyyy-MM-dd HH:mm'),
                inputType: InputType.both,
                editable: true,
                decoration: InputDecoration(
                  labelText: 'Date and Time',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onChanged: (DateTime dateTime) {
                  try {
                    this._currentDateTime = dateTime;
                  } catch (e) {}
                },
                validator: (DateTime dateTime) {
                  if (this._currentDateTime == null) {
                    return 'Please select a valid date and time';
                  }
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Save'),
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    widget._user.appointmentList.add(
                      Appointment(
                        title: _controllerTitle.text,
                        description: _controllerDescription.text,
                        doctor: this._currentDoctor,
                        hospital: (_controllerHospital.text.trim().isNotEmpty)
                            ? _controllerHospital.text
                            : this._currentDoctor.hospital,
                      ),
                    );
                    widget._refreshState();
                    Navigator.pop(context);
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
