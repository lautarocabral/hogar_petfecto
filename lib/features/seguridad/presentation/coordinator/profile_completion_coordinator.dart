import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/coordinator/profile_coordinator_page.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';

class ProfileCompletionCoordinator {
  static void handleProfileCompletion(
    BuildContext context,
    UsuarioResponseDto user,
  ) {
    if (user.hasToUpdateProfile.isEmpty) {
      context.pushReplacement(HomePage.route);
    } else {
      context.pushReplacement(
        ProfileCompletionCoordinatorPage.route,
        extra: user.hasToUpdateProfile,
      );
    }
  }
}
