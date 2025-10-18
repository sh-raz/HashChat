//
//  SignUpViewController.swift
//  HashChat
//
//  Created by shilani on 09/07/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Contacts

class SignUpViewController: UIViewController {
    
    var welcomeLabel = TitleLabel(fontSize: 35, textAlignment: .center)
    var emailTextField = CustomTextField(placeholder: "Email")
    var passwordTextField = CustomTextField(placeholder: "Password")
    var signUpButton = HCButton(title: "Signup", theme: .blue)
    var stackView = UIStackView()

    let dbManager = DatabaseManager.shared
    var userEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        emailTextField.delegate = self
        passwordTextField.delegate = self
        welcomeLabel.text = "Welcome"
        updateUI()
    }
    
    
    
    @objc func signupPressed() {
        let username = emailTextField.text!
        let password = passwordTextField.text!
        if validateInputs() {
            Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert(message: "Something went wrong. SignUp Faild.")
                }
                guard authResult != nil else {
                    print("No user object available")
                    return
                }
                guard let id = Auth.auth().currentUser?.uid else {return}
                let user = User(id: id , name: "", email: username.lowercased())
                
                self.dbManager.addUserToFirestore(user: user)
                let mainVC = MainTabBarVC()
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: false)

            }
        }
    }
       


    
    
   
    func updateUI(){
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(stackView)
        view.addSubview(welcomeLabel)
        signUpButton.addTarget(self, action: #selector(signupPressed), for: .touchUpInside)
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
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalTo: signUpButton.widthAnchor)
        ])
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
            userEmail = emailTextField.text!
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
    
    
    func configureBottomStackView(){
        let changeToSignupButton = AttributedButton(title: "Login")
        let changeToSignupLabel = DetailsLabel()
        
        changeToSignupButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        changeToSignupLabel.text = "Already have an account?"
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
    
    @objc func goToLogin() {
        let loginVC = LogInViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    
}





extension SignUpViewController: UITextFieldDelegate {
    
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        textField.endEditing(true)
    //    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    
    
 
    
}
