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
public class MockMatcher {

  public static let sharedInstance = MockMatcher()

  private var typeMatchers = [String: TypeMatcher]()

  private init() {
    typeMatchers[String(OptionalArrayMatcher.self)] = OptionalArrayMatcher()
    typeMatchers[String(NonOptionalArrayMatcher.self)] = NonOptionalArrayMatcher()
    typeMatchers[String(OptionalDictionaryMatcher.self)] = OptionalDictionaryMatcher()
    typeMatchers[String(NonOptionalDictionaryMatcher.self)] = NonOptionalDictionaryMatcher()
    typeMatchers[String(StringMatcher.self)] = StringMatcher()
    typeMatchers[String(IntMatcher.self)] = IntMatcher()
    typeMatchers[String(DoubleMatcher.self)] = DoubleMatcher()
    typeMatchers[String(FloatMatcher.self)] = FloatMatcher()
    typeMatchers[String(BoolMatcher.self)] = BoolMatcher()
  }

  public func match(arguments args: Any?, withArguments withArgs: Any?) -> Bool {
    switch(args, withArgs) {
      case (nil, nil): return true
      case (nil, _): return false
      case (_, nil): return false
      case (_, _): return matchTypes(arguments: args!, withArguments: withArgs!)
    }
  }

  public func register(type: Any, typeMatcher: TypeMatcher) {
    let typeKey = String(type)

    typeMatchers[typeKey] = typeMatcher
  }

  public func unregister(type: Any) {
    let typeKey = String(type)

    guard typeExists(forKey: typeKey) else {
      return
    }

    typeMatchers.removeValueForKey(typeKey)
  }

  private func typeExists(forKey typeKey: String) -> Bool {
    if let _ = typeMatchers[typeKey] {
      return true
    }

    return false
  }

  private func matchTypes(arguments args: Any, withArguments withArgs: Any) -> Bool {
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
