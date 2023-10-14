import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:izzup/Views/Discussions/discussions_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../Models/photo.dart';
import '../../Models/scale.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';
import '../LastJobOffers/last_job_offers.dart';
import '../LastJobRequests/last_job_requests.dart';
import '../SignIn/signin_landing.dart';
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
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      if (context.mounted) {
        var photo = context.read<Photo>();
        photo.modifyPhoto(imageTemp);
      }
      await Api.uploadProfilePhoto(imageTemp.path);
      await _loadUser();
    } on PlatformException catch (e) {
      if (kDebugMode) print('Failed to pick image: $e');
    }
  }

  Widget _sectionText(
      String text, String arrowAssetName, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent, width: 1),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: AppColors.accent,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 20,
              bottom: 20,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 24,
              ),
            ),
          ],
        ),
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
                              padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                      fontSize: 24),
                                  textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
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
                                                      AppLocalizations.of(context)
                                                          ?.homeProfile_camera ??
                                                          'Camera',
                                                      textScaleFactor:
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                    ),
                                                    leading:
                                                    const Icon(Icons.camera),
                                                    onTap: () => pickImage(
                                                        ImageSource.camera),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      AppLocalizations.of(context)
                                                          ?.homeProfile_gallery ??
                                                          'Gallery',
                                                      textScaleFactor:
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                    ),
                                                    leading:
                                                    const Icon(Icons.photo),
                                                    onTap: () => pickImage(
                                                        ImageSource.gallery),
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    },
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width / 3,
                                      height:
                                      MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                          color: (image == null && user?.photo == null) ? const Color(0xFFe0e0e0) : Colors.white38,
                                          shape: BoxShape.circle,
                                          border: const Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.grey,
                                                  width: 10))),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    3)),
                                        child: _isLoading
                                            ? null
                                            : image != null
                                            ? Image.file(image!,
                                            fit: BoxFit.cover)
                                            : user?.photo == null
                                            ? const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        )
                                            : Image.network(
                                            user?.photo ?? "",
                                            fit: BoxFit.cover),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _sectionText(
                              AppLocalizations.of(context)?.profile_chats ??
                                  "Chats",
                              "assets/arrow_right.png", () {
                            context.push(const DiscussionPage());
                          }, Icons.chat_rounded),
                          const SizedBox(width: 20),
                          if (user?.role.value == "EXTRA")
                            _sectionText(
                                AppLocalizations.of(context)?.profile_tags ??
                                    "Tags",
                                "assets/arrow_right.png", () {
                              context.push(const TagsScreen());
                            }, Icons.tag),
                          if (user?.role.value == "EMPLOYER")
                            _sectionText(
                                AppLocalizations.of(context)
                                    ?.homeProfile_myContracts ??
                                    "My contracts",
                                "assets/arrow_right.png", () {
                              context.push(const LastJobOfferListPage());
                            }, Icons.handyman_rounded),
                        ],
                      ),
                      if (user?.role.value == "EXTRA")
                        const SizedBox(height: 20),
                      if (user?.role.value == "EXTRA")
                        _sectionText(
                            AppLocalizations.of(context)
                                ?.homeProfile_myLastJobs ??
                                "My last jobs",
                            "assets/arrow_right.png", () {
                          context.push(const LastJobRequestListPage());
                        }, Icons.work)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: SafeArea(
            child: IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFFe0e0e0)),
              onPressed: () {
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
                                AppLocalizations.of(context)
                                    ?.profile_logout ??
                                    'Logout',
                                textScaleFactor:
                                ScaleSize.textScaleFactor(
                                    context),
                              ),
                              leading:
                              const Icon(Icons.logout),
                              onTap: () async {
                                setState(() => _isLoading = true);
                                await Globals.logout();
                                setState(() => _isLoading = false);
                              },
                            ),
                            ListTile(
                              title: Text(
                                  AppLocalizations.of(context)
                                      ?.profile_deleteMyAccount ??
                                      'Delete my account',
                                  textScaleFactor: ScaleSize.textScaleFactor(context),
                                  style: const TextStyle(color: Colors.red)
                              ),
                              leading:
                              const Icon(Icons.delete_forever, color: Colors.red),
                              onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)?.profile_deleteMyAccount_alertTitle ?? "Account Deletion"),
                                content: Text(AppLocalizations.of(context)?.profile_deleteMyAccount_alertContent ?? "Are you sure you want to delete your account ?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)?.profile_no ?? "No", style: const TextStyle(color: Colors.black))),
                                  TextButton(onPressed: () => Globals.deleteAccount(), child: Text(AppLocalizations.of(context)?.profile_yes ?? "Yes", style: const TextStyle(color: Colors.red))),
                                ],
                              )
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                );
              },
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
