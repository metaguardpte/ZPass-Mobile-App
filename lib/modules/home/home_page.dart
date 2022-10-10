import 'package:flutter/material.dart';
import 'package:zpass/widgets/load_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(color: Theme.of(context).primaryColor,
                child: const Center(child: Text("Hello ZPass"))
            ),
            Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: const LoadAssetImage("home/slogan_dark", width: 160, height: 61, fit: BoxFit.contain,)
            ),
          ],
        ),
      ),
    );
  }
}
