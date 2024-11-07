import 'package:chirp_frontend/widgets/custom_icons.dart';
import 'package:chirp_frontend/models/styles.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

/// Reacts on individual Timeline posts.
class Reacts extends StatefulWidget {
  final int postId;

  final String? myReaction;

  final Map<String, dynamic>? reactions;

  const Reacts(
      {required Key key,
      required this.postId,
      required this.myReaction,
      required this.reactions})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReactsState(postId, myReaction, reactions);
  }
}

/// The state class for [Reacts].
class _ReactsState extends State<Reacts> {
  /// The counts for each react.
  late int happyCount;
  late int loveCount;
  late int sadCount;
  late int surpriseCount;

  /// ID of the corresponding post
  int postId;

  /// The user's current reaction
  String? myReaction;

  /// A map of { reaction : reaction count } for each reaction type
  Map<String, dynamic>? reactions;

  _ReactsState(this.postId, this.myReaction, this.reactions);

  /// Fields for changing react colors on select/deselect. Icon and text is initially grey, but updates on toggle
  Color _happyColor = Colors.grey;
  Color _happyText = Colors.grey;
  Color _loveColor = Colors.grey;
  Color _loveText = Colors.grey;
  Color _sadColor = Colors.grey;
  Color _sadText = Colors.grey;
  Color _surpriseColor = Colors.grey;
  Color _surpriseText = Colors.grey;

  @override
  void initState() {
    super.initState();
    // if the user hasn't selected a reaction, set it to initial
    if (myReaction == null) {
      myReaction = 'initial';
    } else {
      switch (myReaction) {
        case "happy":
          {
            _happyColor = const Color(0xfff0c800);
            _happyText = Colors.black;
            break;
          }
        case "love":
          {
            _loveColor = Colors.red;
            _loveText = Colors.black;
            break;
          }
        case "sad":
          {
            _sadColor = Colors.blue;
            _sadText = Colors.black;
            break;
          }
        case "surprise":
          {
            _surpriseColor = Colors.green;
            _surpriseText = Colors.black;
            break;
          }
      }
    }

    // initializing the reactions map if no reactions exist for a post
    reactions ??= {};
    reactions!.putIfAbsent('happy', () => 0);
    reactions!.putIfAbsent('sad', () => 0);
    reactions!.putIfAbsent('love', () => 0);
    reactions!.putIfAbsent('surprise', () => 0);

    // initializing the counts for each reaction
    happyCount = reactions!['happy'] ?? 0;
    sadCount = reactions!['sad'] ?? 0;
    loveCount = reactions!['love'] ?? 0;
    surpriseCount = reactions!['surprise'] ?? 0;
  }

  /// Updates the reacts for a post when the user presses a reaction
  /// - increases/decreases count
  /// - changes reaction color + text color
  void setReact(String newReact) {
    if (newReact == myReaction) {
      apiProvider.removeReaction(postId, myReaction!);
      setState(() {
        switch (myReaction) {
          case "happy":
            {
              happyCount -= 1;
              break;
            }
          case "love":
            {
              loveCount -= 1;
              break;
            }
          case "sad":
            {
              sadCount -= 1;
              break;
            }
          case "surprise":
            {
              surpriseCount -= 1;
              break;
            }
          default:
            {}
        }
        myReaction = "initial";
      });
    } else {
      if (myReaction == "initial") {
        apiProvider.makeReaction(postId, newReact);
      } else {
        apiProvider.removeReaction(postId, myReaction!);
        apiProvider.makeReaction(postId, newReact);
        setState(() {
          switch (myReaction) {
            case "happy":
              {
                happyCount -= 1;
                break;
              }
            case "love":
              {
                loveCount -= 1;
                break;
              }
            case "sad":
              {
                sadCount -= 1;
                break;
              }
            case "surprise":
              {
                surpriseCount -= 1;
                break;
              }
            default:
              {}
          }
        });
      }
      setState(() {
        myReaction = newReact;
        switch (myReaction) {
          case "happy":
            {
              happyCount += 1;
              break;
            }
          case "love":
            {
              loveCount += 1;
              break;
            }
          case "sad":
            {
              sadCount += 1;
              break;
            }
          case "surprise":
            {
              surpriseCount += 1;
              break;
            }
          default:
            {}
        }
      });
    }
    setState(() {
      switch (myReaction) {
        case "happy":
          {
            _happyColor = const Color(0xfff0c800);
            _happyText = Colors.black;
            _loveColor = Colors.grey;
            _loveText = Colors.grey;
            _sadColor = Colors.grey;
            _sadText = Colors.grey;
            _surpriseColor = Colors.grey;
            _surpriseText = Colors.grey;
            break;
          }
        case "love":
          {
            _happyColor = Colors.grey;
            _happyText = Colors.grey;
            _loveColor = Colors.red;
            _loveText = Colors.black;
            _sadColor = Colors.grey;
            _sadText = Colors.grey;
            _surpriseColor = Colors.grey;
            _surpriseText = Colors.grey;
            break;
          }
        case "sad":
          {
            _happyColor = Colors.grey;
            _happyText = Colors.grey;
            _loveColor = Colors.grey;
            _loveText = Colors.grey;
            _sadColor = Colors.blue;
            _sadText = Colors.black;
            _surpriseColor = Colors.grey;
            _surpriseText = Colors.grey;
            break;
          }
        case "surprise":
          {
            _happyColor = Colors.grey;
            _happyText = Colors.grey;
            _loveColor = Colors.grey;
            _loveText = Colors.grey;
            _sadColor = Colors.grey;
            _sadText = Colors.grey;
            _surpriseColor = Colors.green;
            _surpriseText = Colors.black;
            break;
          }
        default:
          {
            _happyColor = Colors.grey;
            _happyText = Colors.grey;
            _loveColor = Colors.grey;
            _loveText = Colors.grey;
            _sadColor = Colors.grey;
            _sadText = Colors.grey;
            _surpriseColor = Colors.grey;
            _surpriseText = Colors.grey;
          }
      }
    });
  }

  /// Container representing individual reacts
  Row react(int reactCount, IconData icon, Color reactColor, Color textColor,
      String react) {
    return Row(
      children: <Widget>[
        Text(
          reactCount.toString(),
          style: h4.copyWith(color: textColor),
        ),
        Container(
          width: 5,
        ),
        InkWell(
          onTap: () {
            setReact(react);
          },
          child: Icon(icon, color: reactColor, size: 22),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        react(
            happyCount, CustomIcons.smile_1, _happyColor, _happyText, "happy"),
        Container(height: 8),
        react(loveCount, CustomIcons.heart, _loveColor, _loveText, "love"),
        Container(height: 8),
        react(sadCount, CustomIcons.sadTear, _sadColor, _sadText, "sad"),
        Container(height: 8),
        react(surpriseCount, CustomIcons.surprise, _surpriseColor,
            _surpriseText, "surprise")
      ],
    );
  }
}
