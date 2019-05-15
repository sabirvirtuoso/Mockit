//
//  Mockit
//
//  Copyright (c) 2016 Syed Sabir Salman-Al-Musawi <sabirvirtuoso@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/**
 * `MockMatcher` is used to match expected arguments with actual arguments based on argument types
 * and using custom type matchers if necessary.
 */
open class MockMatcher {

  public static let sharedInstance = MockMatcher()

  fileprivate var typeMatchers = [String: TypeMatcher]()

  fileprivate init() {
    typeMatchers[String(describing: OptionalArrayMatcher.self)] = OptionalArrayMatcher()
    typeMatchers[String(describing: NonOptionalArrayMatcher.self)] = NonOptionalArrayMatcher()
    typeMatchers[String(describing: OptionalDictionaryMatcher.self)] = OptionalDictionaryMatcher()
    typeMatchers[String(describing: NonOptionalDictionaryMatcher.self)] = NonOptionalDictionaryMatcher()
    typeMatchers[String(describing: StringMatcher.self)] = StringMatcher()
    typeMatchers[String(describing: IntMatcher.self)] = IntMatcher()
    typeMatchers[String(describing: DoubleMatcher.self)] = DoubleMatcher()
    typeMatchers[String(describing: FloatMatcher.self)] = FloatMatcher()
    typeMatchers[String(describing: BoolMatcher.self)] = BoolMatcher()
  }

  open func match(arguments args: Any?, withArguments withArgs: Any?) -> Bool {
    switch(args, withArgs) {
      case (nil, nil): return true
      case (nil, _): return false
      case (_, nil): return false
      case (_, _): return matchTypes(arguments: args!, withArguments: withArgs!)
    }
  }

  open func register(_ type: Any, typeMatcher: TypeMatcher) {
    let typeKey = String(describing: type)

    typeMatchers[typeKey] = typeMatcher
  }

  open func unregister(_ type: Any) {
    let typeKey = String(describing: type)

    guard typeExists(forKey: typeKey) else {
      return
    }

    typeMatchers.removeValue(forKey: typeKey)
  }

  fileprivate func typeExists(forKey typeKey: String) -> Bool {
    if let _ = typeMatchers[typeKey] {
      return true
    }

    return false
  }

  fileprivate func matchTypes(arguments args: Any, withArguments withArgs: Any) -> Bool {
    var argumentsMatched = false

    for (_, typeMatcher) in typeMatchers {
      if typeMatcher.match(argument: args, withArgument: withArgs) {
        argumentsMatched = true

        break
      }
    }

    return argumentsMatched
  }

}
