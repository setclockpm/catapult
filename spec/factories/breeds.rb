FactoryGirl.define do
  
  factory :breed do
    name 'Norwegian Forest Cat'
    
    transient do
      tags_count 2 # if details count is not given while creating job, 2 is taken as default count
    end

    factory :breed_with_tags do
      after(:create) do |breed, evaluator|
        (0...evaluator.tags_count).each do |i|
          breed.tags << FactoryGirl.create(:tag)
        end
      end
    end
    
  end
end
