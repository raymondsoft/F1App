import F1Data
import F1UseCases

struct AppCompositionRoot {
    let getSeasonsPageUseCase: GetSeasonsPageUseCase
    let getRacesForSeasonUseCase: GetRacesForSeasonUseCase

    init() {
        let repository = JolpicaF1Repository(httpClient: JolpicaHTTPClient())

        self.getSeasonsPageUseCase = GetSeasonsPageUseCase(repository: repository)
        self.getRacesForSeasonUseCase = GetRacesForSeasonUseCase(repository: repository)
    }
}
