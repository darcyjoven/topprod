# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Program name...: s_ccc.4gl
# Descriptions...: 
# Date & Author..: 
# Memo...........: No.+012 信用額度依每張單據加總金額, 並增加參數
#                         1.立帳匯率 2.當日匯率  010402 by linda modify
#                  注意!!! 必須維持cal_t51()至cal_t70()之function與axmq210,axmr210相同
# Modify.........: No.MOD-4B0135 04/11/16 By Mandy 讓'信用彙總查核'中可再選擇要查哪一細項資料
# Modify.........: No.FUN-4B0071 04/11/25 By Mandy DEFINE匯率欄位,改用LIKE方式
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: NO.FUN-630086 06/04/04 By Niocla 多工廠客戶信用查詢
# Modify.........: NO.FUN-640328 06/04/11 By Joe 明細資料未出現改善
# Modify.........: NO.MOD-640569 06/04/26 By Nicola 出貨改用況狀碼判斷
# Modify.........: No.TQC-5C0086 05/12/21 By Carrier AR月底重評修改
# Modify.........: No.FUN-650020 06/05/26 By kim 整合信用額度的錯誤訊息為一個視窗,不要每筆都秀
# Modify.........: No.FUN-640248 06/06/01 By Echo 自動執行確認功能
# Modify.........: No.MOD-640498 06/06/21 By Mandy s_ccc_cal_t66() pab_amt==>由SUM(oeb24*oeb13) 的值不正確
# Modify.........: NO.MOD-650058 06/06/21 By Mandy承MOD-640498補強, pab_amt應該要抓當站資料庫的資料來計算
# Modify.........: No.FUN-680022 06/08/24 By cl   多帳期處理
# Modify.........: No.FUN-680147 06/09/15 By czl 欄位型態定義,改為LIKE
# Modify.........: No.MOD-6A0121 06/12/14 By pengu FUNCTION cal_t66中,SELECT oeb24*oeb13要改成SELECT SUM(oeb24*oeb13)
# Modify.........: No.FUN-710080 07/02/06 By Sarah s_ccc_cal_t65()裡的l_sql1寫法有誤(漏掉一些 , 跟"'")
# Modify.........: No.FUN-740016 07/05/08 By Nicola 借出管理
# Modify.........: No.MOD-7A0064 07/10/15 By Smapmin 修改SQL語法
# Modify.........: No.MOD-7A0077 07/10/25 By Pengu 出至境外倉流程不應改考慮信用額度
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.FUN-640215 08/02/13 By Mandy s_exrate()改用s_exrate_m() 
# Modify.........: No.MOD-820186 08/03/24 By chenl 增加折扣率計算
# Modify.........: No.MOD-840102 08/04/14 By chenl 修正FUN-680022錯誤,不再分衝賬到項次，直接取已立衝賬未審核的金額。
# Modify.........: No.MOD-840337 08/04/24 By claire 調整MOD-820186語法
# Modify.........: No.MOD-840336 08/04/24 By claire 調整MOD-820186語法
# Modify.........: No.MOD-860089 08/06/10 By Smapmin 抓取訂單單身資料時,要加上oeb12>oeb24的條件
# Modify.........: No.FUN-870084 08/09/03 By xiaofeizhu nmh24 MATCHES '[1234] 條件式，要改為nmh24 IN ('1','2','3') OR (nmh24 IN ('4') AND nmh05 >= g_today)
# Modify.........: No.MOD-890063 08/09/09 By Smapmin 修改抓取已轉出貨單金額
# Modify.........: No.MOD-890205 08/09/22 By Smapmin 拿掉oeb12>oeb24的條件
# Modify.........: Mo:MOD-8A0126 08/10/16 By chenyu 1.出貨單在審核時，判斷信用超限沒有考慮當前筆的金額
#                                                   2.在計算訂單的信用時，使用計價單位的時候，需要有轉換率
#                                                   3.在計算訂單已出貨金額的時候，要考慮當前筆的金額
# Modify.........: No.CHI-8A0011 08/10/21 By Smapmin 計算出通單金額時,匯率應抓取出通單當下的匯率
# Modify.........: No.MOD-8B0078 08/11/07 By Smapmin 抓取出通單金額/出貨單金額時,應過濾已結案的訂單
# Modify.........: No.MOD-8B0191 08/11/19 By clover 修改FUN-870084 條件式nmh24 MATCHS '[123]' 括號
# Modify.........: No.TQC-8C0071 08/12/25 By Smapmin 修改變數定義
# Modify.........: No.CHI-8C0028 09/01/12 By xiaofeizhu oga09的條件由2348調整為23468
# Modify.........: No.TQC-950028 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法    
# Modify.........: No.MOD-960274 09/06/30 By Smapmin admr110呼叫時,回傳的信用餘額為0
# Modify.........: No.TQC-970038 09/07/03 By lilingyu 將參數p_slip傳入到s_ccc2
# Modify.........: No.CHI-910034 09/07/14 By chenmoyan 金額部分按照幣種做小數取位
# Modify.........: No.MOD-970082 09/07/20 By liuxqa 抓取逾期余額時，應用立賬金額減去已審核的衝賬金額。
# Modify.........: No.FUN-980020 09/09/02 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.MOD-990044 09/09/07 By Dido 條件調整
# Modify.........: No.FUN-980094 09/09/15 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-980048 09/09/17 By Dido 應收逾期帳(t65)計算邏輯調整(應收-已沖-未確認收款) 
# Modify.........: No.TQC-9C0099 09/12/15 By jan mark時漏寫#符
# Modify.........: No:CHI-9C0003 09/12/17 By Smapmin 待抵的金額回頭抓訂金的金額
# Modify.........: No:TQC-9C0162 09/12/22 By lilingyu 不作信用檢查時,不需跳出信用明細畫面
# Modify.........: No:MOD-9C0317 09/12/24 By Smapmin 還原CHI-9C0003
# Modify.........: No:MOD-9C0316 09/12/25 By sabrina 跨資料庫拋轉 
# Modify.........: No:MOD-A50023 10/05/05 By sabrina 信用額度計算有誤
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-AC0125 10/12/15 By lilingyu 客戶額度,已發生的額度數據來源都應該抓取營運中心的數據,現在抓的是當前庫的
# Modify.........: No:CHI-AC0030 10/12/22 By Summer 調整所有FOREACH內的CURSOR往外移
# Modify.........: No:TQC-AC0345 10/12/24 By lilingyu MOD-AC0125 多角貿易額度控管,沒有考慮到非多角的情況
# Modify.........: No:TQC-B10018 11/01/05 By lilingyu axmr221額度檢查匯總表無法顯示相關數據
# Modify.........: No:CHI-AC0036 11/01/06 By Smapmin 送簽中的單據也要納入計算
# Modify.........: No:MOD-B30462 11/03/16 By Summer 信用查核時只限定訂單不秀訊息,因為出貨在"客戶相關查詢"ACTION動作時,仍是要秀訊息才合理
# Modify.........: No:MOD-B60164 11/06/20 By JoHung 將t64_cur_1 SQL中的計算改到FOREACH中計算
# Modify.........: No:MOD-B60171 11/06/20 By JoHung 信用查核時，整批處理不show訊息
# Modify.........: No:MOD-B70001 11/07/01 By JoHung SQL加入跨資料庫語法
# Modify.........: No:MOD-B70208 11/07/22 By JoHung 客戶不作信用查核時不show訊息判斷加上axmr600
# Modify.........: No:MOD-B70221 11/07/22 By JoHung pab_amt計算後應取位
# Modify.........: No:MOD-B80027 11/08/03 By johung 計算出貨通知單應加上未結案項次條件 
# Modify.........: No:CHI-B80050 11/09/09 By johung 不作信用查核時不show訊息判斷加上axmt700
# Modify.........: No:MOD-BC0077 11/12/08 By Polly 修正條件，銷售信用狀需確認才產生額度異動
# Modify.........: No:MOD-BC0150 11/12/14 By Vampire 修正FUN-980020              
# Modify.........: No:MOD-C40144 12/04/19 By Elise FUN-980020修正過,但有漏掉的,請調整
# Modify.........: No:MOD-C50080 12/05/11 By Elise 增加顯示錯誤訊息"逾期應收或逾期未兌現票據"
# Modify.........: No:FUN-C50136 12/06/26 By xianghui 新增信用管控處理方法
# Modify.........: No.MOD-C60138 12/07/15 By SunLM t_azi03,04已經在top.global中定義,此處需要mark
# Modify.........: No:MOD-C80206 12/09/05 By Summer 出貨與應收不論單價是否含稅都是用未稅推含稅,訂單比照調整 
# Modify.........: No:CHI-C80033 12/12/26 By Summer 待抵帳款23類增加乘於稅率 
# Modify.........: No:MOD-CB0219 13/03/08 By Elise 客戶代號不等於額度客戶時，應抓額度客戶的寬限天數

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE gi_ccc_logerr LIKE type_file.num5         #No.FUN-680147 SMALLINT #FUN-650020
 
GLOBALS
   DEFINE g_ocg         RECORD LIKE ocg_file.*
   DEFINE g_chr         LIKE type_file.chr1    #No.FUN-680147 VARCHAR(1)
   DEFINE g_cnt         LIKE type_file.num10  # 欲得超信用餘額, 請在主程式使用本變數即可  #No.FUN-680147 INTEGER
   DEFINE g_curr        LIKE occ_file.occ631      #No.FUN-680147 VARCHAR(4)
   DEFINE g_exrate      LIKE azk_file.azk03   #FUN-4B0071
   DEFINE g_aza17       LIKE aza_file.aza17
   DEFINE l_occ631_o    LIKE occ_file.occ631  #010928  額度幣別
   DEFINE l_occ631      LIKE occ_file.occ631    #990512  額度幣別
   DEFINE l_occ36       LIKE occ_file.occ36   #寬現天數
   DEFINE l_oea01       LIKE oea_file.oea01     #No.FUN-680147 VARCHAR(16)       #No.FUN-560002
   DEFINE g_occ33       LIKE occ_file.occ33     #010928 add 額度客戶 
   DEFINE g_occ         RECORD LIKE occ_file.*  #010928 add 
END GLOBALS
#DEFINE    t_azi03       LIKE azi_file.azi03     #No.MOD-820186 # MOD-C60138
#DEFINE    t_azi04       LIKE azi_file.azi04     #No.MOD-820186 # MOD-C60138
DEFINE    g_chr1        LIKE type_file.chr1     #TQC-9C0162 
DEFINE    g_flag        LIKE type_file.chr1     #TQC-AC0345
DEFINE    g_azp03       LIKE azp_file.azp03     #TQC-AC0345
DEFINE    g_azp01       LIKE azp_file.azp01     #MOD-C40144
#DEFINE    t_plant_new   LIKE azp_file.azp01     #FUN-C50136
 
# 98/07/17 加傳一個參數p_slip, 本欄位僅供出貨通知單查核信用額度時使用.
FUNCTION s_ccc(p_cus_no,p_cmd,p_slip)           # Customer Credit Check  
   DEFINE p_cus_no            LIKE oea_file.oea01     #No.FUN-680147 VARCHAR(16)    #No.FUN-560002
   DEFINE p_cmd               LIKE type_file.chr1   # 1:有誤時顯示 2:一定顯示 3:回傳信用餘額  #No.FUN-680147 VARCHAR(1)
   DEFINE p_slip              LIKE oea_file.oea01     #No.FUN-680147 VARCHAR(16)       #No.FUN-560002
   DEFINE l_sql               STRING   #TQC-8C0071 VARCHAR(1000)-->STRING
   DEFINE l_occ11             LIKE occ_file.occ11      #No.FUN-680147 VARCHAR(8)
   DEFINE l_occ02,l_occ62     LIKE occ_file.occ02      #No.FUN-680147 VARCHAR(10)
   DEFINE l_msg,l_cmd         LIKE type_file.chr1000  #No.FUN-680147 VARCHAR(50)
   DEFINE t51,t52,t53,t54,t55,t61,t62,t63,t64,t65,t66,t67,t70,bal,tot   LIKE oma_file.oma57 #FUN-4C0031   #No.FUN-740016
   DEFINE s51,s52,s53,s54,s55,s61,s62,s63,s64,s65,s66,s67,s70,sbal,stot LIKE oma_file.oma57 #FUN-4C0031   #No.FUN-740016
   DEFINE l_occ63 LIKE occ_file.occ63,
          l_occ64 LIKE occ_file.occ64
   DEFINE l_str               STRING            #FUN-640248
#MOD-AC0125 --begin--
   DEFINE l_oea904            LIKE oea_file.oea904
   DEFINE l_poy02             LIKE poy_file.poy02
   DEFINE l_poy04             LIKE poy_file.poy04
#MOD-AC0125 --end--
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   LET g_flag = 'N'          #TQC-AC0345
      
#MOD-AC0125 --begin--
  SELECT oga16 INTO l_oea01 FROM oga_file
   WHERE oga01 = p_slip
  IF cl_null(l_oea01) THEN
     SELECT ogb31 INTO l_oea01 FROM ogb_file,oea_file
      WHERE oea01 = ogb31
        AND ogb01 = p_slip
  END IF

  SELECT oea904 INTO l_oea904 FROM oea_file
   WHERE oea01 = l_oea01
     AND oea905 = 'Y'
     AND oea99 IS NOT NULL
  IF NOT cl_null(l_oea904) THEN
     SELECT poy04 INTO l_poy04 FROM poy_file
      WHERE poy01 = l_oea904
        AND poy02 = '0'
     SELECT azp03,azp01 INTO g_azp03,g_azp01 FROM azp_file  #MOD-C40144 add g_azp01
      WHERE azp01 = l_poy04
     LET g_flag = 'Y'
  ELSE
     LET g_flag = 'N'
  END IF
#MOD-AC0125 --end-- 

  
#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
      SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
   ELSE
      LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                  " WHERE aza01 = '0'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
      PREPARE aza17_p1 FROM l_sql
      DECLARE aza17_cs1 CURSOR FOR aza17_p1
      FOREACH aza17_cs1 INTO g_aza17 END FOREACH
   END IF
#TQC-AC0345 --end--  
   IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
      SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
   ELSE
      LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".oaz_file",
                  " WHERE oaz00 = '0'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
      PREPARE oaz_p1 FROM l_sql
      DECLARE oaz_cs1 CURSOR FOR oaz_p1
      FOREACH oaz_cs1 INTO g_oaz.* END FOREACH
   END IF
#TQC-AC0345 --end--
   IF g_oaz.oaz211 IS NULL THEN
      LET g_oaz.oaz211='1'
   END IF
   IF g_oaz.oaz212 IS NULL THEN
      LET g_oaz.oaz212='B'
   END IF
  
  #-CHI-980048-add-  
 IF g_flag = 'N' THEN          #TQC-AC0345 
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
#TQC-AC0345 --begin--   
 ELSE
   LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ooz_file",
               " WHERE ooz00 = '0'" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
   PREPARE ooz_p1 FROM l_sql
   DECLARE ooz_cs1 CURSOR FOR ooz_p1
   FOREACH ooz_cs1 INTO g_ooz.* END FOREACH             
 END IF 
#TQC-AC0345 --end-- 	     
   IF g_ooz.ooz07 IS NULL THEN
      LET g_ooz.ooz07 = 'N'
   END IF
  #-CHI-980048-end-  
 
   #讀取額度客戶代號
#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
      SELECT occ33 INTO g_occ33 FROM occ_file WHERE occ01 = p_cus_no
   ELSE
      LET l_sql = "SELECT occ33 FROM ",g_azp03 CLIPPED,".occ_file",
                  " WHERE occ01 = '",p_cus_no,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
      PREPARE occ33_p1 FROM l_sql
      DECLARE occ33_cs1 CURSOR FOR occ33_p1
      FOREACH occ33_cs1 INTO g_occ33 END FOREACH
   END IF
#TQC-AC0345 --end--   
   IF cl_null(g_occ33)  THEN LET g_occ33  = p_cus_no END IF
 
   #讀取額度客戶所使用幣別
#MOD-AC0125 --begin--
  IF g_flag = 'N' THEN         #TQC-AC0345 
     SELECT occ631 INTO l_occ631_o FROM occ_file WHERE occ01 = g_occ33   
  ELSE      #TQC-AC0345
#     LET l_sql = "SELECT occ631 FROM ",l_poy04 CLIPPED,".occ_file",   #TQC-AC0345 
      LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",   #TQC-AC0345 
                  " WHERE occ01 = '",g_occ33,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
      PREPARE c_p1 FROM l_sql
      DECLARE c_cs1 CURSOR FOR c_p1
      FOREACH c_cs1 INTO l_occ631_o END FOREACH
  END IF                        #TQC-AC0345     
#MOD-AC0125 --end--     

   IF cl_null(l_occ631_o)  THEN LET l_occ631_o = g_aza17 END IF

  IF g_flag = 'N' THEN          #TQC-AC0345 
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_occ631_o #No.CHI-910034
#TQC-AC0345 --begin--
  ELSE
  	 LET l_sql = "SELECT azi04 FROM ",g_azp03 CLIPPED,".azi_file",
  	             " WHERE azi01 = '",l_occ631_o,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  	 PREPARE azi04_p1 FROM l_sql
  	 DECLARE azi04_cs1 CURSOR FOR azi04_p1
  	 FOREACH azi04_cs1 INTO t_azi04 END FOREACH             
  END IF  	  
#TQC-AC0345 --end-- 
  
   IF cl_null(g_occ33)  THEN LET g_occ33  = p_cus_no END IF

 IF g_flag = 'N' THEN            #TQC-AC0345 
   LET l_sql = "SELECT * FROM occ_file ",                        
               " WHERE occ01 ='",g_occ33 CLIPPED,
               "' OR ( occ33 ='",g_occ33 CLIPPED,
               "' AND occ33 IS NOT NULL ) AND occ62='Y' "
 ELSE        #TQC-AC0345                   
#   LET l_sql = "SELECT * FROM ",l_poy04 CLIPPED,".occ_file ",              #TQC-AC0345 
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".occ_file ",              #TQC-AC0345 
               " WHERE occ01 ='",g_occ33 CLIPPED,
               "' OR ( occ33 ='",g_occ33 CLIPPED,
               "' AND occ33 IS NOT NULL ) AND occ62='Y' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
 END IF       #TQC-AC0345               
               
   PREPARE ccc_pre1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('pre occ',SQLCA.SQLCODE,1)
      RETURN
   END IF   
 
   DECLARE ccc_curs CURSOR FOR ccc_pre1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('declare occ',SQLCA.SQLCODE,1)
      RETURN
   END IF   
 
   LET s51=0 LET s52=0 LET s53=0 LET s54=0 LET stot=0 LET s55=0
   LET s61=0 LET s62=0 LET s63=0 LET s64=0 LET s67=0  LET sbal=0   #No.FUN-740016
   LET s65=0 LET s66=0 LET s70=0
 
  #FUN-640248
  #MESSAGE "Credit Check!",g_occ.occ01 CLIPPED
   LET l_str = "Credit Check!",g_occ.occ01 CLIPPED
   CALL cl_msg(l_str)                               
  #END FUN-640248
 
   LET g_errno = 'Y'   #MOD-960274
   LET g_chr1 ='Y'    #TQC-9C0162
   FOREACH ccc_curs INTO g_occ.* 
      IF STATUS THEN 
         CALL cl_err('',STATUS,1)
         EXIT FOREACH
         RETURN 
      END IF 
 
      LET t51=0 LET t52=0 LET t53=0 LET t54=0 LET tot=0 LET t55=0
      LET t61=0 LET t62=0 LET t63=0 LET t64=0 LET t67=0 LET bal=0   #No.FUN-740016
      LET t65=0 LET t66=0 LET t70=0
 
      #/UN-640248
      #MESSAGE "Credit Check!",g_occ.occ01 CLIPPED
       LET l_str = "Credit Check!",g_occ.occ01 CLIPPED
       CALL cl_msg(l_str)                               
      #END FUN-640248
 
      IF g_occ.occ01 = g_occ33 THEN 
         LET l_occ02=g_occ.occ02 
         LET l_occ11=g_occ.occ11
         LET l_occ62=g_occ.occ62
         LET l_occ36=g_occ.occ36
      #MOD-CB0219 add start -----
      #客戶代號不等於額度客戶時,抓額度客戶的寬限天數
      ELSE
         IF g_flag = 'N' THEN
            select occ36 INTO l_occ36 FROM occ_file where occ01 = g_occ33
         ELSE
            LET l_sql = "SELECT occ36 FROM ",g_azp03 CLIPPED,".occ_file",
                        " WHERE occ01 = '",g_occ33,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            PREPARE occ36_pre FROM l_sql
            DECLARE occ36_cur CURSOR FOR occ36_pre
            OPEN occ36_cur
            FETCH occ36_cur INTO l_occ36
            CLOSE occ36_cur
         END IF
      #MOD-CB0219 add end   -----
      END IF
 
      #FUN-650020...............begin
      #IF l_occ62='N' THEN 
      #   CLOSE WINDOW screen
      #   CALL cl_err(l_occ02,'axm-403',1)
      #   EXIT FOREACH 
      #END IF
       IF l_occ62='N' THEN 
#         IF (g_prog[1,7]<>'axmt410' AND g_prog[1,7]<>'axmt420' AND g_prog[1,7]<>'axmt810') THEN #MOD-B30462 add   #MOD-B60171 mark
#MOD-B60171 -- begin --
          IF (g_prog[1,7]<>'axmt410' AND g_prog[1,7]<>'axmt420' AND g_prog[1,7]<>'axmt810'
             AND g_prog[1,7]<>'axmp200' AND g_prog[1,7]<>'axmp210' AND g_prog[1,7]<>'axmp220'
#            AND g_prog[1,7]<>'axmp230') THEN                              #MOD-B70208 mark
            #AND g_prog[1,7]<>'axmp230' AND g_prog[1,7]<>'axmr600') THEN   #MOD-B70208           #CHI-B80050 mark
#MOD-B60171 -- end --
             AND g_prog[1,7]<>'axmp230' AND g_prog[1,7]<>'axmr600') AND g_prog[1,7]<>'axmt700'   #CHI-B80050
             THEN                                                                                #CHI-B80050
             IF gi_ccc_logerr THEN 
               #CLOSE WINDOW screen
                LET g_showmsg=g_occ.occ01,"||","axm-403","||",l_occ02
                LET gi_ccc_logerr=FALSE
             ELSE
               #CLOSE WINDOW screen
               #FUN-640248
               #CALL cl_err(l_occ02,'axm-403',1)
                CALL cl_getmsg('axm-403',g_lang) RETURNING l_msg
                LET l_msg=l_occ02 CLIPPED, " ",l_msg CLIPPED
                CALL cl_msgany(1,1,l_msg)
               #END FUN-640248
             END IF
          END IF #MOD-B30462 add 
          LET g_chr1 = 'N'  #TQC-9C0162
          EXIT FOREACH
       END IF
      #FUN-650020...............end
      
      IF cl_null(l_occ36) THEN LET l_occ36=0 END IF
 
      #FUN-650020...............begin
      #IF cl_null(g_occ.occ61) AND l_occ62='Y' THEN  # 信用評等
      #   CALL cl_err('','axm-270',1)
      #   EXIT FOREACH  
      #END IF     
       IF cl_null(g_occ.occ61) AND l_occ62='Y' THEN  # 信用評等
          IF gi_ccc_logerr THEN
             LET g_showmsg=g_occ.occ01,"||","axm-270","||",l_occ02
             LET gi_ccc_logerr=FALSE
          ELSE
             CALL cl_err('','axm-270',1)
          END IF
          LET g_errno = 'N'   #MOD-960274
          IF p_cmd != '3' THEN    #MOD-960274
             EXIT FOREACH
          END IF   #MOD-960274
       END IF     
      #FUN-650020...............end
 
      ###---- 多工廠信用查核 Modify by WUPN 96-05-23 ---#
#MOD-AC0125 --begin--
   IF g_flag = 'N' THEN       #TQC-AC0345 
      SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01=g_occ.occ61
   ELSE                       #TQC-AC0345    
#     LET l_sql = "SELECT * FROM ",l_poy04 CLIPPED,".ocg_file",   #TQC-AC0345 
      LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",   #TQC-AC0345 
                  " WHERE ocg01 = '",g_occ.occ61,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
      PREPARE c_p2 FROM l_sql
      DECLARE c_cs2 CURSOR FOR c_p2
      FOREACH c_cs2 INTO g_ocg.* END FOREACH
   END IF    #TQC-AC0345    
#MOD-AC0125 --end--

      #FUN-650020...............begin
     #IF STATUS THEN 
     #   CALL cl_err(g_occ.occ01,'axm-270',1) 
     #   LET g_errno = 'N'
     #   EXIT FOREACH 
     #END IF
      #IF STATUS THEN    #MOD-960274
      IF STATUS AND g_errno <> 'N' THEN    #MOD-960274
         IF gi_ccc_logerr THEN
            LET g_showmsg=g_occ.occ01,"||","axm-271","||",l_occ02   #MOD-960274 axm-270-->axm-271
            LET gi_ccc_logerr=FALSE
         ELSE
            CALL cl_err(g_occ.occ01,'axm-271',1)    #MOD-960274 axm-270-->axm-271
         END IF
         LET g_errno = 'N'
         IF p_cmd != '3' THEN    #MOD-960274
            EXIT FOREACH 
         END IF   #MOD-960274
      END IF
      #FUN-650020...............end
 
      ###-((1)-----------------------------------------
      IF g_ocg.ocg02 > 0 THEN     # 待抵帳款
         CALL s_ccc_cal_t51(g_occ.occ01,g_occ.occ61) RETURNING t51
      END IF 
      IF p_cmd = '1' 
      THEN 
             #FUN-640248
             #MESSAGE '51:',t51 
              LET l_str = '51:',t51 
              CALL cl_msg(l_str)                               
             #END FUN-640248
      END IF
 
      ###-((2)-----------------------------------------
      IF g_ocg.ocg03 > 0 THEN     # ＬＣ收狀   #No.FUN-630086
         CALL s_ccc_cal_t52(g_occ.occ01,g_occ.occ61) RETURNING t52
      END IF 
      IF p_cmd = '1' THEN
         #MESSAGE '52:',t52 
          LET l_str = '52:',t52           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((3)-----------------------------------------
      IF g_ocg.ocg04 > 0 THEN     # 財務暫收支票   #No.FUN-630086
         CALL s_ccc_cal_t53(g_occ.occ01,g_occ.occ61) RETURNING t53
      END IF 
      IF p_cmd = '1' THEN
         #MESSAGE '53:',t53 
          LET l_str = '53:',t53           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((4)-----------------------------------------
      IF g_ocg.ocg04 > 0 THEN     # 財務暫收ＴＴ   #No.FUN-630086
         CALL s_ccc_cal_t54(g_occ.occ01,g_occ.occ61) RETURNING t54
      END IF 
      IF p_cmd = '1' THEN
         #MESSAGE '54:',t54 
          LET l_str = '54:',t54           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((B)-----------------------------------------
      IF g_ocg.ocg05 > 0 THEN     # 沖帳未確認   #No.FUN-630086
         CALL s_ccc_cal_t55(g_occ.occ01,g_occ.occ61) RETURNING t55
      END IF 
      IF p_cmd = '1' THEN 
         #MESSAGE '55:',t55 
          LET l_str = '55:',t55           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((5)-----------------------------------------
      IF g_ocg.ocg06 > 0 THEN     # 未兌應收票據   #No.FUN-630086
         CALL s_ccc_cal_t61(g_occ.occ01,g_occ.occ61) RETURNING t61
      END IF 
      IF p_cmd = '1' THEN 
         #MESSAGE '61:',t61 
          LET l_str = '61:',t61           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((6)-----------------------------------------
      IF g_ocg.ocg07 > 0 THEN     # 發票應收 (AR)   #No.FUN-630086
         CALL s_ccc_cal_t62(g_occ.occ01,g_occ.occ61) RETURNING t62
      END IF 
      IF p_cmd = '1' THEN
         #MESSAGE '62:',t62 
          LET l_str = '62:',t62           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((7)-----------------------------------------
      IF g_ocg.ocg08 > 0 THEN     # 出貨未開發票  (PA)   #No.FUN-630086
         CALL s_ccc_cal_t63(g_occ.occ01,p_slip,g_occ.occ61) RETURNING t63
      END IF 
      IF p_cmd = '1' THEN
         #MESSAGE '63:',t63 
          LET l_str = '63:',t63           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((8)-----------------------------------------
      IF g_ocg.ocg09 > 0 THEN     # 出貨通知單  (IF)   #No.FUN-630086
         CALL s_ccc_cal_t66(g_occ.occ01,p_slip,g_occ.occ61) RETURNING t66
      END IF 
      IF p_cmd = '1' THEN
         #MESSAGE '66:',t66 
          LET l_str = '66:',t66           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((9)-----------------------------------------
      IF g_ocg.ocg10 > 0 THEN     # 接單未出貨  (SO)   #No.FUN-630086
         CALL s_ccc_cal_t64(g_occ.occ01,p_slip,g_occ.occ61) RETURNING t64
      END IF 
      IF p_cmd = '1' THEN 
         #MESSAGE '64:',t64 
          LET l_str = '64:',t64           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      #-----No.FUN-740016-----
      ###-((D)-----------------------------------------
      IF g_ocg.ocg10 > 0 THEN     # 接單未出貨  (SO) 
         CALL s_ccc_cal_t67(g_occ.occ01,p_slip,g_occ.occ61) RETURNING t67
      END IF 
      IF p_cmd = '1' THEN 
          LET l_str = '67:',t67
          CALL cl_msg(l_str)
      END IF
      #-----No.FUN-740016 END-----
 
      ###-((A)-----------------------------------------
      IF g_ocg.ocg11 = 'Y' THEN   # 逾期應收  (OVERDUE)   #No.FUN-630086
         CALL s_ccc_cal_t65(g_occ.occ01,g_occ.occ61) RETURNING t65
      END IF
      IF p_cmd = '1' THEN 
         #MESSAGE '65:',t65 
          LET l_str = '65:',t65           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((C)-----------------------------------------
      IF g_ocg.ocg12 = 'Y' THEN   # 逾期未兌現票據   #No.FUN-630086
         CALL s_ccc_cal_t70(g_occ.occ01,g_occ.occ61) RETURNING t70
      END IF
      IF p_cmd = '1' THEN 
         #MESSAGE '70:',t70 
          LET l_str = '70:',t70           #FUN-640248
          CALL cl_msg(l_str)              #FUN-640248
      END IF
 
      ###-((-)-----------------------------------------
      IF cl_null(g_occ.occ63) THEN LET g_occ.occ63=0 END IF
      IF cl_null(g_occ.occ64) THEN LET g_occ.occ64=0 END IF
      LET tot=g_occ.occ63*(1+g_occ.occ64/100)  #信用額度總額
      IF cl_null(tot) THEN LET tot = 0 END IF 
 
      #信用餘額
      LET bal = tot + t51 + t52 + t53 + t54 + t55 - t61 - t62 - t63 - t64 - t66 - t67   #No.FUN-740016
      
      #各客戶金額合計 
      IF g_occ.occ631 = l_occ631_o THEN
         #使用幣別與額度客戶之幣別相同時
         LET s51 = s51 + t51 
         LET s52 = s52 + t52 
         LET s53 = s53 + t53 
         LET s54 = s54 + t54 
         LET s55 = s55 + t55 
         LET s61 = s61 + t61 
         LET s62 = s62 + t62 
         LET s63 = s63 + t63 
         LET s64 = s64 + t64 
         LET s67 = s67 + t67   #No.FUN-740016 
         LET s65 = s65 + t65   #no.4967
         LET s66 = s66 + t66 
         LET s70 = s70 + t70   #no.4967
         LET stot= stot+ tot
      ELSE 
         #幣別轉換
        #LET g_exrate=s_exrate  (g_occ.occ631,l_occ631_o,g_oaz.oaz212)    #FUN-640215 mark
         IF g_flag = 'N' THEN         #TQC-AC0345
           LET g_exrate=s_exrate_m(g_occ.occ631,l_occ631_o,g_oaz.oaz212,'') #FUN-640215 add
         ELSE                         #TQC-AC0345
          #LET g_exrate=s_exrate_m(g_occ.occ631,l_occ631_o,g_oaz.oaz212,g_azp03)   #TQC-AC0345  #MOD-C40144 mark
           LET g_exrate=s_exrate_m(g_occ.occ631,l_occ631_o,g_oaz.oaz212,g_azp01)   #MOD-C40144
         END IF 	                    #TQC-AC0345
         LET s51 = s51 + t51 * g_exrate
         LET s52 = s52 + t52 * g_exrate
         LET s53 = s53 + t53 * g_exrate
         LET s54 = s54 + t54 * g_exrate
         LET s55 = s55 + t55 * g_exrate
         LET s61 = s61 + t61 * g_exrate
         LET s62 = s62 + t62 * g_exrate
         LET s63 = s63 + t63 * g_exrate
         LET s64 = s64 + t64 * g_exrate
         LET s67 = s67 + t67 * g_exrate   #No.FUN-740016
         LET s65 = s65 + t65 * g_exrate #no.4967
         LET s66 = s66 + t66 * g_exrate
         LET s70 = s70 + t70 * g_exrate #no.4967
         LET stot= stot+ tot * g_exrate
      END IF 
      LET sbal=stot+s51+s52+s53+s54+s55-s61-s62-s63-s64-s66-s67   #No.FUN-740016
   END FOREACH 
 
   IF sbal < 0 THEN 
      LET g_errno = 'N'
   ELSE
      LET g_errno = 'Y'
   END IF
 
   LET g_cnt=sbal
 
   IF g_errno='Y' THEN
      #逾期應收 或 逾期未兌現票據
      IF s65 > 0 OR s70 > 0 THEN
         LET g_errno = 'N'
         CALL cl_err('','axm-689',1)  #MOD-C50080 add 
      END IF
   END IF
 
  #MESSAGE ""
   CALL cl_msg("")                                       #FUN-640248
 
 
   IF p_cmd='3' THEN         #modi by kitty 02/07/29
      RETURN sbal 
   END IF
 
   IF ((p_cmd = '1' AND bal < 0) OR (p_cmd='2')) AND  
      (g_bgjob='N' OR cl_null(g_bgjob))                    #FUN-640248
   THEN
     IF g_chr1 = 'Y' THEN   #TQC-9C0162 
      OPEN WINDOW s_ccc_w AT 3,20 WITH FORM "sub/42f/s_ccc"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      
      CALL cl_ui_locale("s_ccc")
          
      DISPLAY l_occ631_o TO FORMONLY.curr
  
      DISPLAY BY NAME g_occ33,l_occ02,stot,s51,s52,s53,s54,s55,s61,s62,s63,
                      s66,s64,s67,sbal,s65,s70    #No.FUN-740016
      
      MENU ""
         ON ACTION query_detail
            #MOD-4B0135
           #LET l_cmd="axmq210 '",p_cus_no,"' ",g_chr
           #CALL cl_cmdrun(l_cmd)
           #CURRENT WINDOW IS s_ccc_w
#            CALL s_ccc2(p_cus_no)         #TQC-970038
             CALL s_ccc2(p_cus_no,p_slip)  #TQC-970038
            #MOD-4B0135(end)
         
         ON ACTION exit
            EXIT MENU
         
         ON ACTION accept
            EXIT MENU
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
         
         ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE        #MOD-570244 mars
            CLOSE WINDOW s_ccc_w
            EXIT MENU
  
      END MENU
 
      CLOSE WINDOW s_ccc_w
      CALL ui.Interface.refresh()
      END IF   #TQC-9C0162
   END IF
  #MESSAGE ""
   CALL cl_msg("")                              #FUN-640248
 
   #FINISH REPORT ccc_rep
END FUNCTION

---------------------------#其他單要過單，所以C50136部分暫時mark---------------------------------------
##FUN-C50136----add----str----
#FUNCTION s_ccc_cy(p_cus_no,p_slip,p_plant)
#DEFINE p_cus_no  LIKE oea_file.oea01
#DEFINE l_sql               STRING 
#DEFINE l_oea904  LIKE oea_file.oea904
#DEFINE l_poy04   LIKE poy_file.poy04
#DEFINE p_slip    LIKE oea_file.oea01
#DEFINE p_plant   LIKE azp_file.azp01
#
#   LET g_flag = 'N' 
#   IF NOT cl_null(p_plant) THEN    
#      LET g_flag = 'Y'
#      LET t_plant_new = p_plant
#   ELSE
#      LET g_flag = 'N'
#   END IF
#
#   IF g_flag = 'N' THEN
#      SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
#   ELSE
#      LET l_sql = "SELECT aza17 FROM ",cl_get_target_table(t_plant_new,'aza_file'),
#                  " WHERE aza01 = '0'"
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
#      PREPARE aza17_p2 FROM l_sql
#      DECLARE aza17_cs2 CURSOR FOR aza17_p2
#      FOREACH aza17_cs2 INTO g_aza17 END FOREACH
#   END IF
#   IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
# 
#   IF g_flag = 'N' THEN
#      SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
#   ELSE
#      LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oaz_file'),
#                  " WHERE oaz00 = '0'"
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
#      PREPARE oaz_p2 FROM l_sql
#      DECLARE oaz_cs2 CURSOR FOR oaz_p2
#      FOREACH oaz_cs2 INTO g_oaz.* END FOREACH
#   END IF
#   IF g_oaz.oaz211 IS NULL THEN
#      LET g_oaz.oaz211='1'
#   END IF
#   IF g_oaz.oaz212 IS NULL THEN
#      LET g_oaz.oaz212='B'
#   END IF
#  
#   IF g_flag = 'N' THEN   
#     SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
#   ELSE
#     LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'ooz_file'),
#                 " WHERE ooz00 = '0'" 
#     CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
#     PREPARE ooz_p2 FROM l_sql
#     DECLARE ooz_cs2 CURSOR FOR ooz_p2
#     FOREACH ooz_cs2 INTO g_ooz.* END FOREACH             
#   END IF 
#   IF g_ooz.ooz07 IS NULL THEN
#      LET g_ooz.ooz07 = 'N'
#   END IF
# 
#   #讀取額度客戶代號
#   IF g_flag = 'N' THEN
#      SELECT occ33 INTO g_occ33 FROM occ_file WHERE occ01 = p_cus_no
#   ELSE
#      LET l_sql = "SELECT occ33 FROM ",cl_get_target_table(t_plant_new,'occ_file'),
#                  " WHERE occ01 = '",p_cus_no,"'"
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
#      PREPARE occ33_p2 FROM l_sql
#      DECLARE occ33_cs2 CURSOR FOR occ33_p2
#      FOREACH occ33_cs2 INTO g_occ33 END FOREACH
#   END IF
#   IF cl_null(g_occ33)  THEN LET g_occ33  = p_cus_no END IF
# 
#   #讀取額度客戶所使用幣別
#   IF g_flag = 'N' THEN 
#      SELECT occ631 INTO l_occ631_o FROM occ_file WHERE occ01 = g_occ33   
#   ELSE 
#      LET l_sql = "SELECT occ631 FROM ",cl_get_target_table(t_plant_new,'occ_file'),
#                  " WHERE occ01 = '",g_occ33,"'"
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
#      PREPARE c_p3 FROM l_sql
#      DECLARE c_cs3 CURSOR FOR c_p3
#      FOREACH c_cs3 INTO l_occ631_o END FOREACH
#   END IF    
#
#   IF cl_null(l_occ631_o)  THEN LET l_occ631_o = g_aza17 END IF
#
#   IF g_flag = 'N' THEN  
#      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_occ631_o
#   ELSE
#      LET l_sql = "SELECT azi04 FROM ",cl_get_target_table(t_plant_new,'azi_file'),
#                  " WHERE azi01 = '",l_occ631_o,"'"
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
#      PREPARE azi04_p2 FROM l_sql
#      DECLARE azi04_cs2 CURSOR FOR azi04_p2
#      FOREACH azi04_cs2 INTO t_azi04 END FOREACH             
#   END IF  	  
#END FUNCTION
#
#FUNCTION s_ccc_oia(p_cus_no,p_oia05,p_slip,p_no,p_plant)
#DEFINE l_n      LIKE type_file.num5
#DEFINE l_plant  LIKE oib_file.oibplant
#DEFINE l_sql    STRING
#DEFINE p_no     LIKE type_file.num5
#DEFINE p_oia05  LIKE oia_file.oia05     #異動程序
#DEFINE p_cus_no LIKE occ_file.occ01   #客戶編號
#DEFINE p_slip   LIKE oea_file.oea01    #單據編號
#DEFINE p_plant  LIKE azp_file.azp01
#DEFINE l_oia    RECORD LIKE oia_file.*
#DEFINE l_oib    RECORD LIKE oib_file.*
#DEFINE l_oea    RECORD LIKE oea_file.*
#DEFINE l_oeb    RECORD LIKE oeb_file.*
#DEFINE l_oep    RECORD LIKE oep_file.*
#DEFINE l_oeq    RECORD LIKE oeq_file.*
#DEFINE l_amt    LIKE oib_file.oib06
#DEFINE l_amt1   LIKE oib_file.oib06
#DEFINE l_amt11  LIKE oib_file.oib06
#DEFINE l_amt2   LIKE oib_file.oib06
#DEFINE l_occ61  LIKE occ_file.occ61 
#DEFINE l_oga    RECORD LIKE oga_file.*
#DEFINE l_ogb    RECORD LIKE ogb_file.*
#DEFINE l_ogbi   RECORD LIKE ogb_file.*
#DEFINE l_oha    RECORD LIKE oha_file.*
#DEFINE l_ohb    RECORD LIKE ohb_file.*
#DEFINE l_nmg    RECORD LIKE nmg_file.*
#DEFINE l_nmh    RECORD LIKE nmh_file.*
#DEFINE l_oic02  LIKE oic_file.oic02
#DEFINE l_occ62  LIKE occ_file.occ62
#DEFINE l_oma    RECORD LIKE oma_file.*
#DEFINE l_exrate LIKE azk_file.azk03
#DEFINE l_oia06  LIKE oia_file.oia06
#DEFINE l_oep08  LIKE oep_file.oep08
#DEFINE l_ola    RECORD LIKE ola_file.*
#DEFINE l_oga011 LIKE oga_file.oga011
#DEFINE l_oga01  LIKE oga_file.oga01
#DEFINE l_oia03  LIKE oia_file.oia03
#DEFINE l_oia08  LIKE oia_file.oia08
#DEFINE l_prog   LIKE type_file.chr20
#
#   CALL s_ccc_cy(p_cus_no,p_slip,p_plant)
#   #LET g_errno = 'Y'
#   IF g_flag = 'N' THEN
#      LET l_sql = "SELECT occ61,occ62 FROM occ_file ",
#                  " WHERE occ01 = '",p_cus_no,"'"
#   ELSE
#      LET l_sql = "SELECT occ61,occ62 FROM ",cl_get_target_table(t_plant_new,'occ_file'),
#                  " WHERE occ01 = '",p_cus_no,"'"
#   END IF
#   PREPARE sel_occ1 FROM l_sql
#   EXECUTE sel_occ1 INTO l_occ61,l_occ62
#   IF l_occ62 = 'N' THEN
#      IF (g_prog[1,7]<>'axmt410' AND g_prog[1,7]<>'axmt420' AND g_prog[1,7]<>'axmt810'
#          AND g_prog[1,7]<>'axmp200' AND g_prog[1,7]<>'axmp210' AND g_prog[1,7]<>'axmp220'
#          AND g_prog[1,7]<>'axmp230' AND g_prog[1,7]<>'axmr600' AND g_prog[1,7]<>'axmt700'
#          AND g_prog[1,7]<>'axmt620') THEN
#          CALL cl_err('','axm-841',0)
#      END IF
#      RETURN
#   END IF
#   IF cl_null(l_occ61) AND l_occ62='Y' THEN  # 信用評等
#      CALL cl_err('','axm-270',1)
#      RETURN                
#   END IF
#
#   LET l_n = 0
#   SELECT COUNT(*) INTO l_n FROM oia_file,oie_file
#    WHERE oia01 = l_occ61
#      AND oia05 = p_oia05 
#      AND oiaacti = 'Y'  
#      AND oie02 = g_plant 
#      AND oie01 = oia01     
#   IF l_n = 0 THEN
#      CALL cl_err('','axm-842',0)
#      RETURN 
#   END IF
#
#   ##銷退單需要同時檢查出貨單是否需要信用管控
#   IF p_oia05 ='G' THEN 
#      LET l_n = 0
#      SELECT COUNT(*) INTO l_n FROM oia_file,oie_file
#       WHERE oia01 = l_occ61
#         AND oia05 = 'D' 
#         AND oiaacti = 'Y'  
#         AND oie02 = g_plant 
#         AND oie01 = oia01     
#      IF l_n = 0 THEN
#         CALL cl_err('','axm-847',0)
#         RETURN 
#      END IF
#   END IF
#
#   SELECT * INTO l_oia.* FROM oia_file
#    WHERE oia01 = l_occ61 
#      AND oia05 = p_oia05
#
#   LET l_amt  = 0
#   LET l_amt1 = 0
#   LET l_amt2 = 0         #沖銷的額度
#   LET l_amt11= 0         #簽退單中簽退的額度
#  
#   IF g_flag = 'N' THEN 
#      LET l_sql = "INSERT INTO oib_file(oib01,oib02,oib03,oib04,oib041,",
#                                       "oib05,oib06,oib07,oib08,oib09,",
#                                       "oib10,oib11,oib12,oib121,oib122,",
#                                       "oiblegal,oibplant,oib13) ",
#                  " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?)"
#      LET l_plant = g_plant
#   ELSE
#      LET l_sql = "INSERT INTO ",cl_get_target_table(t_plant_new,'oib_file'),
#                               "(oib01,oib02,oib03,oib04,oib041,",
#                               "oib05,oib06,oib07,oib08,oib09,",
#                               "oib10,oib11,oib12,oib121,oib122,",
#                               "oiblegal,oibplant,oib13) ",
#                  " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?)"
#      LET l_plant = t_plant_new
#   END IF
#   PREPARE ins_oib FROM l_sql
#   
#   IF p_oia05 MATCHES '[A]' THEN  #一般訂單
#      IF g_flag = 'N' THEN 
#         LET l_sql = "SELECT * FROM oea_file ",
#                     " WHERE oea01 = '",p_slip,"'"
#      ELSE
#         LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oea_file'),
#                     " WHERE oea01 = '",p_slip,"'"
#      END IF
#      PREPARE sel_oea FROM l_sql
#      EXECUTE sel_oea INTO l_oea.*
#      
#      IF g_flag = 'N' THEN       
#         LET g_exrate=s_exrate_m(l_oea.oea23,l_occ631_o,g_oaz.oaz212,'')
#      ELSE                        
#         LET g_exrate=s_exrate_m(l_oea.oea23,l_occ631_o,g_oaz.oaz212,t_plant_new)  
#      END IF       
#      
#      IF g_flag = 'N' THEN 
#         LET l_sql = "SELECT * FROM oeb_file ",
#                     " WHERE oeb01 = '",p_slip,"'"
#      ELSE
#         LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oeb_file'),
#                     " WHERE oeb01 = '",p_slip,"'"               
#      END IF
#      PREPARE oeb_pre FROM l_sql
#      DECLARE oeb_cur CURSOR FOR oeb_pre
#      FOREACH oeb_cur INTO l_oeb.* 
#         LET l_oib.oib06 = l_oeb.oeb14t * l_oia.oia08/100 
#         LET l_oib.oib06 = l_oib.oib06 * g_exrate
#         LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)
#         
#         EXECUTE ins_oib USING l_oea.oea03,l_plant,g_prog,l_oea.oea01,
#                               l_oeb.oeb03,l_oia.oia06,l_oib.oib06,l_oia.oia03, 
#                               l_oia.oia07,g_today,g_time,g_user,' ','0',' ',l_oea.oeauser,l_plant,l_oia.oia08
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#            LET g_success = 'N'
#            RETURN       
#         END IF
#         LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06
#      END FOREACH
#   END IF 
#
#   IF p_oia05 MATCHES '[B]' THEN  #訂單變更單
#   #  IF g_flag = 'N' THEN
#         LET l_sql = "SELECT * FROM oea_file ",
#                     " WHERE oea01 = '",p_slip,"'"
#   #  ELSE
#   #     LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oea_file'),
#   #                 " WHERE oea01 = '",p_slip,"'"
#   #  END IF
#      PREPARE sel_oea1 FROM l_sql
#      EXECUTE sel_oea1 INTO l_oea.*
#   #  IF g_flag = 'N' THEN
#         LET l_sql = "SELECT * FROM oep_file ",
#                     " WHERE oep01 = '",p_slip,"'",
#                     "   AND oep02 = '",p_no,"'"
#   #  ELSE
#   #     LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oep_file'),
#   #                 " WHERE oep01 = '",p_slip,"'",
#   #                 "   AND oep02 = '",p_no,"'"
#   #  END IF
#      PREPARE sel_oep FROM l_sql
#      EXECUTE sel_oep INTO l_oep.*
#
#      SELECT oia06 INTO l_oia06 FROM oia_file
#       WHERE oia01 = l_occ61 
#         AND oia05 = 'A'      
#      IF cl_null(l_oep.oep08b) THEN       
#         LET l_exrate= 1
#         LET l_oep08 = l_oep.oep08
#      ELSE                        
#         LET l_exrate=s_exrate_m(l_oep.oep08,l_oep.oep08b,g_oaz.oaz212,t_plant_new)
#         LET l_oep08 = l_oep.oep08b  
#      END IF     
#      
#   #  IF g_flag = 'N' THEN       
#         LET g_exrate=s_exrate_m(l_oep08,l_occ631_o,g_oaz.oaz212,'')
#   #  ELSE                        
#   #     LET g_exrate=s_exrate_m(l_oep08,l_occ631_o,g_oaz.oaz212,t_plant_new)  
#   #  END IF       
#      
#      LET l_sql = "SELECT * FROM oeq_file ",
#                  " WHERE oeq01 = '",p_slip,"'",
#                  "   AND oeq02 = '",p_no,"'"                  
#      PREPARE oeq_pre FROM l_sql
#      DECLARE oeq_cur CURSOR FOR oeq_pre
#      FOREACH oeq_cur INTO l_oeq.* 
#      
#         LET l_oib.oib06 = (l_oeq.oeq14ta - l_oeq.oeq14tb*l_exrate) * l_oia.oia08/100 
#         LET l_oib.oib06 = l_oib.oib06 * g_exrate
#         LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)
#         IF l_oib.oib06 > 0 THEN 
#            LET l_oia.oia06 = 1 * l_oia06
#         ELSE
#            LET l_oia.oia06 = (-1)* l_oia06
#            LET l_oib.oib06 = (-1)* l_oib.oib06
#         END IF
#         ####l_oep.oep02是變更單的變更序號，目前是將此key值存放在oib121中
#         EXECUTE ins_oib USING l_oea.oea03,l_plant,g_prog,l_oep.oep01,
#                               l_oeq.oeq03,l_oia.oia06,l_oib.oib06,l_oia.oia03, 
#                               l_oia.oia07,g_today,g_time,g_user,l_oea.oea01,l_oep.oep02,' ',' ',' ',l_oia.oia08
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#            LET g_success = 'N'
#            RETURN       
#         END IF
#         LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06
#      END FOREACH
#   END IF 
#
#   IF p_oia05 MATCHES '[CDEF]' THEN   #出貨通知單/一般出貨單/無訂單出貨/客戶簽收單
#      LET l_prog = g_prog
#      IF g_prog ='atmp201' THEN 
#         IF p_oia05 = 'C' THEN 
#            LET l_prog ='axmt610'
#         END IF
#         IF p_oia05 = 'D' THEN 
#            LET l_prog ='axmt620'
#         END IF 
#      END IF
#
#      IF g_flag = 'N' THEN
#         LET l_sql = "SELECT * FROM oga_file ",
#                     " WHERE oga01 = '",p_slip,"'"
#      ELSE
#         LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oga_file'),
#                     " WHERE oga01 = '",p_slip,"'"
#      END IF
#      PREPARE sel_oga FROM l_sql
#      EXECUTE sel_oga INTO l_oga.*
#
#      IF g_flag = 'N' THEN       
#         LET g_exrate=s_exrate_m(l_oga.oga23,l_occ631_o,g_oaz.oaz212,'')
#      ELSE                        
#         LET g_exrate=s_exrate_m(l_oga.oga23,l_occ631_o,g_oaz.oaz212,t_plant_new)
#      END IF 
#        
#      IF g_flag = 'N' THEN 
#         LET l_sql = "SELECT * FROM ogb_file ",
#                     " WHERE ogb01 = '",p_slip,"'"
#      ELSE
#         LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'ogb_file'),
#                     " WHERE ogb01 = '",p_slip,"'"
#      END IF
#      PREPARE ogb_pre FROM l_sql
#      DECLARE ogb_cur CURSOR FOR ogb_pre
#      
#      IF p_oia05 MATCHES '[CDF]' THEN
#         CALL s_ccc_cx(l_oga.*,p_slip,p_oia05,l_prog) RETURNING l_amt2
#      END IF
#      IF g_success = 'N'  THEN RETURN END IF
#      FOREACH ogb_cur INTO l_ogb.* 
#         LET l_oib.oib06 = l_ogb.ogb14t * l_oia.oia08/100 
#         LET l_oib.oib06 = l_oib.oib06 * g_exrate
#         LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)         
#         EXECUTE ins_oib USING l_oga.oga03,l_plant,l_prog,l_oga.oga01,
#                               l_ogb.ogb03,l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                               l_oia.oia07,g_today,g_time,g_user,' ','0',' ',l_oga.ogauser,l_plant,l_oia.oia08
#         IF SQLCA.sqlcode THEN 
#            CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#            LET g_success = 'N'
#            RETURN
#         END IF
#         LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06   
#      END FOREACH   
#
#      ###如果在簽收單產生了簽退單，那麼要對簽退單的信用額度進行相當於沖銷的處理
#      SELECT oga01 INTO l_oga01 FROM oga_file WHERE oga56 = l_oga.oga01
#      IF NOT cl_null(l_oga01) THEN 
#         SELECT oia03,oia08 INTO l_oia03,l_oia08
#           FROM oia_file,occ_file
#          WHERE oia01 = occ61
#            AND oia05 = p_oia05
#            AND occ01 = l_oga.oga03
#         IF NOT cl_null(l_oia03) THEN 
#            LET l_oia.oia06 = -1 * l_oia.oia06
#            LET l_sql = "SELECT * FROM ogb_file ",
#                        " WHERE ogb01 = '",l_oga01,"'"
#            PREPARE ogbi_pre FROM l_sql
#            DECLARE ogbi_cur CURSOR FOR ogbi_pre          
#            FOREACH ogbi_cur INTO l_ogbi.*
#               LET l_oib.oib06 = l_ogbi.ogb14t * l_oia08/100
#               LET l_oib.oib06 = l_oib.oib06 * g_exrate
#               LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)
#               EXECUTE ins_oib USING l_oga.oga03,l_plant,g_prog,l_oga.oga01,
#                                     l_ogbi.ogb03,l_oia.oia06,l_oib.oib06,l_oia03,
#                                     l_oia.oia07,g_today,g_time,g_user,l_oga01,l_ogbi.ogb03,' ',l_oga.ogauser,g_plant,l_oia08
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#               LET l_amt11 = l_amt11 + l_oia.oia06 * l_oib.oib06
#            END FOREACH        
#         END IF
#      END IF
#   END IF 
#
#   IF p_oia05 MATCHES '[G]' THEN   #一般銷退單
#      IF g_flag = 'N' THEN
#         LET l_sql = "SELECT * FROM oha_file ",
#                     " WHERE oha01 = '",p_slip,"'"
#      ELSE
#         LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'oha_file'),
#                     " WHERE oha01 = '",p_slip,"'"
#      END IF
#      PREPARE sel_oha FROM l_sql
#      EXECUTE sel_oha INTO l_oha.*
#
#      IF g_flag = 'N' THEN       
#         LET g_exrate=s_exrate_m(l_oha.oha23,l_occ631_o,g_oaz.oaz212,'')
#      ELSE                        
#         LET g_exrate=s_exrate_m(l_oha.oha23,l_occ631_o,g_oaz.oaz212,t_plant_new)
#      END IF 
#      
#      IF g_flag = 'N' THEN 
#         LET l_sql = "SELECT * FROM ohb_file ",
#                     " WHERE ohb01 = '",p_slip,"'"
#      ELSE
#         LET l_sql = "SELECT * FROM ",cl_get_target_table(t_plant_new,'ohb_file'),
#                     " WHERE ohb01 = '",p_slip,"'"
#      END IF
#      PREPARE ohb_pre FROM l_sql
#      DECLARE ohb_cur CURSOR FOR ohb_pre
#      FOREACH ohb_cur INTO l_ohb.* 
#         LET l_oib.oib06 = l_ohb.ohb14t * l_oia.oia08/100 
#         LET l_oib.oib06 = l_oib.oib06 * g_exrate
#         LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)         
#         EXECUTE ins_oib USING l_oha.oha03,l_plant,g_prog,l_oha.oha01,
#                               l_ohb.ohb03,l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                               l_oia.oia07,g_today,g_time,g_user,' ','0',' ',l_oha.ohauser,l_plant,l_oia.oia08
#         IF SQLCA.sqlcode THEN 
#            CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#            LET g_success = 'N'
#            RETURN
#         END IF
#         LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06  
#      END FOREACH   
#   END IF    
#   
##xujing---add---str
#   IF p_oia05 MATCHES '[H]' THEN  #訂單結案
#      LET l_sql = "SELECT * FROM oea_file ",
#                  " WHERE oea01 = '",p_slip,"'"
#      PREPARE sel_oea2 FROM l_sql
#      EXECUTE sel_oea2 INTO l_oea.*
#
#      LET g_exrate=s_exrate_m(l_oea.oea23,l_occ631_o,g_oaz.oaz212,'')
#
#      SELECT oia06 INTO l_oia06 FROM oia_file
#       WHERE oia01 = l_occ61
#         AND oia05 = 'A' 
#   
#      SELECT * INTO l_oeb.*
#        FROM oeb_file 
#       WHERE oeb01 = p_slip
#         AND oeb03 = p_no
#      LET l_oib.oib06 = l_oeb.oeb26 * l_oeb.oeb13
#      LET l_oib.oib06 = l_oib.oib06 * l_oia.oia08/100
#      LET l_oib.oib06 = l_oib.oib06 * g_exrate
#      LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)
#      LET l_oia.oia06 = -1 * l_oia06    
#      EXECUTE ins_oib USING l_oea.oea03,l_plant,g_prog,l_oea.oea01,
#                            l_oeb.oeb03,l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                            l_oia.oia07,g_today,g_time,g_user,' ','0',' ',' ',' ',l_oia.oia08
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      LET l_amt1 =  l_oia.oia06 * l_oib.oib06
#   END IF
#
#   IF p_oia05 MATCHES '[IJ]' THEN
#      IF p_oia05 = 'I' THEN 
#         LET l_sql = "SELECT * FROM oma_file ",
#                     " WHERE oma01 = '",p_slip,"'",
#                     "   AND oma00 = '14'"
#      ELSE
#         LET l_sql = "SELECT * FROM oma_file ",
#                     " WHERE oma01 = '",p_slip,"'",
#                     "   AND oma00 = '22'"
#      END IF 
#      PREPARE sel_oma FROM l_sql
#      EXECUTE sel_oma INTO l_oma.*
#
#
#      LET g_exrate=s_exrate_m(l_oma.oma23,l_occ631_o,g_oaz.oaz212,'')
#      LET l_oib.oib06 = l_oma.oma54t * l_oia.oia08 / 100
#      LET l_oib.oib06 = l_oib.oib06 * g_exrate
#      LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)
#      EXECUTE ins_oib USING l_oma.oma03,l_plant,g_prog,l_oma.oma01,'0',
#                            l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                            l_oia.oia07,g_today,g_time,g_user,' ','0',' ',' ',' ',l_oia.oia08
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06
#   END IF 
##xujing---add---end 
####----CJ----add--
#   IF p_oia05 MATCHES '[L]' THEN
#      LET l_prog = g_prog
#      IF g_prog ='anmt3023' THEN
#         LET l_prog ='anmt302'
#      END IF
#
#      LET l_sql = "SELECT * FROM nmg_file ",
#                  " WHERE nmg00 = '",p_slip,"'",
#                  "   AND nmg20 IN ('21','22')"
#      PREPARE sel_nmg FROM l_sql
#      EXECUTE sel_nmg INTO l_nmg.*
#
#      LET g_exrate=s_exrate_m(l_nmg.nmg22,l_occ631_o,g_oaz.oaz212,'')
#      LET l_oib.oib06 = l_nmg.nmg23*l_oia.oia08/100
#      LET l_oib.oib06 = l_oib.oib06 * g_exrate
#      LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)         
#      EXECUTE ins_oib USING l_nmg.nmg18,l_plant,l_prog,l_nmg.nmg00,
#                            '0',l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                            l_oia.oia07,g_today,g_time,g_user,' ','0',' ',g_legal,g_plant,l_oia.oia08
#      IF SQLCA.sqlcode THEN 
#         CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06  
#   END IF   
#
#   IF p_oia05 MATCHES '[M]' THEN
#      LET l_sql = "SELECT * FROM nmh_file ",
#                  " WHERE nmh01 = '",p_slip,"'"
#      PREPARE sel_nmh FROM l_sql
#      EXECUTE sel_nmh INTO l_nmh.*
#
#      LET g_exrate=s_exrate_m(l_nmh.nmh03,l_occ631_o,g_oaz.oaz212,'')
#      LET l_oib.oib06 = l_nmh.nmh02*l_oia.oia08/100	
#      LET l_oib.oib06 = l_oib.oib06 * g_exrate
#      LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)         
#      EXECUTE ins_oib USING l_nmh.nmh11,l_plant,g_prog,l_nmh.nmh01,
#                            '0',l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                            l_oia.oia07,g_today,g_time,g_user,' ','0',' ',g_legal,g_plant,l_oia.oia08
#      IF SQLCA.sqlcode THEN 
#         CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06  
#   END IF   
####----CJ----add--
####----xj----add----str
#   IF p_oia05 MATCHES '[N]' THEN  #銷售信用狀維護
#      LET l_sql = "SELECT * FROM ola_file ",
#                  " WHERE ola01 = '",p_slip,"'"
#      PREPARE sel_ola FROM l_sql
#      EXECUTE sel_ola INTO l_ola.*
#      
#      LET g_exrate=s_exrate_m(l_ola.ola06,l_occ631_o,g_oaz.oaz212,'')
#      
#      LET l_oib.oib06 = (l_ola.ola09-l_ola.ola10)*l_oia.oia08 / 100
#      LET l_oib.oib06 = l_oib.oib06 * g_exrate
#      LET l_oib.oib06 = cl_digcut(l_oib.oib06,t_azi04)
#         
#      EXECUTE ins_oib USING l_ola.ola05,l_plant,g_prog,l_ola.ola01,
#                            '0',l_oia.oia06,l_oib.oib06,l_oia.oia03,
#                            l_oia.oia07,g_today,g_time,g_user,' ','0',' ',l_ola.olauser,g_plant,l_oia.oia08
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#         LET g_success = 'N' 
#         RETURN        
#      END IF
#      LET l_amt1 = l_amt1 + l_oia.oia06 * l_oib.oib06
#   END IF
####xj----add---end-----
#
#   LET l_amt = l_amt1 + l_amt2 + l_amt11
#
#   IF g_flag ='N' THEN
#      LET l_sql = "UPDATE oic_file",
#                  "   SET oic02 = oic02 + ",l_amt,
#                  " WHERE oic01 = '",g_occ33 CLIPPED,"'"
#   ELSE
#      LET l_sql = "UPDATE ",cl_get_target_table(t_plant_new,'oic_file'),
#                  "   SET oic02 = oic02 + ",l_amt,
#                  " WHERE oic01 = '",g_occ33 CLIPPED,"'"
#   END IF
#   PREPARE upd_oic01 FROM l_sql
#   EXECUTE upd_oic01   
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('upd oic_file',SQLCA.sqlcode,0)
#      LET g_success = 'N'
#      RETURN
#   END IF
#   
#   IF g_flag ='N' THEN 
#      LET l_sql = "SELECT oic02 FROM oic_file",
#                  " WHERE oic01 = '",g_occ33 CLIPPED,"'"
#   ELSE
#      LET l_sql = "SELECT oic02 FROM ",cl_get_target_table(t_plant_new,'oic_file'),
#                  " WHERE oic01 = '",g_occ33 CLIPPED,"'"
#   END IF
#   PREPARE sel_oic02 FROM l_sql
#   EXECUTE sel_oic02 INTO l_oic02
#   IF l_oic02 < 0 THEN 
#     LET g_errno = 'N'
#   END IF
#END FUNCTION
#
##出貨通知單中訂單是否做信用管控的檢查，如果做管控則進行對訂單做沖銷
#FUNCTION s_ccc_cx(l_oga,p_slip,p_oia05,l_prog)
#DEFINE l_oga    RECORD LIKE oga_file.*
#DEFINE l_ogb    RECORD LIKE ogb_file.*
#DEFINE p_slip   LIKE oea_file.oea01
#DEFINE l_oea    RECORD LIKE oea_file.*
#DEFINE l_amt2   LIKE oib_file.oib06
#DEFINE l_oia03  LIKE oia_file.oia03
#DEFINE l_oia08  LIKE oia_file.oia08
#DEFINE l_oib03  LIKE oib_file.oib03
#DEFINE l_oib05  LIKE oib_file.oib05
#DEFINE p_oia05  LIKE oia_file.oia05
#DEFINE l_oib06  LIKE oib_file.oib06
#DEFINE l_plant  LIKE oib_file.oibplant
#DEFINE l_oib12  LIKE oib_file.oib12
#DEFINE l_prog   LIKE type_file.chr20
#DEFINE l_oia05  LIKE oia_file.oia05
#DEFINE l_n      LIKE type_file.num5
#DEFINE l_n_a    LIKE type_file.num5
#DEFINE l_n_c    LIKE type_file.num5
#DEFINE l_n_d    LIKE type_file.num5
#DEFINE l_n_e    LIKE type_file.num5
#DEFINE l_amt_a  LIKE oib_file.oib06
#DEFINE l_amt_b  LIKE oib_file.oib06
#DEFINE l_amt    LIKE oib_file.oib06
#DEFINE l_sql    STRING
#     
#   LET l_amt2 = 0
#   IF g_flag ='N' THEN
#      LET l_plant = g_plant
#   ELSE
#      LET l_plant = t_plant_new
#   END IF
#   LET l_n_a = 0
#   LET l_n_c = 0
#   LET l_n_d = 0
#   LET l_n_e = 0
#   IF g_flag ='N' THEN
#      LET l_sql = "SELECT COUNT(*) FROM oia_file,occ_file ",
#                  " WHERE occ61 =oia01 ",
#                  "   AND oia05 = ? ",
#                  "   AND occ01 = ? "
#   ELSE
#      LET l_sql = "SELECT COUNT(*) FROM oia_file,",cl_get_target_table(t_plant_new,'occ_file'),
#                  " WHERE occ61 =oia01 ",
#                  "   AND oia05 = ? ",
#                  "   AND occ01 = ? "
#   END IF
#   PREPARE sel_count FROM l_sql
#   EXECUTE sel_count USING 'A',l_oga.oga03 INTO l_n_a
#   EXECUTE sel_count USING 'C',l_oga.oga03 INTO l_n_c
#   EXECUTE sel_count USING 'D',l_oga.oga03 INTO l_n_d
#   EXECUTE sel_count USING 'E',l_oga.oga03 INTO l_n_e
#   FOREACH ogb_cur INTO l_ogb.* 
#      LET l_n = 0
#      CASE p_oia05
#         WHEN 'C'
#            IF l_n_a > 0 THEN 
#               LET l_oia05 ='A'
#               LET l_oib12 = l_ogb.ogb31
#               LET l_n = 1
#            END IF
#         WHEN 'D'
#            IF NOT cl_null(l_oga.oga011) AND l_n_c >0 THEN 
#               LET l_oia05 ='C'
#               LET l_oib12 = l_oga.oga011
#               LET l_n = 1
#               EXIT CASE
#            END IF
#            IF l_n_a> 0 THEN 
#               LET l_oia05 ='A'
#               LET l_oib12 = l_ogb.ogb31
#               LET l_n = 1 
#            END IF 
#         WHEN 'F' 
#            IF NOT cl_null(l_oga.oga011) AND l_ogb.ogb31 IS NULL AND l_n_e > 0 THEN 
#               LET l_oia05 = 'E'
#               LET l_oib12 = l_oga.oga011
#               LET l_n= 1
#               EXIT CASE
#            END IF
#            IF NOT cl_null(l_oga.oga011) AND l_n_d >0 THEN
#               LET l_oia05 = 'D'
#               LET l_oib12 = l_oga.oga011
#               LET l_n = 1
#               EXIT CASE
#            END IF
#            IF l_n_a> 0 THEN
#               LET l_oia05 ='A'
#               LET l_oib12 = l_ogb.ogb31
#               LET l_n = 1
#            END IF
#      END CASE 
#
#      IF l_n >0 THEN 
#         SELECT oia03,oia08 INTO l_oia03,l_oia08 
#           FROM oia_file,occ_file
#          WHERE oia01 = occ61          
#            AND oia05 = l_oia05
#            AND occ01 = l_oga.oga03
#         LET l_oib06 = l_ogb.ogb14t * l_oia08/100 
#         LET l_oib06 = l_oib06 * g_exrate
#         LET l_oib06 = cl_digcut(l_oib06,t_azi04)            
#         ###控管l_ogb14t不可大於訂單金額,因為會有超交的情況,
#         ###比如訂單金額-100,出通單出了110,產生一筆-110,另一筆沖銷應為100,
#         ###即如果大於原單據金額,則沖銷的金額=原單據金額
#         ###需考慮分批出貨的情況,需SUM數量進行判斷
#         IF l_oia05 ='A' THEN 
#            #訂單中異動的信用額度
#            IF g_flag = 'N' THEN
#               LET l_sql = "SELECT SUM(oib05*oib06) FROM oib_file ", 
#                           " WHERE oib01 = '",l_oga.oga03,"'",
#                           "   AND oib04 = '",l_oib12,"'",
#                           "   AND oib041= '",l_ogb.ogb32,"'"
#            ELSE
#               LET l_sql = "SELECT SUM(oib05*oib06) FROM ",cl_get_target_table(t_plant_new,'oib_file'), 
#                           " WHERE oib01 = '",l_oga.oga03,"'",
#                           "   AND oib04 = '",l_oib12,"'",
#                           "   AND oib041= '",l_ogb.ogb32,"'"
#            END IF
#            PREPARE sel_oib06_b FROM l_sql
#            EXECUTE sel_oib06_b INTO l_amt_b 
#            IF l_amt_b < 0 THEN LET l_amt_b = -1 * l_amt_b END IF
#            IF NOT cl_null(l_amt_b) THEN 
#               IF l_amt_b < l_oib06 THEN 
#                  LET l_oib06 = l_amt_b
#               ELSE
#                  #訂單中已沖銷的信用額度
#                  IF g_flag = 'N' THEN 
#                     LET l_sql = "SELECT SUM(oib05*oib06) FROM oib_file",    
#                                 " WHERE oib01 = '",l_oga.oga03,"'",
#                                 "   AND oib03 = '",l_prog,"'",
#                                 "   AND oib08 = '8' ",
#                                 "   AND oib12 = '",l_oib12,"'",
#                                 "   AND oib121= '",l_ogb.ogb32,"'"
#                  ELSE
#                     LET l_sql = "SELECT SUM(oib05*oib06) FROM ",cl_get_target_table(t_plant_new,'oib_file'),
#                                 " WHERE oib01 = '",l_oga.oga03,"'",
#                                 "   AND oib03 = '",l_prog,"'",
#                                 "   AND oib08 = '8' ",
#                                 "   AND oib12 = '",l_oib12,"'",
#                                 "   AND oib121= '",l_ogb.ogb32,"'"
#                  END IF
#                  PREPARE sel_oib06_a FROM l_sql
#                  EXECUTE sel_oib06_a INTO l_amt_a
#                  IF l_amt_a < 0 THEN LET l_amt_a = -1 * l_amt_a END IF
#                  IF NOT cl_null(l_amt_a) THEN
#                     LET l_amt = l_amt_b - l_amt_a
#                     IF l_oib06 > l_amt THEN 
#                        LET l_oib06 = l_amt
#                     END IF
#                  END IF
#               END IF
#            END IF
#         END IF 
#         
#         IF g_flag = 'N' THEN 
#            LET l_sql = "SELECT oib03,oib05 FROM oib_file",
#                        " WHERE oib04 = '",l_oib12,"'", 
#                        "   AND oib041= '",l_ogb.ogb32,"'",
#                        "   AND oib12 = ' ' "
#         ELSE
#            LET l_sql = "SELECT oib03,oib05 FROM ",cl_get_target_table(t_plant_new,'oib_file'),
#                        " WHERE oib04 = '",l_oib12,"'", 
#                        "   AND oib041= '",l_ogb.ogb32,"'",
#                        "   AND oib12 = ' ' "
#         END IF
#         PREPARE sel_oib FROM l_sql
#         EXECUTE sel_oib INTO l_oib03,l_oib05       
#
#         LET l_oib05 = -1 * l_oib05
#         EXECUTE ins_oib USING l_oga.oga03,l_plant,l_prog,l_oga.oga01,
#                               l_ogb.ogb03,l_oib05,l_oib06,l_oia03,
#                               '8',g_today,g_time,g_user,l_oib12,l_ogb.ogb32,l_oib03,l_oga.ogauser,l_plant,l_oia08
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('ins oib_file',SQLCA.sqlcode,0)
#            LET g_success = 'N' 
#            RETURN
#         END IF
#         LET l_amt2 = l_amt2 + l_oib05 * l_oib06
#      END IF
#   END FOREACH
#   IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#   RETURN l_amt2 
#END FUNCTION
#
##取消審核或過帳還原時候刪除oib_file的異動記錄，并還原oic_file的信用餘額，如有沖銷也一併刪除
#FUNCTION s_ccc_rback(p_cus_no,p_oia05,p_slip,p_no,p_plant)
#DEFINE l_n      LIKE type_file.num5
#DEFINE p_no     LIKE type_file.num5
#DEFINE p_oia05  LIKE oia_file.oia05
#DEFINE p_cus_no LIKE occ_file.occ01 
#DEFINE p_slip   LIKE oea_file.oea01
#DEFINE p_plant  LIKE azp_file.azp01
#DEFINE l_amt    LIKE oib_file.oib06
#DEFINE l_amt1   LIKE oib_file.oib06
#DEFINE l_amt2   LIKE oib_file.oib06
#DEFINE l_amt3   LIKE oib_file.oib06
#DEFINE l_occ61  LIKE occ_file.occ61
#DEFINE l_occ62  LIKE occ_file.occ62
#DEFINE l_oga01  LIKE oga_file.oga01
#DEFINE l_sql    STRING
#DEFINE l_prog   LIKE type_file.chr20
#
#
#   LET l_prog = g_prog
#   IF p_oia05 = 'L' THEN 
#      LET l_prog ='anmt302'
#   END IF
#   CASE g_prog
#      WHEN 'axmp810'  LET l_prog = 'axmp800'
#      WHEN 'axmp831'  LET l_prog = 'axmp821'
#      WHEN 'axmp830'  LET l_prog = 'axmp820'
#      WHEN 'axmp901'  LET l_prog = 'axmp900'
#      WHEN 'axmp870'  LET l_prog = 'axmp860'
#      WHEN 'axmp866'  LET l_prog = 'axmp865'
#      WHEN 'axmp911'  LET l_prog = 'axmp910'
#      WHEN 'apmp811'  LET l_prog = 'apmp801'
#      WHEN 'apmp832'  LET l_prog = 'apmp822'
#      WHEN 'apmp841'  LET l_prog = 'apmp840'
#   END CASE
#   CALL s_ccc_cy(p_cus_no,p_slip,p_plant)
#   IF g_flag = 'N' THEN
#      LET l_sql = "SELECT occ61,occ62 FROM occ_file ",
#                  " WHERE occ01 = '",p_cus_no,"'"
#   ELSE
#      LET l_sql = "SELECT occ61,occ62 FROM ",cl_get_target_table(t_plant_new,'occ_file'),
#                  " WHERE occ01 = '",p_cus_no,"'"
#   END IF
#   PREPARE sel_occ2 FROM l_sql
#   EXECUTE sel_occ2 INTO l_occ61,l_occ62
#   IF l_occ62 = 'N' THEN
#      IF (g_prog[1,7]<>'axmt410' AND g_prog[1,7]<>'axmt420' AND g_prog[1,7]<>'axmt810'
#          AND g_prog[1,7]<>'axmp200' AND g_prog[1,7]<>'axmp210' AND g_prog[1,7]<>'axmp220'
#          AND g_prog[1,7]<>'axmp230' AND g_prog[1,7]<>'axmr600' AND g_prog[1,7]<>'axmt700'
#          AND g_prog[1,7]<>'axmt620') THEN 
#          CALL cl_err('','axm-841',0)
#      END IF
#      RETURN
#   END IF
#   IF cl_null(l_occ61) AND l_occ62='Y' THEN  # 信用評等    
#      CALL cl_err('','axm-270',1)
#      RETURN              
#   END IF
#    
#   LET l_n = 0
#   SELECT COUNT(*) INTO l_n FROM oia_file,oie_file
#    WHERE oia01 =l_occ61
#      AND oia05 =p_oia05 
#      AND oiaacti = 'Y'  
#      AND oie02 =g_plant 
#      AND oie01 = oia01     
#   IF l_n = 0 THEN
#      CALL cl_err('','axm-842',0)
#      RETURN 
#   END IF
#  
#   ##撈取異動記錄檔oib_file中非沖銷的信用額度
#   IF g_flag ='N' THEN 
#      LET l_sql = "SELECT SUM(oib05*oib06) FROM oib_file",
#                  " WHERE oib01 = '",p_cus_no,"'", 
#                  "   AND oib02 = '",g_plant,"'",
#                  "   AND oib03 = '",l_prog,"'",
#                  "   AND oib04 = '",p_slip,"'",
#                  "   AND oib08 <> '8'"
#   ELSE
#      LET l_sql = "SELECT SUM(oib05*oib06) FROM ",cl_get_target_table(t_plant_new,'oib_file'),
#                  " WHERE oib01 = '",p_cus_no,"'",
#                  "   AND oib02 = '",t_plant_new,"'",
#                  "   AND oib03 = '",l_prog,"'",
#                  "   AND oib04 = '",p_slip,"'",
#                  "   AND oib08 <> '8'"        
#   END IF
#   CASE p_oia05
#      WHEN 'H'  LET l_sql = l_sql CLIPPED," AND oib041 = '",p_no CLIPPED,"'"
#      WHEN 'B'  LET l_sql = l_sql CLIPPED," AND oib121 = '",p_no CLIPPED,"'"
#   END CASE
#   PREPARE amt1_pre FROM l_sql
#   EXECUTE amt1_pre INTO l_amt1
#   IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#   
#   ##撈取異動記錄檔oib_file中沖銷的信用額度
#   IF g_flag ='N' THEN  
#      LET l_sql = "SELECT SUM(oib05*oib06) FROM oib_file",
#                  " WHERE oib01 ='",p_cus_no,"'", 
#                  "   AND oib02 ='",g_plant,"'",
#                  "   AND oib03 ='",l_prog,"'",
#                  "   AND oib04 ='",p_slip,"'",
#                  "   AND oib08 = '8'" 
#   ELSE
#      LET l_sql = "SELECT SUM(oib05*oib06) FROM ",cl_get_target_table(t_plant_new,'oib_file'),
#                  " WHERE oib01 ='",p_cus_no,"'",
#                  "   AND oib02 ='",t_plant_new,"'",
#                  "   AND oib03 ='",l_prog,"'",
#                  "   AND oib04 ='",p_slip,"'",
#                  "   AND oib08 = '8'"
#   END IF
#   PREPARE amt2_pre FROM l_sql
#   EXECUTE amt2_pre INTO l_amt2
#   IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#
#   LET l_amt = l_amt1 + l_amt2
#
#   #刪除異動記錄
#   IF g_flag ='N' THEN 
#      LET l_sql = "DELETE FROM oib_file", 
#                  " WHERE oib01 ='",p_cus_no,"'", 
#                  "   AND oib02 ='",g_plant,"'",
#                  "   AND oib03 ='",l_prog,"'",
#                  "   AND oib04 ='",p_slip ,"'"
#   ELSE
#      LET l_sql = "DELETE FROM ",cl_get_target_table(t_plant_new,'oib_file'),
#                  " WHERE oib01 ='",p_cus_no,"'",
#                  "   AND oib02 ='",t_plant_new,"'",
#                  "   AND oib03 ='",l_prog,"'",
#                  "   AND oib04 ='",p_slip ,"'"     
#   END IF
#   CASE p_oia05 
#      WHEN 'H'  LET l_sql = l_sql CLIPPED," AND oib041 = '",p_no CLIPPED,"'"
#      WHEN 'B'  LET l_sql = l_sql CLIPPED," AND oib121 = '",p_no CLIPPED,"'"      #oib121存入的是變更單的變更序號
#   END CASE    
#   PREPARE del_oib FROM l_sql
#   EXECUTE del_oib
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('del oib_file',SQLCA.sqlcode,0)
#      LET g_success ='N'
#   END IF
#
#   #回寫oic_file中的信用額度
#   IF g_flag ='N' THEN 
#      LET l_sql = "UPDATE oic_file",
#                  "   SET oic02 = oic02 - ",l_amt,
#                  " WHERE oic01 = '",g_occ33 CLIPPED,"'"
#   ELSE
#      LET l_sql = "UPDATE ",cl_get_target_table(t_plant_new,'oic_file'),
#                  "   SET oic02 = oic02 - ",l_amt,
#                  " WHERE oic01 = '",g_occ33 CLIPPED,"'"
#   END IF      
#   PREPARE upd_oic FROM l_sql
#   EXECUTE upd_oic      
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('upd oic_file',SQLCA.sqlcode,0)
#      LET g_success ='N'
#   END IF
#END FUNCTION
#
##從axmi270中撈出oia07
#FUNCTION s_ccc_oia07(p_oia05,p_cus_no)
#DEFINE p_oia05  LIKE oia_file.oia05
#DEFINE p_cus_no LIKE occ_file.occ01
#DEFINE l_oia07  LIKE oia_file.oia07
#
#   SELECT oia07 INTO l_oia07 FROM oia_file,occ_file
#    WHERE oia01 = occ61
#      AND oia05 = p_oia05 
#      AND occ01 = p_cus_no 
#   IF l_oia07 IS NULL THEN  LET l_oia07 = ' ' END IF
#   RETURN l_oia07
#END FUNCTION 
#---------------------------#其他單要過單，所以C50136部分暫時mark---------------------------------------
#FUN-C50136----add----end----
 
#信用額度計算邏輯說明-------------------------------------------
#讀取每一單據:   IF  信用額度幣別 = 單據幣別 THEN
#                    金額 = 原幣
#                ELSE
#                    IF 參數(oaz121)='1' 立帳匯率 THEN
#                       金額 = 本幣
#                    ELSE
#                       金額 = 原幣 * 當日匯率  (單據幣別->本幣)
#                    END IF
#                    IF 額度幣別  <> 本國幣別 THEN
#                       金額 = 金額 * (本幣對額度幣別匯率)
#                    END IF
#                END IF
#------------------------------------------------------------------
                        
#註:以下SQL會多select日期及單號, 是為了給axmq210用的
#-(1)---------------------------------#
# 多工廠待抵帳款計算 by WUPN 96-05-23 #
#-------------------------------------#
FUNCTION s_ccc_cal_t51(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t51,l_tmp LIKE oma_file.oma57, 
          ntd_amt     LIKE oma_file.oma57, 
          l_amt       LIKE oma_file.oma57, 
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE  #日期
          l_no        LIKE oma_file.oma01, 
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING 
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10) #No.FUN-630086
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
      SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
   ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t51_aza17 FROM l_sql
    DECLARE t51_aza17_cs CURSOR FOR t51_aza17
    FOREACH t51_aza17_cs INTO g_aza17 END FOREACH
   END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
     SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
   ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t51_occ631 FROM l_sql
    DECLARE t51_occ631_cs CURSOR FOR t51_occ631
    FOREACH t51_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----

#TQC-AC0345 --begin--   
  IF g_flag = 'N' THEN
     SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
               " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t51_ocg FROM l_sql
    DECLARE t51_ocg_cs CURSOR FOR t51_ocg
    FOREACH t51_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--

   #LET l_plant[1]=g_ocg.ocg03    LET l_plant[2]=g_ocg.ocg04
   #LET l_plant[3]=g_ocg.ocg05    LET l_plant[4]=g_ocg.ocg06
 
  IF g_flag = 'N' THEN       #TQC-AC0345 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 1"
#TQC-AC0345 --begin--  
  ELSE            
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",     
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 1"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF                 
#TQC-AC0345 --end--  

    PREPARE t51_poch FROM l_sql
    DECLARE t51_och CURSOR FOR t51_poch
 
    LET l_j = 1
 
    FOREACH t51_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t51_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?",
                "   AND azp053 != 'N'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t51_azp FROM l_sql
    DECLARE t51_azp_cs CURSOR FOR t51_azp
  END IF
#TQC-AC0345 --end--  
    
    LET l_t51=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
       IF g_flag= 'N' THEN    #TQC-AC0345 
          SELECT azp03 INTO l_azp03           # DATABASE ID
            FROM azp_file WHERE azp01=l_plant[l_i]
                            AND azp053 !='N' #no.7431
#TQC-AC0345 --begin--
       ELSE
          FOREACH t51_azp_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
       END IF
#TQC-AC0345 --end--
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t51_pre FROM l_sql
        DECLARE aza_t51_cur CURSOR FOR aza_t51_pre
        OPEN aza_t51_cur 
        FETCH aza_t51_cur INTO l_aza17
        CLOSE aza_t51_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028   
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                  "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t51_pre FROM l_sql
        DECLARE oaz_t51_cur CURSOR FOR oaz_t51_pre
        OPEN oaz_t51_cur
        FETCH oaz_t51_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
 
        #No.TQC-5C0086  --Begin                                                                                                     
        IF g_ooz.ooz07 = 'N' THEN
           LET l_sql="SELECT oma54t-oma55,oma56t-oma57,oma23,oma01,oma11 ",
          #LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",   #A060
                    #"  FROM ", l_azp03 CLIPPED,".dbo.oma_file ", #TQC-950028 
                     #"  FROM ", s_dbstring(l_azp03 CLIPPED),"oma_file ",#TQC-950028
                     "  FROM ", cl_get_target_table(l_plant[l_i],'oma_file'), #FUN-A50102  
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 LIKE '2%'", #CHI-C80033 add ,  
           #CHI-C80033 add --start--
                     " AND oma00 <> '23' ", 
                     " UNION ALL ",
                     "SELECT (oma54t-oma55)*(1+oma211/100),(oma56t-oma57)*(1+oma211/100),oma23,oma01,oma11 ",
                     "  FROM ", cl_get_target_table(l_plant[l_i],'oma_file'), 
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 = '23'"    
           #CHI-C80033 add --end--
        ELSE                                                                                                                        
           LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",                                                                
                    #"  FROM ", l_azp03 CLIPPED,".dbo.oma_file ",     #TQC-950028                                                                  
                     #"  FROM ", s_dbstring(l_azp03 CLIPPED),"oma_file ",  #TQC-950028
                     "  FROM ", cl_get_target_table(l_plant[l_i],'oma_file'), #FUN-A50102   
                     " WHERE oma03 ='",p_occ01,"'",                                                                                 
                     " AND oma54t > oma55",                                                                                         
                     " AND omaconf='Y' AND oma00 LIKE '2%'", #CHI-C80033 add ,  
           #CHI-C80033 add --start--
                     " AND oma00 <> '23' ", 
                     " UNION ALL ",
                     "SELECT (oma54t-oma55)*(1+oma211/100),oma61,oma23,oma01,oma11 ",                                                                
                     "  FROM ", cl_get_target_table(l_plant[l_i],'oma_file'),   
                     " WHERE oma03 ='",p_occ01,"'",                                                                                 
                     " AND oma54t > oma55",                                                                                         
                     " AND omaconf='Y' AND oma00 = '23'"                                                                         
           #CHI-C80033 add --end--
        END IF                                                                                                                      
        #No.TQC-5C0086  --End 
 
       #FUN-630043
        IF g_aza.aza52='Y' THEN
           LET l_sql=l_sql CLIPPED," AND oma66='",l_plant[l_i],"' "
        END IF
       #END FUN-630043
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE t51_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t51',SQLCA.SQLCODE,1)
       END IF   
 
       DECLARE t51_curs CURSOR FOR t51_pre
 
       FOREACH t51_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
       #FUN-640215 --add--
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215    #FUN-980020 mark
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215  #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
       #FUN-640215 --add--
        LET l_tmp= l_tmp * g_ocg.ocg02/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t51=l_t51+l_tmp
       END FOREACH
    END FOR
 
    RETURN l_t51
 
END FUNCTION
 
#-(2)-------------------------------#
# ＬＣ收狀金額計算 by WUPN 96-05-23 #
#-----------------------------------#
FUNCTION s_ccc_cal_t52(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t52,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_ola07     LIKE ola_file.ola07,
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE   #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01     #No.FUN-680147 VARCHAR(10)   #No.FUN-630086

#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--
 
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
     SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
 ELSE
     LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                 " WHERE aza01 = '0'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
     PREPARE t52_aza17 FROM l_sql
     DECLARE t52_aza17_cs CURSOR FOR t52_aza17
     FOREACH t52_aza17_cs INTO g_aza17 END FOREACH
 END IF
#TQC-AC0345 --end--
    IF STATUS <> 1 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
     SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t52_occ631 FROM l_sql
    DECLARE t52_occ631_cs CURSOR FOR t52_occ631
    FOREACH t52_occ631_cs INTO l_occ631 END FOREACH
END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
   
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
 ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t52_ocg FROM l_sql
    DECLARE t52_ocg_cs CURSOR FOR t52_ocg
    FOREACH t52_ocg_cs INTO g_ocg.* END FOREACH
 END IF
#TQC-AC0345  --end--

   #LET l_plant[1]=g_ocg.ocg12    LET l_plant[2]=g_ocg.ocg13
   #LET l_plant[3]=g_ocg.ocg14    LET l_plant[4]=g_ocg.ocg15
 
 IF g_flag = 'N' THEN         #TQC-AC0345 
     LET l_sql = "SELECT och03 FROM och_file",   
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 2"
#TQC-AC0345 --begin--                
 ELSE
     LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",   
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 2"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
 END IF              
#TQC-AC0345 --END--
    PREPARE t52_poch FROM l_sql
    DECLARE t52_och CURSOR FOR t52_poch
 
    LET l_j = 1
 
    FOREACH t52_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t52_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t52_azp03 FROM l_sql
    DECLARE t52_azp03_cs CURSOR FOR t52_azp03
END IF
#TQC-AC0345 --end--
    
    LET l_t52=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020

      IF g_flag = 'N' THEN          #TQC-AC0345 
          SELECT azp03 INTO l_azp03           # DATABASE ID
            FROM azp_file WHERE azp01=l_plant[l_i]
#TQC-AC0345 --begin--
      ELSE
        FOREACH t52_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--

        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028  
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t52_pre FROM l_sql
        DECLARE aza_t52_cur CURSOR FOR aza_t52_pre
        OPEN aza_t52_cur 
        FETCH aza_t52_cur INTO l_aza17
        CLOSE aza_t52_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028  
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102  
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t52_pre FROM l_sql
        DECLARE oaz_t52_cur CURSOR FOR oaz_t52_pre
        OPEN oaz_t52_cur
        FETCH oaz_t52_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
        LET l_sql=" SELECT ola09-ola10,ola06,ola07,ola01,ola02 ",
                 #" FROM ", l_azp03 CLIPPED,".dbo.ola_file ",   #TQC-950028  
                  #" FROM ", s_dbstring(l_azp03 CLIPPED),"ola_file ", #TQC-950028 
                  " FROM ", cl_get_target_table(l_plant[l_i],'ola_file'), #FUN-A50102  
                  " WHERE ola05='",p_occ01,"' AND ola40 = 'N'",
                  "   AND ola09>ola10",
                 #"   AND olaconf !='X' "    #010809增   #MOD-BC0077 mark
                  "   AND olaconf = 'Y' "    #MOD-BC0077 add
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE t52_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t52',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t52_curs CURSOR FOR t52_pre
       FOREACH t52_curs INTO l_amt,g_curr,l_ola07,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF l_ola07 IS NULL THEN LET l_ola07 = 1 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = l_amt * l_ola07
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
       #FUN-640215 ----add----
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = l_amt * l_ola07
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-650215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020 
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
       #FUN-640215 ----add----
        LET l_tmp= l_tmp * g_ocg.ocg03/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t52=l_t52+l_tmp
       END FOREACH
    END FOR
    RETURN l_t52
END FUNCTION
 
#-(3)-----------------------------------------#
# 多工廠財務暫收支票金額計算 by WUPN 96-05-23 #
#---------------------------------------------#
FUNCTION s_ccc_cal_t53(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t53,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE    #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01     #No.FUN-680147 VARCHAR(10)  #No.FUN-630086
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
 IF g_flag ='N' THEN
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
 ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t53_aza17 FROM l_sql
    DECLARE t53_aza17_cs CURSOR FOR t53_aza17
    FOREACH t53_aza17_cs INTO g_aza17 END FOREACH
 END IF
#TQC-AC0345 --end--

    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
 IF g_flag ='N' THEN
      SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 ELSE
     LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                 " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t53_occ631 FROM l_sql
    DECLARE t53_occ631_cs CURSOR FOR t53_occ631
    FOREACH t53_occ631_cs INTO l_occ631 END FOREACH
 END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
 IF g_flag ='N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
 ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t53_ocg FROM l_sql
    DECLARE t53_ocg_cs CURSOR FOR t53_ocg
    FOREACH t53_ocg_cs INTO g_ocg.* END FOREACH
 END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg21    LET l_plant[2]=g_ocg.ocg22
   #LET l_plant[3]=g_ocg.ocg23    LET l_plant[4]=g_ocg.ocg24
 
 IF g_flag ='N' THEN  #TQC-AC0345 
     LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 3"
#TQC-AC0345 --begin--
 ELSE
     LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 3"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
 END IF
#TQC-AC0345 --end--
    PREPARE t53_poch FROM l_sql
    DECLARE t53_och CURSOR FOR t53_poch
 
    LET l_j = 1
 
    FOREACH t53_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t53_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
IF g_flag = 'Y' THEN
   LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t53_azp03 FROM l_sql
    DECLARE t53_azp03_cs CURSOR FOR t53_azp03
END IF
#TQC-AC0345 --end--
    
    LET l_t53=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
       
      IF g_flag ='N' THEN                    #TQC-AC0345 
         SELECT azp03 INTO l_azp03           # DATABASE ID
           FROM azp_file WHERE azp01=l_plant[l_i]
#TQC-AC0345 --begin--
      ELSE
        FOREACH t53_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--
       
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028 
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t53_pre FROM l_sql
        DECLARE aza_t53_cur CURSOR FOR aza_t53_pre
        OPEN aza_t53_cur 
        FETCH aza_t53_cur INTO l_aza17
        CLOSE aza_t53_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028  
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t53_pre FROM l_sql
        DECLARE oaz_t53_cur CURSOR FOR oaz_t53_pre
        OPEN oaz_t53_cur
        FETCH oaz_t53_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh09 ",
                #"   FROM ",l_azp03 CLIPPED,".dbo.nmh_file", #TQC-950028  
                 #"   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file",#TQC-950028
                 "   FROM ",cl_get_target_table(l_plant[l_i],'nmh_file'), #FUN-A50102
                 " WHERE nmh11='", p_occ01,"'",
                 "   AND (nmh24 IN ('1','2','3') OR (nmh24 IN ('4') AND nmh05 >= '",g_today,"'))",  #FUN-870084  #MOD-8B0191
                 "   AND (nmh17 IS NULL OR nmh17 =0 )",
                 "   AND nmh38 <> 'X' ",
                 "   AND nmh02 > 0 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE t53_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t53',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t53_curs CURSOR FOR t53_pre
       FOREACH t53_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
       #FUN-640215 --add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
       #FUN-640215 --end---
        LET l_tmp= l_tmp * g_ocg.ocg04/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t53=l_t53+l_tmp
       END FOREACH
    END FOR
    RETURN l_t53
END FUNCTION
 
#-(4)-------------------------------------#
# 多工廠財務暫收ＴＴ計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION s_ccc_cal_t54(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t54,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE   #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10) #No.FUN-630086
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
 ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t54_aza17 FROM l_sql
    DECLARE t54_aza17_cs CURSOR FOR t54_aza17
    FOREACH t54_aza17_cs INTO g_aza17 END FOREACH
 END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
 IF g_flag ='N' THEN
     SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t54_occ631 FROM l_sql
    DECLARE t54_occ631_cs CURSOR FOR t54_occ631
    FOREACH t54_occ631_cs INTO l_occ631 END FOREACH
 END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
   SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
 ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t54_ocg FROM l_sql
    DECLARE t54_ocg_cs CURSOR FOR t54_ocg
    FOREACH t54_ocg_cs INTO g_ocg.* END FOREACH
 END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg21    LET l_plant[2]=g_ocg.ocg22
   #LET l_plant[3]=g_ocg.ocg23    LET l_plant[4]=g_ocg.ocg24
 
IF g_flag ='N' THEN               #TQC-AC0345 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 3"
#TQC-AC0345 --begin--
 ELSE
     LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 3"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
 END IF    
 #TQC-AC0345 --end--
    PREPARE t54_poch FROM l_sql
    DECLARE t54_och CURSOR FOR t54_poch
 
    LET l_j = 1
 
    FOREACH t54_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t54_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t54_azp03 FROM l_sql
    DECLARE t54_azp03_cs CURSOR FOR t54_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t54=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
       
      IF g_flag ='N' THEN   #TQC-AC0345 
        SELECT azp03 INTO l_azp03           # DATABASE ID
         FROM azp_file WHERE azp01=l_plant[l_i]
#TQC-AC0345 --begin--
      ELSE
        FOREACH t54_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--
        
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028  
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file",#TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102 
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t54_pre FROM l_sql
        DECLARE aza_t54_cur CURSOR FOR aza_t54_pre
        OPEN aza_t54_cur 
        FETCH aza_t54_cur INTO l_aza17
        CLOSE aza_t54_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028     
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102  
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t54_pre FROM l_sql
        DECLARE oaz_t54_cur CURSOR FOR oaz_t54_pre
        OPEN oaz_t54_cur
        FETCH oaz_t54_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
        #nmg22在系統中是null值,所以必須以單身之幣別判斷
      # LET l_sql=" SELECT nmg23,nmg22 FROM ", #本幣,原幣,幣別
        LET l_sql=" SELECT npk08,npk09,npk05,nmg00,nmg01 ", #原幣,本幣,幣別
#TQC-950028    ----start  
                 #" FROM ",l_azp03 CLIPPED,".dbo.nmg_file,",
                 #  l_azp03 CLIPPED,".dbo.npk_file",
                  #" FROM ",s_dbstring(l_azp03 CLIPPED),"nmg_file,",  
                  #  s_dbstring(l_azp03 CLIPPED),"npk_file",
                " FROM ",cl_get_target_table(l_plant[l_i],'nmg_file'),",", #FUN-A50102    
                         cl_get_target_table(l_plant[l_i],'npk_file'),     #FUN-A50102    
#TQC-950028     ---end 
                 " WHERE nmg18='",p_occ01,"' AND nmgconf = 'Y'",
                 "  AND nmg00=npk00 ",
                 "  AND nmg20 LIKE '2%' ",
                 "   AND nmg23 > 0 ",
                 " AND (nmg24 IS NULL OR nmg24=0 )"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE t54_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t54',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t54_curs CURSOR FOR t54_pre
       FOREACH t54_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
       #FUN-640215 ---add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020 
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
       #FUN-640215 ---end---
        LET l_tmp= l_tmp * g_ocg.ocg04/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t54=l_t54+l_tmp
       END FOREACH
    END FOR
    RETURN l_t54
END FUNCTION
 
#-(B)-------------------------------------#
# 沖帳未確認                              #
#-----------------------------------------#
FUNCTION s_ccc_cal_t55(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t55,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_nmg05     LIKE nmg_file.nmg05,
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_sql2      STRING,   #MOD-A50023 add
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE  #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)   #No.FUN-630086
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
 IF g_flag ='N' THEN
     SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
 ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t55_aza17 FROM l_sql
    DECLARE t55_aza17_cs CURSOR FOR t55_aza17
    FOREACH t55_aza17_cs INTO g_aza17 END FOREACH
 END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t55_occ631 FROM l_sql
    DECLARE t55_occ631_cs CURSOR FOR t55_occ631
    FOREACH t55_occ631_cs INTO l_occ631 END FOREACH
 END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t55_ocg FROM l_sql
    DECLARE t55_ocg_cs CURSOR FOR t55_ocg
    FOREACH t55_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg30    LET l_plant[2]=g_ocg.ocg31`
   #LET l_plant[3]=g_ocg.ocg32    LET l_plant[4]=g_ocg.ocg33
 
 IF g_flag ='N' THEN        #TQC-AC0345
    LET l_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 4"
#TQC-AC0345 --begin--
 ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
               " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 4"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
 END IF
 #TQC-AC0345 --end--
    PREPARE t55_poch FROM l_sql
    DECLARE t55_och CURSOR FOR t55_poch
 
    LET l_j = 1
 
    FOREACH t55_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t55_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t55_azp03 FROM l_sql
    DECLARE t55_azp03_cs CURSOR FOR t55_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t55=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
       
       IF g_flag = 'N' THEN      #TQC-AC0345
          SELECT azp03 INTO l_azp03           # DATABASE ID
            FROM azp_file WHERE azp01=l_plant[l_i]
#TQC-AC0345 --begin--
       ELSE
         FOREACH t55_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
       END IF
#TQC-AC0345 --end--
       
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file",  #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file",#TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t55_pre FROM l_sql
        DECLARE aza_t55_cur CURSOR FOR aza_t55_pre
        OPEN aza_t55_cur 
        FETCH aza_t55_cur INTO l_aza17
        CLOSE aza_t55_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028  
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t55_pre FROM l_sql
        DECLARE oaz_t55_cur CURSOR FOR oaz_t55_pre
        OPEN oaz_t55_cur
        FETCH oaz_t55_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
 
       LET l_sql=" SELECT oob09,oob10,oob07,ooa01,ooa02 ",
#TQC-950028   ---start    
                #" FROM ", l_azp03 CLIPPED,".dbo.oob_file,",
                #          l_azp03 CLIPPED,".dbo.ooa_file",
                 #" FROM ", s_dbstring(l_azp03 CLIPPED),"oob_file,",  
                 #          s_dbstring(l_azp03 CLIPPED),"ooa_file",
               " FROM ", cl_get_target_table(l_plant[l_i],'oob_file'),",", #FUN-A50102  
                         cl_get_target_table(l_plant[l_i],'ooa_file'),     #FUN-A50102    
#TQC-950028   ---end  
                 " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                 "   AND oob09 > 0 ",
                 " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
      #MOD-A50023---add---start---
       LET l_sql2 = "SELECT oob09*-1,oob10*-1,oob07,ooa01,ooa02 ",
                    #" FROM ", s_dbstring(l_azp03 CLIPPED),"oob_file,",                                                                            
                    #          s_dbstring(l_azp03 CLIPPED),"ooa_file",
                    " FROM ", cl_get_target_table(l_plant[l_i],'oob_file'),",", #FUN-A50102  
                              cl_get_target_table(l_plant[l_i],'ooa_file'),     #FUN-A50102        
                    " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                    "   AND oob09 > 0 ",
                    " AND oob04 = '3'  AND oob03='1' AND ooa01=oob01 "
       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       CALL cl_parse_qry_sql(l_sql2,l_plant[l_i]) RETURNING l_sql2 #FUN-A50102
       LET l_sql=l_sql," UNION ",l_sql2
      #MOD-A50023---add---end---
       PREPARE t55_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t55',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t55_curs CURSOR FOR t55_pre
       FOREACH t55_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
       #FUN-640215 ---add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020 
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
       #FUN-640215 ---end---
        LET l_tmp= l_tmp * g_ocg.ocg05/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t55=l_t55+l_tmp
       END FOREACH
    END FOR
    RETURN l_t55
END FUNCTION
 
 
#-(5)-------------------------------------#
# 多工廠未兌應收票據計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION s_ccc_cal_t61(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t61,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE      #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)   #No.FUN-630086

#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--
 
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
 ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t61_aza17 FROM l_sql
    DECLARE t61_aza17_cs CURSOR FOR t61_aza17
    FOREACH t61_aza17_cs INTO g_aza17 END FOREACH
 END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag ='N' THEN
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t61_occ631 FROM l_sql
    DECLARE t61_occ631_cs CURSOR FOR t61_occ631
    FOREACH t61_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
 IF g_flag = 'N' THEN      #TQC-AC0345 
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61
#TQC-AC0345 --begin--
 ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t61_ocg FROM l_sql
    DECLARE t61_ocg_cs CURSOR FOR t61_ocg
    FOREACH t61_ocg_cs INTO g_ocg.* END FOREACH
 END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg39    LET l_plant[2]=g_ocg.ocg40
   #LET l_plant[3]=g_ocg.ocg41    LET l_plant[4]=g_ocg.ocg42
 
 IF g_flag = 'N' THEN  #TQC-AC0345
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 5"
#TQC-AC0345 --begin--
 ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 5"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF
 #TQC-AC0345 --end--
    PREPARE t61_poch FROM l_sql
    DECLARE t61_och CURSOR FOR t61_poch
 
    LET l_j = 1
 
    FOREACH t61_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t61_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t61_azp03 FROM l_sql
    DECLARE t61_azp03_cs CURSOR FOR t61_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t61=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
     
       IF g_flag = 'N' THEN    #TQC-AC0345
          SELECT azp03 INTO l_azp03           # DATABASE ID
            FROM azp_file WHERE azp01=l_plant[l_i]
#TQC-AC0345 --begin--
      ELSE
        FOREACH t61_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--
      
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file",#TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t61_pre FROM l_sql
        DECLARE aza_t61_cur CURSOR FOR aza_t61_pre
        OPEN aza_t61_cur 
        FETCH aza_t61_cur INTO l_aza17
        CLOSE aza_t61_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028 
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t61_pre FROM l_sql
        DECLARE oaz_t61_cur CURSOR FOR oaz_t61_pre
        OPEN oaz_t61_cur
        FETCH oaz_t61_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh09  ",
                #"   FROM ",l_azp03 CLIPPED,".dbo.nmh_file", #TQC-950028
                 #"   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file",#TQC-950028
                 "   FROM ",cl_get_target_table(l_plant[l_i],'nmh_file'), #FUN-A50102  
                 " WHERE nmh11='",p_occ01,"' AND (nmh24 IN ('1','2','3') OR (nmh24 IN ('4') AND nmh05 >= '",g_today,"'))", #FUN-870084 #MOD-8B0191
                 "   AND nmh02 > 0 ",
                 "   AND nmh38 <> 'X' ",
                 " AND (nmh17 >0 AND nmh17 IS NOT NULL)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE t61_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t61',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t61_curs CURSOR FOR t61_pre
       FOREACH t61_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
        #FUN-640215 ---add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #FUN-640215 ---add---
        LET l_tmp= l_tmp * g_ocg.ocg06/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t61=l_t61+l_tmp
       END FOREACH
    END FOR
    RETURN l_t61
END FUNCTION
 
#-(6)-----------------------------------#
# 多工廠發票應收帳計算 by WUPN 96-05-23 #
#---------------------------------------#
FUNCTION s_ccc_cal_t62(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t62,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE   #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)  #No.FUN-630086
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
   IF g_flag ='N' THEN
     SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
   ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t62_aza17 FROM l_sql
    DECLARE t62_aza17_cs CURSOR FOR t62_aza17
    FOREACH t62_aza17_cs INTO g_aza17 END FOREACH
   END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
 IF g_flag = 'N' THEN
   SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t62_occ631 FROM l_sql
    DECLARE t62_occ631_cs CURSOR FOR t62_occ631
    FOREACH t62_occ631_cs INTO l_occ631 END FOREACH
 END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t62_ocg FROM l_sql
    DECLARE t62_ocg_cs CURSOR FOR t62_ocg
    FOREACH t62_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg48    LET l_plant[2]=g_ocg.ocg49
   #LET l_plant[3]=g_ocg.ocg50    LET l_plant[4]=g_ocg.ocg51
 
  IF g_flag = 'N' THEN   #TQC-AC0345 
     LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 6"
#TQC-AC0345 --begin--
 ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 6"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
 END IF
#TQC-AC0345 --end--
    PREPARE t62_poch FROM l_sql
    DECLARE t62_och CURSOR FOR t62_poch
 
    LET l_j = 1
 
    FOREACH t62_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t62_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t62_azp03 FROM l_sql
    DECLARE t62_azp03_cs CURSOR FOR t62_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t62=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
     
#TQC-AC0345 --begin--
      IF g_flag = 'N' THEN
        SELECT azp03 INTO l_azp03           # DATABASE ID
         FROM azp_file WHERE azp01=l_plant[l_i]
      ELSE
        FOREACH t62_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--
    
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t62_pre FROM l_sql
        DECLARE aza_t62_cur CURSOR FOR aza_t62_pre
        OPEN aza_t62_cur 
        FETCH aza_t62_cur INTO l_aza17
        CLOSE aza_t62_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028 
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t62_pre FROM l_sql
        DECLARE oaz_t62_cur CURSOR FOR oaz_t62_pre
        OPEN oaz_t62_cur
        FETCH oaz_t62_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
        #No.TQC-5C0086  --Begin                                                                                                     
        IF g_ooz.ooz07 = 'N' THEN
           LET l_sql="SELECT oma54t-oma55,oma56t-oma57,oma23,oma01,oma11 ",
          #LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",    #A060
                    #"  FROM ",l_azp03 CLIPPED,".dbo.oma_file", #TQC-950028 
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file", #TQC-950028
                     "  FROM ",cl_get_target_table(l_plant[l_i],'oma_file'), #FUN-A50102
                     " WHERE oma03='",p_occ01,"'",
                     "   AND oma54t>oma55",
                     "   AND omaconf='Y' AND oma00 LIKE '1%'"
        ELSE                                                                                                                        
           LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",                                                                
                    #"  FROM ",l_azp03 CLIPPED,".dbo.oma_file",    #TQC-950028   
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",   #TQC-950028
                     "  FROM ",cl_get_target_table(l_plant[l_i],'oma_file'), #FUN-A50102                    
                     " WHERE oma03='",p_occ01,"'",                                                                                  
                     "   AND oma54t>oma55",                                                                                         
                     "   AND omaconf='Y' AND oma00 LIKE '1%'"                                                                       
        END IF                                                                                                                      
        #No.TQC-5C0086  --End
       #FUN-630043
        IF g_aza.aza52='Y' THEN
           LET l_sql=l_sql CLIPPED," AND oma66='",l_plant[l_i],"' "
        END IF
       #END FUN-630043
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE t62_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t62',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t62_curs CURSOR FOR t62_pre
       FOREACH t62_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
        #FUN-640215 ---add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               #LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01)   #FUN-980020 #MOD-BC0150 mark
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #MOD-BC0150 add
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #FUN-640215 ---add---
        LET l_tmp= l_tmp * g_ocg.ocg07/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t62=l_t62+l_tmp
       END FOREACH
    END FOR
    RETURN l_t62
END FUNCTION
 
#-(7)-------------------------------------#
# 多工廠出貨未轉應收計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION s_ccc_cal_t63(p_occ01,p_slip,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          p_slip      LIKE oga_file.oga01,     #No.FUN-680147 VARCHAR(16)      
          l_t63,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oga24     LIKE oga_file.oga24,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_sql1      STRING,   #MOD-9C0316 
          l_sql2      STRING,   #MOD-9C0316 
          l_sql3      STRING,   #MOD-9C0316 
          l_sql4      STRING,   #MOD-9C0316 
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE     #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)  #No.FUN-630086

#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end-- 

#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t63_aza17 FROM l_sql
    DECLARE t63_aza17_cs CURSOR FOR t63_aza17
    FOREACH t63_aza17_cs INTO g_aza17 END FOREACH
  END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t63_occ631 FROM l_sql
    DECLARE t63_occ631_cs CURSOR FOR t63_occ631
    FOREACH t63_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t63_ocg FROM l_sql
    DECLARE t63_ocg_cs CURSOR FOR t63_ocg
    FOREACH t63_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg57    LET l_plant[2]=g_ocg.ocg58 
   #LET l_plant[3]=g_ocg.ocg59    LET l_plant[4]=g_ocg.ocg60
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 7"
  ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 7"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF
 #TQC-AC0345 --end--
    PREPARE t63_poch FROM l_sql
    DECLARE t63_och CURSOR FOR t63_poch
 
    LET l_j = 1
 
    FOREACH t63_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t63_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----
   
#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t63_azp03 FROM l_sql
    DECLARE t63_azp03_cs CURSOR FOR t63_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t63=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
   
#TQC-AC0345 --begin--
       IF g_flag = 'N' THEN
         SELECT azp03 INTO l_azp03           # DATABASE ID
         FROM azp_file WHERE azp01=l_plant[l_i]
       ELSE
          FOREACH t63_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
       END IF
#TQC-AC0345 --end--
   
        #----add---#FUN-640215
 
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(S) 
        LET g_plant_new = l_azp01
        CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(E) 
 
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE aza_t63_pre FROM l_sql
        DECLARE aza_t63_cur CURSOR FOR aza_t63_pre
        OPEN aza_t63_cur 
        FETCH aza_t63_cur INTO l_aza17
        CLOSE aza_t63_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file",  #TQC-950028  
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t63_pre FROM l_sql
        DECLARE oaz_t63_cur CURSOR FOR oaz_t63_pre
        OPEN oaz_t63_cur
        FETCH oaz_t63_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
         #己出貨未轉應收, 所以要考慮應收未確認的亦歸在出貨未轉應收
        #MOD-9C0316---modify---start---
         LET l_sql1=" SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                #" FROM ",l_azp03 CLIPPED,".dbo.oga_file ", #TQC-950028 
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ",#TQC-950028   
                 #" FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file ",#FUN-980094 GP5.2 mod
                 " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                 " WHERE oga03='",p_occ01,"' ",
#                "  AND oga09 IN ('2','3','4','8') ",                         #CHI-8C0028 Mark
                 "  AND oga09 IN ('2','3','4','6','8') ",                     #CHI-8C0028
                 "  AND oga65='N' ",  #No.FUN-610020
                 "  AND oga00 IN ('1','4','5') ",
                 "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                 "  AND ogaconf = 'Y'",              #已確認
                 "  AND ogapost = 'Y'"               #已扣帳
                #"  UNION ",
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
         LET l_sql2= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
#TQC-950028     ---start  
                #" FROM ",l_azp03 CLIPPED,".dbo.oga_file, ",
                #"      ",l_azp03 CLIPPED,".dbo.oma_file ",
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ",   
                 #" FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file, ",  #FUN-980094 GP5.2 mod
                 #"      ",s_dbstring(l_azp03 CLIPPED),"oma_file ",
                 " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'oma_file'),      #FUN-A50102
#TQC-950028    ---end    
                 " WHERE oga03='",p_occ01,"' ",
#                "  AND oga09 IN ('2','3','4','8') ",                         #CHI-8C0028 Mark
                 "  AND oga09 IN ('2','3','4','6','8') ",                     #CHI-8C0028                 
                 "  AND oga65='N' ",  #No.FUN-610020
                 "  AND oga00 IN ('1','4','5') ",
                 "  AND (oga10 IS NOT NULL AND oga10 <> ' ') ",   #帳款編號
                 "  AND oga10=oma01 ",
                 "  AND ogaconf = 'Y'",              #已確認
                 "  AND ogapost = 'Y'",              #已扣帳
                 "  AND omaconf='N' "
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
         LET l_sql = l_sql1," UNION ",l_sql2
        #MOD-9C0316---modify---end--- 
      #-----No.MOD-640569----- by Clinton 
      #-----當  出貨通知單&接單未出貨 都不 check 時,
      #-----則  需特別考慮出貨單已確認未過帳情況 --- 
 
      IF g_ocg.ocg09 = 0 AND g_ocg.ocg10 = 0 THEN 
        IF cl_null(p_slip) THEN
          #MOD-9C0316---modify---start---
          #LET l_sql = l_sql CLIPPED,
          #      "  UNION ",
           LET l_sql3= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                #" FROM ",l_azp03 CLIPPED,".dbo.oga_file ", #TQC-950028    
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ", #TQC-950028   
                 #" FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file ", #FUN-980094 GP5.2
                 " FROM ",cl_get_target_table(g_plant_new,'oga_file'),      #FUN-A50102
                 " WHERE oga03='",p_occ01,"' ",
#                "  AND oga09 IN ('2','3','4','8') ",                         #CHI-8C0028 Mark
                 "  AND oga09 IN ('2','3','4','6','8') ",                     #CHI-8C0028                 
                 "  AND oga65='N' ",  #No.FUN-610020
                 "  AND oga00 IN ('1','4','5') ",
                 "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                 "  AND ogapost = 'N'",              #未扣帳
                 "  AND oga55 IN ('1','S') "         #已確認
        ELSE
          #LET l_sql = l_sql CLIPPED,
          #      "  UNION ",
           LEt l_sql3= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                #" FROM ",l_azp03 CLIPPED,".dbo.oga_file ",  #TQC-950028  
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ", #TQC-950028    
                 #" FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file ", #FUN-980094 GP5.2 mod
                 " FROM ",cl_get_target_table(g_plant_new,'oga_file'),      #FUN-A50102
                 " WHERE oga03='",p_occ01,"' ",
#                "  AND oga09 IN ('2','3','4','8') ",                         #CHI-8C0028 Mark
                 "  AND oga09 IN ('2','3','4','6','8') ",                     #CHI-8C0028                 
                 "  AND oga65='N' ",  #No.FUN-610020
                 "  AND oga00 IN ('1','4','5') ",
                 "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                 "  AND ogapost = 'N'",              #未扣帳
                 "  AND ( oga55 IN ('1','S') ",      #已確認
                 "     OR oga01 = '",p_slip,"' ) "
        END IF
        CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3
        LET l_sql = l_sql," UNION ",l_sql3
          #MOD-9C0316---modify---end---
      END IF 
      #-----No.MOD-640569 END-----
 
      #No.MOD-8A0126 add --begin
      IF NOT cl_null(p_slip) THEN
        #MOD-9C0316---modify---start---
        #LET l_sql = l_sql CLIPPED,
        #      "  UNION ",
         LET l_sql4= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
              #"   FROM ",l_azp03 CLIPPED,".dbo.oga_file ", #TQC-950028  
              #"   FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ",#TQC-950028  
               #"   FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file ",#FUN-980094 GP5.2 mod
               "   FROM ",cl_get_target_table(g_plant_new,'oga_file'),      #FUN-A50102
               "  WHERE oga03='",p_occ01,"' ",
#              "    AND oga09 IN ('2','3','4','8') ",                         #CHI-8C0028 Mark
               "    AND oga09 IN ('2','3','4','6','8') ",                     #CHI-8C0028               
               "    AND oga65='N' ",
               "    AND oga00 IN ('1','4','5') ",
               "    AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
               "    AND oga01 = '",p_slip,"'  "
         CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4
         LET l_sql = l_sql," UNION ",l_sql4
        #MOD-9C0316---modify---end---
      END IF
      #No.MOD-8A0126 add --end
 
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
 
       PREPARE t63_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t63',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t63_curs CURSOR FOR t63_pre
       FOREACH t63_curs INTO l_amt,g_curr,l_oga24,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = l_amt*l_oga24
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
         #FUN-640215 add----
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = l_amt*l_oga24
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020 
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
         #FUN-640215 end----
        LET l_tmp= l_tmp * g_ocg.ocg08/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t63=l_t63+l_tmp
       END FOREACH
    END FOR
    RETURN l_t63
END FUNCTION
 
#-(8)--Sales Order ---------------------#
# 多工廠接單未出貨計算 by WUPN 96-05-23 #
#---------------------------------------#
FUNCTION s_ccc_cal_t64(p_occ01,p_slip,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_slip      LIKE oga_file.oga01,     #No.FUN-680147 VARCHAR(16)
          p_occ61     LIKE occ_file.occ61,
          l_t64,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE   #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
        # l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)  #No.FUN-630086
   #No.MOD-8A0126 add --begin
   DEFINE l_oeb04     LIKE oeb_file.oeb04        #訂單料號
   DEFINE l_oeb05     LIKE oeb_file.oeb05        #銷售單位
   DEFINE l_oeb916    LIKE oeb_file.oeb916       #計價單位
   DEFINE l_amt2      LIKE oeb_file.oeb14t       #訂單項次金額
   DEFINE l_amt3      LIKE oeb_file.oeb14t       #訂單項次已出貨金額
   DEFINE l_amt4      LIKE oeb_file.oeb14t       #當前出貨單金額
   DEFINE l_num       LIKE type_file.num5
   DEFINE l_factor    LIKE ima_file.ima31_fac
   #No.MOD-8A0126 add --end
   #MOD-B60164 -- begin --
   DEFINE l_oeb13     LIKE oeb_file.oeb13,
          l_oeb24     LIKE oeb_file.oeb24,
          l_oeb1006   LIKE oeb_file.oeb1006
   #MOD-B60164 -- end --
   DEFINE l_oeb12     LIKE oeb_file.oeb12 #MOD-C80206 add
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t64_aza17 FROM l_sql
    DECLARE t64_aza17_cs CURSOR FOR t64_aza17
    FOREACH t64_aza17_cs INTO g_aza17 END FOREACH
  END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t64_occ631 FROM l_sql
    DECLARE t64_occ631_cs CURSOR FOR t64_occ631
    FOREACH t64_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t64_ocg FROM l_sql
    DECLARE t64_ocg_cs CURSOR FOR t64_ocg
    FOREACH t64_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg66    LET l_plant[2]=g_ocg.ocg67
   #LET l_plant[3]=g_ocg.ocg68    LET l_plant[4]=g_ocg.ocg69
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
      LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 9"
  ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 9"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF
#TQC-AC0345 --end--
    PREPARE t64_poch FROM l_sql
    DECLARE t64_och CURSOR FOR t64_poch
 
    LET l_j = 1
 
    FOREACH t64_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t64_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

 #TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t64_azp03 FROM l_sql
    DECLARE t64_azp03_cs CURSOR FOR t64_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t64=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
    
 #TQC-AC0345 --begin--
      IF g_flag = 'N' THEN
         SELECT azp03 INTO l_azp03           # DATABASE ID
         FROM azp_file WHERE azp01=l_plant[l_i]
      ELSE
        FOREACH t64_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--
    
        #----add---#FUN-640215
 
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(S) 
        LET g_plant_new = l_azp01
        CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(E) 
 
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                   "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102        
        PREPARE aza_t64_pre FROM l_sql
        DECLARE aza_t64_cur CURSOR FOR aza_t64_pre
        OPEN aza_t64_cur 
        FETCH aza_t64_cur INTO l_aza17
        CLOSE aza_t64_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028  
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t64_pre FROM l_sql
        DECLARE oaz_t64_cur CURSOR FOR oaz_t64_pre
        OPEN oaz_t64_cur
        FETCH oaz_t64_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
       #接單未出貨為訂單量-出貨量-出貨通知單量(因出貨通知單亦有單獨計算額度)
      #No.MOD-820186--begin-- modify
      #LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,SUM(oeb14t),",
      #          "        SUM(oeb24*oeb13) ",
      #          " FROM ",l_azp03 CLIPPED,".dbo.oea_file, ",
      #          "      ",l_azp03 CLIPPED,".dbo.oeb_file ",
      #          " WHERE oea03='",p_occ01,"' ",
      #          " AND oea01=oeb01 ",
      #          " AND oeb12 > oeb24 ",
      #       #  " AND oeaconf='Y' AND oea00 MATCHES '[1345]'" ,
      #          " AND oea00 IN ('1','4','5')" ,    #No.MOD-7A0077 modify
      #          " AND oeb70='N' "
  
              LET l_sql=" SELECT DISTINCT oea01,oea02,oea23,oea24,oea211 ",
#TQC-950028   ---start   
                #" FROM ",l_azp03 CLIPPED,".dbo.oea_file,  ",  #MOD-840337 add , 
                #"      ",l_azp03 CLIPPED,".dbo.oeb_file ",
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file,  ",  
                #"      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",  
                 #" FROM ",s_dbstring(g_dbs_tra CLIPPED),"oea_file,  ",  #FUN-980094 GP5.2 mod 
                 #"      ",s_dbstring(g_dbs_tra CLIPPED),"oeb_file ",      #FUN-980094 GP5.2 mod
                  " FROM ",cl_get_target_table(l_plant[l_i],'oea_file'),",", #FUN-A50102 
                           cl_get_target_table(l_plant[l_i],'oeb_file'),     #FUN-A50102 
#TQC-950028   ---end    
                 " WHERE oea03='",p_occ01,"' ",
                 " AND oea01=oeb01 ",
                 #" AND oeb12 > oeb24 ",   #MOD-890205
                #" AND oeaconf='Y' AND oea00 IN ('1','3','4','5') " ,	#MOD-990044 mark
                 #" AND oeaconf='Y' AND oea00 IN ('1','4','5') " ,	#MOD-990044   #CHI-AC0036
                 " AND oea00 IN ('1','4','5') " ,	#MOD-990044   #CHI-AC0036
                 " AND oeb70='N' "
      #No.MOD-820186---end---
 
      #-----No.MOD-640569-----
      IF cl_null(p_slip) THEN
         LET l_sql = l_sql CLIPPED,
                     #-----CHI-AC0036---------
                     #" AND oea49 IN ('1','S') ",     #No:MOD-640569   
                     " AND (oeaconf='Y' OR oea49='S')",
                     #-----END CHI-AC0036-----
                     " GROUP BY oea01,oea02,oea23,oea24,oea211 "
      ELSE
         LET l_sql = l_sql CLIPPED,
                     #-----CHI-AC0036---------
                     #" AND ( oea49 IN ('1','S') ",   #No:MOD-640569  
                     " AND (oeaconf='Y' OR oea49='S' ",
                     #-----END CHI-AC0036-----
                     "     OR oea01 = '",p_slip,"' ) ",
                     " GROUP BY oea01,oea02,oea23,oea24,oea211 "
      END IF
      #-----No.MOD-640569 END-----
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
 
       PREPARE t64_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
#         CALL cl_err('pre t61',SQLCA.SQLCODE,1)   #MOD-B60164 mark
          CALL cl_err('pre t64',SQLCA.SQLCODE,1)   #MOD-B60164
       END IF   
       DECLARE t64_curs CURSOR FOR t64_pre

       #CHI-AC0030 add --start--
#      LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14t,oeb24* CAST(oeb13*oeb1006/100 AS DECIMAL(20,",t_azi03,"))",  #MOD-B60164 mark
      #LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14t,oeb24,oeb13,oeb1006",                                        #MOD-B60164 #MOD-C80206 mark
       LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14,oeb24,oeb13,oeb1006,oeb12",                                               #MOD-C80206
               " FROM ",cl_get_target_table(g_plant_new,'oeb_file'),    
               " WHERE oeb01=? ",
               " AND oeb70='N' "   
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
 
       PREPARE t64_pre_1 FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
#         CALL cl_err('pre t61',SQLCA.SQLCODE,1)   #MOD-B60164 mark
          CALL cl_err('pre t64',SQLCA.SQLCODE,1)   #MOD-B60164
       END IF
       DECLARE t64_cur_1 CURSOR FOR t64_pre_1

       LET l_sql = "SELECT SUM(ogb14t)",
                   "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",  
                             cl_get_target_table(g_plant_new,'ogb_file'),   
                   " WHERE oga01=ogb01", 
                   "   AND oga09 IN ('1','5') ",
                   "   AND ogb31=? "
#MOD-B80027 -- begin --
                   ,"  AND ogb31||ogb32 IN (SELECT oeb01||oeb03 FROM ",cl_get_target_table(g_plant_new,'oeb_file'),
                   "                        WHERE oeb01=? AND oeb70='N')"
#MOD-B80027 -- end --
 
       IF cl_null(p_slip) THEN
          LET l_sql = l_sql CLIPPED,
                      " AND oga55 IN ('1','S') "
       ELSE
          LET l_sql = l_sql CLIPPED,
                      " AND ( oga55 IN ('1','S') ",  
                      "     OR oga01 = '",p_slip,"' ) "
       END IF
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
 
       PREPARE t64_pre2 FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
           CALL cl_err('pre t64_pre2',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t64_curs2 CURSOR FOR t64_pre2
       #CHI-AC0030 add --end--

      #No.MOD-820186--begin--
      #FOREACH t64_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211,
      #                      l_amt,pab_amt
       FOREACH t64_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211
#        SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  #CHI-910034
         SELECT azi03 INTO t_azi03 FROM azi_file                #CHI-910034
          WHERE azi01 = g_curr
   #No.MOD-8A0126 mark --begin
   #     LET l_sql = " SELECT SUM(oeb14t),SUM(oeb24* CAST(oeb13*oeb1006/100 AS DECIMAL(20,",t_azi03,")))",
   #             " FROM ",l_azp03 CLIPPED,".dbo.oeb_file ",
   #            #" AND oeb01='",l_oea01 CLIPPED,"'",    #MOD-840337 mark
   #             "  WHERE oeb01='",l_oea01 CLIPPED,"'", #MOD-840337
   #             #" AND oeb12 > oeb24 ",   #MOD-890205
   #             " AND oeb70='N' "   
   #     PREPARE t64_pre_1 FROM l_sql
   #     IF SQLCA.SQLCODE <> 0 THEN
   #        CALL cl_err('pre t61',SQLCA.SQLCODE,1) 
   #     END IF
   #     EXECUTE t64_pre_1 INTO l_amt,pab_amt
   #     LET pab_amt = cl_digcut(pab_amt,t_azi04)
   #  #No.MOD-820186---end---
   #     LET l_no=l_oea01
   #     IF l_amt IS NULL THEN LET l_amt = 0 END IF 
   #     IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
   #     IF pab_amt IS NULL THEN LET pab_amt = 0 END IF 
   #     LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
   #No.MOD-8A0126 mark --end
   #No.MOD-8A0126 add --begin
        #CHI-AC0030 mark --start--
        #LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14t,oeb24* CAST(oeb13*oeb1006/100 AS DECIMAL(20,",t_azi03,"))",
        #       #" FROM ",l_azp03 CLIPPED,".dbo.oeb_file ", #TQC-950028  
        #       #" FROM ",s_dbstring(l_azp03 CLIPPED),"oeb_file ", #TQC-950028   
        #        #" FROM ",s_dbstring(g_dbs_tra CLIPPED),"oeb_file ", #FUN-980094 GP5.2 mod
        #        " FROM ",cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
        #        " WHERE oeb01='",l_oea01 CLIPPED,"'",
        #        " AND oeb70='N' "   
 
        #CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
        #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
 
        #PREPARE t64_pre_1 FROM l_sql
        #IF SQLCA.SQLCODE <> 0 THEN
        #   CALL cl_err('pre t61',SQLCA.SQLCODE,1) 
        #END IF
        #DECLARE t64_cur_1 CURSOR FOR t64_pre_1
        #CHI-AC0030 mark --end--
         LET l_amt = 0
         LET pab_amt = 0 
        #FOREACH t64_cur_1 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_amt3 #CHI-AC0030 mark
#        FOREACH t64_cur_1 USING l_oea01 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_amt3 #CHI-AC0030         #MOD-B60164 mark
        #FOREACH t64_cur_1 USING l_oea01 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_oeb24,l_oeb13,l_oeb1006  #MOD-B60164 #MOD-C80206 mark
         FOREACH t64_cur_1 USING l_oea01 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_oeb24,l_oeb13,l_oeb1006,l_oeb12      #MOD-C80206
#           LET l_amt3 = cl_digcut(l_amt3,t_azi04)      #CHI-910034
            IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF 
           #MOD-C80206 add --start--
            IF l_oeb24 = l_oeb12 THEN
               LET l_amt3 = l_amt2
            ELSE
           #MOD-C80206 add --end--
               LET l_amt3 = l_oeb24 * cl_digcut((l_oeb13*l_oeb1006/100),t_azi03)                            #MOD-B60164 add
               IF l_amt3 IS NULL THEN LET l_amt3 = 0 END IF
               IF cl_null(l_oeb916) THEN
                  LET l_oeb916 = l_oeb05
               END IF 
               CALL s_umfchk(l_oeb04,l_oeb05,l_oeb916) RETURNING l_num,l_factor
               IF l_num = 1 THEN LET l_factor = 1 END IF
               LET l_amt3 = l_amt3 * l_factor
            END IF #MOD-C80206 add
            LET l_amt = l_amt + l_amt2
            LET pab_amt = pab_amt + l_amt3
         END FOREACH
         LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
         LET pab_amt = cl_digcut(pab_amt,t_azi04)   #MOD-B70221 add
         LET l_amt = l_amt*(1+l_oea211/100)        #含稅金額 #MOD-C80206 add
         LET l_amt = cl_digcut(l_amt,t_azi04)                #MOD-C80206 add
         #出貨單當前筆的金額在出貨單的時候已經考慮過了，這邊不能重復考慮
         IF NOT cl_null(p_slip) AND l_amt4 IS NULL THEN
            LET l_sql = " SELECT (oga50)*(1+oga211/100)",
                       #"   FROM ",l_azp03 CLIPPED,".dbo.oga_file ", #TQC-950028 
                       #"   FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file ", #TQC-950028 
                        #"   FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file ", #FUN-980094 GP5.2 mod
                        "   FROM ",cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                        "  WHERE oga03='",p_occ01,"' ",
#                       "    AND oga09 IN ('2','3','4','8') ",                         #CHI-8C0028 Mark
                        "    AND oga09 IN ('2','3','4','6','8') ",                     #CHI-8C0028                        
                        "    AND oga65='N' ", 
                        "    AND oga00 IN ('1','4','5') ",
                        "    AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                        "    AND oga01 = '",p_slip,"' "
 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
 
            PREPARE t64_pre_2 FROM l_sql
              IF SQLCA.SQLCODE <> 0 THEN
                 CALL cl_err('pre t64_pre_2',SQLCA.SQLCODE,1) 
              END IF
            EXECUTE t64_pre_2 INTO l_amt4
            IF cl_null(l_amt4) THEN
               LET l_amt4 = 0
            END IF
            LET pab_amt = pab_amt + l_amt4    #只能加一次
         END IF
   #No.MOD-8A0126 add --end
         #BugNo:4388---------------- 
         #計算出貨通知單量
         LET ifb_amt =0
#CHI-AC0030 mark --start--
#         LET l_sql = "SELECT SUM(ogb14t)",
##TQC-950028   ---start   
#                    #"  FROM ",l_azp03 CLIPPED,".oga_file, ",
#                    #"       ",l_azp03 CLIPPED,".ogb_file ",
#                    #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ", 
#                    #"       ",s_dbstring(l_azp03 CLIPPED),"ogb_file ",     
#                     #"  FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file, ", #FUN-980094 GP5.2 mod
#                     #"       ",s_dbstring(g_dbs_tra CLIPPED),"ogb_file ",  #FUN-980094 GP5.2 mod
#                     "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",",  #FUN-A50102
#                               cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
##TQC-950028   ---end  
#                     " WHERE oga01=ogb01", 
#                     "   AND oga09 IN ('1','5') ",
#                     "   AND ogb31='",l_oea01,"'"
#                    #"   AND ogaconf='Y'"
# 
#      #-----No.MOD-640569-----
#      IF cl_null(p_slip) THEN
#         LET l_sql = l_sql CLIPPED,
#                     " AND oga55 IN ('1','S') "
#      ELSE
#         LET l_sql = l_sql CLIPPED,
#                     " AND ( oga55 IN ('1','S') ",  
#                     "     OR oga01 = '",p_slip,"' ) "
#      END IF
#      #-----No.MOD-640569 END-----
# 
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
#         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
# 
#         PREPARE t64_pre2 FROM l_sql
#         IF SQLCA.SQLCODE <> 0 THEN
#             CALL cl_err('pre t64_pre2',SQLCA.SQLCODE,1)
#         END IF   
#         DECLARE t64_curs2 CURSOR FOR t64_pre2
#         OPEN t64_curs2
#CHI-AC0030 mark --end--
#        OPEN t64_curs2 USING l_oea01 #CHI-AC0030 add   #MOD-B80027 mark
         OPEN t64_curs2 USING l_oea01,l_oea01           #MOD-B80027 
         FETCH t64_curs2 INTO ifb_amt
         #-----------------
                  
         IF cl_null(ifb_amt) THEN LET ifb_amt=0 END IF
         LET ifb_amt = ifb_amt - pab_amt   #出貨通知單金額-已出貨金額
         IF ifb_amt < 0 THEN LET ifb_amt = 0 END IF
         #訂單未出貨金額=訂單金額-已出貨金額-出貨通知單金額(扣除已出貨)
         LET l_amt = l_amt - pab_amt - ifb_amt
         IF l_amt <= 0 THEN CONTINUE FOREACH END IF
        
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = l_amt*l_oea24
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
       #FUN-640215------add---------
        IF l_occ631=g_curr THEN
           LET l_tmp = l_amt
        ELSE
           IF l_oaz211 = '1' THEN
              LET l_tmp = l_amt*l_oea24
           ELSE
             #LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark #TQC-9C0099 add #
              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
              LET l_tmp = l_amt * g_exrate
           END IF
           IF l_occ631 <> l_aza17 THEN
             #LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark  #TQC-9C0099 add #
              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020 
              LET l_tmp = l_tmp*g_exrate  
           END IF
        END IF
       #FUN-640215------add---------
        LET l_tmp= l_tmp * g_ocg.ocg10/100   #No.FUN-630086
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t64=l_t64+l_tmp
       END FOREACH
    END FOR
    RETURN l_t64
END FUNCTION
 
#-(9)Shipping Notice----------------------#
# 多工廠出貨通知單                        #
#-----------------------------------------#
FUNCTION s_ccc_cal_t66(p_occ01,p_slip,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          p_slip  LIKE oga_file.oga01,     #No.FUN-680147 VARCHAR(16)     #No.FUn-560002
          l_t66,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE   #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
         #l_plant     ARRAY[8] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)  #No.FUN-630086
   DEFINE l_oga24     LIKE oga_file.oga24,   #CHI-8A0011
          ifb_tot,pab_tot LIKE oea_file.oea61   #CHI-8A0011

#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--
 
#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
     SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
   ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t66_aza17 FROM l_sql
    DECLARE t66_aza17_cs CURSOR FOR t66_aza17
    FOREACH t66_aza17_cs INTO g_aza17 END FOREACH
   END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t66_occ631 FROM l_sql
    DECLARE t66_occ631_cs CURSOR FOR t66_occ631
    FOREACH t66_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t66_ocg FROM l_sql
    DECLARE t66_ocg_cs CURSOR FOR t66_ocg
    FOREACH t66_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg80    LET l_plant[2]=g_ocg.ocg81 
   #LET l_plant[3]=g_ocg.ocg82    LET l_plant[4]=g_ocg.ocg83
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 8"
  ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 8"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF
#TQC-AC0345 --end--
    PREPARE t66_poch FROM l_sql
    DECLARE t66_och CURSOR FOR t66_poch
 
    LET l_j = 1
 
    FOREACH t66_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t66_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t66_azp03 FROM l_sql
    DECLARE t66_azp03_cs CURSOR FOR t66_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t66=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
    
#TQC-AC0345 --begin--
       IF g_flag = 'N' THEN
          SELECT azp03 INTO l_azp03           # DATABASE ID
          FROM azp_file WHERE azp01=l_plant[l_i]
       ELSE
          FOREACH t66_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
       END IF
#TQC-AC0345 --end--
 
 
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(S) 
        LET g_plant_new = l_azp01
        CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(E) 
 
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file",#TQC-950028 
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file",#TQC-950028
                  "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102       
        PREPARE aza_t66_pre FROM l_sql
        DECLARE aza_t66_cur CURSOR FOR aza_t66_pre
        OPEN aza_t66_cur 
        FETCH aza_t66_cur INTO l_aza17
        CLOSE aza_t66_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102        
        PREPARE oaz_t66_pre FROM l_sql
        DECLARE oaz_t66_cur CURSOR FOR oaz_t66_pre
        OPEN oaz_t66_cur
        FETCH oaz_t66_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
       #-----CHI-8A0011---------
       ##出貨通知單信用額度改用訂單角度去看, 因為出貨單可併出貨通知單出貨
       ##所以無法一對一的角度看出貨通知單出貨沒
       ##LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,SUM(oeb24*oeb13), ", #MOD-640498 mark
       #LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,0               , ", #MOD-640498 mod
       #          "        SUM(ogb14t)  ",
       #          " FROM ",l_azp03 CLIPPED,".dbo.oea_file, ",
       #          "      ",l_azp03 CLIPPED,".dbo.oeb_file,",
       #          "      ",l_azp03 CLIPPED,".dbo.oga_file,",
       #          "      ",l_azp03 CLIPPED,".dbo.ogb_file ",
       #          " WHERE oea03='",p_occ01,"' ",
       #          " AND oea01=oeb01 ",
       #          " AND oga01=ogb01 ",
       #          " AND ogb31=oeb01 ",
       #          " AND ogb32=oeb03 ",
       #          #" AND oeb12 > oeb24 ",   #MOD-890205
       #          " AND oga09 IN ('1','5')",
       #          " AND oeaconf='Y' AND oea00 IN ('1','4','5') " ,    #No.MOD-7A0077 modify
       #          " AND oeb70='N' "   #不含已結案
       #         #" AND ogaconf='Y' "
       #
       ##-----No.MOD-640569-----
       #IF cl_null(p_slip) THEN
       #   LET l_sql = l_sql CLIPPED,
       #               " AND oga55 IN ('1','S') ",     #No.MOD-640569
       #               " GROUP BY oea01,oea02,oea23,oea24,oea211 "
       #ELSE
       #   LET l_sql = l_sql CLIPPED,
       #               " AND ( oga55 IN ('1','S') ",   #No.MOD-640569
#      #               " AND ( oga55 IN ('1','S') ",   #No.MOD-640569
       #               "     OR oga01 = '",p_slip,"' ) ",
       #               " GROUP BY oea01,oea02,oea23,oea24,oea211 "
       #END IF
       ##-----No.MOD-640569 END-----
       #
       #PREPARE t66_pre FROM l_sql
       #IF SQLCA.SQLCODE <> 0 THEN
       #   CALL cl_err('pre t66',SQLCA.SQLCODE,1)
       #END IF   
       #DECLARE t66_curs CURSOR FOR t66_pre
       #FOREACH t66_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211,
       #                      pab_amt,ifb_amt
       #  #MOD-640498-----------add--------
       #  #MOD-650058 pab_amt應該要抓當站資料庫的資料來計算--
       #  #No.MOD-820186--begin--
       #  SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       #   WHERE azi01=g_curr 
       #  #No.MOD-820186---end---
       #  #-----MOD-890063---------
       #  #LET l_sql =
       #  #         #" SELECT SUM(oeb24*oeb13) ",      #No.MOD-6A0121 modify #MOD-820186 mark
       #  #          " SELECT SUM(oeb24* CAST(oeb13*oeb1006/100 AS DECIMAL(20,",t_azi03,"))) ", #No.MOD-820186  #TQC-840064 add )
       #  #          "   FROM ",l_azp03 CLIPPED,".dbo.oeb_file",
       #  #          "  WHERE oeb01 = '",l_oea01,"'",
       #  #          "    AND oeb12 > oeb24 "   #MOD-860089
       #  LET l_sql = " SELECT SUM(ogb14t) FROM oga_file,ogb_file ",
       #              "  WHERE ogb31 ='",l_oea01,"'",
       #              "    AND oga01 = ogb01 ",
       #              "    AND ogaconf='Y' ",
       #              "    AND ogapost='Y' ",
       #              "    AND oga09 MATCHES '[2348]' "
       #  #-----END MOD-890063-----
       #  PREPARE t66_pab_pre FROM l_sql
       #  DECLARE t66_pab_cur CURSOR FOR t66_pab_pre
       #  OPEN t66_pab_cur
       #  FETCH t66_pab_cur INTO pab_amt
       #  CLOSE t66_pab_cur
       #  #MOD-640498-----------end--------#MOD-650058 end-----
       #  LET pab_amt = cl_digcut(pab_amt,t_azi04)    #No.MOD-820186
       #  LET l_no = l_oea01
       #  IF l_amt IS NULL THEN LET l_amt = 0 END IF 
       #  IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #  IF pab_amt IS NULL THEN LET pab_amt = 0 END IF 
       #  #LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額   #MOD-890063
       #  IF cl_null(ifb_amt) THEN LET ifb_amt=0 END IF
       #  LET l_amt = ifb_amt - pab_amt   #出貨通知單金額-已出貨金額
       #  IF l_amt <= 0 THEN CONTINUE FOREACH END IF
       # 
       ##FUN-640215 mark改成下段
       ## IF l_occ631=g_curr THEN
       ##    LET l_tmp = l_amt
       ## ELSE
       ##    IF g_oaz.oaz211 = '1' THEN
       ##       LET l_tmp = l_amt*l_oea24
       ##    ELSE
       ##       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       ##       LET l_tmp = l_amt * g_exrate
       ##    END IF
       ##    IF l_occ631 <> g_aza17 THEN
       ##       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       ##       LET l_tmp = l_tmp*g_exrate  
       ##    END IF
       ##END IF
       # #FUN-640215 ---add---
       #  IF l_occ631=g_curr THEN
       #     LET l_tmp = l_amt
       #  ELSE
       #     IF l_oaz211 = '1' THEN
       #        LET l_tmp = l_amt*l_oea24
       #     ELSE
       #        LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215
       #        LET l_tmp = l_amt * g_exrate
       #     END IF
       #     IF l_occ631 <> l_aza17 THEN
       #        LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215
       #        LET l_tmp = l_tmp*g_exrate  
       #     END IF
       #  END IF
       # #FUN-640215 ---add---
       # LET l_tmp= l_tmp * g_ocg.ocg09/100   #No.FUN-630086
       # LET l_t66=l_t66+l_tmp
       #END FOREACH
       LET l_sql=" SELECT oea01 ",   
#TQC-950028   ---start 
                #" FROM ",l_azp03 CLIPPED,".dbo.oea_file, ",
                #"      ",l_azp03 CLIPPED,".dbo.oeb_file",
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file, ", 
                #"      ",s_dbstring(l_azp03 CLIPPED),"oeb_file",  
                # " FROM ",s_dbstring(g_dbs_tra CLIPPED),"oea_file, ",  #FUN-980094 GP5.2 mod
                # "      ",s_dbstring(g_dbs_tra CLIPPED),"oeb_file",    #FUN-980094 GP5.2 mod
                " FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                         cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
#TQC-950028    ---end 
                 " WHERE oea03='",p_occ01,"' ",
                 " AND oea01=oeb01 ",
                 " AND oeaconf='Y' AND oea00 IN ('1','4','5') " ,    
                 " AND oeb70='N' ",   #不含已結案
                 " GROUP BY oea01,oea02 "
       
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
 
       PREPARE t66_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t66',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t66_curs CURSOR FOR t66_pre

       #CHI-AC0030 add --start--
         LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
                    " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                             cl_get_target_table(g_plant_new,'ogb_file'),",",
                             cl_get_target_table(g_plant_new,'oeb_file'),   
                     "  WHERE ogb31 =? ",
                     "    AND oga01 = ogb01 ",
                     "    AND ogaconf='Y' ",
                     "    AND ogapost='Y' ",
                     "    AND oga09 IN ('2','3','4','6','8') ",     
                     "    AND ogb31 = oeb01 ",   
                     "    AND ogb32 = oeb03 ",  
                     "    AND oeb70 = 'N' ",   
                     "    GROUP BY oga23,oga24 "
 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
 
         PREPARE t66_pab_pre FROM l_sql
         DECLARE t66_pab_cur CURSOR FOR t66_pab_pre

         LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
                    " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                             cl_get_target_table(g_plant_new,'ogb_file'),",",
                             cl_get_target_table(g_plant_new,'oeb_file'),   
                     "  WHERE ogb31 =? ",
                     "    AND oga01 = ogb01 ",
                     "    AND oga09 IN ('1','5') ",
                     "    AND ogb31 = oeb01 ",   
                     "    AND ogb32 = oeb03 ",  
                     "    AND oeb70 = 'N' "    
         IF cl_null(p_slip) THEN
            LET l_sql = l_sql CLIPPED,
                        " AND oga55 IN ('1','S') ",    
                        " GROUP BY oga23,oga24 "
         ELSE
            LET l_sql = l_sql CLIPPED,
                        " AND ( oga55 IN ('1','S') ",  
                        "     OR oga01 = '",p_slip,"' ) ",
                        " GROUP BY oga23,oga24 "
         END IF
 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                     
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
 
         PREPARE t66_ifb_pre FROM l_sql
         DECLARE t66_ifb_cur CURSOR FOR t66_ifb_pre
       #CHI-AC0030 add --end--

       FOREACH t66_curs INTO l_oea01
#CHI-AC0030 mark --start--        
#         LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
##TQC-950028   ---start 
#                    #" FROM ",l_azp03 CLIPPED,".dbo.oga_file, ",
#                    #"      ",l_azp03 CLIPPED,".dbo.ogb_file, ",
#                    #"      ",l_azp03 CLIPPED,".dbo.oeb_file ",   #MOD-8B0078
#                    #" FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ",  
#                    #"      ",s_dbstring(l_azp03 CLIPPED),"ogb_file, ",   
#                    #"      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",  
#                    # " FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file, ",  #FUN-980094 GP5.2 mod
#                    # "      ",s_dbstring(g_dbs_tra CLIPPED),"ogb_file, ",  #FUN-980094 GP5.2 mod
#                    # "      ",s_dbstring(g_dbs_tra CLIPPED),"oeb_file ",   #FUN-980094 GP5.2 mod
#                    " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
#                             cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
#                             cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
##TQC-950028   ---end    
#                     "  WHERE ogb31 ='",l_oea01,"'",
#                     "    AND oga01 = ogb01 ",
#                     "    AND ogaconf='Y' ",
#                     "    AND ogapost='Y' ",
##                    "    AND oga09 MATCHES '[2348]' ",       #CHI-8C0028 Mark
#                     "    AND oga09 IN ('2','3','4','6','8') ",      #CHI-8C0028
#                     "    AND ogb31 = oeb01 ",   #MOD-8B0078
#                     "    AND ogb32 = oeb03 ",   #MOD-8B0078
#                     "    AND oeb70 = 'N' ",     #MOD-8B0078
#                     "    GROUP BY oga23,oga24 "
# 
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
#         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
# 
#         PREPARE t66_pab_pre FROM l_sql
#         DECLARE t66_pab_cur CURSOR FOR t66_pab_pre
#CHI-AC0030 mark --end--
         LET pab_tot = 0 
        #FOREACH t66_pab_cur INTO g_curr,l_oga24,pab_amt #CHI-AC0030 mark
         FOREACH t66_pab_cur USING l_oea01 INTO g_curr,l_oga24,pab_amt #CHI-AC0030
            IF l_occ631=g_curr THEN
               LET l_tmp = pab_amt
            ELSE
               IF l_oaz211 = '1' THEN
                  LET l_tmp = pab_amt*l_oga24
               ELSE
#                 LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03)  #FUN-980020 mark 
                  LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01)  #FUN-980020
                  LET l_tmp = pab_amt * g_exrate
               END IF
               IF l_occ631 <> l_aza17 THEN
#                 LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-980020 mark 
                  LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
                  LET l_tmp = l_tmp*g_exrate  
               END IF
            END IF
            LET l_tmp= l_tmp * g_ocg.ocg09/100   
            LET pab_tot = pab_tot + l_tmp
         END FOREACH
#CHI-AC0030 mark --start--
#         LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
##TQC-950028   --start 
#                    #" FROM ",l_azp03 CLIPPED,".dbo.oga_file, ",
#                    #"      ",l_azp03 CLIPPED,".dbo.ogb_file, ",
#                    #"      ",l_azp03 CLIPPED,".dbo.oeb_file ",   #MOD-8B0078
#                    #" FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file, ", 
#                    #"      ",s_dbstring(l_azp03 CLIPPED),"ogb_file, ", 
#                    #"      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",    
#                    # " FROM ",s_dbstring(g_dbs_tra CLIPPED),"oga_file, ",  #FUN-980094 GP5.2 mod
#                    # "      ",s_dbstring(g_dbs_tra CLIPPED),"ogb_file, ",  #FUN-980094 GP5.2 mod
#                    # "      ",s_dbstring(g_dbs_tra CLIPPED),"oeb_file ",   #FUN-980094 GP5.2 mod
#                    " FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
#                             cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
#                             cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
##TQC-950028   ---end   
#                     "  WHERE ogb31 ='",l_oea01,"'",
#                     "    AND oga01 = ogb01 ",
#                     "    AND oga09 IN ('1','5') ",
#                     "    AND ogb31 = oeb01 ",   #MOD-8B0078
#                     "    AND ogb32 = oeb03 ",   #MOD-8B0078
#                     "    AND oeb70 = 'N' "      #MOD-8B0078
#         IF cl_null(p_slip) THEN
#            LET l_sql = l_sql CLIPPED,
#                        " AND oga55 IN ('1','S') ",    
#                        " GROUP BY oga23,oga24 "
#         ELSE
#            LET l_sql = l_sql CLIPPED,
#                        " AND ( oga55 IN ('1','S') ",  
#                        "     OR oga01 = '",p_slip,"' ) ",
#                        " GROUP BY oga23,oga24 "
#         END IF
# 
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
#         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
# 
#         PREPARE t66_ifb_pre FROM l_sql
#         DECLARE t66_ifb_cur CURSOR FOR t66_ifb_pre
#CHI-AC0030 mark --end--
         LET ifb_tot = 0 
        #FOREACH t66_ifb_cur INTO g_curr,l_oga24,ifb_amt #CHI-AC0030 mark
         FOREACH t66_ifb_cur USING l_oea01 INTO g_curr,l_oga24,ifb_amt #CHI-AC0030
            IF l_occ631=g_curr THEN
               LET l_tmp = ifb_amt
            ELSE
               IF l_oaz211 = '1' THEN
                  LET l_tmp = ifb_amt*l_oga24
               ELSE
#                 LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-980020 mark 
                  LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
                  LET l_tmp = ifb_amt * g_exrate
               END IF
               IF l_occ631 <> l_aza17 THEN
#                 LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-980020 mark
                  LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
                  LET l_tmp = l_tmp*g_exrate  
               END IF
            END IF
            LET l_tmp= l_tmp * g_ocg.ocg09/100   
            LET ifb_tot = ifb_tot + l_tmp
         END FOREACH
         LET l_amt = ifb_tot - pab_tot   #出貨通知單金額-已出貨金額
         IF l_amt <= 0 THEN CONTINUE FOREACH END IF
        LET l_amt = cl_digcut(l_amt,t_azi04) #No.CHI-910034
        LET l_t66=l_t66+l_amt
       END FOREACH
       #-----END CHI-8A0011-----
    END FOR
    RETURN l_t66
END FUNCTION
 
#-(10)-----------------------------------#
# 多工廠應收逾期帳計算 by ERIC 98-06-24 #
#---------------------------------------#
FUNCTION s_ccc_cal_t65(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          l_t65,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oma01     LIKE oma_file.oma01,
          l_oob09_1   LIKE oob_file.oob09,
          l_oob10_1   LIKE oob_file.oob10,
          l_oob09_2   LIKE oob_file.oob09,
          l_oob10_2   LIKE oob_file.oob10,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING 
          l_sql1      STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE        #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_today     LIKE type_file.dat,          #No.FUN-680147 DATE
          l_oob06     LIKE oob_file.oob06,
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
          l_oma11     LIKE oma_file.oma11,
         #l_plant     ARRAY[4] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)   #No.FUN-630086
   DEFINE l_omc01     LIKE omc_file.omc01         #No.FUN-680022 add
   DEFINE l_omc08_tot LIKE omc_file.omc08         #No.FUN-680022 add
   DEFINE l_omc09_tot LIKE omc_file.omc09         #No.FUN-680022 add
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t65_aza17 FROM l_sql
    DECLARE t65_aza17_cs CURSOR FOR t65_aza17
    FOREACH t65_aza17_cs INTO g_aza17 END FOREACH
  END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t65_occ631 FROM l_sql
    DECLARE t65_occ631_cs CURSOR FOR t65_occ631
    FOREACH t65_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t65_ocg FROM l_sql
    DECLARE t65_ocg_cs CURSOR FOR t65_ocg
    FOREACH t65_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg75    LET l_plant[2]=g_ocg.ocg76
   #LET l_plant[3]=g_ocg.ocg77    LET l_plant[4]=g_ocg.ocg78
 
#TQC-AC0345 --begin--
   IF g_flag = 'N' THEN
     LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 10"
   ELSE
     LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 10"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
   END IF
#TQC-AC0345 --end--
    PREPARE t65_poch FROM l_sql
    DECLARE t65_och CURSOR FOR t65_poch
 
    LET l_j = 1
 
    FOREACH t65_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t65_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

 #TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t65_azp03 FROM l_sql
    DECLARE t65_azp03_cs CURSOR FOR t65_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t65=0
    LET l_today=TODAY-l_occ36
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
    
#TQC-AC0345 --begin--
       IF g_flag = 'N' THEN
          SELECT azp03 INTO l_azp03           # DATABASE ID
          FROM azp_file WHERE azp01=l_plant[l_i]
       ELSE
          FOREACH t65_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
       END IF
#TQC-AC0345 --end--
    
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file",#TQC-950028
                  "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102       
        PREPARE aza_t65_pre FROM l_sql
        DECLARE aza_t65_cur CURSOR FOR aza_t65_pre
        OPEN aza_t65_cur 
        FETCH aza_t65_cur INTO l_aza17
        CLOSE aza_t65_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028 
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                  "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102         
        PREPARE oaz_t65_pre FROM l_sql
        DECLARE oaz_t65_cur CURSOR FOR oaz_t65_pre
        OPEN oaz_t65_cur
        FETCH oaz_t65_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
       #應收已沖帳未確認金額
      #No.FUN-680022--begin-- mark
      #LET l_sql1=" SELECT SUM(oob09),SUM(oob10) ",
      #           " FROM ",l_azp03 CLIPPED,".dbo.oob_file,",
      #                   l_azp03 CLIPPED,".dbo.ooa_file,",
      #                   l_azp03 CLIPPED,".dbo.oma_file",
      #          " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
      #          " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 ",
      #          " AND oob09>0",
      #          " AND oma01 = oob06",
      #          " AND oma01 = ? "
      #No.FUN-680022--end-- mark
      #No.FUN-680022--begin-- add
       #--------------------------該解釋已不合適------------------不衝至單身已衝帳未確認金額     #No.MOD-840102 注釋
       #No.MOD-840102--取已立衝賬但未審核的合計金額。
       LET l_sql1=" SELECT SUM(oob09),SUM(oob10) ",
#TQC-950028   ---start      
                #" FROM ",l_azp03 CLIPPED,".dbo.oob_file,",
                #         l_azp03 CLIPPED,".dbo.ooa_file,",
                #         l_azp03 CLIPPED,".dbo.oma_file,",   #FUN-710080 modify 少了一個,
                #         l_azp03 CLIPPED,".dbo.omc_file",
                # " FROM ",s_dbstring(l_azp03 CLIPPED),"oob_file,", 
                #          s_dbstring(l_azp03 CLIPPED),"ooa_file,", 
                #          s_dbstring(l_azp03 CLIPPED),"oma_file,", 
                #          s_dbstring(l_azp03 CLIPPED),"omc_file",
                 " FROM ",cl_get_target_table(l_plant[l_i],'oob_file'),",", #FUN-A50102 
                          cl_get_target_table(l_plant[l_i],'ooa_file'),",", #FUN-A50102 
                          cl_get_target_table(l_plant[l_i],'oma_file'),",", #FUN-A50102  
                          cl_get_target_table(l_plant[l_i],'omc_file'),     #FUN-A50102    
#TQC-950028   ---end     
                 " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,  #No.MOD-970082 mark	#CHI-980048 remark
                #" WHERE ooa03='",p_occ01,"' AND ooaconf='Y' " ,  #No.MOD-970082 mod	#CHI-980048 mark
                 " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 ",
                 " AND oob09>0",
                 " AND oma01 = oob06",
                 " AND oma01 = omc01 AND oob19=omc02 AND omc04<'",l_today,"'",   #FUN-710080 modify 少了一個"'"
                 " AND oma01 = ? "
      #No.FUN-680022--end-- add
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102         
       PREPARE t65_pre2 FROM l_sql1
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre2 t65',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t65_curs2 CURSOR FOR t65_pre2
     #NO.MOD-840102--begin-- mark
     #MARK理由：不必區分是否衝賬至單身。
     ##No.FUN-680022--begin-- add
     ##衝帳至單身已衝帳未確認金額
     # LET l_sql1=" SELECT SUM(oob09),SUM(oob10) ",
     #            " FROM ",l_azp03 CLIPPED,".dbo.oob_file,",
     #                     l_azp03 CLIPPED,".dbo.ooa_file,",
     #                     l_azp03 CLIPPED,".dbo.oma_file,",   #FUN-710080 modify 少了一個,
     #                     l_azp03 CLIPPED,".dbo.omb_file,",
     #                     l_azp03 CLIPPED,".dbo.omc_file",   #MOD-7A0064
     #           " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
     #           " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 ",
     #           " AND oob09>0",
     #           " AND oma01 = oob06 AND omc04<'",l_today,"'",   #FUN-710080 modify 少了一個"'"
     #           " AND oma01 = omb01 AND oob15=omb03 AND (oob15 IS NOT NULL) ",
     #           " AND oma01 = omc01 AND oob19 = omc02 ",   #MOD-7A0064
     #           " AND oma01 = ? "
     # PREPARE t65_pre3 FROM l_sql1
     # IF SQLCA.SQLCODE <> 0 THEN
     #    CALL cl_err('pre3 t65',SQLCA.SQLCODE,1)
     # END IF   
     # DECLARE t65_curs3 CURSOR FOR t65_pre3
     ##No.FUN-680022--end-- add
     #No.MOD-840102---end--- mark
 
    ###No.FUN-680022--begin-- mark
    #############################################################################
    ## #No.TQC-5C0086  --Begin                                                                                                      
    ## IF g_ooz.ooz07 = 'N' THEN
    ##    LET l_sql=" SELECT oma01,oma54t-oma55,oma56t-oma57,oma23,oma11 ",
#   ##    LET l_sql=" SELECT oma01,oma54t-oma55,oma61,oma23,oma11 ",    #A060
    ##              "  FROM ",l_azp03 CLIPPED,".dbo.oma_file",
    ##              " WHERE oma03='",p_occ01,"'",
    ##              "  AND oma11 <'",l_today,"' ",
    ##              "  AND oma54t>oma55",
    ##              " AND omaconf='Y' AND oma00 LIKE '1%'"
    ## ELSE                                                                                                                         
    ##    LET l_sql=" SELECT oma01,oma54t-oma55,oma61,oma23,oma11 ",                                                                
    ##              "  FROM ",l_azp03 CLIPPED,".dbo.oma_file",                                                                          
    ##              " WHERE oma03='",p_occ01,"'",                                                                                   
    ##              "  AND oma11 <'",l_today,"' ",                                                                                  
    ##              "  AND oma54t>oma55",                                                                                           
    ##              " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
    ## END IF                                                                                                                       
    ## #No.TQC-5C0086  --End
    ## #FUN-630043
    ##  IF g_aza.aza52='Y' THEN
    ##     LET l_sql=l_sql CLIPPED," AND oma66='",l_plant[l_i],"' "
    ##  END IF
    ## #END FUN-630043
    ## PREPARE t65_pre FROM l_sql
    ## IF SQLCA.SQLCODE <> 0 THEN
    ##    CALL cl_err('pre t65',SQLCA.SQLCODE,1)
    ## END IF   
    ## DECLARE t65_curs CURSOR FOR t65_pre
    ## FOREACH t65_curs INTO l_oma01,l_amt,ntd_amt,g_curr,l_date
    ##   LET l_no=l_oma01
    ##   IF l_amt IS NULL THEN LET l_amt = 0 END IF 
    ##   IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
    ##   #需扣除已沖帳未確認金額
    ##   LET l_oob09=0  LET l_oob10=0
    ##   OPEN t65_curs2 USING l_oma01
    ##   IF SQLCA.SQLCODE THEN
    ##      LET l_oob09=0  LET l_oob10=0
    ##   END IF
    ##   FETCH t65_curs2 INTO l_oob09,l_oob10
    ##   IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
    ##   IF cl_null(l_oob10) THEN LET l_oob10=0 END IF
    ##   LET l_amt=l_amt-l_oob09
    ##   LET ntd_amt=ntd_amt-l_oob10
    ##   IF l_occ631=g_curr THEN
    ##      LET l_tmp = l_amt
    ##   ELSE
    ##      IF g_oaz.oaz211 = '1' THEN
    ##         LET l_tmp = ntd_amt
    ##      ELSE
    ##         LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
    ##         LET l_tmp = l_amt * g_exrate
    ##      END IF
    ##      IF l_occ631 <> g_aza17 THEN
    ##         LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
    ##         LET l_tmp = l_tmp*g_exrate  
    ##      END IF
    ##  END IF
    ##  LET l_t65=l_t65+l_tmp
    ## END FOREACH
    #################################################################################
    ##No.FUN-680022--end-- mark
      #No.FUN-680022--begin-- add
       IF g_ooz.ooz07 = 'N' THEN						#CHI-980048		   
         #LET l_sql=" SELECT omc01,SUM(omc08),SUM(omc09),oma23 ",		#CHI-980048 mark
          LET l_sql=" SELECT omc01,SUM(omc08-omc10),SUM(omc09-omc11),oma23 ",	#CHI-980048
#TQC-950028   ---start 
                   #" FROM ",l_azp03 CLIPPED,".dbo.oma_file,",   #FUN-710080 modify 少了一個,
                   #         l_azp03 CLIPPED,".dbo.omc_file",
                   # " FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file,",  
                   #          s_dbstring(l_azp03 CLIPPED),"omc_file",
                   " FROM ",cl_get_target_table(l_plant[l_i],'oma_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant[l_i],'omc_file'),     #FUN-A50102
#TQC-950028   ---end  
                    " WHERE oma03='",p_occ01,"'",
                    "   AND omc04<'",l_today,"'",
                   #"   AND omc01=oma01 AND omc08>omc09 ",   #No.MOD-840102 mark
                    "   AND omc01=oma01 AND omc08>omc10 ",   #No.MOD-840102
                    "   AND omaconf='Y' AND oma00 LIKE '1%'" 
                   #" GROUP BY omc01,oma23 "   #MOD-7A0064			#CHI-980048 mark	
      #-CHI-980048-add-
       ELSE
          LET l_sql=" SELECT omc01,SUM(omc08-omc10),SUM(omc13),oma23 ",	
                    #" FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file,",                                                
                    #         s_dbstring(l_azp03 CLIPPED),"omc_file",
                    " FROM ",cl_get_target_table(l_plant[l_i],'oma_file'),",", #FUN-A50102
                             cl_get_target_table(l_plant[l_i],'omc_file'),     #FUN-A50102      
                    " WHERE oma03='",p_occ01,"'",
                    "   AND omc04<'",l_today,"'",
                    "   AND omc01=oma01 AND omc08>omc10 ",   
                    "   AND omaconf='Y' AND oma00 LIKE '1%'" 
       END IF
      #-CHI-980048-end-
        IF g_aza.aza52='Y' THEN
           LET l_sql=l_sql CLIPPED," AND oma66='",l_plant[l_i],"' "
        END IF       
       LET l_sql = l_sql CLIPPED," GROUP BY omc01,oma23 "	#CHI-980048
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102        
       PREPARE t65_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t65',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t65_curs CURSOR FOR t65_pre
       FOREACH t65_curs INTO l_omc01,l_omc08_tot,l_omc09_tot,g_curr
         LET l_no=l_oma01
         IF l_omc09_tot IS NULL THEN LET l_omc09_tot=0 END IF
         #需扣除已沖帳未確認金額
         LET l_oob09_1=0  LET l_oob10_1=0
         OPEN t65_curs2 USING l_omc01
         FETCH t65_curs2 INTO l_oob09_1,l_oob10_1      #No.MOD-840102 modify l_oob10_2 -> l_oob10_1
         IF SQLCA.SQLCODE THEN
            LET l_oob09_1=0  LET l_oob10_1=0
         END IF
         IF cl_null(l_oob09_1) THEN LET l_oob09_1=0 END IF
         IF cl_null(l_oob10_1) THEN LET l_oob10_1=0 END IF
        #No.MOD-840102--begin-- modify
        #LET   l_amt=l_omc08_tot-l_oob09_1-l_oob09_2
        #LET ntd_amt=l_omc09_tot-l_oob10_1-l_oob10_2
         LET   l_amt=l_omc08_tot-l_oob09_1
         LET ntd_amt=l_omc09_tot-l_oob10_1
        #No.MOD-840102---end--- modify
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp=ntd_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       # END IF
         #FUN-640215--add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020 
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
         #FUN-640215--add---
         LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
         LET l_t65=l_t65+l_tmp                 
       END FOREACH
      #No.FUN-680022--end-- add
    END FOR
    RETURN l_t65
END FUNCTION
 
#-(11)(C)--------------------------------#
# 多工廠逾期未兌現應收票據計算 010404 add#
#----------------------------------------#
FUNCTION s_ccc_cal_t70(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          l_t70,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE     #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_today     LIKE type_file.dat,          #No.FUN-680147 DATE
          l_oob06     LIKE oob_file.oob06,
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
          l_oma11     LIKE oma_file.oma11,
         #l_plant     ARRAY[4] OF VARCHAR(10)       # 工廠編號
          l_j         LIKE type_file.num5,     #No.FUN-630086  #No.FUN-680147 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01       #No.FUN-680147 VARCHAR(10)   #No.FUN-630086
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t70_aza17 FROM l_sql
    DECLARE t70_aza17_cs CURSOR FOR t70_aza17
    FOREACH t70_aza17_cs INTO g_aza17 END FOREACH
 END IF
#TQC-AC0345 --end--
    IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t70_occ631 FROM l_sql
    DECLARE t70_occ631_cs CURSOR FOR t70_occ631
    FOREACH t70_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
   #-----No.FUN-630086-----
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
    SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t70_ocg FROM l_sql
    DECLARE t70_ocg_cs CURSOR FOR t70_ocg
    FOREACH t70_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
   #LET l_plant[1]=g_ocg.ocg85    LET l_plant[2]=g_ocg.ocg86
   #LET l_plant[3]=g_ocg.ocg87    LET l_plant[4]=g_ocg.ocg88
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 11"
  ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 11"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF
 #TQC-AC0345 --end--
    PREPARE t70_poch FROM l_sql
    DECLARE t70_och CURSOR FOR t70_poch
 
    LET l_j = 1
 
    FOREACH t70_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t70_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
   #-----No.FUN-630086 END-----

#TQC-AC0345 --begin--
  IF g_flag = 'Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t70_azp03 FROM l_sql
    DECLARE t70_azp03_cs CURSOR FOR t70_azp03
  END IF
#TQC-AC0345 --end--
    
    LET l_t70=0
    LET l_today=TODAY-l_occ36
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       LET l_azp01 = l_plant[l_i]          #FUN-980020
     
#TQC-AC0345 --begin--
      IF g_flag = 'N' THEN
        SELECT azp03 INTO l_azp03           # DATABASE ID
         FROM azp_file WHERE azp01=l_plant[l_i]
      ELSE
        FOREACH t70_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
      END IF
#TQC-AC0345 --end--
     
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028
                  # "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                    "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102   
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102        
        PREPARE aza_t70_pre FROM l_sql
        DECLARE aza_t70_cur CURSOR FOR aza_t70_pre
        OPEN aza_t70_cur 
        FETCH aza_t70_cur INTO l_aza17
        CLOSE aza_t70_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028
                  # "SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102        
        PREPARE oaz_t70_pre FROM l_sql
        DECLARE oaz_t70_cur CURSOR FOR oaz_t70_pre
        OPEN oaz_t70_cur
        FETCH oaz_t70_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
 
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh05 ",
                #"   FROM ",l_azp03 CLIPPED,".dbo.nmh_file", #TQC-950028 
                 #"   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file",#TQC-950028
                 "   FROM ",cl_get_target_table(l_plant[l_i],'nmh_file'), #FUN-A50102      
                 " WHERE nmh11='", p_occ01,"'",
#                "   AND nmh24 MATCHES '[1234]'",                                                      #FUN-870084 
                 "   AND (nmh24 IN ('1','2','3') OR (nmh24 IN ('4') AND nmh05 >= '",g_today,"'))",   #FUN-870084 #MOD-8B0191
                 "   AND nmh05 < '",l_today,"' ",
                 "   AND nmh38 ='Y' "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102        
       PREPARE t70_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t70',SQLCA.SQLCODE,1)
       END IF   
       DECLARE t70_curs CURSOR FOR t70_pre
       FOREACH t70_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF 
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = l_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = ntd_amt
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = l_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       #END IF
         #FUN-640215 add---
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215  #FUN-980020 mark
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020 
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
         #FUN-640215 add---
        LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
        LET l_t70=l_t70+l_tmp
       END FOREACH
    END FOR
    RETURN l_t70
END FUNCTION
 
FUNCTION s_ccc_logerr()   #FUN-650020
   LET g_showmsg=''
   LET gi_ccc_logerr = TRUE
END FUNCTION
 
#-----No.FUN-740016-----
#-(D)--Borrow --------------------------#
# 借貨金額 By Nicola 07-05-08           #
#---------------------------------------#
FUNCTION s_ccc_cal_t67(p_occ01,p_slip,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_slip      LIKE oga_file.oga01,     #No.FUN-680147 VARCHAR(16)
          p_occ61     LIKE occ_file.occ61,
          l_t67,l_tmp LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,          #No.FUN-680147 DATE   #日期
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,    #No.FUN-680147 SMALLINT
          l_sql       STRING,   #TQC-8C0071 VARCHAR(1000)-->STRING
          l_azp01     LIKE azp_file.azp01,
          l_azp03     LIKE azp_file.azp03,
          l_j         LIKE type_file.num5,
          l_plant     DYNAMIC ARRAY OF LIKE azp_file.azp01
 
#TQC-B10018 --begin--
   IF cl_null(g_flag) THEN
      LET g_flag = 'N'
   END IF
#TQC-B10018 --end--

#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
  ELSE
    LET l_sql = "SELECT aza17 FROM ",g_azp03 CLIPPED,".aza_file",
                " WHERE aza01 = '0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t67_aza17 FROM l_sql
    DECLARE t67_aza17_cs CURSOR FOR t67_aza17
    FOREACH t67_aza17_cs INTO g_aza17 END FOREACH
  END IF
#TQC-AC0345 --end--
   IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
  ELSE
    LET l_sql = "SELECT occ631 FROM ",g_azp03 CLIPPED,".occ_file",
                " WHERE occ01 = '",p_occ01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t67_occ631 FROM l_sql
    DECLARE t67_occ631_cs CURSOR FOR t67_occ631
    FOREACH t67_occ631_cs INTO l_occ631 END FOREACH
  END IF
#TQC-AC0345 --end--
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = p_occ61 #NO:FUN-640328
  ELSE
    LET l_sql = "SELECT * FROM ",g_azp03 CLIPPED,".ocg_file",
                " WHERE ocg01 = '",p_occ61,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t67_ocg FROM l_sql
    DECLARE t67_ocg_cs CURSOR FOR t67_ocg
    FOREACH t67_ocg_cs INTO g_ocg.* END FOREACH
  END IF
#TQC-AC0345 --end--
 
#TQC-AC0345 --begin--
  IF g_flag = 'N' THEN
     LET l_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",p_occ61,"'",
               "   AND och02 = 9"
  ELSE
    LET l_sql = "SELECT och03 FROM ",g_azp03 CLIPPED,".och_file",
               " WHERE och01 ='",p_occ61,"'",
               "   AND och02 = 9"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
  END IF
#TQC-AC0345 --end--
   PREPARE t67_poch FROM l_sql
   DECLARE t67_och CURSOR FOR t64_poch
 
   LET l_j = 1
 
   FOREACH t67_och INTO l_plant[l_j]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t67_och:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_j = l_j +1
 
   END FOREACH
 
   LET l_j = l_j - 1

#TQC-AC0345 --begin--
  IF g_flag ='Y' THEN
    LET l_sql = "SELECT azp03 FROM ",g_azp03 CLIPPED,".azp_file",
                " WHERE azp01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #MOD-B70001 add
    PREPARE t67_azp03 FROM l_sql
    DECLARE t67_azp03_cs CURSOR FOR t67_azp03
  END IF
#TQC-AC0345 --end--
   
   LET l_t67=0
   FOR l_i = 1 TO l_j
      IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
      LET l_azp01 = l_plant[l_i]          #FUN-980020
   
#TQC-AC0345 --begin--
       IF g_flag ='N' THEN
         SELECT azp03 INTO l_azp03           # DATABASE ID
         FROM azp_file WHERE azp01=l_plant[l_i]
       ELSE
         FOREACH t67_azp03_cs USING l_plant[l_i] INTO l_azp03 END FOREACH
       END IF
#TQC-AC0345 --end-
 
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(S) 
        LET g_plant_new = l_azp01
        CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
        #FUN-980094 依l_azp01的PLANT變數取得TRANS DB ----------(E) 
 
        #----add---#FUN-640215
        LET l_sql =
                  #"SELECT aza17 FROM ",l_azp03 CLIPPED,".aza_file", #TQC-950028 
                  # "SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #TQC-950028
                    "SELECT aza17 FROM ",cl_get_target_table(l_plant[l_i],'aza_file'), #FUN-A50102  
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102          
        PREPARE aza_t67_pre FROM l_sql
        DECLARE aza_t67_cur CURSOR FOR aza_t67_pre
        OPEN aza_t67_cur 
        FETCH aza_t67_cur INTO l_aza17
        CLOSE aza_t67_cur
       
        LET l_sql =
                  #"SELECT oaz211,oaz212 FROM ",l_azp03 CLIPPED,".oaz_file", #TQC-950028  
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",#TQC-950028
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(l_plant[l_i],'oaz_file'), #FUN-A50102  
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add 
        CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql #FUN-A50102         
        PREPARE oaz_t67_pre FROM l_sql
        DECLARE oaz_t67_cur CURSOR FOR oaz_t67_pre
        OPEN oaz_t67_cur
        FETCH oaz_t67_cur INTO l_oaz211,l_oaz212
        #----end---#FUN-640215
 
      #借貨量為實際借貨量-已還數量-償價數量
      LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,",
                "        SUM((oeb12-oeb25-oeb29)*oeb13) ",
#TQC-950028   ---start  
               #" FROM ",l_azp03 CLIPPED,".dbo.oea_file, ",
               #"      ",l_azp03 CLIPPED,".dbo.oeb_file ",
               #" FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file, ", 
               #"      ",s_dbstring(l_azp03 CLIPPED),"oeb_file ",  
               # " FROM ",s_dbstring(g_dbs_tra CLIPPED),"oea_file, ", #FUN-980094 GP5.2 mod
               # "      ",s_dbstring(g_dbs_tra CLIPPED),"oeb_file ",    #FUN-980094 GP5.2 mod
               " FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                        cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
#TQC-950028   ---end    
                " WHERE oea03='",p_occ01,"' ",
                " AND oea01=oeb01 ",
         #      " AND oeb12 > oeb24 ",
                " AND oea00 = '8'" ,
                " AND oeb70='N' ",
                " AND oea49 IN ('1','S') ",
                " GROUP BY oea01,oea02,oea23,oea24,oea211 "
 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #MOD-9C0316 add        
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
 
      PREPARE t67_pre FROM l_sql
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err('pre t67',SQLCA.SQLCODE,1)
      END IF   
 
      DECLARE t67_curs CURSOR FOR t67_pre
 
      FOREACH t67_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211,
                            pab_amt
         LET l_no=l_oea01
         IF pab_amt IS NULL THEN LET pab_amt = 0 END IF 
         LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
 
       #FUN-640215 mark改成下段
       # IF l_occ631=g_curr THEN
       #    LET l_tmp = pab_amt
       # ELSE
       #    IF g_oaz.oaz211 = '1' THEN
       #       LET l_tmp = pab_amt*l_oea24
       #    ELSE
       #       LET g_exrate=s_exrate(g_curr,g_aza17,g_oaz.oaz212)
       #       LET l_tmp = pab_amt * g_exrate
       #    END IF
       #    IF l_occ631 <> g_aza17 THEN
       #       LET g_exrate=s_exrate(g_aza17,l_occ631,g_oaz.oaz212)
       #       LET l_tmp = l_tmp*g_exrate  
       #    END IF
       # END IF
         #FUN-640215 ----add----------
         IF l_occ631=g_curr THEN
            LET l_tmp = pab_amt
         ELSE
            IF g_oaz.oaz211 = '1' THEN
               LET l_tmp = pab_amt*l_oea24
            ELSE
#              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = pab_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
#              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp03) #FUN-640215 #FUN-980020 mark 
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_azp01) #FUN-980020
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
         #FUN-640215 ----end----------
         LET l_tmp= l_tmp * g_ocg.ocg10/100
         LET l_tmp = cl_digcut(l_tmp,t_azi04) #No.CHI-910034
         LET l_t67=l_t67+l_tmp
      END FOREACH
 
   END FOR
 
   RETURN l_t67
 
END FUNCTION
#-----No.FUN-740016 END-----
#MOD-9C0317
