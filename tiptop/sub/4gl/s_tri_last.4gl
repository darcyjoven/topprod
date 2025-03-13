# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_tri_last.4gl
# Descriptions...: 多角貿易取得最終工廠與站別
# Date & Author..: No.7993 03/08/31 By Kammy 
# Usage..........: CALL s_last_tri(p_flow,p_date,p_type,p_no) RETURNING p_last,p_last_plant
# Input Parameter: p_flow       流程代號
# Return Code....: p_last       站別
#                  p_last_plant 工廠
# Modify.........: No.8640 03/11/04 ching rename to s_tri_last
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-720003 07/02/5 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.TQC-810029 08/07/10 BY yiting 代採正拋如有設最終供應商，99站不為最終站
# Modify.........: NO.MOD-870123 08/07/10 BY claire 追單TQC-810029
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_tri_last(p_flow)
DEFINE p_flow        LIKE poz_file.poz01
DEFINE p_last        LIKE poy_file.poy02
DEFINE p_last_plant  LIKE poy_file.poy04
  SELECT MAX(poy02) INTO p_last FROM poy_file
   WHERE poy01 = p_flow
     AND poy02 <> '99'   #NO.TQC-810029 #MOD-870123
  IF STATUS THEN
#    CALL cl_err('','axm-318',1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('poy01',p_flow,'','axm-318',1)                                                             
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
