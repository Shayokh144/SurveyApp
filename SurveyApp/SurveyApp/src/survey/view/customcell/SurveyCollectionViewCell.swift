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
    
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    static let cellIdentifier: String = "surveyCollectionViewCellId"
    
    var surveyCellData : SurveyDataEntity = SurveyDataEntity(){
        didSet{
            self.showButton()
            self.setTitle(with: surveyCellData.title)
            self.setDescription(with: surveyCellData.description)
            self.showImage(image: surveyCellData.bgImageData)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButton()
        configureTextLabel()
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
    
    private func configureTextLabel(){
        self.titleLabel.accessibilityIdentifier = UIConstants.surveyCellTitleAccesibilityIdentifier
        self.titleLabel.skeletonPaddingInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 56.0)
        self.titleLabel.lastLineFillPercent = 40
        self.descriptionLabel.skeletonPaddingInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 24.0)
        self.titleLabel.skeletonLineSpacing = 5.0
        self.titleLabel.linesCornerRadius = UIConstants.skeletonCornerRadius
        self.descriptionLabel.skeletonLineSpacing = 5.0
        self.descriptionLabel.linesCornerRadius = UIConstants.skeletonCornerRadius

    }
    
    private func showImage(image : Data){
        DispatchQueue.main.async {
            self.cellBackgroundImage.image = UIImage(data: image)
        }
    }
    
    private func showButton(){
        DispatchQueue.main.async {
            self.arrowButton.isHidden = false
        }
    }

    private func configureButton(){
        arrowButton.isHidden = true
        arrowButton.accessibilityIdentifier = UIConstants.surveyCellButtonAccesibilityIdentifier
        arrowButton.clipsToBounds = true
        arrowButton.layer.cornerRadius = 0.5 * min(arrowButton.frame.size.width , arrowButton.frame.size.width)
        arrowButton.setTitle("", for: .normal)
        arrowButton.setImage(UIImage(named: UIConstants.arrowButtonImageName), for: .normal)
    }

}
