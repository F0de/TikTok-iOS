//
//  SwitchTableViewCell.swift
//  TikTok
//
//  Created by Влад Тимчук on 09.08.2024.
//

import UIKit
import SnapKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "SwitchTableViewCell"
    weak var delegate: SwitchTableViewCellDelegate?
    
    private lazy var label = UILabel()
    private lazy var switcher = UISwitch()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    //MARK: - Setup Methods
    func configure(with viewModel: SwitchCellViewModel) {
        label.text = viewModel.title
        switcher.isOn = viewModel.isOn
    }
    
    private func setupLabel() {
        label.numberOfLines = 1
    }
    
    private func setupSwitcher() {
        switcher.onTintColor = .systemBlue
        switcher.isOn = UserDefaults.standard.bool(forKey: "save_video")
        switcher.addTarget(self, action: #selector(didChangeSwitchValue), for: .valueChanged)
    }
    
    //MARK: - Setting Views
    private func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
        selectionStyle = .none
        
        setupLabel()
        setupSwitcher()
        
        addSubViews()
    }
    
    //MARK: - Setting
    private func addSubViews() {
        contentView.addSubview(label)
        contentView.addSubview(switcher)
    }
    
    //MARK: - Layout
    private func setUpLayout() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        switcher.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc private func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.switchTableViewCell(self, didUpdateSwitchTo: sender.isOn)
    }
}
