module Divs
  class ProjectStatus < Inum::Base
    define :DRAFT, 0
    define :APPLIED, 1
    define :REMANDED, 2
    define :CANCELED, 3
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
end
