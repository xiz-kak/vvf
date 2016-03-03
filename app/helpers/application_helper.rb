module ApplicationHelper
  # Add button
  def link_to_add_field(name, f, association, options={})
    # Generate a new empty instance
    new_object = f.object.class.reflect_on_association(association).klass.new

    # Index of js array
    id = new_object.object_id

    # Generate a child of f
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_form", f: builder)
    end

    # Generate Add button
    link_to(name, '#', class: "add_field", data: {id: id, fields: fields.gsub("\n","")})
  end

  # Remove button
  def link_to_remove_field(name, f, options={})
    # Generate Remove button with hidden field
    f.hidden_field(:_destroy) + link_to(name, '#', class: "remove_field")
  end
end
