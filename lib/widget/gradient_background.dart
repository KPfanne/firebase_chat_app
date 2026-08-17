import 'package:flutter/widgets.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 66, 176, 182),
            Color.fromARGB(255, 43, 135, 147),
            Color.fromARGB(255, 6, 75, 75),
          ],
        ),
      ),
      child: child,
    );
  }
}
