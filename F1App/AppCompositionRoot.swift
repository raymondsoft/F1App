import F1Data
import F1UseCases

struct AppCompositionRoot {
    let repository: JolpicaF1Repository
    let getSeasonsUseCase: GetSeasonsUseCase
    let getRacesForSeasonUseCase: GetRacesForSeasonUseCase

    init() {
        let repository = JolpicaF1Repository(httpClient: JolpicaHTTPClient())

        self.repository = repository
        self.getSeasonsUseCase = GetSeasonsUseCase(repository: repository)
        self.getRacesForSeasonUseCase = GetRacesForSeasonUseCase(repository: repository)
    }
}
