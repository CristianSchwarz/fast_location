import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../shared/colors/app_colors.dart';
import '../../home/page/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  late final Animation<double> fade;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    animation.forward();
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primary,
    body: Center(
      child: FadeTransition(
        opacity: fade,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 76),
            SizedBox(height: 12),
            Text('FastLocation', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Encontre enderecos com facilidade', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    ),
  );
}
