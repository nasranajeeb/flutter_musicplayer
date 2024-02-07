import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/Db/model/db_model.dart';
import 'package:Zylae/Db/model/playlist_model.dart';
import 'package:Zylae/_screens.dart/home.dart';
import 'package:Zylae/_screens.dart/main_page.dart';
import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class SelectSongs extends StatefulWidget {
  final PlaylistDbModel playlistModel;
  const SelectSongs({required this.playlistModel, super.key});

  @override
  State<SelectSongs> createState() => _SelectSongsState();
}

// ignore: camel_case_types
class _SelectSongsState extends State<SelectSongs> {
  // ignore: override_on_non_overriding_member

  final _audioquery = OnAudioQuery();
  late Future<List<MusicSong>> s;
  @override
  void initState() {
    super.initState();
    checkSongOnPlaylist(playlist: widget.playlistModel);
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
          'Select Songs',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
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
                              trailing: songsinPlylist
                                      .contains(item.data![index].songid)
                                  ? IconButton(
                                      onPressed: () {
                                        removeSongsFromPlaylist(
                                            songid: item.data![index].songid,
                                            playlist: widget.playlistModel);

                                        checkSongOnPlaylist(
                                            playlist: widget.playlistModel);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: mediaqueryHeight(0.03, context),
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        addSongsToPlaylist(
                                            songid: item.data![index].songid,
                                            playlist: widget.playlistModel);

                                        checkSongOnPlaylist(
                                            playlist: widget.playlistModel);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: mediaqueryHeight(0.03, context),
                                        color: Colors.white,
                                      ),
                                    )));
                    },
                  );
          }),
    );
  }
}
