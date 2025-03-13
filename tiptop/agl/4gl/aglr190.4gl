# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: aglr190.4gl
# Descriptions...: 當期部門財務報表
# Date & Author..: 96/08/29 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/21 By Nicola 報表架構修改
# Modify.........: No.FUN-560273 05/07/07 By Nicola 族群編碼,應該要可以開窗選擇
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By Lynn 會計科目加帳套
# Modify.........: No.TQC-770061 07/07/11 By Carrier 去掉maj00的條件
# Modify.........: No.FUN-780060 07/08/29 By destiny 報表格式改為CR輸出
# Modify.........: No.MOD-920093 09/02/10 By liuxqa 畫面上【打印余額為0】，未勾上，但還是可以打印出金額為零的項目。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990078 09/09/08 By mike 報表的百分比計算邏輯有問題，應該是跑完所有報表后找出設定百分比基准的科目與金額，再
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark 
# Modify.........: No:FUN-A30022 10/03/05 By Cockroch 增加選項【是否列印內部管理科目】--aag38
# Modify.........: No:CHI-A70046 10/08/04 By Summer 百分比需依金額單位顯示
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.MOD-C90030 12/09/20 By Elise 將 l_sql/g_buf 改為 STRING
# Modify.........: No:FUN-D70095 13/07/18 BY fengmy 1.CE類憑證結轉科目部門統計檔，報表列印時應減回CE類憑證
#                                                   2.參照gglq812,修改讀取agli116計算邏輯

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
              a       LIKE mai_file.mai01,       #報表結構編號   #No.FUN-680098 VARCHAR(6)
              b       LIKE aaa_file.aaa01,      #帳別編號       #No.FUN-670039
              abe01   LIKE abe_file.abe01,      #列印族群/部門  #No.FUN-680098 VARCHAR(6)
              yy      LIKE aao_file.aao03,      #輸入年度       #No.FUN-680098 smallint
              bm      LIKE aao_file.aao04,      #Begin 期別     #No.FUN-680098 SMALLINT 
              em      LIKE type_file.num5,      #End  期別      #No.FUN-680098  SMALLINT
              c       LIKE type_file.chr1,      #異動額及餘額為0者是否列印 #No.FUN-680098 VARCHAR(1)
              d       LIKE type_file.chr1,      #金額單位      #No.FUN-680098  VARCHAR(1)
              e       LIKE azi_file.azi05,      #小數位數      #No.FUN-680098  smallint 
              f       LIKE type_file.num5,      #列印最小階數  #No.FUN-680098 
              h       LIKE type_file.chr4,      #額外說明類別  #No.FUN-680098 VARCHAR(04)
              aag38   LIKE aag_file.aag38,      #是否列印內部管理科目 #FUN-A30022 ADD
              o       LIKE type_file.chr1,      #轉換幣別否#No.FUN-680098  VARCHAR(1)
              p       LIKE azi_file.azi01,  #幣別
              q       LIKE azj_file.azj03,  #匯率
              r       LIKE azi_file.azi01,  #幣別
              more    LIKE type_file.chr1     #Input more condition(Y/N) #No.FUN-680098 VARCHAR(1)
              END RECORD,
          i,j,k,g_mm LIKE type_file.num5,      #No.FUN-680098  smallint
          g_unit     LIKE type_file.num5,      #金額單位基數 #No.FUN-680098 smallint
         #g_buf      LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(500)  #MOD-C90030 mark
          g_buf      STRING,                   #MOD-C90030
          g_bookno   LIKE aah_file.aah00,      #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_abe01    LIKE abe_file.abe01,
         #g_tot1     ARRAY[50]  OF LIKE type_file.num20_6, #No.FUN-680098  dec(20,6) #CHI-A70046 mark
          g_tot1     ARRAY[100]  OF LIKE type_file.num20_6, #CHI-A70046
         #g_basetot1 ARRAY[100] OF LIKE type_file.num20_6, #No.FUN-680098  dec(20,6) #MOD-990078                                    
          g_basetot1 LIKE aah_file.aah04,    #MOD-990078                                     
          rep_cnt    LIKE type_file.num5                   #No.FUN-680098  smallint
define g_ct LIKE type_file.num10    #No.FUN-680098 integer
DEFINE   g_aaa03         LIKE aaa_file.aaa03   
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
#No.FUN-780060--start--add 
   DEFINE g_sql       STRING    
   DEFINE l_table     STRING   
   DEFINE g_str       STRING   
#No.FUN-780060--end-- 
#No.FUN-D70095  --Begin
   DEFINE g_bal_a     DYNAMIC ARRAY OF RECORD
                      maj02      LIKE maj_file.maj02,
                      maj03      LIKE maj_file.maj03,
                      bal1       LIKE aah_file.aah05,                     
                      maj08      LIKE maj_file.maj08,
                      maj09      LIKE maj_file.maj09
                      END RECORD
#No.FUN-D70095  --End  

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
#No.FUN-780060--start--add  
   LET g_sql="maj20.maj_file.maj20,", 
             "maj20e.maj_file.maj20e,", 
             "maj02.maj_file.maj02,", 
             "maj03.maj_file.maj03,",   
             "bal1.aao_file.aao05,",
             "dept.gem_file.gem01,",  
             "l_gem02.gem_file.gem02,",
             "per1.fid_file.fid03,",
             "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglr120',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
#No.FUN-780060--end--add
 
  #str MOD-990078 add                                                                                                               
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                       
               "   SET per1 =?",                                                                                                    
               " WHERE maj02=? AND dept=? AND line=?"                                                                               
   PREPARE update_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('update_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
  #end MOD-990078 add      
 
   LET g_ct=0
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)   #TQC-610056
   LET tm.abe01 = ARG_VAL(11)
   LET tm.yy = ARG_VAL(12)
   LET tm.bm = ARG_VAL(13)
   LET tm.em = ARG_VAL(14)
   LET tm.c  = ARG_VAL(15)
   LET tm.d  = ARG_VAL(16)
   LET tm.e  = ARG_VAL(17)
   LET tm.f  = ARG_VAL(18)
   LET tm.h  = ARG_VAL(19)
   LET tm.o  = ARG_VAL(20)
   LET tm.r  = ARG_VAL(21)   #TQC-610056
   LET tm.p  = ARG_VAL(22)
   LET tm.q  = ARG_VAL(23)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.aag38 = ARG_VAL(28) #FUN-A30022 ADD
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b)     THEN LET tm.b     = g_aza.aza81 END IF   #No.FUN-740020
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r190_tm()                        # Input print condition
   ELSE
      CALL r190()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r190_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,         #重要欄位是否空白 #No.FUN-680098 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098    VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-670005    #No.FUN-680098 smallint
   DEFINE li_result      LIKE type_file.num5          #No.FUN-6C0068
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r190_w AT p_row,p_col WITH FORM "agl/42f/aglr190" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HC
    
    CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)  # NO.FUN-660123
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)  # NO.FUN-660123
   END IF
#  LET tm.b = g_bookno     #No.FUN-740020
   LET tm.c = 'N'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.aag38='N'   #FUN-A30022 ADD
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET g_buf=''
    LET l_sw = 1
    LET rep_cnt=0
    INPUT BY NAME tm.rtype,tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,
                 tm.e,tm.f,tm.d,tm.c,tm.h,tm.aag38,tm.o,tm.r,    #FUN-A30022 add aag38
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
               CALL cl_err3("sel","mai_file",g_aaa03,"",STATUS,"","sel mai:",0)  # NO.FUN-660123              
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
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF     #No.FUN-740020
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
#              CALL cl_err('sel aaa:',STATUS,0)
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123   
               NEXT FIELD b 
            END IF
         END IF
 
      AFTER FIELD abe01
         IF NOT cl_null(tm.abe01) THEN
            SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
            IF STATUS=100 THEN
               LET g_abe01 =' '
               SELECT * FROM gem_file WHERE gem01=tm.abe01 AND gem05='Y'
               IF STATUS=100 THEN NEXT FIELD abe01 END IF
            END IF
            IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
         END IF
 
      BEFORE FIELD bm
         IF tm.rtype='1' THEN
            LET tm.bm = 0 DISPLAY '' TO bm
         END IF
 
#No.TQC-720032 -- begin --
      AFTER FIELD yy
         IF tm.yy IS NULL OR tm.yy = 0 THEN
            NEXT FIELD yy
         END IF
#No.TQC-720032 -- end --
 
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
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD bm
#         END IF
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
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD d
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
      AFTER FIELD e
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF
 
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
     #FUN-A30022 ADD END--- 
 
      AFTER FIELD o
         IF tm.o = 'N' THEN 
            LET tm.p = g_aaa03 
            LET tm.q = 1
            DISPLAY g_aaa03 TO p
            DISPLAY BY NAME tm.q
         END IF
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(tm.p,'agl-109',0) # NO.FUN-660123
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)  # NO.FUN-660123 
            NEXT FIELD p
         END IF
 
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
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         IF INFIELD(a) THEN
#           CALL q_mai(0,0,tm.a,'13') RETURNING tm.a
#           CALL FGL_DIALOG_SETBUFFER( tm.a )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
           #LET g_qryparam.where = " mai00 = '",tm.b,"'"     #No.FUN-740020   #No.TQC-C50042   Mark
            LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
            CALL cl_create_qry() RETURNING tm.a 
#            CALL FGL_DIALOG_SETBUFFER( tm.a )
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
          #No.MOD-4C0156 add
         IF  INFIELD(b) THEN
#           CALL q_aaa(0,0,tm.b) RETURNING tm.b
#           CALL FGL_DIALOG_SETBUFFER( tm.b )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.b
            CALL cl_create_qry() RETURNING tm.b 
#            CALL FGL_DIALOG_SETBUFFER( tm.b )
            DISPLAY BY NAME tm.b
            NEXT FIELD b
         END IF
          #No.MOD-4C0156 end
         IF INFIELD(p) THEN
#           CALL q_azi(6,10,tm.p) RETURNING tm.p
#           CALL FGL_DIALOG_SETBUFFER( tm.p )
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azi'
            LET g_qryparam.default1 = tm.p
            CALL cl_create_qry() RETURNING tm.p
#            CALL FGL_DIALOG_SETBUFFER( tm.p )
            DISPLAY BY NAME tm.p
            NEXT FIELD p
         END IF
         #-----No.FUN-560273-----
         IF INFIELD(abe01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_abe'
            LET g_qryparam.default1 = tm.abe01
            CALL cl_create_qry() RETURNING tm.abe01
            DISPLAY BY NAME tm.abe01
            NEXT FIELD abe01
         END IF
         #-----No.FUN-560273-----
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r190_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr190'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr190','9031',1)   
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
                         " '",tm.rtype CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-610056
                         " '",tm.abe01 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
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
         CALL cl_cmdat('aglr190',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r190_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r190()
   ERROR ""
END WHILE
   CLOSE WINDOW r190_w
END FUNCTION
 
FUNCTION r190()
   DEFINE l_name    LIKE type_file.chr20      # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
  #DEFINE l_sql     LIKE type_file.chr1000    # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000)  #MOD-C90030 mark
   DEFINE l_sql     STRING                    #MOD-C90030
   DEFINE l_chr     LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1)            
   DEFINE l_leng    LIKE type_file.num5       #No.FUN-680098  smallint
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE m_abd02   LIKE abd_file.abd02
   DEFINE l_tit     LIKE type_file.chr1000    #No.FUN-780060
   CALL cl_del_data(l_table)                  #No.FUN-780060
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE LET g_msg=" 1= 1 "
   END CASE
   LET g_basetot1 = NULL #MOD-990078  
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
#              " WHERE maj00 = '",tm.b,"'",      #No.FUN-740020  #No.TQC-770061
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r190_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r190_c CURSOR FOR r190_p
 
   LET g_mm = tm.em
   FOR g_i = 1 TO 50 LET g_tot1[g_i] = 0 END FOR
  #FOR g_i = 1 TO 100 LET g_basetot1[g_i] = 0 END FOR #MOD-990078      
 
#  CALL cl_outnam('aglr190') RETURNING l_name
#  START REPORT r190_rep TO l_name
#---------------------------------------------------
   IF g_abe01=' ' THEN                     #--- 部門
      DECLARE r190_curs10 CURSOR FOR 
       SELECT abd02,gem05 FROM abd_file,gem_file WHERE abd01=tm.abe01
                                                   AND gem01=abd02
        ORDER BY 1
      FOREACH r190_curs10 INTO m_abd02,l_chr
          IF SQLCA.SQLCODE THEN 
             EXIT FOREACH 
          END IF
          CALL r190_bom(m_abd02,l_chr)
      END FOREACH
      IF g_buf IS NULL THEN LET g_buf="'",tm.abe01 CLIPPED,"'," END IF
     #LET l_leng=LENGTH(g_buf)                       #MOD-C90030 mark
      LET l_leng = g_buf.getlength()                 #MOD-C90030
     #LET g_buf=g_buf[1,l_leng-1] CLIPPED            #MOD-C90030 mark
      LET g_buf=g_buf.substring(1,l_leng-1) CLIPPED  #MOD-C90030
      CALL r190_process(tm.abe01)
   ELSE                                    #--- 族群
      DECLARE r190_bom CURSOR FOR
       SELECT abe03,gem05 FROM abe_file,gem_file WHERE abe01=tm.abe01
                                                   AND gem01=abe03
        ORDER BY 1
      FOREACH r190_bom INTO l_abe03,l_chr
          IF SQLCA.SQLCODE THEN 
             EXIT FOREACH 
          END IF
          CALL r190_bom(l_abe03,l_chr)
          IF g_buf IS NULL THEN LET g_buf="'",l_abe03 CLIPPED,"'," END IF
         #LET l_leng=LENGTH(g_buf)                       #MOD-C90030 mark
          LET l_leng = g_buf.getlength()                 #MOD-C90030
         #LET g_buf=g_buf[1,l_leng-1] CLIPPED            #MOD-C90030 mark
          LET g_buf=g_buf.substring(1,l_leng-1) CLIPPED  #MOD-C90030
          CALL r190_process(l_abe03)
          LET g_buf=''
      END FOREACH
   END IF
 
   LET rep_cnt=0
#---------------------------------------------------
#  FINISH REPORT r190_rep
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET l_tit=tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&'
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   LET g_str= g_mai02,";",tm.a,";",tm.d,";",tm.p,";",tm.e,";",l_tit,";",g_basetot1 #CHI-A70046 add g_basetot1
   CALL cl_prt_cs3('aglr190','aglr190',g_sql,g_str) 
END FUNCTION
 
FUNCTION r190_process(l_dept)
   DEFINE l_dept     LIKE abd_file.abd01     #No.FUN-680098  VARCHAR(6)
  #DEFINE l_sql      LIKE type_file.chr1000  #No.FUN-680098  VARCHAR(1000)  #MOD-C90030 mark
   DEFINE l_sql      STRING                  #MOD-C90030
   DEFINE amt1       LIKE aao_file.aao05
   DEFINE maj        RECORD LIKE maj_file.*
   DEFINE sr         RECORD
                        dept      LIKE gem_file.gem01,     #No.FUN-680098 VARCHAR(6)
                        bal1      LIKE aao_file.aao05
                     END RECORD
#MOD-990078   ---start
   DEFINE cr         RECORD                                                                                       
                        maj02     LIKE maj_file.maj02,                                                                              
                        bal1      LIKE aao_file.aao05,                                                                              
                        line      LIKE type_file.num5                                                                               
                     END RECORD                
#MOD-990078   ---end
#No.FUN-780060--start--add 
   DEFINE per1         LIKE fid_file.fid03                                                      
   DEFINE l_gem02      LIKE gem_file.gem02
#No.FUN-780060--end--
#No.FUN-D70095--start
   DEFINE l_CE_sum1    LIKE abb_file.abb07
   DEFINE l_CE_sum2    LIKE abb_file.abb07   
   DEFINE l_sw1        LIKE type_file.num5        
   DEFINE l_i          LIKE type_file.num5
   DEFINE g_cnt        LIKE type_file.num5            
   DEFINE l_maj08      LIKE maj_file.maj08     
#No.FUN-D70085--end
    IF l_dept IS NULL THEN 
       RETURN 
    END IF
    LET rep_cnt=rep_cnt+1
    LET g_cnt = 1     #FUN-D70095
### 98/03/04 by connie modify where conditions
    #----------- sql for sum(aao05-aao06)-----------------------------------
    LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                " WHERE aao01 BETWEEN ? AND ? ",
                "   AND aao02 IN (",g_buf CLIPPED,")",     #---- g_buf 部門族群
                "   AND aao03 = '",tm.yy,"'",
                "   AND aao04 BETWEEN '",tm.bm,"' AND '",g_mm,"'",
                "   AND aao00= '",tm.b,"'",
                "   AND aao01 = aag01 AND aao00 = aag00 AND aag07 IN ('2','3')"    #No.FUN-740020
   LET l_sql = l_sql CLIPPED," AND aag38= '",tm.aag38,"'"      #FUN-A30022 ADD     
    PREPARE r190_sum FROM l_sql
    DECLARE r190_sumc CURSOR FOR r190_sum
    #-----------------------------------------------------------------------
    #FUN-D70095--------------------------begin
    LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file " ,   
                " WHERE abb00 = '",tm.b,"'",
                "   AND aba00 = abb00 AND aba01 = abb01",
                "   AND abb03 BETWEEN ? AND ?",
                "   AND abb05 IN (",g_buf CLIPPED,")",
                "   AND aba06 = 'CE'  AND abb06 = ? AND aba03 ='",tm.yy,"'",
                "   AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"'",
                "   AND abapost = 'Y'"               
      PREPARE r121_cesum FROM l_sql
      DECLARE r121_cesumc CURSOR FOR r121_cesum
    #FUN-D70095--------------------------end
    FOREACH r190_c INTO maj.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET amt1 = 0
       IF NOT cl_null(maj.maj21) THEN
          OPEN r190_sumc USING maj.maj21,maj.maj22
          FETCH r190_sumc INTO amt1   
          IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
          IF amt1 IS NULL THEN LET amt1 = 0 END IF
       END IF
     #---------------FUN-D70095----------(S)                
       IF NOT cl_null(maj.maj21) THEN
          OPEN r121_cesumc USING maj.maj21,maj.maj22,'1'
          FETCH r121_cesumc INTO l_CE_sum1   
          IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
          IF l_CE_sum1 IS NULL THEN LET l_CE_sum1 = 0 END IF
          
          OPEN r121_cesumc USING maj.maj21,maj.maj22,'2'
          FETCH r121_cesumc INTO l_CE_sum2   
          IF STATUS THEN CALL cl_err('sel abb:',STATUS,1) EXIT FOREACH END IF
          IF l_CE_sum2 IS NULL THEN LET l_CE_sum2 = 0 END IF
          LET amt1 = amt1 - l_CE_sum1 + l_CE_sum2                  
       END IF           
      #---------------FUN-D70095----------(E) 
 
       IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF      #匯率的轉換
       #---------------FUN-D70095----------(S)
       IF NOT cl_null(maj.maj21) THEN
          IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
             LET amt1 = amt1 * -1            
          END IF
          IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
             LET amt1 = amt1 * -1            
          END IF
          IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
             LET amt1 = amt1 * -1             
          END IF
       END IF
       #---------------FUN-D70095----------(E)
       IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
          #---------------FUN-D70095----------(S)
               IF maj.maj08 = '1' THEN
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].bal1   = amt1                 
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09
               ELSE
                  LET g_bal_a[g_cnt].maj02 = maj.maj02
                  LET g_bal_a[g_cnt].maj03 = maj.maj03
                  LET g_bal_a[g_cnt].maj08 = maj.maj08
                  LET g_bal_a[g_cnt].maj09 = maj.maj09                  
                  LET g_bal_a[g_cnt].bal1   = amt1
                  
                  FOR l_i = g_cnt - 1 TO 1 STEP -1       
                      IF maj.maj08 <= g_bal_a[l_i].maj08 THEN
                         EXIT FOR
                      END IF
                      IF g_bal_a[l_i].maj03 NOT MATCHES "[012]" THEN
                         CONTINUE FOR
                      END IF                    
                      IF l_i = g_cnt - 1 THEN       
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                      IF g_bal_a[l_i].maj09 = '+' THEN
                         LET l_sw1 = 1
                      ELSE
                         LET l_sw1 = -1
                      END IF
                      IF g_bal_a[l_i].maj08 >= l_maj08 THEN   
                         LET g_bal_a[g_cnt].bal1 = g_bal_a[g_cnt].bal1 + 
                             g_bal_a[l_i].bal1 * l_sw1                         
                      END IF
                      IF g_bal_a[l_i].maj08 > l_maj08 THEN
                         LET l_maj08 = g_bal_a[l_i].maj08
                      END IF
                  END FOR
               END IF
          ELSE
          IF maj.maj03='5' THEN
              LET g_bal_a[g_cnt].maj02 = maj.maj02
              LET g_bal_a[g_cnt].maj03 = maj.maj03
              LET g_bal_a[g_cnt].bal1  = amt1              
              LET g_bal_a[g_cnt].maj08 = maj.maj08
              LET g_bal_a[g_cnt].maj09 = maj.maj09
          ELSE
              LET g_bal_a[g_cnt].maj02 = maj.maj02
              LET g_bal_a[g_cnt].maj03 = maj.maj03
              LET g_bal_a[g_cnt].bal1  = 0              
              LET g_bal_a[g_cnt].maj08 = maj.maj08
              LET g_bal_a[g_cnt].maj09 = maj.maj09
          END IF
       END IF
       LET sr.bal1 = g_bal_a[g_cnt].bal1       
       LET g_cnt = g_cnt + 1
       #---------------FUN-D70095----------(E)
       #---------------FUN-D70095---mark-------(S)
         #CHI-A70050---modify---start---
         #FOR i = 1 TO 50 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
#          FOR i = 1 TO 50 
#              IF maj.maj09 = '-' THEN
#                 LET g_tot1[i]=g_tot1[i]-amt1 
#              ELSE
#                 LET g_tot1[i]=g_tot1[i]+amt1 
#              END IF
#          END FOR
#         #CHI-A70050---modify---end---
#          LET k=maj.maj08  LET sr.bal1=g_tot1[k]
#         #CHI-A70050---add---start---
#          IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
#             LET sr.bal1 = sr.bal1 *-1
#          END IF
#         #CHI-A70050---add---end---
#          FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
#       ELSE 
#          IF maj.maj03='5' THEN
#              LET sr.bal1=amt1
#          ELSE
#              LET sr.bal1=NULL 
#          END IF
#       END IF
       #---------------FUN-D70095---mark-------(E)
       IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
         #MOD-990078   ---start    
         #LET g_basetot1[rep_cnt]=sr.bal1
         #IF g_basetot1[rep_cnt] = 0 THEN LET g_basetot1[rep_cnt] = NULL END IF
         #IF maj.maj07='2' THEN LET g_basetot1[rep_cnt]=g_basetot1[rep_cnt]*-1 END IF
          LET g_basetot1 = sr.bal1                                                                                                  
          IF g_basetot1 = 0 THEN                                                                                                    
             LET g_basetot1 = NULL                                                                                                  
          END IF 
          #---------------FUN-D70095---mark----(S)                                                                                                                   
#          IF maj.maj07='2' THEN                                                                                                     
#             LET g_basetot1 = g_basetot1 * -1                                                                                       
#          END IF
          #---------------FUN-D70095---mark----(E)                                                                                                                    
         #MOD-990078   ---END     
         LET g_basetot1=g_basetot1/g_unit #CHI-A70046 add
       END IF
       IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
       IF (tm.c='N' OR maj.maj03='2') AND
           maj.maj03 MATCHES "[01259]" AND sr.bal1=0 THEN    #No.MOD-920093 mod by liuxqa add '59'
          CONTINUE FOREACH                        #餘額為 0 者不列印
       END IF
       IF tm.f>0 AND maj.maj08 < tm.f THEN
          CONTINUE FOREACH                        #最小階數起列印
       END IF
       LET sr.dept=l_dept                               #部門 code 區別用
#No.FUN-780060--start--add
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.dept AND gem05='Y'
       #---------------FUN-D70095---mark----(S) 
#       IF maj.maj07 = '2' THEN 
#          LET sr.bal1 = sr.bal1 * -1
#       END IF  
       #---------------FUN-D70095---mark----(E) 
       IF tm.h = 'Y' THEN 
          LET maj.maj20 = maj.maj20e 
       END IF 
      #LET per1 = (sr.bal1 / g_basetot1[rep_cnt]) * 100 #MOD-990078                                                                
       LET per1 = 0                                     #MOD-990078     
       IF tm.d MATCHES '[23]' THEN  
          LET sr.bal1 = sr.bal1 / g_unit
       END IF 
       LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
       IF maj.maj04=0 THEN 
          EXECUTE insert_prep USING 
                  maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                  sr.bal1,sr.dept,l_gem02,per1,
                  '2'
       ELSE
          EXECUTE insert_prep USING
                  maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                                                                          
                  sr.bal1,sr.dept,l_gem02,per1,                                                                                     
                  '2'   
          FOR i=1 TO maj.maj04      
          EXECUTE insert_prep USING                                                                                                 
                  maj.maj20,maj.maj20e,maj.maj02,maj.maj03,        
                  '0',sr.dept,l_gem02,'0',
                  '1'
          END FOR
       END IF
#No.FUN-780060--end--
#      OUTPUT TO REPORT r190_rep(maj.*, sr.*)
    END FOREACH
  #str MOD-990078 add                                                                                                               
   IF NOT cl_null(g_basetot1) THEN                                                                                                  
      LET l_sql = "SELECT maj02,bal1,line",                                                                                         
                  "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
                  " WHERE dept='",l_dept,"'"                                                                                        
      PREPARE r190_crtmp_p FROM l_sql                                                                                               
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1)                                                                               
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114                                                              
      END IF                                                                                                                        
      DECLARE r190_crtmp_c CURSOR FOR r190_crtmp_p                                                                                  
      FOREACH r190_crtmp_c INTO cr.*                                                                                                
         IF cr.bal1 != 0 THEN                                                                                                       
            LET per1 = (cr.bal1 / g_basetot1) * 100                                                                                 
            EXECUTE update_prep USING per1,cr.maj02,l_dept,cr.line                                                                  
         END IF                                                                                                                     
      END FOREACH                                                                                                                   
   END IF                                                                                                                           
  #str MOD-990078 add      
END FUNCTION
#No.FUN-780060--start--mark
{REPORT r190_rep(maj, sr)
   DEFINE l_last_sw    LIKE type_file.chr1      #No.FUN-680098  VARCHAR(1)
   DEFINE l_unit       LIKE zaa_file.zaa08      #No.FUN-680098  VARCHAR(4)
   DEFINE per1         LIKE fid_file.fid03      #No.FUN-680098  dec(8,3)
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE maj          RECORD LIKE maj_file.*
   DEFINE sr           RECORD
                          dept      LIKE gem_file.gem01,   #No.FUN-680098 VARCHAR(6)
                          bal1      LIKE aao_file.aao05
                       END RECORD
   DEFINE g_head1     STRING
 
   OUTPUT
      TOP MARGIN g_top_margin 
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.dept,maj.maj02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         LET g_x[1] = g_mai02
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
     
         #金額單位之列印
         CASE tm.d
              WHEN '1'  LET l_unit = g_x[13]
              WHEN '2'  LET l_unit = g_x[14]
              WHEN '3'  LET l_unit = g_x[15]
              OTHERWISE LET l_unit = ' '
         END CASE
 
         LET g_head1 = g_x[11] CLIPPED,tm.a,'     ',
                       g_x[16] CLIPPED,tm.p,'     ',
                       g_x[12] CLIPPED,l_unit
         PRINT g_head1
     
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.dept AND gem05='Y'
         LET g_head1 = g_x[17] CLIPPED,sr.dept,' ',l_gem02 
         PRINT g_head1
     
         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '<<<<',
                       '/',tm.bm USING'&&','-',tm.em USING'&&'
         #PRINT g_head1                                          #FUN-660060 remark
         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1  #FUN-660060
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33] 
         PRINT g_dash1
         LET l_last_sw = 'n'
     
      BEFORE GROUP OF sr.dept
         SKIP TO TOP OF PAGE
         LET rep_cnt = rep_cnt + 1
     
      ON EVERY ROW
         IF maj.maj07 = '2' THEN
            LET sr.bal1 = sr.bal1 * -1
         END IF
         IF tm.h = 'Y' THEN
            LET maj.maj20 = maj.maj20e  
         END IF
         CASE
            WHEN maj.maj03 = '9'
               SKIP TO TOP OF PAGE
            WHEN maj.maj03 = '3'
               PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
                     COLUMN g_c[33],g_dash2[1,g_w[33]] 
            WHEN maj.maj03 = '4'
               PRINT g_dash2[1,g_len]
            OTHERWISE
               FOR i = 1 TO maj.maj04 
                  PRINT 
               END FOR
               LET per1 = (sr.bal1 / g_basetot1[rep_cnt]) * 100
               IF tm.d MATCHES '[23]' THEN
                  LET sr.bal1 = sr.bal1 / g_unit 
               END IF
               LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
               PRINT COLUMN g_c[31],maj.maj20,
                     COLUMN g_c[32],cl_numfor(sr.bal1,32,tm.e),
                     COLUMN g_c[33],per1 USING '----&.&& %'
         END CASE
     
      ON LAST ROW
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
     
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
     
END REPORT}
#No.FUN-780060--end--
 
FUNCTION r190_bom(l_dept,l_sw)
    DEFINE l_dept    LIKE abd_file.abd01          #No.FUN-680098 VARCHAR(6)
    DEFINE l_sw      LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
    DEFINE l_abd02   LIKE abd_file.abd02          #No.FUN-680098 VARCHAR(6)
    DEFINE l_cnt1,l_cnt2   LIKE type_file.num5    #No.FUN-680098 smallint
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
 
### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR 
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH 
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN 
           CALL r190_bom(l_arr[l_cnt2].*)
        END IF
    END FOR 
    IF l_sw = 'Y' THEN 
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
