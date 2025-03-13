DATABASE dstest
DEFINE l_pmk  RECORD LIKE pmk_file.*
DEFINE l_pml  RECORD LIKE pml_file.*
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_pmk01 LIKE pmk_file.pmk01
DEFINE l_cnt  SMALLINT
DEFINE l_cn2  SMALLINT
DEFINE l_cn3  SMALLINT
DEFINE i_rowid SMALLINT
DEFINE o_rowid CHAR(18)
DEFINE l_sql1 CHAR(200)
DEFINE l_sql2 VARCHAR(200)
DEFINE l_wc1  CHAR(100)
DEFINE l_wc2  VARCHAR(200)


MAIN
OPTIONS
    MESSAGE LINE LAST
  OPEN WINDOW test_w AT 2,3
     WITH FORM "work/sample/per/apmtest" ATTRIBUTE(BORDER)
  CONSTRUCT BY NAME l_wc1 ON pmk01,pmk04,pmk12
  LET l_sql1 = "SELECT ROWID,pmk01 FROM pmk_file WHERE ",l_wc1
  PREPARE infx_p1 FROM l_sql1
DECLARE p_pmk_s_curs SCROLL CURSOR FOR infx_p1
OPEN p_pmk_s_curs
FETCH FIRST  p_pmk_s_curs INTO i_rowid,l_pmk01
SELECT * into l_pmk.* from pmk_file  where pmk01=l_pmk01
DISPLAY l_pmk.pmk01 TO pmk01
DISPLAY l_pmk.pmk04 TO pmk04
DISPLAY l_pmk.pmk12 TO pmk12
SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_pmk.pmk12
DISPLAY l_gen02 TO FORMONLY.gen02

#CLOSE p_pmk_s_curs

{
DISPLAY "Informix dstest:pmk_file : ",i1

DECLARE p_ima_s_curs3
   SCROLL CURSOR FOR
         SELECT count(*) from ds:ima_file
OPEN p_ima_s_curs3
FETCH FIRST p_ima_s_curs3 INTO i3
DISPLAY "Informix ds:ima_file : ",i3

DECLARE p_zx_s_curs5
   SCROLL CURSOR FOR
         SELECT count(*) from ds_init:zxx_file
OPEN p_zx_s_curs5
FETCH FIRST p_zx_s_curs5 INTO i5
DISPLAY "Informix ds_init:zxx_file : ",i5

LET l_ima01 = 'PIII'
LET l_ima02 = ''
DECLARE p_zx_s_curs7
   SCROLL CURSOR FOR
         SELECT ima02 from ds:ima_file
           WHERE ima01=l_ima01
OPEN p_zx_s_curs7
FETCH FIRST p_zx_s_curs7 INTO l_ima02
DISPLAY " "
DISPLAY "Informix ds:ima_file ima01 : ",l_ima01
DISPLAY "Informix ds:ima_file ima02 : ",l_ima02
DISPLAY " "

DATABASE ds
DECLARE p_ima_s_curs2
   SCROLL CURSOR FOR
         SELECT count(*) from ima_file
OPEN p_ima_s_curs2
FETCH FIRST p_ima_s_curs2 INTO i2
DISPLAY "Oracle ds.ima_file : ",i2

DECLARE p_zx_s_curs4
   SCROLL CURSOR FOR
         SELECT count(*) from ds_init.zxx_file
OPEN p_zx_s_curs4
FETCH FIRST p_zx_s_curs4 INTO i4
DISPLAY "Oracle ds_init.zxx_file : ",i4

LET l_ima021 = ''
DECLARE p_zx_s_curs8
   SCROLL CURSOR FOR
         SELECT ima021 from ds.ima_file
           WHERE ima01=l_ima01
OPEN p_zx_s_curs8
FETCH FIRST p_zx_s_curs8 INTO l_ima021
DISPLAY " "
DISPLAY "Oracle ds.ima_file ima01 : ",l_ima01
DISPLAY "Oracle ds.ima_file ima021 : ",l_ima021
DISPLAY " "

DATABASE dstest
DECLARE p_zx_s_curs6
   SCROLL CURSOR FOR
         SELECT count(*) from ds:ima_file
OPEN p_zx_s_curs6
FETCH FIRST p_zx_s_curs6 INTO i6
DISPLAY "Informix ds:ima_file : ",i6

DISPLAY " "
DISPLAY "ima01: ",l_ima01
DISPLAY "Informix ima02: ",l_ima02
DISPLAY "Oracle ima021: ",l_ima021
}
END MAIN
