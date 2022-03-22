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
    
    @IBOutlet weak var arrowButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var arrowButtonWidth: NSLayoutConstraint!
    
    static let cellIdentifier: String = "surveyCollectionViewCellId"
    
    var surveyCellData : SurveyDataEntity = SurveyDataEntity(){
        didSet{
            self.setTitle(with: surveyCellData.title)
            self.setDescription(with: surveyCellData.description)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButton()
        self.titleLabel.accessibilityIdentifier = "cellDataTitleAccIdentifier"
    }
    @IBAction func arrowBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: UIConstants.surveyDetailsViewStoryBoardId) as? SurveyDetailsView
        viewController?.titleText = self.surveyCellData.title
        NavigationManager.shared.loadViewController(newViewController: viewController ?? UIViewController())
    }
    
    private func setTitle(with text : String){
        let attrs = [NSAttributedString.Key.font : UIFont(name:     UIConstants.fontNeuzeitSLTHeavy, size: UIConstants.surveyTitlefontSize),
                     NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        let boldText = NSMutableAttributedString(string: text, attributes:attrs as [NSAttributedString.Key : Any])
        DispatchQueue.main.async {
            self.titleLabel.attributedText = boldText
        }
    }
    
    private func setDescription(with text : String){
        let attrs = [NSAttributedString.Key.font : UIFont(name:     UIConstants.fontNeuzeitSLTNormal, size: UIConstants.surveyDescriptionfontSize),
                     NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        let normalText = NSMutableAttributedString(string: text, attributes:attrs as [NSAttributedString.Key : Any])
        DispatchQueue.main.async {
            self.descriptionLabel.attributedText = normalText
        }
    }

    private func configureButton(){
        arrowButton.accessibilityIdentifier = "arrowBtnIdentifier"
        arrowButtonHeight.constant = UIConstants.arrowButtonHeight
        arrowButtonWidth.constant = UIConstants.arrowButtonWidth
        UIConstants.multiplyWithScreenRatio(constraint: arrowButtonHeight)
        UIConstants.multiplyWithScreenRatio(constraint: arrowButtonHeight)
        arrowButton.clipsToBounds = true
        arrowButton.layer.cornerRadius = 0.5 * arrowButton.bounds.size.width
        arrowButton.setTitle("", for: .normal)
        arrowButton.setImage(UIImage(named: UIConstants.arrowButtonImageName), for: .normal)
    }

}
