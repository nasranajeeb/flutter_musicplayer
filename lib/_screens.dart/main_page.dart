// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/Db/model/db_model.dart';
import 'package:Zylae/_screens.dart/addtoplaylist.dart';
import 'package:Zylae/_screens.dart/home.dart';
import 'package:Zylae/_screens.dart/share_function.dart';
import 'package:Zylae/_screens.dart/widgets/lyrics_sheet.dart';
import 'package:Zylae/_screens.dart/widgets/media_query.dart';
import 'package:Zylae/_screens.dart/widgets/network_connection.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MySong extends StatefulWidget {
  MySong(
      {super.key,
      required this.songmodel,
      required this.index,
      required this.audioPlayer,
      required this.fromFavscreen,
      required double sliderval});
  final List<MusicSong> songmodel;
  int index;
  final AudioPlayer audioPlayer;
  bool fromFavscreen;

  @override
  State<MySong> createState() => _MySongState();
}

bool isFavorite = false;

class _MySongState extends State<MySong> with SingleTickerProviderStateMixin {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  @override
  void initState() {
    playSong(widget.songmodel[widget.index].uri);

    super.initState();
  }

  Future<void> toggleFavorite() async {
    final song = widget.songmodel[widget.index];

    await checkIsFav();

    if (favoriteSongIds.contains(song.songid)) {
      removeSongFromFav(songId: song.songid);
      setState(() {
        isFavorite = false;
      });
      // deleteFromFavoriteAlert(context);
    } else {
      await addSongToFav(songId: song.songid);

      //  addToFavoritesAlert(context);
    }
    await checkIsFav();
  }

  bool _isplaying = true;
  bool showLyrics = false;
  bool isFetchingLyrics = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: const Color.fromARGB(255, 27, 8, 39),
        actions: [
          PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      const Icon(Icons.favorite_border, color: Colors.black),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        'Add To Favourite',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: mediaqueryHeight(0.020, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    addSongToFav(songId: widget.songmodel[widget.index].songid);
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle_rounded, color: Colors.black),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        'Add To Playlist',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: mediaqueryHeight(0.020, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToPlayslist(
                                  fromAllSongsScreen: widget.fromFavscreen,
                                  song: widget.songmodel[widget.index],
                                ))).then((value) {
                      setState(() {});
                    });
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.share, color: Colors.black),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        'Share',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: mediaqueryHeight(0.020, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    sharemusic(widget.songmodel[widget.index]);
                  },
                )
              ];
            },
          )
        ],
        title: Text(
          'Zylea',
          style: GoogleFonts.inter(color: Colors.white),
        ),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: ArtWorkWIdget(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.001,
        ),
        Text(
          widget.songmodel[widget.index].name,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
              color: Colors.white, fontSize: mediaqueryHeight(0.023, context)),
          textAlign: TextAlign.center,
        ),
        Text(
          widget.songmodel[widget.index].artist,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
              color: Colors.grey, fontSize: mediaqueryHeight(0.02, context)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
          // width: MediaQuery.of(context).size.width*0.1,
        ),
        Slider(
          min: const Duration(microseconds: 0).inSeconds.toDouble(),
          value: _position.inSeconds.toDouble(),
          max: _duration.inSeconds.toDouble(),
          onChanged: (value) {
            setState(() {
              changetoseconds(value.toInt());
              value = value;
            });
          },
          thumbColor: Colors.white,
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
        Row(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.077,
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              _position.toString().split(".")[0],
              style: GoogleFonts.inter(color: Colors.white),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.077,
              width: MediaQuery.of(context).size.width * 0.55,
            ),
            Text(
              _duration.toString().split(".")[0],
              style: GoogleFonts.inter(color: Colors.white),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.088,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  toggleRepeat();
                  showRepeatSnackbar(widget.audioPlayer.loopMode);
                },
                icon: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: Icon(
                    Icons.repeat,
                    color: widget.audioPlayer.loopMode == LoopMode.one
                        ? Colors.blue
                        : Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
              ),
              GestureDetector(
                onTap: playPreviousSong,
                child: const Icon(
                  Icons.skip_previous_outlined,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.16),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_isplaying) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.play();
                    }
                    _isplaying = !_isplaying;
                  });
                },
                icon: Icon(
                  _isplaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              GestureDetector(
                onTap: playnextSong,
                child: const Icon(
                  Icons.skip_next_outlined,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.099,
              ),
              GestureDetector(
                  onTap: () async {
                    toggleFavorite();
                    setState(() {});
                  },
                  child: favoriteSongIds
                          .contains(widget.songmodel[widget.index].songid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                        ))
            ],
          ),
        ),
        Center(
          child: CustomInkWell(
            onTap: () async {
              bool netAvailable = await checkConnection();
              if (netAvailable) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                await showLyricsSheet(
                  context: context,
                  artist: widget.songmodel[widget.index].artist,
                  title: widget.songmodel[widget.index].name,
                );
              } else {
                netWorkErrorSnackbar(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Ink(
                padding: EdgeInsets.symmetric(
                  vertical: mediaqueryHeight(0.019, context),
                  horizontal: mediaqueryHeight(0.022, context),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Get lyrics",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> playSong(String? uri) async {
    addSongToRecentlyPlayed(widget.songmodel[widget.index].songid);
    addSongToMostPlayed(widget.songmodel[widget.index].songid);
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
    try {
      await widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.songmodel[widget.index].uri),
          tag: MediaItem(
              id: '${widget.songmodel[widget.index].songid}',
              title: widget.songmodel[widget.index].name,
              artist: widget.songmodel[widget.index].artist),
        ),
      );

      await widget.audioPlayer.play();
    } catch (e) {
      // ignore: avoid_print
      print('Error playing song: $e');
    }
  }

  void playPreviousSong() {
    if (widget.index > 0) {
      setState(() {
        widget.index--;
        _isplaying = true;

        playSong(widget.songmodel[widget.index].uri);
      });
      context
          .read<SongModelProvider>()
          .setId(widget.songmodel[widget.index].songid);
    }
  }

  void toggleRepeat() {
    setState(() {
      if (widget.audioPlayer.loopMode == LoopMode.one) {
        widget.audioPlayer.setLoopMode(LoopMode.off);
      } else {
        widget.audioPlayer.setLoopMode(LoopMode.one);
      }
    });
  }

  void showRepeatSnackbar(LoopMode loopMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            loopMode == LoopMode.off ? 'Repeat is OFF' : 'Repeat is ON',
            style: GoogleFonts.aboreto(
                color: Colors.black,
                fontSize: mediaqueryHeight(0.020, context)),
          ),
          backgroundColor: Colors.white),
    );
  }

  void playnextSong() {
    if (widget.index < widget.songmodel.length) {
      setState(() {
        widget.index++;
        _isplaying = true;

        playSong(widget.songmodel[widget.index].uri);
      });
      context
          .read<SongModelProvider>()
          .setId(widget.songmodel[widget.index].songid);
    }
  }

  void changetoseconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}

class CustomInkWell extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  // ignore: use_super_parameters
  const CustomInkWell({Key? key, this.onTap, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        splashColor: const Color(0xFF153C44),
        child: ClipPath(
          clipper: MyClipper(),
          child: child,
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
        const Radius.circular(30)));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ArtWorkWIdget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors, non_constant_identifier_names
  const ArtWorkWIdget({Key? Key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: QueryArtworkWidget(
        keepOldArtwork: true,
        id: context.watch<SongModelProvider>().id,
        type: ArtworkType.AUDIO,
        artworkHeight: MediaQuery.of(context).size.width * 0.65,
        artworkWidth: MediaQuery.of(context).size.width * 0.65,
        artworkQuality: FilterQuality.high,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: Icon(
          Icons.music_note,
          color: Colors.white,
          size: mediaqueryHeight(0.3, context),
        ),
      ),
    );
  }
}
