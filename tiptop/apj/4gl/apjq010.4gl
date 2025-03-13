# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apjq010.4gl
# Descriptions...: 項目材料成本查詢作業
# Date & Author..: No.FUN-790025 08/02/22 By Zhangyajun
# Modify.........: No.TQC-850002 08/05/02 By douzh 查詢筆數顯示修改和查詢資料SUM錯誤處理
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ccc02 LIKE ccc_file.ccc02,
    g_ccc03 LIKE ccc_file.ccc03,
    g_ccc08 LIKE ccc_file.ccc08,
    g_ccc DYNAMIC ARRAY OF RECORD
          ccc01     LIKE ccc_file.ccc01,
          ccc61     LIKE ccc_file.ccc61,
          cost_up   LIKE ccc_file.ccc62,
          ccc62     LIKE ccc_file.ccc62,
          ccc91     LIKE ccc_file.ccc91,
          ccc92     LIKE ccc_file.ccc92,
          sum_qty   LIKE ccc_file.ccc61,
          sum_cost  LIKE ccc_file.ccc62
        END RECORD,
    g_ccc_t RECORD
          ccc01     LIKE ccc_file.ccc01,
          ccc61     LIKE ccc_file.ccc61,
          cost_up   LIKE ccc_file.ccc62,
          ccc62     LIKE ccc_file.ccc62,
          ccc91     LIKE ccc_file.ccc91,
          ccc92     LIKE ccc_file.ccc92,
          sum_qty   LIKE ccc_file.ccc61,
          sum_cost  LIKE ccc_file.ccc62 
        END RECORD
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10 
DEFINE   g_no_ask      LIKE type_file.num5      
DEFINE   l_ac           LIKE type_file.num10 
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10      
DEFINE   g_sql          STRING
DEFINE   g_wc           STRING
 
MAIN
   OPTIONS                                #改變一些系統的預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵，由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW q010_w WITH FORM "apj/42f/apjq010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL q010_menu()
    CLOSE WINDOW q010_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q010_cs()
    CLEAR FORM
    CALL g_ccc.clear()
    CALL cl_opmsg('q')
 
    IF INT_FLAG THEN
       RETURN
    END IF 
  
    CONSTRUCT BY NAME g_wc ON ccc02,ccc03,ccc08,
                              ccc01,ccc61,ccc62,ccc91,
                              ccc92
     BEFORE CONSTRUCT
          CALL cl_qbe_init()
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ccc08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pja"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccc08    
               NEXT FIELD ccc08   
            WHEN INFIELD(ccc01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ima"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccc01    
               NEXT FIELD ccc01     
              OTHERWISE
                   EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
 
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
 
     END CONSTRUCT   
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cccuser', 'cccgrup') #FUN-980030
   
    IF INT_FLAG THEN 
        RETURN
    END IF
 
#    LET g_sql=
#        "SELECT ROWID,ccc02,ccc03,ccc08",
#        " FROM ccc_file",
#        " WHERE ccc07 = '4' AND ",g_wc CLIPPED,
#        " ORDER BY ccc02,ccc03,ccc08"
 
    LET g_sql=                                                                                                                     
        "SELECT UNIQUE ccc02,ccc03,ccc08",                                                                                          
        " FROM ccc_file,pja_file",                                                                                                          
        " WHERE ccc07 = '4' AND ccc08 = pja01 AND ",g_wc CLIPPED,                                                                                    
        " ORDER BY ccc02,ccc03,ccc08" 
    PREPARE q010_prepare FROM g_sql
    DECLARE q010_cs SCROLL CURSOR WITH HOLD FOR q010_prepare
 
    LET g_sql = "SELECT UNIQUE ccc02,ccc03,ccc08 FROM ccc_file,pja_file", 
                " WHERE ccc07 = '4' AND ccc08 = pja01 AND ",g_wc CLIPPED,  
                " INTO TEMP x"   
    DROP TABLE x
    PREPARE q010_precount_x FROM g_sql
    EXECUTE q010_precount_x
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE q010_precount FROM g_sql
    DECLARE q010_count CURSOR FOR q010_precount
 
END FUNCTION
 
FUNCTION q010_menu()
 
   WHILE TRUE
      CALL q010_bp("G")
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q010_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ccc),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q010_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q010_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_ccc02,g_ccc03,g_ccc08 TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN q010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ccc02,g_ccc03,g_ccc08 TO NULL
   ELSE
      OPEN q010_count
      FETCH q010_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q010_fetch('F')                   # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
 
END FUNCTION
 
FUNCTION q010_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,    #處理方式     
            l_abso   LIKE type_file.num10    #絕對的筆數    
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q010_cs INTO g_ccc02,g_ccc03,g_ccc08
      WHEN 'P' FETCH PREVIOUS q010_cs INTO g_ccc02,g_ccc03,g_ccc08
      WHEN 'F' FETCH FIRST    q010_cs INTO g_ccc02,g_ccc03,g_ccc08
      WHEN 'L' FETCH LAST     q010_cs INTO g_ccc02,g_ccc03,g_ccc08
      WHEN '/'
         IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0 
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump q010_cs INTO g_ccc02,g_ccc03,g_ccc08
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_ccc02,g_ccc03,g_ccc08 TO NULL
      CALL cl_err('fetch: ',SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   SELECT UNIQUE ccc02,ccc03,ccc08 INTO g_ccc02,g_ccc03,g_ccc08 FROM ccc_file WHERE ccc02 = g_ccc02 AND ccc03 = g_ccc03 AND ccc08 = g_ccc08
   IF SQLCA.sqlcode THEN
      INITIALIZE g_ccc02,g_ccc03,g_ccc08 TO NULL
      CALL cl_err3("sel","ccc_file",g_ccc02,g_ccc03,SQLCA.sqlcode,"","",0)   #No.FUN-660128
      RETURN
   END IF
   CALL q010_show()
END FUNCTION
 
FUNCTION q010_show()
    DISPLAY  g_ccc02,g_ccc03,g_ccc08 TO ccc02,ccc03,ccc08
    CALL q010_ccc08('d')
    CALL q010_b_fill(g_wc)
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION q010_ccc08(p_cmd)
DEFINE  p_cmd   LIKE type_file.chr1
DEFINE  l_pja02 LIKE pja_file.pja02
 
 LET g_errno = ''
 SELECT pja02 INTO l_pja02
    FROM pja_file
    WHERE pja01 = g_ccc08
 CASE 
   WHEN SQLCA.sqlcode = 100 LET g_errno = 'apj-005'
                            LET l_pja02 = NULL
   OTHERWISE LET g_errno = SQLCA.sqlcode USING '------'
 END CASE
 IF p_cmd = 'u' OR cl_null(g_errno) THEN
    DISPLAY l_pja02 TO pja02
 END IF
 
END FUNCTION
 
FUNCTION q010_b_fill(p_wc)   
#   DEFINE  p_wc            LIKE type_file.chr1000
   DEFINE  p_wc            STRING     #NO.FUN-910082
   DEFINE  l_i             LIKE type_file.num5
   DEFINE  l_ccc91         LIKE ccc_file.ccc91  
   DEFINE  l_ccc92         LIKE ccc_file.ccc92  
   DEFINE  l_cch91         LIKE cch_file.cch91  
   DEFINE  l_cch92         LIKE cch_file.cch92  
 
   LET g_cnt=1 
 
   LET g_sql = "SELECT ccc01,'','','','','','',''",
               " FROM ccc_file ",
               "WHERE ccc07 = '4' AND ccc02 = ",g_ccc02,
               " AND ccc03 = ",g_ccc03," AND ccc08 = '",g_ccc08 CLIPPED,"'"   
IF NOT cl_null(p_wc) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc CLIPPED
   END IF
   PREPARE q010_p1 FROM g_sql
   DECLARE q010_cs1 CURSOR FOR q010_p1
   FOREACH q010_cs1 INTO g_ccc[g_cnt].*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach: ',SQLCA.sqlcode,1)
         EXIT FOREACH 
      END IF
 
      SELECT SUM(ccc61),SUM(ccc62),SUM(ccc91),SUM(ccc92)
             INTO g_ccc[g_cnt].ccc61,g_ccc[g_cnt].ccc62,l_ccc91,l_ccc92
             FROM ccc_file 
             WHERE ccc01 = g_ccc[g_cnt].ccc01 AND ccc02 = g_ccc02 AND ccc03 = g_ccc03
               AND ccc08 = g_ccc08 AND ccc07 = '4'
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','ccc_file',g_ccc[g_cnt].ccc01,'',SQLCA.sqlcode,'','',0)
         INITIALIZE g_ccc[g_cnt].ccc61,g_ccc[g_cnt].ccc62,l_ccc91,l_ccc92 TO NULL
      END IF
      IF l_ccc91 IS NULL THEN LET l_ccc91 = 0 END IF
      IF l_ccc92 IS NULL THEN LET l_ccc92 = 0 END IF
      SELECT SUM(cch91),SUM(cch92)
             INTO l_cch91,l_cch92
             FROM cch_file 
             WHERE cch01 = g_ccc[g_cnt].ccc01 AND cch02 = g_ccc02 AND cch03 = g_ccc03
               AND cch07 = g_ccc08 AND cch06 = '4'
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','cch_file',g_ccc[g_cnt].ccc01,'',SQLCA.sqlcode,'','',0)
         INITIALIZE l_cch91,l_cch92 TO NULL
      END IF
      IF l_cch91 IS NULL THEN LET l_cch91 = 0 END IF
      IF l_cch92 IS NULL THEN LET l_cch92 = 0 END IF
      LET g_ccc[g_cnt].ccc91= l_ccc91+l_cch91
      LET g_ccc[g_cnt].ccc92= l_ccc92+l_cch92
#No.TQC-850002--end
      IF g_ccc[g_cnt].ccc61 IS NULL THEN LET g_ccc[g_cnt].ccc61 = 0 END IF
      IF g_ccc[g_cnt].ccc62 IS NULL THEN LET g_ccc[g_cnt].ccc62 = 0 END IF
      IF g_ccc[g_cnt].ccc91 IS NULL THEN LET g_ccc[g_cnt].ccc91 = 0 END IF
      IF g_ccc[g_cnt].ccc92 IS NULL THEN LET g_ccc[g_cnt].ccc92 = 0 END IF
      LET g_ccc[g_cnt].cost_up=g_ccc[g_cnt].ccc62/g_ccc[g_cnt].ccc61
      LET l_i = g_cnt - 1
      LET g_ccc[1].sum_qty = g_ccc[1].ccc61
      LET g_ccc[1].sum_cost = g_ccc[1].ccc62  
      WHILE l_i>=1
      LET g_ccc[g_cnt].sum_qty = g_ccc[g_cnt-1].sum_qty + g_ccc[g_cnt].ccc61
      LET g_ccc[g_cnt].sum_cost = g_ccc[g_cnt-1].sum_cost + g_ccc[g_cnt].ccc62
      LET l_i = l_i-1
      END WHILE
      LET g_cnt=g_cnt+1
      IF g_cnt >g_max_rec THEN
       CALL cl_err('',9035,0)
       EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_ccc.deleteElement(g_cnt)
   LET g_cnt= g_cnt-1
   LET g_rec_b=g_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
   
END FUNCTION
 
FUNCTION q010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ccc TO s_ccc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION first
         CALL q010_fetch('F')
         EXIT DISPLAY
         CALL q010_bp_refresh()
 
      ON ACTION previous
         CALL q010_fetch('P')
         EXIT DISPLAY
         CALL q010_bp_refresh()
 
      ON ACTION jump
         CALL q010_fetch('/')
         EXIT DISPLAY
         CALL q010_bp_refresh()
 
      ON ACTION next
         CALL q010_fetch('N')
         EXIT DISPLAY
         CALL q010_bp_refresh()
 
      ON ACTION last
         CALL q010_fetch('L')
         EXIT DISPLAY
         CALL q010_bp_refresh()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q010_bp_refresh()
   DISPLAY ARRAY g_ccc TO s_ccc.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
#No.FUN-790025
