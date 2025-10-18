//
//  LogInViewController.swift
//  HashChat
//
//  Created by shilani on 09/07/2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class LogInViewController: UIViewController{

    var welcomeLabel = TitleLabel(fontSize: 35, textAlignment: .center)
    var emailTextField = CustomTextField(placeholder: "Email")
    var passwordTextField = CustomTextField(placeholder: "Password")
    var logInButton = HCButton(title: "Login", theme: .purple)
    var stackView = UIStackView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.text = "shilan@email.com"
        passwordTextField.text = "123456"
        updateUI()
    }
    

    @objc func loginButtonPressed() {
        if validateInputs() {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(message: "Something went wrong!")
                }else{
                    let mainVC = MainTabBarVC()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: false)
                }
            }
        }
    }

    
    func validateInputs() -> Bool {
        var errorMessages: [String] = []
        if let email = emailTextField.text, email.isEmpty {
            errorMessages.append("Please enter a valid email.")
        }
        if let password = passwordTextField.text, password.isEmpty {
            errorMessages.append("Please enter a valid password.")
        }
        if errorMessages.isEmpty {
            return true
        }else{
            showAlert(message: errorMessages.joined(separator: "\n"))
            return false
        }
    }
    
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc func goToSignup() {
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .fullScreen
        present(signupVC, animated: true)
    }
    
    
    func updateUI(){
        view.addSubview(welcomeLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(stackView)
        
        welcomeLabel.text = "Welcome Back"
        
        logInButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        passwordTextField.isSecureTextEntry = true
        
        configureBottomStackView()
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 120),
            
            emailTextField.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logInButton.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalTo: logInButton.widthAnchor)
        ])
    }
    
    
    func configureBottomStackView(){
        let changeToSignupButton = AttributedButton(title: "Signup")
        let changeToSignupLabel = DetailsLabel()
        
        changeToSignupButton.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
        changeToSignupLabel.text = "Do not have an account?"
        changeToSignupLabel.textAlignment = .right
        
        stackView.axis = .horizontal
        stackView.contentMode = .right
        stackView.alignment = .trailing
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.addArrangedSubview(changeToSignupLabel)
        stackView.addArrangedSubview(changeToSignupButton)
    }
}


//MARK: - Extensions
extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
