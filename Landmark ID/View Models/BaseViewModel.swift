
//MARK: BaseViewModel

class BaseViewModel {
    
    let webService : WebServiceProtocol
    let dataManager : DataManagerProtocol
    init() {
        self.webService = WebService.shared
        self.dataManager = DataManager.shared
    }
}
