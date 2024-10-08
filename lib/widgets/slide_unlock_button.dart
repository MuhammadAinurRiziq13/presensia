import 'package:flutter/material.dart';

class SlideToUnlockButton extends StatefulWidget {
  final VoidCallback onSlideComplete;
  final String text;

  const SlideToUnlockButton({
    Key? key,
    required this.onSlideComplete,
    this.text = 'Geser Untuk Keluar',
  }) : super(key: key);

  @override
  _SlideToUnlockButtonState createState() => _SlideToUnlockButtonState();
}

class _SlideToUnlockButtonState extends State<SlideToUnlockButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double _dragThreshold = 0.9;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxDrag) {
    _controller.value += details.primaryDelta! / maxDrag;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_controller.value > _dragThreshold) {
      _controller.forward().then((_) {
        widget.onSlideComplete();
      });
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonSize = 60.0;
        final maxDrag = constraints.maxWidth - buttonSize;

        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    left: _animation.value * maxDrag,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) =>
                          _onDragUpdate(details, maxDrag),
                      onHorizontalDragEnd: _onDragEnd,
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_forward, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
