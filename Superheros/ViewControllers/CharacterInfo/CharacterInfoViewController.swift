//
//  CharacterInfoViewController.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/28/21.
//

import UIKit

class CharacterInfoViewController: UIViewController
{

    @IBOutlet weak var characterImageView: MSHeroImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterBioTextView: UITextView!
    
    var character: Character!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureNavBar()
        configureView()
    }
    
    func configureNavBar()
    {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismssViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureView()
    {
        characterImageView.downloadImage(from: "\(character.thumbnail?.path ?? "")/\(Constants.kLargeImageSize).\(character.thumbnail?.thumbnailExtension ?? "")")
        characterName.text = character.name
        characterBioTextView.text = character.bio?.isEmpty == true ? "We don't have a bio for \(character.name ?? "") :(" : character.bio
    }
    
    @objc func dismssViewController()
    {
        dismiss(animated: true)
    }
}
