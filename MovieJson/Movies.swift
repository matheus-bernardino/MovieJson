//
//  Movies.swift
//  MovieJson
//
//  Created by Matheus on 25/01/21.
//

import Foundation

class Movies: Codable {
    var page: Int
    var results = [Movie]()
}
