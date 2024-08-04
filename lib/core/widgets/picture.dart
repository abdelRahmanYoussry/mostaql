import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';

class Picture extends StatelessWidget {
  const Picture(
    this.src, {
    Key? key,
    this.placeholder,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.paddingEdgeInsets,
    this.loadingBuilder,
    this.imageBuilder,
  })  : memory = null,
        super(key: key);

  const Picture.memory(Uint8List this.memory,
      {Key? key, this.placeholder, this.height, this.width, this.color, this.fit, this.paddingEdgeInsets})
      : src = '',
        loadingBuilder = null,
        imageBuilder = null,
        super(key: key);

  final String src;
  final Widget Function(double progress)? loadingBuilder;
  final Widget Function(ImageProvider provider)? imageBuilder;
  final Widget? placeholder;
  final Uint8List? memory;
  final Color? color;
  final EdgeInsets? paddingEdgeInsets;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final isSvg = src.endsWith('svg');

    if (placeholder != null && !validString(src)) {
      return placeholder!;
    }
    final isMemory = memory != null;
    if (isMemory) {
      return isSvg ? _memSvg() : _memImage();
    }

    final isAsset = src.startsWith('assets');
    if (isAsset) {
      return isSvg ? _assetSvg() : _assetImage();
    }

    final isNetwork = src.startsWith('http');
    if (isNetwork) {
      return isSvg ? _networkSvg() : _networkImage();
    }

    final file = File(src);
    final isFile = file.existsSync();
    if (isFile) {
      return isSvg ? _fileSvg(file) : _fileImage(file);
    }

    return const SizedBox();
  }

  Widget _assetImage() => paddingEdgeInsets == null
      ? Image.asset(
          src,
          height: height,
          color: color,
          width: width,
          fit: fit,
        )
      : Padding(
          padding: paddingEdgeInsets!,
          child: Image.asset(
            src,
            height: height,
            color: color,
            width: width,
            fit: fit,
          ),
        );

  Widget _networkImage() => CachedNetworkImage(
        imageUrl: src,
        height: height,
        width: width,
        color: color,
        fit: fit,
        placeholder: placeholder == null ? null : (context, url) => placeholder!,
        imageBuilder: imageBuilder == null ? null : (context, imageProvider) => imageBuilder!.call(imageProvider),
        progressIndicatorBuilder: loadingBuilder == null
            ? null
            : (context, url, progress) => loadingBuilder!.call(progress.downloaded / (progress.totalSize ?? 1)),
      );

  Widget _fileImage(File file) => Image.file(
        file,
        color: color,
        height: height,
        width: width,
        fit: fit,
      );

  Widget _memImage() => Image.memory(
        memory!,
        color: color,
        height: height,
        width: width,
        fit: fit,
      );

  Widget _assetSvg() => paddingEdgeInsets == null
      ? SvgPicture.asset(
          src,
          height: height,
          // ignore: deprecated_member_use
          color: color,
          width: width,
          fit: fit ?? BoxFit.contain,
          placeholderBuilder: placeholder == null ? null : (context) => placeholder!,
        )
      : Padding(
          padding: paddingEdgeInsets!,
          child: SvgPicture.asset(
            src,
            height: height,
            // ignore: deprecated_member_use
            color: color,
            width: width,
            fit: fit ?? BoxFit.contain,
            placeholderBuilder: placeholder == null ? null : (context) => placeholder!,
          ),
        );

  Widget _networkSvg() => SvgPicture.network(
        src,
        // ignore: deprecated_member_use
        color: color,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
      );

  Widget _fileSvg(File file) => SvgPicture.file(
        file,
        // ignore: deprecated_member_use
        color: color,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
      );

  Widget _memSvg() => SvgPicture.memory(
        memory!,
        // ignore: deprecated_member_use
        color: color,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
      );
}

// class SmartPic extends StatelessWidget {
//   const SmartPic(
//     this.src, {
//     Key? key,
//     this.height,
//   }) : super(key: key);
//
//   final String src;
//   final double? height;
//
//   @override
//   Widget build(BuildContext context) {
//     final isNetwork = src.startsWith('http');
//     if (isNetwork) {
//       return FutureBuilder<Response>(
//         future: Dio().get(src),
//         builder: (context, snapshot) {
//           final data = snapshot.data;
//           if (data != null) {
//             final s = data.data;
//           }
//           return const SizedBox();
//         },
//       );
//     }
//
//     return const Placeholder();
//   }
//
//   Future<Widget Function(BuildContext)> buildWidget() async {
//     final isSvg = src.endsWith('svg');
//
//     final isMemory = memory != null;
//     if (isMemory) {
//       return (context) => isSvg ? _memSvg() : _memImage();
//     }
//
//     final isAsset = src.startsWith('assets');
//     if (isAsset) {
//       return (context) => isSvg ? _assetSvg() : _assetImage();
//     }
//
//     final isNetwork = src.startsWith('http');
//     if (isNetwork) {
//       return (context) => isSvg ? _networkSvg() : _networkImage();
//     }
//
//     final file = File(src);
//     final isFile = file.existsSync();
//     if (isFile) {
//       return (context) => isSvg ? _fileSvg(file) : _fileImage(file);
//     }
//
//     return (context) => const SizedBox();
//   }
// }
