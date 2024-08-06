// import 'package:equatable/equatable.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Car extends Equatable {
//   final String name;
//   final String BKS;
//   final String note;
//   const Car({
//    required this.name,
//    required this.BKS,
//    required this.note,
// });
//   static Car fromSnapShot(DocumentSnapshot snap){
//     Car car = Car(name: snap['name'], BKS: snap['BKS'], note: snap['note']);
//     return car;
//   }
//  @override
//   // TODO: implement props
//   List<Object?> get props => [name, BKS, note];
// }