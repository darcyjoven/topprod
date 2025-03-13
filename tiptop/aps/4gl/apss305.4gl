# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apss305.4gl
# Descriptions...: aps 站台設定作業
# Date & Author..: 08/05/17 By kevin #FUN-840179
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: FUN-B50003 11/05/05 By Abby---GP5.25 追版---str---------------
# Modify.........: No: FUN-940090 09/04/16 By Duke 加上顯示營運中心名稱
# Modify.........: No: FUN-A10128 10/01/25 By Mandy 當營運中心輸入重覆時,按放棄會無法跳出
# Modify.........: FUN-B50003 11/05/05 By Abby---GP5.25 追版---end---------------
# Modify.........: FUN-B90030 11/09/05 By minpp 程序撰写规范修改 
DATABASE ds

GLOBALS "../../config/top.global"
 
 
DEFINE

    g_vlg   RECORD LIKE vlg_file.*,
    g_vlg_t RECORD LIKE vlg_file.*,
    g_cnt   LIKE type_file.num10,
    g_sql   STRING,
    
    g_bvlg  DYNAMIC ARRAY OF RECORD
        bvlg01  LIKE vlg_file.vlg01,
        bvlg02  LIKE vlg_file.vlg02,
        bvlg03  LIKE vlg_file.vlg03,
        bvlg04  LIKE vlg_file.vlg04
        
    END RECORD,
    
    l_ac    LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_azp02 LIKE azp_file.azp02     #FUN-940090 ADD
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680130 SMALLINT
#        l_time          LIKE type_file.chr8    #No.FUN-680130 VARCHAR(8)  #No.FUN-6A0091
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
 
    LET p_row = 4 LET p_col = 6
    
    LET l_ac = 1
 
    CALL plant_fill()
    
    OPEN WINDOW apss305 AT 4, 16
        WITH FORM "aps/42f/apss305" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
    
    CALL cl_ui_locale("apss305")
 
    CALL plant_menu()
 
    CLOSE WINDOW apss305
 
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
    DISPLAY ARRAY g_bvlg TO s_bvlg.* ATTRIBUTE(COUNT=g_cnt,UNBUFFERED)
 
      BEFORE ROW
          LET l_ac = ARR_CURR()
          IF l_ac != 0 THEN
             DISPLAY g_bvlg[l_ac].bvlg01 TO vlg01

            #FUN-940090  ADD  --STR--
             SELECT azp02 INTO l_azp02
               FROM azp_file
              WHERE azp01 = g_bvlg[l_ac].bvlg01
             DISPLAY l_azp02 TO FORMONLY.azp02
            #FUN-940090  ADD  --END--

             DISPLAY g_bvlg[l_ac].bvlg02 TO vlg02
             DISPLAY g_bvlg[l_ac].bvlg03 TO vlg03
             DISPLAY g_bvlg[l_ac].bvlg04 TO vlg04
             
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
               DELETE FROM vlg_file WHERE vlg01 = g_bvlg[l_ac].bvlg01
               IF SQLCA.SQLCODE THEN
                  #CALL cl_err('del vlg_file: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","vlg_file",g_bvlg[l_ac].bvlg01,"",SQLCA.sqlcode,"","", 1)   #No.FUN-660155)   #No.FUN-660155
               END IF
               CALL plant_fill()
               IF g_bvlg.getLength() = 0 THEN
                  DISPLAY '' TO vlg01
                  DISPLAY '' TO vlg02
                  DISPLAY '' TO vlg03
                  DISPLAY '' TO vlg04
                  
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
    LET g_sql = "SELECT vlg01,vlg02,vlg03,vlg04 FROM vlg_file "
 
    PREPARE apscfg_pp FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B90030
       EXIT PROGRAM
    END IF
    DECLARE apscfg_cs2 CURSOR FOR apscfg_pp
    CALL g_bvlg.clear()
    LET g_cnt=1
    FOREACH apscfg_cs2 INTO g_bvlg[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
   END FOREACH
   CALL g_bvlg.deleteElement(g_cnt)
   
END FUNCTION
 
FUNCTION plant_maintain(p_cmd)
    DEFINE
        p_cmd       LIKE type_file.chr20,   #No.FUN-680130 VARCHAR(10) 
        l_cnt       LIKE type_file.num10,    #No.FUN-680130 INTEGER
        l_vlg01     LIKE vlg_file.vlg01
 
    INITIALIZE g_vlg.* TO NULL
    LET  l_azp02 = ''                   #FUN-940090 ADD
    DISPLAY l_azp02 TO FORMONLY.azp02   #FUN-940090 ADD
    LET g_action_choice = ""
    
    IF p_cmd = "modify" THEN
       LET g_vlg.vlg01 = g_bvlg[l_ac].bvlg01
       LET g_vlg.vlg02 = g_bvlg[l_ac].bvlg02
       LET g_vlg.vlg03 = g_bvlg[l_ac].bvlg03
       LET g_vlg.vlg04 = g_bvlg[l_ac].bvlg04
       
      #FUN-940090  ADD  --STR--
       SELECT azp02 INTO l_azp02
         FROM azp_file
        WHERE azp01 = g_vlg.vlg01
       DISPLAY l_azp02  TO FORMONLY.azp02
      #FUN-940090  ADD  --END--

       LET l_vlg01 = g_bvlg[l_ac].bvlg01
       CALL cl_set_comp_entry("vlg01", FALSE)
    END IF
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT BY NAME g_vlg.vlg01,g_vlg.vlg02,g_vlg.vlg03,g_vlg.vlg04
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
           #LET g_vlg.vlg01 = 'E'
           #LET g_vlg.vlg05 = '*'
           #LET g_vlg.vlg07 = '*'
 
        AFTER FIELD vlg01
           IF g_vlg.vlg01 IS NOT NULL THEN
                SELECT COUNT(*) INTO l_cnt FROM azp_file
                        where azp01 = g_vlg.vlg01
                IF l_cnt = 0 THEN
                   CALL cl_err(g_vlg.vlg01,"-827",0)
                   NEXT FIELD vlg01
               #FUN-940090 ADD  --STR--
                ELSE
                   SELECT azp02 INTO l_azp02
                     FROM azp_file
                    WHERE azp01 = g_vlg.vlg01
                   DISPLAY l_azp02  TO FORMONLY.azp02
               #FUN-940090 ADD  --END--
                END IF
                #FUN-A10128---add---str---
                IF p_cmd = "insert" THEN
                   SELECT COUNT(*) INTO l_cnt FROM vlg_file
                     WHERE vlg01 = g_vlg.vlg01
                   IF l_cnt > 0 THEN
                       CALL cl_err(g_vlg.vlg01,-239,1)
                       NEXT FIELD vlg01
                   END IF
                END IF
                #FUN-A10128---add---end---
           END IF

       #FUN-A10128 mark---str---
       #AFTER INPUT
       #   IF p_cmd = "insert" THEN
       #      SELECT COUNT(*) INTO l_cnt FROM vlg_file
       #        WHERE vlg01 = g_vlg.vlg01
       #      IF l_cnt > 0 THEN
       #          CALL cl_err(g_vlg.vlg01,-239,0)
       #          NEXT FIELD vlg01
       #      END IF
       #   END IF
       #FUN-A10128 mark---end---
 
        ON ACTION controlp
           CASE WHEN INFIELD(vlg01)
              CALL cl_init_qry_var()
             #LET g_qryparam.form = "q_azp"    #FUN-940090 MARK
              LET g_qryparam.form = "q_azp2"   #FUN-940090 add
              LET g_qryparam.default1 = g_vlg.vlg01
             #CALL cl_create_qry() RETURNING g_vlg.vlg01           #FUN-940090 MARK
              CALL cl_create_qry() RETURNING g_vlg.vlg01, l_azp02  #FUN-940090 ADD
             #DISPLAY BY NAME g_vlg.vlg01        #FUN-940090 MARK
              DISPLAY BY NAME g_vlg.vlg01        #FUN-940090 ADD
              DISPLAY l_azp02 TO FORMONLY.azp02  #FUN-940090 ADD
              NEXT FIELD vlg01
           END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL plant_fill()
        IF p_cmd = "modify" THEN
           CALL cl_set_comp_entry("vlg01", TRUE)
        END IF
        CALL cl_set_act_visible("accept,cancel", FALSE)
        RETURN
    END IF
    IF p_cmd ="insert" THEN
        INSERT INTO vlg_file VALUES(g_vlg.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_vlg.vlg01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("ins","vlg_file",g_vlg.vlg01,"",SQLCA.sqlcode,"","",1)
        END IF
    ELSE
        UPDATE vlg_file SET vlg01 = g_vlg.vlg01,
                            vlg02 = g_vlg.vlg02,
                            vlg03 = g_vlg.vlg03,
                            vlg04 = g_vlg.vlg04                            
            WHERE vlg01 = l_vlg01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","vlg_file",g_vlg.vlg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660155
        END IF
    END IF
    CALL plant_fill()
 
    IF p_cmd = "modify" THEN
       CALL cl_set_comp_entry("vlg01", TRUE)
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION
#FUN-B50003
