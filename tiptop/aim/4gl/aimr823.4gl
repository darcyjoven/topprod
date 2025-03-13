# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr823.4gl
# Descriptions...: 盤點資料清單－現有庫存
# Input parameter: 
# Return code....: 
# Date & Author..: 93/11/09 By Apple
# Modify.........: No.FUN-510017 05/01/27 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0138 05/10/20 By Claire 調整報表格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-570181 06/04/26 By Claire 列印多單位
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.TQC-740117 07/04/19 By claire 單位數量位置錯誤
# Modify.........: No.FUN-7C0007 07/12/06 By baofei  報表輸出至Crystal Reports功能 
# Modify.........: No.FUN-860001 08/06/02 By Sherry 批序號-盤點
# Modify.........: No.MOD-860014 08/06/02 By claire 多單位對應的樣板檔需調整 
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B50008 11/07/07 By Summer temptable欄位名稱不符
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-B70032 11/08/04 By jason 刻號/BIN-盤點
# Modify.........: No.TQC-C40207 12/04/12 By fengrui 修正臨時表命名重複錯誤,規範時間函數開啟
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD                           # Print condition RECORD
              wc   STRING,                     # Where Condition  #TQC-630166
              data     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12),
              choice   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
              user     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
              type     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
              tot      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
              lot      LIKE type_file.chr1,    #No.FUN-860001 VARCHAR(1)
              dot      LIKE type_file.chr1,    #No.FUN-B70032 VARCHAR(1)
              s        LIKE type_file.chr3,    # Order by sequence  #No.FUN-690026 VARCHAR(3)
              t        LIKE type_file.chr3,    # Eject sw  #No.FUN-690026 VARCHAR(3)
              more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
              END RECORD
#       g_str  LIKE zaa_file.zaa08              #No.FUN-690026 VARCHAR(40) #No.FUN-7C0007
 
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_q_point       LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(80)
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       l_table2       STRING, #FUN-860001
       l_table3       STRING, #FUN-B70032
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                       
#No.FUN-7C0007---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo #TQC-C40207 mark 
 
#No.FUN-7C0007---Begin                                                          
   LET g_sql = "pia01.pia_file.pia01,",                                         
               "pia02.pia_file.pia02,",                                         
               "pia03.pia_file.pia03,",                                         
               "pia04.pia_file.pia04,",                                         
               "pia05.pia_file.pia05,",                                         
               "pia09.pia_file.pia09,",    
               "pia10.pia_file.pia10,", 
               "count.pia_file.pia30,",                                      
               "l_piaa09.piaa_file.piaa09,",  
               "l_count1.piaa_file.piaa30,",                                        
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "ima25.ima_file.ima25,",
               "flag.type_file.chr1"                                           
                                                        
   LET l_table = cl_prt_temptable('aimr823',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "pia01.pia_file.pia01,", 
              #CHI-B50008 mod --start--
              #"l_piaa09.piaa_file.piaa09,",  
              #"l_count1.piaa_file.piaa30"    
               "piaa09.piaa_file.piaa09,",  
               "piaa30.piaa_file.piaa30"    
              #CHI-B50008 mod --end--
   LET l_table1 = cl_prt_temptable('aimr8231',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                    
#No.FUN-7C0007---End
   #FUN-860001
   LET g_sql = "pias01.pias_file.pias01,", 
               "pias06.pias_file.pias06,", 
               "pias07.pias_file.pias07,", 
               "l_count1.pias_file.pias09"    
   LET l_table2 = cl_prt_temptable('aimr8232',g_sql) CLIPPED                      
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                                    
   #--
 
   #FUN-B70032 --START--
   LET g_sql = "piad01.piad_file.piad01,", 
               "piad06.piad_file.piad06,", 
               "piad07.piad_file.piad07,", 
               "l_count1.piad_file.piad09"    
   #LET l_table3 = cl_prt_temptable('aimr8232',g_sql) CLIPPED      #TQC-C40207 mark                
   LET l_table3 = cl_prt_temptable('aimr8233',g_sql) CLIPPED       #TQC-C40207 add                
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   #FUN-B70032 --END--
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.data  = ARG_VAL(8)
   LET tm.choice= ARG_VAL(9)
   LET tm.user  = ARG_VAL(10)
   LET tm.type  = ARG_VAL(11)
   LET tm.tot   = ARG_VAL(12)
   LET tm.s     = ARG_VAL(13)
   LET tm.t     = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #TQC-C40207 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r823_tm(0,0)         # Input print condition
      ELSE CALL r823()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r823_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 17 
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r823_w AT p_row,p_col
        WITH FORM "aim/42f/aimr823" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice= '1'
   LET tm.user  = '1'
   LET tm.type  = 'N'
   LET tm.tot   = 'N'
   LET tm.lot   = 'N' #FUN-860001
   LET tm.dot   = 'N' #FUN-B70032
   LET tm.s     = '1'
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

   #FUN-B70032 --START--
   IF NOT s_industry('icd') THEN
      CALL cl_set_comp_visible("dot", FALSE)
   END IF    
   #FUN-B70032 --END--
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pia02,pia03,pia04,pia05,pia01,pia931                   #FUN-930122 Add pia931
 
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
 
 
      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
                       '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED 
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
      LET INT_FLAG = 0 CLOSE WINDOW r823_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.data,tm.choice,tm.user,tm.type,tm.tot,tm.lot,tm.dot, #FUN-860001 #FUN-B70032
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more 
                 WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD choice
         IF tm.choice IS NULL OR tm.choice NOT MATCHES'[123]'
         THEN NEXT FIELD choice
         END IF
 
      AFTER FIELD user  
         IF tm.user   IS NULL OR tm.user   NOT MATCHES'[12]'
         THEN NEXT FIELD user  
         END IF
 
      AFTER FIELD type  
         IF tm.type   IS NULL OR tm.type   NOT MATCHES'[YN]'
         THEN NEXT FIELD type  
         END IF
 
      AFTER FIELD tot   
         IF tm.tot   IS NULL OR tm.tot   NOT MATCHES'[YN]'
         THEN NEXT FIELD tot   
         END IF
 
      #FUN-860001
      AFTER FIELD lot   
         IF tm.lot   IS NULL OR tm.lot   NOT MATCHES'[YN]'
         THEN NEXT FIELD lot   
         END IF
      #--
 
      #FUN-B70032 --START--
      AFTER FIELD dot   
         IF tm.dot IS NULL OR tm.dot NOT MATCHES'[YN]'
         THEN NEXT FIELD dot   
         END IF
      #FUN-B70032 --END--
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r823_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr823'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr823','9031',1)
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
                         " '",tm.data   CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.user   CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #TQC-610072
                         " '",tm.tot CLIPPED,"'",               #TQC-610072
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr823',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r823_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r823()
   ERROR ""
END WHILE
   CLOSE WINDOW r823_w
END FUNCTION
 
FUNCTION r823()
   DEFINE l_name    LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                          # RDSQL STATEMENT     #TQC-630166
          l_cnt     LIKE type_file.num5,             #NO.FUN_7C0007
          l_chr     LIKE type_file.chr1,             #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD 
                    order1 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    order2 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    order3 LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                    pia01  LIKE pia_file.pia01,   #標籤號碼
                    pia02  LIKE pia_file.pia02,   #料件編號
                    pia03  LIKE pia_file.pia03,   #倉庫
                    pia04  LIKE pia_file.pia04,   #儲位
                    pia05  LIKE pia_file.pia05,   #批號
                    pia09  LIKE pia_file.pia09,   #單位
                    pia10  LIKE pia_file.pia10,   #factor
                    pia30  LIKE pia_file.pia30,   #初盤量(一)
                    pia40  LIKE pia_file.pia40,   #初盤量(二)
                    pia50  LIKE pia_file.pia50,   #複盤量(一)
                    pia60  LIKE pia_file.pia60,   #複盤量(二)
                    ima02  LIKE ima_file.ima02,   #品名規格
                    ima021 LIKE ima_file.ima021,   #品名規格
                    ima25  LIKE ima_file.ima25,   #庫存單位
                    count  LIKE pia_file.pia30,
                    flag   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
                    END RECORD,                    
#No.FUN-7C0007---Begin
                   l_piaa09  LIKE piaa_file.piaa09, 
                   l_piaa30  LIKE piaa_file.piaa30,  
                   l_piaa40  LIKE piaa_file.piaa40, 
                   l_piaa50  LIKE piaa_file.piaa50,  
                   l_piaa60  LIKE piaa_file.piaa60, 
                   l_count1  LIKE piaa_file.piaa30,  
                   l_pias06  LIKE pias_file.pias06, #FUN-860001 
                   l_pias07  LIKE pias_file.pias07, #FUN-860001 
                   l_pias09  LIKE pias_file.pias09, #FUN-860001 
                   l_pias30  LIKE pias_file.pias30, #FUN-860001  
                   l_pias40  LIKE pias_file.pias40, #FUN-860001
                   l_pias50  LIKE pias_file.pias50, #FUN-860001 
                   l_pias60  LIKE pias_file.pias60, #FUN-860001
                   l_piad06  LIKE piad_file.piad06, #FUN-B70032 
                   l_piad07  LIKE piad_file.piad07, #FUN-B70032 
                   l_piad09  LIKE piad_file.piad09, #FUN-B70032 
                   l_piad30  LIKE piad_file.piad30, #FUN-B70032  
                   l_piad40  LIKE piad_file.piad40, #FUN-B70032
                   l_piad50  LIKE piad_file.piad50, #FUN-B70032 
                   l_piad60  LIKE piad_file.piad60  #FUN-B70032
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
               " VALUES(?,?,?) "      
   PREPARE insert_prep1 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
   #FUN-860001
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,              
               " VALUES(?,?,?,?) "      
   PREPARE insert_prep2 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
   #--
   #FUN-B70032 --START--   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,              
               " VALUES(?,?,?,?) "      
   PREPARE insert_prep3 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM                         
   END IF     
   #FUN-B70032 --END--
     CALL cl_del_data(l_table)     
     CALL cl_del_data(l_table1)    
     CALL cl_del_data(l_table2) #FUN-860001    
     CALL cl_del_data(l_table3) #FUN-B70032     
#No.FUN-7C0007---End
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-7C0007	
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','',",
                 "pia01, pia02, pia03, pia04,",
                 "pia05, pia09, pia10, pia30, pia40,",
                 "pia50, pia60, ima02, ima021,ima25, '','Y'",
                 "  FROM pia_file ,OUTER ima_file",
                 " WHERE pia_file.pia02=ima_file.ima01",
                 "   AND pia02 IS NOT NULL ",
                 "   AND ",tm.wc
     IF tm.type ='N'
     THEN  CASE tm.choice    
           WHEN  '1'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped, # modi in 98/10/17 NO:2543 
                      #    "AND pia30 IS NOT NULL AND pia30 != ' ' "
                           "AND pia30 IS NOT NULL "
                      ELSE LET l_sql =l_sql clipped,
## No:2892 modify 1998/12/04 -----------------------------------------
#                          "AND pia50 IS NOT NULL AND pia50 != ' ' "
                           "AND pia40 IS NOT NULL "
                      END IF
           WHEN  '2'  IF tm.user = '1'
                      THEN LET l_sql =l_sql clipped,
                      #    "AND pia40 IS NOT NULL AND pia40 != ' ' "
## No:2892 modify 1998/12/04 -----------------------------------------
#                          "AND pia40 IS NOT NULL "
                           "AND pia50 IS NOT NULL "
                      ELSE LET l_sql =l_sql clipped,
                      #    "AND pia60 IS NOT NULL AND pia60 != ' ' "
                           "AND pia60 IS NOT NULL  "
                      END IF
           WHEN  '3' LET l_sql = l_sql clipped,
## No:2892 modify 1998/12/04 -----------------------------------------
#                         " AND (pia30 IS NOT NULL OR pia50 IS NOT NULL) "
                          " AND pia19='Y'"   #已過帳
           OTHERWISE EXIT CASE
           END CASE
     END IF
     PREPARE r823_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r823_curs1 CURSOR FOR r823_prepare1
 
#     LET l_name = 'aimr823.out'
#     CALL cl_outnam('aimr823') RETURNING l_name
    #START REPORT r823_rep TO l_name   #TQC-740117 
 
     #--NO.FUN-570181 START---
#     IF g_sma.sma115 = "Y" THEN
#         LET g_zaa[43].zaa06 = "N"
#         LET g_zaa[44].zaa06 = "N"
#         LET g_zaa[47].zaa06 = "N"     #TQC-740117 add
#     ELSE
#         LET g_zaa[43].zaa06 = "Y"
#         LET g_zaa[44].zaa06 = "Y"
#         LET g_zaa[47].zaa06 = "Y"     #TQC-740117 add
#     END IF
#     CALL cl_prt_pos_len()
     #--NO.FUN-570181 END-----
 
#    START REPORT r823_rep TO l_name   #TQC-740117
 
#     FOR g_i = 1 TO 80 LET g_q_point[g_i,g_i] = '?' END FOR
#      CASE
#       WHEN tm.choice = '1' 
#            LET g_str = g_x[15] clipped
#       WHEN tm.choice = '2' 
#            LET g_str = g_x[16] clipped
#       WHEN tm.choice = '3' 
#            LET g_str = g_x[18] clipped
#       OTHERWISE EXIT CASE
#      END CASE
#     LET g_pageno = 0
     IF g_sma.sma115 = "Y" THEN
         LET l_name = 'aimr823'
     ELSE
         LET l_name = 'aimr823_1'
     END IF
     #LET l_name = 'aimr823'     ##MOD-860014 mark
#No.FUN-7C0007---End 
 
     FOREACH r823_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF tm.user = '1' 
       THEN CASE 
             WHEN tm.choice = '1'
                  LET sr.count = sr.pia30
             WHEN tm.choice = '2'
                  LET sr.count = sr.pia50
             WHEN tm.choice = '3'
                  IF sr.pia50 IS NULL OR sr.pia50 = ' '
                  THEN LET sr.count = sr.pia30
                  ELSE LET sr.count = sr.pia50
                  END IF
             OTHERWISE EXIT CASE
            END CASE
       ELSE CASE
             WHEN tm.choice ='1'
                  LET sr.count = sr.pia40
             WHEN tm.choice ='2'
                  LET sr.count = sr.pia60
             WHEN tm.choice ='3'
                  IF sr.pia50 IS NULL OR sr.pia50 = ' '
                  THEN LET sr.count = sr.pia30
                  ELSE LET sr.count = sr.pia50
                  END IF
             OTHERWISE EXIT CASE
            END CASE
       END IF
       IF sr.count IS NULL THEN LET sr.count = 0 LET sr.flag = 'N' END IF
       IF sr.pia10 IS NULL THEN LET sr.pia10 = 1 END IF
#No.FUN-7C0007---Begin
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pia02
#                                        LET l_orderA[g_i] =g_x[52]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pia03
#                                        LET l_orderA[g_i] =g_x[53]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pia04
#                                        LET l_orderA[g_i] =g_x[54]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pia05
#                                        LET l_orderA[g_i] =g_x[55]    #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pia01
#                                        LET l_orderA[g_i] =g_x[56]    #TQC-6A0088
#               OTHERWISE LET l_order[g_i] = '-'
#                                        LET l_orderA[g_i] =''    #TQC-6A0088
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
      IF g_sma.sma115='Y' THEN
            LET l_cnt = 0
            LET l_sql = "SELECT piaa09,piaa30,piaa40,piaa50,piaa60 ",
                        "  FROM piaa_file ",
                        " WHERE piaa01= '",sr.pia01,"'"
            PREPARE r823_piaa_p FROM l_sql
            IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
                EXIT PROGRAM 
                   
            END IF
            DECLARE r823_piaa_c CURSOR FOR r823_piaa_p
            FOREACH r823_piaa_c INTO l_piaa09,l_piaa30,l_piaa40,l_piaa50,l_piaa60 
            IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
            END IF
            LET l_cnt = l_cnt + 1
 
            IF tm.user = '1' 
            THEN CASE 
                 WHEN tm.choice = '1'
                      LET l_count1 = l_piaa30
                 WHEN tm.choice = '2'
                      LET l_count1 = l_piaa50
                 WHEN tm.choice = '3'
                      IF l_piaa50 IS NULL OR l_piaa50 = ' '
                      THEN LET l_count1 = l_piaa30
                      ELSE LET l_count1 = l_piaa50
                      END IF
                 OTHERWISE EXIT CASE
                 END CASE
            ELSE CASE
                 WHEN tm.choice ='1'
                      LET l_count1 = l_piaa40
                 WHEN tm.choice ='2'
                      LET l_count1 = l_piaa60
                 WHEN tm.choice ='3'
                      IF l_piaa50 IS NULL OR l_piaa50 = ' '
                      THEN LET l_count1 = l_piaa30
                      ELSE LET l_count1 = l_piaa50
                      END IF
                 OTHERWISE EXIT CASE
            END CASE
            END IF
            EXECUTE insert_prep1 USING  sr.pia01,l_piaa09,l_count1
            END FOREACH
 
      END IF
      #FUN-860001
      IF tm.lot='Y' THEN
            LET l_cnt = 0
            LET l_sql = "SELECT pias06,pias07,pias09,pias30,pias40,pias50,pias60 ",
                        "  FROM pias_file ",
                        " WHERE pias01= '",sr.pia01,"'"
            PREPARE r823_pias_p FROM l_sql
            IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
                EXIT PROGRAM 
                   
            END IF
            DECLARE r823_pias_c CURSOR FOR r823_pias_p
            FOREACH r823_pias_c INTO l_pias06,l_pias07,
                   l_pias09,l_pias30,l_pias40,l_pias50,l_pias60 
            IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
            END IF
            LET l_cnt = l_cnt + 1
 
            IF tm.user = '1' 
            THEN CASE 
                 WHEN tm.choice = '1'
                      LET l_count1 = l_pias30
                 WHEN tm.choice = '2'
                      LET l_count1 = l_pias50
                 WHEN tm.choice = '3'
                      IF l_pias50 IS NULL OR l_pias50 = ' '
                      THEN LET l_count1 = l_pias30
                      ELSE LET l_count1 = l_pias50
                      END IF
                 OTHERWISE EXIT CASE
                 END CASE
            ELSE CASE
                 WHEN tm.choice ='1'
                      LET l_count1 = l_pias40
                 WHEN tm.choice ='2'
                      LET l_count1 = l_pias60
                 WHEN tm.choice ='3'
                      IF l_pias50 IS NULL OR l_pias50 = ' '
                      THEN LET l_count1 = l_pias30
                      ELSE LET l_count1 = l_pias50
                      END IF
                 OTHERWISE EXIT CASE
            END CASE
            END IF
            EXECUTE insert_prep2 USING  sr.pia01,l_pias06,l_pias07,l_count1
            END FOREACH
      END IF
      #FUN-860001

      #FUN-B70032 --START--
      IF s_industry('icd') THEN
         IF tm.dot='Y' THEN
            LET l_cnt = 0
            LET l_sql = "SELECT piad06,piad07,piad09,piad30,piad40,piad50,piad60 ",
                        "  FROM piad_file ",
                        " WHERE piad01= '",sr.pia01,"'"
            PREPARE r823_piad_p FROM l_sql
            IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                EXIT PROGRAM
            END IF
            DECLARE r823_piad_c CURSOR FOR r823_piad_p
            FOREACH r823_piad_c INTO l_piad06,l_piad07,
                   l_piad09,l_piad30,l_piad40,l_piad50,l_piad60 
               IF SQLCA.sqlcode != 0 THEN 
                   CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
               END IF
               LET l_cnt = l_cnt + 1
    
               IF tm.user = '1' 
               THEN CASE 
                       WHEN tm.choice = '1'
                            LET l_count1 = l_piad30
                       WHEN tm.choice = '2'
                            LET l_count1 = l_piad50
                       WHEN tm.choice = '3'
                            IF l_piad50 IS NULL OR l_piad50 = ' '
                            THEN LET l_count1 = l_piad30
                            ELSE LET l_count1 = l_piad50
                            END IF
                       OTHERWISE EXIT CASE
                    END CASE
               ELSE CASE
                       WHEN tm.choice ='1'
                            LET l_count1 = l_piad40
                       WHEN tm.choice ='2'
                            LET l_count1 = l_piad60
                       WHEN tm.choice ='3'
                            IF l_piad50 IS NULL OR l_piad50 = ' '
                            THEN LET l_count1 = l_piad30
                            ELSE LET l_count1 = l_piad50
                            END IF
                       OTHERWISE EXIT CASE
                    END CASE
               END IF
               EXECUTE insert_prep3 USING  sr.pia01,l_piad06,l_piad07,l_count1
            END FOREACH
         END IF
      END IF           
      #FUN-B70032 --END--
      EXECUTE insert_prep USING sr.pia01,sr.pia02,sr.pia03,sr.pia04,sr.pia05,sr.pia09,sr.pia10,sr.count,
                                l_piaa09,l_count1,sr.ima02,sr.ima021,sr.ima25,sr.flag
                 
#       OUTPUT TO REPORT r823_rep(sr.*)
#No.FUN-7C0007---End
     END FOREACH
#No.FUN-7C0007---Begin
#     FINISH REPORT r823_rep
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'pia02,pia03,pia04,pia05,pia01,pia931')                 #FUN-930122 Add pia931                        
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.data,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                      tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                      tm.tot,";",g_q_point,";",l_cnt
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED,"|",  
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED,"|",  #FUN-860001
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table3 CLIPPED       #FUN-B70032
   
   CALL cl_prt_cs3('aimr823',l_name,l_sql,g_str) 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0007---END
END FUNCTION
#No.FUN-7C0007---Begin
#REPORT r823_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-690026 VARCHAR(1)
#          l_cnt        LIKE type_file.num5,        #FUN-570181  #No.FUN-690026 SMALLINT
#          l_sql        STRING,                     # RDSQL STATEMENT     #TQC-630166
#         sr           RECORD 
#                      order1 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                      order2 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                      order3 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                      pia01  LIKE pia_file.pia01, #標籤號碼
#                      pia02  LIKE pia_file.pia02, #料件編號
#                      pia03  LIKE pia_file.pia03, #倉庫
#                      pia04  LIKE pia_file.pia04, #儲位
#                      pia05  LIKE pia_file.pia05, #批號
#                      pia09  LIKE pia_file.pia09, #單位
#                      pia10  LIKE pia_file.pia10, #factor
#                      pia30  LIKE pia_file.pia30, #初盤量(一)
#                      pia40  LIKE pia_file.pia40, #初盤量(二)
#                      pia50  LIKE pia_file.pia50, #複盤量(一)
#                      pia60  LIKE pia_file.pia60, #複盤量(二)
#                      ima02  LIKE ima_file.ima02, #品名規格
#                      ima021 LIKE ima_file.ima021,#品名規格
#                      ima25  LIKE ima_file.ima25, #庫存單位
#                      count  LIKE pia_file.pia30,
#                      flag   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#                      END RECORD,
#     l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#     l_piaa09  LIKE piaa_file.piaa09,  #NO.FUN-570181
#     l_piaa30  LIKE piaa_file.piaa30,  #NO.FUN-570181
#     l_piaa40  LIKE piaa_file.piaa40,  #NO.FUN-570181
#     l_piaa50  LIKE piaa_file.piaa50,  #NO.FUN-570181
#     l_piaa60  LIKE piaa_file.piaa60,  #NO.FUN-570181
#     l_count1  LIKE piaa_file.piaa30   #NO.FUN-570181
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.pia02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      #FUN-5A0138 表頭列印位置挪前10碼
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-5+1 ,g_x[1] CLIPPED,g_str CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno" 
#     PRINT g_head CLIPPED,pageno_total     
#     PRINT tm.data
#     PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                      '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED
#     PRINT g_dash
#     #FUN-5A0138-begin
#     #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#     #PRINTX name=H2 g_x[37],g_x[38],g_x[39]
#     #PRINTX name=H3 g_x[40],g_x[41]
#     #FUN-570181-begin
#     #PRINTX name=H1 g_x[31],g_x[33],g_x[34],g_x[39],g_x[35],g_x[36]
#     #PRINTX name=H2 g_x[42],g_x[32]
#     #PRINTX name=H3 g_x[37],g_x[38]
#     PRINTX name=H1 g_x[31],g_x[33],g_x[34],g_x[39],g_x[36],g_x[44],g_x[35] 
#     PRINTX name=H2 g_x[42],g_x[32],g_x[45],g_x[49],g_x[43]
#     PRINTX name=H3 g_x[37],g_x[38],g_x[46],g_x[48],g_x[47]
#     #FUN-570181-end
#     PRINTX name=H4 g_x[40],g_x[41]
#     #FUN-5A0138-end
#     PRINT g_dash1 
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#    #NEED 3 LINES    #FUN-570181 mark
#     PRINTX name=D1 COLUMN g_c[31],sr.pia01,
#                  # COLUMN g_c[32],sr.pia02, #FUN-5A0138
#                    COLUMN g_c[33],sr.pia03,
#                    COLUMN g_c[34],sr.pia04,
#                    COLUMN g_c[39],sr.pia05;   #FUN-5A0138
#          
#           IF sr.flag = 'N' THEN
#               #PRINTX name=D1 COLUMN g_c[35],g_q_point[1,g_w[35]],
#               #               COLUMN g_c[36],sr.pia09
#               PRINTX name=D1 COLUMN g_c[36],sr.pia09 ,
#                              COLUMN g_c[35],g_q_point[1,g_w[35]]
#           ELSE
#               PRINTX name=D1 COLUMN g_c[36],sr.pia09,
#                              COLUMN g_c[35],cl_numfor(sr.count,35,3)
#                              
#           END IF
 
#     #FUN-5A0138-begin
#     #PRINTX name=D2 COLUMN g_c[37],' ',
#     #               COLUMN g_c[38],sr.ima02,
#     #          #    COLUMN g_c[39],sr.pia05   #FUN-5A0138
#     #PRINTX name=D3 COLUMN g_c[40],' ',
#     #               COLUMN g_c[41],sr.ima021
#     PRINTX name=D2 COLUMN g_c[32],sr.pia02;
#     #FUN-5A0138-end
#---NO.FUN-570181 START-----------
#     #PRINTX name=D3 COLUMN g_c[38],sr.ima02
#     LET l_piaa09=' '
#     LET l_count1= 0
#     IF g_sma.sma115='Y' THEN
#           LET l_cnt = 0
#           LET l_sql = "SELECT piaa09,piaa30,piaa40,piaa50,piaa60 ",
#                       "  FROM piaa_file ",
#                       " WHERE piaa01= '",sr.pia01,"'"
#           PREPARE r823_piaa_p FROM l_sql
#           IF SQLCA.sqlcode != 0 THEN 
#               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#               EXIT PROGRAM 
#                  
#           END IF
#           DECLARE r823_piaa_c CURSOR FOR r823_piaa_p
#           FOREACH r823_piaa_c INTO l_piaa09,l_piaa30,l_piaa40,l_piaa50,l_piaa60 
#           IF SQLCA.sqlcode != 0 THEN 
#               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
#           END IF
#           LET l_cnt = l_cnt + 1
#
#           IF tm.user = '1' 
#           THEN CASE 
#                WHEN tm.choice = '1'
#                     LET l_count1 = l_piaa30
#                WHEN tm.choice = '2'
#                     LET l_count1 = l_piaa50
#                WHEN tm.choice = '3'
#                     IF l_piaa50 IS NULL OR l_piaa50 = ' '
#                     THEN LET l_count1 = l_piaa30
#                     ELSE LET l_count1 = l_piaa50
#                     END IF
#                OTHERWISE EXIT CASE
#                END CASE
#           ELSE CASE
#                WHEN tm.choice ='1'
#                     LET l_count1 = l_piaa40
#                WHEN tm.choice ='2'
#                     LET l_count1 = l_piaa60
#                WHEN tm.choice ='3'
#                     IF l_piaa50 IS NULL OR l_piaa50 = ' '
#                     THEN LET l_count1 = l_piaa30
#                     ELSE LET l_count1 = l_piaa50
#                     END IF
#                OTHERWISE EXIT CASE
#           END CASE
#           END IF
#           IF l_cnt = 1  THEN
#              PRINTX name=D2 COLUMN g_c[49],l_piaa09,
#                             COLUMN g_c[43],cl_numfor(l_count1,43,3)
#           END IF
#           END FOREACH
#           IF l_cnt=0 THEN
#               PRINTX name=D2 COLUMN g_c[42],''
#           END IF
#     ELSE 
#          PRINTX name=D2 COLUMN g_c[42],''
#     END IF
#     IF l_cnt<2 THEN 
#        PRINTX name=D3 COLUMN g_c[38],sr.ima02
#     ELSE
#        PRINTX name=D3 COLUMN g_c[38],sr.ima02,
#                       COLUMN g_c[48],l_piaa09,                 
#                       COLUMN g_c[47],cl_numfor(l_count1,47,3)   
#     END IF 
#---NO.FUN-570181 END------------
#     PRINTX name=D4 COLUMN g_c[41],sr.ima021
#          
 
#  AFTER GROUP OF sr.pia02 
#     IF tm.tot = 'Y' THEN
#        PRINTX name=S1 COLUMN g_c[33],g_x[17] CLIPPED,
#                       COLUMN g_c[35],cl_numfor(GROUP SUM(sr.count*sr.pia10),35,3),
#                       COLUMN g_c[36],sr.ima25
#        PRINT ' '
#     END IF
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'pia02,pia03,pia04,pia05,pia01')
#             RETURNING tm.wc
#        PRINT g_dash
##TQC-630166
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-7C0007---End
