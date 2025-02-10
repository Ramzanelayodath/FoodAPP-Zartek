
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/customWidget/CustomWidgets.dart';
import 'package:foodapp/homePage/Data/MenuResponse.dart';
import '../utils/Strings.dart';
import 'package:badges/badges.dart' as badges;

import 'HomePageCubit.dart';

class HomePage extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<HomePage> with TickerProviderStateMixin,WidgetsBindingObserver {
  late TabController _tabController;
  List<Category> listMenu = [];
  int totalCartItem = 0;
  String username = "";
  String userFirebaseId = "";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomePageCubit>(context).getMenu();
    BlocProvider.of<HomePageCubit>(context).getUserDetails();
    return BlocConsumer<HomePageCubit, HomePageState>(
      listener: (context, state) {
        handleListener(state);
      },
      builder: (context, state) {
        return body(state);
      },
      buildWhen: (previousState, state) {
        return handleBuildWhen(state);
      },
      listenWhen: (previousState,state){
         return listenWhen(state);
      },
    );
  }

  Widget body(HomePageState state) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          badges.Badge(
            badgeContent: Text(
              totalCartItem.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            showBadge: totalCartItem > 0,
            position: badges.BadgePosition.topEnd(top: 5, end: 5),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(username, style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(userFirebaseId, style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(Strings.strLogOut),
              onTap: () {
                BlocProvider.of<HomePageCubit>(context).logout();
              },
            ),
          ],
        ),
      ),
      body: state is MenuLoading ? loading() : menuList(),
    );
  }

  Widget loading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget menuList() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: listMenu.map((e) => Tab(text: e.name)).toList(),
          isScrollable: true,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: listMenu.map((category) {
              return ListView.builder(
                itemCount: category.dishes.length,
                itemBuilder: (context, index) {
                  final dish = category.dishes[index];
                  return listItem(dish);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget listItem(Dish dish) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${dish.price} ${Strings.currency}"),
                        Text('${dish.calories}  ${Strings.strCal}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      dish.description,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 125,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: SizedBox(
                                width: 24,
                                child: Center(
                                  child: Icon(Icons.remove, color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                if(dish.qty >0) {
                                  BlocProvider.of<HomePageCubit>(context)
                                      .onDecrement(dish);
                                }
                              },
                            ),
                            Text(
                              dish.qty.toString(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              child: Icon(Icons.add, color: Colors.white),
                              onTap: () {
                                BlocProvider.of<HomePageCubit>(context).onIncrement(dish);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Visibility(
                      visible: dish.customizationsAvailable,
                      child: Text(
                        Strings.strCustomization,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/food.png',
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleListener(HomePageState state) {
    switch (state) {
      case MenuLoaded _:
        listMenu = state.listMenu;
        totalCartItem = state.totalCartItemQty;
        if (_tabController.length != listMenu.length) {
          _tabController = TabController(length: listMenu.length, vsync: this);
        }
        break;
      case MenuDownloadedError _:
        CustomWidgets.errorDialog(state.error, context);
        break;
      case UserDetails _:
        username = state.userName;
        userFirebaseId = state.userFirebaseId;
        break;
      case LogoutSuccess _:
        Navigator.pushReplacementNamed(context, "/login");
        break;


    }
  }

  bool handleBuildWhen(HomePageState state) {
    return state is MenuLoading || state is MenuLoaded || state is UserDetails;
  }

  bool listenWhen(HomePageState state){
     return state is MenuLoaded || state is LogoutSuccess || state is UserDetails;
  }
}
