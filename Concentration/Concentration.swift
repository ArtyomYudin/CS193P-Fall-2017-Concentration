//
//  Concentration.swift
//  Concentration
//
//  Created by Artyom Yudin on 21.10.2019.
//  Copyright © 2019 Artyom Yudin. All rights reserved.
//

// Модель игры Concentration

import Foundation

class Concentration {

    private (set) var cards = [Card]()
    private (set) var cardsSuffled = [Card]()
    private (set) var flipCount = 0
    private (set) var score = 0
    private var seenCards = Set<Int>()  // индексы уже увиденных карт
    
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
    
    init (numberOfPairOfCard: Int) {
        for _ in 1...numberOfPairOfCard {
            let card = Card()
            cards += [card,card]
        }
        // TODO: Shuffle the card
        cards.shuffle()
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    // тут делаем проверку былали уже просмотренна карта или нет
                    if seenCards.contains(index) {
                        score -= 1
                        print("карта уже просматривалась! \(index)")
                    }
                    if seenCards.contains(matchIndex) {
                        score -= 1
                        print("карта уже просматривалась! \(matchIndex)")
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            
            flipCount += 1
            print(seenCards)
        } else {
            print("Кликаем в пустоту !")
        }
    }
    
    func startNewGame() {
        flipCount = 0
        score = 0
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }
    
}
