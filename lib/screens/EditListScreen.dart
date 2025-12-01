import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/auth_service.dart';
import '../utils/list_service.dart';

class EditListScreen extends StatefulWidget {
  final String listId; // Pass this when navigating

  const EditListScreen({super.key, required this.listId});

  @override
  State<EditListScreen> createState() => _EditListScreenState();
}

class _EditListScreenState extends State<EditListScreen> {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController(text: '1');
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _selectedUnit = 'lbs';
  final List<String> _unitOptions = ['lbs', 'kg', 'g', 'oz'];

  Map<String, dynamic>? listDetails;
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoadingList = true;
  bool isLoadingItems = true;
  String errorMessage = '';
  String listCode = '';
  bool isCreator = false;
  DateTime lastRefreshed = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadListDetails();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _listNameController.dispose();
    _itemController.dispose();
    _qtyController.dispose();
    _weightController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadListDetails() async {
    print('🔵 EDIT LIST: Loading list details for ID: ${widget.listId}');
    setState(() {
      isLoadingList = true;
      isLoadingItems = true;
      errorMessage = '';
    });

    try {
      final details = await ListService.getListDetails(widget.listId);
      print('✅ List details loaded: ${details['name']}');
      print('📋 Items: ${details['items'].length}');

      setState(() {
        listDetails = details;
        _listNameController.text = details['name'] ?? 'List Name';
        listCode = details['code'] ?? '';
        isCreator = details['isCreator'] ?? false;
        allItems = List<Map<String, dynamic>>.from(details['items'] ?? []);
        _filterItems();
        isLoadingList = false;
        isLoadingItems = false;
        lastRefreshed = DateTime.now();
      });
    } catch (e) {
      print('❌ Failed to load list: $e');
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoadingList = false;
        isLoadingItems = false;
      });
    }
  }

  void _filterItems() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems.where((item) {
        // Filter by search
        final matchesSearch = searchQuery.isEmpty ||
            item['name'].toString().toLowerCase().contains(searchQuery);

        // Filter by purchase status
        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Purchased' && item['purchased'] == true) ||
            (_selectedFilter == 'Unpurchased' && item['purchased'] != true);

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  Future<void> _handleRenameList() async {
    final newName = _listNameController.text.trim();
    if (newName.isEmpty || newName == listDetails?['name']) return;

    print('🔵 Renaming list to: $newName');

    try {
      await ListService.updateList(
        listId: widget.listId,
        name: newName,
      );
      print('✅ List renamed successfully');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('List renamed successfully!'),
          backgroundColor: Color(0xFF00C676),
        ),
      );

      await _loadListDetails(); // Refresh
    } catch (e) {
      print('❌ Failed to rename list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRenameDialog() {
    final tempController = TextEditingController(text: _listNameController.text);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101F18),
          title: const Text('Rename List', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: tempController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter new list name',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00C676)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _listNameController.text = tempController.text.trim();
                });
                Navigator.pop(context);
                _handleRenameList();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDeleteList() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF101F18),
        title: const Text('Delete List', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this list? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    print('🔵 Deleting list: ${widget.listId}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00C676)),
      ),
    );

    try {
      await ListService.deleteList(widget.listId);
      print('✅ List deleted successfully');

      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('List deleted successfully'),
          backgroundColor: Color(0xFF00C676),
        ),
      );

      Navigator.pushReplacementNamed(context, '/myLists');
    } catch (e) {
      print('❌ Failed to delete list: $e');
      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAddItem() async {
    final itemName = _itemController.text.trim();
    if (itemName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final quantity = int.tryParse(_qtyController.text.trim()) ?? 1;
    final weight = double.tryParse(_weightController.text.trim());

    print('🔵 Adding item: $itemName (qty: $quantity)');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00C676)),
      ),
    );

    try {
      await ListService.addItem(
        listId: widget.listId,
        name: itemName,
        quantity: quantity,
        weight: weight,
        weightUnit: weight != null ? _selectedUnit : null,
      );
      print('✅ Item added successfully');

      Navigator.pop(context); // Close loading

      // Clear form
      _itemController.clear();
      _qtyController.text = '1';
      _weightController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$itemName added to list'),
          backgroundColor: const Color(0xFF00C676),
        ),
      );

      await _loadListDetails(); // Refresh list
    } catch (e) {
      print('❌ Failed to add item: $e');
      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleTogglePurchased(String itemId, bool currentStatus) async {
    print('🔵 Toggling purchased status for item: $itemId');

    try {
      await ListService.updateItem(
        listId: widget.listId,
        itemId: itemId,
        purchased: !currentStatus,
      );
      print('✅ Item status updated');

      await _loadListDetails(); // Refresh
    } catch (e) {
      print('❌ Failed to update item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDeleteItem(String itemId, String itemName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF101F18),
        title: const Text('Delete Item', style: TextStyle(color: Colors.white)),
        content: Text(
          'Delete "$itemName"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    print('🔵 Deleting item: $itemId');

    try {
      await ListService.deleteItem(listId: widget.listId, itemId: itemId);
      print('✅ Item deleted');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item deleted'),
          backgroundColor: Color(0xFF00C676),
        ),
      );

      await _loadListDetails(); // Refresh
    } catch (e) {
      print('❌ Failed to delete item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: listCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code $listCode copied to clipboard!'),
        backgroundColor: const Color(0xFF00C676),
      ),
    );
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  Widget _buildFilterChip(String label) {
    final bool selected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
          _filterItems();
        });
      },
      backgroundColor: const Color(0xFF101F18),
      selectedColor: const Color(0xFF00C676),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF151F1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  String _getTimeSinceRefresh() {
    final diff = DateTime.now().difference(lastRefreshed);
    if (diff.inSeconds < 60) return '${diff.inSeconds} seconds ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    return '${diff.inHours} hours ago';
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF050F0B);
    const cardBackground = Color(0xFF101F18);
    const accentGreen = Color(0xFF00C676);
    const accentRed = Color(0xFFEA4335);

    final textPrimary = Colors.white.withOpacity(0.95);
    const textSecondary = Colors.white70;
    final greetingName = AuthService.firstName ?? 'there';

    if (isLoadingList) {
      return Scaffold(
        backgroundColor: background,
        body: const Center(
          child: CircularProgressIndicator(color: accentGreen),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadListDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final purchasedCount = allItems.where((item) => item['purchased'] == true).length;
    final totalCount = allItems.length;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'images/SharedCartLogo.png',
                              height: 32,
                              width: 32,
                              errorBuilder: (context, _, __) =>
                              const Icon(Icons.shopping_cart, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'SharedCart',
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _handleLogout,
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Hello, $greetingName!',
                        style: const TextStyle(color: textSecondary, fontSize: 14),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/myLists');
                        },
                        icon: const Icon(Icons.list, size: 18, color: Colors.white),
                        label: const Text('My Lists', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // BACK TO LISTS
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/myLists');
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              label: const Text('Back to Lists', style: TextStyle(color: Colors.white70)),
            ),

            const SizedBox(height: 8),

            // LIST DETAILS CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LIST',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showRenameDialog,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _listNameController.text,
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.edit, size: 18, color: Colors.white70),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C2A22),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _copyCodeToClipboard,
                        child: const Text('Copy Code'),
                      ),
                      const SizedBox(width: 8),
                      if (isCreator)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _handleDeleteList,
                          child: const Text('Delete List'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to rename',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'List code - $listCode',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // PROGRESS CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PROGRESS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$purchasedCount / $totalCount items purchased',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Unpurchased'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Purchased'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF151F1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Last refreshed ${_getTimeSinceRefresh()}',
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ADD ITEM CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD ITEM',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ITEM',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _itemController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _fieldDecoration('e.g., Almond milk'),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'QTY',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _qtyController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: _fieldDecoration('1'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'WEIGHT',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _weightController,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              style: const TextStyle(color: Colors.white),
                              decoration: _fieldDecoration('Optional'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'UNIT',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF151F1A),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedUnit,
                                  dropdownColor: const Color(0xFF151F1A),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white70),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  items: _unitOptions
                                      .map(
                                        (u) => DropdownMenuItem<String>(
                                      value: u,
                                      child: Text(u),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _selectedUnit = value);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _handleAddItem,
                      child: const Text('Add Item', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ITEMS LIST
            if (isLoadingItems)
              Container(
                padding: const EdgeInsets.all(32),
                child: const Center(
                  child: CircularProgressIndicator(color: accentGreen),
                ),
              )
            else if (filteredItems.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
                child: Center(
                  child: Text(
                    allItems.isEmpty
                        ? 'No items in this list yet. Add one above!'
                        : 'No items match your search or filter.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...filteredItems.map((item) {
                final isPurchased = item['purchased'] == true;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isPurchased
                          ? accentGreen.withOpacity(0.3)
                          : Colors.white24,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Checkbox
                      Checkbox(
                        value: isPurchased,
                        activeColor: accentGreen,
                        onChanged: (_) => _handleTogglePurchased(
                          item['_id'],
                          isPurchased,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] ?? 'Unknown',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: isPurchased
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Qty: ${item['quantity'] ?? 1}' +
                                  (item['weight'] != null
                                      ? ' • ${item['weight']} ${item['weightUnit']}'
                                      : ''),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
// Delete button
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _handleDeleteItem(
                          item['_id'],
                          item['name'],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            const SizedBox(height: 24),

            // FOOTER
            const Column(
              children: [
                Text(
                  '© 2025 SharedCart. All rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}