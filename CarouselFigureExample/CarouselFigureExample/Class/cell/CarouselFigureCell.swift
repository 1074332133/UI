//
//  CarouselFigureCell.swift


import UIKit

class CarouselFigureCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup(view:UIView) -> Void {
        view.removeFromSuperview()
        self.addSubview(view)
    }
    
    static func cellID() -> String {
        return "CarouselFigureCellID"
    }
}
