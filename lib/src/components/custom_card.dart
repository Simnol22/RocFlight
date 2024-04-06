import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget children;
  final Widget? trailing;

  const CustomCard({
    super.key,
    required this.title,
    required this.children,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  dense: true,
                  trailing: trailing
                ),
                const SizedBox(height: 8),
                children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}