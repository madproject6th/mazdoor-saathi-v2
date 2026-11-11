import 'package:firebase_auth/firebase_auth.dart';

/// Firebase EMAIL + password authentication (primary auth for v2).
class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  bool get emailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<UserCredential> signUp(String email, String password) => _auth
      .createUserWithEmailAndPassword(email: email.trim(), password: password);

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> sendEmailVerification() async {
    final u = _auth.currentUser;
    if (u != null && !u.emailVerified) await u.sendEmailVerification();
  }

  Future<void> reloadUser() async => _auth.currentUser?.reload();

  Future<String?> idToken() async {
    final u = _auth.currentUser;
    return u == null ? null : u.getIdToken();
  }

  Future<void> signOut() => _auth.signOut();

  /// Friendly message for FirebaseAuthException codes.
  static String friendly(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';
        case 'email-already-in-use':
          return 'An account already exists for this email. Try logging in.';
        case 'weak-password':
          return 'Password is too weak — use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Check your connection and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait and try again.';
        default:
          return e.message ?? 'Authentication failed.';
      }
    }
    return e.toString();
  }
}
