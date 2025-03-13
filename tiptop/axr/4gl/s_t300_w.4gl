# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 應收帳款-直接收款
# Date & Author..: 2005/07/25 By Elva
# Modify.........: No.TQC-5A0089 05/10/27 By Smapmin 單別寫死
# Modify.........: No.TQC-5B0080 05/11/28 By ice 直接收款時,也應考慮發票待扺&收款衝帳部分的異動
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號改為char(16)
# Modify.........: No.FUN-680022 06/08/15 By Tracy 多帳期修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6C0042 06/12/08 By chenl  1、將原子帳期項次改為帳款子帳期項次，對應于帳款(oma01)所對應的子帳款(omc)
# Modify.........:                                  2、若帳款子帳期資料僅為1筆，則帳款子帳期項次自動賦值為1。反之，則必須手動錄入。
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.TQC-740042 07/04/09 By bnlent 年度取帳套 
# Modify.........: No.TQC-750177 07/05/28 By rainy   直接收款""銀存異動碼""開窗查詢,應只需查出 ""存提別""(nmc03='1') 存入資料
# Modify.........: No.TQC-790092 07/09/17 By rainy 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.TQC-7B0035 07/11/06 By wujie  做直接收款，生成分錄后分錄底稿二取不到銀行科目
# Modify.........: No.TQC-7B0043 07/11/08 By wujie  子帳期項次必輸且必須存在對應的omc_file之內,且金額不能大于未衝金額 
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-890174 08/09/19 By chenl 1.收款幣種必須與賬款幣種相同。
# Modify.........:                                 2.若已存在相同子賬期的數據，則新增的記錄其金額應該是該子賬期的余額。
# Modify.........: No.FUN-960140 09/06/08 By lutingting add oob22
# Modify.........: No.TQC-970273 09/07/27 By Carrier 審核資料時,直接付款畫面僅供查看
# Modify.........: No.FUN-980011 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0043 09/11/06 By lutingting編譯時報錯"檢測 FORM LINE 發現錯誤,建議MESSAGE LINE指令為文字模式使用，請直接刪除本指令" 
# Modify.........: No.FUN-9B0147 09/11/27 By lutingting insert into ooa_file时给ooa37默认值N
# Modify.........: No.FUN-9C0041 09/12/08 By elva 子帐期判断MARK,使其可做差异处理
# Modify.........: No.FUN-A40076 10/07/02 By xiaofeizhu 修改ooa37的默認值，Y改為2，N改為1
# Modify.........: No.MOD-B10135 11/01/19 By Dido oob06 應不可修改 
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤
# Modify.........: No.TQC-B80021 11/08/21 By Dido ROLLBACK WORK 檢核有誤
# Modify.........: No.MOD-BA0175 11/10/26 By Polly 將BEGIN WORD移至CALL s_t300_a前
# Modify.........: No.MOD-BC0136 11/12/15 By Polly 修正「直接收款」刪除單身出現錯誤
# Modify.........: No.FUN-C90082 12/09/24 By xuxz 添加待抵收款方式
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D70037 13/07/16 By zhangweib 直接收款時,選擇TT也應該開放子帳期項次錄入
# Modify.........: No:MOD-D60149 13/09/10 By yinhy q_oma04增加參數


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_oma	    RECORD LIKE oma_file.*,
#   g_ooz	    RECORD LIKE ooz_file.*,
    m_oob           RECORD LIKE oob_file.*,
    g_ooa           RECORD LIKE ooa_file.*,
    g_oob2          RECORD LIKE oob_file.*,
    g_oob_o         RECORD LIKE oob_file.*,
    g_oob           DYNAMIC ARRAY OF RECORD    #Program Variables No.MOD-480007
        oob02           LIKE oob_file.oob02,
        oob03           LIKE oob_file.oob03,
        oob04           LIKE oob_file.oob04,
        #oob04_d         LIKE oob_file.oob04,    #No.FUN-680123 VARCHAR(10),   #FUN-960140 mark
        oob04_d         LIKE type_file.chr20,    #FUN-960140
        oob17           LIKE oob_file.oob17,
        oob18           LIKE oob_file.oob18,
        oob06           LIKE oob_file.oob06,
        oob19           LIKE oob_file.oob19,    #No.FUN-680022
        oob15           LIKE oob_file.oob15,
        oob11           LIKE oob_file.oob11,
        oob13           LIKE oob_file.oob13,
        oob14           LIKE oob_file.oob14,
        oob07           LIKE oob_file.oob07,
        oob08           LIKE oob_file.oob08,
        oob09           LIKE oob_file.oob09,
        oob10           LIKE oob_file.oob10,
        oob22           LIKE oob_file.oob22,    #FUN-960140 add
        oob12           LIKE oob_file.oob12
                    END RECORD,
    g_oob_t         RECORD
        oob02           LIKE oob_file.oob02,
        oob03           LIKE oob_file.oob03,
        oob04           LIKE oob_file.oob04,
        #oob04_d         LIKE oob_file.oob04,     #No.FUN-680123 VARCHAR(10),  #FUN-960140 MARK
        oob04_d         LIKE type_file.chr20,     #No.FUN-960140
        oob17           LIKE oob_file.oob17,
        oob18           LIKE oob_file.oob18,
        oob06           LIKE oob_file.oob06,
        oob19           LIKE oob_file.oob19,     #No.FUN-680022
        oob15           LIKE oob_file.oob15,
        oob11           LIKE oob_file.oob11,
        oob13           LIKE oob_file.oob13,
        oob14           LIKE oob_file.oob14,
        oob07           LIKE oob_file.oob07,
        oob08           LIKE oob_file.oob08,
        oob09           LIKE oob_file.oob09,
        oob10           LIKE oob_file.oob10,
        oob22           LIKE oob_file.oob22,    #NO.FUN-960140
        oob12           LIKE oob_file.oob12
                    END RECORD,
        g_i,l_ac        LIKE type_file.num5,          #No.FUN-680123 SMALLINT,
        g_buf           LIKE type_file.chr20          #No.FUN-680123 VARCHAR(20)
  DEFINE g_oob09_t      LIKE oob_file.oob09,
         g_oob10_t      LIKE oob_file.oob10,
         g_ooa31_diff   LIKE ooa_file.ooa31d,
         g_ooa32_diff   LIKE ooa_file.ooa32d,
         diff_flag      LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
  DEFINE l_ooa31d       LIKE ooa_file.ooa31d
  DEFINE l_ooa32d       LIKE ooa_file.ooa32d
  DEFINE l_azi04        LIKE azi_file.azi04
  DEFINE g_oob111       LIKE oob_file.oob111     #No.TQC-7B0035
  DEFINE g_bookno1        LIKE aza_file.aza81#FUN-C90082 
  DEFINE g_bookno2        LIKE aza_file.aza82  #FUN-C90082
  DEFINE g_flag           LIKE type_file.chr1  #FUN-C90082
  DEFINE g_net            LIKE apv_file.apv04  #FUN-C90082
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(72)
DEFINE   g_rec_b         LIKE type_file.num5          #No.FUN-680123 SMALLINT              #單身筆數
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE   g_wc            LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(300)         #查詢條件
         g_sql           LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(300)
#         g_t1            VARCHAR(3),                    #TQC-5A0089
         g_t1            LIKE ooy_file.ooyslip,       #No.FUN-680123 VARCHAR(5) #TQC-5A0089
         p_row,p_col     LIKE type_file.num5,         #No.FUN-680123 SMALLINT,
         b_oob           RECORD LIKE oob_file.*,
         g_ooa_t         RECORD LIKE ooa_file.* ,
         g_ooa_o         RECORD LIKE ooa_file.* ,
#        g_ooy           RECORD LIKE ooy_file.*,
         l_oob09_sum     LIKE oob_file.oob09,
         l_oob10_sum     LIKE oob_file.oob10
 
FUNCTION s_t300_w(p_no)
   DEFINE p_no LIKE oma_file.oma01         #No.FUN-680123 VARCHAR(16)
 
   WHENEVER ERROR CONTINUE
 
   # 合法驗証,是否存在該單據號，應收帳款系統是否使用
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01=p_no
   IF STATUS THEN 
#     CALL cl_err('sel oma:',STATUS,1)   #No.FUN-660116
      CALL cl_err3("sel","oma_file",p_no,"",STATUS,"","sel oma:",1)    #No.FUN-660116
      RETURN 
   END IF
   IF g_ooz.ooz01='N' THEN
      CALL cl_err('','9037',0)
      RETURN
   END IF
   IF g_oma.oma01 IS NULL THEN RETURN END IF
 
   # 若該單據未確認且未作廢，則可維護直接收款
   IF g_oma.omaconf = 'N' AND g_oma.omavoid = 'N' THEN
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      INPUT BY NAME g_oma.oma02 WITHOUT DEFAULTS ATTRIBUTES(REVERSE)
         AFTER INPUT
            IF g_oma.oma02 IS NULL THEN NEXT FIELD oma02 END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      UPDATE oma_file SET oma02=g_oma.oma02
       WHERE oma01=g_oma.oma01
   END IF
 
   OPEN WINDOW s_t300_w AT 10,2 WITH FORM "axr/42f/axrt300_w"
   #               ATTRIBUTE(BORDER,GREEN,FORM LINE FIRST)  #MOD-9B0043
 
   CALL cl_ui_locale("axrt300_w")
  #CALL cl_set_comp_visible("oob15,g_ooa31_diff,g_ooa32_diff",FALSE)#FUN-C90082 mark
   CALL cl_set_comp_visible("g_ooa31_diff,g_ooa32_diff",FALSE)#FUN-C90082 add
 
   LET g_forupd_sql = " SELECT * FROM ooa_file WHERE ooa01 = ? ",
                      "    FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_t300_cl CURSOR FROM g_forupd_sql
   # 若已存在直接收款明細，則直接抓取并顯示
 
   #No.TQC-970273  --Begin
   IF g_oma.omaconf = 'Y' THEN
      CALL s_t300_q(g_oma.oma01)
      CALL s_t300_bp('G')
   ELSE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM oob_file WHERE oob01 = g_oma.oma01
      IF g_cnt = 0 THEN
         BEGIN WORK         #MOD-BA0175 add
         CALL s_t300_a()
         LET g_rec_b = 0
         CALL s_t300_b()
        #CALL s_t300_d()    #MOD-BC0136 mark
      ELSE
         CALL s_t300_q(g_oma.oma01)
         CALL s_t300_u()
      END IF
   END IF
   #No.TQC-970273  --End
 
   IF g_oma.omavoid ='Y' THEN
      CALL cl_err(g_oma.oma01,'9027',1) CLOSE WINDOW s_t300_w RETURN
   END IF
   CLOSE WINDOW s_t300_w
END FUNCTION
 
FUNCTION s_t300_a()
DEFINE l_ooymxno LIKE ooy_file.ooymxno,
       l_stra    LIKE type_file.chr4,        #No.FUN-680123 VARCHAR(4), #TQC-840066
       l_strb    LIKE aba_file.aba18,        #No.FUN-680123 VARCHAR(2),
       l_strc    LIKE type_file.chr3,        #No.FUN-680123 VARCHAR(3),
       l_ooa_b   LIKE ooa_file.ooa03,        #No.FUN-680123 VARCHAR(10),
       l_ooa_e   LIKE ooa_file.ooa03         #No.FUN-680123 VARCHAR(10)
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_oob.clear()
    INITIALIZE g_ooa.* TO NULL
    LET g_ooa_o.* = g_ooa.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ooa.ooa00  = '2'
        LET g_ooa.ooa01  = g_oma.oma01
#       LET g_ooa.ooa02  = g_today
        LET g_ooa.ooa02  = g_oma.oma02     #No.TQC-7B0043
        LET g_ooa.ooa021 = g_today
        LET g_ooa.ooa03  = g_oma.oma03
        LET g_ooa.ooa032 = g_oma.oma032
        LET g_ooa.ooa13  = g_oma.oma13
        LET g_ooa.ooa14  = g_user
        LET g_ooa.ooa15  = g_grup
        LET g_ooa.ooa20  = 'Y'
        LET g_ooa.ooa23  = g_oma.oma23
        LET g_ooa.ooa24  = g_oma.oma24
        LET g_ooa.ooa31c = 0
        LET g_ooa.ooa32c = 0
        LET g_ooa.ooaconf= 'N'
        LET g_ooa.ooa34 = '0'   #FUN-9C0041 luttb add
        LET g_ooa.ooaprsw= 0
        LET g_ooa.ooauser= g_user
        LET g_ooa.ooaoriu = g_user #FUN-980030
        LET g_ooa.ooaorig = g_grup #FUN-980030
        LET g_ooa.ooagrup= g_grup
        LET g_ooa.ooadate= g_today
 
        LET g_ooa.ooalegal= g_legal #FUN-980011 add
       # LET g_ooa.ooa37 = 'N'    #FUN-9B0147 add    #FUN-A40076 mark 
        LET g_ooa.ooa37 = '1'    #FUN-A40076 add 
        # 計算原幣借方金額合計ooa31d,本幣借方金額合計ooa32d
        LET g_ooa.ooa31d=0 LET g_ooa.ooa32d=0
        CALL s_t300_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_ooa.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        INSERT INTO ooa_file VALUES (g_ooa.*)
        #TQC-5B0080 排除已有資料的情形
#       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        #IF SQLCA.SQLCODE AND SQLCA.SQLCODE != -239 THEN                   #TQC-790092
        IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790092
           CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)   #TQC-B80021
           ROLLBACK WORK
#          CALL cl_err('ins ooa',SQLCA.SQLCODE,1)   #No.FUN-660116
          #CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)   #No.FUN-660116 #TQC-B80021 mark
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           CALL cl_flow_notify(g_ooa.ooa01,'I')
        END IF
        SELECT ooa01 INTO g_ooa.ooa01 FROM ooa_file WHERE ooa01 = g_ooa.ooa01
        LET g_ooa_t.* = g_ooa.*
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s_t300_q(p_ooa01)
DEFINE p_ooa01    LIKE ooa_file.ooa01
 
   CALL g_oob.clear()
   IF cl_null(p_ooa01) THEN RETURN END IF
 
   LET g_wc=" ooa01='",p_ooa01,"'"
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND ooauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND ooagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND ooagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
   #End:FUN-980030
 
 
   LET g_sql = "SELECT UNIQUE ooa01 ",
               "  FROM ooa_file      ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ooa01     "
   PREPARE s_t300_prepare FROM g_sql
   DECLARE s_t300_cs CURSOR FOR s_t300_prepare
 
   MESSAGE " Searching....."
 
   OPEN s_t300_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ooa.* TO NULL
   ELSE
      FETCH s_t300_cs INTO  g_ooa.ooa01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_ooa.ooa01,SQLCA.sqlcode,0)
         RETURN
      ELSE
         SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ooa.ooa01,SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("sel","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
            INITIALIZE g_ooa.* TO NULL
            RETURN
         ELSE
            CALL s_t300_show()
         END IF
      END IF
   END IF
   MESSAGE ""
 
END FUNCTION
 
FUNCTION s_t300_show()
    LET g_ooa_t.* = g_ooa.*                #保存單頭舊值
 
    DISPLAY BY NAME g_oma.oma54t, g_oma.oma56t
    CALL s_t300_show_amt()
#    LET g_t1 = g_ooa.ooa01[1,3]   #TQC-5A0089
    LET g_t1 = s_get_doc_no(g_ooa.ooa01)   #TQC-5A0089
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    CALL s_t300_b_fill("1=1")
END FUNCTION
 
FUNCTION s_t300_show_amt()
   # 計算差異金額
   LET g_ooa31_diff = g_ooa.ooa31c - g_ooa.ooa31d
   LET g_ooa32_diff = g_ooa.ooa32c - g_ooa.ooa32d
   DISPLAY BY NAME g_ooa.ooa31d,g_ooa.ooa31c,g_ooa.ooa32c,g_ooa.ooa32d,
                   g_ooa31_diff,g_ooa32_diff
END FUNCTION
 
FUNCTION s_t300_b_fill(p_wc)
DEFINE p_wc           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(200)
 
    LET g_sql = " SELECT oob02,oob03,oob04,'',oob17,oob18, ",
                "        oob06,oob19,oob15,oob11,oob13,oob14,oob07,oob08,",    #No.FUN-680022 add oob19
                "        oob09,oob10,oob22,oob12                               ",  #FUN-960140 add oob22
                "   FROM oob_file  ",
                "  WHERE oob01 ='",g_ooa.ooa01,"'",  #單頭
                "    AND oob02 > 0 ",                #只選擇大于0的項次
                "    AND ",p_wc CLIPPED,                     #單身
                "  ORDER BY oob02 "
 
    PREPARE s_t300_pb FROM g_sql
    DECLARE s_oob_curs CURSOR FOR s_t300_pb
    CALL g_oob.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH s_oob_curs INTO g_oob[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CALL s_oob04(g_oob[g_cnt].oob03,g_oob[g_cnt].oob04)
               RETURNING g_oob[g_cnt].oob04_d
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oob.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    CALL s_t300_bp_refresh()
END FUNCTION
 
FUNCTION s_t300_bp_refresh()
   DISPLAY ARRAY g_oob TO s_oob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
   END DISPLAY
END FUNCTION
 
FUNCTION s_t300_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_oma.omaconf = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
    IF g_ooa.ooa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ooa.ooaconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ooa.ooaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    MESSAGE ""
    LET g_ooa_o.* = g_ooa.*
    BEGIN WORK
 
    OPEN s_t300_cl USING g_ooa.ooa01
    IF STATUS THEN
       CALL cl_err("OPEN s_t300_cl:", STATUS, 1)
       CLOSE s_t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH s_t300_cl INTO g_ooa.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ooa.ooa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE s_t300_cl ROLLBACK WORK RETURN
    END IF
    CALL s_t300_show()
    WHILE TRUE
        LET g_ooa.ooamodu=g_user                # 不可改單號,客戶...
        LET g_ooa.ooadate=g_today
        CALL s_t300_i("u")
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ooa.*=g_ooa_t.*
           CALL s_t300_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        UPDATE ooa_file SET * = g_ooa.* WHERE ooa01 = g_ooa.ooa01
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ooa.ooa01,SQLCA.sqlcode,0)   #No.FUN-660116
           CALL cl_err3("upd","ooa_file",g_ooa_t.ooa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
           CONTINUE WHILE
        ELSE
           CLOSE s_t300_cl
           COMMIT WORK
           CALL cl_flow_notify(g_ooa.ooa01,'U')
        END IF
        SELECT ooa01 INTO g_ooa.ooa01
          FROM ooa_file WHERE ooa01 = g_ooa.ooa01
        LET g_ooa_t.* = g_ooa.*
        LET l_ac = 1
        CALL s_t300_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s_t300_i(p_cmd)
  DEFINE p_cmd         LIKE type_file.chr1          #No.FUN-680123  VARCHAR(1)         #a:輸入 u:更改
 
  DISPLAY BY NAME g_oma.oma54t, g_oma.oma56t
  CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
  INPUT BY NAME g_ooa.ooa31d,g_ooa.ooa32d WITHOUT DEFAULTS
 
     AFTER FIELD ooa31d
       IF cl_null(g_ooa.ooa31d) THEN NEXT FIELD ooa31d END IF
       IF g_ooa.ooa31d > l_ooa31d THEN
          CALL cl_err(l_ooa31d,'axr-194',0)
          NEXT FIELD ooa31d
       END IF
       LET g_ooa.ooa32d=g_ooa.ooa31d* g_oma.oma24
       LET g_ooa.ooa32d=cl_digcut(g_ooa.ooa32d,g_azi04)
 
     AFTER FIELD ooa32d
       IF cl_null(g_ooa.ooa32d) THEN NEXT FIELD ooa32d END IF
       IF g_ooa.ooa32d> l_ooa32d THEN
          CALL cl_err(l_ooa32d,'axr-194',0)
          NEXT FIELD ooa32d
       END IF
 
     AFTER INPUT
       IF cl_null(g_ooa.ooa31d) THEN NEXT FIELD ooa31d END IF
       IF cl_null(g_ooa.ooa32d) THEN NEXT FIELD ooa32d END IF
 
     ON ACTION CONTROLF                  #欄位說明
        CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()
    END INPUT
END FUNCTION
 
FUNCTION s_t300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #No.FUN-680123 SMALLINT              #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,          #No.FUN-680123 SMALLINT                     #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,          #No.FUN-680123 SMALLINT              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)               #單身鎖住否
    p_cmd           LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)               #處理狀態
    l_flag          LIKE type_file.num10,         #No.FUN-680123 INTEGER
    l_aag07         LIKE aag_file.aag07,
    oob08_t         LIKE oob_file.oob08,          #FUN-4C0013
    oob09_t         LIKE oob_file.oob09,          #FUN-4C0013
    oob10_t         LIKE oob_file.oob10,
    l_omc02         LIKE omc_file.omc02,          #No.FUN-680022
    l_omc08         LIKE omc_file.omc08,          #No.FUN-680022
    l_omc09         LIKE omc_file.omc09,          #No.FUN-680022
    l_allow_insert  LIKE type_file.num5,          #No.FUN-680123 SMALLINT
    l_allow_delete  LIKE type_file.num5           #No.FUN-680123 SMALLINT
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-740009
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
DEFINE  l_oob09e    LIKE oob_file.oob09          #No.MOD-890174 #累計已存在的相同子賬期之原幣金額
DEFINE  l_oob10e    LIKE oob_file.oob10          #No.MOD-890174 #累計已存在的相同子賬期之本幣金額
DEFINE  l_nmh04     LIKE nmh_file.nmh04          #FUN-C90082 add
DEFINE  l_oma00     LIKE oma_file.oma00          #FUN-C90082 add
 
    LET g_action_choice = ""
    IF g_oma.omaconf = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
    IF g_ooa.ooa01 IS NULL THEN RETURN END IF
    IF g_ooa.ooaconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ooa.ooaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    #No.FUN-740009 --begin
    CALL s_get_bookno(YEAR(g_oma.oma02))    #No.TQC-740042
         RETURNING l_flag1,l_bookno1,l_bookno2
    IF  l_flag1='1' THEN #抓不到帳別
       CALL cl_err(YEAR(g_oma.oma02),'aoo-081',1)
       RETURN
    END IF
    #No.FUN-740009 --end
 
    CALL s_t300_bp_refresh()
 
    LET g_forupd_sql = "SELECT oob02,oob03,oob04,'',oob17,oob18,  ",
                       "       oob06,oob19,oob15,oob11,oob111,oob13,oob14,   ",  #No.FUN-680022 add oob19   #No.TQC-7B0035 add oob111
                       "       oob07,oob08,oob09,oob10,oob22,oob12              ",  #FUN-960140 add oob22
                       "   FROM oob_file",
                       " WHERE oob01=? AND oob02 > 0 AND oob02=?          ",
                       "   FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s_t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_success = 'Y'
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_oob WITHOUT DEFAULTS FROM s_oob.* HELP 1
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN s_t300_cl USING g_ooa.ooa01
            IF STATUS THEN
               CALL cl_err("OPEN s_t300_cl:", STATUS, 1)
               CLOSE s_t300_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH s_t300_cl INTO g_ooa.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ooa.ooa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE s_t300_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_oob_t.* = g_oob[l_ac].*  #BACKUP
               OPEN s_t300_bcl USING g_ooa.ooa01,g_oob_t.oob02
               IF STATUS THEN
                  CALL cl_err("OPEN s_t300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CLOSE s_t300_bcl
                  ROLLBACK WORK
               ELSE
                  FETCH s_t300_bcl INTO b_oob.oob02,b_oob.oob03,
                                        b_oob.oob04,g_msg,
                                        b_oob.oob17,b_oob.oob18,
                                        b_oob.oob06,b_oob.oob19,     #No.FUN-680022 add oob19
                                        b_oob.oob15,
                                        b_oob.oob11,b_oob.oob111,b_oob.oob13,    #No.TQC-7B0035
                                        b_oob.oob14,b_oob.oob07,
                                        b_oob.oob08,b_oob.oob09,
                                        b_oob.oob10,b_oob.oob22,b_oob.oob12   #FUN-960140 add oob22
                  IF SQLCA.sqlcode THEN
                      DISPLAY p_cmd
                      DISPLAY g_rec_b
                      CALL cl_err('lock oob',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      CALL s_t300_b_move_to()
                  END IF
               END IF
               CALL s_t300_set_entry_b()
               CALL s_t300_set_no_entry_b()
               CALL s_t300_chk_entry(p_cmd)    #NO.FUN-960140
               CALL cl_show_fld_cont()         #No.FUN-550037
               #FUN-C90082--add--str
               CALL cl_set_comp_entry('oob04',TRUE)
               CALL cl_set_comp_entry('oob17,oob18,oob13',g_oob[l_ac].oob04 = '2')
              #CALL cl_set_comp_entry('oob06,oob19,oob14,oob15',g_oob[l_ac].oob04= '3')   #No.TQC-D70037   Mark
               CALL cl_set_comp_entry('oob06,oob14,oob15',g_oob[l_ac].oob04= '3')         #No.TQC-D70037   Mark
               CALL cl_set_comp_required('oob17,oob18',g_oob[l_ac].oob04 = '2')
               CALL cl_set_comp_required('oob06',g_oob[l_ac].oob04 = '3')
               #FUN-C90082--add--end
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT COUNT(*) INTO l_n FROM oob_file
             WHERE oob01=g_ooa.ooa01 AND oob02=g_oob[l_ac].oob02
            IF l_n = 0 THEN                                   #<-NO:0352--
               IF g_oob[l_ac].oob09 = 0 AND g_oob[l_ac].oob10 = 0 THEN
                  INITIALIZE g_oob[l_ac].* TO NULL  #重要欄位空白,無效
               ELSE
                  CALL s_t300_b_move_back()
                  INSERT INTO oob_file VALUES(b_oob.*)
                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('ins oob',SQLCA.sqlcode,0)   #No.FUN-660116
                      CALL cl_err3("ins","oob_file",b_oob.oob01,b_oob.oob02,SQLCA.sqlcode,"","ins oob",0)   #No.FUN-660116
                      CANCEL INSERT
                  ELSE
                      MESSAGE 'INSERT O.K'
                      LET g_rec_b=g_rec_b+1
                      CALL s_t300_bu()
                      COMMIT WORK
                  END IF
               END IF
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_oob[l_ac].* TO NULL      #900423
            LET g_oob[l_ac].oob03 = '1'    #借
           #FUN-C90082-mark--str
           #LET g_oob[l_ac].oob04 = '2'    #TT
           #CALL cl_getmsg('axr-921',g_lang) RETURNING g_msg
           #LET g_oob[l_ac].oob04_d = g_msg
           #LET g_oob[l_ac].oob06=g_oma.oma01
           #LET g_oob[l_ac].oob07=g_oma.oma23
           #LET g_oob[l_ac].oob08=g_oma.oma24
           #IF cl_null(g_oob[l_ac].oob08) THEN
           #   LET g_oob[l_ac].oob08=1
           #END IF
           #LET g_oob[l_ac].oob09=0
           #LET g_oob[l_ac].oob10=0
           #LET g_oob[l_ac].oob22=0               #NO.FUN-960140
           #LET g_oob[l_ac].oob13=g_oma.oma15
           #FUN-C90082--mark--end
            LET g_oob_t.* = g_oob[l_ac].*         #新輸入資料
            CALL s_t300_chk_entry(p_cmd)          #NO.FUN-960140
            CALL s_t300_set_entry_b()
            CALL s_t300_set_no_entry_b()
           #FUN-C90082--add--str
            CALL cl_set_comp_entry('oob04',TRUE)
            CALL cl_set_comp_entry('oob17,oob18,oob13',g_oob[l_ac].oob04 = '2')
            CALL cl_set_comp_entry('oob06,oob19,oob14,oob15',g_oob[l_ac].oob04= '3')
            CALL cl_set_comp_required('oob17,oob18',g_oob[l_ac].oob04 = '2')
            CALL cl_set_comp_required('oob06',g_oob[l_ac].oob04 = '3')
           #FUN-C90082--add--end
            NEXT FIELD oob02
 
        BEFORE FIELD oob02                        #default 序號
           IF g_oob[l_ac].oob02 IS NULL OR g_oob[l_ac].oob02 = 0 THEN
              IF l_ac>1 THEN LET g_chr=g_oob[l_ac-1].oob03 END IF
              SELECT MAX(oob02)+1 INTO g_oob[l_ac].oob02 FROM oob_file
               WHERE oob01 = g_ooa.ooa01 AND oob02 > 0 #AND oob03<=g_chr
              IF g_oob[l_ac].oob02 IS NULL THEN
                 LET g_oob[l_ac].oob02 = 1
              END IF
           END IF
 
        AFTER FIELD oob02
           IF NOT cl_null(g_oob[l_ac].oob02) THEN
              IF g_oob[l_ac].oob02 != g_oob_t.oob02 OR g_oob_t.oob02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM oob_file
                  WHERE oob01 = g_ooa.ooa01 AND oob02 = g_oob[l_ac].oob02
                 IF l_n > 0 THEN
                    LET g_oob[l_ac].oob02 = g_oob_t.oob02
                    CALL cl_err('',-239,0) NEXT FIELD oob02
                 END IF
              END IF
           END IF
          #FUN-C90082--mark-str
          #IF g_oob[l_ac].oob11 IS NULL THEN
          #   SELECT ooc03 INTO g_oob[l_ac].oob11 FROM ooc_file
          #    WHERE ooc01=g_oob[l_ac].oob04
          #END IF
#No.TQC-7B0035 --begin
          #IF g_oob111 IS NULL THEN
          #   SELECT ooc04 INTO g_oob111 FROM ooc_file
          #    WHERE ooc01=g_oob[l_ac].oob04
          #END IF
#No.TQC-7B0035 --end
          #CALL s_t300_acct_code()
          #FUN-C90082--mark--end
           CALL s_t300_set_entry_b()
           CALL s_t300_set_no_entry_b()
 
        #FUN-C90082--add--str
        ON CHANGE oob04
           CALL cl_set_comp_entry('oob17,oob18,oob13',g_oob[l_ac].oob04 = '2')
           CALL cl_set_comp_entry('oob06,oob19,oob14,',g_oob[l_ac].oob04= '3')
           CALL cl_set_comp_required('oob17,oob18',g_oob[l_ac].oob04 = '2')
           IF g_oob[l_ac].oob04 = 2 THEN 
              CALL s_t300_acct_code()
              CALL cl_set_comp_entry('oob15',FALSE)
              LET g_oob[l_ac].oob04 = '2'    #TT
              CALL cl_getmsg('axr-921',g_lang) RETURNING g_msg
              LET g_oob[l_ac].oob04_d = g_msg
              LET g_oob[l_ac].oob06=g_oma.oma01
              LET g_oob[l_ac].oob07=g_oma.oma23
              LET g_oob[l_ac].oob08=g_oma.oma24
              IF cl_null(g_oob[l_ac].oob08) THEN
                 LET g_oob[l_ac].oob08=1
              END IF
              LET g_oob[l_ac].oob09=0
              LET g_oob[l_ac].oob10=0
              LET g_oob[l_ac].oob22=0               
              LET g_oob[l_ac].oob13=g_oma.oma15
              LET g_oob[l_ac].oob19 = ''
              IF g_oob[l_ac].oob11 IS NULL THEN
                 SELECT ooc03 INTO g_oob[l_ac].oob11 FROM ooc_file
                 WHERE ooc01=g_oob[l_ac].oob04
              END IF
              IF g_oob111 IS NULL THEN
                 SELECT ooc04 INTO g_oob111 FROM ooc_file
                 WHERE ooc01=g_oob[l_ac].oob04
              END IF
           ELSE
              LET g_oob[l_ac].oob06=''
              LET g_oob[l_ac].oob07=''
              LET g_oob[l_ac].oob08=''
              IF cl_null(g_oob[l_ac].oob08) THEN
                 LET g_oob[l_ac].oob08=''
              END IF
              LET g_oob[l_ac].oob09=0
              LET g_oob[l_ac].oob10=0
              LET g_oob[l_ac].oob11 = ''
              LET g_oob[l_ac].oob22=0               
              LET g_oob[l_ac].oob13=''
              LET g_oob[l_ac].oob17 = ''
              LET g_oob[l_ac].oob18 = ''
              CALL cl_set_comp_required('oob06',g_oob[l_ac].oob04 = '3')
           END IF 
        
        AFTER FIELD oob06
           IF NOT cl_null(g_oob[l_ac].oob06) THEN
              IF g_oob[l_ac].oob03='1' AND g_oob[l_ac].oob04='3' THEN
                 SELECT oma02 INTO l_nmh04 FROM oma_file
                  WHERE oma00 MATCHES '2*'
                    AND oma01 = g_oob[l_ac].oob06 
              END IF
  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","nmh_file",g_oob[l_ac].oob06,"",SQLCA.sqlcode,"","",0) 
              ELSE
                 IF l_nmh04 > g_ooa.ooa02 THEN
                    CALL cl_err('','axr-371',0)
                    NEXT FIELD oob06
                 END IF 
              END IF
 
              CALL s_get_bookno(YEAR(l_nmh04)) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag='1' THEN
                 CALL cl_err(l_nmh04,'aoo-081',1)
                 NEXT FIELD oob06
              END IF        
 
              IF g_oob[l_ac].oob03='1' AND g_oob[l_ac].oob04 MATCHES "[3]" THEN                         
                 IF p_cmd= 'a' OR g_oob_t.oob06 != g_oob[l_ac].oob06  THEN 
                    IF g_oob[l_ac].oob04 = '3' THEN 
                       SELECT oma00 INTO l_oma00 FROM oma_file
                        WHERE oma01 = g_oob[l_ac].oob06
                       IF (l_oma00!='21') AND (l_oma00!='22') AND (l_oma00!='23') AND
                          (l_oma00!='24') AND (l_oma00!='25') AND (l_oma00!='26') AND  
                          (l_oma00!='27') AND (l_oma00!='28') THEN   
                          CALL cl_err('','axr-992',0)
                          NEXT FIELD oob06
                       END IF 
                       SELECT COUNT(*) INTO l_n FROM omc_file 
                        WHERE omc01=g_oob[l_ac].oob06
                       IF l_n=1 THEN
                          LET g_oob[l_ac].oob19=1
                          CALL t300_oob06('2')
                          IF NOT cl_null(g_errno) THEN
                             NEXT FIELD oob06            
                          ELSE 
                             IF g_ooz.ooz62 = 'Y' THEN
                                NEXT FIELD oob15
                             ELSE
                                NEXT FIELD oob11
                             END IF
                          END IF
                       END IF 
                    END IF 
                 END IF                 
              END IF 
           END IF  
        
        AFTER FIELD oob19
           CALL cl_set_comp_entry("oob19",g_oob[l_ac].oob04='3')
           IF g_ooz.ooz62='Y' AND g_oob[l_ac].oob04='3'THEN
              CALL cl_set_comp_entry("oob15",TRUE)
           ELSE
              CALL cl_set_comp_entry("oob15",FALSE)
           END IF
           IF (p_cmd= 'a' OR g_oob_t.oob06 != g_oob[l_ac].oob06 OR
               g_oob_t.oob04 != g_oob[l_ac].oob04) THEN  

              SELECT COUNT(*) INTO l_n FROM omc_file
                 WHERE omc01=g_oob[l_ac].oob06
              IF l_n=1 THEN
                 LET g_oob[l_ac].oob19=1
                 CALL t300_oob06('2')
                 IF NOT cl_null(g_errno) THEN
                    NEXT FIELD oob06         
                 ELSE
                    IF g_ooz.ooz62 = 'Y' THEN
                       NEXT FIELD oob15
                    ELSE
                       NEXT FIELD oob11
                    END IF
                 END IF
              END IF
           END IF         
        #FUN-C90082--add--end

        BEFORE FIELD oob17
            LET g_oob2.oob02 = g_oob[l_ac].oob02
            SELECT oob18 INTO g_oob[l_ac].oob18 FROM oob_file
             WHERE oob01 = g_ooa.ooa01
               AND oob02 = g_oob[l_ac].oob02
            LET g_oob_o.oob18 = g_oob[l_ac].oob18
            LET g_oob_o.oob02 = g_oob[l_ac].oob02
 
        AFTER FIELD oob17
           #FUN-C90082--mark--str
           #IF g_oob[l_ac].oob04 = '2' AND cl_null(g_oob[l_ac].oob17) THEN
           #   NEXT FIELD oob17
           #END IF
           #FUN-C90082--mark--end
            IF g_oob[l_ac].oob17 IS NOT NULL THEN
               SELECT nma05,nma051,nma10   #No.TQC-7B0035
                 INTO g_oob[l_ac].oob11,g_oob111,g_oob[l_ac].oob07     #No.TQC-7B0035
                 FROM nma_file
                WHERE nma01 = g_oob[l_ac].oob17
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('sel nma:',STATUS,0)   #No.FUN-660116
                  CALL cl_err3("sel","nma_file",g_oob[l_ac].oob17,"",STATUS,"","sel nma:",0)   #No.FUN-660116
                  NEXT FIELD oob17
               END IF
              #No.MOD-890174--begin--
               IF g_oob[l_ac].oob07 <> g_oma.oma23 THEN 
                  CALL cl_err(g_oob[l_ac].oob07,'axr-144',0)
                  NEXT FIELD oob17
               END IF 
              #No.MOD-890174---end---
            END IF
 
         AFTER FIELD oob18
           IF NOT cl_null(g_oob[l_ac].oob18) THEN
              SELECT nmc02 FROM nmc_file
               WHERE nmc01 = g_oob[l_ac].oob18  AND nmc03 = '1'
              IF STATUS THEN
#                CALL cl_err(g_oob[l_ac].oob18,STATUS,0)   #No.FUN-660116
                 CALL cl_err3("sel","nmc_file",g_oob[l_ac].oob18,"",STATUS,"","",0)   #No.FUN-660116
                 LET g_oob[l_ac].oob18 = g_oob_o.oob18
                 DISPLAY BY NAME g_oob[l_ac].oob18
                 NEXT FIELD oob18
              END IF
           END IF
           LET g_oob_o.oob18 = g_oob[l_ac].oob18
 
        AFTER FIELD oob07
           IF NOT cl_null(g_oob[l_ac].oob07) THEN
              CALL s_t300_oob07('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_oob[l_ac].oob07,g_errno,0)
                 LET g_oob[l_ac].oob07 = g_oob_t.oob07
                 NEXT FIELD oob07
              END IF
            END IF
 
#No.TQC-6C0042--begin-- add
        BEFORE FIELD oob19
          IF p_cmd='a' OR cl_null(g_oob_t.oob19) THEN 
             SELECT COUNT(*) INTO l_cnt FROM omc_file WHERE omc01=g_oma.oma01
             IF l_cnt=1 THEN 
                LET g_oob[l_ac].oob19=1
                SELECT omc08,omc09 
                  INTO l_omc08,l_omc09
                  FROM omc_file 
                 WHERE omc01 = g_oma.oma01 
                   AND omc02 = g_oob[l_ac].oob19
               #No.MOD-890174--begin--
                CALL s_t300_tot(g_oob[l_ac].oob06,g_oob[l_ac].oob19,g_oob[l_ac].oob02)
                  RETURNING l_oob09e,l_oob10e
                LET g_oob[l_ac].oob09 = l_omc08 - l_oob09e
                LET g_oob[l_ac].oob10 = l_omc09 - l_oob10e
               #No.MOD-890174---end---
               #LET g_oob[l_ac].oob09 = l_omc08    #No.MOD-890174
               #LET g_oob[l_ac].oob10 = l_omc09    #No.MOD-890174
                DISPLAY BY NAME g_oob[l_ac].oob09
                DISPLAY BY NAME g_oob[l_ac].oob10
                NEXT FIELD oob11             
             END IF 
          END IF 
#No.TQC-6C0042--begin-- add
 
       #No.MOD-890174--begin--
       ON CHANGE oob19
          IF cl_null(g_oob[l_ac].oob19) THEN 
             LET g_oob[l_ac].oob09 = 0 
             LET g_oob[l_ac].oob10 = 0
             CALL cl_err('','axr-411',1)
             NEXT FIELD oob19
          ELSE
             SELECT COUNT(*) INTO l_cnt FROM omc_file
              WHERE omc01 = g_oob[l_ac].oob06
                AND omc02 = g_oob[l_ac].oob19
             IF l_cnt = 0 THEN 
                CALL cl_err(g_oob[l_ac].oob19,'aap-777',1)
                LET g_oob[l_ac].oob19 =NULL
                NEXT FIELD oob19
             ELSE 
               SELECT omc08,omc09 INTO l_omc08,l_omc09 FROM omc_file
                WHERE omc01 = g_oma.oma01 AND omc02 = g_oob[l_ac].oob19
               CALL s_t300_tot(g_oob[l_ac].oob06,g_oob[l_ac].oob19,g_oob[l_ac].oob02)
                 RETURNING l_oob09e,l_oob10e 
               LET g_oob[l_ac].oob09 = l_omc08 - l_oob09e
               LET g_oob[l_ac].oob10 = l_omc09 - l_oob10e
             END IF 
          END IF
       #No.MOD-890174---end---
 
     #No.MOD-890174--begin--
     # #No.FUN-680022  --start--
     #  AFTER FIELD oob19
     #     IF NOT cl_null(g_oob[l_ac].oob19) THEN  
     #        SELECT omc08,omc09 
     #          INTO l_omc08,l_omc09
     #          FROM omc_file 
     #         WHERE omc01 = g_oma.oma01 
     #           AND omc02 = g_oob[l_ac].oob19
     #        IF g_oob[l_ac].oob19 != g_oob_t.oob19 OR cl_null(g_oob_t.oob19) THEN
     #           LET g_oob[l_ac].oob09 = l_omc08
     #           LET g_oob[l_ac].oob10 = l_omc09
     #        END IF
     #     END IF 
     # #No.FUN-680022  --end--
     # #No.TQC-7B0043 --begin
     #     IF NOT cl_null(g_oob[l_ac].oob19) THEN
     #        SELECT COUNT(*) INTO l_cnt FROM omc_file 
     #         WHERE omc01 =g_oma.oma01
     #           AND omc02 =g_oob[l_ac].oob19
     #        IF l_cnt =0 THEN
     #           CALL cl_err(g_oob[l_ac].oob19,'aap-777',1)
     #           LET g_oob[l_ac].oob19 =NULL
     #           NEXT FIELD oob19
     #        END IF
     #     ELSE
     #        CALL cl_err('','axr-411',1)
     #        NEXT FIELD oob19
     #     END IF
     #  #No.TQC-7B0043 --end
     #No.MOD-890174---end---
 
        BEFORE FIELD oob08
           LET oob08_t = g_oob[l_ac].oob08   #No.+010
           IF g_oob[l_ac].oob08 = 0 OR g_oob[l_ac].oob08 = 1 OR
              cl_null(g_oob[l_ac].oob08) THEN
              CALL s_curr3(g_oob[l_ac].oob07,g_ooa.ooa02,g_ooz.ooz17)
                   RETURNING g_oob[l_ac].oob08
           END IF
           LET oob08_t=g_oob[l_ac].oob08
 
       #No.MOD-890174--begin--
        ON CHANGE oob08
           LET g_oob[l_ac].oob10 = g_oob[l_ac].oob09 * g_oob[l_ac].oob08
       #No.MOD-890174---end---
 
       #No.MOD-890174--begin-- mark
       #BEFORE FIELD oob09
       #   LET oob09_t=g_oob[l_ac].oob09
       #No.MOD-890174---end--- mark
 
        AFTER FIELD oob09
           IF NOT cl_null(g_oob[l_ac].oob09) THEN
              #FUN-C90082--add--str
              IF g_oob_t.oob09 != g_oob[l_ac].oob09 OR
                 g_oob_t.oob09 IS NOT NULL OR p_cmd = 'a' THEN
                 IF g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '3' THEN
                    IF NOT t300_oob09_13('1',p_cmd) THEN
                       NEXT FIELD oob09
                    END IF
                 END IF
              END IF
              #FUN-C90082--add--end
             #IF (oob08_t!=g_oob[l_ac].oob08) OR (oob09_t!=g_oob[l_ac].oob09) THEN  #No.MOD-890174 mark
             #FUN-9C0041 --begin MARK
             #   IF NOT cl_null(g_oob[l_ac].oob19) THEN
             #     #No.MOD-890174--begin--
             #      SELECT omc08 INTO  l_omc08 FROM omc_file 
             #       WHERE omc01 = g_oob[l_ac].oob06 
             #         AND omc02 = g_oob[l_ac].oob19
             #      CALL s_t300_tot(g_oob[l_ac].oob06,g_oob[l_ac].oob19,g_oob[l_ac].oob02)
             #        RETURNING l_oob09e,l_oob10e
             #     #No.MOD-890174---end---
             #     #IF g_oob[l_ac].oob09 > l_omc08 THEN   #No.MOD-890174 mark
             #     #   CALL cl_err(g_oob[l_ac].oob09,'axr-026',0)  #No.MOD-890174 mark
             #      IF g_oob[l_ac].oob09 + l_oob09e > l_omc08 THEN  #No.MOD-890174 
             #         CALL cl_err(g_oob[l_ac].oob09+l_oob09e,'axr-026',0)  #No.MOD-890174 
             #         NEXT FIELD oob09
             #      END IF
             #   END IF
             #FUN-9C0041 --end MARK
                 SELECT azi04 INTO t_azi04 FROM azi_file
                  WHERE azi01 = g_oob[l_ac].oob07
                 LET g_oob[l_ac].oob10 = g_oob[l_ac].oob08 * g_oob[l_ac].oob09
                 CALL cl_digcut(g_oob[l_ac].oob09,g_azi04)
                      RETURNING g_oob[l_ac].oob09
                 CALL cl_digcut(g_oob[l_ac].oob10,t_azi04)
                      RETURNING g_oob[l_ac].oob10
             #END IF   #No.MOD-890174 mark
              IF g_oob[l_ac].oob09 <= 0 THEN
                 IF g_oob[l_ac].oob04 <> '7' THEN
                    NEXT FIELD oob09
                 END IF
              END IF
           END IF
 
       #No.MOD-890174--begin-- mark
       #BEFORE FIELD oob10
       #   LET oob10_t=g_oob[l_ac].oob10
       #No.MOD-890174---end--- mark
 
        AFTER FIELD oob10
           IF NOT cl_null(g_oob[l_ac].oob10) THEN
#             IF oob10_t<>g_oob[l_ac].oob10 AND g_oob[l_ac].oob07<>g_aza.aza17 THEN
             #IF oob10_t<>g_oob[l_ac].oob10  THEN                 #No.TQC-7B0043   #No.MOD-890174 mark
             #FUN-9C0041 --begin MARK
             #   IF NOT cl_null(g_oob[l_ac].oob19) THEN
             #     #No.MOD-890174--begin--
             #      SELECT omc09 INTO l_omc09 FROM omc_file 
             #       WHERE omc01 = g_oob[l_ac].oob06
             #         AND omc02 = g_oob[l_ac].oob19
             #      CALL s_t300_tot(g_oob[l_ac].oob06,g_oob[l_ac].oob19,g_oob[l_ac].oob02)
             #        RETURNING l_oob09e,l_oob10e
             #     #No.MOD-890174---end---
             #     #IF g_oob[l_ac].oob10 > l_omc09 THEN    #No.MOD-890174 mark
             #     #   CALL cl_err(g_oob[l_ac].oob10,'axr-026',0)  #No.MOD-890174 mark
             #      IF g_oob[l_ac].oob10 + l_oob10e > l_omc09 THEN  #No.MOD-890174
             #         CALL cl_err(g_oob[l_ac].oob10 + l_oob10e,'axr-026',0)   #No.MOD-890174 
             #         LET g_oob[l_ac].oob10 =NULL                #No.TQC-7B0043
             #         NEXT FIELD oob10
             #      END IF
             #   END IF
             #FUN-9C0041 --end MARK
            #No.MOD-890174--begin-- mark
            #    IF cl_confirm('axr-320') THEN
            #       SELECT azi04 INTO g_azi04 FROM azi_file
            #        WHERE azi01 = g_oob[l_ac].oob07
            #       LET g_oob[l_ac].oob09 = g_oob[l_ac].oob10 / g_oob[l_ac].oob08
            #       CALL cl_digcut(g_oob[l_ac].oob09,g_azi04)
            #            RETURNING g_oob[l_ac].oob09
            #     ELSE
            #       LET g_oob[l_ac].oob08 = g_oob[l_ac].oob10 / g_oob[l_ac].oob09
            #    END IF
            # END IF   #No.MOD-890174 mark
            # IF g_oob[l_ac].oob08=1 AND g_oob[l_ac].oob07<>g_aza.aza17 THEN
            #    LET g_oob[l_ac].oob08 = g_oob[l_ac].oob10 / g_oob[l_ac].oob09
            # END IF
            #No.MOD-890174---end--- mark
            #FUN-C90082--add--str
              IF g_oob_t.oob10 != g_oob[l_ac].oob10 OR g_oob_t.oob10 IS NOT NULL OR p_cmd = 'a'THEN
                 IF g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '3' THEN
                    IF NOT t300_oob09_13('2',p_cmd) THEN
                       NEXT FIELD oob10
                    END IF
                 END IF
                  
                 IF oob10_t <> g_oob[l_ac].oob10 AND g_oob[l_ac].oob07 <> g_aza.aza17 THEN
                    IF cl_confirm('axr-320') THEN
                       SELECT azi04 INTO t_azi04 FROM azi_file 
                        WHERE azi01 = g_oob[l_ac].oob07
                       CALL cl_digcut(g_oob[l_ac].oob10,g_azi04)  
                          RETURNING g_oob[l_ac].oob10
                       LET g_oob[l_ac].oob09 = g_oob[l_ac].oob10 / g_oob[l_ac].oob08
                       CALL cl_digcut(g_oob[l_ac].oob09,t_azi04)  
                          RETURNING g_oob[l_ac].oob09
                    END IF
                 END IF
                 IF g_oob[l_ac].oob08 = 1 AND g_oob[l_ac].oob07 <> g_aza.aza17 THEN
                    LET g_oob[l_ac].oob08 = g_oob[l_ac].oob10 / g_oob[l_ac].oob09
                 END IF
                 IF g_oob[l_ac].oob08 = 1 THEN
                    IF g_oob[l_ac].oob09 <> g_oob[l_ac].oob10 THEN
                       CALL cl_err('','agl-926',0)
                       NEXT FIELD oob10 
                    END IF
                 END IF
              END IF 
             #FUN-C90082--add--end
              IF g_oob[l_ac].oob10 <= 0 THEN NEXT FIELD oob10 END IF
           END IF
 
#NO.FUN-960140------------start--------
       #FUN-C90082--mark--str
       #BEFORE FIELD oob04
       #   IF g_oob[l_ac].oob22 = 0 THEN
       #          CALL cl_set_comp_entry('oob04',TRUE)
       #   ELSE
       #          CALL cl_set_comp_entry('oob04',FALSE)
       #   END IF
       #FUN-C90082--mark--end
 
        AFTER FIELD oob04
           IF NOT cl_null(g_oob[l_ac].oob04) THEN
              CALL cl_set_comp_required('oob17,oob18',g_oob[l_ac].oob04 = '2')#FUN-C90082 add
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ooc_file
                 WHERE ooc01 = g_oob[l_ac].oob04
              IF l_cnt = 0 THEN
                 IF g_oob[l_ac].oob03='1' THEN
                    IF g_oob[l_ac].oob04 NOT MATCHES '[1,2,3,4,5,6,7,8,9,A,E,F,Q]' THEN
                       CALL cl_err('','axr-917',0)
                       NEXT FIELD oob04
                    END IF
                 ELSE
                    IF g_oob[l_ac].oob04 NOT MATCHES '[1,2,4,7,9,A,B,C,D,E,F,Q]' THEN
                       CALL cl_err('','axr-917',0)
                       NEXT FIELD oob04
                    END IF
                 END IF
              END IF
              #FUN-C90082--add--str
              IF g_oob[l_ac].oob04 NOT MATCHES '[2,3]' THEN 
                 NEXT FIELD oob04
              END IF 
              #FUN-C90082--add--end
              CALL s_oob04(g_oob[l_ac].oob03,g_oob[l_ac].oob04)
                   RETURNING g_oob[l_ac].oob04_d
              DISPLAY BY NAME g_oob[l_ac].oob04_d
              CALL s_t300_acct_code()
              IF g_oob[l_ac].oob11 IS NULL THEN
                 SELECT ooc03 INTO g_oob[l_ac].oob11 FROM ooc_file
                  WHERE ooc01=g_oob[l_ac].oob04
                  DISPLAY BY NAME g_oob[l_ac].oob11
              END IF
              IF g_aza.aza63='Y' THEN
                 IF g_oob111 IS NULL THEN
                    SELECT ooc04 INTO g_oob111 FROM ooc_file
                     WHERE ooc01=g_oob[l_ac].oob04
                     DISPLAY BY NAME g_oob111
                 END IF
              END IF
              IF g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = "7" AND
                 g_ooa31_diff != 0 AND NOT cl_null(g_ooa.ooa23) THEN
                 CALL cl_err('','axr-204',0) NEXT FIELD oob04
              END IF
              IF g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 MATCHES "[567]" AND
                 g_oob[l_ac].oob09 = 0   AND g_oob[l_ac].oob10 = 0 THEN
                 LET g_oob[l_ac].oob07 = g_ooa.ooa23
                 IF g_ooa31_diff = 0
                    THEN LET g_oob[l_ac].oob08 = 1
                    ELSE LET g_oob[l_ac].oob08 = g_ooa32_diff/g_ooa31_diff
                 END IF
                 LET g_oob[l_ac].oob09 = g_ooa31_diff
                 LET g_oob[l_ac].oob10 = g_ooa32_diff
                 LET g_oob[l_ac].oob10 = cl_digcut(g_oob[l_ac].oob10,g_azi04)
                             DISPLAY BY NAME g_oob[l_ac].oob08
                             DISPLAY BY NAME g_oob[l_ac].oob09
                             DISPLAY BY NAME g_oob[l_ac].oob10
              END IF
         END IF
         CALL s_t300_set_no_entry_b()
         CALL t300_set_no_entry_b1()
         CALL t300_set_entry_b1()
#NO.FUN-960140-----------end--------
 
        AFTER FIELD oob11
          IF NOT cl_null(g_oob[l_ac].oob11) THEN
#No.FUN-B10053  --Begin
#             SELECT aag02,aag07 INTO g_buf,l_aag07 FROM aag_file WHERE aag01=g_oob[l_ac].oob11
#                                                                   AND aag00 = l_bookno1      #No.FUN-740009
#             IF STATUS THEN
#                CALL cl_err('select aag',STATUS,0)    #No.FUN-660116
#                CALL cl_err3("sel","aag_file",g_oob[l_ac].oob11,"",STATUS,"","select aag",0)   #No.FUN-660116
#                NEXT FIELD oob11
#             END IF
#             IF l_aag07='1' THEN
#                  CALL cl_err(g_oob[l_ac].oob11,'agl-015',0) NEXT FIELD oob11
#             END IF
              CALL s_t300_oob11(g_oob[l_ac].oob11,l_bookno1)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_oob[l_ac].oob11,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_oob[l_ac].oob11
                 LET g_qryparam.arg1 = l_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",g_oob[l_ac].oob11 CLIPPED ,"%'"
                 CALL cl_create_qry() RETURNING g_oob[l_ac].oob11
                 DISPLAY BY NAME g_oob[l_ac].oob11
                 NEXT FIELD oob11 
               END IF
          END IF
          CALL t300_set_no_entry_b1()
 #No.FUN-B10053  --End
           
        AFTER FIELD oob13
          IF NOT cl_null(g_oob[l_ac].oob13) THEN
             SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_oob[l_ac].oob13
                AND gemacti='Y'   #NO:6950
             IF STATUS THEN
#               CALL cl_err('select gem',STATUS,0)   #No.FUN-660116
                CALL cl_err3("sel","gem_file",g_oob[l_ac].oob13,"",STATUS,"","select gem",0)   #No.FUN-660116
                NEXT FIELD oob13
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            DISPLAY "g_oob_t.oob02=",g_oob_t.oob02
            IF g_oob_t.oob02 > 0 AND g_oob_t.oob02 IS NOT NULL THEN
                #NO.FUN-960140---end----
                IF g_oob[l_ac].oob22 > 0 THEN     #g_oob_t.oob22 =g_oob[l_ac].oob22?
                   CALL cl_err("", 'axr-616', 1)
                   CANCEL DELETE
                END IF
                #NO.FUN-960140----end----
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM oob_file
                 WHERE oob01=g_ooa.ooa01 AND oob02=g_oob_t.oob02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_oob_t.oob02,SQLCA.sqlcode,0)   #No.FUN-660116
                    CALL cl_err3("del","oob_file",g_ooa.ooa01,g_oob_t.oob02,SQLCA.sqlcode,"","",0)   #No.FUN-660116
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
            END IF
           #No.MOD-890174--begin-- mark
           #IF cl_null(g_oob_t.oob02) THEN   #若本身有空行單身筆數要減1
           #    LET g_rec_b=g_rec_b-1        #確保g_rec_b筆數正確(genero)
           #END IF
           #No.MOD-890174---end---
            CALL s_t300_oma65_check()
            CALL s_t300_bu()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oob[l_ac].* = g_oob_t.*
               CLOSE s_t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oob[l_ac].oob02,-263,1)
               LET g_oob[l_ac].* = g_oob_t.*
            ELSE
               CALL s_t300_b_move_back()
               SELECT COUNT(*) INTO l_n FROM oob_file
                WHERE oob01=g_ooa.ooa01  AND oob02=g_oob[l_ac].oob02
               IF l_n = 0 THEN                                   #<-NO:0352--
                  IF g_oob[l_ac].oob09 = 0 AND g_oob[l_ac].oob10 = 0 THEN
                     INITIALIZE g_oob[l_ac].* TO NULL  #重要欄位空白,無效
                  END IF
               END IF
               UPDATE oob_file SET * = b_oob.*
                  WHERE oob01=g_ooa.ooa01 AND oob02=g_oob_t.oob02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd oob',SQLCA.sqlcode,0)   #No.FUN-660116
                  CALL cl_err3("upd","oob_file",g_ooa.ooa01,g_oob_t.oob02,SQLCA.sqlcode,"","upd oob",0)   #No.FUN-660116
                  LET g_oob[l_ac].* = g_oob_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CALL s_t300_bu()
                COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oob[l_ac].* = g_oob_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_oob.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                  #   LET g_action_choice = "detail"
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE s_t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE s_t300_bcl
            COMMIT WORK
 
       ON ACTION controlp
          CASE WHEN INFIELD(oob17)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_nma"
                    LET g_qryparam.where = " nma10 = '",g_oma.oma23,"'"  #No.MOD-890174
                    LET g_qryparam.default1 = g_oob[l_ac].oob17
                    CALL cl_create_qry() RETURNING g_oob[l_ac].oob17
                    DISPLAY g_oob[l_ac].oob17 TO oob17
                    NEXT FIELD oob17
               WHEN INFIELD(oob18)
                    CALL cl_init_qry_var()
                  #TQC-750177 begin
                    #LET g_qryparam.form ="q_nmc"
                    LET g_qryparam.form ="q_nmc02"
                    LET g_qryparam.arg1 = '1'
                  #TQC-750177 end
                    LET g_qryparam.default1 = g_oob[l_ac].oob18
                    CALL cl_create_qry() RETURNING g_oob[l_ac].oob18
                    DISPLAY BY NAME g_oob[l_ac].oob18
                    NEXT FIELD oob18
               #FUN-C90082-add--str
               WHEN INFIELD(oob06)
                   IF g_oob[l_ac].oob03='1' AND g_oob[l_ac].oob04='3' THEN
                      CALL q_oma4(FALSE,TRUE,g_oob[l_ac].oob06,g_oob[l_ac].oob02,
                                  g_ooa.ooa01,g_ooa.ooa03,'2*',g_ooa.ooa23)           #MOD-D60149
                           RETURNING g_oob[l_ac].oob06,g_oob[l_ac].oob09,g_oob[l_ac].oob10,g_oob[l_ac].oob19
                      NEXT FIELD oob06
                   END IF
               #FUN-C90082--ad--end
               WHEN INFIELD(oob11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_aag'
                    LET g_qryparam.default1 =g_oob[l_ac].oob11
                    LET g_qryparam.arg1 = l_bookno1      #No.FUN-740009
                    CALL cl_create_qry() RETURNING g_oob[l_ac].oob11
                    DISPLAY BY NAME g_oob[l_ac].oob11
                    NEXT FIELD oob11
               WHEN INFIELD(oob13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_gem'
                    LET g_qryparam.default1 = g_oob[l_ac].oob13
                    CALL cl_create_qry() RETURNING g_oob[l_ac].oob13
                    DISPLAY BY NAME g_oob[l_ac].oob13
                    NEXT FIELD oob13
               WHEN INFIELD(oob07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_azi'
                    LET g_qryparam.default1 =g_oob[l_ac].oob07
                    CALL cl_create_qry() RETURNING g_oob[l_ac].oob07
                    DISPLAY BY NAME g_oob[l_ac].oob07
                    NEXT FIELD oob07
               #NO.FUN-960140------start----
               WHEN INFIELD(oob04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ooc"
                     LET g_qryparam.default1 = g_oob[l_ac].oob04
                     LET g_qryparam.where = " aag_file.aag00 = '",l_bookno1,"'"
                     CALL cl_create_qry() RETURNING g_oob[l_ac].oob04
                     DISPLAY BY NAME g_oob[l_ac].oob04
                     NEXT FIELD oob04
               #NO.FUN-960140--------end-------
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLO
            IF INFIELD(oob02) AND l_ac > 1 THEN
                LET g_oob[l_ac].* = g_oob[l_ac-1].*
                NEXT FIELD oob02
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION controls                             #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.TQC-7B0043 --begin
      AFTER INPUT
         CALL s_t300_ins_oob()
        #-------------------------MOD-BC0136--------------------------------mark
        #SELECT COUNT(*) INTO l_cnt FROM oob_file WHERE oob01 =g_oma.oma01
        #IF l_cnt =0 THEN
        #   DELETE FROM ooa_file WHERE ooa01 =g_oma.oma01
        #   CLOSE s_t300_bcl
        #   COMMIT WORK
        #   RETURN
        #END IF
        #-------------------------MOD-BC0136--------------------------------mark
#No.TQC-7B0043 --end
    END INPUT
    CALL s_t300_d()                            #MOD-BC0136 add
 
    LET l_oob09_sum = 0
    SELECT SUM(oob09) INTO l_oob09_sum
      FROM oob_file
     WHERE oob01 = g_oma.oma01 AND oob02 > 0 AND oob03 = '1' #AND oob04 = '2'
    IF l_oob09_sum > 0 THEN
       UPDATE oma_file SET oma65='2' WHERE oma01=g_oma.oma01
       IF STATUS THEN
#         CALL cl_err('upd oma65:',STATUS,1)   #No.FUN-660116
          CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","upd oma65:",1)   #No.FUN-660116
          LET g_success='N'
          RETURN
       END IF
    END IF
    CALL s_t300_bu()
 
    IF (g_ooa.ooa31d > g_ooa.ooa31c OR
        (g_ooa.ooa31d = g_ooa.ooa31c AND
         g_ooa.ooa32d != g_ooa.ooa32c)) THEN
       LET p_row = 10 LET p_col = 27
       OPEN WINDOW s_t3001_w AT p_row,p_col WITH FORM "axr/42f/axrt3003"
            ATTRIBUTE (STYLE = g_win_style)
 
       CALL cl_ui_locale("axrt3003")
 
       IF (g_ooa.ooa31d = g_ooa.ooa31c) THEN
          IF g_ooa.ooa32d != g_ooa.ooa32c THEN
             LET diff_flag = '7'
          END IF
       ELSE
          IF g_ooa.ooa31d > g_ooa.ooa31c THEN
             LET diff_flag = '8'
          END IF
       END IF
       IF g_ooa.ooa32d = g_oma.oma56t THEN RETURN END IF
       DISPLAY BY NAME diff_flag
       INPUT BY NAME diff_flag WITHOUT DEFAULTS
         AFTER FIELD diff_flag
           IF diff_flag NOT MATCHES "[780E]" THEN NEXT FIELD diff_flag END IF
           IF diff_flag MATCHES '[8]'  AND g_ooa.ooa32d < g_ooa.ooa32c THEN
              CALL cl_err('','axr-304',0) NEXT FIELD diff_flag
           END IF
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
 
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
 
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
 
         END INPUT
         UPDATE ooa_file SET ooamodu = g_user,ooadate = g_today
          WHERE ooa01 = g_ooa.ooa01
         IF INT_FLAG THEN LET INT_FLAG=0 LET diff_flag='0' END IF
         CLOSE s_t300_bcl
         CLOSE WINDOW s_t3001_w
         IF diff_flag='0' THEN CALL s_t300_b() END IF #GENERO 再進單身時
      END IF
    CLOSE s_t300_bcl
    COMMIT WORK
 
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM oob_file
     WHERE oob01 = g_trno   AND oob03 = '2'
       AND oob04 = '2'      AND oob02 > 0
    IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
 
    IF diff_flag MATCHES "[78]" AND g_cnt = 0 THEN
       CALL s_t300_diff()
       CALL s_t300_b_fill('1=1')         #FOR GENERO MOD調整
       LET diff_flag = NULL
    END IF
#    LET g_t1=g_ooa.ooa01[1,3]   #TQC-5A0089
    LET g_t1=s_get_doc_no(g_ooa.ooa01)   #TQC-5A0089
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF STATUS THEN
       RETURN
    END IF
    IF (g_ooa.ooaconf='Y' OR g_ooy.ooyconf='N') #單據已確認或單據不需自動確認
       THEN RETURN
    END IF
    CLOSE s_t300_bcl
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION s_t300_oma65_check()
 
  SELECT COUNT(*) INTO g_cnt FROM oob_file
   WHERE oob01 = g_oma.oma01 AND oob02 > 0
  IF g_cnt = 0 THEN
     LET g_oma.oma65 = '1'
     UPDATE oma_file SET oma65 = g_oma.oma65
      WHERE oma01 = g_oma.oma01
  END IF
END FUNCTION
 
FUNCTION s_t300_set_entry_b()
 
    MESSAGE ''
    CALL cl_set_comp_entry("oob07",TRUE)
    CALL cl_set_comp_entry("oob08",TRUE)   #NO.FUN-960140
 
END FUNCTION
 
FUNCTION s_t300_set_no_entry_b()
 
    MESSAGE ''
    IF NOT cl_null(g_ooa.ooa23) THEN
       CALL cl_set_comp_entry("oob07",FALSE)
    END IF
    #NO.FUN-960140--------START-----ADD---
    IF (g_oob[l_ac].oob03='1' AND g_oob[l_ac].oob04 MATCHES "[1239]") THEN
       CALL cl_set_comp_entry("oob07,oob08",FALSE)
    END IF
    IF g_oob[l_ac].oob07=g_aza.aza17 THEN
       CALL cl_set_comp_entry("oob08",FALSE)
       LET g_oob[l_ac].oob08=1.0
       DISPLAY BY NAME g_oob[l_ac].oob08
    END IF
  #NO.FUN-960140----END-----ADD---
END FUNCTION
 
FUNCTION s_t300_acct_code()
DEFINE l_ool RECORD LIKE ool_file.*
 
   IF NOT cl_null(g_oob[l_ac].oob11) THEN RETURN END IF
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_ooa.ooa13
   CASE WHEN g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '2'    #TT
             LET b_oob.oob11 = l_ool.ool23
             LET b_oob.oob111 = l_ool.ool231      #No.TQC-7B0035
        WHEN g_oob[l_ac].oob03 = '2' AND g_oob[l_ac].oob04 = '2'    #溢收
             LET b_oob.oob11 = l_ool.ool25
             LET b_oob.oob111 = l_ool.ool251      #No.TQC-7B0035
        WHEN g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '7' AND  #匯損
             g_oob[l_ac].oob10 > 0   LET b_oob.oob11 = l_ool.ool52
                                     LET b_oob.oob111 = l_ool.ool521      #No.TQC-7B0035 
        WHEN g_oob[l_ac].oob03 = '2' AND g_oob[l_ac].oob04 = '7'      #匯盈
                               LET b_oob.oob11 = l_ool.ool53
                               LET b_oob.oob111 = l_ool.ool531      #No.TQC-7B0035
        #NO.FUN-960140----------start-------------
        WHEN g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '5'
             LET b_oob.oob11 = l_ool.ool54
             IF g_aza.aza63='Y' THEN
                LET b_oob.oob111 = l_ool.ool541
             END IF
        WHEN g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '6'
             LET b_oob.oob11 = l_ool.ool51
             IF g_aza.aza63='Y' THEN
                LET b_oob.oob111 = l_ool.ool511
             END IF
        WHEN g_oob[l_ac].oob03 = '2' AND g_oob[l_ac].oob04 = '7'
             LET b_oob.oob11 = l_ool.ool53
             IF g_aza.aza63='Y' THEN
                LET b_oob.oob111 = l_ool.ool531
             END IF
        WHEN g_oob[l_ac].oob03 = '1' AND g_oob[l_ac].oob04 = '8'
             LET b_oob.oob11 = l_ool.ool23
             IF g_aza.aza63='Y' THEN
                LET b_oob.oob111 = l_ool.ool231
             END IF
        WHEN g_oob[l_ac].oob03 = '2' AND g_oob[l_ac].oob04 = '2'
             LET b_oob.oob11 = l_ool.ool25
             IF g_aza.aza63='Y' THEN
                LET b_oob.oob111 = l_ool.ool251
             END IF
        OTHERWISE
           IF b_oob.oob04 != g_oob[l_ac].oob04 THEN
              LET b_oob.oob11 = null
              LET b_oob.oob111= null
           END IF
           LET g_oob[l_ac].oob11 = null
           LET g_oob111= null
        #NO.FUN-960140----------end------------ 
   END CASE
#NO.FUN-960140----------start------------
#   IF cl_null(g_oob[l_ac].oob11) THEN
#      LET g_oob[l_ac].oob11 = b_oob.oob11
#   ELSE
#      LET b_oob.oob11=g_oob[l_ac].oob11
#   END IF
 
   IF cl_null(g_oob[l_ac].oob11) THEN
      LET g_oob[l_ac].oob11 = b_oob.oob11
      LET g_oob111= b_oob.oob111
      DISPLAY BY NAME g_oob[l_ac].oob11
      DISPLAY BY NAME g_oob111
   ELSE
      LET b_oob.oob11 =g_oob[l_ac].oob11
      LET b_oob.oob111=g_oob111
   END IF
#NO.FUN-960140----------end----------
END FUNCTION
 
FUNCTION s_t300_oob07(p_cmd)
DEFINE
      p_cmd        LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1),
      l_azi01      LIKE azi_file.azi01,
      l_aziacti    LIKE azi_file.aziacti
 
      LET g_errno = ' '
      SELECT azi01,aziacti INTO l_azi01,l_aziacti
        FROM azi_file
       WHERE azi01 = g_oob[l_ac].oob07
      CASE
          WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
                                   LET l_azi01 = NULL
                                   LET l_aziacti = NULL
          WHEN l_aziacti = 'N' LET g_errno = '9028'
          OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
END FUNCTION
 
FUNCTION s_t300_bu()
   IF g_ooa.ooa01 IS NULL THEN RETURN END IF                   #MOD-BC0136 add
   LET g_ooa.ooa31d = 0 LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0 LET g_ooa.ooa32c = 0
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
          FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='1'
                          AND oob02>0
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
          FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='2'
                          AND oob02 > 0
   IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
   IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF
   IF cl_null(g_ooa.ooa31c) THEN
      LET g_ooa.ooa31c=g_oma.oma54t
   ELSE
      LET g_ooa.ooa31c=g_oma.oma54t + g_ooa.ooa31c
   END IF
   IF cl_null(g_ooa.ooa32c) THEN
      LET g_ooa.ooa32c=g_oma.oma56t
   ELSE
      LET g_ooa.ooa32c=g_oma.oma56t + g_ooa.ooa32c
   END IF
 
   IF g_ooa.ooa31d < g_ooa.ooa31c THEN
      LET g_ooa.ooa31c=g_ooa.ooa31d
      LET g_ooa.ooa32c=g_ooa.ooa32d
   END IF
 
   LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,t_azi04)
   LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,t_azi04)
 
   UPDATE ooa_file SET
          ooa31d=g_ooa.ooa31d,ooa31c=g_ooa.ooa31c,
          ooa32d=g_ooa.ooa32d,ooa32c=g_ooa.ooa32c
          WHERE ooa01=g_ooa.ooa01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd ood31,32',SQLCA.SQLCODE,0)   #No.FUN-660116
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ood31,32",1)   #No.FUN-660116
   END IF
 
   CALL s_t300_show_amt()
END FUNCTION
 
FUNCTION s_t300_diff()
   DEFINE l_oob10d  LIKE oob_file.oob10
   DEFINE l_oob10c  LIKE oob_file.oob10
   DEFINE l_msg     LIKE type_file.chr20         #No.FUN-680123 VARCHAR(20)
 
   IF g_ooa.ooa32d = g_ooa.ooa32c THEN RETURN END IF
   INITIALIZE b_oob.* TO NULL
   LET b_oob.oob01=g_ooa.ooa01
   LET b_oob.oob07=g_ooa.ooa23
   IF b_oob.oob07 IS NULL THEN
      WHILE b_oob.oob07 IS NULL
         LET l_msg=cl_getmsg('axr-030',g_lang)  #MOD-4C0141
        PROMPT l_msg FOR b_oob.oob07
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
 
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
 
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
        END PROMPT
        IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
      END WHILE
   END IF
    SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = b_oob.oob07 #MOD-560077
   IF diff_flag='8'
      THEN LET b_oob.oob03='2'
           LET b_oob.oob04='2'
           LET b_oob.oob22=0                          #NO.FUN-960140
           SELECT SUM(oob10)/SUM(oob09) INTO b_oob.oob08 FROM oob_file
            WHERE oob01=g_ooa.ooa01 AND oob03='1' AND oob09>0
              AND oob02>0
           LET b_oob.oob09= g_ooa.ooa31d - g_ooa.ooa31c
           IF b_oob.oob08 IS NOT NULL THEN
             #No.B181 010411 by plum modi
             #LET b_oob.oob10= b_oob.oob08 * b_oob.oob09
             IF b_oob.oob07 = g_aza.aza17 THEN
                LET b_oob.oob10= g_ooa.ooa32d - g_ooa.ooa32c
             ELSE
              LET b_oob.oob10= b_oob.oob08 * b_oob.oob09
             END IF
             #No.B181 ..end
            ELSE
              LET b_oob.oob10= g_ooa.ooa32d - g_ooa.ooa32c
              LET b_oob.oob08= b_oob.oob10/b_oob.oob09
           END IF
      ELSE LET b_oob.oob03='1'
           LET b_oob.oob04=diff_flag
           LET b_oob.oob22=0                          #NO.FUN-960140
           LET b_oob.oob10= g_ooa.ooa32c - g_ooa.ooa32d
         IF b_oob.oob10<0 THEN LET b_oob.oob10=-b_oob.oob10 END IF
           IF diff_flag='7' OR g_ooa.ooa31d = g_ooa.ooa31c
              THEN LET b_oob.oob08= 1
                   LET b_oob.oob09= 0
               IF g_ooa.ooa32d>g_ooa.ooa32c THEN #匯兌收入
                    LET b_oob.oob03='2'
                  ELSE
                    LET b_oob.oob03='1'                   #匯兌損失
               END IF
              ELSE LET b_oob.oob09= g_ooa.ooa31c - g_ooa.ooa31d
                   LET b_oob.oob08= b_oob.oob10/b_oob.oob09
           END IF
   END IF
   CALL cl_digcut(b_oob.oob09,g_azi04) RETURNING b_oob.oob09
   CALL cl_digcut(b_oob.oob10,t_azi04) RETURNING b_oob.oob10
 
   SELECT MAX(oob02)+1 INTO b_oob.oob02 FROM oob_file
    WHERE oob01=g_ooa.ooa01 #AND oob03=b_oob.oob03
      AND oob02 > 0
   IF STATUS OR b_oob.oob02 IS NULL THEN
      IF b_oob.oob03='1' THEN LET b_oob.oob02=1 ELSE LET b_oob.oob02=5 END IF
   END IF
   CALL s_t300_b_move_to()
   CALL s_t300_acct_code()
   LET b_oob.oob13= g_ooa.ooa15
   LET b_oob.ooblegal= g_legal #FUN-980011 add
   INSERT INTO oob_file VALUES(b_oob.*)
   IF STATUS THEN
      BEGIN WORK LET g_success='Y'
 
      OPEN s_t300_cl USING g_ooa.ooa01
      IF STATUS THEN
         CALL cl_err("OPEN s_t300_cl:", STATUS, 1)  
         CLOSE s_t300_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH s_t300_cl INTO g_ooa.*       # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
          CALL cl_err(g_ooa.ooa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
          CLOSE s_t300_cl ROLLBACK WORK RETURN
      END IF
      CALL s_t300_sortb() RETURNING b_oob.oob02
      IF g_success='Y' THEN COMMIT WORK
         INSERT INTO oob_file VALUES(b_oob.*)
      ELSE
         ROLLBACK WORK
         CALL cl_err('ins oob',STATUS,1)
      END IF
   END IF
   CALL s_t300_bu()
END FUNCTION
 
FUNCTION s_t300_sortb()
DEFINE p_i,p_rnum  LIKE type_file.num5,          #No.FUN-680123  SMALLINT,
         p_oob03_t LIKE oob_file.oob03,
         p_a       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1),
         p_oob       RECORD LIKE oob_file.*,
         x_oob      DYNAMIC ARRAY OF RECORD like oob_file.*
   #FUN-680123 begin
   CREATE TEMP TABLE sort_file(
         oob01 LIKE oob_file.oob01,
         oob02 LIKE oob_file.oob02,
         oob03 LIKE oob_file.oob03,
         oob04 LIKE oob_file.oob04,
         oob05 LIKE oob_file.oob05,
         oob06 LIKE oob_file.oob06,
         oob07 LIKE oob_file.oob07,
         oob08 LIKE oob_file.oob08 NOT NULL,
         oob09 LIKE oob_file.oob09 NOT NULL,
         oob10 LIKE oob_file.oob10 NOT NULL,
         oob11 LIKE oob_file.oob11,
         oob12 LIKE oob_file.oob12,
         oob13 LIKE oob_file.oob13,
	 oob14 LIKE oob_file.oob14,
         oob15 LIKE oob_file.oob15,
         oob16 LIKE oob_file.oob16,
         oob17 LIKE oob_file.oob17,
         oob18 LIKE oob_file.oob18,  #FUN-4C0013  #FUN-660152  #FUN-680123 end
         oob111 LIKE oob_file.oob111, #FUN-980011 begin  add
         oob19 LIKE oob_file.oob19,  
         oobud01 LIKE oob_file.oobud01,
         oobud02 LIKE oob_file.oobud02,
         oobud03 LIKE oob_file.oobud03,
         oobud04 LIKE oob_file.oobud04,
         oobud05 LIKE oob_file.oobud05,
         oobud06 LIKE oob_file.oobud06,
         oobud07 LIKE oob_file.oobud07,
         oobud08 LIKE oob_file.oobud08,
         oobud09 LIKE oob_file.oobud09,
         oobud10 LIKE oob_file.oobud10,
         oobud11 LIKE oob_file.oobud11,
         oobud12 LIKE oob_file.oobud12,
         oobud13 LIKE oob_file.oobud13,
         oobud14 LIKE oob_file.oobud14,
         oobud15 LIKE oob_file.oobud15,
         ooblegal LIKE oob_file.ooblegal,
         oob20 LIKE oob_file.oob20,  
         oob21 LIKE oob_file.oob21,  
         oob22 LIKE oob_file.oob22,  
         oob23 LIKE oob_file.oob23)     
       #FUN-980011 end add
 
       INITIALIZE p_oob.* TO NULL
       DECLARE s_t300_sortb_cur CURSOR FOR
        SELECT * FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob02 > 0
        ORDER BY oob03
 
      LET p_i=1
      FOREACH s_t300_SORTB_CUR INTO p_oob.*
          IF STATUS THEN LET g_success='N' RETURN 0 END IF
        INSERT INTO sort_file VALUES(p_oob.*)
          IF STATUS THEN LET g_success='N' RETURN 0 END IF
      END FOREACH
            LET INT_FLAG = 0  ######add for prompt mod
        PROMPT 'any key continue...' FOR CHAR p_a
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
#              CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        END PROMPT
        DELETE FROM oob_file WHERE oob01=g_ooa.ooa01
      IF STATUS THEN
            LET g_success='N' RETURN 0
        END IF
      LET p_i=1
      DECLARE s_t300_sortc_cur CURSOR FOR
         SELECT * FROM sort_file WHERE oob01=g_ooa.ooa01 ORDER BY oob03
      LET p_oob03_t=1
      FOREACH s_t300_SORTC_CUR INTO p_oob.*
        IF p_oob.oob03<>p_oob03_t THEN
           LET p_rnum=p_i
           LET p_i=p_i+1
          END IF
        LET p_oob.oob02=p_i
        INSERT INTO oob_file VALUES(p_oob.*)
        IF STATUS THEN LET g_success='N' RETURN 0 END IF
          LET p_oob03_t=p_oob.oob03
        LET p_i=p_i+1
      END FOREACH
      DROP TABLE sort_file
      RETURN p_rnum
END FUNCTION
 
FUNCTION s_t300_b_move_to()
   LET b_oob.oob01 = g_oma.oma01
   LET g_oob[l_ac].oob02 = b_oob.oob02
   LET g_oob[l_ac].oob03 = b_oob.oob03
   LET g_oob[l_ac].oob04 = b_oob.oob04
   CALL s_oob04(b_oob.oob03,b_oob.oob04)
        RETURNING g_oob[l_ac].oob04_d
   LET g_oob[l_ac].oob06 = b_oob.oob06
   LET g_oob[l_ac].oob19 = b_oob.oob19           #No.FUN-680022 
   LET g_oob[l_ac].oob17 = b_oob.oob17
   LET g_oob[l_ac].oob18 = b_oob.oob18
   LET g_oob[l_ac].oob15 = b_oob.oob15
   LET g_oob[l_ac].oob07 = b_oob.oob07
   LET g_oob[l_ac].oob08 = b_oob.oob08
   LET g_oob[l_ac].oob09 = b_oob.oob09
   LET g_oob[l_ac].oob10 = b_oob.oob10
   LET g_oob[l_ac].oob11 = b_oob.oob11
   LET g_oob[l_ac].oob22 = b_oob.oob22          #No.FUN-960140--ADD--
   LET g_oob[l_ac].oob12 = b_oob.oob12
   LET g_oob[l_ac].oob13 = b_oob.oob13
   LET g_oob[l_ac].oob14 = b_oob.oob14
END FUNCTION
 
FUNCTION s_t300_b_move_back()
   LET b_oob.oob01 = g_oma.oma01
   LET b_oob.oob02 = g_oob[l_ac].oob02
   LET b_oob.oob03 = g_oob[l_ac].oob03
   LET b_oob.oob04 = g_oob[l_ac].oob04
   LET b_oob.oob06 = g_oob[l_ac].oob06
   LET b_oob.oob19 = g_oob[l_ac].oob19           #No.FUN-680022
   LET b_oob.oob17 = g_oob[l_ac].oob17
   LET b_oob.oob18 = g_oob[l_ac].oob18
   LET b_oob.oob15 = g_oob[l_ac].oob15
   LET b_oob.oob07 = g_oob[l_ac].oob07
   LET b_oob.oob08 = g_oob[l_ac].oob08
   LET b_oob.oob09 = g_oob[l_ac].oob09
   LET b_oob.oob10 = g_oob[l_ac].oob10
   LET b_oob.oob11 = g_oob[l_ac].oob11
   LET b_oob.oob111= g_oob111                    #No.TQC-7B0035
   LET b_oob.oob12 = g_oob[l_ac].oob12
   LET b_oob.oob13 = g_oob[l_ac].oob13
   LET b_oob.oob14 = g_oob[l_ac].oob14
   LET b_oob.ooblegal= g_legal #FUN-980011 add
END FUNCTION
 
FUNCTION s_t300_d()
 
  #BEGIN WORK         #MOD-BA0175 mark
   SELECT COUNT(*) INTO g_cnt FROM oob_file
    WHERE oob01 = g_oma.oma01 AND oob02 > 0
   IF g_cnt = 0 THEN
      DELETE FROM ooa_file WHERE ooa01 = g_oma.oma01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('No ooa deleted','',0)   #No.FUN-660116
         CALL cl_err3("del","ooa_file",g_oma.oma01,"","","","No ooa deleted",0)   #No.FUN-660116
         ROLLBACK WORK
         RETURN
      END IF
      #-------------------------MOD-BC0136--------------------------------add
      INITIALIZE g_ooa.* TO NULL
      DELETE FROM oob_file WHERE oob01 = g_oma.oma01 AND oob02 < 0
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","oob_file",g_oma.oma01,"","","","No oob deleted",0)   #No.FUN-660116
         ROLLBACK WORK
         RETURN
      END IF
      #-------------------------MOD-BC0136--------------------------------add
   END IF
   COMMIT WORK
END FUNCTION
#No.TQC-7B0043 --begin
# 為保証axrt400中借貸相平，則需更新oob_file中負項次
FUNCTION s_t300_ins_oob()
DEFINE  l_oob  RECORD LIKE oob_file.*,
        l_ooa  RECORD LIKE ooa_file.*
 
   DELETE FROM oob_file
    WHERE oob01 = g_oma.oma01 AND oob02 <0  
      AND oob03 = '2'    AND oob04 = '1'
 
   INITIALIZE l_oob.* TO NULL
   INITIALIZE l_ooa.* TO NULL
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_oma.oma01
   IF cl_null(l_ooa.ooa01) THEN  RETURN END IF
      
   DECLARE s_t300_sel_oob_cur CURSOR FOR
     SELECT * FROM oob_file
      WHERE oob01 =g_oma.oma01
   FOREACH s_t300_sel_oob_cur INTO l_oob.*
      LET l_oob.oob02 = l_oob.oob02*(-1)
      LET l_oob.oob03 = '2'
      LET l_oob.oob04 = '1'
      LET l_oob.oob06 = g_oma.oma01
      LET l_oob.oob07 = l_ooa.ooa23
      LET l_oob.oob08 = l_ooa.ooa24
      IF cl_null(l_oob.oob09) THEN LET l_oob.oob09 = 0 END IF
      IF cl_null(l_oob.oob10) THEN LET l_oob.oob10 = 0 END IF
      LET l_oob.oob13 = l_ooa.ooa15
      LET l_oob.ooblegal = g_legal #FUN-980011 add
      INSERT INTO oob_file VALUES (l_oob.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob#1",1)
      END IF
   END FOREACH
END FUNCTION
#No.TQC-7B0043 --end
 
#No.MOD-890174--begin--
#已存在的同一子賬期的記錄，金額累計值計算。
FUNCTION s_t300_tot(p_oob06,p_oob19,p_oob02)
DEFINE l_n      LIKE type_file.num10
DEFINE p_oob06  LIKE oob_file.oob06
DEFINE p_oob19  LIKE oob_file.oob19
DEFINE p_oob02  LIKE oob_file.oob02
DEFINE l_oob09  LIKE oob_file.oob09
DEFINE l_oob10  LIKE oob_file.oob10
 
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM oob_file 
     WHERE oob06 = p_oob06 AND oob19 = p_oob19
       AND oob02 > 0
       AND oob02 <> p_oob02
         
    IF l_n = 0 THEN 
       LET l_oob09 = 0
       LET l_oob10 = 0 
       RETURN l_oob09 ,l_oob10
    END IF 
    LET l_oob09 = 0
    LET l_oob10 = 0 
    SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 
      FROM oob_file
     WHERE oob06 = p_oob06 AND oob19 = oob19
       AND oob02 > 0
       AND oob02 <> p_oob02
 
    RETURN l_oob09,l_oob10
 
END FUNCTION 
#No.MOD-890174---end---
 
#No.FUN-960140----start-----
FUNCTION t300_set_entry_b1()
    IF g_oob[l_ac].oob03='1' THEN
       IF g_oob[l_ac].oob04='3' THEN
          CALL cl_set_comp_entry("oob19",TRUE)
          IF g_ooz.ooz62='Y' THEN
             CALL cl_set_comp_entry("oob15",TRUE)
          END IF
       END IF
       IF g_oob[l_ac].oob04='4' THEN
          CALL cl_set_comp_entry("oob19",TRUE)
          IF g_ooz.ooz62='Y' THEN
             CALL cl_set_comp_entry("oob15",TRUE)
          END IF
       END IF
       IF g_oob[l_ac].oob04 NOT MATCHES '[34]' AND NOT(g_oob[l_ac].oob03='1' AND g_oob[l_ac].oob04='1') THEN
          CALL cl_set_comp_entry("oob15",TRUE)
       END IF
    END IF
END FUNCTION
 
FUNCTION t300_set_no_entry_b1()
       CALL cl_set_comp_entry("oob15,oob19",FALSE)
END FUNCTION
 
FUNCTION s_t300_chk_entry(p_cmd)
DEFINE p_cmd         LIKE type_file.chr1
 
  IF p_cmd ='u' AND g_oob[l_ac].oob22 > 0 THEN
     CALL cl_set_comp_entry("oob02,oob17,oob18,oob06,oob19,oob15,   #FUN-C90082 del oob04
                             oob11,oob13,oob14,oob07,oob08,oob12",FALSE)
     CALL cl_set_comp_entry("oob09,oob10",TRUE)
  END IF
  IF p_cmd ='a' THEN
    #CALL cl_set_comp_entry("oob17,oob18,oob06,oob19,oob15,              #MOD-B10135 mark
     CALL cl_set_comp_entry("oob17,oob18,oob19,oob15,                    #MOD-B10135
                             oob11,oob13,oob14,oob07,oob08,oob12",TRUE)
     CALL cl_set_comp_entry("oob09,oob10",TRUE)
  END IF
END FUNCTION
#No.FUN-960140--end-- add
 
#No.TQC-970273  --Begin
FUNCTION s_t300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oob TO s_oob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         EXIT DISPLAY
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.TQC-970273  --End  
#No.FUN-B10053  --Begin
FUNCTION s_t300_oob11(p_key,p_bookno)
    DEFINE p_key        LIKE aag_file.aag01
    DEFINE p_bookno     LIKE aag_file.aag00      
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti       LIKE aag_file.aagacti      
 
    LET g_errno = ' '
    SELECT aag02,aag07,aagacti
      INTO l_aag02,l_aag07,l_acti
      FROM aag_file WHERE aag01 = p_key
       AND aag00 = p_bookno
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
END FUNCTION
#No.FUN-B10053  --End
#FUN-C90082--add--str

FUNCTION t300_oob06(p_sw)            # 檢查待抵
  DEFINE p_sw             LIKE type_file.chr1                       # 2:取待抵 
  DEFINE l_oma            RECORD LIKE oma_file.*
  DEFINE l_omc            RECORD LIKE omc_file.*   
  DEFINE tot1,tot2,tot3   LIKE oob_file.oob09
  DEFINE l_oox10          LIKE oox_file.oox10
  DEFINE l_aag05          LIKE aag_file.aag05   
  DEFINE tot4,tot4t       LIKE type_file.num20_6     
  DEFINE l_bookno         LIKE aag_file.aag00   
  DEFINE l_ombcnt         LIKE type_file.num5  
  DEFINE l_chkcnt         LIKE type_file.num5  
 
  LET g_sql="SELECT oma_file.*,omc_file.* ",   
            "  FROM omc_file,oma_file  ",
            " WHERE oma01=omc01 AND omc01=? AND omc02=?" 
 	
  PREPARE t400_oob06_13_p1 FROM g_sql
  DECLARE t400_oob06_13_c1 CURSOR FOR t400_oob06_13_p1
  OPEN t400_oob06_13_c1 USING g_oob[l_ac].oob06,g_oob[l_ac].oob19
  FETCH t400_oob06_13_c1 INTO l_oma.*,l_omc.*  
  IF STATUS THEN CALL cl_err('sel omc',"aap-777",1) LET g_errno='N' END IF  
  IF l_oma.omavoid = 'Y' THEN
     CALL cl_err(l_oma.oma01,'axr-103',0) LET g_errno = 'N'
  END IF
  IF l_oma.omaconf='N' THEN   
     CALL cl_err('','axr-194',1) LET g_errno='N'
  END IF
  IF p_sw='2' AND l_oma.oma00[1,1]!='2' THEN
     CALL cl_err('','axr-186',1) LET g_errno='N' END IF
  
  IF l_oma.oma00='23' THEN
     LET l_ombcnt = 0
     SELECT COUNT(*) INTO l_ombcnt
       FROM oma_file,omb_file
      WHERE oma01 = omb01 
        AND oma19 = l_oma.oma01
     IF cl_null(l_ombcnt) THEN LET l_ombcnt = 0 END IF

     LET l_chkcnt = 0
     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_oma.oma66,'oeb_file'),",",
                 "   oma_file,omb_file ",
                 " WHERE oma01 = omb01 ",
                 "   AND oma19 = '",l_oma.oma01,"'",
                 "   AND omb31 = oeb01 ",
                 "   AND omb32 = oeb03 ",
                 "   AND oeb70 = 'Y' "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,l_oma.oma66) RETURNING g_sql
     PREPARE sel_oeb2 FROM g_sql
     EXECUTE sel_oeb2 INTO l_chkcnt 
     IF cl_null(l_chkcnt) THEN LET l_ombcnt = 0 END IF

     IF l_ombcnt <> l_chkcnt THEN
        CALL cl_err('','axr-188',1) 
        LET g_errno='N' 
     END IF
  END IF 

  IF l_oma.oma68 != g_ooa.ooa03 THEN
     CALL cl_err('','axr-140',1) 
     LET g_errno='N'
  END IF
  IF l_oma.oma69 != g_ooa.ooa032 THEN
     CALL cl_err('','axr-140',1) 
     LET g_errno='N'
  END IF
  IF l_oma.oma23!=g_ooa.ooa23 THEN
     CALL cl_err('','axr-144',1) LET g_errno='N' END IF
  IF l_oma.oma54t<=l_oma.oma55 THEN
     CALL cl_err('','axr-190',1) LET g_errno='N' END IF
 #原幣沖完但本幣未沖完
  IF l_oma.oma54t=l_oma.oma55 AND l_oma.oma56t!=l_oma.oma57 THEN
     CALL cl_err('','axr-193',1) LET g_errno='N' END IF
## 立帳日不可比沖款日小
  IF l_oma.oma02 > g_ooa.ooa02 THEN
     CALL cl_err('','axr-371',0) LET g_errno = 'N'
  END IF
  CALL s_get_bookno(YEAR(l_oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
  IF g_flag='1' THEN
     CALL cl_err(l_oma.oma02,'aoo-081',1)
  END IF
  LET g_oob[l_ac].oob07=l_oma.oma23
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob[l_ac].oob07 
  LET g_oob[l_ac].oob08=l_oma.oma24
## 不可沖超過
   LET tot1 = 0
   LET tot2 = 0
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file,ooa_file 
    WHERE oob06 = g_oob[l_ac].oob06
      AND oob01 = ooa01 AND ooaconf = 'N'
      AND oob19 = g_oob[l_ac].oob19   
      AND (oob01 <> g_ooa.ooa01 OR oob02 <> g_oob_t.oob02)      
      AND oob03 = g_oob[l_ac].oob03
      AND oob04 = g_oob[l_ac].oob04
   IF tot1 IS NULL THEN
      LET tot1 = 0
   END IF
   IF tot2 IS NULL THEN
      LET tot2 = 0
   END IF
   LET g_oob[l_ac].oob09 = l_omc.omc08  - l_omc.omc10 - tot1 
   LET g_oob[l_ac].oob10 = l_omc.omc09  - l_omc.omc11 - tot2 
   IF g_ooz.ooz07 = 'Y' THEN       
      LET g_oob[l_ac].oob08 = l_oma.oma60  
   ELSE                                       
      LET g_oob[l_ac].oob08 = l_oma.oma24       
   END IF                                   
   IF g_ooz.ooz07 = 'Y' AND g_oob[l_ac].oob07 != g_aza.aza17 THEN
      IF cl_null(g_oob[l_ac].oob08) OR g_oob[l_ac].oob08 = 0 THEN
         LET g_oob[l_ac].oob08 = l_oma.oma24
      END IF
     CALL s_g_np1('1',l_oma.oma00,g_oob[l_ac].oob06,g_oob[l_ac].oob15,g_oob[l_ac].oob19)     
           RETURNING tot3
      #取得衝帳單的待扺金額
      CALL t300_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
      CALL cl_digcut(tot4,t_azi04) RETURNING tot4              
      CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t    
      #未衝金額扣除待扺
      LET tot3 = tot3 - tot4t
      IF (tot1+g_oob[l_ac].oob09+l_omc.omc10) = l_omc.omc08  THEN  
         LET g_oob[l_ac].oob10 = tot3 - tot2
      END IF
   END IF
  CALL cl_digcut(g_oob[l_ac].oob09,t_azi04) RETURNING g_oob[l_ac].oob09     
  CALL cl_digcut(g_oob[l_ac].oob10,g_azi04) RETURNING g_oob[l_ac].oob10     
  LET g_oob[l_ac].oob11=l_oma.oma18
 #IF g_aza.aza63='Y' THEN                 
 #   LET g_oob[l_ac].oob111=l_oma.oma181  
 #END IF                                  
 LET l_aag05=''
  SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob[l_ac].oob11
                                            AND aag00=g_bookno1    
  IF l_aag05 = 'Y' THEN
     LET g_oob[l_ac].oob13=l_oma.oma15
  ELSE   
     LET g_oob[l_ac].oob13=''   
  END IF
  IF YEAR(g_ooa.ooa02) <> YEAR(l_oma.oma02) THEN
     CALL s_tag(YEAR(g_ooa.ooa02),g_bookno1,g_oob[l_ac].oob11)
          RETURNING l_bookno,g_oob[l_ac].oob11
  END IF
 #IF YEAR(g_ooa.ooa02) <> YEAR(l_oma.oma02) THEN
 #   CALL s_tag(YEAR(g_ooa.ooa02),g_bookno2,g_oob[l_ac].oob111)
 #        RETURNING l_bookno,g_oob[l_ac].oob111
 #END IF
 
  IF p_sw = '2' THEN
     LET g_oob[l_ac].oob14=l_oma.oma16
  END IF

END FUNCTION

FUNCTION t300_oob09_13(l_sw,l_cmd)  
   DEFINE l_sw           LIKE type_file.chr1        
   DEFINE l_cmd          LIKE type_file.chr1        
   DEFINE l_oma          RECORD LIKE oma_file.*
   DEFINE l_omc          RECORD LIKE omc_file.*
   DEFINE l_message      LIKE type_file.chr1000     
   DEFINE tot1,tot2,tot3 LIKE oob_file.oob09
   DEFINE tot5,tot6      LIKE oob_file.oob09    
   DEFINE tot7,tot8      LIKE oob_file.oob09   
   DEFINE l_oob09        LIKE oob_file.oob09
   DEFINE l_diff         LIKE oob_file.oob10
   DEFINE l_msg1,l_msg2  LIKE type_file.chr1000     
   DEFINE l_omb          RECORD LIKE omb_file.*     
 
   LET tot1 = 0
   LET tot2 = 0
 
   SELECT * INTO l_oma.* FROM oma_file
    WHERE oma01=g_oob[l_ac].oob06 AND omavoid='N'
   IF STATUS THEN
      LET l_oma.oma54t = 0
      LET l_oma.oma56t = 0
      LET l_oma.oma55  = 0
      LET l_oma.oma57  = 0
      LET l_oma.oma61  = 0    
   END IF
 
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file,ooa_file
    WHERE oob06 = g_oob[l_ac].oob06
      AND (oob01 <> g_ooa.ooa01 OR oob02 <> g_oob_t.oob02)      
      AND oob01 = ooa01 AND ooaconf = 'N'
      AND oob03 = g_oob[l_ac].oob03
      AND oob04 = g_oob[l_ac].oob04
   IF tot1 IS NULL THEN LET tot1=0 END IF  
   IF tot2 IS NULL THEN LET tot2=0 END IF   
 
   SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file,ooa_file
    WHERE oob06 = g_oob[l_ac].oob06 AND oob15 = g_oob[l_ac].oob15
      AND (oob01 <> g_ooa.ooa01 OR oob02 <> g_oob_t.oob02)     
      AND oob01 = ooa01 AND ooaconf = 'N'
      AND oob03 = g_oob[l_ac].oob03
      AND oob04 = g_oob[l_ac].oob04
   IF tot5 IS NULL THEN LET tot5=0 END IF
   IF tot6 IS NULL THEN LET tot6=0 END IF
 
   #待扺或貸方
   IF l_cmd = 'a' THEN 
      SELECT SUM(oob09),SUM(oob10) INTO tot7,tot8 FROM oob_file,ooa_file
    WHERE oob06 = g_oob[l_ac].oob06 AND oob19 = g_oob[l_ac].oob19
      AND oob01 = ooa01 AND ooaconf = 'N'
      AND oob03 = g_oob[l_ac].oob03
      AND oob04 = g_oob[l_ac].oob04
   ELSE
   SELECT SUM(oob09),SUM(oob10) INTO tot7,tot8 FROM oob_file,ooa_file
    WHERE oob06 = g_oob[l_ac].oob06 AND oob19 = g_oob[l_ac].oob19
      AND (oob01 <> g_ooa.ooa01 OR oob02 <> g_oob_t.oob02)     
      AND oob01 = ooa01 AND ooaconf = 'N'
      AND oob03 = g_oob[l_ac].oob03
      AND oob04 = g_oob[l_ac].oob04
   END IF 
   IF tot7 IS NULL THEN LET tot7=0 END IF
   IF tot8 IS NULL THEN LET tot8=0 END IF
 
   SELECT * INTO l_omc.* FROM omc_file
    WHERE omc01=g_oob[l_ac].oob06 AND omc02=g_oob[l_ac].oob19
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","omc_file",g_oob[l_ac].oob06,g_oob[l_ac].oob19,SQLCA.sqlcode,"","select omc_file",1)
   END IF

   IF tot1 IS NULL THEN LET tot1 = 0 END IF
   IF tot2 IS NULL THEN LET tot2 = 0 END IF
 
   IF l_sw = '1' THEN
      IF g_ooz.ooz62 = 'Y' THEN #衝帳至項次   

         SELECT * INTO l_omb.* FROM omb_file WHERE omb01 = l_oma.oma01 AND omb03 = g_oob[l_ac].oob15
         IF (tot5+g_oob[l_ac].oob09) > (l_omb.omb14t - l_omb.omb34) THEN
            CALL cl_err('','axr-185',1) RETURN FALSE
         END IF
         IF g_ooz.ooz07 = 'Y' AND g_oob[l_ac].oob07 != g_aza.aza17 THEN
            IF (tot5+g_oob[l_ac].oob09) = (l_omb.omb14t - l_omb.omb34) THEN
              IF g_ooz.ooz62 = 'Y' THEN
                 CALL s_g_np('1',l_oma.oma00,g_oob[l_ac].oob06,g_oob[l_ac].oob15)
                      RETURNING tot3                  
                 #判斷本幣金額是否超過
                 IF (tot6+g_oob[l_ac].oob09) > tot3 THEN   
                    CALL cl_err('','axr-189',1)   
                    LET g_oob[l_ac].oob10 = tot3 - tot2
                 END IF
              END IF
            END IF
         END IF
      ELSE    #不衝賬至項次
         IF (tot7+g_oob[l_ac].oob09) > (l_omc.omc08 - l_omc.omc10) THEN
            CALL cl_err('','axr-185',1) 
            LET g_oob[l_ac].oob09=g_oob_t.oob09
            DISPLAY g_oob[l_ac].oob09 TO oob09
            RETURN FALSE
         END IF
      END IF
   ELSE
      IF g_ooz.ooz07 = 'N' OR g_oob[l_ac].oob07 = g_aza.aza17 THEN
            IF (tot8+g_oob[l_ac].oob10) > (l_omc.omc09  - l_omc.omc11) THEN  
               CALL cl_err('','axr-185',1) 
               LET g_oob[l_ac].oob10=g_oob_t.oob10        
               DISPLAY g_oob[l_ac].oob10 TO oob10      
               RETURN FALSE
            END IF
           #原幣沖完但本幣未沖完
            IF (tot1+g_oob[l_ac].oob09) = (l_oma.oma54t-l_oma.oma55)   AND
               (tot8+g_oob[l_ac].oob10)!= (l_omc.omc09  - l_omc.omc11) THEN
               CALL cl_err('','axr-193',1)
               RETURN FALSE                    
            END IF
         #(怕因匯差問題)
         IF g_aza.aza17 != g_oob[l_ac].oob07 THEN
            LET l_diff= (l_omc.omc09  - l_omc.omc11)- (tot8+g_oob[l_ac].oob10)  
            IF l_diff <=3 AND l_diff >0 THEN
               CALL cl_getmsg('mfg-030',g_lang) RETURNING l_msg1
               CALL cl_getmsg('mfg-031',g_lang) RETURNING l_msg2
               LET g_msg=l_msg1 CLIPPED,l_omc.omc09  USING '#######&',  
                         " ",l_msg2 CLIPPED,
                        (l_omc.omc11+tot8+g_oob[l_ac].oob10) USING '#######&'  
               CALL cl_err(g_msg,'mfg-012',1)
               RETURN FALSE                    
            END IF
         END IF
      END IF
      #判斷本幣金額是否超過
      IF g_ooz.ooz07 = 'Y' THEN   #有做月底重評時, 需判斷不可超過未沖金額
            IF g_ooz.ooz62 ='Y' THEN
               CALL s_ar_oox03(l_oma.oma01) RETURNING g_net
            ELSE
               CALL s_ar_oox03_1(l_omc.omc01,l_omc.omc02) RETURNING g_net
            END IF
            IF cl_null(g_net) THEN LET g_net =0 END IF
            IF (tot8+g_oob[l_ac].oob10) > l_omc.omc13-g_net  THEN 
               CALL cl_err('','axr-185',1)
               LET g_oob[l_ac].oob10 = l_omc.omc13 - tot8 
               DISPLAY g_oob[l_ac].oob10 TO oob10         
               RETURN FALSE
            END IF
           #原幣沖完但本幣未沖完
            IF (tot1+g_oob[l_ac].oob09) = (l_oma.oma54t-l_oma.oma55)   AND
               (tot8+g_oob[l_ac].oob10)!= l_omc.omc13 THEN                    
               CALL cl_err('','axr-193',1)
               RETURN FALSE                   
            END IF
      END IF
   END IF
 
   RETURN TRUE
END FUNCTION
FUNCTION t300_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t
 
   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION
#FUN-C90082--add--end
