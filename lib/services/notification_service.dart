import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission();
    // TODO: fetch the token and save it against the logged-in user in
    // Supabase (users.fcm_token) so your backend/Edge Function can target
    // pushes: `final token = await _messaging.getToken();`
    FirebaseMessaging.onMessage.listen((message) {
      // TODO: show an in-app banner/snackbar for foreground notifications.
    });
  }
}
