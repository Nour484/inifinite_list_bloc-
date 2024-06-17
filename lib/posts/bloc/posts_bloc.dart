import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_list_bloc/posts/bloc/posts_events.dart';
import 'package:infinite_list_bloc/posts/bloc/posts_state.dart';
import 'package:infinite_list_bloc/posts/models/model.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

const _postLimit = 20;

EventTransformer<E> throttelDroppable<E>(Duration duration) {
  return (event, mapper) {
    return droppable<E>().call(event.throttle(duration), mapper);
  };
}

class PostsBloc extends Bloc<PostsEvents, PostState> {
  PostsBloc({required this.httpClient}) : super(const PostState()) {
    on<FetchPostsEvent>(onPostsFetched,
        transformer: throttelDroppable(throttleDuration));
  }

  final http.Client httpClient;

  Future<void> onPostsFetched(
      FetchPostsEvent event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostsStatus.initial) {
        final post = await _fetchPosts();
        return emit(state.copyWith(
          state: PostsStatus.success,
          posts: post,
          hasReachedMax: false,
        ));
      }

      final posts = await _fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                state: PostsStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(state: PostsStatus.failure));
    }
  }

  Future<List<PostModel>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(Uri.http(
      "https://jsonplaceholder.typicode.com/posts",
      // "/posts",
      // <String, String>{"_start": "$startIndex ", "_limit": "$_postLimit "},
    ));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;

        return PostModel(
            id: json["id"], title: json["title"], body: json["body"]);
      }).toList();
    }

    throw Exception('error fetching posts');
  }
}
