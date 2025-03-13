# Prog. Version..: '5.30.07-13.05.30(00005)'     #
#
# Pattern name...: axmx450.4gl
# Descriptions...: 客戶訂單追蹤表
# Date & Author..: 97/10/21 by Lynn
# Modify.........: 01-04-09 BY ANN CHEN No.B318 不含合約訂單
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550070 05/05/26 By ice   單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-570175 05/07/27 By Nicola l_ima021放錯位置
# Modify.........: No.MOD-570213 05/07/14 By Mandy 資料狀態選'2'未交 目前程式的寫法篩選未交的資料不合理
# Modify.........: No.FUN-580004 05/08/09 By wujie 雙單位報表格式修改
# Modify.........: NO.FUN-5B0015 05/11/02 by YITING 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE 
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-750129 07/06/19 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-860253 08/06/24 By Smapmin ogb23->oga23
# Modify.........: No.MOD-8A0262 08/10/30 By Smapmin 恢復MOD-570213的調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70068 10/07/21 By shenyang 加上營運中心代碼  并跨庫處理
# Modify.........: No.MOD-BA0119 12/01/17 By Vampire cl_get_target_table 傳入的第二個參數只能傳table名稱 
# Modify.........: No.TQC-C50101 12/05/11 By zhuhao 字段類型定義修改
# Modify.........: No.TQC-C80016 12/08/02 By zhuhao sql語句錯誤
# Modify.........: No.FUN-CB0002 12/11/12 By lujh CR轉XtraGrid
# Modify.........: No.FUN-D30053 13/03/18 By chenying XtraGrid报表修改
# Modify.........: No.FUN-D30070 13/03/21 By chenying 去除小計
# Modify.........: No.FUN-D40128 13/05/16 By wangrr 增加"幣別"開窗
# Modify.........: No.FUN-D50099 13/05/16 By wangrr 打印條件顯示中文

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
DEFINE tm  RECORD
           wc1     STRING,  
           wc       STRING,
           s       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           t       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
          #u       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)  #FUN-D30070
           a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
           more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)
           END RECORD
DEFINE   g_orderA        ARRAY[3] OF LIKE faj_file.faj02      # No.FUN-680137 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_table          STRING  #No.FUN-750129
DEFINE g_str            STRING  #No.FUN-750129
DEFINE g_sql            STRING  #No.FUN-750129
#FUN-580004--end 
#No.FUN-A70068  ..begin 
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING


#No.FUN-A70068  ..end

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
   #No.FUN-750129  --Begin
   LET g_sql = " azp01.azp_file.azp01,",         #No.FUN-A70068
               " order1.type_file.chr20,",
               " order2.type_file.chr20,",
               " order3.type_file.chr20,",
               " oea01.oea_file.oea01,",
               " oea02.oea_file.oea02,",
               " oea03.oea_file.oea03,",
               " oea032.oea_file.oea032,",
               " oea04.oea_file.oea04,",
               " occ02.occ_file.occ02,",
               " gen02.gen_file.gen02,",
               " gem02.gem_file.gem02,",
               " oea23.oea_file.oea23,",
               " oeb03.oeb_file.oeb03,",
               " oeb04.oeb_file.oeb04,",
               " oeb06.oeb_file.oeb06,",
               " oeb05.oeb_file.oeb05,",
               " oeb12.oeb_file.oeb12,",
               " oeb13.oeb_file.oeb13,",
               " oeb14.oeb_file.oeb14,",
               " oeb14t.oeb_file.oeb14t,",  #FUN-D40128
               " oeb15.oeb_file.oeb15,",
               " oeb910.oeb_file.oeb910,",
               " oeb912.oeb_file.oeb912,",
               " oeb913.oeb_file.oeb913,",
               " oeb915.oeb_file.oeb915,",
               " oeb916.oeb_file.oeb916,",
               " oeb917.oeb_file.oeb917,",
               " oea14.oea_file.oea14,",
               " oea15.oea_file.oea15,",
               " oga01.oga_file.oga01,",
               " oga02.oga_file.oga02,",
               " ogb03.ogb_file.ogb03,",
               " ogb12.ogb_file.ogb12,",
               " ogb13.ogb_file.ogb13,",
               " oga23.oga_file.oga23,",   #MOD-860253 ogb23->oga23
               " oma01.oma_file.oma01,",
               " oma10.oma_file.oma10,",
               " omb03.omb_file.omb03,",
               " t_azi03.azi_file.azi03,",
               " t_azi04.azi_file.azi04,",
               " t_azi05.azi_file.azi05,",
               " ima021.ima_file.ima021,",
               " l_azi03.azi_file.azi03,",
               " l_str4.type_file.chr1000"
 
   LET l_table = cl_prt_temptable('axmx450',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ? ,?, ? )  "  #FUN-D40128 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)      #No.TQC-610089 modify
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)     #No.TQC-610089 modify
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
  #LET tm.u  = ARG_VAL(10)  #FUN-D30070
   LET tm.a  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL x450_tm(0,0)
      ELSE CALL x450()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION x450_tm(p_row,p_col)
 DEFINE l_num          LIKE type_file.num10
 DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
 DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000) 
#No.FUN-A70068  ..begin
 
DEFINE tok            base.StringTokenizer 
DEFINE l_zxy03        LIKE zxy_file.zxy03
#No.FUN-A70068  ..end
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW x450_w AT p_row,p_col WITH FORM "axm/42f/axmx450"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '9'
  #LET tm2.u1  = 'Y'  #FUN-D30070
  #LET tm2.u2  = 'N'  #FUN-D30070
  #LET tm2.u3  = 'N'  #FUN-D30070
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE 
#No.FUN-A70068  ..begin

CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
        AFTER FIELD azp01 
            LET g_chk_azp01 = TRUE 
            LET g_azp01_str = get_fldbuf(azp01)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azp01_str,"|") 
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
                  IF STATUS THEN 
                     CONTINUE WHILE  
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF 
                  END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF  
            END IF 
            IF g_chk_azp01 THEN
               DECLARE x450_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH x450_zxy_cs1 INTO l_zxy03 
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF 
            END IF
    
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw01"     
                   LET g_qryparam.state = "c" 
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
            END CASE
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about          
            CALL cl_about()       
 
         ON ACTION help           
            CALL cl_show_help()   
 
         ON ACTION controlg       
            CALL cl_cmdask()     
 
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
         LET INT_FLAG = 0 CLOSE WINDOW x450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

  #   LET l_num = tm.wc1.getIndexOf('azp01',1)
  #    IF l_num = 0 THEN
  #       CALL cl_err('','art-926',0) CONTINUE WHILE
  #    END IF 
# No.FUN-A70068..end
  
   CONSTRUCT BY NAME tm.wc ON oea03,oea04,oea01,oea02,oea14,
                              oea15,oea23,oeb15
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(oea03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           END IF
           IF INFIELD(oea04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea04
              NEXT FIELD oea04
           END IF
           #FUN-CB0002--add--str--
           IF INFIELD(oea01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea11"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea01
              NEXT FIELD oea01
           END IF
           #FUN-CB0002--add--end--
      
           IF INFIELD(oea14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea14
              NEXT FIELD oea14
           END IF
           IF INFIELD(oea15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea15
              NEXT FIELD oea15
           END IF
           #FUN-D40128--add--str--
           IF INFIELD(oea23) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azi"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea23
              NEXT FIELD oea23
           END IF
           #FUN-D40128--add--end
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      LET INT_FLAG = 0
      CLOSE WINDOW x450_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3,  #FUN-D30070
                 tm.a,tm.more  WITHOUT DEFAULTS
		
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3 #FUN-D30070
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
      LET INT_FLAG = 0
      CLOSE WINDOW x450_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmx450'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmx450','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
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
                        #" '",tm.u CLIPPED,"'",  #FUN-D30070
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmx450',g_time,l_cmd)
      END IF
      CLOSE WINDOW x450_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x450()
   ERROR ""
END WHILE
   CLOSE WINDOW x450_w
END FUNCTION
 
FUNCTION x450()
 DEFINE l_plant   LIKE  azp_file.azp01
 DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0094
#DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)  #TQC-C50101 mark
#DEFINE l_za05    LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)                                      #TQC-C50101 mark
 DEFINE l_sql     STRING                        #TQC-C50101 add
 DEFINE l_order   ARRAY[5] OF LIKE faj_file.faj02           # No.FUN-680137 VARCHAR(10)      #No.FUN-550070
 DEFINE sr        RECORD azp01 LIKE azp_file.azp01,          #No.FUN-A70068
                        order1 LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
                        order2 LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
                        order3 LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
                        oea01 LIKE oea_file.oea01,
                        oea02 LIKE oea_file.oea02,
                        oea03 LIKE oea_file.oea03,
                        oea032 LIKE oea_file.oea032,		#客戶簡稱
                        oea04 LIKE oea_file.oea04,		#客戶編號
                        occ02 LIKE occ_file.occ02,		#客戶簡稱
                        gen02 LIKE gen_file.gen02,
                        gem02 LIKE gem_file.gem02,
                        oea23 LIKE oea_file.oea23,
                        oeb03 LIKE oeb_file.oeb03,
                        oeb04 LIKE oeb_file.oeb04,
                        oeb06 LIKE oeb_file.oeb06,
                        oeb05 LIKE oeb_file.oeb05,
                        oeb12 LIKE oeb_file.oeb12,
                        oeb13 LIKE oeb_file.oeb13,
                        oeb14 LIKE oeb_file.oeb14,
                        oeb14t LIKE oeb_file.oeb14t, #FUN-D40128
                        oeb15 LIKE oeb_file.oeb15,
                        oeb910 LIKE oeb_file.oeb910,            #No.FUN-580004
                        oeb912 LIKE oeb_file.oeb912,            #No.FUN-580004
                        oeb913 LIKE oeb_file.oeb913,            #No.FUN-580004
                        oeb915 LIKE oeb_file.oeb915,            #No.FUN-580004
                        oeb916 LIKE oeb_file.oeb916,            #No.FUN-580004
                        oeb917 LIKE oeb_file.oeb917,            #No.FUN-580004
                        oea14 LIKE oea_file.oea14,              #FUN-4C0096
                        oea15 LIKE oea_file.oea15               #FUN-4C0096
                        END RECORD,
          l_azp02   LIKE azp_file.azp02
#No.FUN-750129  --Begin
DEFINE l_oga            RECORD
                        oga01    LIKE oga_file.oga01,
                        oga02    LIKE oga_file.oga02,
                        ogb03    LIKE ogb_file.ogb03,
                        ogb12    LIKE ogb_file.ogb12,
                        ogb13    LIKE ogb_file.ogb13,  
                        oga23    LIKE oga_file.oga23    #MOD-860253 ogb23->oga23
                        END RECORD 
DEFINE l_oma            RECORD
                        oma01    LIKE oma_file.oma01,
                        oma10    LIKE oma_file.oma10,
                        omb03    LIKE omb_file.omb03
                        END RECORD
DEFINE l_azi03          LIKE azi_file.azi03   
DEFINE l_ima021         LIKE ima_file.ima021  
DEFINE l_oeb915         STRING
DEFINE l_oeb912         STRING
DEFINE l_oeb12          STRING
DEFINE l_str4           LIKE type_file.chr1000  
DEFINE l_ima906         LIKE ima_file.ima906
DEFINE l_cnt            LIKE type_file.num5
#No.FUN-750129  --End     
 
     #No.FUN-750129  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-750129  --End  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
  LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth ,
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
   FOREACH sel_azp01_cs INTO l_plant,l_azp02  
       IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF
 
#    SELECT azi03,azi04,azi05                #No.CHI-6A0004 
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取 #No.CHI-6A0004
#      FROM azi_file                         #No.CHI-6A0004
#      WHERE azi01=g_aza.aza17               #No.CHI-6A0004
     
     LET l_sql = "SELECT azp01,'','','',",
                 " oea01, oea02,  oea03, oea032, oea04, occ02, gen02,",
                 "gem02, oea23, oeb03, oeb04, oeb06, oeb05, oeb12,",
                 "oeb13, oeb14,oeb14t,oeb15,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,oea14, oea15 ", #No.FUN-580004 #FUN-D40128 add oeb14t
                 " FROM ",cl_get_target_table(l_plant,'oea_file'),
                 #MOD-BA0119 --- start ---
                 #" ,",cl_get_target_table(l_plant,'OUTER occ_file'),
                 #" ,",cl_get_target_table(l_plant,'OUTER gen_file'),
                 #" ,",cl_get_target_table(l_plant,'OUTER gem_file'),
                 " ,OUTER ",cl_get_target_table(l_plant,'occ_file'),
                 " ,OUTER ",cl_get_target_table(l_plant,'gen_file'),
                 " ,OUTER ",cl_get_target_table(l_plant,'gem_file'),
                 #MOD-BA0119 ---  end  ---
                  " ,",cl_get_target_table(l_plant,'oeb_file'),
                  " ,",cl_get_target_table(l_plant,'azp_file'),
                 " WHERE oea_file.oea04 = occ_file.occ01 AND oea_file.oea14 = gen_file.gen01 ",  #No.FUN-750129
		        "   AND oea_file.oea15 = gem_file.gem01  AND oea01 = oeb01 AND azp01 = oebplant",          #No.FUN-750129
                 "   AND oea00 <>'0' ", #No.B318
                  " AND oeaplant='",l_plant,"'",
                 "   AND oeaconf = 'Y' AND oeahold IS NULL AND ", tm.wc CLIPPED
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
             CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
     CASE tm.a
         WHEN '1'        #已交
            LET l_sql = l_sql CLIPPED," AND oeb24 > 0 "
         WHEN '2'        #未交 BugNo:4038 已結案訂單不可納入
            LET l_sql = l_sql CLIPPED," AND oeb24 = 0 AND oeb70 != 'Y'"                      #MOD-570213 MARK   #MOD-8A0262取消mark
            #LET l_sql = l_sql CLIPPED," AND (oeb12-oeb24+oeb25-oeb26) > 0 AND oeb70 != 'Y'"  #MOD-570213 add    #MOD-8A0262mark
 
     END CASE
display 'l_sql:',l_sql
     PREPARE x450_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE x450_curs1 CURSOR FOR x450_prepare1
     #No.FUN-750129  --Begin
     #CALL cl_outnam('axmx450') RETURNING l_name
 
#FUN-580004--begin
   #  SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
   LET  l_sql="SELECT sma115,sma116 FROM ",cl_get_target_table(l_plant,'sma_file')
                  
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_sma11_pre FROM l_sql
         EXECUTE sel_sma11_pre INTO g_sma115,g_sma116
     #IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
     #       LET g_zaa[45].zaa06 = "Y"
     #       LET g_zaa[46].zaa06 = "Y"
     #       LET g_zaa[59].zaa06 = "N"
     #       LET g_zaa[60].zaa06 = "N"
     #ELSE
     #       LET g_zaa[45].zaa06 = "N"
     #       LET g_zaa[46].zaa06 = "N"
     #       LET g_zaa[59].zaa06 = "Y"
     #       LET g_zaa[60].zaa06 = "Y"
     #END IF
     #IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
     #       LET g_zaa[58].zaa06 = "N"
     #ELSE
     #       LET g_zaa[58].zaa06 = "Y"
     #END IF
     # CALL cl_prt_pos_len()
#No.FUN-580004--end
     #START REPORT x450_rep TO l_name
     #LET g_pageno = 0
     IF g_sma116 MATCHES '[23]' THEN
        LET l_name = 'axmx450a'
     END IF
     IF g_sma116 NOT MATCHES '[23]' AND g_sma115 = 'Y' THEN
        LET l_name = 'axmx450b'
     END IF
     IF g_sma116 NOT MATCHES '[23]' AND g_sma115 = 'N' THEN
        LET l_name = 'axmx450c'
     END IF
     #No.FUN-750129  --End  
     FOREACH x450_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          #No.FUN-750129  --Begin
          #FOR g_i = 1 TO 3
          #    CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea03
          #                                  LET g_orderA[g_i]= g_x[19]
          #         WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea04
          #                                  LET g_orderA[g_i]= g_x[20]
          #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea01
          #                                  LET g_orderA[g_i]= g_x[17]
          #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea02 USING 'yyyymmdd'
          #                                  LET g_orderA[g_i]= g_x[18]
          #         WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oea14
          #                                  LET g_orderA[g_i]= g_x[21]
          #         WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oea15
          #                                  LET g_orderA[g_i]= g_x[22]
          #         WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
          #                                  LET g_orderA[g_i]= g_x[23]
          #         WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oeb15 USING 'yyyymmdd'
          #                                  LET g_orderA[g_i]= g_x[24]
          #         OTHERWISE LET l_order[g_i]  = '-'
          #                   LET g_orderA[g_i] = ' '          #清為空白
          #    END CASE
          #END FOR
          #LET sr.order1 = l_order[1]
          #LET sr.order2 = l_order[2]
          #LET sr.order3 = l_order[3]
          #OUTPUT TO REPORT x450_rep(sr.*)
    #      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05       #No.CHI-6A0004
     #       FROM azi_file
     #      WHERE azi01=sr.oea23
       LET l_sql="SELECT azi03,azi04,azi05 FROM ",cl_get_target_table(l_plant,'azi_file'),
                   " WHERE azi01 = '",sr.oea23,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi031_pre FROM l_sql
         EXECUTE sel_azi031_pre INTO t_azi03,t_azi04,t_azi05 
          IF sr.oeb04[1,4] !='MISC' THEN
    #         SELECT ima021 INTO l_ima021 FROM ima_file
    #          WHERE ima01 = sr.oeb04
         LET l_sql="SELECT ima021 FROM ",cl_get_target_table(l_plant,'ima_file'),
                   " WHERE ima01 = '",sr.oeb04,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ima021_pre FROM l_sql
         EXECUTE sel_ima021_pre INTO l_ima021
          ELSE
             LET l_ima021 = ''
          END IF
        #  SELECT ima906 INTO l_ima906 FROM ima_file
        #                     WHERE ima01=sr.oeb04
          LET l_sql="SELECT ima906 FROM ",cl_get_target_table(l_plant,'ima_file'),
                   " WHERE ima01 = '",sr.oeb04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ima906_pre FROM l_sql
         EXECUTE sel_ima906_pre INTO l_ima906 
          LET l_str4 = ""
          IF g_sma115 = "Y" THEN
             CASE l_ima906
                WHEN "2"
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                    LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
                    IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                        CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                        LET l_str4 = l_oeb912, sr.oeb910 CLIPPED
                    ELSE
                       IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                          CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                          LET l_str4 = l_str4 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                       END IF
                    END IF
                WHEN "3"
                    IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                        CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                        LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
                    END IF
             END CASE
          ELSE
          END IF
          IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
               #IF sr.oeb910 <> sr.oeb916 THEN   #No.TQC-6B0137  mark
                IF sr.oeb05  <> sr.oeb916 THEN   #No.TQC-6B0137  mod
                   CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
                   LET l_str4 = l_str4 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
                END IF
          END IF
          
          LET sr.oeb917=cl_digcut(sr.oeb917,2) #FUN-D40128
          LET sr.oeb12=cl_digcut(sr.oeb12,3)   #FUN-D40128

          INITIALIZE l_oga.* TO NULL
          INITIALIZE l_oma.* TO NULL
          LET l_azi03 = NULL
     #     SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
      #     WHERE oga01=ogb01 AND ogb31=sr.oea01
     #        AND ogb32=sr.oeb03 AND ogaconf='Y'
      #       AND oga09 not IN ('1','5','7','9')  #No.FUN-610020
    LET l_sql="SELECT COUNT(*)  FROM ",cl_get_target_table(l_plant,'oga_file'),
                    " ,",cl_get_target_table(l_plant,'ogb_file'),
                   " WHERE oga01=ogb01 AND ogb31= '",sr.oea01,"' " ,
                   " AND ogb32='",sr.oeb03,"' AND ogaconf='Y' ",
                   " AND oga09 not IN ('1','5','7','9') "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_COUNT_pre FROM l_sql
         EXECUTE sel_COUNT_pre INTO l_cnt  
    
          IF l_cnt = 0 THEN
             LET l_oga.ogb12=cl_digcut(l_oga.ogb12,3) #FUN-D40128
             
             EXECUTE insert_prep USING
                     sr.*,l_oga.*,l_oma.*,t_azi03,t_azi04,t_azi05,
                     l_ima021,l_azi03,l_str4
          ELSE

           LET l_sql="SELECT oga01,oga02,ogb03,ogb12,ogb13,oga23  FROM ",cl_get_target_table(l_plant,'oga_file'),
                    " ,",cl_get_target_table(l_plant,'ogb_file'),
                   " WHERE oga01=ogb01 AND ogb31= '",sr.oea01,"' " ,
                   " AND ogb32='",sr.oeb03,"' AND ogaconf='Y' ",
                   " AND oga09 not IN ('1','5','7','9') "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
             PREPARE x450_c1 from l_sql
             DECLARE x450_c1_curs CURSOR FOR  x450_c1 
              FOREACH x450_c1_curs INTO  l_oga.*
                IF STATUS THEN
                   CALL cl_err('for oga:',STATUS,1)
                   EXIT FOREACH
                END IF
               # SELECT azi03 INTO l_azi03 FROM azi_file           #No.CHI-6A0004
              #   WHERE azi01=l_oga.oga23
                 LET l_sql="SELECT azi03 FROM ",cl_get_target_table(l_plant,'azi_file'),
                  #" WHERE azi01 = l_oga.oga23"                    #TQC-C80016 mark
                   " WHERE azi01 = '",l_oga.oga23,"'"                #TQC-C80016 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi032_pre FROM l_sql
         EXECUTE sel_azi032_pre INTO l_azi03 
                LET l_cnt = 0
              #  SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
             #    WHERE oma01=omb01 AND omb31=l_oga.oga01
             #      AND omb32=l_oga.ogb03 AND omaconf='Y'
                  LET l_sql="SELECT COUNT(*)  FROM ",cl_get_target_table(l_plant,'oma_file'),
                    " ,",cl_get_target_table(l_plant,'omb_file'),
                  #" WHERE oma01=omb01 AND omb31=l_oga.oga01 " ,     #TQC-C80016 mark
                  #" omb32=l_oga.ogb03 AND omaconf='Y'"              #TQC-C80016 mark
                   " WHERE oma01=omb01 AND omb31= '",l_oga.oga01,"'",  #TQC-C80016 add
                   " AND omb32= ",l_oga.ogb03," AND omaconf='Y'"          #TQC-C80016 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_COUNT1_pre FROM l_sql
         EXECUTE sel_COUNT1_pre INTO l_cnt  
                IF l_cnt=0 THEN
                   INITIALIZE l_oma.* TO NULL
                   LET l_oga.ogb12=cl_digcut(l_oga.ogb12,3) #FUN-D40128
                   EXECUTE insert_prep USING
                           sr.*,l_oga.*,l_oma.*,t_azi03,t_azi04,t_azi05,
                           l_ima021,l_azi03,l_str4
                ELSE
                   LET l_oma.oma01=''
                   LET l_oma.oma10=''
                   LET l_oma.omb03=''
                   LET l_sql="SELECT oma01,oma10,omb03  FROM ",cl_get_target_table(l_plant,'oma_file'),
                    " ,",cl_get_target_table(l_plant,'omb_file'),
                 # " WHERE oma01=omb01 AND omb31=l_oga.oga01 " ,         #TQC-C80016 mark
                 # " AND AND omb32=l_oga.ogb03 AND omaconf='Y' ",        #TQC-C80016 mark
                   " WHERE oma01=omb01 AND omb31= '",l_oga.oga01,"'",      #TQC-C80016 add
                   " AND omb32= " ,l_oga.ogb03," AND omaconf='Y' ",      #TQC-C80016 add
                   " ORDER BY oma01,omb03 "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                   
                  PREPARE x450_c2 from l_sql
                  DECLARE x450_c2_curs CURSOR FOR  x450_c2 
                 FOREACH x450_c2_curs INTO l_oma.oma01,l_oma.oma10,l_oma.omb03
                      IF SQLCA.sqlcode THEN
                         EXIT FOREACH
                      END IF
                   LET l_oga.ogb12=cl_digcut(l_oga.ogb12,3) #FUN-D40128
                   EXECUTE insert_prep USING
                           sr.*,l_oga.*,l_oma.*,t_azi03,t_azi04,t_azi05,
                           l_ima021,l_azi03,l_str4
                   END FOREACH
                END IF
            END FOREACH
          END IF
          #No.FUN-750129  --End  
     END FOREACH
 END FOREACH
     #No.FUN-750129  --Begin
     #FINISH REPORT x450_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     #FUN-CB0002--mark--str--
     #IF g_zz05 = 'Y' THEN
     #   CALL cl_wcchp(tm.wc,'oea03,oea14,oea04,oea15,oea01,oea23,oea02,1oeb15')
     #        RETURNING g_str
     #END IF
     #FUN-CB0002--mark--end--
###XtraGrid###     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",tm.a
###XtraGrid###     CALL cl_prt_cs3('axmx450',l_name,g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.template = l_name
    #FUN-D30053--mod--str--  
   #LET g_xgrid.order_field = cl_get_order_field(tm.s,"oea03,oea14,oea04,oea15,oea01,oea23,oea02,1oeb15")
   #LET g_xgrid.grup_field = cl_get_order_field(tm.s,"oea03,oea14,oea04,oea15,oea01,oea23,oea02,1oeb15")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"oea03,oea14,oea04,oea15,oea01,oea23,oea02,1oeb15")
   #LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"oea03,oea14,oea04,oea15,oea01,oea23,oea02,1oeb15")
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,azp01")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,azp01")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,azp01")  #FUN-D30070
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,azp01")
    #FUN-D30053--mod--str--  
    IF g_zz05 = 'Y' THEN
       #CALL cl_wcchp(tm.wc,'oea03,oea14,oea04,oea15,oea01,oea23,oea02,1oeb15')  #FUN-D30053
        CALL cl_wcchp(tm.wc,'oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,azp01')  #FUN-D30053
             RETURNING g_str
    END IF
   #LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc  #FUN-D50099 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),g_str  #FUN-D50099
    CALL cl_xg_view()    ###XtraGrid###
     #No.FUN-750129  --End  
END FUNCTION
 
#No.FUN-750129  --Begin
#REPORT x450_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)
#DEFINE sr           RECORD order1 LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
#                           order2 LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
#                           order3 LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
#                        oea01 LIKE oea_file.oea01,
#                        oea02 LIKE oea_file.oea02,
#                        oea03 LIKE oea_file.oea03,
#                        oea032 LIKE oea_file.oea032,		#客戶簡稱
#                        oea04 LIKE oea_file.oea04,		#客戶編號
#                        occ02 LIKE occ_file.occ02,		#客戶簡稱
#                        gen02 LIKE gen_file.gen02,
#                        gem02 LIKE gem_file.gem02,
#                        oea23 LIKE oea_file.oea23,
#                        oeb03 LIKE oeb_file.oeb03,
#                        oeb04 LIKE oeb_file.oeb04,
#                        oeb06 LIKE oeb_file.oeb06,
#                        oeb05 LIKE oeb_file.oeb05,
#                        oeb12 LIKE oeb_file.oeb12,
#                        oeb13 LIKE oeb_file.oeb13,
#                        oeb14 LIKE oeb_file.oeb14,
#                        oeb15 LIKE oeb_file.oeb15,
#                        oeb910 LIKE oeb_file.oeb910,            #No.FUN-580004
#                        oeb912 LIKE oeb_file.oeb912,            #No.FUN-580004
#                        oeb913 LIKE oeb_file.oeb913,            #No.FUN-580004
#                        oeb915 LIKE oeb_file.oeb915,            #No.FUN-580004
#                        oeb916 LIKE oeb_file.oeb916,            #No.FUN-580004
#                        oeb917 LIKE oeb_file.oeb917,            #No.FUN-580004
#                        oea14 LIKE oea_file.oea14,              #FUN-4C0096
#                        oea15 LIKE oea_file.oea15               #FUN-4C0096
#                    END RECORD,
#		l_rowno LIKE type_file.num5,        # No.FUN-680137 SMALLINT
#		l_rowno1 LIKE type_file.num5,       # No.FUN-680137 SMALLINT
#		l_cnt    LIKE type_file.num5,        #No.FUN-680137 SMALLINT
#		l_amt_1  LIKE oeb_file.oeb14,
#		l_amt_2  LIKE oeb_file.oeb12,
#      l_oga    RECORD
#                 oga01    LIKE oga_file.oga01,
#                 oga02    LIKE oga_file.oga02,
#                 ogb03    LIKE ogb_file.ogb03,
#                 ogb12    LIKE ogb_file.ogb12,
#                 ogb13    LIKE ogb_file.ogb13,  #FUN-4C0096
#                 ogb23    LIKE oga_file.oga23   #FUN-4C0096
#               END RECORD,
#      l_oma    RECORD
#                 oma01    LIKE oma_file.oma01,
#                 oma10    LIKE oma_file.oma10,
#                 omb03    LIKE omb_file.omb03
#               END RECORD,
#               l_str     LIKE aaf_file.aaf03,      # No.FUN-680137  VARCHAR(40)       #FUN-4C0096 add
#               l_str1    LIKE aaf_file.aaf03,      # No.FUN-680137  VARCHAR(40)       #FUN-4C0096 add
#               l_str2    LIKE aaf_file.aaf03,      # No.FUN-680137  VARCHAR(40)       #FUN-4C0096 add
#               l_str3    LIKE aaf_file.aaf03,      # No.FUN-680137  VARCHAR(40)       #FUN-4C0096 add
#               l_azi03    LIKE azi_file.azi03,  #FUN-4C0096
#               l_ima021   LIKE ima_file.ima021  #FUN-4C0096 add
##No.FUN-580004--begin
#   DEFINE  l_oeb915    STRING
#   DEFINE  l_oeb912    STRING
#   DEFINE  l_oeb12     STRING
#   DEFINE  l_str4      STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
##No.FUN-580004--end
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.oea01
#
##FUN-4C0096 modify
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#
#      LET l_str3= ''
#      CASE tm.a
#           WHEN '1' LET l_str3=g_x[14] CLIPPED;
#           WHEN '2' LET l_str3=g_x[15] CLIPPED;
#           WHEN '3' LET l_str3=g_x[16] CLIPPED;
#      END CASE
#      LET g_head1 = g_x[13] CLIPPED,
#                    g_orderA[1] CLIPPED,'-',
#                    g_orderA[2] CLIPPED,'-',
#                    g_orderA[3] CLIPPED
#      PRINT g_head1 CLIPPED,
#            COLUMN g_c[35],l_str3 CLIPPED
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39],
#            g_x[40],
#            g_x[41],
#            g_x[42],
#            g_x[43],
#            g_x[44],
#            g_x[45],
#            g_x[46],
#            g_x[47],
#            g_x[48],
#            g_x[49],
#            g_x[50],
#            g_x[51],
#            g_x[52],
#            g_x[53],
#            g_x[54],
#            g_x[55],
#            g_x[56],
#            g_x[57],
#            g_x[58],           #No.FUN-580004
#            g_x[59],           #No.FUN-580004
#            g_x[60]            #No.FUN-580004
#      PRINT g_dash1
#
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#   BEFORE GROUP OF sr.oea01
#      LET l_rowno = 1
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05       #No.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.oea23
#
#      PRINT COLUMN g_c[31],sr.oea01 CLIPPED,
#            COLUMN g_c[32],sr.oea02,
#            COLUMN g_c[33],sr.oea03,
#            COLUMN g_c[34],sr.oea032,
#            COLUMN g_c[35],sr.oea04,
#            COLUMN g_c[36],sr.occ02,
#            COLUMN g_c[37],sr.oea14,
#            COLUMN g_c[38],sr.gen02,
#            COLUMN g_c[39],sr.oea15,
#            COLUMN g_c[40],sr.gem02;
#
#   ON EVERY ROW
#       #-----No.MOD-570175-----
#      IF sr.oeb04[1,4] !='MISC' THEN
#         SELECT ima021 INTO l_ima021 FROM ima_file
#          WHERE ima01 = sr.oeb04
#      ELSE
#         LET l_ima021 = ''
#      END IF
#       #-----No.MOD-570175 END-----
#
##FUN-580004--begin
#
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01=sr.oeb04
#      LET l_str4 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
#                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
#                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                    LET l_str4 = l_oeb912, sr.oeb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
#                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                      LET l_str4 = l_str4 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
#                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                    LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           #IF sr.oeb910 <> sr.oeb916 THEN   #No.TQC-6B0137  mark
#            IF sr.oeb05  <> sr.oeb916 THEN   #No.TQC-6B0137  mod
#               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
#               LET l_str4 = l_str4 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
#            END IF
#      END IF
##FUN-580004--end
#      PRINT COLUMN g_c[41],sr.oeb03 USING '####',
#            #COLUMN g_c[42],sr.oeb04[1,20],  #No.FUN-580004
#            COLUMN g_c[42],sr.oeb04 clipped,  #No.FUN-580004  #NO.FUN-5B0015
#            COLUMN g_c[58],l_str4 CLIPPED,  #No.FUN-580004
#            COLUMN g_c[43],sr.oeb06,
#            COLUMN g_c[44],l_ima021,
#            COLUMN g_c[59],sr.oeb916 ,                              #No.FUN-580004
#            COLUMN g_c[60],sr.oeb917 USING '###########&.##',       #No.FUN-580004
#            COLUMN g_c[45],sr.oeb05,
#            COLUMN g_c[46],sr.oeb12 USING '###########.###',
#            COLUMN g_c[47],cl_numfor(sr.oeb13,47,t_azi03),          #No.CHI-6A0004    
#            COLUMN g_c[48],cl_numfor(sr.oeb14,48,t_azi04),          #No.CHI-6A0004
#            COLUMN g_c[49],sr.oeb15;
# 
#      SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
#       WHERE oga01=ogb01 AND ogb31=sr.oea01
#         AND ogb32=sr.oeb03 AND ogaconf='Y'
#         AND oga09 not IN ('1','5','7','9')  #No.FUN-610020
#      IF l_cnt = 0 THEN
#         PRINT ' '
#      ELSE
#         DECLARE x450_c1 CURSOR FOR
#             SELECT oga01,oga02,ogb03,ogb12,ogb13,oga23 FROM oga_file,ogb_file
#              WHERE oga01=ogb01 AND ogb31=sr.oea01
#                AND ogb32=sr.oeb03 AND ogaconf='Y'
#                AND oga09 not IN ('1','5','7','9')  #BugNo:6315  #No.FUN-610020
#                ORDER BY oga01,ogb03
#         FOREACH x450_c1 INTO l_oga.*
#            IF STATUS THEN
#               CALL cl_err('for oga:',STATUS,1)
#               PRINT ' '
#               EXIT FOREACH
#            END IF
#            SELECT azi03 INTO t_azi03 FROM azi_file           #No.CHI-6A0004
#             WHERE azi01=l_oga.oga23
#            PRINT  COLUMN g_c[50],l_oga.oga01,
#                   COLUMN g_c[51],l_oga.ogb03 USING '####',
#                   COLUMN g_c[52],l_oga.oga02,
#                   COLUMN g_c[53],l_oga.ogb12 USING '###########.###',
#                   COLUMN g_c[54],cl_numfor(l_oga.ogb13,54,t_azi03);   #No.CHI-6A0004
#            LET l_cnt = 0
#            SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
#             WHERE oma01=omb01 AND omb31=l_oga.oga01
#               AND omb32=l_oga.ogb03 AND omaconf='Y'
#            IF l_cnt=0 THEN
#               PRINT ' '
#            ELSE
#               LET l_oma.oma01=''
#               LET l_oma.oma10=''
#               LET l_oma.omb03=''
#               DECLARE x450_c2 CURSOR FOR
#                  SELECT oma01,oma10,omb03 FROM oma_file,omb_file
#                   WHERE oma01=omb01 AND omb31=l_oga.oga01
#                     AND omb32=l_oga.ogb03 AND omaconf='Y'
#                     ORDER BY oma01,omb03
#               FOREACH x450_c2 INTO l_oma.oma01,l_oma.oma10,l_oma.omb03
#                  IF SQLCA.sqlcode THEN
#                     PRINT ''
#                     EXIT FOREACH
#                  END IF
#                  PRINT  COLUMN g_c[55],l_oma.oma01,
#                         COLUMN g_c[56],l_oma.omb03 USING '####',
#                         COLUMN g_c[57],l_oma.oma10
#               END FOREACH
#            END IF
#         END FOREACH
#      END IF
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_amt_1 = GROUP SUM(sr.oeb14)
#         LET l_amt_2 = GROUP SUM(sr.oeb12)
#         PRINT ''
#         PRINT COLUMN g_c[44],g_orderA[1] CLIPPED,
#	       COLUMN g_c[45],g_x[11] CLIPPED,
#               COLUMN g_c[46],l_amt_2 USING '###########.###',
#               COLUMN g_c[48],cl_numfor(l_amt_1,48,t_azi05)   #No.CHI-6A0004
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_amt_1 = GROUP SUM(sr.oeb14)
#         LET l_amt_2 = GROUP SUM(sr.oeb12)
#         PRINT ''
#         PRINT COLUMN g_c[44],g_orderA[2] CLIPPED,
#         COLUMN g_c[45],g_x[11] CLIPPED,
#         COLUMN g_c[46],l_amt_2 USING '###########.###',
#         COLUMN g_c[48],cl_numfor(l_amt_1,48,t_azi05)      #No.CHI-6A0004
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_amt_1 = GROUP SUM(sr.oeb14)
#         LET l_amt_2 = GROUP SUM(sr.oeb12)
#         PRINT ''
#         PRINT COLUMN g_c[44],g_orderA[3] CLIPPED,
#	       COLUMN g_c[45],g_x[11] CLIPPED,
#               COLUMN g_c[46],l_amt_2 USING '###########.###',
#               COLUMN g_c[48],cl_numfor(l_amt_1,48,t_azi05)    #No.CHI-6A0004
#         PRINT ''
#      END IF
#
#   ON LAST ROW
#      PRINT ''
#      LET l_amt_1 = SUM(sr.oeb14)
#      PRINT COLUMN g_c[44],g_x[12] CLIPPED,
#            COLUMN g_c[48],cl_numfor(l_amt_1,48,t_azi05)    #No.CHI-6A0004
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         #TQC-630166
#         #     IF tm.wc[001,070] > ' ' THEN            # for 80
#         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         #     IF tm.wc[071,140] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         #     IF tm.wc[141,210] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         #     IF tm.wc[211,280] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#         #END TQC-630166
#
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#     #PRINT COLUMN g_c[31], g_x[4] CLIPPED,
#     #      COLUMN g_c[34], g_x[5] CLIPPED,
#     #      COLUMN g_c[37], g_x[9] CLIPPED,
#     #      COLUMN g_c[40], g_x[10] CLIPPED,
#     PRINT  COLUMN (g_len-9), g_x[7] CLIPPED  #No.FUN-580004
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#        #PRINT COLUMN g_c[31], g_x[4] CLIPPED,
#        #      COLUMN g_c[34], g_x[5] CLIPPED,
#        #      COLUMN g_c[37], g_x[9] CLIPPED,
#        #      COLUMN g_c[40], g_x[10] CLIPPED,
#         PRINT COLUMN (g_len-9), g_x[6] CLIPPED  #No.FUN-580004
#      ELSE
#         SKIP 2 LINE
#      END IF
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4]
#             PRINT g_memo
#      END IF
### END FUN-550127
#
#END REPORT
#No.FUN-750129  --End  


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
