critical_attributes = [ :name, :last_name, :born_city_id, :residence_city_id, :identification_number, :contact_number, :document_type_id, :about_me, :educational_degree_id]

users_with_empty_values = User.all.map { |user| [user.id,user.attributes.deep_symbolize_keys.slice(*critical_attributes).select { |key, value| value.eql?("") }] }.select { |user| user[1].any? }


users_with_empty_values.map { |user|
  u = User.find(user[0])
  u.skip_confirmation_notification!
  u.update(user[1].transform_values { |v| nil })
}
