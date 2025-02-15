import 'package:firebase_core/firebase_core.dart';

class FirebaseUtils {
  FirebaseUtils._();

  static String handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return "You do not have permission to perform this action.";
      case 'unavailable':
        return "Firestore service is currently unavailable. Try again later.";
      case 'deadline-exceeded':
        return "Request timed out. Please check your internet connection.";
      case 'not-found':
        return "The requested document was not found.";
      case 'already-exists':
        return "An employee with this ID already exists.";
      case 'invalid-argument':
        return "Invalid data format. Please check your inputs.";
      default:
        return "Firestore error: ${e.message}";
    }
  }
}
