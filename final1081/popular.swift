//
//  popular.swift
//  final1081
//
//  Created by User06 on 2020/1/13.
//  Copyright © 2020 matcha55. All rights reserved.
//

import Foundation
struct  Movie:Codable {
   var title: String?
    var voteAverage: Float?//平均評分
    var popularity:Float?//熱門度
    var overview: String?
    var id: Int?
    var posterPath: String?
    var original_language:String?
    var release_date:String?//上映日期
    var posterUrl: URL? {
        if let imageConfiguration = MovieService.shared.imageConfiguration, let secureBaseUrl = imageConfiguration.secureBaseUrl, let posterSizes = imageConfiguration.posterSizes, let posterPath = posterPath {
            if posterSizes.count >= 5 {
                return URL(string: "\(secureBaseUrl)\(posterSizes[4])\(posterPath)")

            } else {
                
                return URL(string: "\(secureBaseUrl)\(posterSizes[0])\(posterPath)")
            }
        } else {
            return nil
        }
        
    }
    
}
struct Popular: Codable {
    var page: Int?
    var totalPages: Int?
    var results: [Movie]?
}
