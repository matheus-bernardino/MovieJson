//
//  Acssess.swift
//  MovieJson
//
//  Created by aluno001 on 31/01/21.
//

import Foundation

protocol InfoReceived : class {
    func sendData(data: Data)
}

class Acssess {
    var delegate: InfoReceived?
    
    
    func getInfo() {
        print("1")
        let baseUrl = "https://www.omdbapi.com"
        let key = "a9803992"
        if let url = URL(string: baseUrl) {
            print("2")
            var componets = URLComponents(string: url.absoluteString)
            componets?.queryItems = [
                URLQueryItem(name: "apiKey", value: key),
                URLQueryItem(name: "t", value: "star")
            ]
            let session = URLSession.shared
            if let urlFromComponents = componets?.url {
                session.dataTask(with: urlFromComponents) { (Data, URLResponse, Error) in
                    print("3")
                    if Error != nil {
                        print("4")
                        print(Error?.localizedDescription)
                    }
                    if let data = Data {
                        print("5")
                        self.delegate?.sendData(data: data)
//                        if let information = String(data: data, encoding: .utf8) {
//                            print(information)
//                        }
                    }
                }.resume()
            }
        }
    }
}
