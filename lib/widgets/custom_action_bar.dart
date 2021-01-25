import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/constant.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;

  CustomActionBar({this.title, this.hasBackArrow, this.hasTitle, this.hasBackground});


  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasBackground = hasBackground ?? true;

    return Container(
      decoration: BoxDecoration(
        gradient: _hasBackground ? LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0)
          ],
          begin: Alignment(0,0),
          end: Alignment(0,1)
        ) : null
      ),
      padding: EdgeInsets.only(
        top: 55.0,
        left: 24.0,
        right: 24.0,
        bottom: 24.0
      ),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(9.0)
                ),
              child:
              Padding(
                padding: EdgeInsets.all(10),
                child : Image(
                  image: AssetImage(
                      "assets/images/back_arrow.png"
                  ),
                  color: Colors.white,
                  width: 5.0,
                  height: 5.0,
                ),
              )

          ),
            ),
          if(_hasTitle)
          Text(
            title ?? "Action Bar",
            style: Constants.boldHeading,
          ),
          Container(
            width: 42.0,
            height: 42.0,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(9.0)
            ),
            alignment: Alignment.center,
            child: Text(
              "0",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          )
        ],
      )
    );
  }
}
