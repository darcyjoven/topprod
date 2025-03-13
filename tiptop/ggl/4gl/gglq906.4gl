# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: gglq906.4gl
# Descriptions...: 明細分類帳查詢
# Date & Author..: 02/02/27 By Danny
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-5A0072 05/10/31 By ice 新增傳票明細查詢功能
# Modify.........: No.TQC-5B0104 05/11/11 By Tracy 將貸方金額顯示為負值
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉yy,mm,因程序中沒有賦值
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/10 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-860273 08/07/02 By Sarah gglq906查詢時,單身摘要無"期初"及"期末"說明字眼,需同aglq906
# Modify.........: No.MOD-850053 08/05/05 By chenl   修正sql錯誤。
# Modify.........: No.TQC-920073 09/02/23 By dxfwo FUNCTION q906_qcye中的e_date,b_date定義為num5型，但它接受的是日期型的    
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   tm    RECORD
            wc1       LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
            wc        LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
            wc2       LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(1000)
         END RECORD,
   g_ae  RECORD
            aea00     LIKE aea_file.aea00,       #No.FUN-740033
            aea05     LIKE aea_file.aea05,
            aea02     LIKE aea_file.aea02
         END RECORD,
   g_aea DYNAMIC ARRAY OF RECORD
            aea02     LIKE aea_file.aea02,
            aba05     LIKE aba_file.aba05,
            aea03     LIKE aea_file.aea03,
            abb04     LIKE abb_file.abb04,
            aba06     LIKE aba_file.aba06,
            abb24     LIKE abb_file.abb24,
            abb25     LIKE abb_file.abb25,
            abb07f_1  LIKE abb_file.abb07f,
            abb07_1   LIKE abb_file.abb07,
            abb07f_2  LIKE abb_file.abb07f,
            abb07_2   LIKE abb_file.abb07,
            b         LIKE alb_file.alb06        #NO FUN-690009   DECIMAL(20,6)
         END RECORD,
  g_bookno            LIKE aea_file.aea00,
  g_wc,g_sql          LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
  g_rec_b             LIKE type_file.num5,       #NO FUN-690009   SMALLINT
  g_i                 LIKE type_file.num5,       #NO FUN-690009   SMALLINT
  l_ac                LIKE type_file.num5        #NO FUN-690009   SMALLINT
DEFINE   g_cnt        LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_msg        LIKE ze_file.ze03      #NO FUN-690009   VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   g_curs_index LIKE type_file.num10       #NO FUN-690009   INTEGER
DEFINE   bdate,edate  LIKE type_file.dat         #NO FUN-690009   DATE  #CHI-710005
 
MAIN
   OPTIONS                              #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                      #擷取中斷鍵, 由程式處理
 
   LET g_bookno = ARG_VAL(1)            #參數值(1) Part#
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
#  CALL cl_used('gglq906',g_time,1) RETURNING g_time    #No.FUN-6A0097
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW q906_srn WITH FORM 'ggl/42f/gglq906'
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET bdate=g_today
   LET edate=g_today
   IF NOT cl_null(g_bookno) THEN CALL q906_q() END IF
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 
   CALL q906_menu()
   CLOSE WINDOW q906_srn               #結束畫面
 
#  CALL cl_used('gglq906',g_time,2) RETURNING g_time    #No.FUN-6A0097
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
#QBE 查詢資料
FUNCTION q906_cs()
   DEFINE   l_cnt LIKE type_file.num5        #NO FUN-690009   SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_aea.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INITIALIZE g_ae.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc1 ON aag00,aag01  #No.FUN-740033
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_sql=" SELECT aag00,aag01 FROM aag_file ",  #No.FUN-740033
             "  WHERE ",tm.wc1 CLIPPED,
             "    AND aag03 = '2' ",
            #"    AND aag07 = '2' "                 #No.MOD-850053 mark
             "    AND (aag07 = '2' OR aag07='3')"   #No.MOD-850053
   PREPARE q906_prepare FROM g_sql
   DECLARE q906_cs                         #SCROLL CURSOR
      SCROLL CURSOR FOR q906_prepare
 
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             " WHERE ",tm.wc1 CLIPPED,
             "   AND aag03 = '2' ",
            #"   AND aag07 = '2' "                  #No.MOD-850053 mark
             "    AND (aag07 = '2' OR aag07='3')"   #No.MOD-850053
   PREPARE q906_precount FROM g_sql
   DECLARE q906_count CURSOR FOR q906_precount
   INPUT BY NAME bdate,edate WITHOUT DEFAULTS
      AFTER FIELD bdate
         IF cl_null(bdate) THEN
              NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(edate) THEN
            LET edate =g_lastdat
         ELSE
            IF YEAR(bdate) <> YEAR(edate) THEN
               CALL cl_err('','mfg6150',0)
               NEXT FIELD edate
            END IF
         END IF
         IF edate < bdate THEN
            CALL cl_err(' ','agl-031',0)
            NEXT FIELD edate
         END IF
 
#--NO.MOD-860078 start---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg
           CALL cl_cmdask()
#--NO.MOD-860078 end------- 
   END INPUT
END FUNCTION
 
FUNCTION q906_menu()
DEFINE   p_vchno LIKE aea_file.aea03
DEFINE   g_cmd   LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(100)
 
   WHILE TRUE
      CALL q906_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q906_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aea),'','')
            END IF
         #No.FUN-5A0072 --start--
         WHEN "drill"
            IF NOT cl_null(g_ae.aea05) THEN
               LET p_vchno=g_aea[l_ac].aea03
               LET g_bookno=g_ae.aea00           #No.FUN-740033
               IF NOT cl_null(p_vchno) THEN
                  CASE g_aea[l_ac].aba06
                     WHEN 'RV'
                        LET g_cmd = "aglq170 '",g_bookno,"' '",p_vchno,"' "
                     WHEN 'AC'
                        LET g_cmd = "aglt130 '",g_bookno,"' '",p_vchno,"' "
                     OTHERWISE
                        LET g_cmd = "aglt110                '",p_vchno,"' " #FUN-810046
                  END CASE
                  #FUN-660216 start--
                   #CALL cl_cmdrun(g_cmd)
                   IF g_aea[l_ac].aba06 ='RV' THEN
                      CALL cl_cmdrun(g_cmd)
                   ELSE
                      CALL cl_cmdrun_wait(g_cmd)
                   END IF
                  #FUN-660216 end--
               END IF
            END IF
         #No.FUN-5A0072 --end--
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q906_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL q906_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q906_count
   FETCH q906_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q906_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      CALL q906_fetch('F')                 # 讀出TEMP第一筆并顯示
   END IF
END FUNCTION
 
FUNCTION q906_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)        #處理方式
    l_abso          LIKE type_file.num10       #NO FUN-690009   INTEGER        #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q906_cs INTO g_ae.aea00,g_ae.aea05  #No.FUN-740033
        WHEN 'P' FETCH PREVIOUS q906_cs INTO g_ae.aea00,g_ae.aea05  #No.FUN-740033
        WHEN 'F' FETCH FIRST    q906_cs INTO g_ae.aea00,g_ae.aea05  #No.FUN-740033
        WHEN 'L' FETCH LAST     q906_cs INTO g_ae.aea00,g_ae.aea05  #No.FUN-740033
        WHEN '/'
           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
           LET INT_FLAG = 0
           PROMPT g_msg CLIPPED,': ' FOR l_abso
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
           END PROMPT
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              EXIT CASE
           END IF
           FETCH ABSOLUTE l_abso q906_cs INTO g_ae.aea00,g_ae.aea05  #No.FUN-740033
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ae.aea05,SQLCA.sqlcode,0)
        INITIALIZE g_ae.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL q906_show()
END FUNCTION
 
FUNCTION q906_show()
   DISPLAY g_ae.aea05 TO aag01
   DISPLAY g_ae.aea00 TO aag00  #No.FUN-740033
   CALL q906_aea05('d')
   CALL q906_b_fill() #單身
END FUNCTION
 
FUNCTION q906_aea05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)
          l_aag02   LIKE aag_file.aag02,
          l_aagacti LIKE aag_file.aagacti
 
   LET g_errno = ' '
   IF g_ae.aea05 IS NULL THEN
      LET l_aag02=NULL
   ELSE
      SELECT aag02,aagacti
        INTO l_aag02,l_aagacti
        FROM aag_file WHERE aag01 = g_ae.aea05
                        AND aag00 = g_ae.aea00  #No.FUN-740033
      IF SQLCA.sqlcode THEN
         LET g_errno = 'agl-001'
         LET l_aag02 = NULL
      END IF
   END IF
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_aag02 TO  aag02
   END IF
END FUNCTION
 
#No.FUN-5A0072 --start--
FUNCTION q906_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,    #NO FUN-690009   VARCHAR(1000)
          l_abb06   LIKE abb_file.abb06,
          l_bal     LIKE abb_file.abb07,       #NO FUN-690009   DECIMAL(20,6)
          l_bal1    LIKE abb_file.abb07,       #NO FUN-690009   DECIMAL(20,6)
          l_bdate   LIKE type_file.dat,        #NO FUN-690009   DATE
          l_edate   LIKE type_file.dat         #NO FUN-690009   DATE
   #期初
   LET l_bal1=0
   LET l_bdate=bdate USING "YYYY-MM-DD"
   CALL q906_qcye(g_ae.aea05) RETURNING l_bal
   LET l_sql = "SELECT aea02,aba05,aea03,abb04,aba06,abb24,abb25,abb07f,",
               "       abb07,0,0,0,abb06 ",
               "  FROM aea_file,abb_file,aba_file ",
               " WHERE aea05 = '",g_ae.aea05,"' ",
               " AND aea00 = '",g_ae.aea00,"'",   #No.FUN-740033
               " AND aea03 = abb01 AND aea04 = abb02  AND abb01 = aba01 ",
              #" AND aea00 = ?",      #No.MOD-850053 mark
               " AND aba00 = aea00 ",
               " AND abb00 = aea00 ",
               " AND aea02 BETWEEN '",bdate,"' AND '",edate,"'",
               " ORDER BY aea02"
    PREPARE q906_pb FROM l_sql
    DECLARE q906_bcs                       #BODY CURSOR
       SCROLL CURSOR WITH HOLD FOR q906_pb
    LET l_sql = "SELECT COUNT(*)",
                " FROM  aea_file,abb_file,aba_file ",
                " WHERE aea05 = '",g_ae.aea05,"'",
                " AND aea03 = abb01 AND aea04 = abb02  AND abb01 = aba01 ",
#               " AND aea00 = '",g_bookno,"'",
                " AND aea00 = '",g_ae.aea00,"'",   #No.FUN-740033
                " AND aba00 = aea00 ",
                " AND abb00 = aea00 ",
                " AND aea02 BETWEEN '",bdate,"' AND '",edate,"'"
    PREPARE q906_pre FROM l_sql
    DECLARE q906_c
        CURSOR FOR q906_pre
    OPEN q906_c
    FETCH q906_c INTO g_rec_b
    CALL g_aea.clear()
 
    LET g_cnt = 1     #No.MOD-850053
 
   #str MOD-860273 add
    FOR g_cnt = 1 TO g_aea.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_aea[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_aea[1].b=l_bal
    LET l_bal1=l_bal
    #期初
    CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
    LET g_aea[1].abb04 = g_msg CLIPPED
    LET g_cnt = 2
   #end MOD-860273 add
 
   #No.MOD-850053--begin-- mark
   #OPEN q906_bcs USING ''
   #IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
   #   CALL cl_err('',SQLCA.sqlcode,1)
   #END IF
   #FETCH q906_bcs INTO g_aea[1].*,l_abb06
   #CALL cl_getmsg('agl-192',g_lang) RETURNING g_msg
   #LET g_aea[1].abb04 = g_msg CLIPPED
   #LET g_aea[1].b=l_bal
   #LET g_cnt =2
   #LET l_bal1=l_bal
   #No.MOD-850053---end---
#   OPEN q906_bcs USING g_bookno    #No.FUN-740033
  # OPEN q906_bcs USING g_ae.aea00  #No.FUN-740033      #No.MOD-850053 mark
    FOREACH q906_bcs INTO g_aea[g_cnt].*,l_abb06 #No.MOD-850053
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_abb06 = '2' THEN
          LET g_aea[g_cnt].abb07_2 = -g_aea[g_cnt].abb07_1 #No.TQC-5B0104
          LET g_aea[g_cnt].abb07_1 = 0
          LET g_aea[g_cnt].abb07f_2 =-g_aea[g_cnt].abb07f_1 #No.TQC-5B0104
          LET g_aea[g_cnt].abb07f_1 = 0
       END IF
       LET l_bal1=l_bal1+g_aea[g_cnt].abb07_1+g_aea[g_cnt].abb07_2 #No.TQC-5B0104
       LET g_aea[g_cnt].b=l_bal1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
   #str MOD-860273 add
    #期末
    CALL cl_getmsg('agl-193',g_lang) RETURNING g_msg
    LET g_aea[g_cnt].abb04 = g_msg CLIPPED
    LET g_aea[g_cnt].b=l_bal1
   #end MOD-860273 add
 
   #No.MOD-850053--begin-- mark
   #OPEN q906_bcs USING ''
   #IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
   #   CALL cl_err('',SQLCA.sqlcode,1)
   #END IF
   #FETCH q906_bcs INTO g_aea[g_cnt].*,l_abb06
   #CALL cl_getmsg('gnm-001',g_lang) RETURNING g_msg
   #LET g_aea[g_cnt].abb04 = g_msg[1,4] CLIPPED
   #LET g_aea[g_cnt].b=l_bal1
   #No.MOD-850053---end--- mark
END FUNCTION
#No.FUN-5A0072 --end--
 
FUNCTION q906_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        #NO FUN-690009   VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_aea TO s_aea.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q906_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
      ON ACTION previous
         CALL q906_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
      ON ACTION jump
         CALL q906_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
      ON ACTION next
         CALL q906_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
      ON ACTION last
         CALL q906_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="drill"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION drill_down
         LET g_action_choice="drill"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about
         CALL cl_about()
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q906_bp_refresh()
   DISPLAY ARRAY g_aea TO s_aea.*
      BEFORE DISPLAY
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
   END DISPLAY
END FUNCTION
 
#No.FUN-5A0072 --start--
FUNCTION q906_qcye(l_aea05)
   DEFINE l_aea05 LIKE aea_file.aea05,
          l_bal,l_bal1,l_bal2,n_bal,n_bal1,l_d,l_c,l_d1,l_c1  LIKE abb_file.abb07, #NO FUN-690009  DECIMAL(20,6)
          l_y1    LIKE type_file.num5,       #NO FUN-690009   SMALLINT      #起始日所在年度
          l_m1    LIKE type_file.num5,       #NO FUN-690009   SMALLINT      #起始日所在期別
          l_flag  LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01)      #
#         b_date  LIKE type_file.num5,       #NO FUN-690009   DATE          #期始日
#         e_date  LIKE type_file.num5        #NO FUN-690009   DATE          #截至日
          b_date  LIKE type_file.dat,        #NO TQC-920073   DATE          #期始日
          e_date  LIKE type_file.dat         #NO TQC-920073   DATE          #截至日
 
   SELECT azn02,azn04 INTO l_y1,l_m1 FROM azn_file
    WHERE azn01 = bdate
 
   #取得起始日會計期間的起始日和截至日
   #CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(l_y1,l_m1,g_plant,g_ae.aea00) RETURNING l_flag,b_date,e_date
   ELSE
      CALL s_azm(l_y1,l_m1) RETURNING l_flag,b_date,e_date
   END IF
   #CHI-A70007 add --end--
   LET l_bal = 0
   LET l_bal1 = 0
   LET l_d = 0
   LET l_d1 = 0
   LET l_c = 0
   LET l_c1 = 0
   LET n_bal = 0
   LET n_bal1 = 0
 
   #會計科目余額檔
   SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
    WHERE aah01 = l_aea05
      AND aah02 = l_y1
      AND aah03 >= 0
      AND aah03 < l_m1
      AND aah00 = g_ae.aea00  #No.FUN-740033
   #會計傳票檔
   SELECT SUM(abb07) INTO l_d FROM abb_file,aba_file
    WHERE abb03 = l_aea05 AND aba01 = abb01 AND abb06='1'
      AND aba02 >= b_date
      AND aba02 < bdate
      AND abb00 = aba00
      AND aba00 = g_ae.aea00 AND abapost='Y'  #No.FUN-740033
#     AND aba03=yy AND aba04=mm  #CHI-710005
   SELECT SUM(abb07) INTO l_c FROM aba_file,abb_file
    WHERE abb03 = l_aea05 AND aba01 = abb01 AND abb06='2'
      AND aba02 >= b_date
      AND aba02 < bdate
      AND abb00 = aba00
      AND aba00 = g_ae.aea00 AND abapost='Y'  #No.FUN-740033
#     AND aba03=yy AND aba04=mm  #CHI-710005
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   IF cl_null(l_bal1) THEN LET l_bal1 = 0 END IF
   IF cl_null(n_bal) THEN LET n_bal = 0 END IF
   IF cl_null(n_bal1) THEN LET n_bal1 = 0 END IF
   IF cl_null(l_d) THEN LET l_d = 0 END IF
   IF cl_null(l_c) THEN LET l_c = 0 END IF
   IF cl_null(l_d1) THEN LET l_d1 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   LET l_bal = l_bal + l_d - l_c + l_bal1   # 期初余額
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   RETURN l_bal
END FUNCTION
#No.FUN-5A0072 --end--
#Patch....NO.TQC-610037 <001> #
