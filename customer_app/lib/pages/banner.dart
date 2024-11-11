import 'package:customer_app/API/banner.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerPage extends StatefulWidget {
  final String token; // Pass token to authenticate API request

  const BannerPage({Key? key, required this.token}) : super(key: key);

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  late Future<List<Map<String, dynamic>>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the banners using the service
    _bannersFuture = BannerService.fetchBanners(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FutureBuilder to fetch and display banners
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _bannersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> banners = snapshot.data!;

                  if (banners.isEmpty) {
                    return const Center(child: Text('No banners available.'));
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      viewportFraction: 1.0,
                    ),
                    items: banners.map((banner) {
                      // Get the banner image URL and title from the JSON data
                      String imageUrl = banner['banner_img'];
                      String bannerTitle = banner['banner_title'];

                      return Builder(
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              // Row to display banner image with title below
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Check if the banner has an image and display it
                                  if (imageUrl.isNotEmpty)
                                    Flexible(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.network(
                                          imageUrl,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Text(
                                                "Image not available");
                                          },
                                        ),
                                      ),
                                    )
                                  else
                                    const Text("No Image Available"),
                                ],
                              ),
                              const SizedBox(
                                  height: 8.0), // Space between image and title
                              // Banner Title
                              Text(
                                bannerTitle,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
