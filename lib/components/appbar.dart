import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(72); // Adjust the height as needed

  final String title;
  final VoidCallback? onClickedBack;
  final VoidCallback? onClickedHome;

  const CustomAppBar({super.key, 
    required this.title,
     this.onClickedBack,
     this.onClickedHome,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.tertiary),
        onPressed: onClickedHome,
      ),
      actions: [
        IconButton(
          icon: Image.asset("assets/mavunohub_icon.png",width: 25,),
          iconSize: 35,
          // onPressed: (){
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ))
          // },
          onPressed: onClickedHome,
        ),
        const Padding(padding: EdgeInsets.all(10)),
      ],
      elevation: 0.0,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontFamily: 'Gilmer',
          fontSize: 32,
          fontWeight: FontWeight.w800,
        ),
      ),
      toolbarHeight: 150,
      // centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.background],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.only(bottom: 38),
      ),
    );
  }
}
