# Prog. Version..: '5.30.06-13.04.22(00007)'     #
 
# Pattern name...: aglt603.4gl
# Descriptions...: 異動碼預算維護作業
# Date & Author..: No.FUN-850027 08/06/02 By douzh
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-8C0092 08/12/17 By alex 調整SELECT指令
# Modify.........: No.FUN-930106 09/03/17 By destiny aff02預算項目字段增加管控
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.TQC-960409 09/06/29 By destiny 修改計算筆試方法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_aff    RECORD LIKE aff_file.*,
        g_aff_t  RECORD LIKE aff_file.*,
        g_aff_o  RECORD LIKE aff_file.*,
        g_afg   DYNAMIC ARRAY OF RECORD 
                afg07   LIKE afg_file.afg07,
                afg08   LIKE afg_file.afg08 
                        END RECORD,
        g_afg_t RECORD
                afg07   LIKE afg_file.afg07,
                afg08   LIKE afg_file.afg08 
                        END RECORD,
        g_afg_o RECORD
                afg07   LIKE afg_file.afg07,
                afg08   LIKE afg_file.afg08 
                        END RECORD
DEFINE  g_sql           STRING
DEFINE  g_wc            STRING
DEFINE  g_wc2           STRING
DEFINE  g_rec_b         LIKE type_file.num5
DEFINE  l_ac            LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_i             LIKE type_file.num5
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  g_no_ask        LIKE type_file.num5
DEFINE  g_str           STRING
DEFINE  g_aaa03         LIKE aaa_file.aaa03
DEFINE  g_temp          STRING                #No.TQC-960409
 
MAIN
   OPTIONS                            
      INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   
 
   #FUN-8C0092
   LET g_forupd_sql="SELECT * FROM aff_file WHERE aff00 = ? AND aff01 = ? AND aff02 = ? AND aff03 = ? ",
                    "AND aff04 = ? AND aff05 = ? AND aff06 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t603_cl CURSOR FROM g_forupd_sql
    
   OPEN WINDOW t603_w WITH FORM "agl/42f/aglt603"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   CALL t603_menu()
   CLOSE WINDOW t603_w                   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
             
END MAIN
 
FUNCTION t603_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_afg TO s_afg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL t603_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         CALL t603_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t603_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         CALL t603_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION last
         CALL t603_fetch('L')
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
      ON ACTION related_document
         LET g_action_choice = 'related_document'
         EXIT DISPLAY
 
      ON ACTION controls                                                        
         CALL cl_set_head_visible("","AUTO")
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t603_menu()
 
   WHILE TRUE
      CALL t603_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t603_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t603_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t603_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t603_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t603_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t603_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t603_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t603_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_afg),'','')
             END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF NOT cl_null(g_aff.aff00) THEN
                    LET g_doc.column1 = "aff00"
                    LET g_doc.value1 = g_aff.aff00
                    CALL cl_doc()
                 END IF
              END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t603_cs()
    CLEAR FORM
    CALL g_afg.clear()
    CALL cl_set_head_visible("","YES")
    INITIALIZE g_aff.* TO NULL
    
    CONSTRUCT BY NAME g_wc ON                               
        aff00,aff01,aff02,aff03,aff04,aff05,aff06,aff07,
        aff08,aff09,aff10,aff11,aff12,aff13,
        affuser,affgrup,affmodu,affdate,affacti
             
        BEFORE CONSTRUCT
                CALL cl_qbe_init()
             
        ON ACTION controlp
           CASE
               WHEN INFIELD(aff02)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"             #No.FUN-930106
                 LET g_qryparam.form = "q_azf01a"          #No.FUN-930106
                 LET g_qryparam.state = "c"
                #LET g_qryparam.arg1 = '2'                 #No.FUN-930106
                #LET g_qryparam.arg1 = '9'                 #No.FUN-930106
                 LET g_qryparam.arg1 = '7'                 #No.FUN-950077
                 LET g_qryparam.default1 = g_aff.aff02 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aff02
                 NEXT FIELD aff02
               WHEN INFIELD(aff03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_aff.aff03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aff03
                 NEXT FIELD aff03
               WHEN INFIELD(aff04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_aff.aff04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aff04
                 NEXT FIELD aff04
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
    #        LET g_wc = g_wc CLIPPED," AND affuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
        LET g_wc = g_wc CLIPPED," AND affgrup LIKE '",
                   g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND affgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('affuser', 'affgrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2 ON afg07,afg08 
                    FROM s_afg[1].afg07,s_afg[1].afg08
                                                
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
    LET g_wc2=g_wc2 CLIPPED
    IF  g_wc2=" 1=1" THEN       
         LET g_sql="SELECT aff00,aff01,aff02,aff03,aff04,aff05,aff06 FROM aff_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY aff00,aff01,aff02,aff03,aff04,aff05,aff06"
    ELSE                                 
    LET g_sql=
        "SELECT DISTINCT aff_file.aff00,aff01,aff02,aff03,aff04,aff05,aff06",
        " FROM aff_file,afg_file",
        " WHERE aff00 = afg00 AND aff01 = afg01",
        "   AND aff02 = afg02 AND aff03 = afg03",
        "   AND aff04 = afg04 AND aff05 = afg05",
        "   AND aff06 = afg06",
        " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
        " ORDER BY aff00,aff01,aff02,aff03,aff04,aff05,aff06"
    END IF
    PREPARE t603_prepare FROM g_sql
    DECLARE t603_cs SCROLL CURSOR WITH HOLD FOR t603_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM aff_file WHERE ",g_wc CLIPPED
    ELSE
#No.TQC-960409--begin
#        LET g_sql="SELECT COUNT(DISTINCT aff01) FROM aff_file,afg_file WHERE",
#                " aff00 = afg00 AND aff01 = afg01",
#                "   AND aff02 = afg02 AND aff03 = afg03",
#                "   AND aff04 = afg04 AND aff05 = afg05",
#                "   AND aff06 = afg06 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
        LET g_temp="SELECT DISTINCT aff00,aff01,aff02,aff03,aff04,aff05,aff06 ",
                   " FROM aff_file,afg_file WHERE ",
                   " aff00 = afg00 AND aff01 = afg01",
                   "   AND aff02 = afg02 AND aff03 = afg03",
                   "   AND aff04 = afg04 AND aff05 = afg05",
                   "   AND aff06 = afg06 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " INTO TEMP x "  
        DROP TABLE x                                                                                                                     
        PREPARE t630_pre_x FROM g_temp                                                                                                   
        EXECUTE t630_pre_x                                                                                                               
        LET g_sql  = " SELECT COUNT(*) FROM x "
#No.TQC-960409--end 
    END IF 
    PREPARE t603_precount FROM g_sql
    DECLARE t603_count CURSOR FOR t603_precount
END FUNCTION
 
FUNCTION t603_q()
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_afg.clear()      
    MESSAGE ""
    
    DISPLAY '' TO FORMONLY.cnt
    CALL t603_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_aff.* TO NULL
        CALL g_afg.clear()
        RETURN
    END IF
    OPEN t603_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aff.* TO NULL
        CALL g_afg.clear()
    ELSE
        OPEN t603_count
        FETCH t603_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
                                  
        CALL t603_fetch('F')              
    END IF
END FUNCTION
 
FUNCTION t603_fetch(p_flaff)
    DEFINE
        p_flaff         LIKE type_file.chr1           
    CASE p_flaff
        WHEN 'N' FETCH NEXT     t603_cs INTO g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06
        WHEN 'P' FETCH PREVIOUS t603_cs INTO g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06
        WHEN 'F' FETCH FIRST    t603_cs INTO g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06
        WHEN 'L' FETCH LAST     t603_cs INTO g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06
        WHEN '/'
            IF (NOT g_no_ask) THEN                   
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
            FETCH ABSOLUTE g_jump t603_cs INTO g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aff.aff01,SQLCA.sqlcode,0)
        INITIALIZE g_aff.* TO NULL  
        RETURN
    ELSE
      CASE p_flaff
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_aff.* FROM aff_file    
       WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01 AND aff02 = g_aff.aff02 
  AND aff03 = g_aff.aff03 AND aff04 = g_aff.aff04 AND aff05 = g_aff.aff05 AND aff06 = g_aff.aff06
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","aff_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_aff.affuser           
        LET g_data_group=g_aff.affgrup
        CALL t603_show()                   
    END IF
END FUNCTION
 
FUNCTION t603_aff02(p_cmd)         
DEFINE    l_azfacti  LIKE azf_file.azfacti
DEFINE    l_azf03    LIKE azf_file.azf03  
DEFINE    l_azf07    LIKE azf_file.azf07
DEFINE    p_cmd      LIKE type_file.chr1           
DEFINE    l_azf09    LIKE azf_file.azf09        #No.FUN-930106          
   LET g_errno = ' '
  #SELECT azf03,azfacti INTO l_azf03,l_azfacti  FROM azf_file                    #No.FUN-930106
   SELECT azf03,azfacti,azf09 INTO l_azf03,l_azfacti,l_azf09  FROM azf_file      #No.FUN-930106   
         WHERE azf01 = g_aff.aff02 AND azf02 = '2'
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-005' 
                                 LET l_azf03=NULL 
        WHEN l_azfacti='N'       LET g_errno='9028'     
       #WHEN l_azf09 !='9'       LET g_errno='aoo-408'                           #No.FUN-930106
        WHEN l_azf09 !='7'       LET g_errno='aoo-406'                           #No.FUN-950077
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
  END IF
 
END FUNCTION
 
FUNCTION t603_aff03(p_cmd)         
DEFINE    l_aagacti  LIKE aag_file.aagacti, 
          l_aag02    LIKE aag_file.aag02,    
          l_aag07    LIKE aag_file.aag07,    
          p_cmd      LIKE type_file.chr1            
          
   LET g_errno = ' '
   SELECT aag02,aag07,aagacti INTO l_aag02,l_aag07,l_aagacti  FROM aag_file     
    WHERE aag00 = g_aff.aff00 
      AND aag01 = g_aff.aff03
      AND aag03 = '2'
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' 
                                 LET l_aag02=NULL 
                                 LET l_aag07=NULL 
        WHEN l_aag07='1'         LET g_errno='agl-015'     
        WHEN l_aagacti='N'       LET g_errno='9028'     
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02
  END IF
 
END FUNCTION
 
FUNCTION t603_aff04(p_cmd)         
DEFINE    l_gemacti  LIKE gem_file.gemacti, 
          l_gem02    LIKE gem_file.gem02,    
          p_cmd      LIKE type_file.chr1            
          
   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti  FROM gem_file     
         WHERE gem01 = g_aff.aff04
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-003' 
                                 LET l_gem02=NULL 
        WHEN l_gemacti='N'       LET g_errno='9028'     
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION t603_period(p_cmd1,p_cmd2,p_cmd3)
   DEFINE l_flag   LIKE type_file.chr1
   DEFINE l_aff07  LIKE aff_file.aff07
   DEFINE l_amt    LIKE afg_file.afg08
   DEFINE l_tmp    LIKE aff_file.aff10
   DEFINE l_n,l_i,i             LIKE type_file.num5
   DEFINE p_cmd1,p_cmd2,p_cmd3  LIKE type_file.chr1
   DEFINE l_fac1,l_fac2,l_fac3,l_tot LIKE type_file.num5
   DEFINE l_arr ARRAY[13] OF DECIMAL(20,6) 
   DEFINE l_remaind  LIKE aff_file.aff10 
   DEFINE l_sum      LIKE aff_file.aff10  
 
   SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=g_aff.aff01
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aff.aff00
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03 
 
   LET l_sum = 0 
   IF g_azm.azm02 = '1' THEN
      LET l_tot = 3
      LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
   ELSE
      LET l_tot = 4
      LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
   END IF
   CASE p_cmd2 
     WHEN '0' 
        LET l_i = 1
        LET g_aff.aff10 = g_aff.aff09/4
        LET g_aff.aff11 = g_aff.aff09/4
        LET g_aff.aff12 = g_aff.aff09/4
        LET g_aff.aff13 = g_aff.aff09/4
        LET l_arr[1] = g_aff.aff10*l_fac1/l_tot                                                                                     
        LET l_arr[2] = g_aff.aff10*l_fac2/l_tot                                                                                     
        LET l_arr[3] = g_aff.aff10*l_fac3/l_tot
        LET l_arr[4] = g_aff.aff11*l_fac1/l_tot                                                                                     
        LET l_arr[5] = g_aff.aff11*l_fac2/l_tot                                                                                     
        LET l_arr[6] = g_aff.aff11*l_fac3/l_tot
        LET l_arr[7] = g_aff.aff12*l_fac1/l_tot                                                                                     
        LET l_arr[8] = g_aff.aff12*l_fac2/l_tot                                                                                     
        LET l_arr[9] = g_aff.aff12*l_fac3/l_tot
        IF g_azm.azm02='1' THEN                                                                                                     
           LET l_n=12                                                                                                               
           LET l_arr[10] = g_aff.aff13*l_fac1/l_tot                                                                                 
           LET l_arr[11] = g_aff.aff13*l_fac2/l_tot       
           LET l_arr[12] = g_aff.aff13*l_fac3/l_tot                                                                                 
        ELSE                                                                                                                        
           LET l_n=13                                                                                                               
           LET l_arr[10] = g_aff.aff13*l_fac1/l_tot                                                                                 
           LET l_arr[11] = g_aff.aff13*l_fac2/l_tot                                                                                 
           LET l_arr[12] = g_aff.aff13*l_fac3/l_tot     
           LET l_arr[13] = g_aff.aff13-(l_arr[10]+l_arr[11]+l_arr[12])                                                              
        END IF
     WHEN '1'
        LET l_i=1
        LET l_n=3
        LET l_arr[1] = g_aff.aff10*l_fac1/l_tot 
        LET l_arr[2] = g_aff.aff10*l_fac2/l_tot
        LET l_arr[3] = g_aff.aff10*l_fac3/l_tot 
     WHEN '2'
        LET l_i=4
        LET l_n=6
        LET l_arr[4] = g_aff.aff11*l_fac1/l_tot                                                                                     
        LET l_arr[5] = g_aff.aff11*l_fac2/l_tot           
        LET l_arr[6] = g_aff.aff11*l_fac3/l_tot
     WHEN '3'
        LET l_i=7
        LET l_n=9
        LET l_arr[7] = g_aff.aff12*l_fac1/l_tot                                                                                     
        LET l_arr[8] = g_aff.aff12*l_fac2/l_tot          
        LET l_arr[9] = g_aff.aff12*l_fac3/l_tot
     WHEN '4'
        LET l_i=10
        IF g_azm.azm02='1' THEN
           LET l_n=12
           LET l_arr[10] = g_aff.aff13*l_fac1/l_tot                                                                                     
           LET l_arr[11] = g_aff.aff13*l_fac2/l_tot                 
           LET l_arr[12] = g_aff.aff13*l_fac3/l_tot
        ELSE 
           LET l_n=13
           LET l_arr[10] = g_aff.aff13*l_fac1/l_tot                                                                                 
           LET l_arr[11] = g_aff.aff13*l_fac2/l_tot                                                                                 
           LET l_arr[12] = g_aff.aff13*l_fac3/l_tot
           LET l_arr[13] = g_aff.aff13-(l_arr[10]+l_arr[11]+l_arr[12])
        END IF
     END CASE
   IF p_cmd2 NOT MATCHES '0' THEN
      LET g_aff.aff09=g_aff.aff10 + g_aff.aff11 + g_aff.aff12 + g_aff.aff13
   END IF
   LET g_aff.aff09 = cl_numfor(g_aff.aff09,20,t_azi04)
   LET g_aff.aff10 = cl_numfor(g_aff.aff10,20,t_azi04)
   LET g_aff.aff11 = cl_numfor(g_aff.aff11,20,t_azi04)
   LET g_aff.aff12 = cl_numfor(g_aff.aff12,20,t_azi04)
   LET g_aff.aff13 = cl_numfor(g_aff.aff13,20,t_azi04)
#-start- 處理尾數問題
   LET l_remaind = g_aff.aff09 - (g_aff.aff10 + g_aff.aff11 + g_aff.aff12 + g_aff.aff13)  
   LET g_aff.aff13 = g_aff.aff13 + l_remaind
    FOR i=l_i TO l_n
       LET l_arr[i] = cl_numfor(l_arr[i],20,t_azi04)
       LET l_sum = l_sum + l_arr[i]
       CASE l_n 
         WHEN '3'
           LET l_arr[3] = l_arr[3] + g_aff.aff10 - l_sum
         WHEN '6'
           LET l_arr[6] = l_arr[6] + g_aff.aff11 - l_sum
         WHEN '9'
           LET l_arr[9] = l_arr[9] + g_aff.aff12 - l_sum
         WHEN '12' 
           IF p_cmd2 NOT MATCHES '0' THEN
              LET l_arr[12] = l_arr[12] + g_aff.aff13 - l_sum
           ELSE
              LET l_arr[12] = l_arr[12] + g_aff.aff09 - l_sum
           END IF   
         WHEN '13'
           IF p_cmd2 NOT MATCHES '0' THEN                                                                                           
              LET l_arr[13] = l_arr[13] + g_aff.aff13 - l_sum                                                                       
           ELSE                                                                                                                     
              LET l_arr[13] = l_arr[13] + g_aff.aff09 - l_sum                                                                       
           END IF
       END CASE
    END FOR
 
   DISPLAY BY NAME g_aff.aff09,g_aff.aff10,g_aff.aff11,g_aff.aff12,g_aff.aff13
   BEGIN WORK   
    IF p_cmd1 = 'a' AND p_cmd3='0' THEN
       DECLARE ic CURSOR FOR 
        INSERT INTO afg_file (afg00,afg01,afg02,afg03,afg04,afg05,afg06,afg07,afg08)
          VALUES(g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06,i,l_tmp) 
       OPEN ic
         FOR i=l_i TO l_n
           LET l_tmp = l_arr[i] 
           PUT ic
         END FOR
      FLUSH ic
      COMMIT WORK
      CLOSE ic
      FREE ic
      LET g_aff_t.aff09 = g_aff.aff09
      LET g_aff_t.aff10 = g_aff.aff10
      LET g_aff_t.aff11 = g_aff.aff11
      LET g_aff_t.aff12 = g_aff.aff12
      LET g_aff_t.aff13 = g_aff.aff13
    ELSE
      PREPARE iu FROM "UPDATE afg_file SET afg08 = ? WHERE afg00 = ? AND afg01 = ? AND afg02 = ?
                       AND afg03 = ? AND afg04 = ? AND afg05 = ? AND afg06 = ? AND afg07 = ?"
      FOR i=l_i TO l_n
        LET l_tmp = l_arr[i]
        EXECUTE iu USING l_tmp,g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06,i
        IF SQLCA.sqlcode THEN                                                                                                         
           CALL cl_err3("upd","afg_file",i,l_tmp,SQLCA.sqlcode,'','',1)
           ROLLBACK WORK
        END IF 
      END FOR
      COMMIT WORK
      FREE iu
      LET g_aff_t.aff09 = g_aff.aff09
      LET g_aff_t.aff10 = g_aff.aff10
      LET g_aff_t.aff11 = g_aff.aff11
      LET g_aff_t.aff12 = g_aff.aff12
      LET g_aff_t.aff13 = g_aff.aff13
    END IF
 
END FUNCTION
 
FUNCTION t603_show()
    LET g_aff_t.* = g_aff.*
    LET g_aff_o.*=g_aff.*
    DISPLAY BY NAME g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03, g_aff.afforiu,g_aff.afforig,
                    g_aff.aff04,g_aff.aff05,
                    g_aff.aff06,g_aff.aff07,g_aff.aff08,g_aff.aff09,
                    g_aff.aff10,g_aff.aff11,g_aff.aff12,g_aff.aff13,
                    g_aff.affuser,g_aff.affgrup,
                    g_aff.affmodu,g_aff.affdate,g_aff.affacti
    CALL t603_aff02('d')
    CALL t603_aff03('d')
    CALL t603_aff04('d')
    CALL t603_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t603_b_fill(p_wc2)              
DEFINE  p_wc2   STRING 
 
    LET g_sql =
        "SELECT afg07,afg08 FROM afg_file ",
        " WHERE afg00 = '",g_aff.aff00,"'"," AND afg01 = '",g_aff.aff01,"'",
        "   AND afg02 = '",g_aff.aff02,"'"," AND afg03 = '",g_aff.aff03,"'",
        "   AND afg04 = '",g_aff.aff04,"'"," AND afg05 = '",g_aff.aff05,"'",
        "   AND afg06 = '",g_aff.aff06,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t603_pb FROM g_sql
    DECLARE afg_cs CURSOR FOR t603_pb
 
    CALL g_afg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH afg_cs INTO g_afg[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_afg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t603_a()
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10              
   DEFINE l_n         LIKE type_file.num5   
 
   MESSAGE ""
   CLEAR FORM
   CALL g_afg.clear()
   LET g_wc = '' 
   LET g_wc2= ''
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_aff.* TO NULL                  
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_aff.affuser = g_user
      LET g_aff.afforiu = g_user #FUN-980030
      LET g_aff.afforig = g_grup #FUN-980030
      LET g_aff.affgrup = g_grup
      LET g_aff.affdate = g_today
      LET g_aff.affacti = 'Y'               
      LET g_aff.aff00 = g_aza.aza81     
      LET g_aff.aff01 = YEAR(g_today)
      LET g_aff.aff07 = '3'  
      LET g_aff.aff08 = '2' 
 
      CALL t603_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_aff.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_aff.aff00) OR  
         cl_null(g_aff.aff02) OR cl_null(g_aff.aff03) OR
         cl_null(g_aff.aff01) THEN       
         CONTINUE WHILE
      END IF
      BEGIN WORK
      INSERT INTO aff_file VALUES(g_aff.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","aff_file",g_aff.aff01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
         CALL cl_flow_notify(g_aff.aff01,'I')
      END IF
      
      SELECT aff00,aff01,aff02,aff03,aff04,aff05,aff06 INTO g_aff.aff00,g_aff.aff01,
    g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,g_aff.aff06 FROM aff_file
           WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01
             AND aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
             AND aff04 = g_aff.aff04 AND aff05 = g_aff.aff05
             AND aff06 = g_aff.aff06 
      LET g_aff_t.* = g_aff.*
      LET g_aff_o.* = g_aff.*
      CALL g_afg.clear()
      
      CALL t603_b_fill("1=1")  
      CALL t603_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t603_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
   DEFINE   l_n       LIKE type_file.num10
   DEFINE   l_aff01   STRING
   DEFINE   l_pjb01   LIKE pjb_file.pjb01
   DEFINE   l_pjb09   LIKE pjb_file.pjb09   #No.FUN-850027 
   DEFINE   l_pjb11   LIKE pjb_file.pjb11   #No.FUN-850027
 
   DISPLAY BY NAME
      g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,
      g_aff.aff06,g_aff.aff07,g_aff.aff08,g_aff.aff09,g_aff.aff10,g_aff.aff11,  
      g_aff.aff12,g_aff.aff13,
      g_aff.affuser,g_aff.affgrup,g_aff.affmodu,
      g_aff.affdate,g_aff.affacti
 
   LET g_aff_t.* = g_aff.* 
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_aff.afforiu,g_aff.afforig,
      g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,
      g_aff.aff06,g_aff.aff07,g_aff.aff08,g_aff.aff09,g_aff.aff10,g_aff.aff11, 
      g_aff.aff12,g_aff.aff13
      WITHOUT DEFAULTS
 
      BEFORE INPUT     
          LET g_before_input_done = FALSE
          CALL t603_set_entry(p_cmd)
          CALL t603_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
      
      AFTER FIELD aff00
         IF NOT cl_null(g_aff.aff00) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_aff.aff00 != g_aff_t.aff00) THEN              
               SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01 = g_aff.aff00 AND aaaacti = 'Y'
               IF l_n<1 THEN
                  CALL cl_err('aff00:','agl-095',0)
                  LET g_aff.aff00 = g_aff_t.aff00
                  DISPLAY BY NAME g_aff.aff00
                  NEXT FIELD aff00
               END IF
            END IF
         END IF
        
      AFTER FIELD aff01
         IF NOT cl_null(g_aff.aff01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_aff.aff01 != g_aff_t.aff01) THEN              
               LET l_aff01 = g_aff.aff01
               IF LENGTH(l_aff01)<>4 THEN
                  NEXT FIELD aff01
               END IF
            END IF
         END IF   
 
      AFTER FIELD aff02
         IF NOT cl_null(g_aff.aff02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_aff.aff02 != g_aff_t.aff02) THEN              
               CALL t603_aff02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('aff02:',g_errno,0)
                  LET g_aff.aff02 = g_aff_t.aff02
                  DISPLAY BY NAME g_aff.aff02
                  NEXT FIELD aff02
               END IF
            END IF
         END IF
 
      AFTER FIELD aff03
         IF NOT cl_null(g_aff.aff03) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_aff.aff03 != g_aff_t.aff03) THEN              
               CALL t603_aff03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('aff03:',g_errno,0)
                 #Mod No.FUN-B10048
                 #LET g_aff.aff03 = g_aff_t.aff03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03='2' AND aagacti='Y' AND aag01 LIKE '",g_aff.aff03 CLIPPED,"%'"
                  LET g_qryparam.arg1 = g_aff.aff00
                  LET g_qryparam.default1 = g_aff.aff03
                  CALL cl_create_qry() RETURNING g_aff.aff03
                 #End Mod No.FUN-B10048
                  DISPLAY BY NAME g_aff.aff03
                  NEXT FIELD aff03
               END IF
            END IF
         END IF
         
      AFTER FIELD aff04
         IF NOT cl_null(g_aff.aff04) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_aff.aff04 != g_aff_t.aff04) THEN              
               CALL t603_aff04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('aff04:',g_errno,0)
                  LET g_aff.aff04 = g_aff_t.aff04
                  DISPLAY BY NAME g_aff.aff04
                  NEXT FIELD aff04
               END IF
            END IF
         ELSE
            LET g_aff.aff04 = ' '
         END IF
              
      AFTER FIELD aff05
         IF NOT cl_null(g_aff.aff05) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_aff.aff05 != g_aff_t.aff05) THEN              
               IF g_aff.aff05 < 1 OR g_aff.aff05 > g_aaz.aaz88 THEN
                  CALL cl_err('aff05:','',0)
                  LET g_aff.aff05 = g_aff_t.aff05
                  DISPLAY BY NAME g_aff.aff05
                  NEXT FIELD aff05
               END IF
            END IF
         END IF
 
      AFTER FIELD aff07,aff08
         IF NOT cl_null(g_aff.aff07) OR NOT cl_null(g_aff.aff08) THEN
            CASE 
              WHEN INFIELD(aff07)
                    IF g_aff.aff07 NOT MATCHES '[123]' THEN
                     NEXT FIELD aff07
                    END IF
              WHEN INFIELD(aff08)
                    IF g_aff.aff08 NOT MATCHES '[12]' THEN
                     NEXT FIELD aff08
                    END IF
               OTHERWISE EXIT CASE
             END CASE
         END IF
 
      ON CHANGE aff07
         CALL t603_set_entry(p_cmd)
 
      AFTER FIELD aff09,aff10,aff11,aff12,aff13
          IF p_cmd='a' OR (p_cmd='u' AND (g_aff.aff09<>g_aff_t.aff09 OR 
             g_aff.aff10<>g_aff_t.aff10 OR g_aff.aff11<>g_aff_t.aff11 OR
             g_aff.aff12<>g_aff_t.aff12 OR g_aff.aff13<>g_aff_t.aff13 ))THEN
 
             CASE
               WHEN INFIELD(aff09)
                 IF g_aff.aff09 <=0 THEN
                    CALL cl_err('','axr-029',0)
                    NEXT FIELD aff09
                 ELSE
                    IF g_aff.aff09<>g_aff_t.aff09 AND g_aff_t.aff09!=0 THEN
                       CALL t603_period(p_cmd,'0','1')
                    ELSE
                       CALL t603_period(p_cmd,'0','0')
                    END IF
                 END IF
               WHEN INFIELD(aff10)         
                 IF g_aff.aff10 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD aff10                            
                 ELSE 
                    IF g_aff.aff10<>g_aff_t.aff10 AND g_aff_t.aff10!=0 THEN
                       CALL t603_period(p_cmd,'1','1')
                    ELSE
                       CALL t603_period(p_cmd,'1','0')
                    END IF
                 END IF
               WHEN INFIELD(aff11)         
                 IF g_aff.aff11 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD aff11                            
                 ELSE                                                                                          
                    IF g_aff.aff11<>g_aff_t.aff11 AND g_aff_t.aff11!=0 THEN
                       CALL t603_period(p_cmd,'2','1')
                    ELSE
                       CALL t603_period(p_cmd,'2','0')
                    END IF
                 END IF
               WHEN INFIELD(aff12)      
                 IF g_aff.aff12 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD aff12 
                 ELSE 
                    IF g_aff.aff12<>g_aff_t.aff12 AND g_aff_t.aff12!=0 THEN
                       CALL t603_period(p_cmd,'3','1')
                    ELSE
                       CALL t603_period(p_cmd,'3','0')
                    END IF
                 END IF
               WHEN INFIELD(aff13)     
                 IF g_aff.aff13 <=0 THEN                                        
                    CALL cl_err('','axr-029',0)     
                    NEXT FIELD aff13                             
                 ELSE 
                    IF g_aff.aff13<>g_aff_t.aff13 AND g_aff_t.aff13!=0 THEN
                       CALL t603_period(p_cmd,'4','1')
                    ELSE
                       CALL t603_period(p_cmd,'4','0')
                    END IF
                 END IF
               OTHERWISE EXIT CASE
             END CASE
         END IF   
 
     AFTER INPUT
        LET g_aff.affuser = s_get_data_owner("aff_file") #FUN-C10039
        LET g_aff.affgrup = s_get_data_group("aff_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         CASE 
             WHEN cl_null(g_aff.aff00) 
                  NEXT FIELD aff00
                  EXIT CASE
             WHEN cl_null(g_aff.aff01)                 
                  NEXT FIELD aff01
                  EXIT CASE
             WHEN cl_null(g_aff.aff02) 
                  NEXT FIELD aff02
                  EXIT CASE
             WHEN cl_null(g_aff.aff03) 
                  NEXT FIELD aff03
                  EXIT CASE
             OTHERWISE EXIT CASE
         END CASE
         IF p_cmd='a' THEN
            SELECT COUNT(*) INTO l_n FROM aff_file
             WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01
              AND  aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
              AND  aff04 = g_aff.aff04 AND aff05 = g_aff.aff05
              AND  aff06 = g_aff.aff06
            IF l_n > 0 THEN                  
               CALL cl_err('',-239,1)
               LET g_aff.* = g_aff_t.*
               DISPLAY BY NAME g_aff.*
               #No.FUN-9A0024--begin   
               #DISPLAY BY NAME g_aff.*  
               DISPLAY BY NAME g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,g_aff.aff05,
                               g_aff.aff06,g_aff.aff07,g_aff.aff08,g_aff.aff09,g_aff.aff10,g_aff.aff11, 
                               g_aff.aff12,g_aff.aff13,g_aff.affuser,g_aff.affgrup,g_aff.affmodu,
                               g_aff.affdate,g_aff.affacti,g_aff.afforiu,g_aff.afforig
               #No.FUN-9A0024--end 
               NEXT FIELD aff00
            END IF   
         END IF        
         IF g_aff.aff07 <> g_aff_t.aff07 OR 
            (p_cmd = 'u' AND g_aff.aff08<> g_aff_t.aff08) THEN
           IF g_aff.aff07 = '2' THEN
                      CALL t603_period(p_cmd,'1','1')
                      CALL t603_period(p_cmd,'2','1')
                      CALL t603_period(p_cmd,'3','1')
                      CALL t603_period(p_cmd,'4','1')
           END IF
           IF g_aff.aff07 = '3' THEN
            CALL t603_period(p_cmd,'0','1')
           END IF
         END IF
            
      ON ACTION CONTROLO                        
         IF INFIELD(aff01) THEN
            LET g_aff.* = g_aff_t.*
            CALL t603_show()
            NEXT FIELD aff01
         END IF
 
     ON ACTION controlp
        CASE
               WHEN INFIELD(aff02)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"              #No.FUN-930106
                 LET g_qryparam.form = "q_azf01a"           #No.FUN-930106
                #LET g_qryparam.arg1 = '2'                  #No.FUN-930106
                #LET g_qryparam.arg1 = '9'                  #No.FUN-930106   
                 LET g_qryparam.arg1 = '7'                  #No.FUN-950077   
                 LET g_qryparam.default1 = g_aff.aff02
                 CALL cl_create_qry() RETURNING g_aff.aff02
                 DISPLAY g_aff.aff02 TO aff02
                 CALL t603_aff02('a')
                 NEXT FIELD aff02
               WHEN INFIELD(aff03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where =" aag03='2' AND aag07 IN ('2','3') "
                 LET g_qryparam.arg1 = g_aff.aff00
                 LET g_qryparam.default1 = g_aff.aff03
                 CALL cl_create_qry() RETURNING g_aff.aff03
                 DISPLAY g_aff.aff03 TO aff03
                 CALL t603_aff03('a')
                 NEXT FIELD aff03
               WHEN INFIELD(aff04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_aff.aff04
                 CALL cl_create_qry() RETURNING g_aff.aff04
                 DISPLAY g_aff.aff04 TO aff04
                 CALL t603_aff04('a')
                 NEXT FIELD aff04
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
 
FUNCTION t603_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("aff00,aff01,aff02,aff03,aff04,aff05,aff06",TRUE)
     END IF
     IF p_cmd MATCHES '[au]' THEN
       CASE g_aff.aff07                                                                                                           
           WHEN '1'                                                                                                                 
               CALL cl_set_comp_entry("aff10,aff11,aff12,aff13",FALSE)                                                              
               CALL cl_set_comp_entry("aff09",FALSE)                                                                                
           WHEN '2'                                                                                                                 
               CALL cl_set_comp_entry("aff09",FALSE)                                                                                
               CALL cl_set_comp_entry("aff10,aff11,aff12,aff13",TRUE)
               IF p_cmd = 'a' THEN
                LET g_aff.aff10 = 0
                LET g_aff.aff11 = 0
                LET g_aff.aff12 = 0
                LET g_aff.aff13 = 0
               ELSE
                LET g_aff.aff10 = g_aff_t.aff10
                LET g_aff.aff11 = g_aff_t.aff11
                LET g_aff.aff12 = g_aff_t.aff12
                LET g_aff.aff13 = g_aff_t.aff13
               END IF                          
               DISPLAY BY NAME g_aff.aff10,g_aff.aff11,g_aff.aff12,g_aff.aff13
           WHEN '3'                                                                                                                 
               CALL cl_set_comp_entry("aff10,aff11,aff12,aff13",FALSE)                                                              
               CALL cl_set_comp_entry("aff09",TRUE) 
               IF p_cmd = 'a' THEN
                LET g_aff.aff09 = 0
               ELSE
                LET g_aff.aff09 = g_aff_t.aff09
               END IF              
               DISPLAY BY NAME g_aff.aff09
           OTHERWISE EXIT CASE                                                                                                      
       END CASE
    END IF
    IF p_cmd = 'c' THEN
       CALL cl_set_comp_entry("aff00,aff01,aff02,aff03,aff04,aff05,aff06",TRUE)
    END IF
END FUNCTION
 
FUNCTION t603_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("aff00,aff01,aff02,aff03,aff04,aff05,aff06",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t603_b()
        DEFINE l_ac_t          LIKE type_file.num5,
               l_n             LIKE type_file.num5,               
               l_lock_sw       LIKE type_file.chr1,
               p_cmd           LIKE type_file.chr1,
               l_allow_insert  LIKE type_file.num5,
               l_allow_delete  LIKE type_file.num5
        DEFINE l_flag   LIKE type_file.chr1
        DEFINE l_aff07  LIKE aff_file.aff07
        DEFINE l_amt    LIKE afg_file.afg08
                
        LET g_action_choice=''
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_aff.aff00) OR 
           cl_null(g_aff.aff01) OR cl_null(g_aff.aff02) OR
           cl_null(g_aff.aff03) THEN
                RETURN 
        END IF
        
        SELECT * INTO g_aff.* FROM aff_file WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01 AND aff02 = g_aff.aff02 
  AND aff03 = g_aff.aff03 AND aff04 = g_aff.aff04 AND aff05 = g_aff.aff05 AND aff06 = g_aff.aff06
        
        IF g_aff.affacti='N' THEN 
                CALL cl_err(g_aff.aff00,'mfg1000',0)
                RETURN 
        END IF
        
        IF g_aff.aff07 MATCHES '[23]' THEN 
           RETURN
        END IF        
        CALL cl_opmsg('b')
        SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=g_aff.aff01
        LET g_forupd_sql="SELECT afg07,afg08",
                        " FROM afg_file",
                        "  WHERE afg00 = ? AND afg01 = ? AND afg02 = ?",
                        " AND afg03 = ? AND afg04 = ? AND afg05 = ? ",
                        " AND afg06 = ? AND afg07 = ? ",  #No.CHI-950007
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t603_bcl CURSOR FROM g_forupd_sql
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        INPUT ARRAY g_afg WITHOUT DEFAULTS FROM s_afg.*
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
                OPEN t603_cl USING g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,
       g_aff.aff04,g_aff.aff05,g_aff.aff06
                IF STATUS THEN
                        CALL cl_err("OPEN t603_cl:",STATUS,1)
                        CLOSE t603_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t603_cl INTO g_aff.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_aff.aff00,SQLCA.sqlcode,0)
                        CLOSE t603_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_afg_t.*=g_afg[l_ac].*
                        LET g_afg_o.*=g_afg[l_ac].*
                        OPEN t603_bcl USING g_aff.aff00,g_aff.aff01,g_aff.aff02,
                                            g_aff.aff03,g_aff.aff04,g_aff.aff05,
                                            g_aff.aff06,g_afg_t.afg07
                        IF STATUS THEN
                                CALL cl_err("OPEN t603_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH t603_bcl INTO g_afg[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_afg_t.afg07,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF                               
                       END IF
                END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_afg[l_ac].* TO NULL
                LET g_afg_t.*=g_afg[l_ac].*
                LET g_afg_o.*=g_afg[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD afg07
       AFTER INSERT
                IF INT_FLAG THEN
                   CALL cl_err('',9001,0)
                   LET INT_FLAG=0
                   CANCEL INSERT
                END IF
                INSERT INTO afg_file(afg00,afg01,afg02,afg03,afg04,afg05,afg06,afg07,afg08)
                VALUES(g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,g_aff.aff04,
                       g_aff.aff05,g_aff.aff06,g_afg[l_ac].afg07,g_afg[l_ac].afg08)
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","afg_file",g_aff.aff01,g_afg[l_ac].afg07,SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
                ELSE
                  MESSAGE 'INSERT Ok'
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b To FORMONLY.cn2
                  CALL t603_sum()
                END IF
                
      BEFORE FIELD afg07
        IF cl_null(g_afg[l_ac].afg07) OR g_afg[l_ac].afg07=0 THEN 
            SELECT MAX(afg07)+1 INTO g_afg[l_ac].afg07 FROM afg_file
                WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
                 AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
                 AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
                 AND  afg06 = g_aff.aff06
                IF cl_null(g_afg[l_ac].afg07) THEN
                   LET g_afg[l_ac].afg07 = 1 
                END IF
         END IF
      AFTER FIELD afg07
        IF NOT cl_null(g_afg[l_ac].afg07) THEN 
           IF g_afg[l_ac].afg07!=g_afg_t.afg07
              OR cl_null(g_afg_t.afg07) THEN
              SELECT COUNT(*) INTO l_n FROM afg_file
              WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
               AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
               AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
               AND  afg06 = g_aff.aff06 AND afg07 = g_afg[l_ac].afg07
              IF l_n>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_afg[l_ac].afg07=g_afg_t.afg07
                  NEXT FIELD afg07
              ELSE
                  IF g_afg[l_ac].afg07>=1 THEN
                     IF g_azm.azm02 = '1' THEN
                        IF g_afg[l_ac].afg07>12 THEN
                           CALL cl_err('','mfg9287',0)
                           NEXT FIELD afg07
                        END IF
                     END IF
                     IF g_azm.azm02 = '2' THEN                         
                        IF g_afg[l_ac].afg07>13 THEN       
                           CALL cl_err('','mfg9288',0)            
                           NEXT FIELD afg07                            
                        END IF                                         
                     END IF    
                  ELSE 
                     NEXT FIELD afg07
                  END IF
              END IF
           END IF
        END IF
         
      AFTER FIELD afg08
        IF g_afg[l_ac].afg08 <= 0 THEN
           CALL cl_err('','axr-029',0)
	   NEXT FIELD afg08
        END IF
 
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_afg_t.afg07 > 0 AND g_afg_t.afg07 <=13 AND g_afg_t.afg07 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM afg_file
               WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
                AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
                AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
                AND  afg06 = g_aff.aff06 AND afg07 = g_afg_t.afg07
                 
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","afg_file",g_aff.aff00,g_afg_t.afg07,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_afg[l_ac].* = g_afg_t.*
              CLOSE t603_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_afg[l_ac].afg07,-263,1)
              LET g_afg[l_ac].* = g_afg_t.*
           ELSE
              UPDATE afg_file SET afg07 = g_afg[l_ac].afg07,
                                  afg08 = g_afg[l_ac].afg08  
                 WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
                  AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
                  AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
                  AND  afg06 = g_aff.aff06 AND afg07 = g_afg_t.afg07
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","afg_file",g_aff.aff01,g_afg_t.afg07,SQLCA.sqlcode,"","",1) 
                 LET g_afg[l_ac].* = g_afg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 CALL t603_sum()
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_afg[l_ac].* = g_afg_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_afg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE t603_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032 add 
           CLOSE t603_bcl
           COMMIT WORK
      ON ACTION CONTROLO                        
           IF INFIELD(afg02) AND l_ac > 1 THEN
              LET g_afg[l_ac].* = g_afg[l_ac-1].*
              LET g_afg[l_ac].afg07 = g_rec_b + 1
              NEXT FIELD afg07
           END IF
 
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
 
    LET g_aff.affmodu = g_user
    LET g_aff.affdate = g_today
    UPDATE aff_file SET affmodu = g_aff.affmodu,affdate = g_aff.affdate
       WHERE aff01 = g_aff.aff01 AND aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
         AND aff04 = g_aff.aff04 AND aff05 = g_aff.aff05 AND aff06 = g_aff.aff06
    DISPLAY BY NAME g_aff.affmodu,g_aff.affdate
  
    CLOSE t603_bcl
    COMMIT WORK
#   CALL t603_delall()  #CHI-C30002 mark
    CALL t603_delHeader()     #CHI-C30002 add
    CALL t603_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION t603_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM aff_file WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01
                                AND  aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
                                AND  aff04 = g_aff.aff04 AND aff05 = g_aff.aff05
                                AND  aff06 = g_aff.aff06
         DELETE FROM afg_file WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
                                AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
                                AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
                                AND  afg06 = g_aff.aff06
         INITIALIZE g_aff.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t603_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM afg_file
#   WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
#    AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
#    AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
#    AND  afg06 = g_aff.aff06 
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM aff_file WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01
#                           AND  aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
#                           AND  aff04 = g_aff.aff04 AND aff05 = g_aff.aff05
#                           AND  aff06 = g_aff.aff06
#     DELETE FROM afg_file WHERE afg00 = g_aff.aff00 AND afg01 = g_aff.aff01
#                           AND  afg02 = g_aff.aff02 AND afg03 = g_aff.aff03
#                           AND  afg04 = g_aff.aff04 AND afg05 = g_aff.aff05
#                           AND  afg06 = g_aff.aff06
#  END IF
#
#END FUNCTION                  
#CHI-C30002 -------- mark -------- end
                                
FUNCTION t603_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
    IF cl_null(g_aff.aff00)OR 
      cl_null(g_aff.aff01) OR cl_null(g_aff.aff02) OR
      cl_null(g_aff.aff03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_aff.* FROM aff_file
    WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01
     AND  aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
     AND  aff04 = g_aff.aff04 AND aff05 = g_aff.aff05
     AND  aff06 = g_aff.aff06
 
   IF g_aff.affacti ='N' THEN    
      CALL cl_err(g_aff.aff00,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t603_cl USING g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,
       g_aff.aff04,g_aff.aff05,g_aff.aff06
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_aff.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_aff.aff00,SQLCA.sqlcode,0)    
       CLOSE t603_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t603_show()
 
   WHILE TRUE
      LET g_aff_o.* = g_aff.*
      LET g_aff_t.* = g_aff.*
      LET g_aff.affmodu=g_user
      LET g_aff.affdate=g_today
 
      CALL t603_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aff.*=g_aff_t.*
         CALL t603_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_aff.aff00 != g_aff_t.aff00 OR g_aff.aff01 != g_aff_t.aff01 OR
         g_aff.aff02 != g_aff_t.aff02 OR g_aff.aff03 != g_aff_t.aff03 OR
         g_aff.aff04 != g_aff_t.aff04 OR g_aff.aff05 != g_aff_t.aff05 OR
         g_aff.aff06 != g_aff_t.aff06 THEN 
         UPDATE afg_file SET afg00 = g_aff.aff00,
                             afg01 = g_aff.aff01,
                             afg02 = g_aff.aff02,
                             afg03 = g_aff.aff03,
                             afg04 = g_aff.aff04,
                             afg05 = g_aff.aff05,
                             afg06 = g_aff.aff06
          WHERE afg00 = g_aff_t.aff00 AND afg01 = g_aff_t.aff01 AND afg02 = g_aff_t.aff02
           AND  afg03 = g_aff_t.aff03 AND afg04 = g_aff_t.aff04 AND afg05 = g_aff_t.aff05
           AND  afg06 = g_aff_t.aff06
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","afg_file",g_aff_t.aff00,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE aff_file SET aff_file.* = g_aff.*
       WHERE aff00 = g_aff_t.aff00 AND aff01 = g_aff_t.aff01 AND aff02 = g_aff_t.aff02 AND
             aff03 = g_aff_t.aff03 AND aff04 = g_aff_t.aff04 AND aff05 = g_aff_t.aff05 AND
             aff06 = g_aff_t.aff06
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aff_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t603_cl
   COMMIT WORK
   CALL t603_show()
   CALL cl_flow_notify(g_aff.aff00,'U')
   
   CALL t603_b()
   CALL t603_b_fill("1=1")
   CALL t603_bp_refresh()
 
END FUNCTION          
                
FUNCTION t603_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_aff.aff00) OR  
      cl_null(g_aff.aff01) OR cl_null(g_aff.aff02) OR
      cl_null(g_aff.aff03) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_aff.* FROM aff_file
    WHERE aff00=g_aff.aff00 AND aff01=g_aff.aff01 AND aff02=g_aff.aff02
     AND  aff03=g_aff.aff03 AND aff04=g_aff.aff04 AND aff05=g_aff.aff05
     AND  aff06=g_aff.aff06
   IF g_aff.affacti ='N' THEN    
      CALL cl_err(g_aff.aff01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t603_cl USING g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,
       g_aff.aff04,g_aff.aff05,g_aff.aff06
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_aff.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aff.aff00,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t603_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "aff00"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_aff.aff00      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM aff_file WHERE aff00=g_aff.aff00 AND aff01=g_aff.aff01 AND aff02=g_aff.aff02
                            AND  aff03=g_aff.aff03 AND aff04=g_aff.aff04 AND aff05=g_aff.aff05
                            AND  aff06=g_aff.aff06
      DELETE FROM afg_file WHERE afg00=g_aff.aff00 AND afg01=g_aff.aff01 AND afg02=g_aff.aff02
                            AND  afg03=g_aff.aff03 AND afg04=g_aff.aff04 AND afg05=g_aff.aff05
                            AND  afg06=g_aff.aff06
      CLEAR FORM
      CALL g_afg.clear()
      OPEN t603_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t603_cs
         CLOSE t603_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end-- 
      FETCH t603_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t603_cs
         CLOSE t603_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t603_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t603_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE      
            CALL t603_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t603_cl
   COMMIT WORK
   CALL cl_flow_notify(g_aff.aff00,'D')
END FUNCTION
 
FUNCTION t603_copy()
   DEFINE l_newno0    LIKE aff_file.aff00
   DEFINE l_newno1    LIKE aff_file.aff01
   DEFINE l_newno2    LIKE aff_file.aff02
   DEFINE l_newno3    LIKE aff_file.aff03
   DEFINE l_newno4    LIKE aff_file.aff04
   DEFINE l_newno5    LIKE aff_file.aff05
   DEFINE l_newno6    LIKE aff_file.aff06
   DEFINE l_oldno0    LIKE aff_file.aff00
   DEFINE l_oldno1    LIKE aff_file.aff01
   DEFINE l_oldno2    LIKE aff_file.aff02
   DEFINE l_oldno3    LIKE aff_file.aff03
   DEFINE l_oldno4    LIKE aff_file.aff04
   DEFINE l_oldno5    LIKE aff_file.aff05
   DEFINE l_oldno6    LIKE aff_file.aff06
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_aff01     LIKE aff_file.aff01
   IF s_shut(0) THEN RETURN END IF
 
   LET g_aff_t.* = g_aff.*
   IF cl_null(g_aff.aff00) OR 
      cl_null(g_aff.aff01) OR cl_null(g_aff.aff02) OR
      cl_null(g_aff.aff03) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL t603_show()
   LET g_before_input_done = FALSE
   CALL t603_set_entry('c') 
   
   CALL cl_set_head_visible("","YES")      
 
   INPUT l_newno0,l_newno1,l_newno2,l_newno3,l_newno4,l_newno5,l_newno6 FROM
         aff00,aff01,aff02,aff03,aff04,aff05,aff06
     BEFORE INPUT
         LET l_newno0 = g_aza.aza81
         LET l_newno1 = YEAR(g_today)
         DISPLAY l_newno0,l_newno1 TO aff00,aff01
     AFTER FIELD aff00
         IF NOT cl_null(l_newno0) THEN                 
               SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01 = g_aff.aff00 AND aaaacti = 'Y'
               IF l_n < 1 THEN
                  CALL cl_err('aff00:','agl-095',0)
                  LET l_newno0 = g_aff_t.aff00
                  DISPLAY l_newno0 TO aff00
                  NEXT FIELD aff00
               END IF
         END IF
        
      AFTER FIELD aff04
         IF NOT cl_null(l_newno4) THEN
            LET g_aff.aff04 = l_newno4
            CALL t603_aff04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('aff04:',g_errno,0)
               LET g_aff.aff04 = g_aff_t.aff04
               DISPLAY l_newno4 TO aff04
               NEXT FIELD aff04
            END IF
            LET g_aff.aff04 = g_aff_t.aff04
         ELSE
            LET l_newno4 = ' '    
         END IF  
 
      AFTER FIELD aff02
         IF NOT cl_null(l_newno2) THEN
            LET g_aff.aff02 = l_newno2
            CALL t603_aff02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('aff02:',g_errno,0)
               LET g_aff.aff02 = g_aff_t.aff02
               DISPLAY l_newno2 TO aff02
               NEXT FIELD aff02
            END IF
            LET g_aff.aff02 = g_aff_t.aff02
         ELSE
            LET l_newno1 = ' '
         END IF 
                  
      AFTER FIELD aff03
         IF NOT cl_null(l_newno3) THEN
            LET g_aff.aff03 = l_newno3
            CALL t603_aff03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('aff03:',g_errno,0)
              #Mod No.FUN-B10048
              #LET g_aff.aff03 = g_aff_t.aff03
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.arg1 = g_aff.aff00
               LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",l_newno3 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_newno3
              #End Mod No.FUN-B10048
               DISPLAY l_newno3 TO aff03
               NEXT FIELD aff03
            END IF
            LET g_aff.aff03 = g_aff_t.aff03
         END IF
         
      AFTER FIELD aff01
         IF NOT cl_null(l_newno1) THEN
               LET l_aff01 = l_newno1
               IF LENGTH(l_aff01)<>4 THEN
                  NEXT FIELD aff01
               END IF
         END IF              
       AFTER INPUT 
         IF INT_FLAG THEN
               LET g_aff.* = g_aff_t.*
               EXIT INPUT
         END IF
           CASE 
              WHEN cl_null(l_newno0)
                   NEXT FIELD aff00
              WHEN cl_null(l_newno2)
                   NEXT FIELD aff02
              WHEN cl_null(l_newno3)
                   NEXT FIELD aff03
              WHEN cl_null(l_newno4)
                   NEXT FIELD aff04
              OTHERWISE EXIT CASE
           END CASE
           
           SELECT COUNT(*) INTO l_n FROM aff_file WHERE aff00 = l_newno0 AND aff01 = l_newno1
                                                    AND aff02 = l_newno2 AND aff03 = l_newno3
                                                    AND aff04 = l_newno4 AND aff05 = l_newno5 AND aff06 = l_newno6
           IF l_n > 0 THEN
              CALL cl_err('',-239,0)
              NEXT FIELD aff00
           END IF                                               
       ON ACTION controlp
          CASE
              WHEN INFIELD(aff04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING l_newno4
                 DISPLAY l_newno4 TO aff04
                 NEXT FIELD aff04
               WHEN INFIELD(aff02)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"                   #No.FUN-930106
                 LET g_qryparam.form = "q_azf01a"                #No.FUN-930106  
                #LET g_qryparam.arg1 = '2'                       #No.FUN-930106
                #LET g_qryparam.arg1 = '9'                       #FUN-950077 mark 
                 LET g_qryparam.arg1 = '7'                       #FUN-950077 add
                 CALL cl_create_qry() RETURNING l_newno2
                 DISPLAY l_newno2 TO aff02
                 NEXT FIELD aff01
               WHEN INFIELD(aff03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aff.aff00
                 CALL cl_create_qry() RETURNING l_newno3
                 DISPLAY l_newno3 TO aff03
                 NEXT FIELD aff03
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
      DISPLAY BY NAME g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,
                      g_aff.aff04,g_aff.aff05,g_aff.aff06  
      ROLLBACK WORK  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM aff_file         
    WHERE aff00=g_aff.aff00 AND aff01=g_aff.aff01 AND aff02=g_aff.aff02
      AND aff03=g_aff.aff03 AND aff04=g_aff.aff04 AND aff05=g_aff.aff05
      AND aff06=g_aff.aff06
     INTO TEMP y
 
   UPDATE y
      SET aff00=l_newno0,
          aff01=l_newno1,
          aff02=l_newno2,
          aff03=l_newno3,
          aff04=l_newno4,
          aff05=l_newno5,
          aff06=l_newno6,
          affuser=g_user,   
          affgrup=g_grup,   
          affmodu=NULL,     
          affdate=g_today,  
          affacti='Y'      
 
   INSERT INTO aff_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aff_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE 
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM afg_file         
    WHERE afg00=g_aff.aff00 AND afg01=g_aff.aff01 AND afg02=g_aff.aff02
      AND afg03=g_aff.aff03 AND afg04=g_aff.aff04 AND afg05=g_aff.aff05
      AND afg06=g_aff.aff06
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET afg00 = l_newno0,
                afg01 = l_newno1,
                afg02 = l_newno2,
                afg03 = l_newno3,
                afg04 = l_newno4,
                afg05 = l_newno5,
                afg06 = l_newno6
   INSERT INTO afg_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","afg_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-B80057---調整至回滾事務前---
      ROLLBACK WORK 
      RETURN
   ELSE
      COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno0,') O.K'
 
   LET l_oldno0 = g_aff.aff00
   LET l_oldno1 = g_aff.aff01
   LET l_oldno2 = g_aff.aff02
   LET l_oldno3 = g_aff.aff03
   LET l_oldno4 = g_aff.aff04
   LET l_oldno5 = g_aff.aff05
   LET l_oldno6 = g_aff.aff06
   SELECT * INTO g_aff.* FROM aff_file 
    WHERE aff00 = l_newno0 AND aff01 = l_newno1
      AND aff02 = l_newno2 AND aff03 = l_newno3
      AND aff04 = l_newno4 AND aff05 = l_newno5 AND aff06 = l_newno6
   CALL t603_u()
   CALL t603_b()
   #FUN-C30027---begin
   #SELECT * INTO g_aff.* FROM aff_file 
   # WHERE aff00 = l_oldno0 AND aff01 = l_oldno1
   #   AND aff02 = l_oldno2 AND aff03 = l_oldno3
   #   AND aff04 = l_oldno4 AND aff05 = l_oldno5 AND aff06 = l_oldno6
   #CALL t603_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION t603_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_aff.aff01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t603_cl USING g_aff.aff00,g_aff.aff01,g_aff.aff02,g_aff.aff03,
       g_aff.aff04,g_aff.aff05,g_aff.aff06
   IF STATUS THEN
      CALL cl_err("OPEN t603_cl:", STATUS, 1)
      CLOSE t603_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t603_cl INTO g_aff.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aff.aff01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t603_show()
 
   IF cl_exp(0,0,g_aff.affacti) THEN                   
      LET g_chr=g_aff.affacti
      IF g_aff.affacti='Y' THEN
         LET g_aff.affacti='N'
      ELSE
         LET g_aff.affacti='Y'
      END IF
 
      UPDATE aff_file SET affacti=g_aff.affacti,
                          affmodu=g_user,
                          affdate=g_today
       WHERE aff00=g_aff.aff00 AND aff01=g_aff.aff01 AND aff02=g_aff.aff02
        AND  aff03=g_aff.aff03 AND aff04=g_aff.aff04 AND aff05=g_aff.aff05
        AND  aff06=g_aff.aff06
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","aff_file",g_aff.aff00,"",SQLCA.sqlcode,"","",1)  
         LET g_aff.affacti=g_chr
      END IF
   END IF
 
   CLOSE t603_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aff.aff00,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT affacti,affmodu,affdate
     INTO g_aff.affacti,g_aff.affmodu,g_aff.affdate FROM aff_file
    WHERE aff00=g_aff.aff00 AND aff01=g_aff.aff01 AND aff02=g_aff.aff02
     AND  aff03=g_aff.aff03 AND aff04=g_aff.aff04 AND aff05=g_aff.aff05
     AND  aff06=g_aff.aff06
   DISPLAY BY NAME g_aff.affacti,g_aff.affmodu,g_aff.affdate
 
END FUNCTION
 
FUNCTION t603_bp_refresh()
  DISPLAY ARRAY g_afg TO s_afg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL t603_show()
END FUNCTION
 
FUNCTION t603_out()            
DEFINE l_wc    STRING                                                                             
    IF cl_null(g_aff.aff00) OR 
       cl_null(g_aff.aff02) OR cl_null(g_aff.aff03) OR
       cl_null(g_aff.aff01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" aff00 = '",g_aff.aff00,"'"," AND aff01 = '",g_aff.aff01,"'",
                 " AND aff02 = '",g_aff.aff02,"'"," AND aff03 = ",g_aff.aff03,
                 " AND aff04 = '",g_aff.aff04,"'"," AND aff05 = '",g_aff.aff05,"'",
                 " AND aff06 = '",g_aff.aff06,"'"
   END IF
   IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"    
   END IF
   CALL cl_wait()   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                    
   LET g_sql=" SELECT DISTINCT aff00,aff01,aff02,aff03,aff04,aff05,aff06,aff07,aff08,aff09,",  
             " aff10,aff11,aff12,aff13,afg07,afg08,azf03,aag02,gem02",
             " FROM aag_file,",
             " ((aff_file LEFT JOIN afg_file ON aff00 = afg00 AND aff01 = afg01 ",    
             " AND aff02 = afg02 AND aff03 = afg03 AND aff04 = afg04 AND aff05 = afg05 AND aff06 = afg06)",           
             " LEFT JOIN gem_file ON  gem01 = aff04) LEFT JOIN azf_file ON  azf01 = aff02 AND azf02 = '2'",     
             " WHERE aag00 = aff00 AND aag01 = aff03 AND aag03 = '2' AND aag07 IN ('2','3')",
             " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED 
   IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'aff00,aff01,aff02,aff03,aff04,aff05,aff06,aff07,aff08,aff09,  
                           aff10,aff11,aff12,aff13,afg07,afg08')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
    LET g_str = l_wc
    CALL cl_prt_cs1('aglt603','aglt603',g_sql,g_str)                                    
                        
 END FUNCTION                                                            
 
#計算年度和各季度預算
FUNCTION t603_sum() 
 DEFINE l_aff09  LIKE aff_file.aff09
 DEFINE l_aff10  LIKE aff_file.aff10
 DEFINE l_aff11  LIKE aff_file.aff11
 DEFINE l_aff12  LIKE aff_file.aff12
 DEFINE l_aff13  LIKE aff_file.aff13
 DEFINE l_sql    STRING
    LET l_sql="SELECT COALESCE(SUM(afg08),0) FROM afg_file",
            " WHERE afg00 = '",g_aff.aff00,"'"," AND afg01 =  ",g_aff.aff01,
            "   AND afg02 = '",g_aff.aff02,"'"," AND afg03 = '",g_aff.aff03,"'",
            "   AND afg04 = '",g_aff.aff04,"'"," AND afg05 = '",g_aff.aff05,"'",
            "   AND afg06 = '",g_aff.aff06,"'"," AND afg07 >= ? AND afg07 <= ?"
    #No.CHI-950007  --Begin
   #DECLARE t603_sum CURSOR FROM l_sql    
    PREPARE t603_sum_p FROM l_sql 
    EXECUTE t603_sum_p USING '1','3' INTO l_aff10
    EXECUTE t603_sum_p USING '4','6' INTO l_aff11
    EXECUTE t603_sum_p USING '7','9' INTO l_aff12
    IF g_azm.azm02 = '1' THEN
    EXECUTE t603_sum_p USING '10','12' INTO l_aff13
    END IF
    IF g_azm.azm02 = '2' THEN
    EXECUTE t603_sum_p USING '10','13' INTO l_aff13
    END IF
    FREE t603_sum_p
    #No.CHI-950007  --End
    LET l_aff09 = l_aff10 + l_aff11 + l_aff12 + l_aff13
    UPDATE aff_file SET aff09 = l_aff09,
                        aff10 = l_aff10,
                        aff11 = l_aff11,
                        aff12 = l_aff12,
                        aff13 = l_aff13 
           WHERE aff00 = g_aff.aff00 AND aff01 = g_aff.aff01
             AND aff02 = g_aff.aff02 AND aff03 = g_aff.aff03
             AND aff04 = g_aff.aff04 AND aff05 = g_aff.aff05
             AND aff06 = g_aff.aff06    
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","aff_file",g_aff.aff00,"",SQLCA.sqlcode,"","",1)  
        ROLLBACK WORK
     END IF
     LET g_aff.aff09 = l_aff09
     LET g_aff.aff10 = l_aff10
     LET g_aff.aff11 = l_aff11
     LET g_aff.aff12 = l_aff12
     LET g_aff.aff13 = l_aff13
      DISPLAY l_aff09,l_aff10,l_aff11,l_aff12,l_aff13
         TO  aff09,aff10,aff11,aff12,aff13
                                                                                
END FUNCTION 

