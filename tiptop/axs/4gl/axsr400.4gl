# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: axsr400.4gl
# Descriptions...: 四期銷售分析表
# Date & Author..: 95/03/06 By Danny
# Modify.........: No.FUN-520029 05/03/07 By kim 報表轉XML功能
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 新增地區欄位
# Modify.........: No.FUN-580013 05/08/18 By will 報表轉XML格式
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680130 06/08/31 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6C0119 06/12/21 By Ray 報表調整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740041 07/04/14 By Carol 第二期的金額會重覆計算,將sr.amt2清成0。
# Modify.........: No.FUN-740015 07/04/17 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.MOD-7B0032 07/11/08 By Pengu 若QBE條件有下產品編號而條件選項下的來源選擇3:出貨實際會出現SQL錯誤
# Modify.........: No.CHI-870001 08/07/22 By Smapmin 走出貨簽收流程,未簽收前不可納入銷貨收入
# Modify.........: No.CHI-870039 08/07/24 By xiaofeizhu 抓oea_file資料時，排除oea00=A的資料，抓oga_file資料時，排除oga00=A的資料
# Modify.........: No.MOD-8C0137 08/12/22 By Pengu SQL 語法中應該要將occ_file 加上 OUTER ,否則會抓不到資料
# Modify.........: No.MOD-950018 09/05/05 By Smapmin 營運中心欄位應加上營運中心使用權限判斷
# Modify.........: No.TQC-950044 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.CHI-950025 09/06/24 By mike sql語句調整        
# Modify.........: No.MOD-980231 09/09/01 By Smapmin 修改SQL語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960154 09/09/07 By chenmoyan 改CONSTRUCT的欄位皆可開窗
# Modify.........: No.FUN-9C0072 10/01/08 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/18 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.TQC-A50147 10/05/25 By Carrier main中结构调整 & MOD-A10015追单
# Modify.........: No:CHI-A60005 10/06/22 By Summer 條件式有oga09就加上'A'的類別
# Modify.........: No.FUN-B80059 11/08/03 By minpp 程序撰寫規範修改
# Modify.........: No.FUN-B90090 11/09/14 By Sakura QBE及排序增加其他分群碼一二三	
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-D30276 13/04/01 By Elise tm.wc,tm.wc2型態調整為STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_sql	string  #No.FUN-580092 HCN
   DEFINE tm  RECORD                               # Print condition RECORD
             #wc      LIKE type_file.chr1000,      # Where condition   #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark    
              wc      STRING,                      #MOD-D30276
             #wc2     LIKE type_file.chr1000,      # Where condition   #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark   
              wc2     STRING,
              s       LIKE type_file.chr4,         # Order by sequence #No.FUN-680130 VARCHAR(4)    
              t       LIKE type_file.chr3,         # Eject sw          #No.FUN-680130 VARCHAR(3)    
              u       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              a1,a2   LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              a3,a4   LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              b1,b2   LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              b3,b4   LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              y1,y2   LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              y3,y4   LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m1b,m1e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m2b,m2e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m3b,m3e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m4b,m4e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              op      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              ch      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              w       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              z       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              more    LIKE type_file.chr1          # Input more condition(Y/N) #No.FUN-680130 VARCHAR(1)
              END RECORD,
          sr  RECORD order1 LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(40) #FUN-5B0105 20->40
                     order2 LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(40) #FUN-5B0105 20->40
                     order3 LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(40) #FUN-5B0105 20->40
                     order4 LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(40) #FUN-5B0105 20->40
                     gem02  LIKE gem_file.gem02,   #部門名稱
                     gen02  LIKE gen_file.gen02,   #人員名稱
                     oab02  LIKE oab_file.oab02,   #銷售名稱
                     oea26  LIKE oea_file.oea26,   #銷售分類二
                     oea032 LIKE oea_file.oea032,  #帳款客戶
                     oca02  LIKE oca_file.oca02,   #客戶分類
                     oea04  LIKE oea_file.oea04,   #送貨客戶
                     oea23  LIKE oea_file.oea23,   #幣別
                     oea24  LIKE oea_file.oea24,   #匯率
                     amt1   LIKE oea_file.oea61,   #第一期金額
                     amt2   LIKE oea_file.oea61,   #第二期金額
                     amt3   LIKE oea_file.oea61,   #第三期金額
                     amt4   LIKE oea_file.oea61,   #第四期金額
                     oea15  LIKE oea_file.oea15,
                     oea14  LIKE oea_file.oea14,
                     oea25  LIKE oea_file.oea25,
                     oea03  LIKE oea_file.oea03,
                     oca01  LIKE oca_file.oca01,
                     azp01  LIKE azp_file.azp01,
                     ima131 LIKE ima_file.ima131,
                     ima06  LIKE ima_file.ima06,
                     oeb04  LIKE oeb_file.oeb04
                    ,ima09  LIKE ima_file.ima09, #FUN-B90090 add
                     ima10  LIKE ima_file.ima10, #FUN-B90090 add
                     ima11  LIKE ima_file.ima11  #FUN-B90090 add
              END RECORD,
          g_order1,g_order2 LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(40)  #FUN-5B0105 20->40
          g_order3,g_order4 LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(40)  #FUN-5B0105 20->40
          g_order           LIKE oeb_file.oeb04,   #No.FUN-680130 VARCHAR(60) 
          g_buf             LIKE ze_file.ze03,     #No.FUN-680130 VARCHAR(10)
          g_str1,g_str2     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(04)
          g_str5,g_str6     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(04)
          g_str7,g_str8     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(08)
          g_str9,g_str10    LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(08)
          g_str3,g_str4     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(06)
          b_date1,e_date1   LIKE type_file.dat,    #No.FUN-680130 DATE
          b_date2,e_date2   LIKE type_file.dat,    #No.FUN-680130 DATE
          b_date3,e_date3   LIKE type_file.dat,    #No.FUN-680130 DATE
          b_date4,e_date4   LIKE type_file.dat,    #No.FUN-680130 DATE
          g_total1,g_total2 LIKE oea_file.oea61,
          g_total3,g_total4 LIKE oea_file.oea61,
          l_azi03           LIKE azi_file.azi03,   #
          l_azi04           LIKE azi_file.azi04,   #
          l_azi05           LIKE azi_file.azi05    #
 
DEFINE   g_chr           LIKE type_file.chr1       #No.FUN-680130 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose #No.FUN-680130 SMALLINT
DEFINE   i               LIKE type_file.num5       #No.FUN-680130 SMALLINT
DEFINE   l_table         STRING                    #No.TQC-A50147
DEFINE   g_str           STRING,                 ### FUN-740015 add ###
         l_oab02         LIKE oab_file.oab02,    ### FUN-740015 add ###
         l_occ02         LIKE occ_file.occ02,    ### FUN-740015 add ###
         l_occ20         LIKE occ_file.occ20,    ### FUN-740015 add ###
         l_occ21         LIKE occ_file.occ21,    ### FUN-740015 add ###
         l_occ22         LIKE occ_file.occ22     ### FUN-740015 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50147  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.s   = ARG_VAL(9)
   LET tm.t   = ARG_VAL(10)
   LET tm.u   = ARG_VAL(11)
   LET tm.a1  = ARG_VAL(12)
   LET tm.b1  = ARG_VAL(13)
   LET tm.y1  = ARG_VAL(14)
   LET tm.m1b = ARG_VAL(15)
   LET tm.m1e = ARG_VAL(16)
   LET tm.a2  = ARG_VAL(17)
   LET tm.b2  = ARG_VAL(18)
   LET tm.y2  = ARG_VAL(19)
   LET tm.m2b = ARG_VAL(20)
   LET tm.m2e = ARG_VAL(21)
   LET tm.a3  = ARG_VAL(22)
   LET tm.b3  = ARG_VAL(23)
   LET tm.y3  = ARG_VAL(24)
   LET tm.m3b = ARG_VAL(25)
   LET tm.m3e = ARG_VAL(26)
   LET tm.a4  = ARG_VAL(27)
   LET tm.b4  = ARG_VAL(28)
   LET tm.y4  = ARG_VAL(29)
   LET tm.m4b = ARG_VAL(30)
   LET tm.m4e = ARG_VAL(31)
   LET tm.op  = ARG_VAL(32)
   LET tm.ch  = ARG_VAL(33)
   LET tm.w   = ARG_VAL(34)
   LET tm.z   = ARG_VAL(35)
   LET g_rep_user = ARG_VAL(36)
   LET g_rep_clas = ARG_VAL(37)
   LET g_template = ARG_VAL(38)
   LET g_rpt_name = ARG_VAL(39)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD #FUN-BB0047 mark
 
# *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/17 *** ##
     LET g_sql = "order1.oab_file.oab02,",
                 "order2.oab_file.oab02,",
                 "order3.oab_file.oab02,",
                 "order4.oab_file.oab02,",
                 "gem02.gem_file.gem02,",     #部門名稱
                 "gen02.gen_file.gen02,",     #人員名稱
                 "oab02.oab_file.oab02,",     #銷售名稱
                 "oea26.oea_file.oea26,",     #銷售分類二
                 "oea032.oea_file.oea032,",   #帳款客戶名稱
                 "oca02.oca_file.oca02,",     #客戶分類
                 "oea04.oea_file.oea04,",     #送貨客戶
                 "oea23.oea_file.oea23,",     #幣別
                 "oea24.oea_file.oea24,",     #匯率
                 "amt1.oea_file.oea61,",      #第一期金額
                 "amt2.oea_file.oea61,",      #第二期金額
                 "amt3.oea_file.oea61,",      #第三期金額
                 "amt4.oea_file.oea61,",      #第四期金額
                 "oeb04.oeb_file.oeb04,",     #產品編號
                 "oea15.oea_file.oea15,",     #部門編號
                 "oea14.oea_file.oea14,",     #人員編號
                 "oea25.oea_file.oea25,",     #銷售分類一
                 "oea03.oea_file.oea03,",     #帳款客戶
                 "oca01.oca_file.oca01,",     #帳款客戶分類
                 "ima131.ima_file.ima131,",   #產品分類
                 "ima06.ima_file.ima06,",     #主要分群碼
                 "azp01.azp_file.azp01,",     #工廠編號
                 "l_oab02.oab_file.oab02,",    
                 "occ02.occ_file.occ02,",   
                 "occ20.occ_file.occ20,",    
                 "occ21.occ_file.occ21,",   
                 "occ22.occ_file.occ22,",
                 "azi05.azi_file.azi05,",
                 "ima09.ima_file.ima09,", #FUN-B90090 add
                 "ima10.ima_file.ima10,", #FUN-B90090 add
                 "ima11.ima_file.ima11"   #FUN-B90090 add 
 
    LET l_table = cl_prt_temptable('axsr400',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,? ,?,?,?,?,?,",
                "        ?,?,?,?,? ,?,?,?,?,?,",
                "        ?,?,?,?,? ,?,?,?,?,?,",
                "        ?,?,?,?,?)" #FUN-B90090 add 3?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
   #No.TQC-A50147  --End  

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axsr400_tm(0,0)        # Input print condition
      ELSE CALL axsr400()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
END MAIN
 
FUNCTION axsr400_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col =10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 7
   ELSE
       LET p_row = 2 LET p_col = 10
   END IF
 
   OPEN WINDOW axsr400_w AT p_row,p_col
        WITH FORM "axs/42f/axsr400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '26 '
   LET tm.u    = 'Y  '
   LET tm.y1   = YEAR(g_today)
   LET tm.y2   = YEAR(g_today)
   LET tm.y3   = YEAR(g_today)
   LET tm.y4   = YEAR(g_today)
   LET tm.m1b  = MONTH(g_today)
   LET tm.m1e  = MONTH(g_today)
   LET tm.m2b  = MONTH(g_today)
   LET tm.m2e  = MONTH(g_today)
   LET tm.m3b  = MONTH(g_today)
   LET tm.m3e  = MONTH(g_today)
   LET tm.m4b  = MONTH(g_today)
   LET tm.m4e  = MONTH(g_today)
   LET tm.a1   = '1'
   LET tm.a2   = '3'
   LET tm.a3   = '1'
   LET tm.a4   = '3'
   LET tm.b1   = '1'
   LET tm.b2   = '1'
   LET tm.b3   = '3'
   LET tm.b4   = '3'
   LET tm.op   = '0'
   LET tm.ch   = '2'
   LET tm.w    = 'Y'
   LET tm.z    = 'Y'
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
   CONSTRUCT BY NAME tm.wc ON azp01
       ON ACTION locale
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
 
     ON ACTION CONTROLP
        CASE
              WHEN INFIELD(azp01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   #LET g_qryparam.form = "q_azp"   #MOD-950018
                   LET g_qryparam.form = "q_zxy"   #MOD-950018
                   LET g_qryparam.arg1 = g_user   #MOD-950018
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
        END CASE
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      LET tm.wc="azp01='",g_plant,"'"
   END IF
 
   CONSTRUCT BY NAME tm.wc2 ON oea15,oea14,oea25,oea26,oea03,oca01,oea04,oea23,
                               ima131,ima06,oeb04,occ20,occ21,occ22       #No.FUN-960154
                               ,ima09,ima10,ima11 #FUN-B90090 add 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION controlp
         CASE
              WHEN INFIELD(oea03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea03
                   NEXT FIELD oea03
              WHEN INFIELD(oea04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea04
                   NEXT FIELD oea04
              WHEN INFIELD(oea15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form="q_gem"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea15
                   NEXT FIELD oea15
              WHEN INFIELD(oea14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea14
                   NEXT FIELD oea14
              WHEN INFIELD(oea23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_azi'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea23
                   NEXT FIELD oea23
              WHEN INFIELD(oea25)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oab"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea25
                   NEXT FIELD oea25
              WHEN INFIELD(oea26)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oab"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oea26
                   NEXT FIELD oea26
              WHEN INFIELD(oeb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oeb04
                   NEXT FIELD oeb04
              WHEN INFIELD(occ20)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gea'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.occ20
                   NEXT FIELD occ20
              WHEN INFIELD(occ21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_geb'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.occ21
                   NEXT FIELD occ21
              WHEN INFIELD(ima06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_imz"
                   LET g_qryparam.state    = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima06
                   NEXT FIELD ima06
              WHEN INFIELD(ima131)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oba"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima131
                   NEXT FIELD ima131
              WHEN INFIELD(oca01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oca"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oca01
                   NEXT FIELD oca01
              WHEN INFIELD(occ22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_geo"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.occ22
                   NEXT FIELD occ22
#FUN-B90090----------add-------str
              WHEN INFIELD(ima09) #其他分群碼一
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "D"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima09
                   NEXT FIELD ima09
              WHEN INFIELD(ima10) #其他分群碼二
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "E"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima10
                   NEXT FIELD ima10
              WHEN INFIELD(ima11) #其他分群碼三
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "F"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima11
                   NEXT FIELD ima11
#FUN-B90090----------add-------end                   
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc2 = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                 tm.a1,tm.b1,tm.y1,tm.m1b,tm.m1e,tm.a2,tm.b2,
                 tm.y2,tm.m2b,tm.m2e,tm.a3,tm.b3,tm.y3,tm.m3b,tm.m3e,tm.a4,
                 tm.b4,tm.y4,tm.m4b,tm.m4e,tm.op,tm.ch,tm.w,tm.z,tm.more
                 WITHOUT DEFAULTS
      AFTER FIELD a1
         IF cl_null(tm.a1) OR tm.a1 NOT MATCHES '[1-4]' THEN
            NEXT FIELD a1
         END IF
         CASE WHEN tm.a1='1' LET g_str1=g_x[30]
              WHEN tm.a1='2' LET g_str1=g_x[31]
              WHEN tm.a1='3' LET g_str1=g_x[32]
              WHEN tm.a1='4' LET g_str1=g_x[33]
         END CASE
      AFTER FIELD b1
         IF cl_null(tm.b1) OR tm.b1 NOT MATCHES '[1-4]' THEN
            NEXT FIELD b1
         END IF
         CASE WHEN tm.b1='1' LET g_str7=g_x[15]
              WHEN tm.b1='2' LET g_str7=g_x[16]
              WHEN tm.b1='3' LET g_str7=g_x[17]
              WHEN tm.b1='4' LET g_str7=g_x[18]
         END CASE
         DISPLAY g_str7 TO FORMONLY.c1
      AFTER FIELD y1
         IF cl_null(tm.y1) THEN NEXT FIELD y1 END IF
      AFTER FIELD m1b
         IF NOT cl_null(tm.m1b) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1b > 12 OR tm.m1b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1b
               END IF
            ELSE
               IF tm.m1b > 13 OR tm.m1b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1b
               END IF
            END IF
         END IF
         IF cl_null(tm.m1b) THEN NEXT FIELD m1b END IF
 
      AFTER FIELD m1e
         IF NOT cl_null(tm.m1e) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1e > 12 OR tm.m1e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1e
               END IF
            ELSE
               IF tm.m1e > 13 OR tm.m1e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1e
               END IF
            END IF
         END IF
         IF cl_null(tm.m1e) THEN NEXT FIELD m1e END IF
 
      AFTER FIELD a2
         IF cl_null(tm.a2) OR tm.a2 NOT MATCHES '[1-4]' THEN
            NEXT FIELD a2
         END IF
         CASE WHEN tm.a2='1' LET g_str2=g_x[30]
              WHEN tm.a2='2' LET g_str2=g_x[31]
              WHEN tm.a2='3' LET g_str2=g_x[32]
              WHEN tm.a2='4' LET g_str2=g_x[33]
         END CASE
      AFTER FIELD b2
         IF cl_null(tm.b2) OR tm.b2 NOT MATCHES '[1-4]' THEN
            NEXT FIELD b2
         END IF
         CASE WHEN tm.b2='1' LET g_str8=g_x[15]
              WHEN tm.b2='2' LET g_str8=g_x[16]
              WHEN tm.b2='3' LET g_str8=g_x[17]
              WHEN tm.b2='4' LET g_str8=g_x[18]
         END CASE
         DISPLAY g_str8 TO FORMONLY.c2
      AFTER FIELD y2
         IF cl_null(tm.y2) THEN NEXT FIELD y2 END IF
 
      AFTER FIELD m2b
         IF NOT cl_null(tm.m2b) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y2
            IF g_azm.azm02 = 1 THEN
               IF tm.m2b > 12 OR tm.m2b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2b
               END IF
            ELSE
               IF tm.m2b > 13 OR tm.m2b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2b
               END IF
            END IF
         END IF
         IF cl_null(tm.m2b) THEN NEXT FIELD m2b END IF
 
      AFTER FIELD m2e
         IF NOT cl_null(tm.m2e) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y2
            IF g_azm.azm02 = 1 THEN
               IF tm.m2e > 12 OR tm.m2e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2e
               END IF
            ELSE
               IF tm.m2e > 13 OR tm.m2e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2e
               END IF
            END IF
         END IF
         IF cl_null(tm.m2e) THEN NEXT FIELD m2e END IF
 
      AFTER FIELD a3
         IF cl_null(tm.a3) OR tm.a3 NOT MATCHES '[1-4]' THEN
            NEXT FIELD a3
         END IF
         CASE WHEN tm.a3='1' LET g_str5=g_x[30]
              WHEN tm.a3='2' LET g_str5=g_x[31]
              WHEN tm.a3='3' LET g_str5=g_x[32]
              WHEN tm.a3='4' LET g_str5=g_x[33]
         END CASE
      AFTER FIELD b3
         IF cl_null(tm.b3) OR tm.b3 NOT MATCHES '[1-4]' THEN
            NEXT FIELD b3
         END IF
         CASE WHEN tm.b3='1' LET g_str9=g_x[15]
              WHEN tm.b3='2' LET g_str9=g_x[16]
              WHEN tm.b3='3' LET g_str9=g_x[17]
              WHEN tm.b3='4' LET g_str9=g_x[18]
         END CASE
         DISPLAY g_str9 TO FORMONLY.c3
      AFTER FIELD y3
         IF cl_null(tm.y3) THEN NEXT FIELD y3 END IF
 
      AFTER FIELD m3b
         IF NOT cl_null(tm.m3b) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y3
            IF g_azm.azm02 = 1 THEN
               IF tm.m3b > 12 OR tm.m3b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m3b
               END IF
            ELSE
               IF tm.m3b > 13 OR tm.m3b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m3b
               END IF
            END IF
         END IF
         IF cl_null(tm.m3b) THEN NEXT FIELD m3b END IF
 
      AFTER FIELD m3e
         IF NOT cl_null(tm.m3e) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y3
            IF g_azm.azm02 = 1 THEN
               IF tm.m3e > 12 OR tm.m3e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m3e
               END IF
            ELSE
               IF tm.m3e > 13 OR tm.m3e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m3e
               END IF
            END IF
         END IF
         IF cl_null(tm.m3e) THEN NEXT FIELD m3e END IF
 
      AFTER FIELD a4
         IF cl_null(tm.a4) OR tm.a4 NOT MATCHES '[1-4]' THEN
            NEXT FIELD a4
         END IF
         CASE WHEN tm.a4='1' LET g_str6=g_x[30]
              WHEN tm.a4='2' LET g_str6=g_x[31]
              WHEN tm.a4='3' LET g_str6=g_x[32]
              WHEN tm.a4='4' LET g_str6=g_x[33]
         END CASE
      AFTER FIELD b4
         IF cl_null(tm.b4) OR tm.b4 NOT MATCHES '[1-4]' THEN
            NEXT FIELD b4
         END IF
         CASE WHEN tm.b4='1' LET g_str10=g_x[15]
              WHEN tm.b4='2' LET g_str10=g_x[16]
              WHEN tm.b4='3' LET g_str10=g_x[17]
              WHEN tm.b4='4' LET g_str10=g_x[18]
         END CASE
         DISPLAY g_str10 TO FORMONLY.c4
      AFTER FIELD y4
         IF cl_null(tm.y4) THEN NEXT FIELD y4 END IF
 
      AFTER FIELD m4b
         IF NOT cl_null(tm.m4b) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y4
            IF g_azm.azm02 = 1 THEN
               IF tm.m4b > 12 OR tm.m4b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4b
               END IF
            ELSE
               IF tm.m4b > 13 OR tm.m4b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4b
               END IF
            END IF
         END IF
         IF cl_null(tm.m4b) THEN NEXT FIELD m4b END IF
 
      AFTER FIELD m4e
         IF NOT cl_null(tm.m4e) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y4
            IF g_azm.azm02 = 1 THEN
               IF tm.m4e > 12 OR tm.m4e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4e
               END IF
            ELSE
               IF tm.m4e > 13 OR tm.m4e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m4e
               END IF
            END IF
         END IF
         IF cl_null(tm.m4e) THEN NEXT FIELD m4e END IF
 
      AFTER FIELD op
         IF cl_null(tm.op) OR tm.op NOT MATCHES '[0-2]' THEN
            NEXT FIELD op
         END IF
         CASE WHEN tm.op='0' LET g_str3=''
              WHEN tm.op='1' LET g_str3=g_x[11]
              WHEN tm.op='2' LET g_str3=g_x[28]
         END CASE
      AFTER FIELD ch
         IF cl_null(tm.ch) OR tm.ch NOT MATCHES '[1-2]' THEN
            NEXT FIELD ch
         END IF
         CASE WHEN tm.ch='1' LET g_str4=g_x[12]
              WHEN tm.ch='2' LET g_str4=g_x[13]
         END CASE
      AFTER FIELD w
         IF cl_null(tm.w) OR tm.w NOT MATCHES '[YN]' THEN NEXT FIELD w END IF
      AFTER FIELD z
         IF cl_null(tm.z) OR tm.z NOT MATCHES '[YN]' THEN NEXT FIELD z END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axsr400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axsr400','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",           #No.TQC-610090 add
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a1 CLIPPED,"'",
                         " '",tm.b1 CLIPPED,"'",
                         " '",tm.y1 CLIPPED,"'",
                         " '",tm.m1b CLIPPED,"'",
                         " '",tm.m1e CLIPPED,"'",
                         " '",tm.a2 CLIPPED,"'",
                         " '",tm.b2 CLIPPED,"'",
                         " '",tm.y2 CLIPPED,"'",
                         " '",tm.m2b CLIPPED,"'",
                         " '",tm.m2e CLIPPED,"'",
                         " '",tm.a3 CLIPPED,"'",
                         " '",tm.b3 CLIPPED,"'",
                         " '",tm.y3 CLIPPED,"'",
                         " '",tm.m3b CLIPPED,"'",
                         " '",tm.m3e CLIPPED,"'",
                         " '",tm.a4 CLIPPED,"'",
                         " '",tm.b4 CLIPPED,"'",
                         " '",tm.y4 CLIPPED,"'",
                         " '",tm.m4b CLIPPED,"'",
                         " '",tm.m4e CLIPPED,"'",
                         " '",tm.op CLIPPED,"'",
                         " '",tm.ch CLIPPED,"'" ,
                         " '",tm.w CLIPPED,"'",            #No.TQC-610090 add   
                         " '",tm.z CLIPPED,"'",            #No.TQC-610090 add 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axsr400',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axsr400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axsr400()
   ERROR ""
END WHILE
   CLOSE WINDOW axsr400_w
END FUNCTION
 
FUNCTION r400_wc2(p_x)
  DEFINE l_i,l_j  LIKE type_file.num5,   #No.FUN-680130 SMALLINT
         l_buf    LIKE type_file.chr1000,#tm.wc2之長度  #No.FUN-680130 VARCHAR(1000)
         p_x      LIKE type_file.chr1    #No.FUN-680130 VARCHAR(01)
 
    LET l_buf=tm.wc2
    LET l_j=length(l_buf)
    IF p_x='2' THEN   #訂單/出貨目標
       FOR l_i=1 TO l_j
           IF l_buf[l_i,l_i+2]='oea' THEN LET l_buf[l_i,l_i+2]='osa' END IF
       END FOR
    END IF
    IF p_x='3' THEN   #出貨實際
       FOR l_i=1 TO l_j
           IF l_buf[l_i,l_i+2]='oea' THEN LET l_buf[l_i,l_i+2]='oga' END IF
           IF l_buf[l_i,l_i+4]='oeb04' THEN LET l_buf[l_i,l_i+4]='ogb04' END IF   #No.MOD-7B0032 add
       END FOR
    END IF
    RETURN l_buf
END FUNCTION
 
#FUNCTION r400_g_sql(p_azp03,p_b,p_y,p_mb,p_me,p_bdate,p_edate)  #FUN-A10098
FUNCTION r400_g_sql(p_azp01,p_b,p_y,p_mb,p_me,p_bdate,p_edate)  #FUN-A10098 
   DEFINE p_azp03    LIKE azp_file.azp03,       #工廠別
          p_azp01    LIKE azp_file.azp01,       #FUN-A10098 
          p_b	     LIKE type_file.chr1,       #訂單/出貨/目標 #No.FUN-680130 VARCHAR(1)                   
          p_y        LIKE type_file.num10,      #年別           #No.FUN-680130 INTEGER                 
          p_mb       LIKE type_file.num10,      #起始期別       #No.FUN-680130 INTEGER                 
          p_me       LIKE type_file.num10,      #結束期別       #No.FUN-680130 INTEGER                 
          p_bdate    LIKE type_file.dat,        #起始日期       #No.FUN-680130 DATE                 
          p_edate    LIKE type_file.dat,        #結束日期       #No.FUN-680130 DATE                 
          l_wc       LIKE type_file.chr1000                     #No.FUN-680130 VARCHAR(1000)
   IF p_b = '1' THEN #-->訂單實際(oea_file)
      LET g_sql = "SELECT '','','','',",
                  "       gem02,gen02,oab02,oea26,oea032,oca02,",
                  "       oea04,oea23,oea24,oeb14,0,0,0,oea15,oea14,",
                  "       oea25,oea03,oca01,'',ima131,ima06,oeb04 ",
                  "      ,ima09,ima10,ima11 ", #FUN-B90090 add                   
#FUN-A10098---BEGIN
#                  "  FROM ",s_dbstring(p_azp03),"oea_file,",                                                                        
#                            s_dbstring(p_azp03),"oeb_file,",                                                                        
#                            s_dbstring(p_azp03),"occ_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"oca_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"gem_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"gen_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"ima_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"oab_file ",                                                                        
                  "  FROM ",cl_get_target_table(p_azp01,'oea_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gem_file')," ON(gem01 = oea15) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gen_file')," ON(gen01 = oea14) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oab_file')," ON(oab01 = oea25), ",
                            cl_get_target_table(p_azp01,'oeb_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'ima_file')," ON(ima01 = oeb04),",
                            cl_get_target_table(p_azp01,'occ_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oca_file')," ON(oca01 = occ03) ",
#FUN-A10098---END
                  " WHERE ",tm.wc2 CLIPPED,
                  "   AND oea02 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                  "   AND oea01 = oeb01 ",
                  "   AND oea00 <> '3A' ",    #CHI-950025       
              #    "   AND ima_file.ima01 = oeb04 ",
                  "   AND occ01 = oea03 "
              #    "   AND oca_file.oca01 = occ03 ",
              #    "   AND gem_file.gem01 = oea15 ",
              #    "   AND gen_file.gen01 = oea14 ",
              #    "   AND oab_file.oab01 = oea25 "
      IF tm.w='Y' THEN
          LET g_sql = g_sql CLIPPED," AND oeaconf='Y' "
      ELSE
          LET g_sql = g_sql CLIPPED," AND oeaconf != 'X' " #01/08/16 mandy
      END IF
   END IF
   IF p_b MATCHES "[24]" THEN #-->訂單/出貨目標(osa_file)
      IF p_b = '2' THEN LET g_chr='1' END IF
      IF p_b = '4' THEN LET g_chr='2' END IF
      CALL r400_wc2('2') RETURNING l_wc
      LET g_sql = "SELECT '','','','',",
                  "       gem02,gen02,oab02,osa26,occ02,oca02,",
                  "       osa04,osa23,osa24,osb04,osb05,0,0,osa15,osa14,",
                  "       osa25,osa03,oca01,'',ima131,ima06,''",
                  "      ,ima09,ima10,ima11 ", #FUN-B90090 add                  
#FUN-A10098---BEGIN
#                  "  FROM ",s_dbstring(p_azp03),"osa_file,",                                                                        
#                            s_dbstring(p_azp03),"osb_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"occ_file,",    #No.MOD-8C0137 add OUTER                                            
#                  " OUTER ",s_dbstring(p_azp03),"oca_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"gem_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"gen_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"ima_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"oab_file ",                                                                        
                  "  FROM ",cl_get_target_table(p_azp01,'osb_file'),",",
                            cl_get_target_table(p_azp01,'osa_file'),
                  " LEFT OUTER JOIN (",cl_get_target_table(p_azp01,'occ_file'),    
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oca_file')," ON(oca01 = occ03)) ON(occ01 = osa03)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gem_file')," ON(gem01 = osa15) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gen_file')," ON(gen01 = osa14) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'ima_file')," ON(ima131= osa90) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oab_file')," ON(oab01 = osa25)",
#FUN-A10098---END
                  " WHERE ",l_wc CLIPPED,
                  "   AND osb01 = osa01 ",
                  "   AND osb02 = ",p_y,
                  "   AND osb03 BETWEEN ",p_mb," AND ",p_me,
              #    "   AND occ_file.occ01 = osa03 ",
              #    "   AND oca_file.oca01 = occ03 ",
              #    "   AND ima_file.ima131= osa90 ",
              #    "   AND gem_file.gem01 = osa15 ",
              #    "   AND gen_file.gen01 = osa14 ",
              #    "   AND oab_file.oab01 = osa25 ",
                  "   AND osa05 = '",g_chr,"'"          #訂單/出貨
   END IF
   IF p_b='3' THEN #-->出貨實際(oga_file)
      CALL r400_wc2('3') RETURNING l_wc
      LET g_sql = "SELECT '','','','',",
                  "       gem02,gen02,oab02,oga26,oga032,oca02,",
                  "       oga04,oga23,oga24,ogb14,0,0,0,oga15,oga14,",
                  "       oga25,oga03,oca01,'',ima131,ima06,ogb04 ",
                  "      ,ima09,ima10,ima11 ", #FUN-B90090 add                  
#FUN-A10098---BEGIN
#                  "  FROM ",s_dbstring(p_azp03),"oga_file,",                                                                        
#                            s_dbstring(p_azp03),"occ_file,",                                                                        
#                            s_dbstring(p_azp03),"ogb_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"oca_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"gem_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"gen_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"ima_file,",                                                                        
#                  " OUTER ",s_dbstring(p_azp03),"oab_file ",                                                                        
                  "  FROM ",cl_get_target_table(p_azp01,'oga_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gem_file')," ON(gem01 = oga15) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gen_file')," ON(gen01 = oga14) ",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oab_file')," ON(oab01 = oga25), ",
                            cl_get_target_table(p_azp01,'occ_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oca_file')," ON(oca01 = occ03),",
                            cl_get_target_table(p_azp01,'ogb_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'ima_file')," ON(ima01 = ogb04)",

#FUN-A10098---END
                  " WHERE ",l_wc CLIPPED,
                  "   AND oga09 IN ('2','3','4','6','8','A')", #CHI-950025 #CHI-A60005 add 'A'   
                  "   AND (oga65 != 'Y' OR oga09 = '8')",  #CHI-870001
                  "   AND oga02 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                  "   AND occ01 = oga03 ",
           #       "   AND oca_file.oca01 = occ03 ",
                  "   AND oga01 = ogb01 ",
                  "   AND oga00 <> 'A' "                  #No.CHI-870039 
           #       "   AND ima_file.ima01 = ogb04 ",
           #       "   AND gem_file.gem01 = oga15 ",
           #       "   AND gen_file.gen01 = oga14 ",
           #       "   AND oab_file.oab01 = oga25 "
      IF tm.z='Y' THEN
          LET g_sql = g_sql CLIPPED," AND ogapost='Y' "
      ELSE
          LET g_sql = g_sql CLIPPED," AND ogapost != 'X' "  #01/08/16 mandy
      END IF
      IF tm.w='Y' THEN
          LET g_sql = g_sql CLIPPED," AND ogaconf = 'Y' "
      ELSE
          LET g_sql = g_sql CLIPPED," AND ogaconf != 'X' "
      END IF
   END IF
END FUNCTION
 
FUNCTION axsr400()
   DEFINE l_name    LIKE type_file.chr20,  # External(Disk) file name       #No.FUN-680130 VARCHAR(20)         
          l_osa05   LIKE osa_file.osa05,
          l_azp01   LIKE azp_file.azp01,
          l_azp03   LIKE azp_file.azp03,
          l_date1   LIKE type_file.dat,    #No.FUN-680130 DATE
          l_date2   LIKE type_file.dat,    #No.FUN-680130 DATE
          l_i,l_j   LIKE type_file.num10,  #No.FUN-680130 INTEGER
          l_buf     LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(3000)
          l_buf_tmp LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(3000)
          l_str1,l_str2 LIKE type_file.chr1000,   #CHI-870001
          l_sql     LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(3000)
   DEFINE l_date01     VARCHAR(10),
          l_date02     VARCHAR(10),
          l_date03     VARCHAR(10),
          l_date04     VARCHAR(10)
 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
     CALL s_azn01(tm.y1,tm.m1b) RETURNING b_date1,l_date1
     CALL s_azn01(tm.y1,tm.m1e) RETURNING l_date2,e_date1
     CALL s_azn01(tm.y2,tm.m2b) RETURNING b_date2,l_date1
     CALL s_azn01(tm.y2,tm.m2e) RETURNING l_date2,e_date2
     CALL s_azn01(tm.y3,tm.m3b) RETURNING b_date3,l_date1
     CALL s_azn01(tm.y3,tm.m3e) RETURNING l_date2,e_date3
     CALL s_azn01(tm.y4,tm.m4b) RETURNING b_date4,l_date1
     CALL s_azn01(tm.y4,tm.m4e) RETURNING l_date2,e_date4
 
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740015 *** ##
 
    CALL cl_del_data(l_table)
 
# ------------------------------------------------------ CR (2) ------- ##
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740015 add ###
 
     LET l_sql ="SELECT azp01,azp03 FROM azp_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND azp01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01='",g_user,"') ",   #MOD-950018
                "   AND azp053 != 'N' " #no.7431
     PREPARE azp_pr FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('azp_pr',STATUS,0) END IF
     DECLARE azp_cur CURSOR FOR azp_pr
 
     LET g_pageno = 0
     LET g_total1=0
     LET g_total2=0
     LET g_total3=0
     LET g_total4=0
     FOREACH azp_cur INTO l_azp01,l_azp03
         IF STATUS THEN CALL cl_err('azp_cur',STATUS,0) EXIT FOREACH END IF
         #---------------------------- 第一期 ---------------------------
  #       CALL r400_g_sql(l_azp03,tm.b1,tm.y1,tm.m1b,tm.m1e,b_date1,e_date1)  #FUN-A10098
         CALL r400_g_sql(l_azp01,tm.b1,tm.y1,tm.m1b,tm.m1e,b_date1,e_date1)  #FUN-A10098
         FOR i=1 TO 2
          IF tm.b1 !='3' AND i=2 THEN EXIT FOR END IF
          IF tm.b1 ='3' AND i=2  THEN
             LET l_buf = l_buf_tmp
             LET l_str1 = "   AND oga09 IN ('2','3','4','6','8','A')   AND (oga65 != 'Y' OR oga09 = '8')" #CHI-950025 add 6 #CHI-A60005 add 'A'
             LET l_str2 = "   AND 1=1 "
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf 
             LET l_str1 = "   AND oga00 <> 'A' "   #MOD-980231
             LET l_str2 = "   AND 1=1 "   #MOD-980231
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf    #MOD-980231
             CALL cl_replace_str(l_buf,"oga","oha") RETURNING l_buf
             CALL cl_replace_str(l_buf,"ogb","ohb") RETURNING l_buf
             LET g_sql = l_buf
          END IF
          IF tm.b1 = '3' AND i = 1 THEN
             LET l_buf_tmp = g_sql
             LET g_sql = g_sql CLIPPED," AND oga00 NOT IN ('3','7') "    #No.MOD-950210 add
          END IF
          CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING  g_sql   #FUN-A10098
          PREPARE r400_p1 FROM g_sql
          DECLARE r400_c1 CURSOR FOR r400_p1
          FOREACH r400_c1 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #1',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
              IF tm.b1='2' OR tm.b1='4' THEN   #訂單/出貨目標
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt2 END IF
              ELSE
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt1*sr.oea24 END IF  #本幣
              END IF
              #退貨
              IF tm.b1='3' AND i=2 THEN LET sr.amt1 = sr.amt1 * -1 END IF
              LET sr.amt2=0
              IF cl_null(sr.amt1) THEN LET sr.amt1=0 END IF
              LET g_total1=g_total1+sr.amt1
              LET sr.azp01=l_azp01
              CALL r400_case()
              CALL r400_m(sr.oea23)
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.order2,sr.order3,sr.order4,sr.gem02,
         sr.gen02, sr.oab02, sr.oea26, sr.oea032,sr.oca02,
         sr.oea04, sr.oea23, sr.oea24, sr.amt1,  sr.amt2,
         sr.amt3 , sr.amt4 , sr.oeb04, sr.oea15, sr.oea14,
         sr.oea25, sr.oea03, sr.oca01, sr.ima131,sr.ima06,
         sr.azp01, l_oab02 , l_occ02 , l_occ20 , l_occ21 ,
         l_occ22 , l_azi05
        ,sr.ima09,sr.ima10,sr.ima11 #FUN-B90090 add 
       #------------------------------ CR (3) ------------------------------#
 
          END FOREACH
         END FOR
         #---------------------------- 第二期 ---------------------------
      #   CALL r400_g_sql(l_azp03,tm.b2,tm.y2,tm.m2b,tm.m2e,b_date2,e_date2)  #FUN-A10098
         CALL r400_g_sql(l_azp01,tm.b2,tm.y2,tm.m2b,tm.m2e,b_date2,e_date2)  #FUN-A10098
         FOR i=1 TO 2
          IF tm.b2 !='3' AND i=2 THEN EXIT FOR END IF
          IF tm.b2 ='3' AND i=2  THEN
             LET l_buf = l_buf_tmp
             LET l_str1 = "   AND oga09 IN ('2','3','4','6','8','A')   AND (oga65 != 'Y' OR oga09 = '8')" #CHI-950025 add 6 #CHI-A60005 add 'A'
             LET l_str2 = "   AND 1=1 "
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf 
             LET l_str1 = "   AND oga00 <> 'A' "   #MOD-980231
             LET l_str2 = "   AND 1=1 "   #MOD-980231
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf    #MOD-980231
             CALL cl_replace_str(l_buf,"oga","oha") RETURNING l_buf
             CALL cl_replace_str(l_buf,"ogb","ohb") RETURNING l_buf
             LET g_sql = l_buf
          END IF
          IF tm.b2 = '3' AND i = 1 THEN
             LET l_buf_tmp = g_sql
             LET g_sql = g_sql CLIPPED," AND oga00 NOT IN ('3','7') "    #No.MOD-950210 add
          END IF
          CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING  g_sql   #FUN-A10098
          PREPARE r400_p2 FROM g_sql
          DECLARE r400_c2 CURSOR FOR r400_p2
          FOREACH r400_c2 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #2',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
              IF tm.b2='2' OR tm.b2='4' THEN   #訂單/出貨目標
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt2 END IF
              ELSE
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt1*sr.oea24 END IF  #本幣
              END IF
              #退貨
              IF tm.b2='3' AND i=2 THEN LET sr.amt1 = sr.amt1 * -1 END IF
              LET sr.amt2=sr.amt1 LET sr.amt1=0
              IF cl_null(sr.amt2) THEN LET sr.amt2=0 END IF
              LET g_total2=g_total2+sr.amt2
              LET sr.azp01=l_azp01
              CALL r400_case()
              CALL r400_m(sr.oea23)
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.order2,sr.order3,sr.order4,sr.gem02,
         sr.gen02, sr.oab02, sr.oea26, sr.oea032,sr.oca02,
         sr.oea04, sr.oea23, sr.oea24, sr.amt1,  sr.amt2,
         sr.amt3 , sr.amt4 , sr.oeb04, sr.oea15, sr.oea14,
         sr.oea25, sr.oea03, sr.oca01, sr.ima131,sr.ima06,
         sr.azp01, l_oab02 , l_occ02 , l_occ20 , l_occ21 ,
         l_occ22 , l_azi05
        ,sr.ima09,sr.ima10,sr.ima11 #FUN-B90090 add
       #------------------------------ CR (3) ------------------------------#
       #end FUN-740015 add 
 
          END FOREACH
         END FOR
         #---------------------------- 第三期 ---------------------------
  #       CALL r400_g_sql(l_azp03,tm.b3,tm.y3,tm.m3b,tm.m3e,b_date3,e_date3)   #FUN-A10098
         CALL r400_g_sql(l_azp01,tm.b3,tm.y3,tm.m3b,tm.m3e,b_date3,e_date3)   #FUN-A10098
         FOR i=1 TO 2
          IF tm.b3 !='3' AND i=2 THEN EXIT FOR END IF
          IF tm.b3 ='3' AND i=2  THEN
             LET l_buf = l_buf_tmp
             LET l_str1 = "   AND oga09 IN ('2','3','4','6','8','A')   AND (oga65 != 'Y' OR oga09 = '8')" #CHI-950025 add 6 #CHI-A60005 add 'A'
             LET l_str2 = "   AND 1=1 "
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf 
             LET l_str1 = "   AND oga00 <> 'A' "   #MOD-980231
             LET l_str2 = "   AND 1=1 "   #MOD-980231
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf    #MOD-980231
             CALL cl_replace_str(l_buf,"oga","oha") RETURNING l_buf
             CALL cl_replace_str(l_buf,"ogb","ohb") RETURNING l_buf
             LET g_sql = l_buf
          END IF
          IF tm.b3 = '3' AND i = 1 THEN
             LET l_buf_tmp = g_sql
             LET g_sql = g_sql CLIPPED," AND oga00 NOT IN ('3','7') "    #No.MOD-950210 add
          END IF
          CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING  g_sql   #FUN-A10098 
          PREPARE r400_p3 FROM g_sql
          DECLARE r400_c3 CURSOR FOR r400_p3
          FOREACH r400_c3 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #3',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD 
                 EXIT PROGRAM
              END IF
              IF tm.b3='2' OR tm.b3='4' THEN   #訂單/出貨目標
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt2 END IF
              ELSE
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt1*sr.oea24 END IF  #本幣
              END IF
              #退貨
              IF tm.b3='3' AND i=2 THEN LET sr.amt1 = sr.amt1 * -1 END IF
              LET sr.amt3=sr.amt1 LET sr.amt1=0
              LET sr.amt2 = 0   #MOD-740041 add
              IF cl_null(sr.amt3) THEN LET sr.amt3=0 END IF
              LET g_total3=g_total3+sr.amt3
              LET sr.azp01=l_azp01
              CALL r400_case()
              CALL r400_m(sr.oea23)
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.order2,sr.order3,sr.order4,sr.gem02,
         sr.gen02, sr.oab02, sr.oea26, sr.oea032,sr.oca02,
         sr.oea04, sr.oea23, sr.oea24, sr.amt1,  sr.amt2,
         sr.amt3 , sr.amt4 , sr.oeb04, sr.oea15, sr.oea14,
         sr.oea25, sr.oea03, sr.oca01, sr.ima131,sr.ima06,
         sr.azp01, l_oab02 , l_occ02 , l_occ20 , l_occ21 ,
         l_occ22 , l_azi05
        ,sr.ima09,sr.ima10,sr.ima11 #FUN-B90090 add         
       #------------------------------ CR (3) ------------------------------#
 
          END FOREACH
         END FOR
         #---------------------------- 第四期 ---------------------------
      #   CALL r400_g_sql(l_azp03,tm.b4,tm.y4,tm.m4b,tm.m4e,b_date4,e_date4)   #FUN-A10098
         CALL r400_g_sql(l_azp01,tm.b4,tm.y4,tm.m4b,tm.m4e,b_date4,e_date4)   #FUN-A10098
         FOR i=1 TO 2
          IF tm.b4 !='3' AND i=2 THEN EXIT FOR END IF
          IF tm.b4 ='3' AND i=2  THEN
             LET l_buf = l_buf_tmp
             LET l_str1 = "   AND oga09 IN ('2','3','4','6','8','A')   AND (oga65 != 'Y' OR oga09 = '8')" #CHI-950025 add 6 #CHI-A60005 add 'A'
             LET l_str2 = "   AND 1=1 "
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf 
             LET l_str1 = "   AND oga00 <> 'A' "   #MOD-980231
             LET l_str2 = "   AND 1=1 "   #MOD-980231
             CALL cl_replace_str(l_buf,l_str1,l_str2) RETURNING l_buf    #MOD-980231
             CALL cl_replace_str(l_buf,"oga","oha") RETURNING l_buf
             CALL cl_replace_str(l_buf,"ogb","ohb") RETURNING l_buf
             LET g_sql = l_buf
          END IF
          IF tm.b4 = '3' AND i = 1 THEN
             LET l_buf_tmp = g_sql
             LET g_sql = g_sql CLIPPED," AND oga00 NOT IN ('3','7') "    #No.MOD-950210 add  
          END IF
          CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING  g_sql   #FUN-A10098
          PREPARE r400_p4 FROM g_sql
          DECLARE r400_c4 CURSOR FOR r400_p4
          FOREACH r400_c4 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #4',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
              IF tm.b4='2' OR tm.b4='4' THEN   #訂單/出貨目標
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt2 END IF
              ELSE
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt1*sr.oea24 END IF  #本幣
              END IF
              #退貨
              IF tm.b4='3' AND i=2 THEN LET sr.amt1 = sr.amt1 * -1 END IF
              LET sr.amt4=sr.amt1 LET sr.amt1=0
              LET sr.amt2 = 0   #MOD-740041 add
              IF cl_null(sr.amt4) THEN LET sr.amt4=0 END IF
              LET g_total4=g_total4+sr.amt4
              LET sr.azp01=l_azp01
              CALL r400_case()
              CALL r400_m(sr.oea23)
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.order2,sr.order3,sr.order4,sr.gem02,
         sr.gen02, sr.oab02, sr.oea26, sr.oea032,sr.oca02,
         sr.oea04, sr.oea23, sr.oea24, sr.amt1,  sr.amt2,
         sr.amt3 , sr.amt4 , sr.oeb04, sr.oea15, sr.oea14,
         sr.oea25, sr.oea03, sr.oca01, sr.ima131,sr.ima06,
         sr.azp01, l_oab02 , l_occ02 , l_occ20 , l_occ21 ,
         l_occ22 , l_azi05
        ,sr.ima09,sr.ima10,sr.ima11 #FUN-B90090 add         
       #------------------------------ CR (3) ------------------------------#
       #end FUN-740015 add 
 
          END FOREACH
         END FOR
     END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'azp01') RETURNING tm.wc
      CALL cl_wcchp(tm.wc2,'oea15,oea14,oea25,oea26,oea03,oca01,oea04,
                           oea23,ima131,ima06,oeb04,occ20,occ21,occ22,
                           oga23,ima131,ima06,ogb04,occ20,occ21,occ22
                          ,ima09,ima10,ima11') #FUN-B90090 add
           RETURNING tm.wc2
      LET g_str = tm.wc,tm.wc
   END IF
 
   LET l_date01 = "(",b_date1 USING "YY","/",b_date1 USING "MM",
                          "-",e_date1 USING "MM",")"
   LET l_date02 = "(",b_date2 USING "YY","/",b_date2 USING "MM",
                          "-",e_date2 USING "MM",")"
   LET l_date03 = "(",b_date3 USING "YY","/",b_date3 USING "MM",
                          "-",e_date3 USING "MM",")"
   LET l_date04 = "(",b_date4 USING "YY","/",b_date4 USING "MM",
                          "-",e_date4 USING "MM",")"
 
   LET g_str = g_str,";",tm.s,";",tm.t,";",tm.u,";",tm.ch,";",
               l_date01,";",l_date02,";",l_date03,";",l_date04,";",tm.a1,";",
               tm.a2,";",tm.a3,";",tm.a4,";",tm.b1,";",tm.b2,";",
               tm.b3,";",tm.b4,";",tm.op
   CALL cl_prt_cs3('axsr400','axsr400',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740015 add 
 
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
FUNCTION r400_m(p_code)
DEFINE p_code  LIKE oea_file.oea23
 
    IF tm.ch=1  THEN#(原幣)
        SELECT azi03,azi04,azi05 INTO l_azi03,t_azi04,t_azi05  #抓幣別取位 
        FROM azi_file
        WHERE azi01=p_code
   ELSE
       LET l_azi03=t_azi03   #(本幣)
       LET l_azi04=t_azi04
       LET l_azi05=t_azi05
   END IF
   IF cl_null(l_azi03) THEN LET l_azi03=0 END IF
   IF cl_null(l_azi04) THEN LET l_azi03=0 END IF
   IF cl_null(l_azi05) THEN LET l_azi03=0 END IF
 
END FUNCTION
 
FUNCTION r400_case()
  DEFINE l_order   ARRAY[5] OF LIKE oeb_file.oeb04,  #No.FUN-680130 VARCHAR(40)  #FUN-5B0105 20->40
         l_occ20   LIKE occ_file.occ20,
         l_occ21   LIKE occ_file.occ21,
         l_occ22   LIKE occ_file.occ22   #FUN-550091
      LET g_order=''
      FOR g_i = 1 TO 4
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azp01
                    LET g_order=g_order CLIPPED,' ',g_x[19] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[19] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea15
                    LET g_order=g_order CLIPPED,' ',g_x[20] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[20] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea14
                    LET g_order=g_order CLIPPED,' ',g_x[21] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[21] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea25
                    LET g_order=g_order CLIPPED,' ',g_x[22] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[22] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oea26
                    LET g_order=g_order CLIPPED,' ',g_x[23] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[23] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oea03
                    LET g_order=g_order CLIPPED,' ',g_x[24] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[24] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oca01
                    LET g_order=g_order CLIPPED,' ',g_x[25] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[25] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oea04
                    LET g_order=g_order CLIPPED,' ',g_x[26] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[26] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oea23
                    LET g_order=g_order CLIPPED,' ',g_x[27] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[27] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.ima131
                    LET g_order=g_order CLIPPED,'   ',g_x[35] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[35] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = 'b' LET l_order[g_i] = sr.ima06
                    LET g_order=g_order CLIPPED,'  ',g_x[36] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[36] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = 'c' LET l_order[g_i] = sr.oeb04
                    LET g_order=g_order CLIPPED,'  ',g_x[37] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[37] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = 'd'
                    SELECT occ20 INTO l_occ20 FROM occ_file
                     WHERE occ01=sr.oea04
                    IF STATUS THEN LET l_occ20='' END IF
                    LET l_order[g_i] = l_occ20
                    LET g_order=g_order CLIPPED,'  ',g_x[38] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[38] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = 'e'
                    SELECT occ21 INTO l_occ21 FROM occ_file
                     WHERE occ01=sr.oea04
                     IF STATUS THEN LET l_occ21='' END IF
                    LET l_order[g_i] = l_occ21
                    LET g_order=g_order CLIPPED,'  ',g_x[39] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[39] CLIPPED   #No.FUN-580013
               WHEN tm.s[g_i,g_i] = 'f'
                    SELECT occ22 INTO l_occ22 FROM occ_file
                     WHERE occ01=sr.oea04
                     IF STATUS THEN LET l_occ22='' END IF
                    LET l_order[g_i] = l_occ22
                    LET g_order=g_order CLIPPED,'  ',g_x[40] CLIPPED
                    LET g_zaa[40+g_i].zaa08 = g_x[40] CLIPPED   #No.FUN-580013
               #FUN-B90090----------add-------str
               WHEN tm.s[g_i,g_i] = 'g' 
                    LET l_order[g_i] = sr.ima09
               WHEN tm.s[g_i,g_i] = 'h' 
                    LET l_order[g_i] = sr.ima10
               WHEN tm.s[g_i,g_i] = 'i' 
                    LET l_order[g_i] = sr.ima11
               #FUN-B90090----------add-------end
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       LET sr.order4 = l_order[4]
END FUNCTION
#FUN-9C0072 精簡程式碼
