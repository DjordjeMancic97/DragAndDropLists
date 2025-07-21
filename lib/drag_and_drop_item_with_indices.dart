import 'package:drag_and_drop_lists/drag_and_drop_item.dart';

/// A wrapper class that contains a DragAndDropItem along with its position information
class DragAndDropItemWithIndices {
  final DragAndDropItem item;
  final int itemIndex;
  final int listIndex;

  const DragAndDropItemWithIndices({
    required this.item,
    required this.itemIndex,
    required this.listIndex,
  });
}
