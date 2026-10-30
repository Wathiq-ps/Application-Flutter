import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/home/presentation/pages/home_screen.dart';
import 'package:mobile/features/profile/presentation/pages/profile_screen.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../saved/presentations/pages/saved_screen.dart';
import '../../../search/presentations/pages/search_screen.dart';
import '../state_mangment/navigation_cubit.dart';
import '../state_mangment/navigation_state.dart';
import '../widgets/main_bottom_navigation_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> pages = [
    HomeScreen(),
    SavedScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final PageController _controller;
  bool _programmatic = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: context.read<NavigationCubit>().state.selectedIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateTo(int index) async {
    if (!_controller.hasClients) return;
    if ((_controller.page?.round() ?? index) == index) return;
    _programmatic = true;
    try {
      await _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } finally {
      _programmatic = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listenWhen: (p, c) => p.selectedIndex != c.selectedIndex,
      listener: (context, state) => _animateTo(state.selectedIndex),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: false,
        body: PageView(
          controller: _controller,
          onPageChanged: (index) {
            if (_programmatic) return;
            context.read<NavigationCubit>().changeTab(index);
          },
          children: [
            for (final page in MainNavigationScreen.pages)
              _KeepAlivePage(child: page),
          ],
        ),
        bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) => MainBottomNavigationBar(
            selectedIndex: state.selectedIndex,
            onTabSelected: context.read<NavigationCubit>().changeTab,
          ),
        ),
      ),
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}