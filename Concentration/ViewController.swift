//
//  ViewController.swift
//  Concentration
//
//  Created by Artyom Yudin on 21.10.2019.
//  Copyright © 2019 Artyom Yudin. All rights reserved.
//

import UIKit

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
}

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairOfCard: numberOfPairOfCard)
    
    var numberOfPairOfCard: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private var emoji = [Int:String]()
    private var emojiChoices = [String]()
    
    private var emojiThemes = [
        "Animals" : ["🐶","🐱","🐭","🐰","🦊","🐯","🐷","🐸","🐵","🐥","🦆","🐍","🐜","🐴","🐝","🐢"],
        "Foods" : ["🍏","🍐","🍊","🍋","🍌","🍇","🍓","🍒","🍍","🍆","🍅","🥦","🥔","🥕","🥝","🌽"],
        "Cars" : ["🚗","🚕","🚙","🚌","🚎","🚓","🚑","🚒","🚐","🚚","🚛","🚜","🚲","🛵","🏍","🛴"],
        "Sport" : ["⛷","🏂","🏋️‍♀️","🤼‍♀️","🤸‍♀️","⛹️‍♀️","🤺","🤾‍♀️","🏌️‍♀️","🏇","🧘‍♀️","🐍","🏊‍♀️","🤽‍♀️","🚣‍♀️","🚴‍♀️"],
        "Building" : ["⛺️","🏠","🏚","🏭","🏢","🏬","🏤","🏥","🏦","🏫","🏛","⛪️","🕌","🗼","🏰","🏯"],
        "Face" : ["👶","👧","🧒","👦","👩","👨","👱‍♀️","🧔","👵","🧓","👴","👲","👳‍♀️","👳‍♂️","👸","👰"],
        
    ]
    
    private var indexTheme = 0 {
        didSet {
            emoji = [:]
            emojiChoices = emojiThemes[emojiThemeKeys[indexTheme]] ?? []
        }
    }

    private var emojiThemeKeys: [String] {
        return Array(emojiThemes.keys)
    }
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBAction private func tochCard(_ sender: UIButton) {
        if let  cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func touchNewGame(_ sender: UIButton) {
        indexTheme = emojiThemeKeys.count.arc4random
        game.startNewGame()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = emojiThemeKeys.count.arc4random
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitle(emoji(for: card), for: .normal)
            } else {
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                button.setTitle("", for: .normal)
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randonIndex = emojiChoices.count.arc4random
            emoji[card.identifier] = emojiChoices.remove(at: randonIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

