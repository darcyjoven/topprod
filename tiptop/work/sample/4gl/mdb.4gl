DATABASE dstest
DEFINE i1 INTEGER
DEFINE i2 INTEGER
DEFINE i3 INTEGER
DEFINE i4 INTEGER
DEFINE i5 INTEGER
DEFINE i6 INTEGER
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_ima02 LIKE ima_file.ima02
DEFINE l_ima021 LIKE ima_file.ima021
MAIN
DECLARE p_ima_s_curs
   SCROLL CURSOR FOR
         SELECT count(*) from ima_file
OPEN p_ima_s_curs
FETCH FIRST p_ima_s_curs INTO i1
DISPLAY "Informix dstest:ima_file : ",i1

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

END MAIN
