# Prog. Version..: '5.30.06-13.04.09(00008)'     #
#
# Pattern name...: artt801.4gl
# Descriptions...: 專櫃對帳單資料維護作業
# Date & Author..: NO.FUN-B50034 11/05/04 By baogc 
# Modify.........: No:FUN-B50157 11/05/24 By huangtao 隱藏含稅否 
# Modify.........: No:FUN-B60054 11/06/09 By huangtao 增加列印功能
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:TQC-BB0125 11/11/24 by pauline 控卡platn code不是當前營運中心時，不允許執行任何動作
# Modify.........: No:TQC-C20263 12/02/20 by fanbj 銷售抽成資料及費用資料單身二中項次來源
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:CHI-D20015 13/03/27 By minpp 將確認人，確認日期改為確認異動人員，確認異動日期，取消審核時，回寫確認異動人員及日期

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_rch         RECORD LIKE rch_file.*,
       g_rch_t       RECORD LIKE rch_file.*,
       g_rch_o       RECORD LIKE rch_file.*,
       g_rci1         DYNAMIC ARRAY OF RECORD
           rci03       LIKE rci_file.rci03,
           rci04       LIKE rci_file.rci04,
           rci04_desc  LIKE tqa_file.tqa02,
           rci05       LIKE rci_file.rci05,
           rci06       LIKE rci_file.rci06,
           rci07       LIKE rci_file.rci07,
           rci08       LIKE rci_file.rci08,
           rci09       LIKE rci_file.rci09
                     END RECORD,
       g_rci1_t       RECORD
           rci03       LIKE rci_file.rci03,
           rci04       LIKE rci_file.rci04,
           rci04_desc  LIKE tqa_file.tqa02,
           rci05       LIKE rci_file.rci05,
           rci06       LIKE rci_file.rci06,
           rci07       LIKE rci_file.rci07,
           rci08       LIKE rci_file.rci08,
           rci09       LIKE rci_file.rci09
                     END RECORD,
       g_rci1_o       RECORD 
           rci03       LIKE rci_file.rci03,
           rci04       LIKE rci_file.rci04,
           rci04_desc  LIKE tqa_file.tqa02,
           rci05       LIKE rci_file.rci05,
           rci06       LIKE rci_file.rci06,
           rci07       LIKE rci_file.rci07,
           rci08       LIKE rci_file.rci08,
           rci09       LIKE rci_file.rci09
                     END RECORD,
       g_rci2         DYNAMIC ARRAY OF RECORD
           item1       LIKE type_file.num5,
           rci10       LIKE rci_file.rci10,
           rci10_desc  LIKE oaj_file.oaj02,
           rci11       LIKE rci_file.rci11,
           rci12       LIKE rci_file.rci12
                     END RECORD,
       g_rci2_t       RECORD
           item1       LIKE type_file.num5,
           rci10       LIKE rci_file.rci10,
           rci10_desc  LIKE oaj_file.oaj02,
           rci11       LIKE rci_file.rci11,
           rci12       LIKE rci_file.rci12
                     END RECORD,
       g_rci2_o       RECORD 
           item1       LIKE type_file.num5,
           rci10       LIKE rci_file.rci10,
           rci10_desc  LIKE oaj_file.oaj02,
           rci11       LIKE rci_file.rci11,
           rci12       LIKE rci_file.rci12
                     END RECORD,
       g_rce         DYNAMIC ARRAY OF RECORD
           rce01       LIKE rce_file.rce01,
           rcd02       LIKE rcd_file.rcd02,
           rce02       LIKE rce_file.rce02,
           rce06       LIKE rce_file.rce06,
           rce04       LIKE rce_file.rce04,
           rce05       LIKE rce_file.rce05
                     END RECORD,
       g_rce_t       RECORD
           rce01       LIKE rce_file.rce01,
           rcd02       LIKE rcd_file.rcd02,
           rce02       LIKE rce_file.rce02,
           rce06       LIKE rce_file.rce06,
           rce04       LIKE rce_file.rce04,
           rce05       LIKE rce_file.rce05
                     END RECORD,
       g_rce_o       RECORD
           rce01       LIKE rce_file.rce01,
           rcd02       LIKE rcd_file.rcd02,
           rce02       LIKE rce_file.rce02,
           rce06       LIKE rce_file.rce06,
           rce04       LIKE rce_file.rce04,
           rce05       LIKE rce_file.rce05
                     END RECORD,
       g_lua         DYNAMIC ARRAY OF RECORD
           lua01       LIKE lua_file.lua01,
           lua09       LIKE lua_file.lua09,
           item2       LIKE type_file.num5,
           lub03       LIKE lub_file.lub03,
           lub03_desc  LIKE oaj_file.oaj02,
           lub04       LIKE lub_file.lub04,
           lub04t      LIKE lub_file.lub04t
                     END RECORD,
       g_lua_t       RECORD
           lua01       LIKE lua_file.lua01,
           lua09       LIKE lua_file.lua09,
           item2       LIKE type_file.num5,
           lub03       LIKE lub_file.lub03,
           lub03_desc  LIKE oaj_file.oaj02,
           lub04       LIKE lub_file.lub04,
           lub04t      LIKE lub_file.lub04t
                     END RECORD,
       g_lua_o       RECORD
           lua01       LIKE lua_file.lua01,
           lua09       LIKE lua_file.lua09,
           item2       LIKE type_file.num5,
           lub03       LIKE lub_file.lub03,
           lub03_desc  LIKE oaj_file.oaj02,
           lub04       LIKE lub_file.lub04,
           lub04t      LIKE lub_file.lub04t
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_rec_b       LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5,
       g_rec_b2      LIKE type_file.num5,
       g_rec_b3      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac          LIKE type_file.num5,
       l_ac2         LIKE type_file.num5,
       l_ac3         LIKE type_file.num5
 
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
DEFINE l_cnt               LIKE type_file.num5

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

   LET g_forupd_sql = "SELECT * FROM rch_file WHERE rch01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t801_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t801_w AT p_row,p_col WITH FORM "art/42f/artt801"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("rch073",FALSE)      #FUN-B50157 add
   CALL t801_menu()
   CLOSE WINDOW t801_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t801_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   DEFINE l_rch04     LIKE rch_file.rch04
 
   CLEAR FORM 
   CALL g_rci1.clear()
   CALL g_rce.clear()

    CALL cl_set_head_visible("","YES")
    INITIALIZE g_rch.* TO NULL
    CONSTRUCT BY NAME g_wc ON rch01,rch02,rch03,rch04,rch05,rch06,rch07,
                              rch071,rch073,rch072,rch08,rch09,rchconf,rchcond,
                              rchcont,rchconu,rch10,rch11,rchuser,rchgrup,
                              rchoriu,rchmodu,rchdate,rchorig,rchacti,rchcrat
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rch01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_rch01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rch01
                NEXT FIELD rch01
             WHEN INFIELD(rch05)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_azw"
                LET g_qryparam.where = " azw01 IN ",g_auth
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rch05
                NEXT FIELD rch05
             WHEN INFIELD(rch06)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_occ02"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rch06
                NEXT FIELD rch06
             WHEN INFIELD(rch07)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_gec"
                LET g_qryparam.arg1 = "2"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rch07
                NEXT FIELD rch07
                
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
    
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rchuser', 'rchgrup')
 
    LET g_wc  = g_wc  CLIPPED

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF

    LET g_sql = "SELECT DISTINCT rch01",
                "  FROM rch_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND rch05 IN ",g_auth,
                " ORDER BY rch01"
    PREPARE t801_prepare FROM g_sql
    DECLARE t801_cs
       SCROLL CURSOR WITH HOLD FOR t801_prepare
       
    LET g_sql = "SELECT COUNT(DISTINCT rch01) ",
                "  FROM rch_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND rch05 IN ",g_auth,
                " ORDER BY rch01"

    PREPARE t801_precount FROM g_sql
    DECLARE t801_count CURSOR FOR t801_precount
 
END FUNCTION
 
FUNCTION t801_menu()
DEFINE l_cmd   LIKE type_file.chr1000
DEFINE l_wc    LIKE type_file.chr500 
   WHILE TRUE
      CALL t801_bp("G")
      CASE g_action_choice
      
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t801_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t801_r()
            END IF
#FUN-B60054 ---------------------STA
         WHEN "output"
            IF NOT cl_null(g_rch.rch01) AND  cl_chk_act_auth() THEN
               MENU "" ATTRIBUTE(STYLE="popup")
                 ON ACTION output_r800
                    LET l_wc =  "rch01 = '",g_rch.rch01,"' AND rch05 = '",g_rch.rch05,"'"
                    LET l_cmd='artr800 ', '"" "" "" "Y" "" "" "',l_wc CLIPPED,'" "',
                               g_rch.rch03 CLIPPED,'" "',g_rch.rch04 CLIPPED,'" "" "Y" "" "" "" ""'
                    CALL cl_cmdrun(l_cmd)
                 ON ACTION output_r801
                    LET l_wc =  "rch01 = '",g_rch.rch01,"' AND rch05 = '",g_rch.rch05,"'"
                   #LET l_cmd='artr801 ', '"" "" "" "Y" "" "" "',l_wc CLIPPED,'" "',  #FUN-C30085 
                    LET l_cmd='artg801 ', '"" "" "" "Y" "" "" "',l_wc CLIPPED,'" "',  #FUN-C30085
                               g_rch.rch03 CLIPPED,'" "',g_rch.rch04 CLIPPED,'" "" "Y" "" "" "" ""'
                    CALL cl_cmdrun(l_cmd)
               END MENU

            END IF
#FUN-B60054 ---------------------END
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t801_yes()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t801_w()
            END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rci1),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rch.rch01 IS NOT NULL THEN
                 LET g_doc.column1 = "rch01"
                 LET g_doc.value1 = g_rch.rch01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t801_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rci1 TO s_rci1.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL t801_b2_fill()
            CALL cl_show_fld_cont()
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL t801_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t801_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t801_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t801_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t801_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
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
    
      DISPLAY ARRAY g_rce TO s_rce.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL t801_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t801_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t801_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t801_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t801_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
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

      DISPLAY ARRAY g_rci2 TO s_rci2.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL t801_b4_fill()
            CALL cl_show_fld_cont()
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL t801_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t801_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t801_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t801_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t801_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
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

      DISPLAY ARRAY g_lua TO s_lua.* ATTRIBUTE(COUNT=g_rec_b3)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            
         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL t801_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t801_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t801_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t801_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t801_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
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
#FUN-B60054 ---------------------STA
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG
#FUN-B60054 ---------------------END
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t801_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rci1.clear()
   CALL g_rci2.clear()
   CALL g_lua.clear()
   CALL g_rce.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t801_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rch.* TO NULL
      RETURN
   END IF
 
   OPEN t801_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rch.* TO NULL
   ELSE
      OPEN t801_count
      FETCH t801_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t801_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t801_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t801_cs INTO g_rch.rch01
      WHEN 'P' FETCH PREVIOUS t801_cs INTO g_rch.rch01
      WHEN 'F' FETCH FIRST    t801_cs INTO g_rch.rch01
      WHEN 'L' FETCH LAST     t801_cs INTO g_rch.rch01
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
        FETCH ABSOLUTE g_jump t801_cs INTO g_rch.rch01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rch.rch01,SQLCA.sqlcode,0)
      INITIALIZE g_rch.* TO NULL
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
 
   SELECT * INTO g_rch.* FROM rch_file 
    WHERE rch01 = g_rch.rch01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rch_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rch.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rch.rchuser
   LET g_data_group = g_rch.rchgrup
   LET g_data_plant = g_rch.rchplant    #TQC-BB0125 add 
   CALL t801_show()
 
END FUNCTION
 
FUNCTION t801_show()
DEFINE l_azw08    LIKE azw_file.azw08
DEFINE l_occ02    LIKE occ_file.occ02
 
   LET l_ac = 1
   LET l_ac1 = 1
   LET l_ac2 = 1
   LET l_ac3 = 1
   LET g_rch_t.* = g_rch.*
   LET g_rch_o.* = g_rch.*
   DISPLAY BY NAME g_rch.rch01,g_rch.rch02,g_rch.rch03,g_rch.rch04,
                   g_rch.rch05,g_rch.rch06,g_rch.rch07,g_rch.rch071,
                   g_rch.rch072,g_rch.rch073,g_rch.rch08,g_rch.rch09,
                   g_rch.rch10,g_rch.rch11,g_rch.rchconf,g_rch.rchcond,
                   g_rch.rchcont,g_rch.rchconu,g_rch.rchoriu,g_rch.rchorig,
                   g_rch.rchuser,g_rch.rchmodu,g_rch.rchacti,
                   g_rch.rchgrup,g_rch.rchdate,g_rch.rchcrat
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_rch.rch05 AND azwacti = 'Y'
   DISPLAY l_azw08 TO FORMONLY.rch05_desc
   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_rch.rch06 AND occacti = 'Y'
   DISPLAY l_occ02 TO FORMONLY.rch06_desc

   CALL t801_b1_fill()
   CALL t801_b2_fill()
   CALL t801_b3_fill()
   CALL t801_b4_fill()
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t801_b1_fill()
 
   LET g_sql = "SELECT '',rci04,'',rci05,rci06,rci07,rci08,rci09 ",
               "  FROM rci_file",
               " WHERE rci01 ='",g_rch.rch01,"' ",
               "   AND rci02 = '1'"
 
   LET g_sql=g_sql CLIPPED," ORDER BY rci03 "
 
   DISPLAY g_sql
 
   PREPARE sel_rci_pb1 FROM g_sql
   DECLARE sel_rci_cs1 CURSOR FOR sel_rci_pb1
 
   CALL g_rci1.clear()
   LET l_cnt = 1
   LET g_cnt = 1
 
   FOREACH sel_rci_cs1 INTO g_rci1[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT tqa02 INTO g_rci1[g_cnt].rci04_desc 
         FROM tqa_file WHERE tqa01 = g_rci1[g_cnt].rci04 AND tqaacti = 'Y'
          AND tqa03 = '29'
       LET g_rci1[g_cnt].rci03 = l_cnt
       LET l_cnt = l_cnt + 1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rci1.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t801_b2_fill()
DEFINE l_rcb02     LIKE rcb_file.rcb02
DEFINE l_rcb03     LIKE rcb_file.rcb03
DEFINE l_days   LIKE type_file.num5
DEFINE l_bdate  LIKE type_file.dat
DEFINE l_edate  LIKE type_file.dat

   LET l_days = cl_days(g_rch.rch03,g_rch.rch04)
   LET l_bdate = MDY(g_rch.rch04,1,g_rch.rch03)
   LET l_edate = MDY(g_rch.rch04,l_days,g_rch.rch03)

   LET g_sql = "SELECT rcb02,rcb03 ",
               "  FROM ",cl_get_target_table(g_rch.rch05,'rcb_file'),
               " WHERE rcb01 = '",g_rch.rch05,"' ",
               "   AND rcb05 = '",g_rci1[l_ac].rci04,"' ",
               "   AND rcb08 = '",g_rci1[l_ac].rci05,"' "
   PREPARE sel_rcb_pre FROM g_sql
   DECLARE sel_rcb_cs CURSOR FOR sel_rcb_pre

   CALL g_rce.clear()
   LET l_cnt = 1
   LET g_cnt = 1
   FOREACH sel_rcb_cs INTO l_rcb02,l_rcb03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      #LET g_sql = "SELECT rce01,'','',rce06,rce04,rce05 ",   #TQC-C20263 mark
      LET g_sql = "SELECT rce01,'',rce02,rce06,rce04,rce05 ", #TQC-C20263 add
                  "  FROM ",cl_get_target_table(g_rch.rch05,'rce_file'),
                  " WHERE rce01 IN (SELECT rcd01 FROM ",cl_get_target_table(g_rch.rch05,'rcd_file'),
                  "                  WHERE (rcd02 BETWEEN '",l_rcb02,"' ",
                  "                    AND '",l_rcb03,"') ",
                  "                    AND (rcd02 BETWEEN '",l_bdate,"' ",
                  "                    AND '",l_edate,"') ",
                  "                    AND rcdconf = 'Y'",
                  "                    AND rcd04 = '",g_rci1[l_ac].rci06,"') ",
                  "   AND rce03 = '",g_rci1[l_ac].rci04,"'"

      LET g_sql=g_sql CLIPPED," ORDER BY rce01 "
      PREPARE sel_rce_pre FROM g_sql
      DECLARE sel_rce_cs CURSOR FOR sel_rce_pre

      FOREACH sel_rce_cs INTO g_rce[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         LET g_sql = "SELECT rcd02 FROM ",cl_get_target_table(g_rch.rch05,'rcd_file'),
                     " WHERE rcd01 = '",g_rce[g_cnt].rce01,"' "
         PREPARE sel_rcd_pre FROM g_sql
         EXECUTE sel_rcd_pre INTO g_rce[g_cnt].rcd02
         #LET g_rce[g_cnt].rce02 = l_cnt     #TQC-C20263  mark
         LET l_cnt = l_cnt + 1
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF 
      END FOREACH 
   END FOREACH
   
   CALL g_rce.deleteElement(g_cnt)
   LET g_rec_b1=g_cnt-1
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t801_b3_fill()
 
   LET g_sql = "SELECT '',rci10,'',rci11,rci12 ",
               "  FROM rci_file",
               " WHERE rci01 ='",g_rch.rch01,"' ",
               "   AND rci02 = '2'"
 
   LET g_sql=g_sql CLIPPED," ORDER BY rci03 "
 
   DISPLAY g_sql
 
   PREPARE sel_rci_pb2 FROM g_sql
   DECLARE sel_rci_cs2 CURSOR FOR sel_rci_pb2
 
   CALL g_rci2.clear()
   LET l_cnt = 1
   LET g_cnt = 1
 
   FOREACH sel_rci_cs2 INTO g_rci2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT oaj02 INTO g_rci2[g_cnt].rci10_desc 
         FROM oaj_file WHERE oaj01 = g_rci2[g_cnt].rci10 AND oajacti = 'Y' 
       LET g_rci2[g_cnt].item1 = l_cnt
       LET l_cnt = l_cnt + 1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rci2.deleteElement(g_cnt)
 
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t801_b4_fill()
DEFINE l_days   LIKE type_file.num5
DEFINE l_bdate  LIKE type_file.dat
DEFINE l_edate  LIKE type_file.dat

   LET l_days = cl_days(g_rch.rch03,g_rch.rch04)
   LET l_bdate = MDY(g_rch.rch04,1,g_rch.rch03)
   LET l_edate = MDY(g_rch.rch04,l_days,g_rch.rch03)
   #LET g_sql = "SELECT lua01,lua09,'',lub03,'',lub04,lub04t ",   #TQC-C20263 mark
   LET g_sql = "SELECT lua01,lua09,lub02,lub03,'',lub04,lub04t ",  #TQC-C20263 add
               "  FROM ",cl_get_target_table(g_rch.rch05,'lua_file'),
               "      ,",cl_get_target_table(g_rch.rch05,'lub_file'),
               " WHERE lua01 = lub01",
               "   AND (lua09 BETWEEN '",l_bdate,"' AND '",l_edate,"') ",
               "   AND luaplant = '",g_rch.rch05,"' ",
               "   AND lub03 = '",g_rci2[l_ac2].rci10,"'",
               "   AND lua32 = '4'",
               "   AND lua15 = 'Y'"
 
   LET g_sql=g_sql CLIPPED," ORDER BY lua01 "
 
   DISPLAY g_sql
 
   PREPARE sel_lua_pre FROM g_sql
   DECLARE sel_lua_cs CURSOR FOR sel_lua_pre 
 
   CALL g_lua.clear()
   LET l_cnt = 1
   LET g_cnt = 1
 
   FOREACH sel_lua_cs INTO g_lua[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #LET g_lua[g_cnt].item2 = l_cnt    #TQC-C20263   mark
       LET g_sql = "SELECT oaj02 FROM ",cl_get_target_table(g_rch.rch05,'oaj_file'),
                   " WHERE oaj01 = '",g_lua[g_cnt].lub03,"' ",
                   "   AND oajacti = 'Y'"
       PREPARE sel_oaj_pre FROM g_sql
       EXECUTE sel_oaj_pre INTO g_lua[g_cnt].lub03_desc
       LET l_cnt = l_cnt + 1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lua.deleteElement(g_cnt)
 
   LET g_rec_b3=g_cnt-1
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t801_yes() 
DEFINE l_cnt      LIKE type_file.num5

   IF cl_null(g_rch.rch01) OR cl_null(g_rch.rch06) OR cl_null(g_rch.rch07) 
      OR cl_null(g_rch.rch071) OR cl_null(g_rch.rch072) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
#CHI-C30107 ----------- add ----------- begin
   IF g_rch.rchconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rch.rchacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ----------- add ----------- end
   SELECT * INTO g_rch.* FROM rch_file 
    WHERE rch01=g_rch.rch01
   IF g_rch.rchconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rch.rchacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rci_file
    WHERE rci01 = g_rch.rch01
      AND rci02 = '1'
   IF l_cnt = 0 OR l_cnt IS NULL THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM rci_file
       WHERE rci01 = g_rch.rch01
         AND rci02 = '2'
      IF l_cnt = 0 OR l_cnt IS NULL THEN
         CALL cl_err('','mfg-009',0)
         RETURN
      END IF 
   END IF
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t801_cl USING g_rch.rch01
   
   IF STATUS THEN
      CALL cl_err("OPEN t801_cl:", STATUS, 1)
      CLOSE t801_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t801_cl INTO g_rch.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rch.rch01,SQLCA.sqlcode,0)
      CLOSE t801_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rch_file SET rchconf='Y',
                       rchcond=g_today, 
                       rchcont=g_time, 
                       rchconu=g_user,
                       rchdate=g_today,
                       rchmodu=g_user
     WHERE  rch01=g_rch.rch01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rch.rchconf='Y'
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rch.* FROM rch_file 
    WHERE rch01=g_rch.rch01
   DISPLAY BY NAME g_rch.rchconf                                                                                         
   DISPLAY BY NAME g_rch.rchcond                                                                                         
   DISPLAY BY NAME g_rch.rchcont                                                                                         
   DISPLAY BY NAME g_rch.rchconu
   DISPLAY BY NAME g_rch.rchdate
   DISPLAY BY NAME g_rch.rchmodu
END FUNCTION

FUNCTION t801_w()

   IF g_rch.rch01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rch.* FROM rch_file
    WHERE rch01=g_rch.rch01
   IF g_rch.rchconf <> 'Y' THEN CALL cl_err('',9025,0) RETURN END IF

   LET g_success = 'Y'
   BEGIN WORK

   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF
   #FUN-B80085增加空白行

   LET g_time = TIME               #CHI-D20015
   UPDATE rch_file SET rchconf = 'N',
                      #CHI-D20015----mod--str
                      #rchconu='',
                      #rchcond='',
                      #rchcont = '',
                       rchconu=g_user,
                       rchcond=g_today,
                       rchcont = g_time,
                      #CHI-D20015---mod--end
                       rchdate=g_today,
                       rchmodu=g_user
    WHERE rch01 = g_rch.rch01

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rch_file",g_rch.rch01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      MESSAGE 'UPDATE rch_file OK'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rch.rchconf='N'
     #CHI-D20015---mod--str
     #LET g_rch.rchconu=NULL
     #LET g_rch.rchcond=NULL
     #LET g_rch.rchcont=NULL
      LET g_rch.rchconu=g_user
      LET g_rch.rchcond=g_today
      LET g_rch.rchcont=g_time
     #CHI-D20015---mod--end
      DISPLAY BY NAME g_rch.rchconf
      DISPLAY BY NAME g_rch.rchcond
      DISPLAY BY NAME g_rch.rchcont
      DISPLAY BY NAME g_rch.rchconu
      DISPLAY BY NAME g_rch.rchdate
      DISPLAY BY NAME g_rch.rchmodu
   ELSE
      LET g_rch.rchconu=g_rch_t.rchconu
      LET g_rch.rchcond=g_rch_t.rchcond
      LET g_rch.rchconf='Y'
      ROLLBACK WORK
   END IF
END FUNCTION

 
FUNCTION t801_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rch.rch01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rch.* FROM rch_file
    WHERE rch01=g_rch.rch01
 
   IF g_rch.rchconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rch.rchacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF

   BEGIN WORK
 
   OPEN t801_cl USING g_rch.rch01
   IF STATUS THEN
      CALL cl_err("OPEN t801_cl:", STATUS, 1)
      CLOSE t801_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t801_cl INTO g_rch.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rch.rch01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t801_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rch01"      
       LET g_doc.value1 = g_rch.rch01    
       CALL cl_del_doc()
      DELETE FROM rch_file WHERE rch01 = g_rch.rch01
      DELETE FROM rci_file WHERE rci01 = g_rch.rch01

      CLEAR FORM
      CALL g_rci1.clear() 
      CALL g_rci2.clear()
      CALL g_lua.clear()
      CALL g_rce.clear()

      OPEN t801_count
      FETCH t801_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t801_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t801_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t801_fetch('/')
      END IF
   END IF
 
   CLOSE t801_cl
   COMMIT WORK
END FUNCTION

FUNCTION t801_b2_refresh()

   DISPLAY ARRAY g_rce TO s_rce.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t801_b4_refresh()

   DISPLAY ARRAY g_lua TO s_lua.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

#FUN-B50034
