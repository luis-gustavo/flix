# Flix

Flix is a framework created to apply a pattern when creating games.

The name is just a cool abbreviation of Netflix because how it works was used to smooth the learning curve when creating a new game.

# 3W Data Pattern

## The problem of storing data for every game

The data collected in each game is the most important thing, and also the most difficult thing to find out a pattern that generalizes each of them. Why? Consider that each game is unique, the only thing they have in common is that data are collected. How can be possible to collect data for each game, even that not created yet, in a way that are equal to each game? It's a big challenge, do you agree?

The solution cam when we imagine the following:

If you need to collect some data for researchers, it is done when the game is being playing. So when you need to know how speed the player touches the screen, you need to store when each touch happen and calculate that, right? We are talking about this all in the present tense, but if we just talk about that in the past? If you can calculate something about what is happening, you also can calculate that same thing about what happened, *in the past*. 

So we can just store many many *chunks of data* about what happen in the game and whenever the results are necessary, we can just read that data and calculate some other thing. In the example above we store when each touch happen and derivates from that information how speed the player touches the screen whenever this information is needed.

## So how to store data in a good way?

To do that, we take by hypothesis that every thing that happened in a game happen *in some place*, *on a given moment* and that every thing have a name. It's not just a *thing*, it's a touch, a timeout, feedback, etc. So we have three things about every event.

- **What**: event's name.
- **When**: what point in time that event happened.
- **Where**: event's location in the game.

This is the 3W Data Pattern!

