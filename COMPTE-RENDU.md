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


## Séance 3 - Linters et automatisation

### Exercice #1 - Installation et configuration des linters

Mes manipulations :

J'ai testé PHP Lint sur un fichier :

```bash
php -l lib/Configuration.php
```

Pour tester tous les fichiers PHP du projet :

```bash
find . -type f -name '*.php' -exec php -l {} \;
```

**2. Installation de PHP Code Sniffer**

J'ai d'abord installé l'extension PHP nécessaire :

```bash
sudo apt install php-xmlwriter
```

Puis j'ai installé PHP Code Sniffer via Composer :

```bash
composer require --dev "squizlabs/php_codesniffer=3.*"
```

J'ai testé l'outil sur le projet :

```bash
./vendor/bin/phpcs --extensions=php ./lib/
```

**3. Installation de PHP Mess Detector**

```bash
composer require --dev "phpmd/phpmd=@stable"
```

J'ai testé PHPMD avec différentes règles :

```bash
./vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
```

**4. Configuration des linters**

J'ai créé un fichier de configuration pour PHP Code Sniffer si nécessaire, et j'ai ajusté les règles selon mes besoins (par exemple, ignorer certains warnings ou ajuster les seuils de complexité).

**5. Création d'une target `make lint` dans le Makefile**

J'ai ajouté cette target dans le `Makefile` :

```makefile
lint:
        $ find . -type f -name '*.php' -exec php -l {} \;
        ./vendor/bin/phpcs --extensions=php ./lib/
        ./vendor/bin/phpmd ./lib ansi codesize,unusedcode,naming
```

J'ai testé la commande :

```bash
make lint
```

**6. Correction de 5+ erreurs**

J'ai corrigé au moins 5 erreurs :



**Ligne 26** : Doc comment short description must start with a capital letter

**AVANT :**
```php
/**
 * parsed configuration
 */
```

**APRÈS :**
```php
/**
 * Parsed configuration
 */
```



---

**Ligne 33** : Doc comment short description must start with a capital letter

**AVANT :**
```php
/**
 * default configuration
 *
 * @var array
 */
```

**APRÈS :**
```php
/**
 * Default configuration
 *
 * @var array
 */
```

---


**Ligne 104** : Doc comment short description must start with a capital letter

**AVANT :**
```php
/**
 * parse configuration file and ensure default configuration values are present
 *
 * @throws Exception
 */
```

**APRÈS :**
```php
/**
 * Parse configuration file and ensure default configuration values are present
 *
 * @throws Exception
 */
```

---



**Ligne 246** : Doc comment short description must start with a capital letter

**AVANT :**
```php
/**
 * get configuration as array
 *
 * @return array
 */
```

**APRÈS :**
```php
/**
 * Get configuration as array
 *
 * @return array
 */
```


---

**Ligne 256** : Doc comment short description must start with a capital letter

**AVANT :**
```php
/**
 * get default configuration as array
 *
 * @return array
 */
```

**APRÈS :**
```php
/**
 * Get default configuration as array
 *
 * @return array
 */
```




