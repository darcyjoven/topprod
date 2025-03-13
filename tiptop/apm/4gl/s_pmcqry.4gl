# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION s_pmcqry(p_pmc)
  DEFINE p_pmc		LIKE pmc_file.pmc01          #No.FUN-680136 VARCHAR(10)
  DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(100)
  DEFINE g_chr		LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
  DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680136 SMALLINT
  LET l_cmd='xxxxxxx ',p_pmc
 
  LET p_row = 4 LET p_col = 39
  OPEN WINDOW s_pmcqry_w AT p_row,p_col WITH FORM "sub/42f/s_pmcqry"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  CALL cl_ui_locale("s_pmcqry")
              
  WHILE TRUE
     INPUT g_chr FROM a 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON ACTION EXIT
            LET g_chr='0' EXIT INPUT 
         ON KEY(ESC)
            LET g_chr='0' EXIT INPUT 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
     END INPUT
 
     IF INT_FLAG THEN LET INT_FLAG = 0 LET g_chr='0' END IF
 
     CASE WHEN g_chr = '1' LET l_cmd[1,7]='apmq230' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '2' LET l_cmd[1,7]='apmq231' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '3' LET l_cmd[1,7]='apmq232' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '4' LET l_cmd[1,7]='apmq233' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '5' LET l_cmd[1,7]='apmq234' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '6' LET l_cmd[1,7]='apmq235' CALL cl_cmdrun(l_cmd)
          WHEN g_chr = '0' CLOSE WINDOW s_pmcqry_w RETURN
          WHEN g_chr = 'e' CLOSE WINDOW s_pmcqry_w RETURN
     END CASE
  END WHILE
END FUNCTION
