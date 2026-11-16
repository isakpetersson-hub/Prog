const blueButton = document.getElementById("color-button-blue");
const brownButton = document.getElementById("color-button-brown");
const greenButton = document.getElementById("color-button-green");
const noneButton = document.getElementById("color-button-none");
const addbutton = document.getElementById("add-post");
const removebutton = document.getElementById("remove-post");
const page = document.getElementsByClassName("container");
let artical = document.createElement('p');
let articalclass = document.getElementsByTagName('article');
blueButton.addEventListener('click', () => {page[0].classList.remove('brown','green','none'), page[0].classList.add('blue'); } );
brownButton.addEventListener('click', () => {page[0].classList.remove('blue','green','none'), page[0].classList.add('brown'); } );
greenButton.addEventListener('click', () => {page[0].classList.remove('blue','brown','none'), page[0].classList.add('green'); } );
noneButton.addEventListener('click', () => {page[0].classList.remove('blue','brown','green'), page[0].classList.add('none'); } );
addbutton.addEventListener('click', () => {createNewPost(artical)} );
removebutton.addEventListener('click', () => {RemovePost(artical)} );

function createNewPost(artical){
	artical.innerHTML = 'Test';
	articalclass[0].appendChild(artical);
}
function RemovePost() {
  articalclass[0].removeChild(articalclass[0].lastChild);
}