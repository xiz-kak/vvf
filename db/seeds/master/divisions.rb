language_id_en = Language.find_by(code: :en).id
language_id_vi = Language.find_by(code: :vi).id
language_id_ja = Language.find_by(code: :ja).id

div=Division.create(code: 2, val: 1, sort_order: 1, description: 'project_status-draft')
div.division_locales.create(language_id: language_id_en, name: 'Draft')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '下書き')

div=Division.create(code: 2, val: 2, sort_order: 2, description: 'project_status-applied')
div.division_locales.create(language_id: language_id_en, name: 'Applied')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '申請中')

div=Division.create(code: 2, val: 5, sort_order: 4, description: 'project_status-active')
div.division_locales.create(language_id: language_id_en, name: 'Active')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '有効')

div=Division.create(code: 2, val: 9, sort_order: 6, description: 'project_status-closed')
div.division_locales.create(language_id: language_id_en, name: 'Closed')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '終了')

div=Division.create(code: 5, val: 1, sort_order: 1, description: 'reward_ships_to-no_shipping')
div.division_locales.create(language_id: language_id_en, name: 'No shipping involved')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '発送なし')

div=Division.create(code: 5, val: 2, sort_order: 2, description: 'reward_ships_to-certain_countries')
div.division_locales.create(language_id: language_id_en, name: 'Only ships to certain countries')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '一部の国のみ発送')

div=Division.create(code: 5, val: 3, sort_order: 3, description: 'reward_ships_to-anywhere_in_the_world')
div.division_locales.create(language_id: language_id_en, name: 'Anywhere in the world')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: '世界中の国へ発送')

div=Division.create(code: 7, val: 1, sort_order: 1, description: 'pledge_payment_method-wallet')
div.division_locales.create(language_id: language_id_en, name: 'Wallet')
div.division_locales.create(language_id: language_id_vi, name: '')
div.division_locales.create(language_id: language_id_ja, name: 'ウォレット')
