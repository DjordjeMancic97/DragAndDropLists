import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:example/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

class AnimationDurationExample extends StatefulWidget {
  const AnimationDurationExample({Key? key}) : super(key: key);

  @override
  State createState() => _AnimationDurationExample();
}

class _AnimationDurationExample extends State<AnimationDurationExample> {
  late List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();

    _contents = [
      // List with fast animation (100ms)
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Fast Animation List (100ms)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        sizeAnimationDuration: const Duration(milliseconds: 100),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: const ListTile(
              title: Text('Fast Item 1'),
              subtitle: Text('Animation: 50ms'),
            ),
            sizeAnimationDuration: const Duration(milliseconds: 50),
          ),
          DragAndDropItem(
            child: const ListTile(
              title: Text('Fast Item 2'),
              subtitle: Text('Animation: 50ms'),
            ),
            sizeAnimationDuration: const Duration(milliseconds: 50),
          ),
          DragAndDropItem(
            child: const ListTile(
              title: Text('Normal Item'),
              subtitle: Text('Uses global default'),
            ),
            // No sizeAnimationDuration set - uses global default
          ),
        ],
      ),

      // List with slow animation (500ms)
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Slow Animation List (500ms)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        sizeAnimationDuration: const Duration(milliseconds: 500),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: const ListTile(
              title: Text('Slow Item 1'),
              subtitle: Text('Animation: 800ms'),
            ),
            sizeAnimationDuration: const Duration(milliseconds: 800),
          ),
          DragAndDropItem(
            child: const ListTile(
              title: Text('Slow Item 2'),
              subtitle: Text('Animation: 800ms'),
            ),
            sizeAnimationDuration: const Duration(milliseconds: 800),
          ),
        ],
      ),

      // List with no animation
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'No Animation List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        sizeAnimationDuration: Duration.zero,
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: const ListTile(
              title: Text('No Animation Item 1'),
              subtitle: Text('Animation: disabled'),
            ),
            sizeAnimationDuration: Duration.zero,
          ),
          DragAndDropItem(
            child: const ListTile(
              title: Text('No Animation Item 2'),
              subtitle: Text('Animation: disabled'),
            ),
            sizeAnimationDuration: Duration.zero,
          ),
        ],
      ),

      // List with default animation (uses global settings)
      DragAndDropList(
        header: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Default Animation List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // No sizeAnimationDuration set - uses global default
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: const ListTile(
              title: Text('Default Item 1'),
              subtitle: Text('Uses global default'),
            ),
            // No sizeAnimationDuration set - uses global default
          ),
          DragAndDropItem(
            child: const ListTile(
              title: Text('Default Item 2'),
              subtitle: Text('Uses global default'),
            ),
            // No sizeAnimationDuration set - uses global default
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color.fromARGB(255, 243, 242, 248);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Duration Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const CustomNavigationDrawer(),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'This example demonstrates individual animation durations per list and item.\n'
              'Try dragging items between lists to see different animation speeds!',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: DragAndDropLists(
              children: _contents,
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              listPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemDivider: const Divider(
                thickness: 1,
                height: 1,
                color: backgroundColor,
              ),
              itemDecorationWhileDragging: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              listInnerDecoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              lastItemTargetHeight: 8,
              addLastItemTargetHeightToTop: true,
              lastListTargetSize: 40,
              // Global defaults for animation durations
              itemSizeAnimationDurationMilliseconds: 150,
              listSizeAnimationDurationMilliseconds: 150,
            ),
          ),
        ],
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}
