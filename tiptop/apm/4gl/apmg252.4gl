# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apmg252.4gl
# Descriptions...: 採購料件詢價維護作業
# Modify.........: No.FUN-B50018 11/06/09 By yangtt CR轉GRW
# Modify.........: No.MOD-BC0151 11/12/19 By chenying GR修改
# Modify.........: No.FUN-C40019 12/04/10 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)  # Where condition
              a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)    # 選擇(1)已列印 (2)未列印 (3)全部
              more    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD
DEFINE g_pmw         RECORD LIKE pmw_file.*
DEFINE g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       g_wc          STRING                       #單頭CONSTRUCT結果
DEFINE g_argv1             LIKE pmw_file.pmw01     #單號 
DEFINE g_argv2             STRING                  #指定執行的功能 #TQC-630074
DEFINE g_argv3             LIKE pmx_file.pmx11  
DEFINE g_pmx11             LIKE pmx_file.pmx11 
DEFINE l_table             STRING
DEFINE g_str               STRING
TYPE sr1_t RECORD
     pmw01     LIKE pmw_file.pmw01,
     pmx12     LIKE pmx_file.pmx12,
     pmc03     LIKE pmc_file.pmc03,
     pmw04     LIKE pmw_file.pmw04,
     pmw06     LIKE pmw_file.pmw06,
     pmwacti   LIKE pmw_file.pmwacti,
     pmx02     LIKE pmx_file.pmx02,
     pmx08     LIKE pmx_file.pmx08,
     pmx081    LIKE pmx_file.pmx081,
     pmx082    LIKE pmx_file.pmx082,
     pmx10     LIKE pmx_file.pmx10,
     ecd02     LIKE ecd_file.ecd02,
     pmx09     LIKE pmx_file.pmx09,
     pmx06     LIKE pmx_file.pmx06,
     pmx03     LIKE pmx_file.pmx03,
     pmx07     LIKE pmx_file.pmx07,
     pmx04     LIKE pmx_file.pmx04,
     pmx05     LIKE pmx_file.pmx05,
     pmw05     LIKE pmw_file.pmw05,
     pmw051    LIKE pmw_file.pmw051,
     pmx06t    LIKE pmx_file.pmx06t,
     gec07     LIKE gec_file.gec07,
     azi03     LIKE azi_file.azi03,
     sign_type LIKE type_file.chr1,     #FUN-C40019 add
     sign_img LIKE type_file.blob,      #FUN-C40019 add
     sign_show LIKE type_file.chr1,     #FUN-C40019 add
     sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD
 
MAIN

#  IF FGL_GETENV("FGLGUI") <> "0" THEN      #若為整合EF自動簽核功能: 需抑制此段落 此處不適用
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
#  END IF
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074
   LET g_argv2=ARG_VAL(2)           #TQC-630074
   LET g_argv3=ARG_VAL(3)

#  IF g_argv3 = "1" THEN                  #在cl_user前須預先處理全域變數值
#     LET g_prog="apmg252"                #此處是 apmg252與 apmi262為共用程式的處理方式
#     LET g_pmx11 = "1"
#  ELSE
#     LET g_prog="apmg262"
#     LET g_pmx11 = "2"
#  END IF 
 
   IF (NOT cl_user()) THEN                #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                        #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
 
   IF (NOT cl_setup("APM")) THEN          #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                        #判斷使用者執行程式權限
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)

   LET g_sql="pmw01.pmw_file.pmw01,",#若需使用CR報表的TEMP Table需在setup後宣告開啟的字串
             "pmx12.pmx_file.pmx12,",#格式為 "colname_in_temp.table.col_name"
             "pmc03.pmc_file.pmc03,",#每個宣告間以逗號隔開
             "pmw04.pmw_file.pmw04,",
             "pmw06.pmw_file.pmw06,",
             "pmwacti.pmw_file.pmwacti,",
             "pmx02.pmx_file.pmx02,",
             "pmx08.pmx_file.pmx08,",
             "pmx081.pmx_file.pmx081,",
             "pmx082.pmx_file.pmx082,",
             "pmx10.pmx_file.pmx10,",
             "ecd02.ecd_file.ecd02,",
             "pmx09.pmx_file.pmx09,",
             "pmx06.pmx_file.pmx06,",
             "pmx03.pmx_file.pmx03,",
             "pmx07.pmx_file.pmx07,",
             "pmx04.pmx_file.pmx04,",
             "pmx05.pmx_file.pmx05,",
             "pmw05.pmw_file.pmw05,",
             "pmw051.pmw_file.pmw051,",
             "pmx06t.pmx_file.pmx06t,",
             "gec07.gec_file.gec07,",
             "azi03.azi_file.azi03,",
             "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
             "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
             "sign_show.type_file.chr1,",                       #FUN-C40019 add
             "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('apmg252',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       CALL cl_gre_drop_temptable(l_table)
       EXIT PROGRAM 
   END IF                #依照狀態值決定程式是否繼續
                                                            #單頭Lock Cursor
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g252_tm(0,0)        # Input print condition
      ELSE CALL g252()              # Read data and create out-file
   END IF
   
   LET g_pdate = g_today                                    #No.FUN-710091 
   CLOSE WINDOW g252_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g252_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW g252_w WITH FORM "apm/42f/apmg252"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         CALL cl_ui_init()                               #轉換介面語言別、匯入ToolBar、Action...等資訊
  
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
       CONSTRUCT BY NAME tm.wc ON pmw01,pmw06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             
       ON ACTION locale
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
      ON ACTION qbe_select
          CALL cl_qbe_select()
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g252_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.a, tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]'  OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g252_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmg252'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg252','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'",         
                         " '",g_rpt_name CLIPPED,"'"         
         CALL cl_cmdat('apmg252',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g252_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g252()
   ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION g252()
DEFINE
    l_i             LIKE type_file.num5, 
    sr              RECORD
        pmw01       LIKE pmw_file.pmw01,   #單據編號
        pmx12       LIKE pmx_file.pmx12,   #廠商編號 #FUN-650191
        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
        pmw04       LIKE pmw_file.pmw04,   #交易幣別
        pmw06       LIKE pmw_file.pmw06,   #詢價日期
        pmwacti     LIKE pmw_file.pmwacti, #資料有效碼
        pmx02       LIKE pmx_file.pmx02,   #項次
        pmx08       LIKE pmx_file.pmx08,   #料件編號
        pmx081      LIKE pmx_file.pmx081,  #品名
        pmx082      LIKE pmx_file.pmx082,  #規格      #MOD-640052
        pmx10       LIKE pmx_file.pmx10,   
        ecd02       LIKE ecd_file.ecd02,   
        pmx09       LIKE pmx_file.pmx09,   #詢價單位
        pmx06       LIKE pmx_file.pmx06,   #採購價格
        pmx03       LIKE pmx_file.pmx03,   #上限數量
        pmx07       LIKE pmx_file.pmx07,   #折扣比率
        pmx04       LIKE pmx_file.pmx04,   #生效日期
        pmx05       LIKE pmx_file.pmx05,   #失效日期
        pmw05       LIKE pmw_file.pmw05,   #稅別
        pmw051      LIKE pmw_file.pmw051,  #稅率
        pmx06t      LIKE pmx_file.pmx06t,  #含稅單價
        gec07       LIKE gec_file.gec07   #含稅否
       END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  
    l_za05          LIKE za_file.za05,    
    l_azi03         LIKE azi_file.azi03,   
    l_wc            STRING                
    DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   

    CALL cl_del_data(l_table)
    LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add

    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"    #FUN-C40019 add 4?   
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       CALL cl_gre_drop_temptable(l_table)
       EXIT PROGRAM
    END IF

    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmwuser', 'pmwgrup')
    
    LET g_sql="SELECT pmw01,pmx12,pmc03,pmw04,pmw06,pmwacti,",
          " pmx02,pmx08,pmx081,pmx082,pmx10,ecd02,pmx09,pmx06,pmx03,pmx07,pmx04,pmx05,",
          " pmw05,pmw051,pmx06t,gec07",
          " FROM pmw_file LEFT OUTER JOIN gec_file ON pmw05=gec01 AND gec011='1',pmx_file LEFT OUTER JOIN pmc_file ON pmx12=pmc01 ",
          " LEFT OUTER JOIN ecd_file ON pmx10=ecd01 ",      
          " WHERE pmx01 = pmw01 AND ",tm.wc CLIPPED
 #  LET g_sql = g_sql CLIPPED," ORDER BY pmw01,pmx02"  #No.FUN-710091
    PREPARE g252_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('g252_p1',STATUS,0) END IF
 
    DECLARE g252_co                         # CURSOR
        CURSOR FOR g252_p1
 
 
    FOREACH g252_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01=sr.pmw04
        EXECUTE insert_prep USING sr.*,l_azi03,  #No.FUN-710091 
                                  "",l_img_blob,"N",""    #FUN-C40019 add
    END FOREACH
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pmw01,pmw06')
            RETURNING tm.wc
    ELSE
       LET l_wc = ' '
    END IF
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "pmw01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL apmg252_grdata()                                      #FUN-B50018     
    ERROR ""
END FUNCTION
           
###GENGRE###START                                                                  
FUNCTION apmg252_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019

    WHILE TRUE
        CALL cl_gre_init_pageheader()    
        LET handler = cl_gre_outnam("apmg252")
  
        IF handler IS NOT NULL THEN
            START REPORT apmg252_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY pmw01,pmx02"          #MOD-BC0151 add
          
            DECLARE apmg252_datacur1 CURSOR FROM l_sql
            FOREACH apmg252_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg252_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg252_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
 
REPORT apmg252_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_title2 STRING
    DEFINE l_group1 STRING
    DEFINE l_pmx06_fmt  STRING
    DEFINE l_pmx06t_fmt  STRING
    DEFINE l_pmx03_fmt   STRING
    
    ORDER EXTERNAL BY sr1.pmw01,sr1.pmx02,sr1.pmx08
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #MOD-BC0151
            PRINTX g_wc            
  
        BEFORE GROUP OF sr1.pmw01
            LET l_lineno = 0   
        BEFORE GROUP OF sr1.pmx02
        BEFORE GROUP OF sr1.pmx08
            
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            
            IF cl_null(g_pmx11) THEN
               LET  l_group1 = 'apmg252'
            ELSE 
               IF g_pmx11 = '1' THEN
                  LET  l_group1 = 'apmg252' 
               ELSE
                  LET  l_group1 = 'apmg262'
               END IF
            END IF

            IF cl_null(l_group1) THEN 
               LET l_title2 = cl_gr_getmsg("gre-089",g_lang,'2')
            ELSE
               IF l_group1 = 'apmg252' THEN
                  LET l_title2 = cl_gr_getmsg("gre-089",g_lang,'0')
               ELSE
                  LET l_title2 = cl_gr_getmsg("gre-089",g_lang,'1')
               END IF
            END IF
            PRINTX  l_group1                    
            PRINTX l_title2
      
            LET l_pmx03_fmt = cl_gr_numfmt('pmx_file','pmx03',sr1.azi03)
            PRINTX l_pmx03_fmt
            LET l_pmx06_fmt = cl_gr_numfmt('pmx_file','pmx06', sr1.azi03)
            PRINTX l_pmx06_fmt
            LET l_pmx06t_fmt = cl_gr_numfmt('pmx_file','pmx06t', sr1.azi03)
            PRINTX l_pmx06t_fmt 

            PRINTX sr1.*

        AFTER GROUP OF sr1.pmw01
        AFTER GROUP OF sr1.pmx02
        AFTER GROUP OF sr1.pmx08

        
        ON LAST ROW

END REPORT
###GENGRE###END   
#FUN-B50018----add-----end---------------

