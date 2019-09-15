//
//  CarouselFigureView.swift

import UIKit

let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height

class CarouselFigureView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 建议使用的时候 替换成自己的page控件，原生的不好定制且点击事件点不到
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// 左边重复的次数
    private let leftRepeatNum = 10
    /// 右边重复的次数
    private let rightRepeatNum = 10
    
    /**
     * 里面存的是pageViews的下标,重复n次
     *
     * 具体内容
     * (0~pageViews.count-1) * leftRepeatNum,
     * (0~pageViews.count-1),
     * (0~pageViews.count-1) * rightRepeatNum
     */
    private var data = [Int]()
    
    private var _pageViews:Array<UIView>?
    
    var pageViews:Array<UIView> {
        get {
            assert(_pageViews != nil && _pageViews!.count > 0)
            return _pageViews!
        }
        set {
            assert(newValue.count > 0)
            _pageViews = newValue
            self.pageControl.numberOfPages = _pageViews!.count
            for _ in 0..<(self.leftRepeatNum+1+self.rightRepeatNum) {
                for j in 0..<_pageViews!.count {
                    self.data.append(j)
                }
            }
            self.collectionView.reloadData()
            
            let start = self.startPageIdx()
            self.currentPage = start
            self.collectionView.scrollToItem(at: IndexPath(row: start, section: 0), at: .centeredHorizontally, animated: false)
        }
    }

    /// 位于data的下标 0 ~ (left+1+right)*pageViews.count - 1
    private var currentPage:Int = 0
    
    /// 位于点的下标，0 ~ pageViews.count-1
    var pageIdx:Int {
        get {
            return self.currentPage % self.pageViews.count
        }
    }
    
    // MARK: Init
    static func initFromNib() -> CarouselFigureView {
        let obj = Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! CarouselFigureView
        obj.commonInit()
        return obj
    }
    
    private func commonInit() -> Void {
        self.collectionView.register(UINib.init(nibName: "\(CarouselFigureCell.self)", bundle: Bundle.main), forCellWithReuseIdentifier: CarouselFigureCell.cellID())
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        /// 这句话要加上，不然cell会因为collectionView的优化，导致黑掉
        self.collectionView.isPrefetchingEnabled = false
        
        // TODO: cellSize 自己根据样式需求修改
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 375, height: 200)
    }

    
    // MARK: 操作
    func scrollToNextPage() -> Void {
        self.scrollToPage(self.currentPage + 1)
    }
    
    func scrollToLastPage() -> Void {
        self.scrollToPage(self.currentPage - 1)
    }
    
    func scrollToPage(_ page:Int) -> Void {
        if self.collectionView.isDragging || self.collectionView.isTracking {
            return
        }
        let rest = page % self.pageViews.count
        self.correctPage(page: self.currentPage)
        
        self.currentPage = self.startPageIdx() + rest
        self.collectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        self.updatePageControl(page: self.currentPage)
    }
    
    // MARK: PageControl
    /// pageControl不便于点击，可以自己实现控件，其点击事件里面scrollToPage
    @IBAction func onPageControlValueChanged(_ sender: Any) {
        self.scrollToPage(self.pageControl.currentPage)
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: CarouselFigureCell.cellID(), for: indexPath) as! CarouselFigureCell
        let idx = self.data[indexPath.row]
        let view = self.pageViews[idx]
        cell.setup(view: view)
        return cell
    }
    
    // MARK: ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 手动滑动的时候，纠正底部pageControl的page
        let page = lroundf(Float(scrollView.contentOffset.x / SCREEN_WIDTH))
        if scrollView.isDragging || scrollView.isTracking {
            if page == self.currentPage {
                return
            } else {
                self.updatePageControl(page: page)
            }
        }
        self.currentPage = page
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /// 超出startPageIdx~endPageIdx的 纠正回区间内对应的item
        let page = lroundf(Float(scrollView.contentOffset.x / SCREEN_WIDTH))
        if page < self.startPageIdx() || page > self.endPageIdx() {
            self.correctPage(page: page)
        }
    }
    
    // MARK:私有
    private func correctPage(page:Int) -> Void {
        let rest = page % self.pageViews.count
        let idx = self.startPageIdx() + rest
        let indexPath = IndexPath(row: idx, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        self.currentPage = idx
    }
    
    private func updatePageControl(page:Int) -> Void {
        let rest = page % self.pageViews.count
        self.pageControl.currentPage = rest
    }
    
    private func startPageIdx() -> Int {
        return self.leftRepeatNum * self.pageViews.count
    }
    
    private func endPageIdx() -> Int {
        return (self.leftRepeatNum + 1) * self.pageViews.count - 1
    }
}
