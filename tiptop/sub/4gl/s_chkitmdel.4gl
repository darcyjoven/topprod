# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: s_chkitmdel.4gl
# Descriptions...: 檢查料號是否已經被使用,由aimi100的i100_del()移過來
# Modify.........: No.FUN-560112 05/06/18 By kim 新增料件時,無法更改庫存單位
# Modify.........: No.FUN-5B0101 05/12/07 By Sarah 刪除時,須增加考慮以下資料,較為完整:
#                                                  1.已存在料件承認資料不可刪除
#                                                  2.已存在料件/供應商資料不可刪除
#                                                  3.已存在核價資料不可刪除
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-760116 07/08/08 By pengu 若有img資料若有則不允許修改庫存單位(ima25)
# Modify.........: No.MOD-790068 07/09/17 By Pengu CREATE TEMP TABLE時應先建INDEX在INSERT資料有製程資料時不允許刪除料件資料
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.CHI-980019 09/11/05 By jan 新增判斷料件是否為虛擬料的function
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.MOD-C50234 12/05/29 By suncx 新增檢查tlf_file是否存在料件資料
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_chkitmdel(p_itmno)
  DEFINE l_n       LIKE type_file.num5        #No.FUN-680147 SMALLINT
  DEFINE p_itmno   LIKE ima_file.ima01
 ###FUN-A20044-----BEGIN
#  DEFINE l_ima26   LIKE ima_file.ima26
 # DEFINE l_ima261  LIKE ima_file.ima261
 # DEFINE l_ima262  LIKE ima_file.ima262
  DEFINE l_errno   STRING
 ###FUN-A20044-----END
  DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044
  #No.B013 010322 by plum check 後端資料只要有存在就不允許刪除
  LET l_errno = ' '
  #FUN-560112................begin
  IF cl_null(p_itmno) THEN
     RETURN l_errno
  END IF
  SELECT COUNT(*) INTO l_n FROM ima_file
     WHERE ima01=p_itmno
  IF l_n=0 THEN
     RETURN l_errno
  END IF
  #FUN-560112................end
 # SELECT ima26,ima261,ima262 INTO l_ima26,l_ima261,l_ima262 FROM
 # ima_file WHERE ima01=p_itmno    #FUN-A20044
  CALL s_getstock(p_itmno,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
  IF SQLCA.sqlcode THEN
    LET l_errno=SQLCA.sqlcode
 #   LET l_ima26=0
  #  LET l_ima261=0
   # LET l_ima262=0     #FUN-A20044
    LET l_avl_stk_mpsmrp = 0   #FUN-A20044
    LET l_unavl_stk =0  #FUN-A20044
    LET l_avl_stk = 0   #FUN-A20044
  END IF
 #IF l_ima26  >0 THEN LET l_errno='mfg9161' RETURN l_errno END IF
 #IF l_ima261 >0 THEN LET l_errno='mfg9162' RETURN l_errno END IF
 #IF l_ima262 >0 THEN LET l_errno='mfg9163' RETURN l_errno END IF  #FUN-A20044
IF l_avl_stk_mpsmrp  >0 THEN LET l_errno='mfg9161' RETURN l_errno END IF  #FUN-A20044
IF l_unavl_stk >0 THEN LET l_errno='mfg9162' RETURN l_errno END IF #FUN-A20044
IF l_avl_stk >0 THEN LET l_errno='mfg9163' RETURN l_errno END IF  #FUN-A20044

#start FUN-5B0101
 #只要有料件承認資料,不可刪除
 SELECT COUNT(*) INTO l_n FROM bmj_file
  WHERE bmj01 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9188' RETURN l_errno END IF
 #只要有料件/供應商資料,不可刪除
 SELECT COUNT(*) INTO l_n FROM pmh_file
  WHERE pmh01 = p_itmno
    AND pmhacti = 'Y'                                           #CHI-910021
 IF l_n > 0 THEN LET l_errno='mfg9189' RETURN l_errno END IF
 #只要有核價單,不可刪除
 SELECT COUNT(*) INTO l_n FROM pmj_file
  WHERE pmj03 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9190' RETURN l_errno END IF
#end FUN-5B0101
 #--->產品結構(bma_file,bmb_file)須有效BOM 
 SELECT COUNT(*) INTO l_n FROM bma_file
  WHERE bma01 = p_itmno 
 IF l_n > 0 THEN LET l_errno='mfg9191' RETURN l_errno END IF
 SELECT COUNT(*) INTO l_n FROM bmb_file
  WHERE bmb03 = p_itmno 
#   AND (bmb05 >= MDY(12,31,9999) OR bmb05 IS NULL)
    AND (bmb04<=g_today OR bmb04 IS NULL) #BugNo:6039
    AND (bmb05> g_today OR bmb05 IS NULL)
 IF l_n > 0 THEN LET l_errno='mfg9191' RETURN l_errno END IF
 #--->取替代(bmd_file)
 SELECT COUNT(*) INTO l_n FROM bmd_file
  WHERE bmd04 = p_itmno
    AND bmdacti = 'Y'                                           #CHI-910021
 IF l_n >0 THEN LET l_errno='mfg9191' RETURN l_errno END IF
 #--->請購單 (pml_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM pml_file
  WHERE pml04 = p_itmno 
 IF l_n > 0 THEN LET l_errno='mfg9194' RETURN l_errno END IF
 #--->採購單 (pmn_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM pmn_file
  WHERE pmn04 = p_itmno  
 #  AND pmn16 MATCHES "[X012]"     
 IF l_n > 0 THEN LET l_errno='mfg9192' RETURN l_errno END IF
 #--->收貨(rvv_file)
 SELECT COUNT(*) INTO l_n FROM rvv_file
 WHERE rvv31 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9192' RETURN l_errno END IF
 #--->工單料件 (sfa_file,sfb_file)，必須尚未結案 -> 只要有存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM sfa_file,sfb_file
  WHERE sfa01=sfb01 AND sfa03 = p_itmno 
#   AND sfb04 != '8'
 IF l_n > 0 THEN LET l_errno='mfg9193' RETURN l_errno END IF
 SELECT COUNT(*) INTO l_n FROM sfb_file
  WHERE sfb05 = p_itmno 
#   AND sfb04 != '8'
 IF l_n > 0 THEN LET l_errno='mfg9193' RETURN l_errno END IF
 #---> 訂單(oeb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM oeb_file
  WHERE oeb04 = p_itmno 
 IF l_n > 0 THEN LET l_errno='mfg9195' RETURN l_errno END IF
 #---> 出貨單(ogb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM ogb_file
  WHERE ogb04 = p_itmno 
 IF l_n > 0 THEN LET l_errno='mfg9196' RETURN l_errno END IF
 #---> 銷退(ohb_file)
 SELECT COUNT(*) INTO l_n FROM ohb_file
  WHERE ohb04 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9196' RETURN l_errno END IF
 #---> 庫存異動單(inb_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM inb_file
  WHERE inb04 = p_itmno 
 IF l_n > 0 THEN LET l_errno='mfg9197' RETURN l_errno END IF
 #---> 調撥單(imn_file),只要存在就不允許刪除
 SELECT COUNT(*) INTO l_n FROM imn_file
  WHERE imn03 = p_itmno 
 IF l_n > 0 THEN LET l_errno='mfg9198' RETURN l_errno END IF
#No.B013 010322 by plum
#------No.MOD-760116 add
 SELECT COUNT(*) INTO l_n FROM img_file 
  WHERE img01 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9199' RETURN l_errno END IF
#------No.MOD-760116 end
 
#-------No.MOD-790068 add
 #只要有料件承認資料,不可刪除
 SELECT COUNT(*) INTO l_n FROM ecu_file
  WHERE ecu01 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9200' RETURN l_errno END IF
#-------No.MOD-790068 end
#MOD-C50234 add begin-----------------------------
 SELECT COUNT(*) INTO l_n FROM tlf_file
  WHERE tlf01 = p_itmno
 IF l_n > 0 THEN LET l_errno='mfg9202' RETURN l_errno END IF
#MOD-C50234 add end ------------------------------
 RETURN l_errno 
END FUNCTION

#CHI-980019--begin--add----
#檢查料件是否為虛擬料
#RETURN TRUE檢查無錯誤/RETURN FALSE 檢查有錯誤
FUNCTION s_chkima08(p_item)
DEFINE p_item      LIKE ima_file.ima01
DEFINE l_ima08     LIKE ima_file.ima08

 IF cl_null(p_item) THEN RETURN TRUE END IF
 SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=p_item
 IF l_ima08 = 'X' THEN
    CALL cl_err('','mfg9022',0)
    RETURN FALSE
 END IF
 RETURN TRUE
END FUNCTION
#CHI-980019--end--add------
