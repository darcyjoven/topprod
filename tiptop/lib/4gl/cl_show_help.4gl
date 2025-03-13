# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: cl_show_help.4gl
# Descriptions...: 顯示程式的說明文件.
# Date & Author..: 03/08/08 by Hiko
# Usage..........: CALL cl_show_help()
# Modify.........: 2005/03/04 alex 調路徑
# Modify.........: No.MOD-490117 03/08/08 By alex 增加客製程式可以抓到help功能
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-760007 07/06/05 By claire 客製程式取不到help改取標準程式 
# Modify.........: No.FUN-750068 07/07/06 By saki 行業別程式說明檔連結
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810089 08/03/05 By saki 行業別程式架構更動
# Modify.........: No:TQC-9B0186 09/11/23 By saki 客製程式串出網址異常
 
IMPORT os   #No:TQC-9B0186

DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
DEFINE mc_std_id           LIKE smb_file.smb01            #No.FUN-750068
 
# Descriptions...: 顯示程式的說明文件
# Date & Author..: 2003/08/08 by Hiko
# Input Parameter: none
# Return code....: void
# Memo...........: 
 
FUNCTION cl_show_help()
   DEFINE   ls_help_url     STRING,
            ls_fglasip      STRING,
            ls_help_path    STRING   #No:TQC-9B0186
   DEFINE   lc_zz011        LIKE zz_file.zz011
   DEFINE   g_cnt           LIKE type_file.num10  #TQC-760007 add  
   DEFINE   l_cmd,ls_sys    STRING  #TQC-760007 add
#No.FUN-810089 --mark start--
#  DEFINE   lc_ui_setting   LIKE gav_file.gav11  #No.FUN-750068
#  DEFINE   lc_cust_gav     LIKE type_file.chr1  #No.FUN-750068
#  DEFINE   lc_cust_flag    LIKE type_file.chr1  #No.FUN-750068
#No.FUN-810089 ---mark end---
 
   LET ls_fglasip = FGL_GETENV("FGLASIP")
   IF UPSHIFT(g_sys[1,1])="C" THEN
      LET ls_help_url = ls_fglasip.trim(), "/topcust/help/"
      LET ls_help_path = FGL_GETENV("CUST"),os.Path.separator(),"doc",
                         os.Path.separator(),"help",os.Path.separator()   #No:TQC-9B0186
   ELSE
      LET ls_help_url = ls_fglasip.trim(), "/tiptop/help/"
      LET ls_help_path = FGL_GETENV("TOP"),os.Path.separator(),"doc",
                         os.Path.separator(),"help",os.Path.separator()   #No:TQC-9B0186
   END IF
 
#No.FUN-810089 --start--
#  #No.FUN-750068 --start--
#  CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#  SELECT COUNT(*) INTO g_cnt FROM gav_file
#   WHERE gav01 = g_frm_name AND gav08 = 'Y'
#  IF g_cnt > 0 THEN
#     LET lc_cust_gav  = "Y"
#  ELSE
#     LET lc_cust_gav  = "N"
#  END IF
#  SELECT COUNT(*) INTO g_cnt FROM gae_file
#   WHERE gae01 = g_frm_name AND gae03 = g_lang AND gae11 = 'Y'
#  IF g_cnt > 0 THEN
#     LET lc_cust_flag = "Y"
#  ELSE
#     LET lc_cust_flag = "N"
#  END IF
#  LET mc_std_id = "std"
#  LET lc_ui_setting = g_sma.sma124
#  SELECT COUNT(*) INTO g_cnt FROM gav_file
#   WHERE gav01 = g_frm_name AND gav08 = lc_cust_gav AND gav11 = lc_ui_setting
#  IF g_cnt <= 0 THEN
#     LET lc_ui_setting = mc_std_id
#  ELSE
#     SELECT COUNT(*) INTO g_cnt FROM gae_file
#      WHERE gae01 = g_frm_name AND gae03 = g_lang AND gae11 = lc_cust_flag AND gae12 = lc_ui_setting
#     IF g_cnt <= 0 THEN
#        LET lc_ui_setting = mc_std_id
#     END IF
#  END IF
#  IF lc_ui_setting = "std" THEN
#     LET ls_help_url = ls_help_url.trim(),
#                        g_lang CLIPPED, "/", DOWNSHIFT(g_sys) CLIPPED,
#                        "/HELP_",  g_prog CLIPPED, ".htm"
#  ELSE
#     LET ls_help_url = ls_help_url.trim(),
#                        g_lang CLIPPED, "/", DOWNSHIFT(g_sys) CLIPPED,
#                        "/HELP_",  g_prog CLIPPED,"_",lc_ui_setting CLIPPED,".htm"
#  END IF
#  #No.FUN-750068 ---end---
   LET ls_help_url = ls_help_url.trim(),
                      g_lang CLIPPED, "/", DOWNSHIFT(g_sys) CLIPPED,
                      "/HELP_",  g_prog CLIPPED, ".htm"
   LET ls_help_path = ls_help_path.trim(),g_lang CLIPPED,os.Path.separator(),
                      DOWNSHIFT(g_sys) CLIPPED,os.Path.separator(),
                      "HELP_",  g_prog CLIPPED, ".htm"   #No:TQC-9B0186
#No.FUN-810089 ---end---
   
  #TQC-760007-begin-add
#  LET l_cmd = "test -s ",ls_help_url    #No:TQC-9B0186
   LET l_cmd = "test -s ",ls_help_path   #No:TQC-9B0186
   RUN l_cmd RETURNING g_cnt
   IF g_cnt AND g_prog[1,1] != "c" AND UPSHIFT(g_sys[1,1])="C" THEN
#No.FUN-810089 --start--
      LET ls_sys = DOWNSHIFT(g_sys) CLIPPED
	 IF ls_sys.getLength() >= "4" THEN
             LET ls_sys = ls_sys.subString(2,ls_sys.getLength())
          ELSE
	     LET ls_sys = "a",ls_sys.subString(2,ls_sys.getLength())
         END IF 
#  #No.FUN-750068 --start--
#     IF g_ui_setting = "std" THEN
   LET ls_help_url = ls_fglasip.trim(), "/tiptop/help/",g_lang CLIPPED, "/",
              ls_sys,"/HELP_",  g_prog CLIPPED, ".htm"
#        LET ls_help_url = ls_help_url.trim(),
#                           g_lang CLIPPED, "/", ls_sys,"/HELP_",  g_prog CLIPPED,".htm"
#     ELSE
#        LET ls_help_url = ls_help_url.trim(),
#                           g_lang CLIPPED, "/", ls_sys,"/HELP_",  g_prog CLIPPED,"_",g_ui_setting CLIPPED,".htm"
#     END IF
#  #No.FUN-750068 ---end---
#No.FUN-810089 ---end---
   END IF
 
  #TQC-760007-end-add
   IF NOT cl_open_url(ls_help_url) THEN
      CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
   END IF
 
END FUNCTION
