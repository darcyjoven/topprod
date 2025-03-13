# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_abm_memo.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_chr		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
FUNCTION s_abm_memo(p_no,p_cmd)
   DEFINE p_no		LIKE bmg_file.bmg01 	#No.FUN-680147 VARCHAR(20)
   DEFINE p_cmd		LIKE type_file.chr1     # u:update d:display only #No.FUN-680147 VARCHAR(1)
   DEFINE i,j,s		LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_bmg     DYNAMIC ARRAY OF RECORD
                	bmg03		LIKE bmg_file.bmg03
                    END RECORD
   DEFINE p_row,p_col     LIKE type_file.num5   #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p_no IS NULL THEN RETURN END IF
 
   LET p_row = 5 LET p_col = 5
   OPEN WINDOW s_abm_memo_w AT p_row,p_col WITH FORM "sub/42f/s_abm_memo"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("s_abm_memo")
       
   DECLARE s_abm_memo_c CURSOR FOR
           SELECT bmg03,bmg02 FROM bmg_file
             WHERE bmg01 = p_no
             ORDER BY bmg02
 
   FOR i = 1 TO l_bmg.getLength() INITIALIZE l_bmg[i].* TO NULL END FOR
   LET i = 1
   FOREACH s_abm_memo_c INTO l_bmg[i].bmg03,j
      IF STATUS THEN CALL cl_err('foreach bmg',STATUS,0) EXIT FOREACH END IF 
      LET i = i + 1
      IF i > g_max_rec THEN            #No.TQC-630109
         CALL cl_err( '', 9035, 0 )    #No.TQC-630109
         EXIT FOREACH
      END IF
   END FOREACH
   CALL SET_COUNT(i-1)
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_bmg TO s_bmg.*
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
      
      END DISPLAY
      CLOSE WINDOW s_abm_memo_w
      RETURN
   END IF
   INPUT ARRAY l_bmg WITHOUT DEFAULTS FROM s_bmg.*  ATTRIBUTE(MAXCOUNT=g_max_rec)   #No.TQC-630109
   CLOSE WINDOW s_abm_memo_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_success ='Y' 
   BEGIN WORK
   DELETE FROM bmg_file WHERE bmg01 = p_no
   FOR i = 1 TO l_bmg.getLength()
       IF cl_null(l_bmg[i].bmg03) THEN CONTINUE FOR END IF
       INSERT INTO bmg_file (bmg01,bmg02,bmg03,bmgplant,bmglegal) #FUN-980012 add bmgplant,bmglegal
                     VALUES(p_no,i,l_bmg[i].bmg03,g_plant,g_legal) #FUN-980012 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
          #CALL cl_err('INS-bmg',SQLCA.sqlcode,0)  #FUN-670091
          CALL cl_err3("ins","bmg_file",p_no,l_bmg[i].bmg03,SQLCA.sqlcode,"","",0) #FUN-670091
          LET g_success = 'N' EXIT FOR
       END IF
    END FOR
    IF g_success='Y'
        THEN COMMIT WORK
        ELSE ROLLBACK WORK
    END IF
END FUNCTION
