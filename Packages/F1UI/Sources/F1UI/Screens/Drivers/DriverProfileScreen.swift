import Foundation
import F1Domain
import F1UseCases
import SwiftUI

public struct DriverProfileScreen: View {
    public struct ViewData: Hashable, Sendable {
        public let driverId: String
        public let driverDisplayName: String?
        public let nationality: String?
        public let dateOfBirthText: String?
        public let wikipediaURL: URL?
        public let flagEmoji: String?
        public let preferredSeasonId: String?

        public init(
            driverId: String,
            driverDisplayName: String? = nil,
            nationality: String? = nil,
            dateOfBirthText: String? = nil,
            wikipediaURL: URL? = nil,
            flagEmoji: String? = nil,
            preferredSeasonId: String? = nil
        ) {
            self.driverId = driverId
            self.driverDisplayName = driverDisplayName
            self.nationality = nationality
            self.dateOfBirthText = dateOfBirthText
            self.wikipediaURL = wikipediaURL
            self.flagEmoji = flagEmoji
            self.preferredSeasonId = preferredSeasonId
        }
    }

    @State private var state: ViewState
    @State private var selectedSeasonId: String?

    private let viewData: ViewData
    private let getSeasons: @Sendable () async throws -> [Season]
    private let getDriverStandingsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<DriverStanding>
    private let getRacesForSeason: @Sendable (Season.ID) async throws -> [Race]
    private let getRaceResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>

    public init(
        viewData: ViewData,
        getSeasonsUseCase: GetSeasonsUseCase,
        getDriverStandingsPageUseCase: GetDriverStandingsPageUseCase,
        getRacesForSeasonUseCase: GetRacesForSeasonUseCase,
        getRaceResultsPageUseCase: GetRaceResultsPageUseCase
    ) {
        self.viewData = viewData
        self.getSeasons = { try await getSeasonsUseCase() }
        self.getDriverStandingsPage = { seasonId, request in
            try await getDriverStandingsPageUseCase(seasonId: seasonId, request: request)
        }
        self.getRacesForSeason = { seasonId in
            try await getRacesForSeasonUseCase(seasonId: seasonId)
        }
        self.getRaceResultsPage = { seasonId, round, request in
            try await getRaceResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self._state = State(initialValue: .idle)
        self._selectedSeasonId = State(initialValue: viewData.preferredSeasonId)
    }

    init(
        viewData: ViewData,
        getSeasons: @escaping @Sendable () async throws -> [Season],
        getDriverStandingsPage: @escaping @Sendable (Season.ID, PageRequest) async throws -> Page<DriverStanding>,
        getRacesForSeason: @escaping @Sendable (Season.ID) async throws -> [Race],
        getRaceResultsPage: @escaping @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>
    ) {
        self.viewData = viewData
        self.getSeasons = getSeasons
        self.getDriverStandingsPage = getDriverStandingsPage
        self.getRacesForSeason = getRacesForSeason
        self.getRaceResultsPage = getRaceResultsPage
        self._state = State(initialValue: .idle)
        self._selectedSeasonId = State(initialValue: viewData.preferredSeasonId)
    }

    init(viewData: ViewData, previewState: ViewState) {
        self.viewData = viewData
        self.getSeasons = { [] }
        self.getDriverStandingsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getRacesForSeason = { _ in [] }
        self.getRaceResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self._state = State(initialValue: previewState)
        self._selectedSeasonId = State(
            initialValue: {
                if case .loaded(_, let selector, _, _) = previewState {
                    return selector.selectedSeasonId
                }
                return viewData.preferredSeasonId
            }()
        )
    }

    public var body: some View {
        content
            .navigationTitle("Driver")
            .task {
                if case .idle = state {
                    await loadInitialState()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView("Loading driver profile...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            ContentUnavailableView {
                Label("Unable to Load Driver Profile", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task {
                        await loadInitialState()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let header, let seasonSelector, let seasonSummary, let recentResults):
            ScrollView {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.l) {
                    F1UI.Driver.Header(header)

                    F1UI.Driver.SeasonSelector(
                        seasonSelector,
                        selectedSeasonId: Binding(
                            get: { selectedSeasonId ?? seasonSelector.selectedSeasonId },
                            set: { newValue in
                                guard newValue != selectedSeasonId else { return }
                                selectedSeasonId = newValue
                                Task {
                                    await loadSeasonState(seasonId: newValue)
                                }
                            }
                        )
                    )

                    F1UI.Driver.SeasonSummary(seasonSummary)

                    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
                        F1UI.SectionHeader(.init(title: "Recent Results"))

                        if recentResults.isEmpty {
                            ContentUnavailableView(
                                "No recent results available.",
                                systemImage: "flag.checkered.2.crossed",
                                description: Text("This season does not expose recent results for the selected driver.")
                            )
                        } else {
                            ForEach(recentResults, id: \.id) { result in
                                F1UI.Driver.RecentResult.Row(result)
                            }
                        }
                    }
                }
                .padding(F1Theme.Spacing.m)
            }
            .background(F1Theme.Colors.background)
        }
    }

    @MainActor
    private func loadInitialState() async {
        state = .loading

        do {
            let seasons = try await getSeasons()
            let sortedSeasons = Self.sortedSeasons(from: seasons)

            guard let initialSeasonId = Self.makeInitialSeasonId(
                preferredSeasonId: selectedSeasonId ?? viewData.preferredSeasonId,
                seasons: sortedSeasons
            ) else {
                state = .error(Self.errorMessage)
                return
            }

            selectedSeasonId = initialSeasonId.rawValue
            state = try await Self.makeLoadedState(
                viewData: viewData,
                seasons: sortedSeasons,
                selectedSeasonId: initialSeasonId,
                getDriverStandingsPage: getDriverStandingsPage,
                getRacesForSeason: getRacesForSeason,
                getRaceResultsPage: getRaceResultsPage
            )
        } catch {
            state = .error(Self.errorMessage)
        }
    }

    @MainActor
    private func loadSeasonState(seasonId: String) async {
        state = .loading

        do {
            let seasons = Self.sortedSeasons(from: try await getSeasons())
            let selectedSeasonId = Season.ID(rawValue: seasonId)

            state = try await Self.makeLoadedState(
                viewData: viewData,
                seasons: seasons,
                selectedSeasonId: selectedSeasonId,
                getDriverStandingsPage: getDriverStandingsPage,
                getRacesForSeason: getRacesForSeason,
                getRaceResultsPage: getRaceResultsPage
            )
        } catch {
            state = .error(Self.errorMessage)
        }
    }

    private static let errorMessage = "Failed to load driver profile. Please try again."

    static func makeLoadedState(
        viewData: ViewData,
        seasons: [Season],
        selectedSeasonId: Season.ID,
        getDriverStandingsPage: @escaping @Sendable (Season.ID, PageRequest) async throws -> Page<DriverStanding>,
        getRacesForSeason: @escaping @Sendable (Season.ID) async throws -> [Race],
        getRaceResultsPage: @escaping @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>
    ) async throws -> ViewState {
        let standingsRequest = try PageRequest(limit: 50, offset: 0)
        let resultsRequest = try PageRequest(limit: 60, offset: 0)
        let driverId = Driver.ID(rawValue: viewData.driverId)

        async let standingsPage = getDriverStandingsPage(selectedSeasonId, standingsRequest)
        async let seasonRaces = getRacesForSeason(selectedSeasonId)

        let (page, races) = try await (standingsPage, seasonRaces)
        let standing = page.items.first(where: { $0.driver.id == driverId })
        let header = makeHeaderData(viewData: viewData, driver: standing?.driver)
        let seasonSelector = makeSeasonSelectorData(seasons: seasons, selectedSeasonId: selectedSeasonId)
        let seasonSummary = makeSeasonSummaryData(
            standing: standing,
            maxPoints: page.items.map(\.points).max() ?? 0
        )

        let recentSeasonRaces = races
            .sorted(by: { $0.date > $1.date })
            .prefix(5)

        var recentResults: [RaceResult] = []
        for race in recentSeasonRaces {
            let resultsPage = try await getRaceResultsPage(selectedSeasonId, race.round, resultsRequest)
            if let result = resultsPage.items.first(where: { $0.driver.id == driverId }) {
                recentResults.append(result)
            }
        }

        return .loaded(
            header,
            seasonSelector,
            seasonSummary,
            makeRecentResultRows(from: recentResults)
        )
    }

    static func makeHeaderData(
        viewData: ViewData,
        driver: Driver?
    ) -> F1UI.Driver.Header.ViewData {
        let displayName: String
        if let driver {
            displayName = "\(driver.givenName) \(driver.familyName)"
        } else {
            displayName = viewData.driverDisplayName ?? viewData.driverId
        }

        let nationality = driver?.nationality ?? viewData.nationality ?? "Unknown"
        let dateOfBirthText = driver?.dateOfBirth.map(makeDateText) ?? viewData.dateOfBirthText
        let wikipediaURL = driver?.wikipediaURL ?? viewData.wikipediaURL

        return .init(
            displayName: displayName,
            nationality: nationality,
            dateOfBirthText: dateOfBirthText,
            wikipediaURL: wikipediaURL,
            flagEmoji: viewData.flagEmoji
        )
    }

    static func makeSeasonSelectorData(
        seasons: [Season],
        selectedSeasonId: Season.ID
    ) -> F1UI.Driver.SeasonSelector.ViewData {
        .init(
            seasons: seasons.map {
                .init(id: $0.id.rawValue, title: $0.id.rawValue)
            },
            selectedSeasonId: selectedSeasonId.rawValue
        )
    }

    static func makeSeasonSummaryData(
        standing: DriverStanding?,
        maxPoints: Double
    ) -> F1UI.Driver.SeasonSummary.ViewData {
        guard let standing else {
            return .init(
                positionText: "—",
                position: nil,
                pointsText: "0 pts",
                winsText: "0 wins",
                pointsBar: .init(value: 0, maxValue: 1, style: .subtle),
                winsPips: .init(wins: 0)
            )
        }

        return .init(
            positionText: makePositionText(from: standing.position),
            position: standing.position,
            pointsText: "\(formatPoints(standing.points)) pts",
            winsText: "\(standing.wins) wins",
            pointsBar: .init(
                value: standing.points,
                maxValue: max(maxPoints, standing.points, 1),
                style: .subtle
            ),
            winsPips: .init(wins: standing.wins)
        )
    }

    static func makeRecentResultRows(from results: [RaceResult]) -> [F1UI.Driver.RecentResult.Row.ViewData] {
        results
            .sorted(by: { $0.date > $1.date })
            .map {
                .init(
                    id: "\($0.seasonId.rawValue)-\($0.round.rawValue)-\($0.driver.id.rawValue)",
                    roundText: "Round \($0.round.rawValue)",
                    raceName: $0.raceName,
                    dateText: makeDateText(from: $0.date),
                    positionText: makePositionText(from: $0.position),
                    position: $0.position,
                    pointsText: "\(formatPoints($0.points)) pts",
                    resultChip: makeResultChip(from: $0)
                )
            }
    }

    static func makePositionText(from position: Int?) -> String {
        if let position {
            return "P\(position)"
        }
        return "—"
    }

    static func makeResultChip(from result: RaceResult) -> F1UI.Chip.ViewData {
        if let resultTime = result.resultTime {
            switch resultTime {
            case .time(let value):
                return .init(text: value, style: .time)
            case .status(let value):
                return .init(text: value, style: .status)
            }
        }

        return .init(text: result.status, style: .status)
    }

    static func sortedSeasons(from seasons: [Season]) -> [Season] {
        seasons.sorted { $0.id.rawValue > $1.id.rawValue }
    }

    static func makeInitialSeasonId(preferredSeasonId: String?, seasons: [Season]) -> Season.ID? {
        if let preferredSeasonId, seasons.contains(where: { $0.id.rawValue == preferredSeasonId }) {
            return .init(rawValue: preferredSeasonId)
        }

        return seasons.first?.id
    }

    private static func makeDateText(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func formatPoints(_ points: Double) -> String {
        if points.rounded() == points {
            return String(Int(points))
        }
        return String(points)
    }
}

public extension DriverProfileScreen {
    enum ViewState: Hashable, Sendable {
        case idle
        case loading
        case loaded(
            F1UI.Driver.Header.ViewData,
            F1UI.Driver.SeasonSelector.ViewData,
            F1UI.Driver.SeasonSummary.ViewData,
            [F1UI.Driver.RecentResult.Row.ViewData]
        )
        case error(String)
    }
}

#Preview("Driver Profile Loading Light") {
    NavigationStack {
        DriverProfileScreen(
            viewData: .init(driverId: "max_verstappen", driverDisplayName: "Max Verstappen"),
            previewState: .loading
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Driver Profile Loading Dark") {
    NavigationStack {
        DriverProfileScreen(
            viewData: .init(driverId: "max_verstappen", driverDisplayName: "Max Verstappen"),
            previewState: .loading
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Driver Profile Error Light") {
    NavigationStack {
        DriverProfileScreen(
            viewData: .init(driverId: "max_verstappen", driverDisplayName: "Max Verstappen"),
            previewState: .error("Failed to load driver profile. Please try again.")
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Driver Profile Error Dark") {
    NavigationStack {
        DriverProfileScreen(
            viewData: .init(driverId: "max_verstappen", driverDisplayName: "Max Verstappen"),
            previewState: .error("Failed to load driver profile. Please try again.")
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Driver Profile Loaded Light") {
    NavigationStack {
        DriverProfileScreen(
            viewData: .init(driverId: "max_verstappen", driverDisplayName: "Max Verstappen"),
            previewState: .loaded(
                .init(
                    displayName: "Max Verstappen",
                    nationality: "Dutch",
                    dateOfBirthText: "1997-09-30",
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen"),
                    flagEmoji: nil
                ),
                .init(
                    seasons: [
                        .init(id: "2024", title: "2024"),
                        .init(id: "2023", title: "2023"),
                        .init(id: "2022", title: "2022")
                    ],
                    selectedSeasonId: "2024"
                ),
                .init(
                    positionText: "P1",
                    position: 1,
                    pointsText: "575 pts",
                    winsText: "9 wins",
                    pointsBar: .init(value: 575, maxValue: 700, style: .subtle),
                    winsPips: .init(wins: 9)
                ),
                [
                    .init(
                        id: "2024-2-max_verstappen",
                        roundText: "Round 2",
                        raceName: "Saudi Arabian Grand Prix",
                        dateText: "2024-03-09",
                        positionText: "P1",
                        position: 1,
                        pointsText: "25 pts",
                        resultChip: .init(text: "Finished", style: .status)
                    ),
                    .init(
                        id: "2024-1-max_verstappen",
                        roundText: "Round 1",
                        raceName: "Bahrain Grand Prix",
                        dateText: "2024-03-02",
                        positionText: "P1",
                        position: 1,
                        pointsText: "25 pts",
                        resultChip: .init(text: "1:31:44.742", style: .time)
                    )
                ]
            )
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Driver Profile Loaded Dark") {
    NavigationStack {
        DriverProfileScreen(
            viewData: .init(driverId: "max_verstappen", driverDisplayName: "Max Verstappen"),
            previewState: .loaded(
                .init(
                    displayName: "Max Verstappen",
                    nationality: "Dutch",
                    dateOfBirthText: "1997-09-30",
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen"),
                    flagEmoji: nil
                ),
                .init(
                    seasons: [
                        .init(id: "2024", title: "2024"),
                        .init(id: "2023", title: "2023"),
                        .init(id: "2022", title: "2022")
                    ],
                    selectedSeasonId: "2024"
                ),
                .init(
                    positionText: "P1",
                    position: 1,
                    pointsText: "575 pts",
                    winsText: "9 wins",
                    pointsBar: .init(value: 575, maxValue: 700, style: .subtle),
                    winsPips: .init(wins: 9)
                ),
                [
                    .init(
                        id: "2024-2-max_verstappen",
                        roundText: "Round 2",
                        raceName: "Saudi Arabian Grand Prix",
                        dateText: "2024-03-09",
                        positionText: "P1",
                        position: 1,
                        pointsText: "25 pts",
                        resultChip: .init(text: "Finished", style: .status)
                    ),
                    .init(
                        id: "2024-1-max_verstappen",
                        roundText: "Round 1",
                        raceName: "Bahrain Grand Prix",
                        dateText: "2024-03-02",
                        positionText: "P1",
                        position: 1,
                        pointsText: "25 pts",
                        resultChip: .init(text: "1:31:44.742", style: .time)
                    )
                ]
            )
        )
    }
    .preferredColorScheme(.dark)
}
