//
//  ViewController.swift
//  Flashcards
//
//  Created by Charlie on 2/9/20.
//  Copyright © 2020 Charlie Nguyen. All rights reserved.
//

import UIKit

struct Flashcard: Codable{
    var question: String
    var answer: String
    var fakeAnswer1: String
    var fakeAnswer2: String
    var fakeAnswer3: String
}

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var wrongAndCorrectLabel: UILabel!
    
    @IBOutlet weak var rightAnswerButton: UIButton!
    @IBOutlet weak var wrongAnswerButton1: UIButton!
    @IBOutlet weak var wrongAnswerButton2: UIButton!
    @IBOutlet weak var wrongAnswerButton3: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current Flashcard Index
    var currentIndex = 0
    
    //Current Color
    var currentLabelColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLabelColor = frontLabel.backgroundColor ?? UIColor.systemBlue
        
        readSavedFlashcards()
        
        wrongAndCorrectLabel.isHidden = true
        if flashcards.count == 0 {
            updateFlashCard(question: "Whats the capital of California?", answer: "Sacramento", fakeAnswer1: "Los Angeles", fakeAnswer2: "San Francisco", fakeAnswer3: "San Diego", isExisting: true)
        } else {
            updateLabels()
            updateNextPrevButotns()
        }
    }

    //MARK: - IBACtions
    @IBAction func didTapOnFlashCard(_ sender: Any) {
        showCorrectAnswer()
    }
    
    @IBAction func didTapOnPrev(_ sender: UIButton) {
        //Increase Current Index
        currentIndex = currentIndex - 1
        
        //Update Labels
        updateLabels()
        
        //Update Buttons
        updateNextPrevButotns()
    }
    
    @IBAction func didTapOnNext(_ sender: UIButton) {
        //Increase Current Index
        currentIndex = currentIndex + 1
        
        //Update Labels
        updateLabels()
        
        //Update Buttons
        updateNextPrevButotns()
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
    
    @IBAction func didTapOnDelete(_ sender: UIButton) {
        //Show Configuration
        let alert = UIAlertController(title: "Delete Flashcard", message: "Are you sure you want to delete this flashcard?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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

//MARK: - Update Cards & Labels
extension ViewController {
    func updateFlashCard(question: String, answer: String, fakeAnswer1: String, fakeAnswer2: String, fakeAnswer3: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer, fakeAnswer1: fakeAnswer1, fakeAnswer2: fakeAnswer2, fakeAnswer3: fakeAnswer3)
        
        if isExisting {
            flashcards[currentIndex] = flashcard
        } else {
            //Adding Flashcard in the Flashcards array
            flashcards.append(flashcard)
            
            saveAllFlashcardsToDisk()
            
            //Logging to the console
            print("Added new flashcard")
            print("We now have \(flashcards.count) flashcards")
            
            //Update current index
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }
        
        //Update Buttons
        updateNextPrevButotns()
        
        //Update Labels
        updateLabels()
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        rightAnswerButton.setTitle(currentFlashcard.answer, for: .normal)
        wrongAnswerButton1.setTitle(currentFlashcard.fakeAnswer1, for: .normal)
        wrongAnswerButton2.setTitle(currentFlashcard.fakeAnswer2, for: .normal)
        wrongAnswerButton3.setTitle(currentFlashcard.fakeAnswer3, for: .normal)
        
        frontLabel.isHidden = false
        rightAnswerButton.backgroundColor = currentLabelColor
        wrongAnswerButton1.backgroundColor = currentLabelColor
        wrongAnswerButton2.backgroundColor = currentLabelColor
        wrongAnswerButton3.backgroundColor = currentLabelColor
        
    }
}

//MARK: - Update Next & Prev Buttons Methods
extension ViewController {
   
    func updateNextPrevButotns() {
        //Disable Next Button is at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable Prev Button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
}

//MARK: - Saving & Reading All Flashcards to Disk
extension ViewController {
    func saveAllFlashcardsToDisk() {
//        let dictionaryArray = flashcards.map { (card) -> [String: String] in
//            return ["question": card.question, "answer": card.answer, "fakeAnswer1": card.fakeAnswer1, "fakeAnswer2": card.fakeAnswer2, "fakeAnswer3": card.fakeAnswer3]
//        }

        //UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(flashcards), forKey: "flashcards")
    }
    
    func readSavedFlashcards() {
        if let data = UserDefaults.standard.value(forKey:"flashcards") as? Data {
            flashcards = try! PropertyListDecoder().decode(Array<Flashcard>.self, from: data)
        }
//        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
//            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
//                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, fakeAnswer1: dictionary["fakeAnswer1"]!, fakeAnswer2: dictionary["fakeAnswer2"]!, fakeAnswer3: dictionary["fakeAnswer3"]!)
//            }
//            flashcards.append(contentsOf: savedCards)
//        }
    }
}

//MARK: - Delete Flashcard
extension ViewController {
    func deleteCurrentFlashcard() {
        flashcards.remove(at: currentIndex)
        
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1;
        }
        updateNextPrevButotns()
        updateLabels()
    }
}
