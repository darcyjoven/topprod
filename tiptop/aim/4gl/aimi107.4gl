# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimi107.4gl
# Descriptions...: 料件基本資料維護作業-成本項目結構
# Date & Author..: 91/11/07 By Wu
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_iml01         LIKE iml_file.iml01,   #類別代號 (假單頭)
    g_iml01_t       LIKE iml_file.iml01,   #類別代號 (舊值)
    g_iml           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        iml02       LIKE iml_file.iml02,    #成本項目
        smg02       LIKE smg_file.smg02,    #說明
        smg03       LIKE smg_file.smg03,    #類別
        iml031      LIKE iml_file.iml031,   #標準成本
        iml032      LIKE iml_file.iml032,   #現時成本
        iml033      LIKE iml_file.iml033    #預設成本
                    END RECORD,
    g_iml_t         RECORD                 #程式變數 (舊值)
        iml02       LIKE iml_file.iml02,    #成本項目
        smg02       LIKE smg_file.smg02,    #說明
        smg03       LIKE smg_file.smg03,    #類別
        iml031      LIKE iml_file.iml031,   #標準成本
        iml032      LIKE iml_file.iml032,   #現時成本
        iml033      LIKE iml_file.iml033    #預設成本
                    END RECORD,
    g_argv1         LIKE iml_file.iml01,
    g_imauser       LIKE ima_file.imauser,
    g_imagrup       LIKE ima_file.imagrup,
    g_imamodu       LIKE ima_file.imamodu,
    g_imadate       LIKE ima_file.imadate,
    g_imaacti       LIKE ima_file.imaacti,
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    g_ss            LIKE type_file.chr1,   #決定後續步驟 #No.FUN-690026 VARCHAR(1)
    g_rec           LIKE type_file.num5,   #單身筆數     #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE#No.FUN-690026 SMALLINT              
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL aimi107(g_argv1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
