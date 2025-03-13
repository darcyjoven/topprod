# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_asf_memo.4gl
# Descriptions...: 
# Date & Author..: 
# Input Parameter: 
# Return code....: 
# Modify.........: No.MOD-530308 05/03/25 By pengu 在DISPLAY段加入ON ACTION exit
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_asf_memo(p_cmd,p1)
   DEFINE ls_tmp           STRING
   DEFINE p_cmd		   LIKE type_file.chr1  	# u:update d:display only 	#No.FUN-680147 VARCHAR(1)
   DEFINE p1		   LIKE sfw_file.sfw01 		#No.FUN-680147 VARCHAR(10)
   DEFINE i,j,s,n          LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
          l_allow_insert   LIKE type_file.num5,         #可新增否 	#No.FUN-680147 SMALLINT
          l_allow_delete   LIKE type_file.num5          #可刪除否 	#No.FUN-680147 SMALLINT
   DEFINE l_sfw    DYNAMIC ARRAY OF RECORD
                   sfw03		LIKE sfw_file.sfw03
                   END RECORD
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p1 IS NULL THEN RETURN END IF
 
   OPEN WINDOW s_asf_memo_w AT 3,7 WITH FORM "sub/42f/s_asf_memo"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("s_asf_memo")
       
   DECLARE s_asf_memo_c CURSOR FOR
           SELECT sfw02,sfw03 FROM sfw_file
             WHERE sfw01 = p1
             ORDER BY 1
 
   CALL l_sfw.clear()
   LET i = 1
   FOREACH s_asf_memo_c INTO j,l_sfw[i].sfw03
      IF STATUS THEN CALL cl_err('foreach sfw',STATUS,0) EXIT FOREACH END IF 
      LET i = i + 1
      #No.TQC-630109 --start--
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )    #No.TQC-630109
         EXIT FOREACH
      END IF
      #No.TQC-630109 ---end---
   END FOREACH
   LET i = i - 1 
 
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_sfw TO s_sfw.*
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
      #--------No.MOD-530308-------
     ON ACTION exit
        EXIT DISPLAY
      #-------No.MOD-530308------
      END DISPLAY
      CLOSE WINDOW s_asf_memo_w
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF i=0 THEN CALL l_sfw.clear() END IF
 
   INPUT ARRAY l_sfw WITHOUT DEFAULTS FROM s_sfw.* 
      ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(1)
 
        BEFORE ROW
            LET i=ARR_CURR()
 
        AFTER DELETE 
            LET n=ARR_COUNT()
            INITIALIZE l_sfw[n+1].* TO NULL 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW s_asf_memo_w
      RETURN
   END IF
 
   CLOSE WINDOW s_asf_memo_w
 
   DELETE FROM sfw_file WHERE sfw01 = p1
   FOR i = 1 TO l_sfw.getLength()
       IF cl_null(l_sfw[i].sfw03) THEN CONTINUE FOR END IF
       INSERT INTO sfw_file (sfw01,sfw02,sfw03,sfwplant,sfwlegal) #FUN-980012 add sfwplant,sfwlegal
                      VALUES(p1,   i,    l_sfw[i].sfw03,g_plant,g_legal) #FUN-980012 add g_plant,g_legal
       IF STATUS THEN CALL cl_err('ins sfw',STATUS,1) END IF
    END FOR
 
END FUNCTION
