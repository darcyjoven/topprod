# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr200.4gl
# Descriptions...: 出入庫日報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 93/05/03 By Apple
# Modify ........: No:8423 03/10/06 By Melody 以GUI 6.0去RUN,排列順序選2.日期;小計打勾,報表內容無法依日期小計
# Modify ........: No.MOD-480135 04/08/12 By Nicola 輸入順序錯誤
# Modify ........: No.FUN-4A0055 04/10/07 By Echo 單據編號, 倉庫編號開窗
# Modify.........: No.FUN-510017 05/02/18 By Mandy 報表轉XML
# Modify.........: No.MOD-530313 05/03/25 By Mandy aimr200 報表相關程式無法RUN
# Modify.........: No.FUN-570240 05/07/27 By jackie 料件編號欄位加開窗查詢
# Modify.........: NO.TQC-5B0142 05/11/16 By Rosayu 修改單據編號顯示如果沒有tlf027就不加-
#                  單據編號,參考單號顯示未完全
# Modify.........: No.FUN-5B0047 05/11/30 By Sarah 盤盈未印出倉庫資料
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-650002 06/05/03 By Claire 本用程式,執行程式時需顯示不同程式名稱
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6C0222 06/12/29 By Ray 第一頁跳頁錯誤
# Modify.........: No.TQC-740326 07/04/27 By sherry  進行語言轉換結束候，會自動帶著下一個語言轉換的對話框。
# Modify.........: No.FUN-780012 07/08/08 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.MOD-920241 09/02/19 By claire tlf033 條件改 tlf904
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0120 10/11/28 By chenying sr2裡的no放大為CHAR(30)
#                                                     l_table裡的chr20放大為CHAR(30)
# Modify.........: No.FUN-A90024 10/12/01 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.TQC-CC0047 12/12/10 By qirl 增加倉庫名稱
# Modify.........: No.TQC-CC0082 12/12/14 By qirl 增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm            RECORD                          # Print condition RECORD
                     wc       STRING,                #TQC-630166 where Condition
                     wc2      STRING,                #TQC-630166 where Condition
                     tlf06_b  LIKE tlf_file.tlf06,   #No.FUN-690026 DATE
                     tlf06_e  LIKE tlf_file.tlf06,   #No.FUN-690026 DATE
                     tlf07_b  LIKE tlf_file.tlf07,   #No.FUN-690026 DATE
                     tlf07_e  LIKE tlf_file.tlf07,   #No.FUN-690026 DATE
                     a        LIKE type_file.chr1,   # print date         #No.FUN-690026 VARCHAR(1)
                     s        LIKE type_file.chr3,   # Order by sequence  #No.FUN-690026 VARCHAR(3)
                     t        LIKE type_file.chr3,   # Eject sw           #No.FUN-690026 VARCHAR(3)
                     u        LIKE type_file.chr3,   # Group total sw     #No.FUN-690026 VARCHAR(3)
                     b        LIKE type_file.chr1,   # print condition    #No.FUN-690026 VARCHAR(1)
                     tbname   LIKE gat_file.gat01,   # table name         #No.FUN-690026 VARCHAR(10)
                     more LIKE type_file.chr1        # special condition  #No.FUN-690026 VARCHAR(1)
                     END RECORD,
       g_code        LIKE type_file.num5,            #No.FUN-690026 SMALLINT
      #g_program     LIKE zz_file.zz01,              #No.FUN-690026 VARCHAR(10)
       g_program     STRING,
       g_str         LIKE ze_file.ze03,              #No.FUN-690026 VARCHAR(40)
       g_str1,g_str2 LIKE ze_file.ze03,              #No.FUN-690026 VARCHAR(10)
       g_str3,g_str4 LIKE ze_file.ze03,              #No.FUN-690026 VARCHAR(10)
       g_order       LIKE ima_file.ima01,            #No.FUN-690026 VARCHAR(40)
       g_wc          string,                         #No.FUN-580092 HCN
       g_date        LIKE zaa_file.zaa08             #No.FUN-690026 VARCHAR(40)
DEFINE g_gettlf      DYNAMIC ARRAY OF RECORD   
                     tbname   LIKE gat_file.gat01,   # table name        #No.FUN-690026 VARCHAR(10)
                     bdate    LIKE type_file.dat,    #Transaction begin date  #No.FUN-690026 DATE
                     edate    LIKE type_file.dat,    #Transaction end   date  #No.FUN-690026 DATE
                     p_no     LIKE type_file.num10   #Transaction count  #No.FUN-690026 INTEGER
                     END RECORD
DEFINE g_i           LIKE type_file.num5             #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_sql         STRING                          #No.FUN-780012
DEFINE l_table       STRING                          #No.FUN-780012
DEFINE l_str         STRING                          #No.FUN-780012
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				        # Supress DEL key function
 
   LET g_program= ARG_VAL(1)    	#TQC-610072 mark #TQC-650002
   LET g_code   = ARG_VAL(2)       	#TQC-610072 mark #TQC-650002 順推 
   LET g_pdate  = ARG_VAL(3)       	# Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc    = ARG_VAL(9)
   LET tm.wc2   = ARG_VAL(10)
   #TQC-610072-begin
   LET tm.tlf06_b = ARG_VAL(11)
   LET tm.tlf06_e = ARG_VAL(12)
   LET tm.tlf07_b = ARG_VAL(13)
   LET tm.tlf07_e = ARG_VAL(14)
   #TQC-610072-end                 #順序順推
   LET tm.a     = ARG_VAL(15)
   LET tm.s     = ARG_VAL(16)
   LET tm.t     = ARG_VAL(17)
   LET tm.u     = ARG_VAL(18)
   LET tm.b     = ARG_VAL(19)
   LET tm.tbname= ARG_VAL(20)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF NOT cl_null(g_program) THEN
      LET g_prog=g_program
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-780012 --start--
#  LET g_sql="chr20.type_file.chr20,tlf07.tlf_file.tlf07,",  #TQC-AB0120 mark
   LET g_sql="chr30.type_file.chr30,tlf07.tlf_file.tlf07,",  #TQC-AB0120 add
             "tlf021.tlf_file.tlf021,imd02.imd_file.imd02,tlf023.tlf_file.tlf023,",   #TQC-CC0047--add--imd02
             "tlf022.tlf_file.tlf022,tlf01.tlf_file.tlf01,",
             "ima02.ima_file.ima02,ima021.ima_file.ima021,",
             "tlf11.tlf_file.tlf11,tlf10.tlf_file.tlf10,",
             "tlf026.tlf_file.tlf026,tlf026_1.tlf_file.tlf026,",
             "tlf026_2.tlf_file.tlf026,tlf026_3.tlf_file.tlf026,",
             "ima15.ima_file.ima15,tlf13.tlf_file.tlf13"
   LET l_table = cl_prt_temptable('aimr200',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"       #TQC-CC0047--add--1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780012 --end--
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN      # If background job sw is off
      CALL r200_tm(0,0)	        	          # Input print condition
   ELSE
      CALL r200()			          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r200_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_j,l_n       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW r200_w AT p_row,p_col WITH FORM "aim/42f/aimr200" 
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   # 2004/02/06 by Hiko : 共用畫面時呼叫.
   CALL cl_set_locale_frm_name("aimr200")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a  ='1'
   LET tm.b  ='2'
   LET tm.tbname='tlf_file'
   LET tm.s  = '123'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   CALL s_program(g_code) RETURNING g_str,g_wc
   CALL s_refer(g_code) RETURNING g_str1,g_str2,g_str3,g_str4
WHILE TRUE
   IF g_code > 20 THEN       #出庫條件(來源)
      CONSTRUCT tm.wc ON tlf026,tlf021,tlf022,tlf023,
                         tlf036,tlf13,tlf01,ima08,ima06
                    FROM tlf026,stock, ware,loc ,
                         tlfno ,tlf13,tlf01,ima08,ima06
     ON ACTION locale
     #   CALL cl_dynamic_locale()     #No.TQC-740326
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
       AFTER FIELD ima08
          LET tm.wc2=GET_FLDBUF(ima08)
 
      #### No.FUN-4A0054
      ON ACTION CONTROLP
           CASE
   {           WHEN INFIELD(tlf026)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_tlf"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tlf026
                NEXT FIELD tlf026
  }
#-----TQC-CC0082--add---star
              WHEN INFIELD(tlf026)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_tlf"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tlf026
                NEXT FIELD tlf026
#-----TQC-CC0082--add---end---
              WHEN INFIELD(stock)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1     = 'SW'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO stock
                NEXT FIELD stock
#No.FUN-570240  --start-                                                                                                            
              WHEN INFIELD(tlf01)                                                                                                  
                CALL cl_init_qry_var()                                                                                               
                LET g_qryparam.form = "q_tlf"                                                                                        
                LET g_qryparam.state = "c"                                                                                           
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
                DISPLAY g_qryparam.multiret TO tlf01                                                                            
                NEXT FIELD tlf01                                                                                                     
#No.FUN-570240 --end--  
           END CASE
 
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
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
    #     CALL cl_show_fld_cont()   #FUN-550037(smin)   #No.TQC-740326
          CONTINUE WHILE
       END IF
 
 
 
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW r200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM 
            
      END IF
   ELSE                      #入庫條件(目的)
     #CONSTRUCT tm.wc ON tlf036,tlf031,tlf032,tlf033,  #MOD-920241
      CONSTRUCT tm.wc ON tlf036,tlf902,tlf903,tlf904,  #MOD-920241 mark
                         tlf026,tlf13,tlf01,ima08,ima06
                    FROM tlf026,stock, ware  ,loc   ,
                         tlfno ,tlf13,tlf01,ima08,ima06
  
     ON ACTION locale
       # CALL cl_dynamic_locale()   #No.TQC-740326
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
 
       AFTER FIELD ima08
          LET tm.wc2=GET_FLDBUF(ima08)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      #### No.FUN-4A0054
      ON ACTION CONTROLP
           CASE
   {           WHEN INFIELD(tlf026)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_tlf"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tlf026
                NEXT FIELD tlf026
  }
#-----TQC-CC0082--add---star
              WHEN INFIELD(tlf026)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_tlf"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tlf026
                NEXT FIELD tlf026
#-----TQC-CC0082--add---end---
              WHEN INFIELD(stock)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1     = 'SW'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO stock
                NEXT FIELD stock
#No.FUN-570240  --start-                                                                                                            
              WHEN INFIELD(tlf01)                                                                                                  
                CALL cl_init_qry_var()                                                                                               
                LET g_qryparam.form = "q_tlf"                                                                                        
                LET g_qryparam.state = "c"                                                                                           
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
                DISPLAY g_qryparam.multiret TO tlf01                                                                            
                NEXT FIELD tlf01                                                                                                     
#No.FUN-570240 --end--  
           END CASE
           ### END  No.FUN-4A0054
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
      END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
      #   CALL cl_show_fld_cont()   #FUN-550037(smin)#No.TQC-740326
          CONTINUE WHILE
       END IF
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW r200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM 
            
      END IF
   END IF
#  LET tm.wc = tm.wc clipped, " AND ",tm.wc2 clipped 
#--->怕只怕 user 再重新輸入條件,因此....
   FOR l_j=1  TO 70
       initialize g_gettlf[l_j].* TO NULL
   END FOR
 
#UI
    INPUT BY NAME tm.tlf06_b,tm.tlf06_e,tm.tlf07_b,tm.tlf07_e,  #No.MOD-480135
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,
                 tm.a,tm.b,tm.tbname,tm.more 
                 WITHOUT DEFAULTS 
     ON ACTION locale
       # CALL cl_dynamic_locale()    #No.TQC-740326
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         LET g_action_choice = "locale"
 
 
 
      AFTER FIELD tlf06_e
         IF tm.tlf06_e < tm.tlf06_b THEN 
            NEXT FIELD tlf06_b
         END IF  
      AFTER FIELD tlf07_e
         IF tm.tlf07_e < tm.tlf07_b THEN 
            NEXT FIELD tlf07_b
         END IF  
      AFTER FIELD a       #print date condition
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[12]'
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b       #print condition
         IF cl_null(tm.b) THEN NEXT FIELD b END IF
         IF tm.b NOT MATCHES '[123]'
            THEN NEXT FIELD b
         END IF
      AFTER FIELD tbname  #file name
         IF cl_null(tm.tbname) THEN NEXT FIELD tbname END IF
         #BugNo:6597
         #---FUN-A90024---start-----
         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構
         #SELECT COUNT(distinct table_name) INTO l_n FROM all_tables WHERE table_name=trim(upper(tm.tbname))
         SELECT COUNT(distinct sch01) INTO l_n FROM sch_file WHERE sch01 = tm.tbname
          #---FUN-A90024---end-------
         IF l_n <= 0 THEN
             CALL cl_err(tm.tbname,'mfg9180',0)
             NEXT FIELD tbname
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
       AFTER INPUT
          LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]  #No:8423
          LET tm.t = tm2.t1,tm2.t2,tm2.t3
          LET tm.u = tm2.u1,tm2.u2,tm2.u3
          IF tm.tlf06_b > tm.tlf06_e THEN NEXT FIELD tlf06_b END IF
          IF tm.tlf07_b > tm.tlf07_e THEN NEXT FIELD tlf07_b END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
 
      ON ACTION select_mul_file
         CALL s_gettlf(0,0)  
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r200_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr200','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_program CLIPPED,"'",     #TQC-650002  
                         " '",g_code    CLIPPED,"'",     #TQC-610072 mark #TQC-650002 
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",
                         " '",tm.tlf06_b CLIPPED,"'",
                         " '",tm.tlf06_e CLIPPED,"'",
                         " '",tm.tlf07_b CLIPPED,"'",
                         " '",tm.tlf07_e CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.tbname CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr200',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r200()
   ERROR ""
END WHILE
   CLOSE WINDOW r200_w
END FUNCTION
 
FUNCTION r200()
   DEFINE l_name     LIKE type_file.chr20,            #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                          #TQC-630166             
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr         RECORD        
                     tlf       RECORD LIKE tlf_file.*,     
                     imd02     LIKE imd_file.imd02,  #TQC-CC0047--add
                     ima02     LIKE ima_file.ima02,
                     ima021    LIKE ima_file.ima021,  #FUN-510017
                     ima15     LIKE ima_file.ima15
                     END RECORD,
          sr2        RECORD       
                     order1    LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2    LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3    LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                #    no        VARCHAR(13),               #單據編號
                #    no        LIKE type_file.chr20,  #單據編號+項次  #TQC-5B0142 14->20 #No.FUN-690026 VARCHAR(20)  #TQC-AB0120 mark
                     no        LIKE type_file.chr30,  #單據編號+項次  #TQC-5B0142 14->20 #No.FUN-690026 VARCHAR(20)  #TQC-AB0120 add
                     item      LIKE tlf_file.tlf027,  #項次     
                     date      LIKE tlf_file.tlf07,   #日期
                     stock     LIKE tlf_file.tlf021,  #倉庫編號
                     imd02     LIKE imd_file.imd02,    #TQC-CC0047--add
                     ware      LIKE tlf_file.tlf022,  #儲位
                     location  LIKE tlf_file.tlf023,  #批號
                     tlf01     LIKE tlf_file.tlf01,   #料件編號
                     ima02     LIKE ima_file.ima02,   #品名規格
                     ima021    LIKE ima_file.ima021,  #FUN-510017
                     ima15     LIKE ima_file.ima15,   #保稅否
                     tlf11     LIKE tlf_file.tlf11,   #異動單位
                     tlf10     LIKE tlf_file.tlf10,   #異動數量
                     tlf02     LIKE tlf_file.tlf02,   #來源狀況 
                     tlf03     LIKE tlf_file.tlf03,   #目的狀況
                     tlf13     LIKE tlf_file.tlf13,   #異動命令
                     refer1    LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16) 
                     refer2    LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16) 
                     refer3    LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16) 
                     refer4    LIKE tlf_file.tlf026   #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)  
                     END RECORD, 
                     l_i,l_item    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
     CALL cl_del_data(l_table)                        #No.FUN-780012
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-780012 --start-- mark--
#     IF tm.a  = '1' THEN 
#          LET g_date = g_x[11] clipped,tm.tlf06_b,'-',tm.tlf06_e
#     ELSE LET g_date = g_x[12] clipped,tm.tlf07_b,'-',tm.tlf07_e
#     END IF
#     FOR g_i = 1 TO 3
#       CASE WHEN tm.s[g_i,g_i] = '1' 
#                LET g_order = g_order clipped,' ',g_x[19]
#            WHEN tm.s[g_i,g_i] = '2' 
#                LET g_order = g_order clipped,' ',g_x[20]
#            WHEN tm.s[g_i,g_i] = '3' 
#                LET g_order = g_order clipped,' ',g_x[21]
#            WHEN tm.s[g_i,g_i] = '4' 
#                LET g_order = g_order clipped,' ',g_x[22]
#            WHEN tm.s[g_i,g_i] = '5' 
#                LET g_order = g_order clipped,' ',g_x[23]
#            WHEN tm.s[g_i,g_i] = '6' 
#                LET g_order = g_order clipped,' ',g_x[24]
#            OTHERWISE LET g_order = g_order clipped
#       END CASE
#    END FOR
    #No.FUN-780012 --end--
      LET g_prog= 'aimr200' #MOD-530313 add
#     CALL cl_outnam('aimr200') RETURNING l_name   #No.FUN-780012
      IF cl_null(g_program) THEN LET g_program='aimr200' END IF ##TQC-6A0078
      LET l_name = g_program CLIPPED,l_name[8,11]  #MOD-530484
      LET g_xml_rep = l_name CLIPPED,".xml"    #MOD-530484
      CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED)) #MOD-530484
#     START REPORT r200_rep TO l_name              #No.FUN-780012
#     LET g_pageno = 0                             #No.FUN-780012
 
#*****************************************************************************#
#------->因tlf_file 已做分割處理,因此資料來源不只是從tlf_file來<--------------#
#*****************************************************************************#
 
     IF g_gettlf[1].tbname IS NULL OR g_gettlf[1].tbname=' '
        THEN LET g_gettlf[1].tbname='tlf_file'
     END IF
     IF tm.tlf06_b IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf06 >=","'",tm.tlf06_b,"'"
     END IF
     IF tm.tlf06_e IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf06 <=","'",tm.tlf06_e,"'"
     END IF
     IF tm.tlf07_b IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf07 >=","'",tm.tlf07_b,"'"
     END IF
     IF tm.tlf07_e IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf07 <=","'",tm.tlf07_e,"'"
     END IF
   FOR  l_i=1  TO 70      #最多70期
     IF g_gettlf[l_i].tbname IS NULL OR g_gettlf[l_i].tbname=' '
        THEN EXIT FOR
     END IF
 
     IF g_sma.sma12 MATCHES '[nN]'  #single warehouse
       THEN LET l_sql=
                  " SELECT ",g_gettlf[l_i].tbname CLIPPED,
                  ".*,imd02,ima02,ima021,ima15 ", #FUN-510017 add ima021   #TQC-CC0047--add--''
                  " FROM ",g_gettlf[l_i].tbname,",OUTER  ima_file,OUTER imd_file",
                  " WHERE tlf_file.tlf01=ima_file.ima01 ", 
                  "   AND tlf_file.tlf021 = imd_file.imd01",     #TQC-CC0047--add-
                  "   AND ",tm.wc CLIPPED," ",g_wc CLIPPED
 
        ELSE                        #multi warehouse
        #*********************************************************************#
        #    multi warehous                                                   #
        #*********************************************************************#
        LET l_sql = 
                 " SELECT ",g_gettlf[l_i].tbname CLIPPED,".*,",
                 " imd02,ima02,ima021,ima15", #FUN-510017 add ima021  #TQC-CC0047--add--''
                 " FROM ",g_gettlf[l_i].tbname,",OUTER  ima_file ,OUTER imd_file",
                 " WHERE tlf_file.tlf01=ima_file.ima01 ",  
                  "   AND tlf_file.tlf021 = imd_file.imd01",     #TQC-CC0047--add-
                 "   AND ",tm.wc CLIPPED ," ",g_wc CLIPPED
    END IF
    DISPLAY "l_sql:",l_sql
 
     PREPARE r200_prepare1 FROM l_sql 
     IF SQLCA.sqlcode != 0 
         THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
              EXIT PROGRAM 
     END IF
     DECLARE r200_curs1 CURSOR FOR r200_prepare1
 
     FOREACH r200_curs1 INTO sr.* 
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       LET sr2.tlf11 = sr.tlf.tlf11
       LET sr2.tlf10 = sr.tlf.tlf10
       LET sr2.ima02 = sr.ima02
       LET sr2.ima021= sr.ima021 #FUN-510017
       LET sr2.imd02 = sr.imd02  #TQC-CC0047--add
       LET sr2.ima15 = sr.ima15
       LET sr2.tlf01 = sr.tlf.tlf01
       LET sr2.tlf02 = sr.tlf.tlf02
       LET sr2.tlf03 = sr.tlf.tlf03
       LET sr2.tlf13 = sr.tlf.tlf13
       IF tm.a = '1' 
       THEN LET sr2.date = sr.tlf.tlf06    #單號日期
       ELSE LET sr2.date = sr.tlf.tlf07    #產生日期
       END IF
       IF g_code > 20 THEN     #出庫(來源)
     #Modify:2877---------- 
        #  LET sr2.no       = sr.tlf.tlf026,'-',sr.tlf.tlf027 using'##'
          #LET sr2.no        = sr.tlf.tlf026,'-',sr.tlf.tlf027 using'###'#TQC-5B0142 mark
          #TQC-5B0142 add
          IF NOT cl_null(sr.tlf.tlf027) THEN
             LET sr2.no = sr.tlf.tlf026 CLIPPED,'-',sr.tlf.tlf027 CLIPPED using'###'
          ELSE
             LET sr2.no = sr.tlf.tlf026 CLIPPED
          END IF
          #TQC-5B0142 end
         #start FUN-5B0047
         #LET sr2.stock     = sr.tlf.tlf021
         #LET sr2.ware      = sr.tlf.tlf022
         #LET sr2.location  = sr.tlf.tlf023
          IF sr2.tlf13 = 'aimp880' THEN   #倉庫→實地盤點
             LET sr2.no = sr.tlf.tlf026,'-',sr.tlf.tlf027 using'###'
            #MOD-920241-begin-modify
             #IF NOT cl_null(sr.tlf.tlf021) THEN
             #   LET sr2.stock  = sr.tlf.tlf021
             #ELSE
             #   LET sr2.stock  = sr.tlf.tlf031
             #END IF
             #LET sr2.ware      = sr.tlf.tlf022
             #LET sr2.location  = sr.tlf.tlf023
             LET sr2.stock  = sr.tlf.tlf902
             LET sr2.imd02  = sr.imd02   #TQC-CC0047--add
             LET sr2.ware      = sr.tlf.tlf903
             LET sr2.location  = sr.tlf.tlf904
            #MOD-920241-end-modify
          ELSE
             LET sr2.no = sr.tlf.tlf026,'-',sr.tlf.tlf027 using'###'
            #MOD-920241-begin-modify
             #LET sr2.stock     = sr.tlf.tlf021
             #LET sr2.ware      = sr.tlf.tlf022
             #LET sr2.location  = sr.tlf.tlf023
             LET sr2.stock  = sr.tlf.tlf902
             LET sr2.imd02  = sr.imd02   #TQC-CC0047--add
             LET sr2.ware      = sr.tlf.tlf903
             LET sr2.location  = sr.tlf.tlf904
            #MOD-920241-end-modify
          END IF
         #end FUN-5B0047
       ELSE                    #入庫(目的)
          IF sr2.tlf13 ='asft660' THEN 
          #   LET sr2.no       = sr.tlf.tlf026,'-',sr.tlf.tlf027 using'##'
             #LET sr2.no       = sr.tlf.tlf026,'-',sr.tlf.tlf027 using'###'#TQC-5B0142 mark
             #TQC-5B0142 add
             IF NOT cl_null(sr.tlf.tlf027) THEN
                LET sr2.no = sr.tlf.tlf026 CLIPPED,'-',sr.tlf.tlf027 CLIPPED using'###'
             ELSE
                LET sr2.no = sr.tlf.tlf026 CLIPPED
             END IF
             #TQC-5B0142 end
            #MOD-920241-begin-modify
             #LET sr2.stock    = sr.tlf.tlf021 
             #LET sr2.ware = sr.tlf.tlf022
             #LET sr2.location     = sr.tlf.tlf023
             LET sr2.stock  = sr.tlf.tlf902
             LET sr2.imd02  = sr.imd02   #TQC-CC0047--add
             LET sr2.ware      = sr.tlf.tlf903
             LET sr2.location  = sr.tlf.tlf904
            #MOD-920241-end-modify
             LET sr2.tlf10    = sr.tlf.tlf10 * -1
          ELSE 
           #  LET sr2.no       = sr.tlf.tlf036,'-',sr.tlf.tlf037 using'##'
             #LET sr2.no       = sr.tlf.tlf036,'-',sr.tlf.tlf037 using'###' #TQC-5B0142 mark
             #TQC-5B0142 add
             IF NOT cl_null(sr.tlf.tlf037) THEN
                LET sr2.no = sr.tlf.tlf036 CLIPPED,'-',sr.tlf.tlf037 CLIPPED using'###'
             ELSE
                LET sr2.no = sr.tlf.tlf036 CLIPPED
             END IF
             #TQC-5B0142 end
            #MOD-920241-begin-modify
             #LET sr2.stock    = sr.tlf.tlf031 
             #LET sr2.ware = sr.tlf.tlf032
             #LET sr2.location     = sr.tlf.tlf033
             LET sr2.stock  = sr.tlf.tlf902
             LET sr2.imd02  = sr.imd02   #TQC-CC0047--add
             LET sr2.ware      = sr.tlf.tlf903
             LET sr2.location  = sr.tlf.tlf904
            #MOD-920241-end-modify
          END IF
       END IF
       #No.FUN-780012 --start-- mark
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr2.no  
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr2.date 
#                                                           USING 'yyyymmdd'
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr2.stock
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr2.ware
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr2.tlf01
#               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.tlf13
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr2.order1 = l_order[1]
#       LET sr2.order2 = l_order[2]
#       LET sr2.order3 = l_order[3]
#       LET sr2.refer1 = ' '  LET sr2.refer2 =''
#       LET sr2.refer3 = ' '  LET sr2.refer4 =''
       #No.FUN-780012 --end--
       CASE g_code 
        WHEN  1         LET sr2.refer1 = sr.tlf.tlf026
                        SELECT sfb22,sfb82 INTO sr2.refer3,sr2.refer2
                          FROM sfb_file WHERE sfb01=sr.tlf.tlf026
        WHEN  2         LET sr2.refer1 = sr.tlf.tlf026
                        SELECT sfb22,sfb82 INTO sr2.refer3,sr2.refer2
                          FROM sfb_file,sfv_file
                         WHERE sfb01=sfv11 AND sfv01=sr.tlf.tlf026
                       IF STATUS THEN LET sr2.refer3='' LET sr2.refer2='' END IF
        WHEN  3         LET sr2.refer1 = sr.tlf.tlf026
                        LET sr2.refer2 = sr.tlf.tlf19
                        LET sr2.refer3 = sr.tlf.tlf62
        WHEN  4         LET sr2.refer1 = sr.tlf.tlf026     #驗收入庫
                        LET sr2.refer2 = sr.tlf.tlf19 
                        SELECT rvb03,rvb04 INTO l_item,sr2.refer3
                          FROM rvb_file 
                         WHERE rvb01=sr.tlf.tlf026 
                           AND rvb02=sr.tlf.tlf027
                        IF sr2.refer3 IS NOT NULL THEN 
                           SELECT pmn41 INTO sr2.refer4 
                                        FROM pmn_file  
                                       WHERE pmn01 = sr2.refer3
                                         AND pmn02 = l_item
                        END IF
        WHEN  5         LET sr2.refer1 = sr.tlf.tlf026     #委外驗收入庫
                        LET sr2.refer2 = sr.tlf.tlf19 
                        SELECT rvv18,rvv36 INTO sr2.refer4,sr2.refer3 
                          FROM rvv_file 
                         WHERE rvv04=sr.tlf.tlf026 
                           AND rvv05=sr.tlf.tlf027
        WHEN  6         LET sr2.refer1 = sr.tlf.tlf026 
                        LET sr2.refer2 = sr.tlf.tlf14
        WHEN  7         SELECT imn04,imn05,imn06    
                          INTO sr2.refer1,sr2.refer2,sr2.refer3
                          FROM imn_file 
                         WHERE imn01=sr.tlf.tlf036 AND imn02=sr.tlf.tlf037
                        IF STATUS THEN 
                           LET sr2.refer1='' LET sr2.refer2='' LET sr2.refer3=''
                        END IF
        WHEN  8         SELECT ogb09,ogb091,ogb092 
                          INTO sr2.refer1,sr2.refer2,sr2.refer3
                          FROM ohb_file,ogb_file 
                         WHERE ohb01=sr.tlf.tlf026 AND ohb03=sr.tlf.tlf027
                           AND ohb31=ogb01 AND ohb32=ogb03
                        IF STATUS THEN 
                           LET sr2.refer1='' LET sr2.refer2='' LET sr2.refer3=''
                        END IF
        WHEN  9         LET sr2.refer1 = sr.tlf.tlf020 
                        LET sr2.refer2 = sr.tlf.tlf026
                        SELECT ims03 INTO sr2.refer3  FROM ims_file 
                                     WHERE ims01=sr.tlf.tlf026 
                                       AND ims02=sr.tlf.tlf027 
 
        #出庫狀況
        WHEN 21         LET sr2.refer1 = sr.tlf.tlf036 
                        SELECT sfb22,sfb82 INTO sr2.refer3,sr2.refer2
                          FROM sfb_file WHERE sfb01=sr.tlf.tlf036
        WHEN 23         LET sr2.refer1 = sr.tlf.tlf036 
                        SELECT sfb22,sfb82 INTO sr2.refer3,sr2.refer2
                          FROM sfb_file WHERE sfb01=sr.tlf.tlf036
        WHEN 24         LET sr2.refer2 = sr.tlf.tlf19
                        LET sr2.refer1 = sr.tlf.tlf036
                        SELECT rvv36 
                          INTO sr2.refer3 FROM rvv_file 
                         WHERE rvv01 = sr.tlf.tlf026
                           AND rvv02 = sr.tlf.tlf027
        WHEN 25         LET sr2.refer1 = sr.tlf.tlf036
                        LET sr2.refer2 = sr.tlf.tlf14
        WHEN 26         LET sr2.refer1 = sr.tlf.tlf036
                        LET sr2.refer2 = sr.tlf.tlf14
        WHEN 27         SELECT imn15,imn16,imn17    
                          INTO sr2.refer1,sr2.refer2,sr2.refer3
                          FROM imn_file 
                         WHERE imn01=sr.tlf.tlf026 AND imn02=sr.tlf.tlf027
                        IF STATUS THEN 
                           LET sr2.refer1='' LET sr2.refer2='' LET sr2.refer3=''
                        END IF
        WHEN 28         SELECT ogb31 INTO sr2.refer1 FROM ogb_file 
                               WHERE ogb01 =sr.tlf.tlf026 
                                 AND ogb03 =sr.tlf.tlf027
                        IF STATUS THEN LET sr2.refer1='' END IF
                        LET sr2.refer2 = sr.tlf.tlf19
        WHEN 29         LET sr2.refer1 = sr.tlf.tlf026 
                        LET sr2.refer2 = sr.tlf.tlf14
        WHEN 31         LET sr2.refer1 = sr.tlf.tlf030 
                        LET sr2.refer2 = sr.tlf.tlf036
   END CASE
#      OUTPUT TO REPORT r200_rep(sr2.*)               #No.FUN-780012
#No.FUN-780012 --start--
       IF (tm.b ='2' AND ((sr2.location is not null AND sr2.location != ' ') OR  
                         (sr2.refer3 is not null AND sr2.refer3 != ' ') OR      
                         (sr2.refer4 is not null AND sr2.refer4 != ' ')))       
          OR tm.b = '3' THEN  
          EXECUTE insert_prep USING sr2.no,sr2.date,sr2.stock,sr2.imd02,sr2.location,#TQC-CC0047--add
                                    sr2.ware,sr2.tlf01,sr2.ima02,sr2.ima021,
                                    sr2.tlf11,sr2.tlf10,sr2.refer1,sr2.refer2,
                                    sr2.refer3,sr2.refer4,sr2.ima15,sr2.tlf13
       ELSE 
          EXECUTE insert_prep USING sr2.no,sr2.date,sr2.stock,sr2.imd02,'',    #TQC-CC0047--add 
                                    sr2.ware,sr2.tlf01,sr2.ima02,'',        
                                    sr2.tlf11,sr2.tlf10,sr2.refer1,sr2.refer2,  
                                    '','',sr2.ima15,sr2.tlf13    
       END IF
#No.FUN-780012 --end--  
     END FOREACH
  END FOR 
#     FINISH REPORT r200_rep                       #No.FUN-780012
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-780012
#No.FUN-780012 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN
      #CALL cl_wcchp(tm.wc,'tlf036,tlf021,tlf022,tlf023,tlf031,tlf032,tlf033,  #MOD-920241 mark
      CALL cl_wcchp(tm.wc,'tlf036,tlf021,tlf022,tlf023,tlf902,tlf903,tlf904,tlf026,tlf13,tlf01,ima08,ima06,tlf06,tlf06,tlf07,tlf07')
           RETURNING tm.wc  
      LET l_str = tm.wc
    END IF
    LET l_str = l_str,";",g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
                tm.u[2,2],";",tm.u[3,3],";",tm.b
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('aimr200','aimr200',l_sql,l_str)
#No.FUN-780012 --end--
      LET g_prog=g_program  #MOD-530313 add
END FUNCTION
#No.FUN-780012 --start-- mark
{REPORT r200_rep(sr2)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr2        RECORD       
                     order1    LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2    LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3    LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     no        LIKE type_file.chr20,   #單據編號 #TQC-5B0142 14->20 #No.FUN-690026 VARCHAR(20)
                     item      LIKE tlf_file.tlf027,   #項次     
                     date      LIKE tlf_file.tlf07,    #日期
                     stock     LIKE tlf_file.tlf021,   #倉庫編號
                     imd02     LIKE imd_file.imd02,    #TQC-CC0047--add
                     ware      LIKE tlf_file.tlf022,   #儲位
                     location  LIKE tlf_file.tlf023,   #批號
                     tlf01     LIKE tlf_file.tlf01,    #料件編號
                     ima02     LIKE ima_file.ima02,    #品名規格
                     ima021    LIKE ima_file.ima021,   #FUN-510017
                     ima15     LIKE ima_file.ima15,    #保稅否
                     tlf11     LIKE tlf_file.tlf11,    #異動單位
                     tlf10     LIKE tlf_file.tlf10,    #異動數量
                     tlf02     LIKE tlf_file.tlf02,    #來源狀況 
                     tlf03     LIKE tlf_file.tlf03,    #目的狀況
                     tlf13     LIKE tlf_file.tlf13,    #異動命令
                     refer1    LIKE tlf_file.tlf026,   #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     refer2    LIKE tlf_file.tlf026,   #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     refer3    LIKE tlf_file.tlf026,   #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     refer4    LIKE tlf_file.tlf026    #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     END RECORD,
             l_amt   LIKE tlf_file.tlf10
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr2.order1,sr2.order2,sr2.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT g_str
      PRINT g_dash[1,g_len]  #No.TQC-6A0078
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr2.order1 
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
      IF tm.t[1,1] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr2.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
      IF tm.t[2,2] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr2.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)     #No.TQC-6C0222
      IF tm.t[3,3] = 'Y' AND (PAGENO > 0 OR LINENO > 10)     #No.TQC-6C0222
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      PRINTX name=D1 COLUMN g_c[31],sr2.no,
                     COLUMN g_c[32],sr2.date,
                     COLUMN g_c[33],sr2.stock,
                     COLUMN g_c[34],sr2.ware,
                     COLUMN g_c[35],sr2.tlf01,
                     COLUMN g_c[36],sr2.ima02,
                     COLUMN g_c[37],sr2.tlf11,
                     COLUMN g_c[38],cl_numfor(sr2.tlf10,38,3),
                     #COLUMN g_c[39],sr2.refer1[1,10], #TQC-5B0142 mark
                     COLUMN g_c[39],sr2.refer1 CLIPPED, #TQC-5B0142 add
                     #COLUMN g_c[40],sr2.refer2[1,10], #TQC-5B0142 mark 
                     COLUMN g_c[40],sr2.refer2 CLIPPED, #TQC-5B0142 add
                     COLUMN g_c[41],sr2.ima15
 
      IF (tm.b ='2' AND ((sr2.location is not null AND sr2.location != ' ') OR 
                         (sr2.refer3 is not null AND sr2.refer3 != ' ') OR 
                         (sr2.refer4 is not null AND sr2.refer4 != ' ')))
          OR tm.b = '3' THEN 
          PRINTX name=D2 COLUMN g_c[42],' ',
                         COLUMN g_c[43],' ',
                         COLUMN g_c[44],sr2.location,
                         COLUMN g_c[45],' ',
                         COLUMN g_c[46],' ',
                         COLUMN g_c[47],sr2.ima021,
                         COLUMN g_c[48],' ',
                         COLUMN g_c[49],' ',
                         #COLUMN g_c[50],sr2.refer3[1,10], #TQC-5B0142 mark
                         COLUMN g_c[50],sr2.refer3 CLIPPED, #TQC-5B0142 add  
                         #COLUMN g_c[51],sr2.refer4[1,10]  #TQC-5B0142 add
                         COLUMN g_c[51],sr2.refer4 CLIPPED  #TQC-5B0142 add
      END IF
 
   AFTER GROUP OF sr2.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt = GROUP SUM(sr2.tlf10)
         PRINT COLUMN g_c[36],g_x[18] clipped,
               COLUMN g_c[38],cl_numfor(l_amt,38,3)
      END IF
 
   AFTER GROUP OF sr2.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt = GROUP SUM(sr2.tlf10)
         PRINT COLUMN g_c[36],g_x[18] clipped,
               COLUMN g_c[38],cl_numfor(l_amt,38,3)
      END IF
 
   AFTER GROUP OF sr2.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt = GROUP SUM(sr2.tlf10)
         PRINT COLUMN g_c[36],g_x[18] clipped,
               COLUMN g_c[38],cl_numfor(l_amt,38,3)
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'tlf06,tlf07,tlf026,tlf021,tlf022,tlf023,tlf01')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]  #No.TQC-6A0078
       #TQC-630166
       #       IF tm.wc[001,120] > ' ' THEN            # for 132
       #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
       #       IF tm.wc[121,240] > ' ' THEN
       #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
       #       IF tm.wc[241,300] > ' ' THEN
       #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]  #No.TQC-6A0078
      LET l_last_sw = 'y'
      #PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED     #MOD-530313
       PRINT "(",g_program CLIPPED,")", COLUMN (g_len-9), g_x[7] CLIPPED  #MOD-530313
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]  #No.TQC-6A0078
              #PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED    #MOD-530313
               PRINT "(", g_program CLIPPED,")", COLUMN (g_len-9), g_x[6] CLIPPED #MOD-530313
        ELSE SKIP 2  LINES
      END IF
END REPORT}
#No.FUN-780012 --end--
