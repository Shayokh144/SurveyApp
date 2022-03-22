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
    
    @IBOutlet weak var pageControlLeading: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!//214
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!//8
    @IBOutlet weak var collectionViewTrailing: NSLayoutConstraint!//8
    @IBOutlet weak var collectionVIewTop: NSLayoutConstraint!//8
    @IBOutlet weak var collectionViewLeading: NSLayoutConstraint!//8
    
    var presenter: SurveyViewToPresenterProtocol?
    var cellDataList : [SurveyDataEntity] = []
    var backgroundChangeAlreadySet = false
    let gradient = SkeletonGradient(baseColor: UIColor.asbestos)
    let animation = GradientDirection.leftRight.slidingAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.isHidden = true
        self.pageControl.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
        backgroundChangeAlreadySet = false
        presenter?.onViewDidLoadCalled()
        configureCollectionView()
        configureCollectionViewConstraints()
    }
    
    private func configureCollectionViewConstraints(){
        collectionViewHeight.constant = UIConstants.collectionViewHeight
        UIConstants.multiplyWithScreenRatio(constraint: collectionViewHeight)
        collectionViewBottom.constant = UIConstants.collectionViewMargin
        UIConstants.multiplyWithScreenRatio(constraint: collectionViewBottom)
        collectionViewTrailing.constant = UIConstants.collectionViewMargin
        UIConstants.multiplyWithScreenRatio(constraint: collectionViewTrailing)
        collectionVIewTop.constant = UIConstants.collectionViewMargin
        UIConstants.multiplyWithScreenRatio(constraint: collectionVIewTop)
        collectionViewLeading.constant = UIConstants.collectionViewMargin
        UIConstants.multiplyWithScreenRatio(constraint: collectionViewLeading)
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: UIConstants.surveyCellNibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SurveyCollectionViewCell.cellIdentifier)
    }
    
    private func setBackgroundImage(imageData : Data){
        guard let image = UIImage(data: imageData) else{ return }
        //let blurImage = blurImage(image: image)
        let resizedImage = image.resizeImageTo(size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.contentMode = .scaleAspectFill
        self.view.backgroundColor = UIColor(patternImage: resizedImage ?? UIImage())
    }
    
    private func showAlertMessage(title : String, message : String, errorType : DataFetchingError){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: TextConstants.okText, style: UIAlertAction.Style.default, handler: { _ in
                self.presenter?.didTapOkButtonOnError(errorType: errorType)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func blurImage(image:UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(2.0, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        var cgImage:CGImage?
        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }
        
        if let cgImageA = cgImage
        {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }
        
        return nil
    }
}

extension SurveyView : UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SurveyCollectionViewCell.cellIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyCollectionViewCell.cellIdentifier, for: indexPath) as! SurveyCollectionViewCell
        if(cellDataList.count > 0){
            cell.surveyCellData = cellDataList[indexPath.row]
            if(backgroundChangeAlreadySet == false){
                self.setBackgroundImage(imageData : cellDataList[indexPath.row].bgImageData)
                backgroundChangeAlreadySet = true
            }
        }
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
        //print(indexPath)
        self.setBackgroundImage(imageData : cellDataList[indexPath.row].bgImageData)
        self.pageControl.currentPage = indexPath.row
        
    }
}
extension SurveyView : SurveyPresenterToViewProtocol{
    func showErrorAlert(title: String, message: String, errorType: DataFetchingError) {
        self.showAlertMessage(title: title, message: message, errorType: errorType)
    }
    
    func populateSurveyData(with dataList: [SurveyDataEntity]) {
        DispatchQueue.main.async {
            self.cellDataList = dataList
        }
    }
    
    func showSkeletonView() {
        DispatchQueue.main.async {
            self.pageControl.isHidden = false
            self.pageControlLeading.constant = UIConstants.pageControlSkeletonLeading
            UIConstants.multiplyWithScreenRatio(constraint: self.pageControlLeading)
            self.collectionView.isSkeletonable = true
            self.collectionView.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
            self.pageControl.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
        }
    }
    
    func hideSkeletonView() {
        DispatchQueue.main.async {
            self.pageControl.isHidden = true
            self.pageControl.stopSkeletonAnimation()
            self.collectionView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.pageControlLeading.constant = UIConstants.pageControlLeading
            self.pageControl.numberOfPages = self.cellDataList.count
            self.pageControl.currentPage = 0
            UIConstants.multiplyWithScreenRatio(constraint: self.pageControlLeading)
        }
    }
    
}
