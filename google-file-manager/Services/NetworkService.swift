//
//  NetworkService.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 11.06.2022.
//

import Foundation

let sheetId = "1VHTwoVjLhpKplz0O0zGitzVLeGHfucFwYITJySSLSX4"

// Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

class NetworkService: NSObject {
    
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func getFiles(url: URL, completion: @escaping (Result<[FilesModel]?, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(GoogleService.accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error dataTask: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let jsonData = data else {
                print("Error receiving data")
                return
            }
            
            do {
                let googleSheet = try JSONDecoder().decode(GoogleSheet.self, from: jsonData)
                print("Ок. Successfully received googleSheet")
                
                filesArray = [FilesModel]()
                for json in googleSheet.values {
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
        }
            task.resume()
    }
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

//MARK: MOCK
class MockURLSession: URLSessionProtocol {

    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }

}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}


