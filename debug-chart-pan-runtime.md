# [OPEN] Chart Pan Runtime

## Session
- id: chart-pan-runtime
- scope: `lib/features/coin_detail/presentation/page/coin_detail_page.dart`

## Symptom
- Người dùng báo lỗi runtime ở `Terminal#1-1016` khi tương tác chart.
- Kéo chart hiện không hoạt động ổn định, và đã có nhiều lần vá logic trước đó.

## Hypotheses
1. Gesture pan không đi tới `handleHorizontalDrag` vì widget chart vẫn chặn pointer ở một tầng khác.
2. Viewport bị reset/clamp sai khi đổi range hoặc khi data history prepend, làm runtime rơi vào trạng thái rỗng hoặc bất nhất.
3. `FetchChartHistory` được bắn với `timeStart/timeEnd` không đúng, dẫn tới state update ngoài kỳ vọng hoặc lỗi trong merge points.
4. Dataset sau khi đổi range/pan có thể tạo ra viewport không giao với data hiện tại, khiến chart render lỗi hoặc trắng.
5. Có lỗi runtime khác trong tree của `coin_detail_page.dart` không nằm ở chart painter nhưng chỉ lộ ra khi rebuild sau khi đổi range/pan.

## Evidence
- Chưa thu thập log runtime cụ thể trong phiên này.

## Next
- Xác nhận lỗi terminal hiện tại là compile-time hay runtime.
- Thu thập stack/message cụ thể từ terminal hoặc từ lần chạy `flutter analyze`/runtime reproduction.
