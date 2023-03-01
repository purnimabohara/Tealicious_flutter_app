import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';

import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

import '../../viewmodels/product_viewmodel.dart';
import '../account/account_screen.dart';
import '../favorite/favorite_screen.dart';
import '../home/home_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  PageController pageController = PageController();
  int selectedIndex = 0;
  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;

    });
  }

  _itemTapped(int selectedIndex) {
    pageController.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }


  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  void getInit() {
    try{
      _categoryViewModel.getCategories();
      _productViewModel.getProducts();
      _authViewModel.getFavoritesUser();
      _authViewModel.getMyProducts();
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f4),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: <Widget>[HomeScreen(), FavoriteScreen(), AccountScreen()],
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
          bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Color(0xFFFE53CE) ,
        color: Color(0xFFE0B7C3) ,
        onTap: _itemTapped,
        //IconButtons
        items: <Widget>[
          Icon(Icons.home,color: Colors.black,),
          Icon(Icons.favorite_border,color: Colors.black,),
          Icon(Icons.person,color: Colors.black,)
        
        ],
      ),
     
    );
  }

}