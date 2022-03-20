//
//  SurveyCollectionViewCell.swift
//  Oauth2Project
//
//  Created by Asif on 15/3/22.
//

import UIKit

class SurveyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    
    static let cellIdentifier: String = "surveyCollectionViewCellId"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButton()
    }
    
    private func configureButton(){
        arrowButton.clipsToBounds = true
        arrowButton.layer.cornerRadius = 0.5 * arrowButton.bounds.size.width
        arrowButton.setTitle("", for: .normal)
        arrowButton.setImage(UIImage(named: "Arrow"), for: .normal)
        //arrowButton.setBackgroundImage(UIImage(named: "Arrow"), for: .normal)
    }

}
