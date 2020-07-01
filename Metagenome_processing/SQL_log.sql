
/*looking for photosystem components*/
SELECT * from Avdat_crust_all_annotations WHERE
Avdat_crust_all_annotationsRast like '%Photosystem I %'

/*looking for photosystem components*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%Photosystem II %'

/*looking for chlorophyl synthesis*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%chlorophyll%' AND
Rast not like '%Photosystem II%'

/*looking for blue light sensors*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%blue%' OR
Uniprot like '%blue light%'

/*looking for carotene synthesis*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsPfam like '%Beta-carotene%'

SELECT * from Avdat_crust_all_annotations WHERE
Avdat_crust_all_annotationsPfam like '%carotenoid biosynthesis%'

SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%caroten%ketolas%'

/*looking for rhodopsins*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Bacteriorhodopsin%'

SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Heliorhodopsin%'

SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%sensory rhodopsin%'

/*looking for hydrogenases*/
SELECT * from Avdat_crust_all_annotations WHERE
RAST like '% hydrogenase%subunit%' AND 
Pfam like '% hydrogenase%' OR
Pfam like '%Fe% hydrogenase%' OR
Pfam like 'Nickel% hydrogenase%' OR
Pfam like '%| Nickel% hydrogenase%' OR
Uniprot like 'Hydrogenase%subunit%' AND Pfam like '% hydrogenase%' OR
Uniprot like '%Fe%ydrogenase%subunit%' AND Pfam like '% hydrogenase%'

/*looking for CO-dehydrogenase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%carbon%dehydrogenase%chain%'

/*looking for soluble Methane monooxygenase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%methane%component%'

/*looking for particulate Methane monooxygenase/Ammonia monooxygenase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%pmoa%'

/*looking for sulfur oxidation*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%Flavocytochrome%sulfide%dehydrogenase%'

SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%sulfur%oxidation%' OR
Pfam like '%sulfur%oxidation%'

/*looking for terminal oxidases (Cytochrome C)*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%Cytochrome c oxidase%1.9.3.1%' OR
Pfam like '%Cytochrome bd terminal oxidase%')

/*looking for terminal oxidases (Cytochrome bd)*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Cytochrome bd terminal oxidase%'

/*looking for alternative oxidases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%alternative%oxidase%'

/*looking for arsenate oxidases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%arsenate%reductase%1.20.4%' OR
Pfam like '%ArsC family%'

/*looking for nitrite reducatases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%nitrite%reductase%NAD%'

SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%ferredoxin%nitrite%reductase%'

/*looking for nitrite hydratases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%nitrile%hydratase%'

/*looking for nitrogenases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Uniprot like '%nitrogenase%'

/*looking for NifK homologues*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%chlorophyllide%subunit B %'

/*looking for NifD homologues*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%chlorophyllide%subunit N %'

/*looking for Nitronate monooxygenases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Nitronate monooxygenase%'

/*looking for RuBisCo*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Ribulose bisphosphate carboxylase%'

/*looking for Carbohydrate Binding Motifs*/
SELECT * from Avdat_crust_all_annotations WHERE 
HMM_vs_CAZY like '%CBM%'

/*looking for Glycosyl Hydrolases*/
SELECT * from Avdat_crust_all_annotations WHERE 
HMM_vs_CAZY like '%GH%'

/*looking for Proteases*/
SELECT * from Avdat_crust_all_annotations WHERE 
MEROPS_diamond not like ''

/*looking for sugar transporters*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%port%' AND Rast like '%ose%'

/*looking for peptide transporters*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%port%' AND Rast like '%peptide%'

/*looking for amino acid transporters*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%port%' AND 
Rast like '%amino%acid%'

/*looking for lactate permease*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%permease%' AND Rast like '%lactate%'
OR Pfam like '%L-lactate permease%'

/*looking for other permeases*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%permease%' AND Rast not like '%port%' AND Rast not like '%PTS%'

/*looking for PTS systems*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%PTS%' AND not Rast like '%nitroge%regulatory%'

/*looking for pilin*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%pil%' and Rast not like '%twitching%'

/*looking for twitching motility*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%twitching%'

/*looking for gliding motility*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%gliding%'

/*looking for rRNA methylation*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%rRNA%' and Rast like '%methylase%'
OR Rast like '%rRNA%' and Rast like '%methyl%transferase%'

/*looking for DNA photolyase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%photo%lyase%' OR
Pfam like '%photolyase%')

/*looking for other DNA damage repair*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%DNA%' and Rast like '%repair%'

/*looking for other DNA damage repair*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%UV%' and Rast like '%repair%' OR
Pfam like '%UV%endonuclease%')

/*looking for catalase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%catalase%' OR
Pfam like '%catalase%')

/*looking for Cytochrome C peroxidase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsRast like '%cytochrome% peroxidase%' OR
Pfam like '%cytochrome% peroxidase%'

/*looking for animal haem peroxidase*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%animal% peroxidase%'

/*looking for glyoxilate cycle enzymes*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Isocitrate lyase family%' AND Rast like 'Isocitrate lyase%'

SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%Malate synthase%' and Rast like 'Malate synthase%'

SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG_function is 'dehydrogenase nad-binding'

SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG4552'

/*Rubrerythrins*/
SELECT * from Avdat_crust_all_annotations WHERE 
Avdat_crust_all_annotationsPfam like '%Rubrerythrin%'

SELECT * from Avdat_crust_all_annotations WHERE 
Uniprot like '% spore %' OR
Uniprot like '% sporu%' OR
Pfam like '% spore %' OR
Pfam like '% sporu%' OR
Rast like '% spore %' OR
Rast like '% sporu%' OR
EggNOG_function like '% spore %' OR
EggNOG_function like '% sporu%' OR
Uniprot like 'spore %' OR
Uniprot like 'sporu%' OR
Pfam like 'spore %' OR
Pfam like 'sporu%' OR
Rast like 'spore %' OR
Rast like 'sporu%' OR
EggNOG_function like 'spore %' OR
EggNOG_function like 'sporu%'

/*Assymetric cell division FstX*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG2177'

/*Cell wall hydrolase CwlJ, involved in spore germination*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG3773'

/*DNA-binding transcriptional regulator WhiA, involved in cell division*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG1481'

/*Immunoglobulin-like domain of bacterial spore germination*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '0ZYB3' OR
EggNOG is '0ZVA2' OR
EggNOG is '0ZWGT' OR
EggNOG is '0ZVUJ' OR
EggNOG is '126R3'

/*Lipoprotein LpqB, GerMN domain*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '0ZF99' OR
EggNOG is '11S85' OR
EggNOG is '0Y6FI' OR
EggNOG is '11K5J'

/*Polysaccharide deacetylase family sporulation protein PdaB*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '112BD'

/*Protein of unknown function identified by role in sporulation (SpoVG)*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%SpoVG%' OR
EggNOG is '11SKX'

/*RNA polymerase sporulation specific sigma factor SigH*/
SELECT * from Avdat_crust_all_annotations WHERE 
Rast like '%RNA polymerase sporulation specific sigma factor SigH%' OR
Uniprot like '%RNA polymerase sporulation sigma factor SigH%' OR
Uniprot like '%RNA polymerase, sigma 30 subunit, SigH%'

/*Sporulation-control protein spo0M*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG4326' OR
Pfam like '%SpoOM protein%'

/*spore coat polysaccharide biosynthesis protein*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '11SMP'

/*Spore coat sialic acid synthase SpsE*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG2089'

/*Spore coat sialic acid synthase SpsF*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG1861'

/*Spore coat protein CotF*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG5577'

/*Spore coat protein CotH*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '0YUJE' OR
EggNOG is 'COG5337' OR
EggNOG is '0XP9X'

/*Spore germination protein GerM/Lipoprotein LpqB, GerMN domain*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG5401'

/*Spore germination protein YaaH*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG3858'

/*Spore germination protein CgeB*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG4641'

/*Spore maturation protein SpmB*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG0700'

/*Uncharacterized conserved protein YeaH/YhbH, required for sporulation*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG2718'

/*Transcriptional regulator WhiB*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '11TPB' OR
EggNOG is '11ZPZ'

/*Transcriptional regulator WhiD*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '11U54'

/*Sporulation-specific N-acetylmuramoyl-L-alanine amidase*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is '0XTIC'

/*Stage II sporulation protein D*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG2385'

/*Stage II sporulation protein M*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG1300'

/*Stage III sporulation protein AA*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG3854'

/*Stage V sporulation protein R*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG2719'

/*Stage V sporulation protein S*/
SELECT * from Avdat_crust_all_annotations WHERE 
EggNOG is 'COG2359'

/*Streptomyces sporulation and cell division protein, SsgA*/
SELECT * from Avdat_crust_all_annotations WHERE 
Pfam like '%SsgA%'

SELECT * from Avdat_crust_all_annotations WHERE
Rast like '%Mn%' and
Rast like '%Zn%' and
Rast like '%transporter%' OR
Rast like '%Manganese%SitC%' OR
Rast like '%Manganese%SitD%'
