# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aimr333.4gl
# Descriptions...: 庫存雜項異動明細表
# Input parameter:
# Return code....:
# Date & Author..: 95/05/10 By Riner
# Modify.........: No.FUN-4A0056 04/10/06 By Echo 異動單號,部門邊號要開窗
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.MOD-530519 05/03/28 By Mandy 報表合計小數位數列印異常
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
#
# Modify.........: No.FUN-560069 05/06/14 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-580005 05/08/01 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.MOD-5B0090 05/11/30 By Sarah 原因欄位列印結果為空白,應是取單身的inb15 & azf03
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: No.FUN-660079 06/06/19 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-780012 07/08/17 By zhoufeng 報表打印改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930034 10/02/04 By chenls 加上inaconf條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580005 --end--
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      STRING,                 # TQC-630166
           s       LIKE type_file.chr3,    # Order by sequence #No.FUN-690026 VARCHAR(4)
           t       LIKE type_file.chr3,    # Eject sw        #No.FUN-690026 VARCHAR(3)
           u       LIKE type_file.chr3,    # Group total sw  #No.FUN-690026 VARCHAR(3)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_sma115    LIKE sma_file.sma115    #No.FUN-580005
DEFINE g_sql       STRING                  #No.FUN-780012
DEFINE g_str       STRING                  #No.FUN-780012
DEFINE l_table     STRING                  #No.FUN-780012
DEFINE g_inaconf   LIKE ina_file.inaconf   #No.FUN-930034
 
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
 
   #No.FUN-780012 --start--
   LET g_sql="ina00.ina_file.ina00,ina04.ina_file.ina04,gem02.gem_file.gem02,",
             "chr1000.type_file.chr1000,ina02.ina_file.ina02,",
             "ina01.ina_file.ina01,ina07.ina_file.ina07,inb03.inb_file.inb03,",
             "inb04.inb_file.inb04,inb07.inb_file.inb07,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,inb05.inb_file.inb05,",
             "inb06.inb_file.inb06,inb08.inb_file.inb08,inb09.inb_file.inb09,",
             "chr1000_1.type_file.chr1000,inb11.inb_file.inb11,",
#             "inb12.inb_file.inb12,ima131.ima_file.ima131"                               #No.FUN-930034 ---mark
             "inb12.inb_file.inb12,ima131.ima_file.ima131,inaconf.ina_file.inaconf"       #No.FUN-930034 ---add
   LET l_table = cl_prt_temptable('aimr333',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
#               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                         #No.FUN-930034 ---mark
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                       #No.FUN-930034 ---add
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780012 --end--
   
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr333_tm(0,0)        # Input print condition
      ELSE CALL aimr333()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr333_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 15
   END IF
 
   OPEN WINDOW aimr333_w AT p_row,p_col
        WITH FORM "aim/42f/aimr333"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '2'
   LET tm.u    = 'Y'
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
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ina00,ina01,ina02,ina04,ima131
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION locale
            #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
       #### No.FUN-4A0056
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ina01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ina2"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina01
                NEXT FIELD ina01
 
              WHEN INFIELD(ina04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina04
                NEXT FIELD ina04
           END CASE
      ### END  No.FUN-4A0056
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr333_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF


#UI
#No.FUN-930034 ----add begin
#   INPUT BY NAME
#                 #UI
#                 g_inaconf,tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
#      tm.more WITHOUT DEFAULTS
   INPUT g_inaconf,tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,tm.more
     FROM FORMONLY.inaconf,FORMONLY.s1,FORMONLY.s2,FORMONLY.s3,FORMONLY.t1,FORMONLY.t2,FORMONLY.t3,
          FORMONLY.u1,FORMONLY.u2,FORMONLY.u3,FORMONLY.more ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
#No.FUN-930034 ----add end
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
#      ON ACTION CONTROLP CALL aimr333_wc()   # Input detail Where Condition
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr333_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr333'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr333','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr333',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr333_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr333()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr333_w
END FUNCTION
 
FUNCTION aimr333()
   DEFINE l_name     LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
         #l_sql      LIKE type_file.chr1000, #RDSQL STATEMENT   #MOD-5B0090 mark  #No.FUN-690026 VARCHAR(1000)
          l_sql      STRING,                 #RDSQL STATEMENT   #MOD-5B0090
          l_chr      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05     LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE ina_file.ina01,   #No.FUN-690026 VARCHAR(10)
          sr         RECORD order1 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                            order2 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                            order3 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                            order4 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                            ina00  LIKE ina_file.ina00, #
                            ina01  LIKE ina_file.ina01, #
                            ina02  LIKE ina_file.ina02,
                            ina04  LIKE ina_file.ina04,
                            ina05  LIKE ina_file.ina05,
                            ina07  LIKE ina_file.ina07,
                            inb03  LIKE inb_file.inb03, #單身項次
                            inb04  LIKE inb_file.inb04,
                            inb05  LIKE inb_file.inb05,
                            inb06  LIKE inb_file.inb06,
                            inb07  LIKE inb_file.inb07,
                            inb08  LIKE inb_file.inb08,
                            inb09  LIKE inb_file.inb09,
                            inb11  LIKE inb_file.inb11,
                            inb12  LIKE inb_file.inb12,
#No.FUN-560069 --start--
                            inb902  LIKE inb_file.inb902,
                            inb903  LIKE inb_file.inb903,
                            inb904  LIKE inb_file.inb904,
                            inb905  LIKE inb_file.inb905,
                            inb906  LIKE inb_file.inb906,
                            inb907  LIKE inb_file.inb907,
#No.FUN-560069 ---end--
			   #ima131  VARCHAR(10),              #FUN-660078 remark
			    ima131  LIKE ima_file.ima131,  #FUN-660078	
                            inb15   LIKE inb_file.inb15    #異動原因 #MOD-5B0090
                            ,inaconf LIKE ina_file.inaconf  #No.FUN-930034 
                     END RECORD
   DEFINE l_cnt      LIKE type_file.num5                  #No.FUN-580005  #No.FUN-690026 SMALLINT
   DEFINE l_i        LIKE type_file.num5                  #No.FUN-580005  #No.FUN-690026 SMALLINT
   DEFINE l_zaa02    LIKE zaa_file.zaa02                  #No.FUN-580005
   #No.FUN-780012 --start--
   DEFINE l_ima02    LIKE ima_file.ima02 
   DEFINE l_ima021   LIKE ima_file.ima021
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_str2     LIKE type_file.chr1000,       
          l_inb904   STRING,                       
          l_inb907   STRING                        
   DEFINE l_ima906   LIKE ima_file.ima906          
   DEFINE l_azf03    LIKE azf_file.azf03           
   DEFINE l_inb15    LIKE type_file.chr1000 
   #No.FUN-780012 --end--
 
     CALL cl_del_data(l_table)                             #No.FUN-780012   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#No.FUN-930034 ---add begin
     IF NOT cl_null(g_inaconf) THEN
        CASE g_inaconf
           WHEN '1'
              LET tm.wc = tm.wc CLIPPED," AND inaconf = 'N'"
           WHEN '2'
              LET tm.wc = tm.wc CLIPPED," AND inaconf = 'Y' AND inapost = 'N'"
           WHEN '3'
              LET tm.wc = tm.wc CLIPPED," AND inapost = 'Y'"
           WHEN '4'
              LET tm.wc = tm.wc CLIPPED," AND inaconf = 'X'"
           WHEN '5'
              LET tm.wc = tm.wc CLIPPED
        END CASE
     END IF
#No.FUN-930034 ---add end

     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND inauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND inagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND inagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','','',",
                 "       ina00,ina01,ina02,ina04,ina05,ina07, ",
		 "	 inb03,inb04,inb05,inb06,inb07,inb08,inb09,",
		 "	 inb11,inb12,inb902,inb903,inb904,inb905,inb906,inb907, ima131",#No.FUN-560069
                 "      ,inb15",   #MOD-5B0090
                 "      ,inaconf", #No.FUN-930034 ---add
                 "  FROM ina_file,inb_file, OUTER ima_file",
                 " WHERE ina01 = inb01 ",
                 "   AND inb_file.inb04 = ima_file.ima01 ",
                #"   AND inapost != 'X' ", #mandy #FUN-660079
#                 "   AND inaconf != 'X' ", #FUN-660079               #No.FUN-930034 ---mark
                 "   AND ",tm.wc
     PREPARE aimr333_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE aimr333_curs1 CURSOR FOR aimr333_prepare1
 
#    CALL cl_outnam('aimr333') RETURNING l_name         #No.FUN-780012
   #FUN-580005 --start--
   SELECT sma115 INTO g_sma115 FROM sma_file
   #No.FUN-780012 --mark--
#   IF g_sma115 = "N" THEN
#      LET g_zaa[48].zaa06 = "Y"
#   ELSE
#      LET g_zaa[48].zaa06 = "N"
#   END IF
#   CALL cl_prt_pos_len()
   #No.FUN-780012 --end--
   #No.FUN-580005 --end--
 
#     START REPORT aimr333_rep TO l_name                 #No.FUN-780012
 
     FOREACH aimr333_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.FUN-780012 --mark--
#       FOR g_i = 1 TO 3  #No.FUN-690026
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ina00
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ina01
#               WHEN tm.s[g_i,g_i] = '3'
#                     LET l_order[g_i] = sr.ina02 USING 'yyyymmdd'
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ina04
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima131
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       LET sr.order4 = l_order[4]
#       OUTPUT TO REPORT aimr333_rep(sr.*)
       #No.FUN-780012 --end--
       #No.FUN-780012 --start--
       SELECT ima02,ima021 INTO l_ima02,l_ima021
              FROM ima_file
       WHERE ima01 = sr.inb04
       IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
       END IF
       SELECT gem02 INTO l_gem02
              FROM gem_file
       WHERE gem01 = sr.ina04
       IF SQLCA.sqlcode THEN
          LET l_gem02  = NULL
       END IF
 
       SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.inb15 AND azf02='2'
       IF SQLCA.sqlcode THEN LET l_azf03='' END IF
       LET l_inb15 = sr.inb15 CLIPPED,' ',l_azf03 CLIPPED
 
       SELECT ima906 INTO l_ima906 FROM ima_file
              WHERE ima01 = sr.inb04
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
               LET l_str2 = l_inb907, sr.inb905 CLIPPED
               IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
                  CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                  LET l_str2 = l_inb904, sr.inb902 CLIPPED
               ELSE
                  IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
                     CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                     LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.inb907) OR sr.inb907 > 0 THEN
                  CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
                  LET l_str2 = l_inb907, sr.inb905 CLIPPED
                END IF
          END CASE
       END IF
 
       EXECUTE insert_prep USING sr.ina00,sr.ina04,l_gem02,l_inb15,sr.ina02,
                                 sr.ina01,sr.ina07,sr.inb03,sr.inb04,sr.inb07,
                                 l_ima02,l_ima021,sr.inb05,sr.inb06,sr.inb08,
#                                 sr.inb09,l_str2,sr.inb11,sr.inb12,sr.ima131                  #No.FUN-930034 ---mark
                                 sr.inb09,l_str2,sr.inb11,sr.inb12,sr.ima131,sr.inaconf        #No.FUN-930034 ---add
       #No.FUN-780012 --end--
     END FOREACH
 
#     FINISH REPORT aimr333_rep                     #No.FUN-780012
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-780012
     #No.FUN-780012 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
#        CALL cl_wcchp(tm.wc,'ina00,ina01,ina02,ina04,ima131')                     #No.FUN-930034 ---mark
        CALL cl_wcchp(tm.wc,'ina00,ina01,ina02,ina04,ima131,inaconf')              #No.FUN-930034 ---add
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",g_sma115,";",tm.s[1,1],";",tm.s[2,2],";",
                 tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aimr333','aimr333',l_sql,g_str)
     #No.FUN-780012 --end--
END FUNCTION
#No.FUN-780012 --start-- mark
{REPORT aimr333_rep(sr)
   DEFINE l_ima02      LIKE ima_file.ima02     #FUN-510017
   DEFINE l_ima021     LIKE ima_file.ima021    #FUN-510017
   DEFINE l_gem02      LIKE gem_file.gem02     #FUN-510017
   DEFINE tt	       LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(6)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr           RECORD order1 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                              order2 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                              order3 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                              order4 LIKE ina_file.ina01, #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
                              ina00  LIKE ina_file.ina00, #
                              ina01  LIKE ina_file.ina01, #
                              ina02  LIKE ina_file.ina02,
                              ina04  LIKE ina_file.ina04,
                              ina05  LIKE ina_file.ina05,
                              ina07  LIKE ina_file.ina07,
                              inb03  LIKE inb_file.inb03, #單身項次
                              inb04  LIKE inb_file.inb04,
                              inb05  LIKE inb_file.inb05,
                              inb06  LIKE inb_file.inb06,
                              inb07  LIKE inb_file.inb07,
                              inb08  LIKE inb_file.inb08,
                              inb09  LIKE inb_file.inb09,
                              inb11  LIKE inb_file.inb11,
                              inb12  LIKE inb_file.inb12,
#No.FUN-560069 --start--
                              inb902 LIKE inb_file.inb902,
                              inb903 LIKE inb_file.inb903,
                              inb904 LIKE inb_file.inb904,
                              inb905 LIKE inb_file.inb905,
                              inb906 LIKE inb_file.inb906,
                              inb907 LIKE inb_file.inb907,
#No.FUN-560069 ---end--
		              #ima131 VARCHAR(10),              #FUN-660078 remark
		              ima131 LIKE ima_file.ima131,   #FUN-660078
                              inb15  LIKE inb_file.inb15     #異動原因 #MOD-5B0090
                       END RECORD,
         #l_qty        LIKE type_file.num10,             #MOD-530519  #No.FUN-690026 INTEGER
          l_qty        LIKE inb_file.inb09,              #MOD-530519
          l_chr        LIKE type_file.chr1,              #No.FUN-690026 VARCHAR(1)
          l_inb0407    LIKE type_file.chr1000            #No.FUN-690026 VARCHAR(50)
   DEFINE l_str2       LIKE type_file.chr1000,           #No.FUN-580005  #No.FUN-690026 VARCHAR(100)
          l_inb904     STRING,                           #No.FUN-580005
          l_inb907     STRING                            #No.FUN-580005
   DEFINE l_ima906     LIKE ima_file.ima906              #FUN-580005
   DEFINE l_azf03      LIKE azf_file.azf03               #MOD-5B0090
   DEFINE l_inb15      STRING                            #MOD-5B0090
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.ina01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash[1,g_len]      #No.FUN-580005
#No.FUN-580005 --start--
#No.FUN-560069 --start--
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],
            g_x[48],g_x[49],g_x[50]
#No.FUN-560069 ---end--
      PRINT g_dash1
      LET l_last_sw = 'n'
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file
       WHERE ima01 = sr.inb04
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
      SELECT gem02 INTO l_gem02
        FROM gem_file
       WHERE gem01 = sr.ina04
      IF SQLCA.sqlcode THEN
          LET l_gem02  = NULL
      END IF
 
      #start MOD-5B0090
      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.inb15 AND azf02='2'
      IF SQLCA.sqlcode THEN LET l_azf03='' END IF
      LET l_inb15 = sr.inb15 CLIPPED,' ',l_azf03 CLIPPED
      #end MOD-5B0090
 
      CASE WHEN sr.ina00='1' OR sr.ina00='2' LET tt=g_x[27]
           WHEN sr.ina00='3' OR sr.ina00='4' LET tt=g_x[28]
           WHEN sr.ina00='5' OR sr.ina00='6' LET tt=g_x[29]
           OTHERWISE         LET tt=' '
      END CASE
      LET l_inb0407 = sr.inb04 CLIPPED,' ',sr.inb07 CLIPPED
      SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.inb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
               LET l_str2 = l_inb907, sr.inb905 CLIPPED
               IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
                  CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                  LET l_str2 = l_inb904, sr.inb902 CLIPPED
               ELSE
                  IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
                     CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                     LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.inb907) OR sr.inb907 > 0 THEN
                  CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
                  LET l_str2 = l_inb907, sr.inb905 CLIPPED
                END IF
         END CASE
      END IF
#No.FUN-560069 --start--
      PRINT COLUMN g_c[31],sr.ina00,
            COLUMN g_c[32],sr.ina04,
            COLUMN g_c[33],l_gem02,
            COLUMN g_c[34],tt,
           #COLUMN g_c[35],sr.ina05,  #MOD-5B0090 mark
            COLUMN g_c[35],l_inb15,   #MOD-5B0090
            COLUMN g_c[36],sr.ina02,
            COLUMN g_c[37],sr.ina01,
            COLUMN g_c[38],sr.ina07,
            COLUMN g_c[39],sr.inb03 USING '###&',
            COLUMN g_c[40],sr.inb04 CLIPPED,          #FUN-5B0014 [1,20] CLIPPED,
            COLUMN g_c[41],sr.inb07,
            COLUMN g_c[42],l_ima02,
            COLUMN g_c[43],l_ima021,
            COLUMN g_c[44],sr.inb05,
            COLUMN g_c[45],sr.inb06,
            COLUMN g_c[46],sr.inb08,
            COLUMN g_c[47],cl_numfor(sr.inb09,47,3),
            COLUMN g_c[48],l_str2,
            COLUMN g_c[49],sr.inb11,
            COLUMN g_c[50],sr.inb12
#No.FUN-560069 ---end--
#No.FUN-580005 --end--
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_qty = GROUP SUM(sr.inb09)
         PRINT
         PRINT COLUMN g_c[45],g_x[21] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_qty,47,3)
         PRINT g_dash2[1,g_len]   #No.FUN-580005
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_qty = GROUP SUM(sr.inb09)
         PRINT
         PRINT COLUMN g_c[45],g_x[20] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_qty,47,3)
         PRINT g_dash2[1,g_len]   #No.FUN-580005
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_qty = GROUP SUM(sr.inb09)
         PRINT
         PRINT COLUMN g_c[45],g_x[19] CLIPPED,
               COLUMN g_c[47],cl_numfor(l_qty,47,3)
         PRINT g_dash2[1,g_len]   #No.FUN-580005
      END IF
 
   ON LAST ROW
      LET l_qty = SUM(sr.inb09)
      PRINT COLUMN g_c[45],g_x[22] CLIPPED,
            COLUMN g_c[47],cl_numfor(l_qty,47,3)
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'ina01,ina02,ina03,ina04,ina23,ina15')
              RETURNING tm.wc
         PRINT g_dash[1,g_len] CLIPPED
       #TQC-630166
       #       IF tm.wc[001,070] > ' ' THEN            # for 80
       #  PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
       #       IF tm.wc[071,140] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
       #       IF tm.wc[141,210] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
       #       IF tm.wc[211,280] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]   #No.FUN-580005 #No.TQC-5C0005
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN (g_len-10), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]   #No.FUN-580005 #No.TQC-5C0005
         PRINT g_x[4] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-780012 --end--
