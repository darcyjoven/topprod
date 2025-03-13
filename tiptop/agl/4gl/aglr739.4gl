# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr739.4gl
# Descriptions...: 全年度損益表
# Input parameter: 
# Return code....: 
# Date & Author..: 92/04/14 By Nora
# Modify.........: 96/02/09 By Danny (在INPUT前加INITIALIZE)
# Modify.........: no.7683 03/07/17 By Kammy 科目原本可選部份(s_part)，
#                  此為 tiptop3.0 舊功能，全部刪除。
# Modify.........: No.MOD-490106 04/09/08 By Nicola maj10已無使用
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗,per配合調整
# Modify.........: No.FUN-510007 05/02/21 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-6C0022 06/12/07 By Smapmin 原程式的寫法會導致抓到明細項, 而非依報表結構(該支程式整體架構已修改)
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-740020 07/04/10 By Lynn 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By johnray 報表結構編號輸入判斷應使用畫面帳套欄位值,而非g_bookno
# Modify.........: No.FUN-780059 07/08/24 By xiaofeizhu 報表改寫由Crystal Report產出
# Modify.........: No.MOD-920224 09/02/18 By Sarah IF tm.h = '1' THEN應改為IF tm.h = 'Y' THEN
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30022 10/03/05 By Cockroch 增加選項【是否列印內部管理科目】--aag38 
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
# Modify.........: No:FUN-D70095 13/07/18 BY fengmy 1.CE類憑證結轉科目部門統計檔，報表列印時應減回CE類憑證
#                                                   2.參照gglq812,修改讀取agli116計算邏輯

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                        # Print condition RECORD
                 a    LIKE gem_file.gem01,  #報表結構編號
                 dept LIKE aao_file.aao02,  #部門  #No.FUN-680098  VARCHAR(10)
                 yy   LIKE aao_file.aao02,  #輸入
                 c    LIKE type_file.chr1,  #異動額及餘額為0者是否列印  #No.FUN-680098   VARCHAR(1)
                 d    LIKE type_file.chr1,  #金額單位                   #No.FUN-680098   VARCHAR(1)
                 e    LIKE type_file.num5,  #小數位數                   #No.FUN-680098   smallint
                 f    LIKE type_file.num5,  #列印最小階數               #No.FUN-680098   smallint
                 h    LIKE type_file.chr1,    #額外說明類別               #No.FUN-680098   VARCHAR(4)       
                 aag38   LIKE aag_file.aag38,  #是否列印內部管理科目   #FUN-A30022 ADD
                 o    LIKE type_file.chr1,  #轉換幣別否                 #No.FUN-680098   VARCHAR(1)
                 p    LIKE azi_file.azi01,  #幣別
                 q    LIKE azj_file.azj03,  #匯率
                 r    LIKE azi_file.azi01,  #幣別
                 more LIKE type_file.chr1,                       #No.FUN-680098  VARCHAR(1)
                 bookno LIKE aaa_file.aaa01 #帳套               #No.TQC-740093
              END RECORD,
      l_buf     ARRAY[300] OF  LIKE type_file.chr1000,          #No.FUN-680098 VARCHAR(300)
          g_unit    LIKE type_file.num10,                       #金額單位基數 #No.FUN-680098        INTEGER
#          g_bookno  LIKE aao_file.aao00,  #帳別                #No.TQC-740093
          g_mai02   LIKE mai_file.mai02,  #報表名稱  
          g_mai03   LIKE mai_file.mai03,  #報表性質  
          g_tot     ARRAY[100] OF   RECORD
                    tot ARRAY[14] OF LIKE aao_file.aao05 #Subtotal
                    END RECORD,
          g_level    LIKE type_file.num5,             #合計小數位數   #No.FUN-680098       SMALLINT 
           g_wc      STRING  #No.FUN-580092 HCN                        #No.FUN-680098
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03   
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098 integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose      #No.FUN-680098 smallint 
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680098   VARCHAR(72)
DEFINE   g_scrno         LIKE type_file.num5     #科目條件之SCREEN ARRAY個數  smallint       #No.FUN-680098        
#--str FUN-780059 add--#                                                                                                            
   DEFINE l_table         STRING                                                                                                    
   DEFINE g_sql           STRING                                                                                                    
   DEFINE g_str           STRING                                                                                                    
#--end FUN-780059 add--#
#MOD-6C0022 start
#No.FUN-D70095  --Begin
   DEFINE g_bal_a     DYNAMIC ARRAY OF RECORD
                      maj02 ARRAY[14] OF LIKE maj_file.maj02,
                      maj03 ARRAY[14] OF LIKE maj_file.maj03,
                      bal1  ARRAY[14] OF LIKE aah_file.aah05,                     
                      maj08 ARRAY[14] OF LIKE maj_file.maj08,
                      maj09 ARRAY[14] OF LIKE maj_file.maj09
                      END RECORD
#No.FUN-D70095  --End  

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 #--str FUN-780059 add--#                                                                                                           
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   LET g_sql = "maj20.maj_file.maj20,",                                                                                             
               "maj20e.maj_file.maj20e,",                                                                                           
               "maj02.maj_file.maj02,",   #項次(排序要用的)                                                                         
               "maj03.maj_file.maj03,",   #列印碼              
               "tot1.aao_file.aao05,",
               "tot2.aao_file.aao05,",
               "tot3.aao_file.aao05,",
               "tot4.aao_file.aao05,",
               "tot5.aao_file.aao05,",
               "tot6.aao_file.aao05,",
               "tot7.aao_file.aao05,",
               "tot8.aao_file.aao05,",
               "tot9.aao_file.aao05,",
               "tot10.aao_file.aao05,",
               "tot11.aao_file.aao05,",
               "tot12.aao_file.aao05,",   
               "tot13.aao_file.aao05,",     
               "tot14.aao_file.aao05,",                                                             
               "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空行                                                      
                                                                                                                                    
   LET l_table = cl_prt_temptable('aglr735',g_sql) CLIPPED   # 產生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                       
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,    #TQC-A40133 mark                                                                        
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                           
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#
 
 
# genero  script marked    LET g_arrno = 30
   LET g_scrno = 6
#   LET g_bookno = ARG_VAL(1)          #No.TQC-740093
   LET tm.bookno = ARG_VAL(1)          #No.TQC-740093
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.dept  = ARG_VAL(9)
   LET tm.yy = ARG_VAL(10)
   LET tm.c  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)
   LET tm.h  = ARG_VAL(14)
   LET tm.o  = ARG_VAL(15)
   LET tm.r  = ARG_VAL(16)   #TQC-610056
   LET tm.p  = ARG_VAL(17)
   LET tm.q  = ARG_VAL(18)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.aag38 = ARG_VAL(23) #FUN-A30022 ADD
#No.TQC-740093  -- begin --
#   IF cl_null(g_bookno) THEN 
#      LET g_bookno = g_aza.aza81     #No.FUN-740020
#   END IF
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF
#No.TQC-740093  -- end --
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL r739_tm()                    # Input print condition
      ELSE
             CALL r739()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r739_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,     #No.FUN-680098  SMALLINT
          l_sw             LIKE type_file.chr1,     #重要欄位是否空白  #No.FUN-680098     VARCHAR(1)   
          l_cmd            LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(400)
   DEFINE li_result        LIKE type_file.num5      #NO.FUN-6C0068
 
#  CALL s_dsmark(g_bookno)    #No.TQC-740093
   CALL s_dsmark(tm.bookno)    #No.TQC-740093
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE
      LET p_row = 4 LET p_col = 11
   END IF
 
   OPEN WINDOW r739_w AT p_row,p_col WITH FORM "agl/42f/aglr739"
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)   #No.TQC-740093
   CALL s_shwact(0,0,tm.bookno)   #No.TQC-740093
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   #使用預設帳別之幣別
   LET tm.bookno = g_aza.aza81  #No.TQC-740093
   SELECT aaa03 INTO g_aaa03 FROM aaa_file
    WHERE aaa01 = tm.bookno     #No.TQC-740093 g_bookno->tm.bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
#     CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123   #No.TQC-740093
      CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)   #No.TQC-740093
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file 
    WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('',SQLCA.sqlcode,0)
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
   END IF
   LET tm.c = 'N'
   LET tm.d = '2'
   LET tm.f = 0
   LET tm.h = 'N'        # NO.FUN-780059   
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.aag38='N'   #FUN-A30022 ADD
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET g_unit  = 1000
WHILE TRUE
   FOR g_i = 1 TO 100
      FOR g_cnt = 1 TO 14 LET g_tot[g_i].tot[g_cnt] = 0 END FOR
   END FOR
   FOR g_cnt = 1 TO 300 INITIALIZE l_buf[g_cnt] TO NULL END FOR
   LET l_sw = 1
   DISPLAY BY NAME tm.c,tm.more             # Condition
   INPUT BY NAME tm.bookno,tm.a,tm.dept,tm.yy,tm.f,tm.d,tm.c,      #No.FUN-740020
                 tm.h,tm.aag38,tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS    #FUNA30022 ADD aag38
      ON ACTION locale
        #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
         EXIT INPUT
 
#No.FUN-740020 ---bengin
      AFTER FIELD bookno
         IF tm.bookno IS NULL THEN
            NEXT FIELD bookno
         END IF
#No.FUN-740020 --end
 
      AFTER FIELD a
         IF tm.a IS NULL THEN NEXT FIELD a END IF
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
            CALL cl_err(tm.a,g_errno,1)
            NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND (mai03='1' OR mai03='3')
            AND mai00 = tm.bookno     #No.FUN-740020
            AND maiacti IN ('Y','y')
         IF SQLCA.sqlcode THEN
#           CALL cl_err(tm.a,'agl-012',0)   #No.FUN-660123
            CALL cl_err3("sel","mai_file",tm.a,"","agl-012","","",0)   #No.FUN-660123
            NEXT FIELD a
         END IF
 
      AFTER FIELD dept
         IF tm.dept IS NULL THEN NEXT FIELD dept END IF
 
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD yy
         IF tm.yy IS NULL OR tm.yy = 0 THEN
            NEXT FIELD yy
         END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF 
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
      AFTER FIELD f
         IF tm.f IS NULL OR tm.f < 0  THEN
            LET tm.f = 0
            DISPLAY BY NAME tm.f
            NEXT FIELD f
         END IF
 
     #FUN-A30022 ADD-------                                                                                                         
      AFTER FIELD aag38                                                                                                             
         IF cl_null(tm.aag38) OR tm.aag38 NOT MATCHES '[YN]' THEN                                                                   
            NEXT FIELD aag38                                                                                                        
         END IF                                                                                                                     
     #FUN-A30022 ADD END-- 

      AFTER FIELD o
         IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
         IF tm.o = 'N' THEN 
            LET tm.p = g_aaa03 
            LET tm.q = 1
            DISPLAY g_aaa03 TO p 
            DISPLAY BY NAME tm.q 
         END IF
 
      BEFORE FIELD p
         IF tm.o = 'N' THEN NEXT FIELD more END IF
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(tm.p,'agl-109',0)   #No.FUN-660123
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
            NEXT FIELD p
         END IF
 
      BEFORE FIELD q
         IF tm.o = 'N' THEN NEXT FIELD o END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.yy IS NULL THEN 
            LET l_sw = 0 
            DISPLAY BY NAME tm.yy 
            CALL cl_err('',9033,0)
         END IF
         IF l_sw = 0 THEN 
            LET l_sw = 1 
            NEXT FIELD a
            CALL cl_err('',9033,0)
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()      # Command execution
 
      ON ACTION CONTROLP
         IF INFIELD(a) THEN
#           CALL q_mai(6,10,tm.a,'13') RETURNING tm.a
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
           #LET g_qryparam.where = " mai00 = '",tm.bookno,"'"     #No.FUN-740020   #No.TQC-C50042   Mark
            LET g_qryparam.where = " mai00 = '",tm.bookno,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
            CALL cl_create_qry() RETURNING tm.a
#           CALL FGL_DIALOG_SETBUFFER( tm.a )
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
         #No.MOD-4C0156 add
         IF INFIELD(bookno) THEN
#           CALL q_aaa(0,0,g_bookno) RETURNING g_bookno
#           CALL FGL_DIALOG_SETBUFFER( g_bookno)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.bookno
            CALL cl_create_qry() RETURNING tm.bookno
#           CALL FGL_DIALOG_SETBUFFER( g_bookno)
            DISPLAY BY NAME tm.bookno
            NEXT FIELD bookno
         END IF
         #No.MOD-4C0156 end
         IF INFIELD(p) THEN
#           CALL q_azi(6,10,tm.p) RETURNING tm.p
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azi'
            LET g_qryparam.default1 = tm.p
            CALL cl_create_qry() RETURNING tm.p
#           CALL FGL_DIALOG_SETBUFFER( tm.p )
            DISPLAY BY NAME tm.p
            NEXT FIELD p
         END IF
 
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
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r739_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
       WHERE zz01='aglr739'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr739','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                    " '",g_bookno CLIPPED,"'" ,       #No.TQC-740093
                     " '",tm.bookno CLIPPED,"'" ,       #No.TQC-740093
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.a CLIPPED,"'",
                     " '",tm.dept CLIPPED,"'",   #TQC-610056
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.c CLIPPED,"'",
                     " '",tm.d CLIPPED,"'",
                     " '",tm.f CLIPPED,"'",
                     " '",tm.h CLIPPED,"'",
                     " '",tm.o CLIPPED,"'",
                     " '",tm.r CLIPPED,"'",   #TQC-610056
                     " '",tm.p CLIPPED,"'",
                     " '",tm.q CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'",           #No.FUN-570264
                     " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                     " '",tm.aag38 CLIPPED,"'"    #FUN-A30022 ADD
         CALL cl_cmdat('aglr739',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r739_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r739()
   ERROR ""
END WHILE
   CLOSE WINDOW r739_w
END FUNCTION
 
FUNCTION r739()
   DEFINE l_name      LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#         l_time      LIKE type_file.chr8        #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,    # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000)
          l_n         LIKE type_file.num5,       #No.FUN-680098 smallint
          l_chr       LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
          l_za05      LIKE za_file.za05,         #No.FUN-680098 VARCHAR(40)
          l_tot       LIKE aao_file.aao05,       #金額
          l_aao04     LIKE aao_file.aao04,       #期別

          sr          RECORD 
                       tot1   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot2   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot3   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot4   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot5   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot6   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot7   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot8   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot9   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot10  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot11  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot12  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot13  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot14  LIKE aao_file.aao05   #合計
                      END RECORD,     
     
          sr2         RECORD 
                       tot1   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot2   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot3   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot4   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot5   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot6   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot7   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot8   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot9   LIKE aao_file.aao05,  #本期餘額(印出)
                       tot10  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot11  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot12  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot13  LIKE aao_file.aao05,  #本期餘額(印出)
                       tot14  LIKE aao_file.aao05   #合計
                      END RECORD,
#---------------FUN-D70095----------(S)         
          sr3       ARRAY[14] OF   RECORD
                    tot     LIKE aao_file.aao05                    
                    END RECORD          
#---------------FUN-D70095----------(E)
   DEFINE maj         RECORD LIKE maj_file.*,
          g_msg       LIKE type_file.chr1000  #No.FUN-680098   VARCHAR(72)
#No.FUN-D70095--start
   DEFINE l_CE_sum1    LIKE abb_file.abb07   #FUN-D70095 add
   DEFINE l_CE_sum2    LIKE abb_file.abb07   #FUN-D70095 add
   DEFINE l_sw1        LIKE type_file.num5        
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_cnt        LIKE type_file.num5            
   DEFINE l_maj08      LIKE maj_file.maj08  
#No.FUN-D70095--end
   
   #--str FUN-780059 add--#                                                                                                         
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                            
   CALL cl_del_data(l_table)                                                                                                        
   #------------------------------ CR (2) ------------------------------#                                                           
   #--end FUN-780059 add--#
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno    #No.TQC-740093 g_bookno->tm.bookno
      AND aaf02 = g_rlang
 
   IF cl_null(g_wc) THEN LET g_wc = ' 1=1' END IF
 
   CASE
      WHEN g_mai03 = '2'
         LET g_msg=" maj23[1,1]='1'"
      WHEN g_mai03 = '3'
         LET g_msg=" maj23[1,1]='2'"
      OTHERWISE
         LET g_msg=" 1=1"
   END CASE
  
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r739_p1 FROM l_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r739_c1 CURSOR FOR r739_p1
 
   FOR g_i = 1 TO 100
      FOR l_n = 1 TO 14 LET g_tot[g_i].tot[l_n] = 0 END FOR
   END FOR
#  CALL cl_outnam('aglr739') RETURNING l_name                  #No.FUN-780059--mark
 
#  START REPORT r739_rep TO l_name                             #No.FUN-780059--mark
 
   LET g_pageno = 0
   LET g_cnt    = 1
   LET g_level  = 1
   LET l_cnt = 1     #FUN-D70095
   FOREACH r739_c1 INTO maj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH 
      END IF
       
      LET l_tot = 0
      LET sr2.tot14 = 0
        
      FOR g_i = 1 TO 13
         SELECT SUM(aao05-aao06) INTO l_tot
           FROM aao_file,aag_file
          WHERE aao00 = tm.bookno   #No.TQC-740093 g_bookno->tm.bookno
            AND aao00 = aag00       #No.FUN-740020
            AND aao01 BETWEEN maj.maj21 AND maj.maj22
            AND aao02 = tm.dept
            AND aao03 = tm.yy
            AND aao04 = g_i
            AND aao01 = aag01
            AND aag07 IN ('2','3')
            AND aag38 = tm.aag38     #FUN-A30022 ADD  
         IF SQLCA.sqlcode != 100 AND SQLCA.sqlcode != 0 THEN
            CALL cl_err('',SQLCA.sqlcode,0)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
            EXIT PROGRAM
         END IF
         IF SQLCA.sqlcode = 100 THEN
            LET l_tot = 0 
         END IF
         
         IF l_tot IS NULL THEN LET l_tot = 0 END IF
         
#FUN-D70095--------------------------begin
         LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file " ,   
                     " WHERE abb00 = '",tm.bookno,"'",
                     "   AND aba00 = abb00 AND aba01 = abb01",
                     "   AND abb03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
                     "   AND abb05  = '",tm.dept,"'",
                     "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 ='",tm.yy,"'",
                     "   AND aba04 = '",g_i,"'",
                     "   AND abapost = 'Y'"                         
         PREPARE r121_cesum FROM l_sql
         IF STATUS THEN
            CALL cl_err('prepare:',STATUS,1)
            EXIT FOREACH
         END IF
         DECLARE r121_cesumc CURSOR FOR r121_cesum
         IF STATUS THEN
            CALL cl_err('r121_cesumc',STATUS,1)
            EXIT FOREACH
         END IF
         OPEN r121_cesumc USING '1'
         FETCH r121_cesumc INTO l_CE_sum1   
         IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
         IF l_CE_sum1 IS NULL THEN LET l_CE_sum1 = 0 END IF
         
         OPEN r121_cesumc USING '2'
         FETCH r121_cesumc INTO l_CE_sum2   
         IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
         IF l_CE_sum2 IS NULL THEN LET l_CE_sum2 = 0 END IF
         LET l_tot = l_tot - l_CE_sum1 + l_CE_sum2         
#FUN-D70095--------------------------end
         
#---------------FUN-D70095----------(S) 
        IF g_i = 14 THEN
           LET sr3[14].tot = sr3[14].tot + l_tot 
        ELSE
        	 LET sr3[g_i].tot = l_tot
      	END IF      
#        CASE g_i
#            WHEN 1  LET sr3[g_i].tot = l_tot
#            WHEN 2  LET sr3[g_i].tot = l_tot
#            WHEN 3  LET sr3[g_i].tot = l_tot
#            WHEN 4  LET sr3[g_i].tot = l_tot
#            WHEN 5  LET sr3[g_i].tot = l_tot
#            WHEN 6  LET sr3[g_i].tot = l_tot
#            WHEN 7  LET sr3[g_i].tot = l_tot
#            WHEN 8  LET sr3[g_i].tot = l_tot
#            WHEN 9  LET sr3[g_i].tot = l_tot
#            WHEN 10 LET sr3[g_i].tot = l_tot
#            WHEN 11 LET sr3[g_i].tot = l_tot
#            WHEN 12 LET sr3[g_i].tot = l_tot
#            WHEN 13 LET sr3[g_i].tot = l_tot
#            OTHERWISE EXIT CASE
#         END CASE
#         LET sr3[14].tot = sr3[14].tot + l_tot
                
       IF tm.o = 'Y' THEN 
          LET sr3[g_i].tot = sr3[g_i].tot * tm.q
       END IF
       
#         CASE g_i
#            WHEN 1  LET sr2.tot1  = l_tot
#            WHEN 2  LET sr2.tot2  = l_tot
#            WHEN 3  LET sr2.tot3  = l_tot
#            WHEN 4  LET sr2.tot4  = l_tot
#            WHEN 5  LET sr2.tot5  = l_tot
#            WHEN 6  LET sr2.tot6  = l_tot
#            WHEN 7  LET sr2.tot7  = l_tot
#            WHEN 8  LET sr2.tot8  = l_tot
#            WHEN 9  LET sr2.tot9  = l_tot
#            WHEN 10 LET sr2.tot10 = l_tot
#            WHEN 11 LET sr2.tot11 = l_tot
#            WHEN 12 LET sr2.tot12 = l_tot
#            WHEN 13 LET sr2.tot13 = l_tot
#            OTHERWISE EXIT CASE
#         END CASE
#         LET sr2.tot14 = sr2.tot14 + l_tot
#     END FOR   
#---------------FUN-D70095----------(E)       
      #匯率的轉換
#      IF tm.o = 'Y' THEN 
#         LET sr2.tot1  = sr2.tot1  * tm.q
#         LET sr2.tot2  = sr2.tot2  * tm.q
#         LET sr2.tot3  = sr2.tot3  * tm.q
#         LET sr2.tot4  = sr2.tot4  * tm.q
#         LET sr2.tot5  = sr2.tot5  * tm.q
#         LET sr2.tot6  = sr2.tot6  * tm.q
#         LET sr2.tot7  = sr2.tot7  * tm.q
#         LET sr2.tot8  = sr2.tot8  * tm.q
#         LET sr2.tot9  = sr2.tot9  * tm.q
#         LET sr2.tot10 = sr2.tot10 * tm.q
#         LET sr2.tot11 = sr2.tot11 * tm.q
#         LET sr2.tot12 = sr2.tot12 * tm.q
#         LET sr2.tot13 = sr2.tot13 * tm.q
#         LET sr2.tot14 = sr2.tot14 * tm.q
#      END IF
#---------------FUN-D70095----------(S)          
      IF NOT cl_null(maj.maj21) THEN
             IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
                LET sr3[g_i].tot = sr3[g_i].tot * -1            
             END IF
             IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
                LET sr3[g_i].tot = sr3[g_i].tot * -1            
             END IF
             IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
                LET sr3[g_i].tot = sr3[g_i].tot * -1             
             END IF
       END IF
#---------------FUN-D70095----------(E)           
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
         #---------------FUN-D70095----------(S)         
               IF maj.maj08 = '1' THEN
                  LET g_bal_a[l_cnt].maj02[g_i] = maj.maj02
                  LET g_bal_a[l_cnt].maj03[g_i] = maj.maj03
                  LET g_bal_a[l_cnt].bal1[g_i]  = sr3[g_i].tot                 
                  LET g_bal_a[l_cnt].maj08[g_i] = maj.maj08
                  LET g_bal_a[l_cnt].maj09[g_i] = maj.maj09
               ELSE
                  LET g_bal_a[l_cnt].maj02[g_i] = maj.maj02
                  LET g_bal_a[l_cnt].maj03[g_i] = maj.maj03
                  LET g_bal_a[l_cnt].maj08[g_i] = maj.maj08
                  LET g_bal_a[l_cnt].maj09[g_i] = maj.maj09                  
                  LET g_bal_a[l_cnt].bal1[g_i]  = sr3[g_i].tot
                  
                  FOR l_i = l_cnt - 1 TO 1 STEP -1       
                      IF maj.maj08 <= g_bal_a[l_i].maj08[g_i] THEN
                         EXIT FOR
                      END IF
                      IF g_bal_a[l_i].maj03[g_i] NOT MATCHES "[012]" THEN
                         CONTINUE FOR
                      END IF                    
                      IF l_i = l_cnt - 1 THEN       
                         LET l_maj08 = g_bal_a[l_i].maj08[g_i]
                      END IF
                      IF g_bal_a[l_i].maj09[g_i] = '+' THEN
                         LET l_sw1 = 1
                      ELSE
                         LET l_sw1 = -1
                      END IF
                      IF g_bal_a[l_i].maj08[g_i] >= l_maj08 THEN   
                         LET g_bal_a[l_cnt].bal1[g_i] = g_bal_a[l_cnt].bal1[g_i] + 
                             g_bal_a[l_i].bal1[g_i] * l_sw1                         
                      END IF
                      IF g_bal_a[l_i].maj08[g_i] > l_maj08 THEN
                         LET l_maj08 = g_bal_a[l_i].maj08[g_i]
                      END IF
                  END FOR
               END IF
          ELSE
          IF maj.maj03='5' THEN
              LET g_bal_a[l_cnt].maj02[g_i] = maj.maj02
              LET g_bal_a[l_cnt].maj03[g_i] = maj.maj03
              LET g_bal_a[l_cnt].bal1[g_i] = sr3[g_i].tot             
              LET g_bal_a[l_cnt].maj08[g_i] = maj.maj08
              LET g_bal_a[l_cnt].maj09[g_i] = maj.maj09
          ELSE                      
              LET g_bal_a[l_cnt].maj02[g_i] = maj.maj02
              LET g_bal_a[l_cnt].maj03[g_i] = maj.maj03
              LET g_bal_a[l_cnt].bal1[g_i] = 0              
              LET g_bal_a[l_cnt].maj08[g_i] = maj.maj08
              LET g_bal_a[l_cnt].maj09[g_i] = maj.maj09
          END IF          
       END IF
       END FOR
       
       LET sr.tot1  = g_bal_a[l_cnt].bal1[1]   
       LET sr.tot2  = g_bal_a[l_cnt].bal1[2]
       LET sr.tot3  = g_bal_a[l_cnt].bal1[3]
       LET sr.tot4  = g_bal_a[l_cnt].bal1[4]
       LET sr.tot5  = g_bal_a[l_cnt].bal1[5]
       LET sr.tot6  = g_bal_a[l_cnt].bal1[6]
       LET sr.tot7  = g_bal_a[l_cnt].bal1[7]
       LET sr.tot8  = g_bal_a[l_cnt].bal1[8]
       LET sr.tot9  = g_bal_a[l_cnt].bal1[9]
       LET sr.tot10 = g_bal_a[l_cnt].bal1[10]
       LET sr.tot11 = g_bal_a[l_cnt].bal1[11]
       LET sr.tot12 = g_bal_a[l_cnt].bal1[12]
       LET sr.tot13 = g_bal_a[l_cnt].bal1[13]
       LET sr.tot14 = g_bal_a[l_cnt].bal1[14]          
       LET l_cnt = l_cnt + 1       
       #---------------FUN-D70095----------(E)
       #---------------FUN-D70095---mark-------(S)
#         FOR g_i = 1 TO 100
#            #CHI-A70050---add---start---
#             IF maj.maj09 = '-' THEN
#                LET g_tot[g_i].tot[1]  = g_tot[g_i].tot[1]  - sr2.tot1
#                LET g_tot[g_i].tot[2]  = g_tot[g_i].tot[2]  - sr2.tot2
#                LET g_tot[g_i].tot[3]  = g_tot[g_i].tot[3]  - sr2.tot3
#                LET g_tot[g_i].tot[4]  = g_tot[g_i].tot[4]  - sr2.tot4
#                LET g_tot[g_i].tot[5]  = g_tot[g_i].tot[5]  - sr2.tot5
#                LET g_tot[g_i].tot[6]  = g_tot[g_i].tot[6]  - sr2.tot6
#                LET g_tot[g_i].tot[7]  = g_tot[g_i].tot[7]  - sr2.tot7
#                LET g_tot[g_i].tot[8]  = g_tot[g_i].tot[8]  - sr2.tot8
#                LET g_tot[g_i].tot[9]  = g_tot[g_i].tot[9]  - sr2.tot9
#                LET g_tot[g_i].tot[10] = g_tot[g_i].tot[10] - sr2.tot10
#                LET g_tot[g_i].tot[11] = g_tot[g_i].tot[11] - sr2.tot11
#                LET g_tot[g_i].tot[12] = g_tot[g_i].tot[12] - sr2.tot12
#                LET g_tot[g_i].tot[13] = g_tot[g_i].tot[13] - sr2.tot13
#                LET g_tot[g_i].tot[14] = g_tot[g_i].tot[14] - sr2.tot14
#             ELSE
#            #CHI-A70050---add---end---
#                LET g_tot[g_i].tot[1]  = g_tot[g_i].tot[1]  + sr2.tot1
#                LET g_tot[g_i].tot[2]  = g_tot[g_i].tot[2]  + sr2.tot2
#                LET g_tot[g_i].tot[3]  = g_tot[g_i].tot[3]  + sr2.tot3
#                LET g_tot[g_i].tot[4]  = g_tot[g_i].tot[4]  + sr2.tot4
#                LET g_tot[g_i].tot[5]  = g_tot[g_i].tot[5]  + sr2.tot5
#                LET g_tot[g_i].tot[6]  = g_tot[g_i].tot[6]  + sr2.tot6
#                LET g_tot[g_i].tot[7]  = g_tot[g_i].tot[7]  + sr2.tot7
#                LET g_tot[g_i].tot[8]  = g_tot[g_i].tot[8]  + sr2.tot8
#                LET g_tot[g_i].tot[9]  = g_tot[g_i].tot[9]  + sr2.tot9
#                LET g_tot[g_i].tot[10] = g_tot[g_i].tot[10] + sr2.tot10
#                LET g_tot[g_i].tot[11] = g_tot[g_i].tot[11] + sr2.tot11
#                LET g_tot[g_i].tot[12] = g_tot[g_i].tot[12] + sr2.tot12
#                LET g_tot[g_i].tot[13] = g_tot[g_i].tot[13] + sr2.tot13
#                LET g_tot[g_i].tot[14] = g_tot[g_i].tot[14] + sr2.tot14
#             END IF          #CHI-A70050 add
#         END FOR
#         
#         LET g_level  = maj.maj08
#         LET sr.tot1  = g_tot[g_level].tot[1]
#         LET sr.tot2  = g_tot[g_level].tot[2]
#         LET sr.tot3  = g_tot[g_level].tot[3]
#         LET sr.tot4  = g_tot[g_level].tot[4]
#         LET sr.tot5  = g_tot[g_level].tot[5]
#         LET sr.tot6  = g_tot[g_level].tot[6]
#         LET sr.tot7  = g_tot[g_level].tot[7]
#         LET sr.tot8  = g_tot[g_level].tot[8]
#         LET sr.tot9  = g_tot[g_level].tot[9]
#         LET sr.tot10 = g_tot[g_level].tot[10]
#         LET sr.tot11 = g_tot[g_level].tot[11]
#         LET sr.tot12 = g_tot[g_level].tot[12]
#         LET sr.tot13 = g_tot[g_level].tot[13]
#         LET sr.tot14 = g_tot[g_level].tot[14]
#        #CHI-A70050---add---start---
#         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
#            LET sr.tot1 = sr.tot1 *-1
#            LET sr.tot2 = sr.tot2 *-1
#            LET sr.tot3 = sr.tot3 *-1
#            LET sr.tot4 = sr.tot4 *-1
#            LET sr.tot5 = sr.tot5 *-1
#            LET sr.tot6 = sr.tot6 *-1
#            LET sr.tot7 = sr.tot7 *-1
#            LET sr.tot8 = sr.tot8 *-1
#            LET sr.tot9 = sr.tot9 *-1
#            LET sr.tot10 = sr.tot10 *-1
#            LET sr.tot11 = sr.tot11 *-1
#            LET sr.tot12 = sr.tot12 *-1
#            LET sr.tot13 = sr.tot13 *-1
#            LET sr.tot14 = sr.tot14 *-1
#         END IF
#        #CHI-A70050---add---end---
# 
#         FOR g_i = 1 TO maj.maj08
#            FOR l_n = 1 TO 14 LET g_tot[g_i].tot[l_n] = 0 END FOR
#         END FOR       
#      ELSE
#         IF maj.maj03 = '5' THEN
#            LET sr.* = sr2.* 
#         ELSE
#            INITIALIZE sr.* TO NULL
#         END IF
#      END IF
      #---------------FUN-D70095---mark-------(E)
      IF maj.maj03 = 0 THEN CONTINUE FOREACH END IF  # 不印出
 
      # 餘額為 0 不印
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" AND               #CHI-CC0023 add maj03 match 5
         sr.tot1=0 AND sr.tot2=0 AND sr.tot3=0 AND sr.tot4=0 AND sr.tot5=0 AND     
         sr.tot6=0 AND sr.tot7=0 AND sr.tot8=0 AND sr.tot9=0 AND sr.tot10=0 AND     
         sr.tot11=0 AND sr.tot12=0 AND sr.tot13=0 AND sr.tot14=0 THEN
         CONTINUE FOREACH
      END IF
     
      # 最小階數起列印
      IF tm.f > 0 AND maj.maj08 < tm.f THEN CONTINUE FOREACH END IF

      #--str FUN-780059 add--#
#---------------FUN-D70095---mark----(S) 
#      IF maj.maj07 = '2' THEN                                                                                                       
#         LET sr.tot1  = sr.tot1  * -1                                                                                                
#         LET sr.tot2  = sr.tot2  * -1                                                                                                
#         LET sr.tot3  = sr.tot3  * -1                                                                                                
#         LET sr.tot4  = sr.tot4  * -1                                                                                                
#         LET sr.tot5  = sr.tot5  * -1                                                                                                
#         LET sr.tot6  = sr.tot6  * -1                                                                                                
#         LET sr.tot7  = sr.tot7  * -1                                                                                                
#         LET sr.tot8  = sr.tot8  * -1                                                                                                
#         LET sr.tot9  = sr.tot9  * -1                                                                                                
#         LET sr.tot10 = sr.tot10 * -1                                                                                                
#         LET sr.tot11 = sr.tot11 * -1                                                                                                
#         LET sr.tot12 = sr.tot12 * -1                                                                                                
#         LET sr.tot13 = sr.tot13 * -1                                                                                                
#         LET sr.tot14 = sr.tot14 * -1                                                                                                
#      END IF                                                                                                                        
#---------------FUN-D70095---mark----(E)                                                                                                                                    
      IF tm.h = 'Y' THEN LET maj.maj20 = maj.maj20e END IF  #MOD-920224 mod 1->Y
 
      IF tm.d MATCHES '[23]' THEN                                                                                            
         LET sr.tot1  = sr.tot1  / g_unit                                                                                     
         LET sr.tot2  = sr.tot2  / g_unit                                                                                     
         LET sr.tot3  = sr.tot3  / g_unit                                                                                     
         LET sr.tot4  = sr.tot4  / g_unit                                                                                     
         LET sr.tot5  = sr.tot5  / g_unit                                                                                     
         LET sr.tot6  = sr.tot6  / g_unit                                                                                     
         LET sr.tot7  = sr.tot7  / g_unit                                                                                     
         LET sr.tot8  = sr.tot8  / g_unit                                                                                     
         LET sr.tot9  = sr.tot9  / g_unit                                                                                     
         LET sr.tot10 = sr.tot10 / g_unit                                                                                     
         LET sr.tot11 = sr.tot11 / g_unit                                                                                     
         LET sr.tot12 = sr.tot12 / g_unit                                                                                     
         LET sr.tot13 = sr.tot13 / g_unit                                                                                     
         LET sr.tot14 = sr.tot14 / g_unit                                                                                     
      END IF                                                                                                                 
                                                                                                                                    
      LET maj.maj20 = maj.maj05 SPACE, maj.maj20
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##                                                           
      IF maj.maj04 = 0 THEN                                                                                                         
         EXECUTE insert_prep USING                                                                                                  
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                                                                               
            sr.tot1,sr.tot2,sr.tot3,sr.tot4,sr.tot5,sr.tot6,sr.tot7,
            sr.tot8,sr.tot9,sr.tot10,sr.tot11,sr.tot12,sr.tot13,sr.tot14,                                                                   
            '2'                                                                                                                     
      ELSE                                                                                                                          
         EXECUTE insert_prep USING                                                                                                  
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                                                                               
            sr.tot1,sr.tot2,sr.tot3,sr.tot4,sr.tot5,sr.tot6,sr.tot7,                                                         
            sr.tot8,sr.tot9,sr.tot10,sr.tot11,sr.tot12,sr.tot13,sr.tot14,
            '2'                                                                                                                     
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
         #讓空行的這筆資料排在正常的資料前面印出                                                                                    
         FOR g_i = 1 TO maj.maj04                                                                                                     
            EXECUTE insert_prep USING                                                                                               
               maj.maj20,maj.maj20e,maj.maj02,'',                                                                                   
               '0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0',                                                                                             
               '1'                                                                                                                  
         END FOR                                                                                                                    
      END IF                                                                                                                        
    #--end FUN-780059 add--#
#     OUTPUT TO REPORT r739_rep(maj.*, sr.*)               #No.FUN-780059--mark
 
   END FOREACH
 
#  FINISH REPORT r739_rep                                #No.FUN-780059--mark
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #No.FUN-780059--mark
 
   #--str FUN-780059 add--#  
   LET g_msg = NULL        
   SELECT gem02 INTO g_msg FROM gem_file
    WHERE gem01 = tm.dept AND gem05='Y' AND gemacti='Y'
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##                                                            
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   LET g_str = g_mai02,";",tm.a,";",tm.d,";",tm.p,";",tm.dept,";",
               g_msg,";",g_azi04   
   CALL cl_prt_cs3('aglr739','aglr739',g_sql,g_str)                                                                                 
   #------------------------------ CR (4) ------------------------------#                                                           
   #--end FUN-780059 add--#
END FUNCTION
 
#--str FUN-780059 mark--#
#REPORT r739_rep(maj, sr)
#  DEFINE l_last_sw      LIKE type_file.chr1,    #No.FUN-680098        VARCHAR(1)
#         g_head1        STRING,
#         sr               RECORD 
#                          tot1      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot2      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot3      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot4      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot5      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot6      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot7      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot8      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot9      LIKE aao_file.aao05,#本期餘額(印出)
#                          tot10     LIKE aao_file.aao05,#本期餘額(印出)
#                          tot11     LIKE aao_file.aao05,#本期餘額(印出)
#                          tot12     LIKE aao_file.aao05,#本期餘額(印出)
#                          tot13     LIKE aao_file.aao05,#本期餘額(印出)
#                          tot14     LIKE aao_file.aao05 #合計
#                       END RECORD,
#         l_tot           ARRAY[14] OF LIKE aao_file.aao05,#本期餘額(印出)
#         l_prsw         LIKE type_file.chr1,       #是否列印過金額, 若無,則金額底線及整  #No.FUN-680098     VARCHAR(1)
#         l_unit         LIKE zaa_file.zaa08,         #No.FUN-680098  VARCHAR(6)
#         l_n,l_cnt,l_i  LIKE type_file.num5          #No.FUN-680098  smallint
#  DEFINE maj       RECORD LIKE maj_file.*
#      
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN 0
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY maj.maj02
# FORMAT
 
#  PAGE HEADER
#     PRINT COLUMN ((g_len-length(g_company))/2)+1,g_company
#     PRINT COLUMN ((g_len-length(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total 
#       #金額單位之列印
#       CASE tm.d
#              WHEN '1'  LET l_unit = g_x[17]
#              WHEN '2'  LET l_unit = g_x[18]
#              WHEN '3'  LET l_unit = g_x[19]
#              OTHERWISE LET l_unit = ' '
#       END CASE
#     IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
#     PRINT g_x[15] CLIPPED,tm.a
#     LET g_head1 = g_x[20] CLIPPED,tm.p,' ',g_x[16] CLIPPED,l_unit
#     PRINT COLUMN (g_len-length(g_head1)-6),g_head1
#     LET g_msg = NULL
#     SELECT gem02 INTO g_msg FROM gem_file WHERE gem01 = tm.dept AND gem05='Y'
#                                             AND gemacti='Y'
#     PRINT g_x[21] CLIPPED,tm.dept CLIPPED,' ',g_msg CLIPPED
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#     LET l_prsw = 'n'
 
#  ON EVERY ROW
#     IF maj.maj07 = '2' THEN
#       LET sr.tot1  = sr.tot1  * -1 
#       LET sr.tot2  = sr.tot2  * -1   
#       LET sr.tot3  = sr.tot3  * -1 
#       LET sr.tot4  = sr.tot4  * -1 
#       LET sr.tot5  = sr.tot5  * -1 
#       LET sr.tot6  = sr.tot6  * -1 
#       LET sr.tot7  = sr.tot7  * -1 
#       LET sr.tot8  = sr.tot8  * -1 
#       LET sr.tot9  = sr.tot9  * -1 
#       LET sr.tot10 = sr.tot10 * -1 
#       LET sr.tot11 = sr.tot11 * -1 
#       LET sr.tot12 = sr.tot12 * -1 
#       LET sr.tot13 = sr.tot13 * -1 
#       LET sr.tot14 = sr.tot14 * -1 
#     END IF
#  
#     IF tm.h = '1' THEN LET maj.maj20 = maj.maj20e END IF   
#  
#     CASE
#       WHEN maj.maj03 = '9'
#            SKIP TO TOP OF PAGE
#       WHEN maj.maj03 = '3'
#            PRINT COLUMN g_c[31],g_dash2[1,g_w[31]],
#                  COLUMN g_c[33],g_dash2[1,g_w[33]],
#                  COLUMN g_c[34],g_dash2[1,g_w[34]],
#                  COLUMN g_c[35],g_dash2[1,g_w[35]],
#                  COLUMN g_c[36],g_dash2[1,g_w[36]],
#                  COLUMN g_c[37],g_dash2[1,g_w[37]],
#                  COLUMN g_c[38],g_dash2[1,g_w[38]],
#                  COLUMN g_c[39],g_dash2[1,g_w[39]],
#                  COLUMN g_c[40],g_dash2[1,g_w[40]],
#                  COLUMN g_c[41],g_dash2[1,g_w[41]],
#                  COLUMN g_c[42],g_dash2[1,g_w[42]],
#                  COLUMN g_c[43],g_dash2[1,g_w[43]],
#                  COLUMN g_c[44],g_dash2[1,g_w[44]],
#                  COLUMN g_c[45],g_dash2[1,g_w[45]],
#                  COLUMN g_c[46],g_dash2[1,g_w[46]]
#       WHEN maj.maj03 = '4'
#            PRINT g_dash2 CLIPPED
#       OTHERWISE
#            FOR g_i = 1 TO maj.maj04 PRINT END FOR
#            
#            IF tm.d MATCHES '[23]' THEN
#              LET sr.tot1  = sr.tot1  / g_unit 
#              LET sr.tot2  = sr.tot2  / g_unit  
#              LET sr.tot3  = sr.tot3  / g_unit
#              LET sr.tot4  = sr.tot4  / g_unit
#              LET sr.tot5  = sr.tot5  / g_unit
#              LET sr.tot6  = sr.tot6  / g_unit
#              LET sr.tot7  = sr.tot7  / g_unit
#              LET sr.tot8  = sr.tot8  / g_unit
#              LET sr.tot9  = sr.tot9  / g_unit
#              LET sr.tot10 = sr.tot10 / g_unit
#              LET sr.tot11 = sr.tot11 / g_unit
#              LET sr.tot12 = sr.tot12 / g_unit
#              LET sr.tot13 = sr.tot13 / g_unit
#              LET sr.tot14 = sr.tot14 / g_unit
#            END IF            
#       
#            LET maj.maj20 = maj.maj05 SPACE, maj.maj20
#            PRINT COLUMN g_c[31],maj.maj20,
#                  COLUMN g_c[33],cl_numfor(sr.tot1,33,g_azi04),   #MOD-580211
#                  COLUMN g_c[34],cl_numfor(sr.tot2,34,g_azi04),   #MOD-580211
#                  COLUMN g_c[35],cl_numfor(sr.tot3,35,g_azi04),   #MOD-580211
#                  COLUMN g_c[36],cl_numfor(sr.tot4,36,g_azi04),   #MOD-580211
#                  COLUMN g_c[37],cl_numfor(sr.tot5,37,g_azi04),   #MOD-580211
#                  COLUMN g_c[38],cl_numfor(sr.tot6,38,g_azi04),   #MOD-580211
#                  COLUMN g_c[39],cl_numfor(sr.tot7,39,g_azi04),   #MOD-580211
#                  COLUMN g_c[40],cl_numfor(sr.tot8,40,g_azi04),   #MOD-580211
#                  COLUMN g_c[41],cl_numfor(sr.tot9,41,g_azi04),   #MOD-580211
#                  COLUMN g_c[42],cl_numfor(sr.tot10,42,g_azi04),  #MOD-580211
#                  COLUMN g_c[43],cl_numfor(sr.tot11,43,g_azi04),  #MOD-580211
#                  COLUMN g_c[44],cl_numfor(sr.tot12,44,g_azi04),  #MOD-580211
#                  COLUMN g_c[45],cl_numfor(sr.tot13,45,g_azi04),  #MOD-580211
#                  COLUMN g_c[46],cl_numfor(sr.tot14,46,g_azi04)   #MOD-580211
#     END CASE
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#       PRINT g_dash[1,g_len]
#       PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE 
#       SKIP 2 LINE
#     END IF
#END REPORT}
#MOD-6C0022 end 
#--end FUN-780059 mark--#
