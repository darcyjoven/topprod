# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_chk_imgg.4gl
# Descriptions...: 查詢imgg_file中是否存在雙單位資料
# Date & Author..: 05/04/22 By Carrier  FUN-540022
# Usage..........: CALL s_chk_imgg(p_item,p_ware,p_loc,p_lot,p_unit)
# Input PARAMETER: p_item  料件
#                  p_ware  倉庫
#                  p_loc   儲位
#                  p_lot   批號
#                  p_unit  單位
# RETURN Code....: '1'
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-AB0011 10/10/05 By huangtao 修改return值 

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_chk_imgg(p_item,p_ware,p_loc,p_lot,p_unit)
 
DEFINE
    p_item     LIKE imgg_file.imgg01,
    p_ware     LIKE imgg_file.imgg02,
    p_loc      LIKE imgg_file.imgg03,
    p_lot      LIKE imgg_file.imgg04,
    p_unit     LIKE imgg_file.imgg07,
    l_flag     LIKE type_file.chr1            #No.FUN-680147 VARCHAR(1)
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN
    #    RETURN                         #FUN-AB0011  mark
         RETURN  0                      #FUN-AB0011 
    END IF
#FUN-A90049 --------------end------------------------------------- 

    WHENEVER ERROR CALL cl_err_msg_log
    
    LET l_flag = 0
    SELECT * FROM imgg_file
     WHERE imgg01=p_item
       AND imgg02=p_ware
       AND imgg03=p_loc
       AND imgg04=p_lot
       AND imgg09=p_unit
    IF SQLCA.sqlcode=100 THEN
       LET l_flag = 1
    END IF
    RETURN l_flag
 
END FUNCTION
