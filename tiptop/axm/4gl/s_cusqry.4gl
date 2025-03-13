# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Modify.........: No.FUN-560175 05/06/29 By kim 單號10放大到16
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.MOD-6C0119 06/12/25 By claire 選8時不傳客戶代碼,要以信用評等為key
#
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B60094 13/03/22 BY Elise s_cusqry加傳參數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_cusqry(p_cus,p_slip)  #CHI-B60094 add p_slip
  DEFINE ls_tmp         STRING
  DEFINE p_cus		LIKE oea_file.oea01          # No.FUN-680137  VARCHAR(16)  #FUN-560175
  DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(100)
  DEFINE g_chr		LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_occ61	LIKE occ_file.occ61          #MOD-06C0119 add
  DEFINE p_slip         LIKE oea_file.oea01          #CHI-B60094 add
  LET l_cmd='xxxxxxx ',p_cus
 
  LET p_row = 2 LET p_col = 51
 
  OPEN WINDOW s_cusqry_w AT p_row,p_col WITH FORM "sub/42f/s_cusqry"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  CALL cl_ui_locale("s_cusqry")
 
  WHILE TRUE
     INPUT g_chr FROM a 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()
         ON KEY(ESC) LET g_chr='0' EXIT INPUT 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
     END INPUT
 
     IF INT_FLAG THEN LET INT_FLAG = 0 LET g_chr='0' END IF
    #CASE WHEN g_chr = '1' CALL s_ccc(p_cus,'2','')      #CHI-B60094 mark
     CASE WHEN g_chr = '1' CALL s_ccc(p_cus,'2',p_slip)  #CHI-B60094
          WHEN g_chr = '2' LET l_cmd[1,7]='axmq210' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '3' LET l_cmd[1,7]='axmq220' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '4' LET l_cmd[1,7]='axmq221' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '5' LET l_cmd[1,7]='axmq230' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '6' LET l_cmd[1,7]='axmq240' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '7' LET l_cmd[1,7]='axmq260' CALL cl_cmdrun(l_cmd)
         #MOD-6C0119-begin
         #WHEN g_chr = '8' LET l_cmd[1,7]='axmi300' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '8' 
          SELECT occ61 INTO l_occ61 
            FROM occ_file  
           WHERE occ01=p_cus
          LET l_cmd='axmi300 ',l_occ61
          CALL cl_cmdrun(l_cmd)
          LET l_cmd='xxxxxxx ',p_cus
         #MOD-6C0119-end
          WHEN g_chr = '0' 
               CLOSE WINDOW s_cusqry_w 
               RETURN
          WHEN g_chr = 'e'
               CLOSE WINDOW s_cusqry_w 
               RETURN
     END CASE
  END WHILE
END FUNCTION
