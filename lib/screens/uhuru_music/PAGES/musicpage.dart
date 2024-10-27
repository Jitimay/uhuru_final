// ignore_for_file: prefer_const_constructors, duplicate_ignore, sized_box_for_whitespace

import 'package:flutter/material.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/pink-hair-1450045_1280.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
                const Color(0xFF31314F).withOpacity(1),
                const Color(0xFF31314F).withOpacity(1),
              ])),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
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
                          size: 25,
                          color: Colors.pink,
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.more_vert,
                          size: 25,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 9,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 23, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.all(10.0)),
                                const Text(
                                  'imagine-Dragons',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'singer name',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            // ignore: prefer_const_constructors
                            Icon(
                              Icons.favorite,
                              color: Colors.green,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Slider(
                            min: 0,
                            max: 100,
                            value: 40,
                            onChanged: (value) {},
                            activeColor: Colors.white,
                            inactiveColor: Colors.white54,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '2:05',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '4:45',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.list,
                            color: Colors.pink,
                            size: 32,
                          ),
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.pink,
                            size: 32,
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.pink,
                              size: 30,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.pink,
                            size: 32,
                          ),
                          const Icon(
                            Icons.download,
                            color: Colors.pink,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
