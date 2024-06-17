import 'package:equatable/equatable.dart';

final class PostModel extends Equatable {
  PostModel({required this.id, required this.title, required this.body});
  int id;
  String title;
  String body;

  List<Object> get  props  => [id, title, body];
}
