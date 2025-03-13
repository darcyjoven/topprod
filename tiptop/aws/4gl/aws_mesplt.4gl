# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aws_mesplt.4gl
# Descriptions...: mes 站台設定作業
# Date & Author..: 07/07/24 By Jamie
# Modify.........: No.FUN-870101 07/07/24 By Jamie 新增MES Web Service Client
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AC0068 10/12/27 By Lilan 新增CRM整合站台設定功能(aws_crmplt) 
# Modify.........: No.FUN-9A0095 11/04/15 By Abby 將畫面上的IP位址及HTTP網址欄位隱藏
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改
# Modify.........: No.FUN-C20087 12/03/06 By Abby 新增CROSS平台整合(aws_crmplt不提供操作)
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
#FUN-870101 
#--------#No.FUN-6C0040 --------
DEFINE
    g_wge   RECORD LIKE wge_file.*,
    g_wge_t RECORD LIKE wge_file.*,
    g_cnt   LIKE type_file.num10,
    g_sql   STRING,
    g_argv1 STRING,                      #FUN-AC0068 add
    
    g_bwge  DYNAMIC ARRAY OF RECORD
        bwge06  LIKE wge_file.wge06,
        bwge04  LIKE wge_file.wge04,
        bwge02  LIKE wge_file.wge02,
        bwge03  LIKE wge_file.wge03,
        bwge08  LIKE wge_file.wge08
    END RECORD,
    
    l_ac    LIKE type_file.num5          #目前處理的ARRAY CNT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680130 SMALLINT
#       l_time          LIKE type_file.chr8    #No.FUN-680130 VARCHAR(8)  #No.FUN-6A0091
    DEFINE l_wap02      LIKE wap_file.wap02    #FUN-C20087    

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
 
   #CALL plant_fill()    #FUN-AC0068 mark
    
    OPEN WINDOW mescfg_exc AT 4, 16
        WITH FORM "aws/42f/aws_mesplt" ATTRIBUTE(STYLE = g_win_style)

   #FUN-AC0068 add str --------
    LET g_argv1 = ARG_VAL(1)
    IF g_argv1 = '2' THEN
       LET g_prog = 'aws_crmplt'  
       CALL cl_set_locale_frm_name("aws_crmplt")
    #FUN-9A0095 add str ------------------
    ELSE
       CALL cl_set_comp_visible("wge02",FALSE)
       CALL cl_set_comp_visible("wge08",FALSE)
       CALL cl_set_comp_visible("bwge02",FALSE)
       CALL cl_set_comp_visible("bwge08",FALSE)
    #FUN-9A0095 add end ------------------
    END IF
   #FUN-AC0068 add end --------  

    CALL plant_fill()    #FUN-AC0068 add
 
    CALL cl_ui_init()

   #FUN-C20087 add str ----------
    IF g_argv1 = '2' THEN
       SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
       IF SQLCA.SQLCODE THEN
          CALL cl_err("wap_file", SQLCA.SQLCODE, 1)
       END IF
       IF l_wap02 = "Y" THEN
          CALL cl_err(NULL,"aws-802", 1)
          CALL cl_cmdrun("aws_crosscfg prod_detail") #crosscfg站台設定
          EXIT PROGRAM
       END IF
    END IF
   #FUN-C20087 add end ----------

    IF g_prog = "aws_mesplt" THEN         #FUN-AC0068 add   
       CALL cl_ui_locale("aws_mesplt")
    END IF                                #FUN-AC0068 add 

    CALL plant_menu()
 
    CLOSE WINDOW mescfg_exc
 
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
 
      BEFORE ROW
          LET l_ac = ARR_CURR()
          IF l_ac != 0 THEN
             DISPLAY g_bwge[l_ac].bwge06 TO wge06
             DISPLAY g_bwge[l_ac].bwge04 TO wge04
             DISPLAY g_bwge[l_ac].bwge02 TO wge02
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
              #DELETE FROM wge_file WHERE wge01 = 'M' AND wge05 = '*'  #FUN-AC0068 mark
              #   AND wge06 = g_bwge[l_ac].bwge06 AND wge07='*'        #FUN-AC0068 mark

              #FUN-AC0068 add str ---------
               CASE
                  WHEN g_prog = "aws_mesplt"               
                     DELETE FROM wge_file WHERE wge01 = 'M' AND wge05 = '*'
                        AND wge06 = g_bwge[l_ac].bwge06 AND wge07='*'

                  WHEN g_prog = "aws_crmplt"    
                     DELETE FROM wge_file WHERE wge01 = 'C' AND wge05 = '*'
                        AND wge06 = g_bwge[l_ac].bwge06 AND wge07='*'                  
               END CASE
              #FUN-AC0068 add end ---------
               IF SQLCA.SQLCODE THEN
                 #CALL cl_err('del wga: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wge_file",g_bwge[l_ac].bwge06,"",SQLCA.sqlcode,"","del wga:", 0)   #No.FUN-660155)   #No.FUN-660155
               END IF
               CALL plant_fill()
               IF g_bwge.getLength() = 0 THEN
                  DISPLAY '' TO wge06
                  DISPLAY '' TO wge04
                  DISPLAY '' TO wge02
                  DISPLAY '' TO wge03
                  DISPLAY '' TO wge08
               END IF
               ACCEPT DISPLAY
            END IF
         END IF
 
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
   #LET g_sql = "SELECT wge06,wge04,wge02,wge03,wge08 FROM wge_file where wge01='M'"  #FUN-AC0068 add

   #FUN-AC0068 add str ---------
    CASE
       WHEN g_prog = "aws_mesplt"
            LET g_sql = "SELECT wge06,wge04,wge02,wge03,wge08 FROM wge_file where wge01='M'"
       WHEN g_prog = "aws_crmplt"
            LET g_sql = "SELECT wge06,wge04,wge02,wge03,wge08 FROM wge_file where wge01='C'"
    END CASE
   #FUN-AC0068 add end ---------
 
    PREPARE mescfg_pp FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90032
       EXIT PROGRAM
    END IF
    DECLARE mescfg_cs2 CURSOR FOR mescfg_pp
    CALL g_bwge.clear()
    LET g_cnt=1
    FOREACH mescfg_cs2 INTO g_bwge[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
   END FOREACH
   CALL g_bwge.deleteElement(g_cnt)
   
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
       LET g_wge.wge03 = g_bwge[l_ac].bwge03
       LET g_wge.wge08 = g_bwge[l_ac].bwge08
       LET l_wge06 = g_bwge[l_ac].bwge06
       CALL cl_set_comp_entry("wge06", FALSE)
    END IF
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT BY NAME g_wge.wge06,g_wge.wge04,g_wge.wge02,g_wge.wge03,g_wge.wge08
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
          #LET g_wge.wge01 = 'M'          #FUN-AC0068 mark

          #FUN-AC0068 add str ---------
           CASE
              WHEN g_prog = "aws_mesplt"
                   LET g_wge.wge01 = 'M'
                  #FUN-9A0095 add str----
                   LET g_wge.wge02 = '*'
                   LET g_wge.wge08 = '*'
                  #FUN-9A0095 add end----
              WHEN g_prog = "aws_crmplt"
                   LET g_wge.wge01 = 'C'
           END CASE
          #FUN-AC0068 add end ---------
           LET g_wge.wge05 = '*'
           LET g_wge.wge07 = '*'

        AFTER FIELD wge06
           IF g_wge.wge06 IS NOT NULL THEN
                SELECT COUNT(*) INTO l_cnt FROM azp_file
                 WHERE azp01 = g_wge.wge06
                IF l_cnt = 0 THEN
                   CALL cl_err(g_wge.wge06,"-827",0)
                   NEXT FIELD wge06
                END IF
           END IF
 
        AFTER INPUT
           IF p_cmd = "insert" THEN
              SELECT COUNT(*) INTO l_cnt FROM wge_file
               WHERE wge01 = g_wge.wge01 
                 AND wge05 = g_wge.wge05 
                 AND wge06 = g_wge.wge06 
                 AND wge07 = g_wge.wge07
              IF l_cnt > 0 THEN
                  CALL cl_err(g_wge.wge06,-239,0)
                  NEXT FIELD wge06
		  END IF
           END IF
 
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
          #CALL cl_err(g_wge.wge01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("ins","wge_file",g_wge.wge01,g_wge.wge05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    ELSE
        UPDATE wge_file SET wge06 = g_wge.wge06,
                            wge04 = g_wge.wge04,
                            wge02 = g_wge.wge02,
                            wge03 = g_wge.wge03,
                            wge08 = g_wge.wge08
         WHERE wge01 = g_wge.wge01 
           AND wge05 = g_wge.wge05 
           AND wge06 = l_wge06
           AND wge07 = g_wge.wge07
        IF SQLCA.sqlcode THEN
          #CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("upd","wge_file",g_wge.wge01,g_wge.wge05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    CALL plant_fill()
 
    IF p_cmd = "modify" THEN
       CALL cl_set_comp_entry("wge06", TRUE)
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION
