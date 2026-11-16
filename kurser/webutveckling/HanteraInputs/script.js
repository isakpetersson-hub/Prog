const firstName = document.getElementById("first-name");
const lastName  = document.getElementById("last-name");
const button = document.getElementById("submit-button");
const sidebar = document.getElementById("sidebar");
const commentForm = document.getElementById("comment-form");
button.addEventListener('click', () => {event.preventDefault(),sidebar.textContent = "Hej på dig " + firstName.value + " " + lastName.value, commentForm.reset()} );
