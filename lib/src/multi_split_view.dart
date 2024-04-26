import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_split_view/src/area.dart';
import 'package:multi_split_view/src/controller.dart';
import 'package:multi_split_view/src/divider_tap_typedefs.dart';
import 'package:multi_split_view/src/divider_widget.dart';
import 'package:multi_split_view/src/internal/divider_util.dart';
import 'package:multi_split_view/src/internal/layout_constraints.dart';
import 'package:multi_split_view/src/internal/layout_delegate.dart';
import 'package:multi_split_view/src/policies.dart';
import 'package:multi_split_view/src/theme_data.dart';
import 'package:multi_split_view/src/theme_widget.dart';
import 'package:multi_split_view/src/typedefs.dart';

/// A widget to provides horizontal or vertical multiple split view.
class MultiSplitView extends StatefulWidget {
  static const Axis defaultAxis = Axis.horizontal;

  /// Creates an [MultiSplitView].
  ///
  /// The default value for [axis] argument is [Axis.horizontal].
  /// The [children] argument is required.
  const MultiSplitView(
      {Key? key,
      Axis axis = MultiSplitView.defaultAxis,
      required List<Widget> children,
      MultiSplitViewController? controller,
      DividerBuilder? dividerBuilder,
      OnDividerDragUpdate? onDividerDragUpdate,
      DividerTapCallback? onDividerTap,
      DividerTapCallback? onDividerDoubleTap,
      bool resizable = true,
      bool antiAliasingWorkaround = false,
      bool pushDividers = false,
      List<Area>? initialAreas,
      SizeOverflowPolicy sizeOverflowPolicy = SizeOverflowPolicy.shrinkLast,
      SizeUnderflowPolicy sizeUnderflowPolicy = SizeUnderflowPolicy.stretchLast,
      double fallbackWidth = 500,
      double fallbackHeight = 500})
      : this._(
            key: key,
            axis: axis,
            children: children,
            controller: controller,
            dividerBuilder: dividerBuilder,
            onDividerDragUpdate: onDividerDragUpdate,
            onDividerTap: onDividerTap,
            onDividerDoubleTap: onDividerDoubleTap,
            resizable: resizable,
            antiAliasingWorkaround: antiAliasingWorkaround,
            count: null,
            widgetBuilder: null,
            pushDividers: pushDividers,
            initialAreas: initialAreas,
            sizeOverflowPolicy: sizeOverflowPolicy,
            sizeUnderflowPolicy: sizeUnderflowPolicy,
            fallbackWidth: fallbackWidth,
            fallbackHeight: fallbackHeight);

  /// Creates an [MultiSplitView].
  ///
  /// The default value for [axis] argument is [Axis.horizontal].
  const MultiSplitView.builder(
      {Key? key,
      Axis axis = MultiSplitView.defaultAxis,
      MultiSplitViewController? controller,
      required int count,
      required AreaWidgetBuilder widgetBuilder,
      DividerBuilder? dividerBuilder,
      OnDividerDragUpdate? onDividerDragUpdate,
      DividerTapCallback? onDividerTap,
      DividerTapCallback? onDividerDoubleTap,
      bool resizable = true,
      bool antiAliasingWorkaround = false,
      bool pushDividers = false,
      List<Area>? initialAreas,
      SizeOverflowPolicy sizeOverflowPolicy = SizeOverflowPolicy.shrinkLast,
      SizeUnderflowPolicy sizeUnderflowPolicy = SizeUnderflowPolicy.stretchLast,
      double fallbackWidth = 500,
      double fallbackHeight = 500})
      : this._(
            key: key,
            axis: axis,
            children: null,
            controller: controller,
            dividerBuilder: dividerBuilder,
            onDividerDragUpdate: onDividerDragUpdate,
            onDividerTap: onDividerTap,
            onDividerDoubleTap: onDividerDoubleTap,
            resizable: resizable,
            antiAliasingWorkaround: antiAliasingWorkaround,
            count: count,
            widgetBuilder: widgetBuilder,
            initialAreas: initialAreas,
            pushDividers: pushDividers,
            sizeOverflowPolicy: sizeOverflowPolicy,
            sizeUnderflowPolicy: sizeUnderflowPolicy,
            fallbackWidth: fallbackWidth,
            fallbackHeight: fallbackHeight);

  const MultiSplitView._(
      {Key? key,
      required this.axis,
      required this.children,
      required this.controller,
      required this.dividerBuilder,
      required this.onDividerDragUpdate,
      required this.onDividerTap,
      required this.onDividerDoubleTap,
      required this.resizable,
      required this.antiAliasingWorkaround,
      required this.count,
      required this.widgetBuilder,
      required this.initialAreas,
      required this.pushDividers,
      required this.sizeOverflowPolicy,
      required this.sizeUnderflowPolicy,
      required this.fallbackWidth,
      required this.fallbackHeight})
      : super(key: key);

  final Axis axis;
  final List<Widget>? children;
  final MultiSplitViewController? controller;
  final List<Area>? initialAreas;

  /// Indicates whether a divider can push others.
  final bool pushDividers;

  /// Signature for when a divider tap has occurred.
  final DividerTapCallback? onDividerTap;

  /// Signature for when a divider double tap has occurred.
  final DividerTapCallback? onDividerDoubleTap;

  /// Defines a builder of dividers. Overrides the default divider
  /// created by the theme.
  final DividerBuilder? dividerBuilder;

  /// Indicates whether it is resizable. The default value is [TRUE].
  final bool resizable;

  /// Function to listen divider dragging.
  final OnDividerDragUpdate? onDividerDragUpdate;

  final int? count;

  final AreaWidgetBuilder? widgetBuilder;

  /// Represents the policy for handling overflow of non-flexible areas within
  /// a container.
  final SizeOverflowPolicy sizeOverflowPolicy;

  /// Represents the policy for handling cases where the total size of
  /// non-flexible areas within a container is smaller than the available space.
  final SizeUnderflowPolicy sizeUnderflowPolicy;

  /// Enables a workaround for https://github.com/flutter/flutter/issues/14288
  /// The workaround to minimize the problem is to round the coordinates to
  /// integer values. As a side effect, some areas may stretch or shrink
  /// slightly as the divider is dragged.
  final bool antiAliasingWorkaround;

  /// The width to use when it is in a situation with an unbounded width.
  ///
  /// See also:
  ///
  ///  * [fallbackHeight], the same but vertically.
  final double fallbackWidth;

  /// The height to use when it is in a situation with an unbounded height.
  ///
  /// See also:
  ///
  ///  * [fallbackWidth], the same but horizontally.
  final double fallbackHeight;

  int get _childrenCount {
    if (children != null) {
      return children!.length;
    }
    return count ?? 0;
  }

  @override
  State createState() => _MultiSplitViewState();
}

/// State for [MultiSplitView]
class _MultiSplitViewState extends State<MultiSplitView> {
  late MultiSplitViewController _controller;

  double _initialDragPos = 0;

  int? _draggingDividerIndex;
  int? _hoverDividerIndex;

  Object? _lastAreasUpdateHash;

  LayoutConstraints _layoutConstraints = LayoutConstraints(
      childrenCount: 0, containerSize: 0, dividerThickness: 0);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller != null
        ? widget.controller!
        : MultiSplitViewController(areas: widget.initialAreas);
    _stateHashCodeValidation();
    ControllerHelper.setStateHashCode(_controller, hashCode);
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void deactivate() {
    ControllerHelper.setStateHashCode(_controller, null);
    super.deactivate();
  }

  @override
  void didUpdateWidget(MultiSplitView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != _controller) {
      List<Area> areas = _controller.areas;
      ControllerHelper.setStateHashCode(_controller, null);
      _controller.removeListener(_rebuild);

      _controller = widget.controller != null
          ? widget.controller!
          : MultiSplitViewController(areas: areas);
      _stateHashCodeValidation();
      ControllerHelper.setStateHashCode(_controller, hashCode);
      _controller.addListener(_rebuild);
    }
  }

  /// Checks a controller's [_stateHashCode] to identify if it is
  /// not being shared by another instance of [MultiSplitView].
  void _stateHashCodeValidation() {
    if (ControllerHelper.getStateHashCode(_controller) != null &&
        ControllerHelper.getStateHashCode(_controller) != hashCode) {
      throw StateError(
          'It is not allowed to share MultiSplitViewController between MultiSplitView instances.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._childrenCount > 0) {
      MultiSplitViewThemeData themeData = MultiSplitViewTheme.of(context);

      return LayoutBuilder(builder: (context, constraints) {
        ControllerHelper controllerHelper = ControllerHelper(_controller);

        final double containerSize = widget.axis == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;

        if (_lastAreasUpdateHash != controllerHelper.areasUpdateHash ||
            _layoutConstraints.containerSize != containerSize ||
            _layoutConstraints.childrenCount != widget._childrenCount ||
            _layoutConstraints.dividerThickness != themeData.dividerThickness) {
          _draggingDividerIndex = null;
          _lastAreasUpdateHash = controllerHelper.areasUpdateHash;

          _layoutConstraints = LayoutConstraints(
              childrenCount: widget._childrenCount,
              containerSize: containerSize,
              dividerThickness: themeData.dividerThickness);
          _layoutConstraints.adjustAreas(
              controllerHelper: controllerHelper,
              sizeOverflowPolicy: widget.sizeOverflowPolicy,
              sizeUnderflowPolicy: widget.sizeUnderflowPolicy);
        }

        List<Widget> children = [];

        for (int index = 0; index < _controller.areasCount; index++) {
          // area widget
          Widget child = widget.children != null
              ? widget.children![index]
              : widget.widgetBuilder!(context, index, _controller.areas[index]);

          child = IgnorePointer(
              child: child, ignoring: _draggingDividerIndex != null);

          MouseCursor cursor = MouseCursor.defer;
          if (_draggingDividerIndex != null) {
            cursor = widget.axis == Axis.horizontal
                ? SystemMouseCursors.resizeColumn
                : SystemMouseCursors.resizeRow;
          }
          child = MouseRegion(cursor: cursor, child: child);
          children.add(LayoutId(id: index, child: ClipRect(child: child)));

          //divisor widget
          if (index < _controller.areasCount - 1) {
            bool highlighted = (_draggingDividerIndex == index ||
                (_draggingDividerIndex == null && _hoverDividerIndex == index));
            Widget dividerWidget = widget.dividerBuilder != null
                ? widget.dividerBuilder!(
                    widget.axis == Axis.horizontal
                        ? Axis.vertical
                        : Axis.horizontal,
                    index,
                    widget.resizable,
                    _draggingDividerIndex == index,
                    highlighted,
                    themeData)
                : DividerWidget(
                    axis: widget.axis == Axis.horizontal
                        ? Axis.vertical
                        : Axis.horizontal,
                    index: index,
                    themeData: themeData,
                    highlighted: highlighted,
                    resizable: widget.resizable,
                    dragging: _draggingDividerIndex == index);
            if (widget.resizable) {
              dividerWidget = GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _onDividerTap(index),
                  onDoubleTap: () => _onDividerDoubleTap(index),
                  onHorizontalDragDown: widget.axis == Axis.vertical
                      ? null
                      : (detail) => _onDragDown(detail, index),
                  onHorizontalDragCancel: widget.axis == Axis.vertical
                      ? null
                      : () => _onDragCancel(),
                  onHorizontalDragEnd: widget.axis == Axis.vertical
                      ? null
                      : (detail) => _onDragEnd(),
                  onHorizontalDragUpdate: widget.axis == Axis.vertical
                      ? null
                      : (detail) =>
                          _onDragUpdate(detail, index, controllerHelper),
                  onVerticalDragDown: widget.axis == Axis.horizontal
                      ? null
                      : (detail) => _onDragDown(detail, index),
                  onVerticalDragCancel: widget.axis == Axis.horizontal
                      ? null
                      : () => _onDragCancel(),
                  onVerticalDragEnd: widget.axis == Axis.horizontal
                      ? null
                      : (detail) => _onDragEnd(),
                  onVerticalDragUpdate: widget.axis == Axis.horizontal
                      ? null
                      : (detail) =>
                          _onDragUpdate(detail, index, controllerHelper),
                  child: dividerWidget);
              dividerWidget = _mouseRegion(
                  index: index,
                  axis: widget.axis == Axis.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
                  dividerWidget: dividerWidget,
                  themeData: themeData);
            }
            children.add(LayoutId(id: 'd$index', child: dividerWidget));
          }
        }
        return LimitedBox(
            maxWidth: widget.fallbackWidth,
            maxHeight: widget.fallbackHeight,
            child: CustomMultiChildLayout(
                children: children,
                delegate: LayoutDelegate(
                    controller: _controller,
                    axis: widget.axis,
                    layoutConstraints: _layoutConstraints,
                    antiAliasingWorkaround: widget.antiAliasingWorkaround)));
      });
    }
    return Container();
  }

  /// Updates the hover divider index.
  void _updatesHoverDividerIndex(
      {int? index, required MultiSplitViewThemeData themeData}) {
    if (_hoverDividerIndex != index &&
        (themeData.dividerPainter != null || widget.dividerBuilder != null)) {
      setState(() {
        _hoverDividerIndex = index;
      });
    }
  }

  void _onDividerTap(int index) {
    if (widget.onDividerTap != null) {
      widget.onDividerTap!(index);
    }
  }

  void _onDividerDoubleTap(int index) {
    if (widget.onDividerDoubleTap != null) {
      widget.onDividerDoubleTap!(index);
    }
  }

  void _onDragDown(DragDownDetails detail, int index) {
    setState(() {
      _draggingDividerIndex = index;
    });
    final Offset offset = _offset(context, detail.globalPosition);
    final double position =
        widget.axis == Axis.horizontal ? offset.dx : offset.dy;
    _initialDragPos = position;
  }

  void _onDragUpdate(
      DragUpdateDetails detail, int index, ControllerHelper controllerHelper) {
    if (_draggingDividerIndex == null) {
      return;
    }
    final Offset offset = _offset(context, detail.globalPosition);
    final double position =
        widget.axis == Axis.horizontal ? offset.dx : offset.dy;
    final double delta = position - _initialDragPos;

    if (delta == 0) {
      return;
    }

    double rest = DividerUtil.move(
        controller: _controller,
        layoutConstraints: _layoutConstraints,
        dividerIndex: index,
        pixels: delta,
        pushDividers: widget.pushDividers);

    if (rest == 0) {
      _initialDragPos = position;
    } else if (delta < 0) {
      _initialDragPos = DividerUtil.position(
              controller: _controller,
              layoutConstraints: _layoutConstraints,
              dividerIndex: index,
              antiAliasingWorkaround: widget.antiAliasingWorkaround) +
          _layoutConstraints.dividerThickness;
    } else if (delta > 0) {
      _initialDragPos = DividerUtil.position(
          controller: _controller,
          layoutConstraints: _layoutConstraints,
          dividerIndex: index,
          antiAliasingWorkaround: widget.antiAliasingWorkaround);
    }

    controllerHelper.notifyListeners();
    if (widget.onDividerDragUpdate != null) {
      Future.delayed(Duration.zero, () => widget.onDividerDragUpdate!(index));
    }
  }

  void _onDragCancel() {
    if (_draggingDividerIndex == null) {
      return;
    }
    setState(() {
      _draggingDividerIndex = null;
    });
  }

  void _onDragEnd() {
    if (_draggingDividerIndex == null) {
      return;
    }
    setState(() {
      _draggingDividerIndex = null;
    });
  }

  /// Wraps the divider widget with a [MouseRegion].
  Widget _mouseRegion(
      {required int index,
      required Axis axis,
      required Widget dividerWidget,
      required MultiSplitViewThemeData themeData}) {
    MouseCursor cursor = axis == Axis.horizontal
        ? SystemMouseCursors.resizeRow
        : SystemMouseCursors.resizeColumn;
    return MouseRegion(
        cursor: cursor,
        onEnter: (event) =>
            _updatesHoverDividerIndex(index: index, themeData: themeData),
        onExit: (event) => _updatesHoverDividerIndex(themeData: themeData),
        child: dividerWidget);
  }

  /// Builds an [Offset] for cursor position.
  Offset _offset(BuildContext context, Offset globalPosition) {
    final RenderBox container = context.findRenderObject() as RenderBox;
    return container.globalToLocal(globalPosition);
  }
}
