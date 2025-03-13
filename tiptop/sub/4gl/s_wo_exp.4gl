# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: s_wo_exp.4gl
# Descriptions...: 工单条码生成入库
# Date & Author..: No.DEV-CA0014 12/10/30 By TSD.Hiyawus
# Usage..........: CALL s_wo_exp(p_sfb01,p_inTrancation)
# Input Parameter: p_sfb01         工单编号
#                  p_inTrancation  boolean 是否在事务中
# Return code....: NONE
# Modify.........: No.DEV-CB0002 12/11/21 By TSD.JIE 單別來源取smyb02
# Modify.........: No.DEV-D10005 13/01/23 By Nina 產生入庫單須代入預設倉庫
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---



DATABASE ds
 
GLOBALS "../../config/top.global"  
GLOBALS "../../aba/4gl/barcode.global"
 

FUNCTION s_wo_exp(p_sfb01,p_inTrancation ) 
DEFINE
    p_sfb01        LIKE sfb_file.sfb01,
    p_inTrancation BOOLEAN 
DEFINE l_n         LIKE type_file.num5  
DEFINE l_sql       STRING
DEFINE l_sfb       RECORD LIKE sfb_file.*
DEFINE b_sfu       RECORD LIKE sfu_file.*
DEFINE b_sfv       RECORD LIKE sfv_file.*
DEFINE l_smyslip   LIKE smy_file.smyslip
DEFINE l_success   LIKE type_file.chr1
DEFINE l_sets      LIKE sfb_file.sfb08
DEFINE l_sfv09     LIKE sfb_file.sfb08
DEFINE li_result   LIKE type_file.num5

   WHENEVER ERROR CONTINUE
   LET l_success = 'Y'
   LET l_sets = 0
   IF cl_null(p_sfb01)  THEN 
      CALL cl_err('','asf-967',1)     #工單單號不可為空白
      LET l_success = 'N'
      RETURN l_success,l_sets ,''
   END IF 
   
   ##--判断W.O下所有条码库存是否在同一个仓库中
   LET l_sql = " SELECT COUNT(*) FROM ( SELECT DISTINCT imgb02 FROM imgb_file,iba_file,ibb_file ",
               "                         WHERE iba01 = ibb01 ",
               "                           AND ibb01 = imgb01  ",        #條碼編號
               "                           AND iba02 = 'C' ",            #類型限定 C:包裝
               "                           AND ibb03 = '",p_sfb01,"' ",  #來源單號   
               "                           AND ibb02 = 'A' ) "           #條碼產生時機點 A:工單
   PREPARE getWareCount FROM l_sql
   EXECUTE getWareCount INTO l_n
   IF l_n > 1 THEN 
      IF g_bgerr THEN
         CALL s_errmsg('imgb01',p_sfb01,'sel imgb','aba-009',1)
      ELSE
         CALL cl_err('','aba-009',1)
      END IF
      LET l_success = 'N'
      RETURN l_success,l_sets,'' 
   END IF 

   #--找到W.O 最大的齐套&&可入库数量
   #--->公式：【最大数量-调整数量】-->最大齐套数量 
   #----       - 入库数量 --> 可入库数量

   #No.DEV-CA0014 By TSD.Hiyawus 121030 ---add--- 改寫成LEFT OUTER JOIN寫法
   #LET l_sql = " SELECT MIN(sets) FROM ( SELECT tlfb01,NVL(SUM(tlfb05*tlfb06),0) AS sets ",
   #            "                           FROM tlfb_file,ibb_file ",
   #            "                          WHERE ibb01 = tlfb01(+) ",      #條碼編號
   #            "                            AND ibb03 = '",p_sfb01,"' ",  #來源單號:工單單號  
   #            "                            AND (tlfb011 IN('abat022') OR tlfb011 IS NULL)",
   #            "                          GROUP BY tlfb01 ",
   #            "                          ) "

   LET l_sql = " SELECT MIN(sets) FROM ( SELECT tlfb01,NVL(SUM(tlfb05*tlfb06),0) AS sets ",
               "                           FROM iba_file,ibb_file LEFT OUTER JOIN tlfb_file ON ibb01 = tlfb01 ",
               "                          WHERE iba01 = ibb01 ",
               "                            AND ibb03 = '",p_sfb01,"' ",    #來源單號:工單單號
               "                            AND (tlfb11 IN('abat022') OR tlfb11 IS NULL)",
               "                          GROUP BY tlfb01 ",
               "                          ) "
   #No.DEV-CA0014 By TSD.Hiyawus 121030 ---end--- 

   PREPARE getSets FROM l_sql
   EXECUTE getSets INTO l_sets
   IF cl_null(l_sets) THEN  LET l_sets = 0 END IF 
    
   #入庫數量
   SELECT SUM(sfv09) INTO l_sfv09 FROM sfv_file
    WHERE sfv11 = p_sfb01
   IF cl_null(l_sfv09) THEN LET l_sfv09 = 0  END IF 

   #可入庫數量 = 最大其套數量 - 入庫數量
   LET l_sets = l_sets - l_sfv09
   IF l_sets <= 0 THEN 
      IF g_bgerr THEN
         CALL s_errmsg('tlfb01',p_sfb01,'s_get_sets','aba-010',1)
      ELSE
         CALL cl_err('','aba-010',1)
      END IF
      LET l_success = 'N' 
      RETURN l_success,l_sets,''
   END IF 
   IF cl_null(p_inTrancation) THEN 
      LET p_inTrancation = FALSE
   END IF 
   IF NOT p_intrancation THEN 
      BEGIN WORK
   END IF 

   ##--已经找到W.O 最大可入库数量，生成入库单
   INITIALIZE b_sfu.* TO NULL
   INITIALIZE b_sfv.* TO NULL
    
   LET g_sma.sma39  = 'Y'
   LET g_sma.sma892 = '1NN'

   #-->完工入庫單單頭sfu_file
   LET b_sfu.sfu00    = '1'   
   LET b_sfu.sfu02    = g_today
   LET b_sfu.sfu04    = g_grup
   LET b_sfu.sfu14    = g_today
   LET b_sfu.sfu15    = '0'
   LET b_sfu.sfu16    = g_user
   LET b_sfu.sfupost  = 'N'
   LET b_sfu.sfuconf  = 'N'
   LET b_sfu.sfuuser  = g_user
   LET b_sfu.sfuoriu  = g_user
   LET b_sfu.sfuorig  = g_grup
   LET b_sfu.sfugrup  = g_grup
   LET b_sfu.sfudate  = g_today
   LET b_sfu.sfuplant = g_plant
   LET b_sfu.sfulegal = g_legal
   LET b_sfu.sfumksg  = 'N'     #是否簽核
   #單別
   LET l_smyslip = s_get_doc_no(p_sfb01) 
  #SELECT smy52 INTO l_smyslip FROM smy_file    #No.DEV-CB0002--mark
  # WHERE smyslip = l_smyslip                   #No.DEV-CB0002--mark
   SELECT smyb02 INTO l_smyslip FROM smyb_file  #No.DEV-CB0002--add
    WHERE smybslip = l_smyslip                  #No.DEV-CB0002--add
   #取單號
   CALL s_auto_assign_no("asf",l_smyslip,b_sfu.sfu14,"A","sfu_file","sfu01","","","")
        RETURNING li_result,b_sfu.sfu01
   IF (NOT li_result) THEN
      IF g_bgerr THEN
         CALL s_errmsg('sfu',b_sfu.sfu01,'','aba-011',1)  #没有指定入库单别  
      ELSE
         CALL cl_err('','aba-011',1)
      END IF
      LET l_success = 'N'
   END IF
   INSERT INTO sfu_file VALUES (b_sfu.*)
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('ins sfu',b_sfu.sfu01,'',STATUS,1) 
      ELSE
         CALL cl_err('','aba-077',1)    #新增庫存失敗  #No.DEV-CA0014 新增於p_ze
      END IF
      LET l_success = 'N'
   END IF

   #-->完工入庫單單身sfv_file
   LET b_sfv.sfv01 = b_sfu.sfu01
   LET b_sfv.sfv03 = 1
   #(料號)
   SELECT sfb05 INTO b_sfv.sfv04  
     FROM sfb_file
    WHERE sfb01 = p_sfb01
   #(倉庫)
  #DEV-D10005 mark str-----------------------
  #SELECT DISTINCT imgb02 INTO b_sfv.sfv05
  #  FROM imgb_file,ibb_file
  # WHERE ibb03  = p_sfb01  #來源單號
  #   AND imgb01 = ibb01    #條碼編號
  #DEV-D10005 mark end-----------------------
  #DEV-D10005 add str-----------------------
   SELECT UNIQUE tlfb02 INTO b_sfv.sfv05
     FROM tlfb_file 
    WHERE tlfb11 = 'abat022' 
      AND tlfb01 IN (SELECT ibb01 FROM ibb_file WHERE ibb03 = p_sfb01)
  #DEV-D10005 add end-----------------------
   LET b_sfv.sfv06 = ' '
   LET b_sfv.sfv07 = ' '
   #(庫存單位)
   SELECT ima25 INTO b_sfv.sfv08
     FROM ima_file
    WHERE ima01 = b_sfv.sfv04
   LET b_sfv.sfv09    = l_sets     #可入庫數量
   LET b_sfv.sfv11    = p_sfb01
   LET b_sfv.sfv16    = 'N'
   LET b_sfv.sfv30    = b_sfv.sfv08
   LET b_sfv.sfv31    = 1
   LET b_sfv.sfv32    = b_sfv.sfv09
   LET b_sfv.sfvplant = g_plant
   LET b_sfv.sfvlegal = g_legal
   LET b_sfv.sfv930   = s_costcenter(b_sfu.sfu04)

   #產生完工入庫單單身sfv_file之前先判斷是否需INSERT img_file
   IF NOT wo_add_img(b_sfv.sfv04,b_sfv.sfv05,b_sfv.sfv06,b_sfv.sfv07,
                   b_sfv.sfv01,b_sfv.sfv03,g_today) THEN
      IF g_bgerr THEN
         CALL s_errmsg('ins img',b_sfv.sfv04,'',STATUS,1)  #没有指定入库单别  
      ELSE
         CALL cl_err('',STATUS,1)
      END IF
      LET l_success = 'N'
   END IF 

   INSERT INTO sfv_file VALUES (b_sfv.*)
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('ins sfv',b_sfv.sfv01,'',STATUS,1)  #没有指定入库单别  
      ELSE
         CALL cl_err('',STATUS,1)
      END IF
      LET l_success = 'N'
   END IF

   IF NOT p_inTrancation THEN
      IF l_success='Y' THEN
         COMMIT WORK
      END IF 
      IF l_success='N' THEN
         ROLLBACK WORK
      END IF 
   END IF 
   RETURN l_success,l_sets,b_sfu.sfu01
END FUNCTION
 

FUNCTION wo_add_img(p_sfv04,p_sfv05,p_sfv06,p_sfv07,p_sfv01,p_sfv03,p_day)
   DEFINE p_sfv04 LIKE sfv_file.sfv04,   #料號
          p_sfv05 LIKE sfv_file.sfv05,   #倉庫
          p_sfv06 LIKE sfv_file.sfv06,   #儲位
          p_sfv07 LIKE sfv_file.sfv07,   #批號
          p_sfv01 LIKE sfv_file.sfv01,   #參考單號
          p_sfv03 LIKE sfv_file.sfv03,   #序號
          p_day   LIKE type_file.dat,    #單據日期
          g_img09 LIKE img_file.img09,
          g_img10 LIKE img_file.img10 

   SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
    WHERE img01=p_sfv04 AND img02=p_sfv05
      AND img03=p_sfv06 AND img04=p_sfv07
   IF STATUS = 100 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         IF NOT cl_confirm('mfg1401') THEN
            RETURN FALSE
         END IF
      END IF
      CALL s_add_img(p_sfv04,p_sfv05,
                     p_sfv06,p_sfv07,
                     p_sfv01,p_sfv03,
                     p_day)
      IF g_errno='N' THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#DEV-CA0014 ---add---
#DEV-D30025--add

