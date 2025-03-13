# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: aimr405.4gl
# Descriptions...: 庫存金額明細表
# Input parameter:
# Return code....:
# Date & Author..: 95/02/10 By Nick
# Modify.........: 99/07/02 By Frank871
# Modify.........: No.MOD-490345 04/09/20 Melody 單位成本應顯示
# Modify.........: No.FUN-510017 05/01/10 By Mandy 報表轉XML
# Modify.........: No.MOD-530532 05/03/26 By kim 報表 庫存量,庫存金額,總合計 小數位沒印
# Modify.........: No.MOD-550040 05/06/16 By kim 單位成本(CCC23)的值若找不到時給上期,再找不到給0
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-790004 07/09/03 By wujie 月份欄位控管為只能輸入兩位數 
# Modify.........: No.FUN-790012 07/09/06 By zhoufeng 報表輸出改為Crystal Report
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-870175 08/09/22 By sherry 加上"庫存資料截至日"條件,同aimr106推算邏輯
# Modify.........: No.TQC-910054 09/01/22 By claire 庫存量數量重複計算
# Modify.........: No.MOD-920054 09/02/04 By claire 截止時間統計數量有誤
# Modify.........: No.MOD-980019 09/08/04 By sherry 下條件的時候，檔沒有進入edate欄位的時候，g_yy就取不到值  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0025 09/12/21 By jan 畫面新增type欄位
# Modify.........: No.MOD-A30178 10/04/14 By Sarah 成本計算類別選個別認定時,庫存量與庫存金額呈現有誤
# Modify.........: N0:MOD-A70184 10/07/23 By Sarah r405_prepare1的SQL不串imk_file,等到FOREACH裡再處理imk_file的抓取
# Modify.........: No:MOD-A10150 10/08/03 By Pengu 未排除非成本庫資料
# Modify.........: N0:MOD-A80134 10/08/23 By sabrina sr.imk09在給值前要先清空，不然會有錯
# Modify.........: N0:CHI-BB0023 11/12/20 By ck2yuan 庫存為0改為使用者勾選是否要印出到報表上
# Modify.........: N0:MOD-B90057 12/092/15 By bart 庫存量數量有誤
# Modify.........: N0:MOD-D20140 13/02/26 By Alberti 修改庫存資料截止日(tm.edate)
#                                                       成本單價資料年度期別給預設值(yy,mm)
# Modify.........: N0:CHI-D30010 13/03/22 By bart tm.type='4'時，sr.tlfcost應=sr.tlfcost
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                          # Print condition RECORD
                   wc      LIKE type_file.chr1000, # Where condition  #No.FUN-690026 VARCHAR(500)
                   yy,mm   LIKE type_file.num5,    # No.FUN-690026 SMALLINT
                   edate   LIKE type_file.dat,     # No.FUN-870175 
                   type    LIKE type_file.chr1,    # CHI-9C0025
                   p1      LIKE type_file.chr1,    # CHI-BB0023 add
                   more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                   END RECORD,
#      g_azi03     LIKE azi_file.azi03,  #單價,成本小數位數(0~5)
#      g_azi04     LIKE azi_file.azi04,  #金額小數位數     (0~3)
#      g_azi05     LIKE azi_file.azi05,  #小計,總計小數位數(0~3)
       g_tot_amt   LIKE img_file.img10   # 庫存金額總合計
#No.FUN-870175---Begin
DEFINE    g_yy        LIKE type_file.num5,    
          g_mm        LIKE type_file.num5,    
          last_y      LIKE type_file.num5,    
          last_m      LIKE type_file.num5,    
          l_cnt       LIKE type_file.num5,    
          m_bdate     LIKE type_file.dat,     
          m_edate     LIKE type_file.dat,     
          l_imk09     LIKE imk_file.imk09,    
          l_flag      LIKE type_file.chr1  
DEFINE   g_chr        LIKE type_file.chr1  
#No.FUN-870175---End
DEFINE g_i         LIKE type_file.num5   #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_sql       STRING                #No.FUN-790012
DEFINE g_str       STRING                #No.FUN-790012
DEFINE l_table     STRING                #No.FUN-790012
 
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
 
   #No.FUN-790012 --start--
   LET g_sql="ima01.ima_file.ima01,  ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,ima25.ima_file.ima25,",
             "ccc23.ccc_file.ccc23,  img10.img_file.img10,",
             "tlfcost.tlf_file.tlfcost,oeb13.oeb_file.oeb13"   #CHI-9C0025 #add by huanglf161201
   LET l_table = cl_prt_temptable('aimr405',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?)"  #CHI-9C0025 #add by huanglf161201
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF
   #No.FUN-790012 --end--
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.p1 = ARG_VAL(10)       #CHI-BB0023 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)   #CHI-BB0023 modify 10->11
   LET g_rep_clas = ARG_VAL(12)   #CHI-BB0023 modify 11->12
   LET g_template = ARG_VAL(13)   #CHI-BB0023 modify 12->13
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078   #CHI-BB0023 modify 13->14
   #No.FUN-570264 ---end---
   LET tm.edate = ARG_VAL(15)    #No.FUN-870175   #CHI-BB0023 modify 14->15
   LET tm.type = ARG_VAL(16)    #No.FUN-870175    #CHI-BB0023 modify 15->16
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr405_tm(0,0)                # Input print condition
      ELSE CALL aimr405()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr405_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
DEFINE l_azm   RECORD LIKE azm_file.*         #MOD-D20140
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW aimr405_w AT p_row,p_col
        WITH FORM "aim/42f/aimr405"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #CHI-9C0025
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.edate = g_today             #No.FUN-870175  
   LET tm.more = 'N'
   LET tm.type = g_ccz.ccz28  #CHI-9C0025
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.p1 = 'N'           #CHI-BB0023 add
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima131,ima08,img01,img02,img03,img04
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
 
#No.FUN-570240  --start-
      ON ACTION controlp
            #------CHI-BB0023   str add--------
          CASE
            WHEN INFIELD(ima131)
            CALL cl_init_qry_var()
            LET g_qryparam.form    = "q_oca"
            LET g_qryparam.state   = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima131
            NEXT FIELD ima131

            WHEN INFIELD(img02)
            CALL cl_init_qry_var()
            LET g_qryparam.form    = "q_imd"
            LET g_qryparam.state   = "c"
            LET g_qryparam.arg1    = 'SW'
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO img02
            NEXT FIELD img02

            WHEN INFIELD(img03)
            CALL cl_init_qry_var()
            LET g_qryparam.form    = "q_ime"
            LET g_qryparam.state   = "c"
            LET g_qryparam.arg2    = 'SW'
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO img03
            NEXT FIELD img03

         END CASE
           #------CHI-BB0023   end add--------
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
#No.FUN-570240 --end--
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimr405_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   
   SELECT ccz01,ccz02 INTO tm.yy,tm.mm FROM ccz_file     #MOD-D20140 
   
   DISPLAY BY NAME tm.yy,tm.mm,tm.type,tm.more,tm.p1   # Condition#CHI-9C0025 add type  #CHI-BB0023 add tm.p1
   INPUT BY NAME tm.yy,tm.mm,tm.edate,tm.type,tm.p1,tm.more WITHOUT DEFAULTS    #No.FUN-870175 add tm.edate #CHI-9C0025 add tm.type  #CHI-BB0023 add tm.p1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      #No.TQC-790004 --begin                                                                                                              
      AFTER FIELD mm                                                                                                                
         IF tm.mm <=0 OR tm.mm >12 THEN                                                                                             
            LET tm.mm =null                                                                                                         
            NEXT FIELD mm                                                                                                           
         END IF                                                                                                                     
      #No.TQC-790004 --end
 
      #No.FUN-870175---Begin
      AFTER FIELD edate
           IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
           LET g_yy = YEAR(tm.edate)
      #MOD-D20140-add-start
           LET g_mm = ''
           SELECT * INTO l_azm.* FROM azm_file WHERE azm01 = g_yy 
           IF l_azm.azm011 <= tm.edate AND l_azm.azm012 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 1
           END IF 

           IF l_azm.azm021 <= tm.edate AND l_azm.azm022 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 2
           END IF 

           IF l_azm.azm031 <= tm.edate AND l_azm.azm032 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 3
           END IF 

           IF l_azm.azm041 <= tm.edate AND l_azm.azm042 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 4
           END IF 

           IF l_azm.azm051 <= tm.edate AND l_azm.azm052 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 5
           END IF 

           IF l_azm.azm061 <= tm.edate AND l_azm.azm062 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 6
           END IF 

           IF l_azm.azm071 <= tm.edate AND l_azm.azm072 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 7
           END IF 

           IF l_azm.azm081 <= tm.edate AND l_azm.azm082 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 8
           END IF 

           IF l_azm.azm091 <= tm.edate AND l_azm.azm092 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 9
           END IF 

           IF l_azm.azm101 <= tm.edate AND l_azm.azm102 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 10
           END IF 

           IF l_azm.azm111 <= tm.edate AND l_azm.azm112 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 11
           END IF 

           IF l_azm.azm121 <= tm.edate AND l_azm.azm122 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 12
           END IF 

           IF l_azm.azm131 <= tm.edate AND l_azm.azm132 >= tm.edate AND cl_null(g_mm) THEN
              LET g_mm = 13
           END IF             
     #MOD-D20140-add-end      
           
          #LET g_mm = MONTH(tm.edate)  #MOD-D20140  mark
      #No.FUN-870175---End
           
      
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
         
     #No.FUN-870175---Begin
     AFTER INPUT
         IF  INT_FLAG THEN EXIT INPUT END IF
         LET l_flag = 'N'
         IF  cl_null(tm.edate) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.edate
         END IF
         IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.more
         END IF
         IF  l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD edate
         END IF
     #No.FUN-870175---End
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr405_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   
   #MOD-980019---Begin                                                                                                              
   LET g_yy = YEAR(tm.edate)
#MOD-D20140-add-start
   LET g_mm = ''
   SELECT * INTO l_azm.* FROM azm_file WHERE azm01 = g_yy 
   IF l_azm.azm011 <= tm.edate AND l_azm.azm012 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 1
   END IF 
   IF l_azm.azm021 <= tm.edate AND l_azm.azm022 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 2
   END IF 
   IF l_azm.azm031 <= tm.edate AND l_azm.azm032 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 3
   END IF 
   IF l_azm.azm041 <= tm.edate AND l_azm.azm042 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 4
   END IF 
   IF l_azm.azm051 <= tm.edate AND l_azm.azm052 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 5
   END IF 
   IF l_azm.azm061 <= tm.edate AND l_azm.azm062 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 6
   END IF 
   IF l_azm.azm071 <= tm.edate AND l_azm.azm072 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 7
   END IF 
   IF l_azm.azm081 <= tm.edate AND l_azm.azm082 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 8
   END IF 
   IF l_azm.azm091 <= tm.edate AND l_azm.azm092 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 9
   END IF 
   IF l_azm.azm101 <= tm.edate AND l_azm.azm102 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 10
   END IF 
   IF l_azm.azm111 <= tm.edate AND l_azm.azm112 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 11
   END IF 
   IF l_azm.azm121 <= tm.edate AND l_azm.azm122 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 12
   END IF 
   IF l_azm.azm131 <= tm.edate AND l_azm.azm132 >= tm.edate AND cl_null(g_mm) THEN
      LET g_mm = 13
   END IF             
#MOD-D20140-add-end     
  #LET g_mm = MONTH(tm.edate)  #MOD-D20140 mark                                                                                                        
   #MOD-980019---End     
 
   #No.FUN-870175---Begin
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
   #No.FUN-870175---End
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr405'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr405','9031',1)
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'" ,
                         " '",tm.p1 CLIPPED,"'" ,               #CHI-BB0023 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.edate CLIPPED,"'"              #No.FUN-7C0078
                         ," '",tm.type CLIPPED,"'"              #CHI-9C0025
         CALL cl_cmdat('aimr405',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr405_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr405()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr405_w
END FUNCTION
 
FUNCTION aimr405()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_time    LIKE type_file.chr8,          # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          #No.FUN-870175---Begin
          #sr        RECORD ima01   LIKE ima_file.ima01,    # 料號
          #                 ima02   LIKE ima_file.ima02,    # 品名
          #                 ima021  LIKE ima_file.ima021,   # 規格
          #                 ima25   LIKE ima_file.ima25,    # 單位
          #                 inv_qty LIKE img_file.img10,    # 庫存量
          #                 ccc23   LIKE ccc_file.ccc23     # 單位成本
          #          END RECORD,
          sr         RECORD
                     img01 LIKE img_file.img01,   #--料號
                     img02 LIKE img_file.img02,   #--倉
                     img03 LIKE img_file.img03,   #--儲
                     img04 LIKE img_file.img04,   #--批
                     img10 LIKE img_file.img10,   #--出入庫量
                     ima25 LIKE ima_file.ima25,   #--料件主檔單位
                     imk09 LIKE imk_file.imk09,   #--上期期末庫存
                     tmp01 LIKE imk_file.imk05,   #--上期期末年度  #No.FUN-690026 SMALLINT
                     tmp02 LIKE imk_file.imk06,   #--上期期末期別  #No.FUN-690026 SMALLINT
                     tlfcost LIKE tlf_file.tlfcost
                     END RECORD,
          l_img09       LIKE img_file.img09,     #--來源單位
          l_img2ima_fac LIKE ima_file.ima31_fac, #--轉換率 #MOD-530179
          l_ima02   LIKE ima_file.ima02,         #No.FUN-770006
          l_ima021  LIKE ima_file.ima021,        #No.FUN-770006 
          l_ccc23   LIKE ccc_file.ccc23, 
          l_ccc23_1 LIKE ccc_file.ccc23,         #add by huanglf161130
          l_ccc23_2 LIKE ccc_file.ccc23,         #add by huanglf161130
          l_ccc23_3 LIKE ccc_file.ccc23,         #add by huanglf161130 
          
          l_img10   LIKE img_file.img10,
          l_img21   LIKE img_file.img21,      
          #No.FUN-870175---End  
          l_yy      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_mm      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_str     LIKE type_file.chr1000  #No.FUN-790012
DEFINE    l_sql1    STRING                  # add by huanglf161130
DEFINE    l_oga24   LIKE oga_file.oga24     #add by huanglf161130
DEFINE    l_oea24   LIKE oea_file.oea24     #add by huanglf161130
     CALL cl_del_data(l_table)              #No.FUN-790012
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     #No.FUN-870175---Begin
     DROP TABLE aimr405_tmp
 
     CREATE TEMP TABLE aimr405_tmp(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10,
           ima25 LIKE ima_file.ima25,
           imk09 LIKE imk_file.imk09,
           tmp01 LIKE imk_file.imk05,
           tmp02 LIKE imk_file.imk06,
           tlfcost LIKE tlf_file.tlfcost) #CHI-9C0025
     DELETE FROM aimr405_tmp
 
     DROP TABLE aimr405_tmp2
     
     CREATE TEMP TABLE aimr405_tmp2(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10,
           ima25 LIKE ima_file.ima25,
           imk09 LIKE imk_file.imk09,
           tmp01 LIKE imk_file.imk05,
           tmp02 LIKE imk_file.imk06,
           tlfcost LIKE tlf_file.tlfcost) #CHI-9C0025
     DELETE FROM aimr405_tmp2
      
     IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF
 
    #str MOD-A70184 mod
    #LET l_sql = "SELECT img01,img02,img03,img04,imk05,imk06,imd09,img10",#CHI-9C0025 add imd09  #MOD-A30178 add img10
    #            " FROM ima_file,img_file LEFT OUTER JOIN imk_file",
    #            " ON img01 = imk01 AND img02 = imk02",
    #            " AND img03 = imk03 AND img04 = imk04",
    #            " AND imk_file.imk05 =",last_y,
    #            " AND imk_file.imk06 =",last_m,
    #            " LEFT OUTER JOIN imd_file ON img02 = imd01", #CHI-9C0025
    #            " WHERE ima01=img01 ",
    #            " AND ", tm.wc CLIPPED
     LET l_sql = "SELECT img01,img02,img03,img04,0,0,imd09,img10",#CHI-9C0025 add imd09  #MOD-A30178 add img10
                 " FROM ima_file,img_file ",
                 " LEFT OUTER JOIN imd_file ON img02 = imd01", #CHI-9C0025
                 " WHERE ima01=img01 ",
                 " AND img02 NOT IN (SELECT jce02 FROM jce_file ) ",   #No:MOD-A10150 add
                 " AND ", tm.wc CLIPPED
    #end MOD-A70184 mod
    #CHI-BB0023---add---start---
     IF tm.p1 = 'N' THEN
        LET l_sql = l_sql, " AND img10 !=0 "
     END IF
    #CHI-BB0023---add---end---
     PREPARE r405_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r405_curs1 CURSOR FOR r405_prepare1
 
     LET g_success = 'Y'
     BEGIN WORK
     FOREACH r405_curs1 INTO sr.img01,sr.img02,sr.img03,sr.img04,
                             sr.tmp01,sr.tmp02,sr.tlfcost,  #CHI-9C0025
                             sr.img10   #MOD-A30178 add
        LET sr.tmp01 = last_y   #MOD-A70184 add
        LET sr.tmp02 = last_m   #MOD-A70184 add
        LET sr.img10=0          #MOD-B90057 add
        SELECT COUNT(*) INTO l_cnt FROM aimr405_tmp  #--己存在不覆蓋
         WHERE img01 = sr.img01 AND img02 = sr.img02
           AND img03 = sr.img03 AND img04 = sr.img04
        IF NOT cl_null(l_cnt) AND l_cnt <> 0 THEN
           CONTINUE FOREACH
        END IF
        #MOD-4C0105
        IF sr.tmp02 = g_mm  THEN
           LET sr.tmp02 = sr.tmp02 - 1
           IF sr.tmp02 = 0 THEN
              LET sr.tmp02 = 12
              LET sr.tmp01 = sr.tmp01 - 1
           END IF
        END IF
        #MOD-4C0105(end)
       #LET sr.img10 = 0   #MOD-A30178 mark
       #str MOD-A70184 mod
       #SELECT imk09,img09 INTO sr.imk09,l_img09
       #  FROM img_file LEFT OUTER JOIN imk_file
       #    ON img01 = imk01    AND img02 = imk02
       #   AND img03 = imk03    AND img04 = imk04
       #   AND imk05 = sr.tmp01 AND imk06 = sr.tmp02
       # WHERE img01 = sr.img01 AND img02 = sr.img02
       #   AND img03 = sr.img03 AND img04 = sr.img04
        #將img_file與imk_file的抓取拆開
        SELECT img09 INTO l_img09 FROM img_file
         WHERE img01 = sr.img01 AND img02 = sr.img02
           AND img03 = sr.img03 AND img04 = sr.img04
        LET sr.imk09 = NULL            #MOD-A80134 add
        SELECT imk09 INTO sr.imk09 FROM imk_file
         WHERE imk01 = sr.img01 AND imk02 = sr.img02
           AND imk03 = sr.img03 AND imk04 = sr.img04
           AND imk05 = sr.tmp01 AND imk06 = sr.tmp02
       #end MOD-A70184 mod
       #str MOD-A70184 mark
       #IF SQLCA.sqlcode THEN
       #   LET g_success = 'N'
#      #   CALL cl_err(sr.img01,SQLCA.sqlcode,1) #No.FUN-660156
       #   CALL cl_err3("sel","imk_file",sr.img01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
       #END IF
       #end MOD-A70184 mark
        IF  cl_null(sr.imk09) THEN LET sr.imk09 = 0  END IF
        IF  cl_null(l_img09)  THEN LET l_img09 = ' ' END IF
        SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01 = sr.img01
        LET l_img2ima_fac  = 1
        IF l_img09 <> sr.ima25 THEN
           CALL s_umfchk(sr.img01,l_img09,sr.ima25)
                RETURNING g_i,l_img2ima_fac
           IF g_i = 1 THEN
              LET l_img2ima_fac = 1
              CALL cl_err(sr.img01,'mfg3075',0)
           END IF
        END IF
        LET sr.imk09 = sr.imk09 * l_img2ima_fac #--期末庫存量(轉換後)
       #str MOD-A30178 add
        CASE tm.type
           WHEN '1'  LET sr.tlfcost = ' '
           WHEN '2'  LET sr.tlfcost = ' '
           WHEN '3'  LET sr.tlfcost = sr.img04
           #WHEN '4'  LET sr.tlfcost = ' '  #CHI-D30010
           WHEN '4'  LET sr.tlfcost = sr.tlfcost #CHI-D30010
           WHEN '5'  LET sr.tlfcost = sr.tlfcost
        END CASE
       #end MOD-A30178 add
        INSERT INTO aimr405_tmp VALUES(sr.*)
        IF SQLCA.sqlcode THEN
           LET g_success = "N"
#          CALL cl_err('ins r405_tmp 1:',SQLCA.sqlcode,1)
           CALL cl_err3("ins","aimr405_tmp",sr.img01,"",SQLCA.sqlcode,"",
                        "ins r405_tmp 1",1)   #NO.FUN-640266 #No.FUN-660156
        END IF
     END FOREACH
 
   #MOD-B90057---unmark---start--- 
    #str MOD-A30178 mark
     LET l_sql = " SELECT tlf01,tlf902,tlf903,tlf904, ",
                        " (tlf907*tlf10),' ',0,0,0,tlfcost,tlf11 ", #CHI-9C0025
                 " FROM img_file,tlf_file",
                 " WHERE img01 = tlf01 ",
                 " AND (img02 = tlf902 AND img03 = tlf903 AND img04 = tlf904) ",
                 " AND img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? AND tlfcost = ? ", #CHI-9C0025
                 " AND tlf06 BETWEEN ? AND '",tm.edate,"'",
                 " AND tlf907 IN (1,-1)"   #入出庫碼 (1:入庫 -1:出庫 0:其它
     PREPARE r405_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1) LET g_success = 'N' END IF
     DECLARE r405_curs2 CURSOR WITH HOLD FOR r405_prepare2
    #end MOD-A30178 mark
   #MOD-B90057---unmark---end---
 
     DECLARE r405_cur3 CURSOR FOR
        SELECT * FROM aimr405_tmp
 
     FOREACH r405_cur3 INTO sr.*
       #CALL s_azm(sr.tmp01,sr.tmp02)     #MOD-510083   #No.MOD-580027 mark
        CALL s_azm(g_yy,g_mm)             #No.MOD-580027 抓取本期的起始日期
             RETURNING g_chr,m_bdate,m_edate
        LET l_imk09 = sr.imk09
        INSERT INTO aimr405_tmp2 VALUES(sr.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","aimr405_tmp2",sr.img01,"",SQLCA.sqlcode,"",
                        "ins r405 tmp2",0)   #NO.FUN-640266
           LET g_success='N'
        END IF
     #No:9314
 
        #CHI-9C0025--begin--add--
        CASE tm.type
           WHEN '1'  LET sr.tlfcost = ' '
           WHEN '2'  LET sr.tlfcost = ' '
           WHEN '3'  LET sr.tlfcost = sr.img04
           #WHEN '4'  LET sr.tlfcost = ' '  #CHI-D30010
           WHEN '4'  LET sr.tlfcost = sr.tlfcost  #CHI-D30010
           WHEN '5'  LET sr.tlfcost = sr.tlfcost
        END CASE
        #CHI-9C0025--end--add----

      #MOD-B90057---unmark---start---
       #str MOD-A30178 mark
        FOREACH r405_curs2 USING sr.img01,sr.img02,sr.img03,sr.img04,sr.tlfcost,m_bdate #CHI-9C0025
           INTO sr.*,l_img09
            IF  SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
           #TQC-910054-begin-add
            SELECT COUNT(*) INTO l_cnt FROM aimr405_tmp2  #--己存在不覆蓋
             WHERE img01 = sr.img01 AND img02 = sr.img02
               AND img03 = sr.img03 AND img04 = sr.img04
           #MOD-920054-begin-mark
           #IF  NOT cl_null(l_cnt) AND l_cnt <> 0 THEN
           #    CONTINUE FOREACH
           #END IF
           #MOD-920054-end-mark
           #TQC-910054-end-add
            SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01 = sr.img01
            LET l_img2ima_fac  = 1
            IF l_img09 <> sr.ima25 THEN
               CALL s_umfchk(sr.img01,l_img09,sr.ima25)
                    RETURNING g_i,l_img2ima_fac
               IF g_i = 1 THEN
                  LET l_img2ima_fac = 1
                  CALL cl_err(sr.img01,'mfg3075',0)
               END IF
            END IF
            LET sr.imk09 = sr.imk09 * l_img2ima_fac #--期末庫存量(轉換後)
            LET sr.img10 = sr.img10 * l_img2ima_fac #No.MOD-580027 期間異動數量(轉換後)
            #MOD-920054-begin-add
            IF NOT cl_null(l_cnt) AND l_cnt <> 0 THEN
               UPDATE aimr405_tmp2 SET img10 = img10+sr.img10
                 WHERE img01 = sr.img01 AND img02 = sr.img02
                   AND img03 = sr.img03 AND img04 = sr.img04
            ELSE
            #MOD-920054-end-add
               INSERT INTO aimr405_tmp2 VALUES(sr.*)
            END IF  #MOD-920054 add
            IF  SQLCA.sqlcode THEN
                LET g_success = 'N'
                CALL cl_err3("ins","aimr405_tmp2",sr.img01,"",SQLCA.sqlcode,
                             "ins r405_tmp 1","",1)   #NO.FUN-640266 #No.FUN-660156
            END IF
        END FOREACH
       #end MOD-A30178 mark
      #MOD-B90057---unmark---end---
     END FOREACH
     IF g_success = 'Y' THEN
        CALL cl_cmmsg(1) COMMIT WORK
     ELSE
        CALL cl_rbmsg(1) ROLLBACK WORK RETURN
     END IF
 
     DECLARE aimr405_tmp_cur CURSOR FOR
      SELECT * FROM aimr405_tmp2   #MOD-510083
     FOREACH aimr405_tmp_cur INTO sr.*
        IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                   
         WHERE ima01 = sr.img01                                                
        IF SQLCA.sqlcode THEN                                                     
           LET l_ima02 = ' '                                                     
           LET l_ima021 = ' '                                                    
        END IF 
       #MOD-920054-begin-mark
       #SELECT img10*img21 INTO l_img21 FROM img_file 
       # WHERE img01 = sr.img01 AND img02 = sr.img02 
       #   AND img03 = sr.img03 AND img04 = sr.img04
       #MOD-920054-end-mark
        LET l_img21 =  sr.img10 + sr.imk09 #MOD-920054 
        SELECT ccc23 INTO l_ccc23 FROM ccc_file
         WHERE ccc01=sr.img01 AND ccc02=tm.yy AND ccc03=tm.mm
          #AND ccc07='1'    #No.FUN-840041  #CHI-9C0025
           AND ccc07=tm.type AND ccc08=sr.tlfcost  #CHI-9C0025
        IF (SQLCA.sqlcode) OR (l_ccc23 IS NULL) THEN
           LET l_mm = tm.mm - 1
           LET l_yy = tm.yy
           IF l_mm = 0 THEN
              LET l_yy = tm.yy - 1
              LET l_mm = 12
           END IF
           SELECT ccc23 INTO l_ccc23
             FROM ccc_file
            WHERE ccc01=sr.img01 AND ccc02=l_yy AND ccc03=l_mm
             #AND ccc07='1'    #No.FUN-840041  #CHI-9C0025
              AND ccc07=tm.type AND ccc08=sr.tlfcost  #CHI-9C0025
           IF (SQLCA.sqlcode) OR (l_ccc23 IS NULL) THEN LET l_ccc23 = 0 END IF
        END IF
       
#str----add by huanglf161130
      LET l_ccc23_3='' LET l_ccc23_1='' LET l_ccc23_2=''
      #LET l_ccc23_1=0 LET l_ccc23_2=0 LET l_ccc23_3=0
      DECLARE aimr405_curs2 CURSOR FOR 
      SELECT ogb13,oga24 FROM ogb_file,oga_file WHERE ogb01 = oga01 AND ogb04 = sr.img01 AND oga09='2' 
       ORDER BY oga02 DESC
   #   PREPARE aimr405_prepare2 FROM l_sql1
   #   DECLARE aimr405_curs2 CURSOR FOR aimr405_prepare2
      OPEN aimr405_curs2
      FETCH aimr405_curs2  INTO l_ccc23_1,l_oga24
      CLOSE aimr405_curs2
   #   FOREACH aimr405_curs2 INTO l_ccc23_1,l_oga24 
   #      IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
         LET l_ccc23_1 = l_ccc23_1 * l_oga24
   #   EXIT FOREACH 
   #   END FOREACH

    IF  cl_null(l_ccc23_1) THEN
        DECLARE aimr405_curs3 CURSOR FOR 
         SELECT oeb13,oea24 FROM oeb_file,oea_file 
         WHERE oea01 = oeb01 AND oeb04 = sr.img01 AND oea00!='0' 
         ORDER BY oea02 desc
        OPEN aimr405_curs3  
        FETCH aimr405_curs3 INTO l_ccc23_2,l_oea24
        CLOSE aimr405_curs3
        
     #   PREPARE aimr405_prepare3 FROM l_sql1
     #   DECLARE aimr405_curs3 CURSOR FOR aimr405_prepare3
     #   FOREACH aimr405_curs3 INTO l_ccc23_2,l_oea24
           LET l_ccc23_2 = l_ccc23_2 * l_oea24
     #      EXIT FOREACH  
     #   END FOREACH

        IF cl_null(l_ccc23_2) THEN
        ELSE
            LET l_ccc23_3 = l_ccc23_2
        END IF
        IF  cl_null(l_ccc23_2) THEN
           LET l_sql1 = "SELECT tc_xmf05 FROM tc_xmf_file",
                      " WHERE tc_xmf03 = '",sr.img01,"'",
                      " ORDER BY tc_xmf00 DESC"
           PREPARE aimr405_prepare4 FROM l_sql1
           DECLARE aimr405_curs4 CURSOR FOR aimr405_prepare4
           FOREACH aimr405_curs4 INTO l_ccc23_3
               LET l_ccc23_3 = l_ccc23_3
           EXIT FOREACH
           END FOREACH 
           IF NOT cl_null(l_ccc23_3) THEN 
            #  LET l_ccc23_3 = 0
           END IF 
        ELSE
        #   LET l_ccc23 = l_ccc23_2 
        END IF  
    
   ELSE
        LET l_ccc23_3 = l_ccc23_1
   END IF

    
#str----end by huanglf161130  

        EXECUTE insert_prep USING sr.img01,l_ima02,l_ima021,sr.ima25,
                                  l_ccc23,l_img21,sr.tlfcost,l_ccc23_3   #CHI-9C0025
    
       #LET l_sql = "SELECT ima01,ima02,ima021,ima25,img10*img21,0", #MOD-490345
       #            "  FROM img_file, ima_file ",
       #            " WHERE img01=ima01 ",
       #            "   AND ",tm.wc CLIPPED
       #PREPARE aimr405_prepare1 FROM l_sql
       #IF SQLCA.sqlcode != 0 THEN
       #   CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
       #   EXIT PROGRAM
       #END IF
       #DECLARE aimr405_curs1 CURSOR FOR aimr405_prepare1
#NO.CHI-6A0004--BEGIN
#       SELECT azi03,azi04,azi05
#         INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#         FROM azi_file
#        WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #CALL cl_outnam('aimr405') RETURNING l_name    #No.FUN-790012
     #START REPORT aimr405_rep TO l_name            #No.FUN-790012
     #LET g_tot_amt = 0
     #FOREACH aimr405_curs1 INTO sr.*
     #  IF SQLCA.sqlcode != 0 THEN
     #     CALL cl_err('foreach:',SQLCA.sqlcode,1)
     #     EXIT FOREACH
     #  END IF
     #   #MOD-490345
     #  SELECT ccc23 INTO sr.ccc23 FROM ccc_file
     #   WHERE ccc01=sr.ima01 AND ccc02=tm.yy AND ccc03=tm.mm
     #     AND ccc07='1'    #No.FUN-840041
     #   #MOD-490345
     #   #MOD-550040................begin
     #     IF (SQLCA.sqlcode) OR (sr.ccc23 IS NULL) THEN
     #        LET l_mm = tm.mm - 1
     #        LET l_yy = tm.yy
     #        IF l_mm = 0 THEN
     #           LET l_yy = tm.yy - 1
     #           LET l_mm = 12
     #        END IF
     #        SELECT ccc23 INTO sr.ccc23
     #          FROM ccc_file
     #         WHERE ccc01=sr.ima01 AND ccc02=l_yy AND ccc03=l_mm
     #           AND ccc07='1'    #No.FUN-840041
     #        IF (SQLCA.sqlcode) OR (sr.ccc23 IS NULL) THEN LET sr.ccc23 = 0 END IF
     #     END IF
     #   #MOD-550040................end
#    #   OUTPUT TO REPORT aimr405_rep(sr.*)                 #No.FUN-790012
     # #No.FUN-790012 --start--
     #  EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima25,
     #                            sr.ccc23,sr.inv_qty
     #  #No.FUN-790012 --end--
     #No.FUN-870175---End
     END FOREACH
 
#     FINISH REPORT aimr405_rep                            #No.FUN-790012
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #No.FUN-790012
     #No.FUN-790012 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima131,ima08,img01,img02,img03,img04')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET l_str = tm.yy USING '####','/',tm.mm USING '##'
     LET g_str = g_str,";",l_str,";",g_azi03,";",g_azi04,";",g_azi05
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aimr405','aimr405',l_sql,g_str)
     #No.FUN-790012 --end--
END FUNCTION 
#No.FUN-790012 --start-- mark
{REPORT aimr405_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_inv_qty    LIKE img_file.img10,
          l_inv_amt    LIKE img_file.img10,
          sr           RECORD ima01   LIKE ima_file.ima01,    # 料號
                              ima02   LIKE ima_file.ima02,    # 品名
                              ima021  LIKE ima_file.ima021,   # 規格
                              ima25   LIKE ima_file.ima25,    # 單位
                              inv_qty LIKE img_file.img10,    # 庫存量
                              ccc23   LIKE ccc_file.ccc23     #單位成本
                       END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[11] CLIPPED,tm.yy USING '####','/',tm.mm USING '##'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.ima01
      LET l_inv_qty = GROUP SUM(sr.inv_qty)
      LET l_inv_amt = sr.ccc23 * l_inv_qty
      LET g_tot_amt=g_tot_amt+l_inv_amt
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021,
            COLUMN g_c[34],sr.ima25,
             COLUMN g_c[35],cl_numfor(sr.ccc23,35,g_azi03),      #No.MOD-490345
             COLUMN g_c[36],cl_numfor(l_inv_qty,36,3),    #No.MOD-490345
             COLUMN g_c[37],cl_numfor(l_inv_amt,37,g_azi04)     #No.MOD-490345
 
   ON LAST ROW
      PRINT COLUMN g_c[36],g_x[20] CLIPPED,
             COLUMN g_c[37],cl_numfor(g_tot_amt,37,g_azi05)     #No.MOD-490345
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #No.TQC-5C0005
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-790012 --end--
