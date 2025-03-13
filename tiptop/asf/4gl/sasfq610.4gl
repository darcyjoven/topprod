# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: asfq610.4gl
# Descriptions...: 工單備置明細查詢
# Date & Author..: 10/06/17 By liuxqa
# Modify.........: No.FUN-A60047 10/06/17 By liuxqa 
# Modify.........: No.FUN-B20009 11/04/01 By lixh1  增加sie012,ecm014,sie013三個欄位	
# Modify.........: No.FUN-AC0074 11/04/19 By shenyang 新增頁簽，訂單，雜發 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
# DEFINE g_argv1	LIKE ima_file.ima01     # 所要查詢的key  #FUN-AC0074 mark
  DEFINE g_argv1        LIKE type_file.chr1     #FUN-AC0074 
  DEFINE g_argv2	LIKE ima_file.ima01     #FUN-AC0074
  DEFINE g_wc,g_wc2	string             	# WHERE CONDICTION  
  DEFINE g_sql		string                  
  DEFINE g_rec_b	LIKE type_file.num5    
  DEFINE g_rec_b1	LIKE type_file.num5      #FUN-AC0074
  DEFINE g_rec_b2	LIKE type_file.num5      #FUN-AC0074
  DEFINE g_ima          RECORD
			  ima01	LIKE ima_file.ima01,
  			ima02	LIKE ima_file.ima02,
  			ima021	LIKE ima_file.ima021,
  			img10 	LIKE img_file.img10,
  			sig05   LIKE sig_file.sig05,
  			ima25   LIKE ima_file.ima25 
            		END RECORD

  DEFINE g_sie           DYNAMIC ARRAY OF RECORD
            		sie05   LIKE sie_file.sie05,
                        sie15   LIKE sie_file.sie05,   #FUN-AC0074 
            		sie08   LIKE sie_file.sie08,
              #FUN-B20009 -----------Begin------------ 
                        sie012  LIKE sie_file.sie012,
                        ecm014  LIKE ecm_file.ecm014,
                        sie013  LIKE sie_file.sie013,
              #FUN-B20009 -----------End-------------- 
            		sie07   LIKE sie_file.sie07,
            		sie02   LIKE sie_file.sie02,
            		sie03   LIKE sie_file.sie03, 
            		sie04   LIKE sie_file.sie04, 
            		sie09   LIKE sie_file.sie09,          		
            		sfa05   LIKE sfa_file.sfa05,
            		sie11   LIKE sie_file.sie11,
            		sie12   LIKE sie_file.sie12,
            		sie13   LIKE sie_file.sie13,
            		sie14   LIKE sie_file.sie14
            		END RECORD
 #FUN-AC0074--add--begin                   
  DEFINE g_sie1           DYNAMIC ARRAY OF RECORD
            		sie05_1   LIKE sie_file.sie05,
                        sie15_1   LIKE sie_file.sie15,
            		sie08_1   LIKE sie_file.sie08,
                        sie012_1  LIKE sie_file.sie012,
                        ecm014_1  LIKE ecm_file.ecm014,
                        sie013_1  LIKE sie_file.sie013,
            		sie07_1   LIKE sie_file.sie07,
            		sie02_1   LIKE sie_file.sie02,
            		sie03_1   LIKE sie_file.sie03, 
            		sie04_1   LIKE sie_file.sie04, 
            		sie09_1   LIKE sie_file.sie09, 	
            		sfa05_1   LIKE sfa_file.sfa05,
            		sie11_1   LIKE sie_file.sie11,
            		sie12_1   LIKE sie_file.sie12,
            		sie13_1   LIKE sie_file.sie13,
            		sie14_1   LIKE sie_file.sie14
            		END RECORD 
  DEFINE g_sie2           DYNAMIC ARRAY OF RECORD
                        a         LIKE sie_file.sie16,
            		sie05_2   LIKE sie_file.sie05,
                        sie15_2   LIKE sie_file.sie15,
            		sie08_2   LIKE sie_file.sie08,
                        sie012_2  LIKE sie_file.sie012,
                        ecm014_2  LIKE ecm_file.ecm014,
                        sie013_2  LIKE sie_file.sie013,
            		sie07_2   LIKE sie_file.sie07,
            		sie02_2   LIKE sie_file.sie02,
            		sie03_2   LIKE sie_file.sie03, 
            		sie04_2   LIKE sie_file.sie04, 
            		sie09_2   LIKE sie_file.sie09,          		
            		sfa05_2   LIKE sfa_file.sfa05,
            		sie11_2   LIKE sie_file.sie11,
            		sie12_2   LIKE sie_file.sie12,
            		sie13_2   LIKE sie_file.sie13,
            		sie14_2   LIKE sie_file.sie14
            		END RECORD  
DEFINE g_wc3,g_wc4,g_wc5	string                    
 #FUN-AC0074--add--end                    
  DEFINE p_row,p_col    LIKE type_file.num5                  #No.FUN-690026 SMALLINT

DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5    #No.FUN-690026 SMALLINT
#FUN-AC0074--mark(s) 
#MAIN
# 
#    OPTIONS
#        INPUT NO WRAP
#    DEFER INTERRUPT
# 
#    IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#    END IF
# 
#    WHENEVER ERROR CALL cl_err_msg_log
#  
#    IF (NOT cl_setup("ASF")) THEN
#      EXIT PROGRAM
#    END IF
# 
# 
#     LET g_argv1 = ARG_VAL(1)
#     LET g_argv2 = ARG_VAL(2)
#  #FUN-AC0074--add--begin   
#     CASE WHEN g_argv1='1' LET g_prog='asfq610'
#          WHEN g_argv1='2' LET g_prog='axmq611'    
#          WHEN g_argv1='3' LET g_prog='aimq611'  
#          WHEN g_argv1='4' LET g_prog='asfq612'  
#          OTHERWISE        LET g_argv2=ARG_VAL(2)
#                     
#     END CASE
#    IF g_prog = 'asfq610' THEN
#       LET g_argv1='1'
#    END IF 
#    IF g_prog = 'axmq611' THEN
#       LET g_argv1='2'
#    END IF 
#    IF g_prog = 'aimq611' THEN
#       LET g_argv1='3'
#    END IF 
#    IF g_prog = 'asfq612' THEN
#       LET g_argv1='4'
#    END IF     
#  #FUN-AC0074--add--end 
#     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
#     LET p_row = 4 LET p_col = 3
#  
#     OPEN WINDOW q610_w AT p_row,p_col
#         WITH FORM "asf/42f/asfq610"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
# 
#     CALL cl_ui_init()
#  #FUN-AC0074--add--begin
#     IF g_argv1='1' THEN
#        CALL cl_set_comp_visible("page2,page3",FALSE)
#     END IF
#     IF g_argv1='2' THEN
#        CALL cl_set_comp_visible("page1,page3",FALSE)
#     END IF 
#     IF g_argv1='3' THEN
#        CALL cl_set_comp_visible("page1,page2",FALSE)
#     END IF    
#  #FUN-AC0074--add--end
#     IF NOT cl_null(g_argv2) THEN CALL q610_q() END IF
#     CALL q610_menu()
#     CLOSE WINDOW q610_w
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
#END MAIN
#FUN-AC0074--mark(e)
#FUN-AC0074--add--begin
FUNCTION q610(p_argv1,p_argv2)
   DEFINE p_argv1       LIKE type_file.chr1         
   DEFINE p_argv2       LIKE ima_file.ima01  
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   
     IF p_argv1='1' THEN
        CALL cl_set_comp_visible("page2,page3",FALSE)
        CALL cl_set_comp_visible("sie15",FALSE)
     END IF
     IF p_argv1='2' THEN
        CALL cl_set_comp_visible("page1,page3",FALSE)
        CALL cl_set_comp_visible("sie012_1,ecm014_1,sie013_1",FALSE)
     END IF 
     IF p_argv1='3' THEN
        CALL cl_set_comp_visible("page1,page2",FALSE)
        CALL cl_set_comp_visible("sie012_2,ecm014_2,sie013_2",FALSE)
     END IF    
     
     IF NOT cl_null(p_argv2) THEN CALL q610_q() END IF
     CALL q610_menu()
END  FUNCTION
#FUN-AC0074--add--end
 
FUNCTION q610_cs()
   DEFINE   l_cnt LIKE type_file.num5    
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   IF g_argv2 != ' '                                 #FUN-AC0074
#     THEN LET g_wc = "ima01 = '",g_argv1,"'"
      THEN LET g_wc = "ima01 = '",g_argv2,"'"        #FUN-AC0074 --mark
#		   LET g_wc2=" 1=1 "                         #FUN-AC0074 --mark
#FUN-AC0074--add--begin   
        IF g_argv1='1'  THEN 
           LET g_wc2=" sie16 in ('1','2') "
        END IF
        IF g_argv1='2'  THEN    
           LET g_wc3=" sie16 = '3' "
        END IF    
        IF g_argv1='3'  THEN           
           LET g_wc4=" sie16 in ('4','5') " 
        END IF    
        IF g_argv1='4'  THEN              
           LET g_wc5=" 1=1 "
        END IF 
#FUN-AC0074--add--end           
   ELSE 
   	CLEAR FORM 
#   CALL g_sie.clear()        #FUN-AC0074
#FUN-AC0074--add--begin
    IF g_argv1='1'  THEN
       CALL g_sie.clear()
    END IF
    IF g_argv1='2'  THEN
       CALL g_sie1.clear()
    END IF
    IF g_argv1='3'  THEN
       CALL g_sie2.clear()
    END IF
    IF g_argv1='4'  THEN
       CALL g_sie.clear()
       CALL g_sie1.clear()
       CALL g_sie2.clear()
    END IF
#FUN-AC0074--add--end
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
    INITIALIZE g_ima.* TO NULL   

    CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima25 # 螢幕上取單頭條件

      BEFORE CONSTRUCT
        CALL cl_qbe_init()

      ON IDLE g_idle_seconds
        CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
                
      ON ACTION controlp
         CASE
           WHEN INFIELD(ima01)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = 'c'
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima01
           NEXT FIELD ima01
          END CASE
 

       ON ACTION qbe_select
         	CALL cl_qbe_select()
       ON ACTION qbe_save
		      CALL cl_qbe_save()
     END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
       
#    CONSTRUCT g_wc2 ON sie05,sie08,sie07,sie02,sie03,sie04,sie09,sie11,sie12,sie13,sie14                 #FUN-B20009
#    CONSTRUCT g_wc2 ON sie05,sie08,sie012,sie013,sie07,sie02,sie03,sie04,sie09,sie11,sie12,sie13,sie14   #FUN-B20009 #FUN-AC0074
  IF g_argv1='1'  THEN 
     CONSTRUCT g_wc2 ON sie05,sie15,sie08,sie07,sie02,sie03,sie04,sie09,sie11,sie12,sie13,sie14    #FUN-AC0074
#        FROM s_sie[1].sie05,s_sie[1].sie08,s_sie[1].sie07,      #FUN-B20009
#        FROM s_sie[1].sie05,s_sie[1].sie08,s_sie[1].sie012,     #FUN-B20009    #FUN-AC0074 
#             s_sie[1].sie013,s_sie[1].sie07,                    #FUN-B20009    #FUN-AC0074
         FROM s_sie[1].sie05,s_sie[1].sie15,s_sie[1].sie08,s_sie[1].sie07,      #FUN-AC0074 
              s_sie[1].sie02,s_sie[1].sie03,s_sie[1].sie04,
              s_sie[1].sie09,s_sie[1].sie11,s_sie[1].sie12,
              s_sie[1].sie13,s_sie[1].sie14
       
       BEFORE CONSTRUCT
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn) 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT    
    END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF         
  END IF
 #FUN-AC0074--add--begin  
  IF g_argv1='2'  THEN  
     CONSTRUCT g_wc3 ON sie05_1,sie15_1,sie08_1,sie07_1,
                       sie02_1,sie03_1,sie04_1,sie09_1,sie11_1,sie12_1,sie13_1,sie14_1   
         FROM s_sie1[1].sie05_1,s_sie1[1].sie15_1,s_sie1[1].sie08_1,    
              s_sie1[1].sie07_1,                   
              s_sie1[1].sie02_1,s_sie1[1].sie03_1,s_sie1[1].sie04_1,
              s_sie1[1].sie09_1,s_sie1[1].sie11_1,s_sie1[1].sie12_1,
              s_sie1[1].sie13_1,s_sie1[1].sie14_1
       
       BEFORE CONSTRUCT
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT 
     END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF     
  END IF 
  IF g_argv1='3'  THEN    
    CONSTRUCT g_wc4 ON sie05_2,sie15_2,sie08_2,sie07_2,sie02_2,sie03_2,sie04_2,sie09_2,
                       sie11_2,sie12_2,sie13_2,sie14_2   
         FROM s_sie2[1].sie05_2,s_sie2[1].sie15_2,s_sie2[1].sie08_2,    
              s_sie2[1].sie07_2,                   
              s_sie2[1].sie02_2,s_sie2[1].sie03_2,s_sie2[1].sie04_2,
              s_sie2[1].sie09_2,s_sie2[1].sie11_2,s_sie2[1].sie12_2,
              s_sie2[1].sie13_2,s_sie2[1].sie14_2
       
       BEFORE CONSTRUCT
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT  
    END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF 
   END IF
   IF g_argv1='4' THEN 
      DIALOG ATTRIBUTES(UNBUFFERED) 
      CONSTRUCT g_wc2 ON sie05,sie15,sie08,sie07,sie02,sie03,sie04,sie09,sie11,sie12,sie13,sie14   
         FROM s_sie[1].sie05,s_sie[1].sie15,s_sie[1].sie08,s_sie[1].sie07,     
              s_sie[1].sie02,s_sie[1].sie03,s_sie[1].sie04,
              s_sie[1].sie09,s_sie[1].sie11,s_sie[1].sie12,
              s_sie[1].sie13,s_sie[1].sie14
       
       BEFORE CONSTRUCT
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      CONSTRUCT g_wc3 ON sie05_1,sie15_1,sie08_1,sie07_1,
                       sie02_1,sie03_1,sie04_1,sie09_1,sie11_1,sie12_1,sie13_1,sie14_1   
         FROM s_sie1[1].sie05_1,s_sie1[1].sie15_1,s_sie1[1].sie08_1,    
              s_sie1[1].sie07_1,                   
              s_sie1[1].sie02_1,s_sie1[1].sie03_1,s_sie1[1].sie04_1,
              s_sie1[1].sie09_1,s_sie1[1].sie11_1,s_sie1[1].sie12_1,
              s_sie1[1].sie13_1,s_sie1[1].sie14_1
       
       BEFORE CONSTRUCT
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn) 
       END CONSTRUCT 
       CONSTRUCT g_wc4 ON sie05_2,sie15_2,sie08_2,sie07_2,sie02_2,sie03_2,sie04_2,sie09_2,
                       sie11_2,sie12_2,sie13_2,sie14_2   
         FROM s_sie2[1].sie05_2,s_sie2[1].sie15_2,s_sie2[1].sie08_2,    
              s_sie2[1].sie07_2,                   
              s_sie2[1].sie02_2,s_sie2[1].sie03_2,s_sie2[1].sie04_2,
              s_sie2[1].sie09_2,s_sie2[1].sie11_2,s_sie2[1].sie12_2,
              s_sie2[1].sie13_2,s_sie2[1].sie14_2
       
       BEFORE CONSTRUCT
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
       ON ACTION accept
          ACCEPT DIALOG

       ON ACTION cancel
          LET INT_FLAG = TRUE
          EXIT DIALOG
       END  DIALOG 
       IF INT_FLAG THEN RETURN END IF    
     END IF        
  END IF
 #FUN-AC0074--add--end    
  MESSAGE ' WAIT '
#  CASE WHEN g_wc2 = " 1=1"   
#        LET g_sql=" SELECT ima01 FROM ima_file ",
#               " WHERE ",g_wc CLIPPED
#       WHEN g_wc2 <> " 1=1"
     IF cl_null(g_argv2) THEN
        LET g_sql= "SELECT UNIQUE ima01 ",                             
               "  FROM ima_file, sie_file",
               " WHERE ima01 = sie01 AND sie11 > 0 "
     ELSE
         LET g_sql= "SELECT UNIQUE ima01 ",
               "  FROM ima_file, sie_file",
               " WHERE ima01 = sie01 AND  sie11>0 "
     END IF
#              "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED   #FUN-AC0074
    #FUN-AC0074--add--begin          
    IF NOT cl_null(g_wc3) THEN CALL cl_replace_str(g_wc3,'_1','') RETURNING g_wc3 END IF
    IF NOT cl_null(g_wc4) THEN CALL cl_replace_str(g_wc4,'_2','') RETURNING g_wc4 END IF
    IF cl_null(g_argv2) THEN
        IF  g_argv1='1'   THEN
            LET g_sql =g_sql, "  AND sie16 in ('1','2') AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
        END IF
        IF  g_argv1='2'   THEN
            LET g_sql =g_sql, "  AND sie16='3' AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
        END IF
        IF  g_argv1='3'   THEN
            LET g_sql =g_sql, "  AND sie16 in ('4','5') AND ", g_wc CLIPPED, " AND ",g_wc4 CLIPPED
        END IF
        IF  g_argv1='4'   THEN
            LET g_sql =g_sql, "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                         "  AND ", g_wc3 CLIPPED, "  AND ", g_wc4 CLIPPED
        END IF
    ELSE               
        IF  g_argv1='1'   THEN   
            LET g_sql =g_sql, "  AND sie16 in ('1','2') AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
        END IF  
        IF  g_argv1='2'   THEN   
            LET g_sql =g_sql, "  AND sie16='3' AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
        END IF 
        IF  g_argv1='3'   THEN   
            LET g_sql =g_sql, "  AND sie16 in ('4','5') AND ", g_wc CLIPPED, " AND ",g_wc4 CLIPPED
        END IF 
        IF  g_argv1='4'   THEN   
            LET g_sql =g_sql, "  AND ", g_wc CLIPPED, " AND ",g_wc5 CLIPPED
        END IF
     END IF
    #FUN-AC0074--add--end 
#  END CASE      

   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q610_prepare FROM g_sql
   DECLARE q610_cs SCROLL CURSOR FOR q610_prepare

#  CASE WHEN g_wc2 = " 1=1"   
#        LET g_sql=" SELECT COUNT(*) FROM ima_file ",
#               " WHERE ",g_wc CLIPPED
#       WHEN g_wc2 <> " 1=1"
      IF  cl_null(g_argv2) THEN
        LET g_sql= "SELECT COUNT(DISTINCT ima01) ",                             
               "  FROM ima_file, sie_file",
               " WHERE ima01 = sie01 AND sie11 > 0 "
      ELSE
         LET g_sql= "SELECT COUNT(DISTINCT ima01) ",
               "  FROM ima_file, sie_file",
               " WHERE ima01 = sie01 AND sie11 > 0 "
      END IF
#               "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED   #FUN-AC0074
    #FUN-AC0074--add--begin           
    IF cl_null(g_argv2) THEN
        IF  g_argv1='1'   THEN   
            LET g_sql =g_sql, "  AND sie16 in ('1','2') AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
        END IF  
        IF  g_argv1='2'   THEN   
            LET g_sql =g_sql, "  AND sie16='3' AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
        END IF 
        IF  g_argv1='3'   THEN   
            LET g_sql =g_sql, "  AND sie16 in ('4','5') AND ", g_wc CLIPPED, " AND ",g_wc4 CLIPPED
        END IF 
        IF  g_argv1='4'   THEN   
            LET g_sql =g_sql, "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                         "  AND ", g_wc3 CLIPPED, "  AND ", g_wc4 CLIPPED 
        END IF
    ELSE
        IF  g_argv1='1'   THEN
            LET g_sql =g_sql, "  AND sie16 in ('1','2') AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
        END IF
        IF  g_argv1='2'   THEN
            LET g_sql =g_sql, "  AND sie16='3' AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
        END IF
        IF  g_argv1='3'   THEN
            LET g_sql =g_sql, "  AND sie16 in ('4','5') AND ", g_wc CLIPPED, " AND ",g_wc4 CLIPPED
        END IF
        IF  g_argv1='4'   THEN
            LET g_sql =g_sql, "  AND ", g_wc CLIPPED, " AND ",g_wc5 CLIPPED
        END IF
    END IF
    #FUN-AC0074--add--end 
#  END CASE 
   PREPARE q610_precount  FROM g_sql
   DECLARE q610_count   CURSOR FOR q610_precount
END FUNCTION
 
FUNCTION q610_menu()
 
   WHILE TRUE
#     CALL q610_bp("G")   #FUN-AC0074
#FUN-AC0074--add--begin
   IF g_argv1='1'  THEN      
      CALL q610_bp("G")
   END IF
   IF g_argv1='2'  THEN      
      CALL q610_bp1("G")
   END IF
   IF g_argv1='3'  THEN      
      CALL q610_bp2("G")
   END IF
   IF g_argv1='4'  THEN      
      CALL q610_bp3("G")
   END IF
#FUN-AC0074--add--end   
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q610_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sie),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q610_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q610_count
       FETCH q610_count INTO g_row_count
#FUN-AC0074--add--begin
       IF g_argv1='1' THEN
          DISPLAY g_row_count TO FORMONLY.cnt
       END IF
       IF g_argv1='2' THEN
          DISPLAY g_row_count TO FORMONLY.cnt2
       END IF
       IF g_argv1='3' THEN
          DISPLAY g_row_count TO FORMONLY.cnt4
       END IF
       IF g_argv1='4' THEN
          DISPLAY g_row_count TO FORMONLY.cnt
          DISPLAY g_row_count TO FORMONLY.cnt2
          DISPLAY g_row_count TO FORMONLY.cnt4
       END IF
#FUN-AC0074--add--end
    #  DISPLAY g_row_count TO FORMONLY.cnt
       CALL q610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q610_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q610_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q610_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q610_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        END PROMPT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           EXIT CASE
        END IF
      END IF
      FETCH ABSOLUTE g_jump q610_cs INTO g_ima.ima01
      LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
	SELECT ima01,ima02,ima021,ima25 INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25 FROM ima_file
	 WHERE ima01 = g_ima.ima01
	SELECT SUM(img10) INTO g_ima.img10 FROM img_file WHERE img01=g_ima.ima01
	SELECT SUM(sig05) INTO g_ima.sig05 FROM sig_file WHERE sig01=g_ima.ima01
	
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL q610_show()
END FUNCTION
 
FUNCTION q610_show()
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.img10,g_ima.sig05,g_ima.ima25
#  CALL q610_b_fill() #單身    #FUN-AC0074
#FUN-AC0074--add--begin
   IF g_argv1='1'  THEN      
      CALL q610_b_fill()
   END IF
   IF g_argv1='2'  THEN      
      CALL q610_b_fill_1()
   END IF
   IF g_argv1='3'  THEN      
      CALL q610_b_fill_2()
   END IF
   IF g_argv1='4'  THEN      
      CALL q610_b_fill()
      CALL q610_b_fill_1()
      CALL q610_b_fill_2()
   END IF
#FUN-AC0074--add--end
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION q610_b_fill()              #BODY FILL UP
   DEFINE l_sql                     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE sum_sie09,sum_sfa05,sum_sie11   LIKE sfa_file.sfa05
 
   LET l_sql =
#       "SELECT sie05,sie08,sie07,sie02,sie03,sie04,sie09,(sfa05-sfa065),sie11,sie12,sie13,sie14 ",                     #FUN-B20009 
#       "SELECT sie05,sie08,sie012,' ',sie013,sie07,sie02,sie03,sie04,sie09,(sfa05-sfa065),sie11,sie12,sie13,sie14 ",   #FUN-B20009  #FUN-AC0074
        "SELECT sie05,sie15,sie08,sie012,' ',sie013,sie07,sie02,sie03,sie04,sie09,(sfa05-sfa065),sie11,sie12,sie13,sie14 ",                     #FUN-AC0074
        "  FROM sie_file LEFT OUTER JOIN sfa_file ON sie01=sfa03 AND sie05=sfa01 AND sie08=sfa27 ",
#       " AND sie06 =sfa08 AND sie07 = sfa12 AND sie012 = sfa012 AND sie013 = sfa013 ",
        " AND sie06 =sfa08 AND sie07 = sfa12"                                    #FUN-AC0074
     IF g_argv1='4' AND NOT cl_null(g_argv2)  THEN
        IF cl_null(g_wc5) THEN LET g_wc5=" 1=1 " END IF  #FUN-AC0074
        LET l_sql =l_sql, " WHERE sie01 = '",g_ima.ima01,"' AND (sie16='1' OR sie16 ='2') AND sie11 > 0 AND ", g_wc5 CLIPPED
     ELSE 
       LET l_sql =l_sql,   " WHERE sie01 = '",g_ima.ima01,"' AND (sie16='1' OR sie16 ='2') AND sie11 > 0 AND ", g_wc2 CLIPPED
     END IF
     LET l_sql =l_sql," ORDER BY sie05 "
    PREPARE q610_pb FROM l_sql
    DECLARE q610_bcs CURSOR FOR q610_pb
 
    FOR g_cnt = 1 TO g_sie.getLength()           
       INITIALIZE g_sie[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET sum_sie09 = 0
    LET sum_sfa05 = 0
    LET sum_sie11 = 0
    FOREACH q610_bcs INTO g_sie[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF

       LET sum_sie09=sum_sie09+g_sie[g_cnt].sie09
       LET sum_sfa05=sum_sfa05+g_sie[g_cnt].sfa05
       LET sum_sie11=sum_sie11+g_sie[g_cnt].sie11
       LET g_cnt = g_cnt + 1
#FUN-B20009 -------------------Begin----------------------
       SELECT ecm014 INTO g_sie[g_cnt].ecm014 FROM ecm_file
        WHERE ecm01 = g_sie[g_cnt].sie05
          AND ecm03 = g_sie[g_cnt].sie013
          AND ecm012 = g_sie[g_cnt].sie012
#FUN-B20009 -------------------End------------------------
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
 	 EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sie.deleteElement(g_cnt)   #TQC-790048
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY BY NAME sum_sie09,sum_sfa05,sum_sie11
END FUNCTION
 
FUNCTION q610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sie TO s_sie.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      CALL cl_show_fld_cont()                   

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
                 
 
 
      ON ACTION jump
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
 
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF

 
      ON ACTION last
         CALL q610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
      
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                     
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")   
                       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION         
#FUN-A60047            
#FUN-AC0074--add--begin
FUNCTION q610_b_fill_1()              #BODY FILL UP
   DEFINE l_sql                     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE sum_sie09_1,sum_sfa05_1,sum_sie11_1   LIKE sfa_file.sfa05
 
   LET l_sql =
        "SELECT sie05,sie15,sie08,'','','',sie07,sie02,sie03,sie04,sie09,(sfa05-sfa065),sie11,sie12,sie13,sie14 ",  
        "  FROM sie_file LEFT OUTER JOIN sfa_file ON sie01=sfa03 AND sie05=sfa01 AND sie08=sfa27 ",
        " AND sie06 =sfa08 AND sie07 = sfa12  "
     IF g_argv1='4' AND NOT cl_null(g_argv2) THEN
        IF cl_null(g_wc5) THEN LET g_wc5=" 1=1 " END IF  #FUN-AC0074
        LET l_sql =l_sql, " WHERE sie01 = '",g_ima.ima01,"' AND sie16='3'  AND sie11 > 0 AND ", g_wc5 CLIPPED
     ELSE
        LET l_sql =l_sql, " WHERE sie01 = '",g_ima.ima01,"' AND sie16 = '3'  AND sie11 > 0 AND ", g_wc3 CLIPPED
     END IF
        LET l_sql =l_sql, " ORDER BY sie05 "
    PREPARE q610_pb1 FROM l_sql
    DECLARE q610_bcs1 CURSOR FOR q610_pb1
 
    FOR g_cnt = 1 TO g_sie1.getLength()           
       INITIALIZE g_sie1[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET sum_sie09_1 = 0
    LET sum_sfa05_1 = 0
    LET sum_sie11_1 = 0
    FOREACH q610_bcs1 INTO g_sie1[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF

       LET sum_sie09_1=sum_sie09_1+g_sie1[g_cnt].sie09_1
       LET sum_sfa05_1=sum_sfa05_1+g_sie1[g_cnt].sfa05_1
       LET sum_sie11_1=sum_sie11_1+g_sie1[g_cnt].sie11_1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
 	 EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sie1.deleteElement(g_cnt)   #TQC-790048
    LET g_rec_b1 = g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt3
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY BY NAME sum_sie09_1,sum_sfa05_1,sum_sie11_1
END FUNCTION
 
FUNCTION q610_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sie1 TO s_sie1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      CALL cl_show_fld_cont()                   

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
                 
 
 
      ON ACTION jump
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
 
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1!= 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF

 
      ON ACTION last
         CALL q610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
      
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                     
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")   
                       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
FUNCTION q610_b_fill_2()              #BODY FILL UP
   DEFINE l_sql                     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE sum_sie09_2,sum_sfa05_2,sum_sie11_2   LIKE sfa_file.sfa05
   DEFINE l_sie16   LIKE sie_file.sie16
 
   LET l_sql =
        "SELECT '',sie05,sie15,sie08,'','','',sie07,sie02,sie03,sie04,sie09,(sfa05-sfa065),sie11,sie12,sie13,sie14 ",     
        "  FROM sie_file LEFT OUTER JOIN sfa_file ON sie01=sfa03 AND sie05=sfa01 AND sie08=sfa27 "
     IF g_argv1='4' AND NOT cl_null(g_argv2)  THEN
        IF cl_null(g_wc5) THEN LET g_wc5=" 1=1 " END IF  #FUN-AC0074
        LET l_sql =l_sql, " WHERE sie01 = '",g_ima.ima01,"' AND (sie16='4' OR sie16 ='5') AND sie11 > 0 AND ", g_wc5 CLIPPED
     ELSE
        LET l_sql =l_sql, " WHERE sie01 = '",g_ima.ima01,"' AND (sie16 = '4' OR sie16 = '5') AND sie11 > 0 AND ", g_wc4 CLIPPED
     END IF
        LET l_sql =l_sql, " ORDER BY sie05 "
    PREPARE q610_pb2 FROM l_sql
    DECLARE q610_bcs2 CURSOR FOR q610_pb2
 
    FOR g_cnt = 1 TO g_sie2.getLength()           
       INITIALIZE g_sie2[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET sum_sie09_2 = 0
    LET sum_sfa05_2 = 0
    LET sum_sie11_2 = 0
    FOREACH q610_bcs2 INTO g_sie2[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       SELECT DISTINCT sie16 INTO l_sie16 FROM sie_file
         WHERE sie05 = g_sie2[g_cnt].sie05_2
               AND (sie16 = '4' OR sie16 = '5')
       IF l_sie16 = '4' THEN
          LET g_sie2[g_cnt].a = 4
       ELSE
          LET g_sie2[g_cnt].a = 5
       END IF         
       LET sum_sie09_2=sum_sie09_2+g_sie2[g_cnt].sie09_2
       LET sum_sfa05_2=sum_sfa05_2+g_sie2[g_cnt].sfa05_2
       LET sum_sie11_2=sum_sie11_2+g_sie2[g_cnt].sie11_2
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
 	 EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sie2.deleteElement(g_cnt)   #TQC-790048
    LET g_rec_b2 = g_cnt - 1
    DISPLAY g_rec_b2 TO FORMONLY.cnt5
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY BY NAME sum_sie09_2,sum_sfa05_2,sum_sie11_2
END FUNCTION
 
FUNCTION q610_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sie2 TO s_sie2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      CALL cl_show_fld_cont()                   

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
                 
 
 
      ON ACTION jump
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
 
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF

 
      ON ACTION last
         CALL q610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
      
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                     
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")   
                       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q610_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   #CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    DISPLAY ARRAY g_sie TO s_sie.* ATTRIBUTE(COUNT=g_rec_b)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         CALL cl_show_fld_cont()                   
      AFTER DISPLAY
         CONTINUE DIALOG
    END DISPLAY
    DISPLAY ARRAY g_sie1 TO s_sie1.* ATTRIBUTE(COUNT=g_rec_b1)  #No.MOD-480143
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         CALL cl_show_fld_cont()                   
      AFTER DISPLAY
         CONTINUE DIALOG
    END DISPLAY   
    DISPLAY ARRAY g_sie2 TO s_sie2.* ATTRIBUTE(COUNT=g_rec_b2)  
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         CALL cl_show_fld_cont()                   
      AFTER DISPLAY
         CONTINUE DIALOG
    END DISPLAY  
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION first
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF                 
 
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
                 
 
 
      ON ACTION jump
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
 
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF

 
      ON ACTION last
         CALL q610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
      
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE  DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
                                                                                     
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")   
                       
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  
#FUN-AC0074--add--end
