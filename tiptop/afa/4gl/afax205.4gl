# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: afax205.4gl
# Descriptions...: 財產目錄 - 財務
# Date & Author..: 89/06/20 By Chien
# Modify.........: No:7593 03/09/03 By Wiky 累折與本期累折金額沒有扣掉銷帳部份
# Modify.........: No:8337 03/09/24 By Wiky ON LAST ROW改GROUP SUM=>SUM
# Modify.........: No.CHI-480001 04/08/11 By Danny 增加資產停用選項/新增大陸版報表段(減值準備)
# Modify.........: No.FUN-510035 05/03/07 By pengu 修改報表單價、金額欄位寬度
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.TQC-620119 06/05/09 By Smapmin 新增追溯功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6A0112 06/11/17 By Claire p_faf02,p_fab02清空
# Modify.........: No.MOD-6B0102 06/11/20 By Claire fap53,faj52若無資料改印faj31,faj29
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 報表格式調整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740333 07/04/23 By Smapmin 已銷帳資產不可印列
# Modify.........: No.FUN-770033 07/08/06 By destiny 報表改為使用crystal report
# Modify.........: No.MOD-780020 07/08/22 By Smapmin 修改累折計算方式
# Modify.........: No.MOD-780025 07/08/23 By Smapmin 修改取得成本與調整成本之計算方式
# Modify.........: No.MOD-7B0109 07/11/13 By Smapmin 取得日期有誤
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-860315 08/07/08 By Sarah 資產於5月報廢,印4月資料,"取得原價"欄位會印出資產報廢後的金額而非4月的金額
# Modify.........: No.MOD-870046 08/07/08 By Sarah 計算累折的WHERE條件增加fan041 IN ('0','1')及fan05 IN ('1','2')
# Modify.........: No.MOD-870101 08/07/17 By Sarah faj141與faj33計算方式調整
# Modify.........: No.CHI-710026 08/12/30 By Sarah
#                  1.預留殘值:若無異動資料則預留殘值改捉faj31,若有折畢再提者,則取折畢後預留殘值
#                  2.折畢再提之期數:若無異動資料則年限改捉faj29
#                  3.本期折舊:應是指本年度累折,抓取本年度此筆資產最大的fan08
#                  4.提供給財政單位的報表,應依類別(faj04)跳頁
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990243 09/09/28 By mike FUNCTION x205_cal(),計算本年度累折時,加上過濾期別的條件     
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No:MOD-A50137 10/05/24 By sabrina "改良或修理"、"本期提列數"金額沒有出來
# Modify.........: No:MOD-B10186 11/01/25 By Dido 若入帳當月未折舊而是次月折舊時累折金額不可為 faj32,應扣除後面發生的折舊金額 
# Modify.........: No:MOD-B10205 11/01/25 By Dido 調整 sr.faj141 邏輯 
# Modify.........: No:MOD-B60063 11/06/09 By Dido 取消盤點盈虧數量計算
# Modify.........: No:CHI-B70033 11/09/26 By johung 需考慮當月有作折舊調整的fan資料
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No:MOD-C10070 12/01/09 By Polly 累折需考慮銷帳成本
# Modify.........: No:MOD-C20217 12/02/29 By Polly 給予l_fap54和l_fap57預設值
# Modify.........: No:FUN-C90088 12/12/18 By Belle  列印年限需有回溯功能
# Modify.........: No:FUN-CC0093 13/03/12 By zhangweib CR報表轉XtraGrid報表
# Modify.........: No.TQC-D40018 13/04/08 By zhangweib 補過到正式區
# Modify.........: No.FUN-D40129 13/05/14 By yangtt 1、faj02,faj04,faj05,faj19,faj20,faj21新增開窗
#                                                   2、報表中添加[報表類型名稱]欄位顯示  
#                                                   3、添加報錯信息             
#                                                   4、去除頁脚2和3顯示 
#                                                   5、添加小數取位欄位
#                                                   6、添加跳頁        
#                                                   7、l_a欄位計算錯誤
                      
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                             #Print condition RECORD     #No.TQC-D40018
            wc     LIKE type_file.chr1000,    #Where condition            #No.FUN-680070 VARCHAR(1000)
            yy1    LIKE type_file.num5,       #No.FUN-680070 SMALLINT
            mm1    LIKE type_file.num5,       #No.FUN-680070 SMALLINT
            c      LIKE type_file.chr1,       #No.CHI-480001              #No.FUN-680070 VARCHAR(1)
            more   LIKE type_file.chr1        #Input more condition(Y/N)  #No.FUN-680070 VARCHAR(1)
           END RECORD,
       g_bdate,g_edate LIKE type_file.dat     #No.FUN-680070 DATE
DEFINE g_fap660    LIKE fap_file.fap66,
       g_fap670    LIKE fap_file.fap67,
       g_fap662    LIKE fap_file.fap66,
       g_fap661    LIKE fap_file.fap661,
       g_fap56     LIKE fap_file.fap56,
       g_fap54     LIKE fap_file.fap54,
       g_fap661_2  LIKE fap_file.fap661,      #MOD-780025
       g_fap53     LIKE fap_file.fap53,
       g_fap52     LIKE fap_file.fap52,
       g_fan07     LIKE fan_file.fan07,
       g_fan15     LIKE fan_file.fan15
DEFINE g_i         LIKE type_file.num5        #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_sql       STRING                     #No.FUN-770033
DEFINE g_str       STRING                     #No.FUN-770033
DEFINE l_table     STRING                     #No.FUN-770033
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   LET g_sql="cost.faj_file.faj101,  faj02.faj_file.faj02,",
             "faj06.faj_file.faj06,  faj141.faj_file.faj141,",
             "faj18.faj_file.faj18,  faj21.faj_file.faj21,",
             "faj29.faj_file.faj29,  faj31.faj_file.faj31,",
             "faj33.faj_file.faj33,  l_faj25.faj_file.faj25,",
             "p_fab02.fab_file.fab02,p_faf02.faf_file.faf02,",
             "tmp01.faj_file.faj17,  tmp02.faj_file.faj14,",
             "tmp03.faj_file.faj203, tmp04.faj_file.faj32,",
             "faj04.faj_file.faj04"   #CHI-710026 add
           #,",a.faj_file.faj17,b.faj_file.faj24,c.faj_file.faj24"    #No.FUN-CC0093  Add   #FUN-D40129 mark
            ,",a.faj_file.faj31,b.faj_file.faj24,c.faj_file.faj24,",    #No.FUN-CC0093   Add  #FUN-D40129 add
             "g_azi04.azi_file.azi04,g_azi05.azi_file.azi05"   #FUN-D40129
   LET l_table = cl_prt_temptable('afax205',g_sql) CLIPPED
   IF l_table= -1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",   #CHI-710026 add ?    #No.FUN-CC0093   Add 3 ?
             "        ?,?) "   #FUN-D40129
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF                                                                                                                           
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.yy1   = ARG_VAL(8)
   LET tm.mm1   = ARG_VAL(9)
   LET tm.c     = ARG_VAL(10)                     #No.CHI-480001
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afax205_tm(0,0)        # Input print condition
      ELSE CALL afax205()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afax205_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,        #No.FUN-580031
          p_row,p_col    LIKE type_file.num5,        #No.FUN-680070 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 13
 
   OPEN WINDOW afax205_w AT p_row,p_col WITH FORM "afa/42f/afax205"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy1   = g_faa.faa07
   LET tm.mm1   = g_faa.faa08
   LET tm.c     = '0'                         #No.CHI-480001
 
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON faj04,faj02,faj19,faj27,faj21,faj05,faj20,faj06,
                              faj14,faj22
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
           WHEN INFIELD(faj22)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_azp"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj22
              NEXT FIELD faj22
          #FUN-D40129---add--str--
           WHEN INFIELD(faj02)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_faj02_1"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj02
              NEXT FIELD faj02
            WHEN INFIELD(faj04)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_faj04_1"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj04
              NEXT FIELD faj04
            WHEN INFIELD(faj05)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_fac"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj05
              NEXT FIELD faj05
            WHEN INFIELD(faj19)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_faj19"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj19
              NEXT FIELD faj19
            WHEN INFIELD(faj20)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_faj20"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj20
              NEXT FIELD faj20
            WHEN INFIELD(faj21)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_faj21"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj21
              NEXT FIELD faj21
          #FUN-D40129---add--end--
        END CASE
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW afax205_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT tm.yy1,tm.mm1,tm.c,tm.more WITHOUT DEFAULTS
     FROM FORMONLY.yy1,FORMONLY.mm1,FORMONLY.c,FORMONLY.more  #end No.CHI-480001
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD yy1
         IF cl_null(tm.yy1) THEN NEXT FIELD FORMONLY.yy1 END IF
         IF tm.yy1> g_faa.faa07  THEN    ##不可大於固定資產年度
            CALL cl_err('','afa-423',0)  #FUN-D40129 add
            NEXT FIELD FORMONLY.yy1
         END IF
 
      AFTER FIELD mm1
         IF NOT cl_null(tm.mm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.mm1 > 12 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            ELSE
               IF tm.mm1 > 13 OR tm.mm1 < 1 THEN
                  NEXT FIELD mm1
               END IF
            END IF
         END IF
         IF cl_null(tm.mm1) THEN NEXT FIELD FORMONLY.mm1 END IF
 
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES "[012]" THEN
            NEXT FIELD FORMONLY.c
       END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW afax205_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='afax205'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('afax205','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.mm1 CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",     #No.CHI-480001
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('afax205',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW afax205_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL afax205()
   ERROR ""
END WHILE
   CLOSE WINDOW afax205_w
END FUNCTION
 
FUNCTION afax205()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680070 VARCHAR(40)
          sr        RECORD
                       faj04  LIKE faj_file.faj04,    # 資產分類
                       faj21  LIKE faj_file.faj21,    # 存放位置
                       faj06  LIKE faj_file.faj06,    # 中文名稱
                       tmp01  LIKE faj_file.faj17,    # 數量(faj17-faj58)
                       faj18  LIKE faj_file.faj18,    # 單位
                       faj25  LIKE faj_file.faj25,    # 取得日期
                       tmp02  LIKE faj_file.faj14,    # 取得原價(faj14-faj59)
                       faj141 LIKE faj_file.faj141,   # 改良或修理
                       faj31  LIKE faj_file.faj31,    # 預留殘值
                       faj29  LIKE faj_file.faj29,    # 耐用年限
                       tmp03  LIKE faj_file.faj203,   # 本期提列數faj203*(faj17-
                       tmp04  LIKE faj_file.faj32,    # 截至本期止累計數faj32*(f
                       faj33  LIKE faj_file.faj33,    # 未折減餘額
                       faj02  LIKE faj_file.faj02,    # 財產編號
                       faj022 LIKE faj_file.faj022,   # 財產附號   #TQC-620119
                       faj101 LIKE faj_file.faj101,   #No.CHI-480001
                       cost   LIKE faj_file.faj101    #No.CHI-480001
                    END RECORD
   DEFINE l_i,l_cnt,i         LIKE type_file.num5     #No.FUN-680070 SMALLINT
   DEFINE l_zaa02             LIKE zaa_file.zaa02
   DEFINE p_fab02  LIKE fab_file.fab02,                                                                                             
          p_faf02  LIKE faf_file.faf02,                                                                                             
          l_faj25  LIKE faj_file.faj25,
          l_faz08  LIKE faz_file.faz08    #MOD-A50137 add
   DEFINE l_fap54  LIKE fap_file.fap54    #MOD-C10070 add
   DEFINE l_fap57  LIKE fap_file.fap57    #MOD-C10070 add
   DEFINE l_fap93  LIKE fap_file.fap93    #FUN-C90088
  #DEFINE l_a      LIKE faj_file.faj17   #No.FUN-CC0093   Add   #FUN-D40129 mark
   DEFINE l_a      LIKE faj_file.faj31   #No.FUN-D40129   Add
   #FUN-C90088--B--
   LET l_sql = " SELECT fap93 FROM fap_file"
              ,"  WHERE fap03 ='9'"
              ,"    AND fap02 = ? AND fap021= ? AND fap04 < ?"
              ,"  ORDER BY fap04 desc"
   PREPARE x205_p01 FROM l_sql
   DECLARE x205_c01 SCROLL CURSOR WITH HOLD FOR x205_p01
   #FUN-C90088--E--
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033
   CALL cl_del_data(l_table)                                   #No.FUN-770033

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
 
   CALL s_azn01(tm.yy1,tm.mm1) RETURNING g_bdate,g_edate
   LET l_sql = "SELECT faj04,faj21,faj06,faj17-faj58,faj18,faj25,",
               " faj14-faj59,faj141,faj31,faj29,faj203*(faj17-faj58)/faj17,",
               " faj32*(faj17-faj58)/faj17,faj33,faj02,faj022, ",  #TQC-620119
               " faj101-faj102,0 ",           #end No.CHI-480001
               "  FROM faj_file ",
               " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
               " AND faj17 >0 ",   #除數不為0   #No:7593
               " AND faj26 <='",g_edate,"'"
 
   IF tm.c = '1' THEN    #停用
      #LET l_sql = l_sql CLIPPED," AND faj105 = 'Y' " #No.FUN-B80081 mark
       LET l_sql = l_sql CLIPPED," AND faj43 = 'Z' " #No.FUN-B80081 add  
   END IF
   IF tm.c = '0' THEN    #正常使用
      LET l_sql = l_sql CLIPPED,
                  #" AND (faj105 = 'N' OR faj105 IS NULL OR faj105 = ' ') " #No.FUN-B80081 mark
                   " AND faj43<>'Z' " #No.FUN-B80081 add
   END IF
 
   PREPARE afax205_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE afax205_curs1 CURSOR FOR afax205_prepare1
 
   IF g_aza.aza26 = '2' THEN
      LET l_name='afax205_1'
   ELSE
      LET l_name='afax205'
   END IF
   CALL cl_prt_pos_len()
 
   LET g_pageno = 0
   FOREACH afax205_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT count(*) INTO l_cnt FROM fap_file
       WHERE fap02=sr.faj02 AND fap021=sr.faj022
         AND fap77 IN ('5','6') AND (YEAR(fap04) < tm.yy1  
          OR (YEAR(fap04) = tm.yy1 AND MONTH(fap04) <= tm.mm1))     
      IF l_cnt > 0 THEN CONTINUE FOREACH END IF
 
      #推算至截止日期之資產數量
      LET g_fap660  = 0
      LET g_fap670  = 0
      LET g_fap662  = 0
      LET g_fap661  = 0
      LET g_fap56   = 0
      LET g_fap54   = 0
      LET g_fap661_2= 0   #MOD-780025
      LET g_fap53   = 0
      LET g_fap52   = 0
      LET g_fan07   = 0
      LET g_fan15   = 0
      CALL x205_cal(sr.faj02,sr.faj022)
 
      #數量=(目前數量-銷帳數量)-大於當期(異動值)+大於當期(銷帳)-大於當期(調整)
      LET sr.tmp01 = sr.tmp01 - g_fap660 + g_fap670 - g_fap662
 
      #取得原價
     #LET sr.tmp02 = sr.tmp02 - g_fap661 + g_fap56   #MOD-780025
      LET sr.tmp02 = sr.tmp02 + g_fap56   #MOD-780025  #MOD-860315 mod
 
      #調整成本 = 目前調整成本 - 大於當期改良,重估,調整成本
     #LET sr.faj141 = g_fap54   #MOD-780025
     #MOD-A50137---modify---start---
     #LET sr.faj141 = g_fap54 + g_fap661_2  #MOD-780025
      LET sr.faj141 = sr.faj141 - g_fap54 - g_fap661_2  #MOD-B10205 
     #-MOD-B10205-mark-
     #SELECT SUM(faz08) INTO l_faz08 FROM faz_file,fay_file
     # WHERE faz03=sr.faj02 AND fay01 = faz01
     #   AND fay02 > g_edate
     #IF cl_null(l_faz08) THEN LET l_faz08 = 0 END IF
     #IF l_faz08 > 0 THEN
     #   LET sr.faj141 = sr.faj141 - l_faz08
     #END IF
     #-MOD-B10205-end-
     #MOD-A50137---modify---end-- 
 
      #預留殘值
      IF g_fap53 > 0 THEN            #MOD-6B0102 add
         LET sr.faj31 = g_fap53
      END IF                         #MOD-6B0102 add
 
      #耐用年限
      IF g_fap52 > 0 THEN            #MOD-6B0102 add
         LET sr.faj29 = g_fap52
      END IF                         #MOD-6B0102 add

     #-----------------------------------------------------MOD-C10070------------------------------------start
      LET l_fap54 = 0                                     #MOD-C20217 add
      SELECT fap54 INTO l_fap54
        FROM fap_file
       WHERE fap03 IN ('4','5','6')
         AND fap02 = sr.faj02
         AND fap021 = sr.faj022
         AND fap04 BETWEEN g_bdate AND g_edate
       ORDER BY fap04 DESC
      IF cl_null(l_fap54) THEN LET l_fap54 = 0 END IF     #MOD-C20217 add

       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM fan_file
        WHERE fan01 = sr.faj02
          AND fan02 = sr.faj022
          AND fan03 = tm.yy1
          AND fan04 = tm.mm1
          AND fan041 IN ('0','1')
          AND fan05 IN ('1','2')

       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       IF l_cnt > 0 THEN
          LET l_fap57 = 0                                  #MOD-C20217 add
          SELECT SUM(fap57) INTO l_fap57
            FROM fap_file
           WHERE fap03 IN ('4','5','6')
             AND fap02 = sr.faj02
             AND fap021 = sr.faj022
             AND fap04 BETWEEN g_bdate AND g_edate
          IF cl_null(l_fap57) THEN LET l_fap57 = 0 END IF  #MOD-C20217 add
       END IF
      #本月尚未折舊時,抓取此財產之前的銷貨累折
       IF l_cnt = 0 THEN
          LET l_fap57 = 0                                  #MOD-C20217 add
          SELECT SUM(fap57) INTO l_fap57
            FROM fap_file
           WHERE fap03 IN ('4','5','6')
             AND fap02 = sr.faj02
             AND fap021 = sr.faj022
             AND fap04 < g_bdate
          IF cl_null(l_fap57) THEN LET l_fap57 = 0 END IF  #MOD-C20217 add
       END IF
     #-----------------------------------------------------MOD-C10070--------------------------------------end
 
      #未折減餘額
     #LET sr.faj33 = sr.tmp02 - g_fan15 + sr.faj141            #MOD-780025 #MOD-870101 #MOD-C10070 mark
      LET sr.faj33 = sr.tmp02 - (g_fan15-l_fap54) + sr.faj141  #MOD-C10070 add
 
      #本期折舊
     #LET sr.tmp03 = g_fan07                         #MOD-C10070 mark
      LET sr.tmp03 = g_fan07 - l_fap54               #MOD-C10070 add
 
      #累折
     #LET sr.tmp04 = g_fan15                         #MOD-C10070 mark
      LET sr.tmp04 = g_fan15 - l_fap57               #MOD-C10070 add
 
      LET p_fab02=' '                                                                                            
      SELECT fab02 INTO p_fab02 FROM fab_file                                                                                       
       WHERE fab01 = sr.faj04                                                                                                       
      IF cl_null(p_fab02) THEN                                                                                                      
         LET p_fab02 = sr.faj04                                                                                                     
      END IF                                                                                                                        
      LET p_faf02=' '                                                                                            
      SELECT faf02 INTO p_faf02 FROM faf_file                                                                                       
       WHERE faf01 = sr.faj21                                                                                                       
      IF cl_null(p_faf02) THEN                                                                                                      
         LET p_faf02 = sr.faj21                                                                                                     
      END IF
 
      IF sr.tmp01 = 0 THEN
         LET sr.tmp04 = 0  #No:7593
         LET sr.faj33 = 0
         LET sr.faj101 = 0        
      END IF
      IF cl_null(sr.faj101) THEN LET sr.faj101 = 0 END IF
      LET sr.cost = sr.faj33 - sr.faj101
      LET l_faj25 = sr.faj25   #MOD-7B0109 
 
      #FUN-C90088--B--
      #耐用年限回溯
      LET l_fap93 = ""
      OPEN x205_c01 USING sr.faj02 ,sr.faj022,g_edate
      FETCH FIRST x205_c01 INTO l_fap93
      IF NOT cl_null(l_fap93) THEN LET sr.faj29 = l_fap93 END IF    
      #FUN-C90088--E--
 
     #LET l_a = sr.tmp02+sr.faj31+sr.faj141   #FUN-D40129 mark
      LET l_a = sr.tmp02-sr.faj31+sr.faj141   #FUN-D40129 add
      EXECUTE insert_prep USING
         sr.cost, sr.faj02,sr.faj06,sr.faj141,sr.faj18,
         sr.faj21,sr.faj29,sr.faj31,sr.faj33, l_faj25,
         p_fab02, p_faf02, sr.tmp01,sr.tmp02, sr.tmp03,
         sr.tmp04,sr.faj04   #CHI-710026 add sr.faj04
        ,l_a,' ',' '    #No.FUN-CC0093   Add
         ,g_azi04,g_azi05   #FUN-D40129
   END FOREACH
 
###XtraGrid###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(tm.wc,'faj04,faj02,faj19,faj27,faj21,faj05,faj20,faj06')                                                                   
           RETURNING tm.wc                                                                                                              
      LET g_str = tm.wc                                                                                          
   END IF                                                                                                                         
###XtraGrid###   LET g_str = g_str,";",tm.yy1,";",tm.mm1,";",g_azi04,";",g_azi05                                                                                                               
###XtraGrid###   CALL cl_prt_cs3('afax205',l_name,g_sql,g_str) 
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.order_field = 'faj04,l_faj25'
    IF g_aza.aza26 = '2' THEN
       LET g_xgrid.template = 'afax205_1'
    ELSE
       LET g_xgrid.template = 'afax205'
    END IF
    LET g_xgrid.footerinfo1 = cl_getmsg('afa-209',g_lang) 
   #LET g_xgrid.footerinfo2 = cl_getmsg('afa-211',g_lang),p_fab02   #FUN-D40129 mark 
   #LET g_xgrid.footerinfo3 = cl_getmsg('afa-212',g_lang),p_faf02   #FUN-D40129 mark
    CALL cl_xg_view()    ###XtraGrid###
END FUNCTION

FUNCTION x205_cal(l_faj02,l_faj022)
   DEFINE l_faj02       LIKE faj_file.faj02
   DEFINE l_faj022      LIKE faj_file.faj022
   DEFINE l_fan03       LIKE fan_file.fan03    #No.FUN-680070 VARCHAR(4)
   DEFINE l_fan04       LIKE fan_file.fan04    #No.FUN-680070 VARCHAR(2)
   DEFINE l_fan03_fan04 LIKE type_file.chr6    #No.FUN-680070 VARCHAR(6)
   DEFINE l_fan07       LIKE fan_file.fan07    #MOD-B10186
   DEFINE l_fan10       LIKE fan_file.fan10    #CHI-710026 add
   DEFINE l_sql         STRING
   #CHI-B70033 -- begin --
   DEFINE l_cnt         LIKE type_file.num5,
          l_adj_fan07   LIKE fan_file.fan07,
          l_curr_fan07  LIKE fan_file.fan07,
          l_pre_fan15   LIKE fan_file.fan15
   #CHI-B70033 -- end --
  
   #----盤點、出售、報廢、銷帳(數量)
   SELECT SUM(fap66),SUM(fap67) INTO g_fap660,g_fap670
     FROM fap_file
   #WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02   #No:MOD-540112 #MOD-B60063 mark
    WHERE fap03 IN ('4','5','6') AND fap02=l_faj02       #MOD-B60063
      AND fap021=l_faj022 AND fap04 > g_edate
   IF cl_null(g_fap660) THEN LET g_fap660=0  END IF
   IF cl_null(g_fap670) THEN LET g_fap670=0  END IF
 
   #----調整(數量)
   SELECT SUM(fap66) INTO g_fap662 FROM fap_file
    WHERE fap03 IN ('9') AND fap02=l_faj02
      AND fap021=l_faj022 AND fap04 > g_edate
   IF cl_null(g_fap662) THEN LET g_fap662=0  END IF
 
   #----取得原價
   SELECT SUM(fap661),SUM(fap56) INTO g_fap661,g_fap56 FROM fap_file
    WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
      AND fap021=l_faj022 AND fap04 > g_edate
   IF cl_null(g_fap661) THEN LET g_fap661=0  END IF
   IF cl_null(g_fap56) THEN LET g_fap56=0  END IF
 
   #----調整成本
  #SELECT fap54 INTO g_fap54 FROM fap_file        #MOD-870101 mark
   SELECT SUM(fap54) INTO g_fap54 FROM fap_file   #MOD-870101
    WHERE fap03 IN ('7','8') AND fap02=l_faj02    #MOD-B10205 add 8
     #AND fap021=l_faj022 AND fap04 <= g_edate    #MOD-B10205 mark
      AND fap021=l_faj022 AND fap04 > g_edate     #MOD-B10205
   IF cl_null(g_fap54) THEN LET g_fap54=0  END IF
 
   SELECT fap661 INTO g_fap661_2 FROM fap_file
    WHERE fap03 IN ('9') AND fap02=l_faj02
     #AND fap021=l_faj022 AND fap04 <= g_edate                   #MOD-B10205 mark
      AND fap021=l_faj022 AND fap04 > g_edate                    #MOD-B10205
      AND fap04 IN (SELECT MAX(fap04) FROM fap_file
                     WHERE fap03 IN ('9') AND fap02=l_faj02
                      #AND fap021=l_faj022 AND fap04 <= g_edate) #MOD-B10205 mark
                       AND fap021=l_faj022 AND fap04 > g_edate)  #MOD-B10205
   IF cl_null(g_fap661_2) THEN LET g_fap661_2=0  END IF
 
   #----預留殘值
   SELECT fap53 INTO g_fap53 FROM fap_file
    WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
      AND fap021=l_faj022  AND fap04 <= g_edate
      AND fap04 IN (SELECT MAX(fap04) FROM fap_file
                     WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
                       AND fap021=l_faj022 AND fap04 <= g_edate)
   IF cl_null(g_fap53) THEN LET g_fap53=0  END IF
  #若無異動資料則預留殘值改捉faj31
   IF g_fap53 = 0 THEN
      SELECT faj31 INTO g_fap53 FROM faj_file 
       WHERE faj02=l_faj02 AND faj022=l_faj022
   END IF
  #若有折畢再提者,則取折畢後預留殘值
   SELECT fan10 INTO l_fan10 FROM fan_file
    WHERE fan01=l_faj02 AND fan02=l_faj022
      AND (fan05='1' OR fan05='0')
      AND fan03*100+fan04 IN 
    (SELECT MAX(fan03*100+fan04) FROM fan_file
      WHERE fan01=l_faj02 AND fan02=l_faj022
      AND ((fan03 = tm.yy1 AND fan04 <= tm.mm1) OR
            fan03 < tm.yy1) AND (fan05='1' OR fan05='0') )
   IF l_fan10='7' THEN   #折畢再提
      SELECT faj35 INTO g_fap53 FROM faj_file 
       WHERE faj02=l_faj02  AND faj022=l_faj022
      IF cl_null(g_fap53) THEN LET g_fap53=0 END IF
   END IF
 
   #----耐用年限
   SELECT fap52 INTO g_fap52 FROM fap_file
    WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
      AND fap021=l_faj022 AND fap04 <= g_edate
      AND fap04 IN (SELECT MAX(fap04) FROM fap_file
                     WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
                       AND fap021=l_faj022 AND fap04 <= g_edate)
   IF STATUS THEN
      SELECT fap07 INTO g_fap52 FROM fap_file
       WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
         AND fap021=l_faj022 AND fap04 > g_edate
         AND fap04 IN (SELECT MIN(fap04) FROM fap_file
                        WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
                          AND fap021=l_faj022 AND fap04 > g_edate)
      #若無異動資料則年限改捉faj29
      IF STATUS THEN
         SELECT faj29 INTO g_fap52 FROM faj_file 
          WHERE faj02=l_faj02  AND faj022=l_faj022
      END IF
   END IF
   IF cl_null(g_fap52) THEN LET g_fap52=0  END IF

  ##-----本年度累折
   SELECT MAX(fan08) INTO g_fan07 FROM fan_file
    WHERE fan01=l_faj02 AND fan02=l_faj022
      AND fan03 = tm.yy1
      AND fan04<= tm.mm1 #MOD-990243           
      AND (fan05 = '1' OR fan05 = '2')
   IF cl_null(g_fan07) THEN LET g_fan07 = 0 END IF
 
   #-----累折
   SELECT fan15 INTO g_fan15 FROM fan_file
    WHERE fan01=l_faj02 AND fan02=l_faj022
      AND ((fan03=tm.yy1 AND fan04<=tm.mm1) OR fan03<tm.yy1)
      AND fan03*100+fan04 IN
          (SELECT MAX(fan03*100+fan04) FROM fan_file
            WHERE fan01=l_faj02 AND fan02=l_faj022
              AND ((fan03=tm.yy1 AND fan04<=tm.mm1) OR fan03<tm.yy1))
      AND fan041 IN ('0','1')  #MOD-870046 add
      AND fan05 IN ('1','2')   #MOD-870046 add
   IF cl_null(g_fan15) OR g_fan15=0 THEN
    #CHI-B70033 -- mark begin --
    # SELECT faj32 INTO g_fan15 FROM faj_file
    #  WHERE faj02=l_faj02 AND faj022=l_faj022
    ##-MOD-B10186-add-
    # SELECT SUM(fan07) INTO l_fan07
    #   FROM fan_file
    #  WHERE fan01 = l_faj02 
    #    AND fan02 = l_faj022
    #    AND ((fan03 > tm.yy1) OR (fan03 = tm.yy1 AND fan04 > tm.mm1)) 
    # IF cl_null(l_fan07) THEN LET l_fan07 = 0 END IF
    # LET g_fan15 = g_fan15 - l_fan07
    # IF g_fan15 < 0 THEN LET g_fan15 = 0 END IF
    ##-MOD-B10186-end-
    #CHI-B70033 - mark end --
      #CHI-B70033 -- begin --
      SELECT fan15 INTO g_fan15 FROM fan_file
       WHERE fan01 = l_faj02 AND fan02 = l_faj022
         AND fan041 = '1'
         AND fan03 || fan04 IN (
             SELECT MAX(fan03) || MAX(fan04) FROM fan_File
              WHERE fan01 = l_faj02 AND fan02 = l_faj022
                AND ((fan03 < tm.yy1) OR (fan03 = tm.yy1 AND fan04 < tm.mm1))
                AND fan041 = '1')
      #CHI-B70033 -- end --
   END IF
   IF cl_null(g_fan15) THEN LET g_fan15 = 0 END IF

   #CHI-B70033 -- begin --
   LET l_cnt = 0
   LET l_adj_fan07 = 0
   SELECT COUNT(*) INTO l_cnt FROM fan_file
    WHERE fan01 = l_faj02 AND fan02 = l_faj022
      AND fan03 = tm.yy1
      AND fan04 = tm.mm1
      AND fan041 = '1'

   SELECT fan07 INTO l_adj_fan07 FROM fan_File
    WHERE fan01 = l_faj02 AND fan02 = l_faj022
      AND fan03 = tm.yy1
      AND fan04 = tm.mm1
      AND fan041 = '2'
   IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF

   IF l_cnt > 0 THEN
      IF g_aza.aza26 <> '2' THEN
         LET l_adj_fan07 = 0
      ELSE
         #大陸版有可能先折舊再調整
         SELECT fan15 INTO l_pre_fan15 FROM fan_file
          WHERE fan01 = l_faj02 AND fan02 = l_faj022
            AND fan041 = '1'
            AND fan03 || fan04 IN (
                  SELECT MAX(fan03) || MAX(fan04) FROM fan_File
                   WHERE fan01 = l_faj02 AND fan02 = l_faj022
                     AND ((fan03 < tm.yy1) OR (fan03 = tm.yy1 AND fan04 < tm.mm1))
                     AND fan041 = '1')

         SELECT fan07 INTO l_curr_fan07 FROM fan_file
          WHERE fan01 = l_faj02 AND fan02 = l_faj022
            AND fan03 = tm.yy1 AND fan04 = tm.mm1
            AND fan041 = '1'
         IF cl_null(l_curr_fan07) THEN LET l_curr_fan07 = 0 END IF

         IF g_fan15 = (l_pre_fan15 + l_curr_fan07 + l_adj_fan07) THEN
            LET l_adj_fan07 = 0
         END IF
      END IF
   END IF
   LEt g_fan15 = g_fan15 + l_adj_fan07
   LET g_fan07 = g_fan07 + l_adj_fan07
   #CHI-B70033 -- end --

END FUNCTION
#No.FUN-9C0077 程式精簡


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
