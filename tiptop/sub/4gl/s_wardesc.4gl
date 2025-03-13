# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_wardesc.4gl
# Descriptions...: 取得倉儲是否為可用倉之描述
# Date & Author..: 92/11/05 By  Pin
# Usage..........: CALL s_wardesc(p_img24,p_img24) RETURNING l_mesg
# Input Parameter: p_img23  Warehouse flag-1
#                  p_img24  MRP flag-2
# Return Code....: l_mesg   說明
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_wardesc(p_img23,p_img24)
DEFINE
      p_img23 LIKE img_file.img23,
      p_img24 LIKE img_file.img24,
      p_mesg  LIKE zaa_file.zaa08,      #No.FUN-680147 VARCHAR(26)
      p_flag  LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
      p_no    LIKE ze_file.ze01         #No.FUN-680147 VARCHAR(10)
 
    WHENEVER ERROR CALL cl_err_msg_log
  
    CASE p_img23
         WHEN 'N' LET p_flag=1    #不可用倉
                  LET p_no='mfg9054'
         WHEN 'Y' 
                  IF p_img24 MATCHES '[Yy]'
                      THEN LET p_flag=2   #MPS/MRP 可用倉儲
                           LET p_no='mfg9055'
                      ELSE LET p_flag=3   #MPS/MRP 不可用倉儲'
                           LET p_no='mfg9056'
                  END IF
         OTHERWISE LET p_flag=0 EXIT CASE
    END CASE
         CALL cl_getmsg(p_no,g_lang) RETURNING p_mesg
         RETURN p_mesg
    
                      
END FUNCTION
