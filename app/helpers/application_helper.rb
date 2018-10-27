module ApplicationHelper

  # Выбор цвета фона страницы пользователя
  def background_color(user)
    user.color || "#005a55"
  end

  # Выбор аватарки пользователя
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'default.jpg'
    end
  end

  # Иконки для .css стилей
  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  # Склонятор
  def sklonenie(number, vopros, voprosa, voprosov)
    if number == nil || !number.is_a?(Numeric)
      number = 0
    end

    ostatok2 = number % 100

    if ostatok2.between?(11, 14)
      return voprosov
    elsif number.between?(11, 14)
      return voprosov
    end

    ostatok = number % 10

    if ostatok == 1
      return vopros
    end

    if ostatok >= 2 && ostatok <= 4
      return voprosa
    end

    if (ostatok >= 5 && ostatok <= 9) || ostatok == 0
      return voprosov
    end
  end

end
