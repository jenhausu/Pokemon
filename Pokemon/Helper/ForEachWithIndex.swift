//
//  ForEachWithIndex.swift
//  ObjectCaptureCamera
//
//  Created by 蘇健豪 on 2021/12/3.
//  Preference: https://stackoverflow.com/a/61149111/3295047

import SwiftUI

public struct ForEachWithIndex<Data: RandomAccessCollection, Id: Hashable, Content: View>: View {
    public let data: Data
    public let content: (_ index: Data.Index, _ element: Data.Element) -> Content
    let id: KeyPath<Data.Element, Id>
    
    public init(_ data: Data, id: KeyPath<Data.Element, Id>, content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
    
    public var body: some View {
        ForEach(
            zip(self.data.indices, self.data).map { index, element in
                IndexInfo( index: index, id: self.id, element: element)
            },
            id: \.elementID
        ) { indexInfo in
            self.content(indexInfo.index, indexInfo.element)
        }
    }
}

extension ForEachWithIndex where Id == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

extension ForEachWithIndex: DynamicViewContent where Content: View {
}

private struct IndexInfo<Index, Element, Id: Hashable>: Hashable {
    let index: Index
    let id: KeyPath<Element, Id>
    let element: Element
    
    var elementID: Id {
        self.element[keyPath: self.id]
    }
    
    static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
        lhs.elementID == rhs.elementID
    }
    
    func hash(into hasher: inout Hasher) {
        self.elementID.hash(into: &hasher)
    }
}
