# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axmq950.4gl
# Descriptions...: 批/序號追蹤
# Date & Author..: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-850120 08/05/20 By rainy 單頭改為 imgs_file/ 單身數量出庫以負數表式/新增明細資料Action
# Modify.........: No.MOD-920255 09/02/19 By claire tlfs12值改為tlfs111
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80011 11/08/03 By Sakura 加入excel匯出功能，匯出單身一
# Modify.........: No.MOD-C10019 12/01/09 By Elise mark q950_bp2()...CALL cl_set_act_visible(accept,cancel", FALSE)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
#FUN-850120 begin
#DEFINE g_tlfs   DYNAMIC ARRAY OF RECORD
#                  tlfs01     LIKE tlfs_file.tlfs01,
#                  ima02      LIKE ima_file.ima02,
#                  ima021     LIKE ima_file.ima021,
#                  tlfs02     LIKE tlfs_file.tlfs02,
#                  tlfs03     LIKE tlfs_file.tlfs03,
#                  tlfs04     LIKE tlfs_file.tlfs04,
#                  tlfs06     LIKE tlfs_file.tlfs06,
#                  tlfs05     LIKE tlfs_file.tlfs05,
#                  name       LIKE smy_file.smydesc,
#                  tlfs10     LIKE tlfs_file.tlfs10,
#                  tlfs11     LIKE tlfs_file.tlfs11,
#                  tlfs12     LIKE tlfs_file.tlfs12,
#                  tlfs13     LIKE tlfs_file.tlfs13,
#                  tlfs07     LIKE tlfs_file.tlfs07
#               END RECORD,
#       g_tlfs_t RECORD
#                  tlfs01     LIKE tlfs_file.tlfs01,
#                  ima02      LIKE ima_file.ima02,
#                  ima021     LIKE ima_file.ima021,
#                  tlfs02     LIKE tlfs_file.tlfs02,
#                  tlfs03     LIKE tlfs_file.tlfs03,
#                  tlfs04     LIKE tlfs_file.tlfs04,
#                  tlfs06     LIKE tlfs_file.tlfs06,
#                  tlfs05     LIKE tlfs_file.tlfs05,
#                  name       LIKE smy_file.smydesc,
#                  tlfs10     LIKE tlfs_file.tlfs10,
#                  tlfs11     LIKE tlfs_file.tlfs11,
#                  tlfs12     LIKE tlfs_file.tlfs12,
#                  tlfs13     LIKE tlfs_file.tlfs13,
#                  tlfs07     LIKE tlfs_file.tlfs07
#               END RECORD,
DEFINE g_imgs   DYNAMIC ARRAY OF RECORD
                  imgs01     LIKE imgs_file.imgs01,
                  ima02      LIKE ima_file.ima02,
                  ima021     LIKE ima_file.ima021,
                  imgs02     LIKE imgs_file.imgs02,
                  imgs03     LIKE imgs_file.imgs03,
                  imgs04     LIKE imgs_file.imgs04,
                  imgs06     LIKE imgs_file.imgs06,
                  imgs05     LIKE imgs_file.imgs05,
                  imgs09     LIKE imgs_file.imgs09,
                  imgs08     LIKE imgs_file.imgs08,
                  imgs07     LIKE imgs_file.imgs07
               END RECORD,
       g_imgs_t RECORD
                  imgs01     LIKE imgs_file.imgs01,
                  ima02      LIKE ima_file.ima02,
                  ima021     LIKE ima_file.ima021,
                  imgs02     LIKE imgs_file.imgs02,
                  imgs03     LIKE imgs_file.imgs03,
                  imgs04     LIKE imgs_file.imgs04,
                  imgs06     LIKE imgs_file.imgs06,
                  imgs05     LIKE imgs_file.imgs05,
                  imgs09     LIKE imgs_file.imgs09,
                  imgs08     LIKE imgs_file.imgs08,
                  imgs07     LIKE imgs_file.imgs07
               END RECORD,
#FUN-850120 end
       g_tlfs2 DYNAMIC ARRAY OF RECORD
                  name_2     LIKE smy_file.smydesc,
                  tlfs10_2   LIKE tlfs_file.tlfs10,
                  tlfs11_2   LIKE tlfs_file.tlfs11,
                  tlfs111_2  LIKE tlfs_file.tlfs111, #MOD-920255
                 #tlfs12_2   LIKE tlfs_file.tlfs12,  #MOD-920255 mark
                  tlfs13_2   LIKE tlfs_file.tlfs13,
                #FUN-850120 begin
                  tlfs08     LIKE tlfs_file.tlfs08,
                  tlfs09     LIKE tlfs_file.tlfs09
                #FUN-850120 end
               END RECORD,
       g_tlfs2_t RECORD
                  name_2     LIKE smy_file.smydesc,
                  tlfs10_2   LIKE tlfs_file.tlfs10,
                  tlfs11_2   LIKE tlfs_file.tlfs11,
                  tlfs111_2  LIKE tlfs_file.tlfs111, #MOD-920255
                 #tlfs12_2   LIKE tlfs_file.tlfs12,  #MOD-920255 mark
                  tlfs13_2   LIKE tlfs_file.tlfs13,
                #FUN-850120 begin
                  tlfs08     LIKE tlfs_file.tlfs08,
                  tlfs09     LIKE tlfs_file.tlfs09
                #FUN-850120 end
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,
       g_rec_b1       LIKE type_file.num5,
       l_ac1          LIKE type_file.num5,
       l_ac1_t        LIKE type_file.num5,
       l_ac           LIKE type_file.num5
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_sheet        LIKE smy_file.smyslip
 
MAIN
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q950_w AT p_row,p_col WITH FORM "axm/42f/axmq950"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("tlfs08,tlfs09", FALSE)  #FUN-850120
 
   CALL q950_menu()
 
   CLOSE WINDOW q950_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q950_menu()
 
   WHILE TRUE
      CALL q950_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q950_q()
            END IF
        #FUN-850120 begin
         WHEN "view"
            CALL q950_bp2('v') 
        #FUN-850120 end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #FUN-B80011 begin
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imgs),'','')
            END IF
        #FUN-B80011 end
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q950_q()
 
   CALL q950_b_askkey()
 
END FUNCTION
 
FUNCTION q950_b_askkey()
   CLEAR FORM
  #FUN-850120 begin
   #CALL g_tlfs.clear()
 
   #CONSTRUCT g_wc2 ON tlfs01,tlfs02,tlfs03,tlfs04,tlfs06,
   #                   tlfs05,tlfs10,tlfs12,tlfs13,tlfs07
   #              FROM s_tlfs[1].tlfs01,s_tlfs[1].tlfs02,s_tlfs[1].tlfs03,
   #                   s_tlfs[1].tlfs04,s_tlfs[1].tlfs06,s_tlfs[1].tlfs05,
   #                   s_tlfs[1].tlfs10,s_tlfs[1].tlfs12,s_tlfs[1].tlfs13,
   #                   s_tlfs[1].tlfs07
   CALL g_imgs.clear()
 
   CONSTRUCT g_wc2 ON imgs01,imgs02,imgs03,imgs04,imgs06,
                      imgs05,imgs09,imgs08,tlfs07
                 FROM s_imgs[1].imgs01,s_imgs[1].imgs02,s_imgs[1].imgs03,
                      s_imgs[1].imgs04,s_imgs[1].imgs06,s_imgs[1].imgs05,
                      s_imgs[1].imgs09,s_imgs[1].imgs08,s_imgs[1].imgs07
  #FUN-850120 end
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
             #FUN-850120 begin
               #WHEN INFIELD(tlfs01)
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.state = "c"
               #     LET g_qryparam.form ="q_ima"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
               #     DISPLAY g_qryparam.multiret TO tlfs01
               #     NEXT FIELD tlfs01
               WHEN INFIELD(imgs01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ima"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imgs01
                    NEXT FIELD imgs01
             #FUN-850120 end
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL q950_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   #LET g_tlfs_t.* = g_tlfs[l_ac1].*  #FUN-850120
   LET g_imgs_t.* = g_imgs[l_ac1].*   #FUN-850120
 
   CALL q950_b_fill()
END FUNCTION
 
#FUN-850120 begin
#FUNCTION q950_b1_fill(p_wc2)
#   DEFINE p_wc2     STRING
#
#   LET g_sql = "SELECT tlfs01,'','',tlfs02,tlfs03,tlfs04,tlfs06,tlfs05,",
#               "       '',tlfs10,tlfs11,tlfs12,tlfs13,tlfs07", 
#               "  FROM tlfs_file",
#               " WHERE ",p_wc2 CLIPPED,
#               " ORDER BY tlfs01"
#
#   PREPARE q950_pb1 FROM g_sql
#   DECLARE tlfs_curs CURSOR FOR q950_pb1
#  
#   CALL g_tlfs.clear()
#  
#   LET g_cnt = 1
#   MESSAGE "Searching!"
#
#   FOREACH tlfs_curs INTO g_tlfs[g_cnt].*
#      IF STATUS THEN
#         CALL cl_err("foreach:",STATUS,1)   #No.FUN-660167
#         EXIT FOREACH
#      END IF
#
#      SELECT ima02,ima021
#        INTO g_tlfs[g_cnt].ima02,g_tlfs[g_cnt].ima021
#        FROM ima_file
#       WHERE ima01 = g_tlfs[g_cnt].tlfs01
#
#      CALL s_get_doc_no(g_tlfs[g_cnt].tlfs10) RETURNING g_sheet
#
#      SELECT smydesc INTO g_tlfs[g_cnt].name
#        FROM smy_file 
#       WHERE smyslip = g_sheet 
#
#      LET g_cnt = g_cnt + 1
#
#      IF g_cnt > g_max_rec THEN
#         CALL cl_err("",9035,0)
#         EXIT FOREACH
#      END IF
#
#   END FOREACH
#
#   CALL g_tlfs.deleteElement(g_cnt)
#   MESSAGE ""
#   LET g_rec_b1 = g_cnt - 1
#   DISPLAY g_rec_b1 TO FORMONLY.cn3
#   LET g_cnt = 0
#
#END FUNCTION
 
FUNCTION q950_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = "SELECT imgs01,'','',imgs02,imgs03,imgs04,",
               "       imgs06,imgs05,imgs09,imgs08,imgs07", 
               "  FROM imgs_file",
               " WHERE ",p_wc2 CLIPPED,
               " ORDER BY imgs01"
 
   PREPARE q950_pb1 FROM g_sql
   DECLARE imgs_curs CURSOR FOR q950_pb1
  
   CALL g_imgs.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH imgs_curs INTO g_imgs[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   #No.FUN-660167
         EXIT FOREACH
      END IF
 
      SELECT ima02,ima021
        INTO g_imgs[g_cnt].ima02,g_imgs[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_imgs[g_cnt].imgs01
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_imgs.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0
 
END FUNCTION
#FUN-850120 end
 
 
FUNCTION q950_b_fill()
 
  #FUN-850120 begin
   #LET g_sql = "SELECT '',tlfs10,tlfs11,tlfs12,tlfs13", 
   #            "  FROM tlfs_file",
   #            " WHERE tlfs01 = '",g_tlfs_t.tlfs01 CLIPPED,"'",
   #            "   AND tlfs02 = '",g_tlfs_t.tlfs02,"'",                         
   #            "   AND tlfs03 = '",g_tlfs_t.tlfs03,"'",                         
   #            "   AND tlfs04 = '",g_tlfs_t.tlfs04,"'",                         
   #            "   AND tlfs05 = ",g_tlfs_t.tlfs05,                              
   #            "   AND tlfs06 = '",g_tlfs_t.tlfs06,"'",                         
   #            " ORDER BY tlfs10"
   #LET g_sql = "SELECT '',tlfs10,tlfs11,tlfs12,tlfs13,tlfs08,tlfs09",  #MOD-920255 mark
   LET g_sql = "SELECT '',tlfs10,tlfs11,tlfs111,tlfs13,tlfs08,tlfs09",  #MOD-920255
               "  FROM tlfs_file",
               " WHERE tlfs01 =? ",
               "   AND tlfs02 =? ",       
               "   AND tlfs03 =? ",       
               "   AND tlfs04 =? ",       
               "   AND tlfs05 =? ",         
               "   AND tlfs06 =? ",       
               " ORDER BY tlfs10"
  #FUN-850120 end
   DISPLAY g_sql
 
   PREPARE q950_pb FROM g_sql
   DECLARE tlfs2_curs CURSOR FOR q950_pb
  
   CALL g_tlfs2.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
  
  #FUN-850120 begin
   #FOREACH tlfs2_curs INTO g_tlfs2[g_cnt].*
   FOREACH tlfs2_curs USING g_imgs_t.imgs01,g_imgs_t.imgs02,g_imgs_t.imgs03,
                            g_imgs_t.imgs04,g_imgs_t.imgs05,g_imgs_t.imgs06
                      INTO g_tlfs2[g_cnt].*  
  #FUN-850120 end
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
     #FUN-850120 begin  #出庫數量要為負數
      IF g_tlfs2[g_cnt].tlfs09 = -1 THEN
         LET g_tlfs2[g_cnt].tlfs13_2 = g_tlfs2[g_cnt].tlfs13_2 * (-1)
      END IF
     #FUN-850120 end
 
      CALL s_get_doc_no(g_tlfs2[g_cnt].tlfs10_2) RETURNING g_sheet
 
      SELECT smydesc INTO g_tlfs2[g_cnt].name_2
        FROM smy_file 
       WHERE smyslip = g_sheet 
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_tlfs2.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
#FUNCTION q950_bp2()      #FUN-850120
FUNCTION q950_bp2(p_cmd)  #FUN-850120
  DEFINE p_cmd  LIKE type_file.chr1  #FUN-850120
 
   #CALL cl_set_act_visible("accept,cancel", FALSE) #FUN-850120 add    #MOD-C10019 mark
   DISPLAY ARRAY g_tlfs2 TO s_tlfs2.* ATTRIBUTE(COUNT=g_rec_b)
 
     #FUN-850120 begin
      #BEFORE DISPLAY
      #   EXIT DISPLAY
      BEFORE DISPLAY
        IF cl_null(p_cmd) THEN
          EXIT DISPLAY
        END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      
      ON ACTION transaction_detail
         LET g_action_choice = "transaction_detail"
         CALL q950_detail_data()
      
      ON ACTION return
         EXIT DISPLAY
     #FUN-850120 end
 
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
 
 
FUNCTION q950_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   #DISPLAY ARRAY g_tlfs TO s_tlfs.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW) #FUN-850120
   DISPLAY ARRAY g_imgs TO s_imgs.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)  #FUN-850120
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         IF l_ac1 = 0 THEN
            LET l_ac1 = 1
         END IF
         CALL cl_show_fld_cont()
         LET l_ac1_t = l_ac1
         #LET g_tlfs_t.* = g_tlfs[l_ac1].*  #FUN-850120
         LET g_imgs_t.* = g_imgs[l_ac1].*   #FUN-850120
         CALL q950_b_fill()
         #CALL q950_bp2()  #FUN-850120 
         CALL q950_bp2('') #FUN-850120 
      
      #FUN-850120 add begin
       ON ACTION view   #瀏覽單身
         LET g_action_choice="view"
         EXIT DISPLAY
      #FUN-850120 end

      #FUN-B80011 begin
       ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #FUN-B80011 end
 
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
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
 
#No.FUN-810036
 
 
#FUN-850120 begin
FUNCTION q950_detail_data()
  DEFINE l_cmd  STRING
  
  #CASE g_tlfs2[l_ac].tlfs08
  #   WHEN "aimt301" 
  #   WHEN "aimt302" 
  #  
  #END CASE
  LET l_cmd = g_tlfs2[l_ac].tlfs08 ," '", g_tlfs2[l_ac].tlfs10_2,"' "
  DISPLAY l_cmd
  CALL cl_cmdrun_wait(l_cmd)
 
END FUNCTION
#FUN-850120 end
