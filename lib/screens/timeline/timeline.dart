import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/timeline/reacts.dart';
import 'package:chirp_frontend/screens/profile/public_profile.dart';
import 'package:intl/intl.dart';

/// The timeline page.
class Timeline extends StatefulWidget {
  const Timeline({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimelineState();
  }
}

/// The state class for [Timeline].
class _TimelineState extends State<Timeline> {
  /// Result of calling fetchPosts
  late Future<dynamic> _futureTimelinePosts;

  /// ID of last post (-1 gets most recent post)
  int lastPostId = -1;

  /// Number of posts to fetch
  int count = 60;

  @override
  void initState() {
    super.initState();
    _futureTimelinePosts = apiProvider.fetchPosts(count, lastPostId);
  }

  /// Displays user name and avatar on individual timeline posts
  Container userInfo(String name, String avatar, int id) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            padding: const EdgeInsets.all(2),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(avatar),
                fit: BoxFit.fill,
              ),
              border: Border.all(color: Colors.grey, width: 1),
              shape: BoxShape.circle,
            ),
          ),
          InkWell(
            child: Text(name, style: h2),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PublicProfile(userId: id, key: UniqueKey()),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  /// Displays subheading with timestamps for each timeline post
  Container postTimestamp(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        child: Text(
            '${DateFormat.yMMMMd('en_US').format(dateTime)}, ${DateFormat.jm().format(dateTime)}',
            style: timeStyle));
  }

  /// Builds main emoji + story emoji display for each post
  Row emojiDisplay(String mainEmoji, String storyEmojis) {
    return Row(
      children: <Widget>[
        // text widget containing main emoji
        RichText(text: TextSpan(text: mainEmoji, style: mainEmojiStyle)),
        // spacer
        Container(width: 10),
        // text widgets for story emojis
        RichText(text: TextSpan(text: storyEmojis, style: storyEmojiStyle)),
      ],
    );
  }

  /// Builds individual Timeline posts
  SizedBox card(
      String name,
      String avatar,
      String date,
      String mainEmoji,
      String storyEmojis,
      String? myReaction,
      Map<String, dynamic>? reactions,
      int id,
      int userID) {
    return SizedBox(
      height: 160,
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  userInfo(name, avatar, userID),
                  postTimestamp(date),
                  emojiDisplay(mainEmoji, storyEmojis),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 30),
              child: Reacts(
                myReaction: myReaction,
                reactions: reactions,
                postId: id,
                key: UniqueKey(),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Gets new data from the database when the user pulls to refresh
  Future<void> _getData() async {
    setState(() {
      _futureTimelinePosts = apiProvider.fetchPosts(count, lastPostId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Timeline',
          style: pageHeader,
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: FutureBuilder(
          future: _futureTimelinePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("timeline error: ${snapshot.error}");
            } else if (snapshot.data == null || snapshot.data.isEmpty) {
              return const Center(
                child: Text(
                  'Sorry, no posts were found',
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: _getData,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = snapshot.data[index];
                  if (index == 0) {
                    // if it's the first item in the list, create padding at the top
                    return Container(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: card(
                        item['userName'],
                        item['avatar'],
                        item['postTime'],
                        item['mainEmoji'],
                        item['storyEmojis'],
                        item['myReaction'],
                        item['reactions'],
                        item['id'],
                        item['userID'],
                      ),
                    );
                  }
                  return card(
                    item['userName'],
                    item['avatar'],
                    item['postTime'],
                    item['mainEmoji'],
                    item['storyEmojis'],
                    item['myReaction'],
                    item['reactions'],
                    item['id'],
                    item['userID'],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
