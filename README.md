# Day by Day

Day by Day is an online journaling app built on Ruby on Rails that uses ChatGPT to find patterns in your jounral, 
identify your main obstacles and provide you with personalized recommendations to help you navigate them
<br>
<br>
https://www.ai-journaling.online/


# How it Works

The application integrates with ChatGPT via the <a href="https://github.com/alexrudall/ruby-openai">OpenAI Ruby Gem</a>. 

Users are encouraged to write on their online journal on a daily basis (aka "entries"). 

For every entry created by the user, the application calls OpenAI several times following a series of steps: 
- Identify the sentiment of the post (Positive, Neutral, Negative)
- If Positive, it will generate a gratefulness statement 
- If Negative, it will generate an "Obstacle" that the user will be able to visit at a later point. The Obstacles represent the life problems/challenges the user faces
- The application will try to identify patterns in the user's journal by merging the content of new entries with existing Obstacles whenever possible
- For every Obstacle created, ChatGPT will assess which of the following 4 Mindfulness tactics can be applied: Reframing, Visualization, Compassion or Feel Emotions
- ChatGPT will then generate recommendations for each of the tactics that were applicable to the Obstacle. Recommendations are based on the user entries linked to the Obstacle

The user has access to his/her entries, Obstacles and recommendations. The user can mark an Obstacle as resolved whenever he/she feels like the Obstacle has been addressed and thus get a feeling of progression


# Set Up

Clone this repository. Create a .env file in the project directory. Add your OpenAI API key to the .env file as follows:

OPENAI_API_KEY=your_api_key_here

Replace your_api_key_here with your actual OpenAI API key

Install gems??

# Running the Script

After setting up the project, run the main script using:
Rails s

Make sure that you are running a sidekiq server and JavaScript: 
Rails 
yarn build --watch

Open your browser and run your local host (http://localhost:3000/)
