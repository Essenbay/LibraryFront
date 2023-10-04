import 'package:flutter/material.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';

class AuthorDropdownButton extends StatelessWidget {
  const AuthorDropdownButton(
      {super.key, required this.authors, this.author, required this.onChanged});

  final List<AuthorModel> authors;
  final AuthorModel? author;
  final ValueChanged<AuthorModel?> onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<AuthorModel>(
      hint: Text('${author?.surname ?? ''} ${author?.name ?? ''}'),
      items: [
        ...authors
            .map((e) => DropdownMenuItem(
                value: e, child: Text('${e.surname} ${e.name}')))
            .toList(),
      ],
      onChanged: onChanged,
    );
  }
}
