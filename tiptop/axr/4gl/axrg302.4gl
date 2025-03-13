# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrg302.4gl
# Descriptions...: 電子發票套表列印
# Date & Author..: 95/02/07 by Nick
# Modify.........: No.FUN-4C0100 05/01/26 By Smapmin 調整單價.金額.匯率大小
# Modify.........: No.MOD-530092 05/03/14 By cate 報表標題標準化
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-5A0276 05/10/21 By Smapmin 調整SQL語法
# Modify.........: No.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5B0139 05/12/05 By ice 有發票待扺時,報表應負值呈現對應的待扺資料
# Modify.........: No.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-670020 06/07/05 By Smapmin 將訊息以p_ze呈現
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.CHI-6C0007 06/12/18 By jamie 修正_rep( ) l_sql語法
# Modify.........: No.FUN-720053 07/03/01 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-820021 08/02/19 By baofei 插table2資料時少插一個字段
# Modify.........: No.FUN-840088 08/04/18 By zhaijie 修改報表cs3上方sql
# Modify.........: No.CHI-840005 08/04/21 By baofei 改為子報表寫法 
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
# Modify.........: No.CHI-880039 08/09/02 By Sarah CR Temptable欄位數與EXCUTE寫入數量不符
# Modify.........: No.MOD-8C0245 08/12/25 By Sarah 報表中文數字的部份出不來
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理 
# Modify.........: No:CHI-AC0019 10/12/20 By Summer 跳頁異常
# Modify.........: No:FUN-B50018 11/06/01 By xumm  CR轉GRW
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No:FUN-B90130 11/12/12 By wujie  增加oma75的条件 
# Modify.........: No:FUN-C10036 12/01/12 By xuxz MOD-BC0158,MOD-BC0276追單

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
            wc      LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000)
            more    LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
           END RECORD
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE i            LIKE type_file.num5     #No.FUN-680123 SMALLINT
DEFINE l_table1     STRING                  #FUN-720053 add
DEFINE l_table2     STRING                  #FUN-720053 add
DEFINE l_table3     STRING                  #FUN-720053 add
DEFINE g_sql        STRING                  #FUN-720053 add
DEFINE g_str        STRING                  #FUN-720053 add
 
###GENGRE###START
TYPE sr1_t RECORD
    occ18 LIKE occ_file.occ18,
    occ231 LIKE occ_file.occ231,
    ome04 LIKE ome_file.ome04,
    ome042 LIKE ome_file.ome042,
    ome043 LIKE ome_file.ome043,
    ome044 LIKE ome_file.ome044,
    ome02 LIKE ome_file.ome02,
    ome01 LIKE ome_file.ome01,
    ome21 LIKE ome_file.ome21,
    ome39 LIKE ome_file.ome39,
    ome59x LIKE ome_file.ome59x,
    omeprsw LIKE ome_file.omeprsw,
    omb01 LIKE omb_file.omb01,
    omb03 LIKE omb_file.omb03,
    omb04 LIKE omb_file.omb04,
    omb31 LIKE omb_file.omb31,
    omb32 LIKE omb_file.omb32,
    omb06 LIKE omb_file.omb06,
    omb12 LIKE omb_file.omb12,
    omb17 LIKE omb_file.omb17,
    omb18 LIKE omb_file.omb18,
    oma01 LIKE oma_file.oma01,
    oma00 LIKE oma_file.oma00,
    oma08 LIKE oma_file.oma08,
    oma24 LIKE oma_file.oma24,
    oma54t LIKE oma_file.oma54t,
    oma23 LIKE oma_file.oma23,
    occ11 LIKE occ_file.occ11,
    oma66 LIKE oma_file.oma66,
    year LIKE type_file.chr3,
    month LIKE type_file.chr2,
    day LIKE type_file.chr2,
    check1 LIKE type_file.num10,
    oao06 LIKE oao_file.oao06,
    oea10 LIKE oea_file.oea10,
    oeb03 LIKE oeb_file.oeb03,
    tax LIKE type_file.chr1,
    q LIKE omb_file.omb12,
    q2 LIKE omb_file.omb12,
    tot1 LIKE type_file.chr1,
    tot2 LIKE type_file.chr1,
    tot3 LIKE type_file.chr1,
    tot4 LIKE type_file.chr1,
    tot5 LIKE type_file.chr1,
    tot6 LIKE type_file.chr1,
    tot7 LIKE type_file.chr1,
    tot8 LIKE type_file.chr1,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    azi07 LIKE azi_file.azi07,
    l_sub1 LIKE type_file.chr1
END RECORD

TYPE sr2_t RECORD
    ome01 LIKE ome_file.ome01,
    ome39 LIKE ome_file.ome39,
    oma23 LIKE oma_file.oma23,
    oma24 LIKE oma_file.oma24,
    oma54t LIKE oma_file.oma54t,
    azi04 LIKE azi_file.azi04,
    azi07 LIKE azi_file.azi07,
    l_i LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127    #FUN-C10036  mark
#No.FUN-720053--begin
   LET g_sql = "occ18.occ_file.occ18,  occ231.occ_file.occ231,",
               "ome04.ome_file.ome04,  ome042.ome_file.ome042,",
               "ome043.ome_file.ome043,ome044.ome_file.ome044,",
               "ome02.ome_file.ome02,  ome01.ome_file.ome01,",
               "ome21.ome_file.ome21,  ome39.ome_file.ome39,",
               "ome59x.ome_file.ome59x,omeprsw.ome_file.omeprsw,",
               "omb01.omb_file.omb01,  omb03.omb_file.omb03,",
               "omb04.omb_file.omb04,  omb31.omb_file.omb31,",
               "omb32.omb_file.omb32,  omb06.omb_file.omb06,",
               "omb12.omb_file.omb12,  omb17.omb_file.omb17,",
               "omb18.omb_file.omb18,  oma01.oma_file.oma01,",
               "oma00.oma_file.oma00,  oma08.oma_file.oma08,",
               "oma24.oma_file.oma24,  oma54t.oma_file.oma54t,",
               "oma23.oma_file.oma23,  occ11.occ_file.occ11,",
               "oma66.oma_file.oma66,  year.type_file.chr3,",   #FUN-860041 year chr2->chr3
               "month.type_file.chr2,  day.type_file.chr2,",
               "check1.type_file.num10,oao06.oao_file.oao06,",
               "oea10.oea_file.oea10,  oeb03.oeb_file.oeb03,",
               "tax.type_file.chr1,    q.omb_file.omb12,",
               "q2.omb_file.omb12,     tot1.type_file.chr1,",
               "tot2.type_file.chr1,   tot3.type_file.chr1,",
               "tot4.type_file.chr1,   tot5.type_file.chr1,",
               "tot6.type_file.chr1,   tot7.type_file.chr1,",
               "tot8.type_file.chr1,   azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,  azi05.azi_file.azi05,",
               "azi07.azi_file.azi07,  l_sub1.type_file.chr1" #CHI-AC0019 add l_sub1
   LET l_table1= cl_prt_temptable('axrg3021',g_sql) CLIPPED  
   IF l_table1= -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add    #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)   #FUN-B50018  add  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                
 
   LET g_sql = "ome01.ome_file.ome01,  ome39.ome_file.ome39,",
               "oma23.oma_file.oma23,  oma24.oma_file.oma24,",  #No.CHI-840005
               "oma54t.oma_file.oma54t,azi04.azi_file.azi04,",  #No.CHI-840005
               "azi07.azi_file.azi07,  l_i.type_file.num5"      #No.CHI-840005
   LET l_table2= cl_prt_temptable('axrg3022',g_sql) CLIPPED  
   IF l_table2= -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add   #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)   #FUN-B50018  add  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                
#No.FUN-720053--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc)
      THEN CALL axrg302_tm(0,0)                  # Input print condition
      ELSE CALL axrg302()                        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
   CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)
END MAIN
 
FUNCTION axrg302_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 15
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axrg302_w AT p_row,p_col
        WITH FORM "axr/42f/axrg302"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ome212,ome05,ome02,ome00,omeuser,ome01
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
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omeuser', 'omegrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrg302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW axrg302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrg302'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrg302','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrg302',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrg302_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrg302()
   ERROR ""
END WHILE
   CLOSE WINDOW axrg302_w
END FUNCTION
 
FUNCTION axrg302()
   DEFINE 
          l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8       #No.FUN-6A0095
          l_sql     STRING,                       #CHI-6C0007  #No.FUN-680123 VARCHAR(1400)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
         #l_ogb11   VARCHAR(20),
          l_ogb11   LIKE ogb_file.ogb11,          #NO.FUN-5B0015 #No.FUN-680123 VARCHAR(40) 
         #l_ogb04   VARCHAR(20),
          l_ogb04   LIKE ogb_file.ogb04,          #NO.FUN-5B0015 #No.FUN-680123 VARCHAR(40)
          l_oga25   LIKE oga_file.oga25,          #No.FUN-680123 VARCHAR(1)
          l_q       LIKE omb_file.omb12,
          l_q2      LIKE omb_file.omb12,
          l_oea10   LIKE oea_file.oea10,
          l_oeb03   LIKE oeb_file.oeb03,
          l_oao06   LIKE oao_file.oao06,
          sr        RECORD
                    occ18     LIKE occ_file.occ18,
                    occ231    LIKE occ_file.occ231,
                    ome03     LIKE ome_file.ome03,    #No.FUN-B90130
                    ome04     LIKE ome_file.ome04,
                    ome042    LIKE ome_file.ome042,
                    ome043    LIKE ome_file.ome043,
                    ome044    LIKE ome_file.ome044,
                    ome02     LIKE ome_file.ome02,
                    ome01     LIKE ome_file.ome01,
                    ome21     LIKE ome_file.ome21,
                    ome39     LIKE ome_file.ome39,
                    ome59x    LIKE ome_file.ome59x,        #No.FUN-680123 DEC(20,6)
                    omeprsw   LIKE ome_file.omeprsw,
                    omb01     LIKE omb_file.omb01,
                    omb03     LIKE omb_file.omb03,
                    omb04     LIKE omb_file.omb04,
                    omb31     LIKE omb_file.omb31,
                    omb32     LIKE omb_file.omb32,
                    omb06     LIKE omb_file.omb06,
                    omb12     LIKE omb_file.omb12,
                    omb17     LIKE omb_file.omb17,
                    omb18     LIKE omb_file.omb18,
                    oma01     LIKE oma_file.oma01,
                    oma00     LIKE oma_file.oma00,
                    oma08     LIKE oma_file.oma08,
                    oma24     LIKE oma_file.oma24,
                    oma54t    LIKE oma_file.oma54t,
                    oma23     LIKE oma_file.oma23,
                    occ11     LIKE occ_file.occ11,
                    oma66     LIKE oma_file.oma66 
                    END RECORD
#No.FUN-720053--begin
   DEFINE   l_flag     LIKE type_file.chr1,             
	          l_year         LIKE type_file.num10,      
	          l_month        LIKE type_file.num10,      
	          l_day          LIKE type_file.num10,      
	          l_tot          LIKE type_file.chr8,    
            l_omb18   LIKE omb_file.omb18,	
	          l_i	      LIKE type_file.num5,                            
	          l_num          LIKE type_file.num10,       
	          l_str		       LIKE type_file.chr1000,                       
	          l_tax          LIKE type_file.chr1,         
            l_check        LIKE type_file.num10,         #檢查碼 
            l_code1        LIKE type_file.num5,         
            l_code         LIKE type_file.num5,
            l_ome01_t      LIKE ome_file.ome01,         
            l_q3           LIKE type_file.num5,
            n              LIKE type_file.num5         
   DEFINE l_total  ARRAY[8] OF RECORD
                     num  LIKE type_file.chr1
                   END RECORD
   DEFINE l_sub1   LIKE type_file.chr1 #CHI-AC0019 add
 
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?)" #CHI-AC0019 add ?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)   #FUN-B50018  add
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)"   #CHI-880039 add ?
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)   #FUN-B50018  add
      EXIT PROGRAM
   END IF
#No.FUN-720053--end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axrg302'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 #------97/08/04 modify omeconf無此欄位
 # IF g_ooz.ooz18='N' THEN LET tm.wc=tm.wc CLIPPED," AND omeconf='Y'" END IF
#MOD-5A0276
#  LET l_sql=" SELECT occ18,occ231,ome04,ome042,ome043,ome044,ome02,ome01, ",
#            "       ome21,ome39,ome59x,omeprsw,omb01,omb03,omb04,omb31,omb32,omb06,omb12,omb17,omb18,oma01,oma00,oma08,oma24,oma54t,oma23,occ11,oma66 ",
#            "  FROM ome_file,OUTER occ_file,OUTER(oma_file,omb_file) ",
#            " WHERE ome01=oma10 AND oma01=omb01 AND ome04=occ01 ",
#            "   AND ",tm.wc CLIPPED,
#            " ORDER BY ome01 "
   #No.FUN-5B0139 --start--
     LET l_sql="SELECT occ18,occ231,ome03,ome04,ome042,ome043,ome044,ome02,ome01, ",   #No.FUN-B90130              
               "       ome21,ome39,ome59x,omeprsw,omb01,omb03,omb04,omb31, ",
               "       omb32,omb06,omb12,omb17,omb18,oma01,oma00,oma08,    ",
               "       oma24,oma54t,oma23,occ11,oma66 FROM ome_file LEFT OUTER JOIN occ_file ON occ_file.occ01 = ome_file.ome04 ",
               " LEFT OUTER JOIN ( SELECT oma10,omb01,omb03,omb04,omb31,omb32,omb06,omb12, ",
               "          omb17,omb18,oma01,oma00,oma08,oma24,oma54t,oma23,oma66 ",
               "     FROM oma_file,omb_file  WHERE oma01 = omb01) tmp ",
" ON ome_file.ome01=tmp.oma10 WHERE ",tm.wc CLIPPED
   #只有大陸功能才有發票待扺
   IF g_aza.aza26 = '2' THEN
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT occ18,occ231,ome03,ome04,ome042,ome043,ome044,ome02,ome01, ",  #No.FUN-B90130                 
                  "       ome21,ome39,ome59x,omeprsw,omb01,",g_aza.aza34,",omb04,omb31, ",
                  "       omb32,omb06,-omb12,omb17,-omb18,oma01,oma00,oma08,    ",
                  "       oma24,oma54t,oma23,occ11,oma66 ",  
                  "  FROM ome_file LEFT OUTER JOIN occ_file ON occ_file.occ01 = ome_file.ome04,omb_file,oma_file,oot_file  ",
                  " WHERE ome01 = oma10 ",
#                 "   AND ome04 = occ_file.occ01(+) ",
                  "   AND oma01 = oot03 ",
                  "   AND oot01 = omb01 ",
                  "   AND oot01 = omb01 ",
                  "   AND ",tm.wc CLIPPED,
                  "   AND omb01 IN (SELECT UNIQUE oot01 ",
                  "  FROM oot_file ",
                  " WHERE oot03 IN (SELECT UNIQUE oma01 ",
                  "  FROM oma_file ",
                  " WHERE oma10 IN (SELECT UNIQUE ome01 ",
                  "  FROM ome_file ",
                  " WHERE ",tm.wc CLIPPED,"))) "
   END IF
   #No.FUN-5B0139 --end--
#END MOD-5A0276
#  CALL cl_wcshow(l_sql)
   PREPARE axrg302_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   DECLARE axrg302_curs1 CURSOR FOR axrg302_prepare1
 
#No.FUN-720053--begin
#  CALL cl_outnam('axrg302') RETURNING l_name
#  START REPORT axrg302_rep TO l_name
 
   LET g_pageno = 0
#No.FUN-720053--end
   FOREACH axrg302_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.ome04 != 'MISC' THEN
         LET sr.ome042=sr.occ11
         LET sr.ome043=sr.occ18
         LET sr.ome044=sr.occ231
      END IF
     #IF sr.omeprsw > 0 THEN
     #   CONTINUE FOREACH
     #END IF
#No.FUN-720053--begin
#No.CHI-840005---Begin                                                                                                              
      #檢查碼
      IF cl_null(l_ome01_t) OR sr.ome01 <> l_ome01_t THEN                                                                            
         #LET l_q = 1 #FUN-C10036(MOD-BC0276) mark
         LET l_q = 0 #FUN-C10036(MOD-BC0276) add                                                                                                               
         LET l_q2 = 0                                                                                                               
         #LET l_check = 0 #FUN-C10036(MOD-BC0158) mark                                                                                                           
      END IF                                                                                                                         
#No.CHI-840005---End 
      IF g_pageno = 0 THEN
         LET g_pageno= g_pageno+1
         LET l_code1= 9
         END IF     #FUN-B50018
         LET l_check = 0 #FUN-C10036(MOD-BC0158) add
         FOR n=3 TO 10
            LET l_code = sr.ome01[n,n]
            LET l_check=l_check+((l_code*(11-n)/10)+((l_code*(11-n)) mod 10))
         END FOR
         LET l_check=l_check mod 10
         LET l_check=10-l_check
     #END IF          #FUN-B50018 mark
 
      IF sr.ome043 = 'MISC' THEN
#No.FUN-B90130 --begin  
         IF g_aza.aza26 ='2' THEN
            SELECT oma032 INTO sr.ome043
              FROM oma_file
             WHERE oma10 = sr.ome01
               AND oma75 = sr.ome03 
         ELSE
            SELECT oma032 INTO sr.ome043
              FROM oma_file
             WHERE oma10 = sr.ome01
         END IF 
#No.FUN-B90130 --end      
     END IF
 
#FUN-860063-modify
#     LET l_year = YEAR(sr.ome02)-1911 USING '&&'
      LET l_year = YEAR(sr.ome02)-1911 USING '&&&'
#FUN-860063-modify-end
 
      LET l_month= MONTH(sr.ome02) USING '&&'
      LET l_day = DAY(sr.ome02) USING '&&'
#No.CHI-840005---Begin
#     IF cl_null(l_ome01_t) OR sr.ome01 <> l_ome01_t THEN
#        LET l_q = 1
#        LET l_q2 = 0
#        LET l_check = 0
#     END IF
#No.CHI-840005---End
      LET l_ome01_t =sr.ome01
 
      LET l_oao06 = ''
      LET l_oea10 = ''
    
      SELECT count(*) INTO l_q2 FROM omb_file
       WHERE omb01 = sr.omb01
      IF g_aza.aza26 = '2' THEN
         SELECT COUNT(*) INTO l_q3
           FROM omb_file
          WHERE omb01 IN (SELECT UNIQUE oma01
           FROM oma_file
          WHERE oma10 = sr.ome01 AND oma75 = sr.ome03 )  #No.FUN-B90130         
            AND omb01 != sr.omb01
          IF cl_null(l_q3) THEN LET l_q3 = 0 END IF
          LET l_q2 = l_q2 + l_q3
      END IF
 
      SELECT oao06 INTO l_oao06 FROM oao_file
       WHERE oao01 = sr.oma01
         AND oao04 = '1'
 
      IF l_q2 IS NULL THEN LET l_q2 = 0 END IF
      LET g_plant_new=sr.oma66
      CALL s_getdbs()
      IF NOT cl_null(sr.omb32) THEN 
         LET l_sql =
              "SELECT ogb11,ogb04,oea10,oeb03 ",             
#             "  FROM ",g_dbs_new CLIPPED,"ogb_file,",
#             "       ",g_dbs_new CLIPPED,"oea_file,",
#             "       ",g_dbs_new CLIPPED,"oeb_file ",
              "  FROM ", cl_get_target_table(sr.oma66, 'ogb_file'),",",   #NO.FUN-A10098
              cl_get_target_table(sr.oma66, 'oea_file'),",",              #NO.FUN-A10098
              cl_get_target_table(sr.oma66, 'oeb_file'),                  #NO.FUN-A10098
              " WHERE ogb01 = '",sr.omb31,"' ",
              "   AND ogb03 = '",sr.omb32,"' ",
              "   AND oeb01 = ogb31",
              "   AND oeb03 = ogb32",
              "   AND oea01 = oeb01"
       	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,sr.oma66) RETURNING l_sql           #NO.FUN-A10098
          PREPARE g302_pb1 FROM l_sql
          DECLARE g302_bcs1 CURSOR FOR g302_pb1
          OPEN g302_bcs1
          FETCH g302_bcs1 INTO l_ogb11,l_ogb04,l_oea10,l_oeb03
          IF SQLCA.sqlcode THEN
             LET l_ogb11=''
             LET l_ogb04=''
             LET l_oea10=''
             LET l_oeb03=''
          END IF
      END IF 
 
      IF cl_null(l_ogb11) THEN LET l_ogb11 = l_ogb04 END IF
      IF cl_null(l_ogb04) OR cl_null(l_ogb11) THEN
         LET l_ogb11 = sr.omb06
      END IF
      IF sr.omb04 <> 'MISC' THEN
         LET sr.omb06 =l_ogb11[1,20]
      END IF
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07          #幣別檔小數位數讀取
        FROM azi_file
       WHERE azi01=sr.oma23
 
      LET l_q = l_q + 1 
#     LET l_check = 0         #FUN-B50018 mark
      LET l_sub1 = 'N' #CHI-AC0019 add
      IF ( l_q2 MOD 8 ) <> 0 THEN
         FOR i = (l_q2 MOD 8) TO 7
            IF (sr.oma08 = '2' or sr.oma23 <> 'NTD') AND l_q2 <= 4 THEN
               SELECT azi03,azi04,azi05,azi07
                 INTO t_azi03,t_azi04,t_azi05,t_azi07          #幣別檔小數位數讀取
                 FROM azi_file
                WHERE azi01=sr.oma23
#No.CHI-840005---Begin 
#              CASE WHEN i = '1' EXECUTE insert_prep2 USING sr.ome01,sr.oma23,sr.oma54t     #No.FUN-820021
#              CASE WHEN i = '1' EXECUTE insert_prep2 USING sr.ome01,'',sr.oma23,sr.oma54t  #No.FUN-820021 
#                   WHEN i = '2' EXECUTE insert_prep2 USING sr.ome01,'',sr.oma24            #No.FUN-820021 
#                   WHEN i = '2' EXECUTE insert_prep2 USING sr.ome01,'','',sr.oma24         #No.FUN-820021 
#                   WHEN i = '3' EXECUTE insert_prep2 USING sr.ome01,sr.ome39,''            #No.FUN-820021 
#                   WHEN i = '3' EXECUTE insert_prep2 USING sr.ome01,sr.ome39,'',''         #No.FUN-820021  
#                   OTHERWISE    EXECUTE insert_prep2 USING sr.ome01,'',''                  #No.FUN-820021 
#                   OTHERWISE    EXECUTE insert_prep2 USING sr.ome01,'','',''               #No.FUN-820021 
#              END CASE
               CASE WHEN i = '1' EXECUTE insert_prep2 USING
                                    sr.oma01,'',sr.oma23,'',sr.oma54t,
                                    t_azi04,t_azi07,i
                    WHEN i = '2' EXECUTE insert_prep2 USING
                                    sr.oma01,'','',sr.oma24,'',                          
                                    t_azi04,t_azi07,i  
                    WHEN i = '3' EXECUTE insert_prep2 USING
                                    sr.oma01,sr.ome39,'','','',                          
                                    t_azi04,t_azi07,i  
                    OTHERWISE    EXECUTE insert_prep2 USING
                                    sr.oma01,'','','','',                          
                                    t_azi04,t_azi07,i                                           
               END CASE
               LET l_sub1 = 'Y' #CHI-AC0019 add
#No.CHI-840005---End
#           ELSE
#              EXECUTE insert_prep2 USING sr.ome01,'','' #No.FUN-820021 
#              EXECUTE insert_prep2 USING sr.ome01,'','','' #No.FUN-820021  #No.CHI-840005
            END IF
         END FOR
      END IF
 
      SELECT gec06 INTO l_tax FROM gec_file
       WHERE gec01 = sr.ome21
         AND gec011='2'  #銷項
 
     #str MOD-8C0245 add
      IF sr.omb18 IS NULL THEN LET sr.omb18 = 0 END IF
#No.FUN-B90130 --begin
      IF g_aza.aza26 ='2' THEN 
        SELECT SUM(omb18) INTO l_omb18 FROM omb_file,oma_file,ome_file
         WHERE omb01=oma01 AND oma10=ome01 AND ome01 = sr.ome01 AND oma75 = ome03 AND ome03 = sr.ome03 
      ELSE 
        SELECT SUM(omb18) INTO l_omb18 FROM omb_file,oma_file,ome_file
         WHERE omb01=oma01 AND oma10=ome01 AND ome01 = sr.ome01
      END IF  
#No.FUN-B90130 --end      
      IF l_omb18 IS NULL THEN LET l_omb18 = 0 END IF
      LET l_tot = l_omb18+sr.ome59x USING '&&&&&&&&'
      IF cl_null(l_tot) THEN LET l_tot='00000000' END IF
     #end MOD-8C0245 add
      FOR l_i =1 to 8
         LET l_total[l_i].num = l_tot[l_i]
      END FOR
      LET g_i = g_i
      UPDATE ome_file SET omeprsw = omeprsw + 1
       WHERE ome01 = sr.ome01
#     OUTPUT TO REPORT axrg302_rep(sr.*)
      EXECUTE insert_prep1 USING
      #  sr.*,l_year,l_month,l_day,l_check,l_oao06,   #FUN-C10036 mark
         #FUN-C10036-------add---str---
         sr.occ18,sr.occ231,sr.ome04,sr.ome042,sr.ome043,sr.ome044,
         sr.ome02,sr.ome01,sr.ome21,sr.ome39,sr.ome59x,sr.omeprsw,sr.omb01,
         sr.omb03,sr.omb04,sr.omb31,sr.omb32,sr.omb06,sr.omb12,sr.omb17,sr.omb18,
         sr.oma01,sr.oma00,sr.oma08,sr.oma24,sr.oma54t,sr.oma23,sr.occ11,sr.oma66,
         l_year,l_month,l_day,l_check,l_oao06,      
         #FUN-C10036-------add---end---
         l_oea10,l_oeb03,l_tax,l_q,l_q2,
         l_total[1].num,l_total[2].num,l_total[3].num,l_total[4].num,
         l_total[5].num,l_total[6].num,l_total[7].num,l_total[8].num,
         t_azi03,t_azi04,t_azi05,t_azi07,l_sub1 #CHI-AC0019 add l_sub1

#No.FUN-720053--end
   END FOREACH
#No.FUN-720053--begin
#  FINISH REPORT axrg302_rep
   CALL cl_wcchp(tm.wc,'ome212,ome05,ome02,ome00,omeuser,ome01') 
        RETURNING tm.wc 
#NO.FUN-840088---start---
#  LET g_sql = "SELECT ",l_table1,".*,",
#              l_table2,".ome39,",l_table2,".oma23,",l_table2,".oma54t",
##TQC_730113## "   FROM ",l_table1 CLIPPED,",OUTER ",l_table2 CLIPPED,
#              "   FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,",",g_cr_db_str CLIPPED,l_table2 CLIPPED,
#              " WHERE ",l_table1,".ome01 = ",l_table2,".ome01(+)"
#No.CHI-840005---Begin
#  LET g_sql = "SELECT A.*,B.ome39,B.oma23,B.oma54t",
#              " FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A,",
#              g_cr_db_str CLIPPED,l_table2 CLIPPED," B",
#              " WHERE A.ome01 = B.ome01(+) "  
###GENGRE###   LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
###GENGRE###               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
#No.CHI-840005---End
#NO.FUN-840088---end---
###GENGRE###   LET g_str = tm.wc
  #CALL cl_prt_cs3('axrg302',g_sql,g_str)  #TQC-730113
###GENGRE###   CALL cl_prt_cs3('axrg302','axrg302',g_sql,g_str)
    CALL axrg302_grdata()    ###GENGRE###
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-720053--end
 
END FUNCTION
 
#No.FUN-720053--begin
#REPORT axrg302_rep(sr)
#   DEFINE 
#           l_last_sw    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1) 
#          #l_ogb11      VARCHAR(20),
#           l_ogb11      LIKE ogb_file.ogb11,          #NO.FUN-5B0015 #No.FUN-680123 VARCHAR(40)
#          #l_ogb04      VARCHAR(20),
#           l_ogb04      LIKE ogb_file.ogb04,          #NO.FUN-5B0015 #No.FUN-680123 VARCHAR(40)
#          #l_oga25      VARCHAR(1),
#           l_oga25      LIKE oga_file.oga25,          #No.FUN-680123
#           l_q          LIKE omb_file.omb12,
#           l_q2         LIKE omb_file.omb12,
#           l_q3         LIKE type_file.num5,          #No.FUN-5B0139 #No.FUN-680123 SMALLINT
#           l_oea10      LIKE oea_file.oea10,
#           l_oeb03      LIKE oeb_file.oeb03,
#           l_oao06      LIKE oao_file.oao06,
#          sr        RECORD
#                    occ18     LIKE occ_file.occ18,
#                    occ231    LIKE occ_file.occ231,
#                    ome04     LIKE ome_file.ome04,
#                    ome042    LIKE ome_file.ome042,
#                    ome043    LIKE ome_file.ome043,
#                    ome044    LIKE ome_file.ome044,
#                    ome02     LIKE ome_file.ome02,
#                    ome01     LIKE ome_file.ome01,
#                    ome21     LIKE ome_file.ome21,
#                    ome39     LIKE ome_file.ome39,
#                    ome59x    LIKE ome_file.ome59x,        #No.FUN-680123 DEC(20,6)
#                    omeprsw   LIKE ome_file.omeprsw,
#                    omb01     LIKE omb_file.omb01,
#                    omb03     LIKE omb_file.omb03,
#                    omb04     LIKE omb_file.omb04,
#                    omb31     LIKE omb_file.omb31,
#                    omb32     LIKE omb_file.omb32,
#                    omb06     LIKE omb_file.omb06,
#                    omb12     LIKE omb_file.omb12,
#                    omb17     LIKE omb_file.omb17,
#                    omb18     LIKE omb_file.omb18,
#                    oma01     LIKE oma_file.oma01,
#                    oma00     LIKE oma_file.oma00,
#                    oma08     LIKE oma_file.oma08,
#                    oma24     LIKE oma_file.oma24,
#                    oma54t    LIKE oma_file.oma54t,
#                    oma23     LIKE oma_file.oma23,
#                    occ11     LIKE occ_file.occ11,
#                    oma66     LIKE oma_file.oma66 
#                    END RECORD,
#   l_flag     LIKE type_file.chr1,              #No.FUN-680123 VARCHAR(01)
#	 l_year         LIKE type_file.num10,         #No.FUN-680123 INTEGER
#	 l_month        LIKE type_file.num10,         #No.FUN-680123 INTEGER
#	 l_day          LIKE type_file.num10,         #No.FUN-680123 INTEGER
#	 l_tot          LIKE type_file.chr8,          #No.FUN-680123 VARCHAR(8)
#   l_omb18	LIKE omb_file.omb18,	
#	 l_i		LIKE type_file.num5,          #No.FUN-680123 SMALLINT
#   l_sql          STRING,                       #CHI-6C0007  #LIKE type_file.chr1000,  #No.FUN-680123 VARCHAR(1400)
#	 l_num          LIKE type_file.num10,         #No.FUN-680123 SMALLINT
#	#l_str	 VARCHAR(20),                     #MOD-670020
#	 l_str		STRING,                       #MOD-670020
#	 l_tax          LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
#  DEFINE 
#         l_check        LIKE type_file.num10,         #檢查碼 #No.FUN-680123 integer 
#         l_code1        LIKE type_file.num5,          #No.FUN-680123 SMALLINT
#         l_code         LIKE type_file.num5,          #No.FUN-680123 SMALLINT
#         n              LIKE type_file.num5           #No.FUN-680123 SMALLINT
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  #ORDER BY sr.ome01,sr.omb06
#  ORDER BY sr.ome01,sr.omb03
#  FORMAT
#   PAGE HEADER
#      #檢查碼
#      if g_pageno = 0 then
#      LET l_code1= 9
#      FOR n=3 TO 10
#         LET l_code = sr.ome01[n,n]
#         LET l_check=l_check+((l_code*(11-n)/10)+((l_code*(11-n)) mod 10))
#      END FOR
#      LET l_check=l_check mod 10
#      LET l_check=10-l_check
#      end if
#
#     IF sr.ome043 = 'MISC' THEN
#        SELECT oma032 INTO sr.ome043
#          FROM oma_file
#         WHERE oma10 = sr.ome01
#     END IF
#
#      LET g_pageno= g_pageno+1
#		 LET l_year = YEAR(sr.ome02)-1911
#		 LET l_month= MONTH(sr.ome02)
#                 LET l_Day = DAY(sr.ome02)
#                 PRINT ' '
#                 PRINT ' '
#                 PRINT COLUMN 62,l_year  USING '&&',
#	               COLUMN 67,l_month USING '&&',
#	               COLUMN 72,l_day   USING '&&'
#	         PRINT COLUMN 20,sr.ome01 CLIPPED
#	         PRINT COLUMN 20,sr.ome043 CLIPPED
#	         PRINT COLUMN 20,sr.ome042 CLIPPED,
#                       COLUMN 78,l_check
#		 PRINT ''
#		 PRINT ''
#		 PRINT ''
#                 PRINT ''
#      LET l_last_sw = 'n'             #FUN-550111
#
#   BEFORE GROUP OF sr.ome01
#                LET l_q = 1
#                let l_q2 = 0
#		SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#
#   LET l_oao06 = ''
#   LET l_oea10 = ''
#
#   SELECT count(*) INTO l_q2 FROM omb_file
#    WHERE omb01 = sr.omb01
#   #No.FUN-5B0139 --start--
#   IF g_aza.aza26 = '2' THEN
#      SELECT COUNT(*) INTO l_q3
#        FROM omb_file
#       WHERE omb01 IN (SELECT UNIQUE oma01
#        FROM oma_file
#       WHERE oma10 = sr.ome01)
#         AND omb01 != sr.omb01
#       IF cl_null(l_q3) THEN LET l_q3 = 0 END IF
#       LET l_q2 = l_q2 + l_q3
#   END IF
#   #No.FUN-5B0139 --end--
#
#   SELECT oao06 INTO l_oao06 FROM oao_file
#    WHERE oao01 = sr.oma01
#      AND oao04 = '1'
#
#   IF l_q2 IS NULL THEN LET l_q2 = 0 END IF
#   #FUN-630043
#   LET g_plant_new=sr.oma66
#   CALL s_getdbs()
#   IF NOT cl_null(sr.omb32) THEN #CHI-6C0007 add
#   LET l_sql =
#       #"SELECT rvv01,rvv06,pmc03,rvv09,rvv03,rvuconf ",  #CHI-6C0007 mark 
#        "SELECT ogb11,ogb04,oea10,oeb03 ",                #CHI-6C0007 mod
#        "  FROM ",g_dbs_new CLIPPED,"ogb_file,",
#        "       ",g_dbs_new CLIPPED,"oea_file,",
#        "       ",g_dbs_new CLIPPED,"oeb_file ",
#        " WHERE ogb01 = '",sr.omb31,"' ",
#        "   AND ogb03 = '",sr.omb32,"' ",
#        "   AND oeb01 = ogb31",
#        "   AND oeb03 = ogb32",
#        "   AND oea01 = oeb01"
#    PREPARE g302_pb1 FROM l_sql
#    DECLARE g302_bcs1 CURSOR FOR g302_pb1
#    OPEN g302_bcs1
#    FETCH g302_bcs1 INTO l_ogb11,l_ogb04,l_oea10,l_oeb03
#       IF SQLCA.sqlcode THEN
#          LET l_ogb11=''
#          LET l_ogb04=''
#          LET l_oea10=''
#          LET l_oeb03=''
#       END IF
#   END IF   #CHI-6C0007 add
#   #END FUN-630043
#      IF cl_null(l_ogb11) THEN LET l_ogb11 = l_ogb04 END IF
#      #No.FUN-5B0139 --start--
#      IF cl_null(l_ogb04) OR cl_null(l_ogb11) THEN
#         LET l_ogb11 = sr.omb06
#      END IF
#      #No.FUN-5B0139 --end--
#         IF sr.omb04 = 'MISC'
#            #THEN PRINT COLUMN 10, sr.omb06[1,20];
#            THEN PRINT COLUMN 10, sr.omb06 CLIPPED; #NO.FUN-5B0015
#         ELSE
#         #PRINT COLUMN 10,l_ogb11[1,20];          #sr.omb06
#         PRINT COLUMN 10,l_ogb11 clipped;         #sr.omb06  #NO.FUN-5B0015
#         END IF
#               SELECT azi03,azi04,azi05,azi07
#                 INTO t_azi03,t_azi04,t_azi05,t_azi07          #幣別檔小數位數讀取
#                 FROM azi_file
#                WHERE azi01=sr.oma23
#         PRINT COLUMN 40,cl_numfor(sr.omb12,15,3),
#               COLUMN 55,cl_numfor(sr.omb17,18,t_azi03),
#               COLUMN 76,cl_numfor(sr.omb18,18,t_azi04);
#         IF sr.oma08 = '2' or sr.oma23 <> 'NTD' THEN
#               CASE WHEN l_q = '1' PRINT COLUMN 96, l_oao06[1,15]
#                    WHEN l_q = '2' PRINT COLUMN 96, sr.oma23,cl_numfor(sr.oma54t,18,t_azi04)
#                    WHEN l_q = '3' PRINT COLUMN 96, g_x[11] clipped,cl_numfor(sr.oma24,10,t_azi07) #匯率
#                    WHEN l_q = '4' PRINT COLUMN 96, sr.ome39
#                    OTHERWISE PRINT COLUMN 96, ' '
#               END CASE
#         ELSE
#            IF sr.oma00 <> '12' THEN
#               PRINT COLUMN 96,l_oao06[1,26]
#            ELSE
#               PRINT COLUMN 96,l_oea10 CLIPPED, g_x[12] clipped, l_oeb03 USING '###'
#            END IF
#         END IF
#   IF (l_q MOD 8 ) = 0 AND l_q <> l_q2 THEN
#       PRINT COLUMN 72,g_x[13] clipped
#       SKIP TO TOP OF PAGE
#   END IF
#   LET l_q = l_q + 1
# 
#   AFTER GROUP OF sr.ome01
#     LET g_pageno= 0
#     LET l_check = 0
#     IF ( l_q2 MOD 8 ) <> 0 THEN
#     FOR i = (l_q2 MOD 8) TO 7
#         IF (sr.oma08 = '2' or sr.oma23 <> 'NTD') AND l_q2 <= 4 THEN
#               SELECT azi03,azi04,azi05,azi07
#                 INTO t_azi03,t_azi04,t_azi05,t_azi07          #幣別檔小數位數讀取
#                 FROM azi_file
#                WHERE azi01=sr.oma23
#            CASE WHEN i = '1' PRINT COLUMN 96, sr.oma23,cl_numfor(sr.oma54t,18,t_azi04)
#                 WHEN i = '2' PRINT COLUMN 96, g_x[11] clipped,cl_numfor(sr.oma24,10,t_azi07)  #匯率
#                 WHEN i = '3' PRINT COLUMN 96, sr.ome39
#                 OTHERWISE PRINT COLUMN 96, ''
#            END CASE
#         ELSE
#            PRINT ' '
#         END IF
#     END FOR
#     END IF
# #    SELECT oga25 INTO l_oga25 FROM oga_file
# #     WHERE oga01 = sr.omb31
#
# #    IF l_oga25 = 'M' AND l_q > 10 THEN
# #       PRINT '材料一批'
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #       PRINT ''
# #    ELSE
# #       IF l_oga25 <> 'M' AND l_q >10 THEN
# #          PRINT '成品一批'
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #          PRINT ''
# #       END IF
# #    END IF
#
#  # AFTER GROUP OF sr.ome01
#         LET l_omb18= GROUP SUM(sr.omb18)
#         IF l_omb18 IS NULL THEN LET l_omb18 = 0 END IF
#	   	 PRINT ''
#                 PRINT ''
#                 PRINT ''
#		 PRINT COLUMN 76,cl_numfor(l_omb18,18,t_azi05)
#		 PRINT ''
#                 PRINT COLUMN 76,cl_numfor(sr.ome59x,18,t_azi04)
#		 SELECT gec06 INTO l_tax FROM gec_file
#			WHERE gec01 = sr.ome21
#                          AND gec011='2'  #銷項
#		 CASE l_tax
#			WHEN '1' PRINT COLUMN 50,'V'
#			WHEN '2' PRINT COLUMN 58,'V'
#			WHEN '3' PRINT COLUMN 65,'V'
#		 END CASE
#		 PRINT COLUMN 76,cl_numfor(l_omb18+sr.ome59x,18,t_azi05)
#		 PRINT ''
#		 PRINT COLUMN 27;
#	         #LET l_str = "零壹貳參肆伍陸柒捌玖"   #MOD-670020
#               
#		 LET l_tot = l_omb18+sr.ome59x USING '&&&&&&&&'
#		 IF cl_null(l_tot) THEN LET l_tot='00000000' END IF
#		 FOR l_i =1 to 8
#			LET l_num = l_tot[l_i,l_i]
#                        #-----MOD-670020---------
#			#PRINT l_str[l_num*2+1,l_num*2+2],'      ';   
#                        CASE l_num
#                           WHEN 0
#                             CALL cl_getmsg('sub-130',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 1
#                             CALL cl_getmsg('sub-119',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 2
#                             CALL cl_getmsg('sub-120',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 3
#                             CALL cl_getmsg('sub-121',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 4
#                             CALL cl_getmsg('sub-122',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 5
#                             CALL cl_getmsg('sub-123',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 6
#                             CALL cl_getmsg('sub-124',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 7
#                             CALL cl_getmsg('sub-125',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 8
#                             CALL cl_getmsg('sub-126',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                           WHEN 9
#                             CALL cl_getmsg('sub-127',g_lang) RETURNING l_str
#                             PRINT l_str CLIPPED,'     ';
#                        END CASE
#                        #-----END MOD-670020-----
#		 END FOR
#                 LET g_i = g_i
#		UPDATE ome_file SET omeprsw = omeprsw + 1
#			WHERE ome01 = sr.ome01
### FUN-550111
#     ON LAST ROW
#          LET l_last_sw = 'y'
# 
#     PAGE TRAILER
#         PRINT
#         IF l_last_sw = 'n' THEN
#             IF g_memo_pagetrailer THEN
#                 PRINT g_x[14]
#                 PRINT g_memo
#             ELSE
#                 PRINT
#                 PRINT
#             END IF
#          ELSE
#                 PRINT g_x[14]
#                 PRINT g_memo
#          END IF
### END FUN-550111
# 
#
#END REPORT
##Patch....NO.TQC-610037 <001> #  
#No.FUN-720053--end

###GENGRE###START
FUNCTION axrg302_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF   
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axrg302")
        IF handler IS NOT NULL THEN
            START REPORT axrg302_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED   #FUN-B50018----mod---l_table->l_table1---
                        ," ORDER BY ome01"  #FUN-B50018 add
          
            DECLARE axrg302_datacur1 CURSOR FROM l_sql
            FOREACH axrg302_datacur1 INTO sr1.*
                OUTPUT TO REPORT axrg302_rep(sr1.*)
            END FOREACH
            FINISH REPORT axrg302_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axrg302_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE l_sql           STRING
    DEFINE l_omb18_ome59x  LIKE  omb_file.omb18
    DEFINE l_tot1          STRING
    DEFINE l_tot2          STRING
    DEFINE l_tot3          STRING
    DEFINE l_tot4          STRING
    DEFINE l_tot5          STRING
    DEFINE l_tot6          STRING
    DEFINE l_tot7          STRING
    DEFINE l_tot8          STRING
    DEFINE l_omb18_sum     LIKE omb_file.omb18
    DEFINE l_display1      LIKE type_file.chr1
    DEFINE l_display2      LIKE type_file.chr1
    DEFINE l_display3      LIKE type_file.chr1
    DEFINE l_display4      LIKE type_file.chr1
    DEFINE l_display5      LIKE type_file.chr1
    DEFINE l_display6      LIKE type_file.chr1
    DEFINE l_display7      LIKE type_file.chr1
    DEFINE l_display8      LIKE type_file.chr1
    DEFINE l_oma54t_fmt    STRING
    DEFINE l_oma24_fmt     STRING
    DEFINE l_omb17_fmt     STRING
    DEFINE l_omb18_fmt     STRING
    DEFINE l_omb18_sum_fmt STRING
    DEFINE l_ome59x_fmt    STRING
    DEFINE l_omb18_ome59x_fmt STRING
    DEFINE l_check         LIKE type_file.num10
    DEFINE l_code1         LIKE type_file.num5
    DEFINE l_code          LIKE type_file.num5
    DEFINE n               LIKE type_file.num5
    #FUN-B50018----add-----end-----------------


    
    ORDER EXTERNAL BY sr1.ome01,sr1.omb01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ome01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.omb01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str-----------------
            LET l_oma54t_fmt = cl_gr_numfmt('oma_file','oma54t',sr1.azi04)
            PRINTX l_oma54t_fmt
            LET l_oma24_fmt = cl_gr_numfmt('oma_file','oma24',sr1.azi07)
            PRINTX l_oma24_fmt
            LET l_omb17_fmt = cl_gr_numfmt('omb_file','omb17',sr1.azi03)
            PRINTX l_omb17_fmt
            LET l_omb18_fmt = cl_gr_numfmt('omb_file','omb18',sr1.azi04)   
            PRINTX l_omb18_fmt
            IF NOT cl_null(sr1.tot1) THEN
               LET l_tot1 = cl_gr_getmsg("gre-076",g_lang,sr1.tot1)
            END IF
            PRINTX l_tot1

            IF NOT cl_null(sr1.tot2) THEN
               LET l_tot2 = cl_gr_getmsg("gre-076",g_lang,sr1.tot2)
            END IF
            PRINTX l_tot2

            IF NOT cl_null(sr1.tot3) THEN
               LET l_tot3 = cl_gr_getmsg("gre-076",g_lang,sr1.tot3)
            END IF
            PRINTX l_tot3

            IF NOT cl_null(sr1.tot4) THEN
               LET l_tot4 = cl_gr_getmsg("gre-076",g_lang,sr1.tot4)
            END IF
            PRINTX l_tot4

            IF NOT cl_null(sr1.tot5) THEN
               LET l_tot5 = cl_gr_getmsg("gre-076",g_lang,sr1.tot5)
            END IF
            PRINTX l_tot5

            IF NOT cl_null(sr1.tot6) THEN
               LET l_tot6 = cl_gr_getmsg("gre-076",g_lang,sr1.tot6)
            END IF
            PRINTX l_tot6
       
            IF NOT cl_null(sr1.tot7) THEN
               LET l_tot7 = cl_gr_getmsg("gre-076",g_lang,sr1.tot7)
            END IF
            PRINTX l_tot7

            IF NOT cl_null(sr1.tot8) THEN
               LET l_tot8 = cl_gr_getmsg("gre-076",g_lang,sr1.tot8)
            END IF
            PRINTX l_tot8

            IF sr1.oma23 IS NULL THEN LET sr1.oma23=' ' END IF
            IF sr1.oma08 IS NULL THEN LET sr1.oma08=' ' END IF
            IF sr1.oma08 = '2' OR  sr1.oma23 != 'NTD' AND sr1.q = 1  THEN 
               LET l_display1 = 'Y'
            ELSE
               LET l_display1 = 'N'
            END IF
            PRINTX l_display1 
            

            IF sr1.oma08 = '2' OR sr1.oma23 != "NTD" AND sr1.q = 2 THEN 
               LET l_display2 = 'Y'
            ELSE
               LET l_display2 = 'N'
            END IF
            PRINTX l_display2

            IF sr1.oma08 = '2' OR sr1.oma23 != "NTD" AND sr1.q = 3 THEN 
               LET l_display3 = 'Y'
            ELSE
               LET l_display3 = 'N'
            END IF
            PRINTX l_display3


            IF sr1.oma08 = '2' OR sr1.oma23 != "NTD" AND sr1.q = 4 THEN 
               LET l_display4 = 'Y'
            ELSE
               LET l_display4 = 'N'
            END IF
            PRINTX l_display4

            IF sr1.oma08 = '2' OR sr1.oma23 != "NTD" AND sr1.q != 1 AND sr1.q != 2 AND sr1.q != 3 AND sr1.q != 4 THEN 
               LET l_display5 = 'Y'
            ELSE
               LET l_display5 = 'N'
            END IF
            PRINTX l_display5


            IF sr1.oma08 != '2' AND sr1.oma23 = "NTD" AND sr1.oma00 != "12" THEN
               LET l_display6 = 'Y'
            ELSE
               LET l_display6 = 'N'
            END IF
            PRINTX l_display6

            IF sr1.oma08 != '2' AND sr1.oma23 = "NTD" AND sr1.oma00 = "12" THEN 
               LET l_display7 = 'Y'
            ELSE
               LET l_display7 = 'N'
            END IF
            PRINTX l_display7


            IF sr1.l_sub1 = 'Y' THEN
               LET l_display8 = 'Y'
            ELSE
               LET l_display8 = 'N'
            END IF
            PRINTX l_display8
            #FUN-B50018----add-----end-----------------


            PRINTX sr1.*

        AFTER GROUP OF sr1.ome01

            #FUN-B50018----add-----str-----------------
            LET l_omb18_sum = GROUP SUM(sr1.omb18)
            PRINTX l_omb18_sum

            LET l_omb18_ome59x = l_omb18_sum + sr1.ome59x
            PRINTX l_omb18_ome59x

            LET l_omb18_sum_fmt = cl_gr_numfmt('omb_file','omb18',sr1.azi05)
            PRINTX  l_omb18_sum_fmt
            LET l_ome59x_fmt = cl_gr_numfmt('ome_file','ome59x',sr1.azi04)
            PRINTX l_ome59x_fmt
            LET l_omb18_ome59x_fmt = cl_gr_numfmt('omb_file','omb18',sr1.azi05)
            PRINTX l_omb18_ome59x_fmt
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE oao01 = '",sr1.oma01 CLIPPED,"'",
                        " AND oao04 =  '1'"
            START REPORT axrg302_subrep01
            DECLARE axrg302_repcur1 CURSOR FROM l_sql
            FOREACH axrg302_repcur1 INTO sr2.*
                OUTPUT TO REPORT axrg302_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axrg302_subrep01
            #FUN-B50018----add-----end-----------------

        AFTER GROUP OF sr1.omb01

        
        ON LAST ROW

END REPORT


#FUN-B50018----add-----str-----------------
REPORT axrg302_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_oma54t_fmt STRING
    DEFINE l_oma24_fmt  STRING

    FORMAT
        ON EVERY ROW
            LET l_oma54t_fmt = cl_gr_numfmt('oma_file','oma54t',sr2.azi04)
            PRINTX l_oma54t_fmt
            LET l_oma24_fmt = cl_gr_numfmt('oma_file','oma24',sr2.azi07)
            PRINTX l_oma24_fmt
            PRINTX sr2.*

END REPORT
#FUN-B50018----add-----end-----------------
###GENGRE###END
