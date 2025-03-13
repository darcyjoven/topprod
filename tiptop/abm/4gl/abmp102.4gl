# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abmp102.4gl
# Descriptions...: 
# Input parameter:
# Date & Author..: NO.FUN-820031 08/03/07 Sunyanchun
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_abmi600_carry的參數
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
 
DATABASE ds
#NO.FUN-820031---begin
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"
 
DEFINE tm1        RECORD
                  gev04    LIKE gev_file.gev04,
                  geu02    LIKE geu_file.geu02,
                  wc       STRING
                  END RECORD
DEFINE g_rec_b	  LIKE type_file.num10
DEFINE g_cmd      LIKE type_file.chr50
DEFINE g_bma      DYNAMIC ARRAY OF RECORD 
                  sel      LIKE type_file.chr1,
                  bma01    LIKE bma_file.bma01,
                  bma06    LIKE bma_file.bma06,
                  ima02    LIKE ima_file.ima02,
                  ima021   LIKE ima_file.ima021,
                  ima55    LIKE ima_file.ima55,
                  ima05    LIKE ima_file.ima05,
                  ima08    LIKE ima_file.ima08,
                  bma05    LIKE bma_file.bma05
                  END RECORD
DEFINE g_bma1     DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  bma01    LIKE bma_file.bma01,
                  bma06    LIKE bma_file.bma06 
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
 
   LET g_db_type = cl_db_get_database_type()
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p100_w AT p_row,p_col
        WITH FORM "abm/42f/abmp102"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   IF NOT s_industry('slk') THEN                                               
      CALL cl_set_comp_visible("bma06,bmb30",g_sma.sma118='Y')         
   END IF
   CALL cl_ui_init()
   
   SELECT * FROM gev_file WHERE gev01 = '2' AND gev02 = g_plant                 
                            AND gev03 = 'Y'                                     
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_plant,'aoo-036',1)   #Not Carry DB                          
      EXIT PROGRAM                                                              
   END IF
 
   CALL p102_tm()
   CALL p102_menu()
 
   CLOSE WINDOW p102_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p102_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL p102_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p102_tm()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL p102()
               ERROR ""
            END IF
            
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL p102_download()
            END IF
         
         WHEN "bom_detail_maintain"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  LET l_cmd = 'abmi600 "',g_bma[l_ac].bma01,'" "',
                                g_bma[l_ac].bma06,'" "Y"'
                  CALL cl_cmdrun(l_cmd)
               END IF
            END IF
 
         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  LET l_cmd='aooq604 "',tm1.gev04,'" "2" "',g_prog,'" "',
                         g_bma[l_ac].bma01,'+',g_bma[l_ac].bma06,'"'
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_bma),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p102_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    INITIALIZE tm1.* TO NULL            # Default condition
    CLEAR FORM
    CALL g_bma.clear()
 
    SELECT gev04 INTO tm1.gev04 FROM gev_file
     WHERE gev01 = '2' AND gev02 = g_plant
    SELECT geu02 INTO tm1.geu02 FROM geu_file
     WHERE geu01 = tm1.gev04
    DISPLAY BY NAME tm1.gev04,tm1.geu02
 
#   INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS
 
#      AFTER FIELD gev04
#         IF NOT cl_null(tm1.gev04) THEN
#            CALL p102_gev04()
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
#               LET g_qryparam.arg1 = "2"
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
#      CLOSE WINDOW p102_w
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
    
    CONSTRUCT tm1.wc ON bma01,bma06,ima02,ima021,ima55,ima05,                  
                    ima08,bma05
         FROM s_bma[1].bma01,s_bma[1].bma06,s_bma[1].ima02,                    
              s_bma[1].ima021,s_bma[1].ima55,s_bma[1].ima05,                    
              s_bma[1].ima08,s_bma[1].bma05
 
    BEFORE CONSTRUCT                                                         
          CALL cl_qbe_init()                                                    
         
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bma01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_bma8"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bma01
               NEXT FIELD bma01    
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
    LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       RETURN 
    END IF
 
    CALL p102_b_fill()
    CALL p102_b()
 
END FUNCTION
 
FUNCTION p102_b_fill()
    DEFINE l_i         LIKE type_file.num10
 
    LET g_sql = "SELECT 'N',bma01,bma06,ima02,ima021,ima55,",
                "ima05,ima08,bma05 ",
                " FROM bma_file,ima_file ",
                " WHERE bma01=ima01 AND bma05 is not null AND ",
                " imaacti = 'Y' AND bmaacti = 'Y' AND ",tm1.wc,
                " ORDER BY bma01,bma06 "
    PREPARE bma_p1 FROM g_sql
    DECLARE sel_bma_cur CURSOR FOR bma_p1
      
    CALL g_bma.clear()
    LET l_i = 1
    FOREACH sel_bma_cur INTO g_bma[l_i].*
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
    CALL g_bma.deleteElement(l_i)
    LET g_rec_b = l_i - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
 
FUNCTION p102_b()
  
    SELECT * FROM gev_file
     WHERE gev01 = '2' AND gev02 = g_plant
       AND gev03 = 'Y' AND gev04 = tm1.gev04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_plant,'aoo-036',1)
       RETURN
    END IF
    
    DISPLAY ARRAY g_bma TO s_bma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
    IF g_bma.getLength() = 0 THEN                                               
       LET g_action_choice=''                                                   
       RETURN                                                                   
    END IF
   
    INPUT ARRAY g_bma WITHOUT DEFAULTS FROM s_bma.*
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
 
FUNCTION p102_gev04()
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
       SELECT * FROM gev_file WHERE gev01 = '2' AND gev02 = g_plant
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
 
   FOR l_i = 1 TO g_bma.getLength()
       LET g_bma[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p102()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
 
   CALL g_bma1.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_bma.getLength()
       IF g_bma[l_i].sel = 'Y' THEN
          LET g_bma1[l_j].sel   = g_bma[l_i].sel
          LET g_bma1[l_j].bma01 = g_bma[l_i].bma01
          LET g_bma1[l_j].bma06 = g_bma[l_i].bma06
          LET l_j = l_j + 1
       END IF
   END FOR
   
   IF l_j = 1 THEN                                                                                                                  
      CALL cl_err('','aoo-096',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   CALL s_dc_sel_db(tm1.gev04,'2')                                                                                                  
   IF INT_FLAG THEN                                                                                                                 
      LET INT_FLAG=0                                                                                                                
      RETURN                                                                                                                        
   END IF
 
   CALL s_showmsg_init()
   CALL s_abmi600_carry(g_bma1,g_azp,tm1.gev04,'0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION p102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bma TO s_bma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
         
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
 
      ON ACTION bom_detail_maintain
         LET g_action_choice="bom_detail_maintain"
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
 
FUNCTION p102_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i       LIKE type_file.num10                                
  DEFINE l_j       LIKE type_file.num10                                
                                                                         
  CALL g_bma1.clear()                                                  
  LET l_j = 1                                                          
  FOR l_i = 1 TO g_bma.getLength()                                     
      IF g_bma[l_i].sel = 'Y' THEN                                     
         LET g_bma1[l_j].sel   = g_bma[l_i].sel                        
         LET g_bma1[l_j].bma01 = g_bma[l_i].bma01                      
         LET g_bma1[l_j].bma06 = g_bma[l_i].bma06                      
         LET l_j = l_j + 1                                             
      END IF                                                           
  END FOR
 
  IF l_j = 1 THEN
     CALL cl_err('','aoo-096',0)
     RETURN
  END IF
 
   # CALL s_dc_download_path() RETURNING l_path
   #CALL p102_download_files(l_path)
  CALL s_abmi600_download(g_bma1)
 
END FUNCTION
 
FUNCTION p102_download_files(p_path)
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
 
   CALL s_dc_cre_temp_table("bma_file") RETURNING l_tabname
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM bma_file",
                                                 "  WHERE bma01 = ? AND bma06 = ?"
   PREPARE ins_pp FROM g_sql
 
   FOR l_i = 1 TO g_bma.getLength()
       IF cl_null(g_bma[l_i].bma01) OR cl_null(g_bma[l_i].bma06) THEN
          CONTINUE FOR
       END IF
       IF g_bma[l_i].sel = 'N' THEN
          CONTINUE FOR
       END IF
       EXECUTE ins_pp USING g_bma[l_i].bma01,g_bma[l_i].bma06
       IF SQLCA.sqlcode THEN
          LET l_str = 'ins ',l_tabname CLIPPED   #No.FUN-A80036                 
          CALL cl_err(l_str,SQLCA.sqlcode,1)     #No.FUN-A80036
          CONTINUE FOR
       END IF
   END FOR
   
   LET l_upload_file = l_tempdir CLIPPED,'/abmp102_bma_file.txt'
   LET l_download_file = p_path CLIPPED,"/abmp102_bma_file.txt"
   
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
#NO.FUN-820031---end
