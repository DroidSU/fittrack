import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkoutState();

}


class _WorkoutState extends ConsumerState<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Workout Screen"),
      ),
    );
  }

}