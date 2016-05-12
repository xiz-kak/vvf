# == Schema Information
#
# Table name: project_pledge_summaries
#
#  id            :integer          not null, primary key
#  project_code  :string           not null
#  funded_count  :integer
#  funded_amount :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_project_pledge_summaries_on_project_code  (project_code) UNIQUE
#

class ProjectPledgeSummary < ActiveRecord::Base
  include NumberFormatter

  belongs_to :project, -> { active }, primary_key: :code, foreign_key: :project_code, inverse_of: :project_pledge_summary

  def achieved
    (funded_amount / project.goal_amount * 100).round
  end

  def funded_amount_z
    to_currency_z(funded_amount, :usd)
  end

  def funded_amount_f
    to_currency_f(funded_amount, :usd)
  end

  def self.pledge(project_code, funded_amount)
    sum = ProjectPledgeSummary.find_by(project_code: project_code)
    sum = ProjectPledgeSummary.new(project_code: project_code, funded_count: 0,
                                   funded_amount: 0) if sum.blank?

    sum.funded_count += 1
    sum.funded_amount += funded_amount

    sum.save
  end

  ## Currently not used
  # def self.revert(project_code, funded_amount)
  #   sum = ProjectPledgeSummary.find_by(project_code: project_code)

  #   if sum.present?
  #     sum.funded_count -= 1
  #     sum.funded_amount -= funded_amount

  #     sum.save
  #   else
  #     logger.error("Illegal revert of ProjectPledgeSummary. Error: Not Exist. projectCoder #{project_code}.")
  #   end
  # end
end
