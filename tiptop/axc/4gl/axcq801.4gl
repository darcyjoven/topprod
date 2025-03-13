# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: axcq801.4gl
# Descriptions...: 移動加權平均成本異動明細查詢 
# Date & Author..: NO.FUN-BC0062 12/03/12 By lilingyu 
# Modify.........: NO:TQC-D30066 13/03/27 By lixh1 增加流水號欄位
# Modify.........: NO:FUN-D60091 13/06/21 By lixh1 增加年度/期別/單位等查詢條件

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    g_cfa01         LIKE cfa_file.cfa01,
    g_cfa01_t       LIKE cfa_file.cfa01,
    g_cfa_b         DYNAMIC ARRAY OF RECORD 
         cfa02      LIKE cfa_file.cfa02,
         cfa03      LIKE cfa_file.cfa03,
         cfa04      LIKE cfa_file.cfa04,
         cfa05      LIKE cfa_file.cfa05,
         cfa06      LIKE cfa_file.cfa06,
         cfa18      LIKE cfa_file.cfa18,
         cfa17      LIKE cfa_file.cfa17,
         cfa14      LIKE cfa_file.cfa14,
         cfa15      LIKE cfa_file.cfa15,
         cfa16      LIKE cfa_file.cfa16,
         cfa07      LIKE cfa_file.cfa07,
         cfa08      LIKE cfa_file.cfa08,
         cfa09      LIKE cfa_file.cfa09,
         cfa10      LIKE cfa_file.cfa10,
         cfa11      LIKE cfa_file.cfa11,
         cfa12      LIKE cfa_file.cfa12,
         cfa13      LIKE cfa_file.cfa13,
         cfalegal   LIKE cfa_file.cfalegal,
         cfa00      LIKE cfa_file.cfa00,    #TQC-D30066
         cfaud01    LIKE cfa_file.cfaud01,
         cfaud02    LIKE cfa_file.cfaud02,
         cfaud03    LIKE cfa_file.cfaud03,
         cfaud04    LIKE cfa_file.cfaud04,
         cfaud05    LIKE cfa_file.cfaud05,
         cfaud06    LIKE cfa_file.cfaud06,
         cfaud07    LIKE cfa_file.cfaud07,
         cfaud08    LIKE cfa_file.cfaud08,
         cfaud09    LIKE cfa_file.cfaud09,
         cfaud10    LIKE cfa_file.cfaud10,
         cfaud11    LIKE cfa_file.cfaud11,
         cfaud12    LIKE cfa_file.cfaud12,
         cfaud13    LIKE cfa_file.cfaud13,
         cfaud14    LIKE cfa_file.cfaud14,
         cfaud15    LIKE cfa_file.cfaud15
                    END RECORD,    
    g_cfa_b_t        RECORD  
         cfa02      LIKE cfa_file.cfa02,
         cfa03      LIKE cfa_file.cfa03,
         cfa04      LIKE cfa_file.cfa04,
         cfa05      LIKE cfa_file.cfa05,
         cfa06      LIKE cfa_file.cfa06,
         cfa18      LIKE cfa_file.cfa18,
         cfa17      LIKE cfa_file.cfa17,
         cfa14      LIKE cfa_file.cfa14,
         cfa15      LIKE cfa_file.cfa15,
         cfa16      LIKE cfa_file.cfa16,
         cfa07      LIKE cfa_file.cfa07,
         cfa08      LIKE cfa_file.cfa08,
         cfa09      LIKE cfa_file.cfa09,
         cfa10      LIKE cfa_file.cfa10,
         cfa11      LIKE cfa_file.cfa11,
         cfa12      LIKE cfa_file.cfa12,
         cfa13      LIKE cfa_file.cfa13,
         cfalegal   LIKE cfa_file.cfalegal,
         cfaud01    LIKE cfa_file.cfaud01,
         cfaud02    LIKE cfa_file.cfaud02,
         cfaud03    LIKE cfa_file.cfaud03,
         cfaud04    LIKE cfa_file.cfaud04,
         cfaud05    LIKE cfa_file.cfaud05,
         cfaud06    LIKE cfa_file.cfaud06,
         cfaud07    LIKE cfa_file.cfaud07,
         cfaud08    LIKE cfa_file.cfaud08,
         cfaud09    LIKE cfa_file.cfaud09,
         cfaud10    LIKE cfa_file.cfaud10,
         cfaud11    LIKE cfa_file.cfaud11,
         cfaud12    LIKE cfa_file.cfaud12,
         cfaud13    LIKE cfa_file.cfaud13,
         cfaud14    LIKE cfa_file.cfaud14,
         cfaud15    LIKE cfa_file.cfaud15          
                    END RECORD,
                    
    g_wc,g_wc2,g_sql      STRING,
    g_rec_b         LIKE type_file.num10,
    l_ac            LIKE type_file.num10
    
DEFINE g_forupd_sql          STRING                       
DEFINE g_cnt                 LIKE type_file.num10      
DEFINE g_curs_index          LIKE type_file.num10      
DEFINE g_row_count           LIKE type_file.num10      
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask              LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000        
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_yy                  LIKE type_file.num5    #FUN-D60091
DEFINE g_mm                  LIKE type_file.num5    #FUN-D60091
DEFINE g_bdate               LIKE type_file.dat     #FUN-D60091 
DEFINE g_edate               LIKE type_file.dat     #FUN-D60091
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5           
    OPTIONS                                        #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                #擷取中斷鍵, 由程式處理
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET p_row = 4 LET p_col = 25
   
   OPEN WINDOW q801_w AT p_row,p_col WITH FORM "axc/42f/axcq801"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_ui_init()

   CALL cl_set_comp_visible('cfaud01,cfaud02,cfaud03,cfaud04,cfaud05,cfaud06,cfaud07,
                             cfaud08,cfaud09,cfaud10,cfaud11,cfaud12,cfaud13,cfaud14,cfaud15',FALSE)
 
   CALL q801_menu()
 
   CLOSE WINDOW q801_w            
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q801_menu()
 
   WHILE TRUE
      CALL q801_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q801_q()
            END IF

         WHEN "help" 
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_cfa01 IS NOT NULL THEN
                  LET g_doc.column1 = "cfa01"
                  LET g_doc.value1 = g_cfa01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cfa_b),'','')
            END IF
      END CASE      
   END WHILE
END FUNCTION 

FUNCTION q801_q()
    DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    CLEAR FORM
    CALL g_cfa_b.clear()
    INITIALIZE g_cfa01 TO NULL 
    CALL cl_set_head_visible("","YES")               #FUN-D60091 
    CALL cl_set_act_visible("accept,cancel", TRUE)   #FUN-D60091
    CALL s_yp(g_today) RETURNING g_yy,g_mm           #FUN-D60091 
    DIALOG ATTRIBUTE(UNBUFFERED)   #FUN-D60091
       CONSTRUCT g_wc ON cfa01 FROM cfa01  
          
          BEFORE CONSTRUCT 
              CALL cl_qbe_init()
           
     #FUN-D60091 -----Begin-------
        # ON ACTION controlp
        #   IF INFIELD(cfa01) THEN 
        #      CALL cl_init_qry_var()
        #      LET g_qryparam.state = 'c'
        #      LET g_qryparam.form  = "q_ima"
        #      LET g_qryparam.default1 = g_cfa01
        #      CALL cl_create_qry() RETURNING g_qryparam.multiret
        #      DISPLAY g_qryparam.multiret TO cfa01
        #      NEXT FIELD cfa01
        #   END IF  
     #FUN-D60091 -----End---------
           
           AFTER FIELD cfa01 
             CALL GET_FLDBUF(cfa01) RETURNING g_cfa01
        END CONSTRUCT     #FUN-D60091

#FUN-D60091 ------Begin------
      # ON IDLE g_idle_seconds
      #     CALL cl_on_idle()
      #     CONTINUE CONSTRUCT
 
      #  ON ACTION about        
      #     CALL cl_about()      
      # 
      #  ON ACTION help         
      #     CALL cl_show_help()
      # 
      #  ON ACTION controlg   
      #     CALL cl_cmdask() 
     
      #  ON ACTION qbe_select
      #      CALL cl_qbe_select() 
      #      
      #  ON ACTION qbe_save
      #      CALL cl_qbe_save()                          
   #END CONSTRUCT     
 
 #  IF INT_FLAG THEN 
 #     LET INT_FLAG = 0 
 #     RETURN 
 #  END IF 
  
 #  LET g_wc = g_wc CLIPPED 
#FUN-D60091 ------End---------

#FUN-D60091 ----------Begin--------
    INPUT g_yy,g_mm FROM  yy,mm ATTRIBUTES (WITHOUT DEFAULTS=TRUE)
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
    END INPUT
#FUN-D60091 ----------End----------
 
    CONSTRUCT g_wc2 ON cfa02,cfa03,cfa04,cfa05,cfa06,    
                       cfa18,cfa17,cfa14,cfa15,cfa16,cfalegal    
         FROM s_cfa[1].cfa02,s_cfa[1].cfa03,s_cfa[1].cfa04,s_cfa[1].cfa05,s_cfa[1].cfa06,
              s_cfa[1].cfa18,s_cfa[1].cfa17,s_cfa[1].cfa14,s_cfa[1].cfa15,s_cfa[1].cfa16,
              s_cfa[1].cfalegal
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
    END CONSTRUCT    #FUN-D60091
                    
    ON ACTION controlp
    #FUN-D60091 -----Begin-----
       IF INFIELD(cfa01) THEN 
          CALL cl_init_qry_var()
          LET g_qryparam.state = 'c'
          LET g_qryparam.form  = "q_ima"
          LET g_qryparam.default1 = g_cfa01
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO cfa01
          NEXT FIELD cfa01
       END IF
    #FUN-D60091 -----End-------

       IF INFIELD(cfa14) THEN
          CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO cfa14
          NEXT FIELD cfa14
       END IF                     
       IF INFIELD(cfa17) THEN
          CALL cl_init_qry_var()
          LET g_qryparam.state='c'
          LET g_qryparam.form="q_gfe"            
          CALL cl_create_qry() RETURNING g_qryparam.multiret 
          DISPLAY g_qryparam.multiret TO cfa17
          NEXT FIELD cfa17
       END IF
          
      #FUN-D60091 ----Begin-----
       ON ACTION ACCEPT    #lixh1
          ACCEPT DIALOG

       ON ACTION cancel    #lixh1
          LET INT_FLAG=1
          EXIT DIALOG

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG       #lixh1
      #FUN-D60091 ----End-------

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
       #  CONTINUE CONSTRUCT
          CONTINUE DIALOG
 
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

  # END CONSTRUCT   #FUN-D60091 mark 
    END DIALOG      #FUN-D60091  
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
  #FUN-D60091 --------Begin-------
    CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate 
    IF cl_null(g_wc) THEN LET g_wc = " 1 =1 " END IF 
    LET g_wc = g_wc CLIPPED,"AND cfa18 BETWEEN '",g_bdate,"'","AND '",g_edate,"'"  
  #FUN-D60091 --------End---------
    IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE cfa01 FROM cfa_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cfa01"
    ELSE                              # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cfa01 FROM cfa_file ",
                   " WHERE ",g_wc CLIPPED, 
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY cfa01"
    END IF

   PREPARE q801_prepare FROM g_sql
   DECLARE q801_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR q801_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(UNIQUE cfa01) FROM cfa_file",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE cfa01) FROM cfa_file",
                " WHERE ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF

   PREPARE q801_precount FROM g_sql
   DECLARE q801_count CURSOR FOR q801_precount

   OPEN q801_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cfa01 TO NULL
   ELSE
      OPEN q801_count
      FETCH q801_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt2

      CALL q801_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
     
END FUNCTION
 
FUNCTION q801_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1         

   CASE p_flag
      WHEN 'N' FETCH NEXT     q801_cs INTO g_cfa01
      WHEN 'P' FETCH PREVIOUS q801_cs INTO g_cfa01
      WHEN 'F' FETCH FIRST    q801_cs INTO g_cfa01
      WHEN 'L' FETCH LAST     q801_cs INTO g_cfa01
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
                
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump q801_cs INTO g_cfa01
            LET g_no_ask = FALSE  
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cfa01,SQLCA.sqlcode,0)
      INITIALIZE g_cfa01 TO NULL              
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
      DISPLAY g_curs_index TO FORMONLY.cnt
   END IF

   CALL q801_show()

END FUNCTION

FUNCTION q801_show()
DEFINE l_ima02        LIKE ima_file.ima02
DEFINE l_ima021       LIKE ima_file.ima021
DEFINE l_cca11        LIKE cca_file.cca11
DEFINE l_cca12        LIKE cca_file.cca12
DEFINE l_ima25        LIKE ima_file.ima25   #FUN-D60091

   LET g_cfa01_t = g_cfa01               #保存單頭舊值
   LET l_ima02 = NULL 
   LET l_ima021= NULL 
   
   DISPLAY g_cfa01 TO cfa01
   
   SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file    #FUN-D60091 add ima25
    WHERE ima01 = g_cfa01
      AND imaacti = 'Y'
   DISPLAY l_ima02,l_ima021,l_ima25 TO ima02,ima021,ima25    #FUN-D60091 add ima25
   
#FUN-D60091 ---------Begin---------
   IF g_mm = 1 THEN
      SELECT cfa10,cfa11 INTO l_cca11,l_cca12 FROM
                    (SELECT cfa_file.* FROM cfa_file
                      WHERE cfa01 = g_cfa01
                        AND YEAR(cfa18) = g_yy - 1
                        AND MONTH(cfa18)= 12
                      ORDER BY cfa02 desc,cfa18 desc)
               WHERE rownum = 1
   ELSE
      SELECT cfa10,cfa11 INTO l_cca11,l_cca12 FROM 
                    (SELECT cfa_file.* FROM cfa_file
                      WHERE cfa01 = g_cfa01
                        AND YEAR(cfa18) = g_yy 
                        AND MONTH(cfa18)= g_mm - 1
                      ORDER BY cfa02 desc,cfa18 desc)
               WHERE rownum = 1
   END IF
   IF SQLCA.sqlcode = 100 THEN
      IF g_mm = 1 THEN   
         SELECT cca11,cca12 INTO l_cca11,l_cca12 FROM cca_file
          WHERE cca01 = g_cfa01
            AND cca02 = g_yy-1
            AND cca03 = 12
            AND cca06 = '6'
            AND cca07 = ' '
      ELSE
         SELECT cca11,cca12 INTO l_cca11,l_cca12 FROM cca_file
          WHERE cca01 = g_cfa01
            AND cca02 = g_yy
            AND cca03 = g_mm-1
            AND cca06 = '6'
            AND cca07 = ' '
      END IF
   END IF
#FUN-D60091 ---------End-----------
#FUN-D60091 ----Begin-----
   #  SELECT cca11,cca12 INTO l_cca11,l_cca12 FROM cca_file 
   #   WHERE cca01 = g_cfa01
   #     AND rownum <= 1 
#FUN-D60091 ----End-------
   IF cl_null(l_cca11) THEN LET l_cca11 = 0 END IF
   IF cl_null(l_cca12) THEN LET l_cca12 = 0 END IF
   DISPLAY l_cca11,l_cca12 TO cca11,cca12
      
   
   IF cl_null(g_wc2) THEN 
      LET g_wc2 = " 1=1"
   END IF   
   CALL q801_b_fill(g_wc2)               #單身

   CALL cl_show_fld_cont()                
END FUNCTION

 
FUNCTION q801_b_fill(p_wc2)             
DEFINE p_wc2           STRING       

    LET g_sql ="SELECT cfa02,cfa03,cfa04,cfa05,cfa06,cfa18,cfa17,cfa14,cfa15,cfa16,",
            #  "       cfa07,cfa08,cfa09,cfa10,cfa11,cfa12,cfa13,cfalegal,",          #TQC-D30066  mark
               "       cfa07,cfa08,cfa09,cfa10,cfa11,cfa12,cfa13,cfalegal,cfa00,",    #TQC-D30066 
               "       '','','','','',  '','','','','',   '','','','',''",
               "  FROM cfa_file ", 
               " WHERE cfa01 = '",g_cfa01,"'",
               "   AND ", p_wc2 CLIPPED,
               "   AND cfa18 BETWEEN '",g_bdate,"' AND '",g_edate,"'",   #FUN-D60091 add 
               " ORDER BY cfa02"
   
   PREPARE q801_pb FROM g_sql
   DECLARE cfa_curs CURSOR FOR q801_pb               
   CALL g_cfa_b.clear()
 
   LET g_cnt = 1
   FOREACH cfa_curs INTO g_cfa_b[g_cnt].*   
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
      END IF      
   END FOREACH
   
   CALL g_cfa_b.deleteElement(g_cnt)    
   LET g_rec_b = g_cnt-1    
   DISPLAY g_rec_b TO FORMONLY.cnt3
   LET g_cnt = 0   
 
END FUNCTION
 
FUNCTION q801_bp(p_ud)	
DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN RETURN END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cfa_b TO s_cfa.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()

      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                                                                                                             
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first
         CALL q801_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION previous
         CALL q801_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL q801_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION next
         CALL q801_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL q801_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
         
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-BC0062
                          
