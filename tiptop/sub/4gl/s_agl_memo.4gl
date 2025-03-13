# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_agl_memo.4gl
# Descriptions...: 
# Date & Author..:
# Modify.........: No.MOD-490268 04/09/14 By Carol 資料筆數改check g_max_rec 
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_agl_memo(p_cmd,p0,p1,p2)
   DEFINE p_cmd	        LIKE type_file.chr1  	# u:update d:display only  #No.FUN-680147 VARCHAR(1)
   DEFINE p0		LIKE aaa_file.aaa01     #No.FUN-670039
   DEFINE p1		LIKE abc_file.abc01     #No.FUN-680147 VARCHAR(12)
   DEFINE p2		LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE i,j,s,n LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_abc     DYNAMIC ARRAY OF RECORD
                    abc04         LIKE abc_file.abc04
                    END RECORD
 
   WHENEVER ERROR CONTINUE
 
   IF p1 IS NULL THEN RETURN END IF
 
   OPEN WINDOW s_agl_memo_w AT 03,07 WITH FORM "sub/42f/s_agl_memo"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("s_agl_memo")
 
   DECLARE s_agl_memo_c CURSOR FOR
           SELECT abc03,abc04 FROM abc_file
             WHERE abc00 = p0 AND abc01 = p1 AND abc02 = p2
             ORDER BY abc03,abc04
 
    CALL l_abc.clear()    #MOD-490268
   LET i = 1
   FOREACH s_agl_memo_c INTO j,l_abc[i].abc04
      IF STATUS THEN CALL cl_err('foreach abc',STATUS,0) EXIT FOREACH END IF 
      LET i = i + 1
 #MOD-490268
        IF i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL l_abc.deleteElement(i)
    LET i = i - 1
##
 
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_abc TO s_abc.*
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
      
      END DISPLAY
      CLOSE WINDOW s_agl_memo_w
      RETURN
   END IF
   INPUT ARRAY l_abc WITHOUT DEFAULTS FROM s_abc.* ATTRIBUTE(MAXCOUNT=g_max_rec) #No.TQC-630109
     BEFORE ROW
        LET i=ARR_CURR()
     AFTER DELETE 
        LET n=ARR_COUNT()
        INITIALIZE l_abc[n+1].* TO NULL 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   CLOSE WINDOW s_agl_memo_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   DELETE FROM abc_file WHERE abc00 = p0 AND abc01 = p1 AND abc02 = p2
   FOR i = 1 TO l_abc.getLength()
       IF cl_null(l_abc[i].abc04) THEN CONTINUE FOR END IF
       INSERT INTO abc_file (abc00,abc01,abc02,abc03,abc04,abclegal) #FUN-980012 add abclegal
                     VALUES(p0,p1,p2,i, l_abc[i].abc04,g_legal) #FUN-980012 add g_legal
       IF STATUS THEN 
          #CALL cl_err('INS-abc',STATUS,1)  #FUN-670091
          CALL cl_err3("ins","abc_file","","",STATUS,"","",0) #FUN-670091
       END IF
    END FOR
END FUNCTION
