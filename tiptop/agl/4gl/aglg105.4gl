# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglg105.4gl
# Descriptions...: 試算表列印  
# Date & Author..: 96/09/12 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/17 By Nicola 報表架構修改
# Modify.........: No.TQC-5C0037 05/12/08 By kevin 線條修改
# Modify.........: No.TQC-620081 06/02/20 By Smapmin 當月結方法選擇為帳結法時，
#                                                    相關財務報表無法產出累計/前期損益表  
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.MOD-680002 06/08/02 By Smapmin 修正TQC-620081
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-730135 07/03/28 By Smapmin 修正TQC-620081
# Modify.........: No.FUN-740020 07/04/06 By mike    會計科目加帳套
# Modify.........: No.FUN-770044 07/07/12 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-790083 07/09/17 By Smapmin 小數位數小於0或為NULL時,預設為0
# Modify.........: No.MOD-840057 08/04/10 By Carol 期末金額計算調整
# Modify.........: No.MOD-850040 08/05/13 By Smapimn 每一筆明細的期末餘額以"餘額"方式呈現.最後一筆的期末餘額以"合計"的方式呈現
# Modify.........: No.MOD-890041 08/09/03 By Sarah 選擇本行要印出,但金額不做加總時,金額應該要顯示出來
# Modify.........: No.FUN-8B0059 08/12/09 By xiaofeizhu 在INPUT時提供使用者勾選"是否列印會計科目"
# Modify.........: No.MOD-940050 09/04/06 By Sarah 修正MOD-850040的調整,應放在IF NOT cl_null(maj.maj21)的判斷外
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-B80158 11/09/09 By yangtt 明細類CR轉換成GRW
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              a        LIKE mai_file.mai01,    #報表結構編號  #No.FUN-680098 VARCHAR(6) 
              b        LIKE aaa_file.aaa01,    #帳別編號      #No.FUN-670039
              yy       LIKE type_file.num5,    #輸入年度      #No.FUN-680098 smallint
              bm       LIKE type_file.num5,    #Begin 期別    #No.FUN-680098 smallint
              em       LIKE type_file.num5,    # End  期別    #No.FUN-680098 smallint
              dd       LIKE type_file.num5,    #截止日        #No.FUN-680098 smallint
              c        LIKE type_file.chr1,    #異動額及餘額為0者是否列印    #No.FUN-680098 VARCHAR(1) 
              d        LIKE type_file.chr1,    #金額單位      #No.FUN-680098 VARCHAR(1)    
              e        LIKE type_file.num5,    #小數位數      #No.FUN-680098 smallint
              f        LIKE type_file.num5,    #列印最小階數  #No.FUN-680098 smallint
              h        LIKE type_file.chr4,    #額外說明類別  #No.FUN-680098 VARCHAR(4) 
              o        LIKE type_file.chr1,    #轉換幣別否    #No.FUN-680098 VARCHAR(1) 
              p        LIKE azi_file.azi01,    #幣別  
              q        LIKE azj_file.azj03,    #匯率
              r        LIKE azi_file.azi01,    #幣別
              m        LIKE type_file.chr1,    #FUN-8B0059
              more     LIKE type_file.chr1     #Input more condition(Y/N)    #No.FUN-680098 VARCHAR(1) 
           END RECORD,
       bdate,edate     LIKE type_file.dat,                    #No.FUN-680098 date
       i,j,k,g_mm      LIKE type_file.num5,                   #No.FUN-680098 smallint
       g_unit          LIKE type_file.num10,   #金額單位基數  #No.FUN-680098 integer
       g_bookno        LIKE aah_file.aah00,    #帳別
       g_mai02         LIKE mai_file.mai02,
       g_mai03         LIKE mai_file.mai03,
       g_tot1_1        ARRAY[100] OF LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6)
       g_tot1_2        ARRAY[100] OF LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6)
       g_tot2_1        ARRAY[100] OF LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6) 
       g_tot2_2        ARRAY[100] OF LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6)
       g_tot3_1        ARRAY[100] OF LIKE type_file.num10,    #No.FUN-680098 integer
       g_tot3_2        ARRAY[100] OF LIKE type_file.num10,    #No.FUN-680098 integer
       g_tot4_1        ARRAY[100] OF LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6)
       g_tot4_2        ARRAY[100] OF LIKE type_file.num20_6   #No.FUN-680098 dec(20,6)
DEFINE g_aaa03         LIKE aaa_file.aaa03   
DEFINE g_i             LIKE type_file.num10                   #No.FUN-680098 integer
DEFINE g_aaa09         LIKE aaa_file.aaa09                    #MOD-730135
#str FUN-770044 add
DEFINE l_table         STRING                                 
DEFINE g_sql           STRING  
DEFINE g_str           STRING  
#end FUN-770044 add
 
###GENGRE###START
TYPE sr1_t RECORD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal1_1 LIKE aah_file.aah04,
    bal1_2 LIKE aah_file.aah04,
    bal2_1 LIKE aah_file.aah04,
    bal2_2 LIKE aah_file.aah05,
    bal3_1 LIKE aah_file.aah06,
    bal3_2 LIKE aah_file.aah07,
    bal4_1 LIKE aah_file.aah04,
    bal4_2 LIKE aah_file.aah04,
    line LIKE type_file.num5,
    maj21 LIKE maj_file.maj21,
    maj22 LIKE maj_file.maj22
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #str FUN-770044 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "maj02.maj_file.maj02,",   #項次(排序要用的)
               "maj03.maj_file.maj03,",   #列印碼
               "bal1_1.aah_file.aah04,",  #期初借 
               "bal1_2.aah_file.aah04,",  #期初貸 
               "bal2_1.aah_file.aah04,",  #本期借 
               "bal2_2.aah_file.aah05,",  #本期貸 
               "bal3_1.aah_file.aah06,",  #筆數借 
               "bal3_2.aah_file.aah07,",  #筆數貸 
               "bal4_1.aah_file.aah04,",  #期末借 
               "bal4_2.aah_file.aah04,",  #期末貸 
               "line.type_file.num5,",    #1:表示此筆為空行 2:表示此筆不為空行
               "maj21.maj_file.maj21,",   #FUN-8B0059
               "maj22.maj_file.maj22"     #FUN-8B0059               
 
   LET l_table = cl_prt_temptable('aglg105',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,  #TQC-A40133 mark
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"                          #FUN-8B0059 Add ?,? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-770044 add
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)   #TQC-610056
   LET tm.yy = ARG_VAL(10)
   LET tm.bm = ARG_VAL(11)
   LET tm.em = ARG_VAL(12)
   LET tm.dd = ARG_VAL(13)
   LET tm.c  = ARG_VAL(14)
   LET tm.d  = ARG_VAL(15)
   LET tm.e  = ARG_VAL(16)
   LET tm.f  = ARG_VAL(17)
   LET tm.h  = ARG_VAL(18)
   LET tm.o  = ARG_VAL(19)
   LET tm.p  = ARG_VAL(20)
   LET tm.q  = ARG_VAL(21)
   LET tm.r  = ARG_VAL(22)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.m  = ARG_VAL(27)       #FUN-8B0059
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b)  THEN LET tm.b=g_aza.aza81  END IF #No.FUN-740020
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g105_tm()                   # Input print condition
      ELSE CALL g105()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)   #FUN-B80158 add
END MAIN
 
FUNCTION g105_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,     #No.FUN-680098  smallint
          l_sw         LIKE type_file.chr1,     #重要欄位是否空白 #No.FUN-680098  VARCHAR(1)
          l_cmd        LIKE type_file.chr1000   #No.FUN-680098   VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5    #No.FUN-670005   #No.FUN-680098  smallint
   DEFINE li_result    LIKE type_file.num5      #No.FUN-6C0068   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW g105_w AT p_row,p_col WITH FORM "agl/42f/aglg105" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0) #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123 
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0)  #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123 
   END IF
 # LET tm.b = g_bookno  #No.FUN-740020 
   LET tm.b = g_aza.aza81  #No.FUN-740020 
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.m = 'N'                   #FUN-8B0059
   WHILE TRUE
       LET l_sw = 1
#      INPUT BY NAME tm.a,tm.b,tm.yy,tm.bm,tm.em,tm.dd,
       INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.dd,           #No.FUN-740020
                    tm.e,tm.f,tm.d,tm.c,tm.h,tm.m,tm.o,tm.r,      #No.FUN-8B0059 Add tm.m
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
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
                   WHERE mai01 = tm.a 
                     AND mai00 = tm.b   #No.FUN-740020
                     AND maiacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel mai:',STATUS,0) #No.FUN-660123
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660123 
               NEXT FIELD a 
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
 
          AFTER FIELD b
            IF tm.b IS NULL THEN 
               NEXT FIELD b END IF
            #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b 
                                         AND aaaacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)  #No.FUN-660123 
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123 
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD yy
# genero  script marked             IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD bm
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
#No.TQC-720032 -- end --
# genero  script marked             IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
            IF tm.bm IS NULL THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#            IF tm.bm <1 OR tm.bm > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm
#            END IF
#No.TQC-720032 -- end --
  
         AFTER FIELD em
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
#No.TQC-720032 -- end --
            IF tm.em IS NULL THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#            IF tm.em <1 OR tm.em > 13 THEN
#               CALL cl_err('','agl-013',0) NEXT FIELD em
#            END IF
#No.TQC-720032 -- end --
            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
         AFTER FIELD dd
            IF tm.dd IS NOT NULL THEN
               IF tm.dd <0 OR tm.dd > 31 THEN NEXT FIELD dd END IF
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            #IF tm.e < 0 THEN   #MOD-790083
            IF tm.e < 0 OR cl_null(tm.e) THEN   #MOD-790083
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
 
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
            
         #FUN-8B0059--Begin--#   
         AFTER FIELD m
            IF cl_null(tm.m) OR tm.m NOT MATCHES'[YN]' THEN NEXT FIELD m END IF
         #FUN-8B0059--Begin--#            
   
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
#              CALL cl_err(tm.p,'agl-109',0)  #No.FUN-660123
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
               NEXT FIELD p 
            END IF
 
         BEFORE FIELD q
            IF tm.o = 'N' THEN NEXT FIELD o END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
            IF tm.bm IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm 
           END IF
            IF tm.em IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.em 
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
            CALL cl_cmdask()     # Command execution
 
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(a) 
#              CALL q_mai(0,0,tm.a,tm.a) RETURNING tm.a
#              CALL FGL_DIALOG_SETBUFFER( tm.a )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
         #     LET g_qryparam.arg1= tm.b   #No.FUN-740020
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042  Mark 
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a 
#               CALL FGL_DIALOG_SETBUFFER( tm.a )
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
             #No.MOD-4C0156 add
            WHEN INFIELD(b) 
#              CALL q_aaa(0,0,tm.b) RETURNING tm.b
#              CALL FGL_DIALOG_SETBUFFER( tm.b )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
#               CALL FGL_DIALOG_SETBUFFER( tm.b )
               DISPLAY BY NAME tm.b
               NEXT FIELD b
             #No.MOD-4C0156 end
   
            WHEN INFIELD(p) 
#              CALL q_azi(6,10,tm.p) RETURNING tm.p
#              CALL FGL_DIALOG_SETBUFFER( tm.p )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p 
#               CALL FGL_DIALOG_SETBUFFER( tm.p )
               DISPLAY BY NAME tm.p
               NEXT FIELD p
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
          LET INT_FLAG = 0 CLOSE WINDOW g105_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
          CALL cl_gre_drop_temptable(l_table)   #FUN-B80158 add
          EXIT PROGRAM
             
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aglg105'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('aglg105','9031',1)   
          ELSE
             LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                             " '",g_bookno CLIPPED,"'" ,
                             " '",g_pdate CLIPPED,"'",
                             " '",g_towhom CLIPPED,"'",
                             #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                             " '",g_bgjob CLIPPED,"'",
                             " '",g_prtway CLIPPED,"'",
                             " '",g_copies CLIPPED,"'",
                             " '",tm.a CLIPPED,"'",
                             " '",tm.b CLIPPED,"'",   #TQC-610056
                             " '",tm.yy CLIPPED,"'",
                             " '",tm.bm CLIPPED,"'",
                             " '",tm.em CLIPPED,"'",
                             " '",tm.dd CLIPPED,"'",
                             " '",tm.c CLIPPED,"'",
                             " '",tm.d CLIPPED,"'",
                             " '",tm.e CLIPPED,"'",
                             " '",tm.f CLIPPED,"'",
                             " '",tm.h CLIPPED,"'",
                             " '",tm.o CLIPPED,"'",
                             " '",tm.p CLIPPED,"'",
                             " '",tm.q CLIPPED,"'",
                             " '",tm.r CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                             " '",tm.m CLIPPED,"'"              #No.FUN-8B0059
            CALL cl_cmdat('aglg105',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)   #FUN-B80158 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g105()
      ERROR ""
   END WHILE
   CLOSE WINDOW g105_w
END FUNCTION
 
FUNCTION g105()
   DEFINE l_name    LIKE type_file.chr20    # External(Disk) file name  #No.FUN-680098  VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT               #No.FUN-680098  VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680098   VARCHAR(1)
   DEFINE amt1_1    LIKE aah_file.aah04
   DEFINE amt1_2    LIKE aah_file.aah04
   DEFINE amt2_1    LIKE aah_file.aah04
   DEFINE amt2_2    LIKE aah_file.aah05
   DEFINE amt3_1    LIKE aah_file.aah06
   DEFINE amt3_2    LIKE aah_file.aah07
   DEFINE amt4_1    LIKE aah_file.aah04
   DEFINE amt4_2    LIKE aah_file.aah04
   DEFINE l_tmp1    LIKE aas_file.aas04
   DEFINE l_tmp2    LIKE aas_file.aas05
#-----TQC-620081---------
   DEFINE l_endy1   LIKE aah_file.aah04
   DEFINE l_endy2   LIKE aah_file.aah04
#-----END TQC-620081-----
   DEFINE l_tmp3    LIKE aas_file.aas06
   DEFINE l_tmp4    LIKE aas_file.aas07
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_maj02   LIKE maj_file.maj02   #MOD-850040
   DEFINE sr        RECORD
                       bal1_1   LIKE aah_file.aah04,   #--- 期初借 
                       bal1_2   LIKE aah_file.aah04,   #--- 期初貸 
                       bal2_1   LIKE aah_file.aah04,   #--- 本期借 
                       bal2_2   LIKE aah_file.aah05,   #--- 本期貸 
                       bal3_1   LIKE aah_file.aah06,   #--- 筆數借 
                       bal3_2   LIKE aah_file.aah07,   #--- 筆數貸 
                       bal4_1   LIKE aah_file.aah04,   #--- 期末借 
                       bal4_2   LIKE aah_file.aah04    #--- 期末貸 
                    END RECORD
 
   #str FUN-770044 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-770044 add
 
   SELECT aaf03 INTO g_company FROM aaf_file 
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' ORDER BY maj02"
   PREPARE g105_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g105_c CURSOR FOR g105_p
 
   IF tm.dd IS NULL THEN
      LET g_mm = tm.em
   ELSE 
      LET g_mm = tm.em - 1
      LET bdate = MDY(tm.em, 01,    tm.yy)
      LET edate = MDY(tm.em, tm.dd, tm.yy)
   END IF
   FOR g_i = 1 TO 100 
      LET g_tot1_1[g_i] = 0 LET g_tot1_2[g_i] = 0 
      LET g_tot2_1[g_i] = 0 LET g_tot2_2[g_i] = 0 
      LET g_tot3_1[g_i] = 0 LET g_tot3_2[g_i] = 0 
      LET g_tot4_1[g_i] = 0 LET g_tot4_2[g_i] = 0 
   END FOR
  #CALL cl_outnam('aglg105') RETURNING l_name   #FUN-770044 mark
  #START REPORT g105_rep TO l_name              #FUN-770044 mark
   #-----MOD-850040---------
   LET l_maj02=''
   SELECT MAX(maj02) INTO l_maj02 FROM maj_file 
     WHERE maj01 = tm.a
   #-----END MOD-850040-----
   FOREACH g105_c INTO maj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
      END IF
      LET amt1_1=0 LET amt1_2=0 LET amt2_1=0 LET amt2_2=0 
      LET amt3_1=0 LET amt3_2=0 LET amt4_1=0 LET amt4_2=0 
      IF NOT cl_null(maj.maj21) THEN
         IF maj.maj24 IS NULL THEN
            #--- 期初
            SELECT SUM(aah04-aah05) INTO amt1_1 FROM aah_file,aag_file
                WHERE aah00 = tm.b
                  AND aah01 BETWEEN maj.maj21 AND maj.maj22
                  AND aah02 = tm.yy AND aah03 < tm.bm                
                  AND aah01 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b  #No.FUN-740020  
            #--- 本期  
            SELECT SUM(aah04),SUM(aah05),SUM(aah06),SUM(aah07) 
                INTO amt2_1,amt2_2,amt3_1,amt3_2 FROM aah_file,aag_file
                WHERE aah00 = tm.b
                  AND aah01 BETWEEN maj.maj21 AND maj.maj22
                  AND aah02 = tm.yy AND aah03 >=tm.bm AND aah03 <=g_mm 
                  AND aah01 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b  #No.FUN-740020 
            #-----TQC-620081---------
            #-----MOD-730135---------
            LET g_aaa09 = ''
            SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
            IF g_aaa09 = '2' THEN
            #IF g_aza.aza26 = '2' THEN
            #-----END MOD-730135-----
              #SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file   #MOD-680002
              SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file,aag_file   #MOD-680002
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01   #MOD-680002
                 AND aag03 <> '4'   #MOD-680002
                 AND aag00=tm.b  #No.FUN-740020 
              #SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file   #MOD-680002
              SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file,aag_file   #MOD-680002
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01   #MOD-680002
                 AND aag03 <> '4'   #MOD-680002
                 AND aag00=tm.b  #No.FUN-740020 
              IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
              IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
              LET amt2_1 = amt2_1 - l_endy1
              LET amt2_2 = amt2_2 - l_endy2
            END IF
            #-----END TQC-620081-----
         ELSE
            #--- 期初
            SELECT SUM(aao05-aao06) INTO amt1_1 FROM aao_file,aag_file
                WHERE aao00 = tm.b
                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
                  AND aao03 = tm.yy AND aao04 < tm.bm
                  AND aao01 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b  #No.FUN-740020 
            #--- 本期  
            SELECT SUM(aao05),SUM(aao06) INTO amt2_1,amt2_2
                FROM aao_file,aag_file
                WHERE aao00 = tm.b
                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
                  AND aao03 = tm.yy AND aao04 >=tm.bm AND aao04 <=g_mm 
                  AND aao01 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b  #No.FUN-740020 
            SELECT COUNT(*) INTO amt3_1 FROM aba_file,abb_file,aag_file
                WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                  AND abb03 = aag01 AND aag07 IN ('2','3')
                  AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                  AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                  AND abb06='1' AND aba04 >=tm.bm AND aba04 <=g_mm 
                  AND abaacti = 'Y'  #no.4868
                  AND aag00=tm.b  #No.FUN-740020 
                  AND aba19 <> 'X'  #CHI-C80041
            SELECT COUNT(*) INTO amt3_2 FROM aba_file,abb_file,aag_file
                WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                  AND abb03 = aag01 AND aag07 IN ('2','3')
                  AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                  AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                  AND abb06='2' AND aba04 >=tm.bm AND aba04 <=g_mm 
                  AND abaacti = 'Y'  #no.4868
                  AND aag00=tm.b  #No.FUN-740020 
                  AND aba19 <> 'X'  #CHI-C80041
            #-----TQC-620081---------
            #-----MOD-730135---------
            LET g_aaa09 = ''
            SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
            IF g_aaa09 = '2' THEN
            #IF g_aza.aza26 = '2' THEN
            #-----END MOD-730135-----
              #SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file   #MOD-680002
              SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file,aag_file   #MOD-680002
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy
                 AND abb05 BETWEEN maj.maj24 AND maj.maj25
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01   #MOD-680002
                 AND aag03 <> '4'   #MOD-680002
                 AND aag00=tm.b  #No.FUN-740020 
              #SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file   #MOD-680002
              SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file,aag_file   #MOD-680002
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND abb05 BETWEEN maj.maj24 AND maj.maj25
                 AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01   #MOD-680002
                 AND aag03 <> '4'   #MOD-680002
                 AND aag00=tm.b  #No.FUN-740020 
              IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
              IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
              LET amt3_1 = amt3_1 - l_endy1
              LET amt3_2 = amt3_2 - l_endy2
            END IF
            #-----END TQC-620081-----
         END IF
         IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
         IF amt1_1 IS NULL THEN LET amt1_1=0 END IF
         IF amt2_1 IS NULL THEN LET amt2_1=0 END IF
         IF amt2_2 IS NULL THEN LET amt2_2=0 END IF
         IF amt3_1 IS NULL THEN LET amt3_1=0 END IF
         IF amt3_2 IS NULL THEN LET amt3_2=0 END IF
         #--- 日餘額
         IF tm.dd IS NOT NULL THEN
            IF maj.maj24 IS NULL THEN
               SELECT SUM(aas04),SUM(aas05),SUM(aas06),SUM(aas07) 
                   INTO l_tmp1,l_tmp2,l_tmp3,l_tmp4
                   FROM aas_file,aag_file WHERE aas00 = tm.b
                    AND aas01 BETWEEN maj.maj21 AND maj.maj22
                    AND aas02 BETWEEN bdate AND edate
                    AND aas01 = aag01 AND aag07 IN ('2','3')
                    AND aag00=tm.b  #No.FUN-740020 
            ELSE
               SELECT SUM(abb07) INTO l_tmp1 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='1' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b  #No.FUN-740020 
                     AND aba19 <> 'X'  #CHI-C80041
               SELECT SUM(abb07) INTO l_tmp2 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='2' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b  #No.FUN-740020
                     AND aba19 <> 'X'  #CHI-C80041 
               SELECT COUNT(*) INTO l_tmp3 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='1' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b  #No.FUN-740020 
                     AND aba19 <> 'X'  #CHI-C80041
               SELECT COUNT(*) INTO l_tmp4 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='2' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b  #No.FUN-740020 
                     AND aba19 <> 'X'  #CHI-C80041
            END IF
            IF STATUS THEN CALL cl_err('aas',STATUS,1) EXIT FOREACH END IF
            IF l_tmp1 IS NULL THEN LET l_tmp1 = 0 END IF
            IF l_tmp2 IS NULL THEN LET l_tmp2 = 0 END IF
            IF l_tmp3 IS NULL THEN LET l_tmp3 = 0 END IF
            IF l_tmp4 IS NULL THEN LET l_tmp4 = 0 END IF
            LET amt2_1 = amt2_1 + l_tmp1
            LET amt2_2 = amt2_2 + l_tmp2
            LET amt3_1 = amt3_1 + l_tmp3
            LET amt3_2 = amt3_2 + l_tmp4
         END IF
         IF amt1_1<0 THEN LET amt1_2=amt1_1*-1 LET amt1_1=0 END IF
      END IF
     #str MOD-940050 mod
      #--- 期末  
#-----MOD-850040---------
##MOD-840057-modify
#     LET amt4_1=amt1_1+amt2_1
#     LET amt4_2=amt1_2+amt2_2
##    IF amt4_1<0 THEN LET amt4_2=amt4_1*-1 LET amt4_1=0 END IF
##MOD-840057-modify-end
      IF maj.maj02 = l_maj02 THEN
         LET amt4_1=amt1_1+amt2_1
         LET amt4_2=amt1_2+amt2_2
      ELSE
         LET amt4_1=amt1_1+amt2_1-amt1_2-amt2_2
         IF amt4_1<0 THEN LET amt4_2=amt4_1*-1 LET amt4_1=0 END IF
      END IF
#-----END MOD-850040-----
     #end MOD-940050 mod
 
      IF tm.o = 'Y' THEN                                  #匯率的轉換
         LET amt1_1 = amt1_1 * tm.q LET amt1_2 = amt1_2 * tm.q
         LET amt2_1 = amt2_1 * tm.q LET amt2_2 = amt2_2 * tm.q
         LET amt4_1 = amt4_1 * tm.q LET amt4_2 = amt4_2 * tm.q
      END IF 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN #合計階數處理
         FOR i = 1 TO 100
           #CHI-A70050---modify---start---
            IF maj.maj09 = '-' THEN
               LET g_tot1_1[i] = g_tot1_1[i] - amt1_1 
               LET g_tot1_2[i] = g_tot1_2[i] - amt1_2 
               LET g_tot2_1[i] = g_tot2_1[i] - amt2_1 
               LET g_tot2_2[i] = g_tot2_2[i] - amt2_2 
               LET g_tot3_1[i] = g_tot3_1[i] - amt3_1 
               LET g_tot3_2[i] = g_tot3_2[i] - amt3_2 
               LET g_tot4_1[i] = g_tot4_1[i] - amt4_1 
               LET g_tot4_2[i] = g_tot4_2[i] - amt4_2 
            ELSE
           #CHI-A70050---modify---end---
               LET g_tot1_1[i]=g_tot1_1[i]+amt1_1 
               LET g_tot1_2[i]=g_tot1_2[i]+amt1_2 
               LET g_tot2_1[i]=g_tot2_1[i]+amt2_1 
               LET g_tot2_2[i]=g_tot2_2[i]+amt2_2 
               LET g_tot3_1[i]=g_tot3_1[i]+amt3_1 
               LET g_tot3_2[i]=g_tot3_2[i]+amt3_2 
               LET g_tot4_1[i]=g_tot4_1[i]+amt4_1 
               LET g_tot4_2[i]=g_tot4_2[i]+amt4_2 
            END IF        #CHI-A70050 add
         END FOR
         LET k=maj.maj08  
         LET sr.bal1_1=g_tot1_1[k] LET sr.bal1_2=g_tot1_2[k]
         LET sr.bal2_1=g_tot2_1[k] LET sr.bal2_2=g_tot2_2[k]
         LET sr.bal3_1=g_tot3_1[k] LET sr.bal3_2=g_tot3_2[k]
         LET sr.bal4_1=g_tot4_1[k] LET sr.bal4_2=g_tot4_2[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1_1 = sr.bal1_1 *-1
            LET sr.bal2_1 = sr.bal2_1 *-1
            LET sr.bal3_1 = sr.bal3_1 *-1
            LET sr.bal4_1 = sr.bal4_1 *-1
            LET sr.bal1_2 = sr.bal1_2 *-1
            LET sr.bal2_2 = sr.bal2_2 *-1
            LET sr.bal3_2 = sr.bal3_2 *-1
            LET sr.bal4_2 = sr.bal4_2 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08 
            LET g_tot1_1[i]=0 LET g_tot1_2[i]=0 LET g_tot2_1[i]=0 
            LET g_tot2_2[i]=0 LET g_tot3_1[i]=0 LET g_tot3_2[i]=0 
            LET g_tot4_1[i]=0 LET g_tot4_2[i]=0 
         END FOR
      ELSE 
        #str MOD-890041 add
         IF maj.maj03 = '5' THEN
            LET sr.bal1_1=amt1_1   LET sr.bal1_2=amt1_2
            LET sr.bal2_1=amt2_1   LET sr.bal2_2=amt2_2
            LET sr.bal3_1=amt3_1   LET sr.bal3_2=amt3_2
            LET sr.bal4_1=amt4_1   LET sr.bal4_2=amt4_2
         ELSE
        #end MOD-890041 add
            LET sr.bal1_1=NULL   LET sr.bal1_2=NULL
            LET sr.bal2_1=NULL   LET sr.bal2_2=NULL
            LET sr.bal3_1=NULL   LET sr.bal3_2=NULL
            LET sr.bal4_1=NULL   LET sr.bal4_2=NULL
         END IF   #MOD-890041 add
      END IF
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF    #本行不印出
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"                        #CHI-CC0023 add maj03 match 5
         AND sr.bal1_1=0 AND sr.bal1_2=0 AND sr.bal2_1=0 AND sr.bal2_2=0
         AND sr.bal3_1=0 AND sr.bal3_2=0 AND sr.bal4_1=0 AND sr.bal4_2=0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
 
      #str FUN-770044 add
      IF tm.h = 'Y' THEN
         LET maj.maj20 = maj.maj20e
      END IF
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
      LET sr.bal1_1=sr.bal1_1/g_unit
      LET sr.bal1_2=sr.bal1_2/g_unit
      LET sr.bal2_1=sr.bal2_1/g_unit
      LET sr.bal2_2=sr.bal2_2/g_unit
      LET sr.bal4_1=sr.bal4_1/g_unit
      LET sr.bal4_2=sr.bal4_2/g_unit
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      IF maj.maj04 = 0 THEN 
         EXECUTE insert_prep USING 
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
            sr.bal1_1,sr.bal1_2 ,sr.bal2_1,sr.bal2_2,
            sr.bal3_1,sr.bal3_2 ,sr.bal4_1,sr.bal4_2,
            '2',maj.maj21,maj.maj22                                            #FUN-8B0059 Add maj.maj21,maj.maj22
      ELSE   
         EXECUTE insert_prep USING 
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
            sr.bal1_1,sr.bal1_2 ,sr.bal2_1,sr.bal2_2,
            sr.bal3_1,sr.bal3_2 ,sr.bal4_1,sr.bal4_2,
            '2',maj.maj21,maj.maj22                                            #FUN-8B0059 Add maj.maj21,maj.maj22
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING 
               maj.maj20,maj.maj20e,maj.maj02,'',
               '0','0','0','0',
               '0','0','0','0',
               '1',maj.maj21,maj.maj22                                         #FUN-8B0059 Add maj.maj21,maj.maj22
         END FOR
      END IF
      #end FUN-770044 add
 
     #OUTPUT TO REPORT g105_rep(maj.*, sr.*)   #FUN-770044 mark
   END FOREACH
 
   #str FUN-770044 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   #報表名稱是否以報表結構名稱列印
   IF g_aaz.aaz77 = 'N' THEN LET g_mai02 = '' END IF
   IF tm.dd IS NULL THEN LET tm.dd=' ' END IF
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.d,";",tm.yy,";",tm.bm,";",
###GENGRE###               tm.em,";",tm.dd,";",tm.e,";",tm.m,";",tm.p                   #FUN-8B0059 Add tm.m,tm.p
###GENGRE###   CALL cl_prt_cs3('aglg105','aglg105',g_sql,g_str)
    CALL aglg105_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-770044 add
 
  #FINISH REPORT g105_rep
 
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#str FUN-770044 mark
#REPORT g105_rep(maj, sr)
#   DEFINE l_last_sw  LIKE type_file.chr1       #No.FUN-680098   VARCHAR(1)
#   DEFINE l_unit     LIKE zaa_file.zaa08       #No.FUN-680098   VARCHAR(4)
#   DEFINE maj        RECORD LIKE maj_file.*
#   DEFINE sr         RECORD
#                        bal1_1   LIKE aah_file.aah04,   #--- 期初借 
#                        bal1_2   LIKE aah_file.aah04,   #--- 期初貸 
#                        bal2_1   LIKE aah_file.aah04,   #--- 本期借 
#                        bal2_2   LIKE aah_file.aah05,   #--- 本期貸 
#                        bal3_1   LIKE aah_file.aah06,   #--- 筆數借 
#                        bal3_2   LIKE aah_file.aah07,   #--- 筆數貸 
#                        bal4_1   LIKE aah_file.aah04,   #--- 期末借 
#                        bal4_2   LIKE aah_file.aah04    #--- 期末貸 
#                     END RECORD
#   DEFINE g_head1    STRING
#              
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
# 
#   ORDER BY maj.maj02
# 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         IF g_aaz.aaz77 = 'Y' THEN
#            LET g_x[1] = g_mai02
#         END IF
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         #金額單位之列印
#         CASE tm.d
#              WHEN '1'  LET l_unit = g_x[12]
#              WHEN '2'  LET l_unit = g_x[13]
#              WHEN '3'  LET l_unit = g_x[14]
#              OTHERWISE LET l_unit = ' '
#         END CASE
#         LET g_head1 = g_x[10] CLIPPED,tm.a,g_x[11] CLIPPED,l_unit
#         PRINT g_head1
#         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '<<<<','/',tm.bm USING'&&'
#         IF tm.dd IS NOT NULL THEN 
#            LET g_head1 = g_head1 CLIPPED,'/01'
#         END IF
#         LET g_head1 = g_head1,'-',tm.yy USING '<<<<','/',tm.em USING'&&'
#         IF tm.dd IS NOT NULL THEN
#            LET g_head1 = g_head1,'/',tm.dd USING '&&'
#         END IF
#         #PRINT g_head1                                          #FUN-660060 remark
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1  #FUN-660060
#         PRINT g_dash2[1,g_len]
#         PRINT COLUMN g_c[32],g_x[15],
#               COLUMN g_c[34],g_x[16],
#               COLUMN g_c[36],g_x[17],
#               COLUMN g_c[38],g_x[18]
#         PRINT COLUMN g_c[32],g_dash2[1,g_w[32]+g_w[33]+1],
#               COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+1],
#               COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+1],
#               COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+1]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#               g_x[39]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
#     
#      ON EVERY ROW
#         IF tm.h = 'Y' THEN
#            LET maj.maj20 = maj.maj20e
#         END IF
#         CASE
#            WHEN maj.maj03 = '9'
#               SKIP TO TOP OF PAGE
#            WHEN maj.maj03 = '3'
#               PRINT COLUMN g_c[32],g_dash2[1,g_len-g_w[31]-1] #No.TQC-5C0037
#            WHEN maj.maj03 = '4'
#               PRINT COLUMN g_c[32],g_dash2[1,g_len-g_w[31]-1] #No.TQC-5C0037
#            OTHERWISE
#               FOR i = 1 TO maj.maj04
#                  PRINT
#               END FOR        #空行
#               PRINT COLUMN g_c[31],maj.maj20,
#                     COLUMN g_c[32],cl_numfor(sr.bal1_1/g_unit,32,tm.e),
#                     COLUMN g_c[33],cl_numfor(sr.bal1_2/g_unit,33,tm.e),
#                     COLUMN g_c[34],cl_numfor(sr.bal2_1/g_unit,34,tm.e),
#                     COLUMN g_c[35],cl_numfor(sr.bal2_2/g_unit,35,tm.e),
#                     COLUMN g_c[36],sr.bal3_1 USING '#########&',
#                     COLUMN g_c[37],sr.bal3_2 USING '#########&',
#                     COLUMN g_c[38],cl_numfor(sr.bal4_1/g_unit,38,tm.e),
#                     COLUMN g_c[39],cl_numfor(sr.bal4_2/g_unit,39,tm.e) 
#         END CASE
#     
#      ON LAST ROW
#          PRINT g_dash[1,g_len]
#          LET l_last_sw = 'y'
#          PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF 
#              
#END REPORT
#end FUN-770044 mark

###GENGRE###START
FUNCTION aglg105_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg105")
        IF handler IS NOT NULL THEN
            START REPORT aglg105_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg105_datacur1 CURSOR FROM l_sql
            FOREACH aglg105_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg105_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg105_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg105_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50158------add----str-----
    DEFINE l_period1      STRING
    DEFINE l_period2      STRING
    DEFINE l_unit         STRING
    DEFINE l_bal1_1_fmt   STRING
    DEFINE l_bal1_2_fmt   STRING
    DEFINE l_bal2_1_fmt   STRING
    DEFINE l_bal2_2_fmt   STRING
    DEFINE l_maj20        LIKE maj_file.maj20
    DEFINE l_em           STRING
    DEFINE l_bm           STRING
    DEFINE l_dd           STRING
    #FUN-B50158------add----end-----

    
    ORDER EXTERNAL BY sr1.maj02,sr1.line
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B50158------add----str-----
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit

            LET l_bm = tm.bm
            LET l_bm = l_bm.trim()
            IF cl_null(tm.dd) THEN
               IF tm.bm < 10 THEN
                  LET l_period1 = tm.yy,"/0",l_bm CLIPPED
               ELSE
                  LET l_period1 = tm.yy,'/',l_bm CLIPPED
               END IF
            ELSE
               IF tm.bm < 10 THEN
                  LET l_period1 = tm.yy,"/0",l_bm CLIPPED,"/01" 
               ELSE
                  LET l_period1 = tm.yy,'/',l_bm CLIPPED,"/01"
               END IF
            END IF
            PRINTX l_period1

            LET l_em = tm.em
            LET l_em = l_em.trim()
            LET l_dd = tm.dd
            LET l_dd = l_dd.trim()
            IF cl_null(tm.dd) THEN
               IF tm.em < 10 THEN
                  LET l_period2 = tm.yy,"/0",l_em CLIPPED
               ELSE
                  LET l_period2 = tm.yy,'/',l_em CLIPPED
               END IF
            ELSE
               IF tm.em < 10 THEN
                  IF tm.dd < 10 THEN
                     LET l_period2 = tm.yy,"/0",l_em CLIPPED,"/0",l_dd CLIPPED
                  ELSE
                     LET l_period2 = tm.yy,"/0",l_em CLIPPED,"/",l_dd CLIPPED
                  END IF
               ELSE
                  IF tm.dd < 10 THEN
                     LET l_period2 = tm.yy,"/",l_em CLIPPED,"/0",l_dd CLIPPED
                  ELSE
                     LET l_period2 = tm.yy,"/",l_em CLIPPED,"/",l_dd CLIPPED
                  END IF
               END IF
            END IF
            PRINTX l_period2
            #FUN-B50158------str----end-----
              
        BEFORE GROUP OF sr1.maj02
        BEFORE GROUP OF sr1.line

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50158------add----str----
            IF tm.e = 'Y' THEN
               LET l_maj20 = sr1.maj20e
            ELSE
               LET l_maj20 = sr1.maj20
            END IF
            PRINTX l_maj20

            LET l_bal1_1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal1_1_fmt
            LET l_bal1_2_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal1_2_fmt
            LET l_bal2_1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal2_1_fmt
            LET l_bal2_2_fmt = cl_gr_numfmt("aah_file","aah05",tm.e)
            PRINTX l_bal2_2_fmt
            #FUN-B50158------add----end-----
            PRINTX sr1.*

        AFTER GROUP OF sr1.maj02
        AFTER GROUP OF sr1.line

        
        ON LAST ROW

END REPORT
###GENGRE###END
