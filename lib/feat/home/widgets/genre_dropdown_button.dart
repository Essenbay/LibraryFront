import 'package:flutter/material.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';

///Returns null if Add genre
class GenreDowndownButton extends StatelessWidget {
  const GenreDowndownButton(
      {super.key,
      required this.genres,
      this.selectedGenre,
      required this.onChanged});
  final List<GenreModel> genres;
  final GenreModel? selectedGenre;
  final ValueChanged<GenreModel?> onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<GenreModel>(
      hint: Text(selectedGenre?.name ?? ''),
      items: [
        ...genres
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
      ],
      onChanged: onChanged,
    );
  }
}
