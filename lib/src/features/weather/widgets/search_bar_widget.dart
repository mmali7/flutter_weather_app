import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart'; // For localization

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return TextField(
      controller: searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: l10n.searchCityHint,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onSubmitted: onSearch,
    );
  }
}
