# 🚀 Déploiement - Sondage Cotisation Nelal Express

Guide complet pour déployer le sondage avec backend Supabase.

---

## 📋 Prérequis

- Un compte [Supabase](https://supabase.com) (gratuit)
- Un compte [Netlify](https://netlify.com) ou [Vercel](https://vercel.com) (gratuit)
- Le fichier `index.html` fourni

---

## 🔧 Étape 1 : Configuration Supabase

### 1.1 Créer un projet
1. Connectez-vous à [Supabase](https://supabase.com)
2. Cliquez sur "New Project"
3. Nommez votre projet (ex: `nelal-sondage`)
4. Choisissez une région (Europe de l'Ouest recommandée)
5. Attendez la fin de l'initialisation (~2 minutes)

### 1.2 Créer la table
1. Dans le projet, allez dans **SQL Editor** (icône </>)
2. Cliquez sur **"New query"**
3. Copiez-collez le contenu du fichier `supabase_setup.sql`
4. Cliquez sur **"Run"**

### 1.3 Activer Realtime (Temps réel)
1. Allez dans **Database** → **Replication** → **Realtime**
2. Cochez la table **"votes"**
3. Cliquez sur **"Apply"**

### 1.4 Récupérer les identifiants
1. Allez dans **Project Settings** (icône ⚙️)
2. Cliquez sur **"API"** dans le menu latéral
3. Notez :
   - **URL** : `https://xxxxxxxxxxxx.supabase.co`
   - **anon/public** : `eyJhbG...` (clé publique)

---

## 💻 Étape 2 : Configuration du Frontend

### 2.1 Modifier les constantes
Ouvrez `index.html` et remplacez les valeurs dans la section **CONFIGURATION SUPABASE** (lignes ~580-585) :

```javascript
const SUPABASE_URL = 'https://votre-projet.supabase.co';        // ← Remplacez
const SUPABASE_ANON_KEY = 'votre-cle-anon-publique';            // ← Remplacez
const APP_URL = 'https://nelal-sondage.netlify.app';            // ← Remplacez après déploiement
```

### 2.2 Tester localement (optionnel)
Ouvrez `index.html` dans votre navigateur avec Live Server ou directement :
```bash
# Avec Python
python -m http.server 8000

# Avec Node.js (npx)
npx serve .
```
Accédez à `http://localhost:8000`

---

## 🌐 Étape 3 : Déploiement sur Netlify

### Méthode 1 : Drag & Drop (Recommandée)
1. Compressez le dossier contenant `index.html` en **ZIP**
2. Connectez-vous à [Netlify](https://netlify.com)
3. Faites glisser le fichier ZIP sur la page d'accueil
4. Attendez le déploiement (~30 secondes)
5. Votre URL est affichée (ex: `https://nelal-sondage-abc123.netlify.app`)

### Méthode 2 : Git (pour mises à jour faciles)
1. Créez un dépôt GitHub avec `index.html`
2. Sur Netlify, cliquez sur **"Add new site"** → **"Import an existing project"**
3. Choisissez GitHub et votre dépôt
4. Laissez les paramètres par défaut (publish directory: `/`)
5. Cliquez sur **"Deploy site"**

### Personnaliser le nom de domaine
1. Sur Netlify, allez dans **Site settings** → **Domain management**
2. Cliquez sur **"Options"** → **"Edit site name"**
3. Choisissez un nom personnalisé (ex: `nelal-sondage`)

---

## 🌐 Étape 3 bis : Déploiement sur Vercel

### Méthode rapide
1. Connectez-vous à [Vercel](https://vercel.com)
2. Cliquez sur **"Add New Project"**
3. Importez depuis GitHub ou faites **"Upload"** du dossier
4. Laissez tous les paramètres par défaut
5. Cliquez sur **"Deploy"**

---

## ✅ Étape 4 : Vérification

1. **Ouvrez l'URL déployée** dans votre navigateur
2. **Vérifiez le statut** : le badge "Connexion..." doit devenir "En direct"
3. **Testez un vote** :
   - Sélectionnez un montant
   - Ajoutez un prénom (optionnel)
   - Cliquez sur "Valider"
4. **Vérifiez le temps réel** :
   - Ouvrez l'app dans un autre navigateur/naviguation privée
   - Votez avec un autre montant
   - Les résultats doivent s'actualiser instantanément dans les deux fenêtres

---

## 🔄 Mise à jour après déploiement

Si vous changez l'URL de l'application :

1. Modifiez `APP_URL` dans `index.html` :
```javascript
const APP_URL = 'https://votre-nouvelle-url.netlify.app';
```

2. Redéployez sur Netlify/Vercel

---

## 🛠️ Dépannage

### Problème : "Erreur de connexion à la base de données"
- Vérifiez que `SUPABASE_URL` et `SUPABASE_ANON_KEY` sont corrects
- Assurez-vous que le projet Supabase est actif

### Problème : "Tu as déjà voté !"
- L'identifiant utilisateur est stocké dans `localStorage`
- Pour tester avec un nouveau vote : ouvrez en navigation privée ou effacez les données de navigation

### Problème : Les résultats ne s'actualisent pas en temps réel
- Vérifiez que Realtime est activé sur la table `votes` dans Supabase
- Ouvrez la console développeur (F12) → onglet Console pour voir les erreurs

---

## 📁 Fichiers fournis

- `index.html` - Application complète (frontend + logique)
- `supabase_setup.sql` - Script de création de la base de données
- `DEPLOYMENT.md` - Ce fichier

---

## 🔒 Sécurité

- Les votes sont anonymes (seul un `user_id` généré côté client est stocké)
- Un seul vote par navigateur/appareil (contrainte d'unicité)
- Pas de données personnelles sensibles collectées
- La clé Supabase est publique (anon key) mais les permissions sont restrictives (RLS)

---

## 📞 Support

En cas de problème :
1. Vérifiez la console du navigateur (F12 → Console)
2. Vérifiez les logs Supabase (Database → Logs)
3. Consultez la [documentation Supabase](https://supabase.com/docs)
