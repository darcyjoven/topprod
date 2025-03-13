# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_udima.4gl
# Descriptions...: 更新庫存主檔之庫存數量
# Date & Author..: 92/05/26 By Pin
# Usage..........: IF s_udima(p_item,p_img23,p_img24,p_qty,p_date,p_type)
# Input Parameter: p_item    欲更新之料件
#                  p_img23   倉儲可用否(多倉管理使用)
#                  p_img24   MRP/MPS 可用否(多倉管理使用)
#                  p_qty     欲更新之數量
#                  p_date    異動日期
#                  p_type    欲更新之方式
#                     +1  入庫
#                     0   報廢/退貨
#                     -1  出庫
#                     2   盤點
#                     3   重計
# Return code....: 1   FAIL
#                  0   OK
# Memo...........: 不成功時g_success為N
# Modify.........: 92/06/31 By david
# Modify.........: NO.FUN-670091 06/08/02 by rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0083 06/12/08 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_udima(p_item,p_img23,p_img24,p_qty,p_date,p_type)
DEFINE
    p_item  LIKE ima_file.ima01,
    p_img23 LIKE img_file.img23,
    p_img24 LIKE img_file.img24,
#    p_qty   LIKE ima_file.ima26, #FUN-A20044
    p_qty   LIKE type_file.num15_3, #FUN-A20044
    p_date  LIKE ima_file.ima29, #異動日期
    p_type  LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_ima   RECORD LIKE ima_file.*,
#    l_ima26,l_ima261,l_ima262	LIKE ima_file.ima26 #FUN-A20044
   l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 	LIKE type_file.num15_3 #FUN-A20044
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01= p_item
    IF STATUS THEN 
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_item,'sel ima',STATUS,1)
       ELSE
         #CALL cl_err('sel ima:',STATUS,1) #FUN-670091
          CALL cl_err3("sel","ima_file",p_item,"",STATUS,"","",1)  #FUN-670091
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N' 
       RETURN 1
    END IF
    
#    LET l_ima26=0 LET l_ima261=0 LET l_ima262=0 #FUN-A20044
#    LET l_avl_stk_mpsmrp=0 LET l_unavl_stk=0 LET l_avl_stk=0 #FUN-A20044
   ##########FUN-A20044---------BEGIN
  ##  SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
 #          WHERE img01=l_ima.ima01 AND img24='Y'
  #  IF l_ima26 IS NULL THEN LET l_ima26=0 END IF
  #  SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
   #        WHERE img01=l_ima.ima01 AND img23='N'
   # IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
  #  SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
   #        WHERE img01=l_ima.ima01 AND img23='Y'
   # IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
    ##########FUN-A20044---------END
   CALL s_getstock(l_ima.ima01,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
    SELECT ima29,ima30,ima73,ima74 
      INTO l_ima.ima29,l_ima.ima30,l_ima.ima73,l_ima.ima74
      FROM ima_file
     WHERE ima01=p_item
 
    IF p_type= 2 THEN LET l_ima.ima30=p_date END IF
    IF p_type=+1 THEN LET l_ima.ima73=p_date END IF
    IF p_type=-1 THEN LET l_ima.ima74=p_date END IF
    IF p_type= 0 THEN LET l_ima.ima74=p_date END IF
    
    #--- NO:0721 異動日期需大於原來的異動日期才可 update modi in 99/10/18
   #IF p_date > l_ima.ima29 AND p_type <> 2 THEN
   #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
    IF (p_date > l_ima.ima29 OR l_ima.ima29 IS NULL) AND p_type <> 2 THEN
       LET l_ima.ima29 = p_date
    END IF
    #-------------------------------------------------------------------
 
    UPDATE ima_file SET# ima26=l_ima26,
                       # ima261=l_ima261,
                       # ima262=l_ima262,   #FUN-A20044
                        ima29=l_ima.ima29,
                        ima30=l_ima.ima30,
                        ima73=l_ima.ima73,
                        ima74=l_ima.ima74,
                        imadate = g_today     #FUN-C30315 add
     WHERE ima01= p_item
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_item,'upd ima',STATUS,1)
       ELSE
          CALL cl_err('upd ima:',STATUS,1)
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N'
       RETURN 1
    END IF
    RETURN 0
END FUNCTION
