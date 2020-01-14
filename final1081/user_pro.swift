//
//  user_pro.swift
//  final1081
//
//  Created by User06 on 2020/1/2.
//  Copyright © 2020 matcha55. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage
class user_pro: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    let account:String
    let editable:Bool
    let db  = Firestore.firestore()
    var photo_path :String
   let storage = Storage.storage(url:"gs://final1081.appspot.com")
    init?(coder: NSCoder, account:String,ed:Bool) {
       self.account = account
        self.photo_path=""
        self.editable = ed
       super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photobutton: UIButton!
    @IBOutlet weak var name: UITextField!
 
    @IBOutlet weak var introduce: UITextView!
    @IBOutlet weak var edit_lebal: UILabel!
    @IBOutlet weak var edit_switch: UISwitch!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             textField.resignFirstResponder()
             return true
    }
    @objc func dismisskeyboard(){
          self.view.endEditing(true)
      }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       // print("pick")
        photo.image = image
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
                  if let data = photo.image?.jpegData(compressionQuality: 0.9){
                       fileReference.putData(data, metadata: nil) { (metadata, error) in
                          guard let _ = metadata, error == nil else {
                             return
                          }
                          fileReference.downloadURL(completion: { (url, error) in
                             guard let downloadURL = url else {
                                return
                             }
                             //print(downloadURL)
                            self.photo_path = downloadURL.absoluteString
                          })
                       }
                    }
    }
  
    func update(){
        
        let query = db.collection("user_profile").whereField("email", isEqualTo: account)
        query.getDocuments(){(querySnapshot,err)in
            
            self.name.text = querySnapshot?.documents.first?.get("name").unsafelyUnwrapped as? String
            self.introduce.text = querySnapshot?.documents.first?.get("introduce").unsafelyUnwrapped as? String
            self.photo_path = (querySnapshot?.documents.first?.get("photo_path") as? String)!
            if self.photo_path.isEmpty != false{
               //print("II")
            }
            else{
                print(self.photo_path)
                
                let fileReference = Storage.storage().reference(forURL: self.photo_path)
                fileReference.getData(maxSize: 1024*1024*1024){ (data, error) in
                if let error = error {
                    print("ERROR")
                  // Uh-oh, an error occurred!
                } else {
                  // Data for "images/island.jpg" is returned
                    self.photo.image = UIImage(data: data!)
                    }
                    
                }
            }
        }
    }
    @IBAction func new_photo(_ sender: Any) {
       
        let Message:String = "upload/choose from storage"
        let alertcontroller = UIAlertController(title: "", message: Message, preferredStyle: .alert)
                       let Upload_Action = UIAlertAction(title: "upload", style: .default){(_)in //print("U")
                          let imagePicker = UIImagePickerController()
                            
                              imagePicker.sourceType = .savedPhotosAlbum
                        imagePicker.delegate = self
                              imagePicker.allowsEditing = true
                             
                        self.present(imagePicker,animated:true,completion:nil)
        }
        alertcontroller.addAction(Upload_Action)
        let Choose_Action = UIAlertAction(title: "choose", style: .default){(_)in //print("C")
            
        }
        alertcontroller.addAction(Choose_Action)
        self.present(alertcontroller, animated: true, completion: nil)
    }
    @IBAction func change_user_profile_switch(_ sender: Any) {
        if edit_switch.isOn == true{
            update()
            edit_lebal.text = "關閉儲存"
            name.isEnabled = true
            introduce.isEditable = true
            photobutton.isEnabled = true
            photobutton.isHidden = false
          if photo.image == nil{
               photobutton.setTitle("新增", for:.normal)
               
           }
          else{
                photobutton.setTitle("修改", for:.normal)
            }
           photo.image = nil
            
        }
        else{
            edit_lebal.text = "開啟編輯"
            photobutton.isEnabled = false
            photobutton.isHidden = true
            name.isEnabled = false
            introduce.isEditable = false
            
            let query = db.collection("user_profile").whereField("email", isEqualTo: account)
               
         
            
            if name.text?.isEmpty == true {
                           // print("empty")
                update()
            }
                       else{
                   query.getDocuments(){(querySnapshot,err)in
                           querySnapshot?.documents.first?.reference.updateData(["name":self.name.text!])
                       }
            }
           
            query.getDocuments(){(querySnapshot,err)in
                           querySnapshot?.documents.first?.reference.updateData(["introduce":self.introduce.text!])
        querySnapshot?.documents.first?.reference.updateData(["photo_path":self.photo_path])
           }
        }
                       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(dismisskeyboard))
        
        self.view.addGestureRecognizer(tap)
        if editable == false{
            edit_lebal.isEnabled = false
            edit_lebal.isHidden = true
            edit_switch.isEnabled = false
            edit_switch.isSelected = false
            edit_switch.isHidden = true
        }
        if photo.image == nil{
             photobutton.setTitle("新增", for:.normal)
             photobutton.isHidden = false
        }
        else{
             photobutton.setTitle("修改", for:.normal)
             photobutton.isHidden = true
        }
       
       
        photobutton.isEnabled = false
         update()
        // Do any additional setup after loading the view.
    }
    

}

