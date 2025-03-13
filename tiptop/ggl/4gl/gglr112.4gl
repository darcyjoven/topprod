# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr112.4gl
# Descriptions...: 利潤表列印
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗
# Modify.........: No.FUN-570087 05/07/27 By Will 新增按agli116中公式維護結果
# Modify.........: No.FUN-580010 05/08/02 By vivien  憑証類報表轉XML
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.MOD-5B0299 05/11/23 By jackie 修改帳結法時數據錯誤問題
# Modify.........: No.FUN-590118 06/01/13 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-640004 06/04/10 By Carier 將帳別擴大至5碼 
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改 
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.TQC-6B0073 06/11/20 By xufeng 報表修改
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740305 07/04/30 By Lynn 制表日期位置在報表名之上
# Modify.........: No.FUN-780057 07/08/24 By mike 報表輸出改為Crystal Reports
# Modify.........: No.TQC-810068 08/01/25 By wujie  1:在agli116作業，"金額來源"欄位選擇"1、科目之期初(借減貸)"，然后打印出來的卻是科目當期的借減貸。
#                                                   2:agli116中，金額來源若選3：科目之期末（借減貸），則應該計算從年初開始推算下來到本期末的余額，但是目前是計算了當期異動
#                                                   3:根據agli116中金額來源和借余/貸余的組合確定打印時金額的正負，原先的有錯
# Modify.........: No.MOD-870141 08/07/17 By Sarah 金額的正負顯示錯誤
# Modify.........: No.TQC-860001 08/10/08 By wujie 調整金額值與正負
# Modify.........: No.MOD-910123 09/01/13 By wujie   年結后，有部門編號時不應抓CE類的傳票金額
# Modify.........: No.MOD-860252 09/02/02 By chenl 增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.MOD-950164 09/05/20 By Sarah 合計階沒計算
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/10 By vealxu 精簡程式碼
# Modify.........: No.TQC-A50151 10/05/26 By Carrier MOD-9C0058追单
# Modify.........: No:MOD-AC0111 10/12/14 By Dido 計算合計階段需增加maj09的控制
# Modify.........: No:TQC-B30210 11/04/02 By yinhy 1.增加條件選項“是否包含審計調整”，如果選是並且bm1,em1;bm2,em2分別等於1,12時,則在生成報表時,將憑證來源碼為AD的資料加入到報表中 
# Modify.........:                                 2.所有有SELECT aba_file 'CE'憑證的地方都加一個條件abapost='Y'
# Modify.........: No:TQC-B60325 11/07/12 By elva CE凭证报表修改
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5     #NO FUN-690009   SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.num5,      #NO FUN-690009   VARCHAR(1)
              a       LIKE mai_file.mai01,      #NO FUN-690009   VARCHAR(6)   #報表結構編號
              b       LIKE aaa_file.aaa01,      #帳別編號        #No.FUN-640004
              title1  LIKE type_file.chr20,     # Prog. Version..: '5.30.06-13.03.12(08)  #輸入期別名稱  #No.TQC-A50151
              yy1     LIKE type_file.num5,      #NO FUN-690009   SMALLINT  #輸入年度
              bm1     LIKE type_file.num5,      #NO FUN-690009   SMALLINT  #Begin 期別
              em1     LIKE type_file.num5,      #NO FUN-690009   SMALLINT  # End  期別
              title2  LIKE type_file.chr20,       #NO FUN-690009   VARCHAR(10)  #輸入期別名稱
              yy2     LIKE type_file.num5,      #NO FUN-690009   SMALLINT  #輸入年度
              bm2     LIKE type_file.num5,      #NO FUN-690009   SMALLINT  #Begin 期別
              em2     LIKE type_file.num5,      #NO FUN-690009   SMALLINT  # End  期別
              c       LIKE type_file.chr1,      #NO FUN-690009   VARCHAR(1)   #異動額及餘額為0者是否列印
              d       LIKE type_file.chr1,      #NO FUN-690009   VARCHAR(1)   #金額單位
              e       LIKE type_file.num5,      #NO FUN-690009   SMALLINT  #小數位數
              f       LIKE type_file.num5,      #NO FUN-690009   SMALLINT  #列印最小階數
              h       LIKE type_file.chr4,        # Prog. Version..: '5.30.06-13.03.12(04)  #額外說明類別
              i       LIKE type_file.chr1,      #No.MOD-860252
              o       LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)  #轉換幣別否
              p       LIKE azi_file.azi01,  #幣別
              q       LIKE azj_file.azj03,  #匯率
              r       LIKE azi_file.azi01,  #幣別
              g       LIKE type_file.chr1,      #No TQC-B30210   VARCHAR(1)
              more    LIKE type_file.chr1       #NO FUN-690009   VARCHAR(1)   #Input more condition(Y/N)
              END RECORD,
          bdate,edate LIKE type_file.dat,       #NO FUN-690009   DATE
          i,j,k       LIKE type_file.num5,      #NO FUN-690009   SMALLINT
          g_unit      LIKE type_file.num10,     #NO FUN-690009   INTEGER   #金額單位基數
          g_bookno    LIKE aah_file.aah00,     #帳別
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_tot1      ARRAY[100] OF LIKE aah_file.aah05,     #NO FUN-690009   DEC(20,6)
          g_tot2      ARRAY[100] OF LIKE aah_file.aah05,     #NO FUN-690009   DEC(20,6)
          g_basetot1  LIKE aah_file.aah05,      #NO FUN-690009   DEC(20,6)
          g_basetot2  LIKE aah_file.aah05       #NO FUN-690009   DEC(20,6)
 
DEFINE   g_formula   DYNAMIC ARRAY OF RECORD
                        maj02        LIKE maj_file.maj02,
                        maj27        LIKE maj_file.maj27,
                        lbal1,lbal2  LIKE aah_file.aah05,     #NO FUN-690009   DEC(20,6)
                        bal1,bal2    LIKE aah_file.aah05      #NO FUN-690009   DEC(20,6)
                     END RECORD,
         g_sql       STRING,                 # 查詢語句
         g_for_str   STRING,                 # 當前公式內容
         g_ser_str   STRING,                 # 歷史序號
         g_str_len   LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # 循環計算公式長度中所有出現序號
         g_str_cnt   LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # 循環計數
         g_for_cnt   LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # 從第一筆序號計算出結果開始查詢
         g_beg_pos   LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # 開始位置
         g_end_pos   LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # 結束位置
         g_lbasetot1 LIKE aah_file.aah05,    #NO FUN-690009   DEC(20,6)  # 基准百分比
         g_lbasetot2 LIKE aah_file.aah05,    #NO FUN-690009   DEC(20,6)  # 基准百分比
         g_ltot1     ARRAY[100] OF LIKE aah_file.aah05,     #NO FUN-690009   DEC(20,6)   # 計算上月合計金額
         g_ltot2     ARRAY[100] OF LIKE aah_file.aah05      #NO FUN-690009   DEC(20,6)   # 計算本年合計金額
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000  #NO FUN-690009    VARCHAR(72)
DEFINE   g_str           STRING
DEFINE   l_table         STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql="maj20.maj_file.maj20,",
             "maj02.maj_file.maj02,",    #項次(排序要用的)
             "maj03.maj_file.maj03,",    #列印碼
             "maj26.maj_file.maj26,",
             "bal1.aah_file.aah05,",
             "bal2.aah_file.aah05,",
             "lbal1.aah_file.aah05,",
             "lbal2.aah_file.aah05,",
             "line.type_file.num5,",       #1:表示此筆為空行 2:表示此筆不為空行
             "maj06.maj_file.maj06"    #No.TQC-810068
 
   LET l_table=cl_prt_temptable('gglr112',g_sql) CLIPPED
   IF  l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?)"       #No.TQC-810068
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)   EXIT PROGRAM 
   END IF
 
   LET tm.rtype = '2'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)   #TQC-610056
   LET tm.title1  = ARG_VAL(10)   #TQC-610056
   LET tm.yy1 = ARG_VAL(11)
   LET tm.bm1 = ARG_VAL(12)
   LET tm.em1 = ARG_VAL(13)
   LET tm.title2  = ARG_VAL(14)   #TQC-610056
   LET tm.yy2 = ARG_VAL(15)   #TQC-610056
   LET tm.bm2 = ARG_VAL(16)   #TQC-610056
   LET tm.em2 = ARG_VAL(17)   #TQC-610056
   LET tm.c  = ARG_VAL(18)
   LET tm.d  = ARG_VAL(19)
   LET tm.e  = ARG_VAL(20)   
   LET tm.f  = ARG_VAL(21)
   LET tm.h  = ARG_VAL(22)
   LET tm.o  = ARG_VAL(23)
   LET tm.p  = ARG_VAL(24)
   LET tm.q  = ARG_VAL(25)
   LET tm.r  = ARG_VAL(26)   #TQC-610056
   LET tm.g  = ARG_VAL(27)   #TQC-B30210
   LET tm.rtype = ARG_VAL(28)   #TQC-610056
   LET g_rep_user = ARG_VAL(29)
   LET g_rep_clas = ARG_VAL(30)
   LET g_template = ARG_VAL(31)
   LET g_rpt_name = ARG_VAL(32)  #No.FUN-7C0078
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
 
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r112_tm()                           # Input print condition
   ELSE
      CALL r112()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r112_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_sw           LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5     #No.FUN-6C0068
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW r112_w AT p_row,p_col WITH FORM "ggl/42f/gglr112"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b    
   IF SQLCA.sqlcode THEN 
         CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)    #No.FUN-660124  #No.FUN-740032
    END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03   
   IF SQLCA.sqlcode THEN 
         CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)    #No.FUN-660124     
   END IF
   LET tm.b = g_aza.aza81  #No.FUN-740032
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.i = 'Y'          #No.MOD-860252
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.g = 'N'      #TQC-B30210
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.a,  #No.FUN-740032
                  tm.title1,tm.yy1,tm.bm1,tm.em1,
                  tm.title2,tm.yy2,tm.bm2,tm.em2,
                 tm.c,tm.d,tm.e,tm.f,tm.h,tm.i,tm.o,tm.r, #No.MOD-860252 add tm.i 
                 tm.p,tm.q,tm.g,tm.more WITHOUT DEFAULTS  #No.TQC-B30210 add tm.g
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD a
         IF tm.a IS NULL THEN NEXT FIELD a END IF
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                  AND mai00 = tm.b   #No.FUN-740032
         IF STATUS THEN 
                CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)     #No.FUN-660124
         NEXT FIELD a 
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF  #No.FUN-740032
         IF NOT cl_null(tm.b) THEN
	          CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)    #No.FUN-660124   
               NEXT FIELD b 
            END IF
	 END IF
 
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD yy1
         IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
            NEXT FIELD yy1
         END IF
 
      BEFORE FIELD bm1
         IF tm.rtype='1' THEN
            LET tm.bm1 = 0 DISPLAY '' TO bm1
# genero  script marked             IF cl_ku() THEN NEXT FIELD PREVIOUS ELSE NEXT FIELD NEXT END IF
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
         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
 
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
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF
         IF tm.yy2 IS NULL THEN
            LET tm.yy2 = tm.yy1
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
            DISPLAY BY NAME tm.yy2,tm.bm2,tm.em2
         END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[1234]'  THEN
            NEXT FIELD d
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 10000 END IF  #No.FUN-570087  --add
         IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
      AFTER FIELD e
         IF tm.e < 0 THEN       
            LET tm.e = 0                   
            DISPLAY BY NAME  tm.e 
         END IF
 
      AFTER FIELD f
         IF tm.f IS NULL OR tm.f < 0  THEN
            LET tm.f = 0
            DISPLAY BY NAME tm.f
            NEXT FIELD f
         END IF
 
      AFTER FIELD h
         IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
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
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)    #No.FUN-660124        
         NEXT FIELD p 
         END IF
 
      BEFORE FIELD q
         IF tm.o = 'N' THEN NEXT FIELD o END IF
         
      #No.TQC-B30210  --Begin
      AFTER FIELD g
         IF tm.g IS NULL OR tm.g NOT MATCHES "[YN]" THEN NEXT FIELD g END IF
      #No.TQC-B30210  --End  
      
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
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
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 10000 END IF  #No.FUN-570087  --add
         IF tm.d = '4' THEN LET g_unit = 1000000 END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740032
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
 
            WHEN INFIELD(p)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r112_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gglr112'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr112','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #TQC-610056
                         " '",tm.title1 CLIPPED,"'",   #TQC-610056
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.bm1 CLIPPED,"'",
                         " '",tm.em1 CLIPPED,"'",
                         " '",tm.title2 CLIPPED,"'",   #TQC-610056
                         " '",tm.yy2 CLIPPED,"'",   #TQC-610056
                         " '",tm.bm2 CLIPPED,"'",   #TQC-610056
                         " '",tm.em2 CLIPPED,"'",   #TQC-610056
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",  
                         " '",tm.f CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.p CLIPPED,"'",
                         " '",tm.q CLIPPED,"'",
                         " '",tm.r CLIPPED,"'",   #TQC-610056
                         " '",tm.g CLIPPED,"'",   #TQC-B30210
                         " '",tm.rtype CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gglr112',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r112()
   ERROR ""
END WHILE
   CLOSE WINDOW r112_w
END FUNCTION
 
FUNCTION r112()
   DEFINE l_name    LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
   DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
   DEFINE l_chr     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   DEFINE l_za05    LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(40)
   DEFINE amt1,amt2,amt3    LIKE aah_file.aah05      #NO FUN-690009   DEC(20,6)
   DEFINE lamt1,lamt2,lamt3 LIKE aah_file.aah05      #NO FUN-690009   DEC(20,6)   # 上月統計金額
   DEFINE l_lendy1  LIKE abb_file.abb07
   DEFINE l_lendy2  LIKE abb_file.abb07
   DEFINE l_tmp     LIKE type_file.num20_6     #NO FUN-690009    DEC(20,6)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr  RECORD
              bal1,bal2   LIKE aah_file.aah05,     #NO FUN-690009   DEC(20,6)
              lbal1,lbal2 LIKE aah_file.aah05      #NO FUN-690009   DEC(20,6)    #No.FUN-570087  --add
              END RECORD
   DEFINE l_endy1   LIKE abb_file.abb07
   DEFINE l_endy2   LIKE abb_file.abb07
   DEFINE l_endy21  LIKE abb_file.abb07
   DEFINE l_endy22  LIKE abb_file.abb07
   DEFINE        g_bal_a     DYNAMIC ARRAY OF RECORD
                      maj02      LIKE maj_file.maj02,
                      maj03      LIKE maj_file.maj03,
                      bal1       LIKE aah_file.aah05,
                      bal2       LIKE aah_file.aah05,
                      lbal1      LIKE aah_file.aah05,
                      lbal2      LIKE aah_file.aah05,
                      maj08      LIKE maj_file.maj08,
                      maj09      LIKE maj_file.maj09
                      END RECORD
   DEFINE g_cnt       LIKE type_file.num5
   DEFINE l_sw1       LIKE type_file.num5
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_maj08     LIKE maj_file.maj08 
   DEFINE l_ad1     LIKE abb_file.abb07             #No.TQC-B30210
   DEFINE l_ad2     LIKE abb_file.abb07             #No.TQC-B30210
   DEFINE l_CE_sum1 LIKE abb_file.abb07             #NO.TQC-B60325
   DEFINE l_CE_sum2 LIKE abb_file.abb07             #NO.TQC-B60325
   
   #No.FUN-B80096--mark--Begin--- 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   CALL cl_del_data(l_table)   #No.FUN-780057
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
                                               AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r112_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE r112_c CURSOR FOR r112_p
 
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
   # No.FUN-570087  --begin  按照公式計算上月相關金額
   FOR g_i = 1 TO 100 LET g_ltot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_ltot2[g_i] = 0 END FOR
   # No.FUN-570087  --end
 
  #CALL cl_outnam('gglr112') RETURNING l_name    #No.FUN-780057 
  #START REPORT r112_rep TO l_name               #No.FUN-780057
   #No.FUN-570087  --begin  新增按公式打印,累計已計算完成科目金額
   CALL g_formula.clear()
   LET g_i = 0
   CALL g_bal_a.clear()
   LET g_cnt = 1
   FOREACH r112_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0 LET amt2 = 0 LET amt3=0
 
      #No.FUN-570087   --begin 按照公式計算上月相關金額
      LET lamt1 = 0 LET lamt2 = 0 LET lamt3 = 0
 
      #新增按公式打印,累計已計算完成科目金額
      #若該科目沒維護公式字段，則正常計算金額
      IF cl_null(maj.maj27) THEN
         #新增僅借方/貸方 選擇金額合計
         IF maj.maj06 NOT MATCHES '[12345]' THEN CONTINUE FOREACH END IF
 
         IF maj.maj06='4' THEN      ## 借方金額
            IF NOT cl_null(maj.maj21) THEN
               IF maj.maj24 IS NULL THEN 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aah04) INTO amt1 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
                  END IF 
                  IF tm.i = 'N' THEN  #No.MOD-860252
                     SELECT SUM(aah04) INTO amt1 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                  END IF #No.MOD-860252
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                     IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                        LET l_ad1 = 0
                        SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                         WHERE abb00 = tm.b
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                           AND aba04 = 0 AND abapost = 'Y'
                        IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                        LET amt1 = amt1 + l_ad1
                      END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET lamt1 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04) INTO lamt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah03 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN #No.MOD-860252
                        SELECT SUM(aah04) INTO lamt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah03 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                        IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                           LET l_ad1 = 0
                           SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                           LET lamt1 = lamt1 + l_ad1
                         END IF
                      END IF
                      #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               ELSE
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aao05) INTO amt1 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aba00=aag00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                       AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01 AND aag09 = 'Y' AND aag07 IN ('2','3')
                  IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                  LET amt1 = amt1 - l_CE_sum2
#TQC-B60325 --end
                  END IF 
                  IF tm.i = 'N' THEN  #No.MOD-860252
                     SELECT SUM(aao05) INTO amt1 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aba00=aag00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                       AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01 AND aag07 IN ('2','3')
                  IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                  LET amt1 = amt1 - l_CE_sum2
#TQC-B60325 --end
                  END IF #No.MOD-860252
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                     IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                        LET l_ad1 = 0
                        SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                         WHERE abb00 = tm.b
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                           AND aba04 = 0 AND abapost = 'Y'
                        IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                        LET amt1 = amt1 + l_ad1
                      END IF
                   END IF
                   #No.TQC-B30210 --End #是否包含審計調整
                  #按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET lamt1 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao05) INTO lamt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1
                           AND aao04 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b  AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01 AND aag09 = 'Y' AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET lamt1 = lamt1 - l_CE_sum2
#TQC-B60325 --end
                     END IF 
                     IF tm.i = 'N' THEN  #No.MOD-860252
                        SELECT SUM(aao05) INTO lamt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1
                           AND aao04 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b  AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01 AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET lamt1 = lamt1 - l_CE_sum2
#TQC-B60325 --end
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad1 = 0
                          SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                          LET lamt1 = lamt1 + l_ad1
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               END IF
               IF STATUS THEN
                  CALL cl_err('sel aah4:',STATUS,1)
                  EXIT FOREACH
               END IF
               IF amt1 IS NULL THEN LET amt1 = 0 END IF
            END IF
         END IF
         IF maj.maj06='5' THEN      ## 貸方金額
            IF NOT cl_null(maj.maj21) THEN
               IF maj.maj24 IS NULL THEN 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aah05) INTO amt1 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
                  END IF 
                  IF tm.i = 'N' THEN   #No.MOD-860252
                     SELECT SUM(aah05) INTO amt1 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                  END IF      #No.MOD-860252
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad2 = 0
                       SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                       LET amt1 = amt1 + l_ad2
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET lamt1 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah05) INTO lamt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah03 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 ='Y'
                     END IF 
                     IF tm.i = 'N' THEN   #No.MOD-860252
                        SELECT SUM(aah05) INTO lamt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah03 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF   #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad2 = 0
                          SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                          LET lamt1 = lamt1 + l_ad2
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               ELSE 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aao06) INTO amt1 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
                        AND aag09 = 'Y' 
#TQC-B60325 --begin
#减回CE凭证
                   SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                    WHERE abb00 = tm.b AND aag00 = aba00
                      AND aba00 = abb00 AND aba01 = abb01
                      AND abb03 BETWEEN maj.maj21 AND maj.maj22
                      AND abb05 BETWEEN maj.maj24 AND maj.maj25
                      AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                      AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                      AND abb03 = aag01 AND aag09 = 'Y' AND aag07 IN ('2','3')
                   IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                   LET amt1 = amt1 - l_CE_sum1
#TQC-B60325 --end
                  END IF 
                  IF tm.i = 'N' THEN   #No.MOD-860252
                     SELECT SUM(aao06) INTO amt1 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                   SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                    WHERE abb00 = tm.b AND aag00 = aba00
                      AND aba00 = abb00 AND aba01 = abb01
                      AND abb03 BETWEEN maj.maj21 AND maj.maj22
                      AND abb05 BETWEEN maj.maj24 AND maj.maj25
                      AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                      AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                      AND abb03 = aag01 AND aag07 IN ('2','3')
                   IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                   LET amt1 = amt1 - l_CE_sum1
#TQC-B60325 --end
                  END IF   #No.MOD-860252
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad2 = 0
                       SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                       LET amt1 = amt1 + l_ad2
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET lamt1 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao06) INTO lamt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1
                           AND aao04 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01 AND aag09 = 'Y' AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                        LET lamt1 = lamt1 - l_CE_sum1
#TQC-B60325 --end
                     END IF 
                     IF tm.i = 'N' THEN  #No.MOD-860252
                        SELECT SUM(aao06) INTO lamt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1
                           AND aao04 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01 AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                        LET lamt1 = lamt1 - l_CE_sum1
#TQC-B60325 --end
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad2 = 0
                          SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                          LET lamt1 = lamt1 + l_ad2
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               END IF
               IF STATUS THEN
                  CALL cl_err('sel aah5:',STATUS,1)
                  EXIT FOREACH
               END IF
               IF amt1 IS NULL THEN LET amt1 = 0 END IF
            END IF
         END IF
 
         IF maj.maj06<'4' THEN     #No.FUN-570087  --add
            IF NOT cl_null(maj.maj21) THEN
               IF maj.maj24 IS NULL THEN 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
                  END IF 
                  IF tm.i = 'N' THEN  #NO.MOD-860252
                     SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy1 AND aah03 BETWEEN tm.bm1 AND tm.em1
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                  END IF #No.MOD-860252
                  
                  IF maj.maj06 ='3' THEN
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 <= tm.em1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN   #NO.MOD-860252
                        SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1 AND aah03 <= tm.em1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF #No.MOD-860252
                  END IF
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad1 = 0 
                       LET l_ad2 = 0                       
                       SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                       IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
                       LET amt1 = amt1 + l_ad1 - l_ad2
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #No.FUN-570087  --add  按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET lamt1 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04-aah05) INTO lamt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah03 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN   #No.MOD-860252
                        SELECT SUM(aah04-aah05) INTO lamt1 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy1
                           AND aah03 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad1 = 0 
                          LET l_ad2 = 0                       
                          SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                          IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
                          LET lamt1 = lamt1 + l_ad1 - l_ad2
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               ELSE 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
#TQC-B60325 --begin
#需加回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                       AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                       AND aag09 = 'Y'
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                       AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                       AND aag09 = 'Y'
                  IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                  IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                  LET amt1 = amt1 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                  END IF 
                  IF tm.i = 'N' THEN  #No.MOD-860252
                     SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy1 AND aao04 BETWEEN tm.bm1 AND tm.em1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#需加回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                       AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                       AND aba04 BETWEEN tm.bm1 AND tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                  IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                  IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                  LET amt1 = amt1 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                  END IF #No.MOD-860252
                  IF maj.maj06 ='3' THEN
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1 AND aao04 <= tm.em1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#需加回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                       AND aba04 <= tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                       AND aag09 = 'Y'
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                       AND aba04 <= tm.em1  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                       AND aag09 = 'Y'
                  LET amt1 = amt1 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                     END IF
                     IF tm.i = 'N' THEN  #No.MOD-860252
                        SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1 AND aao04 <= tm.em1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1
                           AND aba04 <= tm.em1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                           AND aba04 <= tm.em1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        LET amt1 = amt1 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                     END IF #No.MOD-860252
                  END IF
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad1 = 0 
                       LET l_ad2 = 0                       
                       SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                       IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
                       LET amt1 = amt1 + l_ad1 - l_ad2
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #No.FUN-570087  --begin按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET lamt1 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao05-aao06) INTO lamt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1
                           AND aao04 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1 
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1 
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                        IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET lamt1 = lamt1 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end 
                     END IF 
                     IF tm.i = 'N' THEN    #No.MOD-860252
                        SELECT SUM(aao05-aao06) INTO lamt1 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy1
                           AND aao04 BETWEEN tm.bm1-1 AND tm.em1-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy1 
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1 
                           AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET lamt1 = lamt1 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end 
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad1 = 0 
                          LET l_ad2 = 0                       
                          SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                          IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF 
                          LET lamt1 = lamt1 + l_ad1 - l_ad2
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               END IF
               IF STATUS THEN
                  CALL cl_err('sel aah1:',STATUS,1)
                  EXIT FOREACH
               END IF
               IF amt1 IS NULL THEN LET amt1 = 0 END IF
               IF maj.maj24 IS NULL THEN    #No.MOD-910123
                  SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file
                   WHERE abb00 = tm.b
                     AND aba00 = abb00 AND aba01 = abb01
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                     AND aba04 BETWEEN tm.bm1 AND tm.em1
                     AND abapost = 'Y'  #No.TQC-B30210
                  SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file
                   WHERE abb00 = tm.b
                     AND aba00 = abb00 AND aba01 = abb01
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy1
                     AND aba04 BETWEEN tm.bm1 AND tm.em1
                     AND abapost = 'Y'  #No.TQC-B30210
                  #No.FUN-570087  --begin   按照公式計算上月相關金額
                  IF tm.em1 = 1 OR tm.bm1 != tm.em1 THEN
                     LET l_lendy1 = 0 LET l_lendy2 = 0
                  ELSE
                     SELECT SUM(abb07) INTO l_lendy1 FROM abb_file,aba_file
                      WHERE abb00 = tm.b
                        AND aba00 = abb00 AND aba01 = abb01
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy1
                        AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1
                        AND abapost = 'Y'  #No.TQC-B30210
                     SELECT SUM(abb07) INTO l_lendy2 FROM abb_file,aba_file
                      WHERE abb00 = tm.b
                        AND aba00 = abb00 AND aba01 = abb01
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy1
                        AND aba04 BETWEEN tm.bm1-1 AND tm.em1-1
                        AND abapost = 'Y'  #No.TQC-B30210
                  END IF
               END IF    #No.MOD-910123
               IF l_lendy1 IS NULL THEN LET l_lendy1 = 0 END IF
               IF l_lendy2 IS NULL THEN LET l_lendy2 = 0 END IF
               LET lamt1 = lamt1 + l_lendy2 - l_lendy1
               IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
               IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
               LET amt1 = amt1 + l_endy2 - l_endy1
            END IF
         END IF   #No.FUN-570087  --add
 
         IF tm.yy2 IS NOT NULL THEN
            IF maj.maj06 = '4' THEN
               IF NOT cl_null(maj.maj21) THEN
                  IF maj.maj24 IS NULL THEN 
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04) INTO amt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN   #No.MOD-860252
                        SELECT SUM(aah04) INTO amt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                         AND aah00 = aag00  #No.FUN-740032
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF #No.MOD-860252
                     #按照公式計算上月相關金額5B0299
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                        IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                           LET l_ad1 = 0
                           SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                           LET amt2 = amt2 + l_ad1
                         END IF
                      END IF
                      #No.TQC-B30210 --End #是否包含審計調整
                     IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                        LET lamt2 = 0
                     ELSE
                        IF tm.i = 'Y' THEN 
                           SELECT SUM(aah04) INTO lamt2 FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah00 = aag00  #No.FUN-740032
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy2
                              AND aah03 BETWEEN tm.bm2-1 AND tm.em2-1
                              AND aah01 = aag01 AND aag07 IN ('2','3')
                              AND aag09 = 'Y'
                        END IF 
                        IF tm.i = 'N' THEN #NO.MOD-860252
                           SELECT SUM(aah04) INTO lamt2 FROM aah_file,aag_file
                            WHERE aah00 = tm.b
                              AND aah00 = aag00  #No.FUN-740032
                              AND aah01 BETWEEN maj.maj21 AND maj.maj22
                              AND aah02 = tm.yy2
                              AND aah03 BETWEEN tm.bm2-1 AND tm.em2-1
                              AND aah01 = aag01 AND aag07 IN ('2','3')
                        END IF #No.MOD-860252
                        #No.TQC-B30210 --Begin #是否包含審計調整
                        IF tm.g = 'Y' THEN
                           IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                              LET l_ad1 = 0
                              SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                               WHERE abb00 = tm.b
                                 AND aba00 = abb00 AND aba01 = abb01
                                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                                 AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                                 AND aba04 = 0 AND abapost = 'Y'
                              IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                              LET lamt2 = lamt2 + l_ad1
                            END IF
                         END IF
                         #No.TQC-B30210 --End #是否包含審計調整
                     END IF
                  ELSE 
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao05) INTO amt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                           AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET amt2 = amt2 - l_CE_sum2
#TQC-B60325 --end
                     END IF 
                     IF tm.i = 'N' THEN #No.MOD-860252
                        SELECT SUM(aao05) INTO amt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                         AND aao00 = aag00  #No.FUN-740032
                         AND aao01 BETWEEN maj.maj21 AND maj.maj22
                         AND aao02 BETWEEN maj.maj24 AND maj.maj25
                         AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                         AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                           AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET amt2 = amt2 - l_CE_sum2
#TQC-B60325 --end
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                        IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                           LET l_ad1 = 0
                           SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                           LET amt2 = amt2 + l_ad1
                         END IF
                      END IF
                      #No.TQC-B30210 --End #是否包含審計調整
                     #按照公式計算上月相關金額    5B0299
                     IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                        LET lamt2 = 0
                     ELSE
                        IF tm.i = 'Y' THEN 
                           SELECT SUM(aao05) INTO lamt2 FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao00 = aag00  #No.FUN-740032
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy2
                              AND aao04 BETWEEN tm.bm2-1 AND tm.em2-1
                              AND aao01 = aag01  AND aag07 IN ('2','3')
                              AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                           AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET lamt2 = lamt2 - l_CE_sum2
#TQC-B60325 --end
                        END IF 
                        IF tm.i = 'N' THEN #No.MOD-860252
                           SELECT SUM(aao05) INTO lamt2 FROM aao_file,aag_file
                            WHERE aao00 = tm.b
                              AND aao00 = aag00  #No.FUN-740032
                              AND aao01 BETWEEN maj.maj21 AND maj.maj22
                              AND aao02 BETWEEN maj.maj24 AND maj.maj25
                              AND aao03 = tm.yy2
                              AND aao04 BETWEEN tm.bm2-1 AND tm.em2-1
                              AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                           AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET lamt2 = lamt2 - l_CE_sum2
#TQC-B60325 --end
                        END IF #No.MOD-860252
                        #No.TQC-B30210 --Begin #是否包含審計調整
                        IF tm.g = 'Y' THEN
                          IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                             LET l_ad1 = 0
                             SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                              WHERE abb00 = tm.b
                                AND aba00 = abb00 AND aba01 = abb01
                                AND abb03 BETWEEN maj.maj21 AND maj.maj22
                                AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                                AND aba04 = 0 AND abapost = 'Y'
                             IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                             LET lamt2 = lamt2 + l_ad1
                           END IF
                        END IF
                        #No.TQC-B30210 --End #是否包含審計調整
                     END IF
                  END IF
                  IF cl_null(amt2) THEN LET amt2 = 0 END IF
               END IF
            END IF
 
            IF maj.maj06 = '5' THEN
               IF NOT cl_null(maj.maj21) THEN
                  IF maj.maj24 IS NULL THEN 
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah05) INTO amt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                         AND aah00 = aag00  #No.FUN-740032
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                         AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN  #No.MOD-860252
                        SELECT SUM(aah05) INTO amt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                         AND aah00 = aag00  #No.FUN-740032
                         AND aah01 BETWEEN maj.maj21 AND maj.maj22
                         AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                         AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF   #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad1 = 0
                          SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                          LET amt2 = amt2 + l_ad1
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                     #按照公式計算上月相關金額 -5B0299
                     IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                        LET lamt2 = 0
                     ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah05) INTO lamt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2
                           AND aah03 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN  #No.MOD-860252
                        SELECT SUM(aah05) INTO lamt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2
                           AND aah03 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF   #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad1 = 0
                          SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                          LET lamt2 = lamt2 + l_ad1
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               ELSE 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aao06) INTO amt2 FROM aao_file,aag_file
                        WHERE aao00 = tm.b
                          AND aao00 = aag00  #No.FUN-740032
                          AND aao01 BETWEEN maj.maj21 AND maj.maj22
                          AND aao02 BETWEEN maj.maj24 AND maj.maj25
                          AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                          AND aao01 = aag01  AND aag07 IN ('2','3')
                          AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                   SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                    WHERE abb00 = tm.b AND aag00 = aba00
                      AND aba00 = abb00 AND aba01 = abb01
                      AND abb03 BETWEEN maj.maj21 AND maj.maj22
                      AND abb05 BETWEEN maj.maj24 AND maj.maj25
                      AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                      AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                      AND abb03 = aag01  AND aag07 IN ('2','3')
                      AND aag09 = 'Y'
                   IF cl_null(amt2) THEN LET amt2=0 END IF
                   IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                   LET amt2 = amt2 - l_CE_sum1
#TQC-B60325 --end 
                  END IF 
                  IF tm.i = 'N' THEN #No.MOD-860252
                     SELECT SUM(aao06) INTO amt2 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                        AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                   SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                    WHERE abb00 = tm.b AND aag00 = aba00
                      AND aba00 = abb00 AND aba01 = abb01
                      AND abb03 BETWEEN maj.maj21 AND maj.maj22
                      AND abb05 BETWEEN maj.maj24 AND maj.maj25
                      AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                      AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                      AND aao01 = aag01  AND aag07 IN ('2','3')
                   IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                   LET amt2 = amt2 - l_CE_sum1
#TQC-B60325 --end 
                  END IF #No.MOD-860252
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad1 = 0
                       SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                       LET amt2 = amt2 + l_ad1
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #按照公式計算上月相關金額  -5B0299
                  IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                     LET lamt2 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao06) INTO lamt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy2
                           AND aao04 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#减回CE凭证
                   SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                    WHERE abb00 = tm.b AND aag00 = aba00
                      AND aba00 = abb00 AND aba01 = abb01
                      AND abb03 BETWEEN maj.maj21 AND maj.maj22
                      AND abb05 BETWEEN maj.maj24 AND maj.maj25
                      AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                      AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                      AND abb03 = aag01  AND aag07 IN ('2','3')
                      AND aag09 = 'Y'
                   IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                   LET lamt2 = lamt2 - l_CE_sum1
#TQC-B60325 --end
                     END IF 
                     IF tm.i = 'N' THEN   #No.MOD-860252
                     SELECT SUM(aao06) INTO lamt2 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy2
                        AND aao04 BETWEEN tm.bm2-1 AND tm.em2-1
                        AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#减回CE凭证
                   SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                    WHERE abb00 = tm.b AND aag00 = aba00
                      AND aba00 = abb00 AND aba01 = abb01
                      AND abb03 BETWEEN maj.maj21 AND maj.maj22
                      AND abb05 BETWEEN maj.maj24 AND maj.maj25
                      AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                      AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                      AND abb03 = aag01  AND aag07 IN ('2','3')
                   IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                   LET lamt2 = lamt2 - l_CE_sum1
#TQC-B60325 --end
                     END IF #NO.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                       IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                          LET l_ad1 = 0
                          SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                           WHERE abb00 = tm.b
                             AND aba00 = abb00 AND aba01 = abb01
                             AND abb03 BETWEEN maj.maj21 AND maj.maj22
                             AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                             AND aba04 = 0 AND abapost = 'Y'
                          IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF
                          LET lamt2 = lamt2 + l_ad1
                        END IF
                     END IF
                     #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               END IF
               IF cl_null(amt2) THEN LET amt2 = 0 END IF
            END IF
         END IF
 
         IF maj.maj06<'4' THEN
            IF NOT cl_null(maj.maj21) THEN
               IF maj.maj24 IS NULL THEN 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aah04-aah05) INTO amt2 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
                  END IF 
                  IF tm.i = 'N' THEN   #No.MOD-860252
                     SELECT SUM(aah04-aah05) INTO amt2 FROM aah_file,aag_file
                      WHERE aah00 = tm.b
                        AND aah00 = aag00  #No.FUN-740032
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22
                        AND aah02 = tm.yy2 AND aah03 BETWEEN tm.bm2 AND tm.em2
                        AND aah01 = aag01 AND aag07 IN ('2','3')
                  END IF #No.MOD-860252
                  IF maj.maj06 ='3' THEN
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04-aah05) INTO amt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2 AND aah03 <= tm.em2
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN #No.MOD-860252
                        SELECT SUM(aah04-aah05) INTO amt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2 AND aah03 <=tm.em2
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF #No.MOD-860252
                  END IF
                 #No.TQC-B30210 --Begin #是否包含審計調整
                 IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad1 = 0 
                       LET l_ad2 = 0                       
                       SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                       IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                       LET amt2 = amt2 + l_ad1 - l_ad2
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #按照公式計算上月相關金額
                  IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                     LET lamt2 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aah04-aah05) INTO lamt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2
                           AND aah03 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                     END IF 
                     IF tm.i = 'N' THEN #No.MOD-860252
                        SELECT SUM(aah04-aah05) INTO lamt2 FROM aah_file,aag_file
                         WHERE aah00 = tm.b
                           AND aah00 = aag00  #No.FUN-740032
                           AND aah01 BETWEEN maj.maj21 AND maj.maj22
                           AND aah02 = tm.yy2
                           AND aah03 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aah01 = aag01 AND aag07 IN ('2','3')
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                        IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                           LET l_ad1 = 0 
                           LET l_ad2 = 0                       
                           SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                           IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                           LET lamt2 = lamt2 + l_ad1 - l_ad2
                         END IF
                      END IF
                      #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               ELSE 
                  IF tm.i = 'Y' THEN 
                     SELECT SUM(aao05-aao06) INTO amt2 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                        AND aao01 = aag01  AND aag07 IN ('2','3')
                        AND aag09 = 'Y'
#TQC-B60325 --begin
#需加回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                       AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                       AND aag09 = 'Y'
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                       AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                       AND aag09 = 'Y'
                  IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                  IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                  LET amt2 = amt2 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                  END IF 
                  IF tm.i = 'N' THEN #No.MOD-860252
                     SELECT SUM(aao05-aao06) INTO amt2 FROM aao_file,aag_file
                      WHERE aao00 = tm.b
                        AND aao00 = aag00  #No.FUN-740032
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25
                        AND aao03 = tm.yy2 AND aao04 BETWEEN tm.bm2 AND tm.em2
                        AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#需加回CE凭证
                    SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                       AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                    SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                     WHERE abb00 = tm.b AND aag00 = aba00
                       AND aba00 = abb00 AND aba01 = abb01
                       AND abb03 BETWEEN maj.maj21 AND maj.maj22
                       AND abb05 BETWEEN maj.maj24 AND maj.maj25
                       AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                       AND aba04 BETWEEN tm.bm2 AND tm.em2  AND abapost = 'Y'
                       AND abb03 = aag01  AND aag07 IN ('2','3')
                  IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                  IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                  LET amt2 = amt2 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                  END IF #No.MOD-860252
                  IF maj.maj06 ='3' THEN
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao05-aao06) INTO amt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy2 AND aao04 <= tm.em2
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                           AND aba04 <= tm.em2  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                           AND aba04 <= tm.em2  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y'
                        IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET amt2 = amt2 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                     END IF 
                     IF tm.i = 'N' THEN #No.MOD-860252
                        SELECT SUM(aao05-aao06) INTO amt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy2 AND aao04 <= tm.em2
                           AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2
                           AND aba04 <= tm.em2  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                           AND aba04 <= tm.em2  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                        IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                        LET amt2 = amt2 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end
                     END IF #No.MOD-860252
                  END IF
                  #No.TQC-B30210 --Begin #是否包含審計調整
                  IF tm.g = 'Y' THEN
                    IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                       LET l_ad1 = 0 
                       LET l_ad2 = 0                       
                       SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                        WHERE abb00 = tm.b
                          AND aba00 = abb00 AND aba01 = abb01
                          AND abb03 BETWEEN maj.maj21 AND maj.maj22
                          AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                          AND aba04 = 0 AND abapost = 'Y'
                       IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                       IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                       LET amt2 = amt2 + l_ad1 - l_ad2
                     END IF
                  END IF
                  #No.TQC-B30210 --End #是否包含審計調整
                  #begin按照公式計算上月相關金額
                  IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                     LET lamt2 = 0
                  ELSE
                     IF tm.i = 'Y' THEN 
                        SELECT SUM(aao05-aao06) INTO lamt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy2
                           AND aao04 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y' 
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2 
                           AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y' 
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2 
                           AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                           AND aag09 = 'Y' 
                      IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                      IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                      LET lamt2 = lamt2 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end 
                     END IF 
                     IF tm.i = 'N' THEN  #No.MOD-860252
                        SELECT SUM(aao05-aao06) INTO lamt2 FROM aao_file,aag_file
                         WHERE aao00 = tm.b
                           AND aao00 = aag00  #No.FUN-740032
                           AND aao01 BETWEEN maj.maj21 AND maj.maj22
                           AND aao02 BETWEEN maj.maj24 AND maj.maj25
                           AND aao03 = tm.yy2
                           AND aao04 BETWEEN tm.bm2-1 AND tm.em2-1
                           AND aao01 = aag01  AND aag07 IN ('2','3')
#TQC-B60325 --begin
#需加回CE凭证
                        SELECT SUM(abb07) INTO l_CE_sum1 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '2' AND aba03 = tm.yy2 
                           AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                        SELECT SUM(abb07) INTO l_CE_sum2 FROM abb_file,aba_file,aag_file
                         WHERE abb00 = tm.b AND aag00 = aba00
                           AND aba00 = abb00 AND aba01 = abb01
                           AND abb03 BETWEEN maj.maj21 AND maj.maj22
                           AND abb05 BETWEEN maj.maj24 AND maj.maj25
                           AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2 
                           AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1  AND abapost = 'Y'
                           AND abb03 = aag01  AND aag07 IN ('2','3')
                      IF cl_null(l_CE_sum1) THEN LET l_CE_sum1 = 0 END IF
                      IF cl_null(l_CE_sum2) THEN LET l_CE_sum2 = 0 END IF
                      LET lamt2 = lamt2 + l_CE_sum1 - l_CE_sum2
#TQC-B60325 --end 
                     END IF #No.MOD-860252
                     #No.TQC-B30210 --Begin #是否包含審計調整
                     IF tm.g = 'Y' THEN
                        IF tm.bm1 = 1 AND tm.bm2 = 1 AND tm.em1 = 12 AND tm.em2 = 12 THEN
                           LET l_ad1 = 0 
                           LET l_ad2 = 0 
                           SELECT SUM(abb07) INTO l_ad1 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '1' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           SELECT SUM(abb07) INTO l_ad2 FROM abb_file,aba_file
                            WHERE abb00 = tm.b
                              AND aba00 = abb00 AND aba01 = abb01
                              AND abb03 BETWEEN maj.maj21 AND maj.maj22
                              AND aba06 = 'AD'  AND abb06 = '2' AND aba03 = tm.yy1+1
                              AND aba04 = 0 AND abapost = 'Y'
                           IF cl_null(l_ad1) THEN LET l_ad1 = 0 END IF 
                           IF cl_null(l_ad2) THEN LET l_ad2 = 0 END IF
                           LET lamt2 = lamt2 + l_ad1 - l_ad2
                         END IF
                    END IF
                    #No.TQC-B30210 --End #是否包含審計調整
                  END IF
               END IF
               IF STATUS THEN
                  CALL cl_err('sel aah2:',STATUS,1)
                  EXIT FOREACH
               END IF
               IF amt2 IS NULL THEN LET amt2 = 0 END IF
               IF maj.maj24 IS NULL THEN    #No.MOD-910123
                  SELECT SUM(abb07) INTO l_endy21 FROM abb_file,aba_file
                   WHERE abb00 = tm.b
                     AND aba00 = abb00 AND aba01 = abb01
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy2
                     AND aba04 BETWEEN tm.bm2 AND tm.em2
                     AND abapost = 'Y'  #No.TQC-B30210
                  SELECT SUM(abb07) INTO l_endy22 FROM abb_file,aba_file
                   WHERE abb00 = tm.b
                     AND aba00 = abb00 AND aba01 = abb01
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22
                     AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy2
                     AND aba04 BETWEEN tm.bm2 AND tm.em2
                     AND abapost = 'Y'  #No.TQC-B30210
                   #--begin   按照公式計算上月相關金額
                  IF tm.em2 = 1 OR tm.bm2 != tm.em2 THEN
                     LET l_lendy1 = 0 LET l_lendy2 = 0
                  ELSE
                     SELECT SUM(abb07) INTO l_lendy1 FROM abb_file,aba_file
                      WHERE abb00 = tm.b
                        AND aba00 = abb00 AND aba01 = abb01
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND aba06 = 'CE'  AND abb06 = '1' AND aba03 = tm.yy2
                        AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1
                        AND abapost = 'Y'  #No.TQC-B30210
                     SELECT SUM(abb07) INTO l_lendy2 FROM abb_file,aba_file
                      WHERE abb00 = tm.b
                        AND aba00 = abb00 AND aba01 = abb01
                        AND abb03 BETWEEN maj.maj21 AND maj.maj22
                        AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy2
                        AND aba04 BETWEEN tm.bm2-1 AND tm.em2-1
                        AND abapost = 'Y'  #No.TQC-B30210
                  END IF
               END IF     #No.MOD-910123
               IF l_lendy1 IS NULL THEN LET l_lendy1 = 0 END IF
               IF l_lendy2 IS NULL THEN LET l_lendy2 = 0 END IF
               LET lamt2 = lamt2 + l_lendy2 - l_lendy1
               IF l_endy21 IS NULL THEN LET l_endy21 = 0 END IF
               IF l_endy22 IS NULL THEN LET l_endy22 = 0 END IF
               LET amt2 = amt2 + l_endy22 - l_endy21
            END IF
         END IF
      END IF
      IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF #匯率的轉換
      IF tm.o = 'Y' THEN LET amt2 = amt2 * tm.q END IF #匯率的轉換
#TQC-B60325 --begin
       IF NOT cl_null(maj.maj21) THEN
          IF maj.maj06 MATCHES '[123]' AND maj.maj07 = '2' THEN
             LET amt1 = amt1 * -1
             LET amt2 = amt2 * -1
             LET lamt1 = lamt1 * -1
             LET lamt2 = lamt2 * -1
          END IF
          IF maj.maj06 = '4' AND maj.maj07 = '2' THEN
             LET amt1 = amt1 * -1
             LET amt2 = amt2 * -1
             LET lamt1 = lamt1 * -1
             LET lamt2 = lamt2 * -1
          END IF
          IF maj.maj06 = '5' AND maj.maj07 = '1' THEN
             LET amt1 = amt1 * -1
             LET amt2 = amt2 * -1
             LET lamt1 = lamt1 * -1
             LET lamt2 = lamt2 * -1
          END IF
       END IF
#TQC-B60325 --end 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN #合計階數處理
         IF maj.maj08 = '1' THEN
            LET g_bal_a[g_cnt].maj02 = maj.maj02
            LET g_bal_a[g_cnt].maj03 = maj.maj03
            LET g_bal_a[g_cnt].bal1   = amt1
            LET g_bal_a[g_cnt].bal2   = amt2
            LET g_bal_a[g_cnt].lbal1  = lamt1
            LET g_bal_a[g_cnt].lbal2  = lamt2
            LET g_bal_a[g_cnt].maj08 = maj.maj08
            LET g_bal_a[g_cnt].maj09 = maj.maj09
         ELSE
            LET g_bal_a[g_cnt].maj02 = maj.maj02
            LET g_bal_a[g_cnt].maj03 = maj.maj03
            LET g_bal_a[g_cnt].maj08 = maj.maj08
            LET g_bal_a[g_cnt].maj09 = maj.maj09
            LET g_bal_a[g_cnt].bal1   = amt1
            LET g_bal_a[g_cnt].bal2   = amt2
            LET g_bal_a[g_cnt].lbal1  = lamt1
            LET g_bal_a[g_cnt].lbal2  = lamt2
         END IF   #MOD-950164 add
            FOR l_i = 1 TO 100
               IF g_bal_a[g_cnt].maj09 = '+' THEN
                  LET g_tot1[l_i] = g_tot1[l_i] +g_bal_a[g_cnt].bal1
                  LET g_tot2[l_i] = g_tot2[l_i] +g_bal_a[g_cnt].bal2
                  LET g_ltot1[l_i]= g_ltot1[l_i]+g_bal_a[g_cnt].lbal1
                  LET g_ltot2[l_i]= g_ltot2[l_i]+g_bal_a[g_cnt].lbal2
               ELSE
                  LET g_tot1[l_i] = g_tot1[l_i] -g_bal_a[g_cnt].bal1
                  LET g_tot2[l_i] = g_tot2[l_i] -g_bal_a[g_cnt].bal2
                  LET g_ltot1[l_i]= g_ltot1[l_i]-g_bal_a[g_cnt].lbal1
                  LET g_ltot2[l_i]= g_ltot2[l_i]-g_bal_a[g_cnt].lbal2
               END IF
            END FOR
            LET k=maj.maj08
            LET sr.bal1 = g_tot1[k]
            LET sr.bal2 = g_tot2[k]
            LET sr.lbal1= g_ltot1[k]
            LET sr.lbal2= g_ltot2[k]
           #-MOD-AC0111-add-
            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
               LET sr.bal1 = sr.bal1 *-1
               LET sr.bal2 = sr.bal2 *-1
               LET sr.lbal1 = sr.lbal1 *-1
               LET sr.lbal2 = sr.lbal2 *-1
            END IF
           #-MOD-AC0111-end-
            FOR l_i = 1 TO maj.maj08 LET g_tot1[l_i] =0 END FOR
            FOR l_i = 1 TO maj.maj08 LET g_tot2[l_i] =0 END FOR
            FOR l_i = 1 TO maj.maj08 LET g_ltot1[l_i]=0 END FOR
            FOR l_i = 1 TO maj.maj08 LET g_ltot2[l_i]=0 END FOR
      ELSE
         IF maj.maj03='5' THEN
             LET g_bal_a[g_cnt].maj02 = maj.maj02
             LET g_bal_a[g_cnt].maj03 = maj.maj03
             LET g_bal_a[g_cnt].bal1  = amt1
             LET g_bal_a[g_cnt].bal2  = amt2
             LET g_bal_a[g_cnt].lbal1  = lamt1
             LET g_bal_a[g_cnt].lbal2  = lamt2
             LET g_bal_a[g_cnt].maj08 = maj.maj08
             LET g_bal_a[g_cnt].maj09 = maj.maj09
         ELSE
             LET g_bal_a[g_cnt].maj02 = maj.maj02
             LET g_bal_a[g_cnt].maj03 = maj.maj03
             LET g_bal_a[g_cnt].bal1  = 0
             LET g_bal_a[g_cnt].bal2  = 0
             LET g_bal_a[g_cnt].lbal1  = 0
             LET g_bal_a[g_cnt].lbal2  = 0
             LET g_bal_a[g_cnt].maj08 = maj.maj08
             LET g_bal_a[g_cnt].maj09 = maj.maj09
         END IF
         LET sr.bal1 = g_bal_a[g_cnt].bal1
         LET sr.bal2 = g_bal_a[g_cnt].bal2
         LET sr.lbal1 = g_bal_a[g_cnt].lbal1
         LET sr.lbal2 = g_bal_a[g_cnt].lbal2
      END IF   #MOD-950164 add
      LET g_cnt = g_cnt + 1
 
      IF maj.maj11 = 'Y' THEN			# 百分比基準科目
         LET g_basetot1=sr.bal1
         LET g_basetot2=sr.bal2
         #No.FUN-570087  --begin 按照公式計算上月相關金額
         LET g_lbasetot1=sr.lbal1
         LET g_lbasetot2=sr.lbal2
         IF maj.maj07='2' THEN LET g_lbasetot1=g_lbasetot1*-1 END IF
         IF maj.maj07='2' THEN LET g_lbasetot2=g_lbasetot2*-1 END IF
         IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
         IF maj.maj07='2' THEN LET g_basetot2=g_basetot2*-1 END IF
      END IF
         IF maj.maj03 = 'H' THEN
            LET sr.bal1  = NULL
            LET sr.bal2  = NULL
            LET sr.lbal1 = NULL
            LET sr.lbal2 = NULL
         END IF
         IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
         IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"
            AND sr.bal1=0 AND sr.bal2=0 THEN
            CONTINUE FOREACH				#餘額為 0 者不列印
         END IF
         IF tm.f>0 AND maj.maj08 < tm.f THEN
            CONTINUE FOREACH				#最小階數起列印
         END IF
        #No.FUN-570087  --begin  按公式計算金額
         #新增按公式打印,累計已計算完成科目金額
         LET g_i = g_i + 1
         LET g_formula[g_i].maj02     = cl_numfor(maj.maj02,9,2)
         LET g_formula[g_i].maj27     = maj.maj27
         LET g_formula[g_i].bal1      = cl_numfor(sr.bal1,20,6)
         LET g_formula[g_i].bal2      = cl_numfor(sr.bal2,20,6)
         LET g_formula[g_i].lbal1     = cl_numfor(sr.lbal1,20,6)
         LET g_formula[g_i].lbal2     = cl_numfor(sr.lbal2,20,6)
         CALL g_formula.appendElement()
         IF maj.maj07='2' THEN LET sr.bal1=sr.bal1*-1 END IF   #MOD-870141 mark
         IF maj.maj07='2' THEN LET sr.bal2=sr.bal2*-1 END IF   #MOD-870141 mark
         IF maj.maj07='2' THEN LET sr.lbal1=sr.lbal1*-1 END IF                                                                           
         IF maj.maj07='2' THEN LET sr.lbal2=sr.lbal2*-1 END IF                                                                           
         IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF 
         LET maj.maj20= maj.maj05 SPACES,maj.maj20
         LET sr.bal1=sr.bal1/g_unit
         LET sr.bal2=sr.bal2/g_unit
         IF maj.maj03 = 'H' THEN
            LET sr.bal1  = NULL
            LET sr.bal2  = NULL
            LET sr.lbal1 = NULL
            LET sr.lbal2 = NULL
         END IF
         IF maj.maj04=0 THEN
            EXECUTE insert_prep USING
              maj.maj20,maj.maj02,maj.maj03,maj.maj26,sr.bal1,sr.bal2,
              sr.lbal1,sr.lbal2,
              '2',maj.maj06    #No.TQC-810068
         ELSE
            EXECUTE insert_prep USING
              maj.maj20,maj.maj02,maj.maj03,maj.maj26,sr.bal1,sr.bal2,
              sr.lbal1,sr.lbal2,
              '2',maj.maj06    #No.TQC-810068
            #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
            #讓空行的這筆資料排在正常的資料前面印出            
            FOR i=1 TO maj.maj04
                EXECUTE insert_prep USING
                   maj.maj20,maj.maj02,'','0','0','0','0',
                   '1',maj.maj06    #No.TQC-810068
            END FOR
         END IF 
      ELSE
         LET g_i = g_i + 1
         LET g_formula[g_i].maj02 = cl_numfor(maj.maj02,9,2)
         LET g_formula[g_i].maj27 = maj.maj21
         LET g_for_str = maj.maj27 CLIPPED
         IF NOT cl_null(g_for_str) THEN
            CALL formula_gen(g_for_str,"1")
            LET g_sql = "SELECT ",g_for_str," FROM sma_file "
            PREPARE bal1 FROM g_sql
            EXECUTE bal1 INTO g_formula[g_i].bal1
         ELSE
            LET g_formula[g_i].bal1 = cl_numfor(sr.bal1,20,6)
         END IF
 
         LET g_for_str = maj.maj28 CLIPPED
         IF NOT cl_null(g_for_str) THEN
            CALL formula_gen(g_for_str,"2")
            LET g_sql = "SELECT ",g_for_str," FROM sma_file "
            PREPARE bal2 FROM g_sql
            EXECUTE bal2 INTO g_formula[g_i].bal2
         ELSE
            LET g_formula[g_i].bal2 = cl_numfor(sr.bal2,20,6)
         END IF
         CALL g_formula.appendElement()
         LET sr.bal1  = cl_numfor(g_formula[g_i].bal1,20,6)
         LET sr.bal2  = cl_numfor(g_formula[g_i].bal2,20,6)
         LET sr.lbal1 = cl_numfor(g_formula[g_i].lbal1,20,6)
         LET sr.lbal2 = cl_numfor(g_formula[g_i].lbal2,20,6)
         IF cl_null(sr.bal1)  THEN LET sr.bal1 = 0.999999 END IF
         IF cl_null(sr.bal2)  THEN LET sr.bal2 = 0.999999 END IF
         IF cl_null(sr.lbal1) THEN LET sr.lbal1 = 0.999999 END IF
         IF cl_null(sr.lbal2) THEN LET sr.lbal2 = 0.999999 END IF
         IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF                                                                            
         LET maj.maj20= maj.maj05 SPACES,maj.maj20                                                                                   
         LET sr.bal1=sr.bal1/g_unit                                                                                                  
         LET sr.bal2=sr.bal2/g_unit                                                                                                  
         IF maj.maj04=0 THEN                                                                                                         
            EXECUTE insert_prep USING                                                                                                
              maj.maj20,maj.maj02,maj.maj03,maj.maj26,sr.bal1,sr.bal2,
              sr.lbal1,sr.lbal2,                                             
              '2',maj.maj06    #No.TQC-810068                                                                                                                    
         ELSE                                                                                                                        
            EXECUTE insert_prep USING                                                                                                
              maj.maj20,maj.maj02,maj.maj03,maj.maj26,sr.bal1,sr.bal2,
              sr.lbal1,sr.lbal2,                                             
              '2',maj.maj06    #No.TQC-810068                                                                                                                    
            #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                            
            #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                                  
            #讓空行的這筆資料排在正常的資料前面印出                                                                                    
            FOR i=1 TO maj.maj04                                                                                                       
                EXECUTE insert_prep USING                                                                                              
                   maj.maj20,maj.maj02,'','0','0','0','0', 
                   '1',maj.maj06    #No.TQC-810068                                                                                                                 
            END FOR                                                                                                                    
         END IF                     
      END IF
   END FOREACH
   IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
   IF g_basetot2 = 0 THEN LET g_basetot2 = NULL END IF
   IF g_lbasetot1= 0 THEN LET g_lbasetot1= NULL END IF
   IF g_lbasetot2= 0 THEN LET g_lbasetot2= NULL END IF
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str=g_mai02,';',tm.b,';',tm.a,';',tm.title1,';',tm.yy1,';',tm.bm1,';',
             tm.em1,';',tm.title2,';',tm.yy2,';',tm.bm2,';',tm.em2,';',tm.c,';',
             tm.d,';',tm.e,';',tm.f,';',tm.h,';',tm.o,';',tm.r,';',tm.p,';',tm.q
   CALL cl_prt_cs3('gglr112','gglr112',g_sql,g_str) 
   #No.FUN-B80096--mark--Begin--- 
   #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
 
FUNCTION formula_gen(p_str,p_chr)
DEFINE p_str  STRING,
       l_tmp  STRING,
       p_chr  LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1) #TQC-5A0134 VARCHAR-->CHAR
 
   IF cl_null(p_str) OR p_chr NOT MATCHES '[12]' THEN
      ERROR "ERROR STRING"
      RETURN
   END IF
 
   # 先計算如出現TMONTH,則需替換為 tm.em2
   # 僅在年合計金額邊判斷，不判斷月合計
   FOR g_for_cnt = 1 TO g_i
       LET g_ser_str = 'TMONTH'
       FOR g_str_len = 1 TO g_for_str.getLength()
           LET g_str_cnt =g_for_str.getIndexOf(g_ser_str,g_str_len)
           IF g_str_cnt > 0 THEN
              LET g_beg_pos = g_str_cnt - 1
              LET g_end_pos = g_beg_pos + g_ser_str.getLength() + 1
              IF p_chr = '1' THEN
                 EXIT FOR
              ELSE
                 LET g_for_str = g_for_str.subString(1,g_beg_pos),tm.em2,
                                 g_for_str.subString(g_end_pos,g_for_str.getLength())
              END IF
              LET g_str_len = g_end_pos
           ELSE
              EXIT FOR
           END IF
       END FOR
   END FOR
 
   # 先計算如出現上月公式，則需替換為上月金額 sr.lbal
   # 僅在月合計金額邊判斷，不判斷年合計
   FOR g_for_cnt = 1 TO g_i
       LET l_tmp = g_formula[g_for_cnt].maj02
       LET l_tmp = l_tmp.trimLeft()
       LET g_ser_str = 'L',l_tmp
       FOR g_str_len = 1 TO g_for_str.getLength()
           LET g_str_cnt =g_for_str.getIndexOf(g_ser_str,g_str_len)
           IF g_str_cnt > 0 THEN
              LET g_beg_pos = g_str_cnt - 1
              LET g_end_pos = g_beg_pos + g_ser_str.getLength() + 1
              IF p_chr = '1' THEN
                 LET g_for_str = g_for_str.subString(1,g_beg_pos),
                                 g_formula[g_for_cnt].lbal1 CLIPPED,
                                 g_for_str.subString(g_end_pos,g_for_str.getLength())
              ELSE
                 EXIT FOR
              END IF
              LET g_str_len = g_end_pos
           ELSE
              EXIT FOR
           END IF
       END FOR
   END FOR
 
   # 替換公式中出現的序號金額 sr.bal1
   FOR g_for_cnt = 1 TO g_i
       LET g_ser_str = g_formula[g_for_cnt].maj02 CLIPPED
       FOR g_str_len = 1 TO g_for_str.getLength()
           LET g_str_cnt =g_for_str.getIndexOf(g_ser_str,g_str_len)
           IF g_str_cnt > 0 THEN
              LET g_beg_pos = g_str_cnt - 1
              LET g_end_pos = g_beg_pos + g_ser_str.getLength() + 1
              IF p_chr = '1' THEN
                 LET g_for_str = g_for_str.subString(1,g_beg_pos),
                                 g_formula[g_for_cnt].bal1 CLIPPED,
                                 g_for_str.subString(g_end_pos,g_for_str.getLength())
              ELSE
                 LET g_for_str = g_for_str.subString(1,g_beg_pos),
                                 g_formula[g_for_cnt].bal2 CLIPPED,
                                 g_for_str.subString(g_end_pos,g_for_str.getLength())
              END IF
              LET g_str_len = g_end_pos
           ELSE
              EXIT FOR
           END IF
       END FOR
   END FOR
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
