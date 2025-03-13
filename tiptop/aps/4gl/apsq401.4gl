# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apsq401.4gl
# Descriptions...: MDS沖銷關聯明細查詢
# Date & Author..: No.FUN-860009 08/06/03 By Mandy
# Date & Author..: No.FUN-870104 08/07/22 By Mandy (1)add vlf15,vlf25
#                                                  (2)沖銷明細加上沖銷量合計
# Modify.........: No.TQC-890023 08/09/18 BY DUKE 查詢未輸入條件時按下放棄,視窗應不用關閉
# Modify.........: No.EXT-940020 09/05/06 BY DUKE 系統模組 cl_setup應為 APS
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0125 09/12/22 By Mandy ERP MDS功能調整
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版
# Modify.........: NO.FUN-B60063 11/07/31 By Mandy MDS效率優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_up         LIKE type_file.chr1         #FUN-860009
DEFINE g_vlf01      LIKE vlf_file.vlf01
DEFINE g_vlf02      LIKE vlf_file.vlf02
DEFINE
    g_vlf_a         DYNAMIC ARRAY OF RECORD
                    vlf03     LIKE vlf_file.vlf03,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,
                    vlf04     LIKE vlf_file.vlf04,
                    vlf06     LIKE vlf_file.vlf06,
                    vlf07     LIKE vlf_file.vlf07 
                    END RECORD,
    g_vlf_b         DYNAMIC ARRAY OF RECORD
                    vlf05     LIKE vlf_file.vlf05,
                    vlf10     LIKE vlf_file.vlf10,
                    vlf11     LIKE vlf_file.vlf11,
                    vlf12     LIKE vlf_file.vlf12,
                    vlf13     LIKE vlf_file.vlf13,
                    vlf15     LIKE vlf_file.vlf15, #FUN-870104 add
                    vlf16     LIKE vlf_file.vlf16,
                    vlf17     LIKE vlf_file.vlf17,
                    vlf18     LIKE vlf_file.vlf18,
                    vlf19     LIKE vlf_file.vlf19,
                    vlf20     LIKE vlf_file.vlf20,
                    vlf21     LIKE vlf_file.vlf21,
                    occ02     LIKE occ_file.occ02,
                    vlf22     LIKE vlf_file.vlf22,
                    vlf23     LIKE vlf_file.vlf23,
                    gen02     LIKE gen_file.gen02,
                    vlf24     LIKE vlf_file.vlf24,
                    vlf25     LIKE vlf_file.vlf25, #FUN-870104 add
                    vlf26     LIKE vlf_file.vlf26,
                    vlf27     LIKE vlf_file.vlf27,
                    vlf28     LIKE vlf_file.vlf28,
                    vlf29     LIKE vlf_file.vlf29
                    END RECORD,
    g_plant_1       DYNAMIC ARRAY OF RECORD
                    no        LIKE azp_file.azp01,
                    db_name   LIKE azp_file.azp03
                    END RECORD,
    g_wc1           STRING,
    g_oga99_wc      STRING,
    g_rec_b1        LIKE type_file.num5,          #單身筆數        
    g_rec_b2        LIKE type_file.num5,          #單身筆數        
    g_sql           STRING,
    l_ac,l_ac_t     LIKE type_file.num5,          
    p_row,p_col     LIKE type_file.num5           
DEFINE   g_msg      LIKE type_file.chr1000   #FUN-9C0125 add
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  #IF (NOT cl_setup("AXM")) THEN   #EXT-940020 MARK
   IF (NOT cl_setup("APS")) THEN   #EXT-940020 ADD
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)  
 
   #顯示畫面
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW q401_w AT p_row,p_col WITH FORM "aps/42f/apsq401"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL q401_def_form()    #FUN-9C0125 add

   CALL cl_set_comp_visible("vlf05",FALSE) #FUN-B60063 add

   CALL q401_menu()
   CLOSE WINDOW q401_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #計算使用時間 (退出使間)   
END MAIN
 
#QBE 查詢資料
FUNCTION q401_cs()
   DEFINE l_vlz70    LIKE vlz_file.vlz70 #FUN-9C0125 add

   CLEAR FORM                             #清除畫面
  #FUN-9C0125 ---mod---str---
  #LET g_vlf01 = NULL
   IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
       LET g_vlf01 = 'TP'
   ELSE
       LET g_vlf01 = NULL
   END IF
  #FUN-9C0125 ---mod---end---
   LET g_vlf02 = NULL
   INPUT g_vlf01,g_vlf02 WITHOUT DEFAULTS FROM vlf01,vlf02
      
 
     AFTER INPUT
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              #EXIT PROGRAM   #TQC-890023
              RETURN      #TQC-890023
           END IF
     ON ACTION controlp
        CASE
           WHEN INFIELD(vlf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vlf01"
              CALL cl_create_qry() RETURNING g_vlf01,g_vlf02
              DISPLAY BY NAME g_vlf01,g_vlf02
              NEXT FIELD vlf01
           #FUN-9C0125---add----str---
           WHEN INFIELD(vlf02)     
              IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_vlz02"
                  CALL cl_create_qry() RETURNING g_vlf02,l_vlz70
                  DISPLAY g_vlf02 TO FORMONLY.vlf02       
                  NEXT FIELD vlf02
              END IF
           #FUN-9C0125---add----end---
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
  CALL g_vlf_a.clear()
  CALL g_vlf_b.clear()
  CONSTRUCT g_wc1 ON vlf03,vlf04,vlf06,vlf07,
                     vlf29
                FROM s_vlf_a[1].vlf03,s_vlf_a[1].vlf04,s_vlf_a[1].vlf06,s_vlf_a[1].vlf07,
                     s_vlf_b[1].vlf29
        ON ACTION controlp
           CASE
              WHEN INFIELD(vlf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.vlf03
                   NEXT FIELD vlf03
 
              OTHERWISE EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
  END CONSTRUCT
  LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  IF INT_FLAG THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION q401_menu()
   WHILE TRUE
      CALL q401_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q401_q()
            END IF
 
         WHEN "view1"
              CALL q401_bp2()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_up = 'R'
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q401_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_vlf_a.clear()
    CALL g_vlf_b.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    CALL q401_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL q401_b1_fill(g_wc1)
 
    LET l_ac = 1
END FUNCTION
 
 
FUNCTION q401_b1_fill(p_wc1)
DEFINE  l_vlf07      LIKE vlf_file.vlf07 #FUN-B60063 add
DEFINE  p_wc1        STRING
DEFINE  l_last       LIKE poy_file.poy02,
        l_last_plant LIKE poy_file.poy04
 
    IF cl_null(p_wc1) THEN
       LET p_wc1 = ' 1=1'
    END IF
 
    LET g_sql = "SELECT unique vlf03,'','',vlf04,vlf06,vlf07 ",
                "  FROM vlf_file ",
                " WHERE ",p_wc1 CLIPPED,
                "   AND vlf01 = '",g_vlf01,"'",
                "   AND vlf02 = '",g_vlf02,"'",
                " ORDER BY vlf03,vlf04"
    PREPARE q401_pre1 FROM g_sql
    DECLARE q401_cs1 CURSOR FOR q401_pre1
 
    CALL g_vlf_a.clear()
    LET g_rec_b1 = 1
    DISPLAY ' ' TO FORMONLY.cnt
 
    FOREACH q401_cs1 INTO g_vlf_a[g_rec_b1].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('b1_fill foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        SELECT ima02,ima021
          INTO g_vlf_a[g_rec_b1].ima02,g_vlf_a[g_rec_b1].ima021
          FROM ima_file
         WHERE ima01 = g_vlf_a[g_rec_b1].vlf03
        #FUN-B60063---add---str--
        #因為#0:零期資料 9:獨立需求 vlf07的值在apsp400沒有算出,故在此合計
        IF g_vlf_a[g_rec_b1].vlf06 MATCHES "[09]" THEN #0:零期資料 9:獨立需求
            SELECT SUM(vlf18)
              INTO l_vlf07
              FROM vlf_file 
             WHERE vlf01 = g_vlf01
               AND vlf02 = g_vlf02
               AND vlf03 = g_vlf_a[g_rec_b1].vlf03
               AND vlf04 = g_vlf_a[g_rec_b1].vlf04
               AND vlf06 = g_vlf_a[g_rec_b1].vlf06 
           LET g_vlf_a[g_rec_b1].vlf07 = l_vlf07
        END IF
        IF cl_null(g_vlf_a[g_rec_b1].vlf07) THEN
            LET g_vlf_a[g_rec_b1].vlf07 = 0
        END IF
        #FUN-B60063---add---end--
 
        LET g_rec_b1 = g_rec_b1 + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err('', 9035, 0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vlf_a.deleteElement(g_rec_b1)
    LET g_rec_b1 = g_rec_b1 - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt
END FUNCTION
 
FUNCTION q401_b2_fill()
DEFINE  l_i      LIKE type_file.num5          
 
    CALL g_vlf_b.clear()
    LET g_rec_b2 = 1
    DISPLAY ' ' TO FORMONLY.cn2
 
 
        LET g_sql = "SELECT vlf05,vlf10,vlf11,vlf12,vlf13,vlf15,vlf16,vlf17,vlf18,vlf19,",             #FUN-870104 add vlf15
                    "       vlf20,vlf21,''   ,vlf22,vlf23,''   ,vlf24,vlf25,vlf26,vlf27,vlf28,vlf29 ", #FUN-870104 add vlf25
                    "  FROM vlf_file ",
                    " WHERE vlf01 = '",g_vlf01,"'",
                    "   AND vlf02 = '",g_vlf02,"'",
                    "   AND vlf03 = '",g_vlf_a[l_ac].vlf03,"'",
                    "   AND vlf04 = '",g_vlf_a[l_ac].vlf04,"'",
                    "   AND vlf06 = '",g_vlf_a[l_ac].vlf06,"'", #FUN-B60063 add
                    " ORDER BY vlf05"
        PREPARE q401_pre2 FROM g_sql
        DECLARE q401_cs2 CURSOR FOR q401_pre2
 
 
        IF NOT(g_rec_b2 > g_max_rec) THEN
           FOREACH q401_cs2 INTO g_vlf_b[g_rec_b2].*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('b2_fill foreach1:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              SELECT occ02 
                INTO g_vlf_b[g_rec_b2].occ02
                FROM occ_file
               WHERE occ01 = g_vlf_b[g_rec_b2].vlf21
 
              SELECT gen02
                INTO g_vlf_b[g_rec_b2].gen02
                FROM gen_file
               WHERE gen01 = g_vlf_b[g_rec_b2].vlf23
 
 
 
              LET g_rec_b2 = g_rec_b2 + 1
              IF g_rec_b2 > g_max_rec THEN
                 CALL cl_err('',9035,0)
                 EXIT FOREACH
              END IF
           END FOREACH
        END IF
        #FUN-870104---add---str--
        #(2)沖銷明細加上沖銷量合計
        SELECT SUM(vlf18),SUM(vlf28)             
          INTO g_vlf_b[g_rec_b2].vlf18,g_vlf_b[g_rec_b2].vlf28
          FROM vlf_file 
         WHERE vlf01 = g_vlf01
           AND vlf02 = g_vlf02
           AND vlf03 = g_vlf_a[l_ac].vlf03
           AND vlf04 = g_vlf_a[l_ac].vlf04
           AND vlf06 = g_vlf_a[l_ac].vlf06 #FUN-B60063 add
 
         IF NOT cl_null(g_vlf_b[g_rec_b2].vlf18) THEN
             LET g_vlf_b[g_rec_b2].vlf16 = 'TOTAL:'
         END IF
         IF NOT cl_null(g_vlf_b[g_rec_b2].vlf28) THEN
             LET g_vlf_b[g_rec_b2].vlf26 = 'TOTAL:'
         END IF
        #FUN-870104---add---end--
        
 
   #CALL g_vlf_b.deleteElement(g_rec_b2) #FUN-870104 mark
 
    LET g_rec_b2 = g_rec_b2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
 
END FUNCTION
 
 
FUNCTION q401_bp()
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  # IF g_up <> "G" THEN
   IF g_up = "V" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vlf_a TO s_vlf_a.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
        #IF q401_plant() THEN
            CALL q401_b2_fill()
        #   CALL q401_b3_fill()
        #   CALL q401_b4_fill()
        #ELSE
        #   CALL g_vlf_b.clear()
        #   CALL g_oga_b.clear()
        #   CALL g_oma_b.clear()
        #   DISPLAY 0 TO FORMONLY.cn2
        #   DISPLAY 0 TO FORMONLY.cn3
        #   DISPLAY 0 TO FORMONLY.cn4
        #END IF
         CALL q401_bp2_refresh()
        #CALL q401_bp3_refresh()
        #CALL q401_bp4_refresh()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL q401_def_form()    #FUN-9C0125 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT DISPLAY
 
     #ON ACTION view2
     #   LET g_action_choice = "view2"
     #   EXIT DISPLAY
 
     #ON ACTION view3
     #   LET g_action_choice = "view3"
     #   EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q401_bp2_refresh()
   DISPLAY ARRAY g_vlf_b TO s_vlf_b.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
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
 
 
 
FUNCTION q401_bp2()
   DEFINE   p_ud   LIKE type_file.chr1          
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vlf_b TO s_vlf_b.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE ROW
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL q401_def_form()    #FUN-9C0125 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_up = "V"
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      #將focus指回單頭
      ON ACTION return
         LET g_up = "R"
         LET g_action_choice="return"
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-9C0125---add---str---
FUNCTION q401_def_form()
   IF cl_null(g_sma.sma901) OR g_sma.sma901 = 'N' THEN
      CALL cl_set_comp_visible("vlf01",FALSE)          #APS版本
      LET g_vlf01 = 'TP'                           
      CALL cl_getmsg('aps-450',g_lang) RETURNING g_msg #MDS版本
      CALL cl_set_comp_att_text("vlf02",g_msg CLIPPED)
   END IF
END FUNCTION
#FUN-9C0125---add---end---
#FUN-B50050
