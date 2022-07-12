import 'package:hive/hive.dart';
part 'habbit.g.dart';
@HiveType(typeId: 0) 
class Habbit extends HiveObject{

  @HiveField(0)
  String habbitName;

  @HiveField(1)
  int timeGoal;

  @HiveField(2)
  int timespent;

  @HiveField(3)
  bool habbitStarted;

  @HiveField(4)
  bool habbitCompleted;


  Habbit(this.habbitName, this.timeGoal,{this.timespent=0,this.habbitStarted=false,this.habbitCompleted=false,});


}