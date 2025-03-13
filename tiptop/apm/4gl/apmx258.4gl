# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: apmx258.4gl
# Desc/riptions..: 採購價格差異分析表
# Date & Author..: 00/08/10 By Mandy
# Modify.........: No.FUN-550060  05/05/30 By yoyo 單據編號格式放大
# Modify.........: No.FUN-570243  05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-580013  05/08/12 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-590005  05/09/02 By kevin 採購數量欄寬加長
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
#                                                   將品名移至料號下
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表名稱和製表日期的行位置應對調
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-610092 06/05/23 By Joe 增加採購單位顯示
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: NO.TQC-6C0139 06/12/25 By Mandy 採購金額/差異金額有誤
# Modify.........: No.FUN-720010 07/02/07 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.MOD-840621 08/04/23 By Carol 修正x258_cs2 end foreach 的位置
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-8C0014 09/01/04 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程
# Modify.........: No.MOD-940403 09/05/05 by Dido 料件供應商幣別改用採購幣別
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-9C0025 09/12/22 By jan 畫面新增type欄位
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:MOD-A50199 10/05/30 By Smapmin 與料件供應商/核價單價比較時,要用原幣
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 平行制程
# Modify.........: No.TQC-B30073 11/03/07 By lilingyu 料件編號開窗後,選擇全部資料,然後確定,程序報錯:找到一個未成對的引號 
# Modify.........: No:MOD-B40124 11/04/18 By Summer 若是分量計價,取分量計價裡的單價
# Modify.........: No:TQC-B80024 11/08/03 By lixia SQL錯誤修改
# Modify.........: No.FUN-CB0002 12/11/07 By lujh CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By wangrr XtraGrid報表畫面檔上小計條件去除，4gl中并去除grup_sum_field
# Modify.........: No:FUN-D40128 13/05/07 By wangrr 增加ctrl+g功

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
                 wc  	STRING,		#TQC-630166  # Where condition
                 pmm04a LIKE type_file.dat,     #採購日期範圍-起始    #No.FUN-680136 DATE
                 pmm04b LIKE type_file.dat,     #採購日期範圍-終止    #No.FUN-680136 DATE
                 s      LIKE type_file.chr3,    #各種排列順序的項目組合  #No.FUN-680136 VARCHAR(3) chr4  
                 t    	LIKE type_file.chr3,    #判斷同項目資料列印完則 "跳頁"   #No.FUN-680136 VARCHAR(3) chr4  
                #u    	LIKE type_file.chr3,    #判斷同項目資料列印完則 "合計"   #No.FUN-680136 VARCHAR(3) chr4  #FUN-D30070 mark 
                 a      LIKE type_file.chr1,    #是否列印有差異者     #No.FUN-680136 VARCHAR(1)
                 b      LIKE type_file.chr1,    #採購價格與何價格比較(1/2/3/4/5) #No.FUN-680136 VARCHAR(1)
                 yy     LIKE type_file.num5,    #實際成本基準期別:年  #No.FUN-680136 SMALLINT
                 mm     LIKE type_file.num5,    #實際成本基準期別:月  #No.FUN-680136 SMALLINT
                 type   LIKE type_file.chr1,    #CHI-9C0025
                 more	LIKE type_file.chr1     #Input more condition(Y/N)  #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total1       LIKE pmn_file.pmn44,   #No.FUN-680136 DECIMAL(20,6)        
          g_total2       LIKE pmn_file.pmn44    #No.FUN-680136 DECIMAL(20,6)
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE l_table        STRING,                 ### FUN-720010 ###
       g_str          STRING,                 ### FUN-720010 ###
       g_sql          STRING                  ### FUN-720010 ###
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
## ***  與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
    LET g_sql = " pmm09.pmm_file.pmm09,",  # 廠商
                " pmc03.pmc_file.pmc03,",  # 廠商簡稱
                " pmn04.pmn_file.pmn04,",  # 料件編號
                " ima02.ima_file.ima02,",  # 品名
                " ima021.ima_file.ima021,",# 規格      #FUN-CB0002 add 
                " pmm01.pmm_file.pmm01,",  # 採購單號
                " pmm04.pmm_file.pmm04,",  # 採購日期
                " pmn87.pmn_file.pmn87,",  # 採購數量
                " pmn44.pmn_file.pmn44,",  # 本幣採購單價
                " pmn44a.pmn_file.pmn44,", # 比較單價
                " pmn44b.pmn_file.pmn44,", # 差異單價
                " pmn44c.pmn_file.pmn44,", # 差異金額
                " pmn44d.pmn_file.pmn44,", # 採購金額
                " pmn07.pmn_file.pmn07,",  # 採購單位(pmn_file) ##NO.FUN-610092
                " pmn86.pmn_file.pmn86, ", # 計價單位   
                " pmm22.pmm_file.pmm22 "   # 採購幣別     #MOD-940403 
 
    LET l_table = cl_prt_temptable('apmx258',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
                "        ?, ?, ?, ? ,?,   ? )"                  #MOD-940403  #FUN-CB0002  add ?
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
    LET tm.pmm04a  = ARG_VAL(8)
    LET tm.pmm04b  = ARG_VAL(9)
    LET tm.s  = ARG_VAL(10)
    LET tm.t  = ARG_VAL(11)
   #LET tm.u  = ARG_VAL(12) #FUN-D30070 mark
    LET tm.a  = ARG_VAL(12) #FUN-D30070 mod 13->12
    LET tm.b  = ARG_VAL(13) #FUN-D30070 mod 14->13
    LET tm.yy = ARG_VAL(14) #FUN-D30070 mod 15->14
    LET tm.mm = ARG_VAL(15) #FUN-D30070 mod 16->15
    LET tm.type = ARG_VAL(16)  #CHI-9C0025 #FUN-D30070 mod 17->16
   LET g_rep_user = ARG_VAL(17) #FUN-D30070 mod 18->17
   LET g_rep_clas = ARG_VAL(18) #FUN-D30070 mod 19->18
   LET g_template = ARG_VAL(19) #FUN-D30070 mod 20->19
   
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
        CALL x258_tm(0,0)		        # Input print condition
    ELSE
        CALL apmx258()		# Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION x258_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
           l_cmd	LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(1000)
           l_a          LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
           l_n          LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    LET p_row = 2 LET p_col = 16
 
    OPEN WINDOW x258_w AT p_row,p_col WITH FORM "apm/42f/apmx258"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #CHI-9C0025
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.pmm04a = g_today
    LET tm.pmm04b = g_today
    LET tm.s      = '123'
    LET tm.t      = ' '
   #LET tm.u      = ' ' #FUN-D30070 mark
    LET tm.a      = 'Y'
    LET tm.b      = '1'
    LET tm.more = 'N'
    LET g_pdate = g_today
    LET g_rlang = g_lang
    LET g_bgjob = 'N'
    LET g_copies = '1'
    LET tm.type = g_ccz.ccz28  #CHI-9C0025
    LET tm2.s1   = tm.s[1,1]
    LET tm2.s2   = tm.s[2,2]
    LET tm2.t1   = tm.t[1,1]
    LET tm2.t2   = tm.t[2,2]
   #LET tm2.u1   = tm.u[1,1] #FUN-D30070 mark
   #LET tm2.u2   = tm.u[2,2] #FUN-D30070 mark
    IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
    IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
    IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
    IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF #FUN-D30070 mark
   #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF #FUN-D30070 mark
 
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON pmm09,pmn04
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            #FUN-CB0002--add--str--
            IF INFIELD (pmm09) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm09
               NEXT FIELD pmm09 
            END IF 
            #FUN-CB0002--add--end--
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
   
   ON ACTION controlg  #FUN-D40128
      CALL cl_cmdask() #FUN-D40128

           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW x258_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
    END IF
    IF tm.wc = " 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
   #DISPLAY BY NAME tm.pmm04a,tm.pmm04b,tm.s,tm.t,tm.u,tm.a,tm.b, #FUN-D30070 mark
    DISPLAY BY NAME tm.pmm04a,tm.pmm04b,tm.s,tm.t,tm.a,tm.b, #FUN-D30070 
        tm.yy,tm.mm,tm.more,tm.type # Condition #CHI-9C0025
#UI
    INPUT BY NAME tm.pmm04a,tm.pmm04b,
                  tm2.s1,tm2.s2,
                  tm2.t1,tm2.t2,
                 #tm2.u1,tm2.u2, #FUN-D30070 mark
                  tm.a,tm.b,
                  tm.yy,tm.mm,tm.type,tm.more WITHOUT DEFAULTS #CHI-9C0025
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
    AFTER FIELD pmm04a
        IF cl_null(tm.pmm04a) THEN
            NEXT FIELD pmm04a
        END IF
    AFTER FIELD pmm04b
        IF cl_null(tm.pmm04b) OR tm.pmm04b < tm.pmm04a THEN
            NEXT FIELD pmm04b
        END IF
    AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
        END IF
    AFTER FIELD b
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[12345]' THEN
            NEXT FIELD b
        END IF
    AFTER FIELD yy
        IF cl_null(tm.yy) OR tm.yy < 0 THEN
             NEXT FIELD yy
        END IF
    AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.mm
             WHERE azm01 = tm.yy        #TQC-B80024
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
 
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
        #LET tm.u = tm2.u1,tm2.u2 #FUN-D30070 mark
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW x258_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
            WHERE zz01='apmx258'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apmx258','9031',1)
        ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.pmm04a CLIPPED,"'",
                         " '",tm.pmm04b CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                        #" '",tm.u CLIPPED,"'", #FUN-D30070 mark
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #CHI-9C0025
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('apmx258',g_time,l_cmd)      # Execute cmd at later time
        END IF
        CLOSE WINDOW x258_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL apmx258()
    ERROR ""
END WHILE
    CLOSE WINDOW x258_w
END FUNCTION
 
FUNCTION apmx258()
    DEFINE l_pmj09      LIKE pmj_file.pmj09  # 新核日
    DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
           l_str        STRING,
           l_time	LIKE type_file.chr8,  	      # Used time for running the job   #No.FUN-680136 VARCHAR(8)
#          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)   #TQC-B30073 
           l_sql 	STRING,                                                                                        #TQC-B30073 
           l_chr	LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
           l_za05	LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
           l_ima021 LIKE ima_file.ima021,         #FUN-CB0002 add 
           l_order	ARRAY[2] OF  LIKE pmn_file.pmn04,             #No.FUN-680136 VARCHAR(40)
           sr               RECORD order1   LIKE pmn_file.pmn04,      #No.FUN-680136 VARCHAR(40)
                                   order2   LIKE pmn_file.pmn04,      #No.FUN-680136 VARCHAR(40)
                                   pmm09    LIKE pmm_file.pmm09, # 廠商
                                   pmc03    LIKE pmc_file.pmc03, # 廠商簡稱
                                   pmn04    LIKE pmn_file.pmn04, # 料件編號
                                   ima02    LIKE ima_file.ima02, # 品名
                                   pmm01    LIKE pmm_file.pmm01, # 採購單號
                                   pmm04    LIKE pmm_file.pmm04, # 採購日期
                                   pmn87    LIKE pmn_file.pmn87, # 採購數量
                                   pmn44    LIKE pmn_file.pmn44, # 本幣採購單價
                                   pmn44a   LIKE pmn_file.pmn44, # 比較單價
                                   pmn44b   LIKE pmn_file.pmn44, # 差異單價
                                   pmn44c   LIKE pmn_file.pmn44, # 差異金額
                                   pmn44d   LIKE pmn_file.pmn44, # 採購金額
                                   pmn07    LIKE pmn_file.pmn07, # 採購單位(pmn_file) ##NO.FUN-610092
                                   pmn86    LIKE pmn_file.pmn86, # 計價單位   
                                   pmm22    LIKE pmm_file.pmm22  # 採購幣別     #MOD-940403 
                            END RECORD
    DEFINE  l_pmm02   LIKE pmm_file.pmm02,   #No.CHI-8C0017
            l_pmn18   LIKE pmn_file.pmn18,   #No.CHI-8C0017  
            l_pmn41   LIKE pmn_file.pmn41,   #No.CHI-8C0017
            l_pmn43   LIKE pmn_file.pmn43,   #No.CHI-8C0017
            l_pmh21   LIKE pmh_file.pmh21,   #No.CHI-8C0017
            l_pmh22   LIKE pmh_file.pmh22,   #No.CHI-8C0017
            l_pmj10   LIKE pmj_file.pmj10,   #No.CHI-8C0014
            l_pmj12   LIKE pmj_file.pmj12    #No.CHI-8C0014                            
    DEFINE  l_pmn52   LIKE pmn_file.pmn52    #CHI-9C0025
    DEFINE  l_pmn54   LIKE pmn_file.pmn54    #CHI-9C0025
    DEFINE  l_pmn56   LIKE pmn_file.pmn56    #CHI-9C0025
    DEFINE  l_tlfcost LIKE tlf_file.tlfcost  #CHI-9C0025
    DEFINE  l_pmn012  LIKE pmn_file.pmn012   #FUN-A60027
    DEFINE  l_pmi01   LIKE pmi_file.pmi01    #MOD-B40124 add
    DEFINE  l_pmi05   LIKE pmi_file.pmi05    #MOD-B40124 add
    DEFINE  l_pmj02   LIKE pmj_file.pmj02    #MOD-B40124 add
    DEFINE  l_msg     STRING    #FUN-CB0002 add
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
    LET l_sql = " SELECT '','', ",
                "   pmm09,pmc03,pmn04,ima02,'','',0,0,0,0,0,0,'','' ",     #FUN-CB0002  add ima021                       ##NO.FUN-610092 #CHI-8C0017 Add pmm02,pmn18,pmn41,pmn43 #MOD-940403 move to cs2
                " FROM pmm_file,pmn_file, ",
                "     OUTER pmc_file, OUTER ima_file ",  
                " WHERE pmm01=pmn01 AND pmm_file.pmm09 = pmc_file.pmc01 AND pmn_file.pmn04 = ima_file.ima01 ",
                "     AND pmn16 NOT IN ('X','0','1','9') ",
                "     AND pmm04 BETWEEN '",tm.pmm04a,"' AND '",tm.pmm04b,"'",
                "     AND ",tm.wc
    LET l_sql = l_sql CLIPPED," GROUP BY pmm09,pmc03,pmn04,ima02  "                              #CHI-8C0017 Add pmm02,pmn18,pmn41,pmn43                #MOD-940403 move to cs2
    PREPARE x258_prepare1 FROM l_sql
    IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
    END IF
    DECLARE x258_cs1 CURSOR FOR x258_prepare1
    IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
    END IF
    #-----MOD-A50199---------
    IF tm.b = '1' OR tm.b = '2' THEN 
       LET l_sql =
                  "SELECT pmm01,pmm04,pmn87,pmn31,pmn07,pmn86,pmm22,pmm02,pmn18,pmn41,pmn43,",
                  "       pmn52,pmn54,pmn56,pmn012,imd09 ",       #FUN-A60027 add pmn012
                  "  FROM pmm_file,pmn_file ",  
                  "  LEFT OUTER JOIN imd_file ON pmn52=imd01",
                  " WHERE pmm01=pmn01 AND pmn16 NOT IN ('X','0','1','9') ",
                  "   AND pmm09=? AND pmn04=? ",
                  "   AND pmm04 BETWEEN '",tm.pmm04a,"' AND '",tm.pmm04b,"'",
                  " ORDER BY pmm04 DESC "
    ELSE
    #-----END MOD-A50199-----
       LET l_sql =
                  "SELECT pmm01,pmm04,pmn87,pmn44,pmn07,pmn86,pmm22,pmm02,pmn18,pmn41,pmn43,",
                  "       pmn52,pmn54,pmn56,pmn012,imd09 ",  #CHI-9C0025 add      #FUN-A60027 add pmn012
                  "  FROM pmm_file,pmn_file ",  #MOD-940403 add
                  "  LEFT OUTER JOIN imd_file ON pmn52=imd01", #CHI-9C0025
                  " WHERE pmm01=pmn01 AND pmn16 NOT IN ('X','0','1','9') ",
                  "   AND pmm09=? AND pmn04=? ",
                  "   AND pmm04 BETWEEN '",tm.pmm04a,"' AND '",tm.pmm04b,"'",
                  " ORDER BY pmm04 DESC "
    END IF   #MOD-A50199
    PREPARE x258_prepare2 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
          
    END IF
    DECLARE x258_cs2 CURSOR FOR x258_prepare2
 
    LET g_pageno = 0
    FOREACH x258_cs1 INTO sr.*                                             #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #MOD-940403 move to cs2
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        FOR g_i = 1 TO 2
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmm09
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmn04
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
        END FOR
        LET sr.order1 = l_order[1]
        LET sr.order2 = l_order[2]
        IF cl_null(sr.pmn44d) THEN LET sr.pmn44d = 0 END IF
        SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima02 = sr.ima02
        FOREACH x258_cs2  USING sr.pmm09,sr.pmn04
            INTO sr.pmm01,sr.pmm04,sr.pmn87,sr.pmn44,sr.pmn07,sr.pmn86,sr.pmm22,l_pmm02,l_pmn18,l_pmn41,l_pmn43,  #MOD-940403 add
                 l_pmn52,l_pmn54,l_pmn56,l_pmn012,l_tlfcost  #CHI-9C0025 add      #FUN-A60027 add l_pmn012
            IF cl_null(sr.pmn44) THEN LET sr.pmn44 = 0 END IF
        CASE tm.b
            WHEN '1'
                 IF l_pmm02='SUB' THEN
                    LET l_pmh22='2'
                    IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
                       LET l_pmh21 =' '
                    ELSE
                      IF NOT cl_null(l_pmn18) THEN
                       SELECT sgm04 INTO l_pmh21 FROM sgm_file
                        WHERE sgm01=l_pmn18
                          AND sgm02=l_pmn41
                          AND sgm03=l_pmn43
                          AND sgm012 = l_pmn012   #FUN-A60076 
                      ELSE
                       SELECT ecm04 INTO l_pmh21 FROM ecm_file 
                        WHERE ecm01=l_pmn41
                          AND ecm03=l_pmn43
                          AND ecm012 = l_pmn012     #FUN-A60027 
                      END IF
                    END IF         #NO.TQC-910033  
                 ELSE
                    LET l_pmh22='1'
                    LET l_pmh21=' '
                 END IF
                 SELECT pmh12 INTO sr.pmn44a FROM pmh_file
                     WHERE pmh01 = sr.pmn04 AND pmh02 = sr.pmm09 AND
                           pmh13 = sr.pmm22    #採購幣別  #MOD-940403 add
                       AND pmh21 = l_pmh21                                                       #CHI-8C0017
                       AND pmh22 = l_pmh22                                                       #CHI-8C0017
                       AND pmh23 = ' '                    #No.CHI-960033
                       AND pmhacti = 'Y'                                           #CHI-910021                       
            WHEN '2'
                 IF l_pmm02='SUB' THEN
                    LET l_pmj12='2'
                    IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
                       LET l_pmj10 =' '
                    ELSE
                      IF NOT cl_null(l_pmn18) THEN
                       SELECT sgm04 INTO l_pmj10 FROM sgm_file
                        WHERE sgm01=l_pmn18
                          AND sgm02=l_pmn41
                          AND sgm03=l_pmn43
                          AND sgm012 = l_pmn012   #FUN-A60076
                      ELSE
                       SELECT ecm04 INTO l_pmj10 FROM ecm_file 
                        WHERE ecm01=l_pmn41
                          AND ecm03=l_pmn43
                          AND ecm012 = l_pmn012   #FUN-A60027
                      END IF
                    END IF      #No.TQC-910033
                 ELSE
                    LET l_pmj12='1'
                    LET l_pmj10=' '
                 END IF
                 DECLARE pmj_cur CURSOR FOR
                    #SELECT pmj07,pmj09 FROM pmj_file,pmi_file   #核價檔                   #MOD-B40124 mark 
                     SELECT pmj07,pmj09,pmi01,pmi05,pmj02 FROM pmj_file,pmi_file   #核價檔 #MOD-B40124 
                         WHERE pmi01   = pmj01     #核價單號
                           AND pmi03   = sr.pmm09  #p_vender  #廠商編號
                           AND pmj03   = sr.pmn04  #p_part    #料件編號
                           AND pmj05   = sr.pmm22             #採購幣別   #MOD-940403 add
                           AND pmj09  <= sr.pmm04  #p_date    #單據日期
                           AND pmj10 = l_pmj10                                                       #CHI-8C0014
                           AND pmj12 = l_pmj12                                                       #CHI-8C0014                           
                           AND pmiconf ='Y'
                           AND pmiacti ='Y'
                     ORDER BY pmj09 DESC
                 OPEN pmj_cur
                #FETCH pmj_cur INTO sr.pmn44a,l_pmj09                         #MOD-B40124 mark 
                 FETCH pmj_cur INTO sr.pmn44a,l_pmj09,l_pmi01,l_pmi05,l_pmj02 #MOD-B40124 
                 CLOSE pmj_cur
                 #MOD-B40124 add --start--
                 IF l_pmi05 = 'Y' THEN #分量計價
                    SELECT pmr05 INTO sr.pmn44a
                      FROM pmr_file
                     WHERE pmr01 = l_pmi01
                       AND pmr02 = l_pmj02
                       AND pmr03 <= sr.pmn87
                       AND pmr04 >= sr.pmn87
                    IF cl_null(sr.pmn44a) THEN LET sr.pmn44a = 0 END IF
                 END IF
                 #MOD-B40124 add --end--
            WHEN '3'
                 #最近採購單價 (本幣)
                 SELECT ima53 INTO sr.pmn44a FROM ima_file
                     WHERE ima01 = sr.pmn04
            WHEN '4'
                 #市價 (本幣)
                 SELECT ima531 INTO sr.pmn44a FROM ima_file
                     WHERE ima01 = sr.pmn04
            WHEN '5'
                  CASE tm.type
                   WHEN '1'  LET l_tlfcost = ' '
                   WHEN '2'  LET l_tlfcost = ' '
                   WHEN '3'  LET l_tlfcost = l_pmn56
                   WHEN '4'  LET l_tlfcost = ' '
                   WHEN '5'  LET l_tlfcost = l_tlfcost
                  END CASE
                 SELECT ccc23 INTO sr.pmn44a FROM ccc_file
                     WHERE ccc01 = sr.pmn04 AND
                           ccc02 = tm.yy    AND
                           ccc03 = tm.mm
                       AND ccc07 = tm.type AND ccc08 = l_tlfcost #CHI-9C0025
        END CASE
        LET sr.pmn44b = sr.pmn44  - sr.pmn44a
        LET sr.pmn44c = sr.pmn44b * sr.pmn87
        LET sr.pmn44d = sr.pmn44  * sr.pmn87
        
        IF (tm.a = 'Y' AND  (cl_null(sr.pmn44b) OR sr.pmn44b = 0)) THEN
            LET sr.pmn44d = 0
        END IF
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
        IF tm.a = 'N' OR (tm.a='Y' AND
           (NOT cl_null(sr.pmn44b) AND sr.pmn44b <> 0)) THEN
           EXECUTE insert_prep USING 
                   sr.pmm09,sr.pmc03,sr.pmn04,sr.ima02,l_ima021,sr.pmm01,  #FUN-CB0002  add l_ima021
                   sr.pmm04,sr.pmn87,sr.pmn44,sr.pmn44a,sr.pmn44b,
                   sr.pmn44c,sr.pmn44d,sr.pmn07,sr.pmn86,sr.pmm22   #MOD-940403 
        END IF 
        #------------------------------ CR (3) ------------------------------#
        END FOREACH
    END FOREACH
 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
###XtraGrid###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    #是否列印選擇條件
    #FUN-CB0002--mark--str--
    #IF g_zz05 = 'Y' THEN
    #   CALL cl_wcchp(tm.wc,'pmm09,pmn04') 
    #        RETURNING tm.wc
    #   LET g_str = tm.wc
    #END IF
    #FUN-CB0002--mark--end--
###XtraGrid###    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u,";",tm.b
###XtraGrid###                     ,";",g_azi03,";",g_azi04,";",g_azi05   #FUN-710080 add
###XtraGrid###    CALL cl_prt_cs3('apmx258','apmx258',l_sql,g_str)        #FUN-710080 modify
    LET g_xgrid.table = l_table    ###XtraGrid###
    IF tm.b = '1' THEN 
       LET l_msg = cl_getmsg("apm-374",g_lang)
    END IF 
    IF tm.b = '2' THEN 
       LET l_msg = cl_getmsg("apm-375",g_lang)
    END IF 
    IF tm.b = '3' THEN 
       LET l_msg = cl_getmsg("apm-376",g_lang)
    END IF 
    IF tm.b = '4' THEN 
       LET l_msg = cl_getmsg("apm-377",g_lang)
    END IF 
    IF tm.b = '5' THEN 
       LET l_msg = cl_getmsg("apm-378",g_lang)
    END IF 
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn44a',l_msg,'')
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pmm09,pmn04') 
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"pmm09,pmn04")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"pmm09,pmn04")  #FUN-D30070
   #LET g_xgrid.grup_field = cl_get_sum_field(tm.s,tm.u,"pmm09,pmn04") #FUN-D30070 mark
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"pmm09,pmn04") #FUN-D30070 mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"pmm09,pmn04")
   #LET l_str = cl_wcchp(g_xgrid.order_field,"pmm09,pmn04") #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',','-')
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    CALL cl_xg_view()    ###XtraGrid###
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
