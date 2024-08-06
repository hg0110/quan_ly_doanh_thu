import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

class MyUser extends Equatable {
   String userId;
   String email;
   String name;
   String roles;
  // final Expense expense;

   MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      required this.roles,
      // required this.expense
      });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    roles: '',
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
    String? roles,
    // Expense? expense,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      roles: name ?? this.roles,
      // expense: expense ?? this.expense,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      roles: roles,
      // expense: expense,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      roles: entity.roles,
      // expense: entity.expense,
    );
  }

  @override
  List<Object?> get props => [userId, email, name, roles];
}
