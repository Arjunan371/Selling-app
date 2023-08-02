//
//  ApiIntegration.swift
//  Task
//
//  Created by DineshM on 27/07/23.
//

import Foundation

class ApiIntegration: Any {
    
    func getApi(urlString: String, oncompletion: @escaping(ProductDetails) -> Void, onerror: @escaping (Error) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
        
        let session = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard error == nil else {return}
            
            guard let httpResponse = response else {return}
            
            guard let  datas = data else {return}
            
            do {
                let content = try JSONDecoder().decode(ProductDetails.self, from: datas)
                
                oncompletion(content)
            } catch {
                onerror(error)
                
            }
        }
        session.resume()
    }
}
