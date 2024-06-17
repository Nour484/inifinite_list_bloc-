import 'package:equatable/equatable.dart';

sealed class PostsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPostsEvent extends PostsEvents {}
