# Terrarm | Provisionnement d'un infrastructure AWS et déploiement d'une application Web sur AWS

_______

Firstname : Carlin

Surname : FONGANG

Email : fongangcarlin@gmail.com

><img src="https://media.licdn.com/dms/image/C4E03AQEUnPkOFFTrWQ/profile-displayphoto-shrink_400_400/0/1618084678051?e=1710979200&v=beta&t=sMjRKoI0WFlbqYYgN0TWVobs9k31DBeSiOffAOM8HAo" width="50" height="50" alt="Carlin Fongang"> 
>
>[LinkedIn](https://www.linkedin.com/in/carlinfongang/) | [GitLab](https://gitlab.com/carlinfongang) | [GitHub](https://githut.com/carlinfongang) | [Credly](https://www.credly.com/users/carlin-fongang/badges)

_______

## Définition
Terraform est un outil open-source développé par HashiCorp qui permet de provisionner et de gérer l'infrastructure informatique de manière déclarative et codée. Conçu pour fonctionner avec une variété de fournisseurs de services cloud, y compris AWS, Azure, Google Cloud, et bien d'autres, Terraform permet aux équipes informatiques de définir leur infrastructure comme du code.

## Contexte
Dans ce mini projet, nous allons explorer le processus de déploiement d'une application web sur Amazon Web Services (AWS) en utilisant Terraform pour automatiser la création et la configuration des ressources nécessaires. Notre objectif étant de créer une infrastructure replicable facilement et hébergent le serveur web nginx. On mettra egalement un point d'honneur sur la sécurité en s'assurant qu'aucune information sensible n'est exposée.


## Plan d'exécution

1. **Création d'une Instance EC2 :** Nous allons écrire un module Terraform pour créer une instance EC2 utilisant la dernière version d'Ubuntu. Ce module permettra de spécifier le type d'instance et le tag (nom) comme variables pour une personnalisation flexible.

2. **Création d'un Volume EBS :** Un autre module sera développé pour créer un volume EBS avec une taille variable, offrant ainsi une gestion efficace du stockage pour notre application.

3. **Attribution d'une Adresse IP Publique :** Nous allons définir un module pour une adresse IP publique qui sera attachée au groupe de sécurité, assurant une connectivité externe à notre application.

4. **Configuration d'un Groupe de Sécurité :** Un autre module sera dédié à la création d'un groupe de sécurité, permettant l'ouverture des ports 80 et 443 pour le trafic web.

5. **Déploiement de l'Application :** Nous allons organiser ces modules dans un dossier "app" pour simplifier le déploiement de notre application. Nous personnaliserons les variables pour rendre le processus de déploiement plus dynamique et adaptable.

6. **Installation de Nginx :** Enfin, nous allons intégrer l'installation de Nginx à la fin du déploiement en le configurant comme rôle de l'instance EC2.

7. **Enregistrement de l'Adresse IP Publique :** Pour une gestion pratique, nous enregistrerons l'adresse IP publique dans un fichier nommé "ip_ec2.txt" pour une référence ultérieure.



## 

