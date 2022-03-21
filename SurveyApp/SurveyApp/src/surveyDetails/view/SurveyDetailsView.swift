//
//  SurveyDetailsView.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import UIKit

class SurveyDetailsView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
    }

}
