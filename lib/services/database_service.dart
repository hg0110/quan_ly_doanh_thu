// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/driver.dart';
//
// const String CUSTOMER_COLLECTION_REF = "customers";
//
// class DatabaseService {
//   final _firestore = FirebaseFirestore.instance;
//
//   late final CollectionReference _customerRef;
//
//   DatabaseService() {
//     _customerRef =
//         _firestore.collection(CUSTOMER_COLLECTION_REF).withConverter<Customer>(
//             fromFirestore: (snapshot, _) => Customer.fromJson(
//                   snapshot.data()!,
//                 ),
//             toFirestore: (customer, _) => customer.toJson());
//   }
//   Stream<QuerySnapshot> getCustomers(){
//     return _customerRef.snapshots();
//   }
//   void addCustomer(Customer customer) async{
//     _customerRef.add(customer);
//   }
//   void updateCustomer(String customerId,Customer customer){
//     _customerRef.doc(customerId).update(customer.toJson());
//   }
// }
