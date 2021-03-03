//
// Created by Leonid Nifantyev on 10/5/19.
//

import UIKit
import MovieModel

protocol CoordinatorInterface: class {
    func start()
}

class AppCoordinator: CoordinatorInterface {
    var router: RouterInterface?
    
    init(router: RouterInterface) {
        self.router = router
    }
    
    func start() {
        showPopularMovieListScreen()
    }
    
    private func showPopularMovieListScreen() {
        let module = PopularMovieAssembler.makeModule()
        module.viewModel.output = self
        
        router?.setRootModule(viewController: module.viewController)
    }
    
    private func showMovieDetailsScreen(movie: Movie) {
        let module = MovieDetailsAssembler.makeModule(movie: movie)
        router?.push(viewController: module.viewController)
    }
}

extension AppCoordinator: PopularMovieOutput {
    func movieChosen(movie: Movie) {
        showMovieDetailsScreen(movie: movie)
    }
}
