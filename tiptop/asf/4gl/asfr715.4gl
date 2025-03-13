# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr715.4gl
# Descriptions...: 工單良率分析表
# Date & Author..: 99/06/01 by iceman
# Modify.........: 02/01/15 By Carol
# Modify.........: No:8659 03/11/06 Melody 針對委外站的 WIP量計算公式有誤
# Modify.........: NO.FUN-510040 05/02/17 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-720005 07/02/13 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/23 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B70050 11/07/07 By guoch mark ecm59
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
              more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
         END RECORD,
         l_sum   LIKE eco_file.eco05,        #No.FUN-680121 DECIMAL(7,2)
         g_sum   LIKE eco_file.eco05,        #No.FUN-680121 DECIMAL(7,2)
         g_tot2  LIKE ste_file.ste06          #No.FUN-680121 DEC(9,2)
DEFINE   g_count LIKE type_file.num5          #No.FUN-680121 SMALLINT
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE    l_table     STRING,                 ### FUN-720005 ###
          g_str       STRING,                 ### FUN-720005 ###
          g_sql       STRING                  ### FUN-720005 ###
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/02/13 TSD.Martin  *** ##
        LET g_sql  = "ecm01.ecm_file.ecm01, ",
                     "ecm03.ecm_file.ecm03, ",
                     "ecm012.ecm_file.ecm012,",    #FUN-A60027
                     "ecm04.ecm_file.ecm04, ",
                     "ecm05.ecm_file.ecm05, ",
                     "ecm45.ecm_file.ecm45, ",
                     "ecm59.ecm_file.ecm59, ",
                     "ecm301.ecm_file.ecm301, ",
                     "ecm302.ecm_file.ecm302, ",
                     "ecm303.ecm_file.ecm303, ",
                     "ecm311.ecm_file.ecm311, ",
                     "ecm314.ecm_file.ecm314, ",
                     "ecm315.ecm_file.ecm315, ",
                     "ecm316.ecm_file.ecm316, ",
                     "sfb06.sfb_file.sfb06,",      #製程編號
                     "shb10.shb_file.shb10,",      #生產料件
                     "shb14.shb_file.shb14,",
                     "shb15.shb_file.shb15,",
                     "ima02.ima_file.ima02,",      #料件名稱
                     "ima021.ima_file.ima021,",     #料件規格
                     "wip_qty.ecm_file.ecm301,",   # WIP量
                     "ecm_k.ste_file.ste06"     #No.FUN-680121 DEC(9,2)#生產良率
 
    LET l_table = cl_prt_temptable('asfr715',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?,  ?, ? , ?, ? ,? ,", 
                "        ?, ?, ?, ?, ?,  ?, ? , ?, ? ,? ,",
                "        ?, ? )"                                  #FUN-A60027 add 1?
 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r715_tm(0,0)        # Input print condition
      ELSE CALL asfr715()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r715_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000          #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 6 LET p_col = 14
   END IF
   OPEN WINDOW r715_w AT p_row,p_col
        WITH FORM "asf/42f/asfr715"
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
   DISPLAY BY NAME tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON shb05,shb10,shb08
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(shb10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shb10
               NEXT FIELD shb10
            END IF
#No.FUN-570240 --end--
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
      ON ACTION help                                          #No.TQC-770004                                                                      
         #CALL cl_dynamic_locale()                                    #No.TQC-770004                                                               
          CALL cl_show_help()                   #No.FUN-550037 hmf           #No.TQC-770004                                                    
         LET g_action_choice = "help"                           #No.TQC-770004                                                                   
         CONTINUE CONSTRUCT                         #No.TQC-770004    
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r715_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
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
      ON ACTION help                                          #No.TQC-770004                                                        
         #CALL cl_dynamic_locale()                                    #No.TQC-770004                                                
          CALL cl_show_help()                   #No.FUN-550037 hmf           #No.TQC-770004                                         
         LET g_action_choice = "help"                           #No.TQC-770004                                                      
         CONTINUE INPUT                         #No.TQC-770004         
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r715_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr715'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr715','9031',1)
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
         CALL cl_cmdat('asfr715',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r715_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr715()
   ERROR ""
END WHILE
   CLOSE WINDOW r715_w
END FUNCTION
 
FUNCTION asfr715()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)
          sr        RECORD LIKE ecm_file.*,
          sr1     RECORD
                  sfb06  LIKE sfb_file.sfb06,     #製程編號
                  shb10  LIKE shb_file.shb10,     #生產料件
                  shb14  LIKE shb_file.shb14,
                  shb15  LIKE shb_file.shb15,
                  ima02  LIKE ima_file.ima02,     #料件名稱
                  ima021 LIKE ima_file.ima021,    #料件規格
                  wip_qty LIKE ecm_file.ecm301,   # WIP量
                  ecm_k  LIKE ste_file.ste06      #No.FUN-680121 DEC(9,2)#生產良率
                  END RECORD
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720005 add ###
     #------------------------------ CR (2) ------------------------------#
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND ecmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND ecmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND ecmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecmuser', 'ecmgrup')
    #End:FUN-980030
 
 
     LET l_sum = 0
     LET g_sum = 0
     LET l_sql =" SELECT ecm_file.*,'',shb10,shb14,shb15,ima02,ima021,0",
                " FROM  ecm_file,shb_file,OUTER ima_file",
                " WHERE shb05 = ecm01 ",
                "   AND shb06 = ecm03 ",
                "   AND shb012 = ecm012 ",                      #FUN-A60027 
                "   AND shb_file.shb10 = ima_file.ima01 ",
                "   AND shbconf = 'Y' ",    #FUN-A70095    
                "   AND ",tm.wc CLIPPED ,
                "   ORDER BY ecm01 "
 
     PREPARE r715_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r715_cs1 CURSOR FOR r715_prepare1
     LET g_tot2 = 0
     LET g_count=0
     FOREACH r715_cs1 INTO sr.*,sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) CONTINUE FOREACH
       END IF
       SELECT sfb06 INTO sr1.sfb06 FROM sfb_file
        WHERE sfb01 = sr.ecm01
 
       IF cl_null(sr1.shb14) AND cl_null(sr1.shb15) THEN
          IF sr.ecm54='Y' THEN   #check in 否
#bugno:4857 add * sr.ecm59 .........................
             LET sr1.wip_qty= sr.ecm291             #check in
                            - sr.ecm311 #*sr.ecm59    #良品轉出  #TQC-B70050 mark
                            - sr.ecm312 #*sr.ecm59    #重工轉出  #TQC-B70050 mark
                            - sr.ecm313 #*sr.ecm59    #當站報廢  #TQC-B70050 mark
                            - sr.ecm314 #*sr.ecm59    #當站下線  #TQC-B70050 mark
                            - sr.ecm316 #*sr.ecm59    #工單轉出  #TQC-B70050 mark
                            - sr.ecm321             #委外加工量
                            + sr.ecm322             #委外完工量
          ELSE
             LET sr1.wip_qty= sr.ecm301             #良品轉入量
                            + sr.ecm302             #重工轉入量
                            + sr.ecm303             #工單轉入
                            - sr.ecm311 #*sr.ecm59    #良品轉出  #TQC-B70050 mark
                            - sr.ecm312 #*sr.ecm59    #重工轉出  #TQC-B70050 mark
                            - sr.ecm313 #*sr.ecm59    #當站報廢  #TQC-B70050 mark
                            - sr.ecm314 #*sr.ecm59    #當站下線  #TQC-B70050 mark
                            - sr.ecm316 #*sr.ecm59    #工單轉出
                            - sr.ecm321             #委外加工量
                            + sr.ecm322             #委外完工量
          END IF
       ELSE
          LET sr1.wip_qty = sr.ecm321 - sr.ecm322   #No:8659
       END IF
#bugno:4857 end .......................
       IF cl_null(sr1.wip_qty) THEN LET sr1.wip_qty = 0  END IF
 
       #IF sr.ecm301+sr.ecm302 <> 0 THEN
       #LET sr.ecm_k = (sr.ecm311 - sr.ecm302) / (sr.ecm301 + sr.ecm302_l)*100
 
       # bug no:4147 02/01/15 Modify Carol
       # 當站良率=(良品轉出+工單轉出+bomus+當站下線)/
       #          (良品轉入+工單轉入+重工轉入-WIP)
       IF cl_null(sr.ecm311) THEN  LET sr.ecm311 = 0  END IF
       IF cl_null(sr.ecm316) THEN  LET sr.ecm316 = 0  END IF
       IF cl_null(sr.ecm315) THEN  LET sr.ecm315 = 0  END IF
       IF cl_null(sr.ecm314) THEN  LET sr.ecm314 = 0  END IF
       IF cl_null(sr.ecm301) THEN  LET sr.ecm301 = 0  END IF
       IF cl_null(sr.ecm303) THEN  LET sr.ecm303 = 0  END IF
       IF cl_null(sr.ecm302) THEN  LET sr.ecm302 = 0  END IF
       IF sr.ecm301+sr.ecm302 <> 0 THEN
   #    LET sr1.ecm_k=((( sr.ecm311+sr.ecm316+sr.ecm315+sr.ecm314 )*sr.ecm59) /   #TQC-B70050 mark
       LET sr1.ecm_k=((( sr.ecm311+sr.ecm316+sr.ecm315+sr.ecm314 )) /  #TQC-B70050 add
                      ( sr.ecm301+sr.ecm303+sr.ecm302-sr1.wip_qty ))*100
      END IF
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
        LET sr.ecm311 = sr.ecm311 # * sr.ecm59    #TQC-B70050 mark
        LET sr.ecm314 = sr.ecm314 # * sr.ecm59    #TQC-B70050 mark
        LET sr.ecm315 = sr.ecm315 # * sr.ecm59    #TQC-B70050 mark
        LET sr.ecm316 = sr.ecm316 # * sr.ecm59    #TQC-B70050 mark
        EXECUTE insert_prep USING 
                sr.ecm01, sr.ecm03,sr.ecm012, sr.ecm04, sr.ecm05, sr.ecm45,    #FUN-A60027 add ecm012
                sr.ecm59,sr.ecm301,sr.ecm302,sr.ecm303,sr.ecm311,
               sr.ecm314,sr.ecm315,sr.ecm316,sr1.sfb06,sr1.shb10,
               sr1.shb14,sr1.shb15,sr1.ima02,sr1.ima021,
               sr1.wip_qty,sr1.ecm_k
      #------------------------------ CR (3) ------------------------------#
     END FOREACH
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'shb05,shb10,shb08') 
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
    #CALL cl_prt_cs3('asfr715','asfr715',l_sql,g_str)   #FUN-710080 modify   #FUN-A60027 
    #FUN-A60027 -------------------start------------------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr715','asfr715_1',l_sql,g_str)
     ELSE
        CALL cl_prt_cs3('asfr715','asfr715',l_sql,g_str)
     END IF 
    #FUN-A60027 ------------------end--------------------------
     #------------------------------ CR (4) ------------------------------#
END FUNCTION
