import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_trivia_king/states/profile.dart';

class ProfileUsername extends ConsumerStatefulWidget {
  const ProfileUsername({super.key});

  @override
  ConsumerState<ProfileUsername> createState() => _ProfileUsernameState();
}

class _ProfileUsernameState extends ConsumerState<ProfileUsername> {
  bool isEditing = false;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // When the text field is unfocused, exit editing mode and apply changes
    focusNode.addListener(() {
      if (!focusNode.hasFocus) onSubmit();
    });
  }

  Future<void> onSubmit() async {
    if (controller.text.isNotEmpty) {
      await ref.read(profileStateProvider.notifier).setUsername(controller.text);
    }
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileStateProvider);
    controller.text = profile.username;

    return Center(
        child: isEditing
            ? UsernameEdit(controller: controller, focusNode: focusNode, onSubmit: onSubmit)
            : UsernameDisplay(onEdit: () => setState(() => isEditing = true)));
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class UsernameDisplay extends ConsumerWidget {
  final void Function() onEdit;

  const UsernameDisplay({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 26,
        ),
        Flexible(
          child: Text(
            profile.username,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          iconSize: 18,
        ),
      ],
    );
  }
}

class UsernameEdit extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() onSubmit;

  const UsernameEdit({super.key, required this.controller, required this.focusNode, required this.onSubmit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: (_) => onSubmit(),
          ),
        ),
      ],
    );
  }
}
