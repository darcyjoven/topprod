# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri025.4gl
# Descriptions...:
# Date & Author..: 03/19/13 by zhangbo


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrbh    RECORD LIKE hrbh_file.*
DEFINE  g_hrbh_t  RECORD LIKE hrbh_file.*
DEFINE  g_forupd_sql        STRING
DEFINE g_rec_b                LIKE type_file.num10
DEFINE l_ac                   LIKE type_file.num5
DEFINE g_sql                  STRING                      #組 sql 用
DEFINE g_before_input_done    LIKE type_file.num5         #判斷是否已執行 Before Input指令
DEFINE g_chr                  LIKE hrat_file.hratacti
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_i                    LIKE type_file.num5         #count/index for any purpose
DEFINE g_wc                   STRING
DEFINE g_msg                  STRING
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10        #總筆數
DEFINE g_jump                 LIKE type_file.num10        #查詢指定的筆數
DEFINE g_no_ask               LIKE type_file.num5         #是否開啟指定筆視窗
DEFINE g_hratid               LIKE hrat_file.hratid
DEFINE g_argv1                LIKE hrat_file.hrat01
DEFINE g_hrbf           RECORD LIKE hrbf_file.*
DEFINE g_bp_flag           LIKE type_file.chr10
DEFINE g_hrat01            VARCHAR(4000)          #须要离职结清的员工工号
DEFINE  g_hrbh_1     DYNAMIC ARRAY OF RECORD
               hrbh01_2       LIKE hrbh_file.hrbh01,
               hrat02_2       LIKE hrat_file.hrat02,
               hrat25_2       LIKE hrat_file.hrat25,     #入司日期
               hrbiud02_2     LIKE hrbi_file.hrbiud02,   #旧工号
               hrat04_2       LIKE hrat_file.hrat04,
               hrat04_desc_2  LIKE hrao_file.hrao02,  
               hrat05_2       LIKE hrat_file.hrat05,   
               hrat05_desc_2  LIKE hrap_file.hrap06, 
               hrat06_2       LIKE hrat_file.hrat06, 
               hrat06_desc_2  LIKE hrat_file.hrat02,    
               hrat17_2       LIKE hrat_file.hrat17,     
               hrat17_desc_2  LIKE hrag_file.hrag07,      
               hrat22_2       LIKE hrat_file.hrat22,       
               hrat22_desc_2  LIKE hrag_file.hrag07,        
               hrat42_2       LIKE hrat_file.hrat42,        
               hrat42_desc_2  LIKE hrai_file.hrai04,
               hrat66_2       LIKE hrat_file.hrat66,         
               hrbh02_a       LIKE hrbh_file.hrbh02,
               hrbh03_2       LIKE hrbh_file.hrbh03,
               hrbh04_2       LIKE hrbh_file.hrbh04,
               hrbh05_2       LIKE hrbh_file.hrbh05,             
               hrbh05_desc_2  LIKE hrag_file.hrag07, 
               hrbh06_2       LIKE hrbh_file.hrbh06,               
               hrbh06_desc_2  LIKE hrad_file.hrad03,
               hrbhconf_2     LIKE hrbh_file.hrbhconf,
               hrbh12_2       LIKE hrbh_file.hrbh12,                 
               hrbh12_desc_2  LIKE hrag_file.hrag07,                  
               hrbh11_2       LIKE hrbh_file.hrbh11,
               hrbh07_2       LIKE hrbh_file.hrbh07,
               hrbh08_2       LIKE hrbh_file.hrbh08,
               hrbhmodu_n     LIKE hrat_file.hrat02       
            END RECORD

MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
   DEFINE l_name   STRING
   DEFINE l_items  STRING
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

   LET g_argv1=ARG_VAL(1)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   INITIALIZE g_hrbh.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrbh_file WHERE hrbh01 = ? and hrbh03 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i025_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i025_w AT p_row,p_col
     WITH FORM "ghr/42f/ghri025"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()
   #CALL cl_set_combo_items("hrbh02",NULL,NULL)
   #CALL i025_get_items('311') RETURNING l_name,l_items
   #CALL cl_set_combo_items("hrbh02",l_name,l_items)

   LET g_action_choice=""

   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" hrbh01='",g_argv1,"'"
      CALL i025_q()
   END IF

   CALL i025_menu()

   CLOSE WINDOW i025_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

FUNCTION i025_curs()

    CLEAR FORM
    INITIALIZE g_hrbh.* TO NULL
  IF g_argv1 IS NULL THEN
    CONSTRUCT BY NAME g_wc ON
        hrbh01,jgh,hrbh02,hrbh03,hrbh04,hrbh05,hrbh06,
        hrbh07,hrbh08,hrbh09,hrbh11,hrbh12,hrbhconf,
        hrbhuser,hrbhgrup,hrbhmodu,hrbhdate,hrbhoriu,hrbhorig,
        hrbhud01,hrbhud02,hrbhud03,hrbhud04,hrbhud05,hrbhud06,
        hrbhud07,hrbhud08,hrbhud09,hrbhud10,hrbhud11,hrbhud12,
        hrbhud13,hrbhud14,hrbhud15

        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbh01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbh01_cx"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbh.hrbh01
                 LET g_qryparam.where = " hratid in (select distinct hrbh01 from hrbh_file) "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbh01
                 NEXT FIELD hrbh01

              WHEN INFIELD(hrbh05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '310'
                 LET g_qryparam.default1 = g_hrbh.hrbh05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbh05
                 NEXT FIELD hrbh05

             WHEN INFIELD(hrbh06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " hrad01='003' "
                 LET g_qryparam.default1 = g_hrbh.hrbh06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbh06
                 NEXT FIELD hrbh06
             WHEN INFIELD(hrbh12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " hrad01!='003' "
                 LET g_qryparam.default1 = g_hrbh.hrbh12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbh12
                 NEXT FIELD hrbh12
              OTHERWISE
                 EXIT CASE
           END CASE

      ON IDLE g_idle_seconds                                #
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #
         CALL cl_about()

      ON ACTION help                                        #
         CALL cl_show_help()

      ON ACTION controlg                                    #
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #
         CALL cl_qbe_save()
    END CONSTRUCT
  END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbhuser', 'hrbhgrup')  #
    CALL cl_replace_str(g_wc,'hrbh01','hrat01') RETURNING g_wc                                                                     #
    CALL cl_replace_str(g_wc,'jgh','hrbiud02') RETURNING g_wc  

#    LET g_sql = "SELECT hrbh01,hrbh03 FROM hrbh_file,hrat_file ",                       #
#                " WHERE ",g_wc CLIPPED,
#                "   AND hrbh01=hratid ",
#                " ORDER BY hrbh01"
    LET g_sql = "SELECT hrbh01,hrbh03 FROM hrbh_file left join hrat_file on hrbh01=hratid left join hrbi_file on hrbh01=hrbi01 and hrbh11 = hrbiud22 ",                       #
                " WHERE ",g_wc CLIPPED,
                " ORDER BY hrbh01"
    PREPARE i025_prepare FROM g_sql
    DECLARE i025_cs                                                  #
        SCROLL CURSOR WITH HOLD FOR i025_prepare

#    LET g_sql = "SELECT COUNT(hrbh01) FROM hrbh_file,hrat_file WHERE ",
#                " hrbh01=hratid AND ",g_wc CLIPPED
    LET g_sql = "SELECT COUNT(hrbh01) FROM hrbh_file left join hrat_file on hrbh01=hratid left join hrbi_file on hrbi01=hrbh01 and hrbh11 = hrbiud22 WHERE ",g_wc CLIPPED
    PREPARE i025_precount FROM g_sql
    DECLARE i025_count CURSOR FOR i025_precount
END FUNCTION

FUNCTION i025_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION item_list
         LET g_action_choice = "" 
         CALL i025_b_menu()  
         IF g_action_choice = "exit" THEN  
            EXIT MENU  
         END IF  
         
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i025_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i025_q()
            END IF

        ON ACTION next
            CALL i025_fetch('N')

        ON ACTION previous
            CALL i025_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i025_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i025_r()
            END IF

        #合同信息
        ON ACTION ghri025_b
           LET g_action_choice="ghri025_b"
           IF cl_chk_act_auth() THEN
              CALL i025_ht()
           END IF
  #终止合同
        ON ACTION ghri025_a
           LET g_action_choice="ghri025_a"
           CALL i0221_assign()
        #培训信息
        ON ACTION ghri025_c
           LET g_action_choice="ghri025_c"

        #工作交接信息
        ON ACTION ghri025_d
           LET g_action_choice="ghri025_d"
           IF cl_chk_act_auth() THEN
              LET g_hratid=''
              SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
              LET g_msg="ghri025_1 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF

        #部门面谈信息
        ON ACTION ghri025_e
           LET g_action_choice="ghri025_e"
           IF cl_chk_act_auth() THEN
              LET g_hratid=''
              SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
              LET g_msg="ghri025_2 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF

        #人资面谈信息
        ON ACTION ghri025_f
           LET g_action_choice="ghri025_f"
           IF cl_chk_act_auth() THEN
              LET g_hratid=''
              SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
              LET g_msg="ghri025_3 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF

        ON ACTION ghri025_g
           LET g_action_choice="ghri025_g"
           IF cl_chk_act_auth() THEN
              CALL i025_confirm()
           END IF

        ON ACTION ghri025_h
           LET g_action_choice="ghri025_h"
           IF cl_chk_act_auth() THEN
              CALL i025_undo_confirm()
           END IF

        ON ACTION ghri025_i
           LET g_action_choice="ghri025_i"
            IF cl_chk_act_auth() THEN
               CALL i025_guidang()
            END IF

        ON ACTION ghri025_j
           LET g_action_choice="ghri025_j"
            IF cl_chk_act_auth() THEN
               CALL i025_undo_guidang()
            END IF

        ON ACTION ghri025_k
           LET g_action_choice="ghri025_k"
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_hrbh01_01"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_hrat01
           IF cl_chk_act_auth() THEN
               CALL i025_p_jieqing()
              #CALL i025_jieqing()
           END IF
        
        ON ACTION ghri025_plsh
           LET g_action_choice="ghri025_plsh"
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_hrbh01_wsh"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_hrat01
           IF cl_chk_act_auth() THEN
               CALL i025_p_shenhe()
           END IF
           
        ON ACTION ghri025_plhmd
           LET g_action_choice="ghri025_plhmd"
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_hrbh01_hmd"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_hrat01
           IF cl_chk_act_auth() THEN
               CALL i025_p_hmd()
           END IF

        ON ACTION ghri025_l
           LET g_action_choice="ghri025_l"
           IF cl_chk_act_auth() THEN
              CALL i025_undo_jieqing()
           END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i025_fetch('/')

        ON ACTION first
            CALL i025_fetch('F')

        ON ACTION last
            CALL i025_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about
           CALL cl_about()

        ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU

        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrbh.hrbh01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbh01"
                 LET g_doc.value1 = g_hrbh.hrbh01
                 CALL cl_doc()
              END IF
           END IF
    END MENU

END FUNCTION

FUNCTION i025_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrbh02 LIKE  hrbh_file.hrbh02
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT SUBSTR(hrag06,LENGTH(hrag06),1) ,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i001_get_items_pre FROM l_sql
       DECLARE i001_get_items CURSOR FOR i001_get_items_pre
       LET l_name=''
       LET l_items=''
       FOREACH i001_get_items INTO l_hrbh02,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name = l_hrbh02
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrbh02 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       RETURN l_name,l_items
END FUNCTION


FUNCTION i025_a()
DEFINE l_hrbh   RECORD LIKE hrbh_file.*

    CLEAR FORM                                   #
    INITIALIZE g_hrbh.* LIKE hrbh_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbh.hrbh02 = '1'
        LET g_hrbh.hrbh09 = 'N'
        LET g_hrbh.hrbh03 = g_today
        LET g_hrbh.hrbh06 = '3001'
        LET g_hrbh.hrbhuser = g_user
        LET g_hrbh.hrbhoriu = g_user
        LET g_hrbh.hrbhorig = g_grup
        LET g_hrbh.hrbhgrup = g_grup               #
        LET g_hrbh.hrbhdate = g_today
        LET g_hrbh.hrbhconf = '1'
        CALL i025_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrbh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbh.hrbh01 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        LET l_hrbh.* = g_hrbh.*
        SELECT hratid INTO l_hrbh.hrbh01 FROM hrat_file
         WHERE (hrat01=g_hrbh.hrbh01 or hratid=g_hrbh.hrbh01)
           AND hratacti='Y'
           AND hratconf='Y'
        SELECT hratid INTO  l_hrbh.hrbh13 FROM hrat_file
         WHERE hrat01=g_hrbh.hrbh13   
        INSERT INTO hrbh_file VALUES(l_hrbh.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbh_file",g_hrbh.hrbh01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i025_i(p_cmd)

   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_input          LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_hrat02         LIKE hrat_file.hrat02
   DEFINE l_hrat04         LIKE hrat_file.hrat04
   DEFINE l_hrat04_desc    LIKE hrao_file.hrao02
   DEFINE l_hrat05         LIKE hrat_file.hrat05
   DEFINE l_hrat05_desc    LIKE hrap_file.hrap06
   DEFINE l_hrat17         LIKE hrat_file.hrat17
   DEFINE l_hrat17_desc    LIKE hrag_file.hrag07
   DEFINE l_hrat22         LIKE hrat_file.hrat22
   DEFINE l_hrat22_desc    LIKE hrag_file.hrag07
   DEFINE l_hrat06         LIKE hrat_file.hrat06
   DEFINE l_hrat06_desc    LIKE hrat_file.hrat02
   DEFINE l_hrat19         LIKE hrat_file.hrat19
   DEFINE l_hrad03_desc    LIKE hrad_file.hrad03
   DEFINE l_hrat42         LIKE hrat_file.hrat42
   DEFINE l_hrat42_desc    LIKE hrai_file.hrai04
   DEFINE l_hrat25         LIKE hrat_file.hrat25
   DEFINE l_hrbh05_desc    LIKE hrag_file.hrag07
   DEFINE l_hrbh06_desc    LIKE hrad_file.hrad03
   DEFINE l_sql         STRING
   DEFINE l_hrbh13_n       LIKE hrat_file.hrat02  
   DISPLAY BY NAME
      g_hrbh.hrbh01,g_hrbh.hrbh02,g_hrbh.hrbh03,g_hrbh.hrbh04,
      g_hrbh.hrbh05,g_hrbh.hrbh06,g_hrbh.hrbh07,g_hrbh.hrbh08,g_hrbh.hrbh09,
      g_hrbh.hrbh11,g_hrbh.hrbh12,
      g_hrbh.hrbhconf,g_hrbh.hrbhoriu,g_hrbh.hrbhorig,
      g_hrbh.hrbhuser,g_hrbh.hrbhgrup,g_hrbh.hrbhmodu,g_hrbh.hrbhdate,
      g_hrbh.hrbhud01,g_hrbh.hrbhud02,g_hrbh.hrbhud03,g_hrbh.hrbhud04,
      g_hrbh.hrbhud05,g_hrbh.hrbhud06,g_hrbh.hrbhud07,g_hrbh.hrbhud08,
      g_hrbh.hrbhud09,g_hrbh.hrbhud10,g_hrbh.hrbhud11,g_hrbh.hrbhud12,
      g_hrbh.hrbhud13,g_hrbh.hrbhud14,g_hrbh.hrbhud15
   LET l_hrbh06_desc = '离职员工'
   DISPLAY l_hrbh06_desc TO hrbh06_desc
   INPUT BY NAME
      g_hrbh.hrbh01,g_hrbh.hrbh02,g_hrbh.hrbh03,g_hrbh.hrbh04,
      g_hrbh.hrbh05,g_hrbh.hrbh06,g_hrbh.hrbh13,g_hrbh.hrbh07,g_hrbh.hrbh08,g_hrbh.hrbh09,
      g_hrbh.hrbh11,g_hrbh.hrbhconf,
      g_hrbh.hrbhud01,g_hrbh.hrbhud02,g_hrbh.hrbhud03,g_hrbh.hrbhud04,
      g_hrbh.hrbhud05,g_hrbh.hrbhud06,g_hrbh.hrbhud07,g_hrbh.hrbhud08,
      g_hrbh.hrbhud09,g_hrbh.hrbhud10,g_hrbh.hrbhud11,g_hrbh.hrbhud12,
      g_hrbh.hrbhud13,g_hrbh.hrbhud14,g_hrbh.hrbhud15
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i025_set_entry(p_cmd)
          CALL i025_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD hrbh01
         IF NOT cl_null(g_hrbh.hrbh01) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrat_file LEFT JOIN HRAD_FILE ON HRAD02=HRAT19 WHERE hrat01=g_hrbh.hrbh01
                                                      AND hratconf='Y' AND HRAD01 <> '003'
            IF l_n=0 THEN
               CALL cl_err('此员工不在职或者不存在或还未审核','!',1)
               NEXT FIELD hrbh01
            END IF
            IF NOT cl_null(g_hrbh.hrbh11) THEN
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM hrbh_file LEFT JOIN hrat_file ON hratid=hrbh01 WHERE hrat01 = g_hrbh.hrbh01 AND hrbh11 = g_hrbh.hrbh11
              IF l_n>0 AND p_cmd = 'a' THEN
               CALL cl_err('此员工最后工作日期的离职信息已经存在','!',1)
               NEXT FIELD hrbh01
              END IF 
              IF l_n>1 AND p_cmd = 'u' THEN
               CALL cl_err('此员工最后工作日期的离职信息已经存在','!',1)
               NEXT FIELD hrbh01
              END IF 
            END IF 
          #add by yinbq 201411 考虑到同一员工可以二次入职直至多次离职，移除员工唯一性校验
          #  IF g_hrbh.hrbh01 != g_hrbh_t.hrbh01 OR g_hrbh_t.hrbh01 IS NULL THEN
          #     LET l_n=0
          #     SELECT COUNT(*) INTO l_n FROM hrbh_file,hrat_file WHERE hrbh01=hratid
          #                                                               AND hrat01=g_hrbh.hrbh01
          #     IF l_n>0 THEN
          #       CALL cl_err(g_hrbh.hrbh01,-239,1)
          #       NEXT FIELD htbh01
          #     END IF
          #  END IF
          #add by yinbq 201411 考虑到同一员工可以二次入职直至多次离职，移除员工唯一性校验

            #姓名,部门编号,职位编号,直接主管,性别,学历,员工状态,成本中心,入职日期
            #SELECT a.hrat02,a.hrat04,b.hrao02,a.hrat05,c.hras04,a.hrat06,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,a.hrat42,h.hrai04,a.hrat25
            SELECT a.hrat02,a.hrat04,b.hrao02,a.hrat05,c.hras04,a.hrat06,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,a.hrat20,h.hrag07,a.hrat25
              INTO l_hrat02,l_hrat04,l_hrat04_desc,l_hrat05,l_hrat05_desc,l_hrat06,l_hrat06_desc,l_hrat17,l_hrat17_desc,l_hrat22,l_hrat22_desc,l_hrat19,l_hrad03_desc,l_hrat42,l_hrat42_desc,l_hrat25
            FROM hrat_file a
            LEFT JOIN hrao_file b ON hrao01=hrat04
            LEFT JOIN hras_file c ON hras01=hrat05
            LEFT JOIN hrat_file d ON d.hrat01=a.hrat06
            LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
            LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
            LEFT JOIN hrad_file g ON g.hrad02=a.hrat19
            #LEFT JOIN hrai_file h ON h.hrai03=a.hrat42
            LEFT join hrag_file h ON h.hrag06=a.hrat20 AND h.hrag01='313'
            WHERE a.hrat01=g_hrbh.hrbh01 AND a.hratconf='Y'

            DISPLAY l_hrat02 TO hrat02
            DISPLAY l_hrat04 TO hrat04
            DISPLAY l_hrat04_desc TO hrat04_desc
            DISPLAY l_hrat05 TO hrat05
            DISPLAY l_hrat05_desc TO hrat05_desc
            DISPLAY l_hrat06 TO hrat06
            DISPLAY l_hrat06_desc TO hrat06_desc
            DISPLAY l_hrat17 TO hrat17
            DISPLAY l_hrat17_desc TO hrat17_desc
            DISPLAY l_hrat22 TO hrat22
            DISPLAY l_hrat22_desc TO hrat22_desc
            DISPLAY l_hrat19 TO hrbh12
            LET g_hrbh.hrbh12 = l_hrat19 #给离职表原员工状态赋值
            DISPLAY l_hrad03_desc TO hrbh12_desc
            DISPLAY l_hrat42 TO hrat42
            DISPLAY l_hrat42_desc TO hrat42_desc
            DISPLAY l_hrat25 TO hrat66

         END IF


      AFTER FIELD hrbh05
         IF g_hrbh.hrbh05 IS NOT NULL THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01 = '310'
                                                      AND hrag06 = g_hrbh.hrbh05
            IF l_n = 0 THEN
               CALL cl_err('无此离退原因','!',0)
               LET g_hrbh.hrbh05 = g_hrbh_t.hrbh05
               DISPLAY BY NAME g_hrbh.hrbh05
               NEXT FIELD hrbh05
            END IF

            SELECT hrag07 INTO l_hrbh05_desc FROM hrag_file
             WHERE hrag01='310'
               AND hrag06=g_hrbh.hrbh05
            DISPLAY l_hrbh05_desc TO hrbh05_desc
         END IF
       	#add by zhuzw 20150318 start
        AFTER FIELD hrbh13
           IF NOT cl_null(g_hrbh.hrbh13) THEN
              SELECT COUNT(*) INTO l_n FROM hrat_file 
               WHERE hrat01 = g_hrbh.hrbh13
              IF l_n = 0 THEN 
                 CALL cl_err('工号不存在请检查','!',0)
                 NEXT FIELD hrbh13
              ELSE 
              	 SELECT hrat02 INTO l_hrbh13_n FROM hrat_file 
              	  WHERE hrat01 = g_hrbh.hrbh13
              	 DISPLAY  l_hrbh13_n TO hrbh13_n
              END IF 
           END IF  
       	#add by zhuzw 20150318 end 
      AFTER FIELD hrbh06
         IF NOT cl_null(g_hrbh.hrbh06) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrad_file
             WHERE hrad01='003'
               AND hrad02=g_hrbh.hrbh06
               AND hradacti='Y'
            IF l_n=0 THEN
               CALL cl_err('无此员工状态','!',0)
               NEXT FIELD hrbh06
            END IF
            SELECT hrad03 INTO l_hrbh06_desc FROM hrad_file
             WHERE hrad02=g_hrbh.hrbh06
            DISPLAY l_hrbh06_desc TO hrbh06_desc
         END IF
      AFTER FIELD hrbh11
         IF cl_null(g_hrbh.hrbh11) THEN
            CALL cl_err('最后工作日不可为空!','!',0)
            NEXT FIELD hrbh11
         END IF
         IF NOT cl_null(g_hrbh.hrbh11) AND NOT cl_null(g_hrbh.hrbh03) THEN
           IF g_hrbh.hrbh11<g_hrbh.hrbh03 THEN
             CALL cl_err('最后工作日必须大于等申请日期','!',0)
             NEXT FIELD hrbh03
           END IF
           IF NOT cl_null(g_hrbh.hrbh01) THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrbh_file LEFT JOIN hrat_file ON hratid=hrbh01 WHERE hrat01 = g_hrbh.hrbh01 AND hrbh11 = g_hrbh.hrbh11
             IF l_n>0 AND p_cmd = 'a' THEN
              CALL cl_err('此员工最后工作日期的离职信息已经存在','!',1)
              NEXT FIELD hrbh01
             END IF 
             IF l_n>1 AND p_cmd = 'u' THEN
              CALL cl_err('此员工最后工作日期的离职信息已经存在','!',1)
              NEXT FIELD hrbh01
             END IF 
           END IF 
         END IF
      AFTER FIELD hrbh04
         IF NOT cl_null(g_hrbh.hrbh04) AND NOT cl_null(g_hrbh.hrbh03) THEN
          IF g_hrbh.hrbh04<g_hrbh.hrbh03 THEN
            CALL cl_err('预计离职日期必须大于等申请日期','!',0)
            NEXT FIELD hrbh04
          END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF


      ON ACTION controlp
        CASE
           WHEN INFIELD(hrbh01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat02_002"
              LET g_qryparam.default1 = g_hrbh.hrbh01
              #LET g_qryparam.where =" hrat19 NOT LIKE '3%' "
              CALL cl_create_qry() RETURNING g_hrbh.hrbh01
              DISPLAY BY NAME g_hrbh.hrbh01
              NEXT FIELD hrbh01

           WHEN INFIELD(hrbh05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrbh.hrbh05
              LET g_qryparam.arg1 = '310'
              CALL cl_create_qry() RETURNING g_hrbh.hrbh05
              DISPLAY BY NAME g_hrbh.hrbh05
              NEXT FIELD hrbh05

           WHEN INFIELD(hrbh06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = g_hrbh.hrbh06
              LET g_qryparam.where = " hrad01='003' "
              CALL cl_create_qry() RETURNING g_hrbh.hrbh06
              DISPLAY BY NAME g_hrbh.hrbh06
              NEXT FIELD hrbh06
#add by zhuzw 20150318 start
            	 WHEN INFIELD(hrbh13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_hrat01"
                    LET g_qryparam.default1 = g_hrbh.hrbh13
                    CALL cl_create_qry() RETURNING g_hrbh.hrbh13
                    DISPLAY BY NAME g_hrbh.hrbh13
                    NEXT FIELD hrbh13
#add by zhuzw 20140318 end
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION

FUNCTION i025_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbh.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i025_curs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i025_count
    FETCH i025_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i025_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbh.hrbh01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbh.* TO NULL
    ELSE
        CALL i025_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i025_fetch(p_flhrbh)
    DEFINE p_flhrbh         LIKE type_file.chr1

    CASE p_flhrbh
        WHEN 'N' FETCH NEXT     i025_cs INTO g_hrbh.hrbh01,g_hrbh.hrbh03
        WHEN 'P' FETCH PREVIOUS i025_cs INTO g_hrbh.hrbh01,g_hrbh.hrbh03
        WHEN 'F' FETCH FIRST    i025_cs INTO g_hrbh.hrbh01,g_hrbh.hrbh03
        WHEN 'L' FETCH LAST     i025_cs INTO g_hrbh.hrbh01,g_hrbh.hrbh03
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
            FETCH ABSOLUTE g_jump i025_cs INTO g_hrbh.hrbh01,g_hrbh.hrbh03
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbh.hrbh01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbh.* TO NULL
        LET g_hrbh.hrbh01 = NULL
        RETURN
    ELSE
      CASE p_flhrbh
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrbh.* FROM hrbh_file
     WHERE hrbh01 = g_hrbh.hrbh01
       AND hrbh03 = g_hrbh.hrbh03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbh_file",g_hrbh.hrbh01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i025_show()
    END IF
END FUNCTION

FUNCTION i025_show()
DEFINE l_hratid   LIKE    hrat_file.hratid
DEFINE l_hrat02         LIKE hrat_file.hrat02
DEFINE l_hrat04         LIKE hrat_file.hrat04
DEFINE l_hrat04_desc    LIKE hrao_file.hrao02
DEFINE l_hrat05         LIKE hrat_file.hrat05
DEFINE l_hrat05_desc    LIKE hrap_file.hrap06
DEFINE l_hrat17         LIKE hrat_file.hrat17
DEFINE l_hrat17_desc    LIKE hrag_file.hrag07
DEFINE l_hrat22         LIKE hrat_file.hrat22
DEFINE l_hrat22_desc    LIKE hrag_file.hrag07
DEFINE l_hrat06         LIKE hrat_file.hrat06
DEFINE l_hrat06_desc    LIKE hrat_file.hrat02
DEFINE l_hrat19         LIKE hrat_file.hrat19
DEFINE l_hrad03_desc    LIKE hrad_file.hrad03
DEFINE l_hrat42         LIKE hrat_file.hrat42
DEFINE l_hrat42_desc    LIKE hrai_file.hrai04
DEFINE l_hrat25         LIKE hrat_file.hrat25
DEFINE l_hrbh05_desc    LIKE hrag_file.hrag07
DEFINE l_hrbh06_desc    LIKE hrad_file.hrad03
DEFINE l_hrbh12_desc    LIKE hrag_file.hrag07
DEFINE l_hrbh13_n       LIKE hrat_file.hrat02  
DEFINE l_jgh            LIKE hrat_file.hrat01 
    SELECT hrbiud02 INTO l_jgh FROM hrbi_file WHERE hrbi01=g_hrbh.hrbh01 AND hrbiud22 = g_hrbh.hrbh11  #查看返聘表里的旧工号
    SELECT hrat01 INTO g_hrbh.hrbh01 FROM hrat_file WHERE hratid=g_hrbh.hrbh01
#    IF cl_null(l_jgh) THEN 
#      LET l_jgh = g_hrbh.hrbh01   #没有返聘就用员工号
#    END IF 
    SELECT hrat01 INTO g_hrbh.hrbh13 FROM hrat_file WHERE hratid=g_hrbh.hrbh13
    LET g_hrbh_t.* = g_hrbh.*
    DISPLAY BY NAME g_hrbh.hrbh01,g_hrbh.hrbh02,g_hrbh.hrbh03,
                    g_hrbh.hrbh04,g_hrbh.hrbh05,g_hrbh.hrbh06,g_hrbh.hrbh07,
                    g_hrbh.hrbh08,g_hrbh.hrbh09,g_hrbh.hrbh11,g_hrbh.hrbh12,g_hrbh.hrbhconf,
                    g_hrbh.hrbhuser,g_hrbh.hrbhgrup,g_hrbh.hrbhmodu,
                    g_hrbh.hrbhdate,g_hrbh.hrbhorig,g_hrbh.hrbhoriu,
                    g_hrbh.hrbhud01,g_hrbh.hrbhud02,g_hrbh.hrbhud03,g_hrbh.hrbhud04,
                    g_hrbh.hrbhud05,g_hrbh.hrbhud06,g_hrbh.hrbhud07,g_hrbh.hrbhud08,
                    g_hrbh.hrbhud09,g_hrbh.hrbhud10,g_hrbh.hrbhud11,g_hrbh.hrbhud12,
                    g_hrbh.hrbhud13,g_hrbh.hrbhud14,g_hrbh.hrbhud15,g_hrbh.hrbh13
                     
   SELECT hrat02 INTO l_hrbh13_n FROM hrat_file WHERE hrat01 = g_hrbh.hrbh13
    DISPLAY  l_hrbh13_n TO hrbh13_n
    DISPLAY  l_jgh TO jgh
   IF g_hrbh.hrbhconf = 1 THEN 
      #姓名,部门编号,职位编号,直接主管,性别,学历,员工状态,成本中心,入职日期
      #SELECT a.hrat02,a.hrat04,b.hrao02,a.hrat05,c.hras04,a.hrat06,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,a.hrat42,h.hrai04,a.hrat25
      SELECT a.hrat02,a.hrat04,b.hrao02,a.hrat05,c.hras04,a.hrat06,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,a.hrat20,h.hrag07,a.hrat25
      INTO l_hrat02,l_hrat04,l_hrat04_desc,l_hrat05,l_hrat05_desc,l_hrat06,l_hrat06_desc,l_hrat17,l_hrat17_desc,l_hrat22,l_hrat22_desc,l_hrat19,l_hrad03_desc,l_hrat42,l_hrat42_desc,l_hrat25
      FROM hrat_file a
      LEFT JOIN hrao_file b ON hrao01=hrat04
      LEFT JOIN hras_file c ON hras01=hrat05
      LEFT JOIN hrat_file d ON d.hrat01=a.hrat06
      LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
      LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
      LEFT JOIN hrad_file g ON g.hrad02=a.hrat19
      #LEFT JOIN hrai_file h ON h.hrai03=a.hrat42
      LEFT JOIN hrag_file h ON h.hrag06=a.hrat20 AND h.hrag01='313'
      WHERE a.hrat01=g_hrbh.hrbh01 AND a.hratconf='Y'
   ELSE 
      #SELECT a.hrat02,hrbhud03,b.hrao02,hrbhud04,c.hras04,hrbhud05,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,hrbhud06,h.hrai04,a.hrat25
      #SELECT a.hrat02,hrbhud03,b.hrao02,hrbhud04,c.hras04,hrbhud05,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,hrbhud06,h.hrai04,hrbhud13 
      #SELECT a.hrat02,hrbhud03,b.hrao02,hrbhud04,c.hras04,hrbhud05,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,a.hrat19,g.hrad03,hrbhud06,h.hrag07,hrbhud13 
      SELECT a.hrat02,hrbhud03,b.hrao02,hrbhud04,c.hras04,hrbhud05,d.hrat02,a.hrat17,e.hrag07,a.hrat22,f.hrag07,hrbh12,g.hrad03,hrbhud06,h.hrag07,hrbhud13 
      INTO l_hrat02,l_hrat04,l_hrat04_desc,l_hrat05,l_hrat05_desc,l_hrat06,l_hrat06_desc,l_hrat17,l_hrat17_desc,l_hrat22,l_hrat22_desc,l_hrat19,l_hrad03_desc,l_hrat42,l_hrat42_desc,l_hrat25
      FROM hrbh_file 
      LEFT join hrat_file a ON a.hratid = hrbh01
      LEFT JOIN hrao_file b ON hrao01=hrbhud03
      LEFT JOIN hras_file c ON hras01=hrbhud04
      LEFT JOIN hrat_file d ON d.hrat01=hrbhud05
      LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
      LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
      LEFT JOIN hrad_file g ON g.hrad02=a.hrat19
      #LEFT JOIN hrai_file h ON h.hrai03=hrbhud06
      LEFT join hrag_file h ON h.hrag06=hrbhud06 AND h.hrag01='313'  #?????
      WHERE a.hrat01=g_hrbh.hrbh01 AND hrbh03 = g_hrbh.hrbh03
   END IF 

    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrat04 TO hrat04
    DISPLAY l_hrat04_desc TO hrat04_desc
    DISPLAY l_hrat05 TO hrat05
    DISPLAY l_hrat05_desc TO hrat05_desc
    DISPLAY l_hrat06 TO hrat06
    DISPLAY l_hrat06_desc TO hrat06_desc
    DISPLAY l_hrat17 TO hrat17
    DISPLAY l_hrat17_desc TO hrat17_desc
    DISPLAY l_hrat22 TO hrat22
    DISPLAY l_hrat22_desc TO hrat22_desc
    DISPLAY l_hrat19 TO hrbh12
    DISPLAY l_hrad03_desc TO hrbh12_desc
    DISPLAY l_hrat42 TO hrat42
    DISPLAY l_hrat42_desc TO hrat42_desc
    DISPLAY l_hrat25 TO hrat66
    
    SELECT hrag07 INTO l_hrbh05_desc FROM hrag_file
     WHERE hrag01='310' AND hrag06=g_hrbh.hrbh05
    SELECT hrad03 INTO l_hrbh06_desc FROM hrad_file
     WHERE hrad02=g_hrbh.hrbh06
    SELECT hrad03 INTO l_hrbh12_desc FROM hrad_file
     WHERE hrad02=g_hrbh.hrbh12
    DISPLAY l_hrbh05_desc TO hrbh05_desc
    DISPLAY l_hrbh06_desc TO hrbh06_desc
    DISPLAY l_hrbh12_desc TO hrbh12_desc
    CALL i025_list_fill() 
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i025_u()
DEFINE  l_hratid    LIKE   hrat_file.hratid
    IF g_hrbh.hrbh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #SELECT * INTO g_hrbh.* FROM hrbh_file WHERE hrbh01=g_hrbh.hrbh01
    IF g_hrbh.hrbhconf != '1' THEN
        CALL cl_err('资料已审核或已归档,不可更改','!',0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK
    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("OPEN i025_cl:", STATUS, 1)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i025_cl INTO g_hrbh.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbh.hrbh01,SQLCA.sqlcode,1)
        RETURN
    END IF
    CALL i025_show()
    WHILE TRUE
        CALL i025_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrbh.*=g_hrbh_t.*
            CALL i025_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrbh.hrbhmodu=g_user
        LET g_hrbh.hrbhdate=g_today
        UPDATE hrbh_file SET hrbh02 = g_hrbh.hrbh02,
                             hrbh03 = g_hrbh.hrbh03,
                             hrbh04 = g_hrbh.hrbh04,
                             hrbh05 = g_hrbh.hrbh05,
                             hrbh06 = g_hrbh.hrbh06,
                             hrbh07 = g_hrbh.hrbh07,
                             hrbh08 = g_hrbh.hrbh08,
                             hrbh09 = g_hrbh.hrbh09,
                             hrbh13 = g_hrbh.hrbh13,
                           #  hrbh10 = g_hrbh.hrbh10,
                             hrbhmodu = g_hrbh.hrbhmodu,
                             hrbhdate = g_hrbh.hrbhdate
         WHERE hrbh01 = l_hratid
           AND hrbh03 = g_hrbh_t.hrbh03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbh_file",g_hrbh.hrbh01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i025_show()
        EXIT WHILE
    END WHILE
    CLOSE i025_cl
    COMMIT WORK
END FUNCTION

FUNCTION i025_r()
DEFINE l_hratid    LIKE   hrat_file.hratid
    IF g_hrbh.hrbh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_hrbh.hrbhconf != '1' THEN
        CALL cl_err('资料已审核或已归档,不可删除','!',0)
        RETURN
    END IF
    BEGIN WORK

    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01

    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("OPEN i025_cl:", STATUS, 0)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i025_cl INTO g_hrbh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbh.hrbh01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i025_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrbh01"
       LET g_doc.value1 = g_hrbh.hrbh01
       CALL cl_del_doc()
       DELETE FROM hrbh_file WHERE hrbh01 = l_hratid AND hrbh03 = g_hrbh_t.hrbh03
       DELETE FROM hrbha_file WHERE hrbha02 = l_hratid
       DELETE FROM hrbhb_file WHERE hrbhb02 = l_hratid
       DELETE FROM hrbhc_file WHERE hrbhc02 = l_hratid
       CLEAR FORM
       OPEN i025_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i025_cl
          CLOSE i025_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i025_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i025_cl
          CLOSE i025_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i025_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i025_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i025_fetch('/')
       END IF
    END IF
    CLOSE i025_cl
    COMMIT WORK
END FUNCTION

FUNCTION i025_confirm()
DEFINE l_hrbhconf      LIKE hrbh_file.hrbhconf
DEFINE l_msg           STRING
DEFINE l_n             LIKE type_file.num5
DEFINE l_hratid,l_hratid_1        LIKE hrat_file.hratid
DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate
DEFINE l_hrbe01        LIKE hrbe_file.hrbe01

DEFINE l_sql,l_sql1    string
DEFINE l_hrat01        LIKE hrat_file.hrat01
DEFINE l_hrat01_1      LIKE hrat_file.hrat01
DEFINE l_hraw01        LIKE hraw_file.hraw01
DEFINE l_hraw02        LIKE hraw_file.hraw02 
DEFINE l_hraw03        LIKE hraw_file.hraw03
DEFINE l_hraw04        LIKE hraw_file.hraw04
DEFINE l_hraw05        LIKE hraw_file.hraw05
DEFINE l_hraw07        LIKE hraw_file.hraw07
DEFINE l_hrat03         LIKE hrat_file.hrat03
DEFINE l_hrat04         LIKE hrat_file.hrat04
DEFINE l_hrat05         LIKE hrat_file.hrat05
DEFINE l_hrat06         LIKE hrat_file.hrat06
DEFINE l_hrat42         LIKE hrat_file.hrat42
DEFINE l_hrat25         LIKE hrat_file.hrat25

   IF cl_null(g_hrbh.hrbh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_hrbh.hrbhconf !='1' THEN
      CALL cl_err('不可取消审核，请检查','!',1)  
      LET g_success='N'
      RETURN
   END IF
   
   LET l_hrbhmodu = g_hrbh.hrbhmodu
   LET l_hrbhdate = g_hrbh.hrbhdate

   BEGIN WORK
      SELECT hratid,hrat03,hrat04,hrat05,hrat06,hrat20,hrat25 INTO l_hratid, l_hrat03, l_hrat04, l_hrat05, l_hrat06, l_hrat42, l_hrat25 FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
      OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
      IF STATUS THEN
         CALL cl_err("open i025_cl:",STATUS,1)
         CLOSE i025_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH i025_cl INTO g_hrbh.*
      IF SQLCA.sqlcode  THEN
         CALL cl_err(l_hratid,SQLCA.sqlcode,0)
         CLOSE i025_cl
         ROLLBACK WORK
         RETURN
      END IF

      CALL i025_show()

      IF NOT cl_confirm("是否确定审核?") THEN
      ELSE
         IF NOT cl_null(g_hrbh.hrbh13) THEN 
            #处理直接主管指向离职人员的信息
       	   LET l_sql=" select hrat01 from hrat_file where hrat06='",g_hrbh.hrbh01,"' "
       	   PREPARE r100_p FROM l_sql 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('ghri016:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
            DECLARE r100_curs CURSOR WITH HOLD FOR r100_p 
            FOREACH r100_curs INTO l_hrat01_1 
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF 
               UPDATE  hrat_file SET  hrat06=g_hrbh.hrbh13, hrat84=g_hrbh.hrbh01 WHERE  hrat01=l_hrat01_1 
               IF SQLCA.sqlcode THEN
                  CALL cl_err("更新继任者相关失败","!",1)
                  ROLLBACK WORK
                  RETURN
               END IF
            END FOREACH 
            
            #更新参退保管理负责人信息
            SELECT hratid INTO l_hratid_1 FROM hrat_file WHERE hrat01 = g_hrbh.hrbh13
            UPDATE hrdu_file SET ta_hrdu02 = l_hratid_1 WHERE  ta_hrdu02 = l_hratid
            IF SQLCA.SQLCODE THEN
               CALL cl_err('更新社保负责人信息失败','!',1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF 
            
         #处理兼职相关信息
         LET l_sql1="select hraw01,hraw02,hraw03,hraw04,hraw05,hraw07 from hraw_file where hraw01='",l_hratid,"' and hraw05>=to_date('",g_hrbh.hrbh11,"','yy/mm/dd')" 
         PREPARE r025_p FROM l_sql1 
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('ghri016:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
         END IF
         DECLARE r025_curs CURSOR WITH HOLD FOR r025_p 
         FOREACH r025_curs INTO l_hraw01,l_hraw02,l_hraw03,l_hraw04,l_hraw05,l_hraw07
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE hraw_file SET  hraw05=g_hrbh.hrbh11, hrawud13=l_hraw04, hrawud14=l_hraw05
                   WHERE  hraw01=l_hraw01 AND  hraw02=l_hraw02 AND  hraw03=l_hraw03 AND hraw04=l_hraw04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hraw_file",l_hraw04,l_hraw05,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               EXIT FOREACH 
            END IF
            #部门主管的调整暂时不做，因不确定继任者是否须要额外添加兼职信息
         END FOREACH
    
         #回写员工信息
         UPDATE hrat_file SET hrat07='N',hrat19=g_hrbh.hrbh06,hrat77 = g_hrbh.hrbh11 WHERE hratid=l_hratid 
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新离职人员信息失败','!',1)
            ROLLBACK WORK
            RETURN 
         END IF 
         
         #更新员工电子卡信息
         UPDATE hrbw_file SET hrbwud02 = '2', hrbwud04 = '2', hrbw06 = g_hrbh.hrbh11 WHERE hrbw01=l_hratid
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新人员考勤卡信息失败','!',1)
            ROLLBACK WORK
            RETURN 
         END IF 
         
         #更新员工合同协议信息
         UPDATE hrbf_file SET hrbf09=g_hrbh.hrbh04 WHERE hrbf02=l_hratid AND g_hrbh.hrbh04>hrbf08 AND g_hrbh.hrbh04<hrbf09
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新人员合同协议信息失败','!',1)
            ROLLBACK WORK
            RETURN 
         END IF 
         
         #清除预生成考勤数据
         DELETE FROM hrcp_file WHERE hrcp02=l_hratid AND hrcp03>g_hrbh.hrbh11    #add by yinbq 20141104 for 离职审批通过后将因离职补录造成的已经生成的点名异常数据清除
         IF SQLCA.SQLCODE THEN
            CALL cl_err('清除预生成考勤数据失败','!',1)
            ROLLBACK WORK
            RETURN
         END IF
         
         #更新审核码
         LET g_hrbh.hrbhconf = '2'
         LET g_hrbh.hrbhmodu = g_user
         LET g_hrbh.hrbhdate = g_today
         
         UPDATE hrbh_file SET hrbhconf = g_hrbh.hrbhconf,
                              hrbhmodu = g_hrbh.hrbhmodu,
                              hrbhdate = g_hrbh.hrbhdate,
                              hrbhud02 = l_hrat03,
                              hrbhud03 = l_hrat04,
                              hrbhud04 = l_hrat05,
                              hrbhud05 = l_hrat06,
                              hrbhud06 = l_hrat42,
                              hrbhud13 = l_hrat25
            WHERE hrbh01 = l_hratid AND hrbh03 = g_hrbh_t.hrbh03

         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
            LET g_hrbh.hrbhconf = "1"
            LET g_hrbh.hrbhmodu = l_hrbhmodu
            LET g_hrbh.hrbhdate = l_hrbhdate
            DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
            ROLLBACK WORK
            RETURN
         ELSE
            DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
         END IF
   END IF
   CLOSE i025_cl
   COMMIT WORK
END FUNCTION

FUNCTION i025_undo_confirm()
   DEFINE l_hrbhconf      LIKE hrbh_file.hrbhconf
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
   DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate
   
   DEFINE l_sql,l_sql1    string
   DEFINE l_hrat01        LIKE hrat_file.hrat01
   DEFINE l_hrat01_1      LIKE hrat_file.hrat01
   DEFINE l_hraw01        LIKE hraw_file.hraw01
   DEFINE l_hraw02        LIKE hraw_file.hraw02 
   DEFINE l_hraw03        LIKE hraw_file.hraw03
   DEFINE l_hraw04        LIKE hraw_file.hraw04
   DEFINE l_hraw05        LIKE hraw_file.hraw05
   DEFINE l_hrawud13      LIKE hraw_file.hrawud13
   DEFINE l_hrawud14      LIKE hraw_file.hrawud14 
   DEFINE l_hrbh11        LIKE hrbh_file.hrbh11
   DEFINE l_hrad01        LIKE hrad_file.hrad01
    IF cl_null(g_hrbh.hrbh01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_hrbh.hrbhconf !='2' THEN
       CALL cl_err('资料还未审核或者已归档,不可再次审核','!',1)
       LET g_success='N'
       RETURN
    END IF

    LET l_hrbhmodu = g_hrbh.hrbhmodu
    LET l_hrbhdate = g_hrbh.hrbhdate
    SELECT MAX(hrbh11) INTO l_hrbh11 FROM hrbh_file WHERE hrbh01 = (SELECT hratid FROM hrat_file WHERE hrat01 = g_hrbh.hrbh01 )
    SELECT hrad01 INTO l_hrad01 FROM hrat_file,hrad_file WHERE hrat01 = g_hrbh.hrbh01  AND hrad02 = hrat19
    IF l_hrbh11 != g_hrbh.hrbh11 OR (l_hrbh11 = g_hrbh.hrbh11 AND l_hrad01 != '003' )THEN 
       CALL cl_err('该笔不是最后一次离职或员工已回聘，不可取消审核','!',1)
       RETURN 
    END IF 
    BEGIN WORK

    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("open i025_cl:",STATUS,1)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i025_cl INTO g_hrbh.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i025_cl
      ROLLBACK WORK
      RETURN
    END IF

   CALL i025_show()

   IF NOT cl_confirm("是否确定取消审核?") THEN
   ELSE
    
##############nihuan add start 20151224   
# de dao xia shu  
     # select hrat01 into l_hrat01 from hrat_file where hratid = g_hrbh.hrbh01 	
    	LET l_sql=" select hrat01 from hrat_file where hrat84='",g_hrbh.hrbh01,"' "
    	PREPARE r100_p_1 FROM l_sql 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('ghri016:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM
       END IF
       DECLARE r100_curs_1 CURSOR WITH HOLD FOR r100_p_1 
       FOREACH r100_curs_1 INTO l_hrat01_1 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF 
           UPDATE  hrat_file  
                  SET  hrat06=g_hrbh.hrbh01  
           WHERE  hrat01=l_hrat01_1 
            
#           IF SQLCA.sqlcode THEN
#                CALL cl_err3("upd","hrat_file",,,SQLCA.sqlcode,"","",1)               
#                 EXIT FOREACH 
#                ROLLBACK WORK
#             ELSE
#                COMMIT WORK
#             END IF 
            
       END FOREACH 
       
       ######jian ren shixiao riqi  nihuan add 20151224
       LET l_sql1="select hraw01,hraw02,hraw03,hraw04,hraw05,hrawud13,hrawud14 from hraw_file where hraw01='",l_hratid,"' and hraw05>=to_date('",g_hrbh.hrbh11,"','yy/mm/dd')" 
       PREPARE r025_p_2 FROM l_sql1 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('ghri016:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM
       END IF
       DECLARE r025_curs_2 CURSOR WITH HOLD FOR r025_p_2 
       FOREACH r025_curs_2 INTO l_hraw01,l_hraw02,l_hraw03,l_hraw04,l_hraw05,l_hrawud13,l_hrawud14 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF   
           
           IF not cl_null(l_hrawud13) and not cl_null(l_hrawud14) then 
              update hraw_file set hraw04=l_hrawud13,
                                   hraw05=l_hrawud14
                               where hraw01=l_hraw01 AND  hraw02=l_hraw02 AND  hraw03=l_hraw03    
           END  IF 
              
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hraw_file",l_hraw04,l_hraw05,SQLCA.sqlcode,"","",1)           
                 EXIT FOREACH 
             END IF 
       END FOREACH  
       ######jian ren shixiao  nihuan add 20151224  
        
#############nihuan add end  20151224       
     
      #回写员工信息
      IF cl_null(g_hrbh.hrbh12) THEN LET g_hrbh.hrbh12 = "2001" END IF 
      UPDATE hrat_file SET hrat19=g_hrbh.hrbh12,hrat77 = '9999/12/31' WHERE hratid=l_hratid
      IF SQLCA.SQLCODE THEN
          CALL cl_err('upd hrat:',SQLCA.SQLCODE,0)
          RETURN
      END IF
      #更新审核码
      LET g_hrbh.hrbhconf = '1'
      LET g_hrbh.hrbhmodu = g_user
      LET g_hrbh.hrbhdate = g_today

      UPDATE hrbh_file
         SET hrbhconf = g_hrbh.hrbhconf,
             hrbhmodu = g_hrbh.hrbhmodu,
             hrbhdate = g_hrbh.hrbhdate
       WHERE hrbh01 = l_hratid
        AND hrbh03 = g_hrbh.hrbh03

       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
          LET g_hrbh.hrbhconf = "2"
          LET g_hrbh.hrbhmodu = l_hrbhmodu
          LET g_hrbh.hrbhdate = l_hrbhdate
          DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
       END IF
   END IF
   CLOSE i025_cl
   COMMIT WORK
END FUNCTION

FUNCTION i025_guidang()
   DEFINE l_hrbhconf      LIKE hrbh_file.hrbhconf
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
   DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate


    IF cl_null(g_hrbh.hrbh01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_hrbh.hrbhconf !='2' THEN
       CALL cl_err('资料还未审核或者已归档,不可归档','!',1)
       LET g_success='N'
       RETURN
    END IF

    LET l_hrbhmodu = g_hrbh.hrbhmodu
    LET l_hrbhdate = g_hrbh.hrbhdate

    BEGIN WORK

    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("open i025_cl:",STATUS,1)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i025_cl INTO g_hrbh.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i025_cl
      ROLLBACK WORK
      RETURN
    END IF

   CALL i025_show()

   IF NOT cl_confirm("是否确定归档?") THEN
   ELSE
      LET g_hrbh.hrbhconf = '3'
      LET g_hrbh.hrbhmodu = g_user
      LET g_hrbh.hrbhdate = g_today

      UPDATE hrbh_file
         SET hrbhconf = g_hrbh.hrbhconf,
             hrbhmodu = g_hrbh.hrbhmodu,
             hrbhdate = g_hrbh.hrbhdate
       WHERE hrbh01 = l_hratid
          AND hrbh03 = g_hrbh.hrbh03
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
          LET g_hrbh.hrbhconf = "2"
          LET g_hrbh.hrbhmodu = l_hrbhmodu
          LET g_hrbh.hrbhdate = l_hrbhdate
          DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
       END IF
   END IF
   CLOSE i025_cl
   COMMIT WORK
END FUNCTION

FUNCTION i025_undo_guidang()
   DEFINE l_hrbhconf      LIKE hrbh_file.hrbhconf
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
   DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate


    IF cl_null(g_hrbh.hrbh01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_hrbh.hrbhconf !='3' THEN
       CALL cl_err('资料还未归档,不可取消归档','!',1)
       LET g_success='N'
       RETURN
    END IF

    LET l_hrbhmodu = g_hrbh.hrbhmodu
    LET l_hrbhdate = g_hrbh.hrbhdate

    BEGIN WORK

    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("open i025_cl:",STATUS,1)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i025_cl INTO g_hrbh.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i025_cl
      ROLLBACK WORK
      RETURN
    END IF

   CALL i025_show()

   IF NOT cl_confirm("是否确定取消归档?") THEN
   ELSE
      LET g_hrbh.hrbhconf = '2'
      LET g_hrbh.hrbhmodu = g_user
      LET g_hrbh.hrbhdate = g_today

      UPDATE hrbh_file
         SET hrbhconf = g_hrbh.hrbhconf,
             hrbhmodu = g_hrbh.hrbhmodu,
             hrbhdate = g_hrbh.hrbhdate
       WHERE hrbh01 = l_hratid
        AND hrbh03 = g_hrbh.hrbh03

       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
          LET g_hrbh.hrbhconf = '3'
          LET g_hrbh.hrbhmodu = l_hrbhmodu
          LET g_hrbh.hrbhdate = l_hrbhdate
          DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
       END IF
   END IF
   CLOSE i025_cl
   COMMIT WORK
END FUNCTION

FUNCTION i025_p_jieqing()
DEFINE l_cnt LIKE type_file.num5
   IF cl_null(g_hrat01) THEN RETURN END IF 
   LET g_hrat01 = cl_replace_str(g_hrat01,"|","','")
   LET g_sql = "SELECT COUNT(*) INTO l_cnt FROM hrbh_file WHERE hrbh01 IN ('",g_hrat01,"') AND hrbhconf = '1'"
   PREPARE i025_01 FROM g_sql
   DECLARE i025_01_cs CURSOR FOR i025_01
   FOREACH i025_01_cs INTO l_cnt
   END FOREACH 
   IF l_cnt>0 THEN 
      CALL cl_err('选择结清人员中包含未审核离职，不能结清','!',1)
      RETURN 
   END IF 
   IF NOT cl_confirm("是否确定结清?") THEN
   ELSE
      LET g_hrat01 = "'",g_hrat01,"'"
      LET g_sql = "UPDATE hrbh_file SET hrbh09 = 'Y' WHERE hrbh01 IN (",g_hrat01,")"
      PREPARE i025_02 FROM g_sql
      EXECUTE i025_02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('选择结清人员结清失败','!',1)
      ELSE
         CALL cl_err('选择结清人员结清成功','!',1)
      END IF
   END IF 
END FUNCTION 

FUNCTION i025_jieqing()
   DEFINE l_hrbh09        LIKE hrbh_file.hrbh09
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
   DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate


    IF cl_null(g_hrbh.hrbh01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_hrbh.hrbhconf ='1' THEN
       CALL cl_err('资料还未审核,不可结清','!',1)
       LET g_success='N'
       RETURN
    END IF

    IF g_hrbh.hrbh09 ='Y' THEN
       CALL cl_err('资料已结清,不可再次结清','!',1)
       LET g_success='N'
       RETURN
    END IF

    LET l_hrbhmodu = g_hrbh.hrbhmodu
    LET l_hrbhdate = g_hrbh.hrbhdate

    BEGIN WORK

    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("open i025_cl:",STATUS,1)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i025_cl INTO g_hrbh.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i025_cl
      ROLLBACK WORK
      RETURN
    END IF

   CALL i025_show()

   IF NOT cl_confirm("是否确定结清?") THEN
   ELSE
      LET g_hrbh.hrbh09 = 'Y'
      LET g_hrbh.hrbhmodu = g_user
      LET g_hrbh.hrbhdate = g_today

      UPDATE hrbh_file
         SET hrbh09 = g_hrbh.hrbh09,
             hrbhmodu = g_hrbh.hrbhmodu,
             hrbhdate = g_hrbh.hrbhdate
       WHERE hrbh01 = l_hratid
        AND hrbh03 = g_hrbh.hrbh03

       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
          LET g_hrbh.hrbh09 = 'N'
          LET g_hrbh.hrbhmodu = l_hrbhmodu
          LET g_hrbh.hrbhdate = l_hrbhdate
          DISPLAY BY NAME g_hrbh.hrbh09,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbh.hrbh09,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
       END IF
   END IF
   CLOSE i025_cl
   COMMIT WORK
END FUNCTION

FUNCTION i025_undo_jieqing()
   DEFINE l_hrbh09        LIKE hrbh_file.hrbh09
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
   DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate


    IF cl_null(g_hrbh.hrbh01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_hrbh.hrbhconf ='1' THEN
       CALL cl_err('资料还未审核,不可取消结清','!',1)
       LET g_success='N'
       RETURN
    END IF

    IF g_hrbh.hrbh09 ='N' THEN
       CALL cl_err('资料还未结清,不可取消结清','!',1)
       LET g_success='N'
       RETURN
    END IF

    LET l_hrbhmodu = g_hrbh.hrbhmodu
    LET l_hrbhdate = g_hrbh.hrbhdate

    BEGIN WORK

    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbh.hrbh01
    OPEN i025_cl USING l_hratid,g_hrbh.hrbh03
    IF STATUS THEN
       CALL cl_err("open i025_cl:",STATUS,1)
       CLOSE i025_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i025_cl INTO g_hrbh.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i025_cl
      ROLLBACK WORK
      RETURN
    END IF

   CALL i025_show()

   IF NOT cl_confirm("是否确定取消结清?") THEN
   ELSE
      LET g_hrbh.hrbh09 = 'N'
      LET g_hrbh.hrbhmodu = g_user
      LET g_hrbh.hrbhdate = g_today

      UPDATE hrbh_file
         SET hrbh09 = g_hrbh.hrbh09,
             hrbhmodu = g_hrbh.hrbhmodu,
             hrbhdate = g_hrbh.hrbhdate
       WHERE hrbh01 = l_hratid
        AND hrbh03 = g_hrbh.hrbh03

       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
          LET g_hrbh.hrbh09 = 'Y'
          LET g_hrbh.hrbhmodu = l_hrbhmodu
          LET g_hrbh.hrbhdate = l_hrbhdate
          DISPLAY BY NAME g_hrbh.hrbh09,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbh.hrbh09,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
       END IF
   END IF
   CLOSE i025_cl
   COMMIT WORK
END FUNCTION


PRIVATE FUNCTION i025_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbh01",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i025_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("hrbh01",FALSE)
   END IF
END FUNCTION
FUNCTION i025_ht()
    DEFINE p_row,p_col         LIKE type_file.num5
    DEFINE l_hrbh01            LIKE hrbh_file.hrbh01
    DEFINE l_i                 LIKE type_file.num5
    DEFINE l_sql STRING
    DEFINE g_hrbf    DYNAMIC ARRAY OF RECORD
                     hrbf01    LIKE hrbf_file.hrbf01,
                     hrbe02    LIKE hrbe_file.hrbe02,
                     hrbf08    LIKE hrbf_file.hrbf08,
                     hrbf09    LIKE hrbf_file.hrbf09,
                     hrbf10    LIKE hrbf_file.hrbf10,
                     hrag07    LIKE hrag_file.hrag07
                     END RECORD
    OPEN WINDOW i025_a_w AT p_row,p_col
    WITH FORM "ghr/42f/ghri025_a"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    SELECT hratid INTO l_hrbh01 FROM hrat_file
     WHERE hrat01 = g_hrbh.hrbh01

    LET l_sql = " SELECT hrbf01,hrbe02,hrbf08,hrbf09,hrbf10,hrag07   FROM hrbf_file,hrag_file,hrbe_file ",
                "  WHERE hrbf02 = '",l_hrbh01,"'  and hrbe01 = hrbf04 ",
                " and hrag01 ='339' and hrag06 = hrbf11 ",
                "  order by hrbf08 desc"
    PREPARE hrbf_p FROM   l_sql
    DECLARE hrbf_cl CURSOR FOR  hrbf_p
    LET l_i = 1
    FOREACH hrbf_cl INTO g_hrbf[l_i].*
       LET l_i = l_i + 1
    END FOREACH
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_hrbf TO s_hrbf.* ATTRIBUTE(COUNT=l_i)

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
    CLOSE WINDOW i025_a_w
END FUNCTION
FUNCTION i025_b()
END FUNCTION

FUNCTION i0221_assign()
  DEFINE l_hrbf01    LIKE  hrbf_file.hrbf01
  DEFINE l_hrbf08    LIKE  hrbf_file.hrbf08
  DEFINE l_hrbe02    LIKE hrbe_file.hrbe02
  DEFINE l_hrag07    LIKE hrag_file.hrag07
  IF cl_null(g_hrbh.hrbh01) THEN
    RETURN
  ELSE
    #INSERT INTO g_hrbf VALUES select * from hrbf_file where hrbf09=(select max(hrbf09) from hrbf_file where hrbf02=g_hrbh.hrbh01) and hrbf02=g_hrbh.hrbh01 and rownum = 1
    select hratid into g_hratid from hrat_file where hrat01=g_hrbh.hrbh01
    select hrbf01,hrbf02,hrbf03,hrbf04,hrbf05,hrbf06,hrbf07,hrbf08,hrbf09,hrbf10,hrbf11,hrbf12
      INTO g_hrbf.hrbf01,g_hrbf.hrbf02,g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,g_hrbf.hrbf06,g_hrbf.hrbf07,g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,g_hrbf.hrbf11,g_hrbf.hrbf12
    from hrbf_file where hrbf09=(select max(hrbf09) from hrbf_file where hrbf02=g_hratid) and hrbf02=g_hratid and rownum = 1
    IF cl_null(g_hrbf.hrbf01) THEN
      CALL cl_err('此员工没有合同','',1)
      RETURN
    END IF
  END IF
  LET g_hrbf.hrbf09 = g_hrbh.hrbh04
  OPEN WINDOW i0221_w1 WITH FORM "ghr/42f/ghri0221"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
  CALL cl_ui_init()
  LET g_hrbf.hrbfacti = 'Y'
  LET g_hrbf.hrbfuser = g_user
  LET g_hrbf.hrbfgrup = g_grup
  LET g_hrbf.hrbfmodu = g_user
  LET g_hrbf.hrbfdate = g_today
  LET g_hrbf.hrbforiu = g_user
  LET g_hrbf.hrbforig = g_grup
  WHILE TRUE
    DISPLAY BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12

  SELECT hrbe02 INTO l_hrbe02 FROM hrbe_file WHERE hrbe01=g_hrbf.hrbf04
  DISPLAY l_hrbe02 TO hrbf04_name
  select hrag07 into l_hrag07 from hrag_file where hrag01='339' and hrag06=g_hrbf.hrbf11
  DISPLAY l_hrag07 TO hrbf11_name
    INPUT BY NAME g_hrbf.hrbf09,g_hrbf.hrbf12
                    WITHOUT DEFAULTS
      BEFORE INPUT

        ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT INPUT

        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

        ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

        ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121

        ON ACTION exit
          LET INT_FLAG = 1
        EXIT INPUT
      END INPUT
        IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
        END IF
        IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i0221_w1
         RETURN
        ELSE
          IF g_hrbf.hrbf08 > g_hrbf.hrbf09 THEN
            CALL cl_err('',-9913,0)
            LET INT_FLAG = 0
            CONTINUE WHILE
          END IF
        END IF
    EXIT WHILE
  END WHILE

  IF NOT cl_null(g_hrbf.hrbf09) THEN 
  UPDATE hrbf_file SET hrbf09=g_hrbf.hrbf09,hrbf12=g_hrbf.hrbf12 where hrbf01=g_hrbf.hrbf01
  END IF
  CLOSE WINDOW i0221_w1
END FUNCTION
FUNCTION i025_b_menu()
   WHILE TRUE

      CALL i025_bp("G")  

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrbh_file.* 
           INTO g_hrbh.* 
           FROM hrbh_file 
          WHERE hrbh01=g_hrbh_1[l_ac].hrbh01_2
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'pg'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i025_fetch('/')
         END IF
      END IF

      CASE g_action_choice
           WHEN "insert"
               IF cl_chk_act_auth() THEN   
                  CALL i025_a()
               END IF
               EXIT WHILE

           WHEN "query"
               IF cl_chk_act_auth() THEN  
                    CALL i025_q()
               END IF
               EXIT WHILE
           
           WHEN "modify"
               IF cl_chk_act_auth() THEN   
                  LET g_curs_index = ARR_CURR()
                  CALL i025_u()
               END IF
               EXIT WHILE
           
           WHEN "exporttoexcel"
              IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbh_1),'','')
              END IF
           
           WHEN "delete"
               IF cl_chk_act_auth() THEN   
                  CALL i025_r()
               END IF
           
           WHEN "help"
               CALL cl_show_help()
           
           WHEN "locale"
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()                 

           WHEN "exit"
              EXIT WHILE
           
           WHEN "g_idle_seconds"
              CALL cl_on_idle()
           
           WHEN "about"
              CALL cl_about()      
           
           WHEN "controlg"     
              CALL cl_cmdask()     
           
           OTHERWISE 
               EXIT WHILE
      END CASE
   END WHILE

END FUNCTION 


FUNCTION i025_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbh_1 TO s_hrbh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
   BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
#      ON ACTION pg
#         LET g_bp_flag = 'pg'
#         LET l_ac = ARR_CURR()
#         LET g_jump = l_ac
#         LET g_no_ask = TRUE
#         IF g_rec_b >0 THEN
#             CALL i025_fetch('/')
#         END IF
#         CALL cl_set_comp_visible("Page4", FALSE)
#         CALL ui.interface.refresh() 
#         CALL cl_set_comp_visible("Page4", TRUE)
#         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i025_fetch('/')
         CALL cl_set_comp_visible("Page2,Page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2,Page4", TRUE)
         EXIT DISPLAY
 
      ON ACTION next
         CALL i025_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION previous
         CALL i025_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION jump
         CALL i025_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION first
         CALL i025_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION last
         CALL i025_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"   #MOD-A70076
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
   IF INT_FLAG THEN
      CALL cl_set_comp_visible("Page2", FALSE)
      CALL cl_set_comp_visible("Page4", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("Page2", TRUE)
      CALL cl_set_comp_visible("Pag4", TRUE)
      LET INT_FLAG = 0
   END IF
END FUNCTION
FUNCTION i025_list_fill()
  DEFINE l_hrbh01         LIKE hrbh_file.hrbh01,
         l_hrbh03         LIKE hrbh_file.hrbh03
  DEFINE l_i             LIKE type_file.num10
  
  CALL g_hrbh_1.clear()
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbhuser', 'hrbhgrup')
   IF cl_null(g_wc) THEN 
      LET g_wc=" 1=1"
   END IF 

#   LET g_sql = "SELECT hratid,hrbh03 FROM hrat_file
#                left join hrad_file on hrad02=hrat19 
#                left join hrbh_file on hrbh01=hratid
#                WHERE  hratconf='Y' and hrad01='003' AND ",g_wc CLIPPED,
#                "ORDER BY hrbh01 " 
   LET g_sql = "SELECT hrbh01,hrbh03 FROM hrbh_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hrbh01=hratid ",
                " ORDER BY hrbh01"
               
   PREPARE i025sub_prepare FROM g_sql


   DECLARE i025sub_list_cur CURSOR FOR i025sub_prepare  
   
   
    LET l_i = 1
    FOREACH i025sub_list_cur INTO l_hrbh01,l_hrbh03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT hrat01,hrbh02,hrat25,hrbiud02,hrbh03,hrbh04,hrbh05,
              hrbh06,hrbhconf,hrbh12,hrbh11,hrbh07,hrbh08,hrbhmodu    
         INTO g_hrbh_1[l_i].hrbh01_2,g_hrbh_1[l_i].hrbh02_a,
              g_hrbh_1[l_i].hrat25_2,g_hrbh_1[l_i].hrbiud02_2,
              g_hrbh_1[l_i].hrbh03_2,g_hrbh_1[l_i].hrbh04_2,
              g_hrbh_1[l_i].hrbh05_2,g_hrbh_1[l_i].hrbh06_2,
              g_hrbh_1[l_i].hrbhconf_2,g_hrbh_1[l_i].hrbh12_2,
              g_hrbh_1[l_i].hrbh11_2,g_hrbh_1[l_i].hrbh07_2,
               g_hrbh_1[l_i].hrbh08_2,g_hrbh_1[l_i].hrbhmodu_n
         FROM hrbh_file
         LEFT join hrat_file ON hratid=hrbh01
         LEFT join hrbi_file ON hrbi01=hrbh01 AND hrbiud22 = hrbh11
        WHERE hrbh01 =l_hrbh01 AND hrbh03=l_hrbh03
    
    SELECT hrat02 INTO g_hrbh_1[l_i].hrbhmodu_n FROM hrat_file WHERE hrat01=g_hrbh_1[l_i].hrbhmodu_n
             
    SELECT hrag07 INTO g_hrbh_1[l_i].hrbh05_desc_2 FROM hrag_file
     WHERE hrag01='310' AND hrag06=g_hrbh_1[l_i].hrbh05_2
    SELECT hrad03 INTO g_hrbh_1[l_i].hrbh06_desc_2 FROM hrad_file
     WHERE hrad02=g_hrbh_1[l_i].hrbh06_2
    SELECT hrad03 INTO g_hrbh_1[l_i].hrbh12_desc_2 FROM hrad_file
     WHERE hrad02=g_hrbh_1[l_i].hrbh12_2 
#         
#        SELECT hrat02,hrat04,hrat05,hrat06,hrat17,hrat22,hrat42,hrat66
#         INTO g_hrbh_1[l_i].hrat02_2,g_hrbh_1[l_i].hrat04_2,
#              g_hrbh_1[l_i].hrat05_2,g_hrbh_1[l_i].hrat06_2,
#              g_hrbh_1[l_i].hrat17_2,g_hrbh_1[l_i].hrat22_2,
#              g_hrbh_1[l_i].hrat42_2,g_hrbh_1[l_i].hrat66_2
#        FROM hrat_file WHERE hrat01=g_hrbh_1[l_i].hrbh01_2 
#         
#        SELECT hrao02 INTO g_hrbh_1[l_i].hrat04_desc_2 
#        FROM hrao_file WHERE hrao01=g_hrbh_1[l_i].hrat04_2 
#         
#        SELECT hras04 INTO g_hrbh_1[l_i].hrat05_desc_2 
#        FROM hras_file WHERE hras01=g_hrbh_1[l_i].hrat05
#          
          SELECT a.hrat02,a.hrat04,
                 b.hrao02,a.hrat05,
                 c.hras04,a.hrat06,
                 d.hrat02,a.hrat17,
                 e.hrag07,a.hrat22,
                 f.hrag07,a.hrat20,
                 k.hrag07,a.hrat25
           INTO g_hrbh_1[l_i].hrat02_2,g_hrbh_1[l_i].hrat04_2,
                g_hrbh_1[l_i].hrat04_desc_2,g_hrbh_1[l_i].hrat05_2,
                g_hrbh_1[l_i].hrat05_desc_2,g_hrbh_1[l_i].hrat06_2,
                g_hrbh_1[l_i].hrat06_desc_2,g_hrbh_1[l_i].hrat17_2,
                g_hrbh_1[l_i].hrat17_desc_2,g_hrbh_1[l_i].hrat22_2,
                g_hrbh_1[l_i].hrat22_desc_2,g_hrbh_1[l_i].hrat42_2,
                g_hrbh_1[l_i].hrat42_desc_2,g_hrbh_1[l_i].hrat66_2
           FROM hrat_file a
           LEFT JOIN hrao_file b ON hrao01=hrat04
           LEFT JOIN hras_file c ON hras01=hrat05
           LEFT JOIN hrat_file d ON d.hrat01=a.hrat06
           LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
           LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
           LEFT JOIN hrad_file g ON g.hrad02=a.hrat19
           LEFT JOIN hrag_file k ON k.hrag06=a.hrat20 AND k.hrag01='313'
           WHERE a.hrat01=g_hrbh_1[l_i].hrbh01_2 AND a.hratconf='Y'
            
             
             

        LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
     CALL g_hrbh_1.deleteElement(l_i)
   # LET g_rec_b = l_i - 1
    DISPLAY ARRAY g_hrbh_1 TO s_hrbh.* #ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
          
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY   
    END DISPLAY
END FUNCTION
FUNCTION i025_p_shenhe()
DEFINE l_sql_w  STRING 
DEFINE l_hrat01 LIKE hrat_file.hrat01
DEFINE l_hrbh03 LIKE hrbh_file.hrbh03
DEFINE l_hrbhconf LIKE hrbh_file.hrbhconf
DEFINE l_hrbhmodu LIKE hrbh_file.hrbhmodu
DEFINE l_hrbhdate LIKE hrbh_file.hrbhdate
DEFINE l_hrbh    RECORD LIKE hrbh_file.*
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrat03         LIKE hrat_file.hrat03
DEFINE l_hrat04         LIKE hrat_file.hrat04
DEFINE l_hrat05         LIKE hrat_file.hrat05
DEFINE l_hrat06         LIKE hrat_file.hrat06
DEFINE l_hrat42         LIKE hrat_file.hrat42
DEFINE l_hrat25         LIKE hrat_file.hrat25
   IF cl_null(g_hrat01) THEN RETURN END IF 
   LET g_hrat01 = cl_replace_str(g_hrat01,"|","','")
   LET l_sql_w = "SELECT hrat01,hrbh03,hrbhconf,hrbhmodu,hrbhdate FROM hrbh_file left join hrat_file on hrbh01=hratid WHERE hrbh01 IN ('",g_hrat01,"') AND hrbhconf = '1'"
   PREPARE i025_shw FROM l_sql_w
   DECLARE i025_shcw_cs CURSOR FOR i025_shw
   FOREACH i025_shcw_cs INTO l_hrat01,l_hrbh03,l_hrbhconf,l_hrbhmodu,l_hrbhdate
         SELECT hratid,hrat03,hrat04,hrat05,hrat06,hrat20,hrat25 INTO l_hratid, l_hrat03, l_hrat04, l_hrat05, l_hrat06, l_hrat42, l_hrat25 FROM hrat_file WHERE   hrat01 = l_hrat01
         SELECT * INTO l_hrbh.* FROM hrbh_file WHERE hrbh01 = l_hratid AND hrbh03 = l_hrbh03
         #回写员工信息
         UPDATE hrat_file SET hrat07='N',hrat19=l_hrbh.hrbh06,hrat77 = l_hrbh.hrbh11 WHERE hratid=l_hratid 
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新离职人员信息失败','!',1)
            CONTINUE FOREACH 
         END IF 
         
         #更新员工合同协议信息
         UPDATE hrbf_file SET hrbf09=l_hrbh.hrbh04 WHERE hrbf02=l_hratid AND l_hrbh.hrbh04>hrbf08 AND l_hrbh.hrbh04<hrbf09
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新人员合同协议信息失败','!',1)
            CONTINUE FOREACH 
         END IF 
         
         #清除预生成考勤数据
         DELETE FROM hrcp_file WHERE hrcp02=l_hratid AND hrcp03>l_hrbh.hrbh11    #add by yinbq 20141104 for 离职审批通过后将因离职补录造成的已经生成的点名异常数据清除
         IF SQLCA.SQLCODE THEN
            CALL cl_err('清除预生成考勤数据失败','!',1)
            CONTINUE FOREACH 
         END IF
         
         #更新审核码
         LET l_hrbh.hrbhconf = '2'
         LET l_hrbh.hrbhmodu = g_user
         LET l_hrbh.hrbhdate = g_today
         
         UPDATE hrbh_file SET hrbhconf = l_hrbh.hrbhconf,
                              hrbhmodu = l_hrbh.hrbhmodu,
                              hrbhdate = l_hrbh.hrbhdate,
                              hrbhud02 = l_hrat03,
                              hrbhud03 = l_hrat04,
                              hrbhud04 = l_hrat05,
                              hrbhud05 = l_hrat06,
                              hrbhud06 = l_hrat42,
                              hrbhud13 = l_hrat25
            WHERE hrbh01 = l_hratid AND hrbh03 = l_hrbh.hrbh03


         
   END FOREACH 
   CALL cl_err('批量离退成功','!','1')
END FUNCTION 

FUNCTION i025_p_confirm(p_hrat01,p_date,p_conf,p_hrbhmodu,p_hrbhdate)
DEFINE p_hrat01        LIKE hrat_file.hrat01
DEFINE p_date          LIKE hrbh_file.hrbh03
DEFINE p_conf          LIKE hrbh_file.hrbhconf
DEFINE p_hrbhmodu      LIKE hrbh_file.hrbhmodu 
DEFINE p_hrbhdate      LIKE hrbh_file.hrbhdate
DEFINE l_hrbhconf      LIKE hrbh_file.hrbhconf
DEFINE l_msg           STRING
DEFINE l_n             LIKE type_file.num5
DEFINE l_hratid,l_hratid_1        LIKE hrat_file.hratid
DEFINE l_hrbhmodu      LIKE hrbh_file.hrbhmodu
DEFINE l_hrbhdate      LIKE hrbh_file.hrbhdate
DEFINE l_hrbe01        LIKE hrbe_file.hrbe01

DEFINE l_sql,l_sql1    string
DEFINE l_hrat01        LIKE hrat_file.hrat01
DEFINE l_hrat01_1      LIKE hrat_file.hrat01
DEFINE l_hraw01        LIKE hraw_file.hraw01
DEFINE l_hraw02        LIKE hraw_file.hraw02 
DEFINE l_hraw03        LIKE hraw_file.hraw03
DEFINE l_hraw04        LIKE hraw_file.hraw04
DEFINE l_hraw05        LIKE hraw_file.hraw05
DEFINE l_hraw07        LIKE hraw_file.hraw07
DEFINE l_hrat03         LIKE hrat_file.hrat03
DEFINE l_hrat04         LIKE hrat_file.hrat04
DEFINE l_hrat05         LIKE hrat_file.hrat05
DEFINE l_hrat06         LIKE hrat_file.hrat06
DEFINE l_hrat42         LIKE hrat_file.hrat42
DEFINE l_hrat25         LIKE hrat_file.hrat25

#   IF cl_null(p_hrat01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   IF p_conf !='1' THEN
#      CALL cl_err('资料已审核或者已归档,不可再次审核','!',1)  
#      LET g_success='N'
#      RETURN
#   END IF
   
   LET l_hrbhmodu = p_hrbhmodu
   LET l_hrbhdate = p_hrbhdate

   BEGIN WORK
      SELECT hratid,hrat03,hrat04,hrat05,hrat06,hrat20,hrat25 INTO l_hratid, l_hrat03, l_hrat04, l_hrat05, l_hrat06, l_hrat42, l_hrat25 FROM hrat_file WHERE hrat01=p_hrat01

      
       SELECT * INTO g_hrbh.* FROM hrbh_file WHERE hrbh01 = l_hratid AND hrbh03 = p_date


      #CALL i025_show()

      #IF NOT cl_confirm("是否确定审核?") THEN
      #ELSE
         IF NOT cl_null(g_hrbh.hrbh13) THEN 
            #处理直接主管指向离职人员的信息
       	   LET l_sql=" select hrat01 from hrat_file where hrat06='",g_hrbh.hrbh01,"' "
       	   PREPARE r100_sh_p FROM l_sql 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('ghri016:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
            DECLARE r100_sh_curs CURSOR WITH HOLD FOR r100_sh_p 
            FOREACH r100_sh_curs INTO l_hrat01_1 
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF 
               UPDATE  hrat_file SET  hrat06=g_hrbh.hrbh13, hrat84=g_hrbh.hrbh01 WHERE  hrat01=l_hrat01_1 
               IF SQLCA.sqlcode THEN
                  CALL cl_err("更新继任者相关失败","!",1)
                  ROLLBACK WORK
                  RETURN
               END IF
            END FOREACH 
            
            #更新参退保管理负责人信息
            SELECT hratid INTO l_hratid_1 FROM hrat_file WHERE hrat01 = g_hrbh.hrbh13
            UPDATE hrdu_file SET ta_hrdu02 = l_hratid_1 WHERE  ta_hrdu02 = l_hratid
            IF SQLCA.SQLCODE THEN
               CALL cl_err('更新社保负责人信息失败','!',1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF 
            
         #处理兼职相关信息
         LET l_sql1="select hraw01,hraw02,hraw03,hraw04,hraw05,hraw07 from hraw_file where hraw01='",l_hratid,"' and hraw05>=to_date('",g_hrbh.hrbh11,"','yy/mm/dd')" 
         PREPARE r025_sh_p FROM l_sql1 
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('ghri016:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
         END IF
         DECLARE r025_sh_curs CURSOR WITH HOLD FOR r025_sh_p 
         FOREACH r025_sh_curs INTO l_hraw01,l_hraw02,l_hraw03,l_hraw04,l_hraw05,l_hraw07
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE hraw_file SET  hraw05=g_hrbh.hrbh11, hrawud13=l_hraw04, hrawud14=l_hraw05
                   WHERE  hraw01=l_hraw01 AND  hraw02=l_hraw02 AND  hraw03=l_hraw03 AND hraw04=l_hraw04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hraw_file",l_hraw04,l_hraw05,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               EXIT FOREACH 
            END IF
            #部门主管的调整暂时不做，因不确定继任者是否须要额外添加兼职信息
         END FOREACH
    
         #回写员工信息
         UPDATE hrat_file SET hrat07='N',hrat19=g_hrbh.hrbh06,hrat77 = g_hrbh.hrbh11 WHERE hratid=l_hratid 
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新离职人员信息失败','!',1)
            ROLLBACK WORK
            RETURN 
         END IF 
         
         #更新员工电子卡信息
         UPDATE hrbw_file SET hrbwud02 = '2', hrbwud04 = '2', hrbw06 = g_hrbh.hrbh11 WHERE hrbw01=l_hratid
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新人员考勤卡信息失败','!',1)
            ROLLBACK WORK
            RETURN 
         END IF 
         
         #更新员工合同协议信息
         UPDATE hrbf_file SET hrbf09=g_hrbh.hrbh04 WHERE hrbf02=l_hratid AND g_hrbh.hrbh04>hrbf08 AND g_hrbh.hrbh04<hrbf09
         IF SQLCA.sqlcode THEN
            CALL cl_err('更新人员合同协议信息失败','!',1)
            ROLLBACK WORK
            RETURN 
         END IF 
         
         #清除预生成考勤数据
         DELETE FROM hrcp_file WHERE hrcp02=l_hratid AND hrcp03>g_hrbh.hrbh11    #add by yinbq 20141104 for 离职审批通过后将因离职补录造成的已经生成的点名异常数据清除
         IF SQLCA.SQLCODE THEN
            CALL cl_err('清除预生成考勤数据失败','!',1)
            ROLLBACK WORK
            RETURN
         END IF
         
         #更新审核码
         LET g_hrbh.hrbhconf = '2'
         LET g_hrbh.hrbhmodu = g_user
         LET g_hrbh.hrbhdate = g_today
         
         UPDATE hrbh_file SET hrbhconf = g_hrbh.hrbhconf,
                              hrbhmodu = g_hrbh.hrbhmodu,
                              hrbhdate = g_hrbh.hrbhdate,
                              hrbhud02 = l_hrat03,
                              hrbhud03 = l_hrat04,
                              hrbhud04 = l_hrat05,
                              hrbhud05 = l_hrat06,
                              hrbhud06 = l_hrat42,
                              hrbhud13 = l_hrat25
            WHERE hrbh01 = l_hratid AND hrbh03 = g_hrbh.hrbh03

         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd hrbh:',SQLCA.SQLCODE,0)
            LET g_hrbh.hrbhconf = "1"
            LET g_hrbh.hrbhmodu = l_hrbhmodu
            LET g_hrbh.hrbhdate = l_hrbhdate
            DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
            ROLLBACK WORK
            RETURN
#         ELSE
#            DISPLAY BY NAME g_hrbh.hrbhconf,g_hrbh.hrbhmodu,g_hrbh.hrbhdate
         END IF
   #END IF
   COMMIT WORK
END FUNCTION
FUNCTION i025_p_hmd()
DEFINE l_hrbj   RECORD LIKE hrbj_file.*
DEFINE l_sql_h  STRING
DEFINE l_hrat01 LIKE hrat_file.hrat01
DEFINE l_hrbh03 LIKE hrbh_file.hrbh03
IF cl_null(g_hrat01) THEN RETURN END IF 
   LET g_hrat01 = cl_replace_str(g_hrat01,"|","','")
   LET l_sql_h = "SELECT hrat01,hrbh03 FROM hrbh_file left join hrat_file on hrbh01=hratid WHERE hrbh01 IN ('",g_hrat01,"') AND hrbhconf <> '1'"
   PREPARE i025_hmd FROM l_sql_h
   DECLARE i025_hmd_cs CURSOR FOR i025_hmd
   FOREACH i025_hmd_cs INTO l_hrat01,l_hrbh03
        LET l_hrbj.hrbj17 = g_today       
        LET l_hrbj.hrbjuser = g_user
        LET l_hrbj.hrbjoriu = g_user 
        LET l_hrbj.hrbjorig = g_grup 
        LET l_hrbj.hrbjgrup = g_grup               
        LET l_hrbj.hrbjdate = g_today
        LET l_hrbj.hrbjacti = 'Y'
        SELECT TO_CHAR(MAX(hrbj01)+1,'fm999999999999') INTO l_hrbj.hrbj01 FROM hrbj_file 
         WHERE substr(hrbj01,1,8) LIKE to_char(sysdate,'yyyyMMdd')
        IF l_hrbj.hrbj01 IS NULL THEN 
        	 LET l_hrbj.hrbj01 = g_today USING "yyyymmdd"||'0001'
        END IF 
        SELECT  hratid,hrat02,
                hrat17,hrat15,hrat12,hrat13,
                hrat29,hrat24,hrat18,hrat45,
                hrat46,hrat49,hrat51,hrat22,
                hrat23
           INTO l_hrbj.hrbj02,l_hrbj.hrbj03,
                l_hrbj.hrbj07,l_hrbj.hrbj06,l_hrbj.hrbj04,l_hrbj.hrbj05,
                l_hrbj.hrbj08,l_hrbj.hrbj09,l_hrbj.hrbj10,l_hrbj.hrbj11,
                l_hrbj.hrbj12,l_hrbj.hrbj13,l_hrbj.hrbj14,l_hrbj.hrbj15,
                l_hrbj.hrbj16
           FROM hrat_file
          WHERE hrat01 = l_hrat01
            AND hratconf = 'Y'
            AND ROWNUM = 1
        INSERT INTO hrbj_file VALUES(l_hrbj.*)     # DISK WRITE
   END FOREACH 
   CALL cl_err('批量插入黑名单成功','!','1')
END FUNCTION 
