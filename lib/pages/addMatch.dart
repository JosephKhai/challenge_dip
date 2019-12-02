import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMatchPage extends StatefulWidget {
  static const String id = 'AddMatchPage';
  final FirebaseUser loggedInUser;

 AddMatchPage({@required this.loggedInUser});
  @override
  _AddMatchPageState createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  final _firestore = Firestore.instance;
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  String venue;
  String payee;
  String amount;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2019),
        lastDate: new DateTime(2022));

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  void _createMatchEvent() async {
    Timestamp timestamp = new Timestamp.fromDate(this.fullDateTime());
    try {
      DocumentReference result = await _firestore.collection('matchs').add({
        'venue': this.venue,
        //'payee': this.payee,
        //'amount': this.amount,
        'datetime': timestamp,
      });
      if (result.documentID != null) {
        Navigator.of(context).pop();
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  DateTime fullDateTime() {
    return new DateTime(this._date.year, this._date.month, this._date.day,
        this._time.hour, this._time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new Match'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
                child: TextField(
                  onChanged: (value) {
                    venue = value;
                  },
                  decoration: InputDecoration(hintText: 'Venue'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  this._selectDate(context);
                },
                child: Text(
                  'Select Date',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              RaisedButton(
                color: Colors.deepOrange,
                onPressed: () {
                  this._selectTime(context);
                },
                child: Text(
                  'Select Time',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Date selected: ${_date.toString()}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Time selected: ${_time.toString()}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      this._createMatchEvent();
                    },
                    child: Text(
                      'Create Match',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
