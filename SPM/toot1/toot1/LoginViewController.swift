import UIKit
import NavigationMod

class LoginViewController: UIViewController {
    private let passwordTextField = UITextField()
    private let loginTextField = UITextField()
    private let loginButton = UIButton()
    private let coordinator: AbstractCoordinator
    
    init(coordinator: AbstractCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Splungemonkey")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        title = "LobIn"
        
        configureLoginTextField()
        configurePasswordTextField()
        configureLoginButton()
    }
    
    private func configureLoginTextField() {
        view.addSubview(loginTextField)
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.textContentType = .username
        loginTextField.layer.borderColor = UIColor.gray.cgColor
        loginTextField.layer.borderWidth = 1
        loginTextField.layer.cornerRadius = 10
        loginTextField.placeholder = "Login"
        loginTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.placeholder = "Password"
        passwordTextField.textContentType = .password
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor)
        ])
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.configuration = UIButton.Configuration.filled()
        
        loginButton.addAction(UIAction(handler: { [weak self] action in
            self?.coordinator.goToHomeScreen()
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
