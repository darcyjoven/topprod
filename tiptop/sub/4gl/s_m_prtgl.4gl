# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: s_m_prtg1.4gl
# Descriptions...: 顯示已拋轉總帳的編號, 並詢問是否列印傳票
# Date & Author..: 93/03/09 By Roger
# Usage..........: CALL s_m_prtgl(p_dbs,p_bookno,p_gl_no_b,p_gl_no_e)
# Input Parameter: p_dbs       總帳所在資料庫
#                  p_bookno    總帳帳別
#                  p_gl_no_b   起始傳票編號
#                  p_gl_no_e   截止傳票編號
# Return code....: NONE
# Modify.........: No.FUN-540059 05/06/19 By day  單據編號修改
# Modify.........: No.FUN-640004 06/04/05 By Tracy  賬別位數擴大到5碼
# Modify.........: No.FUN-670060 06/08/10 By wujie  修正ok,cancel會變英文
# Modify.........: No.FUN-680088 06/08/29 By Rayven 增加帳套欄位
# Modify.........: No.FUN-680147 06/09/15 By czl 欄位型態定義,改為LIKE
# Modify.........: No.MOD-740066 07/04/24 By Smapmin 以輸入日期,輸入人員,列印次數加以過濾來縮小範圍
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-8A0075 08/10/08 By clover 依照aza26功能別來區分要列印台灣(aglr903)的還是大陸的傳票(gglr903)
# Modify.........: No.MOD-8C0061 08/12/10 By Sarah 串aglr903/gglr903時,參數傳遞寫法修正
# Modify.........: No.FUN-990069 09/09/24 By baofei GP集團架構修改,sub相關參數
# Modify.........: No:MOD-9B0172 09/11/25 By Sarah 大陸版應該串gglr304
# Modify.........: No:MOD-A70065 10/07/08 By Dido 若執行放棄時,應重新將 INT_FLAG = FALSE 
# Modify.........: No:MOD-B10227 11/01/26 By Dido 關閉 screen 視窗 
# Modify.........: No.CHI-C30078 12/06/04 By jinjj調整列印額外摘要參數tm.v預設值為 'N'
# Modify.........: No.MOD-D30171 13/03/19 By apo 改串aglg903
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_m_prtgl(p_dbs,p_bookno,gl_no_b,gl_no_e)   #FUN-990069
FUNCTION s_m_prtgl(p_plant,p_bookno,gl_no_b,gl_no_e) #FUN-990069 
   DEFINE p_plant               LIKE type_file.chr10  #FUN-990069 
   DEFINE p_dbs			LIKE type_file.chr21  #No.FUN-680147 VARCHAR(21)
#  DEFINE p_bookno	 VARCHAR(02)
   DEFINE p_bookno		LIKE aaa_file.aaa01   #No.FUN-640004
   DEFINE gl_no_b		LIKE aba_file.aba01   #No.FUN-680147 VARCHAR(16) #No.FUN-540059
   DEFINE gl_no_e		LIKE aba_file.aba01   #No.FUN-680147 VARCHAR(16) #No.FUN-540059
   DEFINE prt_sw		LIKE type_file.chr1   #No.FUN-680147 VARCHAR(01)
   DEFINE l_prtway		LIKE type_file.chr1   #No.FUN-680147 VARCHAR(01)
   DEFINE l_wc                  STRING   #MOD-740066
   DEFINE l_wc2	                LIKE type_file.chr1000#No.FUN-680147 VARCHAR(100)
   DEFINE p_row,p_col           LIKE type_file.num5   #No.FUN-680147 SMALLINT
   DEFINE l_cmd			LIKE type_file.chr1000#No.FUN-680147 VARCHAR(400)
 
#FUN-990069--begin                                                                                                                  
    IF cl_null(p_plant) THEN                                                                                                        
       LET p_dbs = NULL                                                                                                             
    ELSE                                                                                                                            
       LET g_plant_new = p_plant                                                                                                    
       CALL s_getdbs()                                                                                                              
       LET p_dbs = g_dbs_new                                                                                                        
    END IF                                                                                                                          
#FUN-990069--end 
   WHENEVER ERROR CALL cl_err_msg_log
   CLOSE WINDOW screen            #MOD-B10227 
   LET p_row = 8 LET p_col = 36
   OPEN WINDOW s_m_prtgl_w AT p_row,p_col WITH FORM "sub/42f/s_m_prtgl"
   ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_load_act_sys(NULL)             #No.FUN-670060 
   CALL cl_ui_locale("s_m_prtgl")
 
   #No.FUN-680088 --end--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_bookno",FALSE)
   END IF
   #No.FUN-680088 --end--
 
   LET prt_sw = 'N'
   DISPLAY BY NAME gl_no_b,gl_no_e,prt_sw,p_bookno   #No.FUN-680088 add p_bookno
   INPUT BY NAME prt_sw WITHOUT DEFAULTS 
      AFTER FIELD prt_sw
         IF cl_null(prt_sw) THEN 
            NEXT FIELD prt_sw 
         END IF
         IF prt_sw NOT MATCHES '[YN]' THEN 
            NEXT FIELD prt_sw 
         END IF
      ON KEY (CONTROL-P) CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
  #-MOD-A70065-add-
   IF INT_FLAG THEN 
      LET INT_FLAG = FALSE
   END IF  
  #-MOD-A70065-end-
   IF prt_sw = 'N' THEN 
      CLOSE WINDOW s_m_prtgl_w 
      RETURN 
   END IF
   CALL cl_wait()
  #str MOD-8C0061 mod
  #LET l_wc=' aba01 BETWEEN "',gl_no_b,'" AND "',gl_no_e,'"',
  #         ' AND aba05="',g_today,'" AND abauser="',g_user,'"',   #MOD-740066
  #         ' AND abaprno = 0 '    #MOD-740066
   LET l_wc=" aba01 BETWEEN '",gl_no_b,"' AND '",gl_no_e,"'",
            " AND aba05='",g_today,"' AND abauser='",g_user,"'",   #MOD-740066
            " AND abaprno = 0 "    #MOD-740066
  #end MOD-8C0061 mod
   IF g_aza.aza26!='2' THEN    #MOD-8A0075
       # zz21:固定列印條件 zz22:固定列印方式
      SELECT  zz21,zz22 INTO l_wc2,l_prtway 
        FROM  zz_file 
       #WHERE zz01 = 'aglr903'   #MOD-D30171 mark
        WHERE zz01 = 'aglg903'   #MOD-D30171 
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN 
         #LET l_wc2 = " '3' '3' 'Y' '3'"     #CHI-C30078 mark
         LET l_wc2 = " '3' '3' 'N' '3'"      #CHI-C30078 add
      END IF
     #IF cl_null(l_prtway) THEN LET l_prtway = 1 END IF
     #str MOD-8C0061 mod
     #LET l_cmd = 'aglr903',
     #            " '",p_bookno,"'",
     #            " '",p_dbs CLIPPED,"'",
     #            " '",g_today CLIPPED,"' ''",
     #            " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
     #            " '",l_wc CLIPPED,"' ",l_wc2 CLIPPED
     #LET l_cmd = 'aglr903',   #MOD-D30171 mark
      LET l_cmd = 'aglg903',   #MOD-D30171 
                  ' "',p_bookno,'"',
                  ' "',p_dbs CLIPPED,'"',
                  ' "',g_today CLIPPED,'" ""',
                  ' "',g_lang CLIPPED,'" "Y" "',l_prtway,'" "1"',
                  ' "',l_wc CLIPPED,'" ',l_wc2 CLIPPED
     #end MOD-8C0061 mod
   #MOD-8A0075--add-start
   ELSE
     SELECT  zz21,zz22 INTO l_wc2,l_prtway
        FROM  zz_file
     #  WHERE zz01 = 'gglr903'   #MOD-9B0172 mark
        WHERE zz01 = 'gglr304'   #MOD-9B0172
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
        #LET l_wc2 = " '3' '3' 'Y' '3'"   #MOD-9B0172 mark
         LET l_wc2 = " '3' '3' '3' 'N'"   #MOD-9B0172
      END IF
     #IF cl_null(l_prtway) THEN LET l_prtway = 1 END IF
     #str MOD-8C0061 mod
     #LET l_cmd = 'gglr903',
     #            " '",p_bookno,"'",
     #            " '",p_dbs CLIPPED,"'",
     #            " '",g_today CLIPPED,"' ''",
     #            " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
     #            " '",l_wc CLIPPED,"' ",l_wc2 CLIPPED
    #str MOD-9B0172 mod
    # LET l_cmd = 'gglr903',
    #             ' "',p_bookno,'"',
    #             ' "',p_dbs CLIPPED,'"',
    #             ' "',g_today CLIPPED,'" ""',
    #             ' "',g_lang CLIPPED,'" "Y" "',l_prtway,'" "1"',
    #             ' "',l_wc CLIPPED,'" ',l_wc2 CLIPPED
      LET l_cmd = 'gglr304',
                  ' "',p_bookno,'"',
                  ' "',g_today CLIPPED,'"',
                  ' "" ',
                  ' "',g_lang CLIPPED,'"',
                  ' "Y"',
                  ' "',l_prtway,'"',
                  ' "1" ',
                  ' "',l_wc CLIPPED,'"',
                  ' ',l_wc2 CLIPPED,''
    #end MOD-9B0172 mod
     #end MOD-8C0061 mod
   END IF
   #MOD-8A0075 --add -end
 
 
 # START REPORT s_m_prtgl_rep TO 's_m_prtgl.cmd'
 # OUTPUT TO REPORT s_m_prtgl_rep(l_cmd)
 # FINISH REPORT s_m_prtgl_rep
   CLOSE WINDOW s_m_prtgl_w
   DISPLAY l_cmd
  #CALL cl_cmdrun_wait(l_cmd CLIPPED)   #MOD-8C0061 mark
   CALL cl_cmdrun(l_cmd CLIPPED)        #MOD-8C0061
   ERROR ''
 # CLOSE WINDOW s_m_prtgl_w
 # OPTIONS FORM LINE FIRST + 2
END FUNCTION
 
REPORT s_m_prtgl_rep(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(400)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH 1
  FORMAT
   ON EVERY ROW PRINT p_cmd
END REPORT
