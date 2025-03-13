# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr820.4gl
# Descriptions...: 初盤差異分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 93/05/27 By Apple
# Modify.........: No.FUN-510017 05/01/26 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.MOD-720046 07/03/15 BY TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-740065 07/07/20 By jamie 程式已轉成用Crystal Report方式出報表，程式裡面不應取zaa的資料(以後zaa將不再用)，應將其修正
# Modify.........: No.FUN-930121 09/04/09 By zhaijie新增pia931-"底稿類別"查詢欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-CC0027 12/11/26 By qirl 增加開窗 增加倉庫名稱 庫位名稱
# Modify.........: No.TQC-CB0096 12/11/26 By qirl 增加開窗 增加倉庫名稱 庫位名稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
           wc      STRING,                  # Where Condition  #TQC-630166
           diff    LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
           s       LIKE type_file.chr3,     # Order by sequence  #No.FUN-690026 VARCHAR(3)
           t       LIKE type_file.chr3,     # Eject sw  #No.FUN-690026 VARCHAR(3)
           more    LIKE type_file.chr1      # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_q_point       LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(80)
DEFINE g_star          LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(80)
DEFINE   l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
#MOD-720046 BY TSD.Sora---start---
#TQC-CC0027
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#MOD-720046 BY TSD.Sora---end---
DEFINE g_zaa04_value  LIKE zaa_file.zaa04   #FUN-710080 add
DEFINE g_zaa10_value  LIKE zaa_file.zaa10   #FUN-710080 add
DEFINE g_zaa11_value  LIKE zaa_file.zaa11   #FUN-710080 add
DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #MOD-720046 BY TSD.Sora---start---
   LET g_sql = "pia01.pia_file.pia01,",
               "pia02.pia_file.pia02,",
               "pia03.pia_file.pia03,",
               "imd02.imd_file.imd02,",    #No.TQC-CB0096--add-
               "pia04.pia_file.pia04,",
               "ime03.ime_file.ime03,",    #No.TQC-CB0096--add-
               "pia05.pia_file.pia05,",
               "pia08.pia_file.pia08,",
               "pia30.pia_file.pia30,",
               "pia31.pia_file.pia31,",
               "pia34.pia_file.pia34,",
               "pia35.pia_file.pia35,",
               "pia40.pia_file.pia40,",
               "pia41.pia_file.pia41,",
               "pia44.pia_file.pia44,",
               "pia45.pia_file.pia45,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "gen02_1.gen_file.gen02,",
               "gen02_2.gen_file.gen02,",
               "gen02_pia31.gen_file.gen02,",
               "gen02_pia41.gen_file.gen02,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('aimr820',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?, ?  ,?,?)"       #No.TQC-CB0096--add2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   #MOD-720046 BY TSD.Sora---end---
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.diff  = ARG_VAL(8)      #TQC-610072
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r820_tm(0,0)        # Input print condition
      ELSE CALL r820()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r820_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18 
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r820_w AT p_row,p_col
        WITH FORM "aim/42f/aimr820" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'N'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pia01,pia03,pia04,pia05,pia02,pia31,pia41,pia931     #FUN-930121 add pia931
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
        
      ON ACTION controlp                                                                                                 
         IF INFIELD(pia02) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO pia02                                                                                 
            NEXT FIELD pia02                                                                                                     
         END IF                                                            
#No.FUN-570240 --end  
#----TQC-CB0096----ADD---star--- 
         IF INFIELD(pia01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia01
            NEXT FIELD pia01
         END IF
         IF INFIELD(pia03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia03"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia03
            NEXT FIELD pia03
         END IF
         IF INFIELD(pia04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia04"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia04
            NEXT FIELD pia04
         END IF
         IF INFIELD(pia05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia05"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia05
            NEXT FIELD pia05
         END IF
         IF INFIELD(pia31) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia31"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia31
            NEXT FIELD pia31
         END IF
         IF INFIELD(pia41) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia41"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia41
            NEXT FIELD pia41
         END IF
#----TQC-CB0096----ADD---end-----
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
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r820_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   #NO.FUN-930121----start--查詢時若pia931未輸入查詢條件則默認條件為pia931='1'
   #IF tm.wc.getIndexOf("pia931",1) <=0 THEN
   #   LET tm.wc = tm.wc CLIPPED," AND pia931 ='1'"
   #END IF
   #NO.FUN-930121----end---
#UI
   INPUT BY NAME tm.diff,
                         #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3
       ,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD diff 
         IF tm.diff IS NULL OR tm.diff NOT MATCHES'[YNyn]'
         THEN NEXT FIELD diff
         END IF
 
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r820_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr820'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr820','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.diff CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr820',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r820_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r820()
   ERROR ""
END WHILE
   CLOSE WINDOW r820_w
END FUNCTION
 
FUNCTION r820()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                            # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           pia01  LIKE pia_file.pia01,
                           pia02  LIKE pia_file.pia02,
                           pia03  LIKE pia_file.pia03,
                           imd02  LIKE imd_file.imd02,    #No.TQC-CB0096--add-
                           pia04  LIKE pia_file.pia04,
                           ime03  LIKE ime_file.ime03,    #No.TQC-CB0096--add-
                           pia05  LIKE pia_file.pia05,
                           pia08  LIKE pia_file.pia08,
                           pia30  LIKE pia_file.pia30,
                           pia31  LIKE pia_file.pia31,
                           pia34  LIKE pia_file.pia34,
                           pia35  LIKE pia_file.pia35,
                           pia40  LIKE pia_file.pia40,
                           pia41  LIKE pia_file.pia41,
                           pia44  LIKE pia_file.pia44,
                           pia45  LIKE pia_file.pia45,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           gen02_1 LIKE gen_file.gen02,
                           gen02_2 LIKE gen_file.gen02,
                           gen02_pia31 LIKE gen_file.gen02,
                           gen02_pia41 LIKE gen_file.gen02
                        END RECORD
    #MOD-720046 BY TSD.Sora---start---
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr820'
     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
       FROM azi_file WHERE azi01 = g_aza.aza17
    #MOD-720046 BY TSD.Sora---end---
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT  DISTINCT '','','',",
           #     "pia01, pia02, pia03, pia04,",     #No.TQC-CB0096--mark--
                 "pia01, pia02, pia03,'',pia04,'',",   #No.TQC-CB0096--add-
                 "pia05, pia08, pia30, pia31, pia34, pia35,",
                 "pia40, pia41, pia44, pia45, ima02,ima021,",
                 "gen02,' ',' ',' ' ",
         #       "  FROM pia_file ,OUTER gen_file ,OUTER ima_file",  #No.TQC-CB0096--mark--
                 "  FROM pia_file ,OUTER gen_file ,OUTER ima_file,OUTER imd_file,OUTER ime_file",  #No.TQC-CB0096--add-
                 " WHERE pia_file.pia34 = gen_file.gen01 AND pia_file.pia02=ima_file.ima01",
                 "  AND  pia_file.pia03 = imd_file.imd01 AND pia_file.pia04=ime_file.ime02",   #No.TQC-CB0096--add-
                 "  AND (pia02 IS NOT NULL AND pia02 != ' ') ",
                 "  AND ( (pia30 IS NOT NULL ) ",
                 "        OR (pia40 IS NOT NULL )) ",
                 "   AND ",tm.wc
 
     #初盤資料輸入員(一)與資料輸入員(二)
     IF tm.diff ='N' THEN 
        LET l_sql = l_sql clipped," AND (pia30 != pia40 OR ",
                              " pia30 IS NULL OR ",
                              " pia40 IS NULL  )"
     END IF
 
     PREPARE r820_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r820_curs1 CURSOR FOR r820_prepare1
 
     LET l_name = 'aimr820.out'
     #070315 BY TSD.Sora---start---
    #CALL cl_outnam('aimr820') RETURNING l_name    #FUN-710080 modify
    #CALL r820_getzaa()                            #TQC-740065 mark #FUN-710080 add
     #START REPORT r820_rep TO l_name
     #070315 BY TSD.Sora---end---
     FOR g_i = 1 TO 80 LET g_q_point[g_i,g_i] = '?' END FOR
     FOR g_i = 1 TO 80 LET g_star[g_i,g_i] = '*' END FOR
 
     LET g_pageno = 0
     FOREACH r820_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pia01
                                       #LET l_orderA[g_i] =g_x[51]  #TQC-740065 mark  #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pia03
                                       #LET l_orderA[g_i] =g_x[52]  #TQC-740065 mark  #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pia04
                                       #LET l_orderA[g_i] =g_x[53]  #TQC-740065 mark  #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pia05
                                       #LET l_orderA[g_i] =g_x[57]  #TQC-740065 mark  #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pia02
                                       #LET l_orderA[g_i] =g_x[54]  #TQC-740065 mark  #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pia31
                                       #LET l_orderA[g_i] =g_x[55]  #TQC-740065 mark  #TQC-6A0088
               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.pia41
                                       #LET l_orderA[g_i] =g_x[56]  #TQC-740065 mark  #TQC-6A0088
               OTHERWISE LET l_order[g_i] = '-'
                        #LET l_orderA[g_i] =''  #TQC-740065 mark #TQC-6A0088
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       SELECT gen02 INTO sr.gen02_2 FROM gen_file WHERE gen01 = sr.pia44
       SELECT gen02 INTO sr.gen02_pia31 FROM gen_file WHERE gen01 = sr.pia31
       SELECT gen02 INTO sr.gen02_pia41 FROM gen_file WHERE gen01 = sr.pia41
#No.TQC-CB0096--add-
       SELECT imd02 INTO sr.imd02 FROM imd_file WHERE imd01 = sr.pia03
       SELECT ime03 INTO sr.ime03 FROM ime_file WHERE ime02 = sr.pia04
#No.TQC-CB0096--add-
      #070315 BY TSD.Sora---start---
       #OUTPUT TO REPORT r820_rep(sr.*)
       EXECUTE insert_prep USING
          #sr.pia01,sr.pia02,sr.pia03,sr.pia04,sr.pia05,sr.pia08,sr.pia30,    #No.TQC-CB0096--mark--
           sr.pia01,sr.pia02,sr.pia03,sr.imd02,sr.pia04,sr.ime03,sr.pia05,sr.pia08,sr.pia30, #No.TQC-CB0096--add-
           sr.pia31,sr.pia34,sr.pia35,sr.pia40,sr.pia41,sr.pia44,sr.pia45,
           sr.ima02,sr.ima021,sr.gen02_1,sr.gen02_2,sr.gen02_pia31,
           sr.gen02_pia41,g_azi03,g_azi04,g_azi05    
      #070315 BY TSD.Sora---end---
          
     END FOREACH
  
     #MOD-720046 BY TSD.Sora---start---
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pia01,pia03,pia04,pia05,pia02,pia31,pia41,pia931') #FUN-930121 add pia931
          RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
     CALL cl_prt_cs3('aimr820','aimr820',l_sql,g_str)   #FUN-710080 modify
 
     #FINISH REPORT r820_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #MOD-720046 BY TSD.Sora---end---
END FUNCTION
 
#TQC-740065---mark---str---
##str FUN-710080 add
#FUNCTION r820_getzaa()
#   DEFINE l_zaa02           LIKE type_file.num5,
#          l_zaa08           LIKE type_file.chr1000,
#          l_zaa08_s         STRING,
#          l_zaa14           LIKE zaa_file.zaa14,
#          l_zaa16           LIKE zaa_file.zaa16,
#          l_name            LIKE type_file.chr20,
#          l_n               LIKE type_file.num5,
#          l_n2              LIKE type_file.num5,
#          l_buf             LIKE type_file.chr6,
#          l_sw              LIKE type_file.chr1,
#          l_waitsec         LIKE type_file.num5
#
#   SELECT unique zaa04,zaa11,zaa17
#     INTO g_zaa04_value,g_zaa11_value,g_zaa17_value
#     FROM zaa_file
#    WHERE zaa01 = g_prog
#      AND zaa03 = g_rlang
#      AND zaa10 = 'N'
#      AND ((zaa04='default' AND zaa17='default') OR
#           zaa04 =g_user OR zaa17= g_clas)
#   DECLARE zaa_cur CURSOR FOR
#      SELECT zaa02,zaa08,zaa14,zaa16 FROM zaa_file
#       WHERE zaa01 = g_prog           #程式代號
#         AND zaa03 = g_rlang          #語言別
#         AND zaa04 = g_zaa04_value    #使用者
#         AND zaa11 = g_zaa11_value    #報表列印的樣板
#         AND zaa10 = 'N'              #客製否
#         AND zaa17 = g_zaa17_value    #權限類別
#       ORDER BY zaa02
#   FOREACH zaa_cur INTO l_zaa02,l_zaa08,l_zaa14,l_zaa16
#      #FUN-560048
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
#         EXIT PROGRAM
#      END IF
#      #END FUN-560048
#      LET l_zaa08 = cl_outnam_zab(l_zaa08,l_zaa14,l_zaa16)         #MOD-530271
#      LET l_zaa08_s = l_zaa08 CLIPPED
#      LET g_x[l_zaa02] = l_zaa08_s
#   END FOREACH
#
#END FUNCTION
##end FUN-710080 add
#TQC-740065---mark---end---
 
{REPORT r820_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr           RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                              order2 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                              order3 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                              pia01  LIKE pia_file.pia01,
                              pia02  LIKE pia_file.pia02,
                              pia03  LIKE pia_file.pia03,
                              pia04  LIKE pia_file.pia04,
                              pia05  LIKE pia_file.pia05,
                              pia08  LIKE pia_file.pia08,
                              pia30  LIKE pia_file.pia30,
                              pia31  LIKE pia_file.pia31,
                              pia34  LIKE pia_file.pia34,
                              pia35  LIKE pia_file.pia35,
                              pia40  LIKE pia_file.pia40,
                              pia41  LIKE pia_file.pia41,
                              pia44  LIKE pia_file.pia44,
                              pia45  LIKE pia_file.pia45, 
                              ima02  LIKE ima_file.ima02,
                              ima021 LIKE ima_file.ima021,
                              gen02_1 LIKE gen_file.gen02,
                              gen02_2 LIKE gen_file.gen02,
                              gen02_pia31 LIKE gen_file.gen02,
                              gen02_pia41 LIKE gen_file.gen02
                       END RECORD,
      l_diff       LIKE pia_file.pia30,
      l_str        LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(13)
      l_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.pia01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
 #    PRINT                #TQC-6A0088
      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED 
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]
      PRINTX name=H3 g_x[49],g_x[50]
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
 
   ON EVERY ROW
      IF sr.pia30 IS NULL OR sr.pia30 = ' ' THEN 
         LET l_str    ='***************'
      END IF
      IF sr.pia40 IS NULL OR sr.pia40 = ' ' THEN 
         LET l_str    ='***************'
      END IF
      LET l_diff = sr.pia30 - sr.pia40
      PRINTX name=D1 COLUMN g_c[31],sr.pia01,
                     COLUMN g_c[32],sr.pia02,
                     COLUMN g_c[33],sr.pia03,
                     COLUMN g_c[34],sr.pia04,
                     COLUMN g_c[35],cl_numfor(sr.pia08,35,3),
                     COLUMN g_c[36],sr.pia31,
                     COLUMN g_c[37],sr.gen02_pia31;
            IF sr.pia30 IS NOT NULL AND sr.pia30 != ' ' THEN
                PRINTX name=D1 COLUMN g_c[38],cl_numfor(sr.pia30,38,3);
            ELSE 
                PRINTX name=D1 COLUMN g_c[38],g_q_point[1,g_w[38]];
            END IF
            IF l_diff IS NULL OR l_diff = ' ' THEN 
               PRINTX name=D1 COLUMN g_c[39],g_star[1,g_w[39]], #l_str
                              COLUMN g_c[40],sr.gen02_1
            ELSE 
               PRINTX name=D1 COLUMN g_c[39],cl_numfor(l_diff,39,3),
                              COLUMN g_c[40],sr.gen02_1
            END IF
 
      PRINTX name=D2 COLUMN g_c[41],' ',
                     COLUMN g_c[42],sr.ima02,
                     COLUMN g_c[43],sr.pia05,
                     COLUMN g_c[44],sr.pia41,
                     COLUMN g_c[45],sr.gen02_pia41;
            IF sr.pia40 IS NOT NULL AND sr.pia40 != ' ' THEN
                PRINTX name=D2 COLUMN g_c[46],cl_numfor(sr.pia40,46,3);
            ELSE 
                PRINTX name=D2 COLUMN g_c[46],g_q_point[1,g_w[46]];
            END IF
      PRINTX name=D2 COLUMN g_c[47],sr.pia35,
                     COLUMN g_c[48],sr.pia34
      PRINTX name=D3 COLUMN g_c[49],' ',
                     COLUMN g_c[50],sr.ima021
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'pia01,pia03,pia04,pia05,pia02,pia31,pia41')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
#TQC-630166
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
