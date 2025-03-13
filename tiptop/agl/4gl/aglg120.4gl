# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglg120.4gl
# Descriptions...: 部門實際預算比較報表列印
# Date & Author..: 97/08/22 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/01 By Nicola 報表架構修改
# Modify.........: No.MOD-550140 05/05/27 By Smapmin 部門實際預算比較表如果超過100%出現* 
# Modify.........: No.MOD-5A0261 05/10/21 By Smapmin 若為負數百分比多乘 -1 表現為負值狀態
# Modify.........: No.MOD-610106 06/01/19 By Smapmin 當部門預算為有效時才帶出資料
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier 報表格式調整
# Modify.........: No.MOD-6B0126 06/12/05 By Smapmin 預算需為正值
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限 
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/09 By sherry  會計科目加帳套 
# Modify.........: No.FUN-780060 07/08/22 By destiny 報表格式改為CR輸出
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消管控
# Modify.........: No.FUN-830139 08/04/02 By bnlent 去掉預算項目字段
# Modify.........: No.FUN-850160 08/06/12 By Sarah 比照aglr100多一列印下階部門選項(tm.s)，否則將造成有下階部門之報表金額錯誤
# Modify.........: No.FUN-870160 08/08/11 By Sarah 部門編號欄位增家開窗功能
# Modify.........: No.MOD-930055 09/03/05 By Sarah 預算合計階無考慮正負值
# Modify.........: No.CHI-960090 09/07/21 By chenmoyan 可輸入非會計部門,為非會計部門時"列印下層部門"必勾選
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0076 09/12/09 By Sarah SQL條件裡部門應該是afc041
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:CHI-A30009 10/04/09 By Summer 預算金額錯誤
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-AB0020 10/11/08 By lixh1   增加預算編號(afc01)欄位
# Modify.........: No:MOD-B20048 11/02/14 By Dido 預算金額邏輯調整
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No.FUN-B80158 11/08/26 By yangtt  明細類CR轉換成GRW
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-C50004 12/05/11 By nanbing GR 優化 
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype   LIKE type_file.chr1,  #報表結構編號  #No.FUN-680098   VARCHAR(1)
                 a       LIKE mai_file.mai01,  #報表結構編號  #No.FUN-680098   VARCHAR(6) 
                 b       LIKE aaa_file.aaa01,  #帳別編號      #No.FUN-670039 
                 dept    LIKE gem_file.gem01,  #No.FUN-680098 VARCHAR(6)
                 title1  LIKE type_file.chr8,  #輸入期別名稱  #No.FUN-680098    VARCHAR(8)
                 yy1     LIKE type_file.num5,  #輸入年度      #No.FUN-680098    SMALLINT
                 bm1     LIKE type_file.num5,  #Begin 期別    #No.FUN-680098   SMALLINT
                 em1     LIKE type_file.num5,  # End  期別    #No.FUN-680098    SMALLINT
                 e       LIKE type_file.num5,  #小數位數      #No.FUN-680098    SMALLINT
                 f       LIKE type_file.num5,  #列印最小階數  #No.FUN-680098  SMALLINT 
                 d       LIKE type_file.chr1,  #金額單位      #No.FUN-680098    VARCHAR(1)
                 c       LIKE type_file.chr1,  #異動額及餘額為0者是否列印 #No.FUN-680098   VARCHAR(1)
                 s       LIKE type_file.chr1,  #列印下層部門  #FUN-850160 add
                 h       LIKE type_file.chr4,  #額外說明類別  #No.FUN-680098   VARCHAR(4)
                 o       LIKE type_file.chr1,  #轉換幣別否    #No.FUN-680098   VARCHAR(1)
                 afc01   LIKE afc_file.afc01,  #預算編號      #FUN-AB0020 
                 r       LIKE azi_file.azi01,  #幣別
                 p       LIKE azi_file.azi01,  #幣別
                 q       LIKE azj_file.azj03,  #匯率
                 more    LIKE type_file.chr1   #Input more condition(Y/N) #No.FUN-680098    VARCHAR(1)
              END RECORD,
          bdate,edate   LIKE type_file.dat,            #No.FUN-680098  DATE
          i,j,k         LIKE type_file.num5,           #No.FUN-680098  SMALLINT
          g_unit        LIKE type_file.num10,          #金額單位基數   #No.FUN-680098  INTEGER
          g_buf         LIKE type_file.chr1000,        #FUN-850160 add
          g_bookno      LIKE aah_file.aah00,           #帳別 
          g_mai02       LIKE mai_file.mai02,
          g_mai03       LIKE mai_file.mai03,
          g_tot1        ARRAY[100] OF LIKE type_file.num20_6,     #No.FUN-680098  DEC(20,6)
          g_tot1_1      ARRAY[100] OF LIKE type_file.num20_6,     #No.FUN-680098  DEC(20,6)
          m_gem02       LIKE gem_file.gem02
   DEFINE g_aaa03       LIKE aaa_file.aaa03   
   DEFINE g_i           LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
   DEFINE g_msg         LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
   DEFINE g_sql         STRING
   DEFINE l_table       STRING
   DEFINE g_str         STRING 
###GENGRE###START
TYPE sr1_t RECORD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal1 LIKE aah_file.aah04,
    bal1_1 LIKE aah_file.aah04,
    l_amt1 LIKE aah_file.aah04,
    l_per1 LIKE fid_file.fid04,
    line LIKE type_file.num5
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
 
   LET g_sql="maj20.maj_file.maj20, maj20e.maj_file.maj20e,",
             "maj02.maj_file.maj02, maj03.maj_file.maj03,",
             "bal1.aah_file.aah04,  bal1_1.aah_file.aah04,",
             "l_amt1.aah_file.aah04,l_per1.fid_file.fid04,",
             "line.type_file.num5"
   LET l_table = cl_prt_temptable('aglg120',g_sql) CLIPPED                                                  
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF                                                  
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?)"                                                                                     
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM                                                                             
   END IF 
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)   #TQC-610056
   LET tm.dept  = ARG_VAL(11)
   LET tm.title1= ARG_VAL(12)   #TQC-610056
   LET tm.yy1   = ARG_VAL(13)
   LET tm.bm1   = ARG_VAL(14)
   LET tm.em1   = ARG_VAL(15)
   LET tm.afc01 = ARG_VAL(16)    #FUN-AB0020   
   LET tm.c     = ARG_VAL(17)
   LET tm.d     = ARG_VAL(18)
   LET tm.e     = ARG_VAL(19)
   LET tm.f     = ARG_VAL(20)
   LET tm.h     = ARG_VAL(21)
   LET tm.o     = ARG_VAL(22)
   LET tm.r     = ARG_VAL(23)   #TQC-610056
   LET tm.p     = ARG_VAL(24)
   LET tm.q     = ARG_VAL(25)
   LET tm.s     = ARG_VAL(26)   #FUN-850160 add
   LET g_rep_user = ARG_VAL(27)
   LET g_rep_clas = ARG_VAL(28)
   LET g_template = ARG_VAL(29)
   LET g_rpt_name = ARG_VAL(30)  #No.FUN-7C0078
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF   #No.FUN-740020
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g120_tm()
   ELSE
      CALL g120()  
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION g120_tm()
   DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680098  SMALLINT
   DEFINE l_sw           LIKE type_file.chr1      #重要欄位是否空白 #No.FUN-680098   VARCHAR(1)
   DEFINE l_cmd          LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5      #No.FUN-670005   #No.FUN-680098  smallint 
   DEFINE li_result      LIKE type_file.num5      #No.FUN-6C0068
   DEFINE l_gem05        LIKE gem_file.gem05      #CHI-960090
   DEFINE l_azfacti      LIKE azf_file.azfacti    #FUN-AB0020
 
   CALL s_dsmark(g_bookno)
   LET p_row = 1 LET p_col = 18
 
   OPEN WINDOW g120_w AT p_row,p_col WITH FORM "agl/42f/aglg120"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
 
   LET tm.title1 = 'M.T.D.'
   LET tm.b = g_aza.aza81   #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.s = 'N'   #FUN-850160 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      LET l_sw = 1
 
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.dept,tm.title1,tm.yy1,
                    tm.bm1,tm.em1,tm.afc01,tm.e,tm.f,tm.d,tm.c,tm.s, #No.FUN-830139 移去tm.budget   #FUN-850160 add tm.s    #FUN-AB0020 add tm.afc01
                    tm.h,tm.o,tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS           

         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
      
         AFTER FIELD a
            IF tm.a IS NULL THEN 
               NEXT FIELD a 
            END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = tm.b   #No.FUN-740020
               AND maiacti IN ('Y','y')     
            IF STATUS THEN 
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
               NEXT FIELD b 
            END IF
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
            SELECT aaa02 FROM aaa_file
             WHERE aaa01 = tm.b
               AND aaaacti IN ('Y','y')         
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b 
            END IF
      
         AFTER FIELD dept
            IF tm.dept IS NOT NULL OR tm.dept <> ' ' THEN 
               SELECT gem02,gem05 INTO m_gem02,l_gem05 FROM gem_file         #CHI-960090 add gen05
                WHERE gem01 = tm.dept
                  AND gemacti = 'Y'
               IF STATUS = 100 THEN
                  NEXT FIELD dept
               ELSE                                                                                                                 
                  IF l_gem05 !='Y' THEN                                                                                             
                     LET tm.s='Y'                                                                                                   
                     DISPLAY BY NAME tm.s                                                                                           
                  END IF                                                                                                            
               END IF
            END IF
            
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN 
               NEXT FIELD c
            END IF
 
         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES "[YN]" THEN
               NEXT FIELD s
            ELSE                                                                                                                    
               IF l_gem05!='Y' THEN                                                                                                 
                  IF tm.s = 'N' THEN                                                                                                
                     CALL cl_err(tm.dept,'agl-205',0)                                                                               
                     NEXT FIELD s                                                                                                   
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF
      
         AFTER FIELD yy1
            IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
               NEXT FIELD yy1
            END IF
      
         BEFORE FIELD bm1
            IF tm.rtype='1' THEN
               LET tm.bm1 = 0 DISPLAY '' TO bm1
            END IF
      
         AFTER FIELD bm1
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
            IF tm.bm1 IS NULL THEN
               NEXT FIELD bm1 
            END IF
     
         AFTER FIELD em1
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
            IF tm.em1 IS NULL THEN 
               NEXT FIELD em1
            END IF
            IF tm.bm1 > tm.em1 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD bm1 
            END IF
      
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES '[123]' THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF              
            IF tm.d = '2' THEN 
               LET g_unit = 1000 
            END IF              
            IF tm.d = '3' THEN 
               LET g_unit = 1000000
            END IF
      
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
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF
      
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES '[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
#FUN-AB0020 --------------------Begin----------------------------
      AFTER FIELD afc01
        IF NOT cl_null(tm.afc01) THEN
           SELECT azf01 FROM azf_file
            WHERE azf01 = tm.afc01  AND azf02 = '2'
          IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
             NEXT FIELD afc01
          ELSE
             SELECT azfacti INTO l_azfacti FROM azf_file
              WHERE azf01 = tm.afc01 AND azf02 = '2'
             IF l_azfacti = 'N' THEN
                CALL cl_err(tm.afc01,'agl1002',0)
             END IF
          END IF
       END IF       
#FUN-AB0020 --------------------End------------------------------         
      
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more
            END IF
      
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
               NEXT FIELD p
            END IF
      
         BEFORE FIELD q
            IF tm.o = 'N' THEN
               NEXT FIELD o 
            END IF
      
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT 
            END IF
            IF tm.yy1 IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy1 
               CALL cl_err('',9033,0)
            END IF
            IF tm.bm1 IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm1 
            END IF
            IF tm.em1 IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.em1 
            END IF
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN 
               LET g_unit = 1
            END IF              
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF              
            IF tm.d = '3' THEN 
               LET g_unit = 1000000 
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                 #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042   Mark
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a 
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               
               WHEN INFIELD(b) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b 
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
 
               WHEN INFIELD(dept) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gem'          #CHI-960090
                  LET g_qryparam.default1 = tm.dept
                  CALL cl_create_qry() RETURNING tm.dept 
                  DISPLAY BY NAME tm.dept
                  NEXT FIELD dept
 
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p 
                  DISPLAY BY NAME tm.p
                  NEXT FIELD p

#FUN-AB0020 --------------Begin--------------------
               WHEN INFIELD(afc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azf'    
                  LET g_qryparam.default1 = tm.afc01
                  LET g_qryparam.arg1 = '2'        
                  CALL cl_create_qry() RETURNING tm.afc01
                  DISPLAY BY NAME tm.afc01
                  NEXT FIELD afc01
#FUN-AB0020 ---------------End---------------------                  
               
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
      
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg120'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg120','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",   #TQC-610056
                        " '",tm.dept CLIPPED,"'",
                        " '",tm.title1 CLIPPED,"'",   #TQC-610056
                        " '",tm.yy1 CLIPPED,"'",
                        " '",tm.bm1 CLIPPED,"'",
                        " '",tm.em1 CLIPPED,"'",
                        " '",tm.afc01 CLIPPED,"'",    #FUN-AB0020                          
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",   #TQC-610056
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",           #FUN-850160 add
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg120',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g120()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g120_w
 
END FUNCTION
 
FUNCTION g120()
   DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
   DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT        #No.FUN-680098   VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1           #No.FUN-680098    VARCHAR(1)
   DEFINE l_leng    LIKE type_file.num5           #FUN-850160 add
   DEFINE amt1      LIKE aah_file.aah04
   DEFINE amt1_1    LIKE aah_file.aah04
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1,bal1_1      LIKE aah_file.aah04
                    END RECORD
   DEFINE l_amt1    LIKE aah_file.aah04      #FUN-780060
   DEFINE l_per1    LIKE fid_file.fid03      #FUN-780060
 
   CALL cl_del_data(l_table)               #No.FUN-780060
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
  #tm.s-列印下階部門
   LET g_buf = ''
   IF NOT cl_null(tm.dept) THEN
      IF tm.s = 'Y' THEN
         SELECT gem05 INTO l_chr FROM gem_file WHERE gem01=tm.dept
         CALL g120_bom(tm.dept,l_chr)
      END IF
      IF g_buf IS NULL THEN LET g_buf="'",tm.dept CLIPPED,"'," END IF
      LET l_leng=LENGTH(g_buf)
      LET g_buf=g_buf[1,l_leng-1] CLIPPED
   END IF
 
   CASE
      WHEN tm.rtype='1'
         LET g_msg=" maj23[1,1]='1'"
      WHEN tm.rtype='2'
         LET g_msg=" maj23[1,1]='2'"
      OTHERWISE
         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g120_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g120_c CURSOR FOR g120_p
 
   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0 
      LET g_tot1_1[g_i] = 0 
   END FOR

#FUN-C50004 add sta
   LET l_sql="SELECT SUM(aao05-aao06)",
             "  FROM aao_file,aag_file",
             " WHERE aao00 = '",tm.b,"'",
             "   AND aao00 = aag00",       
             "   AND aao01 BETWEEN ? AND ? ",
             "   AND aao02 IN (",g_buf CLIPPED,")",
             "   AND aao03 = ",tm.yy1,
             "   AND aao04 BETWEEN ",tm.bm1," AND ",tm.em1,
             "   AND aao01 = aag01",
             "   AND aag07 IN ('2','3')"
   PREPARE g120_p1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)             
      EXIT PROGRAM 
   END IF
   DECLARE g120_c1 CURSOR FOR g120_p1
   IF STATUS THEN 
      CALL cl_err('declare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)             
      EXIT PROGRAM 
   END IF

   LET l_sql="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  
             "  FROM afc_file,afb_file",
             " WHERE afc00 = afb00",
             "   AND afc01 = afb01",
             "   AND afc02 = afb02",
             "   AND afc03 = afb03",
             "   AND afc04 = afb04",
             "   AND afc00 = '",tm.b,"'",
             "   AND afb00 = '",tm.b,"'",  
             "   AND afc041= afb041",      
             "   AND afc042= afb042",      
             "   AND afc02 BETWEEN ? AND ? ",
             "   AND afc03 = ",tm.yy1,
             "   AND afc041 IN (",g_buf CLIPPED,")",  
             "   AND afc05 BETWEEN ",tm.bm1," AND ",tm.em1,
             "   AND afbacti = 'Y'"  
   IF NOT cl_null(tm.afc01) THEN
      LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
   END IF                       
   PREPARE g120_p2 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)             
      EXIT PROGRAM 
   END IF
   DECLARE g120_c2 CURSOR FOR g120_p2
   IF STATUS THEN 
      CALL cl_err('declare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)              
      EXIT PROGRAM 
   END IF
#FUN-C50004 end sta
 
   FOREACH g120_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      LET amt1 = 0
      LET amt1_1 = 0 
     
      IF tm.dept IS NULL OR tm.dept=' ' THEN
         IF NOT cl_null(maj.maj21) THEN
            IF maj.maj24 IS NULL THEN
               SELECT SUM(aah04-aah05) INTO amt1
                 FROM aah_file,aag_file
                WHERE aah00 = tm.b
                  AND aah00 = aag00        #No.FUN-740020  
                  AND aah01 BETWEEN maj.maj21 AND maj.maj22
                  AND aah02 = tm.yy1
                  AND aah03 BETWEEN tm.bm1 AND tm.em1
                  AND aah01 = aag01
                  AND aag07 IN ('2','3')
            ELSE 
               SELECT SUM(aao05-aao06) INTO amt1
                 FROM aao_file,aag_file
                WHERE aao00 = tm.b
                  AND aao00 = aag00        #No.FUN-740020  
                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
                  AND aao03 = tm.yy1
                  AND aao04 BETWEEN tm.bm1 AND tm.em1
                  AND aao01 = aag01
                  AND aag07 IN ('2','3')
            END IF
            IF STATUS THEN
               CALL cl_err3("sel","aao_file,aag_file",tm.yy1,"",STATUS,"","sel aah1",1)   #No.FUN-660123
               EXIT FOREACH 
            END IF
            IF amt1 IS NULL THEN 
               LET amt1 = 0
            END IF
#--------------------------------精簡程式-----------------------------------------     
#            IF maj.maj24 IS NOT NULL AND maj.maj24 != ' ' THEN 
#                  SELECT SUM(afc06) INTO amt1_1
#                    FROM afc_file,afb_file
#                   WHERE afc00 = afb00
#                     AND afc01 = afb01
#                     AND afc02 = afb02 
#                     AND afc03 = afb03
#                     AND afc04 = afb04 
#                     AND afc00 = tm.b
#                     AND afb00 = tm.b      #No.FUN-740020 
#                     AND afc041= afb041    #FUN-810069
#                     AND afc042= afb042    #FUN-810069
#                     AND afc02 BETWEEN maj.maj21 AND maj.maj22
#                     AND afc03 = tm.yy1
#                     AND afc041 BETWEEN maj.maj24 AND maj.maj25  #MOD-9C0076 mod afc04->afc041
#                     AND afc05 BETWEEN tm.bm1 AND tm.em1
#                     AND afbacti = 'Y'   #MOD-610106
#            ELSE
#                  SELECT SUM(afc06) INTO amt1_1
#                    FROM afc_file,afb_file
#                   WHERE afc00 = afb00
#                     AND afc01 = afb01
#                     AND afc02 = afb02 
#                     AND afc03 = afb03
#                     AND afc04 = afb04 
#                     AND afc00 = tm.b 
#                     AND afb00 = tm.b      #No.FUN-740020 
#                     AND afc041= afb041    #FUN-810069
#                     AND afc042= afb042    #FUN-810069
#                     AND afc02 BETWEEN maj.maj21 AND maj.maj22
#                     AND afc03 = tm.yy1
#                     AND afc05 BETWEEN tm.bm1 AND tm.em1
#                     AND afbacti = 'Y'   #MOD-610106
#            END IF
           #LET l_sql="SELECT SUM(afc06)",                                                  #CHI-B60055 mark
            LET l_sql="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                      "  FROM afc_file,afb_file",
                      " WHERE afc00 = afb00",
                      "   AND afc01 = afb01",
                      "   AND afc02 = afb02",
                      "   AND afc03 = afb03",
                      "   AND afc04 = afb04",
                      "   AND afc00 = '",tm.b,"'",
                      "   AND afb00 = '",tm.b,"'",   
                      "   AND afc041= afb041",       
                      "   AND afc042= afb042",       
                      "   AND afc02 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
                      "   AND afc03 = ",tm.yy1,
                      "   AND afc05 BETWEEN ",tm.bm1," AND ",tm.em1,
                      "   AND afbacti = 'Y'"   
            IF maj.maj24 IS NOT NULL AND maj.maj24 != ' ' THEN 
               LET l_sql = l_sql," AND afc041 BETWEEN '",maj.maj24,"' AND '",maj.maj25,"'"
            END IF
#FUN-AB0020 ---------------------Begin---------------------------
            IF NOT cl_null(tm.afc01) THEN
               LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
            END IF
#FUN-AB0020 ---------------------End-----------------------------            
            PREPARE g120_p3 FROM l_sql
            IF STATUS THEN
               CALL cl_err('prepare3:',STATUS,1)
               EXIT FOREACH
            END IF
            DECLARE g120_c3 CURSOR FOR g120_p3
            IF STATUS THEN
               CALL cl_err('g120_c3',STATUS,1)
               EXIT FOREACH
            END IF
            OPEN g120_c3
            FETCH g120_c3 INTO amt1_1   
#--------------------------------精簡程式-----------------------------------------            
            IF STATUS THEN
               CALL cl_err3("sel","afc_file,afb_file","","",STATUS,"","sel afc:",1)   #No.FUN-660123              
               EXIT FOREACH
            END IF
            IF amt1_1 IS NULL THEN 
               LET amt1_1 = 0 
            END IF
         END IF      
      ELSE
         IF NOT cl_null(maj.maj21) THEN
         #FUN-C50004 mark sta
         #   LET l_sql="SELECT SUM(aao05-aao06)",
         #             "  FROM aao_file,aag_file",
         #             " WHERE aao00 = '",tm.b,"'",
         #             "   AND aao00 = aag00",        #No.FUN-740020
         #             "   AND aao01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
         #             "   AND aao02 IN (",g_buf CLIPPED,")",
         #             "   AND aao03 = ",tm.yy1,
         #             "   AND aao04 BETWEEN ",tm.bm1," AND ",tm.em1,
         #             "   AND aao01 = aag01",
         #             "   AND aag07 IN ('2','3')"
         #   PREPARE g120_p1 FROM l_sql
         #   IF STATUS THEN
         #      CALL cl_err('prepare1:',STATUS,1)
         #      EXIT FOREACH
         #   END IF
         #   DECLARE g120_c1 CURSOR FOR g120_p1
         #   IF STATUS THEN
         #      CALL cl_err('g120_c1',STATUS,1)
         #      EXIT FOREACH
         #   END IF
         #   OPEN g120_c1
         #FUN-C50004 mark end
            OPEN g120_c1 USING maj.maj21,maj.maj22 #FUN-C50004 add
            FETCH g120_c1 INTO amt1
            IF STATUS THEN
               CALL cl_err3("sel","aao_file,aag_file",tm.dept,"",SQLCA.sqlcode,"","sel aah1",1)   #No.FUN-660123
               EXIT FOREACH 
            END IF
            IF amt1 IS NULL THEN
               LET amt1 = 0
            END IF
 
           #LET l_sql="SELECT SUM(afc06)",              #CHI-B60055 mark
            #FUN-C50004 mark
           # LET l_sql="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
           #           "  FROM afc_file,afb_file",
           #           " WHERE afc00 = afb00",
           #           "   AND afc01 = afb01",
           #           "   AND afc02 = afb02",
           #           "   AND afc03 = afb03",
           #           "   AND afc04 = afb04",
           #           "   AND afc00 = '",tm.b,"'",
           #           "   AND afb00 = '",tm.b,"'",   #No.FUN-740020
           #           "   AND afc041= afb041",       #FUN-810069
           #           "   AND afc042= afb042",       #FUN-810069
           #           "   AND afc02 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
           #           "   AND afc03 = ",tm.yy1,
           #           "   AND afc041 IN (",g_buf CLIPPED,")",  #MOD-9C0076 mod afc04->afc041
           #           "   AND afc05 BETWEEN ",tm.bm1," AND ",tm.em1,
           #           "   AND afbacti = 'Y'"   #MOD-610106
#FUN-AB0020 ---------------------Begin---------------------------
           # IF NOT cl_null(tm.afc01) THEN
           #    LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
           # END IF
#FUN-AB0020 ---------------------End-----------------------------                        
           # PREPARE g120_p2 FROM l_sql
           # IF STATUS THEN
           #    CALL cl_err('prepare2:',STATUS,1)
           #    EXIT FOREACH
           # END IF
           # DECLARE g120_c2 CURSOR FOR g120_p2
           # IF STATUS THEN
           #    CALL cl_err('g120_c2',STATUS,1)
           #    EXIT FOREACH
           # END IF
           # OPEN g120_c2
           #FUN-C50004 mark
            OPEN g120_c2 USING  maj.maj21,maj.maj22 #FUN-C50004 add
            FETCH g120_c2 INTO amt1_1
            IF STATUS THEN
               CALL cl_err3("sel","afc_file,afb_file",tm.yy1,tm.dept,SQLCA.sqlcode,"","sel afc:",1)   #No.FUN-660123
               EXIT FOREACH
            END IF
            IF amt1_1 IS NULL THEN
               LET amt1_1 = 0
            END IF
         END IF      
      END IF

      IF maj.maj07 = '2' THEN       #MOD-B20048 
         LET amt1_1 = amt1_1 * -1   #MOD-B20048
      END IF                        #MOD-B20048
   
     #CHI-A70050---mark---start---
     ##CHI-A30009 add start---
     #IF maj.maj09='-' THEN 
     #   LET amt1_1 = amt1_1 * -1
     #  # LET amt1 = amt1 * -1
     #END IF
     ##CHI-A30009 add end-----
     #CHI-A70050---mark---end---

      IF tm.o = 'Y' THEN
         LET amt1 = amt1 * tm.q   #匯率的轉換
         LET amt1_1 = amt1_1 * tm.q 
      END IF
 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN      #合計階數處理
         FOR i = 1 TO 100
           #CHI-A70050---modify---start---
           #LET g_tot1[i] = g_tot1[i] + amt1
           #LET g_tot1_1[i] = g_tot1_1[i] + amt1_1 
            IF maj.maj09 = '-' THEN
               LET g_tot1[i] = g_tot1[i] - amt1
               LET g_tot1_1[i] = g_tot1_1[i] - amt1_1 
            ELSE
               LET g_tot1[i] = g_tot1[i] + amt1
               LET g_tot1_1[i] = g_tot1_1[i] + amt1_1 
            END IF
           #CHI-A70050---modify---end---
         END FOR
 
         LET k = maj.maj08 
         LET sr.bal1 = g_tot1[k] 
         LET sr.bal1_1 = g_tot1_1[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
            LET sr.bal1_1 = sr.bal1_1 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08 
            LET g_tot1[i] = 0
            LET g_tot1_1[i] = 0 
         END FOR
      ELSE 
         IF maj.maj03 = '5' THEN
            LET sr.bal1 = amt1
            LET sr.bal1_1 = amt1_1
         ELSE
            LET sr.bal1 = NULL 
            LET sr.bal1_1 = NULL 
         END IF
      END IF
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH
      END IF #本行不印出
 
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"               #CHI-CC0023 add maj03 match 5
         AND sr.bal1 = 0 AND sr.bal1_1 = 0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
 
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
 
      IF maj.maj07 = '2' THEN                                                                                                    
         LET sr.bal1  = sr.bal1  * -1
         LET sr.bal1_1= sr.bal1_1* -1   #MOD-930055 add  #CHI-A30009 mark #MOD-B20048 remark
      END IF

      IF tm.h = 'Y' THEN                                                                                                         
         LET maj.maj20 = maj.maj20e                                                                                              
      END IF
      LET l_amt1 = sr.bal1 - sr.bal1_1                                                                                     
                                                                                                                                    
      IF sr.bal1_1 = 0 THEN                                                                                                
         LET l_per1 = 0                                                                                                    
      ELSE                                                                                                                 
         LET l_per1 = l_amt1 / sr.bal1_1 * 100                                                                             
      END IF                                                                                                               
                                                                                                                                  
      IF tm.d MATCHES '[23]' THEN                                                                                          
          LET sr.bal1 = sr.bal1 / g_unit                                                                                    
          LET sr.bal1_1 = sr.bal1_1 / g_unit                                                                                
          LET l_amt1 = l_amt1 / g_unit
      END IF                                                                                                               
                                                                                                                                    
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20   

      IF sr.bal1_1<0 THEN LET sr.bal1_1=sr.bal1_1*-1 END IF #CHI-A30009 add

      IF maj.maj04=0 THEN
         EXECUTE insert_prep USING 
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                 sr.bal1,sr.bal1_1,l_amt1,l_per1,
                 '2'       
      ELSE 
         EXECUTE insert_prep USING
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                 sr.bal1,sr.bal1_1,l_amt1,l_per1,
                 '2'
         FOR i=1 TO maj.maj04
         EXECUTE insert_prep USING
                 maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
                 '0','0','0','0',
                 '1'
         END FOR
      END IF
 
 
   END FOREACH
 
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str= g_mai02,";",tm.d,";",tm.a,";",tm.p,";",tm.yy1,";",tm.bm1,";",                #No.FUN-830139
###GENGRE###              tm.em1,";",tm.title1,";",tm.e,";",m_gem02
###GENGRE###   CALL cl_prt_cs3('aglg120','aglg120',g_sql,g_str)
    CALL aglg120_grdata()    ###GENGRE###
END FUNCTION
 
FUNCTION g120_bom(l_dept,l_sw)
   DEFINE l_dept   LIKE gem_file.gem01
   DEFINE l_sw     LIKE type_file.chr1
   DEFINE l_abd02  LIKE abd_file.abd02
   DEFINE l_cnt1,l_cnt2 LIKE type_file.num5
   DEFINE l_arr    DYNAMIC ARRAY OF RECORD
                    gem01 LIKE gem_file.gem01,
                    gem05 LIKE gem_file.gem05
                   END RECORD
 
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
          CALL g120_bom(l_arr[l_cnt2].*)
       END IF
   END FOR
   IF l_sw = 'Y' THEN
      LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
   END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg120_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg120")
        IF handler IS NOT NULL THEN
            START REPORT aglg120_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY maj02,line"          #FUN-B80158 add
          
            DECLARE aglg120_datacur1 CURSOR FROM l_sql
            FOREACH aglg120_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg120_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg120_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg120_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158------add----str--------
    DEFINE l_a             STRING
    DEFINE l_b             STRING
    DEFINE l_unit          STRING
    DEFINE l_bal1_fmt      STRING
    DEFINE l_bal1_1_fmt    STRING
    DEFINE l_amt1_fmt      STRING
    DEFINE l_yy1           STRING
    DEFINE l_bm1           STRING
    DEFINE l_em1           STRING
    #FUN-B80158------end----str--------

    
    ORDER EXTERNAL BY sr1.maj02,sr1.line
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name    #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158------add----str--------
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit

            LET l_yy1 = tm.yy1
            LET l_bm1 = tm.bm1
            LET l_em1 = tm.em1
            LET l_a = l_yy1.trim(),'/',l_bm1.trim(),'-',l_em1.trim()
            PRINTX l_a

            LET l_b = tm.title1,l_yy1.trim(),'/',l_bm1.trim(),'-',l_em1.trim(),m_gem02 
            PRINTX l_b

            #FUN-B80158------end----str--------
              
        BEFORE GROUP OF sr1.maj02
        BEFORE GROUP OF sr1.line

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158------add----str--------
            LET l_bal1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal1_fmt
            LET l_bal1_1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal1_1_fmt
            LET l_amt1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_amt1_fmt
            #FUN-B80158------end----str--------

            PRINTX sr1.*

        AFTER GROUP OF sr1.maj02
        AFTER GROUP OF sr1.line

        
        ON LAST ROW

END REPORT
###GENGRE###END
