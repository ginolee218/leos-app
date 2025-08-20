import 'dart:async';

import 'package:flutter/material.dart';

class FeatureButton extends StatefulWidget {
  final String iconAsset;
  final String label;
  final bool isEmergency;
  final VoidCallback? onSosTriggered;

  const FeatureButton({
    super.key,
    required this.iconAsset,
    required this.label,
    this.isEmergency = false,
    this.onSosTriggered,
  });

  @override
  State<FeatureButton> createState() => _FeatureButtonState();
}

class _FeatureButtonState extends State<FeatureButton> {
  bool _isPressed = false;
  Timer? _countdownTimer;
  int _countdownValue = 3;
  bool _isCountingDown = false;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (!widget.isEmergency) {
      // TODO: Handle normal button tap
      print("${widget.label} tapped");
      return;
    }

    setState(() {
      _isCountingDown = true;
      _countdownValue = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownValue--;
      });

      if (_countdownValue == 0) {
        timer.cancel();
        widget.onSosTriggered?.call();
        setState(() {
          _isCountingDown = false;
          _isPressed = false; // Ensure button returns to normal state
        });
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _isCountingDown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isEmergency ? Colors.red : Colors.white;
    final backgroundImage = _isPressed
        ? 'assets/images/bg_item_pressed.png'
        : 'assets/images/bg_item_normal.png';

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          if (widget.isEmergency) {
            _startCountdown();
          }
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (widget.isEmergency) {
            _cancelCountdown();
          }
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          if (widget.isEmergency) {
            _cancelCountdown();
          }
        },
        onTap: () {
          if (!widget.isEmergency) {
            // Handle regular tap for non-emergency buttons
            print("${widget.label} tapped");
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.iconAsset,
                    color: color,
                    height: 97,
                    width: 147,
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_isCountingDown)
                Image.asset(
                  'assets/images/countdown_$_countdownValue.png',
                  height: 120, // Adjust size as needed
                  width: 120,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
