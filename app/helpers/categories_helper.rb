module CategoriesHelper
  # Add button
  def link_to_add_field(name, f, association, options={})
    # association で渡されたシンボルから、対象のモデルを作る
    # 前回コントローラーで実装したモデルの build にあたる処理
    new_object = f.object.class.reflect_on_association(association).klass.new

    # Javascript 側で配列のインデックス値とする
    # 追加しまくると、インデックス値がかぶりまくるので、
    # 後に Javascript 側でこのインデックス値は現在時刻をミリ秒にした値で置き換えていく
    id = new_object.object_id

    # f はビューから渡されたフォームオブジェクト
    # fields_for で f の子要素を作る
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_form", f: builder)
    end

    # ボタンの設置。classを指定してJavascriptと連動、fields を渡しておいて、
    # ボタン押下時にこの要素(fields)をJavascript側で増やすようにする
    link_to(name, '#', class: "add_field", data: {id: id, fields: fields.gsub("\n","")})
  end

  # Delete button
  def link_to_remove_field(name, f, options={})
    # _destroy の hiddenフィールドと削除ボタンを設置
    f.hidden_field(:_destroy) + link_to(name, '#', class: "remove_field")
  end
end
