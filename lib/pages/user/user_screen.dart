import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/get_user_bloc/get_user_bloc.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late MyUser user;

  bool isLoading = false;

  @override
  void initState() {
    user = MyUser.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          "USER",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<GetUserBloc, GetUserState>(
        builder: (context, state) {
          if (state is GetUserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetUserSuccess) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: state.user.length,
              itemBuilder: (context, index) {
                final user = state.user[index];
                return Card(
                  surfaceTintColor: Colors.green,
                  shadowColor: Colors.green,
                  child: ListTile(
                    title: Row(
                      children: [
                        const Text("Name: "),
                        Text(user.name),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("Emai: "),
                            Text(user.email),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     const Text("Phone: "),
                        //     Text(user.),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Error"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // var newCustomer = await getAddCustomer(context);
          // if (newCustomer != null) {
          //   context.read<GetCustomerBloc>().add(GetCustomer());
          // }
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
