# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglrx01.4gl
# Descriptions...: TXT.JV
# Date & Author..: 97/03/17 by Roger
 # Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc    LIKE type_file.chr1000,  # Where condition       #No.FUN-680098     VARCHAR(300)                                                           
              a     LIKE type_file.chr1,     # 列印單價              #No.FUN-680098     VARCHAR(1)
              more   LIKE type_file.chr1     # Input moire condition(Y/N) #No.FUN-680098 VARCHAR(1)
              END RECORD
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
    LET tm.wc= ARG_VAL(2)   #No.MOD-4C0171
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc)
      THEN CALL aglrx01_tm(0,0)             # Input print condition
      ELSE LET tm.wc='aba01 ="',tm.wc CLIPPED,'"'
           CALL aglrx01()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglrx01_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680098 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   OPEN WINDOW aglrx01_w AT p_row,p_col
        WITH FORM "agl/42f/aglrx01"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON aba01,aba02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglrx01_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglrx01_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglrx01'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglrx01','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglrx01',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglrx01_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglrx01()
   ERROR ""
END WHILE
   CLOSE WINDOW aglrx01_w
END FUNCTION
 
FUNCTION aglrx01()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098  VARCHAR(20)     
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_cmd,l_sql  LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(600)
          l_za05    LIKE za_file.za05,            #No.FUN-680098 VARCHAR(400)
          aba       RECORD LIKE aba_file.*,
          sr	    RECORD
                    gen02	LIKE gen_file.gen02,
                    gen04	LIKE gen_file.gen04
                    END RECORD
 
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
 
     LET l_sql="SELECT aba_file.*, gen02,gen04",
               "  FROM aba_file,OUTER gen_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND aba_file.abauser=gen_file.gen01"
     PREPARE aglrx01_prepare1 FROM l_sql
     DECLARE aglrx01_curs1 CURSOR FOR aglrx01_prepare1
 
     FOREACH aglrx01_curs1 INTO aba.*, sr.*
       IF sr.gen02 IS NULL THEN
          SELECT zx02 INTO sr.gen02 FROM zx_file WHERE zx01=aba.abauser
       END IF
       LET l_name=aba.aba01 CLIPPED,aba.aba18 USING '&&','.JV'
       LET g_page_line = 1
       START REPORT aglrx01_rep TO l_name
       OUTPUT TO REPORT aglrx01_rep(aba.*, sr.*)
       FINISH REPORT aglrx01_rep
       LET l_cmd='sz -a ',l_name
       RUN l_cmd
     END FOREACH
     IF STATUS THEN CALL cl_err('fore:',STATUS,1) END IF
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT aglrx01_rep(aba, sr)
  DEFINE aba       RECORD LIKE aba_file.*,
         abb       RECORD LIKE abb_file.*,
         abc       RECORD LIKE abc_file.*,
         azc       RECORD LIKE azc_file.*,
         l_aag02    LIKE aag_file.aag02,
         sr	    RECORD
                    gen02	LIKE gen_file.gen02,
                    gen04	LIKE gen_file.gen04
                    END RECORD
  DEFINE i,j,k     LIKE type_file.num10           #No.FUN-680098  integer
  DEFINE tot	   LIKE abb_file.abb07            #No.FUN-680098  DEC(20,6)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY aba.aba01, aba.aba03
  FORMAT
    ON EVERY ROW
      PRINT '"',aba.aba01,'","',aba.aba18 USING '&&','",',
            '"', sr.gen02,'"'
      PRINT '"',aba.aba02,'","',aba.aba07,'","',aba.aba06,'"'
      PRINT '"',aba.aba08,'","',aba.aba09,'"'
      #----------------------------------------------------------------------
      PRINT '"',g_dbs CLIPPED,'"'
      #----------------------------------------------------------------------
      DECLARE rx01_c3 CURSOR FOR
           SELECT * FROM abc_file WHERE abc01=aba.aba01 AND abc00=aba.aba00
                   ORDER BY abc03
      PRINT '"';
      FOREACH rx01_c3 INTO abc.*
        PRINT abc.abc02,'.',abc.abc04 CLIPPED;
      END FOREACH
      PRINT '"'
      #----------------------------------------------------------------------
      PRINT '"**body**"'
      #----------------------------------------------------------------------
      DECLARE rx01_c1 CURSOR FOR
           SELECT abb_file.*, aag02 FROM abb_file, OUTER aag_file
                 WHERE abb01=aba.aba01 AND abb_file.abb03=aag_file.aag01
      LET tot=0
      FOREACH rx01_c1 INTO abb.*, l_aag02
        PRINT '"',abb.abb02 USING '####','",',
              '"',abb.abb03[1,12] ,'",',
              '"',l_aag02 ,'",',
              '"',abb.abb04 ,'",',
              '"',abb.abb05 ,'",',
              '"',abb.abb06 ,'",',
              '"',abb.abb07 USING '############' ,'",',
              '"',abb.abb11 ,'"'
        LET tot=tot+abb.abb07
      END FOREACH
      #----------------------------------------------------------------------
      PRINT '"**total**"'
      PRINT '""'
      #PRINT '"',tot USING '############' ,'"'
      PRINT '"**manager**"'
      #----------------------------------------------------------------------
      DECLARE rx01_c2 CURSOR FOR
           SELECT azc_file.*, gen02 FROM azc_file,OUTER gen_file
            WHERE azc01=aba.abasign AND azc_file.azc03=gen_file.gen01
           ORDER BY azc02
      LET i=1
      FOREACH rx01_c2 INTO azc.*, sr.gen02
        PRINT '"',sr.gen02 CLIPPED,'",';
        LET i=i+1
        IF i>5 THEN EXIT FOREACH END IF
      END FOREACH
      IF STATUS THEN CALL cl_err('foreach azc:',STATUS,1) END IF
      #FOR j=i TO 5 PRINT '"",'; END FOR
      #----------------------------------------------------------------------
      PRINT '"**end**"'
      #----------------------------------------------------------------------
END REPORT
