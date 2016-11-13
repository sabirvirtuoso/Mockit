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
 * `TypeMatcher` provides an API for default or custom matchers to implement.
 */
public protocol TypeMatcher {

  func match(argument arg: Any, withArgument withArg: Any) -> Bool

}


// MARK:- `String` matcher implementation


public class StringMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as String, let secondArg as String):
        return firstArg == secondArg
      default:
        return false
    }
  }

}


// MARK:- `Bool` matcher implementation


public class BoolMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Bool, let secondArg as Bool):
        return firstArg == secondArg
      default:
        return false
    }
  }

}


// MARK:- `Int` matcher implementation


public class IntMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Int, let secondArg as Int):
        return firstArg == secondArg
      default:
        return false
    }
  }

}


// MARK:- `Double` matcher implementation


public class DoubleMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Double, let secondArg as Double):
        return firstArg == secondArg
      default:
        return false
    }
  }

}


// MARK:- `Float` matcher implementation


public class FloatMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Float, let secondArg as Float):
        return firstArg == secondArg
      default:
        return false
    }
  }

}


// MARK:- `OptionalArray` matcher implementation


public class OptionalArrayMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
    case (let firstArg as Array<Any?>, let secondArg as Array<Any?>):
      return match(firstArg, withArray: secondArg)
    case (let firstArg as Array<String?>, let secondArg as Array<String?>):
      return match(firstArg, withArray: secondArg)
    case (let firstArg as Array<Int?>, let secondArg as Array<Int?>):
      return match(firstArg, withArray: secondArg)
    case (let firstArg as Array<Bool?>, let secondArg as Array<Bool?>):
      return match(firstArg, withArray: secondArg)
    case (let firstArg as Array<Float?>, let secondArg as Array<Float?>):
      return match(firstArg, withArray: secondArg)
    case (let firstArg as Array<Double?>, let secondArg as Array<Double?>):
      return match(firstArg, withArray: secondArg)
    default:
      return false
    }
  }

  fileprivate func match<T: Any>(_ array: Array<T?>, withArray: Array<T?>) -> Bool {
    guard array.count == withArray.count else {
      return false
    }

    return Array(zip(array, withArray)).filter {
      MockMatcher.sharedInstance.match(arguments: $0, withArguments: $1)
    }.count == array.count
  }

}


// MARK:- `NonOptionalArray` matcher implementation


public class NonOptionalArrayMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Array<Any>, let secondArg as Array<Any>):
        return match(firstArg, withArray: secondArg)
      case (let firstArg as Array<String>, let secondArg as Array<String>):
        return match(firstArg, withArray: secondArg)
      case (let firstArg as Array<Int>, let secondArg as Array<Int>):
        return match(firstArg, withArray: secondArg)
      case (let firstArg as Array<Bool>, let secondArg as Array<Bool>):
        return match(firstArg, withArray: secondArg)
      case (let firstArg as Array<Float>, let secondArg as Array<Float>):
        return match(firstArg, withArray: secondArg)
      case (let firstArg as Array<Double>, let secondArg as Array<Double>):
        return match(firstArg, withArray: secondArg)
      default:
        return false
    }
  }

  fileprivate func match<T: Any>(_ array: Array<T>, withArray: Array<T>) -> Bool {
    guard array.count == withArray.count else {
      return false
    }

    return Array(zip(array, withArray)).filter {
      MockMatcher.sharedInstance.match(arguments: $0, withArguments: $1)
    }.count == array.count
  }

}


// MARK:- `OptionalDictionary` matcher implementation


public class OptionalDictionaryMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Dictionary<String, Any?>, let secondArg as Dictionary<String, Any?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, String?>, let secondArg as Dictionary<String, String?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Int?>, let secondArg as Dictionary<String, Int?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Bool?>, let secondArg as Dictionary<String, Bool?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Float?>, let secondArg as Dictionary<String, Float?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Double?>, let secondArg as Dictionary<String, Double?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Any?>, let secondArg as Dictionary<Int, Any?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, String?>, let secondArg as Dictionary<Int, String?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Int?>, let secondArg as Dictionary<Int, Int?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Bool?>, let secondArg as Dictionary<Int, Bool?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Float?>, let secondArg as Dictionary<Int, Float?>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Double?>, let secondArg as Dictionary<Int, Double?>):
        return match(firstArg, withDictionary: secondArg)
      default:
        return false
    }
  }

  fileprivate func match<T1: Any, T2: Any>(_ dictionary: Dictionary<T1, T2?>, withDictionary: Dictionary<T1, T2?>) -> Bool {
    var firstDictionaryKeys = Array<T1>()
    var secondDictionaryKeys = Array<T1>()

    dictionary.keys.forEach { (key) -> () in
      firstDictionaryKeys.append(key)
    }

    withDictionary.keys.forEach { (key) -> () in
      secondDictionaryKeys.append(key)
    }

    guard MockMatcher.sharedInstance.match(arguments: firstDictionaryKeys, withArguments: secondDictionaryKeys) else {
      return false
    }

    return Array(zip(firstDictionaryKeys, secondDictionaryKeys)).filter {
      MockMatcher.sharedInstance.match(arguments: dictionary[$0]!, withArguments: withDictionary[$1]!)
    }.count == firstDictionaryKeys.count
  }

}


// MARK:- `NonOptionalDictionary` matcher implementation


public class NonOptionalDictionaryMatcher: TypeMatcher {

  public func match(argument arg: Any, withArgument withArg: Any) -> Bool {
    switch (arg, withArg) {
      case (let firstArg as Dictionary<String, Any>, let secondArg as Dictionary<String, Any>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, String>, let secondArg as Dictionary<String, String>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Int>, let secondArg as Dictionary<String, Int>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Bool>, let secondArg as Dictionary<String, Bool>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Float>, let secondArg as Dictionary<String, Float>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<String, Double>, let secondArg as Dictionary<String, Double>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Any>, let secondArg as Dictionary<Int, Any>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, String>, let secondArg as Dictionary<Int, String>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Int>, let secondArg as Dictionary<Int, Int>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Bool>, let secondArg as Dictionary<Int, Bool>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Float>, let secondArg as Dictionary<Int, Float>):
        return match(firstArg, withDictionary: secondArg)
      case (let firstArg as Dictionary<Int, Double>, let secondArg as Dictionary<Int, Double>):
        return match(firstArg, withDictionary: secondArg)
      default:
        return false
    }
  }

  fileprivate func match<T1: Any, T2: Any>(_ dictionary: Dictionary<T1, T2>, withDictionary: Dictionary<T1, T2>) -> Bool {
    var firstDictionaryKeys = Array<T1>()
    var secondDictionaryKeys = Array<T1>()

    dictionary.keys.forEach { (key) -> () in
      firstDictionaryKeys.append(key)
    }

    withDictionary.keys.forEach { (key) -> () in
      secondDictionaryKeys.append(key)
    }

    guard MockMatcher.sharedInstance.match(arguments: firstDictionaryKeys, withArguments: secondDictionaryKeys) else {
      return false
    }

    return Array(zip(firstDictionaryKeys, secondDictionaryKeys)).filter {
      MockMatcher.sharedInstance.match(arguments: dictionary[$0], withArguments: withDictionary[$1])
    }.count == firstDictionaryKeys.count
  }

}
