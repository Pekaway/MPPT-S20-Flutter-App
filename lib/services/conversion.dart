import 'dart:typed_data';

class ConversionService {
  final List<int> dataList;

  ConversionService({required this.dataList});

  getInt4(int start) {
    return dataList[start];
  }

  getInt8(int start) {
    Int8List list = Int8List(2);
    list[0] = dataList[start];
    list[1] = dataList[start + 1];
    return list.buffer.asByteData().getInt16(0);
  }

  getUInt8(int start) {
    Int8List list = Int8List(2);
    list[0] = dataList[start];
    list[1] = dataList[start + 1];
    return list.buffer.asByteData().getUint16(0);
  }
}
