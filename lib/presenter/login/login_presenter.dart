import 'package:trip_planner_ui/services/api_service.dart';
import 'package:trip_planner_ui/views/login/login_screen.dart';

class LoginPresenter {
  final ApiService apiService = ApiService();

  void login(String? email, String? password) async {
    final usuario =
        await apiService.post('auth/login', {"email": email, "password": password});

    if (usuario != null) {
      print(usuario);
    } else {
      // view.onLoginError("Credenciales incorrectas");
      print('Error');
    }
  }
}
