import 'package:ddara/domain/provider/use_case_provider.dart';
import 'package:ddara/feature/home/util/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends AutoDisposeNotifier<HomeState> {
  @override
  HomeState build() {
    _load();
    return const HomeState(isLoading: true);
  }

  Future<void> _load() async {
    final getGroupListUseCase = ref.read(getGroupListUseCaseProvider);

    try {
      final groupList = await getGroupListUseCase();
      state = state.copyWith(isLoading: false, groups: groupList.groups);
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: '목록을 불러오지 못했어요.');
    }
  }
}
