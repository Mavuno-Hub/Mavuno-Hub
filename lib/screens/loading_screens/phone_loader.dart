import 'package:flutter/material.dart';
import 'package:mavunohub/components/drawer.dart';
import 'package:mavunohub/cards/my_box.dart';
import 'package:mavunohub/cards/my_tile.dart';

class MobileLoader extends StatefulWidget {
  const MobileLoader({Key? key}) : super(key: key);

  @override
  State<MobileLoader> createState() => _MobileLoaderState();
}

class _MobileLoaderState extends State<MobileLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MobileLoader(),
                ));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/mavunohub_icon.png',
                        width: 28, height: 28),
                  ),
                ],
              ),
            ),
          ),
        ],
        centerTitle: true, // Center the title
        title: Container(
          width:
              double.infinity, // Make the TextField take up the available width
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .secondary, // Set the background color of the search bar
            borderRadius: BorderRadius.circular(
                5.0), // Adjust the border radius as needed
          ),
          child: TextFormField(
            maxLines: 1,
            // controller: widget.controller,
            cursorColor: Theme.of(context).colorScheme.tertiary,
            minLines: 1,
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter ${widget.text}';
            //   }
            //   return null;
            // },

            style: TextStyle(
              fontFamily: 'Gilmer',
              fontSize: 14,
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w300,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,

              disabledBorder: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
                fontFamily: "Gilmer",
                fontWeight: FontWeight.w100,
              ),
              focusColor: Theme.of(context).colorScheme.tertiary,
              // suffixIcon: Icon(widget.suffix, color: Theme.of(context).colorScheme.te),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 2),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 0),
              ),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).hintColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: const IconMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // first 4 boxes in grid
            AspectRatio(
              aspectRatio: 2,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 2,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return const MyBox();
                  },
                ),
              ),
            ),

            // list of previous days
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const MyTile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
