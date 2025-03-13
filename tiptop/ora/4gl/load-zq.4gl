DATABASE ds

MAIN

CREATE TEMP TABLE zqt_file (zqt01 VARCHAR(10),zqt02 SMALLINT,zqt03 VARCHAR(70) )

LOAD FROM 'zq_file.seq' INSERT INTO zqt_file
UPDATE zqt_file SET zqt01=TRIM(zqt01)

DELETE FROM zq_file
   WHERE zq01 IN ( SELECT zqt01 FROM zqt_file GROUP BY zqt01)
     AND zq02 = '0'
     AND (zq03 <> 0 OR zq03 IS NULL);

INSERT INTO zq_file SELECT zqt01,'0',zqt02,zqt03 FROM zqt_file

END MAIN
