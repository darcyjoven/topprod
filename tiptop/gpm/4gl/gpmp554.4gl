# Prog. Version..: '5.30.06-13.03.12(00009)'     #
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
# Modify.........: No.FUN-650164 06/08/29 By rainy 取消'RTN'判斷
# Modify.........: No.FUN-690009 06/09/14 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930109 09/04/07 By xiaofeizhu 若aoos010勾選使用料件承認申請作業,則此作業不直接產生pmh_file料件承認資料
# Modify.........:                                      都要增加判斷此料件是否需AVL，參數與料件的設定都為'Y',才檢查
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmm DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     #NO.FUN-680145 VARCHAR(1)           # 確定否
            pmm01    LIKE pmm_file.pmm01,     # 採購單號
            pmm04    LIKE pmm_file.pmm04,     # 單據日期
            pmm02    LIKE pmm_file.pmm02,     # 性質
            pmm09    LIKE pmm_file.pmm09,     # 廠商編號
            pmc03    LIKE pmc_file.pmc03,     # 廠商簡稱
            pmm25    LIKE pmm_file.pmm25      #NO.FUN-680145   VARCHAR(10)        # 目前狀況
        END RECORD,
          g_unalc    LIKE type_file.num5,     #NO.FUN-680145 SMALLINT
        g_pmm22      LIKE pmm_file.pmm22,     # Curr
        g_pmm42      LIKE pmm_file.pmm42,     # Ex.Rate
        g_ima53      LIKE ima_file.ima53,
        g_ima531     LIKE ima_file.ima531,
        g_ima532     LIKE ima_file.ima532,
        g_argv1      LIKE pmm_file.pmm01,
        g_argv2      LIKE pmm_file.pmm04,
        g_argv3      LIKE pmm_file.pmm09,
        g_argv4      LIKE azp_file.azp01,
        g_argv5      LIKE azp_file.azp03,
         g_wc        string,  #No.FUN-580092 HCN
         g_sql       string,  #No.FUN-580092 HCN
        g_cmd        LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(60)
        l_exit_sw    LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
        l_sw         LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
        g_rec_b      LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
        l_ac,l_sl    LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE   g_cnt       LIKE type_file.num10    #NO.FUN-680145 INTEGER
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_argv1 = ARG_VAL(1)             #採購單號
   LET g_argv2 = ARG_VAL(2)             #採購日期
   LET g_argv3 = ARG_VAL(3)             #供應廠商
#add 040220 carrier
   LET g_argv4 = ARG_VAL(4)             #azp01
   LET g_argv5 = ARG_VAL(5)             #azp03
#####
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GPM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   IF cl_null(g_argv1) THEN
      CALL p554_tm(0,0)
   ELSE
      DATABASE g_argv5
#      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
      CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
      IF SQLCA.sqlcode THEN
         CALL cl_err('chgdbs',SQLCA.sqlcode,0)
         RETURN
      END IF
      LET g_success = 'Y'
      CALL p554_update(g_argv1,g_argv2,g_argv3)
         IF g_success = 'Y' THEN
            CALL cl_cmmsg(1) COMMIT WORK
         ELSE
            CALL cl_rbmsg(1) ROLLBACK WORK
         END IF
      DATABASE g_dbs
#      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
      CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
#####
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p554_tm(p_row,p_col)
   DEFINE
      p_row,p_col   LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
#       l_time      LIKE type_file.chr8            #No.FUN-6A0098
      l_no,l_cnt    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
      l_pmm18       LIKE pmm_file.pmm18,
      l_pmmmksg     LIKE pmm_file.pmmmksg,
      g_sta         LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 4 END IF
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW p554_w AT p_row,p_col WITH FORM "apm/42f/apmp554"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM
      CALL g_pmm.clear()
      CALL cl_opmsg('q')
        CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
      CONSTRUCT g_wc ON pmm01,pmm04,pmm02,pmm09
       FROM s_pmm[1].pmm01,s_pmm[1].pmm04,s_pmm[1].pmm02,s_pmm[1].pmm09
 
#--NO.MOD-860078 start---
  
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
      END CONSTRUCT
#--NO.MOD-860078 end------- 
 
      IF INT_FLAG THEN LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM 
      END IF
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #        LET g_wc = g_wc clipped," AND pmmuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #        LET g_wc = g_wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #        LET g_wc = g_wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
      #End:FUN-980030
 
      LET g_sql="SELECT 'N',pmm01,pmm04,pmm02,pmm09,pmc03,pmm25,pmm18,pmmmksg",
                "  FROM pmm_file LEFT OUTER JOIN pmc_file  ON pmm_file.pmm09=pmc_file.pmc01",
                " WHERE pmm02 !='SUB' AND pmm18='Y' ",
                " AND pmm25 = '1'"
      LET g_sql = g_sql CLIPPED," AND ", g_wc CLIPPED, " ORDER BY pmm01"
      PREPARE p554_prepare FROM g_sql           # RUNTIME 編譯
      DECLARE p554_cs                         # CURSOR
        CURSOR FOR p554_prepare
 
      CALL cl_opmsg('z')
      LET l_ac = 1
      LET l_exit_sw = 'n'
      LET l_sw = 'y'
      FOREACH p554_cs INTO g_pmm[l_ac].*,l_pmm18,l_pmmmksg
         IF SQLCA.sqlcode THEN
            CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
         CALL SET_COUNT(l_ac)
         LET g_rec_b=l_ac
            DISPLAY g_rec_b TO FORMONLY.cn2
            LET g_cnt = 0
         IF not cl_null(g_pmm[l_ac].pmm25) THEN
            CALL s_pmmsta('pmm',g_pmm[l_ac].pmm25,l_pmm18,l_pmmmksg)
               RETURNING g_pmm[l_ac].pmm25
         END IF
         LET l_ac = l_ac + 1
         LET l_cnt = l_cnt + 1
      END FOREACH
      IF l_cnt = 0 THEN CALL cl_err('','mfg3122',0) CONTINUE WHILE END IF
      LET g_rec_b = l_cnt
      DISPLAY g_rec_b TO FORMONLY.cn2
    # LET g_cnt = l_ac -1
      CALL SET_COUNT(l_ac - 1)
      IF l_ac > 1 THEN
         CALL  p554_sure()         #確定否
         IF l_exit_sw = 'y' THEN EXIT WHILE END IF
         IF l_sw = 'y' THEN
            IF cl_sure(0,0) THEN
               FOR l_no = 1 TO l_cnt
                  LET g_success = 'Y'
                  IF g_pmm[l_no].sure = 'Y'  THEN
                     CALL p554_update(g_pmm[l_no].pmm01,g_pmm[l_no].pmm04,
                                      g_pmm[l_no].pmm09)
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
 
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
      IF l_exit_sw = 'y' THEN EXIT WHILE END IF
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
      l_pmm21   LIKE pmm_file.pmm21,    #No.FUN-610018
      l_pmm43   LIKE pmm_file.pmm43,    #No.FUN-610018
      l_pmn35   LIKE pmn_file.pmn35,
      l_pmn44   LIKE pmn_file.pmn44,
      l_pmn09   LIKE pmn_file.pmn09,
      l_ima37   LIKE ima_file.ima37,
      l_ima44_fac   LIKE ima_file.ima44_fac,
     #l_ima86_fac   LIKE ima_file.ima86_fac,
      l_sql     LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(300)
   BEGIN WORK
   {ckp#1}
   SELECT pmm02 INTO p_pmm02 FROM pmm_file
    WHERE pmm01 = p_pmm01
   #==>更改採購單頭狀況碼,為(已發出)
   IF p_pmm02 != 'BKR' THEN
      UPDATE pmm_file SET pmm25 = '2'
       WHERE pmm01 = p_pmm01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err('(apmp554:ckp#1)',SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF
   {ckp#2}
   #==>更改採購單身狀況碼,為(已發出)
   UPDATE pmn_file SET pmn16 = '2'
    WHERE pmn01 = p_pmm01 AND pmn16 IN ('0','1')
      AND pmn011 != 'BKR'
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      CALL cl_err('(apmp554:ckp#2)',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   {ckp#3}
   #==>更改廠商資料檔中的最近採購日期
   UPDATE pmc_file SET pmc40 = g_today   #最近採購日期
     WHERE pmc01 = p_pmm09
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      CALL cl_err('(apmp554:ckp#3)',SQLCA.sqlcode,1)
      RETURN
   END IF
 
 
   #==>更新[料件主檔]最近採購單價,在外量
   LET l_sql = " SELECT pmn04,pmn31,pmn31t,pmn20,pmn09,",    #No.FUN-610018
               "ima53,ima531,ima532,ima37,pmm22,pmm42,pmn44,pmn35 ",
               " FROM pmn_file,ima_file,pmm_file",
               " WHERE pmn01 = '",p_pmm01,"'",
               "  AND pmm02 != 'SUB' ",
               "   AND pmn01 = pmm01 AND ima01 = pmn04 "
 
   PREPARE p554_pl FROM l_sql
   DECLARE p554_cur2  CURSOR FOR p554_pl
   FOREACH p554_cur2 INTO l_pmn04,l_pmn31,l_pmn31t,l_pmn20,l_pmn09,   #No.FUN-610018
                          g_ima53,g_ima531,g_ima532,
                          l_ima37,g_pmm22,g_pmm42,l_pmn44,l_pmn35
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err('Foreach p554_cur2 :',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      # 93/08/08 Modify By David  --- Today is not a good day
      # if 為期間採購料件 then 更新 最近期間採購日期
      #IF l_ima37 = '5' THEN
         UPDATE ima_file SET ima881 = p_pmm04,
                             imadate = g_today     #FUN-C30315 add
           WHERE ima01 = l_pmn04
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err('Update ima881 Error',SQLCA.sqlcode,1)
            EXIT FOREACH
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
      CALL up_price(l_pmn04,l_pmn20,l_pmn31,l_pmn31t,p_pmm09,l_pmm21,l_pmm43) #No.FUN-610018
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      RETURN
   END IF
 
{  #==>供應商統計資料(pmf_file) 97-05-20
   CALL p554_pmf(p_pmm01,p_pmm04,p_pmm09)
   IF g_success = 'N' THEN
      RETURN
   END IF
}
 
END FUNCTION
 
FUNCTION up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmm21,p_pmm43)    #No.FUN-610018
   DEFINE
      p_part       LIKE pmn_file.pmn04,   #料件編號
      p_qty        LIKE pmn_file.pmn20,   #數量
      p_price      LIKE pmn_file.pmn31,   #本幣單價
      pt_price     LIKE pmn_file.pmn31t,  #本幣含稅單價 FUN-610018
      p_pmm09      LIKE pmm_file.pmm09,
      p_pmm21      LIKE pmm_file.pmm21,   #No.FUN-610018
      p_pmm43      LIKE pmm_file.pmm43,   #No.FUN-610018
      l_new        LIKE pmn_file.pmn31,   # 更新後 Price
      lt_new       LIKE pmn_file.pmn31t,  # 更新後 Tax Price FUN-610018
      l_curr       LIKE pmm_file.pmm22,   #NO.FUN-680145 VARCHAR(4)     # 更新後 Currency
      l_rate       LIKE pmm_file.pmm42,
      l_date       LIKE type_file.dat,    #NO.FUN-680145 DATE
      l_pmh12      LIKE pmh_file.pmh12,
      l_pmh17      LIKE pmh_file.pmh17,   #No.FUN-610018
      l_pmh18      LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh19      LIKE pmh_file.pmh19,   #No.FUN-610018
      ln_pmh17     LIKE pmh_file.pmh17,   #No.FUN-610018
      ln_pmh18     LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh13      LIKE pmh_file.pmh13,
      l_pmh14      LIKE pmh_file.pmh14,
      l_price1     LIKE ima_file.ima53,
      l_price2     LIKE ima_file.ima531
   DEFINE l_pmh    RECORD LIKE pmh_file.*
   DEFINE l_ima926 LIKE ima_file.ima926   #No.FUN-930109 
 
   LET l_price1 =0
   LET l_price2 =0
   CASE  g_sma.sma843
      WHEN '1'
         LET l_price1 = p_price*g_pmm42
      WHEN '2'
         IF p_price*g_pmm42 < g_ima53 THEN
            LET l_price1 = p_price*g_pmm42
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
         LET l_date   = g_today
      WHEN '2'      #較低
         IF cl_null(g_ima531) THEN
             LET g_ima531 = 0
         END IF
         IF (p_price*g_pmm42 < g_ima531) OR (g_ima531 = 0) THEN #NO:7205
            LET l_price2 = p_price*g_pmm42
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
      CALL cl_err('(apmp554:ckp#4)',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   {ckp#5}
   #==>如存在[料件/供應商檔]中則更新其最近採購單價
   SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14    #No.FUN-610018
     INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14 FROM pmh_file
    WHERE pmh01 = p_part AND pmh02 = p_pmm09 AND pmh13=g_pmm22
      AND pmhacti = 'Y'                                           #CHI-910021
   IF SQLCA.sqlcode = 0 THEN
      CASE
         WHEN g_sma.sma842 = '1'
            LET l_new = p_price
            LET ln_pmh17 = p_pmm21  #No.FUN-610018
            LET ln_pmh18 = p_pmm43  #No.FUN-610018
            LET lt_new = pt_price  #No.FUN-610018
            LET l_curr= g_pmm22
            LET l_rate= g_pmm42
         WHEN g_sma.sma842 = '2' AND g_pmm22 != l_pmh13
            IF p_price*g_pmm42 < l_pmh12*l_pmh14 THEN
               LET l_new = p_price
               LET ln_pmh17 = p_pmm21  #No.FUN-610018
               LET ln_pmh18 = p_pmm43  #No.FUN-610018
               LET lt_new = pt_price  #No.FUN-610018
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
            IF p_price < l_pmh12 OR l_pmh12 = 0 THEN
               LET l_new = p_price
               LET ln_pmh17 = p_pmm21  #No.FUN-610018
               LET ln_pmh18 = p_pmm43  #No.FUN-610018
               LET lt_new = pt_price  #No.FUN-610018
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
                             pmh19 = lt_new,  #No.FUN-610018
                             pmh13 = l_curr,
                             pmh14 = l_rate,
                             pmhdate = g_today     #FUN-C40009 add
           WHERE pmh01 = p_part AND pmh02 = p_pmm09 AND pmh13=g_pmm22
         IF SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err('(apmp554:ckp#5)',SQLCA.sqlcode,1)
         END IF
      END IF
    ELSE
      ##No.B434 010423 BY ANN CHEN
      LET l_pmh.pmh01=p_part
      LET l_pmh.pmh02=p_pmm09
      LET l_pmh.pmh03='N'
      IF g_sma.sma102 = 'Y' THEN
#FUN-930109--Begin--#
         SELECT ima926 INTO l_ima926 FROM ima_file 
          WHERE ima01 = p_part
         IF l_ima926='Y' THEN
            LET l_pmh.pmh05='1'
         ELSE
            LET l_pmh.pmh05='0'
         END IF
#FUN-930109--End--#
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
      LET l_pmh.pmh25='N'   #No:FUN-AA0015
      INSERT INTO pmh_file VALUES (l_pmh.*)
      IF STATUS THEN
         LET g_success='N'
         CALL cl_err('(apmp554:ins#)',STATUS,1)
      END IF
      ##No.B434 END
   END IF
END FUNCTION
 
FUNCTION p554_pmf(p_pmm01,p_pmm04,p_pmm09)
   DEFINE
      c_cost     LIKE pmm_file.pmm40,    #NO.FUN-680145 DECIMAL(13,3)
      l_flag     LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
      p_pmm01    LIKE pmm_file.pmm01,
      p_pmm04    LIKE pmm_file.pmm04,
      p_pmm09    LIKE pmm_file.pmm09,
      l_pmm02    LIKE pmm_file.pmm02,
      l_azn02    LIKE azn_file.azn02,
      l_azn03    LIKE azn_file.azn03,
      l_azn04    LIKE azn_file.azn04,
      l_azn05    LIKE azn_file.azn05,
      l_cnt      LIKE type_file.num5     #NO.FUN-680145 SMALLINT
 
   # 判斷是否為 RTN
   SELECT pmm02 INTO l_pmm02 FROM pmm_file
   WHERE pmm01 = p_pmm01 AND pmm18 !='X'
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('pmm Select:',SQLCA.sqlcode,1)
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
      #IF l_pmm02 != 'RTN' THEN    #FUN-650164 remark 
         LET g_success = 'N'
         CALL cl_err(p_pmm01,'mfg3526',1)
         RETURN
      #END IF                      #FUN-650164 remark
   END IF
 
   #讀取會計期間
   CALL s_gactpd(p_pmm04) RETURNING l_flag,l_azn02,l_azn03,l_azn04,l_azn05
   IF l_flag = '1' THEN LET g_success = 'N' RETURN END IF
 
 { #==>更新供應商統計資料檔(pmf_file)   97-05-20
   #==>1.當期發出採購單數  2.當期發出採購金額
   #IF l_pmm02 != 'RTN' THEN  #FUN-650164 remark
      INSERT INTO pmf_file VALUES (p_pmm09, l_azn02, l_azn03, l_azn04,
                                   1, c_cost, 0,0,0,0,0)
  #FUN-650164 remark--start
   #ELSE
   #   INSERT INTO pmf_file VALUES (p_pmm09, l_azn02, l_azn03, l_azn04,
   #                                0,0,1,0,0,0,0)
   #END IF
  #FUN-650164 remark--end
   IF SQLCA.sqlcode != 0 THEN
      #IF l_pmm02 != 'RTN' THEN   #FUN-650164 remark
         UPDATE pmf_file SET  pmf051 = pmf051 + 1,
                              pmf052 = pmf052 + c_cost
         WHERE pmf01 = p_pmm09  AND pmf02 = l_azn02
         AND pmf03 = l_azn03  AND pmf031 = l_azn04
         IF SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err('(ckp#6)',SQLCA.sqlcode,1)
            RETURN
         END IF
     #FUN-650164 remark--start
      #ELSE
      #   UPDATE pmf_file SET  pmf053 = pmf053 + 1
      #   WHERE pmf01 = p_pmm09  AND pmf02 = l_azn02
      #     AND pmf03 = l_azn03  AND pmf031 = l_azn04
      #   IF SQLCA.sqlerrd[3] = 0 THEN
      #      LET g_success = 'N'
      #      CALL cl_err('(ckp#61)',SQLCA.sqlcode,1)
      #      RETURN
      #   END IF
      #END IF
     #FUN-650164 reamrk--end
   END IF
------------------------}
END FUNCTION
 
FUNCTION p554_sure()
   DEFINE
      l_buf        LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(80)
      l_sl2        LIKE type_file.num5,    #NO.FUN-680145 SMALLINT    #screen array no
      l_cnt        LIKE type_file.num5,    #NO.FUN-680145 SMALLINT    #所選擇筆數
      l_cnt1       LIKE type_file.num5,    #NO.FUN-680145 SMALLINT    #所選擇筆數
      l_ok         LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
 
   CALL cl_getmsg('mfg3149',g_lang) RETURNING l_buf
   MESSAGE l_buf CLIPPED
   DISPLAY ARRAY g_pmm  TO  s_pmm.*
      ON ACTION CONTROLM
         LET l_ac = ARR_CURR()
         LET l_sl = SCR_LINE()
         IF g_pmm[l_ac].sure = 'N' THEN
            LET g_pmm[l_ac].sure = 'Y'
            LET g_cnt = g_cnt + 1
         ELSE
            LET g_pmm[l_ac].sure = 'N'
            LET g_cnt = g_cnt - 1
         END IF
         DISPLAY g_pmm[l_ac].sure TO s_pmm[l_sl].sure
 
      ON ACTION CONTROLP
         LET l_ac = ARR_CURR()
         LET g_cmd = "apmt540 ",g_pmm[l_ac].pmm01
      ON ACTION CONTROLY
         IF l_cnt=0 THEN
            LET l_ok='Y'
            LET l_cnt=g_cnt                     #設定已選筆數
         ELSE
            LET l_ok=NULL
            LET l_cnt=0                         #設定已選筆數
         END IF
         LET l_cnt1=0
         LET l_sl2=ARR_CURR()-SCR_LINE()+1
         LET l_sl=0
         FOR l_ac = 1 TO g_cnt                   #將所有的設為選擇
            IF l_ac=l_sl2 THEN
               LET l_sl=1
            ELSE
               IF l_ac > l_sl2 THEN
                  LET l_sl=l_sl+1
               END IF
            END IF
            LET g_pmm[l_ac].sure = l_ok
            #在這裡判斷是否在螢幕顯示範圍內
            IF l_sl < 11 AND l_sl > 0 THEN
               DISPLAY g_pmm[l_ac].sure   TO s_pmm[l_ac].sure
            END IF
            LET l_cnt1 = l_cnt1 + 1
         END FOR
 
      ON ACTION CONTROLN
         LET l_exit_sw = 'n'
         LET l_sw = 'n'
         CLEAR FORM
   CALL g_pmm.clear()
         EXIT DISPLAY
      ON ACTION CONTROLV
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
#--NO.MOD-860078 start---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE  DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
#--NO.MOD-860078 end------- 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   MESSAGE ''
   IF INT_FLAG THEN LET INT_FLAG = 0  LET l_exit_sw = 'y' END IF
END FUNCTION
