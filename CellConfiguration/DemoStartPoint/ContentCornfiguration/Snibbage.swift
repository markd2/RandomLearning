/*
 
 TABLEVIEW CELL CORNFIGURATION
 
 var config = cell.defaultContentConfiguration()
 config.text = "celconf \(indexPath)"
 config.image = UIImage(systemName: "tortoise")
 cell.contentConfiguration = config
 
 */


/*

 struct SnorgleContentConfiguration: UIContentConfiguration {
     var text: String
     var flag: Bool

     func makeContentView() -> UIView & UIContentView {
         return SnorgleView(self)
     }
     
     func updated(for state: UIConfigurationState) -> SnorgleContentConfiguration {
         return self
     }
 }


 class SnorgleView: UIView, UIContentView {
     let label: UILabel

     var configuration: UIContentConfiguration {
         didSet {
             configure(configuration: configuration)
         }
     }
     
     func configure(configuration: UIContentConfiguration) {
         guard let configuration = configuration as? SnorgleContentConfiguration else { return }
         label.text = configuration.text
         if configuration.flag {
             label.text = "ON " + configuration.text
         }
     }

     init(_ configuration: UIContentConfiguration) {
         self.configuration = configuration
         label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         super.init(frame: .zero)

         // add subviews
         addSubview(label)

         let constraints = [
           leftAnchor.constraint(equalTo: label.leftAnchor),
           topAnchor.constraint(equalTo: label.topAnchor),
           bottomAnchor.constraint(equalTo: label.bottomAnchor),
           rightAnchor.constraint(equalTo: label.rightAnchor)
         ]
         NSLayoutConstraint.activate(constraints)

         configure(configuration: configuration)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) get bent")
     }
 }

 
 
 case 2:
     var config = SnorgleContentConfiguration(text: "hello \(indexPath)",
                                              flag: flags[indexPath.row])
     config.toggled = { [weak self] onOff in
         guard let self = self else { return }
         self.flags[indexPath.row] = onOff
         config.flag = onOff
         cell.contentConfiguration = config
     }

     cell.contentConfiguration = config

 
   "This is huge"
 
 */


/*
 
 let config = SnorgleContentConfiguration(text: "hello \(indexPath)", flag: false)
 cell.contentConfiguration = config
 
 */


/*
 
class CustomContainerView: UIView {
     var innerView: (UIView & UIContentView)?

     var contentConfiguration: UIContentConfiguration? {
         didSet {
             innerView?.removeFromSuperview()
 
             guard let contentConfiguration = contentConfiguration else { return }
             let view = contentConfiguration.makeContentView()
 
             view.translatesAutoresizingMaskIntoConstraints = false
             addSubview(view)

             let constraints = [
               leftAnchor.constraint(equalTo: view.leftAnchor),
               topAnchor.constraint(equalTo: view.topAnchor),
               bottomAnchor.constraint(equalTo: view.bottomAnchor),
               rightAnchor.constraint(equalTo: view.rightAnchor)
             ]
             NSLayoutConstraint.activate(constraints)
             innerView = view
         }
     }
 }

 
 (and set type and connection in storyboard)
 
 (after collection view register)
 
 var config = SnorgleContentConfiguration(text: "hello greeeble", flag: false)
 containerView.contentConfiguration = config

 
 
 */
