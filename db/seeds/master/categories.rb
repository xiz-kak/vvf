language_id_en = Language.find_by(code: :en).id
language_id_vi = Language.find_by(code: :vi).id
language_id_ja = Language.find_by(code: :ja).id

ctgr=Category.create(sort_order: 1)
ctgr.category_locales.create(language_id: language_id_en, name: 'Art')
ctgr.category_locales.create(language_id: language_id_vi, name: '')
ctgr.category_locales.create(language_id: language_id_ja, name: 'アート')

ctgr=Category.create(sort_order: 2)
ctgr.category_locales.create(language_id: language_id_en, name: 'Crafts')
ctgr.category_locales.create(language_id: language_id_vi, name: '')
ctgr.category_locales.create(language_id: language_id_ja, name: '制作物')

ctgr=Category.create(sort_order: 3)
ctgr.category_locales.create(language_id: language_id_en, name: 'Fashion')
ctgr.category_locales.create(language_id: language_id_vi, name: '')
ctgr.category_locales.create(language_id: language_id_ja, name: 'ファッション')
