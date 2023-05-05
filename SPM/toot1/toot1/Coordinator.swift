import UIKit
import NavigationMod
import LoginMod
import HomeMod

public class Coordinator: AbstractCoordinator {
    
    var navigationController: UINavigationController?
    
    public func goToHomeScreen() {
        navigationController?.pushViewController(HomeViewController(coordinator: self), animated: true)
    }
    
    public func start() -> UIViewController {
        self.navigationController = UINavigationController(rootViewController: LoginViewController(coordinator: self))
        
        return navigationController!
    }
}
