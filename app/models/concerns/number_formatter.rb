module NumberFormatter
  extend ActiveSupport::Concern

  # Add zeros at the tail
  def to_currency_z(val, currency=:usd)
    if currency == :usd
      ApplicationController.helpers.number_with_precision(val,
                                                        precision: 2, separator: '.')
    else
      val
    end
  end

  # Format to show
  def to_currency_f(val, currency=:usd)
    if currency == :usd
      ApplicationController.helpers.number_with_delimiter(to_currency_z(val, currency),
                                                        delimiter: ',', separator: '.')
    else
      val
    end
  end
end
