# Prog. Version..: '5.25.01-10.05.01(00010)'     #
# Pattern name...: ghri079.4gl
# Descriptions...:
# Date & Author..: 13/6/20 By zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   g_hrdl    DYNAMIC ARRAY OF RECORD
           hrdl01       LIKE    hrdl_file.hrdl01,
           hrdl02       LIKE    hrdl_file.hrdl02,
           hrdl03       LIKE    hrdl_file.hrdl03,
           hrdl03_desc  LIKE    hrcu_file.hrcu02,
           hrdl04       LIKE    hrdl_file.hrdl04,
           hrdl05       LIKE    hrdl_file.hrdl05,
           hrdl06       LIKE    hrdl_file.hrdl06,
           hrdl07       LIKE    hrdl_file.hrdl07,
           hrdl08       LIKE    hrdl_file.hrdl08,
           hrdl09       LIKE    hrdl_file.hrdl09,
           hrdl10       LIKE    hrdl_file.hrdl10
                    END RECORD
DEFINE   g_hrdl_t  RECORD
           hrdl01       LIKE    hrdl_file.hrdl01,
           hrdl02       LIKE    hrdl_file.hrdl02,
           hrdl03       LIKE    hrdl_file.hrdl03,
           hrdl03_desc  LIKE    hrcu_file.hrcu02,
           hrdl04       LIKE    hrdl_file.hrdl04,
           hrdl05       LIKE    hrdl_file.hrdl05,
           hrdl06       LIKE    hrdl_file.hrdl06,
           hrdl07       LIKE    hrdl_file.hrdl07,
           hrdl08       LIKE    hrdl_file.hrdl08,
           hrdl09       LIKE    hrdl_file.hrdl09,
           hrdl10       LIKE    hrdl_file.hrdl10
                    END RECORD
DEFINE   g_hrdla    DYNAMIC ARRAY OF RECORD
           hrdla03       LIKE    hrdla_file.hrdla03,
           hrdla02       LIKE    hrdla_file.hrdla02,
           hrdk03        LIKE    hrdk_file.hrdk03,
           hrdk08        LIKE    hrdk_file.hrdk08,
           hrdk07        LIKE    hrdk_file.hrdk07,
           hrdk09        LIKE    hrdk_file.hrdk09
                    END RECORD
DEFINE   g_hrdla_t  RECORD
           hrdla03       LIKE    hrdla_file.hrdla03,
           hrdla02       LIKE    hrdla_file.hrdla02,
           hrdk03        LIKE    hrdk_file.hrdk03,
           hrdk08        LIKE    hrdk_file.hrdk08,
           hrdk07        LIKE    hrdk_file.hrdk07,
           hrdk09        LIKE    hrdk_file.hrdk09
                    END RECORD
DEFINE   g_wc,g_wc2,g_sql     STRING
DEFINE   g_rec_b         LIKE type_file.num5
DEFINE   g_rec_b1        LIKE type_file.num5
DEFINE   l_ac            LIKE type_file.num5
DEFINE   l_ac1           LIKE type_file.num5
DEFINE   l_ac2,l_ac3     LIKE type_file.num5
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                   #No.FUN-850016                                                                    
DEFINE   g_str           STRING                   #No.FUN-850016   
DEFINE   g_msg                 STRING
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10        #總筆數     
DEFINE   g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE   g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗    
DEFINE   g_flag                LIKE type_file.chr10                    
DEFINE   g_before_input_done   LIKE type_file.num5

MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i079_w WITH FORM "ghr/42f/ghri079"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   CALL cl_set_combo_items("hrdl04",NULL,NULL)
   CALL cl_set_combo_items("hrdl05",NULL,NULL)
   CALL cl_set_combo_items("hrdl06",NULL,NULL)
   
   #币种
   CALL i079_get_items('651') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdl04",l_name,l_items)
   #扣税方式
   CALL i079_get_items('601') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdl05",l_name,l_items)
   #扣零方式
   CALL i079_get_items('602') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdl06",l_name,l_items)
   
   
   LET g_wc=" 1=1"
   LET g_action_choice=""
    
   CALL i079_menu()
 
   CLOSE WINDOW i079_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION i079_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i079_get_items_pre FROM l_sql
       DECLARE i079_get_items CURSOR FOR i079_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i079_get_items INTO l_hrag06,l_hrag07
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION

FUNCTION i079_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
   	
      CALL i079_b_fill()
      
      CALL i079_bp("G")    #包含第一页签DISPLAY
  
      CASE g_action_choice
            	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            	 IF g_flag='Y' THEN
                  CALL i079_b()
               ELSE
               	  CALL i079_b1()
               END IF	     
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "query"
            IF cl_chk_act_auth() THEN
            	 CALL i079_q()
            END IF   	
            	                                                                                                                                                                                                                 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "up"
            CALL setDetail()
            LET l_ac1 = ARR_CURR()
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              IF g_flag ='Y' THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdl),'','')
              ELSE
              	 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdla),'','')
              END IF	    
            END IF
      END CASE
   END WHILE
 
END FUNCTION 
#mark by zhuzw 20141031 start	
#FUNCTION setDetail()
#DEFINE   l_sql    STRING
#DEFINE   l_cnt1   LIKE type_file.num5
#DEFINE   l_cnt2   LIKE type_file.num5
#DEFINE   hrdl01   LIKE hrdl_file.hrdl01
#DEFINE l_hrdk     DYNAMIC ARRAY OF RECORD
#         sel      LIKE type_file.chr1,
#         hrdk01   LIKE hrdk_file.hrdk01,
#         hrdk03   LIKE hrdk_file.hrdk03,
#         hrdk04   LIKE hrag_file.hrag07,
#         hrdk13   LIKE hrag_file.hrag07,
#         hrdkud01 LIKE hrdk_file.hrdkud01
#         END RECORD 
#DEFINE r_hrdla     DYNAMIC ARRAY OF RECORD
#         sel_1      LIKE type_file.chr1,
#         hrdla02    LIKE hrdk_file.hrdk01,
#         hrdk03_1   LIKE hrdk_file.hrdk03,
#         hrdk04_1   LIKE hrag_file.hrag07,
#         hrdk13_1   LIKE hrag_file.hrag07,
#         hrdkud01_1 LIKE hrdk_file.hrdkud01
#         END RECORD 
#         
#   OPEN WINDOW i079_w1  WITH FORM "ghr/42f/ghri079_1"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED)
#   CALL cl_ui_locale("ghri079_1")
#   #CALL cl_set_label_justify("i079_w1","right")
#   
#   LET hrdl01 = g_hrdl[ARR_CURR()].hrdl01 
#   LET l_sql = "SELECT 'N',hrdk01,hrdk03,a.hrag07,b.hrag07,hrdkud01 FROM hrdk_file
#                  LEFT JOIN hrag_file a ON a.hrag01='604' AND hrdk04=a.hrag06
#                  LEFT JOIN hrag_file b ON b.hrag01='650' AND hrdk13=b.hrag06
#                  WHERE NOT EXISTS(SELECT 1 FROM hrdla_file WHERE hrdla01='",hrdl01,"' AND hrdla02=hrdk01)"
#   PREPARE i079_01 FROM l_sql
#   DECLARE i079_01_cs CURSOR FOR i079_01
#   LET l_cnt1 = 1
#   FOREACH i079_01_cs INTO l_hrdk[l_cnt1].*
#     IF SQLCA.sqlcode THEN 
#        CALL cl_err('获取所有薪资项目失败','!',1)
#        EXIT FOREACH 
#     END IF 
#     LET l_cnt1 = l_cnt1 + 1
#   END FOREACH
#   CALL l_hrdk.deleteElement(l_cnt1)
#   LET l_cnt1 = l_cnt1 - 1
#   DISPLAY ARRAY l_hrdk TO s_hrdk.*
#                 ATTRIBUTE (COUNT=l_cnt1) 
#                 
#   LET l_sql = "SELECT 'N' hrdla02,hrdk03,a.hrag07,b.hrag07,hrdkud01 FROM hrdla_file 
#                  LEFT JOIN hrdk_file ON hrdk01=hrdla02
#                  LEFT JOIN hrag_file a ON a.hrag01='604' AND hrdk04=a.hrag06
#                  LEFT JOIN hrag_file b ON b.hrag01='650' AND hrdk13=b.hrag06
#                  WHERE hrdla01='",hrdl01,"' ORDER BY hrdla03"
#   PREPARE i079_02 FROM l_sql
#   DECLARE i079_02_cs CURSOR FOR i079_02
#   LET l_cnt2 = 1
#   FOREACH i079_02_cs INTO r_hrdla[l_cnt2].*
#     IF SQLCA.sqlcode THEN 
#        CALL cl_err('获取所有薪资项目失败','!',1)
#        EXIT FOREACH 
#     END IF 
#     LET l_cnt2 = l_cnt2 + 1
#   END FOREACH
#   CALL r_hrdla.deleteElement(l_cnt2)
#   LET l_cnt2 = l_cnt2 - 1
#   DISPLAY ARRAY r_hrdla TO s_hrdla.*
#                 ATTRIBUTE (COUNT=l_cnt2) 
#   
#   
#           
#   MENU ""
#      ON ACTION locale 
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
#         
#      ON ACTION HELP 
#         CALL cl_show_help()
#         
#      ON ACTION about 
#         CALL cl_about()
#         
#      ON ACTION cancel 
#         LET INT_FLAG=FALSE
#         EXIT MENU
#         
#      ON ACTION accept 
#         LET INT_FLAG=FALSE
#         EXIT MENU
#         
#      ON ACTION controlg 
#         CALL cl_cmdask()
#         
#      ON ACTION close 
#         LET INT_FLAG=FALSE
#         EXIT MENU
#         
#      ON ACTION EXIT
#         LET INT_FLAG=FALSE
#         EXIT MENU
#   END MENU 
#   CLOSE WINDOW i079_w1 
#END FUNCTION 
#mark by zhuzw 20141031 end 	

#add by zhuzw 20141031 start
FUNCTION setDetail()
DEFINE   l_sql    STRING
DEFINE   l_cnt1,l_n,l_s2,l_n1,l_n2   LIKE type_file.num5
DEFINE   l_cnt2   LIKE type_file.num5
DEFINE   l_hrdl01   LIKE hrdl_file.hrdl01
DEFINE l_hrdk     DYNAMIC ARRAY OF RECORD
         sel      LIKE type_file.chr1,
         hrdk01   LIKE hrdk_file.hrdk01,
         hrdk03   LIKE hrdk_file.hrdk03,
         hrdk04   LIKE hrag_file.hrag07,
         hrdk13   LIKE hrag_file.hrag07,
         hrdkud01 LIKE hrdk_file.hrdkud01
         END RECORD 
DEFINE l_hrdk_o     DYNAMIC ARRAY OF RECORD
         sel      LIKE type_file.chr1,
         hrdk01   LIKE hrdk_file.hrdk01,
         hrdk03   LIKE hrdk_file.hrdk03,
         hrdk04   LIKE hrag_file.hrag07,
         hrdk13   LIKE hrag_file.hrag07,
         hrdkud01 LIKE hrdk_file.hrdkud01
         END RECORD          
DEFINE r_hrdla     DYNAMIC ARRAY OF RECORD
         sel_1      LIKE type_file.chr1,
         hrdla02    LIKE hrdk_file.hrdk01,
         hrdk03_1   LIKE hrdk_file.hrdk03,
         hrdk04_1   LIKE hrag_file.hrag07,
         hrdk13_1   LIKE hrag_file.hrag07,
         hrdkud01_1 LIKE hrdk_file.hrdkud01
         END RECORD 
DEFINE r_hrdla_o     DYNAMIC ARRAY OF RECORD
         sel_1      LIKE type_file.chr1,
         hrdla02    LIKE hrdk_file.hrdk01,
         hrdk03_1   LIKE hrdk_file.hrdk03,
         hrdk04_1   LIKE hrag_file.hrag07,
         hrdk13_1   LIKE hrag_file.hrag07,
         hrdkud01_1 LIKE hrdk_file.hrdkud01
         END RECORD          
DEFINE l_i,l_i1,l_s,l_s1  LIKE type_file.num5  
 #add zhuzw 20150425    str 
DEFINE l_x,l_x1,l_x2    LIKE type_file.num5  
DEFINE l_hrdkud01_1     LIKE hrdk_file.hrdkud01
DEFINE l_f              LIKE type_file.chr1
DEFINE l_msg            LIKE type_file.chr100    
 #add zhuzw 20150425    end
DEFINE l_hrdla03    LIKE hrdla_file.hrdla03
   OPEN WINDOW i079_w1  WITH FORM "ghr/42f/ghri079_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("ghri079_1")
   #CALL cl_set_label_justify("i079_w1","right")
   CREATE TEMP TABLE  tmp_file(
   hrdla02 VARCHAR(20)
   )
   DELETE FROM tmp_file
   LET l_hrdl01 = g_hrdl[l_ac].hrdl01 
   LET l_sql = "SELECT 'N',hrdk01,hrdk03,a.hrag07,b.hrag07,hrdkud01 FROM hrdk_file
                  LEFT JOIN hrag_file a ON a.hrag01='604' AND hrdk04=a.hrag06
                  LEFT JOIN hrag_file b ON b.hrag01='650' AND hrdk13=b.hrag06
                  WHERE NOT EXISTS(SELECT 1 FROM hrdla_file WHERE hrdla01='",l_hrdl01,"' AND hrdla02=hrdk01)"
   PREPARE i079_01 FROM l_sql
   DECLARE i079_01_cs CURSOR FOR i079_01
   LET l_cnt1 = 1
   FOREACH i079_01_cs INTO l_hrdk[l_cnt1].*
     IF SQLCA.sqlcode THEN 
        CALL cl_err('获取所有薪资项目失败','!',1)
        EXIT FOREACH 
     END IF 
     LET l_cnt1 = l_cnt1 + 1
   END FOREACH
   CALL l_hrdk.deleteElement(l_cnt1)
   LET l_cnt1 = l_cnt1 - 1  
   DISPLAY 0 TO FORMONLY.cn1               
   LET l_sql = "SELECT 'N', hrdla02,hrdk03,a.hrag07,b.hrag07,hrdkud01 FROM hrdla_file 
                  LEFT JOIN hrdk_file ON hrdk01=hrdla02
                  LEFT JOIN hrag_file a ON a.hrag01='604' AND hrdk04=a.hrag06
                  LEFT JOIN hrag_file b ON b.hrag01='650' AND hrdk13=b.hrag06
                  WHERE hrdla01='",l_hrdl01,"' ORDER BY hrdla03"
   PREPARE i079_02 FROM l_sql
   DECLARE i079_02_cs CURSOR FOR i079_02
   LET l_cnt2 = 1
   FOREACH i079_02_cs INTO r_hrdla[l_cnt2].*
     IF SQLCA.sqlcode THEN 
        CALL cl_err('获取所有薪资项目失败','!',1)
        EXIT FOREACH 
     END IF 
     INSERT INTO tmp_file VALUES(r_hrdla[l_cnt2].hrdla02) 
     LET l_cnt2 = l_cnt2 + 1
   END FOREACH
   CALL r_hrdla.deleteElement(l_cnt2)
   LET l_cnt2 = l_cnt2 - 1
   DISPLAY 0 TO FORMONLY.cn2
  DIALOG ATTRIBUTES(UNBUFFERED)
             INPUT ARRAY l_hrdk  FROM s_hrdk.*
                 ATTRIBUTE (COUNT=l_cnt1,MAXCOUNT=l_cnt1, 
                        INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
                        
                 BEFORE INPUT
                    CALL cl_set_act_visible("accept,cancel", FALSE)
                    IF l_ac2 != 0 THEN 
                      CALL fgl_set_arr_curr(l_ac2)
                    END IF	
                    
                    	
                 BEFORE ROW
                     LET l_ac2 = ARR_CURR()
                     CALL fgl_set_arr_curr(l_ac2)
                 
                 ON CHANGE sel              
                     LET l_s1 = 0          
                     FOR l_i = 1 TO l_cnt1 
                       IF l_hrdk[l_i].sel = 'Y' THEN
                         LET l_s1 = l_s1 + 1
                         LET l_hrdk_o[l_s1].* = l_hrdk[l_i].*     #组选取数组存入r_hrat_o
                       END IF
                     END FOR
                     DISPLAY l_s1 TO FORMONLY.cn1
             END INPUT 
             INPUT ARRAY r_hrdla  FROM s_hrdla.*
                 ATTRIBUTE (COUNT=l_cnt2,MAXCOUNT=l_cnt2, 
                        INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
                        
                 BEFORE INPUT
                    CALL cl_set_act_visible("accept,cancel", FALSE)
                    IF l_ac3 != 0 THEN 
                      CALL fgl_set_arr_curr(l_ac3)
                    END IF	
                    
                    	
                 BEFORE ROW
                     LET l_ac3 = ARR_CURR()
                     CALL fgl_set_arr_curr(l_ac3)
                 
                 ON CHANGE sel_1              
                     LET l_s2 = 0          
                     FOR l_i = 1 TO l_cnt2 
                       IF r_hrdla[l_i].sel_1 = 'Y' THEN
                         LET l_s2 = l_s2 + 1
                         LET r_hrdla_o[l_s2].* = r_hrdla[l_i].*     #组选取数组存入r_hrat_o
                       END IF 
                     END FOR
                     DISPLAY l_s2 TO FORMONLY.cn2   	
             END INPUT
             ON ACTION EXIT
                IF cl_confirm('ghr-093') THEN   #提示未完成匹配,是否要退出 
                  LET INT_FLAG=TRUE   
                  EXIT DIALOG
                ELSE 
                	CONTINUE DIALOG       
                END IF 
                
             #数据上移-仅针对右侧匹配数据进行调整   
             ON ACTION moveup
                IF l_s2 = 0 THEN                #未选择数据则不处理
                  CALL cl_err('','ghr-095',0)   
                  CONTINUE DIALOG
                ELSE
                  LET l_n1 = r_hrdla.getLength()
                  FOR l_n = 1 TO l_n1 
                     IF r_hrdla[l_n].sel_1 = 'Y' AND l_n > 1 THEN 
                        LET r_hrdla_o[1].* = r_hrdla[l_n].*
                        LET r_hrdla[l_n].* = r_hrdla[l_n-1].*
                        LET r_hrdla[l_n-1].* = r_hrdla_o[1].*
                        CALL r_hrdla_o.clear() 
                     END IF 
               	  END FOR 
                  CALL ui.Interface.refresh()
               END IF 
                
             #数据下移-仅针对右侧匹配数据进行调整   
             ON ACTION movedown
                IF l_s2 = 0 THEN                #未选择数据则不处理
                  CALL cl_err('','ghr-095',0)   
                  CONTINUE DIALOG
                ELSE
                  LET l_n1 = r_hrdla.getLength() - 1
                  FOR l_n = l_n1 TO 1 STEP -1
                     IF r_hrdla[l_n].sel_1 = 'Y' THEN 
                        LET r_hrdla_o[1].* = r_hrdla[l_n].*
                        LET r_hrdla[l_n].* = r_hrdla[l_n+1].*
                        LET r_hrdla[l_n+1].* = r_hrdla_o[1].*
                        CALL r_hrdla_o.clear() 
                     END IF 
                	  END FOR 
               END IF 
               
             #数据右移
             ON ACTION moveright
                #处理前重新抓取选取数组
                LET l_s1 = 0
                CALL l_hrdk_o.clear()          
                FOR l_i = 1 TO l_cnt1 
                    IF l_hrdk[l_i].sel = 'Y' THEN
                      LET l_s1 = l_s1 + 1
                      LET l_hrdk_o[l_s1].* = l_hrdk[l_i].*     #组选取数组存入r_hrat_o
                    END IF
                END FOR                
                CALL l_hrdk.deleteElement(l_i)
                #开始处理
                IF l_s1 = 0 THEN 
                  CALL cl_err('','ghr-094',0)   #未选取需右移的资料
                  CONTINUE DIALOG
                ELSE
                	#进行数据右移处理
             #   	FOR l_i = 1 TO l_s1   
                    LET l_i = 1        
                	  LET l_n1 = l_cnt2 + l_s1
                	  LET l_n2 = l_cnt2 + 1
                	  FOR l_n = l_n2 TO l_n1 
                	      LET r_hrdla[l_n].sel_1 = 'N'
                	      LET r_hrdla[l_n].hrdla02 = l_hrdk_o[l_i].hrdk01
                	      LET r_hrdla[l_n].hrdk03_1 =l_hrdk_o[l_i].hrdk03
                	      LET r_hrdla[l_n].hrdk04_1 =l_hrdk_o[l_i].hrdk04
                	      LET r_hrdla[l_n].hrdk13_1 =l_hrdk_o[l_i].hrdk13
                	      LET r_hrdla[l_n].hrdkud01_1 =l_hrdk_o[l_i].hrdkud01
                	      LET l_i = l_i +1
                	  END FOR 
                	  LET l_cnt2 = l_cnt2+ l_s1
               # 	END FOR 
                	LET l_s2 = 0
                	#从原数组中删除已右移数据
                	LET l_s1 = 0
                	CALL l_hrdk_o.clear()
                	FOR l_i = 1 TO l_cnt1 
                	  IF l_hrdk[l_i].sel = 'N' THEN
                	     LET l_s1 = l_s1 + 1
                	     LET l_hrdk_o[l_s1].* = l_hrdk[l_i].*
                	  END IF 
                	END FOR
                	CALL l_hrdk.clear()
                	FOR l_i = 1 TO l_s1 
                	   LET l_hrdk[l_i].* = l_hrdk_o[l_i].*               	   
                	END FOR  
                	LET l_cnt1 = l_s1
                	LET l_s1 = 0
                	DISPLAY l_s1 TO cn1
                	DISPLAY l_s2 TO cn2
                	CALL ui.Interface.refresh() 
                	CONTINUE DIALOG
                END IF 
             #数据左移   
             ON ACTION moveleft
                #开始处理前重新选择数组
                LET l_s2 = 0    
                CALL r_hrdla_o.clear()      
                FOR l_i = 1 TO l_cnt2 
                    IF r_hrdla[l_i].sel_1 = 'Y' THEN
                      LET l_s2 = l_s2 + 1
                      LET r_hrdla_o[l_s2].* = r_hrdla[l_i].*     #组选取数组存入r_hrat_o
                    END IF 
                END FOR 
                CALL r_hrdla.deleteElement(l_i)   
                #开始处理
                IF l_s2 = 0 THEN                #未选择数据则不处理
                  CALL cl_err('','ghr-094',0)   
                  CONTINUE DIALOG
                ELSE
                	#进行数据左移处理
                #	FOR l_i = 1 TO l_s2           #
                    LET l_i = 1
                    LET l_n1 = l_cnt1 + l_s2
                    LET l_n2 = l_cnt1 + 1
                	  FOR l_n = l_n2 TO l_n1                 	 
                	      LET l_hrdk[l_n].sel = 'N'
                	      LET l_hrdk[l_n].hrdk01 = r_hrdla_o[l_i].hrdla02
                	      LET l_hrdk[l_n].hrdk03 = r_hrdla_o[l_i].hrdk03_1
                	      LET l_hrdk[l_n].hrdk04 = r_hrdla_o[l_i].hrdk04_1
                	      LET l_hrdk[l_n].hrdk13 = r_hrdla_o[l_i].hrdk13_1
                	      LET l_hrdk[l_n].hrdkud01 = r_hrdla_o[l_i].hrdkud01_1 
                	      LET l_i = l_i +1
                	  END FOR 
                	  LET l_cnt1 = l_cnt1 + l_s2
                #	END FOR 
                	CALL ui.Interface.refresh() 
                	LET l_s1 = 0
                	#从原数组中删除已右移数据
                	LET l_s2 = 0
                	CALL r_hrdla_o.clear()
                	FOR l_i = 1 TO l_cnt2 
                	  IF r_hrdla[l_i].sel_1 = 'N' THEN
                	     LET l_s2 = l_s2 + 1
                	     LET r_hrdla_o[l_s2].* = r_hrdla[l_i].*
                	  END IF 
                	END FOR
                	CALL r_hrdla.clear()
                	FOR l_i = 1 TO l_s2 
                	   LET r_hrdla[l_i].* = r_hrdla_o[l_i].*               	   
                	END FOR  
                	LET l_cnt2 = l_s2
                	LET l_s2 = 0
                	DISPLAY l_s1 TO cn1
                	DISPLAY l_s2 TO cn2
                	CALL ui.Interface.refresh() 
                	CONTINUE DIALOG
                END IF 
             #自动选取/取消左边资料
             ON ACTION ok2
               IF l_s1 = 0 THEN    
                  FOR l_i = 1 TO l_cnt1 
                      LET l_hrdk[l_i].sel = 'Y' 
                      LET l_s1 = l_s1 + 1
                      LET l_hrdk_o[l_s1].* = l_hrdk[l_i].*     #组选取数组存入r_hrat_o
                  END FOR     
               ELSE               
               	  LET l_s1 = 0 
               	  CALL l_hrdk_o.clear()
               	  FOR l_i = 1 TO l_cnt1 
                    LET l_hrdk[l_i].sel = 'N' 
                  END FOR                
               END IF 
               DISPLAY l_s1 TO cn1
             ON ACTION save
                IF NOT cl_confirm('ghr-096') THEN   #提示是否保存
                   CONTINUE DIALOG
                END IF 
                #add by zhuzw 20150425 start
                FOR l_i = 1 TO l_n1
                  LET l_f = 'A'
                  IF NOT cl_null(r_hrdla[l_i].hrdla02) AND NOT cl_null(r_hrdla[l_i].hrdkud01_1) THEN 
                     SELECT LENGTH(REGEXP_REPLACE(REPLACE(r_hrdla[l_i].hrdkud01_1, '|', '@'),  '[^@]+',  '')) COUNT INTO l_x1 FROM DUAL; 
                     FOR l_x = 1 TO l_x1
                         
                         IF l_x1 = l_x THEN
                            SELECT LENGTH(r_hrdla[l_i].hrdkud01_1) INTO l_x2 FROM dual 
                           SELECT  substr(r_hrdla[l_i].hrdkud01_1,
                                         instr(r_hrdla[l_i].hrdkud01_1, '|', 1, l_x) + 1,
                                         l_x2)
                             INTO l_hrdkud01_1            
                             FROM  dual                            
                         ELSE 
                           SELECT  substr(r_hrdla[l_i].hrdkud01_1,
                                         instr(r_hrdla[l_i].hrdkud01_1, '|', 1, l_x) + 1,
                                         instr(r_hrdla[l_i].hrdkud01_1, '|', 1, l_x+1) -
                                         instr(r_hrdla[l_i].hrdkud01_1, '|', 1, l_x) - 1)
                             INTO l_hrdkud01_1            
                             FROM  dual                                                      	   
                         END IF            
                         LET l_f = 'N'
                         FOR l_i1 = 1 TO l_i
                             IF r_hrdla[l_i1].hrdla02 = l_hrdkud01_1 THEN 
                                LET l_f = 'Y'
                                EXIT FOR 
                             END IF  
                         END FOR 
                         
                         IF l_f = 'N' THEN 
                            LET l_msg = l_hrdkud01_1,'不存在于',r_hrdla[l_i].hrdla02,'之前，请检查'
                            CALL cl_err(l_msg,'!',1)
                            EXIT FOR 
                         END IF                                        
                     END FOR 
                  END IF 
                  IF l_f = 'N' THEN
                     CONTINUE DIALOG
                  END IF 
                END FOR 
                #add by zhuzw 20150425 end               
                #add by yinbq 20141105 重写保存方法
                DELETE FROM hrdla_file WHERE hrdla01=l_hrdl01 
                LET l_n1 = r_hrdla.getLength()
                FOR l_i = 1 TO l_n1
                  IF NOT cl_null(r_hrdla[l_i].hrdla02) THEN 
                     INSERT INTO hrdla_file(hrdla01,hrdla02,hrdla03,hrdlaacti) VALUES (l_hrdl01,r_hrdla[l_i].hrdla02,l_i,'Y')
                  END IF 
                END FOR 
                #add by yinbq 20141105 重写保存方法
                #FOR l_i = 1 TO l_cnt1
                #    SELECT COUNT(*) INTO l_n FROM tmp_file 
                #     WHERE hrdla02 = l_hrdk[l_i].hrdk01
                #    IF l_n = 1 THEN 
                #       DELETE FROM hrdla_file 
                #       WHERE hrdla01 = l_hrdl01
                #         AND hrdla02 = l_hrdk[l_i].hrdk01
                #    END IF   
                #END FOR  
                #FOR l_i = 1 TO l_cnt2
                #    SELECT COUNT(*) INTO l_n FROM tmp_file 
                #     WHERE hrdla02 = r_hrdla[l_i].hrdla02
                #    IF l_n = 0 THEN 
                #       SELECT MAX(hrdla03)+1 INTO l_hrdla03 FROM hrdla_file 
                #        WHERE hrdla01 = l_hrdl01
                #       INSERT INTO hrdla_file(hrdla01,hrdla02,hrdla03,hrdlaacti) VALUES (l_hrdl01,r_hrdla[l_i].hrdla02,l_hrdla03,'Y')
                #    END IF   
                #END FOR 
                LET INT_FLAG = TRUE   #退出此窗口
                EXIT DIALOG 
                               
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG 
  END DIALOG
  
   CLOSE WINDOW i079_w1 
END FUNCTION 
#add by zhuzw 20141031 end 
FUNCTION i079_q()
   CALL i079_b_askkey()
END FUNCTION
	
FUNCTION i079_b_askkey()
    CLEAR FORM
    CALL g_hrdl.clear()
    CALL g_hrdla.clear()
 
    CONSTRUCT g_wc ON hrdl01,hrdl02,hrdl03,hrdl04,hrdl05,
                      hrdl06,hrdl07,hrdl08,hrdl09,hrdl10                       
         FROM s_hrdl[1].hrdl01,s_hrdl[1].hrdl02,s_hrdl[1].hrdl03,                                  
              s_hrdl[1].hrdl04,s_hrdl[1].hrdl05,s_hrdl[1].hrdl06,
              s_hrdl[1].hrdl07,s_hrdl[1].hrdl08,s_hrdl[1].hrdl09,
              s_hrdl[1].hrdl10
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrdl03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrcu01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdl[1].hrdl03
               NEXT FIELD hrdl03
            
            WHEN INFIELD(hrdl07)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrcv03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdl[1].hrdl07
               NEXT FIELD hrdl07   
         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
     ON ACTION down
         LET g_action_choice="down"

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdluser', 'hrdsgrup')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i079_b_fill()
 
END FUNCTION
	
FUNCTION i079_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
      
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT hrdl01,hrdl02,hrdl03,'',hrdl04,hrdl05,",
                      "        hrdl06,hrdl07,hrdl08,hrdl09,hrdl10",
                      "   FROM hrdl_file ",  
                      "  WHERE hrdl01= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i079_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrdl WITHOUT DEFAULTS FROM s_hrdl.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=TRUE,
                   APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrdl_t.* = g_hrdl[l_ac].*  #BACKUP
            OPEN i079_bcl USING g_hrdl_t.hrdl01
            IF STATUS THEN
               CALL cl_err("OPEN i079_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i079_bcl INTO g_hrdl[l_ac].hrdl01,g_hrdl[l_ac].hrdl02,
                                   g_hrdl[l_ac].hrdl03,g_hrdl[l_ac].hrdl03_desc,
                                   g_hrdl[l_ac].hrdl04,g_hrdl[l_ac].hrdl05,
                                   g_hrdl[l_ac].hrdl06,g_hrdl[l_ac].hrdl07,
                                   g_hrdl[l_ac].hrdl08,g_hrdl[l_ac].hrdl09,
                                   g_hrdl[l_ac].hrdl10
                                   
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrdl_t.hrdl01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               IF g_hrdl[l_ac].hrdl08='Y' THEN
         	        CALL cl_set_comp_entry("hrdl09",TRUE)
               ELSE
               	  LET g_hrdl[l_ac].hrdl09='N'
         	        CALL cl_set_comp_entry("hrdl09",FALSE)
               END IF
               #以下为修改时的控制,目前不确定
               #暂时以我自己的想到的控制一下
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrdla_file WHERE hrdla01=g_hrdl[l_ac].hrdl01
               IF l_n>0 THEN
               	  CALL cl_set_comp_entry("hrdl01",FALSE)
               ELSE
               	  CALL cl_set_comp_entry("hrdl01",TRUE)
               END IF	  	  
                 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         ELSE
         	  CALL cl_set_comp_entry("hrdl01",TRUE)  
         END IF
         CALL i079_b1_fill()	
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrdl[l_ac].* TO NULL      #900423
         LET g_hrdl[l_ac].hrdl08='N'
         LET g_hrdl[l_ac].hrdl09='N'
         LET g_hrdl_t.* = g_hrdl[l_ac].*         #新輸入資料
         IF g_hrdl[l_ac].hrdl08='Y' THEN
         	  CALL cl_set_comp_entry("hrdl09",TRUE)
         ELSE
         	  LET g_hrdl[l_ac].hrdl09='N'
         	  CALL cl_set_comp_entry("hrdl09",FALSE)
         END IF	  	  
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrdl01
         
      AFTER FIELD hrdl01
         IF NOT cl_null(g_hrdl[l_ac].hrdl01) THEN
         	  IF g_hrdl[l_ac].hrdl01 != g_hrdl_t.hrdl01 
         	     OR g_hrdl_t.hrdl01 IS NULL THEN
         	     LET l_n=0
         	     SELECT COUNT(*) INTO l_n FROM hrdl_file 
         	      WHERE hrdl01=g_hrdl[l_ac].hrdl01
         	     IF l_n>0 THEN
         	        CALL cl_err('薪资类别编号不可重复','!',0)
         	        NEXT FIELD hrdl01
         	     END IF
         	  END IF
         END IF 
         	
      AFTER FIELD hrdl03
         IF NOT cl_null(g_hrdl[l_ac].hrdl03) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrcu_file 
         	   WHERE hrcu01=g_hrdl[l_ac].hrdl03
         	  IF l_n=0 THEN
         	  	 CALL cl_err("不存在此个税参照表","!",0)
         	  	 NEXT FIELD hrdl03
         	  END IF
         	  SELECT hrcu02 INTO g_hrdl[l_ac].hrdl03_desc FROM hrcu_file
         	   WHERE hrcu01=g_hrdl[l_ac].hrdl03
         	  DISPLAY BY NAME g_hrdl[l_ac].hrdl03_desc
         END IF
         	
      AFTER FIELD hrdl07
         IF NOT cl_null(g_hrdl[l_ac].hrdl07) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrcv_file 
         	   WHERE hrcv03=g_hrdl[l_ac].hrdl07
         	  IF l_n=0 THEN
         	  	 CALL cl_err("不存在此个税起征值","!",0)
         	  	 NEXT FIELD hrdl07
         	  END IF
         END IF
         	
      AFTER FIELD hrdl08
         IF g_hrdl[l_ac].hrdl08='Y' THEN
         	  CALL cl_set_comp_entry("hrdl09",TRUE)
         ELSE
         	  LET g_hrdl[l_ac].hrdl09='N'
         	  CALL cl_set_comp_entry("hrdl09",FALSE)
         END IF  		  	   		   		      	          
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF      
         
         INSERT INTO hrdl_file(hrdl01,hrdl02,hrdl03,hrdl04,hrdl05,hrdl06,hrdl07,hrdl08,hrdl09,hrdl10,
                               hrdluser,hrdlgrup,hrdloriu,hrdlorig,hrdldate,hrdlacti)
                       VALUES(g_hrdl[l_ac].hrdl01,g_hrdl[l_ac].hrdl02,
                              g_hrdl[l_ac].hrdl03,g_hrdl[l_ac].hrdl04,   
                              g_hrdl[l_ac].hrdl05,g_hrdl[l_ac].hrdl06,
                              g_hrdl[l_ac].hrdl07,g_hrdl[l_ac].hrdl08,
                              g_hrdl[l_ac].hrdl09,g_hrdl[l_ac].hrdl10,     
                              g_user,g_grup,g_user,g_grup,g_today,'Y')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdl_file",g_hrdl[l_ac].hrdl01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cnt  
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrdl_t.hrdl01 IS NOT NULL THEN                                                                   
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrdl_file WHERE hrdl01 = g_hrdl[l_ac].hrdl01
            DELETE FROM hrdla_file WHERE hrdla01 = g_hrdl[l_ac].hrdl01                           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrdl_file",g_hrdl_t.hrdl02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1 
            DISPLAY g_rec_b TO FORMONLY.cnt 
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrdl[l_ac].* = g_hrdl_t.*
            CLOSE i079_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrdl[l_ac].hrdl03,-263,1)
            LET g_hrdl[l_ac].* = g_hrdl_t.*
         ELSE
            UPDATE hrdl_file SET  hrdl01=g_hrdl[l_ac].hrdl01,
                                  hrdl02=g_hrdl[l_ac].hrdl02,
                                  hrdl03=g_hrdl[l_ac].hrdl03,
                                  hrdl04=g_hrdl[l_ac].hrdl04,
                                  hrdl05=g_hrdl[l_ac].hrdl05,
                                  hrdl06=g_hrdl[l_ac].hrdl06,
                                  hrdl07=g_hrdl[l_ac].hrdl07,
                                  hrdl08=g_hrdl[l_ac].hrdl08,
                                  hrdl09=g_hrdl[l_ac].hrdl09,
                                  hrdl10=g_hrdl[l_ac].hrdl10,
                                  hrdlmodu=g_user,
                                  hrdldate=g_today  
             WHERE hrdl01 = g_hrdl_t.hrdl01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrdl_file",g_hrdl_t.hrdl01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrdl[l_ac].* = g_hrdl_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrdl[l_ac].* = g_hrdl_t.*
            END IF
            CLOSE i079_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i079_bcl
         COMMIT WORK
         
       ON ACTION controlp
          CASE 
              WHEN INFIELD(hrdl03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrcu01"
                  LET g_qryparam.default1 = g_hrdl[l_ac].hrdl03
                  CALL cl_create_qry() RETURNING g_hrdl[l_ac].hrdl03
                  DISPLAY BY NAME g_hrdl[l_ac].hrdl03
                  NEXT FIELD hrdl03
              WHEN INFIELD(hrdl07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrcv03"
                  LET g_qryparam.default1 = g_hrdl[l_ac].hrdl07
                  CALL cl_create_qry() RETURNING g_hrdl[l_ac].hrdl07
                  DISPLAY BY NAME g_hrdl[l_ac].hrdl07
                  NEXT FIELD hrdl07
          END CASE   
 
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
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i079_bcl
 
   COMMIT WORK
 
END FUNCTION	
	
FUNCTION i079_b1()
   DEFINE l_ac1_t         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   
   IF g_hrdl[l_ac].hrdl01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
        
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT hrdla03,hrdla02,'','','','' ",
                      "   FROM hrdla_file ",  
                      "  WHERE hrdla01= ? AND hrdla02= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i079_bcl1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
 
   INPUT ARRAY g_hrdla WITHOUT DEFAULTS FROM s_hrdla.*
         ATTRIBUTE(COUNT=g_rec_b1, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=TRUE,
                   APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac1      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b1 >= l_ac1 THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrdla_t.* = g_hrdla[l_ac1].*  #BACKUP
            OPEN i079_bcl1 USING g_hrdl[l_ac].hrdl01,g_hrdla_t.hrdla02
            IF STATUS THEN
               CALL cl_err("OPEN i079_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i079_bcl1 INTO g_hrdla[l_ac1].hrdla03,g_hrdla[l_ac1].hrdla02,
                                   g_hrdla[l_ac1].hrdk03,g_hrdla[l_ac1].hrdk08,
                                   g_hrdla[l_ac1].hrdk07,g_hrdla[l_ac1].hrdk09
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrdla_t.hrdla02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT hrdk03,hrdk08,hrdk07,hrdk09 
                 INTO g_hrdla[l_ac1].hrdk03,g_hrdla[l_ac1].hrdk08,
                      g_hrdla[l_ac1].hrdk07,g_hrdla[l_ac1].hrdk09
                 FROM hrdk_file 
                WHERE hrdk01=g_hrdla[l_ac1].hrdla02 	 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrdla[l_ac1].* TO NULL      #900423
         LET g_hrdla_t.* = g_hrdla[l_ac1].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrdla03
         
      BEFORE FIELD hrdla03
         IF cl_null(g_hrdla[l_ac1].hrdla03) 
         	  OR g_hrdla[l_ac1].hrdla03=0 THEN 
         	  SELECT MAX(hrdla03)+1 INTO g_hrdla[l_ac1].hrdla03
         	    FROM hrdla_file
         	   WHERE hrdla01=g_hrdl[l_ac].hrdl01
         	  IF cl_null(g_hrdla[l_ac1].hrdla03) THEN
         	  	 LET g_hrdla[l_ac1].hrdla03=1
         	  END IF
         END IF	  		    
         
      AFTER FIELD hrdla03
         IF NOT cl_null(g_hrdla[l_ac1].hrdla03) THEN
         	  IF g_hrdla[l_ac1].hrdla03 != g_hrdla_t.hrdla03 
         	     OR g_hrdla_t.hrdla03 IS NULL THEN
         	     LET l_n=0
         	     SELECT COUNT(*) INTO l_n FROM hrdla_file 
         	      WHERE hrdla03=g_hrdla[l_ac1].hrdla03
         	        AND hrdla01=g_hrdl[l_ac].hrdl01
         	     IF l_n>0 THEN
         	        CALL cl_err('序号不可重复','!',0)
         	        NEXT FIELD hrdla03
         	     END IF
         	  END IF
         END IF 
         
      AFTER FIELD hrdla02
         IF NOT cl_null(g_hrdla[l_ac1].hrdla02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrdk_file
         	   WHERE hrdk01=g_hrdla[l_ac1].hrdla02
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此计算项','!',0)
         	  	 NEXT FIELD hrdla02
         	  END IF	 
         	  	 
            IF g_hrdla[l_ac1].hrdla02 != g_hrdla_t.hrdla02 
         	     OR g_hrdla_t.hrdla02 IS NULL THEN
         	     LET l_n=0
         	     SELECT COUNT(*) INTO l_n FROM hrdla_file 
         	      WHERE hrdla02=g_hrdla[l_ac1].hrdla02
         	        AND hrdla01=g_hrdl[l_ac].hrdl01
         	     IF l_n>0 THEN
         	        CALL cl_err('计算项不可重复','!',0)
         	        NEXT FIELD hrdla02
         	     END IF
         	  END IF
         	  	
         	  SELECT hrdk03,hrdk08,hrdk07,hrdk09
         	    INTO g_hrdla[l_ac1].hrdk03,g_hrdla[l_ac1].hrdk08,
         	         g_hrdla[l_ac1].hrdk07,g_hrdla[l_ac1].hrdk09
         	    FROM hrdk_file
         	   WHERE hrdk01=g_hrdla[l_ac1].hrdla02 	
         END IF
                                          
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
              
         
         INSERT INTO hrdla_file(hrdla01,hrdla02,hrdla03,
                                hrdlauser,hrdlagrup,hrdlaoriu,hrdlaorig,hrdladate,hrdlaacti)
                       VALUES(g_hrdl[l_ac].hrdl01,
                              g_hrdla[l_ac1].hrdla02,   
                              g_hrdla[l_ac1].hrdla03,     
                              g_user,g_grup,g_user,g_grup,g_today,'Y')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdla_file",g_hrdla[l_ac1].hrdla03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1=g_rec_b1+1
            DISPLAY g_rec_b1 TO FORMONLY.cn2 
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrdla_t.hrdla02 IS NOT NULL THEN                                                               
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrdla_file WHERE hrdla01 = g_hrdl[l_ac].hrdl01
                                     AND hrdla02 = g_hrdla_t.hrdla02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrdla_file",g_hrdla_t.hrdla02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b1=g_rec_b1-1  
            COMMIT WORK
            DISPLAY g_rec_b1 TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrdla[l_ac1].* = g_hrdla_t.*
            CLOSE i079_bcl1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrdla[l_ac1].hrdla02,-263,1)
            LET g_hrdla[l_ac1].* = g_hrdla_t.*
         ELSE
            UPDATE hrdla_file SET hrdla02=g_hrdla[l_ac1].hrdla02,
                                  hrdla03=g_hrdla[l_ac1].hrdla03,
                                  hrdlamodu=g_user,
                                  hrdladate=g_today  
             WHERE hrdla01 = g_hrdl[l_ac].hrdl01
               AND hrdla02 = g_hrdla_t.hrdla02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrdla_file",g_hrdla_t.hrdla02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrdla[l_ac1].* = g_hrdla_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac1 = ARR_CURR()
         LET l_ac1_t = l_ac1
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrdla[l_ac1].* = g_hrdla_t.*
            END IF
            CLOSE i079_bcl1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i079_bcl1
         COMMIT WORK
      
      ON ACTION controlp
          CASE 
              WHEN INFIELD(hrdla02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrdk01"
                  LET g_qryparam.default1 = g_hrdla[l_ac1].hrdla02
                  CALL cl_create_qry() RETURNING g_hrdla[l_ac1].hrdla02
                  DISPLAY BY NAME g_hrdla[l_ac1].hrdla02
                  NEXT FIELD hrdla02
          END CASE   
         
 
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
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i079_bcl1
 
   COMMIT WORK
   
   CALL i079_get_procedure()
 
END FUNCTION	

FUNCTION i079_b_fill()  
DEFINE  l_arg      LIKE   type_file.chr100
DEFINE  l_res      LIKE   type_file.chr1000
DEFINE  l_sql      STRING
 
   LET g_sql = "SELECT hrdl01,hrdl02,hrdl03,'',hrdl04,hrdl05,",
               "       hrdl06,hrdl07,hrdl08,hrdl09,hrdl10 ",
               "  FROM hrdl_file ", 
               " WHERE ",g_wc CLIPPED,    
               " ORDER BY hrdl01"
   PREPARE i079_pb FROM g_sql
   DECLARE hrdl_curs CURSOR FOR i079_pb
 
   CALL g_hrdl.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrdl_curs INTO g_hrdl[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      	
      SELECT hrcu02 INTO g_hrdl[g_cnt].hrdl03_desc
        FROM hrcu_file
       WHERE hrcu01=g_hrdl[g_cnt].hrdl03	
                  
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrdl.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1  
   LET g_cnt = 0
   DISPLAY g_rec_b TO FORMONLY.cnt
   
   {
   #130621----test
   LET l_sql = "create or replace procedure salary(p_hrat01 in varchar2,res out varchar2) is  hrcjaLC001 varchar2(100);  res1 varchar2(100);  res2 varchar2(100);  res3 varchar2(100);  begin  SELECT val INTO hrcjaLC001 FROM tab WHERE column_value=p_hrat01 AND id='@hrcjaLC001';  IF hrcjaLC001 IS NULL THEN hrcjaLC001:=0; END IF; IF hrcjaLC001>0 THEN      res1:=0; ELSE      res1:=300; END IF;  IF hrcjaLC001>0 THEN    res2:=100; ELSE    res2:=200+res1; END IF;   IF res1=100 THEN     res3:=500; ELSE     res3:=0; END IF;  res:=res1||','||res2||','||res3;  end;         "
   PREPARE test2 from l_sql
   EXECUTE test2

   LET l_arg='tiptop'

   PREPARE id2 FROM "call salary(?,?)"
   EXECUTE id2 USING l_arg IN,l_res OUT 
   #130621---test 
   }

END FUNCTION	
	
FUNCTION i079_b1_fill()  
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrdla03,hrdla02,'','','',''",
               "  FROM hrdla_file ",                                         #FUN-B80058 add hrcyb071,hrcyb141
               " WHERE hrdla01 = '",g_hrdl[l_ac].hrdl01,"' ",     
               " ORDER BY hrdla03"
   PREPARE i079_pb1 FROM g_sql
   DECLARE hrdla_curs CURSOR FOR i079_pb1
 
   CALL g_hrdla.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrdla_curs INTO g_hrdla[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      	
      SELECT hrdk03,hrdk08,hrdk07,hrdk09 
        INTO g_hrdla[g_cnt].hrdk03,g_hrdla[g_cnt].hrdk08,
             g_hrdla[g_cnt].hrdk07,g_hrdla[g_cnt].hrdk09
        FROM hrdk_file
       WHERE hrdk01=g_hrdla[g_cnt].hrdla02       	
                  
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrdla.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b1 = g_cnt-1  
   LET g_cnt = 0
   DISPLAY g_rec_b1 TO FORMONLY.cn2
 
END FUNCTION	
	
FUNCTION i079_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
   DEFINE   l_n    LIKE type_file.num5
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
               
      DISPLAY ARRAY g_hrdl TO s_hrdl.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #add by zhangbo130916---begin
         IF l_ac>0 THEN
            CALL FGL_SET_ARR_CURR(l_ac)
         END IF 
         #add by zhangbo130916---end 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i079_b1_fill()  
                                        
      ON ACTION detail
         LET g_flag = "Y"
         LET g_action_choice="detail"
         EXIT DIALOG
         
     ON ACTION up
         LET g_action_choice="up"
         EXIT DIALOG  

      ON ACTION accept
         LET g_flag = "Y"
         LET g_action_choice="detail"
         EXIT DIALOG  
         
      ON ACTION exporttoexcel
         LET g_flag = "Y"
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG    
           
      END DISPLAY
      
       
      DISPLAY ARRAY g_hrdla TO s_hrdla.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
                                        
      ON ACTION detail
         LET g_flag = "N"
         LET g_action_choice="detail"
         EXIT DIALOG
         
      ON ACTION accept
         LET g_flag = "N"
         LET g_action_choice="detail"
         EXIT DIALOG   
      
      ON ACTION exporttoexcel
         LET g_flag = "N"
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
           
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
                                                                  
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	

#获取存储过程的完整语句	
FUNCTION i079_get_procedure()
DEFINE l_sql          STRING
DEFINE l_hrdla02      LIKE  hrdla_file.hrdla02
DEFINE l_hrdk14       LIKE  hrdk_file.hrdk14
DEFINE l_hrdk16       LIKE  hrdk_file.hrdk16
DEFINE l_hrdk17       LIKE  hrdk_file.hrdk17
DEFINE tok            base.StringTokenizer
DEFINE l_str          STRING
DEFINE l_value        LIKE type_file.chr100
DEFINE l_str_head     STRING
DEFINE l_str_init     STRING
DEFINE l_str_value    STRING   
DEFINE l_str_body     STRING
DEFINE l_str_res      STRING
DEFINE l_str_tail     STRING
DEFINE l_str_pro      STRING
DEFINE i,l_i          LIKE  type_file.num5
DEFINE j,k            LIKE  type_file.num5
DEFINE l_para         DYNAMIC ARRAY OF RECORD
         para         LIKE  hrdh_file.hrdh12
                      END RECORD
DEFINE l_res          DYNAMIC ARRAY OF RECORD
         res          LIKE  hrdk_file.hrdk16
                      END RECORD 
DEFINE l_formula      DYNAMIC ARRAY OF RECORD
         fml          LIKE  hrdk_file.hrdk17
                      END RECORD 
DEFINE l_flag         LIKE  type_file.chr1    
DEFINE l_length       LIKE  type_file.num10 
DEFINE l_hrdl21       LIKE  hrdl_file.hrdl21
DEFINE l_str_test     STRING    
DEFINE l_hrdl11       LIKE  hrdl_file.hrdl11
DEFINE l_hrdl12       LIKE  hrdl_file.hrdl12
DEFINE l_hrdl13       LIKE  hrdl_file.hrdl13
DEFINE l_hrdl14       LIKE  hrdl_file.hrdl14
DEFINE l_hrdl15       LIKE  hrdl_file.hrdl15
DEFINE l_hrdl16       LIKE  hrdl_file.hrdl16
DEFINE l_hrdl17       LIKE  hrdl_file.hrdl17
DEFINE l_hrdl18       LIKE  hrdl_file.hrdl18
DEFINE l_hrdl19       LIKE  hrdl_file.hrdl19
DEFINE l_hrdl20       LIKE  hrdl_file.hrdl20    
DEFINE l_arg          LIKE  type_file.chr1000
DEFINE li_res         LIKE  hrdl_file.hrdl11
DEFINE l_hrdl22       LIKE  hrdl_file.hrdl22     #add by zhangbo130730 
DEFINE l_ta_hrdl01,l_ta_hrdl02,l_ta_hrdl03,l_ta_hrdl04,l_ta_hrdl05    LIKE hrdl_file.ta_hrdl01    #add by zhuzw 20150120                  
       
       LET l_str_head="create or replace procedure salary",
                      "(p_hrat01 in varchar2,p_hrct11 in varchar2,res out varchar2) is \n"    #mod by zhangbo---hrct11薪资月
       #LET l_str_body="begin \n"
       LET l_str_body=""
       LET l_str_tail="end;"
       LET l_str_init=""
       LET l_str_value=''               
       LET l_str_res="res:="
                      
       LET l_sql=" SELECT hrdla02 FROM hrdla_file ",
                 "  WHERE hrdla01='",g_hrdl[l_ac].hrdl01,"'",
                 "  ORDER BY hrdla03 "
       PREPARE i079_pro_pre1 FROM l_sql
       DECLARE i079_pro_cs1 CURSOR FOR i079_pro_pre1
       
       LET i=0
       LET j=0
       LET k=0
       
       FOREACH i079_pro_cs1 INTO l_hrdla02
          
          LET l_str=''
          SELECT hrdk14 INTO l_hrdk14 FROM hrdk_file WHERE hrdk01=l_hrdla02
          LET l_str=l_hrdk14
          LET l_str=l_str.trim()
          LET tok = base.StringTokenizer.create(l_str,"|")
          IF NOT cl_null(l_str) THEN
             WHILE tok.hasMoreTokens()
                LET l_value=tok.nextToken()
                IF i=0 THEN
                	 LET i=i+1
                	 LET l_para[i].para=l_value
                ELSE
                	 LET l_flag='N'
                	 FOR l_i=1 TO i
                	    IF l_para[l_i].para=l_value THEN
                	    	 LET l_flag='Y'
                	    	 EXIT FOR
                	    END IF
                	 END FOR
                	 IF l_flag='N' THEN
                	 	  LET i=i+1
                	 	  LET l_para[i].para=l_value
                	 END IF
                END IF	 		     		 	 
             END WHILE
          END IF
          	
          SELECT hrdk16,hrdk17 INTO l_hrdk16,l_hrdk17 FROM hrdk_file 
           WHERE hrdk01=l_hrdla02
          IF NOT cl_null(l_hrdk16) THEN
          	 LET j=j+1
          	 LET l_res[j].res=l_hrdk16
          END IF
          IF NOT cl_null(l_hrdk17) THEN
          	 LET k=k+1
          	 LET l_formula[k].fml=l_hrdk17
          END IF         
           	
       END FOREACH
       
       #定义参数以及参数取值
       FOR l_i=1 TO i
           #add by zhangbo130730---begin
           #记录所有参数
           IF l_i=1 THEN
              LET l_hrdl22=l_para[l_i].para
           ELSE
              LET l_hrdl22=l_hrdl22 CLIPPED,"|",l_para[l_i].para
           END IF
           
           #add by zhangbo130730---end

           LET l_str_head=l_str_head,l_para[l_i].para," varchar2(100); \n"
           #mod by zhangbo130730---参数表hrdxc_file
           LET l_str_value=l_str_value,"SELECT hrdxc05 INTO ",l_para[l_i].para,
                           " FROM hrdxc_file WHERE hrdxc02=p_hrat01 AND hrdxc01=p_hrct11 AND hrdxc08='",l_para[l_i].para,"'; \n"
       END FOR 
       
       LET l_str_body=l_str_body,l_str_value

       #组合主逻辑块
       FOR l_i=1 TO k
          LET l_str_body=l_str_body,l_formula[l_i].fml," \n"
       END FOR
       
       #定义输出结果的参数
       FOR l_i=1 TO j
          IF l_i=1 THEN
          	 LET l_str_res=l_str_res,l_res[l_i].res
          ELSE
          	 LET l_str_res=l_str_res,"||','||",l_res[l_i].res
          END IF
          
          LET l_str_head=l_str_head,l_res[l_i].res," varchar2(100); \n"
          LET l_str_init=l_str_init,l_res[l_i].res," := 0;\n"
       
       END FOR
       
       LET l_str_pro=l_str_head,"begin \n",l_str_init,l_str_body,l_str_res,"; \n",l_str_tail   
       LET l_length=l_str_pro.getLength()
       LET l_hrdl11=''
       LET l_hrdl12=''
       LET l_hrdl13=''
       LET l_hrdl14=''
       LET l_hrdl15=''
       LET l_hrdl16=''
       LET l_hrdl17=''
       LET l_hrdl18=''
       LET l_hrdl19=''
       LET l_hrdl20=''
       #add by zhuzw 20150120 start
       LET l_ta_hrdl01=''
       LET l_ta_hrdl02=''
       LET l_ta_hrdl03=''
       LET l_ta_hrdl04=''
       LET l_ta_hrdl05=''
       #add by zhuzw 20150120 end 
       IF l_length<=4000 THEN
          LET l_hrdl11=l_str_pro.subString(1,l_length)
       END IF
       IF l_length>4000 AND l_length<=8000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,l_length)
       END IF
       IF l_length>8000 AND l_length<=12000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,l_length)
       END IF
       IF l_length>12000 AND l_length<=16000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,l_length)
       END IF
       IF l_length>16000 AND l_length<=20000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,l_length)
       END IF
       IF l_length>20000 AND l_length<=24000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,l_length)
       END IF
       IF l_length>24000 AND l_length<=28000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,l_length)
       END IF
       IF l_length>28000 AND l_length<=32000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,l_length)
       END IF
       IF l_length>32000 AND l_length<=36000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,32000)
          LET l_hrdl19=l_str_pro.subString(32001,l_length)
       END IF
       IF l_length>36000 AND l_length<=40000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,32000)
          LET l_hrdl19=l_str_pro.subString(32001,36000)
          LET l_hrdl20=l_str_pro.subString(36001,l_length)
       END IF
       #add by zhuzw 20150120 start
       IF l_length>40000 AND l_length<=44000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,32000)
          LET l_hrdl19=l_str_pro.subString(32001,36000)
          LET l_hrdl20=l_str_pro.subString(36001,40000)
          LET l_ta_hrdl01=l_str_pro.subString(40001,l_length)
          
       END IF
        #add by zhuzw 20150120 end 
       #add by zhuzw 20150425 start
       IF l_length>44000 AND l_length<=48000 THEN
          LET l_hrdl11=l_str_pro.subString(1,4000)
          LET l_hrdl12=l_str_pro.subString(4001,8000)
          LET l_hrdl13=l_str_pro.subString(8001,12000)
          LET l_hrdl14=l_str_pro.subString(12001,16000)
          LET l_hrdl15=l_str_pro.subString(16001,20000)
          LET l_hrdl16=l_str_pro.subString(20001,24000)
          LET l_hrdl17=l_str_pro.subString(24001,28000)
          LET l_hrdl18=l_str_pro.subString(28001,32000)
          LET l_hrdl19=l_str_pro.subString(32001,36000)
          LET l_hrdl20=l_str_pro.subString(36001,40000)
          LET l_ta_hrdl01=l_str_pro.subString(40001,44000)
          LET l_ta_hrdl02=l_str_pro.subString(44001,l_length)
          
       END IF
        #add by zhuzw 20150425 end 
       #LET l_str_test="1,",l_str_pro,"2,",l_str_pro,"3,",l_str_pro,
       #               "4,",l_str_pro,"5,",l_str_pro,"6,",l_str_pro,
       #               "7,",l_str_pro,"8,",l_str_pro,"9,",l_str_pro,
       #               "10,",l_str_pro
       #LET l_hrdl21=l_str_test
       LET l_hrdl11 = cl_replace_str(l_hrdl11,"  "," ")
       LET l_hrdl12 = cl_replace_str(l_hrdl12,"  "," ")
       LET l_hrdl13 = cl_replace_str(l_hrdl13,"  "," ")
       LET l_hrdl14 = cl_replace_str(l_hrdl14,"  "," ")
       LET l_hrdl15 = cl_replace_str(l_hrdl15,"  "," ")
       LET l_hrdl16 = cl_replace_str(l_hrdl16,"  "," ")
       LET l_hrdl17 = cl_replace_str(l_hrdl17,"  "," ")
       LET l_hrdl18 = cl_replace_str(l_hrdl18,"  "," ")
       LET l_hrdl19 = cl_replace_str(l_hrdl19,"  "," ")
       LET l_hrdl20 = cl_replace_str(l_hrdl20,"  "," ")
       LET l_ta_hrdl01 = cl_replace_str(l_ta_hrdl01,"  "," ")
       LET l_ta_hrdl02 = cl_replace_str(l_ta_hrdl02,"  "," ")
       LET l_hrdl11 = cl_replace_str(l_hrdl11,"  "," ")
       LET l_hrdl12 = cl_replace_str(l_hrdl12,"  "," ")
       LET l_hrdl13 = cl_replace_str(l_hrdl13,"  "," ")
       LET l_hrdl14 = cl_replace_str(l_hrdl14,"  "," ")
       LET l_hrdl15 = cl_replace_str(l_hrdl15,"  "," ")
       LET l_hrdl16 = cl_replace_str(l_hrdl16,"  "," ")
       LET l_hrdl17 = cl_replace_str(l_hrdl17,"  "," ")
       LET l_hrdl18 = cl_replace_str(l_hrdl18,"  "," ")
       LET l_hrdl19 = cl_replace_str(l_hrdl19,"  "," ")
       LET l_hrdl20 = cl_replace_str(l_hrdl20,"  "," ")
       LET l_ta_hrdl01 = cl_replace_str(l_ta_hrdl01,"  "," ")
       LET l_ta_hrdl02 = cl_replace_str(l_ta_hrdl02,"  "," ")
       UPDATE hrdl_file SET hrdl11=l_hrdl11,
                            hrdl12=l_hrdl12,
                            hrdl13=l_hrdl13,
                            hrdl14=l_hrdl14,
                            hrdl15=l_hrdl15,
                            hrdl16=l_hrdl16,
                            hrdl17=l_hrdl17,
                            hrdl18=l_hrdl18,
                            hrdl19=l_hrdl19,
                            hrdl20=l_hrdl20,
                            #add by zhuzw 20150120 start  
                            ta_hrdl01 = l_ta_hrdl01,
                            ta_hrdl02 = l_ta_hrdl02,
                            ta_hrdl03 = l_ta_hrdl03,
                            ta_hrdl04 = l_ta_hrdl04,
                            ta_hrdl05 = l_ta_hrdl05,
                            #add by zhuzw 20150120 end 
                            hrdl22=l_hrdl22        #add by zhangbo130730
                      WHERE hrdl01=g_hrdl[l_ac].hrdl01
       IF SQLCA.sqlcode THEN
          CALL cl_err("保存存储过程不成功!",SQLCA.sqlcode,1)
       END IF             	 
       
#130621test
{
    SELECT hrdl11,hrdl12,hrdl13,hrdl14,hrdl15,hrdl16,hrdl17,hrdl18,hrdl19,hrdl20
      INTO l_hrdl11,l_hrdl12,l_hrdl13,l_hrdl14,l_hrdl15,l_hrdl16,l_hrdl17,l_hrdl18,
           l_hrdl19,l_hrdl20
      FROM hrdl_file WHERE hrdl01='001'
    LET l_sql=l_hrdl11,l_hrdl12,l_hrdl13,l_hrdl14,l_hrdl15,l_hrdl16,l_hrdl17,l_hrdl18,l_hrdl19,l_hrdl20
    IF NOT cl_null(l_sql) THEN
       LET l_sql=cl_replace_str(l_sql,"@","")
       PREPARE test3 from l_sql
       EXECUTE test3

       LET l_arg='tiptop'

       PREPARE id3 FROM "call salary(?,?)"
       EXECUTE id3 USING l_arg IN,li_res OUT
    END IF
}
#130621test    
END FUNCTION
