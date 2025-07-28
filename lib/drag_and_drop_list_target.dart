import 'package:drag_and_drop_lists/drag_and_drop_builder_parameters.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnDropOnLastTarget = void Function(
  DragAndDropListInterface newOrReordered,
  DragAndDropListTarget receiver,
);

class DragAndDropListTarget extends StatefulWidget {
  final Widget? child;
  final DragAndDropBuilderParameters parameters;
  final OnDropOnLastTarget onDropOnLastTarget;
  final double lastListTargetSize;

  const DragAndDropListTarget(
      {this.child,
      required this.parameters,
      required this.onDropOnLastTarget,
      this.lastListTargetSize = 110,
      super.key});

  @override
  State<StatefulWidget> createState() => _DragAndDropListTarget();
}

class _DragAndDropListTarget extends State<DragAndDropListTarget>
    with TickerProviderStateMixin {
  DragAndDropListInterface? _hoveredDraggable;

  /// Get the effective animation duration for the hovered list.
  /// Returns the list's specific duration if set, otherwise the global default.
  Duration _getEffectiveAnimationDuration() {
    return _hoveredDraggable?.sizeAnimationDuration ??
        Duration(milliseconds: widget.parameters.listSizeAnimationDuration);
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
    Widget visibleContents = Column(
      children: <Widget>[
        _buildAnimatedOrStaticSize(
          duration: _getEffectiveAnimationDuration(),
          alignment: widget.parameters.axis == Axis.vertical
              ? Alignment.bottomCenter
              : Alignment.centerLeft,
          child: _hoveredDraggable != null
              ? Opacity(
                  opacity: widget.parameters.listGhostOpacity,
                  child: widget.parameters.listGhost ??
                      _hoveredDraggable!.generateWidget(widget.parameters),
                )
              : Container(),
        ),
        widget.child ??
            SizedBox(
              height: widget.parameters.axis == Axis.vertical
                  ? widget.lastListTargetSize
                  : null,
              width: widget.parameters.axis == Axis.horizontal
                  ? widget.lastListTargetSize
                  : null,
            ),
      ],
    );

    if (widget.parameters.listPadding != null) {
      visibleContents = Padding(
        padding: widget.parameters.listPadding!,
        child: visibleContents,
      );
    }

    if (widget.parameters.axis == Axis.horizontal) {
      visibleContents = SingleChildScrollView(child: visibleContents);
    }

    return Stack(
      children: <Widget>[
        visibleContents,
        Positioned.fill(
          child: DragTarget<DragAndDropListInterface>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAcceptWithDetails: (details) {
              bool accept = true;
              if (widget.parameters.listTargetOnWillAccept != null) {
                accept = widget.parameters.listTargetOnWillAccept!(
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
                  widget.onDropOnLastTarget(details.data, widget);
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
