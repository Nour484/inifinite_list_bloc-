import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_list_bloc/posts/bloc/posts_bloc.dart';
import 'package:infinite_list_bloc/posts/bloc/posts_events.dart';

import 'post_view.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            PostBloc(httpClient: http.Client())..add(FetchPostsEvent()),
        child: const PostView(),
      ),
    );
  }
}
