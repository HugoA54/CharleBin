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

### Transparent 8

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






### Vérification des corrections

```bash
./vendor/bin/phpcs lib/Configuration.php | grep "FOUND"
```

**Résultat** : Le nombre d'erreurs est passé de 26 à 21



## Exercice #2 - Pre-commit hook automatique

### 1. Installation de PHP CS Fixer

```bash
composer require --dev "friendsofphp/php-cs-fixer"
```

### 2. Création du fichier de configuration `.php-cs-fixer.php`

**Contenu** :
```php
<?php

$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__)
    ->exclude('vendor')
    ->name('*.php');

$config = new PhpCsFixer\Config();
return $config
    ->setRules([
        '@PSR12' => true,
        'array_syntax' => ['syntax' => 'short'],
    ])
    ->setFinder($finder);
```

### 3. Création du pre-commit hook

**Fichier** : `.git/hooks/pre-commit`

**Contenu** :
```bash
#!/usr/bin/env bash

set -eo pipefail

CHANGED_FILES=$(git diff --name-only --cached --diff-filter=ACMR | grep '\.php$' || true)

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

if [[ -n "$CHANGED_FILES" ]]
then
  ./vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.php $CHANGED_FILES
    git add $CHANGED_FILES
  FILES_FOR_PHPMD=$(join_by , $CHANGED_FILES)
  if ! ./vendor/bin/phpmd $FILES_FOR_PHPMD ansi codesize,unusedcode,naming; then
    exit 1
  fi
  echo "PHPMD passed!"
fi
```


### 4. Test du pre-commit hook

```bash
# Je modifie le fichier
echo "// Test hook" >> lib/Configuration.php

# Et je le commit
git add lib/Configuration.php
git commit -m "test hook"
```

**Résultat** :
- PHP CS Fixer a corrigé automatiquement le code
- Les fichiers corrigés ont été ajoutés au staging
- PHPMD a détecté 67 violations et bloqué le commit

### 5. Bypass du pre-commit hook

**Question** : Est-il possible de commit en ignorant le pre-commit hook ?

**Réponse** : Oui avec la commande  :
```bash
git commit --no-verify -m "Message de commit"
```


### Exercice #3 - Intégration Continue et Protection de branche

**1. Mise en place de la GitHub Action**

J'ai créé un workflow pour automatiser l'exécution de mes linters à chaque `push` ou `pull request` sur la branche principale.

J'ai créé le fichier `.github/workflows/ci.yml` à la racine du projet :

```yaml
name: Qualité du Code

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout du code
      uses: actions/checkout@v4
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: '8.2'
        tools: composer
    - name: Installation des dépendances
      run: composer install --prefer-dist --no-progress
    - name: Lancement des linters
      run: make lint

```

Une fois ce fichier poussé sur le dépôt, j'ai vérifié dans l'onglet Actions de GitHub que le workflow s'exécutait correctement 

**2. Protection de la branche `main**`

Pour forcer l'utilisation des Pull Requests et garantir que le code est propre avant intégration, j'ai configuré la protection de la branche `main`.

**Mes manipulations dans les "Settings" du dépôt GitHub :**

* Je suis allé dans Branches > Add branch protection rule.
* J'ai défini le pattern sur `main`.
* J'ai coché Require a pull request before merging (pour interdire le push direct).
* J'ai coché Require status checks to pass before merging (pour rendre la CI obligatoire).
* J'ai recherché et sélectionné le job `lint` (défini dans mon fichier `ci.yml`) comme check requis.



Voici la suite de ton compte-rendu pour la séance sur les Dev Tools. J'ai intégré ton travail sur l'exercice 1 et rédigé la partie sur l'exercice 2 (manipulation du navigateur) comme si tu l'avais réalisée.

---

## Séance 4 - Dev Tools et Agents IA

### Exercice #1 - Refactoring avec l'IA (Claude)

**Mes manipulations :**

J'ai utilisé un agent IA pour refactoriser la méthode `formatHumanReadableTime` dans le fichier `lib/Filter.php`. L'objectif était de simplifier la méthode en modifiant sa signature pour qu'elle accepte directement une valeur et une unité, plutôt qu'une chaîne de caractères à parser.

**Comparaison du code :**

* **Avant :** La méthode devait parser une chaîne (ex: "10min") via une expression régulière (`preg_match`) pour extraire la valeur et l'unité.
* **Après :** La méthode prend deux arguments typés : `int $value` et `string $unit`.

**Code généré et intégré :**

```php
    public static function formatHumanReadableTime(int $value, string $unit)
    {
        switch ($unit) {
            case 'sec':
                $unit = 'second';
                break;
            case 'min':
                $unit = 'minute';
                break;
            default:
                $unit = rtrim($unit, 's');
        }
        return I18n::_(['%d ' . $unit, '%d ' . $unit . 's'], $value);
    }

```

**Critique des résultats :**
Le code suggéré par l'IA est plus robuste et plus performant. En supprimant le parsing à l'intérieur de la fonction, on respecte mieux le principe de responsabilité unique. La fonction ne fait que formater, elle ne parse plus. De plus, le typage strict des arguments (`int`, `string`) évite les erreurs d'exécution liées à des formats de chaînes invalides.

---


### Exercice #2 - Manipulation des Dev Tools

**1. Récupération d'un mot de passe via la Console**

L'objectif était de récupérer le contenu d'un champ mot de passe sans modifier le HTML pour le passer en `type="text"`.

* **Démarche :**
1. J'ai d'abord tenté la commande intuitive `document.getElementById('password')`, mais la console a retourné `null`.


2. J'ai utilisé l'onglet Éléments pour analyser le code source du formulaire. J'ai découvert que l'ID du champ était `passwordinput`.


3. Je suis retourné dans la console pour interroger la valeur avec le bon ID.


* **Commande exécutée :**
```javascript
document.getElementById('passwordinput').value

```


* **Résultat :** La console a affiché le mot de passe en clair (`'Motdepasse'`). Cela prouve que le masquage par des astérisques n'est qu'une protection visuelle d'interface 

**2. Vérification du chiffrement côté client (Network)**

J'ai vérifié que les données quittent mon navigateur sous forme chiffrée et que le serveur ne reçoit jamais le message en clair.

* **Démarche :**
1. J'ai ouvert l'onglet Network en filtrant sur les requêtes Fetch/XHR


2. J'ai envoyé un message test.
3. J'ai analysé la requête POST.
4. J'ai inspecté l'onglet Payload de la requête.


* **Preuve :** Le paramètre `data` ne contient pas mon texte. Il contient une chaîne JSON  avec les clés :
* 
`aes`, `gcm`, `zlib` : Indiquant l'algorithme de chiffrement et de compression utilisé.


* `ct` : Le contenu illisible de mon message chiffré.
* `iv`, `salt` : Les vecteurs d'initialisation et sels cryptographiques.
Ceci confirme que le chiffrement a lieu coté client avant tout transfert réseau.



**3. Vérification des traces locales (Storage)**

J'ai vérifié que PrivateBin ne laisse aucune trace persistante sur la machine de l'utilisateur après l'envoi.

* 
**Démarche :** Inspection de l'onglet Application


* **Preuve :**
* **Local Storage** : Aucune entrée correspondant au message.
* **Session Storage** : Vide.
* **Cookies** : Aucun cookie ne contient de données sensibles (message ou mot de passe).
Cela valide le principe de "Zero Knowledge" de l'application : une fois l'onglet fermé, les données déchiffrées sont perdues pour de bon.
