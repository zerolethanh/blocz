# blocz

Một công cụ dòng lệnh (CLI) giúp tăng tốc độ phát triển ứng dụng Flutter bằng cách tạo mã nguồn cho các thành phần theo mẫu BLoC.

[![pub version](https://img.shields.io/pub/v/blocz.svg)](https://pub.dev/packages/blocz)

## Về `blocz`

`blocz` giúp bạn nhanh chóng tạo ra các tệp BLoC, Event và State theo một cấu trúc thư mục có tổ chức, giúp bạn tiết kiệm thời gian và duy trì sự nhất quán trong mã nguồn. Công cụ này cũng hỗ trợ thêm các sự kiện vào một BLoC đã tồn tại.

## Các tính năng

- Tạo BLoC, Event và State chỉ bằng một lệnh duy nhất.
- Tự động tạo cấu trúc thư mục dựa trên tên miền (domain-based).
- Mã nguồn được tạo ra tương thích với các gói phổ biến như `flutter_bloc`, `freezed`, và `injectable`.
- Hỗ trợ thêm sự kiện mới vào một BLoC một cách nhanh chóng.

## Điều kiện tiên quyết

Dự án Flutter của bạn phải có các gói phụ thuộc sau trong tệp `pubspec.yaml`:

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

Kích hoạt `blocz` như một công cụ toàn cục để sử dụng ở bất kỳ đâu:

```bash
dart pub global activate blocz
```

## Cách sử dụng

### 1. Tạo BLoC, Event, và State

Sử dụng lệnh `make` để tạo các thành phần cần thiết.

```bash
blocz make --domain <domain_name> --name <bloc_name> [--apiPath <path_to_api_file>]
```

- `--domain` (hoặc `-d`): Tên miền hoặc tính năng của BLoC (ví dụ: `user`, `product`).
- `--name` (hoặc `-n`)(tùy chọn): Tên của BLoC (ví dụ: `authentication`, `product_list`).
- `--apiPath` (hoặc `-a`)(tùy chọn): Đường dẫn tùy chọn đến tệp tin API service. Nếu được cung cấp, `blocz` sẽ tự động tạo và triển khai các sự kiện cho tất cả các phương thức công khai (public methods) trong tệp đó.

**Ví dụ:**

Tạo BLoC cơ bản:

```bash
blocz make --domain user
```

> Cấu trúc thư mục được tạo

```
lib/features/user/presentation/bloc/
├── user_bloc.dart
├── user_event.dart
└── user_state.dart
```

Lệnh này tạo ra cấu trúc BLoC. Sau đó, bạn sẽ cần chạy `build_runner`.

Tạo BLoC với việc tự động triển khai sự kiện từ một tệp API:

#### Ví dụ với OpenAPI generator:

```bash
export MY_PET_API_PACKAGE_NAME="my_pet_api"
export MY_PET_API_DIR="./apis/$MY_PET_API_PACKAGE_NAME"
rm -fr $MY_PET_API_DIR || true # xóa thư mục cũ
mkdir -p $MY_PET_API_DIR # tạo nếu chưa có
npx @openapitools/openapi-generator-cli generate 
  -i https://petstore.swagger.io/v2/swagger.json 
  -g dart 
  --additional-properties=pubName=$MY_PET_API_PACKAGE_NAME 
  -o $MY_PET_API_DIR
cd $MY_PET_API_DIR 
  && dart pub get 
  && (dart run build_runner build || true) 
  && cd "$(git rev-parse --show-toplevel)"
ls -lh "./apis/$MY_PET_API_PACKAGE_NAME/lib/api/"
```

```yaml
# trong tệp pubspec.yaml của bạn
dependencies:
  my_pet_api: # Đã thêm gói API cục bộ
    path: ./apis/my_pet_api
```

```bash
blocz make --domain pet --apiPath ./apis/my_pet_api/lib/api/pet_api.dart
```

Lệnh này sẽ tạo các tệp BLoC và cũng sẽ tự động thêm các sự kiện và trình xử lý cho tất cả các phương thức được tìm thấy trong `pet_api.dart`.

```dart
// $PROJECT/lib/features/pet/presentation/bloc/pet_event.dart
part of 'pet_bloc.dart';

@freezed
sealed class PetEvent with _$PetEvent {
  const factory PetEvent.loading() = _PetEventLoading;
  const factory PetEvent.addPet(Pet body) = _AddPetRequested;
  const factory PetEvent.deletePet(int petId, {String? apiKey}) =
      _DeletePetRequested;
  const factory PetEvent.findPetsByStatus(List<String> status) =
      _FindPetsByStatusRequested;
  const factory PetEvent.findPetsByTags(List<String> tags) =
      _FindPetsByTagsRequested;
  const factory PetEvent.getPetById(int petId) = _GetPetByIdRequested;
  const factory PetEvent.updatePet(Pet body) = _UpdatePetRequested;
  const factory PetEvent.updatePetWithForm(
    int petId, {
    String? name,
    String? status,
  }) = _UpdatePetWithFormRequested;
  const factory PetEvent.uploadFile(
    int petId, {
    String? additionalMetadata,
    MultipartFile? file,
  }) = _UploadFileRequested;
}



```

```dart
// $PROJECT/lib/features/pet/presentation/bloc/pet_state.dart
part of 'pet_bloc.dart';

@freezed
sealed class PetState with _$PetState {
  const factory PetState.initial() = _InitialDone;
  const factory PetState.loading() = _Loading;
  const factory PetState.failure(String message) = _Failure;
  const factory PetState.addPetResult() = _AddPetResult;
  const factory PetState.deletePetResult() = _DeletePetResult;
  const factory PetState.findPetsByStatusResult(List<Pet>? data) = _FindPetsByStatusResult;
  const factory PetState.findPetsByTagsResult(List<Pet>? data) = _FindPetsByTagsResult;
  const factory PetState.getPetByIdResult(Pet? data) = _GetPetByIdResult;
  const factory PetState.updatePetResult() = _UpdatePetResult;
  const factory PetState.updatePetWithFormResult() = _UpdatePetWithFormResult;
  const factory PetState.uploadFileResult(ApiResponse? data) = _UploadFileResult;
  // const factory PetState.loaded(dynamic result) = _Loaded;
}


```

**Quan trọng:** Vì các tệp được tạo sử dụng `freezed`, bạn cần chạy `build_runner` sau khi tạo:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Thêm một sự kiện

Sử dụng lệnh `add:event` để thêm một sự kiện mới vào một BLoC đã tồn tại.

```bash
blocz add:event --domain <domain_name> --name <bloc_name> <options>
```

**Các tùy chọn:**

- `--event <event_name>`: Thêm một sự kiện duy nhất, được chỉ định.
- `--apiPath <path_to_api_file>`: Quét tệp API và tạo các sự kiện và trình xử lý cho **tất cả** các phương thức công khai.
- `--apiPath <path_to_api_file> --method <method_name>`: Tạo một sự kiện và trình xử lý chỉ cho **một** phương thức được chỉ định từ tệp API.

**Ví dụ:**

Thêm một sự kiện đơn giản:

```bash
blocz add:event --domain user --name login --event LogoutButtonPressed
```

Thêm tất cả các sự kiện từ một tệp API:

```bash
blocz add:event --domain user --name profile --apiPath ./packages/my_pet_api/lib/api/pet_api.dart
```

Thêm một sự kiện duy nhất từ một phương thức API cụ thể:

```bash
blocz add:event --domain user --name profile --event UpdateAvatar --apiPath lib/features/user/data/api/user_api.dart --method uploadAvatar
```

Lệnh này sẽ cập nhật các tệp BLoC tương ứng để thêm (các) sự kiện mới.

## Các lệnh khác

`blocz` cũng cung cấp nhiều lệnh trợ giúp để phân tích mã nguồn Dart. Sử dụng `blocz --help` để xem tất cả các lệnh có sẵn.
