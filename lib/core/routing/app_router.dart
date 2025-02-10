import 'package:app/features/home/logic/home_cubit.dart';
import 'package:app/features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/client_events/data/models/client_event_response.dart';
import '../../features/client_events/data/models/client_messages_status_response.dart';
import '../../features/client_events/logic/client_events_cubit.dart';
import '../../features/client_events/ui/client_events_screen.dart';
import '../../features/client_events/ui/widgets/client_event_details.dart';
import '../../features/client_events/ui/widgets/client_guest_details_screen.dart';
import '../../features/client_events/ui/widgets/client_messages_status_screen.dart';
import '../../features/client_statistics/data/models/guest_type_list.dart';
import '../../features/client_statistics/logic/client_statistics_cubit.dart';
import '../../features/client_statistics/ui/client_statistics_screen.dart';
import '../../features/client_statistics/ui/widgets/client_confirmation_services/client_confirmation_services_screen.dart';
import '../../features/client_statistics/ui/widgets/client_confirmation_services/client_message_status.dart';
import '../../features/client_statistics/ui/widgets/client_messages/client_messages_statistics_screen.dart';
import '../../features/client_statistics/ui/widgets/sent_cards_services/sent_cards_services_screen.dart';
import '../../features/event_calender/ui/event_calender_screen.dart';
import '../../features/events_scan_history/data/models/gatekeeper_events_response.dart';
import '../../features/events_scan_history/logic/gatekeeper_events_cubit.dart';
import '../../features/events_scan_history/ui/my_events_screen.dart';
import '../../features/events_scan_history/ui/scan_history_screen.dart';
import '../../features/events_scan_history/ui/widgets/event_history_details_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/home/ui/widgets/event_instructions_screen.dart';
import '../../features/home/ui/widgets/profile_screen.dart';
import '../../features/location/logic/location_cubit.dart';
import '../../features/login/logic/login_cubit.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/qr_code_scanner/ui/qr_code_scanner_screen.dart';
import '../../features/register/logic/register_cubit.dart';
import '../../features/register/ui/register_screen.dart';

import '../../features/splash/ui/on_boarding_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return _buildRoute(const SplashScreen());

      case Routes.loginScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.registerScreen:
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<
                    RegisterCubit>(), // RegisterCubit for handling registration
              ),
              BlocProvider(
                create: (_) => getIt<
                    LocationCubit>(), // LocationCubit for handling location
              ),
            ],
            child: const RegisterScreen(),
          ),
        );

      case Routes.onBoardingScreen:
        return _buildRoute(
          const OnBoardingScreen(),
        );
      case Routes.homeScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child:
                const HomeScreen(), // RegisterCubit for handling registration
          ),
        );

      case Routes.profileScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const ProfileScreen(),
          ),
        );
      case Routes.eventInstructionsScreen:
        return _buildRoute(
          const EventInstructionsScreen(),
        );
      case Routes.qrCodeScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<QrCodeScannerCubit>(),
            child: const QrCodeScannerScreen(),
          ),
        );
      case Routes.eventsHistory:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: const ScanHistoryScreen(),
          ),
        );
      case Routes.eventDetailScreen:
        final event = arguments as EventsList;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: EventHistoryDetailsScreen(event: event),
          ),
        );
      case Routes.myEventsScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<GatekeeperEventsCubit>(),
            child: const MyEventsScreen(),
          ),
        );

      case Routes.eventsCalendar:
        return _buildRoute(
          const EventCalenderScreen(),
        );

      case Routes.clientEvents:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: const ClientEventsScreen(),
          ),
        );
      case Routes.clientEventsDetailsScreen:
        final event = arguments as ClientEventDetails;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: ClientEventDetailsScreen(clientEventDetailsItem: event),
          ),
        );

      case Routes.clientMessagesStatusScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: ClientMessagesStatusScreen(eventId: eventId),
          ),
        );

      case Routes.clientGuestDetailsScreen:
        final clientMessagesStatusDetails =
            arguments as ClientMessagesStatusDetails;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientEventsCubit>(),
            child: ClientGuestDetailsScreen(
                clientMessagesStatusDetails: clientMessagesStatusDetails),
          ),
        );

      case Routes.clientStatisticsScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: const ClientStatisticsScreen(),
          ),
        );

      case Routes.clientMessagesStatisticsScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: ClientMessagesStatisticsScreen(eventId: eventId),
          ),
        );
      case Routes.clientConfirmationServicesScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: ClientConfirmationServicesScreen(eventId: eventId),
          ),
        );
      case Routes.clientMessageStatus:
        final args = arguments as Map<String, dynamic>;
        final eventId = args['eventId'] as String;
        final type = args['type'] as GuestListType;
        final title = args['title'] as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child:
                ClientMessageStatus(eventId: eventId, type: type, title: title),
          ),
        );
      case Routes.sentCardsServicesScreen:
        final eventId = arguments as String;
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<ClientStatisticsCubit>(),
            child: SentCardsServicesScreen(eventId: eventId),
          ),
        );
      default:
        return _buildRoute(const SplashScreen());

      //   _buildRoute(
      //   Scaffold(
      //     body: Center(
      //       child: Text('No route defined for ${settings.name}'),
      //     ),
      //   ),
      // );
    }
  }

  Route _buildRoute(Widget page, {bool useCupertino = false}) {
    if (useCupertino || TargetPlatform.iOS == defaultTargetPlatform) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }
}
