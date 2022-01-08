import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';

class MusicBottomSheet extends StatefulWidget {
  final BuildContext context;
  final String userID;

  MusicBottomSheet({Key? key, required this.context, required this.userID})
      : super(key: key);

  @override
  _MusicBottomSheetState createState() => _MusicBottomSheetState();
}

class _MusicBottomSheetState extends State<MusicBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("✨ Mystery User ✨", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(                  
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Song name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text("Song artist", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
                    ],
                  ),
                  Icon(Icons.arrow_right_rounded)
                ],),
              style: ElevatedButton.styleFrom(primary: Constants.kSecondaryDarkBackgroundColor, onPrimary: Colors.white,
              shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                    
                  )),
              onPressed: () {
              },
            )
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(                  
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Song name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text("Song artist", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
                    ],
                  ),
                  Icon(Icons.arrow_right_rounded)
                ],),
              style: ElevatedButton.styleFrom(primary: Constants.kSecondaryDarkBackgroundColor, onPrimary: Colors.white,
              shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                    
                  )),
              onPressed: () {
              },
            )
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(                  
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Song name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text("Song artist", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
                    ],
                  ),
                  Icon(Icons.arrow_right_rounded)
                ],),
              style: ElevatedButton.styleFrom(primary: Constants.kSecondaryDarkBackgroundColor, onPrimary: Colors.white,
              shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                    
                  )),
              onPressed: () {
              },
            )
          ),
          SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(                   
              child: Text('Close'),
              style: ElevatedButton.styleFrom(primary: Colors.transparent, onPrimary: Colors.white,
              shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10),
                    side: BorderSide(color: Constants.kPrimaryColor, width: 2)
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          )       
        ],
      ),),
    );
  }
}