import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
	final String userId;
	final String email;
	final String name;
	final String? picture;
	 String roles;
	 DateTime date;

	 MyUserEntity({
		required this.userId,
		required this.email,
		required this.name,
		required this.picture,
		required this.roles,
		required this.date,
	});

	Map<String, Object?> toDocument() {
		return {
			'userId': userId,
			'email': email,
			'name': name,
			'picture': picture,
			'roles': roles,
			'date': date,
		};
	}

	static MyUserEntity fromDocument(Map<String, dynamic> doc) {
		return MyUserEntity(
			userId: doc['userId'], 
			email: doc['email'], 
			name: doc['name'],
			picture: doc['picture'] as String?,
			roles: doc['roles'],
			date: (doc['date'] as Timestamp).toDate(),
		);
	}

	@override
	List<Object?> get props => [userId, email, name,roles,date, picture];

}