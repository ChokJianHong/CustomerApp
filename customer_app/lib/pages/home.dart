import 'package:customer_app/API/banner.dart';
import 'package:customer_app/API/firebase_api.dart';
import 'package:customer_app/API/getCustOrder.dart';
import 'package:customer_app/assets/components/appbar.dart';
import 'package:customer_app/assets/components/jobcard.dart';
import 'package:customer_app/assets/components/navbar.dart';
import 'package:customer_app/assets/models/OrderModel.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Request_details.dart';
import 'package:customer_app/pages/messages.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final CustomerOrder customerOrder = CustomerOrder();
  final FirebaseApi firebaseapi = FirebaseApi();
  late String customerId;
  late Future<List<OrderModel>> _latestOrderFuture;
  late Future<List<String>> _bannerImagesFuture;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String formatDateTime(String utcDateTime) {
    try {
      DateTime parsedDate = DateTime.parse(utcDateTime);
      DateTime localDate = parsedDate.toLocal();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(localDate);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      customerId = decodedToken['userId'].toString();
    } catch (error) {
      print('Error decoding token: $error');
      customerId = 'default';
    }
    _latestOrderFuture = customerId.isNotEmpty
        ? customerOrder.getCustomerOrders(widget.token, customerId)
        : Future.value([]);
    firebaseapi.initNotifications(widget.token, customerId);

    _bannerImagesFuture = fetchBannerImages(widget.token);
  }

  Future<List<String>> fetchBannerImages(String token) async {
    try {
      List<Map<String, dynamic>> banners =
          await BannerService.fetchBanners(token);
      return banners.map((banner) => banner['banner_img'] as String).toList();
    } catch (e) {
      print("Error fetching banners: $e");
      return [];
    }
  }

  Future<Image> _loadImage(String imageUrl) async {
    final image = Image.network(imageUrl);
    await precacheImage(
        image.image, context); // Cache the image to retrieve its size
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        token: widget.token,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              _buildServiceHours(),
              SizedBox(height: size.height * 0.02),
              _buildCurrentOrders(),
              SizedBox(height: size.height * 0.02),
              Center(
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder<List<String>>(
                      future: _bannerImagesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          List<String> bannerUrls = snapshot.data!;

                          return CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true, // Enable auto-play
                              enlargeCenterPage:
                                  true, // Enlarge the center image
                              aspectRatio:
                                  1.0, // Directly use the aspect ratio value
                              viewportFraction:
                                  1.0, // Ensure images fill the entire container
                            ),
                            items: bannerUrls.map((imageUrl) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return FutureBuilder<Image>(
                                    future: _loadImage(imageUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        return SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: size.height * 0.2,
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: size.height * 0.2,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  );
                                },
                              );
                            }).toList(),
                          );
                        } else {
                          return const Center(
                              child: Text('No banners available.'));
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }

  // Build Service Hours Section
  Widget _buildServiceHours() {
    return Card(
      color: AppColors.lightTeal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Hours',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceDayColumn(
                    'Monday - Friday', '9:00 A.M. to 5:00 P.M.'),
                const SizedBox(height: 10),
                _buildServiceDayColumn(
                    'Saturday - Sunday', '9:00 A.M. to 12:00 P.M.'),
                const SizedBox(height: 10),
                _buildServiceDayColumn('Public Holiday', 'OFF'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Service Day Column Helper
  Widget _buildServiceDayColumn(String day, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          time,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        
      ],
    );
  }

  // Build Current Orders Section
  Widget _buildCurrentOrders() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Orders',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<OrderModel>>(
            future: _latestOrderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final List<OrderModel> latestOrders = snapshot.data!;
                final ongoingOrders = latestOrders
                    .where((order) => order.orderStatus == 'ongoing')
                    .toList();

                if (ongoingOrders.isEmpty) {
                  return const Text(
                    'No ongoing orders.',
                    style: TextStyle(color: Colors.white),
                  );
                }

                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ongoingOrders.length,
                    itemBuilder: (context, index) {
                      final OrderModel order = ongoingOrders[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestDetails(
                                orderId: order.orderId.toString(),
                                token: widget.token,
                              ),
                            ),
                          );
                        },
                        child: JobCard(
                          name: order.problemType,
                          description: order.orderDetail,
                          status: order.orderStatus,
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
