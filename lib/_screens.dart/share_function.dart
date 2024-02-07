import 'package:share/share.dart';
import 'package:Zylae/Db/model/db_model.dart';

void sharemusic(MusicSong sh) async {
  final vh = sh;
  await Share.shareFiles([vh.path]);
}
