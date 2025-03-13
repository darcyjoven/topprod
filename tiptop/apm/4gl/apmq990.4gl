# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmq990
# Descriptions...: 出貨明細狀態查詢作業
# Date & Author..: 12/09/26 NO.FUN-C90100 By xianghui
# Modify.........: No.TQC-D50098 13/05/21 By fengrui g_filter_wc赋值为' 1=1'

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING, 
                 bdate  LIKE type_file.dat,
                 edate  LIKE type_file.dat,                 
                 a      LIKE type_file.chr1,
                 sty    LIKE type_file.chr1
              END RECORD       
   DEFINE g_sql           STRING                                                                                    
   DEFINE g_str           STRING    
   DEFINE g_filter_wc     STRING
   DEFINE g_rec_b         LIKE type_file.num10
   DEFINE g_cnt           LIKE type_file.num10                  
   DEFINE g_rvu          DYNAMIC ARRAY OF RECORD  
                rvu04a      LIKE rvu_file.rvu04,
                rvu05a      LIKE rvu_file.rvu05,
                pmc04a      LIKE pmc_file.pmc04,
                pmc081a     LIKE pmc_file.pmc081,
                pmc02a      LIKE pmc_file.pmc02,
                pmy02a      LIKE pmy_file.pmy02,
                rvu06a      LIKE rvu_file.rvu06,
                gem02a      LIKE gem_file.gem02,
                rvu07a      LIKE rvu_file.rvu07,
                gen02a      LIKE gen_file.gen02,
                tot_rvv87   LIKE rvv_file.rvv87,
                tot_rvv39   LIKE rvv_file.rvv39,
                tot_rvv39_t LIKE rvv_file.rvv39t,
                tot_rvv39t  LIKE rvv_file.rvv39t
                         END RECORD

    DEFINE g_rvv          DYNAMIC ARRAY OF RECORD  
                rvu04       LIKE rvu_file.rvu04,
                rvu05       LIKE rvu_file.rvu05,
                pmc04       LIKE pmc_file.pmc04,
                pmc081      LIKE pmc_file.pmc081,
                rvu03       LIKE rvu_file.rvu03,
                rvu01       LIKE rvu_file.rvu01,
                rvv02       LIKE rvv_file.rvv02,
                rvv31       LIKE rvv_file.rvv31,
                rvv031      LIKE rvv_file.rvv031,
                ima021      LIKE ima_file.ima021,
                pmm43       LIKE pmm_file.pmm43,
                rvv86       LIKE rvv_file.rvv86,
                rvv87       LIKE rvv_file.rvv87,
                rvv38_1     LIKE rvv_file.rvv38,
                rvv39_1     LIKE rvv_file.rvv39,
                rvv39_t_1   LIKE rvv_file.rvv39t,
                rvv39t_1    LIKE rvv_file.rvv39t,
                pmm22       LIKE pmm_file.pmm22,
                pmm42       LIKE pmm_file.pmm42,
                rvv36       LIKE rvv_file.rvv36,#str---add by huanglf160805
                pmm02       LIKE pmm_file.pmm02,#add by guanyao160907
                rvv38       LIKE rvv_file.rvv38,
                rvv38t      LIKE rvv_file.rvv38t,#str---add by huanglf160805
                rvv39       LIKE rvv_file.rvv39,
                rvv39_t_2   LIKE rvv_file.rvv39t,
                rvv39t      LIKE rvv_file.rvv39t,
                rvv39t_2    LIKE rvv_file.rvv39t,
                #xj---add---str---
                rvv23       LIKE rvv_file.rvv23,
                apb10       LIKE apb_file.apb10,
                apb24       LIKE apb_file.apb24,
                rvv87_rvv23 LIKE rvv_file.rvv87,
                rvv39_apb10 LIKE rvv_file.rvv39,
                rvv39_apb24 LIKE rvv_file.rvv39,
                #xj---add---end---    
                pmc02       LIKE pmc_file.pmc02,
                pmy02       LIKE pmy_file.pmy02,
                rvu06       LIKE rvu_file.rvu06,
                gem02       LIKE gem_file.gem02,
                rvu07       LIKE rvu_file.rvu07,
                gen02       LIKE gen_file.gen02,
                rvv25       LIKE rvv_file.rvv25,
                rvu99       LIKE rvu_file.rvu99,
                #tianry add 161128
                imaud07     LIKE ima_file.imaud07,
                imaud10     LIKE ima_file.imaud10,
                tc_ecn04    LIKE tc_ecn_file.tc_ecn04,
                tc_ecn05    LIKE tc_ecn_file.tc_ecn05,
                tc_ecn06    LIKE tc_ecn_file.tc_ecn06,
                tc_ecn07    LIKE tc_ecn_file.tc_ecn07,
                tc_ecnud06    LIKE tc_ecn_file.tc_ecnud06,
                #tc_ecn08    LIKE tc_ecn_file.tc_ecn08,    #tianry add  end 161128
                rvvud07     LIKE rvv_file.rvvud07,
                pml06       LIKE pml_file.pml06,       #tianry add 161201
                ecd02       LIKE ecd_file.ecd02,
                ta_sgm01    LIKE sgm_file.ta_sgm01,
                pnl         LIKE img_file.img10,  #tianry add 161206
                tc_ecn02   LIKE tc_ecn_file.tc_ecn02   #tianry add 161207
                         END RECORD
   DEFINE g_rvv_excel    DYNAMIC ARRAY OF RECORD
                rvu04       LIKE rvu_file.rvu04,
                rvu05       LIKE rvu_file.rvu05,
                pmc04       LIKE pmc_file.pmc04,
                pmc081      LIKE pmc_file.pmc081,
                rvu03       LIKE rvu_file.rvu03,
                rvu01       LIKE rvu_file.rvu01,
                rvv02       LIKE rvv_file.rvv02,
                rvv31       LIKE rvv_file.rvv31,
                rvv031      LIKE rvv_file.rvv031,
                ima021      LIKE ima_file.ima021,
                pmm43       LIKE pmm_file.pmm43,
                rvv86       LIKE rvv_file.rvv86,
                rvv87       LIKE rvv_file.rvv87,
                rvv38_1     LIKE rvv_file.rvv38,
                rvv39_1     LIKE rvv_file.rvv39,
                rvv39_t_1   LIKE rvv_file.rvv39t,
                rvv39t_1    LIKE rvv_file.rvv39t,
                pmm22       LIKE pmm_file.pmm22,
                pmm42       LIKE pmm_file.pmm42,
                rvv36       LIKE rvv_file.rvv36,#str---add by huanglf160805
                pmm02       LIKE pmm_file.pmm02,#add by guanyao160907
                rvv38       LIKE rvv_file.rvv38,
                rvv38t      LIKE rvv_file.rvv38t,#str---add by huanglf160805
                rvv39       LIKE rvv_file.rvv39,
                rvv39_t_2   LIKE rvv_file.rvv39t,
                rvv39t      LIKE rvv_file.rvv39t,
                rvv39t_2    LIKE rvv_file.rvv39t,
                #xj---add---str---
                rvv23       LIKE rvv_file.rvv23,
                apb10       LIKE apb_file.apb10,
                apb24       LIKE apb_file.apb24,
                rvv87_rvv23 LIKE rvv_file.rvv87,
                rvv39_apb10 LIKE rvv_file.rvv39,
                rvv39_apb24 LIKE rvv_file.rvv39,
                #xj---add---end---
                pmc02       LIKE pmc_file.pmc02,
                pmy02       LIKE pmy_file.pmy02,
                rvu06       LIKE rvu_file.rvu06,
                gem02       LIKE gem_file.gem02,
                rvu07       LIKE rvu_file.rvu07,
                gen02       LIKE gen_file.gen02,
                rvv25       LIKE rvv_file.rvv25,
                rvu99       LIKE rvu_file.rvu99,
                #tianry add 161128
                imaud07     LIKE ima_file.imaud07,
                imaud10     LIKE ima_file.imaud10,
                tc_ecn04    LIKE tc_ecn_file.tc_ecn04,
                tc_ecn05    LIKE tc_ecn_file.tc_ecn05,
                tc_ecn06    LIKE tc_ecn_file.tc_ecn06,
                tc_ecn07    LIKE tc_ecn_file.tc_ecn07,
                tc_ecnud06    LIKE tc_ecn_file.tc_ecnud06,
               # tc_ecn08    LIKE tc_ecn_file.tc_ecn08,    #tianry add  end 161128
                rvvud07     LIKE rvv_file.rvvud07,
                pml06       LIKE pml_file.pml06,       #tianry add 161201
                ecd02       LIKE ecd_file.ecd02,
                ta_sgm01    LIKE sgm_file.ta_sgm01,
                pnl         LIKE img_file.img10,
                tc_ecn02    LIKE tc_ecn_file.tc_ecn02   #tianry add 161207
                         END RECORD                         
   DEFINE g_sum_rvv87      LIKE rvv_file.rvv87,
          g_y_rvv39        LIKE rvv_file.rvv39,
          g_y_rvv39_t      LIKE rvv_file.rvv39t,
          g_y_rvv39t       LIKE rvv_file.rvv39t,
          g_b_rvv39        LIKE rvv_file.rvv39,
          g_b_rvv39_t      LIKE rvv_file.rvv39t,
          g_b_rvv39t       LIKE rvv_file.rvv39t
          
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10     
   DEFINE l_ac,l_ac1     LIKE type_file.num5
   DEFINE l_ac_t         LIKE type_file.num5
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100
   DEFINE l_table  STRING
   DEFINE   w    ui.Window      
   DEFINE   f    ui.Form       
   DEFINE   page om.DomNode 
     
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("apm")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q990_w AT 5,10
        WITH FORM "apm/42f/apmq990" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)

   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "rvu04.rvu_file.rvu04,     rvu05.rvu_file.rvu05,",
               "pmc04.pmc_file.pmc04,     pmc081.pmc_file.pmc081,",
               "rvu03.rvu_file.rvu03,     rvu01.rvu_file.rvu01,",
               "rvv02.rvv_file.rvv02,     rvv31.rvv_file.rvv31,",
               "rvv031.rvv_file.rvv031,   ima021.ima_file.ima021,",
               "rvv86.rvv_file.rvv86,     rvv87.rvv_file.rvv87,",
               "pmm22.pmm_file.pmm22,     pmm42.pmm_file.pmm42,",
               "rvv38.rvv_file.rvv38,     rvv39.rvv_file.rvv39,",
               "rvv39_t.rvv_file.rvv39t,  rvv39t.rvv_file.rvv39t, ",
               "rvv87_rvv23.rvv_file.rvv87,rvv39_apb10.rvv_file.rvv39"  
   LET l_table = cl_prt_temptable('apmq990',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN
      RETURN
   END IF                  # Temp Table產生
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ## 
   #darcy:2022/06/17 s---
   call cl_set_comp_visible(
      "tot_rvv39,tot_rvv39t,tot_rvv39_t,rvv39_1,rvv39_t_1,rvv39t_1,rvv38,rvv39,rvv39_t_2,rvv39t,rvv39t_2,rvv39_apb10,rvv39_apb24",
      FALSE
   )
   #darcy:2022/06/17 e---
   CALL q990_table()
   CALL q990_q()   
   CALL q990_menu()
   
   DROP TABLE apmq990_tmp;
   CLOSE WINDOW q990_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q990_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   

   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page2" THEN
            CALL q990_bp2()
         ELSE 
            CALL q990_bp("G")
         END IF
      END IF
      CASE g_action_choice
         WHEN "page1"
            CALL q990_bp("G")
         
         WHEN "page2"
            CALL q990_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q990_q()    
            END IF    
            LET g_action_choice = " "
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q990_filter_askkey()
               CALL q990()        #重填充新臨時表
               CALL q990_show()
            END IF            
            LET g_action_choice = " "
    
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q990()        #重填充新臨時表
               CALL q990_show() 
            END IF             
            LET g_action_choice = " "

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q990_cr()
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
         WHEN "exporttoexcel"     #匯出Excel
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_action_flag 
                  WHEN 'page1'
                     LET page = f.FindNode("Page","main")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvu),'','')
                  WHEN 'page2'
                     LET page = f.FindNode("Page","info")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvv_excel),'','')
               END CASE
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "rvu04"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q990_b_fill()
   #str-------add by guanyao160818
   #LET g_sql = "SELECT DISTINCT rvu04,rvu05,pmc04,pmc081,pmc02,pmy02,rvu06,gem02,rvu07,gen02,SUM(rvv87),SUM(rvv39_1),SUM(rvv39_t_1),SUM(rvv39t_1) ",
   #            "  FROM apmq990_tmp ",
   #            " GROUP BY rvu04,rvu05,pmc04,pmc081,pmc02,pmy02,rvu06,gem02,rvu07,gen02",
   #            " ORDER BY rvu04,rvu05"
   LET g_sql = "SELECT DISTINCT rvu04,rvu05,pmc04,pmc081,pmc02,pmy02,'','','','',SUM(rvv87),SUM(rvv39_1),SUM(rvv39_t_1),SUM(rvv39t_1) ",
               "  FROM apmq990_tmp ",
               " GROUP BY rvu04,rvu05,pmc04,pmc081,pmc02,pmy02",
               " ORDER BY rvu04,rvu05"
   #end-------add by guanyao160818
   PREPARE apmq990_pb FROM g_sql
   DECLARE rvu_curs  CURSOR FOR apmq990_pb        #CURSOR

   CALL g_rvu.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH rvu_curs INTO  g_rvu[g_cnt].*       #g_rvu_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      --SELECT SUM(rvv87),SUM(rvv39_1),SUM(rvv39_t_1),SUM(rvv39t_1)
        --INTO g_rvu[g_cnt].tot_rvv87,g_rvu[g_cnt].tot_rvv39,g_rvu[g_cnt].tot_rvv39_t,g_rvu[g_cnt].tot_rvv39t
        --FROM apmq990_tmp     
       --WHERE rvu04 = g_rvu[g_cnt].rvu04a
         --AND pmc04 = g_rvu[g_cnt].pmc04a
         --AND rvu06 = g_rvu[g_cnt].rvu06a
         --AND rvu07 = g_rvu[g_cnt].rvu07a
      LET g_cnt = g_cnt + 1
   END FOREACH
   SELECT SUM(rvv87),SUM(rvv39),SUM(rvv39_t_2),SUM(rvv39t),
          SUM(rvv39_1),SUM(rvv39_t_1),SUM(rvv39t_1)
     INTO g_sum_rvv87,g_y_rvv39,g_y_rvv39_t,g_y_rvv39t,g_b_rvv39,g_b_rvv39_t,g_b_rvv39t     
     FROM apmq990_tmp      
    WHERE rvv25 = 'N'
   CALL g_rvu.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION

FUNCTION q990_b_fill_2()

   CALL g_rvv.clear()
   LET g_cnt = 1
   CALL q990_get_sum()
     
END FUNCTION


FUNCTION q990_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND g_flag != '1' THEN
      CALL q990_b_fill()
   END IF
   
   LET g_flag = ' '
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.bdate,tm.edate,tm.a,tm.sty
   DISPLAY g_sum_rvv87 TO FORMONLY.sum_rvv87
   DISPLAY g_y_rvv39   TO FORMONLY.y_rvv39
   DISPLAY g_y_rvv39_t TO FORMONLY.y_rvv39_t
   DISPLAY g_y_rvv39t  TO FORMONLY.y_rvv39t
   DISPLAY g_b_rvv39   TO FORMONLY.b_rvv39
   DISPLAY g_b_rvv39_t TO FORMONLY.b_rvv39_t
   DISPLAY g_b_rvv39t  TO FORMONLY.b_rvv39t
   DISPLAY ARRAY g_rvu TO s_rvu.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF NOT cl_null(l_ac_t) AND l_ac_t > 0 THEN
            CALL fgl_set_arr_curr(l_ac_t)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION page2
         LET l_ac1 = ARR_CURR()
         LET l_ac_t = ARR_CURR()
         IF l_ac1 > 0  THEN
            #CALL q990_detail_fill(l_ac1)#mark by guanyao160907
            CALL q990_b_fill_1()         #add by guanyao160907
            CALL cl_set_comp_visible("page1", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1", TRUE)
            LET g_flag = '1'
         END IF
         LET g_action_choice = 'page2'
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY   
         
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         LET l_ac_t = ARR_CURR()
         IF NOT cl_null(l_ac1) AND l_ac1 > 0  THEN
            CALL q990_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page1", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1", TRUE)
            LET g_action_choice= "page2"  
            LET g_flag = '1'             
            EXIT DISPLAY
        END IF 

   
      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DISPLAY    

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DISPLAY

      ON ACTION output     
         LET g_action_choice ="output"     
         EXIT DISPLAY

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION CANCEL
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

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q990_bp2()
   
   LET g_action_flag = 'page2'
   IF g_action_choice = "page2" AND g_flag != '1' THEN
      CALL q990_b_fill_2()
   END IF
   LET g_action_choice = ' '
   LET g_flag = ' '
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_sum_rvv87 TO FORMONLY.sum_rvv87
   DISPLAY g_y_rvv39   TO FORMONLY.y_rvv39
   DISPLAY g_y_rvv39_t TO FORMONLY.y_rvv39_t
   DISPLAY g_y_rvv39t  TO FORMONLY.y_rvv39t
   DISPLAY g_b_rvv39   TO FORMONLY.b_rvv39
   DISPLAY g_b_rvv39_t TO FORMONLY.b_rvv39_t
   DISPLAY g_b_rvv39t  TO FORMONLY.b_rvv39t
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY     
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION output     
         LET g_action_choice ="output"    
         EXIT DISPLAY
      
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION CANCEL
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

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
    
FUNCTION q990_cs()
   DEFINE  l_cnt           LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     
   DEFINE  li_chk_bookno   LIKE type_file.num5
 
   CLEAR FORM   #清除畫面
   LET g_sum_rvv87 = ''
   LET g_y_rvv39   = ''
   LET g_y_rvv39_t = ''
   LET g_y_rvv39t  = ''
   LET g_b_rvv39   = ''
   LET g_b_rvv39_t = ''
   LET g_b_rvv39t  = ''
   CALL g_rvu.clear()
   CALL g_rvv.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   LET g_filter_wc =''
   LET tm.a = 'Y'   
   LET tm.sty ='1'
   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT tm.bdate,tm.edate,tm.sty,tm.a FROM bdate,edate,sty,a ATTRIBUTE(WITHOUT DEFAULTS)
        
         BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)    
      END INPUT

      CONSTRUCT tm.wc2 ON rvu04,pmc04,pmc02,rvu06,rvu07
                     FROM s_rvu[1].rvu04a,s_rvu[1].pmc04a,s_rvu[1].pmc02a,
                          s_rvu[1].rvu06a,s_rvu[1].rvu07a

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
      END CONSTRUCT

      ON ACTION controlp
         CASE
            WHEN INFIELD(rvu04a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_rvu04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu04a
               NEXT FIELD rvu04a
            WHEN INFIELD(pmc04a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc18"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc04a
               NEXT FIELD pmc04a
            WHEN INFIELD(pmc02a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc02a
               NEXT FIELD pmc02a
            WHEN INFIELD(rvu06a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_rvu06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu06a
               NEXT FIELD rvu06a
            WHEN INFIELD(rvu07a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu07a
               NEXT FIELD rvu07a
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
         ACCEPT DIALOG 

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG    
   END DIALOG                                                                                                                                                                     
   IF INT_FLAG THEN
      INITIALIZE tm.* TO NULL
      RETURN
   END IF

   CALL q990()   
END FUNCTION 

FUNCTION q990_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    LET l_ac_t = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q990_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q990_show()
END FUNCTION

FUNCTION q990_show()
   DISPLAY tm.bdate,tm.edate,tm.a,tm.sty TO bdate,edate,a,sty
   CALL q990_b_fill_2()
   CALL q990_b_fill()  
   LET g_action_choice = "page1"
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   LET g_action_flag = "page1"
   #CALL q990_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q990_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CONSTRUCT l_wc ON rvu04,pmc04,pmc02,rvu06,rvu07
                FROM s_rvu[1].rvu04a,s_rvu[1].pmc04a,s_rvu[1].pmc02a,
                     s_rvu[1].rvu06a,s_rvu[1].rvu07a

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(rvu04a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_rvu04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu04a
               NEXT FIELD rvu04a
            WHEN INFIELD(pmc04a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc18"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc04a
               NEXT FIELD pmc04a
            WHEN INFIELD(pmc02a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc02a
               NEXT FIELD pmc02a
            WHEN INFIELD(rvu06a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_rvu06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu06a
               NEXT FIELD rvu06a
            WHEN INFIELD(rvu07a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu07a
               NEXT FIELD rvu07a
         END CASE

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION ACCEPT
         ACCEPT CONSTRUCT

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT CONSTRUCT
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

FUNCTION q990_table()
#  DROP TABLE apmq990_tmp;
   CREATE TEMP TABLE apmq990_tmp(
                rvu04       LIKE rvu_file.rvu04,
                rvu05       LIKE rvu_file.rvu05,
                pmc04       LIKE pmc_file.pmc04,
                pmc081      LIKE pmc_file.pmc081,
                rvu03       LIKE rvu_file.rvu03,
                rvu01       LIKE rvu_file.rvu01,
                rvv02       LIKE rvv_file.rvv02,
                rvv31       LIKE rvv_file.rvv31,
                rvv031      LIKE rvv_file.rvv031,
                ima021      LIKE ima_file.ima021,
                pmm43       LIKE pmm_file.pmm43,
                rvv86       LIKE rvv_file.rvv86,
                rvv87       LIKE rvv_file.rvv87,
                rvv38_1     LIKE rvv_file.rvv38,
                rvv39_1     LIKE rvv_file.rvv39,
                rvv39_t_1   LIKE rvv_file.rvv39t,
                rvv39t_1    LIKE rvv_file.rvv39t,
                pmm22       LIKE pmm_file.pmm22,
                pmm42       LIKE pmm_file.pmm42,  #str---add by huanglf160805
                rvv36       LIKE rvv_file.rvv36,
                pmm02       LIKE pmm_file.pmm02,#add by guanyao160907
                rvv38       LIKE rvv_file.rvv38,
                rvv38t      LIKE rvv_file.rvv38t, #str---add by huanglf160805
                rvv39       LIKE rvv_file.rvv39,
                rvv39_t_2   LIKE rvv_file.rvv39t,
                rvv39t      LIKE rvv_file.rvv39t,
                rvv39t_2    LIKE rvv_file.rvv39t,
                rvv23       LIKE rvv_file.rvv23,
                apb10       LIKE apb_file.apb10,
                apb24       LIKE apb_file.apb24,
                rvv87_rvv23 LIKE rvv_file.rvv87,
                rvv39_apb10 LIKE rvv_file.rvv39,
                rvv39_apb24 LIKE rvv_file.rvv39,
                pmc02       LIKE pmc_file.pmc02,
                pmy02       LIKE pmy_file.pmy02,
                rvu06       LIKE rvu_file.rvu06,
                gem02       LIKE gem_file.gem02,
                rvu07       LIKE rvu_file.rvu07,
                gen02       LIKE gen_file.gen02,
                rvv25       LIKE rvv_file.rvv25,
                rvu99       LIKE rvu_file.rvu99,
                imaud07     LIKE ima_file.imaud07,             #tianry add 161128
                imaud10     LIKE ima_file.imaud10,
                tc_ecn04    LIKE tc_ecn_file.tc_ecn04,
                tc_ecn05    LIKE tc_ecn_file.tc_ecn05,
                tc_ecn06    LIKE tc_ecn_file.tc_ecn06,
                tc_ecn07    LIKE tc_ecn_file.tc_ecn07,
                tc_ecnud06    LIKE tc_ecn_file.tc_ecnud06,
                rvvud07     LIKE rvv_file.rvvud07,
                pml06       LIKE pml_file.pml06,       #tianry add 161201
                ecd02       LIKE ecd_file.ecd02,
                ta_sgm01    LIKE sgm_file.ta_sgm01,
                pnl         LIKE img_file.img10,
                tc_ecn02    LIKE tc_ecn_file.tc_ecn02)
END FUNCTION 

FUNCTION q990()
DEFINE l_sql      STRING
DEFINE l_sql1     STRING                
DEFINE l_wc       STRING
 
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
   IF cl_null(g_filter_wc) THEN LET g_filter_wc =' 1=1' END IF  #TQC-D50098 

   DELETE FROM apmq990_tmp

   IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
      LET l_wc = "rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
   END IF
   IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
      LET l_wc = "rvu03 <= '",tm.edate,"'"
   END IF
   IF NOT cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
      LET l_wc = "rvu03 >= '",tm.bdate,"'"
   END IF
   IF cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
      LET l_wc = " 1=1 "
   END IF
 
   LET l_sql1= "SELECT DISTINCT rvu04,rvu05,pmc04,pmc081,rvu03,rvu01,",
               "       rvv02,rvv31,rvv031,ima021,'' pmm43,rvv86,rvv87,",
               "       '' rvv38_1,'' rvv39_1,'' rvv39_t_1,'' rvv39t_1,",
               "       '' pmm22,'' pmm42,rvv36,pmm02,rvv38,rvv38t,rvv39,rvv39t-rvv39 rvv39_t_2,rvv39t,'' rvv39t_2,",  #add pmm02 by guanyao160907
               "       rvv23,'' apb10,'' apb24,rvv87-rvv23 rvv87_rvv23,'' rvv39_apb10,'' rvv39_apb24,",                          
               "       pmc02,'' pmy02,rvu06,gem02,rvu07,gen02,rvv25,rvu99,imaud07,imaud10,0 tc_ecn04,0 tc_ecn05,0 tc_ecn06,0 tc_ecn07,0 tc_ecnud06,rvvud07,'' pml06,'' ecd02,'' ta_sgm01,'' pnl,'' tc_ecn02 ", #add by huanglf161207 #tianry add 161128
               "  FROM rvu_file LEFT OUTER JOIN pmc_file ON pmc01 = rvu04 ",
               "                LEFT OUTER JOIN gem_file ON gem01 = rvu06 ",
               "                LEFT OUTER JOIN gen_file ON gen01 = rvu07,", 
               "       rvv_file LEFT OUTER JOIN ima_file ON ima01 = rvv31 ",
               "                LEFT OUTER JOIN pmm_file ON pmm01 = rvv36",  #add by guanyao160907
               " WHERE rvu01 = rvv01 ",
               "   AND ",l_wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND ",g_filter_wc CLIPPED,
               "   AND rvu00 <>'2' AND rvuconf<>'X' AND rvu17<>'9' " 
               
   LET l_sql = " INSERT INTO apmq990_tmp ",
               "   SELECT x.* FROM (",l_sql1 CLIPPED,") x"
   PREPARE insert_prep FROM l_sql
   EXECUTE insert_prep 

   LET l_sql = " UPDATE apmq990_tmp o",
               "    SET o.pmy02 = (SELECT a.pmy02 FROM pmy_file a WHERE a.pmy01 = o.pmc02) ",
               "  WHERE EXISTS(SELECT * FROM pmy_file a WHERE a.pmy01 = o.pmc02)"
   PREPARE q990_pre1 FROM l_sql
   EXECUTE q990_pre1

   LET l_sql = " MERGE INTO apmq990_tmp o ",
               "      USING (SELECT rvv01,rvv02,pmm22",
               "               FROM pmm_file,rvv_file ",
               "              WHERE rvv36 = pmm01) m ",
               "         ON (o.rvu01 = m.rvv01 AND o.rvv02 = m.rvv02) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.pmm22 = m.pmm22"
   PREPARE q990_pre3 FROM l_sql
   EXECUTE q990_pre3 
   
   LET l_sql = "    UPDATE apmq990_tmp o",
               "       SET o.pmm22 = (SELECT l.rvu113 FROM rvu_file l WHERE l.rvu01 =o.rvu01) ",
               "     WHERE (SELECT COUNT(*) FROM pmm_file n,rvv_file m ",
               "                       WHERE m.rvv36 = n.pmm01 AND o.rvu01 = m.rvv01 ",
               "                         AND o.rvv02 = m.rvv02 AND n.pmm22 IS NULL ",
               "                        HAVING COUNT(*) > 0) "
   PREPARE q990_pre31 FROM l_sql
   EXECUTE q990_pre31
   

   LET l_sql = " MERGE INTO apmq990_tmp o ",
               "      USING (SELECT rvv01,rvv02,pmm42",
               "               FROM pmm_file,rvv_file ",
               "              WHERE rvv36 = pmm01) m ",
               "         ON (o.rvu01 = m.rvv01 AND o.rvv02 = m.rvv02) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.pmm42 = m.pmm42"
   PREPARE q990_pre4 FROM l_sql
   EXECUTE q990_pre4 
   
   LET l_sql = "    UPDATE apmq990_tmp o",
               "       SET o.pmm42 = (SELECT l.rvu114 FROM rvu_file l WHERE l.rvu01 =o.rvu01) ",
               "     WHERE EXISTS(SELECT COUNT(*) FROM pmm_file n,rvv_file m ",
               "                       WHERE m.rvv36 = n.pmm01 AND o.rvu01 = m.rvv01 ",
               "                         AND o.rvv02 = m.rvv02 AND n.pmm42 IS NULL ",
               "                        HAVING COUNT(*) > 0) "
   PREPARE q990_pre41 FROM l_sql
   EXECUTE q990_pre41
   
   LET l_sql = " MERGE INTO apmq990_tmp o ",
               "      USING (SELECT rvv01,rvv02,pmm43",
               "               FROM pmm_file,rvv_file ",
               "              WHERE rvv36 = pmm01) m ",
               "         ON (o.rvu01 = m.rvv01 AND o.rvv02 = m.rvv02) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.pmm43 = m.pmm43"
   PREPARE q990_pre5 FROM l_sql
   EXECUTE q990_pre5 
   
   LET l_sql = "    UPDATE apmq990_tmp o",
               "       SET o.pmm43 = (SELECT l.rvu12 FROM rvu_file l WHERE l.rvu01 =o.rvu01) ",
               "     WHERE EXISTS(SELECT COUNT(*) FROM pmm_file n,rvv_file m ",
               "                       WHERE m.rvv36 = n.pmm01 AND o.rvu01 = m.rvv01 ",
               "                         AND o.rvv02 = m.rvv02 AND n.pmm43 IS NULL ",
               "                        HAVING COUNT(*) > 0) "
   PREPARE q990_pre51 FROM l_sql
   EXECUTE q990_pre51 
      
   LET l_sql = " UPDATE apmq990_tmp ",
               "    SET rvv38_1 = rvv38 * pmm42,",
               "        rvv39_1 = rvv39 * pmm42,",
               "        rvv39t_1= rvv39t * pmm42,",
               "        rvv39t_2= rvv39t * pmm42"
   PREPARE q990_pre6 FROM l_sql
   EXECUTE q990_pre6
   
   LET l_sql = " UPDATE apmq990_tmp ",
               "    SET rvv39_t_1 = rvv39t_1- rvv39_1"
   PREPARE q990_pre7 FROM l_sql
   EXECUTE q990_pre7   

   LET l_sql = " MERGE INTO apmq990_tmp o ",
               "      USING (SELECT rvu00,rvu01 ",
               "               FROM rvu_file ",
               "              WHERE   rvu00 ='3') n",
               "         ON (o.rvu01 = n.rvu01) ",      
               " WHEN MATCHED ",
               " THEN ",
               " UPDATE ",
               " SET rvv87 = rvv87 * (-1),",
               "    rvv38_1 = rvv38_1 * (-1),",
               "    rvv39_1 = rvv39_1 * (-1),",
               "    rvv39_t_1 = rvv39_t_1 * (-1),",
               "    rvv39t_1 = rvv39t_1 * (-1),",
               "    rvv38 = rvv38 * (-1),",
               "    rvv39 = rvv39 * (-1),",
               "    rvv39_t_2 = rvv39_t_2 * (-1),",
               "    rvv39t = rvv39t * (-1),",
               "    rvv39t_2 = rvv39t_2 * (-1),",
               "    rvv23  = rvv23 * (-1),",
               "    rvv87_rvv23 = rvv87_rvv23 * (-1)"
   PREPARE q990_pre8 FROM l_sql
   EXECUTE q990_pre8                    

   LET l_sql = " MERGE INTO apmq990_tmp o ",
               "      USING (SELECT apb21,apb22,SUM(apb10) apb10_sum,SUM(apb24) apb24_sum ",
               "               FROM apb_file,apa_file ",
               "              WHERE apa01 = apb01 ",
               "                AND apa00 NOT IN('16','26') ",
               "              GROUP BY apb21,apb22) n ",
               "         ON (o.rvu01 = n.apb21 AND o.rvv02 = n.apb22) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.apb10 = NVL(n.apb10_sum,0),",
               "           o.apb24 = NVL(n.apb24_sum,0) "
   PREPARE q990_pre9 FROM l_sql
   EXECUTE q990_pre9               


   LET l_sql = " UPDATE apmq990_tmp  ",
               "    SET apb10 = 0 ",
               "  WHERE apb10 IS NULL "
   PREPARE q990_pre91 FROM l_sql
   EXECUTE q990_pre91  

   LET l_sql = " UPDATE apmq990_tmp  ",
               "    SET apb24 = 0 ",
               "  WHERE apb24 IS NULL "
   PREPARE q990_pre92 FROM l_sql
   EXECUTE q990_pre92 
   
   LET l_sql = " UPDATE apmq990_tmp ",
               "    SET rvv39_apb10 = rvv39_1 - apb10,",
               "        rvv39_apb24 = rvv39   - apb24"
   PREPARE q990_pre10 FROM l_sql
   EXECUTE q990_pre10      

   LET l_sql = " MERGE INTO apmq990_tmp o ",
               "      USING (SELECT pmc01,pmc082 ",
               "               FROM pmc_file ) n",
               "         ON (o.rvu04 = n.pmc01) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.pmc081 = (o.pmc081||n.pmc082) "
   PREPARE q990_pre11 FROM l_sql
   EXECUTE q990_pre11 

   LET l_sql = " UPDATE apmq990_tmp ",
               "    SET rvu01 = ('*'||rvu01)",
               "  WHERE rvv25='Y' "
   PREPARE q990_pre12 FROM l_sql
   EXECUTE q990_pre12    

END FUNCTION 

FUNCTION q990_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING
   DEFINE  l_tc_ecn02  LIKE tc_ecn_file.tc_ecn02    #tianry add 161128 
   DEFINE  l_pmn78     LIKE pmn_file.pmn78 
   DEFINE l_pmn18      LIKE pmn_file.pmn18
   DEFINE  l_old       LIKE pmn_file.pmn78   #add by liyjf181224 
   DEFINE  l_old1       LIKE pmn_file.pmn18   #add by liyjf181224 
   
   LET l_old = ''  #add by liyjf181224 
   LET l_old1 = ''  #add by liyjf181224 
   LET l_sql = "SELECT * FROM apmq990_tmp ORDER BY rvu04,rvu05,rvu03 "
   PREPARE q990_pb FROM l_sql
   DECLARE q990_curs1 CURSOR FOR q990_pb
   FOREACH q990_curs1 INTO g_rvv_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #tianry add 161128
      IF NOT cl_null(g_rvv_excel[g_cnt].rvv02) AND NOT cl_null(g_rvv_excel[g_cnt].rvu01) THEN  #add by liyjf181224  
         SELECT pmn78,pmn18 INTO l_pmn78,l_pmn18 FROM pmn_fiLe,rvv_file  WHERE pmn01=rvv36 AND rvv01=g_rvv_excel[g_cnt].rvu01 
         AND rvv02=g_rvv_excel[g_cnt].rvv02 AND pmn02=rvv37

      END IF   #add by liyjf181224 
#str----add by huanglf161207
      IF NOT cl_null(l_pmn78) THEN
       #add by liyjf181224 str
      IF NOT cl_null(l_old) AND l_old = l_pmn78 THEN 
         LET g_rvv_excel[g_cnt].tc_ecn04 = g_rvv_excel[g_cnt-1].tc_ecn04 
         LET g_rvv_excel[g_cnt].tc_ecn05 = g_rvv_excel[g_cnt-1].tc_ecn05
         LET g_rvv_excel[g_cnt].tc_ecn06 = g_rvv_excel[g_cnt-1].tc_ecn06
         LET g_rvv_excel[g_cnt].tc_ecn07 = g_rvv_excel[g_cnt-1].tc_ecn07
         LET g_rvv_excel[g_cnt].tc_ecnud06 = g_rvv_excel[g_cnt-1].tc_ecnud06 
         LET g_rvv_excel[g_cnt].tc_ecn02  = g_rvv_excel[g_cnt-1].tc_ecn02
       ELSE
       #add by liyjf181224 end
         SELECT tc_ecn04,tc_ecn05,tc_ecn06,tc_ecn07,tc_ecnud06,tc_ecn08,tc_ecn02
         INTO g_rvv_excel[g_cnt].tc_ecn04,g_rvv_excel[g_cnt].tc_ecn05,g_rvv_excel[g_cnt].tc_ecn06,g_rvv_excel[g_cnt].tc_ecn07,
         g_rvv_excel[g_cnt].tc_ecnud06,g_rvv_excel[g_cnt].tc_ecn02
         FROM tc_ecn_file
         WHERE tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78
      #   AND tc_ecn09 = (SELECT MAX(tc_ecn09) FROM tc_ecn_file
      #                   WHERE tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 )
          SELECT ecd02 INTO g_rvv_excel[g_cnt].ecd02 FROM ecd_file WHERE ecd01=l_pmn78  #add by liyjf181224  优化程序提高运行速度
      END IF #add by liyjf181224
      END IF 
#str-----end by huanglf161207      
    #  SELECT ecd02 INTO g_rvv_excel[g_cnt].ecd02 FROM ecd_file WHERE ecd01=l_pmn78  #mark by liyjf181224 
       #add by liyjf181224  str
     IF NOT cl_null(l_pmn78) AND NOT cl_null(l_pmn18) THEN 
     IF NOT cl_null(l_old) AND NOT cl_null(l_old1) AND l_old = l_pmn78 AND l_old1 = l_pmn18 THEN
        LET g_rvv_excel[g_cnt].ta_sgm01 = g_rvv_excel[g_cnt-1].ta_sgm01
     ELSE  
     #add by liyjf181224 end
        SELECT ta_sgm01 INTO  g_rvv_excel[g_cnt].ta_sgm01 FROM sgm_file WHERE sgm01=l_pmn18 AND  sgm04=l_pmn78 AND ROWNUM=1
     END IF   #add by liyjf181224 
     END IF   #add by liyjf181224 
      
     IF NOT cl_null(g_rvv_excel[g_cnt].rvv02) AND NOT cl_null(g_rvv_excel[g_cnt].rvv31) THEN  #add by liyjf181224 
        SELECT  pml06 INTO g_rvv_excel[g_cnt].pml06 FROM pml_file,pmn_file,rvv_file WHERE rvv01=g_rvv_excel[g_cnt].rvu01
        AND rvv02=g_rvv_excel[g_cnt].rvv02 AND pmn01=rvv36 AND pmn02=rvv37 AND pml04=g_rvv_excel[g_cnt].rvv31 
        AND pml01=pmn24 AND pml02=pmn25  AND ROWNUM=1 
     END IF   #add by liyjf181224 
      #tianry add end 161128
      #tianry add 161206
      IF NOT cl_null(g_rvv_excel[g_cnt].imaud10) AND g_rvv_excel[g_cnt].imaud10!=0 THEN 
         LET g_rvv_excel[g_cnt].pnl=g_rvv_excel[g_cnt].rvv87/g_rvv_excel[g_cnt].imaud10
      END IF 
      #tianry add end

     
  #    IF g_cnt <= g_max_rec THEN    #mark by huanglf160928
         LET g_rvv[g_cnt].* = g_rvv_excel[g_cnt].*
   #   END IF
      LET l_old = l_pmn78  #add by liyjf181224 
      LET g_cnt = g_cnt + 1
   END FOREACH
   
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
   
  # IF g_cnt <= g_max_rec THEN
      CALL g_rvv.deleteElement(g_cnt)
  # END IF   #mark by huanglf160928
   CALL g_rvv_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
#str-----mark by huanglf160928
  # IF g_rec_b > g_max_rec THEN
    #  CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
     # LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
  # END IF
#str-----mark by huanglf160928
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION  

FUNCTION q990_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,
          l_oga24      LIKE oga_file.oga24,
          l_type       LIKE type_file.chr1,
          l_sql        STRING
#str----add by huanglf161208
   DEFINE l_pmn78      LIKE pmn_file.pmn78
   DEFINE l_pmn18      LIKE pmn_file.pmn18
#str----end by huanglf161208          
   LET l_sql = "SELECT * FROM apmq990_tmp ",
               " WHERE rvu04 = '",g_rvu[p_ac].rvu04a,"'",
               "   AND pmc04 = '",g_rvu[p_ac].pmc04a,"'",
               #"   AND rvu06 = '",g_rvu[p_ac].rvu06a,"'",   #mark by guanyao160818
               #"   AND rvu07 = '",g_rvu[p_ac].rvu07a,"'",   #mark by guanyao160818
               " ORDER BY rvu04,rvu05,rvu03"
   PREPARE apmq990_pb_detail FROM l_sql
   DECLARE rvv_curs_detail  CURSOR FOR apmq990_pb_detail        #CURSOR
   CALL g_rvv.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH rvv_curs_detail INTO g_rvv_excel[g_cnt].*                       
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#str----add by huanglf161208
      SELECT pmn78,pmn18 INTO l_pmn78,l_pmn18 FROM pmn_fiLe,rvv_file  WHERE pmn01=rvv36 AND rvv01=g_rvv_excel[g_cnt].rvu01
      AND rvv02=g_rvv_excel[g_cnt].rvv02 AND pmn02=rvv37

#str----add by huanglf161207
      IF NOT cl_null(l_pmn78) THEN
         SELECT tc_ecn04,tc_ecn05,tc_ecn06,tc_ecn07,tc_ecnud06,tc_ecn02
         INTO g_rvv_excel[g_cnt].tc_ecn04,g_rvv_excel[g_cnt].tc_ecn05,g_rvv_excel[g_cnt].tc_ecn06,g_rvv_excel[g_cnt].tc_ecn07,
         g_rvv_excel[g_cnt].tc_ecnud06,g_rvv_excel[g_cnt].tc_ecn02
         FROM tc_ecn_file
         WHERE tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 
               AND tc_ecn09 = (SELECT MAX(tc_ecn09) FROM tc_ecn_file 
                               WHERE  tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 )
      #   AND tc_ecn09 = (SELECT MAX(tc_ecn09) FROM tc_ecn_file
      #                   WHERE tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 )

      END IF 
#str-----end by huanglf161207   
      SELECT ecd02 INTO g_rvv_excel[g_cnt].ecd02 FROM ecd_file WHERE ecd01=l_pmn78

      SELECT ta_sgm01 INTO  g_rvv_excel[g_cnt].ta_sgm01 FROM sgm_file WHERE sgm01=l_pmn18 AND  sgm04=l_pmn78 AND ROWNUM=1
      #tianry add 161222
      IF cl_null(g_rvv_excel[g_cnt].ta_sgm01) THEN 
         SELECT DISTINCT ecbud02 INTO g_rvv_excel[g_cnt].ta_sgm01 FROM ecb_file
         WHERE ecb01=g_rvv_excel[g_cnt].rvv31 AND ecb06=l_pmn78
      END IF 
      #tianry add end 161222
      SELECT  pml06 INTO g_rvv_excel[g_cnt].pml06 FROM pml_file,pmn_file,rvv_file WHERE rvv01=g_rvv_excel[g_cnt].rvu01
      AND rvv02=g_rvv_excel[g_cnt].rvv02 AND pmn01=rvv36 AND pmn02=rvv37 AND pml04=g_rvv_excel[g_cnt].rvv31
      AND pml01=pmn24 AND pml02=pmn25  AND ROWNUM=1

      #tianry add 161206
      IF NOT cl_null(g_rvv_excel[g_cnt].imaud10) AND g_rvv_excel[g_cnt].imaud10!=0 THEN 
         LET g_rvv_excel[g_cnt].pnl=g_rvv_excel[g_cnt].rvv87/g_rvv_excel[g_cnt].imaud10
      END IF 
      #tianry add end


#str----end by huanglf161208
    #  IF g_cnt < = g_max_rec THEN
         LET g_rvv[g_cnt].* = g_rvv_excel[g_cnt].*
     # END IF   #mark by huanglf160928
      LET g_cnt = g_cnt + 1
   END FOREACH
   #IF g_cnt <= g_max_rec THEN
      CALL g_rvv.deleteElement(g_cnt)
   #END IF  #mark by huanglf160928
   CALL g_rvv_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 #  IF g_rec_b > g_max_rec THEN
  #    CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
  #    LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
  # END IF   #mark by huanglf160928
   SELECT SUM(rvv87),SUM(rvv39),SUM(rvv39_t_2),SUM(rvv39t),
          SUM(rvv39_1),SUM(rvv39_t_1),SUM(rvv39t_1)
     INTO g_sum_rvv87,g_y_rvv39,g_y_rvv39_t,g_y_rvv39t,g_b_rvv39,g_b_rvv39_t,g_b_rvv39t
     FROM apmq990_tmp
    WHERE rvv25 = 'N'
      AND rvu04 = g_rvu[p_ac].rvu04a
      AND pmc04 = g_rvu[p_ac].pmc04a
      #AND rvu06 = g_rvu[p_ac].rvu06a   #mark by guanyao160818
      #AND rvu07 = g_rvu[p_ac].rvu07a   #mark by guanyao160818
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION

FUNCTION q990_set_visible()
   DEFINE l_wc     LIKE type_file.chr20
   CALL cl_set_comp_visible("rvv38_1,rvv39_1,rvv39_t_1,rvv39t_1,pmm22,pmm42,
                             rvv38,rvv39,rvv39_t_2,rvv39t,rvv39t_2",TRUE)
   CALL cl_set_comp_visible("apb10,apb24,rvv39_apb10,rvv39_apb24",TRUE)  
   IF tm.a = 'Y' THEN 
      CALL cl_set_comp_visible("rvv38_1,rvv39_1,rvv39_t_1,rvv39t_1",FALSE)
      CALL cl_set_comp_visible("y_rvv39,y_rvv39_t,y_rvv39t",TRUE)
      CALL cl_set_comp_visible("apb24,rvv39_apb24",TRUE)       
      CALL cl_set_comp_visible("apb10,rvv39_apb10",FALSE)     
   ELSE
      CALL cl_set_comp_visible("pmm22,pmm42,rvv38,rvv39,rvv39_t_2,rvv39t,rvv39t_2",FALSE)
      CALL cl_set_comp_visible("y_rvv39,y_rvv39_t,y_rvv39t",FALSE)
      CALL cl_set_comp_visible("apb24,rvv39_apb24",FALSE)    
      CALL cl_set_comp_visible("apb10,rvv39_apb10",TRUE)       
   END IF
END FUNCTION 

FUNCTION q990_cr()    
DEFINE l_sql    STRING

   CALL cl_wait()    
   CALL cl_del_data(l_table)

   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT z.* FROM (SELECT DISTINCT rvu04,rvu05,pmc04,",
               "                  pmc081,rvu03,rvu01,rvv02,rvv31,rvv031,ima021,",
               "                  rvv86,rvv87,pmm22,pmm42,rvv38,rvv39,",
               "                  rvv39_t_2,rvv39t,0 rvv87_rvv23,0 rvv39_apb10 ",               
               "                  FROM apmq990_tmp ) z"
   PREPARE apmq990_prepare1 FROM l_sql
   EXECUTE apmq990_prepare1

   LET l_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o",
               "    SET o.rvv39_apb10 = o.rvv39 * o.pmm42 - ",
               "      NVL((SELECT SUM(apb10) apb10_sum ",
               "               FROM apb_file,apa_file ",
               "              WHERE apa01 = apb01 AND o.rvu01 = apb21 AND  o.rvv02 = apb22 ",
               "                AND apa00 NOT IN('16','26')),0) ",
               " WHERE EXISTS (SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," x ",
               "              WHERE o.rvu01 = x.rvu01 AND o.rvv02 = x.rvv02)"
   PREPARE apmq990_pre1 FROM l_sql
   EXECUTE apmq990_pre1

   LET l_sql = " MERGE INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," o",
               "      USING (SELECT rvv01,rvv02,rvv23 ",
               "               FROM rvv_file ) n ",
               "         ON (o.rvu01 = n.rvv01 AND o.rvv02 = n.rvv02) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.rvv87_rvv23 = o.rvv87 - NVL(n.rvv23,0)"
   PREPARE apmq990_pre2 FROM l_sql
   EXECUTE apmq990_pre2   

  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.bdate,";",tm.edate,";",tm.sty,";",g_sma.sma115,";",g_sma.sma116
   CALL cl_prt_cs3('apmq990','apmq990',g_sql,g_str)
   #------------------------------ CR (4) ------------------------------#               
END FUNCTION
#FUN-C90100

#str----add by guanyao160907
FUNCTION q990_b_fill_1()
   DEFINE p_ac         LIKE type_file.num5,
          l_oga24      LIKE oga_file.oga24,
          l_type       LIKE type_file.chr1,
          l_sql        STRING
  DEFINE  l_pmn78      LIKE pmn_file.pmn78,
          l_pmn18      LIKE pmn_file.pmn18
          
   LET l_sql = "SELECT * FROM apmq990_tmp ",
               " ORDER BY rvu04,rvu05,rvu03"
   PREPARE apmq990_pb_detail_1 FROM l_sql
   DECLARE rvv_curs_detail_1  CURSOR FOR apmq990_pb_detail_1        #CURSOR
   CALL g_rvv.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH rvv_curs_detail_1 INTO g_rvv_excel[g_cnt].*                       
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT pmn78,pmn18 INTO l_pmn78,l_pmn18 FROM pmn_fiLe,rvv_file  WHERE pmn01=rvv36 AND rvv01=g_rvv_excel[g_cnt].rvu01
      AND rvv02=g_rvv_excel[g_cnt].rvv02 AND pmn02=rvv37

#str----add by huanglf161207
      IF NOT cl_null(l_pmn78) THEN
         SELECT tc_ecn04,tc_ecn05,tc_ecn06,tc_ecn07,tc_ecnud06,tc_ecn02
         INTO g_rvv_excel[g_cnt].tc_ecn04,g_rvv_excel[g_cnt].tc_ecn05,g_rvv_excel[g_cnt].tc_ecn06,g_rvv_excel[g_cnt].tc_ecn07,
         g_rvv_excel[g_cnt].tc_ecnud06,g_rvv_excel[g_cnt].tc_ecn02
         FROM tc_ecn_file
         WHERE tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 
               AND tc_ecn09 = (SELECT MAX(tc_ecn09) FROM tc_ecn_file 
                               WHERE  tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 )
      #   AND tc_ecn09 = (SELECT MAX(tc_ecn09) FROM tc_ecn_file
      #                   WHERE tc_ecn01 = g_rvv_excel[g_cnt].rvv31 AND tc_ecn02 = l_pmn78 )

      END IF 
#str-----end by huanglf161207   
      SELECT ecd02 INTO g_rvv_excel[g_cnt].ecd02 FROM ecd_file WHERE ecd01=l_pmn78

      SELECT ta_sgm01 INTO  g_rvv_excel[g_cnt].ta_sgm01 FROM sgm_file WHERE sgm01=l_pmn18 AND  sgm04=l_pmn78 AND ROWNUM=1
      #tianry add 161222
      IF cl_null(g_rvv_excel[g_cnt].ta_sgm01) THEN
         SELECT DISTINCT ecbud02 INTO g_rvv_excel[g_cnt].ta_sgm01 FROM ecb_file
         WHERE ecb01=g_rvv_excel[g_cnt].rvv31 AND ecb06=l_pmn78
      END IF
      #tianry add end 161222
      SELECT  pml06 INTO g_rvv_excel[g_cnt].pml06 FROM pml_file,pmn_file,rvv_file WHERE rvv01=g_rvv_excel[g_cnt].rvu01
      AND rvv02=g_rvv_excel[g_cnt].rvv02 AND pmn01=rvv36 AND pmn02=rvv37 AND pml04=g_rvv_excel[g_cnt].rvv31
      AND pml01=pmn24 AND pml02=pmn25  AND ROWNUM=1

      #tianry add 161206
      IF NOT cl_null(g_rvv_excel[g_cnt].imaud10) AND g_rvv_excel[g_cnt].imaud10!=0 THEN 
         LET g_rvv_excel[g_cnt].pnl=g_rvv_excel[g_cnt].rvv87/g_rvv_excel[g_cnt].imaud10
      END IF 
      #tianry add end

    #  IF g_cnt < = g_max_rec THEN
         LET g_rvv[g_cnt].* = g_rvv_excel[g_cnt].*
     # END IF    #mark by huanglf160928
      LET g_cnt = g_cnt + 1
   END FOREACH
  # IF g_cnt <= g_max_rec THEN
      CALL g_rvv.deleteElement(g_cnt)
   #END IF  #mark by huanglf160928
   CALL g_rvv_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   #IF g_rec_b > g_max_rec THEN
    #  CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
     # LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   #END IF   #mark by huanglf160928
   SELECT SUM(rvv87),SUM(rvv39),SUM(rvv39_t_2),SUM(rvv39t),
          SUM(rvv39_1),SUM(rvv39_t_1),SUM(rvv39t_1)
     INTO g_sum_rvv87,g_y_rvv39,g_y_rvv39_t,g_y_rvv39t,g_b_rvv39,g_b_rvv39_t,g_b_rvv39t
     FROM apmq990_tmp
    WHERE rvv25 = 'N'
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION
#end----add by guanyao160907
