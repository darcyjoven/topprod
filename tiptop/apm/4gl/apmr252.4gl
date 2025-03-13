# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apmr252.4gl
# Descriptions...: 採購料件詢價維護作業
# Modify.........: No.FUN-B50018 11/07/30 By yangtt 
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
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
DEFINE g_pmw07             LIKE pmw_file.pmw07 
MAIN

#  IF FGL_GETENV("FGLGUI") <> "0" THEN      #若為整合EF自動簽核功能: 需抑制此段落 此處不適用
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
#  END IF
 
 
   IF (NOT cl_user()) THEN                #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                        #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
 
   IF (NOT cl_setup("APM")) THEN          #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                        #判斷使用者執行程式權限
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)

   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)

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
             "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
             "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
             "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
             "sign_str.type_file.chr1000"      #簽核字串 #TQC-C1003
   LET l_table = cl_prt_temptable('apmr252',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN EXIT PROGRAM END IF                #依照狀態值決定程式是否繼續
                                                            #單頭Lock Cursor
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r252_tm(0,0)        # Input print condition
      ELSE CALL r252()              # Read data and create out-file
   END IF
   
   LET g_pdate = g_today                                    #No.FUN-710091 
   CLOSE WINDOW r252_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
FUNCTION r252_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r252_w WITH FORM "apm/42f/apmr252"
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
      LET INT_FLAG = 0 CLOSE WINDOW r252 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
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
      LET INT_FLAG = 0 CLOSE WINDOW r252 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr252'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr252','9031',1)
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
         CALL cl_cmdat('apmr252',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r252
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r252()
   ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION r252()
DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
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
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
    CALL cl_del_data(l_table)
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"   #TQC-C10039  ADD 4?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF


    LET g_sql="SELECT distinct pmw01,pmx12,pmc03,pmw04,pmw06,pmwacti,",
          " pmx02,pmx08,pmx081,pmx082,pmx10,ecd02,pmx09,pmx06,pmx03,pmx07,pmx04,pmx05,",
          " pmw05,pmw051,pmx06t,gec07",
          " FROM pmw_file LEFT OUTER JOIN gec_file ON pmw05=gec01 AND gec011='1',pmx_file LEFT OUTER JOIN pmc_file ON pmx12=pmc01 ",
          " LEFT OUTER JOIN ecd_file ON pmx10=ecd01 ",      
          " WHERE pmx01 = pmw01  AND ",tm.wc CLIPPED
 
    LET g_sql = g_sql CLIPPED," ORDER BY pmw01,pmx02"  #No.FUN-710091
    PREPARE r252_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('r252_p1',STATUS,0) END IF
 
    DECLARE r252_co                         # CURSOR
        CURSOR FOR r252_p1
 
 
    FOREACH r252_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01=sr.pmw04
        EXECUTE insert_prep USING sr.*,l_azi03,  #No.FUN-710091 
                                  "",l_img_blob, "N",""      #No.FUN-710091  #TQC-C10039 ADD "",l_img_blob, "N",""
    END FOREACH
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pmw01,pmw06')                 
            RETURNING tm.wc
    ELSE
       LET tm.wc = ' '
    END IF
    LET g_str = tm.wc CLIPPED ,";",g_prog CLIPPED        #TQC-760033  #MOD-7C0150
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_prog="apmr252"
    LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
    LET g_cr_apr_key_f = "pmw01"       #報表主鍵欄位名稱  #TQC-C10039
    CALL cl_prt_cs3('apmr252','apmr252',g_sql,g_str)
    CLOSE r252_co
    ERROR ""
END FUNCTION
#FUN-B50018
