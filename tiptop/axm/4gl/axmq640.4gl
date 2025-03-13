# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmq640.4gl
# Descriptions...: 借貨查詢
# Date & Author..: No.FUN-740016 07/04/18 By Nicola
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0365 10/12/01 By lixh1 顯示筆數
# Modify.........: No.TQC-BB0215 12/01/05 By SunLM 增加欄位開窗
# Modify.........: No.TQC-C90074 12/09/14 By Dongsz 借貨查詢oea01開窗直接查詢的是借貨訂單。
# Modify.........: No.TQC-C90094 12/09/21 By dongsz oea01開窗改為q_oea11_1 
 
DATABASE ds 
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              #wc        LIKE type_file.chr1000
               wc         STRING       #NO.FUN-910082
           END RECORD,
       g_oeb DYNAMIC ARRAY OF RECORD
               oeb01   LIKE oeb_file.oeb01,
               oeb03   LIKE oeb_file.oeb03,
               oeb04   LIKE oeb_file.oeb04,
               oeb06   LIKE oeb_file.oeb06,
               ima021  LIKE ima_file.ima021,
               oeb05   LIKE oeb_file.oeb05,
               oeb24   LIKE oeb_file.oeb24,
               oeb25   LIKE oeb_file.oeb25,
               oeb29   LIKE oeb_file.oeb29,
               unqty   LIKE oeb_file.oeb24,
               oeb30   LIKE oeb_file.oeb30
           END RECORD,
       g_argv1         LIKE oea_file.oea01,
       g_sql           STRING,
       g_rec_b         LIKE type_file.num10
DEFINE p_row,p_col     LIKE type_file.num5 
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_msg           LIKE type_file.chr1000,
       l_ac            LIKE type_file.num5
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
 
MAIN   #No.FUN-740016
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time
 
   LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q640_w AT p_row,p_col
     WITH FORM "axm/42f/axmq640"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN 
      CALL q640_q()
   END IF
 
   CALL q640_menu()
 
   CLOSE WINDOW q640_w
 
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION q640_cs()
   DEFINE l_cnt   LIKE type_file.num5
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "oea01 = '",g_argv1,"'"
   ELSE
      CLEAR FORM 
      CALL g_oeb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL                  # Default condition
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B003
 
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oeb04,oeb30
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
# TQC-BB0215 add begin
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(oea01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_oea11"                        #No.TQC-C90094 mark
                LET g_qryparam.form ="q_oea11_1"                      #No.TQC-C90094 add
                LET g_qryparam.where = "( oea00='8' OR oea00='9')"    #No.TQC-C90074 add
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea01
                NEXT FIELD oea01
              WHEN INFIELD(oea03)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea03  
                   NEXT FIELD oea03  
              WHEN INFIELD(oeb04)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   IF g_aza.aza50='Y' THEN
                      LET g_qryparam.form ="q_ima15"   
                   ELSE
                      LET g_qryparam.form ="q_ima"   
                   END IF
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeb04
                   NEXT FIELD oeb04
            END CASE
# TQC-BB0215 add end 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
   END IF
 
  ##資料權限的檢查
  #IF g_priv2='4' THEN#只能使用自己的資料
  #   LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
  #END IF
 
  #IF g_priv3='4' THEN#只能使用相同群的資料
  #  LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
  #END IF
 
  #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #  LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
  #END IF
 
  #LET g_sql = g_sql clipped," ORDER BY occ01"
 
  #PREPARE q640_prepare FROM g_sql
  #DECLARE q640_cs                         #SCROLL CURSOR
  #        SCROLL CURSOR FOR q640_prepare
 
  ## 取合乎條件筆數
  ##若使用組合鍵值, 則可以使用本方法去得到筆數值
  #LET g_sql=" SELECT COUNT(*) FROM occ_file ",
  #           " WHERE ",tm.wc CLIPPED
  ##資料權限的檢查
  #IF g_priv2='4' THEN#只能使用自己的資料
  #   LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
  #END IF
  #IF g_priv3='4' THEN#只能使用相同群的資料
  #  LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
  #END IF
 
  #IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #  LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
  #END IF
 
  #PREPARE q640_pp  FROM g_sql
  #DECLARE q640_cnt   CURSOR FOR q640_pp
END FUNCTION
 
FUNCTION q640_menu()
 
   WHILE TRUE
      CALL q640_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q640_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q640_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL q640_cs()
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL q640_b_fill() #單身
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION q640_b_fill() 
   #DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_sql      STRING       #TQC-BB0215
 
   LET l_sql = "SELECT oeb01,oeb03,oeb04,oeb06,'',oeb05,oeb24,oeb25,",
        "       oeb29,0,oeb30 ",
        "  FROM oea_file,oeb_file ",
        " WHERE oea01 =oeb01",
        "   AND oeaconf = 'Y' ",
        "   AND oea00 ='8'",
        "   AND ",tm.wc,
        " ORDER BY oeb01"
    PREPARE q640_pb FROM l_sql
    DECLARE q640_bcs CURSOR WITH HOLD FOR q640_pb
 
    CALL g_oeb.clear()
    LET g_cnt = 1
 
    FOREACH q640_bcs INTO g_oeb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       SELECT ima021 INTO g_oeb[g_cnt].ima021 FROM ima_file
        WHERE ima01 = g_oeb[g_cnt].oeb04
 
       IF g_oeb[g_cnt].oeb24 IS NULL THEN LET g_oeb[g_cnt].oeb24 = 0 END IF
       IF g_oeb[g_cnt].oeb25 IS NULL THEN LET g_oeb[g_cnt].oeb25 = 0 END IF
       IF g_oeb[g_cnt].oeb29 IS NULL THEN LET g_oeb[g_cnt].oeb29 = 0 END IF
       LET g_oeb[g_cnt].unqty = g_oeb[g_cnt].oeb24 -
                                g_oeb[g_cnt].oeb25 - g_oeb[g_cnt].oeb29
 
       LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_oeb.deleteElement(g_cnt)       #TQC-AB0365
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cnt       #TQC-AB0365
 
END FUNCTION
 
FUNCTION q640_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont() 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
