import F1Data
import F1UseCases

struct AppCompositionRoot {
    let getSeasonsPageUseCase: GetSeasonsPageUseCase
    let getDriversPageUseCase: GetDriversPageUseCase
    let getConstructorsPageUseCase: GetConstructorsPageUseCase
    let getRacesForSeasonUseCase: GetRacesForSeasonUseCase
    let getRaceResultsPageUseCase: GetRaceResultsPageUseCase
    let getQualifyingResultsPageUseCase: GetQualifyingResultsPageUseCase
    let getDriverStandingsPageUseCase: GetDriverStandingsPageUseCase
    let getConstructorStandingsPageUseCase: GetConstructorStandingsPageUseCase

    init() {
        let repository = JolpicaF1Repository(httpClient: JolpicaHTTPClient())

        self.getSeasonsPageUseCase = GetSeasonsPageUseCase(repository: repository)
        self.getDriversPageUseCase = GetDriversPageUseCase(repository: repository)
        self.getConstructorsPageUseCase = GetConstructorsPageUseCase(repository: repository)
        self.getRacesForSeasonUseCase = GetRacesForSeasonUseCase(repository: repository)
        self.getRaceResultsPageUseCase = GetRaceResultsPageUseCase(repository: repository)
        self.getQualifyingResultsPageUseCase = GetQualifyingResultsPageUseCase(repository: repository)
        self.getDriverStandingsPageUseCase = GetDriverStandingsPageUseCase(repository: repository)
        self.getConstructorStandingsPageUseCase = GetConstructorStandingsPageUseCase(repository: repository)
    }
}
