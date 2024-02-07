
import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Zylae/_screens.dart/about_screen.dart';
import 'package:Zylae/_screens.dart/fonts.dart';
import 'package:Zylae/_screens.dart/privacy_screen.dart';
import 'package:Zylae/_screens.dart/terms_and_condition.dart';
import 'package:Zylae/_screens.dart/theme.dart';

class Menulist extends StatelessWidget {
  const Menulist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              settingshowBottomSheet(context: context);
            },
          ),
        ],
      ),
    );
  }
}

settingshowBottomSheet({required BuildContext context}) {
  showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      context: context,
      builder: (BuildContext context) {
        // ignore: avoid_unnecessary_containers
        return Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.error_outline, color: Colors.white),
              title: Text(
                'About',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.privacy_tip_outlined, color: Colors.white),
              title: Text(
                'Privacy Policy',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                // Handle the About option
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivcyScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_outlined, color: Colors.white),
              title: Text(
                'Terms And Conditions',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsAndConditions()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_border_purple500_sharp,
                  color: Colors.white),
              title: Text(
                'Rate Us',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                _showRateUsDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: Text(
                'Share App',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            )
          ],
        ));
      });
}

_showRateUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.0267,
          ),
        ),
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            gradient: bgTheme(),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.0267,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4.0,
                offset: Offset(-2, -2),
                color: Colors.white10,
              ),
              BoxShadow(
                blurRadius: 6.0,
                offset: Offset(7, 7),
                color: Colors.black,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              myText('Rate Us ', 18, Colors.white),
              const Divider(
                thickness: 1,
                color: Colors.black12,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Would you like to rate our app on the Amazon store?',
                  style: GoogleFonts.aboreto(fontSize:  mediaqueryHeight(
                                                    0.018, context), color: Colors.amber),
                ),
              ),
              RatingBar.builder(
                allowHalfRating: true,
                unratedColor: Colors.white,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                ),
                onRatingUpdate: (rating) {
                  if (rating.toInt() < 0) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    launchURL();
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> launchURL() async {
  // ignore: deprecated_member_use
}
