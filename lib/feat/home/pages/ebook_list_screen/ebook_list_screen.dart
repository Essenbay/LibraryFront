import 'package:flutter/material.dart';


class EbookListScreen extends StatelessWidget {
  const EbookListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List of EBooks')),
      body: Center(
        child: Text('List of Ebooks Here'),
      ),
    );
  }
}
