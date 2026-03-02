import F1UI
import SwiftUI

struct ContentView: View {
    private let container: AppCompositionRoot

    init(container: AppCompositionRoot) {
        self.container = container
    }

    var body: some View {
        SeasonsScreen(
            getSeasonsPageUseCase: container.getSeasonsPageUseCase,
            getDriversPageUseCase: container.getDriversPageUseCase,
            getConstructorsPageUseCase: container.getConstructorsPageUseCase,
            getRacesForSeasonUseCase: container.getRacesForSeasonUseCase,
            getRaceResultsPageUseCase: container.getRaceResultsPageUseCase,
            getQualifyingResultsPageUseCase: container.getQualifyingResultsPageUseCase,
            getDriverStandingsPageUseCase: container.getDriverStandingsPageUseCase,
            getConstructorStandingsPageUseCase: container.getConstructorStandingsPageUseCase
        )
    }
}
