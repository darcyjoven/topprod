# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: aglr102.4gl
# Descriptions...: 營業成本明細表
#................: 00/12/15 By Mandy
# Modify.........: No.8729 03/12/02 By Kitty 印出抬頭~但為何抬頭後面有金額0
# Modify.........: No.FUN-510007 05/02/17 By Nicola 報表架構修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型    
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/09 By lora    會計科目加帳套
# Modify.........: No.TQC-760105 07/06/13 By arman   互換報表結構與帳號的位置，使得先輸入帳號 
# Modify.........: No.FUN-780058 07/08/29 By sherry 報表改寫由Crystal Report產出
# Modify.........: No.MOD-830131 08/03/17 By Smapmin 變數未給預設值
# Modify.........: No.MOD-920312 09/02/24 By Dido 修改 maj02 宣告
# Modify.........: No.MOD-970245 09/07/27 By mike 將aglr102_file里的maj20e改為定義成LIKE maj_file.maj20e  
# Modify.........: No.MOD-980081 09/08/24 By mike r102_sum 的sql 條件少了 "   AND aah00 = aag00 ", 煩請協助,謝謝!
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No:CHI-A40035 10/04/29 By liuxqa 追单MOD-970225
# Modify.........: No:CHI-A70061 10/08/25 By Summer 先列印空白再列印資料
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No:MOD-D30259 13/03/29 By apo 修改計算餘額型態的位置
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 a       LIKE mai_file.mai01,  #報表結構編號 #No.FUN-680098  VARCHAR(6) 
                 b       LIKE aaa_file.aaa01,  #帳別編號     #No.FUN-670039   
                 yy      LIKE type_file.num5,  #輸入年度     #No.FUN-680098  smallint
                 bm      LIKE type_file.num5,  #Begin 期別   #No.FUN-680098  smallint
                 em      LIKE type_file.num5,  # End  期別   #No.FUN-680098  smallint
                 c       LIKE type_file.chr1,  #異動額及餘額為0者是否列印   #No.FUN-680098  VARCHAR(1)  
                 d       LIKE type_file.chr1,  #金額單位  #No.FUN-680098    VARCHAR(1) 
                 e       LIKE type_file.chr1,  #列印額外名稱 #FUN-6C0012
                 f       LIKE type_file.num5,          #列印最小階數   #No.FUN-680098    smallint
                 more    LIKE type_file.chr1           #Input more condition(Y/N)   #No.FUN-680098  VARCHAR(1) 
              END RECORD,
          g_bookno   LIKE aah_file.aah00,   #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,  
          g_unit     LIKE type_file.num10,            #金額單位基數 #No.FUN-680098  integer
          i,j,k,g_mm LIKE type_file.num5,             #No.FUN-680098   smallint
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6  #No.FUN-680098  decimal(20,6) 
DEFINE   g_aaa03         LIKE aaa_file.aaa03   
#No.FUN-780058---Begin                                                       
DEFINE l_table         STRING                                                
DEFINE g_sql           STRING                                                
DEFINE g_str           STRING                                                
#No.FUN-780058---End      
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-780058---Begin                                                       
   LET g_sql = "maj20.maj_file.maj20,",                                         
               "maj20e.maj_file.maj20e,",                                       
               "maj02.maj_file.maj02,",   #項次(排序要用的)                     
               "maj03.maj_file.maj03,",   #列印碼                               
               "aah04_05.aah_file.aah04,",    #金額  
               "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空    
                                                                                
   LET l_table = cl_prt_temptable('aglr102',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?)"                                
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #No.FUN-780058---End                   
                                         
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.yy   = ARG_VAL(10)
   LET tm.bm   = ARG_VAL(11)
   LET tm.em   = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.d    = ARG_VAL(14)
   LET tm.f    = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   LET tm.e    = ARG_VAL(19)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
 
   DROP TABLE aglr102_file
#FUN-680098-BEGIN
   CREATE TEMP TABLE aglr102_file(
       maj02   LIKE maj_file.maj02,  #MOD-920312 修改 cot_file.cot12
       maj03   LIKE maj_file.maj03,
       maj04   LIKE maj_file.maj04,
       maj05   LIKE maj_file.maj05,
       maj07   LIKE maj_file.maj07,
       maj20   LIKE maj_file.maj20,
       maj20e  LIKE maj_file.maj20e, #MOD-970245 abh11-->maj20e
       aah04_05  LIKE type_file.num20_6)
#FUN-680098-END
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF #預設帳別
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF #預設帳別    #NO.FUN-740020
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r102_tm()                        # Input print condition
   ELSE
      CALL r102()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r102_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  SMALLINT
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白 #No.FUN-680098  VARCHAR(1) 
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400) 
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-670005   #No.FUN-680098  smallint
   DEFINE li_result      LIKE type_file.num5          #No.FUN-6C0068
   CALL s_dsmark(g_bookno)
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r102_w AT p_row,p_col WITH FORM "agl/42f/aglr102" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF #預設帳別    #NO.FUN-740020
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)  # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   # NO.FUN-660123
   END IF
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03        #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0)   # NO.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   # NO.FUN-660123
   END IF
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.a = ' '
#   LET tm.b = g_bookno #預設帳別   #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.f = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
    LET l_sw = 1
#   INPUT BY NAME tm.a,tm.b,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.e,tm.more   #FUN-6C0012
    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.f,tm.d,tm.c,tm.e,tm.more   #TQC-760105
         WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
 
      AFTER FIELD a #報表結構編號
         IF NOT cl_null(tm.a) THEN
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0)  # NO.FUN-660123
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   # NO.FUN-660123
               NEXT FIELD a 
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
         END IF
 
      AFTER FIELD b #帳別編號
         IF NOT cl_null(tm.b) THEN
         #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end 
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
#              CALL cl_err('sel aaa:',STATUS,0) # NO.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   # NO.FUN-660123
               NEXT FIELD b 
            END IF
         END IF
 
      AFTER FIELD yy #年度
         IF NOT cl_null(tm.yy) AND tm.yy = 0 THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD bm #起始期別
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#         IF NOT cl_null(tm.bm) AND ( tm.bm <1 OR tm.bm > 13 ) THEN
#            #期別範圍錯誤,請輸入1-13間的值!!
#            CALL cl_err('','agl-013',0) NEXT FIELD bm
#         END IF
#No.TQC-720032 -- end --
  
      AFTER FIELD em #截止期別
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#         IF NOT cl_null(tm.em) AND ( tm.em <1 OR tm.em > 13 ) THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD f  #列印最小階數
         IF cl_null(tm.f) OR tm.f < 0  THEN
            LET tm.f = 0 DISPLAY BY NAME tm.f NEXT FIELD f
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.yy) THEN
            LET l_sw = 0 
            DISPLAY BY NAME tm.yy 
            CALL cl_err('',9033,0)
         END IF
         IF cl_null(tm.bm) THEN
            LET l_sw = 0 
            DISPLAY BY NAME tm.bm 
         END IF
         IF cl_null(tm.em) THEN
            LET l_sw = 0 
            DISPLAY BY NAME tm.em 
        END IF
 
        #---->金額單位換算
        CASE tm.d
            WHEN '1'
                 LET g_unit = 1        #元
            WHEN '2'
                 LET g_unit = 1000     #千
            WHEN '3'
                 LET g_unit = 1000000  #百萬
        END CASE
 
        IF l_sw = 0 THEN 
            LET l_sw = 1 
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(a) 
#           CALL q_mai(0,0,tm.a,tm.a) RETURNING tm.a  
#           CALL FGL_DIALOG_SETBUFFER( tm.a )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
            LET g_qryparam.where = "mai03 NOT IN ('5','6')" #No.TQC-C50042   Add
            CALL cl_create_qry() RETURNING tm.a 
#            CALL FGL_DIALOG_SETBUFFER( tm.a )
            DISPLAY BY NAME tm.a
            NEXT FIELD a
 
         WHEN INFIELD(b) 
#           CALL q_aaa(0,0,tm.b) RETURNING tm.b
#           CALL FGL_DIALOG_SETBUFFER( tm.b )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.b
            CALL cl_create_qry() RETURNING tm.b 
#            CALL FGL_DIALOG_SETBUFFER( tm.b )
            DISPLAY BY NAME tm.b
            NEXT FIELD b
       END CASE
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r102_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr102'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr102','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",           #FUN-6C0012
                         " '",tm.f CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr102',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r102()
   ERROR ""
END WHILE
   CLOSE WINDOW r102_w
END FUNCTION
 
FUNCTION r102()
   DEFINE l_name    LIKE type_file.chr20       # External(Disk) file name        #No.FUN-680098 VARCHAR(20) 
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000     # RDSQL STATEMENT        #No.FUN-680098   VARCHAR(1000)  
   DEFINE l_chr     LIKE type_file.chr1        #No.FUN-680098   VARCHAR(1) 
   DEFINE l_leng,l_leng2    LIKE type_file.num5     #No.FUN-680098  smallint
   DEFINE l_abe03   LIKE abe_file.abe03  #部門代號
   DEFINE l_abd02   LIKE abd_file.abd02  #部門編號
   DEFINE l_gem02   LIKE gem_file.gem02  #部門名稱
   DEFINE l_dept    LIKE gem_file.gem01  #部門編號
   DEFINE l_maj20   LIKE maj_file.maj20 #科目列印名稱   #No.FUN-680098 VARCHAR(30) 
   DEFINE sr        RECORD
                       maj02     LIKE maj_file.maj02,   #項次
                       maj03     LIKE maj_file.maj03,   #列印碼
                       maj04     LIKE maj_file.maj04,   #空行數
                       maj05     LIKE maj_file.maj05,   #空格數
                       maj07     LIKE maj_file.maj07,   #正常餘額型態 (1.借餘/2.貸餘)
                       maj20     LIKE maj_file.maj20,   #科目列印名稱
                       maj20e    LIKE maj_file.maj20e,  #額外列印名稱
                       aah04_05  LIKE aah_file.aah04    #實際金額
                    END RECORD
   DEFINE g_i       LIKE type_file.num5   #MOD-830131
 
   CALL cl_del_data(l_table)               #No.FUN-780058        
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b  #aaf03帳別名稱
      AND aaf02 = g_rlang
   
   #-----MOD-830131---------
   FOR g_i = 1 TO 100 
       LET g_tot1[g_i] = 0
   END FOR
   #-----END MOD-830131-----
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' AND maj23[1,1]='2' ", #maj23[1,1]='2'損益表科目
               " ORDER BY maj02"
   PREPARE r102_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r102_c CURSOR FOR r102_p
 
   #No.FUN-780058---Begin
   #CALL cl_outnam('aglr102') RETURNING l_name
   
   #No.FUN-6C0012 --start--                                                     
   #IF tm.e = 'Y' THEN                                                           
   #   LET g_zaa[31].zaa06 = 'Y'                                                 
   #ELSE                                                                         
   #   LET g_zaa[33].zaa06 = 'Y'                                                 
   #END IF                                                                       
   #No.FUN-780058---End                                                                             
   CALL cl_prt_pos_len()                                                        
   #No.FUN-6C0012 --end--
 
   DROP TABLE aglr102_file
#FUN-680098-BEGIN
   CREATE TEMP TABLE aglr102_file(
       maj02  LIKE maj_file.maj02,  #MOD-920312 修改 cot_file.cot12
       maj03  LIKE maj_file.maj03,
       maj04  LIKE maj_file.maj04,
       maj05  LIKE maj_file.maj05,
       maj07  LIKE maj_file.maj07,
       maj20  LIKE maj_file.maj20,
       maj20e LIKE maj_file.maj20e, #MOD-970245 abh11-->maj20e
       aah04_05  LIKE type_file.num20_6)
#FUN-680098-END
   #START REPORT r102_rep TO l_name              #No.FUN-780058 
   #LET g_pageno = 0                             #No.FUN-780058 
 
   #---->抓取maj_file的資料,並做與aah_file的處理
   CALL r102_process()
 
   DECLARE tmp_curs CURSOR FOR
       SELECT * FROM aglr102_file ORDER BY maj02
 
   FOREACH tmp_curs INTO sr.*
       #No.FUN-780058---Begin
       LET sr.maj20 = sr.maj05 SPACES,sr.maj20       
 
       IF sr.maj04 = 0 THEN                                                     
          EXECUTE insert_prep USING                                              
            sr.maj20,sr.maj20e,sr.maj02,sr.maj03,                           
            sr.aah04_05,                                
            '2'                                                                 
       ELSE                                                                      
         EXECUTE insert_prep USING                                              
            sr.maj20,sr.maj20e,sr.maj02,sr.maj03,                           
            sr.aah04_05,      
            '2'                                                                 
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
         #讓空行的這筆資料排在正常的資料前面印出                                
         FOR i = 1 TO sr.maj04                                                 
            EXECUTE insert_prep USING                                           
               sr.maj20,sr.maj20e,sr.maj02,'',                               
               '0','1'  #CHI-A70061 mod '0'->'1'
         END FOR 
       END IF                      
       #OUTPUT TO REPORT r102_rep(sr.*)
       #No.FUN-780058---End
   END FOREACH
 
   #No.FUN-780058---Begin  
   #FINISH REPORT r102_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET g_str = g_mai02,";",tm.a,";",tm.d,";",tm.yy,";",                
               tm.bm,";",tm.em,";",tm.e,";",t_azi04                                                
   CALL cl_prt_cs3('aglr102','aglr102',g_sql,g_str)                             
   #No.FUN-780058---End     
END FUNCTION
 
FUNCTION r102_process()
   DEFINE l_sql,l_sql1   LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(300) 
   DEFINE l_cn           LIKE type_file.num5      #No.FUN-680098  smallint
   DEFINE l_amt1         LIKE aah_file.aah04
   DEFINE l_maj          RECORD LIKE maj_file.*
   DEFINE l_mm           LIKE type_file.num5     #No.FUN-680098   smallint
   DEFINE l_aah04_05     LIKE aah_file.aah04
   DEFINE l_aah04_05_sum LIKE aah_file.aah04
   DEFINE l_maj08_last LIKE maj_file.maj08                                                                                                                                                                                                                                                                        
 
#----------- sql for sum(aah04 - aah05)-----------------------------------
#--str CHI-A40035 mark -- 
#    LET l_sql = "SELECT SUM(aah04 - aah05) FROM aah_file,aag_file",
#                " WHERE aah00 = ? AND aah01 BETWEEN ? AND ? ",
#                "   AND aah02 = ? ",
#                "   AND aah03 BETWEEN ? AND ? ",
#                "   AND aah00 = aag00 ", #MOD-980081   
#                "   AND aah01 = aag01   AND aag07 IN ('2','3')"    
#    LET l_sql = l_sql CLIPPED
# 
#    PREPARE r102_sum FROM l_sql
#    DECLARE r102_sumc CURSOR FOR r102_sum
##    IF STATUS THEN CALL cl_err('prepare:r102_sum',STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#       EXIT PROGRAM 
#    END IF
 
#----------- sql for sum(aah04 - aah05)------Sum 期初---------------------
 
#    LET l_sql = "SELECT SUM(aah04 - aah05) FROM aah_file,aag_file",
#                " WHERE aah00 = ? AND aah01 BETWEEN ? AND ? ",
#                "   AND aah02 = ? ",
#                "   AND aah03 <= ? ",
#                "   AND aah01 = aag01  AND aah00=aag00 AND aag07 IN ('2','3')"  #No.FUN-740020
#    LET l_sql = l_sql CLIPPED
 
#    PREPARE r102_sum1 FROM l_sql
#    DECLARE r102_sumc1 CURSOR FOR r102_sum1
#    IF STATUS THEN CALL cl_err('prepare:r102_sum1',STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#       EXIT PROGRAM 
#    END IF
#end CHI-A40035 --mark
 
    FOREACH r102_c INTO l_maj.*
       IF STATUS THEN CALL cl_err('foreach:r102_c',STATUS,1) EXIT FOREACH END IF
       
       LET l_aah04_05 = 0
       IF NOT cl_null(l_maj.maj21) THEN 
          #str CHI-A40035 mark
          #IF l_maj.maj06 = '2' THEN      #2:科目之當期異動
          #    OPEN r102_sumc USING tm.b,l_maj.maj21,l_maj.maj22,tm.yy,tm.bm,tm.em
          #    FETCH r102_sumc INTO l_aah04_05   
          #ELSE
          #    IF l_maj.maj06 = '1' THEN  #1:科目之期初(借減貸)
          #        LET l_mm = tm.bm-1 
          #    ELSE                       #3:科目之期末(借減貸)
          #        LET l_mm = tm.em 
          #    END IF
          #    OPEN r102_sumc1 USING tm.b,l_maj.maj21,l_maj.maj22,tm.yy,l_mm
          #    FETCH r102_sumc1 INTO l_aah04_05    
          #END IF
          #IF STATUS THEN CALL cl_err('fetch:r102_sumc',STATUS,1) EXIT FOREACH END IF
          #end CHI-A40035 mark
          #str CHI-A40035 add
          CASE l_maj.maj06
             WHEN 1   #1:科目之期初(借減貸)
               LET l_sql = "SELECT SUM(aah04-aah05) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03 < '",tm.bm,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 2   #2:科目之當期異動
               LET l_sql = "SELECT SUM(aah04-aah05) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 3   #3:科目之期末(借減貸)
               LET l_sql = "SELECT SUM(aah04-aah05) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03<= '",tm.em,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 4   #4:科目之當期異動(借)
               LET l_sql = "SELECT SUM(aah04) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 5   #5:科目之當期異動(貸)
               LET l_sql = "SELECT SUM(aah05) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 6   #6:科目之期初(借)
               LET l_sql = "SELECT SUM(aah04) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03 < '",tm.bm,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 7   #7:科目之期初(貸)
               LET l_sql = "SELECT SUM(aah05) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03 < '",tm.bm,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 8   #8:科目之期末(借)
               LET l_sql = "SELECT SUM(aah04) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03<= '",tm.em,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
             WHEN 9   #9:科目之期末(貸)
               LET l_sql = "SELECT SUM(aah05) FROM aah_file,aag_file",
                           " WHERE aah00 = '",tm.b,"'",
                           "   AND aah01 BETWEEN ? AND ? ",
                           "   AND aah02 = '",tm.yy,"'",
                           "   AND aah03<= '",tm.em,"'",
                           "   AND aah00 = aag00 ",
                           "   AND aah01 = aag01 AND aag07 IN ('2','3')"
          END CASE
          IF cl_null(l_maj.maj06) THEN
             LET l_sql = ''
             CONTINUE FOREACH
          END IF
          PREPARE r102_sum FROM l_sql
          DECLARE r102_sumc CURSOR FOR r102_sum
          OPEN r102_sumc USING l_maj.maj21,l_maj.maj22
          FETCH r102_sumc INTO l_aah04_05
         #end CHI-A40035 add
          
          IF cl_null(l_aah04_05) THEN LET l_aah04_05 = 0 END IF
       END IF
      #--MOD-D30259 mark--
      ##---->正常餘額型態  
      #IF l_maj.maj07 = '2' THEN #2:貸餘
      #    IF l_aah04_05 < 0 THEN 
      #        LET l_aah04_05 = l_aah04_05 * (-1) 
      #    END IF
      #END IF
      #--MOD-D30259 mark--
       #---->合計階數處理
       IF l_maj.maj03 MATCHES "[012]" AND l_maj.maj08 > 0 THEN   #合計階數處理
           FOR i = 1 TO 100
               LET l_amt1 = l_aah04_05
               IF l_maj.maj09 = '-' THEN  # Thomas 99/01/12
                   LET g_tot1[i] = g_tot1[i] - l_amt1     #科目餘額
               ELSE
                   LET g_tot1[i] = g_tot1[i] + l_amt1     #科目餘額
               END IF
           END FOR
           LET k = l_maj.maj08
           LET l_aah04_05 = g_tot1[k]
           FOR i = 1 TO k LET g_tot1[i] = 0 END FOR
       END IF
 
       #---->本行不印出
       IF l_maj.maj03 = '0' THEN CONTINUE FOREACH END IF 
 
       #---->餘額為 0 者不列印
       IF (tm.c = 'N' OR l_maj.maj03 = '2') AND
          l_maj.maj03 MATCHES "[0125]" AND l_aah04_05 = 0 THEN         #CHI-CC0023 add maj03 match 5
           CONTINUE FOREACH                              
       END IF
 
       #---->最小階數起列印
       IF tm.f > 0 AND l_maj.maj08 < tm.f THEN
           CONTINUE FOREACH                              
       END IF
	   
      #--MOD-D30259 ----- (S)
       #---->正常餘額型態  
       IF l_maj.maj07 = '2' THEN #2:貸餘
          LET l_aah04_05 = l_aah04_05 * (-1) 
       END IF
      #--MOD-D30259 ----- (E)
       
       #---->金額單位換算
       LET l_aah04_05 = l_aah04_05 / g_unit
 
       INSERT INTO aglr102_file VALUES(l_maj.maj02,l_maj.maj03,l_maj.maj04,
                                    l_maj.maj05,l_maj.maj07,l_maj.maj20,l_maj.maj20e,
                                    l_aah04_05)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err('ins aglr102_file',STATUS,1) #No.FUN-660123
           CALL cl_err3("ins","aglr102_file",l_maj.maj02,l_maj.maj03,STATUS,"","ins aglr102_file",1)   #No.FUN-660123
           EXIT FOREACH 
       END IF
    END FOREACH
END FUNCTION
 
#No.FUN-780058---Begin
#REPORT r102_rep(sr)
#  DEFINE l_last_sw   LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1) 
#  DEFINE l_unit      LIKE zaa_file.zaa08      #No.FUN-680098   VARCHAR(6) 
#  DEFINE per1        LIKE fid_file.fid03     #No.FUN-680098   dec(8,3)
#  DEFINE l_gem02      LIKE gem_file.gem02
#  DEFINE sr           RECORD
#                         maj02     LIKE maj_file.maj02,
#                         maj03     LIKE maj_file.maj03,
#                         maj04     LIKE maj_file.maj04,
#                         maj05     LIKE maj_file.maj05,
#                         maj07     LIKE maj_file.maj07,
#                         maj20     LIKE maj_file.maj20,
#                         maj20e    LIKE maj_file.maj20e,
#                         aah04_05  LIKE aah_file.aah04    #實際金額
#                      END RECORD,
#         l_j          LIKE type_file.num5,          #No.FUN-680098  smallint
#         i            LIKE type_file.num5,          #No.FUN-680098  smallint
#         l_x          LIKE type_file.chr50          #No.FUN-680098  VARCHAR(40) 
#  DEFINE g_head1      STRING            
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin 
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.maj02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        IF g_aaz.aaz77 = 'Y' THEN
#           LET g_x[1] = g_mai02
#        END IF
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        #金額單位之列印
#        CASE tm.d
#             WHEN '1'  LET l_unit = g_x[12]
#             WHEN '2'  LET l_unit = g_x[13]
#             WHEN '3'  LET l_unit = g_x[14]
#             OTHERWISE LET l_unit = ' '
#        END CASE
#        LET g_head1 = g_x[10] CLIPPED,tm.a
#        PRINT g_head1
#        
#       #FUN-660060 start
#        #LET g_head1 = g_x[9] CLIPPED,tm.yy USING '<<<<',
#        #              '/',tm.bm USING'&&','-',tm.em USING'&&','     ',
#        #              g_x[11] CLIPPED ,l_unit
#        LET g_head1 = g_x[9] CLIPPED,tm.yy USING '<<<<',
#                      '/',tm.bm USING'&&','-',tm.em USING'&&'
#        #PRINT g_head1                                         #FUN-660060 remark
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1,'  ',g_x[11] CLIPPED ,l_unit  #FUN-660060
#       #FUN-660060 end
#        PRINT g_dash2[1,g_len]
#        #PRINT g_x[31],g_x[32]           #FUN-6C0012
#        PRINT g_x[31],g_x[33],g_x[32]    #FUN-6C0012
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#    
#     ON EVERY ROW
#        CASE
#           WHEN sr.maj03 = '9'    #9:跳頁,本行印前跳頁
#              SKIP TO TOP OF PAGE
#           WHEN sr.maj03 = '3'    #3:底線,本行印出金額底線
#              PRINT COLUMN g_c[32],g_dash2[1,g_w[32]]
#           WHEN sr.maj03 = 'H'    #H:表頭 No:8729 後面不要印出0
#              FOR i = 1 TO sr.maj04
#                 PRINT END
#              FOR  #空行數
#              #maj05空格數,maj20科目列印名稱
#              LET sr.maj20 = sr.maj05 SPACES,sr.maj20 CLIPPED
#              PRINT COLUMN g_c[31],sr.maj20,
#                    COLUMN g_c[33],sr.maj20e  #FUN-6C0012
#           WHEN sr.maj03 = '4'    #4:橫線,本行印出整排橫線
#              PRINT g_dash2[1,g_len]
#           OTHERWISE 
#              FOR i = 1 TO sr.maj04
#                 PRINT END
#              FOR  #空行數
#              #maj05空格數,maj20科目列印名稱
#              LET sr.maj20 = sr.maj05 SPACES,sr.maj20 CLIPPED
#              PRINT COLUMN g_c[31],sr.maj20,
#                    COLUMN g_c[33],sr.maj20e,   #FUN-6C0012
#                    COLUMN g_c[32],cl_numfor(sr.aah04_05,32,t_azi04)         #No.CHI-6A0004 g_azi-->t_azi 
#        END CASE
#    
#     ON LAST ROW
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF 
#             
#END REPORT
#No.FUN-780058---End
