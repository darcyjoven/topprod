# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: s_so_exp.4gl
# Descriptions...: 订单屏风条码生成入库
# Date & Author..: No:DEV-CA0012 2012/10/30 By TSD.JIE
# Usage..........: CALL s_so_exp(p_oea01,p_oba01,p_inTrancation)
# Input Parameter: p_oea01        订单编号
#                  p_oba01        系列号
#                  p_inTrancation  boolean 是否在事务中
# Return code....: NONE
# Modify.........: No.DEV-D10005 13/01/23 By Nina 產生入庫單須代入預設倉庫
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---


DATABASE ds
 
GLOBALS "../../config/top.global"  
 
FUNCTION s_so_exp(p_oea01,p_oba01,p_inTrancation ) 
   DEFINE p_oea01         LIKE oea_file.oea01,
          p_oba01         LIKE oba_file.oba01,
          p_inTrancation  BOOLEAN 
   DEFINE l_n             LIKE type_file.num5  
   DEFINE l_cnt           LIKE type_file.num5  
   DEFINE l_rec_b         LIKE type_file.num5
   DEFINE l_sql           STRING
   DEFINE l_sfb           DYNAMIC ARRAY OF RECORD LIKE sfb_file.*
   DEFINE b_sfu           RECORD LIKE sfu_file.*
   DEFINE b_sfv           RECORD LIKE sfv_file.*
   DEFINE l_smyslip       LIKE smy_file.smyslip
   DEFINE l_success       LIKE type_file.chr1
   DEFINE l_sets          LIKE sfb_file.sfb08
   DEFINE l_sfv09         LIKE sfb_file.sfb08
   DEFINE li_result       LIKE type_file.num5

   WHENEVER ERROR CONTINUE
   LET l_success = 'Y'
   LET l_sets = 0
   IF cl_null(p_oea01) OR cl_null(p_oba01)  THEN 
     #CALL cl_err('订单号&系列不能为空','!',1) #No:DEV-CA0015--mark
      CALL cl_err('','aba-079',1)              #No:DEV-CA0015--add
      LET l_success = 'N'
      RETURN l_success,''
   END IF 
   
   ##--找到所有的生产工单  
   LET l_sql = "SELECT sfb_file.* ",
               "  FROM sfb_file,oeb_file,ima_file ",
               " WHERE sfb22 = oeb01 ",
               "   AND sfb221 = oeb03 ",
               "   AND sfb05 = ima01 ",
               "   AND oeb01 = '",p_oea01,"' ",
               "   AND ima131 = '",p_oba01,"' ",
               " ORDER BY sfb01 "
   PREPARE getSfb FROM l_sql
   DECLARE getSfb_cs CURSOR FOR getSfb
   LET l_cnt = 1
   FOREACH getSfb_cs INTO l_sfb[l_cnt].* 
      IF STATUS THEN LET l_success ='N' END IF 
 
      LET l_cnt = l_cnt + 1
   END FOREACH 
   CALL l_sfb.deleteElement(l_cnt)
   LET l_rec_b = l_cnt -1 
               
   ##--判断S.O下所有条码库存是否在同一个仓库中
   LET l_sql = "SELECT COUNT(*) FROM ( ",
             #No:DEV-CA0015--mark--begin
             #" SELECT DISTINCT imgb02 from imgb_file,iba_file ",
             #"  WHERE iba14 = '",p_oea01,"' ",
             #"    AND iba11 = '",p_oba01,"' ",
             #"    AND iba04 = '52' ",
             #"    AND iba00 = '5' ",
             #"    AND imgb00 = iba00 ",
             #"    AND imgb01 = iba01 ) "
             #No:DEV-CA0015--mark--end
              #No:DEV-CA0015--add--begin
              " SELECT DISTINCT imgb02 ",
              "   FROM imgb_file,ibb_file ",
              "  WHERE ibb03 = '",p_oea01,"' ",  #來源單號
              "    AND ibb09 = '",p_oba01,"' ",  #包裝系列<產品分類碼>
              "    AND ibb02 = 'H' ",
              "    AND imgb01 = ibb01 ) "
              #No:DEV-CA0015--add--end
   PREPARE getWareCount FROM l_sql
   LET l_n = 0 
   EXECUTE getWareCount INTO l_n
   IF l_n > 1 THEN 
     IF g_bgerr THEN
        CALL s_errmsg('imgb01',p_oea01||'--'||p_oba01,'sel imgb','aba-009',1)
     ELSE
        CALL cl_err('','aba-009',1)
     END IF
     LET l_success = 'N'
     RETURN l_success,''
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
    
   LET g_sma.sma39 = 'Y'
   LET g_sma.sma892 = '1NN'

   #插入单头资料
   LET b_sfu.sfu00 = '1'
   LET b_sfu.sfu02 = g_today
   LET b_sfu.sfu14 = g_today
   LET b_sfu.sfu16 = g_user #No:DEV-CB0002--add
   LET b_sfu.sfupost='N'
   LET b_sfu.sfuconf='N'
   LET b_sfu.sfuuser=g_user
   LET b_sfu.sfuoriu = g_user
   LET b_sfu.sfuorig = g_grup
   LET b_sfu.sfugrup=g_grup
   LET b_sfu.sfudate=g_today
   LET b_sfu.sfu04=g_grup
   LET b_sfu.sfuplant = g_plant
   LET b_sfu.sfulegal = g_legal
   LET b_sfu.sfu15 = '0'
   LET b_sfu.sfumksg = 'N' 
   LET l_smyslip = s_get_doc_no(l_sfb[1].sfb01) 
  #SELECT smy52 INTO l_smyslip FROM smy_file    #No.DEV-CB0002--mark
  # WHERE smyslip = l_smyslip                   #No.DEV-CB0002--mark
   SELECT smyb02 INTO l_smyslip FROM smyb_file  #No.DEV-CB0002--add
    WHERE smybslip = l_smyslip                  #No.DEV-CB0002--add
   CALL s_auto_assign_no("asf",l_smyslip,b_sfu.sfu14,"A","sfu_file","sfu01","","","")  #MOD-A40051
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
         CALL s_errmsg('ins sfu',b_sfu.sfu01,'',STATUS,1)  #没有指定入库单别  
      ELSE
         CALL cl_err('',STATUS,1)
      END IF
      LET l_success = 'N'
   END IF

   #插入单身资料
   FOR l_cnt = 1 TO l_rec_b 
      INITIALIZE b_sfv.* TO NULL    #No:DEV-CA0015--add
      LET b_sfv.sfv01 = b_sfu.sfu01
      LET b_sfv.sfv03 = l_cnt
      SELECT sfb05 INTO b_sfv.sfv04 FROM sfb_file
       WHERE sfb01 = l_sfb[l_cnt].sfb01
     #No:DEV-CA0015--mark--begin
     #SELECT DISTINCT imgb02 INTO b_sfv.sfv05
     #  FROM imgb_file,iba_file
     # WHERE iba14 = p_oea01
     #   AND iba04 = '52'
     #   AND iba00 = '5'
     #   AND iba11 = p_oba01
     #   AND imgb01 = iba01
     #   AND imgb00 = iba00
     #No:DEV-CA0015--mark--end
     #DEV-D10005 mark str----------------------
     ##No:DEV-CA0015--add--begin
     #SELECT DISTINCT imgb02 INTO b_sfv.sfv05
     #  FROM imgb_file,iba_file
     # WHERE iba03 = p_oea01
     #   AND iba09 = p_oba01
     #   AND iba02 = 'H'
     #   AND imgb01 = iba01
     ##No:DEV-CA0015--add--end
     #DEV-D10005 mark end----------------------
     #DEV-D10005 add str-----------------------
      SELECT UNIQUE tlfb02 INTO b_sfv.sfv05 
        FROM tlfb_file 
       WHERE tlfb11 = 'abat022' 
         AND tlfb01 IN (SELECT ibb01 FROM ibb_file WHERE ibb03 = p_oea01)
     #DEV-D10005 add end-----------------------
      LET b_sfv.sfv06 = ' '
      LET b_sfv.sfv07 = ' '
      SELECT ima25 INTO b_sfv.sfv08 FROM ima_file
       WHERE ima01 = b_sfv.sfv04
      LET b_sfv.sfv09 = l_sfb[l_cnt].sfb08 - l_sfb[l_cnt].sfb09
      LET b_sfv.sfv11 = l_sfb[l_cnt].sfb01
      LET b_sfv.sfv16 = 'N'
      LET b_sfv.sfv30 = b_sfv.sfv08
      LET b_sfv.sfv31 = 1
      LET b_sfv.sfv32 = b_sfv.sfv09
      LET b_sfv.sfvplant = g_plant
      LET b_sfv.sfvlegal = g_legal
      LET b_sfv.sfv930=s_costcenter(b_sfu.sfu04) #FUN-670103
      INSERT INTO sfv_file VALUES (b_sfv.*)
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg('ins sfv',b_sfv.sfv01,'',STATUS,1)  #没有指定入库单别  
         ELSE
            CALL cl_err('',STATUS,1)
         END IF
         LET l_success = 'N'
      END IF
   END FOR 
      
   IF NOT p_inTrancation THEN
      IF l_success='Y' THEN
         COMMIT WORK
      END IF 
      IF l_success='N' THEN
         ROLLBACK WORK
      END IF 
   END IF 

   RETURN l_success,b_sfu.sfu01
END FUNCTION
#DEV-CA0012
#DEV-D30025--add

