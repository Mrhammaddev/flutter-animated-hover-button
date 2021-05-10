import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ButtonColors {
  static get backgroundColor => const Color(0xFFECF0F1);

  static get defaultColor => const Color(0xff000000);

  static get emerald => const Color(0xff265FE1);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Button(),
    );
  }
}

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ButtonColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedButton(
            height: 60,
            width: 320,
            text: 'Emerald',
            animationColor: ButtonColors.emerald,
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final double height;
  final double width;
  final String text;
  final Color animationColor;

  AnimatedButton({this.height, this.width, this.text, this.animationColor});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  Color textColor;
  Color borderColor;
  AnimationController _controller;
  Animation _animation;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    textColor = ButtonColors.defaultColor;
    borderColor = ButtonColors.defaultColor;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween(begin: 0.0, end: 500.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: _pressed ? Color(0xff265FE1) : Colors.white,
        ),
        height: widget.height,
        width: widget.width,
        child: Material(
          child: InkWell(
            onTap: () {
              setState(() {
                _pressed = !_pressed;
              });
            },
            onHover: (value) {
              if (value) {
                _controller.forward();
                setState(() {
                  textColor = Colors.white;
                  borderColor = widget.animationColor;
                });
              } else {
                _controller.reverse();
                setState(() {
                  textColor = ButtonColors.defaultColor;
                  borderColor = ButtonColors.defaultColor;
                });
              }
            },
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.animationColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    width: _animation.value,
                  ),
                  Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(color: textColor),
                      child: Text(widget.text),
                      curve: Curves.easeIn,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
