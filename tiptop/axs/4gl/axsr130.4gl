# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: axsr130.4gl
# Descriptions...: 銷貨統計表
# Date & Author..: 95/05/22 By Danny
# Modify.........: 95/07/14 By Danny (將數量、金額之','拿掉)
# Modify.........: No:8029 03/11/04 Melody ogb01 改為 oayslip
# Modify.........: No:9457 04/04/14 Melody 組SQL時應該將
#                : oca_file 改為 ,UNION 應改為 UNION ALL
# Modify.........: No.FUN-520029 05/03/07 By kim 報表轉XML功能
# Modify.........: No.MOD-530211 05/03/23 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550072 05/05/23 By Will 單據編號放大
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 新增地區欄位
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-580013 05/08/12 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.MOD-5A0081 05/10/07 By Nicola SQL語法錯誤
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.MOD-630037 06/03/09 By Mandy 執行時若有選到產品編號為排序項目時,則列印出來的料號會被截位!
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0095 06/11/14 By xumin l_sql定義長度過短及報表寬度不符問題修改
# Modify.........: No.TQC-6C0119 06/12/20 By Ray 1.表頭調整
#                                                2.增加check數量單位是否存在于gfe_file及是否有效
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740015 07/04/11 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.MOD-760046 07/06/11 By Carol INPUT順序調整
# Modify.........: No.MOD-760131 07/07/04 By Carol 銷貨成本計算時應以數量*ccc23*數量單位與庫存單位的轉換率
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.MOD-790084 07/09/17 By Pengu SELECT ccc23 INTO sr.ccc23時，沒有考慮到資料庫別
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.TQC-870002 08/07/01 By lumx  修改替換字符的寫法 避免在UTF8下程序down出
# Modify.........: No.MOD-860111 08/07/21 By liuxqa 修改sql條件，參照axsr120的寫法
# Modify.........: No.CHI-870001 08/07/22 By Smapmin 走出貨簽收流程,未簽收前不可納入銷貨收入
# Modify.........: No.CHI-870039 08/07/24 By xiaofeizhu 抓oga_file資料時，排除oga00=A的資料
# Modify.........: No.MOD-8B0193 08/11/19 By clover 銷退部分排除 oha09 = '2' 部分
# Modify.........: No.MOD-8C0025 08/12/04 By Pengu 執行第二次,報表期間會抓到第一次的期間
# Modify.........: No.MOD-890225 08/12/22 By Pengu 應排除非成本倉資料
# Modify.........: No.MOD-950018 09/05/05 By Smapmin 營運中心欄位應加上營運中心使用權限判斷
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990045 09/09/11 By Smapmin 當選擇本幣時,order4要是本國幣
# Modify.........: No.FUN-980059 09/09/11 By arman GP5.2架構,修改SUB傳入參數
# Modify.........: No.FUN-9A0100 09/10/30 By liuxqa 标准SQL修改。
# Modify.........: No.CHI-9C0025 09/12/22 By jan 畫面新增type欄位
# Modify.........: No.FUN-9C0072 10/01/08 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/21 By jan 跨DB的寫法改寫
# Modify.........: No.TQC-A50147 10/05/25 By Carrier main结构调整 & FUN-830159 追单
# Modify.........: No:CHI-A60005 10/06/22 By Summer 條件式有oga09就加上'A'的類別
# Modify.........: No:MOD-A80104 10/08/12 By Smapmin 加上是否列印樣品銷售的選項 
# Modify.........: No:MOD-A80203 10/08/31 By Smapmin 要納入oga00='2'|oha09='2'的資料
# Modify.........: No:FUN-AB0100 10/11/24 By rainy 修正FUN-980059錯誤
# Modify.........: No:MOD-B30619 11/03/30 By Summer 多倉儲批狀況未考慮ogc_file資料
# Modify.........: No.FUN-B80059 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90090 11/09/14 By Sakura QBE及排序增加其他分群碼一二三	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-C20219 12/02/29 By Vampire 列印資料是選擇原幣，但銷貨成本卻是顯示本幣
# Modify.........: No.MOD-CC0213 13/01/28 By Elise 因ccc23本月平均單價表示本幣,請mark掉MOD-C20219,再調整
# Modify.........: No.MOD-C80259 13/02/04 By Elise 抓ogc的地方原抓ogb13*ogc12改抓ogb14/ogb12*ogc12
# Modify.........: No.MOD-D30276 13/04/01 By Elise tm.wc,tm.wc2型態調整為STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_sql	      string                       #No.FUN-580092 HCN
   DEFINE tm  RECORD                               # Print condition RECORD
             #wc      LIKE type_file.chr1000,      # Where condition #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark 
              wc      STRING,                      #MOD-D30276 
             #wc2     LIKE type_file.chr1000,      # Where condition #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark
              wc2     STRING,                      #MOD-D30276
              s       LIKE type_file.chr4,         #No.FUN-680130 VARCHAR(4)
              t       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              u       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              unit    LIKE ima_file.ima25,         #No.FUN-680130 VARCHAR(4)
              y1      LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m1b,m1e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              ch      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              y       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              z       LIKE type_file.chr1,         #MOD-A80104
              type    LIKE type_file.chr1,         #CHI-9C0025
              more    LIKE type_file.chr1          # Input more condition(Y/N)  #No.FUN-680130 VARCHAR(1)
              END RECORD,
          g_order           LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(60)
          g_buf             LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(10)
          g_str1,g_str2     LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(08)
          g_str3,g_str4     LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(20)
          b_date,e_date     LIKE type_file.dat,    #No.FUN-680130 DATE
          l_azi03           LIKE azi_file.azi03,   #
          l_azi04           LIKE azi_file.azi04,   #
          l_azi05           LIKE azi_file.azi05,   #
          g_inqty           LIKE ogb_file.ogb12,   #MOD-530211
          g_inamt           LIKE ogb_file.ogb14,   #MOD-530211
          g_ouqty           LIKE ogb_file.ogb12,   #MOD-530211
          g_ouamt           LIKE ogb_file.ogb14,   #MOD-530211
          g_neqty           LIKE ogb_file.ogb12,   #MOD-530211
          g_neamt           LIKE ogb_file.ogb14,   #MOD-530211
          g_ccamt           LIKE ogb_file.ogb14,   #MOD-530211
          g_ppamt           LIKE ogb_file.ogb14    #MOD-530211
 
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose     #No.FUN-680130 SMALLINT
DEFINE buf     base.StringBuffer    #TQC-870002
DEFINE   l_table         STRING, #FUN-740015###
         g_str           STRING  #FUN-740015### 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50147  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.wc2  = ARG_VAL(8)
   LET tm.s    = ARG_VAL(9)
   LET tm.t    = ARG_VAL(10)
   LET tm.u    = ARG_VAL(11)
   LET tm.y1   = ARG_VAL(12)
   LET tm.m1b  = ARG_VAL(13)
   LET tm.m1e  = ARG_VAL(14)
   LET tm.ch   = ARG_VAL(15)
   LET tm.unit = ARG_VAL(16)
   LET tm.y    = ARG_VAL(17)
   LET tm.z    = ARG_VAL(18)   #MOD-A80104
   LET tm.type = ARG_VAL(19)  #CHI-9C0025
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
#----------------No.TQC-610090 end

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD #FUN-BB0047 mark
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/11 TSD.liquor *** ##
   LET g_sql  = "order1.oab_file.oab02,",
                "order2.oab_file.oab02,",
                "order3.oab_file.oab02,",
                "order4.oab_file.oab02,",
                "oga23.oga_file.oga23,",
                "oga24.oga_file.oga24,",   #MOD-990045
                "inqty.ogb_file.ogb12,",
                "inamt.ogb_file.ogb14,",
                "ouqty.ogb_file.ogb12,",
                "ouamt.ogb_file.ogb14,",
                "neqty.ogb_file.ogb12,",
                "neamt.ogb_file.ogb14,",
                "ccamt.ogb_file.ogb14,",
                "ppamt.ogb_file.ogb14,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05"
               
   LET l_table = cl_prt_temptable('axsr100',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-780054
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?)"    #MOD-990045
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
 
   DROP TABLE tmp_file
   CREATE TEMP TABLE tmp_file
           (order1    LIKE oab_file.oab02,               
            order2    LIKE oab_file.oab02,               
            order3    LIKE oab_file.oab02,              
            order4    LIKE oab_file.oab02,                 
            oga23     LIKE oga_file.oga23,   
            oga24     LIKE oga_file.oga24,    #MOD-990045
            inqty     LIKE ogb_file.ogb12,         
            inamt     LIKE oeb_file.oeb14,          
            ouqty     LIKE ogb_file.ogb12,              
            ouamt     LIKE oeb_file.oeb14,          
            ccamt     LIKE oeb_file.oeb14,          
            ppamt     LIKE oeb_file.oeb14)     
   #No.TQC-A50147  --End  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axsr130_tm(0,0)        # Input print condition
      ELSE CALL axsr130()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD 
END MAIN
 
FUNCTION axsr130_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680130 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
   DEFINE l_gfeacti    LIKE gfe_file.gfeacti      #No.TQC-6C0119
 
   LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW axsr130_w AT p_row,p_col
     WITH FORM "axs/42f/axsr130" ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #CHI-9C0025
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '26 '
   LET tm.u    = 'Y  '
   LET tm.y1   = YEAR(g_today)
   LET tm.m1b  = MONTH(g_today)
   LET tm.m1e  = MONTH(g_today)
   LET tm.ch   = '2'
   LET tm.y    = 'Y'
   LET tm.z    = 'N'   #MOD-A80104
   LET tm.type = g_ccz.ccz28  #CHI-9C0025
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
         LET INT_FLAG = 0
         CLOSE WINDOW axsr130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         LET tm.wc = "azp01='",g_plant,"'"
      END IF
 
      #CONSTRUCT BY NAME tm.wc2 ON oga15,oga14,oga25,oga26,oga03,oca01,oga04, #FUN-B90090 mark 
      #                            oga23,ima131,ima06,ogb04,occ20,occ21,occ22 #FUN-B90090 mark
#FUN-B90090----------add-------str
      CONSTRUCT BY NAME tm.wc2 ON oga15,oga14,oga25,oga26,oga03,oca01,oga04,
                                  oga23,ima131,ima06,ogb04,occ20,occ21,occ22,
                                  ima09,ima10,ima11

         ON ACTION controlp
            CASE WHEN INFIELD(ima09) #其他分群碼一
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_azf"
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.arg1     = "D"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ima09
                      NEXT FIELD ima09
                 WHEN INFIELD(ima10) #其他分群碼二
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_azf"
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.arg1     = "E"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ima10
                      NEXT FIELD ima10
                 WHEN INFIELD(ima11) #其他分群碼三
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_azf"
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.arg1     = "F"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ima11
                      NEXT FIELD ima11
                 OTHERWISE EXIT CASE
              END CASE
#FUN-B90090----------add-------end
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
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axsr130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.y1,tm.m1b,tm.m1e,tm.type, #CHI-9C0025
                    tm.unit,tm.y,tm.z,tm.ch,tm.more WITHOUT DEFAULTS   #MOD-760046 modify   #MOD-A80104 add tm.z
 
         AFTER FIELD y1
            IF cl_null(tm.y1) THEN
               NEXT FIELD y1
            END IF
 
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
            IF cl_null(tm.m1b) THEN
               NEXT FIELD m1b
            END IF
 
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
            IF cl_null(tm.m1e) THEN
               NEXT FIELD m1e
            END IF
 
         AFTER FIELD ch
            IF cl_null(tm.ch) OR tm.ch NOT MATCHES '[1-2]' THEN
               NEXT FIELD ch
            END IF
 
         AFTER FIELD y
            IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN
               NEXT FIELD y
            END IF

         #-----MOD-A80104---------
         AFTER FIELD z
            IF cl_null(tm.z) OR tm.z NOT MATCHES '[YN]' THEN
               NEXT FIELD z
            END IF
         #-----END MOD-A80104-----
 
         AFTER FIELD unit
            IF NOT cl_null(tm.unit) THEN
               SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = tm.unit
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","gfe_file",tm.unit,"",SQLCA.sqlcode,"","",0)
                  NEXT FIELD unit
               ELSE
                  IF l_gfeacti = 'N' THEN
                     CALL cl_err(tm.unit,'ams-106',0)
                     NEXT FIELD unit
                  END IF
               END IF
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW axsr130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axsr130'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axsr130','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.wc2 CLIPPED,"'",               #No.TQC-610090 add
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",          #No.TQC-610090 add
                        " '",tm.u CLIPPED,"'",          #No.TQC-610090 add
                        " '",tm.y1 CLIPPED,"'",
                        " '",tm.m1b CLIPPED,"'",
                        " '",tm.m1e CLIPPED,"'",
                        " '",tm.ch CLIPPED,"'",
                        " '",tm.unit CLIPPED,"'" ,
                        " '",tm.y CLIPPED,"'",                 #No.TQC-610090 add
                        " '",tm.z CLIPPED,"'",                #MOD-A80104 
                        " '",tm.type CLIPPED,"'" ,      #CHI-9C0025
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axsr130',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axsr130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL axsr130()
 
      ERROR ""
 
   END WHILE
 
   CLOSE WINDOW axsr130_w
 
END FUNCTION
 
FUNCTION axsr130()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name  #No.FUN-680130 VARCHAR(20)
          l_azp01   LIKE azp_file.azp01,
          l_azp03   LIKE azp_file.azp03,
          l_chr     LIKE azp_file.azp03,            #No.MOD-790084 add
          l_dbs     LIKE azp_file.azp03,            #MOD-760131 add
          l_plant     LIKE azp_file.azp01,            #FUN-980059 add
          l_date1   LIKE type_file.dat,             #No.FUN-680130 DATE
          l_date2   LIKE type_file.dat,             #No.FUN-680130 DATE
          l_oab02   LIKE oab_file.oab02,
          l_occ02   LIKE occ_file.occ02,
          l_occ20   LIKE occ_file.occ20,
          l_occ21   LIKE occ_file.occ21,
          l_occ22   LIKE occ_file.occ22,            #FUN-550091
          l_order   ARRAY[5] OF LIKE oab_file.oab02,#No.FUN-680130 VARCHAR(40)            #FUN-560011
          l_flag    LIKE type_file.num5,            #No.FUN-680130 SMALLINT
          l_factor  LIKE ima_file.ima31_fac,        #No.FUN-680130 DECIMAL(16,8),
          l_factor1 LIKE ima_file.ima31_fac,        #MOD-760131 add
          l_i,l_j   LIKE type_file.num10,           #No.FUN-680130 INTEGER
          l_buf     LIKE type_file.chr1000,         #No.FUN-680130 VARCHAR(1000)
          l_sql     STRING,     #TQC-6A0095
          l_qty1,l_qty2        LIKE ogb_file.ogb12, #MOD-530211
          l_amt1,l_amt2,l_amt3 LIKE ogb_file.ogb14, #MOD-530211
          sr1 RECORD order1 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     order2 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     order3 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     order4 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     oga23  LIKE oga_file.oga23,
                     oga24  LIKE oga_file.oga24,   #MOD-990045
                     inqty  LIKE ogb_file.ogb12,
                     inamt  LIKE ogb_file.ogb14,
                     ouqty  LIKE ogb_file.ogb12,
                     ouamt  LIKE ogb_file.ogb14,
                     neqty  LIKE ogb_file.ogb12,
                     neamt  LIKE ogb_file.ogb14,
                     ccamt  LIKE ogb_file.ogb14,
                     ppamt  LIKE ogb_file.ogb14
              END RECORD,
          sr  RECORD order1 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     order2 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     order3 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     order4 LIKE oab_file.oab02,    #No.FUN-680130 VARCHAR(40) #FUN-560011
                     code1  LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)                 #no.5169
                     gem02  LIKE gem_file.gem02,    #部門名稱
                     gen02  LIKE gen_file.gen02,    #人員名稱
                     oab02  LIKE oab_file.oab02,    #銷售名稱
                     oga26  LIKE oga_file.oga26,    #銷售分類二
                     oga032 LIKE oga_file.oga032,   #帳款客戶名稱
                     oca02  LIKE oca_file.oca02,    #客戶分類
                     oga04  LIKE oga_file.oga04,    #送貨客戶
                     oga23  LIKE oga_file.oga23,    #幣別
                     oga24  LIKE oga_file.oga24,    #匯率
                     ogb14  LIKE ogb_file.ogb14,    #金額
                     oga15  LIKE oga_file.oga15,    #部門編號
                     oga14  LIKE oga_file.oga14,    #人員編號
                     oga25  LIKE oga_file.oga25,    #銷售分類一
                     oga03  LIKE oga_file.oga03,    #帳款客戶
                     oca01  LIKE oca_file.oca01,    #帳款客戶分類
                     ima131 LIKE ima_file.ima131,   #產品分類
                     ima06  LIKE ima_file.ima06,    #主要分群碼
                     azp01  LIKE azp_file.azp01,    #工廠編號
                     ogb04  LIKE ogb_file.ogb04,    #料件編號
                     ogb05  LIKE ogb_file.ogb05,    #銷售單位
                     ogb1001 LIKE ogb_file.ogb1001, #原因碼   #MOD-A80104
                     ogb12  LIKE ogb_file.ogb12,    #數量
                     ccc23  LIKE ccc_file.ccc23,    #單位成本 #MOD-530211
                     oga02  LIKE oga_file.oga02,    #No.MOD-5A0081  #MOD-760131 modify
                     ima25  LIKE ima_file.ima25,    #MOD-760131 add
                     ogb09  LIKE ogb_file.ogb09,    #CHI-9C0025
                     ogb091 LIKE ogb_file.ogb091,   #CHI-9C0025
                     ogb092 LIKE ogb_file.ogb092,   #CHI-9C0025
                     tlfcost LIKE tlf_file.tlfcost  #CHI-9C0025
              END RECORD
   DEFINE l_azf08    LIKE azf_file.azf08   #MOD-A80104
   #FUN-B90090----------add-------str
   DEFINE l_ima09    LIKE ima_file.ima09,
          l_ima10    LIKE ima_file.ima10,
          l_ima11    LIKE ima_file.ima11,
          l_azf03_1  LIKE azf_file.azf03,
          l_azf03_2  LIKE azf_file.azf03,
          l_azf03_3  LIKE azf_file.azf03   
   #FUN-B90090----------add-------end
 
   DELETE FROM tmp_file
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740015 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   DECLARE temp_c1 CURSOR FOR
           SELECT order1,order2,order3,order4,oga23,oga24,   #MOD-990045
                  SUM(inqty),SUM(inamt),SUM(ouqty),SUM(ouamt),
                  SUM(inqty-ouqty),SUM(inamt-ouamt),
                  SUM(ccamt),SUM(ppamt)
             FROM tmp_file
            GROUP BY order1,order2,order3,order4,oga23,oga24   #MOD-990045
 
   IF STATUS THEN
      CALL cl_err3("sel","tmp_file","","",STATUS,"","TEMP_cl",1)   #No.FUN-660155
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
 
   LET l_sql ="SELECT azp01,azp03 FROM azp_file ",
              " WHERE ",tm.wc CLIPPED,
              "   AND azp01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01='",g_user,"') ",   #MOD-950018
              "   AND azp053 != 'N' " #no.7431
   PREPARE azp_pr FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('azp_pr',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   DECLARE azp_cur CURSOR FOR azp_pr
 
   CALL s_azn01(tm.y1,tm.m1b) RETURNING b_date,l_date1
   CALL s_azn01(tm.y1,tm.m1e) RETURNING l_date2,e_date
 
   FOREACH azp_cur INTO l_azp01,l_azp03
      IF STATUS THEN
         CALL cl_err('azp_cur',STATUS,0)
         EXIT FOREACH
      END IF
      LET g_sql = "SELECT '','','','','1',",
                  "       gem02,gen02,oab02,oga26,oga032,oca02,",
                  "       oga04,oga23,oga24,ogb14,oga15,oga14,",
                  "       oga25,oga03,oca01,ima131,ima06,'',ogb04,ogb05,ogb1001,",   #MOD-A80104 add ogb1001
                  "       ogb12,'',oga02,ima25, ",   #No.MOD-5A0081       #MOD-760131 add ima25
                  "       ogb09,ogb091,ogb092,imd09 ",  #CHI-9C0025
                  "       ,ima09,ima10,ima11 ", #FUN-B90090 add                   
                  "  FROM ",cl_get_target_table(l_azp01,'oga_file'),  #FUN-9A0100 mod  #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gem_file')," ON oga15 = gem01",  #FUN-9A0100 mod #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gen_file')," ON oga14 = gen01",  #FUN-9A0100 mod #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oab_file')," ON oga25 = oab01,", #FUN-9A0100 mod #FUN-A10098
                     cl_get_target_table(l_azp01,'ogb_file'),  #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'imd_file')," ON ogb09 = imd01,", #CHI-9C0025 #FUN-A10098
                     cl_get_target_table(l_azp01,'occ_file'),  #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oca_file')," ON occ03 = oca01,", #FUN-9A0100 mod #FUN-A10098
                     cl_get_target_table(l_azp01,'ima_file'),",",  #FUN-9A0100 mod #FUN-A10098
                     cl_get_target_table(l_azp01,'oay_file'),      #FUN-9A0100 mod #FUN-A10098
                  " WHERE ",tm.wc2 CLIPPED,
                  "   AND oga02 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "   AND oga01 like ltrim(rtrim(oayslip)) || '-%' ",  #No.FUN-550072
                  "   AND oga01 = ogb01 ",
                  "   AND oga00 <> 'A' ",                    #No.CHI-870039
                  "   AND ima01 = ogb04 ",
                  "   AND ogb04 NOT LIKE 'MISC%' ",
                  "   AND ogb17 = 'N' ",  #MOD-B30619 add
                  "   AND occ01 = oga03 ",
                  "   AND ogb09 NOT IN (SELECT jce02 FROM jce_file)",  #No.MOD-890225 add
                  "   AND ogaconf != 'X' ",   #01/08/20 mandy
                  "   AND (oga65 != 'Y' OR oga09 = '8')"   #CHI-870001
 
      IF tm.y = 'Y' THEN
         LET g_sql = g_sql CLIPPED," AND ogapost='Y' "
      END IF
 
      LET g_sql = g_sql CLIPPED," AND oga09 IN ('2','3','4','6','8','A') ",  #No.FUN-610079 #CHI-A60005 add 'A'
                                " AND oga00 NOT IN ('3','7') " #No.MOD-860111 modify by liuxqa  #No.MOD-950210 add 7   #MOD-A80203 del '2'

      #MOD-B30619 add --start--
      LET g_sql = g_sql CLIPPED," UNION ALL ", 
                  "SELECT '','','','','1',",
                  "       gem02,gen02,oab02,oga26,oga032,oca02,",
                 #"       oga04,oga23,oga24,ogb13*ogc12,oga15,oga14,",       #MOD-C80259 mark 
                  "       oga04,oga23,oga24,ogb14/ogb12*ogc12,oga15,oga14,", #MOD-C80259 add
                  "       oga25,oga03,oca01,ima131,ima06,'',ogc17,ogb05,ogb1001,",   
                  "       ogc12,'',oga02,ima25,",   
                  "       ogc09,ogc091,ogc092,imd09 ",
                  "       ,ima09,ima10,ima11 ", #FUN-B90090 add                  
                  "  FROM ",cl_get_target_table(l_azp01,'oga_file'), 
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gem_file')," ON oga15 = gem01",
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gen_file')," ON oga14 = gen01", 
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oab_file')," ON oga25 = oab01,", 
                     cl_get_target_table(l_azp01,'ogb_file'),
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'imd_file')," ON ogb09 = imd01,", 
                     cl_get_target_table(l_azp01,'occ_file'), 
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oca_file')," ON occ03 = oca01,", 
                     cl_get_target_table(l_azp01,'ima_file'),",",  
                     cl_get_target_table(l_azp01,'oay_file'),",", 
                     cl_get_target_table(l_azp01,'ogc_file'), 
                  " WHERE ",tm.wc2 CLIPPED,
                  "   AND oga02 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "   AND oga01 like ltrim(rtrim(oayslip)) || '-%' ", 
                  "   AND oga01 = ogb01 ",
                  "   AND oga00 <> 'A' ",
                  "   AND ogb17 =  'Y' ",
                  "   AND ogc01 = ogb01 ",
                  "   AND ogc03 = ogb03 ",                 
                  "   AND ima01 = ogc17 ",
                  "   AND occ01 = oga03 ",
                  "   AND ogb09 NOT IN (SELECT jce02 FROM jce_file)",  
                  "   AND occ01 = oga03 ",
                  "   AND ogaconf != 'X' ", 
                  "   AND (oga65 != 'Y' OR oga09 = '8')" 

      IF tm.y = 'Y' THEN
         LET g_sql = g_sql CLIPPED," AND ogapost='Y' "
      END IF
 
      LET g_sql = g_sql CLIPPED," AND oga09 IN ('2','3','4','6','8','A') ",
                                " AND oga00 NOT IN ('3','7') " 

      #MOD-B30619 add --end--

         LET buf = base.StringBuffer.create() 
         CALL buf.append(tm.wc2)             
         CALL buf.replace("oga","oha",0)    
         CALL buf.replace("ogb","ohb",0)   
         LET l_buf = buf.toString()
 
      LET l_sql = g_sql CLIPPED," UNION ALL ", #No:9457
                  "SELECT '','','','','2',",
                  " gem02,gen02,oab02,oha26,oha032,oca02,",
                  " oha04,oha23,oha24,ohb14,oha15,oha14,",
                  " oha25,oha03,oca01,ima131,ima06,'',ohb04,ohb05,'',",   #MOD-A80104 add ''
                  " ohb12,'',oha02,ima25, ",  #No.MOD-5A0081     #MOD-760131 add ima25
                  " ohb09,ohb091,ohb092,imd09 ",  #CHI-9C0025
                  " ,ima09,ima10,ima11 ", #FUN-B90090 add                  
                  "  FROM ",cl_get_target_table(l_azp01,'oha_file'),  #FUN-9A0100 mod  #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gem_file')," ON oha15 = gem01",  #FUN-9A0100 mod #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gen_file')," ON oha14 = gen01",  #FUN-9A0100 mod #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oab_file')," ON oha25 = oab01,", #FUN-9A0100 mod #FUN-A10098
                     cl_get_target_table(l_azp01,'ohb_file'),  #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'imd_file')," ON ohb09 = imd01,", #CHI-9C0025 #FUN-A10098
                     cl_get_target_table(l_azp01,'occ_file'),  #FUN-A10098
                  "  LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oca_file')," ON occ03 = oca01,", #FUN-9A0100 mod #FUN-A10098
                     cl_get_target_table(l_azp01,'ima_file'),",",  #FUN-9A0100 mod #FUN-A10098
                     cl_get_target_table(l_azp01,'oay_file'),      #FUN-9A0100 mod #FUN-A10098
                  " WHERE ",l_buf CLIPPED,
                  "   AND oha02 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "   AND oha01 like ltrim(rtrim(oayslip)) || '-%' ",  #No.FUN-550072
                  "   AND oha01 = ohb01 ",
		  "   AND ima01 = ohb04 ",
                  "   AND ohb04 NOT LIKE 'MISC%' ",
                  "   AND occ01 = oha03 ",
                  "   AND ohb09 NOT IN (SELECT jce02 FROM jce_file)",  #No.MOD-890225 add
                  "   AND ohaconf != 'X' ", #01/08/20 mandy
                 "   AND oha09 IN ('1','2','3','4','5') "   # MOD-8B0193    #MOD-A80203 add '2'
 
      IF tm.y = 'Y' THEN
         LET l_sql = l_sql CLIPPED," AND ohapost = 'Y' "
      END IF
 
      CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql   #FUN-A10098
      PREPARE r130_p1 FROM l_sql
      IF STATUS THEN
         CALL cl_err('prepare #1',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
         EXIT PROGRAM
      END IF
      DECLARE r130_c1 CURSOR FOR r130_p1
 
      LET l_chr = l_azp03     #No.MOD-790084 add 
      #FOREACH r130_c1 INTO sr.*                        #FUN-B90090 mark
      FOREACH r130_c1 INTO sr.*,l_ima09,l_ima10,l_ima11 #FUN-B90090 add
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach #1',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         #-----MOD-A80104---------
         LET l_azf08 = ''
         SELECT azf08 INTO l_azf08 FROM azf_file
          WHERE azf01 = sr.ogb1001
            AND azf02 = '2' 
            AND azfacti ='Y'
         IF tm.z = 'N' AND l_azf08 = 'Y' THEN
            CONTINUE FOREACH
         END IF
         #-----END MOD-A80104-----
 
         CASE tm.type
          WHEN '1'  LET sr.tlfcost = ' '
          WHEN '2'  LET sr.tlfcost = ' '
          WHEN '3'  LET sr.tlfcost = sr.ogb092
          WHEN '4'  LET sr.tlfcost = ' '
          WHEN '5'  LET sr.tlfcost = sr.tlfcost
          OTHERWISE LET sr.tlfcost = ' '
         END CASE
        #LET l_sql = "SELECT ccc23 FROM ",s_dbstring(l_chr CLIPPED),"ccc_file",    #TQC-950020 #FUN-A10098
         LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_azp01,'ccc_file'), #TQC-950020 #FUN-A10098 
                     " WHERE ccc01 ='", sr.ogb04 ,"'",
                     " AND ccc02 = ",YEAR(sr.oga02),
                     " AND ccc07 = '",tm.type,"'",     #CHI-9C0025
                     " AND ccc08 = '",sr.tlfcost,"'",  #CHI-9C0025
                     " AND ccc03 = ",MONTH(sr.oga02) 
 
         CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql   #FUN-A10098
         PREPARE r130_ccc23_p1 FROM l_sql
         DECLARE r130_ccc23_c1 CURSOR FOR r130_ccc23_p1
         OPEN r130_ccc23_c1
         FETCH r130_ccc23_c1 INTO sr.ccc23
 
         LET l_qty1=0 LET l_amt1=0 LET l_qty2=0 LET l_amt2=0
         IF tm.ch='2' THEN       #本幣
            LET sr.ogb14 = sr.ogb14 * sr.oga24
         END IF
 
         IF cl_null(sr.ogb14) THEN
            LET sr.ogb14 = 0
         END IF
 
         IF cl_null(sr.ccc23) THEN
            LET sr.ccc23 = 0
         END IF
 
         IF NOT cl_null(tm.unit) THEN         #單位轉換
            LET l_dbs=s_dbstring(l_azp03 CLIPPED)  #TQC-950020   
           # LET l_plant =s_dbstring(l_azp01 CLIPPED)  #FUN-980059   #FUN-AB0100 mark
            LET l_plant =l_azp01 CLIPPED  #FUN-AB0100 
            CALL s_umfchk1(sr.ogb04,sr.ogb05,tm.unit,l_plant)  #No.FUN-980059 
                 RETURNING l_flag,l_factor
            IF l_flag = 1 THEN    #無此轉換率
                CALL cl_err('','abm-731',1)
                EXIT FOREACH
                LET l_factor = 1
            END IF 
            CALL s_umfchk1(sr.ogb04,tm.unit,sr.ima25,l_plant)   #No.FUN-980059 
                 RETURNING l_flag,l_factor1
            IF l_flag = 1 THEN    #無此轉換率
                CALL cl_err('2_factor','abm-731',1)
                LET l_factor1 = 1
                EXIT FOREACH    
            END IF 
         ELSE
            LET l_factor = 1      #MOD-760131 modify
            LET l_dbs=s_dbstring(l_azp03 CLIPPED) #TQC-950020   
            CALL s_umfchk1(sr.ogb04,sr.ogb05,sr.ima25,l_plant)   #No.FUN-980059
                 RETURNING l_flag,l_factor1
            IF l_flag = 1 THEN    #無此轉換率
                CALL cl_err('3_factor','abm-731',1)
                LET l_factor1 = 1
                EXIT FOREACH    
            END IF 
         END IF
 
         LET sr.ogb12 = sr.ogb12 * l_factor
 
         IF sr.code1='1' THEN  #no.5169
            LET l_qty1 = sr.ogb12
            LET l_amt1 = sr.ogb14
         END IF
 
         IF sr.code1='2' THEN  #no.5169                 #銷退
            LET l_qty2 = sr.ogb12
            LET l_amt2 = sr.ogb14
         END IF
 
         LET sr.azp01=l_azp01
         LET g_order=''
 
         FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azp01
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gem02
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.gen02
                WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oab02
                WHEN tm.s[g_i,g_i] = '5'
                     SELECT oab02 INTO l_oab02 FROM oab_file
                      WHERE oab01=sr.oga26
                     IF STATUS THEN LET l_oab02='' END IF
                     LET l_order[g_i] = l_oab02
                WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga032
                WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oca02
                WHEN tm.s[g_i,g_i] = '8'
                     SELECT occ02 INTO l_occ02 FROM occ_file
                      WHERE occ01=sr.oga04
                     IF STATUS THEN LET l_occ02='' END IF
                     LET l_order[g_i] = l_occ02
                WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oga23
                WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.ima131
                WHEN tm.s[g_i,g_i] = 'b' LET l_order[g_i] = sr.ima06
                WHEN tm.s[g_i,g_i] = 'c' LET l_order[g_i] = sr.ogb04
                WHEN tm.s[g_i,g_i] = 'd'
                     SELECT occ20 INTO l_occ20 FROM occ_file
                      WHERE occ01=sr.oga04
                     IF STATUS THEN LET l_occ20='' END IF
                     LET l_order[g_i] = l_occ20
                WHEN tm.s[g_i,g_i] = 'e'
                     SELECT occ21 INTO l_occ21 FROM occ_file
                      WHERE occ01=sr.oga04
                     IF STATUS THEN LET l_occ21='' END IF
                     LET l_order[g_i] = l_occ21
                WHEN tm.s[g_i,g_i] = 'f'
                     SELECT occ22 INTO l_occ22 FROM occ_file
                      WHERE occ01=sr.oga04
                     IF STATUS THEN LET l_occ22='' END IF
                     LET l_order[g_i] = l_occ22
#FUN-B90090----------add-------str
                 WHEN tm.s[g_i,g_i] = 'g'
                      LET l_sql = "SELECT azf03 ",
                                  "  FROM ",cl_get_target_table(l_azp01,'azf_file'),
                                  " WHERE azf01 = '",l_ima09,"'",
                                  "   AND azf02 = 'D' AND azfacti = 'Y'"
                      PREPARE sel_azf03_pre1 FROM l_sql
                      DECLARE sel_azf03_cs1 CURSOR FOR sel_azf03_pre1
                      OPEN sel_azf03_cs1
                      FETCH sel_azf03_cs1 INTO l_azf03_1
                      CLOSE sel_azf03_cs1  
                      IF STATUS THEN LET l_azf03_1 = '' END IF
                      LET l_order[g_i] = l_azf03_1
                 WHEN tm.s[g_i,g_i] = 'h'
                      LET l_sql = "SELECT azf03 ",
                                  "  FROM ",cl_get_target_table(l_azp01,'azf_file'),
                                  " WHERE azf01 = '",l_ima10,"'",
                                  "   AND azf02 = 'E' AND azfacti = 'Y'"
                      PREPARE sel_azf03_pre2 FROM l_sql
                      DECLARE sel_azf03_cs2 CURSOR FOR sel_azf03_pre2
                      OPEN sel_azf03_cs2
                      FETCH sel_azf03_cs2 INTO l_azf03_2
                      CLOSE sel_azf03_cs2  
                      IF STATUS THEN LET l_azf03_2 = '' END IF
                      LET l_order[g_i] = l_azf03_2
                 WHEN tm.s[g_i,g_i] = 'i'
                      LET l_sql = "SELECT azf03 ",
                                  "  FROM ",cl_get_target_table(l_azp01,'azf_file'),
                                  " WHERE azf01 = '",l_ima11,"'",
                                  "   AND azf02 = 'F' AND azfacti = 'Y'"
                      PREPARE sel_azf03_pre3 FROM l_sql
                      DECLARE sel_azf03_cs3 CURSOR FOR sel_azf03_pre3
                      OPEN sel_azf03_cs3
                      FETCH sel_azf03_cs3 INTO l_azf03_3
                      CLOSE sel_azf03_cs3  
                      IF STATUS THEN LET l_azf03_3 = '' END IF
                      LET l_order[g_i] = l_azf03_3
#FUN-B90090----------add-------end                     
                OTHERWISE LET l_order[g_i] = ''
             END CASE
          END FOR
 
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          IF tm.ch = '1' THEN
             LET sr.order4 = sr.oga23
          ELSE
             LET sr.order4 = g_aza.aza17
          END IF
 
          LET l_amt3=(l_qty1-l_qty2)*sr.ccc23 * l_factor1    #MOD-760131 add l_factor1

          #MOD-C20219 ----- add start -----
         #IF tm.ch='2' THEN       #本幣     #MOD-CC0213 mark
         #   LET l_amt3 = l_amt3 * sr.oga24 #MOD-CC0213 mark
          IF tm.ch='1' THEN       #原幣     #MOD-CC0213 add
             LET l_amt3 = l_amt3 / sr.oga24 #MOD-CC0213 add
          END IF
          #MOD-C20219 ----- add end -----
 
          INSERT INTO tmp_file VALUES
                 (sr.order1,sr.order2,sr.order3,sr.oga23,sr.oga23,sr.oga24,   #No:8059   #MOD-990045
                  l_qty1,l_amt1,l_qty2,l_amt2,l_amt3,0)
          IF STATUS THEN
             CALL cl_err3("ins","tmp_file",sr.order1,sr.order2,STATUS,"","INS-tmp",1)   #No.FUN-660155
             EXIT FOREACH
          END IF
       END FOREACH
   END FOREACH
 
#  CALL cl_outnam('axsr130') RETURNING l_name  #No.TQC-A50147
 
   LET g_pageno = 0
   LET g_inqty=0 LET g_inamt=0
   LET g_ouqty=0 LET g_ouamt=0
   LET g_neqty=0 LET g_neamt=0
   LET g_ccamt=0 LET g_ppamt=0
 
   FOREACH temp_c1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach #3',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
         EXIT PROGRAM
      END IF
      LET g_inqty=g_inqty + sr1.inqty       #銷貨數量
      LET g_inamt=g_inamt + sr1.inamt       #銷貨金額
      LET g_ouqty=g_ouqty + sr1.ouqty       #銷退數量
      LET g_ouamt=g_ouamt + sr1.ouamt       #銷退金額
      LET g_neqty=g_neqty + sr1.neqty       #銷貨淨量
      LET g_neamt=g_neamt + sr1.neamt       #銷貨淨額
      LET g_ccamt=g_ccamt + sr1.ccamt       #成本
      LET sr1.ppamt=(sr1.neamt-sr1.ccamt)   #毛利
      LET g_ppamt=g_ppamt + sr1.ppamt       #毛利
 
           CALL r130_m(sr1.oga23)
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
           EXECUTE insert_prep USING 
             sr1.order1,sr1.order2,sr1.order3,sr1.order4,
             sr1.oga23,sr1.oga24,sr1.inqty,sr1.inamt,sr1.ouqty,sr1.ouamt,   #MOD-990045
             sr1.neqty,sr1.neamt,sr1.ccamt,sr1.ppamt,l_azi04,l_azi05 
         #------------------------------ CR (3) ------------------------------#
 
   END FOREACH
   IF g_inqty=0 THEN LET g_inqty=1 END IF
   IF g_inamt=0 THEN LET g_inamt=1 END IF
   IF g_ouqty=0 THEN LET g_ouqty=1 END IF
   IF g_ouamt=0 THEN LET g_ouamt=1 END IF
   IF g_neqty=0 THEN LET g_neqty=1 END IF
   IF g_neamt=0 THEN LET g_neamt=1 END IF
   IF g_ccamt=0 THEN LET g_ccamt=1 END IF
   IF g_ppamt=0 THEN LET g_ppamt=1 END IF
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740015 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-740015 modify
   LET g_str = NULL     #No.MOD-8C0025 add
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gem02,gen02,oab02,oga26,oga032,oca02,oga04,oga23,
                    oga24,ogb14,oga15,oga14,oga25,oga03,oca01,ima131,
                    ima06,azp01,ogb04,ogb05,ogb12,ccc23,oga02
                    ima09,ima10,ima11') #FUN-B90090 add                     
           RETURNING tm.wc
      CALL cl_wcchp(tm.wc2,'gem02,gen02,oab02,oga26,oga032,oca02,oga04,oga23,
                    oga24,ogb14,oga15,oga14,oga25,oga03,oca01,ima131,
                    ima06,azp01,ogb04,ogb05,ogb12,ccc23,oga02
                    ima09,ima10,ima11') #FUN-B90090 add                   
           RETURNING tm.wc2
      LET g_str = tm.wc,tm.wc2
   END IF
   LET g_str = g_str ,";",tm.s,";",tm.t,";",tm.ch,";",b_date,";",e_date,";",
               g_inqty,";",g_inamt,";",g_ouqty,";",g_ouamt,";",g_neqty,";",
               g_neamt,";",g_ccamt,";",g_ppamt,";",tm.u
   CALL cl_prt_cs3('axsr130','axsr130',l_sql,g_str)  
   #------------------------------ CR (4) ------------------------------#
 
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
 
END FUNCTION
 
FUNCTION r130_m(p_code)
DEFINE p_code  LIKE oga_file.oga23
 
    IF tm.ch=1  THEN         #(原幣)
        SELECT azi03,azi04,azi05 INTO l_azi03,l_azi04,l_azi05  #抓幣別取位 
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
#No.FUN-9C0072 精簡程式碼 
 
