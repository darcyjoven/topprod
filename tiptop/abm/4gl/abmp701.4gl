# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmp701.4gl
# Descriptions...: ECN整批生效作業 
# Date & Author..: 08/03/04 By lilingyu
# Modify.........: FUN-820028 08/03/21 By lilingyu
# Modify.........: FUN-820028 08/04/01 By lilingyu 拿掉bmx12拋轉次數
# Modify.........: FUN-820028 08/04/02 By lilingyu 增加畫面查詢功能
# Modify.........: FUN-840033 08/04/08B yiting 1. 按取消鍵之後要記得回復INT_FLAG=0
#                                              2. 改變操作模式  3.確認的羅輯要同於abmp701/abmp701  
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.MOD-930230 09/05/25 By Pengu 1.無法按UI畫面左上角的X離開程式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60021 10/06/07 By lilingyu 平行工藝
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used（2）
# Modify.........: No.CHI-CA0035 13/01/28 By Elise 調整參數避免串查錯誤,g_argv1:固定參數 g_argv2:單號 g_argv3:執行功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   
    g_bmx      DYNAMIC ARRAY OF RECORD
                sel      LIKE type_file.chr1,
                bmx01    LIKE bmx_file.bmx01,    
                bmx06    LIKE bmx_file.bmx06,   #FUN-840033
       	        bmx07    LIKE bmx_file.bmx07,
                bmx10    LIKE bmx_file.bmx10,
                bmx05    LIKE bmx_file.bmx05,
                bmg03    LIKE bmg_file.bmg03,
             #  bmx12    LIKE bmx_file.bmx12,
                bmx04    LIKE bmx_file.bmx04    #NO.FUN-840033
               END RECORD,              
    g_bmz      DYNAMIC ARRAY OF RECORD    
                bmz02    LIKE bmz_file.bmz02,
                ima02    LIKE ima_file.ima02,
               	ima021   LIKE ima_file.ima021,
              	bmz04    LIKE bmz_file.bmz04,    
                bmz03    LIKE bmz_file.bmz03
               END RECORD,    
    g_bmy      DYNAMIC ARRAY OF RECORD    
                bmy02    LIKE bmy_file.bmy02,
                bmy03    LIKE bmy_file.bmy03,
                bmy19    LIKE bmy_file.bmy19,
                bmy04    LIKE bmy_file.bmy04,
                bmy05    LIKE bmy_file.bmy05,
                ima02_1  LIKE ima_file.ima02,
                ima021_1 LIKE ima_file.ima021,
                bmy27    LIKE bmy_file.bmy27, 
                ima02_2  LIKE ima_file.ima02,
                ima021_2 LIKE ima_file.ima021,
                bmy16    LIKE bmy_file.bmy16,
                bmy06    LIKE bmy_file.bmy06,
                bmy30    LIKE bmy_file.bmy30,  
                bmy07    LIKE bmy_file.bmy07,
                bmy22    LIKE bmy_file.bmy22
               END RECORD,   
       g_rec_x           LIKE type_file.num5,           #單身筆數
       g_rec_z           LIKE type_file.num5,           #單身筆數  
       g_rec_y           LIKE type_file.num5,           #單身筆數 
       l_ac              LIKE type_file.num5            #目前處理的ARRAY CNT 
 
DEFINE g_tmp   DYNAMIC ARRAY OF RECORD
                bmx01    LIKE bmx_file.bmx01,
                bmx04    LIKE bmx_file.bmx04      
               END RECORD
 
DEFINE p_row,p_col       LIKE type_file.num5        
DEFINE g_forupd_sql      STRING                    
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE 
       #g_sql             LIKE type_file.chr1000   
       g_sql       STRING      #NO.FUN-910082  
DEFINE g_wc              LIKE type_file.chr1000     #NO.FUN-820028
DEFINE g_bmx_1           RECORD LIKE bmx_file.*     #no.FUN-840033
DEFINE g_last_seq        LIKE type_file.num10      #FUN-840033
DEFINE b_bmy             RECORD LIKE bmy_file.*    #FUN-840033
DEFINE b_bmz             RECORD LIKE bmz_file.*    #FUN-840033
DEFINE b_bmb             RECORD LIKE bmb_file.*    #FUN-840033
DEFINE b_bmw             RECORD LIKE bmw_file.*    #FUN-840033
DEFINE b_bmd             RECORD LIKE bmd_file.*    #FUN-840033
DEFINE b_bmf             RECORD LIKE bmf_file.*    #FUN-840033
DEFINE g_bmy05_t	 LIKE bmy_file.bmy05       #FUN-840033
DEFINE g_cnt             LIKE type_file.num5      #FUN-840033
MAIN
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                               
          INPUT NO WRAP
      DEFER INTERRUPT
    END IF
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
   
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
    LET p_row = 2 LET p_col = 2    
        OPEN WINDOW p701_w AT p_row,p_col WITH FORM "abm/42f/abmp701"
             ATTRIBUTE (STYLE = g_win_style CLIPPED)     
  
    CALL cl_ui_init()
   
    CALL p701_tm()  
    CALL p701_menu()
    
 
    CLOSE WINDOW p701_w                
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
      
END MAIN
 
FUNCTION p701_tm()  
 
    CALL cl_opmsg('p')
    CLEAR FORM
    CALL g_bmx.clear()
 
    LET INT_FLAG = 0 
    INITIALIZE g_wc TO NULL            # Default condition 
  
    #CONSTRUCT g_wc ON bmx01,bmx10,bmx05
    CONSTRUCT g_wc ON bmx01,bmx06,bmx07,bmx10,bmx05      #NO.FUN-840033
         #FROM s_bmx[1].bmx01,s_bmx[1].bmx10,s_bmx[1].bmx05
         FROM s_bmx[1].bmx01,s_bmx[1].bmx06,s_bmx[1].bmx07,s_bmx[1].bmx10,s_bmx[1].bmx05  #NO.FUN-840033
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
        ON ACTION controlp
          CASE
              WHEN INFIELD(bmx01)
                CALL cl_init_qry_var()                                      
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_bmx4"                                
                CALL cl_create_qry() RETURNING g_qryparam.multiret       
                DISPLAY g_qryparam.multiret TO bmx01
                NEXT FIELD bmx01
              WHEN INFIELD(bmx10) 
                CALL cl_init_qry_var()
                LET g_qryparam.state ="c"
                LET g_qryparam.form ="q_bmx5"             
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bmx10
                NEXT FIELD bmx10
              WHEN INFIELD(bmx05) 
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_bmx6"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bmx05
                NEXT FIELD bmx05
             OTHERWISE EXIT CASE
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
 
       ON ACTION qbe_select
          CALL cl_qbe_select() 
       
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmxuser', 'bmxgrup') #FUN-980030
    #IF INT_FLAG THEN RETURN END IF
    IF INT_FLAG THEN 
        LET INT_FLAG = 0   #no.FUN-840033
        RETURN 
    END IF
    
    #NO.FUN-840033 start-----
    CALL p701_b_fill()
    CALL p701_b_fill1()                                                                                                             
    CALL p701_b()                                                                                                                   
    #CALL p701_tm1()                                                                                                   
    #NO.FUN-840033 end-------
 
END FUNCTION
 
#NO.FUN-840033 add----------
FUNCTION p701_b_fill()
  DEFINE l_i         LIKE type_file.num10                                                                                           
 
   #LET g_forupd_sql = "SELECT 'N',bmx01,bmx07,bmx10,bmx05,'' FROM bmx_file",       #NO.FUN-820028
   LET g_forupd_sql = "SELECT 'N',bmx01,bmx06,bmx07,bmx10,bmx05,'',bmx04 FROM bmx_file",       #NO.FUN-820028   #NO.FUN-840033
                     "  WHERE ",g_wc,
                      "  AND bmx04 ='N'", 
                      "  AND bmxacti = 'Y'",   #no.FUN-840033              
                      "  ORDER BY bmx07"
   DECLARE p701_cl CURSOR FROM g_forupd_sql   
  
   CALL g_bmx.clear()      
     
   LET l_i = 1 
   FOREACH p701_cl INTO g_bmx[l_i].* 
      IF SQLCA.sqlcode THEN                                                                                                        
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
         EXIT FOREACH                                                                                                              
       END IF                                                                                                                       
      SELECT bmg03 INTO g_bmx[l_i].bmg03 FROM bmg_file WHERE bmg01= g_bmx[l_i].bmx01                                                                                           
       LET l_i = l_i+1                                                                                                            
       IF l_i > g_max_rec THEN 
          EXIT FOREACH                                                                   
       END IF                                                                                                                       
   END FOREACH     
   CALL g_bmx.deleteElement(l_i)
   LET g_rec_x = l_i-1
   DISPLAY g_rec_x TO FORMONLY.cnt
END FUNCTION
 
FUNCTION p701_b_fill1()
DEFINE l_bmz01   LIKE bmz_file.bmz01  
DEFINE l_bmy01   LIKE bmy_file.bmy01
DEFINE l_i       LIKE type_file.num10                                                                                               
DEFINE l_j       LIKE type_file.num10
 
   IF l_ac > 0 THEN                                                                                                                
       LET l_bmz01 = g_bmx[l_ac].bmx01            
       LET l_bmy01 = g_bmx[l_ac].bmx01                                                                                  
    ELSE                                                                                                                            
       IF g_rec_x > 0 THEN                                                                                                          
          LET l_bmz01 = g_bmx[1].bmx01 
          LET l_bmy01 = g_bmx[1].bmx01                                                                                             
       ELSE                                                                                                                         
          LET l_bmz01 = NULL
          LET l_bmy01 = NULL                                                                                                        
       END IF                                                                                                                       
    END IF  
   
   CALL g_bmz.clear()
   #########g_bmz
   LET g_sql = "SELECT bmz02,ima02,ima021,bmz04,bmz03 FROM bmz_file,ima_file",
               " WHERE bmz01 = '",l_bmz01,"'", 
               "   and bmz02 = ima01",
               "   ORDER BY bmz02"
   
   PREPARE bmz_p1 FROM g_sql                                                                                                   
   DECLARE bmz_cur CURSOR FOR bmz_p1
 
   LET l_i = 1                                                                                                                     
   FOREACH bmz_cur INTO g_bmz[l_i].*                                                                         
       IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
           EXIT FOREACH                                                                                                            
       END IF                                                                                                                      
       LET l_i = l_i + 1                                                                                                           
       IF l_i > g_max_rec  THEN                                                                                                   
         EXIT FOREACH                                                                                                             
       END IF                                                                                                                      
   END FOREACH                                                                                                                     
   CALL g_bmz.deleteElement(l_i) #NO.FUN-820028
   LET g_rec_z = g_bmz.getLength()                                                                                                 
   DISPLAY g_rec_z TO FORMONLY.cn2       
 
   #########g_bmy  
    CALL g_bmy.clear()         
    LET g_sql ="SELECT bmy02,bmy03,bmy19,bmy04,bmy05,'','',bmy27,'','',bmy16",
               "  ,bmy06,bmy30,bmy07,bmy22 ",                                                                             
                "  FROM bmy_file,bmz_file, OUTER ima_file ",   
               "  WHERE bmz01 = bmy01",                                                                                       
               "    AND bmy05 = ima01",
               "    AND bmy01 = '",l_bmy01,"'",                                                           
               "  ORDER BY bmy02 "                                                                                                   
    PREPARE bmy_p1 FROM g_sql                                                                                                   
    DECLARE bmy_cur CURSOR FOR bmy_p1                                                                                       
 
    LET l_j = 1                                                                                                                     
    FOREACH bmy_cur INTO g_bmy[l_j].*                                                                      
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
            EXIT FOREACH                                                                                                            
        END IF 
        SELECT ima02,ima021 INTO g_bmy[l_j].ima02_1,g_bmy[l_j].ima021_1
          FROM ima_file
         WHERE ima01 = g_bmy[l_j].bmy05
        SELECT ima02,ima021 INTO g_bmy[l_j].ima02_2,g_bmy[l_j].ima021_2                                                                     
          FROM ima_file                                                                                                                 
         WHERE ima01 = g_bmy[l_j].bmy27                                                                                                                    
        LET l_j = l_j + 1                                                                                                           
        IF  l_j > g_max_rec THEN                                                                                                     
           EXIT FOREACH                                                                                                             
        END IF
    END FOREACH                                                                                                                     
    CALL g_bmy.deleteElement(l_j)
    LET g_rec_y = g_bmy.getLength()                                                                                                     
    DISPLAY g_rec_y TO FORMONLY.cn3  
 
END FUNCTION 
#NO.FUN-840033 add------------------------------
 
#NO.FUN-840033 mark---
#FUNCTION p701_tm1()
#     DEFINE l_i               LIKE type_file.num10
   
#  LET g_forupd_sql = "SELECT 'N',bmx01,bmx07,bmx10,bmx05,'',bmx12 FROM bmx_file", #NO.FUN0820028
#   LET g_forupd_sql = "SELECT 'N',bmx01,bmx07,bmx10,bmx05,'' FROM bmx_file",       #NO.FUN-820028
#                     "  WHERE ",g_wc,
#                      "  AND bmx04 ='N'",
#                      "  ORDER BY bmx07"
#   DECLARE p701_cl CURSOR FROM g_forupd_sql   
#  
#   CALL g_bmx.clear()      
#     
#   LET l_i = 1 
#   FOREACH p701_cl INTO g_bmx[l_i].* 
#       IF SQLCA.sqlcode THEN                                                                                                        
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
#          EXIT FOREACH                                                                                                              
#        END IF                                                                                                                       
#       SELECT bmg03 INTO g_bmx[l_i].bmg03 FROM bmg_file WHERE bmg01= g_bmx[l_i].bmx01                                                                                           
#        LET l_i = l_i+1                                                                                                            
#        IF l_i > g_max_rec THEN 
#           EXIT FOREACH                                                                   
#        END IF                                                                                                                       
#    END FOREACH     
#    CALL g_bmx.deleteElement(l_i)
#    LET g_rec_x = l_i-1
#    DISPLAY g_rec_x TO FORMONLY.cnt
    
#    DISPLAY ARRAY g_bmx TO s_bmx.* ATTRIBUTE(COUNT=g_rec_x,UNBUFFERED)                                                              
#       BEFORE DISPLAY                                                                                                               
#          EXIT DISPLAY                                                                                                              
#       END DISPLAY   
#  
#    INPUT ARRAY g_bmx WITHOUT DEFAULTS FROM s_bmx.*
#          ATTRIBUTE(COUNT=g_rec_x,MAXCOUNT=g_max_rec,UNBUFFERED,
#                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
#
#       BEFORE INPUT
#          IF g_rec_x != 0 THEN
#           CALL fgl_set_arr_curr(l_ac)
#          END IF
#        
#       BEFORE ROW  
#         LET l_ac = ARR_CURR()                                                                                                                  
#         CALL p701_b()                                                                                                        
#         CALL p701_bp_refresh()                                                                                                    
#                                        
#       AFTER ROW
#          LET l_ac = ARR_CURR()
#
#       AFTER INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG=0  #NO.FUN-840033
#            EXIT INPUT
#         END IF   
#          
#         CALL p701_update()
#           
#      ON ACTION select_all
#         CALL p701_sel_all("Y")
#    
#      ON ACTION select_non
#         CALL p701_sel_all("N") 
#      
#      ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#
#       ON ACTION controlg     
#          CALL cl_cmdask() 
#           END INPUT
#    
#     IF INT_FLAG THEN
#       LET INT_FLAG=0
#       CLOSE WINDOW p701_w
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM     
#    END IF     
#END FUNCTION
#no.FUN-840033 mark-----------------------
 
FUNCTION p701_b()  
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_bmz01   LIKE bmz_file.bmz01  
   DEFINE l_bmy01   LIKE bmy_file.bmy01
   
#NO.FUN-840033 mark-------------------------
#   IF l_ac > 0 THEN                                                                                                                
#       LET l_bmz01 = g_bmx[l_ac].bmx01            
#       LET l_bmy01 = g_bmx[l_ac].bmx01                                                                                  
#    ELSE                                                                                                                            
#       IF g_rec_x > 0 THEN                                                                                                          
#          LET l_bmz01 = g_bmx[1].bmx01 
#          LET l_bmy01 = g_bmx[1].bmx01                                                                                             
#       ELSE                                                                                                                         
#          LET l_bmz01 = NULL
#          LET l_bmy01 = NULL                                                                                                        
#       END IF                                                                                                                       
#    END IF  
#
#   CALL g_bmz.clear()
#  
#   #########g_bmz
#   LET g_sql = "SELECT bmz02,ima02,ima021,bmz04,bmz03 FROM bmz_file,ima_file",
#               " WHERE bmz01 = '",l_bmz01,"'", 
#               "   and bmz02 = ima01",
#               "   ORDER BY bmz02"
#   
#   PREPARE bmz_p1 FROM g_sql                                                                                                   
#   DECLARE bmz_cur CURSOR FOR bmz_p1
#
#   LET l_i = 1                                                                                                                     
#   FOREACH bmz_cur INTO g_bmz[l_i].*                                                                         
#       IF SQLCA.sqlcode THEN                                                                                                       
#           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
#           EXIT FOREACH                                                                                                            
#       END IF                                                                                                                      
#       LET l_i = l_i + 1                                                                                                           
#       IF l_i > g_max_rec  THEN                                                                                                   
#         EXIT FOREACH                                                                                                             
#       END IF                                                                                                                      
#   END FOREACH                                                                                                                     
#   CALL g_bmz.deleteElement(l_i) #NO.FUN-820028
#   LET g_rec_z = g_bmz.getLength()                                                                                                 
#   DISPLAY g_rec_z TO FORMONLY.cn2       
#
#   #########g_bmy  
#    CALL g_bmy.clear()         
#    LET g_sql ="SELECT bmy02,bmy03,bmy19,bmy04,bmy05,'','',bmy27,'','',bmy16",
#               "  ,bmy06,bmy30,bmy07,bmy22 ",                                                                             
#                "  FROM bmy_file,bmz_file, OUTER ima_file ",   
#               "  WHERE bmz01 = bmy01",                                                                                       
#               "    AND bmy05 = ima01",
#               "    AND bmy01 = '",l_bmy01,"'",                                                           
#               "  ORDER BY bmy02 "                                                                                                   
#    PREPARE bmy_p1 FROM g_sql                                                                                                   
#    DECLARE bmy_cur CURSOR FOR bmy_p1                                                                                       
#
#    LET l_j = 1                                                                                                                     
#    FOREACH bmy_cur INTO g_bmy[l_j].*                                                                      
#        IF SQLCA.sqlcode THEN                                                                                                       
#            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
#            EXIT FOREACH                                                                                                            
#        END IF 
#        SELECT ima02,ima021 INTO g_bmy[l_j].ima02_1,g_bmy[l_j].ima021_1
#          FROM ima_file
#         WHERE ima01 = g_bmy[l_j].bmy05
#        SELECT ima02,ima021 INTO g_bmy[l_j].ima02_2,g_bmy[l_j].ima021_2                                                                     
#          FROM ima_file                                                                                                                 
#         WHERE ima01 = g_bmy[l_j].bmy27                                                                                                                    
#        LET l_j = l_j + 1                                                                                                           
#        IF  l_j > g_max_rec THEN                                                                                                     
#           EXIT FOREACH                                                                                                             
#        END IF
#    END FOREACH                                                                                                                     
#    CALL g_bmy.deleteElement(l_j)
#    LET g_rec_y = g_bmy.getLength()                                                                                                     
#    DISPLAY g_rec_y TO FORMONLY.cn3  
#NO.FUN-840033 mark------------------------
 
    #--no.FUN-840033 start-----
    DISPLAY ARRAY g_bmx TO s_bmx.* ATTRIBUTE(COUNT=g_rec_x,UNBUFFERED)                                                              
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
    END DISPLAY                                                                                                                     
                                                                                                                                    
    DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_z,UNBUFFERED)                                                             
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
    END DISPLAY                                                                                                                     
 
    DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_y,UNBUFFERED)                                                             
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
    END DISPLAY                                   
             
    IF g_rec_x = 0 THEN                                                                                                             
       LET g_action_choice=''                                                                                                       
       RETURN                                                                                                                       
    END IF
  
    INPUT ARRAY g_bmx WITHOUT DEFAULTS FROM s_bmx.*
          ATTRIBUTE(COUNT=g_rec_x,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
          IF g_rec_x != 0 THEN
           CALL fgl_set_arr_curr(l_ac)
          END IF
        
       BEFORE ROW  
         LET l_ac = ARR_CURR()                                                                                                                  
         CALL p701_b_fill1()                                                                                                        
         CALL p701_bp_refresh()                                                                                                    
                                        
       AFTER ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG=0  #NO.FUN-840033
            EXIT INPUT
         END IF   
          
       # CALL p701_update()  #no.FUN-840033 mark
           
      ON ACTION select_all
         CALL p701_sel_all("Y")
    
      ON ACTION select_non
         CALL p701_sel_all("N") 
      
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg     
          CALL cl_cmdask() 
           END INPUT
 
    LET g_action_choice=''                                                                                                          
    IF INT_FLAG THEN                                                                                                                
       LET INT_FLAG=0                                                                                                               
       RETURN                                                                                                                       
    END IF                                                                                                                          
    #--no.FUN-840033 end-----------
 
END FUNCTION
 
FUNCTION p701_menu()
DEFINE  l_cmd   STRING   #NO.FUN-840033 add
DEFINE  l_i     LIKE type_file.num5    #FUN-840033 add
DEFINE  l_bmx50 LIKE bmx_file.bmx50    #FUN-A60021

   WHILE TRUE                                                                                                        
      CALL p701_bp("G")
      CASE g_action_choice     
 
         #NO.FUN-840033 MARK--
         #WHEN "retry"
         #     CALL p701_tm1()
         #     CALL p701_tm()
         #no.FUN-840033 mark---
         
         #NO.FUN-840033 start--
         WHEN "detail"                                                                                                          
            IF cl_chk_act_auth() THEN                                                                                               
               CALL p701_b()                                                                                                        
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF                                                                                                                  
 
         WHEN "confirm"                                                                                                          
            IF cl_chk_act_auth() THEN                                                                                               
               CALL s_showmsg_init()
               BEGIN WORK
               FOR l_i = 1 TO g_bmx.getLength()
                  IF g_bmx[l_i].sel = 'Y' THEN
        #FUN-A60021 --begin--                  
                      LET l_bmx50 = NULL
                      SELECT bmx50 INTO l_bmx50 FROM bmx_file
                       WHERE bmx01 = g_bmx[l_i].bmx01 
        #FUN-A60021 --end--                        
                      IF g_bmx[l_i].bmx06 = '1' THEN    #多主件ECN   
                          IF l_bmx50 = '1' THEN   #FUN-A60021 
                             LET l_cmd="abmi710 '",g_bmx[l_i].bmx01,"' 'abmp701' "
                             CALL cl_cmdrun(l_cmd)   
                          END IF                  #FUN-A60021    
                      ELSE                               #單一主件ECN
                      	  IF l_bmx50 = '1' THEN   #FUN-A60021  #CHI-CA0035 mod 2->1
                             LET l_cmd="abmi720 '",g_bmx[l_i].bmx01,"' 'abmp701' "
                             CALL cl_cmdrun(l_cmd) 
                             #CALL p701_update()         #NO.840033 mark                                                                                                
                          END IF                 #FUN-A60021    
                      END IF
                  END IF
                END FOR
                COMMIT WORK
                CALL s_showmsg()
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF                                                                                                                  
         #no.FUN-840033 end----
 
         WHEN "query"
              CALL p701_tm()     
              
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel                                                                                              
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_bmx),'','')                                                       
            END IF 
      END CASE
   END WHILE
   
    #NO.FUN-840033 mark-----
    #IF INT_FLAG THEN                                                                                                               
    #   LET INT_FLAG=0                                                                                                               
    #   CLOSE WINDOW p701_w                                                                                                          
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                               
    #   EXIT PROGRAM                                                                                                                 
    #END IF
    #no.FUN-840033 mark----
    
END FUNCTION
                                                                                                       
FUNCTION p701_bp(p_ud)                                                                                                             
   DEFINE   p_ud   LIKE type_file.chr1                                                                                              
                                                                                                                                    
   IF p_ud <> "G" THEN 
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_action_choice = " "    
   CALL cl_set_act_visible("accept,cancel", FALSE)      #NO.FUN-840033                                                                              
    
  # DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_z,UNBUFFERED)     
  # DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_y,UNBUFFERED)
    DISPLAY ARRAY g_bmx TO s_bmx.* ATTRIBUTE(COUNT=g_rec_x,UNBUFFERED)                                                          
 
      BEFORE ROW
         LET l_ac = ARR_CURR() 
         IF l_ac = 0 THEN                                                                                                           
            LET l_ac = 1                                                                                                            
         END IF
                                                                                                             
         #CALL p701_b()
         CALL p701_b_fill1()  #NO.FUN-840033
         CALL p701_bp_refresh()
         CALL cl_show_fld_cont() 
         
       #no.FUN-840033 mark--
       #ON ACTION retry
       #   LET g_action_choice = "retry"
       #   LET l_ac = 1
       #   EXIT DISPLAY 
       #NO.FUN-840033 mark---
       
       ON ACTION query
          LET g_action_choice="query"                                                                                                 
          EXIT DISPLAY   
          
       #NO.FUN-840033 start--
       #ON ACTION accept
       #  LET g_action_choice="retry"                                                                                           
       #  LET l_ac = ARR_CURR()                                                                                                      
       #  EXIT DISPLAY                                                                                                      
       #NO.FUN-840033 end----
    
      #no.FUN-840033 add--
       ON ACTION detail                                                                                                          
         LET g_action_choice="detail"                                                                                           
         LET l_ac = 1                                                                                                               
         EXIT DISPLAY                                                                                                               
 
       ON ACTION accept
         LET g_action_choice="detail"                                                                                           
         LET l_ac = ARR_CURR()                                                                                                      
         EXIT DISPLAY                                                                                                               
 
       ON ACTION confirm
         LET g_action_choice="confirm"                                                                                           
         EXIT DISPLAY                                                                                                               
      #no.FUN-840033 end---
 
      ON ACTION CONTROLS                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
                                                                                                 
      ON ACTION help                                                                                                                
         LET g_action_choice="help"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION locale                                                                                                              
         CALL cl_dynamic_locale()                                                                                                   
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION exit                                                                                                                
         LET g_action_choice="exit"                                                                                                 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
         EXIT PROGRAM
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         LET g_action_choice="controlg"                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                           
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                         
 
     #-----------No.MOD-930230 add
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
     #-----------No.MOD-930230 end
 
      #NO.FUN-840033 mark--
      #IF INT_FLAG THEN                                                                                                               
      #   LET INT_FLAG=0                                                                                                               
      #   CLOSE WINDOW p701_w                                                                                                          
      #   CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                               
      #   EXIT PROGRAM                                                                                                                 
      #END IF
      #NO.FUN-840033 mark---
                                                                          
    AFTER DISPLAY                                                                                                                 
        # DISPLAY g_rec_z TO FORMONLY.cn2
        # DISPLAY g_rec_y TO FORMONLY.cn3
         CONTINUE DISPLAY                                                                                                         
                                                                                                
   END DISPLAY                                                                                                                      
   CALL cl_set_act_visible("accept,cancel", TRUE)                                                                                   
END FUNCTION                                                                                                                       
 
FUNCTION p701_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10
 
  FOR l_i = 1 TO g_bmx.getLength()
     LET g_bmx[l_i].sel = p_value
  END FOR
 
END FUNCTION
 
 
FUNCTION p701_bp_refresh()                                                                                                         
   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_z,UNBUFFERED)                                                              
      BEFORE DISPLAY
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
      ON ACTION help                                                                                                                
         CALL cl_show_help()                                                                                                        
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         CALL cl_cmdask()                                                                                                           
                                                                                                                                    
   END DISPLAY
             
   DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_y,UNBUFFERED)                                                              
      BEFORE DISPLAY                                                                                                                
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
      ON ACTION help                                                                                                                
         CALL cl_show_help()                                                                                                        
                                                                                                                                    
      ON ACTION controlg
      CALL cl_cmdask()                                                                                                           
                                                                                                                                    
    END DISPLAY 
                                                                                                      
END FUNCTION  
 
#NO.FUN-840033 mark-------------------------
#FUNCTION p701_update()
#  DEFINE l_i                  LIKE type_file.num10  
#  DEFINE l_j                  LIKE type_file.num10
#  DEFINE l_k                  LIKE type_file.num10
#  DEFINE g_tmpsql                STRING
#  
#
#     #no.FUN-840033 mark--
#     #FOR l_i = 1 TO g_bmx.getLength()                                                                                               
#     #    IF cl_null(g_bmx[l_i].bmx01) THEN                                                                                          
#     #       CONTINUE FOR                                                                                                              
#     #     END IF                                                                                                                       
#     #     IF g_bmx[l_i].sel = 'N' THEN                                                                                               
#     #        CONTINUE FOR                                                                                                              
#     #     END IF                                                                                                                      
#     #NO.FUN-840033 end---
#
#    IF cl_sure(18,20) THEN 
#        #FOR l_j = 1 TO g_bmz.getLength()
#        FOR l_j = 1 TO g_bmx.getLength()   #NO.FUN-840033
#          LET g_tmpsql ="  SELECT bmx01,bmx04 FROM bmx_file,bmz_file",
#                        "   WHERE bmx04 = 'N'",
#                        "     AND bmx01 = bmz01",              
#                        "     AND bmz02 = '",g_bmz[l_j].bmz02,"'",               
#                        "     ORDER BY bmx07 ASC"           
#          PREPARE tmp_p FROM g_tmpsql                                                                                                   
#          DECLARE tmp_cur CURSOR FOR tmp_p
#
#          LET l_k = 1                                                                                                                     
#          FOREACH tmp_cur INTO g_tmp[l_k].*                                                                         
#             IF SQLCA.sqlcode THEN                                                                                                       
#                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
#                EXIT FOREACH                                                                                                            
#             END IF              
#              
#             UPDATE bmx_file SET bmx04 = 'Y' 
#              WHERE bmx01 = g_tmp[l_k].bmx01      
#                                                                                                                            
#             LET l_k = l_k + 1                                                                                                           
#             IF l_k > g_max_rec  THEN                                                                                                   
#               EXIT FOREACH                                                                                                             
#             END IF                                                                                                                      
#          END FOREACH   
#        END FOR
#    ELSE 
#        RETURN
#    END IF 
#  #END FOR    #NO.FUN-840033 mark
#         
#END FUNCTION
#NO.FUN-840033 mark--------------------------------
 
#no.FUN-840033 start--
FUNCTION p701_y()
 
END FUNCTION
#NO.FUN-840033 end----
 
