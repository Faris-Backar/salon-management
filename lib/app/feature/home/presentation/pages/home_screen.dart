import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_strings.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/bill_section.dart';
import 'package:salon_management/app/feature/home/presentation/widgets/side_bar_widget.dart';
import 'package:salon_management/gen/assets.gen.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> barbershopServices = [
      {
        "id": 1,
        "name": "Men's Haircut",
        "duration": "30 min",
        "price": 25.00,
        "description": "Classic haircut with styling.",
      },
      {
        "id": 2,
        "name": "Beard Trim",
        "duration": "15 min",
        "price": 15.00,
        "description": "Precision beard trimming and shaping.",
      },
      {
        "id": 3,
        "name": "Hot Towel Shave",
        "duration": "30 min",
        "price": 30.00,
        "description":
            "Traditional straight razor shave with hot towel treatment.",
      },
      {
        "id": 4,
        "name": "Haircut & Beard Trim",
        "duration": "45 min",
        "price": 40.00,
        "description": "Complete grooming package for hair and beard.",
      },
      {
        "id": 5,
        "name": "Kids' Haircut",
        "duration": "20 min",
        "price": 20.00,
        "description": "Gentle and fun haircut for children under 12.",
      },
      {
        "id": 6,
        "name": "Scalp Massage",
        "duration": "20 min",
        "price": 18.00,
        "description":
            "Relaxing scalp massage to relieve stress and improve circulation.",
      },
      {
        "id": 7,
        "name": "Hair Wash & Style",
        "duration": "15 min",
        "price": 12.00,
        "description": "Refreshing hair wash followed by professional styling.",
      },
      {
        "id": 8,
        "name": "Eyebrow Shaping",
        "duration": "10 min",
        "price": 10.00,
        "description": "Clean and shape eyebrows with precision.",
      },
    ];

    final List<Map<String, dynamic>> barbershopEmployees = [
      {
        "id": 1,
        "name": "John Smith",
        "position": "Senior Barber",
        "experience": "10 years",
        "specialty": "Classic haircuts & beard styling",
        "rating": 4.9,
        "image": "assets/images/employees/john_smith.png",
      },
      {
        "id": 2,
        "name": "Emma Johnson",
        "position": "Stylist",
        "experience": "7 years",
        "specialty": "Modern fades & scalp treatments",
        "rating": 4.8,
        "image": "assets/images/employees/emma_johnson.png",
      },
      {
        "id": 3,
        "name": "David Martinez",
        "position": "Master Barber",
        "experience": "15 years",
        "specialty": "Straight razor shaves & hair tattoos",
        "rating": 5.0,
        "image": "assets/images/employees/david_martinez.png",
      },
      {
        "id": 4,
        "name": "Sophia Lee",
        "position": "Hair Stylist",
        "experience": "6 years",
        "specialty": "Creative styling & kids' haircuts",
        "rating": 4.7,
        "image": "assets/images/employees/sophia_lee.png",
      },
      {
        "id": 5,
        "name": "Michael Brown",
        "position": "Junior Barber",
        "experience": "3 years",
        "specialty": "Basic haircuts & beard trims",
        "rating": 4.5,
        "image": "assets/images/employees/michael_brown.png",
      },
      {
        "id": 6,
        "name": "Olivia Davis",
        "position": "Hair & Scalp Specialist",
        "experience": "8 years",
        "specialty": "Scalp treatments & hair coloring",
        "rating": 4.8,
        "image": "assets/images/employees/olivia_davis.png",
      },
      {
        "id": 7,
        "name": "James Wilson",
        "position": "Senior Barber",
        "experience": "12 years",
        "specialty": "Hot towel shaves & executive cuts",
        "rating": 4.9,
        "image": "assets/images/employees/james_wilson.png",
      },
      {
        "id": 8,
        "name": "Isabella Taylor",
        "position": "Grooming Specialist",
        "experience": "5 years",
        "specialty": "Facial treatments & eyebrow shaping",
        "rating": 4.6,
        "image": "assets/images/employees/isabella_taylor.png",
      },
      {
        "id": 9,
        "name": "William Anderson",
        "position": "Master Barber",
        "experience": "14 years",
        "specialty": "Precision fades & afro-textured hair",
        "rating": 4.9,
        "image": "assets/images/employees/william_anderson.png",
      },
      {
        "id": 10,
        "name": "Mia Harris",
        "position": "Junior Stylist",
        "experience": "2 years",
        "specialty": "Basic cuts & hair wash styling",
        "rating": 4.4,
        "image": "assets/images/employees/mia_harris.png",
      },
    ];

    return Scaffold(
      appBar: Responsive.isMobile() ? AppBar() : null,
      drawer: Responsive.isMobile()
          ? SidebarWidget(
              isExpanded: true,
              onToggleExpand: () {},
            )
          : null,
      body: Responsive.isMobile()
          ? SizedBox.shrink()
          : Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: barbershopServices.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemBuilder: (context, index) => Card(
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              barbershopServices[index]["name"],
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              AppStrings.indianRupee +
                                  barbershopServices[index]["price"].toString(),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: barbershopEmployees.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemBuilder: (context, index) => Card(
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              barbershopEmployees[index]["name"],
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              AppStrings.indianRupee +
                                  barbershopEmployees[index]["rating"]
                                      .toString(),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: BillSection(
                      selectedServices: [
                        {
                          "id": 8,
                          "name": "Eyebrow Shaping",
                          "duration": "10 min",
                          "price": 10.00,
                          "description":
                              "Clean and shape eyebrows with precision.",
                        },
                      ],
                      shopName: "Bellozee",
                      shopLogo: Assets.images.logo.path,
                      contactNumber: "+919087654321",
                      email: "info@bellozee",
                      address: "address",
                      slogan: ""),
                ),
              ],
            ),
    );
  }
}
