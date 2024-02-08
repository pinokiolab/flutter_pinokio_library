import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

Future<SwipeImageGallery> customSwipeImageGallery(
  BuildContext context,
  int index,
  List<String> originalUrlList,
  String bl,
  String jwt,
) async {
  return SwipeImageGallery(
      context: context,
      initialIndex: index,
      children: List.generate(originalUrlList.length, (index) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('검사 사진 상세보기'),
            actions: [
              IconButton(
                  onPressed: () async {
                    var t = await get(Uri.parse(originalUrlList[index]));
                    var b = Blob([t.bodyBytes]);
                    var u = Url.createObjectUrlFromBlob(b);
                    AnchorElement(href: u)
                      ..download = '${bl}_[$index].jpg'
                      ..click();
                  },
                  tooltip: '사진 다운로드',
                  icon: const Icon(Icons.download))
            ],
          ),
          body: Row(
            children: [
              Expanded(
                  child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: CachedNetworkImage(
                      cacheKey: 'Original${originalUrlList.elementAt(index)}}',
                      cacheManager: SwipeCacheManager.instance,
                      imageUrl: originalUrlList.elementAt(index),
                      fit: BoxFit.contain,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const _SwipeImageGalleryLabel(
                      label: '마우스 휠로 확대, 키보드 좌우 버튼으로 이동이 가능합니다.'),
                ],
              ))
            ],
          ),
        );
      }));
}

class SwipeCacheManager {
  static const key = "swipe";
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 500,
    ),
  );
}

class _SwipeImageGalleryLabel extends StatelessWidget {
  const _SwipeImageGalleryLabel({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ColoredBox(
        color: Colors.white.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(label, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
