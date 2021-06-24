import 'package:coffe/model/Coffee.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 200);

class CoffeList extends StatefulWidget {
  const CoffeList({ Key? key }) : super(key: key);

  @override
  _CoffeListState createState() => _CoffeListState();
}

class _CoffeListState extends State<CoffeList> {

  final _pageCoffeController = PageController(
    viewportFraction: 0.3,
  );

  final _pageTextController = PageController();

  double _currentPage = 0.0;
  double _textPage = 0.0;

  void _coffeeScrollListener() {
    setState(() {
      _currentPage = _pageCoffeController.page!;
    });
  }

  void _textScrollListener() {
    setState(() {
      _textPage = _currentPage;
    });
  }

  @override
  void initState() {
    _pageCoffeController.addListener(_coffeeScrollListener);
    _pageTextController.addListener(_textScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageCoffeController.removeListener(_coffeeScrollListener);
    _pageTextController.removeListener(_textScrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(children: [
        Positioned(
              left: 20,
              right: 20,
              bottom: -MediaQuery.of(context).size.height*0.22,
              height: MediaQuery.of(context).size.height*0.3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown,
                      blurRadius: 90,
                      offset: Offset.zero,
                      spreadRadius: 45
                    )
                  ]
                ),
              )
            ),
        Transform.scale(
          scale: 1.6,
          alignment: Alignment.bottomCenter,
          child: PageView.builder(
            controller: _pageCoffeController,
            scrollDirection: Axis.vertical,
            itemCount: coffees.length + 1,
            onPageChanged: (value) {
              if(value < coffees.length) {
                _pageTextController.animateToPage(
                  value, 
                  duration: _duration, 
                  curve: Curves.easeInOut
                );
              }
            },
            itemBuilder: (context, index) {
            if(index == 0) {
              return const SizedBox.shrink();
            }
            final coffee = coffees[index];
            final result = _currentPage - index + 1;
            final value = -0.4 * result + 1;
            final opacity = value.clamp(0.0, 1.0);
        
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..translate(
              0.0,
              MediaQuery.of(context).size.height / 2.6 * (1 - value).abs(),
            )
              ..scale(value),
              child: Opacity(opacity: opacity, child: Image.asset(coffee.image),)
            );
          }),
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: 100,
          child: Column(children: [
            Expanded(
              child: PageView.builder(
                controller: _pageTextController,
                itemCount: coffees.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final opacity = (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                  return Opacity(
                    opacity: opacity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                      child: Text(
                      coffees[index].name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                      ),
                  ),
                    ),
                  );
                }
              )
            ),
            AnimatedSwitcher(duration: _duration,
              child: Text(
                '\$${coffees[_currentPage.toInt()].price.toStringAsFixed(2)}',
                style:  TextStyle(
                  fontSize: 30,
                ),
                key: Key(coffees[_currentPage.toInt()].name),
              ),
            )
          ],)
        ),
      ],),
    );
  }
}