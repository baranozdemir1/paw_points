import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../riverpod/providers/auth_provider.dart';
import 'register_state.dart';

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController(this.ref) : super(const RegisterStateInitial());

  final Ref ref;

  Future<void> register(String email, String password) async {
    state = const RegisterStateLoading();
    try {
      await ref.read(authRepositoryProvider).registerWithEmailAndPassword(
            email,
            password,
          );
      state = const RegisterStateSuccess();
    } catch (e) {
      state = RegisterStateError(e.toString());
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  return RegisterController(ref);
});
