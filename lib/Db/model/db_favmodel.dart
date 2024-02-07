import 'package:hive/hive.dart';
part 'db_favmodel.g.dart';


@HiveType(typeId: 2)
class Favmodel extends HiveObject{
 
  @HiveField(0)
  int songIds;
  Favmodel({ required this.songIds});

} 