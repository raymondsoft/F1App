struct PagedListState<Item: Equatable>: Equatable {
    let items: [Item]
    let isLoadingInitial: Bool
    let isLoadingMore: Bool
    let hasMore: Bool
    let nextOffset: Int
    let error: String?

    static var initial: Self {
        .init(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: nil
        )
    }

    static var loadingInitial: Self {
        .init(
            items: [],
            isLoadingInitial: true,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: nil
        )
    }
}

func mergeUniqueByID<Item>(
    _ existingItems: [Item],
    with newItems: [Item],
    id: KeyPath<Item, String>
) -> [Item] {
    var mergedItems = existingItems

    for item in newItems where !mergedItems.contains(where: { $0[keyPath: id] == item[keyPath: id] }) {
        mergedItems.append(item)
    }

    return mergedItems
}
