import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewBikePage extends StatefulWidget {
  final String bikeId;
  
  const ViewBikePage({Key? key, required this.bikeId}) : super(key: key);

  @override
  State<ViewBikePage> createState() => _ViewBikePageState();
}

class _ViewBikePageState extends State<ViewBikePage> {
  late Future<DocumentSnapshot> _bikeFuture;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _bikeFuture = _fetchBikeDetails();
  }

  Future<DocumentSnapshot> _fetchBikeDetails() {
    return FirebaseFirestore.instance
        .collection('bikes')
        .doc(widget.bikeId)
        .get();
  }

  Future<void> _refreshBikeDetails() async {
    setState(() {
      _bikeFuture = _fetchBikeDetails();
    });
  }

  Widget _buildImageCarousel(List<String> images) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                );
              },
            );
          }).toList(),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureChip(String feature) {
    return Chip(
      label: Text(feature),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _bikeFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Bike not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final List<String> photoUrls = (data['photoUrls'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? [];
              
          final List<String> features = (data['features'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? [];

          final String name = data['modelName']?.toString() ?? 'No name';
          final String description = data['description']?.toString() ?? 'No description';
          final String price = data["costPerHour"] != null
            ? 'P${data["costPerHour"].toStringAsFixed(2)}/hour'
            : '0';
          final String ownerId = data['ownerId']?.toString() ?? '';

          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          // check if the current user is the owner of the bike
          final isOwner = currentUserId == data['ownerId'];

          return RefreshIndicator(
            onRefresh: _refreshBikeDetails,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      radius: 124,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  Positioned(
                    top: 64,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 240,
                      child: photoUrls.isNotEmpty
                          ? _buildImageCarousel(photoUrls)
                          : Center(child: Text('No photos available')),
                    )
                  ),
                  Positioned(
                    top: 320,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mag-bike na!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            Text(
                              price.toString(),
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )
                              )
                          ],
                        ),
                        SizedBox(
                          height: 16
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 16
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Features",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: features.map((feature) {
                                    return _buildFeatureChip(feature);
                                  }).toList(),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primaryContainer), shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            "Rent",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          )
                        )
                      )
                    )
                  ),
                  Positioned(
                    top: 32,
                    left: 16,
                    child: Container(
                      height: 48,
                      width: 48,
                      child: Card(
                        elevation: 8,
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              print("Back button pressed");
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              )
            )

          );
        },
      );
  }
}