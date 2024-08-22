import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.goBack,
  });

  final String title;
  final VoidCallback? goBack;

  @override
  State<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: GoogleFonts.lato(
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      leading: widget.goBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.goBack,
            )
          : null,
    );
  }
}
