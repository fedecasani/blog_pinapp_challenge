import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {
  final int start;
  final int limit;

  FetchPostsEvent({this.start = 0, this.limit = 10});

  @override
  List<Object?> get props => [start, limit];
}