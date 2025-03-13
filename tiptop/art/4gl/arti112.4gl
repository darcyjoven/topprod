# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"arti112.4gl"
#Descriptions..:組裝商品結構維護
#Date & Author..:#NO.FUN-870007 08/07/08 By Zhangyajun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/11 By Cockroach 添加pos相關管控
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:TQC-A30153 10/05/14 By Cockroach 預設上筆資料出錯
# Modify.........: No:TQC-A90075 10/10/09 By lilingyu 查詢時,資料建立者等欄位無法下查詢條件 
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60118 11/06/22 By huangtao pos預設值為否
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.MOD-C30159 12/03/10 By fanbj rtb01欄位加控管，當ima_file.ima155 = 'Y'才可以錄入
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rtb    RECORD LIKE rtb_file.*,
        g_rtb_t  RECORD LIKE rtb_file.*,
        g_rtc   DYNAMIC ARRAY OF RECORD 
                rtc02      LIKE rtc_file.rtc02,
                rtc02_desc LIKE gfe_file.gfe02,
                rtc03      LIKE rtc_file.rtc03,
                rtc03_desc LIKE gfe_file.gfe02,
                rtc04      LIKE rtc_file.rtc04
                        END RECORD,
        g_rtc_t RECORD
                rtc02      LIKE rtc_file.rtc02,
                rtc02_desc LIKE gfe_file.gfe02,
                rtc03      LIKE rtc_file.rtc03,
                rtc03_desc LIKE gfe_file.gfe02,
                rtc04      LIKE rtc_file.rtc04
                        END RECORD
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5,
        l_input LIKE type_file.chr1
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  l_table         STRING
DEFINE  g_check         LIKE type_file.chr1
DEFINE  l_ima25         LIKE ima_file.ima25  #庫存單位
DEFINE  l_ima25b         LIKE ima_file.ima25  #庫存單位
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)      
         RETURNING g_time   
          
    LET g_forupd_sql="SELECT * FROM rtb_file WHERE rtb01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i112_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i112_w AT p_row,p_col WITH FORM "art/42f/arti112"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    #CALL cl_set_comp_visible('rtbpos',g_aza.aza88='Y') #TQC-B30004 mark
    CALL cl_set_comp_visible('rtbpos',FALSE)   #TQC-B30004 add
    CALL cl_ui_init()
    CALL i112_menu()
    CLOSE WINDOW i112_w                   
    CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
 
FUNCTION i112_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtc TO s_rtc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i112_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i112_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i112_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i112_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i112_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
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
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i112_menu()
 
   WHILE TRUE
      CALL i112_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i112_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i112_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i112_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i112_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i112_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i112_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i112_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i112_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rtc),'','')
             END IF  
         WHEN "related_document"   
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rtb.rtb01) THEN
                 LET g_doc.column1 = "rtb01"
                 LET g_doc.value1 = g_rtb.rtb01
                 CALL cl_doc()
              END IF
           END IF      
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i112_cs()
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                               
        rtb01,rtb02,rtb03,            #FUN-B50042 remove POS
    	  rtbuser,rtbgrup,
          rtboriu,                    #TQC-A90075 ADD
          rtbmodu,rtbdate,
          rtborig,                    #TQC-A90075 ADD
          rtbacti,rtbcrat
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtb01) #主項商品代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtb01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtb01
                 NEXT FIELD rtb01
              WHEN INFIELD(rtb02) #庫存單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtb02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtb02
                 NEXT FIELD rtb02
              OTHERWISE
                 EXIT CASE
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtbgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rtbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtbuser', 'rtbgrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2 ON rtc02,rtc03,rtc04
                    FROM s_rtc[1].rtc02,s_rtc[1].rtc03,s_rtc[1].rtc04
           ON ACTION controlp
           CASE
              WHEN INFIELD(rtc02) #子項商品代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtc02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtc02
                 NEXT FIELD rtc02
              WHEN INFIELD(rtc03) #庫存單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtc03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtc03
                 NEXT FIELD rtc03
              OTHERWISE
                 EXIT CASE
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
    IF INT_FLAG THEN 
        RETURN
        END IF
    #LET g_wc2=g_wc2 CLIPPED
 
    IF  g_wc2="1=1" THEN       
         LET g_sql="SELECT rtb01 FROM rtb_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY rtb01"
    ELSE                                 
      LET g_sql=
        "SELECT UNIQUE rtb_file.rtb01",
        " FROM rtb_file,rtc_file",
        " WHERE rtb01=rtc01",
        " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
        " ORDER BY rtb01"
    END IF
    
    PREPARE i112_prepare FROM g_sql
    DECLARE i112_cs SCROLL CURSOR WITH HOLD FOR i112_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM rtb_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM rtb_file,rtc_file WHERE",
                " rtb01=rtc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE i112_precount FROM g_sql
    DECLARE i112_count CURSOR FOR i112_precount
    
END FUNCTION
 
FUNCTION i112_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rtc.clear()      
    MESSAGE ""
    
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i112_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rtb.* TO NULL
        RETURN
    END IF
    OPEN i112_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rtc.clear()
    ELSE
        OPEN i112_count
        FETCH i112_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL i112_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION i112_fetch(p_flrtb)
DEFINE  p_flrtb         LIKE type_file.chr1   
        
    CASE p_flrtb
        WHEN 'N' FETCH NEXT     i112_cs INTO g_rtb.rtb01
        WHEN 'P' FETCH PREVIOUS i112_cs INTO g_rtb.rtb01
        WHEN 'F' FETCH FIRST    i112_cs INTO g_rtb.rtb01
        WHEN 'L' FETCH LAST     i112_cs INTO g_rtb.rtb01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
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
            FETCH ABSOLUTE g_jump i112_cs INTO g_rtb.rtb01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rtb.rtb01,SQLCA.sqlcode,0)
        INITIALIZE g_rtb.* TO NULL  
        RETURN
    ELSE
      CASE p_flrtb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rtb.* FROM rtb_file    
       WHERE rtb01 = g_rtb.rtb01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rtb_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        CALL i112_show()                   
    END IF
END FUNCTION
 
FUNCTION i112_rtb01(p_cmd)    
DEFINE    p_cmd      LIKE type_file.chr1     
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02
DEFINE    l_ima155   LIKE ima_file.ima155     #MOD-C30159 add
          
   LET g_errno = ' '
#MOD-C30159--start mark----------------------
#   SELECT ima02,ima25,imaacti 
#     INTO l_ima02,l_ima25,l_imaacti
#     FROM ima_file 
#    WHERE ima01 = g_rtb.rtb01
#MOD-C30159--end mark------------------------
#MOD-C30159--start add-----------------------   
   SELECT ima02,ima25,imaacti,ima155
     INTO l_ima02,l_ima25,l_imaacti,l_ima155
     FROM ima_file
    WHERE ima01 = g_rtb.rtb01    
#MOD-C30159--end add-------------------------   

  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-013' 
                                 LET l_ima02=NULL 
                                 LET l_ima25=NULL
        WHEN l_imaacti='N'       LET g_errno='9028' 
        WHEN l_ima155 <> 'Y'     LET g_errno = 'art1056'        #MOD-C30159 add
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE    
   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rtb.rtb02 = l_ima25
     CALL i112_rtb02('a')
     IF cl_null(g_errno) OR p_cmd = 'd' THEN        
        DISPLAY l_ima25 TO rtb02
        DISPLAY l_ima02 TO FORMONLY.rtb01_desc
     END IF
  END IF
 
END FUNCTION
 
FUNCTION i112_rtb02(p_cmd)         
DEFINE    p_cmd      LIKE type_file.chr1     
DEFINE    l_gfeacti  LIKE gfe_file.gfeacti, 
          l_gfe02    LIKE gfe_file.gfe02
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac         
          
   LET g_errno = ' '
   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti FROM gfe_file
     WHERE gfe01=g_rtb.rtb02
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-031' 
                                 LET l_gfe02=NULL 
        WHEN l_gfeacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gfe02 TO rtb02_desc
  END IF
 
END FUNCTION
 
FUNCTION i112_show()
    LET g_rtb_t.* = g_rtb.*
    DISPLAY BY NAME g_rtb.rtb01,g_rtb.rtb03, g_rtb.rtboriu,g_rtb.rtborig, #FUN-B50042 remove POS
                    g_rtb.rtbuser,g_rtb.rtbgrup,g_rtb.rtbcrat,
                    g_rtb.rtbmodu,g_rtb.rtbdate,g_rtb.rtbacti
    CALL i112_rtb01('d')
    CALL i112_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i112_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT rtc02,'',rtc03,'',rtc04 FROM rtc_file ",
                " WHERE rtc01 = '",g_rtb.rtb01,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    PREPARE i112_pb FROM g_sql
    DECLARE rtc_cs CURSOR FOR i112_pb
 
    CALL g_rtc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtc_cs INTO g_rtc[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT ima02 INTO g_rtc[g_cnt].rtc02_desc FROM ima_file
               WHERE ima01 = g_rtc[g_cnt].rtc02
        SELECT gfe02 INTO g_rtc[g_cnt].rtc03_desc FROM gfe_file
               WHERE gfe01 = g_rtc[g_cnt].rtc03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rtc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i112_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtc.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET g_check = 'N'
   INITIALIZE g_rtb.* LIKE rtb_file.*                  
   LET g_rtb_t.* = g_rtb.*
   
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rtb.rtbuser = g_user
      LET g_rtb.rtboriu = g_user #FUN-980030
      LET g_rtb.rtborig = g_grup #FUN-980030
      LET g_rtb.rtbgrup = g_grup
      LET g_rtb.rtbcrat = g_today
      LET g_rtb.rtbacti = 'Y'                    
#     #LET g_rtb.rtbpos = 'N'    #FUN-B50042 mark  #FUN-B60118
      LET g_rtb.rtbpos = 'N'     #FUN-B60118 
      CALL i112_i("a")                          
 
      IF g_check ='Y' THEN
         EXIT WHILE
      END IF
      IF INT_FLAG THEN                          
         INITIALIZE g_rtb.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      
      IF cl_null(g_rtb.rtb01) THEN       
         CONTINUE WHILE
      END IF
 
      INSERT INTO rtb_file VALUES (g_rtb.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rtb_file",g_rtb.rtb01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rtb.* FROM rtb_file
       WHERE rtb01 = g_rtb.rtb01
      LET g_rtb_t.* = g_rtb.*
      CALL g_rtc.clear()
 
      LET g_rec_b = 0  
      CALL i112_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i112_i(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1,          
         l_n       LIKE type_file.num5           
     
   CALL cl_set_head_visible("","YES")
   DISPLAY BY NAME g_rtb.rtbuser,g_rtb.rtbgrup,g_rtb.rtbmodu,
                   g_rtb.rtbdate,g_rtb.rtbacti,g_rtb.rtbcrat
                   #g_rtb.rtbpos                             #FUN-B50042 remove POS
   INPUT BY NAME g_rtb.rtboriu,g_rtb.rtborig,
      g_rtb.rtb01,g_rtb.rtb03      
      WITHOUT DEFAULTS
 
      BEFORE INPUT       
          LET g_before_input_done = FALSE
          CALL i112_set_entry(p_cmd)
          CALL i112_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
	
      AFTER FIELD rtb01
         IF NOT cl_null(g_rtb.rtb01) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rtb.rtb01,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rtb.rtb01= g_rtb_t.rtb01
               NEXT FIELD rtb01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rtb.rtb01 != g_rtb_t.rtb01) THEN
               SELECT COUNT(*) INTO l_n FROM rtb_file WHERE rtb01 = g_rtb.rtb01
              IF l_n > 0 THEN                 
                  CALL i112_rtb01('d')
                  SELECT rtb03 INTO g_rtb.rtb03 FROM rtb_file WHERE rtb01 = g_rtb.rtb01
                  DISPLAY BY NAME g_rtb.rtb03
                  CALL i112_b_fill(" 1=1")
                  LET l_ac = g_rec_b + 1
                  CALL i112_b()
                  LET g_check = 'Y'
                  EXIT INPUT
               ElSE
                CALL i112_rtb01('a')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rtb01:',g_errno,0)
                  LET g_rtb.rtb01 = g_rtb_t.rtb01
                  DISPLAY BY NAME g_rtb.rtb01
                  NEXT FIELD rtb01
                END IF
               END IF
             END IF
         END IF
         
     AFTER FIELD rtb03
        IF NOT cl_null(g_rtb.rtb03) THEN
           IF g_rtb.rtb03 <0 THEN
              CALL cl_err(g_rtb.rtb03,"art-040",0)
              NEXT FIELD rtb03
           END IF
        END IF
        
     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_rtb.rtb01 IS NULL THEN
               DISPLAY BY NAME g_rtb.rtb01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD rtb01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rtb01) THEN
            LET g_rtb.* = g_rtb_t.*
            CALL i112_show()
            NEXT FIELD rtb01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rtb01)
#FUN-AA0059---------mod------------str-----------------           
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima01"
#              LET g_qryparam.default1 = g_rtb.rtb01
#              CALL cl_create_qry() RETURNING g_rtb.rtb01
              #CALL q_sel_ima(FALSE, "q_ima01","",g_rtb.rtb01,"","","","","",'' )   #MOD-C30159  mark
               CALL q_sel_ima(FALSE, "q_ima01"," ima155= 'Y'",g_rtb.rtb01,"","","","","",'' )   #MOD-C30159  add     
                  RETURNING  g_rtb.rtb01
#FUN-AA0059---------mod------------end-----------------
              DISPLAY BY NAME g_rtb.rtb01
              CALL i112_rtb01('d')
              NEXT FIELD rtb01
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       
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
 
END FUNCTION
 
FUNCTION i112_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rtb01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i112_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rtb01",FALSE)
       
    END IF
 
END FUNCTION
 
FUNCTION i112_b()
DEFINE          l_ac_t LIKE type_file.num5,
                l_n     LIKE type_file.num5,
                l_cnt   LIKE type_file.num5,
                l_lock_sw       LIKE type_file.chr1,
                p_cmd   LIKE type_file.chr1,
                l_misc  LIKE gef_file.gef01,
                l_allow_insert  LIKE type_file.num5,
                l_allow_delete  LIKE type_file.num5
DEFINE  l_sql   STRING          #FUN-AA0059 add                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF g_rtb.rtb01 IS NULL THEN
                RETURN 
        END IF
        
        SELECT * INTO g_rtb.* FROM rtb_file
                WHERE rtb01=g_rtb.rtb01
        
        IF g_rtb.rtbacti='N' THEN 
                CALL cl_err(g_rtb.rtb01,'mfg1000',0)
                RETURN 
        END IF
        
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT  rtc02,'',rtc03,'',rtc04", 
                        " FROM rtc_file",
                        " WHERE rtc01=? AND rtc02=?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i112_bcl CURSOR FROM g_forupd_sql
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        INPUT ARRAY g_rtc WITHOUT DEFAULTS FROM s_rtc.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i112_cl USING g_rtb.rtb01
                IF STATUS THEN
                        CALL cl_err("OPEN i112_cl:",STATUS,1)
                        CLOSE i112_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i112_cl INTO g_rtb.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rtb.rtb01,SQLCA.sqlcode,0)
                        CLOSE i112_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtc_t.*=g_rtc[l_ac].*
                        OPEN i112_bcl USING g_rtb.rtb01,g_rtc_t.rtc02
                        IF STATUS THEN
                                CALL cl_err("OPEN i112_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i112_bcl INTO g_rtc[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_rtc_t.rtc02,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i112_rtc02('d')
                                CALL i112_rtc03('d')
                        END IF
                END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtc[l_ac].* TO NULL
                LET g_rtc_t.*=g_rtc[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtc02
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO rtc_file(rtc01,rtc02,rtc03,rtc04)
                     VALUES(g_rtb.rtb01,g_rtc[l_ac].rtc02,
                            g_rtc[l_ac].rtc03,g_rtc[l_ac].rtc04)
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtc_file",g_rtb.rtb01,g_rtc[l_ac].rtc02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                
      AFTER FIELD rtc02
           IF NOT cl_null(g_rtc[l_ac].rtc02) THEN 
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_rtc[l_ac].rtc02,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rtc[l_ac].rtc02= g_rtc_t.rtc02
                 NEXT FIELD rtc02
              END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF g_rtc[l_ac].rtc02!=g_rtc_t.rtc02
                        OR g_rtc_t.rtc02 IS NULL THEN
                   IF g_rtc[l_ac].rtc02=g_rtb.rtb01 THEN
                      CALL cl_err('',"art-465",0)
                      NEXT FIELD rtc02
                   END IF
                       SELECT COUNT(*) INTO l_n FROM rtc_file
                           WHERE rtc01= g_rtb.rtb01 AND rtc02=g_rtc[l_ac].rtc02
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtc[l_ac].rtc02=g_rtc_t.rtc02
                           NEXT FIELD rtc02
                       END IF
                       CALL i112_rtc02('a')
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_rtc[l_ac].rtc02,g_errno,0)
                          LET g_rtc[l_ac].rtc02 = g_rtc_t.rtc02
                          NEXT FIELD rtc02
                       END IF
                 END IF
         END IF
         
       AFTER FIELD rtc03
         IF NOT cl_null(g_rtc[l_ac].rtc03) THEN 
                IF g_rtc[l_ac].rtc03!=g_rtc_t.rtc03
                        OR g_rtc_t.rtc03 IS NULL THEN
                   CALL i112_rtc03('a')
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_rtc[l_ac].rtc03,g_errno,0)
                          LET g_rtc[l_ac].rtc03 = g_rtc_t.rtc03
                          NEXT FIELD rtc03
                       END IF
                 END IF
         END IF
       AFTER FIELD rtc04
         IF NOT cl_null(g_rtc[l_ac].rtc04) THEN
           IF g_rtc[l_ac].rtc04 <0 THEN
              CALL cl_err(g_rtc[l_ac].rtc04,"art-040",0)
              NEXT FIELD rtc04
           END IF
          END IF
        
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_rtc_t.rtc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtc_file
               WHERE rtc01 = g_rtb.rtb01
                 AND rtc02 = g_rtc_t.rtc02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtc_file",g_rtb.rtb01,g_rtc_t.rtc02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                #FUN-B50042 mark --START--
                 #IF g_aza.aza88 ='Y'  THEN   #FUN-A30030 ADD
                 #   LET g_rtb.rtbpos = 'N'
                 #   UPDATE rtb_file SET rtbpos = g_rtb.rtbpos
                 #    WHERE rtb01 = g_rtb.rtb01
                 #   DISPLAY BY NAME g_rtb.rtbpos
                 #END IF     
                #FUN-B50042 mark --END--
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtc[l_ac].* = g_rtc_t.*
              CLOSE i112_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #FUN-B50042 mark --START--
           #IF g_aza.aza88 ='Y'  THEN   #FUN-A30030 ADD
           #   IF g_rtc[l_ac].rtc02<>g_rtc_t.rtc02 OR 
           #      g_rtc[l_ac].rtc03<>g_rtc_t.rtc03 OR
           #      g_rtc[l_ac].rtc04<>g_rtc_t.rtc04 THEN
           #      LET g_rtb.rtbpos = 'N'
           #      UPDATE rtb_file SET rtbpos = g_rtb.rtbpos
           #       WHERE rtb01 = g_rtb.rtb01
           #      DISPLAY BY NAME g_rtb.rtbpos
           #   END IF
           #END IF
           #FUN-B50042 mark --END--
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtc[l_ac].rtc02,-263,1)
              LET g_rtc[l_ac].* = g_rtc_t.*
           ELSE
              UPDATE rtc_file SET rtc02=g_rtc[l_ac].rtc02,
                                  rtc03=g_rtc[l_ac].rtc03,
                                  rtc04=g_rtc[l_ac].rtc04
                 WHERE rtc01=g_rtb.rtb01
                   AND rtc02=g_rtc_t.rtc02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtc_file",g_rtb.rtb01,g_rtc_t.rtc02,SQLCA.sqlcode,"","",1) 
                 LET g_rtc[l_ac].* = g_rtc_t.*
              ELSE
                LET g_rtb.rtbmodu = g_user
                LET g_rtb.rtbdate = g_today
                UPDATE rtb_file SET rtbmodu = g_rtb.rtbmodu,rtbdate = g_rtb.rtbdate
                 WHERE rtb01 = g_rtb.rtb01
                DISPLAY BY NAME g_rtb.rtbmodu,g_rtb.rtbdate
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtc[l_ac].* = g_rtc_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rtc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i112_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE i112_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtc02) AND l_ac > 1 THEN
              LET g_rtc[l_ac].* = g_rtc[l_ac-1].*
             #LET g_rtc[l_ac].rtc02 = g_rec_b + 1          #TQC-A30153 MARK
              LET g_rtc[l_ac].rtc02 = g_rtc[l_ac-1].rtc02  #ADD
              NEXT FIELD rtc02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtc02)
#FUN-AA0059---------mod------------str-----------------                                 
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_ima01" 
#               LET g_qryparam.where = "ima01<>'",g_rtb.rtb01,"'" 
#               LET g_qryparam.default1 = g_rtc[l_ac].rtc02
#               CALL cl_create_qry() RETURNING g_rtc[l_ac].rtc02
                LET l_sql = "ima01<>'",g_rtb.rtb01,"'"
                CALL q_sel_ima(FALSE, "q_ima01",l_sql,g_rtc[l_ac].rtc02,"","","","","",'' ) 
                     RETURNING  g_rtc[l_ac].rtc02

#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_rtc[l_ac].rtc02
               CALL i112_rtc02('d')
               NEXT FIELD rtc02
               
            WHEN INFIELD(rtc03)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe02" 
               LET g_qryparam.default1 = g_rtc[l_ac].rtc03
               LET g_qryparam.arg1=l_ima25b
               CALL cl_create_qry() RETURNING g_rtc[l_ac].rtc03
               DISPLAY BY NAME g_rtc[l_ac].rtc03
               CALL i112_rtc03('d')
               NEXT FIELD rtc03
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
 
    CLOSE i112_bcl
    COMMIT WORK
#   CALL i112_delall()  #CHI-C30002 mark
    CALL i112_delHeader()     #CHI-C30002 add
    CALL i112_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION i112_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM rtb_file WHERE rtb01 = g_rtb.rtb01
         INITIALIZE g_rtb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i112_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rtc_file
#   WHERE rtc01 = g_rtb.rtb01
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rtb_file WHERE rtb01 = g_rtb.rtb01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i112_rtc02(p_cmd)     
DEFINE    p_cmd      LIKE type_file.chr1    
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02
          
   LET g_errno = ' '
   SELECT ima02,ima25,imaacti 
     INTO l_ima02,l_ima25b,l_imaacti
     FROM ima_file 
    WHERE ima01 = g_rtc[l_ac].rtc02
     
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-013' 
                                 LET l_ima02=NULL 
                                 LET l_ima25b=NULL
        WHEN l_imaacti='N'       LET g_errno='9028'  
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE    
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rtc[l_ac].rtc02_desc = l_ima02
      DISPLAY BY NAME  g_rtc[l_ac].rtc02_desc
  END IF
 
END FUNCTION   
      
FUNCTION i112_rtc03(p_cmd)  
DEFINE    p_cmd      LIKE type_file.chr1       
DEFINE    l_gfeacti  LIKE gfe_file.gfeacti, 
          l_gfe02    LIKE gfe_file.gfe02
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac          
          
   LET g_errno = ' '
   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti FROM gfe_file
     WHERE gfe01=g_rtc[l_ac].rtc03
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-031' 
                                 LET l_gfe02=NULL 
        WHEN l_gfeacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno)  THEN
     CALL s_umfchk('',l_ima25b,g_rtc[l_ac].rtc03) RETURNING l_flag,l_fac
     IF l_flag = 1 THEN
        LET g_errno = 'art-032'
     END IF
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rtc[l_ac].rtc03_desc = l_gfe02
     DISPLAY BY NAME g_rtc[l_ac].rtc03_desc
  END IF
 
END FUNCTION              
                                
FUNCTION i112_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtb.rtb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtb.* FROM rtb_file
    WHERE rtb01=g_rtb.rtb01
 
   IF g_rtb.rtbacti ='N' THEN    
      CALL cl_err(g_rtb.rtb01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtb_t.rtb01 = g_rtb.rtb01
   BEGIN WORK
 
   OPEN i112_cl USING g_rtb.rtb01
   IF STATUS THEN
      CALL cl_err("OPEN i112_cl:", STATUS, 1)
      CLOSE i112_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i112_cl INTO g_rtb.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtb.rtb01,SQLCA.sqlcode,0)    
       CLOSE i112_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i112_show()
 
   WHILE TRUE
      LET g_rtb.rtbmodu=g_user
      LET g_rtb.rtbdate=g_today
 
      CALL i112_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtb.*=g_rtb_t.*
         CALL i112_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rtb.rtb01 != g_rtb_t.rtb01 THEN            
         UPDATE rtc_file SET rtc01 = g_rtb.rtb01
          WHERE rtc01 = g_rtb01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtc_file",g_rtb_t.rtb01,"",SQLCA.sqlcode,"","rtc",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      #IF g_rtb.rtb03 <> g_rtb_t.rtb03 THEN #FUN-B50042 mark
      #   LET g_rtb.rtbpos = 'N'            #FUN-B50042 mark
      #END IF                               #FUN-B50042 mark
      UPDATE rtb_file SET rtb_file.* = g_rtb.*
                      WHERE rtb01 = g_rtb.rtb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtb_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i112_cl
   COMMIT WORK
   CALL i112_show()
   CALL i112_b_fill("1=1")
   CALL i112_bp_refresh()
 
END FUNCTION          
                
FUNCTION i112_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtb.rtb01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
  #TQC-B30004 mark begin---------------------
  ##FUN-A30030 ADD------------------------------------
  # IF g_aza.aza88='Y' THEN
  #    IF NOT (g_rtb.rtbacti='N' AND g_rtb.rtbpos='Y') THEN
  #      #CALL cl_err('', 'aim-944', 1)     #MARK
  #       CALL cl_err('', 'art-648', 1)     #FUN-A30030 ADD
  #       RETURN
  #    END IF
  # END IF
  ##FUN-A30030 END-----------------------------------
  #TQC-B30004 mark end------------------------
 
   SELECT * INTO g_rtb.* FROM rtb_file
    WHERE rtb01=g_rtb.rtb01
   IF g_aza.aza88 = 'N' THEN
      IF g_rtb.rtbacti ='N' THEN    
         CALL cl_err(g_rtb.rtb01,'mfg1000',0)
         RETURN
      END IF
   END IF
   BEGIN WORK
 
   OPEN i112_cl USING g_rtb.rtb01
   IF STATUS THEN
      CALL cl_err("OPEN i112_cl:", STATUS, 1)
      CLOSE i112_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i112_cl INTO g_rtb.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtb.rtb01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i112_show()
 #FUN-A30030 MARK--------------------------------------
 # IF g_aza.aza88 = 'Y' THEN
 #    IF NOT (g_rtb.rtbacti = 'N' AND g_rtb.rtbpos = 'Y') THEN
 #       CALL cl_err('','aim-944',0)
 #       RETURN
 #    END IF
 # END IF
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rtb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rtb.rtb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM rtb_file WHERE rtb01 = g_rtb.rtb01
      DELETE FROM rtc_file WHERE rtc01 = g_rtb.rtb01
      CLEAR FORM
      CALL g_rtc.clear()
      OPEN i112_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i112_cs
         CLOSE i112_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i112_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i112_cs
         CLOSE i112_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i112_cs
      IF g_row_count >0 THEN
 
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i112_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i112_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i112_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i112_copy()
   DEFINE l_newno     LIKE rtb_file.rtb01,
          l_oldno     LIKE rtb_file.rtb01,
          l_cnt       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rtb.rtb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i112_set_entry('a')
   LET l_oldno = g_rtb.rtb01
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rtb01
 
       AFTER FIELD rtb01
          IF l_newno IS NOT NULL THEN  
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(l_newno,"") THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD rtb01
             END IF
#FUN-AA0059 ---------------------end-------------------------------                                        
              SELECT COUNT(*) INTO l_cnt FROM rtb_file                          
                  WHERE rtb01 = l_newno                                         
              IF l_cnt > 0 THEN                                                 
                 CALL cl_err(l_newno,-239,0)                                    
                  NEXT FIELD rtb01    
              ELSE
                 LET g_rtb.rtb01 = l_newno
                 CALL i112_rtb01('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('rtb01:',g_errno,0)
                    NEXT FIELD rtb01
                 END IF         
                 LET g_rtb.rtb01 = l_oldno                                 
              END IF                                                                                                                   
           END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rtb01)
#FUN-AA0059---------mod------------str-----------------                                     
#                CALL cl_init_qry_var()                                          
#                LET g_qryparam.form = "q_ima01"        
#                LET g_qryparam.default1 = g_rtb.rtb01                           
#                CALL cl_create_qry() RETURNING l_newno 
                CALL q_sel_ima(FALSE, "q_ima01","",g_rtb.rtb01,"","","","","",'' ) 
                  RETURNING  l_newno

#FUN-AA0059---------mod------------end-----------------                         
                DISPLAY l_newno TO rtb01                
                NEXT FIELD rtb01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()   
 
     ON ACTION help      
        CALL cl_show_help() 
 
     ON ACTION controlg    
        CALL cl_cmdask()  
 
   END INPUT
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rtb.rtb01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rtb_file         
       WHERE rtb01=g_rtb.rtb01
       INTO TEMP y
 
   UPDATE y
       SET rtb01=l_newno,    
           rtbuser=g_user,   
           rtbgrup=g_grup,   
           rtbmodu=NULL,     
           rtbcrat=g_today,  
           #rtbpos = 'N',  #FUN-A30030 ADD #FUN-B50042 mark
           rtbacti='Y'      
 
   INSERT INTO rtb_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtb_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rtc_file         
       WHERE rtc01=g_rtb.rtb01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rtc01=l_newno
 
   INSERT INTO rtc_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK        #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rtc_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK         #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   SELECT rtb_file.* INTO g_rtb.* FROM rtb_file WHERE rtb01 = l_newno
   CALL i112_u()
   CALL i112_b()
   #SELECT rtb_file.* INTO g_rtb.* FROM rtb_file WHERE rtb01 = l_oldno  #FUN-C80046
   #CALL i112_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION i112_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtb.rtb01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i112_cl USING g_rtb.rtb01
   IF STATUS THEN
      CALL cl_err("OPEN i112_cl:", STATUS, 1)
      CLOSE i112_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i112_cl INTO g_rtb.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtb.rtb01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i112_show()
 
   IF cl_exp(0,0,g_rtb.rtbacti) THEN                   
      LET g_chr=g_rtb.rtbacti
      IF g_rtb.rtbacti='Y' THEN
         LET g_rtb.rtbacti='N'
      ELSE
         LET g_rtb.rtbacti='Y'
      END IF
 
      UPDATE rtb_file SET rtbacti=g_rtb.rtbacti,
                          rtbmodu=g_user,
                          rtbdate=g_today
                      WHERE rtb01=g_rtb.rtb01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rtb_file",g_rtb.rtb01,"",SQLCA.sqlcode,"","",1)  
         LET g_rtb.rtbacti=g_chr
      END IF
   END IF
 
   CLOSE i112_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtbacti,rtbmodu,rtbdate
     INTO g_rtb.rtbacti,g_rtb.rtbmodu,g_rtb.rtbdate FROM rtb_file
    WHERE rtb01=g_rtb.rtb01
   DISPLAY BY NAME g_rtb.rtbacti,g_rtb.rtbmodu,g_rtb.rtbdate
 
END FUNCTION
 
FUNCTION i112_bp_refresh()
  DISPLAY ARRAY g_rtc TO s_rtc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL i112_show()
END FUNCTION
 
FUNCTION i112_out()                                                     
DEFINE l_cmd  STRING
 
    IF cl_null(g_wc) THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "arti112" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                
END FUNCTION                                                            
#NO.FUN-870007                    
 
