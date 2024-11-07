import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:global_configuration/global_configuration.dart';

class ApiProvider {
  late Dio _dio;

  final BaseOptions options = BaseOptions(
    baseUrl: GlobalConfiguration().getValue("host"),
  );
  static final ApiProvider _instance = ApiProvider._internal();

  factory ApiProvider() => _instance;

  ApiProvider._internal() {
    _dio = Dio(options);
  }

  /// Adds a persistCookieJar
  void addCookieJar(CookieJar cookieJar) {
    _dio.interceptors.add(CookieManager(cookieJar));
  }

  /// Returns the UID of the existing user after login
  Future loginUser(String token) async {
    final request = {"token": token};
    final response = await _dio.post('/login',
        data: request,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ));
    return response.data['result']['userID'];
  }

  Future joinGroup(String groupId) async {
    final request = {"group_id": groupId};
    final response = await _dio.post('/user/group',
        data: request,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          },
        ));
    return response.statusCode;
  }

  Future leaveGroup() async {
    final response = await _dio.post('/user/leave_group',
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          },
        ));
    return response.statusCode;
  }

  Future createGroup(String name) async {
    final request = {"name": name};
    final response = await _dio.post('/group',
        data: request,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          },
        ));
    return response.statusCode;
  }

  /// Returns the UID of the newly created user
  Future createAccount(String token) async {
    final request = {"token": token};
    final response = await _dio.post('/user',
        data: request,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          },
        ));
    return response.data['result']['userID'];
  }

  /// Makes a new post
  Future makePost(String mainEmoji, String storyEmojis) async {
    final request = {'main_emoji': mainEmoji, 'emoji_string': storyEmojis};
    final response = await _dio.post(
      '/post',
      data: request,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          }),
    );
    return response.data['result'];
  }

  /// Makes a new reaction on a post
  Future makeReaction(int postId, String react) async {
    final request = {'emoji': react};
    final response = await _dio.post(
      '/post/$postId/reaction',
      data: request,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          }),
    );
    return response.data['result'];
  }

  /// Removes a reaction from a post
  Future removeReaction(int postId, String react) async {
    final request = {'emoji': react};
    await _dio.delete(
      '/post/$postId/reaction',
      data: request,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 204;
          }),
    );
  }

  /// Logs out the current user
  Future logoutUser() async {
    await _dio.post(
      '/logout',
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 204;
          }),
    );
  }

  // gets all of the current user's posts
  Future<dynamic> myPosts() async {
    final response = await _dio.get(
      '/user/posts',
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          }),
    );
    return response.data['result'];
  }

  // gets all of the passed user's posts
  Future<dynamic> userPosts(int id) async {
    final response = await _dio.get(
      '/posts/$id',
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          }),
    );
    return response.data['result'];
  }

  /// Gets all users' posts from the database
  Future<dynamic> fetchPosts(int numPosts, int lastPostId) async {
    final request = {'num_posts': numPosts, 'last_post_id': lastPostId};
    final response = await _dio.get(
      '/posts',
      queryParameters: request,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          }),
    );
    return response.data['result'];
  }

  /// Gets information about the current user
  Future<Map<String, dynamic>?> getUser(int? id) async {
    try {
      final response = await _dio.get(
        '/user/$id',
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 200;
            }),
      );
      if (response.statusCode != 200) return null;
      return Map<String, dynamic>.from(response.data['result']);
    } catch (e) {
      return null;
    }
  }

  /// Gets the notification for the login page
  Future<dynamic> fetchLoginNotification() async {
    final response = await _dio.get(
      '/user/notification',
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 200;
          }),
    );
    return response.data['result'];
  }
}
