import 'package:appfront/Screen/map/widgets/park_info.dart';
import 'package:appfront/Screen/map/widgets/pcg_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MyNaverMap extends StatefulWidget {
  final double lat;
  final double lng;
  final int price;
  final int space;
  final String disabled;
  final List pcgData;
  final List<NMarker> markers;
  final List<NMarker> pcg;
  const MyNaverMap({
    super.key,
    required this.markers,
    required this.pcg,
    required this.pcgData,
    required this.lat,
    required this.lng,
    required this.price,
    required this.space,
    required this.disabled,
  });

  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: NaverMapViewOptions(
        locationButtonEnable: true,
        initialCameraPosition:
            NCameraPosition(target: NLatLng(widget.lat, widget.lng), zoom: 14),
        mapType: NMapType.basic,
        pickTolerance: 8,
        rotationGesturesEnable: true,
        scrollGesturesEnable: true,
        tiltGesturesEnable: true,
        zoomGesturesEnable: true,
        stopGesturesEnable: true,
      ), // 지도 옵션을 설정할 수 있습니다.
      forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
      onMapReady: (controller) {
        for (var marker in widget.markers) {
          controller.addOverlay(marker);
          marker.setOnTapListener((overlay) {
            print(overlay.info.id);
            parkInfo(context, overlay.info.id);
          });
        }
        for (var marker in widget.pcg) {
          controller.addOverlay(marker);
          marker.setOnTapListener((overlay) {
            final tmp = widget.pcgData
                .where((item) => item['name'] == overlay.info.id)
                .toList()[0];
            pcgInfo(context, overlay.info.id, tmp);
          });
        }
      },
      onMapTapped: (point, latLng) {},
      onSymbolTapped: (symbol) {},
      onCameraChange: (position, reason) {},
      onCameraIdle: () {},
      onSelectedIndoorChanged: (indoor) {},
    );
  }
}

void parkInfo(BuildContext context, String name) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    builder: (BuildContext context) {
      return ParkInfo(name: name);
    },
  );
}

void pcgInfo(BuildContext context, String name, dynamic tmp) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    builder: (BuildContext context) {
      return PcgInfo(name: name, tmp: tmp);
    },
  );
}
