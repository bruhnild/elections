
DROP TABLE IF EXISTS bv_update;


CREATE TABLE bv_update AS
SELECT id,
       geom,
       code AS codecom::varchar,
       nom AS nomcom,
       codedep::varchar,
       CASE
           WHEN nom = 'Caen' THEN (SUBSTR(REPLACE(bureau, '.', ''), 7,3))
           WHEN nom = 'Tours' THEN (SUBSTR(REPLACE(bureau, '-', ''), 7,3))
           ELSE (SUBSTR(bureau, 7,3))
       END ::integer AS codebureau,
       NULL::varchar AS nombureau,
       NULL::integer AS codecanton,
       NULL::varchar AS nomcanton,
       circo AS codecirco,
       NULL::varchar AS nomcirco,
       St_AREA(geom) surfbv,
              NULL::integer AS nbinscrits,
              NULL::integer AS annee,
              NULL::varchar AS SOURCE,
              NULL::varchar AS datemaj
FROM public.bv;


ALTER TABLE bv_update
ALTER COLUMN codebureau TYPE varchar USING (codebureau::varchar);


ALTER TABLE bv_update
ALTER COLUMN codecanton TYPE varchar USING (codecanton::varchar);


ALTER TABLE bv_update ADD COLUMN gid SERIAL PRIMARY KEY;


CREATE INDEX bv_update_gix ON bv_update USING GIST (geom);


INSERT INTO bv_update (id, geom,codecom, nomcom, codedep, codebureau, nombureau, nomcanton, surfbv,annee, SOURCE, datemaj)
SELECT id,
       St_Multi(geom) geom,
       code_insee,
       'Bayonne'::varchar AS nomcom,
       '64'::varchar AS codedep,
       numero,
       canton,
       lieu,
       St_AREA(geom) surfbv,
       2016::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/contours-des-bureaux-de-vote-bayonne/'::varchar AS SOURCE,
       date_de_sa
FROM bayonne;


INSERT INTO bv_update (id, geom, nomcom, codedep, codebureau, codecirco, datemaj, codecom, codecanton,nombureau, nomcanton, nbinscrits, surfbv, annee, SOURCE)
SELECT id,
       St_Multi(geom) geom,
       'Belfort'::varchar AS nomcom,
       '90'::varchar AS codedep,
       code_bureau,
       code_circonscription,
       date_maj,
       inseecom,
       code_canton,
       nom_bureau,
       nom_canton,
       inscrit,
       st_area(geom) surfbv,
       2019::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/perimetres-des-bureaux-de-vote-1/'::varchar AS SOURCE
FROM belfort;


INSERT INTO bv_update (id, geom,nomcom, codebureau, surfbv,annee, SOURCE)
SELECT id,
       St_Multi(geom) geom,
       'Besançon'::varchar AS nomcom,
       num_bureau,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/bureaux-de-vote-besancon/'::varchar AS SOURCE
FROM besancon;


INSERT INTO bv_update (id, geom,nomcom, codebureau, nombureau, surfbv,annee, SOURCE)
SELECT id,
       St_Multi(geom) geom,
       'Carpentras'::varchar AS nomcom,
       name,
       descriptio,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       'https://trouver.datasud.fr/dataset/bureaux-vote-84031'::varchar AS SOURCE
FROM carpentras;


INSERT INTO bv_update (id, geom,nomcom, nombureau, nbinscrits, surfbv,annee, SOURCE)
SELECT gid,
       St_Multi(geom) geom,
       'Chassieu'::varchar AS nomcom,
       nom,
       nombre_ele,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/secteur-des-bureaux-de-vote-de-la-commune-de-chassieu/'::varchar AS SOURCE
FROM chassieu;


INSERT INTO bv_update (id, geom,nomcom, nombureau, nomcanton, surfbv,annee, SOURCE)
SELECT id,
       St_Multi(geom) geom,
       'Digne-les-Bains'::varchar AS nomcom,
       name,
       description,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/bureaux-de-vote-a-digne-les-bains/'::varchar AS SOURCE
FROM dignelesbains;


INSERT INTO bv_update (id, geom,nomcom, nombureau,codebureau, surfbv,annee, SOURCE)
SELECT id,
       St_Multi(geom) geom,
       'Grenoble'::varchar AS nomcom,
       sdec_libel,
       sdec_num,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/les-bureaux-de-vote/'::varchar AS SOURCE
FROM grenoble;


INSERT INTO bv_update (id, geom,nomcom, nombureau,codebureau, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'La Rochelle'::varchar AS nomcom,
       ebc_nom,
       ebc_numero,
       St_AREA(geom) surfbv,
       2015::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/decoupage-electoral-bureaux-de-vote/'::varchar AS SOURCE
FROM larochelle;


INSERT INTO bv_update (id, geom,nomcom, nombureau,codebureau, codecanton, codecirco, surfbv,annee, SOURCE)
SELECT gid,
       St_Force2D(St_Multi(geom)) geom,
       'Le Havre'::varchar AS nomcom,
       lieu_de_vo,
       id_bureau,
       num_canton,
       num_circon,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/limites-des-bureaux-de-vote-du-havre/'::varchar AS SOURCE
FROM lehavre;


INSERT INTO bv_update (id, geom,codecom, nomcom, nombureau,codebureau, codecanton, codecirco, surfbv,annee, datemaj, SOURCE)
SELECT gid,
       St_Force2D(St_Multi(geom)) geom,
       code_insee,
       'Lorient'::varchar AS nomcom,
       nom,
       numero,
       canton,
       circonscri,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       date_der_m,
       'https://sdem.opendatasoft.com/explore/dataset/decoupage-bureau-de-vote-ville-de-lorient/export/'::varchar AS SOURCE
FROM lorient;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nomcanton, nomcirco, surfbv,annee, SOURCE)
SELECT gid,
       St_Force2D(St_Multi(geom)) geom,
       'Lyon'::varchar AS nomcom,
       num_bureau,
       canton,
       circonscri,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/contours-de-bureaux-de-vote-de-la-commune-de-lyon/'::varchar AS SOURCE
FROM lyon;


INSERT INTO bv_update (id, geom, nomcom, codecom, codebureau, nombureau, codecanton, codecirco, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Montpellier'::varchar AS nomcom,
       34175::integer AS codecom,
       bureau,
       nom_bureau,
       canton,
       circons,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://data.montpellier3m.fr/dataset/bureaux-de-vote-de-montpellier'::varchar AS SOURCE
FROM montpellier;


INSERT INTO bv_update (id, geom, nomcom, codecom, nombureau, codebureau,nomcanton,codecanton, codecirco, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Mulhouse'::varchar AS nomcom,
       code_insee,
       libelle,
       bureau_num,
       nom_canton,
       num_canton,
       num_circon,
       St_AREA(geom) surfbv,
       2015::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/perimetres-des-bureaux-de-vote-depuis-2015-sur-mulhouse/'::varchar AS SOURCE
FROM mulhouse;


INSERT INTO bv_update (id, geom, nomcom, nombureau, codebureau, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Nanterre'::varchar AS nomcom,
       nom_bureau,
       id_bureau_,
       St_AREA(geom) surfbv,
       2020::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/secteur-des-bureaux-de-vote-de-la-ville-de-nanterre/'::varchar AS SOURCE
FROM nanterre;


INSERT INTO bv_update (id, geom, nomcom,codecom, nombureau, codebureau, surfbv,annee, SOURCE)
SELECT gid,
       St_Force2D(St_Multi(geom)) geom,
       'Nantes'::varchar AS nomcom,
       codcom,
       concat(lieu_site, ' ', lieu_nom),
       idburo,
       St_AREA(geom) surfbv,
       2020::int AS annee,
       'https://data.nantesmetropole.fr/explore/dataset/244400404_decoupage-geographique-bureaux-vote-nantes/export/?disjunctive.lieu_nom&disjunctive.lieu_site'::varchar AS SOURCE
FROM nantes;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nbinscrits, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Paris'::varchar AS nomcom,
       num_bv,
       nbr_elect_f,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://opendata.paris.fr/explore/dataset/secteurs-des-bureaux-de-vote/information/?location=12,48.8589,2.33346&basemap=jawg.streets?disjunctive.id_bvote&disjunctive.num_circ&disjunctive.num_quartier&disjunctive.num_arrond&basemap=jawg.dark&location=12,48.8589,2.33346'::varchar AS SOURCE
FROM paris;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nombureau, codecanton, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Poitiers'::varchar AS nomcom,
       num_bureau,
       nom_site,
       num_canton,
       St_AREA(geom) surfbv,
       2015::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/citoyennete-decoupage-des-bureaux-de-vote-grand-poitiers-donnees-de-reference/'::varchar AS SOURCE
FROM poitiers;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nombureau, nomcanton, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Quimper'::varchar AS nomcom,
       bureaux,
       lieu_vote,
       canton,
       St_AREA(geom) surfbv,
       2018::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/perimetres-des-bureaux-de-vote-ville-de-quimper/'::varchar AS SOURCE
FROM quimper;


INSERT INTO bv_update (id, geom, nomcom, codebureau, codecanton, nbinscrits,surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Rennes'::varchar AS nomcom,
       num_bureau,
       nucanton,
       nb_elec,
       St_AREA(geom) surfbv,
       2017::int AS annee,
       'https://data.rennesmetropole.fr/explore/dataset/perimetres-bureaux-de-vote/map/?location=12,48.11596,-1.6885&basemap=0a029a'::varchar AS SOURCE
FROM rennes;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nombureau,surfbv,annee, SOURCE)
SELECT gid,
       St_Force2D(St_Multi(geom)) geom,
       'Saint-Denis'::varchar AS nomcom,
       numero,
       nom,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       'http://opendata-sig.saintdenis.re/datasets/db28aa7cadcb4c58a116ec29147973b6_0'::varchar AS SOURCE
FROM saintdenis;


INSERT INTO bv_update (id, geom, nomcom, surfbv,annee, SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Saint-Malo'::varchar AS nomcom,
       St_AREA(geom) surfbv,
       2015::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/perimetres-des-bureaux-de-vote/'::varchar AS SOURCE
FROM saintmalo;


INSERT INTO bv_update (id, geom, nomcom,codecom,nombureau, codebureau, codecanton,nomcanton,codecirco,nomcirco,surfbv,annee, datemaj,SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Saint-Nazaire'::varchar AS nomcom,
       cod_commune,
       nom_bureau_vote,
       num_bureau_vote,
       cod_canton,
       nom_canton,
       cod_circonscription,
       nom_circonscription,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       date_creation,
       'https://www.data.gouv.fr/fr/datasets/secteurs-des-bureaux-de-vote-2019-saint-nazaire/'::varchar AS SOURCE
FROM saintnazaire;


INSERT INTO bv_update (id, geom, nomcom,nombureau, codebureau ,nomcanton,surfbv,annee, datemaj,SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Saint-Quentin'::varchar AS nomcom,
       burovote,
       numburo,
       canton,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       creationdate,
       'https://www.data.gouv.fr/fr/datasets/secteurs-de-vote-2/'::varchar AS SOURCE
FROM saintquentin;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nombureau, codecanton,codecirco, surfbv,annee,SOURCE)
SELECT gid,
       St_Force2D(St_Multi(geom)) geom,
       'Strasbourg'::varchar AS nomcom,
       id_bureau,
       nom,
       canton,
       circonscri,
       St_AREA(geom) surfbv,
       2019::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/secteurs-de-vote-2/'::varchar AS SOURCE
FROM strasbourg;


INSERT INTO bv_update (id, geom, nomcom, codebureau, nombureau, surfbv,annee,SOURCE)
SELECT id,
       St_Force2D(St_Multi(geom)) geom,
       'Toulouse'::varchar AS nomcom,
       bv2020,
       nom,
       St_AREA(geom) surfbv,
       2020::int AS annee,
       'https://www.data.gouv.fr/fr/datasets/elections-2020-decoupage-des-bureaux-de-vote-toulouse/'::varchar AS SOURCE
FROM toulouse;


UPDATE bv_update a
SET (codebureau,
     nombureau,
     codecanton,
     codecirco) = (b.code,
                   b.libelle_1,
                   b.canton_code,
                   b.circonscription_code)
FROM
    (SELECT a.*,
            b.code,
            b.libelle_1,
            b.canton_code,
            b.circonscription_code
     FROM bv_update a
     JOIN geo_bureaux_de_vote b ON st_contains (a.geom, b.geom)
     ORDER BY nomcom) b
WHERE a.id = b.id;


SELECT nomcom,
       codecom,
       annee,
       SOURCE
FROM bv_update
GROUP BY nomcom,
         codecom,
         SOURCE,
         annee
ORDER BY nomcom --------------------

CREATE TABLE citoyennete.cartepresidentielle2017toulousecandidats AS
    (SELECT id,
            geom,
            departement,
            commune,
            bv2017,
            nom,
            candidat_1 AS candidat,
            nb_voix_1 AS nb_voix
     FROM citoyennete.cartepresidentielle2017toulouse
     WHERE candidat_1 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_2 AS candidat,
                nb_voix_2 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_2 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_3 AS candidat,
                nb_voix_3 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_3 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_4 AS candidat,
                nb_voix_4 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_4 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_5 AS candidat,
                nb_voix_5 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_5 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_6 AS candidat,
                nb_voix_6 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_6 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_7 AS candidat,
                nb_voix_7 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_7 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_8 AS candidat,
                nb_voix_8 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_8 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_9 AS candidat,
                nb_voix_9 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_9 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_10 AS candidat,
                nb_voix_10 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_10 IS NOT NULL
         UNION ALL
         SELECT id,
                geom,
                departement,
                commune,
                bv2017,
                nom,
                candidat_11 AS candidat,
                nb_voix_11 AS nb_voix
         FROM citoyennete.cartepresidentielle2017toulouse WHERE candidat_11 IS NOT NULL)a
CREATE INDEX cartepresidentielle2017toulousecandidats_gix ON citoyennete.cartepresidentielle2017toulousecandidats USING GIST (geom);


ALTER TABLE citoyennete.cartepresidentielle2017toulousecandidats ADD COLUMN gid SERIAL PRIMARY KEY;

------

DROP TABLE IF EXISTS citoyennete.cartepresidentielle2017toulousecandidatsresultats;


CREATE TABLE citoyennete.cartepresidentielle2017toulousecandidatsresultats AS
SELECT b.id,
       a.geom,
       a.departement,
       a.commune,
       a.bv2017,
       a.nom,
       a.nb_voix,
       b.candidat
FROM
    (SELECT geom,
            departement,
            commune,
            bv2017,
            nom,
            MAX(nb_voix)nb_voix
     FROM citoyennete.cartepresidentielle2017toulousecandidats
     GROUP BY geom,
              departement,
              commune,
              bv2017,
              nom
     ORDER BY bv2017) a
INNER JOIN citoyennete.cartepresidentielle2017toulousecandidats b ON a.bv2017 = b.bv2017
AND a.nb_voix = b.nb_voix;


CREATE INDEX cartepresidentielle2017toulousecandidatsresultats_gix ON citoyennete.cartepresidentielle2017toulousecandidatsresultats USING GIST (geom);


ALTER TABLE citoyennete.cartepresidentielle2017toulousecandidatsresultats ADD COLUMN gid SERIAL PRIMARY KEY;


ALTER TABLE citoyennete.cartepresidentielle2017toulouse ADD COLUMN couleur VARCHAR (10);


UPDATE citoyennete.cartepresidentielle2017toulouse a
SET couleur = b.couleur
FROM
    (SELECT id,
            CASE
                WHEN candidat_gagnant LIKE 'MACR' THEN '#FFB400'
                WHEN candidat_gagnant LIKE 'FILL' THEN '#3d68c6'
                WHEN candidat_gagnant LIKE 'MELA' THEN '#af3045'
            END::varchar AS couleur
     FROM citoyennete.cartepresidentielle2017toulouse) b
WHERE a.id = b.id;


drop table if exists citoyennete.cartepresidentielle2017toulouse;
create table citoyennete.cartepresidentielle2017toulouse as 
select id, departement, commune, bv2017, nom, type, nb_inscrits, nb_bulletins, 
nb_emargements, nb_exprimes, nb_abstentions, nb_blancs, nb_nuls, 
pourcentage_participation, numero_tour, nb_candidats, 
candidat_1, nb_voix_1, ROUND((nb_voix_1*100/nb_bulletins::numeric),2) AS nb_voix_1_participation, '#4c82bf'::varchar as candidat_1_couleur,
candidat_2, nb_voix_2, ROUND((nb_voix_2*100/nb_bulletins::numeric),2) AS nb_voix_2_participation,'#243986'::varchar as candidat_2_couleur,
candidat_3, nb_voix_3, ROUND((nb_voix_3*100/nb_bulletins::numeric),2) AS nb_voix_3_participation,'#FFB400'::varchar as candidat_3_couleur,
candidat_4, nb_voix_4, ROUND((nb_voix_4*100/nb_bulletins::numeric),2) AS nb_voix_4_participation,'#e28482'::varchar as candidat_4_couleur,
candidat_5, nb_voix_5, ROUND((nb_voix_5*100/nb_bulletins::numeric),2) AS nb_voix_5_participation,'#9f1811'::varchar as candidat_5_couleur,
candidat_6, nb_voix_6, ROUND((nb_voix_6*100/nb_bulletins::numeric),2) AS nb_voix_6_participation,'#9f1811'::varchar as candidat_6_couleur,
candidat_7, nb_voix_7, ROUND((nb_voix_7*100/nb_bulletins::numeric),2) AS nb_voix_7_participation,'#f0f0f0'::varchar as candidat_7_couleur,
candidat_8, nb_voix_8, ROUND((nb_voix_8*100/nb_bulletins::numeric),2) AS nb_voix_8_participation,'#f0f0f0'::varchar as candidat_8_couleur,
candidat_9, nb_voix_9, ROUND((nb_voix_9*100/nb_bulletins::numeric),2) AS nb_voix_9_participation,'#af3045'::varchar as candidat_9_couleur,
candidat_10, nb_voix_10, ROUND((nb_voix_10*100/nb_bulletins::numeric),2) AS nb_voix_10_participation,'#7347ba'::varchar as candidat_10_couleur,
candidat_11, nb_voix_11, ROUND((nb_voix_11*100/nb_bulletins::numeric),2) AS nb_voix_11_participation,'#3d68c6'::varchar as candidat_11_couleur,
geom, CASE 
          WHEN candidat_gagnant LIKE 'MACR' THEN 'Emmanuel Macron (En marche !)'
          WHEN candidat_gagnant LIKE 'FILL' THEN 'François Fillon (Les Républicains)' 
          WHEN candidat_gagnant LIKE 'MELA' THEN 'Jean-Luc Mélenchon (La France insoumise)' 
              END::varchar AS candidat_gagnant, nb_voix_gagnant, couleur
       
 from citoyennete.cartepresidentielle2017toulouse_v1;
 CREATE INDEX cartepresidentielle2017toulouse_gix ON citoyennete.cartepresidentielle2017toulouse USING GIST (geom);

ALTER TABLE citoyennete.cartepresidentielle2017toulouse ADD PRIMARY KEY (id) ;
 