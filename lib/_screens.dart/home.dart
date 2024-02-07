// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, unnecessary_new, annotate_overrides, use_key_in_widget_constructors, camel_case_types, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:Zylae/_screens.dart/favorites.dart';
import 'package:Zylae/_screens.dart/homescreen.dart';
import 'package:Zylae/_screens.dart/play_lists.dart';
import 'package:Zylae/_screens.dart/searchscreen.dart';
import 'package:Zylae/_screens.dart/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';

final AudioPlayer audioPlayer = AudioPlayer();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int current_index = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  // ignore: unused_field
  final _audioquery = new OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 8, 39),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 8, 39),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                settingshowBottomSheet(context: context);
              })
        ],
        title: Text(
          'Zylea',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.white,
          dividerHeight: 3,
          indicatorColor: const Color.fromARGB(255, 35, 12, 39),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 18),
          isScrollable: false,
          onTap: (value) {
            FocusScope.of(context).unfocus();
          },
          tabs: const [
            Tab(
              text: 'Home',
            ),
            Tab(text: 'Search'),
            Tab(text: 'Favourites'),
            Tab(text: 'Playlists'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const homescreen(),
          searchscreen(),
          const Favorites(),
          const playlists(),
        ],
      ),
    );
  }
}
