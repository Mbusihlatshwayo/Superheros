//
//  PersistenceManager.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/28/21.
//

import Foundation

enum PersistenceActionType
{
    case add, remove
}

enum PersistenceError: String, Error
{
    case couldNotFindObjectForKey = "Unable to find object for specified key. May not have been set yet"
    case decodingError = "JSON Decoding Error"
    case encodingError = "JSON Encoding Error"
    case alreadySavedCharacter = "This character has already been persisted"
}

class PersitenceManager
{
    private let defaults = UserDefaults.standard
    static let shared = PersitenceManager()

    func updateWith(character: Character, actionType: PersistenceActionType, completed: @escaping (PersistenceError?) -> Void) {
        
        retrieveCharacters { [weak self] result in
            switch result
            {
            case .success(let characters):
                var retrievedCharacters = characters
                switch actionType
                {
                case .add:
                    guard retrievedCharacters.contains(character) == false else {
                        completed(.alreadySavedCharacter)
                        return
                    }
                    
                    retrievedCharacters.append(character)
                case .remove:
                    retrievedCharacters.removeAll()
                }
                
                completed(self?.save(characters: retrievedCharacters))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    func retrieveCharacters(completed: @escaping (Result<[Character], PersistenceError>) -> Void)
    {
        guard let charactersData = defaults.object(forKey: Constants.kCharactersUserDefaults) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let characters = try decoder.decode([Character].self, from: charactersData)
            completed(.success(characters))
        } catch {
            completed(.failure(.decodingError))
        }
    }
    
    
    func save(characters: [Character]) -> PersistenceError? {
        do {
            let encoder = JSONEncoder()
            let encodedCharacters = try encoder.encode(characters)
            defaults.set(encodedCharacters, forKey: Constants.kCharactersUserDefaults)
            return nil
        } catch {
            return .encodingError
        }
    }
}
