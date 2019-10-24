//
//  ViewController.swift
//  Concentration
//
//  Created by Artyom Yudin on 21.10.2019.
//  Copyright © 2019 Artyom Yudin. All rights reserved.
//

import UIKit

// Extension for random
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
    private var gameBackground: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private var cardBackground: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    
    // Dictionary Emoji Themes with emoji, game backgraund color and card skin color
    private var emojiThemes: [String:(emojiList: [String], gameSkin: UIColor, cardSkin: UIColor)] = [
        "Animals" : (["🐶","🐱","🐭","🐰","🦊","🐯","🐷","🐸","🐵","🐥","🦆","🐍","🐜","🐴","🐝","🐢"], #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) ),
        "Foods" : (["🍏","🍐","🍊","🍋","🍌","🍇","🍓","🍒","🍍","🍆","🍅","🥦","🥔","🥕","🥝","🌽"], #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
        "Cars" : (["🚗","🚕","🚙","🚌","🚎","🚓","🚑","🚒","🚐","🚚","🚛","🚜","🚲","🛵","🏍","🛴"], #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
        "Sport" : (["⛷","🏂","🏋️‍♀️","🤼‍♀️","🤸‍♀️","⛹️‍♀️","🤺","🤾‍♀️","🏌️‍♀️","🏇","🧘‍♀️","🐍","🏊‍♀️","🤽‍♀️","🚣‍♀️","🚴‍♀️"], #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        "Building" : (["⛺️","🏠","🏚","🏭","🏢","🏬","🏤","🏥","🏦","🏫","🏛","⛪️","🕌","🗼","🏰","🏯"], #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
        "Face" : (["👶","👧","🧒","👦","👩","👨","👱‍♀️","🧔","👵","🧓","👴","👲","👳‍♀️","👳‍♂️","👸","👰"], #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
    ]
    
    private var indexTheme = 0 {
        didSet {
            emoji = [:]
            (emojiChoices, gameBackground, cardBackground) = emojiThemes[emojiThemeKeys[indexTheme]] ?? ([], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
            view.backgroundColor = gameBackground
            themeNameLabel.text = emojiThemeKeys[indexTheme]
        }
    }

    private var emojiThemeKeys: [String] {
        return Array(emojiThemes.keys)
    }
    
    @IBOutlet private weak var themeNameLabel: UILabel!
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
        game.startNewGame()
        indexTheme = emojiThemeKeys.count.arc4random
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTheme = emojiThemeKeys.count.arc4random
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitle(emoji(for: card), for: .normal)
            } else {
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardBackground
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

