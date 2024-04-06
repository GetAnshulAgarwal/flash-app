import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen>
    with SingleTickerProviderStateMixin {
  Color? bigbuttoncolor = const Color(0xFF312C27);

  Color? midbuttoncolor = const Color(0xFF484242);

  Color? smallbuttoncolor = const Color(0xFF504847);

  bool inOn = false;
  bool _isColorChanged = false;

  AnimationController? controller;
  Animation<Color?>? coloranimationbigbutton;
  Animation<Color?>? coloranimationmidbutton;
  Animation<Color?>? coloranimationsmallbutton;

  void _changecolor() {
    if (_isColorChanged) {
      controller!.reverse;
    } else {
      controller!.forward();
    }
    _isColorChanged = !_isColorChanged;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    torchavailable();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    coloranimationbigbutton = ColorTween(
      begin: bigbuttoncolor,
      end: const Color(0xFF312C27).withOpacity(0.3),
    ).animate(controller!);

    coloranimationmidbutton = ColorTween(
      begin: midbuttoncolor,
      end: const Color(0xFFFF8E01).withOpacity(0.4),
    ).animate(controller!);

    coloranimationsmallbutton = ColorTween(
      begin: const Color(0xFF504847),
      end: const Color(0xFFFF8E01),
    ).animate(controller!);

    controller?.addListener(() {
      setState(() {
        bigbuttoncolor = coloranimationbigbutton?.value;
        midbuttoncolor = coloranimationmidbutton?.value;
        smallbuttoncolor = coloranimationsmallbutton?.value;
      });
    });
  }

  Future<bool> torchavailable() async {
    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (e) {
      print(e);
      showmessage(
        'Could not check if the device has an available torch',
      );
      rethrow;
    }
  }

  Future<void> torchlight() async {
    if (inOn) {
      try {
        return await TorchLight.enableTorch();
      } on Exception catch (_) {
        showmessage('COULD NOT ENABLE TORCH');
        rethrow;
      }
    } else {
      try {
        return await TorchLight.disableTorch();
      } on Exception catch (_) {
        showmessage('Could Not Disable Torch');
        rethrow;
      }
    }
  }

  void showmessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              const Center(
                child: Text(
                  "Alert",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
              Center(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLASH APP'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                (inOn) ? Icons.wb_sunny : Icons.wb_sunny_outlined,
                size: 100,
                color:
                    (inOn) ? const Color(0xFFFF8E01) : const Color(0xFF504847),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "FlashLight:${(inOn) ? "ON" : "OFF"}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Circlecontain(
                      w: 300,
                      h: 300,
                      colour: (inOn)
                          ? const Color(0xFF312C27).withOpacity(0.3)
                          : bigbuttoncolor!),
                  Circlecontain(
                      w: 260,
                      h: 260,
                      colour: (inOn)
                          ? const Color(0xFFFF8E01).withOpacity(0.4)
                          : midbuttoncolor!),
                  Container(
                    width: 190,
                    height: 190,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (inOn)
                            inOn = false;
                          else
                            inOn = true;
                        });
                        torchlight();
                        _changecolor();
                      },
                      child: const Icon(
                        Icons.power_settings_new,
                        size: 170,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          backgroundColor: (inOn)
                              ? const Color(0xFFFF8E01)
                              : smallbuttoncolor!,
                          foregroundColor: (inOn)
                              ? const Color(0xFF504847)
                              : const Color(0xFFFF8E01)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Circlecontain extends StatelessWidget {
  const Circlecontain({required this.w, required this.h, required this.colour});

  final double w;
  final double h;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colour,
      ),
    );
  }
}
