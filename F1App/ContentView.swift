import F1UI
import SwiftUI

struct ContentView: View {
    private let container: AppCompositionRoot

    init(container: AppCompositionRoot) {
        self.container = container
    }

    var body: some View {
        SeasonsScreen(
            getSeasonsUseCase: container.getSeasonsUseCase,
            getRacesForSeasonUseCase: container.getRacesForSeasonUseCase
        )
    }
}
