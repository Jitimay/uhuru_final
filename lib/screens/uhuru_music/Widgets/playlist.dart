// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class PlayLists extends StatelessWidget {
  const PlayLists({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 1; i < 20; i++)
            Container(
              margin: EdgeInsets.only(top: 20, right: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF30314d),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "PlayListsPage");
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'images/pink-hair-1450045_1280.jpg',
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Imagine-Dragons',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '30 songs',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.more_vert,
                    color: Colors.pink,
                    size: 30,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
