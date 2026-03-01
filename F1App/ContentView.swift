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
            getRacesForSeasonUseCase: container.getRacesForSeasonUseCase
        )
    }
}
