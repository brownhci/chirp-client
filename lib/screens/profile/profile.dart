import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/settings/settings.dart';
import 'package:chirp_frontend/singletons/user_data.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart';

/// The Profile page.
class Profile extends StatefulWidget {
  const Profile({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

/// The state class for [Profile].
class _ProfileState extends State<Profile> {
  /// Result of calling myPosts
  late Future<dynamic> _futureMyPosts;

  /// Represents the current date
  late String today;

  @override
  void initState() {
    super.initState();
    _futureMyPosts = apiProvider.myPosts();
    today = DateFormat.yMMMMd('en_US').format(DateTime.now());
  }

  /// Header for profile page; includes name, avatar, and current date
  SliverAppBar profileHeader(String name, String avatar) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: false,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
          background: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 15, 20),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(avatar), fit: BoxFit.fill),
                border: Border.all(color: Colors.grey, width: 1),
                shape: BoxShape.circle,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: profileNameStyle),
                Text(today, style: profileDateStyle)
              ],
            ),
          ],
        ),
      )),
    );
  }

  /// Header for individual cards; includes day/month
  Row cardHeader(String timePosted) {
    DateTime dateTime = DateTime.parse(timePosted).toLocal();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(DateFormat.d().format(dateTime), style: profileCardDayStyle),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 4),
          child: Text(DateFormat.MMMM().format(dateTime),
              style: profileCardMonthStyle),
        )
      ],
    );
  }

  /// Displays mood postings (main emoji + timestamp) for collapsed cards
  SizedBox collapsed(String mainEmoji, String timePosted) {
    DateTime dateTime = DateTime.parse(timePosted).toLocal();
    return SizedBox(
      width: 70,
      child: Column(
        children: <Widget>[
          RichText(text: TextSpan(text: mainEmoji, style: mainEmojiStyle)),
          Text(DateFormat.jm().format(dateTime), style: timeStyle)
        ],
      ),
    );
  }

  /// Displays mood postings (main emoji + story emojis + timestamp) for expanded cards
  Widget expanded(String mainEmoji, String storyEmojis, String timePosted) {
    DateTime dateTime = DateTime.parse(timePosted).toLocal();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(bottom: 10),
            width: 70,
            child: Column(
              children: <Widget>[
                RichText(
                    text: TextSpan(text: mainEmoji, style: mainEmojiStyle)),
                Text(DateFormat.jm().format(dateTime), style: timeStyle)
              ],
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
          child: RichText(
              text: TextSpan(text: storyEmojis, style: storyEmojiStyle)),
        )
      ],
    );
  }

  /// Creates individual profile cards, where each card contains all posts from that day
  Card profilePost(List<dynamic> postList, String time) {
    return Card(
      elevation: 0.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: ExpandablePanel(
          // displays the header for a profile post card
          header: Container(
              padding: const EdgeInsets.only(left: 15),
              child: cardHeader(time)),
          // collapsed view of individual mood postings (only displays main emoji + timestamp)
          collapsed: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(height: 2, color: Colors.grey),
              Container(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    runAlignment: WrapAlignment.start,
                    children: <Widget>[
                      for (var post in postList)
                        collapsed(post['mainEmoji'], post['timePosted'])
                    ],
                  ))
            ],
          ),
          // expanded view of individual mood postings (displays main emoji + story emojis + timestamp)
          expanded: Column(
            children: <Widget>[
              const Divider(height: 2, color: Colors.grey),
              Container(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: Column(
                    children: <Widget>[
                      for (var post in postList)
                        expanded(post['mainEmoji'], post['storyEmojis'],
                            post['timePosted'])
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a list of lists of posts, where each list contains all posts for a single day
  List<dynamic> sortPosts(List<dynamic> posts) {
    String prevDate = '';
    var result = <dynamic>[];
    var temp = [];
    for (var i = 0; i < posts.length; i++) {
      Map<String, dynamic> currPost = posts[i];
      DateTime dateTime = DateTime.parse(posts[i]['timePosted']).toLocal();
      String currDate = DateFormat.yMd().format(dateTime);
      if (i == 0) {
        // if it's the first post in the list, set the previous date to the current date
        prevDate = currDate;
      }
      if (prevDate == currDate) {
        // if the current post is in the same day, add it to temp
        temp.add(currPost);
      } else {
        // otherwise, set the previous date, add the list of posts for a single day to the list of results, and reset
        prevDate = currDate;
        result.insert(0, temp);
        temp = [];
        temp.add(currPost);
      }
    }
    result.insert(0, temp); // add the last list of posts to the results list
    return result;
  }

  /// Builds a list of cards containing all profile posts
  FutureBuilder allProfilePosts() {
    return FutureBuilder(
        future: _futureMyPosts,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'Sorry, no posts were found',
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("timeline error: ${snapshot.error}");
          }
          List<dynamic> sortedPosts = sortPosts(snapshot.data);
          return ListView.builder(
              itemCount: sortedPosts.length,
              itemBuilder: (BuildContext context, int index) {
                final postList =
                    sortedPosts[index]; // list of posts for one day
                var time = postList[0]
                    ['timePosted']; // the date the posts were created
                if (index == 0) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: profilePost(postList, time));
                }
                return profilePost(postList, time);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: const Text('My Profile',
              style: pageHeader),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Settings(key: UniqueKey(), payload: ''),
                  ),
                );
              },
            )
          ]),
      body: Center(
        // builds profile if user info is loaded
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              profileHeader(userData.data?['name'], userData.data?['avatar']),
            ];
          },
          body: allProfilePosts(),
        ),
      ),
    );
  }
}
