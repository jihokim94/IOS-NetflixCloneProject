//
//  SearchAPI.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/08/17.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import Foundation
class SearchAPI {
    static func search(_ term : String , completion : @escaping ([Movie]) -> Void) {
        let session = URLSession(configuration: .default)

        //URL
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents?.queryItems?.append(mediaQuery)
        urlComponents?.queryItems?.append(entityQuery)
        urlComponents?.queryItems?.append(termQuery)
        
        let requsetURL = urlComponents?.url!
        
        print(requsetURL)
        
        let dataTask = session.dataTask(with: requsetURL!) { data, respone, error in
            let sucessRange = 200..<300
            
            guard error == nil , let statusCode = (respone as? HTTPURLResponse)?.statusCode , sucessRange.contains(statusCode) else {
                completion([])
                return
            }
            guard let resultData = data else {
                completion([])
                return
            }
            
            //data -> [Movie]
            // JSON Parsing
            let string  = String(data: resultData, encoding: .utf8)
            
            // movie 리스트 초기화 및 컴플리션에 바인딩
            //let movies: [Movie]
            let movies = SearchAPI.parseMovies(resultData)
            completion(movies)
            
            print("--> resultData: \(string)")
            
        }
        dataTask.resume()
    }
    
    static func parseMovies (_ data : Data) -> [Movie] {
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
        } catch {
            print("--> Parsing error \(error.localizedDescription)")
            return []
        }
    }
}
