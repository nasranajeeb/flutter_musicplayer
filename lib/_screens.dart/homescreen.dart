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

// ignore: camel_case_types
class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

// ignore: camel_case_types
class _homescreenState extends State<homescreen> {
  // ignore: override_on_non_overriding_member
  //  late PlaylistDbModel playlistModel;
  // List<SongModel> songs = [];

  final _audioquery = OnAudioQuery();
  late Future<List<MusicSong>> s;
  @override
  void initState() {
    super.initState();
    s = music();
  }

  double sliderValue = 0.36;
  Future<List<SongModel>> getaudio() async {
    List<SongModel> s = await _audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    addSong(s: s);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      body: FutureBuilder(
          future: music(),
          builder: (context, item) {
            getaudio();
            return item.data == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                          color: const Color.fromARGB(255, 27, 8, 39),
                          child: ListTile(
                              onTap: () {
                                context
                                    .read<SongModelProvider>()
                                    .setId(item.data![index].songid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySong(
                                            songmodel: item.data!,
                                            audioPlayer: audioPlayer,
                                            index: index,
                                            fromFavscreen: false,
                                            sliderval: sliderValue,
                                          )),
                                );
                              },
                              title: Text(item.data![index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      GoogleFonts.inter(color: Colors.white)),
                              subtitle: Text(
                                item.data![index].artist.toString(),
                                style: GoogleFonts.inter(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: QueryArtworkWidget(
                                id: item.data![index].songid,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          Text(
                                            'Add To Favourite',
                                            style: GoogleFonts.inter(
                                                fontSize: mediaqueryHeight(
                                                    0.020, context),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        addSongToFav(
                                            songId: item.data![index].songid);
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add_circle_rounded,
                                              color: Colors.black),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          Text(
                                            'Add To Playlist',
                                            style: GoogleFonts.inter(
                                                fontSize: mediaqueryHeight(
                                                    0.020, context),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddToPlayslist(
                                                      fromAllSongsScreen: true,
                                                      song: item.data![index],
                                                    )));
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.share,
                                              color: Colors.black),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          Text(
                                            'Share',
                                            style: GoogleFonts.inter(
                                                fontSize: mediaqueryHeight(
                                                    0.020, context),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        sharemusic(item.data![index]);
                                      },
                                    )
                                  ];
                                },
                              )));
                    },
                  );
          }),
    );
  }
}
