import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ing_mobile/configs/constants.dart';
import 'package:ing_mobile/features/authentication/screens/login.dart';
import 'package:ing_mobile/features/profile/github_utilities/generated/assets.dart';
import 'package:ing_mobile/features/profile/github_utilities/json/shortcut_list.dart';
import 'package:ing_mobile/features/profile/github_utilities/repo/repository.dart';
import 'package:ing_mobile/features/profile/github_utilities/utils/iconly/iconly_bold.dart';
import 'package:ing_mobile/features/profile/github_utilities/widgets/custom_list_tile.dart';
import 'package:ing_mobile/models/user.dart';
import 'package:ing_mobile/utilities/animation/slideleft_toright.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  final user = FirebaseAuth.instance.currentUser!;
  UserModel? userData;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    final userCollection = await FirebaseFirestore.instance.collection('Users').where('Uid', isEqualTo: user.uid).get();
    final userDoc = userCollection.docs[0];

    userData = UserModel.fromDocumentSnapshot(userDoc);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const Gap(40),
          Stack(
            children: [
              Container(
                height: 280,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Repository.accentColor(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(60),
                      Center(
                          child: Text(
                            (userData != null) ? userData!.name : '',
                            style: TextStyle(
                                  color: Repository.textColor(context), fontSize: 30, fontWeight: FontWeight.bold))),
                      const Gap(10),
                      Text((userData != null) ? userData!.email : '',
                          style:
                              TextStyle(color: Repository.subTextColor(context), fontSize: 16)),
                      const Gap(25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: profilesShortcutList.map<Widget>((e) {
                          return GestureDetector(
                            onTap: () {
                              loadingDialog(context);

                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                SlideLeftToRight(page: const LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.all(13),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(e['icon'], color: e['color']),
                            ),
                          );
                        }).toList(),
                      ),
                      const Gap(25)
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE486DD),
                  ),
                  child: Transform.scale(
                    scale: 0.55,
                    child: Image.asset(Assets.memoji6),
                  ),
                ),
              )
            ],
          ),
          const Gap(50),
          CustomListTile(
              icon: Icons.handshake,
              color: const Color.fromARGB(255, 201, 0, 71),
              title: 'Terms and Conditions', context: context),
          const Gap(10),
          CustomListTile(
              icon: IconlyBold.Shield_Done,
              color: const Color(0xFF229e76),
              title: 'Security', context: context),
          const Gap(10),
          CustomListTile(
              icon: IconlyBold.Message,
              color: const Color(0xFFe17a0a),
              title: 'Contact us', context: context),
          const Gap(10),
          CustomListTile(
              icon: IconlyBold.Document,
              color: const Color(0xFF064c6d),
              title: 'Support', context: context),
        ],
      ),
    );
  }
}

