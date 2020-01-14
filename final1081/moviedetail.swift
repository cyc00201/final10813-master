//
//  moviedetail.swift
//  final1081
//
//  Created by User06 on 2020/1/13.
//  Copyright © 2020 matcha55. All rights reserved.
//

import UIKit

class moviedetail: UIViewController {

    let mdetail:Movie
    @IBOutlet weak var titler: UILabel!
    
    @IBOutlet weak var voteAvaerage: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var overview: UITextView!
    init?(coder: NSCoder, mdetail: Movie) {
        self.mdetail = mdetail
       
       super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         titler.text = mdetail.title
        voteAvaerage.text = mdetail.voteAverage?.description
        popularity.text = mdetail.popularity?.description
        overview.text = mdetail.overview
        MovieService.shared.getImage(url: mdetail.posterUrl) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.photo.image = image
                }
            }
        }
        // Do any additional setup after loading the view.
    }


}


