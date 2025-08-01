import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragAndDropItemTarget extends StatefulWidget {
  final Widget child;
  final DragAndDropListInterface? parent;
  final DragAndDropBuilderParameters parameters;
  final OnItemDropOnLastTarget onReorderOrAdd;

  const DragAndDropItemTarget(
      {required this.child,
      required this.onReorderOrAdd,
      required this.parameters,
      this.parent,
      super.key});

  @override
  State<StatefulWidget> createState() => _DragAndDropItemTarget();
}

class _DragAndDropItemTarget extends State<DragAndDropItemTarget>
    with TickerProviderStateMixin {
  DragAndDropItem? _hoveredDraggable;

  /// Get the effective animation duration for the hovered item.
  /// Returns the item's specific duration if set, otherwise the global default.
  Duration _getEffectiveAnimationDuration() {
    return _hoveredDraggable?.sizeAnimationDuration ??
        Duration(milliseconds: widget.parameters.itemSizeAnimationDuration);
  }

  /// Build an animated or static widget based on animation duration.
  /// If duration is zero, returns a static widget to avoid animation issues.
  Widget _buildAnimatedOrStaticSize({
    required Duration duration,
    required AlignmentGeometry alignment,
    required Widget child,
  }) {
    if (duration == Duration.zero) {
      return child;
    } else {
      return AnimatedSize(
        duration: duration,
        alignment: alignment,
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: widget.parameters.verticalAlignment,
          children: <Widget>[
            _buildAnimatedOrStaticSize(
              duration: _getEffectiveAnimationDuration(),
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.parameters.itemGhostOpacity,
                      child: widget.parameters.itemGhost ??
                          _hoveredDraggable!.child,
                    )
                  : Container(),
            ),
            widget.child,
          ],
        ),
        Positioned.fill(
          child: DragTarget<DragAndDropItem>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAcceptWithDetails: (details) {
              bool accept = true;
              if (widget.parameters.itemTargetOnWillAccept != null) {
                accept = widget.parameters.itemTargetOnWillAccept!(
                    details.data, widget);
              }
              if (accept && mounted) {
                setState(() {
                  _hoveredDraggable = details.data;
                });
              }
              return accept;
            },
            onLeave: (data) {
              if (mounted) {
                setState(() {
                  _hoveredDraggable = null;
                });
              }
            },
            onAcceptWithDetails: (details) {
              if (mounted) {
                setState(() {
                  widget.onReorderOrAdd(details.data, widget.parent!, widget);
                  _hoveredDraggable = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
