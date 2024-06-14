import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/features/forums/presentation/bloc/discussion_bloc.dart';
import 'package:flutterapp/features/members/presentation/bloc/member_bloc.dart';
import 'package:provider/provider.dart';

import 'config/theme/theme_contants.dart';
import 'config/theme/theme_manager.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/feed/presentation/views/main_screen.dart';
import 'injections_container.dart' as dependencyInjection;
import 'injections_container.dart';

void main() {
  dependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AuthBloc>()..add(AppStarted()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                serviceLocator<DiscussionBloc>()..add(GetDiscussionEvent()),
          ),
          BlocProvider(
            create: (_) => serviceLocator<MemberBloc>()..add(GetMemberEvent()),
          ),
        ],
        child: ChangeNotifierProvider<ThemeService>(
          create: (context) => ThemeService(),
          child: Consumer(
            builder: (context, ThemeService theme, _) {
              return MaterialApp(
                title: 'TechForum',
                debugShowCheckedModeBanner: false,
                theme: theme.darkTheme! ? darkTheme : lightTheme,
                home: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return const MainScreen();
                    } else if (state is Unauthenticated) {
                      return const LoginScreen();
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}