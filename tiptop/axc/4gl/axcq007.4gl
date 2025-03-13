# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axcq007.4gl
# Descriptions...: 借還料明細表
# Date & Author..: 12/08/27 By xujing  FUN-C80092
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,最大筆數控制與excel導出處理 
# Modify.........: No.FUN-D10079 13/01/16 By xujing 補_tm()ON ACTION

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm,tm_t  RECORD                         # Print condition RECORD
            bdate       LIKE type_file.dat,           #No.FUN-680122SMALLINT,
            edate       LIKE type_file.dat,          #No.FUN-680122SMALLINT,
            a           LIKE type_file.chr1 
           #ctype       LIKE type_file.chr1
           END RECORD
DEFINE g_imp  DYNAMIC ARRAY OF RECORD
            imo01 LIKE imo_file.imo01,
            imp02 LIKE imp_file.imp02,
            imo02 LIKE imo_file.imo02,
            imo03 LIKE imo_file.imo03,
            imp03 LIKE imp_file.imp03,
            ima02 LIKE ima_file.ima02,
           ima021 LIKE ima_file.ima021,
            ima25 LIKE ima_file.ima25,
            imp04 LIKE imp_file.imp04,
            imp09 LIKE imp_file.imp09,
            imp10 LIKE imp_file.imp10
              END RECORD
DEFINE g_imr  DYNAMIC ARRAY OF RECORD 
                imr00 LIKE imr_file.imr00, 
                imr01 LIKE imr_file.imr01,
                imq02 LIKE imq_file.imq02, 
                imr09 LIKE imr_file.imr09,  
                imq03 LIKE imq_file.imq03,  
                imq04 LIKE imq_file.imq04, 
                imq05 LIKE imq_file.imq05, 
                apb27 LIKE ima_file.ima02,           
                bmq021 LIKE ima_file.ima021,         
                chr4 LIKE ima_file.ima25,             
                imq07 LIKE imq_file.imq07,  
                imq11 LIKE imq_file.imq11, 
                imq12 LIKE imq_file.imq12            
                END RECORD
DEFINE g_imp_excel  DYNAMIC ARRAY OF RECORD
            imo01 LIKE imo_file.imo01,
            imp02 LIKE imp_file.imp02,
            imo02 LIKE imo_file.imo02,
            imo03 LIKE imo_file.imo03,
            imp03 LIKE imp_file.imp03,
            ima02 LIKE ima_file.ima02,
           ima021 LIKE ima_file.ima021,
            ima25 LIKE ima_file.ima25,
            imp04 LIKE imp_file.imp04,
            imp09 LIKE imp_file.imp09,
            imp10 LIKE imp_file.imp10
              END RECORD
DEFINE g_imr_excel  DYNAMIC ARRAY OF RECORD 
                imr00 LIKE imr_file.imr00, 
                imr01 LIKE imr_file.imr01,
                imq02 LIKE imq_file.imq02, 
                imr09 LIKE imr_file.imr09,  
                imq03 LIKE imq_file.imq03,  
                imq04 LIKE imq_file.imq04, 
                imq05 LIKE imq_file.imq05, 
                apb27 LIKE ima_file.ima02,           
                bmq021 LIKE ima_file.ima021,         
                chr4 LIKE ima_file.ima25,             
                imq07 LIKE imq_file.imq07,  
                imq11 LIKE imq_file.imq11, 
                imq12 LIKE imq_file.imq12            
                END RECORD
DEFINE g_imo01        LIKE imo_file.imo01
DEFINE g_rec_b_1      LIKE type_file.num10
DEFINE g_rec_b_2      LIKE type_file.num10
DEFINE g_cnt_1        LIKE type_file.num10
DEFINE g_cnt_2        LIKE type_file.num10
DEFINE g_wc           STRING
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE l_ac           LIKE type_file.num5,
           g_qty_1    LIKE imp_file.imp04,
           g_qty_2    LIKE imq_file.imq07,
           g_tot_1    LIKE imp_file.imp10,
           g_tot_2    LIKE imq_file.imq12
DEFINE g_ckk  RECORD  LIKE ckk_file.*
DEFINE g_yy,g_mm      LIKE type_file.num5
DEFINE g_argv1        LIKE type_file.num5,
       g_argv2        LIKE type_file.num5,
       g_argv3        LIKE type_file.chr1,
       g_argv4        LIKE type_file.chr1,
       g_argv5        LIKE type_file.chr1
DEFINE g_cka00        STRING              #FUN-C80092
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
DEFINE  g_action_flag  LIKE type_file.chr100 

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

   LET g_argv1     = ARG_VAL(1)       #年度
   LET g_argv2     = ARG_VAL(2)       #期別
   LET g_argv3     = ARG_VAL(3)       #成本計算類型
   LET g_argv4     = ARG_VAL(4)       #勾稽否
   LET g_argv5     = ARG_VAL(5)       #g_bgjob
  
   LET g_bgjob     = g_argv5
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      OPEN WINDOW q007_w AT 5,10
           WITH FORM "axc/42f/axcq007" ATTRIBUTE(STYLE = g_win_style)
      CALL cl_ui_init()

      CALL axcq007_tm(0,0)
      
      CALL q007_menu()
      
      CLOSE WINDOW q007_w
      
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
   ELSE
      CALL s_ymtodate(g_argv1,g_argv2,g_argv1,g_argv2) RETURNING tm.bdate,tm.edate
      LET tm.a = g_argv4
      CALL axcq007()
   END IF
   
END MAIN 

FUNCTION q007_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
   WHILE TRUE
      CALL q007_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL axcq007_tm(0,0)
            END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL q007_out_2()
#           END IF
#         WHEN "drill_general_ledger"
#            IF cl_chk_act_auth() THEN
#               CALL q007_drill_gl()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_action_flag = "page1" THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imp_excel),'','')
               END IF
               IF g_action_flag = "page2" THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imr_excel),'','')
               END IF
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imp_excel),'','')
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imr_excel),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION axcq007_tm(p_row,p_col)
   DEFINE p_row,p_col       LIKE type_file.num5
   DEFINE lc_qbe_sn         LIKE gbm_file.gbm01 
   DEFINE l_byy,l_eyy,l_bdd LIKE type_file.num5
   DEFINE l_bmm,l_emm,l_edd LIKE type_file.num5
   DEFINE l_flag            LIKE type_file.chr1

   LET p_row = 4 LET p_col =25
   OPEN WINDOW axcq007_w AT p_row,p_col WITH FORM "axc/42f/axcq007_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()    
   CALL cl_ui_locale("axcq007")
   CALL cl_opmsg('p')
   LET tm_t.* = tm.*
   INITIALIZE tm.* TO NULL
   CALL s_ymtodate(g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.bdate,tm.edate   #抓到現價年度期別
   LET tm.a  = 'Y'
   LET g_bgjob = 'N'

   WHILE TRUE
      INPUT BY NAME tm.bdate,tm.edate,tm.a WITHOUT DEFAULTS
         BEFORE INPUT 
            CALL cl_qbe_display_condition(lc_qbe_sn)
            CALL cl_set_comp_entry('a',TRUE)
            #FUN-C80092--add--by--free--
            IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
               CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,tm.bdate,tm.edate
               IF NOT q007_a_check() THEN 
                  LET tm.a = 'N'
               ELSE 
                  LET tm.a = 'Y'
               END IF
               DISPLAY BY NAME tm.*
               CALL cl_set_comp_entry('bdate,edate',FALSE)
            ELSE 
               CALL cl_set_comp_entry('bdate,edate',TRUE)
            END IF 
            #FUN-C80092--add--by--free-
            
         AFTER FIELD bdate
            IF NOT q007_a_check() THEN
               CALL cl_set_comp_entry('a',FALSE)
               LET tm.a = 'N'
               DISPLAY BY NAME tm.a
            ELSE
               CALL cl_set_comp_entry('a',TRUE)
               LET tm.a = 'Y'
               DISPLAY BY NAME tm.a
            END IF 
                    
 
         AFTER FIELD edate
            IF NOT q007_a_check() THEN
               CALL cl_set_comp_entry('a',FALSE)
               LET tm.a = 'N'
               DISPLAY BY NAME tm.a
            ELSE
               CALL cl_set_comp_entry('a',TRUE)
               LET tm.a = 'Y'
               DISPLAY BY NAME tm.a
            END IF
             
         AFTER FIELD a
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.edate < tm.bdate THEN
               CALL cl_err('','agl-031',0)
               NEXT FIELD edate
            END IF
        #FUN-D10079---add---str---
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION about
            CALL cl_about()
   
         ON ACTION help
            CALL cl_show_help()
   
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
   
         ON ACTION qbe_save
            CALL cl_qbe_save()
        #FUN-D10079---add---end---
      END INPUT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF 
      IF INT_FLAG THEN
#No.FUN-A30008 --begin
#        LET INT_FLAG = 0 
         LET tm.* = tm_t.*
#        INITIALIZE tm.* TO NULL 
#        LET g_qty_1 = 0
#        LET g_qty_2 = 0
#        LET g_tot_1 = 0
#        LET g_tot_2 = 0
#        LET g_rec_b_1 = 0
#        LET g_rec_b_2 = 0        
         CLOSE WINDOW axcq007_w
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
         RETURN
#No.FUN-A30008 --end
      END IF
      CALL cl_wait()
      LET g_yy = YEAR(tm.bdate)
      LET g_mm = MONTH(tm.edate)
      CALL axcq007()
      ERROR ""
      EXIT WHILE
   END WHILE
   CLOSE WINDOW axcq007_w
END FUNCTION

FUNCTION q007_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
#  DISPLAY tm.ctype TO ctype

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_imp TO s_imp.* 
         BEFORE DISPLAY
         #CALL cl_navigator_setting( g_curs_index, g_row_count )

         #IF g_rec_b_1 != 0 AND l_ac != 0 THEN
         #   CALL fgl_set_arr_curr(l_ac)
         #END IF
         LET g_action_flag = "page1"
         DISPLAY g_rec_b_1 TO FORMONLY.cn2
         DISPLAY g_qty_1   TO FORMONLY.qty
         DISPLAY g_tot_1   TO FORMONLY.tot
      #BEFORE ROW
      #  LET l_ac = ARR_CURR()
      #  CALL cl_show_fld_cont()
       END DISPLAY

       DISPLAY ARRAY g_imr TO s_imr.*
          BEFORE DISPLAY 
             LET g_action_flag = "page2"
             DISPLAY g_qty_2   TO FORMONLY.qty
             DISPLAY g_tot_2   TO FORMONLY.tot
             DISPLAY g_rec_b_2 TO FORMONLY.cn2
 
       END DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DIALOG
 
#     ON ACTION drill_general_ledger
#        LET g_action_choice="drill_general_ledger"
#        EXIT DIALOG
      #No.FUN-A30008--begin
#     ON ACTION first
#        CALL axcq007_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DIALOG
#
#     ON ACTION previous
#        CALL axcq007_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DIALOG
#
#     ON ACTION jump
#        CALL axcq007_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DIALOG
#
#     ON ACTION next
#        CALL axcq007_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DIALOG

#     ON ACTION last
#        CALL axcq007_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DIALOG
#     #No.FUN-A30008--end    
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
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      AFTER DIALOG
         CONTINUE DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION axcq007()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20),       # External(Disk) file name
          l_name1   LIKE type_file.chr20,          #No.FUN-680122CHAR(20),       # External(Disk) file name
          l_sql     STRING,
          l_cmd     LIKE type_file.chr1000        #No.FUN-680122CHAR(400),
   DEFINE l_str      STRING,                   #FUN-750112
          l_msg      LIKE type_file.chr1000,   #FUN-750112
          l_mm       LIKE type_file.chr2,      #FUN-750112
          l_bdate    LIKE type_file.dat,       #區間的起始日期 	#MOD-A60048 add
          l_edate    LIKE type_file.dat        #區間的截止日期 	#MOD-A60048 add
   DEFINE l_msg1     STRING                    #FUN-C80092  
  

   #FUN-C80092 -------------Begin---------------
   LET l_msg1 = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.a = '",tm.a,"'"
   CALL s_log_ins(g_prog,'','','',l_msg1)
        RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
 
   #借料明細
   LET l_sql = "SELECT imo01,imp02,imo02,imo03,imp03,",
               "       ima02,ima021,ima25,imp04,imp09,imp10",
               "  FROM imo_file,imp_file,ima_file",
               " WHERE imo01=imp01",
               "   AND imp03=ima01",
               "   AND imo02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-A60048
               "   AND imopost='Y'",   #MOD-A60048 add
               "   AND imp11 NOT IN (SELECT jce02 FROM jce_file)", #MOD-A90019 add
               " ORDER BY imo01,imp02"
   PREPARE q007_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE q007_cs1 CURSOR FOR q007_p1
   #还料明细
   LET l_sql = "SELECT imr00,imr01,imq02,imr09,imq03,imq04,imq05,",
               "       ima02,ima021,ima25,imq07,imq11,imq07*imq11",
               "  FROM imr_file,imq_file,ima_file",
               " WHERE imr01=imq01",
               "   AND imq05=ima01",
               "   AND imr09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-A60048
               "   AND imrpost='Y'",   #MOD-A60048 add
               "   AND imr00='2'",   #No.MOD-940042 add  #No.TQC-A40130
               "   AND imq08 NOT IN (SELECT jce02 FROM jce_file)", #MOD-A90019 add
               " UNION ",
               "SELECT imr00,imr01,imq02,imr09,imq03,imq04,imq05,",
               "       ima02,ima021,ima25,imq07,imp09,imq07*imp09",
               "  FROM imr_file,imq_file,ima_file,imp_file",
               " WHERE imr01=imq01",
               "   AND imq05=ima01",
               "   AND imq03=imp01",
               "   AND imq04=imp02",
               "   AND imr09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-A60048
               "   AND imrpost='Y'",   #MOD-A60048 add
               "   AND imr00='1'",   #No.MOD-940042 add
               "   AND imq08 NOT IN (SELECT jce02 FROM jce_file)", #MOD-A90019 add
               " ORDER BY imr00,imr01,imq02"
  #end FUN-680007 modify
   PREPARE r007_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r007_cs2 CURSOR FOR r007_p2

   #借料明細
   LET g_qty_1 = 0
   LET g_tot_1 = 0
   LET g_cnt_1 = 1
   LET g_rec_b_1 = 0
   CALL g_imp.clear()
   CALL g_imp_excel.clear()
   FOREACH q007_cs1 INTO g_imp_excel[g_cnt_1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF cl_null(g_imp_excel[g_cnt_1].imp04) THEN LET g_imp_excel[g_cnt_1].imp04=0 END IF
      IF cl_null(g_imp_excel[g_cnt_1].imp09) THEN LET g_imp_excel[g_cnt_1].imp09=0 END IF
      IF cl_null(g_imp_excel[g_cnt_1].imp10) THEN LET g_imp_excel[g_cnt_1].imp10=0 END IF

      LET g_qty_1 = g_qty_1 + g_imp_excel[g_cnt_1].imp04
      LET g_tot_1 = g_tot_1 + g_imp_excel[g_cnt_1].imp10
      IF g_cnt_1 <= g_max_rec THEN
         LET g_imp[g_cnt_1].* = g_imp_excel[g_cnt_1].*
      END IF
      LET g_cnt_1 = g_cnt_1 + 1
   END FOREACH 
   IF g_cnt_1 <= g_max_rec THEN
      CALL g_imp.deleteElement(g_cnt_1)  
   END IF
   CALL g_imp_excel.deleteElement(g_cnt_1)  
   LET g_cnt_1= g_cnt_1-1
   LET g_rec_b_1 = g_cnt_1
   #IF g_rec_b_1 > g_max_rec THEN   #FUN-C80092
   IF g_rec_b_1 > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",
           g_rec_b_1||"|"||g_max_rec,10)
      LET g_rec_b_1  = g_max_rec
   END IF

   IF tm.a = 'Y' AND g_rec_b_1 > 0 THEN 
      LET g_ckk.ckk17 = " imo02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
      LET g_ckk.ckk06 = g_ccz.ccz28
      CALL s_ckk_fill('','313','axc-445',g_yy,g_mm,g_prog,g_ckk.ckk06,g_qty_1,g_tot_1,'','','','',
                     '','','','',g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
     IF NOT s_ckk(g_ckk.*,'') THEN END IF
   END IF 

   #还料明细
   LET g_qty_2 = 0
   LET g_tot_2 = 0
   LET g_cnt_2 = 1
   LET g_rec_b_2 = 0
   CALL g_imr.clear()
   CALL g_imr_excel.clear()
   FOREACH r007_cs2 INTO g_imr_excel[g_cnt_2].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(g_imr_excel[g_cnt_2].imq07) THEN LET g_imr_excel[g_cnt_2].imq07=0 END IF
      IF cl_null(g_imr_excel[g_cnt_2].imq11) THEN LET g_imr_excel[g_cnt_2].imq11=0 END IF
      IF cl_null(g_imr_excel[g_cnt_2].imq12) THEN LET g_imr_excel[g_cnt_2].imq12=0 END IF
      
      LET g_qty_2 = g_qty_2 + g_imr_excel[g_cnt_2].imq07
      LET g_tot_2 = g_tot_2 + g_imr_excel[g_cnt_2].imq12
      IF g_cnt_2 <= g_max_rec THEN
         LET g_imr[g_cnt_2].* = g_imr_excel[g_cnt_2].*
      END IF
      LET g_cnt_2 = g_cnt_2 + 1
   END FOREACH

   IF g_cnt_2 <= g_max_rec THEN
      CALL g_imr.deleteElement(g_cnt_2)  
   END IF 
   CALL g_imr_excel.deleteElement(g_cnt_2)  

   LET g_cnt_2= g_cnt_2-1
   LET g_rec_b_2 = g_cnt_2
   #IF g_rec_b_2 > g_max_rec THEN  #FUN-C80092
   IF g_rec_b_2 > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",
           g_rec_b_2||"|"||g_max_rec,10)
      LET g_rec_b_2  = g_max_rec
   END IF
   
   IF tm.a = 'Y' AND g_rec_b_2 > 0THEN
      LET g_ckk.ckk17 = " imr09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
      LET g_ckk.ckk06 = g_ccz.ccz28
      CALL s_ckk_fill('','320','axc-446',g_yy,g_mm,g_prog,g_ckk.ckk06,g_qty_2,g_tot_2,'','','','',
                     '','','','',g_ckk.ckk17,g_user,g_today,g_time,'Y') RETURNING g_ckk.*
      IF NOT s_ckk(g_ckk.*,'') THEN END IF
   END IF
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
 
END FUNCTION

FUNCTION q007_a_check()                                    #對[寫入勾稽表]欄位輸入管控
   DEFINE l_byy,l_eyy,l_bdd LIKE type_file.num5
   DEFINE l_bmm,l_emm,l_edd LIKE type_file.num5  
   DEFINE l_bdate,l_edate   LIKE type_file.dat

   LET l_byy = YEAR(tm.bdate)
   LET l_eyy = YEAR(tm.edate)
   LET l_bmm = MONTH(tm.bdate)
   LET l_emm = MONTH(tm.edate)
   IF l_byy != l_eyy OR l_bmm ! = l_emm THEN                        #判斷是否同一年月
      RETURN FALSE
   ELSE
      IF l_byy = g_ccz.ccz01 AND l_bmm = g_ccz.ccz02 AND l_eyy = g_ccz.ccz01 AND l_emm = g_ccz.ccz02 THEN       #判斷是否與axcs010中設置的一致 
         CALL s_ymtodate(l_byy,l_bmm,l_eyy,l_emm) RETURNING l_bdate,l_edate   
         IF tm.bdate != l_bdate OR tm.edate != l_edate THEN                   #判斷是否月初到月末
            RETURN FALSE
         ELSE      
            RETURN TRUE
         END IF
      ELSE
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION 
