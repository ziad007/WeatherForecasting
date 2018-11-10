
import UIKit

class CustomHeaderTableViewHeaderFooterView: UITableViewHeaderFooterView {
    static let reuseIdentifer = "CustomHeaderReuseIdentifier"
    static let seperatorViewHeight: CGFloat = 0.2

    private let topSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-SemiBold", size: 15)
        label.textColor = .darkColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white

        contentView.addSubview(topSeperatorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomSeperatorView)

        layoutComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            topSeperatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topSeperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topSeperatorView.heightAnchor.constraint(equalToConstant: CustomHeaderTableViewHeaderFooterView.seperatorViewHeight),

            titleLabel.topAnchor.constraint(equalTo: topSeperatorView.bottomAnchor, constant: 5),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            bottomSeperatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            bottomSeperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomSeperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomSeperatorView.heightAnchor.constraint(equalToConstant: CustomHeaderTableViewHeaderFooterView.seperatorViewHeight),
            ])
    }
}
