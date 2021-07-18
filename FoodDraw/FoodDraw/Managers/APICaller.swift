//
//  APICaller.swift
//  APICaller
//
//  Created by Hao Qin on 7/17/21.
//

import UIKit

final class APICaller {
  static let shared = APICaller()
  
  private init() {}
  
  private let baseApiUrl = "https://api.yelp.com/v3"
  
  private enum APIError: Error {
    case failedToGetData
  }
  
  private enum HTTPMethod: String {
    case GET
  }
  
  private func creatRequestWith(
    with url: URL?,
    type: HTTPMethod,
    completion: @escaping (URLRequest) -> Void
  ) {
    guard let apiUrl = url else { return }
    var request = URLRequest(url: apiUrl)
    request.setValue("Bearer \(YelpApiSecret.apiKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = type.rawValue
    completion(request)
  }
  
  func getImageUrl(for name: String, location: String, completion: @escaping (Result<URL?, Error>) -> Void) {
    let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    creatRequestWith(
      with: URL(string: baseApiUrl + "/businesses/search?term=\(encodedName)&location=\(encodedLocation)&limit=1"),
      type: HTTPMethod.GET
    ) { request in
      URLSession.shared.dataTask(with: request) { data, _ , error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(YelpBusinesses.self, from: data)
          let url = result.businesses.first?.image_url
          completion(.success(URL(string: url ?? "")))
        } catch {
          print(error.localizedDescription)
          completion(.failure(error))
        }
      }
      .resume()
    }
  }
  
  public func downloadImage(with url: URL?, completion: @escaping (UIImage?) -> Void) {
    guard let url = url else {
      completion(nil)
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil, let image = UIImage(data: data) else {
        completion(nil)
        return
      }
      completion(image)
    }
    task.resume()
  }
}
