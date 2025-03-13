# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_icdqry.sql    
# Descriptions...: ICD單據刻號/BIN查詢作業
# Date & Author..: 07/11/29 By lilingyu   #FUN-7B0015 
# Modify.........: No.FUN-830124 08/03/28 By lilingyu s_icdqry.per未過單,未修改原程式
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No.MOD-890023 08/09/02 By chenyu icd版功能修改
# Modify.........: No.FUN-B30192 11/05/09 By shenyang       改icb05為imaicd14   
# Modify.........: No.FUN-B90012 11/09/28 By fengrui 修改為跨出處理 
# Modify.........: No.FUN-BA0051 11/10/11 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BC0036 11/12/29 By jason 新增刻號/BIN調整單功能

DATABASE ds    #FUN-850069
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_idd10        LIKE idd_file.idd10,      #單據編號
    g_idd11        LIKE idd_file.idd11,      #項次
    g_idd01        LIKE idd_file.idd01,      #料件編號
    g_idd02        LIKE idd_file.idd02,      #品名
    g_idd03        LIKE idd_file.idd03,      #倉庫 
    g_idd04        LIKE idd_file.idd04,      #儲位
    g_idd07        LIKE idd_file.idd07,      #批號
    g_idd13s       LIKE idd_file.idd13,      #單位
    g_ima02        LIKE ima_file.ima02,      #異動數量總計  
#   g_icb05        LIKE icb_file.icb05,      #GROSS DIE   #FUN-B30192
    g_imaicd14     LIKE imaicd_file.imaicd14,  #FUN-B30192 
    g_idd          DYNAMIC ARRAY OF RECORD   
        idd05      LIKE idd_file.idd05,      #刻號
        idd06      LIKE idd_file.idd06,      #BIN
        idd22      LIKE idd_file.idd22,      #PASS BIN
        idd13      LIKE idd_file.idd13,      #異動數量
        idd15      LIKE idd_file.idd15,      #母體
        idd16      LIKE idd_file.idd16,      #母批 
        idd18      LIKE idd_file.idd18,      #DIE數
        idd17      LIKE idd_file.idd17,      #DATECODE
        idd19      LIKE idd_file.idd19,      #YIELD
        idd20      LIKE idd_file.idd20,      #TEST
        idd21      LIKE idd_file.idd21,      #DEDUCT
        idd25      LIKE idd_file.idd25       #備注
                                END RECORD,
    g_argv1        LIKE type_file.num5,     #異動別                  
    g_argv2        LIKE idd_file.idd10,     #單據編號
    g_argv3        LIKE idd_file.idd11,     #項次(查詢整張單據的數據) 
    g_argv4        LIKE type_file.chr1,     #過賬否[YN]              
    g_argv5        LIKE ima_file.ima01,     #料件編號       
    g_wc           STRING,
    g_sql          STRING,  
    g_rec_b        LIKE type_file.num5,          
    l_ac           LIKE type_file.num5         
 
DEFINE p_row,p_col    LIKE type_file.num5 
DEFINE g_forupd_sql   STRING                #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt          LIKE type_file.num10   
DEFINE g_i            LIKE type_file.num5   #count/index for any purpose
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE g_no_ask       LIKE type_file.num5 
#DEFINE g_msg          LIKE type_file.chr1000 #NO.FUN-830124
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_plant_multi  LIKE type_file.chr20    #FUN-B90012--add--
DEFINE g_idbch_flag   LIKE type_file.num5     #是否為刻號/BIN調整單 FUN-BC0036

#FUN-B90012--add--strat--
FUNCTION s_icdqry_plant(p_plant)
DEFINE p_plant  LIKE type_file.chr20
   LET g_plant_multi = p_plant
END FUNCTION 
#FUN-B90012--add---end---
 
FUNCTION s_icdqry(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)
   DEFINE l_n             LIKE type_file.num10,
          l_sql           STRING,                  #FUN-B90012--add--
          p_argv1         LIKE type_file.num5,                           
          p_argv2         LIKE idd_file.idd10,      
          p_argv3         LIKE idd_file.idd11,        
          p_argv4         LIKE type_file.chr1,                    
          p_argv5         LIKE ima_file.ima01            
   #DEFINE l_imaicd08      LIKE imaicd_file.imaicd08   #FUN-BA0051 mark  
   DEFINE l_plant_new     LIKE type_file.chr20      #FUB-B90012--add--

   #FUN-B90012--add--strat--
   IF cl_null(g_plant_multi) THEN 
      LET g_plant_multi = g_plant 
   END IF 
   LET l_plant_new = g_plant_multi
   #FUN-B90012--add---end---
   
  #IF NOT cl_null(p_argv3) AND cl_null(p_argv5) AND p_argv4 = 'N' THEN  #No.MOD-890023 mark
   IF NOT cl_null(p_argv3) AND NOT cl_null(p_argv5) AND p_argv4 = 'N' THEN  #No.MOD-890023 add
      #FUN-BA0051 --START mark--
      #LET  l_imaicd08 = NULL
      # 
      ##FUN-B90012--mark--strat--
      ##SELECT imaicd08 INTO l_imaicd08 FROM ima_file,imaicd_file
      ##       WHERE ima01 = p_argv5 
      ##         AND ima01=imaicd00
      ##FUN-B90012--mark---end---
      # 
      ##FUN-B90012--add--strat--
      #LET l_sql = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'ima_file'),",",
      #                                    cl_get_target_table(l_plant_new,'imaicd_file'),
      #            " WHERE ima01 = '",p_argv5,"' ",
      #            "   AND ima01 = imaicd00 "
      #
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
      #PREPARE icdqry_imaicd08 FROM l_sql
      #EXECUTE icdqry_imaicd08 INTO l_imaicd08
      ##FUN-B90012--add---end---
      #IF l_imaicd08 = 'N' OR cl_null(l_imaicd08) THEN
      #FUN-BA0051 --END mark--
      IF NOT s_icdbin_multi(p_argv5,l_plant_new) THEN   #FUN-BA0051 
         #CALL cl_err('','sub-184',1)                   #FUN-BA0051 mark
         RETURN
      END IF
   END IF
  
   IF cl_null(p_argv1) OR cl_null(p_argv2) OR 
      cl_null(p_argv4) THEN
      RETURN
   END IF
 
   #NO.FUN-7B0015  --Begin--
   IF NOT (p_argv1 = 1 OR p_argv1 = 0 OR p_argv1 = -1 OR p_argv1=2) THEN
      RETURN
   END IF
   #NO.FUN-7B0015  --End--
 
   IF p_argv4 NOT MATCHES '[YN]' THEN
      RETURN
   END IF
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW s_icdqry_w AT p_row,p_col WITH FORM "sub/42f/s_icdqry" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("s_icdqry") 
 
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_argv3 = p_argv3
   LET g_argv4 = p_argv4

   #FUN-BC0036 --START--
   IF g_prog[1,7] = 'aict324' THEN
      LET g_idbch_flag = TRUE
   ELSE
      LET g_idbch_flag = FALSE
   END IF
   #FUN-BC0036 --END--
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv4) THEN
      CALL s_icdqry_q()
 
      DISPLAY ARRAY g_idd TO s_idd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         ON ACTION first
            CALL s_icdqry_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
 
         ON ACTION previous
            CALL s_icdqry_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
 
         ON ACTION jump
            CALL s_icdqry_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
 
         ON ACTION next
            CALL s_icdqry_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
 
         ON ACTION last
            CALL s_icdqry_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION CONTROLG
             CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION help          
            CALL cl_show_help()
 
         ON ACTION about     
            CALL cl_about()   
 
         ON ACTION cancel
            EXIT DISPLAY
      END DISPLAY 
   END IF
 
   CLOSE WINDOW s_icdqry_w       
   LET INT_FLAG = 0  
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION s_icdqry_curs()
DEFINE l_plant_new     LIKE type_file.chr20      #FUB-B90012--add--
 
   CLEAR FORM       
   CALL g_idd.clear()
   LET  g_sql = NULL

   #FUN-B90012--add--strat--
   IF cl_null(g_plant_multi) THEN 
      LET g_plant_multi = g_plant 
   END IF 
   LET l_plant_new = g_plant_multi
   #FUN-B90012--add---end---
 
   IF (g_argv1 = 1 OR g_argv1 = 0) AND g_argv4 = 'N' THEN 
      LET g_wc = "ida07 = '",g_argv2 CLIPPED,"' "  
         
      IF cl_null(g_argv3) THEN
         #LET g_wc = g_wc CLIPPED," AND imaicd08 = 'Y' "                     #FUN-BA0051 mark
         LET g_wc = g_wc CLIPPED," AND (imaicd08 = 'Y' OR imaicd09 = 'Y')"   #FUN-BA0051
      END IF   
                                                                             
      IF NOT cl_null(g_argv3) THEN                                 
         LET g_wc = g_wc CLIPPED," AND ida08 = '",g_argv3 CLIPPED,"' "     
      END IF   
                                                                       
      LET g_sql = "SELECT ida01,ida02,ida03,ida04, ",   
                  "       ida13,ida07,ida08,ima02, ",         
                  "       SUM(ida10) ",                                    
                  "  FROM ",cl_get_target_table(l_plant_new,'ida_file'),",",   #FUN-B90012
                            cl_get_target_table(l_plant_new,'ima_file'),",",   #FUN-B90012
                            cl_get_target_table(l_plant_new,'imaicd_file'),    #FUN-B90012                       
                  " WHERE ida01 = ima01 ",
                  "   AND ima01 = imaicd00 ",
                  "   AND ",g_wc CLIPPED,                   
                  " GROUP BY ida01,ida02,ida03,ida04,", 
                  "          ida07,ida08,ida13,ima02 ",       
                  " ORDER BY ida07,ida08 "
   END IF
   
   IF (g_argv1 = -1 OR g_argv1 = 2) AND g_argv4 = 'N' THEN 
      LET g_wc = "idb07 = '",g_argv2 CLIPPED,"' "  
                            
      IF cl_null(g_argv3) THEN                                                  
         #LET g_wc = g_wc CLIPPED," AND imaicd08 = 'Y' "                      #FUN-BA0051 mark
         LET g_wc = g_wc CLIPPED," AND (imaicd08 = 'Y' OR imaicd09 = 'Y') "   #FUN-BA0051          
      END IF    
                                                                            
      IF NOT cl_null(g_argv3) THEN                                 
         LET g_wc = g_wc CLIPPED," AND idb08 = '",g_argv3 CLIPPED,"' "    
      END IF    
                                                                      
      LET g_sql = "SELECT idb01,idb02,idb03,idb04, ",  
                  "       idb12,idb07,idb08,ima02, ", 
                  "       SUM(idb11) ",       
                  "  FROM ",cl_get_target_table(l_plant_new,'idb_file'),",",   #FUN-B90012
                            cl_get_target_table(l_plant_new,'ima_file'),",",   #FUN-B90012
                            cl_get_target_table(l_plant_new,'imaicd_file'),    #FUN-B90012                               
                  " WHERE idb01 = ima01 AND ima01 = imaicd00",
                  "    AND ",g_wc CLIPPED,       
                  " GROUP BY idb01,idb02,idb03,idb04,", 
                  "          idb07,idb08,idb12,ima02 ",
                  " ORDER BY idb07,idb08 "
   END IF
   
   IF g_argv4 = 'Y' THEN 
      LET g_wc = "idd10 = '",g_argv2 CLIPPED,"' "
      
      IF NOT cl_null(g_argv3) THEN 
         LET g_wc = g_wc CLIPPED," AND idd11 = '",g_argv3 CLIPPED,"' "
      END IF
      #FUN-BC0036 --START--
      IF g_idbch_flag THEN
         CASE g_argv1
            WHEN 1
               LET g_wc = g_wc CLIPPED," AND idd12 = '1' "
            WHEN -1
               LET g_wc = g_wc CLIPPED," AND idd12 = '-1' "
         END CASE  
      END IF 
      #FUN-BC0036 --END--
     
      
      LET g_sql = "SELECT idd01,idd02,idd03,idd04, ",
                  "       idd07,idd10,idd11,ima02, ",
                  "       SUM(idd13) ",
                  "  FROM ",cl_get_target_table(l_plant_new,'idd_file'),",",   #FUN-B90012
                            cl_get_target_table(l_plant_new,'ima_file'),",",   #FUN-B90012
                            cl_get_target_table(l_plant_new,'imaicd_file'),    #FUN-B90012  
                  " WHERE idd01 = ima01 AND ima01=imaicd00",
                  "   AND ",g_wc CLIPPED,
                  " GROUP BY idd01,idd02,idd03,idd04,",
                  "          idd07,idd10,idd11,ima02 ",
                  " ORDER BY idd10,idd11 "
   END IF
   #FUN-B90012--add--start--
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql
   #FUN-B90012--add---end---
   PREPARE s_icdqry_prepare FROM g_sql
   DECLARE s_icdqry_b_curs         
      SCROLL CURSOR WITH HOLD FOR s_icdqry_prepare
 
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION i08_count()                                                           
DEFINE l_idd   DYNAMIC ARRAY of RECORD                    
               idd01  LIKE idd_file.idd01,                     
               idd02  LIKE idd_file.idd02,                     
               idd03  LIKE idd_file.idd03                     
                            END RECORD                                                   
DEFINE li_cnt     LIKE type_file.num10                                                      
DEFINE li_rec_b   LIKE type_file.num10                                                      
                                                                                
   PREPARE i08_precount FROM g_sql                                             
   DECLARE i08_count CURSOR FOR i08_precount                                  
   LET li_cnt=1                                                                 
   LET li_rec_b=0                                                               
   FOREACH i08_count INTO l_idd[li_cnt].*                                  
       LET li_rec_b = li_rec_b + 1   
                                                  
       IF SQLCA.sqlcode THEN                                                    
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                               
          LET li_rec_b = li_rec_b - 1                                           
          EXIT FOREACH                                                          
       END IF  
         
       LET li_cnt = li_cnt + 1                                                  
    END FOREACH                                                                 
    LET g_row_count = li_rec_b                                                  
END FUNCTION        
 
# Private Func...: TRUE
 
FUNCTION s_icdqry_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
 
   MESSAGE ""
   CLEAR FORM
   CALL g_idd.clear()
 
   CALL s_icdqry_curs()       
   OPEN s_icdqry_b_curs    
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   ELSE
      CALL i08_count()
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL s_icdqry_fetch('F')      
   END IF
 
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION s_icdqry_fetch(p_flag)
DEFINE
    p_flag        LIKE type_file.chr1,       
    l_msg         LIKE type_file.chr50 
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT    s_icdqry_b_curs INTO g_idd01,g_idd02,
                                                    g_idd03,g_idd04,
                                                    g_idd07,g_idd10,
                                                    g_idd11,
                                                    g_ima02,g_idd13s 
        WHEN 'P' FETCH PREVIOUS s_icdqry_b_curs INTO g_idd01,g_idd02,    
                                                    g_idd03,g_idd04,    
                                                    g_idd07,g_idd10,    
                                                    g_idd11,   
                                                    g_ima02,g_idd13s 
        WHEN 'F' FETCH FIRST   s_icdqry_b_curs INTO g_idd01,g_idd02,    
                                                    g_idd03,g_idd04,    
                                                    g_idd07,g_idd10,    
                                                    g_idd11,  
                                                    g_ima02,g_idd13s 
        WHEN 'L' FETCH LAST    s_icdqry_b_curs INTO g_idd01,g_idd02,    
                                                    g_idd03,g_idd04,    
                                                    g_idd07,g_idd10,    
                                                    g_idd11,  
                                                    g_ima02,g_idd13s 
        WHEN '/' 
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            
            FETCH ABSOLUTE g_jump s_icdqry_b_curs INTO g_idd01,g_idd02,
                                                       g_idd03,g_idd04,
                                                       g_idd07,g_idd10, 
                                                       g_idd11, 
                                                       g_ima02,g_idd13s 
                                                       
            LET g_no_ask = FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
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
 
    CALL s_icdqry_show()
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION s_icdqry_show()
  
    DISPLAY g_idd01  TO idd01 
    DISPLAY g_idd02  TO idd02
    DISPLAY g_idd03  TO idd03  
    DISPLAY g_idd04  TO idd04 
    DISPLAY g_idd07  TO idd07 
    DISPLAY g_idd10  TO idd10
    DISPLAY g_idd11  TO idd11
    DISPLAY g_ima02  TO ima02    
    DISPLAY g_idd13s TO idd13s 
 #FUN-B30192--begin
  # LET g_icb05 = NULL
  # SELECT icb05 INTO g_icb05 FROM icb_file 
  #       WHERE icb01 = g_idd01
  # DISPLAY g_icb05 TO icb05  
    LET g_imaicd14 = NULL
    CALL s_icdfun_imaicd14(g_idd01)   RETURNING g_imaicd14
    DISPLAY g_imaicd14 TO icb05 
 #FUN-B30192---end    
    CALL s_icdqry_b_fill(g_wc)        
    CALL cl_show_fld_cont()   
 
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION s_icdqry_b_fill(p_wc)         
DEFINE
        l_sql  STRING,
        l_i    LIKE type_file.num5,
        l_cnt  LIKE type_file.num10,
        p_wc   STRING ,
        l_plant_new    LIKE type_file.chr20      #FUB-B90012--add-- 
 
    LET l_sql = NULL
    #FUN-B90012--add--strat--
    IF cl_null(g_plant_multi) THEN 
       LET g_plant_multi = g_plant 
    END IF 
    LET l_plant_new = g_plant_multi
    #FUN-B90012--add---end---
    
    IF (g_argv1 = 0 OR g_argv1 = '1') AND g_argv4 = 'N' THEN
       LET l_sql = "SELECT ida05,ida06,ida21,ida10, ",
                   "       ida14,ida15,ida17,ida16, ",
                   "       ida18,ida19,ida20,ida29 ",
                   "  FROM ",cl_get_target_table(l_plant_new,'ida_file'),",",   #FUN-B90012
                             cl_get_target_table(l_plant_new,'ima_file'),",",   #FUN-B90012
                             cl_get_target_table(l_plant_new,'imaicd_file'),    #FUN-B90012
                   " WHERE ida01 = ima01 AND (imaicd08 = 'Y' OR imaicd09 = 'Y' )", #FUN-BA0051 add OR imaicd09 = 'Y' 
                   "   AND ima01 = imaicd00",  
                   "   AND ida01 = '",g_idd01 CLIPPED,"' ",
                   "   AND ida02 = '",g_idd02 CLIPPED,"' ",
                   "   AND ida13 = '",g_idd07 CLIPPED,"' ",
                   "   AND ida07 = '",g_idd10 CLIPPED,"' ",
                   "   AND ida08 = '",g_idd11 CLIPPED,"' "
 
       IF NOT cl_null(g_idd03) THEN
          LET l_sql = l_sql CLIPPED,
                      " AND ida03 = '",g_idd03 CLIPPED,"' "
       ELSE
          LET l_sql = l_sql CLIPPED, 
                      " AND ida03 = ' ' "
       END IF
       IF NOT cl_null(g_idd04) THEN                                 
          LET l_sql = l_sql CLIPPED,                                            
                      " AND ida04 = '",g_idd04 CLIPPED,"' "            
       ELSE                                                                     
          LET l_sql = l_sql CLIPPED,                                            
                      " AND ida04 = ' ' "                                
       END IF
       LET l_sql = l_sql CLIPPED," ORDER BY ida05,ida06 " 
 
    END IF
    
   #IF (g_argv1 = -1) AND g_argv4 = 'N' THEN   #No.MOD-890023 mark
    IF (g_argv1 = -1 OR g_argv1 = 2) AND g_argv4 = 'N' THEN   #No.MOD-890023 add
       #FUN-BC0036 --START--
       IF g_idbch_flag THEN
          LET l_sql = "SELECT idb26,idb27"
       ELSE 
          LET l_sql = "SELECT idb05,idb06"
       END IF 
       #FUN-BC0036 --END--
       #LET l_sql = "SELECT idb05,idb06,idb20,idb11, ",   #FUN-BC0036 mark
       LET l_sql = l_sql, ",idb20,idb11, ",               #FUN-BC0036 
                   "       idb13,idb14,idb16,idb15, ",
                   "       idb17,idb18,idb19,idb25 ",
                   "  FROM ",cl_get_target_table(l_plant_new,'idb_file'),",",   #FUN-B90012
                             cl_get_target_table(l_plant_new,'ima_file'),",",   #FUN-B90012
                             cl_get_target_table(l_plant_new,'imaicd_file'),    #FUN-B90012
                   " WHERE idb01 = ima01 AND (imaicd08 = 'Y' OR imaicd09 = 'Y') ",  #FUN-BA0051 add OR imaicd09 = 'Y' 
                   "   AND ima01 = imaicd00",
                   "   AND idb01 = '",g_idd01 CLIPPED,"' ",
                   "   AND idb02 = '",g_idd02 CLIPPED,"' ",
                   "   AND idb12 = '",g_idd07 CLIPPED,"' ",
                   "   AND idb07 = '",g_idd10 CLIPPED,"' ",
                   "   AND idb08 = '",g_idd11 CLIPPED,"' "
 
       IF NOT cl_null(g_idd03) THEN 
          LET l_sql = l_sql CLIPPED,          
                      " AND idb03 = '",g_idd03 CLIPPED,"' "  
       ELSE                                                                     
          LET l_sql = l_sql CLIPPED,                                 
                      " AND idb03 = ' ' "                    
       END IF                                                      
       IF NOT cl_null(g_idd04) THEN                     
          LET l_sql = l_sql CLIPPED,                             
                      " AND idb04 = '",g_idd04 CLIPPED,"' "  
       ELSE                                                          
          LET l_sql = l_sql CLIPPED,                                
                      " AND idb04 = ' ' "                   
       END IF                       
       LET l_sql = l_sql CLIPPED," ORDER BY idb05,idb06 " 
    END IF
 
    IF g_argv4 = 'Y' THEN
       LET l_sql = "SELECT idd05,idd06,idd22,idd13, ",
                   "       idd15,idd16,idd18,idd17, ",
                   "       idd19,idd20,idd21,idd25 ",
                   "  FROM ",cl_get_target_table(l_plant_new,'idd_file'),",",   #FUN-B90012
                             cl_get_target_table(l_plant_new,'ima_file'),       #FUN-B90012
                   "  WHERE idd01 = ima01  ",
                   "   AND idd01 = '",g_idd01 CLIPPED,"' ",
                   "   AND idd02 = '",g_idd02 CLIPPED,"' ",
                   "   AND idd07 = '",g_idd07 CLIPPED,"' ",
                   "   AND idd10 = '",g_idd10 CLIPPED,"' ",
                   "   AND idd11 = '",g_idd11 CLIPPED,"' "
 
       IF NOT cl_null(g_idd03) THEN                                   
          LET l_sql = l_sql CLIPPED,                                            
                      " AND idd03 = '",g_idd03 CLIPPED,"' "            
       ELSE                                                                     
          LET l_sql = l_sql CLIPPED,                                            
                      " AND idd03 = ' ' "                                
       END IF                                                                   
       IF NOT cl_null(g_idd04) THEN                                   
          LET l_sql = l_sql CLIPPED,                                            
                      " AND idd04 = '",g_idd04 CLIPPED,"' "            
       ELSE                                                                     
          LET l_sql = l_sql CLIPPED,                                            
                      " AND idd04 = ' ' "                                
       END IF                       
       #FUN-BC0036 --START--
       IF g_idbch_flag THEN         
          CASE g_argv1 
             WHEN 1
                LET l_sql = l_sql CLIPPED, " AND idd12 = '1'  "
             WHEN -1  
                LET l_sql = l_sql CLIPPED, " AND idd12 = '-1'  "
          END CASE                           
       END IF       
       #FUN-BC0036 --END--
       LET l_sql = l_sql CLIPPED," ORDER BY idd05,idd06 " 
    END IF

    #FUN-B90012--add--start--
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
    #FUN-B90012--add---end--- 
    PREPARE s_icdqry_prepare2 FROM l_sql 
    DECLARE idd_curs2 CURSOR FOR s_icdqry_prepare2
    CALL g_idd.clear()
    LET l_cnt = 1
 
    FOREACH idd_curs2 INTO g_idd[l_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        
        LET l_cnt = l_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_idd.deleteElement(l_cnt)
    LET g_rec_b=l_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET l_cnt = 0
 
END FUNCTION
