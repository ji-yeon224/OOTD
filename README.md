
<img src = "https://github.com/ji-yeon224/OOTD/assets/69784492/155a5f0d-35eb-4013-b34c-62affc336fc3" width="20%"/>

# 👕 OOTD

<img src = "https://github.com/ji-yeon224/OOTD/assets/69784492/f779e1b1-e0b4-43f7-bc3a-06ffc2328653" width="80%"/>
</br>

## 🗓️ 프로젝트
- 개인 프로젝트
- 2023.11.13 ~ 2023.12.23
</br>
  

## ✏️ 한 줄 소개
-  사용자들 간 옷 정보를 공유할 수 있는 커뮤니티 어플리케이션

</br>


## 💻 기술 스택
- `MVVM`
- `RxSwift`, `RxDataSource`
- `UIKit`
- `Moya`, `Codable`, `Kingfisher`
- `Snapkit`, `AutoLayout`
- `DiffableDataSource`, `CompositionalLayout`
- `Tabman`, `Toast`, `IQKeyboardManager`

</br>

## 📖 프로젝트 목표

- 서버와의 통신을 통해 `Error Handling` 
- `Moya Intercepter`를 통해 JWT Token 관리하여 사용자 인증 처리
- `RxSwift`와 `MVVM` `Input-Ouput 패턴`을 적용하여 코드의 가독성 높이기
</br>


##  🔎 주요 기능
### ✔️ 회원가입, 로그인
<img src = "https://github.com/ji-yeon224/OOTD/assets/69784492/32588db8-d6d1-4692-88c7-04dedbfdac8d" width="80%"/>

- 이메일 유효성 체크 api를 통해 서버 내에 이미 존재하는 이메일인지 확인하도록 하였다.
</br>

### ✔️ JWT Token 관리
- `Alamofire Intercepter`를 이용하여 token 값이 유효한지 체크하여 토큰 갱신을 하거나 refresh token이 만료됐을 시 다시 로그인 하도록 유도하였다.
</br>

### ✔️ 게시물 작성 및 조회, 댓글 작성
<img src = "https://github.com/ji-yeon224/OOTD/assets/69784492/3db28b84-e702-434f-9d2d-5e4c4f3effd1" width="90%"/>

- `Compositional Layout`과 `RxDataSource`를 사용하여 서버에서 받아온 데이터를 CollectionView와 TableView를 통해 구현하였다. 
- `PHPickerViewController`를 통해 게시물 작성 시 사용자의 앨범에 있는 사진을 업로드할 수 있도록 하였다. 
</br>

### ✔️ 내 정보 조회 및 수정
<img src = "https://github.com/ji-yeon224/OOTD/assets/69784492/32caaec8-a942-48cf-8285-997f343bccd4" width="80%"/>

- `Tabman` 라이브러리를 이용하여 사용자가 작성한 게시글을 카테고리 별로 나눠 볼 수 있도록 구현하였다. 

</br>



## 🚨 트러블 슈팅
### 이미지 캐싱
- `Kingfisher`를 이용하여 게시판의 이미지 썸네일 로드 시 메모리를 최대 300MB까지 사용하게 되는 문제가 발생하였다. 
- Kingfisher에서 제공하는 이미지 캐싱 기능을 통해 이미 캐싱되어 있는 이미지라면 캐싱 데이터에서 이미지를 로드하여 보여주고, 캐싱되지 않은 이미지는 새로 다운로드 하여 캐시 데이터로 저장하는 방식으로 메서드를 구현하여 사용하였더니 이미지 로드 시 약 74MB까지 메모리 사용량을 줄일 수 있었다.

```swift 
func setImage(with urlString: String, resize width: CGFloat? = nil, cornerRadius: CGFloat = 15, completion: (() -> Void)? = nil) {

        let cornerImageProcessor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        ImageCache.default.retrieveImage(forKey: urlString, options: [
            .requestModifier(ImageLoadManager.shared.getModifier()),
            .transition(.fade(1.0)),
            .processor(cornerImageProcessor)
        ]) { [weak self] result in
            guard let self = self else { return }
            self.kf.indicatorType = .activity
            switch result {
            case .success(let value):
	            // 캐시된 데이터가 존재하면
                if let image = value.image {
                    self.image = image.resize(width: width)
                    completion?()

                } else { // 캐시된 데이터가 없다면
                    guard let url = URL(string: self.getPhotoURL(urlString)) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource, options: [
                        .requestModifier(ImageLoadManager.shared.getModifier()),
                        .transition(.fade(1.0)),
                        .processor(cornerImageProcessor)
                    ]) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let result):
                            self.image = result.image.resize(width: width)
                            completion?()
                        case .failure(_):
                            self.image = Constants.Image.errorPhoto?.withTintColor(Constants.Color.background)
                        }
                    }
                }
            case .failure(let error):
	            self.image = Constants.Image.errorPhoto?.withTintColor(Constants.Color.background)
                debugPrint(error)
            }
        }
    }
```


### PHPickerViewController 사진 로드 시 메모리 과사용

- `PHPickerViewController`를 이용하여 사용자의 앨범에서 여러 개의 이미지를 가져올 때 메모리가 사용된 후 메모리가 해제 되지 않는 문제가 발생하였다. 
- PHPickerViewController를 PHPickerManger를 통해 `싱글톤`으로 생성하여 present & dismiss로 구현하여 메모리가 해제되도록 하였다. 
- 선택한 이미지는 `RxSwift PublishSubject`를 통해 전달하도록 구현하였다.
```swift
final class PHPickerManager {

    static let shared = PHPickerManager()
    private init() { }

    private weak var viewController: UIViewController?
    private var fullScreenType: Bool = false
    private let group = DispatchGroup()
    
    let selectedImage = PublishSubject<[UIImage]>()
    var disposeBag = DisposeBag()

    func presentPicker(vc: UIViewController, selectLimit: Int = 1, fullScreenType: Bool) {

        self.viewController = vc
        self.fullScreenType = fullScreenType
        self.disposeBag = DisposeBag()
        
        let filter = PHPickerFilter.images
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        ... // PHPicker configuration

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController?.present(picker, animated: true)

    }

}

extension PHPickerManager: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var imgList: [UIImage] = []

        guard let viewController else {return}
        if results.isEmpty {
            viewController.dismiss(animated: true)
        } else {
            results.forEach {
                self.group.enter()
                let item = $0.itemProvider
                item.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        guard let img = image as? UIImage else { return }
                        imgList.append(img)
                        self.group.leave()
                    }
                }
            }
           // loadObject가 비동기로 동작하기 때문에 dispatchGroup을 통해 이미지 한 번에 전달
            group.notify(queue: DispatchQueue.main) {
                self.selectedImage.onNext(imgList)
                self.viewController?.dismiss(animated: !self.fullScreenType)
            }
        }
    }
}
```

<img src = "https://github.com/ji-yeon224/OOTD/assets/69784492/666121f5-3398-421b-9416-1c3ce8e00a3f" width="85%"/>

### Codable TypeMismatch
- 커서 기반 페이지네이션 구현 중 서버에서 응답받은 커서 값이 마지막 페이지일 때는 Int로, 다음 페이지가 있을 때는 String으로 반환하여 **디코딩 TypeMismatch 오류**가 발생하였다. 
-  **init** 구문을 통해 전달 받은 값의 타입을 체크하여 예외처리 하는 방식으로 해결하였다.
- 응답 데이터 구조체 내부에서 init 구문을 통해 확인 시 응답 받을 데이터 모두 체크해야하는 번거로움이 있었고, `PropertyWrapper`를 통해 원하는 데이터의 타입만 체크할 수 있도록 구현하였다.
```swift
@propertyWrapper
struct NextCursorType {
    var wrappedValue: String
}

extension NextCursorType: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let nextCursor = try? container.decode(String.self) {
            wrappedValue = nextCursor
        } else {
            wrappedValue = "0"
        }
    }
}
```

```swift
struct ReadResponse: Codable {
    let data: [Post]
    @NextCursorType var nextCursor: String

    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
}
```
### invalidateLayout
- `RxDataSource`를 사용하여 셀에 서버에서 받은 이미지를 적용할 때 이미지의 크기 조절이 되지 않는 문제가 발생하였다. Kingfisher를 통해 다운 받는 이미지는 **비동기로 동작**하기 때문에 이미지 다운로드가 완료되지 않은 채로 imageView의 layout을 잡기 때문에 발생하는 문제였다.
- 이미지 다운로드가 완료되면 completion handler를 통해 알리고, `invalidateLayout`을 호출하여 **CollectionView 레이아웃을 재구성**하도록 하여 해결하였다.
```swift
lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PostListModel> { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OOTDCollectionViewCell.identifier, for: indexPath) as? OOTDCollectionViewCell else { return UICollectionViewCell()}

        if item.image.count > 0 {
            cell.imageView.setImage(with: item.image[0], resize: Constants.Design.deviceWidth, cornerRadius: 0 ) {
                collectionView.collectionViewLayout.invalidateLayout()
            }

        }
}
```
