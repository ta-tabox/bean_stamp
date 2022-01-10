FactoryBot.define do
  factory :offer do
    ended_at { Date.current.next_day(5) }
    roasted_at { Date.current.next_day(10) }
    receipt_started_at { Date.current.next_day(15) }
    receipt_ended_at { Date.current.next_day(20) }
    price { 1000 }
    weight { 100 }
    amount { 10 }
    bean
  end
end
