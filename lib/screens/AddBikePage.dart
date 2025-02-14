import 'package:elbisikleta/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class AddBikePage extends StatefulWidget {
  final String ownerId;


  const AddBikePage({Key? key, required this.ownerId}) : super(key: key);

  @override
  _AddBikePageState createState() => _AddBikePageState();
}

class _AddBikePageState extends State<AddBikePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costPerHourController = TextEditingController();
  final TextEditingController _featuresController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String bikeRefId = "NONE";

  bool _isAvailable = true;
  bool _isLoading = false;

  // photo urls
  List<String> photoUrls = [];
  List<String> chosenPhotoUrls = [];

  Future<void> _submitBike() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      // Create a new document reference - Firebase will generate the ID
      final bikeRef = FirebaseFirestore.instance.collection('bikes').doc();
      
      bikeRefId = bikeRef.id;

      // upload the chosen photo urls
      final storageService = Provider.of<StorageService>(context, listen: false);
                            
      // upload image
      photoUrls = await storageService.uploadImages(chosenPhotoUrls,bikeRefId);

      // Create bike data
      final bikeData = {
        'bikeId': bikeRef.id, // Using Firebase's auto-generated ID
        'ownerId': widget.ownerId,
        'modelName': _modelNameController.text,
        'description': _descriptionController.text,
        'photoUrls': photoUrls,
        'costPerHour': double.parse(_costPerHourController.text),
        'isAvailable': _isAvailable,
        'location': _locationController.text.isNotEmpty ? _locationController.text : null,
        'features': _featuresController.text.isNotEmpty 
          ? _featuresController.text.split(',').map((f) => f.trim()).toList() 
          : [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await bikeRef.set(bikeData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bike added successfully!')),
      );
      
      Navigator.pop(context); // Return to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bike: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Your Bike')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _modelNameController,
                    decoration: InputDecoration(
                      labelText: 'Bike Model/Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty 
                      ? 'Please enter bike model name' 
                      : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                      ? 'Please enter bike description'
                      : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _costPerHourController,
                    decoration: InputDecoration(
                      labelText: 'Cost per Hour',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cost per hour';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _featuresController,
                    decoration: InputDecoration(
                      labelText: 'Features (comma-separated, Optional)',
                      border: OutlineInputBorder(),
                      hintText: 'E.g. Mountain Bike, Gears, Suspension',
                    ),
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Bike Availability'),
                    subtitle: Text('Is the bike currently available for rent?'),
                    value: _isAvailable,
                    onChanged: (bool value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 100,
                    child: ElevatedButton(
                          onPressed: () async {
                            final storageService = Provider.of<StorageService>(context, listen: false);
                            // upload image
                            chosenPhotoUrls = await storageService.pickImages();
                          },
                          child: const Text('Upload Image'),
                        ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitBike,
                    child: Text('Add Bike'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    _descriptionController.dispose();
    _costPerHourController.dispose();
    _featuresController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}