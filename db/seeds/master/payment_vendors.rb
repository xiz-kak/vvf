language_id_en = Language.find_by(code: :en).id
language_id_vi = Language.find_by(code: :vi).id
language_id_ja = Language.find_by(code: :ja).id

pv=PaymentVendor.create(sort_order: 1)
pv.payment_vendor_locales.create(language_id: language_id_en, name: 'PayPal')
pv.payment_vendor_locales.create(language_id: language_id_vi, name: 'PayPal')
pv.payment_vendor_locales.create(language_id: language_id_ja, name: 'ペイパル')
