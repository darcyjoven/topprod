# Prog. Version..: '5.10.03-08.08.20(00409)''     #
#
# Pattern name...: ghrq004.4gl
# Descriptions...: 集团公司明细查询作业
# Date & Author..: 13/05/22 by lijun
# .......................modify: by zhuzw 20130916 更改结点图标
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1  LIKE sfb_file.sfb01,
    ddflag   LIKE type_file.chr1,                 
    g_wc,g_wc2,g_sql    STRING, 
    g_cott          LIKE type_file.num5,          
    g_hrar           DYNAMIC ARRAY OF RECORD 
      hrag07         LIKE hrag_file.hrag07,
      hrar02_1       LIKE hrar_file.hrar04,
      hrar02_2       LIKE hrar_file.hrar04,
      hrar02_3       LIKE hrar_file.hrar04,
      hrar02_4       LIKE hrar_file.hrar04,
      hrar02_5       LIKE hrar_file.hrar04,
      hrar02_6       LIKE hrar_file.hrar04,
      hrar02_7       LIKE hrar_file.hrar04,
      hrar02_8       LIKE hrar_file.hrar04,
      hrar02_9       LIKE hrar_file.hrar04,
      hrar02_10      LIKE hrar_file.hrar04,
      hrar02_11      LIKE hrar_file.hrar04,
      hrar02_12      LIKE hrar_file.hrar04,
      hrar02_13      LIKE hrar_file.hrar04,
      hrar02_14      LIKE hrar_file.hrar04,
      hrar02_15      LIKE hrar_file.hrar04
                     END RECORD,
    g_hrar_tmp       DYNAMIC ARRAY OF RECORD
      hrar06         LIKE hrar_file.hrar06,
      hrag07         LIKE hrag_file.hrag07,
      hrar04         LIKE hrar_file.hrar04,
      hrar02         LIKE hrar_file.hrar02
                     END RECORD,                   
                                                                                           
    g_rec_b         LIKE type_file.num5,  
    g_rec_b1         LIKE type_file.num5,  
    g_rec_b2         LIKE type_file.num5,           
    l_ac            LIKE type_file.num5,               
    g_ac            LIKE type_file.num5,
    l_sl,p_row,p_col            LIKE type_file.num5    

DEFINE g_forupd_sql      STRING                       
DEFINE   g_chr           LIKE type_file.chr1          
DEFINE   g_cnt           LIKE type_file.num10         
DEFINE   g_msg           LIKE type_file.chr1000      
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10         
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   g_idx           LIKE type_file.num5  
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          NAME           STRING,                 #节点名称
          img            LIKE type_file.chr1000, #add by zhuzw 20130916
          pid            LIKE hrar_file.hrar01,    #父节点id
          id             LIKE hrar_file.hrar01,    #节点id
          has_children   BOOLEAN,                #1:有子节点, null:无子节点
          expanded       BOOLEAN,                #0:不展开, 1展开
          level          LIKE type_file.num5,    #层级
          treekey1       STRING,
          treekey2       STRING
          END RECORD
      
DEFINE g_tree_focus_idx  STRING                  #当前节点数
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE  g_curr_idx       INTEGER 
DEFINE g_f               LIKE type_file.chr1 
DEFINE g_max_num     LIKE type_file.num5
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   
   DROP TABLE hrar_tmp
   CREATE TEMP TABLE hrar_tmp(
      hrar06         LIKE hrar_file.hrar06,
      hrag07         LIKE hrag_file.hrag07,
      hrar02_1       LIKE hrar_file.hrar04,
      hrar02_2       LIKE hrar_file.hrar04,
      hrar02_3       LIKE hrar_file.hrar04,
      hrar02_4       LIKE hrar_file.hrar04,
      hrar02_5       LIKE hrar_file.hrar04,
      hrar02_6       LIKE hrar_file.hrar04,
      hrar02_7       LIKE hrar_file.hrar04,
      hrar02_8       LIKE hrar_file.hrar04,
      hrar02_9       LIKE hrar_file.hrar04,
      hrar02_10      LIKE hrar_file.hrar04,
      hrar02_11      LIKE hrar_file.hrar04,
      hrar02_12      LIKE hrar_file.hrar04,
      hrar02_13      LIKE hrar_file.hrar04,
      hrar02_14      LIKE hrar_file.hrar04,
      hrar02_15      LIKE hrar_file.hrar04);
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    LET g_argv1 = ARG_VAL(1)
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q004_w AT p_row,p_col WITH FORM "ghr/42f/ghrq004"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    LET g_f = '1'
    CALL cl_ui_init()
    CALL  q004_menu()
    CLOSE WINDOW q004_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
FUNCTION q004_menu()
 
   WHILE TRUE
      CALL  q004_tree_fill_1()
      CALL q004_bp("G")
      
      CASE g_action_choice
         WHEN "help"
            IF cl_chk_act_auth() THEN        
              CALL cl_show_help()            
            END IF                           
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_f = '1' THEN  
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrar),'','')
               END IF                              
            END IF                     
      END CASE
   END WHILE 
END FUNCTION
FUNCTION q004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000

 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
   
        DISPLAY ARRAY g_tree TO tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
             
         BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR()
            LET l_wc = " hrar01 = '",g_tree[l_tree_ac].id,"' " 
            CALL q004_b_fill(l_wc)
                                         
      END DISPLAY       
      DISPLAY ARRAY g_hrar TO s_hrar.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
                 
      END DISPLAY   
         
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DIALOG                        
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
        ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q004_b_fill(p_wc2)              
DEFINE p_wc2    LIKE type_file.chr1000  
DEFINE l_color   LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1,l_cnt2     LIKE type_file.num5
DEFINE l_max_hrar06  LIKE hrar_file.hrar06
DEFINE l_type        LIKE type_file.num5
DEFINE l_num         LIKE type_file.num5
DEFINE l_sql1        LIKE type_file.chr1000
DEFINE l_sql2        LIKE type_file.chr1000
DEFINE l_sql3        LIKE type_file.chr1000
DEFINE l_sql4        LIKE type_file.chr1000
DEFINE l_sql5        LIKE type_file.chr1000
DEFINE i             LIKE type_file.num5
DEFINE l_type_new    LIKE type_file.chr10
DEFINE l_count       LIKE type_file.num5
DEFINE l_type1       LIKE type_file.chr10
DEFINE l_num1        LIKE type_file.chr10
DEFINE l_hrag07      LIKE hrag_file.hrag07
DEFINE   j      LIKE type_file.num5
DEFINE   j_chr  LIKE type_file.chr10
DEFINE   l_field  LIKE type_file.chr10
DEFINE   l_sql  LIKE type_file.chr1000
  
   DELETE FROM hrar_tmp
     
 #-------page1
#   LET l_sql1 =" SELECT MAX(hrar06) FROM hrar_file ",
#               " WHERE hraracti = 'Y' ",
#               "   AND ",p_wc2
#   PREPARE q_max_hrar06 FROM l_sql1
#   DECLARE max_hrar06 CURSOR FOR q_max_hrar06
#   EXECUTE max_hrar06 INTO l_max_hrar06
#   LET g_max_num = l_max_hrar06
#   FOR i = 1 TO g_max_num
#
#       INSERT INTO hrar_tmp 
#       VALUES (i,'','','','','',   '','','','','',  '','','','','' )
#   END FOR
  
#   LET g_sql =  " SELECT hrar02,hrar04,hrar06 ",
#                "   FROM hrar_file ",
#                "  WHERE hraracti = 'Y' ",
#                "   AND ",p_wc2 CLIPPED,
#                " ORDER BY hrar06,hrar02 "
   LET g_sql =  " SELECT hrar06,hrag07,hrar04,hrar02 ",
                "   FROM hrar_file,hrag_file ",
                "  WHERE hraracti = 'Y' AND hrag06=hrar06 AND hrag01='204' ",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY hrar06,hrar02 "           
    PREPARE q0041_pb FROM g_sql
    DECLARE hrar_curs CURSOR FOR q0041_pb
 
    CALL g_hrar.CLEAR()
    LET g_rec_b = 0
    LET l_cnt = 1
    #临时表数据处理
    FOREACH hrar_curs INTO g_hrar_tmp[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_type = g_hrar_tmp[l_cnt].hrar02
        LET l_type1 = l_type
        LET l_type_new = 'hrar02_',l_type1
        #动态显示表格职位体系类别名称
        IF NOT cl_null(g_hrar_tmp[l_cnt].hrar02) THEN
        	SELECT hrag07 INTO l_hrag07 FROM hrag_file
        	  WHERE hrag01='203' AND hrag06=g_hrar_tmp[l_cnt].hrar02
        	IF NOT cl_null(l_hrag07) THEN
        		CALL cl_set_comp_att_text(l_type_new, l_hrag07)
        	END IF
        END IF
        LET l_sql1 = " SELECT COUNT(*) FROM hrar_tmp WHERE hrag07 = '",g_hrar_tmp[l_cnt].hrag07,"'"
        PREPARE q_count FROM l_sql1
        EXECUTE q_count INTO l_count
        IF l_count = 0 THEN   #不存在该职位等级数据应insert
        	 LET l_sql2 = "INSERT INTO hrar_tmp VALUES ('",g_hrar_tmp[l_cnt].hrar06,"','",g_hrar_tmp[l_cnt].hrag07,"' ,'','','','','',   '','','','','',  '','','','','' )"
        	 PREPARE insert_tmp FROM l_sql2
           EXECUTE insert_tmp
           LET l_sql2= "UPDATE hrar_tmp SET ",l_type_new,"='",g_hrar_tmp[l_cnt].hrar04,"' ",
        	             " WHERE hrag07='",g_hrar_tmp[l_cnt].hrag07,"'"
        	 PREPARE update_tmp1 FROM l_sql2
           EXECUTE update_tmp1
        ELSE	 #存在该职位等级数据
           LET l_sql3 = " SELECT COUNT(",l_type_new,") FROM hrar_tmp WHERE hrag07 = '",g_hrar_tmp[l_cnt].hrag07,"'"
           PREPARE q_count_num FROM l_sql3
           EXECUTE q_count_num INTO l_count
           IF l_count = 0 THEN   #不存在该职位等级下职位种类记录则
        	    LET l_sql4= "UPDATE hrar_tmp SET ",l_type_new,"='",g_hrar_tmp[l_cnt].hrar04,"' ",
        	             " WHERE hrag07='",g_hrar_tmp[l_cnt].hrag07,"'"
        	    PREPARE update_tmp2 FROM l_sql4
              EXECUTE update_tmp2
           END IF
        	
        END IF
         
        LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_hrar_tmp.deleteElement(l_cnt)
#    #动态控制表格栏位显示与否
    CALL cl_set_comp_visible("hrar02_1,hrar02_2,hrar02_3,hrar02_4,hrar02_5,hrar02_6,hrar02_7,hrar02_8",FALSE)
    CALL cl_set_comp_visible("hrar02_9,hrar02_10,hrar02_11,hrar02_12,hrar02_13,hrar02_14,hrar02_15,hrag07",FALSE)
    SELECT COUNT(hrag07) INTO l_count FROM hrar_tmp
    IF l_count > 0 THEN
       CALL cl_set_comp_visible("hrag07",TRUE)
    END IF
    FOR j=1 TO 15
       LET j_chr = j
       LET l_field = 'hrar02_',j_chr
       LET l_sql = "SELECT COUNT(",l_field,") FROM hrar_tmp"
       PREPARE show_field FROM l_sql
       EXECUTE show_field INTO l_count 
       IF l_count >0 THEN
          CALL cl_set_comp_visible(l_field,TRUE)
       END IF
    END FOR
    
    #抓取临时表数据填充单身
    LET l_cnt = 1
    LET l_sql5 = "SELECT hrag07,hrar02_1,hrar02_2,hrar02_3,hrar02_4,hrar02_5,hrar02_6,hrar02_7,hrar02_8 ",
                 " hrar02_9,hrar02_10,hrar02_11,hrar02_12,hrar02_13,hrar02_14,hrar02_15 FROM hrar_tmp ORDER BY hrar06"
    PREPARE q_hrar_tmp FROM l_sql5
    DECLARE q_hrar_tmp_cs CURSOR FOR q_hrar_tmp
    FOREACH q_hrar_tmp_cs INTO g_hrar[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_hrar.deleteElement(l_cnt)
    LET g_rec_b= l_cnt-1
    LET l_cnt = 0
    LET g_ac=1 
    
   
END FUNCTION
####################################################################

#填充树
FUNCTION q004_tree_fill_1()
DEFINE p_level,l_n      LIKE type_file.num5,
       l_child      INTEGER
DEFINE p_oea01        LIKE oea_file.oea01 
DEFINE l_name       LIKE hraa_file.hraa12    
   INITIALIZE g_tree TO NULL
   LET p_level = 0
   LET g_idx = 0  
   LET g_idx = g_idx + 1
   SELECT hraa01,hraa12 INTO g_tree[g_idx].id,l_name FROM hraa_file 
    WHERE hraa10 IS NULL    
   LET g_tree[g_idx].name = l_name
   LET g_tree[g_idx].expanded = 1          #0:不展, 1:展          
   LET g_tree[g_idx].pid = NULL 
   LET g_tree[g_idx].img = "gongsi.ico" #add by zhuzw 20130916
   SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa10 = g_tree[g_idx].id
   IF l_n > 0 THEN 
      LET g_tree[g_idx].has_children = TRUE  
   ELSE 
      LET g_tree[g_idx].has_children = FALSE    	
   END IF 
   LET g_tree[g_idx].level = p_level
   IF l_n > 0 THEN 
      CALL q004_tree_fill_2(g_tree[g_idx].id,p_level) 
   END IF          
END FUNCTION

#
FUNCTION q004_tree_fill_2(p_pid,p_level)
DEFINE p_level,l_n,l_i           LIKE type_file.num5,
       p_pid             STRING,
       l_child           INTEGER
DEFINE p_oea01             LIKE oea_file.oea01      
DEFINE l_sfb01         LIKE sfb_file.sfb01
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_hraa         DYNAMIC ARRAY OF  RECORD 
         hraa10        LIKE hraa_file.hraa10
                                   END RECORD     
DEFINE l_name          LIKE hraa_file.hraa12                                        
   LET g_sql = "SELECT  hraa01 ",
               "  FROM hraa_file ",
               " WHERE hraa10 = '",p_pid,"' and hraaacti = 'Y' ",    
               "  ORDER BY hraa01 "        
   PREPARE q004_tree_pre1 FROM g_sql
   DECLARE q004_tree_cs1 CURSOR FOR q004_tree_pre1
   
   LET l_cnt = 1
   
   FOREACH q004_tree_cs1 INTO l_hraa[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_hraa.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
   LET l_cnt = l_cnt - 1
   LET p_level = p_level + 1
   IF l_cnt > 0 THEN 
      FOR l_i = 1 TO l_cnt 
          LET g_idx = g_idx + 1
          LET g_tree[g_idx].expanded = 1          #0:不展, 1:展     
          SELECT hraa12 INTO  l_name  FROM hraa_file      
           WHERE hraa01 = l_hraa[l_i].hraa10               
          LET g_tree[g_idx].name = l_name 
          LET g_tree[g_idx].id = l_hraa[l_i].hraa10
          LET g_tree[g_idx].pid = p_pid
          LET g_tree[g_idx].level = p_level
          LET g_tree[g_idx].img = "gongsi.ico" #add by zhuzw 20130916
          SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa10 = l_hraa[l_i].hraa10 AND hraaacti = 'Y'
          IF l_n > 0 THEN 
             LET g_tree[g_idx].has_children = TRUE  
          ELSE 
             LET g_tree[g_idx].has_children = FALSE    	
          END IF 
          IF l_n > 0 THEN 
             CALL q004_tree_fill_2(l_hraa[l_i].hraa10,p_level) 
          END IF 
      END FOR     
   END IF         
END FUNCTION
