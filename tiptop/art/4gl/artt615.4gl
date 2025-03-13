# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt615.4gl
# Descriptions...: 費用退款單維護作業
# Date & Author..: NO.FUN-BB0117 11/11/24 By fanbj
# Modify.........: No:FUN-BB0117 11/12/06 By baogc 退款邏輯
# Modify.........: No:FUN-BB0117 11/12/21 By shi 重新整理

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20020 12/02/10 By lujh 添加“拋轉財務”按鈕
# Modify.........: No:FUN-C20079 12/02/14 By xumeimei 客戶簡稱從occ_file表中抓取
# Modify.........: No:FUN-C20120 12/02/27 By nanbing 增加财务单号 luc28
# Modify.........: No:TQC-C20430 12/02/28 By lutingting 拋轉財務后重新show畫面
# Modify.........: No:TQC-C30027 12/03/02 By shiwuying 未退款不可审核
# Modify.........: No:TQC-C30188 12/03/14 By zhangweib 修改拋轉財務cl_cmdrun參數
# Modify.........: No:FUN-C30029 12/03/19 By lujh 添加拋轉財務還原按鈕
# Modify.........: No:TQC-C40008 12/04/05 By suncx 已拋轉財務的資料不可取消審核
# Modify.........: No:FUN-C30072 12/04/18 By fanbj 處理費用類型為支出類型的退款
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.FUN-CB0076 12/11/15 By xumeimei 添加GR打印功能
# Modify.........: No:CHI-C80041 13/01/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20015 13/03/26 By minpp 审核人员，审核日期改为审核异动人员，审核异动日期，取消审核赋值
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_luc         RECORD     LIKE luc_file.*,
       g_luc_t       RECORD     LIKE luc_file.*,
       g_luc_o       RECORD     LIKE luc_file.*,
       g_luc01_t                LIKE luc_file.luc01,
       g_luc01                  LIKE luc_file.luc01
       

DEFINE g_lud                 DYNAMIC ARRAY OF RECORD
          lud02                 LIKE lud_file.lud02,     #项次
          lud03                 LIKE lud_file.lud03,     #来源单号
          lud04                 LIKE lud_file.lud04,     #来源项次
          lud05                 LIKE lud_file.lud05,     #费用编号
          oaj02                 LIKE oaj_file.oaj02,     #费用名称
          oaj05                 LIKE oaj_file.oaj05,     #费用类型
          amt                   LIKE lud_file.lud07t,    #支出金额
          amt1                  LIKE lud_file.lud07t,    #支出未退
          lud07t                LIKE lud_file.lud07t,    #退款金额
          oaj04                 LIKE oaj_file.oaj04,     #会计科目
          aag02                 LIKE aag_file.aag02,     #科目名称
          oaj041                LIKE oaj_file.oaj041,    #会计科目二
          aag02_1               LIKE aag_file.aag02,     #科目名称
          lud06                 LIKE lud_file.lud06,     #账款单号
          lud10                 LIKE lud_file.lud10      #待抵单号   
                             END RECORD,

       g_lud_t               RECORD
          lud02                 LIKE lud_file.lud02,
          lud03                 LIKE lud_file.lud03,
          lud04                 LIKE lud_file.lud04,
          lud05                 LIKE lud_file.lud05,
          oaj02                 LIKE oaj_file.oaj02,
          oaj05                 LIKE oaj_file.oaj05,
          amt                   LIKE lud_file.lud07t,
          amt1                  LIKE lud_file.lud07t,
          lud07t                LIKE lud_file.lud07t,
          oaj04                 LIKE oaj_file.oaj04,
          aag02                 LIKE aag_file.aag02,
          oaj041                LIKE oaj_file.oaj041,
          aag02_1               LIKE aag_file.aag02,
          lud06                 LIKE lud_file.lud06,
          lud10                 LIKE lud_file.lud10       
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
DEFINE g_argv1                  LIKE type_file.chr1
DEFINE g_argv2                  LIKE luc_file.luc01
DEFINE g_luk01                  LIKE luk_file.luk01
DEFINE g_dd                     LIKE luk_file.luk02
DEFINE g_t1                     LIKE oay_file.oayslip
#FUN-CB0076----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lucplant  LIKE luc_file.lucplant,
    luc01     LIKE luc_file.luc01,
    luc04     LIKE luc_file.luc04,
    luc03     LIKE luc_file.luc03,
    luc07     LIKE luc_file.luc07,
    luc05     LIKE luc_file.luc05,
    luc16     LIKE luc_file.luc16,
    luc15     LIKE luc_file.luc15,
    luccont   LIKE luc_file.luccont,
    lud02     LIKE lud_file.lud02,
    lud03     LIKE lud_file.lud03,
    lud04     LIKE lud_file.lud04,
    lud05     LIKE lud_file.lud05,
    lud07t    LIKE lud_file.lud07t,
    lud10     LIKE lud_file.lud10,
    rtz13     LIKE rtz_file.rtz13,
    occ02     LIKE occ_file.occ02,
    gen02     LIKE gen_file.gen02,
    oaj02     LIKE oaj_file.oaj02,
    oaj05     LIKE oaj_file.oaj05,
    lup06     LIKE lup_file.lup06,
    lup07     LIKE lup_file.lup07,
    lup08     LIKE lup_file.lup08,
    amt       LIKE lup_file.lup06
END RECORD
#FUN-CB0076----add---end
DEFINE   g_void          LIKE type_file.chr1            #CHI-C80041

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)       #来源类型
   LET g_argv2 = ARG_VAL(2)       #来源单号

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
   LET g_sql ="lucplant.luc_file.lucplant,",
    "luc01.luc_file.luc01,",
    "luc04.luc_file.luc04,",
    "luc03.luc_file.luc03,",
    "luc07.luc_file.luc07,",
    "luc05.luc_file.luc05,",
    "luc16.luc_file.luc16,",
    "luc15.luc_file.luc15,",
    "luccont.luc_file.luccont,",
    "lud02.lud_file.lud02,",
    "lud03.lud_file.lud03,",
    "lud04.lud_file.lud04,",
    "lud05.lud_file.lud05,",
    "lud07t.lud_file.lud07t,",
    "lud10.lud_file.lud10,",
    "rtz13.rtz_file.rtz13,",
    "occ02.occ_file.occ02,",
    "gen02.gen_file.gen02,",
    "oaj02.oaj_file.oaj02,",
    "oaj05.oaj_file.oaj05,",
    "lup06.lup_file.lup06,",
    "lup07.lup_file.lup07,",
    "lup08.lup_file.lup08,",
    "amt.lup_file.lup06"
   LET l_table = cl_prt_temptable('artt615',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end

   LET g_forupd_sql = "SELECT * FROM luc_file WHERE luc01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t615_cl CURSOR FROM g_forupd_sql                 

   OPEN WINDOW t615_w WITH FORM "art/42f/artt615"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL cl_set_comp_visible("oaj041,aag02_1",g_aza.aza63='Y')
   CALL cl_set_comp_visible("lud06",FALSE)    #TQC-C20430
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
      CALL t615_q()
   END IF
  
   CALL t615_menu()
   CLOSE WINDOW t615_w
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN

FUNCTION t615_cs()
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01,
         #l_table      LIKE type_file.chr1000,         #FUN-CB0076 mark
         #l_where      LIKE type_file.chr100           #FUN-CB0076 mark
          l_table      STRING,                         #FUN-CB0076 add
          l_where      STRING                          #FUN-CB0076 add
         
   CLEAR FORM    
   CALL g_lud.clear()

   CALL cl_set_head_visible("","YES")
   INITIALIZE g_luc.* TO NULL
   
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " luc10 = '",g_argv1,"' AND luc11 = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
   ELSE
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON  
                           luc01,luc07,luc21,luc10,luc11,lucplant,luclegal,luc03,
                           luc031,luc05,luc04,luc22,luc23,luc24,luc28,luc25,luc26,luc27,  #FUN-C20120 add luc28
                           luc14,luc15,luc16,luccont,luc08,lucuser,lucgrup,lucoriu,
                           lucmodu,lucdate,lucorig,lucacti,luccrat
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  #退款单号
                  WHEN INFIELD(luc01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc01
                     NEXT FIELD luc01                     
                   
                  #来源单号
                  WHEN INFIELD(luc11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc11"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc11
                     NEXT FIELD luc11  
                           
                  #门店编号
                  WHEN INFIELD(lucplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lucplant"     
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lucplant
                     NEXT FIELD lucplant      
                    
                  #法人
                  WHEN INFIELD(luclegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luclegal"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luclegal
                     NEXT FIELD luclegal

                  #客户编号
                  WHEN INFIELD(luc03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc03"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc03
                     NEXT FIELD luc03

                  #摊位编号
                  WHEN INFIELD(luc05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc05"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc05
                     NEXT FIELD luc05

                  #合同编号
                  WHEN INFIELD(luc04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc04_6"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc04
                     NEXT FIELD luc04

                  #业务人员
                  WHEN INFIELD(luc26)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc26"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc26
                     NEXT FIELD luc26

                  #部门
                  WHEN INFIELD(luc27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luc27"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc27
                     NEXT FIELD luc27

                  #审核人
                  WHEN INFIELD(luc15)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lucconu"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luc15
                     NEXT FIELD luc15

                  OTHERWISE
                     EXIT CASE
               END CASE
         END CONSTRUCT

         CONSTRUCT g_wc2 ON lud02,lud03,lud04,lud05,lud07t,lud06,lud10
              FROM s_lud[1].lud02,s_lud[1].lud03,s_lud[1].lud04,s_lud[1].lud05,
                   s_lud[1].lud07t,s_lud[1].lud06,s_lud[1].lud10   
                       
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
 
            ON ACTION controlp
               CASE
                  #来源单号 
                  WHEN INFIELD(lud03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lud03_2"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lud03
                     NEXT FIELD lud03

                  #费用编号
                  WHEN INFIELD(lud05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_lud05_1"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lud05
                     NEXT FIELD lud05
                     
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

   LET g_sql = "SELECT DISTINCT luc01"
   LET l_table = " FROM luc_file"
   LET l_where = " WHERE ",g_wc

   IF g_wc2 <> " 1=1" THEN 
      LET l_table = l_table,",lud_file"
      LET l_where = l_where," AND lud01 = luc01 AND ",g_wc2
   END IF    

   LET g_sql = g_sql,l_table,l_where," ORDER BY luc01"
   
   PREPARE t615_prepare FROM g_sql
   DECLARE t615_cs SCROLL CURSOR WITH HOLD FOR t615_prepare

   LET g_sql = "SELECT COUNT(DISTINCT luc01) ",l_table,l_where
   PREPARE t615_precount FROM g_sql
   DECLARE t615_count CURSOR FOR t615_precount
END FUNCTION

FUNCTION t615_menu()
   WHILE TRUE
     #Mark Begin ---
     #IF g_action_choice = "exit"  THEN
     #  EXIT WHILE
     #END IF
     #Mark End -----
      
      CALL t615_bp("G")

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t615_a()
            END IF 

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t615_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t615_r()
            END IF

         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t615_out()
            END IF
         #FUN-CB0076------add----end

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t615_u()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t615_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         #审核  
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL t615_confirm()
           END IF

         #取消审核
         WHEN "undo_confirm "
            IF cl_chk_act_auth() THEN
               CALL t615_unconfirm()
            END IF

         #退款   
         WHEN "refund "
            IF cl_chk_act_auth() THEN
               CALL t615_refund()
            END IF

         #退款明细   
         WHEN "refund_details"
            IF cl_chk_act_auth() THEN
              #FUN-BB0117 Add&Mark Begin ---   
              #CALL t615_refund_details()
               IF NOT cl_null(g_luc.luc01) AND g_luc.luc25 = 'N' THEN
                  CALL s_pay_detail('08',g_luc.luc01,g_luc.lucplant,g_luc.luc14)
               END IF
              #FUN-BB0117 ADD&Mark End -----
            END IF           
        
         #待抵查询  
         WHEN "qry_arrived"
           IF cl_chk_act_auth() THEN
              CALL t615_qry_arrived()
           END IF

         #FN-C20020--add--str
         WHEN "spin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               CALL t615_axrp603()
            END IF 
         #FN-C20020--add--end 

         #FUN-C30029--add--str
         WHEN "spin_fin_z"
            IF cl_chk_act_auth() THEN
               CALL t615_axrp607()
            END IF
         #FUN-C30029--add--end
       
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                        base.TypeInfo.create(g_lud),'','')
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_luc.luc01 IS NOT NULL THEN
                  LET g_doc.column1 = "luc01"
                  LET g_doc.value1  = g_luc.luc01
                  CALL cl_doc()
               END IF  
            END IF  
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t615_v()
               IF g_luc.luc14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic(g_luc.luc14,"","","",g_void,"") 
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t615_a()
   DEFINE li_result     LIKE type_file.num5 
   DEFINE l_lnt30       LIKE lnt_file.lnt30
   DEFINE l_tqa02       LIKE tqa_file.tqa02

   MESSAGE ""
   CLEAR FORM   
   CALL g_lud.clear()  

   LET g_wc = NULL 
   LET g_wc2 = NULL 
    
   INITIALIZE g_luc.*    LIKE luc_file.*       
   INITIALIZE g_luc_t.*  LIKE luc_file.*
   INITIALIZE g_luc_o.*  LIKE luc_file.*     
   
   LET g_luc01_t = NULL
   CALL cl_opmsg('a')     
    
   WHILE TRUE
     #IF NOT cl_null(g_argv2) THEN
     #   LET g_luc.luc11 = g_argv2
     #   SELECT luo05,luo06,luo07,luo08
     #     INTO g_luc.luc03,g_luc.luc05,g_luc.luc04,g_luc.luc22
     #     FROM luo_file
     #    WHERE luo01 = g_luc.luc11
     #           
     #   #带出主品牌
     #   SELECT lnt30 INTO l_lnt30
     #     FROM lnt_file
     #    WHERE lnt01 = g_luc.luc04

     #   #带出品牌名称
     #   SELECT tqa02 INTO l_tqa02
     #     FROM tqa_file
     #    WHERE tqa01 = l_lnt30
     #      AND tqa03 = '2'
     #   DISPLAY l_lnt30 TO FORMONLY.lnt30
     #   DISPLAY l_tqa02 TO FORMONLY.tqa02
     #END IF 
      LET g_luc.luc02 ='1'         #商户来源，默认为支出单
      LET g_luc.luc06 = 0          #未税支出总额
      LET g_luc.luc06t = 0         #含税支出总额
      LET g_luc.luc12 = 'N'        #是否签核 
      LET g_luc.luc13 = '0'        #签核状态
      LET g_luc.luc17 = 0          #未税应付金额
      LET g_luc.luc09 = 'N'        #系统自动生成
      LET g_luc.luc17t = 0         #含税应付金额
      LET g_luc.luc182 = 'N'       #含税
      LET g_luc.luc20 = '2'        #客户来源
      LET g_luc.luc23 = 0          #退款金额
      LET g_luc.luc24 = 0          #已退金额
      LET g_luc.luc25 = 'N'        #生成待抵单
      LET g_luc.luc07 = g_today    #单据日期
      LET g_luc.luc21 = g_today    #立账日期
      LET g_luc.luc10 = '1'        #来源作业
      LET g_luc.lucplant = g_plant #门店编号 
      LET g_luc.luclegal = g_legal #法人
      LET g_luc.luc14 = 'N'        #审核码   
      LET g_luc.lucuser = g_user   #资料所有者
      LET g_luc.lucgrup = g_grup   #资料所有群
      LET g_luc.lucdate = g_today  #最近更改日
      LET g_luc.lucacti = 'Y'      #资料有效码
      LET g_luc.luccrat = g_today  #资料创建日
      LET g_luc.lucoriu = g_user   #资料建立者
      LET g_luc.lucorig = g_grup   #资料建立部门
      LET g_luc.luc26 = g_user     #业务人员
      LET g_luc.luc27 = g_grup     #部门
      CALL t615_lucplant('d')
      CALL t615_gen02('d')
      IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
         LET g_luc.luc10 = g_argv1
         LET g_luc.luc11 = g_argv2
         CALL t615_luc11('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            RETURN
         END IF
      END IF
 
      CALL t615_i("a")
   
      IF INT_FLAG THEN  
         LET INT_FLAG = 0
         INITIALIZE g_luc.* TO NULL
         CALL g_lud.clear() 
         LET g_luc01_t = NULL  
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
       
      IF cl_null(g_luc.luc01) OR cl_null(g_luc.lucplant) THEN    
         CONTINUE WHILE
      END IF        
       
      ####自動編號#############################################################
      CALL s_auto_assign_no("art",g_luc.luc01,g_luc.luc07,'C1',"luc_file",
                            "luc01","","","") RETURNING li_result,g_luc.luc01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_luc.luc01
      ########################################################################
      LET g_success = 'Y'
      BEGIN WORK 
      
      INSERT INTO luc_file VALUES(g_luc.*)                   
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","luc_file",g_luc.luc01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK         
         CONTINUE WHILE
      END IF

      CALL g_lud.clear()
      LET g_rec_b = 0

      #带出单身 
      IF NOT cl_confirm("alm1302") THEN 
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CONTINUE WHILE
         ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_luc.luc01,'I')
            CALL t615_b_fill(" 1=1")
            CALL t615_b()
         END IF
      ELSE 
         CALL t615_inslud()   #根据来源类型带出相应的单身
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CONTINUE WHILE
         ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_luc.luc01,'I')
            CALL t615_b_fill(" 1=1")
            CALL t615_b()
         END IF
      END IF   
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t615_i(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1, 
            l_cnt      LIKE type_file.num5, 
            l_count    LIKE type_file.num5, 
            li_result  LIKE type_file.num5,
            l_sma53      LIKE sma_file.sma53
            
   DISPLAY BY NAME g_luc.luc07,g_luc.luc21,g_luc.luc10,g_luc.lucplant,
                   g_luc.luclegal,g_luc.luc14,g_luc.lucuser,g_luc.lucgrup,
                   g_luc.lucdate,g_luc.lucacti,g_luc.luccrat,g_luc.lucoriu,
                   g_luc.lucorig       
              
   INPUT BY NAME g_luc.luc01,g_luc.luc07,g_luc.luc21,g_luc.luc10,g_luc.luc11,
                 g_luc.lucplant,g_luc.luclegal,g_luc.luc03,g_luc.luc031,
                 g_luc.luc05,g_luc.luc04,g_luc.luc22,g_luc.luc23,g_luc.luc24,
                 g_luc.luc25,g_luc.luc26,g_luc.luc27,g_luc.luc14,g_luc.luc15,
                 g_luc.luc16,g_luc.luccont,g_luc.luc08,g_luc.lucuser,
                 g_luc.lucgrup,g_luc.lucoriu,g_luc.lucmodu,g_luc.lucdate,
                 g_luc.lucorig,g_luc.lucacti,g_luc.luccrat
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          CALL t615_set_entry(p_cmd)        
          CALL t615_set_no_entry(p_cmd)  
          CALL t615_set_no_entry_luc11(p_cmd)
          CALL t615_set_no_entry_luc04(p_cmd)
          LET g_before_input_done = TRUE
          
      AFTER FIELD luc01 
         IF NOT cl_null(g_luc.luc01) THEN
            CALL s_check_no("art",g_luc.luc01,g_luc01_t,'C1',"luc_file",
                           "luc01","") RETURNING li_result,g_luc.luc01
            IF (NOT li_result) THEN
               LET g_luc.luc01=g_luc_t.luc01
               NEXT FIELD luc01
            END IF
         END IF           
 
     #AFTER FIELD luc07 #单据日期
     #   IF NOT cl_null(g_luc.luc07) THEN
     #      SELECT sma53 INTO l_sma53
     #        FROM sma_file
     #       WHERE sma00 = '0' 

     #      IF g_luc.luc07 < l_sma53 THEN
     #         CALL cl_err('','alm1203',0)
     #         LET g_luc.luc07 = g_luc_t.luc07
     #         DISPLAY g_luc.luc07
     #         NEXT FIELD luc07
     #      END IF  
     #   END IF 
      
      AFTER FIELD luc21 #立账日期
         IF NOT cl_null(g_luc.luc21) THEN 
            IF g_luc.luc21 <= g_ooz.ooz09 THEN
               CALL cl_err('','alm1276',0)
               LET g_luc.luc21 = g_ooz.ooz09 +1
               DISPLAY g_luc.luc21
            END IF  
         END IF 
      
      AFTER FIELD luc11 #来源单号
         IF NOT cl_null(g_luc.luc11) THEN
            IF cl_null(g_luc_t.luc11) OR (p_cmd = 'u' AND g_luc.luc11 <> g_luc_t.luc11) THEN
               CALL t615_luc11(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_luc.luc11 = g_luc_t.luc11
                  DISPLAY BY NAME g_luc.luc11
                  NEXT FIELD luc11 
               END IF
            END IF
         END IF
         CALL t615_set_no_entry_luc11(p_cmd)
         CALL t615_set_no_entry_luc04(p_cmd)

      AFTER FIELD luc03 #客户编号
         IF NOT cl_null(g_luc.luc03) THEN 
            IF cl_null(g_luc.luc11) THEN 
               CALL t615_luc03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_luc.luc03 = g_luc_t.luc03
                  DISPLAY BY NAME g_luc.luc03
                  NEXT FIELD luc03 
               END IF 
            END IF 
         END IF  

      AFTER FIELD luc05 #摊位编号
         IF NOT cl_null(g_luc.luc05) THEN 
            CALL t615_luc05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_luc.luc05 = g_luc_t.luc05
               DISPLAY BY NAME g_luc.luc05
               NEXT FIELD luc05 
            END IF 
         END IF            

      AFTER FIELD luc04 #合同编号
         IF NOT cl_null(g_luc.luc04) THEN
            CALL t615_luc04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_luc.luc04 = g_luc_t.luc04
               DISPLAY BY NAME g_luc.luc04
               NEXT FIELD luc04 
            END IF 
         END IF
         CALL t615_set_no_entry_luc04(p_cmd)

      AFTER FIELD luc26 
         IF NOT cl_null(g_luc.luc26) THEN
            CALL t615_gen02(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_luc.luc26 = g_luc_t.luc26
               DISPLAY BY NAME g_luc.luc26
               NEXT FIELD luc26
            END IF 
         END IF

      AFTER FIELD luc27 
         IF NOT cl_null(g_luc.luc27) THEN
            CALL t615_gem02(p_cmd) 
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0) 
               LET g_luc.luc27 = g_luc_t.luc27
               DISPLAY BY NAME g_luc.luc27
               NEXT FIELD luc27
            END IF 
         END IF   
 
      AFTER INPUT
         LET g_luc.lucuser = s_get_data_owner("luc_file") #FUN-C10039
         LET g_luc.lucgrup = s_get_data_group("luc_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF 
         
      ON ACTION CONTROLP
         CASE
            #支出单号 
            WHEN INFIELD(luc01)
               LET g_kindslip = s_get_doc_no(g_luc.luc01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'C1','ART') RETURNING g_kindslip
               LET g_luc.luc01 = g_kindslip
               DISPLAY BY NAME g_luc.luc01
               NEXT FIELD luc01
         
            #来源类型  
            WHEN INFIELD(luc11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_luc11_1"
               LET g_qryparam.default1 = g_luc.luc11
               CALL cl_create_qry() RETURNING g_luc.luc11
               DISPLAY BY NAME g_luc.luc11
               NEXT FIELD luc11

            #客户编号
            WHEN INFIELD(luc03)
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_luc03_1"   #FUN-C20079 mark
               LET g_qryparam.form = "q_occ"        #FUN-C20079 add
               LET g_qryparam.default1 = g_luc.luc03
               CALL cl_create_qry() RETURNING g_luc.luc03
               DISPLAY BY NAME g_luc.luc03
               NEXT FIELD luc03

            #摊位编号
            WHEN INFIELD(luc05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_luc05_1"
               LET g_qryparam.default1 = g_luc.luc05
               CALL cl_create_qry() RETURNING g_luc.luc05
               DISPLAY BY NAME g_luc.luc05
               NEXT FIELD luc05

            #合同编号
            WHEN INFIELD(luc04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_luc04_5"
               LET g_qryparam.default1 = g_luc.luc04
               CALL cl_create_qry() RETURNING g_luc.luc04
               DISPLAY BY NAME g_luc.luc04
               NEXT FIELD luc04

            #业务人员
            WHEN INFIELD(luc26)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen02"  
               LET g_qryparam.default1 = g_luc.luc26
               CALL cl_create_qry() RETURNING g_luc.luc26
               DISPLAY BY NAME g_luc.luc26
               NEXT FIELD luc26
            
            #部门
            WHEN INFIELD(luc27)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_luc.luc27
               CALL cl_create_qry() RETURNING g_luc.luc27
               DISPLAY BY NAME g_luc.luc27
               NEXT FIELD luc27 
           
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
 
FUNCTION t615_q()
   LET  g_row_count = 0
   LET  g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   INITIALIZE g_luc.* TO NULL
   INITIALIZE g_luc_t.* TO NULL
   INITIALIZE g_luc_o.* TO NULL
   
   LET g_luc01_t = NULL
   LET g_wc = NULL
   
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '' TO FORMONLY.cnt
   
   CALL t615_cs()  
         
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_luc.* TO NULL
      LET g_rec_b = 0 
      CALL g_lud.clear()      
      LET g_luc01_t = NULL
      LET g_wc = NULL
      LET g_wc2 = NULL 
      RETURN
   END IF
   
   OPEN t615_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_luc.* TO NULL
      LET g_wc = NULL
      LET g_luc01_t = NULL
   ELSE
      OPEN t615_count
      FETCH t615_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t615_fetch('F')
   END IF
END FUNCTION
 
FUNCTION t615_fetch(p_flag)
   DEFINE p_flag LIKE type_file.chr1 
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     t615_cs INTO g_luc.luc01
       WHEN 'P' FETCH PREVIOUS t615_cs INTO g_luc.luc01
       WHEN 'F' FETCH FIRST    t615_cs INTO g_luc.luc01
       WHEN 'L' FETCH LAST     t615_cs INTO g_luc.luc01
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
           FETCH ABSOLUTE g_jump t615_cs INTO g_luc.luc01
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
      INITIALIZE g_luc.* TO NULL
      LET g_luc01_t = NULL
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
 
   SELECT * INTO g_luc.* 
     FROM luc_file  
    WHERE luc01 = g_luc.luc01

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_luc.lucuser 
      LET g_data_group = g_luc.lucgrup
      CALL t615_show() 
   END IF
END FUNCTION
 
FUNCTION t615_show()
   DEFINE l_gen02     LIKE gen_file.gen02,
          l_lnt30     LIKE lnt_file.lnt30,
          l_tqa02     LIKE tqa_file.tqa02
 
    LET g_luc_t.* = g_luc.*
    LET g_luc_o.* = g_luc.*
    DISPLAY BY NAME g_luc.luc01,g_luc.luc07,g_luc.luc21,g_luc.luc10,g_luc.luc11,
                    g_luc.lucplant,g_luc.luclegal,g_luc.luc03,g_luc.luc031,
                    g_luc.luc05,g_luc.luc04,g_luc.luc22,g_luc.luc23,g_luc.luc24,
                    g_luc.luc25,g_luc.luc26,g_luc.luc27,g_luc.luc14,g_luc.luc15,
                    g_luc.luc16,g_luc.luccont,g_luc.luc08,g_luc.lucuser,
                    g_luc.lucgrup,g_luc.lucoriu,g_luc.lucmodu,g_luc.lucdate,
                    g_luc.lucorig,g_luc.lucacti,g_luc.luccrat,g_luc.luc28 #FUN-C20120 add g_luc.luc28

   #带出审核人名称
   SELECT gen02 INTO l_gen02
     FROM gen_file
    WHERE gen01 = g_luc.luc15
   DISPLAY l_gen02 TO FORMONLY.gen02_1
   
   #带出主品牌
   IF NOT cl_null(g_luc.luc04) THEN
      SELECT lnt30 INTO l_lnt30
        FROM lnt_file
       WHERE lnt01 = g_luc.luc04
   ELSE
      SELECT lne08 INTO l_lnt30
        FROM lne_file
       WHERE lne01 = g_luc.luc03
   END IF

   #带出品牌名称
   SELECT tqa02 INTO l_tqa02
     FROM tqa_file
    WHERE tqa01 = l_lnt30
      AND tqa03 = '2'
   DISPLAY l_lnt30 TO FORMONLY.lnt30
   DISPLAY l_tqa02 TO FORMONLY.tqa02

   CALL cl_show_fld_cont()
   CALL t615_gen02('d')  #带出业务人员名称
   CALL t615_gem02('d')  #带出部门名称
   CALL t615_lucplant('d')  #门店名称
   CALL t615_b_fill(g_wc2)  
   CALL t615_upd()          #汇总单身金额显示到单头
   #CALL cl_set_field_pic(g_luc.luc14,"","","","","")  #CHI-C80041
   IF g_luc.luc14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_luc.luc14,"","","",g_void,"")  #CHI-C80041
END FUNCTION

FUNCTION t615_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lud TO s_lud.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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

   #退款   
   ON ACTION refund
      LET g_action_choice="refund"
      LET l_ac=1
      EXIT DISPLAY
      
   #退款明细
   ON ACTION refund_details
      LET g_action_choice="refund_details"
      LET l_ac=1
      EXIT DISPLAY

   ON ACTION confirm
      LET g_action_choice="confirm"
      EXIT DISPLAY

   ON ACTION undo_confirm
      LET g_action_choice="undo_confirm"
      EXIT DISPLAY 
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
   ON ACTION first
      CALL t615_fetch('F')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION previous
      CALL t615_fetch('P')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION jump
      CALL t615_fetch('/')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION next
      CALL t615_fetch('N')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION last
      CALL t615_fetch('L')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
      ACCEPT DISPLAY

   ON ACTION detail
      LET g_action_choice="detail"
      LET l_ac=1
      EXIT DISPLAY

   ##退款   
   #ON ACTION refund
   #   LET g_action_choice="refund"
   #   LET l_ac=1
   #   EXIT DISPLAY

   ##退款明细   
   #ON ACTION refund_details
   #   LET g_action_choice="refund_details"
   #   LET l_ac=1
   #   EXIT DISPLAY

   #待抵查询
   ON ACTION qry_arrived
      LET g_action_choice="qry_arrived"
      EXIT DISPLAY   

   #---------FUN-C20020--add--str
   ON ACTION spin_fin
      LET g_action_choice = "spin_fin"
      EXIT DISPLAY
   #---------FUN-C20020--add-end

   #---FUN-C30029--add--str
   ON ACTION spin_fin_z
      LET g_action_choice = "spin_fin_z"
      EXIT DISPLAY
   #---FUN-C30029--add--end

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
 
FUNCTION t615_u()
   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
    
   SELECT * INTO g_luc.* 
     FROM luc_file 
    WHERE luc01  = g_luc.luc01
  
   IF g_luc.luc14 = 'Y' THEN
      CALL cl_err(g_luc.luc01,'alm-027',1)
      RETURN
   END IF 
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_luc.luc24 <> 0 AND NOT cl_null(g_luc.luc24) THEN 
      CALL cl_err(g_luc.luc01,'alm1370',0)
      RETURN 
   END IF 

   #终止结算产生的退款单不可以修改
   IF g_luc.luc10 = '2' THEN
      CALL cl_err('','alm1355',0)
      RETURN
   END IF    
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_luc01_t = g_luc.luc01
    
   BEGIN WORK
 
   OPEN t615_cl USING g_luc.luc01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:",STATUS,1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   FETCH t615_cl INTO g_luc.*  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   ###############
   LET g_date = g_luc.lucdate
   LET g_modu = g_luc.lucmodu
   ############### 
   
   LET g_luc.lucmodu = g_user  
   LET g_luc.lucdate = g_today  
  
   CALL t615_show()    
    
   WHILE TRUE
      CALL t615_i('u')  
        
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         ###############
         LET g_luc_t.lucdate = g_date
         LET g_luc_t.lucmodu = g_modu
         ###############
         LET g_luc.*=g_luc_t.*
         CALL t615_show()
         CALL cl_err('',9001,0)        
         EXIT WHILE
      END IF
      
      IF g_luc.luc01 != g_luc01_t THEN
         UPDATE lud_file
            SET lud01 = g_luc.luc01
          WHERE lud01 = g_luc01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lud_file",g_luc01_t,
                  "",SQLCA.sqlcode,"","lud",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE luc_file 
         SET luc_file.* = g_luc.* 
       WHERE luc01 = g_luc01_t
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t615_cl
   COMMIT WORK

   SELECT * INTO g_luc.*
    FROM luc_file
   WHERE luc01=g_luc.luc01
    
   CALL t615_show()
   CALL cl_flow_notify(g_luc.luc01,'U')
   CALL t615_b_fill("1=1")
   CALL t615_bp_refresh()
END FUNCTION
 
FUNCTION t615_r()
   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_luc.luc14 = 'Y' THEN 
      CALL cl_err(g_luc.luc01,'alm-028',1)
      RETURN
   END IF
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
  ##终止结算产生的待抵单不可以删除
  #IF g_luc.luc10 = '2' THEN
  #   CALL cl_err('','alm1355',0)
  #   RETURN
  #END IF   
     
   LET g_success='Y'

   BEGIN WORK
 
   OPEN t615_cl USING g_luc.luc01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:",STATUS,0)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t615_cl INTO g_luc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   CALL t615_show()
    
   IF cl_delh(0,0) THEN                 
      INITIALIZE g_doc.* TO NULL         
      LET g_doc.column1 = "luc01"         
      LET g_doc.value1 = g_luc.luc01      
      CALL cl_del_doc()                                         
        
      DELETE FROM luc_file 
       WHERE luc01 = g_luc_t.luc01

      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","luc_file",g_luc.luc01,"",SQLCA.SQLCODE,
                       "","(t615_r:delete luc)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM lud_file
       WHERE lud01 =g_luc_t.luc01

      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lud_file",g_luc.luc01,"",
                      SQLCA.SQLCODE,"","(t615_r:delete lud)",1)
         LET g_success='N'
      END IF

      DELETE FROM rxy_file
       WHERE rxy01 = g_luc.luc01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rxy_file",g_luc.luc01,"",
                      SQLCA.SQLCODE,"","(t615_r:delete lud)",1)
         LET g_success='N'
      END IF 

      DELETE FROM rxz_file
       WHERE rxz01 = g_luc.luc01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rxz_file",g_luc.luc01,"",
                      SQLCA.SQLCODE,"","(t615_r:delete lud)",1)
         LET g_success='N'
      END IF 

      DELETE FROM rxx_file
       WHERE rxx01 = g_luc.luc01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rxx_file",g_luc.luc01,"",
                      SQLCA.SQLCODE,"","(t615_r:delete lud)",1)
         LET g_success='N'
      END IF 

      INITIALIZE g_luc.* TO NULL

      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM

         CALL g_lud.clear()
         OPEN t615_count
         IF STATUS THEN
            CLOSE t615_cs
            CLOSE t615_count
            COMMIT WORK
            RETURN
         END IF

         FETCH t615_count INTO g_row_count

         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t615_cs
            CLOSE t615_count
            COMMIT WORK
            RETURN
         END IF

         DISPLAY g_row_count TO FORMONLY.cnt

         OPEN t615_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t615_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t615_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_luc.* = g_luc_t.*
      END IF
   END IF

   CLOSE t615_cl
   COMMIT WORK
END FUNCTION

##审核
#FUNCTION t615_confirm()
#   DEFINE l_luc15        LIKE luc_file.luc15,
#          l_luc16        LIKE luc_file.luc16,
#          l_lua14        LIKE lua_file.lua14,
#          l_n            LIKE type_file.num5,
#          l_gen02_1      LIKE gen_file.gen02, 
#          l_luccont      LIKE luc_file.luccont,
#          l_cnt          LIKE type_file.num5,
#          l_lup06        LIKE lup_file.lup06,
#          l_lup07        LIKE lup_file.lup07,
#          l_lup03        LIKE lup_file.lup03,
#          l_lup04        LIKE lup_file.lup04,
#          l_lup08        LIKE lup_file.lup08,
#          l_amt          LIKE lup_file.lup06,
#          l_lud03        LIKE lud_file.lud03,
#          l_lud04        LIKE lud_file.lud04,
#          l_lud07t       LIKE lud_file.lud07t,
#          l_lul03        LIKE lul_file.lul03,
#          l_lul04        LIKE lul_file.lul04,
#          l_lul08        LIKE lul_file.lul08,
#          l_lub11        LIKE lub_file.lub11,
#          l_lub12        LIKE lub_file.lub12,
#          l_lub04t       LIKE lub_file.lub04t,
#          l_lus06        LIKE lus_file.lus06,
#          l_luo09        LIKE luo_file.luo09,
#          l_luo10        LIKE luo_file.luo10,
#          l_luo11        LIKE luo_file.luo11,
#          l_luo03        LIKE luo_file.luo03,
#          l_lua35        LIKE lua_file.lua35,
#          l_luk12        LIKE luk_file.luk12,
#          l_luq10        LIKE luq_file.luq10,
#          l_sql          STRING,
#          l_sql1         STRING  
#          
#   IF cl_null(g_luc.luc01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#   
#   IF g_luc.luc14 = 'Y' THEN
#      CALL cl_err(g_luc.luc01,'alm-005',1)
#      RETURN
#   END IF
#   
#   SELECT * INTO g_luc.* 
#     FROM luc_file
#    WHERE luc01 = g_luc.luc01
#
#   IF g_luc.luc25 = 'N' THEN
#      IF cl_null(g_luc.luc24) OR g_luc.luc24 = 0 THEN
#         CALL cl_err('','alm1374',0)
#         RETURN 
#      END IF  
#   END IF  
#
#   LET l_luc15 = g_luc.luc15
#   LET l_luc16 = g_luc.luc16
#   LET l_luccont = g_luc.luccont
#
#   LET l_sql = "SELECT lud03,lud04,lud07t",
#               "  FROM lud_file" ,
#               " WHERE lud01 = '",g_luc.luc01,"'"
#               
#   DECLARE t615_chk_cs CURSOR FROM l_sql 
#   
#   LET g_success = 'Y'
#
#   BEGIN WORK 
#   OPEN t615_cl USING g_luc.luc01
#   IF STATUS THEN 
#      CALL cl_err("open t615_cl:",STATUS,1)
#      CLOSE t615_cl
#      ROLLBACK WORK 
#      RETURN 
#   END IF 
#    
#   FETCH t615_cl INTO g_luc.*
#   IF SQLCA.sqlcode  THEN 
#      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
#      CLOSE t615_cl
#      ROLLBACK WORK
#      RETURN 
#   END IF    
#  
#   IF NOT cl_confirm("alm-006") THEN
#       RETURN
#   ELSE
#      LET l_cnt = 1
#
#      CASE g_luc.luc10
#         #来源类型是支出单更新支出单单身对应项次的已退金额,以及单头的已退金额，
#         #如果支出单来源类型是待抵单,还要更新待抵单单身以及单头的已退金额,如果
#         #支出单来源类型是费用单需要跟新费用单对应的单身以及单头的已收金额,同时
#         #判断费用单的单身是否结案,再判断单头是否可以结案,合同是否可以结案
#         WHEN '1'
#            FOREACH t615_chk_cs INTO l_lud03,l_lud04,l_lud07t
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF  
#                
#               IF cl_null(l_lud07t) THEN
#                  LET l_lud07t = 0 
#               END IF   
# 
#               SELECT luo09,luo10,luo03,luo11 
#                 INTO l_luo09,l_luo10,l_luo03,l_luo11 
#                 FROM luo_file 
#                WHERE luo01 = l_lud03
#                
#               UPDATE luo_file 
#                  SET luo10 = l_luo10 + l_lud07t
#                WHERE luo01 = l_lud03
#
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","luo_file",l_lud03,"",
#                                               SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF       
#
#               SELECT lup07,lup03,lup04 INTO l_lup07,l_lup03,l_lup04
#                 FROM lup_file
#                WHERE lup01 = l_lud03
#                  AND lup02 = l_lud04
#
#               IF cl_null(l_lup07) THEN
#                  LET l_lup07 = 0
#               END IF    
#
#               UPDATE lup_file
#                  SET lup07 = l_lup07 + l_lud07t
#                WHERE lup01 = l_lud03
#                  AND lup02 = l_lud04
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","lup_file",l_lud03,"",
#                                               SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF       
#
#               SELECT luo09,luo10,luo11 INTO l_luo09,l_luo10,l_luo11
#                 FROM luo_file
#                WHERE luo01 = l_lud03
#               IF cl_null(l_luo09) THEN
#                  LET l_luo09 = 0
#               END IF 
#               
#               IF cl_null(l_luo10) THEN
#                  LET l_luo10 = 0
#               END IF
#
#               IF cl_null(l_luo11) THEN
#                  LET l_luo11 = 0
#               END IF
#
#               IF l_luo09 - l_luo10 - l_luo11 = 0 THEN
#                  UPDATE luo_file
#                     SET luo15 = '2'
#                   WHERE luo01 = l_lud03
#                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                     CALL cl_err3("upd","luo_file",l_lud03,"",
#                                               SQLCA.sqlcode,"","",1)
#                     LET g_success = 'N'
#                     RETURN
#                  END IF 
#               END IF 
#            
#               CASE l_luo03
#                  #更新待抵单已退金额
#                  WHEN '1'                  
#                     SELECT lul08 INTO l_lul08
#                       FROM lul_file
#                      WHERE lul01 = l_lup03
#                        AND lul02 = l_lup04
#
#                     IF cl_null(l_lul08) THEN 
#                        LET l_lul08 = 0 
#                     END IF 
#                        
#                     UPDATE lul_file
#                        SET lul08 = l_lul08 + l_lud07t
#                      WHERE lul01 = l_lup03
#                        AND lul02 = l_lup04
#
#                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                        CALL cl_err3("upd","lul_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                        LET g_success = 'N'
#                        RETURN
#                     END IF   
#
#                     SELECT luk12 INTO l_luk12
#                       FROM luk_file
#                      WHERE luk01 = l_lup03
#
#                     IF cl_null(l_luk12) THEN 
#                        LET l_luk12 = 0    
#                     END IF  
#
#                     UPDATE luk_file
#                        SET luk12 = l_luk12 + l_lud07t
#                      WHERE luk01 = l_lup03
#
#                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                        CALL cl_err3("upd","luk_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                        LET g_success = 'N'
#                        RETURN
#                     END IF  
#                        
#                  #更新费用单已收金额
#                  WHEN '2'
#                     SELECT lub11 INTO l_lub11
#                       FROM lub_file
#                      WHERE lub01 = l_lup03
#                        AND lub02 = l_lup04
#
#                    SELECT lua35 INTO l_lua35
#                      FROM lua_file
#                     WHERE lua01 = l_lup03
#
#                    IF cl_null(l_lua35) THEN
#                       LET l_lua35 = 0
#                    END IF   
#
#                    IF cl_null(l_lub11) THEN
#                       LET l_lub11 = 0
#                    END IF   
#
#                    UPDATE lub_file 
#                       SET lub11 = l_lub11 - l_lud07t     
#                     WHERE lub01 = l_lup03
#                       AND lub02 = l_lup04
#
#                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                       CALL cl_err3("upd","lub_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                       LET g_success = 'N'
#                       RETURN
#                    END IF
# 
#                    UPDATE lua_file
#                       SET lua35 = l_lua35 - l_lud07t
#                     WHERE lua01 = l_lup03
#
#                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                       CALL cl_err3("upd","lua_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                       LET g_success = 'N'
#                       RETURN
#                    END IF
#                     
#                    SELECT lub11,lub12,lub04t INTO l_lub11,l_lub12,l_lub04t
#                      FROM lub_file
#                     WHERE lub01 = l_lup03
#                       AND lub02 = l_lup04
#
#                    IF cl_null(l_lub11) THEN
#                       LET l_lub11 = 0
#                    END IF 
#
#                    IF cl_null(l_lub12) THEN
#                       LET l_lub12 = 0
#                    END IF 
#
#                    IF cl_null(l_lub04t) THEN
#                       LET l_lub04t = 0
#                    END IF 
#                    
#                    #费用单单身的未收金额为0 ，单身结案
#                    IF l_lub04t - l_lub11 - l_lub12 = 0 THEN 
#                       UPDATE lub_file 
#                          SET lub13 = 'Y'
#                        WHERE lub01 = l_lup03
#                          AND lub02 = l_lup04
#
#                       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                          CALL cl_err3("upd","lub_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                          LET g_success = 'N'
#                          RETURN
#                       END IF
#
#                       SELECT COUNT(*) INTO l_n 
#                         FROM lub_file 
#                        WHERE lub01 = l_lup03
#                          AND lub13 = 'N'
#
#                       #该费用单对应的单身都结案,费用单结案,同时更新对应的合同账单结案,回写已收金额
#                       IF l_n = 0 THEN 
#                          UPDATE lua_file
#                             SET lua14 = '2'
#                           WHERE lua01 = l_lup03
#
#                          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                             CALL cl_err3("upd","lua_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                             LET g_success = 'N'
#                             RETURN
#                          END IF  
#
#                       END IF 
#
#                    END IF
#                    
#                    SELECT liw14 INTO l_lub11
#                      FROM liw_file
#                     WHERE liw16 = l_lup03
#                       AND liw18 = l_lup04
#
#                    UPDATE liw_file
#                       SET liw14 = l_lub11 - l_lud07t
#                     WHERE liw16 = l_lup03
#                       AND liw18 = l_lup04
#
#                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                       CALL cl_err3("upd","liw_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                       LET g_success = 'N'
#                       RETURN
#                    END IF                    
#
#                    SELECT liw13,liw14,liw15 INTO l_lub04t,l_lub11,l_lub12
#                      FROM liw_file
#                     WHERE liw16 = l_lup03
#                       AND liw18 = l_lup04
#
#                    IF cl_null(l_lub04t) THEN LET l_lub04t = 0 END IF 
#                    IF cl_null(l_lub11) THEN LET l_lub11 = 0 END IF 
#                    IF cl_null(l_lub12) THEN LET l_lub12 = 0 END IF
#   
#                    IF l_lub04t - l_lub11 - l_lub12 = 0 THEN
#                       UPDATE liw_file 
#                          SET liw17 = 'Y'
#                        WHERE liw16 = l_lup03
#                          AND liw18 = l_lup04
# 
#                       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                             CALL cl_err3("upd","liw_file",l_lup03,"",
#                                               SQLCA.sqlcode,"","",1)
#                             LET g_success = 'N'
#                             RETURN
#                       END IF
#                    END IF  
#               END CASE 
#            END FOREACH
#         
#         #来源类型是终止结算，同步更新终止结算对应单身的已退金额，
#         #和单头的已退金额
#         WHEN '2'     
#            FOREACH t615_chk_cs INTO l_lud03,l_lud04,l_lud07t
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                  EXIT FOREACH
#               END IF  
#  
#               SELECT lus06 INTO l_lus06 
#                 FROM lus_file 
#                WHERE lus01 = l_lud03
#                  AND lus02 = l_lud04 
#  
#               UPDATE lus_file 
#                  SET lus06 = l_lus06 + l_lud07t
#                WHERE lus01 = l_lud03
#                  AND lus02 = l_lud04
#
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","lus_file",l_lud03,"",
#                                              SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF      
#
#               SELECT luq10 INTO l_luq10
#                 FROM luq_file
#                WHERE luq01 = l_lud03
#
#               IF cl_null(l_luq10) THEN
#                  LET l_luq10 = 0   
#               END IF      
#               
#               UPDATE luq_file
#                  SET luq10 = l_luq10 + l_lud07t
#                 WHERE luq01 = l_lud03
#
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","luq_file",l_lud03,"",
#                                              SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#            END FOREACH
#      END CASE 
#
#      LET g_luc.luc14 = 'Y'
#      LET g_luc.luc15 = g_user
#      LET g_luc.luc16 = g_today
#      LET g_luc.luccont = TIME 
#
#      UPDATE luc_file
#         SET luc14 = g_luc.luc14,
#             luc15 = g_luc.luc15,
#             luc16 = g_luc.luc16,
#             luccont = g_luc.luccont
#        WHERE luc01= g_luc.luc01
#       
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd luc:',SQLCA.SQLCODE,0)
#         LET g_success = 'N'
#         LET g_luc.luc14 = "N"
#         LET g_luc.luc15 = l_luc15
#         LET g_luc.luc16 = l_luc16
#         LET g_luc.luccont = l_luccont
#         DISPLAY BY NAME g_luc.luc14,g_luc.luc15,g_luc.luc16,
#                         g_luc.luccont
#         RETURN
#      END IF 
#
#      IF g_luc.luc25 = 'Y' THEN
#         CALL t615_generate_arrived() 
#      END IF 
#      CALL s_showmsg()
#      
#      IF g_success = 'Y' THEN
#         CALL cl_err('','abm-983',0)
#         COMMIT WORK
#
#         SELECT gen02 INTO l_gen02_1
#           FROM gen_file
#          WHERE gen01 = g_luc.luc15
#              
#         DISPLAY l_gen02_1 TO FORMONLY.gen02_1
#         DISPLAY BY NAME g_luc.luc14,g_luc.luc15,g_luc.luc16,
#                         g_luc.luccont
#      ELSE
#         ROLLBACK WORK
#      END IF
#      
#      CALL cl_set_field_pic(g_luc.luc14,"","","","","")                
#   END IF 
#   CLOSE t615_cl
#   COMMIT WORK      
#END FUNCTION
 
FUNCTION t615_set_entry(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("luc01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t615_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("luc01",FALSE)        
   END IF

  #20111221 By shi Begin---
   CALL cl_set_comp_entry("luc10",FALSE)
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND p_cmd = 'a' THEN
      CALL cl_set_comp_entry("luc10,luc11",FALSE)
      LET g_luc.luc10 = g_argv1
      LET g_luc.luc11 = g_argv2
      DISPLAY BY NAME g_luc.luc10,g_luc.luc11
   END IF
  #20111221 By shi End-----
END FUNCTION  

FUNCTION t615_set_no_entry_luc11(p_cmd)
 DEFINE   p_cmd     LIKE type_file.chr1

   IF NOT cl_null(g_luc.luc11) THEN
      CALL cl_set_comp_entry("luc03,luc05,luc04",FALSE)
   ELSE
      CALL cl_set_comp_entry("luc03,luc05,luc04",TRUE)
   END IF

END FUNCTION
 
FUNCTION t615_set_no_entry_luc04(p_cmd)
 DEFINE   p_cmd     LIKE type_file.chr1

   IF cl_null(g_luc.luc11) THEN
      IF NOT cl_null(g_luc.luc04) THEN
         CALL cl_set_comp_entry("luc03,luc05",FALSE)
      ELSE
         CALL cl_set_comp_entry("luc03,luc05",TRUE)
      END IF
   END IF
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("luc03,luc05,luc04",FALSE)
   END IF
END FUNCTION

##取消审核,逆向跟新数据
#FUNCTION t615_unconfirm()
#   DEFINE l_n             LIKE type_file.num5,
#          l_luc14         LIKE luc_file.luc14,
#          l_luc15         LIKE luc_file.luc15,
#          l_luc16         LIKE luc_file.luc16,
#          l_luccont       LIKE luc_file.luccont,
#          l_lup03         LIKE lup_file.lup03,
#          l_lup04         LIKE lup_file.lup04,
#          l_lup07         LIKE lup_file.lup07,
#          l_luo10         LIKE luo_file.luo10,
#          l_luo09         LIKE luo_file.luo09,
#          l_luo11         LIKE luo_file.luo11,  
#          l_luo03         LIKE luo_file.luo03,
#          l_lub11         LIKE lub_file.lub11,
#          l_lub13         LIKE lub_file.lub13,
#          l_lua35         LIKE lua_file.lua35,
#          l_lua14         LIKE lua_file.lua14,
#          l_lul08         LIKE lul_file.lul08,
#          l_luk12         LIKE luk_file.luk12,
#          l_lus06         LIKE lus_file.lus06,
#          l_luq10         LIKE luq_file.luq10,
#          l_luk01         LIKE luk_file.luk01,
#          l_sql           STRING 
#   DEFINE l_lud    RECORD LIKE lud_file.*       
#          
#   IF cl_null(g_luc.luc01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_luc.* 
#     FROM luc_file
#    WHERE luc01 = g_luc.luc01
#
#   LET l_luc14 = g_luc.luc14 
#   LET l_luc15 = g_luc.luc15
#   LET l_luc16 = g_luc.luc16 
#   LET l_luccont = g_luc.luccont 
#   
#   IF g_luc.luc14 = 'N' THEN
#      CALL cl_err(g_luc.luc01,'alm-007',1)
#      RETURN
#   END IF
#   
#   IF g_luc.luc25 ='Y' THEN 
#      SELECT DISTINCT lul01 INTO l_luk01 
#        FROM lul_file
#       WHERE lul03 = g_luc.luc01
#
#      SELECT count(*) INTO l_n 
#        FROM lup_file
#       WHERE lup03 = l_luk01
#      IF l_n > 0 THEN 
#         CALL cl_err('','alm1372',0)
#         RETURN
#      ELSE 
#         SELECT count(*) INTO l_n
#           FROM rxy_file
#          WHERE rxy06 = l_luk01
#         IF l_n > 0 THEN
#            CALL cl_err('','alm1373',0)
#            RETURN  
#         ELSE 
#            DELETE FROM luk_file
#             WHERE luk05 = g_luc.luc01 
#            IF SQLCA.SQLCODE THEN
#               CALL cl_err3("del"," luk_file",g_luc.luc01,"",
#                      SQLCA.SQLCODE,"","(t615_r:delete lud)",1)
#               RETURN         
#            END IF
#            DELETE FROM lul_file
#             WHERE lul03 = g_luc.luc01
#            IF SQLCA.SQLCODE THEN
#               CALL cl_err3("del"," lul_file",g_luc.luc01,"",
#                      SQLCA.SQLCODE,"","(t615_r:delete lud)",1)
#               RETURN
#            END IF
#         END IF  
#      END IF 
#   END IF 
#    
#   LET l_sql = " SELECT *",
#               "   FROM lud_file",
#               "  WHERE lud01 = '",g_luc.luc01,"'"
#
#   DECLARE t615_unconfirm_cs CURSOR FROM l_sql
#
#   LET g_success = 'Y'
#   
#   BEGIN WORK
#   OPEN t615_cl USING g_luc.luc01
#    
#   IF STATUS THEN 
#      CALL cl_err("open t615_cl:",STATUS,1)
#      CLOSE t615_cl
#      ROLLBACK WORK 
#      RETURN 
#   END IF
#   
#   FETCH t615_cl INTO g_luc.*
#   IF SQLCA.sqlcode  THEN 
#      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
#      CLOSE t615_cl
#      ROLLBACK WORK
#      RETURN 
#   END IF    
#    
#   IF NOT cl_confirm('alm-008') THEN
#      RETURN
#   ELSE
#      LET g_luc.luc14 = 'N'
#      LET g_luc.luc15 = NULL
#      LET g_luc.luc16 = NULL
#      LET g_luc.luccont = NULL
#      LET g_luc.lucmodu = g_user
#      LET g_luc.lucdate = g_today
#
#      FOREACH t615_unconfirm_cs INTO l_lud.*
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#
#         IF NOT cl_null(l_lud.lud06) THEN 
#            CALL cl_err('','alm1343',0)
#            RETURN    
#         END IF 
#
#         IF NOT cl_null(l_lud.lud10) THEN 
#            CALL cl_err('','alm1344',0)
#            RETURN 
#         END IF 
#
#         IF cl_null(l_lud.lud07t ) THEN 
#            LET l_lud.lud07t = 0
#         END IF 
#            
#         CASE g_luc.luc10
#            WHEN '1'
#               SELECT lup03,lup04,lup07 INTO l_lup03,l_lup04,l_lup07
#                 FROM lup_file
#                WHERE lup01 = l_lud.lud03
#                  AND lup02 = l_lud.lud04
#
#               IF cl_null(l_lup07) THEN 
#                  LET l_lup07 = 0
#               END IF 
#
#               LET l_lup07 = l_lup07 - l_lud.lud07t
#
#               UPDATE lup_file
#                  SET lup07 = l_lup07
#                WHERE lup01 = l_lud.lud03
#                  AND lup02 = l_lud.lud04
#                  
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","lup_file",l_lud.lud03,"",
#                                              SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#
#               SELECT luo03,luo10 INTO l_luo03,l_luo10
#                 FROM luo_file 
#                WHERE luo01 = l_lud.lud03 
#
#               IF cl_null(l_luo10) THEN 
#                  LET l_luo10 = 0 
#               END IF 
#
#               UPDATE luo_file
#                  SET luo10 = l_luo10 - l_lud.lud07t 
#                WHERE luo01 = l_lud.lud03
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","luo_file",l_lud.lud03,"",
#                                              SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#
#               SELECT luo09,luo10,luo11 INTO l_luo09,l_luo10,l_luo11
#                 FROM luo_file
#                WHERE luo01 = l_lud.lud03
#               IF cl_null(l_luo09) THEN
#                  LET l_luo09 = 0
#               END IF
#                              
#               IF cl_null(l_luo10) THEN
#                  LET l_luo10 = 0
#               END IF
#
#               IF cl_null(l_luo11) THEN
#                  LET l_luo11 = 0
#               END IF
# 
#               IF l_luo09 - l_luo10 - l_luo11 <> 0 THEN
#                  UPDATE luo_file
#                     SET luo15 = '1'
#                   WHERE luo01 = l_lud.lud03
#
#                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                     CALL cl_err3("upd","luo_file",l_lud.lud03,"",
#                                              SQLCA.sqlcode,"","",1)
#                     LET g_success = 'N'
#                     RETURN
#                  END IF
#               END IF 
#               CASE l_luo03
#                  WHEN '1'
#                     SELECT lul08 INTO l_lul08
#                       FROM lul_file
#                      WHERE lul01 = l_lup03
#                        AND lul02 = l_lup04
#
#                     IF cl_null(l_lul08) THEN 
#                        LET l_lul08 = 0
#                     END IF 
#
#                     UPDATE lul_file
#                        SET lul08 = l_lul08 - l_lud.lud07t
#                      WHERE lul01 = l_lup03
#                        AND lul02 = l_lup04
#
#                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                        CALL cl_err3("upd","lul_file",l_lup03,"",
#                                              SQLCA.sqlcode,"","",1)
#                        LET g_success = 'N'
#                        RETURN
#                     END IF   
#
#                     SELECT luk12 INTO l_luk12
#                       FROM luk_file
#                      WHERE luk01 = l_lup03
#
#                     IF cl_null(l_luk12) THEN 
#                        LET l_luk12 = 0  
#                     END IF  
#
#                     UPDATE luk_file
#                        SET luk12 = l_luk12 - l_lud.lud07t
#                      WHERE luk01 = l_lup03
#
#                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                        CALL cl_err3("upd","luk_file",l_lup03,"",
#                                              SQLCA.sqlcode,"","",1)
#                        LET g_success = 'N'
#                        RETURN
#                     END IF 
#                  WHEN '2'
#                     SELECT lub11,lub13 INTO l_lub11,l_lub13
#                       FROM lub_file
#                      WHERE lub01 = l_lup03
#                        AND lub02 = l_lup04
#
#                     IF cl_null(l_lub11) THEN
#                        LET l_lub11 = 0
#                     END IF 
#
#                     UPDATE lub_file 
#                        SET lub11 = l_lub11 + l_lud.lud07t
#                      WHERE lub01 = l_lup03
#                        AND lub02 = l_lup04
#
#                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                        CALL cl_err3("upd","lub_file",l_lup03,"",
#                                              SQLCA.sqlcode,"","",1)
#                        LET g_success = 'N'
#                        RETURN
#                     END IF     
#                 
#                     IF l_lub13 = 'Y' THEN 
#                        UPDATE lub_file 
#                           SET lub13 = 'N'
#                         WHERE lub01 = l_lup03
#                           AND lub02 = l_lup04
#
#                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                           CALL cl_err3("upd","lub_file",l_lup03,"",
#                                              SQLCA.sqlcode,"","",1)
#                           LET g_success = 'N'
#                           RETURN
#                        END IF 
#                     END IF
#
#                    SELECT lua35,lua14 INTO l_lua35,l_lua14
#                      FROM lua_file
#                     WHERE lua01 = l_lup03
#
#                    IF cl_null(l_lua35) THEN 
#                       LET l_lua35 = 0
#                    END IF  
#
#                    UPDATE lua_file
#                       SET lua35 = l_lua35 + l_lud.lud07t
#                     WHERE lua01 = l_lup03
#
#                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                       CALL cl_err3("upd","lua_file",l_lup03,"",
#                                            SQLCA.sqlcode,"","",1)
#                       LET g_success = 'N'
#                       RETURN
#                    END IF  
#
#                    IF l_lua14 = '2' THEN
#                       UPDATE lua_file
#                          SET lua14 = '1'
#                        WHERE lua01 = l_lup03
#
#                       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                          CALL cl_err3("upd","lua_file",l_lup03,"",
#                                            SQLCA.sqlcode,"","",1)
#                          LET g_success = 'N'
#                          RETURN
#                       END IF 
#                    END IF  
#
#                     SELECT liw14,liw17 INTO l_lub11,l_lub13
#                       FROM liw_file
#                      WHERE liw16 = l_lup03
#                        AND liw18 = l_lup04
#
#                     IF cl_null (l_lub11) THEN
#                        LET l_lub11 = 0 
#                     END IF   
#
#                     UPDATE liw_file
#                        SET liw14 = l_lub11 + l_lud.lud07t
#                      WHERE liw16 = l_lup03
#                        AND liw18 = l_lup04
#
#                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                        CALL cl_err3("upd","liw_file",l_lup03,"",
#                                              SQLCA.sqlcode,"","",1)
#                        LET g_success = 'N'
#                        RETURN
#                     END IF
#                
#                    IF l_lub13 = 'Y' THEN 
#                        UPDATE liw_file
#                           SET liw17 = 'N'
#                         WHERE liw16 = l_lup03
#                           AND liw18 = l_lup04
#                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                           CALL cl_err3("upd","lub_file",l_lup03,"",
#                                              SQLCA.sqlcode,"","",1)
#                           LET g_success = 'N'
#                           RETURN
#                        END IF
#                     END IF 
#               END CASE 
#            WHEN '2'
#               SELECT lus06 INTO l_lus06
#                 FROM lus_file
#                WHERE lus01 = l_lud.lud03
#                  AND lus02 = l_lud.lud04
#
#               IF cl_null(l_lus06) THEN 
#                  LET l_lus06 = 0    
#               END IF    
#
#               UPDATE lus_file
#                  SET lus06 = l_lus06 - l_lud.lud07t
#                WHERE lus01 = l_lud.lud03
#                  AND lus02 = l_lud.lud04
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","lus_file",l_lup03,"",
#                                         SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF  
#
#               SELECT luq10 INTO l_luq10
#                 FROM luq_file
#                WHERE luq01 = l_lud.lud03
#
#               IF cl_null(l_luq10) THEN
#                  LET l_luq10 = 0 
#               END IF   
#
#               UPDATE luq_file
#                  SET luq10 = l_luq10 - l_lud.lud07t
#                WHERE luq01 = l_lud.lud03
#
#               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err3("upd","luq_file",l_lup03,"",
#                                         SQLCA.sqlcode,"","",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#         END CASE 
#      END FOREACH    
#   
#      UPDATE luc_file
#         SET luc14 = g_luc.luc14,
#             luc15 = g_luc.luc15,
#             luc16 = g_luc.luc16,
#             luccont = g_luc.luccont,
#             lucmodu = g_luc.lucmodu,
#             lucdate = g_luc.lucdate
#       WHERE luc01 = g_luc.luc01
#       
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd luc:',SQLCA.SQLCODE,0)
#         LET g_luc.luc14 = "Y"
#         LET g_luc.luc15 = l_luc15
#         LET g_luc.luc16 = l_luc16
#         LET g_luc.luccont = l_luccont
#         DISPLAY BY NAME g_luc.luc14,g_luc.luc15,g_luc.luc16,
#                         g_luc.luccont
#         RETURN
#      ELSE 
#         DISPLAY '' TO FORMONLY.gen02_1
#         DISPLAY BY NAME g_luc.luc14,g_luc.luc15,g_luc.luc16,g_luc.luccont,
#                         g_luc.lucmodu,g_luc.lucdate
#         CALL cl_set_field_pic(g_luc.luc14,"","","","","")                
#      END IF
#   END IF 
#   CLOSE t615_cl
#   IF g_success = 'Y' THEN 
#      COMMIT WORK  
#   END IF    
#END FUNCTION
 
FUNCTION t615_b()
   DEFINE
      l_n             LIKE type_file.num5,
      l_n1            LIKE type_file.num5,
      l_i1            LIKE type_file.num5,
      l_lud02         LIKE lud_file.lud02,
      l_lock_sw       LIKE type_file.chr1,
      p_cmd           LIKE type_file.chr1,
      l_allow_insert  LIKE type_file.num5,
      flag            LIKE type_file.chr1,
      l_allow_delete  LIKE type_file.num5,
      l_ac_t          LIKE type_file.num5    #FUN-D30033 add

   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_luc.luc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_luc.*
     FROM luc_file
    WHERE luc01=g_luc.luc01

   IF g_luc.luc14 = 'Y' THEN
      CALL cl_err(g_luc.luc01,'alm-027',1)
     RETURN
   END IF
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_luc.luc24 <> 0 AND NOT cl_null(g_luc.luc24) THEN
      CALL cl_err(g_luc.luc01,'alm1371',0)
      RETURN  
   END IF 

   IF g_luc.luc10 = '2' THEN
      CALL cl_err('','alm1355',0)
      RETURN 
   END IF 

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT lud02,lud03,lud04,lud05,'','','','',lud07t,'',",
                      "       '','','',lud06,lud10",        
                      "  FROM lud_file",
                      " WHERE lud01='",g_luc.luc01,"'",
                      "   AND lud02=? ",
                      "  FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t615_bcl CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_lud WITHOUT DEFAULTS FROM s_lud.*
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

        OPEN t615_cl USING g_luc.luc01
        IF STATUS THEN
           CALL cl_err("OPEN t615_cl:", STATUS, 1)
           CLOSE t615_cl
           ROLLBACK WORK
           RETURN
        END IF

        FETCH t615_cl INTO g_luc.*
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
           CLOSE t615_cl
           ROLLBACK WORK
           RETURN
        END IF

        IF g_rec_b >= l_ac THEN
           LET p_cmd='u'
           LET g_lud_t.* = g_lud[l_ac].*

           OPEN t615_bcl USING g_lud_t.lud02
           IF STATUS THEN
              CALL cl_err("OPEN t615_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE
             FETCH t615_bcl INTO g_lud[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_lud_t.lud02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
          END IF
          CALL t615_dis_oaj(g_lud[l_ac].lud03,g_lud[l_ac].lud04,
                            g_lud[l_ac].lud05,'2')
          CALL cl_show_fld_cont()
       END IF

   BEFORE INSERT
      DISPLAY "BEFORE INSERT!"
      LET l_n = ARR_COUNT()
      LET p_cmd='a'
      INITIALIZE g_lud[l_ac].* TO NULL
      LET g_lud_t.* = g_lud[l_ac].*
      IF NOT cl_null(g_luc.luc11) THEN
         LET g_lud[l_ac].lud03 = g_luc.luc11 
      END IF 
      CALL cl_show_fld_cont()
      NEXT FIELD lud02

   AFTER INSERT
      DISPLAY "AFTER INSERT!"
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         CANCEL INSERT
      END IF
      
      INSERT INTO lud_file(lud01,lud02,lud03,lud04,lud05,lud06,lud07,lud07t,
                           lud08,lud09,lud10,ludplant,ludlegal)
           VALUES(g_luc.luc01,g_lud[l_ac].lud02,g_lud[l_ac].lud03,
                  g_lud[l_ac].lud04,g_lud[l_ac].lud05,g_lud[l_ac].lud06,
                  0,g_lud[l_ac].lud07t,'','','',g_luc.lucplant,g_luc.luclegal)

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lud_file",g_luc.luc01,
                      g_lud[l_ac].lud02,SQLCA.sqlcode,"","",1)
         CANCEL INSERT
      ELSE
         MESSAGE 'INSERT O.K'
         COMMIT WORK
         LET g_success = 'Y'
         LET g_rec_b=g_rec_b+1
         DISPLAY g_rec_b TO FORMONLY.cnt2
      END IF

   BEFORE FIELD lud02
      IF p_cmd = 'a' THEN  
         SELECT MAX(lud02) INTO l_lud02
           FROM lud_file 
          WHERE lud01 = g_luc.luc01

         IF cl_null(l_lud02) THEN 
            LET l_lud02 = 1
         ELSE 
            LET l_lud02 = l_lud02 + 1   
         END IF  

         LET g_lud[l_ac].lud02 = l_lud02
      END IF       

   AFTER FIELD lud02
      IF NOT cl_null(g_lud[l_ac].lud02) THEN
         IF g_lud[l_ac].lud02 <= 0 THEN
            CALL cl_err('','alm1127',0)
            LET g_lud[l_ac].lud02 = g_lud_t.lud02
            NEXT FIELD lud02
         END IF

         IF (p_cmd = 'a') OR 
            (p_cmd = 'u' AND g_lud[l_ac].lud02 <> g_lud_t.lud02) THEN
            SELECT COUNT(*) INTO l_n 
              FROM lud_file
             WHERE lud01 = g_luc.luc01
               AND lud02 = g_lud[l_ac].lud02

            IF l_n > 0 THEN
               CALL cl_err('','alm1357',0)
               LET g_lud[l_ac].lud02 = g_lud_t.lud02
               NEXT FIELD lud02
            END IF 
         END IF  
      END IF

   #单头来源单号不为空,单身的来源单号必须与单头一致,
   #单头的来源单号为空,满足单头范围的来源单号 
   AFTER FIELD lud03
      IF NOT cl_null(g_lud[l_ac].lud03) THEN
         CALL t615_lud03(p_cmd)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            LET g_lud[l_ac].lud03 = g_lud_t.lud03
            NEXT FIELD lud03
         END IF
         IF NOT cl_null(g_lud[l_ac].lud04) THEN 
            CALL t615_lud04(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_lud[l_ac].lud03 = g_lud_t.lud03
               NEXT FIELD lud03
            END IF  
         END IF    
      END IF
  
   #同一退款单号，来源单号+来源项次不可以重复 
   AFTER FIELD lud04
      IF NOT cl_null(g_lud[l_ac].lud04) AND NOT cl_null(g_lud[l_ac].lud03) THEN
         CALL t615_lud04(p_cmd)
         IF NOT cl_null(g_errno) THEN 
            CALL cl_err('',g_errno,0)
            LET g_lud[l_ac].lud04 = g_lud_t.lud04
            NEXT FIELD lud04
         END IF 
      END IF

   BEFORE FIELD lud07t
      LET g_lud_t.lud07t = g_lud[l_ac].lud07t 

   #大于0，小于支出未退，支出未退金额通过来源单号+项次带出,
   #同时去掉未审核的退款金额
   AFTER FIELD lud07t
      IF NOT cl_null(g_lud[l_ac].lud07t) THEN
         IF g_lud[l_ac].lud07t < 0 THEN
            CALL cl_err(g_lud[l_ac].lud07t,'alm-719',1)
            LET g_lud[l_ac].lud07t = g_lud_t.lud07t
            NEXT FIELD lud07t
         END IF
         CALL t615_lud07t(p_cmd)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            LET g_lud[l_ac].lud07t = g_lud_t.lud07t 
            NEXT FIELD lud07t
         END IF
      END IF
   
   BEFORE DELETE
      IF g_lud_t.lud02 IS NOT NULL THEN 
      IF NOT cl_delb(0,0) THEN
         CANCEL DELETE
      END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF

         DELETE FROM lud_file
               WHERE lud01 = g_luc.luc01
                 AND lud02 = g_lud_t.lud02

         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lud_file",g_luc.luc01,
                          g_lud_t.lud02,SQLCA.sqlcode,"","",1)
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
         LET g_lud[l_ac].* = g_lud_t.*
         CLOSE t615_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      
      IF l_lock_sw = 'Y' THEN
         CALL cl_err(g_lud[l_ac].lud02,-263,1)
         LET g_lud[l_ac].* = g_lud_t.*
      ELSE
         UPDATE lud_file
            SET lud02 = g_lud[l_ac].lud02,
                lud03 = g_lud[l_ac].lud03,
                lud04 = g_lud[l_ac].lud04,
                lud05 = g_lud[l_ac].lud05,
                lud06 = g_lud[l_ac].lud06,
                lud07t = g_lud[l_ac].lud07t,
                lud10 = g_lud[l_ac].lud10 
          WHERE lud01=g_luc.luc01
            AND lud02=g_lud_t.lud02

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lud_file",g_luc.luc01,
                 g_lud_t.lud02,SQLCA.sqlcode,"","",1)
            LET g_lud[l_ac].* = g_lud_t.*
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
            CALL g_lud.deleteElement(l_ac)
            #FUN-D30033--add--begin--
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
            #FUN-D30033--add--end----
         END IF

         IF p_cmd = 'u' THEN
            LET g_lud[l_ac].* = g_lud_t.*
         END IF

         CLOSE t615_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      LET l_ac_t = l_ac  #FUN-D30033 add

      IF g_success =  'N' THEN
         CLOSE t615_bcl
         ROLLBACK WORK
      ELSE
         CLOSE t615_bcl
      END IF
      
   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION controlp
      CASE
         WHEN INFIELD(lud03)
            CALL cl_init_qry_var()
            IF g_luc.luc10 = '1' THEN
              #IF NOT cl_null(g_luc.luc11) THEN   
              #   LET g_qryparam.form ="q_lud03_1"
              #ELSE
              #   LET g_qryparam.form ="q_lud03_3"
              #   LET g_qryparam.where = " lup01 = '",g_luc.luc11,"'"
              #END IF 
               LET g_qryparam.form ="q_luc11_1"
               IF NOT cl_null(g_luc.luc11) THEN   
                  LET g_qryparam.where = " luo01 = '",g_luc.luc11,"'"
               ELSE
                  LET g_sql = " 1=1"
                  IF NOT cl_null(g_luc.luc04) THEN
                     LET g_sql =  g_sql CLIPPED," AND luo07 = '",g_luc.luc04,"'"
                  END IF
                  IF NOT cl_null(g_luc.luc03) THEN
                     LET g_sql = g_sql CLIPPED," AND luo05 = '",g_luc.luc03,"'"
                  END IF
                  IF NOT cl_null(g_luc.luc05) THEN
                     LET g_sql = g_sql CLIPPED," AND luo06 = '",g_luc.luc05,"'"
                  END IF
                  LET g_qryparam.where = g_sql
               END IF 
            END IF  
            LET g_qryparam.default1 = g_lud[l_ac].lud03
            CALL cl_create_qry() RETURNING g_lud[l_ac].lud03
            DISPLAY BY NAME g_lud[l_ac].lud03
            NEXT FIELD lud03
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

   IF p_cmd = 'u' AND flag = 'u' THEN
      LET g_luc.lucmodu = g_user
      LET g_luc.lucdate = g_today

      UPDATE luc_file
         SET lucmodu = g_luc.lucmodu,
             lucdate = g_luc.lucdate
       WHERE luc01 = g_luc.luc01
      DISPLAY BY NAME g_luc.lucmodu,g_luc.lucdate
   END IF
   CALL t615_upd()
   CLOSE t615_bcl
#  CALL t615_delall() #CHI-C30002 mark
   CALL t615_delHeader()     #CHI-C30002 add
   COMMIT WORK 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t615_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_luc.luc01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM luc_file ",
                  "  WHERE luc01 LIKE '",l_slip,"%' ",
                  "    AND luc01 > '",g_luc.luc01,"'"
      PREPARE t615_pb1 FROM l_sql 
      EXECUTE t615_pb1 INTO l_cnt      
      
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
         CALL t615_v()
         IF g_luc.luc14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic(g_luc.luc14,"","","",g_void,"") 
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM rxy_file
          WHERE rxy01 = g_luc.luc01
         DELETE FROM rxz_file
          WHERE rxz01 = g_luc.luc01
         DELETE FROM rxx_file
          WHERE rxx01 = g_luc.luc01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM luc_file where luc01 = g_luc.luc01
         INITIALIZE g_luc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t615_delall()
#  DEFINE l_n    LIKE type_file.num5

#  SELECT count(*) INTO l_n
#    FROM lud_file
#   WHERE lud01 = g_luc.luc01

#  IF l_n = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#        ERROR g_msg CLIPPED
#     DELETE FROM luc_file where luc01 = g_luc.luc01
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t615_b_fill(p_wc2)
   DEFINE p_wc2      STRING

   IF cl_null(p_wc2) THEN
      LET p_wc2 = " 1=1" 
   END IF 
   LET g_sql = "SELECT lud02,lud03,lud04,lud05,'','','','',lud07t,",
               "       '','','','',lud06,lud10",
               "  FROM lud_file",
               " WHERE lud01 ='",g_luc.luc01,"' ",
               "   AND ",p_wc2 CLIPPED ,
               " ORDER BY lud02"

   PREPARE t615_pb FROM g_sql
   DECLARE t615_b_cs CURSOR FOR t615_pb

   CALL g_lud.clear()
   LET g_cnt = 1

   FOREACH t615_b_cs INTO g_lud[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      CALL t615_dis_oaj(g_lud[g_cnt].lud03,g_lud[g_cnt].lud04,
                        g_lud[g_cnt].lud05,'1')
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lud.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t615_bp_refresh()
END FUNCTION

FUNCTION t615_dis_oaj(p_lud03,p_lud04,p_lud05,p_flag)
   DEFINE p_oaj01      LIKE oaj_file.oaj01,
          l_oaj02      LIKE oaj_file.oaj02,
          l_oaj04      LIKE oaj_file.oaj04,
          l_oaj041     LIKE oaj_file.oaj041,
          l_aag02      LIKE aag_file.aag02,
          l_aag02_1    LIKE aag_file.aag02,
          p_lud03      LIKE lud_file.lud03,
          p_lud04      LIKE lud_file.lud04,
          p_lud05      LIKE lud_file.lud05,
          l_lup06      LIKE lup_file.lup06,
          l_lup07      LIKE lup_file.lup07,
          l_lup08      LIKE lup_file.lup08,
          l_lus05      LIKE lus_file.lus05,
          l_lus06      LIKE lus_file.lus06,
          l_oaj05      LIKE oaj_file.oaj05,
          l_lud07t     LIKE lud_file.lud07t,
          p_flag       LIKE type_file.chr1
#FUN-C10024--add--str--
   DEFINE l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--     

   CALL s_get_bookno(YEAR(g_luc.luc07)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
   SELECT oaj02,oaj04,oaj041
     INTO l_oaj02,l_oaj04,l_oaj041
     FROM oaj_file
    WHERE oaj01 = p_lud05

   SELECT aag02 INTO l_aag02
     FROM aag_file
    #WHERE aag00 = g_aza.aza81   #FUN-C10024
     WHERE aag00 = l_bookno1  #FUN-C10024 add
      AND aag01 = l_oaj04

   SELECT aag02 INTO l_aag02_1
     FROM aag_file
    #WHERE aag00 = g_aza.aza81 #FUN-C10024
     WHERE aag00 = l_bookno2  #FUN-C10024 add
      AND aag01 = l_oaj041

   CASE g_luc.luc10
      WHEN '1'
         SELECT lup06,lup07,lup08 INTO l_lup06,l_lup07,l_lup08
           FROM lup_file
          WHERE lup01 = p_lud03
            AND lup02 = p_lud04
            
         IF cl_null(l_lup06) THEN
            LET l_lup06 = 0 
         END IF 

         IF cl_null(l_lup07) THEN
            LET l_lup07 = 0 
         END IF

         IF cl_null(l_lup08) THEN
            LET l_lup08 = 0 
         END IF
         
         SELECT oaj05 INTO l_oaj05 
           FROM oaj_file
          WHERE oaj01 = p_lud05
      WHEN '2'
         SELECT lus04,lus05,lus06 INTO l_oaj05,l_lus05,l_lus06
           FROM lus_file
          WHERE lus01 = p_lud03
            AND lus02 = p_lud04

         IF cl_null(l_lus06) THEN
            LET l_lus06 = 0 
         END IF   
   END CASE    

   CASE p_flag
      WHEN '1'
         LET g_lud[g_cnt].oaj02 = l_oaj02
         LET g_lud[g_cnt].oaj04 = l_oaj04
         LET g_lud[g_cnt].oaj041 = l_oaj041
         LET g_lud[g_cnt].aag02 = l_aag02
         LET g_lud[g_cnt].aag02_1 = l_aag02_1
         LET g_lud[g_cnt].oaj05 = l_oaj05

        #SELECT SUM(lud07t) INTO l_lud07t
        #  FROM lud_file,luc_file
        # WHERE luc14 = 'N'
        #   AND lud01 = luc01
        #   AND lud03 = g_lud[g_cnt].lud03
        #   AND lud04 = g_lud[g_cnt].lud04
        #   AND lud01 <> g_luc.luc01

         IF cl_null(l_lud07t) THEN
            LET l_lud07t = 0
         END IF  

         CASE g_luc.luc10
            WHEN '1'
               LET g_lud[g_cnt].amt = l_lup06
               LET g_lud[g_cnt].amt1 = l_lup06 - l_lup07 - l_lup08 - l_lud07t
            WHEN '2'
               LET g_lud[g_cnt].amt = l_lus05
               LET g_lud[g_cnt].amt1 = l_lus05 - l_lus06 - l_lud07t
         END CASE 
         
      WHEN '2'
         IF cl_null(g_lud[l_ac].lud07t) THEN
            LET g_lud[l_ac].lud07t = 0
         END IF

         LET g_lud[l_ac].oaj02 = l_oaj02
         LET g_lud[l_ac].oaj04 = l_oaj04
         LET g_lud[l_ac].oaj041 = l_oaj041
         LET g_lud[l_ac].aag02 = l_aag02
         LET g_lud[l_ac].aag02_1 = l_aag02_1
         LET g_lud[l_ac].oaj05 = l_oaj05

        #SELECT SUM(lud07t) INTO l_lud07t
        #  FROM lud_file,luc_file
        # WHERE luc14 = 'N'
        #   AND lud01 = luc01
        #   AND lud03 = g_lud[l_ac].lud03
        #   AND lud04 = g_lud[l_ac].lud04
        #   AND lud01 <> g_luc.luc01

         IF cl_null(l_lud07t) THEN
            LET l_lud07t = 0
         END IF

         CASE g_luc.luc10
            WHEN '1'
               LET g_lud[l_ac].amt = l_lup06
               LET g_lud[l_ac].amt1 = l_lup06 - l_lup07 - l_lup08 - l_lud07t
            WHEN '2'
               LET g_lud[l_ac].amt = l_lus05
               LET g_lud[l_ac].amt1 = l_lus05 - l_lus06 - l_lud07t
         END CASE 
   END CASE
END FUNCTION

FUNCTION t615_bp_refresh()
   DISPLAY ARRAY g_lud TO s_lud.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

   BEFORE DISPLAY
      EXIT DISPLAY

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION t615_luc11(p_cmd)
 DEFINE l_amt      LIKE luo_file.luo09
 DEFINE p_cmd      LIKE type_file.chr1
 DEFINE l_luo05    LIKE luo_file.luo05
 DEFINE l_luo06    LIKE luo_file.luo06
 DEFINE l_luo07    LIKE luo_file.luo07
 DEFINE l_luo08    LIKE luo_file.luo08
 DEFINE l_luo09    LIKE luo_file.luo09
 DEFINE l_luo10    LIKE luo_file.luo10
 DEFINE l_luo11    LIKE luo_file.luo11
 DEFINE l_luoconf  LIKE luo_file.luoconf
 DEFINE l_lne05    LIKE lne_file.lne05
 DEFINE l_lne08    LIKE lne_file.lne08
 DEFINE l_tqa02    LIKE tqa_file.tqa02

   LET g_errno = ''
   #来源单号有变化，判断是否跟单身的一致
   IF g_rec_b > 0 AND NOT cl_null(g_luc.luc11) THEN
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM lud_file
       WHERE lud01 = g_luc.luc01
         AND lud03 <> g_luc.luc11
      IF g_cnt > 0 THEN
         LET g_errno = 'alm1339'
          RETURN
      END IF
   END IF
    
   IF g_luc.luc10 = '1' THEN
      #SELECT 商户，摊位，合同，合同版本，支出金额，已退金额，清算金额
      SELECT luo05,luo06,luo07,luo08,luo09,luo10,luo11,luoconf
        INTO l_luo05,l_luo06,l_luo07,l_luo08,l_luo09,l_luo10,l_luo11,l_luoconf
        FROM luo_file 
       WHERE luo01 = g_luc.luc11

      LET l_amt = l_luo09 - l_luo10 - l_luo11

      CASE 
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'axr-098'
         WHEN l_luoconf <> 'Y'    LET g_errno = 'axr-099'        #支出单未审核
         WHEN l_luo09-l_luo10-l_luo11<=0 LET g_errno = 'alm1348' #没有支出金额
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE 

      IF p_cmd = 'd' OR cl_null(g_errno) THEN
         IF p_cmd <> 'd' THEN
            LET g_luc.luc03 = l_luo05
            LET g_luc.luc05 = l_luo06
            LET g_luc.luc04 = l_luo07
            LET g_luc.luc22 = l_luo08
         END IF
         #SELECT lne05,lne08 INTO l_lne05,l_lne08 FROM lne_file  #FUN-C20079 mark
         # WHERE lne01 = l_luo05                                 #FUN-C20079 mark
         #FUN-C20079----add----str---
         SELECT occ02 INTO l_lne05 
           FROM occ_file
          WHERE occ01 = l_luo05
         SELECT lne08 INTO l_lne08
           FROM lne_file
          WHERE lne01 = l_luo05
         #FUN-C20079----add----end----
         IF p_cmd <> 'd' THEN
            LET g_luc.luc031 = l_lne05
         END IF
         IF NOT cl_null(g_luc.luc04) THEN
            SELECT lnt30 INTO l_lne08 FROM lnt_file
             WHERE lnt01 = g_luc.luc04
         END IF
         SELECT tqa02 INTO l_tqa02 FROM tqa_file
          WHERE tqa01 = l_lne08
            AND tqa03 = '2'
         DISPLAY l_lne08,l_tqa02 TO lnt30,tqa02
         DISPLAY BY NAME g_luc.luc03,g_luc.luc031,g_luc.luc05,g_luc.luc04,g_luc.luc22
      END IF
  #ELSE 
  #   LET g_errno = 'alm1338' 
   END IF 
END FUNCTION 

#FUNCTION t615_desc()
#   DEFINE l_luc03       LIKE luc_file.luc03,
#          l_luc031      LIKE luc_file.luc031,
#          l_luc05       LIKE luc_file.luc05,
#          l_luc04       LIKE luc_file.luc04,
#          l_luc22       LIKE luc_file.luc22,
#          l_lnt30       LIKE lnt_file.lnt30,
#          l_tqa02       LIKE tqa_file.tqa02
#
#   SELECT luo05,luo06,luo07,luo08 INTO l_luc03,l_luc05,l_luc04,l_luc22
#     FROM luo_file
#    WHERE luo01 = g_luc.luc11
#
#   SELECT lnt30 INTO l_lnt30 
#     FROM lnt_file
#    WHERE lnt01 = l_luc04
#
#   SELECT tqa02 INTO l_tqa02 
#     FROM tqa_file
#    WHERE tqa01 = l_lnt30
#      AND tqa03 = '2'
#
#   SELECT lne05 INTO l_luc031
#     FROM lne_file
#    WHERE lne01 = l_luc03
#
#   LET g_luc.luc03 = l_luc03
#   LET g_luc.luc05 = l_luc05
#   LET g_luc.luc04 = l_luc04
#   LET g_luc.luc22 = l_luc22
#   LET g_luc.luc031 = l_luc031
#
#   DISPLAY BY NAME g_luc.luc03,g_luc.luc05,g_luc.luc04,g_luc.luc22,g_luc.luc031 
#   DISPLAY l_lnt30 TO FORMONLY.lnt30
#   DISPLAY l_tqa02 TO FORMONLY.tqa02
#   
#END FUNCTION 

FUNCTION t615_luc03(p_cmd)
   DEFINE l_lne05      LIKE lne_file.lne05,
          l_lne08      LIKE lne_file.lne08,
          l_lne36      LIKE lne_file.lne36,
          p_cmd        LIKE type_file.chr1
 DEFINE l_tqa02        LIKE tqa_file.tqa02

   LET g_errno = ''

   #FUN-C20079----mark---str---
   #SELECT lne05,lne08,lne36 INTO l_lne05,l_lne08,l_lne36
   #  FROM lne_file
   # WHERE lne01 = g_luc.luc03
   #FUN-C20079----mark---end---

   #FUN-C20079----add---str---
   SELECT occ02,occacti INTO l_lne05,l_lne36
     FROM occ_file
    WHERE occ01 = g_luc.luc03
   #FUN-C20079----add---end---
   CASE 
      WHEN SQLCA.SQLCODE =100
         LET g_errno = 'alm-a01'
      WHEN l_lne36 <> 'Y'
         LET g_errno = 'alm-997'   
   END CASE  

   SELECT lne08 INTO l_lne08  FROM lne_file WHERE lne01 = g_luc.luc03  #FUN-C20079 add
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_luc.luc031 = l_lne05
      SELECT tqa02 INTO l_tqa02 FROM tqa_file
       WHERE tqa01 = l_lne08
         AND tqa03 = '2'
      DISPLAY l_lne08,l_tqa02 TO lnt30,tqa02
      DISPLAY BY NAME g_luc.luc03,g_luc.luc031
   END IF 
END FUNCTION 

FUNCTION t615_luc05(p_cmd)
   DEFINE l_lmf06  LIKE lmf_file.lmf06,
          p_cmd    LIKE type_file.chr1

   LET g_errno = ''

   SELECT lmf06 INTO l_lmf06
     FROM lmf_file
    WHERE lmf01 = g_luc.luc05

   CASE 
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'alm-042'
      WHEN l_lmf06 <> 'Y'
         LET g_errno = 'alm1063'   
   END CASE   

   IF p_cmd = 'd' OR cl_null(g_errno) THEN 
      DISPLAY BY NAME g_luc.luc05
   END IF 
END FUNCTION 

FUNCTION t615_luc04(p_cmd)
 DEFINE l_lnt26    LIKE lnt_file.lnt26
 DEFINE l_lnt02    LIKE lnt_file.lnt02
 DEFINE l_lnt04    LIKE lnt_file.lnt04
 DEFINE l_lnt06    LIKE lnt_file.lnt06
 DEFINE l_lnt30    LIKE lnt_file.lnt30
 DEFINE l_tqa02    LIKE tqa_file.tqa02    
 DEFINE p_cmd      LIKE type_file.chr1

   LET g_errno = ''

   SELECT lnt04,lnt06,lnt26,lnt02,lnt30
     INTO l_lnt04,l_lnt06,l_lnt26,l_lnt02,l_lnt30
     FROM lnt_file
    WHERE lnt01 = g_luc.luc04
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm1124'
      WHEN l_lnt26 NOT MATCHES '[YSE]'
                               LET g_errno = 'alm1231'
     #WHEN NOT cl_null(g_luc.luc03) AND l_lnt04<>g_luc.luc03
     #                         LET g_errno = 'alm1310'
     #WHEN NOT cl_null(g_luc.luc05) AND l_lnt06<>g_luc.luc05
     #                         LET g_errno = 'alm1310'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_cmd <> 'd' THEN
         LET g_luc.luc22 = l_lnt02
         LET g_luc.luc03 = l_lnt04
         LET g_luc.luc05 = l_lnt06
         #SELECT lne05 INTO g_luc.luc031 FROM lne_file   #FUN-C20079 mark
         # WHERE lne01 = g_luc.luc03                     #FUN-C20079 mark
         SELECT occ02 INTO g_luc.luc031 FROM occ_file    #FUN-C20079 add
          WHERE occ01 = g_luc.luc03                      #FUN-C20079 add
      END IF
      SELECT tqa02 INTO l_tqa02
        FROM tqa_file
       WHERE tqa01 = l_lnt30
         AND tqa03 = '2'
      DISPLAY l_lnt30 TO FORMONLY.lnt30
      DISPLAY l_tqa02 TO FORMONLY.tqa02  
      DISPLAY BY NAME g_luc.luc04,g_luc.luc22,g_luc.luc03,
                      g_luc.luc031,g_luc.luc05
   END IF 
END FUNCTION 

FUNCTION t615_gen02(p_cmd)
   DEFINE l_gen02     LIKE gen_file.gen02,
          l_gen03     LIKE gen_file.gen03, 
          l_genacti   LIKE gen_file.genacti,
          l_gem02     LIKE gem_file.gem02,
          p_cmd       LIKE type_file.chr1

   LET g_errno = ''

   SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_luc.luc26

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'apj-062'
      WHEN l_genacti <> 'Y'
         LET g_errno = 'art-733'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE 

   IF p_cmd = 'd' OR cl_null(g_errno) THEN 
      IF NOT cl_null(l_gen03) THEN
         SELECT gem02 INTO l_gem02
           FROM gem_file
          WHERE gem01 = l_gen03
         LET g_luc.luc27 = l_gen03
      END IF  
      DISPLAY BY NAME g_luc.luc26,g_luc.luc27  
      DISPLAY l_gem02 TO FORMONLY.gem02
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF 
END FUNCTION 

FUNCTION t615_gem02(p_cmd)
   DEFINE l_gem02     LIKE gem_file.gem02,
          l_gemacti   LIKE gem_file.gemacti,
          p_cmd       LIKE type_file.chr1,
          l_n         LIKE type_file.num5

   LET g_errno = ''

   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 =g_luc.luc27

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'apy-070'
      WHEN l_gemacti <> 'Y'
         LET g_errno = 'asf-472'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF NOT cl_null(g_luc.luc26) THEN
      SELECT COUNT(*) INTO l_n
        FROM gen_file
       WHERE gen01 = g_luc.luc26
         AND gen03 = g_luc.luc27

      IF l_n = 0 THEN
         LET g_errno = 'mfg3202'
      END IF
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION 

FUNCTION t615_lucplant(p_cmd)
   DEFINE l_rtz13      LIKE rtz_file.rtz13,
          l_rtz28      LIKE rtz_file.rtz28,
          l_azt02      LIKE azt_file.azt02,
          l_azw02      LIKE azw_file.azw02,
          p_cmd        LIKE type_file.chr1

   SELECT rtz13,rtz28 INTO l_rtz13,l_rtz28
     FROM rtz_file
    WHERE rtz01 = g_luc.lucplant

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'alm-001'
      WHEN l_rtz28 <> 'Y'
         LET g_errno = 'lma-003'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT azw02 INTO l_azw02
        FROM azw_file
       WHERE azw01 = g_luc.lucplant

      LET g_luc.luclegal = l_azw02

      SELECT azt02 INTO l_azt02
        FROM azt_file
       WHERE azt01 = g_luc.luclegal

      DISPLAY BY NAME g_luc.lucplant,g_luc.luclegal
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION 

FUNCTION t615_luc10()
   DEFINE l_n        LIKE type_file.num5

   LET g_errno = ''

   SELECT count(*) INTO l_n 
     FROM lud_file
    WHERE lud01 = g_luc.luc01 

   IF l_n > 0 THEN 
      LET g_errno = 'alm1339'
   END IF  
END FUNCTION 

FUNCTION t615_lud03(p_cmd)
 DEFINE p_cmd          LIKE type_file.chr1
 DEFINE l_luo05        LIKE luo_file.luo05
 DEFINE l_luo06        LIKE luo_file.luo06
 DEFINE l_luo07        LIKE luo_file.luo07
 DEFINE l_luoconf      LIKE luo_file.luoconf

   LET g_errno = ''

   IF NOT cl_null(g_luc.luc11) THEN
      IF g_lud[l_ac].lud03 <> g_luc.luc11 THEN
         LET g_errno = 'alm1238'
         RETURN
      END IF
   END IF    

   SELECT luo05,luo06,luo07,luoconf
     INTO l_luo05,l_luo06,l_luo07,l_luoconf
     FROM luo_file
    WHERE luo01 = g_lud[l_ac].lud03
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm1284'
      WHEN l_luoconf <> 'Y'    LET g_errno = 'axr-099'
      WHEN NOT cl_null(g_luc.luc03) AND NOT cl_null(l_luo05) AND l_luo05<>g_luc.luc03 
         LET g_errno = 'alm1379'
      WHEN NOT cl_null(g_luc.luc05) AND NOT cl_null(l_luo06) AND l_luo06<>g_luc.luc05 
         LET g_errno = 'alm1379'
      WHEN NOT cl_null(g_luc.luc04) AND NOT cl_null(l_luo07) AND l_luo07<>g_luc.luc04 
         LET g_errno = 'alm1379'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION 

FUNCTION t615_lud04(p_cmd)
 DEFINE p_cmd            LIKE type_file.chr1
 DEFINE l_lup03          LIKE lup_file.lup03
 DEFINE l_lup04          LIKE lup_file.lup04
 DEFINE l_lup05          LIKE lup_file.lup05
 DEFINE l_lup06          LIKE lup_file.lup06
 DEFINE l_lup07          LIKE lup_file.lup07
 DEFINE l_lup08          LIKE lup_file.lup08
 DEFINE l_oaj02          LIKE oaj_file.oaj02
 DEFINE l_oaj04          LIKE oaj_file.oaj04
 DEFINE l_oaj041         LIKE oaj_file.oaj041
 DEFINE l_oaj05          LIKE oaj_file.oaj05
 DEFINE l_aag02          LIKE aag_file.aag02
 DEFINE l_aag02_1        LIKE aag_file.aag02
 DEFINE l_lud07t         LIKE lud_file.lud07t
#FUN-C10024--add--str--
 DEFINE l_bookno1 LIKE aag_file.aag00,
        l_bookno2 LIKE aag_file.aag00,
        l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--
   LET g_errno = ''
   IF cl_null(g_lud[l_ac].lud03) OR cl_null(g_lud[l_ac].lud04) THEN
      RETURN
   END IF

   IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_lud[l_ac].lud03 <> g_lud_t.lud03 OR
      g_lud[l_ac].lud04 <> g_lud_t.lud04)) THEN
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM lud_file
       WHERE lud03 = g_lud[l_ac].lud03
         AND lud04 = g_lud[l_ac].lud04
         AND lud01 = g_luc.luc01
      IF g_cnt > 0 THEN
         LET g_errno = 'alm1356'
         RETURN
      END IF
   END IF

   SELECT lup03,lup04,lup05,lup06,lup07,lup08
     INTO l_lup03,l_lup04,l_lup05,l_lup06,l_lup07,l_lup08
     FROM lup_file
    WHERE lup01 = g_lud[l_ac].lud03
      AND lup02 = g_lud[l_ac].lud04
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm1353'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(l_lup06) THEN LET l_lup06=0 END IF
   IF cl_null(l_lup07) THEN LET l_lup07=0 END IF
   IF cl_null(l_lup08) THEN LET l_lup08=0 END IF
   
   IF p_cmd <> 'd' AND cl_null(g_errno) THEN
      SELECT SUM(lud07t) INTO l_lud07t FROM lud_file,luc_file
       WHERE luc01 = lud01
         AND lud03 = g_lud[l_ac].lud03
         AND lud04 = g_lud[l_ac].lud04
         AND lud01 <> g_luc.luc01
         AND luc14 = 'N'
      IF cl_null(l_lud07t) THEN LET l_lud07t=0 END IF
      LET l_lud07t = l_lup06-l_lup07-l_lup08-l_lud07t
      IF l_lud07t = 0 THEN
         LET g_errno = 'alm1369'
         LET g_lud[l_ac].amt = ''
         LET g_lud[l_ac].amt1 = ''
         RETURN
      END IF
   END IF

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_cmd <> 'd' THEN
         LET g_lud[l_ac].lud05 = l_lup05
         LET g_lud[l_ac].lud07t= l_lud07t
      END IF
      SELECT oaj02,oaj05,oaj04,oaj041 INTO l_oaj02,l_oaj05,l_oaj04,l_oaj041
        FROM oaj_file
       WHERE oaj01 = g_lud[l_ac].lud05

      CALL s_get_bookno(YEAR(g_luc.luc07)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
      SELECT aag02 INTO l_aag02
        FROM aag_file
       #WHERE aag00 = g_aza.aza81 #FUN-C10024
        WHERE aag00 = l_bookno1 #FUN-C10024
         AND aag01 = l_oaj04

      SELECT aag02 INTO l_aag02_1
        FROM aag_file
       #WHERE aag00 = g_aza.aza81   #FUN-C10024
        WHERE aag00 = l_bookno2  #FUN-C10024 add
         AND aag01 = l_oaj041

      LET g_lud[l_ac].oaj02 = l_oaj02
      LET g_lud[l_ac].oaj05 = l_oaj05
      LET g_lud[l_ac].amt = l_lup06
      LET g_lud[l_ac].amt1= l_lup06-l_lup07-l_lup08
      LET g_lud[l_ac].oaj04 = l_oaj04
      LET g_lud[l_ac].oaj041 = l_oaj041
      LET g_lud[l_ac].aag02 = l_aag02
      LET g_lud[l_ac].aag02_1 = l_aag02_1
   END IF
END FUNCTION

#FUNCTION t615_lud04(p_cmd)
#   DEFINE l_luoconf        LIKE luo_file.luoconf,
#          l_luo03          LIKE luo_file.luo03,
#          l_lup03          LIKE lup_file.lup03,
#          l_lup04          LIKE lup_file.lup04,
#          l_lup05          LIKE lup_file.lup05,
#          l_lup06          LIKE lup_file.lup06,
#          l_lup07          LIKE lup_file.lup07,
#          l_lup08          LIKE lup_file.lup08,
#          l_lul03          LIKE lul_file.lul03,
#          l_lul04          LIKE lul_file.lul04,
#          l_lub03          LIKE lub_file.lub03,
#          l_lub09          LIKE lub_file.lub09,
#          l_oaj02          LIKE oaj_file.oaj02,
#          l_oaj04          LIKE oaj_file.oaj04,
#          l_oaj05          LIKE oaj_file.oaj05,
#          l_oaj041         LIKE oaj_file.oaj041,
#          l_aag02          LIKE aag_file.aag02,
#          l_aag02_1        LIKE aag_file.aag02,
#          l_amt1           LIKE lup_file.lup06,
#          l_n              LIKE type_file.num5,
#          l_lud07t         LIKE lud_file.lud07t,
#          p_cmd            LIKE type_file.chr1
#          
#   LET g_errno = ''
#
#   IF p_cmd = 'u' THEN
#      IF g_lud[l_ac].lud03 <> g_lud_t.lud03 OR
#         g_lud[l_ac].lud04 <> g_lud_t.lud04 THEN
#         SELECT COUNT(*) INTO l_n
#           FROM lud_file
#          WHERE lud03 = g_lud[l_ac].lud03
#            AND lud04 = g_lud[l_ac].lud04
#            AND lud01 = g_luc.luc01
#
#         IF l_n > 0 THEN
#            LET g_errno = 'alm1356'
#            RETURN
#         END IF    
#      END IF 
#      SELECT SUM(lud07t) INTO l_lud07t
#        FROM lud_file,luc_file
#       WHERE luc14 = 'N'
#         AND luc01 = lud01
#         AND lud03 = g_lud[l_ac].lud03
#         AND lud04 = g_lud[l_ac].lud04
#         AND (lud01 <> g_luc.luc01 OR lud02 <> g_lud[l_ac].lud02) 
#   ELSE
#      SELECT SUM(lud07t) INTO l_lud07t
#        FROM lud_file,luc_file
#       WHERE luc14 = 'N'
#         AND luc01 = lud01
#         AND lud03 = g_lud[l_ac].lud03
#         AND lud04 = g_lud[l_ac].lud04
#
#      SELECT COUNT(*) INTO l_n
#        FROM lud_file
#       WHERE lud03 = g_lud[l_ac].lud03
#         AND lud04 = g_lud[l_ac].lud04
#         AND lud01 = g_luc.luc01
#
#      IF l_n > 0 THEN
#         LET g_errno = 'alm1356'
#         RETURN
#      END IF
#   END IF
#
#   IF cl_null(l_lud07t) THEN
#      LET l_lud07t = 0      
#   END IF  
#
#   SELECT luoconf,luo03 INTO l_luoconf,l_luo03
#     FROM luo_file 
#    WHERE luo01 = g_lud[l_ac].lud03
#
#   CASE 
#      WHEN SQLCA.SQLCODE = 100
#         LET g_errno = ''
#      WHEN l_luoconf <> 'Y'
#         LET g_errno = 'axr-099'   
#   END CASE 
#
#   SELECT COUNT(*) INTO l_n 
#     FROM lup_file
#    WHERE lup01 = g_lud[l_ac].lud03
#      AND lup02 = g_lud[l_ac].lud04
#
#   IF l_n = 0 THEN 
#      LET g_errno = 'alm1353'
#   END IF 
#
#   SELECT lup03,lup04,lup05,lup06,lup07,lup08 
#     INTO l_lup03,l_lup04,l_lup05,l_lup06,l_lup07,l_lup08
#     FROM lup_file
#    WHERE lup01 = g_lud[l_ac].lud03
#      AND lup02 = g_lud[l_ac].lud04
#
#   SELECT oaj05 INTO l_oaj05
#     FROM oaj_file
#    WHERE oaj01 = l_lup05    
#
#   IF cl_null(l_lup06) THEN
#      LET l_lup06 = 0
#   END IF 
#
#   IF cl_null(l_lup07) THEN
#      LET l_lup07 = 0
#   END IF
#
#   IF cl_null(l_lup08) THEN
#      LET l_lup08 = 0
#   END IF
#
#   LET l_amt1 = l_lup06 - l_lup07 -l_lup08 - l_lud07t   
#   LET g_lud[l_ac].amt = l_lup06
#   LET g_lud[l_ac].amt1 = l_amt1
#   
#   IF p_cmd = 'a' THEN
#      LET l_amt1 = l_amt1 - l_lud07t
#      IF l_amt1 <= 0 THEN
#         LET g_errno = 'alm1369'
#         LET g_lud[l_ac].amt = ''
#         LET g_lud[l_ac].amt1 = ''
#         RETURN
#      END IF 
#      LET g_lud[l_ac].lud07t = l_amt1 - l_lud07t 
#   END IF
# 
#   LET g_lud[l_ac].oaj05 = l_oaj05
#   LET g_lud[l_ac].lud05 = l_lup05
#   
#   IF p_cmd = 'd' OR cl_null(g_errno) THEN    
#      SELECT oaj02,oaj04,oaj041 INTO l_oaj02,l_oaj04,l_oaj041 
#        FROM oaj_file
#       WHERE oaj01 = l_lup05
#       
#      SELECT aag02 INTO l_aag02
#        FROM aag_file
#       WHERE aag00 = g_aza.aza81
#         AND aag01 = l_oaj04
#
#      SELECT aag02 INTO l_aag02_1
#        FROM aag_file
#       WHERE aag00 = g_aza.aza81
#         AND aag01 = l_oaj041   
#      
#      LET g_lud[l_ac].oaj02 = l_oaj02
#      LET g_lud[l_ac].oaj04 = l_oaj04
#      LET g_lud[l_ac].oaj041 = l_oaj041
#      LET g_lud[l_ac].aag02 = l_aag02
#      LET g_lud[l_ac].aag02_1 = l_aag02_1
#   END IF 
#END FUNCTION 

FUNCTION t615_lud07t(p_cmd)
   DEFINE l_lup06       LIKE lup_file.lup06,
          l_lup07       LIKE lup_file.lup07,
          l_lup08       LIKE lup_file.lup08,
          l_lud07t      LIKE lud_file.lud07t,
          l_amt         LIKE lup_file.lup08,
          p_cmd         LIKE type_file.chr1

   LET g_errno = ''

   IF p_cmd = 'u' THEN
      SELECT SUM(lud07t) INTO l_lud07t
        FROM lud_file,luc_file
       WHERE luc14 = 'N'
         AND luc01 = lud01
         AND lud03 = g_lud[l_ac].lud03
         AND lud04 = g_lud[l_ac].lud04
         AND (lud01 <> g_luc.luc01 OR lud02 <> g_lud[l_ac].lud02)
   ELSE
      SELECT SUM(lud07t) INTO l_lud07t
        FROM lud_file,luc_file
       WHERE luc14 = 'N'
         AND luc01 = lud01
         AND lud03 = g_lud[l_ac].lud03
         AND lud04 = g_lud[l_ac].lud04
   END IF 

   IF cl_null(l_lud07t) THEN 
      LET l_lud07t = 0
   END IF

   SELECT lup06,lup07,lup08 INTO l_lup06,l_lup07,l_lup08
     FROM lup_file
    WHERE lup01 = g_lud[l_ac].lud03
      AND lup02 = g_lud[l_ac].lud04   

   IF cl_null(l_lup06) THEN
      LET l_lup06 = 0
   END IF 

   IF cl_null(l_lup07) THEN
      LET l_lup07 = 0
   END IF

   IF cl_null(l_lup08) THEN
      LET l_lup08 = 0
   END IF 

   LET l_amt = l_lup06 - l_lup07 - l_lup08
   
   CASE
      WHEN g_lud[l_ac].lud07t > l_amt
         LET g_errno = 'alm1285'
      WHEN g_lud[l_ac].lud07t > l_amt - l_lud07t
         LET g_errno = 'alm1354'
   END CASE
END FUNCTION 

FUNCTION t615_inslud()
   DEFINE l_lucacti    LIKE luc_file.lucacti ,
          l_lud02      LIKE lud_file.lud02,
          l_amt        LIKE lud_file.lud07t,
          l_lud07t     LIKE lud_file.lud07t,
          l_lup01      LIKE lup_file.lup01,
          l_lup02      LIKE lup_file.lup02,
          l_lup03      LIKE lup_file.lup03,
          l_luo03      LIKE luo_file.luo03,
          l_lup05      LIKE lup_file.lup05,
          l_lup06      LIKE lup_file.lup06,
          l_lup07      LIKE lup_file.lup07,
          l_lup08      LIKE lup_file.lup08,
          l_sql        STRING 
   DEFINE l_lup   RECORD LIKE lup_file.*,
          l_lud   RECORD LIKE lud_file.*   

   LET g_sql = "SELECT lup_file.* FROM lup_file,luo_file",
               " WHERE luo01 = lup01 ",
               "   AND luoconf = 'Y' ",
               "   AND lup06-COALESCE(lup07,0)-COALESCE(lup08,0)>0 "
   IF NOT cl_null(g_luc.luc11) THEN
      LET g_sql = g_sql CLIPPED,"   AND lup01 = '",g_luc.luc11,"'"
   ELSE
      #FUN-C30072--start add----------------------------------------------
      LET g_sql = g_sql ,"AND (luo03 = '1' OR (luo03 = '2' AND lup05 IN ",
                 "(SELECT lub03 FROM lub_file,lup_file WHERE lub01 = lup03 AND lub02 =lup04 AND lub09  <> '10')))" 
      #FUN-C30072--end add------------------------------------------------

      IF NOT cl_null(g_luc.luc03) THEN
         LET g_sql = g_sql CLIPPED,"   AND luo05 = '",g_luc.luc03,"'"
      END IF
      IF NOT cl_null(g_luc.luc04) THEN
         LET g_sql = g_sql CLIPPED,"   AND luo07 = '",g_luc.luc04,"'"
      END IF
      IF NOT cl_null(g_luc.luc05) THEN
         LET g_sql = g_sql CLIPPED,"   AND luo06 = '",g_luc.luc05,"'"
      END IF
   END IF

   LET g_sql = g_sql CLIPPED," ORDER BY lup01,lup02 "
   DECLARE t615_ins_cs CURSOR FROM g_sql
   FOREACH t615_ins_cs INTO l_lup.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

         SELECT SUM(lud07t) INTO l_lud07t
           FROM lud_file,luc_file
          WHERE luc14 = 'N'
            AND luc01 = lud01
            AND lud03 = l_lup.lup01
            AND lud04 = l_lup.lup02   

         IF cl_null(l_lud07t) THEN LET l_lud07t = 0 END IF
         IF cl_null(l_lup.lup06) THEN LET l_lup.lup06 = 0 END IF
         IF cl_null(l_lup.lup07) THEN LET l_lup.lup07 = 0 END IF
         IF cl_null(l_lup.lup08) THEN LET l_lup.lup08 = 0 END IF
         LET l_lud.lud07t = l_lup.lup06 - l_lup.lup07 - l_lup.lup08 - l_lud07t
         IF l_lud.lud07t <= 0 THEN
            CONTINUE FOREACH  
         END IF 
         
         SELECT MAX(lud02)+1 INTO l_lud.lud02
           FROM lud_file
          WHERE lud01 = g_luc.luc01
         IF cl_null(l_lud.lud02) THEN 
            LET l_lud.lud02 = 1
         END IF 

         SELECT luo03 INTO l_luo03
           FROM luo_file
          WHERE luo01 = g_luc.luc11
         LET l_lud.lud01 = g_luc.luc01
         LET l_lud.lud03 = l_lup.lup01
         LET l_lud.lud04 = l_lup.lup02
         LET l_lud.lud05 = l_lup.lup05
         LET l_lud.lud07 = 0
         LET l_lud.ludplant = g_luc.lucplant 
         LET l_lud.ludlegal = g_luc.luclegal
         
         INSERT INTO lud_file VALUES l_lud.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","lud_file",g_luc.luc01,"",
                                          SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
   END FOREACH  
END FUNCTION 

#FUNCTION t615_generate_arrived()
#   DEFINE l_luc   RECORD LIKE luc_file.*,
#          l_lud   RECORD LIKE lud_file.*,
#          li_result      LIKE type_file.num5,
#          l_n            LIKE type_file.num5,
#          l_cnt          LIKE type_file.num5,
#          l_luk01        LIKE luk_file.luk01,
#          l_lud07t       LIKE lud_file.lud07t,  
#          l_sql          STRING 
#   DEFINE l_luk   RECORD LIKE luk_file.*
#   DEFINE l_lul   RECORD LIKE lul_file.*
#
#   SELECT * INTO l_luc.*
#     FROM luc_file
#    WHERE luc01 = g_luc.luc01
#
#   IF g_luc.lucplant <> g_plant THEN
#      CALL cl_err('','alm1023',0)
#      RETURN
#   END IF   
#   
#   IF g_luc.luc14='N' THEN
#      CALL cl_err('','aap-717',0)
#      RETURN
#   END IF 
#   
#   SELECT COUNT(*) INTO l_n FROM luk_file
#    WHERE luk05 = g_luc.luc01
#   IF l_n > 0 THEN 
#      CALL cl_err('','alm1345',0)
#      RETURN 
#   END IF
#   
#   LET g_success = 'Y' 
#   BEGIN WORK
#   
#   SELECT rye03 INTO g_luk01 FROM rye_file
#    WHERE rye01 = 'art' AND rye02 = 'B2'
#   LET g_dd = g_today
#   
#  # OPEN WINDOW t615_1_w WITH FORM "art/42f/artt615_1"
#  #  ATTRIBUTE(STYLE=g_win_style CLIPPED)
#  #  
#  # CALL cl_ui_locale("artt615_1")
#  # 
#  # DISPLAY g_luk01 TO FORMONLY.g_luk01
#  # DISPLAY g_dd TO FORMONLY.g_dd
#  # 
#  # INPUT  BY NAME g_luk01,g_dd   WITHOUT DEFAULTS
#  #    BEFORE INPUT
#  #    
#  #    AFTER FIELD g_luk01
#  #       LET l_cnt = 0
#  #       
#  #       SELECT COUNT(*) INTO  l_cnt FROM oay_file
#  #        WHERE oaysys ='art' AND oaytype ='B2' AND oayslip = g_luk01
#  #        
#  #       IF l_cnt = 0 THEN
#  #          CALL cl_err(g_luk01,'art-800',0)
#  #          NEXT FIELD g_luk01
#  #       END IF
#
#  #    ON ACTION CONTROLR
#  #       CALL cl_show_req_fields()
#
#  #    ON ACTION CONTROLG
#  #       CALL cl_cmdask()
#  #    ON ACTION CONTROLF
#  #       CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#  #                              RETURNING g_fld_name,g_frm_name
#  #       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#  #    ON ACTION controlp
#  #       CASE
#  #          WHEN INFIELD(g_luk01)
#  #             LET g_t1=s_get_doc_no(g_luk01)
#  #             CALL q_oay(FALSE,FALSE,g_t1,'B2','ART') RETURNING g_t1  
#  #             LET g_luk01=g_t1               
#  #             DISPLAY BY NAME g_luk01
#  #             NEXT FIELD g_luk01
#  #          OTHERWISE EXIT CASE
#  #       END CASE
#  #    ON IDLE g_idle_seconds
#  #       CALL cl_on_idle()
#  #       CONTINUE INPUT
#
#  #    ON ACTION about
#  #       CALL cl_about()
#
#  #    ON ACTION HELP
#  #       CALL cl_show_help()
#  # END INPUT
#  # 
#  # IF INT_FLAG THEN
#  #    LET INT_FLAG=0
#  #    CLOSE WINDOW t615_1_w
#  #    CALL cl_err('',9001,0)
#  #    LET g_success = 'N'
#  #    RETURN
#  # END IF
#  # 
#  # CLOSE WINDOW t615_1_w
#   
#   #自動編號
#   CALL s_check_no("art",g_luk01,"",'B2',"luk_file","luk01","")
#      RETURNING li_result,l_luk01
#      
#   LET g_t1=s_get_doc_no(g_luk01)
#   CALL s_auto_assign_no("art",g_luk01,g_dd,'B2',"luk_file","luk01","","","")
#      RETURNING li_result,l_luk.luk01
#      
#   IF NOT li_result THEN
#      CALL cl_err('','alm1346',0)
#      LET g_success = 'N'
#      RETURN
#   END IF
#
#   LET l_luk.luk02 = g_dd
#
#   IF g_ooz.ooz09 >= g_today THEN
#      LET l_luk.luk03 = g_ooz.ooz09 + 1
#   ELSE
#      LET l_luk.luk03 = g_today
#   END IF
#  
#   LET l_luk.luk04 = '2'
#   LET l_luk.luk05 = g_luc.luc01
#   LET l_luk.luk06 = g_luc.luc03
#   LET l_luk.luk07 = g_luc.luc05
#   LET l_luk.luk08 = g_luc.luc05
#   LET l_luk.luk09 = g_luc.luc22
#
#   SELECT SUM(lud07t) INTO l_lud07t 
#     FROM lud_file 
#    WHERE lud01 = g_luc.luc01
#
#   IF cl_null(l_lud07t) THEN
#      LET l_lud07t = 0
#   END IF
#   #LET l_luk.luk10 = l_lud07t
#   LET l_luk.luk11 = 0
#   LET l_luk.luk12 = 0
#   LET l_luk.luk13 = g_luc.luc26
#   LET l_luk.luk14 = g_luc.luc27
#   LET l_luk.luk15 = NULL
#   LET l_luk.lukacti = 'Y'
#   LET l_luk.lukcond = g_today
#   LET l_luk.lukconf = 'Y'
#   LET l_luk.lukcont = TIME 
#   LET l_luk.lukconu = g_user
#   LET l_luk.lukcrat = g_today
#   LET l_luk.lukdate = g_today
#   LET l_luk.lukgrup = g_grup
#   LET l_luk.luklegal = g_legal
#   LET l_luk.lukmksg = '1'
#   LET l_luk.lukmodu = NULL
#   LET l_luk.lukorig = g_grup
#   LET l_luk.lukoriu = g_user
#   LET l_luk.lukplant = g_plant
#   LET l_luk.lukuser = g_user
#
#   LET l_sql = "SELECT * FROM lud_file",
#               " where lud01 = '",g_luc.luc01,"'",
#               #"   AND lud07t > 0 ",
#               " ORDER BY lud02 DESC"
#               
#   PREPARE t615_12_prepare FROM l_sql
#   DECLARE t615_12_cs CURSOR FOR t615_12_prepare
#   
#   LET l_cnt = 1 
#   LET l_luk.luk10 = 0
#   FOREACH t615_12_cs INTO l_lud.*
#   
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('','','t615_12_cs',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#
#      IF cl_null(l_lud.lud07t) THEN
#         LET l_lud.lud07t = 0
#      END IF 
#      LET l_lul.lul01 = l_luk.luk01
#      LET l_lul.lul02 = l_cnt 
#      LET l_lul.lul03 = g_luc.luc01
#      LET l_lul.lul04 = l_lud.lud02
#      LET l_lul.lul05 = l_lud.lud05
#      LET l_lul.lul06 = l_lud.lud07t
#      IF l_lul.lul06 = 0 THEN CONTINUE FOREACH END IF 
#      LET l_luk.luk10 = l_luk.luk10 + l_lul.lul06  
#      LET l_lul.lul07 = 0
#      LET l_lul.lul08 = 0
#      LET l_lul.lul09 = NULL
#      LET l_lul.lul10 = NULL 
#      LET l_lul.lullegal = g_legal
#      LET l_lul.lulplant = g_plant
#
#      INSERT INTO lul_file VALUES l_lul.*
#      #INSERT INTO lul_file(lul01,lul02,lul03,lul04,lul05,lul06,lul07,
#      #                     lul08,lul09,lul10,lullegal,lulplant)
#      #   values(l_luk01,l_cnt,g_luc.luc01,l_lud.lud02,l_lud.lud05,
#      #           l_lud.lud07t,0,0,'','',g_legal,g_plant) 
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         #CALL cl_err('ins lul_file:',SQLCA.SQLCODE,0)
#         CALL s_errmsg('','','ins lul',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#         CONTINUE FOREACH 
#         #RETURN
#      END IF    
#         LET l_cnt = l_cnt + 1          
#   END FOREACH          
#   IF l_cnt = 1 THEN RETURN END IF 
#
#   INSERT INTO luk_file VALUES l_luk.*  
#    
#   #INSERT INTO luk_file(luk01,luk02,luk03,luk04,luk05,luk06,luk07,luk08,luk09,
#   #                     luk10,luk11,luk12,luk13,luk14,luk15,lukacti,lukcond,
#   #                     lukconf,lukcont,lukconu,lukcrat,lukdate,lukgrup,
#   #                     luklegal,lukmksg,lukmodu,lukorig,lukoriu,lukplant,
#   #                     lukuser)
#    #VALUES(l_luk01,g_dd,g_today,'2',g_luc.luc01,g_luc.luc03,g_luc.luc05,
#    #       g_luc.luc04,g_luc.luc22,l_lud07t,0,0,g_luc.luc26,g_luc.luc27,'',
#    #       'Y','','N','','',g_today,g_today,g_grup,g_legal,'N','',g_grup,g_user,
#    #      g_plant,g_user)
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      #CALL cl_err('insert luk_file:',SQLCA.SQLCODE,0)
#      CALL s_errmsg('','','ins luk',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#
#   
#END FUNCTION 

FUNCTION t615_qry_arrived()
   DEFINE l_cmd      STRING

   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #FUN-C30072--start add------------------------------
   IF g_luc.luc25 = 'N' THEN
      CALL cl_err('','art1067',0)
   ELSE 
   #FUN-C30072--end add--------------------------------
      LET l_cmd = "artt612 '",g_luc.luc01 CLIPPED ,"'"
      CALL cl_cmdrun(l_cmd)
   END IF                                            #FUN-C30072 add
END FUNCTION 

FUNCTION t615_upd()
   DEFINE l_sql         STRING,
          l_luc23       LIKE luc_file.luc23,
          l_amt         LIKE luc_file.luc23,
          l_amt1        LIKE luc_file.luc23,
          l_amt1_1      LIKE lud_file.lud07t,
          l_amt2        LIKE luc_file.luc23,
          l_lus05       LIKE lus_file.lus05,
          l_lus06       LIKE lus_file.lus06,
          l_lup06       LIKE lup_file.lup06,
          l_lup07       LIKE lup_file.lup07,
          l_lup08       LIKE lup_file.lup08
   DEFINE l_lud  RECORD LIKE lud_file.*

   LET l_sql = " SELECT *",
               "   FROM lud_file ",
               "  WHERE lud01 = '",g_luc.luc01,"'"

   DECLARE t615_upd_cs CURSOR FROM l_sql

   LET l_luc23 = 0
   LET l_amt1 = 0
   LET l_amt = 0
   LET l_amt1_1 = 0
   
   FOREACH t615_upd_cs INTO l_lud.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      CASE g_luc.luc10
         WHEN '1'
            SELECT lup06,lup07,lup08 INTO l_lup06,l_lup07,l_lup08
              FROM lup_file
             WHERE lup01 = l_lud.lud03
               AND lup02 = l_lud.lud04
    
            IF cl_null(l_lup06) THEN
               LET l_lup06 = 0
            END IF 

            IF cl_null(l_lup07) THEN
               LET l_lup07 = 0
            END IF

            IF cl_null(l_lup08) THEN
               LET l_lup08 = 0
            END IF

            LET l_amt = l_amt + l_lup06
            LET l_amt1_1 = l_lup06 - l_lup07 -l_lup08
            LET l_amt1 = l_amt1 + l_amt1_1 
         WHEN '2' 
            SELECT lus05,lus06 INTO l_lus05,l_lus06
              FROM lus_file
             WHERE lus01 = l_lud.lud03
               AND lus02 = l_lud.lud04

            IF cl_null(l_lus05) THEN
               LET l_lus05 = 0 
            END IF 

            IF cl_null(l_lus06) THEN
               LET l_lus06 = 0
            END IF  

            LET l_amt = l_amt + l_lus05
            LET l_amt1= l_amt1 + l_lus05 - l_lus06      
      END CASE 
      
      IF cl_null(l_lud.lud07t) THEN 
         LET l_lud.lud07t = 0
      END IF
      
      LET l_luc23 = l_luc23 + l_lud.lud07t
   END FOREACH

   LET g_luc.luc23 = l_luc23
   LET l_amt2 = g_luc.luc23 - g_luc.luc24
   
   UPDATE luc_file
      SET luc23 = l_luc23
    WHERE luc01 = g_luc.luc01

   DISPLAY BY NAME g_luc.luc23
   DISPLAY l_amt2 TO FORMONLY.amt2
   DISPLAY l_amt TO FORMONLY.amt
   DISPLAY l_amt1 TO FORMONLY.amt1
END FUNCTION

#FUN-BB0117 Add Begin ---
FUNCTION t615_refund()

   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF

   SELECT * INTO g_luc.* FROM luc_file WHERE luc01 = g_luc.luc01

   IF g_luc.luc14 = 'Y' THEN
      CALL cl_err('','art-812',1)
      RETURN
   END IF
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_luc.luc25 = 'Y' THEN
      CALL cl_err('','alm1375',1)
      RETURN
   END IF

   BEGIN WORK
   OPEN t615_cl USING g_luc.luc01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:",STATUS,1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   FETCH t615_cl INTO g_luc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL s_pay('08',g_luc.luc01,g_luc.lucplant,g_luc.luc23,g_luc.luc14)

   CALL t615_upd_money()

   CLOSE t615_cl
   COMMIT WORK
END FUNCTION

FUNCTION t615_upd_money()

   SELECT SUM(rxx04) INTO g_luc.luc24
     FROM rxx_file
    WHERE rxx00 = '08'
      AND rxx01 = g_luc.luc01 AND rxxplant = g_luc.lucplant
   IF cl_null(g_luc.luc24) THEN LET g_luc.luc24 = 0 END IF

   UPDATE luc_file SET luc24 = g_luc.luc24
    WHERE luc01 = g_luc.luc01

   CALL t615_show()
END FUNCTION

# By shi
#审核
FUNCTION t615_confirm()
 DEFINE l_gen02_1        LIKE gen_file.gen02
 DEFINE l_amt2           LIKE luc_file.luc23

   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
#CHI-C30107 ------------ add ------------- begin
   IF g_luc.luc14 = 'Y' THEN
      CALL cl_err(g_luc.luc01,'alm-005',1)
      RETURN
   END IF
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_luc.luc25 = 'N' THEN
      IF cl_null(g_luc.luc24) OR g_luc.luc24 = 0 OR g_luc.luc24<>g_luc.luc23 THEN 
         CALL cl_err('','alm1374',0)
         RETURN
      END IF
   END IF
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
#CHI-C30107 ------------ add ------------- end
   SELECT * INTO g_luc.* FROM luc_file
    WHERE luc01 = g_luc.luc01
   
   IF g_luc.luc14 = 'Y' THEN
      CALL cl_err(g_luc.luc01,'alm-005',1)
      RETURN
   END IF
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_luc.luc25 = 'N' THEN
     #IF cl_null(g_luc.luc24) OR g_luc.luc24 = 0 THEN                             #TQC-C30027
      IF cl_null(g_luc.luc24) OR g_luc.luc24 = 0 OR g_luc.luc24<>g_luc.luc23 THEN #TQC-C30027
         CALL cl_err('','alm1374',0)
         RETURN 
      END IF  
   END IF  

   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success = 'Y'
   
   OPEN t615_cl USING g_luc.luc01
   IF STATUS THEN 
      CALL cl_err("open t615_cl:",STATUS,1)
      CLOSE t615_cl
      ROLLBACK WORK 
      RETURN 
   END IF 
    
   FETCH t615_cl INTO g_luc.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN 
   END IF    
  
#CHI-C30107 -------- mark ----------- begin
#  IF NOT cl_confirm("alm-006") THEN
#      RETURN
#  END IF
#CHI-C30107 -------- mark ----------- end

   LET g_luc.luc14 = 'Y'
   LET g_luc.luc15 = g_user
   LET g_luc.luc16 = g_today
   LET g_luc.luccont = TIME 
   UPDATE luc_file
      SET luc14 = g_luc.luc14,
          luc15 = g_luc.luc15,
          luc16 = g_luc.luc16,
          luccont = g_luc.luccont
     WHERE luc01= g_luc.luc01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd luc:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
   END IF 

   IF g_luc.luc25 = 'Y' THEN
      CALL t615_ins_luklul() 
   END IF
   
   IF g_success = 'Y' THEN
      CALL t615_confirm_upd('1')
      UPDATE luc_file
         SET luc24 = luc23
       WHERE luc01= g_luc.luc01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd luc:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         LET g_luc.luc24 = g_luc.luc23
      END IF
   END IF
   
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      SELECT gen02 INTO l_gen02_1
        FROM gen_file
       WHERE gen01 = g_luc.luc15
      COMMIT WORK
      CALL cl_err('','abm-983',0)
   ELSE
      LET g_luc.luc14 = "N"
      LET g_luc.luc15 = NULL
      LET g_luc.luc16 = NULL
      LET g_luc.luccont = NULL
      LET l_gen02_1 = NULL
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_luc.luc14,g_luc.luc15,g_luc.luc16,
                   g_luc.luccont,g_luc.luc24
   DISPLAY l_gen02_1 TO FORMONLY.gen02_1
   LET l_amt2 = g_luc.luc23-g_luc.luc24
   DISPLAY l_amt2 TO FORMONLY.amt2
   CALL cl_set_field_pic(g_luc.luc14,"","","","","")                
   CLOSE t615_cl
END FUNCTION

FUNCTION t615_confirm_upd(p_type)
 DEFINE p_type         LIKE type_file.chr1
 DEFINE l_lua          RECORD LIKE lua_file.*
 DEFINE l_lub          RECORD LIKE lub_file.*
 DEFINE l_lud          RECORD LIKE lud_file.*
 DEFINE l_luo          RECORD LIKE luo_file.*
 DEFINE l_lup          RECORD LIKE lup_file.*
 DEFINE l_liw          RECORD LIKE liw_file.*
 DEFINE l_lij05        LIKE lij_file.lij05
 DEFINE l_lla05        LIKE lla_file.lla05
 DEFINE l_lul08        LIKE lul_file.lul08
 DEFINE l_luq10        LIKE luq_file.luq10
 DEFINE l_lub09        LIKE lub_file.lub09      #FUN-C30072 add 

   SELECT lla05 INTO l_lla05 FROM lla_file WHERE llastore = g_luc.lucplant
   LET g_sql = "SELECT * FROM lud_file" ,
               " WHERE lud01 = '",g_luc.luc01,"'"
   PREPARE t615_confirm_upd_p FROM g_sql
   DECLARE t615_confirm_upd_cs CURSOR FOR t615_confirm_upd_p
   FOREACH t615_confirm_upd_cs INTO l_lud.*
      IF STATUS THEN
         CALL s_errmsg('','','t615_confirm_upd_cs',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      
      CASE g_luc.luc10
         WHEN '1'
         #来源类型是1:支出单，更新支出单单身已退金额，单头已退金额，单头结案
         #在看支出单来源类型1:待抵单,更新待抵单单身和单头已退金额
         #                  2:费用单,更新费用单单身已收金额/结案,单头已收金额/结案
         #                    再根据费用单抓合同账单，更新已收金额/结案
            SELECT lup_file.*,luo_file.* INTO l_lup.*,l_luo.* FROM lup_file,luo_file
             WHERE lup01 = luo01
               AND lup01 = l_lud.lud03
               AND lup02 = l_lud.lud04
            IF cl_null(l_lup.lup07) THEN LET l_lup.lup07 = 0 END IF
            IF p_type = '1' THEN
               LET l_lup.lup07 = l_lup.lup07+l_lud.lud07t
            ELSE
               LET l_lup.lup07 = l_lup.lup07-l_lud.lud07t
            END IF
            UPDATE lup_file SET lup07 = l_lup.lup07
             WHERE lup01 = l_lud.lud03
               AND lup02 = l_lud.lud04
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_lud.lud03,'/',l_lud.lud04
               CALL s_errmsg('lup01,lup02',g_showmsg,"upd lup_file",SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            IF cl_null(l_luo.luo10) THEN LET l_luo.luo10 = 0 END IF
            IF p_type = '1' THEN
               LET l_luo.luo10 = l_luo.luo10+l_lud.lud07t
            ELSE
               LET l_luo.luo10 = l_luo.luo10-l_lud.lud07t
            END IF
            IF l_luo.luo09 = l_luo.luo10+l_luo.luo11 THEN
               LET l_luo.luo15 = '2'
            ELSE
               LET l_luo.luo15 = '1'
            END IF
            #更新支出单单头已退金额和状况码结案
            UPDATE luo_file SET luo10 = l_luo.luo10,
                                luo15 = l_luo.luo15
             WHERE luo01 = l_lud.lud03
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_lud.lud03
               CALL s_errmsg('luo01',g_showmsg,"upd luo_file",SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            #再看支出单的来源(1.待抵单,2.费用单)，更新对应的单据
            IF l_luo.luo03 = '1' THEN
               #更新待抵单单头和单身的已退款金额
               IF p_type = '1' THEN
                  LET l_lul08 = l_lud.lud07t
               ELSE
                  LET l_lul08 = -l_lud.lud07t
               END IF
               UPDATE lul_file SET lul08 = lul08+l_lul08
                WHERE lul01 = l_lup.lup03
                  AND lul02 = l_lup.lup04
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_lup.lup03,'/',l_lup.lup04
                  CALL s_errmsg('lul01,lul02',g_showmsg,"upd lul_file",SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
               UPDATE luk_file SET luk12 = luk12+l_lul08
                WHERE luk01 = l_lup.lup03
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_lup.lup03
                  CALL s_errmsg('luk01',g_showmsg,"upd luk_file",SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF
            IF l_luo.luo03 = '2' THEN
               #更新费用单单头单身金额
               SELECT lua_file.*,lub_file.* INTO l_lua.*,l_lub.*
                 FROM lua_file,lub_file
                WHERE lua01 = lub01
                  AND lua01 = l_lup.lup03
                  AND lub02 = l_lup.lup04
               IF cl_null(l_lub.lub11) THEN LET l_lub.lub11 = 0 END IF
               #FUN-C30072--start add----------------------------------
               SELECT lub09 INTO l_lub09
                 FROM lub_file
                WHERE lub01 = l_lup.lup03
                  AND lub02 = l_lup.lup04

               IF l_lub09 = '10' THEN
                  IF p_type = '1' THEN  
                     LET l_lub.lub11 = l_lub.lub11 + l_lud.lud07t
                  ELSE 
                     LET l_lub.lub11 = l_lub.lub11 - l_lud.lud07t
                  END IF 
               ELSE
                  IF p_type = '1' THEN
                     LET l_lub.lub11 = l_lub.lub11 - l_lud.lud07t   
                  ELSE
                     LET l_lub.lub11 = l_lub.lub11 + l_lud.lud07t
                  END IF
               END IF               
               #FUN-C30072--end add------------------------------------
               #FUN-C30072--start mark-----------------------------------------
               #IF p_type = '1' THEN #因为负的金额才可以支出，支出单显示的是正的
               #   LET l_lub.lub11 = l_lub.lub11-l_lud.lud07t
               #ELSE
               #   LET l_lub.lub11 = l_lub.lub11+l_lud.lud07t
               #END IF
               #FUN-C30072--end mark--------------------------------------------
               IF l_lub.lub04t = l_lub.lub11+l_lub.lub12 THEN
                  LET l_lub.lub13 = 'Y'
               ELSE
                  LET l_lub.lub13 = 'N'
               END IF
               UPDATE lub_file SET lub11 = l_lub.lub11,
                                   lub13 = l_lub.lub13
                WHERE lub01 = l_lup.lup03
                  AND lub02 = l_lup.lup04
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_lup.lup03,'/',l_lup.lup04
                  CALL s_errmsg('lub01,lub02',g_showmsg,"upd lub_file",SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
               IF cl_null(l_lua.lua35) THEN LET l_lua.lua35 = 0 END IF
               IF p_type = '1' THEN
                  LET l_lua.lua35 = l_lua.lua35-l_lud.lud07t
               ELSE
                  LET l_lua.lua35 = l_lua.lua35+l_lud.lud07t
               END IF
               IF l_lua.lua08t = l_lua.lua35+l_lua.lua36 THEN
                  LET l_lua.lua14 = '2'
               ELSE
                  LET l_lua.lua14 = '1'
               END IF
               UPDATE lua_file SET lua35 = l_lua.lua35,
                                   lua14 = l_lua.lua14
                WHERE lua01 = l_lup.lup03
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_lup.lup03
                  CALL s_errmsg('lua01',g_showmsg,"upd lua_file",SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
               
               #更新账单已收金额和结案
               IF cl_null(l_lua.lua33) OR cl_null(l_lua.lua34) THEN CONTINUE FOREACH END IF
               #账单是否按自然月拆分lla05不同，抓取账单的SQL也不同
               SELECT lij05 INTO l_lij05 FROM lij_file,lua_file,lnt_file
                WHERE lua04 = lnt01
                  AND lnt71 = lij01
                  AND lij02 = l_lub.lub03
                  AND lua01 = l_lua.lua01
               IF l_lla05 = 'N' OR l_lij05 = '1' THEN #收付实现制也不拆分
                  SELECT liw_file.* INTO l_liw.* FROM liw_file,lub_file,lua_file
                   WHERE lua01 = lub01
                     AND lub01 = l_lub.lub01
                     AND lub02 = l_lub.lub02
                     AND liw05 = lua33       #帐期
                     AND liw06 = lua34       #出账日
                     AND liw02 = lub16       #合同版本号
                     AND liw16 = l_lub.lub01 #费用单号
                     AND liw04 = l_lub.lub03 #费用编号
               ELSE
                  SELECT liw_file.* INTO l_liw.* FROM liw_file,lub_file,lua_file
                   WHERE lua01 = lub01
                     AND lub01 = l_lub.lub01
                     AND lub02 = l_lub.lub02
                     AND liw05 = lua33       #帐期
                     AND liw06 = lua34       #出账日
                     AND liw02 = lub16       #合同版本号
                     AND liw16 = l_lub.lub01 #费用单号
                     AND liw04 = l_lub.lub03 #费用编号
                     AND liw07 = lub07       #开始日期
                     AND liw08 = lub08       #结束日期
               END IF
               IF cl_null(l_liw.liw14) THEN LET l_liw.liw14 = 0 END IF
               IF cl_null(l_liw.liw15) THEN LET l_liw.liw15 = 0 END IF

               IF p_type = '1' THEN
                  LET l_liw.liw14 = l_liw.liw14 - l_lud.lud07t
               ELSE
                  LET l_liw.liw14 = l_liw.liw14 + l_lud.lud07t
               END IF
               IF l_liw.liw13 = l_liw.liw14 + l_liw.liw15 THEN
                  LET l_liw.liw17 = 'Y'
               ELSE
                  LET l_liw.liw17 = 'N'
               END IF
               UPDATE liw_file SET liw14 = l_liw.liw14,
                                   liw17 = l_liw.liw17
                 WHERE liw01 = l_liw.liw01
                   AND liw03 = l_liw.liw03
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_liw.liw01,'/',l_liw.liw03
                  CALL s_errmsg('liw01,liw03',g_showmsg,'upd liw_file','',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
            END IF
         WHEN '2'
         #来源类型是2:终止结算，更新终止结算单单头单身的已退金额
            IF p_type = '1' THEN
               LET l_luq10 = l_lud.lud07t
            ELSE
               LET l_luq10 = -l_lud.lud07t
            END IF
            UPDATE luq_file SET luq10 = luq10 + l_luq10
             WHERE luq01 = l_lud.lud03
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_lud.lud03
               CALL s_errmsg('luq01',g_showmsg,"upd luq_file",SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            #因为现在只能一次性退款，不可以录多笔退款单
            IF p_type = '1' THEN
               UPDATE lus_file SET lus06 = lus05
                WHERE lus01 = l_lud.lud03
            ELSE
               UPDATE lus_file SET lus06 = 0
                WHERE lus01 = l_lud.lud03
            END IF
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_lud.lud03
               CALL s_errmsg('lus01',g_showmsg,"upd lus_file",SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
      END CASE
   END FOREACH
END FUNCTION

FUNCTION t615_ins_luklul()
 DEFINE li_result      LIKE type_file.num5,
        l_n            LIKE type_file.num5,
        l_cnt          LIKE type_file.num5,
        l_luk01        LIKE luk_file.luk01
 DEFINE l_luk   RECORD LIKE luk_file.*
 DEFINE l_lul   RECORD LIKE lul_file.*
 DEFINE l_lud     RECORD LIKE lud_file.*

  #FUN-C90050 mark begin--- 
  #SELECT rye03 INTO g_luk01 FROM rye_file
  # WHERE rye01 = 'art' AND rye02 = 'B2'
  #FUN-C90050 mark end----

   CALL s_get_defslip('art','B2',g_plant,'N') RETURNING g_luk01       #FUN-C90050 add

   LET g_dd = g_today
   
  # OPEN WINDOW t615_1_w WITH FORM "art/42f/artt615_1"
  #  ATTRIBUTE(STYLE=g_win_style CLIPPED)
  #  
  # CALL cl_ui_locale("artt615_1")
  # 
  # DISPLAY g_luk01 TO FORMONLY.g_luk01
  # DISPLAY g_dd TO FORMONLY.g_dd
  # 
  # INPUT  BY NAME g_luk01,g_dd   WITHOUT DEFAULTS
  #    BEFORE INPUT
  #    
  #    AFTER FIELD g_luk01
  #       LET l_cnt = 0
  #       
  #       SELECT COUNT(*) INTO  l_cnt FROM oay_file
  #        WHERE oaysys ='art' AND oaytype ='B2' AND oayslip = g_luk01
  #        
  #       IF l_cnt = 0 THEN
  #          CALL cl_err(g_luk01,'art-800',0)
  #          NEXT FIELD g_luk01
  #       END IF

  #    ON ACTION CONTROLR
  #       CALL cl_show_req_fields()

  #    ON ACTION CONTROLG
  #       CALL cl_cmdask()
  #    ON ACTION CONTROLF
  #       CALL cl_set_focus_form(ui.Interface.getRootNode()) 
  #                              RETURNING g_fld_name,g_frm_name
  #       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

  #    ON ACTION controlp
  #       CASE
  #          WHEN INFIELD(g_luk01)
  #             LET g_t1=s_get_doc_no(g_luk01)
  #             CALL q_oay(FALSE,FALSE,g_t1,'B2','ART') RETURNING g_t1  
  #             LET g_luk01=g_t1               
  #             DISPLAY BY NAME g_luk01
  #             NEXT FIELD g_luk01
  #          OTHERWISE EXIT CASE
  #       END CASE
  #    ON IDLE g_idle_seconds
  #       CALL cl_on_idle()
  #       CONTINUE INPUT

  #    ON ACTION about
  #       CALL cl_about()

  #    ON ACTION HELP
  #       CALL cl_show_help()
  # END INPUT
  # 
  # IF INT_FLAG THEN
  #    LET INT_FLAG=0
  #    CLOSE WINDOW t615_1_w
  #    CALL cl_err('',9001,0)
  #    LET g_success = 'N'
  #    RETURN
  # END IF
  # 
  # CLOSE WINDOW t615_1_w
   
   #自動編號
   CALL s_check_no("art",g_luk01,"",'B2',"luk_file","luk01","")
      RETURNING li_result,l_luk01
      
   LET g_t1=s_get_doc_no(g_luk01)
   CALL s_auto_assign_no("art",g_luk01,g_dd,'B2',"luk_file","luk01","","","")
      RETURNING li_result,l_luk.luk01
      
   IF NOT li_result THEN
      CALL cl_err('','alm1346',0)
      LET g_success = 'N'
      RETURN
   END IF

   LET l_luk.luk02 = g_dd

   IF g_ooz.ooz09 >= g_today THEN
      LET l_luk.luk03 = g_ooz.ooz09 + 1
   ELSE
      LET l_luk.luk03 = g_today
   END IF
  
   LET l_luk.luk04 = '2'
   LET l_luk.luk05 = g_luc.luc01
   LET l_luk.luk06 = g_luc.luc03
   LET l_luk.luk07 = g_luc.luc05
   LET l_luk.luk08 = g_luc.luc05
   LET l_luk.luk09 = g_luc.luc22
  #LET l_luk.luk10 =
   LET l_luk.luk11 = 0
   LET l_luk.luk12 = 0
   LET l_luk.luk13 = g_luc.luc26
   LET l_luk.luk14 = g_luc.luc27
   LET l_luk.luk15 = NULL
   LET l_luk.lukacti = 'Y'
   LET l_luk.lukcond = g_today
   LET l_luk.lukconf = 'Y'
   LET l_luk.lukcont = TIME 
   LET l_luk.lukconu = g_user
   LET l_luk.lukcrat = g_today
   LET l_luk.lukdate = g_today
   LET l_luk.lukgrup = g_grup
   LET l_luk.luklegal = g_legal
   LET l_luk.lukmksg = '1'
   LET l_luk.lukmodu = NULL
   LET l_luk.lukorig = g_grup
   LET l_luk.lukoriu = g_user
   LET l_luk.lukplant = g_plant
   LET l_luk.lukuser = g_user

   LET g_sql = "SELECT * FROM lud_file",
               " where lud01 = '",g_luc.luc01,"'",
               #"   AND lud07t > 0 ",
               " ORDER BY lud02 DESC"
   PREPARE t615_12_prepare FROM g_sql
   DECLARE t615_12_cs CURSOR FOR t615_12_prepare
   
   LET l_cnt = 1 
   LET l_luk.luk10 = 0
   FOREACH t615_12_cs INTO l_lud.*
   
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','t615_12_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF cl_null(l_lud.lud07t) THEN
         LET l_lud.lud07t = 0
      END IF 
      LET l_lul.lul01 = l_luk.luk01
      LET l_lul.lul02 = l_cnt 
      LET l_lul.lul03 = g_luc.luc01
      LET l_lul.lul04 = l_lud.lud02
      LET l_lul.lul05 = l_lud.lud05
      LET l_lul.lul06 = l_lud.lud07t
      IF l_lul.lul06 = 0 THEN CONTINUE FOREACH END IF 
      LET l_luk.luk10 = l_luk.luk10 + l_lul.lul06  
      LET l_lul.lul07 = 0
      LET l_lul.lul08 = 0
      LET l_lul.lul09 = NULL
      LET l_lul.lul10 = NULL 
      LET l_lul.lullegal = g_legal
      LET l_lul.lulplant = g_plant

      INSERT INTO lul_file VALUES l_lul.*
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','ins lul',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF    
         LET l_cnt = l_cnt + 1          
   END FOREACH          
   IF l_cnt = 1 THEN RETURN END IF 

   INSERT INTO luk_file VALUES l_luk.* 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','','ins luk',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

#取消审核
FUNCTION t615_unconfirm()
 DEFINE l_amt2           LIKE luc_file.luc23
 DEFINE l_gen02          LIKE gen_file.gen02     #CHI-D20015
   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_luc.* FROM luc_file
    WHERE luc01 = g_luc.luc01
   IF g_luc.luc14 = 'N' THEN
      CALL cl_err(g_luc.luc01,'alm-007',1)
      RETURN
   END IF
   IF g_luc.luc14 = 'X' THEN RETURN END IF  #CHI-C80041
#TQC-C40008 add str-------
   IF NOT cl_null(g_luc.luc28) THEN
      CALL cl_err(g_luc.luc01,'axm-316',1)
      RETURN
   END IF 
#TQC-C40008 add end-------
   
   IF g_luc.luc25 ='Y' THEN
      #如果待抵单有支出，不可取消审核
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt
        FROM lup_file,luo_file,lul_file
       WHERE luo01 = lup01
         AND lup03 = lul01
         AND luo03 = '1'
         AND lul03 = g_luc.luc01
         AND luoconf <> 'X' #CHI-C80041
      IF g_cnt > 0 THEN
         CALL cl_err('','alm1372',0)
         RETURN
      END IF
      
      #该待抵单已用于交款，不可取消审核
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt
        FROM rxy_file,lul_file
       WHERE lul01 = rxy06
         AND lul03 = g_luc.luc01
         AND rxy03 = '07'
         AND rxy19 = '3'
      IF g_cnt > 0 THEN
         CALL cl_err('','alm1373',0)
         RETURN
      END IF
      
      #待抵单有变更，不允许取消审核
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt
        FROM lun_file,lul_file
       WHERE lun03 = lul01
         AND lul03 = g_luc.luc01
      IF g_cnt > 0 THEN
         CALL cl_err('','alm1378',0)
         RETURN
      END IF
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   
   OPEN t615_cl USING g_luc.luc01
   IF STATUS THEN 
      CALL cl_err("open t615_cl:",STATUS,1)
      CLOSE t615_cl
      ROLLBACK WORK 
      RETURN 
   END IF
   
   FETCH t615_cl INTO g_luc.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN 
   END IF    
    
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   END IF
  
   LET g_luc.luccont = TIME   #CHI-D20015 
   UPDATE luc_file
      SET luc14 = 'N',
         #CHI-D20015---MOD--STR 
         #luc15 = NULL,
         #luc16 = NULL,
         #luccont = NULL,
          luc15 = g_user,
          luc16 = g_today,
          luccont = g_luc.luccont,
         #CHI-D20015---MOD--END
          lucmodu = g_luc.lucmodu,
          lucdate = g_luc.lucdate
    WHERE luc01 = g_luc.luc01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','','upd luc_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   
   IF g_success = 'Y' THEN
      CALL t615_confirm_upd('2')
   END IF
   IF g_success = 'Y' AND g_luc.luc25 = 'Y' THEN
      DELETE FROM lul_file WHERE lul03 = g_luc.luc01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','del lul_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DELETE FROM luk_file WHERE luk05 = g_luc.luc01
                             AND luk04 = '2'
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('','','del luk_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      
      UPDATE luc_file
         SET luc24 = 0
       WHERE luc01= g_luc.luc01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd luc:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         LET g_luc.luc24 = 0
      END IF
   END IF
   CALL s_showmsg()
   IF g_success = 'Y' THEN 
      COMMIT WORK
      LET g_luc.luc14 = "N"
     #CHI-D20015---mod--str 
     #LET g_luc.luc15 = NULL
     #LET g_luc.luc16 = NULL
     #LET g_luc.luccont = NULL
      LET g_luc.luc15 = g_user
      LET g_luc.luc16 = g_today
      LET g_luc.luccont = TIME
     #CHI-D20015---mod--end
      LET g_luc.lucmodu = g_user
      LET g_luc.lucdate = g_today
   ELSE
      ROLLBACK WORK
   END IF
  #DISPLAY '' TO FORMONLY.gen02_1                                    #CHI-D20015
  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_luc.luc15  #CHI-D20015
   DISPLAY l_gen02 TO FORMONLY.gen02_1                               #CHI-D20015
   DISPLAY BY NAME g_luc.luc14,g_luc.luc15,g_luc.luc16,g_luc.luccont,
                   g_luc.lucmodu,g_luc.lucdate,g_luc.luc24
   LET l_amt2 = g_luc.luc23-g_luc.luc24
   DISPLAY l_amt2 TO FORMONLY.amt2
   CALL cl_set_field_pic(g_luc.luc14,"","","","","")
   CLOSE t615_cl
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-C20020--add-str
FUNCTION t615_axrp603()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_azp01 LIKE azp_file.azp01
   DEFINE li_sql STRING
   DEFINE li_str STRING
   DEFINE li_wc STRING
   DEFINE li_wc2 STRING 
   DEFINE l_lud06 LIKE lud_file.lud06
   DEFINE l_lud10 LIKE lud_file.lud10
   DEFINE l_ar_slip LIKE ooa_file.ooa01
   DEFINE l_ar_slip2 LIKE ooa_file.ooa01
   DEFINE l_luc28    LIKE luc_file.luc28
   
   IF s_shut(0) THEN
       RETURN
    END IF
   IF cl_null(g_luc.luc01) OR cl_null(g_luc.luc11) THEN 
      RETURN 
   END IF
   #TQC-C20430--add--begin
   IF g_luc.luc14 !='Y' THEN
      RETURN
   END IF
   #TQC-C20430--add--end

   #FUN-C30029--add--str--
   IF NOT cl_null(g_luc.luc28) THEN 
      CALL cl_err('','aim-162',1)
      RETURN
   END IF 
   #FUN-C30029--add--end--

   #FUN-c30029--mark--str--
   #LET g_sql =" SELECT lud06,lud10",
   #           "   FROM luc_file,lud_file",
   #           "  WHERE luc01 = lud01",
   #           "    AND luc01 ='",g_luc.luc01,"'"
   #PREPARE p615_lud_pre FROM g_sql
   #DECLARE p615_lud_cs CURSOR FOR p615_lud_pre
   #FOREACH p615_lud_cs INTO l_lud06,l_lud10
   #   IF NOT cl_null(l_lud06) OR NOT cl_null(l_lud10) THEN
   #      CALL cl_err('','aim-162',1)
   #      RETURN  
   #   END IF
   #END FOREACH    
   
   IF NOT (cl_confirm("axr119")) THEN 
      RETURN 
   END IF 
   SELECT azp01 INTO l_azp01 FROM azp_file,azw_file 
    WHERE azw01 = azp01 AND azw02 = g_legal AND azw01 = g_luc.lucplant
  #LET li_wc = " azp01 = '",l_azp01,"'"                                                                     #No.TQC-C30188   Mark
  #LET li_wc2 = " luc01 = '",g_luc.luc01,"' AND luc03 = '",g_luc.luc03,"' AND luc07 = '",g_luc.luc07,"'"    #no.TQC-C30188   Mark
   LET li_wc  = ' azp01 = "',l_azp01,'"'                                                                    #No.TQC-C30188   Add
   LET li_wc2 = ' luc01 = "',g_luc.luc01,'" AND luc03 = "',g_luc.luc03,'" AND luc07 = "',g_luc.luc07,'"'    #No.TQC-C30188   Add

   SELECT oow14 INTO l_ar_slip FROM oow_file
   IF SQLCA.sqlcode THEN 
      LET l_ar_slip = ""
   END IF
   SELECT oow15 INTO l_ar_slip2 FROM oow_file
   IF SQLCA.sqlcode THEN 
      LET l_ar_slip2 = ""
   END IF 
   
  #No.TQC-C30188   ---start---   Mark
  #LET li_str = "axrp603 ",
  #             ' "',li_wc,'" ',
  #             ' "',li_wc2,'" ',
  #             ' "',l_ar_slip,'" ',
  #             ' "',l_ar_slip2,'" ',
  #             ' "Y" '
  #No.TQC-C30188   ---start---   Mark
   LET li_str = "axrp603 '",li_wc CLIPPED,"' '",li_wc2,"' '",l_ar_slip,"' '",l_ar_slip2,"' 'Y'"
   CALL cl_cmdrun_wait(li_str) 

   SELECT * INTO g_luc.* FROM luc_file WHERE luc01 = g_luc.luc01  #TQC-C20430
   CALL t615_show()  #TQC-C20430
   LET g_sql = " SELECT lud06,lud10,lud02 ",
               "   FROM luc_file,lud_file ",
               "  WHERE luc01 = lud01 ",
               "    AND luc01 = '",g_luc.luc01,"'" 
   PREPARE p615_luc_pre FROM g_sql
   DECLARE p615_luc_cs CURSOR FOR p615_luc_pre
   FOREACH p615_luc_cs INTO l_lud06,l_lud10,l_cnt
      LET g_lud[l_cnt].lud06 = l_lud06
      LET g_lud[l_cnt].lud10 = l_lud10
      DISPLAY BY NAME g_lud[l_cnt].lud06,g_lud[l_cnt].lud10
   END FOREACH 
END FUNCTION 
#FUN-C20020--add-end

#FUN-C30029--add--str
FUNCTION t615_axrp607()
   DEFINE l_str  STRING
   DEFINE l_wc   STRING
   DEFINE l_wc2  STRING
   DEFINE l_lud10 LIKE lud_file.lud10
   DEFINE l_luc28 LIKE luc_file.luc28
   DEFINE l_azp01 LIKE azp_file.azp01
   DEFINE l_luc01 LIKE luc_file.luc01
   DEFINE l_cnt   LIKE type_file.num5
   IF s_shut(0) THEN
       RETURN
   END IF
   IF cl_null(g_luc.luc01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF cl_null(g_luc.luc28) THEN 
      CALL cl_err('','axr-393',1)
      RETURN
   END IF 
   IF NOT (cl_confirm("axr-391")) THEN
      RETURN
   END IF
   LET l_wc = ''
   LET l_wc2 = ''
   LET l_str = ''
   LET l_azp01 = g_plant
   LET l_wc  = 'azp01 = "',l_azp01,'"'
   LET l_wc2 = 'luc01 = "',g_luc.luc01,'"'
   LET l_str = " axrp607 '",l_wc,"' '",l_wc2,"' 'Y'"
   
   CALL cl_cmdrun_wait(l_str)
   SELECT luc28 INTO l_luc28 FROM luc_file WHERE luc01 = g_luc.luc01
   DISPLAY l_luc28 TO luc28
   LET g_luc.luc28 = l_luc28

   SELECT * INTO g_luc.* FROM luc_file WHERE luc01 = g_luc.luc01
   CALL t615_show()
 
   LET g_sql = " SELECT lud10,lud02 ",
               "   FROM luc_file,lud_file ",
               "  WHERE luc01 = lud01 ",
               "    AND luc01 = '",g_luc.luc01,"'" 
   PREPARE p615_luc_pre_01 FROM g_sql
   DECLARE p615_luc_cs_01 CURSOR FOR p615_luc_pre_01
   FOREACH p615_luc_cs_01 INTO l_lud10,l_cnt
      LET g_lud[l_cnt].lud10 = l_lud10
      DISPLAY BY NAME g_lud[l_cnt].lud10
   END FOREACH 
END FUNCTION
#FUN-C30029--add--end

#FUN-CB0076-------add------str
FUNCTION t615_out()
DEFINE l_sql     STRING, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_occ02   LIKE occ_file.occ02,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_oaj05   LIKE oaj_file.oaj05,
       l_lup06   LIKE lup_file.lup06,
       l_lup07   LIKE lup_file.lup07,
       l_lup08   LIKE lup_file.lup08,
       l_amt     LIKE lup_file.lup06,
       sr        RECORD
          lucplant  LIKE luc_file.lucplant,
          luc01     LIKE luc_file.luc01,
          luc04     LIKE luc_file.luc04,
          luc03     LIKE luc_file.luc03,
          luc07     LIKE luc_file.luc07,
          luc05     LIKE luc_file.luc05,
          luc16     LIKE luc_file.luc16,
          luc15     LIKE luc_file.luc15,
          luccont   LIKE luc_file.luccont,
          lud02     LIKE lud_file.lud02,
          lud03     LIKE lud_file.lud03,
          lud04     LIKE lud_file.lud04,
          lud05     LIKE lud_file.lud05,
          lud07t    LIKE lud_file.lud07t,
          lud10     LIKE lud_file.lud10
                 END RECORD
                 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lucser', 'lucgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " luc01 = '",g_luc.luc01,"'" END IF
     LET l_sql = "SELECT lucplant,luc01,luc04,luc03,luc07,luc05,luc16,luc15,luccont,",
                 "       lud02,lud03,lud04,lud05,lud07t,lud10",
                 "  FROM luc_file,lud_file",
                 " WHERE luc01 = lud01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t615_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t615_cs1 CURSOR FOR t615_prepare1

     DISPLAY l_table
     FOREACH t615_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lucplant
       LET l_occ02 = ' '
       SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = sr.luc03
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.luc15
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.lud05
       LET l_oaj05 = ' '
       SELECT oaj05 INTO l_oaj05 FROM oaj_file WHERE oaj01 = sr.lud05
       LET l_lup06 = 0
       LET l_lup07 = 0
       LET l_lup08 = 0
       SELECT lup06,lup07,lup08 INTO l_lup06,l_lup07,l_lup08
         FROM lup_file
        WHERE lup01 = sr.lud03
          AND lup02 = sr.lud04
       LET l_amt = 0
       LET l_amt = l_lup06-l_lup07-l_lup08
       EXECUTE insert_prep USING sr.*,l_rtz13,l_occ02,l_gen02,l_oaj02,l_oaj05,l_lup06,l_lup07,l_lup08,l_amt
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'luc01,luc07,luc21,luc10,luc11,lucplant,luclegal,luc03,luc031,luc05,luc04,luc22,luc23,luc24,luc28,luc25,luc26,luc27,luc14,luc15,luc16,luccont,luc08,lucuser,lucgrup,lucoriu,lucmodu,lucdate,lucorig,lucacti,luccrat')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lud02,lud03,lud04,lud05,lud06,lud07t,lud10')
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
     CALL t615_grdata()
END FUNCTION

FUNCTION t615_grdata()
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
       LET handler = cl_gre_outnam("artt615")
       IF handler IS NOT NULL THEN
           START REPORT t615_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY luc01,lud02"
           DECLARE t615_datacur1 CURSOR FROM l_sql
           FOREACH t615_datacur1 INTO sr1.*
               OUTPUT TO REPORT t615_rep(sr1.*)
           END FOREACH
           FINISH REPORT t615_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t615_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lup06_sum   LIKE lup_file.lup06
    DEFINE l_lud07t_sum  LIKE lud_file.lud07t
    DEFINE l_lud10_sum   LIKE lud_file.lud10
    DEFINE l_amt_sum     LIKE lup_file.lup06
    DEFINE l_oaj05       STRING
    DEFINE l_plant       STRING
    
    ORDER EXTERNAL BY sr1.luc01,sr1.lud02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
            PRINTX g_wc3
            PRINTX g_wc4
              
        BEFORE GROUP OF sr1.luc01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            LET l_oaj05 = cl_gr_getmsg('gre-316',g_lang,sr1.oaj05)
            PRINTX l_lineno
            PRINTX l_oaj05
            PRINTX sr1.*
            LET l_plant = sr1.lucplant,' ',sr1.rtz13
            PRINTX l_plant

        AFTER GROUP OF sr1.luc01
            LET l_lup06_sum = GROUP SUM(sr1.lup06)
            LET l_lud07t_sum = GROUP SUM(sr1.lud07t)
            LET l_amt_sum = GROUP SUM(sr1.amt)
            PRINTX l_lup06_sum
            PRINTX l_lud07t_sum
            PRINTX l_amt_sum
            
        ON LAST ROW

END REPORT
#FUN-CB0076-------add------end
#CHI-C80041---begin
FUNCTION t615_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_luc.luc01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t615_cl USING g_luc.luc01
   IF STATUS THEN
      CALL cl_err("OPEN t615_cl:", STATUS, 1)
      CLOSE t615_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t615_cl INTO g_luc.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_luc.luc01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t615_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_luc.luc14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_luc.luc14)   THEN 
        LET l_chr=g_luc.luc14
        IF g_luc.luc14='N' THEN 
            LET g_luc.luc14='X' 
        ELSE
            LET g_luc.luc14='N'
        END IF
        UPDATE luc_file
            SET luc14=g_luc.luc14,  
                lucmodu=g_user,
                lucdate=g_today
            WHERE luc01=g_luc.luc01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","luc_file",g_luc.luc01,"",SQLCA.sqlcode,"","",1)  
            LET g_luc.luc14=l_chr 
        END IF
        DISPLAY BY NAME g_luc.luc14
   END IF
 
   CLOSE t615_cl
   COMMIT WORK
   CALL cl_flow_notify(g_luc.luc01,'V')
 
END FUNCTION
#CHI-C80041---end
