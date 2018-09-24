//
//  TransactionsListItemCell.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 22/9/18.
//

import Foundation
import UIKit

class TransactionsListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: TransactionsListItemCell.self)
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var imageLoadTask: CancelableTask? { willSet { imageLoadTask?.cancel() } }
    private var imageDataSource: ImageDataSourceInterface!
    private var imageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
    }
    
    func fill(with item: TransactionsListViewModel.Item, imageDataSource: ImageDataSourceInterface, selectionColor: UIColor) {
        self.imageDataSource = imageDataSource
        descriptionLabel.text = item.description
        valueLabel.text = item.value
        categoryLabel.text = item.categoryName
        setIcon(with: item.iconUrl)
        setSelectionColor(selectionColor)
    }
    
    private func setIcon(with url: URL?) {
        guard imageURL != url else { return }
        imageURL = url
        iconImageView.image = nil
        
        guard let url = imageURL else { return }
        imageLoadTask = imageDataSource.image(withUrl: url) { [weak self] result in
            DispatchQueue.main.async {
                guard self?.imageURL == url else { return }
                switch result {
                case .success(let image):
                    self?.iconImageView.image = image.replaceWhiteBackgroundWithTransparent()
                case .failure(let error):
                    if let networkError = error as? NetworkError, networkError.isNotFoundError {
                        self?.iconImageView.image = UIImage.init(named: "image_not_found")
                    }
                }
            }
        }
    }
    
    private func setSelectionColor(_ selectionColor: UIColor) {
        let colorView = UIView()
        colorView.backgroundColor = selectionColor
        selectedBackgroundView = colorView
    }
    
    private func setupAppearance() {
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = AppColors.lightGray.cgColor
        iconImageView.layer.masksToBounds = true
    }
}
