import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ThemeSwitcher extends StatelessWidget {
  final String currentTheme;
  final Function(String) onThemeChanged;

  // Remove const from constructor since ThemeData isn't const
  ThemeSwitcher({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  // Create a method to generate themes instead of using const
  Map<String, ThemeData> get themes {
    return {
      'light': ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      'dark': ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      'green': ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      'purple': ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
      ),
      'orange': ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeMap = themes;
    final themeKeys = themeMap.keys.toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 100,
        aspectRatio: 16 / 9,
        viewportFraction: 0.3,
        initialPage: themeKeys.indexOf(currentTheme),
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          onThemeChanged(themeKeys[index]);
        },
      ),
      items: themeMap.entries.map((entry) {
        final isSelected = entry.key == currentTheme;
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: entry.value.primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.white, width: 3)
                : null,
          ),
          child: Center(
            child: Text(
              entry.key.toUpperCase(),
              style: TextStyle(
                color: entry.value.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}