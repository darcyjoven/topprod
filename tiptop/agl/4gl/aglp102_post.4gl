# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern........: aglp102_post(p_bookno,p_bdate,p_edate,bno,p_eno)
# Descriptions...: 輸入要過帳的起始、截止的日期、起始傳票單號、截止傳票單號
# Input Parameter: p_bookno  帳別
#                  p_bdate   起始日期
#                  p_edate   截止日期
#                  p_bno     起始傳票編號
#                  p_eno     截止傳票編號
# Memo...........: 請檢查g_success看是否成功
# Date & Author..: 92/03/06 BY MAY
# Modify.........: By Melody    增傳'過帳否'及'輸入人員範圍'兩參數
# Modify.........: By Melody    aee00 改為 no-use
# Modify.........: 97/04/17 By Melody 加判斷 aba02 不可 <= aaa07 關帳日期
# Modify.........: 97/07/09 By Roger  考慮 Multi_user Posting: 架構變更
# Modify.........: No:BUG-470041(MOD-470573) 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No:FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570019 05/07/04 By day    傳票編號加大
# Modify.........: No:FUN-5C0015 060104 BY GILL (1)多增加處理abb31~37
#                  (2)傳aag15~18，aag31~37，給aec052、aed012、aee021、ted012
# Modify.........: No.FUN-640004 06/04/06 By Carrier 將帳套放大至5碼
# Modify.........: No:FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No:TQC-670004 06/07/12 By Ray 修改當過帳出現錯誤訊息后warning message無法關掉的bug
# Modify.........: No.MOD-680034 06/08/08 By Smapmin INSERT INTO aea_file時,若資料重複則不做insert動作
# Modify.........: No:FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No:CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No:FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No:TQC-7A0083 07/10/23 By chenl  增加回寫aba38字段
# Modify.........: No:MOD-7C0040 07/12/05 By Smapmin 背景處理時不可有畫面出現
# Modify.........: No.FUN-810069 08/03/04 By lynn 過賬時會更新afc_file,因afc_file調整了KEY值要做修正
# Modify.........: No:FUN-840074 08/04/17 By Carrier 項目預算管理
# Modify.........: No.CHI-840052 08/05/02 By Carol 科目做部門管理時空白部間也應寫入aao_file
# Modify.........: No:MOD-870067 08/07/07 BY chenl 修正部分變量定義錯誤。
# Modify.........: No:FUN-920155 09/02/20 By shiwuying 程序名稱由s_post改為aglp102_post
# Modify.........: No:MOD-950051 09/05/07 By wujie 當aza08 =N時，若abb08,abb35=NULL，則賦值' '
# Modify.........: No:FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-980292 09/09/17 By Sarah 過帳前,先將該筆傳票lock住,以免有別人同時做過帳動作,會重覆將該張傳票過到餘額檔
# Modify.........: No:FUN-9A0052 09/11/17 By Carrier 增加'科目核算項'統計檔功能
# Modify.........: No:MOD-9C0103 09/12/23 By sabrina 寫入afc_file時，abb35/abb05/abb08若為NULL值給預設值' ' 
# Modify.........: No.MOD-A70163 10/07/21 By sabrina 已過帳重新過帳aglp103時，不可再回寫過帳人
# Modify.........: No.MOD-A70168 10/07/22 By Dido WEB 作業時不可使用 DISPLAY 至背景 
# Modify.........: No.TQC-AB0113 10/11/29 By lixia 已拋轉憑證的憑證再次過帳不應顯示拋轉成功
# Modify.........: No.FUN-B10009 11/01/07 By Carrier aeh_file增加aehlegal字段
# Modify.........: No.MOD-B30349 11/03/15 By Dido 異動碼9/10改用原單身 abb35/abb36 寫入相關檔案
# Modify.........: No.TQC-B30141 11/03/17 By Elva 帐结时CE凭证过账和一般凭证过账一样处理
# Modify.........: No.TQC-B50148 11/05/25 By yinhy FUNCTION aeg_ins(p_key)，INSERT INTO aeg_file時，p_keyk應改為p_key
# Modify.........: No.MOD-B80056 11/08/05 By Polly 將l_sql、p_wc型態改為STRING
# Modify.........: No.MOD-BA0179 11/10/27 By Dido 新增 aec_file 時,aec052 若為 null 有誤 
# Modify.........: No.MOD-CA0081 12/10/16 by Polly 批次過帳時，就需luck tabke動作，避免有未確認但已過帳錯誤
# Modify.........: No.MOD-C90261 12/12/18 By Polly 分錄內的科目為資產類科目(aag04=1)且分錄的類別為FA(固資系統)，
#                                                  即使該會科有設定預算控管，亦不應進入預算檢核的程式段
# Modify.........: No.TQC-D10071 13/01/18 by apo 計算上層統制科目科餘時,上層統制科目(aag08)與自己(aag01)相同時離開迴圈 
# Modify.........: NO.CHI-C70044 13/01/30 by Lori 預算afc07 回寫時，需一併回寫科目總預算資料
# Modify.........: NO.MOD-D70108 13/07/16 by fengmy 憑證過帳失敗，沒有任何提示
# Modify.........: NO.MOD-D80024 13/08/06 By fengmy 月結為表結年結為賬結時,累計盈虧科目所在憑證要過帳
# Modify.........: NO.MOD-D90023 13/09/04 By fengmy aee04的值非摘要，是核算項對應的值
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_aaa        RECORD LIKE aaa_file.*
DEFINE g_aag        RECORD LIKE aag_file.*
DEFINE g_aba        RECORD LIKE aba_file.*
DEFINE g_abb        RECORD LIKE abb_file.*
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680098 integer
DEFINE g_msg        LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(72)
DEFINE g_forupd_sql STRING                  #TQC-980292 add

FUNCTION aglp102_post(p_bookno,p_bdate,p_edate,p_bno,p_eno,p_post,p_wc)#No.FUN-920155
   DEFINE p_bookno	LIKE aaa_file.aaa01   #No.FUN-640004
   DEFINE p_bdate	LIKE aba_file.aba02   #No.FUN-680098 date
   DEFINE p_edate	LIKE aba_file.aba02   #No.FUN-680098 date
   DEFINE p_bno		LIKE aba_file.aba01   #No.FUN-570019
   DEFINE p_eno		LIKE aba_file.aba01   #No.FUN-570019
   DEFINE p_post	LIKE type_file.chr1     #過帳否 #No.FUN-680098  VARCHAR(1)
  #DEFINE p_wc          LIKE type_file.chr1000              #No.FUN-680098  VARCHAR(600)  #No.MOD-B80056 mark
   DEFINE p_wc          STRING                              #No.MOD-B80056 add
  #DEFINE l_sql         LIKE type_file.chr1000              #No.FUN-680098  VARCHAR(600)  #No.MOD-B80056 mark
   DEFINE l_sql         STRING                              #No.MOD-B80056 add
   DEFINE l_cnt,l_cnt1,l_cnt2,l_cnt3 LIKE type_file.num5    #No.FUN-680098  smallint
   DEFINE p_row,p_col LIKE type_file.num5                   #No.FUN-680098 smallint
   DEFINE l_flag        LIKE type_file.chr1  #TQC-AB0113

   WHENEVER ERROR CONTINUE

   IF g_bgjob = 'N'  THEN    #MOD-7C0040
      OPEN WINDOW post_g_w WITH FORM "agl/42f/aglp102_post"    #No.FUN-920155
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
      CALL cl_ui_locale("aglp102_post")    #No.FUN-920155
   END IF   #MOD-7C0040

   LET g_forupd_sql = "SELECT * FROM aba_file WHERE aba01 = ? AND aba00 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aglp102_post_cl CURSOR FROM g_forupd_sql

   SELECT * INTO g_aaa.* FROM aaa_file where aaa01=p_bookno

   #設定資料選擇條件
   LET l_sql = "SELECT * FROM aba_file",
               " WHERE (aba02 BETWEEN '",p_bdate,"' AND '",p_edate,"')",
               "   AND aba00 ='",p_bookno,"'",
               "   AND abapost = '",p_post,"'",     # 96-07-01 是否已過帳
               "   AND aba19 = 'Y'",        # 98-06-02 傳票是否已確認
               "   AND abaacti = 'Y'",
               "   AND ",p_wc CLIPPED               # 96-07-01 輸入人員範圍
   #若有傳起始傳票單號時.....
   IF NOT cl_null(p_bno) THEN
      LET l_sql  = l_sql CLIPPED, " AND aba01 >= '",p_bno,"'"
   END IF

   #若有傳截止傳票單號時.....
   IF NOT cl_null(p_eno) THEN
      LET l_sql  = l_sql CLIPPED, " AND aba01 <= '",p_eno,"'"
   END IF
   LET l_sql = l_sql CLIPPED, " ORDER BY aba02,aba01"

    DISPLAY l_sql
   PREPARE post_prepare FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) RETURN END IF
   DECLARE post_cur CURSOR FOR post_prepare

   LET l_cnt = 0 LET l_cnt1 = 0 LET l_cnt2 = 0 LET l_cnt3 = 0
   IF g_bgjob = 'N'  THEN    #MOD-7C0040
      DISPLAY l_cnt  TO FORMONLY.count
      DISPLAY l_cnt1 TO FORMONLY.count1
      DISPLAY l_cnt2 TO FORMONLY.count2
      DISPLAY l_cnt3 TO FORMONLY.count3
      CALL ui.Interface.refresh()                  #No:MOD-520088
   #-----MOD-7C0040----------
   ELSE
      DISPLAY "l_cnt=",l_cnt
      DISPLAY "l_cnt1=",l_cnt1
      DISPLAY "l_cnt2=",l_cnt2
      DISPLAY "l_cnt3=",l_cnt3
   END IF
   LET l_flag = '0'   #TQC-AB0113
   DISPLAY 'OK1'
   FOREACH post_cur INTO g_aba.*
      DISPLAY 'OK2'
      IF STATUS THEN
        IF g_bgerr THEN
          LET g_showmsg=p_bookno,"/",p_post,"/",'Y',"/",'Y'
         #CALL s_errmsg('aba00,abapost,aba19,abaacti',g_showmsg,'fore aba:',STATUS,0)  #MOD-D70108 mark
          CALL s_errmsg('aba00,abapost,aba19,abaacti',g_showmsg,'fore aba:',STATUS,1)  #MOD-D70108
        ELSE
         CALL cl_err('fore aba:',STATUS,1)
        END IF
         RETURN
      END IF
      LET l_flag = '1'      #TQC-AB0113
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF
      #TQC-B30141 --begin
     #IF g_aba.aba01[1,g_doc_len]='EOM' OR g_aba.aba01[1,g_doc_len]=g_aaz.aaz65 OR   #No.FUN-570019
     #   g_aba.aba06='CE' THEN CONTINUE FOREACH
     #END IF
      #TQC-B30141 --end
     #-------------------------MOD-CA0081---------------------(S)
     #先把要過帳的這筆傳票LOCK住,以免發生同時有另一個人也執行過帳
      OPEN aglp102_post_cl USING g_aba.aba01,g_aba.aba00
      IF STATUS THEN
         CALL cl_err("OPEN aglp102_post_cl:", STATUS, 1)
         CLOSE aglp102_post_cl
         CONTINUE FOREACH
      END IF
      FETCH aglp102_post_cl INTO g_aba.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK
         CLOSE aglp102_post_cl
         CONTINUE FOREACH
      END IF

      IF g_aba.aba19 <> 'Y' OR g_aba.abaacti <> 'Y' THEN   #需確認
         CLOSE aglp102_post_cl
         CONTINUE FOREACH
      END IF

      IF g_aba.aba01[1,g_doc_len]='EOM' OR
         g_aba.aba01[1,g_doc_len]=g_aaz.aaz65 OR   #No.FUN-570019
         g_aba.aba06='CE' THEN
         #CLOSE aglp102_post_cl  #mark by dengsy161018
         #CONTINUE FOREACH   #mark by dengsy161018
      END IF
     #-------------------------MOD-CA0081---------------------(E)
      IF g_bgjob = 'N'  THEN    #MOD-7C0040
         DISPLAY g_aba.aba02 TO FORMONLY.aba02
         DISPLAY g_aba.aba01 TO FORMONLY.aba01
      #-----MOD-7C0040---------
      ELSE
         DISPLAY "g_aba.aba02=",g_aba.aba02
         DISPLAY "g_aba.aba01=",g_aba.aba01
      END IF
      #-----END MOD-7C0040-----
       CALL ui.Interface.refresh()                  #No:MOD-520088
    #--------------------------MOD-CA0081------------------------mark
    # #----------------------------------------------------------------------
    # # 可能資料恰巧已被post/del/upd所以重讀 (V2.0此處有漏洞,易造成過帳錯誤)
    # SELECT * INTO g_aba.* FROM aba_file
    #        WHERE aba01=g_aba.aba01 AND aba00=g_aba.aba00
    # IF STATUS THEN
    #    #CALL cl_err('sel aba:',STATUS,1) # NO.FUN-660123
    #    #CALL cl_err3("sel","aba_file",g_aba.aba00,g_aba.aba01,STATUS,"","sel aba:",1)  # NO.FUN-660123 #NO.FUN-710023
    #    #NO.FUN-710023--BEGIN
    #     IF g_bgerr THEN
    #        LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
    #        CALL s_errmsg('aba01,aba00',g_showmsg,'sel aba:',STATUS,0)
    #     ELSE
    #        CALL cl_err3("sel","aba_file",g_aba.aba00,g_aba.aba01,STATUS,"","sel aba:",1)
    #     END IF
    #    #NO.FUN-710023--END
    #     CONTINUE FOREACH
    # END IF
    #--------------------------MOD-CA0081------------------------mark
      IF g_aba.abamksg='Y' AND g_aba.aba20<>'1'   #需簽核,未簽完
         THEN
         #-MOD-D70108-str
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
            CALL s_errmsg('abb01,abb00',g_showmsg,'','aim-317',1)
         ELSE
            CALL cl_err('','aim-317',1)
         END IF
         #-MOD-D70108-str
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
         CONTINUE FOREACH
      END IF
#     IF STATUS THEN CALL cl_err('sel aba:',STATUS,1) CONTINUE FOREACH END IF    #NO.FUN-710023
    #--------------------------MOD-CA0081------------------------mark
    ##NO.FUN-710023--BEGIN
    # IF STATUS THEN
    #    IF g_bgerr THEN
    #       LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
    #       CALL s_errmsg('aba01,aba00',g_showmsg,'sel aba:',STATUS,0) CONTINUE FOREACH
    #    ELSE
    #       CALL cl_err('sel aba:',STATUS,1)  CONTINUE FOREACH
    #    END IF
    # END IF
    ##NO.FUN-710023--END
    #--------------------------MOD-CA0081------------------------mark
      IF g_aba.abapost<>p_post THEN
         {CALL cl_err('sel aba:','aar-347',1)} 
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
         CONTINUE FOREACH
      END IF
      #----------------------------------------------------------------------
      IF g_aba.aba01[g_no_sp,g_no_ep]=' ' OR     #No.FUN-570019
         g_aba.aba03 IS NULL OR g_aba.aba04 IS NULL THEN
#        CALL cl_err('aba01/03/04 is null','agl-027',1) CONTINUE FOREACH
#NO.FUN-710023--BEGIN
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
           #CALL s_errmsg('aba01,aba00',g_showmsg,'aba01/03/04 is null','agl-027',0)  CONTINUE FOREACH  #MOD-D70108 mark
            CALL s_errmsg('aba01,aba00',g_showmsg,'aba01/03/04 is null','agl-027',1)  CONTINUE FOREACH  #MOD-D70108
         ELSE
            CALL cl_err('aba01/03/04 is null','agl-027',1)  CONTINUE FOREACH 
         END IF
#NO.FUN-710023--END
      END IF
      IF g_aba.aba02<=g_aaa.aaa07 THEN 			# 小於關帳年月
#        CALL cl_err('aba02<aaa07','agl-200',1) CONTINUE FOREACH #NO.FUN-710023
#NO.FUN-710023--BEGIN
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
           #CALL s_errmsg('aba01,aba00',g_showmsg,'aba02<aaa07','agl-200',0) CONTINUE FOREACH   #MOD-D70108 mark
            CALL s_errmsg('aba01,aba00',g_showmsg,'aba02<aaa07','agl-200',1) CONTINUE FOREACH   #MOD-D70108
         ELSE
            CALL cl_err('aba02<aaa07','agl-200',1)  CONTINUE FOREACH
         END IF
#NO.FUN-710023--END
      END IF
      IF g_aba.aba08 != g_aba.aba09 OR			# 借貸不平衡
         g_aba.aba08 IS NULL OR g_aba.aba09 IS NULL THEN
         LET l_cnt1 = l_cnt1 + 1
         IF g_bgjob = 'N'  THEN    #MOD-7C0040
            DISPLAY l_cnt1 TO FORMONLY.count1
         ELSE   #MOD-7C0040
            DISPLAY "l_cnt1=",l_cnt1   #MOD-7C0040
         END IF   #MOD-7C0040
         CONTINUE FOREACH
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
      END IF
      IF g_aba.abamksg='Y' AND g_aba.abasmax > g_aba.abasseq THEN
         LET l_cnt2 = l_cnt2 + 1				# 應簽未簽
         IF g_bgjob = 'N'  THEN    #MOD-7C0040
            DISPLAY l_cnt2 TO FORMONLY.count2
         ELSE   #MOD-7C0040
            DISPLAY "l_cnt2=",l_cnt2   #MOD-7C0040
         END IF   #MOD-7C0040
         CONTINUE FOREACH
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
      END IF
      IF g_aba.abamksg='Y' AND(g_aba.aba20='0' OR g_aba.aba20 IS NULL)THEN
         LET l_cnt2 = l_cnt2 + 1				# 應簽未簽
         IF g_bgjob = 'N'  THEN    #MOD-7C0040
            DISPLAY l_cnt2 TO FORMONLY.count2
         ELSE   #MOD-7C0040
            DISPLAY "l_cnt2=",l_cnt2   #MOD-7C0040
         END IF   #MOD-7C0040
         CONTINUE FOREACH
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
      END IF
      IF g_aaz.aaz80='N' AND g_aba.abaprno=0 THEN
         LET l_cnt3 = l_cnt3 + 1				# 應印未印
         IF g_bgjob = 'N'  THEN    #MOD-7C0040
            DISPLAY l_cnt3 TO FORMONLY.count3
         ELSE   #MOD-7C0040
            DISPLAY "l_cnt3=",l_cnt3   #MOD-7C0040
         END IF   #MOD-7C0040
         CONTINUE FOREACH
         CLOSE aglp102_post_cl                    #MOD-CA0081 add
      END IF
    #--------------------------MOD-CA0081------------------------mar
    ##str TQC-980292 add
    ##先把要過帳的這筆傳票LOCK住,以免發生同時有另一個人也執行過帳
    # OPEN aglp102_post_cl USING g_aba.aba01,g_aba.aba00
    # IF STATUS THEN
    #    CALL cl_err("OPEN aglp102_post_cl:", STATUS, 1)
    #    CLOSE aglp102_post_cl
    #    CONTINUE FOREACH
    # END IF
    # FETCH aglp102_post_cl INTO g_aba.*
    # IF SQLCA.sqlcode THEN
    #    CALL cl_err(g_aba.aba01,SQLCA.sqlcode,0)          #資料被他人LOCK
    #    CLOSE aglp102_post_cl
    #    CONTINUE FOREACH
    # END IF
    ##end TQC-980292 add
    #--------------------------MOD-CA0081------------------------mar
      #-------------------------------------------------------- 開始過帳
      CALL upd_abapost()
      IF g_success='N' THEN EXIT FOREACH END IF
      CALL s_post_abb()
      IF g_success='N' THEN EXIT FOREACH END IF
      #-------------------------------------------------------- 過帳成功
      LET l_cnt = l_cnt + 1
      IF g_bgjob = 'N'  THEN    #MOD-7C0040
         DISPLAY l_cnt TO FORMONLY.count
      ELSE   #MOD-7C0040
         DISPLAY "l_cnt=",l_cnt   #MOD-7C0040
      END IF   #MOD-7C0040
      CLOSE aglp102_post_cl   #TQC-980292 add
   END FOREACH
#NO.FUN-710023--BEGIN
  IF g_totsuccess="N" THEN
    LET g_success="N"
  END IF
#NO.FUN-710023--END
#TQC-AB0113--add--str--
  IF l_flag = '0' THEN
     DISPLAY 'OK3'
     LET g_success = 'N'
     CALL cl_err('','agl-118',1)
     RETURN  #FUN-B30166
  END IF
#TQC-AB0113--add--end--
   UPDATE aaa_file SET aaa06 = g_today WHERE  aaa01 = p_bookno
   IF STATUS THEN
#     CALL cl_err('upd aaa06:',STATUS,1) #No.FUN-660123
#     CALL cl_err3("upd","aaa_file",p_bookno,"",STATUS,"","upd aaa06:",1)  # NO.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('aaa01','p_bookno','upd aaa06:',STATUS,1)
      ELSE
         CALL cl_err3("upd","aaa_file",p_bookno,"",STATUS,"","upd aaa06:",1)
      END IF
   END IF
#NO.FUN-710023--END
       LET g_success='N'
   END IF
   SET LOCK  MODE  TO NOT WAIT
   IF g_bgjob = 'N' THEN   #MOD-7C0040
      CALL cl_end(0,0)
   END IF   #MOD-7C0040
   CLOSE WINDOW post_g_w
END FUNCTION

FUNCTION upd_abapost()


   IF g_aba.abapost = 'N' THEN        #MOD-A70163 add
      UPDATE aba_file SET abapost='Y' ,
                          aba38 = g_user    #No.TQC-7A0083
       WHERE aba01=g_aba.aba01 AND aba00=g_aba.aba00
   END IF                             #MOD-A70163 add
   IF STATUS THEN
#     CALL cl_err('upd abapost:',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","aba_file",g_aba.aba01,g_aba.aba00,SQLCA.sqlcode,"","upd abapost:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
        LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
        CALL s_errmsg('aba01,aba00',g_showmsg,'upd abapost:',STATUS,1)
      ELSE
        CALL cl_err3("upd","aba_file",g_aba.aba01,g_aba.aba00,SQLCA.sqlcode,"","upd abapost:",1)   #No.FUN-660123 #NO.FUN-710023
      END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION s_post_abb()
   DECLARE s_post_abb_c CURSOR FOR
         SELECT * FROM abb_file,aag_file
                WHERE abb01=g_aba.aba01 AND abb00=g_aba.aba00 AND abb00 = aag00 AND abb03=aag01     #No.FUN-740020
   FOREACH s_post_abb_c INTO g_abb.*, g_aag.*
      IF g_bgjob = 'N'  THEN    #MOD-7C0040
         DISPLAY g_abb.abb02 TO FORMONLY.abb02  #TQC-980292 mark     #MOD-A70168 remark
        #DISPLAY "g_abb.abb02=",g_abb.abb02     #TQC-980292          #MOD-A70168 mark
      ELSE    #MOD-7C0040
         DISPLAY "g_abb.abb02=",g_abb.abb02   #MOD-7C0040
      END IF   #MOD-7C0040
      IF STATUS THEN
#        CALL cl_err('fore abb',STATUS,1)  #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
            CALL s_errmsg('abb01,abb00',g_showmsg,'fore abb',STATUS,1)
         ELSE
            CALL cl_err('fore abb',STATUS,1)
         END IF
#NO.FUN-710023--END
         LET g_success='N'
         RETURN
      END IF
      IF g_bgjob = 'N'  THEN    #MOD-7C0040
         DISPLAY g_aba.aba02 TO FORMONLY.aba02
         DISPLAY g_aba.aba01 TO FORMONLY.aba01
      ELSE   #MOD-7C0040
         DISPLAY "g_aba.aba02=",g_aba.aba02   #MOD-7C0040
         DISPLAY "g_aba.aba01=",g_aba.aba01   #MOD-7C0040
      END IF   #MOD-7C0040
      IF g_aag.aag01 IS NULL THEN
#        CALL cl_err('aag01=null','aap-262',1) LET g_success='N' RETURN
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            CALL s_errmsg(' ',' ','aag01=null','aap-262',1)
         ELSE
            CALL cl_err('aag01=null','aap-262',1)
         END IF
#NO.FUN-710023--END
         LET g_success='N'
      END IF
      IF g_aag.aag07='2' AND g_aag.aag08 IS NULL THEN
#         CALL cl_err('aag07=2 aag08=null','agl-179',1) LET g_success='N' RETURN #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            CALL s_errmsg(' ',' ','aag07=2 aag08=null','agl-179',1)
          ELSE
            CALL cl_err('aag07=2 aag08=null','agl-179',1)
          END IF
#NO.FUN-710023--END
          LET g_success='N'
      END IF
      CALL s_post_aah(g_aag.aag07,g_aag.aag08)
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_aas(g_aag.aag07,g_aag.aag08)
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_aao(g_aag.aag07,g_aag.aag08)
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_afc()
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_aea()
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_aed()
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_aef()
                      IF g_success='N' THEN RETURN END IF
      #no.A002外幣管理
      CALL s_post_tah(g_aag.aag07,g_aag.aag08)
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_tas(g_aag.aag07,g_aag.aag08)
                      IF g_success='N' THEN RETURN END IF
      CALL s_post_tao(g_aag.aag07,g_aag.aag08)
                      IF g_success='N' THEN RETURN END IF
      #no.A002 (end)
      #No.FUN-9A0052  --Begin
      CALL s_post_aeh()
                      IF g_success='N' THEN RETURN END IF
      #No.FUN-9A0052  --End

   END FOREACH
END FUNCTION

FUNCTION s_post_aah(p_aag07,p_aag08)
   #DEFINE p_aag07	LIKE aag_file.aag02      #No.FUN-680098   VARCHAR(1) #No.MOD-870067
    DEFINE p_aag07	LIKE aag_file.aag07      #No.MOD-870067
    DEFINE p_aag08	LIKE aag_file.aag08      #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04      #No:FUN-4C0009    #No.FUN-680098  dec(20,6)
    DEFINE rec_d,rec_c  LIKE type_file.num5      #No.FUN-680098   smallint
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5      #No.FUN-680098  smallint
    DEFINE l_aag08	LIKE aag_file.aag08      #No.FUN-680098   VARCHAR(24)
    DEFINE m_aag08	LIKE aag_file.aag08      #No.FUN-680098   VARCHAR(24)

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aah_file SET aah04 = aah04 + amt_d,
                        aah05 = aah05 + amt_c,
                        aah06 = aah06 + rec_d,
                        aah07 = aah07 + rec_c
          WHERE aah00=g_aba.aba00 AND aah01=g_abb.abb03
            AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
          IF STATUS THEN
#            CALL cl_err('upd aah:',STATUS,1)    #No.FUN-660123
#            CALL cl_err3("upd","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04
               CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd aah:',STATUS,1)
             ELSE
               CALL cl_err3("upd","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aah:",1)
             END IF
#NO.FUN-710023--END
             LET g_success='N'
             RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No:MOD-470041 #FUN-980003 add aahlegal
                  VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba03,g_aba.aba04,
                         amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
            IF STATUS THEN
#               CALL cl_err('ins aah:',STATUS,1)   #No.FUN-660123
#               CALL cl_err3("ins","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aah:",1)   #No.FUN-660123 #NO.FUN-710023
              #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                 LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04
                 CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'ins aah:',STATUS,1)
                ELSE
                 CALL cl_err3("ins","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aah:",1)   #No.FUN-660123
                END IF
             #NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
          END IF
   #modify 020813 NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL s_post_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   #  IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
             CALL s_post_aah_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
             IF m_aag08 = l_aag08 THEN EXIT FOR END IF    #TQC-D10071
         END FOR
   #  END IF
   END IF
END FUNCTION

#add 020813 NO.A030
FUNCTION s_post_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE aah_file.aah04
   DEFINE  rec_d,rec_c   LIKE aah_file.aah06

   UPDATE aah_file SET aah04 = aah04 + amt_d,
                       aah05 = aah05 + amt_c,
                       aah06 = aah06 + rec_d,
                       aah07 = aah07 + rec_c
    WHERE aah00=g_aba.aba00 AND aah01=p_aag08
      AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
   IF STATUS THEN
#     CALL cl_err('upd aah(2):',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","aah_file",g_aba.aba00,p_aag08,STATUS,"","upd aah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04
         CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd aah(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","aah_file",g_aba.aba00,p_aag08,STATUS,"","upd aah(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No:MOD-470041 #FUN-980003 add aahlegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba03,g_aba.aba04,
                  amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins aah(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","aah_file",g_aba.aba00,p_aag08,STATUS,"","ins aah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04
            CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'ins aah(2):',STATUS,1)
         ELSE
            CALL cl_err3("ins","aah_file",g_aba.aba00,p_aag08,STATUS,"","ins aah(2):",1)
         END IF
#NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

#add by danny 020226 外幣管理(A002)
FUNCTION s_post_tah(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07    #No.FUN-680098   VARCHAR(1)
    DEFINE p_aag08	 LIKE aag_file.aag08    #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE aah_file.aah04    #No:FUN-4C0009   #No.FUN-680098  dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5    #No.FUN-680098  smallint
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No:FUN-4C0009      #No.FUN-680098  dec(20,6)
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i           LIKE type_file.num5     #No.FUN-680098  smallint
    DEFINE l_aag08	 LIKE aag_file.aag08    #No.FUN-680098  VARCHAR(24)
    DEFINE m_aag08	 LIKE aag_file.aag08    #No.FUN-680098   cha(24)

    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tah_file SET tah04 = tah04 + amt_d,
                        tah05 = tah05 + amt_c,
                        tah06 = tah06 + rec_d,
                        tah07 = tah07 + rec_c,
                        tah09 = tah09 + amtf_d,
                        tah10 = tah10 + amtf_c
          WHERE tah00=g_aba.aba00 AND tah01=g_abb.abb03
            AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
            AND tah08=g_abb.abb24     #幣別
          IF STATUS THEN
#            CALL cl_err('upd tah:',STATUS,1)  #No.FUN-660123
#            CALL cl_err3("upd","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,g_abb.abb24
               CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'upd tah:',STATUS,1)
             ELSE
               CALL cl_err3("upd","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tah:",1)
             END IF
#NO.FUN-710023--END
              LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,  #No:MOD-470041
                                  tah06,tah07,tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
                  VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba03,g_aba.aba04,
                         amt_d,amt_c,rec_d,rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
             IF STATUS THEN
#               CALL cl_err('ins tah:',STATUS,1)  #No.FUN-660123
#               CALL cl_err3("ins","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                  LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",amt_d,"/",amt_c,"/",rec_d,
                               "/",rec_c,"/",g_abb.abb24,"/",amtf_d,"/",amtf_c
                  CALL s_errmsg('tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,tah08,tah09,tah10',g_showmsg,'ins tah:',STATUS,1)
                ELSE
                  CALL cl_err3("ins","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tah:",1)
                END IF
#NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
          END IF
   #modify 020813 NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL s_post_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
             CALL s_post_tah_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
             IF m_aag08 = l_aag08 THEN EXIT FOR END IF    #TQC-D10071
         END FOR
    # END IF
   END IF
END FUNCTION
#no.A002 (end)

#add 020813 NO.A030
FUNCTION s_post_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE tah_file.tah04
   DEFINE  rec_d,rec_c   LIKE tah_file.tah06
   DEFINE  amtf_d,amtf_c LIKE tah_file.tah09

   UPDATE tah_file SET tah04 = tah04 + amt_d,
                       tah05 = tah05 + amt_c,
                       tah06 = tah06 + rec_d,
                       tah07 = tah07 + rec_c,
                       tah09 = tah09 + amtf_d,
                       tah10 = tah10 + amtf_c
    WHERE tah00=g_aba.aba00 AND tah01=p_aag08
      AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
      AND tah08=g_abb.abb24     #幣別
   IF STATUS THEN
#     CALL cl_err('upd tah(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","tah_file",g_aba.aba00,p_aag08,STATUS,"","upd tah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
     IF g_bgerr THEN
        LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
        CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'upd tah(2):',STATUS,1)
     ELSE
        CALL cl_err3("upd","tah_file",g_aba.aba00,p_aag08,STATUS,"","upd tah(2):",1)
     END IF
       LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,  #No:MOD-470041
                           tah06,tah07,tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba03,g_aba.aba04,amt_d,
                  amt_c,rec_d,rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins tah(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","tah_file",g_aba.aba00,p_aag08,STATUS,"","ins tah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04,"/",amt_d,"/",amt_c,"/",rec_d,
                          "/",rec_c,"/",g_abb.abb24,"/",amtf_d,"/",amtf_c
            CALL s_errmsg('tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,tah08,tah09,tah10',g_showmsg,'ins tah:',STATUS,1)
         ELSE
            CALL cl_err3("ins","tah_file",g_aba.aba00,p_aag08,STATUS,"","ins tah(2):",1)
         END IF
#NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION s_post_aas(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07       #No.FUN-680098    VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08       #No.FUN-680098    VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04       #No:FUN-4C0009    #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5       #No.FUN-680098   smallint
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5        #No.FUN-680098   smallint
    DEFINE l_aag08      LIKE aag_file.aag08       #No.FUN-680098  VARCHAR(24)
    DEFINE m_aag08      LIKE aag_file.aag08       #No.FUN-680098  VARCHAR(24)

    IF g_aaz.aaz51 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aas_file SET  aas04 = aas04+amt_d,
                         aas05 = aas05+amt_c,
                         aas06 = aas06+rec_d,
                         aas07 = aas07+rec_c
          WHERE aas00=g_aba.aba00 AND aas01=g_abb.abb03 AND aas02=g_aba.aba02
          IF STATUS THEN
#            CALL cl_err('upd aas:',STATUS,1)  #No.FUN-660123
#            CALL cl_err3("upd","aas_file",g_abb.abb03,g_aba.aba02,STATUS,"","upd aas:",1)   #No.FUN-660123 #NO.FUN-710023
         #NO.FUN-710023--BEGIN
            IF g_bgerr THEN
               LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02
               CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd aas:',STATUS,1)
            ELSE
               CALL cl_err3("upd","aas_file",g_abb.abb03,g_aba.aba02,STATUS,"","upd aas:",1)
            END IF
         #NO.FUN-710023--END
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No:MOD-470041 #FUN-980003 add aaslegal
                  VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba02,amt_d,
                         amt_c,rec_d,rec_c,g_legal)  #FUN-980003 add g_legal
             IF STATUS THEN
#               CALL cl_err('ins aas:',STATUS,1)  #No.FUN-660123
#               CALL cl_err3("ins","aas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aas:",1)   #No.FUN-660123 #NO.FUN-710023
                #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                   LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02
                   CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'ins aas:',STATUS,1)
                ELSE
                   CALL cl_err3("ins","aas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aas:",1)   #No.FUN-660123 #NO.FUN-710023
                END IF
                #NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
          END IF
   #modify 020813 NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL s_post_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00  #No.FUN-740020
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1 TO 1 STEP -1
             CALL s_post_aas_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
             IF m_aag08 = l_aag08 THEN EXIT FOR END IF    #TQC-D10071
         END FOR
    # END IF
   END IF
END FUNCTION

#add 020813 NO.A030
FUNCTION s_post_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE aah_file.aah04
   DEFINE  rec_d,rec_c   LIKE type_file.num5        #No.FUN-680098 smallint

   UPDATE aas_file SET  aas04 = aas04+amt_d,
                        aas05 = aas05+amt_c,
                        aas06 = aas06+rec_d,
                        aas07 = aas07+rec_c
         WHERE aas00=g_aba.aba00 AND aas01=p_aag08 AND aas02=g_aba.aba02
   IF STATUS THEN
#     CALL cl_err('upd aas(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","aas_file",g_aba.aba00,p_aag08,STATUS,"","upd aas(2):",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02
         CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd aas(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","aas_file",g_aba.aba00,p_aag08,STATUS,"","upd aas(2):",1)
      END IF
      #NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No:MOD-470041 #FUN-980003 add aaslegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba02,amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins aas(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","aas_file",g_aba.aba00,p_aag08,STATUS,"","ins aas(2):",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02
           CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'ns aas(2):',STATUS,1)
         ELSE
           CALL cl_err3("ins","aas_file",g_aba.aba00,p_aag08,STATUS,"","ins aas(2):",1)
         END IF
      #NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

#add by danny 020226 外幣管理(A002)
FUNCTION s_post_tas(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07      #No.FUN-680098  VARCHAR(1)
    DEFINE p_aag08       LIKE aag_file.aag08      #No.FUN-680098  VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE type_file.num20_6   #No:FUN-4C0009 #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5      #No.FUN-680098  smallint
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6   #No:FUN-4C0009#No.FUN-680098 dec(20,6)
    DEFINE l_aag24       LIKE aag_file.aag24
    DEFINE l_i           LIKE type_file.num5      #No.FUN-680098 smallint
    DEFINE l_aag08	 LIKE aag_file.aag08      #No.FUN-680098  VARCHAR(24)
    DEFINE m_aag08	 LIKE aag_file.aag08      #No.FUN-680098  VARCHAR(24)

    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_aaz.aaz51 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tas_file SET tas04 = tas04 + amt_d,
                        tas05 = tas05 + amt_c,
                        tas06 = tas06 + rec_d,
                        tas07 = tas07 + rec_c,
                        tas09 = tas09 + amtf_d,
                        tas10 = tas10 + amtf_c
          WHERE tas00=g_aba.aba00 AND tas01=g_abb.abb03
            AND tas02=g_aba.aba02 AND tas08=g_abb.abb24     #幣別
          IF STATUS THEN
#            CALL cl_err('upd tas:',STATUS,1)   #No.FUN-660123
#            CALL cl_err3("upd","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tas:",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_abb.abb24
               CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'upd tas:',STATUS,1)
             ELSE
               CALL cl_err3("upd","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tas:",1)
             END IF
      #NO.FUN-710023--END
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              INSERT INTO tas_file(tas00,tas01,tas02,tas04,tas05,  #No:MOD-470041
                                  tas06,tas07,tas08,tas09,tas10,taslegal) #FUN-980003 add taslegal
                  VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba02,amt_d,amt_c,
                         rec_d,rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
             IF STATUS THEN
#               CALL cl_err('ins tas:',STATUS,1)   #No.FUN-660123
#               CALL cl_err3("ins","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tas:",1)   #No.FUN-660123 #NO.FUN-710023
            #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                  LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_abb.abb24
                  CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'ins tas:',STATUS,1)
                ELSE
                  CALL cl_err3("ins","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tas:",1)
                END IF
            #NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
         END IF
   #modify 020813 NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL s_post_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
    # IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1 TO 1 STEP -1
             CALL s_post_tas_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
             IF m_aag08 = l_aag08 THEN EXIT FOR END IF    #TQC-D10071
         END FOR
    # END IF
   END IF
END FUNCTION
#no.A002 (end)

#add 020813 NO.A030
FUNCTION s_post_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE tah_file.tah04
   DEFINE  rec_d,rec_c   LIKE tah_file.tah06
   DEFINE  amtf_d,amtf_c LIKE tah_file.tah09

   UPDATE tas_file SET tas04 = tas04 + amt_d,
                       tas05 = tas05 + amt_c,
                       tas06 = tas06 + rec_d,
                       tas07 = tas07 + rec_c,
                       tas09 = tas09 + amtf_d,
                       tas10 = tas10 + amtf_c
    WHERE tas00=g_aba.aba00 AND tas01=p_aag08
      AND tas02=g_aba.aba02 AND tas08=g_abb.abb24     #幣別
   IF STATUS THEN
#     CALL cl_err('upd tas(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","tas_file",g_aba.aba00,p_aag08,STATUS,"","upd tas(2):",1)   #No.FUN-660123 #NO.FUN-710023
    #NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02,"/",g_abb.abb24
         CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'upd tas(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","tas_file",g_aba.aba00,p_aag08,STATUS,"","upd tas(2):",1)
      END IF
    #NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO tas_file(tas00,tas01,tas02,tas04,tas05,  #No:MOD-470041
                           tas06,tas07,tas08,tas09,tas10,taslegal) #FUN-980003 add taslegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba02,amt_d,amt_c,rec_d,rec_c,
                  g_abb.abb24,amtf_d,amtf_c,g_legal)  #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins tas(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","tas_file",g_aba.aba00,p_aag08,STATUS,"","ins tas(2):",1)   #No.FUN-660123 #NO.FUN-710023
        #NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02,"/",g_abb.abb24
            CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'ins tas(2):',STATUS,1)
         ELSE
             CALL cl_err3("ins","tas_file",g_aba.aba00,p_aag08,STATUS,"","ins tas(2):",1)
         END IF
        #NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION s_post_aao(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07     #No.FUN-680098   VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08     #No.FUN-680098   VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04     #No:FUN-4C0009   #No.FUN-680098    #No:FUN-4C0009 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5     #No.FUN-680098   smallint
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5     #No.FUN-680098    smallint
    DEFINE l_aag08      LIKE aag_file.aag08     #No.FUN-680098    VARCHAR(24)
    DEFINE m_aag08      LIKE aag_file.aag08     #No.FUN-680098    VARCHAR(24)

    IF g_aag.aag05='Y' THEN ELSE RETURN END IF
#   IF cl_null(g_abb.abb05) THEN RETURN END IF      #CHI-840052-mark
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aao_file SET aao05 = aao05 + amt_d,
                        aao06 = aao06 + amt_c,
                        aao07 = aao07 + rec_d,
                        aao08 = aao08 + rec_c
          WHERE aao00=g_aba.aba00 AND aao01=g_abb.abb03 AND aao02=g_abb.abb05
            AND aao03=g_aba.aba03 AND aao04=g_aba.aba04
          IF STATUS THEN
#            CALL cl_err('upd aao:',STATUS,1)  #No.FUN-660123
#            CALL cl_err3("upd","aao_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aao:",1)   #No.FUN-660123 #NO.FUN-710023
         #NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04
               CALL s_errmsg('aao00,aao01,aao02,aao03,aao04',g_showmsg,'upd aao:',STATUS,1)
             ELSE
               CALL cl_err3("upd","aao_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aao:",1)
             END IF
         #NO.FUN-710023--END
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,  #No:MOD-470041
                                  aao06,aao07,aao08,aaolegal) #FUN-980003 add aaolegal
                  VALUES(g_aba.aba00,g_abb.abb03,g_abb.abb05,g_aba.aba03,
                         g_aba.aba04,amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
             IF STATUS THEN
#               CALL cl_err('ins aao:',STATUS,1)  #No.FUN-660123
#               CALL cl_err3("ins","aao_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aao:",1)   #No.FUN-660123 #NO.FUN-710023
           #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                  LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04
                  CALL s_errmsg('aao00,aao01,aao02,aao03,aao04',g_showmsg,'ins aao:',STATUS,1)
                ELSE
                  CALL cl_err3("ins","aao_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aao:",1)
                END IF
           #NO.FUN-710023--END
                 LET g_success='N' RETURN
             END IF
          END IF
   #modify 020813 NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL s_post_aao_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   #  IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
             CALL s_post_aao_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
             IF m_aag08 = l_aag08 THEN EXIT FOR END IF    #TQC-D10071
         END FOR
   #  END IF
   END IF
END FUNCTION

#add 020813 NO.A030
FUNCTION s_post_aao_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE aah_file.aah04
   DEFINE  rec_d,rec_c	 LIKE type_file.num5    #No.FUN-680098 SMALLINT

   UPDATE aao_file SET aao05 = aao05 + amt_d,
                       aao06 = aao06 + amt_c,
                       aao07 = aao07 + rec_d,
                       aao08 = aao08 + rec_c
    WHERE aao00=g_aba.aba00 AND aao01=p_aag08 AND aao02=g_abb.abb05
      AND aao03=g_aba.aba03 AND aao04=g_aba.aba04
   IF STATUS THEN
#     CALL cl_err('upd aao(2):',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","aao_file",g_aba.aba00,p_aag08,STATUS,"","upd aao(2):",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04
         CALL s_errmsg('aao00,aao01,aao02,aao03,aao04',g_showmsg,'upd aao(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","aao_file",g_aba.aba00,p_aag08,STATUS,"","upd aao(2):",1)
      END IF
      #NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO aao_file(aao00,aao01,aao02,aao03,aao04,aao05,  #No:MOD-470041
                           aao06,aao07,aao08,aaolegal) #FUN-980003 add aaolegal
           VALUES(g_aba.aba00,p_aag08,g_abb.abb05,g_aba.aba03,
                  g_aba.aba04,amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins aao(2):',STATUS,1)  #No.FUN-660123
#        CALL cl_err3("ins","aao_file",g_aba.aba00,p_aag08,STATUS,"","ins aaao(2):",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
          IF g_bgerr THEN
              LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04
              CALL s_errmsg('aao00,aao01,aao02,aao03,aao04',g_showmsg,'ins aao(2):',STATUS,1)
          ELSE
              CALL cl_err3("ins","aao_file",g_aba.aba00,p_aag08,STATUS,"","ins aaao(2):",1)
          END IF
      #NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

#add by danny 020226 外幣管理(A002)
FUNCTION s_post_tao(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07     #No.FUN-680098   VARCHAR(1)
   #DEFINE p_aag08	 LIKE aag_file.aag07     #No.FUN-680098    VARCHAR(24)   #No.MOD-870067 mark
    DEFINE p_aag08	 LIKE aag_file.aag08     #No.MOD-870067
    DEFINE amt_d,amt_c	 LIKE aah_file.aah04     #No:FUN-4C0009 #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5     #No.FUN-680098  smallint
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No:FUN-4C0009#No.FUN-680098 dec(20,6)
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5     #No.FUN-680098   smallint
    DEFINE l_aag08	LIKE aag_file.aag08    #No.FUN-680098   VARCHAR(24)
    DEFINE m_aag08      LIKE aag_file.aag08    #No.FUN-680098   VARCHAR(24)

    IF g_aaz.aaz83='N' THEN RETURN END IF
    IF g_aag.aag05='N' THEN RETURN END IF
    IF cl_null(g_abb.abb05) THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tao_file SET tao05 = tao05 + amt_d,
                        tao06 = tao06 + amt_c,
                        tao07 = tao07 + rec_d,
                        tao08 = tao08 + rec_c,
                        tao10 = tao10 + amtf_d,
                        tao11 = tao11 + amtf_c
          WHERE tao00=g_aba.aba00 AND tao01=g_abb.abb03 AND tao02=g_abb.abb05
            AND tao03=g_aba.aba03 AND tao04=g_aba.aba04 AND tao09=g_abb.abb24
          IF STATUS THEN
#            CALL cl_err('upd tao:',STATUS,1)   #No.FUN-660123
#            CALL cl_err3("upd","tao_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tao:",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
             IF g_bgerr THEN
                LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
                CALL s_errmsg('tao00,tao01,tao02,tao03,tao04,tao09',g_showmsg,'upd tao:',STATUS,1)
             ELSE
                CALL cl_err3("upd","tao_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tao:",1)
              END IF
      #NO.FUN-710023--END
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,  #No:MOD-470041
                                  tao06,tao07,tao08,tao09,tao10,tao11,taolegal) #FUN-980003 add taolegal
                  VALUES(g_aba.aba00,g_abb.abb03,g_abb.abb05,g_aba.aba03,
                         g_aba.aba04,amt_d,amt_c,rec_d,rec_c,g_abb.abb24,
                         amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
             IF STATUS THEN
#               CALL cl_err('ins tao:',STATUS,1)   #No.FUN-660123
#               CALL cl_err3("ins","tao_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tao:",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                   LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
                   CALL s_errmsg('tao00,tao01,tao02,tao03,tao04,tao09',g_showmsg,'ins tao:',STATUS,1)
                ELSE
                   CALL cl_err3("ins","tao_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tao:",1)
                END IF
      #NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
          END IF
   #modify 020813 NO.A030
   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
      CALL s_post_tao_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
     #IF g_aza.aza26 = '2' THEN  #CHI-710005
         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
         LET m_aag08 = l_aag08
         FOR l_i = l_aag24 - 1  TO 1 STEP -1
             CALL s_post_tao_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
             LET l_aag08 = m_aag08
             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
             IF m_aag08 = l_aag08 THEN EXIT FOR END IF    #TQC-D10071
         END FOR
     #END IF
   END IF
END FUNCTION
#no.A002 (end)

#add 020813 NO.A030
FUNCTION s_post_tao_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE tah_file.tah04
   DEFINE  rec_d,rec_c   LIKE tah_file.tah06
   DEFINE  amtf_d,amtf_c LIKE tah_file.tah09

   UPDATE tao_file SET tao05 = tao05 + amt_d,
                       tao06 = tao06 + amt_c,
                       tao07 = tao07 + rec_d,
                       tao08 = tao08 + rec_c,
                       tao10 = tao10 + amtf_d,
                       tao11 = tao11 + amtf_c
    WHERE tao00=g_aba.aba00 AND tao01=p_aag08 AND tao02=g_abb.abb05
      AND tao03=g_aba.aba03 AND tao04=g_aba.aba04 AND tao09=g_abb.abb24
   IF STATUS THEN
#     CALL cl_err('upd tao(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","tao_file",g_aba.aba00,p_aag08,STATUS,"","upd tao(2):",1)   #No.FUN-660123#NO.FUN-710023
      #NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
         CALL s_errmsg('tao00,tao01,tao02,tao03,tao04,tao09',g_showmsg,'upd tao(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","tao_file",g_aba.aba00,p_aag08,STATUS,"","upd tao(2):",1)   #No.FUN-660123
      END IF
      #NO.FUN-710023--END
       LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO tao_file(tao00,tao01,tao02,tao03,tao04,tao05,  #No:MOD-470041
                           tao06,tao07,tao08,tao09,tao10,tao11,taolegal) #FUN-980003 add taolegal
           VALUES(g_aba.aba00,p_aag08,g_abb.abb05,g_aba.aba03,g_aba.aba04,
                  amt_d,amt_c,rec_d,rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins tao(2):',STATUS,1)  #No.FUN-660123
#        CALL cl_err3("ins","tao_file",g_aba.aba00,p_aag08,STATUS,"","ins tao(2):",1)   #No.FUN-660123 #NO.FUN-710023
      #NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_abb.abb05,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
            CALL s_errmsg('tao00,tao01,tao02,tao03,tao04,tao09',g_showmsg,'ins tao(2):',STATUS,1)
         ELSE
            CALL cl_err3("ins","tao_file",g_aba.aba00,p_aag08,STATUS,"","ins tao(2):",1)
         END IF
      #NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION s_post_afc()
    DEFINE amt_d,amt_c	LIKE aah_file.aah04    #No:FUN-4C0009 #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c  LIKE type_file.num5    #No.FUN-680098  smallint
    DEFINE l_cnt_afc    LIKE type_file.num5    #CHI-C70044

#   IF cl_null(g_abb.abb15) THEN RETURN END IF #no.5831           #FUN-810069
    IF g_aba.aba06 = 'FA' AND g_aag.aag04 = '1' THEN              #MOD-C90261 add
       RETURN                                                     #MOD-C90261 add
    END IF                                                        #MOD-C90261 add
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
## No:2427 Modify 1998/09/18 -------------------
    IF ((g_abb.abb35 <> ' ') OR (g_abb.abb05 <> ' ') OR (g_abb.abb08 <> ' ')) THEN  #CHI-C70044 add
       IF g_aag.aag06='1' THEN   # 正常餘額型態 (1.借餘/2.貸餘)
#No.MOD-950051 --begin
          IF g_aza.aza08 ='N' THEN
             LET g_abb.abb08 =' '
             LET g_abb.abb35 =' '
          END IF
          IF cl_null(g_abb.abb35) THEN LET g_abb.abb35=' ' END IF     #MOD-9C0103 add
          IF cl_null(g_abb.abb05) THEN LET g_abb.abb05=' ' END IF     #MOD-9C0103 add
          IF cl_null(g_abb.abb08) THEN LET g_abb.abb08=' ' END IF     #MOD-9C0103 add
#No.MOD-950051 --end
          #No.FUN-840074  --Begin
          UPDATE afc_file SET afc07 = afc07 + (amt_d - amt_c)
           WHERE afc00 = g_abb.abb00
             AND afc01 = g_abb.abb36
             AND afc02 = g_abb.abb03
             AND afc03 = g_aba.aba03
             AND afc04 = g_abb.abb35
             AND afc041= g_abb.abb05
             AND afc042= g_abb.abb08
             AND afc05 = g_aba.aba04
          IF STATUS THEN
             IF g_bgerr THEN
                LET g_showmsg = g_abb.abb00,"/", g_abb.abb36,"/",
                                g_abb.abb03,"/", g_aba.aba03,"/",
                                g_abb.abb35,"/", g_abb.abb05,"/",
                                g_abb.abb08,"/", g_aba.aba04
                CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'upd afc:',STATUS,1)
             ELSE
                CALL cl_err3("upd","afc_file",g_abb.abb03,g_abb.abb36,STATUS,"","upd afc:",1)
             END IF
             LET g_success='N' RETURN
          END IF
          #UPDATE afc_file SET afc07 = afc07 + (amt_d - amt_c)
          #      WHERE afc01=g_abb.abb15 AND afc02=g_abb.abb03 AND afc00=g_aba.aba00
          #        AND afc03=g_aba.aba03 AND afc05=g_aba.aba04
          #        AND afc041=g_aba.aba35 AND afc042=g_aba.aba08             #FUN-810069
          #                        AND (afc04 = '@' OR afc04=g_abb.abb05 OR
          #                             afc04 = g_abb.abb11 OR
          #                             afc04 = g_abb.abb12 OR
          #                             afc04 = g_abb.abb13 OR
          #                             afc04 = g_abb.abb14 OR
          #                             #FUN-5C0015 BY GILL --START
          #                             afc04 = g_abb.abb31 OR
          #                             afc04 = g_abb.abb32 OR
          #                             afc04 = g_abb.abb33 OR
          #                             afc04 = g_abb.abb34 OR
          #                             afc04 = g_abb.abb35 OR
          #                             afc04 = g_abb.abb36 OR
          #                             afc04 = g_abb.abb37 OR
          #                             #FUN-5C0015 BY GILL --END
          #                             afc04 = g_abb.abb08)
          #      IF STATUS THEN
#         #         CALL cl_err('upd afc:',STATUS,1)   #No.FUN-660123
#         #         CALL cl_err3("upd","afc_file",g_abb.abb15,g_abb.abb03,STATUS,"","upd afc:",1)   #No.FUN-660123 #NO.FUN-710023
          #  #NO.FUN-710023--BEGIN
          #         IF g_bgerr THEN
          #           LET g_showmsg=g_abb.abb15,"/",g_abb.abb03,"/",g_aba.aba00,"/",g_aba.aba03,"/",g_aba.aba04
          #           CALL s_errmsg('afc01,afc02,afc00,afc03,afc05',g_showmsg,'upd afc:',STATUS,1)
          #         ELSE
          #           CALL cl_err3("upd","afc_file",g_abb.abb15,g_abb.abb03,STATUS,"","upd afc:",1)
          #         END IF
          #  #NO.FUN-710023--END
          #         LET g_success='N' RETURN
          #      END IF
          #No.FUN-840074  --End
       ELSE
          IF cl_null(g_abb.abb35) THEN LET g_abb.abb35=' ' END IF     #MOD-9C0103 add
          IF cl_null(g_abb.abb05) THEN LET g_abb.abb05=' ' END IF     #MOD-9C0103 add
          IF cl_null(g_abb.abb08) THEN LET g_abb.abb08=' ' END IF     #MOD-9C0103 add
          #No.FUN-840074  --Begin
          UPDATE afc_file SET afc07 = afc07 + (amt_c - amt_d)
           WHERE afc00 = g_abb.abb00
             AND afc01 = g_abb.abb36
             AND afc02 = g_abb.abb03
             AND afc03 = g_aba.aba03
             AND afc04 = g_abb.abb35
             AND afc041= g_abb.abb05
             AND afc042= g_abb.abb08
             AND afc05 = g_aba.aba04
          IF STATUS THEN
             IF g_bgerr THEN
                LET g_showmsg = g_abb.abb00,"/", g_abb.abb36,"/",
                                g_abb.abb03,"/", g_aba.aba03,"/",
                                g_abb.abb35,"/", g_abb.abb05,"/",
                                g_abb.abb08,"/", g_aba.aba04
                CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'upd afc:',STATUS,1)
             ELSE
                CALL cl_err3("upd","afc_file",g_abb.abb03,g_abb.abb36,STATUS,"","upd afc:",1)
             END IF
             LET g_success='N' RETURN
          END IF
          #UPDATE afc_file SET afc07 = afc07 + (amt_c - amt_d)
          #      WHERE afc01=g_abb.abb15 AND afc02=g_abb.abb03 AND afc00=g_aba.aba00
          #        AND afc03=g_aba.aba03 AND afc05=g_aba.aba04
          #        AND afc041=g_aba.aba35 AND afc042=g_aba.aba08                    #FUN-810069
          #                        AND (afc04 = '@' OR afc04=g_abb.abb05 OR
          #                             afc04 = g_abb.abb11 OR
          #                             afc04 = g_abb.abb12 OR
          #                             afc04 = g_abb.abb13 OR
          #                             afc04 = g_abb.abb14 OR
          #                             #FUN-5C0015 BY GILL --START
          #                             afc04 = g_abb.abb31 OR
          #                             afc04 = g_abb.abb32 OR
          #                             afc04 = g_abb.abb33 OR
          #                             afc04 = g_abb.abb34 OR
          #                             afc04 = g_abb.abb35 OR
          #                             afc04 = g_abb.abb36 OR
          #                             afc04 = g_abb.abb37 OR
          #                             #FUN-5C0015 BY GILL --END
          #                             afc04 = g_abb.abb08)
          #      IF STATUS THEN
#         #         CALL cl_err('upd afc:',STATUS,1)   #No.FUN-660123
#         #         CALL cl_err3("upd","afc_file",g_abb.abb15,g_abb.abb03,STATUS,"","upd afc:",1)   #No.FUN-660123 #NO.FUN-710023
          #  #NO.FUN-710023--BEGIN
          #         IF g_bgerr THEN
          #            LET g_showmsg=g_abb.abb15,"/",g_abb.abb03,"/",g_aba.aba00,"/",g_aba.aba03,"/",g_aba.aba04
          #            CALL s_errmsg('afc01,afc02,afc00,afc03,afc05',g_showmsg,'upd afc:',STATUS,1)
          #         ELSE
          #            CALL cl_err3("upd","afc_file",g_abb.abb15,g_abb.abb03,STATUS,"","upd afc:",1)
          #         END IF
          #  #NO.FUN-710023--END
          #         LET g_success='N' RETURN
          #      END IF
          #No.FUN-840074  --End
       END IF
    END IF   #CHI-C70044 add

    #--CHI-C70044 start------
    LET l_cnt_afc = 0
    SELECT COUNT(*) INTO l_cnt_afc
      FROM afc_file
     WHERE afc00 = g_abb.abb00
       AND afc01 = g_abb.abb36
       AND afc02 = g_abb.abb03
       AND afc03 = g_aba.aba03
       AND afc04 = ' '
       AND afc041= ' '
       AND afc042= ' '
       AND afc05 = g_aba.aba04
    IF l_cnt_afc > 0 THEN
        IF g_aag.aag06='1' THEN   # 正常餘額型態 (1.借餘/2.貸餘)
            IF g_aza.aza08 ='N' THEN
               LET g_abb.abb08 =' '
               LET g_abb.abb35 =' '
            END IF
            IF cl_null(g_abb.abb35) THEN LET g_abb.abb35=' ' END IF
            IF cl_null(g_abb.abb05) THEN LET g_abb.abb05=' ' END IF
            IF cl_null(g_abb.abb08) THEN LET g_abb.abb08=' ' END IF
            UPDATE afc_file SET afc07 = afc07 + (amt_d - amt_c)
             WHERE afc00 = g_abb.abb00
               AND afc01 = g_abb.abb36
               AND afc02 = g_abb.abb03
               AND afc03 = g_aba.aba03
               AND afc04 = ' '
               AND afc041= ' '
               AND afc042= ' '
               AND afc05 = g_aba.aba04
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg = g_abb.abb00,"/", g_abb.abb36,"/",
                                  g_abb.abb03,"/", g_aba.aba03,"/",
                                  g_abb.abb35,"/", g_abb.abb05,"/",
                                  g_abb.abb08,"/", g_aba.aba04
                  CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'upd afc:',STATUS,1)
               ELSE
                  CALL cl_err3("upd","afc_file",g_abb.abb03,g_abb.abb36,STATUS,"","upd afc:",1)
               END IF
               LET g_success='N' RETURN
            END IF
        ELSE
           IF cl_null(g_abb.abb35) THEN LET g_abb.abb35=' ' END IF
           IF cl_null(g_abb.abb05) THEN LET g_abb.abb05=' ' END IF
           IF cl_null(g_abb.abb08) THEN LET g_abb.abb08=' ' END IF
           UPDATE afc_file SET afc07 = afc07 + (amt_c - amt_d)
            WHERE afc00 = g_abb.abb00
              AND afc01 = g_abb.abb36
              AND afc02 = g_abb.abb03
              AND afc03 = g_aba.aba03
              AND afc04 = ' '
              AND afc041= ' '
              AND afc042= ' '
              AND afc05 = g_aba.aba04
           IF STATUS THEN
              IF g_bgerr THEN
                 LET g_showmsg = g_abb.abb00,"/", g_abb.abb36,"/",
                                 g_abb.abb03,"/", g_aba.aba03,"/",
                                 g_abb.abb35,"/", g_abb.abb05,"/",
                                 g_abb.abb08,"/", g_aba.aba04
                 CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05',g_showmsg,'upd afc:',STATUS,1)
              ELSE
                 CALL cl_err3("upd","afc_file",g_abb.abb03,g_abb.abb36,STATUS,"","upd afc:",1)
              END IF
              LET g_success='N' RETURN
           END IF
        END IF
    END IF
    #--CHI-C70044 end----
END FUNCTION

FUNCTION s_post_aea()
   #modify 020813  NO.A030
   DEFINE l_aag08   LIKE aag_file.aag08
   DEFINE l_aag24   LIKE aag_file.aag24
   DEFINE l_abb03   LIKE abb_file.abb03
   DEFINE l_i       LIKE type_file.num5         #No.FUN-680098  smallint

   CALL s_post_aea_2(g_aag.aag08,g_abb.abb03)
  #IF g_aag.aag07 = '2' AND g_aza.aza26 = '2' THEN #判斷是否為明細帳戶若是則處理 #CHI-710005\
   IF g_aag.aag07 = '2' THEN #判斷是否為明細帳戶若是則處理 #CHI-710005
      SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
       WHERE aag01 = g_aag.aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
      IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
      LET l_abb03 = g_aag.aag08
      FOR l_i = l_aag24 - 1  TO 1 STEP -1
          CALL s_post_aea_2(l_aag08,l_abb03)
          #No:TQC-670004 --begin
          IF g_success = 'N' THEN
 #            CALL cl_err3("ins","aea_file",g_abb.abb00,l_aag08,STATUS,"","ins aea:",1) #NO.FUN-710023
           #NO.FUN-710023--BEGIN
              IF g_bgerr THEN
                LET g_showmsg=g_abb.abb00,"/",g_aba.aba02,"/",g_aba.aba01,"/",g_abb.abb02
               #CALL s_errmsg('aea00,aea02,aea03,aea04',g_showmsg,'ins aea:',STATUS,0)  #MOD-D70108 mark
                CALL s_errmsg('aea00,aea02,aea03,aea04',g_showmsg,'ins aea:',STATUS,1)  #MOD-D70108
               ELSE
                CALL cl_err3("ins","aea_file",g_abb.abb00,l_aag08,STATUS,"","ins aea:",1)
               END IF
           #NO.FUN-710023--END
             RETURN
          END IF
          #No:TQC-670004 --end
          LET l_abb03 = l_aag08
          SELECT aag08 INTO l_aag08 FROM aag_file WHERE aag01 = l_abb03 AND aag00 = g_aba.aba00    #No.FUN-740020
      END FOR
   END IF
END FUNCTION

#add 020813 NO.A030 NO.A030
FUNCTION s_post_aea_2(p_aag08,p_abb03)
   DEFINE p_aag08  LIKE aag_file.aag08
   DEFINE p_abb03  LIKE abb_file.abb03
   DEFINE l_cnt    LIKE type_file.num5    #MOD-680034    #No.FUN-680098  smallint

   #-----MOD-680034---------
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM aea_file
     WHERE aea00=g_abb.abb00 AND
           aea01=p_aag08 AND
           aea03=g_aba.aba01 AND
           aea04=g_abb.abb02
   IF l_cnt = 0 THEN
   #-----END MOD-680034-----
      INSERT INTO aea_file(aea00,aea01,aea02,aea03,aea04,aea05,aealegal)  #No:MOD-470041 #FUN-980003 add aealegal
           VALUES(g_abb.abb00,p_aag08,g_aba.aba02,g_aba.aba01,g_abb.abb02,p_abb03,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
         #CALL cl_err('ins aea:',STATUS,1)   #No.FUN-660123
         #CALL cl_err3("ins","aea_file",g_abb.abb00,p_aag08,STATUS,"","ins aea:",1)   #No.FUN-660123 #No.TQC-670004 mark
      #NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_abb.abb00,"/",p_aag08,"/",g_aba.aba02,"/",g_aba.aba01,"/",g_abb.abb02,"/",p_abb03
           CALL s_errmsg('aea00,aea01,aea02,aea03,aea04,aea05',g_showmsg,'ins aea:',STATUS,1)
         ELSE
           CALL cl_err3("ins","aea_file",g_abb.abb00,p_aag08,STATUS,"","ins aea:",1)
         END IF
      #NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF   #MOD-680034
END FUNCTION

FUNCTION s_post_aed()

   #FUN-5C0015 BY GILL--START 參數多傳異動代碼
   #IF NOT cl_null(g_abb.abb11) THEN
   #   CALL aec_ins(g_abb.abb11,g_aag.aag151,'1')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL aed_ins(g_abb.abb11,'1')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL ted_ins(g_abb.abb11,'1')
   #   IF g_success = 'N' THEN RETURN END IF
   #END IF
   #IF NOT cl_null(g_abb.abb12) THEN
   #   CALL aec_ins(g_abb.abb12,g_aag.aag161,'2')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL aed_ins(g_abb.abb12,'2')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL ted_ins(g_abb.abb12,'2')
   #   IF g_success = 'N' THEN RETURN END IF
   #END IF
   #IF NOT cl_null(g_abb.abb13) THEN
   #   CALL aec_ins(g_abb.abb13,g_aag.aag171,'3')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL aed_ins(g_abb.abb13,'3')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL ted_ins(g_abb.abb13,'3')
   #   IF g_success = 'N' THEN RETURN END IF
   #END IF
   #IF NOT cl_null(g_abb.abb14) THEN
   #   CALL aec_ins(g_abb.abb14,g_aag.aag181,'4')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL aed_ins(g_abb.abb14,'4')
   #   IF g_success = 'N' THEN RETURN END IF
   #   CALL ted_ins(g_abb.abb14,'4')
   #   IF g_success = 'N' THEN RETURN END IF
   #END IF

   IF NOT cl_null(g_abb.abb11) THEN
      #CALL aec_ins(g_abb.abb11,g_aag.aag151,'1',g_aag.aag15)         #MOD-D90023 mark
      CALL aec_ins(g_abb.abb11,g_aag.aag151,'1',g_aag.aag15,'aag15')  #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb11,'1',g_aag.aag15)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb11,'1',g_aag.aag15)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb12) THEN
      #CALL aec_ins(g_abb.abb12,g_aag.aag161,'2',g_aag.aag16)         #MOD-D90023 mark
      CALL aec_ins(g_abb.abb12,g_aag.aag161,'2',g_aag.aag16,'aag16')  #MOD-D90023 
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb12,'2',g_aag.aag16)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb12,'2',g_aag.aag16)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb13) THEN
      #CALL aec_ins(g_abb.abb13,g_aag.aag171,'3',g_aag.aag17)         #MOD-D90023 mark
      CALL aec_ins(g_abb.abb13,g_aag.aag171,'3',g_aag.aag17,'aag17')  #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb13,'3',g_aag.aag17)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb13,'3',g_aag.aag17)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb14) THEN
      #CALL aec_ins(g_abb.abb14,g_aag.aag181,'4',g_aag.aag18)         #MOD-D90023 mark      
      CALL aec_ins(g_abb.abb14,g_aag.aag181,'4',g_aag.aag18,'aag18')  #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb14,'4',g_aag.aag18)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb14,'4',g_aag.aag18)
      IF g_success = 'N' THEN RETURN END IF
   END IF

   IF NOT cl_null(g_abb.abb31) THEN
      #CALL aec_ins(g_abb.abb31,g_aag.aag311,'5',g_aag.aag31)         #MOD-D90023 mark 
      CALL aec_ins(g_abb.abb31,g_aag.aag311,'5',g_aag.aag31,'aag31')  #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb31,'5',g_aag.aag31)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb31,'5',g_aag.aag31)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb32) THEN
      #CALL aec_ins(g_abb.abb32,g_aag.aag321,'6',g_aag.aag32)         #MOD-D90023 mark 
      CALL aec_ins(g_abb.abb32,g_aag.aag321,'6',g_aag.aag32,'aag32')  #MOD-D90023 
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb32,'6',g_aag.aag32)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb32,'6',g_aag.aag32)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb33) THEN
      #CALL aec_ins(g_abb.abb33,g_aag.aag331,'7',g_aag.aag33)          #MOD-D90023 mark
      CALL aec_ins(g_abb.abb33,g_aag.aag331,'7',g_aag.aag33,'aag33')   #MOD-D90023 
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb33,'7',g_aag.aag33)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb33,'7',g_aag.aag33)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb34) THEN
      #CALL aec_ins(g_abb.abb34,g_aag.aag341,'8',g_aag.aag34)          #MOD-D90023 mark
      CALL aec_ins(g_abb.abb34,g_aag.aag341,'8',g_aag.aag34,'aag33')   #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb34,'8',g_aag.aag34)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb34,'8',g_aag.aag34)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb35) THEN
     #CALL aec_ins(g_abb.abb35,g_aag.aag351,'9',g_aag.aag35) #MOD-B30349 mark  
     #CALL aec_ins(g_abb.abb35,'1','9',' ')                  #MOD-B30349 #MOD-D90023 mark
      CALL aec_ins(g_abb.abb35,'1','9',' ',' ')              #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
     #CALL aed_ins(g_abb.abb35,'9',g_aag.aag35)              #MOD-B30349 mark
      CALL aed_ins(g_abb.abb35,'9',' ')                      #MOD-B30349
      IF g_success = 'N' THEN RETURN END IF
     #CALL ted_ins(g_abb.abb35,'9',g_aag.aag35)              #MOD-B30349 mark
      CALL ted_ins(g_abb.abb35,'9',' ')                      #MOD-B30349
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb36) THEN
     #CALL aec_ins(g_abb.abb36,g_aag.aag361,'10',g_aag.aag36) #MOD-B30349 mark
     #CALL aec_ins(g_abb.abb36,'1','10',' ')                  #MOD-B30349 #MOD-D90023 mark
      CALL aec_ins(g_abb.abb36,'1','10',' ',' ')              #MOD-D90023 
      IF g_success = 'N' THEN RETURN END IF
     #CALL aed_ins(g_abb.abb36,'10',g_aag.aag36)              #MOD-B30349 mark
      CALL aed_ins(g_abb.abb36,'10',' ')                      #MOD-B30349
      IF g_success = 'N' THEN RETURN END IF
     #CALL ted_ins(g_abb.abb36,'10',g_aag.aag36)              #MOD-B30349 mark
      CALL ted_ins(g_abb.abb36,'10',' ')                      #MOD-B30349
      IF g_success = 'N' THEN RETURN END IF
   END IF
   IF NOT cl_null(g_abb.abb37) THEN
     #CALL aec_ins(g_abb.abb37,g_aag.aag371,'99',g_aag.aag37)         #MOD-D90023 mark      
      CALL aec_ins(g_abb.abb37,g_aag.aag371,'99',g_aag.aag37,'aag37') #MOD-D90023
      IF g_success = 'N' THEN RETURN END IF
      CALL aed_ins(g_abb.abb37,'99',g_aag.aag37)
      IF g_success = 'N' THEN RETURN END IF
      CALL ted_ins(g_abb.abb37,'99',g_aag.aag37)
      IF g_success = 'N' THEN RETURN END IF
   END IF
   #FUN-5C0015 BY GILL --END

END FUNCTION

#FUNCTION aec_ins(p_key,p_sw,p_key2)     #FUN-5C0015 BY GILL --MARK
#FUNCTION aec_ins(p_key,p_sw,p_key2,p_tc) #FUN-5C0015 BY GILL  #MOD-D90023 mark
FUNCTION aec_ins(p_key,p_sw,p_key2,p_tc,p_gaq01) #MOD-D90023 add p_gaq01
   DEFINE  p_key   LIKE aec_file.aec05,	# 異動碼
	   p_sw    LIKE type_file.chr1,  # 異動碼處理方式   #No.FUN-680098  VARCHAR(1)
	   #p_key2  VARCHAR(1)  		 # 異動碼順序 #FUN-5C0015 BY GILL --MARK
	   p_key2  LIKE aec_file.aec051,  # 異動碼順序 #FUN-5C0015 BY GILL  #No.FUN-680098  VARCHAR(2)
           p_tc    LIKE aec_file.aec052  # 異動代碼   #FUN-5C0015 BY GILL
   DEFINE  p_gaq01       LIKE gaq_file.gaq01  # 異動碼欄位  #MOD-D90023
    #FUN-5C0015 BY GILL --START 多塞aec052異動代碼
    IF cl_null(p_tc) THEN LET p_tc = ' ' END IF      #MOD-BA0179 
    #INSERT INTO aec_file(aec00,aec01,aec02,aec03,aec04,aec05,aec051)  #No:MOD-470041
    #    VALUES(g_abb.abb00,g_abb.abb03,g_aba.aba02,g_aba.aba01,g_abb.abb02,
    #           p_key,p_key2)
    INSERT INTO aec_file(aec00,aec01,aec02,aec03,aec04,aec05,aec051,aec052,aeclegal)  #FUN-980003 add aeclegal
        VALUES(g_abb.abb00,g_abb.abb03,g_aba.aba02,g_aba.aba01,g_abb.abb02,
               p_key,p_key2,p_tc,g_legal) #FUN-980003 add g_legal
    #FUN-5C0015 BY GILL --END

        IF STATUS THEN
#          CALL cl_err('ins aec:',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("ins","aec_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins aec:",1)   #No.FUN-660123 #NO.FUN-710023
           #NO.FUN-710023--BEGIN
           IF g_bgerr THEN
             LET g_showmsg=g_abb.abb00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_aba.aba01,"/",g_abb.abb02
             CALL s_errmsg('aec00,aec01,aec02,aec03,aec04',g_showmsg,'ins aec:',STATUS,1)
           ELSE
             CALL cl_err3("ins","aec_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins aec:",1)
           END IF
           #NO.FUN-710023--END
           LET g_success='N' RETURN
        END IF
## No:2381 modify 1998/07/27 -----------
#  IF g_abb.abb04 IS NOT NULL THEN
#MOD-D90023 mark begin-----------------------
#      SELECT COUNT(*) INTO g_cnt FROM aee_file
#       WHERE aee01 = g_abb.abb03
#         AND aee00 = g_abb.abb00     #No.FUN-740020
#         AND aee02 = p_key2
#         AND aee03 = p_key
#      IF g_cnt = 0 THEN
#         INSERT INTO aee_file(aee00,aee01,aee02,aee03,aee04,aee05,aee06,   #No.FUN-740020
#                              aeeacti,aeeuser,aeegrup,aeemodu,aeedate,
#                              aee021 #FUN-5C0015 BY GILL
#                             ,aeeoriu,aeeorig)
#                VALUES(g_abb.abb00,g_abb.abb03,p_key2,p_key,g_abb.abb04,
#                       g_aba.aba01,g_aba.aba02,
#                       'Y',g_user,g_grup,'',g_today,
#                       p_tc #FUN-5C0015 BY GILL
#                       , g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#      END IF
#MOD-D90023 mark end-----------------------
     CALL s_ins_aee(p_key,p_key2,g_abb.abb00,g_abb.abb03,p_gaq01,g_aba.aba01)  #MOD-D90023
#  END IF
END FUNCTION

#FUNCTION aed_ins(p_key,p_key2)            #FUN-5C0015 BY GILL--MARK
FUNCTION aed_ins(p_key,p_key2,p_tc)        #FUN-5C0015 BY GILL
    DEFINE p_key	LIKE aed_file.aed02   #No.FUN-680098 VARCHAR(15)

    #DEFINE p_key2      VARCHAR(1)	        # 異動碼順序 #FUN-5C0015 BY GILL --MARK
    DEFINE p_key2       LIKE aed_file.aed011  # 異動碼順序 #FUN-5C0015 BY GILL  #No.FUN-680098  VARCHAR(2)
    DEFINE p_tc         LIKE aed_file.aed012 # 異動代碼   #FUN-5C0015 BY GILL

    DEFINE amt_d,amt_c	LIKE aah_file.aah04   #No:FUN-4C0009 #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5    #No.FUN-680098  smallint

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aed_file SET aed05 = aed05 + amt_d,
                        aed06 = aed06 + amt_c,
                        aed07 = aed07 + rec_d,
                        aed08 = aed08 + rec_c
                  WHERE aed01 = g_abb.abb03 AND aed02 = p_key AND aed011=p_key2
                    AND aed03 = g_aba.aba03 AND aed04 = g_aba.aba04
                    AND aed00 = g_aba.aba00
          IF STATUS THEN
#            CALL cl_err('upd aed:',STATUS,1)  #No.FUN-660123
#            CALL cl_err3("upd","aed_file",g_abb.abb03,p_key,STATUS,"","upd aed:",1)   #No.FUN-660123 #NO.FUN-710023
           #NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=g_abb.abb03,"/",p_key,"/",p_key2,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_aba.aba00
               CALL s_errmsg('aed00,aed02,aed011,aed03,aed04,aed00',g_showmsg,'upd  aed:',STATUS,1)
             ELSE
               CALL cl_err3("upd","aed_file",g_abb.abb03,p_key,STATUS,"","upd aed:",1)
             END IF
           #NO.FUN-710023--END
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆

              #FUN-5C0015 BY GILL --START
              #INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,    #No:MOD-470041
              #                     aed04,aed05,aed06,aed07,aed08)     #No.MOD-470315
              #    VALUES(g_abb.abb00,g_abb.abb03,p_key2,p_key,g_aba.aba03,
              #           g_aba.aba04,amt_d,amt_c,rec_d,rec_c)

              INSERT INTO aed_file(aed00,aed01,aed011,aed02,aed03,
                                   aed04,aed05,aed06,aed07,aed08,aed012,aedlegal) #FUN-980003 add aedlegal
                  VALUES(g_abb.abb00,g_abb.abb03,p_key2,p_key,g_aba.aba03,
                         g_aba.aba04,amt_d,amt_c,rec_d,rec_c,p_tc,g_legal) #FUN-980003 add g_legal

              #FUN-5C0015 BY GILL --END


             IF STATUS THEN
#               CALL cl_err('ins aed:',STATUS,1)   #No.FUN-660123
#               CALL cl_err3("ins","aed_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins aed:",1)   #No.FUN-660123
           #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                  LET g_showmsg=g_abb.abb00,"/",g_abb.abb03,"/",p_key2,"/",p_key,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_aba.aba00
                  CALL s_errmsg('aed00,aed01,aed011,aed02,aed03,aed04',g_showmsg,'ins  aed:',STATUS,1)
                ELSE
                  CALL cl_err3("ins","aed_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins aed:",1)
                END IF
           #NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
          END IF
END FUNCTION

#FUNCTION ted_ins(p_key,p_key2)         #FUN-5C0015 BY GILL --MARK
FUNCTION ted_ins(p_key,p_key2,p_tc)           #FUN-5C0015 BY GILL
    DEFINE p_key	LIKE ted_file.ted02   #No.FUN-680098  VARCHAR(15)

    #DEFINE p_key2      VARCHAR(1)	              # 異動碼順序 #FUN-5C0015 BY GILL --MARK
    DEFINE p_key2       LIKE ted_file.ted011  # 異動碼順序 #FUN-5C0015 BY GILL  #No.FUN-680098  VARCHAR(2)
    DEFINE p_tc         LIKE ted_file.ted012  # 異動代碼   #FUN-5C0015 BY GILL

    DEFINE amt_d,amt_c	 LIKE aah_file.aah04    #No:FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6 #No:FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5    #No.FUN-680098  smalint

    #add by danny 020228 外幣管理(A002)
    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE ted_file SET ted05 = ted05 + amt_d,
                        ted06 = ted06 + amt_c,
                        ted07 = ted07 + rec_d,
                        ted08 = ted08 + rec_c,
                        ted10 = ted10 + amtf_d,
                        ted11 = ted11 + amtf_c
                  WHERE ted01 = g_abb.abb03 AND ted02 = p_key AND ted011=p_key2
                    AND ted03 = g_aba.aba03 AND ted04 = g_aba.aba04
                    AND ted00 = g_aba.aba00 AND ted09 = g_abb.abb24
          IF STATUS THEN
#            CALL cl_err('upd ted:',STATUS,1)  #No.FUN-660123
#            CALL cl_err3("upd","ted_file",g_abb.abb03, p_key,STATUS,"","upd ted:",1)   #No.FUN-660123 #NO.FUN-710023
          #NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=g_abb.abb03,"/",p_key,"/",p_key2,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_aba.aba00,"/",g_abb.abb24
               CALL s_errmsg('ted01,ted02,ted011,ted03,ted04,ted00,ted09',g_showmsg,'upd  ted:',STATUS,1)
             ELSE
               CALL cl_err3("upd","ted_file",g_abb.abb03, p_key,STATUS,"","upd ted:",1)
             END IF
          #NO.FUN-710023--END
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
              #FUN-5C0015 BY GILL --START
              #INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,  #No:MOD-470041
              #                    ted06,ted07,ted08,ted09,ted10,ted11)
              #    VALUES(g_abb.abb00,g_abb.abb03,p_key2,p_key,g_aba.aba03,
              #           g_aba.aba04,amt_d,amt_c,rec_d,rec_c,g_abb.abb24,
              #           amtf_d,amtf_c)

              INSERT INTO ted_file(ted00,ted01,ted011,ted02,ted03,ted04,ted05,
                                   ted06,ted07,ted08,ted09,ted10,ted11,ted012,tedlegal) #FUN-980003 add tedlegal
                  VALUES(g_abb.abb00,g_abb.abb03,p_key2,p_key,g_aba.aba03,
                         g_aba.aba04,amt_d,amt_c,rec_d,rec_c,g_abb.abb24,
                         amtf_d,amtf_c,p_tc,g_legal) #FUN-980003 add g_legal
              #FUN-5C0015 BY GILL --END

             IF STATUS THEN
#               CALL cl_err('ins ted:',STATUS,1)   #No.FUN-660123
#               CALL cl_err3("ins","ted_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins ted:",1)   #No.FUN-660123 #NO.FUN-710023
           #NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                  LET g_showmsg=g_abb.abb00,"/",g_abb.abb03,"/",p_key2,"/",p_key,"/",g_aba.aba03,"/",g_aba.aba04
                  CALL s_errmsg('ted00,ted01,ted011,ted02,ted03,ted04',g_showmsg,'ins  ted:',STATUS,1)
                ELSE
                  CALL cl_err3("ins","ted_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins ted:",1)
                END IF
           #NO.FUN-710023--END
                LET g_success='N' RETURN
             END IF
          END IF
END FUNCTION

#no.3565 01/09/20
FUNCTION s_post_aef()
   IF NOT cl_null(g_abb.abb08) THEN
      CALL aeg_ins(g_abb.abb08)
      IF g_success = 'N' THEN RETURN END IF
      CALL aef_ins(g_abb.abb08)
      IF g_success = 'N' THEN RETURN END IF
   END IF
END FUNCTION

#Insert 專案別分類檔 no.3565 01/09/20
FUNCTION aeg_ins(p_key)
   DEFINE  p_key   LIKE aeg_file.aeg05 	# 專案編號

    INSERT INTO aeg_file(aeg00,aeg01,aeg02,aeg03,aeg04,aeg05,aeglegal)  #No:MOD-470041 #FUN-980003 add aeglegal
        VALUES(g_abb.abb00,g_abb.abb03,g_aba.aba02,g_aba.aba01,
             #  g_abb.abb02,p_keyk,g_legal) #FUN-980003 add g_legal #TQC-B50148 mark
               g_abb.abb02,p_key,g_legal)   #TQC-B50148 
        IF STATUS THEN
#          CALL cl_err('ins aeg:',STATUS,1)   #No.FUN-660123
#          CALL cl_err3("ins","aeg_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins aeg:",1)   #No.FUN-660123 #NO.FUN-710023
       #NO.FUN-710023--BEGIN
           IF g_bgerr THEN
              LET g_showmsg=g_abb.abb00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_aba.aba01,"/",p_key
              CALL s_errmsg('aeg00,aeg01,aeg02,aeg03,aeg04,aeg05',g_showmsg,'ins aeg:',STATUS,1)
           ELSE
              CALL cl_err3("ins","aeg_file",g_abb.abb00,g_abb.abb03,STATUS,"","ins aeg:",1)
           END IF
       #NO.FUN-710023--END
           LET g_success='N' RETURN
        END IF
END FUNCTION

#Insert 專案餘額檔 no.3565 01/09/20
FUNCTION aef_ins(p_key)
    DEFINE p_key        LIKE aef_file.aef02    #No.FUN-680098   VARCHAR(12)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04    #No:FUN-4C0009  #No.FUN-680098  dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5    #No.FUN-680098  smallint

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aef_file SET aef05 = aef05 + amt_d,
                        aef06 = aef06 + amt_c,
                        aef07 = aef07 + rec_d,
                        aef08 = aef08 + rec_c
     WHERE aef01 = g_abb.abb03 AND aef02 = p_key
       AND aef03 = g_aba.aba03 AND aef04 = g_aba.aba04
       AND aef00 = g_aba.aba00
    IF STATUS THEN
#      CALL cl_err('upd aef:',STATUS,1)  #No.FUN-660123
#      CALL cl_err3("upd","aef_file",g_abb.abb03,p_key,STATUS,"","upd aef:",1)   #No.FUN-660123 #NO.FUN-710023
     #NO.FUN-710023--BEGIN
       IF g_bgerr THEN
           LET g_showmsg=g_abb.abb03,"/",p_key,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_aba.aba00
           CALL s_errmsg('aef01,aef02,aef03,aef04,aef00',g_showmsg,'upd aef:',STATUS,1)
       ELSE
           CALL cl_err3("upd","aef_file",g_abb.abb03,p_key,STATUS,"","upd aef:",1)
       END IF
      #NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
        INSERT INTO aef_file(aef00,aef01,aef02,aef03,aef04,aef05,  #No:MOD-470041
                            aef06,aef07,aef08,aeflegal)  #FUN-980003 add aeflegal
            VALUES(g_abb.abb00,g_abb.abb03,p_key,g_aba.aba03,
                   g_aba.aba04,amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
       IF STATUS THEN
#         CALL cl_err('ins aef:',STATUS,1)  #No.FUN-660123
#         CALL cl_err3("ins","aef_file",g_abb.abb00,g_abb.abb03,SQLCA.sqlcode,"","ins aef:",1)  #NO.FUN-710023
     #NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=g_abb.abb00,"/",g_abb.abb03,"/",p_key,"/",g_aba.aba03,"/",g_aba.aba04
            CALL s_errmsg('aef00,aef01,aef02,aef03,aef04',g_showmsg,'ins aef:',STATUS,1)
          ELSE
            CALL cl_err3("ins","aef_file",g_abb.abb00,g_abb.abb03,SQLCA.sqlcode,"","ins aef:",1)
          END IF
     #NO.FUN-710023--END
          LET g_success='N' RETURN
       END IF
    END IF
END FUNCTION

#No.FUN-9A0052  --Begin
FUNCTION s_post_aeh()
    DEFINE l_sql            STRING
    DEFINE amt_d,amt_c	    LIKE aah_file.aah04   #No:FUN-4C0009 #No.FUN-680098 dec(20,6)
    DEFINE amt_df,amt_cf    LIKE aah_file.aah04   #LILID ADD 090428
    DEFINE rec_d,rec_c	    LIKE type_file.num5    #No.FUN-680098  smallint
    DEFINE l_abb            RECORD LIKE abb_file.*


    LET l_abb.* = g_abb.*

    IF l_abb.abb06 = 1
       THEN LET amt_d  = l_abb.abb07    LET rec_d = 1
            LET amt_c  = 0              LET rec_c = 0
            LET amt_df = l_abb.abb07f
            LET amt_cf = 0
       ELSE LET amt_d  = 0              LET rec_d = 0
            LET amt_c  = l_abb.abb07    LET rec_c = 1
            LET amt_df = 0
            LET amt_cf = l_abb.abb07f
    END IF

    IF cl_null(l_abb.abb05) THEN LET l_abb.abb05 = ' ' END IF
    IF cl_null(l_abb.abb08) THEN LET l_abb.abb08 = ' ' END IF
    IF cl_null(l_abb.abb11) THEN LET l_abb.abb11 = ' ' END IF
    IF cl_null(l_abb.abb12) THEN LET l_abb.abb12 = ' ' END IF
    IF cl_null(l_abb.abb13) THEN LET l_abb.abb13 = ' ' END IF
    IF cl_null(l_abb.abb14) THEN LET l_abb.abb14 = ' ' END IF
    IF cl_null(l_abb.abb15) THEN LET l_abb.abb15 = ' ' END IF
    IF cl_null(l_abb.abb31) THEN LET l_abb.abb31 = ' ' END IF
    IF cl_null(l_abb.abb32) THEN LET l_abb.abb32 = ' ' END IF
    IF cl_null(l_abb.abb33) THEN LET l_abb.abb33 = ' ' END IF
    IF cl_null(l_abb.abb34) THEN LET l_abb.abb34 = ' ' END IF
    IF cl_null(l_abb.abb35) THEN LET l_abb.abb35 = ' ' END IF
    IF cl_null(l_abb.abb36) THEN LET l_abb.abb36 = ' ' END IF
    IF cl_null(l_abb.abb37) THEN LET l_abb.abb37 = ' ' END IF

    LET l_sql = "UPDATE aeh_file SET ",
                "       aeh11 = aeh11 + ",amt_d,",",
                "       aeh12 = aeh12 + ",amt_c,",",
                "       aeh13 = aeh13 + ",rec_d,",",
                "       aeh14 = aeh14 + ",rec_c,",",
                "       aeh15 = aeh15 + ",amt_df,",",
                "       aeh16 = aeh16 + ",amt_cf,
                "  WHERE aeh00 = '",g_aba.aba00,"'",
                "    AND aeh01 = '",l_abb.abb03,"'",
                "    AND aeh09 =  ",g_aba.aba03,
                "    AND aeh10 =  ",g_aba.aba04,
                "    AND aeh17 = '",l_abb.abb24,"'",
                "    AND aeh02 = '",l_abb.abb05,"'",
                "    AND aeh03 = '",l_abb.abb08,"'",
                "    AND aeh04 = '",l_abb.abb11,"'",
                "    AND aeh05 = '",l_abb.abb12,"'",
                "    AND aeh06 = '",l_abb.abb13,"'",
                "    AND aeh07 = '",l_abb.abb14,"'",
                "    AND aeh08 = '",l_abb.abb15,"'",
                "    AND aeh31 = '",l_abb.abb31,"'",
                "    AND aeh32 = '",l_abb.abb32,"'",
                "    AND aeh33 = '",l_abb.abb33,"'",
                "    AND aeh34 = '",l_abb.abb34,"'",
                "    AND aeh35 = '",l_abb.abb35,"'",
                "    AND aeh36 = '",l_abb.abb36,"'",
                "    AND aeh37 = '",l_abb.abb37,"'"

    PREPARE aeh_p1 FROM l_sql
    EXECUTE aeh_p1
    IF STATUS THEN
       IF g_bgerr THEN
          LET g_showmsg=g_aba.aba00,"/",l_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",l_abb.abb24
          CALL s_errmsg('aeh00,aeh01,aeh09,aeh10,aeh17',g_showmsg,'upd aeh',STATUS,1)
       ELSE
         CALL cl_err3("upd","aeh_file",l_abb.abb03,'',STATUS,"","upd aeh:",1)
       END IF
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
        LET l_sql = "INSERT INTO aeh_file(",
                    "aeh00,aeh01,aeh02,aeh03,aeh04,",
                    "aeh05,aeh06,aeh07,aeh08,aeh09,",
                    "aeh10,aeh11,aeh12,aeh13,aeh14,",
                    "aeh15,aeh16,aeh17,aeh31,aeh32,",
                    "aeh33,aeh34,aeh35,aeh36,aeh37,aehlegal)",       #No.FUN-B10009
                    " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                    "        ?,?,?,?,?, ?,?,?,?,?, ",
                    "        ?,?,?,?,?, ?  ) "                       #No.FUN-B10009
        PREPARE aeh_p2 FROM l_sql
        EXECUTE aeh_p2 USING l_abb.abb00,l_abb.abb03,l_abb.abb05,l_abb.abb08,
                             l_abb.abb11,l_abb.abb12,l_abb.abb13,l_abb.abb14,
                             l_abb.abb15,g_aba.aba03,g_aba.aba04,amt_d,
                             amt_c,rec_d,rec_c,amt_df,
                             amt_cf,l_abb.abb24,l_abb.abb31,l_abb.abb32,
                             l_abb.abb33,l_abb.abb34,l_abb.abb35,l_abb.abb36,
                             l_abb.abb37,g_legal                     #No.FUN-B10009
       IF STATUS THEN
          IF g_bgerr THEN
             LET g_showmsg=g_aba.aba00,"/",l_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",l_abb.abb24
             CALL s_errmsg('aeh00,aeh01,aeh09,aeh10,aeh17',g_showmsg,'ins aeh',STATUS,1)
          ELSE
            CALL cl_err3("upd","aeh_file",l_abb.abb03,'',STATUS,"","ins aeh:",1)
          END IF
          LET g_success='N' RETURN
       END IF
    END IF
END FUNCTION
#No.FUN-9A0052  --End
