import 'package:anthem/globals/globals.dart';
import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';

class RecommendedSongsPage extends StatefulWidget {
  final List<dynamic> recommendedSongs;

  RecommendedSongsPage({Key? key, required this.recommendedSongs})
      : super(key: key);

  @override
  _RecommendedSongsPageState createState() => _RecommendedSongsPageState();
}

class _RecommendedSongsPageState extends State<RecommendedSongsPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Recommended songs",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) => Divider(),
                        shrinkWrap: true,
                        itemCount: widget.recommendedSongs.length,
                        itemBuilder: (context, index) {
                          final item = widget.recommendedSongs[index];
                          return SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(                  
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row (
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: Text(item["name"].toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: Text((item["artists"] as List<dynamic>).join(", "), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300),
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_right_rounded)
                                ],),
                              style: ElevatedButton.styleFrom(primary: Constants.kSecondaryDarkBackgroundColor, onPrimary: Colors.white,
                              shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10),
                                    
                                  )),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongDetailsPage(item["id"]),
                                  ),
                                );
                              },
                            )
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}