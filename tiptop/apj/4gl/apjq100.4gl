# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apjq100.4gl
# Descriptions...: WBS累計資源需求查詢作業
# Date & Author..: #No.FUN-790025 07/12/13 By douzh
# Modify ........: #No.FUN-830139 08/04/15 By douzh
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
# Modify.........: No.FUN-B80031 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjb01 LIKE pjb_file.pjb01,
    g_pjb02 LIKE pjb_file.pjb02,
    g_pja   RECORD LIKE pja_file.*,
    g_pjb   RECORD LIKE pjb_file.*,
    g_pjf DYNAMIC ARRAY OF RECORD
          pjf02   LIKE pjf_file.pjf02,
          pjf03   LIKE pjf_file.pjf03,
          pjf04   LIKE pjf_file.pjf04,
          ima25   LIKE ima_file.ima25,
          pjf05   LIKE pjf_file.pjf05,
          pjf06   LIKE pjf_file.pjf06 
        END RECORD,
    g_pjf_t RECORD
          pjf02   LIKE pjf_file.pjf02,
          pjf03   LIKE pjf_file.pjf03,
          pjf04   LIKE pjf_file.pjf04,
          ima25   LIKE ima_file.ima25,
          pjf05   LIKE pjf_file.pjf05,
          pjf06   LIKE pjf_file.pjf06 
        END RECORD,
    g_pjh DYNAMIC ARRAY OF RECORD
          pjh02   LIKE pjh_file.pjh02,
          cpi02   LIKE type_file.chr100,   #LIKE cpi_file.cpi02,   #TQC-B90211
          pjx02   LIKE pjx_file.pjx02,
          pjx03   LIKE pjx_file.pjx03,
          pjh03   LIKE pjh_file.pjh03,
          amt     LIKE pjx_file.pjx03
        END RECORD,
    g_pjh_t RECORD
          pjh02   LIKE pjh_file.pjh02,
          cpi02   LIKE type_file.chr100,   #LIKE cpi_file.cpi02,   #TQC-B90211
          pjx02   LIKE pjx_file.pjx02,
          pjx03   LIKE pjx_file.pjx03,
          pjh03   LIKE pjh_file.pjh03,
          amt     LIKE pjx_file.pjx03
        END RECORD,
    g_pjm DYNAMIC ARRAY OF RECORD
          pjm02   LIKE pjm_file.pjm02,
          pjy02   LIKE pjy_file.pjy02,
          pjm03   LIKE pjm_file.pjm03,
          pjy03   LIKE pjy_file.pjy03,
          pjy04   LIKE pjy_file.pjy04,
          pjm04   LIKE pjm_file.pjm04,
          amt_2   LIKE pjy_file.pjy04
        END RECORD,
    g_pjm_t RECORD
          pjm02   LIKE pjm_file.pjm02,
          pjy02   LIKE pjy_file.pjy02,
          pjm03   LIKE pjm_file.pjm03,
          pjy03   LIKE pjy_file.pjy03,
          pjy04   LIKE pjy_file.pjy04,
          pjm04   LIKE pjm_file.pjm04,
          amt_2   LIKE pjy_file.pjy04
        END RECORD,
    g_pjd DYNAMIC ARRAY OF RECORD
          pjd02   LIKE pjd_file.pjd02,
          azf03   LIKE azf_file.azf03,
          pjd03   LIKE pjd_file.pjd03,
          aag02   LIKE aag_file.aag02,
          pjd04   LIKE pjd_file.pjd04,
          aag02_2 LIKE aag_file.aag02,
          pjd05   LIKE pjd_file.pjd05
        END RECORD,
    g_pjd_t RECORD
          pjd02   LIKE pjd_file.pjd02,
          azf03   LIKE azf_file.azf03,
          pjd03   LIKE pjd_file.pjd03,
          aag02   LIKE aag_file.aag02,
          pjd04   LIKE pjd_file.pjd04,
          aag02_2 LIKE aag_file.aag02,
          pjd05   LIKE pjd_file.pjd05
        END RECORD 
DEFINE   g_tot          LIKE pjx_file.pjx03
DEFINE   g_tot_2        LIKE pjy_file.pjy04
DEFINE   g_tot_3        LIKE pjd_file.pjd05
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
DEFINE   g_wc2          STRING
DEFINE   l_bdate        LIKE type_file.dat
DEFINE   l_edate        LIKE type_file.dat
DEFINE   g_b_flag       LIKE type_file.chr1
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-B80031--l_time改用g_time--

    OPEN WINDOW q100_w WITH FORM "apj/42f/apjq100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL q100_menu()
    CLOSE WINDOW q100_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80031--l_time改用g_time--
END MAIN
 
#QBE 查詢資料
FUNCTION q100_cs()
   DEFINE   l_cnt   LIKE type_file.num5
   DEFINE   l_azp01 LIKE azp_file.azp01
   DEFINE   l_n     LIKE type_file.num5
   DEFINE   l_n1    LIKE type_file.num5
 
   CLEAR FORM
#  SELECT azp01 INTO l_azp01 FROM azp_file WHERE azp03 = g_dbs    #FUN-980020 mark
    CALL g_pjf.clear()
    CALL cl_opmsg('q')
 
    IF INT_FLAG THEN
       RETURN
    END IF 
  
    CONSTRUCT BY NAME g_wc ON pjb01,pjb02
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pjb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pjb01"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET g_pjb01 = g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb01
            WHEN INFIELD(pjb02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pjb02"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET g_pjb02 = g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb02
              OTHERWISE
                   EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION material        
         LET g_b_flag = '1'
    
      ON ACTION human      
         LET g_b_flag = '2'
 
      ON ACTION equipment        
         LET g_b_flag = '3'
 
      ON ACTION estimated       
         LET g_b_flag = '4'
 
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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjbuser', 'pjbgrup') #FUN-980030
 
     IF INT_FLAG OR g_action_choice = "exit" THEN
        RETURN
     END IF
 
     LET g_sql = "SELECT pjb01,pjb02 FROM pjb_file",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE q100_prepare FROM g_sql
     DECLARE q100_cs SCROLL CURSOR WITH HOLD FOR q100_prepare
 
     LET g_sql="SELECT COUNT(*) FROM pjb_file WHERE ",g_wc CLIPPED
     PREPARE q100_precount FROM g_sql
     DECLARE q100_count CURSOR FOR q100_precount
END FUNCTION
 
FUNCTION q100_menu()
 
   WHILE TRUE
 
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
      CASE g_b_flag
        WHEN '1'
          CALL q100_bp1("G")
        WHEN '2'
          CALL q100_bp2("G")
        WHEN '3'
          CALL q100_bp3("G")
        WHEN '4'
          CALL q100_bp4("G")
        OTHERWISE
          CALL q100_bp1("G")
      END CASE
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "material" 
            IF cl_chk_act_auth() THEN
               CALL q100_b_fill_1()
               LET g_b_flag = '1'
            END IF
         WHEN "human" 
            IF cl_chk_act_auth() THEN
               CALL q100_b_fill_2()
               LET g_b_flag = '2'
            END IF
         WHEN "equipment" 
            IF cl_chk_act_auth() THEN
               CALL q100_b_fill_3()
               LET g_b_flag = '3'
            END IF
         WHEN "estimated" 
            IF cl_chk_act_auth() THEN
               CALL q100_b_fill_4()
               LET g_b_flag = '4'
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjf),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q100_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q100_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_pjb.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pjb.* TO NULL
   ELSE
      OPEN q100_count
      FETCH q100_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q100_fetch('F')                   # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
 
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,    #處理方式     
            l_abso   LIKE type_file.num10    #絕對的筆數    
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q100_cs INTO g_pjb01,g_pjb02
      WHEN 'P' FETCH PREVIOUS q100_cs INTO g_pjb01,g_pjb02
      WHEN 'F' FETCH FIRST    q100_cs INTO g_pjb01,g_pjb02
      WHEN 'L' FETCH LAST     q100_cs INTO g_pjb01,g_pjb02
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
         FETCH ABSOLUTE g_jump q100_cs INTO g_pjb01,g_pjb02  
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_pjb.* TO NULL
      CALL g_pjf.clear()
      CALL g_pjh.clear()
      CALL g_pjm.clear()
      CALL g_pjd.clear()
      CALL cl_err(g_pjb01,SQLCA.sqlcode,0)
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
   END IF
 
     SELECT * INTO g_pjb.* FROM pjb_file WHERE pjb01 = g_pjb01 AND pjb02 = g_pjb02              
   CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
   DISPLAY g_pjb.pjb01,g_pjb.pjb02,g_pjb.pjb03 TO pjb01,pjb02,pjb03
    CALL q100_pja('d')
    CASE g_b_flag
        WHEN '1'
          CALL q100_b_fill_1()
        WHEN '2'
          CALL q100_b_fill_2()
        WHEN '3'
          CALL q100_b_fill_3()
        WHEN '4'
          CALL q100_b_fill_4()
        OTHERWISE
          CALL q100_b_fill_1()
    END CASE
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION q100_pja(p_cmd)
DEFINE  p_cmd   LIKE type_file.chr1
 
 SELECT pja02,pja14,pja15 INTO g_pja.pja02,g_pja.pja14,g_pja.pja15
    FROM pja_file 
   WHERE pja01 = g_pjb.pjb01
 
 DISPLAY BY NAME g_pja.pja02
 DISPLAY BY NAME g_pja.pja14
 DISPLAY BY NAME g_pja.pja15
 
END FUNCTION
 
FUNCTION q100_b_fill_1()   
   DEFINE  l_i             LIKE type_file.num5
 
   LET g_sql = "SELECT pjf02,pjf03,pjf04,'',pjf05,pjf06",
               " FROM pjf_file ",
               "WHERE pjf01 = '",g_pjb.pjb02,"'" 
                 
 
   PREPARE q100_p1 FROM g_sql
   DECLARE q100_cs1 CURSOR FOR q100_p1
 
   CALL g_pjf.clear() 
   LET g_rec_b = 0
   LET g_cnt=1 
 
   FOREACH q100_cs1 INTO g_pjf[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    SELECT ima25 INTO g_pjf[g_cnt].ima25 
     FROM ima_file WHERE ima01 =g_pjf[g_cnt].pjf03
    LET g_cnt=g_cnt+1
    IF g_cnt >g_max_rec THEN
       CALL cl_err('',9035,0)
       EXIT FOREACH
    END IF
 
   END FOREACH
 
   LET g_cnt= g_cnt-1
   LET g_rec_b=g_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
   
END FUNCTION
 
FUNCTION q100_b_fill_2()   
   DEFINE  l_i             LIKE type_file.num5
 
   LET g_sql = "SELECT pjh02,'','','',pjh03,''",
               " FROM pjh_file ",
               "WHERE pjh01 = '",g_pjb.pjb02,"'" 
                 
 
   PREPARE q100_p2 FROM g_sql
   DECLARE q100_cs2 CURSOR FOR q100_p2
 
   CALL g_pjh.clear() 
   LET g_rec_b = 0
   LET g_cnt=1 
 
   FOREACH q100_cs2 INTO g_pjh[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    SELECT pjx02,pjx03 INTO g_pjh[g_cnt].pjx02,g_pjh[g_cnt].pjx03
     FROM pjx_file WHERE pjx01 = g_pjh[g_cnt].pjh02
    LET g_pjh[g_cnt].amt = g_pjh[g_cnt].pjx03 * g_pjh[g_cnt].pjh03
    IF cl_null(g_pjh[g_cnt].amt) THEN LET g_pjh[g_cnt].amt = 0 END IF
    LET g_cnt=g_cnt+1
    IF g_cnt >g_max_rec THEN
       CALL cl_err('',9035,0)
       EXIT FOREACH
    END IF
 
   END FOREACH
 
   SELECT SUM(pjh03*pjx03) INTO g_tot
     FROM pjh_file,pjx_file 
    WHERE pjx01 = pjh02
      AND pjh01 = g_pjb.pjb02
   IF cl_null(g_tot) THEN LET g_tot = 0 END IF
   DISPLAY g_tot TO FORMONLY.tot
 
   LET g_cnt= g_cnt-1
   LET g_rec_b=g_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
   
END FUNCTION
 
FUNCTION q100_b_fill_3()   
   DEFINE  l_i             LIKE type_file.num5
 
   LET g_sql = "SELECT pjm02,'',pjm03,'','',pjm04,'' ",
               " FROM pjm_file ",
               "WHERE pjm01 = '",g_pjb.pjb02,"'" 
                 
 
   PREPARE q100_p3 FROM g_sql
   DECLARE q100_cs3 CURSOR FOR q100_p3
 
   CALL g_pjm.clear() 
   LET g_rec_b = 0
   LET g_cnt=1 
 
   FOREACH q100_cs3 INTO g_pjm[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    SELECT pjy02,pjy03,pjy04 INTO g_pjm[g_cnt].pjy02,
               g_pjm[g_cnt].pjy03,g_pjm[g_cnt].pjy04
     FROM pjy_file WHERE pjy01 = g_pjm[g_cnt].pjm02
    LET g_pjm[g_cnt].amt_2 = g_pjm[g_cnt].pjy04 * g_pjm[g_cnt].pjm04
    IF cl_null(g_pjm[g_cnt].amt_2) THEN LET g_pjm[g_cnt].amt_2 = 0 END IF
    LET g_cnt=g_cnt+1
    IF g_cnt >g_max_rec THEN
       CALL cl_err('',9035,0)
       EXIT FOREACH
    END IF
 
   END FOREACH
 
   SELECT SUM(pjy04*pjm04) INTO g_tot_2 FROM pjm_file,pjy_file
    WHERE pjy01=pjm02 AND pjm01=g_pjb.pjb02
   IF cl_null(g_tot_2) THEN LET g_tot_2 = 0 END IF
   DISPLAY g_tot_2 TO FORMONLY.tot_2
 
   LET g_cnt= g_cnt-1
   LET g_rec_b=g_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
   
END FUNCTION
 
FUNCTION q100_b_fill_4()   
   DEFINE  l_i             LIKE type_file.num5
 
   LET g_sql = "SELECT pjd02,'',pjd03,'',pjd04,'',pjd05 ",
               " FROM pjd_file ",
               "WHERE pjd01 = '",g_pjb.pjb02,"'" 
                 
 
   PREPARE q100_p4 FROM g_sql
   DECLARE q100_cs4 CURSOR FOR q100_p4
 
   CALL g_pjd.clear() 
   LET g_rec_b = 0
   LET g_cnt=1 
 
   FOREACH q100_cs4 INTO g_pjd[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    SELECT azf03 INTO g_pjd[g_cnt].azf03
     FROM azf_file WHERE azf01 = g_pjd[g_cnt].pjd02 AND azf02 = '2'
    SELECT aag02 INTO g_pjd[g_cnt].aag02
     FROM aag_file WHERE aag01 = g_pjd[g_cnt].pjd03 
                     AND aag00=g_aza.aza81
    SELECT aag02 INTO g_pjd[g_cnt].aag02_2
     FROM aag_file WHERE aag01 = g_pjd[g_cnt].pjd04
                     AND aag00=g_aza.aza81 
 
    LET g_cnt=g_cnt+1
    IF g_cnt >g_max_rec THEN
       CALL cl_err('',9035,0)
       EXIT FOREACH
    END IF
 
   END FOREACH
  
   SELECT SUM(pjd05) INTO g_tot_3 FROM pjd_file WHERE pjd01=g_pjb.pjb02
   IF cl_null(g_tot_3) THEN LET g_tot_3 = 0 END IF
   DISPLAY g_tot_3 TO FORMONLY.tot_3
 
   LET g_cnt= g_cnt-1
   LET g_rec_b=g_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt=0
   
END FUNCTION
 
FUNCTION q100_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pjf TO s_pjf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION first
         CALL q100_fetch('F')
         EXIT DISPLAY
         CALL q100_bp1_refresh()
 
      ON ACTION previous
         CALL q100_fetch('P')
         EXIT DISPLAY
         CALL q100_bp1_refresh()
 
      ON ACTION jump
         CALL q100_fetch('/')
         EXIT DISPLAY
         CALL q100_bp1_refresh()
 
      ON ACTION next
         CALL q100_fetch('N')
         EXIT DISPLAY
         CALL q100_bp1_refresh()
 
      ON ACTION last
         CALL q100_fetch('L')
         EXIT DISPLAY
         CALL q100_bp1_refresh()
 
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION material        
         LET g_action_choice = 'material'
         EXIT DISPLAY
    
      ON ACTION human      
         LET g_action_choice = 'human'
         EXIT DISPLAY
 
      ON ACTION equipment        
         LET g_action_choice = 'equipment'
         EXIT DISPLAY
 
      ON ACTION estimated       
         LET g_action_choice = 'estimated'
         EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q100_bp1_refresh()
   DISPLAY ARRAY g_pjf TO s_pjf.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q100_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pjh TO s_pjh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION first
         CALL q100_fetch('F')
         EXIT DISPLAY
         CALL q100_bp2_refresh()
 
      ON ACTION previous
         CALL q100_fetch('P')
         EXIT DISPLAY
         CALL q100_bp2_refresh()
 
      ON ACTION jump
         CALL q100_fetch('/')
         EXIT DISPLAY
         CALL q100_bp2_refresh()
 
      ON ACTION next
         CALL q100_fetch('N')
         EXIT DISPLAY
         CALL q100_bp2_refresh()
 
      ON ACTION last
         CALL q100_fetch('L')
         EXIT DISPLAY
         CALL q100_bp2_refresh()
 
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION material        
         LET g_action_choice = 'material'
         EXIT DISPLAY
    
      ON ACTION human      
         LET g_action_choice = 'human'
         EXIT DISPLAY
 
      ON ACTION equipment        
         LET g_action_choice = 'equipment'
         EXIT DISPLAY
 
      ON ACTION estimated       
         LET g_action_choice = 'estimated'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q100_bp2_refresh()
   DISPLAY ARRAY g_pjh TO s_pjh.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q100_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pjm TO s_pjm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION first
         CALL q100_fetch('F')
         EXIT DISPLAY
         CALL q100_bp3_refresh()
 
      ON ACTION previous
         CALL q100_fetch('P')
         EXIT DISPLAY
         CALL q100_bp3_refresh()
 
      ON ACTION jump
         CALL q100_fetch('/')
         EXIT DISPLAY
         CALL q100_bp3_refresh()
 
      ON ACTION next
         CALL q100_fetch('N')
         EXIT DISPLAY
         CALL q100_bp3_refresh()
 
      ON ACTION last
         CALL q100_fetch('L')
         EXIT DISPLAY
         CALL q100_bp3_refresh()
 
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION material        
         LET g_action_choice = 'material'
         EXIT DISPLAY
    
      ON ACTION human      
         LET g_action_choice = 'human'
         EXIT DISPLAY
 
      ON ACTION equipment        
         LET g_action_choice = 'equipment'
         EXIT DISPLAY
 
      ON ACTION estimated       
         LET g_action_choice = 'estimated'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q100_bp3_refresh()
   DISPLAY ARRAY g_pjm TO s_pjm.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q100_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("pjg04,aag02_2",FALSE)
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pjd TO s_pjd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION first
         CALL q100_fetch('F')
         EXIT DISPLAY
         CALL q100_bp4_refresh()
 
      ON ACTION previous
         CALL q100_fetch('P')
         EXIT DISPLAY
         CALL q100_bp4_refresh()
 
      ON ACTION jump
         CALL q100_fetch('/')
         EXIT DISPLAY
         CALL q100_bp4_refresh()
 
      ON ACTION next
         CALL q100_fetch('N')
         EXIT DISPLAY
         CALL q100_bp4_refresh()
 
      ON ACTION last
         CALL q100_fetch('L')
         EXIT DISPLAY
         CALL q100_bp4_refresh()
 
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION material        
         LET g_action_choice = 'material'
         EXIT DISPLAY
    
      ON ACTION human      
         LET g_action_choice = 'human'
         EXIT DISPLAY
 
      ON ACTION equipment        
         LET g_action_choice = 'equipment'
         EXIT DISPLAY
 
      ON ACTION estimated       
         LET g_action_choice = 'estimated'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q100_bp4_refresh()
   DISPLAY ARRAY g_pjf TO s_pjd.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
#No.FUN-790025
#No.FUN-830139
