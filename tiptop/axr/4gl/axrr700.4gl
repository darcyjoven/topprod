# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr700.4gl
# Descriptions...: 銷貨客戶排行表
# Date & Author..: 00/07/24 by Brendan
# Modify.........: No:7700 03/03/19 By Wiky create temp y 時應多增加客戶名稱,不然MISC客戶但不同名稱時會計算錯誤
# Modify.........: No.MOD-4A0076 04/10/14 By Yuna 在輸入工廠編號的地方,應該不要新增與刪除的功能
# Modify.........: No.FUN-4C0100 05/01/01 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-630018 06/03/06 By Smapmin 請剔除料號'MISC*',才能勾稽其他報表.
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表格式       
# Modify.........: No.FUN-710080 07/03/26 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-740043 07/04/12 By Smapmin 客戶簡稱要放大
# Modify.........: No.TQC-750198 07/05/31 By Smapmin 將幣別QBE條件移到INPUT選項中
# Modify.........: No.MOD-780074 07/08/13 By Smapmin axmt700選5.折讓的資料,應呈現在銷折金額裡
# Modify.........: No.CHI-7B0027 07/11/19 By Smapmin 增加合計欄位
# Modify.........: No.MOD-7C0036 07/12/05 By Smapmin 列印筆數與列印金額設定了卻沒作用
# Modify.........: No.MOD-810180 08/03/05 By Smapmin 基礎幣別用意在於報表金額的呈現方式依據
# Modify.........: No.FUN-8C0018 08/12/15 By jan 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-970054 09/07/08 By destiny 數值欄位不能插空
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/07 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No.TQC-950152 10/03/09 by huangrh percent是MSV的關鍵字
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A50082 10/05/25 By Carrier crate temp table失败 FUN-A20044修改的问题
# Modify.........: No:CHI-B20010 11/02/18 BY Summer 將排序、跳頁、小計等INPUT選項拿掉
# Modify.........: No:CHI-B30021 11/04/01 BY Summer 延續CHI-B20010處理,移除oma15/oma14/oma09的抓取應用
# Modify.........: No:MOD-B50150 11/05/18 BY Dido 應排除 MISC 資料 
# Modify.........: No:TQC-BB0082 11/11/09 By yinhy percent改為%顯示
# Modify.........: No:FUN-BB0173 12/01/16 by pauline 增加跨法人抓取資料
# Modify.........: No.FUN-C40001 12/04/13 By SunLM 增加開窗功能


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
            wc      STRING,		      #TQC-630166
  ##NO.FUN-A10098   add--begin
#           b        LIKE type_file.chr1,    #No.FUN-8C0018 VARCHAR(1)
#           p1       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
#           p2       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
#           p3       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
#           p4       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10) 
#           p5       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
#           p6       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
#           p7       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
#           p8       LIKE azp_file.azp01,    #No.FUN-8C0018 VARCHAR(10)
  ##NO.FUN-A10098   add--end
         #FUN-BB0173 add START
            plant_1 LIKE azw_file.azw01,
            plant_2 LIKE azw_file.azw01,
            plant_3 LIKE azw_file.azw01,
            plant_4 LIKE azw_file.azw01,
            plant_5 LIKE azw_file.azw01,
            plant_6 LIKE azw_file.azw01,
            plant_7 LIKE azw_file.azw01,
            plant_8 LIKE azw_file.azw01,
         #FUN-BB0173 add END
           #CHI-B20010 mark --start--
           #s        LIKE type_file.chr6,    #FUN-8C0018
           #t        LIKE type_file.chr3,    #FUN-8C0018
           #u        LIKE type_file.chr3,    #FUN-8C0018
           #CHI-B20010 mark --end--
            oma23   LIKE oma_file.oma23,   #TQC-750198
            bdate   LIKE type_file.dat,          #No.FUN-680123 DATE
            edate   LIKE type_file.dat,          #No.FUN-680123 DATE
            prno    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
            pramt   LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
            more    LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
           END RECORD,
       g_rank       LIKE type_file.num5,         #No.FUN-680123 SMALLINT # Rank
       g_atot       LIKE type_file.num5          #No.FUN-680123 SMALLINT # total array
DEFINE g_i          LIKE type_file.num5          #count/index for any purpose  #No.FUN-680123 SMALLINT
DEFINE i            LIKE type_file.num5          #TQC-610059 #No.FUN-680123 SMALLINT
DEFINE l_table      STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
  ##NO.FUN-A10098   add--begin
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0018 ARRAY[10] OF VARCHAR(20)
  ##NO.FUN-A10098   add--end 
#FUN-BB0173 add START
DEFINE plant   ARRAY[8]  OF LIKE azp_file.azp01
DEFINE   g_ary DYNAMIC ARRAY OF RECORD
            plant      LIKE azw_file.azw01           #plant
            END RECORD
DEFINE   g_ary_i        LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1         #記錄是否為流通
DEFINE   g_azw01_1      LIKE azw_file.azw01
DEFINE   g_azw01_2      LIKE azw_file.azw01
#FUN-BB0173 add END
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "seq.type_file.num5,",
               "oma03.oma_file.oma03,",
               "oma032.oma_file.oma032,",
               "A1.type_file.num15_3,",  #FUN-A20044  #No.TQC-A50082
               "A2.type_file.num20_6,",
               "B1.type_file.num15_3,",  #FUN-A20044  #No.TQC-A50082
               "B2.type_file.num20_6,",
               "C2.type_file.num20_6,",
               "D1.type_file.num20_6,",    #FUN-A20044  #No.TQC-A50082
               "D2.type_file.num20_6,",
               "amt.type_file.num20_6,",
#              "percent.type_file.num20_6,",                #TQC-950152                                                             
               "percent_1.type_file.num20_6,",              #TQC-950152   
               "plant.azp_file.azp01"                       #FUN-8C0018 #CHI-B30021 mod
              #CHI-B30021 mark --start--
              #"oma15.oma_file.oma15,",                     #FUN-8C0018
              #"oma14.oma_file.oma14,",                     #FUN-8C0018
              #"oma09.oma_file.oma09"                       #FUN-8C0018
              #CHI-B30021 mark --end--
 
   LET l_table = cl_prt_temptable('axrr700',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"                       #FUN-8C0018 add ?,?,?,? #CHI-B30021 拿掉3? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   DROP TABLE x
   DROP TABLE y
   DROP TABLE z   #FUN-710080 add
 
   CREATE TEMP TABLE x
        (x00 LIKE type_file.chr2,  
         x34 LIKE oma_file.oma34,   #MOD-780074
         x23 LIKE oma_file.oma23,   #MOD-810180
         x03 LIKE azp_file.azp01,
         x032 LIKE oma_file.oma032,     #MOD-740043
         xb12 LIKE type_file.num20_6,
         xb14 LIKE type_file.num20_6,   #MOD-810180
         xb16 LIKE type_file.num20_6)   #CHI-B30021 mod
        #CHI-B30021 mark --start--
        #x15 LIKE oma_file.oma15,       #FUN-8C0018
        #x14 LIKE oma_file.oma14,       #FUN-8C0018
        #x09 LIKE oma_file.oma09)       #FUN-8C0018
        #CHI-B30021 mark --end--
   IF STATUS THEN 
      CALL cl_err('create',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
 
   CREATE TEMP TABLE y
        (y03 LIKE azp_file.azp01,
         y032 LIKE oma_file.oma032,     #MOD-740043
         yA1 LIKE type_file.num15_3, #FUN-A20044  #No.TQC-A50082
         yA2 LIKE type_file.num20_6,
         yB1 LIKE type_file.num15_3, #FUN-A20044  #No.TQC-A50082
         yB2 LIKE type_file.num20_6,
         yC2 LIKE type_file.num20_6)
   IF STATUS THEN 
      CALL cl_err('create #2',STATUS,1) 
      EXIT PROGRAM 
   END IF
 
   CREATE TEMP TABLE z
        (oma03   LIKE oma_file.oma03,
         oma032  LIKE oma_file.oma032,
         A1      LIKE type_file.num15_3, #FUN-A20044  #No.TQC-A50082
         A2      LIKE type_file.num20_6,
         B1      LIKE type_file.num15_3, #FUN-A20044  #No.TQC-A50082
         B2      LIKE type_file.num20_6,
         C2      LIKE type_file.num20_6,
         D1      LIKE type_file.num15_3, #FUN-A20044  #No.TQC-A50082
         D2      LIKE type_file.num20_6,
         amt     LIKE type_file.num20_6,
         percent_1 LIKE type_file.num20_6)     #TQC-950152                                                                          
#        percent LIKE type_file.num20_6)       #TQC-950152   
   IF STATUS THEN 
      CALL cl_err('create #3',STATUS,1)
      EXIT PROGRAM 
   END IF
 
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  ##NO.FUN-A10098   add--begin
#  LET tm.p1    = ARG_VAL(8)
#  LET tm.p2    = ARG_VAL(9)
#  LET tm.p3    = ARG_VAL(10)
#  LET tm.p4    = ARG_VAL(11)
#  LET tm.p5    = ARG_VAL(12)
#  LET tm.p6    = ARG_VAL(13)
#  LET tm.p7    = ARG_VAL(14)
#  LET tm.p8    = ARG_VAL(15)
#FUN-BB0173 mark START
#  LET tm.oma23 = ARG_VAL(8)   #TQC-750198
#  LET tm.bdate = ARG_VAL(9)
#  LET tm.edate = ARG_VAL(10)
#  LET tm.prno  = ARG_VAL(11)
#  LET tm.pramt = ARG_VAL(12)
#  LET g_rep_user = ARG_VAL(13)
#  LET g_rep_clas = ARG_VAL(14)
#  LET g_template = ARG_VAL(15)
#  LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
#FUN-BB0173 mark END
#FUN-BB0173 add START
   LET plant[1] = ARG_VAL(8)
   LET plant[2] = ARG_VAL(9)
   LET plant[3] = ARG_VAL(10)
   LET plant[4] = ARG_VAL(11)
   LET plant[5] = ARG_VAL(12)
   LET plant[6] = ARG_VAL(13)
   LET plant[7] = ARG_VAL(14)
   LET plant[8] = ARG_VAL(15)
   LET tm.oma23 = ARG_VAL(16)
   LET tm.bdate = ARG_VAL(17)
   LET tm.edate = ARG_VAL(18)
   LET tm.prno  = ARG_VAL(19)
   LET tm.pramt = ARG_VAL(20)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)
   FOR g_i = 1 TO 8
      IF NOT cl_null(plant[g_i])THEN
         CALL chk_plant(plant[g_i]) RETURNING g_azw01_1
         IF NOT cl_null(g_azw01_1) THEN
            IF cl_null(g_azw01_2) THEN
               LET g_azw01_2 = "'",g_azw01_1,"'"
            ELSE
               LET g_azw01_2 = g_azw01_2,"'",g_azw01_1,"'"
            END IF
         END IF
      END IF
   END FOR
   IF NOT cl_null(g_azw01_2) THEN
      CALL r700_legal_db(g_azw01_2)
   END IF
#FUN-BB0173 add END
#  LET tm.b     = ARG_VAL(25)
# ##NO.FUN-A10098   add--begin
  #CHI-B20010 mark --start--
  #LET tm.s     = ARG_VAL(17)
  #LET tm.t     = ARG_VAL(18)
  #LET tm.u     = ARG_VAL(19)   
  #LET tm2.s1   = tm.s[1,1]
  #LET tm2.s2   = tm.s[2,2]
  #LET tm2.s3   = tm.s[3,3]
  #LET tm2.t1   = tm.t[1,1]
  #LET tm2.t2   = tm.t[2,2]
  #LET tm2.t3   = tm.t[3,3]
  #LET tm2.u1   = tm.u[1,1]
  #LET tm2.u2   = tm.u[2,2]
  #LET tm2.u3   = tm.u[3,3]
  #IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
  #IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
  #IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
  #IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
  #IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
  #IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
  #CHI-B20010 mark --end--
 
   IF cl_null(tm.wc) THEN
      CALL axrr700_tm(0,0)               # Input print condition
   ELSE
      CALL axrr700()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr700_tm(p_row,p_col)
   DEFINE p_row,p_col     LIKE type_file.num5,       #No.FUN-680123 SMALLINT
          i               LIKE type_file.num5,       #No.FUN-680123 SMALLINT
          l_ac            LIKE type_file.num5,       #No.FUN-680123 SMALLINT
          l_cmd           LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(1000)
          l_allow_insert  LIKE type_file.num5,       #可新增否  #No.MOD-4A0076  #No.FUN-680123 SMALLINT
          l_allow_delete  LIKE type_file.num5,       #可刪除否  #No.FUN-680123 SMALLINT
          l_cnt           LIKE type_file.num5        #TQC-750198
#FUN-BB0173 add START
   DEFINE l_string       STRING
   DEFINE l_plant        LIKE azw_file.azw01
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
#FUN-BB0173 add END
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col =15
   ELSE 
      LET p_row = 4 LET p_col =12
   END IF
 
   OPEN WINDOW axrr700_w AT p_row,p_col WITH FORM "axr/42f/axrr700"
################################################################################
# START genero shell script ADD
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL r700_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.oma23 = g_aza.aza17   #TQC-750198
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#  LET tm.b ='N'                #NO.FUN-A10098
  #CHI-B20010 mark --start--
  #LET tm.s ='1234'
  #LET tm.t ='Y'
  #LET tm.u ='Y'
  #CHI-B20010 mark --end--
#  LET tm.p1=g_plant            #NO.FUN-A10098
   LET tm.plant_1 = g_plant   #FUN-BB0173 add
#  CALL r700_set_entry_1()      #NO.FUN-A10098          
#  CALL r700_set_no_entry_1()   #NO.FUN-A10098
#  CALL r700_set_comb()         #NO.FUN-A10098    
 
   WHILE TRUE
      DELETE FROM x
      DELETE FROM y
      DELETE FROM z   #FUN-710080 add
 
      CONSTRUCT BY NAME tm.wc ON oma03,oma15,oma14,oma09   #TQC-750198
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
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma15)#部門
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oma03)#賬款客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
            WHEN INFIELD(oma14)#人員編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma14
                 NEXT FIELD oma14
            END CASE
      #No.FUN-C40001  --End  
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axrr700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
#CHI-B20010 mark --start--
#     #----- 工廠編號 -B---#
#     CALL SET_COUNT(1)    # initial array argument
#     INPUT BY NAME 
##                  tm.b,tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,  #NO.FUN-A10098
#                   tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3 
#     WITHOUT DEFAULTS
#     
#         BEFORE INPUT    #FUN-8C0018
#           LET l_ac = ARR_CURR()
#CHI-B20010 mark --end--
  ##NO.FUN-A10098   mark--begin            
#       ON CHANGE  b
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8
#          CALL r700_set_entry_1()
#          CALL r700_set_no_entry_1()
#          CALL r700_set_comb()
#          
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1
#            END IF  
#         END IF              
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p2 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#         END IF
# 
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p3 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#         END IF
# 
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p4 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#         END IF
# 
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#               NEXT FIELD p5 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#         END IF
# 
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p6 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#         END IF
# 
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#               NEXT FIELD p7 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#         END IF
# 
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p8 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#         END IF       
  ##NO.FUN-A10098   mark--end       
#CHI-B20010 mark --start--
#        AFTER INPUT                    # 檢查至少輸入一個工廠
#           IF INT_FLAG THEN EXIT INPUT END IF
#        ON ACTION CONTROLP
#CHI-B20010 mark --end--
  ##NO.FUN-A10098   mark--begin            
#            IF INFIELD(p1) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            END IF
#            IF INFIELD(p2) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            END IF
#            IF INFIELD(p3) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            END IF
#            IF INFIELD(p4) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            END IF
#            IF INFIELD(p5) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            END IF
#            IF INFIELD(p6) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            END IF
#            IF INFIELD(p7) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            END IF
#            IF INFIELD(p8) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#            END IF
  ##NO.FUN-A10098   mark--end            
#CHI-B20010 mark --start--
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
#     END INPUT
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0 
#        CLOSE WINDOW axrr700_w 
#        RETURN 
#     END IF
#CHI-B20010 mark --end--

#FUN-BB0173 add START
   INPUT BY NAME tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8

   WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD plant_1
         IF NOT cl_null(tm.plant_1) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_1
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_1
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_1) THEN
               NEXT FIELD plant_1
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_1 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_1 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_1 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_1 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_1 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_1 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_1 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
         END IF

      AFTER FIELD plant_2
         IF NOT cl_null(tm.plant_2) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_2
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_2
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_2) THEN
               NEXT FIELD plant_2
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_2 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_2 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_2 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_2 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_2 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_2 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_2 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
         END IF

      AFTER FIELD plant_3
         IF NOT cl_null(tm.plant_3) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_3
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_3
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_3) THEN
               NEXT FIELD plant_3
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_3 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_3 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_3 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_3 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_3 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_3 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_3 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
         END IF

      AFTER FIELD plant_4
         IF NOT cl_null(tm.plant_4) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_4
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_4
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_4) THEN
               NEXT FIELD plant_4
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_4 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_4 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_4 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_4 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_4 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_4 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_4 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
         END IF

      AFTER FIELD plant_5
         IF NOT cl_null(tm.plant_5) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_5
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_5
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_5) THEN
               NEXT FIELD plant_5
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_5 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_5 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_5 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_5 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_5 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_5 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_5 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
         END IF

      AFTER FIELD plant_6
         IF NOT cl_null(tm.plant_6) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_6
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_6
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_6) THEN
               NEXT FIELD plant_6
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_6 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_6 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_6 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_6 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_6 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_6 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_6 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
         END IF

      AFTER FIELD plant_7
         IF NOT cl_null(tm.plant_7) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_7
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_7
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_7) THEN
               NEXT FIELD plant_7
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_7 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_7 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_7 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_7 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_7 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_7 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_7 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
         END IF

      AFTER FIELD plant_8
         IF NOT cl_null(tm.plant_8) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_8
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_8
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_8) THEN
               NEXT FIELD plant_8
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_8 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_8 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_8 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_8 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_8 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_8 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_8 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
         END IF

      AFTER INPUT
         LET l_string = ''
         IF NOT cl_null(tm.plant_1) THEN
            CALL chk_plant(tm.plant_1) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_2) THEN
            CALL chk_plant(tm.plant_2) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_3) THEN
            CALL chk_plant(tm.plant_3) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_4) THEN
            CALL chk_plant(tm.plant_4) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_5) THEN
            CALL chk_plant(tm.plant_5) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_6) THEN
            CALL chk_plant(tm.plant_6) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_7) THEN
            CALL chk_plant(tm.plant_7) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_8) THEN
            CALL chk_plant(tm.plant_8) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

          #營運中心不可為空
         IF cl_null(l_string) THEN
            CALL cl_err('','aom-423',0)
            NEXT FIELD plant_1
         END IF
         CALL r700_legal_db(l_string)

      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(plant_1)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_1
                CALL cl_create_qry() RETURNING tm.plant_1
                DISPLAY BY NAME tm.plant_1
                NEXT FIELD plant_1

             WHEN INFIELD(plant_2)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_2
                CALL cl_create_qry() RETURNING tm.plant_2
                DISPLAY BY NAME tm.plant_2
                NEXT FIELD plant_2

             WHEN INFIELD(plant_3)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_3
                CALL cl_create_qry() RETURNING tm.plant_3
                DISPLAY BY NAME tm.plant_3
                NEXT FIELD plant_3

             WHEN INFIELD(plant_4)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_4
                CALL cl_create_qry() RETURNING tm.plant_4
                DISPLAY BY NAME tm.plant_4
                NEXT FIELD plant_4

             WHEN INFIELD(plant_5)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_5
                CALL cl_create_qry() RETURNING tm.plant_5
                DISPLAY BY NAME tm.plant_5
                NEXT FIELD plant_5

             WHEN INFIELD(plant_6)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_6
                CALL cl_create_qry() RETURNING tm.plant_6
                DISPLAY BY NAME tm.plant_6
                NEXT FIELD plant_6

             WHEN INFIELD(plant_7)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zxy"
                LET g_qryparam.arg1 = g_user
                LET g_qryparam.default1 = tm.plant_7
                CALL cl_create_qry() RETURNING tm.plant_7
                DISPLAY BY NAME tm.plant_7
                NEXT FIELD plant_7

             WHEN INFIELD(plant_8)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zxy"
                  LET g_qryparam.arg1 = g_user
                  LET g_qryparam.default1 = tm.plant_8
                  CALL cl_create_qry() RETURNING tm.plant_8
                  DISPLAY BY NAME tm.plant_8
                  NEXT FIELD plant_8
         END CASE

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#FUN-BB0173 add END

      #----- 工廠編號 -E---#
      LET g_rank = 0
      INPUT BY NAME tm.oma23,tm.bdate,tm.edate,tm.prno,tm.pramt,tm.more   #TQC-750198
            WITHOUT DEFAULTS
         AFTER FIELD oma23
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt  FROM azi_file WHERE azi01=tm.oma23
            IF l_cnt = 0 THEN
               CALL cl_err(tm.oma23,'aap-002',0) 
               NEXT FIELD oma23
            END IF
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
            IF tm.bdate > tm.edate THEN NEXT FIELD edate END IF
         AFTER FIELD prno
            IF NOT cl_null(tm.prno) AND tm.prno < 0 THEN
               DISPLAY '' TO FORMONLY.prno
               NEXT FIELD prno
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' THEN NEXT FIELD more END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLP
           IF INFIELD(oma23) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azi"
              LET g_qryparam.default1 = tm.oma23
              CALL cl_create_qry() RETURNING tm.oma23
              DISPLAY BY NAME tm.oma23
              NEXT FIELD oma23
           END IF
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
 
        #CHI-B20010 mark --start--
        #AFTER INPUT
        #   LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
        #   LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #   LET tm.u = tm2.u1,tm2.u2,tm2.u3
        #CHI-B20010 mark --end--
         
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW axrr700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='axrr700'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axrr700','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
         ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                            " '",tm.p1 CLIPPED,"'" , 
#                            " '",tm.p2 CLIPPED,"'" , 
#                            " '",tm.p3 CLIPPED,"'" , 
#                            " '",tm.p4 CLIPPED,"'" ,  
#                            " '",tm.p5 CLIPPED,"'" , 
#                            " '",tm.p6 CLIPPED,"'" , 
#                            " '",tm.p7 CLIPPED,"'" ,  
#                            " '",tm.p8 CLIPPED,"'" ,  
                      #FUN-BB0173 add START
                            " '",plant[1] CLIPPED,"'",
                            " '",plant[2] CLIPPED,"'",
                            " '",plant[3] CLIPPED,"'",
                            " '",plant[4] CLIPPED,"'",
                            " '",plant[5] CLIPPED,"'",
                            " '",plant[6] CLIPPED,"'",
                            " '",plant[7] CLIPPED,"'",
                            " '",plant[8] CLIPPED,"'",
                      #FUN-BB0173 add END
                            " '",tm.oma23 CLIPPED,"'",   #TQC-750198
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",tm.prno CLIPPED,"'",
                            " '",tm.pramt CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078 #CHI-B20010 取消,
#                        " '",tm.b CLIPPED,"'"      #FUN-8C0018
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
                        #CHI-B20010 mark --start--
                        #" '",tm.s CLIPPED,"'" ,    #FUN-8C0018
                        #" '",tm.t CLIPPED,"'" ,    #FUN-8C0018
                        #" '",tm.u CLIPPED,"'"      #FUN-8C0018
                        #CHI-B20010 mark --end--
            CALL cl_cmdat('axrr700',g_time,l_cmd)  # Execute cmd at later time
         END IF
         CLOSE WINDOW axrr700_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axrr700()
      ERROR ""
   END WHILE
   CLOSE WINDOW axrr700_w
END FUNCTION
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin 
#FUNCTION r700_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r700_set_no_entry_1()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '5' THEN                                                                                                        
#          LET tm2.s1 = ' '                                                                                                          
#       END IF                                                                                                                       
#       IF tm2.s2 = '5' THEN                                                                                                        
#          LET tm2.s2 = ' '                                                                                                          
#       END IF                                                                                                                       
#       IF tm2.s3 = '5' THEN                                                                                                       
#          LET tm2.s2 = ' '                                                                                                          
#       END IF
#    END IF
#END FUNCTION
#FUNCTION r700_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr102' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr103' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
FUNCTION axrr700()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680123 VARCHAR(20) # External(Disk) file name
          l_sql     LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(40)
          l_dbs     LIKE type_file.chr21,        #No.FUN-680123 VARCHAR(22)
          l_i       LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_oma03   LIKE oma_file.oma03,
         #CHI-B30021 mark --start--
         #l_oma15   LIKE oma_file.oma15,         #FUN-8C0018
         #l_oma14   LIKE oma_file.oma14,         #FUN-8C0018
         #l_oma09   LIKE oma_file.oma09,         #FUN-8C0018
         #CHI-B30021 mark --end--
          l_oma032  LIKE oma_file.oma032,        #No:7700
          l_amt1    LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
          l_amt2    LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
          l_amt3    LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
          j         LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          sr        RECORD
                    oma00  LIKE oma_file.oma00,
                    oma34  LIKE oma_file.oma34,   #MOD-780074
                    oma23  LIKE oma_file.oma23,   #MOD-810180
                    oma03  LIKE oma_file.oma03,  #客戶編號
                    oma032 LIKE oma_file.oma032, #客戶簡稱
                    omb12  LIKE omb_file.omb12,
                    omb14  LIKE omb_file.omb14,   #MOD-810180
                    omb16  LIKE omb_file.omb16
                    END RECORD,
          sr1       RECORD
                    oma03   LIKE oma_file.oma03,        #客戶編號
                    oma032  LIKE oma_file.oma032,       #客戶簡稱
#                    A1      LIKE ima_file.ima26,        #No.FUN-680123 DEC(15,3) #FUN-A20044
                    A1      LIKE type_file.num15_3,        #No.FUN-680123 DEC(15,3) #FUN-A20044
                    A2      LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
#                    B1      LIKE ima_file.ima26,        #No.FUN-680123 DEC(15,3) #FUN-A20044
                    B1      LIKE type_file.num15_3,        #No.FUN-680123 DEC(15,3) #FUN-A20044
                    B2      LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
                    C2      LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
#                    D1      LIKE ima_file.ima26,        #No.FUN-680123 DEC(15,3)     #FUN-A20044
                    D1      LIKE type_file.num15_3,        #No.FUN-680123 DEC(15,3)     #FUN-A20044
                    D2      LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
                    amt     LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
                    percent LIKE type_file.num20_6      #FUN-710080 add
                    END RECORD
     DEFINE l_rate  LIKE oma_file.oma24   #MOD-810180
     DEFINE l_azp03   LIKE azp_file.azp03   #FUN-8C0018
     DEFINE l_j       LIKE type_file.num5   #FUN-8C0018
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin     
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
 
#  FOR l_j = 1 to 8
#      IF cl_null(m_dbs[l_j]) THEN CONTINUE FOR END IF
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_j]
#      LET l_azp03 = l_dbs CLIPPED
#      LET l_dbs = s_dbstring(l_dbs CLIPPED) 
#FUN-BB0173 add START
    LET l_j = 1
    FOR l_j = 1 TO g_ary_i
       IF cl_null(g_ary[l_j].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END 
        #LET l_sql="SELECT oma00,oma34,oma23,oma03,oma032,omb12,omb14,omb16,oma15,oma14,oma09",   #MOD-780074   #MOD-810180 #FUN-8C0018 #CHI-B30021 mark
         LET l_sql="SELECT oma00,oma34,oma23,oma03,oma032,omb12,omb14,omb16",   #CHI-B30021
#                  "  FROM ",l_dbs CLIPPED,"oma_file,",l_dbs CLIPPED,"omb_file",
                  #"  FROM oma_file,omb_file",  #FUN-BB0173 mark
                   "  FROM ",cl_get_target_table(g_ary[l_j].plant,'oma_file'),  #FUN-BB0173 add
                   "      ,",cl_get_target_table(g_ary[l_j].plant,'omb_file'),  #FUN-BB0173 add
                   " WHERE ",tm.wc CLIPPED,
                   "   AND oma01 = omb01 ",
                   "   AND omavoid = 'N' ",
                   "   AND omaconf = 'Y'   ",
                   "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "   AND oma00 IN ('12','21','22','25') ",
                   "   AND omb04[1,4] != 'MISC' ",   #MOD-B50150 
                   " ORDER BY oma03 "    #No:7700
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr700_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
         END IF
         DECLARE axrr700_curs1 CURSOR FOR axrr700_prepare1
        #FOREACH axrr700_curs1 INTO sr.*,l_oma15,l_oma14,l_oma09  #FUN-8C0018 #CHI-B30021 mark
         FOREACH axrr700_curs1 INTO sr.*  #CHI-B30021
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF cl_null(sr.omb12) THEN LET sr.omb12=0 END IF
            IF cl_null(sr.omb16) THEN LET sr.omb16=0 END IF
            IF sr.oma23 <> tm.oma23 THEN
               LET l_rate = s_curr3(tm.oma23,g_today,'B')
               LET sr.omb16 = sr.omb16 / l_rate
            ELSE
               LET sr.omb16 = sr.omb14
            END IF
            IF STATUS = 0 THEN
                                    #sr.omb12,sr.omb16,sr.plant)   #MOD-810180
               INSERT INTO x VALUES(sr.oma00,sr.oma34,sr.oma23,sr.oma03,sr.oma032,   #MOD-810180
                                   #sr.omb12,sr.omb14,sr.omb16,l_oma15,l_oma14,l_oma09)   #MOD-810180  #FUN-8C0018 #CHI-B30021 mark
                                    sr.omb12,sr.omb14,sr.omb16)   #CHI-B30021
               SELECT COUNT(*) INTO l_i FROM y
                WHERE y03 = sr.oma03
                  AND y032= sr.oma032   #No:7700
               IF l_i = 0 OR cl_null(l_i) THEN
                  INSERT INTO y VALUES(sr.oma03,sr.oma032,0,0,0,0,0)       #No.TQC-970054
               END IF
            END IF
         END FOREACH
 
     LET l_sql = "SELECT x03,x032,SUM(xb12),SUM(xb16) FROM x", #No:7700
                 " WHERE x00 = '12' ",
                 " GROUP BY x03,x032 ",  #No:7700
                 " ORDER BY x03,x032"    #No:7700
     PREPARE axrr700_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr700_curs2 CURSOR FOR axrr700_prepare2
     FOREACH axrr700_curs2 INTO l_oma03,l_oma032,l_amt1,l_amt2  #No:7700
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
        IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
        UPDATE y SET yA1 = l_amt1, yA2 = l_amt2
         WHERE y03 = l_oma03 AND y032=l_oma032    #No:7700
     END FOREACH
 
     LET l_sql = "SELECT x03,x032,SUM(xb12),SUM(xb16) FROM x", #No:7700
                 " WHERE x00 = '21' AND x34 <> '5' ",   #MOD-780074
                 " GROUP BY x03,x032 ",  #No:7700
                 " ORDER BY x03,x032 "   #No:7700
     PREPARE axrr700_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr700_curs3 CURSOR FOR axrr700_prepare3
     FOREACH axrr700_curs3 INTO l_oma03,l_oma032,l_amt1,l_amt2  #No:7700
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF l_amt1 IS NULL THEN LET l_amt1 = 0 END IF
        IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
        UPDATE y SET yB1 = l_amt1, yB2 = l_amt2
         WHERE y03 = l_oma03 AND y032 = l_oma032  #No:7700
     END FOREACH
 
     LET l_sql = "SELECT x03,x032,SUM(xb16) FROM x",  #No:7700
                 " WHERE x00 = '22' OR x00 = '25' OR (x00 = '21' AND x34 = '5')",   #MOD-780074
                 " GROUP BY x03,x032 ",   #No:7700
                 " ORDER BY x03,x032 "    #No:7700
     PREPARE axrr700_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr700_curs4 CURSOR FOR axrr700_prepare4
     FOREACH axrr700_curs4 INTO l_oma03,l_oma032,l_amt2
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
        UPDATE y SET yC2 = l_amt2
         WHERE y03 = l_oma03 AND y032=l_oma032   #No:7700
     END FOREACH
 
     SELECT SUM(xb16) INTO l_amt1 FROM x WHERE x00 = '12'
     SELECT SUM(xb16) INTO l_amt2 FROM x WHERE x00 = '21' AND x34 <> '5'  #MOD-780074
     SELECT SUM(xb16) INTO l_amt3 FROM x WHERE x00 = '22' OR x00 = '25' OR (x00 = '21' AND x34 = '5')  #MOD-780074
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
     IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
 
     LET l_sql = "SELECT DISTINCT x03,x032,yA1,yA2,",
                 "                yB1,yB2,yC2,'','','','' ",   #FUN-710080
                 "  FROM x,OUTER y ",
                 " WHERE x.x03 = y.y03 ",
                 "   AND x032 = y032 ",   #No:7700
                 " ORDER BY x03,x032 "    #No:7700
     PREPARE axrr700_prepare5 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr700_curs5 CURSOR FOR axrr700_prepare5
     FOREACH axrr700_curs5 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF sr1.A1 IS NULL THEN LET sr1.A1 = 0 END IF
        IF sr1.A2 IS NULL THEN LET sr1.A2 = 0 END IF
        IF sr1.B1 IS NULL THEN LET sr1.B1 = 0 END IF
        IF sr1.B2 IS NULL THEN LET sr1.B2 = 0 END IF
        IF sr1.C2 IS NULL THEN LET sr1.C2 = 0 END IF
        LET sr1.D1 = sr1.A1 - sr1.B1
        LET sr1.D2 = sr1.A2 - sr1.B2 - sr1.C2
        LET sr1.amt = l_amt1 - l_amt2 - l_amt3
        #LET sr1.percent = sr1.D2 / sr1.amt   #FUN-710080 add
        LET sr1.percent = sr1.D2 / sr1.amt * 100  #TQC-BB0082
 
        INSERT INTO z VALUES(sr1.oma03,sr1.oma032,sr1.A1,sr1.A2,
                             sr1.B1,sr1.B2,sr1.C2,sr1.D1,sr1.D2,
                             sr1.amt,sr1.percent)
     END FOREACH
 
     LET l_sql = "SELECT * FROM z",
#                " ORDER BY percent DESC"   #TQC-950152                                                                             
                 " ORDER BY percent_1 DESC"   #TQC-950152     
     PREPARE axrr700_prepare6 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr700_curs6 CURSOR FOR axrr700_prepare6
     LET g_rank = 0 #CHI-B20010 add 
     FOREACH axrr700_curs6 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_rank = g_rank + 1
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
        IF sr1.D2 <= tm.pramt THEN 
           CONTINUE FOREACH
        END IF
        IF g_rank > tm.prno THEN
           EXIT FOREACH
        END IF
        EXECUTE insert_prep USING
           g_rank ,sr1.oma03,sr1.oma032,sr1.A1,sr1.A2,
           sr1.B1 ,sr1.B2   ,sr1.C2    ,sr1.D1,sr1.D2,
#          sr1.amt,sr1.percent,m_dbs[l_j],l_oma15,l_oma14,l_oma09            #FUN-8C0018
          #sr1.amt,sr1.percent,'',l_oma15,l_oma14,l_oma09      #CHI-B30021 mark 
          #sr1.amt,sr1.percent,''                              #CHI-B30021  #FUN-BB0173 mark
           sr1.amt,sr1.percent,g_ary[l_j].plant                #FUN-BB0173 add 
        #------------------------------ CR (3) ------------------------------#
     END FOREACH 
       #CHI-B20010 add --start--
       DELETE FROM x
       DELETE FROM y
       DELETE FROM z
       #CHI-B20010 add --end--
#   END FOR                      #FUN-8C0018
    END FOR   #FUN-BB0173 add
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01=tm.oma23   #MOD-810180
     LET g_str = tm.bdate,";",tm.edate,";",t_azi04,";",tm.oma23,";",t_azi05     #CHI-7B0027      #MOD-810180
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oma03,oma15,oma14,oma23,oma09')
             RETURNING tm.wc
#       LET g_str = g_str ,";",tm.wc,";",tm.b,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u   #No.FUN-8C0018
       #LET g_str = g_str ,";",tm.wc,";",'',";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u #CHI-B20010 mark
        LET g_str = g_str ,";",tm.wc,";",'' #CHI-B20010
     END IF
#    IF tm.b = 'N' THEN                                                  #No.FUN-8C0018
       #CALL cl_prt_cs3('axrr700','axrr700',l_sql,g_str) markmark
#    ELSE                                                                #No.FUN-8C0018
#       CALL cl_prt_cs3('axrr700','axrr700_1',l_sql,g_str)               #No.FUN-8C0018
#    END IF                                                              #No.FUN-8C0018
#FUN-BB0173 add START
     IF g_flag = 'Y' THEN
        CALL cl_prt_cs3('axrr700','axrr700',l_sql,g_str)
     ELSE
        CALL cl_prt_cs3('axrr700','axrr700_1',l_sql,g_str)
     END IF
#FUN-BB0173 add END
     #------------------------------ CR (4) ------------------------------#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
END FUNCTION
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r700_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("Group1",FALSE)
     LET g_flag = 'Y'  #流通
     LET g_ary_i = 1
     LET g_ary[g_ary_i].plant = g_plant      #流通業則將array存入 g_plant
  END IF
  RETURN l_cnt
END FUNCTION

#將plant放入array
FUNCTION r700_legal_db(p_string)
DEFINE p_string  STRING
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azw09   LIKE azw_file.azw09
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_sql     STRING
   IF cl_null(p_string) THEN
      LET p_string = g_plant
   END IF
   LET g_ary_i = 1
   LET g_errno = ' '

   LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
               "  WHERE azw01 IN ( ",p_string," ) "
   PREPARE r140_azw01_pre FROM l_sql
   DECLARE r140_azw01_cs CURSOR FOR r140_azw01_pre
   FOREACH r140_azw01_cs INTO g_ary[g_ary_i].plant
      LET g_ary_i = g_ary_i + 1
   END FOREACH
   LET g_ary_i = g_ary_i - 1

END FUNCTION
#FUN-BB0173 add END
#No.FUN-9C0072 精簡程式碼 
