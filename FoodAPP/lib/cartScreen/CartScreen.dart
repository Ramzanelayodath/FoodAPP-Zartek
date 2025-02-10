


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/cartScreen/CartCubit.dart';
import '../localDb/Cart.dart';
import '../utils/Strings.dart';

class CartScreen extends StatelessWidget{
  List<Cart> listCartItems = [];
  int totalDish = 0;
  int totalItem = 0;
  int totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CartCubit>(context).getCartItems();
     return Scaffold(
        appBar: AppBar(
          title: Text(Strings.cartTitle),
        ),
       body: BlocConsumer<CartCubit,CartState>(
           builder: (context,state){
             return handleBuild(state,context);
           },
           listener: (context,state){
             handleListen(state);
           },
           buildWhen: (previousContext,state){
              return handleBuildWhen(state);
           },
       ),
     );
  }

  Widget body(BuildContext context){
     return  listCartItems.isNotEmpty ? Column(
       children: [
          itemDetails(),
          list(),
          totalPriceContainer(),
          Spacer(),
          proceedButton(context)
       ],
     ) : emptyCart();
  }
  Widget list(){
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context,index){
           return listItem(listCartItems[index],context);
        },itemCount: listCartItems.length,);
  }

  Widget loading(){
     return Center(
       child: CircularProgressIndicator(),
     );
  }

  Widget itemDetails(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 75,
        color: Colors.green,
        child: Center(
            child: Text("$totalDish ${Strings.strDish}-$totalItem ${Strings.strItems}",
                 style: TextStyle(color: Colors.white,fontSize:17 ), )
        ),
      ),
    );
  }

  Widget listItem(Cart cart,BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart.productName,
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(" ${Strings.currency} ${cart.totalPrice.toStringAsFixed(2)}"),
                    SizedBox(height: 8),

                  ],
                ),
              ),
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
                          BlocProvider.of<CartCubit>(context)
                              .onDecrement(cart);
                        },
                      ),
                      Text(
                        cart.qty.toString(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        child: Icon(Icons.add, color: Colors.white),
                        onTap: () {
                          BlocProvider.of<CartCubit>(context).onIncrement(cart);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text("${Strings.currency} ${cart.singlePrice.toStringAsFixed(2)}"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget totalPriceContainer(){
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.strTotal,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text("${Strings.currency} ${totalPrice.toStringAsFixed(2)}",style: TextStyle(fontSize: 18,color: Colors.green),)
            ],
          ),
       ),
     );
  }

  Widget proceedButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0,left: 15,right: 15),
      child: InkWell(
        child: Container(
          width: double.infinity,
          height: 75,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Center(
              child: Text(Strings.strPlOrder,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
        ),
        onTap: (){
            successAlert(context);
        },
      )
      ,
    );
  }

  Widget emptyCart(){
      return Flexible(
         child: Align(
           alignment: Alignment.center,
           child: Text(Strings.strEmpty),
         ),
      );
  }

  void handleListen(CartState state){
     switch(state){
       case CartItems _:
         listCartItems = state.listCart;
         totalDish = state.totalDish;
         totalItem = state.totalItem;
         totalPrice = state.totalPrice;
     }
  }

  void successAlert(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(Strings.strSuccess),
          content: Text(Strings.strSuccessContent),
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<CartCubit>(context).clearCart();
                Navigator.of(ctx).pop();
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: Text(Strings.strOk),
            ),
          ],
        );
      },
    );

  }

  Widget handleBuild(CartState state,BuildContext context){
     switch(state){
       case CartItemLoading _:
         return loading();
       case CartItems _:
          return body(context);
       default:
         return SizedBox();
     }
  }

  bool handleBuildWhen(CartState state){
    return state is CartItemLoading || state is CartItems;
  }
}