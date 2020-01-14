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

    var refreshControl:UIRefreshControl?
   let account:String
    var toA:String?
    var comments = [QueryDocumentSnapshot]()
    let db  = Firestore.firestore()
    init?(coder: NSCoder, account:String) {
       self.account = account
       
       super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
       fatalError()
    }
    @IBSegueAction func to_other_profs(_ coder: NSCoder) -> user_pro? {
        return user_pro(coder: coder, account: toA!,ed:false)
    }
    func getcomments(isupdate:Bool){
        if(isupdate == false)
        {
            return
        }
        let query = db.collection("QA")
        
         query.getDocuments{(querySnapshot,err)in
            if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                var indexPaths = [IndexPath]()
                print(querySnapshot?.documents.count)
                 for document in querySnapshot!.documents {
                     print("\(document.documentID) => \(document.data())")
                    self.comments.append(document)
                    print(self.comments[self.comments.count-1].get("email") as! String)
                    DispatchQueue.main.async {
                        self.collectionView.insertItems(at: indexPaths)
                    }
                 }
             }
         }
        print("R")
        
    }
    @objc func refreshcomment(){
        getcomments(isupdate: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
                   let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                   let width = collectionView.bounds.width
                   layout?.itemSize = CGSize(width: width, height: width)
                   layout?.estimatedItemSize = .zero
                   
       collectionView.refreshControl = UIRefreshControl()
       collectionView.refreshControl?.addTarget(self, action: #selector(refreshcomment), for: .valueChanged)
       collectionView.refreshControl?.beginRefreshing()
        getcomments(isupdate: true)
     
        print("C0",comments.count)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
        return comments.count
        }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("STOP0")
        if indexPath.item >= comments.count-1 {
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
             cell.T.text = comments[indexPath.item].get("question") as? String
        }
       
        
        
        return cell
    }

    @IBAction func new_question(_ sender: Any)
    {
        var question:String = ""
        let controller = UIAlertController(title: "QA", message: "請輸入你的問題/回答", preferredStyle: .alert)
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
        
    }
    
   
}
