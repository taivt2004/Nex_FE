import 'package:nexpaylab/app/data/model/base/meta.dart';

class DataList<T> {
  const DataList({
    required this.data,
    this.meta,
  });

  final List<T> data;
  final Meta? meta;
}
