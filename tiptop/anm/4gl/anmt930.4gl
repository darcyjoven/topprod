# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmt930.4gl
# Descriptions...: 集團資金調撥-還本維護作業
# Date & Author..: No.FUN-620051 2006/03/07 By Mandy
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-680088 06/09/19 By Rayven anmt940調用anmt930畫面時會報錯
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
MAIN
   DEFINE
       p_row,p_col     LIKE type_file.num5,          #No.FUN-680107 SMALLINT
#       l_time       LIKE type_file.chr8              #No.FUN-6A0082
       p_argv1         LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       p_argv2         LIKE nnw_file.nnw01
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_argv1=ARG_VAL(1)
   LET p_argv2=ARG_VAL(2)
   CASE WHEN p_argv1='1' LET g_prog='anmt930' #還本
        WHEN p_argv1='2' LET g_prog='anmt940' #還息
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL t930_lock_cur_a() #LOCK單頭的CURSOR
   CALL t930_plantnam('d','3',g_plant)
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0082
 
   LET p_row = 1 LET p_col = 6
 
   OPEN WINDOW t930_w AT p_row,p_col
     WITH FORM "anm/42f/anmt930"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_set_locale_frm_name("anmt930")  #No.FUN-680088
    CALL cl_ui_init()
 
 
 
   IF cl_null(g_nmz.nmz56) THEN LET g_nmz.nmz56=0 END IF
   IF cl_null(g_nmz.nmz57) THEN LET g_nmz.nmz57=0 END IF
   CALL t930(p_argv1,p_argv2) #1:還本 2:還息
   CLOSE WINDOW t930_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
