# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_afa_memo.4gl 
# Descriptions...: 固定資產備註資料維護作業    
# Date & Author..: 96/05/01 By Sophia
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-960275 09/06/29 By mike 數據類型定義修正  
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_chr		LIKE type_file.chr1,   	  #No.FUN-680147 VARCHAR(1)
       g_argv1          LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(0.底稿資料1.基本資料2.異動單據) #No.FUN-680147 VARCHAR(1)
       g_argv2          LIKE fam_file.fam01,      #單據號碼/財產編號  --No.FUN-560002 	#No.FUN-680147 VARCHAR(16)
      #g_argv3          LIKE fam_file.fam02,      #財產附號     	#No.FUN-680147 VARCHAR(4) #MOD-960275
       g_argv3          LIKE faj_file.faj022,     #MOD-960275      
       g_argv4          LIKE fam_file.fam01       #財產編號+財產附號 	#No.FUN-680147 VARCHAR(14)
 
FUNCTION s_afa_memo(p_argv1,p_argv2,p_cmd,p_argv3)
   DEFINE p_argv1       LIKE type_file.chr1,           	#No.FUN-680147  VARCHAR(1)
          p_argv2       LIKE fam_file.fam01,            #No.FUN-560002           	#No.FUN-680147 VARCHAR(16)
         #p_argv3       LIKE fam_file.fam02,            #No.FUN-680147 VARCHAR(4) #MOD-960275  
          p_argv3       LIKE faj_file.faj022,           #MOD-960275   
          p_cmd		LIKE type_file.chr1,  	        # u:update d:display only 	#No.FUN-680147 VARCHAR(1)
          i,j,s		LIKE type_file.num5,   	        #No.FUN-680147 SMALLINT
          l_fam     DYNAMIC ARRAY OF RECORD
                    fam02       LIKE fam_file.fam02,
                    fam04	LIKE fam_file.fam04,
                    fam05	LIKE fam_file.fam05
                    END RECORD,
          l_fam02_t   LIKE fam_file.fam02 
 
   DEFINE p_row,p_col   LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_argv1 = p_argv1  #類別
   LET g_argv2 = p_argv2  #單據號碼/財產編號
   LET g_argv3 = p_argv3  #財產附號
   IF g_argv1 IS NULL AND g_argv2 IS NULL THEN RETURN END IF
 
   LET p_row = 5 LET p_col = 5 
   OPEN WINDOW s_afa_memo_w AT p_row,p_col WITH FORM "sub/42f/s_afa_memo"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("s_afa_memo")
         
   LET g_argv4=g_argv2     
   LET g_argv4[11,14]=g_argv3     
               
   DECLARE s_afa_memo_c CURSOR FOR
           SELECT fam02,fam04,fam05,fam03 FROM fam_file
             WHERE fam00 = g_argv1
               AND fam01 = g_argv4
             ORDER BY fam02,fam03
 
#  FOR i = 1 TO l_fam.getLength() INITIALIZE l_fam[i].* TO NULL END FOR
   CALL l_fam.clear()
 
   LET i = 1
   FOREACH s_afa_memo_c INTO l_fam[i].fam02,l_fam[i].fam04,l_fam[i].fam05,g_chr
      IF STATUS THEN 
         CALL cl_err('foreach fam',STATUS,0)
         EXIT FOREACH
      END IF 
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )    #No.TQC-630109
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL SET_COUNT(i-1)
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_fam TO s_fam.*       #畫面顯示資料
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
      
      END DISPLAY
      CLOSE WINDOW s_afa_memo_w
      RETURN
   END IF
   INPUT ARRAY l_fam WITHOUT DEFAULTS FROM s_fam.* ATTRIBUTE(MAXCOUNT=g_max_rec) #No.TQC-630109
     BEFORE ROW
        LET i=ARR_CURR()
     AFTER FIELD fam04
        IF cl_null(l_fam[i].fam04) OR l_fam[i].fam04 NOT MATCHES '[012]' THEN
           NEXT FIELD fam04
        END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   CLOSE WINDOW s_afa_memo_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_success ='Y' 
   BEGIN WORK
   DELETE FROM fam_file 
    WHERE fam00 = g_argv1
      AND fam01 = g_argv4
   FOR i = 1 TO l_fam.getLength()
       IF cl_null(l_fam[i].fam05) THEN CONTINUE FOR END IF
       INSERT INTO fam_file (fam00,fam01,fam02,fam03,fam04,fam05) #寫入資料庫
            VALUES(g_argv1,g_argv4,l_fam[i].fam02,i,l_fam[i].fam04,
	           l_fam[i].fam05)
       IF SQLCA.sqlcode THEN
          #CALL cl_err('INS-fam',SQLCA.sqlcode,0) #FUN-670091
          CALL cl_err3("ins","fam_file",g_argv1,"",SQLCA.sqlcode,"","",0) #FUN-670091
          LET g_success = 'N' 
          EXIT FOR
       END IF
    END FOR
    IF g_success='Y'
        THEN COMMIT WORK
        ELSE ROLLBACK WORK
    END IF
END FUNCTION
