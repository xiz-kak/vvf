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
