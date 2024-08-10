import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

class MyUser extends Equatable {
   String userId;
   String email;
   String name;
   String? picture;
   String roles;
   DateTime date;

   MyUser(
      {required this.userId,
      required this.email,
      required this.name,
        required this.picture,
      required this.roles,
      required this.date,
      });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    picture: '',
    roles: '',
    date: DateTime.now(),
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
    String? picture,
    String? roles,
    DateTime? date,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      roles: roles ?? this.roles,
      date: date ?? this.date,
      // expense: expense ?? this.expense,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      picture: picture,
      roles: roles,
      date: date,
      // expense: expense,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      picture: entity.picture,
      roles: entity.roles,
      date: entity.date,
    );
  }

  @override
  List<Object?> get props => [userId, email, name, roles, date, picture];
}
