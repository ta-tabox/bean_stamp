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

    trait :update do
      price { '1500' }
    end

    trait :too_early_ended_at do
      ended_at { Date.current.prev_day(1) }
    end

    trait :too_early_roasted_at do
      ended_at { Date.current.next_day(5) }
      roasted_at { Date.current.next_day(4) }
    end

    trait :too_early_receipt_started_at do
      roasted_at { Date.current.next_day(10) }
      receipt_started_at { Date.current.next_day(9) }
    end

    trait :too_early_receipt_ended_at do
      receipt_started_at { Date.current.next_day(15) }
      receipt_ended_at { Date.current.next_day(14) }
    end

    trait :on_roasting do
      ended_at { Date.current.prev_day(1) }
      to_create { |instance| instance.save(validate: false) }
    end

    trait :on_preparing do
      ended_at { Date.current.prev_day(5) }
      roasted_at { Date.current.prev_day(1) }
      to_create { |instance| instance.save(validate: false) }
    end

    trait :on_selling do
      ended_at { Date.current.prev_day(10) }
      roasted_at { Date.current.prev_day(5) }
      receipt_started_at { Date.current.prev_day(1) }
      to_create { |instance| instance.save(validate: false) }
    end

    trait :end_of_sales do
      ended_at { Date.current.prev_day(15) }
      roasted_at { Date.current.prev_day(10) }
      receipt_started_at { Date.current.prev_day(5) }
      receipt_ended_at { Date.current.prev_day(1) }
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
