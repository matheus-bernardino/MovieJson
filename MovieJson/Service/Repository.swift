//
//  Repository.swift
//  MovieJson
//
//  Created by aluno001 on 07/02/21.
//

import Foundation
import UIKit

class Repository {
    static let acssess = Repository()
    
    func getInfo(completion: @escaping (_ result: Result<[Movie], Error>)->Void, searchText: String) {
        let baseUrl = "https://api.themoviedb.org/3"
        
        let key = "d92e7fcec7193dec7a55b95f3df34292"
        if let baseUrl = URL(string: baseUrl) {
            let url = searchText == "" ? baseUrl.appendingPathComponent("movie").appendingPathComponent("popular") : baseUrl.appendingPathComponent("search").appendingPathComponent("movie")
            
            var componets = URLComponents(string: url.absoluteString)
            componets?.queryItems = [
                URLQueryItem(name: "api_key", value: key)
            ]
            if searchText != "" {
                componets?.queryItems?.append(URLQueryItem(name: "query", value: searchText))
            }
            let session = URLSession.shared
            if let urlFromComponents = componets?.url {
                session.dataTask(with: urlFromComponents) { (Data, URLResponse, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                    if let data = Data {
                        do {
                            let decoder = JSONDecoder.init()
                            let movies = try decoder.decode(Movies.self, from: data).results
                            completion(.success(movies))
                        } catch  {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func getImages(completion: @escaping (_ result: Result<[UIImage], Error>)->Void, poster_paths: [String?]) {
        var images: [UIImage] = []
        for poster_path in poster_paths {
            do {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500") {
                    if let posterUrl = poster_path {
                        let novaUrl = url.appendingPathComponent(posterUrl)
                        
                        
                        let data = try Data(contentsOf: novaUrl)
                        images.append(UIImage(data: data) ?? UIImage())
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        completion(.success(images))
    }
}
