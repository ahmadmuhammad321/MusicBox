import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playsong extends StatefulWidget {
  playsong(
      {super.key,
      required this.audioPlayer,
      required this.songlist,
      required this.index});

  final AudioPlayer audioPlayer;
  final List<SongModel> songlist;
  int index;

  @override
  State<playsong> createState() => _playsongState();
}

class _playsongState extends State<playsong> {
  bool isplaying = false;
  bool islooping = false;
  bool isshuffle = false;
  Color iconColorL = Colors.grey.shade600;
  Color iconColorS = Colors.grey.shade600;
  List<AudioSource> listuri = [];

  @override
  void initState() {
    // TODO: implement initState

    startplaying(widget.index);

    super.initState();
  }

  void startplaying(int index) {
    try {
      widget.audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(widget.songlist[index].uri!)));
      widget.audioPlayer.play();
      isplaying = true;
    } on Exception {
      print("Not able to play this song");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/3.jpg'), fit: BoxFit.cover)),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const Text('Now Playing')
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CircleAvatar(
                //   radius: 120.0,
                //   child: Icon(
                //     Icons.music_note,
                //     size: 100,
                //   ),
                // ),
                CircleAvatar(
                  radius: 115.0,
                  child: QueryArtworkWidget(
                    id: widget.songlist[widget.index].id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: 230,
                    artworkWidth: 230,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.circular(125),
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 350,
                  child: Marquee(
                    text: widget.songlist[widget.index].displayNameWOExt +
                        '            ',
                    style: TextStyle(fontSize: 27),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.songlist[widget.index].artist.toString() ==
                              '<unknown>'
                          ? 'Unknown Artist'
                          : widget.songlist[widget.index].artist.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            slider(
              audioPlayer: widget.audioPlayer,
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (islooping == true) {
                          widget.audioPlayer.setLoopMode(LoopMode.off);
                          iconColorL = Colors.grey.shade600;
                        } else {
                          widget.audioPlayer.setLoopMode(LoopMode.one);
                          iconColorL = Colors.blue.shade300;
                        }
                        islooping = !islooping;
                      });
                    },
                    icon: Icon(
                      Icons.loop,
                      size: 40,
                      color: iconColorL,
                    )),
                IconButton(
                    onPressed: () {
                      if (widget.index != 0)
                        setState(() {
                          widget.index--;
                          startplaying(widget.index);
                        });
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 43,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (isplaying == true) {
                          widget.audioPlayer.pause();
                        } else {
                          widget.audioPlayer.play();
                        }
                        isplaying = !isplaying;
                      });
                    },
                    icon: Icon(
                      isplaying == true ? Icons.pause : Icons.play_arrow,
                      size: 43,
                    )),
                IconButton(
                    onPressed: () {
                      if (widget.index != widget.songlist.length - 1)
                        setState(() {
                          widget.index++;
                          startplaying(widget.index);
                        });
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      size: 43,
                    )),
                IconButton(
                    onPressed: () {
                      for (int i = 0; i < widget.songlist.length; i++) {
                        listuri.add(AudioSource.uri(
                            Uri.parse(widget.songlist[i].uri!)));
                      }
                      setState(() {
                        if (isshuffle == true) {
                          iconColorS = Colors.grey.shade600;
                        } else {
                          iconColorS = Colors.blue.shade300;
                        }
                        isshuffle = !isshuffle;
                      });

                      widget.audioPlayer.setAudioSource(
                          ConcatenatingAudioSource(
                              children: listuri,
                              shuffleOrder: DefaultShuffleOrder()));
                    },
                    icon: Icon(
                      Icons.shuffle,
                      color: iconColorS,
                      size: 40,
                    )),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class slider extends StatefulWidget {
  const slider({
    super.key,
    required this.audioPlayer,
  });
  final AudioPlayer audioPlayer;

  @override
  State<slider> createState() => _sliderState();
}

class _sliderState extends State<slider> {
  Duration duration = Duration();
  Duration position = Duration();
  @override
  void initState() {
    // TODO: implement initState
    playslider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          position.toString().split('.')[0],
        ),
        Expanded(
            child: Slider(
                min: Duration(microseconds: 0).inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      changeToseconds(value.toInt());
                      value = value;
                    });
                  }
                })),
        Text(
          duration.toString().split('.')[0],
        )
      ],
    );
  }

  void changeToseconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  void playslider() {
    widget.audioPlayer.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          duration = d!;
        });
      }
    });
    widget.audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
      }
    });
  }
}
