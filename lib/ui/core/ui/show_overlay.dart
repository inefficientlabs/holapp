import 'package:shadcn_flutter/shadcn_flutter_experimental.dart';

void showOverlay(BuildContext context, Widget child) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) {
        return child;
      },
      transitionsBuilder: (_, animation, _, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(1, 0), // 👉 slide from right
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    ),
  );
}
