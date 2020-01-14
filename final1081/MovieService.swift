//
//  MovieService.swift
//  TmdbDemo
//
//  Created by SHIH-YING PAN on 2019/10/6.
//  Copyright © 2019 SHIH-YING PAN. All rights reserved.
//

import Foundation
import UIKit

class MovieService {
    
    static let shared = MovieService()
    var imageConfiguration: ImageConfiguration?
    let version = 3
    let baseUrlString = "https://api.themoviedb.org"
    let apiKey = "ee3c059c55758c26015f7733d08d62d9"
       
    func getImage(url: URL?, completionHandler: @escaping (UIImage?) -> ()) {
           if let url = url {
               let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   if let data = data, let image = UIImage(data: data) {
                       completionHandler(image)
                   } else {
                       completionHandler(nil)
                   }
               }
               task.resume()
           }
       }
    
    func getConfiguration() {
           var urlComponents = URLComponents(string: baseUrlString)
           urlComponents?.path = "/\(version)/configuration"
           urlComponents?.query = "api_key=\(apiKey)"
           if let url = urlComponents?.url {
               let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                   if let data = data, let movieConfiguration = try? decoder.decode(MovieConfiguration.self, from: data) {
                       self.imageConfiguration = movieConfiguration.images
                   }
               }
               task.resume()
           }
           
           
       }
    
    func getPopular(page: Int, completion: @escaping (Popular?) -> () ) {
        var urlComponents = URLComponents(string: baseUrlString)
        urlComponents?.path = "/\(version)/movie/popular"
        urlComponents?.query = "api_key=\(apiKey)&page=\(page)&language=zh-TW"
        if let url = urlComponents?.url {
             //print(url.description)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
               
                if let data = data, let nowPlaying = try? decoder.decode(Popular.self, from: data) {
                    
                    completion(nowPlaying)
                } else {
                  
                    completion(nil)
                }
            }
            task.resume()
        }
        
    }
    func gettop_rated(page: Int, completion: @escaping (Popular?) -> () ) {
        var urlComponents = URLComponents(string: baseUrlString)
        urlComponents?.path = "/\(version)/movie/top_rated"
        urlComponents?.query = "api_key=\(apiKey)&page=\(page)&language=zh-TW"
        if let url = urlComponents?.url {
             //print(url.description)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
               
                if let data = data, let nowPlaying = try? decoder.decode(Popular.self, from: data) {
                    
                    completion(nowPlaying)
                } else {
                   
                    completion(nil)
                }
            }
            task.resume()
        }
        
    }
      
    
    
}


