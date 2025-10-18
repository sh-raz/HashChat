//
//  ChatViewController.swift
//  HashChat
//
//  Created by shilani on 09/07/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTxt: UITextField!
    var messageSender: String?
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var messages: [Message] = []
    var listner: ListenerRegistration?

    
    override func viewDidLoad()  {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        configureTableView()
        getDataFromDatabase()

        sendButton.setTitle("", for: .normal)
        sendButton.setTitle("", for: .highlighted)
        sendButton.setTitle("", for: .selected)
        sendButton.setTitle("", for: .disabled)
        sendButton.setTitle("", for: .focused)
        sendButton.setTitle("", for: .application)
        sendButton.setTitle("", for: .reserved)
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.messageSender = user.email
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
   
    
 // MARK: -IBActions
     
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let message = Message(sender: messageSender!, text: messageTxt.text!, date: Date().timeIntervalSince1970)
        Task { @MainActor in
            do {
                let ref = try await db.collection("messages").addDocument(data: [
                    "sender":message.sender,
                    "text":message.text,
                    "date": message.date
                ])
                print("Document added with ID: \(ref.documentID)")
            } catch {
                print("Error adding document: \(error.localizedDescription)")
            }
        }
        messages.append(message)
        updateUIOnTheMainThread()
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
 
    
    func getDataFromDatabase() {
        messages = []
        listner = db.collection("messages").order(by:"date", descending: false).addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents:\(error!)")
                return
            }
            self.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                do {
                    let messages = try queryDocumentSnapshot.data(as: Message.self)
                    return messages
                }catch{
                    print("Error updating messages array.")
                    return nil
                }
            }
            self.updateUIOnTheMainThread()
        })
    }
    
    
    
    func updateUIOnTheMainThread(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .top, animated: false)
            self.messageTxt.text = ""
            self.messageTxt.placeholder = "Message"
        }
    }
    
    
    
    
    
    //MARK: -TableView delegate and dataSource methods
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: .main), forCellReuseIdentifier: "ReuseCell")
        tableView.register(UINib(nibName: "RecipientTableViewCell", bundle: .main), forCellReuseIdentifier: "YouMessage")
        tableView.showsVerticalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseCell", for: indexPath) as! CustomTableViewCell
            cell.label.text = messages[indexPath.row].text
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "YouMessage", for: indexPath) as! RecipientTableViewCell
            cell.txtLabel.text = messages[indexPath.row].text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    

    
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //messageTxt.text?.append("\n")
        return false
    }

    
}
