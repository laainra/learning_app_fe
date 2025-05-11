import 'package:finbedu/widgets/CustomHeader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_providers.dart'; // Import your CategoryProvider

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController =
      TextEditingController(); // Controller for new category input

  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(hintText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final categoryName = _categoryController.text.trim();
                if (categoryName.isNotEmpty) {
                  await Provider.of<CategoryProvider>(
                    context,
                    listen: false,
                  ).addCategory(categoryName);
                  _categoryController.clear(); // Clear the input field
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: const CustomHeader(title: 'All Categories'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Refresh for search
              },
            ),
            const SizedBox(height: 20),

            // Button to add new category
            ElevatedButton(
              onPressed: _showAddCategoryDialog,
              child: const Text('Add Category'),
            ),
            const SizedBox(height: 20),

            // Grid Categories
            Expanded(
              child: GridView.builder(
                itemCount: categoryProvider.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  final category = categoryProvider.categories[index];
                  final query = _searchController.text.toLowerCase();

                  if (query.isNotEmpty &&
                      !category.name.toLowerCase().contains(query)) {
                    return const SizedBox.shrink(); // Skip this item if it doesn't match the search
                  }

                  return CategoryCard(
                    title: category.name,
                    icon: Icons.category,
                  ); // Use a default icon
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          // Navigate to category details or perform an action
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.blueAccent),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
