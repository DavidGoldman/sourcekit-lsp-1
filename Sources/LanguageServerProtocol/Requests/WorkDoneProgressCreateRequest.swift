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

/// Request sent from the server to the client to ask the client to create a work done progress.
///
/// - Parameters:
///   - token: The token to be used to report progress.
///
/// - Returns: Void. If an error occurs, the server must not send any progress notification
///   using the provided token.
public struct WorkDoneProgressCreateRequest: RequestType, Hashable {
  public static let method: String = "window/workDoneProgress/create"
  public typealias Response = VoidResponse

  /// The token to be used to report progress.
  public var token: ProgressToken

  public init(token: ProgressToken) {
    self.token = token
  }
}
