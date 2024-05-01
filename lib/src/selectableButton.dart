import 'package:flutter/material.dart';

///
/// Creates the SelectableButton class which is a button widget
/// that changes states once pressed. The state after being selected
/// as well as the starting state and the child widget within it are 
/// required in order to start something from this class.
///
class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

///
/// This actually defines the features of the selectable button state to
/// assign what happens when the button is pressed and its reflection
/// on the button's state.
///
class _SelectableButtonState extends State<SelectableButton> {
  late final MaterialStatesController statesController;

  ///
  /// Changes the button controller to refelct the current state.
  ///
  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
      <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  ///
  ///updates the state of the widget whether it was selected.
  ///
  @override
  void didUpdateWidget(SelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      statesController.update(MaterialState.selected, widget.selected);
    }
  }

  ///
  /// Builds the button widget with the controller, style,
  /// actions after being pressed, and child all set to what 
  /// the user included in the call.
  ///
  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}