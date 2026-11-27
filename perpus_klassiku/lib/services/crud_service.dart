import '../constants/api_constant.dart';
import '../models/category_model.dart';
import '../models/collection_item_model.dart';
import 'api_client.dart';

class CrudService {
  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await ApiClient.request(
      'GET',
      ApiConstant.categoriesPath,
    ).timeout(ApiConstant.requestTimeout);
    return (response['data'] as List<dynamic>)
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<CategoryModel> saveCategory({
    int? id,
    required String name,
    required String description,
  }) async {
    final response = await ApiClient.request(
      id == null ? 'POST' : 'PUT',
      id == null
          ? ApiConstant.categoriesPath
          : '${ApiConstant.categoriesPath}/$id',
      body: {'name': name, 'description': description},
    ).timeout(ApiConstant.requestTimeout);
    return CategoryModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  static Future<void> deleteCategory(int id) async {
    await ApiClient.request(
      'DELETE',
      '${ApiConstant.categoriesPath}/$id',
    ).timeout(ApiConstant.requestTimeout);
  }

  static Future<List<CollectionItemModel>> fetchItems({int? categoryId}) async {
    final response = await ApiClient.request(
      'GET',
      ApiConstant.collectionItemsPath,
      queryParameters: categoryId == null
          ? null
          : {'category_id': categoryId.toString()},
    ).timeout(ApiConstant.requestTimeout);
    return (response['data'] as List<dynamic>)
        .map(
          (json) => CollectionItemModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  static Future<CollectionItemModel> saveItem({
    int? id,
    required int categoryId,
    required String title,
    required String author,
    required String cover,
    required int lastPage,
  }) async {
    final response = await ApiClient.request(
      id == null ? 'POST' : 'PUT',
      id == null
          ? ApiConstant.collectionItemsPath
          : '${ApiConstant.collectionItemsPath}/$id',
      body: {
        'category_id': categoryId,
        'title': title,
        'author': author,
        'cover': cover,
        'last_page': lastPage,
      },
    ).timeout(ApiConstant.requestTimeout);
    return CollectionItemModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  static Future<void> deleteItem(int id) async {
    await ApiClient.request(
      'DELETE',
      '${ApiConstant.collectionItemsPath}/$id',
    ).timeout(ApiConstant.requestTimeout);
  }
}
