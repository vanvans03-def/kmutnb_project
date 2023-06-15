import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/home/screens/category_deals_screen.dart';
import '../../../models/category.dart';
import '../services/home_service.dart';

class TopCategories extends StatefulWidget {
  TopCategories({Key? key}) : super(key: key);

  @override
  _TopCategoriesState createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories> {
  String categoryId = '';
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    getAllCategory(context);
  }

  void navigateToCategoryPage(BuildContext context, String categoryId) {
    Navigator.pushNamed(
      context,
      CategoryDealsScreen.routeName,
      arguments: categoryId,
    );
  }

  void getAllCategory(BuildContext context) async {
    final HomeService homeService = HomeService();
    categories = await homeService.fetchAllCategory(context);
    setState(() {}); // trigger a rebuild to display the loaded categories
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        itemCount: categories.length,
        itemExtent: 75,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                navigateToCategoryPage(context, categories[index].categoryId),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      categories[index].categoryImage,
                      fit: BoxFit.cover,
                      height: 38,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  categories[index].categoryName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
