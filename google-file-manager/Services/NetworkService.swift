//
//  NetworkService.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 11.06.2022.
//

import Foundation

let sheetId = "1VHTwoVjLhpKplz0O0zGitzVLeGHfucFwYITJySSLSX4"

class NetworkService: NSObject {
    func getFiles(completion: @escaping (Result<[FilesModel]?, Error>) -> Void) {
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId)/values/Sheet1!A1:D1000"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(GoogleService.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { jsonData, _, error in
            if let error = error {
                print("Error dataTask: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let jsonData = jsonData else {
                print("Error receiving data")
                return
            }
            
            do {
                let googleSheet = try JSONDecoder().decode(GoogleSheet.self, from: jsonData)
                print("Ок. Successfully received Soc")
                
//                socName = data.i.name
//                socUrlImage = soc.image
//                socText = soc.text
                for json in googleSheet.values {
//                    var trackArray = [Track]()
//                    for lesson in seria.lessons {
//                        trackArray.append(Track(number: lesson.number, name: lesson.name, albumName: seria.name, duration: secToTime(duration: Double(lesson.duration)), url: lesson.url, image: lesson.image))
//                    }
                    
                   filesArray.append(FilesModel(json: json))
                }
                
                completion(.success(filesArray))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                completion(.failure(error!))
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(error!))
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(error!))
            } catch {
                print("error: ", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
}

