import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Views/Discussions/discussions_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../Models/scale.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';
import '../Tag/tagpage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class CardData {
  String title;
  String description;
  String? pictureData;
  String type;
  String? link;
  String? companyId;

  CardData(this.title, this.description, this.pictureData, this.type, this.link,
      this.companyId);
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      if (context.mounted) Navigator.of(context).pop();
      final image = await ImagePicker().pickImage(source: source);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      print(await Api.uploadProfilePhoto(imageTemp.path));
      await _loadUser();
    } on PlatformException catch(e) {
      if (kDebugMode) print('Failed to pick image: $e');
    }
  }

  Widget _sectionText(String text, String arrowAssetName, VoidCallback onTap, {String? assetName, IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (assetName != null)
                  Image(
                    image: AssetImage(assetName),
                    height: 30,
                  ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 30,
                    color: AppColors.accent,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                    ),
                  ),
                ),
                Image(
                  image: AssetImage(arrowAssetName),
                  height: 20,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 60, right: 60),
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }

  User? user;

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    final fetchedUser = await Api.getProfile();
    setState(() {
      user = fetchedUser;
      Globals.profile = fetchedUser;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.accent,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: HeaderClipper(),
                      child: CustomPaint(
                        size: Size.fromHeight(
                            MediaQuery.of(context).size.height / 3),
                        painter: HeaderPainter(color: AppColors.accent),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: Row()),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3.5,
                            child: Column(
                              children: [
                                const Spacer(),
                                Text(
                                  "${user?.firstName} ${user?.lastName}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24
                                  ),
                                  textScaleFactor: ScaleSize.textScaleFactor(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      showFloatingModalBottomSheet(
                                        context: context,
                                        builder: (context) => Material(
                                            child: SafeArea(
                                              top: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      AppLocalizations.of(context)?.homeProfile_camera ?? 'Camera',
                                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                                    ),
                                                    leading: const Icon(Icons.camera),
                                                    onTap: () => pickImage(ImageSource.camera),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      AppLocalizations.of(context)?.homeProfile_gallery ?? 'Gallery',
                                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                                    ),
                                                    leading: const Icon(Icons.photo),
                                                    onTap: () => pickImage(ImageSource.gallery),
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width / 3,
                                      height:
                                      MediaQuery.of(context).size.width / 3,
                                      decoration: const BoxDecoration(
                                          color: Colors.white38,
                                          shape: BoxShape.circle,
                                          border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 10))
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    3)),
                                        child: _isLoading
                                            ? null
                                            : user?.photo == null
                                            ? const Image(image: AssetImage("assets/blank_profile_picture.png"))
                                            : Image.network(
                                            user?.photo ?? "",
                                            fit: BoxFit.fitWidth
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: Column(
                    children: [
                      _sectionText(
                          "Discussions",
                          "assets/arrow_right.png",
                              () {
                            context.push(const DiscussionPage());
                          },
                          icon: Icons.chat_rounded
                      ),
                      _sectionText(
                          "Tags",
                          "assets/arrow_right.png",
                              () {
                            context.push(const TagsScreen());
                          },
                          assetName: "assets/badge.png"
                      ),
                      _sectionText(
                          AppLocalizations.of(context)?.homeProfile_aboutMe ??
                              "About me",
                          "assets/arrow_right.png",
                              () {},
                          icon: Icons.description
                      ),
                      _sectionText(
                          AppLocalizations.of(context)
                              ?.homeProfile_myContracts ??
                              "My contracts",
                          "assets/arrow_right.png",
                              () {},
                          icon: Icons.handyman_rounded
                      ),
                      _sectionText(
                          AppLocalizations.of(context)
                              ?.homeProfile_myLastJobs ??
                              "My last jobs",
                          "assets/arrow_right.png",
                              () {},
                          icon: Icons.work
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height - 100)
      ..quadraticBezierTo(size.width / 4, (size.height - 50), size.width / 2,
          (size.height - 50))
      ..quadraticBezierTo(size.width - (size.width / 4), (size.height - 50),
          size.width, size.height - 100)
      ..lineTo(size.width, 0.0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class HeaderPainter extends CustomPainter {
  HeaderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height - 50);
    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarBounds =
    Rect.fromCircle(center: centerAvatar, radius: 50).inflate(3);
    _drawBackground(canvas, shapeBounds, avatarBounds);
  }

  @override
  bool shouldRepaint(HeaderPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect avatarBounds) {
    final paint = Paint()..color = color;

    final backgroundPath = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top)
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy)
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy)
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy)
      ..close();

    canvas.drawPath(backgroundPath, paint);
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
      context: context,
      builder: builder,
      containerWidget: (_, animation, child) => FloatingModal(
        child: child,
      ),
      expand: false);

  return result;
}

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}