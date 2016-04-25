# == Schema Information
#
# Table name: project_pledge_summaries
#
#  id            :integer          not null, primary key
#  project_code  :string
#  funded_count  :integer
#  funded_amount :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ProjectPledgeSummary < ActiveRecord::Base
end
