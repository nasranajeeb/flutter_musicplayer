import 'package:Zylae/_screens.dart/favouriteslist.dart';
import 'package:flutter/material.dart';
import 'package:Zylae/Db/function/db_function.dart';
import 'package:Zylae/Db/model/playlist_model.dart';
import 'package:Zylae/_screens.dart/fonts.dart';
import 'package:Zylae/_screens.dart/most_played.dart';
import 'package:Zylae/_screens.dart/new_playlist.dart';
import 'package:Zylae/_screens.dart/recently_played.dart';
import 'package:Zylae/_screens.dart/select_songs_to_playlist.dart';
import 'package:Zylae/_screens.dart/theme.dart';
import 'package:Zylae/_screens.dart/widgets/media_query.dart';

// ignore: camel_case_types
class playlists extends StatefulWidget {
  const playlists({super.key});

  @override
  State<playlists> createState() => _playlistsState();
}

// ignore: camel_case_types
class _playlistsState extends State<playlists> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> playlists = [
    "Recently played",
    "Most played",
    "Favorites",
  ];
  TextEditingController namecontroller = TextEditingController();
  String newPlaylistName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      body: SafeArea(
          child: FutureBuilder(
            future: getFromPlaylist(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<String> allPlaylists = List.from(playlists);
          
                allPlaylists
                    .addAll(snapshot.data!.map((playlist) => playlist.name));
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: mediaqueryHeight(0.022, context),
                    mainAxisSpacing: mediaqueryHeight(0.025, context),
                  ),
                  itemCount: allPlaylists.length,
                  itemBuilder: (BuildContext context, int index) {
                    PlaylistDbModel? currentPlaylist;
                    if (index < playlists.length) {
                      currentPlaylist = null;
                    } else {
                      int playlistIndex = index - playlists.length;
                      if (playlistIndex < snapshot.data!.length) {
                        currentPlaylist = snapshot.data![playlistIndex];
                      } else {
                        currentPlaylist = null;
                      }
                    }
                    return buildContainer(allPlaylists[index],
                        index < playlists.length, index, currentPlaylist);
                  },
                );
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkplaylistNames();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Form(
                key: _formKey,
                child: AlertDialog(
                    backgroundColor: greyColor2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    title: Center(
                        child: myText('Create New Playlist',
                            mediaqueryWidth(0.052, context), Colors.black)),
                    content: TextFormField(
                      controller: namecontroller,
                      onChanged: (value) {
                        _name = value;
                      },
                      validator: (value) {
                        String trimmedValue = value!.trim();
                        if (trimmedValue == 'Recently played' ||
                            trimmedValue == 'Most played' ||
                            trimmedValue == 'Favorites' ||
                            trimmedValue == 'Recordings' ||
                            playlistNames.contains(trimmedValue)) {
                          return "Playlist already exists";
                        } else if (trimmedValue == "") {
                          return "Please enter a name";
                        } else {
                          return null;
                        }
                      },
                      maxLength: 18,
                      decoration: const InputDecoration(
                          hintText: "Enter playlist name",
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: mediaqueryWidth(0.05, context),
                        right: mediaqueryWidth(0.05, context)),
                    actions: <Widget>[
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 56, 21, 50))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'cancel',
                            style: TextStyle(
                                fontSize: mediaqueryHeight(0.020, context),
                                color: Colors.white),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.099,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 56, 21, 50))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addPlaylist(name: _name, songId: []);

                            namecontroller.clear();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);

                            setState(() {});
                          } else {
                            return;
                          }
                        },
                        child: Text(
                          'save',
                          style: TextStyle(
                              fontSize: mediaqueryHeight(0.020, context),
                              color: Colors.white),
                        ),
                      )
                    ]),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  buildContainer(String title, bool isInitialPlaylist, int index,
      PlaylistDbModel? functPlaylist) {
    return InkWell(
      onTap: () {
        if (title == "Favorites") {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const Myfavorites(
                        fromPlaylist: true,
                      )))
              .then((value) {
            setState(() {});
          });
        } else if (title == "Recently played") {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => const Myplayedlist()))
              .then((value) {
            setState(() {});
          });
        } else if (title == "Most played") {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const MostPlayedScreen()))
              .then((value) {
            setState(() {});
          });
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => Mynewplaylist(
                        playlistName: title,
                        playlistModel: functPlaylist!,
                      )))
              .then((value) {
            setState(() {});
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF828282),
                const Color(0xFFDDDDDD).withOpacity(0)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      isInitialPlaylist
                          ? getIconForPlaylist(title)
                          : Icons.music_note,
                      size: mediaqueryHeight(0.045, context),
                      color: const Color(0xFF1D1E1E),
                    ),
                  ),
                  SizedBox(height: mediaqueryHeight(0.012, context)),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "FiraSans",
                      color: greyColor2,
                      fontSize: mediaqueryHeight(0.021, context),
                    ),
                  ),
                ],
              ),
              if (!isInitialPlaylist)
                Positioned(
                  top: 0,
                  right: 0,
                  child: PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.grey,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'Add',
                        height: mediaqueryWidth(0.1, context),
                        child: myText('Add', mediaqueryWidth(0.046, context),
                            Colors.black),
                      ),
                      PopupMenuItem<String>(
                        value: 'Rename',
                        height: mediaqueryWidth(0.1, context),
                        child: myText('Rename', mediaqueryWidth(0.046, context),
                            Colors.black),
                      ),
                      PopupMenuItem<String>(
                        value: 'Delete',
                        height: mediaqueryWidth(0.1, context),
                        child: myText('Delete', mediaqueryWidth(0.046, context),
                            Colors.black),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'Add':
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SelectSongs(playlistModel: functPlaylist!)));
                          break;
                        case 'Rename':
                          alertDialogue(
                              context: context,
                              name: title,
                              playlists: functPlaylist);
                          break;
                        case 'Delete':
                          deleteAlert(context: context, index: index - 3);
                          break;
                      }
                    },
                    icon: Icon(Icons.more_vert,
                        size: mediaqueryWidth(0.058, context),
                        color: const Color.fromARGB(255, 193, 193, 193)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIconForPlaylist(String playlistTitle) {
    if (playlistTitle == "Recently played") {
      return Icons.music_note;
    } else if (playlistTitle == "Most played") {
      return Icons.music_note;
    } else if (playlistTitle == "Favorites") {
      return Icons.music_note;
    } else {
      return Icons.folder;
    }
  }

  alertDialogue(
      {required BuildContext context,
      String? name,
      PlaylistDbModel? playlists}) {
    showDialog(
      context: context,
      builder: (ctx2) {
        String newPlaylistName = name ?? "";
        namecontroller.text = newPlaylistName;
        return Form(
          child: AlertDialog(
            backgroundColor: greyColor2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Center(
              child: myText("Create Playlist", mediaqueryWidth(0.049, context),
                  Colors.black),
            ),
            content: TextFormField(
              controller: namecontroller,
              onChanged: (value) {
                newPlaylistName = value.trim();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                String trimmedValue = value!.trim();
                if (trimmedValue == 'Recently played' ||
                    trimmedValue == 'Most played' ||
                    trimmedValue == 'Favorites' ||
                    playlistNames.contains(trimmedValue)) {
                  return "Playlist already exists";
                } else if (trimmedValue == "") {
                  return "Please enter a name";
                } else {
                  return null;
                }
              },
              maxLength: 18,
              decoration: const InputDecoration(
                hintText: "playlist name",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
                left: mediaqueryWidth(0.05, context),
                right: mediaqueryWidth(0.05, context)),
            actions: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 56, 21, 50)),
                      ),
                      onPressed: () {
                        namecontroller.clear();
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: "FiraSans",
                            color: Colors.white,
                            fontSize: mediaqueryWidth(0.046, context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 56, 21, 50)),
                      ),
                      onPressed: () {
                        if (name != null) {
                          renamePlaylist(
                            playlist: playlists!,
                            newName: newPlaylistName,
                          );
                        } else {
                          addPlaylist(name: newPlaylistName, songId: []);
                        }

                        Navigator.of(context).pop();
                        namecontroller.clear();
                        setState(() {});
                      },
                      child: Center(
                        child: Text(
                          name == null ? "Create" : "Update",
                          style: TextStyle(
                            fontFamily: "FiraSans",
                            color: Colors.white,
                            fontSize: mediaqueryWidth(0.046, context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  deleteAlert({required BuildContext context, required int index}) {
    showDialog(
      context: context,
      builder: (ctx2) {
        return AlertDialog(
          backgroundColor: greyColor2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Center(
            child: myText("Delete playlist ?", mediaqueryWidth(0.052, context),
                Colors.black),
          ),
          contentPadding: EdgeInsets.only(
              left: mediaqueryWidth(0.05, context),
              right: mediaqueryWidth(0.05, context)),
          actions: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 56, 21, 50)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: "FiraSans",
                          color: Colors.white,
                          fontSize: mediaqueryWidth(0.046, context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 121, 28, 21)),
                    ),
                    onPressed: () {
                      deletePlayList(index);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: "FiraSans",
                          color: Colors.white,
                          fontSize: mediaqueryWidth(0.046, context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ignore: unused_element
String _name = '';
