// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Zylae/Db/model/db_favmodel.dart';
import 'package:Zylae/Db/model/db_model.dart';
import 'package:Zylae/Db/model/most_played_db_model.dart';
import 'package:Zylae/Db/model/playlist_model.dart';
import 'package:Zylae/Db/model/recently_played_db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> addSong({required List<SongModel> s}) async {
  final songDB = await Hive.openBox<MusicSong>('Song_db');
  if (songDB.isEmpty) {
    for (SongModel song in s) {
      songDB.add(MusicSong(
        songid: song.id,
        uri: song.uri.toString(),
        name: song.title.toString(),
        artist: song.artist.toString(),
        path: song.data,
      ));
    }
    music();
  } else {
    for (SongModel song in s) {
      if (!songDB.values.any((element) => element.songid == song.id.toInt())) {
        songDB.add(MusicSong(
          songid: song.id,
          uri: song.uri.toString(),
          name: song.title.toString(),
          artist: song.artist.toString(),
          path: song.data,
        ));
      }
      
    }
    music();
  }
}

Future<List<MusicSong>> music() async {
  List<MusicSong> songs = [];
  final songDB = await Hive.openBox<MusicSong>('Song_db');
  for (int i = 0; i < songDB.length; i++) {
    MusicSong a = songDB.get(i)!;
    songs.add(a);
  }
 
  return songs;
}

addSongToFav({required int songId, String? title}) async {
  final favBox = await Hive.openBox<Favmodel>('favorites');
  List<Favmodel> fd = favBox.values.toList();

  bool songAlreadyExists = fd.any((fav) => fav.songIds == (songId));

  if (!songAlreadyExists) {
    favBox.add(Favmodel(songIds: songId));
    debugPrint("Song added to fav");
  } else {
    debugPrint("Song is already in fav");
  }
}

removeSongFromFav({required int songId}) async {
  final favBox = await Hive.openBox<Favmodel>('favorites');
  List<Favmodel> fd = favBox.values.toList();

  for (int i = 0; i < fd.length; i++) {
    if (fd[i].songIds == songId) {
      favBox.deleteAt(i);
      debugPrint("song removed from fav");
    }
  }
}

Future<List<MusicSong>> favSongList() async {
  final favBox = await Hive.openBox<Favmodel>('favorites');
  List<MusicSong> allSongs = await music();
  List<Favmodel> fav = favBox.values.toList();
  List<MusicSong> favRet = [];
  for (int i = 0; i < fav.length; i++) {
    for (int j = 0; j < allSongs.length; j++) {
      if (fav[i].songIds == allSongs[j].songid) {
        favRet.add(allSongs[j]);
      }
    }
  }
  return favRet;
}

List<int> favoriteSongIds = [];

checkIsFav() async {
  favoriteSongIds.clear();
  final favBox = await Hive.openBox<Favmodel>('favorites');
  List<Favmodel> favList = favBox.values.toList();
  for (int i = 0; i < favList.length; i++) {
    favoriteSongIds.add(favList[i].songIds);
  }
}

void addSongToRecentlyPlayed(int songId) async {
  final recentlyPlayedBox = await Hive.openBox<RecentlyPlayed>('recents');
  List<RecentlyPlayed> songs = recentlyPlayedBox.values.toList();
  for (int i = 0; i < songs.length; i++) {
    if (songs[i].songIds == songId) {
      recentlyPlayedBox.delete(songs[i].key);
      break;
    }
  }
  recentlyPlayedBox.add(RecentlyPlayed(songIds: songId));
}

Future<List<MusicSong>> recentlyPlayedSongs() async {
  final recentlyPlayedBox = await Hive.openBox<RecentlyPlayed>('recents');
  List<RecentlyPlayed> songs = recentlyPlayedBox.values.toList();
  List<MusicSong> allSongs = await music();
  List<MusicSong> recents = [];
  for (int i = 0; i < songs.length; i++) {
    for (int j = 0; j < allSongs.length; j++) {
      if (songs[i].songIds == allSongs[j].songid) {
        recents.add(allSongs[j]);
      }
    }
  }

  return recents.reversed.toList();
}

mostPlayedUpdate({required List<SongModel> songs}) async {
  final songDb = await Hive.openBox<MostPlayed>("most_played");
  if (songDb.isEmpty) {
    debugPrint("most played empty");
    for (SongModel song in songs) {
      songDb.add(MostPlayed(songIds: song.id.toInt(), count: 0));
    }
  } else {
    debugPrint("most played not empty");
    for (SongModel song in songs) {
      if (!songDb.values.any((element) => element.songIds == song.id.toInt())) {
        songDb.add(MostPlayed(songIds: song.id.toInt(), count: 0));
      }
    }
  }
}

addSongToMostPlayed(int songId) async {
  final mostPlayed = await Hive.openBox<MostPlayed>('most_played');
  List<MostPlayed> songs = mostPlayed.values.toList();
  for (int i = 0; i < songs.length; i++) {
    if (songs[i].songIds == songId) {
      final plSong = mostPlayed.get(songs[i].key);
      plSong!.count++;
      mostPlayed.put(songs[i].key, plSong);
      debugPrint("addeddddd");
      break;
    }
  }
}

Future<List<MusicSong>> mostPlayedSongs() async {
  final mostPlayed = await Hive.openBox<MostPlayed>('most_played');
  List<MostPlayed> songs = mostPlayed.values.toList();
  List<MusicSong> allSongs = await music();
  List<MostPlayed> most = [];
  List<MusicSong> finalList = [];
  for (int i = 0; i < songs.length; i++) {
    if (songs[i].count > 0) {
      most.add(songs[i]);
    }
  }
  most.sort((a, b) => b.count.compareTo(a.count));
  List<MostPlayed> mostOrder = List.from(most);
  for (int i = 0; i < mostOrder.length; i++) {
    for (int j = 0; j < allSongs.length; j++) {
      if (mostOrder[i].songIds == allSongs[j].songid) {
        finalList.add(allSongs[j]);
      }
    }
  }
  print("naaa $finalList");
  return finalList;
}

addPlaylist({required String name, required List<int> songId}) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  playListDb.add(PlaylistDbModel(name: name, songIds: songId));

  debugPrint("nass${playListDb.length}");
}

Future<List<PlaylistDbModel>> getFromPlaylist() async {
  List<PlaylistDbModel> pldb = [];
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  pldb = playListDb.values.toList();
  return pldb;
}

deletePlayList(int index) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  if (index >= 0 && index < playListDb.length) {
    playListDb.deleteAt(index);
    debugPrint("Playlist deleted at index: $index");
    debugPrint("nass${playListDb.length}");
  } else {
    debugPrint("Invalid index for playlist deletion");
  }
}

renamePlaylist(
    {required PlaylistDbModel playlist, required String newName}) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');

  final storedPlaylist = playListDb.get(playlist.key);

  if (storedPlaylist != null) {
    storedPlaylist.name = newName;
    playListDb.put(playlist.key, storedPlaylist);
  }
}

addSongsToPlaylist(
    {required int songid, required PlaylistDbModel playlist}) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  final pl = playListDb.get(playlist.key);
  if (!pl!.songIds.contains(songid)) {
    pl.songIds.add(songid);
    playListDb.put(playlist.key, pl);
    debugPrint("$songid added");
  } else {
    debugPrint("song already present in playlist");
  }
}

List<int> songsinPlylist = [];

checkSongOnPlaylist({required PlaylistDbModel playlist}) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  final pl = playListDb.get(playlist.key);
  songsinPlylist = pl!.songIds;
}

List<String> playlistNames = [];

checkplaylistNames() async {
  playlistNames.clear();
  final playListBox = await Hive.openBox<PlaylistDbModel>('playlist_db');
  for (int i = 0; i < playListBox.length; i++) {
    final playlist = playListBox.getAt(i);
    if (playlist != null) {
      playlistNames.add(playlist.name);
      debugPrint("playlist name $i - ${playlist.name}");
    }
  }
  await playListBox.close();
}

removeSongsFromPlaylist(
    {required int songid, required PlaylistDbModel playlist}) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  final pl = playListDb.get(playlist.key);
  pl!.songIds.remove(songid);
  playListDb.put(playlist.key, pl);
  debugPrint("$songid removed");
}

Future<List<MusicSong>> playlistSongs(
    {required PlaylistDbModel playslist}) async {
  final playListDb = await Hive.openBox<PlaylistDbModel>('playlist_db');
  PlaylistDbModel? s = playListDb.get(playslist.key);
  List<int> plSongs = s!.songIds;
  List<MusicSong> allSongs = await music();
  List<MusicSong> result = [];
  for (int i = 0; i < allSongs.length; i++) {
    for (int j = 0; j < plSongs.length; j++) {
      if (allSongs[i].songid == plSongs[j]) {
        result.add(MusicSong(
          name: allSongs[i].name,
          songid: allSongs[i].songid,
          uri: allSongs[i].uri,
          artist: allSongs[i].artist,
          path: allSongs[i].path,
        ));
      }
    }
  }
  return result;
}
