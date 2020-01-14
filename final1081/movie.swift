//
//  movie.swift
//  final1081
//
//  Created by User06 on 2020/1/8.
//  Copyright © 2020 matcha55. All rights reserved.
//

import UIKit

class movie: UICollectionViewController {
    @IBOutlet weak var bar_title: UINavigationItem!
    var refreshControl: UIRefreshControl!
     var movies = [Movie]()
    var id:Int = 0
    var pagenum : Int = 0

    @IBOutlet weak var PRswitch: UISwitch!
    @IBSegueAction func showdetail(_ coder: NSCoder) -> moviedetail? {
        
        return moviedetail(coder: coder, mdetail: movies[id])
    }
    @IBAction func PRswitch_action(_ sender: Any) {
        if PRswitch.isOn == false{
            bar_title.title = "熱門度排序"
            
            
        }
        else{
            bar_title.title = "平均評分排序"
        }
        pagenum = 0
        getMovies()
    }
    func getMovies() {
           var fetchPage = 1 + pagenum
           
        if fetchPage == 1 || fetchPage <= 100 {
            if PRswitch.isOn == false{
                MovieService.shared.getPopular(page: fetchPage) { (popular) in
                    if let popular = popular, let results = popular.results {
                        if fetchPage == 1 {
                            self.pagenum = 1
                            self.movies = results
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                if self.collectionView.refreshControl?.isRefreshing == true {
                                    self.collectionView.refreshControl?.endRefreshing()
                                }
                            }
                        } else if fetchPage == self.pagenum + 1 {
                            self.pagenum = fetchPage
                            var indexPaths = [IndexPath]()
                            for i in self.movies.count..<self.movies.count + results.count {
                                indexPaths.append(IndexPath(item: i, section: 0))
                            }
                            self.movies.append(contentsOf: results)
                            DispatchQueue.main.async {
                                self.collectionView.insertItems(at: indexPaths)
                            }
                        }
                    }
                }
            }
            else{
                MovieService.shared.gettop_rated(page: fetchPage) { (popular) in
                    if let popular = popular, let results = popular.results {
                        if fetchPage == 1 {
                            self.pagenum = 1
                            self.movies = results
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                if self.collectionView.refreshControl?.isRefreshing == true {
                                    self.collectionView.refreshControl?.endRefreshing()
                                }
                            }
                        } else if fetchPage == self.pagenum + 1 {
                            self.pagenum = fetchPage
                            var indexPaths = [IndexPath]()
                            for i in self.movies.count..<self.movies.count + results.count {
                                indexPaths.append(IndexPath(item: i, section: 0))
                            }
                            self.movies.append(contentsOf: results)
                            DispatchQueue.main.async {
                                self.collectionView.insertItems(at: indexPaths)
                            }
                        }
                    }
                }
            }
           }
               
           
       }
    @objc func refreshMovie() {
        getMovies()
    }
    override func viewDidLoad() {
            super.viewDidLoad()
        
            refreshControl = UIRefreshControl()
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let width = (collectionView.bounds.width - 5) / 2
            layout?.itemSize = CGSize(width: width, height: width)
            layout?.estimatedItemSize = .zero
            
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshMovie), for: .valueChanged)
        collectionView.refreshControl?.beginRefreshing()
            MovieService.shared.getConfiguration()
            getMovies()
           
        }

        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
            return movies.count
        }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.item == movies.count - 1 {
            getMovies()
        }
    }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviecell", for: indexPath) as! moviecell
            
            // Configure the cell
            let movie = movies[indexPath.item]
           // print(cell.moviedetail)
            cell.image.image = UIImage(systemName: "film")
            MovieService.shared.getImage(url: movie.posterUrl) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.image.image = image
                    }
                }
            }
        
            return cell
        }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // print(movies[indexPath.item])
        id = indexPath.item
        self.performSegue(withIdentifier: "showdetail", sender:nil)
    }
        
   
    
    }
