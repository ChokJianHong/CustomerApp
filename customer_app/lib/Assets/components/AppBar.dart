import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/Settings.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(


      leading: GestureDetector(child: const Icon(Icons.settings, color: Colors.white,),onTap: () {
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Setting()),
                  );
      },),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.notifications, color: Colors.white,),
        )
        ],
      backgroundColor: AppColors.secondary,
      

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
