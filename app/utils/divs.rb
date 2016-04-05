module Divs
  class ProjectStatus < Inum::Base
    define :TEMP, 0
    define :DRAFT, 1
    define :APPLIED, 2
    define :REMANDED, 3
    define :DISCARDED, 4
    define :ACTIVE, 5
    define :SUSPENDED, 6
    define :DROPPED, 9
  end

  class RewardShipsTo < Inum::Base
    define :NO_SHIPPING, 0
    define :CERTAIN_COUNTRIES, 1
    define :ANYWHERE_IN_THE_WORLD, 2
  end

  class PledgePaymentMethod < Inum::Base
    define :WALLET, 0
  end

  class PledgePaymentStatus < Inum::Base
    define :UNPAID, 1
    define :PREAPPROVAL_ERROR, 2
    define :PREAPPROVED, 3
    define :PAY_ERROR, 8
    define :APPROVED, 9
  end
end
