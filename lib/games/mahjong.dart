import 'package:flutter/material.dart';

import '../widgets/layered.dart';

class MahjongPets extends StatelessWidget {
  const MahjongPets({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahjong Pets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _MyHomePage(title: 'Princess Peanutbutter'),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({required this.title});

  final String title;

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

const String imageURL =
    'https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-'
    'free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*';

class _MyHomePageState extends State<_MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: buildLayeredTiles()),
    );
  }
}
