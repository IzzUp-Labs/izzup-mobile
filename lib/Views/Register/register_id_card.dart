import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gig/Services/colors.dart';
import 'package:gig/Services/navigation.dart';
import 'package:gig/Views/Register/register_extra_tags.dart';

class RegisterIdCard extends StatefulWidget {
  const RegisterIdCard({super.key});

  @override
  State<RegisterIdCard> createState() => _RegisterIdCardState();
}

class _RegisterIdCardState extends State<RegisterIdCard> {
  late final CameraDescription firstCamera;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  String? imagePath;

  getCam() async {
    _controller = CameraController(
      (await availableCameras()).first,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    getCam();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> takePictureButton = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 30),
              child: const Image(
                image: AssetImage('assets/id.png'),
                width: 250,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 250 / _controller.value.aspectRatio,
                      child: imagePath == null
                          ? FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return CameraPreview(_controller);
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          : Image.file(File(imagePath!), fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 55, bottom: 75),
              child: Text(
                "Take a clear photo of the front of your ID card",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imagePath == null
                  ? [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.accent,
                          minimumSize: const Size(222, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // <-- Radius
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await _initializeControllerFuture;
                            final image = await _controller.takePicture();
                            if (!mounted) return;
                            setState(() {
                              imagePath = image.path;
                            });
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                    ]
                  : [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          minimumSize: const Size(150, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // <-- Radius
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            imagePath = null;
                          });
                        },
                        child: const Row(
                          children: [
                            Text("Retake  "),
                            Icon(Icons.close),
                          ],
                        ),
                      ),
                      const SizedBox(width: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.accent,
                          minimumSize: const Size(150, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // <-- Radius
                          ),
                        ),
                        onPressed: () async {
                          if (kDebugMode) {
                            print("PICTURE OK $imagePath");
                          }
                          context
                              .navigateWithoutBack(const RegisterExtraTags());
                        },
                        child: const Row(
                          children: [
                            Text("Looks great  "),
                            Icon(Icons.done),
                          ],
                        ),
                      ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
