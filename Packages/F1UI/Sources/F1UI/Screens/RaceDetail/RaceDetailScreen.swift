import Foundation
import SwiftUI

public struct RaceDetailScreen: View {
    @State private var state: ViewState
    @State private var selectedTab: Tab = .results

    private let load: @Sendable () async -> ViewState

    public init(load: @escaping @Sendable () async -> ViewState) {
        self.load = load
        self._state = State(initialValue: .idle)
    }

    init(previewState: ViewState) {
        self.load = { previewState }
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("Race Detail")
            .task {
                if case .idle = state {
                    await loadState()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView("Loading race details...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            ContentUnavailableView {
                Label("Unable to Load Race Detail", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task {
                        await loadState()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let data):
            VStack(spacing: F1Theme.Spacing.m) {
                F1UI.Race.DetailHeader(data.header)
                    .padding(.horizontal, F1Theme.Spacing.m)
                    .padding(.top, F1Theme.Spacing.s)

                Picker("Section", selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Text(tab.title).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, F1Theme.Spacing.m)

                tabContent(data)
            }
            .background(F1Theme.Colors.background)
        }
    }

    @ViewBuilder
    private func tabContent(_ data: LoadedViewData) -> some View {
        switch selectedTab {
        case .results:
            if data.results.isEmpty {
                emptyTabView("No race results available.")
            } else {
                List(data.results, id: \.id) { result in
                    F1UI.Result.Row(result)
                        .listRowInsets(
                            EdgeInsets(
                                top: F1Theme.Spacing.xs,
                                leading: F1Theme.Spacing.m,
                                bottom: F1Theme.Spacing.xs,
                                trailing: F1Theme.Spacing.m
                            )
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(F1Theme.Colors.background)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }

        case .qualifying:
            if data.qualifying.isEmpty {
                emptyTabView("No qualifying results available.")
            } else {
                List(data.qualifying, id: \.id) { result in
                    F1UI.Qualifying.Row(result)
                        .listRowInsets(
                            EdgeInsets(
                                top: F1Theme.Spacing.xs,
                                leading: F1Theme.Spacing.m,
                                bottom: F1Theme.Spacing.xs,
                                trailing: F1Theme.Spacing.m
                            )
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(F1Theme.Colors.background)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }

        case .circuit:
            ScrollView {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.m) {
                    F1UI.SectionHeader(
                        .init(
                            title: "Circuit",
                            subtitle: "\(data.circuit.locality), \(data.circuit.country)"
                        )
                    )
                    F1UI.Circuit.Summary(data.circuit)
                }
                .padding(.horizontal, F1Theme.Spacing.m)
                .padding(.vertical, F1Theme.Spacing.s)
            }
        }
    }

    private func emptyTabView(_ message: String) -> some View {
        ContentUnavailableView {
            Label(message, systemImage: "list.bullet.rectangle")
        } description: {
            Text("Please retry later.")
        }
    }

    @MainActor
    private func loadState() async {
        state = .loading
        state = await load()
    }
}

public extension RaceDetailScreen {
    enum Tab: String, CaseIterable, Hashable, Sendable {
        case results
        case qualifying
        case circuit

        var title: String {
            switch self {
            case .results: return "Results"
            case .qualifying: return "Qualifying"
            case .circuit: return "Circuit"
            }
        }
    }

    struct LoadedViewData: Hashable, Sendable {
        public let header: F1UI.Race.DetailHeader.ViewData
        public let results: [F1UI.Result.Row.ViewData]
        public let qualifying: [F1UI.Qualifying.Row.ViewData]
        public let circuit: F1UI.Circuit.Summary.ViewData

        public init(
            header: F1UI.Race.DetailHeader.ViewData,
            results: [F1UI.Result.Row.ViewData],
            qualifying: [F1UI.Qualifying.Row.ViewData],
            circuit: F1UI.Circuit.Summary.ViewData
        ) {
            self.header = header
            self.results = results
            self.qualifying = qualifying
            self.circuit = circuit
        }
    }

    enum ViewState: Hashable, Sendable {
        case idle
        case loading
        case loaded(LoadedViewData)
        case error(String)
    }
}

#Preview("Race Detail Loading Light") {
    NavigationStack {
        RaceDetailScreen(previewState: .loading)
    }
    .preferredColorScheme(.light)
}

#Preview("Race Detail Loading Dark") {
    NavigationStack {
        RaceDetailScreen(previewState: .loading)
    }
    .preferredColorScheme(.dark)
}

#Preview("Race Detail Error Light") {
    NavigationStack {
        RaceDetailScreen(previewState: .error("Failed to load race details. Please try again."))
    }
    .preferredColorScheme(.light)
}

#Preview("Race Detail Error Dark") {
    NavigationStack {
        RaceDetailScreen(previewState: .error("Failed to load race details. Please try again."))
    }
    .preferredColorScheme(.dark)
}

#Preview("Race Detail Loaded Light") {
    NavigationStack {
        RaceDetailScreen(
            previewState: .loaded(
                .init(
                    header: .init(
                        id: "2024-1",
                        title: "Bahrain Grand Prix",
                        dateText: "2024-03-02",
                        timeText: "15:00:00",
                        circuitName: "Bahrain International Circuit",
                        locality: "Sakhir",
                        country: "Bahrain",
                        wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix")
                    ),
                    results: [
                        .init(
                            id: "2024-1-max_verstappen",
                            positionText: "1",
                            position: 1,
                            driverName: "Max Verstappen",
                            constructorName: "Red Bull Racing",
                            pointsText: "25 pts",
                            resultChip: .init(text: "1:31:44.742", style: .time),
                            teamStyleToken: .redBull,
                            teamShortCode: "RBR"
                        ),
                        .init(
                            id: "2024-1-sergio_perez",
                            positionText: "2",
                            position: 2,
                            driverName: "Sergio Perez",
                            constructorName: "Red Bull Racing",
                            pointsText: "18 pts",
                            resultChip: .init(text: "+22.457s", style: .time),
                            teamStyleToken: .redBull,
                            teamShortCode: "RBR"
                        )
                    ],
                    qualifying: [
                        .init(
                            id: "2024-1-max_verstappen",
                            positionText: "1",
                            position: 1,
                            driverName: "Max Verstappen",
                            constructorName: "Red Bull Racing",
                            q1Text: "1:29.421",
                            q2Text: "1:29.374",
                            q3Text: "1:29.179",
                            teamStyleToken: .redBull,
                            teamShortCode: "RBR"
                        ),
                        .init(
                            id: "2024-1-charles_leclerc",
                            positionText: "2",
                            position: 2,
                            driverName: "Charles Leclerc",
                            constructorName: "Ferrari",
                            q1Text: "1:29.500",
                            q2Text: "1:29.401",
                            q3Text: "1:29.407",
                            teamStyleToken: .ferrari,
                            teamShortCode: "FER"
                        )
                    ],
                    circuit: .init(
                        id: "bahrain",
                        name: "Bahrain International Circuit",
                        locality: "Sakhir",
                        country: "Bahrain",
                        coordinatesText: "26.0325, 50.5106",
                        wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
                    )
                )
            )
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Race Detail Loaded Dark") {
    NavigationStack {
        RaceDetailScreen(
            previewState: .loaded(
                .init(
                    header: .init(
                        id: "2024-1",
                        title: "Bahrain Grand Prix",
                        dateText: "2024-03-02",
                        timeText: "15:00:00",
                        circuitName: "Bahrain International Circuit",
                        locality: "Sakhir",
                        country: "Bahrain",
                        wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix")
                    ),
                    results: [
                        .init(
                            id: "2024-1-max_verstappen",
                            positionText: "1",
                            position: 1,
                            driverName: "Max Verstappen",
                            constructorName: "Red Bull Racing",
                            pointsText: "25 pts",
                            resultChip: .init(text: "1:31:44.742", style: .time),
                            teamStyleToken: .redBull,
                            teamShortCode: "RBR"
                        ),
                        .init(
                            id: "2024-1-sergio_perez",
                            positionText: "2",
                            position: 2,
                            driverName: "Sergio Perez",
                            constructorName: "Red Bull Racing",
                            pointsText: "18 pts",
                            resultChip: .init(text: "+22.457s", style: .time),
                            teamStyleToken: .redBull,
                            teamShortCode: "RBR"
                        )
                    ],
                    qualifying: [
                        .init(
                            id: "2024-1-max_verstappen",
                            positionText: "1",
                            position: 1,
                            driverName: "Max Verstappen",
                            constructorName: "Red Bull Racing",
                            q1Text: "1:29.421",
                            q2Text: "1:29.374",
                            q3Text: "1:29.179",
                            teamStyleToken: .redBull,
                            teamShortCode: "RBR"
                        ),
                        .init(
                            id: "2024-1-charles_leclerc",
                            positionText: "2",
                            position: 2,
                            driverName: "Charles Leclerc",
                            constructorName: "Ferrari",
                            q1Text: "1:29.500",
                            q2Text: "1:29.401",
                            q3Text: "1:29.407",
                            teamStyleToken: .ferrari,
                            teamShortCode: "FER"
                        )
                    ],
                    circuit: .init(
                        id: "bahrain",
                        name: "Bahrain International Circuit",
                        locality: "Sakhir",
                        country: "Bahrain",
                        coordinatesText: "26.0325, 50.5106",
                        wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
                    )
                )
            )
        )
    }
    .preferredColorScheme(.dark)
}
