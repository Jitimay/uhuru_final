// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';

class PlayListsPage extends StatelessWidget {
  const PlayListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xFF303151).withOpacity(0.6),
            const Color(0xFF303151).withOpacity(0.9),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      // ignore: prefer_const_constructors
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.pink,
                        size: 24,
                      ),
                    ),
                    const InkWell(
                      // ignore: prefer_const_constructors
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.pink,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 9,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'images/pink-hair-1450045_1280.jpg',
                  width: 250,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              Column(
                children: [
                  Text(
                    'imagin-dragons',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'singer name',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTapCancel: () {},
                    child: Container(
                      width: 150,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Play all',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.pink,
                            size: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTapCancel: () {},
                    child: Container(
                      width: 150,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Suffle',
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Icons.shuffle,
                            color: Colors.pink,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              for (int i = 1; i < 20; i++)
                Container(
                  margin: const EdgeInsets.only(top: 12, right: 10, left: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF30314D),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Text(
                        i.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'MusicPage');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'imagine dragons - believer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'bass',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  '2:34',
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 24,
                          color: Colors.pink,
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        )),
      ),
    );
  }
}
