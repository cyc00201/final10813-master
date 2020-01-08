//
//  user_interview.swift
//  final1081
//
//  Created by User06 on 2019/12/18.
//  Copyright © 2019 matcha55. All rights reserved.
//

import UIKit
import FirebaseAuth
class user_interview: UIViewController {

    let account:String
    
    init?(coder: NSCoder, account: String) {
        self.account = account
       super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
       fatalError()
    }
    @IBSegueAction func topro(_ coder: NSCoder) -> user_pro? {
        return user_pro(coder: coder, account: account)
        
    }
    @IBOutlet weak var Account: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Account.text = account
    }
    
}


