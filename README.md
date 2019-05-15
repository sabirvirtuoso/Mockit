# Mockit

[![Build Status](https://travis-ci.org/sabirvirtuoso/Mockit.svg?branch=master)](https://travis-ci.org/sabirvirtuoso/Mockit)
[![Coverage Status](https://coveralls.io/repos/github/sabirvirtuoso/Mockit/badge.svg?branch=master)](https://coveralls.io/github/sabirvirtuoso/Mockit?branch=master)
[![Code Climate](https://codeclimate.com/github/sabirvirtuoso/Mockit/badges/gpa.svg)](https://codeclimate.com/github/sabirvirtuoso/Mockit)
[![Version](https://img.shields.io/cocoapods/v/Mockit.svg?style=flat)](http://cocoapods.org/pods/Mockit)
[![License](https://img.shields.io/cocoapods/l/Mockit.svg?style=flat)](http://cocoapods.org/pods/Mockit)
[![Platform](https://img.shields.io/cocoapods/p/Mockit.svg?style=flat)](http://cocoapods.org/pods/Mockit)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)

![Mockit GIF](Mockit.png)

## Introduction

`Mockit` is a **Tasty mocking framework for unit tests in Swift 5.0**. It's at an early stage of development, but its current features are almost completely usable.

`Mockit` is a mocking framework that tastes brilliant. It lets you write beautiful tests with a clean & simple API. Tests written using `Mockit` are very readable and they produce clean verification errors. It's inspired by the famous mocking framework for Java - [Mockito](http://mockito.org/).

## Documentation

`Mockit` is yet to be documented fully but it comes with a sample project that lets you try all its features and become familiar with the API. You can find it in `Mockit.xcworkspace`. 

There's an example test file called ```ExampleTests.swift```. Look there for some tests that can be run. This tests a class ```Example``` against a mocked collaborator ```ExampleCollaborator```. 

File an issue if you have any question.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Limitations

* There's some boiler-plate code needed to create mocks. See ```MockExampleCollaborator``` for an example in the *Basic Usage* section below. However, a plugin development is on its way for both `Xcode` and `AppCode` to minimize writing this boiler-plate code every time a mock needs to be created.

## Features

- **Stubbing**. *Mockit* lets you stub a method and then perform any of 3 actions (`thenReturn`, `thenDo`, `thenAnswer`) individually or in any order via chaining;
- **Mocking**. You can create a subclass extending the ```Mock``` protocol to mock required methods;
- **Call Verification**. You can verify method calls using one of 8 supported modes (`Once`, `AtLeastOnce`, `AtMostOnce`, `Times`, `AtLeastTimes`, `AtMostTimes`, `Never` and `Only`);
- **Arguments of specific call**. *Mockit* allows you to obtain the arguments of a specific method call to use custom assertions on them;
- **Helpful messages**. If method verification fails or something goes wrong, Mockit provides readable messages that describes the issue;
- **Default Type matchers**. Out of the box, *Mockit* can match the following types:

  * String / String?
  * Bool / Bool?
  * Int / Int?
  * Double / Double?
  * Float / Float?
  * Array / Array? of the above primitive types
  * Dictionary / Dictionary? of the above primitive types

Given that Swift does not have reflection, *Mockit* cannot magically match your custom types, so you need to subclass ```TypeMatcher``` protocol to write 
your one custom type matcher. For an example, see the *Basic Usage* section below.

## Basic Usage

The examples below assume we are mocking this class:

```swift
class ExampleCollaborator {

    func voidFunction() {
    }

    func function(int: Int, _ string: String) -> String {
      return ""
    }

    func stringDictFunction(dict: [String: String]) -> String {
      return ""
    }

}
```

In your test code, you'll need to create a ```MockExampleCollaborator```, which extends ```ExampleCollaborator``` and adopts ```Mock```. The mock creates a ```CallHandler```, and forwards all calls to it:

```swift
class MockExampleCollaborator: ExampleCollaborator, Mock {

    let callHandler: CallHandler

    init(testCase: XCTestCase) {
      callHandler = CallHandlerImpl(withTestCase: testCase)
    }

    func instanceType() -> MockExampleCollaborator {
      return self
    }

    override func voidFunction() {
      callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: nil)
    }

    override func function(int: Int, _ string: String) -> String {
      return callHandler.accept("", ofFunction: #function, atFile: #file, inLine: #line, withArgs: int, string) as! String
    }

    override func stringDictFunction(dict: Dictionary<String, String>) -> String {
      return callHandler.accept("", ofFunction: #function, atFile: #file, inLine: #line, withArgs: dict) as! String
    }

}
```

To write a custom type matcher: 

```swift
public class CustomMatcher: TypeMatcher {

    public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
      switch (arg, withArg) {
        case ( _ as CustomType, _ as CustomType):
          // custom matching code here
          return true
        default:
          return false
      }
    }

}
```

It is good practice to put the mock objects and custom type matchers in a separate group in the test part of your project.

### Currently-supported syntax

```swift
// stub a call on a method with parameters, then return value
mockCollaborator.when().call(withReturnValue: mockCollaborator.function(42, "frood")).thenReturn("hoopy")
```

```swift
// stub a call on a method with dictionary parameter, then answer value
mockCollaborator.when().call(withReturnValue: mockCollaborator.stringDictFunction(["Hello": "Pong"])).thenAnswer {
      (args: [Any?]) -> String in

      // custom code here
    }
```

```swift
// stub a call on a void method , then do action
mockCollaborator.when().call(withReturnValue: mockCollaborator.voidFunction()).thenDo {
      (args: [Any?]) -> Void in

      // if the call is received, this closure will be executed
      print("===== thenDo closure called =====")
    }
```

```swift
// stub a call on a method , then return values on multiple calls
mockCollaborator.when().call(withReturnValue: mockCollaborator.stringDictFunction(["Hello": "Pong"])).thenReturn("ping", "hoopy")
```

```swift
// stub a call on a method , then chain multiple actions for corresponding calls
mockCollaborator.when().call(withReturnValue: mockCollaborator.stringDictFunction(["Hello": "Pong"])).thenReturn("ping", "hoopy").thenAnswer {
      (args: [Any?]) -> String in

      // custom code here
    }
```

```swift
// call a method and then get arguments of a specific call which can be asserted later
systemUnderTest.doSomethingWithParamters(42, "frood")
systemUnderTest.doSomethingWithParamters(18, "hoopy")

let argumentsOfFirstCall = mockCollaborator.getArgs(callOrder: 1).of(mockCollaborator.function(AnyValue.int, AnyValue.string))
let argumentsOfSecondCall = mockCollaborator.getArgs(callOrder: 2).of(mockCollaborator.function(AnyValue.int, AnyValue.string))
```

With nice mocks, Mockit supports the **"verify expectations after mocking"** style using **8 supported verification modes**

```swift
// call method on the system under test
systemUnderTest.expectMethodOneAndThree()

// Then
mockCollaborator.verify(verificationMode: Once()).methodOne()
mockCollaborator.verify(verificationMode: Never()).methodTwo()
mockCollaborator.verify(verificationMode: Once()).methodThree()


// call method on the system under test
sut.expectMethodOneTwice()

// Then
mockCollaborator.verify(verificationMode: Times(times: 2)).methodOne()


// call method on the system under test
sut.expectOnlyMethodThree()

// Then
mockCollaborator.verify(verificationMode: Only()).methodThree()


// call method on system under test
sut.expectAllThreeMethods()

// Then
mockCollaborator.verify(verificationMode: Once()).methodOne()
mockCollaborator.verify(verificationMode: AtLeastOnce()).methodTwo()
mockCollaborator.verify(verificationMode: AtMostOnce()).methodThree()


// call method on the system under test
sut.expectMethodTwoAndThree()

// Then
mockCollaborator.verify(verificationMode: AtLeastTimes(times: Times(times: 1))).methodTwo()
mockCollaborator.verify(verificationMode: Never()).methodOne()
mockCollaborator.verify(verificationMode: AtMostTimes(times: Times(times: 3))).methodThree()
```
## Requirements

* Xcode 9+
* XCTest

## Installation

Mockit is built with Swift 5.0.

#### CocoaPods

Mockit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mockit', '1.5.0'
```

#### Manually
1. Download and drop ```/Mockit``` folder in your project.  
2. Congratulations!  

## Feedback

Issues and pull-requests are most welcome - especially about improving the API further.

## Author

Syed Sabir Salman-Al-Musawi, sabirvirtuoso@gmail.com

I'd also like to thank [**Sharafat Ibn Mollah Mosharraf**](sharafat_8271@yahoo.co.uk) for his big support during the API design and development phase.

## License

**Mockit** is available under the **MIT license**. See the `LICENSE` file for more info.

The PNG at the top of this `README.md` is from [www.mockit.co.uk/about.html](http://www.mockit.co.uk/about.html)
