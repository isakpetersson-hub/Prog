document.addEventListener('DOMContentLoaded', function() {
  var deleteBtn = document.getElementsByTagName('i');
  for (let i = 0; i < deleteBtn.length; i++) {
  deleteBtn[i].addEventListener('click', function() {
    var id = deleteBtn[i].id;
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'php/delete-row.php');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
      if (xhr.status === 200 && xhr.responseText) {
        console.log(xhr.responseText);
        location.reload();
      } else {
        console.log('Request failed. Status: ' + xhr.status);
      }
    };
    xhr.send('id=' + encodeURIComponent(id));
  });
}
});
