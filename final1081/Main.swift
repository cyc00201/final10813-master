//
//  login.swift
//  final1081
//
//  Created by User06 on 2019/12/18.
//  Copyright © 2019 matcha55. All rights reserved.
//


//import FirebaseAuth
import Firebase
import UIKit

class Main: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       do {
                     try Auth.auth().signOut()
                  } catch {
                    print(error)
        }
        // Do any additional setup after loading the view.
    }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
  }
  
    @IBSegueAction func toshow(_ coder: NSCoder) -> user_interview? {
        return  user_interview(coder: coder, account:Account.text!)
    }
    @IBAction func Login(_ sender: Any) {
        let db  = Firestore.firestore()
       
        /*db.collection("user_profile").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }*/
        Auth.auth().createUser(withEmail: Account.text!, password: Password.text!) { (result, error) in
            guard error == nil else {
                //print(error?.localizedDescription)
                let alertcontroller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertcontroller.addAction(okAction)
                self.present(alertcontroller, animated: true, completion: nil)
                return
            }
                    self.dismiss(animated: true, completion: nil)
            var ref: DocumentReference? = nil
                 ref = db.collection("user_profile").addDocument(data: [
                    "email": self.Account.text,
                    "name": "",
                    "introduce":"",
                    "photo_path":""
                 ]) { err in
                     if let err = err {
                         print("Error adding document: \(err)")
                     } else {
                         print("Document added with ID: \(ref!.documentID)")
                     }
            }
        }
    }
    
    @IBAction func sign_in(_ sender: Any) {
        if Auth.auth().currentUser != nil {
        //print("login")
        let alertcontroller = UIAlertController(title: "Error", message: "A account doesn't sign out", preferredStyle: .alert)
                       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alertcontroller.addAction(okAction)
                       self.present(alertcontroller, animated: true, completion: nil)
        
           
            
            return
        } else {
        //print("not login")
            let user = Auth.auth().signIn(withEmail: Account.text!, password: Password.text!) { (result, error) in
                guard error == nil
                else {
                        //print(error?.localizedDescription)
                    var error_message:String = error!.localizedDescription
                    error_message.append("\n If you forget your password,please press the 'Forget Password' button.")
                    let alertcontroller = UIAlertController(title: "Error", message: error_message, preferredStyle: .alert)
                                       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                       alertcontroller.addAction(okAction)
                                       self.present(alertcontroller, animated: true, completion: nil)
                        return
                }
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "toshow", sender:nil)
                
               
        }
            
        }
        
        }
    
    @IBAction func forget_password(_ sender: Any) {
        if Account.text == nil{// 判定是否有輸入郵件
            let nilMessage:String = "The email can't be nil."
            let alertcontroller = UIAlertController(title: "Error", message: nilMessage, preferredStyle: .alert)
                           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                           alertcontroller.addAction(okAction)
                           self.present(alertcontroller, animated: true, completion: nil)
            return
        }
        let Alertcontroller = UIAlertController(title: "Alert", message:"Do you really want to reset your password?\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let Alertcontroller2 = UIAlertController(title: "", message:"We have sent the reset email.\nYou can go to check your mailbox", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .default){(_) in
                 Auth.auth().sendPasswordReset(withEmail: self.Account.text!, completion: nil)
                
            }
            Alertcontroller2.addAction(okAction2)
            self.present(Alertcontroller2, animated: true, completion: nil)
        }
        Alertcontroller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        Alertcontroller.addAction(cancelAction)
        present(Alertcontroller, animated: true, completion: nil)
        
        
    }
    
    
    
    
}

