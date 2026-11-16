let text = "Hello";
let text2 = "World";

class episode{
	construtor(title, duration, minuteswatched){
		this.title = title;
		this.duration = duration;
		let watchedtext = "";

		if (minuteswatched == duration) {
			this.watchedtext = "watched";
		}
		if(minuteswatched > 0 && minuteswatched < duration){
			this.watchedtext = "watching";
		}
		if(minuteswatched == 0){
			this.watchedtext = "notwatched";
		}
	}
}

let episode1 = new episode("Begins",108,0);
let episode2 = new episode("Dark Knight",126,85);

console.log(episode1);
console.log(episode2);

console.log(episode1.title);