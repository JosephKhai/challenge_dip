import 'package:challenge_diploma/model/matchCard.dart';
import 'package:challenge_diploma/model/matchEvent.dart';
import 'package:challenge_diploma/pages/addMatch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';
  FirebaseUser loggedInUser;
    final MatchEvent matchEvent;
  HomePage({@required this.loggedInUser,this.matchEvent});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showUpComingMatch = true;
  bool isManager = false;

  @override
  void initState() {
    super.initState();
    checkManager();
  }

  checkManager() async {
    final snapshot = await Firestore.instance
        .collection('admin')
        .document(widget.loggedInUser.uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        isManager = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game Event List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 35,
          ),
          onPressed: () {
            _auth.signOut();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context) {
              if (this.isManager == true) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddMatchPage.id,
                        arguments: widget.loggedInUser);
                  },
                  icon: Icon(
                    Icons.add,
                    size: 40,
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      setState(() {
                        this.showUpComingMatch = true;
                      });
                    },
                    child: Text('Upcoming Match'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      setState(() {
                        this.showUpComingMatch = false;
                      });
                    },
                    child: Text('Past Match'),
                  ),
                ],
              ),
              StreamBuilder(
                stream: _firestore.collection('matchs').snapshots(),
                builder: (context, snapshot) {
                  List<Widget> widgets = new List<Widget>();
                  try {
                    final events = snapshot.data.documents;
                    for (var event in events) {
                      MatchEvent matchEvent = new MatchEvent(
                        venue: event.data['venue'],
                        payee: event.data['payee'] == null
                            ? null
                            : event.data['payee'],
                        amount: event.data['amount'] == null
                            ? null
                            : event.data['amount'],
                        dateTime: event.data['datetime'] == null
                            ? DateTime.now()
                            : event.data['datetime'].toDate(),
                        id: event.documentID,
                      );

                      if (this.showUpComingMatch == true ||
                          isManager == false) {
                        if (matchEvent.dateTime.isAfter(DateTime.now()) ||
                            matchEvent.dateTime
                                .isAtSameMomentAs(DateTime.now())) {
                          Widget w = MatchCard(matchEvent: matchEvent);

                          widgets.add(w);
                        }
                      } else {
                        if (matchEvent.dateTime.isBefore(DateTime.now())) {
                          Widget w = MatchCard(
                            matchEvent: matchEvent,
                          );
                          widgets.add(w);
                        }
                      }
                    }
                  } catch (e) {
                    print(e);
                  }

                  return Column(
                    children: widgets,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
