# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: sgglt100.4gl
# Descriptions...: 調整與銷除分錄底稿維護作業
# Date & Author..: #FUN-B50001 01/09/21 By zhangweib
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: NO.FUN-B90057 11/09/07 By lutingting單頭科目改取族群最上層公司的記帳幣別 
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70040 12/07/05 By lujh 【憑證編號asj01】欄位開窗有帶出單別，選擇後，系統報錯“mfg0014  無此單別”
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 13/01/07 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"          #FUN-BB0036
 
DEFINE
    g_asj   RECORD LIKE asj_file.*,
    g_aaa   RECORD LIKE aaa_file.*,
    g_aac   RECORD LIKE aac_file.*,
    g_asj01_o  LIKE asj_file.asj01,
    g_asj01_t  LIKE asj_file.asj01,
    g_asj_o RECORD LIKE asj_file.*,
    g_asj_t RECORD LIKE asj_file.*,
    b_ask   RECORD LIKE ask_file.*,
    g_ask   DYNAMIC ARRAY OF RECORD
            ask02    LIKE ask_file.ask02,
            ask03    LIKE ask_file.ask03,
            aag02    LIKE aag_file.aag02,
            ask04    LIKE ask_file.ask04,
            ask05    LIKE ask_file.ask05,
            ask06    LIKE ask_file.ask06,
            ask07    LIKE ask_file.ask07
 	    END RECORD,
    g_ask_t RECORD
            ask02    LIKE ask_file.ask02,
            ask03    LIKE ask_file.ask03,
            aag02    LIKE aag_file.aag02,
            ask04    LIKE ask_file.ask04,
            ask05    LIKE ask_file.ask05,
            ask06    LIKE ask_file.ask06,
            ask07    LIKE ask_file.ask07
 	    END RECORD,
    g_wc,g_wc1,g_sql STRING,        
    g_t1             LIKE aac_file.aac01,     
    g_rec_b          LIKE type_file.num5,         #單身筆數      
    l_ac             LIKE type_file.num5,         #目前處理的ARRAY CNT  
    l_cmd            LIKE type_file.chr1000,  
  
    g_argv1          LIKE asj_file.asj00,         #帐套                          
    g_argv2          LIKE asj_file.asj01,         #凭证编号
    g_argv3          LIKE asj_file.asj04,         #月份                          
    g_argv4          LIKE asj_file.asj21,         #版本号                                            
    l_azn02          LIKE azn_file.azn02,
    l_azn04          LIKE azn_file.azn04,
    g_asg06          LIKE asg_file.asg06,   
    g_before_input_done LIKE type_file.num5,    
    g_forupd_sql        STRING    
 
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5     
DEFINE   g_msg           LIKE type_file.chr1000  
 
DEFINE   g_row_count    LIKE type_file.num10     
DEFINE   g_curs_index   LIKE type_file.num10       
DEFINE   g_jump         LIKE type_file.num10       
DEFINE   mi_no_ask       LIKE type_file.num5      
DEFINE   g_asz01       LIKE asz_file.asz01     
DEFINE   g_dbs_asg03    LIKE type_file.chr21       
DEFINE   g_plant_asg03  LIKE type_file.chr10      
DEFINE   g_asg03        LIKE asg_file.asg03       
DEFINE   g_asg04        LIKE asg_file.asg04      
DEFINE   g_asa09        LIKE asa_file.asa09  
DEFINE   g_newno        LIKE asj_file.asj01        
DEFINE   g_argv00       LIKE type_file.chr1
DEFINE   g_argv01       LIKE type_file.chr1
#FUN-B80135--add--str--
DEFINE g_aaa07          LIKE aaa_file.aaa07
DEFINE g_year           LIKE  type_file.chr4
DEFINE g_month          LIKE  type_file.chr2
#FUN-B80135--add--end
DEFINE   g_void         LIKE type_file.chr1      #CHI-C80041
 
FUNCTION t001(p_argv00,p_argv01,p_argv1,p_argv2) 
DEFINE p_argv00 LIKE type_file.chr1   #来源   
DEFINE p_argv01 LIKE type_file.chr1   #类型 
DEFINE p_argv1  LIKE asj_file.asj00,  #帳套
       p_argv2  LIKE asj_file.asj01   #单号

   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_forupd_sql = " SELECT * FROM asj_file ",
                      " WHERE asj00 = ? AND asj01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t001_cl CURSOR FROM g_forupd_sql
  
   LET g_argv00= p_argv00
   LET g_argv01= p_argv01 
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
 
   IF NOT cl_null(g_argv00) THEN DISPLAY g_argv00 TO asj08 END IF 
   IF NOT cl_null(g_argv01) THEN DISPLAY g_argv01 TO asj081 END IF 
   IF g_argv00 MATCHES '[34]' THEN CALL cl_set_comp_visible("gb1",FALSE) END IF 
   IF not cl_null(g_argv1) THEN CALL t001_q() END IF
   CALL t001_menu()
END FUNCTION
 
FUNCTION t001_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
    CLEAR FORM
    CALL g_ask.clear()
    IF NOT cl_null(g_argv00) THEN DISPLAY g_argv00 TO asj08 END IF 
    IF NOT cl_null(g_argv01) THEN DISPLAY g_argv01 TO asj081 END IF
    IF g_argv1<>' ' THEN                             
       LET g_wc = " asj00 = '",g_argv1,"' AND asj01 = '",g_argv2,"'"                
       LET g_wc1=" 1=1"
    ELSE
       CALL cl_set_head_visible("","YES")  
 
       INITIALIZE g_asj.* TO NULL  
       CONSTRUCT BY NAME g_wc ON
             asj01,asj02,asj03,asj04,asj05,asj06,asj07,asj10, 
             asj09,asjconf,asj11,asj12,asjuser,asjgrup,asjmodu,asjdate
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(asj01) #單據性質
                   CALL q_aac(TRUE,TRUE,g_asj.asj01,'A','','','GGL') RETURNING g_asj.asj01
                   DISPLAY g_asj.asj01 TO asj01
                   NEXT FIELD asj01
                WHEN INFIELD(asj05) #族群編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_asa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO asj05
                   NEXT FIELD asj05
                WHEN INFIELD(asj06)  
                   IF g_asj.asj08 = '1' THEN
                      CALL q_asa4(TRUE,TRUE,g_asj.asj06,g_asj.asj05)
                           RETURNING g_asj.asj06
                      DISPLAY BY NAME g_asj.asj06
                      NEXT FIELD asj06
                   ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_asa2"     
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO asj06
                      NEXT FIELD asj06
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('asjuser', 'asjgrup')
       CONSTRUCT g_wc1 ON ask02,ask03,ask04,ask05,ask06,ask07
                     FROM s_ask[1].ask02,s_ask[1].ask03,s_ask[1].ask04,
                          s_ask[1].ask05,s_ask[1].ask06,s_ask[1].ask07
          BEFORE CONSTRUCT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(ask03)
                   CALL q_m_aag2(TRUE,TRUE,g_plant_asg03,g_ask[1].ask03,'23',g_asz01) 
                        RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO ask03 
                   NEXT FIELD ask03
                WHEN INFIELD(ask04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_aad2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ask04
                   NEXT FIELD ask04
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
       LET g_sql="SELECT asj01,asj00 FROM asj_file ", # 組合出 SQL 指令
           " WHERE ",g_wc CLIPPED,
           "   AND asj08 = '",g_argv00,"'",
           "   AND asj081 = '",g_argv01,"'",
           " ORDER BY asj01"
    ELSE
       LET g_sql="SELECT DISTINCT asj_file.asj01,asj_file.asj00 ",
           "  FROM asj_file,ask_file ", # 組合出 SQL 指令
           " WHERE asj01=ask01 AND asj00=ask00",
           "   AND asj08 = '",g_argv00,"'",
           "   AND asj081 = '",g_argv01,"'",
           "   AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
           " ORDER BY asj01"
    END IF
    PREPARE t001_pr FROM g_sql           # RUNTIME 編譯
    DECLARE t001_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t001_pr
 
    IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
       LET g_sql="SELECT COUNT(*) FROM asj_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND asj08 = '",g_argv00,"'",
                 "   AND asj081 = '",g_argv01,"'"
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT asj01) FROM asj_file,ask_file ",
                 " WHERE asj00=ask00 AND asj01=ask01",
                 "   AND asj08 = '",g_argv00,"'",
                 "   AND asj081 = '",g_argv01,"'",
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
               IF g_asj.asj01 IS NOT NULL THEN
                  LET g_doc.column1 = "asj00"
                  LET g_doc.value1 = g_asj.asj00
                  LET g_doc.column2 = "asj01"
                  LET g_doc.value2 = g_asj.asj01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ask),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t100_v()
               IF g_asj.asjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_asj.asjconf,"","","",g_void,"")
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
   INITIALIZE g_asj.* TO NULL   
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   IF NOT cl_null(g_argv00) THEN DISPLAY g_argv00 TO asj08 END IF
   IF NOT cl_null(g_argv01) THEN DISPLAY g_argv01 TO asj081 END IF
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
      CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)
      INITIALIZE g_asj.* TO NULL
   ELSE
      CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t001_fetch(p_flasj)
   DEFINE p_flasj     LIKE type_file.chr1, 
          l_abso      LIKE type_file.num10   
 
   CASE p_flasj
       WHEN 'N' FETCH NEXT     t001_cs INTO g_asj.asj01,g_asj.asj00
       WHEN 'P' FETCH PREVIOUS t001_cs INTO g_asj.asj01,g_asj.asj00
       WHEN 'F' FETCH FIRST    t001_cs INTO g_asj.asj01,g_asj.asj00
       WHEN 'L' FETCH LAST     t001_cs INTO g_asj.asj01,g_asj.asj00
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
           FETCH ABSOLUTE g_jump t001_cs INTO g_asj.asj01,g_asj.asj00
           LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)
      INITIALIZE g_asj.* TO NULL  
      RETURN
   ELSE
      CASE p_flasj
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_asj.* FROM asj_file            # 重讀DB,因TEMP有不被更新特性
    WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","asj_file",g_asj.asj01,g_asj.asj00,SQLCA.sqlcode,"","",1)
   ELSE
      LET g_data_owner = g_asj.asjuser 
      LET g_data_group = g_asj.asjgrup 
      CALL t001_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t001_show()
   DEFINE l_azi02,a,b     LIKE type_file.chr20  
   DEFINE l_nml02         LIKE type_file.chr1000 
   DEFINE l_asa09         LIKE asa_file.asa09  
 
   LET g_asj_t.*=g_asj.* 
   IF g_asj.asj08 = '1' THEN
      CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("asj06",g_msg CLIPPED)
   ELSE
      CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("asj06",g_msg CLIPPED)
   END IF
   DISPLAY BY NAME 
      g_asj.asj01,g_asj.asj02,g_asj.asj03,g_asj.asj04,g_asj.asj05,
      g_asj.asj06,g_asj.asj07,g_asj.asj09,g_asj.asj08,g_asj.asj081,
      g_asj.asj10,g_asj.asj11,g_asj.asj12,
      g_asj.asjconf,g_asj.asjuser,g_asj.asjmodu,
      g_asj.asjgrup,g_asj.asjdate
   #CALL cl_set_field_pic(g_asj.asjconf,"","","","","")  #CHI-C80041
   IF g_asj.asjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_asj.asjconf,"","","",g_void,"")  #CHI-C80041
 
#FUN-B90057--mod--str--
#  SELECT asg06 INTO g_asg06
#    FROM asg_file
#   WHERE asg01 = g_asj.asj06
   SELECT asg06 INTO g_asg06 FROM asg_file,asa_file
    WHERE asg01 = asa02 AND asa04 = 'Y'
      AND asa01 = g_asj.asj05
#FUN-B90057--mod--end
   DISPLAY g_asg06 TO FORMONLY.asg06      #單頭
 
   SELECT azi04 INTO t_azi04  
     FROM azi_file
    WHERE azi01 = g_asg06
   IF (NOT cl_null(g_asj.asj05) AND NOT cl_null(g_asj.asj06)) THEN 
       CALL s_aaz641_asg(g_asj.asj05,g_asj.asj06) RETURNING g_dbs_asg03
       CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01 
   END IF
   LET g_t1=s_get_doc_no(g_asj.asj01)     
   CALL t001_b_fill(g_wc1)
   CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION t001_a()           #輸入
DEFINE li_result   LIKE type_file.num5   
DEFINE l_cmd       LIKE type_file.chr1000 
 
   IF s_aglshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_ask.clear()
   INITIALIZE g_asj.* TO NULL
   LET g_asj_t.* = g_asj.*
   LET g_asj.asjconf='N'
   LET g_asj.asj02 = g_today
   LET g_asj.asj09 = 'N'
   LET g_asj.asjuser = g_user
   LET g_asj.asj08 = g_argv00
   LET g_asj.asj081 = g_argv01
   LET g_asj.asjoriu = g_user
   LET g_asj.asjorig = g_grup
   LET g_asj.asjgrup = g_grup               #使用者所屬群
   LET g_asj.asjdate = g_today
   LET g_asj.asj11=0
   LET g_asj.asj12=0
   LET g_asj.asjlegal= g_legal 
   CALL cl_opmsg('a')
   WHILE TRUE
      BEGIN WORK
      CALL t001_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0 CALL cl_err('',9001,0)
         INITIALIZE g_asj.* TO NULL EXIT WHILE
      END IF
      IF cl_null(g_asj.asj01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
     #CALL s_auto_assign_no("ggl",g_asj.asj01,g_asj.asj02,"","asj_file","asj01",g_plant,"2",g_asj.asj00)    #carrire 20111024
      CALL s_auto_assign_no("AGL",g_asj.asj01,g_asj.asj02,"","asj_file","asj01",g_plant,"2",g_asj.asj00)    #carrire 20111024
           RETURNING li_result,g_asj.asj01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_asj.asj01
 
      INSERT INTO asj_file VALUES (g_asj.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","asj_file",g_asj.asj01,g_asj.asj00,SQLCA.sqlcode,"","t001_ins_asj:",1) 
         LET g_success = 'N' RETURN
      END IF
      COMMIT WORK
 
      CALL g_ask.clear()
      LET g_rec_b = 0
      SELECT asj00 INTO g_asj.asj00 FROM asj_file
       WHERE asj01 = g_asj.asj01 AND asj00=g_asj.asj00
      LET g_asj_t.* = g_asj.*
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
    DEFINE l_asj02     STRING              
    DEFINE l_i         LIKE type_file.num5   
 
    LET g_asj.asj21 = '00'     #版本,寫死塞入00  
    CALL cl_set_head_visible("","YES")       
 
    INPUT BY NAME
       g_asj.asj01,g_asj.asj02,g_asj.asj03,g_asj.asj04,
       g_asj.asj05,g_asj.asj06,g_asj.asj07,g_asj.asj10,
       g_asj.asj08,g_asj.asj081,g_asj.asj09,g_asj.asj11,g_asj.asj12,
       g_asj.asjconf,g_asj.asjuser,g_asj.asjmodu,
       g_asj.asjgrup,g_asj.asjdate
       WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t001_set_entry(p_cmd)
           CALL t001_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("asj01")

           IF g_asj.asj08 = '1' THEN
              CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("asj06",g_msg CLIPPED)
           ELSE
              CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("asj06",g_msg CLIPPED)
           END IF

            #FUN-B80135--add--str--
           SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
            WHERE aaa01 = asz01 AND asz00 = '0'
            LET g_year = YEAR(g_aaa07)
            LET g_month= MONTH(g_aaa07)
           #FUN-B80135--add—end


        AFTER FIELD asj01
           IF NOT cl_null(g_asj.asj01) THEN
              #CALL s_check_no("ggl",g_asj.asj01,g_asj01_t,"*","asj_file","asj01","")    #TQC-C70040   mark
              CALL s_check_no("agl",g_asj.asj01,g_asj01_t,"*","asj_file","asj01","")     #TQC-C70040   add  
                   RETURNING li_result,g_asj.asj01
              DISPLAY BY NAME g_asj.asj01
              IF (NOT li_result) THEN
                  LET g_asj.asj01 = g_asj01_t
                  NEXT FIELD asj01
              END IF
 
        END IF
 
        AFTER FIELD asj02
           IF NOT cl_null(g_asj.asj02) THEN
              SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
               WHERE azn01 = g_asj.asj02
              IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN 
                 CALL cl_err('','agl-022',0) 
                 NEXT FIELD asj02 
              ELSE
                 LET g_asj.asj03 = l_azn02
                 LET g_asj.asj04 = l_azn04
              END IF
              DISPLAY BY NAME g_asj.asj03,g_asj.asj04
              #No.FUN-B80135--add--str--
              IF g_asj.asj03 < g_year THEN
                 CALL cl_err(g_asj.asj03,'atp-164',0)
                 NEXT FIELD asj03
              END IF
              IF g_asj.asj03=g_year AND g_asj.asj04<=g_month THEN
                 CALL cl_err(g_asj.asj04,'atp-164',0)
                 NEXT FIELD asj04
              END IF  
              #No.FUN-B80135--add—end—
              LET g_asj_o.asj02 = g_asj.asj02
           END IF
           CALL t001_set_entry(p_cmd)  
           CALL t001_set_no_entry(p_cmd) 
 
        AFTER FIELD asj03
           IF g_asj.asj08 = '1' THEN
              LET l_asj02 = g_asj.asj02
              LET l_i = l_asj02.getLength()
              IF (l_asj02.subString(l_i-4,l_i-3)='12' AND
                  l_asj02.subString(l_i-1,l_i)  ='31') THEN
                 IF g_asj.asj03 != l_azn02 AND g_asj.asj03 != l_azn02+1 THEN
                    CALL cl_err_msg("","agl-167",l_azn02 CLIPPED|| "|" || l_azn02+1 CLIPPED,0)
                    NEXT FIELD asj03
                 ELSE
                    IF g_asj.asj03 = l_azn02 THEN
                       LET g_asj.asj04 = 12
                    ELSE
                       LET g_asj.asj04 = 0
                    END IF
                    DISPLAY BY NAME g_asj.asj03,g_asj.asj04
                 END IF
              END IF
           END IF
          #No.FUN-B80135--add--str--
          IF NOT cl_null(g_asj.asj03) THEN
             IF g_asj.asj03 < 0 THEN
                CALL cl_err(g_asj.asj03,'apj-035',0)
                NEXT FIELD asj03 
             END IF 
             IF g_asj.asj03 < g_year THEN
                CALL cl_err(g_asj.asj03,'atp-164',0)
                NEXT FIELD asj03
             END IF
             IF g_asj.asj03=g_year AND g_asj.asj04<=g_month THEN
                CALL cl_err(g_asj.asj04,'atp-164',0)
                NEXT FIELD asj04
             END IF
         END IF 
          #No.FUN-B80135--add—end--
 
        AFTER FIELD asj04
           IF g_asj.asj08 = '1' THEN
              LET l_asj02 = g_asj.asj02
              LET l_i = l_asj02.getLength()
              IF (l_asj02.subString(l_i-4,l_i-3)='12' AND
                  l_asj02.subString(l_i-1,l_i)  ='31') THEN
                 IF g_asj.asj04 != 0 AND g_asj.asj04 != 12 THEN
                    CALL cl_err('','agl-166',0)
                    NEXT FIELD asj04
                 ELSE
                    IF g_asj.asj04 = 12 THEN
                       LET g_asj.asj03 = l_azn02
                    ELSE
                       LET g_asj.asj03 = l_azn02+1
                    END IF
                    DISPLAY BY NAME g_asj.asj03,g_asj.asj04
                 END IF
              END IF
           END IF
            #FUN-B80135--add--str--
             IF NOT cl_null(g_asj.asj04) THEN
                SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = g_asi.asi06
                 IF g_azm.azm02 = 1 THEN
                    IF g_asj.asj04 > 12 OR g_asj.asj04 < 1 THEN
                       CALL cl_err('','agl-020',0)
                       NEXT FIELD asj04
                    END IF
                 ELSE
                    IF g_asj.asj04 > 13 OR g_asj.asj04 < 1 THEN
                       CALL cl_err('','agl-020',0)
                       NEXT FIELD asj04
                    END IF
                END IF
                IF NOT cl_null(g_asj.asj03) AND g_asj.asj03=g_year
                   AND g_asj.asj04<=g_month THEN
                   CALL cl_err(g_asj.asj04,'atp-164',0)
                   NEXT FIELD asj04
                END IF
            END IF
            #FUN-B80135--add--end

 
        AFTER FIELD asj05   #族群編號
           IF NOT cl_null(g_asj.asj05) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(asa_file)
              SELECT COUNT(*) INTO l_cnt FROM asa_file WHERE asa01=g_asj.asj05
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN
                 LET g_asj.asj05=g_asj_t.asj05
                 CALL cl_err(g_asj.asj05,'agl-223',0) NEXT FIELD asj05
                 NEXT FIELD asj05
              END IF
             #FUN-B90057--add--str--
              SELECT asg06 INTO g_asg06 FROM asg_file,asa_file
               WHERE asg01 = asa02 AND asa04 = 'Y'
                 AND asa01 = g_asj.asj05
              IF cl_null(g_asg06) THEN
                 CALL cl_err(g_asj.asj05,'afa-050',0)
                 NEXT FIELD asj05
              ELSE
                 DISPLAY  g_asg06 TO FORMONLY.asg06
              END IF
             #FUN-B90057--add--end
           ELSE  
              CALL cl_err(g_asj.asj05,'mfg0037',0) 
              NEXT FIELD asj05                 
           END IF
           
        AFTER FIELD asj06   #上層公司
           IF NOT cl_null(g_asj.asj06) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(asa_file)
              SELECT COUNT(*) INTO l_cnt FROM asa_file
                             WHERE asa01=g_asj.asj05
                               AND asa02=g_asj.asj06
              IF SQLCA.sqlcode THEN 
                 LET l_cnt = 0 
              ELSE
                  SELECT asa03 INTO g_asj.asj07
                    FROM asa_file
                   WHERE asa01=g_asj.asj05
                     AND asa02=g_asj.asj06
                  DISPLAY BY NAME g_asj.asj07
              END IF
              IF l_cnt <=0  THEN
                 LET g_asj.asj06=g_asj_t.asj06
                 CALL cl_err(g_asj.asj06,'agl-223',0) NEXT FIELD asj06
                 NEXT FIELD asj06
              END IF
                 CALL s_aaz641_asg(g_asj.asj05,g_asj.asj06) RETURNING g_dbs_asg03  
                 CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01           
                 IF cl_null(g_asz01) THEN
                    CALL cl_err(g_asg03,'agl-601',1)
                 END IF
                 LET g_asj.asj00 = g_asz01 
#FUN-B90057--mark--str--
#                SELECT asg06 INTO g_asg06
#                  FROM asg_file
#                 WHERE asg01 = g_asj.asj06
#                IF cl_null(g_asg06) THEN
#                   CALL cl_err(g_asj.asj06,'afa-050',0)
#                   NEXT FIELD asj06
#                ELSE 
#                   DISPLAY  g_asg06 TO FORMONLY.asg06
#                END IF
#FUN-B90057--mark--end
           ELSE                                                       
              CALL cl_err(g_asj.asj06,'mfg0037',0)                    
              NEXT FIELD asj06                                        
           END IF 
 
        AFTER FIELD asj09
          IF NOT cl_null(g_asj.asj09) THEN
             IF g_asj.asj09 NOT MATCHES '[YN]' THEN
                NEXT FIELD asj09
             END IF
          END IF
            
        AFTER FIELD asj08
          IF cl_null(g_asj.asj08) THEN NEXT FIELD asj08 END IF
          IF NOT cl_null(g_asj.asj08) THEN
             IF g_asj.asj08 NOT MATCHES '[123]' THEN 
                NEXT FIELD asj08
             END IF
          END IF
          CALL t001_set_entry(p_cmd)
          CALL t001_set_no_entry(p_cmd)
           IF g_asj.asj08 = '1' THEN
              CALL cl_getmsg('agl032',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("asj06",g_msg CLIPPED)
           ELSE
              CALL cl_getmsg('agl033',g_lang) RETURNING g_msg
              CALL cl_set_comp_att_text("asj06",g_msg CLIPPED)
           END IF
 
        AFTER INPUT
           LET g_asj.asjuser = s_get_data_owner("asj_file") #FUN-C10039
           LET g_asj.asjgrup = s_get_data_group("asj_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(asj01) #單據性質
                 CALL q_aac(FALSE,TRUE,g_asj.asj01,'A','','','GGL') RETURNING g_asj.asj01 
                 DISPLAY BY NAME g_asj.asj01
                 NEXT FIELD asj01
              WHEN INFIELD(asj05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asa1"
                 CALL cl_create_qry() RETURNING g_asj.asj05
                 DISPLAY BY NAME g_asj.asj05
 
                 SELECT azi04 INTO t_azi04   
                   FROM azi_file
                  WHERE azi01 = g_asg06
 
                 NEXT FIELD asj05
              WHEN INFIELD(asj06)  
                 IF g_asj.asj08 = '1' THEN
                     CALL q_asa4(FALSE,TRUE,g_asj.asj06,g_asj.asj05)
                          RETURNING g_asj.asj06
                     DISPLAY BY NAME g_asj.asj06
                     NEXT FIELD asj06
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_asa2"     
                    LET g_qryparam.arg1 = g_asj.asj05
                    CALL cl_create_qry() RETURNING g_asj.asj06,g_asj.asj07
                    DISPLAY BY NAME g_asj.asj06
                    DISPLAY BY NAME g_asj.asj07
                    NEXT FIELD asj06
                 END IF     
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLZ
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
      CALL cl_set_comp_entry("asj01",TRUE)
   END IF
   IF g_asj.asj08 = '1' THEN
      CALL cl_set_comp_entry("asj03,asj04",TRUE)
   END IF
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_asj02   STRING        
   DEFINE l_i       LIKE type_file.num5  
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("asj01",FALSE)
   END IF
   IF g_asj.asj08 = '1' THEN
      LET l_asj02 = g_asj.asj02
      LET l_i = l_asj02.getLength()
      IF NOT (l_asj02.subString(l_i-4,l_i-3)='12' AND
              l_asj02.subString(l_i-1,l_i)  ='31') THEN
         CALL cl_set_comp_entry("asj03,asj04",FALSE)
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
    l_asa09         LIKE asa_file.asa09           #獨立會科合并  
 
    LET g_action_choice = ""
 
    SELECT * INTO g_asj.* FROM asj_file WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
    IF cl_null(g_asj.asj01) THEN RETURN END IF
    IF g_asj.asjconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_asj.asjconf = 'Y' THEN CALL cl_err('','9022',0) RETURN END IF

    CALL s_aaz641_asg(g_asj.asj05,g_asj.asj06) RETURNING g_dbs_asg03 
    CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01    
    SELECT azi04 INTO t_azi04      
      FROM azi_file
     WHERE azi01 = g_asg06

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT * FROM ask_file ",
                       " WHERE ask00=? AND ask01=? AND ask02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql
 
      INPUT ARRAY g_ask WITHOUT DEFAULTS FROM s_ask.*
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
            OPEN t001_cl USING g_asj.asj00,g_asj.asj01
            FETCH t001_cl INTO g_asj.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)
               CLOSE t001_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ask_t.* = g_ask[l_ac].*  #BACKUP
                OPEN t001_bcl USING g_asj.asj00,g_asj.asj01,g_ask_t.ask02
                IF STATUS THEN
                    CALL cl_err("OPEN t002_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                   FETCH t001_bcl INTO b_ask.*
                   IF cl_null(b_ask.ask05) THEN
                      LET b_ask.ask05 = ' '
                   END IF
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock ask',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL t001_b_move_to()
                   END IF
                END IF
                CALL cl_show_fld_cont() 
            ELSE
                LET p_cmd='a'  #輸入新資料
                INITIALIZE g_ask[l_ac].* TO NULL
                INITIALIZE b_ask.* TO NULL
                CALL cl_show_fld_cont() 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ask[l_ac].* TO NULL
            LET b_ask.ask01=g_asj.asj01
            INITIALIZE g_ask_t.* TO NULL
            CALL cl_show_fld_cont()
            NEXT FIELD ask02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET g_success = 'Y'
           CALL t001_b_move_back()
           LET b_ask.ask00=g_asj.asj00
           LET b_ask.asklegal=g_legal
           IF cl_null(b_ask.ask05) THEN
              LET b_ask.ask05 = ' '
           END IF
           INSERT INTO ask_file VALUES(b_ask.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ask_file",b_ask.ask01,b_ask.ask02,SQLCA.sqlcode,"","ins ask",1)
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
 
        BEFORE FIELD ask02                            #default 序號
            IF cl_null(g_ask[l_ac].ask02) OR
               g_ask[l_ac].ask02 = 0 THEN
                  SELECT max(ask02)+1 INTO g_ask[l_ac].ask02
                   FROM ask_file WHERE ask01 = g_asj.asj01 AND ask00=g_asj.asj00
                  IF cl_null(g_ask[l_ac].ask02) THEN
                      LET g_ask[l_ac].ask02 = 1
                  END IF
            END IF
 
        AFTER FIELD ask02                        #check 序號是否重複
            IF NOT cl_null(g_ask[l_ac].ask02) THEN
               IF g_ask[l_ac].ask02 != g_ask_t.ask02 THEN
                   SELECT count(*) INTO l_n FROM ask_file
                    WHERE ask00=g_asj.asj00
                      AND ask01=g_asj.asj01
                      AND ask02 = g_ask[l_ac].ask02
                   IF l_n > 0 THEN
                       LET g_ask[l_ac].ask02 = g_ask_t.ask02
                       CALL cl_err('',-239,0) NEXT FIELD ask02
                   END IF
               END IF
            END IF
 
        AFTER FIELD ask03   #科目編號
            IF NOT cl_null(g_ask[l_ac].ask03) THEN
               CALL t001_ask03('a')
               IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ask[l_ac].ask03,g_errno,0)
                    CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_ask[1].ask03,'23',g_asz01)
                        RETURNING g_ask[l_ac].ask03 
                     DISPLAY g_ask[l_ac].ask03 TO ask03
                    NEXT FIELD ask03
               END IF
            END IF
 
        AFTER FIELD ask04    #摘要
            IF NOT cl_null(g_ask[l_ac].ask04) THEN
               LET g_msg = g_ask[l_ac].ask04
               IF g_msg[1,1] = '.' THEN
                  LET g_msg = g_msg[2,10]
                  SELECT aad02 INTO g_ask[l_ac].ask04 FROM aad_file
                     WHERE aad01 = g_msg AND aadacti = 'Y'
                   DISPLAY g_ask[l_ac].ask04 TO ask04
                  NEXT FIELD ask04
               END IF
            END IF
 
 
        AFTER FIELD ask06  #借貸方
          IF NOT cl_null(g_ask[l_ac].ask06) THEN
             IF g_ask[l_ac].ask06 NOT MATCHES '[12]' THEN
                 NEXT FIELD ask06
             END IF
          END IF
 
        AFTER FIELD ask07
          LET g_ask[l_ac].ask07 = cl_digcut(g_ask[l_ac].ask07,t_azi04)
 
        BEFORE DELETE                            #是否取消單身
            IF g_ask_t.ask02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ask_file
                 WHERE ask00 = g_asj.asj00
                   AND ask01 = g_asj.asj01
                   AND ask02 = g_ask_t.ask02
 
                IF SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err3("del","ask_file",g_asj.asj00,g_asj.asj01,SQLCA.sqlcode,"","",1) 
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
            LET g_ask[l_ac].* = g_ask_t.*
            CLOSE t001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL t001_b_move_back()
         LET g_success = 'Y'
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ask[l_ac].ask02,-263,1)
            LET g_ask[l_ac].* = g_ask_t.*
         ELSE
            UPDATE ask_file SET ask02 = b_ask.ask02,
                                ask03 = b_ask.ask03,
                                ask04 = b_ask.ask04,
                                ask05 = b_ask.ask05,
                                ask06 = b_ask.ask06,
                                ask07 = b_ask.ask07
                         WHERE ask00=g_asj.asj00
                           AND ask01=g_asj.asj01 AND ask02=g_ask_t.ask02
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","ask_file",g_asj.asj00,g_asj.asj01,SQLCA.sqlcode,"","upd ask",1)
                           LET g_ask[l_ac].* = g_ask_t.*
                           LET g_success='N'
                        ELSE
                           CALL t001_bu()
                        END IF
             CLOSE t001_bcl
         END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac        #FUN-D30032 Mark
          IF INT_FLAG THEN   
             CALL cl_err('',9001,0) LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_ask[l_ac].* = g_ask_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_ask.deleteElement(l_ac)
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
            IF INFIELD(ask02) AND l_ac > 1 THEN
                LET g_ask[l_ac].* = g_ask[l_ac-1].*
                LET g_ask[l_ac].ask02 = NULL
                NEXT FIELD ask02
            END IF
            IF INFIELD(ask04) AND l_ac > 1 THEN
               LET g_ask[l_ac].ask04 = g_ask[l_ac-1].ask04
                DISPLAY g_ask[l_ac].ask04 TO ask04
               NEXT FIELD ask04
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ask03)
                   CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_ask[1].ask03,'23',g_asz01)
                        RETURNING g_ask[l_ac].ask03 
                   DISPLAY BY NAME g_ask[l_ac].ask03         
                   NEXT FIELD ask03
 
                WHEN INFIELD(ask04)     #查詢常用摘要
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aad2"
                     LET g_qryparam.default1 = g_ask[l_ac].ask04
                     CALL cl_create_qry() RETURNING g_ask[l_ac].ask04
                     DISPLAY BY NAME g_ask[l_ac].ask04
                     NEXT FIELD ask04
           END CASE
 
        ON ACTION CONTROLZ
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
 
      LET g_asj.asjmodu = g_user
      LET g_asj.asjdate = g_today
      UPDATE asj_file SET asjmodu = g_asj.asjmodu,asjdate = g_asj.asjdate
       WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
      DISPLAY BY NAME g_asj.asjmodu,g_asj.asjdate
 
      UPDATE asj_file SET asjdate = g_today WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
 
      #-->借貸不平
      IF cl_null(g_asj.asj11) THEN LET g_asj.asj11 = 0 END IF
      IF cl_null(g_asj.asj12) THEN LET g_asj.asj12 = 0 END IF
      IF g_asj.asj11 != g_asj.asj12 THEN
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
      CALL s_get_doc_no(g_asj.asj01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM asj_file ",
                  "  WHERE asj01 LIKE '",l_slip,"%' ",
                  "    AND asj01 > '",g_asj.asj01,"'"
      PREPARE t100_pb1 FROM l_sql 
      EXECUTE t100_pb1 INTO l_cnt       
      
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
         CALL t100_v()
         IF g_asj.asjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_asj.asjconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM asj_file WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
         INITIALIZE g_asj.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查科目名稱
FUNCTION t001_ask03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",  
                "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),  
                " WHERE aag01 = '",g_ask[l_ac].ask03,"'",                
                "   AND aag00 = '",g_asz01,"'"                
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
       LET g_ask[l_ac].aag02 = l_aag02
        DISPLAY g_ask[l_ac].aag02 TO aag02
    END IF
END FUNCTION
 
FUNCTION t001_bu()
 
   SELECT SUM(ask07) INTO g_asj.asj11
     FROM ask_file
    WHERE ask01=g_asj.asj01 AND ask00=g_asj.asj00 AND ask06='1'
 
   SELECT SUM(ask07) INTO g_asj.asj12
     FROM ask_file
    WHERE ask01=g_asj.asj01 AND ask00=g_asj.asj00 AND ask06='2'
 
   IF cl_null(g_asj.asj11) THEN LET g_asj.asj11 = 0 END IF
   IF cl_null(g_asj.asj12) THEN LET g_asj.asj12 = 0 END IF
 
   LET g_asj.asj11 = cl_digcut(g_asj.asj11,t_azi04)  
   LET g_asj.asj12 = cl_digcut(g_asj.asj12,t_azi04) 
 
   UPDATE asj_file SET asj11=g_asj.asj11, asj12=g_asj.asj12
    WHERE asj01=g_asj.asj01 AND asj00=g_asj.asj00
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3("upd","asj_file",g_asj.asj01,g_asj.asj00,STATUS,"","upd asj",1) 
      RETURN
   END IF
   DISPLAY BY NAME g_asj.asj11,g_asj.asj12
END FUNCTION
 
FUNCTION t001_baskey()
DEFINE l_wc2    LIKE type_file.chr1000
 
    CONSTRUCT g_wc1 ON ask02,ask03,ask04,ask05,ask06,ask07
                  FROM s_ask[1].ask02,s_ask[1].ask03,s_ask[1].ask04,
                       s_ask[1].ask05,s_ask[1].ask06,s_ask[1].ask07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
    ON ACTION controlp
          CASE
             WHEN INFIELD(ask03)
 
                CALL q_m_aag2(TRUE,TRUE,g_plant_asg03,g_ask[1].ask03,'23',g_asz01)
                     RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO ask03 
                NEXT FIELD ask03
             WHEN INFIELD(ask04)     #查詢常用摘要
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aad2"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ask04
                NEXT FIELD ask04
 
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
        "SELECT ask02,ask03,'',ask04,ask05,ask06,ask07 ",
        " FROM ask_file ",
        " WHERE ask01 ='",g_asj.asj01,"' ",
        "   AND ask00='",g_asj.asj00,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
 
    PREPARE t001_pb FROM g_sql
    DECLARE ask_curs CURSOR FOR t001_pb
 
    CALL g_ask.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ask_curs INTO g_ask[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'), 
                    " WHERE aag01 = '",g_ask[g_cnt].ask03,"'",                
                    "   AND aag00 = '",g_asz01,"'"                
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
        PREPARE t001_pre_2 FROM g_sql
        DECLARE t001_cur_2 CURSOR FOR t001_pre_2
        OPEN t001_cur_2
        FETCH t001_cur_2 INTO g_ask[g_cnt].aag02 
        
        IF SQLCA.sqlcode  THEN LET g_ask[g_cnt].aag02 = '' END IF
        IF SQLCA.sqlcode THEN 
           SELECT aag02 INTO g_ask[g_cnt].aag02 FROM aag_file
            WHERE aag01=g_ask[g_cnt].ask03
           IF SQLCA.sqlcode THEN LET g_ask[g_cnt].aag02 = ' ' END IF
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ask.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t001_copy()
   DEFINE l_newno     LIKE asj_file.asj01,
          l_newdate   LIKE asj_file.asj02,
          l_oldno     LIKE asj_file.asj01
   DEFINE l_oldno1    LIKE asj_file.asj00
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_newasj03  LIKE asj_file.asj03
   DEFINE l_newasj04  LIKE asj_file.asj04
   DEFINE l_newasj05  LIKE asj_file.asj05
   DEFINE l_newasj06  LIKE asj_file.asj06
   DEFINE l_newasj07  LIKE asj_file.asj07
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_asz01    LIKE asz_file.asz01
   DEFINE l_azn02     LIKE azn_file.azn02
   DEFINE l_azn04     LIKE azn_file.azn04
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF
   IF g_asj.asj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_asj.asj08 <> '1' THEN
      CALL cl_err('','asj-001',0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL t001_set_entry('a')

   CALL cl_set_head_visible("","YES")
   INPUT l_newno,l_newdate,l_newasj05,l_newasj06
    FROM asj01,asj02,asj05,asj06

       BEFORE INPUT
          CALL cl_set_docno_format("asj01")

       AFTER FIELD asj01
           IF NOT cl_null(l_newno) THEN
              #CALL s_check_no("ggl",l_newno,"","*","asj_file","asj01","")    #TQC-C70040  mark
              CALL s_check_no("agl",l_newno,"","*","asj_file","asj01","")     #TQC-C70040  add
                   RETURNING li_result,l_newno
              DISPLAY l_newno TO asj01
              IF (NOT li_result) THEN
                  LET l_newno = g_asj01_t
                  NEXT FIELD asj01
              END IF
           END IF
       AFTER FIELD asj02
           IF cl_null(l_newdate) THEN NEXT FIELD asj02 END IF
           IF NOT cl_null(l_newdate) THEN
              SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
                   WHERE azn01 = l_newdate
              IF SQLCA.sqlcode  OR l_azn02 = 0 OR l_azn02 IS NULL THEN
                 CALL cl_err('','agl-022',0)
                 NEXT FIELD asj02
              ELSE LET l_newasj03 = l_azn02
                   LET l_newasj04 = l_azn04
              END IF
              DISPLAY l_newasj03 TO asj03
              DISPLAY l_newasj04 TO asj04
              LET g_asj_o.asj02 = l_newdate
           END IF
       AFTER FIELD asj05   #族群編號
           IF NOT cl_null(l_newasj05) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(asa_file)
              SELECT COUNT(*) INTO l_cnt FROM asa_file WHERE asa01=l_newasj05
              IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
              IF l_cnt <=0  THEN
                 CALL cl_err(l_newasj05,'agl-223',0) NEXT FIELD asj05
                 NEXT FIELD asj05
              END IF
             #FUN-B90057--add-str--
              SELECT asg06 INTO g_asg06 FROM asg_file,asa_file
               WHERE asg01 = asa02 AND asa04 = 'Y'
                 AND asa01 = l_newasj05
              IF cl_null(g_asg06) THEN
                 CALL cl_err(l_newasj05,'afa-050',0)
                 NEXT FIELD asj05
              ELSE
                 DISPLAY  g_asg06 TO FORMONLY.asg06
              END IF
             #FUN-B90057--add--end
           ELSE
              CALL cl_err(l_newasj05,'mfg0037',0)
              NEXT FIELD asj05
           END IF
           
       AFTER FIELD asj06   #上層公司
           IF NOT cl_null(l_newasj06) THEN
              #-->檢查是否存在聯屬公司層級單頭檔(asa_file)
              SELECT COUNT(*) INTO l_cnt FROM asa_file
                             WHERE asa01=l_newasj05
                               AND asa02=l_newasj06
              IF SQLCA.sqlcode THEN 
                 LET l_cnt = 0
              ELSE
                  SELECT asa03 INTO l_newasj07
                    FROM asa_file
                   WHERE asa01=l_newasj05
                     AND asa02=l_newasj06
                  DISPLAY l_newasj07 TO asj07
              END IF
              IF l_cnt <=0  THEN                                    
                 SELECT COUNT(*) INTO l_cnt FROM asb_file
                                WHERE asb01=l_newasj05
                                  AND asb04=l_newasj06
                 IF SQLCA.sqlcode THEN
                     LET l_cnt = 0
                 ELSE
                     SELECT asb05 INTO l_newasj07
                       FROM asb_file
                      WHERE asb01=l_newasj05
                        AND asb04=l_newasj06
                     DISPLAY l_newasj07 TO asj07
                 END IF
                 IF l_cnt <=0 THEN
                    CALL cl_err(l_newasj06,'agl-223',0) NEXT FIELD asj06
                    NEXT FIELD asj06
                 ELSE
                 END IF  
              END IF  
              CALL s_aaz641_asg(g_asj.asj05,g_asj.asj06) RETURNING g_dbs_asg03
              CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
                 IF cl_null(g_asz01) THEN
                    CALL cl_err(g_asg03,'agl-601',1)
                 END IF
                #FUN-B90057---MARK--STR--
                #SELECT asg06 INTO g_asg06
                #  FROM asg_file
                # WHERE asg01 = l_newasj06
                #IF cl_null(g_asg06) THEN
                #   CALL cl_err(l_newasj06,'afa-050',0)
                #   NEXT FIELD asj06
                #ELSE
                #   DISPLAY  g_asg06 TO FORMONLY.asg06
                #END IF
                #FUN-B90057--mark--end
              BEGIN WORK
             #CALL s_auto_assign_no("ggl",l_newno,l_newdate,"","asj_file","asj01",g_plant,"2",g_asz01)   #carrier 20111024
              CALL s_auto_assign_no("AGL",l_newno,l_newdate,"","asj_file","asj01",g_plant,"2",g_asz01)   #carrier 20111024
                        RETURNING li_result,l_newno
              IF (NOT li_result) THEN
                 NEXT FIELD asj01
                 END IF
              DISPLAY l_newno TO asj01
           ELSE
              CALL cl_err(l_newasj06,'mfg0037',0)
              NEXT FIELD asj06
           END IF
       ON ACTION controlp
          CASE
             WHEN INFIELD(asj01) #單據性質
                 CALL q_aac(FALSE,TRUE,l_newno,'A','','','GGL') RETURNING l_newno
                 DISPLAY l_newno TO asj01
                 NEXT FIELD asj01
             WHEN INFIELD(asj05) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asa1"
                 CALL cl_create_qry() RETURNING l_newasj05
                 DISPLAY l_newasj05 TO asj05
                 SELECT azi04 INTO t_azi04
                   FROM azi_file
                  WHERE azi01 = g_asg06
                 NEXT FIELD asj05
             WHEN INFIELD(asj06)
                 IF g_asj.asj08 = '1' THEN
                     CALL q_asa4(FALSE,TRUE,g_asj.asj06,g_asj.asj05)
                          RETURNING g_asj.asj06
                     DISPLAY BY NAME g_asj.asj06
                     NEXT FIELD asj06
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_asa2"
                    LET g_qryparam.arg1 = l_newasj05
                    CALL cl_create_qry() RETURNING l_newasj06,l_newasj07
                    DISPLAY l_newasj06 TO asj06
                    DISPLAY l_newasj07 TO asj07
                    NEXT FIELD asj06
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
      DISPLAY BY NAME g_asj.asj01
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y
   SELECT * FROM asj_file         #單頭複製
       WHERE asj01=g_asj.asj01
         AND asj00=g_asj.asj00
       INTO TEMP y

   UPDATE y
       SET asj01=l_newno,    #新的鍵值
           asj00=g_asz01,   #新的鍵值
           asj02=l_newdate,  #新的鍵值
           asj03=l_newasj03, #新的鍵值
           asj04=l_newasj04, #新的鍵值
           asj05=l_newasj05, #新的鍵值
           asj06=l_newasj06, #新的鍵值
           asj07=l_newasj07, #新的鍵值
           asjconf = 'N',
           asjuser=g_user,   #資料所有者
           asjgrup=g_grup,   #資料所有者所屬群
           asjmodu=NULL,     #資料修改日期
           asjdate=g_today   #資料建立日期

   INSERT INTO asj_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","asj_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x
   SELECT * FROM ask_file         #單身複製
    WHERE ask01=g_asj.asj01
      AND ask00=g_asj.asj00
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET ask01=l_newno,
                ask00=g_asz01
   INSERT INTO ask_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ask_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

   LET l_oldno = g_asj.asj01
   LET l_oldno1 = g_asj.asj00
   SELECT asj_file.* INTO g_asj.* FROM asj_file WHERE asj01 = l_newno AND asj00 = g_asz01
   CALL t001_u()
   CALL t001_b()
   #SELECT asj_file.* INTO g_asj.* FROM asj_file WHERE asj01 = l_oldno AND asj00 = l_oldno1  #FUN-C80046
   #CALL t001_show()   #FUN-C80046

END FUNCTION

 
FUNCTION t001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ask TO s_ask.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         #CALL cl_set_field_pic(g_asj.asjconf,"","","","","")  #CHI-C80041
         IF g_asj.asjconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_asj.asjconf,"","","",g_void,"")  #CHI-C80041
 
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
   LET g_ask[l_ac].ask02 = b_ask.ask02
   LET g_ask[l_ac].ask03 = b_ask.ask03
   LET g_ask[l_ac].ask04 = b_ask.ask04
   LET g_ask[l_ac].ask05 = b_ask.ask05
   LET g_ask[l_ac].ask06 = b_ask.ask06
   LET b_ask.ask07 = cl_digcut(b_ask.ask07,t_azi04)
   LET g_ask[l_ac].ask07 = b_ask.ask07
END FUNCTION
 
FUNCTION t001_b_move_back()
   LET b_ask.ask01 = g_asj.asj01
   LET b_ask.ask02 = g_ask[l_ac].ask02
   LET b_ask.ask03 = g_ask[l_ac].ask03
   LET b_ask.ask04 = g_ask[l_ac].ask04
   LET b_ask.ask05 = g_ask[l_ac].ask05
   LET b_ask.ask06 = g_ask[l_ac].ask06
   LET g_ask[l_ac].ask07 = cl_digcut(g_ask[l_ac].ask07,t_azi04)  
   LET b_ask.ask07 = g_ask[l_ac].ask07
END FUNCTION
 
FUNCTION t001_u()
    DEFINE l_flag   LIKE type_file.chr1
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_asj.asj01) THEN CALL cl_err('',-400,2) RETURN END IF
    SELECT * INTO g_asj.* FROM asj_file WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
    IF g_asj.asjconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
    IF g_asj.asjconf = 'X' THEN RETURN END IF  #CHI-C80041
    LET g_success = 'Y'
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_asj01_t = g_asj.asj01
    LET g_asj_o.* = g_asj.*
    BEGIN WORK
    OPEN t001_cl USING g_asj.asj00,g_asj.asj01
    FETCH t001_cl INTO g_asj.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    CALL t001_show()
    WHILE TRUE
        LET g_asj01_t = g_asj.asj01
        LET g_asj.asjmodu=g_user
        LET g_asj.asjdate=g_today
        CALL t001_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_asj.*=g_asj_t.*
            CALL t001_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_asj.asj01 != g_asj01_t THEN            # 更改單號
            UPDATE ask_file SET ask01 = g_asj.asj01
                WHERE ask00 = g_asj.asj00
                AND ask01 = g_asj01_t 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ask_file",g_asj.asj00,"",SQLCA.sqlcode,"","abb",1) 
                CONTINUE WHILE
            END IF
            LET g_errno = TIME
            LET g_msg = 'Chg No:',g_asj.asj01
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
               VALUES('gglt100',g_user,g_today,g_errno,g_asj01_t,g_msg,g_plant,g_legal) 
        END IF
        UPDATE asj_file SET asj_file.* = g_asj.*
            WHERE asj00=g_asj.asj00 AND asj01 = g_asj01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","asj_file",g_asj_t.asj00,g_asj_t.asj01,SQLCA.sqlcode,"","",1) 
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
    IF cl_null(g_asj.asj01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_asj.* FROM asj_file WHERE asj00 = g_asj.asj00 AND asj01 = g_asj.asj01
    IF g_asj.asjconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF
    IF g_asj.asjconf = 'X' THEN RETURN END IF  #CHI-C80041
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t001_cl USING g_asj.asj00,g_asj.asj01
    FETCH t001_cl INTO g_asj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)
       CLOSE t001_cl ROLLBACK WORK RETURN
    END IF
    LET g_asj_o.* = g_asj.*
    LET g_asj_t.* = g_asj.*
    CALL t001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "asj00" 
        LET g_doc.value1 = g_asj.asj00 
        LET g_doc.column2 = "asj01" 
        LET g_doc.value2 = g_asj.asj01  
        CALL cl_del_doc()
       SELECT COUNT(*) INTO k_n FROM ask_file
        WHERE ask01 = g_asj.asj01 AND ask00=g_asj.asj00
       IF k_n > 0 THEN
          DELETE FROM ask_file WHERE ask01 = g_asj.asj01 AND ask00=g_asj.asj00
          IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ask_file",g_asj.asj01,g_asj.asj00,SQLCA.sqlcode,"","(t001_r:delete ask)",1)
          LET g_success='N'  
          END IF
       END IF
       DELETE FROM asj_file WHERE asj01 = g_asj.asj01 AND asj00=g_asj.asj00
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","asj_file",g_asj.asj01,g_asj.asj00,SQLCA.sqlcode,"","(t001_r:delete asj)",1) 
          LET g_success='N' 
       END IF
       IF g_asj.asj08 = '1' AND g_asj.asj081 = 'U' THEN 
          UPDATE aso_file SET aso10 = ' ' WHERE aso10 = g_asj.asj01 
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","aso_file",g_asj.asj01,'',SQLCA.sqlcode,"","(t001_r:upd aso)",1)
             LET g_success='N'
          END IF 
       END IF
       IF g_asj.asj08 = '2' AND g_asj.asj081 = '2' THEN
          UPDATE asw_file SET asw18=' ' WHERE asw01 = g_asj.asj03
             AND asw02 = g_asj.asj04 AND asw03 = g_asj.asj05
             AND asw031 = g_asj.asj06
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","asw_file",g_asj.asj01,'',SQLCA.sqlcode,"","(t001_r:upd asw)",1)
             LET g_success='N'
          END IF
       END IF 
       INITIALIZE g_asj.* TO NULL
       IF g_success = 'Y' THEN
          COMMIT WORK
          LET g_asj_t.* = g_asj.*
          CALL g_ask.clear()
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
          LET g_asj.* = g_asj_t.*
       END IF
    END IF
    CALL t001_show()
END FUNCTION
 
FUNCTION t001_y()
   DEFINE l_asj01_old           LIKE asj_file.asj01
   DEFINE only_one              LIKE type_file.chr1 
   DEFINE l_cmd                 LIKE type_file.chr1000
 
   IF s_aglshut(0) THEN RETURN END IF
   IF cl_null(g_asj.asj01) THEN RETURN END IF
#CHI-C30107 ------------- add --------------- begin
   IF g_asj.asjconf='Y'    THEN RETURN END IF
   IF g_asj.asjconf = 'X' THEN RETURN END IF  #CHI-C80041
   SELECT COUNT(*) INTO g_cnt FROM ask_file
    WHERE ask00=g_asj.asj00 AND ask01=g_asj.asj01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('atp-108') THEN RETURN END IF
#CHI-C30107 ------------- add --------------- end
   SELECT * INTO g_asj.* FROM asj_file
    WHERE asj00=g_asj.asj00 AND asj01 = g_asj.asj01
   IF g_asj.asjconf='Y'    THEN RETURN END IF
   IF g_asj.asjconf = 'X' THEN RETURN END IF  #CHI-C80041
   SELECT COUNT(*) INTO g_cnt FROM ask_file
    WHERE ask00=g_asj.asj00 AND ask01=g_asj.asj01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF cl_confirm('atp-108') THEN #CHI-C30107 mark
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t001_cl USING g_asj.asj00,g_asj.asj01
      FETCH t001_cl INTO g_asj.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t001_cl ROLLBACK WORK RETURN
      END IF
      IF g_asj.asj09='N' AND (g_asj.asj11<>g_asj.asj12) THEN
         CALL cl_err('','agl-060',1)
         LET g_success='N'
      END IF
      IF g_success = 'Y' THEN
         UPDATE asj_file SET asjconf='Y'
          WHERE asj00=g_asj.asj00 AND asj01=g_asj.asj01
             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("upd","asj_file",g_asj.asj00,g_asj.asj01,SQLCA.sqlcode,"","upd asj_file",1)
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
 
      SELECT * INTO g_asj.* FROM asj_file
       WHERE asj00=g_asj.asj00 AND asj01 = g_asj.asj01
      DISPLAY BY NAME g_asj.asjconf
#  END IF #CHI-C30107 mark
   CALL cl_set_field_pic(g_asj.asjconf,"","","","","")
END FUNCTION
 
FUNCTION t001_z()
   DEFINE l_asj01_old LIKE asj_file.asj01
   DEFINE only_on     LIKE type_file.chr1
   DEFINE l_amt       LIKE abg_file.abg072
   DEFINE l_cnt       LIKE type_file.num5 
 
   IF s_aglshut(0) THEN RETURN END IF
   IF cl_null(g_asj.asj01) THEN RETURN END IF
   SELECT * INTO g_asj.* FROM asj_file
           WHERE asj01 = g_asj.asj01 AND asj00=g_asj.asj00
   IF g_asj.asjconf='N' THEN RETURN END IF
   IF g_asj.asjconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN t001_cl USING g_asj.asj00,g_asj.asj01
      FETCH t001_cl INTO g_asj.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t001_cl ROLLBACK WORK RETURN
      END IF
      UPDATE asj_file SET asjconf='N'
       WHERE asj00=g_asj.asj00 AND asj01=g_asj.asj01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","asj_file",g_asj.asj00,g_asj.asj01,SQLCA.sqlcode,"","",1) 
      END IF
      CLOSE t001_cl
      IF g_success='N' THEN
         ROLLBACK WORK RETURN
      ELSE
         COMMIT WORK
      CALL cl_cmmsg(1)
      END IF
   END IF
   SELECT * INTO g_asj.* FROM asj_file WHERE asj01=g_asj.asj01
   DISPLAY BY NAME g_asj.asjconf
   CALL cl_set_field_pic(g_asj.asjconf,"","","","","")
END FUNCTION
#FUN-B50001

#CHI-C80041---begin
FUNCTION t100_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_asj.asj01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t001_cl USING g_asj.asj00,g_asj.asj01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_asj.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asj.asj01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t001_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_asj.asjconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_asj.asjconf)   THEN 
        LET l_chr=g_asj.asjconf
        IF g_asj.asjconf='N' THEN 
            LET g_asj.asjconf='X' 
        ELSE
            LET g_asj.asjconf='N'
        END IF
        UPDATE asj_file
            SET asjconf=g_asj.asjconf,  
                asjmodu=g_user,
                asjdate=g_today
            WHERE asj00=g_asj.asj00
              AND asj01=g_asj.asj01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","asj_file",g_asj.asj01,"",SQLCA.sqlcode,"","",1)  
            LET g_asj.asjconf=l_chr 
        END IF
        DISPLAY BY NAME g_asj.asjconf
   END IF
 
   CLOSE t001_cl
   COMMIT WORK
   CALL cl_flow_notify(g_asj.asj01,'V')
 
END FUNCTION
#CHI-C80041---end
