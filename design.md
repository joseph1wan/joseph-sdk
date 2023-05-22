# SDK Design

## Philosophy

I modeled the SDK design after the Octokit philosophy of keeping the SDK
structure close to the original API. The classes provide getter methods with Ruby-convention naming. I originally planned to allow users to fetch quotes from movies (`Movie.quotes`) and vice-versa, but ultimately removed that functionality since those methods can be costly in API calls if the developer is not careful. Instead, developers should use the Client for all API calls (`Client.movie_quotes(movie_id)`).

## Objectives:
One of my main objectives in this API design is to prevent my users from running into some of the problem I ran into:
- Receiving an empty response for a movie that didn't exist
- Getting a 500 error when the ID wasn't a 24-char string
- Partial movie-name matching not working until converted to Regex

Another important objective of the design was clarity. I spent a good portion of development time writing tests and making sure all methods were documented.

## Areas of improvement

### Schema validation
Implementing schema validation on the response from The One API would:
1. Give early warning about API changes.
2. Provide useful data about what changed.
3. Make it trivial to update and release a new version of the SDK.

### Meta programming
Using meta-programming, we could programmatically create class methods with Ruby-convention naming using the keys of the JSON response. 

For example, we could potentially take advantage of Ruby's `NoMethodError` and infer that `runtime_in_minutes` would be `runtimeInMinutes` and access the data using that key. Essentially defining this method without writing code:

```
def runtime_in_minutes
    @data["runtimeinMinutes"]
end
```

However, I find that this can create more headache than help, depending on edge cases. It also makes it much harder to generate documentation from code (can't use YARD). But it would be handle changes in the source API response with very little
code change.
