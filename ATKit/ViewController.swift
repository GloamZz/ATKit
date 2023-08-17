//
//  ViewController.swift
//  CGAffineTransform
//
//  Created by Sylvan on 2023/8/18.
//

import UIKit
import SnapKit

class ViewController: UIViewController, ATSliderDelegate {
    
    @IBOutlet weak var canvas: Canvas!
    
    @IBOutlet weak var order: UISegmentedControl!
    
    @IBOutlet weak var orderDescription: UILabel!
    
    let factory = ATFactory()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        order.addTarget(self, action: #selector(clickOnOrderSegmentItem(_:)), for: .touchUpInside)
        for (index, each) in ATApplyOrder.allCases.enumerated() {
            let action = UIAction.init(title: each.rawValue, identifier: .init(each.rawValue), handler: clickOnOrderSegmentItem)

            if order.numberOfSegments > index {
                order.setAction(action, forSegmentAt: index)
            } else {
                order.insertSegment(action: action, at: index, animated: false)
            }
        }
        
        var sliders: [ATSlider] = []
        for property in ATComponent.allCases.reversed(){
            let slider = ATSlider.init(identifier: property.rawValue)
            slider.delegate = self
            slider.name = property.name
            slider.currentValue = property.defaultValue
            slider.defaultValue = property.defaultValue
            slider.minimumValue = property.minimumValue
            slider.maximumValue = property.maximumValue
            view.addSubview(slider)
            
            slider.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(30)
                if let last = sliders.last {
                    make.bottom.equalTo(last.snp.top).offset(-8)
                } else {
                    make.bottom.equalToSuperview().offset(-40)
                }
            }
            
            sliders.append(slider)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadUI()
    }
    
    func reloadUI() {
        self.orderDescription.text =  ATApplyOrder.allCases[order.selectedSegmentIndex].title
    }

    @objc func clickOnOrderSegmentItem(_ action: UIAction) {
        guard let order = ATApplyOrder.init(rawValue: action.identifier.rawValue) else {
            return
        }
        let transform = factory.makeAffineTransform(for: order)
        
        canvas.drawingTransform = transform
        self.reloadUI()
    }
    
    @IBAction func clickOnAddButton(_ sender: Any) {
        factory.add()
    }

    @IBAction func clickOnResetButton(_ sender: Any) {
        factory.reset()
        
        canvas.drawingTransform = .identity
    }

    func slider(_ slider: ATSlider, didValueChanged value: CGFloat) {
        guard let property = ATComponent.init(rawValue: slider.identifier) else {
            return
        }
        factory.modify(at: 0, for: property, value: value)
        let order = ATApplyOrder.allCases[order.selectedSegmentIndex]
        let transform = factory.makeAffineTransform(for: order)
        canvas.drawingTransform = transform
    }
    
}

protocol ATSliderDelegate: AnyObject {
    func slider(_ slider: ATSlider, didValueChanged value: CGFloat)
}

class ATSlider: UIView {
    
    let identifier: String
    
    weak var delegate: ATSliderDelegate? = nil
    
    var name: String?  {
        get { return nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    var currentValue: CGFloat = 0.0
    
    var defaultValue: CGFloat = 0.0

    var maximumValue: CGFloat {
        get { return CGFloat(slider.maximumValue) }
        set { slider.maximumValue = Float(newValue) }
    }
    
    var minimumValue: CGFloat {
        get { return CGFloat(slider.minimumValue) }
        set { slider.minimumValue = Float(newValue) }
    }
        
    var valueTextField: UITextField!
    
    var nameLabel: UILabel!
        
    var slider: UISlider!
    
    init(identifier: String) {
        self.identifier = identifier
        super.init(frame: .zero)
        initUIComponents()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func initUIComponents() {
        valueTextField = UITextField()
        valueTextField.borderStyle = .line
        valueTextField.keyboardType = .numberPad
        valueTextField.textAlignment = .center
        addSubview(valueTextField)
        
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        
        slider = UISlider()
        slider.addTarget(self, action: #selector(didSliderValueChanged(_:)), for: .valueChanged)
        addSubview(slider)
        
        valueTextField.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(100)
        }

        slider.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(valueTextField.snp.leading).offset(-8)
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
    }
    
    @objc func didSliderValueChanged(_ sender: UISlider) {
        currentValue = CGFloat(sender.value)
        valueTextField.text = String.init(format: "%02f", sender.value)
        delegate?.slider(self, didValueChanged: currentValue)
    }
}
