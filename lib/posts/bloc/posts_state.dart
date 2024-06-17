import 'package:equatable/equatable.dart';

import '../models/post_model.dart';

enum PostsStatus { initial, success, failure }

final class PostState extends Equatable {
  const PostState(
      {this.status = PostsStatus.initial,
      this.posts = const <PostModel>[],
      this.hasReachedMax = false});
  final PostsStatus status;
  final List<PostModel> posts;
  final bool hasReachedMax;

  PostState copyWith(
      {PostsStatus? state, List<PostModel>? posts, bool? hasReachedMax}) {
    return PostState(
        status: state ?? this.status,
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    // TODO: implement toString
    return """PostState state : $status , Post : $posts  , hasReachedMax : $hasReachedMax""";
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, posts, hasReachedMax];
}
