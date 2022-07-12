import 'package:hive/hive.dart';
import 'package:habbits_tracker/Model/habbit.dart';
class Boxes{
  static Box<Habbit> getHabbits()=>
  Hive.box<Habbit>('Habbits');
}