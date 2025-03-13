# Prog. Version..: '5.30.06-13.03.12(00006)'     #
 
GLOBALS "../../config/top.global"
# Modify.........: No.FUN-560175 05/06/29 By kim 單號10放大到16
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE  
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-730008 07/04/04 By Smapmin 在出貨查詢-金額明細查詢時,
#                  應check此出貨單是否要簽收,如果要的話,應傳入出貨簽收單號(非出貨單號)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-C60090 12/06/29 By qiaozy 服饰流通出貨查詢庫存明細不可運行
 
DATABASE ds        #FUN-6C0017
 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
FUNCTION s_shpqry(p_shp)
  DEFINE p_shp		LIKE oea_file.oea01   #FUN-560175    # No.FUN-680137  VARCHAR(16)
  DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(100)
  DEFINE g_chr		LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE ls_tmp         STRING
  DEFINE l_oga01a       LIKE oga_file.oga01    #TQC-730008
  DEFINE l_oga65        LIKE oga_file.oga65    #TQC-730008
 
  LET l_cmd='xxxxxxx ',p_shp
 
  LET p_row = 2 LET p_col = 50
  OPEN WINDOW s_shpqry_w AT p_row,p_col WITH FORM "sub/42f/s_shpqry"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_locale("s_shpqry")
              
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
     CASE WHEN g_chr='1' LET l_cmd="axmq600 '",p_shp,"'" CALL cl_cmdrun(l_cmd)
          #-----TQC-730008---------
          #WHEN g_chr='2' LET l_cmd="axmq610 '",p_shp,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='2' 
               SELECT oga65 INTO l_oga65 FROM oga_file
                  WHERE oga01=p_shp
               IF l_oga65 = 'Y' THEN
                  DECLARE oga_cur CURSOR FOR
                   SELECT oga01 FROM oga_file
                    WHERE oga011=p_shp AND oga09='8'
                    ORDER BY oga01
                  OPEN oga_cur
                  FETCH oga_cur INTO l_oga01a
                  CLOSE oga_cur
                  LET l_cmd="axmq610 '",l_oga01a,"'" CALL cl_cmdrun(l_cmd)
               ELSE
                  LET l_cmd="axmq610 '",p_shp,"'" CALL cl_cmdrun(l_cmd)
               END IF
          #-----END TQC-730008-----
#FUN-C60090----ADD-----STR----
          WHEN g_chr='3'
             IF s_industry('slk') AND g_azw.azw04='2' THEN
                LET l_cmd="axmq620_slk '",p_shp,"'" CALL cl_cmdrun(l_cmd)
             ELSE
                LET l_cmd="axmq620 '",p_shp,"'" CALL cl_cmdrun(l_cmd)
             END IF
#FUN-C60090----ADD-----END----
#          WHEN g_chr='3' LET l_cmd="axmq620 '",p_shp,"'" CALL cl_cmdrun(l_cmd) #FUN-C60090----mark---
          WHEN g_chr='4' LET l_cmd="axmq530 '",p_shp,"'" CALL cl_cmdrun(l_cmd)
          WHEN g_chr='0' 
               CLOSE WINDOW s_shpqry_w
               RETURN
          WHEN g_chr='e' 
               CLOSE WINDOW s_shpqry_w
               RETURN
     END CASE
  END WHILE
 
END FUNCTION
