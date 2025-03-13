# Prog. Version..: '5.10.03-08.08.20(00009)''     #
#
# Pattern name...: cxmq000.4gl
# Descriptions...: 集团公司明细查询作业
# Date & Author..: 20130226 zhuzw

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1   LIKE sfb_file.sfb01,
    ddflag   LIKE type_file.chr1,                 
    g_wc,g_wc2,g_sql    STRING, 
    g_cott          LIKE type_file.num5,          
    g_hraa           DYNAMIC ARRAY OF RECORD 
      hraa01         LIKE hraa_file.hraa01,
      hraa12         LIKE hraa_file.hraa12,
      hraa10         LIKE hraa_file.hraa10,
      hraa12_s       LIKE hraa_file.hraa12,
      hraa02         LIKE hraa_file.hraa02,
      hraa03         LIKE hraa_file.hraa03,              
      hraa07         LIKE hraa_file.hraa07,
      hraa04         LIKE hraa_file.hraa04,
      hraa05         LIKE hraa_file.hraa05,
      hraa05_s       LIKE hrag_file.hrag07,
      hraaacti       LIKE hraa_file.hraaacti,
      hraa06         LIKE hraa_file.hraa06
                     END RECORD,
    g_hraa1           DYNAMIC ARRAY OF RECORD 
      hraa01         LIKE hraa_file.hraa01,
      hraa12         LIKE hraa_file.hraa12,
      hraa10         LIKE hraa_file.hraa10,
      hraa12_s1      LIKE hraa_file.hraa12,
      hraa02         LIKE hraa_file.hraa02,
      hraa03         LIKE hraa_file.hraa03,              
      hraa07         LIKE hraa_file.hraa07,
      hraa04         LIKE hraa_file.hraa04,
      hraa05         LIKE hraa_file.hraa05,
      hraa05_s1      LIKE hrag_file.hrag07,
      hraaacti       LIKE hraa_file.hraaacti,
      hraa06         LIKE hraa_file.hraa06
                     END RECORD,
    g_hraa2           DYNAMIC ARRAY OF RECORD 
      hraa01         LIKE hraa_file.hraa01,
      hraa12         LIKE hraa_file.hraa12,
      hraa10         LIKE hraa_file.hraa10,
      hraa12_s2      LIKE hraa_file.hraa12,
      hraa02         LIKE hraa_file.hraa02,
      hraa03         LIKE hraa_file.hraa03,              
      hraa07         LIKE hraa_file.hraa07,
      hraa04         LIKE hraa_file.hraa04,
      hraa05         LIKE hraa_file.hraa05,
      hraa05_s2      LIKE hrag_file.hrag07,
      hraaacti       LIKE hraa_file.hraaacti,
      hraa06         LIKE hraa_file.hraa06
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
          NAME           LIKE type_file.chr1000,                 #节点名称
          img            LIKE type_file.chr1000, #add by zhuzw 20130913
          pid            LIKE hraa_file.hraa01,    #父节点id
          id             LIKE hraa_file.hraa01,    #节点id
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
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    LET g_argv1 = ARG_VAL(1)
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q000_w AT p_row,p_col WITH FORM "ghr/42f/ghrq000"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    LET g_f = '1'
    CALL cl_ui_init()
    CALL  q000_menu()
    CLOSE WINDOW q000_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
FUNCTION q000_menu()
 
   WHILE TRUE
      CALL  q000_tree_fill_1()
      CALL q000_bp("G")
      CASE g_action_choice
         WHEN "help"
            IF cl_chk_act_auth() THEN        
              CALL cl_show_help()            
            END IF                           
         WHEN "exit"
            EXIT WHILE
         WHEN "contact"
            CONTINUE	WHILE	
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_f = '1' THEN  
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hraa),'','')
               END IF 
                IF g_f = '2' THEN  
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hraa1),'','')  
                END IF     
                IF g_f = '3' THEN  
                  LET page = f.FindNode("Page","page3")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hraa2),'','')  
                END IF                              
            END IF                     
      END CASE
   END WHILE 
END FUNCTION
FUNCTION q000_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
   
        DISPLAY ARRAY g_tree TO s_tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
          #  CALL dialog.setArrayAttributes("s_hraa",g_att)
             
         BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR()
            LET l_wc = " hraa10 = '",g_tree[l_tree_ac].id,"' " 
            CALL q000_b_fill(l_wc)
            
      ON ACTION accept
         CALL q000_drill_gl(g_tree[l_tree_ac].id)
         EXIT DIALOG  
      ON ACTION page1
         LET g_f = '1' 
      ON ACTION page2
         LET g_f = '2'
      ON ACTION page3
         LET g_f = '3'                 
      ON ACTION ghrq000_a
         CALL i000_feature_maintain(g_tree[l_tree_ac].id)
         LET  g_action_choice='contact'
         EXIT DIALOG   
      ON ACTION ghrq000_b
         IF g_tree[l_tree_ac].id IS NOT NULL THEN
            LET g_doc.column1 = "hraa01"
            LET g_doc.value1 = g_tree[l_tree_ac].id
            CALL cl_doc()
         END IF
          EXIT DIALOG            
      ON ACTION ghrq000_c
         CALL q000_drill_gl('1=0')
         EXIT DIALOG                              
      END DISPLAY       
      DISPLAY ARRAY g_hraa TO s_hraa.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION accept
         CALL q000_drill_gl(g_hraa[l_ac].hraa01)
         EXIT DIALOG  
      ON ACTION ghrq000_a
             CALL i000_feature_maintain(g_hraa[l_ac].hraa01)
             LET  g_action_choice='contact'
         EXIT DIALOG      
      ON ACTION ghrq000_b
              IF g_hraa[l_ac].hraa01 IS NOT NULL THEN
                 LET g_doc.column1 = "hraa01"
                 LET g_doc.value1 = g_hraa[l_ac].hraa01
                 CALL cl_doc()
              END IF
          EXIT DIALOG 
      ON ACTION ghrq000_c
         CALL q000_drill_gl('1=0')
         EXIT DIALOG                               
      ON ACTION page1
         LET g_f = '1' 
      ON ACTION page2
         LET g_f = '2'
      ON ACTION page3
         LET g_f = '3'           
      END DISPLAY   
      DISPLAY ARRAY g_hraa1 TO s_hraa1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION accept
         CALL q000_drill_gl(g_hraa1[l_ac].hraa01)
         EXIT DIALOG  
      ON ACTION ghrq000_a
             CALL i000_feature_maintain(g_hraa1[l_ac].hraa01)
             LET  g_action_choice='contact'
         EXIT DIALOG      
      ON ACTION ghrq000_b
              IF g_hraa1[l_ac].hraa01 IS NOT NULL THEN
                 LET g_doc.column1 = "hraa01"
                 LET g_doc.value1 = g_hraa1[l_ac].hraa01
                 CALL cl_doc()
              END IF
          EXIT DIALOG 
      ON ACTION ghrq000_c
         CALL q000_drill_gl('1=0'	)
         EXIT DIALOG    
      ON ACTION page1
         LET g_f = '1' 
      ON ACTION page2
         LET g_f = '2'
      ON ACTION page3
         LET g_f = '3'                                      
      END DISPLAY 
      DISPLAY ARRAY g_hraa2 TO s_hraa2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION accept
         CALL q000_drill_gl(g_hraa2[l_ac].hraa01)
         EXIT DIALOG  
      ON ACTION ghrq000_a
             CALL i000_feature_maintain(g_hraa2[l_ac].hraa01)
             LET  g_action_choice='contact'
         EXIT DIALOG      
      ON ACTION ghrq000_b
              IF g_hraa2[l_ac].hraa01 IS NOT NULL THEN
                 LET g_doc.column1 = "hraa01"
                 LET g_doc.value1 = g_hraa2[l_ac].hraa01
                 CALL cl_doc()
              END IF
          EXIT DIALOG 
      ON ACTION ghrq000_c
         CALL q000_drill_gl('1=0'	)
         EXIT DIALOG    
      ON ACTION page1
         LET g_f = '1' 
      ON ACTION page2
         LET g_f = '2'
      ON ACTION page3
         LET g_f = '3'                                     
      END DISPLAY                             
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                        
 
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
 
FUNCTION q000_b_fill(p_wc2)              
DEFINE p_wc2    LIKE type_file.chr1000  
DEFINE l_color   LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1,l_cnt2     LIKE type_file.num5
 #-------page1    
   LET g_sql =  " SELECT hraa01,hraa12,hraa10,'',hraa02,hraa03,hraa07,hraa04,hraa05,'',hraaacti,hraa06 ",
                "   FROM hraa_file ",
                "  WHERE hraaacti = 'Y' ",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY hraa01 "            
    PREPARE q0001_pb FROM g_sql
    DECLARE hraa_curs CURSOR FOR q0001_pb
 
    CALL g_hraa.CLEAR()
    LET g_rec_b = 0
    LET l_cnt = 1
    #單身 ARRAY 填充
    FOREACH hraa_curs  INTO g_hraa[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hraa12 INTO g_hraa[l_cnt].hraa12_s FROM hraa_file 
        WHERE hraa01=g_hraa[l_cnt].hraa10
        SELECT hrag07 INTO g_hraa[l_cnt].hraa05_s FROM hrag_file 
        WHERE hrag01='201'
        AND  hrag06=g_hraa[l_cnt].hraa05
        LET l_cnt = l_cnt + 1
    END FOREACH
    LET g_sql= " SELECT hraa01,hraa12,hraa10,'',hraa02,hraa03,hraa07,hraa04,hraa05,'',hraaacti,hraa06 ",
                "   FROM hraa_file ",
                "  WHERE hraaacti = 'Y' ",
                "  AND hraa10 in (select hraa01 from hraa_file where hraa10= '",g_tree[l_tree_ac].id,"'  )  ",
                " ORDER BY hraa01 "  
        PREPARE q0004_pb FROM g_sql
        DECLARE hraa_curs4 CURSOR FOR q0004_pb
        FOREACH hraa_curs4  INTO g_hraa[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hraa12 INTO g_hraa[l_cnt].hraa12_s FROM hraa_file 
        WHERE hraa01=g_hraa[l_cnt].hraa10
        SELECT hrag07 INTO g_hraa[l_cnt].hraa05_s FROM hrag_file 
        WHERE hrag01='201'
        AND  hrag06=g_hraa[l_cnt].hraa05
        LET l_cnt = l_cnt + 1
        END FOREACH 
    CALL g_hraa.deleteElement(l_cnt)
    LET g_rec_b= l_cnt-1
    LET l_cnt = 0
    LET g_ac=1
#--- page2
   LET g_sql =  " SELECT hraa01,hraa12,hraa10,'',hraa02,hraa03,hraa07,hraa04,hraa05,'',hraaacti,hraa06 ",
                "   FROM hraa_file ",
                "  WHERE hraaacti = 'N' ",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY hraa01 "            
    PREPARE q0002_pb FROM g_sql
    DECLARE hraa_curs1 CURSOR FOR q0002_pb
 
    CALL g_hraa1.CLEAR()
    LET g_rec_b1 = 0
    LET l_cnt1 = 1
    #單身 ARRAY 填充
    FOREACH hraa_curs1  INTO g_hraa1[l_cnt1].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hraa12 INTO g_hraa1[l_cnt1].hraa12_s1 FROM hraa_file 
        WHERE hraa01=g_hraa1[l_cnt1].hraa10
        SELECT hrag07 INTO g_hraa1[l_cnt1].hraa05_s1 FROM hrag_file 
        WHERE hrag01='201'
        AND  hrag06=g_hraa1[l_cnt1].hraa05
        LET l_cnt1 = l_cnt1 + 1
    END FOREACH
    LET g_sql= " SELECT hraa01,hraa12,hraa10,'',hraa02,hraa03,hraa07,hraa04,hraa05,'',hraaacti,hraa06 ",
                "   FROM hraa_file ",
                "  WHERE hraaacti = 'N' ",
                "  AND hraa10 in (select hraa01 from hraa_file where hraa10= '",g_tree[l_tree_ac].id,"'  )  ",
                " ORDER BY hraa01 "  
        PREPARE q0005_pb FROM g_sql
        DECLARE hraa_curs5 CURSOR FOR q0005_pb
        FOREACH hraa_curs5  INTO g_hraa1[l_cnt1].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hraa12 INTO g_hraa1[l_cnt1].hraa12_s1 FROM hraa_file 
        WHERE hraa01=g_hraa1[l_cnt1].hraa10
        SELECT hrag07 INTO g_hraa1[l_cnt1].hraa05_s1 FROM hrag_file 
        WHERE hrag01='201'
        AND  hrag06=g_hraa1[l_cnt1].hraa05
        LET l_cnt1 = l_cnt1 + 1
        END FOREACH 
    CALL g_hraa1.deleteElement(l_cnt1)
    LET g_rec_b1= l_cnt1-1
    LET l_cnt1 = 0
    LET g_ac=1
#---page3
   LET g_sql =  " SELECT hraa01,hraa12,hraa10,'',hraa02,hraa03,hraa07,hraa04,hraa05,'',hraaacti,hraa06 ",
                "   FROM hraa_file ",
                "  WHERE ",p_wc2 CLIPPED,
                " ORDER BY hraa01 "            
    PREPARE q0003_pb FROM g_sql
    DECLARE hraa_curs2 CURSOR FOR q0003_pb
 
    CALL g_hraa2.CLEAR()
    LET g_rec_b2 = 0
    LET l_cnt2 = 1
    #單身 ARRAY 填充
    FOREACH hraa_curs2  INTO g_hraa2[l_cnt2].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hraa12 INTO g_hraa2[l_cnt2].hraa12_s2 FROM hraa_file 
        WHERE hraa01=g_hraa2[l_cnt2].hraa10
        SELECT hrag07 INTO g_hraa2[l_cnt2].hraa05_s2 FROM hrag_file 
        WHERE hrag01='201'
        AND  hrag06=g_hraa2[l_cnt2].hraa05
        LET l_cnt2 = l_cnt2 + 1
    END FOREACH
     LET g_sql= " SELECT hraa01,hraa12,hraa10,'',hraa02,hraa03,hraa07,hraa04,hraa05,'',hraaacti,hraa06 ",
                "   FROM hraa_file ",
                "  WHERE hraa10 in (select hraa01 from hraa_file where hraa10= '",g_tree[l_tree_ac].id,"'  )  ",
                " ORDER BY hraa01 "  
        PREPARE q0006_pb FROM g_sql
        DECLARE hraa_curs6 CURSOR FOR q0006_pb
        FOREACH hraa_curs6  INTO g_hraa2[l_cnt2].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hraa12 INTO g_hraa2[l_cnt2].hraa12_s2 FROM hraa_file 
        WHERE hraa01=g_hraa2[l_cnt2].hraa10
        SELECT hrag07 INTO g_hraa2[l_cnt2].hraa05_s2 FROM hrag_file 
        WHERE hrag01='201'
        AND  hrag06=g_hraa2[l_cnt2].hraa05
        LET l_cnt2 = l_cnt2 + 1
        END FOREACH 
    CALL g_hraa2.deleteElement(l_cnt2)
    LET g_rec_b2 = l_cnt2-1
    LET l_cnt2 = 0
    LET g_ac=1    
END FUNCTION
####################################################################

#填充树
FUNCTION q000_tree_fill_1()
DEFINE p_level,l_n      LIKE type_file.num5,
       l_child      INTEGER
DEFINE p_oea01        LIKE oea_file.oea01 
DEFINE l_name       LIKE hraa_file.hraa12    
   INITIALIZE g_tree TO NULL
   LET p_level = 0
   LET g_idx = 0  
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].img = "gongsi.ico" #add by zhuzw 20130913
   SELECT hraa01,hraa12 INTO g_tree[g_idx].id,l_name FROM hraa_file 
    WHERE hraa10 IS NULL    
   LET g_tree[g_idx].name = l_name
   LET g_tree[g_idx].expanded = 1          #0:不展, 1:展          
   LET g_tree[g_idx].pid = NULL 
  
   SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa10 = g_tree[g_idx].id
   IF l_n > 0 THEN 
      LET g_tree[g_idx].has_children = TRUE  
   ELSE 
      LET g_tree[g_idx].has_children = FALSE    	
   END IF 
   LET g_tree[g_idx].level = p_level
   IF l_n > 0 THEN 
      CALL q000_tree_fill_2(g_tree[g_idx].id,p_level) 
   END IF          
END FUNCTION

#
FUNCTION q000_tree_fill_2(p_pid,p_level)
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
   PREPARE q000_tree_pre1 FROM g_sql
   DECLARE q000_tree_cs1 CURSOR FOR q000_tree_pre1
   
   LET l_cnt = 1
   
   FOREACH q000_tree_cs1 INTO l_hraa[l_cnt].*
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
          LET g_tree[g_idx].img = "gongsi.ico" #add by zhuzw 20130913
          LET g_tree[g_idx].name = l_name 
          LET g_tree[g_idx].id = l_hraa[l_i].hraa10
          LET g_tree[g_idx].pid = p_pid
          LET g_tree[g_idx].level = p_level
          SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa10 = l_hraa[l_i].hraa10 AND hraaacti = 'Y'
          IF l_n > 0 THEN 
             LET g_tree[g_idx].has_children = TRUE  
          ELSE 
             LET g_tree[g_idx].has_children = FALSE    	
          END IF 
          IF l_n > 0 THEN 
             CALL q000_tree_fill_2(l_hraa[l_i].hraa10,p_level) 
          END IF 
      END FOR     
   END IF         
END FUNCTION

FUNCTION q000_drill_gl(p_id)
   DEFINE l_sql,l_occ01 STRING
   DEFINE l_flg     LIKE type_file.chr1
   DEFINE l_cn1     LIKE type_file.num5
   DEFINE p_id      LIKE hraa_File.hraa01
          

   IF l_ac = 0 THEN RETURN END IF 
   IF cl_null(p_id) THEN RETURN END IF  
   LET g_msg = "ghri000 '",p_id,"' 'Y'  " 
   CALL cl_cmdrun_wait(g_msg)
   CALL q000_tree_fill_1()
   
END FUNCTION
