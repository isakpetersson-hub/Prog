Git kommandon

Nya changes:
git add
git commit -m "kommentar"
git push

för ny branch:
se till att vara på senaste branchen du vill skapa branch ifrån
git checkout -b "namn på branch"

om man vill flytta kod till en branch, eller ta bort saker man gjort kan man göra detta med git stash

flytta kod till en branch:
git stash
git checkout "namn på branch"
git stash apply
välj den stashen som ska läggas till
kommer se ut typ som: git stash apply stash@{0}
