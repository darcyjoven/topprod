# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csft511.4gl
# Descriptions...: 工单调拨维护作业
# Date & Author..: 20160903 by gujq

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tc_imm           RECORD LIKE tc_imm_file.*,
    g_tc_imm_t         RECORD LIKE tc_imm_file.*,
    g_tc_imm_o         RECORD LIKE tc_imm_file.*,
    g_tc_imm01_t       LIKE tc_imm_file.tc_imm01,
    g_tc_imn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imn02            LIKE tc_imn_file.tc_imn02,          #项次
        tc_imn03            LIKE tc_imn_file.tc_imn03,          #工单单号
        tc_imn04            LIKE tc_imn_file.tc_imn04,          #作业编号
        ecd02               LIKE ecd_file.ecd02,                #作业名称
        tc_imn05            LIKE tc_imn_file.tc_imn05,          #生产料号
        ima02               LIKE ima_file.ima02,                #品名
        ima021              LIKE ima_file.ima021,               #规格
        tc_imn06            LIKE tc_imn_file.tc_imn06           #生产数量
                    END RECORD,
    g_tc_imn_t         RECORD                     #程式變數 (舊值)
        tc_imn02            LIKE tc_imn_file.tc_imn02,          #项次
        tc_imn03            LIKE tc_imn_file.tc_imn03,          #工单单号
        tc_imn04            LIKE tc_imn_file.tc_imn04,          #作业编号
        ecd02               LIKE ecd_file.ecd02,                #作业名称
        tc_imn05            LIKE tc_imn_file.tc_imn05,          #生产料号
        ima02               LIKE ima_file.ima02,                #品名
        ima021              LIKE ima_file.ima021,               #规格
        tc_imn06            LIKE tc_imn_file.tc_imn06           #生产数量
                    END RECORD,
    g_tc_imp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imp02            LIKE tc_imp_file.tc_imp02,          #项次
        tc_imp05            LIKE tc_imp_file.tc_imp05,          #料号
        ima02_1             LIKE ima_file.ima02,                #品名
        ima021_1            LIKE ima_file.ima021,               #规格
        tc_imp06            LIKE tc_imp_file.tc_imp06,          #仓库
        imd02               LIKE imd_file.imd02,                #仓库名称
        tc_imp07            LIKE tc_imp_file.tc_imp07,          #申请人
        gen02_1             LIKE gen_file.gen02,                #姓名
        tc_imp08            LIKE tc_imp_file.tc_imp08,          #申请数量
        tc_imp09            LIKE tc_imp_file.tc_imp09           #实际领用数量
                    END RECORD,
    g_tc_imp_t         RECORD
        tc_imp02            LIKE tc_imp_file.tc_imp02,          #项次
        tc_imp05            LIKE tc_imp_file.tc_imp05,          #料号
        ima02_1             LIKE ima_file.ima02,                #品名
        ima021_1            LIKE ima_file.ima021,               #规格
        tc_imp06            LIKE tc_imp_file.tc_imp06,          #仓库
        imd02               LIKE imd_file.imd02,                #仓库名称
        tc_imp07            LIKE tc_imp_file.tc_imp07,          #申请人
        gen02_1             LIKE gen_file.gen02,                #姓名
        tc_imp08            LIKE tc_imp_file.tc_imp08,          #申请数量
        tc_imp09            LIKE tc_imp_file.tc_imp09           #实际领用数量
                    END RECORD,
    g_tc_imq           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imq02   LIKE tc_imq_file.tc_imq02,                   #项次
        tc_imq03   LIKE tc_imq_file.tc_imq03,                   #工单单号
        tc_imq04   LIKE tc_imq_file.tc_imq04,                   #作业编号
        tc_imq05   LIKE tc_imq_file.tc_imq05,                   #料号
        ima02_2    LIKE ima_file.ima02,                         #品名
        ima021_2   LIKE ima_file.ima021,                        #规格
        tc_imq06   LIKE tc_imq_file.tc_imq06,                   #拨出仓库
        tc_imq07   LIKE tc_imq_file.tc_imq07,                   #储位
        tc_imq08   LIKE tc_imq_file.tc_imq08,                   #批号
        tc_imq09   LIKE tc_imq_file.tc_imq09,                   #拨出单位
        tc_imq10   LIKE tc_imq_file.tc_imq10,                   #拨入仓库
        tc_imq11   LIKE tc_imq_file.tc_imq11,                   #储位
        tc_imq12   LIKE tc_imq_file.tc_imq12,                   #批号
        tc_imq13   LIKE tc_imq_file.tc_imq13,                   #拨入单位
        tc_imq14   LIKE tc_imq_file.tc_imq14,                   #拨出数量
        tc_imq15   LIKE tc_imq_file.tc_imq15,                   #拨入数量
        tc_imq16   LIKE tc_imq_file.tc_imq16,                   #单位转换
        tc_imq17   LIKE tc_imq_file.tc_imq17,                   #理由码
        azf03      LIKE azf_file.azf03,                         #理由码说明
        tc_imq18   LIKE tc_imq_file.tc_imq18                    #备注
                    END RECORD,
    g_tc_imq_t         RECORD
        tc_imq02   LIKE tc_imq_file.tc_imq02,                   #项次
        tc_imq03   LIKE tc_imq_file.tc_imq03,                   #工单单号
        tc_imq04   LIKE tc_imq_file.tc_imq04,                   #作业编号
        tc_imq05   LIKE tc_imq_file.tc_imq05,                   #料号
        ima02_2    LIKE ima_file.ima02,                         #品名
        ima021_2   LIKE ima_file.ima021,                        #规格
        tc_imq06   LIKE tc_imq_file.tc_imq06,                   #拨出仓库
        tc_imq07   LIKE tc_imq_file.tc_imq07,                   #储位
        tc_imq08   LIKE tc_imq_file.tc_imq08,                   #批号
        tc_imq09   LIKE tc_imq_file.tc_imq09,                   #拨出单位
        tc_imq10   LIKE tc_imq_file.tc_imq10,                   #拨入仓库
        tc_imq11   LIKE tc_imq_file.tc_imq11,                   #储位
        tc_imq12   LIKE tc_imq_file.tc_imq12,                   #批号
        tc_imq13   LIKE tc_imq_file.tc_imq13,                   #拨入单位
        tc_imq14   LIKE tc_imq_file.tc_imq14,                   #拨出数量
        tc_imq15   LIKE tc_imq_file.tc_imq15,                   #拨入数量
        tc_imq16   LIKE tc_imq_file.tc_imq16,                   #单位转换
        tc_imq17   LIKE tc_imq_file.tc_imq17,                   #理由码
        azf03      LIKE azf_file.azf03,                         #理由码说明
        tc_imq18   LIKE tc_imq_file.tc_imq18                    #备注
                    END RECORD,
    g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2    STRING,
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4    LIKE type_file.num5, #單身筆數
    g_fic03         LIKE fic_file.fic03,
    g_t1            LIKE type_file.chr3,
    l_ac            LIKE type_file.num5                         #目前處理的ARRAY CNT
DEFINE g_tc_imq05_t    LIKE tc_imq_file.tc_imq05
 
#主程式開始
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  l_action_flag        STRING    
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_i             LIKE type_file.num5
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  g_void          LIKE type_file.chr1
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)
         RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM tc_imm_file WHERE tc_imm01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i511_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 5
 
   OPEN WINDOW i511_w AT 2,2 WITH FORM "csf/42f/csft511"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL i511_menu()
 
   CLOSE WINDOW i511_w
   CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i511_cs()
DEFINE    l_type          LIKE type_file.chr2
   CLEAR FORM                                      #清除畫面
   CALL g_tc_imn.clear()
   CALL g_tc_imp.clear()
   CALL g_tc_imq.clear()
   CALL cl_set_head_visible("folder01","YES")
 
   INITIALIZE g_tc_imm.* TO NULL

   CONSTRUCT BY NAME g_wc ON tc_imm01,tc_imm02,tc_immud13,tc_imm14,tc_imm16,
                             tc_imm08,tc_imm10,tc_immconf,tc_imm03,tc_imm09
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imm01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_faj3"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm01
               NEXT FIELD tc_imm01
            WHEN INFIELD(tc_imm14)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm14
               NEXT FIELD tc_imm14
            WHEN INFIELD(tc_imm16)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm16
               NEXT FIELD tc_imm16
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()

   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc2 = " 1=1"
   CONSTRUCT g_wc2 ON tc_imn02,tc_imn03,tc_imn04,tc_imn05,tc_imn06
        FROM s_tc_imn[1].tc_imn02,s_tc_imn[1].tc_imn03,s_tc_imn[1].tc_imn04,s_tc_imn[1].tc_imn05,s_tc_imn[1].tc_imn06
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imn03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imn03
               NEXT FIELD tc_imn03
            WHEN INFIELD(tc_imn04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imn04
               NEXT FIELD tc_imn04
            WHEN INFIELD(tc_imn05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imn05
               NEXT FIELD tc_imn05
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

   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc3 = " 1=1"
   CONSTRUCT g_wc3 ON tc_imp02,tc_imp05,tc_imp06,tc_imp07,tc_imp08,tc_imp09
         FROM s_tc_imp[1].tc_imp02,s_tc_imp[1].tc_imp05,s_tc_imp[1].tc_imp06,
              s_tc_imp[1].tc_imp07,s_tc_imp[1].tc_imp08,s_tc_imp[1].tc_imp09
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imp05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imp05
               NEXT FIELD tc_imp05
            WHEN INFIELD(tc_imp06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imp06
               NEXT FIELD tc_imp06
            WHEN INFIELD(tc_imp07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imp07
               NEXT FIELD tc_imp07
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
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   	
   LET g_wc4 = " 1=1"
   CONSTRUCT g_wc4 ON tc_imq02,tc_imq03,tc_imq04,tc_imq05,tc_imq06,
                      tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,
                      tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,
                      tc_imq17,tc_imq18
         FROM s_tc_imp[1].tc_imq02,s_tc_imp[1].tc_imq03,s_tc_imp[1].tc_imq04,s_tc_imp[1].tc_imq05,s_tc_imp[1].tc_imq06,
              s_tc_imp[1].tc_imq07,s_tc_imp[1].tc_imq08,s_tc_imp[1].tc_imq09,s_tc_imp[1].tc_imq10,s_tc_imp[1].tc_imq11,
              s_tc_imp[1].tc_imq12,s_tc_imp[1].tc_imq13,s_tc_imp[1].tc_imq14,s_tc_imp[1].tc_imq15,s_tc_imp[1].tc_imq16,
              s_tc_imp[1].tc_imq17,s_tc_imp[1].tc_imq18
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imq03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imq03
               NEXT FIELD tc_imq03
            WHEN INFIELD(tc_imq04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imq04
               NEXT FIELD tc_imq04
            WHEN INFIELD(tc_imq05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imq05
               NEXT FIELD tc_imq05
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
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_immuser', 'tc_immgrup')

   LET g_sql  = "SELECT tc_imm01 "
   LET g_sql1 = " FROM tc_imm_file "
   LET g_sql2 = " WHERE ", g_wc CLIPPED
 
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imn_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_imm01=tc_imn01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imp_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_imm01=tc_imp01",
                                 " AND ",g_wc3 CLIPPED
   END IF
   IF g_wc4 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imq_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_imm01=tc_imq01",
                                 " AND ",g_wc4 CLIPPED
   END IF
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY tc_imm01'
 
   PREPARE i511_prepare FROM g_sql
   DECLARE i511_cs SCROLL CURSOR WITH HOLD FOR i511_prepare
 
   LET g_sql  = "SELECT COUNT(UNIQUE tc_imm01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE i511_precount FROM g_sql
   DECLARE i511_count CURSOR FOR i511_precount
END FUNCTION
 
FUNCTION i511_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "Page1")
            CALL i511_bp2("G")
         WHEN (l_action_flag = "Page2")
            CALL i511_bp3("G")
      END CASE
      CASE g_action_choice
      	 WHEN "Page1"
            CALL i511_bp2("G")
         WHEN "Page2"
            CALL i511_bp3("G")
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i511_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i511_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i511_r()
            END IF
         #WHEN "reproduce"
         #   IF cl_chk_act_auth() THEN
         #      CALL i511_copy()
         #   END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i511_u()
            END IF
         #WHEN "invalid"
         #   IF cl_chk_act_auth() THEN
         #      CALL i511_x()
         #   END IF
         #WHEN "output"
         #   IF cl_chk_act_auth()                                           
         #      THEN CALL i511_out()                                    
         #   END IF                                                         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "accessory"
            IF cl_chk_act_auth() THEN
               CALL i511_b1()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "user_defined_columns"
            IF cl_chk_act_auth() THEN
               CALL i511_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "spare_part"
            IF cl_chk_act_auth() THEN
               CALL i511_b3()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_imm.tc_imm01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_imm01"
                 LET g_doc.value1 = g_tc_imm.tc_imm01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i511_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_imn.clear()
   CALL g_tc_imp.clear()
   CALL g_tc_imq.clear()
   INITIALIZE g_tc_imm.* LIKE tc_imm_file.*             #DEFAULT 設定
   LET g_tc_imm01_t = NULL
   #預設值及將數值類變數清成零
   LET g_tc_imm.tc_immuser=g_user
   LET g_tc_imm.tc_immoriu = g_user
   LET g_tc_imm.tc_immorig = g_grup
   LET g_tc_imm.tc_immgrup=g_grup
   LET g_tc_imm.tc_immdate=g_today
   LET g_tc_imm.tc_immacti='Y'              #資料有效
   LET g_tc_imm.tc_immplant = g_plant
   LET g_tc_imm.tc_immlegal = g_plant
   LET g_tc_imm.tc_imm15 = 0
   LET g_tc_imm.tc_immmksg = 'N'
   LET g_tc_imm.tc_imm03 = 'N'
   LET g_tc_imm.tc_immconf = 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i511_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_tc_imm.* TO NULL
         EXIT WHILE
      END IF
      IF g_tc_imm.tc_imm01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO tc_imm_file VALUES (g_tc_imm.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      SELECT tc_imm01 INTO g_tc_imm.tc_imm01 FROM tc_imm_file
       WHERE tc_imm01 = g_tc_imm.tc_imm01
      LET g_tc_imm01_t = g_tc_imm.tc_imm01        #保留舊值
      LET g_tc_imm_t.* = g_tc_imm.*

      CALL i511_b1_fill(" 1=1")                 #單身
      CALL i511_b1()                   #輸入單身-1
 
      CALL g_tc_imp.clear()
      LET g_rec_b2=0
      CALL i511_b2()                   #輸入單身-2
 
      CALL g_tc_imq.clear()
      LET g_rec_b3=0
      CALL i511_b3()                   #輸入單身-3
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i511_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file
    WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_imm.tc_imm01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_imm01_t = g_tc_imm.tc_imm01
   LET g_tc_imm_o.* = g_tc_imm.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i511_cl INTO g_tc_imm.*                          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i511_show()
   WHILE TRUE
      LET g_tc_imm01_t = g_tc_imm.tc_imm01
      LET g_tc_imm.tc_immmodu=g_user
      LET g_tc_imm.tc_immdate=g_today
      CALL i511_i("u")                                    #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_imm.*=g_tc_imm_t.*
         CALL i511_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_tc_imm.tc_imm01 != g_tc_imm01_t THEN            # 更改單號
         UPDATE tc_imn_file SET tc_imn01 = g_tc_imm.tc_imm01 WHERE tc_imn01 = g_tc_imm01_t
         UPDATE tc_imp_file SET tc_imp01 = g_tc_imm.tc_imm01 WHERE tc_imp01 = g_tc_imm01_t
         UPDATE tc_imq_file SET tc_imq01 = g_tc_imm.tc_imm01 WHERE tc_imq01 = g_tc_imm01_t
      END IF
      UPDATE tc_imm_file SET tc_imm_file.* = g_tc_imm.* WHERE tc_imm01 = g_tc_imm01_t 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i511_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i511_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改
    l_pmc03         LIKE pmc_file.pmc03,
    l_yy,l_mm       LIKE type_file.num5,
    l_fii03         LIKE fii_file.fii03
DEFINE   l_n        LIKE type_file.num5
    
    LET l_n = 0
    CALL cl_set_head_visible("folder01","YES")
 
    INPUT BY NAME g_tc_imm.tc_imm01,g_tc_imm.tc_imm02,g_tc_imm.tc_immud13,g_tc_imm.tc_imm14,g_tc_imm.tc_imm16,
                  g_tc_imm.tc_imm08,g_tc_imm.tc_imm10,g_tc_imm.tc_immconf,g_tc_imm.tc_imm03,g_tc_imm.tc_imm09
          
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i511_set_entry(p_cmd)
           CALL i511_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
      { AFTER FIELD tc_imm01
           IF NOT cl_null(g_tc_imm.tc_imm01) THEN
              IF g_tc_imm.tc_imm01 != g_tc_imm01_t OR g_tc_imm01_t IS NULL THEN
                 SELECT COUNT(*) INTO g_cnt FROM tc_imm_file
                  WHERE tc_imm01 = g_tc_imm.tc_imm01
                 IF g_cnt > 0 THEN
                    CALL cl_err(g_tc_imm.tc_imm01,-239,0)
                    LET g_tc_imm.tc_imm01 = g_tc_imm01_t
                    DISPLAY BY NAME g_tc_imm.tc_imm01
                    NEXT FIELD tc_imm01
                 END IF
              END IF
           END IF

        BEFORE FIELD tc_imm03
           CALL i511_set_entry(p_cmd)
 
        AFTER FIELD tc_imm03
           IF NOT cl_null(g_tc_imm.tc_imm03) THEN
              CALL i511_tc_imm03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_imm.tc_imm03,g_errno,0)
                 LET g_tc_imm.tc_imm03 = g_tc_imm_o.tc_imm03
                 DISPLAY BY NAME g_tc_imm.tc_imm03
                 NEXT FIELD tc_imm03
              END IF
           END IF
           CALL i511_set_no_entry(p_cmd)
 
        AFTER FIELD tc_imm04
           IF NOT cl_null(g_tc_imm.tc_imm04) THEN
              CALL i511_tc_imm04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_imm.tc_imm04,g_errno,0)
                 LET g_tc_imm.tc_imm04 = g_tc_imm_o.tc_imm04
                 DISPLAY BY NAME g_tc_imm.tc_imm04
                 NEXT FIELD tc_imm04
              END IF
              IF NOT cl_null(g_tc_imm.tc_imm05) THEN
                 SELECT fii03 INTO l_fii03 FROM fii_file
                  WHERE fii01=g_tc_imm.tc_imm04
                    AND fii02=g_tc_imm.tc_imm05
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","fii_file",g_tc_imm.tc_imm04,g_tc_imm.tc_imm05,"aem-009","","",1)  #No.FUN-660092
                    NEXT FIELD tc_imm04
                 END IF
              END IF
           END IF
 
        AFTER FIELD tc_imm05
           IF NOT cl_null(g_tc_imm.tc_imm05) THEN
              CALL i511_tc_imm05(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_imm.tc_imm05,g_errno,0)
                 LET g_tc_imm.tc_imm05 = g_tc_imm_o.tc_imm05
                 DISPLAY BY NAME g_tc_imm.tc_imm05
                 NEXT FIELD tc_imm05
              END IF
              IF NOT cl_null(g_tc_imm.tc_imm04) THEN
                 SELECT fii03 INTO l_fii03 FROM fii_file
                  WHERE fii01=g_tc_imm.tc_imm04
                    AND fii02=g_tc_imm.tc_imm05
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","fii_file",g_tc_imm.tc_imm04,g_tc_imm.tc_imm05,"aem-009","","",1)  #No.FUN-660092
                    NEXT FIELD tc_imm04
                 END IF
              END IF
           END IF
 
        AFTER FIELD tc_imm06
           IF g_fic03 ='Y' THEN
              IF cl_null(g_tc_imm.tc_imm06) THEN NEXT FIELD tc_imm06 END IF
           END IF
        AFTER FIELD tc_imm07
           IF NOT cl_null(g_tc_imm.tc_imm07) THEN
              SELECT COUNT(*) INTO l_n FROM pmc_file
               WHERE pmc01 = g_tc_imm.tc_imm07 
              IF l_n = 0 THEN
                 CALL cl_err(g_tc_imm.tc_imm07,'aem-048',0)
                 NEXT FIELD tc_imm07
              END IF
           END IF
 
        AFTER FIELD tc_imm08
           IF NOT cl_null(g_tc_imm.tc_imm08) THEN
              SELECT COUNT(*) INTO l_n FROM geb_file
               WHERE geb01 = g_tc_imm.tc_imm08
              IF l_n = 0 THEN
                 CALL cl_err(g_tc_imm.tc_imm08,'aem-049',0)
                 NEXT FIELD tc_imm08
              END IF
           END IF
        AFTER FIELD tc_imm09
           IF cl_null(g_tc_imm.tc_imm09) THEN
              DISPLAY '' TO FORMONLY.pmc03
           ELSE
              CALL i511_tc_imm09(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_imm.tc_imm09,g_errno,0) 
                 NEXT FIELD tc_imm09
              END IF
           END IF
 
        AFTER FIELD tc_imm10
            IF NOT cl_null(g_tc_imm.tc_imm10) THEN
               CALL i511_tc_imm10(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_imm.tc_imm10,g_errno,0)
                  LET g_tc_imm.tc_imm10 = g_tc_imm_o.tc_imm10
                  DISPLAY BY NAME g_tc_imm.tc_imm10
                  NEXT FIELD tc_imm10
               END IF
            END IF
 
        AFTER FIELD tc_imm11
            IF NOT cl_null(g_tc_imm.tc_imm11) THEN
               CALL i511_tc_imm11(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_imm.tc_imm11,g_errno,0)
                  LET g_tc_imm.tc_imm11 = g_tc_imm_o.tc_imm11
                  DISPLAY BY NAME g_tc_imm.tc_imm11
                  NEXT FIELD tc_imm11
               END IF
            END IF
 
        AFTER FIELD tc_imm14
            IF NOT cl_null(g_tc_imm.tc_imm14) THEN
               CALL i511_tc_imm14(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_imm.tc_imm14,g_errno,0)
                  LET g_tc_imm.tc_imm14 = g_tc_imm_o.tc_imm14
                  DISPLAY BY NAME g_tc_imm.tc_imm14
                  NEXT FIELD tc_imm14
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02
            END IF
 
        AFTER FIELD tc_imm15
            IF NOT cl_null(g_tc_imm.tc_imm15) THEN
               CALL i511_tc_imm15(p_cmd,'2')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_imm.tc_imm15,g_errno,0)
                  LET g_tc_imm.tc_imm15 = g_tc_imm_o.tc_imm15
                  DISPLAY BY NAME g_tc_imm.tc_imm15
                  NEXT FIELD tc_imm15
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02a
            END IF
 
        AFTER FIELD tc_imm16
            IF NOT cl_null(g_tc_imm.tc_imm16) THEN
               CALL i511_tc_imm15(p_cmd,'3')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_imm.tc_imm16,g_errno,0)
                  LET g_tc_imm.tc_imm16 = g_tc_imm_o.tc_imm16
                  DISPLAY BY NAME g_tc_imm.tc_imm16
                  NEXT FIELD tc_imm16
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02b
            END IF}

        ON ACTION CONTROLP
           {CASE
              WHEN INFIELD(tc_imm03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm03
                 LET g_qryparam.form ="q_fic"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm03
                 DISPLAY BY NAME g_tc_imm.tc_imm03
                 NEXT FIELD tc_imm03
              WHEN INFIELD(tc_imm04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm04
                 LET g_qryparam.form ="q_fii"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm04,g_tc_imm.tc_imm05
                 DISPLAY BY NAME g_tc_imm.tc_imm04
                 DISPLAY BY NAME g_tc_imm.tc_imm05
                 NEXT FIELD tc_imm04
              WHEN INFIELD(tc_imm05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm04
                 LET g_qryparam.form ="q_fii"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm04,g_tc_imm.tc_imm05
                 DISPLAY BY NAME g_tc_imm.tc_imm04
                 DISPLAY BY NAME g_tc_imm.tc_imm05
                 NEXT FIELD tc_imm05
              WHEN INFIELD(tc_imm07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm07
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm07
                 DISPLAY BY NAME g_tc_imm.tc_imm07
                 NEXT FIELD tc_imm07
              WHEN INFIELD(tc_imm08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm08
                 LET g_qryparam.form ="q_geb"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm08
                 DISPLAY BY NAME g_tc_imm.tc_imm08
                 NEXT FIELD tc_imm08
              WHEN INFIELD(tc_imm09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm09
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm09
                 DISPLAY BY NAME g_tc_imm.tc_imm09
                 NEXT FIELD tc_imm09
              WHEN INFIELD(tc_imm10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm10
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm10
                 DISPLAY BY NAME g_tc_imm.tc_imm10
                 NEXT FIELD tc_imm10
              WHEN INFIELD(tc_imm11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm11
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm11
                 DISPLAY BY NAME g_tc_imm.tc_imm11
              WHEN INFIELD(tc_imm14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm14
                 LET g_qryparam.form ="q_fjf"
                 LET g_qryparam.arg1 =g_plant
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm14
                 DISPLAY BY NAME g_tc_imm.tc_imm14
                 NEXT FIELD tc_imm14
              WHEN INFIELD(tc_imm15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm15
                 LET g_qryparam.form ="q_fjg"
                 LET g_qryparam.arg1 = g_tc_imm.tc_imm14
                 LET g_qryparam.arg2 = g_plant
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm15
                 DISPLAY BY NAME g_tc_imm.tc_imm15
                 NEXT FIELD tc_imm15
              WHEN INFIELD(tc_imm16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm16
                 LET g_qryparam.form ="q_fjg"
                 LET g_qryparam.arg1 = g_tc_imm.tc_imm14
                 LET g_qryparam.arg2 = g_plant
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm16
                 DISPLAY BY NAME g_tc_imm.tc_imm16
                 NEXT FIELD tc_imm16
              OTHERWISE EXIT CASE
        END CASE}

       ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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

FUNCTION i511_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tc_imm.* TO NULL
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_imn.clear()
   CALL g_tc_imp.clear()
   CALL g_tc_imq.clear()

 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i511_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i511_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_imm.* TO NULL
   ELSE
      OPEN i511_count
      FETCH i511_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i511_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i511_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i511_cs INTO g_tc_imm.tc_imm01
      WHEN 'P' FETCH PREVIOUS i511_cs INTO g_tc_imm.tc_imm01
      WHEN 'F' FETCH FIRST    i511_cs INTO g_tc_imm.tc_imm01
      WHEN 'L' FETCH LAST     i511_cs INTO g_tc_imm.tc_imm01
      WHEN '/'
         IF NOT mi_no_ask THEN
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
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i511_cs INTO g_tc_imm.tc_imm01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_imm.* TO NULL
      CLEAR FORM
      CALL g_tc_imn.clear()
      CALL g_tc_imp.clear()
      CALL g_tc_imq.clear()
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
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_tc_imm.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_tc_imm.tc_immuser 
   LET g_data_group = g_tc_imm.tc_immgrup 
   CALL i511_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i511_show()
   LET g_tc_imm_t.* = g_tc_imm.*                #保存單頭舊值
   DISPLAY BY NAME g_tc_imm.tc_imm01,g_tc_imm.tc_imm02,g_tc_imm.tc_imm03#,g_tc_imm.tc_imm04#,g_tc_imm.tc_immdays,
                   #g_tc_imm.tc_immprit,g_tc_imm.tc_imm05,g_tc_imm.tc_imm06,g_tc_imm.tc_imm07,g_tc_imm.tc_imm08,
                   #g_tc_imm.tc_imm09,g_tc_imm.tc_imm10,g_tc_imm.tc_imm11,g_tc_imm.tc_imm12,g_tc_imm.tc_imm13,
                   #g_tc_imm.tc_immacti,g_tc_imm.tc_immuser,g_tc_imm.tc_immgrup,g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate,
                   #g_tc_imm.tc_immconf,g_tc_imm.tc_imm14,g_tc_imm.tc_immspc,g_tc_imm.tc_immud01,g_tc_imm.tc_immud02,
                   #g_tc_imm.tc_immud03,g_tc_imm.tc_immud04,g_tc_imm.tc_immud05,g_tc_imm.tc_immud06,g_tc_imm.tc_immud07,
                   #g_tc_imm.tc_immud08,g_tc_imm.tc_immud09,g_tc_imm.tc_immud10,g_tc_imm.tc_immud11,g_tc_imm.tc_immud12,
                   #g_tc_imm.tc_immud13,g_tc_imm.tc_immud14,g_tc_imm.tc_immud15,g_tc_imm.tc_immplant,g_tc_imm.tc_immlegal,
                   #g_tc_imm.tc_immoriu,g_tc_imm.tc_immorig,g_tc_imm.tc_imm15,g_tc_imm.tc_imm16,g_tc_imm.tc_immmksg
   CALL i511_b1_fill(g_wc2)                 #單身
   CALL i511_b2_fill(g_wc3)                 #單身
   CALL i511_b3_fill(g_wc4)                 #單身
    CALL cl_show_fld_cont()
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i511_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti = 'N' THEN
      CALL cl_err('','abm-950',0)
      RETURN
   END IF

   BEGIN WORK
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)         
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i511_cl INTO g_tc_imm.*                             # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)         #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i511_show()
   IF cl_delh(0,0) THEN                                      #確認一下
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "tc_imm01"
       LET g_doc.value1 = g_tc_imm.tc_imm01
       CALL cl_del_doc()
      DELETE FROM tc_imn_file WHERE tc_imn01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imn_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imn:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imp_file WHERE tc_imp01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imp_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imp:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imq_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imq:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imm_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imm:",1)
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_tc_imm.* TO NULL
      CLEAR FORM
      CALL g_tc_imn.clear()
      CALL g_tc_imp.clear()
      CALL g_tc_imq.clear()
      OPEN i511_count
      IF STATUS THEN
         CLOSE i511_cs
         CLOSE i511_count
         COMMIT WORK
         RETURN
      END IF
      FETCH i511_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i511_cs
         CLOSE i511_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i511_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i511_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i511_fetch('/')
      END IF
   END IF
   CLOSE i511_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i511_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,                #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態          
   l_exit_sw       LIKE type_file.chr1,                               
   l_allow_insert  LIKE type_file.num5,                #可新增否          
   l_allow_delete  LIKE type_file.num5                 #可刪除否          
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti ='N' THEN CALL cl_err(g_tc_imm.tc_imm01,'9027',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tc_imn02,tc_imn03,tc_imn04,'',tc_imn05,'','',tc_imn06 ",
                      " FROM tc_imn_file",
                      " WHERE tc_imn01=? AND tc_imn02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i511_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tc_imn WITHOUT DEFAULTS FROM s_tc_imn.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i511_cl USING g_tc_imm.tc_imm01
          IF STATUS THEN
             CALL cl_err("OPEN i511_cl:", STATUS, 1)
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i511_cl INTO g_tc_imm.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b1 >= l_ac THEN
             LET p_cmd='u'
             LET g_tc_imn_t.* = g_tc_imn[l_ac].*  #BACKUP
             OPEN i511_b1_cl USING g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02
             IF STATUS THEN
                CALL cl_err("OPEN i511_b1_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i511_b1_cl INTO g_tc_imn[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tc_imn_t.tc_imn02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_tc_imn[l_ac].* TO NULL 
          LET g_tc_imn_t.* = g_tc_imn[l_ac].*         #新輸入資料
          NEXT FIELD tc_imn02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO tc_imn_file(tc_imn01,tc_imn02,tc_imn03,tc_imn04,tc_imn05,tc_imn06)
          VALUES(g_tc_imm.tc_imm01,g_tc_imn[l_ac].tc_imn02,g_tc_imn[l_ac].tc_imn03,g_tc_imn[l_ac].tc_imn04,
                 g_tc_imn[l_ac].tc_imn05,g_tc_imn[l_ac].tc_imn06)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn[l_ac].tc_imn02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             COMMIT WORK
          END IF
 
       BEFORE FIELD tc_imn02                        #default 序號
          IF g_tc_imn[l_ac].tc_imn02 IS NULL OR g_tc_imn[l_ac].tc_imn02 = 0 THEN
             SELECT max(tc_imn02)+1
               INTO g_tc_imn[l_ac].tc_imn02
               FROM tc_imn_file
              WHERE tc_imn01 = g_tc_imm.tc_imm01
             IF g_tc_imn[l_ac].tc_imn02 IS NULL THEN
                LET g_tc_imn[l_ac].tc_imn02 = 1
             END IF
          END IF
 
       AFTER FIELD tc_imn02                        #check 序號是否重複
          IF NOT cl_null(g_tc_imn[l_ac].tc_imn02) THEN
             IF g_tc_imn[l_ac].tc_imn02 != g_tc_imn_t.tc_imn02 OR
                g_tc_imn_t.tc_imn02 IS NULL THEN
                SELECT count(*) INTO l_n FROM tc_imn_file
                 WHERE tc_imn01 = g_tc_imm.tc_imm01
                   AND tc_imn02 = g_tc_imn[l_ac].tc_imn02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tc_imn[l_ac].tc_imn02 = g_tc_imn_t.tc_imn02
                   NEXT FIELD tc_imn02
                END IF
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_tc_imn_t.tc_imn02 > 0 AND
             g_tc_imn_t.tc_imn02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM tc_imn_file
              WHERE tc_imn01 = g_tc_imm.tc_imm01
                AND tc_imn02 = g_tc_imn_t.tc_imn02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b1=g_rec_b1-1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tc_imn[l_ac].* = g_tc_imn_t.*
             CLOSE i511_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tc_imn[l_ac].tc_imn02,-263,1)
             LET g_tc_imn[l_ac].* = g_tc_imn_t.*
          ELSE
             UPDATE tc_imn_file SET tc_imn02 = g_tc_imn[l_ac].tc_imn02,
                                    tc_imn03 = g_tc_imn[l_ac].tc_imn03,
                                    tc_imn04 = g_tc_imn[l_ac].tc_imn04,
                                    tc_imn05 = g_tc_imn[l_ac].tc_imn05,
                                    tc_imn06 = g_tc_imn[l_ac].tc_imn06
              WHERE tc_imn01=g_tc_imm.tc_imm01 AND tc_imn02=g_tc_imn_t.tc_imn02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02,SQLCA.sqlcode,"","",1)
                LET g_tc_imn[l_ac].* = g_tc_imn_t.*
                CLOSE i511_b1_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_tc_imn[l_ac].* = g_tc_imn_t.*
             ELSE
                CALL g_tc_imn.deleteElement(l_ac)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "accessory"
                   LET l_ac = l_ac_t
                END IF
             END IF
             CLOSE i511_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE i511_b1_cl
          COMMIT WORK
 
       ON ACTION CONTROLN
          CALL i511_b1_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_imn02) AND l_ac > 1 THEN
               LET g_tc_imn[l_ac].* = g_tc_imn[l_ac-1].*
               NEXT FIELD tc_imn02
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
         CALL cl_set_head_visible("folder01","AUTO")
   END INPUT
   LET g_tc_imm.tc_immmodu = g_user
   LET g_tc_imm.tc_immdate = g_today
   UPDATE tc_imm_file SET tc_immmodu = g_tc_imm.tc_immmodu,tc_immdate = g_tc_imm.tc_immdate
    WHERE tc_imm01 = g_tc_imm.tc_imm01
   DISPLAY BY NAME g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate
 
   CLOSE i511_b1_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i511_b2()
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態         
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_cnt           LIKE type_file.num5,                              
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    l_allow_insert  LIKE type_file.num5,                #可新增否         
    l_allow_delete  LIKE type_file.num5                 #可刪除否         
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_imm.tc_imm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
    IF g_tc_imm.tc_immacti ='N' THEN CALL cl_err(g_tc_imm.tc_imm01,'9027',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_imp02,tc_imp05,'','',tc_imp06,'',tc_imp07,'',tc_imp08,tc_imp09 ",
                       "  FROM tc_imp_file",
                       " WHERE tc_imp01=? AND tc_imp02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i511_b2_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_imp WITHOUT DEFAULTS FROM s_tc_imp.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
 
           BEGIN WORK
           OPEN i511_cl USING g_tc_imm.tc_imm01
           IF STATUS THEN
              CALL cl_err("OPEN i511_cl:", STATUS, 1)
              CLOSE i511_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i511_cl INTO g_tc_imm.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i511_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_imp_t.* = g_tc_imp[l_ac].*  #BACKUP
              OPEN i511_b2_cl USING g_tc_imm.tc_imm01,g_tc_imp_t.tc_imp02
              IF STATUS THEN
                 CALL cl_err("OPEN i511_b2_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i511_b2_cl INTO g_tc_imp[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_imp_t.tc_imp02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_imp[l_ac].* TO NULL
           LET g_tc_imp_t.* = g_tc_imp[l_ac].*         #新輸入資料
           NEXT FIELD tc_imp02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tc_imp_file(tc_imp01,tc_imp02,tc_imp05,tc_imp06,tc_imp07,tc_imp08,tc_imp09)
            VALUES(g_tc_imm.tc_imm01,g_tc_imp[l_ac].tc_imp02,g_tc_imp[l_ac].tc_imp05,g_tc_imp[l_ac].tc_imp06,
                   g_tc_imp[l_ac].tc_imp07,g_tc_imp[l_ac].tc_imp08,g_tc_imp[l_ac].tc_imp09)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_imp_file",g_tc_imm.tc_imm01,g_tc_imp[l_ac].tc_imp02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              COMMIT WORK
           END IF
 
        AFTER FIELD tc_imp02                        #check 序號是否重複
           IF NOT cl_null(g_tc_imp[l_ac].tc_imp02) THEN
              IF g_tc_imp[l_ac].tc_imp02 != g_tc_imp_t.tc_imp02 OR g_tc_imp_t.tc_imp02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM tc_imp_file
                  WHERE tc_imp01 = g_tc_imm.tc_imm01
                    AND tc_imp02 = g_tc_imp[l_ac].tc_imp02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_imp[l_ac].tc_imp02 = g_tc_imp_t.tc_imp02
                    NEXT FIELD tc_imp02
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_tc_imp_t.tc_imp02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_imp_file
               WHERE tc_imp01 = g_tc_imm.tc_imm01
                 AND tc_imp02 = g_tc_imp_t.tc_imp02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_imp_file",g_tc_imm.tc_imm01,g_tc_imp_t.tc_imp02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              MESSAGE "Delete Ok"
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_imp[l_ac].* = g_tc_imp_t.*
               CLOSE i511_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_imp[l_ac].tc_imp02,-263,1)
               LET g_tc_imp[l_ac].* = g_tc_imp_t.*
            ELSE
               UPDATE tc_imp_file SET tc_imp02 = g_tc_imp[l_ac].tc_imp02,
                                      tc_imp05 = g_tc_imp[l_ac].tc_imp05,
                                      tc_imp06 = g_tc_imp[l_ac].tc_imp06,
                                      tc_imp07 = g_tc_imp[l_ac].tc_imp07,
                                      tc_imp08 = g_tc_imp[l_ac].tc_imp08,
                                      tc_imp09 = g_tc_imp[l_ac].tc_imp09
                WHERE tc_imp01=g_tc_imm.tc_imm01
                  AND tc_imp02=g_tc_imp_t.tc_imp02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_imp_file",g_tc_imm.tc_imm01,g_tc_imp_t.tc_imp02,SQLCA.sqlcode,"","",1)
                  LET g_tc_imp[l_ac].* = g_tc_imp_t.*
                  CLOSE i511_b2_cl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_imp[l_ac].* = g_tc_imp_t.*
               ELSE
                  CALL g_tc_imp.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "user_defined_columns"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i511_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i511_b2_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL i511_b2_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_imp02) AND l_ac > 1 THEN
               LET g_tc_imp[l_ac].* = g_tc_imp[l_ac-1].*
               NEXT FIELD tc_imp02
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
           CALL cl_set_head_visible("folder01","AUTO")                            
    END INPUT
 
    LET g_tc_imm.tc_immmodu = g_user
    LET g_tc_imm.tc_immdate = g_today
    UPDATE tc_imm_file SET tc_immmodu = g_tc_imm.tc_immmodu,tc_immdate = g_tc_imm.tc_immdate
     WHERE tc_imm01 = g_tc_imm.tc_imm01
    DISPLAY BY NAME g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate
 
    CLOSE i511_b2_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i511_b3()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態         
   l_exit_sw       LIKE type_file.chr1,                              
   l_allow_insert  LIKE type_file.num5,                #可新增否         
   l_allow_delete  LIKE type_file.num5                 #可刪除否         
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti ='N' THEN CALL cl_err(g_tc_imm.tc_imm01,'9027',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tc_imq02,tc_imq03,tc_imq04,tc_imq05,'','',tc_imq06,",
                      "       tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,",
                      "       tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,",
                      "       tc_imq17,'',tc_imq18 ",
                      " FROM tc_imq_file",
                      " WHERE tc_imq01=? AND tc_imq02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i511_b3_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tc_imq WITHOUT DEFAULTS FROM s_tc_imq.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i511_cl USING g_tc_imm.tc_imm01
          IF STATUS THEN
             CALL cl_err("OPEN i511_cl:", STATUS, 1)
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i511_cl INTO g_tc_imm.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b3 >= l_ac THEN
             LET p_cmd='u'
             LET g_tc_imq_t.* = g_tc_imq[l_ac].*  #BACKUP
             LET g_tc_imq05_t = g_tc_imq[l_ac].tc_imq05      #FUN-BB0084 
             OPEN i511_b3_cl USING g_tc_imm.tc_imm01,g_tc_imq_t.tc_imq02
             IF STATUS THEN
                CALL cl_err("OPEN i511_b3_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i511_b3_cl INTO g_tc_imq[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tc_imq_t.tc_imq02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_tc_imq[l_ac].* TO NULL      #900423
          LET g_tc_imq_t.* = g_tc_imq[l_ac].*         #新輸入資料
          LET g_tc_imq05_t = g_tc_imq[l_ac].tc_imq05     #FUN-BB0084 
          LET g_tc_imq[l_ac].tc_imq06=0
          NEXT FIELD tc_imq02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO tc_imq_file(tc_imq01,tc_imq02,tc_imq03,tc_imq04,tc_imq05,tc_imq06,
                                  tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,
                                  tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,
                                  tc_imq17,tc_imq18)
          VALUES(g_tc_imm.tc_imm01,g_tc_imq[l_ac].tc_imq02,g_tc_imq[l_ac].tc_imq03,g_tc_imq[l_ac].tc_imq04,g_tc_imq[l_ac].tc_imq05,
                 g_tc_imq[l_ac].tc_imq06,g_tc_imq[l_ac].tc_imq07,g_tc_imq[l_ac].tc_imq08,g_tc_imq[l_ac].tc_imq09,g_tc_imq[l_ac].tc_imq10,
                 g_tc_imq[l_ac].tc_imq11,g_tc_imq[l_ac].tc_imq12,g_tc_imq[l_ac].tc_imq13,g_tc_imq[l_ac].tc_imq14,g_tc_imq[l_ac].tc_imq15,
                 g_tc_imq[l_ac].tc_imq16,g_tc_imq[l_ac].tc_imq17,g_tc_imq[l_ac].tc_imq18)

          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tc_imq_file",g_tc_imm.tc_imm01,g_tc_imq[l_ac].tc_imq02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b3=g_rec_b3+1
             DISPLAY g_rec_b3 TO FORMONLY.cn4
             COMMIT WORK
          END IF
 
       BEFORE FIELD tc_imq02                        #default 序號
          IF g_tc_imq[l_ac].tc_imq02 IS NULL OR g_tc_imq[l_ac].tc_imq02 = 0 THEN
             SELECT max(tc_imq02)+1
               INTO g_tc_imq[l_ac].tc_imq02
               FROM tc_imq_file
              WHERE tc_imq01 = g_tc_imm.tc_imm01
             IF g_tc_imq[l_ac].tc_imq02 IS NULL THEN
                LET g_tc_imq[l_ac].tc_imq02 = 1
             END IF
          END IF
 
       AFTER FIELD tc_imq02                        #check 序號是否重複
          IF NOT cl_null(g_tc_imq[l_ac].tc_imq02) THEN
             IF g_tc_imq[l_ac].tc_imq02 != g_tc_imq_t.tc_imq02 OR
                g_tc_imq_t.tc_imq02 IS NULL THEN
                SELECT COUNT(*) INTO l_n FROM tc_imq_file
                 WHERE tc_imq01 = g_tc_imm.tc_imm01
                   AND tc_imq02 = g_tc_imq[l_ac].tc_imq02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tc_imq[l_ac].tc_imq02 = g_tc_imq_t.tc_imq02
                   NEXT FIELD tc_imq02
                END IF
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_tc_imq_t.tc_imq02 > 0 AND
             g_tc_imq_t.tc_imq02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM tc_imq_file
              WHERE tc_imq01 = g_tc_imm.tc_imm01
                AND tc_imq02 = g_tc_imq_t.tc_imq02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_imq_file",g_tc_imm.tc_imm01,g_tc_imq_t.tc_imq02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b3=g_rec_b3-1
             DISPLAY g_rec_b3 TO FORMONLY.cn4
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tc_imq[l_ac].* = g_tc_imq_t.*
             CLOSE i511_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tc_imq[l_ac].tc_imq02,-263,1)
             LET g_tc_imq[l_ac].* = g_tc_imq_t.*
          ELSE
             UPDATE tc_imq_file SET tc_imq02 = g_tc_imq[l_ac].tc_imq02,
                                    tc_imq03 = g_tc_imq[l_ac].tc_imq03,
                                    tc_imq04 = g_tc_imq[l_ac].tc_imq04,
                                    tc_imq05 = g_tc_imq[l_ac].tc_imq05,
                                    tc_imq06 = g_tc_imq[l_ac].tc_imq06,
                                    tc_imq07 = g_tc_imq[l_ac].tc_imq07,
                                    tc_imq08 = g_tc_imq[l_ac].tc_imq08,
                                    tc_imq09 = g_tc_imq[l_ac].tc_imq09,
                                    tc_imq10 = g_tc_imq[l_ac].tc_imq10,
                                    tc_imq11 = g_tc_imq[l_ac].tc_imq11,
                                    tc_imq12 = g_tc_imq[l_ac].tc_imq12,
                                    tc_imq13 = g_tc_imq[l_ac].tc_imq13,
                                    tc_imq14 = g_tc_imq[l_ac].tc_imq14,
                                    tc_imq15 = g_tc_imq[l_ac].tc_imq15,
                                    tc_imq16 = g_tc_imq[l_ac].tc_imq16,
                                    tc_imq17 = g_tc_imq[l_ac].tc_imq17,
                                    tc_imq18 = g_tc_imq[l_ac].tc_imq18
              WHERE tc_imq01=g_tc_imm.tc_imm01 AND tc_imq02=g_tc_imq_t.tc_imq02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tc_imq_file",g_tc_imm.tc_imm01,g_tc_imq_t.tc_imq02,SQLCA.sqlcode,"","",1)
                LET g_tc_imq[l_ac].* = g_tc_imq_t.*
                CLOSE i511_b3_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_tc_imq[l_ac].* = g_tc_imq_t.*
             ELSE
                CALL g_tc_imq.deleteElement(l_ac)
                IF g_rec_b3 != 0 THEN
                   LET g_action_choice = "spare_part"
                   LET l_ac = l_ac_t
                END IF
             END IF
             CLOSE i511_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE i511_b3_cl
          COMMIT WORK
 
       ON ACTION CONTROLN
          CALL i511_b3_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_imq02) AND l_ac > 1 THEN
               LET g_tc_imq[l_ac].* = g_tc_imq[l_ac-1].*
               NEXT FIELD tc_imq02
           END IF
 
       ON ACTION CONTROLP
          {CASE
             WHEN INFIELD(tc_imq03)
                CALL q_sel_ima(FALSE, "q_ima", "", g_tc_imq[l_ac].tc_imq03 , "", "", "", "" ,"",'' )  RETURNING g_tc_imq[l_ac].tc_imq03 
                NEXT FIELD tc_imq03
             WHEN INFIELD(tc_imq04)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq04
                LET g_qryparam.form ="q_fiz"
                CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq04
                NEXT FIELD tc_imq04
             WHEN INFIELD(tc_imq05)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq04
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq04
                NEXT FIELD tc_imq05
             OTHERWISE EXIT CASE
          END CASE}
 
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
         CALL cl_set_head_visible("folder01","AUTO")                            

   END INPUT

   LET g_tc_imm.tc_immmodu = g_user
   LET g_tc_imm.tc_immdate = g_today
   UPDATE tc_imm_file SET tc_immmodu = g_tc_imm.tc_immmodu,tc_immdate = g_tc_imm.tc_immdate
    WHERE tc_imm01 = g_tc_imm.tc_imm01
   DISPLAY BY NAME g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate

   CLOSE i511_b3_cl
   COMMIT WORK
 
END FUNCTION

FUNCTION i511_b1_askkey()  
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON tc_imn02,tc_imn03
            FROM s_tc_imn[1].tc_imn02,s_tc_imn[1].tc_imn03

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i511_b1_fill(l_wc2)
END FUNCTION
 
FUNCTION i511_b1_fill(p_wc1)
DEFINE  p_wc1           STRING
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imn02,tc_imn03,tc_imn04,'',tc_imn05,'','',tc_imn06",
                "  FROM tc_imn_file",
                " WHERE tc_imn01 ='",g_tc_imm.tc_imm01,"'",
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY 1"
    PREPARE i511_pb1 FROM g_sql
    DECLARE tc_imn_curs1 CURSOR FOR i511_pb1
 
    CALL g_tc_imn.clear()
    LET l_ac = 1
    FOREACH tc_imn_curs1 INTO g_tc_imn[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imn.deleteElement(l_ac)
    DISPLAY ARRAY g_tc_imn TO s_tc_imn.*(COUNT=l_ac-1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    #LET g_rec_b1 = l_ac-1
    #DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i511_b2_askkey() 
    DEFINE l_wc2           STRING    #TQC-630166    
 
    CONSTRUCT l_wc2 ON tc_imp02,tc_imp03
            FROM s_tc_imp[1].tc_imp02,s_tc_imp[1].tc_imp03

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i511_b2_fill(l_wc2)
END FUNCTION
 
FUNCTION i511_b2_fill(p_wc2)
DEFINE p_wc2           STRING
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imp02,tc_imp05,'','',tc_imp06,'',tc_imp07,'',tc_imp08,tc_imp09 ",
                " FROM tc_imp_file",
                " WHERE tc_imp01 ='",g_tc_imm.tc_imm01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE i511_pb2 FROM g_sql
    DECLARE tc_imp_curs2 CURSOR FOR i511_pb2
 
    CALL g_tc_imp.clear()
    LET g_cnt = 1
    FOREACH tc_imp_curs2 INTO g_tc_imp[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imp.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i511_b3_askkey()
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON tc_imq02,tc_imq03,tc_imq04,tc_imq05,tc_imq06
         FROM s_tc_imq[1].tc_imq02,s_tc_imq[1].tc_imq03,s_tc_imq[1].tc_imq04,
              s_tc_imq[1].tc_imq05,s_tc_imq[1].tc_imq06

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
         { CASE
             WHEN INFIELD(tc_imq03)
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_imq03
                NEXT FIELD tc_imq03
             WHEN INFIELD(tc_imq04)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fiz"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_imq04
                NEXT FIELD tc_imq04
             WHEN INFIELD(tc_imq05)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_imq05
                NEXT FIELD tc_imq05
             OTHERWISE EXIT CASE
          END CASE}
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i511_b3_fill(l_wc2)
END FUNCTION
 
FUNCTION i511_b3_fill(p_wc3)
DEFINE p_wc3           STRING
 
    IF cl_null(p_wc3) THEN LET p_wc3 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imq02,tc_imq03,tc_imq04,tc_imq05,'','',tc_imq06, ",
                "       tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,",
                "       tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,",
                "       tc_imq17,'',tc_imq18 ", 
                "  FROM tc_imq_file LEFT OUTER JOIN ima_file ON tc_imq_file.tc_imq05=ima_file.ima01",
                " WHERE tc_imq01 ='",g_tc_imm.tc_imm01,"'",
                "   AND ",p_wc3 CLIPPED,
                " ORDER BY 1"
    PREPARE i511_pb3 FROM g_sql
    DECLARE tc_imq_curs3 CURSOR FOR i511_pb3
 
    CALL g_tc_imq.clear()
    LET l_ac = 1
    FOREACH tc_imq_curs3 INTO g_tc_imq[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imq.deleteElement(l_ac)
    LET g_rec_b3 = l_ac-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION

FUNCTION i511_bp1(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
   DEFINE l_cmd  LIKE type_file.chr1000

   IF p_ud <> "G" OR g_action_choice = "Page1" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imn TO s_tc_imn.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
         EXIT DISPLAY
 
      ON ACTION help          
         CALL cl_show_help()  
         EXIT DISPLAY
 
      ON ACTION controlg      
         CALL cl_cmdask()     
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
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
      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="accessory"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="accessory"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
                                           
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
         
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i511_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "Page2" THEN 
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imp TO s_tc_imp.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION Page2
        LET l_action_flag = "Page2"
     EXIT DISPLAY

      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
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
      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="user_defined_columns"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="user_defined_columns"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
                                                         
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i511_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "spare_part" THEN  #FUN-D40030 add 
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imq TO s_tc_imq.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
     ON ACTION Page1
        LET l_action_flag = "Page1"
     EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
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
      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="spare_part"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="spare_part"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY                                                       
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

{FUNCTION i511_out()
DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_tc_imm.tc_imm01) THEN                          
       LET g_wc = " tc_imm01 = '",g_tc_imm.tc_imm01,"' "                                 
    END IF                                                                      
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0) RETURN                                          
    END IF                                                                      
    LET l_cmd = 'p_query "csft511" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
END FUNCTION}
 
{FUNCTION i511_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file
    WHERE tc_imm01=g_tc_imm.tc_imm01
 
   BEGIN WORK
 
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)   
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i511_cl INTO g_tc_imm.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   CALL i511_show()
   IF cl_exp(0,0,g_tc_imm.tc_immacti) THEN                   #確認一下
       LET g_chr=g_tc_imm.tc_immacti
       IF g_tc_imm.tc_immacti='Y' THEN
           LET g_tc_imm.tc_immacti='N'
       ELSE
           LET g_tc_imm.tc_immacti='Y'
       END IF
       UPDATE tc_imm_file
          SET tc_immacti=g_tc_imm.tc_immacti, #更改有效碼
              tc_immmodu=g_user,
              tc_immdate=g_today
        WHERE tc_imm01=g_tc_imm.tc_imm01
       IF SQLCA.sqlcode OR STATUS=100 THEN
           CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)   
           LET g_tc_imm.tc_immacti=g_chr
       END IF
       SELECT tc_immacti,tc_immmodu,tc_immdate
         INTO g_tc_imm.tc_immacti,g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate
         FROM tc_imm_file
        WHERE tc_imm01=g_tc_imm.tc_imm01
       DISPLAY BY NAME g_tc_imm.tc_immacti,g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate
   END IF
   CLOSE i511_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i511_copy()
DEFINE
    l_newno        LIKE tc_imm_file.tc_imm01,
    l_oldno        LIKE tc_imm_file.tc_imm01
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_imm.tc_imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i511_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM tc_imm01
        AFTER FIELD tc_imm01
            IF l_newno IS NULL THEN
                NEXT FIELD tc_imm01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM tc_imm_file
             WHERE tc_imm01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD tc_imm01
            END IF
 
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tc_imm_file         #單頭復制
     WHERE tc_imm01=g_tc_imm.tc_imm01
      INTO TEMP y
    UPDATE y
        SET tc_imm01=l_newno,     #新的鍵值
            tc_immuser=g_user,    #資料所有者
            tc_immgrup=g_grup,    #資料所有者所屬群
            tc_immdate = g_today,
            tc_immacti = 'Y'
    INSERT INTO tc_imm_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tc_imm_file",l_newno,"",SQLCA.sqlcode,"","",1)
    END IF
 
    DROP TABLE x
    SELECT * FROM tc_imn_file         #單身復制
     WHERE tc_imn01=g_tc_imm.tc_imm01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET tc_imn01=l_newno
    INSERT INTO tc_imn_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM tc_imn_file WHERE tc_imn01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DROP TABLE x
    SELECT * FROM tc_imp_file         #單身復制
     WHERE tc_imp01=g_tc_imm.tc_imm01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET tc_imp01=l_newno
    INSERT INTO tc_imp_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","tc_imp_file",l_newno,g_tc_imp_t.tc_imp02,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM tc_imp_file WHERE tc_imp01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DROP TABLE x
    SELECT * FROM tc_imq_file         #單身復制
     WHERE tc_imq01=g_tc_imm.tc_imm01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET tc_imq01=l_newno
    INSERT INTO tc_imq_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","tc_imq_file",l_newno,g_tc_imq_t.tc_imq02,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM tc_imq_file WHERE tc_imq01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DROP TABLE x
    SELECT * FROM fjc_file         #單身復制
     WHERE fjc01=g_tc_imm.tc_imm01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET fjc01=l_newno
    INSERT INTO fjc_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","fjc_file",l_newno,g_fjc_t.fjc02,SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM fjc_file WHERE fjc01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_tc_imm.tc_imm01
    SELECT tc_imm_file.* INTO g_tc_imm.* FROM tc_imm_file
     WHERE tc_imm01 = l_newno
    CALL i511_u()
    CALL i511_b1()
    CALL i511_b2()
    CALL i511_b3()
END FUNCTION}
 
FUNCTION i511_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_imm01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i511_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_imm01",FALSE)
    END IF
 
END FUNCTION
