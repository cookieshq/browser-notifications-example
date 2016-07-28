FactoryGirl.define do
  factory :account do
  end

  factory :device do
    account
    user_agent "Browser User Agent v123"
    endpoint { "https://android.googleapis.com/gcm/send/test_#{SecureRandom.urlsafe_base64 114}" }
    p256dh { "test_#{SecureRandom.urlsafe_base64 66}" }
    auth { "test_#{SecureRandom.urlsafe_base64 16}" }
  end
end
