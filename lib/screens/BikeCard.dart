import 'package:elbisikleta/models/bike_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BikeCard extends StatelessWidget {
  final BikeModel bike;

  const BikeCard({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bike.photoUrls.isNotEmpty)
              SizedBox(
                height: 100,
                child: PageView.builder(
                  itemCount: bike.photoUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      bike.photoUrls[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    );
                  },
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bike.modelName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bike.isAvailable ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          bike.isAvailable ? 'Available' : 'Not Available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${bike.costPerHour.toStringAsFixed(2)}/hour',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(bike.description),
                  if (bike.location != null) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16),
                        SizedBox(width: 4),
                        Text(bike.location!),
                      ],
                    ),
                  ],
                  if (bike.features != null && bike.features!.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: bike.features!.map((feature) => Chip(
                        label: Text(feature),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}