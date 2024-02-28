# Terrarm | Provisioners

_______

Firstname : Carlin

Surname : FONGANG

Email : fongangcarlin@gmail.com

><img src="https://media.licdn.com/dms/image/C4E03AQEUnPkOFFTrWQ/profile-displayphoto-shrink_400_400/0/1618084678051?e=1710979200&v=beta&t=sMjRKoI0WFlbqYYgN0TWVobs9k31DBeSiOffAOM8HAo" width="50" height="50" alt="Carlin Fongang"> 
>
>[LinkedIn](https://www.linkedin.com/in/carlinfongang/) | [GitLab](https://gitlab.com/carlinfongang) | [GitHub](https://githut.com/carlinfongang) | [Credly](https://www.credly.com/users/carlin-fongang/badges)

_______

## Contexte
Dans ce lab, nous allons mettre en oeuvre l'utilisation des modules dans un cas pratique.

Les modules sous Terraform sont des éléments essentiels permettant d'organiser et de réutiliser du code d'infrastructure. Ils regroupent des ressources Terraform liées par une fonctionnalité ou un objectif commun, offrant ainsi une abstraction et une modularité accrues. Les modules peuvent être composés de ressources, de variables, de sorties et d'autres éléments Terraform. Ils permettent de définir une interface claire et cohérente pour la configuration et le déploiement de l'infrastructure, ce qui facilite la gestion et la maintenance à grande échelle. Les modules favorisent également la réutilisation du code, réduisant ainsi la duplication et accélérant le processus de développement. En résumé, les modules Terraform sont des composants modulaires et réutilisables qui simplifient la gestion de l'infrastructure en permettant une organisation efficace et une abstraction cohérente des ressources.

## Plan d'exécution
Dans ce lab, il faudra :

1. Créer un module "ec2-module" afin de déployer une instance avec les ressources suivantes :
  - EC2
  - Security Group
  - EIP

2. Ensuite, créer deux dossiers, "prod" et "dev", chacun contenant un fichier Terraform (main.tf) utilisant le module "ec2-module" créé pour déployer une instance. Utiliser respectivement le type "t3.medium" pour la prod et "t2.micro" pour la dev.

3. Surcharger les tags de chaque environnement afin d'avoir respectivement "ec2-prod-<prefix>" pour la prod et "ec2-dev-<prefixe>" pour la dev.

4. Lancer la création des instances EC2 de dev et prod.

5. Une fois les instances provisionnées et Nginx fonctionnel, supprimer l'infrastructure.


