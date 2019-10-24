//
//  Concentration.swift
//  Concentration
//
//  Created by Artyom Yudin on 21.10.2019.
//  Copyright © 2019 Artyom Yudin. All rights reserved.
//

// Concentration Model

import Foundation

class Concentration {

    private (set) var cards = [Card]()
    private (set) var cardsSuffled = [Card]()
    private (set) var flipCount = 0
    private (set) var score = 0
    private var seenCards = Set<Int>()  // seen card sets
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int? = nil
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set (newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue) // true когда выполняется условие в скобках
            }
        }
    }
    
    // private var timeBonus: Int
    
    init (numberOfPairOfCard: Int) {
        for _ in 1...numberOfPairOfCard {
            let card = Card()
            cards += [card,card]
        }
        cards.shuffle() // card suffle
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                print("Second click!") // TODO: Stop timer bonus interval
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    // card is seen or not and set score bonus
                    if seenCards.contains(index) {
                        score -= 1
                    }
                    if seenCards.contains(matchIndex) {
                        score -= 1
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
                print("First click!") // TODO: Start timer bonus interval
            }
            
            flipCount += 1
        }
    }
    
    // reset all values and start neg game
    func startNewGame() {
        flipCount = 0
        score = 0
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle() // card suffle
    }
    
}
