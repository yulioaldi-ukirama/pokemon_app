module PokemonsHelper
  def stars_counter(power)
    if power > 0 && power <= 4
      stars = 3
    elsif power >= 5 && power <= 9
      stars = 4
    elsif power >= 10 && power <= 13
      stars = 5
    elsif power >= 14 && power <= 17
      stars = 6
    elsif power >= 18 && power <= 22
      stars = 7
    elsif power >= 23
      stars = 8
    end

    return stars
  end
end
