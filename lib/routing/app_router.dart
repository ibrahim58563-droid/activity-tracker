import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/domain/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/students/presentation/students_list_screen.dart';
import '../features/students/presentation/student_profile_screen.dart';
import '../features/students/presentation/add_edit_student_screen.dart';
import 'shell_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/students',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull ?? false;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/students';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/students',
            builder: (context, state) => const StudentsListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => StudentProfileScreen(
                  studentId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/add-student',
            builder: (context, state) => const AddEditStudentScreen(),
          ),
          GoRoute(
            path: '/edit-student/:id',
            builder: (context, state) => AddEditStudentScreen(
              studentId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
    ],
  );
});
