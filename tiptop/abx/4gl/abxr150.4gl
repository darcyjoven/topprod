# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr150.4gl
# Descriptions...: FCST應完稅報表
# Date & Author..: 96/08/26 By STAR 
# Modify.........: No.FUN-530012 05/03/15 By kim 報表轉XML功能
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-740077 07/04/23 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換) 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
             #wc      VARCHAR(1000),   # Where condition  #TQC-610081
              yea     LIKE type_file.num5,          #No.FUN-680062 smallint
              mo      LIKE type_file.num5,          #No.FUN-680062 smallint
              more    LIKE type_file.chr1           #No.FUN-680062 VARCHAR(1)
              END RECORD,
          xr               RECORD bnh03     LIKE bnh_file.bnh03, #Group Code
                                  bnh04     LIKE bnh_file.bnh04  #數量
                        END RECORD,
          g_vdate       LIKE type_file.dat,       #No.FUN-680062 date
          g_mount       LIKE type_file.num10      #No.FUN-680062 integer
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE l_table        STRING                    #FUN-740077 add
DEFINE g_sql          STRING                    #FUN-740077 add
DEFINE g_str          STRING                    #FUN-740077 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
   #str FUN-740077 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "mea01.mea_file.mea01,",
               "bne05.bne_file.bne05,",
               "bne05s.bne_file.bne05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "bne08.bne_file.bne08,",
               "forecast.bnf_file.bnf12,",
               "bnf12.bnf_file.bnf12,",
               "total.bnf_file.bnf12"
 
   LET l_table = cl_prt_temptable('abxr150',g_sql) CLIPPED          # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                         # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,            # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-740077 add
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #LET tm.wc = ARG_VAL(7)    #TQC-610081
   LET tm.yea = ARG_VAL(7)
   LET tm.mo    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   DROP TABLE b1_temp
#FUN-680062-BEGIN
#   CREATE TEMP TABLE b1_temp(
#          mea01     SMALLINT,
#          bne05     VARCHAR(20),           {料件編號        }
#          bne05s    VARCHAR(20),           {料件編號[排序]  }
#          ima02     VARCHAR(30),
#          bne08     decimal(16,8),      #FUN-560231
#          forecast  decimal(18,3),      {FORECAST應完稅數量}
#          bnf12     decimal(18,3),      {本期結存非保稅數}
#          total     decimal(18,3)       {下月應完稅數量}
#                             );
   CREATE TEMP TABLE b1_temp(
          mea01     LIKE mea_file.mea01,
          bne05     LIKE bne_file.bne05,
          bne05s    LIKE bne_file.bne05,
          ima02     LIKE ima_file.ima02,
          bne08     LIKE bne_file.bne08,
          forecast  LIKE bnf_file.bnf12, 
          bnf12     LIKE bnf_file.bnf12,
          total     LIKE bnf_file.bnf12);
#FUN-680062-END
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr150_tm(4,15)        # Input print condition
      ELSE CALL abxr150()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr150_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd        LIKE type_file.chr1000       #No.FUN-680062  VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 8 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW abxr150_w AT p_row,p_col
        WITH FORM "abx/42f/abxr150" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea = YEAR(g_today)
   LET tm.mo  = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.wc = '1=1'  #TQC-610081
WHILE TRUE
   INPUT BY NAME tm.yea,tm.mo,tm.more 
   WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
 
      AFTER FIELD yea
           IF cl_null(tm.yea) THEN NEXT FIELD yea END IF 
 
      AFTER FIELD mo
           IF cl_null(tm.mo) OR tm.mo >12 OR tm.mo < 1 THEN 
              NEXT FIELD mo 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr150','9031',1)
      ELSE
        #LET tm.wc=cl_replace_str(tm.wc, "'", "\"")  #TQC-610081
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                        #" '",tm.wc CLIPPED,"'",     #TQC-610081
                         " '",tm.yea     CLIPPED,"'",
                         " '",tm.mo      CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
                        
         CALL cl_cmdat('abxr150',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr150()
   DELETE FROM b1_temp
   ERROR ""
END WHILE
   CLOSE WINDOW abxr150_w
END FUNCTION
 
FUNCTION abxr150()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name              #No.FUN-680062 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680062  VARCHAR(1000)
          l_chr     LIKE type_file.chr1,           #No.FUN-680062  VARCHAR(1)
          l_za05    LIKE za_file.za05,             #No.FUN-680062  VARCHAR(40)
          l_year    LIKE type_file.num5,           #No.FUN-680062  smallint
          l_month   LIKE type_file.num5,           #No.FUN-680062  smallint
          l_bnd01   LIKE bnd_file.bnd01,  #---主件料號---
          l_mea01   LIKE mea_file.mea01,  #---生效日期---
          l_bne05   LIKE bne_file.bne05,
          sr               RECORD 
          mea01     LIKE mea_file.mea01,                                #No.FUN-680062   smallint
          bne05     LIKE bne_file.bne05,           {料件編號        }   #No.FUN-680062 VARCHAR(20)
          bne05s    LIKE bne_file.bne05,           {料件編號[排序]  }   #No.FUN-680062 VARCHAR(20)
          ima02     LIKE ima_file.ima02,
          bne08     LIKE bne_file.bne08,#FUN-560231
          forecast  LIKE bnf_file.bnf12,      {FORECAST應完稅數量}   #No.FUN-680062  decimal(18,3)
          bnf12     LIKE bnf_file.bnf12,      {本期結存非保稅數}     #No.FUN-680062  decimal(18,3)                                                                   
          total     LIKE bnf_file.bnf12       {下月應完稅數量}       #No.FUN-680062  decimal(18,3)
                        END RECORD
   DEFINE l_ima021  LIKE ima_file.ima021    #No.FUN-740077 add
 
     #str FUN-740077 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abxr140'
 
     DECLARE mea_curs CURSOR FOR SELECT mea01,mea02,' ',ima02,0,0,bnf12,0
        FROM mea_file,ima_file,bnf_file
        WHERE mea02=ima01 AND ima15='Y' AND bnf01=ima01 AND
        bnf03=tm.yea AND bnf04=tm.mo
     FOREACH mea_curs INTO sr.*
        INSERT INTO b1_temp VALUES (sr.*)
     END FOREACH
     #---下期的年月--
     LET l_month = tm.mo + 1
     LET l_year = tm.yea
     IF l_month > 12 THEN LET l_month = 1 LET l_year = l_year + 1 END IF  
 
     LET l_sql = "SELECT bnh03,SUM(bnh04) ",
                 "  FROM bnh_file ",
     {           " WHERE YEAR(bnh02) = ",l_year,
                 "   AND MONTH(bnh02) = ",l_month,}
                 "  WHERE bnh01 = '1' ",
                 "  GROUP BY bnh03 " 
 
     PREPARE abxr150_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr150_curs1 CURSOR FOR abxr150_prepare1
 
      CALL cl_outnam('abxr150') RETURNING l_name
 
     LET l_bnd01 = ' '
     LET g_vdate = g_today
     FOREACH abxr150_curs1 INTO xr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
 
       CALL r150_bom(1,xr.bnh03,1)
     END FOREACH
 
     LET g_pageno = 0
     DECLARE abxr150_curs4 CURSOR FOR
      SELECT * FROM b1_temp
      
     LET l_mea01 = ' '
     FOREACH abxr150_curs4 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       IF l_mea01 != sr.mea01 THEN
          LET l_bne05 = sr.bne05
       END IF 
       LET sr.bne05s = l_bne05
       IF sr.forecast<>0 OR sr.bnf12<>0 THEN
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         SELECT ima021 INTO l_ima021 FROM ima_file 
             WHERE ima01=sr.bne05
         EXECUTE insert_prep USING
            sr.mea01,sr.bne05,sr.bne05s,sr.ima02,l_ima021,sr.bne08,
            sr.forecast,sr.bnf12,sr.total
         #------------------------------ CR (3) ------------------------------#
         #end FUN-740077 add
       END IF
       LET l_mea01 = sr.mea01 
     END FOREACH
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
         LET g_str = " ",";",tm.yea,";",tm.mo 
     END IF
     CALL cl_prt_cs3('abxr150','abxr150',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
 
FUNCTION r150_bom(p_level,p_key,p_total)     
   DEFINE p_level	LIKE type_file.num5,  #No.FUN-680062   smallint
          p_key		LIKE bma_file.bma01,  #主件料件編號
          p_total       LIKE bmb_file.bmb06,  #FUN-560231
          l_ac,i	LIKE type_file.num5,          #No.FUN-680062  smallint
          arrno		LIKE type_file.num5,  	#BUFFER SIZE (可存筆數)  #No.FUN-680062  smallint
          l_chr		LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)   
          l_ima08       LIKE ima_file.ima08,
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bma01 LIKE bma_file.bma01,
              level LIKE type_file.num5,                                #No.FUN-680062   smallint
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb25 LIKE bmb_file.bmb25    #倉庫別  
   #          bma01 VARCHAR(20)                                
          END RECORD,
          sr2     RECORD 
                  mea01     LIKE mea_file.mea01,                      #No.FUN-680062  smallint
                  bne05     LIKE bne_file.bne05,           {料件編號        }  #No.FUN-680062   VARCHAR(20) 
                  bne05s    LIKE bne_file.bne05,           {料件編號[排序]  }  #No.FUN-680062   VARCHAR(20) 
                  ima02     LIKE ima_file.ima02,                               #No.FUN-680062  VARCHAR(30)
                  bne08     LIKE bne_file.bne08, #FUN-560231
                  forecast  LIKE bnf_file.bnf12,      {FORECAST應完稅數量}   #No.FUN-680062   decimal(18,3)
                  bnf12     LIKE bnf_file.bnf12,      {本期結存非保稅數}     #No.FUN-680062   decimal(18,3)
                  total     LIKE bnf_file.bnf12       {下月應完稅數量}       #No.FUN-680062   decimal(18,3)
                  END RECORD,
          l_cmd	  LIKE type_file.chr1000       #No.FUN-680062  VARCHAR(1000)
 
	IF p_level > 10 THEN 
		CALL cl_err('','mfg2733',1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
   EXIT PROGRAM
   
	END IF
    LET p_level = p_level + 1
    LET arrno = 600			#95/12/21 Modify By Lynn
    LET l_cmd= "SELECT bma01,0, bne03, bne05, bne08, ' ',' ' ",
               "  FROM bnd_file,bne_file,OUTER bma_file",
               " WHERE bnd01=bne01 AND bnd02=bne02 AND bne09='Y' AND ",
               " bne_file.bne05 = bma_file.bma01 AND bnd01='", p_key,"' " 
    #---->生效日及失效日的判斷
    IF g_vdate IS NOT NULL THEN
        LET l_cmd=l_cmd CLIPPED,
                  " AND (bnd02 <='",g_vdate,"' OR bnd02 IS NULL)",
                  " AND (bnd03 > '",g_vdate,"' OR bnd03 IS NULL)"
    END IF
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bne03'
    PREPARE r150_cur1_pre FROM l_cmd
    DECLARE r150_cur1 CURSOR FOR r150_cur1_pre
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
       EXIT PROGRAM 
    END IF
    LET l_ac = 1
    FOREACH r150_cur1 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr[i].level = p_level
        LET sr[i].bmb06=p_total*sr[i].bmb06
  
        LET sr2.bne05 = sr[i].bmb03
        LET sr2.forecast = xr.bnh04 * sr[i].bmb06 * 6 
 
                         UPDATE b1_temp SET forecast=forecast+sr2.forecast
                            WHERE bne05=sr2.bne05
 # modify by Elaine 06/19/97
        IF sr[i].bmb03 IS NULL THEN CONTINUE FOR END IF
        IF sr[i].bma01 IS NOT NULL THEN
           CALL r150_bom(p_level,sr[i].bmb03,sr[i].bmb06)
        END IF
    END FOR
END FUNCTION
 
