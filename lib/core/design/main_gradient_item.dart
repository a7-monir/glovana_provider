import 'package:flutter/material.dart';

class MainGradientItem extends StatelessWidget {
  final bool isFromTop;
  final double? height;
  final List<Color>? colors;
  const MainGradientItem({super.key,  this.isFromTop=true, this.colors, this.height});

  @override
  Widget build(BuildContext context) {
    return     Container(
      height:height?? MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors??[
            if(isFromTop)
            Color(0xffF0BFBF),
            Color(0xffFDF3EB),
            Color(0xffFDF3EB),
            Color(0xffFDF3EB),
            Color(0xffFDF3EB),
            if(!isFromTop)
              Color(0xffF0BFBF),

          ],
        ),
      ),
    );
  }
}
