import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:Zylae/Db/model/db_favmodel.dart';
import 'package:Zylae/Db/model/db_model.dart';
import 'package:Zylae/Db/model/most_played_db_model.dart';
import 'package:Zylae/Db/model/playlist_model.dart';
import 'package:Zylae/Db/model/recently_played_db_model.dart';
import 'package:Zylae/provider/song_model_provider.dart';
import 'package:provider/provider.dart';
import '_screens.dart/splash_screen.dart';
import '_screens.dart/home.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(MusicSongAdapter().typeId)) {
    Hive.registerAdapter(MusicSongAdapter());
  }

  Hive.registerAdapter(FavmodelAdapter());
  if (!Hive.isAdapterRegistered(RecentlyPlayedAdapter().typeId)) {
    Hive.registerAdapter(RecentlyPlayedAdapter());
  }

  if (!Hive.isAdapterRegistered(MostPlayedAdapter().typeId)) {
    Hive.registerAdapter(MostPlayedAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistDbModelAdapter().typeId)) {
    Hive.registerAdapter(PlaylistDbModelAdapter());
  }
  runApp(ChangeNotifierProvider(
    create: (contex) => SongModelProvider(),
    child: MyApp(),
  ));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zylae',
      theme: ThemeData(primaryColor: Colors.white),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => MyHomePage(),
      },
    );
  }
}
