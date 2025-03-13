# Prog. Version..: '5.30.10-13.11.15(00002)'     #
#
# Pattern name...: axct005.4gl
# Descriptions...: 庫存成本月統計資料維護作業
# Date & Author..: No.FUN-D70054 2013/08/02 By lixh1
# Modify.........: No.TQC-D90016 2013/09/17 By lixh1 測試bug修正


IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cca        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
          cca01        LIKE cca_file.cca01,
          ima02        LIKE ima_file.ima02,
          ima021       LIKE ima_file.ima021,
          ima25        LIKE ima_file.ima25,
          cca02        LIKE cca_file.cca02,
          cca03        LIKE cca_file.cca03,
          cca06        LIKE cca_file.cca06,
          cca07        LIKE cca_file.cca07,
          cca11        LIKE cca_file.cca11,
          cca12a       LIKE cca_file.cca12a,
          cca12b       LIKE cca_file.cca12b,
          cca12c       LIKE cca_file.cca12c,
          cca12d       LIKE cca_file.cca12d,
          cca12e       LIKE cca_file.cca12e,
          cca12f       LIKE cca_file.cca12f,
          cca12g       LIKE cca_file.cca12g,
          cca12h       LIKE cca_file.cca12h,
          cca12        LIKE cca_file.cca12,
          cca23a       LIKE cca_file.cca23a,
          cca23b       LIKE cca_file.cca23b,
          cca23c       LIKE cca_file.cca23c,
          cca23d       LIKE cca_file.cca23d,
          cca23e       LIKE cca_file.cca23e,
          cca23f       LIKE cca_file.cca23f,
          cca23g       LIKE cca_file.cca23g,
          cca23h       LIKE cca_file.cca23h,
          cca23        LIKE cca_file.cca23,
          ccaud01      LIKE cca_file.ccaud01,
          ccaud02      LIKE cca_file.ccaud02,
          ccaud03      LIKE cca_file.ccaud03,
          ccaud04      LIKE cca_file.ccaud04,
          ccaud05      LIKE cca_file.ccaud05,
          ccaud06      LIKE cca_file.ccaud06,
          ccaud07      LIKE cca_file.ccaud07,
          ccaud08      LIKE cca_file.ccaud08,
          ccaud09      LIKE cca_file.ccaud09,
          ccaud10      LIKE cca_file.ccaud10,
          ccaud11      LIKE cca_file.ccaud11,
          ccaud12      LIKE cca_file.ccaud12,
          ccaud13      LIKE cca_file.ccaud13,
          ccaud14      LIKE cca_file.ccaud14,
          ccaud15      LIKE cca_file.ccaud15                        
                    END RECORD, 
       g_cca_t      RECORD    
          cca01        LIKE cca_file.cca01,
          ima02        LIKE ima_file.ima02,
          ima021       LIKE ima_file.ima021,
          ima25        LIKE ima_file.ima25,
          cca02        LIKE cca_file.cca02,
          cca03        LIKE cca_file.cca03,
          cca06        LIKE cca_file.cca06,
          cca07        LIKE cca_file.cca07,
          cca11        LIKE cca_file.cca11,
          cca12a       LIKE cca_file.cca12a,
          cca12b       LIKE cca_file.cca12b,
          cca12c       LIKE cca_file.cca12c,
          cca12d       LIKE cca_file.cca12d,
          cca12e       LIKE cca_file.cca12e,
          cca12f       LIKE cca_file.cca12f,
          cca12g       LIKE cca_file.cca12g,
          cca12h       LIKE cca_file.cca12h,
          cca12        LIKE cca_file.cca12,
          cca23a       LIKE cca_file.cca23a,
          cca23b       LIKE cca_file.cca23b,
          cca23c       LIKE cca_file.cca23c,
          cca23d       LIKE cca_file.cca23d,
          cca23e       LIKE cca_file.cca23e,
          cca23f       LIKE cca_file.cca23f,
          cca23g       LIKE cca_file.cca23g,
          cca23h       LIKE cca_file.cca23h,
          cca23        LIKE cca_file.cca23,
          ccaud01      LIKE cca_file.ccaud01,
          ccaud02      LIKE cca_file.ccaud02,
          ccaud03      LIKE cca_file.ccaud03,
          ccaud04      LIKE cca_file.ccaud04,
          ccaud05      LIKE cca_file.ccaud05,
          ccaud06      LIKE cca_file.ccaud06,
          ccaud07      LIKE cca_file.ccaud07,
          ccaud08      LIKE cca_file.ccaud08,
          ccaud09      LIKE cca_file.ccaud09,
          ccaud10      LIKE cca_file.ccaud10,
          ccaud11      LIKE cca_file.ccaud11,
          ccaud12      LIKE cca_file.ccaud12,
          ccaud13      LIKE cca_file.ccaud13,
          ccaud14      LIKE cca_file.ccaud14,
          ccaud15      LIKE cca_file.ccaud15
                    END RECORD 
DEFINE   g_wc,g_sql      STRING
DEFINE   g_forupd_sql    STRING 
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_n             LIKE type_file.num10
DEFINE   g_msg           LIKE ze_file.ze03       
DEFINE   g_before_input_done LIKE type_file.num5 
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_jump         LIKE type_file.num10 
DEFINE   mi_no_ask      LIKE type_file.num5 
DEFINE   g_str          STRING             
DEFINE   l_table        STRING            
DEFINE   l_ac,l_ac_t    LIKE type_file.num10
DEFINE   g_rec_b        LIKE type_file.num10

DEFINE ms_codeset      STRING            
DEFINE ms_locale       STRING            
DEFINE g_query_prog    LIKE gcy_file.gcy01    #查詢單ID  
DEFINE g_query_cust    LIKE gcy_file.gcy05    #客製否   
DEFINE xls_name        STRING                
DEFINE  g_hidden        DYNAMIC ARRAY OF LIKE type_file.chr1,     
        g_ifchar        DYNAMIC ARRAY OF LIKE type_file.chr1,     
        g_mask          DYNAMIC ARRAY OF LIKE type_file.chr1,     
        g_quote         STRING    
DEFINE  tsconv_cmd      STRING    

DEFINE  l_channel       base.Channel,
        l_str           STRING,
        l_cmd           STRING,
        l_field_name    STRING,
        cnt_table       LIKE type_file.num10    
DEFINE  l_win_name      STRING,              
        cnt_header      LIKE type_file.num10
DEFINE  g_gab07         LIKE gab_file.gab07     
DEFINE  g_sort          RECORD
         column         LIKE type_file.num5,    #sortColumn  
         type           STRING,                 #sortType:排序方式:asc/desc
         name           STRING                  #欄位代號
                        END RECORD
DEFINE  g_sheet          STRING 
DEFINE g_cca_1   RECORD LIKE cca_file.*
DEFINE g_disk    LIKE type_file.chr1   #從C:TIPTOP 上傳?(INPUT條件)
DEFINE g_choice  LIKE type_file.chr1   #文件形式:'1' TXT;'2' EXCEL
DEFINE g_file    STRING                #文件名稱
DEFINE g_chr     LIKE type_file.chr1
DEFINE lr_data   DYNAMIC ARRAY OF RECORD
       cca01        LIKE cca_file.cca01,
       cca02        LIKE cca_file.cca02,
       cca03        LIKE cca_file.cca03,
       cca06        LIKE cca_file.cca06,
       cca07        LIKE cca_file.cca07,
       cca11        LIKE cca_file.cca11,
       cca12a       LIKE cca_file.cca12a,
       cca12b       LIKE cca_file.cca12b,
       cca12c       LIKE cca_file.cca12c,
       cca12d       LIKE cca_file.cca12d,
       cca12e       LIKE cca_file.cca12e,
       cca12f       LIKE cca_file.cca12f,
       cca12g       LIKE cca_file.cca12g,
       cca12h       LIKE cca_file.cca12h,
       cca12        LIKE cca_file.cca12,
       cca23a       LIKE cca_file.cca23a,
       cca23b       LIKE cca_file.cca23b,
       cca23c       LIKE cca_file.cca23c,
       cca23d       LIKE cca_file.cca23d,
       cca23e       LIKE cca_file.cca23e,
       cca23f       LIKE cca_file.cca23f,
       cca23g       LIKE cca_file.cca23g,
       cca23h       LIKE cca_file.cca23h,
       cca23        LIKE cca_file.cca23,
       ccaud01      LIKE cca_file.ccaud01,
       ccaud02      LIKE cca_file.ccaud02,
       ccaud03      LIKE cca_file.ccaud03,
       ccaud04      LIKE cca_file.ccaud04,
       ccaud05      LIKE cca_file.ccaud05,
       ccaud06      LIKE cca_file.ccaud06,
       ccaud07      LIKE cca_file.ccaud07,
       ccaud08      LIKE cca_file.ccaud08,
       ccaud09      LIKE cca_file.ccaud09,
       ccaud10      LIKE cca_file.ccaud10,
       ccaud11      LIKE cca_file.ccaud11,
       ccaud12      LIKE cca_file.ccaud12,
       ccaud13      LIKE cca_file.ccaud13,
       ccaud14      LIKE cca_file.ccaud14,
       ccaud15      LIKE cca_file.ccaud15
       END RECORD
 
MAIN
   DEFINE
       p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = "cca01.cca_file.cca01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "cca02.cca_file.cca02,",
               "cca03.cca_file.cca03,",
               "cca06.cca_file.cca06,",   
               "cca07.cca_file.cca07,",  
               "cca11.cca_file.cca11,",
               "cca12.cca_file.cca12 " 
   LET l_table = cl_prt_temptable('axct005',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
#    INITIALIZE g_cca.* TO NULL
#    INITIALIZE g_cca_t.* TO NULL
 
#    LET g_forupd_sql = "SELECT * FROM cca_file WHERE cca01 = ? AND cca02 = ? AND cca03 = ? AND cca06 = ? AND cca07 = ? FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE t005_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW t005_w AT p_row,p_col WITH FORM "axc/42f/axct005" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
   CALL cl_ui_init()
   LET g_wc = "1 =1"
   CALL t005_b_fill(g_wc)    
 
   CALL t005_menu()
 
   CLOSE WINDOW t005_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t005_menu()
   WHILE TRUE
      CALL t005_bp("G")

      CASE g_action_choice

         WHEN "query"          
            IF cl_chk_act_auth() THEN
               CALL t005_q()
            END IF

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               LET g_chr = 'Y'
               CALL t005_a()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_chr = 'N'
               CALL t005_b()
            END IF
         WHEN "dataload"            #資料匯入
            IF cl_chk_act_auth() THEN
                CALL t005_dataload()
                CALL t005_b_fill(' 1=1 ')
             END IF
         WHEN "excelexample"        #匯出Excel範本
            IF cl_chk_act_auth() THEN
               CALL t005_excelexample(ui.Interface.getRootNode(),base.TypeInfo.create(g_cca),'Y')
            END IF
       # WHEN "output"            
       #    IF cl_chk_act_auth() THEN 
       #       CALL t005_out()
       #    END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "about"
            CALL cl_about() 
         WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                    
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
         WHEN "exporttoexcel"       
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cca),'','')
            END IF
         WHEN "related_document"       #相關文件
            IF cl_chk_act_auth() THEN
               IF g_cca[l_ac].cca01 IS NOT NULL THEN
                  LET g_doc.column1 = "cca01"
                  LET g_doc.value1 = g_cca[l_ac].cca01
                  CALL cl_doc()
               END IF
            END IF
      END CASE 
   END WHILE
END FUNCTION

FUNCTION t005_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_cca TO s_cca.* ATTRIBUTE(COUNT=g_rec_b)


      BEFORE DISPLAY
      #  CALL DIALOG.setSelectionMode( "s_cca", 1 )        #支持單身多選
         CALL fgl_set_arr_curr(l_ac)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 

      ON ACTION query 
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY
          
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY            

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION dataload
         LET g_action_choice="dataload"
         EXIT DISPLAY

      ON ACTION excelexample
         LET g_action_choice="excelexample"
         EXIT DISPLAY

      ON ACTION exporttoexcel   #匯出EXCEL               
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      ON ACTION delete 
         LET g_action_choice="delete"
         EXIT DISPLAY 
         
    # ON ACTION output 
    #    LET g_action_choice="output"
    #    EXIT DISPLAY 
         
      ON ACTION help 
         CALL cl_show_help()
         EXIT DISPLAY
        
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 

      ON ACTION exit
          LET g_action_choice = "exit"
          EXIT DISPLAY
          
      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document" 
      #  CONTINUE DISPLAY  #TQC-D90042 mark
         EXIT DISPLAY      #TQC-D90042 add
 
      ON ACTION close   #COMMAND KEY(INTERRUPT)  
         LET INT_FLAG=FALSE 		 
         LET g_action_choice = "exit"
         EXIT DISPLAY 
   END DISPLAY             
 
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 

FUNCTION t005_cs()
DEFINE l_cca06 LIKE cca_file.cca06   
   CLEAR FORM
   CALL g_cca.clear()
   CONSTRUCT g_wc ON                    # 螢幕上取條件
       cca01,cca02,cca03,cca06,cca07,cca11,      
       cca12a, cca12b, cca12c, cca12d, cca12e,cca12f,cca12g,cca12h, cca12,    
       cca23a, cca23b, cca23c, cca23d, cca23e,cca23f,cca23g,cca23h, cca23,     
       ccaud01,ccaud02,ccaud03,ccaud04,ccaud05,
       ccaud06,ccaud07,ccaud08,ccaud09,ccaud10,
       ccaud11,ccaud12,ccaud13,ccaud14,ccaud15
        FROM s_cca[1].cca01,s_cca[1].cca02,s_cca[1].cca03,s_cca[1].cca06,s_cca[1].cca07,s_cca[1].cca11,
             s_cca[1].cca12a,s_cca[1].cca12b,s_cca[1].cca12c,
             s_cca[1].cca12d,s_cca[1].cca12e,s_cca[1].cca12f,s_cca[1].cca12g,
             s_cca[1].cca12h,s_cca[1].cca12,s_cca[1].cca23a,s_cca[1].cca23b,
             s_cca[1].cca23c,s_cca[1].cca23d,s_cca[1].cca23e,s_cca[1].cca23f,
             s_cca[1].cca23g,s_cca[1].cca23h,s_cca[1].cca23,s_cca[1].ccaud01,
             s_cca[1].ccaud02,s_cca[1].ccaud03,s_cca[1].ccaud04,s_cca[1].ccaud05,
             s_cca[1].ccaud06,s_cca[1].ccaud07,s_cca[1].ccaud08,s_cca[1].ccaud09,
             s_cca[1].ccaud10,s_cca[1].ccaud11,s_cca[1].ccaud12,s_cca[1].ccaud13,
             s_cca[1].ccaud14,s_cca[1].ccaud15
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         AFTER FIELD cca06
            LET l_cca06 = get_fldbuf(cca06)

         ON ACTION about          
            CALL cl_about()       
 
         ON ACTION HELP           
            CALL cl_show_help()   
 
         ON ACTION controlg       
            CALL cl_cmdask()      
    
         ON ACTION controlp
            CASE 
               WHEN INFIELD(cca01) #item
                  CALL q_sel_ima(TRUE, "q_ima","",g_cca[l_ac].cca01,"","","","","",'')
                       RETURNING  g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cca01
                  NEXT FIELD cca01
               WHEN INFIELD(cca07)                                               
                  IF l_cca06 MATCHES '[45]' THEN                             
                     CALL cl_init_qry_var()       
                     LET g_qryparam.state= "c"                                
                     CASE l_cca06                                               
                        WHEN '4'                                                    
                          LET g_qryparam.form = "q_pja"                             
                        WHEN '5'                                                                                 
                          LET g_qryparam.form = "q_imd3"                       
                        OTHERWISE EXIT CASE                                         
                     END CASE                                                       
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                     DISPLAY  g_qryparam.multiret TO cca07                                   
                     NEXT FIELD cca07                                               
                  END IF                                                         
            END CASE
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
	    CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccauser', 'ccagrup')  
 
    LET g_sql= "SELECT COUNT(*) FROM cca_file WHERE ",g_wc CLIPPED
    PREPARE t005_precount FROM g_sql
    DECLARE t005_count CURSOR FOR t005_precount
END FUNCTION

FUNCTION t005_a()
   DISPLAY g_rec_b TO FORMONLY.cnt
   CALL t005_b()
END FUNCTION
  
FUNCTION t005_b()
    DEFINE
        p_cmd           LIKE type_file.chr1,           
        l_flag          LIKE type_file.chr1,           
        l_flag_1        LIKE type_file.chr1,
        l_n             LIKE type_file.num5,           
        l_pja01         LIKE pja_file.pja01,           
        l_imd09         LIKE imd_file.imd09,           
        l_gem01         LIKE gem_file.gem01,
        l_lock_sw       LIKE type_file.chr1,           
        l_allow_insert  LIKE type_file.num5,    #可新增否
        l_allow_delete  LIKE type_file.num5     #可刪除否
DEFINE  l_chr    LIKE type_file.chr1,   
        l_bdate  LIKE sma_file.sma53,   
        l_edate  LIKE sma_file.sma53    
DEFINE  l_cca03  LIKE cca_file.cca03  #20131212 add by suncx
DEFINE  l_cca02  LIKE cca_file.cca02  #20131209 add by suncx
        
    IF s_shut(0) THEN RETURN END IF       
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
    LET g_action_choice = ""
              
    LET g_forupd_sql = " SELECT cca01,'','','',cca02,cca03,cca06,cca07,cca11,cca12a,cca12b,cca12c,",
                       "        cca12d,cca12e,cca12f,cca12g,cca12h,cca12,cca23a,cca23b,cca23c,cca23d,",
                       "        cca23e,cca23f,cca23g,cca23h,cca23,ccaud01,ccaud02,ccaud03,ccaud04,ccaud05,", 
                       "        ccaud06,ccaud07,ccaud08,ccaud09,ccaud10,ccaud11,ccaud12,ccaud13,ccaud14,ccaud15",                       
                       "   FROM cca_file",
                       "  WHERE cca01= ?  AND cca02 = ? AND cca03 = ? AND cca06 = ? AND cca07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t005_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
              
    INPUT ARRAY g_cca WITHOUT DEFAULTS FROM s_cca.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

 
        BEFORE INPUT

           IF g_rec_b != 0 THEN
              IF g_chr = 'Y' THEN
                 LET l_n = ARR_COUNT()
                 LET l_ac = l_n + 1
              END IF
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_before_input_done = FALSE
           CALL t005_set_entry_b(p_cmd)
           CALL t005_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE

        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              IF NOT cl_null(g_cca[l_ac].cca02) AND NOT cl_null(g_cca[l_ac].cca03) THEN
                 #131129 add by suncx str------------
                 IF g_cca[l_ac].cca03 >= 12 THEN
                    LET l_cca02 = g_cca[l_ac].cca02 + 1
                    LET l_cca03 = 1
                 ELSE
                    LET l_cca02 = g_cca[l_ac].cca02
                    LET l_cca03 = g_cca[l_ac].cca03 + 1
                 END IF
                 #131129 add by suncx end------------
                 SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
                #CALL s_azm(g_cca[l_ac].cca02,g_cca[l_ac].cca03) RETURNING l_chr,l_bdate,l_edate
                 CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate #131129 add by suncx
                 IF l_edate <= g_sma.sma53 THEN
                    CALL cl_err('','alm1561',0)
                    EXIT INPUT 
                 END IF
                 #20131209 add by suncx sta-------
                 IF NOT t005_chk(g_cca[l_ac].cca02,g_cca[l_ac].cca03) THEN
                    CALL cl_err('','axc-809',1)
                    EXIT INPUT 
                 END IF
                 #20131209 add by suncx end-------
              END IF
              CALL t005_set_entry_b(p_cmd)  
              LET p_cmd = 'u'
              LET g_before_input_done = FALSE
              CALL t005_set_entry_b(p_cmd)
              CALL t005_set_no_entry_b(p_cmd)
              LET g_before_input_done = TRUE

              LET g_success = 'Y'              
              BEGIN WORK
              LET p_cmd='u'
              LET g_cca_t.* = g_cca[l_ac].*  #BACKUP
              OPEN t005_bcl USING g_cca_t.cca01,g_cca_t.cca02,g_cca_t.cca03,g_cca_t.cca06,g_cca_t.cca07
              IF STATUS THEN
                 CALL cl_err("OPEN t005_bcl:", STATUS, 1)
                 LET l_lock_sw = 'Y'
              ELSE
                 FETCH t005_bcl INTO g_cca[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_cca_t.cca01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t005_ima()
              END IF
              CALL cl_show_fld_cont()   
           END IF
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE
           CALL t005_set_entry_b(p_cmd)
           CALL t005_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           INITIALIZE g_cca[l_ac].* TO NULL
           LET g_cca[l_ac].cca11=0 LET g_cca[l_ac].cca12=0
           LET g_cca[l_ac].cca12a=0 LET g_cca[l_ac].cca12b=0 LET g_cca[l_ac].cca12c=0
           LET g_cca[l_ac].cca12d=0 LET g_cca[l_ac].cca12e=0
           LET g_cca[l_ac].cca12f=0 LET g_cca[l_ac].cca12g=0 LET g_cca[l_ac].cca12h=0     
           LET g_cca[l_ac].cca23a=0 LET g_cca[l_ac].cca23b=0 LET g_cca[l_ac].cca23c=0
           LET g_cca[l_ac].cca23d=0 LET g_cca[l_ac].cca23e=0 
           LET g_cca[l_ac].cca23f=0 LET g_cca[l_ac].cca23g=0 LET g_cca[l_ac].cca23h=0     
           LET g_cca[l_ac].cca23 =0
           LET g_cca[l_ac].cca06 = g_ccz.ccz28                                
           LET g_cca_t.* = g_cca[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()      
           NEXT FIELD cca01           
 
        AFTER FIELD cca01
          IF p_cmd = 'a' AND  g_cca[l_ac].cca01 IS NOT NULL THEN
            IF NOT s_chk_item_no(g_cca[l_ac].cca01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD cca01
            END IF    
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_cca[l_ac].cca01,"",STATUS,"","sel ima:",1)   
               IF p_cmd = 'u' AND  g_cca[l_ac].cca01 = g_cca_t.cca01  THEN                                                   
               ELSE                                                                                               
                  NEXT FIELD cca01                                                                                                    
               END IF                                          
            END IF
            CALL t005_ima()
            IF NOT t005_cca_chk() THEN
               NEXT FIELD cca01
            END IF
          END IF
 
        AFTER FIELD cca02
          IF g_cca[l_ac].cca02 <= 0 THEN 
             CALL cl_err(g_cca[l_ac].cca02,'axc-207',0)
             NEXT FIELD cca02
          END IF 
          IF NOT t005_cca_chk() THEN
             NEXT FIELD cca01
          END IF
          IF NOT cl_null(g_cca[l_ac].cca02) AND NOT cl_null(g_cca[l_ac].cca03) THEN 
             #131129 add by suncx str------------
             IF g_cca[l_ac].cca03 >= 12 THEN
                LET l_cca02 = g_cca[l_ac].cca02 + 1
                LET l_cca03 = 1
             ELSE
                LET l_cca02 = g_cca[l_ac].cca02
                LET l_cca03 = g_cca[l_ac].cca03 + 1
             END IF
             #131129 add by suncx end------------
             SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
            #CALL s_azm(g_cca[l_ac].cca02,g_cca[l_ac].cca03) RETURNING l_chr,l_bdate,l_edate  
             CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate #131129 add by suncx
             IF l_edate <= g_sma.sma53 THEN           
                CALL cl_err('','alm1561',0)
                NEXT FIELD cca02
             END IF
          END IF 
 
        AFTER FIELD cca03
          IF g_cca[l_ac].cca03 IS NOT NULL THEN
            IF NOT t005_cca_chk() THEN
               NEXT FIELD cca01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_cca[l_ac].cca01 != g_cca_t.cca01 OR
                g_cca[l_ac].cca02 != g_cca_t.cca02 OR g_cca[l_ac].cca03 != g_cca_t.cca03 OR
                g_cca[l_ac].cca06 != g_cca_t.cca06 OR g_cca[l_ac].cca07 != g_cca_t.cca07)) THEN  
                SELECT count(*) INTO l_n FROM cca_file
                    WHERE cca01 = g_cca[l_ac].cca01
                      AND cca02 = g_cca[l_ac].cca02 AND cca03 = g_cca[l_ac].cca03
                      AND cca06 = g_cca[l_ac].cca06 AND cca07 = g_cca[l_ac].cca07   
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cca01
                END IF
            END IF
            IF g_cca[l_ac].cca03 <= 0 THEN 
               CALL cl_err(g_cca[l_ac].cca03,'axc-207',0)
               NEXT FIELD cca03
            END IF
 
            IF NOT cl_null(g_cca[l_ac].cca02) AND NOT cl_null(g_cca[l_ac].cca03) THEN 
               #131129 add by suncx str------------
               IF g_cca[l_ac].cca03 >= 12 THEN
                  LET l_cca02 = g_cca[l_ac].cca02 + 1
                  LET l_cca03 = 1
               ELSE
                  LET l_cca02 = g_cca[l_ac].cca02
                  LET l_cca03 = g_cca[l_ac].cca03 + 1
               END IF
               #131129 add by suncx end------------
               SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
              #CALL s_azm(g_cca[l_ac].cca02,g_cca[l_ac].cca03) RETURNING l_chr,l_bdate,l_edate  
               CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate #131129 add by suncx
               IF l_edate <= g_sma.sma53 THEN           
                  CALL cl_err('','alm1561',0)
                  NEXT FIELD cca03
               END IF
            END IF 
          END IF
        AFTER FIELD cca06
          IF g_cca[l_ac].cca06 IS NOT NULL THEN
 
             IF g_cca[l_ac].cca06 NOT MATCHES '[123456]' THEN     
                NEXT FIELD cca06
             END IF
 
             IF g_cca[l_ac].cca06 MATCHES'[126]' THEN          
                CALL cl_set_comp_entry("cca07",FALSE)
                LET g_cca[l_ac].cca07 = ' '
             ELSE
                CALL cl_set_comp_entry("cca07",TRUE)
             END IF
             IF NOT t005_cca_chk() THEN
                NEXT FIELD cca01
             END IF
          END IF
          
        AFTER FIELD cca07
            IF NOT cl_null(g_cca[l_ac].cca07) OR g_cca[l_ac].cca07 != ' '  THEN
               IF g_cca[l_ac].cca06='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_cca[l_ac].cca07
                                                            AND pjaclose='N'  
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",g_cca[l_ac].cca07,"",STATUS,"","sel pja:",1)
                     NEXT FIELD cca07
                  END IF
               END IF
               IF g_cca[l_ac].cca06='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=g_cca[l_ac].cca07
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",g_cca[l_ac].cca07,"",STATUS,"","sel imd:",1)     
                     NEXT FIELD cca07
                  END IF
               END IF
            ELSE 
               LET g_cca[l_ac].cca07 = ' '
            END IF
            IF NOT t005_cca_chk() THEN
               NEXT FIELD cca01
            END IF

        AFTER FIELD cca11,cca12a,cca12b,cca12c,cca12d,cca12e,cca12f,cca12g,cca12h #No.FUN-7C0101
            CALL t005_u_cost()

        AFTER FIELD cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h       #No.FUN-7C0101
            CALL t005_u_23()
        
        AFTER FIELD ccaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        BEFORE DELETE                            #是否取消單身
           IF g_cca_t.cca01 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
             #檢查此筆資料之下游檔案imf_file,img_file是否尚在使用中
              #131129 add by suncx str------------
              IF g_cca[l_ac].cca03 >= 12 THEN
                 LET l_cca02 = g_cca[l_ac].cca02 + 1
                 LET l_cca03 = 1
              ELSE
                 LET l_cca02 = g_cca[l_ac].cca02
                 LET l_cca03 = g_cca[l_ac].cca03 + 1
              END IF
              #131129 add by suncx end------------
              SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
             #CALL s_azm(g_cca[l_ac].cca02,g_cca[l_ac].cca03) RETURNING l_chr,l_bdate,l_edate   
              CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate #131129 add by suncx
              IF l_edate <= g_sma.sma53 THEN                
                 CALL cl_err('','alm1561',0)  
                 CANCEL DELETE
              END IF     
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF              
              DELETE FROM cca_file
               WHERE cca01 = g_cca_t.cca01
                 AND cca02 = g_cca_t.cca02
                 AND cca03 = g_cca_t.cca03
                 AND cca06 = g_cca_t.cca06
                 AND cca07 = g_cca_t.cca07
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","cca_file",g_cca_t.cca01,"",
                               SQLCA.sqlcode,"","",1)   
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cnt
           END IF             
 
        ON ROW CHANGE
           IF INT_FLAG THEN     
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_cca[l_ac].* = g_cca_t.*
              CLOSE t005_bcl 
              ROLLBACK WORK 
              EXIT INPUT
           END IF
           #131129 add by suncx str------------
           IF g_cca[l_ac].cca03 >= 12 THEN
              LET l_cca02 = g_cca[l_ac].cca02 + 1
              LET l_cca03 = 1
           ELSE
              LET l_cca02 = g_cca[l_ac].cca02
              LET l_cca03 = g_cca[l_ac].cca03 + 1
           END IF
           #131129 add by suncx end------------
           SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
          #CALL s_azm(g_cca[l_ac].cca02,g_cca[l_ac].cca03) RETURNING l_chr,l_bdate,l_edate
           CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate #131129 add by suncx
           IF l_edate <= g_sma.sma53 THEN
              CALL cl_err('','alm1561',0)
              LET l_flag_1 = 'Y'
           END IF

           IF l_lock_sw = 'Y' OR l_flag_1 = 'Y' THEN
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_cca[l_ac].cca01,-263,1)
              END IF
              LET g_cca[l_ac].* = g_cca_t.*
           ELSE
              UPDATE cca_file
                   SET cca11   = g_cca[l_ac].cca11,
                       cca12a   = g_cca[l_ac].cca12a,
                       cca12b   = g_cca[l_ac].cca12b,
                       cca12c   = g_cca[l_ac].cca12c,
                       cca12d   = g_cca[l_ac].cca12d,  
                       cca12e   = g_cca[l_ac].cca12e,  
                       cca12f   = g_cca[l_ac].cca12f,  
                       cca12g   = g_cca[l_ac].cca12g,  
                       cca12h   = g_cca[l_ac].cca12h,
                       cca12 = g_cca[l_ac].cca12,
                       cca23a   = g_cca[l_ac].cca23a,  
                       cca23b   = g_cca[l_ac].cca23b,
                       cca23c   = g_cca[l_ac].cca23c,  
                       cca23d   = g_cca[l_ac].cca23d,
                       cca23e   = g_cca[l_ac].cca23e,
                       cca23f   = g_cca[l_ac].cca23f,
                       cca23g   = g_cca[l_ac].cca23g,
                       cca23h   = g_cca[l_ac].cca23h,
                       cca23   = g_cca[l_ac].cca23,
                       ccamodu = g_user,
                       ccadate = g_today
               WHERE cca01= g_cca_t.cca01
                 AND cca02 = g_cca_t.cca02
                 AND cca03 = g_cca_t.cca03
                 AND cca06 = g_cca_t.cca06
                 AND cca07 = g_cca_t.cca07
                 
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","cca_file",g_cca_t.cca01,"",
                                SQLCA.sqlcode,"","",1)   
                  LET g_cca[l_ac].* = g_cca_t.*
                  ROLLBACK WORK
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN    
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_cca[l_ac].* = g_cca_t.*
              ELSE
                 CALL g_cca.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF
              CLOSE t005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           IF l_ac = 0 THEN LET l_ac = 0 END IF
           CLOSE t005_bcl
           COMMIT WORK

        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE t005_bcl
              CANCEL INSERT
           END IF
           #20131209 add by suncx sta-------
           IF NOT t005_chk(g_cca[l_ac].cca02,g_cca[l_ac].cca03) THEN
               CALL cl_err('','axc-809',1)
               NEXT FIELD cca02
           END IF
           #20131209 add by suncx end-------

           INSERT INTO cca_file(cca01,cca02,cca03,cca06,cca07,cca11,cca12a,
                                cca12b,cca12c,cca12d,cca12e,cca12f,cca12g,cca12h,cca12,
                                cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h,cca23,
                                ccaacti,ccauser,ccadate,ccamodu,ccaoriu,ccaorig,ccalegal) 
             VALUES(g_cca[l_ac].cca01,g_cca[l_ac].cca02,g_cca[l_ac].cca03,
                    g_cca[l_ac].cca06,g_cca[l_ac].cca07,g_cca[l_ac].cca11,
                    g_cca[l_ac].cca12a,g_cca[l_ac].cca12b,g_cca[l_ac].cca12c,
                    g_cca[l_ac].cca12d,g_cca[l_ac].cca12e,g_cca[l_ac].cca12f,
                    g_cca[l_ac].cca12g,g_cca[l_ac].cca12h,g_cca[l_ac].cca12,
                    g_cca[l_ac].cca23a,g_cca[l_ac].cca23b,g_cca[l_ac].cca23c,
                    g_cca[l_ac].cca23d,g_cca[l_ac].cca23e,g_cca[l_ac].cca23f,
                    g_cca[l_ac].cca23g,g_cca[l_ac].cca23h,g_cca[l_ac].cca23,   
                    'Y',g_user,'',' ',g_user,g_grup,g_legal)   
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","cca_file",g_cca[l_ac].cca01,g_cca[l_ac].cca02,
                            SQLCA.sqlcode,"","",1)   
              ROLLBACK WORK
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cnt
              COMMIT WORK
           END IF  
      # AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
      #     LET l_flag='N'
      #     IF INT_FLAG THEN
      #         EXIT INPUT  
      #     END IF
      #     IF l_flag='Y' THEN
      #          CALL cl_err('','9033',0)
      #          NEXT FIELD cca01
      #     END IF
 
         ON ACTION controlp
           CASE
              WHEN INFIELD(cca01) #料號
                 CALL q_sel_ima(FALSE, "q_ima","",g_cca[l_ac].cca01,"","","","","",'' ) 
                 RETURNING  g_cca[l_ac].cca01
                 DISPLAY BY NAME g_cca[l_ac].cca01
                 NEXT FIELD cca01
              WHEN INFIELD(cca07)
                IF g_cca[l_ac].cca06 MATCHES '[45]' THEN
                 CALL cl_init_qry_var()
                 CASE g_cca[l_ac].cca06
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                    WHEN '5'
                      LET g_qryparam.form = "q_imd3"    
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = g_cca[l_ac].cca07
                 CALL cl_create_qry() RETURNING g_cca[l_ac].cca07
                 DISPLAY BY NAME g_cca[l_ac].cca07
                END IF
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
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
    CLOSE t005_bcl
   #COMMIT WORK    
END FUNCTION

FUNCTION t005_cca_chk()
   DEFINE l_n    LIKE type_file.num5
   IF NOT cl_null(g_cca[l_ac].cca01) AND NOT cl_null(g_cca[l_ac].cca02) AND NOT cl_null(g_cca[l_ac].cca03)
      AND NOT cl_null(g_cca[l_ac].cca06) AND (g_cca[l_ac].cca07) IS NOT NULL THEN
      SELECT COUNT(*) INTO l_n FROM cca_file
          WHERE cca01 = g_cca[l_ac].cca01
            AND cca02 = g_cca[l_ac].cca02 AND cca03 = g_cca[l_ac].cca03
            AND cca06 = g_cca[l_ac].cca06 AND cca07 = g_cca[l_ac].cca07
      IF l_n > 0 THEN     
          CALL cl_err('count:',-239,0)
          RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t005_u_cost()
    IF cl_null(g_cca[l_ac].cca11)  THEN LET g_cca[l_ac].cca11 = 0 END IF
    IF cl_null(g_cca[l_ac].cca12)  THEN LET g_cca[l_ac].cca12 = 0 END IF
    IF cl_null(g_cca[l_ac].cca12a) THEN LET g_cca[l_ac].cca12a= 0 END IF
    IF cl_null(g_cca[l_ac].cca12b) THEN LET g_cca[l_ac].cca12b= 0 END IF
    IF cl_null(g_cca[l_ac].cca12c) THEN LET g_cca[l_ac].cca12c= 0 END IF
    IF cl_null(g_cca[l_ac].cca12d) THEN LET g_cca[l_ac].cca12d= 0 END IF
    IF cl_null(g_cca[l_ac].cca12e) THEN LET g_cca[l_ac].cca12e= 0 END IF
    IF cl_null(g_cca[l_ac].cca12f) THEN LET g_cca[l_ac].cca12f= 0 END IF 
    IF cl_null(g_cca[l_ac].cca12g) THEN LET g_cca[l_ac].cca12g= 0 END IF
    IF cl_null(g_cca[l_ac].cca12h) THEN LET g_cca[l_ac].cca12h= 0 END IF
    LET g_cca[l_ac].cca12a = cl_digcut(g_cca[l_ac].cca12a,g_ccz.ccz26)
    LET g_cca[l_ac].cca12b = cl_digcut(g_cca[l_ac].cca12b,g_ccz.ccz26)
    LET g_cca[l_ac].cca12c = cl_digcut(g_cca[l_ac].cca12c,g_ccz.ccz26)
    LET g_cca[l_ac].cca12d = cl_digcut(g_cca[l_ac].cca12d,g_ccz.ccz26)
    LET g_cca[l_ac].cca12e = cl_digcut(g_cca[l_ac].cca12e,g_ccz.ccz26)
    LET g_cca[l_ac].cca12f = cl_digcut(g_cca[l_ac].cca12f,g_ccz.ccz26)   
    LET g_cca[l_ac].cca12g = cl_digcut(g_cca[l_ac].cca12g,g_ccz.ccz26)  
    LET g_cca[l_ac].cca12h = cl_digcut(g_cca[l_ac].cca12h,g_ccz.ccz26) 
    LET g_cca[l_ac].cca12 = g_cca[l_ac].cca12a+g_cca[l_ac].cca12b+g_cca[l_ac].cca12c
                    + g_cca[l_ac].cca12d+g_cca[l_ac].cca12e
                    + g_cca[l_ac].cca12f+g_cca[l_ac].cca12g+g_cca[l_ac].cca12h 
    DISPLAY BY NAME g_cca[l_ac].cca12
    IF g_cca[l_ac].cca11<>0 THEN
       LET g_cca[l_ac].cca23a=g_cca[l_ac].cca12a/g_cca[l_ac].cca11
       LET g_cca[l_ac].cca23b=g_cca[l_ac].cca12b/g_cca[l_ac].cca11
       LET g_cca[l_ac].cca23c=g_cca[l_ac].cca12c/g_cca[l_ac].cca11
       LET g_cca[l_ac].cca23d=g_cca[l_ac].cca12d/g_cca[l_ac].cca11
       LET g_cca[l_ac].cca23e=g_cca[l_ac].cca12e/g_cca[l_ac].cca11
       LET g_cca[l_ac].cca23f=g_cca[l_ac].cca12f/g_cca[l_ac].cca11   
       LET g_cca[l_ac].cca23g=g_cca[l_ac].cca12g/g_cca[l_ac].cca11  
       LET g_cca[l_ac].cca23h=g_cca[l_ac].cca12h/g_cca[l_ac].cca11 
       LET g_cca[l_ac].cca23 =g_cca[l_ac].cca12 /g_cca[l_ac].cca11
       DISPLAY BY NAME g_cca[l_ac].cca23,g_cca[l_ac].cca23a,g_cca[l_ac].cca23b,g_cca[l_ac].cca23c,
                                   g_cca[l_ac].cca23d,g_cca[l_ac].cca23e,
                                   g_cca[l_ac].cca23f,g_cca[l_ac].cca23g,g_cca[l_ac].cca23h 
    END IF
END FUNCTION

FUNCTION t005_u_23()
    LET g_cca[l_ac].cca23=g_cca[l_ac].cca23a+g_cca[l_ac].cca23b+g_cca[l_ac].cca23c+
                    g_cca[l_ac].cca23d+g_cca[l_ac].cca23e
                    +g_cca[l_ac].cca23f+g_cca[l_ac].cca23g+g_cca[l_ac].cca23h 
    DISPLAY BY NAME g_cca[l_ac].cca23
END FUNCTION

FUNCTION t005_ima()

  IF l_ac > 0 THEN
     SELECT ima02,ima021,ima25 INTO g_cca[l_ac].ima02,g_cca[l_ac].ima021,g_cca[l_ac].ima25
       FROM ima_file 
      WHERE ima01 = g_cca[l_ac].cca01
     DISPLAY BY NAME g_cca[l_ac].ima02,g_cca[l_ac].ima021,g_cca[l_ac].ima25
  END IF

END FUNCTION


#資料匯入:通過excel模板錄入單身資料
FUNCTION t005_dataload()
   OPEN WINDOW t005_o_w WITH FORM "axc/42f/axct005_o" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axct005_o")
 
   CLEAR FORM
   ERROR ''
   LET g_disk = "Y"   #從C:TIPTOP 上傳?(INPUT條件) 
   LET g_choice = '2' #文件形式:'1' TXT;'2' EXCEL
   DISPLAY g_choice TO FORMONLY.b
   WHILE TRUE
      INPUT g_file,g_choice,g_disk 
      WITHOUT DEFAULTS FROM FORMONLY.file,FORMONLY.b,FORMONLY.c
         AFTER FIELD b
            IF g_choice = '2' THEN 
               LET g_disk = 'Y'
            END IF 
      
         AFTER FIELD c
            IF g_choice = '2' AND g_disk = 'N' THEN 
               CALL cl_err('','agl-971',0)
               LET g_disk = 'Y'
               NEXT FIELD c
            END IF   
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()          
            EXIT INPUT
    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
    
         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
    
         ON ACTION controlf
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help()  
    
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION CANCEL
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t005_o_w
         RETURN
      END IF
        
      IF cl_sure(0,0) THEN
         LET g_n = 0    
         LET g_cnt = 0    
         LET g_totsuccess = 'N'
         LET g_success='Y'
       # BEGIN WORK       #FUN-D90042 mark  
         CALL t005_load()
       # CALL s_showmsg()  
         IF g_totsuccess = 'Y' THEN
            LET g_success='Y'
         END IF
         CALL cl_err_msg("","agl1013",g_n CLIPPED|| "|" || g_cnt CLIPPED,0)
         IF g_success = 'Y' THEN
         #  COMMIT WORK       #FUN-D90042 mark
         ELSE
         #  ROLLBACK WORK     #FUN-D90042 mark
            CONTINUE WHILE
         END IF
         EXIT WHILE
      ELSE
         CONTINUE WHILE
      END IF
   END WHILE
   CLOSE WINDOW t005_o_w
END FUNCTION

#txt格式導入
FUNCTION t005_load()
   DEFINE channel_r base.Channel
   DEFINE l_string  LIKE type_file.chr1000
   DEFINE unix_path LIKE type_file.chr1000
   DEFINE window_path LIKE type_file.chr1000
   DEFINE l_cmd     LIKE type_file.chr1000 
   DEFINE li_result LIKE type_file.chr1 
   DEFINE l_column  DYNAMIC ARRAY of RECORD 
            col1    LIKE gaq_file.gaq01,
            col2    LIKE gaq_file.gaq03
                    END RECORD
   DEFINE l_cnt3    LIKE type_file.num5
   DEFINE li_i      LIKE type_file.num5
   DEFINE li_n      LIKE type_file.num5
   DEFINE ls_cell   STRING
   DEFINE ls_cell_r STRING
   DEFINE li_i_r    LIKE type_file.num5
   DEFINE ls_cell_c STRING
   DEFINE ls_value  STRING
   DEFINE ls_value_o  STRING
   DEFINE li_flag   LIKE type_file.chr1 
   DEFINE lr_data_tmp   DYNAMIC ARRAY OF RECORD
             data01 STRING
                    END RECORD
   DEFINE l_fname   STRING   
   DEFINE l_column_name LIKE zta_file.zta01
   DEFINE l_data_type LIKE ztb_file.ztb04
   DEFINE l_nullable  LIKE ztb_file.ztb05
   DEFINE l_flag_1  LIKE type_file.chr1  
   DEFINE l_date    LIKE type_file.dat
   DEFINE li_k                 LIKE type_file.num5
   DEFINE l_err_cnt            LIKE type_file.num5
   DEFINE l_no_b               LIKE pmw_file.pmw01   
   DEFINE l_no_e               LIKE pmw_file.pmw01
   DEFINE l_old_no             LIKE type_file.chr50  
   DEFINE l_old_no_b           LIKE type_file.chr50  
   DEFINE l_old_no_e           LIKE type_file.chr50
   DEFINE lr_err       DYNAMIC ARRAY OF RECORD
               line         STRING,
               key1         STRING,
               err          STRING
                        END RECORD
  DEFINE  m_tempdir   LIKE type_file.chr1000,    
          ss1          LIKE type_file.chr1000,
          m_sf        LIKE type_file.chr1000,
          m_file      LIKE type_file.chr1000,
          l_j         LIKE type_file.num5,
          l_n         LIKE type_file.num5
  DEFINE  g_target    LIKE type_file.chr1000
  DEFINE tok           base.StringTokenizer
  DEFINE ss            STRING 
  DEFINE l_str         DYNAMIC ARRAY OF STRING  
  DEFINE ms_codeset          String  
  
   CALL s_showmsg_init()
   LET g_success='Y'
   LET m_tempdir = FGL_GETENV("TEMPDIR")
   LET l_n = LENGTH(m_tempdir)
   
   LET ms_codeset = cl_get_codeset()
   
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF
 
   IF m_tempdir IS NULL THEN
      IF g_choice='1' THEN
         LET m_file=g_file,".txt"
      ELSE
         LET m_file=g_file,".xls"
      END IF
   ELSE
      IF g_choice='1' THEN 
         LET m_file=m_tempdir CLIPPED,'/',g_file,".txt"
      ELSE
         LET m_file=m_tempdir CLIPPED,'/',g_file,".xls" 
      END IF
   END IF
 
   IF g_disk= "Y" THEN
      LET m_sf = "c:/tiptop/"
      IF g_choice='1' THEN 
         LET m_sf = m_sf CLIPPED,g_file CLIPPED,".txt"
      ELSE
         LET m_sf = m_sf CLIPPED,g_file CLIPPED,".xls"
      END IF
      IF NOT cl_upload_file(m_sf, m_file) THEN
         CALL cl_err(NULL, "lib-212", 1)
         RETURN
      END IF
   END IF
   LET ss1="test -s ",m_file CLIPPED
   -- l_n=0 if the file is exist;
   -- otherwise there is no such file
   RUN ss1 RETURNING l_n

   IF l_n THEN
      IF m_tempdir IS NULL THEN
         LET m_tempdir='.'
      END IF

      DISPLAY "* NOTICE * No such file '",m_file CLIPPED,"'"
      DISPLAY "PLEASE make sure that the file download from LEADER"
      DISPLAY "has been put in the directory:"
      DISPLAY '--> ',m_tempdir
      CALL cl_err(m_file,'aap-186',1)
      RETURN
   END IF
   IF g_choice='1' THEN
      LET channel_r = base.Channel.create()
      LET g_target = m_file
      IF m_sf IS NOT NULL THEN
         IF NOT cl_upload_file(m_sf,g_target) THEN
            CALL cl_err("Can't upload file: ", m_sf, 0)
            RETURN
         END IF
      END IF
      CASE ms_codeset
         WHEN "UTF-8"
            IF g_lang='0' THEN
               LET l_cmd = "enca -L zh_TW -x UTF-8 "||g_target CLIPPED
            ELSE
               IF g_lang='2' THEN
                  LET l_cmd = "enca -L zh_CN -x UTF-8 "||g_target CLIPPED
               END IF
            END IF
            RUN l_cmd
            LET l_cmd = " killcr " ||g_target CLIPPED
            RUN l_cmd
         WHEN "BIG5"
            IF g_lang='0' THEN
               LET l_cmd = "enca -L zh_TW -x BIG5 "||g_target CLIPPED
             ELSE
               IF g_lang='2' THEN
                  LET l_cmd = "enca -L zh_CN -x BIG5 "||g_target CLIPPED
               END IF
            END IF
            RUN l_cmd
            LET l_cmd = " killcr " ||g_target CLIPPED
            RUN l_cmd
         WHEN "GB2312"
            IF g_lang='0' THEN
               LET l_cmd = "enca -L zh_TW -x GB2312 "||g_target CLIPPED
            ELSE
               IF g_lang='2' THEN
                  LET l_cmd = "enca -L zh_CN -x GB2312 "||g_target CLIPPED
               END IF
            END IF
            RUN l_cmd
            LET l_cmd = " killcr " ||g_target CLIPPED
            RUN l_cmd
      END CASE
     
      CALL channel_r.openFile(g_target,"r")                                    
      IF STATUS THEN
         CALL cl_err("Can't open file: ", STATUS, 0)
         RETURN
      END IF
      LET l_n=1
      CALL channel_r.setDelimiter("")
      WHILE channel_r.read(ss)
         IF l_n=1 THEN LET l_n=-1 CONTINUE WHILE END IF #第一行是栏位名称,跳过
         LET tok = base.StringTokenizer.createExt(ss,ASCII 9,'',TRUE) 
         LET l_j=0
         CALL l_str.clear()
         WHILE tok.hasMoreTokens()
            LET l_j=l_j+1
            LET l_str[l_j]=tok.nextToken()
         END WHILE                   
                   LET g_cca_1.cca01 = l_str[1]  
                   LET g_cca_1.cca02 = l_str[2]
                   LET g_cca_1.cca03 = l_str[3]
                   LET g_cca_1.cca06 = l_str[4]
                   LET g_cca_1.cca07 = l_str[5]
                   LET g_cca_1.cca11 = l_str[6]
                   LET g_cca_1.cca12a = l_str[7]
                   LET g_cca_1.cca12b = l_str[8]
                   LET g_cca_1.cca12c = l_str[9]
                   LET g_cca_1.cca12d = l_str[10]
                   LET g_cca_1.cca12e = l_str[11]
                   LET g_cca_1.cca12f = l_str[12]
                   LET g_cca_1.cca12g = l_str[13]
                   LET g_cca_1.cca12h = l_str[14]
                   LET g_cca_1.cca12 = l_str[15]
                   LET g_cca_1.cca23a = l_str[16]
                   LET g_cca_1.cca23b = l_str[17]
                   LET g_cca_1.cca23c = l_str[18]
                   LET g_cca_1.cca23d = l_str[19]
                   LET g_cca_1.cca23e = l_str[20]
                   LET g_cca_1.cca23f = l_str[21]
                   LET g_cca_1.cca23g = l_str[22]
                   LET g_cca_1.cca23h = l_str[23]  
                   LET g_cca_1.cca23 = l_str[24]
                   LET g_cca_1.ccaud01 = l_str[25]
                   LET g_cca_1.ccaud02 = l_str[26]
                   LET g_cca_1.ccaud03 = l_str[27] 
                   LET g_cca_1.ccaud04 = l_str[28]
                   LET g_cca_1.ccaud05 = l_str[29]
                   LET g_cca_1.ccaud06 = l_str[30]
                   LET g_cca_1.ccaud07 = l_str[31]
                   LET g_cca_1.ccaud08 = l_str[32]
                   LET g_cca_1.ccaud09 = l_str[33] 
                   LET g_cca_1.ccaud10 = l_str[34] 
                   LET g_cca_1.ccaud11 = l_str[35] 
                   LET g_cca_1.ccaud12 = l_str[36]
                   LET g_cca_1.ccaud13 = l_str[37] 
                   LET g_cca_1.ccaud14 = l_str[38]
                   LET g_cca_1.ccaud15 = l_str[39] 
        IF cl_null(g_cca_1.cca01) THEN   
           CONTINUE WHILE 
        END IF
        CALL t005_ins_cca()
      END WHILE
      CALL channel_r.close()
   ELSE
      CALL t005_from_excel(m_sf,g_file)
   END IF
   CALL s_showmsg()  #lixh1

END FUNCTION
#excel格式導入
FUNCTION t005_from_excel(p_path,p_file)
   DEFINE p_path       STRING,
          p_file       STRING
   DEFINE li_result    LIKE type_file.num5,
          li_i         LIKE type_file.num5,
          li_j         LIKE type_file.num5,
          li_cnt       LIKE type_file.num5,
          ls_col_cnt   LIKE type_file.num5,
          ls_col_cnt1  LIKE type_file.num5,
          li_col_idx   LIKE type_file.num5,
          li_data_stat LIKE type_file.num5,
          li_data_end  LIKE type_file.num5,
          l_str1       STRING,
          ls_cell      STRING,
          ls_cell2     STRING,
          ls_cell_r    STRING,
          ls_cell_c    STRING,
          ls_cell_r2   STRING,
          ls_value     STRING
   DEFINE lr_loc          DYNAMIC ARRAY OF RECORD
             loc1         LIKE type_file.chr10,
             loc2         LIKE type_file.chr10
                     END RECORD
   DEFINE l_count    LIKE type_file.num5
   
   LET p_path=cl_replace_str(p_path,"/","\\")
   LET p_file=p_file,".xls"
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
 
   CALL ui.Interface.frontCall("standard","shellexec",[p_path] ,li_result)
   CALL axct005_checkError(li_result,"Open File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",p_file],[li_result])
   CALL axct005_checkError(li_result,"Connect File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
   CALL axct005_checkError(li_result,"Connect Sheet1")
 
   MESSAGE p_file," File Analyze..."
   
   #準備解Excel內的資料
   #第一階段搜尋
   LET li_col_idx = 1
   LET li_i=1
   WHILE TRUE   #1->excel中的栏位数
      #判断第一行第li_i列是否有值,如果有值说明需要抓取改列一下资料,否则列到此结束
      LET ls_cell_c=li_i
      LET ls_cell = "R1C",ls_cell_c.trim()
      CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",p_file,ls_cell],[li_result,ls_value])
      CALL axct005_checkError(li_result,"Peek Cells")
      LET ls_value = ls_value.trim()
      IF ls_value.getIndexOf("\"",1) THEN
         LET ls_value = cl_replace_str(ls_value,'"','@#$%')
         LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
      END IF
      IF ls_value.getIndexOf("'",1) THEN
         LET ls_value = cl_replace_str(ls_value,"'","@#$%")
         LET ls_value = cl_replace_str(ls_value,"@#$%","''")
      END IF
      IF cl_null(ls_value) THEN EXIT WHILE END IF
      
      #直接默认取列，直向
      #R2C1  第二行第一列开始
      #將抓到的資料放到lr_data
      LET li_cnt = 1
      LET li_j=2
      WHILE TRUE
          LET ls_value = ""
          LET ls_cell_r = li_j
          LET ls_cell = "R",ls_cell_r.trim(),"C",ls_cell_c.trim()
          CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",p_file,ls_cell],[li_result,ls_value])
          CALL axct005_checkError(li_result,"Peek Cells")
          LET ls_value = ls_value.trim()
          IF ls_value.getIndexOf("\"",1) THEN
             LET ls_value = cl_replace_str(ls_value,'"','@#$%')
             LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
          END IF
          IF ls_value.getIndexOf("'",1) THEN
             LET ls_value = cl_replace_str(ls_value,"'","@#$%")
             LET ls_value = cl_replace_str(ls_value,"@#$%","''")
          END IF

             CASE li_col_idx
                WHEN 1
                   LET lr_data[li_cnt].cca01 = ls_value
                WHEN 2
                   LET lr_data[li_cnt].cca02= ls_value
                WHEN 3
                   LET lr_data[li_cnt].cca03 = ls_value
                WHEN 4
                   LET lr_data[li_cnt].cca06 = ls_value
                WHEN 5
                   LET lr_data[li_cnt].cca07 = ls_value
                WHEN 6
                   LET lr_data[li_cnt].cca11 = ls_value
                WHEN 7
                   LET lr_data[li_cnt].cca12a = ls_value
                WHEN 8
                   LET lr_data[li_cnt].cca12b = ls_value
                WHEN 9
                   LET lr_data[li_cnt].cca12c = ls_value
                WHEN 10
                   LET lr_data[li_cnt].cca12d = ls_value
                WHEN 11
                   LET lr_data[li_cnt].cca12e = ls_value
                WHEN 12
                   LET lr_data[li_cnt].cca12f= ls_value
                WHEN 13
                   LET lr_data[li_cnt].cca12g = ls_value
                WHEN 14
                   LET lr_data[li_cnt].cca12h = ls_value
                WHEN 15
                   LET lr_data[li_cnt].cca12 = ls_value
                WHEN 16
                   LET lr_data[li_cnt].cca23a = ls_value     
                WHEN 17
                   LET lr_data[li_cnt].cca23b = ls_value
                WHEN 18
                   LET lr_data[li_cnt].cca23c = ls_value
                WHEN 19
                   LET lr_data[li_cnt].cca23d = ls_value
                WHEN 20
                   LET lr_data[li_cnt].cca23e = ls_value
                WHEN 21
                   LET lr_data[li_cnt].cca23f= ls_value
                WHEN 22
                   LET lr_data[li_cnt].cca23g = ls_value
                WHEN 23
                   LET lr_data[li_cnt].cca23h = ls_value
                WHEN 24
                   LET lr_data[li_cnt].cca23 = ls_value
                WHEN 25
                   LET lr_data[li_cnt].ccaud01 = ls_value
                WHEN 26
                   LET lr_data[li_cnt].ccaud02 = ls_value   
                WHEN 27
                   LET lr_data[li_cnt].ccaud03 = ls_value
                WHEN 28
                   LET lr_data[li_cnt].ccaud04 = ls_value 
                WHEN 29
                   LET lr_data[li_cnt].ccaud05 = ls_value
                WHEN 30
                   LET lr_data[li_cnt].ccaud06 = ls_value 
                WHEN 31
                   LET lr_data[li_cnt].ccaud07 = ls_value
                WHEN 32
                   LET lr_data[li_cnt].ccaud08 = ls_value 
                WHEN 33
                   LET lr_data[li_cnt].ccaud09 = ls_value
                WHEN 34
                   LET lr_data[li_cnt].ccaud10 = ls_value 
                WHEN 35
                   LET lr_data[li_cnt].ccaud11 = ls_value
                WHEN 36
                   LET lr_data[li_cnt].ccaud12 = ls_value    
                WHEN 37
                   LET lr_data[li_cnt].ccaud13 = ls_value
                WHEN 38
                   LET lr_data[li_cnt].ccaud14 = ls_value  
                WHEN 39
                   LET lr_data[li_cnt].ccaud15 = ls_value                  
             END CASE

         #判斷行是否到此結束
          IF cl_null(lr_data[li_cnt].cca01) THEN
             EXIT WHILE
          END IF          
          LET li_j=li_j+1 
          LET li_cnt = li_cnt + 1
      END WHILE
      LET li_col_idx = li_col_idx + 1
      LET li_i=li_i+1
   END WHILE
   CALL lr_data.deleteElement(li_cnt)
   FOR li_i = 1 TO lr_data.getLength()
                   LET g_cca_1.cca01 = lr_data[li_i].cca01  
                   LET g_cca_1.cca02 = lr_data[li_i].cca02 
                   LET g_cca_1.cca03 = lr_data[li_i].cca03 
                   LET g_cca_1.cca06 = lr_data[li_i].cca06 
                   LET g_cca_1.cca07 = lr_data[li_i].cca07 
                   LET g_cca_1.cca11 = lr_data[li_i].cca11 
                   LET g_cca_1.cca12a = lr_data[li_i].cca12a 
                   LET g_cca_1.cca12b = lr_data[li_i].cca12b 
                   LET g_cca_1.cca12c = lr_data[li_i].cca12c 
                   LET g_cca_1.cca12d = lr_data[li_i].cca12d  
                   LET g_cca_1.cca12e = lr_data[li_i].cca12e  
                   LET g_cca_1.cca12f = lr_data[li_i].cca12f 
                   LET g_cca_1.cca12g = lr_data[li_i].cca12g  
                   LET g_cca_1.cca12h = lr_data[li_i].cca12h  
                   LET g_cca_1.cca12 = lr_data[li_i].cca12  
                   LET g_cca_1.cca23a = lr_data[li_i].cca23a  
                   LET g_cca_1.cca23b = lr_data[li_i].cca23b  
                   LET g_cca_1.cca23c = lr_data[li_i].cca23c  
                   LET g_cca_1.cca23d = lr_data[li_i].cca23d  
                   LET g_cca_1.cca23e = lr_data[li_i].cca23e  
                   LET g_cca_1.cca23f = lr_data[li_i].cca23f 
                   LET g_cca_1.cca23g = lr_data[li_i].cca23g  
                   LET g_cca_1.cca23h = lr_data[li_i].cca23h  
                   LET g_cca_1.cca23 = lr_data[li_i].cca23  
                   LET g_cca_1.ccaud01 = lr_data[li_i].ccaud01  
                   LET g_cca_1.ccaud02 = lr_data[li_i].ccaud02 
                   LET g_cca_1.ccaud03 = lr_data[li_i].ccaud03  
                   LET g_cca_1.ccaud04 = lr_data[li_i].ccaud04  
                   LET g_cca_1.ccaud05 = lr_data[li_i].ccaud05  
                   LET g_cca_1.ccaud06 = lr_data[li_i].ccaud06  
                   LET g_cca_1.ccaud07 = lr_data[li_i].ccaud07 
                   LET g_cca_1.ccaud08 = lr_data[li_i].ccaud08 
                   LET g_cca_1.ccaud09 = lr_data[li_i].ccaud09  
                   LET g_cca_1.ccaud10 = lr_data[li_i].ccaud10  
                   LET g_cca_1.ccaud11 = lr_data[li_i].ccaud11  
                   LET g_cca_1.ccaud12 = lr_data[li_i].ccaud12  
                   LET g_cca_1.ccaud13 = lr_data[li_i].ccaud13 
                   LET g_cca_1.ccaud14 = lr_data[li_i].ccaud14  
                   LET g_cca_1.ccaud15 = lr_data[li_i].ccaud15  
       CALL t005_ins_cca()
   END FOR
#  CALL s_showmsg()  #lixh1
   #關閉Excel寫入
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result])
   CALL axct005_checkError(li_result,"Finish")
END FUNCTION

#插入資料庫
FUNCTION t005_ins_cca()
   DEFINE l_sql    STRING
   DEFINE l_ima    RECORD LIKE ima_file.*
   DEFINE l_chr    LIKE type_file.chr1,
          l_bdate  LIKE sma_file.sma53,
          l_edate  LIKE sma_file.sma53,
          l_pjb09  LIKE pjb_file.pjb09,
          l_pjb11  LIKE pjb_file.pjb11,
          l_n      LIKE type_file.num5,
          l_cnt    LIKE type_file.num5,
          l_pja01  LIKE pja_file.pja01,
          l_imd09  LIKE imd_file.imd09,
          l_msg    STRING
   DEFINE l_cca03  LIKE cca_file.cca03  #20131209 add by suncx
   DEFINE l_cca02  LIKE cca_file.cca02  #20131209 add by suncx

   LET g_success = 'Y'  #TQC-D90042 add
   IF cl_null(g_cca_1.cca01) OR cl_null(g_cca_1.cca02) OR cl_null(g_cca_1.cca03) THEN
      LET g_success='N'
      CALL s_errmsg('','','','aim-927',1)
   END IF 
   SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_cca_1.cca01
   IF STATUS THEN
      LET g_success='N'
      CALL s_errmsg('cca01',g_cca_1.cca01,'','axc-204',1)
   END IF   
   IF NOT s_chk_item_no(g_cca_1.cca01,'') THEN
      LET g_success='N'
      CALL s_errmsg('cca01',g_cca_1.cca01,'',g_errno,1)
   END IF 
   IF g_cca_1.cca02 <= 0 THEN
      LET l_msg = NULL        #TQC-D90016 add
      LET l_msg = g_cca_1.cca01,"/",g_cca_1.cca02,"/",g_cca_1.cca03   #TQC-D90016 add
      CALL s_errmsg('cca01,cca02',l_msg,'','axc-207',1)
      LET g_success='N'
   END IF  
   IF g_cca_1.cca03 <= 0 THEN
      LET l_msg = NULL
      LET l_msg = g_cca_1.cca01,"/",g_cca_1.cca02,"/",g_cca_1.cca03
      CALL s_errmsg(',cca01,cca03',l_msg,'','axc-207',1)
      LET g_success='N'
   END IF          
   IF NOT cl_null(g_cca_1.cca02) AND NOT cl_null(g_cca_1.cca03) THEN          
       #131129 add by suncx str------------
       IF g_cca_1.cca03 >= 12 THEN
          LET l_cca02 = g_cca_1.cca02 + 1
          LET l_cca03 = 1
       ELSE
          LET l_cca02 = g_cca_1.cca02
          LET l_cca03 = g_cca_1.cca03 + 1
       END IF
       #131129 add by suncx end------------
       SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      #CALL s_azm(g_cca_1.cca02,g_cca_1.cca03) RETURNING l_chr,l_bdate,l_edate
       CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate #131129 add by suncx
       IF l_edate <= g_sma.sma53 THEN
          LET l_msg = NULL 
          LET l_msg = g_cca_1.cca01,"/",g_cca_1.cca02,"/",g_cca_1.cca03
          CALL s_errmsg('cca01,cca02,cca03',l_msg,'','alm1561',1)
          LET g_success='N'
       END IF  
   END IF 
   IF NOT cl_null(g_cca_1.cca03) THEN
      IF cl_null(g_cca_1.cca07) THEN LET g_cca_1.cca07 = ' ' END IF  #TQC-D90042
      SELECT COUNT(*) INTO l_n FROM cca_file
        WHERE cca01 = g_cca_1.cca01
          AND cca02 = g_cca_1.cca02 
          AND cca03 = g_cca_1.cca03
          AND cca06 = g_cca_1.cca06 
          AND cca07 = g_cca_1.cca07  
      IF l_n > 0 THEN                  
          LET l_msg = NULL
          LET l_msg = g_cca_1.cca01,"/",g_cca_1.cca02,"/",g_cca_1.cca03,"/",g_cca_1.cca06,"/",g_cca_1.cca07
          CALL s_errmsg('cca01,cca02,cca03,cca06,cca07',l_msg,'',-239,1)
          LET g_success='N'
      END IF
   END IF     
   IF g_cca_1.cca06 NOT MATCHES '[123456]' THEN     
      LET g_success='N'
   END IF
   IF g_cca_1.cca06 MATCHES'[126]' THEN         
      LET g_cca_1.cca07 = ' '    #是報錯還是直接賦值空
   END IF 
   IF NOT cl_null(g_cca_1.cca07) OR g_cca_1.cca07 != ' '  THEN
      IF g_cca_1.cca06='4'THEN
         SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_cca_1.cca07
                                                   AND pjaclose='N'  
         IF STATUS THEN
            LET g_success='N'
         END IF
      END IF
      IF g_cca_1.cca06='5'THEN
         SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=g_cca_1.cca07
         IF STATUS THEN
            LET g_success='N'
         END IF
      END IF
   ELSE
      LET g_cca_1.cca07 = ' '
   END IF               
   IF cl_null(g_cca_1.cca07) THEN LET g_cca_1.cca07 = ' ' END IF           

   IF cl_null(g_cca_1.cca02) THEN
      LET l_msg = NULL
      LET l_msg = g_cca_1.cca01,"/",g_cca_1.cca02,"/",g_cca_1.cca03
      LET g_success='N'
      CALL s_errmsg('cca01,cca02,cca03',l_msg,'','aim-927',1)
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM cca_file 
       WHERE cca01=g_apa.apa01 AND cca02=g_cca_1.cca02
      IF l_cnt>0 THEN
         LET g_success='N' 
         LET l_msg = NULL
         LET l_msg =g_cca_1.cca01,"/",g_cca_1.cca02,"/",g_cca_1.cca03,"/",g_cca_1.cca06,"/",g_cca_1.cca07
         CALL s_errmsg('cca01,cca02,cca03,cca06,cca07',l_msg,'','mfg-240',1)
      END IF
   END IF 
   IF cl_null(g_cca_1.cca07) THEN LET g_cca_1.cca07 = ' ' END IF
   IF cl_null(g_cca_1.cca11) THEN LET g_cca_1.cca11 = 0 END IF
   IF cl_null(g_cca_1.cca12) THEN LET g_cca_1.cca12 = 0 END IF
   IF cl_null(g_cca_1.cca12a) THEN LET g_cca_1.cca12a = 0 END IF
   IF cl_null(g_cca_1.cca12b) THEN LET g_cca_1.cca12b = 0 END IF
   IF cl_null(g_cca_1.cca12c) THEN LET g_cca_1.cca12c = 0 END IF
   IF cl_null(g_cca_1.cca12d) THEN LET g_cca_1.cca12d = 0 END IF
   IF cl_null(g_cca_1.cca12e) THEN LET g_cca_1.cca12e = 0 END IF
   IF cl_null(g_cca_1.cca12f) THEN LET g_cca_1.cca12f = 0 END IF
   IF cl_null(g_cca_1.cca12g) THEN LET g_cca_1.cca12g = 0 END IF
   IF cl_null(g_cca_1.cca12h) THEN LET g_cca_1.cca12h = 0 END IF
   IF cl_null(g_cca_1.cca23) THEN LET g_cca_1.cca23 = 0 END IF
   IF cl_null(g_cca_1.cca23a) THEN LET g_cca_1.cca23a = 0 END IF 
   IF cl_null(g_cca_1.cca23b) THEN LET g_cca_1.cca23b = 0 END IF
   IF cl_null(g_cca_1.cca23c) THEN LET g_cca_1.cca23c = 0 END IF
   IF cl_null(g_cca_1.cca23d) THEN LET g_cca_1.cca23d = 0 END IF
   IF cl_null(g_cca_1.cca23e) THEN LET g_cca_1.cca23e = 0 END IF
   IF cl_null(g_cca_1.cca23f) THEN LET g_cca_1.cca23f = 0 END IF
   IF cl_null(g_cca_1.cca23g) THEN LET g_cca_1.cca23g = 0 END IF
   IF cl_null(g_cca_1.cca23h) THEN LET g_cca_1.cca23h = 0 END IF
   LET g_cca_1.ccaacti = 'Y'
   LET g_cca_1.ccalegal = g_legal
   LET g_cca_1.ccaorig = g_grup
   LET g_cca_1.ccaoriu = g_user
   LET g_cca_1.ccagrup = g_grup
   LET g_cca_1.ccauser = g_user   

   IF g_success='Y' THEN 
      INSERT INTO cca_file VALUES (g_cca_1.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
         LET l_msg = NULL
         LET l_msg=g_cca_1.cca01,'/',g_cca_1.cca02,"/",g_cca_1.cca03,"/",g_cca_1.cca06,"/",g_cca_1.cca07
         CALL s_errmsg('cca01,cca02,cca03,cca06,cca07',l_msg,'',SQLCA.sqlcode,1)
         LET g_cnt=g_cnt+1
      ELSE
         LET g_totsuccess = 'Y'
         #記錄成功筆數
         LET g_n=g_n+1
      END IF
   ELSE 
      #記錄失敗筆數
      LET g_cnt=g_cnt+1
   END IF  
END FUNCTION

FUNCTION t005_excelexample(n,t,p_show_hidden)
 DEFINE  t,t1,t2,n1_text,n3_text         om.DomNode,
         n,n2,n_child                    om.DomNode,
         p_show_hidden                   LIKE type_file.chr1,    #隱藏欄位是否顯示
         n1,n_table,n3                   om.NodeList,
         i,res,p,q,k                     LIKE type_file.num10,   
         h                               LIKE type_file.num10,   
         cnt_combo_data,cnt_combo_tot    LIKE type_file.num10,   
         cells,values,j,l,sheet,cc       STRING, 
         table_name,l_length             STRING,   
         l_table_name                    LIKE gac_file.gac05,     
         l_datatype                      LIKE type_file.chr20,    
         l_bufstr                        base.StringBuffer,
         lwin_curr                       ui.Window,
         l_show                          LIKE type_file.chr1,    
         l_time                          LIKE type_file.chr8     
 
 DEFINE  combo_arr        DYNAMIC ARRAY OF RECORD 
           sheet          LIKE type_file.num10,    
           seq            LIKE type_file.num10,    
           name           LIKE type_file.chr2,     
           text           LIKE type_file.chr50     
                          END RECORD
 DEFINE  customize_table  LIKE type_file.chr1   
 DEFINE  l_str            STRING                  
 DEFINE  l_i              LIKE type_file.num5     
 DEFINE  buf              base.StringBuffer       
 DEFINE  l_dec_point      STRING,                 
         l_qry_name       LIKE gab_file.gab01,    
         l_cust           LIKE gab_file.gab11     
 DEFINE  l_tabIndex       LIKE type_file.num10    
 DEFINE  l_seq            DYNAMIC ARRAY OF LIKE type_file.num10  
 DEFINE  l_seq2           DYNAMIC ARRAY OF LIKE type_file.num10 
 DEFINE  l_j              LIKE type_file.num5     
 DEFINE  bFound           LIKE type_file.num5     
 DEFINE  l_dbname         STRING                  
 DEFINE  l_zal09          LIKE zal_file.zal09     
 DEFINE  l_desc           STRING                  

   WHENEVER ERROR CALL cl_err_msg_log           

   LET cnt_table = 1  
 
   LET l_bufstr = base.StringBuffer.create()
   WHENEVER ERROR CALL cl_err_msg_log 
   LET lwin_curr = ui.window.getCurrent()  
 
   LET l_channel = base.Channel.create()
   LET l_time = TIME(CURRENT)
   LET xls_name = g_prog CLIPPED,l_time CLIPPED,".xls"

   LET buf = base.StringBuffer.create()
   CALL buf.append(xls_name)
   CALL buf.replace( ":","-", 0)
   LET xls_name = buf.toString()
 
   # 個資會記錄使用者的行為模式，在此說明excel的檔名及匯出excel的方式
   LET l_desc = xls_name CLIPPED," Using HTML to export the Table to excel."

   IF os.Path.delete(xls_name CLIPPED) THEN END IF    
   CALL l_channel.openFile( xls_name CLIPPED, "a" )
   CALL l_channel.setDelimiter("")
 
   IF ms_codeset.getIndexOf("BIG5", 1) OR
      ( ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) THEN
      IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
         LET tsconv_cmd = "big5_to_gb2312"
         LET ms_codeset = "GB2312"
      END IF
      IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
         LET tsconv_cmd = "gb2312_to_big5"
         LET ms_codeset = "BIG5"
      END IF
   END IF
 
   LET l_str = "<html xmlns:o=",g_quote,"urn:schemas-microsoft-com:office:office",g_quote
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "<meta http-equiv=Content-Type content=",g_quote,"text/html; charset=",ms_codeset,g_quote,">"
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "xmlns:x=",g_quote,"urn:schemas-microsoft-com:office:excel",g_quote
   CALL l_channel.write(l_str CLIPPED)
   LET l_str = "xmlns=",g_quote,"http://www.w3.org/TR/REC-html40",g_quote,">"
   CALL l_channel.write(l_str CLIPPED)
   CALL l_channel.write("<head><style><!--")

   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN
      IF g_lang = "0" THEN  #繁體中文
         CALL l_channel.write("td  {font-family:細明體, serif;}")
      ELSE
         IF g_lang = "2" THEN  #簡體中文
            CALL l_channel.write("td  {font-family:新宋体, serif;}")
         ELSE
            CALL l_channel.write("td  {font-family:細明體, serif;}")
         END IF
      END IF
   ELSE
      CALL l_channel.write("td  {font-family:Courier New, serif;}")
   END IF
 
   LET l_str = ".xl24  {mso-number-format:",g_quote,"\@",g_quote,";}",
               ".xl30 {mso-style-parent:style0; mso-number-format:\"0_ \";} ",
               ".xl31 {mso-style-parent:style0; mso-number-format:\"0\.0_ \";} ",
               ".xl32 {mso-style-parent:style0; mso-number-format:\"0\.00_ \";} ",
               ".xl33 {mso-style-parent:style0; mso-number-format:\"0\.000_ \";} ",
               ".xl34 {mso-style-parent:style0; mso-number-format:\"0\.0000_ \";} ",
               ".xl35 {mso-style-parent:style0; mso-number-format:\"0\.00000_ \";} ",
               ".xl36 {mso-style-parent:style0; mso-number-format:\"0\.000000_ \";} ",
               ".xl37 {mso-style-parent:style0; mso-number-format:\"0\.0000000_ \";} ",
               ".xl38 {mso-style-parent:style0; mso-number-format:\"0\.00000000_ \";} ",
               ".xl39 {mso-style-parent:style0; mso-number-format:\"0\.000000000_ \";} ",
               ".xl40 {mso-style-parent:style0; mso-number-format:\"0\.0000000000_ \";} "
   CALL l_channel.write(l_str CLIPPED)
   CALL l_channel.write("--></style>")
   CALL l_channel.write("<!--[if gte mso 9]><xml>")
   CALL l_channel.write("<x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>")
   CALL l_channel.write("<x:DefaultRowHeight>330</x:DefaultRowHeight>")
   CALL l_channel.write("</xml><![endif]--></head>")
   CALL l_channel.write("<body><table border=1 cellpadding=0 cellspacing=0 width=432 style='border-collapse: collapse;table-layout:fixed;width:324pt'>")
   CALL l_channel.write("<tr height=22>")         
 
   LET l_win_name = NULL  
   LET l_win_name = n.getAttribute("name")
 
   LET n_table = n.selectByTagName("Table")
   CALL combo_arr.clear()
   FOR h=1 to cnt_table
      CALL g_hidden.clear()  
      CALL g_ifchar.clear()  
      CALL g_mask.clear()    
      LET n2 = n_table.item(h)
 
      IF l_win_name = "p_dbqry_table" THEN
         LET n1 = n2.selectByPath("//TableColumn[@hidden=\"0\"]")
      ELSE
         LET n1 = n2.selectByTagName("TableColumn")
      END IF
 
      #抓取 table 是否有進行欄位排序
      INITIALIZE g_sort.* TO NULL
      LET g_sort.column = n2.getAttribute("sortColumn")      
      IF g_sort.column >=0 AND g_sort.column IS NOT NULL  THEN
         LET g_sort.column = g_sort.column + 1    #屬性 sortColumn 為 0 開始
         LET g_sort.type = n2.getAttribute("sortType")            
      END IF
 
      LET cnt_header = n1.getLength()
      LET l = h
      LET sheet=g_sheet  CLIPPED,l  
      LET k = 0                   
 
      CALL l_seq.clear()                       
      CALL l_seq2.clear() 

     #循環Table中的每一個列       
     FOR i=1 TO cnt_header
       #得到對應的DomNode節點
       LET n1_text = n1.item(i)
       #得到該列的TabIndex屬性                                                                                                  
       LET l_tabIndex = n1_text.getAttribute("tabIndex")  
       
       #如果TabIndex屬性不為空
       IF NOT cl_null(l_tabIndex) THEN                  
          #初始化一個標志變量（表明是否在數組中找到比當前TabIndex更大的節點）
          LET bFound = FALSE
          #開始在已有的數組中定位比當前tabIndex大的成員
          FOR l_j=1 TO l_seq2.getLength()
              #如果有找到
              IF l_seq2[l_j] > l_tabIndex THEN
                 #設置標志變量
                 LET bFound = TRUE
                 #退出搜尋過程（此時下標j保存的該成員變量的位置）
                 EXIT FOR
              END IF
          END FOR
          #如果始終沒有找到（比如數組根本就是空的）那麼j里面保存的就是當前數組最大下標+1
          #判斷有沒有找到
          IF bFound THEN
             #如果找到則向該數組中插入一個元素（在這個tabIndex比它大的元素前面插入)
             CALL l_seq2.InsertElement(l_j)
             CALL l_seq.InsertElement(l_j)
          END IF
          #把當前的下標（列的位置）和tabIndex填充到這個位置上
          #如果沒有找到，則填充的位置會是整個數組的末尾
          LET l_seq[l_j] = i
          LET l_seq2[l_j] = l_tabIndex
       END IF                                                                                                 
     END FOR

      FOR i=1 to cnt_header
         LET n1_text = n1.item(l_seq[i])
         LET k = k + 1                
         LET j = k                    
         LET cells = "R1C" CLIPPED,j
         LET l_field_name = NULL
         LET l_show = n1_text.getAttribute("hidden")
         IF ((p_show_hidden = 'N' OR p_show_hidden IS NULL) AND (l_show = "0" OR l_show IS NULL)) OR p_show_hidden = 'Y' THEN  
            LET l_field_name = n1_text.getAttribute("name")
            IF l_field_name = 'cca_file.cca01' OR l_field_name = 'cca_file.cca02' OR
               l_field_name = 'cca_file.cca03' OR l_field_name = 'cca_file.cca06' OR
               l_field_name = 'cca_file.cca07' OR l_field_name = 'cca_file.cca11' OR
               l_field_name = 'cca_file.cca12a' OR l_field_name = 'cca_file.cca12b' OR
               l_field_name = 'cca_file.cca12c' OR l_field_name = 'cca_file.cca12d' OR
               l_field_name = 'cca_file.cca12e' OR l_field_name = 'cca_file.cca12f' OR
               l_field_name = 'cca_file.cca12g' OR l_field_name = 'cca_file.cca12h' OR
               l_field_name = 'cca_file.cca12' OR l_field_name = 'cca_file.cca23a' OR
               l_field_name = 'cca_file.cca23b' OR l_field_name = 'cca_file.cca23c' OR
               l_field_name = 'cca_file.cca23d' OR l_field_name = 'cca_file.cca23e' OR
               l_field_name = 'cca_file.cca23f' OR l_field_name = 'cca_file.cca23g' OR
               l_field_name = 'cca_file.cca23h' OR l_field_name = 'cca_file.cca23'
               THEN
               LET values = n1_text.getAttribute("text")
               LET l_str = "<td>",cl_add_span(values),"</td>"
               CALL l_channel.write(l_str CLIPPED)
            END IF
         ELSE    
            LET g_hidden[i] = "1"
            LET k = k -1  
         END IF
      END FOR
      IF h=1 THEN CALL axct005_get_body(h,cnt_header,t,combo_arr,l_seq) END IF
 
   END FOR

   # 使用者的行為模式改到前面判斷，在此僅將前面判斷的結果說明傳至syslog中做紀錄
   IF cl_syslog("A","G",l_desc) THEN     
   END IF

END FUNCTION

###############################################################
## Descriptions...: 匯出excel時，以畫面檔的isPassword為隱藏條件
## Input parameter: n1_text  DomNode節點
## Return code....: Boolean
###############################################################
FUNCTION axct005_chk_mask(n1_text)   
   DEFINE n1_text        om.DomNode
   DEFINE n1             om.DomNode
   
   LET n1 = n1_text.getFirstChild()
   IF n1.getAttribute("isPassword") = "1" THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION

FUNCTION axct005_get_body(p_h,p_cnt_header,s,s_combo_arr,p_seq) 
 DEFINE  s,n1_text                          om.DomNode,
         n1                                 om.NodeList,
         i,m,k,cnt_body,res,p               LIKE type_file.num10,    
         l_hidden_cnt,n,l_last_hidden       LIKE type_file.num10,   
         p_h,p_cnt_header,arr_len           LIKE type_file.num10,    
         p_null                             LIKE type_file.num10,    
         cells,values,j,l,sheet             STRING,
         l_bufstr                           base.StringBuffer
 
 DEFINE  s_combo_arr    DYNAMIC ARRAY OF RECORD
          sheet         LIKE type_file.num10,       #sheet
          seq           LIKE type_file.num10,       #項次
          name          LIKE type_file.chr2,        #代號
          text          LIKE type_file.chr50        #說明
                        END RECORD
 DEFINE  p_seq          DYNAMIC ARRAY OF LIKE type_file.num10 
 DEFINE  l_item         LIKE type_file.num10     
 
 DEFINE  unix_path      STRING,                 
         window_path    STRING                  
 DEFINE  l_dom_doc      om.DomDocument,        
         r,n_node       om.DomNode              
 DEFINE  l_status       LIKE type_file.num5     
 
   LET l_hidden_cnt = 0      
   LET l = p_h
   LET sheet=g_sheet CLIPPED,l   
   LET l_bufstr = base.StringBuffer.create()
   LET l = 0
   LET i = 0 
   LET m = 0
 
   CALL l_channel.write("</tr></table></body></html>")
   CALL l_channel.close()
   CALL cl_prt_convert(xls_name)  
   IF cl_null(g_aza.aza56) THEN
     UPDATE aza_file set aza56='1'
     IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","aza_file","1","",SQLCA.sqlcode,"","",0) 
             RETURN
     END IF
     LET g_aza.aza56 = '1'
   END IF
 
   IF g_aza.aza56 = '2' THEN
        LET unix_path = os.Path.join(FGL_GETENV("TEMPDIR"),xls_name CLIPPED)
 
        LET window_path = "c:\\tiptop\\",xls_name CLIPPED
        LET status = cl_download_file(unix_path, window_path)
        IF status then
           DISPLAY "Download OK!!"
        ELSE
           DISPLAY "Download fail!!"
        END IF
 
        LET status = cl_open_prog("excel",window_path)
        IF status then
           DISPLAY "Open OK!!"
        ELSE
           DISPLAY "Open fail!!"
        END IF
   ELSE
        #此處為組出 URL Address,不需代換
        LET l_str = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", xls_name CLIPPED
        IF g_prog!="p_thousand" THEN
           CALL ui.Interface.frontCall("standard",
                                    "shellexec",
                                    ["EXPLORER \"" || l_str || "\""],
                                    [res])
        END IF
        IF STATUS THEN
           CALL cl_err("Front End Call failed.", STATUS, 1)
           RETURN
        END IF
   END IF
END FUNCTION

FUNCTION axct005_checkerror(res,p_msg)
   DEFINE res  LIKE type_file.num10    
   DEFINE mess STRING
   DEFINE p_msg      STRING
   
   IF res THEN RETURN END IF
   DISPLAY p_msg," DDE Error:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[mess]);
   DISPLAY mess
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll", [], [res] );
   DISPLAY "Exit with DDE Error."
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   EXIT PROGRAM (-1)
END FUNCTION

FUNCTION axct005_getsheetname()
   DEFINE   l_rval  STRING                       
   DEFINE   l_val   STRING                       
   DEFINE   l_val1  STRING                       
   DEFINE   l_str1  STRING 
   DEFINE   res     LIKE type_file.num10
   DEFINE   l_i     LIKE type_file.num5
   DEFINE   l_sheet STRING
   
      CALL ui.Interface.frontCall("WINDDE","DDEConnect", ["excel", "system"], res )
      CALL axct005_checkerror(res,'')
      CALL ui.Interface.frontCall("WINDDE","DDEPeek", ["excel","system","topics"], [res,l_rval] );
      IF l_rval IS NOT NULL THEN 
         LET l_val=l_rval.getIndexOf("]",1)
         LET l_rval=l_rval.subString(l_val+1,length(l_rval))
         LET l_val=l_rval.getIndexOf("]",1)
         LET l_rval=l_rval.subString(l_val+1,length(l_rval))
         LET l_val1=l_rval.getIndexOf("[",1)
         LET l_sheet=l_rval.subString(1,l_val1-1) 
      END IF 
      CALL axct005_checkerror(res,'')
      FOR l_i=1 TO l_sheet.getlength()
         LET l_str1=l_sheet.getCharAt(l_i)
         IF ORD(l_str1) > 47 AND ORD(l_str1) < 58 THEN 
            LET l_sheet=l_sheet.subString(1,l_i-1)
            EXIT FOR 
         END IF 
      END FOR
      CALL ui.Interface.frontCall("WINDDE","DDEFinish", ["EXCEL","system"], [res] );
      RETURN l_sheet
END FUNCTION
 
FUNCTION t005_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL g_cca.clear()
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t005_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t005_count
    FETCH t005_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL t005_b_fill(" 1=1")                  # 讀出TEMP第一筆並顯示
END FUNCTION

FUNCTION t005_b_fill(p_wc)               
DEFINE
    p_wc           LIKE type_file.chr1000  
    
    IF cl_null(g_wc) THEN LET g_wc = " 1 = 1 "  END IF

    LET g_sql = "SELECT cca01,ima02,ima021,ima25,cca02,cca03,cca06,cca07,cca11,cca12a,cca12b,cca12c,",
                "       cca12d,cca12e,cca12f,cca12g,cca12h,cca12,cca23a,cca23b,cca23c,cca23d,cca23e,",
                "       cca23f,cca23g,cca23h,cca23,ccaud01,ccaud02,ccaud03,ccaud04,ccaud05,ccaud06,",
                "       ccaud07,ccaud08,ccaud09,ccaud10,ccaud11,ccaud12,ccaud13,ccaud14,ccaud15 ",
                "  FROM cca_file LEFT OUTER JOIN ima_file ON cca01 = ima01 ",
                " WHERE ", p_wc CLIPPED,
                "   AND ", g_wc CLIPPED,                      
                " ORDER BY cca02 desc,cca03 desc,cca01"
    PREPARE t005_pb FROM g_sql
    DECLARE cca_curs CURSOR FOR t005_pb

    CALL g_cca.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH cca_curs INTO g_cca[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF

    END FOREACH
    MESSAGE ""
    CALL g_cca.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0

END FUNCTION
 
FUNCTION t005_out()
    DEFINE
        l_i             LIKE type_file.num5,           
        l_name          LIKE type_file.chr20,          
        l_za05          LIKE ima_file.ima01,         
        l_cca RECORD LIKE cca_file.*,
        sr RECORD
           ima02  LIKE ima_file.ima02,
           ima021 LIKE ima_file.ima021,    
           ima25  LIKE ima_file.ima25
           END RECORD
 
    IF g_wc IS NULL THEN
       IF cl_null(g_cca[l_ac].cca01) THEN 
          CALL cl_err('','9057',0) RETURN 
       ELSE
          LET g_wc=" cca01='",g_cca[l_ac].cca01,"'"
       END IF
       IF NOT cl_null(g_cca[l_ac].cca02) THEN
          LET g_wc=g_wc," and cca02=",g_cca[l_ac].cca02
       END IF
       IF NOT cl_null(g_cca[l_ac].cca03) THEN
          LET g_wc=g_wc," and cca03=",g_cca[l_ac].cca03
       END IF 
       IF NOT cl_null(g_cca[l_ac].cca06) THEN
          LET g_wc=g_wc," and cca06=",g_cca[l_ac].cca06
       END IF
       IF NOT cl_null(g_cca[l_ac].cca07) THEN
          LET g_wc=g_wc," and cca07=",g_cca[l_ac].cca07
       END IF
    END IF
 
    CALL cl_wait()
    CALL cl_outnam('axct005') RETURNING l_name 
 
    CALL cl_del_data(l_table) 
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,? )"    #No.FUN-830135 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cca_file.*, ima02,ima021,ima25 ",   #FUN-5C0002
              "  FROM cca_file LEFT OUTER JOIN ima_file ON cca01=ima_file.ima01 ",
              " WHERE  ",g_wc CLIPPED
    PREPARE t005_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t005_co CURSOR FOR t005_p1
 
 
    FOREACH t005_co INTO l_cca.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        EXECUTE insert_prep USING l_cca.cca01,sr.ima02,sr.ima021,sr.ima25, #No.FUN-7C0034
                            l_cca.cca02,l_cca.cca03,l_cca.cca06,l_cca.cca07,l_cca.cca11,l_cca.cca12 #No.FUN-830135
    END FOREACH

          LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #      CALL cl_wcchp(g_wc,'cca01,cca02,cca03,cca06,cca07,cca11,    #No.FUN-830135 add cca06,cca07 
   #                    cca12a, cca12b, cca12c, cca12d, cca12e, cca12,
   #                    cca23a, cca23b, cca23c, cca23d, cca23e, cca23,
   #                    ccauser,ccagrup,ccamodu,ccadate')
   #           RETURNING g_wc      
           LET g_str=g_wc clipped 
           CALL cl_prt_cs3('axct005','axct001',g_sql,g_str)
    CLOSE t005_co
    ERROR ""
END FUNCTION
 
FUNCTION t005_set_entry_b(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cca01,cca02,cca03,cca06,cca07",TRUE) 
  END IF
END FUNCTION
 
FUNCTION t005_set_no_entry_b(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          
 
  IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey MATCHES '[Nn]' THEN
     CALL cl_set_comp_entry("cca01,cca02,cca03,cca06,cca07",FALSE) 
  END IF
  IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey MATCHES '[Yy]' THEN
     IF g_cca[l_ac].cca06 MATCHES'[126]' THEN      
        CALL cl_set_comp_entry("cca07",FALSE)
     ELSE
        CALL cl_set_comp_entry("cca07",TRUE)
     END IF
  END IF
     
END FUNCTION
#FUN-D70054

#20131209 add by suncx begin--------------------------------
FUNCTION t005_chk(p_yy,p_mm)
DEFINE p_yy        LIKE type_file.num5,
       p_mm        LIKE type_file.num5
DEFINE l_bdate     LIKE type_file.dat,
       l_edate     LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_n         LIKE type_file.num5
DEFINE l_correct   LIKE type_file.chr1

      LET l_n = 0
      CALL s_azm(p_yy,p_mm) RETURNING l_correct, l_bdate, l_edate
      LET l_sql = " SELECT COUNT(*) FROM npp_file",
                  "  WHERE nppsys  = 'CA'",
                  "    AND npp011  = '1'",
                  "    AND npp00 >= 2 AND npp00 <= 7 ",
                  "    AND npp00 <> 6 ",
                  "    AND nppglno IS NOT NULL ",
                  "    AND YEAR(npp02) = ",p_yy,
                  "    AND MONTH(npp02) = ",p_mm,
                  "    AND npp03 BETWEEN '",l_bdate,"' AND '",l_edate ,"' "

      PREPARE npq_pre FROM l_sql
      DECLARE npq_cs CURSOR FOR npq_pre
      OPEN npq_cs
      FETCH npq_cs INTO l_n
      CLOSE npq_cs

      IF l_n > 0 THEN
         RETURN FALSE
      END IF
      RETURN TRUE
END FUNCTION
#20131209 add by suncx end----------------------------------
