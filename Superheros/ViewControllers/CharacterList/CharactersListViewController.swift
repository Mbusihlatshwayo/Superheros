//
//  CharactersListViewController.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import UIKit
import CoreData

class CharactersListViewController: UIViewController
{
    enum Section
    {
        case main
    }
    
    var characters: [Character] = [Character]()
    var filteredCharacters: [Character] = [Character]()
    var specificCharacters: [Character] = [Character]()
    
    var shouldGoToNextCharacterPage = true
    var shouldGoToNextNamedCharacterPage = true
    var isSearchingForSpecificCharacter = false
    
    var characterSearchOffset = 0
    var specificCharactersOffset = 0
    
    @IBOutlet weak var heroSearchBar: UISearchBar!
    @IBOutlet weak var heroCollectionView: UICollectionView!
    var collectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section, Character>!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
        configureDataSource()
        getHeroes(for: characterSearchOffset)
    }

    func configureSearchBar()
    {
        heroSearchBar.delegate = self
    }

    func configureCollectionView()
    {
        heroCollectionView.register(UINib.init(nibName: Constants.kHeroCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.kHeroCellReuseId)
        heroCollectionView.collectionViewLayout = createThreeColumnFlowLayout()
        heroCollectionView.delegate = self
    }
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout
    {
        let width: CGFloat = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    func configureDataSource()
    {
        collectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: heroCollectionView, cellProvider: { collectionView, indexPath, character in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kHeroCellReuseId, for: indexPath) as! HeroCollectionViewCell
            cell.contentView.isUserInteractionEnabled = false
            cell.set(hero: character)
            return cell
        })
    }
    
    func updateData(with characters: [Character])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        DispatchQueue.main.async { self.collectionViewDiffableDataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func resetSearchOffset()
    {
        characterSearchOffset = 0
        specificCharactersOffset = 0
    }
    
    func getHeroes(for page: Int)
    {
        showLoadingView()
        NetworkManager.shared.getHeroes(offset: page, publicKey: NetworkManager.MarvelPublicApiKey) { [weak self] characters, errorString in
            self?.dismissLoadingView()
            if errorString == nil
            {
                guard let retreivedCharacters = characters else {
                    return
                }

                for retreivedCharacter in retreivedCharacters
                {
                    PersitenceManager.shared.updateWith(character: retreivedCharacter, actionType: .add) { _ in }
                }
            
                if characters?.count ?? 0 < 100
                {
                    self?.shouldGoToNextCharacterPage = false
                }
                self?.characters.append(contentsOf: characters ?? [Character]())
                self?.updateData(with: self?.characters ?? [Character]())
            }
            else
            {
                self?.resetSearchOffset()
                PersitenceManager.shared.retrieveCharacters { [weak self] result in
                    switch result {
                    case .success(let characters):
                        DispatchQueue.main.async {
                            self?.updateData(with: characters)
                        }
                    case .failure(_):
                        return
                    }
                }
            }
        }
    }
    
    func getHeroes(with name: String, for page: Int)
    {
        guard name.isEmpty == false else { return }
        showLoadingView()
        NetworkManager.shared.getHeroesWithName(offset: specificCharactersOffset, nameStartingWith: name) { [weak self] characters, errorString in
            self?.dismissLoadingView()
            if errorString == nil
            {
                if characters?.count ?? 0 < 100
                {
                    self?.shouldGoToNextNamedCharacterPage = false
                }
                self?.specificCharacters.append(contentsOf: characters ?? [Character]())
                self?.updateData(with: self?.specificCharacters ?? [Character]())
            }
        }
    }

}

extension CharactersListViewController: UICollectionViewDelegate
{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height
        {
            if isSearchingForSpecificCharacter == false && heroSearchBar.text?.isEmpty == true && shouldGoToNextCharacterPage == true
            {
                characterSearchOffset += 100
                getHeroes(for: characterSearchOffset)
            }
            else if isSearchingForSpecificCharacter == true && shouldGoToNextNamedCharacterPage == true && heroSearchBar.text?.isEmpty == false
            {
                specificCharactersOffset += 100
                getHeroes(with: heroSearchBar.text ?? "", for: specificCharactersOffset)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let presentedArray = isSearchingForSpecificCharacter ? specificCharacters : characters
        let character = presentedArray[indexPath.item]

        let characterViewController = CharacterInfoViewController()
        characterViewController.character = character
        let navController = UINavigationController(rootViewController: characterViewController)
        present(navController, animated: true)
    }
}

extension CharactersListViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard let filter = searchBar.text, filter.isEmpty == false else {
            specificCharacters.removeAll()
            updateData(with: characters)
            isSearchingForSpecificCharacter = false
            return
        }
        
        filteredCharacters = characters.filter { ($0.name?.lowercased().contains(filter.lowercased())) ?? false }
        updateData(with: filteredCharacters)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let filter = searchBar.text, filter.isEmpty == false else { return }
        isSearchingForSpecificCharacter = true
        getHeroes(with: filter, for: specificCharactersOffset)
    }
}
