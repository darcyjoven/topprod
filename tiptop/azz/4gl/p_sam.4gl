DATABASE ds

MAIN
  DEFINE m_file VARCHAR(100)
  DEFINE l_ima01    LIKE ima_file.ima01
  DEFINE l_ima25    LIKE ima_file.ima25
  DEFINE l_ima44    LIKE ima_file.ima44
  DEFINE l_img      RECORD LIKE img_file.*
  DEFINE l_cnt      LIKE type_file.num10
  
  WHENEVER ERROR CALL cl_err_msg_log

  DATABASE ds6
  
# CREATE TEMP TABLE img_bak(
#    img01 VARCHAR(16),
#    img02 SMALLINT,
#    img05 VARCHAR(40),
#    img08 DECIMAL(15,3));
# IF STATUS THEN
#    DISPLAY "CREATE TEMP TABLE FAIL"
# END IF
# 
# LOAD FROM '/u3/utiptopo/azz/4gl/img.txt' INSERT INTO img_bak
# IF STATUS THEN
#    DISPLAY "LOAD FAIL"
# END IF

# DELETE FROM img_file
#  WHERE img01<>'51100-0707000001'
# DELETE FROM sfa_file
#  WHERE sfa01<>'51100-0707000001'
  SELECT * INTO l_img.* FROM img_file
   WHERE img01='0A1A005.0E'

  DECLARE curs CURSOR FOR
   SELECT ima01,ima44,ima25 FROM ima_file 
    ORDER BY ima01

  FOREACH curs INTO l_ima01,l_ima44,l_ima25
      LET l_img.img01 = l_ima01
      LET l_img.img07 = l_ima44
      LET l_img.img08 = 0
      LET l_img.img09 = l_ima25
      LET l_img.img10 = 0
      INSERT INTO img_file VALUES(l_img.*)
      IF SQLCA.sqlcode THEN
         DISPLAY l_ima01
      END IF
  END FOREACH
  DATABASE ds

END MAIN
