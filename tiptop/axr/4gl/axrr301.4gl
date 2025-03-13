# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr301.4gl
# Descriptions...: 應收憑單列印作業
# Date & Author..: 99/08/24 By Carol&Kammy
# Modify.........: No.FUN-4C0100 05/01/26 By Smapmin 調整單價.金額.匯率大小
# Modify.........: No:Bug-530284 05/03/25 By Nicola 傳參數執行
# Modify.........: No.FUN-540057 05/05/09 By vivien 發票號碼調整
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-540059 05/06/19 By wujie 報表調整
# Modify.........: No.FUN-580010 05/08/08 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-580248 05/08/29 By Smapmin 帳款人員和帳款部門欄位列印錯誤
# Modify.........: No.MOD-590392 05/10/07 By Dido 客戶簡稱帶錯欄位
# Modify.........: NO.TQC-5B0125 05/11/23 by yiting 抬頭位置有誤
# Modify.........: No.FUN-5B0139 05/12/05 By ice 有發票待扺時,帳款報表應負值呈現對應的待扺資料
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-660010 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0102 06/11/21 By johnray 報表修改
# Modify.........: No.MOD-6C0104 06/12/19 By Smapmin 發票日期列印錯誤
# Modify.........: No.TQC-6C0139 06/12/25 By Mandy 數量應印小數位數(3位)
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.TQC-770028 07/07/05 By Rayven 制表日期與報表名稱所在的行數顛倒
#                                                   報表中"帳款部門"與"訂金"之間的間距太短
# Modify.........: No.TQC-7A0013 07/10/09 By sherry 報表改由CR輸出 
# Modify.........: No.MOD-7A0191 07/10/30 By Smapmin 單身出貨單號列印有誤
# Modify.........: No.CHI-7A0043 07/10/30 By Smapmin 以子報表呈現分錄資料
# Modify.........: No.CHI-7C0006 07/12/05 By Smapmin 增加規格欄位
# Modify.........: No.MOD-810096 08/01/14 By Smapmin 增加整張單據尾顯示備註
# Modify.........: No.MOD-950032 09/05/08 By lilingyu g_str增加兩個傳參 g_azi03,g_azi4
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-940043 11/11/04 By minpp 整合單據列印EF簽核 
# Modify.........: No.MOD-BB0171 11/11/18 By Polly 備註增加oao04排序
# Modify.........: No.MOD-BB0325 11/12/01 By Dido 取消 tm.f2 改用 tm.f 
# Modify.........: No.TQC-C10039 12/01/16 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc       LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000)
              b        LIKE type_file.chr1,    # 已列印者是否再列印(Y/N) #No.FUN-680123 VARCHAR(1)
              c        LIKE type_file.chr1,    # 是否列印傳票分錄(Y/N) #No.FUN-680123 VARCHAR(1)
              d        LIKE type_file.chr1,    # 是否列印額外備注(Y/N) #No.FUN-680123 VARCHAR(1)
   #          e        VARCHAR(1),                # 是否列印料號品名(Y/N)   #TQC-660010
              f        LIKE type_file.chr20,   # (1)進貨發票 (2)雜項發票 (3)Ｃ．Ｍ. #No.FUN-680123 VARCHAR(15)
              f2       LIKE type_file.chr20,   # (1)進貨發票 (2)雜項發票 (3)Ｃ．Ｍ．#No.FUN-680123 VARCHAR(15) 
              h        LIKE type_file.chr1,    # (1)已確認 (2)未確認 (3)全部  #No.FUN-680123 VARCHAR(1)
              more     LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680123 VARCHAR(1)
              END RECORD,
          tmf1         LIKE gat_file.gat01,    #No.FUN-680123 VARCHAR(15)
           #g_sql       string,                 # RDSQL STATEMENT  #No.FUN-580092 HCN 
          g_tot_bal    LIKE pmc_file.pmc45     # User defined variable #No.FUN-680123 DECIMAL(13,2)
 
 #DEFINE   g_dash3         VARCHAR(400)           #No.FUN-580010   #MOD-580248
 DEFINE   
 	#g_dash3         VARCHAR(500)                    #MOD-580248
	 g_dash3         LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(500)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680123 SMALLINT
#FUN-740009.....begin
DEFINE  g_flag      LIKE type_file.chr1,
        g_bookno1   LIKE aag_file.aag00,
        g_bookno2   LIKE aag_file.aag00
#FUN-740009.....end
#No.TQC-7A0013---Begin                                                          
DEFINE l_table1       STRING, 
       l_table2       STRING,                                                   
       l_table3       STRING,                                                   
       l_table4       STRING,                                                   
       l_table5       STRING,   #CHI-7A0043
       l_table6       STRING,   #MOD-810096
       g_str          STRING,                                                   
       g_sql          STRING                                                    
#No.TQC-7A0013---End     
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #No.TQC-7A0013---Begin                                                       
   LET g_sql = " oma00.oma_file.oma00,", 
               " oma01.oma_file.oma01,",
               " oma23.oma_file.oma23,",
               " oma24.oma_file.oma24,",
               " oma33.oma_file.oma33,",
               " oma02.oma_file.oma02,",
               " oma21.oma_file.oma21,",
               " oma211.oma_file.oma211,",
               " oma13.oma_file.oma13,",
               " oma16.oma_file.oma16,",
               " oma25.oma_file.oma25,",
               " oma26.oma_file.oma26,",
               " oma18.oma_file.oma18,",
               " oma03.oma_file.oma03,",
               " gen02.gen_file.gen02,",
               " oma032.oma_file.oma032,",
               " gem02.gem_file.gem02,",
               " oma52.oma_file.oma52,",
               " oma53.oma_file.oma53,",
               " oma10.oma_file.oma10,",
               " oma58.oma_file.oma58,",
               " oma54.oma_file.oma54,",
               " oma56.oma_file.oma56,",   
               " oma09.oma_file.oma09,",
               " omaconf.oma_file.omaconf,",
               " oma54x.oma_file.oma54x,",
               " oma56x.oma_file.oma56x,",
               " oma32.oma_file.oma32,",
               " omavoid.oma_file.omavoid,",
               " oma54t.oma_file.oma54t,",
               " oma56t.oma_file.oma56t,",
               " oma11.oma_file.oma11,",
               " oma40.oma_file.oma40,",
               " oma55.oma_file.oma55,", 
               " oma57.oma_file.oma57,", 
               " oma12.oma_file.oma12,",
               " omb03.omb_file.omb03,",     
               " omb01.omb_file.omb01,",
               " omb31.omb_file.omb31,",   #MOD-7A0191
               " omb12.omb_file.omb12,",
               " omb13.omb_file.omb13,",
               " omb15.omb_file.omb15,",
               " omb17.omb_file.omb17,",
               " omb04.omb_file.omb04,",
               " omb33.omb_file.omb33,",
               " omb14.omb_file.omb14,",
               " omb16.omb_file.omb16,",
               " omb18.omb_file.omb18,",
               " omb06.omb_file.omb06,", 
               " ima021.ima_file.ima021,",   #CHI-7C0006 
               " omb14t.omb_file.omb14t,",
               " omb16t.omb_file.omb16t,",
               " omb18t.omb_file.omb18t,",
              #-----CHI-7A0043--------- 
               {
               " npq02.npq_file.npq02,",
               " npq03.npq_file.npq03,",
               " npq04.npq_file.npq04,",
               " npq06.npq_file.npq06,",
               " npq07.npq_file.npq07,",
               }
              #-----END CHI-7A0043-----
              #" oao06.oao_file.oao06,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi07.azi_file.azi07,",
               "sign_type.type_file.chr1,",#簽核方式   #No.FUN-940043
               "sign_img.type_file.blob,", #簽核圖檔   #No.FUN-940043
               "sign_show.type_file.chr1,",  #是否顯示簽核資料(Y/N) #No.FUN-940043
               "sign_str.type_file.chr1000"    #TQC-C10039
   LET l_table1 = cl_prt_temptable('axrr3011',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF         
 
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06,",
               "oao04.oao_file.oao04"           #MOD-BB0171 add
 
   LET l_table2 = cl_prt_temptable('axrr3012',g_sql) CLIPPED                      
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "oao01_1.oao_file.oao01,",                                         
               "oao03_1.oao_file.oao03,",                                         
               "oao05_1.oao_file.oao05,",                                         
               "oao06_1.oao_file.oao06,",
               "oao04_1.oao_file.oao04"          #MOD-BB0171 add                                          
                                                                                
   LET l_table3 = cl_prt_temptable('axrr3013',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN EXIT PROGRAM END IF      
 
   LET g_sql = "oao01_2.oao_file.oao01,",                                         
               "oao03_2.oao_file.oao03,",                                         
               "oao05_2.oao_file.oao05,",                                         
               "oao06_2.oao_file.oao06,",
               "oao04_2.oao_file.oao04"          #MOD-BB0171 add                                          
                                                                                
   LET l_table4 = cl_prt_temptable('axrr3014',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN EXIT PROGRAM END IF                          
 
   #-----MOD-810096---------
   LET g_sql = "oao01_3.oao_file.oao01,",                                         
               "oao03_3.oao_file.oao03,",                                         
               "oao05_3.oao_file.oao05,",                                         
               "oao06_3.oao_file.oao06,",
               "oao04_3.oao_file.oao04"          #MOD-BB0171 add                                          
                                                                                
   LET l_table6 = cl_prt_temptable('axrr3016',g_sql) CLIPPED                    
   IF l_table6 = -1 THEN EXIT PROGRAM END IF                          
   #-----END MOD-810096-----
 
   #-----CHI-7A0043---------
   LET g_sql = "npq01.npq_file.npq01,",
               "npq02.npq_file.npq02,",
               "npq03.npq_file.npq03,",
               "npq04.npq_file.npq04,",
               "npq06.npq_file.npq06,",
               "npq07.npq_file.npq07,",
               "azi04.azi_file.azi04"     
   LET l_table5 = cl_prt_temptable('axrr3015',g_sql) CLIPPED
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
   #-----END CHI-7A0043-----
                                        
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
   #            " VALUES(?,?,?,?,?, ?,?,?,?,?, ",                                
   #            "        ?,?,?,?,?, ?,?,?,?,?, ",                                
   #            "        ?,?,?,?,?, ?,?,?,?,?, ",
   #            "        ?,?,?,?,?, ?,?,?,?,?, ", 
   #            "        ?,?,?,?,?, ?,?,?,?,?, ", 
   #            "        ?,?,?,?,?, ?,?,?,? ) "   
                                  
   #PREPARE insert_prep FROM g_sql                                               
   #IF STATUS THEN                                                               
   #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   #END IF                                                                       
   #No.TQC-7A0013--END        
 
 # SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01=g_aza.aza17   #No.CHI-6A0004
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   #-----TQC-660010---------
   LET tm.c  = ARG_VAL(9)
   LET tm.d  = ARG_VAL(10)
   LET tm.f  = ARG_VAL(11)
   LET tm.h  = ARG_VAL(12)
   #-----END TQC-660010-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
    #-----No.MOD-530284-----
   IF cl_null(tm.wc) THEN
      CALL r301_tm(0,0)
   ELSE
      CALL r301()
   END IF
    #-----No.MOD-530284 END-----
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r301_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 15
   ELSE LET p_row = 3 LET p_col = 14
   END IF
 
   OPEN WINDOW r301_w AT p_row,p_col
        WITH FORM "axr/42f/axrr301"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = 'N'
   LET tm.f    = '12.出貨'
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.f    = '12'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma01,oma02,oma03,oma14,oma15,oma24
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

        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oma01)  #genero要改查單據單(未改)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_oma6'
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry()  RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma01
                   NEXT FIELD oma01
              WHEN INFIELD(oma03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma03
              WHEN INFIELD(oma14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma14
                   NEXT FIELD oma14
              WHEN INFIELD(oma15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.plant = g_plant
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma15
                   NEXT FIELD oma15
              END CASE
        #No.FUN-C40001  --End
  END CONSTRUCT

       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r301_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.b,tm.c,tm.d,tm.f,tm.h,tm.more
         WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)
            THEN NEXT FIELD c
         END IF
      AFTER FIELD d
         IF tm.d NOT MATCHES "[YN]" OR cl_null(tm.d)
            THEN NEXT FIELD d
         END IF
     #-MOD-BB0325-mark-
     #AFTER FIELD f
     #   LET tm.f2=tm.f[1,2]
     #   IF tm.f2[1,2] NOT MATCHES '1[1-4]' AND tm.f2[1,2] NOT MATCHES '2[1-5]' AND
     #      tm.f2[1,2] !='31' AND cl_null(tm.f2[1,2])
     #      THEN NEXT FIELD f
     #   END IF
     #-MOD-BB0325-end-
      AFTER FIELD h
         IF tm.h NOT MATCHES "[123]" OR cl_null(tm.h)
            THEN NEXT FIELD h
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
      LET INT_FLAG = 0 CLOSE WINDOW r301_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   # get exec cmd (fglgo xxxx)
             WHERE zz01='axrr301'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr301','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,         # (at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",   #TQC-660010
                         " '",tm.h CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr301',g_time,l_cmd) # Execute cmd at later time
      END IF
      CLOSE WINDOW r301_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r301()
   ERROR ""
END WHILE
   CLOSE WINDOW r301_w
END FUNCTION
 
FUNCTION r301()
   DEFINE 
          l_name    LIKE type_file.chr20,      # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT #No.FUN-680123 VARCHAR(1400)
          l1_sql    LIKE type_file.chr1000,    # No.FUN-5B0139 RDSQL condition  #No.FUN-680123 VARCHAR(200)
          l_chr     LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1)
          l_head    LIKE zaa_file.zaa08,       #No.FUN-680123 VARCHAR(10)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680123 VARCHAR(10)
          sr               RECORD
                                  oma  RECORD LIKE oma_file.*, #應付帳款單頭
                                  omb  RECORD LIKE omb_file.*, #應付帳款單身
                                  azi03 LIKE azi_file.azi03,   #單位小數位數
                                  azi04 LIKE azi_file.azi04,   #金額小數位數
                                  azi05 LIKE azi_file.azi05,   #小計小數位數
                                  azi07 LIKE azi_file.azi07    #匯率小數位數
                        END RECORD,
       #No.TQC-7A0013---Begin 
          sr1              RECORD                                               
                                  npq02 LIKE npq_file.npq02, # 項次             
                                  npq03 LIKE npq_file.npq03, # 科目編號         
                                  npq04 LIKE npq_file.npq04, # 摘要             
                                  npp02 LIKE npp_file.npp02, # 日期  #CHI-7A0043           
                                  npq06 LIKE npq_file.npq06, # 借貸別(1.借/2.貸)
                                  npq07 LIKE npq_file.npq07  # 異動金額         
                        END RECORD,                                             
      l_oao06      LIKE oao_file.oao06,          #備注                            
      l_oao04      LIKE oao_file.oao04,          #MOD-BB0171 add
      l_amt,l_amt2 LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(17,5)   
     #l_rtn        DECIMAL(20,6),                                               
      l_rtn        LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(20,6)   
      l_ome RECORD LIKE ome_file.*,                                             
      l_gem02      LIKE gem_file.gem02,                                         
      l_gen02      LIKE gen_file.gen02,                                         
      l_omb03      LIKE omb_file.omb03,
      l_cnt        LIKE type_file.num5,
      l_ima021     LIKE ima_file.ima021   #CHI-7C0006
 
###No.FUN-940043 START###
     DEFINE            l_img_blob     LIKE type_file.blob
#     DEFINE            l_ii           INTEGER
#     DEFINE            l_key          RECORD                  #主鍵
#                          v1          LIKE oma_file.oma01
#                                      END RECORD
###No.FUN-940043 END### 
     CALL cl_del_data(l_table1)    #No.TQC-7A0013  
     CALL cl_del_data(l_table2)    #No.TQC-7A0013  
     CALL cl_del_data(l_table3)    #No.TQC-7A0013  
     CALL cl_del_data(l_table4)    #No.TQC-7A0013  
     CALL cl_del_data(l_table5)    #CHI-7A0043  
     CALL cl_del_data(l_table6)    #MOD-810096  
     LOCATE l_img_blob IN MEMORY #blob初始化     #FUN-940043 ADD

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ",                                
                 "        ?,?,?,?,?, ?,?,?,?,?, ",                                
                 "        ?,?,?,?,?, ?,?,?,?,?, ",                                
                 "        ?,?,?,?,?, ?,?,?,?,?, ",                                
                 "        ?,?,?,?,?, ?,?,?,?,?, ",                                
                 #"        ?,?,?,?,?, ?,?,?,? ) "     #MOD-7A0191          
                 #"        ?,?,?,?,?, ?,?,?,?,? ) "   #MOD-7A0191  #CHI-7A0043         
                 #"        ?,?,?,?,? ) "    #CHI-7A0043    #CHI-7C0006       
                 "        ?,?,?,?,?, ?,?,?,?, ? ) "  #CHI-7C0006 #FUN-940043 ADD 3?        #TQC-C10039 add 1?
 
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                         
     END IF            
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,            
                 " VALUES(?,?,?,?,? )"      #MOD-BB0171 add 1 ?              
                                                                                
     PREPARE insert_prep1 FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                       
     END IF                    
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,           
                 " VALUES(?,?,?,?,? )"      #MOD-BB0171 add 1 ?
                                                                                
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                      
     END IF        
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,           
                 " VALUES(?,?,?,?,? )"      #MOD-BB0171 add 1 ?
                                                                                
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep3:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                      
     END IF          
 
     #-----MOD-810096---------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,           
                 " VALUES(?,?,?,?,? )"      #MOD-BB0171 add 1 ?
                                                                                
     PREPARE insert_prep5 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep5:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                      
     END IF          
     #-----END MOD-810096-----
 
     #-----CHI-7A0043---------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,           
                 " VALUES(?,?,?,?,?,?,? )"                                            
                                                                                
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep4:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                      
     END IF          
     #-----END CHI-7A0043-----
     #No.TQC-7A0013---End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.TQC-7A0013
     FOR g_i=1 TO g_len LET g_dash3[g_i,g_i]='-' END FOR       #No.FUN-580010
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
     #No.FUN-5B0139 --start--
     LET l_sql = "SELECT ",
                 "  oma_file.*,omb_file.*,azi03, azi04, azi05,azi07 ",
                 "  FROM oma_file, omb_file, azi_file ",
                 " WHERE oma01 = omb_file.omb01 ",
                 "   AND oma23 = azi_file.azi01 "
     IF tm.b = 'N' THEN
        LET l1_sql = " AND (omaprsw = 0 OR omaprsw IS NULL)"
     END IF
    #IF NOT cl_null(tm.f2[1,2]) THEN   #MOD-BB0325 mark
     IF NOT cl_null(tm.f) THEN         #MOD-BB0325
       #LET l1_sql = l1_sql CLIPPED," AND oma00 = '",tm.f2[1,2],"'"   #MOD-BB0325 mark
        LET l1_sql = l1_sql CLIPPED," AND oma00 = '",tm.f,"'"         #MOD-BB0325
     END IF
     IF tm.h = '1' THEN
        LET l1_sql = l1_sql CLIPPED," AND omaconf = 'Y'"
     END IF
     IF tm.h = '2' THEN
        LET l1_sql = l1_sql CLIPPED," AND omaconf = 'N'"
     END IF
     LET l1_sql = l1_sql CLIPPED,"    AND omavoid = 'N' AND ",tm.wc
     LET l_sql = l_sql CLIPPED,l1_sql
     #只有大陸功能才有發票待扺
     IF g_aza.aza26 = '2' THEN
        LET l_sql = l_sql CLIPPED,
                    " UNION ",
                    " SELECT oma_file.*,omb_file.*,azi03, azi04, azi05,azi07 ",
                    "   FROM oma_file,omb_file,oot_file,azi_file  ",
                    "  WHERE oot01 = omb01  ",
                    "    AND oot03 = oma01  ",
                    "    AND oma23 = azi_file.azi01 ",
                    "    AND omb01 IN (SELECT DISTINCT oot01 ",
                    "   FROM oot_file ",
                    "  WHERE oot03 IN (SELECT DISTINCT oma01 ",
                    "   FROM oma_file ",
                    "  WHERE 1=1 ",l1_sql CLIPPED,")) "
     END IF
     #No.FUN-5B0139 --end--
     PREPARE r301_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
           
     END IF
     DECLARE r301_curs1 CURSOR FOR r301_prepare1
     
     #FUN-940043--STR-
     LET l_sql = "SELECT oma01",
                 "  FROM oma_file, omb_file, azi_file ",
                 " WHERE oma_file.oma01 = omb_file.omb01 ",
                 "   AND oma_file.oma23 = azi_file.azi01 "
    IF tm.b = 'N' THEN
        LET l1_sql = " AND (omaprsw = 0 OR omaprsw IS NULL)"
     END IF
     IF NOT cl_null(tm.f2[1,2]) THEN
        LET l1_sql = l1_sql CLIPPED," AND oma00 = '",tm.f2[1,2],"'"
     END IF
     IF tm.h = '1' THEN
        LET l1_sql = l1_sql CLIPPED," AND omaconf = 'Y'"
     END IF
     IF tm.h = '2' THEN
        LET l1_sql = l1_sql CLIPPED," AND omaconf = 'N'"
     END IF
     LET l1_sql = l1_sql CLIPPED,"    AND omavoid = 'N' AND ",tm.wc
     LET l_sql = l_sql CLIPPED,l1_sql
     #只有大陸功能才有發票待扺
     IF g_aza.aza26 = '2' THEN
        LET l_sql = l_sql CLIPPED,
                    " UNION ",
                    " SELECT oma01 ",
                    "   FROM oma_file,omb_file,oot_file,azi_file  ",
                    "  WHERE oot_file.oot01 = omb01  ",
                    "    AND oot_file.oot03 = oma01  ",
                    "    AND oma_file.oma23 = azi_file.azi01 ",
                    "    AND omb_file.omb01 IN (SELECT DISTINCT oot01 ",
                    "   FROM oot_file ",
                    "  WHERE oot03 IN (SELECT DISTINCT oma01 ",
                    "   FROM oma_file ",
                    "  WHERE 1=1 ",l1_sql CLIPPED,")) "
     END IF
     PREPARE r301_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM

     END IF
     DECLARE r301_cs1 CURSOR FOR r301_pr1
     #FUN-940043--END--

      #-->傳票分錄資料(npq_file)
      #-----CHI-7A0043---------
      {
      LET l_sql = " SELECT npq02, npq03, aag02, npq06, npq07 ",   
                  "   FROM npp_file, npq_file, OUTER aag_file ", 
                  "  WHERE npp01 = ? AND npq03=aag_file.aag01 ",
                  "    AND aag00 = ? ",         #FUN-740009
                  "    AND nppsys = 'AP' AND npp00 = 1 AND npq01 = npp01 ",
                  "    AND nppsys=npqsys AND npp00=npq00 AND npp011=npq011"
      }
      LET l_sql = " SELECT npq02, npq03, '', npp02, npq06, npq07 ",   
                  "   FROM npp_file, npq_file ", 
                  "  WHERE npp01 = ? ",
                  "    AND npptype = 0 ",
                  "    AND nppsys = 'AR' AND npp00 = 2 AND npq01 = npp01 ",
                  "    AND nppsys=npqsys AND npp00=npq00 AND npp011=npq011",
                  "    AND npptype = npqtype"
      #-----END CHI-7A0043----- 
      PREPARE r301_pnpq FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('r301_pnpq:',SQLCA.sqlcode,1)
      END IF
      DECLARE r301_cnpq CURSOR FOR r301_pnpq
     
     #No.TQC-7A0013---Begin
     #display "prog:",g_prog
     #CALL cl_outnam('axrr301') RETURNING l_name
     #START REPORT r301_rep TO l_name
     #LET g_pageno = 0
     #No.TQC-7A0013---End
 
     FOREACH r301_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.FUN-5B0139 --start--
       #列印發票待扺資料,用負值呈現
       IF sr.oma.oma01 != sr.omb.omb01 AND NOT cl_null(sr.omb.omb01) THEN
          LET sr.omb.omb03 = g_aza.aza34              #項次不填充,待打印時調整
       END IF
       #No.FUN-5B0139 --end--
       #No.TQC-7A0013---Begin
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oma.oma14  
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oma.oma15
       #-----MOD-810096---------
       #IF tm.d='Y' THEN                                                          
       #   DECLARE oao0_cur CURSOR FOR SELECT oao06 FROM oao_file                 
       #                               WHERE oao01=sr.oma.oma01                   
       #                                 AND oao03=0 AND oao05='1'                
       #                                                                         
       #   FOREACH oao0_cur INTO l_oao06                                          
       #      IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
       #      EXECUTE insert_prep1 USING sr.oma.oma01,sr.omb.omb03,'1',l_oao06  
       #   END FOREACH                                                            
       #END IF                   
       #-----END MOD-810096-----  
 
 
 
       SELECT COUNT(*) INTO g_cnt FROM omb_file WHERE omb01=sr.oma.oma01          
        #No.FUN-5B0139 --start--                                                  
        SELECT COUNT(*) INTO l_cnt                                                
          FROM oma_file                                                           
         WHERE oma01 IN                                                           
       (SELECT DISTINCT oot01                                                     
          FROM oot_file                                                           
         WHERE oot03 = sr.oma.oma01)                                              
        #IF g_cnt > 0  THEN                                                       
        IF g_cnt > 0  OR l_cnt > 0 THEN                                           
           LET l_omb03 = 0     #No.FUN-5B0139 Default項次初值                     
           IF g_cnt = 0 THEN                                                      
              LET l_omb03 = 1  #No.FUN-5B0139 無帳款項次時                        
           END IF        
        END IF
 
      IF g_cnt > 0  OR l_cnt > 0 THEN    #No.FUN-5B0139                         
                                                                                
         #是否列印額外備注                                                      
         IF tm.d='Y' THEN                                                       
           #------------------------MOD-BB0171--add-oao04------------------------start
            DECLARE oao1_cur CURSOR FOR SELECT oao06,oao04 FROM oao_file
                                        WHERE oao01=sr.oma.oma01
                                          AND oao03=sr.omb.omb03 AND oao05='1'

            FOREACH oao1_cur INTO l_oao06,l_oao04
               IF SQLCA.SQLCODE THEN
                  LET l_oao06=' '
                  LET l_oao04=' '
               END IF
               EXECUTE insert_prep2 USING sr.oma.oma01,sr.omb.omb03,'1',l_oao06,l_oao04
            END FOREACH
           #------------------------MOD-BB0171--add-oao04--------------------------end                                                    
         END IF                                                                 
         #No.FUN-5B0139 --start--                                               
         IF sr.oma.oma01 != sr.omb.omb01 AND NOT cl_null(sr.omb.omb01) THEN     
            LET sr.omb.omb01 = sr.oma.oma01                                     
            LET sr.omb.omb03 = l_omb03                                          
            LET l_omb03 = l_omb03 + 1                                           
            LET sr.omb.omb12 = - sr.omb.omb12                                   
            LET sr.omb.omb14 = - sr.omb.omb14                                   
            LET sr.omb.omb16 = - sr.omb.omb16          
            LET sr.omb.omb18 = - sr.omb.omb18                                   
            LET sr.omb.omb14t = - sr.omb.omb14t                                 
            LET sr.omb.omb16t = - sr.omb.omb16t                                 
            LET sr.omb.omb18t = - sr.omb.omb18t                                 
         ELSE                                                                   
            LET l_omb03 =  sr.omb.omb03 + 1                                     
         END IF                
 
         #是否列印額外備注                                                      
         IF tm.d='Y' THEN                                                       
           #------------------------MOD-BB0171--add-oao04------------------------start
            DECLARE oao2_cur CURSOR FOR SELECT oao06,oao04 FROM oao_file
                                        WHERE oao01=sr.oma.oma01
                                          AND oao03=sr.omb.omb03 AND oao05='2'

            FOREACH oao2_cur INTO l_oao06,l_oao04
               IF SQLCA.SQLCODE THEN
                  LET l_oao06=' '
                  LET l_oao04=' '
                END IF
               EXECUTE insert_prep3 USING sr.oma.oma01,sr.omb.omb03,'2',l_oao06,l_oao04
            END FOREACH
           #------------------------MOD-BB0171--add-oao04--------------------------end                                                   
         END IF                                                                 
       END IF
 
      #-----CHI-7A0043---------
      {
      #-->列印傳票分錄                                                          
      IF tm.c = 'Y' THEN                                                        
         LET l_chr = 'Y'                                                        
#FUN-740009.....begin                                                           
         CALL s_get_bookno(YEAR(sr.oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag = '1' THEN                                                   
            CALL cl_err(YEAR(sr.oma.oma02),'aoo-081',1)                         
         END IF                                                                 
#FUN-740009.....end                                                             
         FOREACH r301_cnpq                                                      
         USING sr.oma.oma01,g_bookno1   #FUN-740009 add g_bookno1               
         INTO sr1.*                                                             
            IF SQLCA.sqlcode != 0 THEN                                          
                CALL cl_err('foreach:',SQLCA.sqlcode,0)                         
                EXIT FOREACH                                                    
            END IF                                                              
            IF l_chr = 'Y' THEN                                                 
                LET l_chr = 'N'      
            END IF
         END FOREACH 
      END IF
      }
      #-----END CHI-7A0043-----
       #OUTPUT TO REPORT r301_rep(sr.*)
       #-----CHI-7C0006---------
       LET l_ima021 = ''
       SELECT ima021 INTO l_ima021 FROM ima_file
         WHERE ima01=sr.omb.omb04   
       #-----END CHI-7C0006----- 
       EXECUTE insert_prep USING sr.oma.oma00,sr.oma.oma01,sr.oma.oma23,
                                 sr.oma.oma24,sr.oma.oma33,sr.oma.oma02,
                                 sr.oma.oma21,sr.oma.oma211,sr.oma.oma13,
                                 sr.oma.oma16,sr.oma.oma25,sr.oma.oma26,
                                 sr.oma.oma18,sr.oma.oma03,l_gen02,
                                 sr.oma.oma032,l_gem02,sr.oma.oma52,
                                 sr.oma.oma53,sr.oma.oma10,sr.oma.oma58,
                                 sr.oma.oma54,sr.oma.oma56,sr.oma.oma09,
                                 sr.oma.omaconf,sr.oma.oma54x,sr.oma.oma56x,
                                 sr.oma.oma32,sr.oma.omavoid,sr.oma.oma54t,
                                 sr.oma.oma56t,sr.oma.oma11,sr.oma.oma40,
                                 sr.oma.oma55,sr.oma.oma57,sr.oma.oma12,
                                 #sr.omb.omb03,sr.omb.omb01,sr.omb.omb12,   #MOD-7A0191
                                 sr.omb.omb03,sr.omb.omb01,sr.omb.omb31,sr.omb.omb12,   #MOD-7A0191
                                 sr.omb.omb13,sr.omb.omb15,sr.omb.omb17,
                                 sr.omb.omb04,sr.omb.omb33,sr.omb.omb14,
                                 sr.omb.omb16,sr.omb.omb18, 
                                 #sr.omb.omb06,sr.omb.omb14t,sr.omb.omb16t,   #CHI-7C0006
                                 sr.omb.omb06,l_ima021,sr.omb.omb14t,sr.omb.omb16t,   #CHI-7C0006
                                 #sr.omb.omb18t,sr1.npq02,sr1.npq03,   #CHI-7A0043
                                 #sr1.npq04,sr1.npq06,sr1.npq07,   #CHI-7A0043
                                 sr.omb.omb18t,   #CHI-7A0043
                                 sr.azi03,sr.azi04,sr.azi07,
                                 "",l_img_blob,"N",""   #No.FUN-940043 add  "",l_img_blob,"N"   #TQC-C10039 add ""

       #No.TQC-7A0013---End
       #CALL r301_upd(sr.oma.oma01)   #CHI-7A0043
     END FOREACH
 
      #-----CHI-7A0043---------
      LET l_sql = "SELECT DISTINCT oma01 FROM ",
                   g_cr_db_str CLIPPED,l_table1 CLIPPED
      PREPARE r301_p FROM l_sql
      DECLARE r301_curs CURSOR FOR r301_p
      FOREACH r301_curs INTO sr.oma.oma01
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        CALL r301_upd(sr.oma.oma01)   
        #-->列印傳票分錄                                                          
        IF tm.c = 'Y' THEN                                                        
           FOREACH r301_cnpq USING sr.oma.oma01 INTO sr1.*                                                     
              IF SQLCA.sqlcode != 0 THEN                                          
                  CALL cl_err('foreach:',SQLCA.sqlcode,0)                         
                  EXIT FOREACH                                                    
              END IF                                                              
              CALL s_get_bookno(YEAR(sr1.npp02)) RETURNING 
                   g_flag,g_bookno1,g_bookno2
              IF g_flag = '1' THEN                                                   
                 CALL cl_err(YEAR(sr1.npp02),'aoo-081',1)                         
              END IF                                                                 
              SELECT aag02 INTO sr1.npq04 FROM aag_file
               WHERE aag00=g_bookno1
                 AND aag01=sr1.npq03
              EXECUTE insert_prep4 USING sr.oma.oma01,sr1.npq02,sr1.npq03,sr1.npq04,
                                         sr1.npq06,sr1.npq07,g_azi04       
           END FOREACH 
        END IF
 
        #-----MOD-810096--------- 
        IF tm.d='Y' THEN                                                          
          #------------------------MOD-BB0171--add-oao04------------------------start
           DECLARE oao0_cur CURSOR FOR SELECT oao06,oao04 FROM oao_file
                                       WHERE oao01=sr.oma.oma01
                                         AND oao03=0 AND oao05='1'

           FOREACH oao0_cur INTO l_oao06,l_oao04
              IF SQLCA.SQLCODE THEN
                 LET l_oao06=' '
                 LET l_oao04=' '
              END IF
              EXECUTE insert_prep1 USING sr.oma.oma01,'','1',l_oao06,l_oao04
           END FOREACH

           DECLARE oao3_cur CURSOR FOR SELECT oao06,oao04 FROM oao_file
                                       WHERE oao01=sr.oma.oma01
                                         AND oao03=0 AND oao05='2'

           FOREACH oao3_cur INTO l_oao06,l_oao04
              IF SQLCA.SQLCODE THEN
                 LET l_oao06=' '
                 LET l_oao04=' '
              END IF
              EXECUTE insert_prep5 USING sr.oma.oma01,'','2',l_oao06,l_oao04
           END FOREACH
          #------------------------MOD-BB0171--add-oao04---------------------------end                                                       
        END IF                   
        #-----END MOD-810096-----  
      END FOREACH
      #-----END CHI-7A0043-----
 
     #No.TQC-7A0013---Begin 
     #FINISH REPORT r301_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'oma01,oma02,oma03,oma14,oma15,oma24')
        RETURNING g_str                                                           
     END IF                                                                       
     LET g_str = g_str,";",tm.d,";",tm.c,";",g_cnt,";",l_cnt,";",g_azi03,";",g_azi04  #MOD-950032 add g_azi03,g_azi04
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",             
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",   #CHI-7A0043           
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED   #MOD-810096   

     ###FUN-940043 START ###
     LET g_cr_table = l_table1                 #主報表的temp table名稱
#     LET g_cr_gcx01 = "axri010"               #單別維護程式
     LET g_cr_apr_key_f = "oma01"             #報表主鍵欄位名稱，用"|"隔開
#     LET l_ii = 1
     #報表主鍵值
#     CALL g_cr_apr_key.clear()                #清空
#     FOREACH r301_cs1 INTO l_key.*
#        LET g_cr_apr_key[l_ii].v1 = l_key.v1
#        LET l_ii = l_ii + 1
#     END FOREACH
     ###FUN-940043 END ###
     CALL cl_prt_cs3('axrr301','axrr301',l_sql,g_str)                             
     #No.TQC-7A0013---End 
END FUNCTION
 
FUNCTION r301_upd(l_oma01)
     DEFINE l_oma01 LIKE oma_file.oma01
 
     UPDATE oma_file SET omaprsw = omaprsw + 1 WHERE oma01 = l_oma01
     IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660116
        CALL cl_err3("upd","oma_file",l_oma01,"",SQLCA.sqlcode,"","foreach:",1)   #No.FUN-660116
     END IF
END FUNCTION
 
#No.TQC-7A0013---Begin
{REPORT r301_rep(sr)
   DEFINE 
   	  l_last_sw    LIKE type_file.chr1,                    #No.FUN-680123 VARCHAR(1)
          sr               RECORD
                                  oma  RECORD LIKE oma_file.*, #應付帳款單頭
                                  omb  RECORD LIKE omb_file.*, #應付帳款單身
                                  azi03 LIKE azi_file.azi03,   #單位小數位數
                                  azi04 LIKE azi_file.azi04,   #金額小數位數
                                  azi05 LIKE azi_file.azi05,   #小計小數位數
                                  azi07 LIKE azi_file.azi07    #匯率小數位數
                        END RECORD,
          sr1              RECORD
                                  npq02 LIKE npq_file.npq02, # 項次
                                  npq03 LIKE npq_file.npq03, # 科目編號
                                  npq04 LIKE npq_file.npq04, # 摘要
                                  npq06 LIKE npq_file.npq06, # 借貸別(1.借/2.貸)
                                  npq07 LIKE npq_file.npq07  # 異動金額
                        END RECORD,
      l_oao06      LIKE oao_file.oao06,        #備註
      l_amt,l_amt2 LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(17,5)
     #l_rtn        DECIMAL(20,6),
      l_rtn        LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(20,6)     
      l_ome RECORD LIKE ome_file.*,
      l_gem02      LIKE gem_file.gem02,
      l_gen02      LIKE gen_file.gen02,
      l_omb03      LIKE omb_file.omb03,        #No.FUN-5B0139 記錄帳款單身項次
      l_cnt        LIKE type_file.num5,        #No.FUN-5B0139 是否有發票待扺資料  #No.FUN-680123 SMALLINT
     #l_head       VARCHAR(10),
      l_head       LIKE zaa_file.zaa08,        #No.FUN-680123 VARCHAR(10)
      l_chr        LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.oma.oma01,sr.omb.omb03
  FORMAT
   PAGE HEADER
#No.FUN-580010--start
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total  #No.TQC-770028 mark
      PRINT                              #No.TQC-770028
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#No.FUN-580010--end
#     PRINT ' '                          #No.TQC-770028 mark
      PRINT g_head CLIPPED,pageno_total  #No.TQC-770028
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
 
#NO.FUN540057--begin
   BEFORE GROUP OF sr.oma.oma01
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
      # HEAD LINE 1
      PRINT g_x[11] CLIPPED,sr.oma.oma01,
            #COLUMN 8,g_x[12] CLIPPED,sr.oma.oma23,
            COLUMN 28,g_x[12] CLIPPED,sr.oma.oma23, #NO.TQC-5B0125
            COLUMN 42,g_x[13] CLIPPED,cl_numfor(sr.oma.oma24,10,sr.azi07)CLIPPED,
            COLUMN 64,g_x[14] CLIPPED,sr.oma.oma33 CLIPPED
 
      # HEAD LINE 2
      PRINT g_x[15] CLIPPED,sr.oma.oma02,
            COLUMN 28,g_x[16] CLIPPED,sr.oma.oma21,
            COLUMN 42,g_x[17] CLIPPED,sr.oma.oma211 USING '##.##' CLIPPED,'%',
            COLUMN 64,g_x[18] CLIPPED,sr.oma.oma13
 
      # HEAD LINE 3
      CASE WHEN sr.oma.oma00='11' PRINT g_x[57] CLIPPED,':',sr.oma.oma16;
           WHEN sr.oma.oma00='12' PRINT g_x[58] CLIPPED,':',sr.oma.oma16;
           WHEN sr.oma.oma00='13' PRINT g_x[58] CLIPPED,':',sr.oma.oma16;
           WHEN sr.oma.oma00='21' PRINT g_x[59] CLIPPED,':',sr.oma.oma16;
           OTHERWISE PRINT g_x[60] CLIPPED,':',sr.oma.oma16;
      END CASE
      PRINT COLUMN 28,g_x[21] CLIPPED,sr.oma.oma25,
            COLUMN 42,sr.oma.oma26 CLIPPED,
            COLUMN 64,g_x[22] CLIPPED,sr.oma.oma18
 
      # HEAD LINE 4
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oma.oma14
      PRINT g_x[23] CLIPPED,sr.oma.oma03,
 #            COLUMN 28,g_x[28] CLIPPED,l_gem02   #MOD-580248
             COLUMN 28,g_x[28] CLIPPED,l_gen02   #MOD-580248
 
      # HEAD LINE 5
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oma.oma15
#MOD-590392
      PRINT g_x[27] CLIPPED,sr.oma.oma032,
#     PRINT g_x[27] CLIPPED,sr.oma.oma32,
#MOD-590392 End
 #            COLUMN 28,g_x[31] CLIPPED,l_gen02 CLIPPED,   #MOD-580248
             COLUMN 28,g_x[31] CLIPPED,l_gem02 CLIPPED,   #MOD-580248
#           COLUMN 50,g_x[26] CLIPPED, #No.TQC-770028 mark
            COLUMN 64,g_x[26] CLIPPED, #No.TQC-770028
                   cl_numfor(sr.oma.oma52,18,sr.azi04) CLIPPED,
                   cl_numfor(sr.oma.oma53,18,g_azi04) CLIPPED
 
      # HEAD LINE 6
#No.FUN-540059--begin
      PRINT g_x[30] CLIPPED,sr.oma.oma10 CLIPPED,
            COLUMN 28,g_x[63] CLIPPED,cl_numfor(sr.oma.oma58,10,sr.azi07) CLIPPED,
#No.FUN-540059--end
#           COLUMN 50,g_x[29] CLIPPED, #No.TQC-770028 mark
            COLUMN 64,g_x[29] CLIPPED, #No.TQC-770028
                   cl_numfor(sr.oma.oma54,18,sr.azi04) CLIPPED,
                   cl_numfor(sr.oma.oma56 ,18, g_azi04) CLIPPED
 
      # HEAD LINE 7
      #PRINT g_x[33] CLIPPED,sr.oma.oma08,   #MOD-6C0104
      PRINT g_x[33] CLIPPED,sr.oma.oma09,   #MOD-6C0104
            COLUMN 28,g_x[39] CLIPPED,sr.oma.omaconf CLIPPED,
#           COLUMN 50,g_x[61] CLIPPED, #No.TQC-770028 mark
            COLUMN 64,g_x[61] CLIPPED, #No.TQC-770028
                   cl_numfor(sr.oma.oma54x,18,sr.azi04) CLIPPED,
                   cl_numfor(sr.oma.oma56x ,18, g_azi04) CLIPPED
 
      # HEAD LINE 8
      PRINT g_x[36] CLIPPED,sr.oma.oma32,
            COLUMN 28,g_x[40] CLIPPED,sr.oma.omavoid,
#           COLUMN 50,g_x[38] CLIPPED, #No.TQC-770028 mark
            COLUMN 64,g_x[38] CLIPPED, #No.TQC-770028
                   cl_numfor(sr.oma.oma54t,18,sr.azi04) CLIPPED,
                   cl_numfor(sr.oma.oma56t,18, g_azi04) CLIPPED
 
      # HEAD LINE 9
      PRINT g_x[41] CLIPPED,sr.oma.oma11,
            COLUMN 28,g_x[64] CLIPPED,sr.oma.oma40 CLIPPED,
#           COLUMN 50,g_x[32] CLIPPED, #No.TQC-770028 mark
            COLUMN 64,g_x[32] CLIPPED, #No.TQC-770028
                   cl_numfor(sr.oma.oma55,18,sr.azi04) CLIPPED,
                   cl_numfor(sr.oma.oma57,18, g_azi04) CLIPPED
 
      # HEAD LINE 10
      PRINT g_x[34] CLIPPED,sr.oma.oma12
#NO.FUN540057--end
 
      #是否列印額外備註
      IF tm.d='Y' THEN
         DECLARE oao0_cur CURSOR FOR SELECT oao06 FROM oao_file
                                     WHERE oao01=sr.oma.oma01
                                       AND oao03=0 AND oao05='1'
 
         FOREACH oao0_cur INTO l_oao06
            IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
               IF NOT cl_null(l_oao06) THEN
                  PRINT COLUMN 01,l_oao06
            END IF
         END FOREACH
      END IF
      PRINT g_dash3[1,g_len]                    #No.FUN-580010
 
      CASE WHEN sr.oma.oma00='11' LET l_head=g_x[57]
           WHEN sr.oma.oma00='12' LET l_head=g_x[58]
           WHEN sr.oma.oma00='13' LET l_head=g_x[58]
           WHEN sr.oma.oma00='21' LET l_head=g_x[59]
           OTHERWISE LET l_head=g_x[60]
      END CASE
 
     SELECT COUNT(*) INTO g_cnt FROM omb_file WHERE omb01=sr.oma.oma01
      #No.FUN-5B0139 --start--
      SELECT COUNT(*) INTO l_cnt
        FROM oma_file
       WHERE oma01 IN
     (SELECT DISTINCT oot01
        FROM oot_file
       WHERE oot03 = sr.oma.oma01)
      #IF g_cnt > 0  THEN
      IF g_cnt > 0  OR l_cnt > 0 THEN
         LET l_omb03 = 0     #No.FUN-5B0139 Default項次初值
         IF g_cnt = 0 THEN
            LET l_omb03 = 1  #No.FUN-5B0139 無帳款項次時
         END IF
         #No.FUN-5B0139 --end--
#No.FUN-580010--start
         PRINTX name=H1 g_x[68],g_x[69],g_x[70],g_x[71],g_x[72],g_x[73],g_x[74]
         PRINTX name=H2 g_x[75],g_x[76],g_x[77],g_x[78],g_x[79],g_x[80],g_x[81]
         PRINTX name=H3 g_x[82],g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88]
         PRINT g_dash1 CLIPPED  #No.TQC-6A0102
#No.FUN-580010--end
      END IF
 
 
   ON EVERY ROW
 
#     IF g_cnt > 0  THEN
      IF g_cnt > 0  OR l_cnt > 0 THEN    #No.FUN-5B0139
 
         #是否列印額外備註
         IF tm.d='Y' THEN
            DECLARE oao1_cur CURSOR FOR SELECT oao06 FROM oao_file
                                        WHERE oao01=sr.oma.oma01
                                          AND oao03=sr.omb.omb03 AND oao05='1'
 
            FOREACH oao1_cur INTO l_oao06
               IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
                  IF NOT cl_null(l_oao06) THEN
                     PRINT COLUMN 01,l_oao06
               END IF
            END FOREACH
         END IF
         #No.FUN-5B0139 --start--
         IF sr.oma.oma01 != sr.omb.omb01 AND NOT cl_null(sr.omb.omb01) THEN
            LET sr.omb.omb01 = sr.oma.oma01
            LET sr.omb.omb03 = l_omb03
            LET l_omb03 = l_omb03 + 1
            LET sr.omb.omb12 = - sr.omb.omb12
            LET sr.omb.omb14 = - sr.omb.omb14
            LET sr.omb.omb16 = - sr.omb.omb16
            LET sr.omb.omb18 = - sr.omb.omb18
            LET sr.omb.omb14t = - sr.omb.omb14t
            LET sr.omb.omb16t = - sr.omb.omb16t
            LET sr.omb.omb18t = - sr.omb.omb18t
         ELSE
            LET l_omb03 =  sr.omb.omb03 + 1
         END IF
         #No.FUN-5B0139 --end--
#No.FUN-580010--start
         PRINTX name=D1
               COLUMN g_c[68],sr.omb.omb03 USING "###&", #FUN-590118
               COLUMN g_c[69], sr.omb.omb01 CLIPPED,
              #TQC-6C0139------------mod------------str-------
              #COLUMN g_c[70],cl_numfor(sr.omb.omb12,70,0),
               COLUMN g_c[70],cl_numfor(sr.omb.omb12,70,3),
              #TQC-6C0139------------mod------------end-------
               COLUMN g_c[71],g_x[66] CLIPPED,
               COLUMN g_c[72],cl_numfor(sr.omb.omb13,72,sr.azi03),
               COLUMN g_c[73],cl_numfor(sr.omb.omb15,73,g_azi03),
               COLUMN g_c[74],cl_numfor(sr.omb.omb17,74,g_azi03)
 
         PRINTX name=D2
               COLUMN g_c[76],sr.omb.omb04 CLIPPED,  #No.8818
               COLUMN g_c[77],cl_numfor(sr.omb.omb33,77,0),
               COLUMN g_c[78],g_x[29] CLIPPED,
               COLUMN g_c[79],cl_numfor(sr.omb.omb14,79,sr.azi04),
               COLUMN g_c[80],cl_numfor(sr.omb.omb16,80,g_azi04),
               COLUMN g_c[81],cl_numfor(sr.omb.omb18,81,g_azi04)
         PRINTX name=D3
               COLUMN g_c[83],sr.omb.omb06 CLIPPED,
               COLUMN g_c[85],g_x[38] CLIPPED,
               COLUMN g_c[86],cl_numfor(sr.omb.omb14t,86,sr.azi04),
               COLUMN g_c[87],cl_numfor(sr.omb.omb16t,87,g_azi04),
               COLUMN g_c[88],cl_numfor(sr.omb.omb18t,88,g_azi04)
#No.FUN-580010--end
         #是否列印額外備註
         IF tm.d='Y' THEN
            DECLARE oao2_cur CURSOR FOR SELECT oao06 FROM oao_file
                                        WHERE oao01=sr.oma.oma01
                                          AND oao03=sr.omb.omb03 AND oao05='2'
 
            FOREACH oao2_cur INTO l_oao06
               IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
                  IF NOT cl_null(l_oao06) THEN
                     PRINT COLUMN 01,l_oao06
               END IF
            END FOREACH
         END IF
      END IF
 
   AFTER GROUP OF sr.oma.oma01
      PRINT g_dash2[1,g_len]
 
      #-->列印傳票分錄
      IF tm.c = 'Y' THEN
         LET l_chr = 'Y'
#FUN-740009.....begin
         CALL s_get_bookno(YEAR(sr.oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag = '1' THEN
            CALL cl_err(YEAR(sr.oma.oma02),'aoo-081',1)
         END IF
#FUN-740009.....end
         FOREACH r301_cnpq
         USING sr.oma.oma01,g_bookno1   #FUN-740009 add g_bookno1
         INTO sr1.*
            IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,0)
                EXIT FOREACH
            END IF
            IF l_chr = 'Y' THEN
                LET l_chr = 'N'
                SKIP 1 LINE
                PRINT '----------------------------------------',
                      '----------------------------------------'
                PRINT g_x[48],g_x[49]
                PRINT ' -----   ----------------------- -------',
                      '--------------------- - ----------------'
           END IF
           PRINT ' ',sr1.npq02 USING "####&",
                 COLUMN 10,sr1.npq03 CLIPPED,
                 COLUMN 34,sr1.npq04 CLIPPED,
                 COLUMN 63,sr1.npq06,
                 COLUMN 65,cl_numfor(sr1.npq07,18,g_azi04)
          END FOREACH
      END IF
      LET l_last_sw = 'y'
#     LET g_pageno = 0
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]  #No.TQC-6A0102
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
## FUN-550111
      # LET l_last_sw = 'n'
#      PRINT g_dash[1,g_len]  #No.TQC-6A0102
      #PRINT 10 SPACE,g_x[52] CLIPPED, COLUMN 32,g_x[53] CLIPPED,
      #     COLUMN 55,g_x[54] CLIPPED
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[52]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[52]
             PRINT g_memo
      END IF
## END FUN-550111
 
END REPORT}
#No.TQC-7A0013---End
#Patch....NO.TQC-610037 <> #
