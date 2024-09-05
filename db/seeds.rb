user = User.create(email: Faker::Internet.email, password: "password", password_confirmation: "password")

30.times do
  Post.create(title: Faker::Lorem.sentence(word_count: 3),
                     body: Faker::Lorem.paragraph(sentence_count: 5),
                     user: user)
end
