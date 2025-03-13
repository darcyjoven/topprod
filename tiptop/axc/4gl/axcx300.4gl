# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: axcx300.4gl
# Descriptions...: 兩月成本差異比較明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/11/24 by nick 
# Modify.........: No.FUN-4C0099 04/12/30 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/22 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-5C0002 05/12/05 By Sarah 最後一頁應該印(結束)卻印(接下頁)
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: NO.MOD-720042 07/02/07 By TSD.Sideny 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-7C0101 08/01/23 By Zhangyajun 成本改善增加成本計算類型(type)
# Modify.........: No.FUN-840016 08/04/07 By Zhangyajun 報表修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-970190 09/07/22 By mike 1.調整UPDATE x300_tmp的程式段，c5與c10兩個欄位update的值應該是sr.ccc23e才對，此程>
#                                                   所以只須調整ora檔即可。                                                         
#                                                 2.GP5.1此程式段多新增了c51、c52、c53、c101、c102、c103，但ora檔卻未一并更新，請一>
#                                                   而c52與c102要用sr.ccc23g，c53與c103要用sr.ccc23。                               
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30060 13/03/21 By wangrr CR转为XtraGrid報表
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
              yy1,mm1,yy2,mm2,x   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,         #No.FUN-7C0101 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE nma_file.nma12        #No.FUN-680122 DECIMAL(13,2)    # User defined variable
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122DATE 
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122DATE 
    DEFINE g_sql	  string  #No.FUN-580092 HCN
   DEFINE g_argv1 LIKE type_file.chr20          #No.FUN-680122 VARCHAR(20)
   DEFINE g_argv2 LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE g_argv3 LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE g_argv4 LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE g_argv5 LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE g_argv6 LIKE type_file.num5           #No.FUN-680122SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122CHAR(72)
 
DEFINE l_table    STRING #NO.MOD-720042 07/02/07 By TSD.Sideny
DEFINE g_str      STRING #NO.MOD-720042 07/02/07 By TSD.Sideny
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
  #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "type.type_file.num5,",
               "pn.type_file.chr20,",
               "n1.ccc_file.ccc23a,",
               "n2.ccc_file.ccc23a,",
               "diff.rmf_file.rmf35,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ccc08.ccc_file.ccc08,",
               "item_type.type_file.chr1000,", #FUN-D30060
               "azi03.azi_file.azi03,",  #FUN-D30060
               "azi04.azi_file.azi04"    #FUN-D30060

   LET l_table = cl_prt_temptable('axcx300',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"  #FUN-D30060 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
 
  #TQC-610051-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_argv1 = ARG_VAL(1)        # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)        # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)        # Get arguments from command line
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(4)
   #LET g_rep_clas = ARG_VAL(5)
   #LET g_template = ARG_VAL(6)
   ##No.FUN-570264 ---end---
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.yy1 = ARG_VAL(8)
   LET tm.mm1 = ARG_VAL(9)
   LET tm.yy2 = ARG_VAL(10)
   LET tm.mm2 = ARG_VAL(11)
   LET tm.x   = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET tm.type = ARG_VAL(16)    #No.FUN-7C0101 add
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
  #TQC-610051-end
#CREATE TEMP TABLE
   DROP TABLE x300_tmp
#No.FUN-680122 -- begin --
#     CREATE TEMP TABLE x300_tmp(pn VARCHAR(40),yy1 smallint,mm1 smallint,      #FUN-560011
#      c1 dec(15,5),c2 dec(15,5),c3 dec(15,5),c4 dec(15,5),c5 dec(15,5),
#     yy2 smallint,mm2 smallint,c6 dec(15,5),c7 dec(15,5),c8 dec(15,5),
#      c9 dec(15,5),c10 dec(15,5));
     CREATE TEMP TABLE x300_tmp(
        pn  LIKE ccc_file.ccc01,
        yy1 LIKE ccc_file.ccc02,
        mm1 LIKE ccc_file.ccc03,
        ccc08 LIKE ccc_file.ccc08,     #No.FUN-7C0101
        c1  LIKE ccc_file.ccc23a,
        c2  LIKE ccc_file.ccc23b,
        c3  LIKE ccc_file.ccc23c,
        c4  LIKE ccc_file.ccc23d,
        c5  LIKE ccc_file.ccc23e,
        c51 LIKE ccc_file.ccc23f,     #No.FUN-7C0101
        c52 LIKE ccc_file.ccc23g,     #No.FUN-7C0101
        c53 LIKE ccc_file.ccc23h,     #No.FUN-7C0101
        yy2 LIKE ccc_file.ccc02,
        mm2 LIKE ccc_file.ccc03,
        c6  LIKE ccc_file.ccc23a,
        c7  LIKE ccc_file.ccc23b,
        c8  LIKE ccc_file.ccc23c,
        c9  LIKE ccc_file.ccc23d,
        c10 LIKE ccc_file.ccc23e,
        c101 LIKE ccc_file.ccc23f,    #No.FUN-7C0101
        c102 LIKE ccc_file.ccc23g,    #No.FUN-7C0101
        c103 LIKE ccc_file.ccc23h);   #No.FUN-7C0101
#No.FUN-680122 -- end --
   CREATE UNIQUE INDEX x300_01 ON x300_tmp(pn);
 
   #TQC-610051-begin
   #IF cl_null(g_argv1)
   # Prog. Version..: '5.30.07-13.05.16(0,0)        # Input print condition
   #   ELSE LET tm.wc=" ima01='",g_argv1,"'"
   #        LET tm.yy1=g_argv2
   #        LET tm.mm1=g_argv3
   #        LET tm.yy2=g_argv4
   #        LET tm.mm2=g_argv5
   #        LET tm.x  =g_argv6
   #        CALL axcx300()            # Read data and create out-file
   #END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL axcx300_tm(0,0)         # Input print condition
      ELSE CALL axcx300()               # Read data and create out-file
   END IF
   #TQC-610051-end
   DROP TABLE x300_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcx300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 28 
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcx300_w AT p_row,p_col
        WITH FORM "axc/42f/axcx300" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
  #TQC-610051-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #TQC-610051-end
   LET tm.x = 5
   LET tm.type = g_ccz.ccz28     #No.FUN-7C0101
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ccc01 
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
     ON ACTION CONTROLP                                                      
        IF INFIELD(ccc01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ccc01                             
           NEXT FIELD ccc01                                                 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cccuser', 'cccgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcx300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.yy1,tm.mm1,tm.yy2,tm.mm2,tm.x,tm.type,tm.more   #No.FUN-7C
   WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD x
         IF tm.x < 0 THEN NEXT FIELD x END IF
      AFTER FIELD yy1
         IF tm.yy1 IS NULL THEN NEXT FIELD yy1 END IF
      AFTER FIELD mm1
         IF tm.mm1 IS NULL THEN NEXT FIELD mm1 END IF
      AFTER FIELD yy2
         IF tm.yy2 IS NULL THEN NEXT FIELD yy2 END IF
      AFTER FIELD mm2
         IF tm.mm2 IS NULL THEN NEXT FIELD mm2 END IF
      #No.FUN-7C0101--start--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      #No.FUN-7C0101---end---
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
      LET INT_FLAG = 0 CLOSE WINDOW axcx300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcx300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcx300','9031',1)   
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
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.mm1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.mm2 CLIPPED,"'",
                         " '",tm.x   CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101 add
                        #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcx300',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcx300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcx300()
   ERROR ""
END WHILE
   CLOSE WINDOW axcx300_w
END FUNCTION
 
FUNCTION axcx300()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT                #No.FUN-680122CHAR(600) #TQC-840066
          u_sign    LIKE type_file.num5,           #No.FUN-680122SMALLINT, 
          l_sfb99   LIKE sfb_file.sfb99,           #No.FUN-680122CHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE cre_file.cre08,                               #No.FUN-680122 VARCHAR(10)
          l_diff    LIKE oad_file.oad041,          #No.FUN-680122DEC(6,2)
          l_type    LIKE type_file.num5, #NO.MOD-720042 07/02/07 By TSD.Sideny
          l_ima02   LIKE ima_file.ima02, #NO.MOD-720042 07/02/07 By TSD.Sideny
          l_ima021  LIKE ima_file.ima021, #NO.MOD-720042 07/02/07 By TSD.Sideny
          sr            RECORD ccc01 LIKE ccc_file.ccc01,
                               ccc02 LIKE ccc_file.ccc02,
                               ccc03 LIKE ccc_file.ccc03,
                               ccc08 LIKE ccc_file.ccc08,          #No.FUN-7C0101 VARCHAR(40)
                               ccc23a LIKE ccc_file.ccc23a,
                               ccc23b LIKE ccc_file.ccc23b,
                               ccc23c LIKE ccc_file.ccc23c,
                               ccc23d LIKE ccc_file.ccc23d,
                               ccc23e LIKE ccc_file.ccc23e,
                               ccc23f LIKE ccc_file.ccc23f,      #No.FUN-7C0101 dec(20,6)
                               ccc23g LIKE ccc_file.ccc23g,      #No.FUN-7C0101 dec(20,6)
                               ccc23h LIKE ccc_file.ccc23h       #No.FUN-7C0101 dec(20,6)
                        END RECORD,
          sr1           RECORD pn  LIKE ccc_file.ccc01,           #No.FUN-680122char(20)
                               yy1 LIKE ccc_file.ccc02,           #No.FUN-680122smallint
                               mm1 LIKE ccc_file.ccc03,           #No.FUN-680122smallint
                               ccc08 LIKE ccc_file.ccc08,         #No.FUN-7C0101 VARCHAR(40)
                               c1  LIKE ccc_file.ccc23a,          #No.FUN-680122  dec(15,5)
                               c2  LIKE ccc_file.ccc23b,          #No.FUN-680122 dec(15,5)
                               c3  LIKE ccc_file.ccc23c,          #No.FUN-680122 dec(15,5)
                               c4  LIKE ccc_file.ccc23d,          #No.FUN-680122 dec(15,5)
                               c5  LIKE ccc_file.ccc23e,          #No.FUN-680122 dec(15,5)
                               c51 LIKE ccc_file.ccc23f,          #No.FUN-7C0101 dec(20,6)
                               c52 LIKE ccc_file.ccc23g,          #No.FUN-7C0101 dec(20,6)
                               c53 LIKE ccc_file.ccc23h,          #No.FUN-7C0101 dec(20,6)
                               yy2 LIKE ccc_file.ccc02,           #No.FUN-680122smallint
                               mm2 LIKE ccc_file.ccc03,           #No.FUN-680122smallint
                               c6  LIKE ccc_file.ccc23a,          #No.FUN-680122 dec(15,5)
                               c7  LIKE ccc_file.ccc23b,          #No.FUN-680122 dec(15,5)
                               c8  LIKE ccc_file.ccc23c,          #No.FUN-680122 dec(15,5)
                               c9  LIKE ccc_file.ccc23d,          #No.FUN-680122 dec(15,5)
                               c10 LIKE ccc_file.ccc23e,          #No.FUN-680122 dec(15,5)
                               c101 LIKE ccc_file.ccc23f,         #No.FUN-7C0101 dec(20,6)
                               c102 LIKE ccc_file.ccc23g,         #No.FUN-7C0101 dec(20,6)
                               c103 LIKE ccc_file.ccc23h          #No.FUN-7C0101 dec(20,6)
                        END RECORD
   DEFINE l_item_type    LIKE type_file.chr1000 #FUN-D30060
   DEFINE l_azi03        LIKE azi_file.azi03
   DEFINE l_azi04        LIKE azi_file.azi04
 
    #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
    #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720042 add
 
    #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
    #CALL cl_outnam('axcx300') RETURNING l_name
    #START REPORT axcx300_rep TO l_name
    #LET g_pageno = 0
    #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
     DELETE FROM x300_tmp;
#--------------------------------------------------------------- 取 ccg_file
     LET l_sql = "SELECT ccc01,ccc02,ccc03,ccc08,ccc23a,ccc23b,ccc23c,",  
                 "ccc23d,ccc23e,ccc23f,ccc23g,ccc23h ",    #No.FUN-7C0101
                 "  FROM ccc_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND ((ccc02=",tm.yy1," AND ccc03=",tm.mm1,
                 ") OR (ccc02=",tm.yy2," AND ccc03=",tm.mm2,"))",
                 " AND ccc07='",tm.type,"'"    #No.FUN-7C0101 add
                
     PREPARE axcx300_prepare1 FROM l_sql
     DECLARE axcx300_curs1 CURSOR WITH HOLD FOR axcx300_prepare1
     FOREACH axcx300_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       IF tm.yy1=sr.ccc02 AND tm.mm1=sr.ccc03 THEN
         UPDATE x300_tmp SET pn=sr.ccc01,yy1=sr.ccc02,mm1=sr.ccc03,ccc08=sr.ccc08,c1=sr.ccc23a,c2=sr.ccc23b,c3=sr.ccc23c,c4=sr.ccc23d,c5=sr.ccc23e,c51=sr.ccc23f,c52=sr.ccc23g,c53=sr.ccc23h   #No.FUN-7C0101 modify #MOD-970190 modify ora
           WHERE pn=sr.ccc01
          IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
             INSERT INTO x300_tmp(pn,yy1,mm1,ccc08,c1,c2,c3,c4,c5,c51,c52,c53) VALUES(sr.*) #No.FUN-7C0101 modify
          END IF
       ELSE
         UPDATE x300_tmp SET pn=sr.ccc01,yy2=sr.ccc02,mm2=sr.ccc03,ccc08=sr.ccc08,c6=sr.ccc23a,c7=sr.ccc23b,c8=sr.ccc23c,c9=sr.ccc23d,c10=sr.ccc23e,c101=sr.ccc23f,c102=sr.ccc23g,c103=sr.ccc23h   #No.FUN-7C0101 modify #MOD-970190 modify ora
           WHERE pn=sr.ccc01
          IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
             INSERT INTO x300_tmp(pn,yy2,mm2,ccc08,c6,c7,c8,c9,c10,c101,c102,c103) VALUES(sr.*) #No.FUN-7C0101 modify
          END IF
       END IF
     END FOREACH
 
     DECLARE x300_curs2 CURSOR WITH HOLD FOR SELECT * FROM x300_tmp
     FOREACH x300_curs2 INTO sr1.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       LET l_item_type='' #FUN-D30060
       IF sr1.c1 IS NOT NULL THEN 
         IF sr1.c6 IS NULL THEN LET sr1.c6 = 0 END IF
          LET l_diff=0
          LET l_diff=(sr1.c6-sr1.c1)/sr1.c1*100
          IF l_diff>tm.x OR l_diff < (tm.x * -1) THEN
            #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
             LET l_type = 1
             SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr1.pn
             LET l_item_type=cl_gr_getmsg('axc-136',g_lang,l_type) #FUN-D30060
             LET l_azi03=5   #FUN-D30060
             LET l_azi04=2   #FUN-D30060
             EXECUTE insert_prep USING l_type,sr1.pn,sr1.c1,sr1.c6,l_diff,l_ima02,l_ima021,sr1.ccc08   #No.FUN-7C0101 add ccc08
                                      ,l_item_type,l_azi03,l_azi04  #FUN-D30060 
            #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
          END IF
       END IF
       IF sr1.c2 IS NOT NULL THEN 
          IF sr1.c7 IS NULL THEN LET sr1.c7 = 0 END IF
          LET l_diff=0
          LET l_diff=(sr1.c7-sr1.c2)/sr1.c2*100
          IF l_diff > tm.x OR l_diff < (tm.x * -1) THEN
            #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
             LET l_type = 2
             SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr1.pn
             LET l_item_type=cl_gr_getmsg('axc-136',g_lang,l_type) #FUN-D30060
             LET l_azi03=5   #FUN-D30060
             LET l_azi04=2   #FUN-D30060
             EXECUTE insert_prep USING l_type,sr1.pn,sr1.c2,sr1.c7,l_diff,l_ima02,l_ima021,sr1.ccc08    #No.FUN-7C0101 add ccc08
                                      ,l_item_type,l_azi03,l_azi04  #FUN-D30060 
            #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
          END IF
       END IF
       IF sr1.c3 IS NOT NULL THEN 
          IF sr1.c8 IS NULL THEN LET sr1.c8 = 0 END IF
          LET l_diff=0
          LET l_diff=(sr1.c8-sr1.c3)/sr1.c3*100
          IF l_diff>tm.x OR l_diff < (tm.x * -1) THEN
            #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
             LET l_type = 3
             SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr1.pn
             LET l_item_type=cl_gr_getmsg('axc-136',g_lang,l_type) #FUN-D30060
             LET l_azi03=5   #FUN-D30060
             LET l_azi04=2   #FUN-D30060  
             EXECUTE insert_prep USING l_type,sr1.pn,sr1.c3,sr1.c8,l_diff,l_ima02,l_ima021,sr1.ccc08    #No.FUN-7C0101 add ccc08
                                      ,l_item_type,l_azi03,l_azi04  #FUN-D30060
             #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
          END IF
       END IF
       IF sr1.c4 IS NOT NULL THEN 
          IF sr1.c9 IS NULL THEN LET sr1.c9 = 0 END IF
          LET l_diff=0
          LET l_diff=(sr1.c9-sr1.c4)/sr1.c4*100
          IF l_diff>tm.x OR l_diff < (tm.x * -1) THEN
            #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
             LET l_type = 4
             SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr1.pn
             LET l_item_type=cl_gr_getmsg('axc-136',g_lang,l_type) #FUN-D30060
             LET l_azi03=5   #FUN-D30060
             LET l_azi04=2   #FUN-D30060
             EXECUTE insert_prep USING l_type,sr1.pn,sr1.c4,sr1.c9,l_diff,l_ima02,l_ima021,sr1.ccc08    #No.FUN-7C0101 add ccc08
                                      ,l_item_type,l_azi03,l_azi04  #FUN-D30060
            #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
          END IF
       END IF
       IF sr1.c5 IS NOT NULL THEN 
          IF sr1.c10 IS NULL THEN LET sr1.c10 = 0 END IF
          LET l_diff=0
          LET l_diff=(sr1.c10-sr1.c5)/sr1.c5*100
          IF l_diff>tm.x OR l_diff < (tm.x * -1) THEN
            #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
             LET l_type = 5
             SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr1.pn
             LET l_item_type=cl_gr_getmsg('axc-136',g_lang,l_type) #FUN-D30060
             LET l_azi03=5   #FUN-D30060
             LET l_azi04=2   #FUN-D30060
             EXECUTE insert_prep USING l_type,sr1.pn,sr1.c5,sr1.c10,l_diff,l_ima02,l_ima021,sr1.ccc08   #No.FUN-7C0101 add ccc08
                                      ,l_item_type,l_azi03,l_azi04  #FUN-D30060
            #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
          END IF
       END IF
     END FOREACH
 
    #NO.MOD-720042 07/02/07 By TSD.Sideny --start--
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ccc01')
             RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
###XtraGrid###     LET g_str = g_str,";",tm.yy1 USING '####',";",tm.mm1 USING '##'   #FUN-710080 modify
###XtraGrid###                      ,";",tm.yy2 USING '####',";",tm.mm2 USING '##'   #FUN-710080 modify 
###XtraGrid###                      ,";",tm.x,";",tm.type
#FUN-840016-start-
     IF tm.type MATCHES '[12]' THEN                                                                                    
###XtraGrid###        CALL cl_prt_cs3('axcx300','axcx300',l_sql,g_str)
        LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"ccc08","N") #FUN-D30060                                                                  
     #No.FUN-7C0101--start--                                                                                                        
     END IF                                                                                                                         
     IF tm.type MATCHES '[345]' THEN                                                                                                
###XtraGrid###        CALL cl_prt_cs3('axcx300','axcx300_1',l_sql,g_str)                   
        LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"ccc08","Y") #FUN-D30060                                                       
     END IF
#FUN-840016-end-
#     CALL cl_prt_cs3('axcx300','axcx300',l_sql,g_str)   #FUN-710080 modify
    #NO.MOD-720042 07/02/07 By TSD.Sideny ---end---
   LET g_xgrid.table = l_table    ###XtraGrid###
   #FUN-D30060--add--str--
   LET g_xgrid.order_field="pn"
   LET g_xgrid.footerinfo1=cl_gr_getmsg('axc-137',g_lang,1),':',tm.yy1 USING '####','-',tm.mm1 USING '##','|',
                           cl_gr_getmsg('axc-137',g_lang,2),':',tm.yy2 USING '####','-',tm.mm2 USING '##'
   LET g_xgrid.condition=cl_getmsg('lib-160',g_lang),g_str
   #FUN-D30060--add--end
   CALL cl_xg_view()    ###XtraGrid###
END FUNCTION
 
{
REPORT axcx300_rep(sr)
   DEFINE u_p  LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6)
          amt  LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw  LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          l_ima02    LIKE ima_file.ima02,    #FUN-4C0099
          l_ima021   LIKE ima_file.ima021,   #FUN-4C0099
          sr         RECORD type LIKE type_file.num5,           #No.FUN-680122SMALLINT
                            pn   LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
                            n1   LIKE ccc_file.ccc23a,
                            n2   LIKE ccc_file.ccc23a,
                            diff LIKE rmf_file.rmf35         #No.FUN-680122DEC(6,2)
                     END RECORD,
          l_chr      LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  ORDER EXTERNAL BY sr.type,sr.pn
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      LET l_chr=g_x[9] CLIPPED,tm.yy1 USING '&&&&',
                           g_x[11] CLIPPED,tm.mm1 USING '&&','  ',
                g_x[10] CLIPPED,tm.yy2 USING '&&&&',
                           g_x[11] CLIPPED,tm.mm2 USING '&&'
      LET l_chr = l_chr CLIPPED 
      PRINT COLUMN (g_len-FGL_WIDTH(l_chr))/2,l_chr CLIPPED
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.type
      CASE
         WHEN sr.type=1 LET g_msg = g_x[12]
         WHEN sr.type=2 LET g_msg = g_x[13]
         WHEN sr.type=3 LET g_msg = g_x[14]
         WHEN sr.type=4 LET g_msg = g_x[15]
         WHEN sr.type=5 LET g_msg = g_x[16]
         OTHERWISE LET g_msg = ' '
      END CASE
      PRINT COLUMN g_c[31],g_msg CLIPPED
 
   ON EVERY ROW
      SELECT ima02,ima021
        INTO l_ima02,l_ima021
        FROM ima_file
       WHERE ima01=sr.pn
      IF SQLCA.sqlcode THEN
         LET l_ima02 = NULL
         LET l_ima021 = NULL
      END IF
 
      PRINT COLUMN g_c[31],sr.pn,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],cl_numfor(sr.n1,34,5),
            COLUMN g_c[35],cl_numfor(sr.n2,35,5),
            COLUMN g_c[36],cl_numfor(sr.diff,36,2),'%'
 
  #start FUN-5C0002
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
  #end FUN-5C0002
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
     #start FUN-5C0002
     #   PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         SKIP 2 LINE
     #end FUN-5C0002
      END IF
END REPORT
}


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
