# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"arti122.4gl"
#Descriptions..:價格信息表維護作業
#Date & Author..:FUN-870007 08/07/07 By Zhangyajun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控 
# Modify.........: No:FUN-A30030 10/03/11 By Cockroach 添加pos相關管控
# Modify.........: No:FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No:TQC-AB0123 10/11/28 By shenyang GP5.2 SOP流程修改
# Modify.........: No:FUN-B50023 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B40103 11/05/04 By shiwuying 增加开价否栏位rth07
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B70075 11/10/25 By yangxf 更新已传pos否的状态
# Modify.........: No:FUN-C50036 12/05/18 By fanbj 添加rth08和rth09欄位
# Modify.........: No.FUN-C50036 12/05/31 By yangxf 如果aza88=Y， 已传pos否<>'1'，更改时把key值noentry
# Modify.........: No:FUN-C60024 12/06/20 By fanbj BUG更改
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/09 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40044 13/04/19 By dongsz 維護單位時，檢查是否存在庫存單位轉化率，存在時才能維護

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rth01         LIKE rth_file.rth01,
        g_rth01_t       LIKE rth_file.rth01,
        g_rthplant      LIKE rth_file.rthplant,
        g_rthplant_t    LIKE rth_file.rthplant,
        g_rthlegal      LIKE rth_file.rthlegal,
        g_rthlegal_t    LIKE rth_file.rthlegal,
        g_tqa           RECORD LIKE tqa_file.*,
        g_rth   DYNAMIC ARRAY OF RECORD 
                rth02   LIKE rth_file.rth02,
                rth02_desc LIKE gfe_file.gfe02,
                rth03   LIKE rth_file.rth03,
                rth04   LIKE rth_file.rth04,
                rth05   LIKE rth_file.rth05,
                rth06   LIKE rth_file.rth06,
                rth08   LIKE rth_file.rth08,  #FUN-C50036 add
                rth09   LIKE rth_file.rth09,  #FUN-C50036 add   
                rth07   LIKE rth_file.rth07,  #FUN-B40103
                rthacti LIKE rth_file.rthacti,
                rthpos  LIKE rth_file.rthpos
                        END RECORD,
        g_rth_t RECORD
                rth02   LIKE rth_file.rth02,
                rth02_desc LIKE gfe_file.gfe02,
                rth03   LIKE rth_file.rth03,
                rth04   LIKE rth_file.rth04,
                rth05   LIKE rth_file.rth05,
                rth06   LIKE rth_file.rth06,
                rth08   LIKE rth_file.rth08,  #FUN-C50036 add
                rth09   LIKE rth_file.rth09,  #FUN-C50036 add
                rth07   LIKE rth_file.rth07,  #FUN-B40103
                rthacti LIKE rth_file.rthacti,
                rthpos  LIKE rth_file.rthpos
                        END RECORD
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
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
DEFINE  l_ima      RECORD LIKE  ima_file.*  
DEFINE  l_ret           LIKE type_file.chr1
DEFINE  g_rtz05   LIKE rtz_file.rtz05
 
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
          
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i122_w AT p_row,p_col WITH FORM "art/42f/arti122"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    
    CALL cl_set_comp_visible('rthpos',g_aza.aza88='Y')
    CALL cl_set_comp_visible("rth09",FALSE)             #FUN-C50036 add
 
    SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant
    CALL i122_menu()
    CLOSE WINDOW i122_w                   
    CALL  cl_used(g_prog,g_time,2)        
    RETURNING g_time    
END MAIN
 
FUNCTION i122_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rth TO s_rth.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      ON ACTION first
         CALL i122_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i122_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i122_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i122_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i122_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
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
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i122_menu()
 
   WHILE TRUE
      CALL i122_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i122_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i122_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL i122_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL i122_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL i122_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i122_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rth),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i122_cs()
 
    CLEAR FORM
    CONSTRUCT g_wc ON rth01,rthplant,
                      #rth02,rth03,rth04,rth05,rth06,rth07, #FUN-B40103 #FUN-C50036 add
                      rth02,rth03,rth04,rth05,rth06,rth08,rth09,rth07,  #FUN-C50036 add
                      rthacti,rthpos
       FROM rth01,rthplant,
            s_rth[1].rth02,s_rth[1].rth03,s_rth[1].rth04,s_rth[1].rth05,s_rth[1].rth06,
            s_rth[1].rth08,s_rth[1].rth09,   #FUN-C50036 add
            s_rth[1].rth07,                  #FUN-B40103
            s_rth[1].rthacti,s_rth[1].rthpos
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rth01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rth01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1=g_plant
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rth01
                 NEXT FIELD rth01
              WHEN INFIELD(rth02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rth02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1=g_plant
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rth02
                 NEXT FIELD rth02
              WHEN INFIELD(rthplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rthplant
                 NEXT FIELD rthplant
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
    #        LET g_wc = g_wc CLIPPED," AND rthuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rthgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rthgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rthuser', 'rthgrup')
    #End:FUN-980030
 
    IF INT_FLAG THEN 
        RETURN
    END IF
      
    LET g_sql="SELECT DISTINCT rth01,rthplant FROM rth_file ", 
#        " WHERE ",g_wc CLIPPED," AND rthplant IN ",g_auth,
         " WHERE ",g_wc CLIPPED,
         " ORDER BY rth01"
 
    PREPARE i122_prepare FROM g_sql
    DECLARE i122_cs SCROLL CURSOR WITH HOLD FOR i122_prepare
 
    LET g_sql="SELECT COUNT(*) FROM (SELECT DISTINCT rth01,rthplant FROM rth_file WHERE ",
#              " rthplant IN ",g_auth," AND ",g_wc CLIPPED,")"
              g_wc CLIPPED,")"
 
    PREPARE i122_precount FROM g_sql
    DECLARE i122_count CURSOR FOR i122_precount
    
END FUNCTION
 
FUNCTION i122_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rth.clear()      
    MESSAGE ""
    
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i122_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rth01 TO NULL
        RETURN
    END IF
    OPEN i122_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rth.clear()
    ELSE
        OPEN i122_count
        FETCH i122_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL i122_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION i122_fetch(p_flrth)
    DEFINE
        p_flrth         LIKE type_file.chr1           
    CASE p_flrth
        WHEN 'N' FETCH NEXT     i122_cs INTO g_rth01,g_rthplant
        WHEN 'P' FETCH PREVIOUS i122_cs INTO g_rth01,g_rthplant
        WHEN 'F' FETCH FIRST    i122_cs INTO g_rth01,g_rthplant
        WHEN 'L' FETCH LAST     i122_cs INTO g_rth01,g_rthplant
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
            FETCH ABSOLUTE g_jump i122_cs INTO g_rth01,g_rthplant
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rth01,SQLCA.sqlcode,0)
        INITIALIZE g_rth01 TO NULL  
        RETURN
    ELSE
      CASE p_flrth
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
     LET g_data_plant = g_rthplant   #TQC-A10128 ADD 
    CALL i122_show()                   
 
END FUNCTION
 
FUNCTION i122_rth01(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  l_ima25    LIKE gfe_file.gfe02
DEFINE l_n LIKE type_file.num5
             
   LET g_errno = ' '
   
   SELECT ima02,ima021,ima25,ima1004,ima1005,ima1006,ima1007,ima1009,imaacti,gfe02
          INTO l_ima.ima02,l_ima.ima021,l_ima.ima25,l_ima.ima1004,l_ima.ima1005,
               l_ima.ima1006,l_ima.ima1007,l_ima.ima1009,l_ima.imaacti,l_ima25
           FROM ima_file LEFT JOIN gfe_file ON ima25 = gfe01
        WHERE ima01 = g_rth01
        
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-030' 
                                 INITIALIZE l_ima.* TO NULL
        WHEN l_ima.imaacti='N'       LET g_errno = '9028'      
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) AND NOT cl_null(g_rtz05) THEN
     SELECT COUNT(*) INTO l_n FROM rtg_file
      WHERE rtg01 = g_rtz05
        AND rtg03 = g_rth01
     IF l_n=0 THEN
        LET g_errno = 'art-902'
     END IF
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima.ima02   TO ima02
      DISPLAY l_ima.ima021  TO ima021
      DISPLAY l_ima.ima25   TO ima25
      DISPLAY l_ima25       TO ima25_desc
      DISPLAY l_ima.ima1004 TO ima1004
      DISPLAY l_ima.ima1005 TO ima1005
      DISPLAY l_ima.ima1006 TO ima1006
      DISPLAY l_ima.ima1007 TO ima1007
      DISPLAY l_ima.ima1009 TO ima1009     
  END IF
 
END FUNCTION
 
FUNCTION i122_rth02(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1 
DEFINE  l_gfe02    LIKE gfe_file.gfe02,
        l_gfeacti  LIKE gfe_file.gfeacti,
        l_flag    LIKE type_file.num5,
        l_fac     LIKE ima_file.ima31_fac,         
        l_rtg08   LIKE rtg_file.rtg08,
        l_rtg09   LIKE rtg_file.rtg09
 
   LET g_errno = ' '
   
   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti FROM gfe_file 
        WHERE gfe01 = g_rth[l_ac].rth02
   CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-031' 
                                 LET l_gfe02 = NULL 
        WHEN l_gfeacti='N'       LET g_errno = '9028'      
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   IF cl_null(g_errno) THEN
      IF g_rth[l_ac].rth02 != l_ima.ima25 THEN                                        #TQC-D40044 add
        #CALL s_umfchk('',l_ima.ima25,g_rth[l_ac].rth02) RETURNING l_flag,l_fac       #TQC-D40044 mark
         CALL s_umfchk(g_rth01,l_ima.ima25,g_rth[l_ac].rth02) RETURNING l_flag,l_fac  #TQC-D40044 add
         IF l_flag = 1 THEN
            LET g_errno = 'art-032'
         END IF
      END IF                                                  #TQC-D40044 add
   END IF                                              
   IF cl_null(g_errno) AND NOT cl_null(g_rtz05) THEN
      SELECT rtg08,rtg09 INTO l_rtg08,l_rtg09 FROM rtg_file
       WHERE rtg01 = g_rtz05 
         AND rtg03 = g_rth01
         AND rtg04 = g_rth[l_ac].rth02
      CASE 
         WHEN SQLCA.sqlcode=100 LET g_errno='art-901'
         WHEN l_rtg08='N'       LET g_errno='art-065'
         WHEN l_rtg09='N'       LET g_errno='9028'
         OTHERWISE              LET g_errno=SQLCA.sqlcode USING '------'
      END CASE
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rth[l_ac].rth02_desc = l_gfe02
      LET g_rth[l_ac].rth03 = l_fac
      DISPLAY BY NAME   g_rth[l_ac].rth02_desc,g_rth[l_ac].rth03
   END IF
 
END FUNCTION
 
FUNCTION i122_show()
DEFINE l_rthplant_desc LIKE azp_file.azp02
 
    DISPLAY g_rth01 TO rth01
    DISPLAY g_rthplant TO rthplant
    SELECT azp02 INTO l_rthplant_desc FROM azp_file
     WHERE azp01 = g_rthplant
    DISPLAY l_rthplant_desc TO rthplant_desc
    CALL i122_rth01('d')
    CALL i122_b_fill(g_wc) 
    CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION i122_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        #"SELECT rth02,'',rth03,rth04,rth05,rth06,rth07,rthacti,rthpos FROM rth_file ", #FUN-B40103 #FUN-C50036 add
        "SELECT rth02,'',rth03,rth04,rth05,rth06,rth08,rth09,rth07,rthacti,rthpos FROM rth_file ",  #FUN-C50036 add
        " WHERE rth01= '",g_rth01,"' AND rthplant = '",g_rthplant,"'" 
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i122_pb FROM g_sql
    DECLARE rth_cs CURSOR FOR i122_pb
 
    CALL g_rth.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rth_cs INTO g_rth[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT gfe02 INTO g_rth[g_cnt].rth02_desc FROM gfe_file
               WHERE gfe01 = g_rth[g_cnt].rth02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rth.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i122_i_init()
DEFINE l_rthplant_desc LIKE azp_file.azp02 
 
   LET g_rthplant=g_plant
   LET g_data_plant = g_plant  #TQC-A10128 ADD 
   SELECT azw02 INTO g_rthlegal FROM azw_file WHERE azw01=g_plant
   SELECT azp02 INTO l_rthplant_desc FROM azp_file
     WHERE azp01 = g_rthplant  
   DISPLAY g_rthplant,l_rthplant_desc
        TO rthplant,rthplant_desc
        
END FUNCTION
 
FUNCTION i122_a()
   DEFINE li_result   LIKE type_file.num5                
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10              
 
   MESSAGE ""
   CLEAR FORM
   LET g_wc = NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET g_rth01 = NULL
   LET g_rth01_t = NULL
   CALL g_rth.clear()
   CALL cl_opmsg('a')
   
   WHILE TRUE
   
      CALL i122_i_init()
      CALL i122_i("a")                          
 
      IF INT_FLAG THEN                 
         CLEAR FORM
         CALL g_rth.clear()      
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rth01) THEN       
         CONTINUE WHILE
      END IF
      LET g_rec_b = 0
      CALL i122_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i122_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,                     
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5            
     
   CALL cl_set_head_visible("","YES")
   INPUT g_rth01  WITHOUT DEFAULTS      
     FROM rth01 
     
      AFTER FIELD rth01
         DISPLAY "AFTER FIELD rth01"
         IF NOT cl_null(g_rth01) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rth01,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rth01= g_rth01_t
               NEXT FIELD rth01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rth01 != g_rth01_t) THEN
               SELECT COUNT(*) INTO l_n FROM rth_file 
                WHERE rth01 = g_rth01 AND rthplant = g_rthplant
               IF l_n > 0 THEN   
                 CALL i122_rth01('d')              
                 CALL i122_b_fill("1=1")
                 LET l_ac = g_rec_b + 1
                 CALL i122_b()
                 EXIT INPUT
               ELSE
                 CALL i122_rth01('a')
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rth01:',g_errno,0)
                  LET g_rth01 = g_rth01_t
                  DISPLAY BY NAME g_rth01
                  NEXT FIELD rth01
                 END IF
               END IF
            END IF
         END IF
 
     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_rth01 IS NULL THEN
               DISPLAY BY NAME g_rth01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD rth01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rth01) THEN
            LET g_rth01_t = g_rth01
            CALL i122_show()
            NEXT FIELD rth01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rth01)
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()                                                 #FUN-AA0059 mark
              IF cl_null(g_rtz05) THEN
#                LET g_qryparam.form = "q_ima01"                                     #FUN-AA0059 mark
                 CALL q_sel_ima(FALSE, "q_ima01","",g_rth01,"","","","","",'' )      #FUN-AA0059 add
                   RETURNING  g_rth01                                                #FUN-AA0059 add
              ELSE
              	 CALL cl_init_qry_var()                                              #FUN-AA0059 add
                 LET g_qryparam.form = "q_rtg03_1"
                 LET g_qryparam.arg1 = g_rtz05
                 LET g_qryparam.default1 = g_rth01                                   #FUN-AA0059 add     
                 CALL cl_create_qry() RETURNING g_rth01                              #FUN-AA0059 add
              END IF
#              LET g_qryparam.default1 = g_rth01                                     #FUN-AA0059 mark
#              CALL cl_create_qry() RETURNING g_rth01                                #FUN-AA0059 mark     
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_rth01 TO rth01
              CALL i122_rth01('d')
              NEXT FIELD rth01
 
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
 
FUNCTION i122_b()
        DEFINE  l_ac_t          LIKE type_file.num5,
                l_n             LIKE type_file.num5,
                l_cnt           LIKE type_file.num5,
                l_lock_sw       LIKE type_file.chr1,
                p_cmd           LIKE type_file.chr1,
                l_allow_insert  LIKE type_file.num5,
                l_allow_delete  LIKE type_file.num5
        DEFINE  l_price         LIKE rth_file.rth04      
        DEFINE  l_rtg07         LIKE rtg_file.rtg07
        DEFINE  l_rthpos        like rth_file.rthpos    #FUN-B70075        
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rth01) THEN
           CALL cl_err("",-400,0)
           RETURN 
        END IF
        CALL cl_opmsg('b')

        CALL i122_i_init() #FUN-B40103
        
        #LET g_forupd_sql = "SELECT rth02,'',rth03,rth04,rth05,rth06,rth07,rthacti,rthpos", #FUN-B40103  #FUN-C60024 mark
        LET g_forupd_sql = "SELECT rth02,'',rth03,rth04,rth05,rth06,rth08,rth09,rth07,rthacti,rthpos",   #FUN-C60024 add
                           " FROM rth_file",
                           " WHERE rth01=? AND rth02=? AND rthplant=?",
                           " FOR UPDATE"
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i122_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rth WITHOUT DEFAULTS FROM s_rth.*
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
                IF g_rec_b>=l_ac THEN 
                  #FUN-B70075 Begin---
#FUN-C50036 add begin ---
                   IF g_aza.aza88 = 'Y' THEN
                      IF g_rth[l_ac].rthpos <> '1' THEN
                         CALL cl_set_comp_entry("rth02",FALSE)
                      ELSE
                         CALL cl_set_comp_entry("rth02",TRUE)
                      END IF 
                   END IF 
#FUN-C50036 add end ---
                   IF g_aza.aza88 = 'Y' THEN
                       UPDATE rth_file SET rthpos = '4'
                        WHERE rth01 = g_rth01
                          AND rth02 = g_rth[l_ac].rth02
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("upd","rth_file",g_rth01_t,"",SQLCA.sqlcode,"","",1)
                          LET l_lock_sw = "Y"
                       END IF
                       LET l_rthpos = g_rth[l_ac].rthpos
                       LET g_rth[l_ac].rthpos = '4'
                       DISPLAY BY NAME g_rth[l_ac].rthpos
                   END IF
                  #FUN-B70075 End-----                
                BEGIN WORK 
                
                #IF g_rec_b>=l_ac THEN   #FUN-B70075 Mark
                        LET p_cmd ='u'
                        LET g_rth_t.*=g_rth[l_ac].*
 
                        OPEN i122_bcl USING g_rth01,g_rth_t.rth02,g_rthplant
                        IF STATUS THEN
                                CALL cl_err("OPEN i122_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i122_bcl INTO g_rth[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_rth_t.rth02,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i122_rth02('d')
                        END IF
                 END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                CALL cl_set_comp_entry("rth02",TRUE)  #FUN-C50036 add
                INITIALIZE g_rth[l_ac].* TO NULL
                LET g_rth[l_ac].rthpos = '1'      #NO.FUN-B50023
                LET l_rthpos = '1'                #FUN-B70075  
                LET g_rth[l_ac].rthacti = 'Y'
                LET g_rth[l_ac].rth07 = 'N'       #FUN-B40103
                LET g_rth[l_ac].rth09 = g_today   #FUN-C50036 add        
                LET g_rth_t.*=g_rth[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rth02
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                #INSERT INTO rth_file(rth01,rthplant,rthlegal,rth02,rth03,rth04,rth05,rth06,rth07, #FUN-B40103  #FUN-C50036 mark
                INSERT INTO rth_file(rth01,rthplant,rthlegal,rth02,rth03,rth04,rth05,              #FUN-C50036 add
                                     rth06,rth08,rth09,rth07,                                      #FUN-C50036 add    
                                     rthpos,rthacti,rthuser,rthgrup,rthcrat,rthoriu,rthorig)
                VALUES(g_rth01,g_rthplant,g_rthlegal,g_rth[l_ac].rth02,g_rth[l_ac].rth03,g_rth[l_ac].rth04,
                       #g_rth[l_ac].rth05,g_rth[l_ac].rth06,g_rth[l_ac].rth07, #FUN-B40103         #FUN-C50036 mark
                       g_rth[l_ac].rth05,g_rth[l_ac].rth06,g_rth[l_ac].rth08,g_rth[l_ac].rth09,    #FUN-C50036 add 
                       g_rth[l_ac].rth07,                                                          #FUN-C50036 add   
                       g_rth[l_ac].rthpos,g_rth[l_ac].rthacti,
                       g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rth_file",g_rth01,g_rth[l_ac].rth02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                
      AFTER FIELD rth02
        IF NOT cl_null(g_rth[l_ac].rth02) THEN 
           IF p_cmd = 'a' OR (p_cmd='u' AND g_rth[l_ac].rth02<>g_rth_t.rth02) THEN
                   SELECT COUNT(*) INTO l_n FROM rth_file
                        WHERE rth01 = g_rth01 AND rth02 = g_rth[l_ac].rth02 AND rthplant = g_rthplant
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rth[l_ac].rth02=g_rth_t.rth02
                           NEXT FIELD rth02
                       END IF
                       CALL i122_rth02('a')
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_rth[l_ac].rth02,g_errno,0)
                           LET g_rth[l_ac].rth02=g_rth_t.rth02
                           LET g_rth[l_ac].rth03=g_rth_t.rth03
                           NEXT FIELD rth02
                       END IF 
           END IF
        END IF                                
       
       AFTER FIELD rth04,rth05,rth06
           LET l_price = FGL_DIALOG_GETBUFFER()
           IF l_price < 0 THEN
              CALL cl_err('',"art-029",0)
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_rtz05) AND NOT cl_null(g_rth[l_ac].rth02) THEN
              SELECT rtg07 INTO l_rtg07 FROM rtg_file
               WHERE rtg01 = g_rtz05 AND rtg03 = g_rth01
                 AND rtg04 = g_rth[l_ac].rth02
              IF l_price < l_rtg07 THEN
                 CALL cl_err(l_rtg07,'art-900',0)
                 NEXT FIELD CURRENT
              END IF 
           END IF     
#TQC-AB0123 ---------------STA                                                  
                                                              
           IF NOT cl_null(g_rth[l_ac].rth05) THEN                               
              IF g_rth[l_ac].rth05>g_rth[l_ac].rth04 THEN                       
                 CALL cl_err('','art-979',0)                                    
              END IF                                                            
           END IF                                                                                             
           IF NOT cl_null(g_rth[l_ac].rth06) THEN                               
              IF g_rth[l_ac].rth06>g_rth[l_ac].rth04 OR g_rth[l_ac].rth06>g_rth[l_ac].rth05 THEN
                 CALL cl_err('','art-978',0)                                    
              END IF                                                            
           END IF                                                               
                                                                                
#TQC-AB0123 ---------------END  
       BEFORE DELETE                      
         IF NOT cl_null(g_rth_t.rth02) THEN
             IF g_aza.aza88 = 'Y' THEN                                   #FUN-A30030 ADD
               #FUN-B50023 --START--
                #IF NOT (g_rth[l_ac].rthacti='N' AND g_rth[l_ac].rthpos='Y') THEN
                #   CALL cl_err('','art-648',0)
                #   CANCEL DELETE
                #END IF
                #FUN-B70075  sta------------
                #IF NOT ((g_rth[l_ac].rthpos='3' AND g_rth[l_ac].rthacti='N') 
                #          OR (g_rth[l_ac].rthpos='1'))  THEN     
                 IF NOT ((l_rthpos = '3' AND g_rth[l_ac].rthacti='N')
                           OR (l_rthpos = '1')) THEN      
                #FUN-B70075  end-----------                     
                   CALL cl_err('','apc-139',0)            
                   CANCEL DELETE
                END IF     
               #FUN-B50023 --END--
             END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM rth_file
                WHERE rth01 = g_rth01 AND rth02 = g_rth_t.rth02 AND rthplant = g_rthplant
            IF SQLCA.sqlcode THEN   
               CALL cl_err3("del","rth_file",g_rth01,g_rth_t.rth02,SQLCA.sqlcode,"","",1)  
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
              LET g_rth[l_ac].* = g_rth_t.*
              CLOSE i122_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #FUN-870100---start
           IF g_aza.aza88 = 'Y' THEN         #FUN-A30030 ADD
             #FUN-B70075  sta------------ 
             #IF g_rth[l_ac].rth02<>g_rth_t.rth02 OR g_rth[l_ac].rth03<>g_rth_t.rth03 OR g_rth[l_ac].rth04<>g_rth_t.rth04 OR g_rth[l_ac].rth05<>g_rth_t.rth05
             #   OR g_rth[l_ac].rth06<>g_rth_t.rth06 OR g_rth[l_ac].rthpos<>g_rth_t.rthpos THEN
                 #FUN.B50023 --START--
                 #LET g_rth[l_ac].rthpos = 'N'
                 #FUN-B70075  sta------------
                 #IF g_rth[l_ac].rthpos <> '1' THEN
                  IF l_rthpos <> '1' THEN
                     LET g_rth[l_ac].rthpos = '2'
                  ELSE
                     LET g_rth[l_ac].rthpos = '1'
                  END IF 
                 #  LET g_rth[l_ac].rthpos = '2'
                 #END IF
                 #FUN-B70075  end----------- 
                 #FUN.B50023 --END--
                 DISPLAY BY NAME g_rth[l_ac].rthpos
             #END IF
             #FUN-B70075  end-----------
           END IF
           #FUN-870100---end
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rth[l_ac].rth02,-263,1)
              LET g_rth[l_ac].* = g_rth_t.*
           ELSE
              UPDATE rth_file SET rth02 = g_rth[l_ac].rth02,
                                  rth03 = g_rth[l_ac].rth03,
                                  rth04 = g_rth[l_ac].rth04,
                                  rth05 = g_rth[l_ac].rth05,
                                  rth06 = g_rth[l_ac].rth06,
                                  rth08 = g_rth[l_ac].rth08, #FUN-C50036 add
                                  rth09 = g_rth[l_ac].rth09, #FUN-C50036 add 
                                  rth07 = g_rth[l_ac].rth07, #FUN-B40103
                                  rthacti = g_rth[l_ac].rthacti,
                                  rthmodu = g_user,
                                  rthdate = g_today,                                                                 
                                  rthpos  = g_rth[l_ac].rthpos      #FUN-A30030 ADD
                 WHERE rth01=g_rth01
                   AND rth02=g_rth_t.rth02 AND rthplant = g_rthplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rth_file",g_rth01,g_rth_t.rth02,SQLCA.sqlcode,"","",1) 
                 LET g_rth[l_ac].* = g_rth_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rth[l_ac].* = g_rth_t.*
            #FUN-D30033--add--str--
            ELSE
               CALL g_rth.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE i122_bcl
              ROLLBACK WORK
              #FUN-B70075 Begin---
              IF p_cmd='u' THEN
                 IF g_aza.aza88 = 'Y' THEN
                    UPDATE rth_file SET rthpos = l_rthpos
                     WHERE rth01 = g_rth01
                       AND rth02 = g_rth[l_ac].rth02
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL cl_err3("upd","rth_file",g_rth01_t,"",SQLCA.sqlcode,"","",1)
                       LET l_lock_sw = "Y"
                    END IF
                    LET g_rth[l_ac].rthpos = l_rthpos
                    DISPLAY BY NAME g_rth[l_ac].rthpos
                 END IF
              END IF
              #FUN-B70075 End-----               
              EXIT INPUT
          END IF
          LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE i122_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rth02) AND l_ac > 1 THEN
              LET g_rth[l_ac].* = g_rth[l_ac-1].*
              LET g_rth[l_ac].rth02 = g_rec_b + 1
              NEXT FIELD rth02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rth02)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe02" 
               LET g_qryparam.arg1 = l_ima.ima25
               LET g_qryparam.default1 = g_rth[l_ac].rth02
               CALL cl_create_qry() RETURNING g_rth[l_ac].rth02
               DISPLAY BY NAME g_rth[l_ac].rth02
               CALL i122_rth02('d')
               NEXT FIELD rth02
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
  
    CLOSE i122_bcl
    COMMIT WORK
    CALL i122_show()
    
END FUNCTION                 
             
FUNCTION i122_r()
DEFINE l_n1 LIKE type_file.num5
DEFINE l_n2 LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rth01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
#   SELECT COUNT(*) INTO l_n1 FROM rth_file
#    WHERE rth01 = g_rth01 AND rthplant = g_rthplant
#      AND rthacti = 'N' AND rthpos = 'Y'
#   SELECT COUNT(*) INTO l_n2 FROM rth_file
#    WHERE rth01 = g_rth01 AND rthplant = g_rthplant
#   IF l_n1 <> l_n2 AND g_aza.aza88 = 'Y' THEN
#      CALL cl_err('','aim-944',0)
#      RETURN
#   END IF
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM rth_file WHERE rth01 = g_rth01 AND rthplant = g_rthplant
      CLEAR FORM
      CALL g_rth.clear()
      OPEN i122_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i122_cs
         CLOSE i122_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i122_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i122_cs
         CLOSE i122_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i122_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i122_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i122_fetch('/')
         END IF
      END IF
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i122_copy()
   DEFINE l_newno     LIKE rth_file.rth01,
          l_oldno     LIKE rth_file.rth01,
          l_cnt       LIKE type_file.num5 
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rth01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_before_input_done = FALSE
   LET l_oldno = g_rth01
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rth01
 
       AFTER FIELD rth01
          IF NOT cl_null(l_newno) THEN 
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(l_newno,"") THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD rth01
             END IF
#FUN-AA0059 ---------------------end-------------------------------                                         
              SELECT COUNT(*) INTO l_cnt FROM rth_file                          
                  WHERE rth01 = l_newno AND rthplant = g_rthplant                                       
              IF l_cnt > 0 THEN                                                 
                 CALL cl_err(l_newno,-239,0)                                    
                  NEXT FIELD rth01                                              
              END IF                 
              LET g_rth01 = l_newno
              CALL i122_rth01('a')                                                                                      
              IF NOT cl_null(g_errno) THEN     
                 CALL cl_err('',g_errno,0)                                  
                 NEXT FIELD rth01                                            
              END IF          
              LET g_rth01 = l_oldno                                                  
           END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rth01)
#FUN-AA0059---------mod------------str-----------------                                     
#                CALL cl_init_qry_var()                                          
#                LET g_qryparam.form = "q_ima01"                                 
#                LET g_qryparam.default1 = g_rth01                           
#                CALL cl_create_qry() RETURNING l_newno 
                 CALL q_sel_ima(FALSE, "q_ima01","",g_rth01,"","","","","",'' ) 
                       RETURNING  l_newno
#FUN-AA0059---------mod------------end-----------------                         
                DISPLAY l_newno TO rth01                 
                NEXT FIELD rth01
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
      DISPLAY BY NAME g_rth01 
      ROLLBACK WORK  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rth_file         
       WHERE rth01=g_rth01 AND rthplant = g_rthplant
       INTO TEMP y
 
   UPDATE y
       SET rth01=l_newno,    
           rthuser=g_user,   
           rthgrup=g_grup,   
           rthmodu=NULL,     
           rthcrat=g_today,  
           #rthpos = 'N',     #FUN-A30030 ADD
           rthpos = '1',     #FUN-B50023
           rthacti='Y'      
 
   INSERT INTO rth_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rth_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET g_rth01 = l_newno
   CALL i122_b()
   #LET g_rth01 = l_oldno  #FUN-C80046
   #CALL i122_show()       #FUN-C80046
 
END FUNCTION
 
FUNCTION i122_bp_refresh()
  DISPLAY ARRAY g_rth TO s_rth.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL i122_show()
END FUNCTION
 
FUNCTION i122_out()                                                     
DEFINE l_cmd  STRING
 
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF     
   LET l_cmd = 'p_query "arti122" "',g_wc CLIPPED,'"'                                                                     
    CALL cl_cmdrun(l_cmd)
 
END FUNCTION
#FUN-870007                                                                             
 
