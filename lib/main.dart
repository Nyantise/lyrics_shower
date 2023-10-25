import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyrics_shower/file_watcher.dart';
import 'package:lyrics_shower/key_binds.dart';
import 'package:lyrics_shower/lyrics_text.dart';
import 'package:lyrics_shower/app_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

Future<void> main() async {
  runApp(const MyApp());
  const initialSize = Size(450, 300);
  appWindow.size = initialSize;
  appWindow.alignment = Alignment.center;

  WidgetsFlutterBinding.ensureInitialized();
  // For hot reload, `unregisterAll()` needs to be called.
  await hotKeyManager.unregisterAll();
  await registerKeys();

  await getConfig();

  appWindow.show();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GlobalCatcher(
        child: Obx(
      () => Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 1400),
                curve: Curves.elasticOut,
                decoration: BoxDecoration(
                    color: appState.stayFocused.value
                        ? Color(appState.backgroundColor.value)
                        : Colors.transparent,
                    border: Border.all(
                      color: appState.hover.value
                          ? Color(appState.subcolor.value)
                          : Colors.transparent,
                    )),
                width: appState.isReady.isFalse ? 200 : 100.w,
                height: appState.isReady.isFalse ? 200 : 100.h,
                child: appState.isReady.value
                    ? Stack(
                        children: [
                          Positioned(
                            top: 5.h,
                            right: 5.h,
                            child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                opacity: appState.stayFocused.value ? 1 : 0,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit_note_outlined,
                                      color: Color(appState.subcolor.value),
                                      size: 21,
                                    ),
                                    Text(
                                      ' Edit',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color(appState.subcolor.value)),
                                    ),
                                  ],
                                )),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 3.h,
                                ),
                                const LyricsText()
                              ]),
                        ],
                      )
                    : hello),
          )),
    ));
  }
}

var hello = Center(
  child: TextAnimator(
    'Hello!',
    initialDelay: const Duration(milliseconds: 500),
    characterDelay: const Duration(milliseconds: 80),
    incomingEffect: WidgetTransitionEffects.outgoingScaleUp(
        duration: const Duration(milliseconds: 100)),
    outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
    style: TextStyle(color: Color(appState.textColor.value), fontSize: 32),
  ),
);
