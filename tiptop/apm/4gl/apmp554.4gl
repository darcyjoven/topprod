# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp554.4gl
# Descriptions...: 發出採購單作業
# Input parameter:
#                  1: 採購單號
#                  2: 採購日期
#                  3: 供應廠商
# Return code....:
# Date & Author..: 91/09/30 By Apple
# Modify.........: 93/02/08 BY Apple
#                : 修改成採購單維護後可直接發出
# Modify.........: 99/04/15 BY Carol:modify s_pmmsta()
# Modify.........: No.FUN-610018 06/01/09 By ice 採購含稅單價功能調整
 
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-650164 06/08/29 By rainy 取消 'RTN'判斷
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.TQC-690085 06/11/16 By pengu 採購單發出時，若單價為0則單價不回寫pmh_file。
# Modify.........: No.TQC-6B0125 06/11/22 By day 開啟查詢視窗無效
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-760015 07/06/05 By claire sma843價格更新參數要考慮最近單價=0
# Modify.........: No.TQC-750236 07/06/10 By claire 發出時pmn36給值g_today
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: No.MOD-730044 07/09/18 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.TQC-7C0125 07/12/08 By Rayven 單身中“最近采購含稅單價”的金額、“稅種”、“稅率”沒有更新
# Modify.........: No.FUN-810038 08/01/21 By kim GP5.1 ICD
# Modify.........: No.FUN-810016 08/02/17 By ve007 pmh_file.pmh23的insert
# Modify.........: No.CHI-830032 08/03/26 By kim GP5.1整合測試修改
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930108 09/04/07 By zhaijie增加判斷此料件是否需AVL的檢查
# Modify.........: No.MOD-950287 09/05/27 By chenyu pmhacti='N'時不能新增一筆資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行制程
# Modify.........: No:TQC-A80053 10/08/53 select pmh时多加了acti='Y'的条件,导致有无效资料时,重复insert pmh失败
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-A90020 10/09/19 By Carrier pmh25 default
# Modify.........: No:TQC-B60131 11/06/17 By wuxj  顯示目前狀況pmm25,并在審核時重新抓取再判斷是否可發出
# Modify.........: No:MOD-B90060 11/09/08 By johung ima53/ima531更新後依本國幣取位
# Modify.........: No.TQC-C40221 12/04/23 By zhuhao FUNCTION up_price()中l_date欄位類型調整
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmm DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1) # 確定否
            pmm01    LIKE pmm_file.pmm01,     # 採購單號
            pmm04    LIKE pmm_file.pmm04,     # 單據日期
            pmm02    LIKE pmm_file.pmm02,     # 性質
            pmm09    LIKE pmm_file.pmm09,     # 廠商編號
            pmc03    LIKE pmc_file.pmc03,     # 廠商簡稱
         #  pmm25    LIKE pmm_file.pmm25      #No.FUN-680136 VARCHAR(10)  # 目前狀況
            pmm25    LIKE type_file.chr10     #No:TQC-B60131 add 
        END RECORD,
        g_unalc      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        g_pmm22      LIKE pmm_file.pmm22,     # Curr
        g_pmm42      LIKE pmm_file.pmm42,     # Ex.Rate
        g_ima53      LIKE ima_file.ima53,
        g_ima531     LIKE ima_file.ima531,
        g_ima532     LIKE ima_file.ima532,
        g_argv1      LIKE pmm_file.pmm01,
        g_argv2      LIKE pmm_file.pmm04,
        g_argv3      LIKE pmm_file.pmm09,
         g_wc         string,  #No.FUN-580092 HCN
         g_sql        string,  #No.FUN-580092 HCN
        g_cmd         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(60)
        l_exit_sw     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
        l_sw          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
        g_flag        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
        g_rec_b       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
        l_ac,l_sl     LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE  g_cnt         LIKE type_file.num10    #No.FUN-680136 INTEGER
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_argv1 = ARG_VAL(1)             #採購單號
   LET g_argv2 = ARG_VAL(2)             #採購日期
   LET g_argv3 = ARG_VAL(3)             #供應廠商
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   IF cl_null(g_argv1) THEN
      CALL p554_tm()
   ELSE
      LET g_success = 'Y'
      CALL p554_update(g_argv1,g_argv2,g_argv3)
      CALL s_showmsg()       #No.FUN-710030
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1)
         COMMIT WORK
      ELSE
         CALL cl_rbmsg(1)
         ROLLBACK WORK
      END IF
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p554_tm()
   DEFINE
      p_row,p_col   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_no,l_cnt    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_pmm18       LIKE pmm_file.pmm18,
      l_pmmmksg     LIKE pmm_file.pmmmksg,
      g_sta         LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW p554_w AT p_row,p_col WITH FORM "apm/42f/apmp554"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('q')
 
   WHILE TRUE
      CALL g_pmm.clear()
      CLEAR FORM
      ERROR ''
      CONSTRUCT g_wc ON pmm01,pmm04,pmm02,pmm09
                FROM s_pmm[1].pmm01,s_pmm[1].pmm04,s_pmm[1].pmm02,s_pmm[1].pmm09
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        ON ACTION locale                    #genero
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT CONSTRUCT
 
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
 
     IF g_action_choice = "locale" THEN  #genero
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     LET g_success = 'Y'
 
     #資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET g_wc = g_wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET g_wc = g_wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET g_wc = g_wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET g_sql="SELECT 'N',pmm01,pmm04,pmm02,pmm09,pmc03,pmm25,pmm18,pmmmksg",
               "  FROM pmm_file ,OUTER pmc_file",
               " WHERE pmm_file.pmm09 = pmc_file.pmc01 ",
               " AND pmm02 !='SUB' AND pmm18='Y' ",
               " AND pmm25 = '1'"
     LET g_sql = g_sql CLIPPED," AND ", g_wc CLIPPED, " ORDER BY pmm01"
     PREPARE p554_prepare FROM g_sql           # RUNTIME 編譯
     IF SQLCA.sqlcode THEN
        CALL cl_err('cannot prepare ',SQLCA.sqlcode,1)
        CONTINUE WHILE
     END IF
     DECLARE p554_cs                         # CURSOR
       CURSOR FOR p554_prepare
     IF SQLCA.sqlcode THEN
        CALL cl_err('cannot declare ',SQLCA.sqlcode,1)
        CONTINUE WHILE
     END IF
 
     CALL cl_opmsg('z')
     LET l_ac = 1
     LET g_rec_b = 0
 
     FOREACH p554_cs INTO g_pmm[l_ac].*,l_pmm18,l_pmmmksg
        IF SQLCA.sqlcode THEN
           CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF NOT cl_null(g_pmm[l_ac].pmm25) THEN
           CALL s_pmmsta('pmm',g_pmm[l_ac].pmm25,l_pmm18,l_pmmmksg)
                RETURNING g_pmm[l_ac].pmm25
        END IF
        LET l_ac = l_ac + 1
        IF l_ac > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     END FOREACH
     CALL g_pmm.deleteElement(l_ac)
 
     LET g_rec_b=l_ac - 1
     DISPLAY g_rec_b TO FORMONLY.cn2
     IF g_rec_b = 0 THEN
        CALL cl_err('','mfg3122',0)
        CONTINUE WHILE
     END IF
 
     IF g_rec_b > 0 THEN
        CALL  p554_sure() RETURNING l_cnt        #確定否
        IF INT_FLAG  THEN
           LET INT_FLAG = 0
           CONTINUE WHILE
        END IF
 
        IF l_cnt > 0 THEN
           IF cl_sure(0,0) THEN
              FOR l_no = 1 TO g_rec_b
                  LET g_success = 'Y'
                  IF g_pmm[l_no].sure = 'Y'  THEN
                     CALL p554_update(g_pmm[l_no].pmm01,g_pmm[l_no].pmm04,
                                      g_pmm[l_no].pmm09)
                     CALL s_showmsg()       #No.FUN-710030
                     IF g_success = 'Y' THEN
                        CALL cl_cmmsg(1) COMMIT WORK
                     ELSE
                        CALL cl_rbmsg(1) ROLLBACK WORK
                     END IF
                 END IF
              END FOR
           END IF
        END IF
     END IF
   END WHILE
   ERROR ""
   CLOSE WINDOW p554_w
END FUNCTION
 
FUNCTION p554_update(p_pmm01,p_pmm04,p_pmm09)
   DEFINE
      p_pmm01   LIKE pmm_file.pmm01,    #採購單號
      p_pmm02   LIKE pmm_file.pmm02,
      p_pmm04   LIKE pmm_file.pmm04,    #採購日期
      p_pmm09   LIKE pmm_file.pmm09,    #廠商編號
      l_pmn20   LIKE pmn_file.pmn20,
      l_pmn04   LIKE pmn_file.pmn04,
      l_pmn31   LIKE pmn_file.pmn31,
      l_pmn31t  LIKE pmn_file.pmn31t,   #No.FUN-610018
      l_pmn43   LIKE pmn_file.pmn43,    #No.FUN-670099
      l_pmm21   LIKE pmm_file.pmm21,    #No.FUN-610018
      l_pmm43   LIKE pmm_file.pmm43,    #No.FUN-610018
      l_pmn35   LIKE pmn_file.pmn35,
      l_pmn44   LIKE pmn_file.pmn44,
      l_pmn09   LIKE pmn_file.pmn09,
      l_ima37   LIKE ima_file.ima37,
     #MOD-730044-begin-add
      l_pmn07   LIKE pmn_file.pmn07,      #採購單位
      l_ima44   LIKE ima_file.ima44,    
      l_ima908  LIKE ima_file.ima908,    
      l_pmn86   LIKE pmn_file.pmn86,      #計價單位
      l_pmn87   LIKE pmn_file.pmn87,      #計價單位
      l_pmn012  LIKE pmn_file.pmn012,     #FUN-A60027
     #l_pmn46   LIKE pmn_file.pmn46,      #FUN-A60027  #FUN-A60076 
      l_pmn41   LIKE pmn_file.pmn41,      #FUN-A60076 
      l_unitrate LIKE pmn_file.pmn121,  
      l_sw      LIKE type_file.num10,               
     #MOD-730044-end-add
      l_ima44_fac   LIKE ima_file.ima44_fac,
     #l_ima86_fac   LIKE ima_file.ima86_fac,
      l_sql     LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(300)
DEFINE p_pmm25  LIKE pmm_file.pmm25     #TQC-B60131 add
DEFINE p_pmm18  LIKE pmm_file.pmm18     #TQC-B60131 add 
 
   BEGIN WORK
 
#TQC-B60131  ---begin---
   SELECT pmm25,pmm18 INTO p_pmm25,p_pmm18 FROM pmm_file WHERE pmm01 = p_pmm01
   IF p_pmm18 !='Y' THEN 
      LET g_success = 'N'
      CALL cl_err(p_pmm01,'apm-117',1)
      RETURN
   END IF 
   IF p_pmm25 != '1' THEN 
      LET g_success = 'N'
      CALL cl_err('pmm25 != 1','apm-299',1) 
      RETURN
    END IF
#TQC-B60131  --end---

   SELECT pmm02 INTO p_pmm02 FROM pmm_file
    WHERE pmm01 = p_pmm01
 
   #==>更改採購單頭狀況碼,為(已發出)
   IF p_pmm02 != 'BKR' THEN
      UPDATE pmm_file SET pmm25 = '2'
       WHERE pmm01 = p_pmm01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
#        CALL cl_err('(apmp554:ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("upd","pmm_file",p_pmm01,"",SQLCA.sqlcode,"","(apmp554:ckp#1)",1)  #No.FUN-660129
         RETURN
      END IF
   END IF
 
   #==>更改採購單身狀況碼,為(已發出)
   UPDATE pmn_file SET pmn16 = '2', pmn36 = g_today  #TQC-750236 modify
    WHERE pmn01 = p_pmm01 AND pmn16 IN ('0','1')
      AND pmn011 != 'BKR'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
#     CALL cl_err('(apmp554:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
      CALL cl_err3("upd","pmn_file",p_pmm01,"",SQLCA.sqlcode,"","(apmp554:ckp#2)",1)  #No.FUN-660129
      RETURN
   END IF
 
 
   #==>更改廠商資料檔中的最近採購日期
   UPDATE pmc_file SET pmc40 = g_today   #最近採購日期
     WHERE pmc01 = p_pmm09
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
#     CALL cl_err('(apmp554:ckp#3)',SQLCA.sqlcode,1)   #No.FUN-660129
      CALL cl_err3("upd","pmc_file",p_pmm09,"",SQLCA.sqlcode,"","(apmp554:ckp#3)",1)  #No.FUN-660129
      RETURN
   END IF
 
   #FUN-810038................begin
   IF s_industry('icd') THEN
      #==>用採購料號(pmn04)串icw05，若存在且icw17為空白,
      #   則回寫new code的wafer首次發出日期(icw17)=g_today,
      #                         wafer採購單(icw20)
      LET l_sql = "SELECT pmn04 FROM pmn_file WHERE pmn01 = '",p_pmm01,"'"
      PREPARE p554_pre FROM l_sql
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err('prepare p554_pre :',SQLCA.sqlcode,1)
         RETURN
      END IF
      DECLARE p554_cus CURSOR FOR p554_pre
      FOREACH p554_cus INTO l_pmn04
         UPDATE icw_file SET icw17 = g_today,icw20 = p_pmm01
          WHERE icw05 = l_pmn04 AND icw17 IS NULL
        #CHI-830032..........mark begin 無需警告
        #IF SQLCA.sqlerrd[3]=0 THEN
        #   CALL cl_err3("upd","icw_file",l_pmn04,"",SQLCA.sqlcode,"","100",1)
        #   RETURN
        #END IF  
        #CHI-830032..........mark end
      END FOREACH
   END IF
   #FUN-810038................end
 
   #==>更新[料件主檔]最近採購單價,在外量
   LET l_sql = " SELECT pmn04,pmn31,pmn31t,pmn20,pmn09,",     #No.FUN-610018
               "ima53,ima531,ima532,ima37,pmm22,pmm42,pmn44,pmn35,pmn43 ",  #No.FUN-670099
             # ",pmn07,ima44,ima908,pmn86,pmn87,pmn012,pmn46 ",  #MOD-730044 add  #FUN-A60027 add pmn012,pmn46  #FUN-A60076 mark
               ",pmn07,ima44,ima908,pmn86,pmn87,pmn012,pmn41 ",  #FUN-A60076 
               " FROM pmn_file,ima_file,pmm_file",
               " WHERE pmn01 = '",p_pmm01,"'",
               "   AND pmm02 != 'SUB' ",
               "   AND pmn01 = pmm01 AND ima01 = pmn04 "
 
   PREPARE p554_pl FROM l_sql
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('prepare p005_p1 :',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE p554_cur2  CURSOR FOR p554_pl
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('declare p005_cur2 :',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH p554_cur2 INTO l_pmn04,l_pmn31,l_pmn31t,l_pmn20,l_pmn09,   #No.FUN-610018
                          g_ima53,g_ima531,g_ima532,
                          l_ima37,g_pmm22,g_pmm42,l_pmn44,l_pmn35,l_pmn43  #No.FUN-670099
                       #  ,l_pmn07,l_ima44,l_ima908,l_pmn86,l_pmn87,l_pmn012,l_pmn46 #MOD-730044   #FUN-A60027 add pmn012,pmn46 #FUN-A60076 mark
                          ,l_pmn07,l_ima44,l_ima908,l_pmn86,l_pmn87,l_pmn012,l_pmn41 #FUN-A60076  
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
#No.FUN-710030 -- begin --
#         CALL cl_err('Foreach p554_cur2 :',SQLCA.sqlcode,1)
         IF g_bgerr THEN
            CALL s_errmsg("","","Foreach p554_cur2 :",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","Foreach p554_cur2 :",1)
            END IF
#No.FUN-710030 -- end --
         EXIT FOREACH
      END IF
#No.FUN-710030 -- begin --
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
#No.FUN-710030 -- end --
 
      # 93/08/08 Modify By David  --- Today is not a good day
      # if 為期間採購料件 then 更新 最近期間採購日期
      #IF l_ima37 = '5' THEN
         UPDATE ima_file SET ima881 = p_pmm04,
                             imadate = g_today     #FUN-C30315 add
           WHERE ima01 = l_pmn04
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
#           CALL cl_err('Update ima881 Error',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","ima_file",l_pmn04,"",SQLCA.sqlcode,"","Update ima881 Error",1)  #No.FUN-660129
#            EXIT FOREACH
            IF g_bgerr THEN
               CALL s_errmsg("ima01",l_pmn04,"Update ima881 Error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("upd","ima_file",l_pmn04,"",SQLCA.sqlcode,"","Update ima881 Error",1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF
      #END IF
 
      #轉換成庫存單位
      # Modify By David Wang 93/02/08
      # 更改單價 , 在外量
      LET l_pmn20 = l_pmn20*l_pmn09
      IF cl_null(l_pmn20) THEN LET l_pmn20=0 END IF   #96-05-28
      IF cl_null(l_pmn31) THEN LET l_pmn31=0 END IF   #96-05-28
      IF cl_null(l_pmn31t) THEN LET l_pmn31t=0 END IF #NO.FUN-610018
      SELECT pmm21,pmm43 INTO l_pmm21,l_pmm43
        FROM pmm_file
       WHERE pmm01 = p_pmm01
      #MOD-730044-begin-add
      IF cl_null(l_ima908) THEN LET l_ima908 = l_ima44  END IF
      IF g_sma.sma116 MATCHES '[13]' THEN   
         LET l_ima44 = l_ima908
      END IF   
        IF NOT cl_null(l_pmn86) AND l_pmn86 <> l_ima44 THEN
           LET l_unitrate = 1
           CALL s_umfchk(l_pmn04,l_pmn86,l_ima44)
           RETURNING l_sw,l_unitrate
           IF l_sw THEN
              #單位換算率抓不到 ---#
              CALL cl_err(l_pmn04,'abm-731',1)
              IF NOT cl_confirm('lib-005') THEN 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
           LET l_pmn31  = l_pmn31/l_unitrate
           LET l_pmn31t = l_pmn31t/l_unitrate
        END IF
       #MOD-730044-end-add
     #CALL up_price(l_pmn04,l_pmn87,l_pmn31,l_pmn31t,p_pmm09,l_pmm21,l_pmm43,l_pmn43,l_pmn012,l_pmn46) #No.FUN-610018  #No.FUN-670099  #MOD-730044 modify  #FUN-A60027 add pmn012,pmn46 #FUN-A60076 mark
      CALL up_price(l_pmn04,l_pmn87,l_pmn31,l_pmn31t,p_pmm09,l_pmm21,l_pmm43,l_pmn43,l_pmn012,l_pmn41) #FUN-A60076
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
  #DISPLAY 'update ok'      #CHI-A70049 mark
 
END FUNCTION
 
#FUNCTION up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmm21,p_pmm43,p_pmn43,p_pmn012,p_pmn46)    #No.FUN-610018  #No.FUN-670099  #FUN-A60027 add p_pmn012,p_pmn46  #FUN-A60076
 FUNCTION up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmm21,p_pmm43,p_pmn43,p_pmn012,p_pmn41)    #FUN-A60076 
   DEFINE
      p_part       LIKE pmn_file.pmn04,   #料件編號
      p_qty        LIKE pmn_file.pmn20,   #數量
      p_price      LIKE pmn_file.pmn31,   #本幣單價
      pt_price     LIKE pmn_file.pmn31t,  #本幣含稅單價 FUN-610018
      p_pmm09      LIKE pmm_file.pmm09,
      p_pmm21      LIKE pmm_file.pmm21,   #No.FUN-610018
      p_pmm43      LIKE pmm_file.pmm43,   #No.FUN-610018
      p_pmn43      LIKE pmn_file.pmn43,   #No.FUN-670099
      p_pmn012     LIKE pmn_file.pmn012,  #No.FUN-A60027
     #p_pmn46      LIKE pmn_file.pmn46,   #No.FUN-A60027  #FUN-A60076
      p_pmn41      LIKE pmn_file.pmn41,   #No.FUN-A60076
      l_ecm04      LIKE ecm_file.ecm04,   #No.FUN-670099
      l_new        LIKE pmn_file.pmn31,   # 更新後 Price
      lt_new       LIKE pmn_file.pmn31t,  # 更新後 Tax Price FUN-610018
      l_curr       LIKE pmm_file.pmm22,   #No.FUN-680136 VARCHAR(4) # 更新後 Currency
      l_rate       LIKE pmm_file.pmm42,
     #l_date       LIKE type_file.chr1,   #No.FUN-680136 DATE  #TQC-C40221 mark
      l_date       LIKE type_file.dat,    #TQC-C40221 add
      l_pmh12      LIKE pmh_file.pmh12,
      l_pmh17      LIKE pmh_file.pmh17,   #No.FUN-610018
      l_pmh18      LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh19      LIKE pmh_file.pmh19,   #No.FUN-610018
      ln_pmh17     LIKE pmh_file.pmh17,   #No.FUN-610018
      ln_pmh18     LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh13      LIKE pmh_file.pmh13,
      l_pmh14      LIKE pmh_file.pmh14,
      l_pmhacti    LIKE pmh_file.pmhacti,    #No.MOD-950287 add
      l_price1     LIKE ima_file.ima53,
      l_price2     LIKE ima_file.ima531
   DEFINE l_pmh    RECORD LIKE pmh_file.*
   DEFINE l_ima926 LIKE ima_file.ima926   #NO.FUN-930108
 
   #-----No.FUN-670099-----
   IF p_pmn43 = 0 OR cl_null(p_pmn43) THEN
      LET l_ecm04 = " "
   ELSE
#FUN-A60076--------------------mod--------------------------------------
#      IF g_sma.sma541 = 'Y' AND NOT cl_null(p_pmn012) AND NOT cl_null(p_pmn46) THEN      #FUN-A60027
#         SELECT ecm04 INTO l_ecm04 FROM ecm_file                                         #FUN-A60027
#          WHERE ecm03 = p_pmn43                                                          #FUN-A60027 
#            AND ecm012 = p_pmn012                                                        #FUN-A60027
#            AND ecm013 = p_pmn46                                                         #FUN-A60027   
#      ELSE                                                                               #FUN-A60027
#         SELECT ecm04 INTO l_ecm04 FROM ecm_file
#          WHERE ecm03 = p_pmn43
#      END IF                                                                             #FUN-A60027
      SELECT ecm04 INTO l_ecm04 FROM ecm_file
       WHERE ecm01 = p_pmn41
         AND ecm03 = p_pmn43
         AND ecm012 = p_pmn012 
#FUN-A60076 ---------------mod-------------------------------------------     
   END IF
   #-----No.FUN-670099 END-----
 
#MOD-B90060 -- begin --
   SELECT azi03 INTO g_azi03 FROM azi_file
      WHERE azi01 = g_aza.aza17  AND aziacti matches'[Yy]'
#MOD-B90060 -- end --

   LET l_price1 =0
   LET l_price2 =0
   CASE  g_sma.sma843
      WHEN '1'
         LET l_price1 = p_price*g_pmm42
         LET l_price1 = cl_digcut(l_price1,g_azi03)   #MOD-B90060 add
        #---------No.TQC-690085 add
         IF l_price1 <=0 THEN
            LET l_price1 = g_ima53
         END IF
        #---------No.TQC-690085 end
      WHEN '2'
        #MOD-760015-begin-add
         IF cl_null(g_ima53) THEN
             LET g_ima53 = 0
         END IF
        #MOD-760015-end-add
         IF (p_price*g_pmm42 < g_ima53) OR (g_ima53=0) THEN   #MOD-760015 modify
            LET l_price1 = p_price*g_pmm42
            LET l_price1 = cl_digcut(l_price1,g_azi03)   #MOD-B90060 add
            #-->值為零則不變動
            IF l_price1 <=0 THEN
               LET l_price1 = g_ima53
            END IF
         ELSE
            LET l_price1 = g_ima53
         END IF
      OTHERWISE
         LET l_price1 = g_ima53
   END CASE
   CASE  g_sma.sma844 #採購單發出時, 更新料件主檔市價方式
      WHEN '1'      #無條件
         LET l_price2 = p_price*g_pmm42
         LET l_price2 = cl_digcut(l_price2,g_azi03)   #MOD-B90060 add
         LET l_date   = g_today
        #----------No.TQC-690085 add
         IF l_price2 <= 0 THEN        #單價為零不更新
            LET l_price2 = g_ima531
            LET l_date   = g_ima532
         END IF
        #----------No.TQC-690085 end
      WHEN '2'      #較低
         IF cl_null(g_ima531) THEN
             LET g_ima531 = 0
         END IF
         IF (p_price*g_pmm42 < g_ima531) OR (g_ima531 = 0) THEN #NO:7205
            LET l_price2 = p_price*g_pmm42
            LET l_price2 = cl_digcut(l_price2,g_azi03)   #MOD-B90060 add
            LET l_date   = g_today
            IF l_price2 <= 0 THEN        #單價為零不更新
               LET l_price2 = g_ima531
               LET l_date   = g_ima532
            END IF
         ELSE       #不更新
            LET l_price2 = g_ima531
            LET l_date   = g_ima532
         END IF
      OTHERWISE  #不更新
         LET l_price2 = g_ima531
         LET l_date   = g_ima532
   END CASE
 
   {ckp#4}
   #==>更新料件主檔中的
   UPDATE ima_file SET ima53  = l_price1,
                       ima531 = l_price2,
                       ima532 = l_date,
                       imadate = g_today     #FUN-C30315 add
     WHERE ima01  = p_part
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
#     CALL cl_err('(apmp554:ckp#4)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#      CALL cl_err3("upd","ima_file",p_part,"",SQLCA.sqlcode,"","(apmp554:ckp#4)",1)  #No.FUN-660129
      IF g_bgerr THEN
         CALL s_errmsg("ima01",p_part,"(apmp554:ckp#4)",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("","","","",SQLCA.sqlcode,"","(apmp554:ckp#4)",1)
      END IF
#No.FUN-710030 -- end --
      RETURN
   END IF
 
   {ckp#5}
   #==>如存在[料件/供應商檔]中則更新其最近採購單價
   SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14,pmhacti   #No.FUN-610018   #No.MOD-950287 add pmhacti
     INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14,l_pmhacti      #No.MOD-950287 add pmhacti
     FROM pmh_file
    WHERE pmh01 = p_part AND pmh02 = p_pmm09 AND pmh13=g_pmm22
      AND pmh21 = l_ecm04 AND pmh22 ="1"  #No.FUN-670099
      AND pmh23 = ' '                                             #No.CHI-960033
   #No.TQC-A80053  --Begin                                                      
   #  AND pmhacti = 'Y'                                           #CHI-910021   
   #No.TQC-A80053  --End
 #No.MOD-950287 add --begin
 IF l_pmhacti = 'N' THEN
    LET g_success = 'N'
    IF g_bgerr THEN
       LET g_showmsg = p_part,"/",p_pmm09,"/",g_pmm22,"/",l_ecm04,"/",'1'
       CALL s_errmsg("pmh01,pmh02,pmh13,pmh21,pmh22",g_showmsg,"(apmp554)",'9028',1)
    ELSE
       CALL cl_err(p_part,'9028',1)
    END IF
 ELSE
 #No.MOD-950287 add --end
   IF SQLCA.sqlcode = 0 THEN
      CASE
         WHEN g_sma.sma842 = '1'
            LET l_new = p_price
            LET lt_new = pt_price  #No.FUN-610018
            LET ln_pmh17 = p_pmm21  #No.FUN-610018
            LET ln_pmh18 = p_pmm43  #No.FUN-610018
            LET l_curr= g_pmm22
            LET l_rate= g_pmm42
           #-------------No.TQC-690085 add
            IF l_new <= 0 THEN
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  
               LET ln_pmh17=l_pmh17  
               LET ln_pmh18=l_pmh18  
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
           #-------------No.TQC-690085 end
         WHEN g_sma.sma842 = '2' AND g_pmm22 != l_pmh13
            IF p_price*g_pmm42 < l_pmh12*l_pmh14 THEN
               LET l_new = p_price
               LET lt_new = pt_price  #No.FUN-610018
               LET ln_pmh17 = p_pmm21  #No.FUN-610018
               LET ln_pmh18 = p_pmm43  #No.FUN-610018
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
               IF l_new <= 0 THEN
                  LET l_new = l_pmh12
                  LET lt_new = l_pmh19  #No.FUN-610018
                  LET ln_pmh17=l_pmh17  #No.FUN-610018
                  LET ln_pmh18=l_pmh18  #No.FUN-610018
                  LET l_curr= l_pmh13
                  LET l_rate= l_pmh14
               END IF
            ELSE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  #No.FUN-610018
               LET ln_pmh17=l_pmh17  #No.FUN-610018
               LET ln_pmh18=l_pmh18  #No.FUN-610018
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
         WHEN g_sma.sma842 = '2' AND g_pmm22 = l_pmh13
#           IF p_price < l_pmh12 OR l_pmh12 = 0 THEN                   #No.TQC-7C0125 mark
            IF p_price < l_pmh12 OR pt_price < l_pmh19 OR l_pmh12 = 0 THEN  #No.TQC-7C0125
               LET l_new = p_price
               LET lt_new = pt_price  #No.FUN-610018
               LET ln_pmh17 = p_pmm21  #No.FUN-610018
               LET ln_pmh18 = p_pmm43  #No.FUN-610018
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
               IF l_new <= 0 THEN
                  LET l_new = l_pmh12
                  LET lt_new = l_pmh19  #No.FUN-610018
                  LET ln_pmh17=l_pmh17  #No.FUN-610018
                  LET ln_pmh18=l_pmh18  #No.FUN-610018
                  LET l_curr= l_pmh13
                  LET l_rate= l_pmh14
               END IF
            ELSE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  #No.FUN-610018
               LET ln_pmh17=l_pmh17  #No.FUN-610018
               LET ln_pmh18=l_pmh18  #No.FUN-610018
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
            END IF
        OTHERWISE
            LET l_new = l_pmh12
            LET lt_new = l_pmh19  #No.FUN-610018
            LET ln_pmh17=l_pmh17  #No.FUN-610018
            LET ln_pmh18=l_pmh18  #No.FUN-610018
            LET l_curr= l_pmh13
            LET l_rate= l_pmh14
      END CASE
## No:2930 modify 1998/12/17 -------
      IF p_part[1,4] <>'MISC'
         THEN
         UPDATE pmh_file SET pmh12 = l_new,
                             pmh17 = ln_pmh17, #No.FUN-610018
                             pmh18 = ln_pmh18, #No.FUN-610018
                             pmh19 = lt_new,   #No.FUN-610018
                             pmh13 = l_curr,
                             pmh14 = l_rate,
                             pmhdate = g_today     #FUN-C40009 add
           WHERE pmh01 = p_part AND pmh02 = p_pmm09 AND pmh13=g_pmm22
             AND pmh21 = l_ecm04  #No.FUN-670099
             AND pmh22 = "1"   #No.FUN-670099  
             AND pmh23 = ' '      #No.CHI-960033
         IF SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
#           CALL cl_err('(apmp554:ckp#5)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","pmh_file",p_part,p_pmm09,SQLCA.sqlcode,"","(apmp554:ckp#5)",1)  #No.FUN-660129
            IF g_bgerr THEN
               LET g_showmsg = p_part,"/",p_pmm09
               CALL s_errmsg("pmh01,pmh21,pmh22",g_showmsg,"(apmp554:ckp#5)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pmh_file",p_part,p_pmm09,SQLCA.sqlcode,"","(apmp554:ckp#5)",1)
            END IF
#No.FUN-710030 -- begin --
         END IF
      END IF
    ELSE
      ##No.B434 010423 BY ANN CHEN
      LET l_pmh.pmh01=p_part
      LET l_pmh.pmh02=p_pmm09
      LET l_pmh.pmh03='N'
      IF g_sma.sma102 = 'Y' THEN
#FUN-930108-----start----
         SELECT ima926 INTO l_ima926 FROM ima_file
          WHERE ima01 = p_part
         IF l_ima926 ='Y' THEN
            LET l_pmh.pmh05='1'
         ELSE 
            LET l_pmh.pmh05='0'
         END IF
#FUN-930108-----end------
      ELSE
         LET l_pmh.pmh05='0'
      END IF
      LET l_pmh.pmh06=NULL
      LET l_pmh.pmh10=NULL
      LET l_pmh.pmh11=0
      LET l_pmh.pmh12=p_price
      LET l_pmh.pmh19=pt_price  #No.FUN-610018
      LET l_pmh.pmh17=p_pmm21   #No.FUN-610018
      LET l_pmh.pmh18=P_pmm43   #No.FUN-610018
      LET l_pmh.pmh13=g_pmm22
      LET l_pmh.pmh14=g_pmm42
      LET l_pmh.pmh21=l_ecm04  #No.FUN-670099
      LET l_pmh.pmh22="1"      #No.FUN-670099
      LET l_pmh.pmh23 = ' '     #No,FUN-810016
      LET l_pmh.pmhacti='Y'
      LET l_pmh.pmhuser=g_user
      LET l_pmh.pmhgrup=g_grup
      LET l_pmh.pmhdate = g_today
      SELECT ima100,ima24,ima101,ima102
        INTO l_pmh.pmh09,l_pmh.pmh08,l_pmh.pmh15,l_pmh.pmh16
        FROM ima_file
       WHERE ima01=p_part
      #No.CHI-790003 START
      IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
      #No.CHI-790003 END 
      #INSERT INTO pmh_file(pmh01,pmh02,pmh12,pmh13,pmh14,pmhacti)
      #  VALUES(p_part,p_pmm09,l_new,l_curr,l_rate,'Y')
      LET l_pmh.pmhoriu = g_user      #No.FUN-980030 10/01/04
      LET l_pmh.pmhorig = g_grup      #No.FUN-980030 10/01/04
      LET l_pmh.pmh25 = 'N'           #No.FUN-A90020
      INSERT INTO pmh_file VALUES (l_pmh.*)
      IF STATUS THEN
         LET g_success='N'
#        CALL cl_err('(apmp554:ins#)',STATUS,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("ins","pmh_file","","",STATUS,"","(apmp554:ins#)",1)  #No.FUN-660129
         IF g_bgerr THEN
            LET g_showmsg = l_pmh.pmh01,"/",l_pmh.pmh02,"/",l_pmh.pmh13,"/",l_pmh.pmh21,"/",l_pmh.pmh22
            CALL s_errmsg("pmh01,pmh02,pmh13,pmh21,pmh22",g_showmsg,"(apmp554:ins#)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","pmh_file","","",STATUS,"","(apmp554:ins#)",1)
         END IF
#No.FUN-710030 -- end --
      END IF
      ##No.B434 END
   END IF
 END IF     #No.MOD-950287 add
END FUNCTION
 
FUNCTION p554_pmf(p_pmm01,p_pmm04,p_pmm09)
   DEFINE
      c_cost     LIKE pmm_file.pmm40, #MOD-530190
      l_flag     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      p_pmm01    LIKE pmm_file.pmm01,
      p_pmm04    LIKE pmm_file.pmm04,
      p_pmm09    LIKE pmm_file.pmm09,
      l_pmm02    LIKE pmm_file.pmm02,
      l_azn02    LIKE azn_file.azn02,
      l_azn03    LIKE azn_file.azn03,
      l_azn04    LIKE azn_file.azn04,
      l_azn05    LIKE azn_file.azn05,
      l_cnt      LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   # 判斷是否為 RTN
   SELECT pmm02 INTO l_pmm02 FROM pmm_file
   WHERE pmm01 = p_pmm01 AND pmm18 !='X'
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
#     CALL cl_err('pmm Select:',SQLCA.sqlcode,1)   #No.FUN-660129
      CALL cl_err3("sel","pmm_file",p_pmm01,"",SQLCA.sqlcode,"","pmm Select:",1)  #No.FUN-660129
      RETURN
   END IF
 
   #-->判斷單價是否有為零
   SELECT count(*) INTO l_cnt FROM pmn_file
                             WHERE ( pmn31 <=0 OR pmn44 <=0)
                              AND pmn01 = p_pmm01 AND pmn16 !='9'
   #IF l_cnt > 0 AND l_pmm02 != 'RTN' THEN #FUN-650164 remark
   IF l_cnt > 0  THEN                      #FUN-650164 
      LET g_success = 'N'
      CALL cl_err(p_pmm01,'mfg3525',1)
      RETURN
   END IF
 
   select (pmm40 * pmm42) into c_cost from pmm_file
                         where pmm01 = p_pmm01
   IF cl_null(c_cost) OR c_cost = 0 THEN
      #IF l_pmm02 != 'RTN' THEN  #FUN-650164 remark
         LET g_success = 'N'
         CALL cl_err(p_pmm01,'mfg3526',1)
         RETURN
      #END IF                    #FUN-650164 remark
   END IF
 
   #讀取會計期間
   CALL s_gactpd(p_pmm04) RETURNING l_flag,l_azn02,l_azn03,l_azn04,l_azn05
   IF l_flag = '1' THEN LET g_success = 'N' RETURN END IF
 
 { #==>更新供應商統計資料檔(pmf_file)   97-05-20
   #==>1.當期發出採購單數  2.當期發出採購金額
   #IF l_pmm02 != 'RTN' THEN #FUN-650164 remark
      INSERT INTO pmf_file VALUES (p_pmm09, l_azn02, l_azn03, l_azn04,
                                   1, c_cost, 0,0,0,0,0)
  #FUN-650164 remark--start
   #ELSE
   #   INSERT INTO pmf_file VALUES (p_pmm09, l_azn02, l_azn03, l_azn04,
   #                                0,0,1,0,0,0,0)
   #END IF
  #FUN-650164 remark--end
   IF SQLCA.sqlcode != 0 THEN
      #IF l_pmm02 != 'RTN' THEN  #FUN-650164 remark
         UPDATE pmf_file SET  pmf051 = pmf051 + 1,
                              pmf052 = pmf052 + c_cost
         WHERE pmf01 = p_pmm09  AND pmf02 = l_azn02
         AND pmf03 = l_azn03  AND pmf031 = l_azn04
         IF SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
#           CALL cl_err('(ckp#6)',SQLCA.sqlcode,1)   #No.FUN-660129
            CALL cl_err3("upd","pmf_file",p_pmm09,l_azn02,SQLCA.sqlcode,"","(ckp#6)",1)  #No.FUN-660129
            RETURN
         END IF
     #FUN-650164 remark--start
      #ELSE
      #   UPDATE pmf_file SET  pmf053 = pmf053 + 1
      #   WHERE pmf01 = p_pmm09  AND pmf02 = l_azn02
      #     AND pmf03 = l_azn03  AND pmf031 = l_azn04
      #   IF SQLCA.sqlerrd[3] = 0 THEN
      #      LET g_success = 'N'
#     #      CALL cl_err('(ckp#61)',SQLCA.sqlcode,1)   #No.FUN-660129
      #      CALL cl_err3("upd","pmf_file",pmm09,l_azn02,SQLCA.sqlcode,"","(ckp#61)",1)  #No.FUN-660129
      #      RETURN
      #   END IF
      #END IF
     #FUN-650164 remark --end
   END IF
------------------------}
END FUNCTION
 
FUNCTION p554_sure()
   DEFINE
      l_buf           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(80)
      l_cnt           LIKE type_file.num5,                    #所選擇筆數  #No.FUN-680136 SMALLINT
      l_i             LIKE type_file.num5,                    #所選擇筆數  #No.FUN-680136 SMALLINT
      l_allow_insert  LIKE type_file.num5,                    #可新增否  #No.FUN-680136 SMALLINT
      l_allow_delete  LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
#   CALL cl_getmsg('mfg3149',g_lang) RETURNING l_buf
 
    DISPLAY ARRAY g_pmm  TO  s_pmm.* ATTRIBUTE( COUNT = g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    LET l_cnt = 0
    LET l_ac = 1
    INPUT ARRAY g_pmm WITHOUT DEFAULTS FROM s_pmm.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD sure
          IF NOT cl_null(g_pmm[l_ac].sure) THEN
             IF g_pmm[l_ac].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
          END IF
 
       AFTER INPUT
          LET l_cnt  = 0
          FOR l_i =1 TO g_rec_b
             IF g_pmm[l_i].sure MATCHES "[Yy]" AND
                NOT cl_null(g_pmm[l_i].pmm01)  THEN
                LET l_cnt = l_cnt + 1
             END IF
          END FOR
          DISPLAY l_cnt TO FORMONLY.cn3
 
      ON ACTION CONTROLP
         LET l_ac = ARR_CURR()
         LET g_cmd = "apmt540 ",g_pmm[l_ac].pmm01
         CALL cl_cmdrun_wait(g_cmd)  #No.TQC-6B0125
 
      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
             LET g_pmm[l_i].sure="Y"
         END FOR
         LET l_cnt = g_rec_b
         DISPLAY g_rec_b TO FORMONLY.cn3
 
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b    #將所有的設為選擇
             LET g_pmm[l_i].sure="N"
         END FOR
         LET l_cnt = 0
         DISPLAY 0 TO FORMONLY.cn3
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   RETURN l_cnt
 
   MESSAGE ''
END FUNCTION
