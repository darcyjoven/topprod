# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aimp100.4gl
# Descriptions...: 基本資料拋轉作業
# Input parameter:
# Date & Author..: 07/12/11 By Carrier FUN-7C0010
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_aimi100_carry的參數
# Modify.........: NO.FUN-840033 08/04/08 BY Yiting  aimp100->aimi100 直接開啟主畫面
# Modify.........: No.FUN-840103 08/04/20 By Carrier 加入ima901
# Modify.........: NO.FUN-850117 08/05/20 BY Yitign  control-f無此功能
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu b_fill() 撈 ima 時應加上 企業料號的條件
# Modify.........: No.MOD-B30213 11/03/12 By sabrina 若是在icd業則點選"料件基本資料明細"應執行aimi100_icd
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global" #FUN-7C0010
 
DEFINE tm1        RECORD
                  gev04    LIKE gev_file.gev04,
                  geu02    LIKE geu_file.geu02,
                 # wc       LIKE type_file.chr1000
                  wc       string     #NO.FUN-910082
                  END RECORD
DEFINE g_rec_b	  LIKE type_file.num10
DEFINE g_rec_b2   LIKE type_file.num10
DEFINE g_ima      DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  ima01    LIKE ima_file.ima01,
                  ima02    LIKE ima_file.ima02,
                  ima021   LIKE ima_file.ima021,
                  ima06    LIKE ima_file.ima06,
                  ima08    LIKE ima_file.ima08,
                  ima130   LIKE ima_file.ima130,
                  ima109   LIKE ima_file.ima109,
                  ima25    LIKE ima_file.ima25,
                  ima37    LIKE ima_file.ima37,
                  ima901   LIKE ima_file.ima901,   #No.FUN-840103
                  ima1010  LIKE ima_file.ima1010,
                  imaacti  LIKE ima_file.imaacti
                  END RECORD
DEFINE g_ima1     DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  ima01    LIKE ima_file.ima01 
                  END RECORD
DEFINE #g_sql      LIKE type_file.chr1000
       g_sql      STRING     #NO.FUN-910082
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
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_db_type=cl_db_get_database_type()
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p100_w AT p_row,p_col
        WITH FORM "aim/42f/aimp100"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT * FROM gev_file WHERE gev01 = '1' AND gev02 = g_plant
                            AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_plant,'aoo-036',1)   #Not Carry DB
      EXIT PROGRAM
   END IF
 
   CALL p100_tm()
   CALL p100_menu()
 
   CLOSE WINDOW p100_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p100_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL p100_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p100_tm()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL p100()
            END IF
            
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL p100_download()
            END IF
            
         WHEN "item_detail_maintain"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  #LET l_cmd='aimi100 "',g_ima[l_ac].ima01,'"'
                 #MOD-B30213---modify---start---
                 #LET l_cmd='aimi100 "',g_ima[l_ac].ima01,'" "Y"'   #NO.FUN-840033
                  IF s_industry('icd') THEN
                     LET l_cmd='aimi100_icd "',g_ima[l_ac].ima01,'" "Y"'   
                  ELSE
                     LET l_cmd='aimi100 "',g_ima[l_ac].ima01,'" "Y"'   
                  END IF
                 #MOD-B30213---modify---end---
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p100_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    CLEAR FORM
    CALL g_ima.clear()
 
    LET INT_FLAG = 0 
 
    INITIALIZE tm1.* TO NULL            # Default condition
    LET tm1.gev04=NULL
    LET tm1.geu02=NULL
 
    SELECT gev04 INTO tm1.gev04 FROM gev_file
     WHERE gev01 = '1' AND gev02 = g_plant
    SELECT geu02 INTO tm1.geu02 FROM geu_file
     WHERE geu01 = tm1.gev04
    DISPLAY tm1.gev04 TO gev04
    DISPLAY tm1.geu02 TO geu02
 
    #DISPLAY BY NAME tm1.*
 
    #INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS
 
    #   AFTER FIELD gev04
    #      IF NOT cl_null(tm1.gev04) THEN
    #         CALL p100_gev04()
    #         IF NOT cl_null(g_errno) THEN
    #            CALL cl_err(tm1.gev04,g_errno,0)
    #            NEXT FIELD gev04
    #         END IF
    #      ELSE
    #         DISPLAY '' TO geu02
    #      END IF
 
    #   ON ACTION CONTROLP
    #      CASE
    #         WHEN INFIELD(gev04)
    #            CALL cl_init_qry_var()
    #            LET g_qryparam.form = "q_gev04"
    #            LET g_qryparam.arg1 = "1"
    #            LET g_qryparam.arg2 = g_plant
    #            CALL cl_create_qry() RETURNING tm1.gev04
    #            DISPLAY BY NAME tm1.gev04
    #            NEXT FIELD gev04
    #         OTHERWISE EXIT CASE
    #      END CASE
 
    #   ON ACTION locale
    #      CALL cl_show_fld_cont()
    #      LET g_action_choice = "locale"
 
    #   ON IDLE g_idle_seconds
    #      CALL cl_on_idle()
    #      CONTINUE INPUT
 
    #   ON ACTION controlg
    #      CALL cl_cmdask()
 
    #   ON ACTION exit
    #      LET INT_FLAG = 1
    #      EXIT INPUT
 
    #END INPUT
 
    #IF INT_FLAG THEN
    #   LET INT_FLAG=0
    #   CLOSE WINDOW p100_w
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
    #   EXIT PROGRAM
    #END IF
 
    CALL g_ima.clear()
    CONSTRUCT tm1.wc ON ima01,ima02,ima021,ima06,ima08,ima130,
                        ima109,ima25,ima37,ima901,ima1010,imaacti  #FUN-840103
         FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021,
              s_ima[1].ima06,s_ima[1].ima08,s_ima[1].ima130,
              s_ima[1].ima109,s_ima[1].ima25,s_ima[1].ima37,
              s_ima[1].ima901,s_ima[1].ima1010,s_ima[1].imaacti  #FUN-840103
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
    
       ON ACTION controlp
          CASE
             WHEN INFIELD(ima01) #料件編號    #FUN-4B0001
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form     = "q_ima"
             #   LET g_qryparam.state    = "c"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01
             WHEN INFIELD(ima06) #分群碼
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imz"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima06
                NEXT FIELD ima06
             WHEN INFIELD(ima109)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_azf"
                LET g_qryparam.state    = "c"
                LET g_qryparam.arg1     = "8"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima109
                NEXT FIELD ima109
             WHEN INFIELD(ima25) #庫存單位
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_gfe"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima25
                NEXT FIELD ima25
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
 
       #--NO.FUN-850117 start--
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
       #--NO.FUN-850117 end----
 
    END CONSTRUCT
    LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    
    CALL p100_b_fill()
    CALL p100_b()
 
END FUNCTION
 
FUNCTION p100_b_fill()
  DEFINE l_i         LIKE type_file.num10
 
    LET g_sql = " SELECT 'N',ima01,ima02,ima021,ima06,ima08,",
                "        ima130,ima109,ima25,ima37,ima901,ima1010,",  #No.FUN-840103
                "        imaacti ",
                "   FROM ima_file ",
                "  WHERE ",tm1.wc,
                "  AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) ",    #FUN-AB0025 add
                "  ORDER BY ima01 "
    PREPARE ima_p1 FROM g_sql
    DECLARE sel_ima_cur CURSOR FOR ima_p1
      
    CALL g_ima.clear()
    LET l_i = 1
    FOREACH sel_ima_cur INTO g_ima[l_i].*   #單身 ARRAY 填充
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
    CALL g_ima.deleteElement(l_i)
    LET g_rec_b = l_i - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION p100_b()
  
    SELECT * FROM gev_file
     WHERE gev01 = '1' AND gev02 = g_plant
       AND gev03 = 'Y' AND gev04 = tm1.gev04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_plant,'aoo-036',1)
       RETURN
    END IF
    
    DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
    IF g_rec_b = 0 THEN
       LET g_action_choice=''
       RETURN
    END IF
 
    INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION select_all
          CALL p100_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p100_sel_all_1("N")
 
       ON ACTION qry_carry_history
          IF l_ac > 0 AND NOT cl_null(g_ima[l_ac].ima01) THEN
             LET g_sql='aooq604 "',tm1.gev04,'" "1" "aimp100" "',g_ima[l_ac].ima01,'"'
             CALL cl_cmdrun(g_sql)
          END IF
            
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
 
    LET g_action_choice=''
    IF INT_FLAG THEN
       LET INT_FLAG=0
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p100_gev04()
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
       SELECT * FROM gev_file WHERE gev01 = '1' AND gev02 = g_plant
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
 
   FOR l_i = 1 TO g_ima.getLength()
       LET g_ima[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p100()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
 
   CALL g_ima1.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_ima.getLength()
       IF g_ima[l_i].sel = 'Y' AND NOT cl_null(g_ima[l_i].ima01) THEN
          LET g_ima1[l_j].sel   = g_ima[l_i].sel
          LET g_ima1[l_j].ima01 = g_ima[l_i].ima01
          LET l_j = l_j + 1
       END IF
   END FOR
   #No.FUN-830090  --Begin
   IF l_j = 1 THEN
      CALL cl_err('','aoo-096',0)
      RETURN
   END IF
   #No.FUN-830090  --End  
 
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(tm1.gev04,'1')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL s_showmsg_init()
   CALL s_aimi100_carry(g_ima1,g_azp,tm1.gev04,'0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION p100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION item_detail_maintain
         LET g_action_choice="item_detail_maintain"
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
 
FUNCTION p100_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10  #No.FUN-830090
  DEFINE l_flag       LIKE type_file.chr1   #No.FUN-830090
  DEFINE l_j          LIKE type_file.num10  #No.FUN-840103
 
   #No.FUN-830090  --Begin
   LET l_flag = 'N'
   CALL g_ima1.clear()  #No.FUN-840103
   LET l_j = 1          #No.FUN-840103
   FOR l_i = 1 TO g_ima.getLength()
       IF g_ima[l_i].sel = 'Y' AND NOT cl_null(g_ima[l_i].ima01) THEN
          LET l_flag = 'Y'
          #No.FUN-840103  --Begin
          LET g_ima1[l_j].sel = 'Y'
          LET g_ima1[l_j].ima01 = g_ima[l_i].ima01
          LET l_j = l_j + 1
          #No.FUN-840103  --End
       END IF
   END FOR
   IF l_flag = 'N' THEN
      CALL cl_err('','aoo-096',0)
      RETURN
   END IF
   #No.FUN-830090  --End  
 
   #No.FUN-840103  --Begin
   CALL s_aimi100_download(g_ima1)
 
   #CALL s_dc_download_path() RETURNING l_path
   #IF cl_null(l_path) THEN RETURN END IF
   #CALL p100_download_files(l_path)
   #No.FUN-840103  --End  
 
END FUNCTION
 
FUNCTION p100_download_files(p_path)
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
 
   CALL s_dc_cre_temp_table("ima_file") RETURNING l_tabname
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM ima_file",
                                                 "  WHERE ima01 = ?"
   PREPARE ins_pp FROM g_sql
 
   FOR l_i = 1 TO g_ima.getLength()
       IF cl_null(g_ima[l_i].ima01) THEN
          CONTINUE FOR
       END IF
       IF g_ima[l_i].sel = 'N' THEN
          CONTINUE FOR
       END IF
       EXECUTE ins_pp USING g_ima[l_i].ima01
       IF SQLCA.sqlcode THEN
          LET l_str = 'ins ',l_tabname CLIPPED   #No.FUN-A80036                 
          CALL cl_err(l_str,SQLCA.sqlcode,1)     #No.FUN-A80036
          CONTINUE FOR
       END IF
   END FOR
   
   LET l_upload_file = l_tempdir CLIPPED,'/aimi100_ima_file_1.txt'  #No.FUN-840103
   LET l_download_file = p_path CLIPPED,"/aimi100_ima_file_1.txt"   #No.FUN-840103
   
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
