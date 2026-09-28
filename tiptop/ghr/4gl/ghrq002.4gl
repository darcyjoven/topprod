# Prog. Version..: '5.10.03-08.08.20(00009)''     #
#
# Pattern name...: ghrq002.4gl
# Descriptions...: 
# Date & Author..: 22/03/13 by zhangbo
# .......................modify: by zhuzw 20130916 更改结点图标
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1   LIKE hrao_file.hrao01,
    ddflag   LIKE type_file.chr1,                 
    g_wc,g_wc2,g_sql    STRING, 
    g_cott          LIKE type_file.num5,          
    g_hrap           DYNAMIC ARRAY OF RECORD 
      hrap05         LIKE hrap_file.hrap05,
      hrap06         LIKE hrap_file.hrap06,
      hrap01         LIKE hrap_file.hrap01,
      hrap02         LIKE hrap_file.hrap02,
      hrap07         LIKE hrap_file.hrap07,              
      hrap08         LIKE hrap_file.hrap08,
      hrao00         LIKE hrao_file.hrao00,
      hraa02         LIKE hraa_file.hraa02
                     END RECORD,                                                                                                              
    g_rec_b         LIKE type_file.num5,  
    g_rec_b1         LIKE type_file.num5,             
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
          name           LIKE type_file.chr1000,                 
          img            LIKE type_file.chr1000, #add by zhuzw 20130916
          pid            LIKE hraa_file.hraa01, 
          id             LIKE hrao_file.hrao01,  
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),
          treekey2       VARCHAR(1000)
          END RECORD
      
DEFINE g_tree_focus_idx  STRING                 
DEFINE g_tree_reload     LIKE type_file.chr1     
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
    
    DROP TABLE q002_tmp
    CREATE TEMP TABLE q002_tmp(
        hrao01  LIKE  hrao_file.hrao01,
        img     LIKE type_file.chr1000, #add by zhuzw 20130916
        idx     LIKE  type_file.num5,
        chr     LIKE  type_file.chr1)
        
    DROP TABLE q002_tmp2
    CREATE TEMP TABLE q002_tmp2(
        a          LIKE  type_file.chr1000,
        k          LIKE  type_file.chr1000,
        b          LIKE  hraa_file.hraa01,
        c          LIKE  hrao_file.hrao01,
        d          BOOLEAN,                
        e          BOOLEAN,                
        f          INTEGER,   
        g          VARCHAR(1000),
        h          VARCHAR(1000)
        )    
        
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q002_w AT p_row,p_col WITH FORM "ghr/42f/ghrq002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    LET g_f = '1'
    CALL cl_ui_init()
    CALL  q002_menu()
    CLOSE WINDOW q002_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q002_menu()
 
   WHILE TRUE
      CALL q002_tree_fill()
      
      CALL q002_bp("G")
      
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
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrap),'','')
               END IF   
                                           
            END IF                     
      END CASE
   END WHILE 
END FUNCTION
	
FUNCTION q002_bp(p_ud)
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
            DELETE FROM q002_tmp
            IF g_tree[l_tree_ac].treekey1='N' THEN
               INSERT INTO q002_tmp VALUES(g_tree[l_tree_ac].id,"bumen.ico",g_tree[l_tree_ac].level,g_tree[l_tree_ac].treekey1)
            END IF   
            CALL q002_b_fill_1(g_tree[l_tree_ac].id,g_tree[l_tree_ac].level,g_tree[l_tree_ac].treekey1)
            CALL q002_b_fill() 	    
                        
      #ON ACTION accept
      #   CALL q002_drill_gl(g_tree[l_tree_ac].id)
      #   EXIT DIALOG  

      ON ACTION ghrq002_a
         CALL q002_drill_gl('','')
         EXIT DIALOG
         
      ON ACTION page1
         LET g_f = '1'
                                    
      #ON ACTION hraa01
      #   CALL q002_drill_gl('1=0')
      #   EXIT DIALOG
                                       
      END DISPLAY 
            
      DISPLAY ARRAY g_hrap TO s_hrap.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION accept
         CALL q002_drill_gl(g_hrap[l_ac].hrap01,g_hrap[l_ac].hrap05)
         EXIT DIALOG  
         
      #ON ACTION hraa01
      #   CALL q002_drill_gl('1=0')
      #   EXIT DIALOG

      ON ACTION ghrq002_a
         CALL q002_drill_gl('','')
         EXIT DIALOG
                                        
      ON ACTION page1
         LET g_f = '1'
           
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

#公司之下属公司	
FUNCTION q002_b_fill_1(p_id,p_level,p_key1)
DEFINE p_id     LIKE  hrao_file.hrao01
DEFINE p_level  LIKE  type_file.num5
DEFINE l_level  LIKE  type_file.num5
DEFINE p_key1   LIKE  type_file.chr1
DEFINE l_hrap   DYNAMIC ARRAY OF RECORD 
         id     LIKE    hrao_file.hrao01,
         level  LIKE    type_file.num5,
         chr    LIKE    type_file.chr1 
                END RECORD
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_i      LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5
DEFINE l_sql    STRING
DEFINE li_sql   STRING
        
        LET p_level=p_level+1

        LET l_sql=" SELECT c,f,g FROM q002_tmp2 WHERE b='",p_id,"'",
                  "                               AND f=",p_level,
                  "                               AND h='",p_key1,"'"

        PREPARE q002_hrap_pb1 FROM l_sql
        DECLARE q002_hrap_cs1 CURSOR FOR q002_hrap_pb1
        
        LET l_cnt=1
        
        FOREACH q002_hrap_cs1 INTO l_hrap[l_cnt].*
        
           IF SQLCA.sqlcode THEN
              CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
           LET l_cnt=l_cnt+1
           
        END FOREACH
        
        CALL l_hrap.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
        LET l_cnt = l_cnt - 1   	
       
        IF l_cnt>0 THEN
        	 FOR l_i = 1 TO l_cnt
        	    IF l_hrap[l_i].chr='N' THEN
        	       INSERT INTO q002_tmp VALUES(l_hrap[l_i].id,"",l_hrap[l_i].level,l_hrap[l_i].chr)
        	    END IF   
        	    LET l_n=0 
                    LET l_level=l_hrap[l_i].level+1
        	    LET li_sql="SELECT COUNT(*) FROM q002_tmp2 WHERE b='",l_hrap[l_i].id,"'",
                               "                                 AND f=",l_level,
                               "                                 AND h='",l_hrap[l_i].chr,"'"
                    PREPARE q002_count FROM li_sql
                    EXECUTE q002_count INTO l_n
        	    IF l_n>0 THEN
        	    	 CALL q002_b_fill_1(l_hrap[l_i].id,l_hrap[l_i].level,l_hrap[l_i].chr)  
        	    END IF
           END FOR
        END IF   	    		        
           
END FUNCTION        

FUNCTION q002_b_fill()
DEFINE l_sql   STRING
DEFINE l_hrap01  LIKE  hrap_file.hrap01
DEFINE l_cnt     LIKE  type_file.num5

       CALL g_hrap.clear()
       LET g_rec_b=0
       LET l_sql=" SELECT hrao01 FROM q002_tmp ORDER BY idx"	
       PREPARE q002_hrap_pb2 FROM l_sql
       DECLARE q002_hrap_cs2 CURSOR FOR q002_hrap_pb2
       
       LET l_cnt=1
       
       FOREACH q002_hrap_cs2 INTO l_hrap01
          IF SQLCA.sqlcode THEN
              CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
          
          LET l_sql=" SELECT hrap05,hrap06,hrap01,hrap02,hrap07,hrap08,'','' ",
                    "   FROM hrap_file ",
                    "  WHERE hrap01='",l_hrap01,"'"

          PREPARE q002_hrap_pb3 FROM l_sql
          DECLARE q002_hrap_cs3 CURSOR FOR q002_hrap_pb3
          
          FOREACH q002_hrap_cs3 INTO g_hrap[l_cnt].*
             SELECT hrao00,hraa12 INTO g_hrap[l_cnt].hrao00,g_hrap[l_cnt].hraa02 
               FROM hrao_file,hraa_file
              WHERE hraoacti = 'Y' AND hrao00=hraa01
                AND hrao01=g_hrap[l_cnt].hrap01
             
             LET l_cnt=l_cnt+1     	
          	
          END FOREACH
	     END FOREACH
		   
		   CALL g_hrap.deleteElement(l_cnt)
       LET  g_rec_b= l_cnt-1
       LET  l_cnt = 0

END FUNCTION
       
       
FUNCTION q002_tree_fill()
DEFINE p_level,l_n,l_n1,l_n2   LIKE   type_file.num5
DEFINE l_sql    STRING
DEFINE l_tree   RECORD
         name           LIKE  type_file.chr1000,
         img            LIKE type_file.chr1000, #add by zhuzw 20130916
         pid            LIKE  hraa_file.hraa01,
         id             LIKE hrao_file.hrao01,
         has_children   BOOLEAN,
         expanded       BOOLEAN,
         level          LIKE type_file.num5,
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD

   DELETE FROM q002_tmp2
	 
   INITIALIZE g_tree TO NULL
   LET g_idx=0
   LET p_level=0
   #LET g_idx=g_idx+1
   #LET g_tree[g_idx].id='JTJG'
   #LET g_tree[g_idx].name='集团架构'
   #LET g_tree[g_idx].expanded=1
   #LET g_tree[g_idx].pid = NULL
   #LET g_tree[g_idx].has_children = TRUE
   #LET g_tree[g_idx].level = p_level
   #LET g_tree[g_idx].treekey1 = 'Y'

   SELECT DISTINCT hraa01,hraa12 INTO l_tree.id,l_tree.name
     FROM hraa_file WHERE hraaacti='Y' AND hraa10 IS NULL 
   
   #PREPARE q002_pb5 FROM l_sql
   #DECLARE q002_cs5 CURSOR FOR q002_pb5
   #LET g_idx=g_idx+1
   #LET p_level=p_level+1

   #FOREACH q002_cs5 INTO g_tree[g_idx].id,g_tree[g_idx].name
      LET l_tree.expanded=1
      LET l_tree.pid = NULL
      LET l_tree.level = p_level
      LET l_tree.treekey1 = 'Y'
      
      SELECT COUNT(*) INTO l_n1 FROM hraa_file WHERE hraa10=l_tree.id
      SELECT COUNT(*) INTO l_n2 FROM hrao_file WHERE hraoacti = 'Y' AND hrao00=l_tree.id
   
      IF l_n1>0 OR l_n2>0 THEN
         LET l_tree.has_children = TRUE
      ELSE
         LET l_tree.has_children = FALSE
      END IF
      
      INSERT INTO q002_tmp2 VALUES(l_tree.name,l_tree.pid,"",l_tree.id,l_tree.has_children,
                                   l_tree.expanded,l_tree.level,l_tree.treekey1,l_tree.treekey2)

      IF l_n1>0 THEN
         CALL q002_tree_fill_1(p_level,l_tree.id)       #公司之下级公司
      END IF
   
#      IF l_n2>0 THEN
#         CALL q002_tree_fill_2(p_level,g_tree[g_idx].id)       #公司之下级部门
#      END IF   
     
   #   LET g_idx=g_idx+1
   #END FOREACH

   #LET g_idx=g_idx-1
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM q002_tmp2 WHERE 1=1
   IF l_n>0 THEN
   	  CALL q002_tree_fill_2()
   END IF	   
   
   CALL q002_tree_fill_3()
   
   CALL q002_tree_show()
   
END FUNCTION
	
FUNCTION q002_tree_fill_1(p_level,p_id)
DEFINE p_level,l_n1,l_n2     LIKE    type_file.num5
DEFINE p_id   LIKE hraa_file.hraa10	
DEFINE l_sql  STRING
DEFINE l_hraa      DYNAMIC ARRAY OF RECORD
          hraa01      LIKE    hrao_file.hrao01
                END RECORD
DEFINE l_cnt2    LIKE  type_file.num5
DEFINE l_name   LIKE  hraa_file.hraa12
DEFINE l_i      LIKE  type_file.num5
DEFINE l_tree   RECORD
         name           LIKE  type_file.chr1000,
         img            LIKE type_file.chr1000, #add by zhuzw 20130916
         pid            LIKE  hraa_file.hraa01,
         id             LIKE hrao_file.hrao01,  
         has_children   BOOLEAN,                
         expanded       BOOLEAN,                
         level          LIKE type_file.num5,    
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD 

      LET l_sql=" SELECT hraa01 FROM hraa_file WHERE hraa10='",p_id,"'"  
      PREPARE q002_pb6 FROM l_sql
      DECLARE q002_cs6 CURSOR FOR q002_pb6

       LET l_cnt2=1
                
       FOREACH q002_cs6 INTO l_hraa[l_cnt2].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt2 = l_cnt2 + 1 
       END FOREACH
       
       CALL l_hraa.deleteelement(l_cnt2)  #刪除FOREACH最後新增的空白列
       LET l_cnt2 = l_cnt2 - 1
       
       LET p_level = p_level + 1
       IF l_cnt2 > 0 THEN 
          FOR l_i = 1 TO l_cnt2
             LET l_tree.expanded = 1          #0:不展, 1:展     
             SELECT hraa12 INTO  l_name  FROM hraa_file      
              WHERE hraa01 = l_hraa[l_i].hraa01               
             LET l_tree.name = l_name 
             LET l_tree.id = l_hraa[l_i].hraa01
             LET l_tree.pid = p_id
             LET l_tree.level = p_level
             LET l_tree.treekey1 = 'Y'
             LET l_tree.treekey2 = 'Y'
             SELECT COUNT(*) INTO l_n1 FROM hraa_file WHERE hraa10=l_hraa[l_i].hraa01
             SELECT COUNT(*) INTO l_n2 FROM hrao_file WHERE hraoacti = 'Y' AND hrao00=l_hraa[l_i].hraa01
             IF l_n1 > 0 OR l_n2>0 THEN 
                LET l_tree.has_children = TRUE  
             ELSE 
                LET l_tree.has_children = FALSE    	
             END IF 
             	
             INSERT INTO q002_tmp2 VALUES(l_tree.*)	
             
             IF l_n1 > 0 THEN 
                CALL q002_tree_fill_1(p_level,l_hraa[l_i].hraa01) 
             END IF	
             	
          END FOR     
       END IF        
             
END FUNCTION	
	
FUNCTION q002_tree_fill_2()
DEFINE p_level,l_n   LIKE  type_file.num5
DEFINE p_cmd         LIKE  type_file.chr1
DEFINE l_sql         STRING	
DEFINE p_id          STRING
DEFINE l_tmp         RECORD
         id      LIKE    hraa_file.hraa01,
         level   LIKE    type_file.num5
                END RECORD
DEFINE l_cnt    LIKE  type_file.num5
DEFINE l_name   LIKE  hrao_file.hrao02 
DEFINE l_i      LIKE  type_file.num5
DEFINE l_tree   RECORD
         name           LIKE  type_file.chr1000,
         img            LIKE type_file.chr1000, #add by zhuzw 20130916
         pid            LIKE  hraa_file.hraa01,
         id             LIKE  hrao_file.hrao01,  
         has_children   BOOLEAN,                
         expanded       BOOLEAN,                
         level          LIKE type_file.num5,    
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD

                             
       LET l_sql=" SELECT c,f FROM q002_tmp2 WHERE g ='Y' ORDER BY f"
       PREPARE q002_pb7 FROM l_sql
       DECLARE q002_cs7 CURSOR FOR q002_pb7          
                
       FOREACH q002_cs7 INTO l_tmp.*            

          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          	
          LET l_sql=" SELECT hrao02,hrao01 FROM hrao_file ",
                    "  WHERE hraoacti = 'Y' AND hrao00='",l_tmp.id,"' AND hrao05='Y' "
          PREPARE q002_pb9 FROM l_sql
          DECLARE q002_cs9 CURSOR FOR q002_pb9
          
          FOREACH q002_cs9 INTO l_tree.name,l_tree.id
             LET l_tree.pid=l_tmp.id                        
             LET l_tree.expanded=1
             LET l_tree.level=l_tmp.level+1
             LET l_tree.treekey1='N'
             LET l_tree.treekey2='Y'
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hraoacti = 'Y' AND hrao06=l_tree.id
             IF l_n>0 THEN
          	    LET l_tree.has_children = TRUE  
             ELSE 
                LET l_tree.has_children = FALSE    	
             END IF 
             
             INSERT INTO q002_tmp2 VALUES(l_tree.*)
             
             	  
          END FOREACH
       END FOREACH
       
END FUNCTION
	
FUNCTION q002_tree_fill_3()
DEFINE p_level,l_n   LIKE  type_file.num5
DEFINE p_cmd         LIKE  type_file.chr1
DEFINE l_sql         STRING	
DEFINE p_id          STRING
DEFINE ls_tree       DYNAMIC ARRAY OF RECORD
          id         LIKE   hrao_file.hrao01,
          level      LIKE   type_file.num5
                END RECORD
DEFINE l_cnt1    LIKE  type_file.num5
DEFINE l_name    LIKE  hrao_file.hrao02
DEFINE l_i       LIKE  type_file.num5
      
    	    	                
       LET l_sql=" SELECT c,f FROM q002_tmp2 WHERE g='N' "
       
       PREPARE q002_pb8 FROM l_sql
       DECLARE q002_cs8 CURSOR FOR q002_pb8
       
       LET l_cnt1 = 1
       
       FOREACH q002_cs8 INTO ls_tree[l_cnt1].*            
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#          CALL q002_tree_fill_4(ls_tree[l_cnt1].level,ls_tree[l_cnt1].id)	
          LET l_cnt1 = l_cnt1 + 1 
       END FOREACH
       
       CALL ls_tree.deleteelement(l_cnt1)  #刪除FOREACH最後新增的空白列
       LET l_cnt1 = l_cnt1 - 1  
       
       IF l_cnt1 > 0 THEN 
          FOR l_i = 1 TO l_cnt1 
             CALL q002_tree_fill_4(ls_tree[l_i].level,ls_tree[l_i].id) 
          END FOR     
       END IF         
       
    
END FUNCTION 
	
FUNCTION q002_tree_fill_4(p_level,p_id)
DEFINE p_level     LIKE     type_file.num5
DEFINE p_id        LIKE     hrao_file.hrao01
DEFINE l_cnt,l_n,l_i   LIKE     type_file.num5
DEFINE l_sql	     STRING
DEFINE l_hrao      DYNAMIC ARRAY OF RECORD
         hrao01    LIKE  hrao_file.hrao01
                   END RECORD
DEFINE l_tree   RECORD
         name           LIKE  type_file.chr1000,
         img            LIKE type_file.chr1000, #add by zhuzw 20130916
         pid            LIKE  hraa_file.hraa01,
         id             LIKE  hrao_file.hrao01,  
         has_children   BOOLEAN,                
         expanded       BOOLEAN,                
         level          LIKE type_file.num5,    
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD
DEFINE l_name      LIKE   hrao_file.hrao02                                   	     
	     
	     LET l_sql=" SELECT hrao01 FROM hrao_file WHERE hraoacti = 'Y' AND hrao06='",p_id,"'"
	     
	     PREPARE q002_pb10 FROM l_sql
	     DECLARE q002_cs10 CURSOR FOR q002_pb10
	     
	     LET l_cnt=1
	     
	     FOREACH q002_cs10 INTO l_hrao[l_cnt].*
	        IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt=l_cnt+1
       END FOREACH
       
       CALL l_hrao.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
       LET l_cnt = l_cnt - 1   	
	     
	     LET p_level = p_level + 1
       IF l_cnt > 0 THEN 
          FOR l_i = 1 TO l_cnt
             LET l_tree.expanded = 1          #0:不展, 1:展     
             SELECT hrao02 INTO  l_name  FROM hrao_file      
              WHERE hraoacti = 'Y' AND hrao01 = l_hrao[l_i].hrao01               
             LET l_tree.name = l_name 
             LET l_tree.id = l_hrao[l_i].hrao01
             LET l_tree.pid = p_id
             LET l_tree.level = p_level
             LET l_tree.treekey1 = 'N'
             LET l_tree.treekey2 = 'N'
             SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hraoacti = 'Y' AND hrao06=l_hrao[l_i].hrao01
             IF l_n > 0 THEN 
                LET l_tree.has_children = TRUE  
             ELSE 
                LET l_tree.has_children = FALSE    	
             END IF 
             	
             INSERT INTO q002_tmp2 VALUES(l_tree.*)	
             
             IF l_n > 0 THEN 
                CALL q002_tree_fill_4(p_level,l_hrao[l_i].hrao01) 
             END IF	
             	
          END FOR     
       END IF        

END FUNCTION	      
	
FUNCTION q002_tree_show()
DEFINE l_sql STRING
DEFINE l_n   LIKE   type_file.num5

       LET l_sql=" SELECT * FROM q002_tmp2 WHERE b IS NULL ORDER BY a"
       	
       PREPARE q002_pb11 FROM l_sql
       DECLARE q002_cs11 CURSOR FOR q002_pb11
       
       LET g_idx=1
       
       FOREACH q002_cs11 INTO g_tree[g_idx].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_n=0
          IF g_tree[g_idx].treekey1 = 'Y' THEN
             LET g_tree[g_idx].img = "gongsi.ico" #add by zhuzw 20130916
          ELSE 
          	 LET g_tree[g_idx].img = "bumen.ico" #add by zhuzw 20130916   
          END IF   

          SELECT COUNT(*) INTO l_n FROM q002_tmp2 WHERE b=g_tree[g_idx].id
          IF l_n>0 THEN	
             CALL q002_tree_show_2(g_tree[g_idx].id,g_tree[g_idx].level,g_tree[g_idx].treekey1)
          END IF   	
          LET g_idx=g_idx+1
       END FOREACH   	 
       
       CALL g_tree.deleteelement(g_idx)  #刪除FOREACH最後新增的空白列
       LET g_idx=g_idx-1
       
END FUNCTION           	
	     	                     	
FUNCTION q002_tree_show_2(p_id,p_level,p_key1)
DEFINE l_sql   STRING
DEFINE p_id    LIKE  hrao_file.hrao02
DEFINE p_level LIKE  type_file.num5
DEFINE p_key1  LIKE  type_file.chr1
DEFINE l_tree   DYNAMIC ARRAY OF RECORD
         name           LIKE  type_file.chr1000,
         img            LIKE type_file.chr1000, #add by zhuzw 20130916
         pid            LIKE  hraa_file.hraa01,
         id             LIKE  hrao_file.hrao01,  
         has_children   BOOLEAN,                
         expanded       BOOLEAN,                
         level          LIKE type_file.num5,    
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD
DEFINE  l_cnt,l_i,l_n      LIKE  type_file.num5
             
       
       LET p_level=p_level+1      
       LET l_sql=" SELECT * FROM q002_tmp2 WHERE b='",p_id,"'",
                 "                           AND f='",p_level,"'",
                 "                           AND h='",p_key1,"'",
                 "  ORDER BY g desc,a "
       PREPARE q002_pb12 FROM l_sql
       DECLARE q002_cs12 CURSOR FOR q002_pb12
       
       LET l_cnt=1
       
       FOREACH q002_cs12 INTO l_tree[l_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF  
          
          LET l_cnt=l_cnt+1
       END FOREACH
       
       CALL l_tree.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
       LET l_cnt = l_cnt - 1   	
       
       IF l_cnt > 0 THEN 
       FOR l_i = 1 TO l_cnt 
          LET g_idx = g_idx + 1
          LET g_tree[g_idx].name=l_tree[l_i].name
          LET g_tree[g_idx].pid=l_tree[l_i].pid
          LET g_tree[g_idx].id=l_tree[l_i].id
          LET g_tree[g_idx].has_children=l_tree[l_i].has_children
          LET g_tree[g_idx].level=l_tree[l_i].level
          LET g_tree[g_idx].expanded=l_tree[l_i].expanded
          LET g_tree[g_idx].treekey1=l_tree[l_i].treekey1
          LET g_tree[g_idx].treekey2=l_tree[l_i].treekey2
          IF g_tree[g_idx].treekey1 = 'Y' THEN
             LET g_tree[g_idx].img = "gongsi.ico" #add by zhuzw 20130916
          ELSE 
          	 LET g_tree[g_idx].img = "bumen.ico" #add by zhuzw 20130916   
          END IF   

          SELECT COUNT(*) INTO l_n FROM q002_tmp2 WHERE b=g_tree[g_idx].id
          IF l_n > 0 THEN 
             CALL q002_tree_show_2(g_tree[g_idx].id,g_tree[g_idx].level,g_tree[g_idx].treekey1) 
          END IF 
       END FOR     
   END IF 
   	
END FUNCTION   	        
       
                   	
FUNCTION q002_drill_gl(p_hrap01,p_hrap05)
   DEFINE l_sql,l_occ01 STRING
   DEFINE l_flg     LIKE type_file.chr1
   DEFINE l_cn1     LIKE type_file.num5
   DEFINE p_hrap01  LIKE hrap_file.hrap01
   DEFINE p_hrap05  LIKE hrap_file.hrap05
          

   IF l_ac = 0 THEN RETURN END IF 
   #IF cl_null(p_id) THEN RETURN END IF  
   #LET g_msg = "ghri002 '",p_hrap01,"' '",p_hrap05,"'" 
   LET g_msg = "ghri002 '",p_hrap01,"'"
   CALL cl_cmdrun_wait(g_msg)
   CALL q002_tree_fill()
   
END FUNCTION		
