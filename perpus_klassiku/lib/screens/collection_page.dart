import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/collection_item_model.dart';
import '../routes/app_routing.dart';
import '../services/crud_service.dart';
import '../widgets/cover_image.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<CategoryModel> _categories = [];
  List<CollectionItemModel> _items = [];
  int? _selectedCategoryId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load({bool showLoading = true}) async {
    if (showLoading) setState(() => _isLoading = true);
    try {
      final categories = await CrudService.fetchCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        if (_selectedCategoryId != null &&
            !_categories.any(
              (category) => category.id == _selectedCategoryId,
            )) {
          _selectedCategoryId = null;
        }
      });

      final items = await CrudService.fetchItems(
        categoryId: _selectedCategoryId,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted && showLoading) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await CrudService.fetchItems(
        categoryId: _selectedCategoryId,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _editCategory([CategoryModel? category]) async {
    var name = category?.name ?? '';
    var description = category?.description ?? '';
    final formKey = GlobalKey<FormState>();
    final values = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nama kategori'),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Nama kategori wajib diisi.'
                    : null,
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                minLines: 1,
                maxLines: 3,
                onChanged: (value) => description = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(context, {
                'name': name.trim(),
                'description': description.trim(),
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (values == null) return;

    try {
      await CrudService.saveCategory(
        id: category?.id,
        name: values['name']!,
        description: values['description']!,
      );
      await _load(showLoading: false);
      if (mounted) _showMessage('Kategori berhasil disimpan.');
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final confirmed = await _confirmDelete('kategori "${category.name}"');
    if (!confirmed) return;
    try {
      await CrudService.deleteCategory(category.id);
      if (_selectedCategoryId == category.id) _selectedCategoryId = null;
      await _load(showLoading: false);
      if (mounted) _showMessage('Kategori berhasil dihapus.');
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  Future<void> _editItem([CollectionItemModel? item]) async {
    if (_categories.isEmpty) {
      _showMessage('Tambahkan kategori terlebih dahulu.');
      return;
    }
    var title = item?.title ?? '';
    var author = item?.author ?? '';
    var cover = item?.cover ?? '';
    var showCoverPreview = cover.trim().isNotEmpty;
    var lastPage = item?.lastPage.toString() ?? '0';
    final formKey = GlobalKey<FormState>();
    int? categoryId = item?.categoryId ?? _categories.first.id;

    final values = await showDialog<Map<String, Object>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            item == null ? 'Tambah Item Koleksi' : 'Edit Item Koleksi',
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: categoryId,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => categoryId = value),
                    validator: (value) =>
                        value == null ? 'Pilih kategori.' : null,
                  ),
                  TextFormField(
                    initialValue: title,
                    decoration: const InputDecoration(labelText: 'Judul item'),
                    validator: (value) => (value?.trim().isEmpty ?? true)
                        ? 'Judul wajib diisi.'
                        : null,
                    onChanged: (value) => title = value,
                  ),
                  TextFormField(
                    initialValue: author,
                    decoration: const InputDecoration(labelText: 'Penulis'),
                    validator: (value) => (value?.trim().isEmpty ?? true)
                        ? 'Penulis wajib diisi.'
                        : null,
                    onChanged: (value) => author = value,
                  ),
                  TextFormField(
                    initialValue: cover,
                    decoration: const InputDecoration(
                      labelText: 'URL sampul (opsional)',
                      helperText: 'Gunakan URL gambar publik dengan http/https.',
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      final imageUrl = value?.trim() ?? '';
                      if (imageUrl.isEmpty) return null;
                      final uri = Uri.tryParse(imageUrl);
                      if (uri == null ||
                          !['http', 'https'].contains(uri.scheme) ||
                          uri.host.isEmpty) {
                        return 'Masukkan URL gambar http/https yang valid.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      cover = value;
                      setDialogState(() => showCoverPreview = false);
                    },
                  ),
                  if (cover.trim().isNotEmpty) ...[
                    TextButton.icon(
                      onPressed: () {
                        final uri = Uri.tryParse(cover.trim());
                        if (uri == null ||
                            !['http', 'https'].contains(uri.scheme) ||
                            uri.host.isEmpty) {
                          return;
                        }
                        setDialogState(() => showCoverPreview = true);
                      },
                      icon: const Icon(Icons.image_search_outlined),
                      label: const Text('Pratinjau sampul'),
                    ),
                    if (showCoverPreview)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CoverImage(
                          url: cover,
                          width: 90,
                          height: 120,
                          iconSize: 36,
                        ),
                      ),
                  ],
                  TextFormField(
                    initialValue: lastPage,
                    decoration: const InputDecoration(
                      labelText: 'Halaman terakhir dibaca',
                      helperText: 'Isi 0 jika belum mulai membaca.',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final page = int.tryParse(value?.trim() ?? '');
                      if (page == null) {
                        return 'Masukkan nomor halaman yang valid.';
                      }
                      if (page < 0) {
                        return 'Nomor halaman tidak boleh negatif.';
                      }
                      return null;
                    },
                    onChanged: (value) => lastPage = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate() || categoryId == null) {
                  return;
                }
                final parsedLastPage = int.tryParse(lastPage.trim());
                if (parsedLastPage == null) return;
                Navigator.pop(context, {
                  'category_id': categoryId!,
                  'title': title.trim(),
                  'author': author.trim(),
                  'cover': cover.trim(),
                  'last_page': parsedLastPage,
                });
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    if (values == null) return;

    try {
      await CrudService.saveItem(
        id: item?.id,
        categoryId: values['category_id']! as int,
        title: values['title']! as String,
        author: values['author']! as String,
        cover: values['cover']! as String,
        lastPage: values['last_page']! as int,
      );
      await _load(showLoading: false);
      if (mounted) _showMessage('Item koleksi berhasil disimpan.');
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  Future<void> _deleteItem(CollectionItemModel item) async {
    final confirmed = await _confirmDelete('"${item.title}"');
    if (!confirmed) return;
    try {
      await CrudService.deleteItem(item.id);
      await _load(showLoading: false);
      if (mounted) _showMessage('Item koleksi berhasil dihapus.');
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    }
  }

  Future<bool> _confirmDelete(String label) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi hapus'),
            content: Text('Yakin ingin menghapus $label?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _categories.isEmpty && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _categories.isEmpty && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Gagal memuat koleksi: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (_error != null)
          MaterialBanner(
            content: Text('Gagal memuat data: $_error'),
            actions: [
              TextButton(
                onPressed: () => _load(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Kategori'),
            Tab(text: 'Item Koleksi'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildCategoriesTab(), _buildItemsTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: () => _editCategory(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah kategori'),
            ),
          ),
        ),
        Expanded(
          child: _categories.isEmpty
              ? const Center(child: Text('Belum ada kategori.'))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ListTile(
                      title: Text(category.name),
                      subtitle: Text(
                        category.description.isEmpty
                            ? (category.isDefault
                                  ? 'Kategori bawaan'
                                  : 'Kategori milik Anda')
                            : category.description,
                      ),
                      trailing: category.isDefault
                          ? const Icon(Icons.lock_outline)
                          : Wrap(
                              children: [
                                IconButton(
                                  tooltip: 'Edit kategori',
                                  onPressed: () => _editCategory(category),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Hapus kategori',
                                  onPressed: () => _deleteCategory(category),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildItemsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int?>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Filter kategori',
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Semua kategori'),
                    ),
                    ..._categories.map(
                      (category) => DropdownMenuItem<int?>(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                    _loadItems();
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Tambah item',
                onPressed: () => _editItem(),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Text(
                    'Gagal memuat item: $_error',
                    textAlign: TextAlign.center,
                  ),
                )
              : _items.isEmpty
              ? const Center(child: Text('Belum ada item koleksi.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      isThreeLine: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CoverImage(
                          url: item.cover,
                          width: 48,
                          height: 64,
                          iconSize: 28,
                        ),
                      ),
                      title: Text(item.title),
                      subtitle: Text(
                        '${item.author} • ${item.categoryName}\n'
                        'Halaman terakhir: ${item.lastPage}',
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouting.collectionItemDetail,
                        arguments: item,
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'edit') _editItem(item);
                          if (action == 'delete') _deleteItem(item);
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
