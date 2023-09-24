import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class MediaMessage extends StatefulWidget {
  const MediaMessage(
      {super.key,
      required this.mediaurl,
      required this.isme,
      required this.medaitype});

  final bool isme;
  final String mediaurl;
  final String medaitype;

  @override
  State<MediaMessage> createState() => _MediaMessageState();
}

class _MediaMessageState extends State<MediaMessage> {
  bool _showdownloand = false;
  bool _downloading = false;

  Future<void> downloadMedia(String mediaUrl) async {
    setState(() {
      _downloading = true;
    });
    FileDownloader.downloadFile(
        url: mediaUrl,
        onProgress: (name, progress) {},
        onDownloadCompleted: (value) {
          setState(() {
            _downloading = false;
            _showdownloand = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.medaitype == 'jpg'
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                widget.isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                clipBehavior: Clip.hardEdge,
                constraints:
                    const BoxConstraints(maxHeight: 500, maxWidth: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                    onTap: () {
                      if (_showdownloand) {
                        setState(() {
                          _showdownloand = false;
                        });
                      }
                    },
                    onLongPress: () {
                      setState(() {
                        _showdownloand = true;
                      });
                    },
                    child: Image.network(widget.mediaurl)),
              ),
              if (_downloading)
                const Center(
                  child: LinearProgressIndicator(),
                ),
              if (_showdownloand && !_downloading)
                IconButton(
                    onPressed: () {
                      downloadMedia(widget.mediaurl);
                    },
                    icon: const Icon(Icons.download))
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                widget.isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    downloadMedia(widget.mediaurl);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Document')),
              if (_downloading)
                const Center(
                  child: LinearProgressIndicator(),
                ),
            ],
          );
  }
}
