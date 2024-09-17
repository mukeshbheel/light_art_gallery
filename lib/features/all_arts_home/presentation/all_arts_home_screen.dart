import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AllArtsHomeScreen extends StatefulWidget {
  AllArtsHomeScreen({super.key});

  @override
  State<AllArtsHomeScreen> createState() => _AllArtsHomeScreenState();
}

class _AllArtsHomeScreenState extends State<AllArtsHomeScreen> {
  final searchTerm = TextEditingController(text: '');

  List arts = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://api.artic.edu/api/v1/artworks/search?q=${searchTerm.text}&page=$currentPage&query[term][is_public_domain]=true&fields=id,title,image_id,artist_display,thumbnail.width,thumbnail.height,date_display,artist_display,description,short_description&size=10');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        arts = data['data'];
      });
      debugPrint('data: ${response.body}');
    } else {
      debugPrint('statues: ${response.statusCode}');
    }
  }

  void nextPage() {
    setState(() {
      currentPage++;
      fetchData();
    });
  }

  void previousPage() {
    setState(() {
      currentPage--;
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 237, 237),
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: false,
              floating: false,
              backgroundColor: Color(0xFF1E1C32),
              automaticallyImplyLeading: false,
              title: const Text(
                "Light Art Gallery",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              actions: [],
              centerTitle: true,
              elevation: 2,
            )
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: searchTerm,
                      onChanged: (v) {
                        setState(() {});
                      },
                      onSubmitted: (v) {
                        fetchData();
                      },
                      decoration: InputDecoration(
                        hintText: "Search Art",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefix: SizedBox(
                          width: 10,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchTerm.clear();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: searchTerm.text.isNotEmpty
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        ...List.generate(arts.length, (artsIndex) {
                          int crossAxisCount = 2;
                          int mainAxisCount = 2;
                          if (arts[artsIndex]['thumbnail'] != null) {
                            double ratioDouble = arts[artsIndex]['thumbnail']
                                    ['width'] /
                                arts[artsIndex]['thumbnail']['height'];
                            int ratio = ratioDouble.round();
                            debugPrint(
                                "ratio for ${artsIndex + 1} : $ratioDouble");
                            if (ratio == 0) {
                              mainAxisCount = 2;
                              crossAxisCount = 1;
                            } else if (ratio == 1) {
                              mainAxisCount = 2;
                              crossAxisCount = 2;
                            } else if (ratio == 2) {
                              mainAxisCount = 1;
                              crossAxisCount = 2;
                            }
                          }

                          // if (artsIndex == 1) {
                          //   crossAxisCount = 2;
                          //   mainAxisCount = 1;
                          // } else if (artsIndex == 2 || artsIndex == 3) {
                          //   crossAxisCount = 1;
                          //   mainAxisCount = 1;
                          // } else if (artsIndex == 4) {
                          //   crossAxisCount = 4;
                          //   mainAxisCount = 2;
                          // } else if (artsIndex == 5) {
                          //   crossAxisCount = 2;
                          //   mainAxisCount = 1;
                          // } else if (artsIndex == 6) {
                          //   crossAxisCount = 2;
                          //   mainAxisCount = 1;
                          // } else if (artsIndex == 7) {
                          //   crossAxisCount = 2;
                          //   mainAxisCount = 2;
                          // } else if (artsIndex == 8) {
                          //   crossAxisCount = 2;
                          //   mainAxisCount = 2;
                          // } else if (artsIndex == 9) {
                          //   crossAxisCount = 2;
                          //   mainAxisCount = 2;
                          // }
                          return StaggeredGridTile.count(
                            crossAxisCellCount: crossAxisCount,
                            mainAxisCellCount: mainAxisCount,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://www.artic.edu/iiif/2/${arts[artsIndex]['image_id']}/full/200,/0/default.jpg",
                                width: 200,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: currentPage == 1
                            ? null
                            : () {
                                previousPage();
                              },
                        child: Text("< Prev")),
                    Text("Page $currentPage"),
                    ElevatedButton(
                        onPressed: () {
                          nextPage();
                        },
                        child: Text("Next >")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  var imageId;

  Tile({
    super.key,
    this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: imageId == null
          ? SizedBox()
          : Image.network(
              "https://www.artic.edu/iiif/2/$imageId/full/200,/0/default.jpg",
              fit: BoxFit.cover,
            ),
    );
  }
}
