# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp400.4gl
# Descriptions...: 收款沖賬單整批產生作業
# Date & Author..: 05/07/08 By Nigel
# Modify.........: No.MOD-5B0015 05/11/02 By day  1.一進程序就判斷系統是否衝帳至項次
#                                                 2.INPUT時加入支票及T/T收款
# Modify.........: No.TQC-5B0147 05/11/21 By jackie 處理axrt400單身顯示項次問題
# Modify.........: No.MOD-640476 06/04/14 By Smapmin ooa_file單身合計金額有誤
# Modify.........: No.TQC-5C0086 06/05/08 By ice AR月底重評修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670026 06/07/26 By Tracy 應收銷退合并
# Modify.........: No.MOD-670136 06/07/31 By Smapmin 修改幣別取位問題
# Modify.........: No.FUN-670047 06/08/16 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680022 06/08/22 By cl  多帳期處理
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/27 By xumin l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-710050 07/01/22 By bnlent 錯誤信息匯整
# Modify.........: No.MOD-730022 07/03/07 By Smapmin 部門編號依據科目是否要做部門管理才產生
# Modify.........: No.FUN-740009 07/04/03 By Xufeng  會計科目加帳套
# Modify.........: No.FUN-740184 07/04/24 By Carrier 生成帳款時,根據收款日期,做新舊科目參照
# Modify.........: No.FUN-7A0055 07/11/14 By Carrier s_ar_oox03時加入分期項次
# Modify.........: No.FUN-7B0055 07/11/14 By Carrier CALL s_ar_oox時考慮多帳期
# Modify.........: No.TQC-7B0097 07/11/19 By Smapmin 未拋轉簽核欄位
# Modify.........: No.MOD-7B0262 07/12/03 By Smapmin 立帳日期不可大於沖帳日期
# Modify.........: No.MOD-830033 08/03/05 By Smapmin 收款沖帳匯率,若ooz07為'Y'應捉重評價匯率而非立帳時的匯率
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0044 09/11/06 By wujie   5.2SQL转标准语法
# Modify.........: No.FUN-9B0147 09/11/27 By lutingting INSERT INTO ooa_file时给ooa37默认值N
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No:TQC-9C0133 09/12/16 By Carrier oma38赋值
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXR
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-A90058 10/09/08 By Dido 自動產生axrt300待抵資料時,金額抓取方式應與單身輸入時一致.
# Modify.........: No:MOD-AB0154 10/11/16 By wujie ooa37赋值错误
# Modify.........: No:MOD-B40026 11/04/08 By Dido 若無 omc_file 資料時,會產生只有單頭的沖帳資料
# Modify.........: No:FUN-B80068 11/08/05 By yinhy 增加欄位"收款截止日期"
# Modify.........: No:MOD-B90061 11/09/07 By yinhy 抓取T/T資料時，應考慮項次和排除當前筆資料
# Modify.........: No:TQC-BB0053 11/11/07 By Carrier tm.pay_edate为空时,不做过滤条件
# Modify.........: No:MOD-C30847 12/04/10 By Polly 參考axrt400增加抓apc_file，將oob19=apc02並重新計算oob09/oob1
# Modify.........: No:TQC-D10098 13/01/28 By qirl 此程式不能正常運行

IMPORT os   #No.FUN-9C0009
DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
      tm       RECORD
               emp_no 	      LIKE gen_file.gen01,
               dept   	      LIKE gem_file.gem01,
               tr_type	      LIKE ooy_file.ooyslip,
               pay_date	      LIKE type_file.dat,          #No.FUN-680123 DATE,
               pay_edate      LIKE type_file.dat,          #No.FUN-B60068 DATE,
               chg            LIKE type_file.chr1,         #No.FUN-740184
               a              LIKE type_file.chr1,         #No.TQC-D10098
               b              LIKE type_file.chr1,         #No.TQC-D10098
               s2             LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(01),
               ap             LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(01),
               apa06          LIKE apa_file.apa06,
               apa07          LIKE apa_file.apa07
               END RECORD,
      g_oma           RECORD LIKE oma_file.*,
      g_apa           RECORD LIKE apa_file.*,
      g_ooa           RECORD LIKE ooa_file.*,
      g_oob           RECORD LIKE oob_file.*,
      g_aph           RECORD LIKE aph_file.*,
      g_discount      LIKE type_file.num20_6,              #No.FUN-680123 DEC(20,6),
      i,j             LIKE type_file.num10,                #No.FUN-680123 INTEGER,
      l_ac,l_sl       LIKE type_file.num10,                #No.FUN-680123 INTEGER,
      g_wc,g_sql      string,
      g_buf           LIKE type_file.chr20,               #No.FUN-680123 VARCHAR(20),
      g_sw            LIKE type_file.chr1,                #No.FUN-680123 VARCHAR(1),
      g_seq           LIKE type_file.num5,                #No.FUN-680123 SMALLINT,
      plant           ARRAY[5] OF LIKE azp_file.azp01,    #No.FUN-680123 VARCHAR(10),
      ooa14           LIKE ooa_file.ooa14,
      bank_actno      LIKE aab_file.aab01,                #No.FUN-680123 VARCHAR(24),
      g_arr  	DYNAMIC ARRAY OF RECORD
                    duedate		LIKE type_file.dat,          #No.FUN-680123 DATE,
                    amountf		LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6),
                    amount		LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)
                    END RECORD,
      oma64_t 	LIKE type_file.dat,                   #No.FUN-680123 DATE,
      g_start_no,g_end_no  LIKE ooa_file.ooa01,       #No.FUN-680123 VARCHAR(16),
      g_dbs_cnt LIKE type_file.num5,                  #No.FUN-680123 SMALLINT,
      tot3      LIKE type_file.num20_6                #No.FUN-680123 DEC(20,6)

DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE   g_aag05          LIKE aag_file.aag05    #MOD-730022
DEFINE   g_i             LIKE type_file.num5         #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(72)
DEFINE g_before_input_done   STRING
DEFINE   g_net            LIKE oox_file.oox10        #No.TQC-5C0086
#No.FUN-740009  --begin
DEFINE   g_bookno1        LIKE aza_file.aza81
DEFINE   g_bookno2        LIKE aza_file.aza82
DEFINE   g_flag           LIKE type_file.chr1
#No.FUN-740009  --end

MAIN
#   DEFINE l_time      LIKE type_file.chr8         #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
   DEFINE p_row,p_col LIKE type_file.num5         #No.FUN-680123 SMALLINT
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF


   OPEN WINDOW p400_w AT p_row,p_col WITH FORM "axr/42f/axrp400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()


     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   CALL cl_opmsg('z')
   LET g_dbs_cnt = 5
 # SELECT azi04 INTO g_azi04 FROM azi_file
 #  WHERE azi01=g_aza.aza17                     #No.CHI-6A0004

#No.MOD-5B0015-begin
    IF g_ooz.ooz62='Y' THEN
     CALL cl_err('ooz62','axr-000',1)
     RETURN
    END IF
#No.MOD-5B0015-end

   CALL p400()
   CLOSE WINDOW p400_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
END MAIN

FUNCTION p400()
   DEFINE   l_flag     LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1),
            l_n        LIKE type_file.chr3          #No.FUN-680123 VARCHAR(3)
   DEFINE l_pma11      LIKE pma_file.pma11
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_name       LIKE type_file.chr20         #No.FUN-680123 VARCHAR(20)
   DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(30)
   DEFINE l_aba19      LIKE aba_file.aba19
   DEFINE l_ooytype    LIKE ooy_file.ooytype
   DEFINE g_t1         LIKE ooy_file.ooyslip        #No.FUN-680123 VARCHAR(05)
   DEFINE l_i          LIKE type_file.num10         #No.FUN-680123 INTEGER
   DEFINE l_gen02      LIKE gen_file.gen02
   DEFINE l_genacti    LIKE gen_file.genacti
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE l_gemacti    LIKE gem_file.gemacti
   DEFINE li_result    LIKE type_file.num5          #No.FUN-680123 SMALLINT

WHILE TRUE
   LET g_action_choice = ""

   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON oma11,oma32,oma01,oma02,oma14,oma00,
                             oma03,oma032,oma68,oma69,oma23,oma13  #No.FUN-670026 add oma68,oma69

         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

     ON ACTION locale
        LET g_action_choice='locale'
        EXIT CONSTRUCT
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()

         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup') #FUN-980030

   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF


   IF INT_FLAG THEN
      RETURN
   END IF

   LET tm.pay_date = g_today
   LET tm.a  = 'Y'   #No.MOD-5B0015
   LET tm.b  = 'N'   #No.MOD-5B0015
   LET tm.s2 = 'N'   #No.MOD-5B0015
   LET tm.ap = 'N'
   LET tm.apa06 = NULL
   LET tm.apa07 = NULL
   LET tm.chg   = 'N'  #No.FUN-740148
   LET tm.pay_edate = NULL  #No.FUN-B80068

   INPUT BY NAME tm.emp_no,tm.dept,tm.tr_type,
                 tm.pay_date,tm.pay_edate,tm.chg,tm.a,tm.b,tm.s2,tm.ap,tm.apa06,tm.apa07  #No.MOD-5B0015  #No.TQC-740184 #No.FUN-B80068 add pay_edate
                 WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p400_set_entry()
          CALL p400_set_no_entry()
          LET g_before_input_done = TRUE


      AFTER FIELD emp_no
         IF NOT cl_null(tm.emp_no) THEN
            SELECT gen02,gen03,genacti INTO l_gen02,tm.dept,l_genacti
            FROM gen_file WHERE gen01 = tm.emp_no
	    IF SQLCA.SQLCODE = 100  THEN
#              CALL cl_err('','mfg3096',1)   #No.FUN-660116
               CALL cl_err3("sel","gen_file",tm.emp_no,"","mfg3096","","",1)   #No.FUN-660116
               NEXT FIELD emp_no
            END IF
            IF l_genacti='N' THEN
               CALL cl_err('','9028',1)
               NEXT FIELD emp_no
            END IF
            DISPLAY l_gen02 TO FORMONLY.gen02
            DISPLAY BY NAME tm.dept
         END IF

      AFTER FIELD dept
         IF NOT cl_null(tm.dept) THEN
            SELECT gem02,gemacti INTO l_gem02,l_gemacti
              FROM gem_file WHERE gem01=tm.dept
            IF STATUS = 100 THEN
#              CALL cl_err('','mfg3097',1)   #No.FUN-660116
               CALL cl_err3("sel","gem_file",tm.dept,"","mfg3097","","",1)   #No.FUN-660116
               NEXT FIELD dept
            END IF
            IF l_gemacti='N' THEN
               CALL cl_err('','9028',1)
               NEXT FIELD dept
            END IF
            DISPLAY l_gem02 TO FORMONLY.gem02
         END IF

      AFTER FIELD tr_type
         IF NOT cl_null(tm.tr_type) THEN
#           CALL s_check_no(g_sys,tm.tr_type,'','30','ooy_file','ooyslip','')
            CALL s_check_no("axr",tm.tr_type,'','30','ooy_file','ooyslip','')   #No.FUN-A40041
            RETURNING li_result,tm.tr_type
            LET tm.tr_type=tm.tr_type[1,g_doc_len]
	    DISPLAY BY NAME tm.tr_type
            IF (NOT li_result) THEN
                CALL cl_err(tm.tr_type,g_errno,0)
   	        NEXT FIELD tr_type
            END IF
        END IF

     BEFORE FIELD ap
         CALL p400_set_entry()

     AFTER FIELD ap
         CALL p400_set_no_entry()

     BEFORE FIELD apa06
         CALL p400_set_entry()

     AFTER FIELD apa06
       IF NOT cl_null(tm.apa06) THEN
          IF tm.apa06 != 'MISC' THEN
             SELECT pmc03 INTO tm.apa07 FROM pmc_file WHERE pmc01=tm.apa06
          ELSE
             LET tm.apa07='MISC'
          END IF
          DISPLAY BY NAME tm.apa07
          SELECT COUNT(*) INTO l_n  FROM apa_file WHERE apa06=tm.apa06
          IF l_n = 0 THEN
             CALL cl_err('','aap-000',1)
             NEXT FIELD apa06
          END IF
       END IF
       CALL p400_set_no_entry()

     AFTER INPUT
       IF tm.ap = 'Y' AND cl_null(tm.apa06) THEN
          NEXT FIELD apa06
       END IF

    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(tr_type) #查詢單據
            #CALL q_ooy(FALSE, TRUE, g_ooa.ooa01,'30',g_sys)  #TQC-670008
            CALL q_ooy(FALSE, TRUE, g_ooa.ooa01,'30','AXR')   #TQC-670008
                RETURNING g_t1
            LET tm.tr_type = g_t1
            DISPLAY BY NAME tm.tr_type
            NEXT FIELD tr_type
          WHEN INFIELD(dept)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gem"
             LET g_qryparam.default1 = tm.dept
             CALL cl_create_qry() RETURNING tm.dept
             DISPLAY BY NAME tm.dept
             NEXT FIELD dept
          WHEN INFIELD(emp_no)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gen"
             LET g_qryparam.default1 = tm.emp_no
             CALL cl_create_qry() RETURNING tm.emp_no
             DISPLAY BY NAME tm.emp_no
             NEXT FIELD emp_no
          WHEN INFIELD(apa06)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_v_apa"
             LET g_qryparam.default1 = tm.apa06
             CALL cl_create_qry() RETURNING tm.apa06,tm.apa07
             DISPLAY BY NAME tm.apa06,tm.apa07
             NEXT FIELD apa06
       OTHERWISE EXIT CASE
       END CASE

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION locale
          LET g_action_choice='locale'
          EXIT INPUT
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION about
          CALL cl_about()
       ON ACTION help
          CALL cl_show_help()


         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

   END INPUT

   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
   LET l_i=0
   IF tm.ap='Y' THEN
      LET g_sql= " SELECT COUNT (*) FROM ",
                 " (SELECT oma03,oma032 ",
                #"  FROM oma_file",              #MOD-B40026 mark
                 "  FROM oma_file,omc_file ",    #MOD-B40026
                 "  WHERE ",g_wc CLIPPED,
                 "  AND oma01 = omc01 ",         #MOD-B40026
                 "  AND oma00 IN ('11','12','13','14') ",
                 "  AND oma54t>oma55 ",
                 "  AND omaconf='Y' AND omavoid='N'",
                 "  AND oma02 <= '",tm.pay_date,"'",    #MOD-7B0262
              #  "  AND oma02 <= '",tm.pay_edate,"'",   #FUN-B80068  #No.TQC-BB0053 mark
                 "  GROUP BY oma03,oma032)"
      PREPARE p400_pre FROM g_sql
      DECLARE p400_count CURSOR FOR p400_pre
      OPEN p400_count
      FETCH p400_count INTO l_i
      CLOSE p400_count
   END IF
   IF l_i >1 THEN
      CALL cl_err('ap','axr-936',1)
      RETURN
   END IF

   IF cl_sure(0,0) THEN
      LET g_success = 'Y'
      BEGIN WORK
      CALL p110_process()
      CALL s_showmsg()     #No.FUN-710050
      IF g_success = 'Y' THEN
         COMMIT WORK
         OPEN WINDOW p400_w2 AT 10,16 WITH FORM "axr/42f/axrp400_2"
                                 ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

         CALL cl_ui_locale("axrp400_2")
         DISPLAY BY NAME g_cnt,g_start_no,g_end_no
         CALL cl_end2(1) RETURNING l_flag
         CLOSE WINDOW p400_w2
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
END WHILE
END FUNCTION

FUNCTION p110_process()
   DEFINE   l_oob09    LIKE oob_file.oob09
   DEFINE   l_oob10    LIKE oob_file.oob10
   DEFINE   l_name     LIKE type_file.chr20    #No.FUN-680123 VARCHAR(20)
   DEFINE   l_cmd      LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(30)
   DEFINE   l_aba19    LIKE aba_file.aba19


   LET g_cnt = 0
   CALL cl_outnam('axrp400') RETURNING l_name
   START REPORT axrp400_rep TO l_name

   LET g_sql= "SELECT oma_file.* ",
             #"  FROM oma_file",              #MOD-B40026 mark
              "  FROM oma_file,omc_file ",    #MOD-B40026
              "  WHERE ",g_wc CLIPPED,
              "  AND oma01 = omc01 ",         #MOD-B40026
              "  AND oma00 IN ('11','12','13','14') ",
              "  AND oma54t>oma55 ",  #No.FUN-680022 mark
              "  AND omaconf='Y' AND omavoid='N'",
              "  AND oma02 <= '",tm.pay_date,"'"    #MOD-7B0262
#             "  AND oma02 <= '",tm.pay_edate,"'"   #FUN-B80068  #No.TQC-BB0053  mark

   PREPARE p400_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('p400_pre',STATUS,0) LET g_success = 'N' RETURN
   END IF
   DECLARE p400_cs CURSOR FOR p400_prepare
   CALL s_showmsg_init()   #No.FUN-710050
   FOREACH p400_cs INTO g_oma.*
      IF STATUS THEN
      #No.FUN-710050--Begin--
      #  CALL cl_err('p400_pre',STATUS,0) LET g_success = 'N' RETURN
         CALL s_errmsg('','','p400_pre',STATUS,1) LET g_success = 'N' RETURN
      #No.FUN-710050--End--
      END IF
      #No.FUN-710050--Begin--
       IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success="Y"
       END IF
      #No.FUN-710050--End-


      #判斷是否已有收款沖款單,且未確認
      SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10
        FROM oob_file,ooa_file
       WHERE  oob06 = g_oma.oma01 AND ooaconf='N' AND ooa01=oob01
       # AND  oob19 = l_omc.omc02   #No.FUN-680022 add
      IF l_oob09 IS NULL THEN
         LET l_oob09 = 0
      END IF
      IF l_oob10 IS NULL THEN
         LET l_oob10  = 0
      END IF
      IF (g_oma.oma54t-g_oma.oma55)-l_oob09<=0 THEN
          CONTINUE FOREACH
      END IF
      #------------------------------------------------------
      IF g_oma.oma12 IS NULL THEN
         LET g_oma.oma12 = 0
      END IF
      #No.FUN-740184  --Begin
      #No.FUN-740009  --begin
      #CALL s_get_bookno(YEAR(tm.pay_date)) RETURNING g_flag, g_bookno1,g_bookno2
      #IF g_flag='1' THEN
      #   CALL cl_err(tm.pay_date,'aoo-081',1)
      #   LET  g_success= 'N'
      #END IF
      #No.FUN-740009  --end
      #No.FUN-740184  --End
      OUTPUT TO REPORT axrp400_rep(g_oma.*)
   END FOREACH
   #No.FUN-710050--Begin--
          IF g_totsuccess="N" THEN
              LET g_success="N"
          END IF
   #No.FUN-710050--End--

   FINISH REPORT axrp400_rep
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009

END FUNCTION

REPORT axrp400_rep(l_oma)
   DEFINE l_oma       RECORD LIKE oma_file.*
   DEFINE l_omc02            LIKE omc_file.omc02
   DEFINE oma12_t            LIKE oma_file.oma12

   #order by 廠商/簡稱/幣別/ 票據到期日/帳款
   ORDER BY l_oma.oma68,l_oma.oma69,             #No.FUN-670026
            l_oma.oma03,l_oma.oma032,l_oma.oma23,
            l_oma.oma12,l_oma.oma01

   FORMAT
#     BEFORE GROUP OF l_oma.oma032   #幣別       #No.FUN-670026 mark
      BEFORE GROUP OF l_oma.oma69    #幣別       #No.FUN-670026
         LET i = 0
         LET oma12_t = '010101'
         LET g_oma.* = l_oma.*
         CALL p400_ins_ooa()         	# Add 收款單頭

      ON EVERY ROW
         IF g_success = 'Y' THEN
            LET g_oma.* = l_oma.*
            CALL p400_ins_oob_1()	# Add 收款單貸方單身
         END IF

#     AFTER GROUP OF l_oma.oma032                #No.FUN-670026 mark
      AFTER GROUP OF l_oma.oma69                 #No.FUN-670026
         IF g_success = 'Y' THEN
            CALL p400_ins_oob_2()	# Add 付款單方借單身
         END IF
         IF g_success = 'Y' THEN
            CALL p400_upd_ooa()	# Add 付款單頭更新
         END IF

      IF g_start_no IS NULL THEN LET g_start_no = g_ooa.ooa01 END IF
      LET g_end_no = g_ooa.ooa01
      CALL update_oob02()       #No.TQC-5B0147
      LET g_cnt    = g_cnt + 1
END REPORT

FUNCTION p400_ins_ooa()
    DEFINE li_result  LIKE type_file.num5         #No.FUN-680123 SMALLINT
    DEFINE g_t1       LIKE ooy_file.ooyslip    #TQC-7B0097

    INITIALIZE g_ooa.* TO NULL
#   CALL s_auto_assign_no(g_sys,tm.tr_type,tm.pay_date,'30',"ooy_file","ooyslip",'','','')
    CALL s_auto_assign_no("axr",tm.tr_type,tm.pay_date,'30',"ooy_file","ooyslip",'','','')   #No.FUN-A40041
    RETURNING li_result,g_ooa.ooa01
    IF (NOT li_result) THEN
        LET g_success = 'N'
        RETURN
    END IF
    LET g_ooa.ooa00 ='1'
    LET g_ooa.ooa02 = tm.pay_date
#   LET g_ooa.ooa03 = g_oma.oma03                #No.FUN-670026
#   LET g_ooa.ooa032= g_oma.oma032               #No.FUN-670026
    LET g_ooa.ooa03 = g_oma.oma68                #No.FUN-670026
    LET g_ooa.ooa032= g_oma.oma69                #No.FUN-670026
    LET g_ooa.ooa13 = g_oma.oma13
    LET g_ooa.ooa14 = tm.emp_no
    LET g_ooa.ooa15 = tm.dept
    LET g_ooa.ooa23 = g_oma.oma23
    LET g_ooa.ooa31d=0
    LET g_ooa.ooa31c=0
    LET g_ooa.ooa32d=0
    LET g_ooa.ooa32c=0
    CALL s_curr3(g_ooa.ooa23,g_ooa.ooa02,'S') RETURNING g_ooa.ooa24
    IF g_ooa.ooa24 = 0 THEN LET g_ooa.ooa24 = 1 END IF
    LET g_ooa.ooaconf = 'N'
    LET g_ooa.ooa34 = '0'       #No.TQC-9C0057
    LET g_ooa.ooauser=g_user
    LET g_ooa.ooagrup=g_grup
    LET g_ooa.ooadate=g_today
    LET g_ooa.ooalegal = g_legal #FUN-980011 add

    LET g_oob.oob02 = 20
    LET g_discount=0
    #-----TQC-7B0097---------
    LET g_t1 = g_ooa.ooa01[1,g_doc_len]
    SELECT ooyapr INTO g_ooa.ooamksg FROM ooy_file
      WHERE ooyslip = g_t1
    #-----END TQC-7B0097-----
#   LET g_ooa.ooa37 = 'N'    #FUN-9B0147
    LET g_ooa.ooa37 = '1'    #FUN-9B0147   No.MOD-AB0154
    LET g_ooa.ooa38 = '2'    #手工  #No.TQC-9C0133
    LET g_ooa.ooaoriu = g_user      #No.FUN-980030 10/01/04
    LET g_ooa.ooaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO ooa_file VALUES(g_ooa.*)
   #DISPLAY "add ooa(",SQLCA.sqlcode,"):",g_ooa.ooa01,' ',g_ooa.ooa02,' ', #CHI-A70049 mark
                      #g_ooa.ooa03,' ',g_ooa.ooa032 AT 1,1                 #CHI-A70049 mark
    IF SQLCA.sqlcode THEN
#      CALL cl_err('p400_ins_ooa(ckp#1):',SQLCA.sqlcode,1)   #No.FUN-660116
       CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","p400_ins_ooa(ckp#1):",1)   #No.FUN-660116
       LET g_success = 'N'
    END IF
END FUNCTION

FUNCTION p400_ins_oob_1()  #貸方項次
    DEFINE l_pma04         LIKE ecb_file.ecb18     #No.FUN-680123 DECIMAL(5,2)
    DEFINE l_omc           RECORD LIKE omc_file.*  #No.FUN-680022 add
    DEFINE l_bookno        LIKE aag_file.aag00     #No.FUN-740184

   #No.FUN-680022--begin-- add
    DECLARE p400_oob_cs1 CURSOR  FOR
      SELECT * FROM omc_file WHERE omc01=g_oma.oma01
    FOREACH p400_oob_cs1 INTO l_omc.*
       IF STATUS THEN
       #No.FUN-710050--Begin--
       #  CALL cl_err('',STATUS,1)
          CALL s_errmsg('omc01','g_oma.oma01','',STATUS,0)
       #No.FUN-710050--End--
          EXIT FOREACH
       END IF
       #原先程序--begin--
      #LET g_oob.oob09=g_oma.oma54t-g_oma.oma55    #No.FUN-680022 --mark
      #LET g_oob.oob10=g_oma.oma56t-g_oma.oma57    #No.FUN-680022 --mark
       LET g_oob.oob09=l_omc.omc08-l_omc.omc10     #No.FUN-680022 add
       LET g_oob.oob10=l_omc.omc13                 #No.FUN-680022 add
      #No.FUN-680022--begin-- mark
      ##No.TQC-5C0086  --Begin
      #CALL s_ar_oox03(g_oma.oma01) RETURNING g_net
      #LET g_oob.oob10=g_oob.oob10 + g_net
      ##No.TQC-5C0086  --End
      #No.FUN-680022--end-- mark
       IF cl_null(g_oob.oob09) THEN LET g_oob.oob09=0 END IF
       IF cl_null(g_oob.oob10) THEN LET g_oob.oob10=0 END IF

      #IF g_oob.oob09 <= 0 AND g_oob.oob09 <= 0 THEN RETURN END IF  #No.FUN-680022 mark
      #No.FUN-680022--begin-- add
       IF g_oob.oob09 <= 0 AND g_oob.oob09 <= 0 THEN
          CONTINUE FOREACH
       END IF
      #No.FUN-680022--end-- add
       LET g_oob.oob01 = g_ooa.ooa01       #No.FUN-680022 mark
       LET g_oob.oob02 = g_oob.oob02 + 1
       LET g_oob.oob03 = '2'
       LET g_oob.oob04 = '1'
       LET g_oob.oob06 = g_oma.oma01
       LET g_oob.oob19 = l_omc.omc02        #No.FUN-680022 add
       LET g_oob.oob07 = g_oma.oma23
       #-----MOD-830033---------
       #LET g_oob.oob08 = g_oma.oma24
       IF g_ooz.ooz07 = 'Y' AND g_oob.oob07 != g_aza.aza17 THEN
          LET g_oob.oob08 = g_oma.oma60
          IF cl_null(g_oob.oob08) OR g_oob.oob08 = 0 THEN
             LET g_oob.oob08 = g_oma.oma24
          END IF
       ELSE
          LET g_oob.oob08 = g_oma.oma24
       END IF
       #-----END MOD-830033-----
       LET g_oob.oob11 = g_oma.oma18
       #No.FUN-670047 --begin
       IF g_aza.aza63 = 'Y' THEN
          LET g_oob.oob111 = g_oma.oma181
       END IF
       #No.FUN-670047 --end
       #-----MOD-730022---------
       #LET g_oob.oob13 = g_oma.oma15
       #No.FUN-740184  --Begin
       CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING g_flag, g_bookno1,g_bookno2
       IF g_flag='1' THEN
          CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
          LET  g_success= 'N'
       END IF
       #No.FUN-740184  --End
       LET g_aag05 = ''
      #SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag01=g_oob.oob11  #No.FUN-740009
       SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag00=g_bookno1 AND aag01=g_oob.oob11  #No.FUN-740009
       IF g_aag05 = 'Y' THEN
          LET g_oob.oob13 = g_oma.oma15
       ELSE
          LET g_oob.oob13 = ''
       END IF
       #-----END MOD-730022-----
       LET g_oob.oob14 = ''
       LET g_oob.oob15 = ''
       #No.FUN-740184  --Begin
       IF tm.chg = 'Y' AND YEAR(tm.pay_date) <> YEAR(g_oma.oma02) THEN
          CALL s_tag(YEAR(tm.pay_date),g_bookno1,g_oob.oob11)
               RETURNING l_bookno,g_oob.oob11
          CALL s_tag(YEAR(tm.pay_date),g_bookno2,g_oob.oob111)
               RETURNING l_bookno,g_oob.oob111
       END IF
       #No.MOD-740184  --End

       LET g_oob.ooblegal = g_legal #FUN-980011 add

       INSERT INTO oob_file VALUES(g_oob.*)
      #DISPLAY "add oob(",SQLCA.sqlcode,"):",g_oob.oob01,' ',g_oob.oob02,' ', #CHI-A70049 mark
                         #g_oob.oob03,' ',g_oob.oob04,' ',g_oob.oob06 AT 2,1  #CHI-A70049 mark
       IF SQLCA.sqlcode THEN
#         CALL cl_err('p400_ins_oob(ckp#1):',SQLCA.sqlcode,1)   #No.FUN-660116
       #No.FUN-710050--Begin--
       #  CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","p400_ins_oob(ckp#1):",1)   #No.FUN-660116
          CALL s_errmsg('','','p400_ins_oob(ckp#1):',SQLCA.sqlcode,1)
          LET g_success = 'N'
       #  RETURN
          EXIT FOREACH
       #No.FUN-710050--End--
       END IF
       LET g_ooa.ooa31c= g_ooa.ooa31c + g_oob.oob09
       LET g_ooa.ooa32c= g_ooa.ooa32c + g_oob.oob10
       #原先程序--end--
    END FOREACH
   #No.FUN-680022--end-- add
END FUNCTION

FUNCTION p400_ins_oob_2() #借方項次
    DEFINE l_nmh            RECORD LIKE nmh_file.*
    DEFINE l_nmg            RECORD LIKE nmg_file.*
    DEFINE l_npk            RECORD LIKE npk_file.*
    DEFINE l_oma            RECORD LIKE oma_file.*
    DEFINE l_apa            RECORD LIKE apa_file.*
    DEFINE l_omc            RECORD LIKE omc_file.*     #No.FUN-680022 add
    DEFINE l_oob09       LIKE oob_file.oob09
    DEFINE l_oob10       LIKE oob_file.oob10
    DEFINE l_ooydmy1     LIKE ooy_file.ooydmy1
    DEFINE g_t1          LIKE ooy_file.ooyslip          #No.FUN-680123 VARCHAR(05)
    DEFINE l_ool RECORD  LIKE ool_file.*,
           l_sql         LIKE type_file.chr1000         #No.FUN-680123 VARCHAR(300)
    DEFINE l_apz27       LIKE apz_file.apz27
    DEFINE l_nmz20       LIKE nmz_file.nmz20
    DEFINE l_nmz59       LIKE nmz_file.nmz59
    DEFINE ls_tmp        STRING
    DEFINE l_bookno      LIKE aag_file.aag00     #No.FUN-740184
    DEFINE l_apc         RECORD LIKE apc_file.*          #MOD-C30847 add
    DEFINE p05f          LIKE apg_file.apg05f            #MOD-C30847 add
    DEFINE p05           LIKE apg_file.apg05             #MOD-C30847 add

   SELECT ool_file.* INTO l_ool.* FROM ool_file WHERE ool01=g_ooa.ooa13
   INITIALIZE g_oob.* TO NULL
   LET g_oob.oob01=g_ooa.ooa01
   LET g_oob.oob02=0

#No.MOD-5B0015-begin
   IF tm.a='Y' THEN
      LET ls_tmp = " SELECT * FROM nmh_file,nmy_file ",
                    " WHERE nmh11 = '",g_ooa.ooa03,"' ",
                      " AND nmh30 = '",g_ooa.ooa032,"' ",
                      " AND nmh17 < nmh02 ",
                      " AND nmh38 = 'Y' ",
#                     " AND nmh04 <= '",tm.pay_edate,"' ",         #FUN-B80068  #No.TQC-BB0053
#                     " AND SUBSTRING(nmh01,1,g_doc_len) = nmyslip "
                      " AND nmh01[1,",g_doc_len,"] = nmyslip ",     #No.FUN-9B0044
                      " AND nmydmy3 = 'N' "
      #No.TQC-BB0053  --Begin
      IF NOT cl_null(tm.pay_edate) THEN
         LET ls_tmp = ls_tmp CLIPPED," AND nmh04 <= '",tm.pay_edate,"' "
      END IF
      #No.TQC-BB0053  --End
      DECLARE t400_g_b_c11 CURSOR FROM ls_tmp

      FOREACH t400_g_b_c11 INTO l_nmh.*
        IF STATUS THEN
           EXIT FOREACH
        END IF

        IF g_ooa.ooa23 IS NOT NULL AND l_nmh.nmh03 != g_ooa.ooa23 THEN
           CONTINUE FOREACH
        END IF

        #若此收票單號未確認,則不可產生於沖帳單身
        IF l_nmh.nmh38 != 'Y' THEN CONTINUE FOREACH END IF
        #須考慮未確認沖帳資料
        SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file,ooa_file
         WHERE oob06 = l_nmh.nmh01 AND oob01 = ooa01 AND ooaconf = 'N'

        IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
        IF cl_null(l_oob10) THEN LET l_oob10=0 END IF

        LET g_oob.oob02=g_oob.oob02+1
        LET g_oob.oob03='1' LET g_oob.oob04='1'
        LET g_oob.oob06=l_nmh.nmh01
        LET g_oob.oob14=l_nmh.nmh31
        LET g_oob.oob07=l_nmh.nmh03 LET g_oob.oob08=l_nmh.nmh32/l_nmh.nmh02
        #SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_oob.oob07    #MOD-670136
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07    #MOD-670136
        LET g_oob.oob09=l_nmh.nmh02-l_nmh.nmh17-l_oob09   #原幣入帳金額
        LET g_oob.oob10=g_oob.oob09*g_oob.oob08
       #金額算法(原幣)=票面金額-已沖金額
       #當原幣金額=票面金額
        IF g_oob.oob09 = l_nmh.nmh02 THEN
           LET g_oob.oob10 = l_nmh.nmh32
        ELSE
           LET g_oob.oob10=g_oob.oob09*g_oob.oob08
        END IF
        SELECT nmz59 INTO l_nmz59 FROM nmz_file WHERE nmz00 = '0'
        IF l_nmz59 = 'Y' AND g_oob.oob07 != g_aza.aza17 THEN
           LET g_oob.oob08 = l_nmh.nmh39
           IF cl_null(g_oob.oob08) OR g_oob.oob08 = 0 THEN
              LET g_oob.oob08 = l_nmh.nmh28
           END IF
           CALL s_g_np('4','1',g_oob.oob06,g_oob.oob15) RETURNING tot3
           IF (g_oob.oob09+l_nmh.nmh17+l_oob09) = l_nmh.nmh02 THEN
              LET g_oob.oob10 = tot3 - l_oob10
           END IF
        END IF

        #CALL cl_digcut(g_oob.oob09,g_azi04) RETURNING g_oob.oob09   #MOD-670136
        #CALL cl_digcut(g_oob.oob10,t_azi04) RETURNING g_oob.oob10   #MOD-670136
        CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09   #MOD-670136
        CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10   #MOD-670136
       #金額算法(本幣)=原幣金額*匯率
        LET g_oob.oob11=l_nmh.nmh26
        #No.FUN-670047 --begin
        IF g_aza.aza63 = 'Y' THEN
           LET g_oob.oob111=l_nmh.nmh261
        END IF
        #No.FUN-670047 --end
        #-----MOD-730022---------
        #LET g_oob.oob13=l_nmh.nmh15
        #No.FUN-740184  --Begin
        CALL s_get_bookno(YEAR(l_nmh.nmh04)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag='1' THEN
           CALL s_errmsg('nmh04',l_nmh.nmh04,'','aoo-081',1)
           LET  g_success= 'N'
        END IF
        #No.FUN-740184  --End
        LET g_aag05 = ''
       #SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag01=g_oob.oob11  #No.FUN-740009
        SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag00=g_bookno1 AND aag01=g_oob.oob11  #No.FUN-740009  #No.FUN-740184
        IF g_aag05 = 'Y' THEN
           LET g_oob.oob13 = l_nmh.nmh15
        ELSE
           LET g_oob.oob13 = ''
        END IF
        #-----END MOD-730022-----
        #No.FUN-740184  --Begin
        IF tm.chg = 'Y' AND YEAR(tm.pay_date) <> YEAR(l_nmh.nmh04) THEN
           CALL s_tag(YEAR(tm.pay_date),g_bookno1,g_oob.oob11)
                RETURNING l_bookno,g_oob.oob11
           CALL s_tag(YEAR(tm.pay_date),g_bookno2,g_oob.oob111)
                RETURNING l_bookno,g_oob.oob111
        END IF
        #No.MOD-740184  --End

        LET g_oob.ooblegal = g_legal #FUN-980011 add

        INSERT INTO oob_file VALUES (g_oob.*)
        LET g_ooa.ooa31d=g_ooa.ooa31d+g_oob.oob09   #MOD-640476
        LET g_ooa.ooa32d=g_ooa.ooa32d+g_oob.oob10   #MOD-640476
      END FOREACH
   END IF
   IF tm.b='Y' THEN
      #No.TQC-BB0053  --Begin
      #DECLARE t400_g_b_c12 CURSOR FOR
      # SELECT nmg_file.*,npk_file.* FROM nmg_file,npk_file
      #  WHERE nmg00=npk00 AND nmg18=g_ooa.ooa03 AND nmg19=g_ooa.ooa032
      #    AND (nmg20='21' OR nmg20='22') AND npk04 IS NOT NULL
      #    AND (nmg23-nmg24>0) AND nmgconf='Y'
      #    AND nmg01 <= tm.pay_edate          #No.FUN-B80068
      LET g_sql = " SELECT nmg_file.*,npk_file.* FROM nmg_file,npk_file ",
                  "  WHERE nmg00=npk00 AND nmg18='",g_ooa.ooa03,"'",
                  "    AND nmg19='",g_ooa.ooa032,"'",
                  "    AND (nmg20='21' OR nmg20='22') AND npk04 IS NOT NULL ",
                  "    AND (nmg23-nmg24>0) AND nmgconf='Y'"
      IF NOT cl_null(tm.pay_edate) THEN
         LET g_sql = g_sql CLIPPED," AND nmg01 <= '",tm.pay_edate,"'"
      END IF
      PREPARE p400_p1 FROM g_sql
      IF STATUS THEN
         CALL cl_err('p400_p1',STATUS,0) LET g_success = 'N' RETURN
      END IF
      DECLARE t400_g_b_c12 CURSOR FOR p400_p1
      #No.TQC-BB0053  --End
      FOREACH t400_g_b_c12 INTO l_nmg.*,l_npk.*
        IF STATUS THEN EXIT FOREACH END IF
        IF g_ooa.ooa23 IS NOT NULL AND l_npk.npk05 != g_ooa.ooa23 THEN
           CONTINUE FOREACH
        END IF
        #須考慮未確認沖帳資料
        SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file,ooa_file
         WHERE oob06 = l_nmg.nmg00 AND oob01 = ooa01 AND ooaconf = 'N'
           AND oob15 = l_npk.npk01 AND ooa01 != g_oob.oob01    #MOD-B90061 add
        IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
        IF cl_null(l_oob10) THEN LET l_oob10=0 END IF

        LET g_oob.oob02=g_oob.oob02+1
        LET g_oob.oob03='1' LET g_oob.oob04='2'
        LET g_oob.oob05=l_npk.npk01    #MOD-B90061 add
        LET g_oob.oob06=l_nmg.nmg00
        LET g_oob.oob14=l_nmg.nmg01
        LET g_oob.oob07=l_npk.npk05    #幣別
        LET g_oob.oob08=l_npk.npk06    #匯率

        #原幣是否應再扣除已沖金額
        LET g_oob.oob09=l_npk.npk08 - l_nmg.nmg24 - l_oob09   #原幣入帳金額
         #SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_oob.oob07    #MOD-670136
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07    #MOD-670136
        #本幣是否應扣除原幣*匯率之金額
        LET g_oob.oob10=l_npk.npk09-(l_nmg.nmg24*l_npk.npk06)-l_oob10  #本幣入帳金額

        SELECT nmz20 INTO l_nmz20 FROM nmz_file WHERE nmz00 = '0'
        IF l_nmz20 = 'Y' AND g_oob.oob07 != g_aza.aza17 THEN
           LET g_oob.oob08 = l_nmg.nmg09
           IF cl_null(g_oob.oob08) OR g_oob.oob08 = 0 THEN
              LET g_oob.oob08 = l_npk.npk06
           END IF
           CALL s_g_np('3','2',g_oob.oob06,g_oob.oob15)
                RETURNING tot3
           IF (l_oob09+g_oob.oob09+l_nmg.nmg24) = l_nmg.nmg23 THEN
              LET g_oob.oob10 = tot3 - l_oob10
           END IF
        END IF

        #CALL cl_digcut(g_oob.oob09,g_azi04) RETURNING g_oob.oob09   #MOD-670136
        #CALL cl_digcut(g_oob.oob10,t_azi04) RETURNING g_oob.oob10   #MOD-670136
        CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09   #MOD-670136
        CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10   #MOD-670136
        IF l_nmg.nmg29='Y' THEN
           LET g_oob.oob11=l_npk.npk071   #會計科目
           #No.FUN-670047 --begin
           IF g_aza.aza63 = 'Y' THEN
              LET g_oob.oob111=l_npk.npk073   #會計科目
           END IF
           #No.FUN-670047 --end
        ELSE
           LET g_oob.oob11=l_npk.npk07    #會計科目
           #No.FUN-670047 --begin
           IF g_aza.aza63 = 'Y' THEN
              LET g_oob.oob111=l_npk.npk072   #會計科目
           END IF
           #No.FUN-670047 --end
        END IF
        #-----MOD-730022---------
        #LET g_oob.oob13=l_nmg.nmg11
        #No.FUN-740184  --Begin
        CALL s_get_bookno(YEAR(l_nmg.nmg01)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag='1' THEN
           CALL s_errmsg('nmg01',l_nmg.nmg01,'','aoo-081',1)
           LET  g_success= 'N'
        END IF
        #No.FUN-740184  --End
        LET g_aag05 = ''
       #SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag01=g_oob.oob11  #No.FUn-740009
        SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag00=g_bookno1 AND aag01=g_oob.oob11  #No.FUN-740009
        IF g_aag05 = 'Y' THEN
           LET g_oob.oob13 = l_nmg.nmg11
        ELSE
           LET g_oob.oob13 = ''
        END IF
        #-----END MOD-730022-----
        IF g_oob.oob09 >0 OR g_oob.oob10 > 0 THEN
           #No.FUN-740184  --Begin
           IF tm.chg = 'Y' AND YEAR(tm.pay_date) <> YEAR(l_nmg.nmg01) THEN
              CALL s_tag(YEAR(tm.pay_date),g_bookno1,g_oob.oob11)
                   RETURNING l_bookno,g_oob.oob11
              CALL s_tag(YEAR(tm.pay_date),g_bookno2,g_oob.oob111)
                   RETURNING l_bookno,g_oob.oob111
           END IF
           #No.MOD-740184  --End

           LET g_oob.ooblegal = g_legal #FUN-980011 add

           INSERT INTO oob_file VALUES (g_oob.*)
           LET g_ooa.ooa31d=g_ooa.ooa31d+g_oob.oob09   #MOD-640476
           LET g_ooa.ooa32d=g_ooa.ooa32d+g_oob.oob10   #MOD-640476
        END IF
      END FOREACH
   END IF
#No.MOD-5B0015-end

   IF tm.s2='Y' THEN
      #No.TQC-5C0086  --Begin
      IF g_ooz.ooz07 = 'N' THEN
        #LET l_sql = "SELECT oma_file.* FROM oma_file ",            #No.FUN-680022 mark
         LET l_sql = "SELECT oma_file.*,omc_file.* FROM oma_file,omc_file ",            #No.FUN-680022 add
#                    " WHERE oma03='",g_ooa.ooa03,"' ",    #No.FUN-670026 mark
#                    "   AND oma032='",g_ooa.ooa032,"' ",  #No.FUN-670026 mark
                     " WHERE oma68='",g_ooa.ooa03,"' ",    #No.FUN-670026
                     "   AND oma69='",g_ooa.ooa032,"' ",   #No.FUN-670026
                     "   AND oma01=omc01 ",                #No.FUN-680022 add
                     "   AND (oma54t>oma55 OR oma56t>oma57) ",
                     "   AND oma00 LIKE '2%' ",
                     "   AND omavoid = 'N' ",
                     "   AND oma00 != '23' "
#                    "   AND oma02 <= '",tm.pay_edate,"' "  #No.FUN-B80068  #No.TQC-BB0053 mark
      ELSE
        #LET l_sql = "SELECT oma_file.* FROM oma_file ",            #No.FUN-680022 mark
         LET l_sql = "SELECT oma_file.*,omc_file.* FROM oma_file,omc_file ",
#                    " WHERE oma03='",g_ooa.ooa03,"' ",    #No.FUN-670026 mark
#                    "   AND oma032='",g_ooa.ooa032,"' ",  #No.FUN-670026 mark
                     " WHERE oma68='",g_ooa.ooa03,"' ",    #No.FUN-670026
                     "   AND oma69='",g_ooa.ooa032,"' ",   #No.FUN-670026
                     "   AND oma01=omc01 ",                #No.FUN-680022 add
                     "   AND (oma54t>oma55 OR oma61>0) ",
                     "   AND oma00 LIKE '2%' ",
                     "   AND omavoid = 'N' ",
                     "   AND oma00 != '23' "  
#                    "   AND oma02 <= '",tm.pay_edate,"' "  #No.FUN-B80068  #No.TQC-BB0053 mark
      END IF
      #No.TQC-BB0053  --Begin
      IF NOT cl_null(tm.pay_edate) THEN
         LET l_sql = l_sql," AND oma02 <= '",tm.pay_edate,"' " 
      END IF
      #No.TQC-BB0053  --End  
      #No.TQC-5C0086  --End
      PREPARE t400_g_b_pre3 FROM l_sql
      DECLARE t400_g_b_c13 CURSOR FOR t400_g_b_pre3
      FOREACH t400_g_b_c13 INTO l_oma.*,l_omc.*        #No.FUN-680022 add l_omc.*
        IF STATUS THEN EXIT FOREACH END IF
        IF g_ooa.ooa23 IS NOT NULL AND l_oma.oma23 != g_ooa.ooa23 THEN
           CONTINUE FOREACH
        END IF
       #考慮未確認沖帳資料
        SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM ooa_file,oob_file
         WHERE oob06=l_oma.oma01 AND ooa01=oob01 AND ooaconf='N'
           AND oob19=l_omc.omc02                            #No.FUN-680022 add
        IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
        IF cl_null(l_oob10) THEN LET l_oob10=0 END IF
       #若己在axrt300產生分錄,因稅額已在前端立過了,故在此不用再立,
       #故此處金額應直接取含稅金額
       #-MOD-A90058-mark-
       #CALL s_get_doc_no(l_oma.oma01) RETURNING g_t1
       #SELECT ooydmy1 INTO l_ooydmy1 FROM ooy_file
       # WHERE ooyslip=g_t1
       #IF l_ooydmy1='Y' THEN
       #-MOD-A90058-end-
          #LET g_oob.oob09=l_oma.oma54t-l_oma.oma55 - l_oob09 #No.FUN-680022 mark
          #LET g_oob.oob10=l_oma.oma56t-l_oma.oma57 - l_oob10 #No.FUN-680022 mark
           LET g_oob.oob09=l_omc.omc08 -l_omc.omc10 - l_oob09 #No.FUN-680022 add
           LET g_oob.oob10=l_omc.omc09 -l_omc.omc11 - l_oob10 #No.FUN-680022 add
           #No.TQC-5C0086  --Begin
           #No.FUN-7B0055  --Begin
           #CALL s_ar_oox03(l_oma.oma01) RETURNING g_net
           CALL s_ar_oox03_1(l_oma.oma01,l_omc.omc02)
                RETURNING g_net  #No.FUN-7B0055
           #No.FUN-7B0055  --End
           LET g_oob.oob10=g_oob.oob10 + g_net
           #No.TQC-5C0086  --End
       #-MOD-A90058-mark-
       #ELSE
       #  #LET g_oob.oob09=l_oma.oma54-l_oma.oma55 - l_oob09 #No.FUN-680022 mark
       #  #LET g_oob.oob10=l_oma.oma56-l_oma.oma57 - l_oob10 #No.FUN-680022 mark
       #   LET g_oob.oob09=l_omc.omc08/(1+l_oma.oma211)-l_omc.omc10/(1+l_oma.oma211)-l_oob09 #No.FUN-680022 add
       #   LET g_oob.oob10=l_omc.omc09/(1+l_oma.oma211)-l_omc.omc11/(1+l_oma.oma211)-l_oob10 #No.FUN-680022 add
       #END IF
       #-MOD-A90058-end-
       #---------------------------- 先作未稅
        LET g_oob.oob02=g_oob.oob02+1
        LET g_oob.oob03='1' LET g_oob.oob04='3'
      # LET g_oob.oob06=l_oma.oma01    #No.FUN-680022 mark
        LET g_oob.oob06=l_omc.omc01    #No.FUN-680022 mark
        LET g_oob.oob19=l_omc.omc02    #No.FUN-680022 mark
        LET g_oob.oob14=NULL
        LET g_oob.oob07=l_oma.oma23 LET g_oob.oob08=l_oma.oma24

        IF g_ooz.ooz07 = 'Y' AND g_oob.oob07 != g_aza.aza17 THEN
           LET g_oob.oob08 = l_oma.oma60
           IF cl_null(g_oob.oob08) OR g_oob.oob08 = 0 THEN
              LET g_oob.oob08 = l_oma.oma24
           END IF
           CALL s_g_np('1',l_oma.oma00,g_oob.oob06,g_oob.oob15)
                RETURNING tot3
          #No.FUN-680022--begin-- mark
          #IF (l_oob09+g_oob.oob09+l_oma.oma55) = l_oma.oma54t THEN
          #   LET g_oob.oob10 = tot3 - l_oob10
          #END IF
          #No.FUN-680022--end-- mark
        END IF

        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07
       #未扣除已沖帳
        #CALL cl_digcut(g_oob.oob09,g_azi04) RETURNING g_oob.oob09   #MOD-670136
        #CALL cl_digcut(g_oob.oob10,t_azi04) RETURNING g_oob.oob10   #MOD-670136
        CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09   #MOD-670136
        CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10   #MOD-670136
        LET g_oob.oob11=l_oma.oma18
        #No.FUN-670047 --begin
        IF g_aza.aza63 = 'Y' THEN
           LET g_oob.oob111=l_oma.oma181
        END IF
        #No.FUN-670047 --end
        IF g_oob.oob09<=0 THEN CONTINUE FOREACH END IF
        #-----MOD-730022---------
        #LET g_oob.oob13=l_oma.oma15
        #No.FUN-740184  --Begin
        CALL s_get_bookno(YEAR(l_oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag='1' THEN
           CALL s_errmsg('oma02',l_oma.oma02,'','aoo-081',1)
           LET  g_success= 'N'
        END IF
        #No.FUN-740184  --End
        LET g_aag05 = ''
       #SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag01=g_oob.oob11  #No.FUN-740009
        SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag00=g_bookno1 AND aag01=g_oob.oob11  #No.FUN-740009
        IF g_aag05 = 'Y' THEN
           LET g_oob.oob13 = l_oma.oma15
        ELSE
           LET g_oob.oob13 = ''
        END IF
        #-----END MOD-730022-----
        #No.FUN-740184  --Begin
        IF tm.chg = 'Y' AND YEAR(tm.pay_date) <> YEAR(l_oma.oma02) THEN
           CALL s_tag(YEAR(tm.pay_date),g_bookno1,g_oob.oob11)
                RETURNING l_bookno,g_oob.oob11
           CALL s_tag(YEAR(tm.pay_date),g_bookno2,g_oob.oob111)
                RETURNING l_bookno,g_oob.oob111
        END IF
        #No.MOD-740184  --End
        LET g_oob.ooblegal = g_legal #FUN-980011 add

        INSERT INTO oob_file VALUES (g_oob.*)
        LET g_ooa.ooa31d=g_ooa.ooa31d+g_oob.oob09   #MOD-640476
        LET g_ooa.ooa32d=g_ooa.ooa32d+g_oob.oob10
       #---------------------------- 再作稅額
       #若'2*'己在axrt300產生分錄,因稅額已在前端立過了,故在此不用再立
       #IF l_oma.oma54x != 0 THEN
        IF l_ooydmy1='N' AND l_oma.oma54x != 0 THEN
           LET g_oob.oob02=g_oob.oob02+1
           LET g_oob.oob09=l_oma.oma54x LET g_oob.oob10=l_oma.oma56x
           LET g_oob.oob11=l_ool.ool14
           #No.FUN-670047 --begin
           IF g_aza.aza63 = 'Y' THEN
              LET g_oob.oob111=l_ool.ool141
           END IF
           #No.FUN-670047 --end
           #-----MOD-730022---------
           LET g_aag05 = ''
          #SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag01=g_oob.oob11   #No.FUN-740009
           SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag00=g_bookno1 AND aag01=g_oob.oob11  #No.FUN-740009
           IF g_aag05 = 'Y' THEN
              LET g_oob.oob13 = l_oma.oma15
           ELSE
              LET g_oob.oob13 = ''
           END IF
           #-----END MOD-730022-----
           #CALL cl_digcut(g_oob.oob09,g_azi04) RETURNING g_oob.oob09   #MOD-670136
           #CALL cl_digcut(g_oob.oob10,t_azi04) RETURNING g_oob.oob10   #MOD-670136
           CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09   #MOD-670136
           CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10   #MOD-670136
           #No.FUN-740184  --Begin
           IF tm.chg = 'Y' AND YEAR(tm.pay_date) <> YEAR(l_oma.oma02) THEN
              CALL s_tag(YEAR(tm.pay_date),g_bookno1,g_oob.oob11)
                   RETURNING l_bookno,g_oob.oob11
              CALL s_tag(YEAR(tm.pay_date),g_bookno2,g_oob.oob111)
                   RETURNING l_bookno,g_oob.oob111
           END IF
           #No.MOD-740184  --End
           LET g_oob.ooblegal = g_legal #FUN-980011 add

           INSERT INTO oob_file VALUES (g_oob.*)
           LET g_ooa.ooa31d=g_ooa.ooa31d+g_oob.oob09    #MOD-640476
           LET g_ooa.ooa32d=g_ooa.ooa32d+g_oob.oob10
        END IF
      END FOREACH
   END IF
   #----------------------------------- #由應付系統產生單身
   IF tm.ap='Y' THEN
      SELECT apz27 INTO l_apz27 FROM apz_file WHERE apz00 = '0'
     #LET l_sql = " SELECT apa_file.* FROM apa_file ",                                         #MOD-C30847 mark
      LET l_sql = " SELECT apa_file.*,apc_file.* ",                                            #MOD-C30847 add
                  "   FROM apa_file,apc_file ",                                                #MOD-C30847 add
                  "  WHERE  apa06='",tm.apa06 ,"'  AND apa07='",tm.apa07,"'",
                  "  AND apa41 = 'Y' and apa42 = 'N' AND apa00 IN ('11','12','15','16','17') ",
                  "  AND apa01 = apc01 ",                                                      #MOD-C30847 add
                 #"  AND apa02 <= '",tm.pay_edate,"' ",  #No.FUN-B80068  #No.TQC-BB0053  mark
                  "  AND apa01 NOT IN ",
                  " (SELECT oob06 FROM oob_file WHERE oob06 IS NOT NULL ",
                  "     AND oob03 = '1' AND oob04 = '9' )"
      #No.TQC-BB0053  --Begin
      IF NOT cl_null(tm.pay_edate) THEN
         LET l_sql = l_sql CLIPPED,"  AND apa02 <= '",tm.pay_edate,"' "
      END IF
      #No.TQC-BB0053  --End  

      PREPARE t400_prec14 FROM l_sql
      IF STATUS THEN
      #No.FUN-710050--Begin--
      #  CALL cl_err('t400_prec14',STATUS,0) LET g_success = 'N' RETURN
         CALL s_errmsg('','','t400_prec14',STATUS,1) LET g_success = 'N' RETURN
      #No.FUN-710050--End--
      END IF
      DECLARE t400_g_b_c14 CURSOR FOR t400_prec14

     #FOREACH t400_g_b_c14 INTO l_apa.*                      #MOD-C30847 mark
      FOREACH t400_g_b_c14 INTO l_apa.*,l_apc.*              #MOD-C30847 add
         IF STATUS THEN
         #No.FUN-710050--Begin--
         #  CALL cl_err('t400_g_b_c14',STATUS,0)
            CALL s_errmsg('','','t400_g_b_c14',STATUS,1)
         #No.FUN-710050--End--
            LET g_success = 'N' EXIT FOREACH
         END IF
         LET g_oob.oob02=g_oob.oob02+1
         LET g_oob.oob03='1' LET g_oob.oob04='9'
         LET g_oob.oob06=l_apa.apa01
         LET g_oob.oob07=l_apa.apa13
         LET g_oob.oob08=l_apa.apa14
         LET g_oob.oob14=' '
         LET g_oob.oob19 = l_apc.apc02                                                     #MOD-C30847 add
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07
        #--------------------------MOD-C30847-----------------------------(S)
        #LET g_oob.oob09 = l_apa.apa34f - l_apa.apa35f                               #MOD-C30847 mark
         LET g_oob.oob09 = l_apc.apc08 - l_apc.apc10 - l_apc.apc16 - l_apc.apc14
         IF g_apz.apz27 = 'N' THEN
           #LET g_oob.oob10 = l_apa.apa34  - l_apa.apa35                             #MOD-C30847 mark
            LET g_oob.oob10 = l_apc.apc09 - l_apc.apc11
                            - (l_apc.apc16*l_apc.apc06) - l_apc.apc15
         ELSE
            LET g_oob.oob10 = l_apc.apc13 - (l_apc.apc16 * l_apc.apc07)
         END IF
        #--------------------------MOD-C30847-----------------------------(E)

         #考慮未確認沖帳資料
         SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10
           FROM oob_file,ooa_file
          WHERE oob06 = l_apa.apa01 
            AND oob01 = ooa01 
            AND ooaconf = 'N'
            AND oob03='1'                    #MOD-C30847 add
            AND oob04='9'                    #MOD-C30847 add
            AND oob19 = l_apc.apc02          #MOD-C30847 add

         IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
         IF cl_null(l_oob10) THEN LET l_oob10=0 END IF

         IF l_apz27 = 'Y' AND g_oob.oob07 != g_aza.aza17 THEN
            LET g_oob.oob08 = l_apa.apa72
            IF cl_null(g_oob.oob08) OR g_oob.oob08 = 0 THEN
               LET g_oob.oob08 = l_apa.apa14
            END IF
           #CALL s_g_np('2',l_apa.apa00,g_oob.oob06,g_oob.oob15)             #MOD-C30847 mark
           #     RETURNING tot3                                              #MOD-C30847 mark
           #IF (l_oob09 + g_oob.oob09 + l_apa.apa35f) = l_apa.apa34f THEN    #MOD-C30847 mark
           #   LET g_oob.oob10 = tot3 - l_oob10                              #MOD-C30847 mark
           #END IF                                                           #MOD-C30847 mark
         END IF
        #--------------------------MOD-C30847-----------------------------(S)
         SELECT SUM(apg05f),SUM(apg05) INTO p05f,p05
           FROM apg_file,apf_file
          WHERE apg04 = l_apa.apa01
            AND apg06 = l_apc.apc02
            AND apg01 = apf01
            AND apf41 = 'N'
            AND apg01<>g_ooa.ooa01
         IF cl_null(p05f) THEN LET p05f = 0 END IF
         IF cl_null(p05) THEN LET p05 = 0 END IF
         LET g_oob.oob09 = g_oob.oob09 - l_oob09 - p05f
         LET g_oob.oob10 = g_oob.oob10 - l_oob10 - p05
        #--------------------------MOD-C30847-----------------------------(E)

        #CALL cl_digcut(g_oob.oob09,g_azi04) RETURNING g_oob.oob09   #MOD-670136
        #CALL cl_digcut(g_oob.oob10,t_azi04) RETURNING g_oob.oob10   #MOD-670136
         CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09   #MOD-670136
         CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10   #MOD-670136
         LET g_oob.oob11=l_apa.apa54
         #No.FUN-670047 --begin
         IF g_aza.aza63 = 'Y' THEN
            LET g_oob.oob111=l_apa.apa541
         END IF
         #No.FUN-670047 --end
         #-----MOD-730022---------
         #LET g_oob.oob13=l_apa.apa22
         #No.FUN-740184  --Begin
         CALL s_get_bookno(YEAR(l_apa.apa02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag='1' THEN
            CALL s_errmsg('apa02',l_apa.apa02,'','aoo-081',1)
            LET  g_success= 'N'
         END IF
         #No.FUN-740184  --End
         LET g_aag05 = ''
        #SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag01=g_oob.oob11   #No.FUN-740009
         SELECT aag05 INTO g_aag05 FROM aag_file WHERE aag00=g_bookno1 AND aag01=g_oob.oob11  #No.FUN-740009
         IF g_aag05 = 'Y' THEN
            LET g_oob.oob13 = l_apa.apa22
         ELSE
            LET g_oob.oob13 = ''
         END IF
         #-----END MOD-730022-----
         IF g_oob.oob09 =0 THEN
            CONTINUE FOREACH
         END IF
         #No.FUN-740184  --Begin
         IF tm.chg = 'Y' AND YEAR(tm.pay_date) <> YEAR(l_apa.apa02) THEN
            CALL s_tag(YEAR(tm.pay_date),g_bookno1,g_oob.oob11)
                 RETURNING l_bookno,g_oob.oob11
            CALL s_tag(YEAR(tm.pay_date),g_bookno2,g_oob.oob111)
                 RETURNING l_bookno,g_oob.oob111
         END IF
         #No.MOD-740184  --End
         LET g_oob.ooblegal = g_legal #FUN-980011 add

         INSERT INTO oob_file VALUES (g_oob.*)
         LET g_ooa.ooa31d=g_ooa.ooa31d+g_oob.oob09   #MOD-640476
         LET g_ooa.ooa32d=g_ooa.ooa32d+g_oob.oob10

      END FOREACH
   END IF

END FUNCTION

FUNCTION p400_upd_ooa()
    DEFINE  l_n       LIKE type_file.num10        #No.FUN-680123  INTEGER

    SELECT COUNT(DISTINCT(oob07)) INTO l_n FROM oob_file WHERE oob01=g_ooa.ooa01
    IF l_n>1 THEN
       UPDATE ooa_file SET ooa23 = ""  WHERE ooa01=g_ooa.ooa01
       IF SQLCA.sqlcode OR STATUS=100 THEN
#         CALL cl_err('up_ooa',SQLCA.sqlcode,0)                                       #No.FUN-660116
       #No.FUN-710050--Begin--
       #  CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","up_ooa",0)   #No.FUN-660116
          CALL s_errmsg('ooa01','g_ooa.ooa01','up_ooa',SQLCA.sqlcode,1)
       #No.FUN-710050--End---
          LET g_success = 'N'
          RETURN
       END IF
    END IF

    UPDATE ooa_file SET ooa31d = g_ooa.ooa31d,
                        ooa31c = g_ooa.ooa31c,
                        ooa32d = g_ooa.ooa32d,
                        ooa32c = g_ooa.ooa32c
                  WHERE ooa01 = g_ooa.ooa01
    IF SQLCA.sqlcode OR STATUS=100 THEN
#      CALL cl_err('up_ooa',SQLCA.sqlcode,0)   #No.FUN-660116
    #No.FUN-710050--Begin--
    #  CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","up_ooa",0)   #No.FUN-660116
       CALL s_errmsg('ooa01','g_ooa.ooa01','up_ooa',SQLCA.sqlcode,1)
    #No.FUN-710050--End---
       LET g_success = 'N'
       RETURN
    END IF
END FUNCTION

FUNCTION p400_set_entry()

    IF INFIELD(ap) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("apa06,apa07",TRUE)
    END IF

END FUNCTION

FUNCTION p400_set_no_entry()

    IF INFIELD(ap) OR (NOT g_before_input_done) THEN
       IF tm.ap = 'N' THEN
          CALL cl_set_comp_entry("apa06,apa07",FALSE)
       END IF
    END IF

    IF INFIELD(apa06) OR (NOT g_before_input_done) THEN
       IF tm.apa06 != 'MISC' THEN
          CALL cl_set_comp_entry("apa07",FALSE)
       END IF
    END IF

END FUNCTION

#No.TQC-5B0147 --start--
FUNCTION update_oob02()
DEFINE l_sql     LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(300)
DEFINE i,j       LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE l_oob02   LIKE oob_file.oob02
DEFINE oob_tmp   DYNAMIC ARRAY OF RECORD
                 tmp_oob01 LIKE oob_file.oob01,
                 tmp_oob02 LIKE oob_file.oob02,
                 tmp_oob04 LIKE oob_file.oob04
                 END RECORD

      LET l_sql = " SELECT oob01,oob02,oob04 FROM oob_file ",
                  "  WHERE  oob01 = '",g_ooa.ooa01, "'",
                  "  ORDER BY oob02,oob04 "

      PREPARE t400_tmp FROM l_sql
      IF STATUS THEN
         CALL cl_err('t400_tmp',STATUS,0) LET g_success = 'N' RETURN
      END IF
      DECLARE tmp_lcur CURSOR FOR t400_tmp

      LET i=1
      CALL oob_tmp.clear()
      FOREACH tmp_lcur INTO oob_tmp[i].*
        LET l_oob02 = oob_tmp[i].tmp_oob02
        IF SQLCA.sqlcode THEN
        #No.FUN-710050--Begin--
        #  CALL cl_err('foreach:',SQLCA.sqlcode,1)
           CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)
        #No.FUN-710050--End--
           EXIT FOREACH
        END IF
        LET oob_tmp[i].tmp_oob02 = i
        UPDATE oob_file SET oob02 = oob_tmp[i].tmp_oob02
         WHERE oob01 = g_ooa.ooa01
           AND oob02 = l_oob02
           AND oob04 = oob_tmp[i].tmp_oob04
        LET i = i+1
        IF i>g_max_rec THEN
        #No.FUN-710050--Begin--
        #  CALL cl_err('',9035,0)
           LET g_showmsg = g_ooa.ooa01,"/",l_oob02,"/",oob_tmp[i].tmp_oob04
           CALL s_errmsg('oob01,oob02,oob04',g_showmsg,'',9035,0)
        #No.FUN-710050--End--
           EXIT FOREACH
        END IF
      END FOREACH

END FUNCTION
#No.TQC-5B0147  --end--
