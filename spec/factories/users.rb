FactoryGirl.define do
  factory :admin, class: User do
    email "shizuka.kakimoto@linkage.jp.net"
    password "linkage00"
    password_confirmation "linkage00"
    # salt "salt"
    # crypted_password "linkage00"
    name "Shizuka Kakimoto"
    is_admin true
  end
end
