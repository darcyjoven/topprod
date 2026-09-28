# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: cpmq002
# Descriptions...: 采购需求表
# Date & Author..: 16/08/29 by ly


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

    DEFINE g_forupd_sql STRING 
    DEFINE g_wc,g_wc1         STRING
    DEFINE g_query LIKE type_file.chr1
    DEFINE g_filter1  LIKE type_file.chr1
    DEFINE g_mss  RECORD                                              
        tc_mss01 LIKE tc_mss_file.tc_mss01,    
        tc_mss18 LIKE tc_mss_file.tc_mss18,
        tc_mss19 LIKE tc_mss_file.tc_mss19,
        tc_mss21 LIKE tc_mss_file.tc_mss21
    END RECORD  

    DEFINE g_tc_mst,g_tc_mst_excel   DYNAMIC ARRAY OF RECORD 
        tc_mst08  LIKE tc_mst_file.tc_mst08,
        tc_mst03  LIKE tc_mst_file.tc_mst03,
        tc_mst02  LIKE tc_mst_file.tc_mst02,
        tc_mst09  LIKE tc_mst_file.tc_mst09,
        ima02     LIKE ima_file.ima02,
        ima021    LIKE ima_file.ima021,
        tc_mst04  LIKE tc_mst_file.tc_mst04,
        tc_mst05  LIKE tc_mst_file.tc_mst05,
        tc_mst06  LIKE tc_mst_file.tc_mst06,
        tc_mst07  LIKE tc_mst_file.tc_mst07

    END RECORD
    DEFINE g_tc_mss   DYNAMIC ARRAY OF RECORD  
        sel1      LIKE type_file.chr1,
        tc_mss02  LIKE tc_mss_file.tc_mss02,
        tc_mss03  LIKE tc_mss_file.tc_mss03,
        tc_mss04  LIKE tc_mss_file.tc_mss04,
        imz01     LIKE imz_file.imz01,
        imz02     LIKE imz_file.imz02,
        tc_mss05  LIKE tc_mss_file.tc_mss05,
        tc_mss06  LIKE tc_mss_file.tc_mss06,
        tc_mss07  LIKE tc_mss_file.tc_mss07,
        tc_mss08  LIKE tc_mss_file.tc_mss08,
        tc_mss09  LIKE tc_mss_file.tc_mss09,
        tc_mss10  LIKE tc_mss_file.tc_mss10,
        tc_mss11  LIKE tc_mss_file.tc_mss11,
        tc_mss12  LIKE tc_mss_file.tc_mss12,
        tc_mss13  LIKE tc_mss_file.tc_mss13,
        tc_mss14  LIKE tc_mss_file.tc_mss14,
        tc_mss15  LIKE tc_mss_file.tc_mss15,
        tc_mss16  LIKE tc_mss_file.tc_mss16,
        tc_mss17  LIKE tc_mss_file.tc_mss17
             END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    
   DEFINE l_ac,l_ac1     LIKE type_file.num5                                                                                        
   DEFINE g_cmd          LIKE type_file.chr1000  
   DEFINE g_rec_b2       LIKE type_file.num10   
   DEFINE g_flag         LIKE type_file.chr1
   DEFINE g_ynac         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100
   DEFINE   w    ui.Window      
   DEFINE   f    ui.Form       
   DEFINE   page om.DomNode 
   DEFINE g_query_flag    LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入N.下筆
       g_sql           STRING,                     #WHERE CONDITION 
       g_rec_b         LIKE type_file.num5         #單身筆數
   DEFINE g_cnt           LIKE type_file.num10     
   DEFINE g_msg           LIKE type_file.chr1000  


MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q001_w AT 5,10
        WITH FORM "cpm/42f/cpmq002" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   #CALL q001_q()   
   LET g_action_flag = 'page2'
  # LET g_query = 'N'
   CALL q001_menu()
   CLOSE WINDOW q001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q001_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   

   WHILE TRUE
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
            CALL q001_q()  
            LET g_action_choice = " "
         WHEN "output"
           IF cl_chk_act_auth() THEN  #MOD-C40129 add
              CALL q001_out() 
           END IF       
         WHEN "new_tc_mss_file"
         IF cl_chk_act_auth() THEN
             CALL q001_new_mss()
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
                     LET page = f.FindNode("Page","page1")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_mst_excel),'','')
                  WHEN 'page2'
                     LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_mss),'','')
               END CASE
            END IF
            LET g_action_choice = " "

      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q001_b_fill()                 #BODY FILL UP
   DEFINE l_sql     STRING 
   DEFINE l_tot     LIKE type_file.num15_3 #FUN-A20044 

    LET l_sql= " SELECT tc_mst08,tc_mst03,tc_mst02,tc_mst09,ima02,ima021,tc_mst04,tc_mst05,tc_mst06,tc_mst07 ",
                " FROM tc_mst_file LEFT OUTER JOIN ima_file ON tc_mst02=ima01 ",
                " WHERE tc_mst01 = '",g_mss.tc_mss01,"'",
                " ORDER BY tc_mst08,tc_mst03,tc_mst02 "
   PREPARE q001_pb2 FROM l_sql
   DECLARE q001_bcs2 CURSOR FOR q001_pb2     #BODY CURSOR
 
   CALL g_tc_mss.clear() 
   LET g_rec_b= 0
   LET g_cnt  = 1
    
   FOREACH q001_bcs2 INTO g_tc_mst[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      	
   END FOREACH
   DISPLAY ARRAY g_tc_mst TO s_tc_mst.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
   
   CALL g_tc_mss.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cnt2a 

END FUNCTION

FUNCTION q001_b_fill2()                #BODY FILL UP
   DEFINE l_sql     STRING 
   DEFINE l_tot     LIKE type_file.num15_3 #FUN-A20044 
   IF g_filter1 = 'Y' THEN 
      LET g_wc1 = "tc_mss06 <> 0 AND ",g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   ELSE 
    LET g_wc1 =g_wc CLIPPED,cl_get_extra_cond(null, null) 
   END IF 
   LET l_sql= " SELECT 'N',tc_mss02,tc_mss03,tc_mss04,imz01,imz02,tc_mss05,tc_mss06,tc_mss07,tc_mss08,tc_mss09,",
            " tc_mss10,tc_mss11,tc_mss12,tc_mss13,tc_mss14,tc_mss15,tc_mss16,tc_mss17 ",
            " FROM tc_mss_file LEFT OUTER JOIN ima_file ON tc_mss02=ima01 ",
            " LEFT OUTER JOIN imz_file ON imz01=ima06 ", 
            " WHERE ",g_wc1 CLIPPED,
            " AND tc_mss01 = '",g_mss.tc_mss01,"'",
            " ORDER BY tc_mss02 "
   PREPARE q001_pb FROM l_sql
   DECLARE q001_bcs CURSOR FOR q001_pb     #BODY CURSOR
 
   CALL g_tc_mss.clear() 
   LET g_rec_b= 0
   LET g_cnt  = 1
    
   FOREACH q001_bcs INTO g_tc_mss[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY ARRAY g_tc_mss TO s_tc_mss.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
      EXIT DISPLAY
   END DISPLAY
   CALL g_tc_mss.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cnt2

END FUNCTION


FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND g_flag != '1' THEN 
      CALL q001_b_fill()
   END IF 
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
     DIALOG ATTRIBUTES(UNBUFFERED)
     INPUT g_filter1 FROM filter1 ATTRIBUTE(WITHOUT DEFAULTS)
     BEFORE INPUT
       CALL DIALOG.setArrayAttributes("s_tc_mst",g_tc_mst)    #参数：屏幕变量,属性数组
       CALL ui.Interface.refresh()
       
     ON CHANGE filter1
        IF NOT cl_null(g_filter1)  THEN 
               CALL q001_b_fill2()
              
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
        
        END IF
        DISPLAY g_filter1 TO filter1
        EXIT DIALOG
    
     DISPLAY  g_mss.* TO tc_mss01,tc_mss18,tc_mss19,tc_mss21
     END INPUT
     DISPLAY ARRAY g_tc_mst TO s_tc_mst.* ATTRIBUTE(COUNT=g_rec_b)
     
     BEFORE DISPLAY
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
         
      ON ACTION OUTPUT 
         LET g_action_choice="output"
         EXIT DIALOG    
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         EXIT DIALOG 

      ON ACTION FIRST
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST

      ON ACTION PREVIOUS
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                  #No.FUN-530067 HCN TEST


      ON ACTION jump 
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                  #No.FUN-530067 HCN TEST

       ON ACTION NEXT 
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST

     ON ACTION LAST 
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG             
         
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG
         
     ON ACTION new_tc_mss_file
         LET g_action_choice="new_tc_mss_file"
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

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
      &include "qry_string.4gl"
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   CALL q001_b_fill2()
   DIALOG ATTRIBUTES(UNBUFFERED)
    INPUT g_filter1 FROM filter1 ATTRIBUTE(WITHOUT DEFAULTS)
    BEFORE INPUT
    CALL DIALOG.setArrayAttributes("s_tc_mst",g_tc_mst)    #参数：屏幕变量,属性数组
    CALL ui.Interface.refresh()

    ON CHANGE filter1
    IF NOT cl_null(g_filter1)  THEN 
           CALL q001_b_fill2()
          
           CALL cl_set_comp_visible("page1", FALSE)
           CALL ui.interface.refresh()
           CALL cl_set_comp_visible("page1", TRUE)
           LET g_action_choice = "page2"
   
    END IF
    DISPLAY g_filter1 TO filter1
    EXIT DIALOG
   DISPLAY  g_mss.* TO tc_mss01,tc_mss18,tc_mss19,tc_mss21
   END INPUT
   DISPLAY ARRAY g_tc_mss TO s_tc_mss.* ATTRIBUTE(COUNT=g_rec_b)
      
     BEFORE ROW
        IF g_ynac = 'N' THEN 
           CALL fgl_set_arr_curr(l_ac)
        END IF 
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()
        LET g_ynac = 'Y'
      END DISPLAY   
      ON ACTION page1
         LET g_action_choice="page1"
         
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG    

      ON ACTION OUTPUT 
         LET g_action_choice="output"
         EXIT DIALOG 
         
     ON ACTION new_tc_mss_file
         LET g_action_choice="new_tc_mss_file"
         EXIT DIALOG       
 
      ON ACTION FIRST
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST

      ON ACTION PREVIOUS
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST

      ON ACTION jump 
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No.FUN-530067 HCN TEST

       ON ACTION NEXT 
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                    #No.FUN-530067 HCN TEST

     ON ACTION LAST 
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG              
         
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF l_ac1 > 0  THEN
         #IF l_ac1 > 0  THEN
            CALL q001_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_ynac = 'N'
            LET g_flag = '1'             
            EXIT DIALOG   
         END IF
         
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

      AFTER DIALOG 
         CONTINUE DIALOG 

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
        END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_cs()
   DEFINE   l_cnt   LIKE type_file.num5     
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01  
   LET g_wc = ''
 
      CLEAR FORM #清除畫面
      CALL g_tc_mss.clear() 
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")  
 
      INITIALIZE g_mss.* TO NULL    
      DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT g_filter1 FROM filter1 ATTRIBUTE(WITHOUT DEFAULTS)
      
       BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)    
       END INPUT
      CONSTRUCT g_wc ON tc_mss01,tc_mss18,tc_mss19,tc_mss02,imz01
        FROM tc_mss01,tc_mss18,tc_mss19,s_tc_mss[1].tc_mss02,s_tc_mss[1].imz01
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        #END CONSTRUCT  
        END CONSTRUCT  
         ON ACTION CONTROLP 
           CASE
             WHEN INFIELD(tc_mss01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_tc_mss01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_mss01
                  NEXT FIELD tc_mss01
                  
             WHEN INFIELD(tc_mss02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_tc_mss02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_mss02
                  NEXT FIELD tc_mss02
                  
             WHEN INFIELD(imz01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_imz1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imz01
                NEXT FIELD imz01
            END CASE                                                      
                                                                    
 
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
   #   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET g_sql="SELECT UNIQUE tc_mss01 FROM tc_mss_file",   
             " WHERE ",g_wc CLIPPED ,
             " ORDER BY tc_mss01"                     
   PREPARE q001_prepare FROM g_sql
   DECLARE q001_cs SCROLL CURSOR FOR q001_prepare   #SCROLL CURSOR
   
   #取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT count(distinct tc_mss01) FROM tc_mss_file",    
             " WHERE ",g_wc CLIPPED 
   
   PREPARE q001_pp FROM g_sql
   DECLARE q001_cnt CURSOR FOR q001_pp

END FUNCTION
 
FUNCTION q001_q()
   LET g_query = 'Y'
   LET g_filter1 = 'Y'
   LET g_row_count = 0                                                        
   LET g_curs_index = 0                                                       
   CALL cl_navigator_setting( g_curs_index, g_row_count )                    
   CALL cl_opmsg('q')
   CALL q001_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q001_cs                              # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q001_cnt
      FETCH q001_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt                           # 從DB產生合乎條件TEMP(0-30秒)
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_mss.tc_mss01,SQLCA.sqlcode,0)
         INITIALIZE g_mss.* TO NULL
      ELSE
         CALL q001_fetch('L')                  #读出最后一笔资料       
      END IF
   END IF
   MESSAGE ''
END FUNCTION

FUNCTION q001_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1      #處理方式
DEFINE l_abso   LIKE type_file.num5      #絕對的筆數
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q001_cs INTO g_mss.tc_mss01
      WHEN 'P' FETCH PREVIOUS q001_cs INTO g_mss.tc_mss01
      WHEN 'F' FETCH FIRST    q001_cs INTO g_mss.tc_mss01
      WHEN 'L' FETCH LAST     q001_cs INTO g_mss.tc_mss01
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about        
                  CALL cl_about()    
 
               ON ACTION help         
                  CALL cl_show_help() 
 
               ON ACTION controlg     
                  CALL cl_cmdask()  
               
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q001_cs INTO g_mss.tc_mss01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mss.tc_mss01,SQLCA.sqlcode,0)
      INITIALIZE g_mss.tc_mss01 TO NULL  
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
   SELECT DISTINCT tc_mss01,tc_mss18,tc_mss19,tc_mss21 INTO g_mss.*
   FROM tc_mss_file
   WHERE tc_mss01 = g_mss.tc_mss01
   CALL q001_show()
END FUNCTION
 

FUNCTION q001_show()
   LET g_action_flag = "page2" 
   DISPLAY  g_mss.* TO tc_mss01,tc_mss18,tc_mss19,tc_mss21
   CALL cl_set_field_pic("","","","","",g_mss.tc_mss18)
   CALL q001_b_fill() #單身
   CALL q001_b_fill2()
   DISPLAY g_curs_index TO FORMONLY.curs_index
   CALL cl_show_fld_cont() 
END FUNCTION

FUNCTION q001_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,
          l_oea24      LIKE oea_file.oea24,
          l_type       LIKE type_file.chr1,   
          l_sql        STRING

   LET g_sql = " SELECT tc_mst08,tc_mst03,tc_mst02,tc_mst09,ima02,ima021,tc_mst04,tc_mst05,tc_mst06,tc_mst07 ",
                 " FROM tc_mst_file LEFT OUTER JOIN ima_file ON tc_mst02=ima01 ",
                 " WHERE tc_mst02 = '",g_tc_mss[p_ac].tc_mss02,"'",
                 " AND tc_mst01 = '",g_mss.tc_mss01,"'",
                 " ORDER BY tc_mst08,tc_mst03 "

          
   PREPARE cimq001_pb_detail FROM g_sql
   DECLARE oea_curs_detail  CURSOR FOR cimq001_pb_detail        #CURSOR
   CALL g_tc_mst.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH oea_curs_detail INTO  g_tc_mst_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_tc_mst[g_cnt].* = g_tc_mst_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1  
   END FOREACH
   
   #DISPLAY ARRAY g_tc_mst TO s_tc_mst.* ATTRIBUTE(COUNT=g_rec_b2)
    IF g_cnt <= g_max_rec THEN
      CALL g_tc_mst.deleteElement(g_cnt)
   END IF
   CALL g_tc_mst_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt2a
END FUNCTION 

FUNCTION q001_new_mss()
DEFINE l_sql,l_sql1,l_sql2,l_sql3 STRING
#DEFINE l_ta_imd24     LIKE imd_file.ta_imd24 #mark by huanglf160930
DEFINE lr_sfa  RECORD LIKE sfa_file.*  
DEFINE l_rvv17        LIKE rvv_file.rvv17
DEFINE l_year,l_month,l_day LIKE type_file.chr20
DEFINE l_tc_mss RECORD LIKE tc_mss_file.*
DEFINE l_tc_mss01 LIKE tc_mss_file.tc_mss01
DEFINE l_number LIKE tc_mss_file.tc_mss01
DEFINE l_short_qty  LIKE type_file.num15_3
DEFINE l_provide LIKE type_file.num15_3
DEFINE l_need  LIKE type_file.num15_3
DEFINE l_date LIKE tc_mss_file.tc_mss19
DEFINE l_time LIKE tc_mss_file.tc_mss21
DEFINE l_tot_count LIKE type_file.num5
DEFINE l_oea01 LIKE oea_file.oea01
DEFINE l_oeb04 LIKE oeb_file.oeb04
DEFINE l_ima45 LIKE ima_file.ima45
DEFINE l_ima46 LIKE ima_file.ima46
    LET l_time = TIME
    LET l_date = g_today

    LET g_success = 'Y'
    
    CALL q001_temp_table()
   # LET g_forupd_sql = "SELECT * FROM tc_mss_file WHERE tc_mss01 = ? FOR UPDATE"
   # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   # DECLARE q001_cl CURSOR FROM g_forupd_sql
	BEGIN WORK 
    # 自动生成版本需求号
	LET l_tc_mss01 = 'PR'
	LET l_year=YEAR(g_today)
	LET l_month=MONTH(g_today)
	LET l_day=DAY(g_today)
	
	LET l_month=l_month USING '&&' 
	LET l_day=l_day USING '&&'
	
	LET l_tc_mss01='PR-' CLIPPED,l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
	SELECT MAX(substr(tc_mss01,15,4)) INTO l_number FROM tc_mss_file WHERE substr(tc_mss01,1,11)=l_tc_mss01
	IF cl_null(l_number) THEN
	   LET l_number = 0
	ELSE 
	   LET l_number = l_number + 1
	END IF 
	LET l_number = l_number USING '&&&&'
	LET  l_tc_mss01 = l_tc_mss01 CLIPPED,l_number CLIPPED
    LET  l_tc_mss01 = l_tc_mss01[1,13]
    #抓出所有备料订单
    LET l_sql3=" SELECT oea01,oeb04 ",
			     " FROM oea_file,oeb_file ",
			     " WHERE oea01 = oeb01 and oeaconf = 'Y' AND oeaud02 = '1' AND oeb12 - oebud07 - oeb24 > 0"
	  PREPARE q001_bl_pre FROM l_sql3
			   DECLARE q001_bl CURSOR FOR q001_bl_pre 
			   FOREACH q001_bl INTO l_oea01,l_oeb04
           
			   LET l_sql2=" SELECT  ima01,bmb06,bmb07,oea01,oeb04,oeb12,oeb12 - oebud07 - oeb24,oeb15,oea49 ",
			                    " FROM(SELECT bmb01,bmb02,bmb03,bmb06,bmb07,ima01",
				                " FROM bmb_file,ima_file WHERE bmb03 = ima01",
				                " AND( bmb05 IS NULL OR bmb05 >to_date('",g_today,"','yyyymmdd')) ",
				                " CONNECT BY PRIOR bmb03=bmb01 START WITH bmb01 ='",l_oeb04,"' ORDER  BY bmb02),oea_file,oeb_file",  
				                " WHERE NOT EXISTS (SELECT * FROM bmb_file WHERE bmb01 = ima01) and oea01 = oeb01 and oea01= '",l_oea01,"' and oeb04 = '",l_oeb04,"'"
			         LET l_sql = " INSERT INTO q001_temp2 ",l_sql2 CLIPPED 
			       PREPARE q001_ins2 FROM l_sql
			       EXECUTE q001_ins2
			       DISPLAY TIME 
			   END FOREACH
    SELECT COUNT (*) INTO l_tot_count FROM ima_file WHERE ima08 = 'P'
    CALL cl_progress_bar(l_tot_count)
    
	LET l_sql = "SELECT distinct '',ima01,ima02,ima021,ima25,'','','','','','','','','','',ima27,'','','','','','','','','','','','','',''",
	            " FROM ima_file WHERE ima08 = 'P' "
	PREPARE q001_new FROM l_sql
	DECLARE q001_new_mss CURSOR WITH HOLD FOR q001_new 
	FOREACH q001_new_mss INTO l_tc_mss.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL  cl_progressing(l_tc_mss.tc_mss02)
        
        LET l_tc_mss.tc_mss01 = l_tc_mss01
        #CALL s_getstock(l_tc_mss.tc_mss02,g_plant) RETURNING avl_stk_mpsmrp,unavl_stk,avl_stk
        

        #正常仓
        SELECT SUM(img10*img21) INTO l_tc_mss.tc_mss07
        FROM imd_file,img_file
       # WHERE (ta_imd24 = 'N'OR ta_imd24 IS NULL) AND img23 = 'Y'
        WHERE img23 = 'Y'  # add by huanglf160930
        AND imd01 = img02 
        AND img01 = l_tc_mss.tc_mss02
        IF cl_null(l_tc_mss.tc_mss07) THEN LET l_tc_mss.tc_mss07=0 END IF 
        
        #呆品仓
        --SELECT SUM(img10*img21) INTO l_tc_mss.tc_mss08   #mark by huanglf160930
        --FROM imd_file,img_file
        --WHERE ta_imd24 = 'Y' AND img23 = 'Y'
        --AND imd01 = img02 
        --AND img01 = l_tc_mss.tc_mss02
        IF cl_null(l_tc_mss.tc_mss08) THEN LET l_tc_mss.tc_mss08=0 END IF 
        
        #-->IQC 在驗量
        SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_tc_mss.tc_mss09
        FROM rvb_file, rva_file, pmn_file
        WHERE rvb05 = l_tc_mss.tc_mss02 AND rvb01=rva01
          AND rvb04 = pmn01 AND rvb03 = pmn02
          AND rvb07 > (rvb29+rvb30) 
          AND rvaconf='Y' #No.BANN
          AND rva10 != 'SUB' 
        IF cl_null(l_tc_mss.tc_mss09) THEN LET l_tc_mss.tc_mss09=0 END IF 
        	  
         #-->採購量
		   MESSAGE " (4)Wait..."
		   SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_tc_mss.tc_mss10      
		         FROM pmn_file, pmm_file
		        WHERE pmn04 = l_tc_mss.tc_mss02 AND pmn01 = pmm01
		          AND pmn20 > pmn50-pmn55-pmn58   #No.FUN-9A0068 
		          AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
		          AND pmn011 !='SUB'
		          AND pmm18 != 'X'
		   IF cl_null(l_tc_mss.tc_mss10) THEN LET l_tc_mss.tc_mss10=0 END IF
		   	
		    #-->請購量
			 MESSAGE " (3)Wait..."
			 SELECT SUM((pml20-pml21)*pml09) INTO l_tc_mss.tc_mss11
			       FROM pml_file, pmk_file
			      WHERE pml04 = l_tc_mss.tc_mss02 AND pml01 = pmk01
			        AND pml20 > pml21
			        AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W')
			        AND pml011 !='SUB'
			        AND pmk18 != 'X'
		 	 IF cl_null(l_tc_mss.tc_mss11) THEN LET l_tc_mss.tc_mss11=0 END IF
		   
			   #待杂收数
			   SELECT SUM (inb16) INTO l_tc_mss.tc_mss12
			   FROM　inb_file,ina_file 
			   WHERE ina01 = inb01 
			   AND inb04 = l_tc_mss.tc_mss02
			   AND ina00 = '3'
			   AND inaconf = 'Y'
			   AND inapost = 'N'
			   IF cl_null(l_tc_mss.tc_mss12) THEN LET l_tc_mss.tc_mss12=0 END IF
			   	
			   #待杂发数
			   SELECT SUM (inb16) INTO l_tc_mss.tc_mss13
			   FROM　inb_file,ina_file 
			   WHERE ina01 = inb01 
			   AND inb04 = l_tc_mss.tc_mss02
			   AND ina00 = '1'
			   AND inaconf = 'Y'
			   AND inapost = 'N'
			   IF cl_null(l_tc_mss.tc_mss13) THEN LET l_tc_mss.tc_mss13=0 END IF

				 #-->工單備料量 
			   LET l_tc_mss.tc_mss14 = 0    			   
			   LET l_sql = "SELECT sfa_file.*",
			                "  FROM sfb_file,sfa_file",
			                "   WHERE sfa03 = '",l_tc_mss.tc_mss02,"'",
			                "   AND sfb01 = sfa01",
			                "   AND sfb04 !='8'",
			                "   AND sfb87!='X'",
			                "   AND sfb02 != '15'"
			   PREPARE q001_sum_pre FROM l_sql
			   DECLARE q001_sum CURSOR FOR q001_sum_pre 
			   FOREACH q001_sum INTO lr_sfa.*
			      CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
			                      lr_sfa.sfa12,lr_sfa.sfa27,
			                      lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066 #TQC-A80005
			           RETURNING l_short_qty 
			      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF                            
			      IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ l_short_qty- lr_sfa.sfa063+ lr_sfa.sfa065 -lr_sfa.sfa062)) OR (l_short_qty > 0) THEN 
			         LET l_rvv17 = 0                                                                               
			         SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file WHERE rvv18=lr_sfa.sfa01 AND rvv31=lr_sfa.sfa03  
			         IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF                                               
			         LET l_tc_mss.tc_mss14= l_tc_mss.tc_mss14 + ((lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063-lr_sfa.sfa062+l_rvv17)*lr_sfa.sfa13) 
			      END IF        	      
			   END FOREACH		
			   	   	
			   #备料需求数tc_mss15
        
                
             #   LET l_sql1 =" SELECT DISTINCT oeb04,oeb12 - oebud07 - oeb24 ",
             #               " FROM oeb_file,oea_file ", 
             #               " WHERE oea01 = oeb01 ",
             #               " AND oeaud02 = '1' ",
             #               " AND oeaconf = 'Y'",
             #               " AND oeb12 - oebud07 - oeb24 > 0 "
             #   LET l_sql = " INSERT INTO q001_temp1 ",l_sql1 CLIPPED  
             #   PREPARE q001_ins1 FROM l_sql
             #   EXECUTE q001_ins1
             #   DISPLAY TIME 
			   
			
	       
            SELECT sum(l_no_cx * bmb06 / bmb07 ) INTO l_tc_mss.tc_mss15
            FROM q001_temp2
            WHERE ima01 = l_tc_mss.tc_mss02
            IF cl_null(l_tc_mss.tc_mss15) THEN LET l_tc_mss.tc_mss15=0 END IF 

            #建议采购量
            LET l_provide = l_tc_mss.tc_mss07 + l_tc_mss.tc_mss08 + l_tc_mss.tc_mss09 + l_tc_mss.tc_mss10+l_tc_mss.tc_mss11 + l_tc_mss.tc_mss12
            LET l_need = l_tc_mss.tc_mss13 + l_tc_mss.tc_mss14 + l_tc_mss.tc_mss15 + l_tc_mss.tc_mss16
            LET l_tc_mss.tc_mss06 = l_need - l_provide  
            IF l_tc_mss.tc_mss06 < 0 THEN LET l_tc_mss.tc_mss06 = 0 END IF 

            SELECT ima45,ima46 INTO l_ima45,l_ima46
            FROM ima_file
            WHERE  ima01 = l_tc_mss.tc_mss02       
            IF  l_tc_mss.tc_mss06 < l_ima46 THEN 
               LET  l_tc_mss.tc_mss06 =l_ima46
            END IF 
            LET  l_tc_mss.tc_mss06 = s_digqty(l_tc_mss.tc_mss06,l_ima45)

	       #只有该版本的资料有效，其他都无效
            LET l_tc_mss.tc_mss18 = 'Y'
            LET l_tc_mss.tc_mss19 = l_date 
            LET l_tc_mss.tc_mss21 = l_time 

            #OPEN q001_cl USING l_tc_mss.tc_mss01
            #IF STATUS THEN
            #  CALL cl_err("OPEN q001_cl:", STATUS, 1)
            #  CLOSE q001_cl
            #  ROLLBACK WORK
            #  RETURN
            #END IF

            # FETCH q001_cl INTO l_tc_mss.*         # 鎖住將被更改或取消的資料
            # IF SQLCA.sqlcode THEN
            #  CALL cl_err(l_tc_mss.tc_mss01,SQLCA.sqlcode,0)     # 資料被他人LOCK
            #  CLOSE q001_cl
            #  ROLLBACK WORK
            #  RETURN
            #END IF
            
            INSERT INTO tc_mss_file VALUES l_tc_mss.*
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("ins","tc_mss_file",l_tc_mss.tc_mss01,"",SQLCA.sqlcode,"","",0)   
               ROLLBACK WORK  
            END IF       
          CALL q001_new_mst(l_tc_mss.*)
   END FOREACH   
    IF g_success = 'Y' THEN
     UPDATE tc_mss_file SET tc_mss18 = 'N' WHERE tc_mss01 <> l_tc_mss01
     IF SQLCA.sqlcode  THEN
        CALL cl_err3("upd","tc_mss_file",l_tc_mss.tc_mss01,"",SQLCA.sqlcode,"","",0)   
        ROLLBACK WORK  
     END IF 
    END IF 
     # 自动生成版本需求号
	LET l_tc_mss01 = 'PR'
	LET l_year=YEAR(g_today)
	LET l_month=MONTH(g_today)
	LET l_day=DAY(g_today)
	
	LET l_month=l_month USING '&&' 
	LET l_day=l_day USING '&&'
	
	LET l_tc_mss01='PR-' CLIPPED,l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
	SELECT MAX(substr(tc_mss01,15,4)) INTO l_number FROM tc_mss_file WHERE substr(tc_mss01,1,11)=l_tc_mss01
	IF cl_null(l_number) THEN
	   LET l_number = 0
	ELSE 
	   LET l_number = l_number + 1
	END IF 
	LET l_number = l_number USING '&&&&'
	LET  l_tc_mss01 = l_tc_mss01 CLIPPED,l_number CLIPPED
    UPDATE tc_mss_file SET tc_mss01 = l_tc_mss01 WHERE tc_mss01 = l_tc_mss.tc_mss01
     IF SQLCA.sqlcode  THEN
        CALL cl_err3("upd","tc_mss_file",l_tc_mss01,"",SQLCA.sqlcode,"","",0)   
        ROLLBACK WORK  
     END IF 
    UPDATE tc_mst_file SET tc_mst01 = l_tc_mss01 WHERE tc_mst01 = l_tc_mss.tc_mss01
     IF SQLCA.sqlcode  THEN
        CALL cl_err3("upd","tc_mst_file",l_tc_mss01,"",SQLCA.sqlcode,"","",0)   
        ROLLBACK WORK  
     END IF 
      #CLOSE q001_cl
      COMMIT WORK 
  # DROP TABLE q001_temp1;
   DROP TABLE q001_temp2;
   # DROP TABLE q001_temp3;
END FUNCTION

FUNCTION q001_new_mst(p_tc_mss)
    DEFINE l_oeb04 LIKE oeb_file.oeb04
    DEFINE l_no_cx LIKE type_file.num15_3
    DEFINE l_oeb12 LIKE oeb_file.oeb12
    DEFINE lr_sfa  RECORD LIKE sfa_file.*  
    DEFINE l_rvv17 LIKE rvv_file.rvv17
    DEFINE p_tc_mss RECORD LIKE tc_mss_file.*
    DEFINE l_tc_mss RECORD LIKE tc_mss_file.*
    DEFINE l_tc_mst RECORD LIKE tc_mst_file.*
    DEFINE l_sql,l_sql1,l_sql2,l_sql3 STRING 
    DEFINE l_short_qty  LIKE type_file.num15_3
    LET l_tc_mss.* = p_tc_mss.*
	#工单
    LET l_sql = " select '',sfa03,sfb01,sfa05,'',sfb13,sfb04,'',sfb05,'','','','','',''",
                " from sfa_file,sfb_file",
                " where sfa01 = sfb01",
                " and sfb04 <> '8'",
                " and sfa03 = '",l_tc_mss.tc_mss02,"'"
                
    PREPARE q001_mst1 FROM l_sql
	DECLARE q001_cur_mst1 CURSOR WITH HOLD FOR q001_mst1 
	FOREACH q001_cur_mst1 INTO l_tc_mst.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF            
        LET l_tc_mst.tc_mst08 = '1'
        LET l_tc_mst.tc_mst01 = l_tc_mss.tc_mss01  
        LET l_tc_mst.tc_mst05 = 0    			   
        LET l_sql = " SELECT sfa_file.*",
                    "  FROM sfb_file,sfa_file",
                    "   WHERE sfa03 = '",l_tc_mst.tc_mst02,"'",
                    "   AND sfa01 = '",l_tc_mst.tc_mst03,"'",
                    "   AND sfb01 = sfa01",
                    "   AND sfb04 !='8'",
                    "   AND sfb87!='X'",
                    "   AND sfb02 != '15'"
        PREPARE q001_mst_pre FROM l_sql
        DECLARE q001_mst CURSOR FOR q001_mst_pre 
        FOREACH q001_mst INTO lr_sfa.*
          CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                          lr_sfa.sfa12,lr_sfa.sfa27,
                          lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066 #TQC-A80005
               RETURNING l_short_qty 
          IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF                            
          IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ l_short_qty- lr_sfa.sfa063+ lr_sfa.sfa065 -lr_sfa.sfa062)) OR (l_short_qty > 0) THEN 
             LET l_rvv17 = 0                                                                               
             SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file WHERE rvv18=lr_sfa.sfa01 AND rvv31=lr_sfa.sfa03  
             IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF                                               
             LET l_tc_mst.tc_mst05= l_tc_mst.tc_mst05 + ((lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063-lr_sfa.sfa062+l_rvv17)*lr_sfa.sfa13) 
          END IF        	      
       END FOREACH		

       INSERT INTO tc_mst_file VALUES l_tc_mst.*
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("ins","tc_mst_file",l_tc_mst.tc_mst01,l_tc_mst.tc_mst02,l_tc_mst.tc_mst03,SQLCA.sqlcode,"",0)   
          ROLLBACK WORK  
       END IF       
    END FOREACH		     	
    #备料订单
	       
	#LET l_sql = " SELECT  distinct '',ima01,oea01,sum(oeb12 * bmb06 / bmb07 ),sum(l_no_cx * bmb06 / bmb07 ),oeb15,oea49,'','','','','','','','' ",
   #             " FROM(SELECT bmb01,bmb02,bmb03,bmb06,bmb07,ima01,oea01,oeb15,oea49 ",
   #             " FROM bmb_file,ima_file,q001_temp3 WHERE bmb03 = ima01 and ima01 = oeb04 ",
   #             " AND( bmb05 IS NULL OR bmb05 >to_date('",g_today,"','yyyymmdd')) ",
   #             " CONNECT BY PRIOR bmb03=bmb01 START WITH bmb01 ='",l_tc_mss.tc_mss02,"' ORDER BY bmb02) ",
   #             " WHERE NOT EXISTS (SELECT * FROM bmb_file WHERE bmb01 = ima01) ",
   #             " GROUP BY ima01,oea01,oeb15,oea49" 
    LET l_sql = " SELECT distinct '',ima01,oea01,sum(oeb12 * bmb06 / bmb07 ),sum(l_no_cx * bmb06 / bmb07 ),oeb15,oea49,'',oeb04,'','','','','',''",
                " FROM q001_temp2",
                " WHERE ima01 ='",l_tc_mss.tc_mss02,"'",
                " group by ima01,oea01,oeb15,oea49,oeb04"
    PREPARE q001_mst2 FROM l_sql
	 DECLARE q001_cur_mst2 CURSOR WITH HOLD FOR q001_mst2 
	 FOREACH q001_cur_mst2 INTO l_tc_mst.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF 
        IF  l_tc_mst.tc_mst07 = '1' THEN LET l_tc_mst.tc_mst07 = '9' END IF 
        LET l_tc_mst.tc_mst08 = '2'
	    LET l_tc_mst.tc_mst01 = l_tc_mss.tc_mss01
        
	 INSERT INTO tc_mst_file VALUES l_tc_mst.*
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("ins","tc_mst_file",l_tc_mst.tc_mst01,l_tc_mst.tc_mst02,l_tc_mst.tc_mst03,SQLCA.sqlcode,"",0)   
          ROLLBACK WORK  
       ELSE 
       	 LET g_success = 'Y'
       END IF    	            
    END FOREACH      	   
	#杂发单 
    LET l_sql = " select '', inb04,ina01,inb16,inb16,ina02,ina08,'',inb04,'','','','','',''",
                " from ina_file,inb_file",
                " where ina01 = inb01",
                " and ina00 = '1'",
                " AND inaconf = 'Y'",
                " AND inapost = 'N'",
                " and inb04 = '",l_tc_mss.tc_mss02,"'"
                
    PREPARE q001_mst3 FROM l_sql
	DECLARE q001_cur_mst3 CURSOR WITH HOLD FOR q001_mst3
	FOREACH q001_cur_mst3 INTO l_tc_mst.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF      
    IF  l_tc_mst.tc_mst07 = '1' THEN LET l_tc_mst.tc_mst07 = '9' END IF 
	LET l_tc_mst.tc_mst08 = '3'
	LET l_tc_mst.tc_mst01 = l_tc_mss.tc_mss01
	INSERT INTO tc_mst_file VALUES l_tc_mst.*
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("ins","tc_mst_file",l_tc_mst.tc_mst01,l_tc_mst.tc_mst02,l_tc_mst.tc_mst03,SQLCA.sqlcode,"",0)   
          ROLLBACK WORK  
       ELSE 
       	 LET g_success = 'Y'
       END IF    
    END FOREACH 
   
END FUNCTION
FUNCTION q001_temp_table()

	 CREATE TEMP TABLE q001_temp2(
                    ima01 LIKE ima_file.ima01,
                    bmb06 LIKE bmb_file.bmb06,
                    bmb07 LIKE bmb_file.bmb07,
                    oea01 LIKE oea_file.oea01,
                    oeb04 LIKE oeb_file.oeb04,
                    oeb12 LIKE oeb_file.oeb12,
                    l_no_cx LIKE type_file.num15_3,
                    oeb15  LIKE oeb_file.oeb15,
                    oea49  LIKE oea_file.oea49);
                    
     CREATE TEMP TABLE q001_bl_temp(
                    oea01 LIKE oea_file.oea01,
                    oeb04 LIKE oeb_file.oeb04,
                    ima01 LIKE ima_file.ima01
                );                
END FUNCTION

FUNCTION q001_out()
   DEFINE l_cmd         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_prog        LIKE zz_file.zz01,      #No.FUN-680136 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
          l_prtway      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_lang        LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) #No:6715可選擇列印(0.中文/1.英文/2.簡體)
   DEFINE l_pmc911      LIKE pmc_file.pmc911   #FUN-610028
   DEFINE l_conp        LIKE type_file.chr1     #FUN-B60074
 
   IF cl_null(g_mss.tc_mss01) THEN
      CALL cl_err('','-400',1)  #MOD-640492 0->1
      RETURN
   END IF
      LET l_prog = NULL 
      MENU ""
         ON ACTION prt_po_80
            LET l_prog='cpmr003' #FUN-C30085 add
            EXIT MENU
 
         ON ACTION prt_po_132
            LET l_prog='cpmr004' #FUN-C30085 add
            EXIT MENU
 
 
         ON ACTION EXIT
              LET g_action_choice="exit"
              EXIT MENU
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
            
         ON ACTION CANCEL 
            LET g_action_choice= NULL 
            EXIT MENU 
           
          -- for Windows close event trapped
          #COMMAND KEY(INTERRUPT)
          #      LET INT_FLAG=FALSE             #MOD-570244      mars
          #    LET g_action_choice = "exit"
          #    EXIT MENU
 
      END MENU

   IF NOT cl_null(l_prog) THEN #BugNo:5548
      LET l_wc='tc_mss01="',g_mss.tc_mss01,'"'

      LET l_cmd = l_prog CLIPPED,
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"

      CALL cl_cmdrun(l_cmd)
   END IF
 
END FUNCTION