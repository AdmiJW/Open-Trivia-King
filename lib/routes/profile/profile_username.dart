import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:open_trivia_king/states/user_state.dart';

class ProfileUsername extends StatefulWidget {
  const ProfileUsername({super.key});

  @override
  State<ProfileUsername> createState() => _ProfileUsernameState();
}

class _ProfileUsernameState extends State<ProfileUsername> {
  bool isEditing = false;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  //? Reassignable function, needs to use the UserState object
  // ignore: prefer_function_declarations_over_variables
  void Function() submitUsername = () {};

  @override
  void initState() {
    super.initState();

    //? When the text field is unfocused, exit editing mode and apply changes
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        submitUsername();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context, listen: true);
    controller.text = userState.username;

    // Refresh the submitUsername() method
    submitUsername = () {
      if (controller.text.isNotEmpty) {
        userState.setUsername(controller.text);
      }
      setState(() => isEditing = false);
    };

    return Center(
      child: isEditing ? editRow(userState) : displayRow(userState),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  //* The username row when isEditing is false
  Widget displayRow(UserState userState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 26,
        ),
        Flexible(
          child: Text(
            userState.username,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () => setState(() => isEditing = true),
          icon: const Icon(Icons.edit),
          iconSize: 18,
        ),
      ],
    );
  }

  //* The username row when isEditing is true
  Widget editRow(UserState userState) {
    // Request focus onto the text field. Without this, the text field won't focus on tapping edit icon
    focusNode.requestFocus();

    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (_) => submitUsername(),
          ),
        ),
      ],
    );
  }
}
