import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pinokio_library/flutter_pinokio_library.dart';

class SearchImageList extends StatelessWidget {
  const SearchImageList(
      {Key? key,
      required this.originalUrlList,
      required this.thumbnailUrlList,
      required this.bl,
      required this.dataRowHeight,
      required this.jwt})
      : super(key: key);

  final List<String> originalUrlList; //  이미지 다운 URL을 list로 받음
  final List<String> thumbnailUrlList; //  이미지 다운 URL을 list로 받음
  final String bl;
  final double dataRowHeight;
  final String jwt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<InkWell>.generate(
          thumbnailUrlList.length,
          (index) {
            return InkWell(
              onTap: () async {
                (await customSwipeImageGallery(
                        context, index, originalUrlList, bl, jwt))
                    .show();
              },
              child: SizedBox.square(
                dimension: dataRowHeight,
                child: thumbnailUrlList[index].isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CachedNetworkImage(
                        cacheKey: 'Thumbnail${thumbnailUrlList[index]}',
                        cacheManager: SearchCacheManager.instance,
                        imageUrl: thumbnailUrlList[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchCacheManager {
  static const key = "search";
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 500,
    ),
  );
}
