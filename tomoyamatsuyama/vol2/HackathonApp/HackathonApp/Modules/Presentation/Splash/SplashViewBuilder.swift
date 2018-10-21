import UIKit

struct SplashViewBuilder {
    static func build() -> SplashViewController {
        let viewController: SplashViewController = .instantiate()
        
        // Data
        let localDataStore = OAuthLocalDataStore()
        let remoteDataStore = OAuthRemoteDataStore()
        
        // Domain
        let repository = OAuthRepository(local: localDataStore, remote: remoteDataStore)
        let useCase = SplashUseCase(repository: repository)
        
        // Presentation: VIPER
        let interactor = SplashInteractor(useCase: useCase)
        let router = SplashRouter(view: viewController)
        let presenter = SplashPresenter(view: viewController, interactor: interactor, router: router)
        
        // DI
        viewController.inject(presenter)
        
        return viewController
    }
}
