//
//  ImageLoadOperation.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import Foundation
import UIKit

fileprivate enum Constants {
    enum Keys {
        static let bytesReceived = "countOfBytesReceived"
    }
}

final class ImageLoadOperation: Operation {
    
    private let url: URL
    private let session: URLSession
    private let completionHandler: (Result<UIImage, ImageLoaderError>) -> Void
    private let progressHandler: ((Double) -> Void)?
    private var dataTask: URLSessionDataTask?
    
    init(url: URL, session: URLSession = URLSession.shared, completionHandler: @escaping (Result<UIImage, ImageLoaderError>) -> Void, progressHandler: ((Double) -> Void)? = nil) {
        self.url = url
        self.session = session
        self.completionHandler = completionHandler
        self.progressHandler = progressHandler
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleNetworkError(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if !(200...299).contains(statusCode) {
                    self.completionHandler(.failure(.httpError(statusCode: statusCode)))
                    return
                }
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                self.completionHandler(.failure(.invalidData))
                return
            }
            
            self.completionHandler(.success(image))
        }
        
        if let _ = progressHandler {
            dataTask?.addObserver(self, forKeyPath: Constants.Keys.bytesReceived, options: .new, context: nil)
        }
        
        dataTask?.resume()
    }
    
    private func handleNetworkError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                self.completionHandler(.failure(.networkUnavailable))
            case .timedOut:
                self.completionHandler(.failure(.timeout))
            case .cannotConnectToHost:
                self.completionHandler(.failure(.serverUnavailable))
            case .networkConnectionLost:
                self.completionHandler(.failure(.networkConnectionLost))
            case .cancelled:
                self.completionHandler(.failure(.taskCancelled))
            case .badURL, .unsupportedURL:
                self.completionHandler(.failure(.invalidURL))
            case .secureConnectionFailed:
                self.completionHandler(.failure(.securityError))
            default:
                self.completionHandler(.failure(.unknownError))
            }
        } else {
            self.completionHandler(.failure(.networkError(error)))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let task = object as? URLSessionTask, keyPath == Constants.Keys.bytesReceived else {
            return
        }
        
        let totalBytesReceived = task.countOfBytesReceived
        let totalBytesExpected = task.countOfBytesExpectedToReceive
        let progress = Double(totalBytesReceived) / Double(totalBytesExpected)
        progressHandler?(progress)
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    func pause() {
        if let task = dataTask {
            switch task.state {
            case .suspended:
                task.resume()
            case .running:
                task.suspend()
            default:
                break
            }
        }
    }
}

extension ImageLoadOperation {
    func testFuncGetURLSessionDataTask() -> URLSessionDataTask? {
        return dataTask
    }
}
