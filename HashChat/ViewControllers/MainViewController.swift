//
//  ViewController.swift
//  HashChat
//
//  Created by shilani on 09/07/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var logoImageView = UIImageView()
    var welcomeLabel = UILabel()
    var LoginButton = HCButton(title: "Log In", theme: .purple)
    var signupButton = HCButton(title: "Sign Up", theme: .blue )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barTintColor = UIColor(named: "darkGray")
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
//    }
    
    func configureUI() {
        
        view.addSubview(LoginButton)
        view.addSubview(signupButton)
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        
        LoginButton.addTarget(self, action: #selector(transformToLoginVC), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(transformToSignUpVC), for: .touchUpInside)
        logoImageView.image = UIImage(resource: .bubble2)
        welcomeLabel.text = "Welcome to HashChat"
        welcomeLabel.numberOfLines = 2
        welcomeLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = UIColor(resource: .purple)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1 / 10),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 140),
            logoImageView.widthAnchor.constraint(equalToConstant: 140),
            
            welcomeLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 160),
            
            LoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.7),
            LoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            LoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            LoginButton.heightAnchor.constraint(equalToConstant: 60),
            
            signupButton.topAnchor.constraint(equalTo: LoginButton.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signupButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    @objc func transformToLoginVC() {
        let loginVC = LogInViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    @objc func transformToSignUpVC() {
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .fullScreen
        present(signupVC, animated: true)
    }
}

