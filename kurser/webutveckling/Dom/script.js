let headers = document.getElementsByTagName('header');
let body = document.getElementsByTagName('body');
headers[0].innerHTML = '<h1>Den första headern</h1>';
let ptagg = document.getElementsByTagName('p')
console.log(ptagg[0].classList);
for (var i = ptagg.length - 1; i >= 0; i--) {
	ptagg[i] = ptagg[i].classList.add('fancyRectangle')
	ptagg[i] = ptagg[i].style.color = 'red';
}
let newArticle = document.createElement('article');
let newp = document.createElement('p');
let newh3 = document.createElement('h3');

newh3.innerHTML = 'En fantastisk artikel';
newp.innerHTML = 'Den här artikeln är ihopsatt med Javascript efter att sidan har laddats in.<br>Det är ju helt otroligt eller hur?!';
newArticle.appendChild(newh3);
newArticle.appendChild(newp);
body[0].appendChild(newArticle);

newh3 = newh3.setAttribute('id','fantastiskt');
newArticle = newArticle.classList.add('fancyRectangle');

let ScriptName = document.querySelector('script');

console.log(ScriptName.src);
let begin = ScriptName.src.lastIndexOf("/");
let end = ScriptName.src.lastIndexOf(".");
let name = ScriptName.src.slice(begin+1,end);
console.log(name);
let title = document.getElementsByTagName('title');
title[0].innerHTML = name;