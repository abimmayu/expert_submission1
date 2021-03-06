import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:muse/common/failure.dart';
import 'package:muse/common/state_enum.dart';
import 'package:muse/domain/entities/tv.dart';
import 'package:muse/domain/usecases/get_tv_popular.dart';
import 'package:muse/presentation/provider/tv_popular_notifier.dart';

import 'tv_popular_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    notifier = PopularTvNotifier(mockGetPopularTv)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  // ignore: non_constant_identifier_names
  final HitTestBehavior = Tv(
      posterPath: "/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg",
      popularity: 29.780826,
      id: 1399,
      backdropPath: "/mUkuc2wyV9dHLG0D0Loaw5pO2s8.jpg",
      voteAverage: 7.91,
      overview:
          "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
      originCountry: ["US"],
      genreIds: [10765, 10759, 18],
      originalLanguage: "en",
      voteCount: 1172,
      name: "Game of Thrones",
      originalName: "Game of Thrones");

  final tMovieList = <Tv>[HitTestBehavior];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tMovieList));
    // act
    notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tMovieList));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tv, tMovieList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
