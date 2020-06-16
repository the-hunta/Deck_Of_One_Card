//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Hunter Smith on 6/16/20.
//  Copyright © 2020 Warren. All rights reserved.
//

import UIKit

class CardController {
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=1") else {return completion(.failure(.invalidURL))}
      // 2 - Contact server
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevel = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevel.cards.first else { return completion(.failure(.noData))}
                return completion(.success(card))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
      // 3 - Handle errors from the server
        
      // 4 - Check for json data
        
      // 5 - Decode json into a Card
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {

      // 1 - Prepare URL
        let finalURL = card.image
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))}
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            return completion(.success(image))
        }.resume()
    }
}

