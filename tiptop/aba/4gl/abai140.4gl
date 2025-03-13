# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: abai140.4gl
# Descriptions...: 訂單包裝單維護作業
# Date & Author..: No:DEV-CA0004 2012/10/16 By jingll
# Modify.........: No:DEV-CB0002 12/11/07 By TSD.JIE
# 1.調整產生條碼編號abaq100
# 2.[條碼產生]執行完後請顯示:"條碼產生成功"
# 3.無控卡判斷此張訂單包裝單的單身數量合計若>0,才可按下Action 
# Modify.........: No:DEV-CC0002 12/12/06 By Nina 增加控卡判斷此張訂單包裝單的單身數量合計若>0,才可按下Action
# Modify.........: No:DEV-CC0001 12/12/07 By Mandy "條碼產生"控卡:在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
# Modify.........: No:DEV-CC0007 12/12/24 By Mandy DEV-CC0002 的調整有誤,造成單身數量合計>0的,無法按下Action
# Modify.........: No:DEV-CC0009 13/01/07 By Nina (1)判斷是否已產生條碼的SQL條件增加判斷系列(ibb09)
#                                                 (2)條碼查詢呼叫時增加參數系列(ibc08)
# Modify.........: No.DEV-D30025 13/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 調整條碼列印由參數控制
# Modify.........: No:DEV-D40016 13/04/16 By Mandy INSERT INTO ibb_file 異常
# Modify.........: No:DEV-D40015 13/04/18 By Nina  修正COMMIT錯置

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_wc,g_wc2,g_sql STRING, 
         g_forupd_sql STRING, 
         g_cnt    LIKE type_file.num5,      
         l_ac     LIKE type_file.num5,   
         l_tree_ac     LIKE type_file.num5,   
         g_rec_b    LIKE type_file.num5
DEFINE   g_i             LIKE type_file.num5 
DEFINE   g_max           LIKE type_file.num5 
DEFINE   g_buf           LIKE ima_file.ima01
DEFINE   g_row_count     LIKE type_file.num10 
DEFINE   g_argv1         LIKE type_file.chr20 
DEFINE   g_argv2         LIKE type_file.chr20 
DEFINE   g_argv3         LIKE type_file.chr20  
DEFINE   g_curs_index    LIKE type_file.num10   
DEFINE   g_str           STRING
DEFINE   g_idx           LIKE type_file.num5  
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #节点名称
          pid            LIKE ima_file.ima01,    #父节点id
          id             LIKE ima_file.ima01,    #节点id
          has_children   BOOLEAN,                #1:有子节点, null:无子节点
          expanded       BOOLEAN,                #0:不展开, 1展开
          level          LIKE type_file.num5,    #层级
          desc           LIKE type_file.chr100,
          bmb06          LIKE bmb_file.bmb06     #组成用量
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #当前节点数
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE mi_no_ask         LIKE type_file.num5
DEFINE  g_curr_idx       INTEGER 
DEFINE g_ibc     DYNAMIC ARRAY OF RECORD
               ibc02  LIKE ibc_file.ibc02,
               ibc04  LIKE ibc_file.ibc04,
               ima02_desc LIKE ima_file.ima02,
               ibc06  LIKE ibc_file.ibc06,
               ibc05  LIKE ibc_file.ibc05
                 END RECORD 
DEFINE g_ibc_t    RECORD
               ibc02  LIKE ibc_file.ibc02,
               ibc04  LIKE ibc_file.ibc04,
               ima02_desc LIKE ima_file.ima02,
               ibc06  LIKE ibc_file.ibc06,
               ibc05  LIKE ibc_file.ibc05
                 END RECORD
DEFINE g_ima02     LIKE ima_file.ima02
DEFINE g_ima021    LIKE ima_file.ima021

DEFINE g_msg       LIKE type_file.chr1000
DEFINE g_jump      LIKE type_file.num10 
DEFINE g_ibc_h     RECORD LIKE ibc_file.*        #单头变量
DEFINE l_table     STRING        #add by zhangym 110926
DEFINE g_cmd       STRING 

MAIN
   OPTIONS                            
      INPUT NO WRAP,                 
      FIELD ORDER FORM
   DEFER INTERRUPT                 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2) 
   LET g_argv3 = ARG_VAL(3)
   
   LET g_sql="ibc05.ibc_file.ibc05,",
             "ima04.gcb_file.gcb09,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ibc06.ibc_file.ibc06,",
             "ima25.ima_file.ima25,",
             "ima04_1.gcb_file.gcb09"

   LET l_table = cl_prt_temptable('abai140',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN EXIT PROGRAM END IF                #依照狀態值決定程式是否繼續
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPEN WINDOW i140_w WITH FORM "aba/42f/abai140"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()  
   
   LET g_tree_reload = "Y"      #tree是否要重新整理 Y/N  
   LET g_tree_focus_idx = 0     #focus节点index
   CALL i140_tree_fill_1(g_ibc_h.ibc01,g_ibc_h.ibc08)      #填充树结构 
   CALL i140_menu()
   CLOSE WINDOW i140_w                  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i140_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
    CLEAR FORM                             #清除畫面
    CALL g_ibc.clear()
    INITIALIZE g_tree TO NULL

    CALL cl_set_head_visible("","YES")   
 
   INITIALIZE g_ibc_h.ibc01,g_ima02,g_ima021,g_ibc_h.ibc03,
              g_ibc_h.ibc08 TO NULL
        
    CONSTRUCT BY NAME g_wc ON  ibc01,ibc03,ibc07,ibc08
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ibc01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oea05"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ibc01
                   NEXT FIELD ibc01
              WHEN INFIELD(ibc08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oba"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ibc08
                    NEXT FIELD ibc08
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
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON ibc02,ibc04,ibc05
            FROM s_ibc[1].ibc02,s_ibc[1].ibc04,s_ibc[1].ibc05
            
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)

 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ibc04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ima01"
                   CALL cl_create_qry() RETURNING g_ibc[1].ibc04
                    DISPLAY BY NAME g_ibc[1].ibc04      
                   NEXT FIELD ibc04
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT

 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  DISTINCT ibc01,ibc08 FROM ibc_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND ibc00 = '2' ",
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  ibc01,ibc08 ",
                   "  FROM ibc_file ",
                   " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND ibc00 = '2' ",
                   " ORDER BY 1"
    END IF
 
    PREPARE i140_prepare FROM g_sql
    DECLARE i140_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i140_prepare
 
    		# 取合乎條件筆數
    LET g_sql="SELECT COUNT(*) FROM (SELECT DISTINCT ibc01,ibc08 ",
              "  FROM ibc_file WHERE ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED,
              " AND ibc00 = '2' )"

    PREPARE i140_precount FROM g_sql
    DECLARE i140_count CURSOR FOR i140_precount
END FUNCTION

FUNCTION i140_menu()

DEFINE l_sql       STRING             

   WHILE TRUE
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i140_a()
              #No:DEV-CB0002--mark--begin
              #IF NOT cl_null(g_ibc_h.ibc01) AND NOT cl_null(g_ibc_h.ibc08) THEN
              #  IF g_ibc_h.ibc07 > 1 THEN 
              #       INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
              #          ibc04,ibc05,ibc06,ibc07,ibc08)
              #       VALUES('2',g_ibc_h.ibc01,1,1,g_ibc_h.ibc01,
              #          1,g_ibc_h.ibc07,g_ibc_h.ibc07,g_ibc_h.ibc08)
              #       CALL i140_b_fill()
              #  END IF 
              #  CALL i140_tree_fill_1(g_ibc_h.ibc01,g_ibc_h.ibc08)      #填充树结构
              #END IF 
              #No:DEV-CB0002--mark--end
            END IF
         
         WHEN "change_num"
            IF cl_chk_act_auth() THEN 
               CALL change_num()
              #CALL i140_b_fill()         #No:DEV-CB0002--mark
               CALL i140_b_fill(g_wc2)    #No:DEV-CB0002--add
            END IF         
         
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i140_b()
            END IF               

        #No:DEV-CB0002--mark--begin
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL i140_out()
        #   END IF
        #No:DEV-CB0002--mark--end
                        
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i140_r()
            END IF     

         WHEN "barcode_gen"     #條碼產生
             IF cl_chk_act_auth() THEN
                CALL i140_barcode_gen()
             END IF

         WHEN "barcode_query"   #條碼查詢
             IF cl_chk_act_auth() THEN
               #LET l_sql = "abaq100 '",g_ibc_h.ibc01,"' "                         #DEV-CC0009 mark
                LET l_sql = "abaq100 '",g_ibc_h.ibc01,"' "," '",g_ibc_h.ibc08,"' " #DEV-CC0009 add
               
               #DEV-CC0002 add str-----
                LET g_success = 'Y'
                CALL i140_chk_b()

                IF g_success = 'N' THEN
                   CONTINUE WHILE
                END IF
               #DEV-CC0002 add end-----

                CALL cl_cmdrun_wait(l_sql)
             END IF

         #No:DEV-CB0002--add--begin
         WHEN "barcode_output"  #條碼列印

             IF cl_chk_act_auth() THEN
                IF g_ibc_h.ibc01 IS NULL THEN
                   CALL cl_err('',-400,0)
                ELSE
                  #DEV-CC0002 add str-----
                   LET g_success = 'Y'
                   CALL i140_chk_b()

                   IF g_success = 'N' THEN
                      CONTINUE WHILE
                   END IF
                  #DEV-CC0002 add end-----

                   LET g_msg=' ibb03="',g_ibc_h.ibc01 CLIPPED,'"',
                             ' AND ibb09="',g_ibc_h.ibc08 CLIPPED,'"'
                   LET g_cmd = "abar100",
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' 'Y' '' '1'",
                       " '' '' '' '' ",
                       " '",g_msg CLIPPED,"' ",
                       #" 'D' 'H' '2'"                          #DEV-D30045--mark
                       " 'D' 'H' '",s_gen_barcode_ibd07(),"'"   #DEV-D30045--mod
                   CALL cl_cmdrun_wait(g_cmd)
                END IF
             END IF
         #No:DEV-CB0002--add--end
       
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
      END CASE
   END WHILE
END FUNCTION 

FUNCTION i140_bp(p_ud)
DEFINE   p_ud                 LIKE type_file.chr1
DEFINE   l_ibc             RECORD LIKE ibc_file.*
DEFINE   l_flg                LIKE type_file.chr1
DEFINE   l_sql                STRING
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5, 
    l_cnt           LIKE type_file.num10,
    l_oeb12	    LIKE oeb_file.oeb12,
    l_ibc06	    LIKE ibc_file.ibc06
    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
    LET g_forupd_sql = "SELECT ibc02,ibc04,ima02,ibc06,ibc05 ",
                       "FROM ibc_file,ima_file WHERE ibc04=ima01  ",
                       " AND ibc01=? AND ibc02=?  AND ibc08=? ",
                       " FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                   
    DECLARE i140_bcl CURSOR FROM g_forupd_sql
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tree TO tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR() 
           #CALL i140_b_fill()         #No:DEV-CB0002--mark
            CALL i140_b_fill(g_wc2)    #No:DEV-CB0002--add
         ###双击进单身 ####   
         ON ACTION accept
            LET l_flg='Y'
            INITIALIZE l_ibc.* TO NULL
            
            LET l_n=0 
            SELECT COUNT(*) INTO l_n FROM ibc_file 
             WHERE ibc01=g_ibc_h.ibc01
               AND ibc08=g_ibc_h.ibc08
               AND ibc04=g_tree[l_tree_ac].id        
            IF l_n>0 THEN
              #IF NOT cl_confirm('aba-007') THEN   #此料号已经选过，是否确定选择 #No:DEV-CB0002--mark
               IF NOT cl_confirm('aba-110') THEN   #此料号已经选过，是否确定选择 #No:DEV-CB0002--add
                  LET l_flg='N'
               END IF 
            END IF
            
            IF l_flg='N' THEN
               CONTINUE DIALOG
            END IF
            
            BEGIN WORK
              LET l_ibc.ibc00 = '2' 
              LET l_ibc.ibc01=g_ibc_h.ibc01
              LET l_sql = " SELECT NVL(MAX(ibc02)+1,1) ",
                          "   FROM ibc_file ",
                          "  WHERE ibc01='",g_ibc_h.ibc01,"' ",
                          "    AND ibc08 = '",g_ibc_h.ibc08,"' "
               PREPARE max_prep FROM l_sql
               EXECUTE max_prep INTO l_ibc.ibc02
              LET l_ibc.ibc03=g_ibc_h.ibc03
              LET l_ibc.ibc04=g_tree[l_tree_ac].id
              LET l_ibc.ibc05= 1
              LET l_ibc.ibc06=g_tree[l_tree_ac].bmb06
              LET l_ibc.ibc07=g_ibc_h.ibc07
              LET l_ibc.ibc08=g_ibc_h.ibc08 
              
              INSERT INTO ibc_file VALUES(l_ibc.*)
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,1)
                 LET l_flg='N'
              END IF 
              
              IF l_flg='N' THEN
                 ROLLBACK WORK
              ELSE
                 COMMIT WORK   
                #CALL i140_b_fill()         #No:DEV-CB0002--mark
                 CALL i140_b_fill(g_wc2)    #No:DEV-CB0002--add
              END IF 
               
      END DISPLAY      

    DISPLAY ARRAY g_ibc  TO s_ibc.* ATTRIBUTE(COUNT=g_rec_b)        
    
       BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
       
       BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()         
         
       ON ACTION accept
          LET g_action_choice="detail"
          EXIT DIALOG             
        
     END DISPLAY
        
      BEFORE DIALOG
        LET l_tree_ac = 1
        LET l_ac = 1

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         LET g_action_choice = 'locale'
         EXIT DIALOG 
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
      
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
         
      ON ACTION change_num
         LET g_action_choice="change_num"
         EXIT DIALOG

      ON ACTION barcode_gen
         LET g_action_choice = 'barcode_gen'
         EXIT DIALOG 

      ON ACTION barcode_query
         LET g_action_choice = 'barcode_query'
         EXIT DIALOG 

      #No:DEV-CB0002--add--begin
      ON ACTION barcode_output #條碼列印
         LET g_action_choice = 'barcode_output'
         EXIT DIALOG 
      #No:DEV-CB0002--add--end
         
      ON ACTION first
         CALL i140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1) 
           END IF
            
 
      ON ACTION previous
         CALL i140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
           END IF             
 
      ON ACTION jump
         CALL i140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF              
 
      ON ACTION next
         CALL i140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
        
      ON ACTION last
         CALL i140_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           
     #No:DEV-CB0002--mark--begin
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DIALOG                       
     #No:DEV-CB0002--mark--end
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  

 
#FUNCTION i140_b_fill()       #No:DEV-CB0002--mark
FUNCTION i140_b_fill(p_wc)    #No:DEV-CB0002--add
DEFINE p_wc  STRING           #No:DEV-CB0002--add
DEFINE l_sql STRING 
DEFINE l_n   LIKE type_file.num5

   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF #No:DEV-CB0002--add
 
   LET l_sql = "SELECT ibc02,ibc04,ima02,ibc06,ibc05 ",
               "  FROM ibc_file,ima_file WHERE ibc04 = ima01 ",
               "   AND ibc01 = '",g_ibc_h.ibc01,"' ",
               "   AND ibc08 = '",g_ibc_h.ibc08,"' ",
               "   AND ibc00 = '2' ",
               "   AND ",p_wc, #No:DEV-CB0002--add
               " ORDER BY ibc02 " 
               
   PREPARE i140_pb FROM l_sql
   DECLARE ibc_curs CURSOR FOR i140_pb
    CALL g_ibc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ibc_curs INTO g_ibc[g_cnt].*
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH 
       END IF
       LET g_cnt = g_cnt + 1    
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ibc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_cnt = 0  
  
END FUNCTION
#填充树
FUNCTION i140_tree_fill_1(p_ima01,p_ima131)
DEFINE p_level      LIKE type_file.num5,
       l_child      INTEGER
DEFINE p_ima01        LIKE ima_file.ima01  
DEFINE p_ima131        LIKE ima_file.ima131   
   INITIALIZE g_tree TO NULL
    LET p_level = 0
    LET g_idx = 0  
    
   CALL i140_tree_fill_2(NULL,p_level,p_ima01,p_ima131)    
END FUNCTION

#填充树的父亲节点
FUNCTION i140_tree_fill_2(p_pid,p_level,p_ima01,p_ima131)
DEFINE p_level           LIKE type_file.num5,
       p_pid             STRING,
       l_child           INTEGER
DEFINE p_ima01           LIKE ima_file.ima01   
DEFINE p_ima131        LIKE ima_file.ima131     
DEFINE l_loop            INTEGER
DEFINE l_ima          DYNAMIC ARRAY OF RECORD
            oeb04     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            oeb12     LIKE oeb_file.oeb12
            END RECORD
DEFINE l_cnt             LIKE type_file.num5
   LET g_sql = "SELECT oeb04,ima02,oeb12 ",
               "  FROM oeb_file,ima_file ",
               " WHERE oeb01 = '",p_ima01,"' " ,
               "   AND oeb04 = ima01 ",
               "   AND ima131= '",p_ima131,"' "
   PREPARE i140_tree_pre1 FROM g_sql
   DECLARE i140_tree_cs1 CURSOR FOR i140_tree_pre1
   LET l_loop = 1
   LET l_cnt = 1
   LET p_level = p_level + 1
   CALL l_ima.clear()
   FOREACH i140_tree_cs1 INTO l_ima[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   FREE i140_tree_cs1
   CALL l_ima.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
   IF l_cnt >0 THEN
     #填充第一级
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].expanded = 1          #0:不展, 1:展          
      LET g_tree[g_idx].name = p_ima01,':',' '       
      LET g_tree[g_idx].id = p_ima01
      LET g_tree[g_idx].pid = p_pid
      LET g_tree[g_idx].has_children = FALSE 
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].desc = ' '
      LET g_tree[g_idx].bmb06 = 1
      FOR l_loop=1 TO l_cnt
          LET g_idx = g_idx + 1
          LET g_tree[g_idx].expanded = 0          #0:不展, 1:展           
          LET g_tree[g_idx].name = l_ima[l_loop].oeb04,':',l_ima[l_loop].ima02        
          LET g_tree[g_idx].id = l_ima[l_loop].oeb04
          LET g_tree[g_idx].pid = p_ima01 
          LET g_tree[g_idx].has_children = FALSE 
          LET g_tree[g_idx].level = p_level
          LET g_tree[g_idx].desc = ' '
          LET g_tree[g_idx].bmb06 = l_ima[l_loop].oeb12
       END FOR
    END IF
END FUNCTION

#填充子节点
FUNCTION i140_tree_fill(p_pid,p_tex,p_level,p_idx)
DEFINE p_pid           LIKE ima_file.ima01              #父id
DEFINE p_tex           LIKE bma_file.bma06               
DEFINE p_level         LIKE type_file.num5               #階層
DEFINE p_idx           LIKE type_file.num5              #父的数组下标
DEFINE l_child         INTEGER 
DEFINE l_ima          DYNAMIC ARRAY OF RECORD
            ima01     LIKE ima_file.ima01 ,
            ima02     LIKE ima_file.ima02 ,
            bma06     LIKE bma_file.bma06
                      END RECORD
DEFINE l_str           STRING
DEFINE max_level       LIKE type_file.num5               #最大階層數,可避免無窮迴圈.
DEFINE l_i             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5

   LET max_level = 20          #設定最大階層數為20(和abmp611相同設定,之後改為傳參數)
   LET p_level = p_level + 1   #下一階層
   IF p_level > max_level THEN
      CALL cl_err_msg("","agl1001",max_level,0) 
      RETURN
   END IF
   LET g_sql = "SELECT bmb03,ima02,bmb29 ",
               "  FROM bmb_file,ima_file",
               " WHERE bmb01 = '",p_pid,"' AND ima01 = bmb03 ",
               "   AND bmb29 ='",p_tex,"' ", 
               " AND (bmb04 <=sysdate OR bmb04 IS NULL ) AND (bmb05 > sysdate OR bmb05 IS NULL ) "        
                    
   PREPARE i140_tree_pre2 FROM g_sql
   DECLARE i140_tree_cs2 CURSOR FOR i140_tree_pre2
   LET l_cnt = 1
   CALL l_ima.clear()
   FOREACH i140_tree_cs2 INTO l_ima[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   FREE i140_tree_cs2
   CALL l_ima.deleteelement(l_cnt) 
   LET l_cnt = l_cnt - 1
      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid
            LET g_tree[g_idx].id = l_ima[l_i].ima01
            LET g_tree[g_idx].expanded = 1      #0:不展開, 1:展開
            LET g_tree[g_idx].name =l_ima[l_i].ima01,':',l_ima[l_i].ima02
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].desc = l_ima[l_i].bma06
            
         ##写入组成用量###################
          LET g_tree[g_idx].bmb06=1
          SELECT bmb06/bmb07 INTO g_tree[g_idx].bmb06 FROM bmb_file 
                  WHERE bmb01 = g_tree[g_idx].pid
                   AND  bmb03 = g_tree[g_idx].id
                   AND bmb29 = l_ima[l_i].bma06
                   AND (bmb04 <=g_today OR bmb04 IS NULL ) AND (bmb05 > g_today OR bmb05 IS NULL ) 
         LET g_tree[g_idx].bmb06=g_tree[g_idx].bmb06*g_tree[p_idx].bmb06   #本阶用量*父料用量=最终用量         
          ###############################              
            
            SELECT COUNT(*) INTO l_child FROM bmb_file 
             WHERE bmb01 =l_ima[l_i].ima01
               AND bmb29 =  l_ima[l_i].bma06
               AND (bmb04 <=g_today OR bmb04 IS NULL ) AND (bmb05 > g_today OR bmb05 IS NULL ) 
               
            LET g_tree[g_idx].has_children = FALSE
            IF l_child > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL i140_tree_fill(g_tree[g_idx].id,g_tree[g_idx].desc,p_level,g_idx)
            END IF
          END FOR
      END IF
END FUNCTION

#No:DEV-CB0002--add--begin
FUNCTION i140_a()

   IF s_shut(0) THEN RETURN END IF

   MESSAGE ""
   INITIALIZE g_tree TO NULL
   INITIALIZE g_ibc_h.* TO NULL
   CALL g_ibc.clear()
   CLEAR FORM

   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_ibc_h.ibc00 = '2'
      LET g_ibc_h.ibc03 = 1
      LET g_ibc_h.ibc07 = 1
      LET g_ibc_h.ibc08 = ' '
      CALL i140_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         INITIALIZE g_ibc_h.* TO NULL
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_ibc_h.ibc01) OR cl_null(g_ibc_h.ibc08) THEN
         CONTINUE WHILE
      END IF

      CALL i140_tree_fill_1(g_ibc_h.ibc01,g_ibc_h.ibc08)      #填充树结构
      DISPLAY ARRAY g_tree TO tree.*
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY


      CALL g_ibc.clear()
      LET g_rec_b = 0
      IF g_ibc_h.ibc07 > 1 THEN 
         INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
                              ibc04,ibc05,ibc06,ibc07,ibc08)
         VALUES('2',g_ibc_h.ibc01,1,1,g_ibc_h.ibc01,
            1,g_ibc_h.ibc07,g_ibc_h.ibc07,g_ibc_h.ibc08)
         CALL i140_b_fill(' 1=1')
      END IF 

      CALL i140_b()                   #輸入單身

      EXIT WHILE
   END WHILE
END FUNCTION
#No:DEV-CB0002--add--end

#FUNCTION i140_a()     #No:DEV-CB0002--mark
FUNCTION i140_i(p_cmd) #No:DEV-CB0002--add
   DEFINE p_cmd    LIKE type_file.chr1 #No:DEV-CB0002--add
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_oba14  LIKE oba_file.oba14
      
   CALL cl_set_head_visible("","YES") 
  #No:DEV-CB0002--mark--begin
  #CALL cl_set_act_visible("accept,cancel", TRUE)
  #  
  #INITIALIZE g_tree TO NULL
  #INITIALIZE g_ibc_h.* TO NULL
  #CALL g_ibc.clear()  
  #CLEAR FORM
  #No:DEV-CB0002--mark--end
       
  INPUT BY NAME  g_ibc_h.ibc00,g_ibc_h.ibc01,g_ibc_h.ibc08,g_ibc_h.ibc03,g_ibc_h.ibc07 #No:DEV-CB0002--add ibc00
           WITHOUT DEFAULTS

      BEFORE INPUT 
         #No:DEV-CB0002--mark--begin
         #LET g_ibc_h.ibc03 = 1
         #LET g_ibc_h.ibc07 = 1
         #DISPLAY BY NAME g_ibc_h.ibc03,g_ibc_h.ibc07,g_ibc_h.ibc08
         #DISPLAY '2' TO ibc00     
         #No:DEV-CB0002--mark--end
        
      AFTER FIELD ibc01
         IF NOT cl_null(g_ibc_h.ibc01) THEN
            LET l_n=0
            IF NOT cl_null(g_ibc_h.ibc08) THEN
               SELECT COUNT(*) INTO l_n FROM ibc_file
                WHERE ibc01=g_ibc_h.ibc01
                  AND ibc08 = g_ibc_h.ibc08
               IF l_n>0 THEN
                 #CALL cl_err(g_ibc_h.ibc01||'--'||g_ibc_h.ibc08,'aba-004',1)  #资料重复  #No:DEV-CB0002--mark
                  CALL cl_err(g_ibc_h.ibc01||'--'||g_ibc_h.ibc08,'aba-106',1)  #资料重复  #No:DEV-CB0002--add
                  NEXT FIELD ibc01
               END IF 
            END IF 
            #No:DEV-CB0002--add--begin
            SELECT COUNT(*) INTO l_n            
              FROM oea_file
             WHERE oea01 = g_ibc_h.ibc01
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_ibc_h.ibc01,'asf-959',1)
               NEXT FIELD ibc01
            END IF
            #No:DEV-CB0002--add--end
         END IF  
         
      AFTER FIELD ibc03
         IF NOT cl_null(g_ibc_h.ibc03) THEN
            IF g_ibc_h.ibc03<=0 THEN
              #CALL cl_err('','aba-020',0) #No:DEV-CB0002--mark
               CALL cl_err('','aba-111',0) #No:DEV-CB0002--add
               NEXT FIELD ibc03
            END IF
         END IF     
           
      AFTER FIELD ibc07
         IF NOT cl_null(g_ibc_h.ibc07) THEN
            IF g_ibc_h.ibc07<=0 THEN
              #CALL cl_err('','aba-020',0) #No:DEV-CB0002--mark
               CALL cl_err('','aba-111',0) #No:DEV-CB0002--add
               NEXT FIELD ibc07
            END IF
         END IF     
 
      AFTER FIELD ibc08
         IF NOT cl_null(g_ibc_h.ibc08) THEN
            LET l_n=0
            IF NOT cl_null(g_ibc_h.ibc01) THEN
              SELECT COUNT(*) INTO l_n FROM ibc_file WHERE ibc01=g_ibc_h.ibc01
                 AND ibc08 = g_ibc_h.ibc08
              IF l_n>0 THEN
                #CALL cl_err(g_ibc_h.ibc01||'--'||g_ibc_h.ibc08,'aba-004',1)  #资料重复 #No:DEV-CB0002--mark
                 CALL cl_err(g_ibc_h.ibc01||'--'||g_ibc_h.ibc08,'aba-004',1)  #资料重复 #No:DEV-CB0002--add
                 NEXT FIELD ibc08
              END IF         
            END IF 
            LET g_buf = NULL
            SELECT oba02,oba14 INTO g_buf,l_oba14 FROM oba_file
             WHERE oba01=g_ibc_h.ibc08
            IF STATUS THEN
               CALL cl_err3("sel","oba_file",g_ibc_h.ibc08,"",STATUS,"","sel oba ",1)
               NEXT FIELD ibc08
            END IF
            IF l_oba14 IS NULL THEN LET l_oba14 = " " END IF
            IF l_oba14 <> '0' THEN
               CALL cl_err('sel oba','art-904',0)
               NEXT FIELD ibc08
            END IF
            MESSAGE g_buf CLIPPED
            DISPLAY g_buf TO oba02
         END IF

      ON ACTION controlp
         CASE  
             WHEN INFIELD(ibc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oea01"
                 LET g_qryparam.default1 = g_ibc_h.ibc01
                 CALL cl_create_qry() RETURNING g_ibc_h.ibc01
                 DISPLAY g_ibc_h.ibc01 TO ibc01
                 NEXT FIELD ibc01
             WHEN INFIELD(ibc08)
                CALL cl_init_qry_var()
                IF g_azw.azw04 = '2' THEN
                   LET g_qryparam.form ="q_oba01"
                ELSE
                   LET g_qryparam.form ="q_oba"
                END IF
                LET g_qryparam.where = "oba01 in (select oba01 from oeb_file,ima_file,oba_file where oeb04 = ima01 and ima131 = oba01 and oeb01 like '",g_ibc_h.ibc01,"%')"
                LET g_qryparam.default1 = g_ibc_h.ibc08
                CALL cl_create_qry() RETURNING g_ibc_h.ibc08
                DISPLAY BY NAME g_ibc_h.ibc08
                NEXT FIELD ibc08
         END CASE
            
      AFTER INPUT
         IF INT_FLAG THEN 
            EXIT INPUT 
         END IF    
            
   END INPUT  
      
   #No:DEV-CB0002--mark--begin
   #IF INT_FLAG THEN
   #    LET INT_FLAG = 0
   #    LET g_ibc_h.ibc01=''
   #    LET g_ibc_h.ibc08=''
   #END IF
   # CALL cl_set_act_visible("accept,cancel", FALSE)
   #No:DEV-CB0002--mark--end
END FUNCTION

FUNCTION i140_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )           
    INITIALIZE g_ibc_h.ibc01,g_ima02,g_ima021,
               g_ibc_h.ibc03,g_ibc_h.ibc07,g_ibc_h.ibc08 TO NULL           
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_ibc.clear()
    CALL i140_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN i140_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ibc_h.ibc01,g_ibc_h.ibc03,g_ima02,g_ima021,g_ibc_h.ibc07,g_ibc_h.ibc08 TO NULL
    ELSE
        OPEN i140_count
        FETCH i140_count INTO g_row_count

        CALL i140_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
END FUNCTION

FUNCTION i140_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i140_cs INTO g_ibc_h.ibc01,g_ibc_h.ibc08
        WHEN 'P' FETCH PREVIOUS i140_cs INTO g_ibc_h.ibc01,g_ibc_h.ibc08
        WHEN 'F' FETCH FIRST    i140_cs INTO g_ibc_h.ibc01,g_ibc_h.ibc08
        WHEN 'L' FETCH LAST     i140_cs INTO g_ibc_h.ibc01,g_ibc_h.ibc08
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
             FETCH ABSOLUTE g_jump i140_cs INTO g_ibc_h.ibc01,g_ibc_h.ibc08
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ibc_h.ibc01,SQLCA.sqlcode,0)
        INITIALIZE g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07,g_ibc_h.ibc08 TO NULL 
        LET g_ibc_h.ibc01 = NULL     
        LET g_ibc_h.ibc08 = NULL
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

    SELECT DISTINCT ibc01,ibc03,ibc07,ibc08  
      INTO g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07,g_ibc_h.ibc08
      FROM ibc_file 
     WHERE ibc01 = g_ibc_h.ibc01
       AND ibc08 = g_ibc_h.ibc08
       AND ibc00 = '2'
    
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oqa_file",g_ibc_h.ibc01,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07,g_ibc_h.ibc08 TO NULL
        RETURN
    END IF

    CALL i140_show()
END FUNCTION

FUNCTION i140_show()
   DEFINE
    l_gem02         LIKE gem_file.gem02,
    l_occ02         LIKE occ_file.occ02,
    l_gen02         LIKE gen_file.gen02,
    l_oba02         LIKE oba_file.oba02
 
    SELECT oba02 INTO l_oba02 FROM oba_file
              WHERE oba01=g_ibc_h.ibc08
    DISPLAY '2',g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07,g_ibc_h.ibc08,l_oba02   
         TO ibc00,ibc01,ibc03,ibc07,ibc08,oba02
 
   #CALL i140_b_fill()         #No:DEV-CB0002--mark
    CALL i140_b_fill(g_wc2)    #No:DEV-CB0002--add
    CALL i140_tree_fill_1(g_ibc_h.ibc01,g_ibc_h.ibc08)
    CALL cl_show_fld_cont()      
    DISPLAY g_curs_index TO idx
    DISPLAY g_row_count TO cnt
    DISPLAY g_rec_b TO cn2
                
END FUNCTION

FUNCTION i140_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ibc_h.ibc01 IS NULL OR g_ibc_h.ibc08 IS NULL THEN 
        CALL cl_err("",-400,0) 
        RETURN
    END IF
 
    BEGIN WORK

    CALL i140_show()
    IF cl_delh(0,0) THEN            
       DELETE FROM ibc_file WHERE ibc01 = g_ibc_h.ibc01
                              AND ibc08 = g_ibc_h.ibc08
                              AND ibc00 = '2' #No:DEV-CB0002--add
       INITIALIZE g_ibc_h.ibc01,g_ima02,g_ima021,g_ibc_h.ibc03,g_ibc_h.ibc08 TO NULL
       CLEAR FORM
       CALL g_ibc.clear()
       CALL g_tree.clear() #No:DEV-CB0002--add
    END IF
                                                                                                            
    OPEN i140_count                                                                                                                 
    FETCH i140_count INTO g_row_count                                                                                                                                                                                           
    OPEN i140_cs        
    IF g_curs_index = g_row_count + 1 THEN                                                                                          
       LET g_jump = g_row_count                                                                                                     
       CALL i140_fetch('L')                                                                                                         
    ELSE   
       LET g_jump = g_curs_index                                                                                                    
       LET mi_no_ask = TRUE                                                                                                         
       CALL i140_fetch('/')                                                                                                         
    END IF                                                                                                                          
  
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i140_b()
    DEFINE l_ac_t          LIKE type_file.num5,
           l_n             LIKE type_file.num5,
           l_lock_sw       LIKE type_file.chr1,
           p_cmd           LIKE type_file.chr1,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5, 
           l_cnt           LIKE type_file.num10 ,
           l_i             LIKE type_file.num10 ,
           l_max           LIKE type_file.num10 
    
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_ibc_h.ibc01 IS NULL OR g_ibc_h.ibc08 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF

    #No:DEV-CB0002--add--begin
    SELECT * INTO g_ibc_h.*
      FROM ibc_file
     WHERE ibc00 = '2'
      AND ibc01 = g_ibc_h.ibc01
      AND ibc08 = g_ibc_h.ibc08
    #No:DEV-CB0002--add--end
    
    LET l_allow_insert = cl_detail_input_auth("insert") #No:DEV-CB0002--add
    LET l_allow_delete = cl_detail_input_auth("delete") #No:DEV-CB0002--add

    INPUT ARRAY g_ibc  WITHOUT DEFAULTS FROM s_ibc.* 
     ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,
            INSERT ROW=FALSE,DELETE ROW=TRUE,APPEND ROW=FALSE)        
    
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
       CALL cl_set_comp_required("ibc05,ibc06",TRUE)
       
    BEFORE ROW
       LET p_cmd = ''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'
       LET l_n  = ARR_COUNT()
       IF g_rec_b >= l_ac THEN
          LET p_cmd='u'
          LET g_ibc_t.* = g_ibc[l_ac].*
          BEGIN WORK
             OPEN i140_bcl USING  g_ibc_h.ibc01,g_ibc[l_ac].ibc02,g_ibc_h.ibc08
             IF STATUS THEN
                CALL cl_err("OPEN i140_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
              ELSE  
                 FETCH i140_bcl INTO g_ibc[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ibc_t.ibc04,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                  END IF
              END IF
           CALL cl_show_fld_cont()
        END IF
        DISPLAY g_ibc[l_ac].ibc05 TO ibc05
        
       AFTER FIELD ibc05
          IF NOT cl_null(g_ibc[l_ac].ibc05) THEN
             IF g_ibc[l_ac].ibc05>g_ibc_h.ibc03 OR g_ibc[l_ac].ibc05<=0 THEN
             END IF
          END IF          
        
      AFTER FIELD ibc06
          IF NOT cl_null(g_ibc[l_ac].ibc06) THEN
             IF g_ibc[l_ac].ibc06 <=0 THEN
               #CALL cl_err('','aba-006',0)   #数量必须大于0 #No:DEV-CB0002--mark
                CALL cl_err('','aba-109',0)   #数量必须大于0 #No:DEV-CB0002--add
                NEXT FIELD ibc06 
             END IF
          END IF   
        
        
        
      ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ibc[l_ac].* = g_ibc_t.*
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ibc[l_ac].ibc04,-263,1)
               LET g_ibc[l_ac].* = g_ibc_t.*
            ELSE  
              UPDATE ibc_file SET
                     ibc05=g_ibc[l_ac].ibc05,
                     ibc06=g_ibc[l_ac].ibc06
            WHERE ibc01 = g_ibc_h.ibc01
             #AND ibc02 = g_ibc[l_ac].ibc02 #No:DEV-CB0002--mark
              AND ibc02 = g_ibc_t.ibc02 #No:DEV-CB0002--add
              AND ibc00 = '2'  
              AND ibc08 = g_ibc_h.ibc08

              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tc_fas_file",g_ibc_t.ibc04,"",SQLCA.sqlcode,"","",1) 
                 LET g_ibc[l_ac].* = g_ibc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i140_bcl
                 COMMIT WORK
              END IF 
            END IF
            
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ibc[l_ac].* = g_ibc_t.*
               END IF
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i140_bcl
            COMMIT WORK
            
        BEFORE DELETE                            #是否取消單身
            IF g_ibc[l_ac].ibc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                
                DELETE FROM ibc_file
                 WHERE  ibc01 = g_ibc_h.ibc01
                  #AND ibc02=g_ibc[l_ac].ibc02 #No:DEV-CB0002--mark
                   AND ibc02=g_ibc_t.ibc02 #No:DEV-CB0002--add
                   AND  ibc08 = g_ibc_h.ibc08                
                   AND  ibc00 = '2' #No:DEV-CB0002--add
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ibc_file",g_ibc[l_ac].ibc04,"",SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N  
                   SELECT DISTINCT ibc03 INTO g_ibc_h.ibc03 FROM ibc_file 
                    WHERE ibc01=g_ibc_h.ibc01
                      AND ibc08=g_ibc_h.ibc08
                   DISPLAY g_ibc_h.ibc03 TO ibc03 
                   COMMIT WORK
                END IF
                LET g_rec_b = g_rec_b-1
 
            END IF                        

       #No:DEV-CB0002--add--begin
       ON ACTION controls
          CALL cl_set_head_visible("","AUTO")
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
       #No:DEV-CB0002--add--end
    END INPUT

    LET g_action_choice=''

    LET l_max = ''
    SELECT MAX(ibc05) INTO l_max FROM ibc_file
     WHERE ibc01 = g_ibc_h.ibc01
       AND ibc08 = g_ibc_h.ibc08
    IF NOT cl_null(l_max) THEN
       FOR l_i = 1 TO l_max
           SELECT COUNT(*) INTO l_cnt FROM ibc_file
            WHERE ibc01 = g_ibc_h.ibc01
              AND ibc08 = g_ibc_h.ibc08
              AND ibc05 = l_i
           IF l_cnt = 0 THEN
              CALL cl_err('','aba-113',1)   #包号断号
              EXIT FOR
           END IF
       END FOR	
   
       UPDATE ibc_file SET ibc03 = l_max
        WHERE ibc01 = g_ibc_h.ibc01
          AND ibc00 = '2'   
          AND ibc08 = g_ibc_h.ibc08
       DISPLAY l_max TO ibc03
    END IF
      
END FUNCTION 

FUNCTION change_num()
  DEFINE l_n LIKE type_file.num5
  
  #DEV-CC0002 add str-----
  LET g_success = 'Y'  
  CALL i140_chk_b()   
  
  IF g_success = 'N' THEN 
     RETURN
  END IF
  #DEV-CC0002 add end-----

  LET l_n=0 
  
  IF g_ibc_h.ibc01 IS NULL OR g_ibc_h.ibc08 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN
  END IF

   SELECT COUNT(*) INTO l_n FROM tc_sfg_file
    WHERE tc_sfg002=g_ibc_h.ibc01
      AND tc_sfg003=g_ibc_h.ibc08
   IF l_n>0 THEN
     #CALL cl_err('','aba-021',0) #此料号已生成条码，不可更改总包数 #No:DEV-CB0002--mark
      CALL cl_err('','aba-112',0) #此料号已生成条码，不可更改总包数 #No:DEV-CB0002--add
      RETURN  
   END IF
   
   INPUT BY NAME  g_ibc_h.ibc03,g_ibc_h.ibc07 WITHOUT DEFAULTS
     BEFORE INPUT

    AFTER FIELD ibc03
      IF NOT cl_null(g_ibc_h.ibc03) THEN
         IF g_ibc_h.ibc03<=0 THEN
           #CALL cl_err('','aba-020',0) #No:DEV-CB0002--mark
            CALL cl_err('','aba-111',0) #No:DEV-CB0002--add
            NEXT FIELD ibc03
         END IF
      END IF

    AFTER FIELD ibc07
      IF NOT cl_null(g_ibc_h.ibc07) THEN
         IF g_ibc_h.ibc07<=0 THEN
           #CALL cl_err('','aba-020',0) #No:DEV-CB0002--mark
            CALL cl_err('','aba-111',0) #No:DEV-CB0002--add
            NEXT FIELD ibc07
         END IF
      END IF
  
    AFTER INPUT
       IF INT_FLAG THEN 
          EXIT INPUT 
       END IF    
            
    END INPUT  
      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    
    BEGIN WORK
    
    IF g_ibc_h.ibc07 > 1 THEN 
      #IF NOT cl_confirm('aba-024') THEN RETURN END IF #No:DEV-CB0002--mark
       IF NOT cl_confirm('aba-114') THEN RETURN END IF #No:DEV-CB0002--add
       DELETE FROM ibc_file
        WHERE ibc01 = g_ibc_h.ibc01
          AND ibc08 = g_ibc_h.ibc08
       INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
          ibc04,ibc05,ibc06,ibc07,ibc08)
       VALUES('2',g_ibc_h.ibc01,1,1,g_ibc_h.ibc01,  
              1,g_ibc_h.ibc07,g_ibc_h.ibc07,g_ibc_h.ibc08)
     ELSE 
       UPDATE ibc_file SET ibc03=g_ibc_h.ibc03, 
                   ibc07=g_ibc_h.ibc07    
        WHERE ibc01=g_ibc_h.ibc01
          AND ibc00='2'    
          AND ibc08=g_ibc_h.ibc08
    END IF 
    
    IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      ROLLBACK WORK
    ELSE
      MESSAGE 'update O.K'
      COMMIT WORK
    END IF
    
END FUNCTION


#No:DEV-CB0002--mark--begin
#FUNCTION i140_out()
#DEFINE
#    l_i             LIKE type_file.num5, 
#    sr              RECORD
#        ibc05   LIKE ibc_file.ibc05, 
#        ima01       LIKE ima_file.ima01,       
#        ima02       LIKE ima_file.ima02,     
#        ima021      LIKE ima_file.ima021,  
#        ibc06   LIKE ibc_file.ibc06,     
#        ima25       LIKE ima_file.ima25 
#       END RECORD,
#    l_name          LIKE type_file.chr20,  #External(Disk) file name  
#    l_za05          LIKE za_file.za05,    
#    l_azi03         LIKE azi_file.azi03,   
#    l_wc            STRING,
#    l_sql           STRING,
#    l_ima04         LIKE gcb_file.gcb09,
#    l_ima04_1       LIKE gcb_file.gcb09                
# 
#    IF cl_null(g_ibc_h.ibc01) THEN
#       CALL cl_err('','9057',0) RETURN
#    END IF
#    IF cl_null(g_wc) THEN
#       LET g_wc =" ibc01='",g_ibc_h.ibc01,"'" ," AND ibc08='",g_ibc_h.ibc08,"' "     
#       LET g_wc2=" 1=1 "   
#    END IF
# 
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
#
#    CALL cl_del_data(l_table)
#    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
#               " VALUES(?,?,?,?,?, ?,?)"   
#    PREPARE insert_prep FROM g_sql
#    IF STATUS THEN
#       CALL cl_err("insert_prep:",STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#       EXIT PROGRAM
#    END IF
#            
#        LET l_ima04_1 = NULL
#        LOCATE l_ima04_1 IN MEMORY
#        LET l_sql = "SELECT gcb09 FROM gca_file,gcb_file",
#                    " WHERE gcb_file.gcb01 = gca_file.gca07 AND gcb_file.gcb02 = gca_file.gca08",
#                    "   AND gcb_file.gcb03 = gca_file.gca09 AND gcb_file.gcb04 = gca_file.gca10",
#                    "   AND gca_file.gca01 = 'ima01=",g_ibc_h.ibc01 CLIPPED,"' AND gca_file.gca02 = ' '",  
#                    "   AND gca_file.gca03 = ' '  AND gca_file.gca04 = ' '", 
#                    "   AND gca_file.gca05 = ' ' AND gca_file.gca08 = 'FLD'", 
#                    "   AND gca_file.gca09 = 'ima04' AND gca11 = 'Y'" 
#        PREPARE tupian_pr21 FROM l_sql
#        DECLARE tupian_cs21 SCROLL CURSOR FOR tupian_pr21
#        OPEN tupian_cs21 
#        FETCH tupian_cs21 INTO l_ima04_1
#        IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ima04_1,SQLCA.sqlcode,0)  
#           CLOSE tupian_cs21 
#        END IF
#        CLOSE tupian_cs21  
#          
#    LET g_sql="SELECT ibc05,ima01,ima02,ima021,ibc06,ima25 ",   
#              "  FROM ima_file,ibc_file ",       
#              " WHERE ima01 = ibc04 AND ibc01 = '",g_ibc_h.ibc01,"' ",
#              "   AND ibc08 = '",g_ibc_h.ibc08,"' "
#                    
#    LET g_sql = g_sql CLIPPED," ORDER BY ibc01,ibc05"  
#    PREPARE i140_p1 FROM g_sql               
#    IF STATUS THEN CALL cl_err('i140_p1',STATUS,0) END IF
# 
#    DECLARE i140_co                         # CURSOR
#        CURSOR FOR i140_p1
# 
#    FOREACH i140_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        LET l_ima04 = NULL
#        LOCATE l_ima04 IN MEMORY
#        LET l_sql = "SELECT gcb09 FROM gca_file,gcb_file",
#                    " WHERE gcb_file.gcb01 = gca_file.gca07 AND gcb_file.gcb02 = gca_file.gca08",
#                    "   AND gcb_file.gcb03 = gca_file.gca09 AND gcb_file.gcb04 = gca_file.gca10",
#                    "   AND gca_file.gca01 = 'ima01=",sr.ima01 CLIPPED,"' AND gca_file.gca02 = ' '",  
#                    "   AND gca_file.gca03 = ' '  AND gca_file.gca04 = ' '", 
#                    "   AND gca_file.gca05 = ' ' AND gca_file.gca08 = 'FLD'", 
#                    "   AND gca_file.gca09 = 'ima04' AND gca11 = 'Y'" 
#        PREPARE tupian_pr2 FROM l_sql
#        DECLARE tupian_cs2 SCROLL CURSOR FOR tupian_pr2
#        OPEN tupian_cs2 
#        FETCH tupian_cs2 INTO l_ima04
#        IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ima04,SQLCA.sqlcode,0)  
#           CLOSE tupian_cs2 
#        END IF
#        CLOSE tupian_cs2
#                
#        EXECUTE insert_prep USING sr.ibc05,l_ima04,sr.ima02,sr.ima021,sr.ibc06,sr.ima25,l_ima04_1
#    END FOREACH
#
#    LET g_str = g_prog CLIPPED
#    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#    LET g_prog="abai140"   
#    CALL cl_prt_cs3('abai140','abai140',g_sql,g_str) 
# 
#    CLOSE i140_co
#    ERROR ""
#END FUNCTION
#No:DEV-CB0002--mark--end

FUNCTION i140_barcode_gen()
   DEFINE l_cnt   LIKE type_file.num5 #DEV-CC0001 add
   DEFINE l_ibc06 LIKE ibc_file.ibc06
   DEFINE l_count LIKE type_file.num5
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_iba   RECORD LIKE iba_file.*
   DEFINE l_ibb   RECORD LIKE ibb_file.*

  #DEV-CC0002 add str-----
   LET g_success = 'Y'  
   CALL i140_chk_b()   
  
   IF g_success = 'N' THEN 
      RETURN
   END IF
  #DEV-CC0002 add end-----

   LET l_ibc06 = 0 
   INITIALIZE l_iba.* TO NULL
   INITIALIZE l_ibb.* TO NULL
  
   IF cl_null(g_ibc_h.ibc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT SUM(ibc06) INTO l_ibc06 FROM ibc_file WHERE ibc01 = g_ibc_h.ibc01
                                                  AND ibc08 = g_ibc_h.ibc08 
                                                  AND ibc00 = '2'
   IF l_ibc06 = 0 THEN
      CALL cl_err('','aba-994',0)
      RETURN
   END IF  

   #DEV-CC0001 add----str---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM tlfb_file 
    WHERE tlfb01 IN (SELECT UNIQUE ibb01 FROM ibb_file 
                      WHERE ibb03 = g_ibc_h.ibc01
                        AND ibb02 = 'H'
                        AND ibb09 = g_ibc_h.ibc08)
   IF l_cnt >=1 THEN
      #在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
      CALL cl_err(g_ibc_h.ibc01,'aba-127',1)
      RETURN
   END IF
   #DEV-CC0001 add----end---

   #No:DEV-CB0002--add--begin
   LET g_success='Y'
   BEGIN WORK
   #No:DEV-CB0002--add--end
  
  #SELECT count(*) INTO l_count FROM ibb_file WHERE ibb02 = 'H' AND ibb03 = g_ibc_h.ibc01  #DEV-CC0009 mark
   SELECT count(*) INTO l_count FROM ibb_file WHERE ibb02 = 'H' AND ibb03 = g_ibc_h.ibc01 AND ibb09 = g_ibc_h.ibc08 #DEV-CC0009 add 
   IF l_count > 0 THEN
       IF NOT cl_confirm('sfb-995') THEN
          ROLLBACK WORK #No:DEV-CB0002--add
          RETURN
       END IF
       DELETE FROM iba_file WHERE iba01 IN (SELECT ibb01 FROM ibb_file
                                             WHERE ibb02 = 'H'
                                               AND ibb09 = g_ibc_h.ibc08    #DEV-CC0009 Add
                                               AND ibb03 = g_ibc_h.ibc01)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","iba_file",g_ibc_h.ibc01,'',SQLCA.sqlcode,"","",1)
          LET g_success='N' #No:DEV-CB0002--add
          ROLLBACK WORK     #No:DEV-CB0002--add
          RETURN
       END IF
      #DELETE FROM ibb_file WHERE ibb02 = 'H' AND ibb03 = g_ibc_h.ibc01                             #DEV-CC0009 mark
       DELETE FROM ibb_file WHERE ibb02 = 'H' AND ibb03 = g_ibc_h.ibc01 AND ibb09 = g_ibc_h.ibc08   #DEV-CC0009 add
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ibb_file",g_ibc_h.ibc01,'',SQLCA.sqlcode,"","",1)
          LET g_success='N' #No:DEV-CB0002--add
          ROLLBACK WORK     #No:DEV-CB0002--add
          RETURN
       END IF
   END IF
  
   FOR l_i = 1 TO g_ibc_h.ibc03
       LET l_iba.iba02 = 'D'
       LET l_iba.iba03 = g_ibc_h.ibc01
       LET l_iba.iba04 = g_ibc_h.ibc08
       LET l_iba.iba05 = l_i USING '&&'
      #LET l_iba.iba01 = "D,'",l_iba.iba03,"','",l_iba.iba04,"','",l_iba.iba05,"'"         #No:DEV-CB0002--mark
       LET l_iba.iba01 = "D",l_iba.iba03 CLIPPED,l_iba.iba04 CLIPPED,l_iba.iba05 CLIPPED   #No:DEV-CB0002--add
       INSERT INTO iba_file VALUES(l_iba.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          #CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1) #No:DEV-CB0002--mark
          #No:DEV-CB0002--add--begin
           IF g_bgerr THEN
              CALL s_errmsg('iba01',l_iba.iba01,'ins iba_file',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","iba_file",l_iba.iba01,"",SQLCA.sqlcode,"","",1)
           END IF
           LET g_success='N'
          #No:DEV-CB0002--add--end
           CONTINUE FOR
       END IF 
  
       LET l_ibb.ibb01 = l_iba.iba01
       LET l_ibb.ibb02 = 'H'
       LET l_ibb.ibb03 = g_ibc_h.ibc01
       LET l_ibb.ibb04 = 0
       LET l_ibb.ibb05 = l_i
       LET l_ibb.ibb06 = NULL
       LET l_ibb.ibb07 = 1
       LET l_ibb.ibb08 = '3'
       LET l_ibb.ibb09 = g_ibc_h.ibc08
       LET l_ibb.ibb10 = g_ibc_h.ibc03
       LET l_ibb.ibb11 = 'Y'
       LET l_ibb.ibb12 = 0
       LET l_ibb.ibbacti = 'Y'
       LET l_ibb.ibb13 = 0 #DEV-D40016 add
       INSERT INTO ibb_file VALUES(l_ibb.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          #CALL cl_err3("ins","ibb_file","","",SQLCA.sqlcode,"","",1) #No:DEV-CB0002--mark
          #No:DEV-CB0002--add--begin
           IF g_bgerr THEN
              CALL s_errmsg('ibb01',l_ibb.ibb01,'ins ibb_file',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","ibb_file",l_ibb.ibb01,"",SQLCA.sqlcode,"","",1)
           END IF
           LET g_success='N'
          #No:DEV-CB0002--add--end
          CONTINUE FOR
       END IF
       
   END FOR

   #No:DEV-CB0002--add--begin
   IF g_success='Y' THEN
      CALL cl_msgany(0,0,'aba-001')
      COMMIT WORK
   ELSE
      CALL cl_msgany(0,0,'aba-002')
     #COMMIT WORK                  #DEV-D40015 mark
      ROLLBACK WORK
   END IF
   #No:DEV-CB0002--add--end
END FUNCTION 

#DEV-CC0002 add str-----
#檢查單身是否有筆數
FUNCTION i140_chk_b()
   DEFINE l_cnt       LIKE type_file.num10

   LET l_cnt = 0 #DEV-CC0007 add
   SELECT COUNT(*) 
   INTO l_cnt 
   FROM ibc_file 
   WHERE ibc01 = g_ibc_h.ibc01 AND
        #ibc02 = g_ibc_h.ibc02 AND     #DEV-CC0007 mark
         ibc00 = '2' AND #類型:2:訂單  #DEV-CC0007 add
         ibc08 = g_ibc_h.ibc08 

   IF l_cnt = 0 THEN 
      CALL cl_err('','aba-128',0)
      LET g_success = 'N' 
   END IF
END FUNCTION 
#DEV-CC0002 add end----
#DEV-CA0004--add
#DEV-D30025--add

