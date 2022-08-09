import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CameraTarget extends StatefulWidget {
  final void Function() whenPressed;
  const CameraTarget(this.whenPressed);

  @override
  State<CameraTarget> createState() => _CameraTargetState();
}

class _CameraTargetState extends State<CameraTarget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controler;
  late Animation<double> _sizeAnimation;
  final AudioPlayer _myPlayer = AudioPlayer();

  @override
  void initState() {
    print("init state in camera target called");
    _controler = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 200, end: 240), weight: 50),
      TweenSequenceItem<double>(tween: Tween(begin: 240, end: 200), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controler, curve: Curves.fastOutSlowIn),
    );

    _sizeAnimation.addListener(() {
      setState(() {});
    });
    _sizeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controler.reset();
        _myPlayer.seek(
          const Duration(minutes: 0),
        );
      }
    });

    _myPlayer.setAsset("lib/assets/audio/camera-shutter.mp3", preload: true);

    super.initState();
  }

  @override
  void dispose() {
    _controler.dispose();
    _myPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _myPlayer.play();
        _controler.forward();
        widget.whenPressed();
      },
      child: Image.asset(
        "lib/assets/images/camera-target-modfied.png",
        height: _sizeAnimation.value,
        width: _sizeAnimation.value,
        fit: BoxFit.contain,
      ),
    );
  }
}
