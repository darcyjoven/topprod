# Prog. Version..: '5.10.03-08.08.20(00009)''     #
#
# Pattern name...: ghrq001.4gl
# Descriptions...: 
# Date & Author..: 2013/03/12 by zhangbo
# .......................modify: by zhuzw 20130916 赂锟戒嵓卤鑻?
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1   LIKE hrao_file.hrao01,
    ddflag   LIKE type_file.chr1,                 
    g_wc,g_wc2,g_sql    STRING, 
    g_cott          LIKE type_file.num5,          
    g_hrao           DYNAMIC ARRAY OF RECORD 
      chk            LIKE type_file.chr1,
      hrao01         LIKE hrao_file.hrao01,
      hrao02         LIKE hrao_file.hrao02,
      hrao03         LIKE hrao_file.hrao03,
      hrao06         LIKE hrao_file.hrao06,
      hrao06_desc    LIKE hrao_file.hrao02,
      hrao00         LIKE hrao_file.hrao00,
      hraa12         LIKE hraa_file.hraa12,              
      hrao10         LIKE hrao_file.hrao10,
      hrao10_desc    LIKE hrao_file.hrao02,
      hrao09         LIKE hrao_file.hrao09,
      hrao13         LIKE hrao_file.hrao13
                     END RECORD,
    g_hrao1           DYNAMIC ARRAY OF RECORD 
      hrao01         LIKE hrao_file.hrao01,
      hrao02         LIKE hrao_file.hrao02,
      hrao03         LIKE hrao_file.hrao03,
      hrao06         LIKE hrao_file.hrao06,
      hrao06_desc    LIKE hrao_file.hrao02,
      hrao00         LIKE hrao_file.hrao00,
      hraa12         LIKE hraa_file.hraa12,              
      hrao10         LIKE hrao_file.hrao10,
      hrao10_desc    LIKE hrao_file.hrao02,
      hrao09         LIKE hrao_file.hrao09,
      hrao13         LIKE hrao_file.hrao13
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
    
    DROP TABLE q001_tmp
    CREATE TEMP TABLE q001_tmp(
        hrao01   LIKE hrao_file.hrao01,
        hrao02   LIKE hrao_file.hrao02,
        hrao03   LIKE hrao_file.hrao03,
        hrao06   LIKE hrao_file.hrao06,
        hrao00   LIKE hrao_file.hrao00,
        hrao10   LIKE hrao_file.hrao10,
        hrao09   LIKE hrao_file.hrao09,
        hrao13   LIKE hrao_file.hrao13,
        hraoacti LIKE hrao_file.hraoacti)
        
    DROP TABLE q001_tmp2
    CREATE TEMP TABLE q001_tmp2(
        a          LIKE  type_file.chr1000,
        k					 LIKE  type_file.chr1000,
        b          LIKE  hraa_file.hraa01,
        c          LIKE  hrao_file.hrao01,
        d          BOOLEAN,                
        e          BOOLEAN,                
        f          INTEGER,   
        g          VARCHAR(1000),
        h          VARCHAR(1000)
        )    
        
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q001_w AT p_row,p_col WITH FORM "ghr/42f/ghrq001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    LET g_f = '1'
    CALL cl_ui_init()
    CALL  q001_menu()
    CLOSE WINDOW q001_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q001_menu()
 
   WHILE TRUE
      CALL q001_tree_fill()
      
      CALL q001_bp("G")
      
      CASE g_action_choice
         WHEN "help"
            IF cl_chk_act_auth() THEN        
              CALL cl_show_help()            
            END IF                           
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#add by zhuzw 20150402 start
         WHEN "bmhb" #部门合并
              CALL q001_b()
              CALL q001_hb()

#add by zhuzw 20150402 end
#add by zhuzw 20150402 start
         WHEN "bmhz" #部门划转
              CALL q001_b()
              CALL q001_hz()

#add by zhuzw 20150402 end
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_f = '1' THEN  
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrao),'','')
               END IF 
               IF g_f = '2' THEN  
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrao1),'','')  
               END IF     
                                           
            END IF                     
      END CASE
   END WHILE 
END FUNCTION
	
FUNCTION q001_bp(p_ud)
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
            #IF g_tree[l_tree_ac].treekey1='Y' THEN
            #	 DELETE FROM q001_tmp WHERE 1=1
            #   LET l_wc = " hrao00 = '",g_tree[l_tree_ac].id,"' " 
            #   CALL q001_b_fill_1(l_wc)
            #ELSE
            #	 DELETE FROM q001_tmp WHERE 1=1
            # 	 CALL q001_b_fill_pre(g_tree[l_tree_ac].id)
            #	 CALL q001_b_fill_2()
            #END IF 	
            
            CALL q001_b_fill(g_tree[l_tree_ac].id,g_tree[l_tree_ac].treekey1)    
            
            
      ON ACTION accept
         CALL q001_drill_gl(g_tree[l_tree_ac].id)
         EXIT DIALOG  

      ON ACTION xinzeng
         CALL q001_drill_gl('')
         EXIT DIALOG
         
      ON ACTION page1
         LET g_f = '1'
          
      ON ACTION page2
         LET g_f = '2' 
                                   
      #ON ACTION hraa01
      #   CALL q001_drill_gl('1=0')
      #   EXIT DIALOG
                                       
      END DISPLAY 
            
      DISPLAY ARRAY g_hrao TO s_hrao.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION accept
         CALL q001_drill_gl(g_hrao[l_ac].hrao01)
         EXIT DIALOG  
         
      #ON ACTION hraa01
      #   CALL q001_drill_gl('1=0')
      #   EXIT DIALOG

      ON ACTION xinzeng
         CALL q001_drill_gl('')
         EXIT DIALOG
##add by zhuzw 20150402 start
#      ON ACTION bmhb #部门合并
#         CALL q001_b()
#         CALL q001_hb()
##add by zhuzw 20150402 end                                         
      ON ACTION page1
         LET g_f = '1'
          
      ON ACTION page2
         LET g_f = '2'
           
      END DISPLAY 
        
      DISPLAY ARRAY g_hrao1 TO s_hrao1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION accept
         CALL q001_drill_gl(g_hrao1[l_ac].hrao01)
         EXIT DIALOG  

      ON ACTION xinzeng
         CALL q001_drill_gl('')
         EXIT DIALOG
         
      #ON ACTION hraa01
      #   CALL q001_drill_gl('1=0'	)
      #   EXIT DIALOG
             
      ON ACTION page1
         LET g_f = '1'
          
      ON ACTION page2
         LET g_f = '2'
                                               
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
 #add by zhuzw 20150402 start
      ON ACTION bmhb #部门合并
         LET g_action_choice="bmhb"
         EXIT DIALOG 
#add by zhuzw 20150402 end  
 #add by zhuzw 20150402 start
      ON ACTION bmhz #部门划转
         LET g_action_choice="bmhz"
         EXIT DIALOG 
#add by zhuzw 20150402 end 
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
	
FUNCTION q001_b_fill_1(p_wc2)              
DEFINE p_wc2    LIKE type_file.chr1000  
DEFINE l_color   LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1     LIKE type_file.num5
 #-------page1    
   LET g_sql =  " SELECT 'N',hrao01,hrao02,hrao03,hrao06,hrao00,hrao10,hrao09,hrao13 ",
                "   FROM hrao_file ",
                "  WHERE hraoacti = 'Y' ",
                "    AND hrao05='Y' ",
                "    AND ",p_wc2 CLIPPED,
                " ORDER BY hrao01 "            
    PREPARE q001_pb FROM g_sql
    DECLARE hrao_curs CURSOR FOR q001_pb
 
    CALL g_hrao.clear()
    LET g_rec_b = 0
    LET l_cnt = 1

    FOREACH hrao_curs INTO g_hrao[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_hrao.deleteElement(l_cnt)
    LET g_rec_b= l_cnt-1
    LET l_cnt = 0
    LET g_ac=1
#--- page2
   LET g_sql =  " SELECT hrao01,hrao02,hrao03,hrao06,hrao00,hrao10,hrao09,hrao13 ",
                "   FROM hrao_file ",
                "  WHERE hraoacti = 'N' ",
                "    AND hrao05='Y' ", 
                "    AND ",p_wc2 CLIPPED,
                " ORDER BY hrao01 "            
    PREPARE q001_pb2 FROM g_sql
    DECLARE hrao_curs2 CURSOR FOR q001_pb2
 
    CALL g_hrao1.clear()
    LET g_rec_b1 = 0
    LET l_cnt1 = 1

    FOREACH hrao_curs2  INTO g_hrao1[l_cnt1].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt1 = l_cnt1 + 1
    END FOREACH
    CALL g_hrao1.deleteElement(l_cnt1)
    LET g_rec_b1= l_cnt1-1
    LET l_cnt1 = 0
    LET g_ac=1

END FUNCTION	

FUNCTION q001_b_fill_pre(p_hrao06)
DEFINE p_hrao06    LIKE hrao_file.hrao06  
DEFINE l_color     LIKE type_file.chr100 
DEFINE l_i,l_n,l_cnt,l_cnt1     LIKE type_file.num5
DEFINE l_hrao     DYNAMIC ARRAY OF RECORD 
         hrao01   LIKE   hrao_file.hrao01,
         hrao02   LIKE   hrao_file.hrao02,
         hrao03   LIKE   hrao_file.hrao03,
         hrao06   LIKE   hrao_file.hrao06,
         hrao00   LIKE   hrao_file.hrao00,
         hrao10   LIKE   hrao_file.hrao10,
         hrao09   LIKE   hrao_file.hrao09,
         hrao13   LIKE   hrao_file.hrao13,
         hraoacti LIKE   hrao_file.hraoacti
                 END RECORD
         
    IF NOT cl_null(p_hrao06) THEN 
       LET g_sql =  " SELECT hrao01,hrao02,hrao03,hrao06,hrao00,hrao10,hrao09,hrao13,hraoacti ",
                    "   FROM hrao_file ",
                    "  WHERE hraoacti = 'Y' AND hrao06='",p_hrao06,"'",
                    "    AND hrao05='N' ",
                    " ORDER BY hrao01 "            
       PREPARE q001_pb_y FROM g_sql
       DECLARE hrao_curs_y CURSOR FOR q001_pb_y
       LET l_cnt=1
       FOREACH hrao_curs_y  INTO l_hrao[l_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#          INSERT INTO q001_tmp VALUES(l_hrao.*)
#          LET l_cnt=0
#          SELECT COUNT(*) INTO l_cnt FROM hrao_file WHERE hrao06=l_hrao.hrao01
#          IF l_cnt>0 THEN	
#          	 CALL q001_b_fill_pre(l_hrao.hrao01)
#          END IF
          LET l_cnt=l_cnt+1	 
       END FOREACH         
       CALL l_hrao.deleteelement(l_cnt)  #鍒櫎FOREACH鏈€寰屾柊澧炵殑绌虹櫧鍒?
       LET l_cnt = l_cnt - 1 
       
       IF l_cnt > 0 THEN 
          FOR l_i = 1 TO l_cnt

             INSERT INTO q001_tmp VALUES(l_hrao[l_i].*) 

             SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao06=l_hrao[l_i].hrao01
             IF l_n > 0 THEN 
                CALL q001_b_fill_pre(l_hrao[l_i].hrao01) 
             END IF 
          END FOR     
       END IF         
        
    END IF 	

END FUNCTION    	
	
FUNCTION q001_b_fill_2()
DEFINE p_wc2    LIKE type_file.chr1000  
DEFINE l_color   LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1     LIKE type_file.num5
 #-------page1    
   LET g_sql =  " SELECT 'N',hrao01,hrao02,hrao03,hrao06,hrao00,hrao10,hrao09,hrao13 ",
                "   FROM q001_tmp ",
                "  WHERE hraoacti = 'Y' ",
                " ORDER BY hrao01 "            
    PREPARE q001_pb3 FROM g_sql
    DECLARE hrao_curs3 CURSOR FOR q001_pb3
 
    CALL g_hrao.clear()
    LET g_rec_b = 0
    LET l_cnt = 1

    FOREACH hrao_curs3  INTO g_hrao[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_hrao.deleteElement(l_cnt)
    LET g_rec_b= l_cnt-1
    LET l_cnt = 0
    LET g_ac=1
#--- page2
   LET g_sql =  " SELECT hrao01,hrao02,hrao03,hrao06,hrao00,hrao10,hrao09,hrao13 ",
                "   FROM q001_tmp ",
                "  WHERE hraoacti = 'N' ",
                " ORDER BY hrao01 "            
    PREPARE q001_pb4 FROM g_sql
    DECLARE hrao_curs4 CURSOR FOR q001_pb4
 
    CALL g_hrao1.clear()
    LET g_rec_b1 = 0
    LET l_cnt1 = 1

    FOREACH hrao_curs4  INTO g_hrao1[l_cnt1].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_cnt1 = l_cnt1 + 1
    END FOREACH
    CALL g_hrao1.deleteElement(l_cnt1)
    LET g_rec_b1= l_cnt1-1
    LET l_cnt1 = 0
    LET g_ac=1

END FUNCTION	
	
FUNCTION q001_tree_fill()
DEFINE p_level,l_n,l_n1,l_n2   LIKE   type_file.num5
DEFINE l_sql    STRING
DEFINE l_tree   RECORD
         name           LIKE  type_file.chr1000,
         pid            LIKE  hraa_file.hraa01,
         id             LIKE hrao_file.hrao01,
         has_children   BOOLEAN,
         expanded       BOOLEAN,
         level          LIKE type_file.num5,
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD

   DELETE FROM q001_tmp2
	 
   INITIALIZE g_tree TO NULL
   LET g_idx=0
   LET p_level=0
   #LET g_idx=g_idx+1
   #LET g_tree[g_idx].id='JTJG'
   #LET g_tree[g_idx].name='闆嗗洟鏋舵瀯'
   #LET g_tree[g_idx].expanded=1
   #LET g_tree[g_idx].pid = NULL
   #LET g_tree[g_idx].has_children = TRUE
   #LET g_tree[g_idx].level = p_level
   #LET g_tree[g_idx].treekey1 = 'Y'

   SELECT DISTINCT hraa01,hraa12 INTO l_tree.id,l_tree.name
     FROM hraa_file WHERE hraaacti='Y' AND hraa10 IS NULL 
   
   #PREPARE q001_pb5 FROM l_sql
   #DECLARE q001_cs5 CURSOR FOR q001_pb5
   #LET g_idx=g_idx+1
   #LET p_level=p_level+1

   #FOREACH q001_cs5 INTO g_tree[g_idx].id,g_tree[g_idx].name
      LET l_tree.expanded=1
      LET l_tree.pid = NULL
      LET l_tree.level = p_level
      LET l_tree.treekey1 = 'Y'
      LET l_tree.treekey2 = 'Y'
      
      SELECT COUNT(*) INTO l_n1 FROM hraa_file WHERE hraa10=l_tree.id
      SELECT COUNT(*) INTO l_n2 FROM hrao_file WHERE hrao00=l_tree.id
   
      IF l_n1>0 OR l_n2>0 THEN
         LET l_tree.has_children = TRUE
      ELSE
         LET l_tree.has_children = FALSE
      END IF
      
      INSERT INTO q001_tmp2 VALUES(l_tree.name,"gongsi.ico",l_tree.pid,l_tree.id,l_tree.has_children,
                                   l_tree.expanded,l_tree.level,l_tree.treekey1,l_tree.treekey2)

      IF l_n1>0 THEN
         CALL q001_tree_fill_1(p_level,l_tree.id)       #鍏徃涔嬩笅绾у叕鍙?
      END IF
   
#      IF l_n2>0 THEN
#         CALL q001_tree_fill_2(p_level,g_tree[g_idx].id)       #鍏徃涔嬩笅绾ч儴闂?
#      END IF   
     
   #   LET g_idx=g_idx+1
   #END FOREACH

   #LET g_idx=g_idx-1
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM q001_tmp2 WHERE 1=1
   IF l_n>0 THEN
   	  CALL q001_tree_fill_2()
   END IF	   
   
   CALL q001_tree_fill_3()
   
   CALL q001_tree_show()
   
END FUNCTION
	
FUNCTION q001_tree_fill_1(p_level,p_id)
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
         img            LIKE  type_file.chr1000,
         pid            LIKE  hraa_file.hraa01,
         id             LIKE hrao_file.hrao01,  
         has_children   BOOLEAN,                
         expanded       BOOLEAN,                
         level          LIKE type_file.num5,    
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD 

      LET l_sql=" SELECT hraa01 FROM hraa_file WHERE hraa10='",p_id,"'"  
      PREPARE q001_pb6 FROM l_sql
      DECLARE q001_cs6 CURSOR FOR q001_pb6

       LET l_cnt2=1
                
       FOREACH q001_cs6 INTO l_hraa[l_cnt2].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt2 = l_cnt2 + 1 
       END FOREACH
       
       CALL l_hraa.deleteelement(l_cnt2)  #鍒櫎FOREACH鏈€寰屾柊澧炵殑绌虹櫧鍒?
       LET l_cnt2 = l_cnt2 - 1
       
       LET p_level = p_level + 1
       IF l_cnt2 > 0 THEN 
          FOR l_i = 1 TO l_cnt2
             LET l_tree.expanded = 0          #0:涓嶅睍, 1:灞?  #00000  
             SELECT hraa12 INTO  l_name  FROM hraa_file      
              WHERE hraa01 = l_hraa[l_i].hraa01               
             LET l_tree.name = l_name 
             LET l_tree.id = l_hraa[l_i].hraa01
             LET l_tree.pid = p_id
             LET l_tree.level = p_level
             LET l_tree.treekey1 = 'Y'
             LET l_tree.treekey2 = 'Y'
              
             SELECT COUNT(*) INTO l_n1 FROM hraa_file WHERE hraa10=l_hraa[l_i].hraa01
             SELECT COUNT(*) INTO l_n2 FROM hrao_file WHERE hrao00=l_hraa[l_i].hraa01
             IF l_n1 > 0 OR l_n2>0 THEN 
                LET l_tree.has_children = TRUE  
             ELSE 
                LET l_tree.has_children = FALSE    	
             END IF 
             	
             INSERT INTO q001_tmp2 VALUES(l_tree.*)	
             
             IF l_n1 > 0 THEN 
                CALL q001_tree_fill_1(p_level,l_hraa[l_i].hraa01) 
             END IF	
             	
          END FOR     
       END IF        
             
END FUNCTION	
	
FUNCTION q001_tree_fill_2()
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
          img            LIKE  type_file.chr1000,
         pid            LIKE  hraa_file.hraa01,
         id             LIKE  hrao_file.hrao01,  
         has_children   BOOLEAN,                
         expanded       BOOLEAN,                
         level          LIKE type_file.num5,    
         treekey1       LIKE type_file.chr1000,
         treekey2       LIKE type_file.chr1000
             END RECORD               
                             
       LET l_sql=" SELECT c,f FROM q001_tmp2 WHERE g='Y' ORDER BY f"
       PREPARE q001_pb7 FROM l_sql
       DECLARE q001_cs7 CURSOR FOR q001_pb7          
                
       FOREACH q001_cs7 INTO l_tmp.*            

          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          	
          LET l_sql=" SELECT hrao02,hrao01 FROM hrao_file ",
                    "  WHERE hraoacti = 'Y' AND hrao00='",l_tmp.id,"' AND hrao05='Y' "
          PREPARE q001_pb9 FROM l_sql
          DECLARE q001_cs9 CURSOR FOR q001_pb9
          
          FOREACH q001_cs9 INTO l_tree.name,l_tree.id
             LET l_tree.pid=l_tmp.id                        
             LET l_tree.expanded=0  #1111
             LET l_tree.level=l_tmp.level+1
             LET l_tree.treekey1='N'
             LET l_tree.treekey2='Y'
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao06=l_tree.id
             IF l_n>0 THEN
          	    LET l_tree.has_children = TRUE  
             ELSE 
                LET l_tree.has_children = FALSE    	
             END IF 
             
             INSERT INTO q001_tmp2 VALUES(l_tree.*)
             	
          END FOREACH
       END FOREACH
       
END FUNCTION
	
FUNCTION q001_tree_fill_3()
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
      
    	    	                
       LET l_sql=" SELECT c,f FROM q001_tmp2 WHERE g='N' "
       
       PREPARE q001_pb8 FROM l_sql
       DECLARE q001_cs8 CURSOR FOR q001_pb8
       
       LET l_cnt1 = 1
       
       FOREACH q001_cs8 INTO ls_tree[l_cnt1].*            
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#          CALL q001_tree_fill_4(ls_tree[l_cnt1].level,ls_tree[l_cnt1].id)	
          LET l_cnt1 = l_cnt1 + 1 
       END FOREACH
       
       CALL ls_tree.deleteelement(l_cnt1)  #鍒櫎FOREACH鏈€寰屾柊澧炵殑绌虹櫧鍒?
       LET l_cnt1 = l_cnt1 - 1  
       
       IF l_cnt1 > 0 THEN 
          FOR l_i = 1 TO l_cnt1 
             CALL q001_tree_fill_4(ls_tree[l_i].level,ls_tree[l_i].id) 
          END FOR     
       END IF         
       
    
END FUNCTION 
	
FUNCTION q001_tree_fill_4(p_level,p_id)
DEFINE p_level     LIKE     type_file.num5
DEFINE p_id        LIKE     hrao_file.hrao01
DEFINE l_cnt,l_n,l_i   LIKE     type_file.num5
DEFINE l_sql	     STRING
DEFINE l_hrao      DYNAMIC ARRAY OF RECORD
         hrao01    LIKE  hrao_file.hrao01
                   END RECORD
DEFINE l_tree   RECORD
         name           LIKE  type_file.chr1000,
          img            LIKE  type_file.chr1000,
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
	     
	     PREPARE q001_pb10 FROM l_sql
	     DECLARE q001_cs10 CURSOR FOR q001_pb10
	     
	     LET l_cnt=1
	     
	     FOREACH q001_cs10 INTO l_hrao[l_cnt].*
	        IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt=l_cnt+1
       END FOREACH
       
       CALL l_hrao.deleteelement(l_cnt)  #鍒櫎FOREACH鏈€寰屾柊澧炵殑绌虹櫧鍒?
       LET l_cnt = l_cnt - 1   	
	     
	     LET p_level = p_level + 1
       IF l_cnt > 0 THEN 
          FOR l_i = 1 TO l_cnt
             LET l_tree.expanded = 0          #0:涓嶅睍, 1:灞?    #1111
             SELECT hrao02 INTO  l_name  FROM hrao_file      
              WHERE hrao01 = l_hrao[l_i].hrao01               
             LET l_tree.name = l_name 
             LET l_tree.id = l_hrao[l_i].hrao01
             LET l_tree.pid = p_id
             LET l_tree.level = p_level
             LET l_tree.treekey1 = 'N'
             LET l_tree.treekey2 = 'N'
             SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao06=l_hrao[l_i].hrao01
             IF l_n > 0 THEN 
                LET l_tree.has_children = TRUE  
             ELSE 
                LET l_tree.has_children = FALSE    	
             END IF 
             	
             INSERT INTO q001_tmp2 VALUES(l_tree.*)	
             
             IF l_n > 0 THEN 
                CALL q001_tree_fill_4(p_level,l_hrao[l_i].hrao01) 
             END IF	
             	
          END FOR     
       END IF        

END FUNCTION	      
	
FUNCTION q001_tree_show()
DEFINE l_sql STRING
DEFINE l_n   LIKE   type_file.num5

       LET l_sql=" SELECT * FROM q001_tmp2 WHERE b IS NULL ORDER BY a"
       	
       PREPARE q001_pb11 FROM l_sql
       DECLARE q001_cs11 CURSOR FOR q001_pb11
       
       LET g_idx=1
       
       FOREACH q001_cs11 INTO g_tree[g_idx].*
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
          SELECT COUNT(*) INTO l_n FROM q001_tmp2 WHERE b=g_tree[g_idx].id
          IF l_n>0 THEN	
             CALL q001_tree_show_2(g_tree[g_idx].id,g_tree[g_idx].level,g_tree[g_idx].treekey1)
          END IF   	
          LET g_idx=g_idx+1
       END FOREACH   	 
       
       CALL g_tree.deleteelement(g_idx)  #鍒櫎FOREACH鏈€寰屾柊澧炵殑绌虹櫧鍒?
       LET g_idx=g_idx-1
       
END FUNCTION           	
	     	                     	
FUNCTION q001_tree_show_2(p_id,p_level,p_key1)
DEFINE l_sql   STRING
DEFINE p_id    LIKE  hrao_file.hrao02
DEFINE p_level LIKE  type_file.num5
DEFINE p_key1  LIKE  type_file.chr1
DEFINE l_tree   DYNAMIC ARRAY OF RECORD
         name           LIKE  type_file.chr1000,
         img            LIKE  type_file.chr1000,
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
      
       LET l_sql=" SELECT * FROM q001_tmp2 WHERE b='",p_id,"'",
                 "                           AND f='",p_level,"'",
                 "                           AND h='",p_key1,"'",
                 "  ORDER BY g desc,a "
       PREPARE q001_pb12 FROM l_sql
       DECLARE q001_cs12 CURSOR FOR q001_pb12
       
       LET l_cnt=1
       
       FOREACH q001_cs12 INTO l_tree[l_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF  
          
          LET l_cnt=l_cnt+1
       END FOREACH
       
       CALL l_tree.deleteelement(l_cnt)  #鍒櫎FOREACH鏈€寰屾柊澧炵殑绌虹櫧鍒?
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
          SELECT COUNT(*) INTO l_n FROM q001_tmp2 WHERE b=g_tree[g_idx].id
          IF l_n > 0 THEN 
             CALL q001_tree_show_2(g_tree[g_idx].id,g_tree[g_idx].level,g_tree[g_idx].treekey1) 
          END IF 
       END FOR     
   END IF 
   	
END FUNCTION   	        
       
                   	
FUNCTION q001_drill_gl(p_id)
   DEFINE l_sql,l_occ01 STRING
   DEFINE l_flg     LIKE type_file.chr1
   DEFINE l_cn1     LIKE type_file.num5
   DEFINE p_id      LIKE hraa_File.hraa01
          

   IF l_ac = 0 THEN RETURN END IF 
   #IF cl_null(p_id) THEN RETURN END IF  
   LET g_msg = "ghri001 " 
   CALL cl_cmdrun_wait(g_msg)
   CALL q001_tree_fill()
   
END FUNCTION	
	
FUNCTION q001_b_fill(p_hrao01,p_chr)
DEFINE p_hrao01 LIKE    type_file.chr100
DEFINE l_c      LIKE    type_file.chr100
DEFINE l_b      LIKE    type_file.chr100
DEFINE l_g      LIKE    type_file.chr1
DEFINE l_cnt,l_cnt1,l_n     LIKE type_file.num5
DEFINE p_chr    LIKE    type_file.chr1

  IF p_chr='N' THEN
     LET g_sql=" SELECT DISTINCT c,b,g FROM (",
               " SELECT c,b,g FROM q001_tmp2 START WITH c IN ('",p_hrao01,"')",
               "                         CONNECT BY PRIOR c=b AND h=g)",
               " WHERE g='N' ",
               "  ORDER BY c "
  ELSE
     LET g_sql=" SELECT hrao01,hrao06,'N' FROM hrao_file WHERE hrao00='",p_hrao01,"' AND hrao05='Y' "
  END IF
               
     PREPARE q001_test_pre FROM g_sql
     DECLARE q001_test CURSOR FOR q001_test_pre
     
     CALL g_hrao.clear()
     LET g_rec_b = 0
     LET l_cnt = 1
     
     CALL g_hrao1.clear()
     LET g_rec_b1 = 0
     LET l_cnt1 = 1
     
     FOREACH q001_test INTO l_c,l_b,l_g
        LET l_n=0
        SELECT COUNT(*) INTO l_n FROM hrao_file 
         WHERE hrao01=l_c
           AND hraoacti='Y'
        IF l_n>0 THEN   
           SELECT 'N',hrao01,hrao02,hrao03,hrao06,'',
                  hrao00,'',hrao10,'',hrao09,hrao13
             INTO g_hrao[l_cnt].*
             FROM hrao_file
            WHERE hrao01=l_c
           SELECT hrao02 INTO g_hrao[l_cnt].hrao06_desc FROM hrao_file WHERE hrao01=g_hrao[l_cnt].hrao06
           SELECT hraa12 INTO g_hrao[l_cnt].hraa12 FROM hraa_file WHERE hraa01=g_hrao[l_cnt].hrao00
           SELECT hrao02 INTO g_hrao[l_cnt].hrao10_desc FROM hrao_file WHERE hrao01=g_hrao[l_cnt].hrao10
           LET l_cnt=l_cnt+1 
        ELSE
        	 SELECT hrao01,hrao02,hrao03,hrao06,'',
                  hrao00,'',hrao10,'',hrao09,hrao13
             INTO g_hrao1[l_cnt1].*
             FROM hrao_file
            WHERE hrao01=l_c
            SELECT hrao02 INTO g_hrao1[l_cnt].hrao06_desc FROM hrao_file WHERE hrao01=g_hrao1[l_cnt].hrao06
            SELECT hraa12 INTO g_hrao1[l_cnt].hraa12 FROM hraa_file WHERE hraa01=g_hrao1[l_cnt].hrao00
            SELECT hrao02 INTO g_hrao1[l_cnt].hrao10_desc FROM hrao_file WHERE hrao01=g_hrao1[l_cnt].hrao10
            LET l_cnt1=l_cnt1+1
        END IF         
        
     END FOREACH
     
     CALL g_hrao.deleteElement(l_cnt)
     LET g_rec_b= l_cnt-1
     LET l_cnt = 0
     LET g_ac=1
     
     CALL g_hrao1.deleteElement(l_cnt1)
     LET g_rec_b1= l_cnt1-1
     LET l_cnt1 = 0
     LET g_ac=1    	                    
                  	
END FUNCTION 	
#add by zhuzw 20150402 start
FUNCTION q001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n,l_i            LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102               #可刪除否
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
DEFINE l_hrag       RECORD LIKE hrag_file.*
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    INPUT ARRAY g_hrao WITHOUT DEFAULTS FROM s_hrao.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=100000,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            CALL cl_show_fld_cont() 
                
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF

        ON ACTION sel_all
           FOR l_n = 1 TO g_rec_b
              LET g_hrao[l_n].chk = 'Y'
           END FOR
           
        ON ACTION sel_no
           FOR l_n = 1 TO g_rec_b
              LET g_hrao[l_n].chk = 'N'
           END FOR           
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     END INPUT
     IF INT_FLAG THEN 
        CALL cl_err('',9001,0)
        LET INT_FLAG = 0
        RETURN      	    
     END IF  
     DROP TABLE temp01
     SELECT hrao01,hrao02 FROM hrao_file 
      WHERE 1= 0 
      INTO TEMP temp01   
     DELETE FROM temp01 
     LET l_i = 1 
     FOR l_i = 1 TO g_rec_b
         IF  g_hrao[l_i].chk = 'Y' THEN 
             INSERT INTO temp01 VALUES (g_hrao[l_i].hrao01,g_hrao[l_i].hrao02)
         END IF 
     END FOR 
END FUNCTION
FUNCTION q001_hb()
DEFINE l_n,l_i,l_hrap04 LIKE type_file.num5
DEFINE tm  RECORD 
           jzdate LIKE type_file.dat,
           xj     LIKE type_file.chr1,
           hrao01 LIKE hrao_file.hrao01,
           hrao02 LIKE hrao_file.hrao02
           END RECORD 
DEFINE l_hrao00   LIKE hrao_file.hrao00 
DEFINE l_hrao01   LIKE hrao_file.hrao01 
DEFINE l_sql STRING
DEFINE l_sql_w STRING
DEFINE l_sql_z STRING
DEFINE l_hrap05   LIKE hrap_file.hrap05  
DEFINE l_hrap06   LIKE hrap_file.hrap06 
DEFINE l_hrap07   LIKE hrap_file.hrap07      
DEFINE l_hrap13,l_sum13   LIKE hrap_file.hrap13
DEFINE l_hrap14,l_sum14   LIKE hrap_file.hrap14
DEFINE l_hrap15,l_sum15   LIKE hrap_file.hrap15
DEFINE l_ao00     LIKE hrao_file.hrao00
DEFINE l_jiubm    LIKE hrao_file.hrao01
DEFINE l_ao01     LIKE hrao_file.hrao01
DEFINE l_hrap10   LIKE hrap_file.hrap10
DEFINE l_hrap11   LIKE hrap_file.hrap11
DEFINE l_hrap12   LIKE hrap_file.hrap12
    SELECT COUNT(*) INTO l_n FROM temp01
    SELECT DISTINCT hrao00 INTO l_hrao00 FROM hrao_file,temp01
     WHERE hrao_file.hrao01 = temp01.hrao01 
    IF l_n < 2 THEN 
       CALL cl_err('请先选择需要合并的部门','!',0)
       RETURN 
    END IF 
    OPEN WINDOW q001_1w  WITH FORM "ghr/42f/ghrq001_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       CALL cl_ui_init()
      LET tm.jzdate = g_today
      LET tm.xj = 'N'
      DISPLAY BY NAME tm.jzdate,tm.xj      
#      INPUT BY NAME tm.jzdate,tm.xj,tm.hrao01,tm.hrao02,tm.hrap05 WITHOUT DEFAULTS  
      INPUT BY NAME tm.jzdate,tm.xj,tm.hrao01,tm.hrao02 WITHOUT DEFAULTS

      AFTER FIELD xj
         IF tm.xj = 'Y' THEN 
            CALL cl_set_comp_entry("hrao02",TRUE)
         ELSE 
          	CALL cl_set_comp_entry("hrao02",FALSE)
         END IF 
      AFTER FIELD hrao01 
        IF NOT cl_null(tm.hrao01) THEN 
           IF tm.xj = 'Y' THEN 
              SELECT COUNT(*) INTO l_n FROM hrao_file 
               WHERE hrao01 = tm.hrao01
              IF l_n > 0 THEN
                 CALL cl_err('部门编码已存在，请检查','!',0) 
                 NEXT FIELD hrao01
              END IF  
           ELSE 
            	SELECT COUNT(*) INTO l_n FROM temp01 
               WHERE hrao01 = tm.hrao01
              IF l_n = 0 THEN
                 CALL cl_err('部门编码不存在，请检查','!',0) 
                 NEXT FIELD hrao01
              ELSE 
               	SELECT hrao02 INTO tm.hrao02 FROM temp01 
                 WHERE hrao01 = tm.hrao01 
                DISPLAY BY NAME tm.hrao02              	    
              END IF 
           END IF           
        END IF 
         
          
#20151028----nihuan---mod          
#      AFTER FIELD hrap05 
#        IF NOT cl_null(tm.hrap05) THEN 
#            	SELECT COUNT(*) INTO l_n FROM temp01,hrap_file 
#               WHERE hrap05 = tm.hrap05
#                 AND hrap01 = hrao01
#              IF l_n = 0 THEN
#                 CALL cl_err('部门职位不存在，请检查','!',0) 
#                 NEXT FIELD hracp05            	    
#              END IF           
#        END IF
#20151028----nihuan---mod  


      AFTER FIELD hrao02
         IF tm.xj = 'Y' AND cl_null(tm.hrao02) THEN  
            CALL cl_err('部门名称不可为空，请检查','!',0) 
            NEXT FIELD hrao02
         END IF 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrao01)
            IF tm.xj = 'N' THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01_1"
              LET g_qryparam.where = " hrao01 in (select hrao01 from temp01) " 
              LET g_qryparam.default1 = tm.hrao01
              CALL cl_create_qry() RETURNING tm.hrao01
              DISPLAY BY NAME tm.hrao01
              NEXT FIELD hrao01
            END IF 
            
            
#nihuan--------mod              
#           WHEN INFIELD(hrap05)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hrap01_1"
#              LET g_qryparam.where = " hrap01 in (select hrao01 from temp01) " 
#              LET g_qryparam.default1 = tm.hrap05
#              CALL cl_create_qry() RETURNING tm.hrap05
#              DISPLAY BY NAME tm.hrap05
#              NEXT FIELD hrap05
#nihuan--------mod


           OTHERWISE
              EXIT CASE
        END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
   IF INT_FLAG THEN 
        CALL cl_err('',9001,0)
        LET INT_FLAG = 0
        CLOSE WINDOW q001_1w
        RETURN 
   ELSE 
   	  IF NOT cl_confirm('ghr-294') THEN
         CLOSE WINDOW q001_1w
         RETURN    	      
   	  END IF 
   	  IF tm.xj = 'Y' THEN    	      #新建部门插入部门信息
   	     INSERT INTO hrao_file(hrao00,hrao01,hrao02,hrao04,hrao05,hrao07,hrao08,hrao09,hraoacti,hraouser,hraogrup,hraodate) VALUES (l_hrao00,tm.hrao01,tm.hrao02,g_today,'Y','N','Y',0,'Y',g_user,g_grup,g_today)
         LET l_sql = " select hrao01 from temp01 "
         PREPARE q001_hb FROM l_sql
         DECLARE q001_hbs CURSOR FOR q001_hb
         FOREACH q001_hbs INTO  l_hrao01
            UPDATE hrao_file SET hraoacti = 'N',hraoadate = tm.jzdate
             WHERE hrao01 = l_hrao01        
         END FOREACH 
         LET l_sql = " select distinct hrap05,hrap06,hrap07,hrap10,hrap11,hrap12 from temp01,hrap_file where hrap01 = hrao01  "
         PREPARE q001_hb1 FROM l_sql
         DECLARE q001_hbs1 CURSOR FOR q001_hb1
         LET l_hrap04 = 1
         
         FOREACH q001_hbs1 INTO  l_hrap05,l_hrap06,l_hrap07,l_hrap10,l_hrap11,l_hrap12
             SELECT hrao00 INTO l_ao00 FROM hrao_file WHERE hrao01=tm.hrao01
             INSERT INTO hrap_file(hrap01,hrap02,hrap03,hrap04,hrap05,hrap06,hrap07,hrap08,hrap10,hrap11,hrap12,hrapacti) VALUES (tm.hrao01,tm.hrao02,l_ao00,l_hrap04,l_hrap05,l_hrap06,l_hrap07,'N',l_hrap10,l_hrap11,l_hrap12,'Y')
             LET l_sql_w = " select hrao01 from temp01 "
             PREPARE q001_hb_s FROM l_sql_w
             DECLARE q001_hbs_s CURSOR FOR q001_hb_s
             FOREACH q001_hbs_s INTO  l_jiubm
                UPDATE hrap_file SET hrapacti = 'N' WHERE hrap01 = l_jiubm AND hrap05 = l_hrap05
             END FOREACH 
            LET l_hrap04 = l_hrap04 + 1 
         END FOREACH  
         LET l_sql_z = " select distinct hrao01 from temp01 "
         PREPARE q001_hb_z FROM l_sql_z
             DECLARE q001_hbs_z CURSOR FOR q001_hb_z
             LET l_sum13 = 0
             LET l_sum14 = 0
             LET l_sum15 = 0
             FOREACH q001_hbs_z INTO  l_ao01
                SELECT hrap13,hrap14,hrap15 INTO l_hrap13,l_hrap14,l_hrap15 FROM hrap_file WHERE hrap01 = l_ao01
                LET l_sum13 = l_sum13 + l_hrap13 
                LET l_sum14 = l_sum14 + l_hrap14 
                LET l_sum15 = l_sum15 + l_hrap15 
             END FOREACH 
             UPDATE hrap_file SET hrap13 = l_sum13,hrap14 = l_sum14,hrap15 = l_sum15 WHERE hrap01 = tm.hrao01
      ELSE 
         LET l_sql = " select hrao01 from temp01 where hrao01 != '",tm.hrao01,"'"
         PREPARE q001_hb2 FROM l_sql
         DECLARE q001_hbs2 CURSOR FOR q001_hb2
         FOREACH q001_hbs2 INTO  l_hrao01
            UPDATE hrao_file SET hraoacti = 'N',hraoadate = tm.jzdate
             WHERE hrao01 = l_hrao01
            UPDATE hrat_file SET hrao04 = tm.hrao01
             WHERE hrat04 = l_hrao01              
         END FOREACH 
         DROP TABLE temp02
         DELETE FROM temp02
         SELECT  DISTINCT  hrap05,hrap06,hrap07 FROM  temp01,hrap_file WHERE  hrap01 = hrao01 
         INTO TEMP temp02 
         LET l_sql = " select  hrap05,hrap06,hrap07 from temp02 "
         PREPARE q001_hb3 FROM l_sql
         DECLARE q001_hbs3 CURSOR FOR q001_hb3
         LET l_hrap04 = 1
         DELETE FROM hrap_file WHERE hrap01 = tm.hrao01
#20151028-----nihuan-----mod
         FOREACH q001_hbs3 INTO  l_hrap05,l_hrap06,l_hrap07    
             INSERT INTO hrap_file(hrap01,hrap02,hrap04,hrap05,hrap06,hrap07) VALUES (tm.hrao01,tm.hrao02,l_hrap04,l_hrap05,l_hrap06,l_hrap07)    
#            IF l_hrap05 = tm.hrap05 THEN
#               INSERT INTO hrap_file(hrap01,hrap02,hrap04,hrap05,hrap06,hrap07) VALUES (tm.hrao01,tm.hrao02,l_hrap04,l_hrap05,l_hrap06,'Y')
#            ELSE 
#            	 INSERT INTO hrap_file(hrap01,hrap02,hrap04,hrap05,hrap06,hrap07) VALUES (tm.hrao01,tm.hrao02,l_hrap04,l_hrap05,l_hrap06,'N')	    
#            END IF   
#20151028-----nihuan-----mod
            LET l_hrap04 = l_hrap04 + 1 
         END FOREACH       	            
   	  END IF
   	  CALL cl_err('合并成功','!',1)                 	    
   END IF   
   CLOSE WINDOW q001_1w
END FUNCTION 
FUNCTION q001_hz()
DEFINE l_n,l_i,l_hrap04 LIKE type_file.num5
DEFINE tm  RECORD 
           jzdate LIKE type_file.dat,
           hrao00 LIKE hrao_file.hrao00,
           hrao01 LIKE hrao_file.hrao01
           END RECORD 
DEFINE l_hrao00   LIKE hrao_file.hrao00 
DEFINE l_hrao01   LIKE hrao_file.hrao01 
DEFINE l_sql STRING
DEFINE l_hrap05   LIKE hrap_file.hrap05  
DEFINE l_hrap06   LIKE hrap_file.hrap06   
DEFINE l_hraa02   LIKE hraa_file.hraa02
DEFINE l_hrao02   LIKE hrao_file.hrao02 
DEFINE l_con      string    
    SELECT COUNT(*) INTO l_n FROM temp01
    SELECT DISTINCT hrao00 INTO l_hrao00 FROM hrao_file,temp01
     WHERE hrao_file.hrao01 = temp01.hrao01 
    
     
    LET l_i = 1 
    LET l_sql = " select hrao01 from temp01 "
      PREPARE q001_hz0 FROM l_sql
      DECLARE q001_hzs0 CURSOR FOR q001_hz0
      FOREACH q001_hzs0 INTO  l_hrao01
      IF l_i=1 THEN 
         LET l_con = "'",l_hrao01,"'"
         LET l_i =l_i+1
      ELSE    
         LET l_con=l_con,",","'",l_hrao01,"'" 
      END IF               
      END FOREACH   
    
    IF l_n < 1 THEN 
       CALL cl_err('请先选择需要划转的部门','!',0)
       RETURN 
    END IF 
    OPEN WINDOW q001_2w  WITH FORM "ghr/42f/ghrq001_2"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       CALL cl_ui_init()
      LET tm.jzdate = g_today
      DISPLAY BY NAME tm.jzdate     
      INPUT BY NAME tm.jzdate,tm.hrao00,tm.hrao01 WITHOUT DEFAULTS  

      AFTER FIELD hrao00
         IF NOT cl_null(tm.hrao00) THEN 
            SELECT COUNT(*) INTO l_n FROM hraa_file 
             WHERE hraa01 = tm.hrao00
            IF l_n = 0 THEN
               CALL cl_err('公司编码不存在，请检查','!',0) 
               NEXT FIELD hrao00
            ELSE 
             	SELECT hraa02 INTO l_hraa02 FROM hraa_file 
               WHERE hraa01 = tm.hrao00 
              DISPLAY l_hraa02 TO  hrao00_1              	    
            END IF            
         END IF  
      AFTER FIELD hrao01 
        IF NOT cl_null(tm.hrao01) THEN 
              SELECT COUNT(*) INTO l_n FROM hrao_file 
               WHERE hrao01 = tm.hrao01
                 AND hrao00 = tm.hrao00
              IF l_n = 0 THEN
                 CALL cl_err('部门编码不存在或不是该公司的下属部门，请检查','!',0) 
                 NEXT FIELD hrao01
              ELSE 
               	SELECT hrao02 INTO l_hrao02 FROM hrao_file 
                 WHERE hrao01 = tm.hrao01 
                DISPLAY l_hrao02  TO hrao01_1             	    
              END IF  
          
        END IF 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrao00)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
#              LET g_qryparam.where = " hraa01 !='",l_hrao00,"' "     #nihuan 20151028  zhu shi
              LET g_qryparam.default1 = tm.hrao00
              CALL cl_create_qry() RETURNING tm.hrao00
              DISPLAY BY NAME tm.hrao00
              NEXT FIELD hrao00   
           WHEN INFIELD(hrao01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01_1"
              LET g_qryparam.where = "  hrao00 ='",tm.hrao00,"' and hrao01 not in (",l_con,")"           #nihuan 20151028  
              LET g_qryparam.default1 = tm.hrao01
              CALL cl_create_qry() RETURNING tm.hrao01
              DISPLAY BY NAME tm.hrao01
              NEXT FIELD hrao01
           OTHERWISE
              EXIT CASE
        END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
   IF INT_FLAG THEN 
        CALL cl_err('',9001,0)
        LET INT_FLAG = 0
        CLOSE WINDOW q001_2w
        RETURN 
   ELSE 
   	  IF NOT cl_confirm('ghr-295') THEN
         CLOSE WINDOW q001_2w
         RETURN    	      
   	  END IF  
      LET l_sql = " select hrao01 from temp01 "
      PREPARE q001_hb4 FROM l_sql
      DECLARE q001_hbs4 CURSOR FOR q001_hb4
      FOREACH q001_hbs4 INTO  l_hrao01
         UPDATE hrao_file SET hrao00 = tm.hrao00 ,hraoadate = tm.jzdate,hrao06 = tm.hrao01,hraomodu = g_user
          WHERE hrao01 = l_hrao01
         UPDATE hrat_file SET hrao03 = tm.hrao00
          WHERE hrat04 = l_hrao01              
      END FOREACH 
   	  CALL cl_err('划转成功','!',1)                 	    
   END IF   
   CLOSE WINDOW q001_2w
END FUNCTION
#add end 
	
			
