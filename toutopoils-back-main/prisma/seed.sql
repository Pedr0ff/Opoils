--
--Contenu de la table 'box'
--

INSERT INTO public."Box"(type, "number", nbr_of_places)
	VALUES
    ('CAT', 'C2', 5),
    ('CAT', 'C1', 4),
    ('CAT', 'C3', 5),
    ('CAT', 'C4', 1),
    ('CAT', 'C5', 4),
    ('CAT', 'C6', 6),
    ('DOG', '1', 3),
    ('DOG', '2', 3),
    ('DOG', '3', 3),
    ('DOG', '4', 2),
    ('DOG', '5', 3),
    ('DOG', '6', 3),
    ('DOG', '7', 2);

--
--Contenu de la table 'animal'
--
INSERT INTO public."Animal"(species, name, gender, age, size, volunteer_experience, box_id)
	VALUES
    ('CAT', 'Jess', 'FEMALE','2022-11-10', 'SMALL', 'BEGINNER', 27),
    ('CAT', 'Topinambour', 'MALE','2022-06-01', 'SMALL', 'BEGINNER', 28),
    ('CAT', 'Chance', 'FEMALE','2020-01-01', 'SMALL', 'BEGINNER', 29),
    ('CAT', 'Rafaello', 'MALE','2016-10-12', 'SMALL', 'EXPERT', 30),
    ('CAT', 'Tofaille', 'MALE','2022-06-01', 'SMALL', 'BEGINNER', 31),
    ('CAT', 'Amande', 'FEMALE','2021-07-01', 'SMALL', 'BEGINNER', 32),
    ('CAT', 'Lumo', 'FEMALE','2015-10-31', 'SMALL', 'BEGINNER', 33),
    ('CAT', 'Maya', 'FEMALE','2022-11-10', 'SMALL', 'BEGINNER',34),
    ('CAT', 'Neo', 'MALE','2022-11-10', 'SMALL', 'BEGINNER', 35),
    ('CAT', 'Pacotille', 'FEMALE','2022-02-25', 'SMALL', 'BEGINNER', 36),
    ('CAT', 'Kati', 'FEMALE','2020-11-10', 'SMALL', 'BEGINNER', 36),
    ('CAT', 'YODA', 'MALE','2019-11-10', 'SMALL', 'BEGINNER', 35),
    ('DOG', 'Lazslow', 'MALE','2021-03-10', 'MEDIUM', 'BEGINNER', 37),
    ('DOG', 'Hoover', 'MALE','2019-07-13', 'MEDIUM', 'BEGINNER', 37),
    ('DOG', 'Tyson', 'MALE','2022-01-10', 'MEDIUM', 'EXPERT', 38),
    ('DOG', 'Drack', 'MALE','2019-07-13', 'MEDIUM', 'MEDIUM', 39),
    ('DOG', 'Pumba', 'MALE','2018-06-02', 'MEDIUM', 'BEGINNER', 39),
    ('DOG', 'Bobby', 'MALE','2020-10-23', 'MEDIUM', 'BEGINNER', 40),
    ('DOG', 'Maya', 'FEMALE','2021-03-12', 'MEDIUM', 'MEDIUM', 40),
    ('DOG', 'Pipa', 'FEMALE','2020-08-13', 'SMALL', 'BEGINNER', 41),
    ('DOG', 'Peggy', 'FEMALE','2017-05-15', 'SMALL', 'BEGINNER', 41),
    ('DOG', 'Bobby', 'MALE','2020-10-23', 'MEDIUM', 'BEGINNER', 42),
    ('DOG', 'Laica', 'FEMALE','2021-09-22', 'BIG', 'MEDIUM', 42),
    ('DOG', 'Olaf', 'MALE','2019-12-27', 'BIG', 'EXPERT', 43);

--
--Contenu de la table 'user'
--
INSERT INTO public."User"(email, password, phone_number, name, firstname,admin, experience)
	VALUES
    ('louna@gmail.com', 'ghfhsksq', '0625130000', 'Decker', 'Louna',false, 'BEGINNER'),
    ('bob@gmail.com', 'kjfhsksq', '0625132458', 'douglas', 'bob',false, 'BEGINNER'),
    ('fanny@gmail.com', 'khtd44zf121', '0681412474', 'Rosio', 'Fanny',false,'BEGINNER'),
    ('laurent@gmail.com', 'tfgrr5455dfs', '0652584748', 'Boulanger', 'Laurent',false, 'MEDIUM'),
    ('laura@gmail.com', 'vsjfihzf121', '0625445581', 'Millet', 'Laura',false,'MEDIUM'),
    ('Mickael@gmail.com', 'hffhhzf121', '0612121474', 'Lob', 'Mickael',false,'MEDIUM'),
    ('Willem@spa.com', 'ggggrere54gd', '0658822142', 'Larazzi', 'Willem',false,'EXPERT'),
    ('maggy@gmail.com', 'szoizh4568', '0625458755', 'Didier', 'Maggy',false,'EXPERT'),
    ('Mariama@gmail.com', 'rrg442dd21', '0612232474', 'Bomgoura', 'Mariama',false,'EXPERT'),
    ('tom@spa.fr', '4545gdfgd54gd', '0658884512', 'Barkali', 'Tom',true,'MEDIUM'),
    ('marine@spa.com', 's41uuy4568', '0624518755', 'Chapier', 'Marine',true,'EXPERT'),
    ('stephane@spa.fr', 'nndizeugd5455dfs', '0625144748', 'Brio', 'Stéphane',true, 'EXPERT');

--
--Contenu de la table 'walk'
-- 
INSERT INTO public."Walk"(date, comment, feeling, user_id, animal_id)
	VALUES 
    ('2023-01-23', 'Tout va bien , on a passé un bon moment', 'GOOD', 13, 213),
    ('2023-01-23', 'Petit probleme pendant la balade. Le chien a vomi', 'MEDIUM', 14, 214),
    ('2023-01-21', 'Bonne balade mais il a beaucoup tiré', 'MEDIUM', 15, 220),
    ('2023-01-20', 'Tout va bien , on a passé un bon moment', 'GOOD', 16, 211),
    ('2023-01-20', 'RAS', 'GOOD', 17, 213),
    ('2023-01-23', 'chien très energique, difficile a tenir en laisse', 'BAD', 20, 212),
    ('2023-01-20', 'RAS', 'GOOD', 17, 215),
    ('2023-01-20', 'Pas de problème, chienne très douce', 'GOOD', 21, 219),
    ('2023-01-21', 'Très nerveux', 'MEDIUM', 28, 217),
    ('2023-01-21', 'Difficile à tenir mais on a passé un bon moment', 'GOOD', 28,215),
    ('2023-01-21', 'Bagarre avec un autre chien', 'BAD', 14,216),
    ('2023-01-21', 'RAS', 'GOOD', 22, 210),
    ('2023-01-20', 'Tout va bien , on a passé un bon moment', 'GOOD', 14,209);

--
--Contenu de la table 'tag'
-- 
INSERT INTO public."Tag"(name)
	VALUES 
	('Joueur'),
	('Sociable'),
	('Energique'),
	('Doux'),
	('Calin'),
	('Calme'),
	('Associable'),
	('Fugueur');

--
--Contenu de la table 'tag'
--
INSERT INTO public."Visit"(date,user_id, box_id)
	VALUES
    ('2023-01-21',21,27),
    ('2023-01-21',22,28),
    ('2023-01-20',14,29),
    ('2023-01-23',13,30);

--
--Contenu de la table 'animal_has_tag'
--
INSERT INTO public."Animal_has_tag"(tag_id, animal_id)
	VALUES
    (11, 197),
    (9, 197),
    (11, 198),
    (9, 198),
    (10, 199),
    (12, 199),
    (12, 200),
    (13, 200),
    (10, 200),
    (15, 201),
    (13, 201),
    (10, 202),
    (12, 203),
    (16, 204),
    (14, 204),
    (13, 205),
    (9, 206),
    (10, 207),
    (11, 208),
    (9, 209),
    (14, 210),
    (12, 210),
    (10, 213),
    (9, 213),
    (9, 214),
    (10, 214),
    (11, 219),
    (9, 219),
    (9, 201),
    (10, 201),
    (9, 217),
    (10, 220),
    (10, 209),
    (12, 213),
    (15,214),
    (16,214),
    (13, 215),
    (14, 215),
    (9, 216),
    (10, 216),
    (10, 217),
    (11, 217),
    (10, 218),
    (14, 218),
    (10, 219),
    (13, 219),
    (10, 210),
    (13, 210),
    (9, 211),
    (12, 211),
    (12, 212),
    (13, 212);
