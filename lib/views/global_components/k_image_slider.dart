import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddyscripts/views/global_components/k_cupertino_nav_bar.dart';
import 'package:buddyscripts/views/styles/b_style.dart';

class KImageSliderView extends StatefulWidget {
  final List<String> imagesList;
  final int initialPage;

  const KImageSliderView({required this.imagesList, this.initialPage = 0, Key? key}) : super(key: key);

  @override
  _KImageSliderViewState createState() => _KImageSliderViewState();
}

class _KImageSliderViewState extends State<KImageSliderView> {
  CarouselController? _carouselController;
  int? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: KColor.blackConst,
      // backgroundColor: KColor.white,
      navigationBar:
          KCupertinoNavBar(backgroundColor: KColor.blackConst, arrowIconColor: KColor.whiteConst, automaticallyImplyLeading: false, hasLeading: true),
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1,
          initialPage: widget.initialPage,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          onPageChanged: (index, _) {
            setState(() {
              _current = index;
            });
          },
        ),
        carouselController: _carouselController,
        items: widget.imagesList.map(
          (imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    InteractiveViewer(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 170,
                        width: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CupertinoActivityIndicator());
                          },
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.info, color: KColor.black), const Text("Something went wrong")],
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.imagesList.map((url) {
                          int index = widget.imagesList.indexOf(url);
                          return Container(
                            width: _current == index ? 12 : 8,
                            height: _current == index ? 5 : 3,
                            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 3.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(1),
                              color: _current == index ? KColor.primary : KColor.primary.withOpacity(0.1),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
