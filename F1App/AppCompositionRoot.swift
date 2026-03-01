import F1Data
import F1UseCases

struct AppCompositionRoot {
    let repository: JolpicaF1Repository
    let getSeasonsPageUseCase: GetSeasonsPageUseCase
    let getRacesPageForSeasonUseCase: GetRacesPageForSeasonUseCase
    let getRacesForSeasonUseCase: GetRacesForSeasonUseCase

    init() {
        let repository = JolpicaF1Repository(httpClient: JolpicaHTTPClient())

        self.repository = repository
        self.getSeasonsPageUseCase = GetSeasonsPageUseCase(repository: repository)
        self.getRacesPageForSeasonUseCase = GetRacesPageForSeasonUseCase(repository: repository)
        self.getRacesForSeasonUseCase = GetRacesForSeasonUseCase(repository: repository)
    }
}
