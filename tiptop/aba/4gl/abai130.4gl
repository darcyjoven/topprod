# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abai130.4gl
# Descriptions...: 包裝單維護作業
# Date & Author..: No:DEV-CA0004 2012/10/16 By jingll
# Date & Author..: No:DEV-CB0002 12/11/21 By TSD.JIE
# Date & Author..: No:DEV-CC0002 12/12/06 By Nina
# Date & Author..: No.DEV-D30025 13/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# 1.錯誤訊息異常
# 2.將單頭新增段改成標準寫法
# 3.單身增加新增、修改功能

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

DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_jump         LIKE type_file.num10 
DEFINE g_ibc_h RECORD LIKE ibc_file.*        #单头变量
DEFINE l_table     STRING      

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

   LET l_table = cl_prt_temptable('abai130',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN EXIT PROGRAM END IF                #依照狀態值決定程式是否繼續
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPEN WINDOW i130_w WITH FORM "aba/42f/abai130"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()  
   
   LET g_tree_reload = "Y"      #tree是否要重新整理 Y/N  
   LET g_tree_focus_idx = 0     #focus节点index
   CALL i130_tree_fill_1(g_ibc_h.ibc01)      #填充树结构 
   CALL i130_menu()
   CLOSE WINDOW i130_w                  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i130_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
    CLEAR FORM                             #清除畫面
    CALL g_ibc.clear()
    INITIALIZE g_tree TO NULL

    CALL cl_set_head_visible("","YES")     
 
   INITIALIZE g_ibc_h.ibc01,g_ima02,g_ima021,g_ibc_h.ibc03 TO NULL  
    CONSTRUCT BY NAME g_wc ON  ibc01,ibc03,ibc07
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ibc01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ima01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ibc01
                   NEXT FIELD ibc01

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
       LET g_sql = "SELECT  DISTINCT ibc01 FROM ibc_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND ibc00 = '1' ",  
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  ibc01 ",
                   "  FROM ibc_file ",
                   " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND ibc00 = '1' ",  
                   " ORDER BY 1"
    END IF
 
    PREPARE i130_prepare FROM g_sql
    DECLARE i130_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i130_prepare
 
    		# 取合乎條件筆數
    LET g_sql="SELECT COUNT(*) FROM (SELECT DISTINCT ibc01 ",
              "  FROM ibc_file WHERE ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED,
              " AND ibc00 = '1')"

    PREPARE i130_precount FROM g_sql
    DECLARE i130_count CURSOR FOR i130_precount
END FUNCTION

FUNCTION i130_menu()
   WHILE TRUE
      CALL i130_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i130_a()
              #No:DEV-CB0002--mark--begin
              #IF NOT cl_null(g_ibc_h.ibc01) THEN
              #  IF g_ibc_h.ibc07 > 1 THEN 
              #       INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
              #          ibc04,ibc05,ibc06,ibc07)
              #       VALUES('1',g_ibc_h.ibc01,1,1,g_ibc_h.ibc01,
              #          1,g_ibc_h.ibc07,g_ibc_h.ibc07)
              #       CALL i130_b_fill()
              #  END IF 
              #  CALL i130_tree_fill_1(g_ibc_h.ibc01)      #填充树结构
              #END IF 
              #No:DEV-CB0002--mark--end
            END IF
         
         WHEN "change_num"
            IF cl_chk_act_auth() THEN
               CALL change_num()
              #CALL i130_b_fill()         #No:DEV-CB0002--mark
               CALL i130_b_fill(g_wc2)    #No:DEV-CB0002--add
            END IF         
         
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i130_b()
            END IF               

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i130_out()
            END IF          
                        
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i130_q()
            END IF
            
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i130_r()
            END IF     
       
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
      END CASE
   END WHILE
END FUNCTION 

FUNCTION i130_bp(p_ud)
DEFINE   p_ud                 LIKE type_file.chr1
DEFINE   l_ibc             RECORD LIKE ibc_file.*
DEFINE   l_flg                LIKE type_file.chr1
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5, 
    l_cnt           LIKE type_file.num10 
    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tree TO tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR()
           # CALL i130_b_init() 
           #CALL i130_b_fill()         #No:DEV-CB0002--mark
            CALL i130_b_fill(g_wc2)    #No:DEV-CB0002--add
         ###双击进单身 ####   
         ON ACTION accept
            LET l_flg='Y'
            INITIALIZE l_ibc.* TO NULL
            
            LET l_n=0 
            SELECT COUNT(*) INTO l_n FROM ibc_file WHERE ibc01=g_ibc_h.ibc01 AND ibc04=g_tree[l_tree_ac].id
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
              LET l_ibc.ibc00 = '1' 
              LET l_ibc.ibc01=g_ibc_h.ibc01
              SELECT NVL(MAX(ibc02)+1,1) INTO l_ibc.ibc02 FROM ibc_file WHERE ibc01=l_ibc.ibc01
              LET l_ibc.ibc03=g_ibc_h.ibc03
              LET l_ibc.ibc04=g_tree[l_tree_ac].id
              LET l_ibc.ibc05= 1
              LET l_ibc.ibc06=g_tree[l_tree_ac].bmb06
              LET l_ibc.ibc07=g_ibc_h.ibc07
              LET l_ibc.ibc08=' '
              
              INSERT INTO ibc_file VALUES(l_ibc.*)
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,1)
                 LET l_flg='N'
              END IF 
              
              IF l_flg='N' THEN
                 ROLLBACK WORK
              ELSE
                 COMMIT WORK  
                #CALL i130_b_fill()         #No:DEV-CB0002--mark
                 CALL i130_b_fill(g_wc2)    #No:DEV-CB0002--add
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
         
         
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1) 
           END IF
            
 
      ON ACTION previous
         CALL i130_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
           END IF             
 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF              
 
      ON ACTION next
         CALL i130_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF

         
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
                     
         
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  

 
#FUNCTION i130_b_fill()       #No:DEV-CB0002--mark
FUNCTION i130_b_fill(p_wc)    #No:DEV-CB0002--add
DEFINE p_wc  STRING           #No:DEV-CB0002--add
DEFINE l_sql STRING 
DEFINE l_n   LIKE type_file.num5

   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF #No:DEV-CB0002--add
               
   LET l_sql = "SELECT ibc02,ibc04,'',ibc06,ibc05 ",
               "  FROM ibc_file ",
               " WHERE ibc01 ='",g_ibc_h.ibc01,"' ",
               "   AND ibc00 = '1' ",   #No:DEV-CB0002--add
               "   AND ",p_wc,          #No:DEV-CB0002--add
               " ORDER BY ibc02 " 
                                             
   PREPARE i130_pb FROM l_sql
   DECLARE ibc_curs CURSOR FOR i130_pb
    CALL g_ibc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ibc_curs INTO g_ibc[g_cnt].*
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH 
       END IF
       
       SELECT ima02 INTO g_ibc[g_cnt].ima02_desc FROM ima_file WHERE ima01 = g_ibc[g_cnt].ibc04
       
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
FUNCTION i130_tree_fill_1(p_ima01)
DEFINE p_level      LIKE type_file.num5,
       l_child      INTEGER
DEFINE p_ima01        LIKE ima_file.ima01     
   INITIALIZE g_tree TO NULL
    LET p_level = 0
    LET g_idx = 0  
    
   CALL i130_tree_fill_2(NULL,p_level,p_ima01)    
END FUNCTION

#填充树的父亲节点
FUNCTION i130_tree_fill_2(p_pid,p_level,p_ima01)
DEFINE p_level           LIKE type_file.num5,
       p_pid             STRING,
       l_child           INTEGER
DEFINE p_ima01           LIKE ima_file.ima01       
DEFINE l_loop            INTEGER
DEFINE l_ima          DYNAMIC ARRAY OF RECORD
            ima01     LIKE ima_file.ima01,
            ima02     LIKE ima_file.ima02,
            bma06     LIKE bma_file.bma06
            END RECORD
DEFINE l_cnt             LIKE type_file.num5
   LET g_sql = "SELECT  bma01,ima02,bma06 ",
               "  FROM bma_file,ima_file ",
               " WHERE bma01=ima01 AND bmaacti ='Y' AND ima08 !='A' ", 
               "   AND bma01 ='",p_ima01,"' ORDER BY bma01 " 
   PREPARE i130_tree_pre1 FROM g_sql
   DECLARE i130_tree_cs1 CURSOR FOR i130_tree_pre1
   LET l_loop = 1
   LET l_cnt = 1
   LET p_level = p_level + 1
   CALL l_ima.clear()
   FOREACH i130_tree_cs1 INTO l_ima[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   FREE i130_tree_cs1
   CALL l_ima.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
   IF l_cnt >0 THEN
      FOR l_loop=1 TO l_cnt
          LET g_idx = g_idx + 1
          LET g_tree[g_idx].expanded = 1          #0:不展, 1:展          
          LET g_tree[g_idx].name = l_ima[l_loop].ima01,':',l_ima[l_loop].ima02          
          LET g_tree[g_idx].id = l_ima[l_loop].ima01
          LET g_tree[g_idx].pid = p_pid
          LET g_tree[g_idx].has_children = FALSE 
          LET g_tree[g_idx].level = p_level
          LET g_tree[g_idx].desc = l_ima[l_loop].bma06
          
          ##写入组成用量#############
          LET g_tree[g_idx].bmb06=1
          SELECT bmb06/bmb07 INTO g_tree[g_idx].bmb06 FROM bmb_file 
                  WHERE bmb01 = g_tree[g_idx].pid
                   AND  bmb03 = g_tree[g_idx].id
                   AND bmb29 = l_ima[l_loop].bma06
                   AND (bmb04 <=g_today OR bmb04 IS NULL ) AND (bmb05 > g_today OR bmb05 IS NULL ) 
          ###########################            
          
          SELECT COUNT(*) INTO l_child FROM bmb_file 
                 WHERE bmb01 = l_ima[l_loop].ima01
                   AND bmb29 = l_ima[l_loop].bma06
                   AND (bmb04 <=g_today OR bmb04 IS NULL ) AND (bmb05 > g_today OR bmb05 IS NULL )                
          #存在子节点的情况
          IF l_child > 0 THEN 
             LET g_tree[g_idx].has_children = TRUE
             CALL i130_tree_fill(l_ima[l_loop].ima01,g_tree[g_idx].desc,p_level,g_idx)
          END IF
       END FOR
    END IF
END FUNCTION

#填充子节点
FUNCTION i130_tree_fill(p_pid,p_tex,p_level,p_idx)
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
                    
   PREPARE i130_tree_pre2 FROM g_sql
   DECLARE i130_tree_cs2 CURSOR FOR i130_tree_pre2
   LET l_cnt = 1
   CALL l_ima.clear()
   FOREACH i130_tree_cs2 INTO l_ima[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   FREE i130_tree_cs2
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
               CALL i130_tree_fill(g_tree[g_idx].id,g_tree[g_idx].desc,p_level,g_idx)
            END IF
          END FOR
      END IF
END FUNCTION

#No:DEV-CB0002--add--begin
FUNCTION i130_a()

   IF s_shut(0) THEN RETURN END IF

   MESSAGE ""
   INITIALIZE g_tree TO NULL
   INITIALIZE g_ibc_h.* TO NULL
   CALL g_ibc.clear()  
   CLEAR FORM

   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_ibc_h.ibc00 = '1'
      LET g_ibc_h.ibc03 = 1
      LET g_ibc_h.ibc07 = 1
      LET g_ibc_h.ibc08 = ' '
      CALL i130_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         INITIALIZE g_ibc_h.* TO NULL
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_ibc_h.ibc01) THEN
         CONTINUE WHILE
      END IF 

      CALL i130_tree_fill_1(g_ibc_h.ibc01)      #填充树结构
      DISPLAY ARRAY g_tree TO tree.* 
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY

      CALL g_ibc.clear()
      LET g_rec_b = 0
      IF g_ibc_h.ibc07 > 1 THEN 
         INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
                              ibc04,ibc05,ibc06,ibc07)
           VALUES('1',g_ibc_h.ibc01,1,1,g_ibc_h.ibc01,
              1,g_ibc_h.ibc07,g_ibc_h.ibc07)
          #CALL i130_b_fill()         #No:DEV-CB0002--mark
           CALL i130_b_fill(' 1=1')   #No:DEV-CB0002--add
      END IF 

      CALL i130_b()                   #輸入單身

      EXIT WHILE
   END WHILE
END FUNCTION
#No:DEV-CB0002--add--end

#FUNCTION i130_a() #No:DEV-CB0002--mark
FUNCTION i130_i(p_cmd)  #No:DEV-CB0002--add
   DEFINE p_cmd LIKE type_file.chr1 #No:DEV-CB0002--add
   DEFINE l_n LIKE type_file.num5
       
   CALL cl_set_head_visible("","YES") 

  #No:DEV-CB0002--mark--begin
  #CALL cl_set_act_visible("accept,cancel", TRUE)
  #INITIALIZE g_tree TO NULL
  #INITIALIZE g_ibc_h.* TO NULL
  #CALL g_ibc.clear()  
  #CLEAR FORM
  #No:DEV-CB0002--mark--end
       
   INPUT BY NAME  g_ibc_h.ibc00,g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07 #No:DEV-CB0002--add ibc00
           WITHOUT DEFAULTS

      BEFORE INPUT 
         #No:DEV-CB0002--mark--begin
         #LET g_ibc_h.ibc03 = 1
         #LET g_ibc_h.ibc07 = 1
         #DISPLAY BY NAME g_ibc_h.ibc03,g_ibc_h.ibc07
         #DISPLAY '1' TO ibc00  
         #No:DEV-CB0002--mark--end
        
      AFTER FIELD ibc01
         IF NOT cl_null(g_ibc_h.ibc01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM ibc_file WHERE ibc01=g_ibc_h.ibc01
            IF l_n>0 THEN
              #CALL cl_err(g_ibc_h.ibc01,'aba-004',1)  #资料重复  #No:DEV-CB0002--mark
               CALL cl_err(g_ibc_h.ibc01,'aba-106',1)  #资料重复  #No:DEV-CB0002--add
               NEXT FIELD ibc01
            END IF 
            
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM bmb_file WHERE bmb01=g_ibc_h.ibc01
            IF l_n=0 THEN
              #CALL cl_err(g_ibc_h.ibc01,'aba-005',1) #此料号没有BOM资料，请先维护BOM #No:DEV-CB0002--mark
               CALL cl_err(g_ibc_h.ibc01,'aba-107',1) #此料号没有BOM资料，请先维护BOM #No:DEV-CB0002--add
               NEXT FIELD ibc01
            END IF 
            
            SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file WHERE ima01=g_ibc_h.ibc01
            DISPLAY g_ima02,g_ima021 TO ima02,ima021   
            
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

      ON ACTION controlp
         CASE  
            WHEN INFIELD(ibc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima01"
                 LET g_qryparam.default1 = g_ibc_h.ibc01
                 CALL cl_create_qry() RETURNING g_ibc_h.ibc01
                 DISPLAY g_ibc_h.ibc01 TO ibc01
                 NEXT FIELD ibc01
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
  #END IF
  #CALL cl_set_act_visible("accept,cancel", FALSE)
  #No:DEV-CB0002--mark--end
END FUNCTION

FUNCTION i130_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )          
    INITIALIZE g_ibc_h.ibc01,g_ima02,g_ima021,
               g_ibc_h.ibc03,g_ibc_h.ibc07 TO NULL           
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_ibc.clear()
    CALL i130_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN i130_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)      
        INITIALIZE g_ibc_h.ibc01,g_ibc_h.ibc03,g_ima02,g_ima021,g_ibc_h.ibc07 TO NULL
    ELSE
        OPEN i130_count
        FETCH i130_count INTO g_row_count

        CALL i130_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
END FUNCTION

FUNCTION i130_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1               
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i130_cs INTO g_ibc_h.ibc01
        WHEN 'P' FETCH PREVIOUS i130_cs INTO g_ibc_h.ibc01
        WHEN 'F' FETCH FIRST    i130_cs INTO g_ibc_h.ibc01
        WHEN 'L' FETCH LAST     i130_cs INTO g_ibc_h.ibc01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
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
             FETCH ABSOLUTE g_jump i130_cs INTO g_ibc_h.ibc01
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ibc_h.ibc01,SQLCA.sqlcode,0)
        INITIALIZE g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07 TO NULL 
        LET g_ibc_h.ibc01 = NULL     
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
    
    SELECT DISTINCT ibc01,ibc03,ibc07  
      INTO g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07
      FROM ibc_file 
     WHERE ibc01 = g_ibc_h.ibc01
    
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","oqa_file",g_ibc_h.ibc01,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_ibc_h.ibc01,g_ibc_h.ibc03,g_ibc_h.ibc07 TO NULL
        RETURN
    END IF

    CALL i130_show()
END FUNCTION

FUNCTION i130_show()
   DEFINE
    l_gem02         LIKE gem_file.gem02,
    l_occ02         LIKE occ_file.occ02,
    l_gen02         LIKE gen_file.gen02
 
    
    LET g_ima02=''
    LET g_ima021=''
    SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file 
     WHERE ima01=g_ibc_h.ibc01
 
    DISPLAY '1',g_ibc_h.ibc01,g_ima02,g_ima021,g_ibc_h.ibc03,g_ibc_h.ibc07    #No:111013
         TO ibc00,ibc01,ima02,ima021,ibc03,ibc07
 
   #CALL i130_b_fill()         #No:DEV-CB0002--mark
    CALL i130_b_fill(g_wc2)    #No:DEV-CB0002--add
    CALL i130_tree_fill_1(g_ibc_h.ibc01)
    CALL cl_show_fld_cont()      
    DISPLAY g_curs_index TO idx
    DISPLAY g_row_count TO cnt
    DISPLAY g_rec_b TO cn2
                
END FUNCTION

FUNCTION i130_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ibc_h.ibc01 IS NULL THEN 
        CALL cl_err("",-400,0) 
        RETURN
    END IF
 
    BEGIN WORK

    CALL i130_show()
    IF cl_delh(0,0) THEN                   #確認一下
       DELETE FROM ibc_file WHERE ibc01 = g_ibc_h.ibc01
                              AND ibc00 = '1' #No:DEV-CB0002--add
       INITIALIZE g_ibc_h.ibc01,g_ima02,g_ima021,g_ibc_h.ibc03 TO NULL
       CLEAR FORM
       CALL g_ibc.clear()
       CALL g_tree.clear() #No:DEV-CB0002--add
    END IF
                                                                                                              
    OPEN i130_count                                                                                                                 
    FETCH i130_count INTO g_row_count                                                                                                                                                                                           
    OPEN i130_cs        
    IF g_curs_index = g_row_count + 1 THEN                                                                                          
       LET g_jump = g_row_count                                                                                                     
       CALL i130_fetch('L')                                                                                                         
    ELSE   
       LET g_jump = g_curs_index                                                                                                    
       LET mi_no_ask = TRUE                                                                                                         
       CALL i130_fetch('/')                                                                                                         
    END IF                                                                                                                          
    COMMIT WORK
    
END FUNCTION
 
FUNCTION i130_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5, 
       l_cnt           LIKE type_file.num10 ,
       l_i           LIKE type_file.num10 ,
       l_max           LIKE type_file.num10 

   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_ibc_h.ibc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #No:DEV-CB0002--add--begin
   SELECT * INTO g_ibc_h.*
     FROM ibc_file
    WHERE ibc00 = '1'
     AND ibc01 = g_ibc_h.ibc01
   #No:DEV-CB0002--add--end

   LET l_allow_insert = cl_detail_input_auth("insert") #No:DEV-CB0002--add
   LET l_allow_delete = cl_detail_input_auth("delete") #No:DEV-CB0002--add
    
   LET g_forupd_sql = "SELECT ibc02,ibc04,ima02,ibc06,ibc05 ",
                      "  FROM ibc_file,ima_file ",
                      " WHERE ibc04=ima01 ",
                      "   AND ibc00='1'",
                      "   AND ibc01=? AND ibc02=?  ",
                      "   FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i130_bcl CURSOR FROM g_forupd_sql

   INPUT ARRAY g_ibc  WITHOUT DEFAULTS FROM s_ibc.* 
      ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,
            #INSERT ROW=FALSE,DELETE ROW=TRUE,APPEND ROW=FALSE)        #No:DEV-CB0002--add
             INSERT ROW=l_allow_insert, #No:DEV-CB0002--add
             DELETE ROW=l_allow_delete, #No:DEV-CB0002--add
             APPEND ROW=l_allow_insert) #No:DEV-CB0002--add
    
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
        #CALL cl_set_comp_required("ibc05,ibc06",TRUE) #DEV-CC0002 mark
         CALL cl_set_comp_required("ibc05",TRUE)       #DEV-CC0002 add
       
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ibc_t.* = g_ibc[l_ac].*
            BEGIN WORK
               OPEN i130_bcl USING  g_ibc_h.ibc01,g_ibc[l_ac].ibc02
               IF STATUS THEN
                  CALL cl_err("OPEN i130_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                ELSE  
                   FETCH i130_bcl INTO g_ibc[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ibc_t.ibc04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                    END IF
                END IF
             CALL cl_show_fld_cont()
          END IF
          DISPLAY g_ibc[l_ac].ibc05 TO ibc05

      #No:DEV-CB0002--add--begin
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_ibc[l_ac].* TO NULL      #900423
          LET g_ibc_t.* = g_ibc[l_ac].*         #新輸入資料
          LET g_ibc_t.* = g_ibc[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD ibc02

      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
                               ibc04,ibc05,ibc06,ibc07,ibc08)
           VALUES(g_ibc_h.ibc00,g_ibc_h.ibc01,g_ibc[l_ac].ibc02,g_ibc_h.ibc03,
                 g_ibc[l_ac].ibc04,g_ibc[l_ac].ibc05,g_ibc[l_ac].ibc06,g_ibc_h.ibc07,
                 g_ibc_h.ibc08)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ibc_file",g_ibc_h.ibc01,g_ibc[l_ac].ibc02,SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
             LET g_success = 'N'
          ELSE
             MESSAGE 'INSERT O.K'
             IF g_success = 'Y' THEN
                 COMMIT WORK
             END IF
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF

      BEFORE FIELD ibc02
         IF cl_null(g_ibc[l_ac].ibc02) THEN
            SELECT NVL(MAX(ibc02)+1,1) INTO g_ibc[l_ac].ibc02
              FROM ibc_file
             WHERE ibc00=g_ibc_h.ibc00
               AND ibc01=g_ibc_h.ibc01
         END IF

      AFTER FIELD ibc02
         IF NOT cl_null(g_ibc[l_ac].ibc02) THEN
            IF g_ibc[l_ac].ibc02 <> g_ibc_t.ibc02 OR
               cl_null(g_ibc_t.ibc02) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM ibc_file
                WHERE ibc00=g_ibc_h.ibc00
                  AND ibc01=g_ibc_h.ibc01
                  AND ibc02=g_ibc[l_ac].ibc02
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  CALL cl_err('','-239',0)
               END IF
            END IF
         END IF          


      AFTER FIELD ibc04
         IF NOT cl_null(g_ibc[l_ac].ibc04) THEN
            SELECT ima02 INTO g_ibc[l_ac].ima02_desc
              FROM ima_file
             WHERE ima01 = g_ibc[l_ac].ibc04
            IF g_ibc[l_ac].ibc04 <> g_ibc_h.ibc04 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM bma_file , bmb_file ,ima_file
                WHERE bma01=ima01
                  AND bmaacti ='Y'
                  AND ima08 !='A'
                  AND bma01 = g_ibc_h.ibc01 
                  AND bma01 = bmb01
                  AND bmb03 = g_ibc[l_ac].ibc04  #料號
                  AND bmb29 = bma06              #特性
                  AND (bmb04 <=sysdate OR bmb04 IS NULL ) AND (bmb05 > sysdate OR bmb05 IS NULL )
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-523',0)
                  NEXT FIELD CURRENT
               END IF
               
               #组成用量
               SELECT bmb06/bmb07 INTO g_ibc[l_ac].ibc06
                 FROM bma_file,bmb_file 
                WHERE bma01 = bmb01
                  AND bmb01 = g_ibc_h.ibc01 
                  AND bmb03 = g_ibc[l_ac].ibc04  #料號
                  AND bmb29 = bma06
                  AND (bmb04 <=g_today OR bmb04 IS NULL ) AND (bmb05 > g_today OR bmb05 IS NULL ) 
            END IF
         END IF
      #No:DEV-CB0002--add--end
        
      AFTER FIELD ibc05
         IF NOT cl_null(g_ibc[l_ac].ibc05) THEN
            IF g_ibc[l_ac].ibc05>g_ibc_h.ibc03 OR g_ibc[l_ac].ibc05<=0 THEN
            END IF
         END IF          
        
      AFTER FIELD ibc06
         IF NOT cl_null(g_ibc[l_ac].ibc06) THEN
            IF g_ibc[l_ac].ibc06 <=0 THEN
              #CALL cl_err('','aba-006',0)   #数量必须大于0 #No:DEV-CB0002--mark
              #CALL cl_err('','aba-109',0)   #数量必须大于0 #No:DEV-CB0002--add    #DEV-CC0002--mark
               NEXT FIELD ibc06 
            END IF
         END IF   
        
        
        
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ibc[l_ac].* = g_ibc_t.*
            CLOSE i130_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ibc[l_ac].ibc04,-263,1)
            LET g_ibc[l_ac].* = g_ibc_t.*
         ELSE  
           UPDATE ibc_file SET
                  ibc02=g_ibc[l_ac].ibc02, #No:DEV-CB0002--add
                  ibc04=g_ibc[l_ac].ibc04, #No:DEV-CB0002--add
                  ibc05=g_ibc[l_ac].ibc05,
                  ibc06=g_ibc[l_ac].ibc06
         WHERE ibc01 = g_ibc_h.ibc01
          #AND  ibc02 = g_ibc[l_ac].ibc02 #No:DEV-CB0002--mark
           AND ibc02 = g_ibc_t.ibc02      #No:DEV-CB0002--add
           AND ibc00 = '1' 

           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","tc_fas_file",g_ibc_t.ibc04,"",SQLCA.sqlcode,"","",1) 
              LET g_ibc[l_ac].* = g_ibc_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              CLOSE i130_bcl
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
            CLOSE i130_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i130_bcl
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
              WHERE ibc01 = g_ibc_h.ibc01
               #AND ibc02 = g_ibc[l_ac].ibc02 #No:DEV-CB0002--mark
                AND ibc02 = g_ibc_t.ibc02     #No:DEV-CB0002--add
                AND ibc00 = '1'               #No:DEV-CB0002--add
              
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ibc_file",g_ibc[l_ac].ibc04,"",SQLCA.sqlcode,"","",1)  
                ROLLBACK WORK
                CANCEL DELETE
             ELSE
                LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N  
                SELECT DISTINCT ibc03 INTO g_ibc_h.ibc03 FROM ibc_file WHERE ibc01=g_ibc_h.ibc01
                DISPLAY g_ibc_h.ibc03 TO ibc03 
                COMMIT WORK
             END IF
             LET g_rec_b = g_rec_b-1
         END IF                        

      #No:DEV-CB0002--add--begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ibc04) #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bmb205"
                 LET g_qryparam.default1 = g_ibc[l_ac].ibc04
                 LET g_qryparam.arg1     = g_today
                 LET g_qryparam.arg2     = g_ibc_h.ibc01
                 CALL cl_create_qry() RETURNING g_ibc[l_ac].ibc04
                 NEXT FIELD ibc04
            OTHERWISE EXIT CASE
         END CASE

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
   SELECT MAX(ibc05) INTO l_max FROM ibc_file
    WHERE ibc01 = g_ibc_h.ibc01
   IF cl_null(l_max) THEN  RETURN END IF 
   FOR l_i = 1 TO l_max
       SELECT COUNT(*) INTO l_cnt FROM ibc_file
        WHERE ibc01 = g_ibc_h.ibc01
          AND ibc05 = l_i
       IF l_cnt = 0 THEN
          CALL cl_err('','aba-113',1)   #包号断号
          EXIT FOR
       END IF
   END FOR	

   UPDATE ibc_file SET ibc03 = l_max
    WHERE ibc01 = g_ibc_h.ibc01
      AND ibc00 = '1'  
   DISPLAY l_max TO ibc03
   LET g_ibc_h.ibc03 = l_max  
      
END FUNCTION 


FUNCTION change_num()
  DEFINE l_n LIKE type_file.num5
  
  IF g_ibc_h.ibc01 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN
  END IF

   LET l_n=0 
   SELECT COUNT(*) INTO l_n FROM tc_sfg_file WHERE tc_sfg002=g_ibc_h.ibc01
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
            CALL cl_err('','aba-020',0)
            NEXT FIELD ibc03
         END IF
      END IF

    AFTER FIELD ibc07
      IF NOT cl_null(g_ibc_h.ibc07) THEN
         IF g_ibc_h.ibc07<=0 THEN
            CALL cl_err('','aba-020',0)
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
               IF NOT cl_confirm('aba-024') THEN RETURN END IF 
               DELETE FROM ibc_file
                WHERE ibc01 = g_ibc_h.ibc01
                  AND ibc00='1'   
               INSERT INTO ibc_file(ibc00,ibc01,ibc02,ibc03,
                  ibc04,ibc05,ibc06,ibc07,ibc08)
               VALUES('1',g_ibc_h.ibc01,1,1,g_ibc_h.ibc01, 
                      1,g_ibc_h.ibc07,g_ibc_h.ibc07,' ')
             ELSE 
               UPDATE ibc_file SET ibc03=g_ibc_h.ibc03, 
                           ibc07=g_ibc_h.ibc07  
                WHERE ibc01=g_ibc_h.ibc01
                  AND ibc00='1'   
            END IF 

    
    IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      ROLLBACK WORK
    ELSE
      MESSAGE 'update O.K'
      COMMIT WORK
    END IF
    
END FUNCTION

FUNCTION i130_out()
DEFINE
    l_i             LIKE type_file.num5, 
    sr              RECORD
        ibc05   LIKE ibc_file.ibc05, 
        ima01       LIKE ima_file.ima01,       
        ima02       LIKE ima_file.ima02,     
        ima021      LIKE ima_file.ima021,  
        ibc06   LIKE ibc_file.ibc06,     
        ima25       LIKE ima_file.ima25 
       END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  
    l_za05          LIKE za_file.za05,    
    l_azi03         LIKE azi_file.azi03,   
    l_wc            STRING,
    l_sql           STRING,
    l_ima04         LIKE gcb_file.gcb09,
    l_ima04_1       LIKE gcb_file.gcb09                
 
    IF cl_null(g_ibc_h.ibc01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" ibc01='",g_ibc_h.ibc01,"'"      
       LET g_wc2=" 1=1 "   
    END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   

    CALL cl_del_data(l_table)
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?, ?,?)"   
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
            
        LET l_ima04_1 = NULL
        LOCATE l_ima04_1 IN MEMORY
        LET l_sql = "SELECT gcb09 FROM gca_file,gcb_file",
                    " WHERE gcb_file.gcb01 = gca_file.gca07 AND gcb_file.gcb02 = gca_file.gca08",
                    "   AND gcb_file.gcb03 = gca_file.gca09 AND gcb_file.gcb04 = gca_file.gca10",
                    "   AND gca_file.gca01 = 'ima01=",g_ibc_h.ibc01 CLIPPED,"' AND gca_file.gca02 = ' '",  
                    "   AND gca_file.gca03 = ' '  AND gca_file.gca04 = ' '", 
                    "   AND gca_file.gca05 = ' ' AND gca_file.gca08 = 'FLD'", 
                    "   AND gca_file.gca09 = 'ima04' AND gca11 = 'Y'" 
        PREPARE tupian_pr21 FROM l_sql
        DECLARE tupian_cs21 SCROLL CURSOR FOR tupian_pr21
        OPEN tupian_cs21 
        FETCH tupian_cs21 INTO l_ima04_1
        IF SQLCA.sqlcode THEN
           CALL cl_err(l_ima04_1,SQLCA.sqlcode,0)  
           CLOSE tupian_cs21 
        END IF
        CLOSE tupian_cs21  
          
    LET g_sql="SELECT ibc05,ima01,ima02,ima021,ibc06,ima25 ",   
              "  FROM ima_file,ibc_file ",       
              " WHERE ima01 = ibc04 AND ibc01 = '",g_ibc_h.ibc01,"' ",
              "   AND ",g_wc CLIPPED,"AND ",g_wc2 CLIPPED   
                    
    LET g_sql = g_sql CLIPPED," ORDER BY ibc01,ibc05"  
    PREPARE i130_p1 FROM g_sql               
    IF STATUS THEN CALL cl_err('i130_p1',STATUS,0) END IF
 
    DECLARE i130_co                         # CURSOR
        CURSOR FOR i130_p1
 
 
    FOREACH i130_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_ima04 = NULL
        LOCATE l_ima04 IN MEMORY
        LET l_sql = "SELECT gcb09 FROM gca_file,gcb_file",
                    " WHERE gcb_file.gcb01 = gca_file.gca07 AND gcb_file.gcb02 = gca_file.gca08",
                    "   AND gcb_file.gcb03 = gca_file.gca09 AND gcb_file.gcb04 = gca_file.gca10",
                    "   AND gca_file.gca01 = 'ima01=",sr.ima01 CLIPPED,"' AND gca_file.gca02 = ' '",  
                    "   AND gca_file.gca03 = ' '  AND gca_file.gca04 = ' '", 
                    "   AND gca_file.gca05 = ' ' AND gca_file.gca08 = 'FLD'", 
                    "   AND gca_file.gca09 = 'ima04' AND gca11 = 'Y'" 
        PREPARE tupian_pr2 FROM l_sql
        DECLARE tupian_cs2 SCROLL CURSOR FOR tupian_pr2
        OPEN tupian_cs2 
        FETCH tupian_cs2 INTO l_ima04
        IF SQLCA.sqlcode THEN
           CALL cl_err(l_ima04,SQLCA.sqlcode,0)  
           CLOSE tupian_cs2 
        END IF
        CLOSE tupian_cs2
                
        EXECUTE insert_prep USING sr.ibc05,l_ima04,sr.ima02,sr.ima021,sr.ibc06,sr.ima25,l_ima04_1
    END FOREACH

    LET g_str = g_prog CLIPPED
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_prog="abai130"   
    CALL cl_prt_cs3('abai130','abai130',g_sql,g_str) 
 
    CLOSE i130_co
    ERROR ""
END FUNCTION
#DEV-CA0004----add
#DEV-D30025--add
