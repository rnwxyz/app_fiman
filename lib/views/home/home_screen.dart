import 'package:app_fiman/utils/constants/contant.dart';
import 'package:app_fiman/views/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/news/news_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/resume/resume_bloc.dart';
import '../../models/news_model.dart';
import '../../models/resume_model.dart';
import '../../utils/componen/navigation_bar.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsModel> news = [];
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          context
              .read<NewsBloc>()
              .add(NewsFetch(loadMore: true, q: searchController.text));
        }
      },
    );
    context.read<NotificationBloc>().add(NotificationFeatch());
    context.read<ResumeBloc>().add(ResumeFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    title: const Text('Hallo', style: headline1),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const NotificationScreen();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final tween = Tween(begin: 0.1, end: 1.0);
                                return FadeTransition(
                                  opacity: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        }, icon:
                            BlocBuilder<NotificationBloc, NotificationState>(
                          builder: (context, state) {
                            if (state is NotificationLoaded) {
                              return Badge(
                                alignment: const AlignmentDirectional(20, 0),
                                largeSize: 18,
                                isLabelVisible: state.schedules.isNotEmpty,
                                textStyle: const TextStyle(
                                  color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                label: Text(
                                  state.schedules.length.toString(),
                                ),
                                child: const Icon(
                                  Icons.notifications,
                                  color: black,
                                  size: 40,
                                ),
                              );
                            } else {
                              return const Icon(
                                Icons.notifications,
                                color: black,
                                size: 40,
                              );
                            }
                          },
                        )),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthLogout());
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StartScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.logout,
                              color: Colors.black, size: 40),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthSuccess) {
                          return Text(state.name, style: headline2);
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 450,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text('Total uang kamu sekarang',
                              style: headline3),
                          const SizedBox(height: 20),
                          BlocBuilder<ResumeBloc, ResumeState>(
                            builder: (context, state) {
                              if (state is ResumeInitial) {
                                return const CircularProgressIndicator();
                              } else if (state is ResumeLoaded) {
                                if (state.transactionSum < 0) {
                                  return Text(
                                    NumberFormat.currency(
                                            locale: 'id', symbol: 'Rp.')
                                        .format(state.transactionSum * -1),
                                    style: const TextStyle(
                                      color: danger,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    NumberFormat.currency(
                                            locale: 'id', symbol: 'Rp.')
                                        .format(state.transactionSum),
                                    style: const TextStyle(
                                      color: success,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              } else if (state is ResumeError) {
                                return Text(state.message);
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 300,
                            child: BlocConsumer<ResumeBloc, ResumeState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                if (state is ResumeLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is ResumeLoaded) {
                                  final data = state.data;
                                  return SfCartesianChart(
                                    title: ChartTitle(
                                        alignment: ChartAlignment.far,
                                        text: DateFormat('MMMM yyyy', 'id_ID')
                                            .format(DateTime.now())),
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(
                                        numberFormat:
                                            NumberFormat.compactCurrency(
                                                locale: 'id', symbol: 'Rp.')),
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    series: <ChartSeries<ResumeModel, String>>[
                                      StackedLineSeries<ResumeModel, String>(
                                        markerSettings: const MarkerSettings(
                                            isVisible: true),
                                        dataSource: data,
                                        xValueMapper: (ResumeModel resume, _) =>
                                            resume.day,
                                        yValueMapper: (ResumeModel resume, _) =>
                                            resume.transactionSum,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                              color: black, fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (state is ResumeError) {
                                  return Center(
                                    child: Text(state.message),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              SlidingUpPanel(
                onPanelOpened: () {
                  context
                      .read<NewsBloc>()
                      .add(NewsFetch(q: '', loadMore: false));
                },
                panel: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 85,
                              width: 200,
                              child: Center(
                                  child:
                                      Text('Berita terkini', style: headline2)),
                            ),
                            SizedBox(
                              height: 50,
                              width: 120,
                              child: TextFormField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                ),
                                onFieldSubmitted: (value) {
                                  context.read<NewsBloc>().add(
                                      NewsFetch(q: value, loadMore: false));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: BlocConsumer<NewsBloc, NewsState>(
                          listener: (context, state) {
                            if (state is NewsLoaded) {
                              news = state.news;
                            }
                            if (state is NewsError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is NewsInitial) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView.builder(
                                controller: scrollController,
                                itemCount: state is NewsLoading
                                    ? news.length + 1
                                    : news.length,
                                itemBuilder: (context, index) {
                                  if (index == news.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    final String title = news[index].title;
                                    final String publishedAt = DateFormat(
                                            'EEEE, dd MMMM yyyy', 'id_ID')
                                        .format(news[index].publishedAt);
                                    final String author = news[index].author;
                                    final String imgUrl =
                                        news[index].urlToImage;
                                    final String url = news[index].url;
                                    Widget image =
                                        const Icon(Icons.image_not_supported);

                                    if (imgUrl != '') {
                                      image = Image.network(
                                        imgUrl,
                                        fit: BoxFit.cover,
                                      );
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, right: 8, left: 8),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Text(
                                                title,
                                                maxLines: 3,
                                              ),
                                            ),
                                            onTap: () {
                                              context
                                                  .read<NewsBloc>()
                                                  .add(NewsRedirect(url));
                                            },
                                            style: ListTileStyle.drawer,
                                            subtitle:
                                                Text('$publishedAt\n$author'),
                                            trailing: SizedBox(
                                              height: 150,
                                              width: 100,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                  child: image),
                                            ),
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const MyNavigationBar(currentTab: 0));
  }
}
