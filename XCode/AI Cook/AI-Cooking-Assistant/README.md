# AI-Cooking-Assistant
Our Group Capstone Project!
AI Chef?

MVP:
“I want to make…” text box
Parse ChatGPT response to use ‘steps’ to make the recipe
Put each step in an easy-to-read format
Interface:
Textbox
Cook button
(navigation) Full screen New screen: Step 1
Next/Previous
Change what’s displayed/no new screen per step
Back Button (Navigation)

What’s unique/ possible future features:
Alternative Recipes
Vague descriptions generates recipe
“I don’t like these foods” or “I only have these ingredients”
Progress steps without touching your phone
Have a “next” button that gets tapped when you user says “next” (and Previous)
AI Generated Pictures of food
David Idea- User can choose between different generated recipe ideas (new screen in between request screen and steps screen?) three buttons, the button text is the recipe
Save ingredients for shopping
Save recipe at the end/ re-cook old stuff
Re-roll recipe
Cross out bad ingredients

Form Content (make call with room for these eventually)
Don’t include these ingredients
How many people


Roles: (Separate out concerns)
AI Wrangler: David
Lead Designer: Juliana
Programmer & and Coder: Zane

Prompts* suggestions (bullet points)
Text box (user types)
Character (“hii :)”)

AI assignment
Parse response into two parts:
1: list of ingredients needed
2: steps for how to prepare the recipe

^^ Instead of doing this i’ve opted to send multiple smaller engineered requests batch by batch to get exactly what we need

Local Level Programming (Zane’s stuff):
Taking info user provides and giving it to the AI
Taking info from AI response and applying it to correct variables. 
Switching screens and steps.
Microphone Access
Speech to Text
Text to Speech



Directions Screen:
var recipe: Recipe
var currentIndex = Int()

if currentIndex == 0 {
	stepLabel.text = “Ingredients”
}

else {
stepLabel.text = “Step \(currentIndex)”
}

directionsLabel.text = recipe.steps[currentIndex]

IBAction func nextButtonPressed {
	If currentIndex < recipe.steps.count


System prompt:

You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience.

Generic user prompt for ingredients:

Generate a recipe title and list of ingredients based on this request: [request]

Second user prompt (second request):
Generate steps for how to prepare this recipe based on this list of ingredients: [ingredients]

var ingredients = [
“1 small russet potato, peeled and diced”,
“1 small leek, white and light green parts only, thinly sliced”,
“1/2 small onion, chopped”,
“1 garlic clove, minced”,
“1 tablespoon unsalted butter”,
“1 cup chicken or vegetable broth”,
“1/4 cup heavy cream”,
“Salt and pepper to taste”,
“Chopped fresh chives or parsley for garnish (optional)”
]

var instructions = [
“Begin by washing and slicing the leek. Make sure to rinse it thoroughly as leeks can often have dirt between the layers.”,
Peel and dice the potato, chop the onion, and mince the garlic.
Saute the Vegetables:
In a small saucepan over medium heat, melt the butter.
Add the chopped onion and leek. Cook for about 5 minutes, or until they become soft and translucent.
Add the minced garlic and cook for an additional 30 seconds, stirring constantly to prevent it from burning.
Cook the Potatoes:
Add the diced potato to the saucepan and stir to combine with the other vegetables.
Pour in the chicken or vegetable broth, ensuring that the potatoes are fully submerged.
Bring the mixture to a gentle simmer and then reduce the heat to low. Cover the saucepan and let it cook for about 15-20 minutes, or until the potatoes are tender and easily pierced with a fork.
Blend the Soup:
Once the potatoes are cooked, remove the saucepan from the heat.
Use an immersion blender to puree the soup until smooth. If you don't have an immersion blender, you can carefully transfer the soup to a regular blender and blend in batches, being cautious with the hot liquid.
Return the blended soup to the saucepan.
Add Cream and Seasoning:
Stir in the heavy cream and return the saucepan to low heat.
Season the soup with salt and pepper to taste. Adjust the seasoning as needed.
Serve:
Ladle the hot potato leek soup into a bowl.
Garnish with chopped fresh chives or parsley, if desired.


