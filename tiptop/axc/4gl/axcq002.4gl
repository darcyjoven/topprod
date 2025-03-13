# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axcq002.4gl
# Descriptions...: 入庫成本調整月報
# Date & Author..: 12/08/06 By Jiangxt
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,最大筆數控制與excel導出處理
# Modify.........: No.FUN-D10022 13/02/21 By xianghui 優化性能
# Modify.........: No.TQC-D20052 13/02/26 By xianghui where條件中沒有去空格
# Modify.........: No.TQC-D50098 13/05/21 By fengrui g_filter_wc赋值为' 1=1'
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
   DEFINE tm,tm_t  RECORD      #FUN-D10022 tm_t       # Print condition RECORD
              wc       LIKE type_file.chr1000,        #No.FUN-680122CHAR(600),      # Where condition
              sy       LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              sm       LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              type     LIKE ccb_file.ccb06,           #No.FUN-7C0101 adde
              a        LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              b        LIKE type_file.chr1,           #FUN-D10022
              auto_gen LIKE type_file.chr1,
              g        LIKE type_file.chr1            #No.FUN-680122CHAR(01)
              END RECORD                                                        
   DEFINE   g_sql           STRING                   #No.FUN-780017     
   DEFINE   l_table         STRING
   DEFINE   g_action_flag   LIKE type_file.chr10     #FUN-D10022 
   DEFINE   g_filter_wc     STRING                   #FUN-D10022 
   DEFINE   g_flag          LIKE type_file.chr1      #FUN-D10022
   DEFINE   g_rec_b         LIKE type_file.num10   
   DEFINE   g_rec_b2        LIKE type_file.num10     #FUN-D10022
   DEFINE   g_cnt           LIKE type_file.num10
   DEFINE   g_row_count     LIKE type_file.num10
   DEFINE   g_curs_index    LIKE type_file.num10
   DEFINE   l_ac            LIKE type_file.num5
   DEFINE   l_ac1           LIKE type_file.num5      #FUN-D10022
   DEFINE   g_str           STRING                   #No.FUN-780017 
   DEFINE   g_sum           LIKE ccb_file.ccb22
   DEFINE   g_sum1          LIKE ccb_file.ccb22
   DEFINE   g_sum2          LIKE ccb_file.ccb22
   DEFINE   g_sum3          LIKE ccb_file.ccb22
   DEFINE   g_sum4          LIKE ccb_file.ccb22
   DEFINE   g_sum5          LIKE ccb_file.ccb22
   DEFINE   g_sum6          LIKE ccb_file.ccb22
   DEFINE   g_sum7          LIKE ccb_file.ccb22
   DEFINE   g_sum8          LIKE ccb_file.ccb22
   DEFINE   g_ccb     DYNAMIC ARRAY OF RECORD
            ima08     LIKE ima_file.ima08,
            ima12     LIKE ima_file.ima12,
            ima01     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            ima57     LIKE ima_file.ima57,   #FUN-D10022
            ccb22a    LIKE ccb_file.ccb22,
            ccb22b    LIKE ccb_file.ccb22,
            ccb22d    LIKE ccb_file.ccb22,
            ccb22c    LIKE ccb_file.ccb22,
            ccb22e    LIKE ccb_file.ccb22,
            ccb22f    LIKE ccb_file.ccb22,
            ccb22g    LIKE ccb_file.ccb22,
            ccb22h    LIKE ccb_file.ccb22
            END RECORD
   #FUN-D10022--add--str--         
   DEFINE   g_ccb_1   DYNAMIC ARRAY OF RECORD
            ima08     LIKE ima_file.ima08,
            ima12     LIKE ima_file.ima12,
            ima01     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            ima57     LIKE ima_file.ima57,
            ccb22a    LIKE ccb_file.ccb22,
            ccb22b    LIKE ccb_file.ccb22,
            ccb22d    LIKE ccb_file.ccb22,
            ccb22c    LIKE ccb_file.ccb22,
            ccb22e    LIKE ccb_file.ccb22,
            ccb22f    LIKE ccb_file.ccb22,
            ccb22g    LIKE ccb_file.ccb22,
            ccb22h    LIKE ccb_file.ccb22
            END RECORD
   DEFINE   g_ccb_1_excel  DYNAMIC ARRAY OF RECORD
            ima08     LIKE ima_file.ima08,
            ima12     LIKE ima_file.ima12,
            ima01     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            ima57     LIKE ima_file.ima57,   
            ccb22a    LIKE ccb_file.ccb22,
            ccb22b    LIKE ccb_file.ccb22,
            ccb22d    LIKE ccb_file.ccb22,
            ccb22c    LIKE ccb_file.ccb22,
            ccb22e    LIKE ccb_file.ccb22,
            ccb22f    LIKE ccb_file.ccb22,
            ccb22g    LIKE ccb_file.ccb22,
            ccb22h    LIKE ccb_file.ccb22
            END RECORD            
   #FUN-D10022--add--end--             
   #FUN-C80092--add--str--
   DEFINE   g_ccb_excel  DYNAMIC ARRAY OF RECORD
            ima08     LIKE ima_file.ima08,
            ima12     LIKE ima_file.ima12,
            ima01     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            ima57     LIKE ima_file.ima57,   #FUN-D10022
            ccb22a    LIKE ccb_file.ccb22,
            ccb22b    LIKE ccb_file.ccb22,
            ccb22d    LIKE ccb_file.ccb22,
            ccb22c    LIKE ccb_file.ccb22,
            ccb22e    LIKE ccb_file.ccb22,
            ccb22f    LIKE ccb_file.ccb22,
            ccb22g    LIKE ccb_file.ccb22,
            ccb22h    LIKE ccb_file.ccb22
            END RECORD
   #FUN-C80092--add--end--
   DEFINE   g_pr    RECORD
            ima08     LIKE ima_file.ima08,
            ima12     LIKE ima_file.ima12,
            ima01     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            ima57     LIKE ima_file.ima57,   #FUN-D10022
            ccb22a    LIKE ccb_file.ccb22,
            ccb22b    LIKE ccb_file.ccb22,
            ccb22d    LIKE ccb_file.ccb22,
            ccb22c    LIKE ccb_file.ccb22,
            ccb22e    LIKE ccb_file.ccb22,
            ccb22f    LIKE ccb_file.ccb22,
            ccb22g    LIKE ccb_file.ccb22,
            ccb22h    LIKE ccb_file.ccb22
            END RECORD
   DEFINE   g_cka00   LIKE cka_file.cka00   #FUN-C80092 
   DEFINE   g_argv8   LIKE type_file.dat    #No.FUN-C80092
   DEFINE   g_argv9   LIKE type_file.dat    #No.FUN-C80092
   DEFINE   g_argv12  LIKE type_file.chr1   #No.FUN-C80092
   DEFINE   w    ui.Window    #FUN-D10022   
   DEFINE   f    ui.Form      #FUN-D10022 
   DEFINE   page om.DomNode   #FUN-D10022

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET tm.a     = 'N'
   LET tm.g     = '1'
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.sy    = ARG_VAL(8)
   LET tm.sm    = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   LET tm.g     = ARG_VAL(11)
   LET tm.type  = ARG_VAL(12) 
   LET tm.auto_gen = ARG_VAL(13)
   LET g_rep_user  = ARG_VAL(14)
   LET g_rep_clas  = ARG_VAL(15)
   LET g_template  = ARG_VAL(16)
   LET g_rpt_name  = ARG_VAL(17)  
   LET g_argv8  = tm.sy    #No.FUN-C80092 add
   LET g_argv9  = tm.sm    #No.FUN-C80092 add
   LET g_argv12 = tm.type  #No.FUN-C80092 add
   CALL q002_out_1()
   #FUN-C80092 mark 
   #OPEN WINDOW q002_w AT 5,10
   #     WITH FORM "axc/42f/axcq002_1" ATTRIBUTE(STYLE = g_win_style)
   #CALL cl_ui_init()
   #FUN-C80092 mark

   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      #FUN-C80092--add--str--
      #OPEN WINDOW q002_w AT 5,10                                        #FUN-D10022 
      #     WITH FORM "axc/42f/axcq002_1" ATTRIBUTE(STYLE = g_win_style) #FUN-D10022
      OPEN WINDOW q002_w AT 5,10                                         #FUN-D10022  
           WITH FORM "axc/42f/axcq002" ATTRIBUTE(STYLE = g_win_style)    #FUN-D10022
      CALL cl_ui_init()
      #FUN-C80092--add--end--
      # Prog. Version..: '5.30.06-13.03.12(0,0)    #FUN-D10022 mark
      #FUN-C80092--add--str--
      CALL cl_set_act_visible("revert_filter",FALSE)  #FUN-D10022
      CALL q002_q()     #FUN-D10022 add
      CALL q002_menu()
      #DROP TABLE axcq002_tmp;
      DROP TABLE q002_tmp;        #FUN-D10022
      CLOSE WINDOW q002_w
      #FUN-C80092--add--end--
   ELSE 
      #CALL axcq002()
      CALL q002()          #FUN-D10022
   END IF
   #FUN-C80092 mark 
   #CALL q002_menu()
   #DROP TABLE axcq002_tmp;
   #CLOSE WINDOW q002_w
   #FUN-C80092 mark
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q002_menu()
DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      #CALL q002_bp("G")     #FUN-D10022
      #FUN-D10022--add--str--
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q002_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q002_bp2()
         END IF
      END IF  
      #FUN-D10022--add--end--      
      CASE g_action_choice
         #FUN-D10022--add--str--
         WHEN "page1"
            CALL q002_bp("G")
         WHEN "page2"
            CALL q002_bp2()   
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q002_filter_askkey()
               CALL q002()        #重填充新臨時表
               CALL q002_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q002()        #重填充新臨時表
               CALL q002_show() 
            END IF             
            LET g_action_choice = " " 
         #FUN-D10022--add--end--   
         WHEN "query"
            IF cl_chk_act_auth() THEN
               # Prog. Version..: '5.30.06-13.03.12(0,0)  #FUN-D10022
               CALL q002_q()    #FUN-D10022
            END IF
            LET g_action_choice = " "   #FUN-D10022
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q002_out_2()
            END IF
            LET g_action_choice = " "   #FUN-D10022
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "   #FUN-D10022
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "   #FUN-D10022
         WHEN "exporttoexcel"
            #FUN-D10022--mod--str--
            #IF cl_chk_act_auth() THEN
            #   CALL cl_export_to_excel
            #   (ui.Interface.getRootNode(),base.TypeInfo.create(g_ccb_excel),'','')  #FUN-C80092
            #END IF
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_action_flag 
                  WHEN 'page1'
                     LET page = f.FindNode("Page","page1")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_ccb_excel),'','')
                  WHEN 'page2'
                     LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_ccb_1_excel),'','')
               END CASE
            END IF 
            #FUN-D10022--mod--end--
            LET g_action_choice = " "   #FUN-D10022
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
            LET g_action_choice = " "   #FUN-D10022
      END CASE
   END WHILE
END FUNCTION

#FUN-D10022--mark--str-- 
#FUNCTION axcq002_tm(p_row,p_col)
#   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01   
#   DEFINE p_row,p_col  LIKE type_file.num5,          
#          l_flag       LIKE type_file.chr1,         
#          l_sy,l_sm    LIKE type_file.num5,          
#          l_ey,l_em    LIKE type_file.num5,         
#          l_cmd        LIKE type_file.chr1000   
#          
#   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
#   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#      LET p_row = 3 
#      LET p_col = 20
#   ELSE 
#      LET p_row = 4 
#      LET p_col = 15
#   END IF
#   OPEN WINDOW axcq002_1 AT p_row,p_col WITH FORM "axc/42f/axcq002" 
#        ATTRIBUTE (STYLE = g_win_style)
#    
#   CALL cl_ui_init()
# 
#   CALL cl_opmsg('p')
#   INITIALIZE tm.* TO NULL 
#   LET tm.a   = 'N'
#   LET tm.g   = '1'
#   LET tm.type = g_ccz.ccz28    
#   LET g_pdate= g_today
#   LET g_rlang= g_lang
#   LET g_bgjob= 'N'
#   LET g_copies= '1'
#   LET tm.auto_gen = 'Y'
#   LET tm.sy = g_ccz.ccz01
#   LET tm.sm = g_ccz.ccz02
# 
#   WHILE TRUE
#      CONSTRUCT BY NAME tm.wc ON ima12,ima01,ima57,ima08
#         BEFORE CONSTRUCT
#            CALL cl_qbe_init()
#            #FUN-C80092--add--by--free--
#            IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) AND NOT cl_null(g_argv12) THEN 
#               LET tm.wc = ' 1=1'
#               EXIT CONSTRUCT 
#            END IF 
#            #FUN-C80092--add--by--free--
# 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#         ON ACTION about 
#            CALL cl_about()    
# 
#         ON ACTION help          
#            CALL cl_show_help()  
# 
#         ON ACTION controlg     
#            CALL cl_cmdask()    
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#   
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
# 
#      END CONSTRUCT
#      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 
#         CLOSE WINDOW axcq002_1 
#         EXIT WHILE
#      END IF
#      IF tm.wc = ' 1=1' AND cl_null(g_argv8) THEN  #FUN-C80092 add g_argv8
#         CALL cl_err('','9046',0) CONTINUE WHILE 
#      END IF
#      INPUT BY NAME tm.sy,tm.sm,tm.type,
#                    tm.a,tm.auto_gen,tm.g
#         WITHOUT DEFAULTS 
#      
#         BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#            #FUN-C80092--add--by--free--
#            IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) AND NOT cl_null(g_argv12) THEN 
#               LET tm.sy   = g_argv8
#               LET tm.sm   = g_argv9
#               LET tm.type = g_argv12
#               DISPLAY BY NAME tm.*
#               CALL cl_set_comp_entry('sy,sm,type',FALSE)
#            ELSE 
#               CALL cl_set_comp_entry('sy,sm,type',TRUE)
#            END IF 
#            #FUN-C80092--add--by--free--
#            CALL cl_set_comp_entry('auto_gen',TRUE)
#
#         AFTER FIELD sy
#            IF tm.sy<1949 OR tm.sy>2050 THEN 
#               NEXT FIELD sy 
#            END IF
#            IF tm.sy <> g_ccz.ccz01 OR tm.sm <> g_ccz.ccz02 THEN
#               CALL cl_set_comp_entry('auto_gen',FALSE)
#               LET tm.auto_gen = 'N'
#               DISPLAY BY NAME tm.auto_gen
#            ELSE
#               CALL cl_set_comp_entry('auto_gen',TRUE)
#               #LET tm.auto_gen = 'N'  #FUN-C80092 mark by free
#               DISPLAY BY NAME tm.auto_gen
#            END IF
#           
#         AFTER FIELD sm
#            IF tm.sm<1 OR tm.sm>12 THEN 
#               NEXT FIELD sm 
#            END IF
#            IF tm.sy <> g_ccz.ccz01 OR tm.sm <> g_ccz.ccz02 THEN
#               CALL cl_set_comp_entry('auto_gen',FALSE)
#               LET tm.auto_gen = 'N'
#               DISPLAY BY NAME tm.auto_gen
#            ELSE
#               CALL cl_set_comp_entry('auto_gen',TRUE)
#               #LET tm.auto_gen = 'N'  #FUN-C80092 mark by free
#               DISPLAY BY NAME tm.auto_gen
#            END IF
#           
#         AFTER FIELD type                                              
#         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
#        
#         AFTER INPUT
#        
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
#         
#         ON ACTION CONTROLG 
#            CALL cl_cmdask()
#         
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#         ON ACTION about     
#            CALL cl_about()     
#    
#         ON ACTION help         
#            CALL cl_show_help()  
#   
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
#       
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#   
#      END INPUT
#   
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 CLOSE WINDOW axcq002_1
#         EXIT WHILE
#      END IF
#      IF g_bgjob = 'Y' THEN
#         SELECT zz08 INTO l_cmd FROM zz_file
#          WHERE zz01='axcq002'
#         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
#             CALL cl_err('axcq002','9031',1)   
#         ELSE
#            LET l_cmd = l_cmd CLIPPED,
#                         " '",g_pdate CLIPPED,"'",
#                         " '",g_towhom CLIPPED,"'",
#                         " '",g_rlang CLIPPED,"'", 
#                         " '",g_bgjob CLIPPED,"'",
#                         " '",g_prtway CLIPPED,"'",
#                         " '",g_copies CLIPPED,"'",
#                         " '",tm.wc CLIPPED,"'",
#                         " '",tm.sy CLIPPED,"'",
#                         " '",tm.sm CLIPPED,"'",
#                         " '",tm.type CLIPPED,"'" ,          
#                         " '",tm.a CLIPPED,"'",
#                         " '",tm.auto_gen CLIPPED,"'",
#                         " '",tm.g CLIPPED,"'",
#                         " '",g_rep_user CLIPPED,"'",
#                         " '",g_rep_clas CLIPPED,"'",
#                         " '",g_template CLIPPED,"'"
#    
#            CALL cl_cmdat('axcq002',g_time,l_cmd)
#         END IF
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#         EXIT PROGRAM
#      END IF
#      CLOSE WINDOW axcq002_1
#      #CALL cl_wait()
#      #CALL axcq002()
#      CALL q002()   #FUN-D10022
#      ERROR ""
#      EXIT WHILE
#   END WHILE
#   CLOSE WINDOW axcq002_w
#   CLEAR FORM
#   CALL g_ccb.clear()
#   CALL g_ccb_excel.clear()
#   CALL axcq002_show()
#
#END FUNCTION
#FUN-D10022--mark--end--
#FUN-D10022--add--str--
FUNCTION q002_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL cl_set_comp_visible("page2", FALSE)
    CALL ui.interface.refresh()
    CALL cl_set_comp_visible("page2", TRUE)
    CALL q002_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q002_show()
END FUNCTION 

FUNCTION q002_cs()
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01   
   DEFINE l_flag       LIKE type_file.chr1,         
          l_sy,l_sm    LIKE type_file.num5,          
          l_ey,l_em    LIKE type_file.num5,         
          l_cmd        LIKE type_file.chr1000   

   CLEAR FORM
   CALL cl_opmsg('p')
   LET tm_t.* = tm.* 
   INITIALIZE tm.* TO NULL 
   LET tm.g = '1'
   LET tm.b = '1'
   CALL q002_set_visible()
   LET tm.type = g_ccz.ccz28    
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.auto_gen = 'Y'
   LET tm.sy = g_ccz.ccz01
   LET tm.sm = g_ccz.ccz02
   
   DIALOG ATTRIBUTE(UNBUFFERED) 
      INPUT BY NAME tm.sy,tm.sm,tm.type,
                    tm.auto_gen,tm.b,tm.g ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) AND NOT cl_null(g_argv12) THEN 
               LET tm.sy   = g_argv8
               LET tm.sm   = g_argv9
               LET tm.type = g_argv12
               DISPLAY BY NAME tm.*
               CALL cl_set_comp_entry('sy,sm,type',FALSE)
            ELSE 
               CALL cl_set_comp_entry('sy,sm,type',TRUE)
            END IF 
            CALL cl_set_comp_entry('auto_gen',TRUE)

         AFTER FIELD sy
            IF tm.sy<1949 OR tm.sy>2050 THEN 
               NEXT FIELD sy 
            END IF
            IF tm.sy <> g_ccz.ccz01 OR tm.sm <> g_ccz.ccz02 THEN
               CALL cl_set_comp_entry('auto_gen',FALSE)
               LET tm.auto_gen = 'N'
               DISPLAY BY NAME tm.auto_gen
            ELSE
               CALL cl_set_comp_entry('auto_gen',TRUE)
               DISPLAY BY NAME tm.auto_gen
            END IF
           
         AFTER FIELD sm
            IF tm.sm<1 OR tm.sm>12 THEN 
               NEXT FIELD sm 
            END IF
            IF tm.sy <> g_ccz.ccz01 OR tm.sm <> g_ccz.ccz02 THEN
               CALL cl_set_comp_entry('auto_gen',FALSE)
               LET tm.auto_gen = 'N'
               DISPLAY BY NAME tm.auto_gen
            ELSE
               CALL cl_set_comp_entry('auto_gen',TRUE)
               DISPLAY BY NAME tm.auto_gen
            END IF
           
         AFTER FIELD TYPE                                              
            IF tm.type NOT MATCHES '[12345]' THEN 
               NEXT FIELD TYPE 
            END IF
            
      END INPUT 
      
      CONSTRUCT BY NAME tm.wc ON ima08,ima12,ima01,ima57 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT
      ON ACTION controlp                                                      
      CASE
         WHEN INFIELD(ima08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima7"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima08
            NEXT FIELD ima08
         WHEN INFIELD(ima12)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima12_1"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima12
            NEXT FIELD ima12
         WHEN INFIELD(ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima110"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01 
            NEXT FIELD ima01
         WHEN INFIELD(ima57)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima10"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima57
            NEXT FIELD ima57
      END CASE 
        
    # ON ACTION CONTROLR
    #    CALL cl_show_req_fields()
       
    # ON ACTION CONTROLG 
    #    CALL cl_cmdask()
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about     
         CALL cl_about()     
    
      ON ACTION help         
         CALL cl_show_help()
         
      ON ACTION ACCEPT
         ACCEPT DIALOG 

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG    
     
    # ON ACTION qbe_save
    #     CALL cl_qbe_save()
   
   END DIALOG
   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')  
   IF INT_FLAG THEN
      LET tm.* = tm_t.*
      LET INT_FLAG = 0 
      CALL g_ccb.clear()
      CALL g_ccb_1.clear()   
   END IF      

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
       WHERE zz01='axcq002'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axcq002','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                    " '",g_pdate CLIPPED,"'",
                    " '",g_towhom CLIPPED,"'",
                    " '",g_rlang CLIPPED,"'", 
                    " '",g_bgjob CLIPPED,"'",
                    " '",g_prtway CLIPPED,"'",
                    " '",g_copies CLIPPED,"'",
                    " '",tm.wc CLIPPED,"'",
                    " '",tm.sy CLIPPED,"'",
                    " '",tm.sm CLIPPED,"'",
                    " '",tm.type CLIPPED,"'" ,          
                    " '",tm.auto_gen CLIPPED,"'",
                    " '",tm.g CLIPPED,"'",
                    " '",g_rep_user CLIPPED,"'",
                    " '",g_rep_clas CLIPPED,"'",
                    " '",g_template CLIPPED,"'"
         CALL cl_cmdat('axcq002',g_time,l_cmd)
      END IF
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL q002()
END FUNCTION

FUNCTION q002_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM

   CONSTRUCT l_wc ON ima08,ima12,ima01,ima57
                FROM s_ccb[1].ima08,s_ccb[1].ima12,
                     s_ccb[1].ima01,s_ccb[1].ima57
      BEFORE CONSTRUCT
         DISPLAY tm.sy TO sy
         DISPLAY tm.sm TO sm
         DISPLAY tm.type TO TYPE
         DISPLAY tm.b TO b
         DISPLAY tm.g TO g
         DISPLAY tm.auto_gen TO auto_gen
         CALL cl_qbe_init()

     ON ACTION controlp                                                      
        CASE
           WHEN INFIELD(ima08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima7"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima08
              NEXT FIELD ima08
           WHEN INFIELD(ima12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima12_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima12
              NEXT FIELD ima12
           WHEN INFIELD(ima01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima110"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima01 
              NEXT FIELD ima01
           WHEN INFIELD(ima57)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima10"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima57
              NEXT FIELD ima57
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
    	 CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT
   
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF 
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF 
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION
#FUN-D10022--add--end--

#FUNCTION axcq002()  #FUN-D10022 mark
FUNCTION q002()      #FUN-D10022 add
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20),
          l_sql     LIKE type_file.chr1000,        #No.FUN-680122CHAR(800),
          l_chr     LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_pmm22   LIKE pmm_file.pmm22,
          l_pmm42   LIKE pmm_file.pmm42,
          l_i       LIKE type_file.num5,
          sr RECORD
             ima08  LIKE ima_file.ima08,
             ima12  LIKE ima_file.ima12,
             ima01  LIKE ima_file.ima01,
             ima02  LIKE ima_file.ima02,
             ima021 LIKE ima_file.ima021,
             ccb22a LIKE ccb_file.ccb22a,
             ccb22b LIKE ccb_file.ccb22b,
             ccb22d LIKE ccb_file.ccb22d,
             ccb22c LIKE ccb_file.ccb22c,
             ccb22e LIKE ccb_file.ccb22e,
             ccb22f LIKE ccb_file.ccb22f,        
             ccb22g LIKE ccb_file.ccb22g,        
             ccb22h LIKE ccb_file.ccb22h
             END RECORD,
          l_n       LIKE type_file.num5,          
          l_rvu08   LIKE rvu_file.rvu08
   DEFINE l_msg     STRING        #FUN-C80092

#FUN-C80092 -----------Begin-------------                     
   LET l_msg = "tm.sy = '",tm.sy,"'",";","tm.sm = '",tm.sm,"'",";","tm.type = '",tm.type,"'",";",
               "tm.a = '",tm.a,"'",";","tm.auto_gen = '",tm.auto_gen,"'",";","tm.g = '",tm.g,"'"
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00
#FUN-C80092 -----------End--------------

   #CALL axcq002_table()
   CALL q002_table()   #FUN-D10022
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF  #FUN-D10022 #TQC-D50098 
   #LET l_sql = "SELECT ima08,ima12,ima01,ima02,ima021,ima57,",   #FUN-D10022 ima57    #TQC-D20052
   LET l_sql = "SELECT NVL(trim(ima08),''),NVL(trim(ima12),''),NVL(trim(ima01),''),ima02,ima021,NVL(trim(ima57),''),",   #FUN-D10022 ima57 #TQC-D20052 
               "       SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),",
               "       SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h)",
               "  FROM ima_file,ccb_file",
               " WHERE ima01 = ccb01",
#               "   AND ima12 IS NOT NULL ",    mark by liuyya170922
               "   AND ccb06 = '",tm.type,"'",               
               "   AND ccb02*12+ccb03 = ",tm.sy,"*12+",tm.sm," ",
               "   AND ",tm.wc CLIPPED," AND ",g_filter_wc CLIPPED,  #FUN-D10022 add g_filter_wc
               " GROUP BY ima08,ima12,ima01,ima02,ima021,ima57"
   LET l_sql = " INSERT INTO q002_tmp  ",l_sql CLIPPED     #FUN-D10022         
   PREPARE q002_ins FROM l_sql         #FUN-D10022
   EXECUTE q002_ins                    #FUN-D10022
   #FUN-D10022--mark--str--
   #PREPARE axcq002_prepare1 FROM l_sql
   #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
   #   CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
   #   EXIT PROGRAM 
   #END IF
   #DECLARE axcq002_curs1 CURSOR FOR axcq002_prepare1
   #CALL cl_del_data(l_table) 
   #LET l_i=1   
   #FOREACH axcq002_curs1 INTO sr.*
   #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
   #     EXIT FOREACH
   # END IF
   # INSERT INTO axcq002_tmp VALUES (sr.ima08, sr.ima12,sr.ima01,sr.ima02,sr.ima021,
   #                                 sr.ccb22a,sr.ccb22b,sr.ccb22d,sr.ccb22c,
   #                                 sr.ccb22e,sr.ccb22f,sr.ccb22g,sr.ccb22h)
   # LET l_i = l_i + 1
   #END FOREACH
   #FUN-D10022-mark--end--
   CALL q002_b_fill()                      #wujie 130628 为更新勾稽表
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
END FUNCTION

#FUNCTION axcq002_table()   #FUN-D10022 mark
FUNCTION q002_table()       #FUN-D10022 add
     #DROP TABLE axcq002_tmp; #FUN-D10022
     #CREATE TEMP TABLE  axcq002_tmp(  #FUN-D10022
     DROP TABLE q002_tmp;              #FUN-D10022
     CREATE TEMP TABLE q002_tmp(
                     ima08  LIKE ima_file.ima08,
                     ima12  LIKE ima_file.ima12,
                     ima01  LIKE ima_file.ima01,
                     ima02  LIKE ima_file.ima02,
                     ima021 LIKE ima_file.ima021,
                     ima57  LIKE ima_file.ima57,             
                     ccb22a LIKE ccb_file.ccb22a,
                     ccb22b LIKE ccb_file.ccb22b,
                     ccb22d LIKE ccb_file.ccb22d,
                     ccb22c LIKE ccb_file.ccb22c,
                     ccb22e LIKE ccb_file.ccb22e,
                     ccb22f LIKE ccb_file.ccb22f,        
                     ccb22g LIKE ccb_file.ccb22g,        
            	     ccb22h LIKE ccb_file.ccb22h);   #FUn-D10022 add ima57

END FUNCTION

FUNCTION q002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

#FUN-D10022--add--str--
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_flag = 'page1'
   IF g_action_choice = "page1"  AND g_flag != '1' THEN
      CALL q002_b_fill()
   END IF
   LET g_action_choice = " "
   LET g_flag = ' '   
   DISPLAY g_rec_b TO FORMONLY.cnt
   DISPLAY g_sum1 TO FORMONLY.sum1
   DISPLAY g_sum2 TO FORMONLY.sum2
   DISPLAY g_sum3 TO FORMONLY.sum3
   DISPLAY g_sum4 TO FORMONLY.sum4
   DISPLAY g_sum5 TO FORMONLY.sum5
   DISPLAY g_sum6 TO FORMONLY.sum6
   DISPLAY g_sum7 TO FORMONLY.sum7
   DISPLAY g_sum8 TO FORMONLY.sum8
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ccb TO s_ccb.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY    
      INPUT tm.b FROM b ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE b
            IF NOT cl_null(tm.b)  THEN 
               CALL q002_b_fill2()
               CALL q002_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            END IF
            DISPLAY  tm.b TO b
            EXIT DIALOG
      END INPUT    
 
      ON ACTION page2
         LET g_action_choice="page2"
         EXIT DIALOG 
         
      ON ACTION refresh_detail
         CALL q002_b_fill()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG   
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
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
 
      AFTER DIALOG
         CONTINUE DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")  
   END DIALOG   
   CALL cl_set_act_visible("accept,cancel", TRUE)
#FUN-D10022--add--end--
#FUN-D10022--mark--str--
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
#
#   LET g_action_choice = " "
#
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_ccb TO s_ccb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#         IF g_rec_b != 0 AND l_ac != 0 THEN
#            CALL fgl_set_arr_curr(l_ac)
#         END IF
#
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
# 
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about
#         CALL cl_about()
# 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON ACTION related_document
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      ON ACTION controls
#         CALL cl_set_head_visible("","AUTO")
# 
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#FUN-D10022--mark--end--    
END FUNCTION

#FUN-D10022--add--str--
FUNCTION q002_bp2()

   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL q002_b_fill2()  #FUN-D10022
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b2 TO FORMONLY.cnt
   DISPLAY g_sum1 TO FORMONLY.sum1
   DISPLAY g_sum2 TO FORMONLY.sum2
   DISPLAY g_sum3 TO FORMONLY.sum3
   DISPLAY g_sum4 TO FORMONLY.sum4
   DISPLAY g_sum5 TO FORMONLY.sum5
   DISPLAY g_sum6 TO FORMONLY.sum6
   DISPLAY g_sum7 TO FORMONLY.sum7
   DISPLAY g_sum8 TO FORMONLY.sum8
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY g_ccb_1 TO s_ccb_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY    
      INPUT tm.b FROM b ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE b
            IF NOT cl_null(tm.b)  THEN 
               CALL q002_b_fill2()
               CALL q002_set_visible()
               LET g_action_choice = "page2"
            END IF
            DISPLAY  tm.b TO b
            EXIT DIALOG
      END INPUT  
 

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG 
 
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q002_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   
      ON ACTION refresh_detail
         CALL q002_b_fill()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
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
 
      AFTER DIALOG
         CONTINUE DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")  
   END DIALOG   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-D10022--add--end--

#FUNCTION axcq002_show()  #FUN-D10022 mark
FUNCTION q002_show()   #FUN-D10022
   #CALL axcq002_b_fill()  #FUN-D10022
   CALL q002_b_fill()   #FUN-D10022
   DISPLAY g_rec_b TO FORMONLY.cnt
   DISPLAY g_sum1 TO FORMONLY.sum1
   DISPLAY g_sum2 TO FORMONLY.sum2
   DISPLAY g_sum3 TO FORMONLY.sum3
   DISPLAY g_sum4 TO FORMONLY.sum4
   DISPLAY g_sum5 TO FORMONLY.sum5
   DISPLAY g_sum6 TO FORMONLY.sum6
   DISPLAY g_sum7 TO FORMONLY.sum7
   DISPLAY g_sum8 TO FORMONLY.sum8
   #FUN-D10022--add--str--
   IF cl_null(g_action_flag) OR g_action_flag ="page2" THEN 
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
   ELSE
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
   END IF 
   #FUN-D10022--add--end--  
   CALL cl_show_fld_cont()
END FUNCTION
 
#FUNCTION axcq002_b_fill()  #FUN-D10022 mark
FUNCTION q002_b_fill()      #FUN-D10022
DEFINE l_ckk RECORD LIKE ckk_file.*          

   LET g_sum  = 0 
   LET g_sum1 = 0 
   LET g_sum2 = 0 
   LET g_sum3 = 0 
   LET g_sum4 = 0 
   LET g_sum5 = 0 
   LET g_sum6 = 0 
   LET g_sum7 = 0 
   LET g_sum8 = 0 

   #FUN-D10022--mark--str-- 
   #IF cl_null(tm.a) OR tm.a = 'N' THEN
   #   LET g_sql = "SELECT  '',ima12,'','','',SUM(ccb22a),",
   #               "SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),SUM(ccb22e), SUM(ccb22f), SUM(ccb22g), SUM(ccb22h) ",
   #               #" FROM axcq002_tmp  ",  #FUN-D10022
   #               " FROM q002_tmp  ",  #FUN-D10022
   #               " GROUP BY ima12 "
   #ELSE
   #FUN-D10022--mark--end--
   IF tm.g = '2' THEN      #列印料号前3码
      LET g_sql = "SELECT  ima08,ima12,substr(ima01,1,3),ima02,ima021,ima57,ccb22a,"
   ELSE
      LET g_sql = "SELECT  ima08,ima12,ima01,ima02,ima021,ima57,ccb22a,"
   END IF
   LET g_sql = g_sql, "ccb22b,ccb22d,ccb22c,ccb22e, ccb22f, ccb22g, ccb22h ",
                      #" FROM axcq002_tmp  "  #FUN-D10022
                      " FROM q002_tmp  "  #FUN-D10022
   #END IF   #FUN-D10022 mark

   PREPARE axcq002_pb FROM g_sql
   DECLARE axcq002_curs  CURSOR FOR axcq002_pb
 
   CALL g_ccb.clear()
   CALL g_ccb_excel.clear()  #FUN-C80092 add
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH axcq002_curs INTO g_ccb_excel[g_cnt].*  #FUN-C80092
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      #FUN-C80092--modofy--str--  #g_ccb->g_ccb_excel
      LET g_sum1 = g_sum1+g_ccb_excel[g_cnt].ccb22a
      LET g_sum2 = g_sum2+g_ccb_excel[g_cnt].ccb22b
      LET g_sum3 = g_sum3+g_ccb_excel[g_cnt].ccb22d
      LET g_sum4 = g_sum4+g_ccb_excel[g_cnt].ccb22c
      LET g_sum5 = g_sum5+g_ccb_excel[g_cnt].ccb22e
      LET g_sum6 = g_sum6+g_ccb_excel[g_cnt].ccb22f
      LET g_sum7 = g_sum7+g_ccb_excel[g_cnt].ccb22g
      LET g_sum8 = g_sum8+g_ccb_excel[g_cnt].ccb22h
      LET g_sum = g_sum1 + g_sum2 + g_sum3 + g_sum4 + g_sum5 + g_sum6 + g_sum7 + g_sum8
      #FUN-C80092--modofy--end--
       

      #FUN-C80092--add--str--
      IF g_cnt <= g_max_rec THEN 
         LET g_ccb[g_cnt].* =  g_ccb_excel[g_cnt].*
      END IF 
      #FUN-C80092--add--end--
      LET g_cnt = g_cnt + 1
      #FUN-C80092--mark--str--
      #IF g_cnt > g_max_rec THEN
      #   CALL cl_err( '', 9035, 0 )
      #   EXIT FOREACH
      #END IF
      #FUN-C80092--mark--end--
   END FOREACH
   
   #CALL g_ccb.deleteElement(g_cnt)  #FUN-C80092 mark  
   #FUN-C80092--add--str--
   IF g_cnt <= g_max_rec THEN 
      CALL g_ccb.deleteElement(g_cnt) 
   END IF 
   CALL g_ccb_excel.deleteElement(g_cnt) 
   #FUN-C80092--add--str--
   LET g_cnt=g_cnt-1
   LET g_rec_b = g_cnt
   #FUN-C80092--add--str--
   #IF g_rec_b > g_max_rec THEN  #FUN-C80092
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   #FUN-C80092--add--end--

   #FUN-C80092--add--str--
   IF NOT cl_null(tm.auto_gen) AND tm.auto_gen = 'Y' THEN
      CALL s_ckk_fill('','308','axc-439',tm.sy,tm.sm,'axcq002',tm.type,0,g_sum,g_sum1,
                      g_sum2,g_sum3,g_sum4,g_sum5,g_sum6,g_sum7,g_sum8,tm.wc,g_user,g_today,TIME,'Y')
         RETURNING l_ckk.*
      IF NOT s_ckk(l_ckk.*,'') THEN  END IF
   END IF 
   #FUN-C80092--add--end--
END FUNCTION

#FUN-D10022--add--str--
FUNCTION q002_b_fill2()
DEFINE l_ckk RECORD LIKE ckk_file.*          

   LET g_sum  = 0 
   LET g_sum1 = 0 
   LET g_sum2 = 0 
   LET g_sum3 = 0 
   LET g_sum4 = 0 
   LET g_sum5 = 0 
   LET g_sum6 = 0 
   LET g_sum7 = 0 
   LET g_sum8 = 0 

   CASE tm.b
      WHEN '1'
         IF tm.g = '2' THEN      #列印料号前3码
            LET g_sql = " SELECT  '','',substr(ima01,1,3) a,ima02,ima021,'', ",
                        " SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),SUM(ccb22e), SUM(ccb22f), SUM(ccb22g), SUM(ccb22h) ",
                        " FROM q002_tmp  ",
                        " GROUP BY a,ima02,ima021 "   
         ELSE
            LET g_sql = " SELECT  '','',ima01,ima02,ima021,'', ",
                        " SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),SUM(ccb22e), SUM(ccb22f), SUM(ccb22g), SUM(ccb22h) ",
                        " FROM q002_tmp  ",
                        " GROUP BY ima01,ima02,ima021 "  
         END IF
      WHEN '2'
         LET g_sql = " SELECT  ima08,'','','','','', ",
                     " SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),SUM(ccb22e), SUM(ccb22f), SUM(ccb22g), SUM(ccb22h) ",
                     " FROM q002_tmp  ",
                     " GROUP BY ima08 "        
      WHEN '3'
         LET g_sql = " SELECT  '',ima12,'','','','', ",
                     " SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),SUM(ccb22e), SUM(ccb22f), SUM(ccb22g), SUM(ccb22h) ",
                     " FROM q002_tmp  ",
                     " GROUP BY ima12 "        
      WHEN '4'
         LET g_sql = " SELECT  '','','','','',ima57, ",
                     " SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),SUM(ccb22c),SUM(ccb22e), SUM(ccb22f), SUM(ccb22g), SUM(ccb22h) ",
                     " FROM q002_tmp  ",
                     " GROUP BY ima57 "        
   END CASE
   PREPARE q002_pb_2 FROM g_sql
   DECLARE q002_curs_2  CURSOR FOR q002_pb_2
 
   CALL g_ccb_1.clear()
   CALL g_ccb_1_excel.clear()  
   LET g_cnt = 1
   LET g_rec_b2 = 0
 
   FOREACH q002_curs_2 INTO g_ccb_1_excel[g_cnt].*  
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_sum1 = g_sum1+g_ccb_1_excel[g_cnt].ccb22a
      LET g_sum2 = g_sum2+g_ccb_1_excel[g_cnt].ccb22b
      LET g_sum3 = g_sum3+g_ccb_1_excel[g_cnt].ccb22d
      LET g_sum4 = g_sum4+g_ccb_1_excel[g_cnt].ccb22c
      LET g_sum5 = g_sum5+g_ccb_1_excel[g_cnt].ccb22e
      LET g_sum6 = g_sum6+g_ccb_1_excel[g_cnt].ccb22f
      LET g_sum7 = g_sum7+g_ccb_1_excel[g_cnt].ccb22g
      LET g_sum8 = g_sum8+g_ccb_1_excel[g_cnt].ccb22h
      LET g_sum = g_sum1 + g_sum2 + g_sum3 + g_sum4 + g_sum5 + g_sum6 + g_sum7 + g_sum8
 
      IF g_cnt <= g_max_rec THEN 
         LET g_ccb_1[g_cnt].* =  g_ccb_1_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1
   END FOREACH
 
   IF g_cnt <= g_max_rec THEN 
      CALL g_ccb_1.deleteElement(g_cnt) 
   END IF 
   CALL g_ccb_1_excel.deleteElement(g_cnt) 
 
   LET g_cnt=g_cnt-1
   LET g_rec_b2 = g_cnt
 
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b2||"|"||g_max_rec,10)
      LET g_rec_b2 = g_max_rec
   END IF
END FUNCTION

FUNCTION q002_detail_fill(p_ac)
DEFINE l_tmp      STRING,
       l_sql      STRING,
       p_ac       LIKE type_file.num5 

   LET g_sum  = 0 
   LET g_sum1 = 0 
   LET g_sum2 = 0 
   LET g_sum3 = 0 
   LET g_sum4 = 0 
   LET g_sum5 = 0 
   LET g_sum6 = 0 
   LET g_sum7 = 0 
   LET g_sum8 = 0 

   IF tm.g = '2' THEN      #列印料号前3码
      LET l_sql = "SELECT  ima08,ima12,substr(ima01,1,3),ima02,ima021,ima57,ccb22a,"
   ELSE
      LET l_sql = "SELECT  ima08,ima12,ima01,ima02,ima021,ima57,ccb22a,"
   END IF
   LET l_sql = l_sql, "ccb22b,ccb22d,ccb22c,ccb22e,ccb22f,ccb22g,ccb22h ",
                      " FROM q002_tmp "
   CASE tm.b
      WHEN '1'
         IF cl_null(g_ccb_1[p_ac].ima01) THEN 
            LET g_ccb_1[p_ac].ima01 = ''
            LET l_tmp = " OR ima01 IS NULL " 
         ELSE
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima01 = '",g_ccb_1[p_ac].ima01 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima08,ima12,ima01,ima02,ima021,ima57 "  
      WHEN '2'
         IF cl_null(g_ccb_1[p_ac].ima08) THEN 
            LET g_ccb_1[p_ac].ima08 = ''
            LET l_tmp = " OR ima08 IS NULL " 
         ELSE
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima08 = '",g_ccb_1[p_ac].ima08 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima08,ima12,ima01,ima02,ima021,ima57 "       
      WHEN '3'
         IF cl_null(g_ccb_1[p_ac].ima12) THEN 
            LET g_ccb_1[p_ac].ima12 = ''
            LET l_tmp = " OR ima12 IS NULL "    
         ELSE
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima12 = '",g_ccb_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima08,ima12,ima01,ima02,ima021,ima57 "       
      WHEN '4'
         IF cl_null(g_ccb_1[p_ac].ima57) THEN 
            LET g_ccb_1[p_ac].ima57 = ''
            LET l_tmp = " OR ima57 IS NULL "  
         ELSE
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima57 = '",g_ccb_1[p_ac].ima57 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima08,ima12,ima01,ima02,ima021,ima57 "       
   END CASE

   PREPARE q002_pb1 FROM l_sql
   DECLARE q002_curs1  CURSOR FOR q002_pb1

   CALL g_ccb.clear()
   CALL g_ccb_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH q002_curs1 INTO g_ccb_excel[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_sum1 = g_sum1+g_ccb_excel[g_cnt].ccb22a
      LET g_sum2 = g_sum2+g_ccb_excel[g_cnt].ccb22b
      LET g_sum3 = g_sum3+g_ccb_excel[g_cnt].ccb22d
      LET g_sum4 = g_sum4+g_ccb_excel[g_cnt].ccb22c
      LET g_sum5 = g_sum5+g_ccb_excel[g_cnt].ccb22e
      LET g_sum6 = g_sum6+g_ccb_excel[g_cnt].ccb22f
      LET g_sum7 = g_sum7+g_ccb_excel[g_cnt].ccb22g
      LET g_sum8 = g_sum8+g_ccb_excel[g_cnt].ccb22h
      LET g_sum = g_sum1 + g_sum2 + g_sum3 + g_sum4 + g_sum5 + g_sum6 + g_sum7 + g_sum8

      IF g_cnt <= g_max_rec THEN 
         LET g_ccb[g_cnt].* =  g_ccb_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1

   END FOREACH

   IF g_cnt <= g_max_rec THEN 
      CALL g_ccb.deleteElement(g_cnt) 
   END IF 
   CALL g_ccb_excel.deleteElement(g_cnt) 
   LET g_cnt=g_cnt-1
   LET g_rec_b = g_cnt
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
END FUNCTION
#FUN-D10022--add--end-- 

FUNCTION q002_out_1()
LET g_prog =   'axcq002'
LET g_sql =    " ima08.ima_file.ima08,",                                                                                            
               " ima12.ima_file.ima12,",
               " ima01.ima_file.ima01,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ima57.ima_file.ima57,",      #FUN-D10022 add ima57
               " ccb22a.ccb_file.ccb22a,",
               " ccb22b.ccb_file.ccb22b,",
               " ccb22d.ccb_file.ccb22d,",
               " ccb22c.ccb_file.ccb22c,",
               " ccb22e.ccb_file.ccb22e,",
               " ccb22f.ccb_file.ccb22f,",    #No.FUN-7C0101 add
               " ccb22g.ccb_file.ccb22g,",    #No.FUN-7C0101 add
               " ccb22h.ccb_file.ccb22h "
   LET l_table = cl_prt_temptable('axcq002',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF                                                                                 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"                                          
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM                                                                     
   END IF                                                                            
END FUNCTION
 
FUNCTION q002_out_2()
DEFINE   l_m     LIKE type_file.chr20
DEFINE   l_sql   STRING 

   LET g_prog = 'axcq002'
   CALL cl_del_data(l_table)
   #LET l_sql=" SELECT * FROM axcq002_tmp "  #FUN-D10022
   LET l_sql=" SELECT * FROM q002_tmp "  #FUN-D10022
   PREPARE cr_p FROM l_sql 
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('cr_p',SQLCA.sqlcode,1)
   END IF
   DECLARE cr_curs CURSOR FOR cr_p
   FOREACH cr_curs INTO g_pr.*
   EXECUTE insert_prep USING g_pr.*
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = NULL
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'ima08,ima12,ima01,ima02,ima021,ima57') RETURNING tm.wc    #FUN-D10022 add ima57       
   END IF
   LET g_str = tm.wc,";",tm.a,";",tm.g,";",g_azi03,";",tm.type      
   CALL cl_prt_cs3('axcq002','axcq002',g_sql,g_str)
END FUNCTION

#FUN-D10022--add--str--
FUNCTION q002_set_visible()

   CALL cl_set_comp_visible("ima08_1,ima12_1,ima01_1,ima02_1,ima021_1,ima57_1",FALSE)
   CASE tm.b 
      WHEN "1"
         CALL cl_set_comp_visible("ima01_1,ima02_1,ima021_1",TRUE)
      WHEN "2"
         CALL cl_set_comp_visible("ima08_1",TRUE)
      WHEN "3"
         CALL cl_set_comp_visible("ima12_1",TRUE)
      WHEN "4"
         CALL cl_set_comp_visible("ima57_1",TRUE)
   END CASE
END FUNCTION 
