//
//  QA.swift
//  final1081
//
//  Created by User06 on 2020/1/14.
//  Copyright © 2020 matcha55. All rights reserved.
//

import UIKit
import Firebase
class QA:UICollectionViewController{

    var toA:String?
    var hidden:Bool = false
    @IBSegueAction func toPSegue(_ coder: NSCoder) -> user_pro? {
        return user_pro(coder: coder, account: toA!, ed: false)
    }
    @IBAction func toP(_ sender: UIButton) {
        //print()
        toA = sender.titleLabel?.text
        performSegue(withIdentifier: "toP", sender: nil)
    }
    
    var refreshControl:UIRefreshControl?
   let account:String
    var DataID=[String]()
    var comments = [QueryDocumentSnapshot]()
    let db  = Firestore.firestore()
    init?(coder: NSCoder, account:String) {
       self.account = account
       
       super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
       fatalError()
    }
   
    func getcomments(isupdate:Bool){
      
        let query = db.collection("QA")
        DataID.removeAll()
        comments.removeAll()
        
          self.collectionView.refreshControl?.beginRefreshing()
         query.getDocuments{(querySnapshot,err)in
            if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                
                print(querySnapshot?.documents.count)
                 for document in querySnapshot!.documents {
                    // print("\(document.documentID) => \(document.data())")
                    self.DataID.append(document.documentID)
                    self.comments.append(document)
                    //print(self.comments[self.comments.count-1].get("email") as! String)
                    
                    var indexPaths=[IndexPath]()
                    
                    DispatchQueue.main.async {
                        self.collectionView.insertItems(at: indexPaths)
                    }
                        
                 }
              
             }
           
            
         }
        if self.collectionView.refreshControl?.isRefreshing == true {
                                  self.collectionView.refreshControl?.endRefreshing()
        }
        //print("R")
        
    }
    @objc func refreshcomment(){
        getcomments(isupdate: true)
    }
    override func viewDidLoad() {
        if(account != "cyc00201@gmail.com"){
            hidden = true
        }
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
                   let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                   let width = collectionView.bounds.width
                   layout?.itemSize = CGSize(width: width, height: width)
                   layout?.estimatedItemSize = .zero
                   
       collectionView.refreshControl = UIRefreshControl()
       collectionView.refreshControl?.addTarget(self, action: #selector(refreshcomment), for: .valueChanged)
       
        getcomments(isupdate: true)
         getcomments(isupdate: false)
        //print("C0",comments.count)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
        return comments.count
        }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("STOP0")
        if indexPath.item >= comments.count {
            print("STOP")
            getcomments(isupdate: false)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QAcell", for: indexPath) as! QAcell

        //print("C1",comments.count)
       
        //print("C3",indexPath.item)
  
        if(comments.count>0){
            //print("E:",self.comments[indexPath.item].get("email") as? String)
             cell.A.setTitle(self.comments[indexPath.item].get("email") as? String, for: .normal)
            var text:String = comments[indexPath.item].get("question") as? String? as! String
             
            if(comments[indexPath.item].get("comment") != nil){
                //print("COMMENT")
                text.append( "\nAns:")
                text.append(comments[indexPath.item].get("comment") as! String)
                
            }
            cell.T.text = text
        }
        if(hidden==true){
            cell.C.isHidden = true
            cell.C.isEnabled = false
        }
        
        cell.C.titleLabel?.tag = indexPath.item
            
        
        print("CM\n",indexPath.item)
        
        return cell
    }

    @IBAction func response(_ sender: UIButton) {
       var question:String = ""
        print(sender.titleLabel?.tag)
       let controller = UIAlertController(title: "QA", message: "請輸入你的回答", preferredStyle: .alert)
       controller.addTextField{ (textField) in
          textField.placeholder = "Q/A"
       }
       
       let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
           question=controller.textFields?[0].text ?? ""
          print(question)
           if question.count>=100{
               let controller2 = UIAlertController(title: "alert", message: "請將字數限制100字內", preferredStyle: .alert)
               let okAction2 = UIAlertAction(title: "OK", style: .default, handler: nil)
               controller2.addAction(okAction2)
               self.present(controller2, animated: true, completion: nil)
               return
           };
        print(self.DataID[sender.titleLabel!.tag])
        self.db.collection( "QA").document(self.DataID[sender.titleLabel!.tag]).setData([
            "email":self.comments[sender.titleLabel!.tag].get("email") as?String,
            "question":self.comments[sender.titleLabel!.tag].get("question") as? String,
            "comment":question])
       }
       
       controller.addAction(okAction)
       
            
       
       let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
       
       controller.addAction(cancelAction)
       present(controller, animated: true, completion: nil)
        getcomments(isupdate: true)
        
    }
    @IBAction func new_question(_ sender: Any)
    {
        var question:String = ""
        let controller = UIAlertController(title: "QA", message: "請輸入你的問題", preferredStyle: .alert)
        controller.addTextField{ (textField) in
           textField.placeholder = "Q/A"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            question=controller.textFields?[0].text ?? ""
           print(question)
            if question.count>=100{
                let controller2 = UIAlertController(title: "alert", message: "請將字數限制100字內", preferredStyle: .alert)
                let okAction2 = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller2.addAction(okAction2)
                self.present(controller2, animated: true, completion: nil)
                return
            }; self.db.collection("QA").addDocument(data: [
            "email":self.account,
               "question":question
           ]
           )
        }
        
        controller.addAction(okAction)
        
             
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        getcomments(isupdate: true)
        
    }
    
   
}
