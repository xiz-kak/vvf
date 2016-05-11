module AdaptivePayments

  # PayPal ExecStatus
  EXEC_STATUS_COMPLETED = 'COMPLETED'

  def adaptive_payments_api
    @api ||= PayPal::SDK::AdaptivePayments::API.new
  end

  def preapprove(pledge)
    opts = { :maxTotalAmountOfAllPayments => pledge.pledge_payment.total_amount,
             :endingDate => pledge.reward.project.end_at.months_since(1),
             :pledge_id => pledge.id }

    preapproval = adaptive_payments_api.build_preapproval(preapproval_options(opts))
    preapproval_response = adaptive_payments_api.preapproval(preapproval)

    if preapproval_response.success?
      pledge.preapproval_key(preapproval_response.preapprovalKey)
      preapprove_log(preapproval_response)
      redirect_to preapproval_url(preapproval_response.preapprovalKey)
      return true
    else
      pledge.preapprove_error!
      payment_error_log(preapproval_response, 'PREAPPROVE')
      return false
    end
  end

  def pay_to_creator(pledge)
    opts = { :email => pledge.reward.project.paypal_account,
             :preapprovalKey => pledge.pledge_payment.preapproval_key,
             :amount => pledge.pledge_payment.total_amount,
             :commissionRate => pledge.reward.project.commission_rate
    }

    pay = adaptive_payments_api.build_pay(approval_options(opts))
    pay_response = adaptive_payments_api.pay(pay)

    if pay_response.success? && pay_response.paymentExecStatus == EXEC_STATUS_COMPLETED
      pledge.pay!
      pay_log(pay_response, approval_options(opts))
      return true
    else
      pledge.pay_error!
      payment_error_log(pay_response, 'PAY')
      return false
    end
  end

  def pay_back_to_backer(pledge)
    cancel_preapproval = adaptive_payments_api.
                           build_cancel_preapproval(cancel_preapproval_options(pledge.pledge_payment.preapproval_key))
    cancel_preapproval_response = adaptive_payments_api.cancel_preapproval(cancel_preapproval)

    if cancel_preapproval_response.success?
      pledge.pay_back!
      pay_back_log(cancel_preapproval_response)
      return true
    else
      pledge.pay_back_error!
      payment_error_log(cancel_preapproval_response, 'PAYBACK')
      return false
    end
  end

  private

  def preapprove_log(response)
    logger.info("[PAYPAL][PREAPPROVE][SUCCESS] preapprovalKey: #{response.preapprovalKey} correlationId: #{response.responseEnvelope.correlationId}")
  end

  def pay_log(pay_response, opts)
    each_amount = "paid"
    opts[:receiverList][:receiver].map do |receiver|
      if receiver[:email] == AdaptivePayments.admin_email
        each_amount << " admin amount #{receiver[:amount]}"
      else
        each_amount << " another amount #{receiver[:amount]}"
      end
    end

    logger.info("[PAYPAL][PAY][SUCCESS] payKey: #{pay_response.payKey} correlationId: #{pay_response.responseEnvelope.correlationId}" \
                " Successfully #{each_amount}")
  end

  def pay_back_log(pay_response)
    logger.info("[PAYPAL][PAYBACK][SUCCESS] correlationId: #{pay_response.responseEnvelope.correlationId}")
  end

  def payment_error_log(response, type)
    errorInfo = response.error.map { |item|
      { errorId: item.errorId,
        message: item.message,
      }
    }.first.merge({ correlationId: response.responseEnvelope.correlationId })

    logger.error "[PAYPAL][#{type}][FAILED] correlationId: #{errorInfo[:correlationId]}" \
       "  errorId: #{errorInfo[:errorId]} with errorMessage: #{errorInfo[:message]}"
  end

  def preapproval_options(opts = {})
    { :currencyCode => 'USD',
      :maxTotalAmountOfAllPayments => opts[:maxTotalAmountOfAllPayments],
      :displayMaxTotalAmount => TRUE,
      :startingDate => Time.now,
      :endingDate => opts[:endingDate],
      :maxNumberOfPayments => 1,
      :maxNumberOfPaymentsPerPeriod => 1,
      :pinType => 'NOT_REQUIRED',
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
      :cancelUrl => application_url(cancel_projects_path),
      :returnUrl => application_url(complete_projects_path),
      :feesPayer => 'PRIMARYRECEIVER'
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
