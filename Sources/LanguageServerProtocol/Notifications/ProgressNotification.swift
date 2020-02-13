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

/// Notification to report progress in a generic fashion.
///
/// This may be used to report any kind of progress:
/// - Work done progress (usually shown in a UI with a progress bar)
/// - Partial result progress to support streaming of results
///
/// As with any `$` notification, the client/server is free to ignore this notification.
///
/// - Parameters:
///   - token: The progress token provided by the client or server.
///   - value: The progress data.
public struct ProgressNotification: NotificationType, Hashable {
  public static let method: String = "$/progress"

  /// The progress token provided by the client or server.
  public var token: ProgressToken

  /// The progress data.
  public var value: LSPAny

  public init(token: ProgressToken, value: LSPAny) {
    self.token = token
    self.value = value
  }
}
