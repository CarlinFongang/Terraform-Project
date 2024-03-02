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

1. **Création d'une Instance EC2 :** Nous allons écrire un module Terraform pour créer une instance EC2 utilisant  **ubuntu-jammy-22.04**. Ce module permettra de spécifier le type d'instance et le tag (nom) comme variables pour une personnalisation flexible.__

2. **Création d'un Volume EBS :** Un autre module sera développé pour créer un volume EBS avec une taille variable, offrant ainsi une gestion efficace du stockage pour notre application.__

3. **Attribution d'une Adresse IP Publique :** Nous allons définir un module pour une adresse IP publique qui sera attachée au groupe de sécurité, assurant une connectivité externe à notre application.__

4. **Configuration d'un Groupe de Sécurité :** Un autre module sera dédié à la création d'un groupe de sécurité, permettant l'ouverture des ports 80 et 443 pour le trafic web.__

5. **Déploiement de l'Application :** Nous allons organiser ces modules dans un dossier "modules" pour simplifier le déploiement de notre application. Nous personnaliserons les variables pour rendre le processus de déploiement plus dynamique et adaptable.

6. **Sécurisation des acces et secret key :** Pour le déploiement en environnement de production, nous allons sécuriser nos key pair connexion afin d'éviter tout exposition.

7. **Installation de Nginx :** Enfin, nous allons intégrer l'installation de Nginx à la fin du déploiement en le configurant comme rôle de l'instance EC2.

8. **Enregistrement de l'Adresse IP Publique :** Pour une gestion pratique, nous enregistrerons l'adresse IP publique dans un fichier nommé "ip_ec2.txt" pour une référence ultérieure.


## Prerequis 
1. [Créer un compte aws](https://gitlab.com/CarlinFongang-Labs/Terraform/lab0-sigup-aws)
2. [Installer terraform](https://gitlab.com/CarlinFongang-Labs/Terraform/lab1-intall-terraform)
3. [Configurer le provider aws afin d'y effectuer des deploiement](https://gitlab.com/CarlinFongang-Labs/Terraform/lab1-intall-terraform)

## Définition de l'architecture du l'IaC
Voici une représentation imagé de l'organisation de notre code d'infra à la fin de la création des différents modules
>![alt text](img/image-1.png)


## Création des modules
Pour débuter la création des modules sous Terraform, nous allons créer un dossier projet nommé **terraform-project** dans lequel l'ensemble des modules, ainsi que tout le code Terraform, sera stocké.

Dans ce dossier principal, nous allons créer le dossier **modules** qui va contenir l'ensemble des modules **ec2-module**, **ebs-module**, **eip-module** et **sg-module** qui vont être décrits dans la suite de cette procédure.

L'on obtiendra alors le résultat ci-dessous :
>![alt text](img/image-2.png)

### 1. Module "ec2-module"
L'utilisation d'instances EC2 comme module dans Terraform permet une gestion automatisée et reproductible des ressources de calcul dans le cloud AWS. Cela facilite le déploiement rapide d'environnements et assure une configuration cohérente, améliorant l'efficacité et réduisant les erreurs manuelles. Pour configurer ce module, nous allons :

Rajouter le dossier **ec2-module** dans le dossier **modules**

````bash
cd terraform-project/modules
mkdir ec2-module
cd ec2-module
````

Une fois dans le dossier **ec2-module**, on va créer 3 fichiers

````bash
touch main.tf variables.tf outputs.tf
````

### 1.1. Description de "variables.tf"

Dans le module EC2, trois variables sont définies pour configurer les instances EC2 sur AWS :

1. `instance_type` détermine le type de l'instance EC2 (par exemple, "t2.nano"), le type d'instance correspond à une performance spécifique et à un modèle de facturation égal; plus elle est performante, plus elle sera chère. Pour la valeur par défaut, nous avons opté pour la **t2.nano** pour de petits déploiements.

2. `aws_ec2_tag` est utilisé pour attribuer des étiquettes (tags) aux ressources, facilitant leur identification et leur gestion. Ici, le tag `Name` est défini avec la valeur **"ec2-aCD"** par défaut et sera utilisé si cette variable n'est pas surchargée.

3. `sg_att_id` représente l'identifiant du groupe de sécurité (security group) associé à l'instance, utilisé pour définir les règles de réseau qui contrôlent le trafic vers et depuis l'instance. Dans ce cas spécifique, le **security group** constituera également un autre module, nous verrons plus loin comment récupérer l'ID de celui-ci pour le renseigner dans cette variable appelée dans le module **ec2-module**.

````bash
#ec2-module variables
variable "instance_type" {
  type        = string
  description = "Définit le type d'instance AWS"
  default     = "t2.nano"
}



variable "aws_ec2_tag" {
  type        = map(any)
  description = "Étiquette commune pour les ressources"
  default = {
    Name = "ec2-aCD"
  }
}

variable "sg_att_id" {
  type = string
  description = "ID du groupe de sécurité"
}

````
*Contenu du fichier **variables.tf***

Une fois les variables déclarées, nous allons passer à la définition du **main.tf**

### 1.2. Description de "main.tf"
Dans ce code Terraform, un modèle Amazon Machine Image (AMI) est sélectionné pour créer une instance EC2 sur AWS. Le code spécifie l'utilisation de l'image AMI la plus récente d'Ubuntu 22.04 (Jammy Jellyfish) fournie par Amazon. Ensuite, il configure une instance EC2 en utilisant cette image AMI, avec des paramètres tels que le type d'instance, une clé SSH pour l'accès, et des étiquettes personnalisées fournies par les variables. Le groupe de sécurité associé est également spécifié pour contrôler l'accès réseau à l'instance. Enfin, un script d'installation, `app_install.sh`, est exécuté sur l'instance via SSH après son lancement pour installer et configurer des applications supplémentaires, en utilisant la clé privée spécifiée pour l'authentification.

````bash
#Sélection de la version la plus récente d'Ubuntu 22.04. Filtre spécifiquement les AMIs fournies par Amazon, garantissant ainsi que l'instance EC2 utilisera une image fiable et à jour.

data "aws_ami" "ami_name" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }
}

#Ce code déploie une instance AWS EC2 en utilisant l'image AMI décrite plus haut. Installe des applications sur l'instance via SSH en utilisant le script `app_install.sh`.

resource "aws_instance" "ec2_ressource" {
  ami             = data.aws_ami.ami_name.id
  instance_type   = var.instance_type
  key_name        = "devops-aCD"
  tags            = var.aws_ec2_tag
  vpc_security_group_ids = [var.sg_att_id]

  provisioner "remote-exec" {
    script = "../app_install.sh"
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/Kusuka.fr/OneDrive - data5tb/Formations/BootCamp DevOps 17/cursus-devops/Terraform/terraform-project/secret/devops-aCD.pem")
    host = self.public_ip
    }
  }
}
````
*Contenu du fichier **main.tf***

#### Description du "app_install.sh"
Le fichier bash **app_install.sh** est créé à la racine du projet **terraform-project** et contient le script d'installation du serveur nginx, de Docker et de Git.

### 1.3. Description de "outputs.tf"
Le fichier `outputs.tf` dans Terraform sert à extraire des informations importantes de l'infrastructure déployée, comme l'ID de l'instance en cours d'exécution ou encore sa zone de disponibilité, facilitant ainsi leur utilisation et référence ultérieures.

Dans ce cas spécifique, nous aurons besoin plus loin de l'ID et de la zone de disponibilité que nous appellerons ici respectivement **"ec2_id_output"** et **"ec2_az_output"**.

````bash
#ec2-module outputs
output "ec2_id_output" {
  value = aws_instance.ec2_ressource.id
}

output "ec2_az_output" {
  value = aws_instance.ec2_ressource.availability_zone
}
````
*Contenu du fichier **outputs.tf***

### 2. Module "ebs-module"
Un Elastic Block Store (EBS) d'Amazon Web Services (AWS) est un système de stockage de volumes persistant, conçu pour une utilisation avec les instances EC2. Il offre des performances de stockage hautement disponibles et fiables pour les applications nécessitant des accès fréquents et rapides aux données.

Dans notre infrastructure (IaC) via Terraform, intégrer EBS comme module permet une gestion et une automatisation cohérentes de ces volumes de stockage, assurant que les ressources sont provisionnées de manière répétable et sans erreur humaine, simplifiant ainsi les déploiements et la maintenance.

Pour configurer ce module, nous allons :

Rajouter le dossier **ebs-module** dans le dossier **modules**

````bash
mkdir ebs-module
cd ebs-module
````

Une fois dans le dossier **ebs-module**, on va créer 2 fichiers

````bash
touch main.tf variables.tf
````

### 2.1. Description de "variables.tf"
Ce manifeste Terraform définit les variables pour configurer un volume EBS (Elastic Block Store) dans AWS. Il spécifie la zone de disponibilité (`az_ebs`), la taille (`size_ebs`), le type (`type_ebs`, avec une valeur par défaut 'gp2'), le nom (`name_ebs`), et l'identifiant de l'instance EC2 (`ec2_id_ebs`) auquel le volume sera attaché, ainsi que le nom du périphérique (`device_name_ebs`) utilisé pour l'attacher à l'instance. Ce manifeste sert de modèle pour personnaliser les propriétés des volumes EBS lors de leur création et de leur montage sur des instances EC2.

````bash
#ebs-module variables
variable "az_ebs" {
  description = "The AZ where the EBS volume will exist"
}

variable "size_ebs" {
  description = "The size of the EBS volume"
}

variable "type_ebs" {
  description = "The type of EBS volume"
  default     = "gp2"
}

variable "name_ebs" {
  description = "The name of the EBS volume"
}

variable "ec2_id_ebs" {
  description = "The ID of the EC2 instance to attach"
}

variable "device_name_ebs" {
  description = "The device name to attach the EBS volume to"
}
````
**Contenu du fichier **variables.tf***


### 2.2. Description de "main.tf"

Ce fichier définit deux ressources pour travailler avec AWS EBS (Elastic Block Store).

1. La première ressource, `aws_ebs_volume`, crée un nouveau volume EBS dans une zone de disponibilité spécifique, avec une taille et un type définis, et lui attribue un nom à travers les tags.

2. La seconde ressource, `aws_volume_attachment`, attache ce volume EBS à une instance EC2 spécifique, utilisant un nom de périphérique donné. L'option `force_detach` permet de s'assurer que le volume peut être détaché de l'instance EC2 sans interaction manuelle lors de la destruction de la ressource.

````bash
#ebs-module

resource "aws_ebs_volume" "ebs_ressource" {
  availability_zone = var.az_ebs
  size              = var.size_ebs
  type              = var.type_ebs

  tags = {
    Name = var.name_ebs
  }
}

resource "aws_volume_attachment" "ebs_attach_ressource" {
  device_name = var.device_name_ebs
  volume_id   = aws_ebs_volume.ebs_ressource.id
  instance_id = var.ec2_id_ebs
  force_detach = true
}
````

### 3. Module "eip-module"
Un Elastic IP (EIP) est une adresse IP statique offerte par AWS pour une gestion dynamique des adresses internet.

Dans notre cas, avec Terraform, utiliser un EIP comme module permet d'attribuer une adresse IP fixe et publique aux ressources cloud, notamment nos instances EC2, garantissant ainsi une connectivité réseau fiable et facilement identifiable. Cela facilite les scénarios où une adresse IP constante est nécessaire, comme pour les serveurs web

 ou les systèmes nécessitant un accès externe constant comme **Ansible**, par exemple. Le module **"eip-module"** assure que la configuration est reproductible et intégrée dans le cycle de vie global de l'infrastructure cloud.

Pour configurer ce module, nous allons :

Rajouter le dossier **eip-module** dans le dossier **modules**

````bash
mkdir eip-module
cd eip-module
````

Une fois dans le dossier **eip-module**, on va créer 3 fichiers

````bash
touch main.tf variables.tf outputs.tf
````

### 3.1. Description de "variables.tf"
Ce fichier Terraform définit deux variables pour la configuration d'une infrastructure cloud.

1. La première variable, `ec2_id`, stocke l'identifiant d'une instance EC2 (un serveur virtuel dans AWS), ce qui permet de référencer cette instance spécifique pour différentes opérations.

2. La seconde variable, `eip_name`, représente le nom attribué à une adresse IP élastique (EIP), servant à identifier de manière unique cette ressource pour une gestion plus aisée. Ces variables sont utilisées pour personnaliser et relier les ressources dans le cadre de déploiements cloud automatisés.

````bash
variable "ec2_id" {
  description = "The ID of the EC2 instance running"
}

variable "eip_name" {
  description = "The name tag of the EIP"
}
````
*Contenu du fichier **variables.tf***

### 3.2. Description de "main.tf"

Ce code crée une adresse IP élastique (EIP) sur AWS, qui sera attribuée à l'instance EC2, représentée ici par `var.ec2_id`. La variable **ec2_id** est surchargée plus tard lors de l'appel de la ressource par la valeur de l'ID issu de l'output (**ec2_id_output**) du module **ec2-module**.

Cette EIP permet à l'instance de communiquer avec l'extérieur du réseau privé virtuel (VPC). En plus, l'EIP est étiquetée avec un nom, `var.eip_name`, pour faciliter son identification et sa gestion dans AWS.

````bash
#ec2-module outputs
output "ec2_id_output" {
  value = aws_instance.ec2_ressource.id
}

output "ec2_az_output" {
  value = aws_instance.ec2_ressource.availability_zone
}
````
*Contenu du fichier **main.tf***

### 3.2. Description de "outputs.tf"

Ce code définit des sorties pour une ressource d'adresse IP élastique (EIP) créée sur AWS.

1. La première sortie, `eip_output`, renvoie l'adresse IP publique de l'EIP, permettant ainsi de connaître l'adresse externe attribuée à une instance EC2.

2. La seconde sortie, `eip_name_output`, renvoie les tags (étiquettes) associés à cette EIP, y compris le nom donné à l'EIP.

Ces informations de sortie seront utilisées pour référencer l'adresse IP et les tags de l'EIP dans les environnements de provisionnement dev et prod.

````bash
output "eip_output" {
  value = aws_eip.eip_ressource.public_ip
}

output "eip_name_output" {
  value = aws_eip.eip_ressource.tags
}
````
*Contenu du **outputs.tf***


#### 4.2. Provisionnement de l'environnement de dev.
1. Initialisation de Terraform et téléchargement des plugins
````bash
cd terraform-project/dev
terraform init
````

Sortie console 
>![alt text](img/image-3.png)
*Sortie console après un **terraform init***

2. Vérification de la cohérence de l'IaC
````bash
terraform validate
````

Sortie console 
>![alt text](img/image-4.png)
*Sortie console après **terraform validate***

3. Planification des ressources
````bash
terraform plan
````

Sortie console 
>![alt text](img/image-5.png)
*Sortie console après **terraform plan***

4. Provisionnement de l'infrastructure
````bash
terraform apply
````

Sortie console 
>![alt text](img/image-6.png)
*Connexion à l'instance provisionnée*

>![alt text](img/image-7.png)
*Fin du provisionnement*


5. Rendu/Résultat du provisionnement 

L'instance a bien été créée avec les caractéristiques attendues : **t2.micro**, **key pair** défini, **AMI** défini et autres.
>![alt text](img/image-8.png)
*EC2 en cours d'exécution*

Le stockage de type **EBS** de 8.0 Go a bien été créé.
>![alt text](img/image-9.png)

L'EIP avec le tag **dev-aCD-eip** a bien été créé.
>![alt text](img/image-10.png)

Le backend de collaboration **dev-acd.tfstates** a bien été créé.
>![alt text](img/image-11.png)

6. Test de Nginx depuis un navigateur

On peut voir que Nginx est bien accessible via l'EIP public.

>![alt text](img/image-12.png)
*Serveur web Nginx*

7. Contrôle des apps installées sur l'instance
Une fois connecté au serveur via la commande 
````bash
ssh -i devops-aCD.pem ubuntu@<public_ip>
nginx -v && docker version && git version
````
>![alt text](img/image-13.png)
*Les apps Nginx, Docker et Git sont bien installées*


#### 4.3. Description de l'IaC pour l'environnement de production.
Pour le déploiement en production, nous allons reproduire le contenu du répertoire **terraform-project/dev**, le contenu sera copié vers **terraform-project/prod** et nous y apporterons des ajustements propres à l'environnement de prod : 

1. La sécurité
Pour des raisons de bonne pratique, exportez les access key et secret key dans des variables d'environnement afin de ne plus avoir ces identifiants d'authentification en clair dans notre code.

Se placer dans le répertoire de production après avoir copié le main de la **dev** vers **prod**
````bash 
cd terraform-project/prod
export AWS_ACCESS_KEY_ID="AKIAYXE474GNA65A4LLN"
export AWS_SECRET_ACCESS_KEY="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"
````
Une fois les commandes entrées, il n'y a aucune sortie sur le terminal, ce qui signifie que l'export s'est bien déroulé.

On va ensuite supprimer les access et secret key écrits en clair dans le manifest, on obtient : 

````bash
provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "backend-acd-1"
    key = "dev-acd.tfstates"
    region = "us-east-1" 
  }
}
````
Terraform ira chercher automatiquement les informations d'authentification dans les variables d'environnement exportées plus haut.

2. Modification des tags vers **prod-aCD-<préfixe>**
Dans l'ensemble du **main.tf** dans le dossier de production, nous allons renseigner les tags correspondant à la production afin d'identifier plus aisément les ressources liées à la production sur AWS.

On obtient le code ci-dessous :

````bash
provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "backend-acd-1"
    key    = "prod-acd.tfstates"
    region = "us-east-1"
  }
}

module "ec2_instance" {
  source        = "../modules/ec2-module"
  instance_type = "t3.medium"
  sg_att_id     = module.sg.output_sg_id
  aws_ec2_tag   = {
    Name = "prod-aCD-ec2"
  }
}

module "ebs_volume" {
  source       = "../modules/ebs-module"
  az_ebs       = module.ec2_instance.ec2_az_output
  size_ebs     = 8.0
  type_ebs     = "gp2"
  name_ebs     = "prod-aCD-ebs"
  ec2_id_ebs   = module.ec2_instance.ec2_id_output
  device_name_ebs = "/dev/sdf"
}

module "eip_address" {
  source = "../modules/eip-module"
  eip_name = "prod-aCD-eip"
  ec2_id   = module.ec2_instance.ec2_id_output
}

resource "null_resource" "export_info" {
    provisioner "local-exec" {
    command = "echo PUBLIC IP : ${module.eip_address.eip_output}; ID: ${module.ec2_instance.ec2_id_output}; AZ: ${module.ec2_instance.ec2_az_output} > info_prod_aCD.txt"
  }  
}

module "sg" {
  source = "../modules/sg-module"
  name_sg = "prod-aCD-sg"
}
````

#### 4.4. Provisionnement de l'environnement de prod.
1. Initialisation de Terraform et téléchargement des plugins
````bash
terraform init
````

Sortie console
>![alt text](img/image-14.png)
*Sortie console après **terraform init***

2. Vérification de la cohérence de l'IaC
````bash
terraform validate
````

Sortie console
>![alt text](img/image-15.png)
*Sortie console après **terraform validate***

3. Planification des ressources
````bash
terraform plan
````

Sortie console
>![alt text](img/image-16.png)
*Sortie console après **terraform plan***

4. Provisionnement de l'infrastructure
````bash
terraform apply
````

Sortie console
>![alt text](img/image-17.png)
*Sortie console après **terraform apply***

5. Rendu/Résultat du provisionnement
>![alt text](img/image-18.png)
*Instance de prod en cours*

>![alt text](img/image-19.png)
*Stockage EBS provisionné*

6. Test de Nginx depuis un navigateur
>![alt text](img/image-20.png)
*Réponse du serveur web Nginx*

7. Vérification des versions des apps installées sur l'instance
Une fois connecté à l'instance de prod via SSH

````bash
ssh -i devops-aCD.pem ubuntu@<public_ip>
nginx -v && docker version && git version
````

>![alt text](img/image-21.png)
*Versions installées des apps Nginx, Docker et Git*

## Conclusion
Nous avons pu mettre en place une IaC grâce à Terraform, qui est l'un des outils par excellence pour ce type de tâche. Les ressources que nous avons pu déployer nous ont permis d'exploiter la notion de **module** avec les **outputs** ainsi que les dépendances explicites, afin de rendre ce code réutilisable pour tout autre projet nécessitant une infrastructure similaire. À noter qu'il est possible de réaliser des infrastructures plus complexes, à haute disponibilité et résilientes avec Terraform.