# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amsr610.4gl
# Desc/riptions..: 資源別產能負荷分析表
# Date & Author..: 00/08/07 By Byron
# Modify.........: No.FUN-510036 05/01/19 By pengu 報表轉XML
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 報表Title[31]忘記印
# Modify.........; NO.MOD-640331 06/04/10 BY Claire 報表內容的"產能單位",請同amsq610一樣顯示"機時"or"人時"
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: No.TQC-6B0011 06/11/30 By Sarah 差異、負荷率沒有靠右
# Modify.........: No.FUN-740078 07/04/30 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: NO.FUN-8B0002 09/02/10 By lilingyu mark cl_outnam()
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D10045 13/01/29 By xuxz 添加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                       # Print condition RECORD
             wc      STRING    ,           # Where condition #TQC-630166
             ver_no  LIKE rqa_file.rqa02,  #版本
             more    LIKE type_file.chr1   #NO.FUN-680101 VARCHAR(1)   # Input more condition(Y/N)
          END RECORD
DEFINE   g_cnt       LIKE type_file.num10  #NO.FUN-680101 INTEGER
DEFINE   g_i         LIKE type_file.num5   #NO.FUN-680101 SMALLINT  #count/index for any purpose
DEFINE   l_table         STRING, #FUN-740078###
         g_str           STRING, #FUN-740078###
         g_sql           STRING  #FUN-740078### 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
   #str FUN-740078 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/30 TSD.liquor *** ##
   LET g_sql  = "rqa01.rqa_file.rqa01,",
                "rqa03.rqa_file.rqa03,",
                "rqa04.rqa_file.rqa04,",
                "rqa05.rqa_file.rqa05,",
                "rqa06.rqa_file.rqa06,",
                "rpf02.rpf_file.rpf02,",
                "rpf03.rpf_file.rpf03"
   LET l_table = cl_prt_temptable('amsr610',g_sql) CLIPPED          # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                         # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,            # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054
               " VALUES(?, ?, ?, ?, ?,  ?, ?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-740078 add
 
 
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'    # If background job sw is off
      THEN CALL r610_tm(0,0)        # Input print condition
      ELSE CALL amsr610()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r610_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680101 SMALLINT
          l_flag         LIKE type_file.chr1,  #NO.FUN-680101 VARCHAR(01)
          l_cmd          LIKE type_file.chr1000#NO.FUN-680101 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 32
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r610_w AT p_row,p_col
        WITH FORM "ams/42f/amsr610"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
    LET tm.ver_no=' '
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rqa01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    #tQC-D10045--add--str
     ON ACTION controlp
        CASE
           WHEN INFIELD(rqa01)    
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rqa01"
              LET g_qryparam.state= "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rqa01
              NEXT FIELD rqa01
        END CASE
    #TQC-D10045-add--end
 
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
 
		
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      LET tm.ver_no=' '
      LET tm.more = 'N'
      INPUT BY NAME tm.ver_no,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD ver_no
#           IF cl_null(tm.ver_no) THEN
#              CALL cl_err('','9033',0)
#              NEXT FIELD ver_no
#           ELSE
               SELECT COUNT(*) INTO g_cnt
                FROM rqa_file WHERE rqa02 = tm.ver_no
               IF g_cnt IS NULL OR g_cnt = 0 THEN
                  CALL cl_err(tm.ver_no,'ams-367',1)
                  LET tm.ver_no=' '
                  NEXT FIELD ver_no
               END IF
#          END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' THEN
               CALL cl_err('','9061',0)
             #  LET tm.more=' '
               NEXT FIELD more
            END IF
            If cl_null(tm.more) THEN
               CALL cl_err('','9033',0)
               NEXT FIELD more
            END IF
            IF tm.more = 'Y'  #cl_repcon只負責傳值的動作
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
              g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
              g_bgjob,g_time,g_prtway,g_copies
              LET INT_FLAG=0 #因在開副程式時,只要按del INT_FLAG就等於1
                             #故要還原
            END IF
         AFTER INPUT #INPUT欄位時,INPUT完後的判斷
            IF INT_FLAG THEN  #USER按del時INT_FLAG=1時的判斷
               LET INT_FLAG = 0 CLOSE WINDOW r610_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
               EXIT PROGRAM
                  
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
         LET INT_FLAG = 0 CLOSE WINDOW r610_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsr610'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amsr610','9031',1)
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
                   " '",tm.ver_no CLIPPED,"'",
                   " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                   " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                   " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
             CALL cl_cmdat('amsr610',g_time,l_cmd)   # Execute cmd at later time
         END IF
         CLOSE WINDOW r610_w #後來自己加的
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM        #後來自己加的
      END IF
      CALL cl_wait()
      CALL amsr610()
      ERROR ""
   END WHILE
   CLOSE WINDOW r610_w
END FUNCTION
 
FUNCTION amsr610()
   DEFINE
      l_name    LIKE type_file.chr20,   #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name
#       l_time      LIKE type_file.chr8        #No.FUN-6A0081
      l_sql     LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(1100) # RDSQL STATEMET
      l_chr     LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
      l_za05    LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(40)
      l_date    LIKE type_file.dat,     #NO.FUN-680101 DATE
      sr        RECORD #要列印出來的資料放在sr
        rqa01   LIKE rqa_file.rqa01, #資源代號
        rqa03   LIKE rqa_file.rqa03, #起始日期
        rqa04   LIKE rqa_file.rqa04, #截止日期
        rqa05   LIKE rqa_file.rqa05, #當日產能
        rqa06   LIKE rqa_file.rqa06, #已耗產能
        rpf02   LIKE rpf_file.rpf02, #資源名稱
        rpf03   LIKE rpf_file.rpf03 #產能單位
            END RECORD
   #str FUN-740078 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740078 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = g_prog
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND rqauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND rqagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND rqagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rqauser', 'rqagrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT ",
               " rqa01,rqa03,rqa04,rqa05,rqa06,rpf02,rpf03  ",
               " FROM rqa_file,rpf_file ",
               " WHERE rqa02 = '",tm.ver_no,"'",
               "   AND rqa01 = rpf01 ",
               " AND ",tm.wc CLIPPED
   PREPARE r610_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   DECLARE r610_cs1 CURSOR FOR r610_prepare1
#   CALL cl_outnam('amsr610') RETURNING l_name #FUN-8B0002
   LET g_pageno = 0
   FOREACH r610_cs1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #str FUN-740078 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740078 *** ##
      EXECUTE insert_prep USING
              sr.rqa01,sr.rqa03,sr.rqa04,sr.rqa05,sr.rqa06,sr.rpf02,sr.rpf03 
      #------------------------------ CR (3) ------------------------------#
      #end FUN-740078 add
   END FOREACH
   #str FUN-740078 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740078 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'rqa01')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str ,";",tm.ver_no
   CALL cl_prt_cs3('amsr610','amsr610',l_sql,g_str)  
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740078 add
END FUNCTION
