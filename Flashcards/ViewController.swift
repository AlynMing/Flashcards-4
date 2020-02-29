//
//  ViewController.swift
//  Flashcards
//
//  Created by Charlie on 2/9/20.
//  Copyright © 2020 Charlie Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var wrongAndCorrectLabel: UILabel!
    
    @IBOutlet weak var rightAnswerButton: UIButton!
    @IBOutlet weak var wrongAnswerButton1: UIButton!
    @IBOutlet weak var wrongAnswerButton2: UIButton!
    @IBOutlet weak var wrongAnswerButton3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wrongAndCorrectLabel.isHidden = true
    }

    //MARK: - IBACtions
    @IBAction func didTapOnFlashCard(_ sender: Any) {
        showCorrectAnswer()
    }
    
    @IBAction func wrongAnswerSelected(_ sender: UIButton) {
        let tempColor = sender.backgroundColor
        sender.backgroundColor = UIColor.red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.backgroundColor = tempColor
        }
        checkIfHidden()
    }
    
    @IBAction func correctAnswerSelected(_ sender: UIButton) {
        sender.backgroundColor = UIColor.green
        showCorrectAnswer()
        wrongAndCorrectLabel.isHidden = false
        wrongAndCorrectLabel.text = "Correct!"
        wrongAndCorrectLabel.textColor = UIColor.green
    }
}

//MARK: - Answer Methods
extension ViewController {
    func showCorrectAnswer() {
        frontLabel.isHidden = !frontLabel.isHidden
    }
}

//MARK: - Wrong And Correct Label Methods
extension ViewController {
    func checkIfHidden() {
        if wrongAndCorrectLabel.isHidden {
            wrongAndCorrectLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.wrongAndCorrectLabel.isHidden = true
            }
        }
    }
}

//MARK: - Segue Functions
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }
}

//MARK: - Update Cards
extension ViewController {
    func updateFlashCard(question: String, answer: String, fakeAnswer1: String, fakeAnswer2: String, fakeAnswer3: String) {
        frontLabel.text = question
        backLabel.text = answer
        
        rightAnswerButton.setTitle(answer, for: .normal)
        wrongAnswerButton1.setTitle(fakeAnswer1, for: .normal)
        wrongAnswerButton2.setTitle(fakeAnswer2, for: .normal)
        wrongAnswerButton3.setTitle(fakeAnswer3, for: .normal)
    }
}
