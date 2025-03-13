# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_gr_upload.4gl
# Descriptions...: 上傳4rp檔
# Date & Author..: 12/03/07 By jacklai
# Usage .........: call s_gr_upload(ps_dir, p_path, p_gdw08, p_gdm03)
# Input Parameter: ps_dir
#                  p_path  (新4rp的檔案路徑)
#                  p_gdw08   
#                  p_gdm03  
# Return code....: none
# Memo...........: 上傳4rp後會開啟比對新舊4rp檔差異的視窗, 
#                  可以套用舊值並更新到新的4rp檔
# Modify.........: No.FUN-C30008 12/03/07 By jacklai 共用上傳4rp檔function
# Modify.........: No.FUN-CB0063 12/11/15 by stellar 增加GR檢查機制

#FUN-C30008 --start--
IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

#FUNCTION s_gr_upload(ps_dir, p_path, p_gdw08, p_gdm03)         #FUN-CB0063 121115 by stellar mark
FUNCTION s_gr_upload(ps_dir, p_path, p_gdw08, p_gdm03, p_rep)   #FUN-CB0063 121115 by stellar add p_rep
   DEFINE ps_dir      STRING
   DEFINE p_path      STRING
   DEFINE p_gdw08     LIKE gdw_file.gdw08
   DEFINE p_gdm03     LIKE gdm_file.gdm03
   DEFINE l_ori_file  STRING
   DEFINE l_new_path  STRING
   DEFINE l_str       STRING
   DEFINE l_now_str   STRING
   DEFINE l_cmd       STRING
   DEFINE l_result    BOOLEAN
   DEFINE l_gdw09     LIKE gdw_file.gdw09
   DEFINE l_basename  STRING
   #FUN-CB0063 121115 by stellar ----(S)
   DEFINE p_rep          LIKE type_file.chr1
   DEFINE l_strong_err   INTEGER
   DEFINE l_chk_err_msg  STRING 
   #FUN-CB0063 121115 by stellar ----(E)
   
   LET l_basename = os.Path.basename(p_path)
   LET l_ori_file = os.Path.join(ps_dir, l_basename)
   LET l_gdw09 = os.Path.rootname(l_basename)

   LET l_now_str = CURRENT
   LET l_now_str = cl_replace_str(l_now_str, "-", "")
   LET l_now_str = cl_replace_str(l_now_str, " ", "")
   LET l_now_str = cl_replace_str(l_now_str, ":", "")
   LET l_now_str = cl_replace_str(l_now_str, ".", "")
   LET l_str = g_prog CLIPPED, "_", g_user CLIPPED, "_", l_now_str CLIPPED, ".4rp"
   LET l_new_path = os.Path.join( FGL_GETENV("TEMPDIR"), l_str)
   
   #如果檔案上傳成功，開始比對   
   IF cl_upload_file(p_path, l_new_path) THEN   #上傳新檔
      
      IF NOT s_gr_diff_rep_chk_paper_size(l_new_path) THEN
         CALL cl_err("Info:取消上傳","!",1)
         CALL os.Path.delete(l_new_path) RETURNING l_result
         RETURN
      END IF

      LET l_result = FALSE
      #當使用者確認新檔案調整後無誤時，將舊檔備份，並使用新檔將舊檔覆蓋，再重新rescan
      IF os.Path.exists(l_ori_file) THEN
         #將舊檔備份
         CALL os.Path.copy(l_ori_file, l_ori_file || "." || l_now_str) RETURNING l_result
         #刪除舊檔
         CALL os.Path.delete(l_ori_file) RETURNING l_result
         #暫存檔copy到舊檔
         CALL os.Path.copy(l_new_path, l_ori_file) RETURNING l_result
         #刪除暫存檔
         CALL os.Path.delete(l_new_path) RETURNING l_result
      ELSE
         CALL os.Path.copy(l_new_path, l_ori_file) RETURNING l_result
      END IF
      
      IF l_result THEN 
         CALL cl_err("Info:上傳檔案成功", "!", 1)
        #FUN-CB0063 121115 by stellar ----(S)
        IF p_rep = '1' THEN #標準報表才檢查
           DISPLAY "l_ori_file:",l_ori_file
           DISPLAY "p_gdw08:",p_gdw08
           DISPLAY "p_gdm03:",p_gdm03
           CALL p_replang_chk_grule(l_ori_file,p_gdw08,p_gdm03) 
                RETURNING l_strong_err,l_chk_err_msg
           IF l_strong_err > 0 THEN
              IF l_chk_err_msg IS NOT NULL THEN
                 CALL cl_err(l_chk_err_msg,"!",-1)
              END IF
              IF NOT cl_confirm('azz1286') THEN
                 #舊檔還原
                 CALL os.Path.copy(l_ori_file || "." || l_now_str, l_ori_file) RETURNING l_result
                 #刪除備份檔
                 CALL os.Path.delete(l_ori_file || "." || l_now_str) RETURNING l_result
              ELSE
                 LET l_cmd = "p_updml4rp '",l_ori_file CLIPPED,"' '",p_gdw08 CLIPPED,"'"
                 IF NOT cl_null(p_gdm03) AND p_gdm03 <> 'S' THEN
                    LET l_cmd = l_cmd," '",p_gdm03 CLIPPED,"'"
                 END IF
                 DISPLAY "cmd: ",l_cmd
                 CALL cl_cmdrun_wait(l_cmd)
              END IF
           ELSE
              LET l_cmd = "p_updml4rp '",l_ori_file CLIPPED,"' '",p_gdw08 CLIPPED,"'"
              IF NOT cl_null(p_gdm03) AND p_gdm03 <> 'S' THEN
                 LET l_cmd = l_cmd," '",p_gdm03 CLIPPED,"'"
              END IF
              DISPLAY "cmd: ",l_cmd
              CALL cl_cmdrun_wait(l_cmd)
           END IF
        ELSE
        #FUN-CB0063 121115 by stellar ----(E)
         LET l_cmd = "p_updml4rp '",l_ori_file CLIPPED,"' '",p_gdw08 CLIPPED,"'"
         #IF NOT cl_null(p_gdm03) THEN                  #FUN-CB0063 121115 by stellar
         IF NOT cl_null(p_gdm03) AND p_gdm03 <> 'S' THEN  #FUN-CB0063 121115 by stellar
            LET l_cmd = l_cmd," '",p_gdm03 CLIPPED,"'"
         END IF
         DISPLAY "cmd: ",l_cmd
         CALL cl_cmdrun_wait(l_cmd)
        END IF    #FUN-CB0063 121115 by stellar
      ELSE
         CALL cl_err("Info:檔案上傳失敗", "!", 1)
      END IF

   END IF
END FUNCTION
#FUN-C30008 --end--
