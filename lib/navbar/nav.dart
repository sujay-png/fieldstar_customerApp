import 'dart:async';

import 'package:field_star_customer_app/auth/login.dart';
import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/navbar/shell.dart';
import 'package:field_star_customer_app/pages/Raisecomplaint/servicecompleted.dart';
import 'package:field_star_customer_app/pages/dashboard/dashboard.dart';
import 'package:field_star_customer_app/pages/final%20screen/final.dart';
import 'package:field_star_customer_app/pages/jobdetails/invoice_payment.dart';
import 'package:field_star_customer_app/pages/jobdetails/jobdetails.dart';
import 'package:field_star_customer_app/pages/profile/profile_page.dart';
import 'package:field_star_customer_app/pages/rating/rating.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange.map(
      (event) => event.session,
    ),
  ),

  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    final isLoginPage = state.matchedLocation == '/login';
    final isLandingPage = state.matchedLocation == '/';

    if (isLoggedIn && (isLoginPage || isLandingPage)) {
      return '/Home';
    }

    if (!isLoggedIn &&
        state.matchedLocation != '/' &&
        state.matchedLocation != '/login') {
      return '/login';
    }

    return null;
  },

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/Home',
          builder: (context, state) {
            final ticketId = state.extra as String? ?? '';
            final categoryName = state.extra as String? ?? '';
            final equipmentName = state.extra as String? ?? '';
            final problemDescription = state.extra as String? ?? '';

            return Dashboard(
              tickedID: ticketId,
              categoryName: categoryName,
              equipmentName: equipmentName,
              problemDescription: problemDescription,
            );
          },
        ),

        GoRoute(
          path: '/jobdescription',
          builder: (context, state) {
            final complaint = state.extra as RaiseComplaintModel;
            return Jobdetails(complaint: complaint);
          },
        ),

        GoRoute(
          path: '/servicecompleted',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return Servicecompleted(
              ticketId: extra?['tickectid'] as String? ?? 'N/A',
              otp: extra?['otp'] as String? ?? 'N/A',
            );
          },
        ),

        GoRoute(
          path: '/payment',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return InvoicePaymentPage(
              ticketId: extra['ticketId'] ?? '',
              technicianId: extra['technicianId'] ?? '',
              technicianName: extra['technicianName'] ?? '',
              equipment: extra['equipment'] ?? '',
              serviceDate: extra['serviceDate'] ?? '',
            );
          },
        ),

        GoRoute(
          path: '/rating',
          builder: (context, state) {
            final extra =
                state.extra as Map<String, dynamic>? ?? {}; // ✅ null-safe
            return RateServicePage(
              ticketId: extra['ticketId'] ?? '',
              technicianId: extra['technicianId'] ?? '',
              technicianName: extra['technicianName'] ?? '',
              equipment: extra['equipment'] ?? '',
              serviceDate: extra['serviceDate'] ?? '',
            );
          },
        ),

        GoRoute(
          path: '/finalpage',
          builder: (_, _) =>
              const ThankYouPage(), // ✅ fixed: __ for second param
        ),

        GoRoute(
          path: '/login',
          builder: (_, _) =>
              const LoginScreen(), // ✅ fixed: __ for second param
        ),
        GoRoute(
          path: '/profile',
          builder: (_, _) =>
              const ProfilePage(), // ✅ fixed: __ for second param
        ),
      ],
    ),
  ],
);
