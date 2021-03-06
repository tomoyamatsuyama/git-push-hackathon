import RxCocoa
import RxSwift
import UIKit

final class SplashPresenter: SplashPresenterProtocol {
    
    private weak var view: SplashViewProtocol!
    private var interactor: SplashInteractorProtocol
    private var router: SplashRouterProtocol
    
    private let disposeBag = DisposeBag()
    
    let isLoading: Observable<Bool>
    private let _isLoading = PublishRelay<Bool>()
    
    let hasAccessToken: Observable<Bool>
    private let _hasAccessToken = PublishRelay<Bool>()
    
    init (view: SplashViewProtocol, interactor: SplashInteractorProtocol, router: SplashRouterProtocol) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.isLoading = _isLoading.asObservable()
        self.hasAccessToken = _hasAccessToken.asObservable()
        
        view.refreshTrigger
            .emit(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self._isLoading.accept(true)
                
                interactor.hasAccessToken()
                    .subscribe(onNext: { hasAccessToken in
                        self._hasAccessToken.accept(hasAccessToken)
                    }, onCompleted: {
                        self._isLoading.accept(false)
                    })
                    .disposed(by: self.disposeBag)

            })
            .disposed(by: disposeBag)
        
        view.present
            .emit(onNext: { route in
                router.transition(route: route)
            })
            .disposed(by: disposeBag)
    }
}
