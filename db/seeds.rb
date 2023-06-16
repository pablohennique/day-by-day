
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
emily = User.new(first_name:"Pablo", last_name:"Brown", email:"emily6@gmail.com", password:"111111")
emily.save
pablo = User.new(first_name:"Pablo", last_name:"Hennique", email:"pablo@gmail.com", password:"111111", admin: true)
pablo.save


puts "Adding an entry..."

Entry.create!(content: "I was stretching after climbing today and it felt so good! I should really try to do it more often.",
                        date: Date.today - 8,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "I woke up halfway through the night because Sacha was crying. Its been several days that he sleeps poorly. I think it is because of his mattress. Maybe Charlene is right and we should buy a new one. Regardless, it is messing up my days. I still feel tired after two cups of coffee.",
                        date: Date.today - 1,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Sacha is not sleeping well in his bed", user_id: pablo.id))

Entry.create!(content: "Today was the first day of career week, I think there were some good tips but I don’t know if it will really help me to find a job. However, I met Sam and got me really excited about her company. I’m going to send her my CV.",
                        date: Date.today - 4,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Job hunt stress", user_id: pablo.id, done: true))

Entry.create!(content: "I got into a fight with Mike. He was very aggressive and I had to tell him to stop. It sucks because he is a good friend and now, we are not talking",
                        date: Date.today - 6,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Fight with Mike", user_id: pablo.id))

Entry.create!(content: "I ate too much pizza today and I had really bad stomach issues. I know I'm lactose intolerant and am so mad that I didn't take my Lactaid",
                        date: Date.today - 10,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Pizza overindulgence led to stomach discomfort", user_id: pablo.id))

Entry.create!(content: "I did not understand a single thing the Stephan was talking about during the lecture today. The entire AJAX concept is way above my head. I am happy Mark asked about it because otherwise I would have been more lost",
                        date: Date.today - 11,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Difficulty understanding the SQL lecture", user_id: pablo.id, done: true))

Entry.create!(content: "I was unable to fall asleep last night because I could not stop thinking about whether or not I will be able to find a job. I concluded that I just have to do my best and trust that things will work out in the end.",
                        date: Date.today - 16,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Job hunt stress"))

Entry.create!(content: "I was watching finding nemo and it made me cry so much. The scene with the dad really touched me. It made me think about me and my dad.",
                        date: Date.today - 18,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "Thinking about my dad", user_id: pablo.id, done: true))

Entry.create!(content: "Mike was being mean again. This time he was the one who started the discussion. It was only logical that I would tell him to stop. If he ever brings up my sister again, I’ll lose it. I’m so pissed!",
                        date: Date.today - 19,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Fight with Mike"))

Entry.create!(content: "I keep thinking about finding a job once I am done with the bootcamp. I sure hope it won’t be too hard given all the tech layoffs. Sophia gave me some words of encouragement. It helped a lot, but I can’t help but be doubtful at times.",
                        date: Date.today - 21,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Job hunt stress"))
Entry.create!(content: "I saw this story on IG that made me shed a tear. A baby squirrel thought that he was being raised by a family of cats. It made me feel so hopeful about life and nature in general. Its weird in a way, but feels good.",
                        date: Date.today - 23,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: Obstacle.create!(title: "IG post about baby squirrel made me cry", user_id: pablo.id))

Entry.create!(content: "I love Mondays! It’s a bit weird, but I think it’s because I finally get some break from my being a dad and I get to sip my coffee in peace.",
                        date: Date.today - 29,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "I am happy that I found my cat. It was super scary not to see him for so long. When I found him, I recognized how much I appreciated him. I’ve had him for only 2 years but it feels like so long.",
                        date: Date.today - 31,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "Charlene welcomed me with an amazing dinner and wine. I did not see that coming. We had a good chat and spent so much time laughing and reminiscing about our past.",
                        date: Date.today - 51,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "Ever since I got to Canada things have been working out for the better. Sometimes I forget, but I consider myself extremely lucky to be living here. The financial and political stability do not compare at all with Mexico. And the job opportunities and quality of life is out of this world. The only thing I do miss about Mexico is the food. I wish they had good tacos here.",
                        date: Date.today - 49,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "Today we turned Sacha's crib into a bed. Sacha was excited but it was very difficult to get him to sleep. Kept wanting to leave his bed",
                        date: Date.today - 6,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Sacha is not sleeping well in his bed"))

  Entry.create!(content: "Sacha woke up several times throughout the night and walked out of his bed. We are exhausted. This new change is more difficult than I thought it would be",
                        date: Date.today - 4,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Sacha is not sleeping well in his bed"))

  Entry.create!(content: "This time Sacha jumped into our bed and told us he did not want to sleep alone. I had to pick him up and bring him back to his bed. We did this 5 times throughout the night. Its hard",
                        date: Date.today - 2,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: Obstacle.find_by(title: "Sacha is not sleeping well in his bed"))


Entry.create!(content: "I stayed up late watching Arcane on Netflix. I might be a bit tired today but I really needed to disconnect yesterday. I am glad I did it",
                        date: Date.today - 60,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "I had a great conversation with Charlene. We really are on the same wavelength when it comes to cooking. Hard at first, but we've found a good rhythm",
                        date: Date.today - 62,
                        sentiment: "Positive",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "Reading Homo Sapiens now and its such a great book! I love how the author explains the evolution of human kind and how we are free to choose our own spiritual path",
                        date: Date.today - 68,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "Reading Homo Sapiens now and its such a great book! I love how the author explains the evolution of human kind and how we are free to choose our own spiritual path",
                        date: Date.today - 68,
                        sentiment: "Neutral",
                        user: pablo,
                        obstacle: nil)

Entry.create!(content: "I'm having a hard time understanding why my mom keeps telling me to call her every Sunday. Its so annoying",
                        date: Date.today - 40,
                        sentiment: "Negative",
                        user: pablo,
                        obstacle: nil)

puts "Adding recommendations..."

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


Recommendation.create(content: "I’m sorry that you're going through a difficult time because it's been hard for Sacha to sleep in his new bed.
                                Maybe seeing the situation from a different perspective would help.
                                This experience is an excellent opportunity to teach Sacha how to be autonomous.
                                Even though it might be difficult, you are reinforcing an independent personality.
                                It is also giving you the opportunity to show Sacha how much you care for him by showing him that you trust him.
                                This experience serves as a valuable lesson to become a better parent and will probably help you in the long run
                                since sacha will be able to sleep alone in his bed without your help.",
                      category: "Reframing",
                      obstacle: Obstacle.find_by(title: "Sacha is not sleeping well in his bed"))


Recommendation.create(content: "It might help to put yourself in the shoes of Sacha and understand where he is coming from.
                                This will help you offer him compassion for what he is going through.
                                As a toddler, it might be intimidating to learn to sleep on your own. Sounds and the dark could be scary.
                                Try to vosualize love an dunderstanding for Sacha. See that it is difficult for him as well.
                                Offering compassion might help you gain more patience and understanding to go through your sleepless nights",
                      category: "Compassion",
                      obstacle: Obstacle.find_by(title: "Sacha is not sleeping well in his bed"))


Recommendation.create(content: "You might want to focus on the sensations of frustration and fatige that you feel througout your body.
                                Welcoming these emotions will help you better relate to them and less prone to being frustrated with Sacha.
                                On top of that, noticing these emotions and allowing them to be, will help you better manage your emotional state
                                and by consequence be more nurturing with Sacha",
                      category: "Feel Emotions",
                      obstacle: Obstacle.find_by(title: "Sacha is not sleeping well in his bed"))


puts "Adding gratefulness..."

Gratefulness.create(content: "I'm grateful for Sacha's independence and growth, and for the small moments that remind me of how lucky I am to have him as my son.",
                    created_at: "Mon, 14 Aug 2023 20:38:57.461908000 UTC +00:00",
                    user: pablo)
