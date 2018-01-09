//
//  JsonHttpRequest.swift
//  EveDatabase
//
//  Created by Koulutus on 21.11.2017.
//  Copyright © 2017 ?. All rights reserved.
//

import Foundation

class JsonHttpRequest {
    private var data: Data?
    private var response: URLResponse?
    private var error: Error?
    
    private let group = DispatchGroup();
    private let address: URL;
    
    init(address: URL) {
        self.address = address;
    }
    
    func perform() throws -> Any {
        performDataTask(address: self.address);
        guard let receivedData = self.data, let httpResponse = self.response as? HTTPURLResponse, self.error == nil else {
            throw error!;
        };
        let jsonData = try JSONSerialization.jsonObject(with: receivedData, options: []);
        try handleHttpResponse(json: jsonData, statusCode: httpResponse.statusCode);
        return jsonData;
    }
    
    private func performDataTask (address: URL) {
        group.enter();
        URLSession.shared.dataTask(with: address, completionHandler: {(data, response, error) in
            self.data = data;
            self.response = response;
            self.error = error;
            self.group.leave();
        }).resume();
        group.wait();
    }
    
    enum HttpError: Error {
        case error404(String);
        case internalServerError(String);
        case otherHttpError(Int);
    }
    
    private func handleHttpResponse(json: Any, statusCode: Int) throws {
        switch statusCode {
        case 200:
            break;
        case 404:
            guard let error = json as? [String:Any], let errorMsg = error["error"] as? String else {
                throw HttpError.otherHttpError(statusCode);
            }
            throw HttpError.error404(errorMsg);
        case 500:
            guard let error = json as? [String:Any], let errorMsg = error["error"] as? String else {
                throw HttpError.otherHttpError(statusCode);
            }
            throw HttpError.internalServerError(errorMsg);
        default:
            throw HttpError.otherHttpError(statusCode);
        }
    }
}
