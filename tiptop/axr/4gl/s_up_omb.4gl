# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Descriptions...: 依內含或外加稅計算單頭及單身之金額, 避免尾差之情況
# Memo...........: 原則: 依單頭金額為主, 先求出單頭各項金額
#      單頭欄位:     外加稅: 未稅金額 = (sum(單身數量*單價))   四捨五入
#                            含稅金額 = (未稅金額*(1+稅率/100) 四捨五入
#                            稅額 = 含稅金額 - 未稅金額
#                    內含稅: 含稅金額= (sum(單身數量*單價))  四捨五入
#                            未金金額=含稅金額/(1+稅率/100)  四捨五入
#                            稅額 = 含稅金額 - 未稅金額
#      單身欄位:     將差額分攤至單身最大金額那一筆
# Date & Author..: 01/04/20 
# Modify.........: No.9718 04/07/13 By ching 尾差調整時,應更新oma61=oma56t
# Modify.........: No:MOD-520040 05/03/18 By kitty 在計算oma50,oma50t,oma54,oma54t,oma54x
#                                                  (Line73 左右)其計算順序是否可以跟t300_bu一致
# Modify.........: No:FUN-580086 05/08/23 開立發票後發現金額與單據紀錄不合,
#                                         則詢問 '是否與應收單據稅額相同', 再決定發票稅額的金額
# Modify.........: No:MOD-590410 05/10/20 不管是計算內含稅還是外含稅，都不應該直接加總(單價*數量)
#                                         而是直接將sum(omb14)，來算內含稅及外含稅,不然當資料筆數較多時，會有產生尾差
# Modify.........: No.TQC-5B0175 05/11/28 By ice 差異分攤時,帳單發票合計應考慮到發票待扺
# Modify.........: No:MOD-610051 06/01/16 By Smapmin 含稅金額有誤
# Modify.........: No:MOD-530702 06/06/13 By Elva 尾差>=0.06時導入金穗系統出錯，需分攤加至其他單身
# Modify.........: No:FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No:MOD-670103 06/07/25 By wujie 修正MOD-530702引起的問題
# Modify.........: No:FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No:MOD-6C0102 06/12/19 By Smapmin 如果只有調整發票匯率，則不會做發票金額的尾差調整
# Modify.........: No:TQC-750093 07/05/21 By Rayven 幣種金額的小數點取位有問題
# Modify.........: No:MOD-7B0020 07/11/05 By Smapmin 處理尾差時,也要一併update omc_file
# Modify.........: No:MOD-810012 08/01/08 By Smapmin 修改MOD-7B0020
# Modify.........: No:MOD-870214 08/07/22 By Sarah 增加過濾條件 m_oma.oma00<> '21'
# Modify.........: No:MOD-930136 09/03/12 By lilingyu 應該先算出重評后之匯差,再將oma56t加上匯差后回寫oma61
# Modify.........: No:MOD-930275 09/03/26 By chenl   1.對omc檔更新時需要考慮是否存在資料，存在則update否則不應更新，如資料新增時。
# Modify.........:                                   2.需要考慮是否采用多帳期，若采用多帳期需要根據多帳期設置更新omc資料。
# Modify.........: No:MOD-970296 09/08/04 By Sarah 有UPDATE omc09的地方,也要一起UPDATE omc13
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-990020 09/09/08 By Sarah 當稅率為0不需進MOD-670103的分攤稅額段
# Modify.........: No:TQC-9A0154 09/10/28 By Dido 未稅金額計算判斷調整 
# Modify.........: No:FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No:MOD-B40264 11/04/29 By Dido 僅限oas02='1'比率者才需更新
# Modify.........: No:MOD-BA0033 11/10/09 By Dido omc08/omc09 取位調整 
# Modify.........: No:MOD-CC0020 12/12/05 By Polly 批次作業時取消詢問直接處理

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_up_omb(p_oma01) 
  DEFINE p_oma01 LIKE oma_file.oma01
  DEFINE m_oma  RECORD LIKE oma_file.*
  DEFINE m_azi04  LIKE azi_file.azi04     
  DEFINE l_oma   RECORD LIKE oma_file.*
  DEFINE l_omb   RECORD LIKE omb_file.*
  DEFINE l_omb14  LIKE omb_file.omb14,
         l_omb14t LIKE omb_file.omb14t,
         l_omb16  LIKE omb_file.omb16,
         l_omb16t LIKE omb_file.omb16t,
         l_omb18  LIKE omb_file.omb18,
         l_omb18t LIKE omb_file.omb18t 
  DEFINE diff_omb14  LIKE omb_file.omb14,
         diff_omb14t LIKE omb_file.omb14t,
         diff_omb16  LIKE omb_file.omb16,
         diff_omb16t LIKE omb_file.omb16t,
         diff_omb18  LIKE omb_file.omb18,
         diff_omb18t LIKE omb_file.omb18t 
  DEFINE l_diff_omb14  LIKE omb_file.omb14,        #No.FUN-680123 DEC(15,2),
         l_diff_omb14t LIKE omb_file.omb14t,       #No.FUN-680123 DEC(15,2),
         l_diff_omb16  LIKE omb_file.omb16,        #No.FUN-680123DEC(15,2),
         l_diff_omb16t LIKE omb_file.omb16t,       #No.FUN-680123 DEC(15,2),
         l_diff_omb18  LIKE omb_file.omb18,        #No.FUN-680123 DEC(15,2),
         l_diff_omb18t LIKE omb_file.omb18t        #No.FUN-680123 DEC(15,2)
  DEFINE l_total  LIKE omb_file.omb14,
         l_qty    LIKE omb_file.omb14, 
         l_a      LIKE omb_file.omb14, 
         t_a      LIKE omb_file.omb14, 
         s_oma54  LIKE oma_file.oma54, 
         s_oma54t LIKE oma_file.oma54t, 
         s_oma56  LIKE oma_file.oma56, 
         s_oma56t LIKE oma_file.oma56t, 
         s_oma59  LIKE oma_file.oma59, 
         s_oma59t LIKE oma_file.oma59t, 
         l_x      LIKE omb_file.omb14  
  DEFINE l_flag   LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1), #FUN-580086
         l_oma59  LIKE oma_file.oma59,         #FUN-580086
         l_oma59x LIKE oma_file.oma59x,        #FUN-580086
         l_oma59t LIKE oma_file.oma59t         #FUN-580086
  DEFINE l_cnt    LIKE type_file.num5         #No.TQC-5B0175  #No.FUN-680123 SMALLINT
  DEFINE l_oot05  LIKE oot_file.oot05   #No.TQC-5B0175 本幣未稅 
  DEFINE l_oot05t LIKE oot_file.oot05t  #No.TQC-5B0175
  DEFINE l_omc01  LIKE omc_file.omc01   #MOD-7B0020
  DEFINE l_omc02  LIKE omc_file.omc02   #MOD-7B0020
  DEFINE g_net    LIKE oox_file.oox10   #MOD-930136
  DEFINE l_flag2  LIKE type_file.chr1         #MOD-CC0020 add


  IF cl_null(p_oma01) THEN RETURN  END IF
  SELECT * INTO m_oma.* FROM oma_file WHERE oma01=p_oma01
  IF STATUS THEN 
     CALL cl_err3("sel","oma_file",p_oma01,"",STATUS,"","sel oma:",1)    #No.FUN-660116
     RETURN  
  END IF

  IF m_oma.oma02<=g_ooz.ooz09 THEN CALL cl_err('','axr-164',0) RETURN  END IF
  #若出貨比率不為 100% 或不為出貨應收 則不適用此functiion
  IF m_oma.oma162 <> 100 OR
    (m_oma.oma00<> '12' AND m_oma.oma00<>'14' AND m_oma.oma00<> '21')  #MOD-870214
       THEN RETURN  END IF

  SELECT azi04 INTO t_azi04    #No.TQC-750093 m_azi -> t_azi
    FROM azi_file
   WHERE azi01 = m_oma.oma23
  IF t_azi04 IS NULL THEN LET t_azi04=0 END IF  #No.TQC-750093 m_azi -> t_azi
  SELECT SUM(omb14),SUM(omb14*oma24),SUM(omb14*oma58),SUM(omb14t*oma58)		#TQC-9A0154 add omb14t*oma58
    INTO l_omb14,l_omb16,l_omb18,l_omb18t					#TQC-9A0154 add omb18t
    FROM omb_file,oma_file
   WHERE omb01 = m_oma.oma01 AND omb01=oma01

  IF cl_null(l_omb14) THEN LET l_omb14 = 0 END IF
  IF cl_null(l_omb16) THEN LET l_omb16 = 0 END IF
  IF cl_null(l_omb18) THEN LET l_omb18 = 0 END IF
  IF cl_null(l_omb18t) THEN LET l_omb18t = 0 END IF


  CALL cl_digcut(l_omb14,t_azi04) RETURNING l_omb14  #No.TQC-750093 m_azi -> t_azi
  CALL cl_digcut(l_omb16,g_azi04) RETURNING l_omb16  #No.TQC-750093 t_azi -> g_azi
  CALL cl_digcut(l_omb18,g_azi04) RETURNING l_omb18  #No.TQC-750093 t_azi -> g_azi
  IF m_oma.oma213='N' THEN
     LET l_oma59 = l_omb18
     LET l_oma59x=l_oma59*m_oma.oma211/100
     CALL cl_digcut(l_oma59x,g_azi04) RETURNING l_oma59x  #No.TQC-750093 t_azi -> g_azi
     LET l_oma59t=l_oma59+l_oma59x

     IF (l_oma59t <> m_oma.oma56t) OR (l_oma59t <> m_oma.oma59t) THEN     #MOD-6C0102
       #IF cl_confirm("axr-007") THEN           #MOD-CC0020 mark
       #--------------------------MOD-CC0020---------------------(S)
        #LET l_flag2 = 'N'
        LET l_flag2 = 'Y'                    #yinhy130513
        IF g_prog NOT MATCHES 'axrp*' THEN
           IF cl_confirm("axr-007") THEN
              #LET l_flag2 = 'Y'
              LET l_flag2 = 'N'              #yinhy130513
           END IF
        ELSE
           LET l_flag2 = 'Y'
        END IF
        IF l_flag2 = 'Y' THEN
       #--------------------------MOD-CC0020---------------------(E)
          #外加稅
           LET m_oma.oma50 = l_omb14 
           LET m_oma.oma50t = m_oma.oma50 * (1+m_oma.oma211/100)
           CALL cl_digcut(m_oma.oma50t,t_azi04) RETURNING m_oma.oma50t  #No.TQC-750093 m_azi -> t_azi
           LET m_oma.oma54 = m_oma.oma50
           LET m_oma.oma54x=m_oma.oma54*m_oma.oma211/100
           CALL cl_digcut(m_oma.oma54x,t_azi04) RETURNING m_oma.oma54x  #No.TQC-750093 m_azi -> t_azi
           LET m_oma.oma54t=m_oma.oma54+m_oma.oma54x
           LET m_oma.oma56 = l_omb16 
           LET m_oma.oma56x=m_oma.oma56*m_oma.oma211/100
           CALL cl_digcut(m_oma.oma56x,g_azi04) RETURNING m_oma.oma56x  #No.TQC-750093 t_azi -> g_azi
           LET m_oma.oma56t=m_oma.oma56+m_oma.oma56x
           LET m_oma.oma59 = l_omb18 
           LET m_oma.oma59x=m_oma.oma59*m_oma.oma211/100
           CALL cl_digcut(m_oma.oma59x,g_azi04) RETURNING m_oma.oma59x  #No.TQC-750093 t_azi -> g_azi
           LET m_oma.oma59t=m_oma.oma59+m_oma.oma59x
           LET m_oma.oma56 = cl_digcut(m_oma.oma56,g_azi04)
           LET m_oma.oma56x = cl_digcut(m_oma.oma56x,g_azi04)
           LET m_oma.oma56t = cl_digcut(m_oma.oma56t,g_azi04)
           LET m_oma.oma59 = cl_digcut(m_oma.oma59,g_azi04)
           LET m_oma.oma59x = cl_digcut(m_oma.oma59x,g_azi04)
           LET m_oma.oma59t = cl_digcut(m_oma.oma59t,g_azi04)
        END IF
     END IF
  ELSE
     LET l_oma59t = l_omb18t				#TQC-9A0154
     LET l_oma59x=l_oma59t*m_oma.oma211/(100+m_oma.oma211)
     CALL cl_digcut(l_oma59x,g_azi04) RETURNING l_oma59x  #No.TQC-750093 t_azi -> g_azi
     LET l_oma59 =l_oma59t-l_oma59x
     IF (l_oma59 <> m_oma.oma56) OR (l_oma59 <> m_oma.oma59) THEN    			#TQC-9A0154 
       #IF cl_confirm("axr-007") THEN        #MOD-CC0020 mark
       #--------------------------MOD-CC0020---------------------(S)
        #LET l_flag2 = 'N'
        LET l_flag2 = 'Y'                    #yinhy130513
        IF g_prog NOT MATCHES 'axrp*' THEN
           IF cl_confirm("axr-007") THEN
              #LET l_flag2 = 'Y'
              LET l_flag2 = 'N'                    #yinhy130513
           END IF
        ELSE
           LET l_flag2 = 'Y'
        END IF
        IF l_flag2 = 'Y' THEN
       #--------------------------MOD-CC0020---------------------(E)
          #內含稅
           LET m_oma.oma50t= l_omb14 
           LET m_oma.oma50  = m_oma.oma50t*100/(100+m_oma.oma211)    #No:MOD-520040
           CALL cl_digcut(m_oma.oma50,t_azi04) RETURNING m_oma.oma50  #No.TQC-750093 m_azi -> t_azi
           CALL cl_digcut(m_oma.oma54t,t_azi04) RETURNING m_oma.oma54t  #No.TQC-750093 m_azi -> t_azi
           LET m_oma.oma54x=m_oma.oma54t*m_oma.oma211/(100+m_oma.oma211)
           CALL cl_digcut(m_oma.oma54x,t_azi04) RETURNING m_oma.oma54x  #No.TQC-750093 m_azi -> t_azi
           LET m_oma.oma54 =m_oma.oma54t-m_oma.oma54x
           CALL cl_digcut(m_oma.oma56t,g_azi04) RETURNING m_oma.oma56t   #MOD-610051
           LET m_oma.oma56x=m_oma.oma56t*m_oma.oma211/(100+m_oma.oma211)
           CALL cl_digcut(m_oma.oma56x,g_azi04) RETURNING m_oma.oma56x  #No.TQC-750093 t_azi -> g_azi
           LET m_oma.oma56 =m_oma.oma56t-m_oma.oma56x
           LET m_oma.oma59x=m_oma.oma59t*m_oma.oma211/(100+m_oma.oma211)
           CALL cl_digcut(m_oma.oma59x,g_azi04) RETURNING m_oma.oma59x  #No.TQC-750093 t_azi -> g_azi
           LET m_oma.oma59 =m_oma.oma59t-m_oma.oma59x
           LET m_oma.oma56 = cl_digcut(m_oma.oma56,g_azi04)
           LET m_oma.oma56x = cl_digcut(m_oma.oma56x,g_azi04)
           LET m_oma.oma56t = cl_digcut(m_oma.oma56t,g_azi04)
           LET m_oma.oma59 = cl_digcut(m_oma.oma59,g_azi04)
           LET m_oma.oma59x = cl_digcut(m_oma.oma59x,g_azi04)
           LET m_oma.oma59t = cl_digcut(m_oma.oma59t,g_azi04)
        END IF
     END IF
  END IF

  LET s_oma54 = m_oma.oma54
  LET s_oma54t= m_oma.oma54t
  LET s_oma56 = m_oma.oma56
  LET s_oma56t= m_oma.oma56t
  LET s_oma59 = m_oma.oma59
  LET s_oma59t= m_oma.oma59t
  IF cl_null(s_oma54)  THEN LET s_oma54 =0 END IF   #CHI-990020 add
  IF cl_null(s_oma54t) THEN LET s_oma54t=0 END IF   #CHI-990020 add
  IF cl_null(s_oma56)  THEN LET s_oma56 =0 END IF   #CHI-990020 add
  IF cl_null(s_oma56t) THEN LET s_oma56t=0 END IF   #CHI-990020 add
  IF cl_null(s_oma59)  THEN LET s_oma59 =0 END IF   #CHI-990020 add
  IF cl_null(s_oma59t) THEN LET s_oma59t=0 END IF   #CHI-990020 add

  #確認的帳單才會扣除發票待扺金額
  IF m_oma.omaconf = 'Y' THEN
     SELECT COUNT(*),SUM(oot05),SUM(oot05t)
       INTO l_cnt,l_oot05,l_oot05t 
       FROM oot_file
      WHERE oot03 = m_oma.oma01
     IF l_cnt > 0 THEN
        IF cl_null(l_oot05)  THEN LET l_oot05  = 0 END IF
        IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
        LET s_oma59 = m_oma.oma59 + l_oot05
        LET s_oma59t= m_oma.oma59t + l_oot05t
     END IF
  END IF

  #讀取單身之金額加總
  SELECT SUM(omb14),SUM(omb14t),SUM(omb16),SUM(omb16t),SUM(omb18),SUM(omb18t)
    INTO l_omb14,l_omb14t,l_omb16,l_omb16t,l_omb18,l_omb18t
    FROM omb_file
   WHERE omb01 = m_oma.oma01
  IF cl_null(l_omb14)  THEN LET l_omb14 = 0 END IF   #CHI-990020 add
  IF cl_null(l_omb14t) THEN LET l_omb14t= 0 END IF   #CHI-990020 add
  IF cl_null(l_omb16)  THEN LET l_omb16 = 0 END IF   #CHI-990020 add
  IF cl_null(l_omb16t) THEN LET l_omb16t= 0 END IF   #CHI-990020 add
  IF cl_null(l_omb18)  THEN LET l_omb18 = 0 END IF   #CHI-990020 add
  IF cl_null(l_omb18t) THEN LET l_omb18t= 0 END IF   #CHI-990020 add

  LET diff_omb14 = s_oma54 - l_omb14 
  LET diff_omb14t= s_oma54t- l_omb14t
  LET diff_omb16 = s_oma56 - l_omb16 
  LET diff_omb16t= s_oma56t- l_omb16t
  LET diff_omb18 = s_oma59 - l_omb18 
  LET diff_omb18t= s_oma59t- l_omb18t
  LET l_diff_omb14t= diff_omb14t
  LET l_diff_omb16t= diff_omb16t
  LET l_diff_omb18t= diff_omb18t
  DECLARE omb_curs2 CURSOR FOR 
       SELECT * FROM omb_file 
      WHERE omb01 = m_oma.oma01
        ORDER BY omb14t DESC
  FOREACH omb_curs2 INTO l_omb.* 
      IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
      LET l_flag = 'N'    #MOD-6C0102
      #當差異真的是稅額的差異才需進入此段調整
      IF m_oma.oma211 > 0 THEN   #CHI-990020 add
         IF g_aza.aza26 ='2' THEN
            LET l_diff_omb16=l_omb.omb16t-l_omb.omb16*(1+m_oma.oma211/100)
            IF l_diff_omb16t+l_diff_omb16>=0.06 OR l_diff_omb16t+l_diff_omb16<=-0.06 THEN
               IF l_diff_omb16t+l_diff_omb16<=-0.06 THEN
                  LET diff_omb14t=-(0.05+l_diff_omb16)/m_oma.oma24
                  LET diff_omb16t=-(0.05+l_diff_omb16)
                  LET diff_omb18t=-diff_omb14t*m_oma.oma58
               ELSE
                  LET diff_omb14t=(0.05-l_diff_omb16)/m_oma.oma24
                  LET diff_omb16t=0.05-l_diff_omb16
                  LET diff_omb18t=diff_omb14t*m_oma.oma58
               END IF
               LET l_flag = 'Y' 
            ELSE
               LET diff_omb14t=l_diff_omb14t
               LET diff_omb16t=l_diff_omb16t
               LET diff_omb18t=l_diff_omb18t
            END IF
         END IF
      END IF   #CHI-990020 add
      UPDATE  omb_file
         SET omb14 =omb14 +diff_omb14,
             omb14t=omb14t+diff_omb14t,
             omb16 =omb16 +diff_omb16,
             omb16t=omb16t+diff_omb16t,
             omb18 =omb18 +diff_omb18,
             omb18t=omb18t+diff_omb18t
        WHERE omb01 = l_omb.omb01 
          AND omb03 = l_omb.omb03
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","omb_file",l_omb.omb01,l_omb.omb03,SQLCA.sqlcode,"","upd omb err:",0)   #No.FUN-660116
      END IF
      IF l_flag = 'N' THEN
         EXIT FOREACH
      END IF
      LET l_diff_omb14t=l_diff_omb14t-diff_omb14t
      LET l_diff_omb16t=l_diff_omb16t-diff_omb16t
      LET l_diff_omb18t=l_diff_omb18t-diff_omb18t
  END FOREACH
  IF cl_null(m_oma.oma50)  THEN LET m_oma.oma50  = 0 END IF
  IF cl_null(m_oma.oma50t)  THEN LET m_oma.oma50t = 0 END IF
  IF cl_null(m_oma.oma54)  THEN LET m_oma.oma54  = 0 END IF
  IF cl_null(m_oma.oma54x)  THEN LET m_oma.oma54x = 0 END IF
  IF cl_null(m_oma.oma54t)  THEN LET m_oma.oma54t = 0 END IF
  IF cl_null(m_oma.oma56)  THEN LET m_oma.oma56  = 0 END IF
  IF cl_null(m_oma.oma56x)  THEN LET m_oma.oma56x = 0 END IF
  IF cl_null(m_oma.oma56t)  THEN LET m_oma.oma56t = 0 END IF
  IF cl_null(m_oma.oma59)  THEN LET m_oma.oma59  = 0 END IF
  IF cl_null(m_oma.oma59x)  THEN LET m_oma.oma59x = 0 END IF
  IF cl_null(m_oma.oma59t)  THEN LET m_oma.oma59t = 0 END IF

  LET m_oma.oma61 = m_oma.oma56t-m_oma.oma57                                                                                  
  CALL s_ar_oox03(m_oma.oma01) RETURNING g_net                                                                                     
  LET m_oma.oma61 = m_oma.oma61+g_net   
 
  #更新單頭
  UPDATE oma_file
     SET oma50 =m_oma.oma50,
         oma50t=m_oma.oma50t,
         oma54 =m_oma.oma54 ,
         oma54x=m_oma.oma54x,
         oma54t=m_oma.oma54t,
         oma56 =m_oma.oma56 ,
         oma56x=m_oma.oma56x,
         oma56t=m_oma.oma56t,
         oma61 =m_oma.oma61,        #MOD-930136
         oma59 =m_oma.oma59 ,
         oma59x=m_oma.oma59x,
         oma59t=m_oma.oma59t 
   WHERE oma01 = m_oma.oma01
  IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err3("upd","oma_file",m_oma.oma01,"",SQLCA.sqlcode,"","upd oma:",0)   #No.FUN-660116
     LET g_success='N'
  END IF
  CALL s_upomc(m_oma.oma01,m_oma.oma54t,m_oma.oma56t)
END FUNCTION

FUNCTION s_upomc(p_oma01,p_oma54t,p_oma56t)
DEFINE p_oma01     LIKE oma_file.oma01
DEFINE p_oma54t    LIKE oma_file.oma54t
DEFINE p_oma56t    LIKE oma_file.oma56t
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5   #MOD-BA0033
DEFINE l_sql       STRING 
DEFINE l_oma32     LIKE oma_file.oma32
DEFINE l_omc       RECORD LIKE omc_file.* 
DEFINE g_net       LIKE oox_file.oox10   #MOD-970296 add
DEFINE l_omc08_s   LIKE omc_file.omc08
DEFINE l_omc09_s   LIKE omc_file.omc09
DEFINE l_max_omc02 LIKE omc_file.omc02
DEFINE l_oas       RECORD LIKE oas_file.*
DEFINE l_diff_08   LIKE omc_file.omc08
DEFINE l_diff_09   LIKE omc_file.omc09 

   IF cl_null(p_oma01) THEN RETURN END IF
   IF p_oma54t = 0 THEN RETURN END IF 
   SELECT COUNT(*) INTO l_cnt FROM omc_file
    WHERE omc01 = p_oma01

   IF l_cnt = 0 THEN RETURN END IF   #若omc檔不存在資料，則不必進行更新調整。 
   
  #-MOD-B40264-add-
   LET l_cnt2 = 0                #MOD-BA0033 mod l_cnt -> l_cnt2 
   SELECT COUNT(*) INTO l_cnt2   #MOD-BA0033 mod l_cnt -> l_cnt2
     FROM oma_file,oas_file
    WHERE oma01 = p_oma01 
      AND oas01 = oma32 
      AND oas02 = '2'   
   IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF  #MOD-BA0033 mod l_cnt -> l_cnt2
   IF l_cnt2 > 0 THEN RETURN END IF               #MOD-BA0033 mod l_cnt -> l_cnt2
  #-MOD-B40264-end-
 
   LET l_sql = "UPDATE omc_file SET omc08 = ? ,",
               "                    omc09 = ? ,",
               "                    omc13 = omc09-omc11+? ",   #MOD-970296 add
               "  WHERE omc01 = ? AND omc02 = ? "
   PREPARE s_up_omc_prep FROM l_sql 
    
   IF l_cnt = 1 THEN        #多賬期僅為1筆的情況。僅為一筆的情況請查看axrt300中的ins_omc函數 
      INITIALIZE l_omc.* TO NULL 
      SELECT * INTO l_omc.* 
        FROM omc_file 
       WHERE omc01 = p_oma01
       
      CALL s_ar_oox03(p_oma01) RETURNING g_net   #MOD-970296 add
      EXECUTE s_up_omc_prep USING p_oma54t,p_oma56t,g_net,l_omc.omc01,l_omc.omc02   #MOD-970296
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","omc_file",l_omc.omc01,l_omc.omc02,SQLCA.sqlcode,"","upd omc:",0)
         LET g_success = 'N'
      END IF 
      
   END IF 
    
   IF l_cnt > 1 THEN       #多賬期為多筆的情況
      INITIALIZE l_omc.* TO NULL 
      LET l_oma32 = NULL 
      SELECT oma32 INTO l_oma32 FROM oma_file WHERE oma01=p_oma01   #抓取母收款條件
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("sel","oma_file",p_oma01,l_oma32,SQLCA.sqlcode,"","sel omc:",0)
         LET g_success = 'N'
         RETURN 
      END IF 

      SELECT MAX(omc02) INTO l_max_omc02 FROM omc_file WHERE omc01 = p_oma01   #抓取多賬期資料中最后一筆資料的序號。
      DECLARE s_up_selomc_cs CURSOR FOR 
        SELECT *  FROM omc_file WHERE omc01 = p_oma01 ORDER BY omc02
      FOREACH s_up_selomc_cs INTO l_omc.*  #先根據母收款條件和子收款條件鎖定收款比率，將多賬期資料按比率一次更新完成。 
        INITIALIZE l_oas.* TO NULL 
        SELECT * INTO l_oas.* FROM oas_file WHERE oas01 = l_oma32 AND oas04 = l_omc.omc03
        LET l_omc.omc08 = p_oma54t * l_oas.oas05 / 100
        CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08   #MOD-BA0033
        LET l_omc.omc09 = p_oma56t * l_oas.oas05 / 100
        CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09   #MOD-BA0033
        LET g_net = 0   #MOD-970296 add
        EXECUTE s_up_omc_prep USING l_omc.omc08,l_omc.omc09,g_net,l_omc.omc01,l_omc.omc02   #MOD-970296
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
           LET g_success = 'N'
           EXIT FOREACH 
        END IF 
      END FOREACH 
      IF g_success = 'N' THEN 
         CALL cl_err3("upd","omc_file",l_omc.omc01,l_omc.omc02,SQLCA.sqlcode,"","upd omc:",0)
         RETURN 
      END IF 
      LET l_omc08_s = 0
      LET l_omc09_s = 0
     #根據收款比率更新后，需求得多賬期原幣含稅金額總和、本幣含稅金額總和，與賬款原幣含稅金額和賬款本幣含稅金額進行比較。
     #求得差異后，將差異更新到多賬期最后一筆資料中。
      SELECT SUM(omc08),SUM(omc09) INTO l_omc08_s,l_omc09_s FROM omc_file
       WHERE omc01 = p_oma01
      IF l_omc08_s <> p_oma54t OR l_omc09_s <> p_oma56t THEN 
         LET l_diff_08 = p_oma54t - l_omc08_s
         LET l_diff_09 = p_oma56t - l_omc09_s
         UPDATE omc_file SET omc08 = omc08 + l_diff_08,
                             omc09 = omc09 + l_diff_09,
                             omc13 = omc13 + l_diff_09   #MOD-970296 add
          WHERE omc01 = p_oma01 AND omc02 = l_max_omc02
         IF SQLCA.sqlcode AND SQLCA.sqlerrd[3]=0 THEN 
            CALL cl_err3("upd","omc_file",p_oma01,l_max_omc02,SQLCA.sqlcode,"","upd omc:",0)
            LET g_success = 'N' 
            RETURN 
         END IF 
      END IF 
   END IF 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
