import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/api.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Register/register_success.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterIdCard extends StatefulWidget {
  const RegisterIdCard({super.key});

  @override
  State<RegisterIdCard> createState() => _RegisterIdCardState();
}

class _RegisterIdCardState extends State<RegisterIdCard> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  String? imagePath;

  getCam() {
    Permission.camera.status;
    _controller = CameraController(
      Globals.firstCamera,
      ResolutionPreset.max,
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
  bool _isLoading = false;

  Future<bool> _onValidatePressed() async {
    setState(() => _isLoading = true);
    if (imagePath == null) return false;

    if (await Api.uploadIdPhoto(imagePath!)) {
      if (context.mounted) context.navigateWithoutBack(const RegisterSuccess());
    } else {
      setState(() => imagePath = null);
    }
    setState(() => _isLoading = false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return imagePath == null
                        ? CameraPreview(_controller)
                        : Image.file(File(imagePath!), fit: BoxFit.fill);
                  } else {
                    return const ClassyLoader();
                  }
                },
              ),
              ClipPath(
                  clipper: _CenterRectPath(
                      dimension: Size(MediaQuery.of(context).size.width - 40,
                          MediaQuery.of(context).size.height / 4)),
                  child: Container(
                    color: AppColors.accent,
                    child: Center(
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
                            width: MediaQuery.of(context).size.width - 40,
                            height: MediaQuery.of(context).size.height / 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 55, bottom: 75),
                            child: Text(
                              AppLocalizations.of(context)
                                      ?.register_takeAClearPhoto ??
                                  "Take a clear photo of the front of your ID card",
                              style: const TextStyle(
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
                                          borderRadius: BorderRadius.circular(
                                              30), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () async {
                                        try {
                                          await _initializeControllerFuture;
                                          final image =
                                              await _controller.takePicture();
                                          if (!mounted) return;
                                          setState(() {
                                            imagePath = image.path;
                                          });
                                        } catch (e) {
                                          if (kDebugMode) print(e);
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
                                          borderRadius: BorderRadius.circular(
                                              30), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          imagePath = null;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(AppLocalizations.of(context)
                                                  ?.register_retake ??
                                              "Retake" "  "),
                                          const Icon(Icons.close),
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
                                          borderRadius: BorderRadius.circular(
                                              30), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () async {
                                        _onValidatePressed();
                                      },
                                      child: Row(
                                        children: [
                                          Text(AppLocalizations.of(context)
                                                  ?.register_looksGreat ??
                                              "Looks great" "  "),
                                          const Icon(Icons.done),
                                        ],
                                      ),
                                    ),
                                  ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
        if (_isLoading) ClassyLoader(loaderSize: MediaQuery.of(context).size.height),
      ],
    );
  }
}

class _CenterRectPath extends CustomClipper<Path> {
  final Size dimension;

  _CenterRectPath({
    required this.dimension,
  });

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: dimension.width,
                height: dimension.height),
            const Radius.circular(20)),
      )
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant _CenterRectPath oldClipper) {
    return dimension != oldClipper.dimension;
  }
}
