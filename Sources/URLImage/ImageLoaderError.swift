//
//  ImageLoaderError.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import Foundation

enum ImageLoaderError: Error, CustomStringConvertible {

    case networkError(Error)
    case networkUnavailable
    case networkConnectionLost
    case serverUnavailable
    case timeout
    case invalidURL
    case httpError(statusCode: Int)
    case invalidData
    case taskCancelled
    case securityError
    case unknownError
    
    var description: String {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .networkUnavailable:
            return "Network is unavailable. Please check your internet connection."
        case .networkConnectionLost:
            return "Network is unavailable. Network connection lost."
        case .serverUnavailable:
            return "Server is unavailable. Please try again later."
        case .timeout:
            return "The request timed out. Please try again."
        case .invalidURL:
            return "The URL provided is invalid."
        case .httpError(let statusCode):
            return "HTTP error occurred with status code \(statusCode)."
        case .invalidData:
            return "Received invalid data."
        case .taskCancelled:
            return "The image loading task was cancelled."
        case .securityError:
            return "A security error occurred. Please check your network settings."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        }
    }
}
