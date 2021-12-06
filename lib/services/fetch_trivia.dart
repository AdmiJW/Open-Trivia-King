import 'package:http/http.dart';
import 'dart:convert';
import 'package:html_unescape/html_unescape_small.dart';



const Map<String, int> _mapCategoryToID = {
	'General Knowledge': 9,
	'Entertainment: Books': 10,
	'Entertainment: Film': 11,
	'Entertainment: Music': 12,
	'Entertainment: Musicals & Theatres': 13,
	'Entertainment: Television': 14,
	'Entertainment: Video Games': 15,
	'Entertainment: Board Games': 16,
	'Science & Nature': 17,
	'Science: Computers': 18,
	'Science: Mathematics': 19,
	'Mythology': 20,
	'Sports': 21,
	'Geography': 22,
	'History': 23,
	'Politics': 24,
	'Art': 25,
	'Celebrities': 26,
	'Animals': 27,
	'Vehicles': 28,
	'Entertainment: Comics': 29,
	'Science: Gadgets': 30,
	'Entertainment: Japanese Anime & Manga': 31,
	'Entertainment: Cartoon & Animations': 32,
};



// A class containing all the required information for a single trivia retrieved from Open Trivia DB
class Trivia {
	String category;
	String question;
	String answer;
	List<dynamic> choices;

	Trivia(Map<String, dynamic> fetchedTrivia):
		category = fetchedTrivia['results'][0]['category'].toString(),
		question = fetchedTrivia['results'][0]['question'].toString(),
		answer = fetchedTrivia['results'][0]['correct_answer'].toString(),
		choices = [
			...fetchedTrivia['results'][0]['incorrect_answers'],
			fetchedTrivia['results'][0]['correct_answer'].toString()
		] 
	{
		choices.shuffle();
	}

	@override
	String toString() {
		return "Category: $category\n"
			"Question: $question\n"
			"Answer: $answer\n"
			"Choices: $choices\n";
  	}
}





Future<Trivia> fetchNewQuestion(String category) async {
	if (!_mapCategoryToID.containsKey(category)) {
		throw ArgumentError("Invalid category $category.");
	}

	Response res;

	try {
		res = await get( 
			Uri.parse('https://opentdb.com/api.php?amount=1&category=${_mapCategoryToID[category]}')
		);
	} catch (e)  {
		throw Exception("There is a problem with your internet connection!\n\n Details:\n $e");
	}
	

	if (res.statusCode != 200) {
		throw Exception("Failed to fetch new trivia.\n Error code: ${res.statusCode}.");
	}

	return Trivia( jsonDecode(HtmlUnescape().convert(res.body.replaceAll('&quot;', '\\"')) ) );
}

