//
//  SettingsVC.swift
//  HashChat
//
//  Created by shilani on 25/01/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user = FirebaseAuth.Auth.auth().currentUser
    var image: UIImage?
    //Views
    var headerView = UIView()
    var logOutButton = UIButton()
    var profileImage = ProfileImageView(size: 140)
    var nameLabel = TitleLabel(fontSize: 20, textAlignment: .center)
    let editImageButton = UIButton(type: .system)
    let dbManager = DatabaseManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        Task{
            if let user = await dbManager.currentCustomUser() {
                if let url = user.imageUrl {
                    
                    if let img = await  dbManager.downloadImage(from: url) {
                        await MainActor.run {
                            self.image = img
                          self.updateImage(with: img)
                        }
                    }
                    
                }
            }
            //                    self.dbManager.downloadImage(from: url, completed: { image in
//                        guard let image = image else {return}
//                        DispatchQueue.main.async {
//                            self.image = image
//                            self.updateImage(with: image)
//                        }
//                    })
                }
            }


    
    func updateImage(with image: UIImage){
        profileImage.image = image
    }
    
    func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(logOutButton)
        headerView.addSubview(profileImage)
        headerView.addSubview(nameLabel)
        headerView.addSubview(editImageButton)

        logOutButton.setTitle("Sign out", for: .normal)
        logOutButton.backgroundColor = UIColor(resource: .purple)
        logOutButton.tintColor = .white
        logOutButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        logOutButton.layer.cornerRadius = 20
        
        nameLabel.textAlignment = .center
        nameLabel.text = user?.email
        profileImage.image = image != nil ? image : UIImage(systemName: "circle")
        profileImage.tintColor = .systemGray6
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        profileImage.addGestureRecognizer(tapGesture)
        
        logOutButton.addTarget(self, action: #selector(didTapSignout), for: .touchUpInside)
        editImageButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editImageButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        editImageButton.tintColor = UIColor(resource: .purple)
        
        editImageButton.setTitleShadowColor(.black, for: .normal)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        editImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            logOutButton.topAnchor.constraint(equalTo: headerView.topAnchor,constant: -10),
            logOutButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            logOutButton.heightAnchor.constraint(equalToConstant: 40),
            logOutButton.widthAnchor.constraint(equalToConstant: 80),

            
            profileImage.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImage.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -10),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1),
            profileImage.widthAnchor.constraint(equalToConstant: 140),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 35),
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            editImageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor,constant: -24),
            editImageButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor,constant: 35),
            editImageButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    
    @objc func setImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageUrl = info[.imageURL] as? URL
        guard let imageUrl = imageUrl else { return }
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImage.image = selectedImage
            dbManager.uploadProfilePhoto(local: imageUrl.absoluteString)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImage.image = originalImage
        }
        picker.dismiss(animated: true)
    }
    
    
    @objc func didTapSignout(){
        let ok = Authenticator.signOut()
           if !ok {
               print("Error signing out")
           }
    }
}
