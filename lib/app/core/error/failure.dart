abstract class Failure {
  final String message;

  const Failure(this.message);
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({String? message})
      : super("An unknown server error occurred.");
}

class WriteFileFailure extends Failure {
  const WriteFileFailure({String? message})
      : super("An unknown server error occurred while reading database.");
}

class ReadDatabaseFailure extends Failure {
  const ReadDatabaseFailure({String? message})
      : super("An unknown server error occurred while writing into database.");
}

// Firebase-specific authentication failures
class FirebaseAuthFailure extends Failure {
  const FirebaseAuthFailure({String? message})
      : super("An unknown FirebaseAuth error occurred.");
}

class InvalidEmailFailure extends FirebaseAuthFailure {
  const InvalidEmailFailure({String? message})
      : super(message: "The email address is not valid.");
}

class WrongPasswordFailure extends FirebaseAuthFailure {
  const WrongPasswordFailure({String? message})
      : super(message: "The password is incorrect.");
}

class UserNotFoundFailure extends FirebaseAuthFailure {
  const UserNotFoundFailure({String? message})
      : super(message: "User with this email does not exist.");
}

class InvalidCredentialFailure extends Failure {
  const InvalidCredentialFailure() : super("Invalid credentials provided");
}

class UserDisabledFailure extends FirebaseAuthFailure {
  const UserDisabledFailure({String? message})
      : super(message: "This user has been disabled.");
}

class TooManyRequestsFailure extends FirebaseAuthFailure {
  const TooManyRequestsFailure({String? message})
      : super(message: "Too many requests. Try again later.");
}

class OperationNotAllowedFailure extends FirebaseAuthFailure {
  const OperationNotAllowedFailure({String? message})
      : super(message: "Operation not allowed.");
}

class WeakPasswordFailure extends FirebaseAuthFailure {
  const WeakPasswordFailure({String? message})
      : super(message: "The password is too weak.");
}
