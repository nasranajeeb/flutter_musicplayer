// ignore_for_file: camel_case_types

import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/Db/model/db_model.dart';
import 'package:Zylae/_screens.dart/addtoplaylist.dart';
import 'package:Zylae/_screens.dart/home.dart';
import 'package:Zylae/_screens.dart/main_page.dart';
import 'package:Zylae/_screens.dart/share_function.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class searchscreen extends StatefulWidget {
  @override
  State<searchscreen> createState() => _searchscreenState();
}

class _searchscreenState extends State<searchscreen> {
  List<MusicSong> findsong = [];
  List<MusicSong> songlist = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getsongs();
  }

  void getsongs() async {
    songlist = await music();
    setState(() {
      findsong = songlist;
    });
  }

  void searchFunction() {
    if (searchController.text.isEmpty) {
      setState(() {
        findsong = songlist;
      });
    } else {
      setState(() {
        findsong = songlist
            .where((song) =>
                song.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                song.artist
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 8, 39),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child: Padding(padding: EdgeInsets.all(12)),
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchFunction();
                        setState(() {});
                      },
                      cursorColor: const Color.fromARGB(255, 158, 136, 136),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 27, 8, 39),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Search Songs,Artist,Artist Name',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              searchFunction();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: findsong.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(255, 27, 8, 39),
                  child: ListTile(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        await Future.delayed(const Duration(milliseconds: 300));
                        // ignore: use_build_context_synchronously
                        context
                            .read<SongModelProvider>()
                            .setId(findsong[index].songid);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MySong(
                                    songmodel: findsong,
                                    audioPlayer: audioPlayer,
                                    index: index,
                                    fromFavscreen: true,
                                    sliderval: 0,
                                  )),
                        );
                      },
                      title: Text(findsong[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(color: Colors.white)),
                      subtitle: Text(
                        findsong[index].artist,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                      leading: QueryArtworkWidget(
                        id: findsong[index].songid,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                      trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.grey,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.favorite_border,
                                      color: Colors.black),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'Add To Favourite',
                                    style:
                                        GoogleFonts.inter(color: Colors.black,fontSize: mediaqueryHeight(0.020, context),fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () {
                                addSongToFav(songId: findsong[index].songid);
                              },
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.add_circle_rounded,
                                      color: Colors.black),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'Add To Playlist',
                                    style:
                                        GoogleFonts.inter(color: Colors.black,fontSize: mediaqueryHeight(0.020, context),fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddToPlayslist(
                                            song: findsong[index],
                                            fromAllSongsScreen: true)));
                              },
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.share, color: Colors.black),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'Share',
                                    style:
                                        GoogleFonts.inter(color: Colors.black,fontSize: mediaqueryHeight(0.020, context),fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () {
                                sharemusic(findsong[index]);
                              },
                            )
                          ];
                        },
                      )),
                );
              },
            ),
          ),
        ]));
  }
}
