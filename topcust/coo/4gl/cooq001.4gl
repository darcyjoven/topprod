# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# PATTERN NAME...: cooq001
# DESCRIPTIONS...: 单据笔数追踪查询
# DATE & AUTHOR..: 13/12/06  By  chuyl 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

   DEFINE tm  RECORD                                              
                 wc2 STRING,                                     
                 a   LIKE type_file.chr1,       #小計選項     #FUN-D10105 chr1==>chr10
                 b   LIKE type_file.chr1,
                 c   LIKE type_file.chr1,
                 d   LIKE type_file.chr1,
                 e   LIKE type_file.chr1,
                 f   LIKE type_file.chr1,
                 yy  LIKE osb_file.osb02,
                 mm  LIKE osb_file.osb03
              END RECORD              
   DEFINE g_msg     LIKE type_file.chr1000                                                                                           
   DEFINE g_sql     STRING                                                                                    
   DEFINE g_str     STRING    
   DEFINE l_table   STRING
   DEFINE g_rec_b        LIKE type_file.num10
   DEFINE g_cnt          LIKE type_file.num10                  
   DEFINE g_gee     DYNAMIC ARRAY OF RECORD 
                azw01_1       LIKE azw_file.azw01, 
                gee01         LIKE gee_file.gee01,
                gee02         LIKE gee_file.gee02,
                gee05         LIKE gee_file.gee05,
                smy72         LIKE smy_file.smy72,
                smy72_name    LIKE gen_file.gen02,  
                count1        LIKE type_file.num10,
                count2        LIKE type_file.num10,
                count3        LIKE type_file.num10,
                count4        LIKE type_file.num10,
                count5        LIKE type_file.num10,
                count6        LIKE type_file.num10,
                count7        LIKE type_file.num10,
                count8        LIKE type_file.num10,
                count9        LIKE type_file.num10,
                count10       LIKE type_file.num10,
                count11       LIKE type_file.num10,
                count12       LIKE type_file.num10,
                count13       LIKE type_file.num10,
                count14       LIKE type_file.num10,
                count15       LIKE type_file.num10,
                count16       LIKE type_file.num10,
                count17       LIKE type_file.num10,
                count18       LIKE type_file.num10,
                count19       LIKE type_file.num10,
                count20       LIKE type_file.num10,
                count21       LIKE type_file.num10,
                count22       LIKE type_file.num10,
                count23       LIKE type_file.num10,
                count24       LIKE type_file.num10,
                count25       LIKE type_file.num10,
                count26       LIKE type_file.num10,
                count27       LIKE type_file.num10,
                count28       LIKE type_file.num10,
                count29       LIKE type_file.num10,
                count30       LIKE type_file.num10,
                count31       LIKE type_file.num10,
                count32       LIKE type_file.num10,
                count33       LIKE type_file.num10,
                count34       LIKE type_file.num10,
                count35       LIKE type_file.num10,
                count36       LIKE type_file.num10,
                count37       LIKE type_file.num10,
                count38       LIKE type_file.num10,
                count39       LIKE type_file.num10,
                count40       LIKE type_file.num10,
                count41       LIKE type_file.num10,
                count42       LIKE type_file.num10,
                count43       LIKE type_file.num10,
                count44       LIKE type_file.num10,
                count45       LIKE type_file.num10,
                count46       LIKE type_file.num10,
                count47       LIKE type_file.num10,
                count48       LIKE type_file.num10,
                count49       LIKE type_file.num10,
                count50       LIKE type_file.num10,
                count51       LIKE type_file.num10,
                count52       LIKE type_file.num10,
                count53       LIKE type_file.num10,
                count54       LIKE type_file.num10,
                count55       LIKE type_file.num10,
                count56       LIKE type_file.num10,
                count57       LIKE type_file.num10,
                count58       LIKE type_file.num10,
                count59       LIKE type_file.num10,
                count60       LIKE type_file.num10,
                count61       LIKE type_file.num10,
                count62       LIKE type_file.num10,
                count63       LIKE type_file.num10,
                count64       LIKE type_file.num10,
                count65       LIKE type_file.num10,
                count66       LIKE type_file.num10,
                count67       LIKE type_file.num10,
                count68       LIKE type_file.num10,
                count69       LIKE type_file.num10,
                count70       LIKE type_file.num10,
                count71       LIKE type_file.num10,
                count72       LIKE type_file.num10,
                count73       LIKE type_file.num10,
                count74       LIKE type_file.num10,
                count75       LIKE type_file.num10,
                count76       LIKE type_file.num10,
                count77       LIKE type_file.num10,
                count78       LIKE type_file.num10,
                count79       LIKE type_file.num10,
                count80       LIKE type_file.num10,
                count81       LIKE type_file.num10,
                count82       LIKE type_file.num10,
                count83       LIKE type_file.num10,
                count84       LIKE type_file.num10,
                count85       LIKE type_file.num10,
                count86       LIKE type_file.num10,
                count87       LIKE type_file.num10,
                count88       LIKE type_file.num10,
                count89       LIKE type_file.num10,
                count90       LIKE type_file.num10,
                count91       LIKE type_file.num10,
                count92       LIKE type_file.num10,
                count93       LIKE type_file.num10
              
                         END RECORD

    DEFINE g_gee_attr   DYNAMIC ARRAY OF RECORD
                azw01_1       STRING, 
                gee01         STRING,
                gee02         STRING,
                gee05         STRING,
                smy72         STRING,
                smy72_name    STRING,
                count1        STRING,
                count2        STRING,
                count3        STRING,
                count4        STRING,
                count5        STRING,
                count6        STRING,
                count7        STRING,
                count8        STRING,
                count9        STRING,
                count10       STRING,
                count11       STRING,
                count12       STRING, 
                count13       STRING,
                count14       STRING,
                count15       STRING,
                count16       STRING,
                count17       STRING,
                count18       STRING,
                count19       STRING,
                count20       STRING,
                count21       STRING,
                count22       STRING,
                count23       STRING,
                count24       STRING,
                count25       STRING,
                count26       STRING,
                count27       STRING,
                count28       STRING,
                count29       STRING,
                count30       STRING,
                count31       STRING,
                count32       STRING,
                count33       STRING,
                count34       STRING,
                count35       STRING,
                count36       STRING,
                count37       STRING,
                count38       STRING,
                count39       STRING,
                count40       STRING,
                count41       STRING,
                count42       STRING,
                count43       STRING,
                count44       STRING,
                count45       STRING,
                count46       STRING,
                count47       STRING,
                count48       STRING,
                count49       STRING,
                count50       STRING,
                count51       STRING,
                count52       STRING,
                count53       STRING,
                count54       STRING,
                count55       STRING,
                count56       STRING,
                count57       STRING,
                count58       STRING,
                count59       STRING,
                count60       STRING,
                count61       STRING,
                count62       STRING,
                count63       STRING,
                count64       STRING,
                count65       STRING,
                count66       STRING,
                count67       STRING,
                count68       STRING,
                count69       STRING,
                count70       STRING,
                count71       STRING,
                count72       STRING,
                count73       STRING,
                count74       STRING,
                count75       STRING,
                count76       STRING,
                count77       STRING,
                count78       STRING,
                count79       STRING,
                count80       STRING,
                count81       STRING,
                count82       STRING,
                count83       STRING,
                count84       STRING,
                count85       STRING,
                count86       STRING,
                count87       STRING,
                count88       STRING,
                count89       STRING,
                count90       STRING,
                count91       STRING,
                count92       STRING,
                count93       STRING
                    END RECORD 
    DEFINE g_gee_1  DYNAMIC ARRAY OF RECORD  
                azw01_2        LIKE azw_file.azw01, 
                yy1            LIKE osb_file.osb02, 
                mm1            LIKE osb_file.osb03,
                gee01_1        LIKE gee_file.gee01,
                gee02_1        LIKE gee_file.gee02,
                gee05_1        LIKE gee_file.gee05,
                count1_1        LIKE type_file.num5,
                count2_1        LIKE type_file.num5,
                count3_1        LIKE type_file.num5
                         END RECORD
   DEFINE  sr            RECORD  
                azw01_1       LIKE azw_file.azw01, 
                gee01         LIKE gee_file.gee01,
                gee02         LIKE gee_file.gee02,
                gee05         LIKE gee_file.gee05,
                smy72         LIKE smy_file.smy72,
                smy72_name    LIKE gen_file.gen02,  
                count1        LIKE type_file.num10,
                count2        LIKE type_file.num10,
                count3        LIKE type_file.num10,
                count4        LIKE type_file.num10,
                count5        LIKE type_file.num10,
                count6        LIKE type_file.num10,
                count7        LIKE type_file.num10,
                count8        LIKE type_file.num10,
                count9        LIKE type_file.num10,
                count10       LIKE type_file.num10,
                count11       LIKE type_file.num10,
                count12       LIKE type_file.num10,
                count13       LIKE type_file.num10,
                count14       LIKE type_file.num10,
                count15       LIKE type_file.num10,
                count16       LIKE type_file.num10,
                count17       LIKE type_file.num10,
                count18       LIKE type_file.num10,
                count19       LIKE type_file.num10,
                count20       LIKE type_file.num10,
                count21       LIKE type_file.num10,
                count22       LIKE type_file.num10,
                count23       LIKE type_file.num10,
                count24       LIKE type_file.num10,
                count25       LIKE type_file.num10,
                count26       LIKE type_file.num10,
                count27       LIKE type_file.num10,
                count28       LIKE type_file.num10,
                count29       LIKE type_file.num10,
                count30       LIKE type_file.num10,
                count31       LIKE type_file.num10,
                count32       LIKE type_file.num10,
                count33       LIKE type_file.num10,
                count34       LIKE type_file.num10,
                count35       LIKE type_file.num10,
                count36       LIKE type_file.num10,
                count37       LIKE type_file.num10,
                count38       LIKE type_file.num10,
                count39       LIKE type_file.num10,
                count40       LIKE type_file.num10,
                count41       LIKE type_file.num10,
                count42       LIKE type_file.num10,
                count43       LIKE type_file.num10,
                count44       LIKE type_file.num10,
                count45       LIKE type_file.num10,
                count46       LIKE type_file.num10,
                count47       LIKE type_file.num10,
                count48       LIKE type_file.num10,
                count49       LIKE type_file.num10,
                count50       LIKE type_file.num10,
                count51       LIKE type_file.num10,
                count52       LIKE type_file.num10,
                count53       LIKE type_file.num10,
                count54       LIKE type_file.num10,
                count55       LIKE type_file.num10,
                count56       LIKE type_file.num10,
                count57       LIKE type_file.num10,
                count58       LIKE type_file.num10,
                count59       LIKE type_file.num10,
                count60       LIKE type_file.num10,
                count61       LIKE type_file.num10,
                count62       LIKE type_file.num10,
                count63       LIKE type_file.num10,
                count64       LIKE type_file.num10,
                count65       LIKE type_file.num10,
                count66       LIKE type_file.num10,
                count67       LIKE type_file.num10,
                count68       LIKE type_file.num10,
                count69       LIKE type_file.num10,
                count70       LIKE type_file.num10,
                count71       LIKE type_file.num10,
                count72       LIKE type_file.num10,
                count73       LIKE type_file.num10,
                count74       LIKE type_file.num10,
                count75       LIKE type_file.num10,
                count76       LIKE type_file.num10,
                count77       LIKE type_file.num10,
                count78       LIKE type_file.num10,
                count79       LIKE type_file.num10,
                count80       LIKE type_file.num10,
                count81       LIKE type_file.num10,
                count82      LIKE type_file.num10,
                count83       LIKE type_file.num10,
                count84       LIKE type_file.num10,
                count85       LIKE type_file.num10,
                count86       LIKE type_file.num10,
                count87       LIKE type_file.num10,
                count88       LIKE type_file.num10,
                count89       LIKE type_file.num10,
                count90       LIKE type_file.num10,
                count91       LIKE type_file.num10,
                count92       LIKE type_file.num10,
                count93       LIKE type_file.num10
                         END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    #FUN-C80102 
   DEFINE l_ac,l_ac1     LIKE type_file.num5                                                                                        
   DEFINE g_osb_qty      LIKE type_file.num15_3      #訂單數量總計
   DEFINE g_osb_sum      LIKE type_file.num20_6      #訂單本幣金額總計
   DEFINE g_osb_sum1     LIKE type_file.num20_6      #訂單原幣金額總計
   DEFINE g_osb_qty1      LIKE type_file.num15_3  
   DEFINE g_cmd          LIKE type_file.chr1000  
   DEFINE   g_rec_b2     LIKE type_file.num10   
   DEFINE   g_flag       LIKE type_file.chr1 
   DEFINE   g_action_flag  LIKE type_file.chr100   
   DEFINE   w    ui.Window
   DEFINE   f    ui.Form
   DEFINE   page om.DomNode  

DEFINE g_b_flag     LIKE type_file.num5
DEFINE g_b_flag2    LIKE type_file.num5
DEFINE g_b_flag3    LIKE type_file.num5
DEFINE g_b_flag4    LIKE type_file.num5
DEFINE g_int_flag   LIKE type_file.chr1
DEFINE g_osb01_o    LIKE osb_file.osb01
DEFINE g_oeb03_o    LIKE oeb_file.oeb03

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("coo")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q001_w AT 5,10
        WITH FORM "coo/42f/cooq001" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q001_q()
   CALL q001_menu()
   DROP TABLE cooq001_tmp;
   CLOSE WINDOW q001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q001_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   
   DEFINE   l_wc    STRING
   DEFINE   l_action_page3    LIKE type_file.chr1

   WHILE TRUE
    #121016-----add----str
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
    #121016----add---end
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q001_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q001_bp2()
         END IF
      END IF 
      CASE g_action_choice
         WHEN "page1"
            CALL q001_bp("G")
         
         WHEN "page2"
            CALL q001_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()    
            END IF   
            LET g_action_choice = " " 
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_osb_excel),base.TypeInfo.create(g_osb_1),'')
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_action_flag = "page1" THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_gee),'','')
               END IF
               IF g_action_flag = "page2" THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_gee_1),'','')
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "osb01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
     
      END CASE
   END WHILE
END FUNCTION

FUNCTION q001_b_fill_2()
DEFINE l_wc,l_sql    STRING

   CALL g_gee_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   LET g_osb_qty = 0
   LET g_osb_sum = 0
   LET g_osb_sum1 = 0
   LET g_osb_qty1 = 0

   CALL q001_get_sum()
     
END FUNCTION

FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,
            l_cutwip        LIKE ecm_file.ecm315,
            l_packwip       LIKE ecm_file.ecm315,
            l_completed     LIKE ecm_file.ecm315,
            l_sfb08         LIKE sfb_file.sfb08   


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1' 

   IF g_action_choice = "page1"  AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q001_b_fill()
   END IF
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.a
   DISPLAY g_osb_qty TO FORMONLY.tot_qty_1
   DISPLAY g_osb_sum TO FORMONLY.tot_sum_1
   DISPLAY g_osb_qty1 TO FORMONLY.tot_qty1_1
   DISPLAY g_osb_sum1 TO FORMONLY.tot_sum1_1
   CALL q001_set_comp_att_text()
   DISPLAY ARRAY g_gee TO s_gee.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e
      FROM a,b,c,d,e ATTRIBUTE(WITHOUT DEFAULTS)
        BEFORE INPUT
            CALL DIALOG.setArrayAttributes("s_gee",g_gee_attr)    #参数：屏幕变量,属性数组
            CALL ui.Interface.refresh()
      ON CHANGE a,b,c,d,e
         IF tm.a = 'N' AND tm.b = 'N' AND tm.c = 'N' AND tm.d = 'N' AND tm.e= 'N' THEN 
         ELSE 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1", TRUE)
            LET g_action_choice = "page2" 
         END IF 
         DISPLAY BY NAME tm.a,tm.b,tm.c,tm.e,tm.d
         EXIT DIALOG

   END INPUT
   DISPLAY ARRAY g_gee TO s_gee.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY 
            CALL DIALOG.setArrayAttributes("s_gee",g_gee_attr)    #参数：屏幕变量,属性数组
            CALL ui.Interface.refresh()
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY

   ON ACTION page2
      LET g_action_choice = 'page2'
      EXIT DIALOG

   ON ACTION query
      LET g_action_choice="query"
      EXIT DIALOG      
 
--
--
   --ON ACTION data_filter
      --LET g_action_choice="data_filter"
      --EXIT DIALOG     

   ON ACTION revert_filter         
      LET g_action_choice="revert_filter"
      EXIT DIALOG 

   ON ACTION refresh_detail
      CALL q001_b_fill()
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG

    
   ON ACTION HELP
      LET g_action_choice="help"
      EXIT DIALOG

   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   

   ON ACTION EXIT
      LET g_action_choice="exit"
      EXIT DIALOG

   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG

   ON ACTION CANCEL
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

      &include "qry_string.4gl"
   
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp2()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08 
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY  tm.a TO a
   DISPLAY  tm.b TO b
   DISPLAY  tm.c TO c
   DISPLAY ARRAY g_gee_1 TO s_gee1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE DISPLAY
           EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e
      FROM a,b,c,d,e ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a,b,c,d,e
          IF tm.a = 'N' AND tm.b = 'N' AND tm.c = 'N' AND tm.d = 'N' AND tm.e = 'N' THEN  
            ELSE 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            LET g_action_choice = "page2" 
          END IF 
         DISPLAY  tm.a TO a
         DISPLAY  tm.b TO b
         DISPLAY  tm.c TO c
         DISPLAY  tm.d TO d 
         DISPLAY  tm.e TO e
         DISPLAY  tm.f TO f
         DISPLAY  tm.yy TO yy 
         DISPLAY  tm.mm TO mm
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_gee_1 TO s_gee1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

   END DISPLAY

   ON ACTION page1
      LET g_action_choice="page1"
      EXIT DIALOG

   ON ACTION query
      LET g_action_choice="query"
      EXIT DIALOG      
 
   ON ACTION ACCEPT
      LET l_ac1 = ARR_CURR()
      IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
         --CALL q001_detail_fill(l_ac1)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice= "page1"  #0921
         LET g_flag = '1'              #0921 
         EXIT DIALOG 
      END IF
   

   ON ACTION refresh_detail
      CALL q001_b_fill()
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG
 
   ON ACTION HELP
      LET g_action_choice="help"
      EXIT DIALOG

   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   

   ON ACTION EXIT
      LET g_action_choice="exit"
      EXIT DIALOG

   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG

   ON ACTION CANCEL
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

FUNCTION q001_cs()
   DEFINE  l_cnt LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01     
   DEFINE li_chk_bookno  LIKE type_file.num5
 
   CLEAR FORM #清除畫面
   CALL g_gee.clear()
   CALL g_gee_1.clear() 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   CALL cl_set_act_visible("revert_filter",FALSE)     #FUN-D10105 add 
   LET tm.a = 'Y'
   LET tm.b = 'N'
   LET tm.c = 'N'
   LET tm.d = 'N'
   LET tm.e = 'N'
   LET tm.f = '1'
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
DIALOG ATTRIBUTE(UNBUFFERED)    
      CONSTRUCT tm.wc2 ON azw01
                  FROM azw01
              
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
	 
      END CONSTRUCT
      
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.yy,tm.mm
        ATTRIBUTE(WITHOUT DEFAULTS)
        
#      BEFORE INPUT
#         CALL cl_qbe_display_condition(lc_qbe_sn)  

   END INPUT


       ON ACTION controlp
          CASE
             WHEN INFIELD(azw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_user
                  LET g_qryparam.form ="q_zxy" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azw01
                  NEXT FIELD azw01
                   
          END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          IF tm.a = 'N' AND tm.b = 'N' AND tm.c = 'N' AND tm.d = 'N' AND tm.e = 'N' THEN 
           NEXT FIELD a
          END IF 
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG    
END DIALOG                                                                                                                                                                     
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         LET g_int_flag = '1'
         DELETE FROM cooq001_tmp
#        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         RETURN 
#        EXIT PROGRAM
      END IF

      CALL q001_b_fill()
         
END FUNCTION 

FUNCTION q001_q()

    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q001_set_unvisible()
    CALL q001_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"

    MESSAGE ""
    CALL q001_show()
END FUNCTION

FUNCTION q001_show()
   DISPLAY tm.a TO a
   DISPLAY tm.b TO b
   DISPLAY tm.c TO c
   #CALL q001_b_fill()  
   CALL q001_b_fill_2()
   IF cl_null(tm.a)  THEN   
      LET g_action_choice = "page1" 
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_flag = "page1"
   ELSE
      IF g_int_flag = '0' THEN
         LET g_action_choice = "page2"
         CALL cl_set_comp_visible("page1", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         LET g_action_flag = "page2"
      ELSE
         LET g_action_choice = "page1"
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE) 
         LET g_action_flag = "page1"
      END IF
   END IF

   CALL q001_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q001_table()
   DROP TABLE cooq001_tmp;
   CREATE TEMP TABLE cooq001_tmp(
                azw01_1       LIKE azw_file.azw01, 
                count1        LIKE type_file.num5,
                count2        LIKE type_file.num5,
                count3        LIKE type_file.num5,
                yy            LIKE type_file.num5,
                mm            LIKE type_file.num5,
                gee01         LIKE gee_file.gee01,
                gee02         LIKE gee_file.gee02,
                gee05         LIKE gee_file.gee05);
             
END FUNCTION 

FUNCTION q001_b_fill()
 DEFINE l_name      LIKE type_file.chr20,           
          l_sql       STRING,    
          l_sql1      STRING,
          l_sql2      STRING,
          l_sql3      STRING,          
          l_chr       LIKE type_file.chr1,  
          i           LIKE type_file.num5,       
          l_i         LIKE type_file.num5              
   DEFINE l_wc,l_msg   STRING 
   DEFINE l_num    LIKE type_file.num5
   DEFINE l_azw01  LIKE azw_file.azw01
   DEFINE l_table  LIKE gee_file.gee06
   DEFINE l_type   LIKE gee_file.gee08
   DEFINE l_db     LIKE gee_file.gee08
   DEFINE l_gee04  LIKE gee_file.gee04
   DEFINE l_tc_gee01  LIKE tc_gee_file.tc_gee01
   DEFINE l_tc_gee02  LIKE tc_gee_file.tc_gee02
   DEFINE l_tc_gee03  LIKE tc_gee_file.tc_gee03
   DEFINE l_tc_gee04  LIKE tc_gee_file.tc_gee04
   DEFINE l_tc_gee05  LIKE tc_gee_file.tc_gee05
   DEFINE l_tc_gee06  LIKE tc_gee_file.tc_gee06
   DEFINE l_tc_gee07  LIKE tc_gee_file.tc_gee07
   DEFINE l_tc_gee08  LIKE tc_gee_file.tc_gee08
   DEFINE l_tc_gee09  LIKE tc_gee_file.tc_gee09
   DEFINE l_tc_gee10  LIKE tc_gee_file.tc_gee10
   DEFINE l_tc_gee11  LIKE tc_gee_file.tc_gee11
   DEFINE l_tc_gee12  LIKE tc_gee_file.tc_gee12
   DEFINE l_tc_geeacti LIKE type_file.chr1
   DEFINE l_correct   LIKE type_file.chr1
   DEFINE g_bdate     LIKE oga_file.oga02
   DEFINE g_edate     LIKE oga_file.oga02
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_cnt1      LIKE type_file.num10
   DEFINE l_cnt2      LIKE type_file.num10
   DEFINE l_cnt3      LIKE type_file.num10
   DEFINE l_date      LIKE oga_file.oga02
   DEFINE l_gee05     LIKE gee_file.gee05
             
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('osbuser', 'osbgrup')
   CALL q001_table()
   CALL g_gee_attr.clear()
   CALL g_gee.clear()
   DELETE FROM cooq001_tmp
   LET l_cnt = 1
   LET l_sql = " INSERT INTO cooq001_tmp VALUES (?,?,?,?,?, ?,?,?,?)"
        PREPARE tem_ins FROM l_sql
   
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, g_bdate, g_edate #得出起始日與截止日
   
   LET l_sql = " SELECT DISTINCT azw01 FROM azw_file WHERE ",tm.wc2 CLIPPED 
   PREPARE insazw FROM l_sql 
   DECLARE ins_azw CURSOR FOR insazw
   FOREACH ins_azw INTO l_azw01
#140101 add luoyb str
     LET l_tc_gee01 = NULL LET l_tc_gee02 = NULL 
     LET l_tc_gee03 = NULL LET l_tc_gee04 = NULL 
     LET l_tc_gee05 = NULL LET l_tc_gee06 = NULL 
     LET l_tc_gee07 = NULL LET l_tc_gee08 = NULL 
     LET l_tc_gee09 = NULL LET l_tc_gee10 = NULL 
     LET l_tc_gee11 = NULL LET l_tc_gee12 = NULL
#140101 add luoyb end
     LET l_sql1 = "SELECT tc_gee01,tc_gee02,tc_gee03,tc_gee04,tc_gee05,tc_gee06,tc_gee07,tc_gee08,tc_gee09,",
                 "tc_gee10,tc_gee11,tc_gee12 FROM ", cl_get_target_table(l_azw01,'tc_gee_file'),
                 " WHERE tc_geeacti = 'Y'"
     PREPARE tc_geese FROM l_sql1
     DECLARE tc_gees  CURSOR FOR tc_geese
       FOREACH tc_gees INTO l_tc_gee01,l_tc_gee02,l_tc_gee03,l_tc_gee04,l_tc_gee05,l_tc_gee06,l_tc_gee07,l_tc_gee08,
        l_tc_gee09,l_tc_gee10,l_tc_gee11,l_tc_gee12
#140101 add luoyb str
        LET l_gee04 = NULL LET l_gee05 = NULL
#140101 add luoyb end
        LET l_sql1 = " SELECT DISTINCT gee04,gee05 FROM ",cl_get_target_table(l_azw01,'gee_file'),",",cl_get_target_table(l_azw01,'zz_file'),
                     " WHERE gee04 = zz01 AND gee01 = '",l_tc_gee01,"' AND gee02 = '",l_tc_gee02,"' AND gee03 = '2'"
        PREPARE selgee FROM l_sql1
        EXECUTE selgee INTO l_gee04,l_gee05
         CASE l_gee04
           WHEN 'aapi010'
             LET l_table = 'apy_file'
             LET l_type =  'apykind'
             LET l_db = 'apyslip'
           WHEN 'aapi103'
             LET l_table = 'apy_file'
             LET l_type =  'apykind'
             LET l_db = 'apyslip'
           WHEN 'abxi010'
             LET l_table = 'bna_file'
             LET l_type = 'bna05'
             LET l_db ='bna01'
           WHEN 'abxi860'
             LET l_table = 'bna_file'
             LET l_type = 'bna05'
             LET l_db ='bna01'
           WHEN 'acoi010'
             LET l_table = 'coy_file '
             LET l_type = 'coytype'
             LET l_db ='coyslip'
           WHEN 'afai060'
             LET l_table = 'fah_file'
             LET l_type = 'fahtype'
             LET l_db = 'fahslip'
           WHEN 'agli108'
             LET l_table = 'aac_file'
             LET l_type = 'aac11'
             LET l_db = 'aac01'
           WHEN 'almi001'
             LET l_table = 'oay_file'
             LET l_type = 'oaytype'
             LET l_db = 'oayslip'
           WHEN 'anmi100'
             LET l_table = 'nmy_file'
             LET l_type = 'nmykind'
             LET l_db = 'nmyslip'
           WHEN 'armi001'
             LET l_table = 'oay_file'
             LET l_type = 'oaytype'
             LET l_db = 'oayslip' 
           WHEN 'arti010'
             LET l_table = 'oay_file'
             LET l_type = 'oaytype'
             LET l_db = 'oayslip' 
           WHEN 'asmi300'
             LET l_table = 'smy_file'
             LET l_type = 'smykind'
             LET l_db = 'smyslip'
           WHEN 'atmi010'
             LET l_table = 'oay_file'
             LET l_type = 'oaytype'
             LET l_db = 'oayslip'
           WHEN 'axmi010'
             LET l_table = 'oay_file'
             LET l_type = 'oaytype'
             LET l_db = 'oayslip'
           WHEN 'axri010'
             LET l_table = 'ooy_file'
             LET l_type = 'ooytype'
             LET l_db = 'ooyslip'
           WHEN 'axsi010'
             LET l_table = 'osy_file'
             LET l_type = 'osytype'
             LET l_db = 'osyslip'
         END CASE 

       IF tm.f = '1' THEN                    #oea01=abc-00000a     substr(oea01,1,instr(oea01,'-',1))
         LET l_sql1 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01,l_table),",",
                    cl_get_target_table(l_azw01,l_tc_gee04)," WHERE substr(",l_tc_gee05,",1,instr(",l_tc_gee05,",'-',1)-1) = ",l_db,"",
                    " AND ",l_type," = '",l_tc_gee02,"' AND ",l_tc_gee12," = ? "
         PREPARE aa1 FROM l_sql1

         LET l_sql2 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01,l_table),",",cl_get_target_table(l_azw01,l_tc_gee04),
                      " WHERE substr(",l_tc_gee05,",1,instr(",l_tc_gee05,",'-',1)-1) = ",l_db," AND ",l_type," = '",l_tc_gee02,"' ",
                      " AND ",l_tc_gee06," = '",l_tc_gee07,"' AND ",l_tc_gee12," = ? "
         PREPARE aa2 FROM l_sql2

         LET l_sql3 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01,l_table),",",cl_get_target_table(l_azw01,l_tc_gee04),
                      " WHERE substr(",l_tc_gee05,",1,instr(",l_tc_gee05,",'-',1)-1) = ",l_db," AND ",l_type," = '",l_tc_gee02,"' ",
                       " AND ",l_tc_gee06," = '",l_tc_gee07,"' AND ",l_tc_gee08,"= '",l_tc_gee09,"' AND ",l_tc_gee12," = ? "
         PREPARE aa3 FROM l_sql3
       ELSE 
         LET l_sql1 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01,l_table),",",cl_get_target_table(l_azw01,l_tc_gee10),",",
                    cl_get_target_table(l_azw01,l_tc_gee04)," WHERE substr(",l_tc_gee05,",1,instr(",l_tc_gee05,",'-',1)-1) = ",l_db,"",
                    " AND ",l_type," = '",l_tc_gee02,"' AND ",l_tc_gee11," AND ",l_tc_gee12," = ? "
         PREPARE aa4 FROM l_sql1

          LET l_sql2 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01,l_table),",",cl_get_target_table(l_azw01,l_tc_gee04),",",cl_get_target_table(l_azw01,l_tc_gee10),
                      " WHERE substr(",l_tc_gee05,",1,instr(",l_tc_gee05,",'-',1)-1) = ",l_db," AND ",l_type," = '",l_tc_gee02,"'",
                      " AND ",l_tc_gee06," = '",l_tc_gee07,"' AND ",l_tc_gee11," AND ",l_tc_gee12," = ? "
         PREPARE aa5 FROM l_sql2

          LET l_sql3 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_azw01,l_table),",",cl_get_target_table(l_azw01,l_tc_gee04),",",cl_get_target_table(l_azw01,l_tc_gee10),
                      " WHERE substr(",l_tc_gee05,",1,instr(",l_tc_gee05,",'-',1)-1) = ",l_db," AND ",l_type," = '",l_tc_gee02,"' ",
                       " AND ",l_tc_gee06," = '",l_tc_gee07,"' AND ",l_tc_gee08,"= '",l_tc_gee09,"' AND ",l_tc_gee11," AND ",l_tc_gee12," = ? "
         PREPARE aa6 FROM l_sql3
       END IF 

     LET sr.azw01_1 = l_azw01
     LET sr.gee01 = l_tc_gee01
     LET sr.gee02 = l_tc_gee02
     LET sr.gee05 = l_gee05
     LET sr.smy72 =NULL
     LET sr.smy72_name = NULL 
     
     LET l_i = g_edate - g_bdate
     FOR i = 0 TO l_i
#140101 add luoyb str
       LET l_cnt1 = NULL
       LET l_cnt2 = NULL 
       LET l_cnt3 = NULL
#140101 add luoyb end
       LET l_date =  g_bdate + i 
       IF tm.f = '1' THEN 
       EXECUTE aa1 INTO l_cnt1 USING l_date
       EXECUTE aa2 INTO l_cnt2 USING l_date
       EXECUTE aa3 INTO l_cnt3 USING l_date
       ELSE 
       EXECUTE aa4 INTO l_cnt1 USING l_date
       EXECUTE aa5 INTO l_cnt2 USING l_date
       EXECUTE aa6 INTO l_cnt3 USING l_date
       END IF
#140101 add luoyb str
       IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF 
       IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF 
       IF cl_null(l_cnt3) THEN LET l_cnt3 = 0 END IF 
#140101 add luoyb end
       CASE i
        WHEN 0
         LET sr.count1 = l_cnt1
         LET sr.count2 = l_cnt2
         LET sr.count3 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 1
         LET sr.count4 = l_cnt1
         LET sr.count5 = l_cnt2
         LET sr.count6 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 2
         LET sr.count7 = l_cnt1
         LET sr.count8 = l_cnt2
         LET sr.count9 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 3
         LET sr.count10 = l_cnt1
         LET sr.count11 = l_cnt2
         LET sr.count12 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 4
         LET sr.count13 = l_cnt1
         LET sr.count14 = l_cnt2
         LET sr.count15 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 5
         LET sr.count16 = l_cnt1
         LET sr.count17 = l_cnt2
         LET sr.count18 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 6
         LET sr.count19 = l_cnt1
         LET sr.count20 = l_cnt2
         LET sr.count21 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 7
         LET sr.count22 = l_cnt1
         LET sr.count23 = l_cnt2
         LET sr.count24 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 8
         LET sr.count25 = l_cnt1
         LET sr.count26 = l_cnt2
         LET sr.count27 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 9
         LET sr.count28 = l_cnt1
         LET sr.count29 = l_cnt2
         LET sr.count30 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 10
         LET sr.count31 = l_cnt1
         LET sr.count32 = l_cnt2
         LET sr.count33 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 11
         LET sr.count34 = l_cnt1
         LET sr.count35 = l_cnt2
         LET sr.count36 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 12
         LET sr.count37 = l_cnt1
         LET sr.count38 = l_cnt2
         LET sr.count39 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 13
         LET sr.count40 = l_cnt1
         LET sr.count41 = l_cnt2
         LET sr.count42 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 14
         LET sr.count43 = l_cnt1
         LET sr.count44 = l_cnt2
         LET sr.count45 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 15
         LET sr.count46 = l_cnt1
         LET sr.count47 = l_cnt2
         LET sr.count48 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 16
         LET sr.count49 = l_cnt1
         LET sr.count50 = l_cnt2
         LET sr.count51 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 17
         LET sr.count52 = l_cnt1
         LET sr.count53 = l_cnt2
         LET sr.count54 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 18
         LET sr.count55 = l_cnt1
         LET sr.count56 = l_cnt2
         LET sr.count57 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 19
         LET sr.count58 = l_cnt1
         LET sr.count59 = l_cnt2
         LET sr.count60 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 20
         LET sr.count61 = l_cnt1
         LET sr.count62 = l_cnt2
         LET sr.count63 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 21
         LET sr.count64 = l_cnt1
         LET sr.count65 = l_cnt2
         LET sr.count66 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 22
         LET sr.count67 = l_cnt1
         LET sr.count68 = l_cnt2
         LET sr.count69 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 23
         LET sr.count70 = l_cnt1
         LET sr.count71 = l_cnt2
         LET sr.count72 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 24
         LET sr.count73 = l_cnt1
         LET sr.count74 = l_cnt2
         LET sr.count75 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 25
         LET sr.count76 = l_cnt1
         LET sr.count77 = l_cnt2
         LET sr.count78 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 26
         LET sr.count79 = l_cnt1
         LET sr.count80 = l_cnt2
         LET sr.count81 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 27
         LET sr.count82 = l_cnt1
         LET sr.count83 = l_cnt2
         LET sr.count84 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 28
         LET sr.count85 = l_cnt1
         LET sr.count86 = l_cnt2
         LET sr.count87 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 29
         LET sr.count88 = l_cnt1
         LET sr.count89 = l_cnt2
         LET sr.count90 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        WHEN 30
         LET sr.count91 = l_cnt1
         LET sr.count92 = l_cnt2
         LET sr.count93 = l_cnt3
         EXECUTE tem_ins USING sr.azw01_1,l_cnt1,l_cnt2,l_cnt3,tm.yy,tm.mm,sr.gee01,sr.gee02,sr.gee05
        END CASE 
     END FOR 

       LET  g_gee[l_cnt].* = sr.*
       IF g_gee[l_cnt].count1 <> 0 THEN 
         LET g_gee_attr[l_cnt].count1 = "yellow"
       END IF 
       IF g_gee[l_cnt].count2 <> 0 THEN 
         LET g_gee_attr[l_cnt].count2 = "yellow"
       END IF 
       IF g_gee[l_cnt].count3 <> 0 THEN 
         LET g_gee_attr[l_cnt].count3 = "yellow"
       END IF 
       IF g_gee[l_cnt].count4 <> 0 THEN 
         LET g_gee_attr[l_cnt].count4 = "yellow"
       END IF 
       IF g_gee[l_cnt].count5 <> 0 THEN 
         LET g_gee_attr[l_cnt].count5 = "yellow"
       END IF 
       IF g_gee[l_cnt].count6 <> 0 THEN 
         LET g_gee_attr[l_cnt].count6 = "yellow"
       END IF 
       IF g_gee[l_cnt].count7 <> 0 THEN 
         LET g_gee_attr[l_cnt].count7 = "yellow"
       END IF 
       IF g_gee[l_cnt].count8 <> 0 THEN 
         LET g_gee_attr[l_cnt].count8 = "yellow"
       END IF 
       IF g_gee[l_cnt].count9 <> 0 THEN 
         LET g_gee_attr[l_cnt].count9 = "yellow"
       END IF 
       IF g_gee[l_cnt].count10 <> 0 THEN 
         LET g_gee_attr[l_cnt].count10 = "yellow"
       END IF 
       IF g_gee[l_cnt].count11 <> 0 THEN 
         LET g_gee_attr[l_cnt].count11 = "yellow"
       END IF 
       IF g_gee[l_cnt].count12 <> 0 THEN 
         LET g_gee_attr[l_cnt].count12 = "yellow"
       END IF 
       IF g_gee[l_cnt].count13 <> 0 THEN 
         LET g_gee_attr[l_cnt].count13 = "yellow"
       END IF 
       IF g_gee[l_cnt].count14 <> 0 THEN 
         LET g_gee_attr[l_cnt].count14 = "yellow"
       END IF 
       IF g_gee[l_cnt].count15 <> 0 THEN 
         LET g_gee_attr[l_cnt].count15 = "yellow"
       END IF 
       IF g_gee[l_cnt].count16 <> 0 THEN 
         LET g_gee_attr[l_cnt].count16 = "yellow"
       END IF 
       IF g_gee[l_cnt].count17 <> 0 THEN 
         LET g_gee_attr[l_cnt].count17 = "yellow"
       END IF 
       IF g_gee[l_cnt].count18 <> 0 THEN 
         LET g_gee_attr[l_cnt].count18 = "yellow"
       END IF 
       IF g_gee[l_cnt].count19 <> 0 THEN 
         LET g_gee_attr[l_cnt].count19 = "yellow"
       END IF 
       IF g_gee[l_cnt].count20 <> 0 THEN 
         LET g_gee_attr[l_cnt].count20 = "yellow"
       END IF 
       IF g_gee[l_cnt].count21 <> 0 THEN 
         LET g_gee_attr[l_cnt].count21 = "yellow"
       END IF 
       IF g_gee[l_cnt].count22 <> 0 THEN 
         LET g_gee_attr[l_cnt].count22 = "yellow"
       END IF 
       IF g_gee[l_cnt].count23 <> 0 THEN 
         LET g_gee_attr[l_cnt].count23 = "yellow"
       END IF 
       IF g_gee[l_cnt].count24 <> 0 THEN 
         LET g_gee_attr[l_cnt].count24 = "yellow"
       END IF 
       IF g_gee[l_cnt].count25 <> 0 THEN 
         LET g_gee_attr[l_cnt].count25 = "yellow"
       END IF 
       IF g_gee[l_cnt].count26 <> 0 THEN 
         LET g_gee_attr[l_cnt].count26 = "yellow"
       END IF 
       IF g_gee[l_cnt].count27 <> 0 THEN 
         LET g_gee_attr[l_cnt].count27 = "yellow"
       END IF 
       IF g_gee[l_cnt].count28 <> 0 THEN 
         LET g_gee_attr[l_cnt].count28 = "yellow"
       END IF 
       IF g_gee[l_cnt].count29 <> 0 THEN 
         LET g_gee_attr[l_cnt].count29 = "yellow"
       END IF 
       IF g_gee[l_cnt].count30 <> 0 THEN 
         LET g_gee_attr[l_cnt].count30 = "yellow"
       END IF 
       IF g_gee[l_cnt].count31 <> 0 THEN 
         LET g_gee_attr[l_cnt].count31 = "yellow"
       END IF 
       IF g_gee[l_cnt].count32 <> 0 THEN 
         LET g_gee_attr[l_cnt].count32 = "yellow"
       END IF 
       IF g_gee[l_cnt].count33 <> 0 THEN 
         LET g_gee_attr[l_cnt].count33 = "yellow"
       END IF 
       IF g_gee[l_cnt].count34 <> 0 THEN 
         LET g_gee_attr[l_cnt].count34 = "yellow"
       END IF 
       IF g_gee[l_cnt].count35 <> 0 THEN 
         LET g_gee_attr[l_cnt].count35 = "yellow"
       END IF 
       IF g_gee[l_cnt].count36 <> 0 THEN 
         LET g_gee_attr[l_cnt].count36 = "yellow"
       END IF 
       IF g_gee[l_cnt].count37 <> 0 THEN 
         LET g_gee_attr[l_cnt].count37 = "yellow"
       END IF 
       IF g_gee[l_cnt].count38 <> 0 THEN 
         LET g_gee_attr[l_cnt].count38 = "yellow"
       END IF 
       IF g_gee[l_cnt].count39 <> 0 THEN 
         LET g_gee_attr[l_cnt].count39 = "yellow"
       END IF 
       IF g_gee[l_cnt].count40 <> 0 THEN 
         LET g_gee_attr[l_cnt].count40 = "yellow"
       END IF 
       IF g_gee[l_cnt].count41 <> 0 THEN 
         LET g_gee_attr[l_cnt].count41 = "yellow"
       END IF 
       IF g_gee[l_cnt].count42 <> 0 THEN 
         LET g_gee_attr[l_cnt].count42 = "yellow"
       END IF 
       IF g_gee[l_cnt].count43 <> 0 THEN 
         LET g_gee_attr[l_cnt].count43 = "yellow"
       END IF 
       IF g_gee[l_cnt].count44 <> 0 THEN 
         LET g_gee_attr[l_cnt].count44 = "yellow"
       END IF 
       IF g_gee[l_cnt].count45 <> 0 THEN 
         LET g_gee_attr[l_cnt].count45 = "yellow"
       END IF 
       IF g_gee[l_cnt].count46 <> 0 THEN 
         LET g_gee_attr[l_cnt].count46 = "yellow"
       END IF 
       IF g_gee[l_cnt].count47 <> 0 THEN 
         LET g_gee_attr[l_cnt].count47 = "yellow"
       END IF 
       IF g_gee[l_cnt].count48 <> 0 THEN 
         LET g_gee_attr[l_cnt].count48 = "yellow"
       END IF 
       IF g_gee[l_cnt].count49 <> 0 THEN 
         LET g_gee_attr[l_cnt].count49 = "yellow"
       END IF 
       IF g_gee[l_cnt].count50 <> 0 THEN 
         LET g_gee_attr[l_cnt].count50 = "yellow"
       END IF 
       IF g_gee[l_cnt].count51 <> 0 THEN 
         LET g_gee_attr[l_cnt].count51 = "yellow"
       END IF 
       IF g_gee[l_cnt].count52 <> 0 THEN 
         LET g_gee_attr[l_cnt].count52 = "yellow"
       END IF 
       IF g_gee[l_cnt].count53 <> 0 THEN 
         LET g_gee_attr[l_cnt].count53 = "yellow"
       END IF 
       IF g_gee[l_cnt].count54 <> 0 THEN 
         LET g_gee_attr[l_cnt].count54 = "yellow"
       END IF 
       IF g_gee[l_cnt].count55 <> 0 THEN 
         LET g_gee_attr[l_cnt].count55 = "yellow"
       END IF 
       IF g_gee[l_cnt].count56 <> 0 THEN 
         LET g_gee_attr[l_cnt].count56 = "yellow"
       END IF 
       IF g_gee[l_cnt].count57 <> 0 THEN 
         LET g_gee_attr[l_cnt].count57 = "yellow"
       END IF 
       IF g_gee[l_cnt].count58 <> 0 THEN 
         LET g_gee_attr[l_cnt].count58 = "yellow"
       END IF 
       IF g_gee[l_cnt].count59 <> 0 THEN 
         LET g_gee_attr[l_cnt].count59 = "yellow"
       END IF 
       IF g_gee[l_cnt].count60 <> 0 THEN 
         LET g_gee_attr[l_cnt].count60 = "yellow"
       END IF 
       IF g_gee[l_cnt].count61 <> 0 THEN 
         LET g_gee_attr[l_cnt].count61 = "yellow"
       END IF 
       IF g_gee[l_cnt].count62 <> 0 THEN 
         LET g_gee_attr[l_cnt].count62 = "yellow"
       END IF 
       IF g_gee[l_cnt].count63 <> 0 THEN 
         LET g_gee_attr[l_cnt].count63 = "yellow"
       END IF 
IF g_gee[l_cnt].count64 <> 0 THEN LET g_gee_attr[l_cnt].count64 = "yellow" END IF 
IF g_gee[l_cnt].count65 <> 0 THEN LET g_gee_attr[l_cnt].count65 = "yellow" END IF 
IF g_gee[l_cnt].count66 <> 0 THEN LET g_gee_attr[l_cnt].count66 = "yellow" END IF 
IF g_gee[l_cnt].count67 <> 0 THEN LET g_gee_attr[l_cnt].count67 = "yellow" END IF 
IF g_gee[l_cnt].count68 <> 0 THEN LET g_gee_attr[l_cnt].count68 = "yellow" END IF 
IF g_gee[l_cnt].count69 <> 0 THEN LET g_gee_attr[l_cnt].count69 = "yellow" END IF 
IF g_gee[l_cnt].count70 <> 0 THEN LET g_gee_attr[l_cnt].count70 = "yellow" END IF 
IF g_gee[l_cnt].count71 <> 0 THEN LET g_gee_attr[l_cnt].count71 = "yellow" END IF 
IF g_gee[l_cnt].count72 <> 0 THEN LET g_gee_attr[l_cnt].count72 = "yellow" END IF 
IF g_gee[l_cnt].count73 <> 0 THEN LET g_gee_attr[l_cnt].count73 = "yellow" END IF 
IF g_gee[l_cnt].count74 <> 0 THEN LET g_gee_attr[l_cnt].count74 = "yellow" END IF 
IF g_gee[l_cnt].count75 <> 0 THEN LET g_gee_attr[l_cnt].count75 = "yellow" END IF 
IF g_gee[l_cnt].count76 <> 0 THEN LET g_gee_attr[l_cnt].count76 = "yellow" END IF 
IF g_gee[l_cnt].count77 <> 0 THEN LET g_gee_attr[l_cnt].count77 = "yellow" END IF 
IF g_gee[l_cnt].count78 <> 0 THEN LET g_gee_attr[l_cnt].count78 = "yellow" END IF 
IF g_gee[l_cnt].count79 <> 0 THEN LET g_gee_attr[l_cnt].count79 = "yellow" END IF 
IF g_gee[l_cnt].count80 <> 0 THEN LET g_gee_attr[l_cnt].count80 = "yellow" END IF 
IF g_gee[l_cnt].count81 <> 0 THEN LET g_gee_attr[l_cnt].count81 = "yellow" END IF 
IF g_gee[l_cnt].count82 <> 0 THEN LET g_gee_attr[l_cnt].count82 = "yellow" END IF 
IF g_gee[l_cnt].count83 <> 0 THEN LET g_gee_attr[l_cnt].count83 = "yellow" END IF 
IF g_gee[l_cnt].count84 <> 0 THEN LET g_gee_attr[l_cnt].count84 = "yellow" END IF 
IF g_gee[l_cnt].count85 <> 0 THEN LET g_gee_attr[l_cnt].count85 = "yellow" END IF 
IF g_gee[l_cnt].count86 <> 0 THEN LET g_gee_attr[l_cnt].count86 = "yellow" END IF 
IF g_gee[l_cnt].count87 <> 0 THEN LET g_gee_attr[l_cnt].count87 = "yellow" END IF 
IF g_gee[l_cnt].count88 <> 0 THEN LET g_gee_attr[l_cnt].count88 = "yellow" END IF 
IF g_gee[l_cnt].count89 <> 0 THEN LET g_gee_attr[l_cnt].count89 = "yellow" END IF 
IF g_gee[l_cnt].count90 <> 0 THEN LET g_gee_attr[l_cnt].count90 = "yellow" END IF 
IF g_gee[l_cnt].count91 <> 0 THEN LET g_gee_attr[l_cnt].count91 = "yellow" END IF 
IF g_gee[l_cnt].count92 <> 0 THEN LET g_gee_attr[l_cnt].count92 = "yellow" END IF 
IF g_gee[l_cnt].count93 <> 0 THEN LET g_gee_attr[l_cnt].count93 = "yellow" END IF 
       
       LET l_cnt = l_cnt + 1
       
    END FOREACH 
   END FOREACH 
                                    
   
END FUNCTION 

FUNCTION q001_get_sum()
DEFINE     l_wc     STRING
DEFINE     l_sql    STRING
DEFINE     l_sql1   STRING 

         LET l_sql = " SELECT "
         IF tm.a = 'Y' THEN 
           LET l_sql = l_sql," azw01_1, "
         ELSE 
           LET l_sql = l_sql," '', "
         END IF 

         IF tm.b = 'Y' THEN 
           LET l_sql = l_sql," yy, "
         ELSE 
           LET l_sql = l_sql," '', "
         END IF 

         IF tm.c = 'Y' THEN 
           LET l_sql = l_sql," mm,"
         ELSE 
           LET l_sql = l_sql," '',"
         END IF 

         IF tm.d = 'Y' THEN 
           LET l_sql = l_sql," gee01,"
         ELSE 
           LET l_sql = l_sql," '',"
         END IF 
         
        IF tm.e = 'Y' THEN 
           LET l_sql = l_sql," gee02,gee05,"
         ELSE 
           LET l_sql = l_sql," '','',"
         END IF 
        LET l_sql = l_sql,"SUM(count1),SUM(count2),SUM(count3)", 
                          " FROM cooq001_tmp",
                          " GROUP BY "
         LET l_sql1 = NULL 
             IF tm.a = 'Y' THEN 
              IF cl_null(l_sql1) THEN 
                 LET l_sql1 = " azw01_1 "
              ELSE 
                 LET l_sql1 = l_sql1," ,azw01_1 "
              END IF 
             END IF 

            IF tm.b = 'Y' THEN 
              IF cl_null(l_sql1) THEN 
                 LET l_sql1 = " yy "
              ELSE 
                 LET l_sql1 = l_sql1," ,yy "
              END IF 
            END IF 

            IF tm.c = 'Y' THEN 
              IF cl_null(l_sql1) THEN 
                 LET l_sql1 = " mm "
              ELSE 
                 LET l_sql1 = l_sql1," ,mm "
              END IF 
            END IF 
            
            IF tm.d = 'Y' THEN 
              IF cl_null(l_sql1) THEN 
                 LET l_sql1 = " gee01 "
              ELSE 
                 LET l_sql1 = l_sql1," ,gee01 "
              END IF 
            END IF 

            IF tm.e = 'Y' THEN 
              IF cl_null(l_sql1) THEN 
                 LET l_sql1 = " gee02,gee05 "
              ELSE 
                 LET l_sql1 = l_sql1," ,gee02,gee05 "
              END IF 
            END IF 

            LET l_sql =l_sql,l_sql1," ORDER BY ",l_sql1 CLIPPED 
   PREPARE q001_pb FROM l_sql
   DECLARE q001_curs1 CURSOR FOR q001_pb
   FOREACH q001_curs1 INTO g_gee_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gee_1.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   DISPLAY ARRAY g_gee_1 TO s_gee1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   LET g_rec_b2 = g_cnt 
END FUNCTION  

FUNCTION q001_set_visible()
DEFINE l_wc     LIKE type_file.chr20
CALL cl_set_comp_visible("azw01_2,yy1,mm1,gee01_1,gee02_1,gee05_1",FALSE )

      IF tm.a = 'Y' THEN 
         CALL cl_set_comp_visible("azw01_2",TRUE)
      END IF 

      IF tm.b = 'Y' THEN 
        CALL cl_set_comp_visible("yy1",TRUE)
      END IF 
     
      IF tm.c = 'Y' THEN 
       CALL cl_set_comp_visible("mm1",TRUE)
      END IF 

      IF tm.d = 'Y' THEN 
       CALL cl_set_comp_visible("gee01_1",TRUE)
      END IF 

      IF tm.e = 'Y' THEN 
       CALL cl_set_comp_visible("gee02_1,gee05_1",TRUE)
      END IF 

END FUNCTION 

FUNCTION q001_set_comp_att_text()
DEFINE l_correct   LIKE type_file.chr1
DEFINE g_bdate     LIKE oga_file.oga02
DEFINE g_edate     LIKE oga_file.oga02
DEFINE l_string    STRING 
DEFINE l_string1   STRING 
DEFINE l_string2   STRING 
DEFINE l_string3   STRING 
DEFINE l_string4   STRING 
DEFINE l_i         LIKE type_file.num5
DEFINE i           LIKE type_file.num5

    CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, g_bdate, g_edate 
    LET l_i =g_edate - g_bdate
    CASE l_i 
      WHEN 27
        CALL cl_set_comp_visible("count1,count2,count3,count4,count5,count6,count7,count8,count9,count10",TRUE )
        CALL cl_set_comp_visible("count11,count12,count13,count14,count15,count16,count17,count18,count19,count20",TRUE )
        CALL cl_set_comp_visible("count21,count22,count23,count24,count25,count26,count27,count28,count29,count30",TRUE )
        CALL cl_set_comp_visible("count31,count32,count33,count34,count35,count36,count37,count38,count39,count40",TRUE )
        CALL cl_set_comp_visible("count41,count42,count43,count44,count45,count46,count47,count48,count49,count50",TRUE )
        CALL cl_set_comp_visible("count51,count52,count53,count54,count55,count56,count57,count58,count59,count60",TRUE )
        CALL cl_set_comp_visible("count61,count62,count63,count64,count65,count66,count67,count68,count69,count70",TRUE )
        CALL cl_set_comp_visible("count81,count82,count83,count84",FALSE )
      WHEN 28
        CALL cl_set_comp_visible("count1,count2,count3,count4,count5,count6,count7,count8,count9,count10",TRUE )
        CALL cl_set_comp_visible("count11,count12,count13,count14,count15,count16,count17,count18,count19,count20",TRUE )
        CALL cl_set_comp_visible("count21,count22,count23,count24,count25,count26,count27,count28,count29,count30",TRUE )
        CALL cl_set_comp_visible("count31,count32,count33,count34,count35,count36,count37,count38,count39,count40",TRUE )
        CALL cl_set_comp_visible("count41,count42,count43,count44,count45,count46,count47,count48,count49,count50",TRUE )
        CALL cl_set_comp_visible("count51,count52,count53,count54,count55,count56,count57,count58,count59,count60",TRUE )
        CALL cl_set_comp_visible("count61,count62,count63,count64,count65,count66,count67,count68,count69,count70",TRUE )
        CALL cl_set_comp_visible("count81,count82,count83,count84,count85,count86,count87",TRUE )
      WHEN 29
        CALL cl_set_comp_visible("count1,count2,count3,count4,count5,count6,count7,count8,count9,count10",FALSE )
        CALL cl_set_comp_visible("count11,count12,count13,count14,count15,count16,count17,count18,count19,count20",TRUE )
        CALL cl_set_comp_visible("count21,count22,count23,count24,count25,count26,count27,count28,count29,count30",TRUE )
        CALL cl_set_comp_visible("count31,count32,count33,count34,count35,count36,count37,count38,count39,count40",TRUE )
        CALL cl_set_comp_visible("count41,count42,count43,count44,count45,count46,count47,count48,count49,count50",TRUE )
        CALL cl_set_comp_visible("count51,count52,count53,count54,count55,count56,count57,count58,count59,count60",TRUE )
        CALL cl_set_comp_visible("count61,count62,count63,count64,count65,count66,count67,count68,count69,count70",TRUE )
        CALL cl_set_comp_visible("count81,count82,count83,count84,count85,count86,count87,count88,count89,count90",TRUE )
        CALL cl_set_comp_visible("count71,count72,count73,count74,count75,count76,count77,count78,count79,count80",TRUE )
      WHEN 30
        CALL cl_set_comp_visible("count1,count2,count3,count4,count5,count6,count7,count8,count9,count10",TRUE )
        CALL cl_set_comp_visible("count11,count12,count13,count14,count15,count16,count17,count18,count19,count20",TRUE )
        CALL cl_set_comp_visible("count21,count22,count23,count24,count25,count26,count27,count28,count29,count30",TRUE )
        CALL cl_set_comp_visible("count31,count32,count33,count34,count35,count36,count37,count38,count39,count40",TRUE )
        CALL cl_set_comp_visible("count41,count42,count43,count44,count45,count46,count47,count48,count49,count50",TRUE )
        CALL cl_set_comp_visible("count51,count52,count53,count54,count55,count56,count57,count58,count59,count60",TRUE )
        CALL cl_set_comp_visible("count61,count62,count63,count64,count65,count66,count67,count68,count69,count70",TRUE )
        CALL cl_set_comp_visible("count81,count82,count83,count84,count85,count86,count87,count88,count89,count90",TRUE )
        CALL cl_set_comp_visible("count71,count72,count73,count74,count75,count76,count77,count78,count79,count80",TRUE )
        CALL cl_set_comp_visible("count91,count92,count93",TRUE )
    END CASE 

    LET l_i = l_i+1
    LET l_string1 = "",tm.yy,"" 
    LET l_string1 = l_string1.trim()
    LET l_string2 = "",tm.mm,""
    LET l_string2 = l_string2.trim()
    LET l_string = l_string1 CLIPPED,"年" CLIPPED,l_string2 CLIPPED,"月" CLIPPED
    LET l_string = l_string.trim()
         FOR i = 1 TO l_i 
           LET l_string4 = "",i,""
           LET l_string4 = l_string4.trim()
           LET l_string1 = l_string CLIPPED ,l_string4 CLIPPED, "日-总单据数量" CLIPPED
           LET l_string2 = l_string CLIPPED ,l_string4 CLIPPED, "日-核准单据数量" CLIPPED
           LET l_string3 = l_string CLIPPED ,l_string4 CLIPPED, "日-过账单据数量" CLIPPED 
           LET l_string1 = l_string1.trim()
           LET l_string2 = l_string2.trim()
           LET l_string3 = l_string3.trim()
           CASE i
            WHEN 1
             CALL cl_set_comp_att_text("count1",l_string1)
             CALL cl_set_comp_att_text("count2",l_string2)
             CALL cl_set_comp_att_text("count3",l_string3)
            WHEN 2
             CALL cl_set_comp_att_text("count4",l_string1)
             CALL cl_set_comp_att_text("count5",l_string2)
             CALL cl_set_comp_att_text("count6",l_string3)
            WHEN 3
             CALL cl_set_comp_att_text("count7",l_string1)
             CALL cl_set_comp_att_text("count8",l_string2)
             CALL cl_set_comp_att_text("count9",l_string3)
            WHEN 4
             CALL cl_set_comp_att_text("count10",l_string1)
             CALL cl_set_comp_att_text("count11",l_string2)
             CALL cl_set_comp_att_text("count12",l_string3)
            WHEN 5
             CALL cl_set_comp_att_text("count13",l_string1)
             CALL cl_set_comp_att_text("count14",l_string2)
             CALL cl_set_comp_att_text("count15",l_string3)
            WHEN 6
             CALL cl_set_comp_att_text("count16",l_string1)
             CALL cl_set_comp_att_text("count17",l_string2)
             CALL cl_set_comp_att_text("count18",l_string3)
            WHEN 7
             CALL cl_set_comp_att_text("count19",l_string1)
             CALL cl_set_comp_att_text("count20",l_string2)
             CALL cl_set_comp_att_text("count21",l_string3)
            WHEN 8
             CALL cl_set_comp_att_text("count22",l_string1)
             CALL cl_set_comp_att_text("count23",l_string2)
             CALL cl_set_comp_att_text("count24",l_string3)
            WHEN 9
             CALL cl_set_comp_att_text("count25",l_string1)
             CALL cl_set_comp_att_text("count26",l_string2)
             CALL cl_set_comp_att_text("count27",l_string3)
            WHEN 10
             CALL cl_set_comp_att_text("count28",l_string1)
             CALL cl_set_comp_att_text("count29",l_string2)
             CALL cl_set_comp_att_text("count30",l_string3)
            WHEN 11
             CALL cl_set_comp_att_text("count31",l_string1)
             CALL cl_set_comp_att_text("count32",l_string2)
             CALL cl_set_comp_att_text("count33",l_string3)
            WHEN 12
             CALL cl_set_comp_att_text("count34",l_string1)
             CALL cl_set_comp_att_text("count35",l_string2)
             CALL cl_set_comp_att_text("count36",l_string3)
            WHEN 13
             CALL cl_set_comp_att_text("count37",l_string1)
             CALL cl_set_comp_att_text("count38",l_string2)
             CALL cl_set_comp_att_text("count39",l_string3)
            WHEN 14
             CALL cl_set_comp_att_text("count40",l_string1)
             CALL cl_set_comp_att_text("count41",l_string2)
             CALL cl_set_comp_att_text("count42",l_string3)
            WHEN 15
             CALL cl_set_comp_att_text("count43",l_string1)
             CALL cl_set_comp_att_text("count44",l_string2)
             CALL cl_set_comp_att_text("count45",l_string3)
            WHEN 16
             CALL cl_set_comp_att_text("count46",l_string1)
             CALL cl_set_comp_att_text("count47",l_string2)
             CALL cl_set_comp_att_text("count48",l_string3)
            WHEN 17
             CALL cl_set_comp_att_text("count49",l_string1)
             CALL cl_set_comp_att_text("count50",l_string2)
             CALL cl_set_comp_att_text("count51",l_string3)
            WHEN 18
             CALL cl_set_comp_att_text("count52",l_string1)
             CALL cl_set_comp_att_text("count53",l_string2)
             CALL cl_set_comp_att_text("count54",l_string3)
            WHEN 19
             CALL cl_set_comp_att_text("count55",l_string1)
             CALL cl_set_comp_att_text("count56",l_string2)
             CALL cl_set_comp_att_text("count57",l_string3)
            WHEN 20
             CALL cl_set_comp_att_text("count58",l_string1)
             CALL cl_set_comp_att_text("count59",l_string2)
             CALL cl_set_comp_att_text("count60",l_string3)
            WHEN 21
             CALL cl_set_comp_att_text("count61",l_string1)
             CALL cl_set_comp_att_text("count62",l_string2)
             CALL cl_set_comp_att_text("count63",l_string3)
            WHEN 22
             CALL cl_set_comp_att_text("count64",l_string1)
             CALL cl_set_comp_att_text("count65",l_string2)
             CALL cl_set_comp_att_text("count66",l_string3)
            WHEN 23
             CALL cl_set_comp_att_text("count67",l_string1)
             CALL cl_set_comp_att_text("count68",l_string2)
             CALL cl_set_comp_att_text("count69",l_string3)
            WHEN 24
             CALL cl_set_comp_att_text("count70",l_string1)
             CALL cl_set_comp_att_text("count71",l_string2)
             CALL cl_set_comp_att_text("count72",l_string3)
            WHEN 25
             CALL cl_set_comp_att_text("count73",l_string1)
             CALL cl_set_comp_att_text("count74",l_string2)
             CALL cl_set_comp_att_text("count75",l_string3)
            WHEN 26
             CALL cl_set_comp_att_text("count76",l_string1)
             CALL cl_set_comp_att_text("count77",l_string2)
             CALL cl_set_comp_att_text("count78",l_string3)
            WHEN 27
             CALL cl_set_comp_att_text("count79",l_string1)
             CALL cl_set_comp_att_text("count80",l_string2)
             CALL cl_set_comp_att_text("count81",l_string3)
            WHEN 28
             CALL cl_set_comp_att_text("count82",l_string1)
             CALL cl_set_comp_att_text("count83",l_string2)
             CALL cl_set_comp_att_text("count84",l_string3)
            WHEN 29
             CALL cl_set_comp_att_text("count85",l_string1)
             CALL cl_set_comp_att_text("count86",l_string2)
             CALL cl_set_comp_att_text("count87",l_string3)
            WHEN 30
             CALL cl_set_comp_att_text("count88",l_string1)
             CALL cl_set_comp_att_text("count89",l_string2)
             CALL cl_set_comp_att_text("count90",l_string3)
            WHEN 31
             CALL cl_set_comp_att_text("count91",l_string1)
             CALL cl_set_comp_att_text("count92",l_string2)
             CALL cl_set_comp_att_text("count93",l_string3)
           END CASE 
         END FOR 
END FUNCTION 

FUNCTION q001_set_unvisible()
   CALL cl_set_comp_visible("count1,count2,count3,count4,count5,count6,count7,count8,count9,count10",FALSE )
   CALL cl_set_comp_visible("count11,count12,count13,count14,count15,count16,count17,count18,count19,count20",FALSE )
   CALL cl_set_comp_visible("count21,count22,count23,count24,count25,count26,count27,count28,count29,count30",FALSE )
   CALL cl_set_comp_visible("count31,count32,count33,count34,count35,count36,count37,count38,count39,count40",FALSE )
   CALL cl_set_comp_visible("count41,count42,count43,count44,count45,count46,count47,count48,count49,count50",FALSE )
   CALL cl_set_comp_visible("count51,count52,count53,count54,count55,count56,count57,count58,count59,count60",FALSE )
   CALL cl_set_comp_visible("count61,count62,count63,count64,count65,count66,count67,count68,count69,count70",FALSE )
   CALL cl_set_comp_visible("count81,count82,count83,count84,count85,count86,count87,count88,count89,count90",FALSE )
   CALL cl_set_comp_visible("count71,count72,count73,count74,count75,count76,count77,count78,count79,count80",FALSE )
   CALL cl_set_comp_visible("count91,count92,count93",FALSE )
END FUNCTION 
