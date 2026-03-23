import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secure_me/features/safety/presentation/bloc/safety_bloc.dart';
import 'package:secure_me/features/auth/presentation/pages/login_screen.dart';
import 'package:secure_me/features/user/presentation/pages/home_screen.dart';
import 'package:secure_me/features/helper/presentation/pages/helper_dashboard.dart';
import 'package:secure_me/features/police/presentation/pages/police_dashboard.dart';
import 'package:secure_me/features/safety/domain/models.dart';

void main() {
  runApp(const SecureMeApp());
}

class SecureMeApp extends StatelessWidget {
  const SecureMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => SafetyBloc()),
      ],
      child: MaterialApp(
        title: 'Secure Me – 7 Seconds',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AppRouter(),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // Role-based routing
          switch (state.user.role) {
            case UserRole.user:
              return const UserHomeScreen();
            case UserRole.helper:
              return const HelperDashboard();
            case UserRole.police:
              return const PoliceDashboard();
          }
        }
        
        // Default to Login
        return const LoginScreen();
      },
    );
  }
}
