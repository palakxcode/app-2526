// DASHBOARD LAYOUT
import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final String userName;
  final String description;
  final List<String> cardTitles;

  DashboardLayout({
    required this.userName,
    required this.description,
    required this.cardTitles,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Pastel theme colors
    final pastelPink = Color(0xFFFFD1DC);
    final pastelBlue = Color(0xFFB5DEFF);
    final pastelMint = Color(0xFFAFE1AF);
    final pastelLavender = Color(0xFFE6E6FA);
    final pastelPeach = Color(0xFFFFDAB9);
    final pastelYellow = Color(0xFFFFFACD);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [pastelLavender, Colors.white],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Text
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: pastelBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Hello, $userName',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Description card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: pastelMint,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, size: 28, color: Colors.black54),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Cards Grid
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: width / (height / 3),
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cardTitles.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: _getCardColor(index),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getCardColor(index),
                            _getCardColor(index).withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getCardIcon(index),
                                size: 30,
                                color: Colors.black54,
                              ),
                              SizedBox(height: 10),
                              Text(
                                cardTitles[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(int index) {
    List<Color> colors = [
      Color(0xFFFFD1DC), // Pastel Pink
      Color(0xFFB5DEFF), // Pastel Blue
      Color(0xFFAFE1AF), // Pastel Mint
      Color(0xFFE6E6FA), // Pastel Lavender
      Color(0xFFFFDAB9), // Pastel Peach
      Color(0xFFFFFACD), // Pastel Yellow
    ];
    return colors[index % colors.length];
  }

  IconData _getCardIcon(int index) {
    List<IconData> icons = [
      Icons.dashboard,
      Icons.event,
      Icons.people,
      Icons.announcement,
      Icons.school,
      Icons.business,
    ];
    return icons[index % icons.length];
  }
}
