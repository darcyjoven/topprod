# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_mtrade_last_plant.4gl
# Descriptions...: 多角貿易取得最終工廠與站別
# Date & Author..: No.7993 03/08/31 By Kammy 
# Usage..........: CALL s_last(p_flow,p_date,p_type,p_no) RETURNING p_last,p_last_plant
# Input Parameter: p_flow       流程代號
# Return code....: p_last       站別
#                  p_last_plant 工廠
# Modify.........: No.FUN-720003 07/02/04 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-810056 08/01/07 By claire 不計算第99站為最後一站
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_mtrade_last_plant(p_flow)
 
   DEFINE p_flow        LIKE poz_file.poz01
   DEFINE p_last        LIKE poy_file.poy02
   DEFINE p_last_plant  LIKE poy_file.poy04
 
   SELECT MAX(poy02) INTO p_last FROM poy_file
    WHERE poy01 = p_flow
      AND poy02 <> 99    #MOD-810056 add
   IF STATUS THEN
#     CALL cl_err('','axm-318',1) 
#No.FUN-720003--begin
 IF g_bgerr THEN
         CALL s_errmsg('','','','axm-318',1)
      ELSE
         CALL cl_err('','axm-318',1)
      END IF
#No.FUN-720003--end
   RETURN '',''   
   END IF
 
   SELECT poy04 INTO p_last_plant FROM poy_file
    WHERE poy01 = p_flow AND poy02 = p_last
 
   RETURN p_last,p_last_plant
 
END FUNCTION
