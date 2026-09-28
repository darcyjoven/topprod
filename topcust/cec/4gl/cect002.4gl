# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cect002.4gl
# Descriptions...: 在制LOT清单交接表
# Date & Author..: 16/09/03 By lidj
# Modfiy   修改为sgm_file取值  18/06/15 by ly

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tc_ima           RECORD LIKE tc_ima_file.*,
    g_tc_ima_t         RECORD LIKE tc_ima_file.*,
    g_tc_ima_o         RECORD LIKE tc_ima_file.*,
    g_tc_ima01_t       LIKE tc_ima_file.tc_ima01,
    g_tc_imb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imb02            LIKE tc_imb_file.tc_imb02,    #项次
        tc_imb03            LIKE tc_imb_file.tc_imb03,    #作业编号
        ecd02               LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        tc_imb04            LIKE tc_imb_file.tc_imb04,    #LOT单号
        tc_imb05            LIKE tc_imb_file.tc_imb05,    #工单单号
        sfb05               LIKE sfb_file.sfb05,          #生产料号 add by gujq 20160905
        ima02_2             LIKE ima_file.ima02,          #品名     add by gujq 20160905
        ima021_2            LIKE ima_file.ima021,         #规格     add by gujq 20160905
        tc_imb06            LIKE tc_imb_file.tc_imb06,    #扫入量
        tc_imb07            LIKE tc_imb_file.tc_imb07,    #开工量
        tc_imb08            LIKE tc_imb_file.tc_imb08,    #完工量
        tc_imb09            LIKE tc_imb_file.tc_imb09,    #扫出量
        tc_imb11            LIKE tc_imb_file.tc_imb11,    #报废量
        tc_imb12            LIKE tc_imb_file.tc_imb12,    #返工量  #add by guanyao160922
        tc_imb10            LIKE tc_imb_file.tc_imb10     #WIP量
        ,tc_imb13           LIKE tc_imb_file.tc_imb13     #PNL量  #add by guanyao160923
                    END RECORD,
    g_tc_imb_t         RECORD                     #程式變數 (舊值)
        tc_imb02            LIKE tc_imb_file.tc_imb02,    #项次
        tc_imb03            LIKE tc_imb_file.tc_imb03,    #作业编号
        ecd02               LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        tc_imb04            LIKE tc_imb_file.tc_imb04,    #LOT单号
        tc_imb05            LIKE tc_imb_file.tc_imb05,    #工单单号
        sfb05               LIKE sfb_file.sfb05,          #生产料号 add by gujq 20160905
        ima02_2             LIKE ima_file.ima02,          #品名     add by gujq 20160905
        ima021_2            LIKE ima_file.ima021,         #规格     add by gujq 20160905
        tc_imb06            LIKE tc_imb_file.tc_imb06,    #扫入量
        tc_imb07            LIKE tc_imb_file.tc_imb07,    #开工量
        tc_imb08            LIKE tc_imb_file.tc_imb08,    #完工量
        tc_imb09            LIKE tc_imb_file.tc_imb09,    #扫出量
        tc_imb11            LIKE tc_imb_file.tc_imb11,    #报废量
        tc_imb12            LIKE tc_imb_file.tc_imb12,    #返工量  #add by guanyao160922
        tc_imb10            LIKE tc_imb_file.tc_imb10     #WIP量
        ,tc_imb13           LIKE tc_imb_file.tc_imb13     #PNL量  #add by guanyao160923
                    END RECORD,
    g_tc_imc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imc02            LIKE tc_imc_file.tc_imc02,    #项次  
        tc_imc03            LIKE tc_imc_file.tc_imc03,    #作业编号
        ecd02_1             LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        #tc_imc04            LIKE tc_imc_file.tc_imc04,    #LOT单号
        tc_imc05            LIKE tc_imc_file.tc_imc05,    #工单单号
        tc_imc06            LIKE tc_imc_file.tc_imc06,    #生产料号
        ima02               LIKE ima_file.ima02,          #品名
        ima021              LIKE ima_file.ima021,         #规格 
        tc_imc07            LIKE tc_imc_file.tc_imc07,    #发料料号
        ima02c              LIKE ima_file.ima02,          #发料品名
        ima021c             LIKE ima_file.ima021,         #发料规格  
        tc_imc08            LIKE tc_imc_file.tc_imc08,    #应发量  
        tc_imc09            LIKE tc_imc_file.tc_imc09,    #已发量
        tc_imc10            LIKE tc_imc_file.tc_imc10,    #已扫出量
        tc_imc11            LIKE tc_imc_file.tc_imc11,    #已完工量
        tc_imc12            LIKE tc_imc_file.tc_imc12,    #已报废量
        tc_imc13            LIKE tc_imc_file.tc_imc13     #剩余库存量
                    END RECORD,
    g_tc_imc_t         RECORD
        tc_imc02            LIKE tc_imc_file.tc_imc02,    #项次  
        tc_imc03            LIKE tc_imc_file.tc_imc03,    #作业编号
        ecd02_1             LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        #tc_imc04            LIKE tc_imc_file.tc_imc04,    #LOT单号
        tc_imc05            LIKE tc_imc_file.tc_imc05,    #工单单号
        tc_imc06            LIKE tc_imc_file.tc_imc06,    #生产料号
        ima02               LIKE ima_file.ima02,          #品名
        ima021              LIKE ima_file.ima021,         #规格 
        tc_imc07            LIKE tc_imc_file.tc_imc07,    #发料料号
        ima02c              LIKE ima_file.ima02,          #发料品名
        ima021c             LIKE ima_file.ima021,         #发料规格  
        tc_imc08            LIKE tc_imc_file.tc_imc08,    #应发量  
        tc_imc09            LIKE tc_imc_file.tc_imc09,    #已发量
        tc_imc10            LIKE tc_imc_file.tc_imc10,    #已扫出量
        tc_imc11            LIKE tc_imc_file.tc_imc11,    #已完工量
        tc_imc12            LIKE tc_imc_file.tc_imc12,    #已报废量
        tc_imc13            LIKE tc_imc_file.tc_imc13     #剩余库存量
                    END RECORD,
    g_tc_imd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imd02            LIKE tc_imd_file.tc_imd02,    #项次
        tc_imd03            LIKE tc_imd_file.tc_imd03,    #料件编码
        ima02d              LIKE ima_file.ima02,          #品名
        ima021d             LIKE ima_file.ima021,         #规格
        tc_imd04            LIKE tc_imd_file.tc_imd04     #数量
                    END RECORD,
    g_tc_imd_t         RECORD
        tc_imd02            LIKE tc_imd_file.tc_imd02,    #项次
        tc_imd03            LIKE tc_imd_file.tc_imd03,    #料件编码
        ima02d              LIKE ima_file.ima02,          #品名
        ima021d             LIKE ima_file.ima021,         #规格
        tc_imd04            LIKE tc_imd_file.tc_imd04     #数量
                    END RECORD,
   #g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2     VARCHAR(1000)
    g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2    STRING,    #TQC-630166        
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4    LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_t1            LIKE type_file.chr3,                  #No.FUN-680072CHAR(3)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
 
#主程式開始
DEFINE   p_row,p_col         LIKE type_file.num5        #No.FUN-680072 SMALLINT
#FUN-540036---start
DEFINE  l_action_flag        STRING    
#FUN-540036---end
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE  g_before_input_done  LIKE type_file.num5     #No.FUN-680072 SMALLINT
DEFINE  g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03            #No.FUN-680072CHAR(72)
DEFINE  g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_void          LIKE type_file.chr1          #No.FUN-680072CHAR(1)
DEFINE g_argv1     LIKE tc_ima_file.tc_ima01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
 
# DEFINE      l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("CEC")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    LET g_forupd_sql = "SELECT * FROM tc_ima_file WHERE tc_ima01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW t001_w33 AT 2,2 WITH FORM "cec/42f/cect001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF
         OTHERWISE        
            CALL t001_q() 
      END CASE
   END IF
   #--
 
    CALL t001_menu()

    DROP TABLE cect002_tmp #add by guanyao160930
 
    CLOSE WINDOW t001_w33
    CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
      RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION t001_cs()
 DEFINE    l_type          LIKE type_file.chr2       #No.FUN-680072CHAR(2)
   CLEAR FORM                                      #清除畫面
   CALL g_tc_imb.clear()
   CALL g_tc_imc.clear()
   CALL g_tc_imd.clear()
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
   INITIALIZE g_tc_ima.* TO NULL    #No.FUN-750051
  IF g_argv1<>' ' THEN                     #FUN-7C0050
     LET g_wc=" tc_ima01='",g_argv1,"'"       #FUN-7C0050
     LET g_wc2=" 1=1"                      #FUN-7C0050
     LET g_wc3=" 1=1"                      #FUN-7C0050
     LET g_wc4=" 1=1"                      #FUN-7C0050
  ELSE
   CONSTRUCT BY NAME g_wc ON
                tc_ima01,tc_ima02,tc_ima03,tc_ima04,tc_ima05,tc_ima06,tc_imaconf,
                tc_imauser,tc_imagrup,tc_imamodu,tc_imadate,tc_imaacti,tc_imaoriu,tc_imaorig
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(tc_ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="cq_tc_ima"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_ima01
            NEXT FIELD tc_ima01
       
         WHEN INFIELD(tc_ima02)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_gen"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_ima02
            NEXT FIELD tc_ima02

         WHEN INFIELD(tc_ima03)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_eca1"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_ima03
            NEXT FIELD tc_ima03 

         WHEN INFIELD(tc_ima05)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="cq_ecg"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_ima05
            NEXT FIELD tc_ima05 

         WHEN INFIELD(tc_ima06)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_gen"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO tc_ima06
            NEXT FIELD tc_ima06   
         
         OTHERWISE EXIT CASE
      END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc2 = " 1=1"
   CONSTRUCT g_wc2 ON tc_imb02,tc_imb03,tc_imb04,tc_imb05,tc_imb06,tc_imb07,tc_imb08,tc_imb09,tc_imb11,tc_imb12,tc_imb10,tc_imb13
        FROM s_tc_imb[1].tc_imb02,s_tc_imb[1].tc_imb03,s_tc_imb[1].tc_imb04,s_tc_imb[1].tc_imb05,
             s_tc_imb[1].tc_imb06,s_tc_imb[1].tc_imb07,s_tc_imb[1].tc_imb08,s_tc_imb[1].tc_imb09,
             s_tc_imb[1].tc_imb11,s_tc_imb[1].tc_imb12,s_tc_imb[1].tc_imb10,s_tc_imb[1].tc_imb13  #add tc_imb12 by guanyao160922
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc3 = " 1=1"
   CONSTRUCT g_wc3 ON tc_imc02,tc_imc03,tc_imc05,tc_imc06,tc_imc07,
                      tc_imc08,tc_imc09,tc_imc10,tc_imc11,tc_imc12,tc_imc13
         FROM s_tc_imc[1].tc_imc02,s_tc_imc[1].tc_imc03,s_tc_imc[1].tc_imc05,s_tc_imc[1].tc_imc06,
              s_tc_imc[1].tc_imc07,s_tc_imc[1].tc_imc08,s_tc_imc[1].tc_imc09,s_tc_imc[1].tc_imc10,
              s_tc_imc[1].tc_imc11,s_tc_imc[1].tc_imc12,s_tc_imc[1].tc_imc13
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc4 = " 1=1"
   CONSTRUCT g_wc4 ON tc_imd02,tc_imd03,tc_imd04
         FROM s_tc_imd[1].tc_imd02,s_tc_imd[1].tc_imd03,s_tc_imd[1].tc_imd04
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 END IF  #FUN-7C0050
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND tc_imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND tc_imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND tc_imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_imauser', 'tc_imagrup')
   #End:FUN-980030
 
 
   LET g_sql  = "SELECT tc_ima01 "
   LET g_sql1 = " FROM tc_ima_file "
   LET g_sql2 = " WHERE ", g_wc CLIPPED
 
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imb_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_ima01=tc_imb01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imc_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_ima01=tc_imc01",
                                 " AND ",g_wc3 CLIPPED
   END IF
   IF g_wc4 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imd_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_ima01=tc_imd01",
                                 " AND ",g_wc4 CLIPPED
   END IF
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY tc_ima01'
 
   PREPARE t001_prepare FROM g_sql
   DECLARE t001_cs SCROLL CURSOR WITH HOLD FOR t001_prepare
 
   LET g_sql  = "SELECT COUNT(UNIQUE tc_ima01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE t001_precount FROM g_sql
   DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
DEFINE l_cmd  LIKE type_file.chr1000        #No.FUN-820002
#str---add by guanyao160923
DEFINE   w    ui.Window      
DEFINE   f    ui.Form       
DEFINE   page om.DomNode
#end---add by guanyao160923
   WHILE TRUE
# NO.FUN-540036--start
#     CALL t001_bp("G")
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "accessory")
            CALL t001_bp1("G")
         WHEN (l_action_flag = "user_defined_columns")
            CALL t001_bp2("G")
         WHEN (l_action_flag = "spare_part")
            CALL t001_bp3("G")
      END CASE
# NO.FUN-540036--end
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
         #WHEN "reproduce"
         #   IF cl_chk_act_auth() THEN
         #      CALL t001_copy()
         #   END IF
         WHEN "confirm"               #審核 
           IF cl_chk_act_auth() THEN
                CALL t001_y()
           END IF 
         WHEN "undo_confirm"          #取消審核?
            IF cl_chk_act_auth() THEN
               CALL t001_z()
            END IF
         WHEN "sure"                  #交接确认
            IF cl_chk_act_auth() THEN 
               CALL t001_s()
            END IF   
         WHEN "undo_sure"             #取消确认
            IF cl_chk_act_auth() THEN 
               CALL t001_us()
            END IF      
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t001_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t001_x()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()                                           
               THEN CALL t001_out()                                    
            END IF                                                         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         #str----add by guanyao160923
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE l_action_flag 
                  WHEN 'accessory' 
                     LET page = f.FindNode("Page","page3")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imb),'','')
                  WHEN 'user_defined_columns'
                     LET page = f.FindNode("Page","page4")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imc),'','')
                   WHEN 'spare_part'
                     LET page = f.FindNode("Page","page5")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imd),'','')
                   OTHERWISE 
                     LET page = f.FindNode("Page","page3")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imb),'','')
               END CASE
            END IF
         #end----add by guanyao160923
         #No.FUN-6B0050-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_ima.tc_ima01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_ima01"
                 LET g_doc.value1 = g_tc_ima.tc_ima01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t001_a()
DEFINE   l_no  VARCHAR(20)
DEFINE   l_gen02   LIKE gen_file.gen02

   IF s_shut(0) THEN RETURN END IF
   
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_imb.clear()
   CALL g_tc_imc.clear()
   CALL g_tc_imd.clear()
   INITIALIZE g_tc_ima.* LIKE tc_ima_file.*             #DEFAULT 設定
   LET g_tc_ima01_t = NULL
   #預設值及將數值類變數清成零
   LET g_tc_ima.tc_ima02 = g_user 
   LET g_tc_ima.tc_ima04 = g_today
   LET g_tc_ima.tc_imaconf = "N"
   LET g_tc_ima.tc_imauser = g_user
   LET g_tc_ima.tc_imaoriu = g_user #FUN-980030
   LET g_tc_ima.tc_imaorig = g_grup #FUN-980030
   LET g_tc_ima.tc_imagrup = g_grup
   LET g_tc_ima.tc_imadate = g_today
   LET g_tc_ima.tc_imaacti = 'Y'              #資料有效
   LET g_tc_ima.tc_imaud02 = 'Y'    #add by guanyao160923
   LET g_tc_ima.tc_imaud03 = '3'    #add by guanyao160923
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tc_ima.tc_ima02
   DISPLAY l_gen02 TO gen02
   CALL cl_opmsg('a')
   WHILE TRUE
      #str----mark by guanyao160926
      #CALL p_zl_auno88('') RETURNING l_no 
      #LET g_tc_ima.tc_ima01 = l_no
      #end----mark by guanyao160926
      CALL t001_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_tc_ima.* TO NULL
         EXIT WHILE
      END IF

      #str-----add by guanyao160926
      CALL p_zl_auno88('') RETURNING l_no 
      LET g_tc_ima.tc_ima01 = l_no
      DISPLAY BY NAME g_tc_ima.tc_ima01
      IF cl_null(g_tc_ima.tc_ima01) THEN 
         CALL cl_err('','cec-027',0)
         INITIALIZE g_tc_ima.* TO NULL
         EXIT WHILE
      END IF 
      #end-----add by guanyao160926
      INSERT INTO tc_ima_file VALUES (g_tc_ima.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_ima_file",g_tc_ima.tc_ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      SELECT tc_ima01 INTO g_tc_ima.tc_ima01 FROM tc_ima_file
       WHERE tc_ima01 = g_tc_ima.tc_ima01
      LET g_tc_ima01_t = g_tc_ima.tc_ima01        #保留舊值
      LET g_tc_ima_t.* = g_tc_ima.*

      CALL t001_ins_tmp()                       #插入临时表  #mark by guanyao160927
      CALL t001_ins_body()                      #单身赋值 
      
      CALL t001_b1_fill(" 1=1")                 #單身-1
      CALL t001_b2_fill(" 1=1")                 #單身-2
      CALL t001_b3_fill(" 1=1")                 #單身-3
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t001_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_ima.tc_ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tc_ima.tc_imaconf = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
   IF g_tc_ima.tc_imaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   
   SELECT * INTO g_tc_ima.* FROM tc_ima_file
    WHERE tc_ima01=g_tc_ima.tc_ima01
   IF g_tc_ima.tc_imaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_ima.tc_ima01,9027,0)
      RETURN
   END IF 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_ima01_t = g_tc_ima.tc_ima01
   LET g_tc_ima_o.* = g_tc_ima.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t001_cl USING g_tc_ima.tc_ima01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_tc_ima.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t001_show()
   WHILE TRUE
      LET g_tc_ima01_t = g_tc_ima.tc_ima01
      LET g_tc_ima.tc_imamodu=g_user
      LET g_tc_ima.tc_imadate=g_today
      CALL t001_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_ima.*=g_tc_ima_t.*
         CALL t001_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_tc_ima.tc_ima01 != g_tc_ima01_t THEN            
         UPDATE tc_imb_file SET tc_imb01 = g_tc_ima.tc_ima01 WHERE tc_imb01 = g_tc_ima01_t
         UPDATE tc_imc_file SET tc_imc01 = g_tc_ima.tc_ima01 WHERE tc_imc01 = g_tc_ima01_t
         UPDATE tc_imd_file SET tc_imd01 = g_tc_ima.tc_ima01 WHERE tc_imd01 = g_tc_ima01_t
      END IF
      UPDATE tc_ima_file SET tc_ima_file.* = g_tc_ima.* WHERE tc_ima01 = g_tc_ima01_t 
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
         CALL cl_err3("upd","tc_ima_file",g_tc_ima.tc_ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t001_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t001_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
    l_pmc03         LIKE pmc_file.pmc03,
    l_yy,l_mm       LIKE type_file.num5,    #No.FUN-680072SMALLINT
    l_fii03         LIKE fii_file.fii03
DEFINE   l_n,l_n1    LIKE type_file.num5     #TQC-720052
DEFINE   l_gen02     LIKE gen_file.gen02
DEFINE   l_eca02     LIKE eca_file.eca02
DEFINE   l_ecg02     LIKE ecg_file.ecg02
DEFINE   l_genacti   LIKE gen_file.genacti
    
    LET l_n = 0   #TQC-720052
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
    INPUT BY NAME 
          #g_tc_ima.tc_ima01,g_tc_ima.tc_ima02,g_tc_ima.tc_ima03,g_tc_ima.tc_ima04,  #mark by guanyao160926
          g_tc_ima.tc_ima02,g_tc_ima.tc_ima03,g_tc_ima.tc_ima04,                     #add by guanyao160926
          g_tc_ima.tc_ima05,g_tc_ima.tc_ima06,g_tc_ima.tc_imaconf,  
          g_tc_ima.tc_imauser,g_tc_ima.tc_imagrup,g_tc_ima.tc_imamodu,g_tc_ima.tc_imaoriu,
          g_tc_ima.tc_imaorig,g_tc_ima.tc_imadate,g_tc_ima.tc_imaacti
          ,g_tc_ima.tc_imaud02,g_tc_ima.tc_imaud03   #add by guanyao160923
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t001_set_entry(p_cmd)
           CALL t001_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_comp_entry("tc_ima06",FALSE)

        AFTER FIELD tc_ima02
           IF NOT cl_null(g_tc_ima.tc_ima02) THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM gen_file WHERE gen01=g_tc_ima.tc_ima02 AND genacti='Y'
              IF l_n1 = 0 THEN 
                 CALL cl_err(g_tc_ima.tc_ima02,'aap-038',0)
                 NEXT FIELD tc_ima02
               ELSE 
                 LET l_gen02 = ''
                 SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tc_ima.tc_ima02
                 DISPLAY l_gen02 TO gen02  
              END IF 
           END IF

        AFTER FIELD tc_ima03
           IF NOT cl_null(g_tc_ima.tc_ima03) THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM eca_file WHERE eca01=g_tc_ima.tc_ima03
              IF l_n1 = 0 THEN 
                 CALL cl_err(g_tc_ima.tc_ima03,'aec-054',0)
                 NEXT FIELD tc_ima03
               ELSE 
                 LET l_eca02 = ''
                 SELECT eca02 INTO l_eca02 FROM eca_file WHERE eca01=g_tc_ima.tc_ima03
                 DISPLAY l_eca02 TO eca02  
              END IF 
           END IF   

        AFTER FIELD tc_ima05
           IF NOT cl_null(g_tc_ima.tc_ima05) THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM ecg_file WHERE ecg01=g_tc_ima.tc_ima05
              IF l_n1 = 0 THEN 
                 CALL cl_err(g_tc_ima.tc_ima05,'mfg4028',0)
                 NEXT FIELD tc_ima05
               ELSE 
                 LET l_ecg02 = ''
                 SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01=g_tc_ima.tc_ima05
                 DISPLAY l_ecg02 TO ecg02  
              END IF 
           END IF

        AFTER FIELD tc_ima06
           IF NOT cl_null(g_tc_ima.tc_ima06) THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM gen_file WHERE gen01=g_tc_ima.tc_ima06 AND genacti='Y'
              IF l_n1 = 0 THEN 
                 CALL cl_err(g_tc_ima.tc_ima06,'aap-038',0)
                 NEXT FIELD tc_ima06
               ELSE 
                 LET l_gen02 = ''
                 SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tc_ima.tc_ima06
                 DISPLAY l_gen02 TO gen02a  
              END IF 
           END IF    
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(tc_ima02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_ima.tc_ima02
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_tc_ima.tc_ima02
                 DISPLAY BY NAME g_tc_ima.tc_ima02
                 NEXT FIELD tc_ima02

              WHEN INFIELD(tc_ima03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_ima.tc_ima03
                 LET g_qryparam.form ="q_eca1"
                 CALL cl_create_qry() RETURNING g_tc_ima.tc_ima03
                 DISPLAY BY NAME g_tc_ima.tc_ima03
                 NEXT FIELD tc_ima03

              WHEN INFIELD(tc_ima05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_ima.tc_ima05
                 LET g_qryparam.form ="cq_ecg"
                 CALL cl_create_qry() RETURNING g_tc_ima.tc_ima05
                 DISPLAY BY NAME g_tc_ima.tc_ima05
                 NEXT FIELD tc_ima05   

              WHEN INFIELD(tc_ima06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_ima.tc_ima06
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_tc_ima.tc_ima06
                 DISPLAY BY NAME g_tc_ima.tc_ima06
                 NEXT FIELD tc_ima06   

              OTHERWISE EXIT CASE
        END CASE
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
FUNCTION t001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tc_ima.* TO NULL               #No.FUN-6B0050
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_imb.clear()
   CALL g_tc_imc.clear()
   CALL g_tc_imd.clear()
 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t001_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_ima.* TO NULL
   ELSE
      OPEN t001_count
      FETCH t001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t001_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t001_cs INTO g_tc_ima.tc_ima01
      WHEN 'P' FETCH PREVIOUS t001_cs INTO g_tc_ima.tc_ima01
      WHEN 'F' FETCH FIRST    t001_cs INTO g_tc_ima.tc_ima01
      WHEN 'L' FETCH LAST     t001_cs INTO g_tc_ima.tc_ima01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t001_cs INTO g_tc_ima.tc_ima01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_ima.* TO NULL  #TQC-6B0105
      CLEAR FORM
      CALL g_tc_imb.clear()
      CALL g_tc_imc.clear()
      CALL g_tc_imd.clear()
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
   SELECT * INTO g_tc_ima.* FROM tc_ima_file WHERE tc_ima01 = g_tc_ima.tc_ima01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("sel","tc_ima_file",g_tc_ima.tc_ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
      INITIALIZE g_tc_ima.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_tc_ima.tc_imauser   #FUN-4C0069
   LET g_data_group = g_tc_ima.tc_imagrup   #FUN-4C0069
   CALL t001_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t001_show()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_eca02 LIKE eca_file.eca02
DEFINE l_ecg02 LIKE ecg_file.ecg02

   LET g_tc_ima_t.* = g_tc_ima.*                #保存單頭舊值
   DISPLAY BY NAME 
          g_tc_ima.tc_ima01,g_tc_ima.tc_ima02,g_tc_ima.tc_ima03,g_tc_ima.tc_ima04,
          g_tc_ima.tc_ima05,g_tc_ima.tc_ima06,g_tc_ima.tc_imaconf,  
          g_tc_ima.tc_imauser,g_tc_ima.tc_imagrup,g_tc_ima.tc_imamodu,g_tc_ima.tc_imaoriu,
          g_tc_ima.tc_imaorig,g_tc_ima.tc_imadate,g_tc_ima.tc_imaacti

   LET l_gen02 = ''       
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tc_ima.tc_ima02
   DISPLAY l_gen02 TO gen02

   LET l_eca02 = ''
   SELECT eca02 INTO l_eca02 FROM eca_file WHERE eca01=g_tc_ima.tc_ima03
   DISPLAY l_eca02 TO eca02 

   LET l_ecg02 = ''
   SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01=g_tc_ima.tc_ima05
   DISPLAY l_ecg02 TO ecg02

   LET l_gen02 = ''
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tc_ima.tc_ima06
   DISPLAY l_gen02 TO gen02a 
              
   CALL t001_b1_fill(g_wc2)                 #單身
   CALL t001_b2_fill(g_wc3)                 #單身
   CALL t001_b3_fill(g_wc4)                 #單身
   CALL t001_pic()
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t001_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_ima.tc_ima01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_tc_ima.tc_imaconf = 'Y' THEN CALL cl_err("",'9023',0) RETURN END IF 
   SELECT * INTO g_tc_ima.* FROM tc_ima_file WHERE tc_ima01=g_tc_ima.tc_ima01
   #No.TQC-920110 add --begin
   IF g_tc_ima.tc_imaacti = 'N' THEN
      CALL cl_err('','abm-950',0)
      RETURN
   END IF
   #No.TQC-920110 add --end
 
   BEGIN WORK
   OPEN t001_cl USING g_tc_ima.tc_ima01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)         
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_tc_ima.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t001_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "tc_ima01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_tc_ima.tc_ima01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tc_imb_file WHERE tc_imb01 = g_tc_ima.tc_ima01
      IF STATUS THEN
         CALL cl_err3("del","tc_imb_file",g_tc_ima.tc_ima01,"",STATUS,"","del tc_imb:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imc_file WHERE tc_imc01 = g_tc_ima.tc_ima01
      IF STATUS THEN
         CALL cl_err3("del","tc_imc_file",g_tc_ima.tc_ima01,"",STATUS,"","del tc_imc:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imd_file WHERE tc_imd01 = g_tc_ima.tc_ima01
      IF STATUS THEN
         CALL cl_err3("del","tc_imd_file",g_tc_ima.tc_ima01,"",STATUS,"","del tc_imd:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_ima_file WHERE tc_ima01 = g_tc_ima.tc_ima01
      IF STATUS THEN
         CALL cl_err3("del","tc_ima_file",g_tc_ima.tc_ima01,"",STATUS,"","del tc_ima:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_tc_ima.* TO NULL
      CLEAR FORM
      CALL g_tc_imb.clear()
      CALL g_tc_imc.clear()
      CALL g_tc_imd.clear()
      OPEN t001_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t001_cs
         CLOSE t001_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t001_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t001_cs
         CLOSE t001_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
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
   END IF
   CLOSE t001_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t001_b1_fill(p_wc1)
DEFINE
   #p_wc1           VARCHAR(200) #TQC-630166     
    p_wc1           STRING    #TQC-630166    
    #str----add by guanyao160923 
    DEFINE l_tc_imb06    LIKE tc_imb_file.tc_imb06  
    DEFINE l_tc_imb07    LIKE tc_imb_file.tc_imb07
    DEFINE l_tc_imb08    LIKE tc_imb_file.tc_imb08
    DEFINE l_tc_imb09    LIKE tc_imb_file.tc_imb09
    DEFINE l_tc_imb10    LIKE tc_imb_file.tc_imb10
    DEFINE l_tc_imb11    LIKE tc_imb_file.tc_imb11
    DEFINE l_tc_imb12    LIKE tc_imb_file.tc_imb12
    DEFINE l_tc_imb13    LIKE tc_imb_file.tc_imb13
    #end----add by guanyao160923 

    #str---add by guanyao160923
    LET l_tc_imb06 = 0 LET l_tc_imb07 = 0 LET l_tc_imb08 = 0 LET l_tc_imb09 = 0 
    LET l_tc_imb10 = 0 LET l_tc_imb11 = 0 LET l_tc_imb12 = 0 LET l_tc_imb13 = 0   
    #end---add by gaunyao160923
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
    #LET g_sql = "SELECT tc_imb02,tc_imb03,'',tc_imb04,tc_imb05,'','',tc_imb06,tc_imb07,tc_imb08,tc_imb09,tc_imb11,tc_imb10", #mark by guanyao160822
    LET g_sql = "SELECT tc_imb02,tc_imb03,'',tc_imb04,tc_imb05,'','','',tc_imb06,tc_imb07,tc_imb08,tc_imb09,tc_imb11,tc_imb12,tc_imb10,tc_imb13",  #add '' by guanyao160922
                "  FROM tc_imb_file",
                " WHERE tc_imb10 !=0 AND tc_imb01 ='",g_tc_ima.tc_ima01,"'",
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY 1"  #add by huanglf170117
    PREPARE t001_pb1 FROM g_sql
    DECLARE tc_imb_curs1 CURSOR FOR t001_pb1
 
    CALL g_tc_imb.clear()
    LET l_ac = 1
    FOREACH tc_imb_curs1 INTO g_tc_imb[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ecd02 INTO g_tc_imb[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_tc_imb[l_ac].tc_imb03 #add by gujq 20160905
       SELECT sfb05 INTO g_tc_imb[l_ac].sfb05 FROM sfb_file WHERE sfb01 = g_tc_imb[l_ac].tc_imb05 #add by gujq 20160905
       SELECT ima02,ima021 INTO g_tc_imb[l_ac].ima02_2,g_tc_imb[l_ac].ima021_2 FROM ima_file WHERE ima01 = g_tc_imb[l_ac].sfb05 #add by gujq 20160905

       LET l_tc_imb06 = l_tc_imb06 +g_tc_imb[l_ac].tc_imb06
       LET l_tc_imb07 = l_tc_imb07 +g_tc_imb[l_ac].tc_imb07
       LET l_tc_imb08 = l_tc_imb08 +g_tc_imb[l_ac].tc_imb08
       LET l_tc_imb09 = l_tc_imb09 +g_tc_imb[l_ac].tc_imb09
       LET l_tc_imb10 = l_tc_imb10 +g_tc_imb[l_ac].tc_imb10
       LET l_tc_imb11 = l_tc_imb11 +g_tc_imb[l_ac].tc_imb11
       LET l_tc_imb12 = l_tc_imb12 +g_tc_imb[l_ac].tc_imb12
       LET l_tc_imb13 = l_tc_imb13 +g_tc_imb[l_ac].tc_imb13


       IF l_tc_imb10  = 0 THEN

       END IF 
    
       LET l_ac=l_ac+1
  # IF g_cnt > g_max_rec THEN  #ly 放到10W
    IF g_cnt > 100000 THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    #CALL g_tc_imb.deleteElement(l_ac)
    #LET g_rec_b1 = l_ac-1
    #str----add by guanyao160923
    LET g_tc_imb[l_ac].tc_imb03 = '汇总'
    LET g_tc_imb[l_ac].tc_imb06 = l_tc_imb06
    LET g_tc_imb[l_ac].tc_imb07 = l_tc_imb07
    LET g_tc_imb[l_ac].tc_imb08 = l_tc_imb08
    LET g_tc_imb[l_ac].tc_imb09 = l_tc_imb09
    LET g_tc_imb[l_ac].tc_imb10 = l_tc_imb10
    LET g_tc_imb[l_ac].tc_imb11 = l_tc_imb11
    LET g_tc_imb[l_ac].tc_imb12 = l_tc_imb12
    LET g_tc_imb[l_ac].tc_imb13 = l_tc_imb13
    #end----add by guanyao160923
    LET g_rec_b1 = l_ac
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t001_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200) #TQC-630166 
    p_wc2           STRING    #TQC-630166 
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imc02,tc_imc03,'',tc_imc05,tc_imc06,ima02,ima021,tc_imc07,'','', ",
                "       tc_imc08,tc_imc09,tc_imc10,tc_imc11,tc_imc12,tc_imc13 ",
                " FROM tc_imc_file LEFT JOIN ima_file ON ima01=tc_imc06 ",
                " WHERE tc_imc01 ='",g_tc_ima.tc_ima01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE t001_pb2 FROM g_sql
    DECLARE tc_imc_curs2 CURSOR FOR t001_pb2
 
    CALL g_tc_imc.clear()
    LET g_cnt = 1
    FOREACH tc_imc_curs2 INTO g_tc_imc[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       SELECT ecd02 INTO g_tc_imc[g_cnt].ecd02_1 FROM ecd_file WHERE ecd01 = g_tc_imc[g_cnt].tc_imc03
       SELECT ima02,ima021 INTO g_tc_imc[g_cnt].ima02c,g_tc_imc[g_cnt].ima021c FROM ima_file 
        WHERE ima01=g_tc_imc[g_cnt].tc_imc07
        
       LET g_cnt = g_cnt + 1
      # IF g_cnt > g_max_rec THEN  #ly 放到10W
    IF g_cnt > 100000 THEN 
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imc.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
END FUNCTION
 
FUNCTION t001_b3_fill(p_wc3)
DEFINE
   #p_wc3           VARCHAR(200) #TQC-630166
    p_wc3           STRING    #TQC-630166
 
    IF cl_null(p_wc3) THEN LET p_wc3 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imd02,tc_imd03,ima02,ima021,tc_imd04 ",
                "  FROM tc_imd_file LEFT JOIN ima_file ON ima01=tc_imd03 ",
                " WHERE tc_imd01 ='",g_tc_ima.tc_ima01,"'",
                "   AND ",p_wc3 CLIPPED,
                " ORDER BY 1"
    PREPARE t001_pb3 FROM g_sql
    DECLARE tc_imd_curs3 CURSOR FOR t001_pb3
 
    CALL g_tc_imd.clear()
    LET l_ac = 1
    FOREACH tc_imd_curs3 INTO g_tc_imd[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
  # IF g_cnt > g_max_rec THEN  #ly 放到10W
    IF g_cnt > 100000 THEN

          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imd.deleteElement(l_ac)
    LET g_rec_b3 = l_ac-1
    DISPLAY g_rec_b3 TO FORMONLY.cn4
END FUNCTION
 
# NO.FUN-540036--start
FUNCTION t001_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_cmd  LIKE type_file.chr1000         #No.FUN-820002
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN    #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "accessory" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imb TO s_tc_imb.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION user_defined_columns
        LET l_action_flag = "user_defined_columns"
     EXIT DISPLAY
 
     ON ACTION spare_part
        LET l_action_flag = "spare_part"
     EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
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
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY    
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION sure
         LET g_action_choice="sure"
         EXIT DISPLAY 
      ON ACTION undo_sure
         LET g_action_choice="undo_sure"
         EXIT DISPLAY    
      ON ACTION first
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
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
 
      #ON ACTION accept
      #   LET g_action_choice="accessory"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end     
      #str----add by guanyao160923
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"          
         EXIT DISPLAY
      #end----add by guanyao160923
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
# NO.FUN-540036--end
 
# NO.FUN-540036--start
FUNCTION t001_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN               #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "user_defined_columns" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imc TO s_tc_imc.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION accessory
        LET l_action_flag = "accessory"
     EXIT DISPLAY
 
     ON ACTION spare_part
        LET l_action_flag = "spare_part"
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
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY 
      ON ACTION sure
         LET g_action_choice="sure"
         EXIT DISPLAY 
      ON ACTION undo_sure
         LET g_action_choice="undo_sure"
         EXIT DISPLAY    
      ON ACTION first
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
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
 
      #ON ACTION accept
      #   LET g_action_choice="user_defined_columns"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      #str----add by guanyao160923
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"          
         EXIT DISPLAY
      #end----add by guanyao160923
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-540036-end
 
 
# NO.FUN-540036--start
FUNCTION t001_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN     #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "spare_part" THEN  #FUN-D40030 add 
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imd TO s_tc_imd.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION accessory
        LET l_action_flag = "accessory"
     EXIT DISPLAY
 
     ON ACTION user_defined_columns
        LET l_action_flag = "user_defined_columns"
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
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY 
      ON ACTION sure
         LET g_action_choice="sure"
         EXIT DISPLAY
      ON ACTION undo_sure
         LET g_action_choice="undo_sure"
         EXIT DISPLAY     
      ON ACTION first
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
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
 
      #ON ACTION accept
      #   LET g_action_choice="spare_part"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      #str----add by guanyao160923
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"          
         EXIT DISPLAY
      #end----add by guanyao160923
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-540036-end
 
#No.FUN-820002--start--
FUNCTION t001_out()
#DEFINE
#   l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
#   sr              RECORD
#       tc_ima01       LIKE tc_ima_file.tc_ima01,
#       tc_ima02       LIKE tc_ima_file.tc_ima02,
#       tc_ima06       LIKE tc_ima_file.tc_ima06,
#       tc_ima14       LIKE tc_ima_file.tc_ima14,
#       tc_ima15       LIKE tc_ima_file.tc_ima15,
#       tc_ima16       LIKE tc_ima_file.tc_ima16,
#       tc_ima17       LIKE tc_ima_file.tc_ima17,
#       tc_ima10       LIKE tc_ima_file.tc_ima10,
#       gen02       LIKE gen_file.gen02
#      END RECORD,
#   l_name          LIKE type_file.chr20,          #No.FUN-680072 VARCHAR(20)
 
#   l_za05          LIKE type_file.chr1000         #No.FUN-680072 VARCHAR(40)
DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_tc_ima.tc_ima01) THEN                          
       LET g_wc = " tc_ima01 = '",g_tc_ima.tc_ima01,"' "                                 
    END IF                                                                      
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0) RETURN                                          
    END IF                                                                      
    LET l_cmd = 'p_query "aemt001" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
#   IF cl_null(g_wc) AND NOT cl_null(g_tc_ima.tc_ima01) THEN
#      LET g_wc = " tc_ima01 = '",g_tc_ima.tc_ima01,"' "
#   END IF
#   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF
#   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1 " END IF
#   IF cl_null(g_wc4) THEN LET g_wc4 = " 1=1 " END IF
#   IF cl_null(g_wc5) THEN LET g_wc5 = " 1=1 " END IF
#   CALL cl_wait()
#   CALL cl_outnam('aemt001') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   LET g_sql="SELECT tc_ima01,tc_ima02,tc_ima06,tc_ima14,tc_ima15,tc_ima16,",
#             "       tc_ima17,tc_ima10,gen02 ",
#             g_sql1 CLIPPED,",LEFT OUTER JOIN tc_ima_file ON tc_ima_file.tc_ima10 = gen_file.gen02",
#             g_sql2 CLIPPED, 
#             " ORDER BY tc_ima01"
#   PREPARE t001_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t001_co CURSOR FOR t001_p1
 
#   START REPORT t001_rep TO l_name
 
#   FOREACH t001_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)             
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t001_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT t001_rep
 
#   CLOSE t001_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
FUNCTION t001_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_ima.tc_ima01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_tc_ima.* FROM tc_ima_file
    WHERE tc_ima01=g_tc_ima.tc_ima01
 
   BEGIN WORK
 
   OPEN t001_cl USING g_tc_ima.tc_ima01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)   
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_tc_ima.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   CALL t001_show()
   IF cl_exp(0,0,g_tc_ima.tc_imaacti) THEN                   #確認一下
       LET g_chr=g_tc_ima.tc_imaacti
       IF g_tc_ima.tc_imaacti='Y' THEN
           LET g_tc_ima.tc_imaacti='N'
       ELSE
           LET g_tc_ima.tc_imaacti='Y'
       END IF
       UPDATE tc_ima_file
          SET tc_imaacti=g_tc_ima.tc_imaacti, #更改有效碼
              tc_imamodu=g_user,
              tc_imadate=g_today
        WHERE tc_ima01=g_tc_ima.tc_ima01
       IF SQLCA.sqlcode OR STATUS=100 THEN
           CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   
           LET g_tc_ima.tc_imaacti=g_chr
       END IF
       SELECT tc_imaacti,tc_imamodu,tc_imadate
         INTO g_tc_ima.tc_imaacti,g_tc_ima.tc_imamodu,g_tc_ima.tc_imadate
         FROM tc_ima_file
        WHERE tc_ima01=g_tc_ima.tc_ima01
       DISPLAY BY NAME g_tc_ima.tc_imaacti,g_tc_ima.tc_imamodu,g_tc_ima.tc_imadate
   END IF
   CLOSE t001_cl
   COMMIT WORK
END FUNCTION
 
#FUNCTION t001_copy()
#DEFINE
#    l_newno        LIKE tc_ima_file.tc_ima01,
#    l_oldno        LIKE tc_ima_file.tc_ima01,
#    l_gen02        LIKE gen_file.gen02
    
#    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
#    IF s_shut(0) THEN RETURN END IF
#    IF g_tc_ima.tc_ima01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
#    LET g_before_input_done = FALSE
#    CALL t001_set_entry('a')
#    LET g_before_input_done = TRUE
 
#    INPUT l_newno FROM tc_ima01
#        AFTER FIELD tc_ima01
#            IF l_newno IS NULL THEN
#                NEXT FIELD tc_ima01
#            END IF
#            SELECT COUNT(*) INTO g_cnt FROM tc_ima_file
#             WHERE tc_ima01 = l_newno
#            IF g_cnt > 0 THEN
#               CALL cl_err(l_newno,-239,0)
#               NEXT FIELD tc_ima01
#            END IF

#      ON ACTION controlp                        # 沿用所有欄位
#           IF INFIELD(tc_ima01) THEN
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_gen"
#              LET g_qryparam.default1 = g_tc_ima.tc_ima01
#              CALL cl_create_qry() RETURNING l_newno
#              DISPLAY l_newno TO tc_ima01

#              SELECT gen01 FROM gen_file WHERE gen01= l_newno
#              IF SQLCA.sqlcode THEN
#                 DISPLAY BY NAME g_tc_ima.tc_ima01
#                 LET l_newno = NULL
#                 NEXT FIELD tc_ima01
#              END IF
#              NEXT FIELD tc_ima01
#           END IF
       
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
  
#    END INPUT
#    IF INT_FLAG OR l_newno IS NULL THEN
#        LET INT_FLAG = 0
#        RETURN
#    END IF
#    DROP TABLE y
#    SELECT * FROM tc_ima_file         #單頭復制
#     WHERE tc_ima01=g_tc_ima.tc_ima01
#      INTO TEMP y
#    UPDATE y
#        SET tc_ima01=l_newno,     #新的鍵值
#            tc_imauser=g_user,    #資料所有者
#            tc_imagrup=g_grup,    #資料所有者所屬群
#            tc_imadate = g_today,
#            tc_imaacti = 'Y'
#    INSERT INTO tc_ima_file SELECT * FROM y
#    IF SQLCA.sqlcode THEN
##        CALL  cl_err(l_newno,SQLCA.sqlcode,0)  # No.FUN-660092
#        CALL cl_err3("ins","tc_ima_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
#    END IF
# 
#    DROP TABLE x
#    SELECT * FROM tc_imb_file         #單身復制
#     WHERE tc_imb01=g_tc_ima.tc_ima01
#     INTO TEMP x
#    IF SQLCA.sqlcode THEN
##       CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
#       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
#       RETURN
#    END IF
#    UPDATE x SET tc_imb01=l_newno
#    INSERT INTO tc_imb_file SELECT * FROM x
#    IF SQLCA.sqlcode THEN
##       CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
#       CALL cl_err3("ins","tc_imb_file",g_tc_ima.tc_ima01,g_tc_imb_t.tc_imb000,SQLCA.sqlcode,"","",1)  #No.FUN-660092
#       RETURN
#     END IF
#    SELECT COUNT(*) INTO g_cnt FROM tc_imb_file WHERE tc_imb01=l_newno
#    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
#    DROP TABLE x
#    SELECT * FROM tc_imc_file         #單身復制
#     WHERE tc_imc01=g_tc_ima.tc_ima01
#      INTO TEMP x
#    IF SQLCA.sqlcode THEN
##      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
#       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
#       RETURN
#    END IF
#    UPDATE x SET tc_imc01=l_newno
#    INSERT INTO tc_imc_file SELECT * FROM x
#    IF SQLCA.sqlcode THEN
##      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
#       CALL cl_err3("ins","tc_imc_file",l_newno,g_tc_imc_t.tc_imc000,SQLCA.sqlcode,"","",1)  #No.FUN-660092
#       RETURN
#    END IF
#    SELECT COUNT(*) INTO g_cnt FROM tc_imc_file WHERE tc_imc01=l_newno
#    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
#    DROP TABLE x
#    SELECT * FROM tc_imd_file         #單身復制
#     WHERE tc_imd01=g_tc_ima.tc_ima01
#      INTO TEMP x
#    IF SQLCA.sqlcode THEN
##      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
#       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
#       RETURN
#    END IF
#    UPDATE x SET tc_imd01=l_newno
#    INSERT INTO tc_imd_file SELECT * FROM x
#    IF SQLCA.sqlcode THEN
##      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)   #No.FUN-660092
#       CALL cl_err3("ins","tc_imd_file",l_newno,g_tc_imd_t.tc_imd000,SQLCA.sqlcode,"","",1)  #No.FUN-660092
#       RETURN
#    END IF
#    SELECT COUNT(*) INTO g_cnt FROM tc_imd_file WHERE tc_imd01=l_newno
#    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
#    LET l_oldno = g_tc_ima.tc_ima01
#    SELECT tc_ima_file.* INTO g_tc_ima.* FROM tc_ima_file
#     WHERE tc_ima01 = l_newno
#    CALL t001_u()
#    CALL t001_b1()
#    CALL t001_b2()
#    CALL t001_b3()
#END FUNCTION
 
FUNCTION t001_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          
  
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     #  CALL cl_set_comp_entry("tc_ima01",TRUE)
    END IF
    
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          
  
  IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_ima01",FALSE)       
    END IF  
 
END FUNCTION

FUNCTION t001_y()
 
   IF cl_null(g_tc_ima.tc_ima01) THEN 
        CALL cl_err('','apj-003',0) 
        RETURN 
   END IF
   
   IF g_tc_ima.tc_imaacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
 
   IF g_tc_ima.tc_imaconf = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('axm-108') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t001_cl USING g_tc_ima.tc_ima01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t001_cl INTO g_tc_ima.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)      
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE tc_ima_file SET tc_imaconf='Y' 
    WHERE tc_ima01 = g_tc_ima.tc_ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","tc_ima_file",g_tc_ima.tc_ima01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","tc_ima_file",g_tc_ima.tc_ima01,"","9050","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_tc_ima.tc_imaconf = 'Y'
         DISPLAY BY NAME g_tc_ima.tc_imaconf
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL t001_pic()     #圖形顯示   #CHI-BC0031 add
 
END FUNCTION
 
FUNCTION t001_z()
 
   IF cl_null(g_tc_ima.tc_ima01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
 
   IF g_tc_ima.tc_imaacti='N' THEN
        CALL cl_err('','atm-365',0)
        RETURN
   END IF
 
   IF g_tc_ima.tc_imaconf = 'N' THEN
      CALL cl_err('','9002',0)
      RETURN
   END IF

   IF NOT cl_null(g_tc_ima.tc_ima06) THEN
      CALL cl_err('','cec-022',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t001_cl USING g_tc_ima.tc_ima01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t001_cl INTO g_tc_ima.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_ima.tc_ima01,SQLCA.sqlcode,0)     
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE tc_ima_file SET tc_imaconf='N'
    WHERE tc_ima01 = g_tc_ima.tc_ima01
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("upd","tc_ima_file",g_tc_ima.tc_ima01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","tc_ima_file",g_tc_ima.tc_ima01,"","9053","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_tc_ima.tc_imaconf = 'N'
         DISPLAY BY NAME g_tc_ima.tc_imaconf
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL t001_pic()     #圖形顯示   #CHI-BC0031 add
 
END FUNCTION

FUNCTION t001_s()
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_gen02   LIKE gen_file.gen02

   IF cl_null(g_tc_ima.tc_ima01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF

   IF g_tc_ima.tc_imaconf = 'N' THEN
      CALL cl_err('','cec-019',0)
      RETURN
   END IF

   IF NOT cl_confirm('cec-020') THEN
      RETURN
    ELSE 
      CALL cl_set_comp_entry("tc_ima06",TRUE)  
   END IF

   BEGIN WORK 
   LET g_success = 'Y'

   DISPLAY BY NAME g_tc_ima.tc_ima06
   INPUT BY NAME g_tc_ima.tc_ima06 WITHOUT DEFAULTS

    BEFORE INPUT 
       LET g_tc_ima.tc_ima06 = g_user
       DISPLAY BY NAME g_tc_ima.tc_ima06  
      
    AFTER FIELD tc_ima06
       IF NOT cl_null(g_tc_ima.tc_ima06) THEN
          LET l_cnt = 0 
          SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01=g_tc_ima.tc_ima06
          IF l_cnt = 0 THEN
             CALL cl_err(g_tc_ima.tc_ima06,'aap-038',0)
             NEXT FIELD tc_ima06
           ELSE 
             LET l_gen02 = ''
             SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tc_ima.tc_ima06
             DISPLAY l_gen02 TO gen02a   
          END IF  
       END IF 
           
       AFTER INPUT 
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             LET g_tc_ima.tc_ima06=''
             DISPLAY BY NAME g_tc_ima.tc_ima06
             RETURN
          END IF

       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(tc_ima06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_ima.tc_ima06
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_tc_ima.tc_ima06
                 DISPLAY BY NAME g_tc_ima.tc_ima06
                 NEXT FIELD tc_ima06   

              OTHERWISE EXIT CASE
          END CASE
           
       ON ACTION CONTROLG 
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
   END INPUT
   
   UPDATE tc_ima_file SET tc_ima06=g_tc_ima.tc_ima06       #MOD-BA0008 add
    WHERE tc_ima01=g_tc_ima.tc_ima01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_tc_ima.tc_ima06  = ''
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN 
      COMMIT WORK 
    ELSE 
      ROLLBACK WORK   
   END IF 
  
END FUNCTION 

FUNCTION t001_us()
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_gen02   LIKE gen_file.gen02

   IF cl_null(g_tc_ima.tc_ima01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF

   IF cl_null(g_tc_ima.tc_ima06) THEN
      CALL cl_err('','cec-021',0)
      RETURN
   END IF

   IF g_tc_ima.tc_ima06 <> g_user THEN 
      CALL cl_err('','cec-025',0)
      RETURN 
   END IF
   
   IF NOT cl_confirm('cec-023') THEN
      RETURN 
   END IF
 
   
   BEGIN WORK 
   
   UPDATE tc_ima_file SET tc_ima06=NULL        #MOD-BA0008 add
    WHERE tc_ima01=g_tc_ima.tc_ima01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      ROLLBACK WORK 
    ELSE 
      LET g_tc_ima.tc_ima06 = ''
      COMMIT WORK
      DISPLAY '' TO gen02a     
   END IF
   DISPLAY BY NAME g_tc_ima.tc_ima06
  
END FUNCTION 

FUNCTION t001_pic()
   CASE g_tc_ima.tc_imaconf
        WHEN 'Y'   LET g_confirm = 'Y'
                   LET g_void = ''
        WHEN 'N'   LET g_confirm = 'N'
                   LET g_void = ''
        WHEN 'X'   LET g_confirm = ''
                   LET g_void = ''
     OTHERWISE     LET g_confirm = ''
                   LET g_void = ''
   END CASE 

   #圖形顯示
   CALL cl_set_field_pic(g_confirm, "" , "" ,  "" , g_void, g_tc_ima.tc_imaacti)
                        #確認碼    #核  #過帳  #結案    #作廢    #有效
END FUNCTION

FUNCTION p_zl_auno88(p_slip)
   DEFINE   p_slip VARCHAR(20),                    #單號
            l_yy   VARCHAR(4),
            l_mm   VARCHAR(2),
            l_mxno1 VARCHAR(10),
            l_mxno2 VARCHAR(04),
            l_buf  VARCHAR(6)
 
   LET p_slip=''
   LET l_yy=TODAY USING 'YYYY'
   LET l_mm=TODAY USING 'MM'
   LET l_buf=l_yy,l_mm
   SELECT MAX(tc_ima01) INTO l_mxno1 FROM tc_ima_file
    WHERE tc_ima01[1,6] = l_buf
   LET l_mxno2= l_mxno1[7,10]
   LET p_slip[7,10]=l_mxno2+1 USING '&&&&'
   IF cl_null(p_slip[5,10]) THEN
      IF l_mxno1 IS NULL OR l_mxno1=' ' THEN #最大編號未曾指定
          LET l_mxno2='0000'
          LET p_slip[7,10]=(l_mxno2+1) USING '&&&&'
      END IF
   END IF
   LET p_slip[1,6]=l_buf
   RETURN p_slip
END FUNCTION
#str------mark by guanyao160927
--FUNCTION t001_ins_tmp()
--DEFINE l_sql       STRING 
   --
   --DROP TABLE cect002_tmp
   --CREATE TEMP TABLE cect002_tmp
     --(sgm01      LIKE sgm_file.sgm01,
      --sgm02      LIKE sgm_file.sgm02,
      --sgm04      LIKE sgm_file.sgm04,
      --tc_shc12r   LIKE tc_shc_file.tc_shc12,
      --tc_shc12c   LIKE tc_shc_file.tc_shc12)
   --LET l_sql =" SELECT DISTINCT sgm01,sgm02,sgm04,'','' FROM sgm_file WHERE sgm04 ",
              --" IN (SELECT DISTINCT ecd01 FROM ecd_file WHERE ecd07='",g_tc_ima.tc_ima03,"')"
   #str----add by guanyao160923
   --IF g_tc_ima.tc_imaud03 = '1' THEN 
      --LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') =0"
   --END IF 
   --IF g_tc_ima.tc_imaud03 = '2' THEN 
      --LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') >0"
   --END IF 
   #end----add by guanyao160923
--
   --LET l_sql = " INSERT INTO cect002_tmp ",
               --"   SELECT sgm01,sgm02,sgm04,'','' ",
               --"     FROM (",l_sql CLIPPED,") "
   --PREPARE t001_ins FROM l_sql
   --EXECUTE t001_ins   
--
   #扫入量 
   --LET l_sql = " MERGE INTO cect002_tmp o ",
               --"      USING (SELECT tc_shc03,tc_shc08,SUM(tc_shc12) tc_shc12_r ", 
               --"               FROM tc_shc_file ",
               --"              WHERE tc_shc01 = '1' ",
               --"             GROUP BY tc_shc03,tc_shc08) n ",
               --"         ON (o.sgm01 = n.tc_shc03 AND o.sgm04 = n.tc_shc08) ",
               --" WHEN MATCHED ",
               --" THEN ",
               --"    UPDATE ",
               --"       SET o.tc_shc12r = NVL(n.tc_shc12_r,0) "
   --PREPARE t001_pre1 FROM l_sql
   --EXECUTE t001_pre1 
--
   #扫出量 
   --LET l_sql = " MERGE INTO cect002_tmp o ",
               --"      USING (SELECT tc_shc03,tc_shc08,SUM(tc_shc12) tc_shc12_c ", 
               --"               FROM tc_shc_file ",
               --"              WHERE tc_shc01 = '2' ",
               --"             GROUP BY tc_shc03,tc_shc08) n ",
               --"         ON (o.sgm01 = n.tc_shc03 AND o.sgm04 = n.tc_shc08) ",
               --" WHEN MATCHED ",
               --" THEN ",
               --"    UPDATE ",
               --"       SET o.tc_shc12c = NVL(n.tc_shc12_c,0) "
   --PREPARE t001_pre2 FROM l_sql
   --EXECUTE t001_pre2 
--
   --DELETE FROM cect002_tmp WHERE tc_shc12r = tc_shc12c OR tc_shc12r IS NULL 
   --
--END FUNCTION 
#end------mark by guanyao160927

FUNCTION t001_ins_tmp()
DEFINE l_sql  STRING 
DEFINE extime DATETIME YEAR TO SECOND
DEFINE l_sql1 STRING 
    DROP TABLE cect002_tmp
    CREATE TEMP TABLE cect002_tmp
     (l_tc_ima01 LIKE tc_ima_file.tc_ima01,
      sgm01      LIKE sgm_file.sgm01,
      sgm02      LIKE sgm_file.sgm02,
      sgm03      LIKE sgm_file.sgm03,
      sgm03_1    LIKE sgm_file.sgm03,
      sgm04      LIKE sgm_file.sgm04,
      sgm65      LIKE sgm_file.sgm65,
      wipqty     LIKE sgm_file.sgm301,
      sgm301     LIKE sgm_file.sgm301,
      sgm311     LIKE sgm_file.sgm311,
      sgm313     LIKE sgm_file.sgm313,
      sgm314     LIKE sgm_file.sgm314,
      l_sum1     LIKE tc_shc_file.tc_shc12,   #扫入
      l_sum2     LIKE tc_shc_file.tc_shc12,   #开工
      l_sum3     LIKE tc_shc_file.tc_shc12,   #完工
      l_sum4     LIKE tc_shc_file.tc_shc12,   #扫出
      l_sum5     LIKE tc_shc_file.tc_shc12,   #报废
      l_sum6     LIKE tc_shc_file.tc_shc12,   #返工
      l_sum7     LIKE tc_shc_file.tc_shc12,   #wip
      l_sum8     LIKE tc_shc_file.tc_shc12,   #PNL
      l_sum9     LIKE tc_shc_file.tc_shc12,   #入库
      l_sum10    LIKE tc_shc_file.tc_shc12)   #排版

{

    LET l_sql ="SELECT '',sgm01,sgm02,sgm03,0,sgm04,",
               "sgm65,sgm301-sgm311-sgm313-sgm314,sgm301,sgm311,sgm313,sgm314,",
               "nvl(a.num, 0),nvl(b.num, 0),nvl(c.num, 0),nvl(c.num1, 0),nvl(c.num2, 0),nvl(d.num, 0),",
              #"        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num1,0)-nvl(c.num, 0)-nvl(c.num2, 0)+nvl(c.num, 0)",
              "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num, 0)+nvl(c.num, 0)",
             # "                       ELSE nvl(a.num,0)-nvl(c.num1,0)-nvl(d.num,0)+nvl(d.num, 0) END CASE,0, ",
              "                       ELSE nvl(a.num,0)-nvl(d.num,0)+nvl(d.num, 0) END CASE,0, ",
              "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(c.num, 0) ",
              "                       ELSE nvl(d.num, 0) END CASE,",
              "        CASE imaud10 WHEN 0 THEN 1 ELSE nvl(imaud10,1) END CASE",
              "  FROM ecd_file,sfb_file,ima_file,shm_file,sgm_file ",
              "        LEFT OUTER JOIN (SELECT tc_shc03, tc_shc06, SUM(tc_shc12) num",#扫入
              "                           FROM tc_shc_file",
              "                          WHERE tc_shc01 = '1'",
              "                          GROUP BY tc_shc03,tc_shc06)a ON sgm01 = a.tc_shc03 ",
              "                                                      AND sgm03 = a.tc_shc06",
              "        LEFT OUTER JOIN (SELECT tc_shb03, tc_shb06, SUM(tc_shb12) num",#开工
              "                           FROM tc_shb_file",
              "                          WHERE tc_shb01 = '1'",
              "                          GROUP BY tc_shb03, tc_shb06) b ON sgm01 = b.tc_shb03 ",
              "                                                        AND sgm03 = b.tc_shb06 ",
              "        LEFT OUTER JOIN (SELECT tc_shb03, tc_shb06, SUM(tc_shb12) num,SUM(tc_shb121) num1,SUM(tc_shb122) num2 ",
              "                           FROM tc_shb_file",#完工，报废，返工
              "                          WHERE tc_shb01 = '2'",
              "                          GROUP BY tc_shb03, tc_shb06) c ON sgm01 = c.tc_shb03 ",
              "                                                        AND sgm03 = c.tc_shb06 ",
              "        LEFT OUTER JOIN (SELECT tc_shc03, tc_shc06, SUM(tc_shc12) num",#扫出
              "                           FROM tc_shc_file",
              "                          WHERE tc_shc01 = '2'",
              "                          GROUP BY tc_shc03, tc_shc06) d ON sgm01 = d.tc_shc03   ",
              "                                                        AND sgm03 = d.tc_shc06 ",
              "   WHERE ecd01 =sgm04 AND sgm01=shm01 AND shm06=sgm11 and shm28 = 'N' ",
              "     AND ecd07 = '",g_tc_ima.tc_ima03,"'",
             # "     AND (a.num >0 OR b.num >0)",  #add b.num by guanyao161006  ly20180124
              "     AND sgm02 = sfb01", 
              "     AND sfb04<>'8'",
              "     AND sgm301-sgm311-sgm313-sgm314>0 ",
              "     AND sfb87 = 'Y'",
              "     AND sgm03_par = ima01"
              
              }
              
      LET l_sql ="SELECT '',sgm01,sgm02,sgm03,0,sgm04,",
               "sgm65,sgm301-sgm311-sgm313-sgm314,sgm301,sgm311,sgm313,sgm314,",
       
     #l_sum1 扫入 l_sum2  开工 l_sum3  完工 l_sum4 扫出  l_sum5 报废  l_sum6 返工  l_sum7 wip l_sum8 PNL  l_sum9  入库 l_sum10 排版
               "'' sum1,'' sum2,'' sum3,'' sum4,'' sum5,'' sum6,",
              "   sgm301-sgm311-sgm313-sgm314 sum7 ,",
              "   '' sum8 , '' sum9  ",
              "        CASE imaud10 WHEN 0 THEN 1 ELSE nvl(imaud10,1) END CASE",
              "  FROM ecd_file,sfb_file,ima_file,shm_file,sgm_file ",
                   
              "   WHERE ecd01 =sgm04 AND sgm01=shm01 AND shm06=sgm11 and shm28 = 'N' ",
              "     AND ecd07 = '",g_tc_ima.tc_ima03,"'",
         
              "     AND sgm02 = sfb01", 
              "     AND sfb04<>'8'",
              "     AND sgm301-sgm311-sgm313-sgm314>0 ",
              "     AND sfb87 = 'Y'",
              "     AND sgm03_par = ima01"
              
   IF g_tc_ima.tc_imaud03 = '1' THEN 
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') =0"
   END IF 
   IF g_tc_ima.tc_imaud03 = '2' THEN 
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') >0"
   END IF 

   
 LET extime = CURRENT YEAR TO SECOND
 INSERT INTO tc_shb_time VALUES(extime)
 
   LET l_sql1 = " INSERT INTO cect002_tmp ",l_sql CLIPPED
   PREPARE t001_ins FROM l_sql1
   EXECUTE t001_ins

   

   {
   DELETE FROM cect002_tmp WHERE l_sum7 <= 0 
  # UPDATE cect002_tmp SET l_sum7 = l_sum7 - l_sum4 #add by huanglf170112
   UPDATE cect002_tmp SET l_sum7 = l_sum7 - l_sum4 #mod ly 180112
} #ly180124
   
END FUNCTION 

FUNCTION t001_ins_body()
DEFINE l_sql,l_sql1       STRING 
DEFINE l_sgm01     LIKE sgm_file.sgm01,      
       l_sgm02     LIKE sgm_file.sgm02,
       l_sgm04     LIKE sgm_file.sgm04,
       l_shc12r    LIKE tc_shc_file.tc_shc12,
       l_shc12c    LIKE tc_shc_file.tc_shc12,
       l_sfb01     LIKE sfb_file.sfb01,
       l_tc_imb09  LIKE tc_imb_file.tc_imb09,
       l_tc_imb08  LIKE tc_imb_file.tc_imb08,
       l_sfa161    LIKE sfa_file.sfa161
DEFINE l_seq1,l_seq2,l_seq3       LIKE type_file.num10
DEFINE l_tc_imb    RECORD LIKE tc_imb_file.*
DEFINE l_tc_imc    RECORD LIKE tc_imc_file.*
DEFINE l_tc_imd    RECORD LIKE tc_imd_file.*
DEFINE l_imaud10   LIKE ima_file.imaud10 #add by guanyao160923
DEFINE l_sfa08     LIKE sfa_file.sfa08   #add by guanyao161010
DEFINE l_tc_imb11  LIKE tc_imb_file.tc_imb11  #add by guanyao161010

   BEGIN WORK 
   LET g_success = 'Y'
   #str------mark by guanyao160927#不用临时表,直接写一个sql
   --LET l_sql =" SELECT * FROM cect002_tmp "
   --PREPARE ecd_prepare FROM l_sql
   --DECLARE ecd_cursor CURSOR FOR ecd_prepare
   --
   --FOREACH ecd_cursor INTO l_sgm01,l_sgm02,l_sgm04,l_shc12r,l_shc12c         #LOT单号，工单号，作业编号，扫入量，扫出量
      --IF STATUS THEN LET g_success = 'N' CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      --IF g_success = 'N' THEN EXIT FOREACH END IF 
      #insert into tc_imb_file
      --INITIALIZE l_tc_imb.* TO NULL 
       #扫入量
      --LET l_tc_imb.tc_imb06 = l_shc12r 
      --IF cl_null(l_tc_imb.tc_imb06) THEN LET l_tc_imb.tc_imb06 = 0 END IF   
       #扫出量    
      --LET l_tc_imb.tc_imb09 = l_shc12c
      --IF cl_null(l_tc_imb.tc_imb09) THEN LET l_tc_imb.tc_imb09 = 0 END IF 
       #开工量
      #SELECT tc_shb12 INTO l_tc_imb.tc_imb07 FROM tc_shb_file WHERE tc_shb03 = l_sgm01      #mark by guanyao160922
      --SELECT SUM(tc_shb12) INTO l_tc_imb.tc_imb07 FROM tc_shb_file WHERE tc_shb03 = l_sgm01  #add by guanyao160922
         --AND tc_shb08 = l_sgm04 AND tc_shb01 = '1' 
      --IF cl_null(l_tc_imb.tc_imb07) THEN LET l_tc_imb.tc_imb07 = 0 END IF     
       #完工量
      #SELECT tc_shb12 INTO l_tc_imb.tc_imb08 FROM tc_shb_file WHERE tc_shb03 = l_sgm01     #mark by guanyao160922
      --SELECT SUM(tc_shb12) INTO l_tc_imb.tc_imb08 FROM tc_shb_file WHERE tc_shb03 = l_sgm01 #add by guanyao160922
         --AND tc_shb08 = l_sgm04 AND tc_shb01 = '2'
      --IF cl_null(l_tc_imb.tc_imb08) THEN LET l_tc_imb.tc_imb08 = 0 END IF 
       #报废量
      --SELECT SUM(tc_shb121) INTO l_tc_imb.tc_imb11 FROM tc_shb_file WHERE tc_shb03 = l_sgm01
         --AND tc_shb08 = l_sgm04  AND tc_shb01='2'
      --IF cl_null(l_tc_imb.tc_imb11) THEN LET l_tc_imb.tc_imb11 = 0 END IF 
      #str----add by guanyao160922
      --SELECT SUM(tc_shb122) INTO l_tc_imb.tc_imb12 FROM tc_shb_file WHERE tc_shb03 = l_sgm01
         --AND tc_shb08 = l_sgm04  AND tc_shb01='2'
      --IF cl_null(l_tc_imb.tc_imb12) THEN LET l_tc_imb.tc_imb12 = 0 END IF 
      #end----add by guanyao160922
       #WIP量(扫入-扫出-报废)   
      --LET l_tc_imb.tc_imb10 = l_tc_imb.tc_imb06 - l_tc_imb.tc_imb09 - l_tc_imb.tc_imb11
      #str----add by guanyao160923
      --LET l_imaud10 = ''
      --SELECT DISTINCT nvl(imaud10,1) INTO l_imaud10 FROM ima_file,shm_file WHERE ima01 = shm05 AND shm01 = l_sgm01
      --IF l_imaud10 = 0 THEN LET l_imaud10 = 1 END IF 
      --LET l_tc_imb.tc_imb13 = l_tc_imb.tc_imb10/l_imaud10
      #end----add by guanyao160923
      #str-----add by guanyao160923
      --IF g_tc_ima.tc_imaud02 = 'Y' THEN 
         --IF l_tc_imb.tc_imb10 = 0 THEN 
            --CONTINUE FOREACH 
         --END IF 
      --END IF 
      #end-----add by guanyao160923
       #项次
      --SELECT MAX(tc_imb02) INTO l_seq1 FROM tc_imb_file WHERE tc_imb01=g_tc_ima.tc_ima01
      --IF cl_null(l_seq1) THEN
         --LET l_seq1 = 1
       --ELSE 
         --LET l_seq1 = l_seq1 + 1 
      --END IF 
      --INSERT INTO tc_imb_file(tc_imb01,tc_imb02,tc_imb03,tc_imb04,tc_imb05,
                              --tc_imb06,tc_imb07,tc_imb08,tc_imb09,tc_imb10,tc_imb11,tc_imb12,tc_imb13) #add tc_imb12 by guanyao160922
         --VALUES(g_tc_ima.tc_ima01,l_seq1,l_sgm04,l_sgm01,l_sgm02,
                --l_tc_imb.tc_imb06,l_tc_imb.tc_imb07,l_tc_imb.tc_imb08,l_tc_imb.tc_imb09,l_tc_imb.tc_imb10,l_tc_imb.tc_imb11
                --,l_tc_imb.tc_imb12,l_tc_imb.tc_imb13) #add tc_imb12 by guanyao160922  
      --IF STATUS THEN
         --LET g_success = 'N'
         --CALL cl_err3("ins","tc_imb_file",g_tc_ima.tc_ima01,"",STATUS,"","ins tc_imb:",1)
         --EXIT FOREACH 
      --END IF  
   --END FOREACH
  # LET l_sql = "SELECT l_tc_ima01,rownum,sgm04,sgm01,sgm02,l_sum1,l_sum2,l_sum3,l_sum6,l_sum7,l_sum4,",
  LET l_sql = "SELECT l_tc_ima01,rownum,sgm04,sgm01,sgm02,l_sum1,l_sum2,l_sum3,l_sum6,wipqty,l_sum4,",
               "       l_sum5,l_sum10 FROM cect002_tmp"
   LET l_sql1 = "INSERT INTO tc_imb_file ", l_sql CLIPPED 
   PREPARE t001_ins_1 FROM l_sql1
   EXECUTE t001_ins_1
   #end------mark by guanyao160927
       
   #insert into tc_imc_file  
   LET l_sfa08 = '' #add by guanyao161010
   LET l_sfb01 = ''
   LET l_sfa161 = ''
   LET l_tc_imb09 = ''
   LET l_tc_imb08 = ''
   LET l_tc_imb11 = ''
   INITIALIZE l_tc_imc.* TO NULL
   
   LET l_sql =" SELECT tc_imb03,tc_imb05,SUM(tc_imb09),SUM(tc_imb08),SUM(tc_imb11) FROM tc_imb_file WHERE tc_imb01='",g_tc_ima.tc_ima01,"'",
              " GROUP BY tc_imb03,tc_imb05 " 
   PREPARE tc_imb_prepapre FROM l_sql
   DECLARE tc_imb_cursor CURSOR FOR tc_imb_prepapre
   FOREACH tc_imb_cursor INTO l_sfa08,l_sfb01,l_tc_imb09,l_tc_imb08,l_tc_imb11  #add l_sfa08,l_tc_imb11 by guanyao161010
      IF STATUS THEN LET g_success = 'N' CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    
       DECLARE sfb_cursor CURSOR FOR 
          SELECT sfb05,sfa03,sfa05,sfa06+sfa062-sfa063,sfa161 FROM sfb_file LEFT JOIN sfa_file ON sfb01=sfa01
           WHERE sfb01 = l_sfb01 #AND sfa08 IN (SELECT ecd01 FROM ecd_file WHERE ecd07 = g_tc_ima.tc_ima03)  #mark by guanyao161010
             AND sfa08 = l_sfa08  #add by guanyao161010
       FOREACH sfb_cursor INTO l_tc_imc.tc_imc06,l_tc_imc.tc_imc07,l_tc_imc.tc_imc08,l_tc_imc.tc_imc09,l_sfa161
          IF STATUS THEN LET g_success = 'N' CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          #已扫出量
          LET l_tc_imc.tc_imc10 = l_tc_imb09 * l_sfa161
          IF cl_null(l_tc_imc.tc_imc10) THEN LET l_tc_imc.tc_imc10 = 0 END IF  
          #已完工量
          LET l_tc_imc.tc_imc11 = l_tc_imb08 * l_sfa161
          IF cl_null(l_tc_imc.tc_imc11) THEN LET l_tc_imc.tc_imc11 = 0 END IF 
          #已报废量
          LET l_tc_imc.tc_imc12 = l_tc_imb11*l_sfa161
          #SELECT SUM(tc_shb121) INTO l_tc_imc.tc_imc12 FROM tc_shb_file WHERE tc_shb03=l_sgm01  #mark by guanyao160930
          #SELECT SUM(tc_shb121) INTO l_tc_imc.tc_imc12 FROM tc_shb_file WHERE tc_shb04=l_sfb01   #add by guanyao160930
             #AND tc_shb08=l_sgm04 AND tc_shb01='2'
          #   AND tc_shb08 = l_sfa08 AND tc_shb01='2'
          IF cl_null(l_tc_imc.tc_imc12) THEN LET l_tc_imc.tc_imc12 = 0 END IF    
          #剩余库存量(已发-已扫出-已完工-已报废)
          LET l_tc_imc.tc_imc13=l_tc_imc.tc_imc09-l_tc_imc.tc_imc10-l_tc_imc.tc_imc11-l_tc_imc.tc_imc12 
          #项次
          SELECT MAX(tc_imc02) INTO l_seq2 FROM tc_imc_file WHERE tc_imc01=g_tc_ima.tc_ima01
          IF cl_null(l_seq2) THEN 
             LET l_seq2 = 1
           ELSE 
             LET l_seq2 = l_seq2 + 1  
          END IF   
          INSERT INTO tc_imc_file(tc_imc01,tc_imc02,tc_imc03,tc_imc05,tc_imc06,tc_imc07,
                                  tc_imc08,tc_imc09,tc_imc10,tc_imc11,tc_imc12,tc_imc13)
            VALUES(g_tc_ima.tc_ima01,l_seq2,l_sfa08,l_sfb01,l_tc_imc.tc_imc06,l_tc_imc.tc_imc07,
                   l_tc_imc.tc_imc08,l_tc_imc.tc_imc09,l_tc_imc.tc_imc10,l_tc_imc.tc_imc11,l_tc_imc.tc_imc12,l_tc_imc.tc_imc13)
          IF STATUS THEN
             LET g_success = 'N'
             CALL cl_err3("ins","tc_imc_file",g_tc_ima.tc_ima01,"",STATUS,"","ins tc_imc:",1)
             EXIT FOREACH 
          END IF                      
       END FOREACH
   END FOREACH     
    
   DECLARE img_cursor CURSOR FOR 
     SELECT img01,img10 FROM img_file WHERE img02 = 'XBC' AND img03 = g_tc_ima.tc_ima03
   FOREACH img_cursor INTO l_tc_imd.tc_imd03,l_tc_imd.tc_imd04
      IF STATUS THEN LET g_success = 'N' CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF g_success = 'N' THEN EXIT FOREACH END IF 
   
      SELECT MAX(tc_imd02) INTO l_seq3 FROM tc_imd_file WHERE tc_imd01 = g_tc_ima.tc_ima01
      IF cl_null(l_seq3) THEN 
         LET l_seq3 = 1
       ELSE 
         LET l_seq3 = l_seq3 + 1  
      END IF 
      INSERT INTO tc_imd_file(tc_imd01,tc_imd02,tc_imd03,tc_imd04)
        VALUES(g_tc_ima.tc_ima01,l_seq3,l_tc_imd.tc_imd03,l_tc_imd.tc_imd04)
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err3("ins","tc_imd_file",g_tc_ima.tc_ima01,"",STATUS,"","ins tc_imd:",1)
         EXIT FOREACH 
      END IF    
        
   END FOREACH  

   IF g_success = 'Y' THEN 
      COMMIT WORK 
    ELSE  
      ROLLBACK WORK   
   END IF  
END FUNCTION 
