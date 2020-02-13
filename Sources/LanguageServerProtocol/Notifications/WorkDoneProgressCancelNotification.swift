//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

/// Notification sent from the client to the server to cancel a progress initiated on the server
/// side via `window/workDoneProgress/create`.
///
/// - Parameters:
///   - token: The progress token to cancel.
public struct WorkDoneProgressCancelNotification: NotificationType, Hashable {
  public static let method: String = "window/workDoneProgress/cancel"

  /// The progress token to cancel.
  public var token: ProgressToken

  public init(token: ProgressToken) {
    self.token = token
  }
}
