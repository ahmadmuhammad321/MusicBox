import 'package:flutter/material.dart';
import 'package:musicbox/drawer.dart';
import 'package:musicbox/main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicbox/playsong.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  @override
  final audioQuery = new OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool status = false;
  String msg = "no songs found in the device";

  @override
  void initState() {
    // TODO: implement initState

    requestpermission();

    super.initState();
  }

  void requestpermission() {
    Permission.storage.request();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        actions: [
          IconButton(
              onPressed: () {
                MyApp.themeNotifier.value =
                    MyApp.themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              },
              icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode))
        ],
      ),
      drawer: sidebar(),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: ((context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return Center(
              child: Text(msg),
            );
          }
          return ListView.builder(
            itemBuilder: ((context, index) => ListTile(
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget:
                        CircleAvatar(child: Icon(Icons.music_note)),
                  ),
                  title: Text(item.data![index].displayNameWOExt),
                  subtitle: Text(
                    '${(((item.data![index].duration!) / 1000) / 60).toInt()} : ${(((item.data![index].duration!) / 1000) % 60).toInt()}',
                  ),
                  trailing: const Icon(Icons.more_horiz),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => playsong(
                                  songlist: item.data!,
                                  audioPlayer: audioPlayer,
                                  index: index,
                                )));
                  },
                )),
            itemCount: item.data!.length,
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
