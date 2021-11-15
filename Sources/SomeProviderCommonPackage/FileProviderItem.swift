//
//  FileProviderItem.swift
//  SomeProvider
//
//  Created by Peter Thomas Horn on 09.03.21.
//

import FileProvider
import UniformTypeIdentifiers

@available(macOS 12, *)
public class FileProviderItem: NSObject, NSFileProviderItem, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    private let identifier: NSFileProviderItemIdentifier
    private let size: NSNumber

    public init(identifier: NSFileProviderItemIdentifier, size: Int) {
        self.identifier = identifier
        self.size = NSNumber(value: size)
    }

    public required init(coder decoder: NSCoder) {
        identifier = NSFileProviderItemIdentifier(decoder.decodeObject(of: NSString.self, forKey: "identifier") as String? ?? "")
        size = decoder.decodeObject(of: NSNumber.self, forKey: "size") ?? NSNumber(0)
    }

    public func encode(with encoder: NSCoder) {
        encoder.encode(identifier, forKey: "identifier")
        encoder.encode(size, forKey: "size")
    }

    public var itemIdentifier: NSFileProviderItemIdentifier {
        return identifier
    }

    public var parentItemIdentifier: NSFileProviderItemIdentifier {
        return .rootContainer
    }

    public var documentSize: NSNumber? {
        return self.size
    }

    public var lastUsedDate: Date? {
        return Date.now
    }

    public var capabilities: NSFileProviderItemCapabilities {
        let result: NSFileProviderItemCapabilities = [
            .allowsAddingSubItems,
            .allowsContentEnumerating,
            .allowsDeleting,
            .allowsReading,
            .allowsRenaming,
            .allowsReparenting,
            .allowsWriting,
            .allowsEvicting,
            .allowsExcludingFromSync,
            .allowsTrashing
        ]
        return result
    }

    public var itemVersion: NSFileProviderItemVersion {
        NSFileProviderItemVersion(contentVersion: "a content version".data(using: .utf8)!, metadataVersion: "a metadata version".data(using: .utf8)!)
    }

    public var filename: String {
        return identifier.rawValue
    }

    public var contentType: UTType {
        return identifier == NSFileProviderItemIdentifier.rootContainer ? .folder : .plainText
    }
}
