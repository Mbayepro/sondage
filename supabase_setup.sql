-- ═══════════════════════════════════════════════════════════
-- SCRIPT SQL POUR SUPABASE - Sondage Cotisation Nelal Express
-- ═══════════════════════════════════════════════════════════

-- 1. CRÉATION DE LA TABLE VOTES
-- ═══════════════════════════════════════════════════════════
CREATE TABLE votes (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id text NOT NULL,
    vote text NOT NULL CHECK (vote IN ('oui', 'non')),
    amount integer NOT NULL DEFAULT 0,
    name text,
    created_at timestamptz DEFAULT now()
);

-- 2. CONTRAINTE D'UNICITÉ (un seul vote par utilisateur)
-- ═══════════════════════════════════════════════════════════
ALTER TABLE votes ADD CONSTRAINT unique_user_id UNIQUE (user_id);

-- 3. INDEX POUR LES PERFORMANCES
-- ═══════════════════════════════════════════════════════════
CREATE INDEX idx_votes_user_id ON votes(user_id);
CREATE INDEX idx_votes_created_at ON votes(created_at DESC);
CREATE INDEX idx_votes_vote ON votes(vote);

-- 4. COMMENTAIRES SUR LES COLONNES
-- ═══════════════════════════════════════════════════════════
COMMENT ON TABLE votes IS 'Table des votes pour le sondage de cotisation Nelal Express';
COMMENT ON COLUMN votes.id IS 'Identifiant unique du vote (UUID)';
COMMENT ON COLUMN votes.user_id IS 'Identifiant anonyme unique par navigateur/appareil';
COMMENT ON COLUMN votes.vote IS 'Type de vote: oui (participation) ou non (refus)';
COMMENT ON COLUMN votes.amount IS 'Montant mensuel cotisé (0 si vote = non)';
COMMENT ON COLUMN votes.name IS 'Prénom optionnel du votant';
COMMENT ON COLUMN votes.created_at IS 'Date et heure du vote';

-- 5. ACTIVER REALTIME (à exécuter après création de la table)
-- ═══════════════════════════════════════════════════════════
-- Dans l'interface Supabase, allez dans :
-- Database → Replication → Realtime → Activer "votes"
-- 
-- OU exécutez cette requête dans l'éditeur SQL :
-- BEGIN;
--   -- Activer realtime pour la table
--   ALTER PUBLICATION supabase_realtime ADD TABLE votes;
-- COMMIT;

-- 6. POLITIQUES RLS (Row Level Security)
-- ═══════════════════════════════════════════════════════════

-- Activer RLS sur la table
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;

-- Politique : tout le monde peut lire tous les votes
CREATE POLICY "Tout le monde peut lire les votes" 
ON votes FOR SELECT 
TO anon, authenticated 
USING (true);

-- Politique : insertion autorisée pour tout le monde
-- avec vérification que user_id n'existe pas déjà (géré par la contrainte UNIQUE)
CREATE POLICY "Tout le monde peut voter une fois" 
ON votes FOR INSERT 
TO anon, authenticated 
WITH CHECK (true);

-- Pas de politique UPDATE ou DELETE (interdit publiquement)
-- Seuls les administrateurs (service_role) peuvent modifier/supprimer

-- 7. TRIGGER OPTIONNEL : Nettoyer les anciens votes (si besoin)
-- ═══════════════════════════════════════════════════════════
-- Créer une fonction pour supprimer les votes de plus de 1 an
CREATE OR REPLACE FUNCTION delete_old_votes()
RETURNS void AS $$
BEGIN
    DELETE FROM votes WHERE created_at < NOW() - INTERVAL '1 year';
END;
$$ LANGUAGE plpgsql;

-- ═══════════════════════════════════════════════════════════
-- FIN DU SCRIPT
-- ═══════════════════════════════════════════════════════════
