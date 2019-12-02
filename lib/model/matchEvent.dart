import 'package:cloud_firestore/cloud_firestore.dart';

class MatchEvent {
  final String id;
  final String venue;
  final String payee;
  final String amount;
  final DateTime dateTime;

  MatchEvent({this.id, this.venue, this.payee, this.amount, this.dateTime});

  factory MatchEvent.fromFirebase(DocumentSnapshot data) =>
      MatchEvent(venue: data['venue'], dateTime: data['datetime'].toDate(), id: data.documentID);

  static List<MatchEvent> decodeEventList(List<DocumentSnapshot> data) {
    List<MatchEvent> eventList = new List<MatchEvent>();
    for (var events in data) {
      MatchEvent eve = MatchEvent.fromFirebase(events);
      eventList.add(eve);
    }
    return eventList;
  }
}
