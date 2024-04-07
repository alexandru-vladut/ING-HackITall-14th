import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ing_mobile/configs/constants.dart';
import 'package:ing_mobile/models/user.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {

  final user = FirebaseAuth.instance.currentUser!;
  List<UserModel>? topThreeUsers;
  List<UserModel>? otherUsers;

  @override
  void initState() {
    print('initState() called, ${topThreeUsers?[0].name}');
    print('initState() called, ${otherUsers?[0].name}');
    getUsers();
    super.initState();
  }

  void getUsers() async {
    
    final userCollection = await FirebaseFirestore.instance.collection('Users').where('Uid', isEqualTo: user.uid).get();
    final userDoc = userCollection.docs[0];

    UserModel userData = UserModel.fromDocumentSnapshot(userDoc);

    // Reference to Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // Query to get users in the same company, ordered by totalPoints
    QuerySnapshot querySnapshot = await users
        .where('CompanyId', isEqualTo: userData.companyId)
        .where('Role', isNotEqualTo: 'Admin')
        .orderBy('Role')
        .orderBy('TotalPoints', descending: true)
        .get();

    List<UserModel> userModels = querySnapshot.docs
      .map((doc) => UserModel.fromQueryDocumentSnapshot(doc as QueryDocumentSnapshot<Map<String, dynamic>>))
      .toList();

    topThreeUsers = userModels.take(3).toList();
    otherUsers = userModels.skip(3).toList();

    print('getUsers() called, ${topThreeUsers?[0].name}');
    print('getUsers() called, ${otherUsers?[0].name}');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('build() called, ${topThreeUsers?[0].name}');
    print('build() called, ${otherUsers?[0].name}');
    return Scaffold(
      body: (topThreeUsers == null || otherUsers == null)
        ? const Center(child: CircularProgressIndicator()) :
        Stack(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/leaderboard/leaderboard3.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 25,
                        child: Image.asset(
                          "assets/leaderboard/line.png",
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 340,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: otherUsers!.length,
                    itemBuilder: (context, index) {
                      final item = otherUsers![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 15),
                        child: Row(
                          children: [

                            Text(
                              (index + 4).toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 96, 96, 96),
                              ),
                            ),

                            const SizedBox(width: 15),

                            CircleAvatar(
                              radius: 25,
                              backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                              foregroundImage: AssetImage(memojiPaths[(index + 3) % 9]),
                            ),

                            const SizedBox(width: 15),

                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 240, 240, 240),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  const Icon(
                                    Icons.token,
                                    color: Color.fromARGB(255, 255, 187, 0),
                                  ),

                                  Text(
                                    item.totalPoints.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
            const Positioned(
              top: 70,
              left: 120,
              child: Text(
                "Leaderboard",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Rank 1st
            Positioned(
              top: 135,
              left: 150,
              child: rank(
                  radius: 45.0,
                  height: 3,
                  image: "assets/memoji/1.png",
                  name: topThreeUsers![0].name,
                  point: topThreeUsers![0].totalPoints.toString(),),
            ),
            // for rank 2nd
            Positioned(
              top: 200,
              left: 45,
              child: rank(
                  radius: 30.0,
                  height: 2,
                  image: "assets/memoji/2.png",
                  name: topThreeUsers![1].name,
                  point: topThreeUsers![1].totalPoints.toString(),),
            ),
            // For 3rd rank
            Positioned(
              top: 220,
              right: 50,
              child: rank(
                  radius: 30.0,
                  height: 2,
                  image: "assets/memoji/3.png",
                  name: topThreeUsers![2].name,
                  point: topThreeUsers![2].totalPoints.toString(),),
            ),
          ],
        ),
    );
  }

  Column rank({
    required double radius,
    required double height,
    required String image,
    required String name,
    required String point,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          foregroundImage: AssetImage(image),
        ),
        SizedBox(
          height: height,
        ),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: height,
        ),
        Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              const Icon(
                Icons.token,
                color: Color.fromARGB(255, 255, 187, 0),
              ),

              Text(
                point,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }
}
