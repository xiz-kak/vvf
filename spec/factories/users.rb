FactoryGirl.define do
  factory :admin, class: User do
    email "admin@linkage.jp.net"
    password "admin"
    password_confirmation "admin"
    # salt "salt"
    # crypted_password "linkage00"
    name "Shizuka Kakimoto"
    is_admin true
  end
end
