# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr005.4gl
# Descriptions...: 聯屬公司關係結構表
# Date & Author..: 01/09/14 By Debbie Hsu
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-530522 05/05/03 By Smapmin 上層公司別與帳別顯示有誤
# Modify.........: NO.TQC-630241 06/03/24 BY yiting 程式錯誤
# Modify.........: No.TQC-650058 06/05/11 By Joe 修改憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉的錯誤 
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.TQC-670012 06/07/05 By Smapmin g_bookno未定義
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6C0211 06/12/30 By wujie   修改打印“結束”的條件 
# Modify.........: No.FUN-6B0021 07/03/14 By jamie 族群欄位開窗查詢
# Modify.........: No.FUN-740149 07/04/24 By Sarah 增加列印公司名稱
# Modify.........: No.FUN-740094 07/04/26 By Sarah 增加列印計帳幣別
# Modify.........: No.TQC-790036 07/09/06 By lumxa 打印報表“from”位置錯誤；頁次格式錯誤
# Modify.........: No.FUN-780068 07/09/26 By Sarah 增加列印持股比率(axb07)
# Modify.........: No.FUN-830053 08/03/27 By baofei 報表打印改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C50059 12/12/20 By Belle 修改axb07為axbb07
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                              #Print condition RECORD
            wc        LIKE type_file.chr1000,  #Where condition           #No.FUN-680098 VARCHAR(200)
            more      LIKE type_file.chr1      #Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)
           END RECORD,
       g_axb01_a      LIKE axb_file.axb01,
       g_axb02_a      LIKE axb_file.axb02,
       g_axb03_a      LIKE axb_file.axb03,
       g_axb04_a      LIKE axb_file.axb04,
       g_axb05_a      LIKE axb_file.axb05,
       g_bookno       LIKE aah_file.aah00      #帳別   #TQC-670012
DEFINE g_i            LIKE type_file.num5      #count/index for any purpose        #No.FUN-680098   SMALLINT
#No.FUN-830053---Begin                                                                                                              
 DEFINE g_axz02       LIKE axz_file.axz02,
        g_axz06       LIKE axz_file.axz05                                                                                           
 DEFINE l_table        STRING,                                                                                                      
        g_str          STRING,                                                                                                      
        g_sql          STRING                                                                                                       
#No.FUN-830053---End   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#No.FUN-830053---Begin                                                                                                              
   LET g_sql = "g_axb01.axb_file.axb01,",                                                                                           
               "g_axb02.axb_file.axb02,",
               "g_axb03.axb_file.axb03,",
               "g_axz02.axz_file.axz02,",
               "g_axz06.axz_file.axz06,",                                                                                           
               "axb02.axb_file.axb02,",                                                                                             
               "axb03.axb_file.axb03,",
               "axb04.axb_file.axb04,",                                                                                              
               "axb05.axb_file.axb05,",                                                                                             
               "axz02.axz_file.axz02,",
               "axz06.axz_file.axz06,",                                                                                           
               "axb07.axb_file.axb07,",
               "p_level.type_file.num5"                                                                                             
   LET l_table = cl_prt_temptable('aglr005',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "                                                                                           
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830053---End 
   #-----No.MOD-4C0171-----
   LET g_bookno = ARG_VAL(1)    #TQC-610056
   LET g_pdate  = ARG_VAL(2)    # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #-----No.MOD-4C0171 END-----
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN # If background job sw is off
      CALL aglr005_tm(0,0)                   # Input print condition
   ELSE
      CALL aglr005()                         # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 34
 
   OPEN WINDOW aglr005_w AT p_row,p_col WITH FORM "agl/42f/aglr005"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON axb01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #FUN-6B0021---add---str---                  
         ON ACTION CONTROLP
            IF INFIELD(axb01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axb3'
               LET g_qryparam.default1 = tm.wc       
               CALL cl_create_qry() RETURNING tm.wc  
               DISPLAY tm.wc TO FORMONLY.axb01       
               NEXT FIELD axb01
            END IF 
         #FUN-6B0021---add---end---
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW aglr005_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW aglr005_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='aglr005'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr005','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_bookno CLIPPED,"'",   #TQC-610056
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr005',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW aglr005_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aglr005()
      ERROR ""
   END WHILE
   CLOSE WINDOW aglr005_w
END FUNCTION
 
FUNCTION aglr005()
DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time    LIKE type_file.chr8          #No.FUN-6A0073
       l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
       l_axb01   LIKE axb_file.axb01,
       l_axb02   LIKE axb_file.axb02,
       l_axb03   LIKE axb_file.axb03,
       l_za05    LIKE za_file.za05            #No.FUN-680098  VARCHAR(40)
 
   CALL cl_del_data(l_table)       #No.FUN-830053
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
##  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr005'
##  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
##  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND axauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND axagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND axagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('axauser', 'axagrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT UNIQUE axb01,axb02,axb03 ",
               " FROM axb_file WHERE  ",tm.wc,
               " ORDER BY 1"
 
   PREPARE aglr005_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr005_curs1 CURSOR FOR aglr005_p1
 
#   CALL cl_outnam('aglr005') RETURNING l_name    #No.FUN-830053
 
   ## TQC-650058 By Joe -------------------------------------
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr005'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   ## TQC-650058 By Joe -------------------------------------
 
#   START REPORT r005_rep TO l_name    #No.FUN-830053
   LET g_pageno = 0
 
   FOREACH aglr005_curs1 INTO l_axb01,l_axb02,l_axb03
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_axb01_a=l_axb01
      LET g_axb02_a=l_axb02
      LET g_axb03_a=l_axb03
#No.FUn-830053---Begin
      SELECT axz02,axz06 INTO g_axz02,g_axz06                                                        
        FROM axz_file WHERE axz01=g_axb02_a                                                                                         
      IF cl_null(g_axz02) THEN LET g_axz02 = ' ' END IF                                                                         
      IF cl_null(g_axz06) THEN LET g_axz06 = ' ' END IF 
#No.FUN-830053---End
 
     CALL r005_bom(0,l_axb01,l_axb02,l_axb03)
   END FOREACH
#No.FUN-830053---Begin
#   FINISH REPORT r005_rep
   LET g_str= g_towhom                                                                                                              
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
   CALL cl_prt_cs3('aglr005','aglr005',l_sql,g_str) 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830053---End
END FUNCTION
 
FUNCTION r005_bom(p_level,p_key1,p_key2,p_key3)
DEFINE p_level     LIKE type_file.num5,           #No.FUN-680098 SMALLINT
       l_axb01_old LIKE axb_file.axb01,
       l_axb04_old LIKE axb_file.axb04,
       l_axb05_old LIKE axb_file.axb05,
       p_key1      LIKE axb_file.axb01,
       p_key2      LIKE axb_file.axb02,
       p_key3      LIKE axb_file.axb03,
       l_ac,i      LIKE type_file.num5,           #No.FUN-680098 SMALLINT
       arrno       LIKE type_file.num5,           #No.FUN-680098 SMALLINT
       l_sql       LIKE type_file.chr1000,        #No.FUN-680098 VARCHAR(300)
       l_remark    LIKE type_file.chr1000,        #No.FUN-680098 VARCHAR(30)  
       sr DYNAMIC ARRAY OF RECORD
          axb01    LIKE axb_file.axb01,
          axb02    LIKE axb_file.axb02,
          axb03    LIKE axb_file.axb03,
          axb04    LIKE axb_file.axb04,
          axb05    LIKE axb_file.axb05,
          axb06    LIKE axb_file.axb06,
          axz02    LIKE axz_file.axz02,           #FUN-740149 add
          axz06    LIKE axz_file.axz06,           #FUN-740094 add
         #axb07    LIKE axb_file.axb07            #FUN-C50059 mark #FUN-780068 add 10/19
          axbb07   LIKE axbb_file.axbb07          #FUN-C50059
       END RECORD
 
   IF p_level>30 THEN CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   LET p_level=p_level+1
   IF p_level=1 THEN
      INITIALIZE sr[1].* TO NULL
      LET g_pageno=0
      LET sr[1].axb02=p_key1
   END IF
   LET arrno=100
   WHILE TRUE
      LET l_sql="SELECT axb01,axb02,axb03,axb04,axb05,axb06,axz02,axz06 ",  #FUN-740149 add axz02   #FUN-740094 add axz06
               #"      ,axb07 ",    #FUN-C50059 mark #FUN-780068 add 10/19
                "      ,axbb07 ",   #FUN-C50059
                "  FROM axb_file,axz_file ",                          #FUN-740149 add axz_file
                "      ,axbb_file",                                         #FUN-C50059
                " WHERE axb02='",p_key2,"' AND axb03='",p_key3,"' ",
                "   AND axb04=axz01",                                 #FUN-740149 add
                "   AND axb01=axbb01 AND axb02=axbb02 AND axb03=axbb03",    #FUN-C50059
                "   AND axb04=axbb04 AND axb05=axbb05 ",                    #FUN-C50059
                "   AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file ",      #FUN-C50059
                "                   WHERE axb01=axbb01 AND axb02=axbb02 AND axb03=axbb03 ",  #FUN-C50059
                "                     AND axb04=axbb04 AND axb05=axbb05)"                    #FUN-C50059
      IF cl_null(p_key1) THEN
         LET l_sql =l_sql CLIPPED," AND axb01 <> '",p_key1,"' ",
                   " ORDER BY axb01,axb02,axb03,axb04,axb05,axb06 "
      ELSE
         LET l_sql =l_sql CLIPPED,
                   "   AND axb01='",g_axb01_a,"' ",
                   " ORDER BY axb01,axb02,axb03,axb04,axb05,axb06 "
      END IF
      PREPARE r005_ppp FROM l_sql
      IF SQLCA.SQLCODE THEN
         CALL cl_err("P1:",SQLCA.SQLCODE,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      DECLARE r005_cur CURSOR FOR r005_ppp
 
      LET l_ac=1
      FOREACH r005_cur INTO sr[l_ac].*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('r005_cur',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_ac=l_ac+1
         IF l_ac=arrno THEN EXIT FOREACH END IF
      END FOREACH
      ##modi by yuening 011030
      FOR i=1 TO l_ac-1
        #LET l_remark=g_axb01_a,g_axb02_a,g_axb03_a  #MOD-530522
        # LET l_remark=g_axb01_a,'.',g_axb02_a,'.',g_axb03_a  #MOD-530522  #N0:FUN-830053
        # OUTPUT TO REPORT r005_rep(p_level,sr[i].*,l_remark)              #No.FUN-830053
#No.FUN-830053---Begin
         EXECUTE insert_prep USING g_axb01_a,g_axb02_a,g_axb03_a,g_axz02,g_axz06,sr[i].axb02,
                                   sr[1].axb03,sr[i].axb04,sr[i].axb05,sr[i].axz02,sr[i].axz06,
                                  #sr[i].axb07,p_level        #FUN-C50059 mark
                                   sr[i].axbb07,p_level       #FUN-C50059
 
#No.FUN-830053---End       
         IF NOT cl_null(sr[i].axb01) AND NOT cl_null(sr[i].axb02)
            AND NOT cl_null(sr[i].axb03) THEN
            CALL r005_bom(p_level,sr[i].axb01,sr[i].axb04,sr[i].axb05)
         END IF
      END FOR
      IF l_ac < arrno THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
#No.FUN-830053---Begin
#REPORT r005_rep(p_level,sr,l_remark)
#DEFINE l_trailer_sw         LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1)
#      l_remark             LIKE type_file.chr1000,   #No.FUN-680098 VARCHAR(100)
#      l_remark2            STRING,                   #MOD-530522
#      l_ind                LIKE type_file.num5,      #MOD-530522    #No.FUN-680098 SMALLINT
#      p_axb01_a            LIKE axb_file.axb01,
#      p_axb02_a            LIKE axb_file.axb02,
#      p_axb03_a            LIKE axb_file.axb03,
#      l_axz02_a            LIKE axz_file.axz02,      #FUN-740149 add
#      l_axz06_a            LIKE axz_file.axz06,      #FUN-740094 add
#      sr           RECORD
#                    axb01  LIKE axb_file.axb01,
#                    axb02  LIKE axb_file.axb02,
#                    axb03  LIKE axb_file.axb03,
#                    axb04  LIKE axb_file.axb04,
#                    axb05  LIKE axb_file.axb05,
#                    axb06  LIKE axb_file.axb06,
#                    axz02  LIKE axz_file.axz02,      #FUN-740149 add
#                    axz06  LIKE axz_file.axz06,      #FUN-740094 add
#                    axb07  LIKE axb_file.axb07       #FUN-780068 add 10/19
#                   END RECORD,
#      t,l_i,l_j,p_level    LIKE type_file.num5       #No.FUN-680098 SMALINT 
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# FORMAT
#   PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' ' THEN
#        PRINT '';
#     ELSE
#        PRINT 'TO:',g_towhom;
#     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED  #TQC-790036
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN (g_len-FGL_WIDTH(g_user)-19),'FROM:',g_user CLIPPED,  #TQC-790036
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     #PRINT g_dash[1,g_len]
#     PRINT g_dash    #NO.TQC-630241
#     PRINT ''
##MOD-530522
#     LET l_remark2 = l_remark
#     LET l_ind = l_remark2.getIndexOf(".",1)
#     LET p_axb01_a = l_remark2.subString(1,l_ind-1)
#     LET l_remark2 = l_remark2.subString(l_ind+1,l_remark2.getLength())
#     LET l_ind = l_remark2.getIndexOf(".",1)
#     LET p_axb02_a = l_remark2.subString(1,l_ind-1)
#     LET l_remark2 = l_remark2.subString(l_ind+1,l_remark2.getLength())
#     LET p_axb03_a = l_remark2
#     #LET p_axb01_a=l_remark[01,10]
#     #LET p_axb02_a=l_remark[11,20]
#     #LET p_axb03_a=l_remark[21,30]
#     #str FUN-740149 add
#     SELECT axz02,axz06 INTO l_axz02_a,l_axz06_a   #FUN-740094 add axz06
#       FROM axz_file WHERE axz01=p_axb02_a
#     IF cl_null(l_axz02_a) THEN LET l_axz02_a = ' ' END IF
#     IF cl_null(l_axz06_a) THEN LET l_axz06_a = ' ' END IF   #FUN-740094 add
#     #end FUN-740149 add
##END MOD-530522
#     PRINT p_axb01_a CLIPPED,'/',p_axb02_a CLIPPED,'/',p_axb03_a CLIPPED,
#           '(',l_axz02_a CLIPPED,')'   #FUN-740149 add
#          ,'  ',l_axz06_a CLIPPED      #FUN-740094 add
#     PRINT ''
#     LET t=1
#     LET l_trailer_sw = 'n'           #No.TQC-6C0211 
 
#   BEFORE GROUP OF l_remark
#     SKIP TO TOP OF PAGE
 
#   ON EVERY ROW
#     IF p_level > t THEN
#        FOR l_i = 1 TO p_level PRINT g_x[13] CLIPPED; END FOR
#        PRINT " "
#     END IF
#     IF p_level < t THEN
#        FOR l_i = 1 TO p_level PRINT g_x[13] CLIPPED; END FOR
#        PRINT g_x[14] CLIPPED
#     END IF
#     FOR l_i = 1 TO p_level-1 PRINT g_x[13] CLIPPED; END FOR
#     PRINT g_x[15] CLIPPED,g_x[16] CLIPPED,sr.axb04 CLIPPED,'/',sr.axb05,
#           '(',sr.axz02 CLIPPED,')'   #FUN-740149 add
#          ,'  ',sr.axz06 CLIPPED      #FUN-740094 add
#          ,'  ',sr.axb07 CLIPPED,'%'  #FUN-780068 add 10/19
#     LET t = p_level
 
#   AFTER GROUP OF l_remark
#     FOR l_i = 1 TO p_level PRINT g_x[14] CLIPPED; END FOR print ''
#     LET l_trailer_sw = 'y'
#
##No.TQC-6C0211--begin                                                                                                               
#   ON LAST ROW                                                                                                                     
#      PRINT g_dash[1,g_len]                                                                                                        
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED                                                                  
#      LET l_trailer_sw ='n'                                                                                                        
##No.TQC-6C0211--end                                                                                                                 
# PAGE TRAILER                                                                                                                      
#   IF l_trailer_sw='y' THEN                                                                                                        
#      PRINT g_dash[1,g_len]                                                                                                        
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED    #No.TQC-6C                                                    
#   ELSE                                                                                                                            
#      SKIP 2 LINE                                                                                                                  
#   END IF 
#END REPORT
#No.FUN-830053---End
#Patch....NO.TQC-610035 <001> #
#FUN-870144
