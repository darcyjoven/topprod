# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_actimg.4gl
# Descriptions...: 檢查該批號是否為有效(有效日期>=MFG DAY)
# Date & Author..: 92/06/24 By  Pin
# Input Parameter: p_item :料件編號
#                  p_ware :倉庫號碼
#                  p_loc  :儲位號碼
#                  p_lot  :批號
# Retuen Code....: 0:該批號已過期
#                  1:該批號未過期
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值 

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_actimg(p_item,p_ware,p_loc,p_lot)
DEFINE
#    p_item       LIKE type_file.chr20,  	#No.FUN-680147 VARCHAR(20)
#	p_ware       LIKE apm_file.apm08, 	#No.FUN-680147 VARCHAR(10)
#    p_loc        LIKE apm_file.apm08, 	        #No.FUN-680147 VARCHAR(10)
#	p_lot        LIKE aab_file.aab01 , 	#No.FUN-680147 VARCHAR(24)
    p_item       LIKE img_file.img01,
    p_ware   LIKE img_file.img02,
    p_loc        LIKE img_file.img03,
    p_lot    LIKE img_file.img04,
    l_img18      LIKE img_file.img18
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN
     #   RETURN                   #FUN-AB0011  mark
         RETURN 1                  #FUN-AB0011
    END IF
#FUN-A90049 --------------end-------------------------------------
 
    IF p_loc IS NULL THEN LET p_loc=' ' END IF
    IF p_lot IS NULL THEN LET p_lot=' ' END IF
    SELECT img18 INTO l_img18 
      FROM img_file 
     WHERE img01=p_item
      AND  img02=p_ware
      AND  img03=p_loc
      AND  img04=p_lot
    IF SQLCA.sqlcode THEN RETURN 0 END IF
    IF l_img18 IS NULL OR l_img18=' ' THEN LET l_img18=g_lastdat  END IF
    IF l_img18 < g_today   #有效日小於今天
       THEN RETURN 0
       ELSE RETURN 1
    END IF
  
END FUNCTION
