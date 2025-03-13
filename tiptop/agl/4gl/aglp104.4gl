# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglp104.4gl
# Descriptions...: 會計科目整批拋轉作業
# Input parameter:
# Date & Author..: FUN-820031 08/03/03 Sunyanchun
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
 
DATABASE ds
#FUN-820031----BEGIN
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"
 
DEFINE tm1        RECORD
                  gev04    LIKE gev_file.gev04,
                  geu02    LIKE geu_file.geu02,
                  wc       STRING
                  END RECORD
DEFINE g_rec_b	  LIKE type_file.num10
DEFINE g_cmd      LIKE type_file.chr50
DEFINE g_aag      DYNAMIC ARRAY OF RECORD 
                  sel      LIKE type_file.chr1,
                  aag00    LIKE aag_file.aag00,
                  aag01    LIKE aag_file.aag01,
                  aag02    LIKE aag_file.aag02,
                  aag13    LIKE aag_file.aag13,
                  aag04    LIKE aag_file.aag04,
                  aag07    LIKE aag_file.aag07,
                  aag08    LIKE aag_file.aag08,
                  aag24    LIKE aag_file.aag24,
                  aag05    LIKE aag_file.aag05,
                  aag21    LIKE aag_file.aag21,
                  aag23    LIKE aag_file.aag23,
                  aagacti  LIKE aag_file.aagacti
                  END RECORD
DEFINE g_aag1     DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  aag00    LIKE aag_file.aag00,
                  aag01    LIKE aag_file.aag01 
                  END RECORD
DEFINE 
       #g_sql      LIKE type_file.chr1000
       g_sql      STRING     #NO.FUN-910082
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_gev04    LIKE gev_file.gev04
MAIN
  DEFINE p_row,p_col    LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_db_type = cl_db_get_database_type()
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p100_w AT p_row,p_col
        WITH FORM "agl/42f/aglp104"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   
   SELECT * FROM gev_file WHERE gev01 = '6' AND gev02 = g_plant                 
                            AND gev03 = 'Y'                                     
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_plant,'aoo-036',1)   #Not Carry DB                          
      EXIT PROGRAM                                                              
   END IF
 
   CALL p104_tm()
   CALL p104_menu()
 
   CLOSE WINDOW p104_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p104_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL p104_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p104_tm()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL p104()
               ERROR ""
            END IF
            
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL p104_download()
            END IF
         
         WHEN "subject_detail_maintain"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  LET g_cmd = 'agli102 "',g_aag[l_ac].aag00,'" "',
                               g_aag[l_ac].aag01,'" "Y"'
                  CALL cl_cmdrun(g_cmd)
               END IF
            END IF
 
         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN                                           
#               IF NOT cl_null(g_aag[l_ac].aag39) THEN                                 
#                  SELECT gev04 INTO g_gev04 FROM gev_file                       
#                   WHERE gev01 = '6' AND gev02 = g_aag[l_ac].aag39                    
#               ELSE      #歷史資料,即沒有aag39的值                              
#                  SELECT gev04 INTO g_gev04 FROM gev_file                       
#                   WHERE gev01 = '6' AND gev02 = g_plant                        
#               END IF                                                           
#               IF NOT cl_null(g_gev04) THEN
               IF l_ac > 0 THEN                                     
                  LET l_cmd='aooq604 "',tm1.gev04,'" "6" "',g_prog,'" "',
                          g_aag[l_ac].aag00,'+',g_aag[l_ac].aag01,'"'
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p104_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    INITIALIZE tm1.* TO NULL            # Default condition
    LET tm1.gev04=NULL
    LET tm1.geu02=NULL
    CALL g_aag.clear()
    CLEAR FORM
 
    SELECT gev04 INTO tm1.gev04 FROM gev_file
     WHERE gev01 = '6' AND gev02 = g_plant
    SELECT geu02 INTO tm1.geu02 FROM geu_file
     WHERE geu01 = tm1.gev04
    DISPLAY BY NAME tm1.gev04,tm1.geu02
 
#   INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS
 
#      AFTER FIELD gev04
#         IF NOT cl_null(tm1.gev04) THEN
#            CALL p104_gev04()
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(tm1.gev04,g_errno,0)
#               NEXT FIELD gev04
#            END IF
#         ELSE
#            DISPLAY '' TO geu02
#         END IF
 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(gev04)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_gev04"
#               LET g_qryparam.arg1 = "6"
#               LET g_qryparam.arg2 = g_plant
#               CALL cl_create_qry() RETURNING tm1.gev04
#               DISPLAY BY NAME tm1.gev04
#               NEXT FIELD gev04
#            OTHERWISE EXIT CASE
#         END CASE
 
#      ON ACTION locale
#         CALL cl_show_fld_cont()
#         LET g_action_choice = "locale"
 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
 
#      ON ACTION controlg
#         CALL cl_cmdask()
 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
 
#   END INPUT
 
#   IF INT_FLAG THEN
#      LET INT_FLAG=0
#      CLOSE WINDOW p104_w
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
    CALL cl_set_comp_entry("gev04",FALSE)
    CONSTRUCT tm1.wc ON aag00,aag01,aag02,aag13,aag04,aag07,                  
                    aag08,aag24,aag05,aag21,aag23,aagacti               
         FROM s_aag[1].aag00,s_aag[1].aag01,s_aag[1].aag02,                    
              s_aag[1].aag13,s_aag[1].aag04,s_aag[1].aag07,                    
              s_aag[1].aag08,s_aag[1].aag24,s_aag[1].aag05,                    
              s_aag[1].aag21,s_aag[1].aag23,s_aag[1].aagacti
 
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
                                                                                
    ON ACTION qbe_select                                                     
       CALL cl_qbe_select()
  
    ON ACTION qbe_save                                                       
       CALL cl_qbe_save()
 
    END CONSTRUCT 
    LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       RETURN 
    END IF
 
    CALL p104_b_fill()
  
    IF g_rec_b > 0 THEN
       CALL p104_b()
    ELSE
       CALL cl_err('',100,0);
    END IF
 
END FUNCTION
 
FUNCTION p104_b_fill()
  DEFINE l_i         LIKE type_file.num10
 
    LET g_sql = "SELECT 'N',aag00,aag01,aag02,aag13,aag04,aag07,aag08,aag24,",
                "aag05,aag21,aag23,aagacti ",
                " FROM aag_file ",
                " WHERE ",tm1.wc,
                " ORDER BY aag00,aag01 "
   PREPARE aag_p1 FROM g_sql
   DECLARE sel_aag_cur CURSOR FOR aag_p1
      
    CALL g_aag.clear()
    LET l_i = 1
    FOREACH sel_aag_cur INTO g_aag[l_i].*
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
    CALL g_aag.deleteElement(l_i)
    LET g_rec_b = l_i - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
 
FUNCTION p104_b()
  
    SELECT * FROM gev_file
     WHERE gev01 = '6' AND gev02 = g_plant
       AND gev03 = 'Y' AND gev04 = tm1.gev04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_plant,'aoo-036',1)
       RETURN
    END IF
    
    DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
    INPUT ARRAY g_aag WITHOUT DEFAULTS FROM s_aag.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT       
            
       ON ACTION select_all
          CALL p100_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p100_sel_all_1("N")
          
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
 
END FUNCTION
 
FUNCTION p104_gev04()
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
       SELECT * FROM gev_file WHERE gev01 = '6' AND gev02 = g_plant
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
 
FUNCTION p100_sel_all_1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_aag.getLength()
       LET g_aag[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p104()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
 
   CALL g_aag1.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_aag.getLength()
       IF g_aag[l_i].sel = 'Y' THEN
          LET g_aag1[l_j].sel   = g_aag[l_i].sel
          LET g_aag1[l_j].aag00 = g_aag[l_i].aag00
          LET g_aag1[l_j].aag01 = g_aag[l_i].aag01
          LET l_j = l_j + 1
       END IF
   END FOR
 
   IF l_j = 1 THEN                                                                                                                  
      CALL cl_err('','aoo-096',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   CALL s_dc_sel_db(tm1.gev04,'6')                                                                                                  
   IF INT_FLAG THEN                                                                                                                 
      LET INT_FLAG=0                                                                                                                
      RETURN                                                                                                                        
   END IF
 
   CALL s_showmsg_init()
   CALL s_agli102_carry_aag(g_aag1,g_azp,tm1.gev04,'0')
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION p104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice="download"
         EXIT DISPLAY
 
      ON ACTION subject_detail_maintain
         LET g_action_choice="subject_detail_maintain"
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
         LET g_action_choice="detail"
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
 
FUNCTION p104_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10  
  DEFINE l_flag       LIKE type_file.chr1
 
    LET l_flag = 'N'                                                                                                                 
    FOR l_i = 1 TO g_aag.getLength()                                                                                                 
       IF g_aag[l_i].sel = 'Y' AND NOT cl_null(g_aag[l_i].aag01) 
                               AND NOT cl_null(g_aag[l_i].aag00) THEN                                                               
          LET l_flag = 'Y'                                                                                                          
       END IF                                                                                                                       
    END FOR                                                                                                                          
    IF l_flag = 'N' THEN                                                                                                             
       CALL cl_err('','aoo-096',0)                                                                                                   
       RETURN                                                                                                                        
    END IF
    CALL s_dc_download_path() RETURNING l_path
    CALL p104_download_files(l_path)
 
END FUNCTION
 
FUNCTION p104_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
  DEFINE l_tempdir         LIKE ze_file.ze03
  DEFINE l_temp_file       LIKE ze_file.ze03                                    
  DEFINE l_temp_file1      LIKE ze_file.ze03                                    
  DEFINE l_tabname         STRING                    #No.FUN-A80036             
  DEFINE l_str             STRING                    #No.FUN-A80036
                                                                                
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
   END IF
 
   LET l_tempdir    = fgl_getenv('TEMPDIR')                                     
 
   CALL s_dc_cre_temp_table("aag_file") RETURNING l_tabname
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM aag_file",
                                                 "  WHERE aag00 = ? AND aag01 = ?"
   PREPARE ins_pp FROM g_sql
 
   FOR l_i = 1 TO g_aag.getLength()
       IF cl_null(g_aag[l_i].aag01) OR cl_null(g_aag[l_i].aag00) THEN
          CONTINUE FOR
       END IF
       IF g_aag[l_i].sel = 'N' THEN
          CONTINUE FOR
       END IF
       EXECUTE ins_pp USING g_aag[l_i].aag00,g_aag[l_i].aag01
       IF SQLCA.sqlcode THEN
          LET l_str = 'ins ',l_tabname CLIPPED   #No.FUN-A80036                 
          CALL cl_err(l_str,SQLCA.sqlcode,1)     #No.FUN-A80036
          CONTINUE FOR
       END IF
   END FOR
   
   LET l_upload_file = l_tempdir CLIPPED,'/aglp104_aag_file_6.txt'
   LET l_download_file = p_path CLIPPED,"/aglp104_aag_file_6.txt"
   
   LET g_sql = "SELECT * FROM ",l_tabname
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql 
 
   CALL s_dc_drop_temp_table(l_tabname)
END FUNCTION
#FUN-820031---END
