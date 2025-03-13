# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr501.4gl
# Descriptions...: 在製成本進出存期報表(簡)
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/20 By Nick
# Modify.........: No.FUN-4C0099 05/01/26 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-5B0082 05/11/17 By Sarah 報表少印"其他"欄位
# Modify.........: NO.FUN-590002 05/12/27 By Monster radio type 應都要給預設值
# Modify.........: NO.FUN-620066 06/03/01 By Sarah 將工單號碼欄位放大成40碼
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-670058 06/07/17 By Sarah 增加抓cct_file,ccu_file(拆件式工單)
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將之前FUN-670058多抓cct_file,ccu_file的部份remove
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: NO.MOD-720042 07/02/14 by TSD.alana 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-790066 07/11/13 By Pengu 加入差異轉出金額
# Modify.........: No.FUN-7C0101 08/01/23 By ChenMoyan 成本改善報表
# Modify.........: No.FUN-830135 08/01/23 By ChenMoyan 成本改善報表部分模板調用 
# Modify.........: No.FUN-8C0047 08/01/14 By zhaijie MARK cl_outnam() 和rep() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No:MOD-B40062 11/04/11 By sabrina 串在製時應排除作廢/尚未發料之工單 
# Modify.........: No:MOD-B70283 11/08/18 By Vampire 增加ccg.ccg41,ccg.ccg42,ccg.ccg42a,ccg.ccg42b,ccg.ccg42c,ccg.ccg42d,ccg.ccg42e等值=0
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,           #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,           #No.FUN-7C0101
              azh01   LIKE azh_file.azh01,           #No.FUN-680122CHAR(10)
              azh02   LIKE azh_file.azh02,           #No.FUN-680122CHAR(40)
              o       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
              n       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
              detail_sw       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)       # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03           #No.FUN-680122DECIMAL(13,2)     # User defined variable
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122DATE
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122CHAR(72)
#---(S)---MOD-720042 By TSD.alana
DEFINE   l_table         STRING           
DEFINE   g_sql           STRING          
DEFINE   g_str           STRING         
DEFINE   g_cnt           LIKE type_file.num5
#---(E)---MOD-720042 By TSD.alana
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.type  = ARG_VAL(18)
  #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.azh01 = ARG_VAL(10)
   LET tm.azh02 = ARG_VAL(11)
   LET tm.o = ARG_VAL(12)
   LET tm.n = ARG_VAL(13)
   LET tm.detail_sw = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
#---(S)---MOD-720042 By TSD.alana
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>  *** ##
  LET g_sql = "ccg04.ccg_file.ccg04,",
              "ima25.ima_file.ima25,",
              "ima02.ima_file.ima02,",
              "ima911.ima_file.ima911,",
              "ccg01.ccg_file.ccg01,",
              "ccg11.ccg_file.ccg11,",
              "ccg12a.ccg_file.ccg12a,",
              "ccg12b.ccg_file.ccg12b,",
              "ccg12e.ccg_file.ccg12e,",
              "ccg12.ccg_file.ccg12,",
              "ccg21.ccg_file.ccg21,",
              "ccg20.ccg_file.ccg20,",
              "ccg22a.ccg_file.ccg22a,",
              "ccg22b.ccg_file.ccg22b,",
              "ccg22e.ccg_file.ccg22e,",
              "ccg22.ccg_file.ccg22,",
              "ccg23a.ccg_file.ccg23a,",
              "ccg23b.ccg_file.ccg23b,",
              "ccg23e.ccg_file.ccg23e,",
              "ccg23.ccg_file.ccg23,",
              "ccg31.ccg_file.ccg31,",
              "ccg32a.ccg_file.ccg32a,",
              "ccg32b.ccg_file.ccg32b,",
              "ccg32e.ccg_file.ccg32e,",
              "ccg32.ccg_file.ccg32,",
              "ccg91.ccg_file.ccg91,",
              "ccg92a.ccg_file.ccg92a,",
              "ccg92b.ccg_file.ccg92b,",
              "ccg92e.ccg_file.ccg92e,",
              "ccg92.ccg_file.ccg92,",
              "ccg12d.ccg_file.ccg12d,",
              "ccg12c.ccg_file.ccg12c,",
              "ccg22d.ccg_file.ccg22d,",
              "ccg22c.ccg_file.ccg22c,",
              "ccg23d.ccg_file.ccg23d,",
              "ccg23c.ccg_file.ccg23c,",
              "ccg32d.ccg_file.ccg32d,",
              "ccg32c.ccg_file.ccg32c,",
              "ccg92d.ccg_file.ccg92d,",
              "ccg92c.ccg_file.ccg92c,",
              "cch04.cch_file.cch04,",
              "cch05.cch_file.cch05,",
              "cch11.cch_file.cch11,",
              "cch12.cch_file.cch12,",
              "cch21.cch_file.cch21,",
              "cch22.cch_file.cch22,",
              "cch31.cch_file.cch31,",
              "cch32.cch_file.cch32,",
              "cch91.cch_file.cch91,",
              "cch92.cch_file.cch92,",
              "azi03.azi_file.azi03,",
              "azi04.azi_file.azi04,",
              "azi05.azi_file.azi05,",
              "ccz27.ccz_file.ccz27,",
              "qty1.ccg_file.ccg11,",
              "qty2.ccg_file.ccg11,",
             #----------------No.MOD-790066 add
              "cch41.cch_file.cch41,",
              "cch42.cch_file.cch42,",
              "ccg41.ccg_file.ccg41,",
              "ccg42.ccg_file.ccg42,",
              "ccg42a.ccg_file.ccg42a,",
              "ccg42b.ccg_file.ccg42b,",
              "ccg42c.ccg_file.ccg42c,",
              "ccg42d.ccg_file.ccg42d,",
             #"ccg42e.ccg_file.ccg42e"               #No.FUN-7C0101
              "ccg42e.ccg_file.ccg42e,",             #No.FUN-7C0101
             #----------------No.MOD-790066 end
             #----------------No.FUN-7C0101 Begin
              "ccg12f.ccg_file.ccg12f,",
              "ccg12g.ccg_file.ccg12g,",
              "ccg12h.ccg_file.ccg12h,",
              "ccg22f.ccg_file.ccg22f,",
              "ccg22g.ccg_file.ccg22g,",
              "ccg22h.ccg_file.ccg22h,",
              "ccg23f.ccg_file.ccg23h,",
              "ccg23g.ccg_file.ccg23g,",
              "ccg23h.ccg_file.ccg23h,",
              "ccg32f.ccg_file.ccg32f,",
              "ccg32g.ccg_file.ccg32g,",
              "ccg32h.ccg_file.ccg32h,",
              "ccg42f.ccg_file.ccg42f,",
              "ccg42g.ccg_file.ccg42g,",
              "ccg42h.ccg_file.ccg42h,",
              "ccg92f.ccg_file.ccg92f,",
              "ccg92g.ccg_file.ccg92g,",
              "ccg92h.ccg_file.ccg92h,",
              "ccg07.ccg_file.ccg07"
              #----------------No.FUN-7C0101 End
 
  LET l_table = cl_prt_temptable('axcr501',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",  #No.MOD-790066 add
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,",    #No.FUN-7C0101
              "        ?,?,?,?, ?)"                                      #No.MOD-790066 add
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
 
#---(E)---MOD-720042 By TSD.alana
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr501_tm(0,0)        # Input print condition
      ELSE CALL axcr501()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr501_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr501_w AT p_row,p_col
        WITH FORM "axc/42f/axcr501" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = 'N'
   LET tm.detail_sw= 'N'
   LET tm.more = 'N'
   LET tm.yy = YEAR(g_today)          # No.FUN-7C0101
   LET tm.mm = MONTH(g_today)         # No.FUN-7C0101
   LET tm.type = g_ccz.ccz28          # No.FUN-7C0101
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #NO.590002 START----------
   LET tm.o= '1'
   #NO.590002 END------------
 
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima09,ima11,
                              ima57,ima06,ima10,ima12      
##
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
 
#No.FUN-570240 --start                                                          
     ON ACTION controlp                                                      
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
        END IF                                                              
#No.FUN-570240 --end     
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
  #LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"   #FUN-620066 mark
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC%'"      #FUN-620066
  #INPUT BY NAME tm.yy,tm.mm,tm.azh01,tm.azh02,tm.o,tm.n,tm.detail_sw,tm.more            #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.azh01,tm.azh02,tm.o,tm.n,tm.detail_sw,tm.more    #No.FUN-7C0101
                 WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      #No.FUN-7C0101 --Begin                                                                                                        
      AFTER FIELD type                                                                                                              
         IF tm.type IS NULL OR tm.type NOT MATCHES "[12345]" THEN                                                                   
            NEXT FIELD type                                                                                                         
         END IF                                                                                                                     
      #No.FUN-7C0101 --End   
      AFTER FIELD azh01
         SELECT azh02 INTO tm.azh02 FROM azh_file WHERE azh01=tm.azh01
         DISPLAY BY NAME tm.azh02
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLP CASE WHEN INFIELD(azh01)
#                            CALL q_azh(4,4,tm.azh01,tm.azh02)
#                                 RETURNING tm.azh01,tm.azh02
#                            CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#                            CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azh'
    LET g_qryparam.default1 = tm.azh01
    LET g_qryparam.default2 = tm.azh02
    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
#    CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#    CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
# END genero shell script ADD
################################################################################
                             DISPLAY BY NAME tm.azh01,tm.azh02
                        END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr501'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr501','9031',1)   
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
                         #TQC-610051-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",  # No.FUN-7C0101
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.n CLIPPED,"'",
                         " '",tm.detail_sw CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr501',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr501_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr501()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr501_w
END FUNCTION
 
FUNCTION axcr501()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)     # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     STRING,  #CHAR(600),  # RDSQL STATEMENT   #FUN-620066 VARCHAR(600)->STRING
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          ccg	RECORD LIKE ccg_file.*,
 #---(S)---MOD-720042 By TSD.alana
          # ima	RECORD LIKE ima_file.*
          l_qty2    LIKE type_file.num5,
           ima       RECORD
                   ima01  LIKE ima_file.ima01,
                   ima25  LIKE ima_file.ima25,
                   ima02  LIKE ima_file.ima02,
                   ima911 LIKE ima_file.ima911
                   END RECORD,
          cch      RECORD 
                   cch04  LIKE cch_file.cch04,
                   cch05  LIKE cch_file.cch05,
                   cch11  LIKE cch_file.cch11,
                   cch12  LIKE cch_file.cch12,
                   cch21  LIKE cch_file.cch21,
                   cch22  LIKE cch_file.cch22,
                   cch31  LIKE cch_file.cch31,
                   cch32  LIKE cch_file.cch32,
                   cch41  LIKE cch_file.cch41,   #No.MOD-790066 add
                   cch42  LIKE cch_file.cch42,   #No.MOD-790066 add
                   cch91  LIKE cch_file.cch91,
                   cch92  LIKE cch_file.cch92
                   END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>  *** ##
   CALL cl_del_data(l_table)
   #---CR(2)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 #---(E)---MOD-720042 By TSD.alana
 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql = "SELECT ccg_file.*, ",
            #---(S)---MOD-720042 By TSD.alana
            #   "       ima_file.*",
               "ima01,ima25,ima02,ima911 ",  
            #---(E)---MOD-720042 By TSD.alana
               "  FROM ccg_file, ima_file, sfb_file",
               " WHERE ",tm.wc,
               "   AND ccg02=",tm.yy," AND ccg03=",tm.mm,
               "   AND ccg06='",tm.type,"'",                     #No.FUN-7C0101
               "   AND ccg04=ima01 AND ccg01=sfb01 ",
               "   AND sfb87='Y' AND sfb04>='2' "                #MOD-B40062 add
   IF tm.o='1' THEN LET l_sql=l_sql CLIPPED,
                              " AND (sfb99 IS NULL OR sfb99='N')" END IF
   IF tm.o='2' THEN LET l_sql=l_sql CLIPPED," AND sfb99 = 'Y'  " END IF
  #start FUN-620066
   LET l_sql = l_sql,
               " UNION ",
               "SELECT ccg_file.*,",
            #---(S)---MOD-720042 By TSD.alana
            #   "       ima_file.*",
               "ima01,ima25,ima02,ima911 ",  
            #---(E)---MOD-720042 By TSD.alana
               "  FROM ccg_file, ima_file ",
               " WHERE ",tm.wc,
               "   AND ccg02=",tm.yy," AND ccg03=",tm.mm,
               "   AND ccg06='",tm.type,"'",         #No.FUN-7C0101
               "   AND ccg01=ima01 ",
               "   AND ima911='Y'"
  #end FUN-620066
 
   PREPARE axcr501_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr501_curs1 CURSOR FOR axcr501_prepare1
 
#   CALL cl_outnam('axcr501') RETURNING l_name       #FUN-8C0047
   #START REPORT axcr501_rep TO l_name  #MOD-720042 By TSD.alana
   LET g_pageno = 0
   FOREACH axcr501_curs1 INTO ccg.*, ima.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #---(S)---MOD-720042 By TSD.alana
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>>  *** ##
      IF cl_null(ccg.ccg11)   THEN LET ccg.ccg11 = 0   END IF
      IF cl_null(ccg.ccg12a)  THEN LET ccg.ccg12a = 0  END IF
      IF cl_null(ccg.ccg12b)  THEN LET ccg.ccg12b = 0  END IF
      IF cl_null(ccg.ccg12)   THEN LET ccg.ccg12 = 0  END IF
      IF cl_null(ccg.ccg21)   THEN LET ccg.ccg21 = 0  END IF
      IF cl_null(ccg.ccg20)   THEN LET ccg.ccg20 = 0  END IF
      IF cl_null(ccg.ccg22a)  THEN LET ccg.ccg22a = 0  END IF
      IF cl_null(ccg.ccg22b)  THEN LET ccg.ccg22b = 0  END IF
      IF cl_null(ccg.ccg22)   THEN LET ccg.ccg22 = 0  END IF
      IF cl_null(ccg.ccg23a)  THEN LET ccg.ccg23a = 0  END IF
      IF cl_null(ccg.ccg23b)  THEN LET ccg.ccg23b = 0  END IF
      IF cl_null(ccg.ccg23)   THEN LET ccg.ccg23 = 0  END IF
      IF cl_null(ccg.ccg31)   THEN LET ccg.ccg31 = 0  END IF
      IF cl_null(ccg.ccg32a)  THEN LET ccg.ccg32a = 0  END IF
      IF cl_null(ccg.ccg32b)  THEN LET ccg.ccg32b = 0  END IF
      IF cl_null(ccg.ccg32)   THEN LET ccg.ccg32 = 0  END IF
      IF cl_null(ccg.ccg91)   THEN LET ccg.ccg91 = 0  END IF
      IF cl_null(ccg.ccg92a)  THEN LET ccg.ccg92a = 0  END IF
      IF cl_null(ccg.ccg92b)  THEN LET ccg.ccg92b = 0  END IF
      IF cl_null(ccg.ccg92)   THEN LET ccg.ccg92 = 0  END IF
      IF cl_null(ccg.ccg12d)  THEN LET ccg.ccg12d = 0  END IF
      IF cl_null(ccg.ccg12c)  THEN LET ccg.ccg12c = 0  END IF
      IF cl_null(ccg.ccg22d)  THEN LET ccg.ccg22d = 0  END IF
      IF cl_null(ccg.ccg22c)  THEN LET ccg.ccg22c = 0  END IF
      IF cl_null(ccg.ccg23d)  THEN LET ccg.ccg23d = 0  END IF
      IF cl_null(ccg.ccg23c)  THEN LET ccg.ccg23c = 0  END IF
      IF cl_null(ccg.ccg32d)  THEN LET ccg.ccg32d = 0  END IF
      IF cl_null(ccg.ccg32c)  THEN LET ccg.ccg32c = 0  END IF
      IF cl_null(ccg.ccg92d)  THEN LET ccg.ccg92d = 0  END IF
      IF cl_null(ccg.ccg92c)  THEN LET ccg.ccg92c = 0  END IF
      IF cl_null(ccg.ccg12e)  THEN LET ccg.ccg12e = 0  END IF
      IF cl_null(ccg.ccg22e)  THEN LET ccg.ccg22e = 0  END IF
      IF cl_null(ccg.ccg23e)  THEN LET ccg.ccg23e = 0  END IF
      IF cl_null(ccg.ccg32e)  THEN LET ccg.ccg32e = 0  END IF
      IF cl_null(ccg.ccg92e)  THEN LET ccg.ccg92e = 0  END IF
     #----------------------No.MOD-790066 add-----------------
      IF cl_null(ccg.ccg41)   THEN LET ccg.ccg41 = 0  END IF
      IF cl_null(ccg.ccg42)   THEN LET ccg.ccg42 = 0  END IF
      IF cl_null(ccg.ccg42a)  THEN LET ccg.ccg42a = 0  END IF
      IF cl_null(ccg.ccg42b)  THEN LET ccg.ccg42b = 0  END IF
      IF cl_null(ccg.ccg42c)  THEN LET ccg.ccg42c = 0  END IF
      IF cl_null(ccg.ccg42d)  THEN LET ccg.ccg42d = 0  END IF
      IF cl_null(ccg.ccg42e)  THEN LET ccg.ccg42e = 0  END IF
     #----------------------No.MOD-790066 end-----------------
     #No.FUN-7C0101 --Begin                                                                                                        
      IF cl_null(ccg.ccg12f)  THEN LET ccg.ccg12f = 0  END IF                                                                       
      IF cl_null(ccg.ccg12g)  THEN LET ccg.ccg12g = 0  END IF                                                                       
      IF cl_null(ccg.ccg12h)  THEN LET ccg.ccg12h = 0  END IF         
      IF cl_null(ccg.ccg22f)  THEN LET ccg.ccg22f = 0  END IF                                                                       
      IF cl_null(ccg.ccg22g)  THEN LET ccg.ccg22g = 0  END IF                                                                       
      IF cl_null(ccg.ccg22h)  THEN LET ccg.ccg22h = 0  END IF       
      IF cl_null(ccg.ccg23f)  THEN LET ccg.ccg23f = 0  END IF                                                                       
      IF cl_null(ccg.ccg23g)  THEN LET ccg.ccg23g = 0  END IF                                                                       
      IF cl_null(ccg.ccg23h)  THEN LET ccg.ccg23h = 0  END IF  
      IF cl_null(ccg.ccg32f)  THEN LET ccg.ccg32f = 0  END IF                                                                       
      IF cl_null(ccg.ccg32g)  THEN LET ccg.ccg32g = 0  END IF                                                                       
      IF cl_null(ccg.ccg32h)  THEN LET ccg.ccg32h = 0  END IF
      IF cl_null(ccg.ccg42f)  THEN LET ccg.ccg42f = 0  END IF                                                                       
      IF cl_null(ccg.ccg42g)  THEN LET ccg.ccg42g = 0  END IF                                                                       
      IF cl_null(ccg.ccg42h)  THEN LET ccg.ccg42h = 0  END IF
      IF cl_null(ccg.ccg92f)  THEN LET ccg.ccg92f = 0  END IF                                                                       
      IF cl_null(ccg.ccg92g)  THEN LET ccg.ccg92g = 0  END IF                                                                       
      IF cl_null(ccg.ccg92h)  THEN LET ccg.ccg92h = 0  END IF
     #No.FUN-7C0101 --End 
      LET g_cnt = 0  
      LET l_qty2 = 0 
      IF tm.detail_sw ='Y' THEN
         INITIALIZE cch.* TO NULL
         SELECT COUNT(*) INTO g_cnt FROM cch_file 
         WHERE cch01=ccg.ccg01 AND cch02=ccg.ccg02 AND cch03=ccg.ccg03
#           AND cch06=ccg.ccg06 AND cch07=ccg.ccg07                  #No.FUN-7C0101#TQC-970003
            AND cch06=ccg.ccg06   #TQC-970003
         IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
         IF g_cnt > 0 THEN
           DECLARE r501_c3 CURSOR FOR
              SELECT cch04,cch05,cch11,cch12,cch21,cch22,cch31,cch32,cch41,cch42,cch91,cch92 FROM cch_file  #No.MOD-790066 add cch41,cch42
               WHERE cch01=ccg.ccg01 AND cch02=ccg.ccg02 AND cch03=ccg.ccg03
                 #AND cch06=ccg.ccg06 AND cch07=ccg.ccg07            #No.FUN-7C0101#TQC-970003 mark
                  AND cch06=ccg.ccg06      #TQC-970003
                ORDER BY cch04
           FOREACH r501_c3 INTO cch.*
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err("r501_c3",SQLCA.SQLCODE,0) 
                  EXIT FOREACH 
               END IF
               LET l_qty2 = l_qty2 + 1
               IF cl_null(cch.cch11)   THEN LET cch.cch11 = 0   END IF
               IF cl_null(cch.cch12)   THEN LET cch.cch12 = 0   END IF
               IF cl_null(cch.cch21)   THEN LET cch.cch21 = 0   END IF
               IF cl_null(cch.cch22)   THEN LET cch.cch22 = 0   END IF
               IF cl_null(cch.cch31)   THEN LET cch.cch31 = 0   END IF
               IF cl_null(cch.cch32)   THEN LET cch.cch32 = 0   END IF
               IF cl_null(cch.cch91)   THEN LET cch.cch91 = 0   END IF
               IF cl_null(cch.cch92)   THEN LET cch.cch92 = 0   END IF
               IF cl_null(cch.cch41)   THEN LET cch.cch41 = 0   END IF   #No.MOD-790066 add
               IF cl_null(cch.cch42)   THEN LET cch.cch42 = 0   END IF   #No.MOD-790066 add
               IF l_qty2 > 1 THEN
                  LET ccg.ccg11 = 0 LET ccg.ccg12a = 0   LET ccg.ccg12b = 0
                  LET ccg.ccg12 = 0 LET ccg.ccg21 = 0    LET ccg.ccg20 = 0
                  LET ccg.ccg22a = 0 LET ccg.ccg22b = 0  LET ccg.ccg22 = 0
                  LET ccg.ccg23a = 0 LET ccg.ccg23b = 0  LET ccg.ccg23 = 0
                  LET ccg.ccg31 = 0  LET ccg.ccg32a = 0  LET ccg.ccg32b = 0
                  LET ccg.ccg32 = 0  LET ccg.ccg91 = 0   LET ccg.ccg92a = 0
                  LET ccg.ccg92b = 0 LET ccg.ccg92 = 0   LET ccg.ccg12d = 0
                  LET ccg.ccg12c = 0 LET ccg.ccg22d = 0  LET ccg.ccg22c = 0
                  LET ccg.ccg23d = 0 LET ccg.ccg23c = 0  LET ccg.ccg32d = 0
                  LET ccg.ccg32c = 0 LET ccg.ccg92d = 0  LET ccg.ccg92c = 0
                  LET ccg.ccg12e = 0 LET ccg.ccg22e = 0  LET ccg.ccg23e = 0
                  LET ccg.ccg32e = 0 LET ccg.ccg92e = 0
                  # No.FUN-7C0101 --Begin
                  LET ccg.ccg12f = 0 LET ccg.ccg12g = 0 LET ccg.ccg12h = 0
                  LET ccg.ccg22f = 0 LET ccg.ccg22g = 0 LET ccg.ccg22h = 0
                  LET ccg.ccg23f = 0 LET ccg.ccg23g = 0 LET ccg.ccg23h = 0
                  LET ccg.ccg32f = 0 LET ccg.ccg32g = 0 LET ccg.ccg32h = 0
                  LET ccg.ccg42f = 0 LET ccg.ccg42g = 0 LET ccg.ccg42h = 0
                  LET ccg.ccg92f = 0 LET ccg.ccg92g = 0 LET ccg.ccg92h = 0
                  # No.FUN-7C0101 --End
                  # MOD-B70283 --- modify --- start ---
                  LET ccg.ccg41  = 0 LET ccg.ccg42  = 0 LET ccg.ccg42a = 0
                  LET ccg.ccg42b = 0 LET ccg.ccg42c = 0 LET ccg.ccg42d = 0
                  LET ccg.ccg42e = 0
                  # MOD-B70283 --- modify ---  end  ---                  
               END IF
               EXECUTE insert_prep USING
                  ccg.ccg04,ima.ima25,ima.ima02,ima.ima911,ccg.ccg01,ccg.ccg11,
                  ccg.ccg12a,ccg.ccg12b,ccg.ccg12e,ccg.ccg12,ccg.ccg21,
                  ccg.ccg20,ccg.ccg22a,ccg.ccg22b,ccg.ccg22e,ccg.ccg22,
                  ccg.ccg23a,ccg.ccg23b,ccg.ccg23e,ccg.ccg23,ccg.ccg31,
                  ccg.ccg32a,ccg.ccg32b,ccg.ccg32e,ccg.ccg32,ccg.ccg91,
                  ccg.ccg92a,ccg.ccg92b,ccg.ccg92e,ccg.ccg92,
                  ccg.ccg12d,ccg.ccg12c,ccg.ccg22d,ccg.ccg22c,
                  ccg.ccg23d,ccg.ccg23c,ccg.ccg32d,ccg.ccg32c,
                  ccg.ccg92d,ccg.ccg92c,cch.cch04,cch.cch05,
                  cch.cch11,cch.cch12,cch.cch21,cch.cch22,
                  cch.cch31,cch.cch32,cch.cch91,cch.cch92,
                  #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,g_cnt,l_qty2,  #CHI-C30012
                  g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,g_cnt,l_qty2, #CHI-C30012
                  cch.cch41,cch.cch42,ccg.ccg41,ccg.ccg42,ccg.ccg42a,     #No.MOD-790066 add
                  ccg.ccg42b,ccg.ccg42c,ccg.ccg42d,ccg.ccg42e             #No.MOD-790066 add
                # No.FUN-7C0101  --Begin
                 ,ccg.ccg12f,ccg.ccg12g,ccg.ccg12h,ccg.ccg22f,ccg.ccg22g,  
                  ccg.ccg22h,ccg.ccg23f,ccg.ccg23g,ccg.ccg23h,ccg.ccg32f,
                  ccg.ccg32g,ccg.ccg32h,ccg.ccg42f,ccg.ccg42g,ccg.ccg42h,
                  ccg.ccg92f,ccg.ccg92g,ccg.ccg92h,ccg.ccg07
                # No.FUN-7C0101  --End
           END FOREACH
         END IF
      END IF
      IF g_cnt = 0 THEN
          IF cl_null(cch.cch11)   THEN LET cch.cch11 = 0   END IF
          IF cl_null(cch.cch12)   THEN LET cch.cch12 = 0   END IF
          IF cl_null(cch.cch21)   THEN LET cch.cch21 = 0   END IF
          IF cl_null(cch.cch22)   THEN LET cch.cch22 = 0   END IF
          IF cl_null(cch.cch31)   THEN LET cch.cch31 = 0   END IF
          IF cl_null(cch.cch32)   THEN LET cch.cch32 = 0   END IF
          IF cl_null(cch.cch91)   THEN LET cch.cch91 = 0   END IF
          IF cl_null(cch.cch92)   THEN LET cch.cch92 = 0   END IF
           EXECUTE insert_prep USING
              ccg.ccg04,ima.ima25,ima.ima02,ima.ima911,ccg.ccg01,ccg.ccg11,
              ccg.ccg12a,ccg.ccg12b,ccg.ccg12e,ccg.ccg12,ccg.ccg21,
              ccg.ccg20,ccg.ccg22a,ccg.ccg22b,ccg.ccg22e,ccg.ccg22,
              ccg.ccg23a,ccg.ccg23b,ccg.ccg23e,ccg.ccg23,ccg.ccg31,
              ccg.ccg32a,ccg.ccg32b,ccg.ccg32e,ccg.ccg32,ccg.ccg91,
              ccg.ccg92a,ccg.ccg92b,ccg.ccg92e,ccg.ccg92,
              ccg.ccg12d,ccg.ccg12c,ccg.ccg22d,ccg.ccg22c,
              ccg.ccg23d,ccg.ccg23c,ccg.ccg32d,ccg.ccg32c,
              ccg.ccg92d,ccg.ccg92c,cch.cch04,cch.cch05,
              cch.cch11,cch.cch12,cch.cch21,cch.cch22,
              cch.cch31,cch.cch32,cch.cch91,cch.cch92,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,g_cnt,l_qty2, #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,g_cnt,l_qty2, #CHI-C30012
              cch.cch41,cch.cch42,ccg.ccg41,ccg.ccg42,ccg.ccg42a,     #No.MOD-790066 add
              ccg.ccg42b,ccg.ccg42c,ccg.ccg42d,ccg.ccg42e             #No.MOD-790066 add
            # No.FUN-7C0101  --Begin                                                                                            
             ,ccg.ccg12f,ccg.ccg12g,ccg.ccg12h,ccg.ccg22f,ccg.ccg22g,                                                           
              ccg.ccg22h,ccg.ccg23f,ccg.ccg23g,ccg.ccg23h,ccg.ccg32f,                                                           
              ccg.ccg32g,ccg.ccg32h,ccg.ccg42f,ccg.ccg42g,ccg.ccg42h,                                                           
              ccg.ccg92f,ccg.ccg92g,ccg.ccg92h,ccg.ccg07                                                                        
            # No.FUN-7C0101  --End 
      END IF
      #OUTPUT TO REPORT axcr501_rep(ccg.*, ima.*)
      #---(E)---MOD-720042 By TSD.alana
 
   END FOREACH
 
    #---(S)---MOD-720042 By TSD.alana
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,ima08,ima09,ima11,ima57,ima06,ima10,ima12')
            RETURNING tm.wc
       LET g_str = tm.wc
    ELSE
       LET g_str = " "
    END IF
    LET g_str = g_str,";",tm.o,";",tm.yy,";",tm.mm,";",tm.azh01,";",tm.azh02,
                ";",tm.n,";",tm.detail_sw
    IF tm.type MATCHES '[12]' THEN                        #No.FUN-7C0101     
       CALL cl_prt_cs3('axcr501','axcr501',l_sql,g_str)   #FUN-710080 modify
    END IF                                                #No.FUN-7C0101
    IF tm.type MATCHES '[345]' THEN                       #No.FUN-7C0101
#       CALL cl_prt_cs3('axcr501','axcr501',l_sql,g_str)  #No.FUN-7C0101#FUN-830135
#       CALL cl_prt_cs3('axcr501_1','axcr501',l_sql,g_str)#No.FUN-830135 #TQC-970003
        CALL cl_prt_cs3('axcr501','axcr501_1',l_sql,g_str)#No.TQC-970003
    END IF                                                #No.FUN-7C0101
    #---(E)---MOD-720042 By TSD.alana
 
   #FINISH REPORT axcr501_rep  #MOD-720042 By TSD.alana
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #MOD-720042 By TSD.alana
END FUNCTION
#NO.FUN-8C0047---mark--start--zj-
#REPORT axcr501_rep(ccg, ima)
#  DEFINE l_last_sw     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
#  DEFINE l_tmpstr      STRING
#  DEFINE i		LIKE type_file.num5          #No.FUN-680122 SMALLINT
#  DEFINE ccg		RECORD LIKE ccg_file.*
#  DEFINE cch		RECORD LIKE cch_file.*
#  #DEFINE ima		RECORD LIKE ima_file.*
#  #---(S)---MOD-720042 By TSD.alana
#  DEFINE ima      RECORD
#                  ima01  LIKE ima_file.ima01,
#                  ima25  LIKE ima_file.ima25,
#                  ima02  LIKE ima_file.ima02,
#                  ima911 LIKE ima_file.ima911
#                  END RECORD
#  #---(E)---MOD-720042 By TSD.alana
#
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY ccg.ccg04, ccg.ccg01
 
# FORMAT
#  PAGE HEADER
#     IF tm.azh02 IS NOT NULL THEN LET g_x[1]=tm.azh02 END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total
#     LET g_msg=NULL
#     IF tm.o='1' THEN LET g_msg=g_x[9] END IF
#     IF tm.o='2' THEN LET g_msg=g_x[10] END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_msg))/2)+1,g_msg CLIPPED
#     LET l_tmpstr=g_x[11] CLIPPED,tm.yy USING '&&&&',
#                  g_x[12] CLIPPED,tm.mm USING '&&'
#     PRINT COLUMN ((g_len-FGL_WIDTH(l_tmpstr))/2)+1,l_tmpstr
#     PRINT g_dash
#     PRINT COLUMN r501_getStartPos(35,36,g_x[13]),g_x[13],
#           COLUMN r501_getStartPos(37,38,g_x[14]),g_x[14],
#           COLUMN r501_getStartPos(39,40,g_x[15]),g_x[15],
#           COLUMN r501_getStartPos(41,42,g_x[16]),g_x[16],
#           COLUMN r501_getStartPos(43,44,g_x[17]),g_x[17]
#     PRINT COLUMN 103,g_x[13],
#           COLUMN 138,g_x[14],
#           COLUMN 168,g_x[15],
#           COLUMN 209,g_x[16],
#           COLUMN 244,g_x[17]
#     PRINT COLUMN g_c[35],g_dash2[1,g_w[35]+g_w[36]+1],
#           COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+1],
#           COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+1],
#           COLUMN g_c[41],g_dash2[1,g_w[41]+g_w[42]+1],
#           COLUMN g_c[43],g_dash2[1,g_w[43]+g_w[44]+1]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41],g_x[42],g_x[43],g_x[44]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF ccg.ccg04
#     PRINT COLUMN g_c[31],ccg.ccg04,
#           COLUMN g_c[32],ima.ima25,
#           COLUMN g_c[33],ima.ima02 CLIPPED;
 
#  ON EVERY ROW
#    #start FUN-620066
#     IF cl_null(ima.ima911) OR ima.ima911 != 'Y' THEN
#        PRINT COLUMN g_c[34], ccg.ccg01;
#     END IF
#    #end FUN-620066
#     PRINT COLUMN g_c[35],cl_numfor(ccg.ccg11,35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[36],cl_numfor(ccg.ccg12,36,g_azi03),    #FUN-570190
#           COLUMN g_c[37],cl_numfor(ccg.ccg20,37,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[38],cl_numfor(ccg.ccg22,38,g_azi03),    #FUN-570190
#           COLUMN g_c[39],cl_numfor(ccg.ccg21,39,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[40],cl_numfor(ccg.ccg23,40,g_azi03),    #FUN-570190
#           COLUMN g_c[41],cl_numfor(ccg.ccg31,41,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[42],cl_numfor(ccg.ccg32,42,g_azi03),    #FUN-570190
#           COLUMN g_c[43],cl_numfor(ccg.ccg91,43,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[44],cl_numfor(ccg.ccg92,44,g_azi03)    #FUN-570190
#     IF tm.n='Y' THEN
#        PRINT COLUMN g_c[34],g_x[18] CLIPPED,
#           COLUMN g_c[36],cl_numfor(ccg.ccg12a,36,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(ccg.ccg22a,38,g_azi03),    #FUN-570190
#           COLUMN g_c[40],cl_numfor(ccg.ccg23a,40,g_azi03),    #FUN-570190
#           COLUMN g_c[42],cl_numfor(ccg.ccg32a,42,g_azi03),    #FUN-570190
#           COLUMN g_c[44],cl_numfor(ccg.ccg92a,44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34],g_x[19] CLIPPED,
#           COLUMN g_c[36],cl_numfor(ccg.ccg12b,36,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(ccg.ccg22b,38,g_azi03),    #FUN-570190
#           COLUMN g_c[40],cl_numfor(ccg.ccg23b,40,g_azi03),    #FUN-570190
#           COLUMN g_c[42],cl_numfor(ccg.ccg32b,42,g_azi03),    #FUN-570190
#           COLUMN g_c[44],cl_numfor(ccg.ccg92b,44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34],g_x[20] CLIPPED,
#           COLUMN g_c[36],cl_numfor(ccg.ccg12c,36,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(ccg.ccg22c,38,g_azi03),    #FUN-570190
#           COLUMN g_c[40],cl_numfor(ccg.ccg23c,40,g_azi03),    #FUN-570190
#           COLUMN g_c[42],cl_numfor(ccg.ccg32c,42,g_azi03),    #FUN-570190
#           COLUMN g_c[44],cl_numfor(ccg.ccg92c,44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34],g_x[21] CLIPPED,
#           COLUMN g_c[36],cl_numfor(ccg.ccg12d,36,g_azi03),    #FUN-570190
#           COLUMN g_c[38],cl_numfor(ccg.ccg22d,38,g_azi03),    #FUN-570190
#           COLUMN g_c[40],cl_numfor(ccg.ccg23d,40,g_azi03),    #FUN-570190
#           COLUMN g_c[42],cl_numfor(ccg.ccg32d,42,g_azi03),    #FUN-570190
#           COLUMN g_c[44],cl_numfor(ccg.ccg92d,44,g_azi03)    #FUN-570190
#        #start FUN-5B0082
#        PRINT COLUMN g_c[34],g_x[24] CLIPPED,
#              COLUMN g_c[36],cl_numfor(ccg.ccg12e,36,g_azi03),
#              COLUMN g_c[38],cl_numfor(ccg.ccg22e,38,g_azi03),
#              COLUMN g_c[40],cl_numfor(ccg.ccg23e,40,g_azi03),
#              COLUMN g_c[42],cl_numfor(ccg.ccg32e,42,g_azi03),
#              COLUMN g_c[44],cl_numfor(ccg.ccg92e,44,g_azi03)
#        #end FUN-5B0082
#     END IF
#     IF tm.detail_sw='Y' THEN
#        PRINT
#       #PRINT "                                              下階料號       ",
#       #      "          期初在製          ",
#       #      "          本月投入          ",
#       #      "       本月領用半成品       ",
#       #      "          本月轉出          ",
#       #      "          期末在製          "
#        DECLARE r501_c2 CURSOR FOR 
#           SELECT * FROM cch_file
#            WHERE cch01=ccg.ccg01 AND cch02=ccg.ccg02 AND cch03=ccg.ccg03
#             ORDER BY cch04
#        FOREACH r501_c2 INTO cch.*
#           LET i=20-LENGTH(cch.cch04)
#           PRINT COLUMN g_c[31],cch.cch04,
#                 COLUMN g_c[35],cl_numfor(cch.cch11,35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#                 COLUMN g_c[36],cl_numfor(cch.cch12,36,g_azi03);    #FUN-570190
#                 IF cch.cch05='P' THEN
#                    PRINT COLUMN g_c[37],cl_numfor(cch.cch21,37,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#                          COLUMN g_c[38],cl_numfor(cch.cch22,38,g_azi03);    #FUN-570190
#                 ELSE 
#                    PRINT COLUMN g_c[39],cl_numfor(cch.cch21,39,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#                          COLUMN g_c[40],cl_numfor(cch.cch22,40,g_azi03);    #FUN-570190
#                 END IF
#                 PRINT
#                 COLUMN g_c[41],cl_numfor(cch.cch31,41,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#                 COLUMN g_c[42],cl_numfor(cch.cch32,42,g_azi03),    #FUN-570190
#                 COLUMN g_c[43],cl_numfor(cch.cch91,43,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#                 COLUMN g_c[44],cl_numfor(cch.cch92,44,g_azi03)    #FUN-570190
#        END FOREACH
#        PRINT g_dash1
#     END IF
#  AFTER GROUP OF ccg.ccg04
#   IF GROUP COUNT(*) > 1 THEN
#     IF tm.detail_sw='N' THEN
#        PRINT g_dash1
#     END IF
#     PRINT COLUMN g_c[34],g_x[22] CLIPPED,
#           COLUMN g_c[35],cl_numfor(GROUP SUM(ccg.ccg11 ),35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[36],cl_numfor(GROUP SUM(ccg.ccg12 ),36,g_azi03),    #FUN-570190
#           COLUMN g_c[37],cl_numfor(GROUP SUM(ccg.ccg20 ),37,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[38],cl_numfor(GROUP SUM(ccg.ccg22 ),38,g_azi03),    #FUN-570190
#           COLUMN g_c[39],cl_numfor(GROUP SUM(ccg.ccg21 ),39,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[40],cl_numfor(GROUP SUM(ccg.ccg23 ),40,g_azi03),    #FUN-570190
#           COLUMN g_c[41],cl_numfor(GROUP SUM(ccg.ccg31 ),41,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[42],cl_numfor(GROUP SUM(ccg.ccg32 ),42,g_azi03),    #FUN-570190
#           COLUMN g_c[43],cl_numfor(GROUP SUM(ccg.ccg91 ),43,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[44],cl_numfor(GROUP SUM(ccg.ccg92 ),44,g_azi03)    #FUN-570190
#     IF tm.n='Y' THEN
#        PRINT COLUMN g_c[34],g_x[18] CLIPPED,
#              COLUMN g_c[36],cl_numfor(GROUP SUM(ccg.ccg12a),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(GROUP SUM(ccg.ccg22a),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(GROUP SUM(ccg.ccg23a),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(GROUP SUM(ccg.ccg32a),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(GROUP SUM(ccg.ccg92a),44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34],g_x[19] CLIPPED,
#              COLUMN g_c[36],cl_numfor(GROUP SUM(ccg.ccg12b),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(GROUP SUM(ccg.ccg22b),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(GROUP SUM(ccg.ccg23b),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(GROUP SUM(ccg.ccg32b),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(GROUP SUM(ccg.ccg92b),44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34],g_x[20] CLIPPED,
#              COLUMN g_c[36],cl_numfor(GROUP SUM(ccg.ccg12c),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(GROUP SUM(ccg.ccg22c),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(GROUP SUM(ccg.ccg23c),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(GROUP SUM(ccg.ccg32c),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(GROUP SUM(ccg.ccg92c),44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34],g_x[21] CLIPPED,
#              COLUMN g_c[36],cl_numfor(GROUP SUM(ccg.ccg12d),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(GROUP SUM(ccg.ccg22d),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(GROUP SUM(ccg.ccg23d),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(GROUP SUM(ccg.ccg32d),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(GROUP SUM(ccg.ccg92d),44,g_azi03)    #FUN-570190
#        #start FUN-5B0082
#        PRINT COLUMN g_c[34],g_x[24] CLIPPED,
#              COLUMN g_c[36],cl_numfor(GROUP SUM(ccg.ccg12e),36,g_azi03),
#              COLUMN g_c[38],cl_numfor(GROUP SUM(ccg.ccg22e),38,g_azi03),
#              COLUMN g_c[40],cl_numfor(GROUP SUM(ccg.ccg23e),40,g_azi03),
#              COLUMN g_c[42],cl_numfor(GROUP SUM(ccg.ccg32e),42,g_azi03),
#              COLUMN g_c[44],cl_numfor(GROUP SUM(ccg.ccg92e),44,g_azi03)
#        #end FUN-5B0082
#     END IF
#     PRINT
#   END IF
#  ON LAST ROW
#     PRINT
#     PRINT COLUMN g_c[34],g_x[23] CLIPPED,
#           COLUMN g_c[35],cl_numfor(SUM(ccg.ccg11 ),35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[36],cl_numfor(SUM(ccg.ccg12 ),36,g_azi03),    #FUN-570190
#           COLUMN g_c[37],cl_numfor(SUM(ccg.ccg20 ),37,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[38],cl_numfor(SUM(ccg.ccg22 ),38,g_azi03),    #FUN-570190
#           COLUMN g_c[39],cl_numfor(SUM(ccg.ccg21 ),39,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[40],cl_numfor(SUM(ccg.ccg23 ),40,g_azi03),    #FUN-570190
#           COLUMN g_c[41],cl_numfor(SUM(ccg.ccg31 ),41,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[42],cl_numfor(SUM(ccg.ccg32 ),42,g_azi03),    #FUN-570190
#           COLUMN g_c[43],cl_numfor(SUM(ccg.ccg91 ),43,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[44],cl_numfor(SUM(ccg.ccg92 ),44,g_azi03)    #FUN-570190
#     IF tm.n='Y' THEN
#        PRINT COLUMN g_c[34], g_x[18] CLIPPED,
#              COLUMN g_c[36],cl_numfor(SUM(ccg.ccg12a),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(SUM(ccg.ccg22a),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(SUM(ccg.ccg23a),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(SUM(ccg.ccg32a),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(SUM(ccg.ccg92a),44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34], g_x[19] CLIPPED,
#              COLUMN g_c[36],cl_numfor(SUM(ccg.ccg12b),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(SUM(ccg.ccg22b),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(SUM(ccg.ccg23b),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(SUM(ccg.ccg32b),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(SUM(ccg.ccg92b),44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34], g_x[20] CLIPPED,
#              COLUMN g_c[36],cl_numfor(SUM(ccg.ccg12c),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(SUM(ccg.ccg22c),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(SUM(ccg.ccg23c),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(SUM(ccg.ccg32c),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(SUM(ccg.ccg92c),44,g_azi03)    #FUN-570190
#        PRINT COLUMN g_c[34], g_x[21] CLIPPED,
#              COLUMN g_c[36],cl_numfor(SUM(ccg.ccg12d),36,g_azi03),    #FUN-570190
#              COLUMN g_c[38],cl_numfor(SUM(ccg.ccg22d),38,g_azi03),    #FUN-570190
#              COLUMN g_c[40],cl_numfor(SUM(ccg.ccg23d),40,g_azi03),    #FUN-570190
#              COLUMN g_c[42],cl_numfor(SUM(ccg.ccg32d),42,g_azi03),    #FUN-570190
#              COLUMN g_c[44],cl_numfor(SUM(ccg.ccg92d),44,g_azi03)    #FUN-570190
#        #start FUN-5B0082
#        PRINT COLUMN g_c[34], g_x[24] CLIPPED,
#              COLUMN g_c[36],cl_numfor(SUM(ccg.ccg12e),36,g_azi03),
#              COLUMN g_c[38],cl_numfor(SUM(ccg.ccg22e),38,g_azi03),
#              COLUMN g_c[40],cl_numfor(SUM(ccg.ccg23e),40,g_azi03),
#              COLUMN g_c[42],cl_numfor(SUM(ccg.ccg32e),42,g_azi03),
#              COLUMN g_c[44],cl_numfor(SUM(ccg.ccg92e),44,g_azi03)
#        #end FUN-5B0082
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-8C0047----end--mark--by zj
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r501_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
