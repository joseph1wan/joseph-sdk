# SDK Design

I modeled the SDK design after the Octokit philosophy of keeping the SDK
structure close to the original API. The classes provide getter methods with Ruby-convention naming. I originally planned to allow users to fetch quotes from movies (`Movie.quotes`) and vice-versa, but ultimately removed that functionality since those methods can be costly in API calls if the developer is not careful. Instead, developers should use the Client for all API calls (`Client.movie_quotes(movie_id)`).
