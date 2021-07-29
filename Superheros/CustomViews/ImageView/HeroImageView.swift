//
//  MSHeroImageView.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import UIKit

class MSHeroImageView: UIImageView
{
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: Constants.kPlaceholderImage)!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        configure()
    }
    
    private func configure()
    {
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        image = placeholderImage
    }
    
    func downloadImage(from urlString: String)
    {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async { self.image = image }
        }

        task.resume()
    }
}
