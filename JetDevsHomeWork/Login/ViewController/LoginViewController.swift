//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by APPLE on 23/03/24.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitleColor(.gray, for: .disabled)
        setupBindings()

    }
    
    func setupBindings() {
        usernameTextField.rx.text
            .bind(to: viewModel.emailSubject).disposed(by: disposeBag)
        passwordTextField.rx.text
            .bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        
        viewModel.isValidForm
            .bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.isValidForm
            .map { $0 ? UIColor(named: "primaryColor") : UIColor.lightGray }
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        debugPrint("Login Button Tapped")
        viewModel.requestToLogin(email: usernameTextField.text ?? "", password: passwordTextField.text ?? "") { [unowned self] result, error in
            guard error == nil else {
                debugPrint("error")
                return
            }
            debugPrint("Login Done")
            debugPrint(result)
        }
        
    }
    
    @IBAction func closeButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
