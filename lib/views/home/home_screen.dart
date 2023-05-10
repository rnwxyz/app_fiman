import 'package:app_fiman/utils/constants/contant.dart';
import 'package:app_fiman/views/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/news/news_bloc.dart';
import '../../models/news_model.dart';
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
    context.read<NewsBloc>().add(NewsFetch(q: '', loadMore: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTile(
                title: Text('Hallo', style: headline1),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
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
                      },
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
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
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('resume',
                        style: Theme.of(context).textTheme.headlineLarge),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 200,
                        child: Text('Berita terkini', style: headline2),
                      ),
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.search),
                          ),
                          onFieldSubmitted: (value) {
                            context
                                .read<NewsBloc>()
                                .add(NewsFetch(q: value, loadMore: false));
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
                              final String publishedAt =
                                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                                      .format(news[index].publishedAt);
                              final String author = news[index].author;
                              final String imgUrl = news[index].urlToImage;
                              final String url = news[index].url;
                              Widget image = Icon(Icons.image_not_supported);

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
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
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
                                      subtitle: Text('$publishedAt\n$author'),
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
        ),
        bottomNavigationBar: const MyNavigationBar(currentTab: 0));
  }
}
