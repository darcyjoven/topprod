# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify...........: NO.FUN-5A0128 05/10/21 By Rosayu INPUT g_chr FROM a--> INPUT g_chr WITHOUT DEFAULTS FROM a
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE  
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-C60090 12/06/29 By qiaozy 服飾流通訂單查詢請購單維護選項有問題
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
FUNCTION s_ordqry(p_ord)
  DEFINE ls_tmp         STRING
  DEFINE p_ord		LIKE oea_file.oea01    #No.FUN-550070    # No.FUN-680137 VARCHAR(16)
  DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(100)
  DEFINE g_chr		LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE l_oea40        LIKE oea_file.oea01    #No.FUN-550070    # No.FUN-680137  VARCHAR(16) 
 
  LET l_cmd='xxxxxxx ',p_ord
 
  LET p_row = 2 LET p_col = 49
  OPEN WINDOW s_ordqry_w AT p_row,p_col WITH FORM "sub/42f/s_ordqry"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_locale("s_ordqry")
              
  WHILE TRUE
     #INPUT g_chr FROM a #FUN-5A0128 mark
     INPUT g_chr WITHOUT DEFAULTS  FROM a  #FUN-5A0128 add
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
 
     
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG=0 LET g_chr='0' END IF
     CASE WHEN g_chr='1' LET l_cmd="axmq400 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='2' LET l_cmd="axmq401 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='3' LET l_cmd="axmq410 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='4' LET l_cmd="axmq420 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='5' LET l_cmd="axmq430 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='6' LET l_cmd="axmq440 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='7' LET l_cmd="aimq841 3 '",p_ord,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='8' 
               LET l_oea40 = ''
               SELECT oea40 INTO l_oea40 FROM oea_file WHERE oea01 = p_ord
               IF SQLCA.sqlcode OR STATUS OR cl_null(l_oea40) THEN
                  LET l_oea40 = ''
                  EXIT CASE
               ELSE
                  #FUN-C60090----ADD-----STR---
                  IF s_industry('slk') AND g_azw.azw04='2' THEN
                     LET l_cmd="apmt420_slk '",l_oea40,"'" CALL cl_cmdrun(l_cmd)
                  ELSE
                  #FUN-C60090----ADD-----END----
                     LET l_cmd="apmt420 '",l_oea40,"'" CALL cl_cmdrun(l_cmd)
                  END IF  #FUN-C60090----ADD----
               END IF
          WHEN g_chr='0' 
               CLOSE WINDOW s_ordqry_w 
               RETURN
          WHEN g_chr='e'
               CLOSE WINDOW s_ordqry_w
               RETURN
     END CASE
  END WHILE
END FUNCTION
