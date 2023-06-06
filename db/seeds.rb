
puts "Deleting entries..."
Entry.delete_all

puts "Adding a user..."
tom = User.new(first_name:"Tom", last_name:"Kim", email:"ehdgus5289@gmail.com", password:"111111")

puts "Adding obstacles..."
obstacle = Obstacle.new(title:"Discovering the hope in life", description:"A baby squirrel story from I
  G brightened my insight toward the humanity")

puts "Adding an entry..."
entry1 = Entry.new(content: "I saw this story on IG that made me shed a tear. A baby squirrel thought that he was being raised by a family of cats. It made me feel so hopeful about life and nature in general. Its weird in a way, but feels good.", date:Date.today, sentiment: "Bad", user_id: 1, obstacle_id: 1)
