import 'package:challenge_diploma/model/matchEvent.dart';
import 'package:challenge_diploma/pages/edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _firestore = Firestore.instance;

class MatchCard extends StatelessWidget {
  final MatchEvent matchEvent;

  MatchCard({this.matchEvent});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEE d MMM').format(this.matchEvent.dateTime);
    String formattedTime =
        DateFormat('K:mm a').format(this.matchEvent.dateTime);

    return Container(
      margin: EdgeInsets.all(15),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text('Venue: '),
                ),
                Container(
                  child: Text(this.matchEvent.venue),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text('Date: '),
                ),
                Container(
                  child: Text('$formattedDate'),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text('Time: '),
                ),
                Container(
                  child: Text('$formattedTime'),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text('Payee: '),
                ),
                Container(
                  child: Text('${this.matchEvent.payee}'),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text('Amount: '),
                ),
                Container(
                  child: Text('${this.matchEvent.amount}'),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => EditPage(matchEvent: matchEvent),
                      )),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
