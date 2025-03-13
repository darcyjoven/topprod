# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmrx02.4gl
# Descriptions...: TXT.PR
# Date & Author..: 97/08/08 by Kitty
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or LIKE type_file.num20_6
# Modify.........: No.TQC-610085 06/04/04 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640184 06/04/19 By Echo 自動執行確認功能
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970017 09/09/21 By baofei 修改 LET l_cmd='sz -a ',l_name 
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:CHI-B70039 11/08/18 By joHung 金額 = 計價數量 x 單價
 
IMPORT os         #TQC-970017  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      LIKE type_file.chr1000,    # Where condition 	        #No.FUN-680136 VARCHAR(500) 
              a       LIKE type_file.chr1,       # 列印單價             	#No.FUN-680136 VARCHAR(1) 
              more    LIKE type_file.chr1        # Input more condition(Y/N) 	#No.FUN-680136 VARCHAR(1) 
              END RECORD
 
MAIN
   #FUN-640184
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
          INPUT NO WRAP
   END IF
   #END FUN-640184
 
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
#------------No.TQC-610085 modify
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
#  LET tm.wc= ARG_VAL(1)
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#------------No.TQC-610085 end

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80088--add--
   IF cl_null(tm.wc)
      THEN CALL apmrx02_tm(0,0)             # Input print condition
      ELSE LET tm.wc='pmm01 ="',tm.wc CLIPPED,'"'
           CALL apmrx02()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
END MAIN
 
FUNCTION apmrx02_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000     #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW apmrx02_w AT p_row,p_col WITH FORM "apm/42f/apmrx02"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04
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
      LET INT_FLAG = 0
      CLOSE WINDOW apmrx02_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
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
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0
      CLOSE WINDOW apmrx02_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmrx02'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmrx02','9031',1)
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
                        #" '",tm.a CLIPPED,"'" ,                #TQC-610085 
                        #" '",tm.more CLIPPED,"'"  ,            #TQC-610085
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmrx02',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmrx02_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmrx02()
   ERROR ""
END WHILE
   CLOSE WINDOW apmrx02_w
END FUNCTION
 
FUNCTION apmrx02()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_cmd,l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) 
          l_za05    LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          pmm       RECORD LIKE pmm_file.*,
          sr	    RECORD
                    gen02	LIKE gen_file.gen02,
                    gen04	LIKE gen_file.gen04,
                    gem02	LIKE gem_file.gem02,
                    pmc03	LIKE pmc_file.pmc03,
                    pma02	LIKE pma_file.pma02
                    END RECORD
       DEFINE l_source,l_target,l_status   STRING      #TQC-970017  
 
       #No.FUN-B80088--mark--Begin---
       #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80088--mark--End-----
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT pmm_file.*, gen02,gen04,gem02,pmc03,pma02",
               "  FROM pmm_file,OUTER gen_file,OUTER gem_file,OUTER pmc_file,",
               "                OUTER pma_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND pmm_file.pmm12=gen_file.gen01 AND pmm_file.pmm13=gem_file.gem01 AND pmm_file.pmm09=pmc_file.pmc01",
               "   AND pmm_file.pmm20=pma_file.pma01 AND pmm18 !='X'"
     PREPARE apmrx02_prepare1 FROM l_sql
     DECLARE apmrx02_curs1 CURSOR FOR apmrx02_prepare1
 
     FOREACH apmrx02_curs1 INTO pmm.*, sr.*
       LET l_name=pmm.pmm01 CLIPPED,pmm.pmm03 USING '&&','.PO'
       LET g_page_line = 1
       START REPORT apmrx02_rep TO l_name
       OUTPUT TO REPORT apmrx02_rep(pmm.*, sr.*)
       FINISH REPORT apmrx02_rep
      #No.+366 010709 by plum
#      LET l_cmd='chmod 777 ',l_name                      #No.FUN-9C0009
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009 
      #No.+366..end
#TQC-970017---begin                                                                                                                 
#       LET l_cmd='sz -a ',l_name                                                                                                   
#       RUN l_cmd                                                                                                                   
    LET l_source= os.Path.join(FGL_GETENV("TEMPDIR"),l_name)                                                                        
    LET l_target="C:\\tiptop\\",l_name CLIPPED                                                                                      
    LET l_status = cl_download_file(l_source,l_target)                                                                              
#TQC-970017---end 
     END FOREACH
     IF STATUS THEN CALL cl_err('fore:',STATUS,1) END IF
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)

       #No.FUN-B80088--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80088--mark--End-----
END FUNCTION
 
REPORT apmrx02_rep(pmm, sr)
  DEFINE pmm       RECORD LIKE pmm_file.*,
         pmn       RECORD LIKE pmn_file.*,
         pmo       RECORD LIKE pmo_file.*,
         azc       RECORD LIKE azc_file.*,
         sr	    RECORD
                    gen02	LIKE gen_file.gen02,
                    gen04	LIKE gen_file.gen04,
                    gem02	LIKE gem_file.gem02,
                    pmc03	LIKE pmc_file.pmc03,
                    pma02	LIKE pma_file.pma02
                    END RECORD
  DEFINE i,j,k     LIKE type_file.num10  	#No.FUN-680136 INTEGER
  DEFINE tot	   LIKE pmn_file.pmn31 #MOD-530190
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY pmm.pmm01, pmm.pmm03
  FORMAT
    ON EVERY ROW
      PRINT '"',pmm.pmm01,'","',pmm.pmm03 USING '&&','",',
            '"', sr.gen02,'","',pmm.pmm04,'"'
      PRINT '"',pmm.pmm06,'","',sr.pmc03,'"'
      PRINT '"',sr.pma02 CLIPPED,'","',pmm.pmm41 CLIPPED,'"'
      PRINT '"',pmm.pmm22 CLIPPED,'","',pmm.pmm21 CLIPPED,'"'
      PRINT '"',pmm.pmm02,'","',pmm.pmm10,'","',pmm.pmm11,'",',
            '"',sr.gen04,'","',sr.gem02,'"'
      #----------------------------------------------------------------------
      PRINT '"',g_dbs CLIPPED,'"'
      #----------------------------------------------------------------------
      DECLARE rx02_c3 CURSOR FOR
           SELECT * FROM pmo_file WHERE pmo01=pmm.pmm01 ORDER BY pmo03
      PRINT '"';
      FOREACH rx02_c3 INTO pmo.*
        PRINT pmo.pmo03,'.',pmo.pmo06 CLIPPED;
      END FOREACH
      PRINT '"'
      #----------------------------------------------------------------------
      PRINT '"**body**"'
      #----------------------------------------------------------------------
      DECLARE rx02_c1 CURSOR FOR
           SELECT * FROM pmn_file WHERE pmn01=pmm.pmm01
      LET tot=0
      FOREACH rx02_c1 INTO pmn.*
        PRINT '"',pmn.pmn04 ,'",',
              '"',pmn.pmn041 ,'",',
              '"',pmn.pmn07 ,'",',
              '"',pmn.pmn31 USING '<<<<<<<<.<<<' ,'",',
              '"',pmn.pmn20 USING '<<<<<<<<.<<<' ,'",',
#             '"',pmn.pmn31*pmn.pmn20 USING '<<<<<<<<.<<<' ,'",',   #CHI-B70039 mark
              '"',pmn.pmn87*pmn.pmn31 USING '<<<<<<<<.<<<' ,'",',   #CHI-B70039
              '"',pmn.pmn33 ,'",',
              '"',pmn.pmn41 ,'"'
#       LET tot=tot+pmn.pmn31*pmn.pmn20   #CHI-B70039 mark
        LET tot=tot+pmn.pmn87*pmn.pmn31   #CHI-B70039
      END FOREACH
      #----------------------------------------------------------------------
      PRINT '"**total**"'
      PRINT '"',tot USING '<<<<<<<<.<<<' ,'"'
      PRINT '"**manager**"'
      #----------------------------------------------------------------------
      DECLARE rx02_c2 CURSOR FOR
           SELECT azc_file.*, gen02 FROM azc_file,OUTER gen_file
            WHERE azc01=pmm.pmmsign AND azc_file.azc03=gen_file.gen01
           ORDER BY azc02
      LET i=1
      FOREACH rx02_c2 INTO azc.*, sr.gen02
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
