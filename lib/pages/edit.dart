import 'package:challenge_diploma/model/matchEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final MatchEvent matchEvent;
  static const id = 'edit';
  FirebaseUser loggedInUser;

  EditPage({this.matchEvent, this.loggedInUser});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _firestore = Firestore.instance;
  String payee;
  String amount;
  TextEditingController _venueController;
  TextEditingController _payeeController;
  TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _venueController =
        TextEditingController(text: isEditMode ? widget.matchEvent.venue : '');
    _payeeController =
        TextEditingController(text: isEditMode ? widget.matchEvent.payee : '');
    _amountController =
        TextEditingController(text: isEditMode ? widget.matchEvent.amount : '');
  }

  get isEditMode => widget.matchEvent != null;

  void _delete() async {
    try {
      await _firestore
          .collection('matchs')
          .document(widget.matchEvent.id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  void _update() async {
    try {
      this.amount = _amountController.text;
      this.payee = _payeeController.text;

      print(widget.matchEvent.id);

      await _firestore
          .collection('matchs')
          .document(widget.matchEvent.id)
          .setData({
        'venue': widget.matchEvent.venue,
        'payee': this.payee,
        'amount': this.amount,
        'datetime': widget.matchEvent.dateTime
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.matchEvent.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 15),
              child: TextFormField(
                controller: _venueController,
                decoration: InputDecoration(
                  labelText: "Venue",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 15),
              child: TextFormField(
                controller: _payeeController,
                decoration: InputDecoration(
                  labelText: "Payee",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 15),
              child: TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  color: Colors.lightBlue,
                  onPressed: () async {
                    this._update();
                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    this._delete();
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
