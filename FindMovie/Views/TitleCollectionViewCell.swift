import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImage.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImage.sd_setImage(with: url, completed: nil)
        /*
         1. Принимает входной параметр `model`.
         2. Формирует URL-адрес из строки, добавляя значение параметра `model` в конец адреса.
         3. Проверяет, что URL-адрес был успешно создан с помощью опционального связывания (optional binding) и присваивает его константе `url`.
         4. Если URL-адрес не был создан (если значение `model` недопустимо или URL-адрес недействителен), код выходит из функции с помощью оператора `return`.
         5. Если URL-адрес был успешно создан, используется библиотека SDWebImage для загрузки изображения по данному URL-адресу и установки его в `posterImage`. В данном коде не указано, что именно происходит после загрузки изображения, так как в параметре `completed` передано значение `nil`, что означает отсутствие обработчика завершения загрузки изображения.
        */
    }
    // m
}
