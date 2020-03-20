DROP TABLE IF EXISTS citoyennete.cartepresidentielle2017toulouse ;


CREATE TABLE citoyennete.cartepresidentielle2017toulouse AS
SELECT a.id,
       departement,
       commune,
       TYPE,
       SUM(nb_inscrits)nb_inscrits,
          SUM(nb_bulletins)nb_bulletins,
             SUM(nb_emargements)nb_emargements,
                SUM(nb_exprimes)nb_exprimes,
                   SUM(nb_abstentions)nb_abstentions,
                      SUM(nb_blancs)nb_blancs,
                         SUM(nb_nuls)nb_nuls,
                            NULL::float AS pourcentage_participation,
                            numero_tour,
                            11::INTEGER AS nb_candidats,
                            candidat_1,
                            SUM(nb_voix_1)nb_voix_1,
                               candidat_2,
                               SUM(nb_voix_2)nb_voix_2,
                                  candidat_3,
                                  SUM(nb_voix_3)nb_voix_3,
                                     candidat_4,
                                     SUM(nb_voix_4)nb_voix_4,
                                        candidat_5,
                                        SUM(nb_voix_5)nb_voix_5,
                                           candidat_6,
                                           SUM(nb_voix_6)nb_voix_6,
                                              candidat_7,
                                              SUM(nb_voix_7)nb_voix_7,
                                                 candidat_8,
                                                 SUM(nb_voix_8)nb_voix_8,
                                                    'MELA'::varchar AS candidat_9,
                                                    SUM(candidat_9) AS nb_voix_9,
                                                    'ASSE'::varchar AS candidat_10,
                                                    SUM(candidat_10) AS nb_voix_10,
                                                    candidat_11,
                                                    SUM(nb_voix_11)nb_voix_11,
                                                       a.geom
FROM citoyennete.toulousemetropole_elections2017decoupagedesbureauxdevote a
LEFT JOIN citoyennete.toulousemetropole_election20171ertour b ON ST_CONTAINS (a.geom,
                                                                              b.geom)
GROUP BY a.id,
         departement,
         commune,
         TYPE,
         numero_tour,
         candidat_1,
         candidat_2,
         candidat_3,
         candidat_4,
         candidat_5,
         candidat_6,
         candidat_7,
         candidat_8,
         candidat_11 ;


ALTER TABLE citoyennete.cartepresidentielle2017toulouse ADD PRIMARY KEY (id);


CREATE INDEX cartepresidentielle2017toulouse_gix ON citoyennete.cartepresidentielle2017toulouse USING GIST (geom);


UPDATE citoyennete.cartepresidentielle2017toulouse
SET pourcentage_participation = COALESCE(((nb_bulletins*100)/nb_inscrits),0) RETURNING pourcentage_participation