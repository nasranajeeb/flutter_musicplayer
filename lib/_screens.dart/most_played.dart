import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/_screens.dart/addtoplaylist.dart';
import 'package:Zylae/_screens.dart/main_page.dart';
import 'package:Zylae/_screens.dart/share_function.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MostPlayedScreen extends StatefulWidget {
  const MostPlayedScreen({super.key});

  @override
  State<MostPlayedScreen> createState() => _MostPlayedScreenState();
}

class _MostPlayedScreenState extends State<MostPlayedScreen> {
  final audioPlayer = AudioPlayer();
  final _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getaudio() async {
    try {
      List<SongModel> song = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      song =
          song.where((song) => !song.data.contains("WhatsApp Audio")).toList();

      mostPlayedUpdate(songs: song);
      return song;
    } catch (e) {
      debugPrint("Error fetching songs: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: const Color.fromARGB(255, 27, 8, 39),
        title: Text(
          'Most Played Songs',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      body: FutureBuilder(
          future: mostPlayedSongs(),
          builder: (context, item) {
            //  getaudio();
            return item.data == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: item.data!.length < 10 ? item.data!.length : 10,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 27, 8, 39),
                        child: ListTile(
                            onTap: () {
                              {
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
                                      sliderval: 0,
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              }
                            },
                            title: Text(item.data![index].name,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(color: Colors.white)),
                            subtitle: Text(
                              item.data![index].artist.toString(),
                              style: GoogleFonts.inter(color: Colors.grey),
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
                                  borderRadius: BorderRadius.circular(10)),
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
                                              color: Colors.black,
                                              fontSize: mediaqueryHeight(
                                                  0.020, context),
                                              fontWeight: FontWeight.bold),
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
                                              color: Colors.black,
                                              fontSize: mediaqueryHeight(
                                                  0.020, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddToPlayslist(
                                                      song: item.data![index],
                                                      fromAllSongsScreen:
                                                          true)));
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
                                              color: Colors.black,
                                              fontSize: mediaqueryHeight(
                                                  0.020, context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      sharemusic(item.data![index]);
                                    },
                                  )
                                ];
                              },
                            )),
                      );
                    },
                  );
          }),
    );
  }
}
