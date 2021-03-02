//
// Created by Leonid Nifantyev on 10/5/19.
//

import UIKit

protocol CoordinatorInterface: class {
    func start()
}

class AppCoordinator: CoordinatorInterface {
    var router: RouterInterface?
    
    init(router: RouterInterface) {
        self.router = router
    }
    
    func start() {
        showLoginScreen()
    }
    
    private func showLoginScreen() {
        let module = PopularMovieAssembler.makeModule()
//        module.viewModel.output = self
        
        router?.setRootModule(viewController: module.viewController)
    }
    
    private func showInterestsScreen() {
//        let module = InterestsAssembler.makeInterestModule()
//        module.viewModel.output = self
//        router?.push(viewController: module.viewController)
    }
}

//extension AppCoordinator: LoginCoordinatorOutput, InterestsCoordinatorOutput {
//    func loginFinished() {
//        showInterestsScreen()
//    }
//
//    func interestFinished() {
//        router?.back()
//    }
//}
