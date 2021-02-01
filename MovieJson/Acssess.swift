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
    
    
    func getInfo(completion: @escaping (_ result: Result<Data, Error>)->Void) {
        print("1")
        let baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key=d92e7fcec7193dec7a55b95f3df34292"
//        let key = "a9803992"
        if let url = URL(string: baseUrl) {
            print("2")
            var componets = URLComponents(string: url.absoluteString)
//            componets?.queryItems = [
//                URLQueryItem(name: "apiKey", value: key),
//                URLQueryItem(name: "t", value: "star"),
//                URLQueryItem(name: "page", value: "2")
//            ]
            let session = URLSession.shared
            if let urlFromComponents = componets?.url {
                session.dataTask(with: urlFromComponents) { (Data, URLResponse, error) in
                    print("3")
                    if let error = error {
                        print("4")
//                        print(error?.localizedDescription)
                        completion(.failure(error))
                    }
                    if let data = Data {
//                        if let information = String(data: data, encoding: .utf8) {
//                            print(information)
//                        }
//                        print("5")
                        completion(.success(data))
//                        self.delegate?.sendData(data: data)
//
                    }
                }.resume()
            }
        }
    }
}
