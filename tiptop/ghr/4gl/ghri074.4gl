#Prog. Version...: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri074.4gl
# Descriptions...: 待审核计件信息
# Date & Author..: 13/05/24 By lifang
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrdf    DYNAMIC ARRAY OF RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrdf01    LIKE hrdf_file.hrdf01,  
                  hrdf02    LIKE hrdf_file.hrdf02,  
                  hrat02    LIKE hrat_file.hrat02,  
                  hrat03    LIKE hrat_file.hrat03,
                  hraa02    LIKE hraa_file.hraa02,
                  hrat04    LIKE hrat_file.hrat04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrdf03    LIKE hrdf_file.hrdf03,
                  hrdf04    LIKE hrdf_file.hrdf04,
                  hrdf05    LIKE hrdf_file.hrdf05,
                  hrdf06    LIKE hrdf_file.hrdf06,
                  hrdf07    LIKE hrdf_file.hrdf07,
                  hrdfacti  LIKE hrdf_file.hrdfacti                   
               END RECORD,
 
       g_hrdf_t RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrdf01    LIKE hrdf_file.hrdf01, 
                  hrdf02    LIKE hrdf_file.hrdf02,   
                  hrat02    LIKE hrat_file.hrat02,  
                  hrat03    LIKE hrat_file.hrat03,
                  hraa02    LIKE hraa_file.hraa02,
                  hrat04    LIKE hrat_file.hrat04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrdf03    LIKE hrdf_file.hrdf03,
                  hrdf04    LIKE hrdf_file.hrdf04,
                  hrdf05    LIKE hrdf_file.hrdf05,
                  hrdf06    LIKE hrdf_file.hrdf06,
                  hrdf07    LIKE hrdf_file.hrdf07,
                  hrdfacti  LIKE hrdf_file.hrdfacti 
               END RECORD,
    g_hrdf_ins     RECORD LIKE hrdf_file.*,
    g_success      LIKE type_file.chr1,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5,
    g_flag          LIKE type_file.chr1
 
DEFINE g_forupd_sql STRING   
DEFINE g_cnt        LIKE type_file.num10  
DEFINE g_cnt2        LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col   LIKE type_file.num5  

MAIN
 
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i074_w AT p_row,p_col WITH FORM "ghr/42f/ghri074"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    LET g_wc = "hrdf05 = '003'"
    CALL cl_set_comp_visible("hrdf01",FALSE)
    CALL i074_b_fill(g_wc)
    CALL i074_menu()
    CLOSE WINDOW i074_w 
 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION i074_menu()
 
   WHILE TRUE
      CALL i074_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i074_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i074_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "unconfirm"
             IF cl_chk_act_auth() THEN
               CALL i074_unconfirm()
             END IF
 
         WHEN "closg"
             IF cl_chk_act_auth() THEN
               CALL i074_closg()
             END IF
             
         WHEN "guidang"
             IF cl_chk_act_auth() THEN
               CALL i074_guidang()
             END IF
                                    
         WHEN "sel_all"
             IF cl_chk_act_auth() THEN
              CALL i074_sel_all('Y')
             END IF
          
         WHEN "cancle_sel_all"
             IF cl_chk_act_auth() THEN
              CALL i074_sel_all('N')
             END IF             
 
      END CASE
   END WHILE
END FUNCTION 
 
FUNCTION i074_q()
   CALL i074_b_askkey()
END FUNCTION 
 
FUNCTION i074_b()
DEFINE l_hratid    LIKE hrat_file.hratid
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_c             LIKE type_file.num5,
    l_hrag07        LIKE hrag_file.hrag07
    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
      
      
    LET g_sql="SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
               "hrdf05,hrdf06,hrdf07,hrdfacti",
               "  FROM hrdf_file,hrat_file WHERE hrdf01=? AND hrdf02 = hratid "

    PREPARE g_forupd_sql FROM g_sql
    DECLARE i074_bcl CURSOR FOR g_forupd_sql      
 
    INPUT ARRAY g_hrdf WITHOUT DEFAULTS FROM s_hrdf.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF 
        
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'             
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'                                        
           LET g_before_input_done = FALSE                                                                         
           LET g_before_input_done = TRUE          
           LET g_hrdf_t.* = g_hrdf[l_ac].*           
           OPEN i074_bcl USING g_hrdf_t.hrdf01          
           IF STATUS THEN
              CALL cl_err("OPEN i074_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i074_bcl INTO g_hrdf[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdf_t.hrdf01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              IF cl_null(g_hrdf[l_ac].sure) THEN 
                 LET g_hrdf[l_ac].sure = 'Y'
              END IF
              DISPLAY g_hrdf[l_ac].sure TO sure 
              
              SELECT hraa02 INTO g_hrdf[l_ac].hraa02 
                FROM hraa_file
               WHERE hraa01 = g_hrdf[l_ac].hrat03
              DISPLAY BY NAME g_hrdf[l_ac].hraa02
              
              SELECT hrao02 INTO g_hrdf[l_ac].hrao02 
                FROM hrao_file
               WHERE hrao01 = g_hrdf[l_ac].hrat04 
              DISPLAY BY NAME g_hrdf[l_ac].hrao02
                             
              
              SELECT hrag07 INTO g_hrdf[l_ac].hrdf05 FROM hrag_file 
               WHERE hrag01 = '103' AND hrag06 = g_hrdf[l_ac].hrdf05
        
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 

    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrdf[l_ac].* = g_hrdf_t.*
         CLOSE i074_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
                   
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdf[l_ac].* = g_hrdf_t.*
          END IF
          CLOSE i074_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i074_bcl                
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
 
      ON ACTION about                     
         CALL cl_about()                  
                                          
      ON ACTION help                      
         CALL cl_show_help()              
 
    END INPUT
 
    CLOSE i074_bcl
    COMMIT WORK 
END FUNCTION              
 
FUNCTION i074_b_askkey()
    CLEAR FORM
    CALL g_hrdf.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrdf01,hrdf02,hrat02,hrat03,hrat04,hrdf03,hrdf04,hrdf05,
                       hrdf06,hrdf07,hrdfacti                     
         FROM s_hrdf[1].hrdf01,s_hrdf[1].hrdf02,s_hrdf[1].hrat02,s_hrdf[1].hrat03,s_hrdf[1].hrat04,s_hrdf[1].hrdf03,s_hrdf[1].hrdf04,
              s_hrdf[1].hrdf05,s_hrdf[1].hrdf06,s_hrdf[1].hrdf07,s_hrdf[1].hrdfacti

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
              WHEN INFIELD(hrdf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdf02
                 NEXT FIELD hrdf02
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03                 
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrdfuser', 'hrdfgrup') #FUN-980030
    LET g_wc2 = cl_replace_str(g_wc2,"hrdf02","hrat01")
    LET g_wc2 = g_wc2," AND hrdf05 = '003' "
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF 
 
    CALL i074_b_fill(g_wc2)
 
END FUNCTION 
 
FUNCTION i074_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
                   "hrdf05,hrdf06,hrdf07,hrdfacti",
                   " FROM hrdf_file,hrat_file ",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid = hrdf02 ",
                   " ORDER BY hrdf01" 
 
    PREPARE i074_pb FROM g_sql
    DECLARE hrdf_curs CURSOR FOR i074_pb
 
    CALL g_hrdf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdf_curs INTO g_hrdf[g_cnt].*   
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF 

       SELECT hraa02 INTO g_hrdf[g_cnt].hraa02 FROM hraa_file
       WHERE hraa01 = g_hrdf[g_cnt].hrat03
       
       SELECT hrao02 INTO g_hrdf[g_cnt].hrao02 FROM hrao_file
       WHERE hrao01 = g_hrdf[g_cnt].hrat04 
       
       SELECT hrag07 INTO g_hrdf[g_cnt].hrdf05 FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = g_hrdf[g_cnt].hrdf05
        
       LET g_hrdf[g_cnt].sure = 'Y'
     
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrdf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
    LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION 
 
FUNCTION i074_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdf TO s_hrdf.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
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
         LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION sel_all
         LET g_action_choice="sel_all"
         EXIT DISPLAY
      
     ON ACTION cancle_sel_all
         LET g_action_choice="cancle_sel_all"
         EXIT DISPLAY   
         
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
      
      ON ACTION closg
         LET g_action_choice="closg"
         EXIT DISPLAY
      
      ON ACTION guidang
         LET g_action_choice="guidang"
         EXIT DISPLAY
              
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
   
 
FUNCTION i074_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i2      LIKE type_file.num5

  FOR l_i2 = 1 TO g_cnt2 
    LET g_hrdf[l_i2].sure = p_flag
    DISPLAY BY NAME g_hrdf[l_i2].sure
  END FOR
 
  CALL g_hrdf.deleteElement(l_i2)
  
  LET l_i2 = l_i2-1
  
  CALL ui.Interface.refresh()

END FUNCTION 
  
 
 
FUNCTION i074_unconfirm() 
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_hrdf  RECORD  LIKE hrdf_file.*
  DEFINE l_count         LIKE type_file.num5 
  CALL s_showmsg_init()
  FOR l_i = 1 TO g_rec_b
    IF g_hrdf[l_i].sure = 'Y' THEN
      IF g_hrdf[l_i].hrdf05 = '002' OR g_hrdf[l_i].hrdf05 = '待审核' THEN 
          CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"未审核，不可取消审核","",1) 
          CONTINUE FOR
       END IF 
       IF g_hrdf[l_i].hrdf06 = '1' THEN 
          CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"已关账，不可取消审核","",1) 
          CONTINUE FOR
       END IF 
        
       UPDATE hrdf_file SET hrdf05 = '002' WHERE hrdf01 = g_hrdf[l_i].hrdf01
       IF SQLCA.SQLCODE THEN
          CALL s_errmsg('update hrdf_file','',SQLCA.SQLCODE,"",1) 
       END IF 
       SELECT hrag07 INTO g_hrdf[l_i].hrdf05 FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = '002'
       DISPLAY BY NAME g_hrdf[l_i].hrdf05   
    END IF
  END FOR
  CALL s_showmsg() 
END FUNCTION
 
FUNCTION i074_closg() 
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5 
  DEFINE l_hrct03        LIKE hrct_file.hrct03
  DEFINE l_hraa02        LIKE hraa_file.hraa02
  DEFINE l_hrct11        LIKE hrct_file.hrct11
  DEFINE l_hrct07        LIKE hrct_file.hrct07
  DEFINE l_hrct08        LIKE hrct_file.hrct08

  OPEN WINDOW i074_w1  WITH FORM "ghr/42f/ghri074_1"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  CALL cl_ui_locale("ghri074_1")
  CALL cl_set_label_justify("i074_w1","right")  
  LET l_hrct03 = g_hrdf[1].hrat03
  LET l_hraa02 = g_hrdf[1].hraa02
  DISPLAY l_hrct03 TO hrct03
  DISPLAY l_hraa02 TO hrct03_name
  INPUT l_hrct03,l_hrct11,l_hrct07,l_hrct08  WITHOUT DEFAULTS FROM hrct03,hrct11,hrct07,hrct08
        AFTER FIELD hrct03
            IF NOT cl_null(l_hrct03) THEN
               LET l_count = 0
               SELECT COUNT(*) INTO l_count FROM hrct_file
                WHERE hrct03 = l_hrct03
               IF l_count = 0 THEN
                  CALL cl_err('薪资周期维护资料中没有该公司资料','!',0)
                  NEXT FIELD hrct03
               END IF
               SELECT hraa02 INTO l_hraa02 FROM hraa_file WHERE hraa01 = l_hrct03
               DISPLAY l_hraa02 TO hraa02
            END IF  
        AFTER FIELD hrct11
            IF NOT cl_null(l_hrct11) THEN
               LET l_count = 0
               SELECT COUNT(*) INTO l_count FROM hr11_file
                WHERE hrct11 = l_hrct11
               IF l_count = 0 THEN
                  CALL cl_err('薪资周期维护资料中没有该周期月','!',0)
                  NEXT FIELD hrct11
               END IF
               SELECT hrct07,hrct08 INTO l_hrct07,l_hrct08 FROM hrct_file
                WHERE hrct11 = l_hrct11
                  AND rownum = 1
               DISPLAY l_hrct07 TO hrct07
               DISPLAY l_hrct08 TO hrct08
            END IF
        AFTER FIELD hrct07
            IF NOT cl_null(l_hrct07) AND NOT cl_null(l_hrct08) THEN
               IF l_hrct07 > l_hrct08 THEN
                  CALL cl_err(l_hrct07,'mfg9234',0)
                  NEXT FIELD hrct07
               END IF
            END IF
        AFTER FIELD hrct08
            IF NOT cl_null(l_hrct07) AND NOT cl_null(l_hrct08) THEN
               IF l_hrct07 > l_hrct08 THEN
                  CALL cl_err(l_hrct08,'axm1028',0)
                  NEXT FIELD hrct08
               END IF
            END IF
        
        ON ACTION controlp
            CASE 
               WHEN INFIELD(hrct03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_hraa01" 
                   LET g_qryparam.default1 = l_hrct03
                   CALL cl_create_qry() RETURNING l_hrct03
                   DISPLAY l_hrct03 TO hrct03
                   NEXT FIELD hrct03
               WHEN INFIELD(hrct11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_hrct11" 
                   LET g_qryparam.default1 = l_hrct11
                   CALL cl_create_qry() RETURNING l_hrct11
                   DISPLAY l_hrct11 TO hrct11
                   NEXT FIELD hrct11                   
           END CASE 

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
           
        ON ACTION CONTROLG
           CALL cl_cmdask()
            
        ON ACTION CONTROLF                        
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
           
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
           
        ON ACTION about
           CALL cl_about() 
              
        ON ACTION help
           CALL cl_show_help()
   END INPUT
   IF INT_FLAG THEN                        
      LET INT_FLAG = 0 
      CALL cl_err('',9001,0)
      CLOSE WINDOW i074_w1
      RETURN 
   END IF           
   CLOSE WINDOW i074_w1
              
   CALL s_showmsg_init()

   FOR l_i = 1 TO g_rec_b
      IF g_hrdf[l_i].sure = 'Y' AND g_hrdf[l_i].hrat03 = l_hrct03 AND g_hrdf[l_i].hrdf03 >= l_hrct07 AND g_hrdf[l_i].hrdf03 <= l_hrct08 THEN
         IF g_hrdf[l_i].hrdf06 = '1' THEN 
            CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"已关账，不可再次关账","",1)
            CONTINUE FOR 
         END IF 
         IF g_hrdf[l_i].hrdf05 = '002' OR g_hrdf[l_i].hrdf05 = '待审核' THEN 
            CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"未审核，不可关账","",1) 
            CONTINUE FOR
         END IF 
           
         UPDATE hrdf_file SET hrdf06 = '1',hrdf07 = MONTH(g_today)  WHERE hrdf01 = g_hrdf[l_i].hrdf01
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('update hrdf_file','hrdf06',"",SQLCA.SQLCODE,1) 
         END IF 
         LET g_hrdf[l_i].hrdf06 = '1'
         LET g_hrdf[l_i].hrdf07 = MONTH(g_today)
         DISPLAY BY NAME g_hrdf[l_i].hrdf06,g_hrdf[l_i].hrdf07
      END IF
   END FOR
   CALL s_showmsg()  
END FUNCTION  
 
FUNCTION i074_guidang() 
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5 

   CALL s_showmsg_init() 
   FOR l_i = 1 TO g_rec_b
       IF g_hrdf[l_i].sure = 'Y' THEN
          IF g_hrdf[l_i].hrdf05 = '002' OR g_hrdf[l_i].hrdf05 = '待审核' THEN 
             CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"未审核，不可归档","",1) 
             CONTINUE FOR
          END IF 
          IF g_hrdf[l_i].hrdf06 = '0' THEN 
             CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"未关账，不可归档","",1) 
             CONTINUE FOR
          END IF 
        
          UPDATE hrdf_file SET hrdf05 = '004' WHERE hrdf01 = g_hrdf[l_i].hrdf01
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('update hrdf_file','',"",SQLCA.SQLCODE,1) 
          END IF 
          SELECT hrag07 INTO g_hrdf[l_i].hrdf05 FROM hrag_file 
           WHERE hrag01 = '103' AND hrag06 = '004'
          DISPLAY BY NAME g_hrdf[l_i].hrdf05   
       END IF
   END FOR
   CALL s_showmsg() 
END FUNCTION 
