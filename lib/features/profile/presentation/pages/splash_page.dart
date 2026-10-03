import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: LoadingView());
}
