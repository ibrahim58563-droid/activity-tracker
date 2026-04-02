import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Top app bar matching the Archivist design — logo + title.
class ArchivistAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const ArchivistAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.menu_book,
            color: AppColors.primaryContainer,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title ?? 'The Archivist',
            style: GoogleFonts.notoSerif(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}
