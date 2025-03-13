# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt614.4gl
# Descriptions...: 支出單維護作業
# Date & Author..: NO.FUN-BB0117 11/11/23 By fanbj
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20079 12/02/14 By xumeimei 客戶簡稱從occ_file表中抓取 
# Modify.........: No:TQC-C30141 12/03/08 By shiwuying 增加退款推迟月逻辑
# Modify.........: No:TQC-C40009 12/04/05 By suncx 來源單號開窗未排除已結案的費用單資料
# Modify.........: No:FUN-C30072 12/04/17 By fanbj 來源類型為費用單時，費用類型為支出類型的處理
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.FUN-CB0076 12/11/21 By xumeimei 添加GR打印功能
# Modify.........: No:CHI-C80041 13/01/22 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20015 13/03/26 By minpp 审核人员，审核日期改为审核异动人员，审核异动日期，取消审核赋值
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_luo         RECORD     LIKE luo_file.*,
       g_luo_t       RECORD     LIKE luo_file.*,
       g_luo_o       RECORD     LIKE luo_file.*,
       g_luo01_t                LIKE luo_file.luo01,
       g_luo01                  LIKE luo_file.luo01
       

DEFINE g_lup                 DYNAMIC ARRAY OF RECORD
          lup02                 LIKE lup_file.lup02,    #项次
          lup03                 LIKE lup_file.lup03,    #来源单号
          lup04                 LIKE lup_file.lup04,    #来源项次
          lup05                 LIKE lup_file.lup05,    #费用编号
          oaj02                 LIKE oaj_file.oaj02,    #费用名称
          oaj05                 LIKE oaj_file.oaj05,    #费用类型
          amt1                  LIKE lup_file.lup06,    #剩余金额
          lup06                 LIKE lup_file.lup06,    #支出金额
          lup07                 LIKE lup_file.lup07,    #已退金额
          amt                   LIKE lup_file.lup08,    #未退金额 
          lup08                 LIKE lup_file.lup08,    #清算金额
          oaj04                 LIKE oaj_file.oaj04,    #会计科目
          aag02                 LIKE aag_file.aag02,    #科目名称
          oaj041                LIKE oaj_file.oaj041,   #会计科目二
          aag02_1               LIKE aag_file.aag02,    #科目名称
          lup09                 LIKE lup_file.lup09     #结算单号  
                             END RECORD

DEFINE g_lup_t               RECORD
          lup02                 LIKE lup_file.lup02,
          lup03                 LIKE lup_file.lup03,
          lup04                 LIKE lup_file.lup04,
          lup05                 LIKE lup_file.lup05,
          oaj02                 LIKE oaj_file.oaj02,
          oaj05                 LIKE oaj_file.oaj05,
          almt1                 LIKE lup_file.lup06,
          lup06                 LIKE lup_file.lup06,
          lup07                 LIKE lup_file.lup07,
          amt                   LIKE lup_file.lup08,
          lup08                 LIKE lup_file.lup08,
          oaj04                 LIKE oaj_file.oaj04,
          aag02                 LIKE aag_file.aag02,
          oaj041                LIKE oaj_file.oaj041,
          aag02_1               LIKE aag_file.aag02,
          lup09                 LIKE lup_file.lup09       
                             END RECORD

DEFINE g_wc                     STRING
DEFINE g_wc2                    STRING 
DEFINE g_sql                    STRING
DEFINE g_forupd_sql             STRING                    
DEFINE g_chr                    LIKE type_file.chr1
DEFINE g_before_input_done      LIKE type_file.num5
DEFINE g_cnt                    LIKE type_file.num10
DEFINE g_i                      LIKE type_file.num5      
DEFINE g_msg                    LIKE type_file.chr1000
DEFINE g_curs_index             LIKE type_file.num10
DEFINE g_row_count              LIKE type_file.num10
DEFINE g_jump                   LIKE type_file.num10
DEFINE g_no_ask                 LIKE type_file.num5
DEFINE g_confirm                LIKE type_file.chr1
DEFINE g_date                   LIKE lne_file.lnedate
DEFINE g_modu                   LIKE lne_file.lnemodu  
DEFINE l_ac                     LIKE type_file.num5
DEFINE g_rec_b                  LIKE type_file.num5
DEFINE g_kindslip               LIKE oay_file.oayslip
DEFINE g_b_flag                 LIKE type_file.chr1
DEFINE g_argv1                  LIKE luo_file.luo03
DEFINE g_argv2                  LIKE luo_file.luo04
DEFINE g_luc01                  LIKE luc_file.luc01
DEFINE g_dd                     LIKE luc_file.luc07
DEFINE g_t1                     LIKE oay_file.oayslip
#FUN-CB0076----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    luoplant  LIKE luo_file.luoplant,
    luo01     LIKE luo_file.luo01,
    luo07     LIKE luo_file.luo07,
    luo08     LIKE luo_file.luo08,
    luo05     LIKE luo_file.luo05,
    luo02     LIKE luo_file.luo02,
    luo06     LIKE luo_file.luo06,
    luocond   LIKE luo_file.luocond,
    luocont   LIKE luo_file.luocont,
    luoconu   LIKE luo_file.luoconu,
    lup02     LIKE lup_file.lup02,
    lup03     LIKE lup_file.lup03,
    lup04     LIKE lup_file.lup04,
    lup05     LIKE lup_file.lup05,
    lup06     LIKE lup_file.lup06,
    lup07     LIKE lup_file.lup07,
    lup08     LIKE lup_file.lup08,
    lup09     LIKE lup_file.lup09,
    rtz13     LIKE rtz_file.rtz13,
    occ02     LIKE occ_file.occ02,
    gen02     LIKE gen_file.gen02,
    oaj02     LIKE oaj_file.oaj02,
    oaj05     LIKE oaj_file.oaj05,
    amt       LIKE lup_file.lup06
END RECORD
#FUN-CB0076----add---end
DEFINE g_void      LIKE type_file.chr1  #CHI-C80041

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)     #支出单的来源类型
   LET g_argv2 = ARG_VAL(2)     #支出单的来源单号

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="luoplant.luo_file.luoplant,",
    "luo01.luo_file.luo01,",
    "luo07.luo_file.luo07,",
    "luo08.luo_file.luo08,",
    "luo05.luo_file.luo05,",
    "luo02.luo_file.luo02,",
    "luo06.luo_file.luo06,",
    "luocond.luo_file.luocond,",
    "luocont.luo_file.luocont,",
    "luoconu.luo_file.luoconu,",
    "lup02.lup_file.lup02,",
    "lup03.lup_file.lup03,",
    "lup04.lup_file.lup04,",
    "lup05.lup_file.lup05,",
    "lup06.lup_file.lup06,",
    "lup07.lup_file.lup07,",
    "lup08.lup_file.lup08,",
    "lup09.lup_file.lup09,",
    "rtz13.rtz_file.rtz13,",
    "occ02.occ_file.occ02,",
    "gen02.gen_file.gen02,",
    "oaj02.oaj_file.oaj02,",
    "oaj05.oaj_file.oaj05,",
    "amt.lup_file.lup06"
   LET l_table = cl_prt_temptable('artt614',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end
   LET g_forupd_sql = "SELECT * FROM luo_file WHERE luo01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t614_cl CURSOR FROM g_forupd_sql                 

   OPEN WINDOW t614_w WITH FORM "art/42f/artt614"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
 
   #g_aza.aza63 = 'N' oaj041,aag02_1不可见
   CALL cl_set_comp_visible("oaj041,aag02_1",g_aza.aza63='Y')    
 
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN 
      CALL t614_q()    
   END IF 

   CALL t614_menu()
   CLOSE WINDOW t614_w
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN

FUNCTION t614_cs()
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01,
          l_table      LIKE type_file.chr1000,
          l_where      LIKE type_file.chr100 
         
   CLEAR FORM    
   CALL g_lup.clear()

   CALL cl_set_head_visible("","YES")
   INITIALIZE g_luo.* TO NULL

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN 
      LET g_wc = " luo03 = '",g_argv1,"' AND luo04 = '",g_argv2,"'" 
      LET g_wc2 = " 1=1"
   ELSE
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON  
                           luo01,luo02,luo03,luo04,luoplant,luolegal,luo05,
                           luo06,luo07,luo08,luo09,luo10,luo11,luo12,luo13,
                           luomksg,luo15,luoconf,luoconu,luocond,luocont,luo14,
                           luouser,luogrup,luooriu,luomodu,luodate,luoorig,
                           luoacti,luocrat
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  #支出单号
                  WHEN INFIELD(luo01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo01
                     NEXT FIELD luo01                     
                   
                  #来源单号 
                  WHEN INFIELD(luo04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo04"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo04
                     NEXT FIELD luo04  
                           
                  #营运中心
                  WHEN INFIELD(luoplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luoplant"     
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luoplant
                     NEXT FIELD luoplant      
                    
                  #法人
                  WHEN INFIELD(luolegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luolegal"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luolegal
                     NEXT FIELD luolegal

                  #商户编号
                  WHEN INFIELD(luo05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo05"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo05
                     NEXT FIELD luo05

                  #摊位编号
                  WHEN INFIELD(luo06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo06"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo06
                     NEXT FIELD luo06

                  #合同编号
                  WHEN INFIELD(luo07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo07"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo07
                     NEXT FIELD luo07

                  #业务人员
                  WHEN INFIELD(luo12)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo12"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo12
                     NEXT FIELD luo12

                  #部门
                  WHEN INFIELD(luo13)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luo13"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luo13
                     NEXT FIELD luo13

                  #审核人
                  WHEN INFIELD(luoconu)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luoconu"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lna03
                     NEXT FIELD lna03

                  OTHERWISE
                  EXIT CASE
               END CASE
         END CONSTRUCT

         CONSTRUCT g_wc2 ON lup02,lup03,lup04,lup05,lup06,lup07,lup08,lup09
              FROM s_lup[1].lup02,s_lup[1].lup03,s_lup[1].lup04,s_lup[1].lup05,
                   s_lup[1].lup06,s_lup[1].lup07,s_lup[1].lup08,s_lup[1].lup09   
                       
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
 
            ON ACTION controlp
               CASE
                  #来源单号
                  WHEN INFIELD(lup03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lup03_1"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lup03
                     NEXT FIELD lup03

                  #费用编号
                  WHEN INFIELD(lup05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lup05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lup05
                     NEXT FIELD lup05
                     
                  OTHERWISE 
                     EXIT CASE
               END CASE
         END CONSTRUCT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
 
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

         ON ACTION ACCEPT
            ACCEPT DIALOG

         ON ACTION CANCEL
            LET INT_FLAG = 1
            EXIT DIALOG   
 
      END DIALOG 
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
   IF cl_null(g_wc) THEN LET g_wc=' 1=1' END IF
   IF cl_null(g_wc2) THEN LET g_wc2=' 1=1' END IF

   LET g_sql = "SELECT DISTINCT luo01"
   LET l_table = " FROM luo_file"
   LET l_where = " WHERE ",g_wc

   IF g_wc2 <> " 1=1" THEN 
      LET l_table = l_table,",lup_file"
      LET l_where = l_where," AND lup01 = luo01 AND ",g_wc2
   END IF    

   LET g_sql = g_sql,l_table,l_where," ORDER BY luo01"
   
   PREPARE t614_prepare FROM g_sql
   DECLARE t614_cs SCROLL CURSOR WITH HOLD FOR t614_prepare

   LET g_sql = "SELECT COUNT(DISTINCT luo01) ",l_table,l_where
   PREPARE t614_precount FROM g_sql
   DECLARE t614_count CURSOR FOR t614_precount
END FUNCTION

FUNCTION t614_menu()
   WHILE TRUE
     # IF g_action_choice = "exit"  THEN
     #   EXIT WHILE
     # END IF
      
      CALL t614_bp("G")

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t614_a()
            END IF 

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t614_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t614_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t614_u()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t614_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t614_out()
            END IF
         #FUN-CB0076------add----end
         #审核
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL t614_confirm()
           END IF

         #取消审核
         WHEN "undo_confirm "
            IF cl_chk_act_auth() THEN
               CALL t614_unconfirm()
            END IF

         #退款单退款    
         WHEN "credit_refund"
            IF cl_chk_act_auth() THEN 
               CALL t614_credit_refund()
            END IF 

         #退款单查询
         WHEN "qry_refund"
            IF cl_chk_act_auth() THEN
               CALL t614_qry_refund()
            END IF    
          
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                        base.TypeInfo.create(g_lup),'','')
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_luo.luo01 IS NOT NULL THEN
                  LET g_doc.column1 = "luo01"
                  LET g_doc.value1  = g_luo.luo01
                  CALL cl_doc()
               END IF  
            END IF 
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t614_v()
               IF g_luo.luoconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic(g_luo.luoconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t614_a()
   DEFINE li_result     LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM   
   CALL g_lup.clear()  
   LET g_rec_b = 0

   LET g_wc = NULL 
   LET g_wc2 = NULL 
    
   INITIALIZE g_luo.*    LIKE luo_file.*       
   INITIALIZE g_luo_t.*  LIKE luo_file.*
   INITIALIZE g_luo_o.*  LIKE luo_file.*     
   
    LET g_luo01_t = NULL
    CALL cl_opmsg('a')     
     
    WHILE TRUE
       LET g_luo.luo02 = g_today     #单据日期
       LET g_luo.luo15 = '0'         #状况码
       LET g_luo.luoconf = 'N'       #审核码
       LET g_luo.luouser = g_user    #资料所有者
       LET g_luo.luogrup = g_grup    #资料所有群
       LET g_luo.luodate = g_today   #最近更改日
       LET g_luo.luoacti = 'Y'       #有效码 
       LET g_luo.luocrat = g_today   #资料创建日
       LET g_luo.luooriu = g_user    #资料建立者
       LET g_luo.luoorig = g_grup    #资料建立部门 
       LET g_luo.luoplant = g_plant  #营运中心
       LET g_luo.luolegal = g_legal  #法人      
       LET g_luo.luomksg = 'N'       #是否签核
       LET g_luo.luo12 = g_user      #业务人员
       LET g_luo.luo13 = g_grup      #部门
 
       CALL t614_luoplant('d')
       CALL t614_gen02('d')
 
       CALL t614_i("a")
    
       IF INT_FLAG THEN  
          LET INT_FLAG = 0
          INITIALIZE g_luo.* TO NULL
          CALL g_lup.clear() 
          LET g_luo01_t = NULL  
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
       
       IF cl_null(g_luo.luo01) OR cl_null(g_luo.luoplant) THEN    
          CONTINUE WHILE
       END IF        
      
      ####自動編號#############################################################
      CALL s_auto_assign_no("art",g_luo.luo01,g_luo.luo02,'B4',"luo_file",
                            "luo01","","","") RETURNING li_result,g_luo.luo01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_luo.luo01
      ########################################################################
      LET g_success = 'Y'
      BEGIN WORK 
      
      INSERT INTO luo_file VALUES(g_luo.*)                   
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","luo_file",g_luo.luo01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK         
         CONTINUE WHILE
      END IF

      CALL g_lup.clear()
      LET g_rec_b = 0

      #带出单身 
      IF NOT cl_confirm("alm1302") THEN
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CONTINUE WHILE
         ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_luo.luo01,'I')
            CALL t614_b_fill(" 1=1")
            CALL t614_b()
         END IF
      ELSE 
         CALL t614_inslup()  #自动带出符合单头条件的单身
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno ,0)
            LET g_success = 'N'    
         END IF 

         IF g_success = 'N' THEN
            ROLLBACK WORK
            CONTINUE WHILE
         ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_luo.luo01,'I')
            CALL t614_b_fill(" 1=1")
            CALL t614_b()
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t614_i(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1, 
            l_cnt      LIKE type_file.num5, 
            l_count    LIKE type_file.num5, 
            li_result  LIKE type_file.num5 
   DEFINE   l_luo03_t  LIKE luo_file.luo03
            
   DISPLAY BY NAME g_luo.luo02,g_luo.luo15,g_luo.luoconf,g_luo.luouser,
                   g_luo.luogrup,g_luo.luodate,g_luo.luoacti,g_luo.luocrat,
                   g_luo.luooriu,g_luo.luoorig       
              
   INPUT BY NAME g_luo.luo01,g_luo.luo02,g_luo.luo03,g_luo.luo04,g_luo.luoplant,
                 g_luo.luolegal,g_luo.luo05,g_luo.luo06,g_luo.luo07,g_luo.luo08,
                 g_luo.luo09,g_luo.luo10,g_luo.luo11,g_luo.luo12,g_luo.luo13,
                 g_luo.luomksg,g_luo.luo15,g_luo.luoconf,g_luo.luoconu,
                 g_luo.luocond,g_luo.luocont,g_luo.luo14,g_luo.luouser,
                 g_luo.luogrup,g_luo.luooriu,g_luo.luomodu,g_luo.luodate,
                 g_luo.luoorig,g_luo.luoacti,g_luo.luocrat
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE  
         CALL t614_set_entry(p_cmd)        
         CALL t614_set_no_entry(p_cmd)  
         CALL t614_set_entry_luo04(p_cmd)
         CALL t614_set_entry_luo07(p_cmd)
         LET g_before_input_done = TRUE
          
      #支出单号  
      AFTER FIELD luo01 
         IF NOT cl_null(g_luo.luo01) THEN
            IF (p_cmd = 'a') OR 
               (p_cmd = 'u' AND g_luo.luo01 != g_luo_t.luo01) THEN 
            CALL s_check_no("art",g_luo.luo01,g_luo01_t,'B4',"luo_file",
                            "luo01","") RETURNING li_result,g_luo.luo01
            IF (NOT li_result) THEN
               LET g_luo.luo01=g_luo_t.luo01
               NEXT FIELD luo01
            END IF
            END IF 
         END IF   

      #来源类型，如果单身有数据，不允许修改来源类型 
      ON CHANGE luo03
         IF NOT cl_null(g_luo.luo03) THEN 
            IF g_rec_b > 0 THEN
               CALL cl_err('','alm1339',0)
               LET g_luo.luo03 = l_luo03_t
               NEXT FIELD luo03
            ELSE
               IF l_luo03_t <> g_luo.luo03 THEN
                  LET g_luo.luo04 = NULL
                  LET g_luo.luo05 = NULL
                  LET g_luo.luo06 = NULL
                  LET g_luo.luo07 = NULL
                  LET g_luo.luo08 = NULL
                  DISPLAY BY NAME g_luo.luo05,g_luo.luo06,g_luo.luo07,
                                  g_luo.luo08,g_luo.luo04
                  DISPLAY '','','' TO luo05_desc,lnt30,tqa02
               END IF
            END IF
         END IF
         CALL t614_set_entry_luo04(p_cmd)
         CALL t614_set_entry_luo07(p_cmd)

      BEFORE FIELD luo03
         LET l_luo03_t = g_luo.luo03
 
      #如果来源类型为空，不允许进入来源单号栏位
      BEFORE FIELD luo04,luo05,luo06,luo07
         IF cl_null(g_luo.luo03) THEN 
            CALL cl_err('','alm1359',0)
            NEXT FIELD luo03
         END IF 

      #如果单身有数据，不允许修改来源单号
      AFTER FIELD luo04
         IF NOT cl_null(g_luo.luo04) THEN
            CALL t614_luo04(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno ,0)
               LET g_luo.luo04 = g_luo_t.luo04
               DISPLAY BY NAME g_luo.luo04  
               NEXT FIELD luo04
            END IF 
            CALL cl_set_comp_entry("luo05,luo06,luo07",TRUE) 
         END IF 
         CALL t614_set_entry_luo04(p_cmd)
         CALL t614_set_entry_luo07(p_cmd)

      AFTER FIELD luo05
         IF NOT cl_null(g_luo.luo05) THEN 
            IF cl_null(g_luo.luo04) THEN 
               CALL t614_luo05(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_luo.luo05 = g_luo_t.luo05 
                  NEXT FIELD luo05 
                  DISPLAY BY NAME g_luo.luo05 
               END IF 
            END IF 
         END IF 

      AFTER FIELD luo06 
         IF NOT cl_null(g_luo.luo06) THEN
            IF cl_null(g_luo.luo04) THEN 
               CALL t614_luo06(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_luo.luo06 = g_luo_t.luo06
                  NEXT FIELD luo06 
                  DISPLAY BY NAME g_luo.luo06 
               END IF 
            END IF 
         END IF

      AFTER FIELD luo07
         IF NOT cl_null(g_luo.luo07) THEN 
            IF cl_null(g_luo.luo04) THEN
               CALL t614_luo07(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0) 
                  LET g_luo.luo07 = g_luo_t.luo07
                  NEXT FIELD luo07 
                  DISPLAY BY NAME g_luo.luo07 
               END IF 
            END IF 
         END IF
         CALL t614_set_entry_luo07(p_cmd)
       
      AFTER FIELD luo12
         IF NOT cl_null(g_luo.luo12) THEN 
            CALL t614_gen02(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_luo.luo12 = g_luo_t.luo12
               NEXT FIELD luo12
               DISPLAY BY NAME g_luo.luo12
            END IF 
         END IF            
 
      AFTER FIELD luo13 
         IF NOT cl_null(g_luo.luo13) THEN
            CALL t614_gem02(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_luo.luo07 = g_luo_t.luo07
               NEXT FIELD luo07
            END IF 
         END IF     
 
      AFTER INPUT
         LET g_luo.luouser = s_get_data_owner("luo_file") #FUN-C10039
         LET g_luo.luogrup = s_get_data_group("luo_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF 
         
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(luo01)
               LET g_kindslip = s_get_doc_no(g_luo.luo01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'B4','ART') RETURNING g_kindslip
               LET g_luo.luo01 = g_kindslip
               DISPLAY BY NAME g_luo.luo01
               NEXT FIELD luo01
          
            #g_luo.luo03 = '1'，来源类型为待抵单，
            #g_luo.luo03 = '2',来源类型为费用单   
            WHEN INFIELD(luo04)
               CALL cl_init_qry_var()
               IF g_luo.luo03 = '1' THEN  
                  LET g_qryparam.form = "q_luo04_1"  
               END IF 
               IF g_luo.luo03 = '2' THEN
                  LET g_qryparam.form = "q_luo04_2"
                  LET g_qryparam.where = " lua14 <> '2' "  #TQC-C40009
               END IF 
               LET g_qryparam.default1 = g_luo.luo04
               CALL cl_create_qry() RETURNING g_luo.luo04
               DISPLAY BY NAME g_luo.luo04
               NEXT FIELD luo04
         
            #商户编号，检查有效的商户   
            WHEN INFIELD(luo05)
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_luo05_1"    #FUN-C20079 mark
               LET g_qryparam.form = "q_occ"         #FUN-C20079 add
               LET g_qryparam.default1 = g_luo.luo05
               CALL cl_create_qry() RETURNING g_luo.luo05
               DISPLAY BY NAME g_luo.luo05
               NEXT FIELD luo05 
        
            #摊位编号，检查已审核的摊位
            WHEN INFIELD(luo06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_luo06_1"  
               LET g_qryparam.where = " lmfstore IN ",g_auth
               LET g_qryparam.default1 = g_luo.luo06
               CALL cl_create_qry() RETURNING g_luo.luo06
               DISPLAY BY NAME g_luo.luo06
               NEXT FIELD luo06 

            #合同编号，终审通过OR终止OR到期
            WHEN INFIELD(luo07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_luo07_1"  
               LET g_qryparam.default1 = g_luo.luo07
               CALL cl_create_qry() RETURNING g_luo.luo07
               DISPLAY BY NAME g_luo.luo07
               NEXT FIELD luo07   

            #业务人员
            WHEN INFIELD(luo12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen02"  
               LET g_qryparam.default1 = g_luo.luo12
               CALL cl_create_qry() RETURNING g_luo.luo12
               DISPLAY BY NAME g_luo.luo12
               NEXT FIELD luo12   

            #部门
            WHEN INFIELD(luo13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"  
               LET g_qryparam.default1 = g_luo.luo13
               CALL cl_create_qry() RETURNING g_luo.luo13
               DISPLAY BY NAME g_luo.luo13
               NEXT FIELD luo13   
            OTHERWISE
               EXIT CASE
         END CASE
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF  
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about() 
 
      ON ACTION HELP 
         CALL cl_show_help()
   END INPUT
END FUNCTION
 
FUNCTION t614_q()
   LET  g_row_count = 0
   LET  g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
    
   INITIALIZE g_luo.* TO NULL
   INITIALIZE g_luo_t.* TO NULL
   INITIALIZE g_luo_o.* TO NULL
    
   LET g_luo01_t = NULL
   LET g_wc = NULL
    
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '' TO FORMONLY.cnt
    
   CALL t614_cs()  
          
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_luo.* TO NULL
      LET g_rec_b = 0 
      CALL g_lup.clear()      
      LET g_luo01_t = NULL
      LET g_wc = NULL
      LET g_wc2 = NULL 
      RETURN
   END IF
    
   OPEN t614_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_luo.* TO NULL
      LET g_wc = NULL
      LET g_luo01_t = NULL
   ELSE
      OPEN t614_count
      FETCH t614_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t614_fetch('F')
   END IF
END FUNCTION
 
FUNCTION t614_fetch(p_flag)
   DEFINE p_flag LIKE type_file.chr1 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t614_cs INTO g_luo.luo01
      WHEN 'P' FETCH PREVIOUS t614_cs INTO g_luo.luo01
      WHEN 'F' FETCH FIRST    t614_cs INTO g_luo.luo01
      WHEN 'L' FETCH LAST     t614_cs INTO g_luo.luo01
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
            FETCH ABSOLUTE g_jump t614_cs INTO g_luo.luo01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
       INITIALIZE g_luo.* TO NULL
       LET g_luo01_t = NULL
       RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_luo.* FROM luo_file  
     WHERE luo01 = g_luo.luo01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_luo.luouser 
       LET g_data_group = g_luo.luogrup
       CALL t614_show() 
    END IF
END FUNCTION
 
FUNCTION t614_show()
    DEFINE l_gen02     LIKE gen_file.gen02,
           l_lnt30     LIKE lnt_file.lnt30,
           l_tqa02     LIKE tqa_file.tqa02

    LET g_luo_t.* = g_luo.*
    LET g_luo_o.* = g_luo.*
    DISPLAY BY NAME g_luo.luo01,g_luo.luo02,g_luo.luo03,g_luo.luo04,
                    g_luo.luoplant,g_luo.luolegal,g_luo.luo05,g_luo.luo06,
                    g_luo.luo07,g_luo.luo08,g_luo.luo09,g_luo.luo10,
                    g_luo.luo11,g_luo.luo12,g_luo.luo13,g_luo.luomksg,
                    g_luo.luo15,g_luo.luoconf,g_luo.luoconu,g_luo.luocond,
                    g_luo.luocont,g_luo.luo14,g_luo.luouser,g_luo.luogrup,
                    g_luo.luooriu,g_luo.luomodu,g_luo.luodate,g_luo.luoorig,
                    g_luo.luoacti,g_luo.luocrat

    #带出审核人名称
    SELECT gen02 INTO l_gen02
      FROM gen_file
     WHERE gen01 = g_luo.luoconu
    DISPLAY l_gen02 TO FORMONLY.gen02_1

    #带出主品牌
    IF NOT cl_null(g_luo.luo07) THEN
       SELECT lnt30 INTO l_lnt30
         FROM lnt_file
        WHERE lnt01 = g_luo.luo07
    ELSE
       SELECT lne08 INTO l_lnt30
         FROM lne_file
        WHERE lne01 = g_luo.luo05
    END IF

    #带出主品牌名称 
    SELECT tqa02 INTO l_tqa02
      FROM tqa_file
     WHERE tqa01 = l_lnt30
       AND tqa03 = '2'

    DISPLAY l_lnt30 TO FORMONLY.lnt30
    DISPLAY l_tqa02 TO FORMONLY.tqa02

    CALL cl_show_fld_cont()
    CALL t614_b_fill(g_wc2)
    CALL t614_luoplant('d')  #带出营运中心及法人名称
    CALL t614_gen02('d')     #带出业务人员名称
    CALL t614_gem02('d')     #业务人员所属部门
    CALL t614_upd()          #单身金额汇总
    #CALL cl_set_field_pic(g_luo.luoconf,"","","","","")  #CHI-C80041
    IF g_luo.luoconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_luo.luoconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION

FUNCTION t614_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lup TO s_lup.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

   BEFORE DISPLAY
      CALL cl_navigator_setting( g_curs_index, g_row_count )

   BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()

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
   #FUN-CB0076------add-----str
   ON ACTION OUTPUT
      LET g_action_choice="output"
      EXIT DISPLAY
   #FUN-CB0076------add-----end
   #审核
   ON ACTION confirm
      LET g_action_choice="confirm"
      EXIT DISPLAY

   #取消审核
   ON ACTION undo_confirm
      LET g_action_choice="undo_confirm"
      EXIT DISPLAY
   #CHI-C80041---begin
   ON ACTION void
      LET g_action_choice="void"
      EXIT DISPLAY
   #CHI-C80041---end 
   #退款单退款
   ON ACTION credit_refund
      LET g_action_choice="credit_refund"
      EXIT DISPLAY 

   #退款单查询   
   ON ACTION qry_refund
      LET g_action_choice="qry_refund"
      EXIT DISPLAY   

   ON ACTION first
      CALL t614_fetch('F')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION previous
      CALL t614_fetch('P')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION jump
      CALL t614_fetch('/')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION next
      CALL t614_fetch('N')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION last
      CALL t614_fetch('L')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION detail
      LET g_action_choice="detail"
      LET l_ac=1
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

   ON ACTION close
      LET INT_FLAG=FALSE
      LET g_action_choice="exit"
      EXIT DISPLAY 
         
   AFTER DISPLAY
      CONTINUE DISPLAY

   ON ACTION controls
      CALL cl_set_head_visible("","AUTO")

   ON ACTION related_document
      LET g_action_choice="related_document"
      EXIT DISPLAY   

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION t614_u()
   IF cl_null(g_luo.luo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
    
   SELECT * INTO g_luo.* 
     FROM luo_file 
    WHERE luo01  = g_luo.luo01
  
   IF g_luo.luoconf = 'Y' THEN
      CALL cl_err(g_luo.luo01,'alm-027',0)
      RETURN
   END IF    
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_luo01_t = g_luo.luo01
    
   BEGIN WORK
 
   OPEN t614_cl USING g_luo.luo01
   IF STATUS THEN
      CALL cl_err("OPEN t614_cl:",STATUS,1)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   FETCH t614_cl INTO g_luo.*  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luo.luo01,SQLCA.sqlcode,1)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   ###############
   LET g_date = g_luo.luodate
   LET g_modu = g_luo.luomodu
   ############### 
   
   LET g_luo.luomodu = g_user  
   LET g_luo.luodate = g_today  
  
   CALL t614_show()    
    
   WHILE TRUE
      CALL t614_i('u')  
        
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         ###############
         LET g_luo_t.luodate = g_date
         LET g_luo_t.luomodu = g_modu
         ###############
         LET g_luo.*=g_luo_t.*
         CALL t614_show()
         CALL cl_err('',9001,0)        
         EXIT WHILE
      END IF
      
      IF g_luo.luo01 != g_luo01_t THEN
         UPDATE lup_file
            SET lup01 = g_luo.luo01
          WHERE lup01 = g_luo01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lup_file",g_luo01_t,
                  "",SQLCA.sqlcode,"","lup",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE luo_file 
         SET luo_file.* = g_luo.* 
       WHERE luo01 = g_luo01_t
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t614_cl
   COMMIT WORK

   SELECT * INTO g_luo.*
    FROM luo_file
   WHERE luo01=g_luo.luo01
    
   CALL t614_show()
   CALL cl_flow_notify(g_luo.luo01,'U')
   CALL t614_b_fill("1=1")
   CALL t614_bp_refresh()
END FUNCTION
 
FUNCTION t614_r()
   IF cl_null(g_luo.luo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_luo.luoconf = 'Y' THEN 
      CALL cl_err(g_luo.luo01,'alm-028',0)
      RETURN
   END IF
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   LET g_success='Y'
       
   BEGIN WORK
 
   OPEN t614_cl USING g_luo.luo01
   IF STATUS THEN
      CALL cl_err("OPEN t614_cl:",STATUS,0)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t614_cl INTO g_luo.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   CALL t614_show()
    
   IF cl_delh(0,0) THEN                 
      INITIALIZE g_doc.* TO NULL         
      LET g_doc.column1 = "luo01"         
      LET g_doc.value1 = g_luo.luo01      
      CALL cl_del_doc()                                         
        
      DELETE FROM luo_file 
       WHERE luo01 = g_luo_t.luo01

      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","luo_file",g_luo.luo01,"",SQLCA.SQLCODE,
                       "","(t614_r:delete luo)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM lup_file
       WHERE lup01 =g_luo_t.luo01

      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lup_file",g_luo.luo01,"",
                      SQLCA.SQLCODE,"","(t614_r:delete lup)",1)
         LET g_success='N'
      END IF

      INITIALIZE g_luo.* TO NULL

      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM

         CALL g_lup.clear()
         OPEN t614_count
         IF STATUS THEN
            CLOSE t614_cs
            CLOSE t614_count
            COMMIT WORK
            RETURN
         END IF

         FETCH t614_count INTO g_row_count

         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t614_cs
            CLOSE t614_count
            COMMIT WORK
            RETURN
         END IF

         DISPLAY g_row_count TO FORMONLY.cnt

         OPEN t614_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t614_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t614_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_luo.* = g_luo_t.*
      END IF
   END IF

   CLOSE t614_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t614_set_entry(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("luo01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t614_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("luo01",FALSE)        
   END IF           
END FUNCTION  
 
FUNCTION t614_set_entry_luo04(p_cmd)
  DEFINE   p_cmd     LIKE type_file.chr1

   IF NOT cl_null(g_luo.luo04) THEN
      CALL cl_set_comp_entry("luo05,luo06,luo07",FALSE)
   ELSE
      CALL cl_set_comp_entry("luo05,luo06,luo07",TRUE)
   END IF
END FUNCTION

FUNCTION t614_set_entry_luo07(p_cmd)
  DEFINE   p_cmd     LIKE type_file.chr1

   IF cl_null(g_luo.luo04) THEN
      IF NOT cl_null(g_luo.luo07) THEN
         CALL cl_set_comp_entry("luo05,luo06",FALSE)
      ELSE
         CALL cl_set_comp_entry("luo05,luo06",TRUE)
      END IF
   END IF
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("luo05,luo06,luo07",FALSE) 
   END IF
END FUNCTION

#审核
FUNCTION t614_confirm()
   DEFINE l_luoconu      LIKE luo_file.luoconu,
          l_luocond      LIKE luo_file.luocond,
          l_n            LIKE type_file.num5,
          l_luocont      LIKE luo_file.luocont,
          l_luo15        LIKE luo_file.luo15,
          l_cnt          LIKE type_file.num5,
          l_lul06        LIKE lul_file.lul06,
          l_lul07        LIKE lul_file.lul07,
          l_lul08        LIKE lul_file.lul08,
          l_amt          LIKE lup_file.lup06,
          l_lup03        LIKE lup_file.lup03,
          l_lup04        LIKE lup_file.lup04,
          l_gen02        LIKE gen_file.gen02,      
          l_sql          STRING 
   DEFINE l_lub09        LIKE lub_file.lub09     #FUN-C30072 add
          
   IF cl_null(g_luo.luo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 -------- add --------- begin
   IF g_luo.luoconf = 'Y' THEN
      CALL cl_err(g_luo.luo01,'alm-005',1)
      RETURN
   END IF
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
#CHI-C30107 -------- add --------- end
   
   SELECT * INTO g_luo.* 
     FROM luo_file
    WHERE luo01 = g_luo.luo01

   IF g_luo.luoconf = 'Y' THEN
      CALL cl_err(g_luo.luo01,'alm-005',1)
      RETURN
   END IF
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   

   LET l_luoconu = g_luo.luoconu
   LET l_luocond = g_luo.luocond
   LET l_luocont = g_luo.luocont
   LET l_luo15   = g_luo.luo15


   LET l_sql = "SELECT lup03,lup04 ",
               "  FROM lup_file" ,
               " WHERE lup01 = '",g_luo.luo01,"'"
               
   DECLARE t614_chk_cs CURSOR FROM l_sql 

   LET l_cnt = 1
   
   #foreach逐笔判断单身的剩余金额是否有变化，有不允许审核
   FOREACH t614_chk_cs INTO l_lup03,l_lup04
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF    
      CASE g_luo.luo03
         WHEN '1'
            SELECT lul06,lul07,lul08
              INTO l_lul06,l_lul07,l_lul08
              FROM lul_file
             WHERE lul01 = l_lup03
               AND lul02 = l_lup04
            LET l_amt = l_lul06 - l_lul07 - l_lul08
         WHEN '2' 
            #FUN-C30072--start mark-----------------
            #SELECT lub04t,lub11,lub12
            #  INTO l_lul06,l_lul07,l_lul08
            #  FROM lub_file
            # WHERE lub01 = l_lup03
            #   AND lub02 = l_lup04  
            #LET l_amt = l_lul07 + l_lul08 - l_lul06
            #FUN-C30072--end mark-------------------
            #FUN-C30072--start add------------------
            SELECT lub04t,lub11,lub12,lub09
              INTO l_lul06,l_lul07,l_lul08,l_lub09
              FROM lub_file
             WHERE lub01 = l_lup03
               AND lub02 = l_lup04
             
            IF l_lub09 = '10' THEN
               LET l_amt = l_lul06-l_lul07-l_lul08
            ELSE 
               LET l_amt = l_lul07 + l_lul08 - l_lul06
            END IF  
            #FUN-C30072--end add--------------------
      END CASE         

      IF l_amt <> g_lup[l_cnt ].amt1 THEN 
         CALL cl_err('','alm1234',0)
         RETURN 
      END IF 

      LET l_cnt = l_cnt + 1
   END FOREACH 
   
   BEGIN WORK 
   OPEN t614_cl USING g_luo.luo01
   IF STATUS THEN 
      CALL cl_err("open t614_cl:",STATUS,1)
      CLOSE t614_cl
      ROLLBACK WORK 
      RETURN 
   END IF 
    
   FETCH t614_cl INTO g_luo.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN 
   END IF    
  

#CHI-C30107 ------------- mark -------------  begin
#  IF NOT cl_confirm("alm-006") THEN
#      RETURN
#  ELSE
#CHI-C30107 ------------- mark ------------- end
      LET g_luo.luoconf = 'Y'
      LET g_luo.luoconu = g_user
      LET g_luo.luocond = g_today
      LET g_luo.luocont = TIME 
      LET g_luo.luo15 = '1'
      UPDATE luo_file
         SET luoconf = g_luo.luoconf,
             luoconu = g_luo.luoconu,
             luocond = g_luo.luocond,
             luocont = g_luo.luocont,
             luo15   = g_luo.luo15 
        WHERE luo01= g_luo.luo01
       
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd luo:',SQLCA.SQLCODE,0)
         LET g_luo.luoconf = "N"
         LET g_luo.luoconu = l_luoconu
         LET g_luo.luocond = l_luocond
         LET g_luo.luocont = l_luocont
         LET g_luo.luo15   = l_luo15 
         DISPLAY BY NAME g_luo.luoconf,g_luo.luoconu,g_luo.luocond,
                         g_luo.luocont,g_luo.luo15
         RETURN
      ELSE
         SELECT gen02 INTO l_gen02
           FROM gen_file
          WHERE gen01 = g_luo.luoconu
         DISPLAY l_gen02 TO FORMONLY.gen02_1
         DISPLAY BY NAME g_luo.luoconf,g_luo.luoconu,g_luo.luocond,
                         g_luo.luocont,g_luo.luo15
         CALL cl_set_field_pic(g_luo.luoconf,"","","","","")                
      END IF
#  END IF   #CHI-C30107 mark
   CLOSE t614_cl
   COMMIT WORK      
END FUNCTION
 
#取消审核
FUNCTION t614_unconfirm()
   DEFINE l_n             LIKE type_file.num5,
          l_luoconf       LIKE luo_file.luoconf,
          l_luoconu       LIKE luo_file.luoconu,
          l_luocond       LIKE luo_file.luocond,
          l_luocont       LIKE luo_file.luocont,
          l_luo15         LIKE luo_file.luo15,
          l_gen02         LIKE gen_file.gen02
          
   IF cl_null(g_luo.luo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #取消审核时判断支出单是否存在于退款单中，
   #如果是，不允许取消审核
   SELECT count(*) INTO l_n 
     FROM luc_file
    WHERE luc11 = g_luo.luo01

   IF l_n > 0 THEN 
      CALL cl_err('','alm1233',0)
      RETURN 
   END IF  
 
   SELECT * INTO g_luo.* 
     FROM luo_file
    WHERE luo01 = g_luo.luo01
  
   LET l_luoconu = g_luo.luoconu
   LET l_luocond = g_luo.luocond 
   LET l_luocont = g_luo.luocont 
   LET l_luo15   = g_luo.luo15
   
   IF g_luo.luoconf = 'N' THEN
      CALL cl_err(g_luo.luo01,'alm-007',1)
      RETURN
   END IF
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t614_cl USING g_luo.luo01
    
   IF STATUS THEN 
      CALL cl_err("open t614_cl:",STATUS,1)
      CLOSE t614_cl
      ROLLBACK WORK 
      RETURN 
   END IF
   
   FETCH t614_cl INTO g_luo.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN 
   END IF    
    
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
      LET g_luo.luoconf = 'N'
     #LET g_luo.luoconu = NULL    #CHI-D20015
     #LET g_luo.luocond = NULL    #CHI-D20015
     #LET g_luo.luocont = NULL    #CHI-D20015
      LET g_luo.luoconu = g_user  #CHI-D20015
      LET g_luo.luocond = g_today #CHI-D20015
      LET g_luo.luocont = TIME    #CHI-D20015
      LET g_luo.luo15 = '0' 
      LET g_luo.luomodu = g_user
      LET g_luo.luodate = g_today
       
      UPDATE luo_file
         SET luoconf = g_luo.luoconf,
             luoconu = g_luo.luoconu,
             luocond = g_luo.luocond,
             luocont = g_luo.luocont,
             luo15   = g_luo.luo15,
             luomodu = g_luo.luomodu,
             luodate = g_luo.luodate
       WHERE luo01 = g_luo.luo01
       
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd luo:',SQLCA.SQLCODE,0)
         LET g_luo.luoconf = "Y"
         LET g_luo.luoconu = l_luoconu
         LET g_luo.luocond = l_luocond
         LET g_luo.luocont = l_luocont
         DISPLAY BY NAME g_luo.luoconf,g_luo.luoconu,g_luo.luocond,
                         g_luo.luocont,g_luo.luo15
         RETURN
      ELSE
         #DISPLAY '' TO FORMONLY.gen02_1      #CHI-D20015
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_luo.luoconu  #CHI-D20015
         DISPLAY l_gen02 TO FORMONLY.gen02_1      #CHI-D20015
         DISPLAY BY NAME g_luo.luoconf,g_luo.luoconu,g_luo.luocond,g_luo.luocont,
                         g_luo.luo15,g_luo.luomodu,g_luo.luodate
         CALL cl_set_field_pic(g_luo.luoconf,"","","","","")                
      END IF
   END IF 
   CLOSE t614_cl
   IF g_success = 'Y' THEN 
      COMMIT WORK  
   END IF    
END FUNCTION
 
FUNCTION t614_b()
   DEFINE
      l_n             LIKE type_file.num5,
      l_n1            LIKE type_file.num5,
      l_i1            LIKE type_file.num5,
      l_lock_sw       LIKE type_file.chr1,
      p_cmd           LIKE type_file.chr1,
      l_allow_insert  LIKE type_file.num5,
      l_allow_delete  LIKE type_file.num5,
      l_lup02         LIKE lup_file.lup02,
      l_ac_t          LIKE type_file.num5   #FUN-D30033 add

   LET g_action_choice = ""
   MESSAGE ''

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_luo.luo01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_luo.*
     FROM luo_file
    WHERE luo01=g_luo.luo01

   IF g_luo.luoconf = 'Y' THEN
      CALL cl_err(g_luo.luo01,'alm-027',1)
     RETURN
   END IF
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lup02,lup03,lup04,lup05,'','','',lup06,lup07,",
                      "       '',lup08,'','','','',lup09",        
                      "  FROM lup_file",
                      " WHERE lup01='",g_luo.luo01,"'",
                      "   AND lup02=? ",
                      "  FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t614_bcl CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_lup WITHOUT DEFAULTS FROM s_lup.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)

      BEFORE INPUT
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
            LET l_ac = 1 
         END IF

      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()

         BEGIN WORK
         LET g_success = 'Y'

         OPEN t614_cl USING g_luo.luo01
         IF STATUS THEN
            CALL cl_err("OPEN t614_cl:", STATUS, 1)
            CLOSE t614_cl
            ROLLBACK WORK
            RETURN
         END IF

         FETCH t614_cl INTO g_luo.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
            CLOSE t614_cl
            ROLLBACK WORK
            RETURN
         END IF

         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_lup_t.* = g_lup[l_ac].*

            OPEN t614_bcl USING g_lup_t.lup02
            IF STATUS THEN
               CALL cl_err("OPEN t614_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t614_bcl INTO g_lup[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_lup_t.lup02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
            CALL t614_dis_oaj(g_lup[l_ac].lup05,'2')
            CALL t614_desc(g_lup[l_ac].lup03,g_lup[l_ac].lup04,'2')
         END IF

   BEFORE INSERT
      DISPLAY "BEFORE INSERT!"
      LET l_n = ARR_COUNT()
      LET p_cmd='a'
      INITIALIZE g_lup[l_ac].* TO NULL
      LET g_lup_t.* = g_lup[l_ac].*
      IF NOT cl_null(g_luo.luo04) THEN
         LET g_lup[l_ac].lup03 = g_luo.luo04   
      END IF 
      CALL cl_show_fld_cont()
      NEXT FIELD lup02

   AFTER INSERT
      DISPLAY "AFTER INSERT!"
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         CANCEL INSERT
      END IF
      
      INSERT INTO lup_file(lup01,lup02,lup03,lup04,lup05,lup06,lup07,lup08,
                           lup09,lupplant,luplegal)
           VALUES(g_luo.luo01,g_lup[l_ac].lup02,g_lup[l_ac].lup03,
                  g_lup[l_ac].lup04,g_lup[l_ac].lup05,g_lup[l_ac].lup06,
                  g_lup[l_ac].lup07,g_lup[l_ac].lup08,g_lup[l_ac].lup09,
                  g_luo.luoplant,g_luo.luolegal)

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lup_file",g_luo.luo01,
                      g_lup[l_ac].lup02,SQLCA.sqlcode,"","",1)
         CANCEL INSERT
      ELSE
         MESSAGE 'INSERT O.K'
         COMMIT WORK
         LET g_success = 'Y'
         LET g_rec_b=g_rec_b+1
         DISPLAY g_rec_b TO FORMONLY.cn2
      END IF

   BEFORE FIELD lup02
      IF p_cmd = 'a' THEN 
         SELECT MAX(lup02) INTO l_lup02
           FROM lup_file
          WHERE lup01 = g_luo.luo01
        
         IF cl_null(l_lup02) THEN 
            LET l_lup02 = 1
         ELSE 
            LET l_lup02 = l_lup02 +1
         END IF
         LET g_lup[l_ac].lup02 = l_lup02 
      END IF 

   #项次不能小于等于0，新增或者修改的时候检查是否重复     
   AFTER FIELD lup02
      IF NOT cl_null(g_lup[l_ac].lup02) THEN
         IF g_lup[l_ac].lup02 <= 0 THEN
            CALL cl_err('','alm1127',0)
            LET g_lup[l_ac].lup02 = g_lup_t.lup02 
            NEXT FIELD lup02 
         END IF 
   
         IF (p_cmd = 'a') OR 
            (p_cmd = 'u' AND g_lup[l_ac].lup02 <> g_lup_t.lup02 ) THEN    
            SELECT COUNT(*) INTO l_n
              FROM lup_file
             WHERE lup01 = g_luo.luo01
               AND lup02 = g_lup[l_ac].lup02

            IF l_n > 0 THEN
                CALL cl_err('','alm1358',0)
               LET g_lup[l_ac].lup02 = g_lup_t.lup02
               NEXT FIELD lup02
            END IF   
         END IF 
      END IF

   #单身检查来源单号和来源项次不允许重复，同时检查来源单号和项次的有效性 
   AFTER FIELD lup03
      IF NOT cl_null(g_lup[l_ac].lup03) THEN
         IF cl_null(g_lup[l_ac].lup04) THEN  
            CALL t614_lup03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lup[l_ac].lup03 = g_lup_t.lup03
               NEXT FIELD lup03
            END IF 
         ELSE 
            CALL t614_lup04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lup[l_ac].lup03 = g_lup_t.lup03
               NEXT FIELD lup03 
            END IF
            #FUN-C30072--start add------------------
            CALL t614_chk_lup05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lup[l_ac].lup03 = g_lup_t.lup03
               LET g_lup[l_ac].lup06 = NULL
               NEXT FIELD lup03
            END IF
            #FUN-C30072--end add--------------------

           #TQC-C30141 Begin---
            IF NOT t614_chk_llb02('1',g_luo.luo03,g_lup[l_ac].lup03,g_lup[l_ac].lup05) THEN
               LET g_lup[l_ac].lup03 = g_lup_t.lup03
               NEXT FIELD lup03
            END IF
           #TQC-C30141 End-----
            
         END IF  
      END IF
   
   AFTER FIELD lup04
      IF NOT cl_null(g_lup[l_ac].lup04) AND NOT cl_null(g_lup[l_ac].lup03 )THEN
         IF g_lup[l_ac].lup04 <= 0 THEN
            CALL cl_err('','alm1352',0)
            LET g_lup[l_ac].lup04 = g_lup_t.lup04
            NEXT FIELD lup04
         END IF 
 
         CALL t614_lup04(p_cmd)
         IF NOT cl_null(g_errno) THEN 
            CALL cl_err('',g_errno,0)
            LET g_lup[l_ac].lup04 = g_lup_t.lup04 
            NEXT FIELD lup04
            DISPLAY BY NAME g_lup[l_ac].lup04
         END IF
         #FUN-C30072--start add------------------
         CALL t614_chk_lup05(p_cmd)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            LET g_lup[l_ac].lup04 = g_lup_t.lup04
            LET g_lup[l_ac].lup06 = null
            NEXT FIELD lup04
         END IF
         #FUN-C30072--end add--------------------
         
        #TQC-C30141 Begin---
         IF NOT t614_chk_llb02('1',g_luo.luo03,g_lup[l_ac].lup03,g_lup[l_ac].lup05) THEN
            LET g_lup[l_ac].lup04 = g_lup_t.lup04
            NEXT FIELD lup04
         END IF
        #TQC-C30141 End-----

      END IF

   BEFORE FIELD lup06
      LET g_lup_t.lup06 = g_lup[l_ac].lup06

   #大于0，不可大于剩余金额，且小于等于剩余金额减去该费用单对应的
   #所有交款金额和所有的支出金额
   AFTER FIELD lup06
      IF NOT cl_null(g_lup[l_ac].lup06) THEN
         IF g_lup[l_ac].lup06 <= 0 THEN
            CALL cl_err('','alm1235',0)
            LET g_lup[l_ac].lup06 = g_lup_t.lup06
            NEXT FIELD lup06   
         ELSE   
            CALL t614_lup06(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lup[l_ac].lup06 = g_lup_t.lup06
               NEXT FIELD lup06 
            END IF 
         END IF    
      END IF
   
   BEFORE DELETE
      IF g_lup_t.lup02 IS NOT NULL THEN 
      IF NOT cl_delb(0,0) THEN
         CANCEL DELETE
      END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF

         DELETE FROM lup_file
               WHERE lup01 = g_luo.luo01
                 AND lup02 = g_lup_t.lup02

         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","luo_file",g_luo.luo01,
                          g_lup_t.lup02,SQLCA.sqlcode,"","",1)
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
         LET g_lup[l_ac].* = g_lup_t.*
         CLOSE t614_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      
      IF l_lock_sw = 'Y' THEN
         CALL cl_err(g_lup[l_ac].lup02,-263,1)
         LET g_lup[l_ac].* = g_lup_t.*
      ELSE
         UPDATE lup_file
            SET lup02 = g_lup[l_ac].lup02,
                lup03 = g_lup[l_ac].lup03,
                lup04 = g_lup[l_ac].lup04,
                lup05 = g_lup[l_ac].lup05,
                lup06 = g_lup[l_ac].lup06,
                lup07 = g_lup[l_ac].lup07,
                lup08 = g_lup[l_ac].lup08,
                lup09 = g_lup[l_ac].lup09 
          WHERE lup01=g_luo.luo01
            AND lup02=g_lup_t.lup02

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lup_file",g_luo.luo01,
                 g_lup_t.lup02,SQLCA.sqlcode,"","",1)
            LET g_lup[l_ac].* = g_lup_t.*
         ELSE
            MESSAGE 'UPDATE O.K'
            COMMIT WORK
         END IF
      END IF

   AFTER ROW
      DISPLAY  "AFTER ROW!!"
      LET l_ac = ARR_CURR()
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0

         IF p_cmd = 'a' THEN
            CALL g_lup.deleteElement(l_ac)
            #FUN-D30033--add--begin--
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
            #FUN-D30033--add--end----
         END IF

         IF p_cmd = 'u' THEN
            LET g_lup[l_ac].* = g_lup_t.*
         END IF

         CLOSE t614_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF

      LET l_ac_t = l_ac   #FUN-D30033 add
      IF g_success =  'N' THEN
         CLOSE t614_bcl
         ROLLBACK WORK
      ELSE
         CLOSE t614_bcl
      END IF
      
   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION controlp
      CASE
         WHEN INFIELD(lup03)
            CALL cl_init_qry_var()
            IF g_luo.luo03 = '1' THEN 
               LET g_qryparam.form ="q_lup03"
            ELSE
               LET g_qryparam.form ="q_lup03_2"
            END IF 
            LET g_qryparam.default1 = g_lup[l_ac].lup03
            CALL cl_create_qry() RETURNING g_lup[l_ac].lup03
            DISPLAY BY NAME g_lup[l_ac].lup03
            NEXT FIELD lup03
         OTHERWISE
            EXIT CASE
      END CASE

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

   IF p_cmd = 'u' THEN
      LET g_luo.luomodu = g_user
      LET g_luo.luodate = g_today

      UPDATE luo_file
         SET luomodu = g_luo.luomodu,
             luodate = g_luo.luodate
       WHERE luo01 = g_luo.luo01
      DISPLAY BY NAME g_luo.luomodu,g_luo.luodate
   END IF
   CALL t614_upd() 
   CLOSE t614_bcl
#  CALL t614_delall() #CHI-C30002 mark
   CALL t614_delHeader()     #CHI-C30002 add
   COMMIT WORK 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t614_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_luo.luo01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM luo_file ",
                  "  WHERE luo01 LIKE '",l_slip,"%' ",
                  "    AND luo01 > '",g_luo.luo01,"'"
      PREPARE t614_pb1 FROM l_sql 
      EXECUTE t614_pb1 INTO l_cnt      
      
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
         CALL t614_v()
         IF g_luo.luoconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic(g_luo.luoconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM luo_file where luo01 = g_luo.luo01
         INITIALIZE g_luo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t614_delall()
#  DEFINE l_n    LIKE type_file.num5

#  SELECT count(*) INTO l_n
#    FROM lup_file
#   WHERE lup01 = g_luo.luo01

#  IF l_n = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#        ERROR g_msg CLIPPED
#     DELETE FROM luo_file where luo01 = g_luo.luo01
#  END IF 
#END FUNCTION
#CHI-C30002 -------- mark -------- end


#刷新单头的金额数据，分别汇总单身的支出、已退、未退以及清算金额，回写到单头
FUNCTION t614_upd()
   DEFINE l_sql         STRING,
          l_luo09       LIKE luo_file.luo09,
          l_luo10       LIKE luo_file.luo10,
          l_luo11       LIKE luo_file.luo11,
          l_amt         LIKE luo_file.luo09,
          l_amt1        LIKE lup_file.lup06,
          l_lul06       LIKE lul_file.lul06,
          l_lul07       LIKE lul_file.lul07,
          l_lul08       LIKE lul_file.lul08
   DEFINE l_lup  RECORD LIKE lup_file.*      

   LET l_sql = " SELECT *",
               "   FROM lup_file ",
               "  WHERE lup01 = '",g_luo.luo01,"'"

   DECLARE t614_upd_cs CURSOR FROM l_sql 

   LET l_luo09 = 0
   LET l_luo10 = 0
   LET l_luo11 = 0
   LET l_amt1 = 0
   LET l_amt = 0
   
   FOREACH t614_upd_cs INTO l_lup.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF cl_null(l_lup.lup06) THEN 
         LET l_lup.lup06 = 0 
      END IF  

      IF cl_null(l_lup.lup07) THEN
         LET l_lup.lup07 = 0
      END IF

      IF cl_null(l_lup.lup08) THEN
         LET l_lup.lup08 = 0
      END IF

      LET l_luo09 = l_luo09 + l_lup.lup06
      LET l_luo10 = l_luo10 + l_lup.lup07
      LET l_luo11 = l_luo11 + l_lup.lup08

      IF g_luo.luo03 ='1' THEN 
         SELECT lul06,lul07,lul08 INTO l_lul06,l_lul07,l_lul08
           FROM lul_file
          WHERE lul01 = l_lup.lup03
            AND lul02 = l_lup.lup04
         LET l_amt1 = l_lul06 - l_lul07 - l_lul08   
      ELSE 
         SELECT lub04t,lub11,lub12 INTO l_lul06,l_lul07,l_lul08
           FROM lub_file
          WHERE lub01 = l_lup.lup03
            AND lub02 = l_lup.lup04

         LET l_amt1 = l_lul07 + l_lul08 - l_lul06   
      END IF  
      #LET l_amt = l_amt + l_amt1  
   END FOREACH   

    
   LET g_luo.luo09 = l_luo09
   LET g_luo.luo10 = l_luo10
   LET g_luo.luo11 = l_luo11
   LET l_amt = g_luo.luo09 - g_luo.luo10 - g_luo.luo11
   
   UPDATE luo_file 
      SET luo09 = l_luo09,
          luo10 = l_luo10,
          luo11 = l_luo11
    WHERE luo01 = g_luo.luo01

   DISPLAY BY NAME g_luo.luo09,g_luo.luo10,g_luo.luo11
   DISPLAY l_amt TO FORMONLY.amt
END FUNCTION 

FUNCTION t614_b_fill(p_wc2)
   DEFINE p_wc2      STRING,
          l_amt_1    LIKE lup_file.lup06,
          l_amt1     LIKE lup_file.lup06

   IF cl_null(p_wc2) THEN
      LET p_wc2 = " 1=1" 
   END IF 
   LET g_sql = "SELECT lup02,lup03,lup04,lup05,'','','',lup06,",
               "       lup07,'',lup08,'','','','',lup09",
               "  FROM lup_file",
               " WHERE lup01 ='",g_luo.luo01,"' ",
               "   AND ",p_wc2 CLIPPED ,
               " ORDER BY lup02"

   PREPARE t614_pb FROM g_sql
   DECLARE t614_b_cs CURSOR FOR t614_pb

   CALL g_lup.clear()
   LET g_cnt = 1

   FOREACH t614_b_cs INTO g_lup[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      CALL t614_dis_oaj(g_lup[g_cnt].lup05,'1')
      CALL t614_desc(g_lup[g_cnt].lup03,g_lup[g_cnt].lup04,'1')   

      IF cl_null(g_lup[g_cnt].lup08) THEN
         LET g_lup[g_cnt].lup08 = 0
      END IF  

      IF cl_null(g_lup[g_cnt].lup07) THEN
         LET g_lup[g_cnt].lup07 = 0
      END IF 
   
      LET l_amt_1 = g_lup[g_cnt].lup06 - g_lup[g_cnt].lup07 - g_lup[g_cnt].lup08
      LET g_lup[g_cnt].amt = l_amt_1
     
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lup.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t614_bp_refresh()
END FUNCTION

#p_flag用于判断是在何处调用该函数，
#p_flag = '1' 在b_fill()函数中调用，为‘2’在BEFORE ROW中调用该function
FUNCTION t614_dis_oaj(p_lup05,p_flag)
   DEFINE p_oaj01      LIKE oaj_file.oaj01,
          l_oaj02      LIKE oaj_file.oaj02,
          l_oaj04      LIKE oaj_file.oaj04,
          l_oaj041     LIKE oaj_file.oaj041,
          l_aag02      LIKE aag_file.aag02,
          l_aag02_1    LIKE aag_file.aag02,
          p_lup05      LIKE lup_file.lup05,
          p_flag       LIKE type_file.chr1
#FUN-C10024--add--str--
   DEFINE l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--
   CALL s_get_bookno(YEAR(g_luo.luo02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add       
   SELECT oaj02,oaj04,oaj041 
     INTO l_oaj02,l_oaj04,l_oaj041
     FROM oaj_file 
    WHERE oaj01 = p_lup05

   SELECT aag02 INTO l_aag02
     FROM aag_file
    #WHERE aag00 = g_aza.aza81 #FUN-C10024 
     WHERE aag00 =l_bookno1  #FUN-C10024 add
      AND aag01 = l_oaj04

   SELECT aag02 INTO l_aag02_1
     FROM aag_file
    #WHERE aag00 = g_aza.aza81   #FUN-C10024 
     WHERE aag00 =l_bookno2   #FUN-C10024 add
      AND aag01 = l_oaj041   

   CASE p_flag 
      WHEN '1'
         LET g_lup[g_cnt].oaj02 = l_oaj02
         LET g_lup[g_cnt].oaj04 = l_oaj04
         LET g_lup[g_cnt].oaj041 = l_oaj041
         LET g_lup[g_cnt].aag02 = l_aag02
         LET g_lup[g_cnt].aag02_1 = l_aag02_1
      WHEN '2'
         IF cl_null(g_lup[l_ac].lup08) THEN
            LET g_lup[l_ac].lup08 = 0
         END IF

         IF cl_null(g_lup[l_ac].lup07) THEN
            LET g_lup[l_ac].lup07 = 0
         END IF

         LET g_lup[l_ac].oaj02 = l_oaj02
         LET g_lup[l_ac].oaj04 = l_oaj04
         LET g_lup[l_ac].oaj041 = l_oaj041   
         LET g_lup[l_ac].aag02 = l_aag02
         LET g_lup[l_ac].aag02_1 = l_aag02_1
         LET g_lup[l_ac].amt = g_lup[l_ac].lup06 - g_lup[l_ac].lup07 
                               - g_lup[l_ac].lup08
   END CASE    
END FUNCTION 

#由门店编号带出门店名称及法人编号和法人名称
FUNCTION t614_luoplant(p_cmd)
   DEFINE l_rtz13      LIKE rtz_file.rtz13,
          l_rtz28      LIKE rtz_file.rtz28,
          l_azt02      LIKE azt_file.azt02,
          l_azw02      LIKE azw_file.azw02,
          p_cmd        LIKE type_file.chr1

   SELECT rtz13,rtz28 INTO l_rtz13,l_rtz28
     FROM rtz_file
    WHERE rtz01 = g_luo.luoplant

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'alm-001'
      WHEN l_rtz28 <> 'Y'
         LET g_errno = 'lma-003'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT azw02 INTO l_azw02
        FROM azw_file
       WHERE azw01 = g_luo.luoplant

      LET g_luo.luolegal = l_azw02

      SELECT azt02 INTO l_azt02
        FROM azt_file
       WHERE azt01 = g_luo.luolegal
     
      DISPLAY BY NAME g_luo.luoplant 
      DISPLAY BY NAME g_luo.luolegal
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION

FUNCTION t614_bp_refresh()
   DISPLAY ARRAY g_lup TO s_lup.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

   BEFORE DISPLAY
      EXIT DISPLAY

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

#带出单身的相关值，p_flag同上使用
FUNCTION t614_desc(p_lup03,p_lup04,p_flag)
   DEFINE l_lub09    LIKE lub_file.lub09,
          l_lub04t   LIKE lub_file.lub04t,
          l_lub11    LIKE lub_file.lub11,
          l_lub12    LIKE lub_file.lub12,
          l_lul03    LIKE lul_file.lul03,
          l_lul04    LIKE lul_file.lul04,
          l_lul05    LIKE lul_file.lul05,
          l_lul06    LIKE lul_file.lul06,
          l_lul07    LIKE lul_file.lul07,
          l_lul08    LIKE lul_file.lul08,
          p_lup03    LIKE lup_file.lup03,
          p_lup04    LIKE lup_file.lup04,
          l_luj06    LIKE luj_file.luj06,
          p_flag     LIKE type_file.chr1,
          l_lup06    LIKE lup_file.lup06,
          l_amt1     LIKE lup_file.lup06
          
   IF g_luo.luo03 = '1' THEN 
      SELECT lul03,lul04,lul05,lul06,lul07,lul08 
        INTO l_lul03,l_lul04,l_lul05,l_lul06,l_lul07,l_lul08
        FROM lul_file
       WHERE lul01 = p_lup03
         AND lul02 = p_lup04

      SELECT oaj05 INTO l_lub09
        FROM oaj_file
       WHERE oaj01 = l_lul05

      CASE p_flag
         WHEN '1'
            LET g_lup[g_cnt].oaj05 = l_lub09
            LET g_lup[g_cnt].amt1 = l_lul06 - l_lul07 - l_lul08
         WHEN '2'
            LET g_lup[l_ac].oaj05 = l_lub09
            LET g_lup[l_ac].amt1 = l_lul06 - l_lul07 - l_lul08
      END CASE 
   ELSE
      SELECT lub09,lub04t,lub11,lub12 
        INTO l_lub09,l_lub04t,l_lub11,l_lub12
        FROM lub_file
       WHERE lub01 = p_lup03
         AND lub02 = p_lup04

      #FUN-C30072--start add----------------------
      IF l_lub09 = '10' THEN
         LET l_amt1 = l_lub04t - l_lub11 - l_lub12
      ELSE
      #FUN-C30072--end add------------------------
         LET l_amt1 = l_lub11 + l_lub12 - l_lub04t
      END IF                  #FUN-C30072 add
      CASE p_flag
         WHEN '1'
            LET g_lup[g_cnt].oaj05 = l_lub09
            LET g_lup[g_cnt].amt1 = l_amt1 
         WHEN '2'
            LET g_lup[l_ac].oaj05 = l_lub09
            LET g_lup[l_ac].amt1 = l_amt1
      END CASE
   END IF    
END FUNCTION 

#判断单身是否有数据，如果有不允许修改单头的来源类型和来源单号
FUNCTION t614_luo03()
   DEFINE l_n     LIKE type_file.num5
   
   LET g_errno = ''

   SELECT count(*) INTO l_n
     FROM lup_file
    WHERE lup01 = g_luo.luo01

   IF l_n > 0 THEN
      LET g_errno = 'alm1339'
   END IF    
END FUNCTION

#根据来源单号和来源单号的项次判断
FUNCTION t614_luo04(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          l_luk10      LIKE luk_file.luk10,
          l_luk11      LIKE luk_file.luk11,
          l_luk12      LIKE luk_file.luk12,
          l_lukacti    LIKE luk_file.lukacti,
          l_luaacti    LIKE lua_file.luaacti,
          l_lua08t     LIKE lua_file.lua08t,
          l_lua35      LIKE lua_file.lua35,
          l_lua36      LIKE lua_file.lua36, 
          l_amt        LIKE lua_file.lua35,
          l_lua06      LIKE lua_file.lua06,
          l_lua061     LIKE lua_file.lua061,
          l_lua07      LIKE lua_file.lua07,
          l_lua04      LIKE lua_file.lua04,
          l_lua14      LIKE lua_file.lua14,
          l_lua20      LIKE lua_file.lua20,
          l_lnt26      LIKE lnt_file.lnt26,
          l_lnt30      LIKE lnt_file.lnt30,
          l_tqa02      LIKE tqa_file.tqa02

   LET g_errno = ''

   CASE g_luo.luo03
      WHEN '1'
         SELECT luk10,luk11,luk12,lukacti,luk06,luk07,luk08,luk09
           INTO l_luk10,l_luk11,l_luk12,l_lukacti,l_lua06,l_lua07,
                l_lua04,l_lua20
           FROM luk_file
          WHERE luk01 = g_luo.luo04 

         IF NOT cl_null(l_luk10) AND NOT cl_null(l_luk11) 
                                 AND NOT cl_null(l_luk12) THEN
            LET l_amt = l_luk10 -l_luk11- l_luk12                      
         END IF
         
         CASE 
            WHEN SQLCA.SQLCODE = 100
               LET g_errno = 'alm1204'
            WHEN l_lukacti = 'N'
               LET g_errno = 'alm1228' 
            WHEN l_amt = 0
               LET g_errno = 'alm1229'        
            OTHERWISE            
               LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE

        #FUN-C20079-----mark---str---
        #SELECT lne05 INTO l_lua061 
        #  FROM lne_file
        # WHERE lne01 = l_lua06
        #FUN-C20079-----mark---end---
        #FUN-C20079-----add----str---
         SELECT occ02 INTO l_lua061
           FROM occ_file
          WHERE occ01 = l_lua06
        #FUN-C20079-----add----end---
          
      WHEN '2'
         SELECT luaacti,lua08t,lua35,lua36,lua06,lua061,lua07,lua04,lua20,lua14
           INTO l_luaacti,l_lua08t,l_lua35,l_lua36,l_lua06,l_lua061,l_lua07,
                l_lua04,l_lua20,l_lua14
           FROM lua_file
          WHERE lua01 = g_luo.luo04

         CASE 
            WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-716'
            WHEN l_lua14 = '2'       LET g_errno = 'axm-444'
            WHEN l_luaacti = 'N'     LET g_errno = 'alm-111'
            OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE 
   END CASE

   SELECT lnt26 INTO l_lnt26 
     FROM lnt_file
    WHERE lnt01 = l_lua04

   #判断合同状态是否是终审通过或终止或到期，是允许新增支出单，
   #否则不允许新增支出单
   IF l_lnt26 <> 'S' AND l_lnt26 <> 'E' AND l_lnt26 <> 'Y' THEN 
      LET g_errno = 'alm1231' 
   END IF  
   
   IF cl_null(g_errno) THEN
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM lup_file
       WHERE lup01 = g_luo.luo01
         AND lup03 <> g_luo.luo04
      IF g_cnt > 0 THEN
         LET g_errno = 'alm1238'
      END IF
   END IF

   IF NOT cl_null(l_lua04) THEN
      SELECT lnt30 INTO l_lnt30 
        FROM lnt_file
       WHERE lnt01 = l_lua04
   ELSE
      SELECT lne08 INTO l_lnt30
        FROM lne_file
       WHERE lne01 = l_lua06
   END IF

   SELECT tqa02 INTO l_tqa02 
     FROM tqa_file
    WHERE tqa01 = l_lnt30
      AND tqa03 = '2'
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_luo.luo05 = l_lua06
      LET g_luo.luo06 = l_lua07
      LET g_luo.luo07 = l_lua04
      LET g_luo.luo08 = l_lua20
             
      DISPLAY BY NAME g_luo.luo04,g_luo.luo05,g_luo.luo06,
                      g_luo.luo07,g_luo.luo08
      DISPLAY l_lua061 TO FORMONLY.luo05_desc
      DISPLAY l_lnt30 TO FORMONLY.lnt30
      DISPLAY l_tqa02 TO FORMONLY.tqa02
   END IF    
   
END FUNCTION 

FUNCTION t614_luo05(p_cmd)
   DEFINE l_lne36          LIKE lne_file.lne36,
          l_lne05          LIKE lne_file.lne05,
          p_cmd            LIKE type_file.chr1
   DEFINE l_lnt30          LIKE lnt_file.lnt30
   DEFINE l_tqa02          LIKE tqa_file.tqa02

   LET g_errno = ''

   #FUN-C20079----mark---str----
   #SELECT lne36,lne05 INTO l_lne36,l_lne05 
   #  FROM lne_file
   # WHERE lne01 = g_luo.luo05
   #FUN-C20079----mark---end----

   #FUN-C20079----add----str----
   SELECT lne36 INTO l_lne36
     FROM lne_file
    WHERE lne01 = g_luo.luo05
   SELECT occ02 INTO l_lne05
     FROM occ_file
    WHERE occ01 = g_luo.luo05
   #FUN-C20079----add----end----
   CASE 
      WHEN SQLCA.sqlcode = 100 
         LET g_errno = 'alm-186'
      WHEN l_lne36 <> 'Y'
         LET g_errno = 'alm1042'
      OTHERWISE                
         LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY BY NAME g_luo.luo05 
      DISPLAY l_lne05 TO FORMONLY.luo05_desc
      IF cl_null(g_luo.luo07) THEN
         SELECT lne08 INTO l_lnt30
           FROM lne_file
          WHERE lne01 = g_luo.luo05
         SELECT tqa02 INTO l_tqa02
           FROM tqa_file
          WHERE tqa01 = l_lnt30
            AND tqa03 = '2'
         DISPLAY l_lnt30 TO FORMONLY.lnt30
         DISPLAY l_tqa02 TO FORMONLY.tqa02
      END IF
   END IF 
END FUNCTION 

FUNCTION t614_luo06(p_cmd)
   DEFINE l_lmf06        LIKE lmf_file.lmf06,
          p_cmd          LIKE type_file.chr1

   LET g_errno = ''

   SELECT lmf06 INTO l_lmf06 
     FROM lmf_file
    WHERE lmf01 = g_luo.luo06

   CASE 
      WHEN sqlca.sqlcode = 100
         LET g_errno = ''
      WHEN l_lmf06 <> 'N'
         LET g_errno = ''
      OTHERWISE                
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY BY NAME g_luo.luo06  
   END IF  
END FUNCTION 

FUNCTION t614_luo07(p_cmd)
 DEFINE p_cmd           LIKE type_file.chr1
 DEFINE l_lnt02         LIKE lnt_file.lnt02
 DEFINE l_lnt04         LIKE lnt_file.lnt04
 DEFINE l_lnt06         LIKE lnt_file.lnt06
 DEFINE l_lnt26         LIKE lnt_file.lnt26
 DEFINE l_lnt30         LIKE lnt_file.lnt30
 DEFINE l_tqa02         LIKE tqa_file.tqa02
 DEFINE l_lne05         LIKE lne_file.lne05

   LET g_errno = ''

   SELECT lnt04,lnt06,lnt26,lnt02,lnt30
     INTO l_lnt04,l_lnt06,l_lnt26,l_lnt02,l_lnt30 
     FROM lnt_file
    WHERE lnt01 = g_luo.luo07

   CASE 
      WHEN sqlca.sqlcode = 100 LET g_errno = 'alm-132'
      WHEN l_lnt26 NOT MATCHES '[YSE]'
                               LET g_errno = 'alm1231'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_cmd <> 'd' THEN 
         LET g_luo.luo05 = l_lnt04
         LET g_luo.luo06 = l_lnt06
         LET g_luo.luo08 = l_lnt02
      END IF
     # SELECT lne05 INTO l_lne05 FROM lne_file  #FUN-C20079 mark
     #  WHERE lne01 = g_luo.luo05               #FUN-C20079 mark
      SELECT occ02 INTO l_lne05 FROM occ_file   #FUN-C20079 add
       WHERE occ01 = g_luo.luo05                #FUN-C20079 add
      SELECT tqa02 INTO l_tqa02
        FROM tqa_file
       WHERE tqa01 = l_lnt30
         AND tqa03 = '2' 
      DISPLAY l_lnt30 TO FORMONLY.lnt30
      DISPLAY l_tqa02 TO FORMONLY.tqa02  
      DISPLAY l_lne05 TO FORMONLY.luo05_desc
      DISPLAY BY NAME g_luo.luo05,g_luo.luo06,g_luo.luo08
   END IF
END FUNCTION 

FUNCTION t614_gen02(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_gen02    LIKE gen_file.gen02,
          l_gen03    LIKE gen_file.gen03,
          l_genacti  LIKE gen_file.genacti,
          l_gem02    LIKE gem_file.gem02 

   LET g_errno = ''

   SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03 
     FROM gen_file
    WHERE gen01 = g_luo.luo12

   IF NOT cl_null(l_gen03) THEN
      SELECT gem02 INTO l_gem02 
        FROM gem_file
       WHERE gem01 = l_gen03
   END IF 
    
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = ''
      WHEN l_genacti <> 'Y'
         LET g_errno = ''   
      OTHERWISE                
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_luo.luo13 = l_gen03
      DISPLAY BY NAME g_luo.luo12,g_luo.luo13  
      DISPLAY l_gen02 TO FORMONLY.gen02  
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF  
END FUNCTION 

FUNCTION t614_gem02(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_gem02      LIKE gem_file.gem02,
          l_gemacti    LIKE gem_file.gemacti 

   LET g_errno = ''

   SELECT gem02,gemacti INTO l_gem02,l_gemacti 
     FROM gem_file
    WHERE gem01 = g_luo.luo13

   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'asf-471'
      WHEN l_gemacti <> 'Y'
         LET g_errno = 'asf-472'
      OTHERWISE                
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY BY NAME g_luo.luo12 
      DISPLAY l_gem02 TO FORMONLY.gem02  
   END IF 
END FUNCTION 

FUNCTION t614_lup03(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1,
          l_lukacti      LIKE luk_file.lukacti,
          l_lukconf      LIKE luk_file.lukconf,
          l_lua15        LIKE lua_file.lua15,
          l_luaacti      LIKE lua_file.luaacti,
          l_lup05        LIKE lup_file.lup05
   DEFINE l_luk06        LIKE luk_file.luk06
   DEFINE l_luk07        LIKE luk_file.luk07
   DEFINE l_luk08        LIKE luk_file.luk08 
   DEFINE l_lua06        LIKE lua_file.lua06
   DEFINE l_lua07        LIKE lua_file.lua07
   DEFINE l_lua04        LIKE lua_file.lua04

   LET g_errno = ''       

   IF cl_null(g_luo.luo04) THEN
      CASE g_luo.luo03
         WHEN '1'
            SELECT luk06,luk07,luk08,lukacti,lukconf 
              INTO l_luk06,l_luk07,l_luk08,l_lukacti,l_lukconf 
              FROM luk_file
             WHERE luk01 = g_lup[l_ac].lup03

            CASE 
               WHEN SQLCA.sqlcode = 100
                  LET g_errno = 'alm1204'
               WHEN l_lukacti <> 'Y'
                  LET g_errno = 'alm1228'
               WHEN l_lukconf <> 'Y'
                  LET g_errno = 'alm1274'   
               WHEN (NOT cl_null(l_luk06) AND NOT cl_null(g_luo.luo05) AND l_luk06 <> g_luo.luo05)
                  LET g_errno = 'art1035'
               WHEN (NOT cl_null(l_luk07) AND NOT cl_null(g_luo.luo06) AND l_luk07 <> g_luo.luo06) 
                  LET g_errno = 'art1036'
               WHEN (NOT cl_null(l_luk08) AND NOT cl_null(g_luo.luo07) AND l_luk08 <> g_luo.luo07)
                  LET g_errno = 'art1037'  
               OTHERWISE                
                  LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE  

         WHEN '2'
            SELECT luaacti,lua15,lua06,lua07,lua04
              INTO l_luaacti,l_lua15,l_lua06,l_lua07,l_lua04 
              FROM lua_file
             WHERE lua01 = g_lup[l_ac].lup03

            CASE 
               WHEN SQLCA.sqlcode = 100
                  LET g_errno = 'alm-112'
               WHEN l_luaacti <> 'Y'
                  LET g_errno = 'alm-111'
               WHEN l_lua15 <> 'Y'
                  LET g_errno = 'alm-110'
               WHEN (NOT cl_null(l_lua06) AND NOT cl_null(g_luo.luo05) AND l_lua06 <> g_luo.luo05)
                  LET g_errno = 'art1035'
               WHEN (NOT cl_null(l_lua07) AND NOT cl_null(g_luo.luo06) AND l_lua07 <> g_luo.luo06)
                 LET g_errno = 'art1036'
               WHEN (NOT cl_null(l_lua04) AND NOT cl_null(g_luo.luo07) AND l_lua04 <> g_luo.luo07)
                 LET g_errno = 'art1037'
               OTHERWISE                
                  LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE 
      END CASE  
   ELSE
      IF g_lup[l_ac].lup03 <> g_luo.luo04 THEN
         LET g_errno = 'alm1238' 
      END IF 
   END IF
   
END FUNCTION 

FUNCTION t614_lup04(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,
          l_lup06   LIKE lup_file.lup06,
          l_luj06   LIKE luj_file.luj06,
          l_lul03   LIKE lul_file.lul03,
          l_lul04   LIKE lul_file.lul04,
          l_lub03   LIKE lub_file.lub03,
          l_lub09   LIKE lub_file.lub09,
          l_oaj02   LIKE oaj_file.oaj02,
          l_oaj04   LIKE oaj_file.oaj04,
          l_oaj041  LIKE oaj_file.oaj041,
          l_aag02   LIKE aag_file.aag02,
          l_aag02_1 LIKE aag_file.aag02,
          l_lub04t  LIKE lub_file.lub04t,
          l_lub11   LIKE lub_file.lub11,
          l_lub12   LIKE lub_file.lub12,
          l_lub13   LIKE lub_file.lub13,
          l_lua14   LIKE lua_file.lua14,
          l_lua15   LIKE lua_file.lua15,
          l_luaacti LIKE lua_file.luaacti,
          l_amt     LIKE lub_file.lub12,
          l_amt2    LIKE lup_file.lup06,
          l_lukconf LIKE luk_file.lukconf,
          l_n       LIKE type_file.num5
   
#FUN-C10024--add--str--
DEFINE    l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--       
   LET g_errno = ''
  
   #支出单中同一来源单号+项次的支出金额之和
   IF p_cmd = 'u' THEN
      IF g_lup[l_ac].lup03 <> g_lup_t.lup03 OR
         g_lup[l_ac].lup04 <> g_lup_t.lup04 THEN
         SELECT COUNT(*) INTO l_n
           FROM lup_file
          WHERE lup03 = g_lup[l_ac].lup03
            AND lup04 = g_lup[l_ac].lup04
            AND lup01 = g_luo.luo01
         IF l_n > 0 THEN
            LET g_errno = 'alm1356'
            RETURN       
         END IF 
      END IF

      SELECT SUM(lup06) INTO l_lup06
        FROM lup_file
       WHERE lup03 = g_lup[l_ac].lup03
         AND lup04 = g_lup[l_ac].lup04
         AND (lup01 <> g_luo.luo01 OR lup02 <> g_lup[l_ac].lup02)
   ELSE
      SELECT count(*) INTO l_n
        FROM lup_file
       WHERE lup03 = g_lup[l_ac].lup03
         AND lup04 = g_lup[l_ac].lup04
         AND lup01 = g_luo.luo01

      IF l_n >0 THEN
         LET g_errno = 'alm1356'
         RETURN
      END IF 
 
      SELECT SUM(lup06) INTO l_lup06
        FROM lup_file
       WHERE lup03 = g_lup[l_ac].lup03
         AND lup04 = g_lup[l_ac].lup04
   END IF 
      
   IF cl_null(l_lup06) THEN
      LET l_lup06 = 0
   END IF

   LET l_amt = 0
   LET l_amt2 = 0

   #检查来源单号+项次的有效性，根据来源类型分别去判断待抵单和费用单
   CASE g_luo.luo03
      WHEN '1'               #来源类型是待抵单
         SELECT lukconf INTO l_lukconf 
           FROM luk_file
          WHERE luk01 = g_lup[l_ac].lup03

         CASE 
            WHEN SQLCA.SQLCODE = 100
               LET g_errno ='art-763'
            WHEN l_lukconf <> 'Y'
               LET g_errno = '1274' 
            OTHERWISE                
               LET g_errno = SQLCA.SQLCODE USING '-------' 
         END CASE

         SELECT COUNT(*) INTO l_n 
           FROM lul_file
          WHERE lul01 = g_lup[l_ac].lup03
            AND lul02 = g_lup[l_ac].lup04

         IF l_n = 0 THEN 
            LET g_errno = 'alm1275'
         ELSE    
            SELECT lul03,lul04,lul05,lul06,lul07,lul08
              INTO l_lul03,l_lul04,l_lub03,l_lub04t,l_lub11,l_lub12 
              FROM lul_file
             WHERE lul01 = g_lup[l_ac].lup03
               AND lul02 = g_lup[l_ac].lup04

            IF cl_null(l_lub04t) THEN
               LET l_lub04t = 0 
            END IF 

            IF cl_null(l_lub11) THEN
               LET l_lub11 = 0 
            END IF 

            IF cl_null(l_lub12) THEN
               LET l_lub12 = 0 
            END IF 

            LET l_amt = l_lub04t - l_lub11 -l_lub12
            LET g_lup[l_ac].amt1 = l_amt
   
            IF p_cmd = 'a' THEN
               LET l_amt2 = l_amt - l_lup06
               LET g_lup[l_ac].lup06 = l_amt2
               LET g_lup[l_ac].lup07 = 0
               LET g_lup[l_ac].lup08 = 0
            END IF 

            LET g_lup[l_ac].amt = l_amt2
            
            SELECT oaj05 INTO l_lub09
              FROM oaj_file
             WHERE oaj01 = l_lub03
         END IF 
  
      WHEN '2'         #来源类型是费用单
         SELECT lua14,lua15,luaacti
           INTO l_lua14,l_lua15,l_luaacti
           FROM lua_file
          WHERE lua01 = g_lup[l_ac].lup03 
         
         CASE 
            WHEN SQLCA.SQLCODE = 100
               LET g_errno = 'alm-112'
            WHEN l_luaacti = 'N'
               LET g_errno = 'alm-111'
            WHEN l_lua15 <> 'Y'
               LET g_errno = 'alm-110'
            WHEN l_lua14 = '2'
               LET g_errno = 'axm-444'
            OTHERWISE                
               LET g_errno = SQLCA.SQLCODE USING '-------' 
         END CASE 

         SELECT count(*) INTO l_n 
           FROM lub_file
          WHERE lub01 = g_lup[l_ac].lup03
            AND lub02 = g_lup[l_ac].lup04


         IF l_n = 0 THEN 
            LET g_errno = 'alm1275'
         ELSE    

         SELECT lub03,lub04t,lub11,lub12,lub09,lub13 
           INTO l_lub03,l_lub04t,l_lub11,l_lub12,l_lub09,l_lub13 
           FROM lub_file
          WHERE lub01 = g_lup[l_ac].lup03
            AND lub02 = g_lup[l_ac].lup04

         IF cl_null(l_lub04t) THEN 
            LET l_lub04t = 0
         END IF     

         IF cl_null(l_lub11) THEN 
            LET l_lub11 = 0
         END IF

         IF cl_null(l_lub12) THEN 
            LET l_lub12 = 0
         END IF

         #交款单中当前来源单号与项次的所有交款金额
         SELECT SUM(luj06) INTO l_luj06
           FROM luj_file
          WHERE luj03 = g_lup[l_ac].lup03
            AND luj04 = g_lup[l_ac].lup04
            
         IF cl_null(l_luj06) THEN 
            LET l_luj06 = 0
         END IF 
         #FUN-C30072--start add------------------------------------ 
         IF l_lub09 = '10' THEN
            LET l_amt = l_lub04t - l_luj06 -l_lup06             
            LET g_lup[l_ac].amt1 = l_lub04t -l_lub11 -l_lub12
         ELSE
            LET l_amt = -l_lub04t + l_luj06 - l_lup06
            LET g_lup[l_ac].amt1 = l_lub11 + l_lub12 - l_lub04t
         END IF 
         #FUN-C30072--end add--------------------------------------          
         #LET l_amt = l_lub04t - l_luj06 + l_lup06     #FUN-C30072 mark
        
         CASE 
            WHEN SQLCA.SQLCODE = 100
               LET g_errno = 'alm-116'
            WHEN l_lub13 = 'Y'
               LET g_errno = 'axm-202' 
            WHEN  l_amt<= 0
               WHEN g_errno = 'alm1235'
            OTHERWISE                
               LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         
         IF l_amt >0 THEN 
            IF p_cmd = 'a' THEN
               LET g_lup[l_ac].lup06 = l_amt
               LET g_lup[l_ac].amt = l_amt
               LET g_lup[l_ac].lup07 = 0
               LET g_lup[l_ac].lup08 = 0
            END IF 
            #LET g_lup[l_ac].amt1 = l_amt    #FUN-C30072 mark
         END IF  
      END IF   
   END CASE 

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      SELECT oaj02,oaj04,oaj041 INTO l_oaj02,l_oaj04,l_oaj041
        FROM oaj_file
       WHERE oaj01 = l_lub03
      CALL s_get_bookno(YEAR(g_luo.luo02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
      SELECT aag02 INTO l_aag02 
        FROM aag_file
       #WHERE aag00 = g_aza.aza81   #FUN-C10024
        WHERE aag00 = l_bookno1     #FUN-C10024 add
         AND aag01 = l_oaj04

      SELECT aag02 INTO l_aag02_1
        FROM aag_file
       #WHERE aag00 = g_aza.aza81   #FUN-C10024
        WHERE aag00 = l_bookno2  #FUN-C10024 add
         AND aag01 = l_oaj041
       
      LET g_lup[l_ac].lup05 = l_lub03
      LET g_lup[l_ac].oaj05 = l_lub09
      LET g_lup[l_ac].oaj02 = l_oaj02
      LET g_lup[l_ac].oaj04 = l_oaj04
      LET g_lup[l_ac].oaj041 = l_oaj041 
      LET g_lup[l_ac].aag02 = l_aag02
      LET g_lup[l_ac].aag02_1 = l_aag02_1     
   END IF 
END FUNCTION 

#FUN-C30072--start add---------------------------------------------
FUNCTION t614_chk_lup05(p_cmd)
   DEFINE l_lub09         LIKE lub_file.lub09
   DEFINE l_lup03         LIKE lup_file.lup03
   DEFINE l_lup04         LIKE lup_file.lup04
   DEFINE p_cmd           LIKE type_file.chr1

   LET g_errno = ''
   IF p_cmd = 'u' THEN 
      LET g_sql = " SELECT lup03,lup04 ",
                  "   FROM lup_file",
                  "  WHERE lup01 = '",g_luo.luo01,"'",
                  "    AND lup02 <>'", g_lup_t.lup02,"' "
   ELSE
      LET g_sql = " SELECT lup03,lup04 ",
                  "   FROM lup_file",
                  "  WHERE lup01 = '",g_luo.luo01,"'",
                  "    AND lup02 <>'", g_lup[l_ac].lup02,"' "
   END IF 
   PREPARE chk_lup05_pre FROM g_sql
   DECLARE chk_lup05_curs CURSOR FOR chk_lup05_pre 

 
   FOREACH chk_lup05_curs INTO l_lup03,l_lup04 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach sel_lub_cur',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT lub09 INTO l_lub09
        FROM lub_file
       WHERE lub01 = l_lup03
         AND lub02 = l_lup04
 
      IF g_lup[l_ac].oaj05 = '10' THEN
         IF l_lub09 <> '10' THEN
            LET g_errno = 'art1063'
            EXIT FOREACH 
         END IF   
      ELSE
         IF l_lub09 = '10' THEN
            LET g_errno = 'art1063'
            EXIT FOREACH  
         END IF 
      END IF
   END FOREACH
   
END FUNCTION
#FUN-C30072--end add-----------------------------------------------

#TQC-C30141 Begin---
FUNCTION t614_chk_llb02(p_type,p_luo03,p_lup03,p_llb01)
 DEFINE p_type          LIKE type_file.chr1 #1:支出单单身检查,2:自动产生单身
 DEFINE p_luo03         LIKE luo_file.luo03 #来源类型
 DEFINE p_lup03         LIKE lup_file.lup03 #来源单号
 DEFINE p_llb01         LIKE llb_file.llb01 #费用编号
 DEFINE l_llb02         LIKE llb_file.llb02
 DEFINE l_lnt01         LIKE lnt_file.lnt01
 DEFINE l_lnt18         LIKE lnt_file.lnt18
 DEFINE l_lnt26         LIKE lnt_file.lnt26

   SELECT llb02 INTO l_llb02
     FROM llb_file
    WHERE llbstore = g_luo.luoplant
      AND llb01 = p_llb01
   IF cl_null(l_llb02) THEN LET l_llb02 = 0 END IF
   IF l_llb02 = 0 THEN RETURN TRUE END IF

   IF p_luo03 = '1' THEN
      SELECT luk08 INTO l_lnt01 FROM luk_file
       WHERE luk01 = p_lup03
   END IF
   IF p_luo03 = '2' THEN
   #  SELECT lua04 INTO l_lnt01 FROM lua_file
   #   WHERE luk01 = p_lup03
   END IF

   IF cl_null(l_lnt01) THEN
      RETURN TRUE
   END IF
   SELECT lnt18,lnt26 INTO l_lnt18,l_lnt26
     FROM lnt_file
    WHERE lnt01 = l_lnt01
   IF SQLCA.sqlcode = 100 THEN RETURN TRUE END IF
   IF NOT (l_lnt26 = 'S' OR l_lnt26 = 'E') THEN
      IF p_type = '1' THEN
         CALL cl_err_msg("","alm1599",p_llb01 CLIPPED|| "|" || l_llb02 CLIPPED,0)
      END IF
      RETURN FALSE
   END IF
   IF l_lnt26 = 'S' THEN
      SELECT lji29 INTO l_lnt18
        FROM lji_file
       WHERE lji04 = l_lnt01
         AND lji03 = '5'
   END IF

   IF g_today < s_incmonth(l_lnt18,l_llb02) THEN
      IF p_type = '1' THEN
         CALL cl_err_msg("","alm1599",p_llb01 CLIPPED|| "|" || l_llb02 CLIPPED,0)
      END IF
      RETURN FALSE
   END IF

   RETURN TRUE
END FUNCTION
#TQC-C30141 End-----

#FUN-C30072--start add------------------------------------------
#FUNCTION t614_lup06(p_cmd)
#   DEFINE l_amt1      LIKE lup_file.lup06,
#          l_amt2      LIKE lup_file.lup06,
#          l_lup04     LIKE lup_file.lup04,
#          l_lup06     LIKE lup_file.lup06,
#          l_lul06     LIKE lul_file.lul06,
#          l_lul07     LIKE lul_file.lul07,
#          l_lul08     LIKE lul_file.lul08,
#          l_lul05     LIKE lul_file.lul05,
#          l_luk01     LIKE luk_file.luk01,
#          l_lua01     LIKE lua_file.lua01,
#          l_luj06     LIKE luj_file.luj06,
#          p_cmd       LIKE type_file.chr1
#
#   LET g_errno = ''
#   LET l_amt1 = 0
#   LET l_amt2 = 0
# 
#   CASE g_luo.luo03
#      WHEN '1' 
#         SELECT lul05,lul06,lul07,lul08 INTO l_lul05,l_lul06,l_lul07,l_lul08
#           FROM lul_file
#          WHERE lul01 = g_lup[l_ac].lup03
#            AND lul02 = g_lup[l_ac].lup04
#         
#      WHEN '2'
#         SELECT lub03,lub04t,lub11,lub12 INTO l_lul05,l_lul06,l_lul07,l_lul08
#           FROM lub_file
#          WHERE lub01 = g_lup[l_ac].lup03
#            AND lub02 = g_lup[l_ac].lup04
#   END CASE 
#   
#   IF p_cmd = 'u' THEN  
#      SELECT SUM(lup06) INTO l_lup06
#        FROM lup_file
#       WHERE lup03 = g_lup[l_ac].lup03
#         AND lup04 = g_lup[l_ac].lup04
#         AND (lup01 <> g_luo.luo01 OR lup02 <> g_lup[l_ac].lup02)
#   ELSE
#      SELECT SUM(lup06) INTO l_lup06
#        FROM lup_file
#       WHERE lup03 = g_lup[l_ac].lup03
#         AND lup04 = g_lup[l_ac].lup04
#   END IF
# 
#   IF cl_null(l_lup06) THEN 
#      LET l_lup06 = 0 
#   END IF 
#
#
#   IF cl_null(l_lul06) THEN
#      LET l_lul06 = 0
#   END IF
#
#   IF cl_null(l_lul07) THEN
#      LET l_lul07 = 0
#   END IF       
#
#   IF cl_null(l_lul08) THEN
#      LET l_lul08 = 0
#   END IF
#
#   CASE g_luo.luo03
#      WHEN '1'
#         LET l_amt1 = l_lul06 - l_lul07 - l_lul08
#         LET l_amt2 = l_amt1 - l_lup06 
#         CASE
#            WHEN g_lup[l_ac].lup06 > l_amt1
#               LET g_errno = 'alm1236'
#            WHEN g_lup[l_ac].lup06 > l_amt2
#               LET g_errno = 'alm1237'
#         END CASE
#      WHEN '2'
#         SELECT SUM(luj06) INTO l_luj06
#           FROM luj_file
#          WHERE luj03 = g_lup[l_ac].lup03
#            AND luj04 = g_lup[l_ac].lup04 
#      
#         IF cl_null(l_luj06) THEN
#            LET l_luj06 = 0
#         END IF 
#
#         LET l_amt1 = l_lul06 - l_luj06 
#         #LET l_amt1 = l_luj06 - l_amt1
#         
#         IF l_amt1 >= 0 THEN
#            LET g_errno = 'alm1230'
#            RETURN  
#         END IF 
#         LET l_amt2 = l_amt1 + l_lup06
#         CASE
#            WHEN g_lup[l_ac].lup06 >  -l_amt1
#               LET g_errno = 'alm1236'
#            WHEN g_lup[l_ac].lup06 > -l_amt2
#               LET g_errno = 'alm1237'
#         END CASE
#   END CASE 
#END FUNCTION 
#FUN-C30072--end add-------------------------------------

#FUN-C30072--start add-----------------------------------------------
FUNCTION t614_lup06(p_cmd)
   DEFINE l_amt1      LIKE lup_file.lup06,
          l_amt2      LIKE lup_file.lup06,
          l_lup04     LIKE lup_file.lup04,
          l_lup06     LIKE lup_file.lup06,
          l_lul06     LIKE lul_file.lul06,
          l_lul07     LIKE lul_file.lul07,
          l_lul08     LIKE lul_file.lul08,
          l_lul05     LIKE lul_file.lul05,
          l_luk01     LIKE luk_file.luk01,
          l_lua01     LIKE lua_file.lua01,
          l_luj06     LIKE luj_file.luj06,
          p_cmd       LIKE type_file.chr1
   DEFINE l_lub09     LIKE lub_file.lub09 

   LET g_errno = ''
   LET l_amt1 = 0
   LET l_amt2 = 0

   CASE g_luo.luo03
      WHEN '1'
         SELECT lul05,lul06,lul07,lul08 INTO l_lul05,l_lul06,l_lul07,l_lul08
           FROM lul_file
          WHERE lul01 = g_lup[l_ac].lup03
            AND lul02 = g_lup[l_ac].lup04

      WHEN '2'
         SELECT lub03,lub04t,lub11,lub12,lub09 INTO l_lul05,l_lul06,l_lul07,l_lul08,l_lub09
           FROM lub_file
          WHERE lub01 = g_lup[l_ac].lup03
            AND lub02 = g_lup[l_ac].lup04
   END CASE

   IF p_cmd = 'u' THEN
      SELECT SUM(lup06) INTO l_lup06
        FROM lup_file
       WHERE lup03 = g_lup[l_ac].lup03
         AND lup04 = g_lup[l_ac].lup04
         AND (lup01 <> g_luo.luo01 OR lup02 <> g_lup[l_ac].lup02)
   ELSE
      SELECT SUM(lup06) INTO l_lup06
        FROM lup_file
       WHERE lup03 = g_lup[l_ac].lup03
         AND lup04 = g_lup[l_ac].lup04
   END IF

   IF cl_null(l_lup06) THEN
      LET l_lup06 = 0
   END IF


   IF cl_null(l_lul06) THEN
      LET l_lul06 = 0
   END IF

   IF cl_null(l_lul07) THEN
      LET l_lul07 = 0
   END IF

   IF cl_null(l_lul08) THEN
      LET l_lul08 = 0
   END IF

   CASE g_luo.luo03
      WHEN '1'
         LET l_amt1 = l_lul06 - l_lul07 - l_lul08
         LET l_amt2 = l_amt1 - l_lup06
         CASE
            WHEN g_lup[l_ac].lup06 > l_amt1
               LET g_errno = 'alm1236'
            WHEN g_lup[l_ac].lup06 > l_amt2
               LET g_errno = 'alm1237'
         END CASE
      WHEN '2'
         SELECT SUM(luj06) INTO l_luj06
           FROM luj_file
          WHERE luj03 = g_lup[l_ac].lup03
            AND luj04 = g_lup[l_ac].lup04

         IF cl_null(l_luj06) THEN
            LET l_luj06 = 0
         END IF

         LET l_amt1 = l_lul06 - l_luj06

         IF l_lub09 = '10' THEN
            LET l_amt2 = l_amt1 - l_lup06
            CASE
               WHEN g_lup[l_ac].lup06 >  l_amt1
                  LET g_errno = 'alm1236'
               WHEN g_lup[l_ac].lup06 > l_amt2
                  LET g_errno = 'alm1237'
            END CASE   
         ELSE
            IF l_amt1 >= 0 THEN
               LET g_errno = 'alm1230'
               RETURN
            END IF 
            LET l_amt2 = l_amt1 + l_lup06
            CASE
               WHEN g_lup[l_ac].lup06 >  -l_amt1
                  LET g_errno = 'alm1236'
               WHEN g_lup[l_ac].lup06 > -l_amt2
                  LET g_errno = 'alm1237'
            END CASE  
         END IF 
   END CASE
END FUNCTION
#FUN-C30072--end add-------------------------------------------------

#退款单查询
FUNCTION t614_qry_refund()
   DEFINE l_cmd      STRING 

   IF cl_null(g_luo.luo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 

   LET l_cmd = "artt615 '1' '",g_luo.luo01 CLIPPED ,"'"
   CALL cl_cmdrun(l_cmd)
END FUNCTION 

#退款单退款，产生退款单，同时打开该退款单进行退款
FUNCTION t614_credit_refund()
   DEFINE l_cmd        STRING

#By shi 重新整理
   IF cl_null(g_luo.luo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_luo.* FROM luo_file WHERE luo01=g_luo.luo01

   IF g_luo.luoconf = 'N' THEN
      CALL cl_err('','aap-717',0)
      RETURN
   END IF
   IF g_luo.luoconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_luo.luoplant <> g_plant THEN
      LET g_errno = 'alm1023'
      RETURN
   END IF   

   IF cl_null(g_luo.luo09) THEN LET g_luo.luo09 = 0 END IF
   IF cl_null(g_luo.luo10) THEN LET g_luo.luo10 = 0 END IF
   IF cl_null(g_luo.luo11) THEN LET g_luo.luo11 = 0 END IF

   IF g_luo.luo09-g_luo.luo10-g_luo.luo11 = 0 THEN
      CALL cl_err('','alm1232',0)
      RETURN
   END IF

   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success = 'Y'
   OPEN t614_cl USING g_luo.luo01
   IF STATUS THEN
      CALL cl_err("open t614_cl:",STATUS,1)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t614_cl INTO g_luo.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL t614_generate_refund()

   CALL s_showmsg()
   IF g_success = 'Y' THEN 
      COMMIT WORK
      LET l_cmd = "artt615  '1' '",g_luo.luo01,"'"
      CALL cl_cmdrun(l_cmd)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','alm1351',0)
   END IF
END FUNCTION 

#自动产生退款单
FUNCTION t614_generate_refund()
   DEFINE l_luo   RECORD LIKE luo_file.*,
          l_lup   RECORD LIKE lup_file.*,
          l_luc   RECORD LIKE luc_file.*,
          l_lud   RECORD LIKE lud_file.*,
          li_result      LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_cnt          LIKE type_file.num5,
          l_amt          LIKE lud_file.lud07t
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO g_luc01 FROM rye_file
   # WHERE rye01 = 'art' AND rye02 = 'C1'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','C1',g_plant,'N') RETURNING g_luc01    #FUN-C90050 add

   IF cl_null(g_luc01) THEN
      CALL s_errmsg('','','sel rye_file','art-330',1)
      LET g_success = 'N'
      RETURN
   END IF
   LET g_dd = g_today
   
  #OPEN WINDOW t614_1_w WITH FORM "art/42f/artt614_1"
  # ATTRIBUTE(STYLE=g_win_style CLIPPED)
  # 
  #CALL cl_ui_locale("artt614_1")
  #
  #DISPLAY g_luc01 TO FORMONLY.g_luc01
  #DISPLAY g_dd TO FORMONLY.g_dd
  #
  #INPUT  BY NAME g_luc01,g_dd   WITHOUT DEFAULTS
  #   BEFORE INPUT
  #   
  #   AFTER FIELD g_luc01
  #      LET l_cnt = 0
  #      
  #      SELECT COUNT(*) INTO  l_cnt FROM oay_file
  #       WHERE oaysys ='art' AND oaytype ='C1' AND oayslip = g_luc01
  #       
  #      IF l_cnt = 0 THEN
  #         CALL cl_err(g_luc01,'art-800',0)
  #         NEXT FIELD g_luc01
  #      END IF

  #   ON ACTION CONTROLR
  #      CALL cl_show_req_fields()

  #   ON ACTION CONTROLG
  #      CALL cl_cmdask()
  #   ON ACTION CONTROLF
  #      CALL cl_set_focus_form(ui.Interface.getRootNode()) 
  #                             RETURNING g_fld_name,g_frm_name
  #      CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

  #   ON ACTION controlp
  #      CASE
  #         WHEN INFIELD(g_luc01)
  #            LET g_t1=s_get_doc_no(g_luc01)
  #            CALL q_oay(FALSE,FALSE,g_t1,'C1','ART') RETURNING g_t1  
  #            LET g_luc01=g_t1               
  #            DISPLAY BY NAME g_luc01
  #            NEXT FIELD g_luc01
  #         OTHERWISE EXIT CASE
  #      END CASE
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE INPUT

  #   ON ACTION about
  #      CALL cl_about()

  #   ON ACTION HELP
  #      CALL cl_show_help()
  #END INPUT
  #
  #IF INT_FLAG THEN
  #   LET INT_FLAG=0
  #   CLOSE WINDOW t614_1_w
  #   CALL cl_err('',9001,0)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
  #
  #CLOSE WINDOW t614_1_w
   
   #自動編號
   CALL s_check_no("art",g_luc01,"",'C1',"luc_file","luc01","")
      RETURNING li_result,l_luc.luc01
      
   LET g_t1=s_get_doc_no(g_luc01)
   CALL s_auto_assign_no("art",g_luc01,g_dd,'C1',"luc_file","luc01","","","")
      RETURNING li_result,l_luc.luc01
      
   IF NOT li_result THEN
      CALL s_errmsg('','','auto no','alm1350',1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_luc.luc02 = '1'
   LET l_luc.luc03 = g_luo.luo05

   #FUN-C20079----mark----str---
   #SELECT lne05 INTO l_luc.luc031
   #  FROM lne_file
   # WHERE lne01 = g_luo.luo05
   #FUN-C20079----mark----end---
   #FUN-C20079----add-----str---
   SELECT occ02 INTO l_luc.luc031
     FROM occ_file
    WHERE occ01 = g_luo.luo05 
   #FUN-C20079----add-----end---

   LET l_luc.luc04 = g_luo.luo07
   LET l_luc.luc05 = g_luo.luo06
   LET l_luc.luc06 = 0
   LET l_luc.luc06t = 0
   LET l_luc.luc07 = g_dd
   LET l_luc.luc09 = 'N'
   LET l_luc.luc10 = '1'
   LET l_luc.luc11 = g_luo.luo01
   LET l_luc.luc12 = 'N'
   LET l_luc.luc13 ='0'
   LET l_luc.luc14 = 'N'
   LET l_luc.luc16 = NULL
   LET l_luc.luc17 = 0
   LET l_luc.luc17t = 0

   SELECT occ41 INTO l_luc.luc18 FROM occ_file
    WHERE occ01 = l_luc.luc03

   SELECT gec04,gec07 INTO l_luc.luc181,l_luc.luc182 FROM gec_file
    WHERE gec01 = l_luc.luc18

   LET l_luc.luc20 = '2'

   IF g_ooz.ooz09 >= g_today THEN
      LET l_luc.luc21 = g_ooz.ooz09 + 1
   ELSE
      LET l_luc.luc21 = g_today
   END IF

   LET l_luc.luc22 = g_luo.luo08
   LET l_luc.luc24 = 0
   LET l_luc.luc25 = 'N'
   LET l_luc.luc26 = g_luo.luo12
   LET l_luc.luc27 = g_luo.luo13
   LET l_luc.lucacti = 'Y'
   LET l_luc.lucuser = g_user
   LET l_luc.lucgrup = g_grup
   LET l_luc.lucmodu = NULL
   LET l_luc.lucdate = g_today
   LET l_luc.luccrat = g_today
   LET l_luc.lucoriu = g_user
   LET l_luc.lucorig = g_grup
   LET l_luc.lucplant = g_luo.luoplant
   LET l_luc.luclegal = g_luo.luolegal
   
   LET g_sql = "SELECT * FROM lup_file",
               " WHERE lup01 = '",g_luo.luo01,"'",
               " ORDER BY lup02"
   PREPARE t614_15_prepare FROM g_sql
   DECLARE t614_15_cs CURSOR FOR t614_15_prepare

   LET l_cnt = 1 
   FOREACH t614_15_cs INTO l_lup.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','t614_15_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF cl_null(l_lup.lup06) THEN LET l_lup.lup06 = 0 END IF
      IF cl_null(l_lup.lup07) THEN LET l_lup.lup07 = 0 END IF
      IF cl_null(l_lup.lup08) THEN LET l_lup.lup08 = 0 END IF
      SELECT SUM(lud07t) INTO l_amt FROM lud_file,luc_file
       WHERE lud01 = luc01
         AND luc10 = '1'
         AND luc14 = 'N'
         AND lud03 = g_luo.luo01
         AND lud04 = l_lup.lup02
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      LET l_lud.lud07t = l_lup.lup06 - l_lup.lup07 - l_lup.lup08 - l_amt
      IF l_lud.lud07t = 0 THEN CONTINUE FOREACH END IF
      LET l_luc.luc23 = l_luc.luc23 + l_lud.lud07t
      LET l_lud.lud07 = l_lud.lud07t/(1+l_luc.luc181/100)
      SELECT azi04 INTO g_azi04 FROM azi_file
       WHERE azi01 = g_aza.aza17
      LET l_lud.lud07 = cl_digcut(l_lud.lud07,g_azi04)

      LET l_lud.lud01 = l_luc.luc01
      LET l_lud.lud02 = l_cnt
      LET l_lud.lud03 = g_luo.luo01
      LET l_lud.lud04 = l_lup.lup02
      LET l_lud.lud05 = l_lup.lup05
      LET l_lud.ludlegal = l_lup.luplegal
      LET l_lud.ludplant = l_lup.lupplant
      
      INSERT INTO lud_file VALUES l_lud.* 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','ins lud',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF           
      LET l_cnt = l_cnt + 1   
   END FOREACH
   IF l_cnt = 1 THEN RETURN END IF

   INSERT INTO luc_file VALUES l_luc.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','','ins lud',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 

##根据单头自动带出单身，如果单头来源单号为空，单身抓取所有满足单头条件的单身
##单身来源单号可以不同，如果单头来源单号不为空，单身来源单号必须与单头的一致
##主要是根据单头的商户编号、摊位编号以及合同编号分别去待抵单和费用单抓取满足
##条件的单身
#FUNCTION t614_inslup()
#   DEFINE l_luoacti      LIKE luo_file.luoacti,
#          l_lul06        LIKE lul_file.lul06,
#          l_lul07        LIKE lul_file.lul07,
#          l_lul08        LIKE lul_file.lul08,
#          l_amt1         LIKE lup_file.lup06, 
#          l_lup02        LIKE lup_file.lup02,
#          l_lup06        LIKE lup_file.lup06,
#          l_lub04t       LIKE lub_file.lub04t,
#          l_lub11        LIKE lub_file.lub11,
#          l_lub12        LIKE lub_file.lub12,
#          l_lub02        LIKE lub_file.lub02,
#          l_lub03        LIKE lub_file.lub03,
#          l_lul01        LIKE lul_file.lul01,
#          l_lub01        LIKE lub_file.lub01,
#          l_llb02        LIKE llb_file.llb02,
#          l_lnt18        LIKE lnt_file.lnt18,
#          l_lnt26        LIKE lnt_file.lnt26,
#          l_lji29        LIKE lji_file.lji29,
#          l_luj06        LIKE luj_file.luj06,
#          l_msg          STRING,
#          l_msg1         STRING, 
#          l_msg2         STRING,
#          l_sql          STRING 
#   DEFINE l_lup   RECORD LIKE lup_file.*
#   
#   SELECT lnt26 INTO l_lnt26
#     FROM lnt_file
#    WHERE lnt01 = g_luo.luo07
#   
#   IF NOT cl_null(g_luo.luo04) THEN            
#      CASE g_luo.luo03
#         WHEN '1'
#            LET l_sql = " SELECT lul02,lul05,lul06,lul07,lul08",
#                        "   FROM lul_file",
#                        "  WHERE lul01 = '",g_luo.luo04,"'"
#         WHEN '2' 
#            LET l_sql = " SELECT lub02,lub03,lub04t,lub11,lub12 ",
#                        "   FROM lub_file ",
#                        "  WHERE lub01 = '",g_luo.luo04,"'",
#                        "    AND lub13 = 'N'"
#      END CASE 
#      
#      DECLARE t614_ins_cs CURSOR FROM l_sql
#      
#      FOREACH t614_ins_cs INTO l_lub02,l_lub03,l_lub04t,l_lub11,l_lub12
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF 
#
#         IF cl_null(l_lub04t) THEN
#            LET l_lub04t = 0 
#         END IF 
#
#         IF cl_null(l_lub11) THEN 
#            LET l_lub11 = 0 
#         END IF 
#
#         IF cl_null(l_lub12) THEN
#            LET l_lub12 = 0 
#         END IF 
#
#         SELECT llb02 INTO l_llb02
#           FROM llb_file
#          WHERE llbstore = g_luo.luoplant 
#            AND llb01 = l_lub03
#
#         SELECT lji29 INTO l_lji29
#           FROM lji_file 
#          WHERE lji04 = g_luo.luo07
#            AND lji03 = '5' 
#
#         SELECT lnt18 INTO l_lnt18
#           FROM lnt_file
#          WHERE lnt01 = g_luo.luo07
#         
#         IF cl_null(l_llb02) THEN
#            LET l_llb02 = 0 
#         END IF    
#
#         IF l_llb02 > 0 THEN
#            IF NOT cl_null(l_lji29) THEN
#               IF g_luo.luo02 <= l_lji29 + l_llb02 THEN
#                  CALL cl_getmsg('alm1362',g_lang) RETURNING l_msg2
#                  CALL cl_getmsg('alm1293',g_lang) RETURNING l_msg
#                  CALL cl_getmsg('alm1361',g_lang) RETURNING l_msg1
#                  LET l_msg = l_msg2,l_lub03,l_msg,l_llb02,l_msg1
#                  CALL cl_err('',l_msg,0)
#                  CONTINUE FOREACH
#               END IF
#            ELSE
#               IF g_luo.luo02 <= l_lnt18 + l_llb02 THEN
#                  CALL cl_getmsg('alm1362',g_lang) RETURNING l_msg2
#                  CALL cl_getmsg('alm1294',g_lang) RETURNING l_msg
#                  CALL cl_getmsg('alm1361',g_lang) RETURNING l_msg1
#                  LET l_msg = l_msg2,l_lub03,l_msg,l_llb02,l_msg1
#                  CALL cl_err('',l_msg,0)
#                  CONTINUE FOREACH
#               END IF
#            END IF  
#         END IF 
#
#         SELECT SUM(lup06) INTO l_lup06
#           FROM lup_file
#          WHERE lup03 = g_luo.luo04
#            AND lup04 = l_lub02
#
#         IF cl_null(l_lup06) THEN
#            LET l_lup06 = 0  
#         END IF
#         
#         SELECT MAX(lup02) INTO l_lup02 
#           FROM lup_file
#          WHERE lup01 = g_luo.luo01 
#         IF cl_null(l_lup02) THEN
#            LET l_lup02 = 1 
#         ELSE 
#            LET l_lup02 = l_lup02 +1
#         END IF  
#
#         LET l_lup.lup01 = g_luo.luo01 
#         LET l_lup.lup02 = l_lup02 
#         LET l_lup.lup03 = g_luo.luo04
#         LET l_lup.lup04 = l_lub02
#         LET l_lup.lup05 = l_lub03
#
#         IF g_luo.luo03 = '1' THEN
#            LET l_amt1 = l_lub04t - l_lub11 - l_lub12
#            LET l_lup.lup06 = l_amt1 - l_lup06
#         ELSE 
#            SELECT SUM(luj06) INTO l_luj06
#              FROM luj_file
#             WHERE luj03 = g_luo.luo04
#               AND luj04 = l_lub02
#
#            IF cl_null(l_luj06) THEN 
#               LET l_luj06 = 0 
#            END IF 
#               
#            LET l_amt1 = l_lub11 + l_lub12 - l_lub04t
#
#            IF l_amt1 <= 0 THEN
#               CONTINUE FOREACH  
#            END IF 
# 
#            LET l_amt1 = l_lub04t + l_lup06 - l_luj06
#                        
#            IF l_amt1 >= 0 THEN 
#               CONTINUE FOREACH
#            END IF
#            LET l_lup.lup06 = -l_amt1 
#         END IF 
#        
#         LET l_lup.lupplant = g_luo.luoplant 
#         LET l_lup.luplegal = g_luo.luolegal
#
#         INSERT INTO lup_file VALUES l_lup.*
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err3("ins","lup_file",g_luo.luo01,"",
#                                          SQLCA.sqlcode,"","",1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#      END FOREACH    
#   ELSE 
#      CASE g_luo.luo03
#         WHEN '1'
#            LET l_sql = "SELECT lul01,lul02,lul05,lul06,lul07,lul08",
#                        "  FROM luk_file,lul_file",
#                        " WHERE lukconf = 'Y'",
#                        "   AND luk06 = '",g_luo.luo05,"'",
#                        "   AND luk07 = '",g_luo.luo06,"'",
#                        "   AND luk08 = '",g_luo.luo07,"'",
#                        "   AND luk01 = lul01"
#             
#         WHEN '2'
#            LET l_sql = " SELECT lub01,lub02,lub03,lub04t,lub11,lub12",
#                        "   FROM lua_file,lub_file",
#                        "  WHERE lua15 = 'Y'",
#                        "    AND lua06 = '",g_luo.luo05,"'",
#                        "    AND lua07 = '",g_luo.luo06,"'",
#                        "    AND lua04 = '",g_luo.luo07,"'",
#                        "    AND lua01 = lub01",
#                        "    AND lub13 = 'N'"
#      END CASE 
#
#      DECLARE t614_ins_cs2 CURSOR FROM l_sql 
#
#      FOREACH t614_ins_cs2 INTO l_lub01,l_lub02,l_lub03,l_lub04t,l_lub11,l_lub12
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#      
#         SELECT llb02 INTO l_llb02
#           FROM llb_file
#          WHERE llbstore = g_luo.luoplant 
#            AND llb01 = l_lub03
#
#         SELECT lji29 INTO l_lji29
#           FROM lji_file 
#          WHERE lji04 = g_luo.luo07
#            AND lji03 = '5' 
#
#         SELECT lnt18 INTO l_lnt18
#           FROM lnt_file
#          WHERE lnt01 = g_luo.luo07
#         
#         IF cl_null(l_llb02) THEN
#            LET l_llb02 = 0 
#         END IF    
#
#         IF l_llb02 > 0 THEN
#            IF NOT cl_null(l_lji29) THEN
#               IF g_luo.luo02 <= l_lji29 + l_llb02 THEN
#                  CALL cl_getmsg('alm1362',g_lang) RETURNING l_msg2
#                  CALL cl_getmsg('alm1293',g_lang) RETURNING l_msg
#                  CALL cl_getmsg('alm1361',g_lang) RETURNING l_msg1
#                  LET l_msg = l_msg2,l_lub03,l_msg,l_llb02,l_msg1
#                  CALL cl_err('',l_msg,0)
#                  CONTINUE FOREACH
#               END IF
#            ELSE
#               IF g_luo.luo02 <= l_lnt18 + l_llb02 THEN
#                  CALL cl_getmsg('alm1362',g_lang) RETURNING l_msg2
#                  CALL cl_getmsg('alm1294',g_lang) RETURNING l_msg
#                  CALL cl_getmsg('alm1361',g_lang) RETURNING l_msg1
#                  LET l_msg = l_msg2,l_lub03,l_msg,l_llb02,l_msg1
#                  CALL cl_err('',l_msg,0)
#                  CONTINUE FOREACH
#               END IF
#            END IF
#         END IF    
#
#         SELECT SUM(lup06) INTO l_lup06
#           FROM lup_file
#          WHERE lup03 = l_lub01
#            AND lup04 = l_lub02
#
#         IF cl_null(l_lup06) THEN 
#            LET l_lup06 = 0
#         END IF 
#
#         CASE g_luo.luo03 
#            WHEN '1'
#               LET l_amt1 = l_lub04t - l_lub11 - l_lub12
#               LET l_amt1 = l_amt1 - l_lup06
#            WHEN '2'
#               SELECT SUM(luj06) INTO l_luj06
#                 FROM luj_file
#                WHERE luj03 = l_lub01
#                  AND luj04 = l_lub02
#
#               IF cl_null(l_luj06) THEN
#                  LET l_luj06 = 0
#               END IF         
#
#               LET l_amt1 = l_lub11 + l_lub12 - l_lub04t
#
#               IF l_amt1 <= 0 THEN 
#                  CONTINUE FOREACH 
#               END IF 
#
#               LET l_amt1 = l_lub04t + l_lup06 - l_luj06
#               IF l_amt1 >= 0 THEN
#                  CONTINUE FOREACH
#               END IF
#         END CASE 
#         
#         SELECT MAX(lup02) INTO l_lup02
#           FROM lup_file
#          WHERE lup01 = g_luo.luo01
#
#         IF cl_null(l_lup02) THEN 
#            LET l_lup02 = 1
#         ELSE 
#            LET l_lup02 = l_lup02 + 1
#         END IF    
#         
#         LET l_lup.lup01 = g_luo.luo01
#         LET l_lup.lup02 = l_lup02
#         LET l_lup.lup03 = l_lub01
#         LET l_lup.lup04 = l_lub02
#         LET l_lup.lup05 = l_lub03
#         CASE g_luo.luo03 
#            WHEN '1'
#               LET l_lup.lup06 = l_amt1
#            WHEN '2'
#               LET l_lup.lup06 = -l_amt1 
#         END CASE
#         LET l_lup.lupplant = g_luo.luoplant
#         LET l_lup.luplegal = g_luo.luolegal
#
#         INSERT INTO lup_file VALUES l_lup.*
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err3("ins","lup_file",g_luo.luo01,"",
#                                       SQLCA.sqlcode,"","",1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#      END FOREACH 
#   END IF    
#END FUNCTION 

#FUN-C30072--start add----------------------------------------------------------
##根据单头条件自动带出单身
#FUNCTION t614_inslup()
# DEFINE l_lup          RECORD LIKE lup_file.*
# DEFINE l_lub01        LIKE lub_file.lub01
# DEFINE l_lub02        LIKE lub_file.lub02
# DEFINE l_lub03        LIKE lub_file.lub03
# DEFINE l_lub04t       LIKE lub_file.lub04t
# DEFINE l_lub11        LIKE lub_file.lub11
# DEFINE l_lub12        LIKE lub_file.lub12
# DEFINE l_lup06        LIKE lup_file.lup06
# DEFINE l_luj06        LIKE luj_file.luj06
# DEFINE l_llb02        LIKE llb_file.llb02
# DEFINE l_lnt18        LIKE lnt_file.lnt18
# DEFINE l_lnt26        LIKE lnt_file.lnt26
# DEFINE l_year         LIKE type_file.num5
# DEFINE l_month        LIKE type_file.num5
# DEFINE l_day          LIKE type_file.num5
# DEFINE l_lnt01        LIKE lnt_file.lnt01
# 
#   CASE g_luo.luo03
#      WHEN '1'
#         LET g_sql = " SELECT lul01,lul02,lul05,lul06,lul07,lul08",
#                     "   FROM lul_file,luk_file",
#                     "  WHERE luk01 = lul01 ",
#                     "    AND lul06-lul07-lul08>0 "
#         IF NOT cl_null(g_luo.luo04) THEN
#            LET g_sql = g_sql CLIPPED,"    AND lul01 = '",g_luo.luo04,"'"
#         ELSE
#            IF NOT cl_null(g_luo.luo05) THEN
#               LET g_sql = g_sql CLIPPED,"    AND luk06 = '",g_luo.luo05,"'"
#            END IF
#            IF NOT cl_null(g_luo.luo06) THEN
#               LET g_sql = g_sql CLIPPED,"    AND luk07 = '",g_luo.luo06,"'"
#            END IF
#            IF NOT cl_null(g_luo.luo07) THEN
#               LET g_sql = g_sql CLIPPED,"    AND luk08 = '",g_luo.luo07,"'"
#            END IF
#         END IF
#      WHEN '2' 
#         LET g_sql = " SELECT lub01,lub02,lub03,lub04t,lub11,lub12 ",
#                     "   FROM lub_file,lua_file ",
#                     "  WHERE lua01 = lub01 ",
#                     "    AND lub13 = 'N'",
#                     "    AND lua14 = '1'",
#                     "    AND lua15 = 'Y'",
#                     "    AND lub04t < 0"
#         IF NOT cl_null(g_luo.luo04) THEN
#            LET g_sql = g_sql CLIPPED,"    AND lub01 = '",g_luo.luo04,"'"
#         ELSE
#            IF NOT cl_null(g_luo.luo05) THEN
#               LET g_sql = g_sql CLIPPED,"    AND lua06 = '",g_luo.luo05,"'"
#            END IF
#            IF NOT cl_null(g_luo.luo06) THEN
#               LET g_sql = g_sql CLIPPED,"    AND lua07 = '",g_luo.luo06,"'"
#            END IF
#            IF NOT cl_null(g_luo.luo07) THEN
#               LET g_sql = g_sql CLIPPED,"    AND lua04 = '",g_luo.luo07,"'"
#            END IF
#         END IF
#   END CASE
#   DECLARE t614_ins_cs CURSOR FROM g_sql
#   FOREACH t614_ins_cs INTO l_lub01,l_lub02,l_lub03,l_lub04t,l_lub11,l_lub12
#                            #费用单号，项次，费用编号，费用金额，已收金额，清算金额
#                            #待抵单号，项次，费用编号，待抵金额，已冲金额，已退金额
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      
#      SELECT MAX(lup02)+1 INTO l_lup.lup02
#        FROM lup_file
#       WHERE lup01 = g_luo.luo01 
#      IF cl_null(l_lup.lup02) THEN
#         LET l_lup.lup02 = 1 
#      END IF  
#
#      LET l_lup.lup01 = g_luo.luo01
#      LET l_lup.lup03 = l_lub01
#      LET l_lup.lup04 = l_lub02
#      LET l_lup.lup05 = l_lub03
#
#      SELECT SUM(lup06) INTO l_lup06 FROM lup_file
#       WHERE lup03 = l_lub01
#         AND lup04 = l_lub02
#      IF cl_null(l_lup06) THEN LET l_lup06 = 0 END IF
#      IF g_luo.luo03 = '1' THEN
#         LET l_lup.lup06 = l_lub04t-l_lub11-l_lup06
#      END IF
#      IF g_luo.luo03 = '2' THEN
#         SELECT SUM(luj06) INTO l_luj06 FROM luj_file
#          WHERE luj03 = l_lub01
#            AND luj04 = l_lub02
#         IF cl_null(l_luj06) THEN LET l_luj06 = 0 END IF
#         LET l_lup.lup06 = l_lub04t-l_lub12-l_luj06+l_lup06
#         LET l_lup.lup06 = -l_lup.lup06
#      END IF
#      IF l_lup.lup06 = 0 THEN 
#         CONTINUE FOREACH
#      END IF
#
#     #TQC-C30141 Begin---
#     #SELECT llb02 INTO l_llb02
#     #  FROM llb_file
#     # WHERE llbstore = g_luo.luoplant 
#     #   AND llb01 = l_lub03
#     #IF cl_null(l_llb02) THEN LET l_llb02 = 0 END IF
#     #IF l_llb02 > 0 AND g_luo.luo03 = '1' THEN
#     #   SELECT luk08 INTO l_lnt01 FROM luk_file
#     #    WHERE luk01 = l_lub01
#     #   IF NOT cl_null(l_lnt01) THEN
#     #      SELECT lnt18,lnt26 INTO l_lnt18,l_lnt26
#     #        FROM lnt_file
#     #       WHERE lnt01 = l_lnt01
#     #      IF SQLCA.sqlcode = 100 THEN CONTINUE FOREACH END IF
#     #      IF NOT (l_lnt26 = 'S' OR l_lnt26 = 'E') THEN
#     #         CONTINUE FOREACH
#     #      END IF
#     #      IF l_lnt26 = 'S' THEN
#     #         SELECT lji29 INTO l_lnt18
#     #           FROM lji_file 
#     #          WHERE lji04 = g_luo.luo07
#     #            AND lji03 = '5'
#     #      END IF
#     #      LET l_year = YEAR(l_lnt18)
#     #      LET l_month = MONTH(l_lnt18) + l_llb02
#     #      LET l_day = DAY(l_lnt18)
#     #      IF l_month > 12 THEN
#     #         LET l_month = l_month-12
#     #         LET l_year = l_year + 1
#     #      END IF
#     #      
#     #      IF g_today < MDY(l_month,l_day,l_year) THEN
#     #         CONTINUE FOREACH
#     #      END IF
#     #   END IF
#     #END IF
#      IF NOT t614_chk_llb02('2',g_luo.luo03,l_lub01,l_lub03) THEN
#         CONTINUE FOREACH
#      END IF
#     #TQC-C30141 End-----
#      
#      LET l_lup.lup07 = 0
#      LET l_lup.lup08 = 0
#      LET l_lup.lupplant = g_luo.luoplant 
#      LET l_lup.luplegal = g_luo.luolegal
#
#      INSERT INTO lup_file VALUES l_lup.*
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err3("ins","lup_file",g_luo.luo01,"",SQLCA.sqlcode,"","",1)
#         LET g_success = 'N'
#         RETURN
#      END IF
#   END FOREACH
#END FUNCTION
#FUN-C30072--end add--------------------------------------------------------

#FUN-C30072--start add------------------------------------------------------
#根据单头条件自动带出单身   
FUNCTION t614_inslup() 
 DEFINE l_lup          RECORD LIKE lup_file.*
 DEFINE l_lub01        LIKE lub_file.lub01
 DEFINE l_lub02        LIKE lub_file.lub02
 DEFINE l_lub03        LIKE lub_file.lub03
 DEFINE l_lub04t       LIKE lub_file.lub04t
 DEFINE l_lub09        LIKE lub_file.lub09 
 DEFINE l_lub11        LIKE lub_file.lub11
 DEFINE l_lub12        LIKE lub_file.lub12
 DEFINE l_lup06        LIKE lup_file.lup06
 DEFINE l_luj06        LIKE luj_file.luj06
 DEFINE l_llb02        LIKE llb_file.llb02
 DEFINE l_lnt18        LIKE lnt_file.lnt18
 DEFINE l_lnt26        LIKE lnt_file.lnt26
 DEFINE l_year         LIKE type_file.num5
 DEFINE l_month        LIKE type_file.num5
 DEFINE l_day          LIKE type_file.num5
 DEFINE l_lnt01        LIKE lnt_file.lnt01
      
   CASE g_luo.luo03
      WHEN '1'
         LET g_sql = " SELECT lul01,lul02,lul05,lul06,lul07,lul08",
                     "   FROM lul_file,luk_file",
                     "  WHERE luk01 = lul01 ",
                     "    AND lul06-lul07-lul08>0 "
         IF NOT cl_null(g_luo.luo04) THEN
            LET g_sql = g_sql CLIPPED,"    AND lul01 = '",g_luo.luo04,"'"
         ELSE
            IF NOT cl_null(g_luo.luo05) THEN
               LET g_sql = g_sql CLIPPED,"    AND luk06 = '",g_luo.luo05,"'"
            END IF
            IF NOT cl_null(g_luo.luo06) THEN
               LET g_sql = g_sql CLIPPED,"    AND luk07 = '",g_luo.luo06,"'"
            END IF
            IF NOT cl_null(g_luo.luo07) THEN
               LET g_sql = g_sql CLIPPED,"    AND luk08 = '",g_luo.luo07,"'"
            END IF
         END IF
      WHEN '2'
         LET g_sql = " SELECT lub01,lub02,lub03,lub04t,lub11,lub12 ",
                     "   FROM lub_file,lua_file ",
                     "  WHERE lua01 = lub01 ",
                     "    AND lub13 = 'N'",
                     "    AND lua14 = '1'",
                     "    AND lua15 = 'Y'"
         IF NOT cl_null(g_luo.luo04) THEN
            LET g_sql = g_sql,"AND ((lub04t < 0 AND  lub09 <> '10') OR (lub04t > 0 AND lub09 = '10')) "
            LET g_sql = g_sql CLIPPED,"    AND lub01 = '",g_luo.luo04,"'"
         ELSE
            LET g_sql = g_sql," AND lub04t < 0 AND lub09 <> '10'" 
            IF NOT cl_null(g_luo.luo05) THEN
               LET g_sql = g_sql CLIPPED,"    AND lua06 = '",g_luo.luo05,"'"
            END IF
            IF NOT cl_null(g_luo.luo06) THEN
               LET g_sql = g_sql CLIPPED,"    AND lua07 = '",g_luo.luo06,"'"
            END IF
            IF NOT cl_null(g_luo.luo07) THEN
               LET g_sql = g_sql CLIPPED,"    AND lua04 = '",g_luo.luo07,"'"
            END IF
         END IF
   END CASE
   DECLARE t614_ins_cs CURSOR FROM g_sql
   FOREACH t614_ins_cs INTO l_lub01,l_lub02,l_lub03,l_lub04t,l_lub11,l_lub12
                            #费用单号，项次，费用编号，费用金额，已收金额，清算金额
                            #待抵单号，项次，费用编号，待抵金额，已冲金额，已退金额
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT MAX(lup02)+1 INTO l_lup.lup02
        FROM lup_file
       WHERE lup01 = g_luo.luo01
      IF cl_null(l_lup.lup02) THEN
         LET l_lup.lup02 = 1
      END IF

      LET l_lup.lup01 = g_luo.luo01
      LET l_lup.lup03 = l_lub01
      LET l_lup.lup04 = l_lub02
      LET l_lup.lup05 = l_lub03

      SELECT SUM(lup06) INTO l_lup06 FROM lup_file
       WHERE lup03 = l_lub01
         AND lup04 = l_lub02
      IF cl_null(l_lup06) THEN LET l_lup06 = 0 END IF
      IF g_luo.luo03 = '1' THEN
         LET l_lup.lup06 = l_lub04t-l_lub11-l_lup06
      END IF
      IF g_luo.luo03 = '2' THEN
         SELECT lub09 INTO l_lub09
           FROM lub_file
          WHERE lub01 = l_lub01
            AND lub02 = l_lub02

         SELECT SUM(luj06) INTO l_luj06 FROM luj_file
          WHERE luj03 = l_lub01
            AND luj04 = l_lub02
         IF cl_null(l_luj06) THEN LET l_luj06 = 0 END IF
          
         IF l_lub09 <> '10' THEN 
            LET l_lup.lup06 = l_lub04t-l_lub12-l_luj06+l_lup06
            LET l_lup.lup06 = -l_lup.lup06
         ELSE
            LET l_lup.lup06 = l_lub04t -l_lub12-l_luj06-l_lup06
         END IF 
      END IF
      IF l_lup.lup06 = 0 THEN
         CONTINUE FOREACH
      END IF

      IF NOT t614_chk_llb02('2',g_luo.luo03,l_lub01,l_lub03) THEN
         CONTINUE FOREACH
      END IF

      LET l_lup.lup07 = 0
      LET l_lup.lup08 = 0
      LET l_lup.lupplant = g_luo.luoplant
      LET l_lup.luplegal = g_luo.luolegal

      INSERT INTO lup_file VALUES l_lup.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","lup_file",g_luo.luo01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION
#FUN-C30072--end add--------------------------------------------------------
#FUN-BB0117-----------------------------------------------------------------
#FUN-CB0076-------add------str
FUNCTION t614_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_occ02   LIKE occ_file.occ02,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_oaj05   LIKE oaj_file.oaj05,
       l_amt     LIKE lup_file.lup06,
       sr        RECORD
    luoplant  LIKE luo_file.luoplant,
    luo01     LIKE luo_file.luo01,
    luo07     LIKE luo_file.luo07,
    luo08     LIKE luo_file.luo08,
    luo05     LIKE luo_file.luo05,
    luo02     LIKE luo_file.luo02,
    luo06     LIKE luo_file.luo06,
    luocond   LIKE luo_file.luocond,
    luocont   LIKE luo_file.luocont,
    luoconu   LIKE luo_file.luoconu,
    lup02     LIKE lup_file.lup02,
    lup03     LIKE lup_file.lup03,
    lup04     LIKE lup_file.lup04,
    lup05     LIKE lup_file.lup05,
    lup06     LIKE lup_file.lup06,
    lup07     LIKE lup_file.lup07,
    lup08     LIKE lup_file.lup08,
    lup09     LIKE lup_file.lup09
                 END RECORD
                 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('luoser', 'luogrup') 
     IF cl_null(g_wc) THEN LET g_wc = " luo01 = '",g_luo.luo01,"'" END IF
     LET l_sql = "SELECT luoplant,luo01,luo07,luo08,luo05,luo02,luo06,luocond,luocont,luoconu,",
                 "       lup02,lup03,lup04,lup05,lup06,lup07,lup08,lup09",
                 "  FROM luo_file,lup_file",
                 " WHERE luo01 = lup01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t614_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t614_cs1 CURSOR FOR t614_prepare1

     DISPLAY l_table
     FOREACH t614_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.luoplant
       LET l_occ02 = ' '
       SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = sr.luo05
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.luoconu
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.lup05
       LET l_oaj05 = ' '
       SELECT oaj05 INTO l_oaj05 FROM oaj_file WHERE oaj01 = sr.lup05
       LET l_amt = 0
       IF cl_null(sr.lup06) THEN LET sr.lup06 = 0 END IF 
       IF cl_null(sr.lup07) THEN LET sr.lup07 = 0 END IF 
       IF cl_null(sr.lup08) THEN LET sr.lup08 = 0 END IF 
       LET l_amt = sr.lup06-sr.lup07-sr.lup08
       EXECUTE insert_prep USING sr.*,l_rtz13,l_occ02,l_gen02,l_oaj02,l_oaj05,l_amt
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'luo01,luo02,luo03,luo04,luoplant,luolegal,luo05,luo06,luo07,luo08,luo09,luo10,luo11,luo12,luo13,luomksg,luo15,luoconf,luoconu,luocond,luocont,luo14,luouser,luogrup,luooriu,luomodu,luodate,luoorig,luoacti,luocrat')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lup02,lup03,lup04,lup05,lup06,lup07,lup08,lup09')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3=''
     END IF
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF
     END IF
     CALL t614_grdata()
END FUNCTION

FUNCTION t614_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt614")
       IF handler IS NOT NULL THEN
           START REPORT t614_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY luo01,lup02 "
           DECLARE t614_datacur1 CURSOR FROM l_sql
           FOREACH t614_datacur1 INTO sr1.*
               OUTPUT TO REPORT t614_rep(sr1.*)
           END FOREACH
           FINISH REPORT t614_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t614_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lup06_sum   LIKE lup_file.lup06
    DEFINE l_lup07_sum   LIKE lup_file.lup07
    DEFINE l_lup08_sum   LIKE lup_file.lup08
    DEFINE l_amt_sum     LIKE lup_file.lup06
    DEFINE l_oaj05       STRING   
    DEFINE l_plant       STRING    

    ORDER EXTERNAL BY sr1.luo01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc4
              
        BEFORE GROUP OF sr1.luo01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_oaj05 = cl_gr_getmsg('gre-316',g_lang,sr1.oaj05)
            PRINTX l_oaj05
            PRINTX sr1.*
            LET l_plant = sr1.luoplant,' ',sr1.rtz13
            PRINTX l_plant

        AFTER GROUP OF sr1.luo01
            LET l_lup06_sum = GROUP SUM(sr1.lup06)
            LET l_lup07_sum = GROUP SUM(sr1.lup07)
            LET l_lup08_sum = GROUP SUM(sr1.lup08)
            LET l_amt_sum = GROUP SUM(sr1.amt)
            PRINTX l_lup06_sum
            PRINTX l_lup07_sum
            PRINTX l_lup08_sum
            PRINTX l_amt_sum
            
        ON LAST ROW

END REPORT
#FUN-CB0076-------add------end  
#CHI-C80041---begin
FUNCTION t614_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_luo.luo01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t614_cl USING g_luo.luo01
   IF STATUS THEN
      CALL cl_err("OPEN t614_cl:", STATUS, 1)
      CLOSE t614_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t614_cl INTO g_luo.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luo.luo01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t614_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_luo.luoconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_luo.luoconf)   THEN 
        LET l_chr=g_luo.luoconf
        IF g_luo.luoconf='N' THEN 
            LET g_luo.luoconf='X' 
        ELSE
            LET g_luo.luoconf='N'
        END IF
        UPDATE luo_file
            SET luoconf=g_luo.luoconf,  
                luomodu=g_user,
                luodate=g_today
            WHERE luo01=g_luo.luo01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","luo_file",g_luo.luo01,"",SQLCA.sqlcode,"","",1)  
            LET g_luo.luoconf=l_chr 
        END IF
        DISPLAY BY NAME g_luo.luoconf
   END IF
 
   CLOSE t614_cl
   COMMIT WORK
   CALL cl_flow_notify(g_luo.luo01,'V')
 
END FUNCTION
#CHI-C80041---end

