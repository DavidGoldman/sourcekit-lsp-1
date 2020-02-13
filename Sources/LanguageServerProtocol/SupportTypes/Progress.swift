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

import Foundation

/// A unique identifier (token) provided by the client or server.
/// This token is different than the request ID which allows out of band progress reporting a
/// well as progress for notifications.
public enum ProgressToken: Hashable {
  case number(Int)
  case string(String)
}

extension ProgressToken: Codable {
  public init(from decoder: Decoder) throws {
    let value = try decoder.singleValueContainer()
    if let intValue = try? value.decode(Int.self) {
      self = .number(intValue)
    } else if let strValue = try? value.decode(String.self) {
      self = .string(strValue)
    } else {
      throw MessageDecodingError.invalidRequest("could not decode progress token")
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let value):
      try container.encode(value)
    case .number(let value):
      try container.encode(value)
    }
  }
}

extension ProgressToken: CustomStringConvertible {
  public var description: String {
    switch self {
    case .number(let n): return String(n)
    case .string(let s): return "\"\(s)\""
    }
  }
}

/// Begin progress reporting.
public struct WorkDoneProgressBegin: Hashable {
  /// Mandatory title of the operation. Should briefly inform about the kind of operation
  /// being performed.
  public var title: String

  /// Controls whether or not the user may cancel the long running operation.
  /// Clients that don't support cancellation may ignore this setting.
  public var cancellable: Bool?

  /// More detail about the progress, containing complementary information to the `title`.
  public var message: String?

  /// Progress percentage to display (value 100 is considered 100%). Must be reported initially
  /// or clients are allowed to assume infinite progress and ignore this value.
  ///
  /// This value should be steadily increasing.
  public var percentage: Int?
}

/// Report new progress for a previously started report.
public struct WorkDoneProgressReport: Hashable {
  /// Controls the enablement state of a cancel button.
  /// Clients that don't support cancellation or enablement state may ignore this setting.
  public var cancellable: Bool?

  /// More detail about the progress, containing complementary information to the `title`.
  /// If unset, the previous progress message (if any) is still valid.
  public var message: String?

  /// Progress percentage to display (value 100 is considered 100%). Must be reported initially
  /// or clients are allowed to assume infinite progress and ignore this value.
  ///
  /// This value should be steadily increasing.
  public var percentage: Int?
}

extension WorkDoneProgressBegin: LSPAnyCodable {
  public init?(fromLSPDictionary dictionary: [String : LSPAny]) {
    guard case .string(let kind) = dictionary["kind"] else { return nil }
    guard kind == "begin" else { return nil }

    guard case .string(let title) = dictionary["title"] else { return nil }
    self.title = title

    if case .bool(let cancellable) = dictionary["cancellable"] {
      self.cancellable = cancellable
    }
    if case .string(let message) = dictionary["message"] {
      self.message = message
    }
    if case .int(let percentage) = dictionary["percentage"] {
      self.percentage = percentage
    }
  }

  public func encodeToLSPAny() -> LSPAny {
    var dict: [String: LSPAny] = [
      "kind": .string("begin"),
      "title": .string(self.title),
    ]
    if let cancellable = self.cancellable {
      dict["cancellable"] = .bool(cancellable)
    }
    if let message = self.message {
      dict["message"] = .string(message)
    }
    if let percentage = self.percentage {
      dict["percentage"] = .int(percentage)
    }
    return .dictionary(dict)
  }
}

extension WorkDoneProgressReport: LSPAnyCodable {
  public init?(fromLSPDictionary dictionary: [String : LSPAny]) {
    guard case .string(let kind) = dictionary["kind"] else { return nil }
    guard kind == "report" else { return nil }

    if case .bool(let cancellable) = dictionary["cancellable"] {
      self.cancellable = cancellable
    }
    if case .string(let message) = dictionary["message"] {
      self.message = message
    }
    if case .int(let percentage) = dictionary["percentage"] {
      self.percentage = percentage
    }
  }

  public func encodeToLSPAny() -> LSPAny {
    var dict: [String: LSPAny] = ["kind": .string("report")]
    if let cancellable = self.cancellable {
      dict["cancellable"] = .bool(cancellable)
    }
    if let message = self.message {
      dict["message"] = .string(message)
    }
    if let percentage = self.percentage {
      dict["percentage"] = .int(percentage)
    }
    return .dictionary(dict)
  }
}

/// Signal the end of progress reporting.
public struct WorkDoneProgressEnd: Hashable {
  /// Final message to display, indicating the outcome of the operation.
  public var message: String?
}

extension WorkDoneProgressEnd: LSPAnyCodable {
  public init?(fromLSPDictionary dictionary: [String : LSPAny]) {
    guard case .string(let kind) = dictionary["kind"] else { return nil }
    guard kind == "end" else { return nil }

    if case .string(let message) = dictionary["message"] {
      self.message = message
    }
  }

  public func encodeToLSPAny() -> LSPAny {
    var dict: [String: LSPAny] = ["kind": .string("end")]
    if let message = self.message {
      dict["message"] = .string(message)
    }
    return .dictionary(dict)
  }
}
