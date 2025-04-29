import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double width;
  final double height;

  const ActionButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onTap,
    required this.width,
    required this.height,
    
  }) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;  // Initialize with the initial color
  }

  void _changeColor() {
    setState(() {
      // Reduce the brightness of the color by 50%
      _currentColor = Color.fromRGBO(
        (widget.color.red * 0.5).toInt(),
        (widget.color.green * 0.5).toInt(),
        (widget.color.blue * 0.5).toInt(),
        widget.color.opacity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();  // Call the provided onTap function
        _changeColor();   // Change the color on tap
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _currentColor,  // Use the dynamically updated color
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: _currentColor,  // Icon color changes as well
              ),
            ),
          ],
        ),
      ),
    );
  }
}
