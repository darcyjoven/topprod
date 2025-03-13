# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: saglt001.4gl
# Descriptions...: 調整與銷除分錄底稿維護作業
# Date & Author..: #FUN-B50001 01/09/21 By zhangweib
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-DA0160 13/10/23 By fengmy 過單據日期,不修改調整年月

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_axi   RECORD LIKE axi_file.*,
    g_aaa   RECORD LIKE aaa_file.*,
    g_aac   RECORD LIKE aac_file.*,
    g_axi01_o  LIKE axi_file.axi01,
    g_axi01_t  LIKE axi_file.axi01,
    g_axi_o RECORD LIKE axi_file.*,
    g_axi_t RECORD LIKE axi_file.*,
    b_axj   RECORD LIKE axj_file.*,
    g_axj   DYNAMIC ARRAY OF RECORD
            axj02    LIKE axj_file.axj02,
            axj03    LIKE axj_file.axj03,
            aag02    LIKE aag_file.aag02,
            axj04    LIKE axj_file.axj04,
            axj05    LIKE axj_file.axj05,
            axj06    LIKE axj_file.axj06,
            axj07    LIKE axj_file.axj07
 	    END RECORD,
    g_axj_t RECORD
            axj02    LIKE axj_file.axj02,
            axj03    LIKE axj_file.axj03,
            aag02    LIKE aag_file.aag02,
            axj04    LIKE axj_file.axj04,
            axj05    LIKE axj_file.axj05,
            axj06    LIKE axj_file.axj06,
            axj07    LIKE axj_file.axj07
 	    END RECORD,
    g_wc,g_wc1,g_sql STRING,        
    g_t1             LIKE aac_file.aac01,     
    g_rec_b          LIKE type_file.num5,         #單身筆數      
    l_ac             LIKE type_file.num5,         #目前處理的ARRAY CNT  
    l_cmd            LIKE type_file.chr1000,  
  
    g_argv1          LIKE axi_file.axi00,         #帐套                          
    g_argv2          LIKE axi_file.axi01,         #凭证编号
    g_argv3          LIKE axi_file.axi04,         #月份                          
    g_argv4          LIKE axi_file.axi21,         #版本号                                            
    l_azn02          LIKE azn_file.azn02,
    l_azn04          LIKE azn_file.azn04,
    g_axz06          LIKE axz_file.axz06,   
    g_before_input_done LIKE type_file.num5,    
    g_forupd_sql        STRING    
 
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5     
DEFINE   g_msg           LIKE type_file.chr1000  
 
DEFINE   g_row_count    LIKE type_file.num10     
DEFINE   g_curs_index   LIKE type_file.num10       
DEFINE   g_jump         LIKE type_file.num10       
DEFINE   mi_no_ask       LIKE type_file.num5      
DEFINE   g_aaw01       LIKE aaw_file.aaw01     
DEFINE   g_dbs_axz03    LIKE type_file.chr21       
DEFINE   g_plant_axz03  LIKE type_file.chr10      
DEFINE   g_axz03        LIKE axz_file.axz03       
DEFINE   g_axz04        LIKE axz_file.axz04      
DEFINE   g_axa09        LIKE axa_file.axa09  
DEFINE   g_newno        LIKE axi_file.axi01        
DEFINE   g_argv00       LIKE type_file.chr1
DEFINE   g_argv01       LIKE type_file.chr1
DEFINE   g_void         LIKE type_file.chr1      #CHI-C80041
 
FUNCTION t001(p_argv00,p_argv01,p_argv1,p_argv2) 
DEFINE p_argv00 LIKE type_file.chr1   #来源   
DEFINE p_argv01 LIKE type_file.chr1   #类型 
DEFINE p_argv1  LIKE axi_file.axi00,  #帳套
       p_argv2  LIKE axi_file.axi01   #单号

   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_forupd_sql = " SELECT * FROM axi_file ",
                      " WHERE axi00 = ? AND axi01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t001_cl CURSOR FROM g_forupd_sql
  
   LET g_argv00= p_argv00
   LET g_argv01= p_argv01 
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
 
   IF NOT cl_null(g_argv00) THEN DISPLAY g_argv00 TO axi08 END IF 
   IF NOT cl_null(g_argv01) THEN DISPLAY g_argv01 TO axi081 END IF 
   IF g_argv00 MATCHES '[34]' THEN CALL cl_set_comp_visible("gb1",FALSE) END IF 
   IF not cl_null(g_argv1) THEN CALL t001_q() END IF
   CALL t001_menu()
END FUNCTION
 
FUNCTION t001_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
    CLEAR FORM
    CALL g_axj.clear()
    IF NOT cl_null(g_argv00) THEN DISPLAY g_argv00 TO axi08 END IF 
    IF NOT cl_null(g_argv01) THEN DISPLAY g_argv01 TO axi081 END IF
    IF g_argv1<>' ' THEN                             
       LET g_wc = " axi00 = '",g_argv1,"' AND axi01 = '",g_argv2,"'"                
       LET g_wc1=" 1=1"
    ELSE
       CALL cl_set_head_visible("","YES")  
 
       INITIALIZE g_axi.* TO NULL  
       CONSTRUCT BY NAME g_wc ON
             axi01,axi02,axi03,axi04,axi05,axi06,axi07,axi10, 
             axi09,axiconf,axi11,axi12,axiuser,axigrup,aximodu,axidate
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(axi01) #單據性質
                   CALL q_aac(TRUE,TRUE,g_axi.axi01,'A','','','AGL') RETURNING g_axi.axi01
                   DISPLAY g_axi.axi01 TO axi01
                   NEXT FIELD axi01
                WHEN INFIELD(axi05) #族群編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_axa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axi05
                   NEXT FIELD axi05
                WHEN INFIELD(axi06)  
                   IF g_axi.axi08 = '1' THEN
                      CALL q_axa4(TRUE,TRUE,g_axi.axi06,g_axi.axi05)
                           RETURNING g_axi.axi06
                      DISPLAY BY NAME g_axi.axi06
                      NEXT FIELD axi06
                   ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_axa2"     
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO axi06
                      NEXT FIELD axi06
                   END IF   
                OTHERWISE EXIT CASE
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
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axiuser', 'axigrup')
       CONSTRUCT g_wc1 ON axj02,axj03,axj04,axj05,axj06,axj07
                     FROM s_axj[1].axj02,s_axj[1].axj03,s_axj[1].axj04,
                          s_axj[1].axj05,s_axj[1].axj06,s_axj[1].axj07
          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(axj03)
                   CALL q_m_aag2(TRUE,TRUE,g_plant_axz03,g_axj[1].axj03,'23',g_aaw01) 
                        RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO axj03 
                   NEXT FIELD axj03
                WHEN INFIELD(axj04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_aad2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axj04
                   NEXT FIELD axj04
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
 
          ON ACTION qbe_save
             CALL cl_qbe_save()
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
 
    IF cl_null(g_wc1) OR g_wc1=" 1=1" THEN
       LET g_sql="SELECT axi01,axi00 FROM axi_file ", # 組合出 SQL 指令
           " WHERE ",g_wc CLIPPED,
           "   AND axi08 = '",g_argv00,"'",
           "   AND axi081 = '",g_argv01,"'",
           " ORDER BY axi01"
    ELSE
       LET g_sql="SELECT DISTINCT axi_file.axi01,axi_file.axi00 ",
           "  FROM axi_file,axj_file ", # 組合出 SQL 指令
           " WHERE axi01=axj01 AND axi00=axj00",
           "   AND axi08 = '",g_argv00,"'",
           "   AND axi081 = '",g_argv01,"'",
           "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
           " ORDER BY axi01"
    END IF
    PREPARE t001_pr FROM g_sql           # RUNTIME 編譯
    DECLARE t001_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t001_pr
 
    IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
       LET g_sql="SELECT COUNT(*) FROM axi_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND axi08 = '",g_argv00,"'",
                 "   AND axi081 = '",g_argv01,"'"
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT axi01) FROM axi_file,axj_file ",
                 " WHERE axi00=axj00 AND axi01=axj01",
                 "   AND axi08 = '",g_argv00,"'",
                 "   AND axi081 = '",g_argv01,"'",
                 " AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
    END IF
    PREPARE t001_precount FROM g_sql                           # row的個數
    DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000  
 
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t001_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t001_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t001_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_z()
            END IF
          WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_axi.axi01 IS NOT NULL THEN
                  LET g_doc.column1 = "axi00"
                  LET g_doc.value1 = g_axi.axi00
                  LET g_doc.column2 = "axi01"
                  LET g_doc.value2 = g_axi.axi01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axj),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t001_v()
               IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
      CLOSE t001_cs
END FUNCTION
 
FUNCTION t001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axi.* TO NULL   
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   IF NOT cl_null(g_argv00) THEN DISPLAY g_argv00 TO axi08 END IF
   IF NOT cl_null(g_argv01) THEN DISPLAY g_argv01 TO axi081 END IF
   CALL t001_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      RETURN 
   END IF
   OPEN t001_count
   FETCH t001_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
      INITIALIZE g_axi.* TO NULL
   ELSE
      CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t001_fetch(p_flaxi)
   DEFINE p_flaxi     LIKE type_file.chr1, 
          l_abso      LIKE type_file.num10   
 
   CASE p_flaxi
       WHEN 'N' FETCH NEXT     t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN 'P' FETCH PREVIOUS t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN 'F' FETCH FIRST    t001_cs INTO g_axi.axi01,g_axi.axi00
       WHEN 'L' FETCH LAST     t001_cs INTO g_axi.axi01,g_axi.axi00
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
           FETCH ABSOLUTE g_jump t001_cs INTO g_axi.axi01,g_axi.axi00
           LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
      INITIALIZE g_axi.* TO NULL  
      RETURN
   ELSE
      CASE p_flaxi
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_axi.* FROM axi_file            # 重讀DB,因TEMP有不被更新特性
    WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","axi_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","",1)
   ELSE
      LET g_data_owner = g_axi.axiuser 
      LET g_data_group = g_axi.axigrup 
      CALL t001_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t001_show()
   DEFINE l_azi02,a,b     LIKE type_file.chr20  
   DEFINE l_nml02         LIKE type_file.chr1000 
   DEFINE l_axa09         LIKE axa_file.axa09  
 
   LET g_axi_t.*=g_axi.* 
   IF g_axi.axi08 = '1' THEN
      CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
   ELSE
      CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
   END IF
   DISPLAY BY NAME 
      g_axi.axi01,g_axi.axi02,g_axi.axi03,g_axi.axi04,g_axi.axi05,
      g_axi.axi06,g_axi.axi07,g_axi.axi09,g_axi.axi08,g_axi.axi081,
      g_axi.axi10,g_axi.axi11,g_axi.axi12,
      g_axi.axiconf,g_axi.axiuser,g_axi.aximodu,
      g_axi.axigrup,g_axi.axidate
   #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
   IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
   SELECT axz06 INTO g_axz06
     FROM axz_file
    WHERE axz01 = g_axi.axi06
   DISPLAY g_axz06 TO FORMONLY.axz06      #單頭
 
   SELECT azi04 INTO t_azi04  
     FROM azi_file
    WHERE azi01 = g_axz06
   IF (NOT cl_null(g_axi.axi05) AND NOT cl_null(g_axi.axi06)) THEN 
       CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03
       CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01 
   END IF
   LET g_t1=s_get_doc_no(g_axi.axi01)     
   CALL t001_b_fill(g_wc1)
   CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION t001_a()           #輸入
DEFINE li_result   LIKE type_file.num5   
DEFINE l_cmd       LIKE type_file.chr1000 
 
   IF s_aglshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_axj.clear()
   INITIALIZE g_axi.* TO NULL
   LET g_axi_t.* = g_axi.*
   LET g_axi.axiconf='N'
   LET g_axi.axi02 = g_today
   LET g_axi.axi09 = 'N'
   LET g_axi.axiuser = g_user
   LET g_axi.axi08 = g_argv00
   LET g_axi.axi081 = g_argv01
   LET g_axi.axioriu = g_user
   LET g_axi.axiorig = g_grup
   LET g_axi.axigrup = g_grup               #使用者所屬群
   LET g_axi.axidate = g_today
   LET g_axi.axi11=0
   LET g_axi.axi12=0
   LET g_axi.axilegal= g_legal 
   CALL cl_opmsg('a')
   WHILE TRUE
      BEGIN WORK
      CALL t001_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0 CALL cl_err('',9001,0)
         INITIALIZE g_axi.* TO NULL EXIT WHILE
      END IF
      IF cl_null(g_axi.axi01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"","axi_file","axi01",g_plant,"2",g_axi.axi00)  
           RETURNING li_result,g_axi.axi01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_axi.axi01
 
      INSERT INTO axi_file VALUES (g_axi.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","axi_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","t001_ins_axi:",1) 
         LET g_success = 'N' RETURN
      END IF
      COMMIT WORK
 
      CALL g_axj.clear()
      LET g_rec_b = 0
      SELECT axi00 INTO g_axi.axi00 FROM axi_file
       WHERE axi01 = g_axi.axi01 AND axi00=g_axi.axi00
      LET g_axi_t.* = g_axi.*
      CALL t001_b()
      MESSAGE ""
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t001_i(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1    
    DEFINE l_n,l_cnt   LIKE type_file.num5  
    DEFINE l_flag      LIKE type_file.chr1    
    DEFINE l_msg       LIKE type_file.chr1000 
    DEFINE g_t1        LIKE aac_file.aac01  
    DEFINE li_result   LIKE type_file.num5  
    DEFINE l_axi02     STRING              
    DEFINE l_i         LIKE type_file.num5   
 
    LET g_axi.axi21 = '00'     #版本,寫死塞入00  
    CALL cl_set_head_visible("","YES")       
 
    INPUT BY NAME
       g_axi.axi01,g_axi.axi02,g_axi.axi03,g_axi.axi04,
       g_axi.axi05,g_axi.axi06,g_axi.axi07,g_axi.axi10,
       g_axi.axi08,g_axi.axi081,g_axi.axi09,g_axi.axi11,g_axi.axi12,
       g_axi.axiconf,g_axi.axiuser,g_axi.aximodu,
       g_axi.axigrup,g_axi.axidate
       WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t001_set_entry(p_cmd)
           CALL t001_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("axi01")

           IF g_axi.axi08 = '1' THEN
              CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           ELSE
              CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           END IF



        AFTER FIELD axi01
           IF NOT cl_null(g_axi.axi01) THEN
              CALL s_check_no("agl",g_axi.axi01,g_axi01_t,"*","axi_file","axi01","") 
                   RETURNING li_result,g_axi.axi01
              DISPLAY BY NAME g_axi.axi01
              IF (NOT li_result) THEN
                  LET g_axi.axi01 = g_axi01_t
                  NEXT FIELD axi01
              END IF
 
        END IF
 
        AFTER FIELD axi02
           IF NOT cl_null(g_axi.axi02) THEN
           #MOD-DA0160----mark----begin
           #  SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
           #   WHERE azn01 = g_axi.axi02
           #  IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN 
           #     CALL cl_err('','agl-022',0) 
           #     NEXT FIELD axi02 
           #  ELSE
           #     LET g_axi.axi03 = l_azn02
           #     LET g_axi.axi04 = l_azn04
           #  END IF
           #  DISPLAY BY NAME g_axi.axi03,g_axi.axi04
           #MOD-DA0160----mark----end
              LET g_axi_o.axi02 = g_axi.axi02
           END IF
           CALL t001_set_entry(p_cmd)  
           CALL t001_set_no_entry(p_cmd) 
 
        AFTER FIELD axi03
           IF g_axi.axi08 = '1' THEN
              LET l_axi02 = g_axi.axi02
              LET l_i = l_axi02.getLength()
              IF (l_axi02.subString(l_i-4,l_i-3)='12' AND
                  l_axi02.subString(l_i-1,l_i)  ='31') THEN
                 IF g_axi.axi03 != l_azn02 AND g_axi.axi03 != l_azn02+1 THEN
                    CALL cl_err_msg("","agl-167",l_azn02 CLIPPED|| "|" || l_azn02+1 CLIPPED,0)
                    NEXT FIELD axi03
                 ELSE
                    IF g_axi.axi03 = l_azn02 THEN
                       LET g_axi.axi04 = 12
                    ELSE
                       LET g_axi.axi04 = 0
                    END IF
                    DISPLAY BY NAME g_axi.axi03,g_axi.axi04
                 END IF
              END IF
           END IF
 
        AFTER FIELD axi04
           IF g_axi.axi08 = '1' THEN
              LET l_axi02 = g_axi.axi02
              LET l_i = l_axi02.getLength()
              IF (l_axi02.subString(l_i-4,l_i-3)='12' AND
                  l_axi02.subString(l_i-1,l_i)  ='31') THEN
                 IF g_axi.axi04 != 0 AND g_axi.axi04 != 12 THEN
                    CALL cl_err('','agl-166',0)
                    NEXT FIELD axi04
                 ELSE
                    IF g_axi.axi04 = 12 THEN
                       LET g_axi.axi03 = l_azn02
                    ELSE
                       LET g_axi.axi03 = l_azn02+1
                    END IF
                    DISPLAY BY NAME g_axi.axi03,g_axi.axi04
                 END IF
              END IF
           END IF

 
        AFTER FIELD axi05   #族群編號
           IF NOT cl_null(g_axi.axi05) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file WHERE axa01=g_axi.axi05
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN
                 LET g_axi.axi05=g_axi_t.axi05
                 CALL cl_err(g_axi.axi05,'agl-223',0) NEXT FIELD axi05
                 NEXT FIELD axi05
              END IF
           ELSE  
              CALL cl_err(g_axi.axi05,'mfg0037',0) 
              NEXT FIELD axi05                 
           END IF
           
        AFTER FIELD axi06   #上層公司
           IF NOT cl_null(g_axi.axi06) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file
                             WHERE axa01=g_axi.axi05
                               AND axa02=g_axi.axi06
              IF SQLCA.sqlcode THEN 
                 LET l_cnt = 0 
              ELSE
                  SELECT axa03 INTO g_axi.axi07
                    FROM axa_file
                   WHERE axa01=g_axi.axi05
                     AND axa02=g_axi.axi06
                  DISPLAY BY NAME g_axi.axi07
              END IF
              IF l_cnt <=0  THEN
                 LET g_axi.axi06=g_axi_t.axi06
                 CALL cl_err(g_axi.axi06,'agl-223',0) NEXT FIELD axi06
                 NEXT FIELD axi06
              END IF
                 CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03  
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01           
                 IF cl_null(g_aaw01) THEN
                    CALL cl_err(g_axz03,'agl-601',1)
                 END IF
                 LET g_axi.axi00 = g_aaw01 
                 SELECT axz06 INTO g_axz06
                   FROM axz_file
                  WHERE axz01 = g_axi.axi06
                 IF cl_null(g_axz06) THEN
                    CALL cl_err(g_axi.axi06,'afa-050',0)
                    NEXT FIELD axi06
                 ELSE 
                    DISPLAY  g_axz06 TO FORMONLY.axz06
                 END IF
           ELSE                                                       
              CALL cl_err(g_axi.axi06,'mfg0037',0)                    
              NEXT FIELD axi06                                        
           END IF 
 
        AFTER FIELD axi09
          IF NOT cl_null(g_axi.axi09) THEN
             IF g_axi.axi09 NOT MATCHES '[YN]' THEN
                NEXT FIELD axi09
             END IF
          END IF
            
        AFTER FIELD axi08
          IF cl_null(g_axi.axi08) THEN NEXT FIELD axi08 END IF
          IF NOT cl_null(g_axi.axi08) THEN
             IF g_axi.axi08 NOT MATCHES '[123]' THEN 
                NEXT FIELD axi08
             END IF
          END IF
          CALL t001_set_entry(p_cmd)
          CALL t001_set_no_entry(p_cmd)
           IF g_axi.axi08 = '1' THEN
              CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           ELSE
              CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("axi06",g_msg CLIPPED)
           END IF
 
        AFTER INPUT
           LET g_axi.axiuser = s_get_data_owner("axi_file") #FUN-C10039
           LET g_axi.axigrup = s_get_data_group("axi_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(axi01) #單據性質
                 CALL q_aac(FALSE,TRUE,g_axi.axi01,'A','','','AGL') RETURNING g_axi.axi01 
                 DISPLAY BY NAME g_axi.axi01
                 NEXT FIELD axi01
              WHEN INFIELD(axi05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING g_axi.axi05
                 DISPLAY BY NAME g_axi.axi05
 
                 SELECT azi04 INTO t_azi04   
                   FROM azi_file
                  WHERE azi01 = g_axz06
 
                 NEXT FIELD axi05
              WHEN INFIELD(axi06)  
                 IF g_axi.axi08 = '1' THEN
                     CALL q_axa4(FALSE,TRUE,g_axi.axi06,g_axi.axi05)
                          RETURNING g_axi.axi06
                     DISPLAY BY NAME g_axi.axi06
                     NEXT FIELD axi06
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axa2"     
                    LET g_qryparam.arg1 = g_axi.axi05
                    CALL cl_create_qry() RETURNING g_axi.axi06,g_axi.axi07
                    DISPLAY BY NAME g_axi.axi06
                    DISPLAY BY NAME g_axi.axi07
                    NEXT FIELD axi06
                 END IF     
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
    END INPUT
END FUNCTION
 
FUNCTION t001_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1  
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("axi01",TRUE)
   END IF
   IF g_axi.axi08 = '1' THEN
      CALL cl_set_comp_entry("axi03,axi04",TRUE)
   END IF
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_axi02   STRING        
   DEFINE l_i       LIKE type_file.num5  
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("axi01",FALSE)
   END IF
   IF g_axi.axi08 = '1' THEN
      LET l_axi02 = g_axi.axi02
      LET l_i = l_axi02.getLength()
      IF NOT (l_axi02.subString(l_i-4,l_i-3)='12' AND
              l_axi02.subString(l_i-1,l_i)  ='31') THEN
         CALL cl_set_comp_entry("axi03,axi04",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT    
    l_row,l_col     LIKE type_file.num5,  	      #分段輸入之行,列數 
    l_n,l_cnt       LIKE type_file.num5,          #檢查重複用   
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否 
    l_exit_sw       LIKE type_file.chr1,          #Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,          #處理狀態  
    l_b2            LIKE abh_file.abh11, 
    l_qty	        LIKE aao_file.aao05,   
    l_flag          LIKE type_file.num10, 
    l_dir           LIKE type_file.chr1, 
    l_jump          LIKE type_file.num5,          #判斷是否跳過AFTER ROW的處理  
    k_n             LIKE type_file.num5, 
    l_allow_insert  LIKE type_file.chr1,          #可新增否  
    l_allow_delete  LIKE type_file.chr1,          #可刪除否 
    l_axa09         LIKE axa_file.axa09           #獨立會科合并  
 
    LET g_action_choice = ""
 
    SELECT * INTO g_axi.* FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
    IF cl_null(g_axi.axi01) THEN RETURN END IF
    IF g_axi.axiconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_axi.axiconf = 'Y' THEN CALL cl_err('','9022',0) RETURN END IF

    CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03 
    CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01    
    SELECT azi04 INTO t_azi04      
      FROM azi_file
     WHERE azi01 = g_axz06

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT * FROM axj_file ",
                       " WHERE axj00=? AND axj01=? AND axj02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql
 
      INPUT ARRAY g_axj WITHOUT DEFAULTS FROM s_axj.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
            OPEN t001_cl USING g_axi.axi00,g_axi.axi01
            FETCH t001_cl INTO g_axi.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
               CLOSE t001_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_axj_t.* = g_axj[l_ac].*  #BACKUP
                OPEN t001_bcl USING g_axi.axi00,g_axi.axi01,g_axj_t.axj02
                IF STATUS THEN
                    CALL cl_err("OPEN t002_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                   FETCH t001_bcl INTO b_axj.*
                   IF cl_null(b_axj.axj05) THEN
                      LET b_axj.axj05 = ' '
                   END IF
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock axj',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL t001_b_move_to()
                   END IF
                END IF
                CALL cl_show_fld_cont() 
            ELSE
                LET p_cmd='a'  #輸入新資料
                INITIALIZE g_axj[l_ac].* TO NULL
                INITIALIZE b_axj.* TO NULL
                CALL cl_show_fld_cont() 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_axj[l_ac].* TO NULL
            LET b_axj.axj01=g_axi.axi01
            INITIALIZE g_axj_t.* TO NULL
            CALL cl_show_fld_cont()
            NEXT FIELD axj02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET g_success = 'Y'
           CALL t001_b_move_back()
           LET b_axj.axj00=g_axi.axi00
           LET b_axj.axjlegal=g_legal
           IF cl_null(b_axj.axj05) THEN
              LET b_axj.axj05 = ' '
           END IF
           INSERT INTO axj_file VALUES(b_axj.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","axj_file",b_axj.axj01,b_axj.axj02,SQLCA.sqlcode,"","ins axj",1)
              CANCEL INSERT
           ELSE
              CALL t001_bu()
              IF g_success='Y' THEN COMMIT WORK
                                    MESSAGE 'INSERT O.K'
                               ELSE ROLLBACK WORK
                                    MESSAGE 'ROLLBACK'
              END IF
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD axj02                            #default 序號
            IF cl_null(g_axj[l_ac].axj02) OR
               g_axj[l_ac].axj02 = 0 THEN
                  SELECT max(axj02)+1 INTO g_axj[l_ac].axj02
                   FROM axj_file WHERE axj01 = g_axi.axi01 AND axj00=g_axi.axi00
                  IF cl_null(g_axj[l_ac].axj02) THEN
                      LET g_axj[l_ac].axj02 = 1
                  END IF
            END IF
 
        AFTER FIELD axj02                        #check 序號是否重複
            IF NOT cl_null(g_axj[l_ac].axj02) THEN
               IF g_axj[l_ac].axj02 != g_axj_t.axj02 THEN
                   SELECT count(*) INTO l_n FROM axj_file
                    WHERE axj00=g_axi.axi00
                      AND axj01=g_axi.axi01
                      AND axj02 = g_axj[l_ac].axj02
                   IF l_n > 0 THEN
                       LET g_axj[l_ac].axj02 = g_axj_t.axj02
                       CALL cl_err('',-239,0) NEXT FIELD axj02
                   END IF
               END IF
            END IF
 
        AFTER FIELD axj03   #科目編號
            IF NOT cl_null(g_axj[l_ac].axj03) THEN
               CALL t001_axj03('a')
               IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_axj[l_ac].axj03,g_errno,0)
                    CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_axj[1].axj03,'23',g_aaw01)
                        RETURNING g_axj[l_ac].axj03 
                     DISPLAY g_axj[l_ac].axj03 TO axj03
                    NEXT FIELD axj03
               END IF
            END IF
 
        AFTER FIELD axj04    #摘要
            IF NOT cl_null(g_axj[l_ac].axj04) THEN
               LET g_msg = g_axj[l_ac].axj04
               IF g_msg[1,1] = '.' THEN
                  LET g_msg = g_msg[2,10]
                  SELECT aad02 INTO g_axj[l_ac].axj04 FROM aad_file
                     WHERE aad01 = g_msg AND aadacti = 'Y'
                   DISPLAY g_axj[l_ac].axj04 TO axj04
                  NEXT FIELD axj04
               END IF
            END IF
 
 
        AFTER FIELD axj06  #借貸方
          IF NOT cl_null(g_axj[l_ac].axj06) THEN
             IF g_axj[l_ac].axj06 NOT MATCHES '[12]' THEN
                 NEXT FIELD axj06
             END IF
          END IF
 
        AFTER FIELD axj07
          LET g_axj[l_ac].axj07 = cl_digcut(g_axj[l_ac].axj07,t_azi04)
 
        BEFORE DELETE                            #是否取消單身
            IF g_axj_t.axj02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM axj_file
                 WHERE axj00 = g_axi.axi00
                   AND axj01 = g_axi.axi01
                   AND axj02 = g_axj_t.axj02
 
                IF SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err3("del","axj_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                CALL t001_bu()
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE t001_bcl
                COMMIT WORK
            END IF
       ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axj[l_ac].* = g_axj_t.*
            CLOSE t001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL t001_b_move_back()
         LET g_success = 'Y'
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axj[l_ac].axj02,-263,1)
            LET g_axj[l_ac].* = g_axj_t.*
         ELSE
            UPDATE axj_file SET axj02 = b_axj.axj02,
                                axj03 = b_axj.axj03,
                                axj04 = b_axj.axj04,
                                axj05 = b_axj.axj05,
                                axj06 = b_axj.axj06,
                                axj07 = b_axj.axj07
                         WHERE axj00=g_axi.axi00
                           AND axj01=g_axi.axi01 AND axj02=g_axj_t.axj02
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","axj_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","upd axj",1)
                           LET g_axj[l_ac].* = g_axj_t.*
                           LET g_success='N'
                        ELSE
                           CALL t001_bu()
                        END IF
             CLOSE t001_bcl
         END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032
          IF INT_FLAG THEN   
             CALL cl_err('',9001,0) LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_axj[l_ac].* = g_axj_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_axj.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE t001_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE t001_bcl
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(axj02) AND l_ac > 1 THEN
                LET g_axj[l_ac].* = g_axj[l_ac-1].*
                LET g_axj[l_ac].axj02 = NULL
                NEXT FIELD axj02
            END IF
            IF INFIELD(axj04) AND l_ac > 1 THEN
               LET g_axj[l_ac].axj04 = g_axj[l_ac-1].axj04
                DISPLAY g_axj[l_ac].axj04 TO axj04
               NEXT FIELD axj04
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(axj03)
                   CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_axj[1].axj03,'23',g_aaw01)
                        RETURNING g_axj[l_ac].axj03 
                   DISPLAY BY NAME g_axj[l_ac].axj03         
                   NEXT FIELD axj03
 
                WHEN INFIELD(axj04)     #查詢常用摘要
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aad2"
                     LET g_qryparam.default1 = g_axj[l_ac].axj04
                     CALL cl_create_qry() RETURNING g_axj[l_ac].axj04
                     DISPLAY BY NAME g_axj[l_ac].axj04
                     NEXT FIELD axj04
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
      END INPUT
 
      LET g_axi.aximodu = g_user
      LET g_axi.axidate = g_today
      UPDATE axi_file SET aximodu = g_axi.aximodu,axidate = g_axi.axidate
       WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
      DISPLAY BY NAME g_axi.aximodu,g_axi.axidate
 
      UPDATE axi_file SET axidate = g_today WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
 
      #-->借貸不平
      IF cl_null(g_axi.axi11) THEN LET g_axi.axi11 = 0 END IF
      IF cl_null(g_axi.axi12) THEN LET g_axi.axi12 = 0 END IF
      IF g_axi.axi11 != g_axi.axi12 THEN
         CALL cl_err('','agl-060',1)
      END IF
      IF g_success='Y' THEN COMMIT WORK
                            MESSAGE 'UPDATE O.K'
                       ELSE ROLLBACK WORK
                            MESSAGE 'ROLLBACK'
      END IF
 
    CLOSE t001_bcl
    CALL t001_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t001_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_axi.axi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM axi_file ",
                  "  WHERE axi01 LIKE '",l_slip,"%' ",
                  "    AND axi01 > '",g_axi.axi01,"'"
      PREPARE t001_pb1 FROM l_sql 
      EXECUTE t001_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t001_v()
         IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
         INITIALIZE g_axi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查科目名稱
FUNCTION t001_axj03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",  
                "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),  
                " WHERE aag01 = '",g_axj[l_ac].axj03,"'",                
                "   AND aag00 = '",g_aaw01,"'"                
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  
    PREPARE t001_pre_1 FROM g_sql
    DECLARE t001_cur_1 CURSOR FOR t001_pre_1
    OPEN t001_cur_1
    FETCH t001_cur_1 INTO l_aag02,l_aag03,l_aag07,l_aagacti
 
    IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
 
    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'     LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    IF g_errno = ' ' OR p_cmd = 'd' THEN
       LET g_axj[l_ac].aag02 = l_aag02
        DISPLAY g_axj[l_ac].aag02 TO aag02
    END IF
END FUNCTION
 
FUNCTION t001_bu()
 
   SELECT SUM(axj07) INTO g_axi.axi11
     FROM axj_file
    WHERE axj01=g_axi.axi01 AND axj00=g_axi.axi00 AND axj06='1'
 
   SELECT SUM(axj07) INTO g_axi.axi12
     FROM axj_file
    WHERE axj01=g_axi.axi01 AND axj00=g_axi.axi00 AND axj06='2'
 
   IF cl_null(g_axi.axi11) THEN LET g_axi.axi11 = 0 END IF
   IF cl_null(g_axi.axi12) THEN LET g_axi.axi12 = 0 END IF
 
   LET g_axi.axi11 = cl_digcut(g_axi.axi11,t_azi04)  
   LET g_axi.axi12 = cl_digcut(g_axi.axi12,t_azi04) 
 
   UPDATE axi_file SET axi11=g_axi.axi11, axi12=g_axi.axi12
    WHERE axi01=g_axi.axi01 AND axi00=g_axi.axi00
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3("upd","axi_file",g_axi.axi01,g_axi.axi00,STATUS,"","upd axi",1) 
      RETURN
   END IF
   DISPLAY BY NAME g_axi.axi11,g_axi.axi12
END FUNCTION
 
FUNCTION t001_baskey()
DEFINE l_wc2    LIKE type_file.chr1000
 
    CONSTRUCT g_wc1 ON axj02,axj03,axj04,axj05,axj06,axj07
                  FROM s_axj[1].axj02,s_axj[1].axj03,s_axj[1].axj04,
                       s_axj[1].axj05,s_axj[1].axj06,s_axj[1].axj07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
    ON ACTION controlp
          CASE
             WHEN INFIELD(axj03)
 
                CALL q_m_aag2(TRUE,TRUE,g_plant_axz03,g_axj[1].axj03,'23',g_aaw01)
                     RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO axj03 
                NEXT FIELD axj03
             WHEN INFIELD(axj04)     #查詢常用摘要
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aad2"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axj04
                NEXT FIELD axj04
 
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
    IF INT_FLAG THEN RETURN END IF
    CALL t001_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t001_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2      LIKE type_file.chr1000 
 
    LET g_sql =
        "SELECT axj02,axj03,'',axj04,axj05,axj06,axj07 ",
        " FROM axj_file ",
        " WHERE axj01 ='",g_axi.axi01,"' ",
        "   AND axj00='",g_axi.axi00,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
 
    PREPARE t001_pb FROM g_sql
    DECLARE axj_curs CURSOR FOR t001_pb
 
    CALL g_axj.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH axj_curs INTO g_axj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'), 
                    " WHERE aag01 = '",g_axj[g_cnt].axj03,"'",                
                    "   AND aag00 = '",g_aaw01,"'"                
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
        PREPARE t001_pre_2 FROM g_sql
        DECLARE t001_cur_2 CURSOR FOR t001_pre_2
        OPEN t001_cur_2
        FETCH t001_cur_2 INTO g_axj[g_cnt].aag02 
        
        IF SQLCA.sqlcode  THEN LET g_axj[g_cnt].aag02 = '' END IF
        IF SQLCA.sqlcode THEN 
           SELECT aag02 INTO g_axj[g_cnt].aag02 FROM aag_file
            WHERE aag01=g_axj[g_cnt].axj03
           IF SQLCA.sqlcode THEN LET g_axj[g_cnt].aag02 = ' ' END IF
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_axj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t001_copy()
   DEFINE l_newno     LIKE axi_file.axi01,
          l_newdate   LIKE axi_file.axi02,
          l_oldno     LIKE axi_file.axi01
   DEFINE l_oldno1    LIKE axi_file.axi00
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_newaxi03  LIKE axi_file.axi03
   DEFINE l_newaxi04  LIKE axi_file.axi04
   DEFINE l_newaxi05  LIKE axi_file.axi05
   DEFINE l_newaxi06  LIKE axi_file.axi06
   DEFINE l_newaxi07  LIKE axi_file.axi07
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_aaw01    LIKE aaw_file.aaw01
   DEFINE l_azn02     LIKE azn_file.azn02
   DEFINE l_azn04     LIKE azn_file.azn04
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF
   IF g_axi.axi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_axi.axi08 <> '1' THEN
      CALL cl_err('','axi-001',0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL t001_set_entry('a')

   CALL cl_set_head_visible("","YES")
   INPUT l_newno,l_newdate,l_newaxi05,l_newaxi06
    FROM axi01,axi02,axi05,axi06

       BEFORE INPUT
          CALL cl_set_docno_format("axi01")

       AFTER FIELD axi01
           IF NOT cl_null(l_newno) THEN
              CALL s_check_no("agl",l_newno,"","*","axi_file","axi01","") 
                   RETURNING li_result,l_newno
              DISPLAY l_newno TO axi01
              IF (NOT li_result) THEN
                  LET l_newno = g_axi01_t
                  NEXT FIELD axi01
              END IF
           END IF
       AFTER FIELD axi02
           IF cl_null(l_newdate) THEN NEXT FIELD axi02 END IF
           IF NOT cl_null(l_newdate) THEN
              SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
                   WHERE azn01 = l_newdate
              IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN
                 CALL cl_err('','agl-022',0)
                 NEXT FIELD axi02
              ELSE LET l_newaxi03 = l_azn02
                   LET l_newaxi04 = l_azn04
              END IF
              DISPLAY l_newaxi03 TO axi03
              DISPLAY l_newaxi04 TO axi04
              LET g_axi_o.axi02 = l_newdate
           END IF
       AFTER FIELD axi05   #族群編號
           IF NOT cl_null(l_newaxi05) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file WHERE axa01=l_newaxi05
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN
                 CALL cl_err(l_newaxi05,'agl-223',0) NEXT FIELD axi05
                 NEXT FIELD axi05
              END IF
           ELSE
              CALL cl_err(l_newaxi05,'mfg0037',0)
              NEXT FIELD axi05
           END IF
       AFTER FIELD axi06   #上層公司
           IF NOT cl_null(l_newaxi06) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(axa_file)
              SELECT COUNT(*) INTO l_cnt FROM axa_file
                             WHERE axa01=l_newaxi05
                               AND axa02=l_newaxi06
              IF SQLCA.sqlcode THEN 
                 LET l_cnt = 0
              ELSE
                  SELECT axa03 INTO l_newaxi07
                    FROM axa_file
                   WHERE axa01=l_newaxi05
                     AND axa02=l_newaxi06
                  DISPLAY l_newaxi07 TO axi07
              END IF
              IF l_cnt <=0  THEN                                    
                 SELECT COUNT(*) INTO l_cnt FROM axb_file
                                WHERE axb01=l_newaxi05
                                  AND axb04=l_newaxi06
                 IF SQLCA.sqlcode THEN
                     LET l_cnt = 0
                 ELSE
                     SELECT axb05 INTO l_newaxi07
                       FROM axb_file
                      WHERE axb01=l_newaxi05
                        AND axb04=l_newaxi06
                     DISPLAY l_newaxi07 TO axi07
                 END IF
                 IF l_cnt <=0 THEN
                    CALL cl_err(l_newaxi06,'agl-223',0) NEXT FIELD axi06
                    NEXT FIELD axi06
                 ELSE
                 END IF  
              END IF  
              CALL s_aaz641_dbs(g_axi.axi05,g_axi.axi06) RETURNING g_dbs_axz03
              CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
                 IF cl_null(g_aaw01) THEN
                    CALL cl_err(g_axz03,'agl-601',1)
                 END IF
                 SELECT axz06 INTO g_axz06
                   FROM axz_file
                  WHERE axz01 = l_newaxi06
                 IF cl_null(g_axz06) THEN
                    CALL cl_err(l_newaxi06,'afa-050',0)
                    NEXT FIELD axi06
                 ELSE
                    DISPLAY  g_axz06 TO FORMONLY.axz06
                 END IF
              BEGIN WORK
              CALL s_auto_assign_no("agl",l_newno,l_newdate,"","axi_file","axi01",g_plant,"2",g_aaw01) 
                        RETURNING li_result,l_newno
              IF (NOT li_result) THEN
                 NEXT FIELD axi01
                 END IF
              DISPLAY l_newno TO axi01
           ELSE
              CALL cl_err(l_newaxi06,'mfg0037',0)
              NEXT FIELD axi06
           END IF
       ON ACTION controlp
          CASE
             WHEN INFIELD(axi01) #單據性質
                 CALL q_aac(FALSE,TRUE,l_newno,'A','','','AGL') RETURNING l_newno
                 DISPLAY l_newno TO axi01
                 NEXT FIELD axi01
             WHEN INFIELD(axi05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_axa1"
                 CALL cl_create_qry() RETURNING l_newaxi05
                 DISPLAY l_newaxi05 TO axi05
                 SELECT azi04 INTO t_azi04
                   FROM azi_file
                  WHERE azi01 = g_axz06
                 NEXT FIELD axi05
             WHEN INFIELD(axi06)
                 IF g_axi.axi08 = '1' THEN
                     CALL q_axa4(FALSE,TRUE,g_axi.axi06,g_axi.axi05)
                          RETURNING g_axi.axi06
                     DISPLAY BY NAME g_axi.axi06
                     NEXT FIELD axi06
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axa2"
                    LET g_qryparam.arg1 = l_newaxi05
                    CALL cl_create_qry() RETURNING l_newaxi06,l_newaxi07
                    DISPLAY l_newaxi06 TO axi06
                    DISPLAY l_newaxi07 TO axi07
                    NEXT FIELD axi06
                 END IF
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_axi.axi01
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y
   SELECT * FROM axi_file         #單頭複製
       WHERE axi01=g_axi.axi01
         AND axi00=g_axi.axi00
       INTO TEMP y

   UPDATE y
       SET axi01=l_newno,    #新的鍵值
           axi00=g_aaw01,   #新的鍵值
           axi02=l_newdate,  #新的鍵值
           axi03=l_newaxi03, #新的鍵值
           axi04=l_newaxi04, #新的鍵值
           axi05=l_newaxi05, #新的鍵值
           axi06=l_newaxi06, #新的鍵值
           axi07=l_newaxi07, #新的鍵值
           axiconf = 'N',
           axiuser=g_user,   #資料所有者
           axigrup=g_grup,   #資料所有者所屬群
           aximodu=NULL,     #資料修改日期
           axidate=g_today   #資料建立日期

   INSERT INTO axi_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axi_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x
   SELECT * FROM axj_file         #單身複製
    WHERE axj01=g_axi.axi01
      AND axj00=g_axi.axi00
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET axj01=l_newno,
                axj00=g_aaw01
   INSERT INTO axj_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axj_file","","",SQLCA.sqlcode,"","",1)    
      ROLLBACK WORK
     # CALL cl_err3("ins","axj_file","","",SQLCA.sqlcode,"","",1)    
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

   LET l_oldno = g_axi.axi01
   LET l_oldno1 = g_axi.axi00
   SELECT axi_file.* INTO g_axi.* FROM axi_file WHERE axi01 = l_newno AND axi00 = g_aaw01
   CALL t001_u()
   CALL t001_b()
   #SELECT axi_file.* INTO g_axi.* FROM axi_file WHERE axi01 = l_oldno AND axi00 = l_oldno1  #FUN-C30027
   #CALL t001_show()  #FUN-C30027

END FUNCTION

 
FUNCTION t001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_axj TO s_axj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont() 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
         IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION first
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY   
 
 
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY    
 
 
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY 
 
 
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY 
 
 
      ON ACTION last
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
 
#@    ON ACTION 相關文件
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t001_b_move_to()
   LET g_axj[l_ac].axj02 = b_axj.axj02
   LET g_axj[l_ac].axj03 = b_axj.axj03
   LET g_axj[l_ac].axj04 = b_axj.axj04
   LET g_axj[l_ac].axj05 = b_axj.axj05
   LET g_axj[l_ac].axj06 = b_axj.axj06
   LET b_axj.axj07 = cl_digcut(b_axj.axj07,t_azi04)
   LET g_axj[l_ac].axj07 = b_axj.axj07
END FUNCTION
 
FUNCTION t001_b_move_back()
   LET b_axj.axj01 = g_axi.axi01
   LET b_axj.axj02 = g_axj[l_ac].axj02
   LET b_axj.axj03 = g_axj[l_ac].axj03
   LET b_axj.axj04 = g_axj[l_ac].axj04
   LET b_axj.axj05 = g_axj[l_ac].axj05
   LET b_axj.axj06 = g_axj[l_ac].axj06
   LET g_axj[l_ac].axj07 = cl_digcut(g_axj[l_ac].axj07,t_azi04)  
   LET b_axj.axj07 = g_axj[l_ac].axj07
END FUNCTION
 
FUNCTION t001_u()
    DEFINE l_flag   LIKE type_file.chr1
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_axi.axi01) THEN CALL cl_err('',-400,2) RETURN END IF
    SELECT * INTO g_axi.* FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
    IF g_axi.axiconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_axi.axiconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
 
    LET g_success = 'Y'
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_axi01_t = g_axi.axi01
    LET g_axi_o.* = g_axi.*
    BEGIN WORK
    OPEN t001_cl USING g_axi.axi00,g_axi.axi01
    FETCH t001_cl INTO g_axi.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    WHILE TRUE
        LET g_axi01_t = g_axi.axi01
        LET g_axi.aximodu=g_user
        LET g_axi.axidate=g_today
        CALL t001_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_axi.*=g_axi_t.*
            CALL t001_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_axi.axi01 != g_axi01_t THEN            # 更改單號
            UPDATE axj_file SET axj01 = g_axi.axi01
                WHERE axj00 = g_axi.axi00
                AND axj01 = g_axi01_t 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","axj_file",g_axi.axi00,"",SQLCA.sqlcode,"","abb",1) 
                CONTINUE WHILE
            END IF
            LET g_errno = TIME
            LET g_msg = 'Chg No:',g_axi.axi01
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
               VALUES('aglt001',g_user,g_today,g_errno,g_axi01_t,g_msg,g_plant,g_legal) 
        END IF
        UPDATE axi_file SET axi_file.* = g_axi.*
            WHERE axi00=g_axi.axi00 AND axi01 = g_axi01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","axi_file",g_axi_t.axi00,g_axi_t.axi01,SQLCA.sqlcode,"","",1) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_r()
    DEFINE k_n      LIKE type_file.num5,  
           l_flag   LIKE type_file.chr1  
    DEFINE l_cnt    LIKE type_file.num5      
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_axi.axi01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_axi.* FROM axi_file WHERE axi00 = g_axi.axi00 AND axi01 = g_axi.axi01
    IF g_axi.axiconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_axi.axiconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t001_cl USING g_axi.axi00,g_axi.axi01
    FETCH t001_cl INTO g_axi.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)
       CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    LET g_axi_o.* = g_axi.*
    LET g_axi_t.* = g_axi.*
    CALL t001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "axi00" 
        LET g_doc.value1 = g_axi.axi00 
        LET g_doc.column2 = "axi01" 
        LET g_doc.value2 = g_axi.axi01  
        CALL cl_del_doc()
       SELECT COUNT(*) INTO k_n FROM axj_file
        WHERE axj01 = g_axi.axi01 AND axj00=g_axi.axi00
       IF k_n > 0 THEN
          DELETE FROM axj_file WHERE axj01 = g_axi.axi01 AND axj00=g_axi.axi00
          IF SQLCA.sqlcode THEN
          CALL cl_err3("del","axj_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","(t001_r:delete axj)",1)
          LET g_success='N'  
          END IF
       END IF
       DELETE FROM axi_file WHERE axi01 = g_axi.axi01 AND axi00=g_axi.axi00
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","axi_file",g_axi.axi01,g_axi.axi00,SQLCA.sqlcode,"","(t001_r:delete axi)",1) 
          LET g_success='N' 
       END IF
       IF g_axi.axi08 = '1' AND g_axi.axi081 = 'U' THEN 
          UPDATE aen_file SET aen10 = ' ' WHERE aen10 = g_axi.axi01 
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","aen_file",g_axi.axi01,'',SQLCA.sqlcode,"","(t001_r:upd aen)",1)
             LET g_success='N'
          END IF 
       END IF
       IF g_axi.axi08 = '2' AND g_axi.axi081 = '2' THEN
          UPDATE axv_file SET axv18=' ' WHERE axv01 = g_axi.axi03
             AND axv02 = g_axi.axi04 AND axv03 = g_axi.axi05
             AND axv031 = g_axi.axi06
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","axv_file",g_axi.axi01,'',SQLCA.sqlcode,"","(t001_r:upd axv)",1)
             LET g_success='N'
          END IF
       END IF 
       INITIALIZE g_axi.* TO NULL
       IF g_success = 'Y' THEN
          COMMIT WORK
          LET g_axi_t.* = g_axi.*
          CALL g_axj.clear()
          OPEN t001_count
          FETCH t001_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN t001_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL t001_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL t001_fetch('/')
          END IF
       ELSE
          ROLLBACK WORK
          LET g_axi.* = g_axi_t.*
       END IF
    END IF
    CALL t001_show()
END FUNCTION
 
FUNCTION t001_y()
   DEFINE l_axi01_old           LIKE axi_file.axi01
   DEFINE only_one              LIKE type_file.chr1 
   DEFINE l_cmd                 LIKE type_file.chr1000
 
   IF s_aglshut(0) THEN RETURN END IF
#CHI-C30107 ---------- add ------------ begin 
   IF cl_null(g_axi.axi01) THEN RETURN END IF
   IF g_axi.axiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_axi.axiconf='Y'    THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ---------- add ------------ end
   IF cl_null(g_axi.axi01) THEN RETURN END IF
   SELECT * INTO g_axi.* FROM axi_file
    WHERE axi00=g_axi.axi00 AND axi01 = g_axi.axi01
   IF g_axi.axiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_axi.axiconf='Y'    THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM axj_file
    WHERE axj00=g_axi.axi00 AND axj01=g_axi.axi01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF cl_confirm('axm-108') THEN  #CHI-C30107 mark
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t001_cl USING g_axi.axi00,g_axi.axi01
      FETCH t001_cl INTO g_axi.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t001_cl ROLLBACK WORK RETURN
      END IF
      IF g_axi.axi09='N' AND (g_axi.axi11<>g_axi.axi12) THEN
         CALL cl_err('','agl-060',1)
         LET g_success='N'
      END IF
      IF g_success = 'Y' THEN
         UPDATE axi_file SET axiconf='Y'
          WHERE axi00=g_axi.axi00 AND axi01=g_axi.axi01
             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("upd","axi_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","upd axi_file",1)
                LET g_success='N'
             END IF
      END IF
 
      CLOSE t001_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      SELECT * INTO g_axi.* FROM axi_file
       WHERE axi00=g_axi.axi00 AND axi01 = g_axi.axi01
      DISPLAY BY NAME g_axi.axiconf
#  END IF  #CHI-C30107 mark
   #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")
   IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION
 
FUNCTION t001_z()
   DEFINE l_axi01_old LIKE axi_file.axi01
   DEFINE only_on     LIKE type_file.chr1
   DEFINE l_amt       LIKE abg_file.abg072
   DEFINE l_cnt       LIKE type_file.num5 
 
   IF s_aglshut(0) THEN RETURN END IF
   IF cl_null(g_axi.axi01) THEN RETURN END IF
   SELECT * INTO g_axi.* FROM axi_file
           WHERE axi01 = g_axi.axi01 AND axi00=g_axi.axi00
   IF g_axi.axiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_axi.axiconf='N' THEN RETURN END IF
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t001_cl USING g_axi.axi00,g_axi.axi01
      FETCH t001_cl INTO g_axi.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t001_cl ROLLBACK WORK RETURN
      END IF
      UPDATE axi_file SET axiconf='N'
       WHERE axi00=g_axi.axi00 AND axi01=g_axi.axi01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","axi_file",g_axi.axi00,g_axi.axi01,SQLCA.sqlcode,"","",1) 
      END IF
      CLOSE t001_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
      CALL cl_cmmsg(1)
      END IF
   END IF
   SELECT * INTO g_axi.* FROM axi_file WHERE axi01=g_axi.axi01
   DISPLAY BY NAME g_axi.axiconf
   #CALL cl_set_field_pic(g_axi.axiconf,"","","","","")  #CHI-C80041
   IF g_axi.axiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_axi.axiconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION
#FUN-B50001
#MOD-BB0262
#CHI-C80041---begin
FUNCTION t001_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_axi.axi01) OR cl_null(g_axi.axi00) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t001_cl USING g_axi.axi00,g_axi.axi01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_axi.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axi.axi01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t001_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_axi.axiconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_axi.axiconf)   THEN 
        LET l_chr=g_axi.axiconf
        IF g_axi.axiconf='N' THEN 
            LET g_axi.axiconf='X' 
        ELSE
            LET g_axi.axiconf='N'
        END IF
        UPDATE axi_file
            SET axiconf=g_axi.axiconf,  
                aximodu=g_user,
                axidate=g_today
            WHERE axi00=g_axi.axi00
              AND axi01=g_axi.axi01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","axi_file",g_axi.axi01,"",SQLCA.sqlcode,"","",1)  
            LET g_axi.axiconf=l_chr 
        END IF
        DISPLAY BY NAME g_axi.axiconf 
   END IF
 
   CLOSE t001_cl
   COMMIT WORK
   CALL cl_flow_notify(g_axi.axi01,'V')
 
END FUNCTION
#CHI-C80041---end
