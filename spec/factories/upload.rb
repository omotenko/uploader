FactoryGirl.define do
  factory :upload do
    attachment_file_name 'suppliers.csv'
    attachment_file_size '1000'
    attachment_content_type 'text/csv'
  end
end