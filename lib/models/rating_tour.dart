import 'package:cloud_firestore/cloud_firestore.dart';

class TourRating{
  String rateId,comment,username,photoUrl;
  double rate;
  String  timeStamp;


  TourRating({
    this.rateId,
    this.comment,
    this.rate,
    this.timeStamp,
    this.username,
    this.photoUrl,

  });

  List<TourRating> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TourRating(
        rateId: doc.get('rateId') ?? '',
        comment: doc.get('comment') ?? '',
        username: doc.get('username') ?? '',
        rate: doc.get('rate') != null ? doc.get(
            'rate') is double ? doc.get('rate') : doc.get(
            'rate') is String ? double.parse(
            doc.get('rate')):doc.get('rate').toDouble() : '',
        photoUrl: doc.get('photoUrl') ?? '',
        timeStamp: doc.get('timeStamp') ?? '',

      );
    }).toList();
  }



  Map<String, dynamic> toJson() {
    return {
      'rateId': rateId,
      'comment': comment,
      'rate': rate,
      'timeStamp': timeStamp,
      'username': username,
      'photoUrl': photoUrl,
    };
  }
}