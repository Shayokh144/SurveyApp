//
//  SurveyView.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import UIKit
import SkeletonView

class SurveyView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: UIConstants.surveyCellNibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SurveyCollectionViewCell.cellIdentifier)
    }
    
    private func setBackgroundImage(imageName : String){
        guard let image = UIImage(named: imageName) else{ return }
        let resizedImage = image.resizeImageTo(size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.contentMode = .scaleAspectFill
        self.view.backgroundColor = UIColor(patternImage: resizedImage!)
    }
}
extension SurveyView : UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SurveyCollectionViewCell.cellIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//cellDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyCollectionViewCell.cellIdentifier, for: indexPath) as! SurveyCollectionViewCell

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        //self.setBackgroundImage(imageName: cellDataList[indexPath.row].imageUrl)
        
    }
}
