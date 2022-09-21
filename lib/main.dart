import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _localHeight = 400;
  List<String> defaultList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  late int totalItemShouldBeRender;
  late List<String> list = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    totalItemShouldBeRender = defaultList.length;
    list = [...defaultList];
    itemPositionsListener.itemPositions.addListener(() {
      var max = itemPositionsListener.itemPositions.value
          .toList()
          .where((ItemPosition position) => position.itemLeadingEdge < 1)
          .reduce((ItemPosition max, ItemPosition position) =>
              position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
          .index;

      if (max + 1 == list.length) return;

      setState(() {
        // list = defaultList.sublist(0, max + 1);
        totalItemShouldBeRender = max + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            height: _localHeight,
            child: ScrollablePositionedList.builder(
              addAutomaticKeepAlives: false,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: defaultList.length + 10,
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey('stick-${list.length}'),
                  height: 40,
                  child: Text('$index + ${list.length}'),
                );
              },
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
            ),
          ),

          GestureDetector(
            onVerticalDragUpdate: (detail) {
              setState(() {
                if (_localHeight + detail.delta.dy < 100 ||
                    _localHeight + detail.delta.dy > 400) return;

                _localHeight = _localHeight + detail.delta.dy;
              });
            },
            child: Container(
              height: 10,
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
          // Bar
        ],
      ),
    );
  }
}
