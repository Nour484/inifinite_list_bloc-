import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_list_bloc/simple_bloc_observer.dart';

import 'my_app.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}
