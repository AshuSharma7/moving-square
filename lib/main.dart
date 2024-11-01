import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  static const _squareSize = 50.0;

  // This will store the current position
  Offset currentOffset = const Offset(0, 0);

  // Controller for managing the animation
  late final AnimationController _controller;
  // Animation value for slide transition
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    // Initialise AnimationController
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    // Initialise Animation for slide transition
    _animation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
            .animate(_controller);

    // Adding listener to animation to check for status changes
    _animation.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Calculate the position for right transition
    final rightOffset =
        Offset(-((size.width - _squareSize) / 2) / _squareSize, 0);

    // Calculate the position for left transition
    final leftOffset =
        Offset(((size.width - _squareSize) / 2) / _squareSize, 0);

    return Column(
      children: [
        SlideTransition(
          position: _animation,
          child: Container(
            width: _squareSize,
            height: _squareSize,
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: currentOffset == rightOffset ||
                      _animation.status == AnimationStatus.forward
                  ? null // Disable the button state if the square is moving or square has already reached right side
                  : () {
                      setState(() {
                        // Start the animation for right side
                        _animation = Tween<Offset>(
                                begin: currentOffset, end: rightOffset)
                            .animate(_controller);
                        currentOffset = rightOffset;
                        _controller.forward(from: 0);
                      });
                    },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.white60,
              ),
              child: const Text(
                'Right',
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: currentOffset == leftOffset ||
                      _animation.status == AnimationStatus.forward
                  ? null // Disable the button state if the square is moving or square has already reached left side
                  : () {
                      setState(() {
                        // Start the animation for left side
                        _animation =
                            Tween<Offset>(begin: currentOffset, end: leftOffset)
                                .animate(_controller);
                        currentOffset = leftOffset;
                        _controller.forward(from: 0);
                      });
                    },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.white60,
              ),
              child: const Text('Left'),
            ),
          ],
        ),
      ],
    );
  }
}
