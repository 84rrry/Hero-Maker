import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habbits_tracker/Model/habbit.dart';
import 'package:habbits_tracker/Services/NotificationServices.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:percent_indicator/percent_indicator.dart';

// import '../Services/NotificationServices.dart';

class HabbitTile extends StatefulWidget {
  final Habbit habbit;

  final PaletteColor? tileColor;

  HabbitTile({
    Key? key,
    required this.habbit,
    required this.tileColor,
  }) : super(key: key);

  @override
  State<HabbitTile> createState() => _HabbitTileState();
}

class _HabbitTileState extends State<HabbitTile> {
  TextEditingController habbitNameController = TextEditingController();
  TextEditingController timeGoalController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void saveHabbit(Habbit habbit) {
    debugPrint('Save habbit called');
    habbit.save();
  }

  void resetHabbit(Habbit habbit) {
    habbit.timespent = 0;
    habbit.habbitStarted = false;
    habbit.habbitCompleted = false;
    habbit.save();
  }

  void doneHabbit(Habbit habbit) {
    debugPrint("done habit called");
    debugPrint(habbit.habbitCompleted.toString());
    habbit.habbitStarted = false;
    habbit.habbitCompleted = true;
    habbit.save();
    debugPrint(habbit.habbitCompleted.toString());
  }

  void editHabbit(
    Habbit habbit,
    String name,
    int goalTime,
  ) {
    habbit.habbitName = name;
    habbit.timeGoal = goalTime;
    habbit.timespent = habbit.timespent;
    habbit.habbitStarted = false;
    habbit.save();
  }

  void deleteHabbit(Habbit habbit) {
    habbit.delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String convSecToMin(int totalSec) {
    String sec = (totalSec % 60).toString();
    String min = (totalSec / 60).toStringAsFixed(5);
    if (sec.length == 1) sec = '0' + sec;
    if (min[1] == '.') min = min.substring(0, 1);
    return min + ':' + sec;
  }

  Color progressColor() {
    if (widget.habbit.timespent / (widget.habbit.timeGoal * 60) < 0.4)
      return Colors.red;
    if (widget.habbit.timespent / (widget.habbit.timeGoal * 60) >= 0.35 &&
        widget.habbit.timespent / (widget.habbit.timeGoal * 60) < 0.6)
      return Colors.orange;
    if (widget.habbit.timespent / (widget.habbit.timeGoal * 60) >= 0.6 &&
        widget.habbit.timespent / (widget.habbit.timeGoal * 60) < 0.85)
      return Colors.yellow;
    if (widget.habbit.timespent / (widget.habbit.timeGoal * 60) == 1) {
      // ensure this is the first time the habbit is being completed
      if (!widget.habbit.habbitCompleted) {
        // createHabbitCompletedNotification(widget.habbit);
        doneHabbit(widget.habbit);
        createHabbitCompletedNotification(widget.habbit);
      }
      ;
      return Colors.green;
    } else
      return Colors.green;
  }

  Widget build(BuildContext context) {
    final WIDTH = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Slidable(
          key: widget.key,
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                onPressed: (context) => showDialog(
                    context: context,
                    builder: (context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: AlertDialog(
                          backgroundColor:
                              widget.tileColor!.color.withOpacity(0.8),
                          title: Text(
                            'Are You sure you want to delete ' +
                                widget.habbit.habbitName +
                                '?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 20,
                                    color: widget.tileColor!.bodyTextColor),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                deleteHabbit(widget.habbit);
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                  msg:
                                      '  ${widget.habbit.habbitName} has been Deleted', // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.BOTTOM, // location
                                  timeInSecForIosWeb: 1,
                                );
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: widget.tileColor!.bodyTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                    color: widget.tileColor!.titleTextColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                onPressed: (context) {
                  habbitNameController.value = TextEditingValue(
                    text: widget.habbit.habbitName,
                  );
                  timeGoalController.value = TextEditingValue(
                    text: widget.habbit.timeGoal.toString(),
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: SingleChildScrollView(
                          child: AlertDialog(
                            backgroundColor: widget.tileColor!.color,
                            title: Text(
                              'Edit ${widget.habbit.habbitName}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 20,
                                      color: widget.tileColor!.bodyTextColor),
                            ),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                        color: widget.tileColor!.bodyTextColor),
                                    cursorWidth: 1,
                                    cursorColor:
                                        widget.tileColor!.bodyTextColor,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field can\'t be empty';
                                      }
                                      return null;
                                    },
                                    controller: habbitNameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          color:
                                              widget.tileColor!.titleTextColor),
                                      prefixIcon: Icon(
                                        Icons.diamond_outlined,
                                        color: widget.tileColor!.bodyTextColor,
                                      ),
                                      labelText: 'Habbit',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color:
                                              widget.tileColor!.bodyTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                        color: widget.tileColor!.bodyTextColor),
                                    cursorWidth: 1,
                                    cursorColor:
                                        widget.tileColor!.bodyTextColor,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field can\'t be empty';
                                      }
                                      return null;
                                    },
                                    controller: timeGoalController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          color:
                                              widget.tileColor!.titleTextColor),
                                      prefixIcon: Icon(
                                        Icons.timer_outlined,
                                        color: widget.tileColor!.bodyTextColor,
                                      ),
                                      labelText: 'Time Goal',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color:
                                              widget.tileColor!.bodyTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Saving Changes!')),
                                    );
                                    editHabbit(
                                        widget.habbit,
                                        habbitNameController.text,
                                        int.parse(timeGoalController.text));
                                    habbitNameController.clear();
                                    timeGoalController.clear();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: widget.tileColor!.bodyTextColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  habbitNameController.clear();
                                  timeGoalController.clear();
                                  Navigator.pop(context);
                                },
                                child: Text('Close',
                                    style: TextStyle(
                                      color: widget.tileColor!.titleTextColor,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                backgroundColor: Colors.blue.shade400,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            key: ValueKey('Container'),
            decoration: BoxDecoration(
              color: !widget.habbit.habbitCompleted
                  ? widget.tileColor!.color.withOpacity(0.5)
                  : Colors.green.withOpacity(0.7),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: ListTile(
                key: widget.key,
                onTap: () {
        if(!widget.habbit.habbitCompleted) {         DateTime startTime = DateTime.now();
                  int elapsedTime = widget.habbit.timespent;
                  setState(() {
                    widget.habbit.habbitStarted = !widget.habbit.habbitStarted;
                  });
                  widget.habbit.habbitStarted
                      ? (widget.habbit.timespent == 0
                          ? Fluttertoast.showToast(
                              msg:
                                  '${widget.habbit.habbitName} has been Started', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              timeInSecForIosWeb: 1,
                            )
                          : Fluttertoast.showToast(
                              msg:
                                  '${widget.habbit.habbitName} has been resumed', // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.BOTTOM, // location
                              timeInSecForIosWeb: 1,
                            ))
                      : Fluttertoast.showToast(
                          msg:
                              ' ${widget.habbit.habbitName} has been Stoped', // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.BOTTOM, // location
                          timeInSecForIosWeb: 1,
                        );
                  if (widget.habbit.habbitStarted) {
          
                    Timer.periodic(const Duration(seconds: 0), (timer) {
                      setState(() {
                        if (!widget.habbit.habbitStarted ||
                            (widget.habbit.timespent /
                                    (widget.habbit.timeGoal * 60)) ==
                                1) {
                          timer.cancel();
                          widget.habbit.habbitStarted = false;
                       
                        }

                        var currenTime = DateTime.now();

                        widget.habbit.timespent = elapsedTime +
                            currenTime.second -
                            startTime.second +
                            60 * (currenTime.minute - startTime.minute) +
                            3600 * (currenTime.hour - startTime.hour);
                      });
                    });
                  }
                };},
                title: Text(
                  widget.habbit.habbitName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: WIDTH * 0.045),
                ),
                subtitle: Text(
                  "${convSecToMin(widget.habbit.timespent)}/${widget.habbit.timeGoal}= ${((widget.habbit.timespent / (widget.habbit.timeGoal * 60)) * 100).toInt()}%",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: WIDTH * 0.045, color: Colors.white70),
                ),
                leading: SizedBox(
                  height: WIDTH * 0.16,
                  width: WIDTH * 0.16,
                  child: Stack(alignment: Alignment.center, children: [
                    CircularPercentIndicator(
                      radius: (WIDTH * 0.06).toDouble(),
                      lineWidth: 4.0,
                      percent: widget.habbit.timespent /
                                  (widget.habbit.timeGoal * 60) <
                              1
                          ? widget.habbit.timespent /
                              (widget.habbit.timeGoal * 60)
                          : 1,
                      progressColor: progressColor(),
                    ),
                    Icon(
                      color: Colors.white,
                      widget.habbit.habbitStarted
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: (WIDTH * 0.055).toDouble(),
                    ),
                  ]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
           
                    Visibility(
                      // ignore: sort_child_properties_last
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: widget.tileColor!.color,
                                title: Text(
                                  'Are you sure you want to reset this habbit?',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 20,
                                        color: widget.tileColor!.bodyTextColor,
                                      ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        resetHabbit(
                                          widget.habbit,
                                        );
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                          msg:
                                              ' The progress for ${widget.habbit.habbitName} has been restored', // message
                                          toastLength:
                                              Toast.LENGTH_SHORT, // length
                                          gravity:
                                              ToastGravity.BOTTOM, // location
                                          timeInSecForIosWeb: 1,
                                        );
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color:
                                              widget.tileColor!.bodyTextColor,
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: widget
                                                .tileColor!.titleTextColor),
                                      )),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.restore),
                        color: Colors.white,
                      ),
                      visible: (widget.habbit.timespent /
                              (widget.habbit.timeGoal * 60)) !=
                          0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
