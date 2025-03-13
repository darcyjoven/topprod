# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armt300.4gl
# Descriptions...: RMA 倉盤點維護作業  (armt300) 
# Date & Author..: 98/02/05 By ALAN 
# Modify.........: 98/04/14 BY PLUM
# Modify.........: NO.FUN-550064 05/05/24 BY Trisy 單據編號加大
# Modify.........: NO.FUN-560014 05/06/09 By jackie 單據編號修改
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/24 By TSD.Wind 自定功能欄位修改
# Modify.........: No.FUN-870163 08/07/31 By sherry 預設申請數量=原異動數量
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun ina_file新增字段賦值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.TQC-AC0040 10/12/14 By destiny  rmh14管控
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:FUN-910088 11/12/22 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-CB0087 12/12/20 By xujing 倉庫單據理由碼改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_rmh        RECORD LIKE rmh_file.*,     #Table Value
   g_rmh_t      RECORD LIKE rmh_file.*,     #Old Table Value
   g_rmh01_t    LIKE        rmh_file.rmh01, #Old Key Value
   g_rmh02_t    LIKE        rmh_file.rmh02, #Old Key Value
   g_rmh03_t    LIKE        rmh_file.rmh03, #Old Key Value
   g_rmh04_t    LIKE        rmh_file.rmh04, #Old Key Value
   g_rmh05_t    LIKE        rmh_file.rmh05, #Old Key Value
    g_wc,g_sql   string,   #No.FUN-580092 HCN
   tm             RECORD
      year     LIKE type_file.num5,    #No.FUN-690010 SMALLINT,        #年度
      mm       LIKE type_file.num5,    #No.FUN-690010 SMALLINT,        #月份
      sdate    LIKE type_file.dat,     #No.FUN-690010 DATE,            #單據日期
      bcnt     LIKE type_file.num5,    #No.FUN-690010 SMALLINT,        #單身筆數
      w1       LIKE inb_file.inb05,    #RMA倉庫
      no1      LIKE rmz_file.rmz07,    #No.FUN-690010 VARCHAR(5),         #發料單單別No.FUN-550064    
      no2      LIKE rmz_file.rmz08     #No.FUN-690010 VARCHAR(5)          #收料單單別No.FUN-550064    
      END RECORD
  
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING     
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1	LIKE oea_file.oea01 #No.FUN-690010 VARCHAR(16)            #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
MAIN
DEFINE
   l_time           LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
   p_row,p_col      LIKE type_file.num5    #No.FUN-690010 SMALLINT
   
   OPTIONS
       INPUT NO WRAP
       DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
   LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
   LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 
   INITIALIZE g_rmh.* TO NULL
   LET g_forupd_sql = "SELECT * FROM rmh_file WHERE rmh01 = ? AND rmh02 = ? AND rmh03 = ? AND rmh04 = ? AND rmh05 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t300_cl CURSOR FROM g_forupd_sql   #Lock Cursor
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW t300_w AT p_row,p_col
      WITH FORM "arm/42f/armt300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    #No.FUN-4A0081 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t300_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
              IF cl_chk_act_auth() THEN
                CALL t300_a()
              END IF
          OTHERWISE 
                CALL t300_q()
       END CASE
    END IF
    #No.FUN-4A0081 ---end---
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL t300_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
   CLOSE WINDOW t300_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t300_cs()
   WHILE TRUE
     CLEAR FORM
  IF cl_null(g_argv1) THEN   #FUN-4A0081
     INITIALIZE g_rmh.* TO NULL      #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON
         rmh01,rmh02,rmh03,rmh08,rmh04,rmh07,rmh09,rmh14,rmh15,rmh11,rmh12,
         rmh13,
         #FUN-840068   ---start---
         rmhud01,rmhud02,rmhud03,rmhud04,rmhud05,
         rmhud06,rmhud07,rmhud08,rmhud09,rmhud10,
         rmhud11,rmhud12,rmhud13,rmhud14,rmhud15
         #FUN-840068    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(rmh03)
#               CALL q_ima(6,3,g_rmh.rmh03)
#                    RETURNING g_rmh.rmh03
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()                                         
#                LET g_qryparam.form = "q_ima"                                  
#                LET g_qryparam.state= "c"                                  
#                LET g_qryparam.default1 = g_rmh.rmh03                          
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_rmh.rmh03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO rmh03
                NEXT FIELD rmh03
             WHEN INFIELD(rmh14)
#               CALL q_gen(6,3,g_rmh.rmh14)
#                  RETURNING g_rmh.rmh14
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form = "q_gen"                                  
                LET g_qryparam.state= "c"                                  
                LET g_qryparam.default1 = g_rmh.rmh14                          
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rmh14
                NEXT FIELD rmh14
          OTHERWISE
             EXIT CASE
          END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
     IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
  #FUN-4A0081
  ELSE
      LET g_wc =" rmh01 = '",g_argv1,"'"    #No.FUN-4A0081
  END IF
  #--
     EXIT WHILE
   END WHILE
   LET g_sql = "SELECT rmh01,rmh02,rmh03,rmh04,rmh05 FROM rmh_file",
      " WHERE ",g_wc CLIPPED," ORDER BY rmh01,rmh02,rmh03,rmh04,rmh05"
 
   PREPARE t300_prepare FROM g_sql
   DECLARE t300_cs
      SCROLL CURSOR WITH HOLD FOR t300_prepare
 
   LET g_sql = "SELECT COUNT(*) FROM rmh_file WHERE ",g_wc CLIPPED
   PREPARE t300_precount FROM g_sql
   DECLARE t300_count CURSOR FOR t300_precount
END FUNCTION
 
FUNCTION t300_menu()    
   MENU ""
 
       BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION access 
           LET g_action_choice="access"
           IF cl_chk_act_auth() THEN
              CALL t300_g() 
           END IF
 
        ON ACTION query 
             LET g_action_choice="query"
             IF cl_chk_act_auth() THEN
                CALL t300_q() 
             END IF
 
        ON ACTION next 
             CALL t300_fetch('N')
 
        ON ACTION previous 
             CALL t300_fetch('P')
 
        ON ACTION register 
            LET g_action_choice="register"
            IF cl_chk_act_auth() THEN
               CALL t300_u() 
            END IF
 
        ON ACTION carry 
             LET g_action_choice="carry"
             IF cl_chk_act_auth() THEN
                CALL t300_t() 
             END IF
 
        ON ACTION help 
           CALL cl_show_help()      
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL t300_fetch('/')
 
        ON ACTION first
           CALL t300_fetch('F')
 
        ON ACTION last
           CALL t300_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0018-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_rmh.rmh01 IS NOT NULL THEN            
                  LET g_doc.column1 = "rmh01"               
                  LET g_doc.column2 = "rmh02" 
                  LET g_doc.column3 = "rmh03"
                  LET g_doc.column4 = "rmh04"  
                  LET g_doc.column5 = "rmh05" 
                  LET g_doc.value1 = g_rmh.rmh01            
                  LET g_doc.value2 = g_rmh.rmh02
                  LET g_doc.value3 = g_rmh.rmh03
                  LET g_doc.value4 = g_rmh.rmh04
                  LET g_doc.value5 = g_rmh.rmh05
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0018-------add--------end----
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
   #CLOSE t300_cs
END FUNCTION
 
 
FUNCTION t300_a()
   MESSAGE ""
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   CLEAR FORM
   CALL cl_opmsg('a')
 
   INITIALIZE g_rmh.* LIKE rmh_file.*
   LET g_rmh01_t = NULL
   LET g_rmh02_t = NULL
   LET g_rmh03_t = NULL
   LET g_rmh_t.*=g_rmh.*
   WHILE TRUE
      CALL t300_i('a')
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err("",9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF cl_null(g_rmh.rmh03) THEN
         CONTINUE WHILE
      END IF
      LET g_rmh.rmhplant = g_plant #FUN-980007
      LET g_rmh.rmhlegal = g_legal #FUN-980007
 
      INSERT INTO rmh_file VALUES(g_rmh.*)
      IF SQLCA.SQLCODE THEN
   #      CALL cl_err('Insert:',SQLCA.SQLCODE, 0) #FUN-660111
         CALL cl_err3("ins","rmh_file",g_rmh.rmh01,g_rmh.rmh02,SQLCA.sqlcode,"","Insert:",1) #FUN-660111
         CONTINUE WHILE
      END IF
      LET g_rmh_t.* = g_rmh.*
      SELECT rmh01,rmh02,rmh03,rmh04,rmh05 INTO g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh04,g_rmh.rmh05 FROM rmh_file
         WHERE rmh01 = g_rmh.rmh01 AND rmh02 = g_rmh.rmh02
           AND rmh03 = g_rmh.rmh03
      CALL cl_flow_notify(g_rmh.rmh01,'A')
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t300_i(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,                 #i:insert,u:update  #No.FUN-690010 VARCHAR(1)
   l_n        LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   DISPLAY BY NAME
      g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh08,g_rmh.rmh04,
      g_rmh.rmh05,g_rmh.rmh06,g_rmh.rmh07,g_rmh.rmh09,g_rmh.rmh10,
      g_rmh.rmh14,g_rmh.rmh15,g_rmh.rmh11,g_rmh.rmh12,g_rmh.rmh13
 
   INPUT BY NAME
      g_rmh.rmh09,g_rmh.rmh14, 
      #FUN-840068     ---start---
      g_rmh.rmhud01,g_rmh.rmhud02,g_rmh.rmhud03,g_rmh.rmhud04,
      g_rmh.rmhud05,g_rmh.rmhud06,g_rmh.rmhud07,g_rmh.rmhud08,
      g_rmh.rmhud09,g_rmh.rmhud10,g_rmh.rmhud11,g_rmh.rmhud12,
      g_rmh.rmhud13,g_rmh.rmhud14,g_rmh.rmhud15 
      #FUN-840068     ----end----
   WITHOUT DEFAULTS 
 
   BEFORE INPUT                                                            
      LET g_before_input_done = FALSE                                     
      CALL t300_set_entry(p_cmd)                                          
      CALL t300_set_no_entry(p_cmd)                                       
      LET g_before_input_done = TRUE      
 
   AFTER FIELD rmh09
      IF cl_null(g_rmh.rmh09) OR g_rmh.rmh09 <0 THEN
         NEXT FIELD rmh09
      END IF
      LET g_rmh.rmh09 = s_digqty(g_rmh.rmh09,g_rmh.rmh08)   #FUN-910088--add--
      DISPLAY BY NAME g_rmh.rmh09                           #FUN-910088--add--
      LET g_rmh.rmh10= g_rmh.rmh07-g_rmh.rmh09
      DISPLAY BY NAME g_rmh.rmh10 
      
   AFTER FIELD rmh14
      IF NOT cl_null(g_rmh.rmh14) THEN 
        #IF g_rmh_t.rmh14 != g_rmh.rmh14 OR g_rmh_t.rmh14 IS NULL THEN  #TQC-AC0040
            CALL t300_rmh03('d')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD rmh14 
            END IF
        #END IF  #TQC-AC0040
      END IF
 
   #FUN-840068     ---start---
   AFTER FIELD rmhud01
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud02
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud03
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud04
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud05
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud06
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud07
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud08
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud09
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud10
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud11
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud12
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud13
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud14
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   AFTER FIELD rmhud15
      IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
   #FUN-840068     ----end----
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(rmh03)
#           CALL q_ima(6,3,g_rmh.rmh03)
#                RETURNING g_rmh.rmh03
#           CALL FGL_DIALOG_SETBUFFER( g_rmh.rmh03 )
#FUN-AA0059---------mod------------str-----------------
#            CALL cl_init_qry_var()                                         
#            LET g_qryparam.form = "q_ima"                                  
#            LET g_qryparam.default1 = g_rmh.rmh03                          
#            CALL cl_create_qry() RETURNING g_rmh.rmh03 
            CALL q_sel_ima(FALSE, "q_ima","",g_rmh.rmh03,"","","","","",'' ) 
                 RETURNING  g_rmh.rmh03
#FUN-AA0059---------mod------------end-----------------      
#            CALL FGL_DIALOG_SETBUFFER( g_rmh.rmh03 )
            DISPLAY BY NAME g_rmh.rmh03 
            NEXT FIELD rmh03
         WHEN INFIELD(rmh14)
#           CALL q_gen(6,3,g_rmh.rmh14)
#              RETURNING g_rmh.rmh14
#           CALL FGL_DIALOG_SETBUFFER( g_rmh.rmh14 )
            CALL cl_init_qry_var()                                         
            LET g_qryparam.form = "q_gen"                                  
            LET g_qryparam.default1 = g_rmh.rmh14                          
            CALL cl_create_qry() RETURNING g_rmh.rmh14   
#            CALL FGL_DIALOG_SETBUFFER( g_rmh.rmh14 )
            DISPLAY BY NAME g_rmh.rmh14 
            NEXT FIELD rmh14
      OTHERWISE
         EXIT CASE
      END CASE
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
END FUNCTION
 
FUNCTION t300_rmh03(p_cmd)
DEFINE
   p_cmd       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
   l_ima02     LIKE ima_file.ima02,
   l_gen02     LIKE gen_file.gen02,
   l_gen03     LIKE gen_file.gen03,
   l_gen04     LIKE gen_file.gen04,
   l_genacti   LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,gen03,gen04,genacti
      INTO l_gen02,l_gen03,l_gen04,l_genacti
      FROM gen_file
      WHERE gen01=g_rmh.rmh14
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'arm-100'
      WHEN l_genacti = 'N'
         LET g_errno = '9027'
   END CASE
 
   SELECT ima02 INTO l_ima02
      FROM ima_file
      WHERE ima01=g_rmh.rmh03
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'arm-100'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_ima02,l_gen02 TO ima02,gen02 
   END IF
END FUNCTION
 
FUNCTION t300_g()
DEFINE
   l_n   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
   l_ans LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
   l_gen02 like gen_file.gen02
     
     CLEAR FORM
     MESSAGE ""
     IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
     INITIALIZE g_rmh.* TO NULL
     SELECT * INTO g_rmz.* FROM rmz_file 
     LET g_rmh.rmh15=g_today        #盤點日期預設為system date
     LET g_rmh.rmh04=g_rmz.rmz01    #倉庫
 
     DISPLAY BY NAME 
        g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh04,g_rmh.rmh14,g_rmh.rmh15
 
     INPUT BY NAME                          #Input 資料年度及月份及盤點日期    
        g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh14,g_rmh.rmh15
        WITHOUT DEFAULTS  
     
     AFTER FIELD rmh02
        IF NOT cl_null(g_rmh.rmh02) THEN 
           SELECT COUNT(*) INTO l_n FROM rmh_file
            WHERE rmh01=g_rmh.rmh01 AND rmh02=g_rmh.rmh02
              AND rmh12 IS NOT NULL
           IF l_n>=1 THEN
              CALL cl_err('','arm-030',0)
              NEXT FIELD rmh01
           END IF
           SELECT COUNT(*) INTO l_n FROM rmh_file
           WHERE rmh01=g_rmh.rmh01 AND rmh02=g_rmh.rmh02
             AND rmh12 IS NULL
           IF l_n>=1 THEN
              IF NOT cl_conf3(0,0,'arm-031') THEN NEXT FIELD rmh01 END IF
           END IF
        END IF
 
     AFTER FIELD rmh14
        IF NOT cl_null(g_rmh.rmh14) THEN 
           SELECT gen02 INTO l_gen02 FROM gen_file
            WHERE gen01 = g_rmh.rmh14 AND genacti = 'Y'
           IF STATUS THEN
              NEXT FIELD rmh14
           ELSE
              DISPLAY l_gen02 TO gen02
           END IF
        END IF
        
     AFTER INPUT 
        IF INT_FLAG THEN EXIT INPUT END IF
 
   ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
   ON ACTION CONTROLG
       CALL cl_cmdask()
    
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(rmh14)
#           CALL q_gen(6,3,g_rmh.rmh14)
#              RETURNING g_rmh.rmh14
#           CALL FGL_DIALOG_SETBUFFER( g_rmh.rmh14 )
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.default1 = g_rmh.rmh14
            CALL cl_create_qry() RETURNING g_rmh.rmh14
#            CALL FGL_DIALOG_SETBUFFER( g_rmh.rmh14 )
            DISPLAY BY NAME g_rmh.rmh14 
            NEXT FIELD rmh14
         OTHERWISE  EXIT CASE
      END CASE
 
    ON ACTION CONTROLF        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT 
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rmh.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    IF NOT cl_confirm('abx-080') THEN RETURN END IF
    DECLARE t300g_cs CURSOR FOR
       SELECT imk01,imk02,imk03,imk04,imk09,ima25,imk09
         FROM imk_file,ima_file
         WHERE imk01=ima01       AND imk02=g_rmz.rmz01 AND
               imk05=g_rmh.rmh01 AND imk06=g_rmh.rmh02 
         # AND ima137='Y'
    BEGIN WORK
    DELETE FROM rmh_file
        WHERE rmh01 = g_rmh.rmh01 AND rmh02 = g_rmh.rmh02
    LET g_rmh.rmh10=0
    LET g_rmh.rmh14=g_user
    LET l_n=0
    FOREACH t300g_cs into g_rmh.rmh03,g_rmh.rmh04,g_rmh.rmh05,
           g_rmh.rmh06,g_rmh.rmh07,g_rmh.rmh08,g_rmh.rmh09
        LET g_rmh.rmhplant = g_plant #FUN-980007
        LET g_rmh.rmhlegal = g_legal #FUN-980007
        LET g_rmh.rmh07 = s_digqty(g_rmh.rmh07,g_rmh.rmh08)   #FUN-910088--add--
        LET g_rmh.rmh09 = s_digqty(g_rmh.rmh09,g_rmh.rmh08)   #FUN-910088--add--
        INSERT INTO rmh_file VALUES(g_rmh.*)
        IF STATUS THEN EXIT FOREACH END IF
        LET l_n=l_n+1
    END FOREACH
    IF l_n = 0 THEN 
        CALL cl_err('','aap-129',0)
        CLEAR FORM RETURN END IF
    IF SQLCA.SQLCODE = 0 THEN
       COMMIT WORK
        CALL cl_err('','arm-032',0)
    ELSE 
       ROLLBACK WORK
       CALL cl_err('','arm-033',1)
    END IF
    CLOSE t300g_cs
    CLEAR FORM
    MESSAGE ""
END FUNCTION
 
FUNCTION t300_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_rmh.* TO NULL       #No.FUN-6A0018
   CALL cl_opmsg('q')
   MESSAGE " "
   DISPLAY ' ' TO cnt  
 
   CALL t300_cs()
   IF INT_FLAG THEN 
      LET INT_FLAG=0 
      CLEAR FROM 
      RETURN 
   END IF
   
   OPEN t300_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('Query:',SQLCA.sqlcode,0)
      INITIALIZE g_rmh.* TO NULL
   ELSE
      OPEN t300_count
      FETCH t300_count INTO g_row_count
      DISPLAY g_row_count TO cnt  
      CALL t300_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t300_u()
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rmh.* FROM rmh_file WHERE rmh01 = g_rmh.rmh01 AND rmh02 = g_rmh.rmh02 AND rmh03 = g_rmh.rmh03 AND rmh04 = g_rmh.rmh04 AND rmh05 = g_rmh.rmh05
   IF cl_null(g_rmh.rmh01) OR cl_null(g_rmh.rmh02) OR
      cl_null(g_rmh.rmh03) THEN  
      CALL cl_err('Update:',-400, 0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rmh01_t = g_rmh.rmh01
   LET g_rmh02_t = g_rmh.rmh02
   LET g_rmh03_t = g_rmh.rmh03
   LET g_rmh03_t = g_rmh.rmh03
   LET g_rmh03_t = g_rmh.rmh03
   LET g_rmh_t.* = g_rmh.*
 
   BEGIN WORK
   OPEN t300_cl USING g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh04,g_rmh.rmh05
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_rmh.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err('Lock:',SQLCA.SQLCODE,0)
      ROLLBACK WORK
      RETURN
   END IF
   CALL t300_show()
 
   WHILE TRUE
      CALL t300_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rmh.*=g_rmh_t.*
         CALL t300_show()
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF
      UPDATE rmh_file SET rmh_file.* = g_rmh.*
         WHERE rmh01 = g_rmh.rmh01 AND rmh02 = g_rmh.rmh02 AND rmh03 = g_rmh.rmh03 AND rmh04 = g_rmh.rmh04 AND rmh05 = g_rmh.rmh05
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
  #       CALL cl_err('Update:','9050',0) # FUN-660111
       CALL cl_err3("upd","rmh_file",g_rmh_t.rmh01,g_rmh_t.rmh02,9050,"","Update",1) #FUN-660111
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t300_cl
   COMMIT WORK 
   CALL cl_flow_notify(g_rmh.rmh01,'U')
 
END FUNCTION
 
FUNCTION t300_t()
   DEFINE l_n    LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   OPEN WINDOW t300t_w AT 8,26
      WITH FORM "arm/42f/armt300_t"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("armt300_t")
 
  WHILE TRUE
   INITIALIZE tm.* TO NULL
   LET tm.bcnt = g_rmz.rmz12
   LET tm.w1   = g_rmz.rmz01
   LET tm.sdate = g_today
   LET tm.no1 = g_rmz.rmz07
   LET tm.no2 = g_rmz.rmz08
   LET g_success="Y"
 
   DISPLAY BY NAME tm.year,tm.mm,tm.sdate,tm.bcnt,tm.w1,tm.no1,tm.no2
 
   INPUT BY NAME tm.year,tm.mm,tm.sdate,tm.bcnt WITHOUT DEFAULTS 
 
      AFTER FIELD mm           #月份
         IF NOT cl_null(tm.mm) THEN 
            SELECT COUNT(*) INTO l_n FROM rmh_file
             WHERE rmh01=tm.year AND rmh02=tm.mm
            IF l_n =0 THEN
               CALL cl_err('','aap-129',1)
               LET g_success="N"
               EXIT INPUT
            ELSE
               SELECT COUNT(*) INTO l_n FROM rmh_file
               WHERE rmh01=tm.year AND rmh02=tm.mm AND rmh11 IS NOT NULL
               IF l_n >=1 THEN
                  CALL cl_err('','afa-388',1)
                  LET g_success="N"
                  EXIT INPUT
               END IF
            END IF
            SELECT MAX(rmh15) INTO tm.sdate FROM rmh_file 
               WHERE rmh01=tm.year AND rmh02=tm.mm AND rmh11 IS NULL
            DISPLAY BY NAME tm.sdate 
         END IF
 
      AFTER FIELD bcnt       #單身筆數
         IF tm.bcnt<1 THEN NEXT FIELD bcnt END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.year) THEN NEXT FIELD year END IF
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
         IF cl_null(tm.bcnt) THEN NEXT FIELD bcnt END IF
         IF tm.bcnt<1 THEN NEXT FIELD bcnt END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success="N"
   END IF
   EXIT WHILE
  END WHILE
  IF g_success="Y" THEN 
     IF cl_sure(19,20) THEN 
        CALL t300_t1()
     END IF
  END IF
  CLOSE WINDOW t300t_w
  MESSAGE ""
END FUNCTION
 
FUNCTION t300_t1()   #carry作業: ina,inb 
DEFINE li_result   LIKE type_file.num5          #No.FUN-550064   #No.FUN-690010 SMALLINT
DEFINE
   l_ina          RECORD LIKE ina_file.*,
   l_inb          RECORD LIKE inb_file.*,
   l_n            LIKE type_file.num5,    #No.FUN-690010 SMALLINT
   l_cnt          LIKE type_file.num5,    #No.FUN-690010 SMALLINT
   l_moredata     LIKE type_file.num5     #No.FUN-690010 SMALLINT
DEFINE l_inb930   LIKE inb_file.inb930 #FUN-680006
DEFINE l_inbi    RECORD LIKE inbi_file.*  #FUN-B70074 add
DEFINE l_ina10   LIKE ina_file.ina10          #FUN-CB0087 xj
DEFINE l_ina11   LIKE ina_file.ina11          #FUN-CB0087 xj
 
   LET g_sql = "SELECT rmh_file.*",
               " FROM rmh_file ",
               " WHERE rmh01=",tm.year," AND rmh02 =",tm.mm,
               " AND rmh11 IS NULL AND rmh10 <> 0 "
 
   LET g_success = "Y"
   INITIALIZE l_ina.* TO NULL
   INITIALIZE l_inb.* TO NULL
   PREPARE t300t_prepare FROM g_sql
   DECLARE t300t_cs CURSOR WITH HOLD 
      FOR t300t_prepare 
   BEGIN WORK
   OPEN t300t_cs
   FETCH NEXT t300t_cs INTO g_rmh.*
   IF STATUS THEN LET l_moredata = 0 ELSE LET l_moredata = 1 END IF
   WHILE l_moredata
      IF g_rmh.rmh10 >0 THEN      #發料單
         LET l_ina.ina00="1"
         LET l_ina.ina01=tm.no1
      END IF
      IF g_rmh.rmh10 <0 THEN      #收料單
         LET l_ina.ina00="3"
         LET l_ina.ina01=tm.no2
      END IF
      #No.FUN-550064 --start--                                                                                                      
        CALL s_auto_assign_no("aim",l_ina.ina01,tm.sdate,l_ina.ina00,"ina_file","ina01","","","")   #No.FUN-560014 
        RETURNING li_result,l_ina.ina01                                                  
      IF (NOT li_result) THEN                                                                                                       
#     CALL s_smyauno(l_ina.ina01,tm.sdate)
#        RETURNING g_i, l_ina.ina01
#     IF g_i THEN
       #No.FUN-550064 ---end---   
         LET g_success="N"
         CALL cl_err('','asf-377',0)
         EXIT WHILE
      END IF
      LET l_ina.ina02 = tm.sdate
      LET l_ina.ina03 = g_today
      LET l_ina.ina04 = g_rmz.rmz13
      LET l_ina.ina06 = NULL
      LET l_ina.ina07 = 'RMA倉非Key Part料單'
      LET l_ina.inaprsw = 0
      LET l_ina.inapost = 'N'
      LET l_ina.inauser = g_user
      LET g_data_plant = g_plant #FUN-980030
      LET l_ina.inagrup = g_grup
      LET l_ina.inaplant = g_plant #FUN-980007
      LET l_ina.inalegal = g_legal #FUN-980007
      LET l_ina.ina12 = 'N' #No.FUN-870007
      LET l_ina.inapos= 'N' #No.FUN-870007
 
      LET l_ina.inaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_ina.inaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ina_file VALUES(l_ina.*)
      IF STATUS THEN
         LET g_success = "N"
         EXIT WHILE #insert 失敗離開迴圈
      END IF
      LET l_inb930=s_costcenter(l_ina.ina04) #FUN-680006
      LET l_cnt = 1
      WHILE l_moredata AND l_cnt <= tm.bcnt
         LET l_inb.inb01 = l_ina.ina01
         LET l_inb.inb03 = l_cnt
         LET l_inb.inb04 = g_rmh.rmh03
         LET l_inb.inb05 = g_rmh.rmh04
         LET l_inb.inb06 = g_rmh.rmh05
         LET l_inb.inb07 = g_rmh.rmh06
         LET l_inb.inb08 = g_rmh.rmh08
         LET l_inb.inb08_fac = 1
         LET l_inb.inb09 = g_rmh.rmh10
         IF l_inb.inb09 < 0 THEN
            LET l_inb.inb09 = l_inb.inb09 * -1
         END IF
         LET l_inb.inb15 = g_rmz.rmz14
         LET l_inb.inb930=l_inb930 #FUN-680006
         LET l_inb.inb16 = g_rmh.rmh10   #No.FUN-870163
         LET l_inb.inbplant = g_plant    #FUN-980007
         LET l_inb.inblegal = g_legal    #FUN-980007
        #FUN-CB0087-xj---add---str
         IF g_aza.aza115 = 'Y' THEN
            SELECT ina10,ina11 INTO l_ina10,l_ina11 FROM ina_file WHERE ina01 = l_inb.inb01
            CALL s_reason_code(l_inb.inb01,l_ina10,'',l_inb.inb04,l_inb.inb05,l_ina.ina04,l_ina11) RETURNING l_inb.inb15
            IF cl_null(l_inb.inb15) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = "N"
               EXIT WHILE
            END IF
         END IF
        #FUN-CB0087-xj---add---end
         INSERT INTO inb_file VALUES(l_inb.*)
         IF STATUS THEN 
            LET g_success = "N"
            LET l_moredata = 0 #insert 失敗視同已無資料
            EXIT WHILE
#FUN-B70074--add--insert--
        ELSE
           IF NOT s_industry('std') THEN
              INITIALIZE l_inbi.* TO NULL
              LET l_inbi.inbi01 = l_inb.inb01
              LET l_inbi.inbi03 = l_inb.inb03
              IF NOT s_ins_inbi(l_inbi.*,l_inb.inbplant ) THEN
                LET g_success = "N"
                LET l_moredata = 0 #insert 失敗視同已無資料
                EXIT WHILE
              END IF
           END IF 
#FUN-B70074--add--insert--
         END IF
 
         #寫回單據編號及項次
         UPDATE rmh_file SET rmh11 = g_today,
            rmh12 = l_ina.ina01, rmh13 = l_cnt
            WHERE rmh01 = g_rmh.rmh01 AND rmh02 = g_rmh.rmh02 AND rmh03 = g_rmh.rmh03 AND rmh04 = g_rmh.rmh04 AND rmh05 = g_rmh.rmh05
         IF STATUS THEN 
            LET g_success = "N"
            LET l_moredata = 0 #insert 失敗視同已無資料
            EXIT WHILE
         END IF
         FETCH NEXT t300t_cs INTO g_rmh.*
         IF STATUS THEN LET l_moredata = 0 ELSE LET l_moredata = 1 END IF
         LET l_cnt = l_cnt + 1
      END WHILE
   END WHILE
   CLOSE t300t_cs
   IF g_success="Y" THEN
      COMMIT WORK
#     CALL cl_flow_notify(g_rmn.rmn01,'S')
      CALL cl_cmmsg(4) SLEEP 1
   ELSE
      ROLLBACK WORK
      CALL cl_err('',9050,1)
   END IF
END FUNCTION
 
FUNCTION t300_fetch(p_flag)
DEFINE
   p_flag   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
   l_abso   LIKE type_file.num10   #No.FUN-690010 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT t300_cs
         INTO g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh04,
              g_rmh.rmh05
      WHEN 'P' FETCH PREVIOUS t300_cs
         INTO g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh04,
              g_rmh.rmh05
      WHEN 'F' FETCH FIRST t300_cs
         INTO g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh04,
              g_rmh.rmh05
      WHEN 'L' FETCH LAST t300_cs
         INTO g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh04,
              g_rmh.rmh05
      WHEN '/'  
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t300_cs INTO g_rmh.*
            LET mi_no_ask = FALSE
   END CASE
   
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FETCH :',SQLCA.SQLCODE,0)
      INITIALIZE g_rmh.* TO NULL  #TQC-6B0105
      RETURN
   ELSE 
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_rmh.* FROM rmh_file
      WHERE rmh01 = g_rmh.rmh01 AND rmh02 = g_rmh.rmh02 AND rmh03 = g_rmh.rmh03 AND rmh04 = g_rmh.rmh04 AND rmh05 = g_rmh.rmh05
   IF SQLCA.SQLCODE THEN
 #     CALL cl_err(g_rmh.rmh01,SQLCA.sqlcode,0)
      CALL cl_err3("sel","rmh_file",g_rmh.rmh01,g_rmh.rmh02,SQLCA.sqlcode,"","",1) #FUN-660111  
   ELSE
      CALL t300_show()
   END IF
END FUNCTION
 
FUNCTION t300_g_tlf()
    DEFINE g_qty LIKE rmh_file.rmh09,  #No.FUN-690010 dec(12,3),
           g_day LIKE type_file.num5,  #No.FUN-690010 smallint,
           bdate,edate LIKE type_file.dat     #No.FUN-690010 DATE
 
        CALL s_azm(g_rmh.rmh01,g_rmh.rmh02) RETURNING g_chr,bdate,edate
        LET g_qty = 0 
        SELECT sum(tlf10*tlf907*tlf60) INTO g_qty #異動數量*出入庫碼*轉換率
         FROM  tlf_file
         WHERE tlf01 = g_rmh.rmh03
           AND (tlf02 =50 OR tlf03 =50 )
           AND (tlf902 = g_rmh.rmh04 AND tlf903 = g_rmh.rmh05
                AND tlf903 = g_rmh.rmh06)
           AND (tlf06 >=  bdate AND tlf06 <= edate)
        IF STATUS OR g_qty IS NULL THEN LET g_qty = 0 END IF 
        
      DISPLAY g_qty TO FORMONLY.tqty 
END FUNCTION 
 
FUNCTION t300_show()
   LET g_rmh_t.* = g_rmh.*
   #No.FUN-9A0024--begin 
   #DISPLAY BY NAME g_rmh.*
   DISPLAY BY NAME g_rmh.rmh01,g_rmh.rmh02,g_rmh.rmh03,g_rmh.rmh08,g_rmh.rmh04,
                   g_rmh.rmh05,g_rmh.rmh06,g_rmh.rmh07,g_rmh.rmh09,g_rmh.rmh10,
                   g_rmh.rmh14,g_rmh.rmh15,g_rmh.rmh11,g_rmh.rmh12,g_rmh.rmh13,
                   g_rmh.rmhud01,g_rmh.rmhud02,g_rmh.rmhud03,g_rmh.rmhud04,
                   g_rmh.rmhud05,g_rmh.rmhud06,g_rmh.rmhud07,g_rmh.rmhud08,
                   g_rmh.rmhud09,g_rmh.rmhud10,g_rmh.rmhud11,g_rmh.rmhud12,
                   g_rmh.rmhud13,g_rmh.rmhud14,g_rmh.rmhud15 
   #No.FUN-9A0024--end
   CALL t300_rmh03('d')
   CALL t300_g_tlf()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t300_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rmh01,rmh02,rmh03,rmh04,rmh05",TRUE)
   END IF
END FUNCTION
 
FUNCTION t300_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rmh01,rmh02,rmh03,rmh04,rmh05",FALSE)
   END IF
END FUNCTION
 
