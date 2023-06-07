
puts "Deleting entries..."
Entry.delete_all
puts "Deleting obstacles..."
Obstacle.delete_all
puts "Deleting recommendations..."
Recommendation.delete_all
puts "Deleting users..."
User.delete_all

puts "Adding a user..."
tom = User.new(first_name:"Tom", last_name:"Kim", email:"ehdgus5289@gmail.com", password:"111111")
tom.save
alexane = User.new(first_name:"Alexane", last_name:"Krek", email:"alexane@gmail.com", password:"111111")
alexane.save
emily = User.new(first_name:"Emily", last_name:"Brown", email:"emily6@gmail.com", password:"111111")
emily.save
pablo = User.new(first_name:"Pablo", last_name:"Hennique", email:"pablo@gmail.com", password:"111111")
pablo.save

puts "Adding obstacles..."
obstacle = Obstacle.new(title:"Discovering the hope in life", description:"A baby squirrel story from IG brightened my insight toward the humanity")
obstacle.save



users = [tom, alexane, emily, pablo]
mood = ["Positive", "Non-positive"]
entry_content = [
"I saw this story on IG that made me shed a tear. A baby squirl thought that he was being raised by a family of cats. It made me feel so hopeful about life and nature in general. Its weird in a way, but feels good.",
"I woke up halfway through the night because Sacha was crying. Its been several days that he sleeps poorly. I think it is because of his mattress. Maybe Charlene is right and we should buy a new one. Regardless, it is messing up my days. I still feel tired after two cups of coffee.",
"Today was the first day of career week, I think there were some good tips but I don’t know if it will really help me to find a job. However, I met Sam and got me really excited about her company. I’m going to send her my CV.",
"I got into a fight with Antoine. He was very aggressive and I had to tell him to stop. It sucks because he is a good friend and now, we are not talking",
"I found a coin while I was walking to work. It made me think about my grandmother. She always used to say that finding a penny would make give you luck for the rest of the day. I miss her",
"I did not understand a single thing the Stephan was talking about during the lecture today. The entire AJAX concept is way above my head. I am happy Mark asked about it because otherwise I would have been more lost",
"I was unable to fall asleep last night because I could not stop thinking about whether or not I will be able to find a job. I concluded that I just have to do my best and trust that things will work out in the end.",
"I was watching finding nemo and it made me cry so much. The scene with the dad really touched me. It made me think about me and my dad.",
"Antoine was being an asshole again. This time he was the one who started the discussion. It was only logical that I would tell him to stop. If he ever brings up my sister again, I’ll lose it. I’m so pissed!",
"I keep thinking about finding a job once I am done with the bootcamp. I sure hope it won’t be too hard given all the tech layoffs. Sophia gave me some words of encouragement. It helped a lot, but I can’t help but be doubtful at times.",
"I saw this story on IG that made me shed a tear. A baby squirl thought that he was being raised by a family of cats. It made me feel so hopeful about life and nature in general. Its weird in a way, but feels good.",
"I woke up halfway through the night because Sacha was crying. Its been several days that he sleeps poorly. I think it is because of his mattress. Maybe Charlene is right and we should buy a new one. Regardless, it is messing up my days. I still feel tired after two cups of coffee.",
"Today was the first day of career week, I think there were some good tips but I don’t know if it will really help me to find a job. However, I met Sam and got me really excited about her company. I’m going to send her my CV.",
"I love Mondays! It’s a bit weird, but I think it’s because I finally get some break from my being a dad and I get to sip my coffee in peace.",
"I am happy that I found my cat. It was super scary not to see him for so long. When I found him, I recognized how much I appreciated him. I’ve had him for only 2 years but it feels like so long.",
"Charlene welcomed me with an amazing dinner and wine. I did not see that coming. We had a good chat and spent so much time laughing and reminiscing about our past.",
"Ever since I got to Canada things have been working out for the better. Sometimes I forget, but I consider myself extremely lucky to be living here. The financial and political stability do not compare at all with Mexico. And the job opportunities and quality of life is out of this world. The only thing I do miss about Mexico is the food. I wish they had good tacos here."
]
puts "Adding an entry..."

entry_content.each do |entry|
Entry.new(content: entry,
                date: Date.today,
                sentiment: nil,
                user: users.sample,
                ).save!
end
