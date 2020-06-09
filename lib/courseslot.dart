import 'package:Sapptest/course.dart';
import 'package:Sapptest/coursepage.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';

import 'mainPage.dart';

class CourseSlot extends StatelessWidget {
  final Course course;
  final Function function;
  final int index;
  CourseSlot({Key key, this.course, this.index, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListTile(
        onTap: () async {
          Navigator.push(
              context,
              PageTransition(
                  alignment: Alignment.center,
                  type: PageTransitionType.upToDown,
                  curve: Curves.easeOut,
                  duration: Duration(milliseconds: 200),
                  child: CoursePage(
                    course: course,
                    index: index,
                  ))).then((value) {
            function();
          });
        },
        contentPadding: EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        title: Center(
            child: Text(
          course.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        )),
        subtitle: course.courseCode.isNotEmpty
            ? Column(
                children: [
                  Center(
                      child: Text(
                    course.courseCode,
                    textAlign: TextAlign.center,
                  )),
                ],
              )
            : Container(
                height: 0,
                width: 0,
              ),
      ),
    );
  }
}

class CourseList extends StatefulWidget {
  final int day;
  final Function function;
  const CourseList({
    Key key,
    this.day,
    this.function,
  }) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  ScrollController _controller;
  int totalHours = 0;

  @override
  void initState() {
    periods.forEach((element) {
      totalHours += element.getPeriodLength;
    });

    _controller = ScrollController()
      ..addListener(() {
        upDirection =
            _controller.position.userScrollDirection == ScrollDirection.forward;

        // makes sure we don't call setState too much, but only when it is needed
        if (upDirection != flag) {
          flag = upDirection;
          scrollCheck.value = upDirection;
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ListView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        return index == 0
            ? Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Courses",
                    style: TextStyle(
                      fontSize: width / 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Number Of Courses: " + courses.length.toString(),
                      style: TextStyle(
                        fontSize: width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Length Of All Classes: " +
                          (totalHours / 60).toStringAsFixed(0) +
                          ":" +
                          (totalHours % 60).toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 3,
                ),
              ])
            : courses.isEmpty
                ? EmptyMessage()
                : Hero(
                    tag: "coursetile$index",
                    child: Material(
                      type: MaterialType.transparency,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Material(
                            child: CourseSlot(
                              function: widget.function,
                              course: courses[index - 1],
                              index: index,
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: width / 20,
                            endIndent: width / 20,
                          )
                        ]),
                      ),
                    ),
                  );
      },
      itemCount: courses.isEmpty ? 2 : courses.length + 1,
    );
  }
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Seems Empty, Try Adding Some Periods!',
        ),
      ),
    );
  }
}
