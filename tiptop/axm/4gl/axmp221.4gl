# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmp221.4gl
# Descriptions...: 客戶資料拋轉作業
# Date & Author..: 08/02/26 By Carrier FUN-7C0010
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_axmi221_carry的參數
# Modify.........: NO.FUN-840033 08/04/08 BY yiting add cust_detail
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global" #FUN-7C0010
 
DEFINE tm1        RECORD
                  gev04    LIKE gev_file.gev04,
                  geu02    LIKE geu_file.geu02,
                  #wc       LIKE type_file.chr1000
                  wc         STRING       #NO.FUN-910082
                  END RECORD
DEFINE g_rec_b    LIKE type_file.num10
DEFINE g_rec_b1   LIKE type_file.num10
DEFINE g_rec_b2   LIKE type_file.num10
DEFINE g_occ      DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  occ01    LIKE occ_file.occ01,
                  occ02    LIKE occ_file.occ02,
                  occ03    LIKE occ_file.occ03,
                  occ04    LIKE occ_file.occ04,     
                  occ05    LIKE occ_file.occ05,
                  occ06    LIKE occ_file.occ06,
                  occ22    LIKE occ_file.occ22,
                  occ21    LIKE occ_file.occ21,
                  occ20    LIKE occ_file.occ20,
                  occ11    LIKE occ_file.occ11,
                  occ1004  LIKE occ_file.occ1004,
                  occacti  LIKE occ_file.occacti
                  END RECORD
DEFINE g_occ1     DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  occ01    LIKE occ_file.occ01
                  END RECORD
DEFINE #g_sql      LIKE type_file.chr1000
       g_sql    STRING     #NO.FUN-910082
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_db_type=cl_db_get_database_type()
 
   OPEN WINDOW p221_w WITH FORM "axm/42f/axmp221"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT * FROM gev_file WHERE gev01 = '4' AND gev02 = g_plant
                            AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_plant,'aoo-036',1)   #Not Carry DB
      EXIT PROGRAM
   END IF
 
   CALL p221_tm()
   CALL p221_menu()
 
   CLOSE WINDOW p221_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p221_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL p221_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p221_tm()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p221_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL p221()
            END IF
            
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL p221_download()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_occ),'','')
            END IF
         #no.FUN-840033 add-------
         WHEN "cust_detail_maintain"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  LET l_cmd = 'axmi221 "',g_occ[l_ac].occ01,'" "Y" '
                  CALL cl_cmdrun(l_cmd)
               END IF
            END IF
         #no.FUN-840033 add-------
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p221_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    CLEAR FORM
    CALL g_occ.clear()
 
    LET INT_FLAG = 0
 
    INITIALIZE tm1.* TO NULL            # Default condition
    LET tm1.gev04=NULL
    LET tm1.geu02=NULL
 
    SELECT gev04 INTO tm1.gev04 FROM gev_file
     WHERE gev01 = '4' AND gev02 = g_plant
    SELECT geu02 INTO tm1.geu02 FROM geu_file
     WHERE geu01 = tm1.gev04
    DISPLAY tm1.gev04 TO gev04
    DISPLAY tm1.geu02 TO geu02
   #DISPLAY BY NAME tm1.*
 
   #INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS
 
   #   AFTER FIELD gev04
   #      IF NOT cl_null(tm1.gev04) THEN
   #         CALL p221_gev04()
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
   #            LET g_qryparam.arg1 = "4"
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
   #   CLOSE WINDOW p221_w
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #   EXIT PROGRAM
   #END IF
 
    CALL g_occ.clear()
    CONSTRUCT tm1.wc ON occ01,occ02,occ03,occ04,occ05,occ06,
                        occ22,occ21,occ20,occ11,occ1004,
                        occacti
         FROM s_occ[1].occ01,s_occ[1].occ02,s_occ[1].occ03, 
              s_occ[1].occ04,s_occ[1].occ05,s_occ[1].occ06, 
              s_occ[1].occ22,s_occ[1].occ21,s_occ[1].occ20, 
              s_occ[1].occ11,s_occ[1].occ1004,s_occ[1].occacti
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
    
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(occ01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ01
                  NEXT FIELD occ01
             WHEN INFIELD(occ03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oca'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ03
                  NEXT FIELD occ03
             WHEN INFIELD(occ04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gen'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ04
                  NEXT FIELD occ04
             WHEN INFIELD(occ20)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gea'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ20
                  NEXT FIELD occ20
             WHEN INFIELD(occ21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_geb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ21
                  NEXT FIELD occ21
             WHEN INFIELD(occ22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_geo'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ22
                  NEXT FIELD occ22
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
    LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup') #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    
    CALL p221_b_fill()
    CALL p221_b()
 
END FUNCTION
 
FUNCTION p221_b_fill()
  DEFINE l_i         LIKE type_file.num10
 
     LET g_sql = " SELECT 'N',occ01,occ02,occ03,occ04,occ05,occ06,",
                 "        occ22,occ21,occ20,occ11,occ1004,occacti ",
                 "   FROM occ_file ",
                 "  WHERE occ1004 = '1'",
                 "    AND ",tm1.wc,
                 "  ORDER BY occ01"
    PREPARE occ_p1 FROM g_sql
    DECLARE sel_occ_cur CURSOR FOR occ_p1
      
    CALL g_occ.clear()
    LET l_i = 1
    FOREACH sel_occ_cur INTO g_occ[l_i].*   #單身 ARRAY 填充
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
    CALL g_occ.deleteElement(l_i)
    LET g_rec_b = l_i - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
 
FUNCTION p221_b()
  
    SELECT * FROM gev_file
     WHERE gev01 = '4' AND gev02 = g_plant
       AND gev03 = 'Y' AND gev04 = tm1.gev04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_plant,'aoo-036',1)
       RETURN
    END IF
    
    DISPLAY ARRAY g_occ TO s_occ.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
    IF g_rec_b = 0 THEN
       LET g_action_choice=''
       RETURN
    END IF
 
    INPUT ARRAY g_occ WITHOUT DEFAULTS FROM s_occ.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW  #No.FUN-830090
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION select_all
          CALL p221_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p221_sel_all_1("N")
 
       ON ACTION qry_carry_history
          IF l_ac > 0 AND NOT cl_null(g_occ[l_ac].occ01) THEN
             LET g_sql='aooq604 "',tm1.gev04,'" "4" "axmp221" "',g_occ[l_ac].occ01,'"'
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
 
FUNCTION p221_gev04()
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
       SELECT * FROM gev_file WHERE gev01 = '4' AND gev02 = g_plant
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
 
FUNCTION p221_sel_all_1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_occ.getLength()
       LET g_occ[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p221()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
 
   CALL g_occ1.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_occ.getLength()
       IF g_occ[l_i].sel = 'Y' AND NOT cl_null(g_occ[l_i].occ01) THEN
          LET g_occ1[l_j].sel   = g_occ[l_i].sel
          LET g_occ1[l_j].occ01 = g_occ[l_i].occ01
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
   CALL s_dc_sel_db(tm1.gev04,'4')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL s_showmsg_init()
   CALL s_axmi221_carry_occ(g_occ1,g_azp,tm1.gev04,'1','0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION p221_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_occ TO s_occ.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      #--NO.FUN-840033 add--
      ON ACTION cust_detail_maintain
         LET g_action_choice="cust_detail_maintain"
         EXIT DISPLAY
    　#--NO.FUN-840033 add--
 
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
         LET g_action_choice="occ_detail"
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
 
FUNCTION p221_download()
   DEFINE l_i    LIKE type_file.num10
   DEFINE l_j    LIKE type_file.num10
 
   CALL g_occ1.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_occ.getLength()
       IF g_occ[l_i].sel = 'Y' AND NOT cl_null(g_occ[l_i].occ01) THEN
          LET g_occ1[l_j].sel   = g_occ[l_i].sel
          LET g_occ1[l_j].occ01 = g_occ[l_i].occ01
          LET l_j = l_j + 1
       END IF
   END FOR
 
   #No.FUN-830090  --Begin
   IF l_j = 1 THEN
      CALL cl_err('','aoo-096',0)
      RETURN
   END IF
   #No.FUN-830090  --End  
 
   CALL s_axmi221_download(g_occ1)
 
END FUNCTION
