//
//  ViewController.swift
//  ItsAZooInThere
//
//  Created by Miranda Li on 4/15/19.
//  Copyright © 2019 Miranda Li. All rights reserved.
//

import UIKit
import AVFoundation

class Animal {

    //MARK: Properties
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    let soundPath: String
    
    //MARK: Initialization
    init(name: String, species: String, age: Int, image: UIImage, soundPath: String) {
        
        // Initialize stored properties.
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
        
    }
}

extension Animal: CustomStringConvertible {
    var description : String {
        return "(Animal: name =\(name), species = \(species) , age = \(age)"
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func changeLabel(){
        let pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        nameLabel.text = animals[pageNumber].species
    }
    
    var images = [UIImage]()
    var animals = [Animal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //ref:https://www.codementor.io/taiwoadedotun/ios-swift-implementing-photos-app-image-scrolling-with-scroll-views-bkbcmrgz5
        images = [#imageLiteral(resourceName: "AnimalImages-cat"), #imageLiteral(resourceName: "AnimalImages-dog"), #imageLiteral(resourceName: "AminalImages-lion")]
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width:1125, height: 500)
        
        //ref: https://codewithchris.com/avaudioplayer-tutorial/
        let cat = Animal(name: "Snowball", species: "Cat", age:9999, image: images[0], soundPath:Bundle.main.path(forResource: "catsound", ofType: "mp3")!)
        
        let dog = Animal(name: "Coffee", species: "Dog", age:6, image: images[1], soundPath:Bundle.main.path(forResource: "dogsound", ofType: "mp3")!)
        
        let lion = Animal(name: "Simba", species: "Lion", age:12, image: images[2], soundPath:Bundle.main.path(forResource: "lionsound", ofType: "mp3")!)
        
        //ref: https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
        animals = [cat, dog, lion].shuffled()
        
        // ref: https://medium.com/@farhansyed/how-to-swipe-through-images-with-uiimageview-uiscrollview-c3b26c03e9a5
        for i in 0..<3 {
            let imageView = UIImageView()
            imageView.image = animals[i].image
            let xPosition = 375 * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
            
        }
        
        for i in 0..<3 {
            let button = UIButton(type: .system)
            button.setTitle(animals[i].name, for: .normal)
            let xPosition = 375 * CGFloat(i)
            button.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            button.tag = i
            button.addTarget(self, action: #selector(alertAndSound), for: .touchUpInside)
            scrollView.addSubview(button)
        }
    
        changeLabel()
        
    }
    
    func buttonTapped(sender: UIButton){
        //ref: lecture in-class demonstration
        let animalIndex = sender.tag
        let alertController = UIAlertController(
            title: "Hello!", message: "name: \(animals[animalIndex].name);\r species: \(animals[animalIndex].species); \r age: \(animals[animalIndex].age);", preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "OK!",
            style: .default
        ))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func playSound(sender: UIButton){
        //ref: https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
        var animalSoundEffect: AVAudioPlayer?
        let animalIndex2 = sender.tag
        let url = URL(fileURLWithPath: animals[animalIndex2].soundPath)
        do {
            animalSoundEffect = try AVAudioPlayer(contentsOf: url)
            animalSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    @objc func alertAndSound(sender: UIButton){
        playSound(sender: sender)
        buttonTapped(sender: sender)
        
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //ref: https://stackoverflow.com/questions/46930402/change-label-text-while-image-in-uiscrollview-changes
        let imageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        switch imageNumber {
        case 0:
            nameLabel.text = animals[0].species
        case 1:
            nameLabel.text = animals[1].species
        case 2:
            nameLabel.text = animals[2].species
        default:
            nameLabel.text = "Unknown"
    }
}

}
