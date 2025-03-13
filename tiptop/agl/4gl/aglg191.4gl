# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg191.4gl
# Descriptions...: 部門全年度實際預算比較報表列印
# Date & Author..: 96/09/05 By Melody
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗
# Modify.........: No.MOD-520085 05/02/25 By Nicola 預算編號與列印內容位置對調,並配合列印內容決定是否要輸入預算編號
# Modify.........: No.MOD-540189 05/04/28 By ching fix預算加減項
# Modify.........: No.MOD-570228 05/08/05 By Smapmin 報表表頭列印有誤
# Modify.........: No.MOD-5A0263 05/11/08 By Smapmin 年合計差異比率計算公式 = 合計差異金額/合計預算金額 * 100
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier 報表格式調整
# Modify.........: No.TQC-6B0097 06/12/12 By Smapmin 族群編號開窗
# Modify.........: No.FUN-6C0012 07/01/04 By Judy 調整報表
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-740020 07/04/10 By mike  會計科目加帳套
# Modify.........: No.FUN-780061 07/08/22 By zhoufeng 報表輸出改為Crystal Report
# Modify.........: NO.FUN-810069 08/02/28 By destiny 預算編號改為預算項目
# Modify.........: No.FUN-830139 08/04/07 By bnlent 去掉預算項目字段
# Modify.........: No.MOD-8B0116 08/11/12 By Sarah 合計階數處理的ELSE段應加入判斷maj03='5'
# Modify.........: No.MOD-8B0126 08/11/12 By clover maj.maj03 MATCHES "[012]" 改為 [0125]
# Modify.........: No.MOD-8C0186 08/12/22 By Sarah 當列印內容tm.kind選1.實際&預算時,實際金額應抓afc07(已消耗預算)來呈現
# Modify.........: No.CHI-8C0029 09/02/24 By Sarah 增加"列印下層部門"功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:CHI-A30009 10/04/09 By Summer 針對預算部分與 maj09 合計減項時再 * -1 
# Modify.........: No:CHI-A50008 10/05/10 By Summer 選【1:實際&預算】,營業成本應為正數
# Modify.........: No:MOD-A80250 10/09/01 By Dido ARRAY 變數宣告調整 
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-AB0020 10/11/08 By lixh1   添加預算項目(afc01)欄位
# Modify.........: No:MOD-B30040 11/03/07 By Dido 清空 g_buf 資料 
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No:FUN-B80161 11/09/07 By chenying 明細類CR轉GR 
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            rtype  LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
            a      LIKE mai_file.mai01,       #報表結構編號 #No.FUN-680098 VARCHAR(6)
            b      LIKE aaa_file.aaa01,       #帳別編號     #No.FUN-670039
            abe01  LIKE abe_file.abe01,
            yy     LIKE type_file.num5,       #輸入年度 #No.FUN-680098 smallint
            kind   LIKE type_file.chr1,       #No.FUN-680098 VARCHAR(1)
            afc01  LIKE afc_file.afc01,       #預算項目   #FUN-AB0020
            c      LIKE type_file.chr1,       #異動額及餘額為0者是否列印  #No.FUN-680098 VARCHAR(1)
            d      LIKE type_file.chr1,       #金額單位      #No.FUN-680098 VARCHAR(1)
            f      LIKE type_file.num5,       #列印最小階數  #No.FUN-680098 smallint 
            h      LIKE type_file.chr4,       #額外說明類別  #No.FUN-680098 VARCHAR(4)
            s      LIKE type_file.chr1,       #列印下層部門  #CHI-8C0029 add
            o      LIKE type_file.chr1,       #轉換幣別否    #No.FUN-680098 VARCHAR(1)
            r      LIKE azi_file.azi01,       #幣別
            p      LIKE azi_file.azi01,       #幣別
            q      LIKE azj_file.azj03,       #匯率
            more   LIKE type_file.chr1        #Input more condition(Y/N) #No.FUN-680098 VARCHAR(1) 
           END RECORD,
       i,j,k       LIKE type_file.num5,       #No.FUN-680098 smallint
       g_unit      LIKE type_file.num10,      #金額單位基數  #No.FUN-680098 integer
       g_buf       LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(500)
       g_abe01     LIKE abe_file.abe01,
       m_abd02     LIKE abd_file.abd02,       #No.FUN-680098  VARCHAR(6)
       g_bookno    LIKE aah_file.aah00,       #帳別 #No.FUN-740020
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_tot_01    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_02    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_03    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_04    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_05    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_06    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_07    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_08    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_09    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_10    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_11    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot_12    ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_01   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_02   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_03   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_04   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_05   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_06   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_07   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_08   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_09   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_10   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_11   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       g_tot1_12   ARRAY[100] OF LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
       rep_cnt     LIKE type_file.num5     #No.FUN-680098   smallint
DEFINE g_aaa03     LIKE aaa_file.aaa03
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose     #No.FUN-680098 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(72)
DEFINE g_sql       STRING                  #No.FUN-780061
DEFINE g_str       STRING                  #No.FUN-780061
DEFINE l_table     STRING                  #No.FUN-780061
 
###GENGRE###START
TYPE sr1_t RECORD
    gem01 LIKE gem_file.gem01,
    gem02 LIKE gem_file.gem02,
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal_1 LIKE type_file.num20_6,
    bal_2 LIKE type_file.num20_6,
    bal_3 LIKE type_file.num20_6,
    bal_4 LIKE type_file.num20_6,
    bal_5 LIKE type_file.num20_6,
    bal_6 LIKE type_file.num20_6,
    bal_7 LIKE type_file.num20_6,
    bal_8 LIKE type_file.num20_6,
    bal_9 LIKE type_file.num20_6,
    bal_10 LIKE type_file.num20_6,
    bal_11 LIKE type_file.num20_6,
    bal_12 LIKE type_file.num20_6,
    bal1_1 LIKE type_file.num20_6,
    bal1_2 LIKE type_file.num20_6,
    bal1_3 LIKE type_file.num20_6,
    bal1_4 LIKE type_file.num20_6,
    bal1_5 LIKE type_file.num20_6,
    bal1_6 LIKE type_file.num20_6,
    bal1_7 LIKE type_file.num20_6,
    bal1_8 LIKE type_file.num20_6,
    bal1_9 LIKE type_file.num20_6,
    bal1_10 LIKE type_file.num20_6,
    bal1_11 LIKE type_file.num20_6,
    bal1_12 LIKE type_file.num20_6,
    l_amt01 LIKE type_file.num20_6,
    l_amt02 LIKE type_file.num20_6,
    l_amt03 LIKE type_file.num20_6,
    l_amt04 LIKE type_file.num20_6,
    l_amt05 LIKE type_file.num20_6,
    l_amt06 LIKE type_file.num20_6,
    l_amt07 LIKE type_file.num20_6,
    l_amt08 LIKE type_file.num20_6,
    l_amt09 LIKE type_file.num20_6,
    l_amt10 LIKE type_file.num20_6,
    l_amt11 LIKE type_file.num20_6,
    l_amt12 LIKE type_file.num20_6,
    l_per01 LIKE fid_file.fid03,
    l_per02 LIKE fid_file.fid03,
    l_per03 LIKE fid_file.fid03,
    l_per04 LIKE fid_file.fid03,
    l_per05 LIKE fid_file.fid03,
    l_per06 LIKE fid_file.fid03,
    l_per07 LIKE fid_file.fid03,
    l_per08 LIKE fid_file.fid03,
    l_per09 LIKE fid_file.fid03,
    l_per10 LIKE fid_file.fid03,
    l_per11 LIKE fid_file.fid03,
    l_per12 LIKE fid_file.fid03,
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
 
   LET g_sql="gem01.gem_file.gem01,gem02.gem_file.gem02,maj20.maj_file.maj20,",
             "maj20e.maj_file.maj20e,maj02.maj_file.maj02,",
             "maj03.maj_file.maj03,bal_1.type_file.num20_6,",
             "bal_2.type_file.num20_6,bal_3.type_file.num20_6,",
             "bal_4.type_file.num20_6,bal_5.type_file.num20_6,",
             "bal_6.type_file.num20_6,bal_7.type_file.num20_6,",
             "bal_8.type_file.num20_6,bal_9.type_file.num20_6,",
             "bal_10.type_file.num20_6,bal_11.type_file.num20_6,",
             "bal_12.type_file.num20_6,bal1_1.type_file.num20_6,",
             "bal1_2.type_file.num20_6,bal1_3.type_file.num20_6,",
             "bal1_4.type_file.num20_6,bal1_5.type_file.num20_6,",
             "bal1_6.type_file.num20_6,bal1_7.type_file.num20_6,",
             "bal1_8.type_file.num20_6,bal1_9.type_file.num20_6,",
             "bal1_10.type_file.num20_6,bal1_11.type_file.num20_6,",
             "bal1_12.type_file.num20_6,l_amt01.type_file.num20_6,",
             "l_amt02.type_file.num20_6,l_amt03.type_file.num20_6,",
             "l_amt04.type_file.num20_6,l_amt05.type_file.num20_6,",
             "l_amt06.type_file.num20_6,l_amt07.type_file.num20_6,",
             "l_amt08.type_file.num20_6,l_amt09.type_file.num20_6,",
             "l_amt10.type_file.num20_6,l_amt11.type_file.num20_6,",
             "l_amt12.type_file.num20_6,l_per01.fid_file.fid03,",
             "l_per02.fid_file.fid03,l_per03.fid_file.fid03,",
             "l_per04.fid_file.fid03,l_per05.fid_file.fid03,",
             "l_per06.fid_file.fid03,l_per07.fid_file.fid03,",
             "l_per08.fid_file.fid03,l_per09.fid_file.fid03,",
             "l_per10.fid_file.fid03,l_per11.fid_file.fid03,",
             "l_per12.fid_file.fid03,line.type_file.num5"
   LET l_table = cl_prt_temptable('aglg191',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
 
   LET g_bookno = ARG_VAL(1)    #No.FUN-740020
   LET g_pdate  = ARG_VAL(2)    # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)   #TQC-610056
   LET tm.abe01 = ARG_VAL(11)
   LET tm.yy    = ARG_VAL(12)
   LET tm.kind  = ARG_VAL(13)   #TQC-610056
   LET tm.c     = ARG_VAL(14)
   LET tm.d     = ARG_VAL(15)
   LET tm.f     = ARG_VAL(16)
   LET tm.h     = ARG_VAL(17)
   LET tm.s     = ARG_VAL(18)   #CHI-8C0029 add
   LET tm.o     = ARG_VAL(19)
   LET tm.r     = ARG_VAL(20)   #TQC-610056
   LET tm.p     = ARG_VAL(21)
   LET tm.q     = ARG_VAL(22)
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26) #No.FUN-7C0078
   LET tm.afc01 = ARG_VAL(27)   #FUN-AB0020
  
   IF cl_null(g_bookno) THEN                  
      LET g_bookno = g_aaz.aaz64               
   END IF
 
   IF cl_null(tm.b) THEN                    
      LET tm.b = g_aza.aza81                
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g191_tm()
   ELSE
      CALL g191()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION g191_tm()
  DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680098 smalint
          l_sw         LIKE type_file.chr1,     #重要欄位是否空白  #No.FUN-680098 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000   #No.FUN-680098    VARCHAR(400)
  DEFINE li_chk_bookno LIKE type_file.num5      #No.FUN-670005    #No.FUN-680098  smallint
  DEFINE li_result    LIKE type_file.num5      #No.FUN-6C0068
  DEFINE l_azfacti    LIKE azf_file.azfacti
 
   CALL s_dsmark(g_bookno)                    
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW g191_w AT p_row,p_col
     WITH FORM "agl/42f/aglg191"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)           
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno  
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123  #No.FUN-740020   
   END IF
 
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.s = 'N'   #CHI-8C0029 add
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
   WHILE TRUE
      LET l_sw = 1
 
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.abe01,tm.yy,tm.f,  #No.FUN-740020   
                    tm.kind,tm.afc01,tm.d,tm.c,tm.h,tm.s,tm.o,tm.r,   #No.MOD-520085 #No.FUN-830139 del tm.budget  #CHI-8C0029 add tm.s   #FUN-AB0020 add tm.afc01
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
               AND mai00 = tm.b     #No.FUN-740020   
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
             CALL s_check_bookno(g_bookno,g_user,g_plant)     
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
            SELECT aaa02 FROM aaa_file
             WHERE aaa01 = g_bookno
               AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123   #No.FUN-740020   
               NEXT FIELD b
            END IF
 
         AFTER FIELD abe01
            IF tm.abe01 IS NULL THEN
               NEXT FIELD abe01
            END IF
            SELECT UNIQUE abe01 INTO g_abe01
              FROM abe_file
             WHERE abe01 = tm.abe01
            IF STATUS = 100 THEN
               LET g_abe01 = ' '
               SELECT * FROM gem_file
                WHERE gem01 = tm.abe01
                  AND gem05 = 'Y'
               IF STATUS = 100 THEN
                  NEXT FIELD abe01
               END IF
            END IF
            IF cl_chkabf(tm.abe01) THEN
               NEXT FIELD abe01
            END IF
 
         BEFORE FIELD kind
             CALL g191_set_entry()  #No.MOD-520085
 
         AFTER FIELD kind
            IF cl_null(tm.kind) OR tm.kind NOT MATCHES '[123]' THEN
               NEXT FIELD kind
            END IF
             CALL g191_set_no_entry()   #No.MOD-520085


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
             
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
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
 
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0 THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF
 
         AFTER FIELD s
            IF tm.s NOT MATCHES "[YN]" THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
 
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more
            END IF
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file
             WHERE azi01 = tm.p
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
            IF INFIELD(a) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020  #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF
            IF INFIELD(abe01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_abe'
               LET g_qryparam.default1 = tm.abe01
               CALL cl_create_qry() RETURNING tm.abe01
               DISPLAY BY NAME tm.abe01
               NEXT FIELD abe01
            END IF
            
#FUN-AB0020 --------------Begin--------------------
            IF INFIELD(afc01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azf'    
               LET g_qryparam.default1 = tm.afc01
               LET g_qryparam.arg1 = '2'        
               CALL cl_create_qry() RETURNING tm.afc01
               DISPLAY BY NAME tm.afc01
               NEXT FIELD afc01
            END IF  
#FUN-AB0020 ---------------End--------------------- 
            
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
         CLOSE WINDOW g191_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg191'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg191','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,  
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",  #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",     #TQC-610056
                        " '",tm.abe01 CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.kind CLIPPED,"'",  #TQC-610056
                        " '",tm.afc01 CLIPPED,"'", #FUN-AB0020                       
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",     #CHI-8C0029 add
                        " '",tm.o CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",     #TQC-610056
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",   #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",   #No.FUN-570264
                        " '",g_template CLIPPED,"'",   #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"    #No.FUN-7C0078
            CALL cl_cmdat('aglg191',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g191_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL g191()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g191_w
 
END FUNCTION
 
FUNCTION g191()
   DEFINE l_name    LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098 VARCHAR(10)
   DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT    #No.FUN-680098  VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1         #No.FUN-680098   VARCHAR(1)
   DEFINE l_za05    LIKE za_file.za05           #No.FUN-680098   VARCHAR(40)
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE l_leng    LIKE type_file.num5         #No.FUN-680098  smallint
   DEFINE l_str     LIKE type_file.chr1000      #No.FUN-780061
 
   CALL cl_del_data(l_table)                    #No.FUN-780061
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b            #No.FUN-740020   
      AND aaf02 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg191'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   FOR g_i = 1 TO 70 LET g_dash2[g_i,g_i] = '-' END FOR
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g191_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE g191_c CURSOR FOR g191_p
 
   FOR g_i = 1 TO 100
      LET g_tot_01[g_i] = 0
      LET g_tot_02[g_i] = 0
      LET g_tot_03[g_i] = 0
      LET g_tot_04[g_i] = 0
      LET g_tot_05[g_i] = 0
      LET g_tot_06[g_i] = 0
      LET g_tot_07[g_i] = 0
      LET g_tot_08[g_i] = 0
      LET g_tot_09[g_i] = 0
      LET g_tot_10[g_i] = 0
      LET g_tot_11[g_i] = 0
      LET g_tot_12[g_i] = 0
      LET g_tot1_01[g_i] = 0
      LET g_tot1_02[g_i] = 0
      LET g_tot1_03[g_i] = 0
      LET g_tot1_04[g_i] = 0
      LET g_tot1_05[g_i] = 0
      LET g_tot1_06[g_i] = 0
      LET g_tot1_07[g_i] = 0
      LET g_tot1_08[g_i] = 0
      LET g_tot1_09[g_i] = 0
      LET g_tot1_10[g_i] = 0
      LET g_tot1_11[g_i] = 0
      LET g_tot1_12[g_i] = 0
   END FOR
 
   LET g_buf = ''      #MOD-B30040  
   IF g_abe01=' ' THEN                     #--- 部門
      LET m_abd02 = tm.abe01
      SELECT gem05 INTO l_chr FROM gem_file WHERE gem01=tm.abe01
      IF tm.s = 'Y' THEN
         CALL g191_bom(m_abd02,l_chr)
      END IF
 
      IF g_buf IS NULL THEN
         LET g_buf = "'",tm.abe01 CLIPPED,"',"
      END IF
 
      LET l_leng=LENGTH(g_buf)
      LET g_buf=g_buf[1,l_leng-1] CLIPPED
      CALL g191_process(tm.abe01)
   ELSE                                    #--- 族群
      DECLARE g191_bom CURSOR FOR
         SELECT abe03,gem05 FROM abe_file,gem_file
          WHERE abe01 = tm.abe01 AND gem01 = abe03
          ORDER BY abe03
      FOREACH g191_bom INTO l_abe03,l_chr
         IF SQLCA.SQLCODE THEN
            EXIT FOREACH
         END IF
         IF tm.s = 'Y' THEN
            CALL g191_bom(l_abe03,l_chr)
         END IF
 
         IF g_buf IS NULL THEN
            LET g_buf = "'",l_abe03 CLIPPED,"',"
         END IF
 
         LET l_leng = LENGTH(g_buf)
         LET g_buf = g_buf[1,l_leng-1] CLIPPED
         CALL g191_process(l_abe03)
         LET g_buf=''
      END FOREACH
   END IF
 
   LET rep_cnt=0
 
 
   CASE tm.kind
     #FUN-B80161---mod--str----------
     #WHEN '1' LET l_name = 'aglg191'
     #WHEN '2' LET l_name = 'aglg191_1'
     #WHEN '3' LET l_name = 'aglg191_2'
      WHEN '1' LET g_template = 'aglg191'
      WHEN '2' LET g_template = 'aglg191_1'
      WHEN '3' LET g_template = 'aglg191_2'
     #FUN-B80161---mod--end----------
   END CASE
   IF g_towhom IS NULL OR g_towhom = ' ' THEN
      LET l_str = ' ' 
   ELSE
      LET l_str = 'TO:',g_towhom
   END IF
###GENGRE###   LET g_str = tm.a,";",tm.p,";",tm.d,";'';",tm.kind,";", #No.FUN-830139 tm.budget -> ''
###GENGRE###               tm.h,";",g_mai02,";",l_str,";",tm.yy
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   CALL cl_prt_cs3('aglg191',l_name,l_sql,g_str)
    CALL aglg191_grdata()    ###GENGRE###
END FUNCTION
 
FUNCTION g191_process(l_dept)
   DEFINE dept      LIKE gem_file.gem01      #No.FUN-680098  VARCHAR(6)
   DEFINE l_dept    LIKE gem_file.gem01      #No.FUN-680098  VARCHAR(6)
   DEFINE l_sql     LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(800)
   DEFINE l_sql1    LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(800)
  #DEFINE amt1      ARRAY[12] OF LIKE type_file.num20_6     #No.FUN-680098 DECIMAL(20,6) #MOD-A80250 mark 
   DEFINE amt1      DYNAMIC ARRAY OF  LIKE type_file.num20_6                             #MOD-A80250
  #DEFINE amt1_1    ARRAY[12] OF LIKE type_file.num20_6     #No.FUN-680098 DECIMAL(20,6) #MOD-A80250 mark
   DEFINE amt1_1    DYNAMIC ARRAY OF  LIKE type_file.num20_6                             #MOD-A80250 
   DEFINE maj       RECORD LIKE maj_file.* 
   DEFINE bal_01    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_01   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_02    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_02   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)  
          bal_03    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_03   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_04    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_04   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_05    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_05   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_06    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_06   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6) 
          bal_07    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_07   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6) 
          bal_08    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_08   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6) 
          bal_09    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_09   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_10    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_10   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_11    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_11   LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal_12    LIKE type_file.num20_6,     #No.FUN-680098 DECIMAL(20,6)
          bal1_12   LIKE type_file.num20_6      #No.FUN-680098 DECIMAL(20,6)
   DEFINE l_amt01   LIKE type_file.num20_6,  
          l_per01   LIKE fid_file.fid03,     
          l_amt02   LIKE type_file.num20_6,  
          l_per02   LIKE fid_file.fid03,     
          l_amt03   LIKE type_file.num20_6,  
          l_per03   LIKE fid_file.fid03,     
          l_amt04   LIKE type_file.num20_6,  
          l_per04   LIKE fid_file.fid03,     
          l_amt05   LIKE type_file.num20_6,  
          l_per05   LIKE fid_file.fid03,     
          l_amt06   LIKE type_file.num20_6,  
          l_per06   LIKE fid_file.fid03,     
          l_amt07   LIKE type_file.num20_6,  
          l_per07   LIKE fid_file.fid03,     
          l_amt08   LIKE type_file.num20_6,  
          l_per08   LIKE fid_file.fid03,     
          l_amt09   LIKE type_file.num20_6,  
          l_per09   LIKE fid_file.fid03,     
          l_amt10   LIKE type_file.num20_6,  
          l_per10   LIKE fid_file.fid03,     
          l_amt11   LIKE type_file.num20_6,  
          l_per11   LIKE fid_file.fid03,     
          l_amt12   LIKE type_file.num20_6,  
          l_per12   LIKE fid_file.fid03
   DEFINE l_gem02    LIKE gem_file.gem02
 
   IF tm.kind != '1' THEN   #MOD-8C0186 add
      LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                  "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",  #No.FUN-740020   
                  " AND aao03 = '",tm.yy,"' AND aao04=? ",
                  " AND aag00 = '",tm.b,"'  ",                             #No.FUN-740020   
                  " AND aao01 = aag01 AND aag07 IN ('2','3')",
                  " AND aao02 IN (",g_buf CLIPPED,")"      #---- g_buf 部門族群
   ELSE
      LET l_sql = "SELECT SUM(afc07) FROM afc_file,afb_file",
                  "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02",
                  "     AND afc03=afb03 AND afc04=afb04 ",
                  "     AND afc00='",tm.b,"' ",   #No.FUN-830139 
                  "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                  "     AND afb041 IN (",g_buf CLIPPED,")",                 #MOD-9C0100 afb04 modify afb041
                  "     AND afc041=afb041 ",                                #No.FUN-810069
                  "     AND afc042=afb042 ",                                #No.FUN-810069
                  "     AND afbacti = 'Y' ",   #TQC-630238
                  "     AND afc05=? "   #---- 部門預算                      #MOD-9C0100 add
   END IF
#FUN-AB0020 ---------------------Begin---------------------------
   IF NOT cl_null(tm.afc01) THEN
      LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
   END IF
#FUN-AB0020 ---------------------End-----------------------------     
   PREPARE g191_sum FROM l_sql
   DECLARE g191_sumc CURSOR FOR g191_sum
 
  #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
   LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
               "   FROM afc_file,afb_file",
               "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02",
               "     AND afc03=afb03 AND afc04=afb04 ",
               "     AND afc00='",tm.b,"' ",   #No.FUN-830139 
               "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
               "     AND afb041 IN (",g_buf CLIPPED,")",                 #MOD-9C0100 afb04 modify afb041
               "     AND afc041=afb041 ",                                #No.FUN-810069
               "     AND afc042=afb042 ",                                #No.FUN-810069
               "     AND afbacti = 'Y' ",   #TQC-630238
               "     AND afc05=? "   #---- 部門預算                      #MOD-9C0100 add

#FUN-AB0020 ---------------------Begin---------------------------
   IF NOT cl_null(tm.afc01) THEN
      LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
   END IF
#FUN-AB0020 ---------------------End-----------------------------                
   PREPARE g191_sum1 FROM l_sql1
   DECLARE g191_sum1c CURSOR FOR g191_sum1
 
   FOREACH g191_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      FOR i=1 TO 12
         LET amt1[i] = 0
         LET amt1_1[i] = 0
      END FOR
 
      IF NOT cl_null(maj.maj21) THEN
         FOR i=1 TO 12
            OPEN g191_sumc USING maj.maj21,maj.maj22,i
            FETCH g191_sumc INTO amt1[i]
         END FOR
         IF STATUS THEN
            CALL cl_err('sel aah1:',STATUS,1)
            EXIT FOREACH
         END IF
 
         FOR i = 1 TO 12
            IF amt1[i] IS NULL THEN
               LET amt1[i] = 0
            END IF
         END FOR
 
         FOR i = 1 TO 12
            OPEN g191_sum1c USING maj.maj21,maj.maj22,i
            FETCH g191_sum1c INTO amt1_1[i]
         END FOR
         IF STATUS THEN
            CALL cl_err('sel afc:',STATUS,1)
            EXIT FOREACH
         END IF
 
         FOR i = 1 TO 12
            IF amt1_1[i] IS NULL THEN
               LET amt1_1[i] = 0
            END IF
          #CHI-A70050---mark---start---
          ##IF tm.kind='3' AND maj.maj09='-' THEN             #CHI-A30009 mark
          # IF tm.kind MATCHES "[13]" AND maj.maj09='-' THEN  #CHI-A30009
          #    LET amt1_1[i] = amt1_1[i] * -1
          #    LET amt1[i] = amt1[i] * -1                     #CHI-A30009 add
          # END IF
          #CHI-A70050---mark---end---
         END FOR
      END IF
 
      IF tm.o = 'Y' THEN
         FOR i = 1 TO 12
            LET amt1[i] = amt1[i] * tm.q  #匯率的轉換
            LET amt1_1[i] = amt1_1[i] * tm.q  #匯率的轉換
         END FOR
      END IF
 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0  THEN     #合計階數處理
         FOR i = 1 TO 100
            #CHI-A70050---add---start---
             IF maj.maj09 = '-' THEN
                LET g_tot_01[i] = g_tot_01[i] - amt1[1]
                LET g_tot_02[i] = g_tot_02[i] - amt1[2]
                LET g_tot_03[i] = g_tot_03[i] - amt1[3]
                LET g_tot_04[i] = g_tot_04[i] - amt1[4]
                LET g_tot_05[i] = g_tot_05[i] - amt1[5]
                LET g_tot_06[i] = g_tot_06[i] - amt1[6]
                LET g_tot_07[i] = g_tot_07[i] - amt1[7]
                LET g_tot_08[i] = g_tot_08[i] - amt1[8]
                LET g_tot_09[i] = g_tot_09[i] - amt1[9]
                LET g_tot_10[i] = g_tot_10[i] - amt1[10]
                LET g_tot_11[i] = g_tot_11[i] - amt1[11]
                LET g_tot_12[i] = g_tot_12[i] - amt1[12]
                LET g_tot1_01[i] = g_tot1_01[i] - amt1_1[1]
                LET g_tot1_02[i] = g_tot1_02[i] - amt1_1[2]
                LET g_tot1_03[i] = g_tot1_03[i] - amt1_1[3]
                LET g_tot1_04[i] = g_tot1_04[i] - amt1_1[4]
                LET g_tot1_05[i] = g_tot1_05[i] - amt1_1[5]
                LET g_tot1_06[i] = g_tot1_06[i] - amt1_1[6]
                LET g_tot1_07[i] = g_tot1_07[i] - amt1_1[7]
                LET g_tot1_08[i] = g_tot1_08[i] - amt1_1[8]
                LET g_tot1_09[i] = g_tot1_09[i] - amt1_1[9]
                LET g_tot1_10[i] = g_tot1_10[i] - amt1_1[10]
                LET g_tot1_11[i] = g_tot1_11[i] - amt1_1[11]
                LET g_tot1_12[i] = g_tot1_12[i] - amt1_1[12]
             ELSE
            #CHI-A70050---add---end---
                LET g_tot_01[i] = g_tot_01[i] + amt1[1]
                LET g_tot_02[i] = g_tot_02[i] + amt1[2]
                LET g_tot_03[i] = g_tot_03[i] + amt1[3]
                LET g_tot_04[i] = g_tot_04[i] + amt1[4]
                LET g_tot_05[i] = g_tot_05[i] + amt1[5]
                LET g_tot_06[i] = g_tot_06[i] + amt1[6]
                LET g_tot_07[i] = g_tot_07[i] + amt1[7]
                LET g_tot_08[i] = g_tot_08[i] + amt1[8]
                LET g_tot_09[i] = g_tot_09[i] + amt1[9]
                LET g_tot_10[i] = g_tot_10[i] + amt1[10]
                LET g_tot_11[i] = g_tot_11[i] + amt1[11]
                LET g_tot_12[i] = g_tot_12[i] + amt1[12]
                LET g_tot1_01[i] = g_tot1_01[i] + amt1_1[1]
                LET g_tot1_02[i] = g_tot1_02[i] + amt1_1[2]
                LET g_tot1_03[i] = g_tot1_03[i] + amt1_1[3]
                LET g_tot1_04[i] = g_tot1_04[i] + amt1_1[4]
                LET g_tot1_05[i] = g_tot1_05[i] + amt1_1[5]
                LET g_tot1_06[i] = g_tot1_06[i] + amt1_1[6]
                LET g_tot1_07[i] = g_tot1_07[i] + amt1_1[7]
                LET g_tot1_08[i] = g_tot1_08[i] + amt1_1[8]
                LET g_tot1_09[i] = g_tot1_09[i] + amt1_1[9]
                LET g_tot1_10[i] = g_tot1_10[i] + amt1_1[10]
                LET g_tot1_11[i] = g_tot1_11[i] + amt1_1[11]
                LET g_tot1_12[i] = g_tot1_12[i] + amt1_1[12]
             END IF     #CHI-A70050 add
         END FOR
         LET k = maj.maj08
         LET bal_01 = g_tot_01[k]
         LET bal_02 = g_tot_02[k]
         LET bal_03 = g_tot_03[k]
         LET bal_04 = g_tot_04[k]
         LET bal_05 = g_tot_05[k]
         LET bal_06 = g_tot_06[k]
         LET bal_07 = g_tot_07[k]
         LET bal_08 = g_tot_08[k]
         LET bal_09 = g_tot_09[k]
         LET bal_10 = g_tot_10[k]
         LET bal_11 = g_tot_11[k]
         LET bal_12 = g_tot_12[k]
         LET bal1_01 = g_tot1_01[k]
         LET bal1_02 = g_tot1_02[k]
         LET bal1_03 = g_tot1_03[k]
         LET bal1_04 = g_tot1_04[k]
         LET bal1_05 = g_tot1_05[k]
         LET bal1_06 = g_tot1_06[k]
         LET bal1_07 = g_tot1_07[k]
         LET bal1_08 = g_tot1_08[k]
         LET bal1_09 = g_tot1_09[k]
         LET bal1_10 = g_tot1_10[k]
         LET bal1_11 = g_tot1_11[k]
         LET bal1_12 = g_tot1_12[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET bal_01 = bal_01 *-1
            LET bal_02 = bal_02 *-1
            LET bal_03 = bal_03 *-1
            LET bal_04 = bal_04 *-1
            LET bal_05 = bal_05 *-1
            LET bal_06 = bal_06 *-1
            LET bal_07 = bal_07 *-1
            LET bal_08 = bal_08 *-1
            LET bal_09 = bal_09 *-1
            LET bal_10 = bal_10 *-1
            LET bal_11 = bal_11 *-1
            LET bal_12 = bal_12 *-1
            LET bal1_01 = bal1_01 *-1
            LET bal1_02 = bal1_02 *-1
            LET bal1_03 = bal1_03 *-1
            LET bal1_04 = bal1_04 *-1
            LET bal1_05 = bal1_05 *-1
            LET bal1_06 = bal1_06 *-1
            LET bal1_07 = bal1_07 *-1
            LET bal1_08 = bal1_08 *-1
            LET bal1_09 = bal1_09 *-1
            LET bal1_10 = bal1_10 *-1
            LET bal1_11 = bal1_11 *-1
            LET bal1_12 = bal1_12 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08
            LET g_tot_01[i] = 0
            LET g_tot_02[i] = 0
            LET g_tot_03[i] = 0
            LET g_tot_04[i] = 0
            LET g_tot_05[i] = 0
            LET g_tot_06[i] = 0
            LET g_tot_07[i] = 0
            LET g_tot_08[i] = 0
            LET g_tot_09[i] = 0
            LET g_tot_10[i] = 0
            LET g_tot_11[i] = 0
            LET g_tot_12[i] = 0
            LET g_tot1_01[i] = 0
            LET g_tot1_02[i] = 0
            LET g_tot1_03[i] = 0
            LET g_tot1_04[i] = 0
            LET g_tot1_05[i] = 0
            LET g_tot1_06[i] = 0
            LET g_tot1_07[i] = 0
            LET g_tot1_08[i] = 0
            LET g_tot1_09[i] = 0
            LET g_tot1_10[i] = 0
            LET g_tot1_11[i] = 0
            LET g_tot1_12[i] = 0
         END FOR
      ELSE
         IF maj.maj03 = '5' THEN
            LET bal_01  = amt1[1]
            LET bal_02  = amt1[2]
            LET bal_03  = amt1[3]
            LET bal_04  = amt1[4]
            LET bal_05  = amt1[5]
            LET bal_06  = amt1[6]
            LET bal_07  = amt1[7]
            LET bal_08  = amt1[8]
            LET bal_09  = amt1[9]
            LET bal_10  = amt1[10]
            LET bal_11  = amt1[11]
            LET bal_12  = amt1[12]
            LET bal1_01 = amt1_1[1]
            LET bal1_02 = amt1_1[2]
            LET bal1_03 = amt1_1[3]
            LET bal1_04 = amt1_1[4]
            LET bal1_05 = amt1_1[5]
            LET bal1_06 = amt1_1[6]
            LET bal1_07 = amt1_1[7]
            LET bal1_08 = amt1_1[8]
            LET bal1_09 = amt1_1[9]
            LET bal1_10 = amt1_1[10]
            LET bal1_11 = amt1_1[11]
            LET bal1_12 = amt1_1[12]
         ELSE
            LET bal_01  = NULL
            LET bal_02  = NULL
            LET bal_03  = NULL
            LET bal_04  = NULL
            LET bal_05  = NULL
            LET bal_06  = NULL
            LET bal_07  = NULL
            LET bal_08  = NULL
            LET bal_09  = NULL
            LET bal_10  = NULL
            LET bal_11  = NULL
            LET bal_12  = NULL
            LET bal1_01 = NULL
            LET bal1_02 = NULL
            LET bal1_03 = NULL
            LET bal1_04 = NULL
            LET bal1_05 = NULL
            LET bal1_06 = NULL
            LET bal1_07 = NULL
            LET bal1_08 = NULL
            LET bal1_09 = NULL
            LET bal1_10 = NULL
            LET bal1_11 = NULL
            LET bal1_12 = NULL
         END IF   #MOD-8B0116 add
      END IF
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH
      END IF #本行不印出N
 
 
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"  #MOD-8B0126
         AND bal_01=0 AND bal_02=0 AND bal_03=0 AND bal_04=0
         AND bal_05=0 AND bal_06=0 AND bal_07=0 AND bal_08=0
         AND bal_09=0 AND bal_10=0 AND bal_11=0 AND bal_12=0
         AND bal1_01=0 AND bal1_02=0 AND bal1_03=0 AND bal1_04=0
         AND bal1_05=0 AND bal1_06=0 AND bal1_07=0 AND bal1_08=0
         AND bal1_09=0 AND bal1_10=0 AND bal1_11=0 AND bal1_12=0 THEN
         CONTINUE FOREACH                              #餘額為 0 者不列印
      END IF
 
      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                              #最小階數起列印
      END IF
 
      LET dept = l_dept
      IF maj.maj07='2' THEN
         LET bal_01=bal_01*-1
         LET bal_02=bal_02*-1
         LET bal_03=bal_03*-1
         LET bal_04=bal_04*-1
         LET bal_05=bal_05*-1
         LET bal_06=bal_06*-1
         LET bal_07=bal_07*-1
         LET bal_08=bal_08*-1
         LET bal_09=bal_09*-1
         LET bal_10=bal_10*-1
         LET bal_11=bal_11*-1
         LET bal_12=bal_12*-1
      END IF
 
      #CHI-A50008
      #位置搬移,因預算正負會影響差異,故須在算差異前決定預算正負
      #CHI-A30009---start---
      #IF tm.kind = '3' THEN  #CHI-A50008 mark
      IF tm.kind MATCHES '[13]' THEN  #CHI-A50008
        IF bal1_01<0 THEN LET bal1_01=bal1_01*-1 END IF
        IF bal1_02<0 THEN LET bal1_02=bal1_02*-1 END IF
        IF bal1_03<0 THEN LET bal1_03=bal1_03*-1 END IF
        IF bal1_04<0 THEN LET bal1_04=bal1_04*-1 END IF
        IF bal1_05<0 THEN LET bal1_05=bal1_05*-1 END IF
        IF bal1_06<0 THEN LET bal1_06=bal1_06*-1 END IF
        IF bal1_07<0 THEN LET bal1_07=bal1_07*-1 END IF
        IF bal1_08<0 THEN LET bal1_08=bal1_08*-1 END IF
        IF bal1_09<0 THEN LET bal1_09=bal1_09*-1 END IF
        IF bal1_10<0 THEN LET bal1_10=bal1_10*-1 END IF
        IF bal1_11<0 THEN LET bal1_11=bal1_11*-1 END IF
        IF bal1_12<0 THEN LET bal1_12=bal1_12*-1 END IF
      END IF
      #CHI-A30009---end---

      LET l_amt01=bal_01-bal1_01
      IF bal1_01=0 THEN
         LET l_per01=0
      ELSE
         LET l_per01=l_amt01/bal1_01*100
      END IF
 
      LET l_amt02=bal_02-bal1_02
      IF bal1_02=0 THEN
         LET l_per02=0
      ELSE
         LET l_per02=l_amt02/bal1_02*100
      END IF
 
      LET l_amt03=bal_03-bal1_03
      IF bal1_03=0 THEN
         LET l_per03=0
      ELSE
         LET l_per03=l_amt03/bal1_03*100
      END IF
 
      LET l_amt04=bal_04-bal1_04
      IF bal1_04=0 THEN
         LET l_per04=0
      ELSE
         LET l_per04=l_amt04/bal1_04*100
      END IF
 
      LET l_amt05=bal_05-bal1_05
      IF bal1_05=0 THEN
         LET l_per05=0
      ELSE
         LET l_per05=l_amt05/bal1_05*100
      END IF
 
      LET l_amt06=bal_06-bal1_06
      IF bal1_06=0 THEN
         LET l_per06=0
      ELSE
         LET l_per06=l_amt06/bal1_06*100
      END IF
 
      LET l_amt07=bal_07-bal1_07
      IF bal1_07=0 THEN
         LET l_per07=0
      ELSE
         LET l_per07=l_amt07/bal1_07*100
      END IF
 
      LET l_amt08=bal_08-bal1_08
      IF bal1_08=0 THEN
         LET l_per08=0
      ELSE
         LET l_per08=l_amt08/bal1_08*100
      END IF
 
      LET l_amt09=bal_09-bal1_09
      IF bal1_09=0 THEN
         LET l_per09=0
      ELSE
         LET l_per09=l_amt09/bal1_09*100
      END IF
 
      LET l_amt10=bal_10-bal1_10
      IF bal1_10=0 THEN
         LET l_per10=0
      ELSE
         LET l_per10=l_amt10/bal1_10*100
      END IF
 
      LET l_amt11=bal_11-bal1_11
      IF bal1_11=0 THEN
         LET l_per11=0
      ELSE
         LET l_per11=l_amt11/bal1_11*100
      END IF
 
      LET l_amt12=bal_12-bal1_12
      IF bal1_12=0 THEN
         LET l_per12=0
      ELSE
         LET l_per12=l_amt12/bal1_12*100
      END IF
 
      IF tm.d MATCHES '[23]' THEN
         LET bal_01=bal_01/g_unit   LET bal1_01=bal1_01/g_unit
         LET bal_02=bal_02/g_unit   LET bal1_02=bal1_02/g_unit
         LET bal_03=bal_03/g_unit   LET bal1_03=bal1_03/g_unit
         LET bal_04=bal_04/g_unit   LET bal1_04=bal1_04/g_unit
         LET bal_05=bal_05/g_unit   LET bal1_05=bal1_05/g_unit
         LET bal_06=bal_06/g_unit   LET bal1_06=bal1_06/g_unit
         LET bal_07=bal_07/g_unit   LET bal1_07=bal1_07/g_unit
         LET bal_08=bal_08/g_unit   LET bal1_08=bal1_08/g_unit
         LET bal_09=bal_09/g_unit   LET bal1_09=bal1_09/g_unit
         LET bal_10=bal_10/g_unit   LET bal1_10=bal1_10/g_unit
         LET bal_11=bal_11/g_unit   LET bal1_11=bal1_11/g_unit
         LET bal_12=bal_12/g_unit   LET bal1_12=bal1_12/g_unit
         LET l_amt01=l_amt01/g_unit
         LET l_amt02=l_amt02/g_unit
         LET l_amt03=l_amt03/g_unit
         LET l_amt04=l_amt04/g_unit
         LET l_amt05=l_amt05/g_unit
         LET l_amt06=l_amt06/g_unit
         LET l_amt07=l_amt07/g_unit
         LET l_amt08=l_amt08/g_unit
         LET l_amt09=l_amt09/g_unit
         LET l_amt10=l_amt10/g_unit
         LET l_amt11=l_amt11/g_unit
         LET l_amt12=l_amt12/g_unit
      END IF
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
      LET maj.maj20e = maj.maj05 SPACES,maj.maj20e
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=dept AND gem05='Y'

      IF maj.maj04 = 0 THEN
         EXECUTE insert_prep USING dept,l_gem02,maj.maj20,maj.maj20e,maj.maj02,
                                   maj.maj03,bal_01,bal_02,bal_03,bal_04,
                                   bal_05,bal_06,bal_07,bal_08,bal_09,bal_10,
                                   bal_11,bal_12,bal1_01,bal1_02,bal1_03,
                                   bal1_04,bal1_05,bal1_06,bal1_07,bal1_08,
                                   bal1_09,bal1_10,bal1_11,bal1_12,l_amt01,
                                   l_amt02,l_amt03,l_amt04,l_amt05,l_amt06,
                                   l_amt07,l_amt08,l_amt09,l_amt10,l_amt11,
                                   l_amt12,l_per01,l_per02,l_per03,l_per04,
                                   l_per05,l_per06,l_per07,l_per08,l_per09,
                                   l_per10,l_per11,l_per12,'2'
      ELSE
         EXECUTE insert_prep USING dept,l_gem02,maj.maj20,maj.maj20e,maj.maj02, 
                                   maj.maj03,bal_01,bal_02,bal_03,bal_04,       
                                   bal_05,bal_06,bal_07,bal_08,bal_09,bal_10,   
                                   bal_11,bal_12,bal1_01,bal1_02,bal1_03,       
                                   bal1_04,bal1_05,bal1_06,bal1_07,bal1_08,     
                                   bal1_09,bal1_10,bal1_11,bal1_12,l_amt01,     
                                   l_amt02,l_amt03,l_amt04,l_amt05,l_amt06,     
                                   l_amt07,l_amt08,l_amt09,l_amt10,l_amt11,     
                                   l_amt12,l_per01,l_per02,l_per03,l_per04,     
                                   l_per05,l_per06,l_per07,l_per08,l_per09,     
                                   l_per10,l_per11,l_per12,'2'
         FOR i = 1 TO maj.maj04
             EXECUTE insert_prep USING dept,l_gem02,maj.maj20,maj.maj20e, 
                                       maj.maj02,maj.maj03,'0','0','0','0',
                                       '0','0','0','0','0','0','0','0','0',
                                       '0','0','0','0','0','0','0','0','0',
                                       '0','0','0','0','0','0','0','0','0',
                                       '0','0','0','0','0','0','0','0','0',
                                       '0','0','0','0','0','0','0','0','1'
         END FOR
       END IF     
    END FOREACH
 
END FUNCTION
 
FUNCTION g191_bom(l_dept,l_sw)
   DEFINE l_dept          LIKE abd_file.abd01   #No.FUN-680098  VARCHAR(6)
   DEFINE l_sw            LIKE type_file.chr1   #No.FUN-680098 VARCHAR(1)
   DEFINE l_abd02         LIKE aab_file.aab02   #No.FUN-680098 VARCHAR(6)
   DEFINE l_cnt1,l_cnt2   LIKE type_file.num5   #No.FUN-680098  smallint
   DEFINE l_arr           DYNAMIC ARRAY OF RECORD
                             gem01 LIKE gem_file.gem01,
                             gem05 LIKE gem_file.gem05
                          END RECORD
 
   ### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
   LET l_cnt1 = 1
   DECLARE a_curs CURSOR FOR
      SELECT abd02,gem05 FROM abd_file,gem_file
       WHERE abd01 = l_dept AND abd02 = gem01
   FOREACH a_curs INTO l_arr[l_cnt1].*
      LET l_cnt1 = l_cnt1 + 1
   END FOREACH
 
   FOR l_cnt2 = 1 TO l_cnt1 - 1
      IF l_arr[l_cnt2].gem01 IS NOT NULL THEN
         CALL g191_bom(l_arr[l_cnt2].*)
      END IF
   END FOR
   IF l_sw = 'Y' THEN
      LET g_buf = g_buf CLIPPED,"'",l_dept CLIPPED,"',"
   END IF
END FUNCTION
 
FUNCTION g191_set_entry()
 
   IF INFIELD(kind) THEN
      CALL cl_set_comp_entry("budget",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION g191_set_no_entry()
 
   IF INFIELD(kind) AND tm.kind = '2' THEN
      CALL cl_set_comp_entry("budget",FALSE)
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg191_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg191")
        IF handler IS NOT NULL THEN
            START REPORT aglg191_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY gem01,maj02"      #FUN-B80161 add
          
            DECLARE aglg191_datacur1 CURSOR FROM l_sql
            FOREACH aglg191_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg191_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg191_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg191_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80161---add-------str-------
    DEFINE l_tmh    LIKE maj_file.maj20
    DEFINE l_unit        STRING
    DEFINE l_gem01_gem02 STRING
    DEFINE l_sumbal      LIKE type_file.num20_6
    DEFINE l_sumbal1     LIKE type_file.num20_6
    DEFINE l_sumamt      LIKE type_file.num20_6
    DEFINE l_m_per       LIKE type_file.num20_6
    DEFINE l_kind        STRING
    DEFINE l_str         STRING
    #FUN-B80161---add-------end-------
    
    ORDER EXTERNAL BY sr1.gem01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80161 add g_ptime,g_user_name 
          
            PRINTX tm.*
            LET l_unit = cl_gr_getmsg("gre-208",g_lang,tm.d)  #FUN-B80161
            PRINTX l_unit                                     #FUN-B80161
              
        BEFORE GROUP OF sr1.gem01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B80161-------add-------str--------- 
            IF g_towhom IS NULL OR g_towhom = ' ' THEN
               LET l_str = ' '
            ELSE
               LET l_str = 'TO:',g_towhom
            END IF
            PRINTX l_str

            IF tm.h = 'Y' THEN 
               LET l_tmh = sr1.maj20e
            ELSE
               LET l_tmh = sr1.maj20
            END IF
            PRINTX l_tmh             

            LET l_sumbal = sr1.bal_1 + sr1.bal_2 + sr1.bal_3 + sr1.bal_4 + sr1.bal_5 + sr1.bal_6 + sr1.bal_7 +
                           sr1.bal_8 + sr1.bal_9 + sr1.bal_10 + sr1.bal_11 + sr1.bal_12

            LET l_sumbal1= sr1.bal1_1 + sr1.bal1_2 + sr1.bal1_3 + sr1.bal1_4 + sr1.bal1_5 + sr1.bal1_6 + sr1.bal1_7 +
                           sr1.bal1_8 + sr1.bal1_9 + sr1.bal1_10 + sr1.bal1_11 + sr1.bal1_12
        
            LET l_sumamt = sr1.l_amt01 + sr1.l_amt02 + sr1.l_amt03 + sr1.l_amt04 + sr1.l_amt05 + sr1.l_amt06 + sr1.l_amt07 +
                           sr1.l_amt08 + sr1.l_amt09 + sr1.l_amt10 + sr1.l_amt11 + sr1.l_amt12
                            
            IF l_sumbal1 = 0 OR cl_null(l_sumbal1) THEN 
               LET l_m_per = 0
            ELSE
               LET l_m_per = l_sumamt / l_sumbal1 * 100
            END IF
            PRINTX l_sumbal
            PRINTX l_sumbal1
            PRINTX l_sumamt
            PRINTX l_m_per

    
            LET l_gem01_gem02 = sr1.gem01,' ',sr1.gem02
            PRINTX l_gem01_gem02            

            LET l_kind = cl_gr_getmsg("gre-209",g_lang,tm.kind)
            PRINTX l_kind
            #FUN-B80161-------add-------end--------- 

            PRINTX sr1.*

        AFTER GROUP OF sr1.gem01

        
        ON LAST ROW

END REPORT
###GENGRE###END
