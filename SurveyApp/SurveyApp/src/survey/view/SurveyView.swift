//
//  SurveyView.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import UIKit
import SkeletonView

class SurveyView: UIViewController {
    
    //@IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skeletonViewForPageController: UIView!
    
    @IBOutlet weak var pageControlLeading: NSLayoutConstraint!
    //@IBOutlet weak var collectionViewHeight: NSLayoutConstraint!//214
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!//8
    @IBOutlet weak var collectionViewTrailing: NSLayoutConstraint!//8
    //@IBOutlet weak var collectionVIewTop: NSLayoutConstraint!//8
    @IBOutlet weak var collectionViewLeading: NSLayoutConstraint!//8
    
    var presenter: SurveyViewToPresenterProtocol?
    var cellDataList : [SurveyDataEntity] = []
    var backgroundChangeAlreadySet = false
    var prevviousIndexPathRow = 0
    var dataLoafinInProgress = false
    var isAlreadyShowingAlert = false
    let gradient = SkeletonGradient(baseColor: UIConstants.skeletonBaseGradiantColor, secondaryColor:  UIConstants.skeletonSecondaryGradiantColor)
    let animation = GradientDirection.leftRight.slidingAnimation()
    var spinnerView : SpinnerViewController!
    var scrollViewPosition : CGFloat = 0.0
    var alertController : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        dataLoafinInProgress = false
        isAlreadyShowingAlert = false
        setInitialPageControl()
        backgroundChangeAlreadySet = false
        presenter?.onViewDidLoadCalled()
        configureCollectionView()
        configureLoadingSpinnerOverlay()
    }
    
    private func setInitialPageControl(){
        self.pageControl.addTarget(self, action: #selector(pageControltapped(_:)), for: .touchUpInside)
        self.pageControl.isHidden = true
        self.skeletonViewForPageController.isHidden = false
        self.skeletonViewForPageController.skeletonCornerRadius = Float(self.pageControl.frame.size.height * 0.5)
        self.skeletonViewForPageController.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
        self.pageControl.skeletonCornerRadius = Float(self.pageControl.frame.size.height * 0.5)
        self.pageControl.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: UIConstants.surveyCellNibName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SurveyCollectionViewCell.cellIdentifier)
    }
    
    private func showAlertMessage(title : String, message : String, errorType : DataFetchingError){
        if(isAlreadyShowingAlert == false){
            DispatchQueue.main.async {
                self.alertController = nil
                self.alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                self.alertController?.dismiss(animated: true, completion: nil)
                self.alertController?.title = title
                self.alertController?.message = message
                self.alertController?.addAction(UIAlertAction(title: TextConstants.okText, style: UIAlertAction.Style.default, handler: { _ in
                    self.isAlreadyShowingAlert = false
                    self.presenter?.didTapOkButtonOnError(errorType: errorType)
                }))
                self.present(self.alertController ?? UIAlertController(), animated: true, completion: {
                    self.isAlreadyShowingAlert = true
                })
            }
        }
    }
    
    private func configureLoadingSpinnerOverlay(){
        spinnerView = SpinnerViewController()
    }
    
    private func showLoadingSpinnerOverlay(){
        DispatchQueue.main.async {
            self.addChild(self.spinnerView)
            self.spinnerView.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.spinnerView.view)
            self.spinnerView.didMove(toParent: self)
        }
    }
    
    private func hideLoadingSpinnerOverlay(){
        DispatchQueue.main.async {
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
        }
    }
    
    @IBAction func pageControltapped(_ sender: Any) {
        guard let pageControlC = sender as? UIPageControl else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
            let page  = pageControlC.currentPage
            //print("current page : \(page ?? -10)")
            let newIndexPath = IndexPath(row: page, section: 0)
            self.collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
        })
        
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
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.x + self.collectionView.frame.size.width
        scrollViewPosition = max(position, scrollViewPosition)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("position = \(scrollViewPosition)")
        //print("width = \(self.collectionView.contentSize.width)")
        if(scrollViewPosition > self.collectionView.contentSize.width + 80){
            print("load more data")
            if(self.dataLoafinInProgress == false){
                print("load more dataLoafinInProgress")

                self.dataLoafinInProgress = true
                self.presenter?.didScrollForNewData()

            }
        }
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        self.pageControl.currentPage = indexPath.row
        prevviousIndexPathRow = indexPath.row
        self.scrollViewPosition = 0
    }
}
extension SurveyView : SurveyPresenterToViewProtocol{
    func hideLoadingSpinner() {
        DispatchQueue.main.async {
            self.hideLoadingSpinnerOverlay()
        }
    }
    
    func showLoadingSpinner() {
        self.showLoadingSpinnerOverlay()
    }
    
    func updateViewWithNewData(dataList: [SurveyDataEntity]) {
        DispatchQueue.main.async {
            let newIndexPathRow = self.cellDataList.count
            self.cellDataList.append(contentsOf: dataList)
            self.pageControl.numberOfPages = self.cellDataList.count
            self.pageControl.currentPage = newIndexPathRow
            self.collectionView.reloadData()
            if(newIndexPathRow < self.cellDataList.count){
                self.collectionView.scrollToItem(at: IndexPath(row: newIndexPathRow, section: 0), at: .left, animated: true)
            }
            self.hideLoadingSpinnerOverlay()
            self.dataLoafinInProgress = false
        }
    }
    
    func showErrorAlert(title: String, message: String, errorType: DataFetchingError) {
        self.showAlertMessage(title: title, message: message, errorType: errorType)
        self.dataLoafinInProgress = false
    }
    
    func populateSurveyData(with dataList: [SurveyDataEntity]) {
        DispatchQueue.main.async {
            self.cellDataList = dataList
        }
    }
    
    func showSkeletonView() {
        DispatchQueue.main.async {
            self.pageControl.isHidden = true
            self.pageControlLeading.constant = UIConstants.pageControlSkeletonLeading
            UIConstants.multiplyWithScreenRatio(constraint: self.pageControlLeading)
            self.collectionView.isSkeletonable = true
            self.collectionView.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
            self.skeletonViewForPageController.showAnimatedGradientSkeleton(usingGradient: self.gradient, animation: self.animation)
            
        }
    }
    
    func hideSkeletonView() {
        DispatchQueue.main.async {
            self.pageControl.isHidden = false
            self.skeletonViewForPageController.isHidden = true
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
