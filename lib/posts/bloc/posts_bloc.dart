import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_list_bloc/posts/bloc/posts_events.dart';
import 'package:infinite_list_bloc/posts/bloc/posts_state.dart';
import 'package:infinite_list_bloc/posts/models/post_model.dart';
import 'package:stream_transform/stream_transform.dart';



const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostsEvents, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<FetchPostsEvent>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
    FetchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostsStatus.initial) {
        final posts = await _fetchPosts();
        return emit(
          state.copyWith(
            state: PostsStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
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
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return PostModel(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}