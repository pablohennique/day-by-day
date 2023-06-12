
puts "Deleting recommendations..."
Recommendation.destroy_all
puts "Deleting entries..."
Entry.destroy_all
puts "Deleting obstacles..."
Obstacle.destroy_all
puts "Deleting users..."
User.destroy_all

puts "Adding a user..."
tom = User.new(first_name:"Tom", last_name:"Kim", email:"ehdgus5289@gmail.com", password:"111111")
tom.save
alexane = User.new(first_name:"Alexane", last_name:"Krek", email:"alexane@gmail.com", password:"111111")
alexane.save
emily = User.new(first_name:"Emily", last_name:"Brown", email:"emily6@gmail.com", password:"111111")
emily.save
pablo = User.new(first_name:"Pablo", last_name:"Hennique", email:"pablo@gmail.com", password:"111111")
pablo.save


puts "Adding an entry..."
users = [tom, alexane, emily, pablo]

entry_1 = Entry.create!(content: "I saw this story on IG that made me shed a tear. A baby squirl thought that he was being raised by a family of cats. It made me feel so hopeful about life and nature in general. Its weird in a way, but feels good.",
                        date: Date.today,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

entry_2 = Entry.create!(content: "I woke up halfway through the night because Sacha was crying. Its been several days that he sleeps poorly. I think it is because of his mattress. Maybe Charlene is right and we should buy a new one. Regardless, it is messing up my days. I still feel tired after two cups of coffee.",
                        date: Date.today - 1,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Baby Sacha Crying", user_id: pablo.id))

entry_3 = Entry.create!(content: "Today was the first day of career week, I think there were some good tips but I don’t know if it will really help me to find a job. However, I met Sam and got me really excited about her company. I’m going to send her my CV.",
                        date: Date.today - 4,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Career Week Was Not Helpful", user_id: pablo.id))

entry_4 = Entry.create!(content: "I got into a fight with Mike. He was very aggressive and I had to tell him to stop. It sucks because he is a good friend and now, we are not talking",
                        date: Date.today - 6,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Fight with Mike", user_id: pablo.id))

entry_5 = Entry.create!(content: "I found a coin while I was walking to work. It made me think about my grandmother. She always used to say that finding a penny would make give you luck for the rest of the day. I miss her",
                        date: Date.today - 10,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Miss my grandmother", user_id: pablo.id))

entry_6 = Entry.create!(content: "I did not understand a single thing the Stephan was talking about during the lecture today. The entire AJAX concept is way above my head. I am happy Mark asked about it because otherwise I would have been more lost",
                        date: Date.today - 11,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Coudln't Understand a Lecture", user_id: pablo.id))

entry_7 = Entry.create!(content: "I was unable to fall asleep last night because I could not stop thinking about whether or not I will be able to find a job. I concluded that I just have to do my best and trust that things will work out in the end.",
                        date: Date.today - 16,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Career Week Was Not Helpful"))

entry_8 = Entry.create!(content: "I was watching finding nemo and it made me cry so much. The scene with the dad really touched me. It made me think about me and my dad.",
                        date: Date.today - 18,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Think about my dad", user_id: pablo.id))

entry_9 = Entry.create!(content: "Mike was being an asshole again. This time he was the one who started the discussion. It was only logical that I would tell him to stop. If he ever brings up my sister again, I’ll lose it. I’m so pissed!",
                        date: Date.today - 19,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Fight with Mike"))

entry_10 = Entry.create!(content: "I keep thinking about finding a job once I am done with the bootcamp. I sure hope it won’t be too hard given all the tech layoffs. Sophia gave me some words of encouragement. It helped a lot, but I can’t help but be doubtful at times.",
                        date: Date.today - 21,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Career Week Was Not Helpful"))

entry_11 = Entry.create!(content: "I saw this story on IG that made me shed a tear. A baby squirl thought that he was being raised by a family of cats. It made me feel so hopeful about life and nature in general. Its weird in a way, but feels good.",
                        date: Date.today - 23,
                        sentiment: "Non-positive",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "IG Post Made Me Cry", user_id: pablo.id))

entry_12 = Entry.create!(content: "I love Mondays! It’s a bit weird, but I think it’s because I finally get some break from my being a dad and I get to sip my coffee in peace.",
                        date: Date.today - 29,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

entry_13 = Entry.create!(content: "I am happy that I found my cat. It was super scary not to see him for so long. When I found him, I recognized how much I appreciated him. I’ve had him for only 2 years but it feels like so long.",
                        date: Date.today - 31,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

entry_14 = Entry.create!(content: "Charlene welcomed me with an amazing dinner and wine. I did not see that coming. We had a good chat and spent so much time laughing and reminiscing about our past.",
                        date: Date.today - 45,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

entry_15 = Entry.create!(content: "Ever since I got to Canada things have been working out for the better. Sometimes I forget, but I consider myself extremely lucky to be living here. The financial and political stability do not compare at all with Mexico. And the job opportunities and quality of life is out of this world. The only thing I do miss about Mexico is the food. I wish they had good tacos here.",
                        date: Date.today - 49,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)


puts "Adding recommendations"

Recommendation.create(content: "I’m sorry that you had a fight with Mike. It must be difficult, specially because its your best friend.
                                Maybe seeing the situation from a different perspective would help. The recent fight
                                between you and Mike can be seen as a transformative experience that has the potential to strengthen your bond.
                                Despite the initial conflict, both of you had the chance to openly express your thoughts and emotions,
                                fostering a deeper understanding between yourselves. By actively addressing and resolving the disagreement,
                                you demonstrated a commitment to honest communication and mutual respect.
                                This experience serves as a valuable lesson in conflict resolution, allowing you to build a stronger
                                friendship that can endure future challenges with grace and understanding.",
                      category: "Reframing",
                      obstacle: Obstacle.find_by(title: "Fight with Mike"))

Recommendation.create(content: "It might help to practice compassion for Mike. Even though he might have wronged you,
                                understanding how his anger made him act this way might help you process the situation.
                                Try to visualize love and understanding for Mike. Send him good wishes and remember that
                                he is also trying to be happy, like every human being.",
                      category: "Compassion",
                      obstacle: Obstacle.find_by(title: "Fight with Mike"))

Recommendation.create(content: "You might want to focus on the sensation of pain and anger in your body. Try closing
                                your eyes and stay with your emotions for a few minutes. Understand how each emotion
                                feels. Welcome it and see how it moves. With time, you might notice that the emotion
                                of anger and pain lose their intensity. When this happens, you might be better
                                equiped to deal with Mike",
                      category: "Feel Emotions",
                      obstacle: Obstacle.find_by(title: "Fight with Mike"))
