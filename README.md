# SlowKit
Simple yet powerful MVVM framework for fast iOS develompent.

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory.

## Dependency Injection

### DI Container creation
```swift
let container = Container()
```

### Register per request
```swift
container.register(IService.self)
	.withInit(Service.init)

let service = container.resolve(IService.self)
```

### Register single instance
```swift
container.register(IService.self)
	.withInit(Service.init)
	.singleInstance()

let service = container.resolve(IService.self)
```

## Installation
SlowKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SlowKit'
```

## Author
Alexander Volokhin, volokhin@bk.ru

## License
SlowKit is available under the MIT license. See the LICENSE file for more info.