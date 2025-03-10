import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wasteapp/utils/constants.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/dimens.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/common/cubit/custom_loading/custom_loading_cubit.dart';
import 'package:wasteapp/features/common/widgets/custom_loading.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/cubit/cubit/page_indicator_cubit.dart';
import 'package:wasteapp/features/home/presentation/pages/user_profile_view.dart';
import 'package:wasteapp/features/home/presentation/widgets/carousel_card.dart';
import 'package:wasteapp/features/home/presentation/widgets/category_grid.dart';
import 'package:wasteapp/features/home/presentation/widgets/destination_card.dart';
import 'package:wasteapp/features/home/presentation/widgets/service_grid.dart';
import 'package:wasteapp/features/home/presentation/widgets/title_text.dart';
import 'package:wasteapp/features/home/presentation/widgets/user_image_avatar.dart';
import 'package:wasteapp/routes/routes.dart';
import 'package:wasteapp/routes/routes_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseServices firebaseServices;
  late FlutterSecureStorage secureStorage;
  late CustomLoadingCubit customLoadingCubit;
  late String userImageUrl = '';

  List<DetailModel> lisUpcomingItems = [
    DetailModel(
      id: "0",
      title: "title",
      location: "",
      locationCategory: "locationCategory",
      category: "category",
      season: "season",
      rating: 0,
      imageUrls: [],
      description: "description",
      suggestionNote: "suggestionNote",
      isFavourite: false,
    ),
    DetailModel(
      id: "1",
      title: "title",
      location: "location",
      locationCategory: "locationCategory",
      category: "category",
      season: "season",
      rating: 0,
      imageUrls: [],
      description: "description",
      suggestionNote: "suggestionNote",
      isFavourite: false,
    ),
  ];

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    customLoadingCubit = CustomLoadingCubit();
    secureStorage = const FlutterSecureStorage();
    firebaseServices = FirebaseServices();
    setUserImage();
    super.initState();
  }

  void setUserImage() async {
    userImageUrl = await secureStorage.read(key: 'userImageUrl') ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationColors(context).appBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                automaticallyImplyLeading: false,
                backgroundColor: ApplicationColors(context).appWhiteBackground,
                expandedHeight: 85,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(
                      bottom: Dimens.defaultPadding,
                    ),
                    child: Column(
                      children: [
                        // Safe Area
                        SizedBox(height: context.mQTopSafeArea),
                        // Header
                        Container(
                          padding: const EdgeInsets.all(Dimens.defaultPadding),
                          decoration: BoxDecoration(
                            color:
                                ApplicationColors(context).appWhiteBackground,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ApplicationColors(
                                  context,
                                ).shadowContainers.withValues(alpha: 0.1),
                                offset: const Offset(0, 4),
                                blurRadius: Dimens.defaultPadding,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "♻️ ${Constants.appName}",
                                style: TextStyles(context).homeHeaderTitle,
                              ),
                              Wrap(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showUserBottomSheet();
                                    },
                                    child: UserImageAvatar(
                                      imageUrl: userImageUrl,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (lisUpcomingItems.isNotEmpty)
                        ? const TitleText(titleText: "What is new...")
                        : Container(),
                    // Carousel Slider
                    (lisUpcomingItems.isNotEmpty)
                        ? Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: Dimens.defaultPadding,
                          ),
                          child: CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(
                                milliseconds: 800,
                              ),
                              autoPlayCurve: Curves.easeInOut,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                context.read<PageIndicatorCubit>().setPageIndex(
                                  index: index,
                                );
                              },
                            ),
                            items:
                                lisUpcomingItems.map((item) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          // context.toNamed(
                                          //   ScreenRoutes.toItemDetailScreen,
                                          //   args: item,
                                          // );
                                        },
                                        child: CarouselCard(
                                          imageUrl:
                                              item.imageUrls.isNotEmpty
                                                  ? item.imageUrls.first
                                                  : "",
                                          text: item.title,
                                          subText: item.location,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                          ),
                        )
                        : Container(),
                    (lisUpcomingItems.isNotEmpty)
                        ? const SizedBox(height: 16.0)
                        : Container(),
                    // Page Indicator
                    (lisUpcomingItems.isNotEmpty)
                        ? Align(
                          alignment: Alignment.center,
                          child: BlocBuilder<
                            PageIndicatorCubit,
                            PageIndicatorState
                          >(
                            builder: (context, state) {
                              if (state is PageIndicatorInitial) {
                                return AnimatedSmoothIndicator(
                                  activeIndex: state.pageIndex,
                                  count: lisUpcomingItems.length,
                                  effect: const ExpandingDotsEffect(
                                    activeDotColor: primaryColor,
                                    dotHeight: 9,
                                    dotWidth: 9,
                                    spacing: 6,
                                  ),
                                  onDotClicked: (index) {
                                    _carouselController.animateToPage(index);
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        )
                        : Container(),
                    const TitleText(titleText: "Discover Your Next Adventure"),
                    SizedBox(
                      height: 400,
                      child: CategoryGrid(
                        onCategoryTap: (category) {
                          if (category == "Event Calendar") {
                            context.toNamed(ScreenRoutes.toEventCalenderScreen);
                          } else {
                            context.toNamed(
                              ScreenRoutes.toItemGridScreen,
                              args: category,
                            );
                          }
                        },
                      ),
                    ),
                    const TitleText(titleText: "Services"),
                    const ServiceGrid(),
                  ],
                ),
              ),
            ],
          ),
          BlocBuilder<CustomLoadingCubit, CustomLoadingInitial>(
            bloc: customLoadingCubit,
            builder: (context, state) {
              return CustomLoading(isLoading: state.isLoading);
            },
          ),
        ],
      ),
    );
  }

  void showUserBottomSheet() {
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.defaultBottomSheetRadius),
          topRight: Radius.circular(Dimens.defaultBottomSheetRadius),
        ),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: context.mQHeight * 0.8),
          child: const Scaffold(body: UserProfileScreen()),
        );
      },
    );
  }
}
