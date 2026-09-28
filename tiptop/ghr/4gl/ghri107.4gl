# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri107.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hraj           DYNAMIC ARRAY OF RECORD    
        hraj01       LIKE hraj_file.hraj01,     
        hraj02       LIKE hraj_file.hraj02,   
        hraj03       LIKE hraj_file.hraj03,     
        hrajacti     LIKE hraj_file.hrajacti   
                    END RECORD,
    g_hraj_t         RECORD                 
        hraj01       LIKE hraj_file.hraj01,     
        hraj02       LIKE hraj_file.hraj02,   
        hraj03       LIKE hraj_file.hraj03,     
        hrajacti     LIKE hraj_file.hrajacti 
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
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
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i107_w AT p_row,p_col WITH FORM "ghr/42f/ghri107"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    

    LET g_wc2 = '1=1'
    CALL i107_b_fill(g_wc2)
    CALL i107_menu()
    CLOSE WINDOW i107_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i107_menu()
 
   WHILE TRUE
      CALL i107_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i107_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i107_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

#         WHEN "quanbu"
#            IF cl_chk_act_auth() THEN
#               CALL i107_b_fill_2(g_wc2)
#            END IF
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hraj[l_ac].hraj01 IS NOT NULL THEN
                  LET g_doc.column1 = "hraj01"
                  LET g_doc.value1 = g_hraj[l_ac].hraj01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hraj),'','')
            END IF
         WHEN "import" 
            IF cl_chk_act_auth() THEN
                 CALL i107_import()
            END IF
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i107_q()
   CALL i107_b_askkey()
END FUNCTION
	
FUNCTION i107_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hraj01,hraj02,hraj03,hrajacti",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hraj_file WHERE hraj01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i107_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hraj WITHOUT DEFAULTS FROM s_hraj.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_hraj_t.* = g_hraj[l_ac].*  #BACKUP
           OPEN i107_bcl USING g_hraj_t.hraj01
           IF STATUS THEN
              CALL cl_err("OPEN i107_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i107_bcl INTO g_hraj[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hraj_t.hraj01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hraj[l_ac].* TO NULL      #900423  
         LET g_hraj[l_ac].hrajacti = 'Y'       #Body default
         LET g_hraj_t.* = g_hraj[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hraj01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i107_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hraj_file(hraj01,hraj02,hraj03,                          #FUN-A30097
                              hrajacti)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hraj[l_ac].hraj01,g_hraj[l_ac].hraj02,
               g_hraj[l_ac].hraj03,
               g_hraj[l_ac].hrajacti) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hraj_file",g_hraj[l_ac].hraj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hraj01                        
       IF NOT cl_null(g_hraj[l_ac].hraj01) THEN       	 	  	                                            
          IF g_hraj[l_ac].hraj01 != g_hraj_t.hraj01 OR
             g_hraj_t.hraj01 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hraj_file
              WHERE hraj01 = g_hraj[l_ac].hraj01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hraj[l_ac].hraj01 = g_hraj_t.hraj01
                NEXT FIELD hraj01
             END IF
          END IF                                             	
       END IF      	
       	
   
    AFTER FIELD hrajacti
       IF NOT cl_null(g_hraj[l_ac].hrajacti) THEN
          IF g_hraj[l_ac].hrajacti NOT MATCHES '[YN]' THEN 
             LET g_hraj[l_ac].hrajacti = g_hraj_t.hrajacti
             NEXT FIELD hrajacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hraj_t.hraj01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hraj01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hraj[l_ac].hraj01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hraj_file WHERE hraj01 = g_hraj_t.hraj01
                    
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hraj_file",g_hraj_t.hraj01,g_hraj_t.hraj02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
          	 LET g_rec_b=g_rec_b-1
          	 DISPLAY g_rec_b TO cn2    
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hraj[l_ac].* = g_hraj_t.*
         CLOSE i107_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hraj[l_ac].hraj01,-263,0)
          LET g_hraj[l_ac].* = g_hraj_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hraj_file SET hraj01=g_hraj[l_ac].hraj01,
                               hraj02=g_hraj[l_ac].hraj02,
                               hraj03=g_hraj[l_ac].hraj03, 
                               hrajacti=g_hraj[l_ac].hrajacti
          WHERE hraj01 = g_hraj_t.hraj01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hraj_file",g_hraj_t.hraj01,g_hraj_t.hraj02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hraj[l_ac].* = g_hraj_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hraj[l_ac].* = g_hraj_t.*
          END IF
          CLOSE i107_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i107_bcl                
        COMMIT WORK  
 
 
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
 
    CLOSE i107_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i107_b_askkey()
    CLEAR FORM
    CALL g_hraj.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hraj01,hraj02,hraj03,hrajacti                       
         FROM s_hraj[1].hraj01,s_hraj[1].hraj02,s_hraj[1].hraj03,                                  
              s_hraj[1].hrajacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hraj01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraj01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hraj[1].hraj01
               NEXT FIELD hraj01
         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrajuser', 'hrajgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i107_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i107_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hraj01,hraj02,hraj03,hrajacti",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hraj_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i107_pb FROM g_sql
    DECLARE hraj_curs CURSOR FOR i107_pb
 
    CALL g_hraj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hraj_curs INTO g_hraj[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
         
        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
    END FOREACH
    CALL g_hraj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	

FUNCTION i107_b_fill_2(p_wc2)              #BODY FILL UP

    DEFINE p_wc2           STRING

       LET g_sql = "SELECT hraj01,hraj02,hraj03,hrajacti",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hraj_file",
                   " WHERE ", p_wc2 CLIPPED,
                   " ORDER BY 1"

    PREPARE i107_pb_2 FROM g_sql
    DECLARE hraj_curs_2 CURSOR FOR i107_pb_2

    CALL g_hraj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hraj_curs_2 INTO g_hraj[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        #IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        #END IF
    END FOREACH
    CALL g_hraj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION
	
FUNCTION i107_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hraj TO s_hraj.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
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
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
#      ON ACTION quanbu
#         LET g_action_choice="quanbu"
#         EXIT DISPLAY
   
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION import   #No.FUN-4B0020
         LET g_action_choice = 'import'
         EXIT DISPLAY
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION		   	     		
FUNCTION i107_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hraj01  LIKE hraj_file.hraj01,
         hraj02  LIKE hraj_file.hraj02,
         hraj03  LIKE hraj_file.hraj03
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE l_flag    LIKE type_file.num5,
       l_fac     LIKE ima_file.ima31_fac 
     LET g_errno = ' '
     LET l_n=0
     CALL s_showmsg_init() #初始化
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 2 TO iRow             
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hraj01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hraj02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hraj03])
                    
                 
                IF NOT cl_null(sr.hraj01) AND NOT cl_null(sr.hraj02) THEN 
                    INSERT INTO hraj_file(hraj01,hraj02,hraj03,hrajacti)
                      VALUES (sr.hraj01,sr.hraj02,sr.hraj03,'Y')
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hraj_file",sr.hraj01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                END IF 
                   LET g_cnt = g_cnt + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE 
                	IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                  END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       LET g_wc2 = '1=1'
       CALL i107_b_fill(g_wc2)
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------


