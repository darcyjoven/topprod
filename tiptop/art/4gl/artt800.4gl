# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: artt800.4gl
# Descriptions...: 專櫃抽成資料建立作業
# Date & Author..: NO.FUN-B50005 11/05/04 By baogc 

# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.TQC-B80099 11/08/10 By lixia 查詢增加審核人員簡稱顯示
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CC0116 12/12/21 By xumeimei 隐藏产品分群类型相关的栏位和第二个单身
# Modify.........: No.CHI-D20015 13/03/27 By minpp 將確認人，確認日期改為確認異動人員，確認異動日期，取消審核時，回寫確認異動人員及日期
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_rca         RECORD LIKE rca_file.*,
       g_rca_t       RECORD LIKE rca_file.*,
       g_rca_o       RECORD LIKE rca_file.*,
       g_rcb         DYNAMIC ARRAY OF RECORD
           rcb04       LIKE rcb_file.rcb04,
           rcb05       LIKE rcb_file.rcb05,
           rcb05_desc  LIKE tqa_file.tqa02,
           rcb06       LIKE rcb_file.rcb06,
           rcb07       LIKE rcb_file.rcb07,
           rcb08       LIKE rcb_file.rcb08,
           rcb09       LIKE rcb_file.rcb09,
           rcbacti     LIKE rcb_file.rcbacti
                     END RECORD,
       g_rcb_t       RECORD
           rcb04       LIKE rcb_file.rcb04,
           rcb05       LIKE rcb_file.rcb05,
           rcb05_desc  LIKE tqa_file.tqa02,
           rcb06       LIKE rcb_file.rcb06,
           rcb07       LIKE rcb_file.rcb07,
           rcb08       LIKE rcb_file.rcb08,
           rcb09       LIKE rcb_file.rcb09,
           rcbacti     LIKE rcb_file.rcbacti
                     END RECORD,
       g_rcb_o       RECORD 
           rcb04       LIKE rcb_file.rcb04,
           rcb05       LIKE rcb_file.rcb05,
           rcb05_desc  LIKE tqa_file.tqa02,
           rcb06       LIKE rcb_file.rcb06,
           rcb07       LIKE rcb_file.rcb07,
           rcb08       LIKE rcb_file.rcb08,
           rcb09       LIKE rcb_file.rcb09,
           rcbacti     LIKE rcb_file.rcbacti
                     END RECORD,
       g_rcc         DYNAMIC ARRAY OF RECORD
           rcc05       LIKE rcc_file.rcc05,
           rcc06       LIKE rcc_file.rcc06,
           rcc06_desc  LIKE tqa_file.tqa02,
           rccacti     LIKE rcc_file.rccacti  
                     END RECORD,
       g_rcc_t       RECORD
           rcc05       LIKE rcc_file.rcc05,
           rcc06       LIKE rcc_file.rcc06,
           rcc06_desc  LIKE tqa_file.tqa02,
           rccacti     LIKE rcc_file.rccacti  
                     END RECORD,
       g_rcc_o       RECORD
           rcc05       LIKE rcc_file.rcc05,
           rcc06       LIKE rcc_file.rcc06,
           rcc06_desc  LIKE tqa_file.tqa02,
           rccacti     LIKE rcc_file.rccacti  
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_flag              LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_azw02             LIKE azw_file.azw02
DEFINE l_azw08             LIKE azw_file.azw08
DEFINE l_n                 LIKE type_file.num5

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM rca_file WHERE rca01 = ? AND rca02 = ? AND rca03 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t800_w AT p_row,p_col WITH FORM "art/42f/artt800"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("ds4",FALSE)                       #FUN-CC0116 add
   CALL cl_set_comp_visible("rca04,rcb06,rcb07,rcb09",FALSE)   #FUN-CC0116 add
   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("rcapos",TRUE)
   ELSE
      CALL cl_set_comp_visible("rcapos",FALSE)
   END IF
   SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = g_plant
   CALL t800_menu()
   CLOSE WINDOW t800_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t800_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   DEFINE l_rca04     LIKE rca_file.rca04
 
   CLEAR FORM 
   CALL g_rcb.clear()
   CALL g_rcc.clear()

      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rca.* TO NULL
      CONSTRUCT BY NAME g_wc ON rca01,rca02,rca03,rca04,rcapos,rcaconf,rcacond,rcacont,
                                rcaconu,rca05,rcauser,rcagrup,rcaoriu,rcamodu,
                                rcadate,rcaorig,rcaacti,rcacrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         AFTER CONSTRUCT
            LET l_rca04 = GET_FLDBUF(rca04)
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rca01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azw"
                  LET g_qryparam.where = "azw01 IN (SELECT azw01 FROM azw_file ",
                                         "           WHERE azw02 = '",g_azw02,"') ",
                                         "  AND azwacti = 'Y'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rca01
                  NEXT FIELD rca01
      
               WHEN INFIELD(rcaconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_gen"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rcaconu                                                                              
                  NEXT FIELD rcaconu
                  
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
      
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rcauser', 'rcagrup')
 
      CONSTRUCT g_wc1 ON rcb04,rcb05,rcb06,rcb07,rcb08,rcb09,rcbacti
              FROM s_rcb[1].rcb04,s_rcb[1].rcb05,s_rcb[1].rcb06,
                   s_rcb[1].rcb07,s_rcb[1].rcb08,s_rcb[1].rcb09,
                   s_rcb[1].rcbacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(rcb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 = "29"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcb05
                  NEXT FIELD rcb05

               OTHERWISE EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
       END CONSTRUCT
   
       IF INT_FLAG THEN
          RETURN
       END IF 

       CONSTRUCT g_wc2 ON rcc05,rcc06,rccacti
              FROM s_rcc[1].rcc05,s_rcc[1].rcc06,
                   s_rcc[1].rccacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rcc06)
                  IF NOT cl_null(l_rca04) THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     CASE l_rca04
                        WHEN '1'
                           LET g_qryparam.form = "q_oba_11"
                        WHEN '2'
                           LET g_qryparam.form = "q_tqa"
                           LET g_qryparam.arg1 = "2"
                        WHEN '3'
                           LET g_qryparam.form = "q_tqa"
                           LET g_qryparam.arg1 = "3"
                        WHEN '4'
                           LET g_qryparam.form = "q_tqa"
                           LET g_qryparam.arg1 = "1"
                        WHEN '5'
                           LET g_qryparam.form = "q_tqa"
                           LET g_qryparam.arg1 = "4"
                        WHEN '6'
                           LET g_qryparam.form = "q_tqa"
                           LET g_qryparam.arg1 = "5"
                        WHEN '7'
                           LET g_qryparam.form = "q_tqa"
                           LET g_qryparam.arg1 = "6"
                     END CASE
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rcc06
                     NEXT FIELD rcc06 
                  ELSE 
                     CALL cl_err('','art-715',1)
                     NEXT FIELD rcc06
                  END IF
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
       END CONSTRUCT     

       IF INT_FLAG THEN 
          RETURN
       END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    LET g_wc  = g_wc  CLIPPED

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF

    LET g_sql = "SELECT DISTINCT rca01,rca02,rca03 ",
                "  FROM rca_file LEFT OUTER JOIN rcb_file ",
                "       ON (rca01=rcb01 AND rca02=rcb02 AND rca03=rcb03) ",
                "  LEFT OUTER JOIN rcc_file ON ( rcb01=rcc01 AND rcb02=rcc02 ",
                "   AND rcb03=rcc03 AND rcb04=rcc04 ) ",
                " WHERE ", g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED,
                "   AND rca01 IN (",
                "SELECT azw01 FROM azw_file WHERE azw02 = '",g_azw02,"')",
                " ORDER BY rca01"
    PREPARE t800_prepare FROM g_sql
    DECLARE t800_cs
       SCROLL CURSOR WITH HOLD FOR t800_prepare
       
    LET g_sql = "SELECT COUNT(DISTINCT rca01||rca02||rca03) ",
                "  FROM rca_file LEFT OUTER JOIN rcb_file ",
                "       ON (rca01=rcb01 AND rca02=rcb02 AND rca03=rcb03) ",
                "  LEFT OUTER JOIN rcc_file ON ( rcb01=rcc01 AND rcb02=rcc02 ",
                "   AND rcb03=rcc03 AND rcb04=rcc04 ) ",
                " WHERE ", g_wc CLIPPED," AND ",g_wc1 CLIPPED," AND ",g_wc2 CLIPPED,
                "   AND rca01 IN (",
                "SELECT azw01 FROM azw_file WHERE azw02 = '",g_azw02,"')",
                " ORDER BY rca01"

    PREPARE t800_precount FROM g_sql
    DECLARE t800_count CURSOR FOR t800_precount
 
END FUNCTION
 
FUNCTION t800_menu()
 
   WHILE TRUE
      CALL t800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t800_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t800_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t800_x()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b = '1' THEN
                  CALL t800_b1()
               ELSE
                  CALL t800_b2()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t800_yes()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t800_w()
            END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rcb),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rca.rca01 IS NOT NULL THEN
                 LET g_doc.column1 = "rca01"
                 LET g_doc.value1 = g_rca.rca01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rcb TO s_rcb.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL t800_b2_fill("1=1")
            CALL cl_show_fld_cont()
 
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
 
         ON ACTION first
            CALL t800_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t800_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t800_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t800_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t800_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            LET l_ac1 = 1
            EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG

         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
 
         AFTER DISPLAY
            CONTINUE DIALOG
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
    
      DISPLAY ARRAY g_rcc TO s_rcc.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
 
         ON ACTION first
            CALL t800_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t800_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t800_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t800_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t800_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = 1
            EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG

         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t800_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rcb.clear()
   CALL g_rcc.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t800_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rca.* TO NULL
      RETURN
   END IF
 
   OPEN t800_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rca.* TO NULL
   ELSE
      OPEN t800_count
      FETCH t800_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t800_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t800_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t800_cs INTO g_rca.rca01,g_rca.rca02,g_rca.rca03
      WHEN 'P' FETCH PREVIOUS t800_cs INTO g_rca.rca01,g_rca.rca02,g_rca.rca03
      WHEN 'F' FETCH FIRST    t800_cs INTO g_rca.rca01,g_rca.rca02,g_rca.rca03
      WHEN 'L' FETCH LAST     t800_cs INTO g_rca.rca01,g_rca.rca02,g_rca.rca03
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION HELP
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
        END IF
        FETCH ABSOLUTE g_jump t800_cs INTO g_rca.rca01,g_rca.rca02,g_rca.rca03
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
      INITIALIZE g_rca.* TO NULL
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
 
   SELECT * INTO g_rca.* FROM rca_file 
    WHERE rca02 = g_rca.rca02 AND rca01 = g_rca.rca01
      AND rca03 = g_rca.rca03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rca_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rca.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rca.rcauser
   LET g_data_group = g_rca.rcagrup
 
   CALL t800_show()
 
END FUNCTION
 
FUNCTION t800_show()
   DEFINE l_gen02    LIKE gen_file.gen02   #TQC-B80099
 
   LET l_ac = 1
   LET g_rca_t.* = g_rca.*
   LET g_rca_o.* = g_rca.*
   DISPLAY BY NAME g_rca.rca01,g_rca.rca02,g_rca.rca03,g_rca.rcapos,  
                   g_rca.rca04,g_rca.rca05,g_rca.rcaconf,
                   g_rca.rcacond,g_rca.rcacont,g_rca.rcaconu,
                   g_rca.rcaoriu,g_rca.rcaorig,g_rca.rcauser,
                   g_rca.rcamodu,g_rca.rcaacti,g_rca.rcagrup,
                   g_rca.rcadate,g_rca.rcacrat

   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_rca.rca01 AND azwacti = 'Y'
   DISPLAY l_azw08 TO FORMONLY.rca01_desc
   #TQC-B80099--add--str--
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rca.rcaconu
   DISPLAY l_gen02 TO FORMONLY.rcaconu_desc
   #TQC-B80099--add--end--
   CALL t800_b1_fill(g_wc1)
   CALL t800_b2_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t800_b1_fill(p_wc1)
DEFINE p_wc1   STRING
 
   LET g_sql = "SELECT rcb04,rcb05,'',rcb06,rcb07,rcb08,rcb09, ",
               "       rcbacti ", 
               "  FROM rcb_file",
               " WHERE rcb02 = '",g_rca.rca02,"' AND rcb01 ='",g_rca.rca01,"' ",
               "   AND rcb03 = '",g_rca.rca03,"'"
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rcb04 "
 
   DISPLAY g_sql
 
   PREPARE t800_pb FROM g_sql
   DECLARE rcb_cs CURSOR FOR t800_pb
 
   CALL g_rcb.clear()
   LET g_cnt = 1
 
   FOREACH rcb_cs INTO g_rcb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT tqa02 INTO g_rcb[g_cnt].rcb05_desc FROM tqa_file
        WHERE tqa01 = g_rcb[g_cnt].rcb05
          AND tqa03 = '29' AND tqaacti = 'Y'
         
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rcb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t800_b2_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rcc05,rcc06,'',rccacti",
               "  FROM rcc_file",
               " WHERE rcc02 = '",g_rca.rca02,"' AND rcc01 ='",g_rca.rca01,"' ",
               "   AND rcc03 = '",g_rca.rca03,"' ",
               "   AND rcc04 = '",g_rcb[l_ac].rcb04,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rcc03 "
 
   DISPLAY g_sql
 
   PREPARE t800_pb1 FROM g_sql
   DECLARE rcc_cs CURSOR FOR t800_pb1
 
   CALL g_rcc.clear()
   LET g_cnt = 1
 
   FOREACH rcc_cs INTO g_rcc[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_rca.rca04
          WHEN '1'
             SELECT oba02 INTO g_rcc[g_cnt].rcc06_desc FROM oba_file
              WHERE oba01 = g_rcc[g_cnt].rcc06 AND obaacti = 'Y'
          WHEN '2'
             SELECT tqa02 INTO g_rcc[g_cnt].rcc06_desc FROM tqa_file
              WHERE tqa01 = g_rcc[g_cnt].rcc06 AND tqaacti = 'Y' AND tqa03 = '2'
          WHEN '3'
             SELECT tqa02 INTO g_rcc[g_cnt].rcc06_desc FROM tqa_file
              WHERE tqa01 = g_rcc[g_cnt].rcc06 AND tqaacti = 'Y' AND tqa03 = '3'
          WHEN '4'
             SELECT tqa02 INTO g_rcc[g_cnt].rcc06_desc FROM tqa_file
              WHERE tqa01 = g_rcc[g_cnt].rcc06 AND tqaacti = 'Y' AND tqa03 = '1'
          WHEN '5'
             SELECT tqa02 INTO g_rcc[g_cnt].rcc06_desc FROM tqa_file
              WHERE tqa01 = g_rcc[g_cnt].rcc06 AND tqaacti = 'Y' AND tqa03 = '4'
          WHEN '6'
             SELECT tqa02 INTO g_rcc[g_cnt].rcc06_desc FROM tqa_file
              WHERE tqa01 = g_rcc[g_cnt].rcc06 AND tqaacti = 'Y' AND tqa03 = '5'
          WHEN '7'
             SELECT tqa02 INTO g_rcc[g_cnt].rcc06_desc FROM tqa_file
              WHERE tqa01 = g_rcc[g_cnt].rcc06 AND tqaacti = 'Y' AND tqa03 = '6'
       END CASE
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rcc.deleteElement(g_cnt)
 
  #LET g_rec_b1=g_cnt-1              #FUN-CC0116 mark
  #DISPLAY g_rec_b1 TO FORMONLY.cn2  #FUN-CC0116 mark
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t800_a()
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_gen02     LIKE gen_file.gen02

   MESSAGE ""
   CLEAR FORM
   CALL g_rcb.clear() 
   CALL g_rcc.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rca.* LIKE rca_file.*
   LET g_rca_t.* = g_rca.*
   LET g_rca_o.* = g_rca.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rca.rca01    = g_plant
      LET g_rca.rca04    = '1'
      LET g_rca.rcapos   = '1'
      LET g_rca.rcaacti  = 'Y'
      LET g_rca.rcaconf  = 'N'
      LET g_rca.rcauser  = g_user
      LET g_rca.rcaoriu  = g_user  
      LET g_rca.rcaorig  = g_grup  
      LET g_rca.rcagrup  = g_grup
      LET g_rca.rcacrat  = g_today

      CALL t800_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rca.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rca.rca01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK

      INSERT INTO rca_file VALUES (g_rca.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK             # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rca_file",g_rca.rca01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK              # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      SELECT * INTO g_rca.* FROM rca_file
       WHERE rca01 = g_rca.rca01 AND rca02 = g_rca.rca02
         AND rca03 = g_rca.rca03  
      LET g_rca_t.* = g_rca.*
      LET g_rca_o.* = g_rca.*
      CALL g_rcb.clear()
      CALL g_rcc.clear()
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      CALL t800_b1()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t800_i(p_cmd)
DEFINE
   p_cmd     LIKE type_file.chr1

   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rca.rca01,g_rca.rca02,g_rca.rca03,g_rca.rca04,g_rca.rca05,g_rca.rcapos,
                   g_rca.rcaconf,g_rca.rcacond,g_rca.rcacont,g_rca.rcaconu,
                   g_rca.rcauser,g_rca.rcamodu,g_rca.rcagrup,g_rca.rcadate,
                   g_rca.rcaacti,g_rca.rcacrat,g_rca.rcaoriu,g_rca.rcaorig
 
   CALL cl_set_head_visible("","YES") 
   
   INPUT BY NAME g_rca.rca01,g_rca.rca02,g_rca.rca03,g_rca.rca04,g_rca.rca05
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t800_set_entry(p_cmd)
         CALL t800_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD rca01
         IF NOT cl_null(g_rca.rca01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rca.rca01 <> g_rca_t.rca01) THEN     
               IF NOT cl_null(g_rca.rca02) AND NOT cl_null(g_rca.rca02) THEN
                  LET l_n = 0
                  CASE p_cmd
                     WHEN "a"
                        SELECT COUNT(*) INTO l_n FROM rca_file
                         WHERE ((rca02 <= g_rca.rca03 AND rca02 >= g_rca.rca02)
                            OR (rca03 <= g_rca.rca03 AND rca03 >= g_rca.rca02)
                            OR (rca02 < g_rca.rca02 AND rca03 > g_rca.rca02))
                           AND rcaacti = 'Y' AND rca01 = g_rca.rca01
                     WHEN "u"
                        SELECT COUNT(*) INTO l_n FROM rca_file
                         WHERE ((rca02 <= g_rca.rca03 AND rca02 >= g_rca.rca02)
                            OR (rca03 <= g_rca.rca03 AND rca03 >= g_rca.rca02)
                            OR (rca02 < g_rca.rca02 AND rca03 > g_rca.rca02))
                           AND rcaacti = 'Y' AND rca01 = g_rca.rca01
                           AND (rca01 <> g_rca_t.rca01 AND rca02 <> g_rca_t.rca02
                           AND rca03 <> g_rca_t.rca03)
                  END CASE
                  IF l_n > 0 THEN
                     CALL cl_err('','art-710',0)
                     NEXT FIELD rca01
                  END IF
               END IF
               CALL t800_rca01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rca01 
               END IF
            END IF
         END IF
         
      AFTER FIELD rca02
         IF NOT cl_null(g_rca.rca02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rca.rca02 <> g_rca_t.rca02) THEN
               IF NOT cl_null(g_rca.rca03) THEN
                  IF g_rca.rca02 > g_rca.rca03 THEN
                     CALL cl_err('','art-711',0)
                     NEXT FIELD rca02
                  END IF
                  IF NOT cl_null(g_rca.rca01) THEN
                     LET l_n = 0
                     CASE p_cmd
                        WHEN "a"
                           SELECT COUNT(*) INTO l_n FROM rca_file
                            WHERE ((rca02 <= g_rca.rca03 AND rca02 >= g_rca.rca02)
                               OR (rca03 <= g_rca.rca03 AND rca03 >= g_rca.rca02)
                               OR (rca02 < g_rca.rca02 AND rca03 > g_rca.rca02))
                              AND rcaacti = 'Y' AND rca01 = g_rca.rca01
                        WHEN "u"
                           SELECT COUNT(*) INTO l_n FROM rca_file 
                            WHERE ((rca02 <= g_rca.rca03 AND rca02 >= g_rca.rca02)
                               OR (rca03 <= g_rca.rca03 AND rca03 >= g_rca.rca02)
                               OR (rca02 < g_rca.rca02 AND rca03 > g_rca.rca02))
                              AND rcaacti = 'Y' AND rca01 = g_rca.rca01
                              AND (rca02 <> g_rca_t.rca02
                              AND rca03 <> g_rca_t.rca03)
                     END CASE
                     IF l_n > 0 THEN
                        CALL cl_err('','art-710',0)
                        NEXT FIELD rca02
                     END IF
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD rca03
         IF NOT cl_null(g_rca.rca03) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rca.rca03 <> g_rca_t.rca03) THEN
               IF NOT cl_null(g_rca.rca02) THEN
                  IF g_rca.rca02 > g_rca.rca03 THEN
                     CALL cl_err('','art-711',0)
                     NEXT FIELD rca03
                  END IF
                  IF NOT cl_null(g_rca.rca01) THEN
                     LET l_n = 0
                     CASE p_cmd
                        WHEN "a"
                           SELECT COUNT(*) INTO l_n FROM rca_file
                            WHERE ((rca02 <= g_rca.rca03 AND rca02 >= g_rca.rca02)
                               OR (rca03 <= g_rca.rca03 AND rca03 >= g_rca.rca02)
                               OR (rca02 < g_rca.rca02 AND rca03 > g_rca.rca02))
                              AND rcaacti = 'Y' AND rca01 = g_rca.rca01
                        WHEN "u"
                           SELECT COUNT(*) INTO l_n FROM rca_file 
                            WHERE ((rca02 <= g_rca.rca03 AND rca02 >= g_rca.rca02)
                               OR (rca03 <= g_rca.rca03 AND rca03 >= g_rca.rca02)
                               OR (rca02 < g_rca.rca02 AND rca03 > g_rca.rca02))
                              AND rcaacti = 'Y' AND rca01 = g_rca.rca01
                              AND (rca02 <> g_rca_t.rca02
                              AND rca03 <> g_rca_t.rca03)
                     END CASE
                     IF l_n > 0 THEN
                        CALL cl_err('','art-710',0)
                        NEXT FIELD rca03
                     END IF
                  END IF
               END IF
            END IF         
         END IF

      AFTER FIELD rca04
         IF NOT cl_null(g_rca.rca04) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rca.rca04 <> g_rca_t.rca04) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM rcc_file 
                WHERE rcc01 = g_rca.rca01 
                  AND rcc02 = g_rca.rca02 AND rcc03 = g_rca.rca03
               IF l_n > 0 THEN
                  CALL cl_err('','art-714',0)
                  NEXT FIELD rca04
               END IF
            END IF
         END IF
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rca01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.where = " azw01 IN (SELECT azw01 FROM azw_file ",
                                      "            WHERE azw02 = '",g_azw02,"')",
                                      " AND azwacti = 'Y'"
               LET g_qryparam.default1 = g_rca.rca01
               CALL cl_create_qry() RETURNING g_rca.rca01
               DISPLAY BY NAME g_rca.rca01
               NEXT FIELD rca01
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION t800_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rca.rca01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rca.* FROM rca_file 
    WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
      AND rca03 = g_rca.rca03
      
   IF g_rca.rcaacti ='N' THEN
      CALL cl_err(g_rca.rca01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rca.rcaconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t800_cl USING g_rca.rca01,g_rca.rca02,g_rca.rca03
 
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t800_cl INTO g_rca.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t800_show()
 
   WHILE TRUE
      LET g_rca_o.* = g_rca.*
      LET g_rca.rcamodu=g_user
      LET g_rca.rcadate=g_today
      IF g_rca_t.rcapos = '3' THEN
         LET g_rca.rcapos = '2'
      ELSE
         LET g_rca.rcapos = g_rca_t.rcapos
      END IF
 
      CALL t800_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rca.*=g_rca_t.*
         CALL t800_show()
         CALL cl_err('','9001',0)
         ROLLBACK WORK
         EXIT WHILE
      END IF

      UPDATE rca_file SET rca_file.* = g_rca.*
       WHERE rca02 = g_rca_t.rca02 AND rca01 = g_rca_t.rca01  
         AND rca03 = g_rca_t.rca03
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rca_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         UPDATE rcb_file SET rcb01 = g_rca.rca01,
                             rcb02 = g_rca.rca02,
                             rcb03 = g_rca.rca03
          WHERE rcb01 = g_rca_t.rca01 AND rcb02 = g_rca_t.rca02
            AND rcb03 = g_rca_t.rca03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rca_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         ELSE
            UPDATE rcc_file SET rcc01 = g_rca.rca01,
                                rcc02 = g_rca.rca02,
                                rcc03 = g_rca.rca03
             WHERE rcc01 = g_rca_t.rca01 AND rcc02 = g_rca_t.rca02
               AND rcc03 = g_rca_t.rca03
         END IF   
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t800_cl
   COMMIT WORK
 
   CALL t800_b1_fill("1=1")
   CALL t800_b2_fill("1=1")

END FUNCTION
 

FUNCTION t800_yes() 
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_pos      LIKE type_file.chr1

   IF cl_null(g_rca.rca01) OR cl_null(g_rca.rca02) OR cl_null(g_rca.rca03) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
#CHI-C30107 ----------- add ------------ begin
   IF g_rca.rcaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rca.rcaacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF 
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ----------- add ------------ end
   SELECT * INTO g_rca.* FROM rca_file 
    WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
      AND rca03 = g_rca.rca03
   IF g_rca.rcaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rca.rcaacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rcb_file
    WHERE rcb02 = g_rca.rca02 AND rcb01=g_rca.rca01
      AND rcb03 = g_rca.rca03
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark 
   BEGIN WORK
   OPEN t800_cl USING g_rca.rca01,g_rca.rca02,g_rca.rca03
   
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t800_cl INTO g_rca.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
      CLOSE t800_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
   IF g_rca.rcapos = '3' THEN
      LET l_pos = '2'
   ELSE
      LET l_pos = g_rca.rcapos
   END IF 
 
   UPDATE rca_file SET rcaconf='Y',
                       rcacond=g_today, 
                       rcacont=g_time, 
                       rcaconu=g_user,
                       rcapos =l_pos 
     WHERE  rca02 = g_rca.rca02 AND rca01=g_rca.rca01
       AND  rca03 = g_rca.rca03
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rca.rcaconf='Y'
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rca.* FROM rca_file 
    WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01 
      AND rca03 = g_rca.rca03
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rca.rcaconu
   DISPLAY BY NAME g_rca.rcaconf                                                                                         
   DISPLAY BY NAME g_rca.rcacond                                                                                         
   DISPLAY BY NAME g_rca.rcacont                                                                                         
   DISPLAY BY NAME g_rca.rcaconu
   DISPLAY BY NAME g_rca.rcapos
   DISPLAY l_gen02 TO FORMONLY.rcaconu_desc
END FUNCTION

FUNCTION t800_w()
DEFINE l_pos  LIKE type_file.chr1
DEFINE l_gen02    LIKE gen_file.gen02    #CHI-D20015

   IF g_rca.rca01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rca.* FROM rca_file
    WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
      AND rca03 = g_rca.rca03
   IF g_rca.rcaconf <> 'Y' THEN CALL cl_err('',9025,0) RETURN END IF

   LET g_success = 'Y'
   BEGIN WORK

   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF
   IF g_rca.rcapos = '3' THEN
      LET l_pos = '2'
   ELSE
      LET l_pos = g_rca.rcapos
   END IF

   LET g_time = TIME    #CHI-D20015
   UPDATE rca_file SET rcaconf = 'N',
                      #CHI-D20015---mod---str
                      #rcaconu='',
                      #rcacond='',
                      #rcacont= '',
                       rcaconu=g_user,
                       rcacond=g_today,
                       rcacont= g_time,
                      #CHI-D20015---mod--str 
                       rcapos = l_pos
    WHERE rca01 = g_rca.rca01
      AND rca02 = g_rca.rca02
      AND rca03 = g_rca.rca03

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rca_file",g_rca.rca01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      MESSAGE 'UPDATE rca_file OK'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rca.rcaconf='N'
     #CHI-D20015----mod---str
     #LET g_rca.rcaconu=NULL
     #LET g_rca.rcacond=NULL
     #LET g_rca.rcacont=NULL
      LET g_rca.rcaconu=g_user
      LET g_rca.rcacond=g_today
      LET g_rca.rcacont=g_time
     #CHI-D20015---mod--end
      LET g_rca.rcapos =l_pos
      DISPLAY BY NAME g_rca.rcaconf
      DISPLAY BY NAME g_rca.rcacond
      DISPLAY BY NAME g_rca.rcacont
      DISPLAY BY NAME g_rca.rcaconu
      DISPLAY BY NAME g_rca.rcapos
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rca.rcaconu    #CHI-D20015
     #DISPLAY '' TO FORMONLY.rcaconu_desc                                    #CHI-D20015
      DISPLAY l_gen02 TO FORMONLY.rcaconu_desc                               #CHI-D20015
   ELSE
      LET g_rca.rcaconu=g_rca_t.rcaconu
      LET g_rca.rcacond=g_rca_t.rcacond
      LET g_rca.rcaconf='Y'
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t800_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rca.rca01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rca.rcaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   BEGIN WORK 
   OPEN t800_cl USING g_rca.rca01,g_rca.rca02,g_rca.rca03
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      RETURN
   END IF
 
   FETCH t800_cl INTO g_rca.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t800_show()
 
   IF cl_exp(0,0,g_rca.rcaacti) THEN
      LET g_chr=g_rca.rcaacti
      IF g_rca.rcaacti='Y' THEN
         LET g_rca.rcaacti='N'
      ELSE
         LET g_rca.rcaacti='Y'
      END IF
      IF g_rca.rcapos = '3' THEN
         LET g_rca.rcapos = '2'
      END IF
 
      UPDATE rca_file SET rcaacti=g_rca.rcaacti,
                          rcamodu=g_user,
                          rcadate=g_today,
                          rcapos =g_rca.rcapos
       WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
         AND rca03 = g_rca.rca03
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rca_file",g_rca.rca01,"",SQLCA.sqlcode,"","",1) 
         LET g_rca.rcaacti=g_chr
      END IF
   END IF
 
   CLOSE t800_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rcaacti,rcamodu,rcadate,rcapos
     INTO g_rca.rcaacti,g_rca.rcamodu,g_rca.rcadate,g_rca.rcapos 
     FROM rca_file
    WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
      AND rca03 = g_rca.rca03

   DISPLAY BY NAME g_rca.rcaacti,g_rca.rcamodu,g_rca.rcadate,g_rca.rcapos 
 
END FUNCTION
 
FUNCTION t800_r()
DEFINE l_count1   LIKE type_file.num5  #FUN-CC0116 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rca.rca01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rca.* FROM rca_file
    WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
      AND rca03 = g_rca.rca03
 
   IF g_rca.rcaconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF

   IF g_aza.aza88 = 'Y' THEN
      #FUN-CC0116-----add----str
      LET l_count1 = 0 
      IF g_rca.rcapos = '3' THEN
         SELECT COUNT(*) INTO l_count1
           FROM rcb_file
          WHERE rcb01 = g_rca.rca01
            AND rcb02 = g_rca.rca02
            AND rcb03 = g_rca.rca03
            AND rcbacti = 'Y'
      END IF 
      IF NOT (g_rca.rcapos = '1' OR (g_rca.rcapos = '3' AND l_count1 = 0 )) THEN
      #FUN-CC0116-----add----end
     #IF NOT (g_rca.rcapos = '1' OR (g_rca.rcapos = '3' AND g_rca.rcaacti = 'N')) THEN   #FUN-CC0116 mark
         CALL cl_err('','apc-139',0)
         RETURN
      END IF
   END IF
  
   BEGIN WORK
 
   OPEN t800_cl USING g_rca.rca01,g_rca.rca02,g_rca.rca03
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t800_cl INTO g_rca.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t800_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rca01"      
       LET g_doc.value1 = g_rca.rca01    
       CALL cl_del_doc()              
      DELETE FROM rca_file WHERE rca02 = g_rca.rca02 AND rca01 = g_rca.rca01
                             AND rca03 = g_rca.rca03
      DELETE FROM rcb_file WHERE rcb02 = g_rca.rca02 AND rcb01 = g_rca.rca01
                             AND rca03 = g_rca.rca03 
      DELETE FROM rcc_file WHERE rcc02 = g_rca.rca02 AND rcc01 = g_rca.rca01
                             AND rca03 = g_rca.rca03

      CLEAR FORM
      CALL g_rcb.clear() 
      CALL g_rcc.clear()

      OPEN t800_count
      FETCH t800_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t800_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t800_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t800_fetch('/')
      END IF
   END IF
 
   CLOSE t800_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t800_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rca.rca01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rca.* FROM rca_file
     WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
       AND rca03 = g_rca.rca03
 
    IF g_rca.rcaacti ='N' THEN
       CALL cl_err(g_rca.rca01||g_rca.rca02,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rca.rcaconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rca.rcaconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rcb04,rcb05,'',rcb06,rcb07,rcb08,", 
                       "       rcb09,rcbacti", 
                       "  FROM rcb_file ",
                       " WHERE rcb01 = ? AND rcb02=? AND rcb03=? AND rcb04 = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rcb WITHOUT DEFAULTS FROM s_rcb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
           CALL t800_b2_fill("1=1")
           CALL t800_b2_refresh()

           BEGIN WORK
 
           OPEN t800_cl USING g_rca.rca01,g_rca.rca02,g_rca.rca03
           IF STATUS THEN
              CALL cl_err("OPEN t800_cl:", STATUS, 1)
              CLOSE t800_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t800_cl INTO g_rca.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
              CLOSE t800_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rcb_t.* = g_rcb[l_ac].*
              LET g_rcb_o.* = g_rcb[l_ac].*
              OPEN t800_bcl USING g_rca.rca01,g_rca.rca02,g_rca.rca03,g_rcb_t.rcb04
              IF STATUS THEN
                 CALL cl_err("OPEN t800_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t800_bcl INTO g_rcb[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rcb_t.rcb04,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT tqa02 INTO g_rcb[l_ac].rcb05_desc FROM tqa_file
                  WHERE tqa01 = g_rcb[l_ac].rcb05
                    AND tqa03 = '29' AND tqaacti = 'Y'
              END IF
          END IF 

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rcb[l_ac].* TO NULL
           LET g_rcb[l_ac].rcb06 = 'N'     #FUN-CC0116 add
           LET g_rcb[l_ac].rcb07 = 'N'     #FUN-CC0116 add
           LET g_rcb[l_ac].rcb09 = 'N'
           LET g_rcb[l_ac].rcbacti = 'Y'
           LET g_rcb_t.* = g_rcb[l_ac].*
           LET g_rcb_o.* = g_rcb[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rcb04
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rcb_file(rcb01,rcb02,rcb03,rcb04,rcb05,rcb06,
                                rcb07,rcb08,rcb09,rcbacti)   
           VALUES(g_rca.rca01,g_rca.rca02,g_rca.rca03,
                  g_rcb[l_ac].rcb04,g_rcb[l_ac].rcb05,
                  g_rcb[l_ac].rcb06,g_rcb[l_ac].rcb07,
                  g_rcb[l_ac].rcb08,g_rcb[l_ac].rcb09,
                  g_rcb[l_ac].rcbacti)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rcb_file",g_rca.rca01,g_rcb[l_ac].rcb04,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              IF p_cmd='u' THEN
                 CALL t800_upd_log()
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rcb04
           IF g_rcb[l_ac].rcb04 IS NULL OR g_rcb[l_ac].rcb04 = 0 THEN
              SELECT max(rcb04)+1
                INTO g_rcb[l_ac].rcb04
                FROM rcb_file
               WHERE rcb02 = g_rca.rca02 AND rcb01 = g_rca.rca01
                 AND rcb03 = g_rca.rca03
              IF g_rcb[l_ac].rcb04 IS NULL THEN
                 LET g_rcb[l_ac].rcb04 = 1
              END IF
           END IF
 
        AFTER FIELD rcb04
           IF NOT cl_null(g_rcb[l_ac].rcb04) THEN
              IF g_rcb[l_ac].rcb04 != g_rcb_t.rcb04
                 OR g_rcb_t.rcb04 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rcb_file
                  WHERE rcb02 = g_rca.rca02 AND rcb01 = g_rca.rca01
                    AND rcb03 = g_rca.rca03 AND rcb04 = g_rcb[l_ac].rcb04
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rcb[l_ac].rcb04 = g_rcb_t.rcb04
                    NEXT FIELD rcb04
                 END IF
              END IF
           END IF
 
        AFTER FIELD rcb05
           IF NOT cl_null(g_rcb[l_ac].rcb05) THEN
              IF g_rcb_o.rcb05 IS NULL OR
                 (g_rcb[l_ac].rcb05 != g_rcb_o.rcb05 ) THEN
                 SELECT COUNT(*) INTO l_n FROM tqa_file 
                  WHERE tqa01 = g_rcb[l_ac].rcb05 AND tqa03 = '29' AND tqaacti = 'Y'
                 IF l_n = 0 THEN 
                    CALL cl_err('','azz1004',0)
                    NEXT FIELD rcb05
                 END IF
                 SELECT count(*)
                   INTO l_n
                   FROM rcb_file
                  WHERE rcb02 = g_rca.rca02 AND rcb01 = g_rca.rca01
                    AND rcb03 = g_rca.rca03 AND rcb05 = g_rcb[l_ac].rcb05
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rcb[l_ac].rcb05 = g_rcb_t.rcb05
                    NEXT FIELD rcb05
                 END IF
                 SELECT tqa02 INTO g_rcb[l_ac].rcb05_desc FROM tqa_file 
                  WHERE tqa01 = g_rcb[l_ac].rcb05 AND tqa03 = '29' AND tqaacti = 'Y'
              END IF
           END IF

        BEFORE FIELD rcb06
           IF NOT cl_null(g_rcb[l_ac].rcb07) THEN
              CALL cl_set_comp_required("rcb06",TRUE)
           ELSE
              CALL cl_set_comp_required("rcb06",FALSE)
           END IF

        AFTER FIELD rcb06
           IF NOT cl_null(g_rcb[l_ac].rcb06) THEN
              CALL cl_set_comp_required("rcb07",TRUE)
              IF NOT cl_null(g_rcb[l_ac].rcb07) THEN
                 IF g_rcb[l_ac].rcb06 > g_rcb[l_ac].rcb07 THEN
                    CALL cl_err('','art-712',0)
                    NEXT FIELD rcb06
                 END IF
              END IF
           ELSE
              CALL cl_set_comp_required("rcb07",FALSE)
           END IF

        BEFORE FIELD rcb07
           IF NOT cl_null(g_rcb[l_ac].rcb06) THEN
              CALL cl_set_comp_required("rcb07",TRUE)
           ELSE
              CALL cl_set_comp_required("rcb07",FALSE)
           END IF

        AFTER FIELD rcb07
           IF NOT cl_null(g_rcb[l_ac].rcb07) THEN
              CALL cl_set_comp_required("rcb06",TRUE)
              IF NOT cl_null(g_rcb[l_ac].rcb06) THEN
                 IF g_rcb[l_ac].rcb06 > g_rcb[l_ac].rcb07 THEN
                    CALL cl_err('','art-712',0)
                    NEXT FIELD rcb07
                 END IF 
              END IF 
           ELSE
              CALL cl_set_comp_required("rcb06",FALSE)
           END IF

        AFTER FIELD rcb08
           IF NOT cl_null(g_rcb[l_ac].rcb08) THEN
              IF g_rcb[l_ac].rcb08 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD rcb08
              END IF
           END IF

        AFTER FIELD rcb09
           IF NOT cl_null(g_rcb[l_ac].rcb09) THEN 
              IF g_rcb[l_ac].rcb09 = 'N' THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM rcc_file 
                  WHERE rcc01 = g_rca.rca01 AND rcc02 = g_rca.rca02 
                    AND rcc03 = g_rca.rca03 AND rcc04 = g_rcb[l_ac].rcb04
                 IF l_n > 0 THEN
                    IF (g_aza.aza88 = 'Y' AND g_rca.rcapos = '1') OR (g_aza.aza88 = 'N') THEN
                       IF cl_confirm('art-713') THEN
                          BEGIN WORK
                          UPDATE rcb_file SET rcb09 = 'N' 
                           WHERE rcb01 = g_rca.rca01 AND rcb02 = g_rca.rca02
                             AND rcb03 = g_rca.rca03 AND rcb04 = g_rcb[l_ac].rcb04
                          IF SQLCA.sqlcode THEN
                             CALL cl_err('upd rcb',SQLCA.sqlcode,1)
                             ROLLBACK WORK
                             NEXT FIELD rcb09
                          END IF
                          DELETE FROM rcc_file WHERE rcc01 = g_rca.rca01 AND rcc02 = g_rca.rca02
                             AND rcc03 = g_rca.rca03 AND rcc04 = g_rcb[l_ac].rcb04
                          IF SQLCA.sqlcode THEN
                             CALL cl_err('del rcc',SQLCA.sqlcode,1)
                             ROLLBACK WORK
                             NEXT FIELD rcb09
                          END IF
                          CALL t800_b2_fill("1=1")
                          CALL t800_b2_refresh()
                          LET g_rcb_t.rcb09 = 'N'
                          COMMIT WORK
                       ELSE
                          LET g_rcb[l_ac].rcb09 = 'Y'
                          NEXT FIELD rcb09
                       END IF
                    ELSE
                       CALL cl_err('','art-721',0)
                       NEXT FIELD rcb09
                    END IF
                 END IF
              END IF
           END IF
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rcb_t.rcb04 > 0 AND g_rcb_t.rcb04 IS NOT NULL THEN
              IF g_aza.aza88 = 'Y' THEN
                 IF NOT (g_rca.rcapos = '1' OR (g_rca.rcapos = '3' AND g_rcb[l_ac].rcbacti = 'N')) THEN
                    CALL cl_err('','apc-139',0)
                    CANCEL DELETE
                 END IF
              END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              SELECT COUNT(*) INTO l_n FROM rcc_file
               WHERE rcc01=g_rca.rca01 AND rcc02=g_rca.rca02
                 AND rcc03=g_rca.rca03 AND rcc04=g_rcb_t.rcb04
              IF l_n>0 THEN
                 CALL cl_err(g_rcb_t.rcb04,'art-722',0)
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rcb_file
               WHERE rcb02 = g_rca.rca02 AND rcb01 = g_rca.rca01
                 AND rcb03 = g_rca.rca03 AND rcb04 = g_rcb_t.rcb04 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rcb_file",g_rca.rca01,g_rcb_t.rcb04,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 #FUN-B80085增加空白行
 
               	 DELETE FROM rcc_file 
               	  WHERE rcc01 = g_rca.rca01 AND rcc02 = g_rca.rca02
                    AND rcc03 = g_rca.rca03 AND rcc04 = g_rcb_t.rcb04
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rcc_file",g_rca.rca01,g_rcb_t.rcb04,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF 
              END IF
              CALL t800_upd_log() 
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rcb[l_ac].* = g_rcb_t.*
              CLOSE t800_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rcb[l_ac].rcb04) THEN
              NEXT FIELD rcb04
           END IF
              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rcb[l_ac].rcb04,-263,1)
              LET g_rcb[l_ac].* = g_rcb_t.*
           ELSE
              UPDATE rcb_file SET rcb04  =g_rcb[l_ac].rcb04,
                                  rcb05  =g_rcb[l_ac].rcb05,
                                  rcb06  =g_rcb[l_ac].rcb06,
                                  rcb07  =g_rcb[l_ac].rcb07,
                                  rcb08  =g_rcb[l_ac].rcb08,
                                  rcb09  =g_rcb[l_ac].rcb09,
                                  rcbacti=g_rcb[l_ac].rcbacti
               WHERE rcb02 = g_rca.rca02 AND rcb01=g_rca.rca01
                 AND rcb03 = g_rca.rca03 AND rcb04 = g_rcb_t.rcb04 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rcb_file",g_rca.rca01,g_rcb_t.rcb04,SQLCA.sqlcode,"","",1) 
                 LET g_rcb[l_ac].* = g_rcb_t.*
              ELSE
                 MESSAGE 'UPDATE rcb_file O.K'
                 CALL t800_upd_log() 
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rcb[l_ac].* = g_rcb_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rcb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                    LET g_flag_b = '1'
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t800_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t800_bcl
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(rcb04) AND l_ac > 1 THEN
              LET g_rcb[l_ac].* = g_rcb[l_ac-1].*
              LET g_rcb[l_ac].rcb04 = g_rec_b + 1
              NEXT FIELD rcb04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
           CASE
              WHEN INFIELD(rcb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa"
                 LET g_qryparam.arg1 = '29'
                 LET g_qryparam.default1 = g_rcb[l_ac].rcb05
                 CALL cl_create_qry() RETURNING g_rcb[l_ac].rcb05
                 DISPLAY BY NAME g_rcb[l_ac].rcb05
                 NEXT FIELD rcb05
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION HELP
           CALL cl_show_help()
 
        ON ACTION controls         
           CALL cl_set_head_visible("","AUTO")
    END INPUT
    
    CLOSE t800_bcl
    COMMIT WORK
    CALL t800_delall()
 
END FUNCTION

FUNCTION t800_upd_log()
   LET g_rca.rcamodu = g_user
   LET g_rca.rcadate = g_today
   IF g_rca_t.rcapos  = '3' THEN
      LET g_rca.rcapos = '2'
   ELSE
      LET g_rca.rcapos = g_rca_t.rcapos
   END IF
   UPDATE rca_file SET rcamodu = g_rca.rcamodu,
                       rcadate = g_rca.rcadate,
                       rcapos  = g_rca.rcapos
    WHERE rca01 = g_rca.rca01 AND rca02 = g_rca.rca02
      AND rca03 = g_rca.rca03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rca_file",g_rca.rcamodu,g_rca.rcadate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rca.rcamodu,g_rca.rcadate,g_rca.rcapos
   MESSAGE 'UPDATE rca_file O.K.'
END FUNCTION

FUNCTION t800_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rcb_file
    WHERE rcb02 = g_rca.rca02 AND rcb01 = g_rca.rca01
      AND rcb03 = g_rca.rca03
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rca_file 
       WHERE rca01 = g_rca.rca01 AND rca02=g_rca.rca02 
         AND rca03=g_rca.rca03
      CALL g_rcb.clear()
   END IF
END FUNCTION

FUNCTION t800_b2()
DEFINE
    l_ac1_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_num           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE l_ima25      LIKE ima_file.ima25
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rca.rca01 IS NULL THEN
       RETURN
    END IF

    IF g_rcb[l_ac].rcb09 = 'N' THEN
       CALL cl_err('','art-716',0)
       RETURN
    END IF
 
    SELECT * INTO g_rca.* FROM rca_file
     WHERE rca02 = g_rca.rca02 AND rca01=g_rca.rca01
       AND rca03 = g_rca.rca03
 
    IF g_rca.rcaacti ='N' THEN
       CALL cl_err(g_rca.rca01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rca.rcaconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT rcc05,rcc06,'',rccacti", 
                       "  FROM rcc_file ",
                       " WHERE rcc01=? AND rcc02=? AND rcc03=? AND rcc04=? AND rcc05 = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t8001_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rcc WITHOUT DEFAULTS FROM s_rcc.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t800_cl USING g_rca.rca01,g_rca.rca02,g_rca.rca03
           IF STATUS THEN
              CALL cl_err("OPEN t800_cl:", STATUS, 1)
              CLOSE t800_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t800_cl INTO g_rca.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rca.rca01,SQLCA.sqlcode,0)
              CLOSE t800_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_rcc_t.* = g_rcc[l_ac1].* 
              LET g_rcc_o.* = g_rcc[l_ac1].* 
              OPEN t8001_bcl USING g_rca.rca01,g_rca.rca02,g_rca.rca03,g_rcb[l_ac].rcb04,g_rcc_t.rcc05
              IF STATUS THEN
                 CALL cl_err("OPEN t8001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t8001_bcl INTO g_rcc[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rcc_t.rcc05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CASE g_rca.rca04
                    WHEN '1'
                       SELECT oba02 INTO g_rcc[l_ac1].rcc06_desc FROM oba_file
                        WHERE oba01 = g_rcc[l_ac1].rcc06 AND obaacti = 'Y'
                    WHEN '2'
                       SELECT tqa02 INTO g_rcc[l_ac1].rcc06_desc FROM tqa_file
                        WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqaacti = 'Y' AND tqa03 = '2'
                    WHEN '3'
                       SELECT tqa02 INTO g_rcc[l_ac1].rcc06_desc FROM tqa_file
                        WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqaacti = 'Y' AND tqa03 = '3'
                    WHEN '4'
                       SELECT tqa02 INTO g_rcc[l_ac1].rcc06_desc FROM tqa_file
                        WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqaacti = 'Y' AND tqa03 = '1'
                    WHEN '5'
                       SELECT tqa02 INTO g_rcc[l_ac1].rcc06_desc FROM tqa_file
                        WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqaacti = 'Y' AND tqa03 = '4'
                    WHEN '6'
                       SELECT tqa02 INTO g_rcc[l_ac1].rcc06_desc FROM tqa_file
                        WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqaacti = 'Y' AND tqa03 = '5'
                    WHEN '7'
                       SELECT tqa02 INTO g_rcc[l_ac1].rcc06_desc FROM tqa_file
                        WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqaacti = 'Y' AND tqa03 = '6'
                 END CASE
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rcc[l_ac1].* TO NULL
           LET g_rcc[l_ac1].rccacti = 'Y'
           LET g_rcc_t.* = g_rcc[l_ac1].*
           LET g_rcc_o.* = g_rcc[l_ac1].*
           CALL cl_show_fld_cont()
           NEXT FIELD rcc05
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF (NOT cl_null(g_rcc[l_ac1].rcc05)) THEN
              LET l_num = 0
              SELECT COUNT(*) INTO l_num FROM rcc_file
               WHERE rcc01 =g_rca.rca01 AND rcc02 = g_rca.rca02
                 AND rcc03 = g_rca.rca03 
                 AND rcc04 = g_rcb[l_ac].rcb04
                 AND rcc05 = g_rcc[l_ac1].rcc05
              IF l_num>0 THEN 
                 CALL cl_err('',-239,0)
                 NEXT FIELD rcc05
              END IF
           END IF
           INSERT INTO rcc_file(rcc01,rcc02,rcc03,rcc04,rcc05,rcc06,
                                rccacti)   
           VALUES(g_rca.rca01,g_rca.rca02,
                  g_rca.rca03,g_rcb[l_ac].rcb04,
                  g_rcc[l_ac1].rcc05,g_rcc[l_ac1].rcc06,
                  g_rcc[l_ac1].rccacti)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rcc_file",g_rca.rca01,g_rcc[l_ac1].rcc05,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
           END IF
  
        BEFORE FIELD rcc05
           IF g_rcc[l_ac1].rcc05 IS NULL OR g_rcc[l_ac1].rcc05 = 0 THEN
              SELECT max(rcc05)+1
                INTO g_rcc[l_ac1].rcc05
                FROM rcc_file
               WHERE rcc02 = g_rca.rca02 AND rcc01 = g_rca.rca01
                 AND rcc03 = g_rca.rca03
                 AND rcc04 = g_rcb[l_ac].rcb04
              IF g_rcc[l_ac1].rcc05 IS NULL THEN
                 LET g_rcc[l_ac1].rcc05 = 1
              END IF
           END IF

        AFTER FIELD rcc05
           IF NOT cl_null(g_rcc[l_ac1].rcc05) THEN
              IF g_rcc[l_ac1].rcc05 != g_rcc_t.rcc05
                 OR g_rcc_t.rcc05 IS NULL THEN
                 LET l_num = 0 
                 SELECT count(*)
                   INTO l_num
                   FROM rcc_file
                  WHERE rcc02 = g_rca.rca02 AND rcc01 = g_rca.rca01
                    AND rcc03 = g_rca.rca03 AND rcc04 = g_rcb[l_ac].rcb04
                    AND rcc05 = g_rcc[l_ac1].rcc05
                 IF l_num > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rcc[l_ac1].rcc05 = g_rcc_t.rcc05
                    NEXT FIELD rcc05
                 END IF
              END IF
           END IF         
         
        AFTER FIELD rcc06
           IF NOT cl_null(g_rcc[l_ac1].rcc06) THEN 
              IF g_rcc[l_ac1].rcc06 != g_rcc_t.rcc06
                 OR g_rcc_t.rcc06 IS NULL THEN
                 LET l_num = 0
                 SELECT count(*)
                   INTO l_num
                   FROM rcc_file
                  WHERE rcc02 = g_rca.rca02 AND rcc01 = g_rca.rca01
                    AND rcc03 = g_rca.rca03 AND rcc04 = g_rcb[l_ac].rcb04
                    AND rcc06 = g_rcc[l_ac1].rcc06
                 IF l_num > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rcc[l_ac1].rcc06 = g_rcc_t.rcc06
                    NEXT FIELD rcc06
                 END IF
                 CALL t800_rcc06()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rcc06
                 END IF
              END IF
           END IF
        
        
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rcc_t.rcc05 > 0 AND g_rcc_t.rcc05 IS NOT NULL THEN
              IF g_aza.aza88 = 'Y' THEN
                 IF NOT (g_rca.rcapos = '1' OR (g_rca.rcapos = '3' AND g_rcc[l_ac1].rccacti = 'N')) THEN
                    CALL cl_err('','apc-139',0)
                    CANCEL DELETE
                 END IF
              END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rcc_file
               WHERE rcc02 = g_rca.rca02 AND rcc01 = g_rca.rca01
                 AND rcc03 = g_rca.rca03 AND rcc04 = g_rcb[l_ac].rcb04 
                 AND rcc05 = g_rcc_t.rcc05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rcc_file",g_rca.rca01,g_rcc_t.rcc05,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rcc[l_ac1].* = g_rcc_t.*
              CLOSE t8001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rcc[l_ac1].rcc05,-263,1)
              LET g_rcc[l_ac1].* = g_rcc_t.*
           ELSE
              IF g_rcc[l_ac1].rcc05<>g_rcc_t.rcc05 THEN
                 LET l_num = 0
                 SELECT COUNT(*) INTO l_num FROM rcc_file
                  WHERE rcc01 =g_rca.rca01 AND rcc02 = g_rca.rca02
                    AND rcc03 = g_rca.rca03 
                    AND rcc04 = g_rcb[l_ac].rcb04
                    AND rcc05 = g_rcc[l_ac1].rcc05
                 IF l_num>0 THEN 
                    CALL cl_err('',-239,0)
                    NEXT FIELD rcc05
                 END IF
              END IF
              UPDATE rcc_file SET rcc05=g_rcc[l_ac1].rcc05,
                                  rcc06=g_rcc[l_ac1].rcc06,
                                  rccacti=g_rcc[l_ac1].rccacti
               WHERE rcc02 = g_rca.rca02 AND rcc01=g_rca.rca01
                 AND rcc03 = g_rca.rca03 AND rcc04=g_rcb[l_ac].rcb04 
                 AND rcc05 = g_rcc_t.rcc05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rcc_file",g_rca.rca01,g_rcc_t.rcc05,SQLCA.sqlcode,"","",1) 
                 LET g_rcc[l_ac1].* = g_rcc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
          #LET l_ac1_t = l_ac1   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rcc[l_ac1].* = g_rcc_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rcc.deleteElement(l_ac1)
                 IF g_rec_b1 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac1 = l_ac1_t
                    LET g_flag_b = '2'
                 END IF
              #FUN-D30033--add--end---- 
              END IF
              CLOSE t8001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac1_t = l_ac1   #FUN-D30033 add
           CLOSE t8001_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rcc05) AND l_ac1 > 1 THEN
              LET g_rcc[l_ac1].* = g_rcc[l_ac1-1].*
              NEXT FIELD rcc05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rcc06)
                 CALL cl_init_qry_var()
                 CASE g_rca.rca04
                    WHEN '1'
                       LET g_qryparam.form = "q_oba_11"
                    WHEN '2'
                       LET g_qryparam.form = "q_tqa"
                       LET g_qryparam.arg1 = "2"
                    WHEN '3'
                       LET g_qryparam.form = "q_tqa"
                       LET g_qryparam.arg1 = "3"
                    WHEN '4'
                       LET g_qryparam.form = "q_tqa"
                       LET g_qryparam.arg1 = "1"
                    WHEN '5'
                       LET g_qryparam.form = "q_tqa"
                       LET g_qryparam.arg1 = "4"
                    WHEN '6'
                       LET g_qryparam.form = "q_tqa"
                       LET g_qryparam.arg1 = "5"
                    WHEN '7'
                       LET g_qryparam.form = "q_tqa"
                       LET g_qryparam.arg1 = "6"
                 END CASE
                 LET g_qryparam.default1 = g_rcc[l_ac1].rcc06
                 CALL cl_create_qry() RETURNING g_rcc[l_ac1].rcc06
                 DISPLAY BY NAME g_rcc[l_ac1].rcc06
                 NEXT FIELD rcc06
              OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
     
    CALL t800_upd_log() 
    
    CLOSE t8001_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t800_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rca01,rca02,rca03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t800_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN  
      CALL cl_set_comp_entry("rca01,rca02,rca03",FALSE)
   END IF
   IF p_cmd = 'u' AND g_aza.aza88 = 'Y' AND g_rca.rcapos <>'1' THEN        #FUN-CC0116 add
      CALL cl_set_comp_entry("rca02,rca03",FALSE)                          #FUN-CC0116 add
   END IF                                                                  #FUN-CC0116 add
 
END FUNCTION

FUNCTION t800_rca01(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_azw08   LIKE azw_file.azw08
DEFINE l_azwacti LIKE azw_file.azwacti

   SELECT azw08,azwacti INTO l_azw08,l_azwacti FROM azw_file
    WHERE azw01 = g_rca.rca01

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'aap-025'
         LET l_azw08 = NULL
      WHEN l_azwacti = 'N' LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_azw08 TO FORMONLY.rca01_desc
   END IF
END FUNCTION

FUNCTION t800_rcc06()
DEFINE l_acti    LIKE type_file.chr1

   CASE g_rca.rca04
      WHEN '1'
         SELECT oba02,obaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti 
           FROM oba_file WHERE oba01 = g_rcc[l_ac1].rcc06
      WHEN '2'
         SELECT tqa02,tqaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti
           FROM tqa_file WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqa03 = '2'
      WHEN '3'
         SELECT tqa02,tqaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti
           FROM tqa_file WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqa03 = '3'
      WHEN '4'
         SELECT tqa02,tqaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti
           FROM tqa_file WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqa03 = '1'
      WHEN '5'
         SELECT tqa02,tqaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti
           FROM tqa_file WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqa03 = '4'
      WHEN '6'
         SELECT tqa02,tqaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti
           FROM tqa_file WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqa03 = '5'
      WHEN '7'
         SELECT tqa02,tqaacti INTO g_rcc[l_ac1].rcc06_desc,l_acti
           FROM tqa_file WHERE tqa01 = g_rcc[l_ac1].rcc06 AND tqa03 = '6'
   END CASE
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = '100'
      WHEN l_acti = 'N' LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION

FUNCTION t800_b2_refresh()

   DISPLAY ARRAY g_rcc TO s_rcc.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

#FUN-B50005
