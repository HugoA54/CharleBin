# Comptes-rendus de GitHub, ressource R4.02 - Qualité de développement

## Séance 2 - Processus de PR et de review

### Transparent 5

Mes manipulations :

- J'ai mis en place une clé SSH publique sur GitHub pour éviter de taper mon mot de passe à chaque push
- J'ai activé un ssh-agent en suivant la documentation officielle
- J'ai créé un repository sur GitHub nommé "CharleBin"
- J'ai branché mon repository local PrivateBin à ce nouveau repository distant

Voici les commandes utilisées :

```bash
git remote set-url origin git@github.com:HugoA54/CharleBin.git
git push -u origin main
```

### Transparent 9

Mes manipulations :

- J'ai modifié le titre de la page web de PrivateBin vers CharleBin via l'interface GitHub
- J'ai édité le fichier `lib/Configuration.php` directement sur GitHub
- J'ai constaté que le changement n'était pas présent dans mon repository local
- J'ai rapatrié les modifications avec la commande suivante :

```bash
git fetch origin
git pull origin main
```


### Transparent 14

Mes manipulations :

- Je me suis assuré d'être sur la branche main avec `git status`
- J'ai créé une nouvelle branche pour supprimer le footer de PrivateBin

```bash
git switch -C remove-footer
```

- J'ai supprimé le footer dans les fichiers concernés et créé des commits
- J'ai poussé la branche sur GitHub :

```bash
git push -u origin remove-footer
```

- J'ai créé une pull request sur GitHub via l'interface web (sans la merger comme demandé)
- La PR contenait les modifications pour supprimer le texte du footer "PrivateBin - Vivons heureux, vivons cachés" et la description du projet

### Transparent 23

Mes manipulations :

- J'ai créé un fichier `README.md` à la racine du projet avec :
  - Le nom du projet : CharleBin
  - Ce que fais le projet
  - Les pré-requis 
  - Les instructions d'installation en local
  - Les instructions de développement
  - Les instructions de déploiement

- J'ai créé un fichier `.github/CONTRIBUTING.md` qui explique :
    - Les règles générales 
    - Flux de travail
    - Modèle de PR
    - Convention de commits


- J'ai créé un template de PR dans `.github/pull_request_template.md` :

Exemple de template de PR :

```markdown
## Contexte
Expliquez brièvement pourquoi ce changement est nécessaire.

## Modifications proposées
Décrivez ce que change cette PR 

## Comment tester localement
Indiquez les commandes à exécuter pour vérifier les changements 

## Issues liées
Référencez les issues liées 

## Checklist
- [ ] Les tests unitaires passent
- [ ] La documentation a été mise à jour si nécessaire
- [ ] Des commits clairs

## Notes supplémentaires
Ajoutez ici toute information pertinente (migration de base, impact infra, rollback, etc.).
```
