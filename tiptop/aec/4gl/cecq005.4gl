# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: cecq005
# Descriptions...: 
# Date & Author..: 16/16/02  By guanyao160802

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING                                     
              END RECORD        
   DEFINE l_where         STRING 
   DEFINE g_sql           STRING                                                                                    
   DEFINE g_str           STRING    
   DEFINE l_table         STRING   
   DEFINE g_msg           LIKE type_file.chr1000
   DEFINE g_rec_b         LIKE type_file.num10
   DEFINE g_cnt           LIKE type_file.num10                  
   DEFINE g_sfb,g_sfb_excel   DYNAMIC ARRAY OF RECORD  
       tc_shc01          LIKE tc_shc_file.tc_shc01,
       tc_shc02          LIKE tc_shc_file.tc_shc02,
       tc_shc03          LIKE tc_shc_file.tc_shc03,
       tc_shc04          LIKE tc_shc_file.tc_shc04,
       tc_shc05          LIKE tc_shc_file.tc_shc05,
       ima02_1           LIKE ima_file.ima02,
       ima021_1          LIKE ima_file.ima021,
       tc_shc06          LIKE tc_shc_file.tc_shc06,
       tc_shc07          LIKE tc_shc_file.tc_shc07,
       tc_shc08          LIKE tc_shc_file.tc_shc08,
       ecd02             LIKE ecd_file.ecd02,
       tc_shc09          LIKE tc_shc_file.tc_shc09,
       eca02             LIKE eca_file.eca02,
       tc_shc10          LIKE tc_shc_file.tc_shc10,
       tc_shc11          LIKE tc_shc_file.tc_shc11,
       gen02             LIKE gen_file.gen02,
       tc_shc12          LIKE tc_shc_file.tc_shc12,
       tc_shc13          LIKE tc_shc_file.tc_shc13,
       ecg02             LIKE ecg_file.ecg02,
       tc_shc14          LIKE tc_shc_file.tc_shc14,
       tc_shc15          LIKE tc_shc_file.tc_shc15,
       tc_shc16          LIKE tc_shc_file.tc_shc16,
       tc_shb121         LIKE tc_shb_file.tc_shb121,
       tc_shb122         LIKE tc_shb_file.tc_shb122
                         END RECORD
   DEFINE g_sfb_attr     DYNAMIC ARRAY OF RECORD
       tc_shc01          STRING,
       tc_shc02          STRING,
       tc_shc03          STRING,
       tc_shc04          STRING,
       tc_shc05          STRING,
       ima02_1           STRING ,
       ima021_1          STRING,
       tc_shc06          STRING,
       tc_shc07          STRING,
       tc_shc08          STRING,
       ecd02             STRING,
       tc_shc09          STRING,
       eca02             STRING,
       tc_shc10          STRING,
       tc_shc11          STRING,
       gen02             STRING,
       tc_shc12          STRING,
       tc_shc13          STRING,
       ecg02             STRING,
       tc_shc14          STRING,
       tc_shc15          STRING,
       tc_shc16          STRING,
       tc_shb121         STRING,
       tc_shb122         STRING
                END RECORD
    DEFINE g_sfb_1          DYNAMIC ARRAY OF RECORD  
        sfb01       LIKE sfb_file.sfb01,   
        sfb05       LIKE sfb_file.sfb05, 
        ima02       LIKE ima_file.ima02, 
        ima021      LIKE ima_file.ima021, 
        sfb06       LIKE sfb_file.sfb06, 
        sfb08       LIKE sfb_file.sfb08, 
        sfb081      LIKE sfb_file.sfb081, 
        sfb09       LIKE sfb_file.sfb09,
        ecm03       LIKE ecm_file.ecm03,   #製程序
        ecm012      LIKE ecm_file.ecm012,  #工艺段号   #No.FUN-A60011
        ecm014      LIKE ecm_file.ecm014,  #FUN-B10056
        ecm06       LIKE ecm_file.ecm06,   #生產站別
        m06_name    LIKE pmc_file.pmc03,   #
        ecm04       LIKE ecm_file.ecm04,
        ecm45       LIKE ecm_file.ecm45,   #作業名稱
        ecm65       LIKE ecm_file.ecm65,   #标准产出量 #No.FUN-A60011
        wipqty      LIKE ecm_file.ecm315,  #
        ecm301      LIKE ecm_file.ecm301,  #
        ecm302      LIKE ecm_file.ecm302,  #
        ecm303      LIKE ecm_file.ecm303,
        ecm311      LIKE ecm_file.ecm311,  #
        ecm312      LIKE ecm_file.ecm312,  #
        ecm316      LIKE ecm_file.ecm316,
        ecm313      LIKE ecm_file.ecm313,  #
        ecm314      LIKE ecm_file.ecm314,  #
        shb30       LIKE shb_file.shb30,   #     #FUN-A80150 add
        ecm66       LIKE ecm_file.ecm66,   #     #FUN-A80150 add
        ecm315      LIKE ecm_file.ecm315,  #
        ecm321      LIKE ecm_file.ecm321,  #
        ecm322      LIKE ecm_file.ecm322,  #
        ecm291      LIKE ecm_file.ecm291,  #
        ecm292      LIKE ecm_file.ecm292,
        ecm58       LIKE ecm_file.ecm58,
        ecm54       LIKE ecm_file.ecm54,    #check-in 否
        ecm52       LIKE ecm_file.ecm52,
        ecm53       LIKE ecm_file.ecm53,
        ecm55       LIKE ecm_file.ecm55,
        ecm56       LIKE ecm_file.ecm56
                         END RECORD
   DEFINE g_sfb_1_attr       DYNAMIC ARRAY OF RECORD  
        sfb01       STRING,   
        sfb05       STRING, 
        ima02       STRING, 
        ima021      STRING, 
        sfb06       STRING, 
        sfb08       STRING, 
        sfb081      STRING, 
        sfb09       STRING,
        ecm03       STRING,
        ecm012      STRING,
        ecm014      STRING,  
        ecm06       STRING,   
        m06_name    STRING,   
        ecm04       STRING,
        ecm45       STRING,   
        ecm65       STRING,   
        wipqty      STRING,  
        ecm301      STRING,  
        ecm302      STRING,  
        ecm303      STRING,
        ecm311      STRING,  
        ecm312      STRING,  
        ecm316      STRING,
        ecm313      STRING,  
        ecm314      STRING,  
        shb30       STRING,
        ecm66       STRING,
        ecm315      STRING,
        ecm321      STRING,
        ecm322      STRING,
        ecm291      STRING,
        ecm292      STRING,
        ecm58       STRING,
        ecm54       STRING,
        ecm52       STRING,
        ecm53       STRING,
        ecm55       STRING,
        ecm56       STRING
            END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    
   DEFINE l_ac,l_ac1     LIKE type_file.num5    
   DEFINE g_rec_b2       LIKE type_file.num10   
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100
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
 
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q005_w AT 5,10
        WITH FORM "cec/42f/cecq005" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q005_table()  
   CALL q005_q()   
   CALL q005_menu()
   DROP TABLE cecq005_tmp;
   DROP TABLE cecq005_tmp_sum;
   CLOSE WINDOW q005_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q005_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   

   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q005_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q005_bp2()
         END IF
      END IF
      CASE g_action_choice
         WHEN "page1"
            CALL q005_bp("G")
         
         WHEN "page2"
            CALL q005_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q005_q()    
            END IF    
            LET g_action_choice = " "
         #WHEN "data_filter"       #資料過濾
         #   IF cl_chk_act_auth() THEN
         #      CALL q005_filter_askkey()
         #      CALL q005()        #重填充新臨時表
         #      CALL q005_show()
         #   END IF            
         #   LET g_action_choice = " "
         #WHEN "revert_filter"     # 過濾還原
         #   IF cl_chk_act_auth() THEN
         #      CALL cl_set_act_visible("revert_filter",FALSE) 
         #      CALL q005()        #重填充新臨時表
         #      CALL q005_show() 
         #   END IF             
         #   LET g_action_choice = " "
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
                     LET page = f.FindNode("Page","page1")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfb_excel),'','')
                  WHEN 'page2'
                     LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfb_1),'','')
               END CASE
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "sfb01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q005_b_fill()

   LET g_sql = " SELECT tc_shc01,tc_shc02,tc_shc03,tc_shc04,tc_shc05,ima02_1,ima021_1,",
               "        tc_shc06,tc_shc07,tc_shc08,ecd02,tc_shc09,eca02,tc_shc10,tc_shc11,gen02,tc_shc12,tc_shc13,",
               "        ecg02,tc_shc14,tc_shc15,tc_shc16,tc_shb121,tc_shb122",
               "   FROM cecq005_tmp ",
               "  ORDER BY tc_shc01,tc_shc02 "   


   PREPARE cecq005_pb FROM g_sql
   DECLARE sfb_curs  CURSOR FOR cecq005_pb        #CURSOR


   CALL g_sfb.clear()
   CALL g_sfb_excel.clear()
   CALL g_sfb_attr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH sfb_curs INTO g_sfb_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      #CALL q005_color()

      IF g_cnt < = g_max_rec THEN
         LET g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_sfb.deleteElement(g_cnt)
   END IF
   CALL g_sfb_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec AND (g_bgjob = 'N' OR cl_null(g_bgjob)) THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION

FUNCTION q005_b_fill_2()
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_sfb01_t     LIKE sfb_file.sfb01
   DEFINE l_ogb03_t     LIKE ogb_file.ogb03
   DEFINE  l_sfb24      LIKE sfb_file.sfb24
   DEFINE  l_type       LIKE type_file.chr1   

   CALL g_sfb_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1

   CALL q005_get_sum()
     
END FUNCTION


FUNCTION q005_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND g_flag != '1' THEN
      CALL q005_b_fill()
   END IF
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_sfb TO s_tc_shc.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL DIALOG.setArrayAttributes("s_tc_shc",g_sfb_attr)    #参数：屏幕变量,属性数组
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
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         EXIT DIALOG
   
      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          #明細資料刷新
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

FUNCTION q005_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q005_b_fill_2()
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_sfb_1 TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY 
            CALL DIALOG.setArrayAttributes("s_sfb",g_sfb_1_attr)    #参数：屏幕变量,属性数组
            CALL ui.Interface.refresh()
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
            CALL q005_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   

      ON ACTION refresh_detail
         #CALL q005_b_fill()  #FUN-D10105 mark
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

FUNCTION q005_cs()
   DEFINE  l_cnt           LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     
   DEFINE  li_chk_bookno   LIKE type_file.num5
 
   CLEAR FORM   #清除畫面
   CALL g_sfb.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                  
   #FUN-D10105--add--str--
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   #FUN-D10105--add--end--
   CALL cl_set_act_visible("revert_filter",FALSE) #FUN-D10105 add
   DIALOG ATTRIBUTE(UNBUFFERED)    

         CONSTRUCT tm.wc2 ON tc_shc02,tc_shc03,tc_shc04,tc_shc05,tc_shc06,tc_shc07,tc_shc08,tc_shc09,tc_shc10, tc_shc11,tc_shc12,tc_shc13,
                             tc_shc14,tc_shc15,tc_shc16

                        FROM s_tc_shc[1].tc_shc02,s_tc_shc[1].tc_shc03,s_tc_shc[1].tc_shc04,s_tc_shc[1].tc_shc05,s_tc_shc[1].tc_shc06,
                             s_tc_shc[1].tc_shc07,s_tc_shc[1].tc_shc08,s_tc_shc[1].tc_shc09,s_tc_shc[1].tc_shc10,s_tc_shc[1].tc_shc11,
                             s_tc_shc[1].tc_shc12,s_tc_shc[1].tc_shc13,s_tc_shc[1].tc_shc14,s_tc_shc[1].tc_shc15,s_tc_shc[1].tc_shc16

              
            BEFORE CONSTRUCT
               CALL cl_qbe_init()


         END CONSTRUCT
         #出貨單欄位

         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_shc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc03
                  NEXT FIELD tc_shc03
               WHEN INFIELD(tc_shc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc04_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc04
                  NEXT FIELD tc_shc04
               WHEN INFIELD(tc_shc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc05
                  NEXT FIELD tc_shc05
               WHEN INFIELD(tc_shc08)
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc08
                  NEXT FIELD tc_shc08
               WHEN INFIELD(tc_shc09)
                  CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc09
                  NEXT FIELD tc_shc09
               WHEN INFIELD(tc_shc11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc11
                  NEXT FIELD tc_shc11
               WHEN INFIELD(tc_shc13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_ecg"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc13
                  NEXT FIELD tc_shc13
            END CASE
       
          
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
      LET INT_FLAG = 0
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      DELETE FROM axcq005_tmp
   END IF

   CALL q005()   
END FUNCTION 

FUNCTION q005_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q005_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q005_show()
END FUNCTION

FUNCTION q005_show() 
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_flag = "page1"  
      CALL q005_b_fill()    #FUN-D10105 add
      --LET g_action_choice = "page2"
      --CALL cl_set_comp_visible("page1", FALSE)
      --CALL ui.interface.refresh()
      --CALL cl_set_comp_visible("page1", TRUE)
      --LET g_action_flag = "page2"  #FUN-D10105 add 
      --CALL q005_b_fill_2()  #FUN-D10105 add 
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q005_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
         CONSTRUCT l_wc ON  tc_shc02,tc_shc03,tc_shc04,tc_shc05,tc_shc06,tc_shc07,tc_shc08,tc_shc09,tc_shc10, tc_shc11,tc_shc12,tc_shc13,
                             tc_shc14,tc_shc15,tc_shc16

                        FROM s_tc_shc[1].tc_shc02,s_tc_shc[1].tc_shc03,s_tc_shc[1].tc_shc04,s_tc_shc[1].tc_shc05,s_tc_shc[1].tc_shc06,
                             s_tc_shc[1].tc_shc07,s_tc_shc[1].tc_shc08,s_tc_shc[1].tc_shc09,s_tc_shc[1].tc_shc10,s_tc_shc[1].tc_shc11,
                             s_tc_shc[1].tc_shc12,s_tc_shc[1].tc_shc13,s_tc_shc[1].tc_shc14,s_tc_shc[1].tc_shc15,s_tc_shc[1].tc_shc16

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

             
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_shc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc03
                  NEXT FIELD tc_shc03
               WHEN INFIELD(tc_shc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc04_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc04
                  NEXT FIELD tc_shc04
               WHEN INFIELD(tc_shc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_shc05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc05
                  NEXT FIELD tc_shc05
               WHEN INFIELD(tc_shc08)
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc08
                  NEXT FIELD tc_shc08
               WHEN INFIELD(tc_shc09)
                  CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc09
                  NEXT FIELD tc_shc09
               WHEN INFIELD(tc_shc11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc11
                  NEXT FIELD tc_shc11
               WHEN INFIELD(tc_shc13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_ecg"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_shc13
                  NEXT FIELD tc_shc13
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
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF 
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF 

END FUNCTION

FUNCTION q005_table()
   #DROP TABLE cecq005_tmp;  #FUN-D10105 mark
   CREATE TEMP TABLE cecq005_tmp(
       tc_shc01          LIKE tc_shc_file.tc_shc01,
       tc_shc02          LIKE tc_shc_file.tc_shc02,
       tc_shc03          LIKE tc_shc_file.tc_shc03,
       tc_shc04          LIKE tc_shc_file.tc_shc04,
       tc_shc05          LIKE tc_shc_file.tc_shc05,
       ima02_1           LIKE ima_file.ima02,
       ima021_1          LIKE ima_file.ima021,
       tc_shc06          LIKE tc_shc_file.tc_shc06,
       tc_shc07          LIKE tc_shc_file.tc_shc07,
       tc_shc08          LIKE tc_shc_file.tc_shc08,
       ecd02             LIKE ecd_file.ecd02,
       tc_shc09          LIKE tc_shc_file.tc_shc09,
       eca02             LIKE eca_file.eca02,
       tc_shc10          LIKE tc_shc_file.tc_shc10,
       tc_shc11          LIKE tc_shc_file.tc_shc11,
       gen02             LIKE gen_file.gen02,
       tc_shc12          LIKE tc_shc_file.tc_shc12,
       tc_shc13          LIKE tc_shc_file.tc_shc13,
       ecg02             LIKE ecg_file.ecg02,
       tc_shc14          LIKE tc_shc_file.tc_shc14,
       tc_shc15          LIKE tc_shc_file.tc_shc15,
       tc_shc16          LIKE tc_shc_file.tc_shc16,
       tc_shb121         LIKE tc_shb_file.tc_shb121,
       tc_shb122         LIKE tc_shb_file.tc_shb122,
       rowno             LIKE type_file.num10)  
    
    CREATE TEMP TABLE cecq005_tmp_sum(
        sfb01       LIKE sfb_file.sfb01,   
        sfb05       LIKE sfb_file.sfb05, 
        ima02       LIKE ima_file.ima02, 
        ima021      LIKE ima_file.ima021, 
        sfb06       LIKE sfb_file.sfb06, 
        sfb08       LIKE sfb_file.sfb08, 
        sfb081      LIKE sfb_file.sfb081, 
        sfb09       LIKE sfb_file.sfb09,
        ecm03       LIKE ecm_file.ecm03,   #製程序
        ecm012      LIKE ecm_file.ecm012,  #工艺段号   #No.FUN-A60011
        ecm014      LIKE ecm_file.ecm014,  #FUN-B10056
        ecm06       LIKE ecm_file.ecm06,   #生產站別
        m06_name    LIKE pmc_file.pmc03,   #
        ecm04       LIKE ecm_file.ecm04,
        ecm45       LIKE ecm_file.ecm45,   #作業名稱
        ecm65       LIKE ecm_file.ecm65,   #标准产出量 #No.FUN-A60011
        wipqty      LIKE ecm_file.ecm315,  #
        ecm301      LIKE ecm_file.ecm301,  #
        ecm302      LIKE ecm_file.ecm302,  #
        ecm303      LIKE ecm_file.ecm303,
        ecm311      LIKE ecm_file.ecm311,  #
        ecm312      LIKE ecm_file.ecm312,  #
        ecm316      LIKE ecm_file.ecm316,
        ecm313      LIKE ecm_file.ecm313,  #
        ecm314      LIKE ecm_file.ecm314,  #
        shb30       LIKE shb_file.shb30,   #     #FUN-A80150 add
        ecm66       LIKE ecm_file.ecm66,   #     #FUN-A80150 add
        ecm315      LIKE ecm_file.ecm315,  #
        ecm321      LIKE ecm_file.ecm321,  #
        ecm322      LIKE ecm_file.ecm322,  #
        ecm291      LIKE ecm_file.ecm291,  #
        ecm292      LIKE ecm_file.ecm292,
        ecm58       LIKE ecm_file.ecm58,
        ecm54       LIKE ecm_file.ecm54,    #check-in 否
        ecm52       LIKE ecm_file.ecm52,
        ecm53       LIKE ecm_file.ecm53,
        ecm55       LIKE ecm_file.ecm55,
        ecm56       LIKE ecm_file.ecm56)
END FUNCTION 

FUNCTION q005()
 DEFINE   l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_chr       LIKE type_file.chr1,         
          l_order     ARRAY[5] OF LIKE abb_file.abb11,   #排列順序    
          l_i         LIKE type_file.num5,                    
          l_cnt       LIKE type_file.num5                  
   DEFINE l_wc,l_msg,g_wc,l_sql1,l_sql2,l_sql3   STRING 
   DEFINE l_sic06a,l_sic06b  LIKE sic_file.sic06
   DEFINE l_order1     LIKE type_file.chr100
   DEFINE l_num        LIKE type_file.num5
   DEFINE l_ogc        RECORD LIKE ogc_file.*
   DEFINE l_sfb01_t    LIKE sfb_file.sfb01      #lixh1121107 add
   DEFINE l_ogb03_t    LIKE ogb_file.ogb03      #lixh1121107 add
   DEFINE l_wc2        STRING 


   DISPLAY TIME   #add by wangxy 20121120                  
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   LET l_wc2 = cl_replace_str(tm.wc2,'tc_shc','tc_shb')      #字符替換
   #LET g_wc = cl_replace_str(g_wc,'ogb12','ogc16')
   #LET g_wc = cl_replace_str(g_wc,'ogb09','ogc09')
   #LET g_wc = cl_replace_str(g_wc,'ogb091','ogc091')
   #LET g_wc = cl_replace_str(g_wc,'ogb092','ogc092')
   #LET l_where = cl_replace_str(tm.wc2,'sfb00','oha05')   #字符替換
   #LET l_where = cl_replace_str(l_where,'sfb','oha')
   #LET l_where = cl_replace_str(l_where,'ogb31','ohb33')
   #LET l_where = cl_replace_str(l_where,'ogb32','ohb34')
   #LET l_where = cl_replace_str(l_where,'ogb19','ohb61')
   #LET l_where = cl_replace_str(l_where,'ogb','ohb')


   DELETE FROM cecq005_tmp

   LET l_sql =  "SELECT CASE tc_shc01 WHEN '1' THEN 1 ELSE 4 END tc_shc01,tc_shc02,tc_shc03,tc_shc04,tc_shc05,",
                "       ima02,ima021,tc_shc06,tc_shc07,tc_shc08,ecd02,tc_shc09,eca02,tc_shc10,tc_shc11,gen02,tc_shc12,tc_shc13,",
                "       ecg02,tc_shc14,tc_shc15,tc_shc16,0 tc_shb121,0 tc_shb122",
                "  FROM tc_shc_file LEFT JOIN gen_file ON gen01 = tc_shc11",
                "                   LEFT JOIN ima_file ON ima01 = tc_shc05",
                "                   LEFT JOIN ecd_file ON ecd01 = tc_shc08",
                "                   LEFT JOIN eca_file ON eca01 = tc_shc09",
                "                   LEFT JOIN ecg_file ON ecg01 = tc_shc13",
                " WHERE ",tm.wc2 CLIPPED,
                " UNION",
                " SELECT CASE tc_shb01 WHEN '1' THEN 2 ELSE 3 END tc_shc01,tc_shb02 tc_shc02,tc_shb03 tc_shc03,tc_shb04 tc_shc04,tc_shb05,",
                "        ima02,ima021,tc_shb06,tc_shb07,tc_shb08,ecd02,tc_shb09,eca02,tc_shb10,tc_shb11,gen02,tc_shb12,tc_shb13,",
                "        ecg02,tc_shb14,tc_shb15,tc_shb16,tc_shb121,tc_shb122",
                "   FROM tc_shb_file LEFT JOIN gen_file ON gen01 = tc_shb11",
                "                    LEFT JOIN ima_file ON ima01 = tc_shb05",
                "                    LEFT JOIN ecd_file ON ecd01 = tc_shb08",
                "                    LEFT JOIN eca_file ON eca01 = tc_shb09",
                "                    LEFT JOIN ecg_file ON ecg01 = tc_shb13",
                " WHERE ",l_wc2 CLIPPED,
                "  ORDER BY tc_shc01,tc_shc02 " 

   LET l_sql = " INSERT INTO cecq005_tmp ",
               "   SELECT x.tc_shc01,x.tc_shc02,x.tc_shc03,x.tc_shc04,x.tc_shc05,",
               "          x.ima02,x.ima021,x.tc_shc06,x.tc_shc07,x.tc_shc08,x.ecd02,x.tc_shc09,x.eca02,x.tc_shc10,x.tc_shc11,x.gen02,x.tc_shc12,x.tc_shc13,",
               "          x.ecg02,x.tc_shc14,x.tc_shc15,x.tc_shc16,x.tc_shb121,x.tc_shb122,",
               "          ROW_NUMBER() OVER (PARTITION BY tc_shc01,tc_shc02 ORDER BY tc_shc01,tc_shc02) ",
               "     FROM (",l_sql CLIPPED,") x "
   PREPARE q005_ins FROM l_sql
   EXECUTE q005_ins

   DISPLAY TIME   #add by wangxy 20121120


END FUNCTION 

FUNCTION q005_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING
   DEFINE l_sql1   STRING 
   

   DELETE FROM cecq005_tmp_sum
   #CALL g_sfb_1_attr.clear()

   LET l_sql1 = "SELECT distinct sfb01,sfb05,ima02,ima021,sfb06,sfb08,sfb081,sfb09,ecm03,ecm012,'',ecm06,eca_file.eca02,ecm04,ecm45,ecm65,0,0,0,",
                "       0,0,0,0,0,0,'N','N',0,",
                "       0,0,0,0,ecm58,NVL(ecm54,'N'),",
                "       NVL(ecm52,'N'),NVL(ecm53,'N'),ecm55,ecm56 ",
                "  FROM ecm_file LEFT JOIN eca_file ON eca01 = ecm06,",
                "       sfb_file LEFT JOIN ima_file ON ima01 = sfb05,cecq005_tmp",
                " WHERE ecm01 = sfb01",    
                "   AND ecm04 = tc_shc08",
                "   AND ecm01 = tc_shc04",       
                " ORDER BY sfb01,ecm012,ecm03 " 
    LET l_sql = "INSERT INTO cecq005_tmp_sum ",l_sql1 CLIPPED
    
    PREPARE q005_ins_sum FROM l_sql
    EXECUTE q005_ins_sum

    #良品转入量
    LET l_sql = " MERGE INTO cecq005_tmp_sum o ",
               "      USING (SELECT SUM(tc_shc12) ecm301,tc_shc04,tc_shc08 FROM tc_shc_file ",
               "               WHERE  tc_shc01 = '1'",
               "               GROUP BY tc_shc04,tc_shc08) n ",
               "         ON (o.sfb01 = n.tc_shc04 AND o.ecm04 = n.tc_shc08) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ecm301 = NVL(n.ecm301,0) "
    PREPARE q005_sum1 FROM l_sql
    EXECUTE q005_sum1

    #良品转出
    LET l_sql = " MERGE INTO cecq005_tmp_sum o ",
               "      USING (SELECT SUM(tc_shc12) ecm311,tc_shc04,tc_shc08 FROM tc_shc_file  ",
               "              WHERE tc_shc01 = '2'",
               "               GROUP BY tc_shc04,tc_shc08) n ",
               "         ON (o.sfb01 = n.tc_shc04 AND o.ecm04 = n.tc_shc08) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ecm311 = NVL(n.ecm311,0) "
    PREPARE q005_sum2 FROM l_sql
    EXECUTE q005_sum2

    #当站报废
    LET l_sql = " MERGE INTO cecq005_tmp_sum o ",
               "      USING (SELECT SUM(tc_shb121) ecm313,tc_shb04,tc_shb08 FROM tc_shb_file ",
               "              WHERE tc_shb01 = '2'", 
               "               GROUP BY tc_shb04,tc_shb08) n ",
               "         ON (o.sfb01 = n.tc_shb04 AND o.ecm04 = n.tc_shb08) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ecm313 = NVL(n.ecm313,0) "
    PREPARE q005_sum3 FROM l_sql
    EXECUTE q005_sum3
    
    #当站返工
    LET l_sql = " MERGE INTO cecq005_tmp_sum o ",
               "      USING (SELECT SUM(tc_shb122) ecm312,tc_shb04,tc_shb08 FROM tc_shb_file,tc_shc_file ",
               "              WHERE tc_shb01 = '2'", 
               "               GROUP BY tc_shb04,tc_shb08) n ",
               "         ON (o.sfb01 = n.tc_shb04 AND o.ecm04 = n.tc_shb08) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ecm312 = NVL(n.ecm312,0) "
    PREPARE q005_sum4 FROM l_sql
    EXECUTE q005_sum4

    LET l_sql = "update cecq005_tmp_sum set wipqty =NVL(ecm301-ecm311-ecm313,0) "
    PREPARE q005_sum5 FROM l_sql
    EXECUTE q005_sum5

    LET l_sql = "SELECT * FROM cecq005_tmp_sum ORDER BY sfb01,ecm012,ecm03"

              
   PREPARE q005_pb FROM l_sql
   DECLARE q005_curs1 CURSOR FOR q005_pb
   FOREACH q005_curs1 INTO g_sfb_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_sfb_1[g_cnt].wipqty>0 THEN 
         CALL q005_color_1()
      END IF 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY ARRAY g_sfb_1 TO s_sfb_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   CALL g_sfb_1.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cnt1 
END FUNCTION  

FUNCTION q005_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,
          l_sfb24      LIKE sfb_file.sfb24,
          l_type       LIKE type_file.chr1,   
          l_sql        STRING, 
          l_tmp        STRING, #FUN-D10105
          l_tmp2       STRING  #FUN-D10105


   LET l_sql = " SELECT tc_shc01,tc_shc02,tc_shc03,tc_shc04,tc_shc05,ima02_1,ima021_1,",
               "        tc_shc06,tc_shc07,tc_shc08,ecd02,tc_shc09,eca02,tc_shc10,tc_shc11,gen02,tc_shc12,tc_shc13,",
               "        ecg02,tc_shc14,tc_shc15,tc_shc16,tc_shb121,tc_shb122",
               "   FROM cecq005_tmp ",
               "  WHERE tc_shc04 = '",g_sfb_1[p_ac].sfb01,"'",
               "    AND tc_shc08 = '",g_sfb_1[p_ac].ecm04,"'",
               "  ORDER BY tc_shc01,tc_shc02 "  


   PREPARE cecq005_pb_detail FROM l_sql
   DECLARE sfb_curs_detail  CURSOR FOR cecq005_pb_detail        #CURSOR
   CALL g_sfb.clear()
   CALL g_sfb_attr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH sfb_curs_detail INTO g_sfb_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_sfb[g_cnt].* = g_sfb_excel[g_cnt].*
      END IF
      #CAll q005_color()
      LET g_cnt = g_cnt + 1  
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_sfb.deleteElement(g_cnt)
   END IF
   CALL g_sfb_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION 

FUNCTION q005_color()
         LET g_sfb_attr[g_cnt].tc_shc01 = "red"
         LET g_sfb_attr[g_cnt].tc_shc02 = "red"
         LET g_sfb_attr[g_cnt].tc_shc03 = "red"
         LET g_sfb_attr[g_cnt].tc_shc04 = "red"
         LET g_sfb_attr[g_cnt].tc_shc05 = "red"
         LET g_sfb_attr[g_cnt].ima02_1 = "red"
         LET g_sfb_attr[g_cnt].ima021_1 = "red"
         LET g_sfb_attr[g_cnt].tc_shc06 = "red"
         LET g_sfb_attr[g_cnt].tc_shc07 = "red"
         LET g_sfb_attr[g_cnt].tc_shc08 = "red"
         LET g_sfb_attr[g_cnt].ecd02 = "red"
         LET g_sfb_attr[g_cnt].tc_shc09 = "red"
         LET g_sfb_attr[g_cnt].eca02 = "red"
         LET g_sfb_attr[g_cnt].tc_shc10 = "red"
         LET g_sfb_attr[g_cnt].tc_shc11 = "red"
         LET g_sfb_attr[g_cnt].gen02 = "red"
         LET g_sfb_attr[g_cnt].tc_shc12 = "red"   #FUN-D10105
         LET g_sfb_attr[g_cnt].tc_shc13 = "red"   #FUN-D10105
         LET g_sfb_attr[g_cnt].ecg02 = "red"   
         LET g_sfb_attr[g_cnt].tc_shc14 = "red"
         LET g_sfb_attr[g_cnt].tc_shc15 = "red"
         LET g_sfb_attr[g_cnt].tc_shc16 = "red"
         LET g_sfb_attr[g_cnt].tc_shb121 = "red"
         LET g_sfb_attr[g_cnt].tc_shb122 = "red"
END FUNCTION

FUNCTION q005_color_1()
         LET g_sfb_1_attr[g_cnt].sfb01 = "red"
         LET g_sfb_1_attr[g_cnt].sfb05 = "red"
         LET g_sfb_1_attr[g_cnt].ima02 = "red"
         LET g_sfb_1_attr[g_cnt].ima021 = "red"
         LET g_sfb_1_attr[g_cnt].sfb06 = "red"
         LET g_sfb_1_attr[g_cnt].sfb08 = "red"
         LET g_sfb_1_attr[g_cnt].sfb081 = "red"
         LET g_sfb_1_attr[g_cnt].sfb09 = "red"
         LET g_sfb_1_attr[g_cnt].ecm03 = "red"
         LET g_sfb_1_attr[g_cnt].ecm012 = "red"
         LET g_sfb_1_attr[g_cnt].ecm014 = "red"
         LET g_sfb_1_attr[g_cnt].ecm06 = "red"   #FUN-D10105
         LET g_sfb_1_attr[g_cnt].m06_name = "red"   #FUN-D10105
         LET g_sfb_1_attr[g_cnt].ecm04 = "red"
         LET g_sfb_1_attr[g_cnt].ecm45 = "red"
         LET g_sfb_1_attr[g_cnt].ecm65 = "red"
         LET g_sfb_1_attr[g_cnt].wipqty = "red"
         LET g_sfb_1_attr[g_cnt].ecm301 = "red"
         LET g_sfb_1_attr[g_cnt].ecm302 = "red"
         LET g_sfb_1_attr[g_cnt].ecm303 = "red"
         LET g_sfb_1_attr[g_cnt].ecm311 = "red"   #FUN-D10105
         LET g_sfb_1_attr[g_cnt].ecm312 = "red"   #FUN-D10105
         LET g_sfb_1_attr[g_cnt].ecm316 = "red"
         LET g_sfb_1_attr[g_cnt].ecm313 = "red"
         LET g_sfb_1_attr[g_cnt].ecm314 = "red"
         LET g_sfb_1_attr[g_cnt].shb30 = "red"
         LET g_sfb_1_attr[g_cnt].ecm66 = "red"
         LET g_sfb_1_attr[g_cnt].ecm315 = "red"         
         LET g_sfb_1_attr[g_cnt].ecm321 = "red"
         LET g_sfb_1_attr[g_cnt].ecm322 = "red"   #FUN-D10105         
         LET g_sfb_1_attr[g_cnt].ecm291 = "red"   #FUN-D10105         
         LET g_sfb_1_attr[g_cnt].ecm292 = "red"
         LET g_sfb_1_attr[g_cnt].ecm58 = "red"
         LET g_sfb_1_attr[g_cnt].ecm54 = "red"
         LET g_sfb_1_attr[g_cnt].ecm52 = "red"
         LET g_sfb_1_attr[g_cnt].ecm53 = "red"
         LET g_sfb_1_attr[g_cnt].ecm55 = "red"
         LET g_sfb_1_attr[g_cnt].ecm56 = "red"
END FUNCTION

