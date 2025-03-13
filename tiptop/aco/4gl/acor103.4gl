# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor103.4gl
# Desc/riptions..: 成品對應料件單消耗情況表
# Date & Author..: 00/09/07 By Mandy
# Modify.........: NO.MOD-490398 04/11/22 BY Elva add HS Code,coc10,Customs No.
# Modify.........: NO.MOD-490398 05/02/25 BY Elva add print cod041
# Modify.........: No.FUN-580110 05/08/25 By Tracy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-5C0019 05/12/06 By Rosayu 無法產生報表會有錯誤訊息
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-640173 06/04/21 By pengu 宣告databaseg時錯誤照成compiler不會過
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/05/28 By TSD.liquor 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds   #No.TQC-640173 modify
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
                 wc  	STRING,                       # Where condition No.TQC-630166
                  y     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)  # NO.MOD-490398
                 more	LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD,
           g_title    DYNAMIC ARRAY OF RECORD     #存放title的分類KEY
                            cod03  LIKE cod_file.cod03,   #商品編號
                            cod041 LIKE cod_file.cod041,  #BOM版本編號
                            cod04  LIKE cod_file.cod04,   #NO.MOD-490398
                            cob09  LIKE cob_file.cob09,   #NO.MOD-490398
                            cob02  LIKE cob_file.cob02
                        END RECORD,
           g_record     DYNAMIC ARRAY OF RECORD    #存放料件的分類KEY
                            con03  LIKE con_file.con03    #海關料件
                        END RECORD,
           g_row        LIKE type_file.num5,        #No.FUN-680069 SMALLINT
           g_column     LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE     g_i          LIKE type_file.num5         #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE     g_head1      STRING                      #No.FUN-580110
DEFINE  g_sql       STRING,      #FUN-840238 add
        g_str       STRING,      #FUN-840238 add
        l_table     STRING       #FUN-840238 add
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
#---FUN-840238 add ---start
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "sn.cod_file.cod02,",       #序號
               "coc01.coc_file.coc01,",    #申請編號
               "coc04.coc_file.coc04,",    #合同編號
               "coc03.coc_file.coc03,",    #手冊編號
               "cob01.cob_file.cob01,",    #產品編號
               "cob02.cob_file.cob02,",    #品名
               "cob021.cob_file.cob021,",  #規格
               "cod03.cod_file.cod03,",    #商品編號
               "cod041.cod_file.cod041,",  #BOM版本編號
               "con05.con_file.con05,",    #單耗
               "con06.con_file.con06"      #損耗率
 
   LET l_table = cl_prt_temptable('acor211',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
  #------------------------------ CR (1) ------------------------------#
#---FUN-840238 add ---end
 
 
 
    LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
        CALL r103_tm(0,0)		        # Input print condition
    ELSE
        CALL acor103()		# Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION r103_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680069 SMALLINT
           l_cmd	LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(400)
           l_a          LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_n          LIKE type_file.num5           #No.FUN-680069 SMALLINT
 
    LET p_row = 5 LET p_col = 20
 
    OPEN WINDOW r103_w AT p_row,p_col WITH FORM "aco/42f/acor103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL			# Default condition
     LET tm.y     = 'N'    #NO.MOD-490398
    LET tm.more  = 'N'
    LET g_pdate  = g_today
    LET g_rlang  = g_lang
    LET g_bgjob  = 'N'
    LET g_copies = '1'
WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON coc01,coc04,coc10,coc03   #NO.MOD-490398
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r103_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
    END IF
    IF tm.wc = " 1=1 "  THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
    END IF
 #NO.MOD-490398--begin
    DISPLAY BY NAME tm.y,tm.more  #Condition
    INPUT BY NAME tm.y,tm.more WITHOUT DEFAULTS
 #NO.MOD-490398--end
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
    AFTER FIELD more
        IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
        END IF
        IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
        END IF
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
    ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
        LET INT_FLAG = 0 CLOSE WINDOW r103_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
            WHERE zz01='acor103'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('acor103','9031',1)
        ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('acor103',g_time,l_cmd)      # Execute cmd at later time
        END IF
        CLOSE WINDOW r103_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL acor103()
    ERROR ""
END WHILE
    CLOSE WINDOW r103_w
END FUNCTION
 
FUNCTION acor103()
    DEFINE l_name	LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time           LIKE type_file.chr8	    #No.FUN-6A0063
           l_sql 	LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
           l_sql1 	LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
           l_chr        LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           l_i          LIKE type_file.num5,         #No.FUN-680069 SMALLINT
           sr           RECORD coc01    LIKE coc_file.coc01, #申請編號
                               coc04    LIKE coc_file.coc04, #合同編號
                               coc03    LIKE coc_file.coc03  #手冊編號
                        END RECORD
    #FUN-840238 add
    DEFINE sr1          RECORD sn       LIKE cod_file.cod02,    #序號
                               coc01    LIKE coc_file.coc01,    #申請編號
                               coc04    LIKE coc_file.coc04,    #合同編號
                               coc03    LIKE coc_file.coc03,    #手冊編號
                               cob01    LIKE cob_file.cob01,    #產品編號
                               cob02    LIKE cob_file.cob02,    #品名
                               cob021   LIKE cob_file.cob021,   #規格
                               cod03    LIKE cod_file.cod03,    #商品編號
                               cod041   LIKE cod_file.cod041,   #BOM版本編號
                               con05    LIKE con_file.con05,    #單耗
                               con06    LIKE con_file.con06     #損耗率
                        END RECORD,
           l_coc01_t    LIKE coc_file.coc01,
           l_coc04_t    LIKE coc_file.coc04,
           l_coc03_t    LIKE coc_file.coc03,
           l_cob01_t    LIKE cob_file.cob01,
           l_sn_t       LIKE cod_file.cod02
     #FUN-840238 add end
 
    #FUN-840238 add 
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #其他列印條件
    #FUN-840238 add end
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND cocuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
    #End:FUN-980030
 
    #FUN-840238 add
    LET l_sql = "SELECT 1,coc01,coc04,coc03,con03,'','',",
                "       cod03,cod041,con05,con06 ",
                "  FROM coc_file LEFT OUTER JOIN cod_file ",
                 "                                LEFT OUTER JOIN con_file ON cod03 = con01 ",
                " AND cod041 = con013 ",
                "                    AND cod041 = con013 ",
                "      ON coc01 = cod01 ",
                "      AND ",tm.wc CLIPPED,
                "    ORDER BY coc01,coc04,coc03,cod03 "
 
    PREPARE r103_prepare FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
    END IF
    DECLARE r103_cs CURSOR FOR r103_prepare
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
    END IF
 
    FOREACH r103_cs INTO sr1.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
 
        IF sr1.coc01 = l_coc01_t AND sr1.coc04 = l_coc04_t 
           AND sr1.coc03 = l_coc03_t THEN
           IF sr1.cob01 <> l_cob01_t THEN
              LET sr1.sn = l_sn_t + 1
           ELSE
              LET sr1.sn = l_sn_t
           END IF
        END IF
        LET l_coc01_t = sr1.coc01
        LET l_coc04_t = sr1.coc04
        LET l_coc03_t = sr1.coc03
        LET l_cob01_t = sr1.cob01
        LET l_sn_t = sr1.sn
 
        SELECT cob01,cob02,cob021 INTO sr1.cob01,sr1.cob02,sr1.cob021
          FROM cob_file
            WHERE cob01 = sr1.cob01
 
        IF tm.y = 'Y' THEN
           SELECT cob09 INTO sr1.cod03 
             FROM cob_file 
               WHERE cob01=sr1.cod03
        END IF  
        EXECUTE insert_prep USING sr1.*  
        IF SQLCA.sqlcode  THEN
           CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
        END IF
    END FOREACH
 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'coc01,coc04,coc10,coc03')
            RETURNING g_str
    END IF
    CALL cl_prt_cs3('acor103','acor103',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    #FUN-840238 add end
    
   
 
{%1}LET l_sql = " SELECT coc01,coc04,coc03 ",
               #"   FROM coc_file",          #TQC-5C0019 mark
                "   FROM coc_file,cod_file", #TQC-5C0019 add cod_file
                "  WHERE ",tm.wc CLIPPED,
                "    AND cocacti = 'Y' ",
                "    AND coc01=cod01 "       #TQC-5C0019 add
    LET l_sql = l_sql CLIPPED," ORDER BY coc01,coc04,coc03 "
    PREPARE r103_prepare1 FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
    END IF
    DECLARE r103_cs1 CURSOR FOR r103_prepare1
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
    END IF
 
 {%2}LET l_sql = "SELECT cod03,cod041,cod04  ",#NO.MOD-490398
                "    FROM cod_file     ",
                "    WHERE cod01 = ?   ",  #cod01 = coc01
                 " ORDER BY cod03,cod041,cod04 " #NO.MOD-490398
    PREPARE r103_prepare2 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
          
    END IF
    DECLARE r103_cs2 CURSOR FOR r103_prepare2
{%3} LET l_sql = " SELECT UNIQUE con03 ",
                 "   FROM cod_file, OUTER con_file",
                 "  WHERE cod01  = ? ",
                 "    AND cod03 =con_file.con01       ",
                 "    AND cod041 = con_file.con013        ",
                  "    AND cod04 = con_file.con08 ", #NO.MOD-490398
                 "  ORDER BY con03       "
    PREPARE r103_prepare3 FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:3',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
    END IF
    DECLARE r103_cs3 CURSOR FOR r103_prepare3
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:r103_cs3',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
    END IF
    FOREACH r103_cs1 INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
    END FOREACH
 
END FUNCTION
#No.FUN-870144
