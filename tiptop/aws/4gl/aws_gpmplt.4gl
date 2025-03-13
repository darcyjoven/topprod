# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aws_gpmplt.4gl
# Descriptions...: gpm 站台設定作業
# Date & Author..: 06/12/29 By Jack Lai
# Modify.........: No.FUN-6C0040 06/12/21 By Jack Lai 新增GPM Web Service Client
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-880054 08/08/18 By Vicky 新增ACTION:"Service設定"&"複製"及欄位Port
#                                                  隱藏"SOAP網址"及"HTTP網址"

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
 
#--------#No.FUN-6C0040 --------
DEFINE
    g_wge       RECORD LIKE wge_file.*,
    g_wge_t     RECORD LIKE wge_file.*,
    g_wgf       RECORD LIKE wgf_file.*,   #FUN-880054
    g_cnt       LIKE type_file.num10,
    g_sql       STRING,
    
    g_bwge  DYNAMIC ARRAY OF RECORD
        bwge06  LIKE wge_file.wge06,
        bwge04  LIKE wge_file.wge04,
        bwge02  LIKE wge_file.wge02,
        bwge09  LIKE wge_file.wge09,   #FUN-880054
        bwge03  LIKE wge_file.wge03,
        bwge08  LIKE wge_file.wge08
    END RECORD,
    
     #--FUN-880054--start--
    g_bwgf DYNAMIC ARRAY OF RECORD
        bwgf01  LIKE wgf_file.wgf01,
        bwgf02  LIKE wgf_file.wgf02,
        bwgf03  LIKE wgf_file.wgf03
    END RECORD,
 
    s04     STRING,
    s05     STRING,
    g_newds     LIKE wge_file.wge06,
    g_oldds     LIKE wge_file.wge06,
    g_new_ac    LIKE type_file.num5,
    g_old_ac    LIKE type_file.num5,
    l_s_ac      LIKE type_file.num5,   #servise_setting目前處理的ARRAY CNT
     #--FUN-880054--end--
 
    l_ac    LIKE type_file.num5    #目前處理的ARRAY CNT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680130 SMALLINT
#        l_time          LIKE type_file.chr8    #No.FUN-680130 VARCHAR(8)  #No.FUN-6A0091
    OPTIONS
#        HELP FILE     "aws/hlp/aws_efcfg2.hlp",#線上訊息的檔案
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AWS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
 
    LET p_row = 4 LET p_col = 6
    
    LET l_ac = 1
 
    CALL plant_fill()
    
    OPEN WINDOW gpmcfg_exc AT 4, 16
        WITH FORM "aws/42f/aws_gpmplt" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("wge03,wge08,bwge03,bwge08",FALSE)   #FUN-880054
    
    CALL cl_ui_locale("aws_gpmplt")
 
    CALL plant_menu()
 
    CLOSE WINDOW gpmcfg_exc
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
END MAIN
 
FUNCTION plant_menu()
   WHILE TRUE      
      CALL plant_bp("G")
      CASE g_action_choice         
         WHEN "detail"
             IF l_ac != 0 THEN
                CALL plant_maintain("modify")
             END IF     
             
         WHEN "insert"          
                CALL plant_maintain("insert")             
             
         WHEN "modify"
             IF l_ac != 0 THEN
                CALL plant_maintain("modify")
             END IF 
             
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
 
          #--FUN-880054--start--
         WHEN "reproduce"
            IF l_ac !=0 THEN
               CALL plant_copy()
            END IF
 
         WHEN "service_setting"
            IF l_ac != 0 THEN
               LET g_wge.wge06 = g_bwge[l_ac].bwge06
               LET g_wge.wge04 = g_bwge[l_ac].bwge04
               LET g_wge.wge02 = g_bwge[l_ac].bwge02
               LET g_wge.wge09 = g_bwge[l_ac].bwge09
               LET g_wge.wge03 = g_bwge[l_ac].bwge03
               LET g_wge.wge08 = g_bwge[l_ac].bwge08
            END IF
            CALL plant_service_setting()
          #--FUN-880054--end--
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION plant_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "    
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_bwge TO s_bwge.* ATTRIBUTE(COUNT=g_cnt,UNBUFFERED)
 
      BEFORE DISPLAY
          IF g_cnt != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
      BEFORE ROW
          LET l_ac = ARR_CURR()
          IF l_ac != 0 THEN
             DISPLAY g_bwge[l_ac].bwge06 TO wge06
             DISPLAY g_bwge[l_ac].bwge04 TO wge04
             DISPLAY g_bwge[l_ac].bwge02 TO wge02
             DISPLAY g_bwge[l_ac].bwge09 TO wge09   #FUN-880054
             DISPLAY g_bwge[l_ac].bwge03 TO wge03
             DISPLAY g_bwge[l_ac].bwge08 TO wge08
          END IF
 
      AFTER DISPLAY
          CONTINUE DISPLAY
 
      ON ACTION insert
          LET g_action_choice="insert"              
          EXIT DISPLAY
 
      ON ACTION modify
          LET g_action_choice="modify"
          LET l_ac = ARR_CURR()          
          EXIT DISPLAY
          
      ON ACTION delete
         IF l_ac != 0 THEN
             IF cl_delete() THEN
               DELETE FROM wge_file WHERE wge01 = 'E' AND wge05 = '*'
                   AND wge06 = g_bwge[l_ac].bwge06 AND wge07='*'
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del wga: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wge_file",g_bwge[l_ac].bwge06,"",SQLCA.sqlcode,"","del wga:", 0)   #No.FUN-660155)   #No.FUN-660155
               END IF
               CALL plant_fill()
               IF g_bwge.getLength() = 0 THEN
                  DISPLAY '' TO wge06
                  DISPLAY '' TO wge04
                  DISPLAY '' TO wge02
                  DISPLAY '' TO wge09   #FUN-880054
                  DISPLAY '' TO wge03
                  DISPLAY '' TO wge08
                  INITIALIZE g_wge.* TO NULL    #FUN-880054
               END IF
               ACCEPT DISPLAY
             END IF
          END IF
 
       #--FUN-880054--start--
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION service_setting
         LET g_action_choice="service_setting"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
       #--FUN-880054--end--
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
    IF INT_FLAG THEN                         # 若按了DEL鍵
        LET INT_FLAG = 0
    END IF
   
END FUNCTION
 
FUNCTION plant_fill()
    LET g_sql = "SELECT wge06,wge04,wge02,wge09,wge03,wge08 FROM wge_file where wge01='E'"   #FUN-880054
 
    PREPARE gpmcfg_pp FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90032
       EXIT PROGRAM
    END IF
    DECLARE gpmcfg_cs2 CURSOR FOR gpmcfg_pp
    CALL g_bwge.clear()
    LET g_cnt=1
    FOREACH gpmcfg_cs2 INTO g_bwge[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
       #--FUN-880054--start--
      IF g_bwge[g_cnt].bwge06 = g_newds THEN
         LET g_new_ac = g_cnt
      END IF
      IF g_bwge[g_cnt].bwge06 = g_oldds THEN
         LET g_old_ac = g_cnt
      END IF
       #--FUN-880054--end--
 
      LET g_cnt=g_cnt + 1
   END FOREACH
   CALL g_bwge.deleteElement(g_cnt)
   LET g_cnt=g_cnt - 1
END FUNCTION
 
FUNCTION plant_maintain(p_cmd)
    DEFINE
        p_cmd       LIKE type_file.chr20,   #No.FUN-680130 VARCHAR(10) 
        l_cnt       LIKE type_file.num10,    #No.FUN-680130 INTEGER
        l_wge06     LIKE wge_file.wge06
 
    INITIALIZE g_wge.* TO NULL
    LET g_action_choice = ""
    
    IF p_cmd = "modify" THEN
       LET g_wge.wge06 = g_bwge[l_ac].bwge06
       LET g_wge.wge04 = g_bwge[l_ac].bwge04
       LET g_wge.wge02 = g_bwge[l_ac].bwge02
       LET g_wge.wge09 = g_bwge[l_ac].bwge09   #FUN-880054
       LET g_wge.wge03 = g_bwge[l_ac].bwge03
       LET g_wge.wge08 = g_bwge[l_ac].bwge08
       LET l_wge06 = g_bwge[l_ac].bwge06
       CALL cl_set_comp_entry("wge06", FALSE)
    END IF
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT BY NAME g_wge.wge06,g_wge.wge04,g_wge.wge02,g_wge.wge09,g_wge.wge03,g_wge.wge08   #FUN-880054
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
           LET g_wge.wge01 = 'E'
           LET g_wge.wge05 = '*'
           LET g_wge.wge07 = '*'
           LET g_wge.wge03 = '*'  #FUN-880054
           LET g_wge.wge08 = '*'  #FUN-880054
 
         #--FUN-880054--start--
        AFTER FIELD wge06
           IF g_wge.wge06 IS NOT NULL THEN
              IF p_cmd = "insert" THEN
                SELECT COUNT(*) INTO l_cnt FROM azp_file
                        where azp01 = g_wge.wge06
                IF l_cnt = 0 THEN
                   CALL cl_err(g_wge.wge06,"-827",0)
                   LET g_wge.wge06=""
                   NEXT FIELD wge06
                END IF
 
                SELECT COUNT(*) INTO l_cnt FROM wge_file
                 WHERE wge01 = g_wge.wge01 AND wge05 = g_wge.wge05 AND
                       wge06 = g_wge.wge06 AND wge07 = g_wge.wge07
                IF l_cnt > 0 THEN
                   CALL cl_err(g_wge.wge06,-239,0)
                   LET g_wge.wge06=""
                   NEXT FIELD wge06
                END IF
            END IF  
           END IF
           #--FUN-880054--end--
 
        ON ACTION controlp
           CASE WHEN INFIELD(wge06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_wge.wge06
              CALL cl_create_qry() RETURNING g_wge.wge06
              DISPLAY BY NAME g_wge.wge06
              NEXT FIELD wge06
           END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
        
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL plant_fill()
        IF p_cmd = "modify" THEN
           CALL cl_set_comp_entry("wge06", TRUE)
        END IF
        CALL cl_set_act_visible("accept,cancel", FALSE)
        RETURN
    END IF
    IF p_cmd ="insert" THEN
        INSERT INTO wge_file VALUES(g_wge.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wge.wge01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("ins","wge_file",g_wge.wge01,g_wge.wge05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    ELSE
        UPDATE wge_file SET wge06 = g_wge.wge06,
                            wge04 = g_wge.wge04,
                            wge02 = g_wge.wge02,
                            wge09 = g_wge.wge09,   #FUN-880054
                            wge03 = g_wge.wge03,
                            wge08 = g_wge.wge08
            WHERE wge01 = g_wge.wge01 AND wge05 = g_wge.wge05 AND
                  wge06 = l_wge06 AND wge07 = g_wge.wge07
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wge_file",g_wge.wge01,g_wge.wge05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    CALL plant_fill()
 
    IF p_cmd = "modify" THEN
       CALL cl_set_comp_entry("wge06", TRUE)
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION
 
#--FUN-880054--start--
FUNCTION plant_copy()
    DEFINE l_newds  LIKE wge_file.wge06,
           l_cnt    LIKE type_file.num10
 
    LET  g_action_choice = ""
 
      LET g_wge.wge06 = g_bwge[l_ac].bwge06
      LET g_wge.wge04 = g_bwge[l_ac].bwge04
      LET g_wge.wge02 = g_bwge[l_ac].bwge02
      LET g_wge.wge09 = g_bwge[l_ac].bwge09
      LET g_wge.wge03 = g_bwge[l_ac].bwge03
      LET g_wge.wge08 = g_bwge[l_ac].bwge08
      LET g_oldds = g_bwge[l_ac].bwge06
 
    IF g_wge.wge06 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    CALL cl_set_act_visible("accept,cancel", TRUE)
    
    INPUT l_newds FROM wge06
 
       AFTER FIELD wge06
          IF l_newds IS NOT NULL THEN
             SELECT COUNT(*) INTO l_cnt FROM azp_file WHERE azp01 = l_newds
             IF l_cnt = 0 THEN
                CALL cl_err(l_newds,"-827",0)
                LET l_newds = ""
                NEXT FIELD wge06
             END IF
 
             SELECT count(*) INTO l_cnt FROM wge_file
              WHERE wge01 = g_wge.wge01 AND wge05 = g_wge.wge05 AND
                    wge06 = l_newds     AND wge07 = g_wge.wge07
             IF l_cnt > 0 THEN
                CALL cl_err(l_newds,-239,0)
                LET l_newds = ""
                NEXT FIELD wge06
             END IF
             LET g_newds =l_newds
          END IF
      
       ON ACTION controlp
          CASE WHEN INFIELD(wge06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_wge.wge06
               CALL cl_create_qry() RETURNING l_newds
               DISPLAY l_newds TO wge06
               NEXT FIELD wge06
          END CASE    
    
       ON ACTION controlf           
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
        
       ON ACTION about
          CALL cl_about()
        
       ON ACTION controlg
          CALL cl_cmdask() 
        
       ON ACTION help 
          CALL cl_show_help()
    END INPUT
    
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL plant_fill()
        CALL cl_set_act_visible("accept,cancel", FALSE)
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM wge_file
     WHERE wge01 = 'E' AND wge06 = g_wge.wge06
      INTO TEMP x
    UPDATE x SET wge06 = l_newds
    
    INSERT INTO wge_file SELECT * FROM x
    
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","wge_file",g_wge.wge06,"",SQLCA.sqlcode,"","",0)
    ELSE
       MESSAGE 'ROW(',l_newds,')O.K'
       CALL plant_fill()
       LET l_ac = g_new_ac
       CALL plant_maintain("modify")
       LET l_ac = g_old_ac
 
       LET g_new_ac = ""
       LET g_old_ac = ""
       LET g_newds = ""
       LET g_oldds = ""
    END IF
 
END FUNCTION
 
FUNCTION plant_service_setting()
   LET l_s_ac = 1
   CALL service_fill()
 
   OPEN WINDOW service_set AT 4, 16
       WITH FORM "aws/42f/aws_service_setting" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_ui_locale("aws_service_setting")
   CALL service_menu()
   CLOSE WINDOW service_set
END FUNCTION
 
FUNCTION service_menu()
   WHILE TRUE
      CALL service_bp("G")
      CASE g_action_choice
         WHEN "detail"
             IF l_s_ac != 0 THEN
                CALL service_maintain("modify")
             END IF
 
         WHEN "insert" 
               CALL service_maintain("insert")
 
         WHEN "modify"
            IF l_s_ac != 0 THEN
               CALL service_maintain("modify")
            END IF
 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION service_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_bwgf TO s_bwgf.* ATTRIBUTE(COUNT=g_cnt,UNBUFFERED)
 
      BEFORE ROW
          LET l_s_ac = ARR_CURR()
          IF l_s_ac != 0 THEN
             DISPLAY g_bwgf[l_s_ac].bwgf01 TO wgf01
             DISPLAY g_bwgf[l_s_ac].bwgf02 TO wgf02
             DISPLAY g_bwgf[l_s_ac].bwgf03 TO wgf03
             IF g_wge.wge06 IS NOT NULL THEN
                LET s04 = "http://", g_wge.wge02 CLIPPED, ":", g_wge.wge09 CLIPPED, "/", g_bwgf[l_s_ac].bwgf02 CLIPPED
                LET s05 = "http://", g_wge.wge02 CLIPPED, ":", g_wge.wge09 CLIPPED, "/", g_bwgf[l_s_ac].bwgf03 CLIPPED
             ELSE
                LET s04=""
                LET s05=""
             END IF
             DISPLAY s04 TO s04
             DISPLAY s05 TO s05
          END IF
 
      AFTER DISPLAY
          CONTINUE DISPLAY
 
      ON ACTION insert
          LET g_action_choice="insert"
          DISPLAY '' TO s04
          DISPLAY '' TO s05
          EXIT DISPLAY
 
      ON ACTION modify
          LET g_action_choice="modify"
          LET l_s_ac = ARR_CURR()
          EXIT DISPLAY
 
      ON ACTION delete
         IF l_s_ac != 0 THEN
            IF cl_delete() THEN
               DELETE FROM wgf_file WHERE wgf01 = g_bwgf[l_s_ac].bwgf01
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","wgf_file",g_bwgf[l_s_ac].bwgf01,"",SQLCA.sqlcode,"","del wga:", 0)
               END IF
               CALL service_fill()
               IF g_bwgf.getLength() = 0 THEN
                  DISPLAY '' TO wgf01
                  DISPLAY '' TO wgf02
                  DISPLAY '' TO wgf03
                  DISPLAY '' TO s04
                  DISPLAY '' TO s05
               END IF
               ACCEPT DISPLAY
            END IF
          END IF
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_s_ac = ARR_CURR()
      EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF INT_FLAG THEN                         # 若按了DEL鍵
       LET INT_FLAG = 0
   END IF
END FUNCTION
 
FUNCTION service_fill()
   LET g_sql = "SELECT wgf01,wgf02,wgf03 FROM wgf_file"
 
   PREPARE gpmcfg_pps FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90032
      EXIT PROGRAM
   END IF
   DECLARE gpmcfg_css CURSOR FOR gpmcfg_pps
   CALL g_bwgf.clear()
   LET g_cnt=1
   FOREACH gpmcfg_css INTO g_bwgf[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     LET g_cnt=g_cnt+1
   END FOREACH
   CALL g_bwgf.deleteElement(g_cnt)
   LET g_cnt=g_cnt - 1
END FUNCTION
 
FUNCTION service_maintain(p_cmd)
    DEFINE
        p_cmd       LIKE type_file.chr20,
        l_cnt       LIKE type_file.num10,
        l_wgf01     LIKE wgf_file.wgf01
       
    INITIALIZE g_wgf.* TO NULL
    LET g_action_choice = ""
    
    IF p_cmd = "modify" THEN
       LET g_wgf.wgf01 = g_bwgf[l_s_ac].bwgf01
       LET g_wgf.wgf02 = g_bwgf[l_s_ac].bwgf02
       LET g_wgf.wgf03 = g_bwgf[l_s_ac].bwgf03
       LET l_wgf01 = g_bwgf[l_s_ac].bwgf01
       CALL cl_set_comp_entry("wgf01", FALSE)
    END IF
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT BY NAME g_wgf.wgf01,g_wgf.wgf02,g_wgf.wgf03 WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
       AFTER FIELD wgf01
             IF p_cmd = "insert" THEN
                SELECT COUNT(*) INTO l_cnt FROM wgf_file WHERE wgf01 = g_wgf.wgf01
                IF l_cnt > 0 THEN
                   CALL cl_err(g_wgf.wgf01,-239,0)
                   LET g_wgf.wgf01=""
                   NEXT FIELD wgf01
                END IF
             END IF
 
       ON ACTION CONTROLF                   # 欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
        
       ON ACTION about
          CALL cl_about()
        
       ON ACTION controlg
          CALL cl_cmdask()
        
       ON ACTION help
          CALL cl_show_help()
 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL service_fill()
        IF p_cmd = "modify" THEN
           CALL cl_set_comp_entry("wgf01", TRUE)
        END IF
        CALL cl_set_act_visible("accept,cancel", FALSE)
        RETURN
    END IF
 
    IF p_cmd ="insert" THEN
        INSERT INTO wgf_file VALUES(g_wgf.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","wgf_file",g_wgf.wgf01,"",SQLCA.sqlcode,"","",0)
        END IF
    ELSE
        UPDATE wgf_file SET wgf01 = g_wgf.wgf01,
                            wgf02 = g_wgf.wgf02,
                            wgf03 = g_wgf.wgf03
                      WHERE wgf01 = l_wgf01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wgf_file",g_wgf.wgf01,"",SQLCA.sqlcode,"","",0)
        END IF
    END IF
 
    CALL service_fill()
 
    IF p_cmd = "modify" THEN
       CALL cl_set_comp_entry("wgf01", TRUE)
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION
#--FUN-880054--end--
