import 'package:countdown_timer/round_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inHours).toString().padLeft(2, '0')}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inHours).toString().padLeft(2, '0')}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '00:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    controller.addListener(
      () {
        notify();
        if (controller.isAnimating) {
          setState(() {
            progress = controller.value;
          });
        } else {
          setState(() {
            progress = 1.0;
            isPlaying = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                    backgroundColor: Colors.grey.shade300,
                    value: progress,
                    strokeWidth: 50,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: controller.duration!,
                            onTimerDurationChanged: (time) {
                              setState(() {
                                controller.duration = time;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.isAnimating) {
                    controller.stop();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    controller.reverse(
                      from: controller.value == 0 ? 1.0 : controller.value,
                    );
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                child: RoundButton(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.reset();
                  setState(() {
                    isPlaying = false;
                  });
                },
                child: const RoundButton(
                  icon: Icons.stop,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
