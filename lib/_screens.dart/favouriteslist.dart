import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/Db/model/db_model.dart';
import 'package:Zylae/_screens.dart/home.dart';
import 'package:Zylae/_screens.dart/main_page.dart';
import 'package:Zylae/_screens.dart/theme.dart';
import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Myfavorites extends StatefulWidget {
  final bool? fromPlaylist;
  const Myfavorites({super.key, this.fromPlaylist});

  @override
  State<Myfavorites> createState() => _MyfavoritesState();
}

class _MyfavoritesState extends State<Myfavorites> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: bgTheme(),
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 27, 8, 39),
            title: Text(
              'My Favorites',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            // child: Padding(
            // padding: screenPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.fromPlaylist == true)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          // size: mediaqueryHeight(0.028, context),
                          // color: greyColor,
                        ),
                      ),
                    if (widget.fromPlaylist == true)
                      const SizedBox(
                          // width: mediaqueryHeight(0.015, context),
                          ),
                    // myText(
                    // "Favorites", mediaqueryHeight(0.030, context), greyColor),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<List<MusicSong>>(
                    future: favSongList(),
                    builder: (context, items) {
                      if (items.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (items.data!.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              "No songs added to favorites",
                              style: TextStyle(
                                fontFamily: "FiraSans",
                                color: greyColor2,
                                fontSize: mediaqueryWidth(0.045, context),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    context
                                        .read<SongModelProvider>()
                                        .setId(items.data![index].songid);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => MySong(
                                                  audioPlayer: audioPlayer,
                                                  index: index,
                                                  songmodel: items.data!,
                                                  fromFavscreen: true,
                                                  sliderval: 0,
                                                )))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  leading: QueryArtworkWidget(
                                    id: items.data![index].songid,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      items.data![index].name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                        onTap: () async {
                                          int songId =
                                              items.data![index].songid;

                                          await removeSongFromFav(
                                              songId: songId);

                                          setState(() {});

                                          // deleteFromFavoriteAlert(context);
                                        },
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      items.data![index].artist.toString(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // screenDivider(context),
                                const Divider(),
                              ],
                            );
                          },
                          itemCount: items.data!.length,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
