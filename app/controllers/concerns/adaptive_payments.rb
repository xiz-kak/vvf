module AdaptivePayments

  # PayPal ExecStatus
  EXEC_STATUS_COMPLETED = 'COMPLETED'

  def adaptive_payments_api
    @api ||= PayPal::SDK::AdaptivePayments::API.new
  end

  def approve_log(pay_response, opts)
    each_amount = "paid"
    opts[:receiverList][:receiver].map do |receiver|
      if receiver[:email] == AdaptivePayments.admin_email
        each_amount << " admin amount #{receiver[:amount]}"
      else
        each_amount << " another amount #{receiver[:amount]}"
      end
    end

    logger.info("payKey: #{pay_response.payKey} correlationId: #{pay_response.responseEnvelope.correlationId}" \
                " Successfully #{each_amount}")
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
      # :feesPayer => 'EACHRECEIVER',
      # :senderEmail => opts[:email], 指定したemailのみしかpaypalにログインできない
      :requestEnvelope => {
        :errorLanguage => 'en_US' },
      :cancelUrl => application_url(cancel_pledge_path(opts[:pledge_id])),
      :returnUrl => application_url(complete_pledge_path(opts[:pledge_id])) }
  end

  def approval_options(opts = {})
    { :actionType => 'PAY',
      :currencyCode => 'USD',
      :requestEnvelope => {
        :errorLanguage => 'en_US' },
      :reverseAllParallelPaymentsOnError => true,
      :preapprovalKey => opts[:preapprovalKey],
      :cancelUrl => application_url(cancel_project_path),
      :returnUrl => application_url(complete_project_path),
      :feesPayer => 'PRIMARYRECEIVER',
    }.merge(approval_receiver_list(opts[:amount], opts[:email], opts[:commissionRate]))
  end

  def cancel_preapproval_options(key)
    { :preapprovalKey => key }
  end

  def approval_receiver_list(amount, email, commission_rate)
    commission = amount * commission_rate / 100.to_f

    { :receiverList => {
        :receiver => [
          {
            :email => AdaptivePayments.admin_email,
            :amount => amount,
            :primary => true
          },
          {
            :email => email,
            :amount => amount - commission,
            :primary => false
          }
        ]
      }
    }
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

  def self.admin_email
    ENV['PAYPAL_EMAIL']
  end
end
