# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#                                                                                                                                   
# Pattern name...: abmp700.4gl                                                                                                      
# Descriptions...: ECN資料拋轉作業                                                                                               
# Input parameter:                                                                                                                  
# Date & Author..: 08/03/05 By xiaofeizhu  FUN-820027                                                                                             
# Modify.........: NO.FUN-840033 08/04/09 BY yiting  INF_FLAG=0                                                                                                                                    
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds                                                                                                                         
                                                                                                                                    
GLOBALS "../../config/top.global"                                                                                                   
GLOBALS "../../sub/4gl/s_data_center.global"                                                                                        
                                                                                                                                    
DEFINE tm1        RECORD                                                                                                            
                  gev04    LIKE gev_file.gev04,                                                                                     
                  geu02    LIKE geu_file.geu02,
#                 wc       LIKE type_file.chr1000  
                  wc       STRING            #NO.FUN-910082                                                                                     
                  END RECORD                                                                                                        
DEFINE g_rec_b    LIKE type_file.num10                                                                                              
DEFINE g_rec_b1   LIKE type_file.num10                                                                                              
DEFINE g_rec_b2   LIKE type_file.num10
DEFINE g_bmx      DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                        
         sel      LIKE type_file.chr1,
         bmx01    LIKE bmx_file.bmx01,                                                                                          
         bmx07    LIKE bmx_file.bmx07,                                                                                          
         bmx10    LIKE bmx_file.bmx10,                                                                                          
         bmx05    LIKE bmx_file.bmx05,                                                                                          
         bmg03    LIKE bmg_file.bmg03
#        bmx04    LIKE bmx_file.bmx04,                                                                                          
#        bmx12    LIKE bmx_file.bmx12                                                                                            
                  END RECORD
DEFINE g_bmx1     DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                        
         sel      LIKE type_file.chr1,                                                                                          
         bmx01    LIKE bmx_file.bmx01                                                                                           
                  END RECORD
DEFINE g_bmz      DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)                                                         
         bmz02    LIKE bmz_file.bmz02,                                                                               
         ima02_1  LIKE ima_file.ima02,                                                                               
         ima021_1 LIKE ima_file.ima021,                                                                              
         bmz04    LIKE bmz_file.bmz04,                                                               
         bmz03    LIKE bmz_file.bmz03                                                                               
                  END RECORD
DEFINE g_bmz1     DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                            
         sel      LIKE type_file.chr1,                                                                                              
         bmz01    LIKE bmz_file.bmz01,
         bmz02    LIKE bmz_file.bmz02,
         bmz05    LIKE bmz_file.bmz05                                                                                               
                  END RECORD
DEFINE g_bmy      DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)                                                         
         bmy02    LIKE bmy_file.bmy02,                                                                               
         bmy03    LIKE bmy_file.bmy03,                                                                               
         bmy19    LIKE bmy_file.bmy19,                                                                               
         bmy04    LIKE bmy_file.bmy04,                                                                               
         bmy05    LIKE bmy_file.bmy05,                                                                               
         ima02    LIKE ima_file.ima02,                                                                               
         ima021   LIKE ima_file.ima021,                                                                              
         bmy27    LIKE bmy_file.bmy27,                                                             
         ima02n   LIKE ima_file.ima02,                                                                               
         ima021n  LIKE ima_file.ima021,                                                                              
         bmy16    LIKE bmy_file.bmy16,
         bmy06    LIKE bmy_file.bmy06,                                                                               
         bmy30    LIKE bmy_file.bmy30,                                                       
         bmy07    LIKE bmy_file.bmy07,                                                                               
         bmy22    LIKE bmy_file.bmy22                                                                                
                  END RECORD
DEFINE g_bmy1     DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                            
         sel      LIKE type_file.chr1,                                                                                              
         bmy01    LIKE bmy_file.bmy01,                                                                                              
         bmy02    LIKE bmy_file.bmy02                                                                                              
                  END RECORD
DEFINE 
      #g_sql      LIKE type_file.chr1000 
       g_sql       STRING      #NO.FUN-910082                                                                                           
DEFINE g_cnt      LIKE type_file.num10                                                                                              
DEFINE g_i        LIKE type_file.num5                                                                                               
DEFINE l_ac       LIKE type_file.num5                                                                                               
DEFINE i          LIKE type_file.num5                                                                                               
DEFINE g_cnt1     LIKE type_file.num10                                                                                              
DEFINE g_db_type  LIKE type_file.chr3                                                                                               
DEFINE g_err      LIKE type_file.chr1000                                                                                            
                                                                                                                                    
MAIN                                                                                                                                
  DEFINE p_row,p_col    LIKE type_file.num5                                                                                         
                                                                                                                                    
   OPTIONS                                                                                                                          
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function                                                                        
                                                                                                                                    
   IF (NOT cl_user()) THEN                                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF
                                                                                                                                    
   WHENEVER ERROR CALL cl_err_msg_log                                                                                               
                                                                                                                                    
   IF (NOT cl_setup("ABM")) THEN                                                                                                    
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                                                                                   
                                                                                                                                    
   LET g_db_type=cl_db_get_database_type()                                                                                          
                                                                                                                                    
   LET p_row = 4 LET p_col = 12                                                                                                     
   OPEN WINDOW p700_w AT p_row,p_col                                                                                                
        WITH FORM "abm/42f/abmp700"                                                                                                 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                     
                                                                                                                                    
   CALL cl_ui_init()                                                                                                                
            
   SELECT * FROM gev_file WHERE gev01 = '3' AND gev02 = g_plant                                                                     
                            AND gev03 = 'Y'                                                                                         
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_plant,'aoo-036',3)   #Not Carry DB                                                                              
      EXIT PROGRAM                                                                                                                  
   END IF
                                                                                                                        
   CALL p700_tm()                                                                                                                   
   CALL p700_menu()                                                                                                                 
                                                                                                                                    
   CLOSE WINDOW p700_w                                                                                                              
                                                                                                                                    
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
                                                                                                                                    
END MAIN                                                                                                                            
                                                                                                                                    
FUNCTION p700_menu()                                                                                                                
   DEFINE   l_cmd   LIKE type_file.chr1000                                                                  
                                                                                                                                    
   WHILE TRUE                                                                                                                       
      CALL p700_bp("G")                                                                                                             
      CASE g_action_choice                                                                                                          
         WHEN "query"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL p700_tm()                                                                                                       
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "bmx_detail"                                                                                                          
            IF cl_chk_act_auth() THEN                                                                                               
               CALL p700_b()                                                                                                        
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "bmzbmy_detail"
            IF cl_chk_act_auth() THEN                                                                                               
               CALL p700_bp1('G')                                                                                                   
            ELSE                                                                                                                    
               LET g_action_choice = NULL                                                                                           
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "carry"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL ui.Interface.refresh()                                                                                          
               CALL p700()                                                                                                          
#              ERROR ""                                                                                                             
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "download"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
               CALL p700_download()                                                                                                 
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "qry_carry_history"                                                                                                   
            IF cl_chk_act_auth() THEN                                                                                               
               IF l_ac > 0 THEN                                                                                                     
                  LET l_cmd='aooq604 "',tm1.gev04,'" "3"'
                  CALL cl_cmdrun(l_cmd)                                                                                             
               END IF                                                                                                               
            END IF                                                                                                                  
                                                                                                                                    
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
END FUNCTION
 
FUNCTION p700_tm()                                                                                                                  
  DEFINE l_sql,l_where  STRING                                                                                                      
  DEFINE l_module       LIKE type_file.chr4                                                                                         
                                                                                                                                    
    CALL cl_opmsg('p')         
    CLEAR FORM                                                                                                                      
    CALL g_bmx.clear()
                                                                                                     
    INITIALIZE tm1.* TO NULL            # Default condition                                                                         
    LET tm1.gev04=NULL                                                                                                              
    LET tm1.geu02=NULL                                                                                                              
                                                                                                                                    
    SELECT gev04 INTO tm1.gev04 FROM gev_file                                                                                       
     WHERE gev01 = '3' AND gev02 = g_plant                                                                                          
    SELECT geu02 INTO tm1.geu02 FROM geu_file                                                                                       
     WHERE geu01 = tm1.gev04                                                                                                        
    DISPLAY tm1.gev04 TO gev04                                                                                                      
    DISPLAY tm1.geu02 TO geu02
 
#   DISPLAY BY NAME tm1.*                                                                                                           
#                                                                                                                                   
#   INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS                                                                                        
#                                                                                                                                   
#      AFTER FIELD gev04                                                                                                            
#         IF NOT cl_null(tm1.gev04) THEN                                                                                            
#            CALL p700_gev04()                                                                                                      
#            IF NOT cl_null(g_errno) THEN                                                                                           
#               CALL cl_err(tm1.gev04,g_errno,0)                                                                                    
#               NEXT FIELD gev04
#            END IF                                                                                                                 
#         ELSE                                                                                                                      
#            DISPLAY '' TO geu02                                                                                                    
#         END IF                                                                                                                    
#                                                                                                                                   
#      ON ACTION CONTROLP                                                                                                           
#         CASE                                                                                                                      
#            WHEN INFIELD(gev04)                                                                                                    
#               CALL cl_init_qry_var()                                                                                              
#               LET g_qryparam.form = "q_gev04"                                                                                     
#               LET g_qryparam.arg1 = "3"                                                                                           
#               LET g_qryparam.arg2 = g_plant                                                                                       
#               CALL cl_create_qry() RETURNING tm1.gev04                                                                            
#               DISPLAY BY NAME tm1.gev04                                                                                           
#               NEXT FIELD gev04                                                                                                    
#            OTHERWISE EXIT CASE                                                                                                    
#         END CASE                                                                                                                  
#                                                                                                                                   
#      ON ACTION locale                                                                                                             
#         CALL cl_show_fld_cont()                                                                                                   
#         LET g_action_choice = "locale"
#                                                                                                                                   
#      ON IDLE g_idle_seconds                                                                                                       
#         CALL cl_on_idle()                                                                                                         
#         CONTINUE INPUT                                                                                                            
#                                                                                                                                   
#      ON ACTION controlg                                                                                                           
#         CALL cl_cmdask()                                                                                                          
#                                                                                                                                   
#      ON ACTION exit                                                                                                               
#         LET INT_FLAG = 1                                                                                                          
#         EXIT INPUT                                                                                                                
#                                                                                                                                   
#   END INPUT                                                                                                                       
#                                                                                                                                   
#   IF INT_FLAG THEN                                                                                                                
#      LET INT_FLAG=0                                                                                                               
#      CLOSE WINDOW p700_w                                                                                                          
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                               
#      EXIT PROGRAM                                                                                                                 
#   END IF                   
 
    CALL g_bmx.clear()                                                                                                              
    CONSTRUCT tm1.wc ON bmx01,bmx07,bmx10,bmx05                             #,bmx12                                                                      
         FROM s_bmx[1].bmx01,s_bmx[1].bmx07,s_bmx[1].bmx10,                                                                        
              s_bmx[1].bmx05                                                #,s_bmx[1].bmx12                                                                        
                                                                                                                                    
       BEFORE CONSTRUCT                                                                                                             
          CALL cl_qbe_init()                                                                                                        
    
        ON ACTION controlp                                                                                                          
          CASE                                                                                                                      
               WHEN INFIELD(bmx01) #查詢單                                                                                          
                #--No.MOD-4A0248--------                                                                                            
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.state= "c"                                                                                            
               LET g_qryparam.form = "q_bmx3"                                                                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO bmx01                                                                                 
               NEXT FIELD bmx01                                                                                                     
               
               WHEN INFIELD(bmx10) #申請人                                                                                          
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_gen"                                                                                      
                 LET g_qryparam.state = 'c'                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO bmx10                                                                               
                 NEXT FIELD bmx10                                                                                                   
 
               WHEN INFIELD(bmx05) #查詢ECR                                                                                         
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.form = "q_bmr"                                                                                   
                    LET g_qryparam.state = "c"                                                                                      
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO bmx05                                                                            
                    NEXT FIELD bmx05                                                                                                
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
    LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('bmxuser', 'bmxgrup') #FUN-980030
                                                                                                                                    
    #IF INT_FLAG THEN RETURN END IF                                                                                                       
    IF INT_FLAG THEN 
        LET INT_FLAG = 0   #NO.FUN-840033
        RETURN 
    END IF                                                                                                       
                                                                                                                                    
    CALL p700_b_fill()
    CALL p700_b_fill1()                                                                                                             
    CALL p700_b()                                                                                                                   
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION p700_b_fill()                                                                                                              
  DEFINE l_i         LIKE type_file.num10                                                                                           
                                                                                                                                    
#   DECLARE sel_bmx_cur CURSOR FOR
#    SELECT 'N',bmx01,bmx07,bmx10,bmx05,'',bmx12
#      FROM bmx_file
#     WHERE tm1.wc
#     ORDER BY bmx01
 
    LET g_sql = " SELECT 'N',bmx01,bmx07,bmx10,bmx05,'',bmx04",                    #,bmx12",                                                                      
                "   FROM bmx_file ",                                                                                                
                "  WHERE ",tm1.wc,                                                                                                  
                "  ORDER BY bmx01 "                                                                                                 
    PREPARE bmx_p1 FROM g_sql                                                                                                       
    DECLARE sel_bmx_cur CURSOR FOR bmx_p1
                                                                                                                                    
    CALL g_bmx.clear()                                                                                                              
    LET l_i = 1                                                                                                                     
    FOREACH sel_bmx_cur INTO g_bmx[l_i].*   #單身 ARRAY 填充                                                                        
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
            EXIT FOREACH                                                                                                            
        END IF 
    SELECT bmg03 INTO g_bmx[l_i].bmg03
      FROM bmg_file
      WHERE  bmg01 = g_bmx[l_i].bmx01 
#     ORDER BY bmg01                                                                                                                    
        LET l_i = l_i + 1                                                                                                           
        IF l_i > g_max_rec THEN                                                                                                     
           CALL cl_err( '', 9035, 0 )                                                                                               
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
    END FOREACH                                                                                                                     
    CALL g_bmx.deleteElement(l_i)                                                                                                   
    LET g_rec_b = l_i - 1                                                                                                           
    DISPLAY g_rec_b TO FORMONLY.cnt                                                                                                 
                                                                                                                                    
END FUNCTION
 
FUNCTION p700_b_fill1()                                                                                                             
DEFINE l_bmz01   LIKE bmz_file.bmz01  
DEFINE l_bmy01   LIKE bmy_file.bmy01
DEFINE l_i       LIKE type_file.num10                                                                                               
                                                                                                                                    
    IF l_ac > 0 THEN                                                                                                                
       LET l_bmz01 = g_bmx[l_ac].bmx01            
       LET l_bmy01 = g_bmx[l_ac].bmx01                                                                                  
    ELSE                                                                                                                            
       IF g_rec_b > 0 THEN                                                                                                          
          LET l_bmz01 = g_bmx[1].bmx01 
          LET l_bmy01 = g_bmx[1].bmx01                                                                                             
       ELSE                                                                                                                         
          LET l_bmz01 = NULL
          LET l_bmy01 = NULL                                                                                                        
       END IF                                                                                                                       
    END IF                                                                                                                          
                                                                                                                                    
    LET g_sql ="SELECT bmz02,ima02,ima021,bmz04,bmz03",                                                                  
               "  FROM bmz_file,ima_file ",                                                                                   
               " WHERE bmz01 = '",l_bmz01,"'",                                                                                      
               "   AND bmz02 = ima01 ",                                                                                    
               " ORDER BY bmz02 "                                                                                                   
    PREPARE sel_bmz_p1 FROM g_sql                                                                                                   
    DECLARE sel_bmz_cur CURSOR FOR sel_bmz_p1
                                                                                                                                    
    CALL g_bmz.clear()                                                                                                              
    LET l_i = 1                                                                                                                     
    FOREACH sel_bmz_cur INTO g_bmz[l_i].*   #單身 ARRAY 填充                                                                        
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
            EXIT FOREACH                                                                                                            
        END IF                                                                                                                      
        LET l_i = l_i + 1                                                                                                           
        IF l_i > g_max_rec THEN                                                                                                     
           CALL cl_err( '', 9035, 0 )                                                                                               
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
    END FOREACH                                                                                                                     
    CALL g_bmz.deleteElement(l_i)                                                                                                   
    LET g_rec_b1 = l_i - 1                                                                                                          
    DISPLAY g_rec_b1 TO FORMONLY.cn2                                                                                                
 
    LET g_sql ="SELECT bmy02,bmy03,bmy19,bmy04,bmy05,'','',bmy27,'','',bmy16,bmy06,bmy30,bmy07,bmy22",                                                                             
               "  FROM bmy_file,bmz_file, OUTER ima_file ",                                                                                         
               " WHERE bmy01 = '",l_bmy01,"'",                                                                                      
               "   AND bmz01 = bmy01 ",
               "   AND bmy_file.bmy05 = ima_file.ima01 ",                                                                                             
               " ORDER BY bmy02 "                                                                                                   
    PREPARE sel_bmy_p1 FROM g_sql                                                                                                   
    DECLARE sel_bmy_cur CURSOR FOR sel_bmy_p1                                                                                       
                                                                                                                                    
    CALL g_bmy.clear()                                                                                                              
    LET l_i = 1                                                                                                                     
    FOREACH sel_bmy_cur INTO g_bmy[l_i].*   #單身 ARRAY 填充                                                                        
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                 
            EXIT FOREACH                                                                                                            
        END IF 
    SELECT ima02,ima021 INTO g_bmy[l_i].ima02,g_bmy[l_i].ima021
      FROM ima_file
     WHERE ima01 = g_bmy[l_i].bmy05
    SELECT ima02,ima021 INTO g_bmy[l_i].ima02n,g_bmy[l_i].ima021n                                                                     
      FROM ima_file                                                                                                                 
     WHERE ima01 = g_bmy[l_i].bmy27                                                                                                                    
        LET l_i = l_i + 1                                                                                                           
        IF l_i > g_max_rec THEN                                                                                                     
           CALL cl_err( '', 9035, 0 )                                                                                               
           EXIT FOREACH                                                                                                             
        END IF
    END FOREACH                                                                                                                     
    CALL g_bmy.deleteElement(l_i)                                                                                                   
    LET g_rec_b2 = l_i - 1                                                                                                          
    DISPLAY g_rec_b2 TO FORMONLY.cn3
                                                                                                                                    
END FUNCTION
 
FUNCTION p700_b()                                                                                                                   
                                                                                                                                    
    SELECT * FROM gev_file                                                                                                          
     WHERE gev01 = '3' AND gev02 = g_plant                                                                                          
       AND gev03 = 'Y' AND gev04 = tm1.gev04                                                                                        
    IF SQLCA.sqlcode THEN                                                                                                           
       CALL cl_err(g_plant,'aoo-036',1)                                                                                             
       RETURN                                                                                                                       
    END IF                                                                                                                          
                                                                                                                                    
    DISPLAY ARRAY g_bmx TO s_bmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                              
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
    END DISPLAY                                                                                                                     
                                                                                                                                    
    DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                             
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
    END DISPLAY                                                                                                                     
 
    DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)                                                             
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
    END DISPLAY                                   
             
    IF g_rec_b = 0 THEN                                                                                                             
       LET g_action_choice=''                                                                                                       
       RETURN                                                                                                                       
    END IF
                                                                                    
    INPUT ARRAY g_bmx WITHOUT DEFAULTS FROM s_bmx.*                                                                                 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                                                                    
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
                                                                                                                                    
       BEFORE INPUT                                                                                                                 
          IF g_rec_b!=0 THEN                                                                                                        
             CALL fgl_set_arr_curr(l_ac)                                                                                            
          END IF                                                                                                                    
                                                                                                                                    
       BEFORE ROW                                                                                                                   
         LET l_ac = ARR_CURR() 
         CALL p700_b_fill1()                                                                                                        
         CALL p700_bp1_refresh()                                                                                                    
                                                                                                                                    
       AFTER ROW                                                                                                                    
          LET l_ac = ARR_CURR()                                                                                                     
                                                                                                                                    
       AFTER INPUT                                                                                                                  
          EXIT INPUT                                                                                                                
                                                                                                                                    
       ON ACTION select_all                                                                                                         
          CALL p700_sel_all_1("Y")                                                                                                  
                                                                                                                                    
       ON ACTION select_non                                                                                                         
          CALL p700_sel_all_1("N")
                                                                                                                                    
       ON IDLE g_idle_seconds                                                                                                       
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
                                                                                                                                    
       ON ACTION controlg      #MOD-4C0121                                                                                          
          CALL cl_cmdask()     #MOD-4C0121                                                                                          
                                                                                                                                    
    END INPUT                                                                                                                       
                                                                                                                                    
    LET g_action_choice=''                                                                                                          
    IF INT_FLAG THEN                                                                                                                
       LET INT_FLAG=0                                                                                                               
       RETURN                                                                                                                       
    END IF                                                                                                                          
                                                                                                                                    
END FUNCTION
 
FUNCTION p700_gev04()                                                                                                               
    DEFINE l_geu00   LIKE geu_file.geu00                                                                                            
    DEFINE l_geu02   LIKE geu_file.geu02                                                                                            
    DEFINE l_geuacti LIKE geu_file.geuacti                                                                                          
                                                                                                                                    
    LET g_errno = ' '                                                                                                               
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti                                                                       
      FROM geu_file WHERE geu01=tm1.gev04                                                                                           
    CASE                                                                                                                            
        WHEN l_geuacti = 'N' LET g_errno = '9028'                                                                                   
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'                                                                                
        WHEN STATUS=100      LET g_errno = 100                                                                                      
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'                                                             
    END CASE                                                                                                                        
    IF NOT cl_null(g_errno) THEN                                                                                                    
       LET l_geu02 = NULL                                                                                                           
    ELSE                                                                                                                            
       SELECT * FROM gev_file WHERE gev01 = '3' AND gev02 = g_plant                                                                 
                                AND gev03 = 'Y' AND gev04 = tm1.gev04                                                               
       IF SQLCA.sqlcode THEN                                                                                                        
          LET g_errno = 'aoo-036'   #Not Carry DB                                                                                   
       END IF                                                                                                                       
    END IF
    IF cl_null(g_errno) THEN                                                                                                        
       LET tm1.geu02 = l_geu02                                                                                                      
    END IF                                                                                                                          
    DISPLAY BY NAME tm1.geu02                                                                                                       
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION p700_sel_all_1(p_value)                                                                                                    
   DEFINE p_value   LIKE type_file.chr1                                                                                             
   DEFINE l_i       LIKE type_file.num10                                                                                            
                                                                                                                                    
   FOR l_i = 1 TO g_bmx.getLength()                                                                                                 
       LET g_bmx[l_i].sel = p_value                                                                                                 
   END FOR                                                                                                                          
                                                                                                                                    
END FUNCTION
 
FUNCTION p700()                                                                                                                     
   DEFINE l_i       LIKE type_file.num10                                                                                            
   DEFINE l_j       LIKE type_file.num10                                                                                            
                                                                                                                                    
   CALL g_bmx1.clear()                                                                                                              
   LET l_j = 1                                                                                                                      
   FOR l_i = 1 TO g_bmx.getLength()                                                                                                 
       IF g_bmx[l_i].sel = 'Y' THEN                                                                                                 
          LET g_bmx1[l_j].sel   = g_bmx[l_i].sel                                                                                    
          LET g_bmx1[l_j].bmx01 = g_bmx[l_i].bmx01                                                                                  
          LET l_j = l_j + 1                                                                                                      
       END IF                                                                                                                       
   END FOR                                                                                                                          
 
   IF l_j = 1 THEN                                                                                                                  
      CALL cl_err('','aoo-096',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   #開窗選擇拋轉的db清單                                                                                                            
   CALL s_dc_sel_db(tm1.gev04,'3')                                                                                                  
   IF INT_FLAG THEN                                                                                                                 
      LET INT_FLAG=0                                                                                                                
      RETURN                                                                                                                        
   END IF
                                                                                                                                    
   CALL s_showmsg_init()
   CALL s_abmi710_carry_bmx(g_bmx1,g_azp,tm1.gev04,'0')
   CALL p700_b_fill()
   DISPLAY ARRAY g_bmx TO s_bmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                                      
     BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY
   CALL s_showmsg()                                                                                                                 
                                                                                                                                    
END FUNCTION
 
FUNCTION p700_bp(p_ud)                                                                                                              
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)                                                              
                                                                                                                                    
                                                                                                                                    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_action_choice = " "                                                                                                        
                                                                                                                                    
   CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
   DISPLAY ARRAY g_bmx TO s_bmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                               
                                                                                                                                    
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
         IF l_ac = 0 THEN                                                                                                           
            LET l_ac = 1                                                                                                            
         END IF                                                                                                                     
         CALL p700_b_fill1()                                                                                                        
         CALL p700_bp1_refresh()
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION query                                                                                                              
         LET g_action_choice="query"                                                                                               
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION bmx_detail                                                                                                          
         LET g_action_choice="bmx_detail"                                                                                           
         LET l_ac = 1                                                                                                               
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION bmzbmy_detail                                                                                                          
         LET g_action_choice="bmzbmy_detail"                                                                                           
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION carry                                                                                                               
         LET g_action_choice="carry"                                                                                                
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION download                                                                                                            
         LET g_action_choice="download"                                                                                             
         EXIT DISPLAY
                                                                                                                                    
      ON ACTION qry_carry_history                                                                                                   
         LET g_action_choice="qry_carry_history"                                                                                    
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION help                                                                                                                
         LET g_action_choice="help"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION locale                                                                                                              
         CALL cl_dynamic_locale()                                                                                                   
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION exit                                                                                                                
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         LET g_action_choice="controlg"                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION accept
         LET g_action_choice="bmx_detail"                                                                                           
         LET l_ac = ARR_CURR()                                                                                                      
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION cancel                                                                                                              
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
                                                                                                                                    
      AFTER DISPLAY                                                                                                                 
         CONTINUE DISPLAY
                                                                                                                                    
      ON ACTION controls                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
                                                                                                                                    
   END DISPLAY                                                                                                                      
   CALL cl_set_act_visible("accept,cancel", TRUE)                                                                                   
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION p700_bp1(p_ud)                                                                                                             
   DEFINE   p_ud   LIKE type_file.chr1                                                                                              
                                                                                                                                    
   IF p_ud <> "G" THEN                                                                                                              
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   CALL cl_set_act_visible("cancel", FALSE)                                                                                         
   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                              
                     
#      BEFORE DISPLAY                                                                                                                
#         EXIT DISPLAY
                                                                                                            
      ON ACTION help                                                                                                                
         LET g_action_choice="help"                                                                                                 
         EXIT DISPLAY
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         LET g_action_choice="controlg"                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
      ON ACTION controls                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
                                                                                                                                    
   END DISPLAY         
 
   DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)                                                              
             
#      BEFORE DISPLAY                                                                                                                
#         EXIT DISPLAY
                                                                                                                       
      ON ACTION help                                                                                                                
         LET g_action_choice="help"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         LET g_action_choice="controlg"                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
      ON ACTION controls                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
                                                                                                                                    
   END DISPLAY                                                                                                             
   CALL cl_set_act_visible("cancel", FALSE)                                                                                         
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION p700_bp1_refresh()                                                                                                         
   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                              
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
             
   DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)                                                              
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
 
FUNCTION p700_download()                                                                                                            
   DEFINE l_i    LIKE type_file.num10                                                                                               
   DEFINE l_j    LIKE type_file.num10                                                                                               
                                                                                                                                    
   CALL g_bmx1.clear()                                                                                                              
   LET l_j = 1                                                                                                                      
   FOR l_i = 1 TO g_bmx.getLength()                                                                                                 
       IF g_bmx[l_i].sel = 'Y' THEN                                                                                                 
          LET g_bmx1[l_j].sel   = g_bmx[l_i].sel                                                                                    
          LET g_bmx1[l_j].bmx01 = g_bmx[l_i].bmx01                                                                                  
          LET l_j = l_j + 1                                                                                                         
       END IF                                                                                                                       
   END FOR    
   IF l_j = 1 THEN                                                                                                                  
      CALL cl_err('','aoo-096',0)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                      
   CALL s_abmi710_download(g_bmx1)                                                                                                      
                                                                                                                                    
END FUNCTION
# FUN-820027
