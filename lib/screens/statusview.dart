import 'package:flutter/material.dart';

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.caption,
    required this.imageurl,
    required this.ondeleterequest,
    required this.ismine,
  });

  final String? caption;
  final String imageurl;
  final void Function() ondeleterequest;
  final bool ismine;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewing status'),
        actions: ismine
            ? [
                IconButton(
                    onPressed: () {
                      ondeleterequest();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.delete))
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Hero(
                  tag: imageurl,
                  child: Image.network(
                    imageurl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              caption ?? "",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
