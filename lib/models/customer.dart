//
// class Customer {
//   String customerId;
//   String name;
//   String address;
//   String phone;
//
//   Customer({
//     required this.customerId,
//     required this.name,
//     required this.address,
//     required this.phone,
//   });
//
//   Customer.fromJson(Map<String, Object?> json)
//       :this(
//     customerId: json['customerId']! as String,
//     name: json['name']! as String,
//     address: json['address']! as String,
//     phone: json['phone']! as String,
//   );
//
//   Customer copyWith({
//     String? customerId,
//     String? name,
//     String? address,
//     String? phone,
//   }){
//     return Customer(
//       customerId: customerId ?? this.customerId,
//       name: name ?? this.name,
//       address: address ?? this.address,
//       phone: phone ?? this.phone,
//     );
//   }
//   Map<String, Object?> toJson(){
//     return{
//       'customerId' : customerId,
//       'name' : name,
//       'address' : address,
//       'phone' : phone,
//     };
//   }
// }