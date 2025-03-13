# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_credit2.4gl
# Descriptions...: (融資/中長貸)信貸額度檢查
# Date & Author..: 97/03/09 By Roger
# Modify.........: No.MOD-5B0338 05/12/06 By Smapmin 修改變數宣告
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-840250 08/04/21 By Smapmin 增加中長貸額度檢查
# Modify.........: No.MOD-910252 09/02/02 By Sarah 綜合額度應抓該合約編號的全額度
# Modify.........: No:MOD-A40153 10/04/26 By sabrina 計算信用額度時應判斷是否已存在aapt820
# Modify.........: No:MOD-A90075 10/09/10 By Dido 變數 amt4 若無資料需設定為 0 
# Modify.........: No:MOD-B60170 11/06/20 By Dido s_credit2_cur 可依類別為條件,不會影響 FOREACH 抓取問題 
# Modify.........: NO.CHI-C90047 13/01/16 By Yiting  程式中計算己動用額度時，以融資anmt710為例，漏考慮當融資幣別不同於合約anmi711單身融資種類幣別(nnp07)時
#                                                    就直接就以融資原幣換算額度匯率計算動用金額,應先判斷單據的原據<> nnp07時，先做一段換匯的動作
# Modify.........: NO.MOD-D20055 13/02/07 By apo 取ala_file,nng_file,alh_file,nne_file時,應加入取出各自的key值，並帶入計算額度的SQL條件式中,以免金額重複計算
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_credit2(p_show,p_bank,p_cons,p_type)   
   DEFINE p_show	LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1) #Y:要顯示 N:不顯示
   DEFINE p_bank	LIKE ala_file.ala07          #No.FUN-680147 VARCHAR(11) #信貸銀行
   DEFINE p_cons        LIKE nno_file.nno01  #合約編號
   DEFINE p_type        LIKE nno_file.nno01  #種類
#MOD-5B0338
  DEFINE y_amt1    LIKE ala_file.ala23
  DEFINE y_amt2    LIKE nne_file.nne12
  DEFINE y_amt3    LIKE nng_file.nng20   #MOD-840250
  DEFINE y_amt4    LIKE alh_file.alh14   #MOD-A40153 add
  DEFINE u_amt1    LIKE ala_file.ala23
  DEFINE u_amt2    LIKE nne_file.nne12
  DEFINE u_amt3    LIKE nng_file.nng20   #MOD-840250
  DEFINE u_amt4    LIKE alh_file.alh14   #MOD-A40153 add
  DEFINE used_amt1 LIKE nne_file.nne12
  DEFINE used_amt2 LIKE nne_file.nne12
  DEFINE bal       LIKE nne_file.nne12
#   DEFINE y_amt1 ,y_amt2   INTEGER
#   DEFINE u_amt1 ,u_amt2   INTEGER
#   DEFINE used_amt1 ,used_amt2 INTEGER
#   DEFINE bal                  INTEGER
#END MOD-5B0338
   DEFINE l_nnp		RECORD LIKE nnp_file.*
   DEFINE l_nno02       LIKE nno_file.nno02  
   DEFINE l_nnn02       LIKE nnn_file.nnn02  
   DEFINE y_nnp03       LIKE nnp_file.nnp03  
   DEFINE y_nnp07       LIKE nnp_file.nnp07  
   DEFINE y_nnp08       LIKE nnp_file.nnp08  
   DEFINE y_nnp09       LIKE nnp_file.nnp09  
   DEFINE l_nnp09       LIKE nnp_file.nnp09     #MOD-910252 add
   DEFINE l_nnp04       LIKE nnp_file.nnp04     #MOD-910252 add
   DEFINE l_chr		LIKE type_file.chr1     #No.FUN-680147 VARCHAR(1)
   DEFINE l_ala20       LIKE ala_file.ala20       #CHI-C90047
   DEFINE l_ala08       LIKE ala_file.ala08       #CHI-C90047
   DEFINE l_nne16       LIKE nne_file.nne16       #CHI-C90047
   DEFINE l_nne02       LIKE nne_file.nne02       #CHI-C90047
   DEFINE l_nng18       LIKE nng_file.nng18       #CHI-C90047
   DEFINE l_nng02       LIKE nng_file.nng02       #CHI-C90047
   DEFINE l_alh11       LIKE alh_file.alh11       #CHI-C90047
   DEFINE l_alh021      LIKE alh_file.alh021      #CHI-C90047
   DEFINE l_rate2       LIKE nnp_file.nnp08       #CHI-C90047
   DEFINE l_rate1       LIKE nnp_file.nnp08       #CHI-C90047
   DEFINE l_ex_rate     LIKE nnp_file.nnp08       #CHI-C90047
   DEFINE l_nno06       LIKE nno_file.nno06       #CHI-C90047
   DEFINE y_amt1_sum    LIKE ala_file.ala23       #CHI-C90047 add 
   DEFINE y_amt2_sum    LIKE nne_file.nne12       #CHI-C90047 add  
   DEFINE y_amt3_sum    LIKE nng_file.nng20       #CHI-C90047 add
   DEFINE y_amt4_sum    LIKE alh_file.alh14       #CHI-C90047 add
   DEFINE u_amt1_sum    LIKE ala_file.ala23       #CHI-C90047 add
   DEFINE u_amt2_sum    LIKE nne_file.nne12       #CHI-C90047 add
   DEFINE u_amt3_sum    LIKE nng_file.nng20       #CHI-C90047 add
   DEFINE u_amt4_sum    LIKE alh_file.alh14       #CHI-C90047 add
   DEFINE l_ala_sql     STRING                    #CHI-C90047 add
   DEFINE l_nne_sql     STRING                    #CHI-C90047 add
   DEFINE l_nng_sql     STRING                    #CHI-C90047 add
   DEFINE l_alh_sql     STRING                    #CHI-C90047 add
   DEFINE l_nne01       LIKE nne_file.nne01   #MOD-D20055
   DEFINE l_ala01       LIKE ala_file.ala01   #MOD-D20055
   DEFINE l_alh01       LIKE alh_file.alh01   #MOD-D20055
   DEFINE l_nng01       LIKE nng_file.nng01   #MOD-D20055

   IF p_show='Y' THEN
      OPEN WINDOW s_credit2_w AT 6,6 WITH FORM "sub/42f/s_credit2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("s_credit2")
   END IF
 
   LET l_nnp09 = 0   #MOD-910252 add
   DECLARE s_credit2_cur CURSOR FOR
   #SELECT * FROM nnp_file WHERE nnp01=p_cons                    #MOD-910252      #MOD-B60170 mark
    SELECT * FROM nnp_file WHERE nnp01=p_cons AND nnp03= p_type  #MOD-910252 mark #MOD-B60170 remark
   FOREACH s_credit2_cur INTO l_nnp.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('sel nnp_file 1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
     #str MOD-910252 add
     #抓取綜合總額度
      SELECT SUM(nnp08*nnp09) INTO l_nnp09 FROM nnp_file
       WHERE nnp01=l_nnp.nnp01 AND nnp04='Y'
      IF cl_null(l_nnp09) THEN LET l_nnp09=0 END IF
     #end MOD-910252 add
      EXIT FOREACH
   END FOREACH
   SELECT nnp03,nnp07,nnp08,nnp09 INTO y_nnp03,y_nnp07,y_nnp08,y_nnp09
     FROM nnp_file
   #WHERE nnp01=p_cons AND nnp04='Y'      #MOD-910252 mark
    WHERE nnp01=p_cons AND nnp03=p_type   #MOD-910252
 
   IF STATUS  THEN
      LET y_nnp03=l_nnp.nnp03
      LET y_nnp08=l_nnp.nnp08  
      LET y_nnp07=l_nnp.nnp07
     #LET y_nnp09=l_nnp.nnp09   #MOD-910252 mark
      LET y_nnp09=l_nnp09       #MOD-910252
   END IF
  #str MOD-910252 add
   SELECT nnp04 INTO l_nnp04 FROM nnp_file
    WHERE nnp01=p_cons AND nnp03=p_type
   IF cl_null(l_nnp04) THEN LET l_nnp04='N' END IF
  #end MOD-910252 add
   #--->取信貸銀行/合約幣別
   #SELECT nno02 INTO l_nno02 FROM nno_file          #CHI-C90047 mark
   SELECT nno02,nno06 INTO l_nno02,l_nno06 FROM nno_file   #CHI-C90047 nod
    WHERE nno01 = l_nnp.nnp01
      AND nno09='N'
   IF SQLCA.sqlcode THEN LET l_nno02= ' '  END IF
   #--->取類別
   SELECT nnn02 INTO l_nnn02 FROM nnn_file WHERE nnn01 = l_nnp.nnp03
   IF SQLCA.sqlcode THEN LET l_nnn02= ' '  END IF
   IF p_show='Y' THEN
      DISPLAY l_nnp.nnp01 TO FORMONLY.nnp01      
      DISPLAY l_nnp.nnp03 TO FORMONLY.nnp03     
      DISPLAY y_nnp07     TO FORMONLY.nnp07     
      DISPLAY l_nnp.nnp07 TO FORMONLY.np072     
      DISPLAY y_nnp09     TO FORMONLY.nnp09     
      DISPLAY l_nnp.nnp09 TO FORMONLY.nnp09_2   
      DISPLAY l_nno02     TO FORMONLY.nno02     
      DISPLAY l_nnn02     TO FORMONLY.nnn02     
   END IF
  #---->動用額度總和 
   #--CHI-C90047 start--
  #LET l_ala_sql = "SELECT ala20,ala08",         #MOD-D20055 mark    #因為不一定每一筆資料都是同原幣，所以要以迴圈方式取出每筆資料幣別再一一進行換算
   LET l_ala_sql = "SELECT ala20,ala08,ala01",   #因為不一定每一筆資料都是同原幣，所以要以迴圈方式取出每筆資料幣別再一一進行換算  #MOD-D20055
               "  FROM ala_file ",
               " WHERE ala07='",p_bank,"'",
               "   AND alafirm='Y' ",
               "   AND alaclos='N' ",
               "   AND ala33 = '",p_cons,"'" 
   PREPARE s_ala_p1 FROM l_ala_sql
   DECLARE s_ala_c CURSOR FOR s_ala_p1

  #LET l_nne_sql = " SELECT nne16,nne02 ",        #MOD-D20055 mark
   LET l_nne_sql = " SELECT nne01,nne16,nne02 ",  #MOD-D20055
               "   FROM nne_file ",
               "  WHERE nne04='",p_bank,"'",
               "    AND nneconf='Y' ",
               "    AND nne30='",p_cons,"'"
   PREPARE s_nne_p1 FROM l_nne_sql
   DECLARE s_nne_c CURSOR FOR s_nne_p1

  #LET l_nng_sql = " SELECT nng18,nng02 ",         #MOD-D20055 mark 
   LET l_nng_sql = " SELECT nng18,nng02,nng01 ",   #MOD-D20055
               "   FROM nng_file ",
               "  WHERE nng04='",p_bank,"'",
               "    AND nngconf='Y'", 
               "    AND nng52='",p_cons,"'" 
   PREPARE s_nng_p1 FROM l_nng_sql
   DECLARE s_nng_c CURSOR FOR s_nng_p1

  #LET l_alh_sql = " SELECT alh11,alh021 ",        #MOD-D20055 mark
   LET l_alh_sql = " SELECT alh11,alh021,alh01 ",  #MOD-D20055
               "   FROM alh_file,ala_file ",
               "  WHERE alh06 = '",p_bank,"'",
               "    AND alhfirm = 'Y'",
               "    AND alh03 = ala01 AND ala33 = '",p_cons,"'"
   PREPARE s_alh_p1 FROM l_alh_sql
   DECLARE s_alh_c CURSOR FOR s_alh_p1

   LET y_amt1_sum = 0                         
   LET l_ala20 = null                       
  #FOREACH s_ala_c INTO l_ala20,l_ala08            #MOD-D20055 mark    
   FOREACH s_ala_c INTO l_ala20,l_ala08,l_ala01    #MOD-D20055  
       IF l_ala20 <> l_nno06  THEN     #與合約幣別不同時要先換算
            CALL s_curr3(l_ala20,l_ala08,'B') RETURNING l_rate1
            CALL s_curr3(l_nno06,l_ala08,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

            SELECT SUM((ala23+ala24)*l_ex_rate*ala79) INTO y_amt1     #已開狀金額
                FROM ala_file
               WHERE ala07=p_bank AND alafirm='Y' AND alaclos='N'
                 AND ala33 = p_cons 
                 AND ala20 = l_ala20
                 AND ala01 = l_ala01  #MOD-D20055
       ELSE     
       #---CHI-C90047 end--------------------------
           SELECT SUM((ala23+ala24)*ala79) INTO y_amt1     #已開狀金額
               FROM ala_file
              WHERE ala07=p_bank AND alafirm='Y' AND alaclos='N'
                AND ala33 = p_cons 
                AND ala20 = l_ala20                        #CHI-C90047 add
                AND ala01 = l_ala01  #MOD-D20055
       END IF                                              #CHI-C90047 add
       IF cl_null(y_amt1) THEN LET y_amt1 = 0 END IF       #CHI-C90047 add
       LET y_amt1_sum = y_amt1_sum +  y_amt1               #CHI-C90047 add
   END FOREACH                                             #CHI-C90047 add 

   #---CHI-C90047 start----
   LET y_amt2_sum = 0      
   LET y_amt2 = 0
   LET l_nne16 = null         
  #FOREACH s_nne_c INTO l_nne16,l_nne02           #MOD-D20055 mark 
   FOREACH s_nne_c INTO l_nne01,l_nne16,l_nne02   #MOD-D20055
       IF l_nne16 <> l_nno06  THEN    
            CALL s_curr3(l_nne16,l_nne02,'B') RETURNING l_rate1
            CALL s_curr3(l_nno06,l_nne02,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

           SELECT SUM((nne12-nne27)*l_ex_rate*nneex2) INTO y_amt2            # 已使用額度
             FROM nne_file
            WHERE nne04=p_bank AND nneconf='Y' 
              AND nne30=p_cons 
              AND nne16=l_nne16
              AND nne01=l_nne01   #MOD-D20055
       ELSE
       #---CHI-C90047 end------
           SELECT SUM((nne12-nne27)*nneex2) INTO y_amt2            # 已使用額度
             FROM nne_file
            WHERE nne04=p_bank AND nneconf='Y' 
              AND nne30=p_cons 
              AND nne16=l_nne16                                    #CHI-C90047 add
              AND nne01=l_nne01                                    #MOD-D20055
       END IF                                                      #CHI-C90047 add
       IF cl_null(y_amt2) THEN LET y_amt2 = 0 END IF               #CHI-C90047 add
       LET y_amt2_sum = y_amt2_sum +  y_amt2                       #CHI-C90047 add
   END FOREACH                                                     #CHI-C90047 add
    
   #---CHI-C90047 start----
   LET y_amt3_sum = 0      
   LET y_amt3 = 0
   LET l_nng18 = null        
  #FOREACH s_nng_c INTO l_nng18,l_nng02           #MOD-D20055 mark
   FOREACH s_nng_c INTO l_nng18,l_nng02,l_nng01   #MOD-D20055
       IF l_nng18 <> l_nno06  THEN   
            CALL s_curr3(l_nng18,l_nng02,'B') RETURNING l_rate1
            CALL s_curr3(l_nno06,l_nng02,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

           SELECT SUM((nng20-nng21)*l_rate1*nngex2) INTO y_amt3            # 已使用額度
             FROM nng_file
            WHERE nng04=p_bank AND nngconf='Y' 
              AND nng52=p_cons 
              AND nng18=l_nng18
              AND nng01=l_nng01   #MOD-D20055
       ELSE
       #--CHI-C90047 end----
   #-----MOD-840250---------
           SELECT SUM((nng20-nng21)*nngex2) INTO y_amt3            # 已使用額度
             FROM nng_file
            WHERE nng04=p_bank AND nngconf='Y' 
              AND nng52=p_cons 
              AND nng18=l_nng18                                    #CHI-C90047 add
              AND nng01=l_nng01    #MOD-D20055
       END IF                                                      #CHI-C90047 add
       IF cl_null(y_amt3) THEN LET y_amt3 = 0 END IF               #CHI-C90047 add
       LET y_amt3_sum = y_amt3_sum +  y_amt3                       #CHI-C90047 add
   END FOREACH                                                     #CHI-C90047 add
   #-----END MOD-840250-----
 
   #---CHI-C90047 start----
   LET y_amt4_sum = 0      
   LET y_amt4 = 0
   LET l_alh11 = null          
  #FOREACH s_alh_c INTO l_alh11,l_alh021          #MOD-D20055 mark  
   FOREACH s_alh_c INTO l_alh11,l_alh021,l_alh01  #MOD-D20055
       IF l_alh11 <> l_nno06  THEN     #與合約單身的幣別不同時要先換成nnp07的幣別金額，再換成合約幣別
            CALL s_curr3(l_alh11,l_alh021,'B') RETURNING l_rate1
            CALL s_curr3(l_nno06,l_alh021,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

            SELECT SUM(alh14 * l_ex_rate* ala79) INTO y_amt4
              FROM alh_file,ala_file
             WHERE alh06 = p_bank AND alhfirm = 'Y'
               AND alh03 = ala01 AND ala33 = p_cons
               AND alh11 = l_alh11
               AND alh01 = l_alh01  #MOD-D20055
       ELSE
       #---CHI-C90047 end----
           #MOD-A40153---add---start---
           SELECT SUM(alh14 * ala79) INTO y_amt4
             FROM alh_file,ala_file
            WHERE alh06 = p_bank AND alhfirm = 'Y'
              AND alh03 = ala01 AND ala33 = p_cons
           #MOD-A40153---add---end---
              AND alh11 = l_alh11                                  #CHI-C90047 add
              AND alh01 = l_alh01   #MOD-D20055
       END IF                                                      #CHI-C90047 add
       IF cl_null(y_amt4) THEN LET y_amt4 = 0 END IF               #CHI-C90047 add
       LET y_amt4_sum = y_amt4_sum +  y_amt4                       #CHI-C90047 add
   END FOREACH                                                     #CHI-C90047 add

   #LET used_amt1 =y_amt1+y_amt2    #MOD-840250
   #LET used_amt1 =y_amt1+y_amt2+y_amt3-y_amt4    #MOD-840250  #MOD-A40153 add y_amt4  #CHI-C90047 mark
   LET used_amt1 =y_amt1_sum+y_amt2_sum+y_amt3_sum-y_amt4_sum   #CHI-C90047 add
 
  #----------------------------->  動用額度總和(by 合約單號+授信類別) 
   #---CHI-C90047 start--
   LET u_amt1_sum = 0
   LET u_amt1 = 0
   LET l_ala20 = null          
  #FOREACH s_ala_c INTO l_ala20,l_ala08           #MOD-D20055 mark  
   FOREACH s_ala_c INTO l_ala20,l_ala08,l_ala01   #MOD-D20055
       IF l_ala20 <> y_nnp07  THEN     #與合約單身的幣別不同時要先換成nnp07的幣別金額，再換成合約幣別
            CALL s_curr3(l_ala20,l_ala08,'B') RETURNING l_rate1
            CALL s_curr3(y_nnp07,l_ala08,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

            SELECT SUM((ala23+ala24)*l_ex_rate*ala79) INTO u_amt1    # 已開狀金額
              FROM ala_file
             WHERE ala07=p_bank AND alafirm='Y' AND alaclos='N'
               AND ala33 = p_cons AND ala35 = p_type
               AND ala20 = l_ala20
               AND ala01 = l_ala01   #MOD-D20055
       ELSE
   #---CHI-C90047 end----
           SELECT SUM((ala23+ala24)*ala79) INTO u_amt1    # 已開狀金額
             FROM ala_file
            WHERE ala07=p_bank AND alafirm='Y' AND alaclos='N'
              AND ala33 = p_cons AND ala35 = p_type
              AND ala20 = l_ala20                                     #CHI-C90047 add
              AND ala01 = l_ala01   #MOD-D20055
       END IF                                                         #CHI-C90047 add
       IF cl_null(u_amt1) THEN LET u_amt1 = 0 END IF                  #CHI-C90047 add
       LET u_amt1_sum = u_amt1_sum +  u_amt1                          #CHI-C90047 add
   END FOREACH                                                        #CHI-C90047 add
 
   #---CHI-C90047 start----
   LET u_amt2_sum = 0
   LET u_amt2 = 0
   LET l_nne16 = null         
  #FOREACH s_nne_c INTO l_nne16,l_nne02           #MOD-D20055 mark 
   FOREACH s_nne_c INTO l_nne01,l_nne16,l_nne02   #MOD-D20055
       IF l_nne16 <> y_nnp07  THEN     #與合約單身的幣別不同時要先換成nnp07的幣別金額，再換成合約幣別
            CALL s_curr3(l_nne16,l_nne02,'B') RETURNING l_rate1
            CALL s_curr3(y_nnp07,l_nne02,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

            SELECT SUM((nne12-nne27)*l_ex_rate*nneex2) INTO u_amt2           # 已使用額度
              FROM nne_file
             WHERE nne04=p_bank AND nneconf='Y' 
               AND nne30=p_cons AND nne06 = p_type   
               AND nne16=l_nne16
               AND nne01=l_nne01  #MOD-D20055
       ELSE
       #--CHI-C90047 end--------
            SELECT SUM((nne12-nne27)*nneex2) INTO u_amt2           # 已使用額度
              FROM nne_file
             WHERE nne04=p_bank AND nneconf='Y' 
               AND nne30=p_cons AND nne06 = p_type   
               AND nne16=l_nne16                                      #CHI-C90047 add
               AND nne01=l_nne01   #MOD-D20055
       END IF                                                         #CHI-C90047 add
       IF cl_null(u_amt2) THEN LET u_amt2 = 0 END IF                  #CHI-C90047 add
       LET u_amt2_sum = u_amt2_sum +  u_amt2                          #CHI-C90047 add
   END FOREACH                                                        #CHI-C90047 add
   #--CHI-C90047 end------
 
   #---CHI-C90047 start----
   LET u_amt3_sum = 0
   LET u_amt3 = 0
   LET l_nng18 = null        
  #FOREACH s_nng_c INTO l_nng18,l_nng02           #MOD-D20055 mark 
   FOREACH s_nng_c INTO l_nng18,l_nng02,l_nng01   #MOD-D20055
       IF l_nng18 <> y_nnp07  THEN     #與合約單身的幣別不同時要先換成nnp07的幣別金額，再換成合約幣別
            CALL s_curr3(l_nng18,l_nng02,'B') RETURNING l_rate1
            CALL s_curr3(y_nnp07,l_nng02,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

           SELECT SUM((nng20-nng21)*l_ex_rate*nngex2) INTO u_amt3           # 已使用額度
             FROM nng_file
            WHERE nng04=p_bank AND nngconf='Y' 
              AND nng52=p_cons AND nng24 = p_type   
              AND nng18=l_nng18
              AND nng01=l_nng01  #MOD-D20055
       ELSE
       #--CHI-C90047 end-----
   #-----MOD-840250---------
           SELECT SUM((nng20-nng21)*nngex2) INTO u_amt3           # 已使用額度
             FROM nng_file
            WHERE nng04=p_bank AND nngconf='Y' 
              AND nng52=p_cons AND nng24 = p_type   
              AND nng18=l_nng18                                   #CHI-C90047 add
              AND nng01=l_nng01  #MOD-D20055
       END IF                                                     #CHI-C90047 add
       IF cl_null(u_amt3) THEN LET u_amt3 = 0 END IF              #CHI-C90047 add
       LET u_amt3_sum = u_amt3_sum +  u_amt3                      #CHI-C90047 add
   END FOREACH                                                    #CHI-C90047 add
   #-----END MOD-840250-----
 
   #---CHI-C90047 start----
   LET u_amt4_sum = 0
   LET u_amt4 = 0
   LET l_alh11 = null          
   #FOREACH s_alh_c INTO l_alh11,l_alh021    #MOD-D20055 mark
   FOREACH s_alh_c INTO l_alh11,l_alh021,l_alh01  #MOD-D20055  
       IF l_alh11 <> y_nnp07  THEN     #與合約單身的幣別不同時要先換成nnp07的幣別金額，再換成合約幣別
            CALL s_curr3(l_alh11,l_alh021,'B') RETURNING l_rate1
            CALL s_curr3(y_nnp07,l_alh021,'B') RETURNING l_rate2
            LET l_ex_rate = l_rate1/l_rate2

           SELECT SUM(alh14 * l_ex_rate * ala79) INTO u_amt4
             FROM alh_file,ala_file
            WHERE alh06 = p_bank AND alhfirm = 'Y'
              AND alh03 = ala01 AND ala33 = p_cons
              AND ala35 = p_type AND alh11= l_alh11
              AND alh01 = l_alh01  #MOD-D20055
       ELSE
       #---CHI-C90047 end------
       #MOD-A40153---add---start---
            SELECT SUM(alh14 * ala79) INTO u_amt4
              FROM alh_file,ala_file
             WHERE alh06 = p_bank AND alhfirm = 'Y'
               AND alh03 = ala01 AND ala33 = p_cons
               AND ala35 = p_type
               AND alh11 = l_alh11                    #CHI-C90047 add
               AND alh01 = l_alh01    #MOD-D20055
       #MOD-A40153---add---end---
       END IF                                         #CHI-C90047 add
       IF u_amt4 IS NULL THEN LET u_amt4=0  END IF   #MOD-A90075
       LET u_amt4_sum = u_amt4_sum +  u_amt4          #CHI-C90047 add
   END FOREACH                                        #CHI-C90047 add

   #LET used_amt2 =u_amt1+u_amt2    #MOD-840250
   #LET used_amt2 =u_amt1+u_amt2+u_amt3-u_amt4    #MOD-840250  #MOD-A40153 add u_amt4   #CHI-C90047 mark
   LET used_amt2 =u_amt1_sum+u_amt2_sum+u_amt3_sum-u_amt4_sum  #CHI-C90047 mod
 
   #------------------------------取餘額=額度-旗動用額度-動用額度
  #str MOD-910252 mod
  #LET bal =(y_nnp08*y_nnp09)-used_amt1
   IF l_nnp04 = 'Y' THEN   #綜合
      LET bal =l_nnp09-used_amt1
   ELSE
      LET bal =y_nnp08*y_nnp09-used_amt2
   END IF
  #end MOD-910252 mod
   IF p_show='Y' THEN 
      DISPLAY BY NAME used_amt1,used_amt2,bal
   END IF
   #-----------------------------------------
   IF p_show='Y' THEN
#     PROMPT ">" FOR CHAR l_chr
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#     
#     END PROMPT
      CALL cl_anykey("Y")
      CLOSE WINDOW s_credit2_w
   END IF
  #RETURN y_nnp09,l_nnp.nnp09,used_amt1,used_amt2,bal   #MOD-910252 mark
   RETURN l_nnp09,l_nnp.nnp09,used_amt1,used_amt2,bal   #MOD-910252
   #      綜合額度,授信類別額度,綜合動用額度,授信類別動用額度,餘額
END FUNCTION
