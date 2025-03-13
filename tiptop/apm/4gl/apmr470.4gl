# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmr470.4gl
# Descriptions...: 工單需求請購表
# Input parameter:
# Return code....:
# Date & Author..: 94/09/12 By Apple
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.FUN-550060 05/05/30 By yoyo單據編號格式放大
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-5A0121 05/10/14 By ice 料號/品名/規格欄位放大
# Modify.........: No.MOD-640356 06/04/10 By Echo 條件選項為1時程式會出現錯誤訊息。
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-7C0034 07/12/25 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.TQC-960245 09/06/22 By lilingyu EXECUTE insert_prep,在計算本次需求,備料數量,獨立性數量,請購數量,采購數量,采購檢驗量是,都沒有插入請購單號和項次，與老報表不符
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:TQC-D20030 13/02/20 By xuxz 添加請購單號開窗，報表顯示替代說明

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			    	# Print condition RECORD
       	    #wc     	LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500)  # Where condition#TQC-D20030 mark
                wc      STRING,#TQC-D20030 add
                choice  LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   	        more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
              END RECORD,
          l_name2       LIKE type_file.chr20,   #No.FUN-680136 VARCHAR(20)
          g_lot         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          g_pnl   RECORD LIKE pnl_file.*
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
DEFINE   l_table         STRING,                ### FUN-7C0034 ###                                                                    
         g_str           STRING,                ### FUN-7C0034 ###                                                                    
         g_sql           STRING                 ### FUN-7C0034 ###
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
### *** FUN-7C0034 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "chr1.type_file.chr1,",
                "pmk01.pmk_file.pmk01,",
                "pml02.pml_file.pml02,",
                "pml04.pml_file.pml04,",
                "pml08.pml_file.pml08,",
#                "ima262.ima_file.ima262,", #FUN-A20044
                "avl_stk.type_file.num15_3,", #FUN-A20044
                "ima27.ima_file.ima27,",
                "pml20.pml_file.pml20,",
                "pml35.pml_file.pml35,",
                "lstat.type_file.chr1,",
                "ldate.pml_file.pml35,",
                "lno.pml_file.pml01,",
                "lseq.pml_file.pml02,",
                "lqty.pml_file.pml20,",
                "ltype.type_file.chr1,",
                "lscode.type_file.chr1,",
                "pnl11.pnl_file.pnl11,",
                "pnl10.pnl_file.pnl10,",
                "pnl09.pnl_file.pnl09,",
                "pnl08.pnl_file.pnl08,",
                "pnl07.pnl_file.pnl07,",
                "pnl06.pnl_file.pnl06,",
                "pnl05.pnl_file.pnl05,",
                "pnl04.pnl_file.pnl04,",
                "pnl03.pnl_file.pnl03,",
                "pnl02.pnl_file.pnl02,",
                "pml041.pml_file.pml041,",
                "l_cnt.type_file.num5"
    LET l_table = cl_prt_temptable('apmr470',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                           
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.choice = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r470_tm(0,0)	    	# Input print condition
      ELSE CALL apmr470()		        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r470_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 11
 
   OPEN WINDOW r470_w AT p_row,p_col WITH FORM "apm/42f/apmr470"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.choice = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.choice,tm.more
   CONSTRUCT BY NAME tm.wc ON pmk01,pmk04,pml04
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP
          #TQC-D20030--add-s-tr
          #添加請購單號開窗
           IF INFIELD(pmk01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmk02"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk01
              NEXT FIELD pmk01
           END IF 
          #TQC-D20030--add-e-nd
            IF INFIELD(pml04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml04
               NEXT FIELD pml04
            END IF
#No.FUN-570243 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r470_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.choice,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD choice
         IF tm.choice NOT MATCHES "[123]" OR tm.choice IS NULL
            THEN NEXT FIELD choice
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
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
      LET INT_FLAG = 0 CLOSE WINDOW r470_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr470'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr470','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr470',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r470_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr470()
   ERROR ""
END WHILE
   CLOSE WINDOW r470_w
END FUNCTION
 
FUNCTION r470_cur(p_pmk01)
  DEFINE p_pmk01  LIKE pmk_file.pmk01,
         l_woedate LIKE type_file.dat,        #No.FUN-680136 DATE
        #l_sql    LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(1000)#TQC-D20030 mark
         l_sql    STRING #TQC-D20030 add
    LET g_lot = 'Y'
	LET g_pnl.pnl02 = g_pnl.pnl02 CLIPPED
    #-->無使用整批請購
	IF g_pnl.pnl02 IS NULL OR g_pnl.pnl02 = ' ' THEN
		LET g_pnl.pnl02 = '1=1'
        LET g_lot = 'N'
    ELSE LET l_sql = "SELECT max(sfb13) ",
                     "  FROM sfb_file,ima_file ",
                     " WHERE sfb05=ima01 AND sfb87!='X' ",
                     "  AND ",g_pnl.pnl02 CLIPPED
         PREPARE p470_predate  FROM l_sql
         DECLARE p470_curdate CURSOR FOR p470_predate
         FOREACH p470_curdate INTO l_woedate
           IF SQLCA.sqlcode THEN
              CALL cl_err('r470_curdate',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
         END FOREACH
         IF cl_null(l_woedate) THEN LET l_woedate = g_pnl.pnl04 + 1 END IF
	END IF
#-----------------------需求資料------------------------------------------
    #--->讀取本次需求
     LET l_sql = "SELECT sfb01,' ',sfb13,(sfa05-sfa06-sfa065),sfa26 ",
                 "  FROM sfa_file,sfb_file,ima_file",
                 " WHERE sfa01 = sfb01 ",
                 "   AND sfa03 = ima01 ",
                 "   AND sfb04 != '8'  ",
                 "   AND sfb02 != '2' AND sfb02 != '11' ",
                 "   AND sfa03 =   ?  AND sfb87!='X'  "
     IF g_lot = 'Y' THEN
        LET l_sql = l_sql CLIPPED, " AND ",g_pnl.pnl02 CLIPPED,
                                   " AND sfb13 <='",l_woedate,"'"
     END IF
     PREPARE r470_prereq  FROM l_sql
     DECLARE r470_cssreq  CURSOR WITH HOLD FOR r470_prereq
 
    #--->讀取備料量(應發量-已發量)(已分配量)(需求)
     LET l_sql = " SELECT sfb01,' ',sfb13,(sfa05-sfa06-sfa065),sfa26 ",
                 " FROM sfa_file,sfb_file ",
                 " WHERE sfa03 = ?  ",
                 "   AND sfa01 = sfb01 ",
                 "   AND sfb02 != '2' AND sfb02 != '11' ",
                 "   AND sfb04 != '8' AND sfb87!='X' "
     IF g_lot = 'Y'
     THEN LET l_sql = l_sql CLIPPED," AND sfb13 <='",l_woedate,"'"
     END IF
     PREPARE r470_presfa  FROM l_sql
     DECLARE r470_cssfa  CURSOR WITH HOLD FOR r470_presfa
 
    #--->讀取獨立性需求量(工單最晚完工日)
     LET l_sql = " SELECT rpc02,rpc03,rpc12,(rpc13-rpc131),'' ", #No:8531
#    LET l_sql = " SELECT rpc02,rpc03,rpc12,(rpc13-rpc131-rpc14),'' ",
                 "   FROM rpc_file ",
                 "  WHERE rpc01 = ? "
     IF g_pnl.pnl04 IS NOT NULL AND g_pnl.pnl04 !=' '
     THEN LET l_sql = l_sql CLIPPED," AND rpc12 <='",g_pnl.pnl04,"'"
     END IF
     PREPARE r470_prerpc  FROM l_sql
     DECLARE r470_csrpc  CURSOR WITH HOLD FOR r470_prerpc
 
#-----------------------供給資料------------------------------------------
    #--->讀取請購量(請購量-已轉採購量)(日期區間)
     LET l_sql = " SELECT pml01,pml02,pml35,(pml20-pml21),pml42 ",
                 "   FROM pml_file,pmk_file ",
                 "  WHERE pmk01=pml01 AND pmk18 != 'X' ",
                 "    AND pml04 = ? ",
                 "    AND (pml011 = 'REG' OR pml011 = 'IPO' ) ",
                 "    AND pml16 < '6' ",
                 "    AND pml01 != '",p_pmk01,"'"
     IF g_pnl.pnl04 IS NOT NULL AND g_pnl.pnl04 !=' '
     THEN LET l_sql = l_sql CLIPPED," AND pml35 <='",g_pnl.pnl04,"'"
     END IF
     PREPARE r470_prepml  FROM l_sql
     DECLARE r470_cspml  CURSOR WITH HOLD FOR r470_prepml
 
    #--->讀取採購量(採購量-已交量)/檢驗量(pmn51)(日期區間)
#    LET l_sql = " SELECT pmn01,pmn02,pmn35,(pmn20-(pmn50-pmn55))/pmn62,pmn42 ",       #No.FUN-9A0068 mark
     LET l_sql = " SELECT pmn01,pmn02,pmn35,(pmn20-(pmn50-pmn55-pmn58))/pmn62,pmn42 ", #No.FUN-9A0068 
                 "   FROM pmn_file,pmm_file ",
                 "  WHERE pmm01=pmn01 AND pmm18 != 'X' ",
                 "    and pmn61 =  ? ",
                 "    AND (pmn011 = 'REG' OR pmn011 = 'IPO' ) ",
                 "    AND pmn16 < '6' ",
#                "    AND (pmn20-pmn50+pmn55) > 0 "       #No.FUN-940083  
                 "    AND (pmn20-pmn50+pmn55+pmn58) > 0 " #No.FUN-940083 
     IF g_pnl.pnl04 IS NOT NULL AND g_pnl.pnl04 !=' '
     THEN LET l_sql = l_sql CLIPPED," AND pmn35 <='",g_pnl.pnl04,"'"
     END IF
     PREPARE r470_prepmn  FROM l_sql
     DECLARE r470_cspmn  CURSOR WITH HOLD FOR r470_prepmn
 
     LET l_sql = " SELECT rvb01,rvb02,'',(rvb31),' '",
                 "   FROM rvb_file,rva_file ",
                 "  WHERE rva01=rvb01 AND rvaconf='Y' ",
                 "    AND rvb05 =  ? "
     PREPARE r470_prervb  FROM l_sql
     DECLARE r470_csrvb  CURSOR WITH HOLD FOR r470_prervb
 
{
    #--->讀取工單量(生產數量-入庫量-報廢量)(日期區間)
     LET l_sql = " SELECT sfb01,'',sfb15,(sfb08-sfb09-sfb12),'' ",
                 "   FROM sfb_file ",
                 "  WHERE sfb05 =  ? ",
                 "    AND sfb02 != '2' AND sfb02 != '11' ",
                 "    AND sfb04 != '8' AND sfb87!='X' "
     IF g_pnl.pnl04 IS NOT NULL AND g_pnl.pnl04 !=' '
     THEN LET l_sql = l_sql CLIPPED," AND sfb15 <='",g_pnl.pnl04,"'" END IF
     PREPARE r470_presfb  FROM l_sql
     DECLARE r470_cssfb  CURSOR WITH HOLD FOR r470_presfb
}
END FUNCTION
 
FUNCTION apmr470()
   DEFINE l_name	 LIKE type_file.chr20, 	       # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time 	 LIKE type_file.chr8,  	       # Used time for running the job  #No.FUN-680136 VARCHAR(8)
         #l_sql 	 LIKE type_file.chr1000,	       # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)#TQC-D20030 mark
          l_sql          STRING,#TQC-D20030 add
          l_chr		 LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05	 LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_cmd 	 LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(30)
          l_cnt          LIKE type_file.num5,          #No.FUN-7C0034
          sr   RECORD
                  pmk01  LIKE pmk_file.pmk01,	# 單號
                  pml02  LIKE pml_file.pml02,	# 項次
                  pml04  LIKE pml_file.pml04,	# 料號
                  pml08  LIKE pml_file.pml08,	# 單位
#                  ima262 LIKE ima_file.ima262,	# 可用量 #FUN-A20044
                  avl_stk LIKE type_file.num15_3,	# 可用量 #FUN-A20044
                  ima27  LIKE ima_file.ima27,	# 安全庫存
                  pml041 LIKE pml_file.pml041,	# 品名規格
                  pml20  LIKE pml_file.pml20,	# 建議量
                  pml35  LIKE pml_file.pml35,	# 入庫日
                  stat   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)  # 狀況
                  date   LIKE pml_file.pml35,   # 日期
                  no     LIKE pml_file.pml01,   # 單號
                  seq    LIKE pml_file.pml02,   # 項次
                  qty    LIKE pml_file.pml20,   # 來源量
                  type   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
                  scode  LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)  # 供/需來源
        END RECORD,
        l_old_pmk01   LIKE pmk_file.pmk01
     DEFINE l_pml04   LIKE pml_file.pml04        #FUN-A20044
     DEFINE avl_stk_mpsmrp,unavl_stk,avl_stk LIKE type_file.num15_3 #FUN-A20044
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #MOD-640356
     #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr470'
     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 150 END IF   #No.MOD-5A0121
     #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #END MOD-640356
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT pmk01, pml02, pml04, pml08,",
#                 " ima262, ima27, pml041, pml20, pml35, '',", #FUN-A20044
                 " 0, ima27, pml041, pml20, pml35, '',", #FUN-A20044
                 " '','','','','','' ",
                 " FROM pmk_file,pml_file, OUTER ima_file",
                 " WHERE pmk01 = pml01 AND pml_file.pml04 = ima_file.ima01" ,
                 " AND ",tm.wc
     PREPARE r470_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r470_cs1 CURSOR FOR r470_prepare1
#No.FUN-7C0034-Mark--Begin--
#    CALL cl_outnam('apmr470') RETURNING l_name
#    IF tm.choice = '3' THEN
#   	LET l_name2=l_name
#    	LET l_name2[11,11]='x'
#    ELSE
#       LET l_name2= l_name
#    END IF
 
#    IF tm.choice matches'[13]' THEN
#       START REPORT r470_rep TO l_name     #彙總
#       LET g_pageno = 0
#    END IF
     #MOD-640356
#    IF tm.choice matches'[23]' THEN
#       LET g_len = 181                                          #No.MOD-5A0121
#       FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR   #No.MOD-5A0121
#    	START REPORT r470_rep2 TO l_name2   #明細
#       LET g_pageno = 0
#    ELSE
#       SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr470'
#       IF g_len = 0 OR g_len IS NULL THEN LET g_len = 150 END IF   #No.MOD-5A0121
#       FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    END IF
#No.FUN-7C0034--Mark--End--
     #END MOD-640356
     LET l_old_pmk01 = ' '
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-7C0034 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-7C0034 add ###                                              
     #------------------------------ CR (2) ------------------------------#
 
     FOREACH r470_cs1 INTO sr.*
     CALL s_getstock(sr.pml04,g_plant) RETURNING avl_stk_mpsmrp,unavl_stk,avl_stk
     LET sr.avl_stk = avl_stk
       IF SQLCA.sqlcode THEN
 		 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.pmk01 != l_old_pmk01 THEN
          SELECT * INTO g_pnl.*  FROM pnl_file WHERE pnl01 = sr.pmk01
          IF SQLCA.sqlcode THEN
             INITIALIZE g_pnl.* TO NULL
          END IF
          CALL r470_cur(sr.pmk01)
       END IF
       LET l_cnt = 0                                               #No.FUN-7C0034
       #--->產生本次需求
        IF g_lot = 'Y' THEN
         FOREACH r470_cssreq  USING sr.pml04
           INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
           IF SQLCA.sqlcode THEN
              CALL cl_err('r470_cssreq',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           LET sr.scode = 'R'
           LET sr.type = 'D'
           #-->彙總
           IF tm.choice matches '[13]' THEN                        #No.FUN-7C0034
#             OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)              #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '1','','','','','','','','',       #TQC-960245                                                                      
                    '1',sr.pmk01,sr.pml02,'','','','','','',       #TQC-960245   
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'D','R',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
           END IF                                                  #No.FUN-7C0034
           #-->明細
           IF tm.choice matches '[23]' THEN                        #No.FUN-7C0034
#             OUTPUT TO REPORT r470_rep2(sr.*)                     #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '2','','','','','','','','',      #TQC-960245
                    '2',sr.pmk01,sr.pml02,'','','','','','',      #TQC-960245                                                                                   
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'D','R',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
           END IF                                                  #No.FUN-7C0034
         END FOREACH
       END IF
       #--->產生備料數量
        FOREACH r470_cssfa  USING sr.pml04
          INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
          IF SQLCA.sqlcode THEN
             CALL cl_err('r470_cssfa',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET sr.scode = '1'  LET sr.type = 'D'
          #-->彙總
          IF tm.choice matches'[13]' THEN                                 #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)                      #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '1','','','','','','','','',    #TQC-960245
                    '1',sr.pmk01,sr.pml02,'','','','','','',    #TQC-960245                                                                                      
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'D','1',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                          #No.FUN-7C0034
          #-->明細
          IF tm.choice matches'[23]' THEN                                 #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep2(sr.*)                             #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '2','','','','','','','','',    #TQC-960245
                    '2',sr.pmk01,sr.pml02,'','','','','','',    #TQC-960245                                                                                     
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'D','1',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                          #No.FUN-7C0034
        END FOREACH
       #--->產生獨立性數量
        FOREACH r470_csrpc USING sr.pml04
          INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
          IF SQLCA.sqlcode THEN
             CALL cl_err('r470_csrpc',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET sr.scode = '1'  LET sr.type = 'D'
          #-->彙總
          IF tm.choice matches'[13]' THEN                            #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)                 #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '1','','','','','','','','',  #TQC-960245
                    '1',sr.pmk01,sr.pml02,'','','','','','',  #TQC-960245                                                                                       
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'D','1',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                     #No.FUN-7C0034
          #-->明細
          IF tm.choice matches'[23]' THEN                            #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep2(sr.*)                        #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '2','','','','','','','','',   #TQC-960245
                    '2',sr.pmk01,sr.pml02,'','','','','','',   #TQC-960245                                                                                       
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'D','1',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                     #No.FUN-7C0034
        END FOREACH
       #--->產生請購數量
        FOREACH r470_cspml  USING sr.pml04
          INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
          IF SQLCA.sqlcode THEN
             CALL cl_err('r470_cspml',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET sr.scode = '2' LET sr.type = 'S'
          #-->彙總
          IF tm.choice matches'[13]' THEN                              #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)                   #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '1','','','','','','','','',    #TQC-960245
                    '1',sr.pmk01,sr.pml02,'','','','','','',    #TQC-960245                                                                                     
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'S','2',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#  
          END IF                                                       #No.FUN-7C0034
          #-->明細
       #  IF tm.choice matches'[23]' THEN CALL r470_rep2(sr.*) END IF
        END FOREACH
       #--->產生採購數量
        FOREACH r470_cspmn  USING sr.pml04
          INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
          IF SQLCA.sqlcode THEN
            CALL cl_err('r470_cspmn',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET sr.scode = '3'   LET sr.type = 'S'
          #-->彙總
          IF tm.choice matches'[13]' THEN                            #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)                 #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '1','','','','','','','','',  #TQC-960245
                    '1',sr.pmk01,sr.pml02,'','','','','','',  #TQC-960245                                                                                        
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'S','3',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                     #No.FUN-7C0034
          #-->明細
          IF tm.choice matches'[23]' THEN                            #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep2(sr.*)                        #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '2','','','','','','','','',  #TQC-960245
                    '2',sr.pmk01,sr.pml02,'','','','','','',  #TQC-960245                                                                                       
                   sr.stat,sr.date,sr.no,sr.seq,sr.qty,'S','3',                                                                     
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                     #No.FUN-7C0034
        END FOREACH
       #--->產生採購檢驗量
        FOREACH r470_csrvb USING sr.pml04
          INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
          IF SQLCA.sqlcode THEN
             CALL cl_err('r470_csrvb',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET sr.date = ' '    #最小日期
          LET sr.scode = '4'   LET sr.type = 'S'
          #-->彙總
         IF tm.choice matches'[13]' THEN                                #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)                     #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
 #                  '1','','','','','','','','',     #TQC-960245                                                                                     
                    '1',sr.pmk01,sr.pml02,'','','','','','',     #TQC-960245 
                   sr.stat,'',sr.no,sr.seq,sr.qty,'S','4',                                                                          
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#   
         END IF                                                         #No.FUN-7C0034
          #-->明細
          IF tm.choice matches'[23]' THEN                                #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep2(sr.*)                            #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '2','','','','','','','','',        #TQC-960245
                    '2',sr.pmk01,sr.pml02,'','','','','','',        #TQC-960245                                                                                 
                   sr.stat,'',sr.no,sr.seq,sr.qty,'S','4',                                                                          
                   '','','','','','','','','','','',''                                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                         #No.FUN-7C0034
        END FOREACH
       #--->產生工單數量
      # FOREACH r470_cssfb USING sr.pml04
      #   INTO sr.no,sr.seq,sr.date,sr.qty,sr.stat
      #   IF SQLCA.sqlcode THEN
      #      CALL cl_err('r470_cssfb',SQLCA.sqlcode,0)
      #      EXIT FOREACH
      #   END IF
      #   LET sr.scode = '5'   LET sr.type = 'S'
          #-->彙總
          IF tm.choice matches'[13]' THEN                                 #No.FUN-7C0034
#            OUTPUT TO REPORT r470_rep(sr.*,g_pnl.*)                      #No.FUN-7C0034
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '1',sr.pmk01,sr.pml02,sr.pml04,sr.pml08,sr.ima262,sr.ima27,sr.pml20,                                                  #FUN-A20044
                   '1',sr.pmk01,sr.pml02,sr.pml04,sr.pml08,sr.avl_stk,sr.ima27,sr.pml20,                                                  #FUN-A20044
                   sr.pml35,'','','','','','','',g_pnl.pnl11,                                                                       
                   g_pnl.pnl10,g_pnl.pnl09,g_pnl.pnl08,g_pnl.pnl07,g_pnl.pnl06,g_pnl.pnl05,                                         
                   g_pnl.pnl04,g_pnl.pnl03,g_pnl.pnl02,sr.pml041,l_cnt                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                          #No.FUN-7C0034
          #-->明細
          IF tm.choice matches'[23]' THEN
#            OUTPUT TO REPORT r470_rep2(sr.*)                             #No.FUN-7C0034
          LET l_cnt = l_cnt + 1                                           #No.FUN-7C0034  
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-7C0034 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
#                   '2',sr.pmk01,sr.pml02,sr.pml04,sr.pml08,sr.ima262,sr.ima27,sr.pml20,                                                  #FUN-A20044
                   '2',sr.pmk01,sr.pml02,sr.pml04,sr.pml08,sr.avl_stk,sr.ima27,sr.pml20,                                                  #FUN-A20044
                   sr.pml35,'','','','','','','',g_pnl.pnl11,                                                                       
                   g_pnl.pnl10,g_pnl.pnl09,g_pnl.pnl08,g_pnl.pnl07,g_pnl.pnl06,g_pnl.pnl05,                                         
                   g_pnl.pnl04,g_pnl.pnl03,g_pnl.pnl02,sr.pml041,l_cnt                                                              
          #------------------------------ CR (3) ------------------------------#
          END IF                                                          
      # END FOREACH
        LET l_old_pmk01 = sr.pmk01
     END FOREACH
#No.FUN-7C0034--Mark-Begin--
#   IF tm.choice matches'[13]' THEN
#      FINISH REPORT r470_rep
#   END IF
#   IF tm.choice matches'[23]' THEN
#      FINISH REPORT r470_rep2
       #No.+366 010705 plum
#       LET l_cmd = "chmod 777 ", l_name2
#       RUN l_cmd
       #No.+366..end
#   END IF
#   IF tm.choice  = '3' THEN
#      LET l_sql='cat ',l_name2,'>> ',l_name
#      RUN l_sql
#   END IF
            LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0034--Mark-End--
 
#No.FUN-7C0034--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'pmk01,pmk04,pml04')                                                               
              RETURNING tm.wc
      END IF
#No.FUN-7C0034--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-7C0034 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_towhom,";",tm.choice                                                         
    CALL cl_prt_cs3('apmr470','apmr470',l_sql,g_str)                                                                                  
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
#No.FUN-7C0034--Mark-Begin--
#REPORT r470_rep(sr,sr2)
#  DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         sr   RECORD
#                 pmk01  LIKE pmk_file.pmk01,	# 單號
#                 pml02  LIKE pml_file.pml02,	# 項次
#                 pml04  LIKE pml_file.pml04,	# 料號
#                 pml08  LIKE pml_file.pml08,	# 單位
#                 ima262 LIKE ima_file.ima262,	# 可用量
#                 ima27  LIKE ima_file.ima27,	# 安全庫存
#                 pml041 LIKE pml_file.pml041,	# 品名規格
#                 pml20  LIKE pml_file.pml20,	# 建議量
#                 pml35  LIKE pml_file.pml35,	# 入庫日
#                 stat   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#                 date   LIKE pml_file.pml35,
#                 no     LIKE pml_file.pml01,   # 單號
#                 seq    LIKE pml_file.pml02,   # 項次
#                 qty    LIKE pml_file.pml20,   # 來源量
#                 type   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#                 scode  LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
#       END RECORD,
#       sr2        RECORD LIKE pnl_file.*,
#       l_wo       LIKE sfb_file.sfb01,
#       l_sfb05    LIKE sfb_file.sfb05,
#       req_qty    LIKE pml_file.pml20,
#       al_qty     LIKE pml_file.pml20,
#       pr_qty     LIKE pml_file.pml20,
#       po_qty     LIKE pml_file.pml20,
#       qc_qty     LIKE pml_file.pml20,
#       wo_qty     LIKE pml_file.pml20,
#       sh_qty     LIKE pml_file.pml20,
#       l_supply   LIKE pml_file.pml20,
#       l_demand   LIKE pml_file.pml20,
#       l_sfb08    LIKE sfb_file.sfb08,
#       l_sfb13    LIKE sfb_file.sfb13,
#       l_sfb15    LIKE sfb_file.sfb15,
#       l_ima02    LIKE ima_file.ima02
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pmk01,sr.pml02
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED ))/2 SPACES,g_company CLIPPED  #MOD-640356
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[11] CLIPPED,sr.pmk01 CLIPPED
#     PRINT g_x[12] CLIPPED,COLUMN 42,g_x[13] CLIPPED,
#           COLUMN 78,g_x[14] CLIPPED,COLUMN 113,g_x[15] CLIPPED
#     PRINT g_x[12] CLIPPED,COLUMN 62,g_x[13] CLIPPED,
#           COLUMN 98,g_x[14] CLIPPED,COLUMN 133,g_x[15] CLIPPED
#     PRINT '---- -------------------- ---- -------- ',
#     PRINT '---- ---------------------------------------- ---- -------- ',     #No.MOD-5A0121
#           '-------- -------- -------- -------- -------- ',
#           '-------- -------- -------- -------- --------'
#     LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.pmk01
#     IF (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#
#   AFTER GROUP OF sr.pml02
#      #-->本次需求
#      LET req_qty = GROUP SUM(sr.qty) WHERE sr.scode = 'R'
#      #-->分配量
#      LET al_qty = GROUP SUM(sr.qty) WHERE sr.scode = '1'
#      #-->請購量
#      LET pr_qty = GROUP SUM(sr.qty) WHERE sr.scode = '2'
#      #-->採購量
#      LET po_qty = GROUP SUM(sr.qty) WHERE sr.scode = '3'
#      #-->在驗量
#      LET qc_qty = GROUP SUM(sr.qty) WHERE sr.scode = '4'
#      #-->在製量
#      LET wo_qty = GROUP SUM(sr.qty) WHERE sr.scode = '5'
#      #-->缺料量
#       #-->不包含現有庫存
#       IF sr2.pnl05 ='N' THEN LET sr.ima262 = 0 END IF
#       #-->不包含檢驗量
#       IF sr2.pnl06 ='N' THEN LET qc_qty = 0    END IF
#       #-->不包含請購量
#       IF sr2.pnl07 ='N' THEN LET pr_qty = 0    END IF
#       #-->不包含採購量
#       IF sr2.pnl08 ='N' THEN LET po_qty = 0    END IF
#       #-->不包含工單量
#       IF sr2.pnl09 ='N' THEN LET wo_qty = 0    END IF
#       #-->不包含已分配量
#       IF sr2.pnl10 ='N' THEN LET al_qty = 0    END IF
#       #-->不包含安全庫存
#       IF sr2.pnl11 ='N' THEN LET sr.ima27 = 0  END IF
#       #-->缺料量 = 本次需求 + 已備料量 - [ 庫存可用 + QC + PO + PR + WO]
#       LET l_supply= sr.ima262 + qc_qty + po_qty + pr_qty + wo_qty
#       LET l_demand= req_qty + al_qty
#       LET sh_qty = l_demand - l_supply
#No.MOD-5A0121 --start--
#      PRINT sr.pml02 USING'###&',' ',sr.pml04,' ',sr.pml08,' ',
#            COLUMN  32,req_qty   USING'########',' ',
#            COLUMN  41,sr.ima262 USING'########',' ',
#            COLUMN  50,sr.ima27  USING'########',' ',
#            COLUMN  59,al_qty    USING'########',' ',
#            COLUMN  68,pr_qty    USING'########',' ',
#            COLUMN  77,po_qty    USING'########',' ',
#            COLUMN  86,qc_qty    USING'########',' ',
#            COLUMN  95,wo_qty    USING'########',' ',
#            COLUMN 104,sh_qty    USING'--------',' ',
#            COLUMN 113,sr.pml20  USING'########',' ',
#            sr.pml35
#      PRINT sr.pml02 USING'###&',
#            COLUMN   6,sr.pml04 CLIPPED,
#            COLUMN  47,sr.pml08 CLIPPED,
#            COLUMN  52,req_qty   USING'########',' ',
#            COLUMN  61,sr.ima262 USING'########',' ',
#            COLUMN  50,sr.ima27  USING'########',' ',
#            COLUMN  79,al_qty    USING'########',' ',
#            COLUMN  88,pr_qty    USING'########',' ',
#            COLUMN  97,po_qty    USING'########',' ',
#            COLUMN  106,qc_qty    USING'########',' ',
#            COLUMN  115,wo_qty    USING'########',' ',
#            COLUMN 124,sh_qty    USING'--------',' ',
#            COLUMN 133,sr.pml20  USING'########',' ',
#            sr.pml35
#No.MOD-5A0121 --end--
 
#   AFTER GROUP OF sr.pmk01
#      PRINT ' '
#      PRINT g_x[16] CLIPPED,sr2.pnl02  CLIPPED
#      PRINT COLUMN 10,g_x[17] CLIPPED,sr2.pnl03,
#            COLUMN 40,g_x[18] CLIPPED,sr2.pnl04
#      PRINT COLUMN 10,g_x[19] CLIPPED,sr2.pnl05,
#            COLUMN 40,g_x[20] CLIPPED,sr2.pnl08
#      PRINT COLUMN 18,g_x[21] CLIPPED,sr2.pnl06,
#            COLUMN 40,g_x[22] CLIPPED,sr2.pnl09
#      PRINT COLUMN 18,g_x[23] CLIPPED,sr2.pnl07,
#            COLUMN 40,g_x[24] CLIPPED,sr2.pnl10
#      PRINT COLUMN 10,g_x[25] CLIPPED,sr2.pnl11
#      PRINT ' '
#      PRINT COLUMN  2,g_x[26] CLIPPED,
#            COLUMN 43,g_x[28] CLIPPED,
#             COLUMN 78,g_x[29] CLIPPED
#No.MOD-5A0121 --start--
#           COLUMN 49,g_x[28] CLIPPED,        #No.FUN-550060
#            COLUMN 84,g_x[29] CLIPPED        #No.FUN-550060
#      PRINT '---------- -------------------- ',
#     PRINT '---------------- -------------------- ',        #No.FUN-550060
#           COLUMN 85,g_x[28] CLIPPED,        #No.FUN-550060
#            COLUMN 122,g_x[29] CLIPPED        #No.FUN-550060
#            '------------------------------ ------------- -------- --------'
#     PRINT '---------------- ---------------------------------------- ',        #No.FUN-550060
#            '------------------------------------------------------------ ------------- -------- --------'
#No.MOD-5A0121 --end--
#
#      FOREACH r470_cs2 USING  sr.pmk01
#         INTO l_wo
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('r470_cs2',SQLCA.sqlcode,0)
#            EXIT FOREACH
#         END IF
#         SELECT sfb05,sfb08,sfb13,sfb15,ima02
#           INTO l_sfb05,l_sfb08,l_sfb13,l_sfb15,l_ima02
#           FROM sfb_file,ima_file
#          WHERE sfb05 = ima01
#            AND sfb01 = l_wo
#         IF SQLCA.sqlcode THEN
#            LET l_sfb05 = ' '   LET l_sfb08 = ' '
#            LET l_sfb13 = ' '   LET l_sfb15 = ' '
#            LET l_ima02 = ' '
#         END IF
#No.MOD-5A0121 --start--
#         PRINT l_wo,' ',l_sfb05,' ',l_ima02,' ',
#               l_sfb08 USING'#############',' ',l_sfb13,' ',l_sfb15
#         PRINT l_wo,' ',l_sfb05,' ',l_ima02,' ',
#               COLUMN 18, l_srb05 CLIPPED,
#               COLUMN 59, l_ima02 CLIPPED,
#               COLUMN 120,l_sfb08 USING '#############',
#               COLUMN 134,l_sfb13 CLIPPED,
#               COLUMN 143,l_sfb15 CLIPPED
#               l_sfb08 USING'#############',' ',l_sfb13,' ',l_sfb15
#No.MOD-5A0121 --end--
#      END FOREACH
#
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT ' '
#     PRINT g_dash[1,g_len]
#     IF g_pageno = 0 OR l_last_sw = 'y'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     END IF
#END REPORT
#-------------------------------------------
#  報表格式(二) 明細表
#-------------------------------------------
 
#REPORT r470_rep2(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         sr   RECORD
#                 pmk01  LIKE pmk_file.pmk01,	# 單號
#                 pml02  LIKE pml_file.pml02,	# 項次
#                 pml04  LIKE pml_file.pml04,	# 料號
#                 pml08  LIKE pml_file.pml08,	# 單位
#                 ima262 LIKE ima_file.ima262,	# 可用量
#                 ima27  LIKE ima_file.ima27,	# 安全庫存
#                 pml041 LIKE pml_file.pml041,	# 品名規格
#                 pml20  LIKE pml_file.pml20,	# 建議量
#                 pml35  LIKE pml_file.pml35,	# 入庫日
#                 stat   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#                 date   LIKE pml_file.pml35,
#                 no     LIKE pml_file.pml01,   # 單號
#                 seq    LIKE pml_file.pml02,   # 項次
#                 qty    LIKE pml_file.pml20,   # 來源量
#                 type   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#                 scode  LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
#       END RECORD,
#       l_rem  LIKE ima_file.ima262,
#       l_cnt  LIKE type_file.num5          #No.FUN-680136 SMALLINT
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pmk01,sr.pml02,sr.date
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[09]))/2 SPACES,g_x[09]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#No.MOD-5A0121 --start--
#     PRINT COLUMN 45,g_x[30] CLIPPED,COLUMN 83,g_x[31] CLIPPED
#     PRINT g_x[32] CLIPPED,COLUMN 42,g_x[36].substring(1,2), #MOD-520129
#           COLUMN  46,g_x[33] CLIPPED,
#           COlUMN  71,g_x[37] CLIPPED,
#            COLUMN  84,g_x[33] CLIPPED,
#           COLUMN  88,g_x[33] CLIPPED,
#           COLUMN  114,g_x[37] CLIPPED,
#            COLUMN 121,g_x[34] CLIPPED
#           COLUMN 130,g_x[34] CLIPPED
#     PRINT COLUMN  12,g_x[35] CLIPPED,
#            COLUMN  42,g_x[36].substring(3,4) #MOD-520129
#     PRINT '---- -------------------- ---- ---------- - ',
#     PRINT COLUMN 85,g_x[30] CLIPPED,COLUMN 128,g_x[31] CLIPPED
#     PRINT g_x[32] CLIPPED,
#           COLUMN 67 ,g_x[38] CLIPPED,
#           COLUMN 82,g_x[36].substring(1,2), #MOD-520129
#No.FUN-550060 --start--
#           COLUMN  86,g_x[33] CLIPPED,
#           COlUMN  111,g_x[37] CLIPPED,
#           COLUMN  84,g_x[33] CLIPPED,
#           COLUMN  128,g_x[33] CLIPPED,
#           COLUMN  154,g_x[37] CLIPPED,
#           COLUMN 121,g_x[34] CLIPPED
#           COLUMN 130,g_x[34] CLIPPED
#           COLUMN 173,g_x[34] CLIPPED
#     PRINT COLUMN  32,g_x[35] CLIPPED,
#           COLUMN  82,g_x[36].substring(3,4) #MOD-520129
#     PRINT '---- ------------------------------------------------------------ ---- ---------- - ',
#No.MOD-5A0121 --end--
#           '-------- ---------- ---- -----------  ',
#           '-------- ---------------- ---- ----------- ',
#            '-------- ---------- ---- ----------- -----------'
#           '-------- ---------------- ---- ----------- -----------'
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.pmk01
#     IF (PAGENO > 1 OR LINENO > 11)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#     PRINT g_x[11] CLIPPED,sr.pmk01
 
#  BEFORE GROUP OF sr.pml02
#     PRINT sr.pml02 USING '###&',
#           COLUMN 06,sr.pml04,
#           COLUMN 27,sr.pml08,
#           COLUMN 32,sr.ima262 USING '----------';
#           COLUMN 67,sr.pml08,                       #No.MOD-5A0121
#           COLUMN 72,sr.ima262 USING '----------';   #No.MOD-5A0121
#     LET l_cnt = 0   LET l_rem = sr.ima262
 
#  ON EVERY ROW
#     LET l_cnt = l_cnt + 1
#     IF l_cnt = '2' THEN PRINT COLUMN 6,sr.pml041; END IF
#     IF sr.type = 'D' THEN
#        LET l_rem = l_rem - sr.qty
#No.MOD-5A0121 --start--
#        PRINT COLUMN 43,sr.stat,
#              COLUMN 45,sr.date,
#              COLUMN 54,sr.no,
#              COLUMN 65,sr.seq USING'###&',
#              COLUMN 71,sr.seq USING'###&',
#              COLUMN 70,sr.qty USING'-----------';
#              COLUMN 76,sr.qty USING'-----------';
#     ELSE
#        LET l_rem = l_rem + sr.qty
#        PRINT COLUMN 43,sr.stat,
#              COLUMN 83,sr.date,
#              COLUMN 88,sr.date,
#              COLUMN 92,sr.no,
#              COLUMN 97,sr.no,
#               COLUMN 103,sr.seq USING'###&',
#              COLUMN 113,sr.seq USING'###&',
#              COLUMN 108,sr.qty USING'-----------';
#              COLUMN 119,sr.qty USING'-----------';
#     END IF
#     PRINT COLUMN 120,l_rem USING'-----------'
#    PRINT COLUMN 130,l_rem USING'-----------'
#        PRINT COLUMN 83,sr.stat,
#              COLUMN 85,sr.date,
#              COLUMN 94,sr.no,
#              COLUMN 111,sr.seq USING'###&',
#              COLUMN 116,sr.qty USING'-----------';
#     ELSE
#        LET l_rem = l_rem + sr.qty
#        PRINT COLUMN 83,sr.stat,
#              COLUMN 128,sr.date,
#              COLUMN 137,sr.no,
#              COLUMN 153,sr.seq USING'###&',
#              COLUMN 159,sr.qty USING'-----------';
#     END IF
#     PRINT COLUMN 170,l_rem USING'-----------'
#No.FUN-550060 --end--
#No.MOD-5A0121 --end--
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT ' '
#     PRINT g_dash[1,g_len]
#     IF g_pageno = 0 OR l_last_sw = 'y'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     END IF
#END REPORT
#No.FUN-7C0034--Mark-End--
#Patch....NO.TQC-610036 <001> #
