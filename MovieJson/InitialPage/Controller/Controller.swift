//
//  Controller.swift
//  MovieJson
//
//  Created by aluno001 on 15/02/21.
//

import UIKit
import Foundation
import CoreData

class Controller {
    private let context = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    func saveMovie(movie: Movie) {
        let movieState = MovieState(context: context)
        movieState.title = movie.original_title
        movieState.sinopse = movie.overview
        movieState.poster_link = movie.poster_path
        saveContext()
    }
    
    func loadMovies() -> [MovieState]{
        let request = NSFetchRequest<MovieState>(entityName: "MovieState")
        do {
            let movies = try context.fetch(request)
            return movies
        } catch  {
            print(error.localizedDescription)
        }
        return [MovieState]()
    }
    
    func removeMovie(movie: Movie) {
        let movies = loadMovies()
        for movieState in movies {
            if movieState.title == movie.original_title {
                context.delete(movieState)
                saveContext()
                break
            }
        }
    }
    
    func saveContext () {
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
