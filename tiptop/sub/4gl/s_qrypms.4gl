# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_qrypms.4gl
# Descriptions...: 常用特殊說明資料查詢
#                  本作業不同於標準做法,使用display array 因特別要求
#                  本作業不同於一般的查詢,請特別小心使用************
# Date & Author..: 90/09/15 By Wu
# Input Parameter: p_no1(單號),p_no2,(資料性質)
#                  p_no3(項次),p_no4(位置)
# Modify.........: No.MOD-4B0101 By Mandy 04/12/15 整支重寫Copy From q_pms ,因為本作業不同於一般的查詢,改放在SUB下
# Modify.........: No.FUN-610048 By Nicola 06/01/09 改用直接選取的方式輸入
# Modify.........: No.TQC-610029 06/01/18 By pengu 移除ON ACTION controln功能
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.MOD-860078 08/06/10 BY yiting IDLE
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_qrypms(p_row,p_col,p_no1,p_no2,p_no3,p_no4)
   DEFINE p_row,p_col     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_no1           LIKE pmo_file.pmo01,   #單號
          p_no2           LIKE pmo_file.pmo02,   #資料性質
          p_no3           LIKE pmo_file.pmo03,   #項次
          p_no4           LIKE pmo_file.pmo04,   #位置
          p_no5           LIKE pmo_file.pmo05,
          l_pms           ARRAY[40] of RECORD
                             a      LIKE type_file.chr1,          #No.FUN-680147CHAR(1)
                             pms01  LIKE pms_file.pms01,
                             pms02  LIKE pms_file.pms02
                         END RECORD,
          l_pmt03        LIKE pmt_file.pmt03,
          l_pmt04        LIKE pmt_file.pmt04,
          l_arrno        LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_ac           LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          g_seq          LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_i            LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_exit_sw      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          l_wc           LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
          l_sql          LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
          l_sql2         LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
          l_time         LIKE type_file.chr8,          #No.FUN-680147 VARCHAR(8)
          l_do_ok        LIKE type_file.chr1           #No.FUN-680147 VARCHAR(1)
   DEFINE l_rec_b        LIKE type_file.num5           #No.FUN-610048 #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CONTINUE

   LET l_arrno = 40
 
   OPEN WINDOW s_qrypms_w WITH FORM "sub/42f/s_qrypms"
     ATTRIBUTE(STYLE="createqry" CLIPPED)
   CALL cl_ui_locale("s_qrypms")
 
   WHILE TRUE
      LET l_exit_sw = "Y"
      LET l_ac = 1
      LET l_do_ok = 'Y'
      CALL cl_opmsg('q')
 
      CONSTRUCT l_wc ON pms01,pms02 FROM s_pms[1].pms01,s_pms[1].pms02
      
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
    END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      
      CALL cl_opmsg('w')
 
      LET l_sql = "SELECT 'N', pms01, pms02 FROM pms_file",
                  " WHERE ",l_wc CLIPPED,
                  " ORDER BY pms01"
      PREPARE s_qrypms_prepare FROM l_sql
      DECLARE pms_curs CURSOR FOR s_qrypms_prepare
      
      LET l_sql2 ="SELECT pmt03, pmt04 ",
                  "  FROM pmt_file ",
                  " WHERE pmt01 = ? ",
                  " ORDER BY pmt03 "
      PREPARE q_pmt_prepare FROM l_sql2
      DECLARE pmt_curs CURSOR FOR q_pmt_prepare
      
      FOREACH pms_curs INTO l_pms[l_ac].*
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_ac = l_ac + 1
         IF l_ac > l_arrno THEN 
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
      
      LET l_rec_b = l_ac -1   #No.FUN-610048
 
      INPUT ARRAY l_pms WITHOUT DEFAULTS FROM s_pms.*   #No.FUN-610048
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      
         BEFORE ROW   #No.FUN-610048
            LET l_ac = ARR_CURR()
      
         ON ACTION select_cancel  #選擇或取消
            LET l_exit_sw = 'n'
          # LET l_ac = ARR_CURR()
            IF l_pms[l_ac].a = 'Y' THEN 
               LET l_pms[l_ac].a = 'N'
               DISPLAY l_pms[l_ac].a TO a
            ELSE 
               LET l_pms[l_ac].a = 'Y'
               DISPLAY l_pms[l_ac].a TO a
            END IF
      
       #------No.TQC-610029 mark
        #ON ACTION controln 
        #   LET  l_exit_sw = 'n'
        #   CLEAR FORM 
        #  #EXIT DISPLAY
        #   EXIT INPUT      #No.FUN-610048
        #------No.TQC-610029 end
      
         ON ACTION accept
            LET l_exit_sw = 'y'
           #EXIT DISPLAY
            EXIT INPUT     #No.FUN-610048
      
#--NO.MOD-860078 start---
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
#--NO.MOD-860078 end------- 
     #END DISPLAY
      END INPUT   #No.FUN-610048
      
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         LET l_exit_sw = 'y'
         LET l_do_ok = 'N'
      END IF
      
      IF l_exit_sw = "y" THEN 
         EXIT WHILE  
      END IF
   END WHILE
 
   IF l_do_ok = 'Y' THEN
      SELECT max(pmo05)  #行序
        INTO g_seq 
        FROM pmo_file
       WHERE pmo01 = p_no1 
         AND pmo02 = p_no2 
         AND pmo03 = p_no3 
         AND pmo04 = p_no4
 
      IF g_seq IS NULL THEN 
         LET g_seq = 0 
      END IF
 
      FOR l_i = 1 TO l_arrno
         IF l_pms[l_i].a = 'Y' THEN 
            FOREACH pmt_curs USING l_pms[l_i].pms01 INTO l_pmt03,l_pmt04
               IF SQLCA.sqlcode THEN      
                  LET l_do_ok = 'N'
                  CALL cl_err('foreach error',SQLCA.sqlcode,0)
                  EXIT FOREACH 
               END IF
 
               LET g_seq = g_seq + 1
 
               INSERT INTO pmo_file(pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,
                                    pmoplant,pmolegal) #FUN-980012 add
                             VALUES(p_no1,p_no2,p_no3,p_no4,g_seq,l_pmt04,
                                    g_plant,g_legal)   #FUN-980012 add
               IF SQLCA.sqlcode THEN
                  LET l_do_ok = 'N'
                  EXIT FOREACH
               END IF
            END FOREACH
 
            IF l_do_ok = 'N' THEN
               EXIT FOR
            END IF
         END IF
      END FOR
   END IF
 
   CLOSE WINDOW s_qrypms_w
 
   RETURN l_do_ok
 
END FUNCTION
