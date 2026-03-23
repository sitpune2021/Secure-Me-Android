import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_me/features/safety/domain/models.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final UserRole role;

  const LoginRequested(this.email, this.password, this.role);
  @override
  List<Object?> get props => [email, password, role];
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      // Mock Login
      await Future.delayed(const Duration(seconds: 1));
      
      final mockUser = UserModel(
        id: '1',
        name: 'Mock ${event.role.name}',
        email: event.email,
        phone: '1234567890',
        role: event.role,
      );
      
      emit(Authenticated(mockUser));
    });

    on<LogoutRequested>((event, emit) {
      emit(Unauthenticated());
    });
  }
}
