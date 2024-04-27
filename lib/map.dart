import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

void launchMap(BuildContext context) async {
  // The latitude and longitude for the location you want to display
  final double latitude = 37.422;
  final double longitude = -122.084;

  // The URL for launching the maps application with the specified location
  final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  // Launch the maps application
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // If the URL can't be launched, show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to open Google Maps'),
      ),
    );
  }
}

