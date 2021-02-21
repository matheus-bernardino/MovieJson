//
//  Acssess.swift
//  MovieJson
//
//  Created by aluno001 on 31/01/21.
//

import Foundation

//protocol InfoReceived : class {
//    func sendData(data: Data)
//}

class Acssess {
//    var delegate: InfoReceived?
    
    
    func getInfo(completion: @escaping (_ result: Result<Data, Error>)->Void, searchText: String) {
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
                        completion(.failure(error))
                    }
                    if let data = Data {
                        if let information = String(data: data, encoding: .utf8) {
                            print(information)
                        }
                        completion(.success(data))
                    }
                }.resume()
            }
        }
    }
}
