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
 * `Actionable<T>` is responsible for registering actions on a particular stub and
 * performing them when a real call is made.
 */
open class Actionable<T>: ActionPerformer {

  fileprivate var actions = [Action<T>]()

  fileprivate weak var stub: Stub!

  fileprivate let dummyReturnValue: T

  init(ofStub stub: Stub, withReturnValue dummyReturnValue: T) {
    self.stub = stub
    self.dummyReturnValue = dummyReturnValue
  }

  open func thenReturn(_ values: T...) -> Actionable<T> {
    for value in values {
      let actionBlock = { () -> T in
        return value
      }

      let action = Action(withBlock: actionBlock, returnsValue: true)
      addAction(action)
    }

    return self
  }

  open func thenDo(_ closure: @escaping (_ args: [Any?]) -> Void) -> Actionable<T> {
    let actionBlock = { [unowned self] () -> T in
      closure(self.stub.actualArgs)

      return self.dummyReturnValue
    }

    let action = Action(withBlock: actionBlock)
    addAction(action)

    return self
  }

  open func thenAnswer(_ closure: @escaping (_ args: [Any?]) -> T) -> Actionable<T> {
    let actionBlock = { [unowned self] () -> T in
      return closure(self.stub.actualArgs)
    }

    let action = Action(withBlock: actionBlock, returnsValue: true)
    addAction(action)

    return self
  }

  fileprivate func addAction(_ action: Action<T>) {
    actions.append(action)
  }

  open func performActions() -> Any? {
    guard actions.count > 0 else {
      return dummyReturnValue
    }

    let action = actions[indexOfAction()]

    return performAction(action)
  }

  fileprivate func indexOfAction() -> Int {
    return stub.callCount > actions.count ? actions.count - 1 : stub.callCount - 1
  }

  fileprivate func performAction(_ action: Action<T>) -> Any? {
    var returnValue: Any?

    if action.providesReturnValue() {
      returnValue = action.performAction()
    } else {
      let _ = action.performAction()
    }

    return returnValue
  }

}
