//
//  File.swift
//  CodeChallenge
//
//  Created by Oleh on 23.09.18.
//

import Foundation
import UIKit

class TransactionsListEmptyDataCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: TransactionsListEmptyDataCell.self)
    
    @IBOutlet weak var descriptionLabel: UILabel!
}

