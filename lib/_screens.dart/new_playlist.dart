import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/Db/model/playlist_model.dart';
import 'package:Zylae/_screens.dart/home.dart';
import 'package:Zylae/_screens.dart/main_page.dart';
import 'package:Zylae/_screens.dart/select_songs_to_playlist.dart';
import 'package:Zylae/_screens.dart/share_function.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Mynewplaylist extends StatefulWidget {
  String playlistName;
  PlaylistDbModel playlistModel;
  Mynewplaylist(
      {required this.playlistName, required this.playlistModel, super.key});

  @override
  State<Mynewplaylist> createState() => _MynewplaylistState();
}

class _MynewplaylistState extends State<Mynewplaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  automaticallyImplyLeading: false,
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: const Color.fromARGB(255, 27, 8, 39),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectSongs(
                              playlistModel: widget.playlistModel,
                            ))).then((value) {
                  setState(() {});
                });
              })
        ],
        title: Text(
          widget.playlistName,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      body: FutureBuilder(
          future: playlistSongs(playslist: widget.playlistModel),
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
                                          sliderval: 0,
                                        )),
                              );
                            },
                            title: Text(item.data![index].name,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(color: Colors.white)),
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
                                        Text(
                                          'Add To Favourite',
                                          style: GoogleFonts.inter(
                                              color: Colors.black,fontSize: mediaqueryHeight(0.020, context),fontWeight: FontWeight.bold),
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
                                        const Icon(Icons.share,
                                            color: Colors.black),
                                        Text(
                                          'Share',
                                          style: GoogleFonts.inter(
                                              color: Colors.black,fontSize: mediaqueryHeight(0.020, context),fontWeight: FontWeight.bold),
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

  void getaudio() {}
}
