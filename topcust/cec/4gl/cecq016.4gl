# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cecq016.4gl
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
        ima02               LIKE ima_file.ima02,          #品名     add by gujq 20160905
        ima021              LIKE ima_file.ima021,         #规格     add by gujq 20160905
        ecbud09             like ecb_file.ecbud09, 
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
        tc_imb03_1          LIKE tc_imb_file.tc_imb03,
        sfb05_1             LIKE sfb_file.sfb05,
        ima02_1               LIKE ima_file.ima02,          #品名
        ima021_1              LIKE ima_file.ima021,         #规格 
        ecbud09              like ecb_file.ecbud09, 
        sum_1                 LIKE img_file.img10 
                    END RECORD,
    g_tc_imb_2           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sfb05_2             LIKE sfb_file.sfb05,
        ima02_2              LIKE ima_file.ima02,          #品名
        ima021d             LIKE ima_file.ima021,         #规格
        ecbud09             like ecb_file.ecbud09,       
        d1          LIKE img_file.img10,
        d2          LIKE img_file.img10,
        d3          LIKE img_file.img10,
        d4          LIKE img_file.img10,
        d5          LIKE img_file.img10,
        d6          LIKE img_file.img10,
        d7          LIKE img_file.img10,
        d8          LIKE img_file.img10,
        d9          LIKE img_file.img10,
        d10         LIKE img_file.img10,
        d11         LIKE img_file.img10,
        d12         LIKE img_file.img10,
        d13         LIKE img_file.img10,
        d14         LIKE img_file.img10,
        d15         LIKE img_file.img10,
        d16         LIKE img_file.img10,
        d17         LIKE img_file.img10,
        d18         LIKE img_file.img10,
        d19         LIKE img_file.img10,
        d20         LIKE img_file.img10,
        d21         LIKE img_file.img10,
        d22         LIKE img_file.img10, 
        d23         LIKE img_file.img10,
        d24         LIKE img_file.img10,
        d25         LIKE img_file.img10,
        d26         LIKE img_file.img10,
        d27         LIKE img_file.img10,
        d28         LIKE img_file.img10,
        d29         LIKE img_file.img10,
        d30         LIKE img_file.img10,
        d31         LIKE img_file.img10,
        d32         LIKE img_file.img10, 
        d33         LIKE img_file.img10,
        d34         LIKE img_file.img10,
        d35         LIKE img_file.img10,
        d36         LIKE img_file.img10,
        d37         LIKE img_file.img10,
        d38         LIKE img_file.img10,
        d39         LIKE img_file.img10,
        d40         LIKE img_file.img10,
        d41         LIKE img_file.img10,
        d42         LIKE img_file.img10,
        d43         LIKE img_file.img10,
        d44         LIKE img_file.img10,
        d45         LIKE img_file.img10,
        d46         LIKE img_file.img10,
        d47         LIKE img_file.img10,
        d48         LIKE img_file.img10,
        d49         LIKE img_file.img10,
        d50         LIKE img_file.img10
                    END RECORD,
    g_tc_imb_3       DYNAMIC ARRAY OF RECORD    #程式??(Program Variables)
        tc_imb03_3           LIKE tc_imb_file.tc_imb03,
        ima02_3              LIKE ima_file.ima02,          #品名
        ima021_3             LIKE ima_file.ima021,         #规格
        ecbud09              like ecb_file.ecbud09, 
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
 
    OPEN WINDOW q016_w33 AT 2,2 WITH FORM "cec/42f/cecq016"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   
    CALL cl_set_comp_visible("Page3,Page4,Page6",FALSE)

   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL q016_q()
            END IF
    {     WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL q016_a()
            END IF}
         OTHERWISE        
            CALL q016_q() 
      END CASE
   END IF
   #--
 
    CALL q016_menu()

    DROP TABLE cecq016_tmp_try #add by guanyao160930
 
    CLOSE WINDOW q016_w33
    CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
      RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION q016_cs()
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
 
FUNCTION q016_menu()
DEFINE l_cmd  LIKE type_file.chr1000        #No.FUN-820002
#str---add by guanyao160923
DEFINE   w    ui.Window      
DEFINE   f    ui.Form       
DEFINE   page om.DomNode
#end---add by guanyao160923
   WHILE TRUE
      IF cl_null(l_action_flag) THEN LET l_action_flag='spare_part' END IF 
# NO.FUN-540036--start
#     CALL q016_bp("G")
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "accessory")
            CALL q016_bp1("G")
         WHEN (l_action_flag = "user_defined_columns")
            CALL q016_bp2("G")
         WHEN (l_action_flag = "spare_part")
            CALL q016_bp3("G")
         WHEN (l_action_flag = "try")
            CALL q016_bp4("G")
      END CASE
# NO.FUN-540036--end
      CASE g_action_choice
{         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL q016_a()
            END IF }
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q016_q()
            END IF
{         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL q016_r()
            END IF
         #WHEN "reproduce"
         #   IF cl_chk_act_auth() THEN
         #      CALL q016_copy()
         #   END IF
         WHEN "confirm"               #審核 
           IF cl_chk_act_auth() THEN
                CALL q016_y()
           END IF 
         WHEN "undo_confirm"          #取消審核�
            IF cl_chk_act_auth() THEN
               CALL q016_z()
            END IF
         WHEN "sure"                  #交接确认
            IF cl_chk_act_auth() THEN 
               CALL q016_s()
            END IF   
         WHEN "undo_sure"             #取消确认
            IF cl_chk_act_auth() THEN 
               CALL q016_us()
            END IF      
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL q016_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL q016_x()
            END IF  }
         WHEN "output"
            IF cl_chk_act_auth()                                           
               THEN CALL q016_out()                                    
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
 
 
FUNCTION q016_q()
 
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
 
   CALL q016_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      CALL q016_show()
   END IF
   MESSAGE ""
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION q016_show()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_eca02 LIKE eca_file.eca02
DEFINE l_ecg02 LIKE ecg_file.ecg02

   CALL temp_chuli()          
  # CALL huamian()   
   CALL q016_b1_fill("1=1")                 #單身
   CALL q016_b2_fill("1=1")                 #單身
   CALL q016_b3_fill("1=1")                 #單身
   CALL q016_b4_fill("1=1")  
END FUNCTION
 
 
FUNCTION q016_b1_fill(p_wc1)
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
    LET g_sql=" SELECT sgm03,sgm04,ecd02,sgm01,sgm02,sfb05,   '','',l_sum1,l_sum2,l_sum3,l_sum6,l_sum4,l_sum5,l_sum7,l_sum10 
                FROM cecq016_tmp_try  WHERE l_sum7!=0"
    PREPARE q016_pb1 FROM g_sql
    DECLARE tc_imb_curs1 CURSOR FOR q016_pb1
 
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
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
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
 
FUNCTION q016_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200) #TQC-630166 
    p_wc2           STRING    #TQC-630166 
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT sgm02,sgm04,sfb05,ima02,ima021,ecbud09,sum(l_sum7) FROM cecq016_tmp_try ",
                " GROUP BY  ecbud09,sgm02,sgm04,sfb05,ima02,ima021,ecbud09 ORDER BY 1"
    PREPARE q016_pb2 FROM g_sql
    DECLARE tc_imc_curs2 CURSOR FOR q016_pb2
 
    CALL g_tc_imb_1.clear()
    LET g_cnt = 1
    FOREACH tc_imc_curs2 INTO g_tc_imb_1[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_tc_imb_1.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
END FUNCTION
 
FUNCTION q016_b3_fill(p_wc3)
DEFINE
   #p_wc3           VARCHAR(200) #TQC-630166
    p_wc3           STRING    #TQC-630166
DEFINE  
        l_sgm06     LIKE sgm_file.sgm06,
        i           LIKE type_file.num5,
        l_aaa       LIKE img_file.img10
DEFINE  l_imaud10    LIKE ima_file.imaud10,
        l_ecbud09    LIKE ecb_file.ecbud09

    IF cl_null(p_wc3) THEN LET p_wc3 = ' 1=1' END IF
    LET g_sql = "SELECT DISTINCT sfb05,ima02,ima021,ecbud09  FROM cecq016_tmp_try  "
               
    PREPARE q016_pb3 FROM g_sql
    DECLARE tc_imd_curs3 CURSOR FOR q016_pb3
  
    #SELECT  l_sum7 INTO l_sum7 FROM cecq016_tmp_try WHERE ROWNUM=1 AND sgm03=270
    CALL g_tc_imb_2.clear()
    LET l_ac = 1   
   
    FOREACH tc_imd_curs3 INTO g_tc_imb_2[l_ac].sfb05_2,g_tc_imb_2[l_ac].ima02_2,g_tc_imb_2[l_ac].ima021d,g_tc_imb_2[l_ac].ecbud09,l_aaa
       SELECT imaud10 INTO l_imaud10 FROM ima_file WHERE ima01=g_tc_imb_2[l_ac].sfb05_2 

       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET i=1  #31序号 贴合之前的换算成PNL
       FOR i=1 TO 50
         IF i=1 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d1 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN 
               LET g_tc_imb_2[l_ac].d1=g_tc_imb_2[l_ac].d1/l_imaud10
            END IF 
            IF g_tc_imb_2[l_ac].d1=0 THEN LET g_tc_imb_2[l_ac].d1='' END IF 
         END IF     
         IF i=2 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d2 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d2=g_tc_imb_2[l_ac].d2/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d2=0 THEN LET g_tc_imb_2[l_ac].d2='' END IF
         END IF
         IF i=3 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d3 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d3=g_tc_imb_2[l_ac].d3/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d3=0 THEN LET g_tc_imb_2[l_ac].d3='' END IF
         END IF
         IF i=4 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d4 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d4=g_tc_imb_2[l_ac].d4/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d4=0 THEN LET g_tc_imb_2[l_ac].d4='' END IF
         END IF
         IF i=5 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d5 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d5=g_tc_imb_2[l_ac].d5/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d5=0 THEN LET g_tc_imb_2[l_ac].d5='' END IF
         END IF
         IF i=6 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d6 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d6=g_tc_imb_2[l_ac].d6/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d6=0 THEN LET g_tc_imb_2[l_ac].d6='' END IF
         END IF
         IF i=7 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d7 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d7=g_tc_imb_2[l_ac].d7/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d7=0 THEN LET g_tc_imb_2[l_ac].d7='' END IF
         END IF
         IF i=8 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d8 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d8=g_tc_imb_2[l_ac].d8/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d8=0 THEN LET g_tc_imb_2[l_ac].d8='' END IF
         END IF
         IF i=9 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d9 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d9=g_tc_imb_2[l_ac].d9/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d9=0 THEN LET g_tc_imb_2[l_ac].d9='' END IF
         END IF
         IF i=10 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d10 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d10=g_tc_imb_2[l_ac].d10/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d10=0 THEN LET g_tc_imb_2[l_ac].d10='' END IF
         END IF
         IF i=11 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d11 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d11=g_tc_imb_2[l_ac].d11/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d11=0 THEN LET g_tc_imb_2[l_ac].d11='' END IF
         END IF
         IF i=12 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d12 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d12=g_tc_imb_2[l_ac].d12/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d12=0 THEN LET g_tc_imb_2[l_ac].d12='' END IF
         END IF
         IF i=13 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d13 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d13=g_tc_imb_2[l_ac].d13/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d13=0 THEN LET g_tc_imb_2[l_ac].d13='' END IF
         END IF
         IF i=14 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d14 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d14=g_tc_imb_2[l_ac].d14/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d14=0 THEN LET g_tc_imb_2[l_ac].d14='' END IF
         END IF
         IF i=15 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d15 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d15=g_tc_imb_2[l_ac].d15/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d15=0 THEN LET g_tc_imb_2[l_ac].d15='' END IF
         END IF
         IF i=16 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d16 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d16=g_tc_imb_2[l_ac].d16/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d16=0 THEN LET g_tc_imb_2[l_ac].d16='' END IF
         END IF
         IF i=17 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d17 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d17=g_tc_imb_2[l_ac].d17/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d17=0 THEN LET g_tc_imb_2[l_ac].d17='' END IF
         END IF
         IF i=18 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d18 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d18=g_tc_imb_2[l_ac].d18/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d18=0 THEN LET g_tc_imb_2[l_ac].d18='' END IF
         END IF
         IF i=19 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d19 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d19=g_tc_imb_2[l_ac].d19/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d19=0 THEN LET g_tc_imb_2[l_ac].d19='' END IF
         END IF
         IF i=20 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d20 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d20=g_tc_imb_2[l_ac].d20/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d20=0 THEN LET g_tc_imb_2[l_ac].d20='' END IF
         END IF
         IF i=21 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d21 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d21=g_tc_imb_2[l_ac].d21/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d21=0 THEN LET g_tc_imb_2[l_ac].d21='' END IF
         END IF
         IF i=22 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d22 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d22=g_tc_imb_2[l_ac].d22/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d22=0 THEN LET g_tc_imb_2[l_ac].d22='' END IF
         END IF
         IF i=23 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d23 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d23=g_tc_imb_2[l_ac].d23/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d23=0 THEN LET g_tc_imb_2[l_ac].d23='' END IF
         END IF
         IF i=24 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d24 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d24=g_tc_imb_2[l_ac].d24/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d24=0 THEN LET g_tc_imb_2[l_ac].d24='' END IF
         END IF
         IF i=25 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d25 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d25=g_tc_imb_2[l_ac].d25/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d25=0 THEN LET g_tc_imb_2[l_ac].d25='' END IF
         END IF
         IF i=26 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d26 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d26=g_tc_imb_2[l_ac].d26/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d26=0 THEN LET g_tc_imb_2[l_ac].d26='' END IF
         END IF
         IF i=27 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d27 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d27=g_tc_imb_2[l_ac].d27/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d27=0 THEN LET g_tc_imb_2[l_ac].d27='' END IF
         END IF
         IF i=28 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d28 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d28=g_tc_imb_2[l_ac].d28/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d28=0 THEN LET g_tc_imb_2[l_ac].d28='' END IF
         END IF
         IF i=29 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d29 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d29=g_tc_imb_2[l_ac].d29/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d29=0 THEN LET g_tc_imb_2[l_ac].d29='' END IF
         END IF
         IF i=30 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d30 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF NOT cl_null(l_imaud10) THEN
               LET g_tc_imb_2[l_ac].d30=g_tc_imb_2[l_ac].d30/l_imaud10
            END IF
            IF g_tc_imb_2[l_ac].d30=0 THEN LET g_tc_imb_2[l_ac].d30='' END IF
         END IF
         IF i=31 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d31 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d31=0 THEN LET g_tc_imb_2[l_ac].d31='' END IF
         END IF
         IF i=32 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d32 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d32=0 THEN LET g_tc_imb_2[l_ac].d32='' END IF
         END IF
         IF i=33 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d33 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d33=0 THEN LET g_tc_imb_2[l_ac].d33='' END IF
         END IF
         IF i=34 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d34 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d34=0 THEN LET g_tc_imb_2[l_ac].d34='' END IF
         END IF
         IF i=35 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d35 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d35=0 THEN LET g_tc_imb_2[l_ac].d35='' END IF
         END IF
         IF i=36 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d36 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d36=0 THEN LET g_tc_imb_2[l_ac].d36='' END IF
         END IF
         IF i=37 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d37 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d37=0 THEN LET g_tc_imb_2[l_ac].d37='' END IF
         END IF
         IF i=38 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d38 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d38=0 THEN LET g_tc_imb_2[l_ac].d38='' END IF
         END IF
         IF i=39 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d39 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d39=0 THEN LET g_tc_imb_2[l_ac].d39='' END IF
         END IF
         IF i=40 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d40 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d40=0 THEN LET g_tc_imb_2[l_ac].d40='' END IF
         END IF
         IF i=41 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d41 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d41=0 THEN LET g_tc_imb_2[l_ac].d41='' END IF
         END IF
         IF i=42 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d42 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d42=0 THEN LET g_tc_imb_2[l_ac].d42='' END IF
         END IF
         IF i=43 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d43 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d43=0 THEN LET g_tc_imb_2[l_ac].d43='' END IF
         END IF
         IF i=44 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d44 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d44=0 THEN LET g_tc_imb_2[l_ac].d44='' END IF
         END IF
         IF i=45 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d45 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d45=0 THEN LET g_tc_imb_2[l_ac].d45='' END IF
         END IF
         IF i=46 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d46 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d46=0 THEN LET g_tc_imb_2[l_ac].d46='' END IF
         END IF
         IF i=47 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d47 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d47=0 THEN LET g_tc_imb_2[l_ac].d47='' END IF
         END IF
         IF i=48 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d48 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d48=0 THEN LET g_tc_imb_2[l_ac].d48='' END IF
         END IF
         IF i=49 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d49 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d49=0 THEN LET g_tc_imb_2[l_ac].d49='' END IF
         END IF
         IF i=50 THEN
            SELECT SUM(NVL(l_sum7,0)) INTO g_tc_imb_2[l_ac].d50 FROM cecq016_tmp_try,cect_try
            WHERE nu=i AND ecd07=sgm06 AND sfb05=g_tc_imb_2[l_ac].sfb05_2 AND ecbud09=g_tc_imb_2[l_ac].ecbud09
            IF g_tc_imb_2[l_ac].d50=0 THEN LET g_tc_imb_2[l_ac].d50='' END IF
         END IF

         #LET i=i+1
       END FOR   



       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imb_2.deleteElement(l_ac)
    LET g_rec_b3 = l_ac-1
    DISPLAY g_rec_b3 TO FORMONLY.cn4
END FUNCTION
 

FUNCTION q016_b4_fill(p_wc4)
DEFINE
   #p_wc3           VARCHAR(200) #TQC-630166
    p_wc4           STRING    #TQC-630166

    IF cl_null(p_wc4) THEN LET p_wc4 = ' 1=1' END IF
    LET g_sql = "SELECT sfb05,ima02,ima021,ecbud09,sgm06,sum(l_sum7) FROM cecq016_tmp_try  ",
                " GROUP BY  sfb05,ima02,ima021,ecbud09,sgm06 "
    PREPARE q016_pb4 FROM g_sql
    DECLARE tc_imd_curs4 CURSOR FOR q016_pb4

    CALL g_tc_imb_3.clear()
    LET l_ac = 1
    FOREACH tc_imd_curs4 INTO g_tc_imb_3[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imb_3.deleteElement(l_ac)
#    LET g_rec_b3 = l_ac-1
#    DISPLAY g_rec_b3 TO FORMONLY.cn4
END FUNCTION

# NO.FUN-540036--start
FUNCTION q016_bp1(p_ud)
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
FUNCTION q016_bp2(p_ud)
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
FUNCTION q016_bp3(p_ud)
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
FUNCTION q016_bp4(p_ud)
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
FUNCTION q016_out()
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
    LET l_cmd = 'p_query "aemq016" "',g_wc CLIPPED,'"'                          
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
#   CALL cl_outnam('aemq016') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   LET g_sql="SELECT tc_ima01,tc_ima02,tc_ima06,tc_ima14,tc_ima15,tc_ima16,",
#             "       tc_ima17,tc_ima10,gen02 ",
#             g_sql1 CLIPPED,",LEFT OUTER JOIN tc_ima_file ON tc_ima_file.tc_ima10 = gen_file.gen02",
#             g_sql2 CLIPPED, 
#             " ORDER BY tc_ima01"
#   PREPARE q016_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE q016_co CURSOR FOR q016_p1
 
#   START REPORT q016_rep TO l_name
 
#   FOREACH q016_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)             
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT q016_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT q016_rep
 
#   CLOSE q016_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
 
FUNCTION temp_chuli()
DEFINE l_sql  STRING
DEFINE l_sql1 STRING
DEFINE l_i,aa    LIKE type_file.num5
DEFINE l_ecd07   LIKE ecd_file.ecd07
DEFINE l_eca02   LIKE eca_file.eca02
DEFINE l_tc_sfcud07   LIKE tc_sfc_file.tc_sfcud07


    DROP TABLE cecq016_tmp_try
    CREATE TEMP TABLE cecq016_tmp_try
     (sfb05      LIKE sfb_file.sfb05,
      sgm01      LIKE sgm_file.sgm01,
      sgm02      LIKE sgm_file.sgm02,
      sgm03      LIKE sgm_file.sgm03,
      sgm03_1    LIKE sgm_file.sgm03,
      sgm04      LIKE sgm_file.sgm04,
      sgm06      LIKE sgm_file.sgm06,
      ima02      LIKE ima_file.ima02,
      ima021     LIKE ima_file.ima021,
      ecbud09    LIKE ecb_file.ecbud09,
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
      DROP TABLE cect_try
    CREATE TEMP TABLE cect_try
     (nu    LIKE pmn_file.pmn02,
      ecd07  LIKE ecd_file.ecd07,
      eca02  LIKE eca_file.eca02)

   IF cl_null(g_wc) THEN LET  g_wc=' 1=1 ' END IF
   LET l_sql ="SELECT DISTINCT '',sgm01,sgm02,sgm03,0,sgm04,sgm06,ima02,ima021,ecbud09,ecd02,nvl(a.num, 0),nvl(b.num, 0),nvl(c.num, 0),nvl(c.num1, 0),nvl(c.num2, 0),nvl(d.num, 0),",
       #       "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num1,0)-nvl(c.num, 0)-nvl(c.num2, 0)+nvl(c.num, 0)",
       #        "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num, 0)-nvl(c.num2, 0)+nvl(c.num, 0)", #ly 180112
               "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(b.num,0)-nvl(c.num, 0)-nvl(c.num1, 0)+nvl(c.num, 0)",
     #         "                       ELSE nvl(a.num,0)-nvl(c.num1,0)-nvl(d.num,0)+nvl(d.num, 0) END CASE,0, ",
              "                       ELSE nvl(a.num,0)-nvl(d.num,0)+nvl(d.num, 0) END CASE,0, ",
              "        CASE  ta_ecd04 WHEN 'Y' THEN nvl(c.num, 0) ",
              "                       ELSE nvl(d.num, 0) END CASE,",
              "        CASE imaud10 WHEN 0 THEN 1 ELSE nvl(imaud10,1) END CASE",
              "  FROM ecd_file,ecb_file,sfb_file,ima_file,shm_file,sgm_file ",
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
              "     AND (a.num >0 OR b.num >0)",  #add b.num by guanyao161006
              "     AND sgm02 = sfb01",
              "     AND sfb04<>'8'",
              "     AND sfb87 = 'Y' AND ecb01=sfb05 and ecb02=sfb06",
              "     AND sgm03_par = ima01 AND ",g_wc CLIPPED
         #     "     AND instr(sgm03_par, '-') >0  " 
   IF g_tc_ima.tc_imaud03 = '1' THEN
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') =0"
   END IF
   IF g_tc_ima.tc_imaud03 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND instr(sgm03_par, '-') >0"
   END IF  
   LET l_sql1 = " INSERT INTO cecq016_tmp_try ",l_sql CLIPPED
   PREPARE q016_ins FROM l_sql1
   EXECUTE q016_ins
   
   SELECT COUNT(*) INTO AA FROM cecq016_tmp_try 

   LET l_sql = " MERGE INTO cecq016_tmp_try o ",
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
   PREPARE q016_pre1 FROM l_sql
   EXECUTE q016_pre1

   LET l_sql = " MERGE INTO cecq016_tmp_try o ",
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
   PREPARE q016_pre2 FROM l_sql
   EXECUTE q016_pre2
   LET l_sql = " MERGE INTO cecq016_tmp_try o ",
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
   PREPARE q016_pre3 FROM l_sql
   EXECUTE q016_pre3

   LET l_sql = " MERGE INTO cecq016_tmp_try o ",
               "      USING (SELECT sfb01,sfb05 ",
               "               FROM sfb_file",
               "              WHERE sfb87='Y' ",
               "              ) n ",
               "         ON (o.sgm02 = n.sfb01 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfb05 = n.sfb05 "
   PREPARE q016_pre4 FROM l_sql
   EXECUTE q016_pre4


   DELETE FROM cecq016_tmp_try WHERE l_sum7 <= 0
   UPDATE cecq016_tmp_try SET l_sum7 = l_sum7 - l_sum4  #add by huanglf170112
   UPDATE cecq016_tmp_try SET l_sum10 = l_sum7/l_sum10
    DELETE FROM cecq016_tmp_try WHERE l_sum7 <= 0

   #tianry add 170204   
   LET l_sql = " MERGE INTO cecq016_tmp_try o ",
               "      USING (SELECT tc_sfc01,tc_sfc02 ",
               "               FROM tc_sfc_file",
               "              ) n ",
               "         ON (o.sgm04 = n.tc_sfc02 ) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sgm06 = n.tc_sfc01 "
   PREPARE q016_pre5 FROM l_sql
   EXECUTE q016_pre5

   #tianry add end 170204


   #tianry add 170118
   DECLARE sel_aaa_try CURSOR FOR
#   SELECT distinct ecd07,eca02 FROM ecd_file,eca_file WHERE ecd07=eca01 ORDER BY ecd07
   SELECT distinct tc_sfc01,tc_sfcud01,tc_sfcud07 FROM tc_sfc_file ORDER BY tc_sfcud07 
   LET l_i=1
   FOREACH sel_aaa_try INTO l_ecd07,l_eca02,l_tc_sfcud07
     INSERT INTO cect_try VALUES (l_i,l_ecd07,l_eca02)
     IF l_i=1 THEN CALL cl_set_comp_att_text("d1",l_eca02) END IF
     IF l_i=2 THEN CALL cl_set_comp_att_text("d2",l_eca02) END IF
     IF l_i=3 THEN CALL cl_set_comp_att_text("d3",l_eca02) END IF
     IF l_i=4 THEN CALL cl_set_comp_att_text("d4",l_eca02) END IF
     IF l_i=5 THEN CALL cl_set_comp_att_text("d5",l_eca02) END IF
     IF l_i=6 THEN CALL cl_set_comp_att_text("d6",l_eca02) END IF
     IF l_i=7 THEN CALL cl_set_comp_att_text("d7",l_eca02) END IF
     IF l_i=8 THEN CALL cl_set_comp_att_text("d8",l_eca02) END IF
     IF l_i=9 THEN CALL cl_set_comp_att_text("d9",l_eca02) END IF
     IF l_i=10 THEN CALL cl_set_comp_att_text("d10",l_eca02) END IF
     IF l_i=11 THEN CALL cl_set_comp_att_text("d11",l_eca02) END IF
     IF l_i=12 THEN CALL cl_set_comp_att_text("d12",l_eca02) END IF
     IF l_i=13 THEN CALL cl_set_comp_att_text("d13",l_eca02) END IF
     IF l_i=14 THEN CALL cl_set_comp_att_text("d14",l_eca02) END IF
     IF l_i=15 THEN CALL cl_set_comp_att_text("d15",l_eca02) END IF
     IF l_i=16 THEN CALL cl_set_comp_att_text("d16",l_eca02) END IF
     IF l_i=17 THEN CALL cl_set_comp_att_text("d17",l_eca02) END IF
     IF l_i=18 THEN CALL cl_set_comp_att_text("d18",l_eca02) END IF
     IF l_i=19 THEN CALL cl_set_comp_att_text("d19",l_eca02) END IF
     IF l_i=20 THEN CALL cl_set_comp_att_text("d20",l_eca02) END IF
     IF l_i=21 THEN CALL cl_set_comp_att_text("d21",l_eca02) END IF
     IF l_i=22 THEN CALL cl_set_comp_att_text("d22",l_eca02) END IF
     IF l_i=23 THEN CALL cl_set_comp_att_text("d23",l_eca02) END IF
     IF l_i=24 THEN CALL cl_set_comp_att_text("d24",l_eca02) END IF
     IF l_i=25 THEN CALL cl_set_comp_att_text("d25",l_eca02) END IF
     IF l_i=26 THEN CALL cl_set_comp_att_text("d26",l_eca02) END IF
     IF l_i=27 THEN CALL cl_set_comp_att_text("d27",l_eca02) END IF
     IF l_i=28 THEN CALL cl_set_comp_att_text("d28",l_eca02) END IF
     IF l_i=29 THEN CALL cl_set_comp_att_text("d29",l_eca02) END IF
     IF l_i=30 THEN CALL cl_set_comp_att_text("d30",l_eca02) END IF
     IF l_i=31 THEN CALL cl_set_comp_att_text("d31",l_eca02) END IF
     IF l_i=32 THEN CALL cl_set_comp_att_text("d32",l_eca02) END IF
     IF l_i=33 THEN CALL cl_set_comp_att_text("d33",l_eca02) END IF
     IF l_i=34 THEN CALL cl_set_comp_att_text("d34",l_eca02) END IF
     IF l_i=35 THEN CALL cl_set_comp_att_text("d35",l_eca02) END IF
     IF l_i=36 THEN CALL cl_set_comp_att_text("d36",l_eca02) END IF
     IF l_i=37 THEN CALL cl_set_comp_att_text("d37",l_eca02) END IF
     IF l_i=38 THEN CALL cl_set_comp_att_text("d38",l_eca02) END IF
     IF l_i=39 THEN CALL cl_set_comp_att_text("d39",l_eca02) END IF
     IF l_i=40 THEN CALL cl_set_comp_att_text("d40",l_eca02) END IF
     IF l_i=41 THEN CALL cl_set_comp_att_text("d41",l_eca02) END IF
     IF l_i=42 THEN CALL cl_set_comp_att_text("d42",l_eca02) END IF
     IF l_i=43 THEN CALL cl_set_comp_att_text("d43",l_eca02) END IF
     IF l_i=44 THEN CALL cl_set_comp_att_text("d44",l_eca02) END IF
     IF l_i=45 THEN CALL cl_set_comp_att_text("d45",l_eca02) END IF
     IF l_i=46 THEN CALL cl_set_comp_att_text("d46",l_eca02) END IF
     IF l_i=47 THEN CALL cl_set_comp_att_text("d47",l_eca02) END IF
     IF l_i=48 THEN CALL cl_set_comp_att_text("d48",l_eca02) END IF
     IF l_i=49 THEN CALL cl_set_comp_att_text("d49",l_eca02) END IF
     IF l_i=50 THEN CALL cl_set_comp_att_text("d50",l_eca02) END IF


     LET l_i=l_i+1
   END FOREACH

   #tianry add  end  



   #tianry add 170118

END FUNCTION


