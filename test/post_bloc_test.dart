import 'package:blog_pinapp_challenge/blocs/post_bloc.dart';
import 'package:blog_pinapp_challenge/blocs/post_event.dart';
import 'package:blog_pinapp_challenge/blocs/post_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:blog_pinapp_challenge/repositories/post_repository.dart';
import 'package:blog_pinapp_challenge/models/post_model.dart';


@GenerateMocks([PostRepository])
import 'post_bloc_test.mocks.dart';

void main() {
  late PostBloc postBloc;
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
    postBloc = PostBloc(mockRepository);
  });

  tearDown(() {
    postBloc.close();
  });

  group('PostBloc', () {
    test('initial state is PostInitial', () {
      expect(postBloc.state, PostInitial());
    });

    blocTest<PostBloc, PostState>(
      'emits [PostLoading, PostLoaded] when FetchPostsEvent is added and succeeds',
      build: () {
        when(mockRepository.fetchPosts(0, 10)).thenAnswer(
          (_) async => [
            Post(id: 1, title: 'Post 1', body: 'Body 1'),
            Post(id: 2, title: 'Post 2', body: 'Body 2'),
          ],
        );
        return postBloc;
      },
      act: (bloc) => bloc.add(FetchPostsEvent(start: 0, limit: 10)),
      expect: () => [
        PostLoading(),
        PostLoaded([
          Post(id: 1, title: 'Post 1', body: 'Body 1'),
          Post(id: 2, title: 'Post 2', body: 'Body 2'),
        ]),
      ],
      verify: (_) {
        verify(mockRepository.fetchPosts(0, 10)).called(1);
      },
    );

    blocTest<PostBloc, PostState>(
      'emits [PostLoading, PostError] when FetchPostsEvent is added and fails',
      build: () {
        when(mockRepository.fetchPosts(0, 10))
            .thenThrow(Exception('Failed to fetch posts'));
        return postBloc;
      },
      act: (bloc) => bloc.add(FetchPostsEvent(start: 0, limit: 10)),
      expect: () => [
        PostLoading(),
        PostError('Exception: Failed to fetch posts'),
      ],
    );
  });
}
