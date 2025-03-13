# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_ccc2.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: No.MOD-4B0135 04/11/16 By Mandy 新FUNCION 讓'信用彙總查核'中可再選擇要查哪一細項資料
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.TQC-6A0079 06/11/06 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-970038 09/07/03 By lilingyu 增加一個參數p_slip,并將此參數傳入到axmq210
# Modify.........: No:MOD-9C0362 09/12/24 By sabrina 程式呼叫段傳參數有問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_ccc2(p_cus_no)                #TQC-970038
 FUNCTION s_ccc2(p_cus_no,p_slip)         #TQC-970038
  DEFINE p_cus_no       LIKE occ_file.occ01     #No.FUN-560002 	#No.FUN-680147 VARCHAR(16)
  DEFINE ls_tmp         STRING
  DEFINE p_cus		LIKE type_file.chr10 	#No.FUN-680147 VARCHAR(10) #No.TQC-6A0079
  DEFINE l_cmd		LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(100)
  DEFINE g_chr		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
  DEFINE p_row,p_col     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
  DEFINE p_slip          LIKE oea_file.oea01    #TQC-970038    
    
  LET l_cmd='xxxxxxx ',p_cus
 
  LET p_row = 2 LET p_col = 51
 
  OPEN WINDOW s_ccc2_w AT p_row,p_col WITH FORM "sub/42f/s_ccc2"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  CALL cl_ui_locale("s_ccc2")
  LET g_chr = '1'
  WHILE TRUE
     INPUT g_chr WITHOUT DEFAULTS FROM a
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()
         ON KEY(ESC) LET INT_FLAG = 1 EXIT INPUT 
         ON ACTION exit LET INT_FLAG = 1 EXIT INPUT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
     END INPUT
     IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CLOSE WINDOW s_ccc2_w
         RETURN 
     END IF
     CASE WHEN g_chr = '1' 
          WHEN g_chr = '2' 
          WHEN g_chr = '3' 
          WHEN g_chr = '4' 
          WHEN g_chr = '5' 
          WHEN g_chr = '6' 
          WHEN g_chr = '7' 
          WHEN g_chr = '8' 
          WHEN g_chr = '9' 
          WHEN g_chr = 'A' 
          WHEN g_chr = 'B' 
          WHEN g_chr = 'C' 
     END CASE
#     LET l_cmd="axmq210 '",p_cus_no,"' ",g_chr                         #TQC-970038
      LET l_cmd="axmq210 '",p_cus_no,"' '",g_chr,"' '",p_slip,"'"       #TQC-970038    #MOD-9C0362 modify 
     CALL cl_cmdrun(l_cmd)
  END WHILE
END FUNCTION
