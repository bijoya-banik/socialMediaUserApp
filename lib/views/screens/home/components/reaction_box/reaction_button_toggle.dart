import 'dart:async';

import 'package:buddyscripts/constants/reactions_constants.dart';
import 'package:buddyscripts/models/reaction_button/reaction_model.dart';
import 'package:buddyscripts/services/audio_player_service.dart';
import 'package:buddyscripts/utils/extensions.dart';
import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';
import 'reactions_box.dart';

class ReactionButtonToggle<T> extends StatefulWidget {
  /// This triggers when reaction button value changed.
  final void Function(T?, bool, ReactionModel<T>) onReactionChanged;

  /// Default reaction button widget if [isChecked == false]
  final ReactionModel<T>? initialReaction;

  /// Default reaction button widget if [isChecked == true]
  final ReactionModel<T>? selectedReaction;

  final List<ReactionModel<T>?> reactions;

  /// Position reactions box for the button [default = TOP]
  final Position boxPosition;

  /// Reactions box color [default = white]
  final Color boxColor;

  /// Reactions box elevation [default = 5]
  final double boxElevation;

  /// Reactions box radius [default = 50]
  final double boxRadius;

  /// Reactions box show/hide duration [default = 200 milliseconds]
  final Duration boxDuration;

  /// Flag for pre-set reactions if true @link selectedReaction will be
  /// displayed else @link initialReaction will be displayed [default = false]
  final bool isChecked, isFromComments;

  /// Reactions box padding [default = const EdgeInsets.all(0)]
  final EdgeInsets boxPadding;

  /// Scale ratio when item hovered [default = 0.3]
  final double itemScale;

  /// Scale duration while dragging [default = const Duration(milliseconds: 100)]
  final Duration? itemScaleDuration;

  const ReactionButtonToggle({
    Key? key,
    required this.onReactionChanged,
    required this.reactions,
    this.initialReaction,
    this.selectedReaction,
    this.boxPosition = Position.TOP,
    this.boxColor = Colors.white,
    this.boxElevation = 5,
    this.boxRadius = 50,
    this.boxDuration = const Duration(milliseconds: 200),
    this.isChecked = false,
    this.boxPadding = const EdgeInsets.all(0),
    this.itemScale = .3,
    this.itemScaleDuration,
    this.isFromComments = false,
  }) : super(key: key);

  @override
  _ReactionButtonToggleState createState() => _ReactionButtonToggleState<T>();
}

class _ReactionButtonToggleState<T> extends State<ReactionButtonToggle<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: _buttonKey,
        // onLongPress: () {
        //   print('onLongPress');
        //   _onTapReactionButton();
        // },
        onLongPressStart: (val) {
          print('onLongPressStart');
          _onTapReactionButton();
        },
        child: Container(color: KColor.transparent, child: (widget.reactions[0])!.icon));
  }

  void _onTapReactionButton() {
    if (_timer != null) return;
    _timer = Timer(const Duration(milliseconds: 0), () {
      _timer = null;
      _showReactionsBox();
    });
  }

  void _showReactionsBox() async {
    AudioPlayerService.playSound('box_up.mp3');
    final buttonOffset = _buttonKey.widgetPositionOffset;
    final buttonSize = _buttonKey.widgetSize;
    final reactionButton = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return ReactionsBox(
            buttonOffset: buttonOffset,
            buttonSize: buttonSize,
            reactions: widget.reactions,
            position: widget.boxPosition,
            color: widget.boxColor,
            elevation: widget.boxElevation,
            radius: widget.boxRadius,
            duration: widget.boxDuration,
            boxPadding: widget.boxPadding,
            itemScale: widget.itemScale,
            itemScaleDuration: widget.itemScaleDuration,
            isFromComments: widget.isFromComments,
          );
        },
      ),
    );

    if (reactionButton != null) _updateReaction(reactionButton, true);
  }

  void _updateReaction(ReactionModel<T>? reaction, [bool isSelectedFromDialog = false]) {
    AudioPlayerService.playSound('icon_choose.mp3');
    if (reaction != null) {
      widget.onReactionChanged.call(reaction.value, true, reaction);
    }
  }
}
