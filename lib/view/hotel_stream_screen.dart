import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/models/hotel.dart';
import 'package:project/view/details_screens/hotel_details.dart';
import '../locale_language/localization_delegate.dart';

 class HotelStream extends StatefulWidget {


  @override
  _HotelStreamState createState() => _HotelStreamState();
}

class _HotelStreamState extends State<HotelStream> {
  getRating(){
    return   AppLocalization.of(context).locale.languageCode == "ar"
        ? DataBase().getHotelsAr
        : DataBase().getHotels;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getRating();
    });
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Hotel>>(
      stream:getRating(),
      builder: (context, AsyncSnapshot<List<Hotel>> snapshot) {
        if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        else if (!snapshot.hasData) {
          return Container();
        }
        else if(snapshot.data.isEmpty) {
          return Center(child: Text('No Data'),);
        }else{
          var data=snapshot.data;
          return Container(
            height: MediaQuery.of(context).size.height *0.80,
            child: StaggeredGridView.countBuilder(
                key: ObjectKey("${snapshot.data.length}"),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount: data != null && data.length > 0
                    ? data.length
                    : 0,
                itemBuilder: (context, index) {
                  final Hotel currentHotel = data[index];

                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(currentHotel.images[0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: blackColor.withOpacity(0.4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: AppLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                      'ar'
                                      ? const EdgeInsets.only(right: 8, top: 4)
                                      : const EdgeInsets.only(left: 8, top: 4),
                                  child: Text(
                                    currentHotel.hotelName,
                                    style: TextStyle(
                                        color: whiteColor, fontSize: 13),
                                  ),
                                ),
                                Padding(
                                  padding: AppLocalization.of(context)
                                      .locale
                                      .languageCode ==
                                      'ar'
                                      ? const EdgeInsets.only(right: 5, top: 2)
                                      : const EdgeInsets.only(left: 5, top: 2),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_sharp,
                                        color: redAccentColor,
                                        size: 16,
                                      ),
                                      Text(
                                        currentHotel.hotelCity,
                                        style: TextStyle(
                                            color: whiteColor, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HotelsDetailsScreen(
                                hotel: currentHotel,
                              )));
                    },
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count(1, index.isEven ? 1.8 : 1.2);
                }),
          );
        }

      },
    );
  }
}
