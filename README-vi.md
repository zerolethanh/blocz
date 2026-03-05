# blocz

Một công cụ dòng lệnh (CLI) giúp tăng tốc độ phát triển ứng dụng Flutter bằng cách tự động tạo các thành phần cho BLoC pattern.

[![pub version](https://img.shields.io/pub/v/blocz.svg)](https://pub.dev/packages/blocz)

## Giới thiệu

`blocz` giúp bạn tạo nhanh chóng các tệp BLoC, Event, và State theo một cấu trúc thư mục được định sẵn, giúp bạn tiết kiệm thời gian và giữ cho code base của bạn nhất quán. Công cụ này cũng hỗ trợ thêm các event vào một BLoC đã có.

## Tính năng

- Tạo BLoC, Event, và State chỉ với một lệnh duy nhất.
- Tự động tạo cấu trúc thư mục theo domain.
- Mã nguồn được tạo ra tương thích với các package phổ biến như `flutter_bloc`, `freezed`, và `injectable`.
- Hỗ trợ thêm nhanh các event vào BLoC.

## Điều kiện tiên quyết

Dự án Flutter của bạn cần phải có các dependencies sau trong `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: <version>
  freezed_annotation: <version>
  injectable: <version>

dev_dependencies:
  build_runner: <version>
  freezed: <version>
  injectable_generator: <version>
```

## Cài đặt

Cài đặt `blocz` như một công cụ global để có thể sử dụng ở bất kỳ đâu:

```bash
dart pub global activate blocz
```

## Hướng dẫn sử dụng

### 1. Tạo BLoC, Event, và State

Sử dụng lệnh `make:bloc` để tạo các thành phần cần thiết.

```bash
blocz make:bloc --domain <ten_domain> --name <ten_bloc>
```

- `--domain` (hoặc `-d`): Domain hoặc feature của BLoC (ví dụ: `user`, `product`).
- `--name` (hoặc `-n`): Tên của BLoC (ví dụ: `authentication`, `product_list`). Đây là tham số không bắt buộc.

**Ví dụ:**

```bash
blocz make:bloc --domain user --name login
```

Lệnh trên sẽ tạo ra cấu trúc thư mục và các tệp sau:

```
lib/
└── features/
    └── user/
        └── presentation/
            └── bloc/
                ├── user_login_bloc.dart
                ├── user_login_event.dart
                └── user_login_state.dart
```

**Quan trọng:** Sau khi tạo các tệp, vì chúng sử dụng `freezed`, bạn cần chạy `build_runner` để tạo các tệp `.freezed.dart` và `.g.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Thêm một Event

Sử dụng lệnh `add:event` để thêm một event mới vào một BLoC đã tồn tại.

```bash
blocz add:event --domain <ten_domain> --name <ten_bloc> --event <ten_event>
```

**Ví dụ:**

```bash
blocz add:event --domain user --name login --event LogoutButtonPressed
```

Lệnh này sẽ cập nhật các tệp `_event.dart` và `_bloc.dart` tương ứng để thêm event `LogoutButtonPressed`.

## Các lệnh khác

`blocz` cũng cung cấp nhiều lệnh phụ trợ để phân tích mã nguồn Dart. Sử dụng `blocz --help` để xem tất cả các lệnh có sẵn.
