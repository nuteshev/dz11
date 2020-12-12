В группу admin входят пользователи dockeradmin и vagrant и не входит пользователь notadmin. У пользователей notadmin и dockeradmin пароль Otus2019. 

Пользователь dockeradmin может управлять сервисом docker следующим образом: 
```
sudo systemctl restart docker
sudo systemctl start docker
sudo systemctl stop docker
```
Остальные команды докера просто выполняются как 
```
docker ...
```
