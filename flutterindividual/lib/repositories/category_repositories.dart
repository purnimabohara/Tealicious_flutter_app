import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Honeydew-flavoured", status: "active", imageUrl: "https://www.honestfoodtalks.com/wp-content/uploads/2021/03/bubble-tea-in-asia.jpg"),
        CategoryModel(categoryName: "Milk-flavoured", status: "active", imageUrl: "https://homemadehooplah.com/wp-content/uploads/2021/05/boba-milk-tea-1.jpg"),
        CategoryModel(categoryName: "Fruit-mix", status: "active", imageUrl: "https://cdn.shopify.com/s/files/1/2567/0132/products/1644274576260.jpg?v=1667844011"),
        CategoryModel(categoryName: "Oreo-Shake", status: "active", imageUrl: "https://tyberrymuch.com/wp-content/uploads/2022/07/oreo-milk-tea-boba-front-recipe-735x919.jpg"),
        CategoryModel(categoryName: "Multi-flavoured", status: "active", imageUrl: "https://cdn.sprinklebakes.com/media/2021/06/Coconut-Butterfly-Pea-Flower-Boba-Tea-2.jpg"),
      ];
  }


}