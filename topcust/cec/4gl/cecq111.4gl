# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cect001.4gl
# Descriptions...: 在制LOT清单交接表
# Date & Author..: 16/09/03 By lidj

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tc_ima           RECORD LIKE tc_ima_file.*,
    g_tc_ima_t         RECORD LIKE tc_ima_file.*,
    g_tc_ima_o         RECORD LIKE tc_ima_file.*,
    g_tc_ima01_t       LIKE tc_ima_file.tc_ima01,
    g_tc_imb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgm03               LIKE sgm_file.sgm03,          #       
        tc_imb03            LIKE tc_imb_file.tc_imb03,    #作业编号
        ecd02               LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        tc_imb04            LIKE tc_imb_file.tc_imb04,    #LOT单号
        tc_imb05            LIKE tc_imb_file.tc_imb05,    #工单单号
        sfb05               LIKE sfb_file.sfb05,          #生产料号 add by gujq 20160905
        ima02             LIKE ima_file.ima02,          #品名     add by gujq 20160905
        ima021            LIKE ima_file.ima021,         #规格     add by gujq 20160905
        tc_imb06            LIKE tc_imb_file.tc_imb06,    #扫入量
        tc_imb07            LIKE tc_imb_file.tc_imb07,    #开工量
        tc_imb08            LIKE tc_imb_file.tc_imb08,    #完工量
        tc_imb09            LIKE tc_imb_file.tc_imb09,    #扫出量
        tc_imb11            LIKE tc_imb_file.tc_imb11,    #报废量
        tc_imb12            LIKE tc_imb_file.tc_imb12,    #返工量  #add by guanyao160922
        tc_imb10            LIKE tc_imb_file.tc_imb10     #WIP量
        ,tc_imb13           LIKE tc_imb_file.tc_imb13     #PNL量  #add by guanyao160923
                    END RECORD,
    g_tc_imb_1           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imb05_1          LIKE tc_imb_file.tc_imb05,
        sgm03_1               LIKE sgm_file.sgm03,    
        tc_imb03_1          LIKE tc_imb_file.tc_imb03,
         ecd02_1               LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        sfb05_1             LIKE sfb_file.sfb05,
        ima02_1               LIKE ima_file.ima02,          #品名
        ima021_1              LIKE ima_file.ima021,         #规格 
        sum_1                 LIKE img_file.img10 
                    END RECORD,
    g_tc_imb_2           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sfb05_2             LIKE sfb_file.sfb05,
        sgm03_2               LIKE sgm_file.sgm03,  
       tc_imb03_2           LIKE tc_imb_file.tc_imb03,
        ecd02_2               LIKE ecd_file.ecd02,          #作业说明 add by gujq 20160905
        ima02_2              LIKE ima_file.ima02,          #品名
        ima021d             LIKE ima_file.ima021,         #规格
        sum_2               LIKE img_file.img10      
                    END RECORD,
    g_tc_imb_3       DYNAMIC ARRAY OF RECORD    #程式??(Program Variables)
        tc_imb03_3           LIKE tc_imb_file.tc_imb03,
        ima02_3              LIKE ima_file.ima02,          #品名
        ima021_3             LIKE ima_file.ima021,         #规格
        sgm06                LIKE sgm_file.sgm06,          #工作站 
        sum_3                LIKE img_file.img10
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
 
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW t001_w33 AT 2,2 WITH FORM "cec/42f/cecq111"
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
    {     WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF}
         OTHERWISE        
            CALL t001_q() 
      END CASE
   END IF
   #--
 
    CALL t001_menu()

    DROP TABLE cecq111_tmp #add by guanyao160930
 
    CLOSE WINDOW t001_w33
    CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
      RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION t001_cs()
 DEFINE    l_type          LIKE type_file.chr2       #No.FUN-680072CHAR(2)
   CLEAR FORM                                      #清除畫面
   CALL g_tc_imb.clear()
   CALL g_tc_imb_1.clear()
   CALL g_tc_imb_2.clear()
   CALL g_tc_imb_3.clear()
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
#  IF g_argv1<>' ' THEN                     #FUN-7C0050
#     LET g_wc=" tc_ima01='",g_argv1,"'"       #FUN-7C0050
#     LET g_wc2=" 1=1"                      #FUN-7C0050
#     LET g_wc3=" 1=1"                      #FUN-7C0050
#     LET g_wc4=" 1=1"                      #FUN-7C0050
#  ELSE
   CONSTRUCT BY NAME g_wc ON                   #tianry add 161226
                shm05,shm012,shm01,sgm04,sgm06
               
 
   ON ACTION CONTROLP
      CASE  
         WHEN INFIELD(shm01)
             CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shm1"
                     LET g_qryparam.construct= "Y"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shm01
          WHEN INFIELD(shm012)
            CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.construct= "Y"
                     LET g_qryparam.arg1     = "12345"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shm012   #MOD-4A0252
                     NEXT FIELD shm012
           WHEN INFIELD(shm05) 
               CALL q_sel_ima(TRUE, "q_ima18","","","","","","","",'')  RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shm05

            WHEN INFIELD(sgm04)                 #作業編號
                     CALL q_ecd(TRUE,TRUE,'')
                     RETURNING g_qryparam.multiret         #No:MOD-970010 modify
                     DISPLAY g_qryparam.multiret TO sgm04  #No:MOD-970010 modify
                     NEXT FIELD sgm04

         
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

   #tianry add 161226
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
   INPUT BY NAME
        g_tc_ima.tc_imaud03   #add by guanyao160923
        WITHOUT DEFAULTS

    BEFORE INPUT
       LET g_before_input_done = TRUE
       LET g_tc_ima.tc_imaud03='3' 
       DISPLAY BY NAME g_tc_ima.tc_imaud03 

     ON ACTION CONTROLF                  #欄位說明
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name

        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

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

   #tianry add end 
   IF INT_FLAG THEN RETURN END IF
 
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
         WHEN (l_action_flag = "try")
            CALL t001_bp4("G")
      END CASE
# NO.FUN-540036--end
      CASE g_action_choice
{         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF }
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
{         WHEN "delete"
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
         WHEN "undo_confirm"          #取消審核�
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
            END IF  }
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
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imb_1),'','')
                   WHEN 'spare_part'
                     LET page = f.FindNode("Page","page5")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imb_2),'','')
                   WHEN 'try'   #tianry add 161226  
                     LET page = f.FindNode("Page","page6")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imb_3),'','')
                   OTHERWISE 
                     LET page = f.FindNode("Page","page3")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_imb),'','')
               END CASE
            END IF
     {    WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_ima.tc_ima01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_ima01"
                 LET g_doc.value1 = g_tc_ima.tc_ima01
                 CALL cl_doc()
               END IF  
         END IF  }
         #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_imb.clear()
   CALL g_tc_imb_1.clear()
   CALL g_tc_imb_2.clear()
   CALL g_tc_imb_3.clear()  #tianry add 161226
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t001_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      CALL t001_show()
   END IF
   MESSAGE ""
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION t001_show()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_eca02 LIKE eca_file.eca02
DEFINE l_ecg02 LIKE ecg_file.ecg02

   CALL temp_chuli()             
   CALL t001_b1_fill("1=1")                 #單身
   CALL t001_b2_fill("1=1")                 #單身
   CALL t001_b3_fill("1=1")                 #單身
   CALL t001_b4_fill("1=1")  
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
   

    LET l_tc_imb06 = 0 LET l_tc_imb07 = 0 LET l_tc_imb08 = 0 LET l_tc_imb09 = 0 
    LET l_tc_imb10 = 0 LET l_tc_imb11 = 0 LET l_tc_imb12 = 0 LET l_tc_imb13 = 0   
    #end---add by gaunyao160923
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
  #  LET g_sql=" SELECT sgm03,sgm04,ecd02,sgm01,sgm02,sfb05,   '','',l_sum1,l_sum2,l_sum3,l_sum6,l_sum4,l_sum5,l_sum7,l_sum10 
  #              FROM cecq111_tmp  WHERE l_sum7!=0"
     LET g_sql=" SELECT sgm03,sgm04,ecd02,sgm01,sgm02,sfb05,   '','',l_sum1,l_sum2,l_sum3,l_sum6,l_sum4,l_sum5,l_sum7,l_sum10 
                FROM cecq111_tmp  "
    PREPARE t001_pb1 FROM g_sql
    DECLARE tc_imb_curs1 CURSOR FOR t001_pb1
 
    CALL g_tc_imb.clear()
    LET l_ac = 1
    FOREACH tc_imb_curs1 INTO g_tc_imb[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 #      SELECT ecd02 INTO g_tc_imb[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_tc_imb[l_ac].tc_imb03 
 #      SELECT ima02,ima021 INTO g_tc_imb[l_ac].ima02,g_tc_imb[l_ac].ima021 FROM ima_file WHERE ima01 = g_tc_imb[l_ac].sfb05 

       LET l_tc_imb06 = l_tc_imb06 +g_tc_imb[l_ac].tc_imb06
       LET l_tc_imb07 = l_tc_imb07 +g_tc_imb[l_ac].tc_imb07
       LET l_tc_imb08 = l_tc_imb08 +g_tc_imb[l_ac].tc_imb08
       LET l_tc_imb09 = l_tc_imb09 +g_tc_imb[l_ac].tc_imb09
       LET l_tc_imb10 = l_tc_imb10 +g_tc_imb[l_ac].tc_imb10
       LET l_tc_imb11 = l_tc_imb11 +g_tc_imb[l_ac].tc_imb11
       LET l_tc_imb12 = l_tc_imb12 +g_tc_imb[l_ac].tc_imb12
       LET l_tc_imb13 = l_tc_imb13 +g_tc_imb[l_ac].tc_imb13

        LET l_ac=l_ac+1
     #  IF l_ac > g_max_rec THEN
     #    CALL cl_err( '', 9035, 0 )
     #     EXIT FOREACH
     # END IF
    END FOREACH
    
    LET g_tc_imb[l_ac].tc_imb03 = '汇总'
    LET g_tc_imb[l_ac].tc_imb06 = l_tc_imb06
    LET g_tc_imb[l_ac].tc_imb07 = l_tc_imb07
    LET g_tc_imb[l_ac].tc_imb08 = l_tc_imb08
    LET g_tc_imb[l_ac].tc_imb09 = l_tc_imb09
    LET g_tc_imb[l_ac].tc_imb10 = l_tc_imb10
    LET g_tc_imb[l_ac].tc_imb11 = l_tc_imb11
    LET g_tc_imb[l_ac].tc_imb12 = l_tc_imb12
    LET g_tc_imb[l_ac].tc_imb13 = l_tc_imb13
END FUNCTION
 
FUNCTION t001_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200) #TQC-630166 
    p_wc2           STRING    #TQC-630166 
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT sgm02,sgm03,sgm04,ecd02,sfb05,ima02,ima021,sum(l_sum7) FROM cecq111_tmp ",
                " GROUP BY  sgm02,sgm03,sgm04,ecd02,sfb05,ima02,ima021 ORDER BY 1"
    PREPARE t001_pb2 FROM g_sql
    DECLARE tc_imc_curs2 CURSOR FOR t001_pb2
 
    CALL g_tc_imb_1.clear()
    LET g_cnt = 1
    FOREACH tc_imc_curs2 INTO g_tc_imb_1[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
        
       LET g_cnt = g_cnt + 1
      # IF g_cnt > g_max_rec THEN
      #    CALL cl_err( '', 9035, 0 )
       #   EXIT FOREACH
      # END IF
    END FOREACH
    CALL g_tc_imb_1.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
END FUNCTION
 
FUNCTION t001_b3_fill(p_wc3)
DEFINE
   #p_wc3           VARCHAR(200) #TQC-630166
    p_wc3           STRING    #TQC-630166
 
    IF cl_null(p_wc3) THEN LET p_wc3 = ' 1=1' END IF
    LET g_sql = "SELECT sfb05,sgm03,sgm04,ecd02,ima02,ima021,sum(l_sum7) FROM cecq111_tmp ",
                " GROUP BY  sfb05,sgm03,sgm04,ecd02,ima02,ima021 ORDER BY 1"
    PREPARE t001_pb3 FROM g_sql
    DECLARE tc_imd_curs3 CURSOR FOR t001_pb3
 
    CALL g_tc_imb_2.clear()
    LET l_ac = 1
    FOREACH tc_imd_curs3 INTO g_tc_imb_2[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
      # IF l_ac > g_max_rec THEN
      #   CALL cl_err( '', 9035, 0 )
      #    EXIT FOREACH
      # END IF
    END FOREACH
    CALL g_tc_imb_2.deleteElement(l_ac)
    LET g_rec_b3 = l_ac-1
    DISPLAY g_rec_b3 TO FORMONLY.cn4
END FUNCTION
 

FUNCTION t001_b4_fill(p_wc4)
DEFINE
   #p_wc3           VARCHAR(200) #TQC-630166
    p_wc4           STRING    #TQC-630166

    IF cl_null(p_wc4) THEN LET p_wc4 = ' 1=1' END IF
    LET g_sql = "SELECT sfb05,ima02,ima021,sgm06,sum(l_sum7) FROM cecq111_tmp  ",
                " GROUP BY  sfb05,ima02,ima021,sgm06 "
    PREPARE t001_pb4 FROM g_sql
    DECLARE tc_imd_curs4 CURSOR FOR t001_pb4

    CALL g_tc_imb_3.clear()
    LET l_ac = 1
    FOREACH tc_imd_curs4 INTO g_tc_imb_3[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       #IF l_ac > g_max_rec THEN
       #   CALL cl_err( '', 9035, 0 )
       #  EXIT FOREACH
       # END IF
    END FOREACH
    CALL g_tc_imb_3.deleteElement(l_ac)
#    LET g_rec_b3 = l_ac-1
#    DISPLAY g_rec_b3 TO FORMONLY.cn4
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
       ON ACTION try
        LET l_action_flag = "try"
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
   DISPLAY ARRAY g_tc_imb_1 TO s_tc_imb_1.* ATTRIBUTE(COUNT=g_rec_b2)
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
      ON ACTION try
        LET l_action_flag = "try"
        EXIT DISPLAY
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION query
         LET g_action_choice="query"
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
   DISPLAY ARRAY g_tc_imb_2 TO s_tc_imb_2.* ATTRIBUTE(COUNT=g_rec_b3)
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
      ON ACTION try
        LET l_action_flag = "try"
        EXIT DISPLAY
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
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


#tianry add 161226
FUNCTION t001_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)

   #IF p_ud <> "G" OR g_action_choice = "detail" THEN     #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "try" THEN  #FUN-D40030 add
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imb_3 TO s_tc_imb_3.* ATTRIBUTE(COUNT=g_rec_b3)
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
     ON ACTION try
        LET l_action_flag = "try"

     EXIT DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION query
         LET g_action_choice="query"
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



#tianry add end  



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
 
 
{
FUNCTION t001_ins_tmp()
DEFINE l_sql  STRING 
DEFINE l_sql1 STRING 
    #tianry add  sgm06,ima02,ima021,ecd02  
    DROP TABLE cecq111_tmp
    CREATE TEMP TABLE cecq111_tmp
     (sfb05      LIKE sfb_file.sfb05,
      sgm01      LIKE sgm_file.sgm01,
      sgm02      LIKE sgm_file.sgm02,
      sgm03      LIKE sgm_file.sgm03,
      sgm03_1    LIKE sgm_file.sgm03,
      sgm04      LIKE sgm_file.sgm04,
      sgm06      LIKE sgm_file.sgm06,          
      ima02      LIKE ima_file.ima02,
      ima021     LIKE ima_file.ima021,
      ecd02      LIKE ecd_file.ecd02,
      l_sum1     LIKE tc_shc_file.tc_shc12,
      l_sum2     LIKE tc_shc_file.tc_shc12,
      l_sum3     LIKE tc_shc_file.tc_shc12,
      l_sum4     LIKE tc_shc_file.tc_shc12,
      l_sum5     LIKE tc_shc_file.tc_shc12,
      l_sum6     LIKE tc_shc_file.tc_shc12,
      l_sum7     LIKE tc_shc_file.tc_shc12,
      l_sum8     LIKE tc_shc_file.tc_shc12,
      l_sum9     LIKE tc_shc_file.tc_shc12,
      l_sum10    LIKE tc_shc_file.tc_shc12)

                                                  #tianry add sgm06,ima02,ima021,ecd02
    LET l_sql ="SELECT '',sgm01,sgm02,sgm03,0,sgm04,sgm06,ima02,ima021,ecd02,nvl(a.num, 0),nvl(b.num, 0),nvl(c.num, 0),nvl(c.num1, 0),nvl(c.num2, 0),nvl(d.num, 0),",
              "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num1,0)-nvl(c.num, 0)-nvl(c.num2, 0)+nvl(c.num, 0)",
              "                       ELSE nvl(a.num,0)-nvl(c.num1,0)-nvl(d.num,0)+nvl(d.num, 0) END CASE,0, ",
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
           #   "     AND (a.num >0 OR b.num >0)",  #add b.num by guanyao161006
              "     AND sgm02 = sfb01", 
              "     AND sfb04<>'8'",
              "     AND sfb87 = 'Y'",
              "     AND sgm03_par = ima01"


   IF g_tc_ima.tc_imaud03 = '1' THEN 
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') =0"
   END IF 
   IF g_tc_ima.tc_imaud03 = '2' THEN 
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') >0"
   END IF 
   LET l_sql1 = " INSERT INTO cecq111_tmp ",l_sql CLIPPED
   PREPARE t001_ins FROM l_sql1
   EXECUTE t001_ins

   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT a.sgm01 sgm01, a.sgm03 sgm03, b.sgm03 sgm03_1",
               "               FROM (SELECT sgm01, sgm03, rownum i",
               "                       FROM sgm_file",
               "                       ORDER BY sgm01, sgm03) a",
               "               LEFT JOIN (SELECT sgm01, sgm03, rownum - 1 i",
               "                            FROM sgm_file",
               "                           ORDER BY sgm01, sgm03) b on b.i = a.i",
               "                                        AND a.sgm01 = b.sgm01) n ",
               "         ON (o.sgm01 = n.sgm01 AND o.sgm03 = n.sgm03) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sgm03_1 = NVL(n.sgm03_1,0) "
   PREPARE t001_pre1 FROM l_sql
   EXECUTE t001_pre1 

   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT SUM(tc_shc12) tc_shc12, tc_shc03 tc_shc03, tc_shc06 tc_shc06",
               "               FROM tc_shc_file, ecd_file",
               "               WHERE ecd01 = tc_shc08",
               "                 AND tc_shc01 ='1'",
               "                 AND (ta_ecd04 IS NULL OR ta_ecd04 = 'N')",
               "               GROUP BY tc_shc03, tc_shc06",
               "               UNION",
               "              SELECT SUM(tc_shb12) tc_shc12, tc_shb03 tc_shc03, tc_shb06 tc_shc06",
               "                FROM tc_shb_file, ecd_file",
               "               WHERE ecd01 = tc_shb08",
               "                 AND ta_ecd04 = 'Y'",
               "                 AND tc_shb01 ='1'",
               "               GROUP BY tc_shb03, tc_shb06) n ",
               "         ON (o.sgm01 = n.tc_shc03 AND o.sgm03_1 = n.tc_shc06) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.l_sum8 = NVL(n.tc_shc12,0), ",
               "           o.l_sum7 =l_sum7-NVL(n.tc_shc12,0)"
   PREPARE t001_pre2 FROM l_sql
   EXECUTE t001_pre2

   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT sfv20, sum(sfv09) sfv09,0 sgm03",
               "               FROM sfv_file, sfu_file",
               "              WHERE sfv01 = sfu01",
               "                AND sfupost = 'Y'",
               "              GROUP BY sfv20) n ",
               "         ON (o.sgm01 = n.sfv20 AND o.sgm03_1 = n.sgm03) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.l_sum8 = NVL(n.sfv09,0), ",
               "           o.l_sum7 =l_sum7-NVL(n.sfv09,0)"
   PREPARE t001_pre3 FROM l_sql
   EXECUTE t001_pre3
   
   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT sfb01,sfb05 ",
               "               FROM sfb_file",
               "              WHERE sfb87='Y' ",
               "              ) n ",
               "         ON (o.sgm02 = n.sfb01 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfb05 = n.sfb05 "
   PREPARE t001_pre4 FROM l_sql
   EXECUTE t001_pre4

   #tianry add 161226


   #tianry add  end 


   DELETE FROM cecq111_tmp WHERE l_sum7 <= 0 
   UPDATE cecq111_tmp SET l_sum10 = l_sum7/l_sum10
END FUNCTION 
 }
FUNCTION temp_chuli()
DEFINE l_sql  STRING
DEFINE l_sql1 STRING
    DROP TABLE cecq111_tmp
    CREATE TEMP TABLE cecq111_tmp
     (sfb05      LIKE sfb_file.sfb05,
      sgm01      LIKE sgm_file.sgm01,
      sgm02      LIKE sgm_file.sgm02,
      sgm03      LIKE sgm_file.sgm03,
      sgm03_1    LIKE sgm_file.sgm03,
      sgm04      LIKE sgm_file.sgm04,
      sgm06      LIKE sgm_file.sgm06,
      ima02      LIKE ima_file.ima02,
      ima021     LIKE ima_file.ima021,
      ecd02      LIKE ecd_file.ecd02, 
      l_sum1     LIKE tc_shc_file.tc_shc12,
      l_sum2     LIKE tc_shc_file.tc_shc12,
      l_sum3     LIKE tc_shc_file.tc_shc12,
      l_sum4     LIKE tc_shc_file.tc_shc12,
      l_sum5     LIKE tc_shc_file.tc_shc12,
      l_sum6     LIKE tc_shc_file.tc_shc12,
      l_sum7     LIKE tc_shc_file.tc_shc12,
      l_sum8     LIKE tc_shc_file.tc_shc12,
      l_sum9     LIKE tc_shc_file.tc_shc12,
      l_sum10    LIKE tc_shc_file.tc_shc12)

   IF cl_null(g_wc) THEN LET  g_wc=' 1=1 ' END IF
   LET l_sql ="SELECT '',sgm01,sgm02,sgm03,0,sgm04,sgm06,ima02,ima021,ecd02,nvl(a.num, 0),nvl(b.num, 0),nvl(c.num, 0),nvl(c.num1, 0),nvl(c.num2, 0),nvl(d.num, 0),",
          #    "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num1,0)-nvl(c.num, 0)-nvl(c.num2, 0)+nvl(c.num, 0)",
              "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num, 0)-nvl(c.num2, 0)+nvl(c.num, 0)",
       #       "                       ELSE nvl(a.num,0)-nvl(c.num1,0)-nvl(d.num,0)+nvl(d.num, 0) END CASE,0, ",
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
          #    "     AND ecd07 = '",g_tc_ima.tc_ima03,"'",
         #     "     AND (a.num >0 OR b.num >0)",  #add b.num by guanyao161006
              "     AND sgm02 = sfb01 AND SGM314=0",
              "     AND sfb04<>'8'",
              "     AND sfb87 = 'Y'",
              "     AND sgm03_par = ima01 AND ",g_wc CLIPPED
         #     "     AND instr(sgm03_par, '-') >0  " 
   IF g_tc_ima.tc_imaud03 = '1' THEN
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') =0"
   END IF
   IF g_tc_ima.tc_imaud03 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') >0"
   END IF  
   LET l_sql1 = " INSERT INTO cecq111_tmp ",l_sql CLIPPED
   PREPARE t001_ins FROM l_sql1
   EXECUTE t001_ins

   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT a.sgm01 sgm01, a.sgm03 sgm03, b.sgm03 sgm03_1",
               "               FROM (SELECT sgm01, sgm03, rownum i",
               "                       FROM sgm_file",
               "                       ORDER BY sgm01, sgm03) a",
               "               LEFT JOIN (SELECT sgm01, sgm03, rownum - 1 i",
               "                            FROM sgm_file",
               "                           ORDER BY sgm01, sgm03) b on b.i = a.i",
               "                                        AND a.sgm01 = b.sgm01) n ",
               "         ON (o.sgm01 = n.sgm01 AND o.sgm03 = n.sgm03) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sgm03_1 = NVL(n.sgm03_1,0) "
   PREPARE t001_pre1 FROM l_sql
   EXECUTE t001_pre1

   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT SUM(tc_shc12) tc_shc12, tc_shc03 tc_shc03, tc_shc06 tc_shc06",
               "               FROM tc_shc_file, ecd_file",
               "               WHERE ecd01 = tc_shc08",
               "                 AND tc_shc01 ='1'",
               "                 AND (ta_ecd04 IS NULL OR ta_ecd04 = 'N')",
               "               GROUP BY tc_shc03, tc_shc06",
               "               UNION",
               "              SELECT SUM(tc_shb12) tc_shc12, tc_shb03 tc_shc03, tc_shb06 tc_shc06",
               "                FROM tc_shb_file, ecd_file",
               "               WHERE ecd01 = tc_shb08",
               "                 AND ta_ecd04 = 'Y'",
               "                 AND tc_shb01 ='1'",
               "               GROUP BY tc_shb03, tc_shb06) n ",
               "         ON (o.sgm01 = n.tc_shc03 AND o.sgm03_1 = n.tc_shc06) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.l_sum8 = NVL(n.tc_shc12,0), ",
               "           o.l_sum7 =l_sum7-NVL(n.tc_shc12,0)"
   PREPARE t001_pre2 FROM l_sql
   EXECUTE t001_pre2
   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT sfv20, sum(sfv09) sfv09,0 sgm03",
               "               FROM sfv_file, sfu_file",
               "              WHERE sfv01 = sfu01",
               "                AND sfupost = 'Y'",
               "              GROUP BY sfv20) n ",
               "         ON (o.sgm01 = n.sfv20 AND o.sgm03_1 = n.sgm03) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.l_sum8 = NVL(n.sfv09,0), ",
               "           o.l_sum7 =l_sum7-NVL(n.sfv09,0)"
   PREPARE t001_pre3 FROM l_sql
   EXECUTE t001_pre3

   LET l_sql = " MERGE INTO cecq111_tmp o ",
               "      USING (SELECT sfb01,sfb05 ",
               "               FROM sfb_file",
               "              WHERE sfb87='Y' ",
               "              ) n ",
               "         ON (o.sgm02 = n.sfb01 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfb05 = n.sfb05 "
   PREPARE t001_pre4 FROM l_sql
   EXECUTE t001_pre4

  # DELETE FROM cecq111_tmp WHERE l_sum7 <= 0
   UPDATE cecq111_tmp SET l_sum7 = l_sum7 - l_sum4  #add by huanglf170112
   UPDATE cecq111_tmp SET l_sum10 = l_sum7/l_sum10
  # DELETE FROM cecq111_tmp WHERE l_sum7 <= 0
END FUNCTION

