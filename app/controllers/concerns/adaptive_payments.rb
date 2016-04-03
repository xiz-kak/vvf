module AdaptivePayments
  def adaptive_payments_api
    @api ||= PayPal::SDK::AdaptivePayments::API.new
  end

  def payment_error_log(response)
    errorInfo = response.error.map { |item|
      { errorId: item.errorId,
        message: item.message,
      }
    }.first.merge({ correlationId: response.responseEnvelope.correlationId })

    logger.error "Failed correlationId: #{errorInfo[:correlationId]}" \
       "  errorId: #{errorInfo[:errorId]} with errorMessage: #{errorInfo[:message]}"
  end

  private

  def preapproval_options(opts = {})
    { :currencyCode => 'USD',
      :maxTotalAmountOfAllPayments => opts[:maxTotalAmountOfAllPayments],
      :displayMaxTotalAmount => TRUE,
      :startingDate => Time.now,
      :endingDate => opts[:endingDate],
      :maxNumberOfPayments => 1,
      :maxNumberOfPaymentsPerPeriod => 1,
      :pinType => 'NOT_REQUIRED',
      :feesPayer => 'SENDER',
      :senderEmail => opts[:email],
      :requestEnvelope => {
      :errorLanguage => 'en_US' },
      :cancelUrl => application_url(cancel_pledges_path),
      :returnUrl => application_url(complete_pledge_path(opts[:pledge_id])) }
  end

  def preapproval_url(key)
    "#{AdaptivePayments.api_base_url}/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=#{key}"
  end

  def application_url(path)
    if params[:locale].nil?
      "#{root_url.chop}#{path}"
    else
      root_url[-1, 1] == '/' ? "#{root_url}#{params[:locale]}#{path}" : "#{root_url.gsub(root_path, '')}#{path}"
    end
  end

  def self.api_base_url
    if Rails.env.production?
      'https://www.paypal.com'
    else
      'https://www.sandbox.paypal.com'
    end
  end
end
