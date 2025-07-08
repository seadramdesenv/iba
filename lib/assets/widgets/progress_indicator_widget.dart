import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      child: Padding(
        padding: const EdgeInsets.all(180.0),
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,
          colors: [Theme.of(context).colorScheme.primary],
          strokeWidth: 0.4,
          pathBackgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
