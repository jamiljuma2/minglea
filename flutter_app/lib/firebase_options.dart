import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAaBkyl3B4NGmqbWs5o5Djs0w8ril7gqAk',
      authDomain:
          'minglea-2a107.firebaseapp.com', // Not used by Flutter, but included for reference
      projectId: 'minglea-2a107',
      storageBucket: 'minglea-2a107.appspot.com',
      messagingSenderId: '505667338617',
      appId: '1:505667338617:web:0b8e994fa928c9c3212fa8',
      measurementId:
          'G-NK69TPZG5S', // Not used by Flutter, but included for reference
    );
  }
}
