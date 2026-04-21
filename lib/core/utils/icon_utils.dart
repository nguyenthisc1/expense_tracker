import 'package:flutter/material.dart';

/// Utility class for mapping string icon names to [IconData].
///
/// This mapping aligns with the CategorySeedData definitions
/// for default categories (see features/categories/data/seed/category_seed_data.dart).
abstract final class IconUtils {
  // Supported icon name → IconData mapping.
  // These must match those referenced in CategorySeedData.
  static const Map<String, IconData> _iconMap = {
    'utensils': Icons.restaurant, // Food
    'car': Icons.directions_car, // Transport
    'shoppingBag': Icons.shopping_bag, // Shopping
    'house': Icons.house, // Housing
    'film': Icons.movie, // Entertainment
    'heart': Icons.favorite, // Health
    'zap': Icons.bolt, // Bills (lightning/zap)
    'layoutGrid': Icons.grid_view, // Other (expense/income)
    'banknote': Icons.attach_money, // Salary
    'briefcase': Icons.work, // Freelance
    'gift': Icons.card_giftcard, // Bonus
    // All icons referenced by CategorySeedData are defined.
    // Add more mappings as needed for new categories.
  };

  /// Returns the corresponding [IconData] for a given [iconName].
  /// Returns [Icons.help_outline] (question mark) as fallback
  /// if the key is not found (for data safety).
  static IconData fromName(String iconName) {
    return _iconMap[iconName] ?? Icons.help_outline;
  }
}
