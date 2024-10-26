# POC OCR-IBAN

## Overview

Ce projet est un test technique devant répondre, le nom du projet s'appelle Banane... (j'ai souhaité garder l'historique des commits)

### Spécifications techniques :

- Développer les écrans en utilisant Swift ✅
- Utilisation d'une architecture au choix (MVVM + Clean Architecture) ✅
- Gestion de l'IBAN français ✅
- Pas de gestion de la tabBar ✅

### Spécifications fonctionnelles :

- Ajout d'un nouveau bénéficiaire en scannant un IBAN ✅ (utilisation de CoreData pour la base de données)
- Créer un écran "Ajouter un bénéficiaire" ✅
- Appuyer sur le bouton "Scan" ouvre la caméra ✅
- La détection d'un IBAN ouvre une feuille (sheet) pour confirmer la validation ✅
- Appuyer sur le bouton "Valider" affiche à nouveau la vue "Ajout d'un nouveau bénéficiaire" en remplissant l'IBAN ✅
- Appuyer sur le bouton "Recommencer" fait disparaître la feuille pour rescanner un IBAN ✅

### Bonus :

- Ajout d'un écran "Liste des bénéficiaires" qui liste tous les bénéficiaires enregistrés via CoreData ✅
- L'ajout d'un bénéficiaire est validé dans l'écran "Ajout d'un nouveau bénéficiaire" en appuyant sur le bouton "Valider" ✅
- Gestion des erreurs avec une alerte lors de l'utilisation des cas d'usage (use cases) pour créer un bénéficiaire ou configurer la caméra ✅
- Ajout de la localisation en français ✅
- Ajout de l'accessibilité avec VoiceOver ✅
- Ajout de la prise en charge des tailles de texte dynamiques (Dynamic Type) ❌
- Ajout de tests unitaires pour les cas d'usage ✅ (avec Testing !)
- Gestion de l'IBAN allemand ✅ (itération facile, il suffit d'ajouter une regex pour chaque pays souhaité)

## Requirements

- Xcode 16 or later
- iOS 16+
- Swift 5.7+ (pas de task, ni d'actor)
- SwiftUI
- CoreData

## Architecture
  
### Structure:

```bash
├── Domain
│   ├── Models
│   ├── UseCases
│   ├── Protocols
├── Data
│   ├── Repository
│   ├── Services
├── Presentation
│   ├── Views
│   ├── ViewModels
├── Tests
│   ├── UnitTests
```

## Usecases

- **Validate IBAN** gestion des iBAN FR et DE.
- **SetupCamera** Renvoie les objects nécéssaire pour le scanner, si indisponible renvoie une erreur.
- **CreateBeneficiary** Ajoute un bénéficiaire dans la table bénéficiare, en cas de doublons sur l'IBAN renvoie une erreur.

-----

Merci pour le temps passé sur la code review

Luc
