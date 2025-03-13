# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmq990
# Descriptions...: 客戶對賬單
# Date & Author..: 12/10/22 NO.FUN-C90076 By fengrui

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING, 
                 bdate  LIKE type_file.dat,
                 edate  LIKE type_file.dat,                 
                 a      LIKE type_file.chr1,
                 b      LIKE type_file.chr1,
                 c      LIKE type_file.chr1,
                 sty    LIKE type_file.chr1
              END RECORD       
   DEFINE g_sql           STRING                                                                                    
   DEFINE g_str           STRING    
   DEFINE g_filter_wc     STRING
   DEFINE g_filter_wc1    STRING
   DEFINE g_wc            STRING
   DEFINE g_rec_b         LIKE type_file.num10
   DEFINE g_cnt           LIKE type_file.num10                  
   DEFINE g_oga          DYNAMIC ARRAY OF RECORD  
                oga03a      LIKE oga_file.oga03,   #账款客户编号
                oga032a     LIKE oga_file.oga032,  #账款客户简称
                oga18a      LIKE oga_file.oga18,   #收款客户编号
                occ18a      LIKE occ_file.occ18,   #收款客户全称
                occ03a      LIKE occ_file.occ03,   #客户分类
                oca02a      LIKE oca_file.oca02,   #分类说明
                oga15a      LIKE oga_file.oga15,   #部门编号
                gem02a      LIKE gem_file.gem02,   #部门名称  
                oga14a      LIKE oga_file.oga14,   #业务员编号
                gen02a      LIKE gen_file.gen02,   #姓名
                tot_ogb917  LIKE ogb_file.ogb917,  #总数量
                tot_ogb14   LIKE ogb_file.ogb14,   #本币未税金额
                tot_ogb14_t LIKE ogb_file.ogb14t,  #本币税额
                tot_ogb14t  LIKE ogb_file.ogb14t   #本币含税金额
                         END RECORD

    DEFINE g_ogb          DYNAMIC ARRAY OF RECORD  
                oga03       LIKE oga_file.oga03,   #账款客户
                oga032      LIKE oga_file.oga032,  #客户简称
                oga18       LIKE oga_file.oga18,   #收款客户编号
                occ18       LIKE occ_file.occ18,   #收款客户全称 根据oga18抓 occ18/occ19
                oga02       LIKE oga_file.oga02,   #出货日期
                ogb01       LIKE ogb_file.ogb01,   #出(退)货单号
                ogb03       LIKE ogb_file.ogb03,   #项次
                ogb04       LIKE ogb_file.ogb04,   #料号
                ogb06       LIKE ogb_file.ogb06,   #品名
                ima021      LIKE ima_file.ima021,  #规格
                oga211      LIKE oga_file.oga211,  #税率
                ogb916      LIKE ogb_file.ogb916,  #单位
                ogb917      LIKE ogb_file.ogb917,  #数量
                ogb13_1     LIKE ogb_file.ogb13,   #未税单价    
                ogb14_1     LIKE ogb_file.ogb14,   #未税金额
                ogb14_t_1   LIKE ogb_file.ogb14t,  #税额 
                ogb14t_1    LIKE ogb_file.ogb14t,  #含税金额
                oga23       LIKE oga_file.oga23,   #币种
                oga24       LIKE oga_file.oga24,   #汇率
                ogb13       LIKE ogb_file.ogb13,   #原币未税单价
                ogb14       LIKE ogb_file.ogb14,   #原币未税金额
                ogb14_t_2   LIKE ogb_file.ogb14t,  #原币税额
                ogb14t      LIKE ogb_file.ogb14t,  #原币含税金额
                ogb14t_2    LIKE ogb_file.ogb14t,  #本币含税金额
                ogb12       LIKE ogb_file.ogb12,
                ogb60       LIKE ogb_file.ogb60,
                ogb1013_1   LIKE ogb_file.ogb1013,
                ogb1013     LIKE ogb_file.ogb1013,
                ogb12_1     LIKE ogb_file.ogb12,
                ogb60_1     LIKE ogb_file.ogb60,
                ogb60_2     LIKE ogb_file.ogb60,   
                occ03       LIKE occ_file.occ03,   #客户分类
                oca02       LIKE oca_file.oca02,   #分类说明
                oga15       LIKE oga_file.oga15,   #部门编号
                gem02       LIKE gem_file.gem02,   #部门名称
                oga14       LIKE oga_file.oga14,   #业务员编号
                gen02       LIKE gen_file.gen02,   #姓名
                ogb1012     LIKE ogb_file.ogb1012, #赠品否
                oea10       LIKE oea_file.oea10,   #客户订单号   #more
                ogb11       LIKE ogb_file.ogb11,   #客户料号     #more
                oga99       LIKE oga_file.oga99    #多角贸易流程序号
                         END RECORD
   DEFINE g_ogb_excel    DYNAMIC ARRAY OF RECORD
                oga03       LIKE oga_file.oga03,   #账款客户
                oga032      LIKE oga_file.oga032,  #客户简称
                oga18       LIKE oga_file.oga18,   #收款客户编号
                occ18       LIKE occ_file.occ18,   #收款客户全称 根据oga18抓 occ18/occ19
                oga02       LIKE oga_file.oga02,   #出货日期
                ogb01       LIKE ogb_file.ogb01,   #出(退)货单号
                ogb03       LIKE ogb_file.ogb03,   #项次
                ogb04       LIKE ogb_file.ogb04,   #料号
                ogb06       LIKE ogb_file.ogb06,   #品名
                ima021      LIKE ima_file.ima021,  #规格
                oga211      LIKE oga_file.oga211,  #税率
                ogb916      LIKE ogb_file.ogb916,  #单位
                ogb917      LIKE ogb_file.ogb917,  #数量
                ogb13_1     LIKE ogb_file.ogb13,   #未税单价    
                ogb14_1     LIKE ogb_file.ogb14,   #未税金额
                ogb14_t_1   LIKE ogb_file.ogb14t,  #税额 
                ogb14t_1    LIKE ogb_file.ogb14t,  #含税金额
                oga23       LIKE oga_file.oga23,   #币种
                oga24       LIKE oga_file.oga24,   #汇率
                ogb13       LIKE ogb_file.ogb13,   #原币未税单价
                ogb14       LIKE ogb_file.ogb14,   #原币未税金额
                ogb14_t_2   LIKE ogb_file.ogb14t,  #原币税额
                ogb14t      LIKE ogb_file.ogb14t,  #原币含税金额
                ogb14t_2    LIKE ogb_file.ogb14t,  #本币含税金额
                ogb12       LIKE ogb_file.ogb12,
                ogb60       LIKE ogb_file.ogb60,
                ogb1013_1   LIKE ogb_file.ogb1013,
                ogb1013     LIKE ogb_file.ogb1013,
                ogb12_1     LIKE ogb_file.ogb12,
                ogb60_1     LIKE ogb_file.ogb60,
                ogb60_2     LIKE ogb_file.ogb60,
                occ03       LIKE occ_file.occ03,   #客户分类
                oca02       LIKE oca_file.oca02,   #分类说明
                oga15       LIKE oga_file.oga15,   #部门编号
                gem02       LIKE gem_file.gem02,   #部门名称
                oga14       LIKE oga_file.oga14,   #业务员编号
                gen02       LIKE gen_file.gen02,   #姓名
                ogb1012     LIKE ogb_file.ogb1012, #赠品否
                oea10       LIKE oea_file.oea10,   #客户订单号
                ogb11       LIKE ogb_file.ogb11,   #客户料号
                oga99       LIKE oga_file.oga99    #多角贸易流程序号
                         END RECORD                 
   TYPE sr_t            RECORD
                oga03       LIKE oga_file.oga03,   #账款客户
                oga032      LIKE oga_file.oga032,  #客户简称
                oga18       LIKE oga_file.oga18,   #收款客户编号
                occ18       LIKE occ_file.occ18,   #收款客户全称 根据oga18抓 occ18/occ19
                oga02       LIKE oga_file.oga02,   #出货日期
                ogb01       LIKE ogb_file.ogb01,   #出(退)货单号
                ogb03       LIKE ogb_file.ogb03,   #项次
                ogb04       LIKE ogb_file.ogb04,   #料号
                ogb06       LIKE ogb_file.ogb06,   #品名
                ima021      LIKE ima_file.ima021,  #规格
                oga211      LIKE oga_file.oga211,  #税率
                ogb916      LIKE ogb_file.ogb916,  #单位
                ogb917      LIKE ogb_file.ogb917,  #数量
                ogb13_1     LIKE ogb_file.ogb13,   #未税单价    
                ogb14_1     LIKE ogb_file.ogb14,   #未税金额
                ogb14_t_1   LIKE ogb_file.ogb14t,  #税额 
                ogb14t_1    LIKE ogb_file.ogb14t,  #含税金额
                oga23       LIKE oga_file.oga23,   #币种
                oga24       LIKE oga_file.oga24,   #汇率
                ogb13       LIKE ogb_file.ogb13,   #原币未税单价
                ogb14       LIKE ogb_file.ogb14,   #原币未税金额
                ogb14_t_2   LIKE ogb_file.ogb14t,  #原币税额
                ogb14t      LIKE ogb_file.ogb14t,  #原币含税金额
                ogb14t_2    LIKE ogb_file.ogb14t,  #本币含税金额
                ogb12       LIKE ogb_file.ogb12,
                ogb60       LIKE ogb_file.ogb60,
                ogb1013_1   LIKE ogb_file.ogb1013,
                ogb1013     LIKE ogb_file.ogb1013,
                ogb12_1     LIKE ogb_file.ogb12,
                ogb60_1     LIKE ogb_file.ogb60,
                ogb60_2     LIKE ogb_file.ogb60,
                occ03       LIKE occ_file.occ03,   #客户分类
                oca02       LIKE oca_file.oca02,   #分类说明
                oga15       LIKE oga_file.oga15,   #部门编号
                gem02       LIKE gem_file.gem02,   #部门名称
                oga14       LIKE oga_file.oga14,   #业务员编号
                gen02       LIKE gen_file.gen02,   #姓名
                ogb1012     LIKE ogb_file.ogb1012, #赠品否
                oea10       LIKE oea_file.oea10,   #客户订单号
                ogb11       LIKE ogb_file.ogb11,   #客户料号
                oga99       LIKE oga_file.oga99    #多角贸易流程序号
                         END RECORD 
   DEFINE g_sum_ogb917      LIKE ogb_file.ogb917,
          g_y_ogb14         LIKE ogb_file.ogb14,
          g_y_ogb14_t       LIKE ogb_file.ogb14t,
          g_y_ogb14t        LIKE ogb_file.ogb14t,
          g_b_ogb14         LIKE ogb_file.ogb14,
          g_b_ogb14_t       LIKE ogb_file.ogb14t,
          g_b_ogb14t        LIKE ogb_file.ogb14t
          
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    
   DEFINE l_ac,l_ac1     LIKE type_file.num5
   DEFINE l_ac_t         LIKE type_file.num5
   DEFINE g_tot_qty      LIKE type_file.num20_6      #出貨數量總計
   DEFINE g_tot_sum      LIKE type_file.num20_6      #出貨本幣金額總計
   DEFINE g_cmd          LIKE type_file.chr1000  
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
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q990_w AT 5,10
        WITH FORM "axm/42f/axmq990" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)
   #tianry add 170108
   LET g_max_rec=30000

   #tianry add end 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oga03.oga_file.oga03,     oga032.oga_file.oga032, ",
               "oga18.oga_file.oga18,     occ18.occ_file.occ18,   ",
               "oga02.oga_file.oga02,     ogb01.ogb_file.ogb01,   ",
               "ogb03.ogb_file.ogb03,     ogb04.ogb_file.ogb04,   ",
               "ogb06.ogb_file.ogb06,     ima021.ima_file.ima021, ",
               "ogb916.ogb_file.ogb916,   ogb917.ogb_file.ogb917, ",
               "oga23.oga_file.oga23,     oga24.oga_file.oga24,   ",
               "ogb13.ogb_file.ogb13,     ogb14.ogb_file.ogb14,   ",
               "ogb14_t.ogb_file.ogb14t,  ogb14t.ogb_file.ogb14t, ",
               "ogb12_1.ogb_file.ogb12,   ogb60_2.ogb_file.ogb60 "
   LET l_table = cl_prt_temptable('axmq990',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN RETURN END IF  # Temp Table產生
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   #------------------------------ CR (2) ------------------------------#
  { LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )"

   PREPARE insert_prep_cr FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep_cr:',status,1)
      #CALL cl_gre_drop_temptable(l_table)
      RETURN
   END IF}

   CALL q990_table()
   
   CALL q990_q()   
   CALL q990_menu()
   DROP TABLE axmq990_tmp;
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
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_oga),'','')
                  WHEN 'page2'
                     LET page = f.FindNode("Page","info")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogb_excel),'','')
               END CASE
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "oga03"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q990_b_fill()
   LET g_sql = "SELECT DISTINCT oga03,oga032,oga18,occ18,occ03,oca02,oga15,gem02,oga14,gen02,SUM(ogb917),SUM(ogb14_1),SUM(ogb14_t_1),SUM(ogb14t_1) ",
               "  FROM axmq990_tmp ",
               " GROUP BY oga03,oga032,oga18,occ18,occ03,oca02,oga15,gem02,oga14,gen02",
               " ORDER BY oga03,oga18,oga15,oga14"
   PREPARE axmq990_pb FROM g_sql
   DECLARE oga_curs  CURSOR FOR axmq990_pb        #CURSOR

   CALL g_oga.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH oga_curs INTO  g_oga[g_cnt].*       #g_oga_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #SELECT SUM(ogb917),SUM(ogb14_1),SUM(ogb14_t_1),SUM(ogb14t_1)
      #  INTO g_oga[g_cnt].tot_ogb917,g_oga[g_cnt].tot_ogb14,g_oga[g_cnt].tot_ogb14_t,g_oga[g_cnt].tot_ogb14t
      #  FROM axmq990_tmp     
      # WHERE oga03 = g_oga[g_cnt].oga03a
      #   AND oga18 = g_oga[g_cnt].oga18a
      #   AND oga15 = g_oga[g_cnt].oga15a
      #   AND oga14 = g_oga[g_cnt].oga14a
      #   AND ogb01[1,1] NOT LIKE '*'
      LET g_cnt = g_cnt + 1
   END FOREACH
   SELECT SUM(ogb917),SUM(ogb14),SUM(ogb14_t_2),SUM(ogb14t),
          SUM(ogb14_1),SUM(ogb14_t_1),SUM(ogb14t_1)
     INTO g_sum_ogb917,g_y_ogb14,g_y_ogb14_t,g_y_ogb14t,g_b_ogb14,g_b_ogb14_t,g_b_ogb14t     
     FROM axmq990_tmp      
    WHERE ogb01[1,1] NOT LIKE '*'  #free
   CALL g_oga.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION

FUNCTION q990_b_fill_2()

   CALL g_ogb.clear()
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
   DISPLAY g_sum_ogb917 TO FORMONLY.sum_ogb917
   DISPLAY g_y_ogb14    TO FORMONLY.y_ogb14
   DISPLAY g_y_ogb14_t  TO FORMONLY.y_ogb14_t
   DISPLAY g_y_ogb14t   TO FORMONLY.y_ogb14t
   DISPLAY g_b_ogb14    TO FORMONLY.b_ogb14
   DISPLAY g_b_ogb14_t  TO FORMONLY.b_ogb14_t
   DISPLAY g_b_ogb14t   TO FORMONLY.b_ogb14t
   DISPLAY ARRAY g_oga  TO s_oga.* ATTRIBUTE(COUNT=g_rec_b)
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
            CALL q990_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page1", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1", TRUE)
            LET g_flag = '1'
        END IF
        LET g_action_choice= "page2"
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
   DISPLAY g_sum_ogb917 TO FORMONLY.sum_ogb917
   DISPLAY g_y_ogb14    TO FORMONLY.y_ogb14
   DISPLAY g_y_ogb14_t  TO FORMONLY.y_ogb14_t
   DISPLAY g_y_ogb14t   TO FORMONLY.y_ogb14t
   DISPLAY g_b_ogb14    TO FORMONLY.b_ogb14
   DISPLAY g_b_ogb14_t  TO FORMONLY.b_ogb14_t
   DISPLAY g_b_ogb14t   TO FORMONLY.b_ogb14t
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b)
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
   LET g_sum_ogb917= '' 
   LET g_y_ogb14   = ''
   LET g_y_ogb14_t = ''
   LET g_y_ogb14t  = ''
   LET g_b_ogb14   = ''
   LET g_b_ogb14_t = ''
   LET g_b_ogb14t  = '' 
   CALL g_oga.clear()
   CALL g_ogb.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   LET g_filter_wc =''
   LET g_filter_wc1 = ''
   LET g_wc = ''
   LET tm.wc2 = ''
   LET tm.a = 'Y'   
   LET tm.b = 'N'
   LET tm.c = 'N' 
   LET tm.sty ='1'
   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT tm.bdate,tm.edate,tm.a,tm.b,tm.c,tm.sty FROM bdate,edate,a,b,c,sty ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)  
      END INPUT

      CONSTRUCT tm.wc2 ON oga03,oga18,oga15,oga14
                     FROM s_oga[1].oga03a,s_oga[1].oga18a,
                          s_oga[1].oga15a,s_oga[1].oga14a
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      ON ACTION controlp
         CASE
            WHEN INFIELD(oga03a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oga03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga03a
               NEXT FIELD oga03a
            WHEN INFIELD(oga18a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_oga18"
               LET g_qryparam.form ="q_oga19"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga18a
               NEXT FIELD oga18a
            WHEN INFIELD(oga15a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oga15a"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga15a
               NEXT FIELD oga15a
            WHEN INFIELD(oga14a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oga14a"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga14a
               NEXT FIELD oga14a
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
   DISPLAY tm.bdate,tm.edate,tm.a,tm.b,tm.c,tm.sty TO bdate,edate,a,b,c,sty
   CALL q990_b_fill_2()
   CALL q990_b_fill()  
   LET g_action_choice = "page1"
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   LET g_action_flag = "page1"
   CALL q990_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q990_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CONSTRUCT l_wc ON oga03,oga18,oga15,oga14
                FROM s_oga[1].oga03a,s_oga[1].oga18a,
                     s_oga[1].oga15a,s_oga[1].oga14a

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(oga03a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oga03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga03a
               NEXT FIELD oga03a
            WHEN INFIELD(oga18a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_oga18"
               LET g_qryparam.form ="q_oga19"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga18a
               NEXT FIELD oga18a
            WHEN INFIELD(oga15a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oga15a"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga15a
               NEXT FIELD oga15a
            WHEN INFIELD(oga14a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oga14a"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oga14a
               NEXT FIELD oga14a
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
      LET g_filter_wc1 = ''
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
   LET g_filter_wc1 = g_filter_wc
   LET g_filter_wc1 = cl_replace_str(g_filter_wc1,'oga18','oha04')
   LET g_filter_wc1 = cl_replace_str(g_filter_wc1,'oga','oha')
  
END FUNCTION

FUNCTION q990_table()
   CREATE TEMP TABLE axmq990_tmp(
                oga03       LIKE oga_file.oga03,
                oga032      LIKE oga_file.oga032,
                oga18       LIKE oga_file.oga18,
                occ18       LIKE occ_file.occ18,
                oga02       LIKE oga_file.oga02,
                ogb01       LIKE ogb_file.ogb01,
                ogb03       LIKE ogb_file.ogb03,
                ogb04       LIKE ogb_file.ogb04,
                ogb06       LIKE ogb_file.ogb06,
                ima021      LIKE ima_file.ima021,
                oga211      LIKE oga_file.oga211,
                ogb916      LIKE ogb_file.ogb916,
                ogb917      LIKE ogb_file.ogb917,
                ogb13_1     LIKE ogb_file.ogb13,
                ogb14_1     LIKE ogb_file.ogb14,
                ogb14_t_1   LIKE ogb_file.ogb14t,
                ogb14t_1    LIKE ogb_file.ogb14t,
                oga23       LIKE oga_file.oga23,
                oga24       LIKE oga_file.oga24,
                ogb13       LIKE ogb_file.ogb13,
                ogb14       LIKE ogb_file.ogb14,
                ogb14_t_2   LIKE ogb_file.ogb14t,
                ogb14t      LIKE ogb_file.ogb14t,
                ogb14t_2    LIKE ogb_file.ogb14t,
                ogb12       LIKE ogb_file.ogb12,
                ogb60       LIKE ogb_file.ogb60,   
                ogb1013_1   LIKE ogb_file.ogb1013, 
                ogb1013     LIKE ogb_file.ogb1013, 
                ogb12_1     LIKE ogb_file.ogb12,   
                ogb60_1     LIKE ogb_file.ogb60,   
                ogb60_2     LIKE ogb_file.ogb60,   
                occ03       LIKE occ_file.occ03,
                oca02       LIKE oca_file.oca02,
                oga15       LIKE oga_file.oga15,
                gem02       LIKE gem_file.gem02,
                oga14       LIKE oga_file.oga14,
                gen02       LIKE gen_file.gen02,
                ogb1012     LIKE ogb_file.ogb1012,
                oea10       LIKE oea_file.oea10, 
                ogb11       LIKE ogb_file.ogb11,   
                oga99       LIKE oga_file.oga99,
                ogb31       LIKE ogb_file.ogb31,
                ogb32       LIKE ogb_file.ogb32,
                oga65       LIKE oga_file.oga65,
                type        LIKE type_file.chr1   
                );   
END FUNCTION 

FUNCTION q990()
DEFINE l_sql      STRING                
DEFINE sr,sr_t    sr_t
DEFINE l_occ19    LIKE occ_file.occ19
DEFINE l_oga09    LIKE oga_file.oga09
DEFINE l_oga213   LIKE oga_file.oga213
DEFINE l_oay11    LIKE oay_file.oay11
DEFINE l_slip     LIKE smy_file.smyslip
DEFINE l_n        LIKE type_file.num5
DEFINE l_wc       STRING
DEFINE l_ogb31    LIKE ogb_file.ogb31
DEFINE l_ogb32    LIKE ogb_file.ogb32
DEFINE l_oga65    LIKE oga_file.oga65
DEFINE l_ogb12    LIKE ogb_file.ogb12
DEFINE l_wc1      STRING
DEFINE l_type     LIKE type_file.chr1
                  
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   LET g_wc = tm.wc2
   LET g_wc = cl_replace_str(g_wc,'oga18','oha04')
   LET g_wc = cl_replace_str(g_wc,'oga','oha')
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   IF cl_null(g_filter_wc1) THEN LET g_filter_wc1 = " 1=1" END IF 
   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
   IF cl_null(tm.wc2) THEN LET tm.wc2 = " 1=1" END IF

   DELETE FROM axmq990_tmp
   #free--mark--str--
   #LET g_sql = "INSERT INTO axmq990_tmp",
   #            " VALUES(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,",
   #            "        ?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,",
   #            "        ?,?,?,?,?,   ?,?,?,?,?, ?)" 
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN                                     
   #   DROP TABLE axmq990_tmp;
   #   CALL cl_err('insert_prep:',status,1)
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time        
   #   EXIT PROGRAM                                                                                                                 
   #END IF
   #free--mark--end--

   IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
      LET l_wc = "oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
   END IF
   IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
      LET l_wc = "oga02 <= '",tm.edate,"'"
   END IF
   IF NOT cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
      LET l_wc = "oga02 >= '",tm.bdate,"'"
   END IF
   IF cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
      LET l_wc = " 1=1 "
   END IF
   LET l_wc1 = cl_replace_str(l_wc,'oga','oha')   #銷退
   IF cl_null(l_wc1) THEN LET l_wc1 = " 1=1" END IF

   LET l_sql = "SELECT DISTINCT oga03,oga032,oga18,'' occ18,oga02,ogb01,ogb03,ogb04,ogb06,ima021, ",  
               "       oga211,ogb916,ogb917,'' ogb13_1,'' ogb14_1,'' ogb14_t_1,'' ogb14t_1,oga23,oga24,ogb13, ",
               "       ogb14,ogb14t-ogb14 ogb14_t_2,ogb14t,'' ogb14t_2,'' ogb12,ogb60,'' ogb1013_1,ogb1013,'' ogb12_1,'' ogb60_1, ",
               "       '' ogb60_2,occ03,oca02,oga15,gem02,oga14,gen02,ogb1012,oea10,ogb11, ",
               "       oga99,ogb31,ogb32,oga65,'A' type",
               "  FROM oga_file LEFT OUTER JOIN occ_file ON occ01 = oga03 ", 
               "                LEFT OUTER JOIN oca_file ON oca01 = occ03 ",
               "                LEFT OUTER JOIN gem_file ON gem01 = oga15 ",
               "                LEFT OUTER JOIN gen_file ON gen01 = oga14 ",
               "      ,ogb_file LEFT OUTER JOIN oea_file ON oea01 = ogb31 ",
               "                LEFT OUTER JOIN ima_file ON ima01 = ogb04 ",
               " WHERE oga01 = ogb01 ",
               "   AND ",l_wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND ",g_filter_wc CLIPPED,
               "   AND oga09 IN ('2','3','4','6') AND ogaconf<>'X' AND oga55<>'9' ",
               " UNION ",
               " SELECT DISTINCT oha03,oha032,oha04,'',oha02,ohb01,ohb03,ohb04,ohb06,ima021, ",
               "        oha211,ohb916,ohb917,'','','','',oha23,oha24,ohb13, ",
               "        ohb14,ohb14t-ohb14,ohb14t,'','',ohb60,'',ohb1012,'','', ",
               "        '',occ03,oca02,oha15,gem02,oha14,gen02,ohb1004,oea10,ohb11, ",
               "        oha99,ohb33,ohb34,'','B'",
               "   FROM oha_file LEFT OUTER JOIN occ_file ON occ01 = oha03 ", 
               "                 LEFT OUTER JOIN oca_file ON oca01 = occ03 ",
               "                 LEFT OUTER JOIN gem_file ON gem01 = oha15 ",
               "                 LEFT OUTER JOIN gen_file ON gen01 = oha14 ",
               "       ,ohb_file LEFT OUTER JOIN oea_file ON oea01 = ohb33 ",
               "                 LEFT OUTER JOIN ima_file ON ima01 = ohb04 ",
               " WHERE oha01 = ohb01 ",
               "   AND ",l_wc1 CLIPPED,
               "   AND ",g_wc CLIPPED,
               "   AND ",g_filter_wc1 CLIPPED  

   LET l_sql = " INSERT INTO axmq990_tmp SELECT  x.* FROM (",l_sql CLIPPED,") x "
   PREPARE q990_ins FROM l_sql
   EXECUTE q990_ins

   #ogb917 如果有签收单则取签收数量，如果没有签收单(包括应该签收而未签收)则以出货单数量为准 
   LET l_sql = " MERGE INTO axmq990_tmp o ",
               "      USING (SELECT ogb01,SUM(ogb12) ogb12_sum FROM oga_file,ogb_file ", 
               "              WHERE oga01=ogb01 AND oga09='8'  ",
               "              GROUP BY ogb01 ) n ",
               "         ON (o.ogb01 = n.ogb01 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb917 = NVL(n.ogb12_sum,0) "
   PREPARE q003_pre1 FROM l_sql
   EXECUTE q003_pre1

   LET l_sql = " UPDATE axmq990_tmp o ",
              #"    SET o.occ18 = (SELECT concat(concat(n.occ18,' '),n.occ19) FROM occ_file n ", #FUN-C90076 xh
               "    SET o.occ18 = (SELECT ((n.occ18||' ')||n.occ19) FROM occ_file n ",    #FUN-C90076 xh
               "                    WHERE n.occ01=o.oga18) "
   PREPARE q003_pre2 FROM l_sql
   EXECUTE q003_pre2

   LET l_sql = " UPDATE axmq990_tmp  ",
               "    SET ogb13_1 = ogb13 * oga24, ",
               "        ogb14_1 = ogb14 * oga24, ",
               "        ogb14_t_1 = (ogb14t-ogb14) * oga24, ",
               "        ogb14t_1 = ogb14t * oga24, ",
               "        ogb14t_2 = ogb14t * oga24 " 
   PREPARE q003_pre3 FROM l_sql
   EXECUTE q003_pre3

   LET l_sql = " MERGE INTO axmq990_tmp o ",
               "      USING (SELECT oga01,oga213 FROM oga_file WHERE oga213='Y' ) n ",
               "         ON (o.ogb01 = n.oga01 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb13=o.ogb13/(1+o.oga211/100), ",
               "           o.ogb13_1=o.ogb13_1/(1+o.oga211/100) "
   PREPARE q003_pre4 FROM l_sql
   EXECUTE q003_pre4

   LET l_sql = " UPDATE axmq990_tmp  ",
               "    SET ogb917 = ogb917 * -1, ",
               "        ogb13_1 = ogb13_1 * -1, ",
               "        ogb14_1 = ogb14_1 * -1, ",
               "        ogb14_t_1 = ogb14_t_1 * -1, ",
               "        ogb14t_1 = ogb14t_1 * -1, ",
               "        ogb13 = ogb13 * -1, ",
               "        ogb14 = ogb14 * -1, ",
               "        ogb14_t_2 = ogb14_t_2 * -1, ",
               "        ogb14t = ogb14t * -1, ",
               "        ogb14t_2 = ogb14t_2 * -1, ",
               "        ogb12 = 0, ",
               "        ogb60 = 0, ",
               "        ogb1013_1 = 0, ",
               "        ogb1013 = 0, ",
               "        ogb12_1 = 0, ",
               "        ogb60_1 = 0, ",
               "        ogb60_2 = 0  ",
               "  WHERE type = 'B' "
   PREPARE q003_pre5 FROM l_sql
   EXECUTE q003_pre5
   
   LET l_sql = " UPDATE axmq990_tmp o ",
               "    SET o.ogb01 = (SELECT '*'||x.ogb01  FROM ogb_file x,oay_file  ",
               "                    WHERE x.ogb01=o.ogb01 AND oay11='N' ",
               "                      AND substr(x.ogb01,0,instr(x.ogb01,'-')-1)=oayslip  ) ",
               "  WHERE EXISTS(SELECT * FROM ogb_file y,oay_file  ",
               "                WHERE y.ogb01=o.ogb01 AND oay11='N' ",
               "                  AND substr(y.ogb01,0,instr(y.ogb01,'-')-1)=oayslip  ) "
   PREPARE q003_pre6
   FROM l_sql
   EXECUTE q003_pre6
   
   LET l_sql = " MERGE INTO axmq990_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum FROM oga_file,ogb_file ", 
               "              WHERE oga01=ogb01 AND ogapost = 'Y' AND oga09 = '8'  ",
               "              GROUP BY ogb31,ogb32 ) n ",
               "         ON (o.ogb31 = n.ogb31 AND o.ogb32 = n.ogb32 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb12 = n.ogb12_sum, ",
               "           o.ogb12_1 = NVL(NVL(n.ogb12_sum,0)-o.ogb60,0) ",
               "     WHERE o.oga65 = 'Y' "
   PREPARE q003_pre7 FROM l_sql
   EXECUTE q003_pre7

   LET l_sql = " MERGE INTO axmq990_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum FROM oga_file,ogb_file ", 
               "              WHERE oga01=ogb01 AND ogapost='Y' AND oga09 IN ('2','4','6') ",
               "              GROUP BY ogb31,ogb32 ) n ",
               "         ON (o.ogb31 = n.ogb31 AND o.ogb32 = n.ogb32 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb12 = 0, ",
               "           o.ogb12_1 = NVL(NVL(n.ogb12_sum,0)-o.ogb60,0) ",
               "     WHERE o.oga65 = 'N' "
   PREPARE q003_pre8 FROM l_sql
   EXECUTE q003_pre8

   LET l_sql = " UPDATE axmq990_tmp  ",
               "    SET ogb1013_1 = NVL(ogb1013 * oga24,0), ",
               "        ogb60_1 = NVL(ogb12_1 * ogb13_1,0), ",
               "        ogb60_2 = NVL(ogb12_1 * ogb13,0) "
   PREPARE q003_pre9 FROM l_sql
   EXECUTE q003_pre9
   #free--mark--str--
   #FOREACH q990_curs INTO sr.*,l_ogb31,l_ogb32,l_oga65,l_type
   #   IF STATUS THEN 
   #      CALL cl_err('foreach:',STATUS,1) 
   #      EXIT FOREACH 
   #   END IF
   #   #ogb917 如果有签收单则取签收数量，如果没有签收单(包括应该签收而未签收)则以出货单数量为准
   #   LET l_oga09 = ''
   #   SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01 = sr.ogb01
   #   IF l_oga09 = '8' THEN 
   #      SELECT SUM(ogb12) INTO sr.ogb917 FROM ogb_file WHERE ogb01 = sr.ogb01
   #   END IF 
   #   #occ18
   #   SELECT occ18,occ19 INTO sr.occ18,l_occ19 FROM occ_file WHERE occ01 = sr.oga18
   #   LET sr.occ18 = sr.occ18,l_occ19 
   #   #occ03 oca02
   #   SELECT occ03 INTO sr.occ03 FROM occ_file WHERE occ01 = sr.oga03 
   #   SELECT oca02 INTO sr.oca02 FROM oca_file WHERE oca01 = sr.occ03
   #   #ima021
   #   SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01 = sr.ogb04
   #   #gem02 gen02
   #   SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.oga15
   #   SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.oga14   

   #   # ogb13_1 ogb14_1 ogb14_t_1 ogb14t_1 ogb14t_2
   #   SELECT oga213 INTO l_oga213 FROM oga_file WHERE oga01 = sr.ogb01
   #   IF l_oga213 = 'Y' THEN  #若为含税
   #      LET sr.ogb13 = sr.ogb13/(1+sr.oga211/100)
   #      LET sr.ogb13_1 = sr.ogb13 * sr.oga24/(1+sr.oga211/100)
   #   ELSE 
   #      LET sr.ogb13_1 = sr.ogb13 * sr.oga24
   #   END IF 
   #   LET sr.ogb14_1 = sr.ogb14 * sr.oga24
   #   LET sr.ogb14_t_1 = (sr.ogb14t-sr.ogb14) * sr.oga24
   #   LET sr.ogb14t_1 = sr.ogb14t * sr.oga24
   #   LET sr.ogb14t_2 = sr.ogb14t * sr.oga24
#  #   SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01 = sr.ogb01   #簽退不考慮--lixh1
#  #   SELECT count(*) INTO l_n  FROM ohb_file WHERE ohb31 = sr.ogb01
#  #   IF l_oga09 = '9' OR l_n >= 1 THEN  #9.客户验退单  ohb_file 销退单 
   #   IF l_type = 'B'THEN      #銷退單  --lixh1
   #      LET sr.ogb917 = -1 * sr.ogb917
   #      LET sr.ogb13_1 = -1 * sr.ogb13_1
   #      LET sr.ogb14_1 = -1 * sr.ogb14_1
   #      LET sr.ogb14_t_1 = -1 * sr.ogb14_t_1
   #      LET sr.ogb14t_1 = -1 * sr.ogb14t_1
   #      LET sr.ogb13 = -1 * sr.ogb13
   #      LET sr.ogb14 = -1 * sr.ogb14
   #      LET sr.ogb14_t_2 = -1 * sr.ogb14_t_2
   #      LET sr.ogb14t = -1 * sr.ogb14t
   #      LET sr.ogb14t_2 = -1 * sr.ogb14t_2
   #      LET sr.ogb12 = 0
   #      LET sr.ogb60 = 0
   #      LET sr.ogb1013_1 = 0
   #      LET sr.ogb1013 = 0
   #      LET sr.ogb12_1 = 0
   #      LET sr.ogb60_1 = 0
   #      LET sr.ogb60_2 = 0
   #   END IF
   #   CALL s_get_doc_no(sr.ogb01) RETURNING l_slip #单据别提取
   #   SELECT DISTINCT oay11 INTO l_oay11 FROM oay_file WHERE oayslip=l_slip 
   #   IF l_oay11 = 'N' THEN 
   #      LET sr.ogb01 = '*',sr.ogb01
   #   END IF
   #   IF l_oga65 = 'Y' THEN   #走簽收   #lixh1
   #      SELECT SUM(ogb12) INTO sr.ogb12 FROM oga_file,ogb_file
   #       WHERE ogb31 = l_ogb31 AND ogb32 = l_ogb32
   #         AND oga01 = ogb01
   #         AND ogapost = 'Y' AND oga09 = '8'  #已過帳
   #      IF cl_null(sr.ogb12) THEN LET sr.ogb12 = 0 END IF
   #      LET sr.ogb12_1 = sr.ogb12 - sr.ogb60
   #   ELSE  #不走簽收
   #      LET sr.ogb12 = 0
   #      SELECT SUM(ogb12) INTO l_ogb12 FROM ogb_file,oga_file    #出貨數量
   #       WHERE ogb31=l_ogb31 AND ogb32=l_ogb32
   #         AND ogb01=oga01 AND ogapost='Y' AND oga09 IN ('2','4','6')
   #      LET sr.ogb12_1 = l_ogb12 - sr.ogb60
   #   END IF
   #   IF cl_null(sr.ogb12_1) THEN LET sr.ogb12_1 = 0 END IF
   #   LET sr.ogb1013_1 = sr.ogb1013 * sr.oga24
   #   IF cl_null(sr.ogb1013_1) THEN LET sr.ogb1013_1 = 0 END IF
   #   LET sr.ogb60_1 = sr.ogb12_1 * sr.ogb13_1
   #   IF cl_null(sr.ogb60_1) THEN LET sr.ogb60_1 = 0 END IF
   #   LET sr.ogb60_2 = sr.ogb12_1 * sr.ogb13
   #   IF cl_null(sr.ogb60_2) THEN LET sr.ogb60_2 = 0 END IF
   #   EXECUTE insert_prep USING sr.* 
   #END FOREACH 
   #free--mark--end--
END FUNCTION 

FUNCTION q990_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING

   LET l_sql = "SELECT oga03,oga032,oga18,occ18,oga02,ogb01,ogb03,ogb04,ogb06,ima021, ",
               "       oga211,ogb916,ogb917,ogb13_1,ogb14_1,ogb14_t_1,ogb14t_1,oga23,oga24,ogb13,",
               "       ogb14,ogb14_t_2,ogb14t,ogb14t_2,ogb12,ogb60,ogb1013_1,ogb1013,ogb12_1,ogb60_1,",
               "       ogb60_2,occ03,oca02,oga15,gem02,oga14,gen02,ogb1012,oea10,ogb11,",
               "       oga99,ogb31 ",
               " FROM axmq990_tmp "
   PREPARE q990_pb FROM l_sql
   DECLARE q990_curs1 CURSOR FOR q990_pb
   FOREACH q990_curs1 INTO g_ogb_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN
         LET g_ogb[g_cnt].* = g_ogb_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY 
   
   IF g_cnt <= 	g_max_rec THEN
      CALL g_ogb.deleteElement(g_cnt)
   END IF
   CALL g_ogb_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION  

FUNCTION q990_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,
          l_oga24      LIKE oga_file.oga24,
          l_type       LIKE type_file.chr1,
          l_sql        STRING

   LET l_sql = "SELECT oga03,oga032,oga18,occ18,oga02,ogb01,ogb03,ogb04,ogb06,ima021, ",
               "       oga211,ogb916,ogb917,ogb13_1,ogb14_1,ogb14_t_1,ogb14t_1,oga23,oga24,ogb13,",
               "       ogb14,ogb14_t_2,ogb14t,ogb14t_2,ogb12,ogb60,ogb1013_1,ogb1013,ogb12_1,ogb60_1,",
               "       ogb60_2,occ03,oca02,oga15,gem02,oga14,gen02,ogb1012,oea10,ogb11,",
               "       oga99,ogb31 ",
               "  FROM axmq990_tmp ",
               " WHERE oga03 = '",g_oga[p_ac].oga03a,"'",  #账款客户编号
               "   AND oga18 = '",g_oga[p_ac].oga18a,"'",  #收款客户编号
               "   AND oga15 = '",g_oga[p_ac].oga15a,"'",  #部门编号
               "   AND oga14 = '",g_oga[p_ac].oga14a,"'",  #人员编号
               " ORDER BY oga03 "
   PREPARE axmq990_pb_detail FROM l_sql
   DECLARE ogb_curs_detail  CURSOR FOR axmq990_pb_detail   #CURSOR
   CALL g_ogb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH ogb_curs_detail INTO g_ogb_excel[g_cnt].*                 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_ogb[g_cnt].* = g_ogb_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_ogb.deleteElement(g_cnt)
   END IF
   CALL g_ogb_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   SELECT SUM(ogb917),SUM(ogb14),SUM(ogb14_t_2),SUM(ogb14t),
          SUM(ogb14_1),SUM(ogb14_t_1),SUM(ogb14t_1)
     INTO g_sum_ogb917,g_y_ogb14,g_y_ogb14_t,g_y_ogb14t,g_b_ogb14,g_b_ogb14_t,g_b_ogb14t
     FROM axmq990_tmp
    WHERE ogb01[1,1] NOT LIKE '*'     #free
      AND oga03 = g_oga[p_ac].oga03a  #账款客户编号
      AND oga18 = g_oga[p_ac].oga18a  #收款客户编号
      AND oga15 = g_oga[p_ac].oga15a  #部门编号
      AND oga14 = g_oga[p_ac].oga14a  #人员编号
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q990_set_visible()
   DEFINE l_wc     LIKE type_file.chr20
   CALL cl_set_comp_visible("ogb13_1,ogb14_1,ogb14_t_1,ogb14t_1,oga23,oga24,
                             ogb13,ogb14,ogb14_t_2,ogb14t,ogb14t_2,oea10,ogb11,ogb1013_1,ogb60_1,ogb1013,ogb60_2",TRUE) 
   CALL cl_set_comp_visible("ogb13_1,ogb14_1,ogb14_t_1,ogb14t_1,ogb1013_1,ogb60_1",tm.a='N')
   CALL cl_set_comp_visible("oga23,oga24,ogb13,ogb14,ogb14_t_2,ogb14t,ogb14t_2,ogb1013,ogb60_2",tm.a='Y')
   CALL cl_set_comp_visible("y_ogb14,y_ogb14_t,y_ogb14t",tm.a='Y')
   CALL cl_set_comp_visible("oea10",tm.b='Y')
   CALL cl_set_comp_visible("ogb11",tm.c='Y')
END FUNCTION 

FUNCTION q990_cr()
DEFINE sr1  RECORD
          oga03     LIKE oga_file.oga03,
          oga032    LIKE oga_file.oga032,
          oga18     LIKE oga_file.oga18,     
          occ18     LIKE occ_file.occ18,
          oga02     LIKE oga_file.oga02,     
          ogb01     LIKE ogb_file.ogb01,
          ogb03     LIKE ogb_file.ogb03,     
          ogb04     LIKE ogb_file.ogb04,
          ogb06     LIKE ogb_file.ogb06,   
          ima021    LIKE ima_file.ima021,
          ogb916    LIKE ogb_file.ogb916,     
          ogb917    LIKE ogb_file.ogb917,
          oga23     LIKE oga_file.oga23,     
          oga24     LIKE oga_file.oga24,
          ogb13     LIKE ogb_file.ogb13,    
          ogb14     LIKE ogb_file.ogb14,
          ogb14_t   LIKE ogb_file.ogb14t, 
          ogb14t    LIKE ogb_file.ogb14t,
          ogb12_1   LIKE ogb_file.ogb12,
          ogb60_2   LIKE ogb_file.ogb60
            END RECORD
DEFINE l_sql    STRING

   CALL cl_del_data(l_table)   #xj add
   #LET l_sql="SELECT DISTINCT oga03,oga032,oga18,occ18,oga02,ogb01,ogb03,ogb04,ogb06,ima021,",
   #          "                ogb916,ogb917,oga23,oga24,ogb13,ogb14,ogb14_t_2,ogb14t,ogb12_1,ogb60_2 ",
   #          "  FROM axmq990_tmp "

   #PREPARE axmq990_prepare1 FROM l_sql
   #IF SQLCA.sqlcode != 0 THEN
   #   CALL cl_err('prepare1:',SQLCA.sqlcode,1)
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #   RETURN
   #END IF
   #DECLARE axmq990_curs1 CURSOR FOR axmq990_prepare1
   #FOREACH axmq990_curs1 INTO sr1.*
   #   IF SQLCA.sqlcode != 0 THEN
   #      CALL cl_err('foreach:',SQLCA.sqlcode,1)
   #      EXIT FOREACH
   #   END IF
   #   EXECUTE insert_prep_cr USING sr1.*
   #END FOREACH
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT DISTINCT oga03,oga032,oga18,occ18,oga02,ogb01,ogb03,ogb04,ogb06,ima021,",
               "                ogb916,ogb917,oga23,oga24,ogb13,ogb14,ogb14_t_2,ogb14t,ogb12_1,ogb60_2 ",
               "  FROM axmq990_tmp "
   PREPARE insert_prep_cr1 FROM g_sql
   EXECUTE insert_prep_cr1

  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.bdate,";",tm.edate,";",tm.sty,";",g_sma.sma115,";",g_sma.sma116
   CALL cl_prt_cs3('axmq990','axmq990',g_sql,g_str)
   #------------------------------ CR (4) ------------------------------#               
END FUNCTION
