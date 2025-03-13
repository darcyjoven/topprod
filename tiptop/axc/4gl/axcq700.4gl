# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: axcq700.4gl
# Descriptions...: 採購入庫查詢
# Date & Author..: 12/08/07 By Lanhang
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能 
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,傳入參數改為年度/期別,最大筆數控制與excel導出處理
# Modify.........: No.FUN-C80092 12/10/05 By zm 增加插入明细资料功能以便比对axcq100采购入库金额差异
# Modify.........: No.FUN-C80092 12/12/17 By fengrui 效能優化、委外數量處理
# Modify.........: No.FUN-D10022 13/01/31 BY chenjing、fengrui 程式效能改善 
# Modify.........: No:FUN-D20078 13/02/26 By xujing 倉退單過帳寫tlf時,區分一般倉退和委外倉退,同時修正成本計算及相關查詢報表邏輯
# Modify.........: No.TQC-D30024 13/03/07 By chenjing 修改tm.type1顯示問題
# Modify.........: No.FUN-D50112 13/05/30 By lixh1 單身增加拋磚憑證編號顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"           
 
DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)      # Where condition
           bdate   LIKE type_file.dat,           #No.FUN-680122DATE 
           edate   LIKE type_file.dat,           #No.FUN-680122DATE  
           type    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
           a       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
           costdown LIKE type_file.chr1,          #FUN-BB0063
           g       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
           type_1  LIKE type_file.chr1,           #No.FUN-8B0026 VARCHAR(1)
           s       LIKE type_file.chr3,           #No.FUN-8B0026 VARCHAR(3)
           type1   LIKE type_file.chr1             #No.FUN-7C0101  ADD  #Cost Calculation Method 
 		   END RECORD
DEFINE g_ckk       RECORD LIKE ckk_file.*
DEFINE g_auto_gen  LIKE type_file.chr1     
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
DEFINE m_plant     ARRAY[10] OF LIKE azp_file.azp01   #FUN-A70084
DEFINE m_legal     ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084 
DEFINE g_rec_b     LIKE type_file.num10
DEFINE g_rec_b2    LIKE type_file.num10   #chenjing
DEFINE g_cnt       LIKE type_file.num10
DEFINE g_flag      LIKE type_file.chr1             #chenjing
DEFINE g_tlf       DYNAMIC ARRAY OF RECORD
                   ima12         LIKE ima_file.ima12,        #FUN-D10002  chenjing add
                   azf03         LIKE azf_file.azf03,        #cj
                   tlf01         LIKE tlf_file.tlf01,        #料号
                   ima02         LIKE ima_file.ima02,        #品名规格
                   ima021        LIKE ima_file.ima021,
                   ima57         LIKE ima_file.ima57,        #FUN-D10002  chenjing add
                   ima08         LIKE ima_file.ima08,        #FUN-D10002  chenjing add
                   tlf19         LIKE tlf_file.tlf19,        #厂商编号
                   wpmc03        LIKE pmc_file.pmc03,        #厂商简称
                   tlf031        LIKE tlf_file.tlf026,       #仓库
                   imd02         LIKE imd_file.imd02,        #chenjing
                   tlf905        LIKE tlf_file.tlf905,       #入库单号
                   tlf06         LIKE tlf_file.tlf06,        #单据日期
                   ima131        LIKE ima_file.ima131,       #FUN-D10002  chenjing add
                   apa44         LIKE type_file.chr200,      #抛转凭证编号 #FUN-D50112
                   tlf10         LIKE tlf_file.tlf10,        #异动数量                   
                   tlf221        LIKE tlf_file.tlf221        #材料金额
                   END RECORD
#FUN-D10002--chenjing--add--str--
DEFINE g_tlf_1     DYNAMIC ARRAY OF RECORD
                   ima12_1       LIKE ima_file.ima12,        
                   azf03_1       LIKE azf_file.azf03,
                   tlf01_1       LIKE tlf_file.tlf01,        #料号
                   ima02_1       LIKE ima_file.ima02,        #品名规格
                   ima021_1      LIKE ima_file.ima021,
                   tlf19_1       LIKE tlf_file.tlf19,        #厂商编号
                   wpmc03_1      LIKE pmc_file.pmc03,        #厂商简称
                   tlf031_1      LIKE tlf_file.tlf026,       #仓库
                   imd02_1       LIKE imd_file.imd02,
                   tlf905_1      LIKE tlf_file.tlf905,       #入库单号
                   tlf06_1       LIKE tlf_file.tlf06,        #单据日期
                   ima131_1      LIKE ima_file.ima131,       
                   apa44         LIKE type_file.chr200,      #抛转凭证编号 #FUN-D50112
                   tlf10_1       LIKE tlf_file.tlf10,        #异动数量
                   tlf221_1      LIKE tlf_file.tlf221        #材料金额
                   END RECORD
#FUN-D10002--chenjing--add--end--
#FUN-C80092--add--str--
DEFINE g_tlf_excel DYNAMIC ARRAY OF RECORD
                   ima12         LIKE ima_file.ima12,        #FUN-D10002  chenjing add
                   azf03         LIKE azf_file.azf03,        #cj
                   tlf01         LIKE tlf_file.tlf01,        #料号
                   ima02         LIKE ima_file.ima02,        #品名规格
                   ima021        LIKE ima_file.ima021,
                   ima57         LIKE ima_file.ima57,        #FUN-D10002  chenjing add
                   ima08         LIKE ima_file.ima08,        #FUN-D10002  chenjing add
                   tlf19         LIKE tlf_file.tlf19,        #厂商编号
                   wpmc03        LIKE pmc_file.pmc03,        #厂商简称
                   tlf031        LIKE tlf_file.tlf026,       #仓库
                   imd02         LIKE imd_file.imd02,
                   tlf905        LIKE tlf_file.tlf905,       #入库单号
                   tlf06         LIKE tlf_file.tlf06,        #单据日期
                   ima131        LIKE ima_file.ima131,       #FUN-D10002  chenjing add
                   apa44         LIKE type_file.chr200,      #抛转凭证编号 #FUN-D50112
                   tlf10         LIKE tlf_file.tlf10,        #异动数量                   
                   tlf221        LIKE tlf_file.tlf221        #材料金额
                   END RECORD
#FUN-C80092--add--end--
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE l_ac           LIKE type_file.num5
DEFINE l_ac1          LIKE type_file.num5               #chenjing
DEFINE l_num          LIKE tlf_file.tlf10               #材料数量合计
DEFINE l_tot          LIKE tlf_file.tlf221              #材料金额合计
DEFINE g_bdate,g_edate   LIKE type_file.dat             #No.FUN-680122DATE
DEFINE g_cka00        STRING
DEFINE g_argv8        LIKE type_file.num5               #No.FUN-C80092
DEFINE g_argv9        LIKE type_file.num5               #No.FUN-C80092
DEFINE g_argv17       LIKE type_file.chr1               #No.FUN-C80092
DEFINE g_action_flag  LIKE type_file.chr100  
DEFINE g_filter_wc    STRING 
DEFINE w              ui.Window
DEFINE f              ui.Form
DEFINE page           om.DomNode

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   INITIALIZE tm.* TO NULL
   LET tm.a    = 'N'
   LET tm.g    = '1'
   LET tm.type1= ARG_VAL(17)          #FUN-7C0101 ADD
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #LET tm.bdate = ARG_VAL(8) #FUN-C80092 mark
   #LET tm.edate = ARG_VAL(9) #FUN-C80092 mark
   LET g_argv8  = ARG_VAL(8)  #FUN-C80092 add
   LET g_argv9  = ARG_VAL(9)  #FUN-C80092 add
   LET tm.type  = ARG_VAL(10)
   #FUN-C80092 add
   LET g_argv17 = ARG_VAL(17)
   IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) THEN 
      CALL s_azn01(g_argv8,g_argv9) RETURNING tm.bdate,tm.edate
   END IF 
   #FUN-C80092 add
   LET tm.a  = ARG_VAL(11)
   LET tm.g  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   LET tm.type_1= ARG_VAL(27)   
   LET g_auto_gen = ARG_VAL(28)
   LET tm.costdown = ARG_VAL(29)
 
   #FUN-C80092 mark
   #OPEN WINDOW q700_w AT 5,10
   #     WITH FORM "axc/42f/axcq700_1" ATTRIBUTE(STYLE = g_win_style)
   #CALL cl_ui_init()
   #FUN-C80092 mark
 
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      #FUN-C80092--add--str--
      OPEN WINDOW q700_w AT 5,10
      #    WITH FORM "axc/42f/axcq700_1" ATTRIBUTE(STYLE = g_win_style)  #chenjing
           WITH FORM "axc/42f/axcq700" ATTRIBUTE(STYLE = g_win_style)    #chenjing
      CALL cl_ui_init()
      #FUN-C80092--add--end--
      CALL cl_set_act_visible("revert_filter",FALSE)  #FUN-D10002 add 
      CALL q700_cs(0,0)
      CALL q700_show()
      #FUN-C80092--add--str--
      CALL q700_menu()
      #DROP TABLE q700_tmp;  #FUN-C80092 mark 121217
      CLOSE WINDOW q700_w
      #FUN-C80092--add--end--
   ELSE
      CALL axcq700()
   END IF
 
   #FUN-C80092 mark
   #CALL q700_menu()
   #DROP TABLE q700_tmp;
   #CLOSE WINDOW q700_w
   #FUN-C80092 mark
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q700_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
  #chenjing--add--str--
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q700_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q700_bp2()
         END IF
      END IF
  #chenjing--add--end
      CASE g_action_choice
  #chenjing--add--str--
         WHEN "page1"
            CALL q700_bp("G")
         WHEN "page2"
            CALL q700_bp2()
  #chenjing--add--end--
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q700_cs(0,0)
               CALL q700_show()
            END IF
  #chenjing--add--str--
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q700_filter_askkey()
               CALL axcq700()        #重填充新臨時表
               CALL q700_show()
            END IF
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE)
               CALL axcq700()        #重填充新臨時表
               CALL q700_show()
            END IF
            LET g_action_choice = " "
  #chenjing--add--end--
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent() 
            LET f = w.getForm()
            IF g_action_flag = "page1" THEN
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_excel),'','')
               END IF
            END IF 
            IF g_action_flag = "page2" THEN 
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_1),'','')
               END IF
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q700_cs(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
       l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
       l_cmd             LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
DEFINE l_cnt             LIKE type_file.num5           #No.FUN-A70084

 #FUN-D10002--chenjing--mark--str--
 # IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
 # IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
 #    LET p_row = 3 LET p_col = 20
 # ELSE LET p_row = 4 LET p_col = 15
 # END IF
 # OPEN WINDOW axcq700_1 AT p_row,p_col
 #      WITH FORM "axc/42f/axcq700"
 #FUN-D10002--chenjing--mark--end--
################################################################################
# START genero shell script ADD
 #     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN  #chenjing
 
 #  CALL cl_ui_init()         #chenjing
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
#  CALL q700_set_visible() RETURNING l_cnt    #FUN-A70084  #chenjing
   CLEAR FORM
   CALL g_tlf_excel.clear()
   CALL g_tlf_1.clear()
   INITIALIZE tm.* TO NULL
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,g_bdate,g_edate
   LET tm.bdate= g_bdate
   LET tm.edate= g_edate
   LET tm.type = '1'
   LET tm.a   = 'N'
   LET tm.costdown = 'N'            #FUN-D10022
   LET tm.g   = '1'
   LET tm.type1 = g_ccz.ccz28       #FUN-7C0101 ADD
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.s ='2 '   
   LET tm.type_1  = '3'
   LET g_auto_gen = 'Y'
   LET g_filter_wc = ' 1=1'
   LET g_action_flag = ''
   CALL cl_set_act_visible("revert_filter",FALSE)
   DISPLAY BY NAME g_auto_gen
   CALL q700_set_entry_1()               
   CALL q700_set_no_entry_1()

#FUN-D10002--chenjing--add--str--
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.bdate,tm.edate,tm.type1,tm.a,tm.costdown,g_auto_gen,tm.type ,tm.g,   
                    tm.type_1,tm.s ATTRIBUTE(WITHOUT DEFAULTS)                                                   
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
    
      BEFORE FIELD bdate
         CALL cl_set_comp_entry("g_auto_gen",TRUE)
      AFTER FIELD bdate
        IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
           IF tm.edate < tm.bdate THEN
               CALL cl_err('','agl-031',0)
           END IF
        END IF
        CALL q700_set_entry_1()
        CALL q700_set_no_entry_1()
        DISPLAY BY NAME g_auto_gen

      BEFORE FIELD edate
         CALL cl_set_comp_entry("g_auto_gen",TRUE)
      AFTER FIELD edate
        IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
           IF tm.edate < tm.bdate THEN
               CALL cl_err('','agl-031',0)
           END IF
        END IF
        CALL q700_set_entry_1()
        CALL q700_set_no_entry_1()
        DISPLAY BY NAME g_auto_gen
      AFTER FIELD type1
        IF tm.type1 IS NULL OR tm.type1 NOT MATCHES '[12345]' THEN NEXT FIELD type1 END IF
      AFTER FIELD type
        IF cl_null(tm.type) OR tm.type not matches '[123]'   #FUN-7B0038 add 3
        THEN NEXT FIELD type
        END IF
      AFTER FIELD g
       IF cl_null(tm.g) OR tm.g not matches '[123]'
        THEN NEXT FIELD g
        END IF

      AFTER FIELD type_1
         IF cl_null(tm.type_1) OR tm.type_1 NOT MATCHES '[123]' THEN
            NEXT FIELD type_1
         END IF


      AFTER INPUT
         IF INT_FLAG THEN
            EXIT DIALOG
         END IF
         IF tm.edate < tm.bdate THEN
            CALL cl_err('','agl-031',0)
            NEXT FIELD edate
         END IF
      END INPUT 
      CONSTRUCT  tm.wc ON ima12,tlf01,ima57,ima08,tlf19,
                          tlf031,tlf06,ima131,tlf10,tlf221,apa44     #FUN-D50112 add
          FROM s_tlf[1].ima12,s_tlf[1].tlf01,s_tlf[1].ima57,s_tlf[1].ima08,s_tlf[1].tlf19,
               s_tlf[1].tlf031,s_tlf[1].tlf06,s_tlf[1].ima131,s_tlf[1].tlf10,s_tlf[1].tlf221,s_tlf[1].apa44    #FUN-D50112 add apa44
              
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
          # IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) AND NOT cl_null(g_argv17) THEN 
          #    LET tm.wc = ' 1=1'
          #    EXIT DIALOG    
          # END IF 
       END CONSTRUCT
 

     ON ACTION controlp
        CASE
           WHEN INFIELD(tlf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tlf"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf01
              NEXT FIELD tlf01
           WHEN INFIELD(ima12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = "G"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima12
              NEXT FIELD ima12
           WHEN INFIELD(tlf19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf19
              NEXT FIELD tlf19
          #FUN-D10022---xj---str---
           WHEN INFIELD(tlf031)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img21"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf031
              NEXT FIELD tlf031
           WHEN INFIELD(ima131)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oba01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima131
              NEXT FIELD ima131         
          #FUN-D10022---xj---end---
    #FUN-D50112 --------Begin--------
           WHEN INFIELD(apa44)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa44"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa44
              NEXT FIELD apa44
    #FUN-D50112 --------End----------
       END CASE
     ON ACTION locale
          CALL cl_show_fld_cont()                                     
         LET g_action_choice = "locale"
         EXIT DIALOG   
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG   
 
     ON ACTION about                    
        CALL cl_about()                 
 
     ON ACTION help                     
        CALL cl_show_help()             
 
     ON ACTION controlg                    
        CALL cl_cmdask()                  
 
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT DIALOG
     ON ACTION qbe_select
        CALL cl_qbe_select()

     ON ACTION ACCEPT
        ACCEPT DIALOG

     ON ACTION CANCEL
        LET INT_FLAG=1
        EXIT DIALOG
  END DIALOG 
   IF INT_FLAG THEN
      CLEAR FORM
      CALL g_tlf_excel.clear()
      CALL g_tlf_1.clear()
      CALL g_tlf.clear()
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      DELETE FROM q700_tmp
      DELETE FROM q700_tmp_1    #FUN-D50112
      DELETE FROM q700_tmp_2    #FUN-D50112
      RETURN
   END IF 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   LET tm.wc = cl_replace_str(tm.wc,'tlf031',"(CASE WHEN tlf13 = 'apmt1072' OR tlf13 = 'asft6101' THEN tlf021 ELSE tlf031 END)") #FUN-D10022
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    
             WHERE zz01='axcq700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcq700','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type1 CLIPPED,"'",    
                         " '",tm.type  CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",              
                         " '",tm.g CLIPPED,"'",                 
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'",      
                         " '",tm.type_1 CLIPPED,"'"                         
 
         CALL cl_cmdat('axcq700',g_time,l_cmd)   
      END IF
   END IF
   CALL axcq700()
   CALL q700_show()
#FUN-D10002--chenjing--add--end--   
#chejing---str---
{
#   WHILE TRUE
#      CONSTRUCT BY NAME tm.wc ON ima12,ima01,ima57,ima08 ,tlf19
#         BEFORE CONSTRUCT
#            CALL cl_qbe_init()
#            #FUN-C80092--add--by--free--
#            IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) AND NOT cl_null(g_argv17) THEN 
#               LET tm.wc = ' 1=1'
#               EXIT CONSTRUCT 
#            END IF 
#            #FUN-C80092--add--by--free--
# 
#     ON ACTION locale
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#     ON ACTION controlp
#        IF INFIELD(ima01) THEN
#           CALL cl_init_qry_var()
#           LET g_qryparam.form = "q_ima"
#           LET g_qryparam.state = "c"
#           CALL cl_create_qry() RETURNING g_qryparam.multiret
#           DISPLAY g_qryparam.multiret TO ima01
#           NEXT FIELD ima01
#        END IF
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
# 
#END CONSTRUCT
#LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW axcq700_1 
#      EXIT WHILE
#   END IF
#   IF tm.wc=' 1=1' AND cl_null(g_argv8) THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF  #FUN-C80092 add g_argv8
#   INPUT BY NAME tm.bdate,tm.edate,tm.type1,tm.a,tm.costdown,g_auto_gen,tm.type ,tm.g,  #FUN-7C0101 ADD tm.type1  #FUN-BB0063      
#                 tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8B0026
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type_1,                                   #FUN-8B0026 
#                 tm2.s1,tm2.s2,tm2.s3,                                                      #FUN-8B0026
#                 tm2.u1,tm2.u2,tm2.u3                                                       #FUN-8B0026   
#      WITHOUT DEFAULTS
#         BEFORE INPUT
#             CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      AFTER FIELD bdate
#        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
#        CALL q700_set_entry_1()      
#        CALL q700_set_no_entry_1()
#      AFTER FIELD edate
#        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
#        CALL q700_set_entry_1()      
#        CALL q700_set_no_entry_1()
#      AFTER FIELD type1
#        IF tm.type1 IS NULL OR tm.type1 NOT MATCHES '[12345]' THEN NEXT FIELD type1 END IF
#      AFTER FIELD type
#        IF cl_null(tm.type) OR tm.type not matches '[123]'   #FUN-7B0038 add 3
#        THEN NEXT FIELD type
#        END IF
#      AFTER FIELD g
#        IF cl_null(tm.g) OR tm.g not matches '[123]'
#        THEN NEXT FIELD g
#        END IF
#       # IF tm.g  =  '1'
#       #    THEN NEXT FIELD more
#       # END IF
#        
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                    
#       ON CHANGE  b
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL q700_set_entry_1()      
#          CALL q700_set_no_entry_1()
#       
#      AFTER FIELD type_1
#         IF cl_null(tm.type_1) OR tm.type_1 NOT MATCHES '[123]' THEN
#            NEXT FIELD type_1
#         END IF                   
#       
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            #FUN-A70084--add--str--
#            ELSE
#               SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.p1
#           #FUN-A70084--add--end
#            END IF  
#         END IF              
# 
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p2 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN              
#               NEXT FIELD p2          
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2
#            IF NOT q700_chklegal(m_legal[2],1) THEN
#               CALL cl_err(tm.p2,g_errno,0)
#               NEXT FIELD p2
#            END IF
#            #FUN-A70084--add--end
#         END IF
# 
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p3 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3
#            IF NOT q700_chklegal(m_legal[3],2) THEN
#               CALL cl_err(tm.p3,g_errno,0)
#               NEXT FIELD p3
#            END IF
#            #FUN-A70084--add--end
#         END IF
# 
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p4 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4
#            IF NOT q700_chklegal(m_legal[4],3) THEN
#               CALL cl_err(tm.p4,g_errno,0)
#               NEXT FIELD p4
#            END IF
#            #FUN-A70084--add--end
#         END IF
# 
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#               NEXT FIELD p5 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5
#            IF NOT q700_chklegal(m_legal[5],4) THEN
#               CALL cl_err(tm.p5,g_errno,0)
#               NEXT FIELD p5
#            END IF
#            #FUN-A70084--add--end
#         END IF
# 
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p6 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6
#            IF NOT q700_chklegal(m_legal[6],5) THEN
#               CALL cl_err(tm.p6,g_errno,0)
#               NEXT FIELD p6
#            END IF
#            #FUN-A70084--add--end
#         END IF
# 
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#               NEXT FIELD p7 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7
#            IF NOT q700_chklegal(m_legal[7],6) THEN
#               CALL cl_err(tm.p7,g_errno,0)
#               NEXT FIELD p7
#            END IF
#            #FUN-A70084--add--end
#         END IF
# 
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p8 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
#            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8
#            IF NOT q700_chklegal(m_legal[8],7) THEN
#               CALL cl_err(tm.p8,g_errno,0)
#               NEXT FIELD p8
#            END IF
#            #FUN-A70084--add--end
#         END IF       
#        
#      #AFTER FIELD more
#      #   IF tm.more = 'Y'
#      #      THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#      #                          g_bgjob,g_time,g_prtway,g_copies)
#      #                RETURNING g_pdate,g_towhom,g_rlang,
#      #                          g_bgjob,g_time,g_prtway,g_copies
#      #   END IF
#################################################################################
## START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
# 
#      ON ACTION CONTROLP
#         CASE        
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#         END CASE                        
# 
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      
#      AFTER INPUT
#         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
#         LET tm.t = tm2.t1,tm2.t2,tm2.t3
#         LET tm.u = tm2.u1,tm2.u2,tm2.u3      
#      
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
# 
#   END INPUT
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW axcq700_1 
#      EXIT WHILE
#   END IF
#   IF g_bgjob = 'Y' THEN
#      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
#             WHERE zz01='axcq700'
#      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
#          CALL cl_err('axcq700','9031',1)   
#      ELSE
#         LET l_cmd = l_cmd CLIPPED,
#                         " '",g_pdate CLIPPED,"'",
#                         " '",g_towhom CLIPPED,"'",
#                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
#                         " '",g_bgjob CLIPPED,"'",
#                         " '",g_prtway CLIPPED,"'",
#                         " '",g_copies CLIPPED,"'",
#                         " '",tm.wc CLIPPED,"'",
#                         " '",tm.bdate CLIPPED,"'",
#                         " '",tm.edate CLIPPED,"'",
#                         " '",tm.type1 CLIPPED,"'",       #FUN-7C0101 ADD
#                         " '",tm.type  CLIPPED,"'",
#                         " '",tm.a CLIPPED,"'",                 #TQC-610051
#                         " '",tm.g CLIPPED,"'",                 #TQC-610051
#                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
#                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
#                         " '",g_template CLIPPED,"'",           #No.FUN-570264
#                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
#                         " '",tm.b CLIPPED,"'" ,     #FUN-8B0026
#                         " '",tm.p1 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p2 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p3 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p4 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p5 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p6 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p7 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.p8 CLIPPED,"'" ,    #FUN-8B0026
#                         " '",tm.type_1 CLIPPED,"'" ,#FUN-8B0026                        
#                         " '",tm.s CLIPPED,"'" ,     #FUN-8B0026
#                         " '",tm.t CLIPPED,"'" ,     #FUN-8B0026
#                         " '",tm.u CLIPPED,"'"       #FUN-8B0026                         
# 
#         CALL cl_cmdat('axcq700',g_time,l_cmd)    # Execute cmd at later time
#      END IF
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
#      EXIT PROGRAM
#   END IF
#   CLOSE WINDOW axcq700_1
#   #CALL cl_wait()
#   CALL axcq700()
#   ERROR ""
#   EXIT WHILE
#END WHILE
#   CLOSE WINDOW axcq700_w
#} 
#chejing---end---
END FUNCTION

FUNCTION axcq700()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)        # External(Disk) file name
          l_sql     STRING,                                                #No.TQC-970185 
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_rvv04   LIKE rvv_file.rvv04,
          l_rvv05   LIKE rvv_file.rvv05,
          l_rvv39   LIKE rvv_file.rvv39,
          l_rva00   LIKE rva_file.rva00,          #MOD-C20103 add
          l_rva06   LIKE rva_file.rva06,
          l_pmm22   LIKE pmm_file.pmm22,
          l_pmm42   LIKE pmm_file.pmm42,
          wima01    LIKE ima_file.ima01,          #No.FUN-680122char(  3)
          wima201   LIKE type_file.chr2,          #No.FUN-680122char(  2)
          wpmc03    LIKE pmc_file.pmc03,          #No.MOD-850234
          wima202   LIKE tlf_file.tlf19,          #No.FUN-7C0090
          l_company    LIKE type_file.chr50,      
          sr RECORD
             code     LIKE type_file.chr1,        #No.FUN-680122CHAR(01)
             ima12    LIKE ima_file.ima12,
             azf03    LIKE azf_file.azf03,        #cj
             ima01    LIKE ima_file.ima01,
             ima02    LIKE ima_file.ima02,
             ima021   LIKE ima_file.ima021,       #cj
             tlfccost LIKE tlfc_file.tlfccost,    #FUN-7C0101 ADD
             tlf021   LIKE tlf_file.tlf021,
             tlf031   LIKE tlf_file.tlf031,
             imd02    LIKE imd_file.imd02,        #cj
             tlf06    LIKE tlf_file.tlf06,
             tlf026   LIKE tlf_file.tlf026,
             tlf027   LIKE tlf_file.tlf027,
             tlf036   LIKE tlf_file.tlf036,
             tlf037   LIKE tlf_file.tlf037,
             tlf01    LIKE tlf_file.tlf01,
             tlf10    LIKE tlf_file.tlf10,
             tlfc21   LIKE tlfc_file.tlfc21,      #FUN-7C0101 tlf21-->tlfc21  
             tlf13    LIKE tlf_file.tlf13,
             tlf65    LIKE tlf_file.tlf65,
             tlf19    LIKE tlf_file.tlf19,
             pmc03    LIKE pmc_file.pmc03,        #fr
             tlf905   LIKE tlf_file.tlf905,
             tlf906   LIKE tlf_file.tlf906,
             tlf907   LIKE tlf_file.tlf907,
             amt01    LIKE tlf_file.tlf221        #材料金額
             END RECORD,
          l_i        LIKE type_file.num5,         #No.FUN-8B0026 SMALLINT
          l_dbs      LIKE azp_file.azp03,         #No.FUN-8B0026
          l_azp03    LIKE azp_file.azp03,         #No.FUN-8B0026
          l_pmc903   LIKE pmc_file.pmc903,        #No.FUN-8B0026
          i          LIKE type_file.num5,         #No.FUN-8B0026
          l_ima57    LIKE ima_file.ima57,         #No.FUN-8B0026
          l_ima08    LIKE ima_file.ima08,         #No.FUN-8B0026         
          l_ima131   LIKE ima_file.ima131,        #cj
          l_slip     LIKE smy_file.smyslip,       #No.MOD-990086
          l_smydmy1  LIKE smy_file.smydmy1,       #No.MOD-990086
          x_flag    LIKE type_file.chr1           #MOD-A40087 add
   DEFINE l_cnt     LIKE type_file.num5           #FUN-A70084 
   DEFINE l_costdown STRING                       #FUN-BB0063
   DEFINE l_n        LIKE type_file.num10         #FUN-C80092 num5->10
   #DEFINE l_n1       LIKE type_file.num10        #FUN-C80092 num5->10 #FUN-C80092 mark 121217
   DEFINE l_msg      STRING                       #FUN-C80092
   DEFINE l_msg1     STRING                       #FUN-C80092
   DEFINE l_type     LIKE ckk_file.ckk01 
   DEFINE l_type1    LIKE ckl_file.ckl01 
   DEFINE l_sql1     STRING    #FUN-D50112
   DEFINE l_sql2     STRING    #FUN-D50112
   
#FUN-C80092 -----------Begin------------- 
   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.type1 = '",tm.type1,"'",";",
                "tm.a = '",tm.a,"'",";","tm.costdown = '",tm.costdown,"'",";","g_auto_gen = '",g_auto_gen,"'",";",
                "tm.type = '",tm.type,"'",";","tm.g = '",tm.g,"'",";","tm.type_1 = '",tm.type_1,"'"    #chenjing--add
              #chenjing--mark--str--
              # "tm.type = '",tm.type,"'",";","tm.g = '",tm.g,"'",";","tm.type_1 = '",tm.type_1,"'",";",
              # "tm.b = '",tm.b,"'",";","tm.p1 = '",tm.p1,"'",";","tm.p2 = '",tm.p2,"'",";",
              # "tm.p3 = '",tm.p3,"'",";","tm.p4 = '",tm.p4,"'",";","tm.p5 = '",tm.p5,"'",";","tm.p6 = '",tm.p6,"'",";",
              # "tm.p7 = '",tm.p7,"'",";","tm.p8 = '",tm.p8,"'",";","tm.s = '",tm.s,"'",";","tm.u = '",tm.u,"'"
              #chenjing--mark--end--
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00
#FUN-C80092 -----------End--------------
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET g_cnt = 1
   LET l_num = 0
   LET l_tot = 0
#FUN-D10002--chenjing--mark--
{
#   FOR i = 1 TO 8 LET m_plant[i] = NULL END FOR
#   #FUN-C80092--add--str--
#   IF cl_null(tm.p1) AND cl_null(tm.p2) AND cl_null(tm.p3) AND cl_null(tm.p4) AND 
#      cl_null(tm.p5) AND cl_null(tm.p6) AND cl_null(tm.p7) AND cl_null(tm.p8) THEN
#      LET tm.p1 = g_plant 
#   END IF 
#   #FUN-C80092--add--end--
#   LET m_plant[1]=tm.p1
#   LET m_plant[2]=tm.p2
#   LET m_plant[3]=tm.p3
#   LET m_plant[4]=tm.p4
#   LET m_plant[5]=tm.p5
#   LET m_plant[6]=tm.p6
#   LET m_plant[7]=tm.p7
#   LET m_plant[8]=tm.p8
#}
#FUN-D10002--chenjing--mark--end--

   CALL g_tlf.clear()
   CALL g_tlf_excel.clear()
   CALL q700_table()  #free add
   IF cl_null(tm.wc) THEN LET tm.wc = " 1=1" END IF 
#FUN-D10022--mark--str--
#  FOR l_i = 1 to 8         
#     IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF 
#     CALL q700_set_visible() RETURNING l_cnt    #FUN-A70084  
#     IF l_cnt>1 THEN   #Single DB
#        LET m_plant[1] = g_plant
#     END IF 
#      #FUN-C80092--add--121217--
#      LET l_sql = "SELECT apa44 ",    
#                  "  FROM apb_file,apa_file ",
#                  " WHERE apb21= ?  AND apb22= ? AND apb01=apa01 ",
#                  "   AND apa42 = 'N' AND apb34 <> 'Y' AND apb29 = '1' "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
#      PREPARE apa_pre3 FROM l_sql     
#
#      LET l_sql = "SELECT SUM(apb101) ",                       
#                  "  FROM apb_file,apa_file ",
#                  " WHERE apa01 = apb01 AND apa42 = 'N' AND apb29='1' ",
#                  "   AND apb21= ?  AND apb22= ? AND apb12= ?",
#                  "   AND (apa00 ='11' OR apa00 = '16') ",
#                  "   AND apb34 <> 'Y'",
#                  "   AND apa02 BETWEEN ? AND ? "       
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
#      PREPARE apb_pre3 FROM l_sql                                                                                          
#
#      LET l_sql = "SELECT ale09 ",                                                                              
#                  "  FROM ale_file ",         
#                  " WHERE ale16= ? AND ale17= ? AND ale11= ? "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
#      PREPARE ale_pre3 FROM l_sql                                                                                          
#
#      LET l_sql = "SELECT SUM(apb101) ",                                                                              
#                  "  FROM apb_file,apa_file ",
#                  " WHERE apa01 = apb01 AND apa42 = 'N'",
#                  "   AND apb29='1' AND  apb21= ? ",
#                  "   AND apb22= ? AND apb12= ? ",
#                  "   AND apa00 ='16' AND apb34 <> 'Y' ",
#                  "   AND apa02 BETWEEN ? AND ? "       
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
#      PREPARE apb_pre2 FROM l_sql                              
#
#      LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                              
#                  "  FROM rvv_file ",
#                  " WHERE rvv01= ? AND rvv02= ? AND rvv25<>'Y' "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
#      PREPARE rvv_pre3 FROM l_sql
#
#      LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
#                  "  FROM rvb_file,pmm_file,rva_file ",
#                  " WHERE rvb01= ? AND rvb02= ? ",
#                  "   AND pmm01=rvb04 AND rva01 = rvb01",
#                  "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "   
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
#      PREPARE pmm_pre2_1 FROM l_sql     
#
#      LET l_sql = "SELECT rva113,rva06,rva114 ",
#                  "  FROM rvb_file,rva_file ", 
#                  " WHERE rvb01= ? AND rvb02= ? ",
#                  "   AND rva01 = rvb01 AND rvaconf <> 'X'  "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
#      PREPARE pmm_pre2_2 FROM l_sql       
#
#       LET l_sql = "SELECT apa44 ",         
#                   "  FROM apb_file,apa_file ",                                                                     
#                    " WHERE apb21= ? AND apb22= ? AND apb01=apa01 ",
#                    "   AND apa42 = 'N' AND apb34 <> 'Y' "
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
#       PREPARE apa_pre2 FROM l_sql                  
#
#       LET l_sql = "SELECT SUM(apb101) ",                                                                              
#                   "  FROM apb_file,apa_file ",
#                   " WHERE apa01 = apb01 AND apa42 = 'N'",
#                   "   AND apb29='3' AND  apb21= ? ",
#                   "   AND apb22= ? AND apb12= ? AND apa00 ='21' ",
#                   "   AND (apa58 ='2' OR apa58 = '3') AND apb34 <> 'Y' ",  
#                   "   AND apa02 BETWEEN ? AND ? "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
#      PREPARE apb_pre1 FROM l_sql   
#
#      LET l_sql = "SELECT SUM(ABS(apb101)) ",  
#                  "  FROM apb_file,apa_file ",                                                                 
#                  " WHERE apa01 = apb01 AND apa42 = 'N'",
#                  "   AND apb29='3' AND  apb21= ? ",
#                  "   AND apb22= ? AND apb12= ? ",
#                  "   AND (apa00 ='11' OR apa00 = '26') ",       
#                  "   AND apb34 <> 'Y'",
#                  "   AND apa02 BETWEEN ? AND ? " 
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
#      PREPARE apb_pre4 FROM l_sql     
#
#      LET l_sql = "SELECT ale09 ",                                                                              
#                  "  FROM ale_file ",
#                  " WHERE ale16= ? AND ale17= ? AND ale11= ? "                         
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
#      PREPARE ale_pre2 FROM l_sql                                                                                          
#
#      LET l_sql = "SELECT SUM(apb101) ",
#                  "  FROM apb_file,apa_file ",   
#                  " WHERE apa01 = apb01 AND apa42 = 'N'",
#                  "   AND apb29='3' AND  apb21= ? ",
#                  "   AND apb22= ? AND apb12= ? ",
#                  "   AND apa00 ='26' ",
#                  "   AND (apa58 ='2' OR apa58 = '3') ", 
#                  "   AND apb34 <> 'Y'",
#                  "   AND apa02 BETWEEN ? AND ?  "     
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
#      PREPARE apb_pre5 FROM l_sql 
#
#      LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                              
#                  "  FROM rvv_file ",
#                  " WHERE rvv01= ? AND rvv02= ? AND rvv25<>'Y' "                     
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
#      PREPARE rvv_pre2 FROM l_sql         
#
#      LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
#                  "  FROM rvb_file,pmm_file,rva_file ",  
#                  " WHERE rvb01= ? AND rvb02= ? ",
#                  "   AND pmm01=rvb04 AND rva01 = rvb01",
#                  "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "  
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               
#      PREPARE pmm_pre1_1 FROM l_sql  
#
#      LET l_sql = "SELECT rva113,rva06,rva114 ",
#                  "  FROM rvb_file,rva_file ",
#                  " WHERE rvb01= ? AND rvb02= ? ",
#                  "   AND rva01 = rvb01   AND rvaconf <> 'X'  "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               
#      PREPARE pmm_pre1_2 FROM l_sql                                                                                          
#
#      LET l_sql = "SELECT COUNT(*) ",       
#                  "  FROM rvv_file ",                                                                        
#                  " WHERE rvv01 = ? AND rvv02 = ? AND rvv25 = 'Y' "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
#      PREPARE rvv_pre1 FROM l_sql          
      
#      LET l_sql = "SELECT azf03 ",                                                                              
#                  "  FROM azf_file ",
#                  " WHERE azf01= ? AND azf02='G' "          
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
#      PREPARE azf_pre1 FROM l_sql     

#      LET l_sql = "SELECT ima202 ",                                                                              
#                  " FROM ima2_file ",
#                  " WHERE ima201= ? "                        
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
#      PREPARE ima_pre1 FROM l_sql  
#
#      LET l_sql = "SELECT ima131 ",                                                        
#                  "  FROM ima_file ",                       
#                  " WHERE ima01 = ? "                          
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
#      PREPARE ima_pre2 FROM l_sql  
#
#      LET l_sql = "SELECT azf03 ",   
#                  "  FROM azf_file ",
#                  " WHERE azf01= ? AND azf02='G'"   
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
#      PREPARE azf_pre4 FROM l_sql                                                                                          
#
#      LET l_sql = "SELECT azf03 ",                                                                              
#                  "  FROM azf_file ",
#                  " WHERE azf01= ? AND azf02='G'"  
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
#      PREPARE azf_pre5 FROM l_sql                                                                                          
#
#      LET l_sql = "SELECT pmc03,pmc903 ",                                                                              
#                  "  FROM pmc_file ",
#                  " WHERE pmc01= ? "
#      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
#      PREPARE pmc_pre1 FROM l_sql                                                                                          
#
#      #FUN-C80092--add--121217--
     IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
     CASE tm.type
       WHEN '1'    #一般採購
        IF g_auto_gen='Y' THEN
           DELETE FROM ckl_file WHERE ckl07=g_ccz.ccz01 AND ckl08=g_ccz.ccz02 AND ckl01='399_1'
        END IF
        LET l_sql = "SELECT '',nvl(trim(ima12),'') ima12,'' azf03,nvl(trim(ima01),'') ima01,ima02,ima021,tlfccost,",          #FUN-7C0101 ADD tlfccost
                 " nvl(trim(tlf021),'') tlf021,nvl(trim(tlf031),'') tlf031,imd02,tlf06,tlf026,tlf027,tlf036,tlf037,",
                 " nvl(trim(tlf01),'') tlf01,tlf10*tlf60,tlfc21,tlf13,tlf65,tlf19,pmc03,tlf905,tlf906,tlf907,",
                 " '',nvl(trim(ima57),'') ima57,nvl(trim(ima08),'') ima08,nvl(trim(ima131),'') ima131,nvl(trim(apa44),'') apa44",    #No.9451  #FUN-7C0101 tlf21-->tlfc21  #FUN-8B0026 Add ,ima57,ima08   #FUN-D50112 add apa44
           #     " FROM ",cl_get_target_table(m_plant[l_i],'tlf_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
                 " FROM tlf_file LEFT OUTER JOIN tlfc_file ",
                 " ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",  #FUN-A10098
                 "                                            tlfc06 = tlf06  AND tlfc13 = tlf13  AND ",
                 "                                            tlfc902= tlf902 AND tlfc903= tlf903 AND ",
                 "                                            tlfc904= tlf904 AND tlfc905= tlf905 AND ",
                 "                                            tlfc906= tlf906 AND tlfc907= tlf907 AND ",
                 "                                            tlfctype = '",tm.type1,"' ",
                 " LEFT OUTER JOIN imd_file ON tlf031 = imd01 ",         # cj  
                 " LEFT OUTER JOIN pmc_file ON pmc01  = tlf19 ",         #fr
                 " LEFT OUTER JOIN apb_file ON tlf905 = apb21 ",   #FUN-D50112
                 " LEFT OUTER JOIN apa_file ON apa01 = apb01 ",    #FUN-D50112
      #          "     ,",cl_get_target_table(m_plant[l_i],'ima_file'), #FUN-A70084
                 "     ,ima_file ",
                 " WHERE ima01 = tlf01",
                 " AND (tlf13 = 'apmt150' OR tlf13 = 'apmt1072' ",
                 "      OR tlf13 = 'apmt230') ", #No.4681 add
                 " AND ",tm.wc CLIPPED," AND ",g_filter_wc CLIPPED,
                 " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
            #    " AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")"    #FUN-A10098   #FUN-A70084
                 " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
                 " AND 'Y' = (SELECT smydmy1 FROM smy_file WHERE smyslip = substr(tlf905,0,instr(tlf905,'-')-1)) "    #FUN-D10022 add
       WHEN '2'    #委外工單
         IF tm.costdown ='Y' THEN
#           LET l_costdown =" OR tlf13 = 'apmt1072' "   #FUN-D20078 mark
            LET l_costdown =" OR (tlf13 = 'asft6201' OR tlf13 = 'apmt230') "   #FUN-D20078 add
         ELSE
            LET l_costdown =''
         END IF
         IF g_auto_gen='Y' THEN
            DELETE FROM ckl_file WHERE ckl07=g_ccz.ccz01 AND ckl08=g_ccz.ccz02 AND ckl01='399_2'
         END IF
         LET l_sql = "SELECT '',nvl(trim(ima12),'') ima12,'' azf03,nvl(trim(ima01),'') ima01,ima02,ima021,tlfccost,",              #FUN-7C0101 ADD tlfccost    
                    " nvl(trim(tlf021),'') tlf021,nvl(trim(tlf031),'') tlf031,imd02,tlf06,tlf026,tlf027,tlf036,tlf037,",
                    " tlf01,tlf10*tlf60,tlfc21,tlf13,tlf65,tlf19,pmc03,tlf905,tlf906,tlf907,'',",
                    " nvl(trim(ima57),'') ima57,nvl(trim(ima08),'') ima08,nvl(trim(ima131),'') ima131,nvl(trim(apa44),'') apa44", #No.9451  #FUN-7C0101 tlf21-->tlfc21 #	FUN-8B0026 Add ,ima57,ima08  #FUN-D50112 add apa44 
               #    "  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file'),   #FUN-A10098   #FUN-A70084 m_dbs-->m_plant
                    "  FROM tlf_file LEFT OUTER JOIN tlfc_file ", 
                    " ON tlfc01 = tlf01  AND tlfc02 = tlf02  AND ",  #FUN-A10098
                    "                        tlfc03 = tlf03  AND tlfc06 = tlf06  AND ",
                    "                        tlfc13 = tlf13 AND ",  #FUN-9B0009  add
                    "                        tlfc902= tlf902 AND tlfc903= tlf903 AND ",
                    "                        tlfc904= tlf904 AND tlfc905= tlf905 AND ",
                    "                        tlfc906= tlf906 AND tlfc907= tlf907 AND ",
                    "                        tlfctype =  '",tm.type1,"' ",
                    " LEFT OUTER JOIN imd_file ON tlf031 = imd01 ",  #cj
                    " LEFT OUTER JOIN pmc_file ON pmc01  = tlf19 ",  #fr
                    " LEFT OUTER JOIN apb_file ON tlf905 = apb21 ",   #FUN-D50112
                    " LEFT OUTER JOIN apa_file ON apa01 = apb01 ",    #FUN-D50112
                #   ",",cl_get_target_table(m_plant[l_i],'ima_file'),",",cl_get_target_table(m_plant[l_i],'sfb_file'),   #FUN-A10098   #FUN-A70084
                    ",ima_file ,sfb_file ",   
                    " WHERE ima01 = tlf01",
                    " AND sfb01 = tlf62",
                    " AND (sfb02 = 7 OR sfb02 = 8) ",  #No:9584
                    " AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231'",l_costdown,") ",  #MOD-740381 add  tlf13='asft6231'  #FUN-BB0063 
                    " AND ",tm.wc CLIPPED," AND ",g_filter_wc CLIPPED,
                    " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                 #  " AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")" #FUN-A10098   #FUN-A70084	
                    " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
                    " AND 'Y' = (SELECT smydmy1 FROM smy_file WHERE smyslip = substr(tlf905,0,instr(tlf905,'-')-1)) "  #FUN-D10022 add
       WHEN '3'   #非委外工單但製程有委外,不用輸入倉庫,所以不考慮倉庫
         LET tm.wc = cl_replace_str(tm.wc,'tlf19','rvu04')   #MOD-980199
         LET tm.wc = cl_replace_str(tm.wc,'tlf01','rvv31')   #add by liuyya 20170809
         IF tm.costdown ='Y' THEN
            LET l_costdown =" OR rvu00='3' "
         ELSE
            LET l_costdown =''
         END IF
         IF g_auto_gen='Y' THEN
            DELETE FROM ckl_file WHERE ckl07=g_ccz.ccz01 AND ckl08=g_ccz.ccz02 AND ckl01='399_3'
         END IF
         LET l_sql = "SELECT rvu00,nvl(trim(ima12),'') ima12,'' azf03,nvl(trim(ima01),'') ima01,ima02,ima021,'',", 
                     " '','','',rvu03,rvu01,rvv02,rvu01,rvv02,", #FUN-BB0063 add
                     #倉庫,倉庫,單據日,來源異動單號,異動項次,目的異動單號,異動項次   #項次不考慮,因為一張入庫一個ap
                     " rvv31,rvv87,0,'','',rvu04,pmc03,rvv01,rvv02,decode(rvu00,'1',1,'3',-1,0),'',",
                     " nvl(trim(ima57),'') ima57,nvl(trim(ima08),'') ima08,nvl(trim(ima131),'') ima131,nvl(trim(apa44),'') apa44", #只會有入不會有出   #FUN-8B0026 Add ,ima57,ima08    #FUN-D50112 add apa44
                     #異動料件編號,異動數量,成會異動成本,異動命令代號,傳票編號,異動廠商�客戶編號/部門編號,單號,項次,入出庫碼
              #      "  FROM ",cl_get_target_table(m_plant[l_i],'rvu_file'),",",cl_get_target_table(m_plant[l_i],'rvv_file'),",",cl_get_target_table(m_plant[l_i],'ima_file'),",",   #FUN-A10098
                     "  FROM rvu_file LEFT OUTER JOIN pmc_file ON pmc01  = rvu04 ",
                     " LEFT OUTER JOIN apb_file ON rvu01 = apb21 ",   #FUN-D50112
                     " LEFT OUTER JOIN apa_file ON apa01 = apb01 ",    #FUN-D50112
                     "      ,rvv_file,ima_file ,sfb_file ",
                     " WHERE rvu01 = rvv01  ",
                     " AND rvu08='SUB' ",
                     " AND ima01 = rvv31 ",
                     " AND rvv18 = sfb01 ",
                     " AND sfb02 not in('7','8') ",
                     " AND (rvu00='1'",l_costdown," )", #FUN-BB0063
                     " AND ",tm.wc CLIPPED," AND ",g_filter_wc CLIPPED,
                     " AND rvuconf = 'Y' ",
                     " AND (rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')" ,                         #FUN-9B0009 dele ','
                     " AND 'Y' = (SELECT smydmy1 FROM smy_file WHERE smyslip = substr(rvv01,0,instr(rvv01,'-')-1)) "   #FUN-D10022 add
         LET tm.wc = cl_replace_str(tm.wc,'rvu04','tlf19')   #MOD-980199
     END CASE
     #FUN-D10022--add--str--
     LET l_sql = " INSERT INTO q700_tmp  ",l_sql CLIPPED    
     PREPARE q700_ins FROM l_sql                               
     EXECUTE q700_ins                                        
     PREPARE axcq700_prepare1 FROM l_sql
       #free:效能提升,減少批量數據處理 故pre23 pre24提到最前面。PS 不怕複雜可放入主sql
       IF tm.type_1 = '1' THEN
          LET l_sql =" DELETE FROM q700_tmp o ",
                     "  WHERE 'N'=(SELECT nvl(pmc903,'N') FROM pmc_file where pmc01=o.tlf19) "
          PREPARE q700_pre23 FROM l_sql
          EXECUTE q700_pre23 
       END IF 
       IF tm.type_1 = '2' THEN
          LET l_sql =" DELETE FROM q700_tmp o ",
                     "  WHERE 'Y'=(SELECT nvl(pmc903,'N') FROM pmc_file where pmc01=o.tlf19) "
          PREPARE q700_pre24 FROM l_sql
          EXECUTE q700_pre24 
       END IF      
     
       IF tm.type = '3' THEN
          LET l_sql = " UPDATE q700_tmp ",
                      "    SET tlf13 = 'asft6201' ",
                      "  WHERE code = '1' "
          PREPARE q700_pre01 FROM l_sql
          EXECUTE q700_pre01
          LET l_sql = " UPDATE q700_tmp ",
                      "    SET tlf13 = 'apmt1072' ",
                      "  WHERE code = '3' "
          PREPARE q700_pre02 FROM l_sql
          EXECUTE q700_pre02
          LET l_sql = " UPDATE q700_tmp ",
                      "    SET tlf13 = 'asft6101' ",
                      "  WHERE (code <> '1' AND code <> '3)' OR (trim(code) is null) "
          PREPARE q700_pre03 FROM l_sql
          EXECUTE q700_pre03
       END IF
       LET l_sql = " UPDATE q700_tmp SET tlf65 = 'UNAP' WHERE trim(tlf65) IS NULL " 
       PREPARE q700_pre04 FROM l_sql
       EXECUTE q700_pre04
       
       LET l_sql = " UPDATE q700_tmp SET code = ' '  " 
       PREPARE q700_pre04_1 FROM l_sql
       EXECUTE q700_pre04_1
       
       LET l_sql = 
                  " MERGE INTO q700_tmp o ",
                  "      USING (SELECT apa44,apb21,apb22 FROM apb_file,apa_file ",
                  "              WHERE apb01 = apa01 AND apa42 = 'N' AND apb34 <> 'Y' AND apb29 = '1') x ",
                  "         ON ( o.tlf036=x.apb21 AND o.tlf037=x.apb22 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.tlf65 = nvl(x.apa44,'UNAP') ",
                  "     WHERE (tlf13 = 'apmt150' OR tlf13='asft6201' OR tlf13='asft6231' OR tlf13 = 'apmt230') ",
                  "       AND (trim(tlf65) IS NULL OR tlf65 = ' ' OR tlf65 = 'UNAP') "
       PREPARE q700_pre05 FROM l_sql
       EXECUTE q700_pre05
       
       LET l_sql = 
                  " MERGE INTO q700_tmp o ",
                  "      USING (SELECT apb21,apb22,apb12,SUM(apb101) apb101_sum FROM apb_file,apa_file ",
                  "              WHERE apa01 = apb01 AND apa42 = 'N' AND apb29='1' ",
                  "                AND (apa00 ='11' OR apa00 = '16') AND apb34 <> 'Y' ",
                  "                AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "              GROUP BY apb21,apb22,apb12 ) x ",
                  "         ON ( o.tlf036=x.apb21 AND o.tlf037=x.apb22 AND o.tlf01=x.apb12) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = apb101_sum ",
                  "     WHERE (tlf13 = 'apmt150' OR tlf13='asft6201' OR tlf13='asft6231' OR tlf13 = 'apmt230') "
       PREPARE q700_pre06 FROM l_sql
       EXECUTE q700_pre06

       LET l_sql ="    UPDATE q700_tmp o ",
                  "       SET o.amt01 = (SELECT ale09 FROM ale_file WHERE ale16=o.tlf036 AND ale17=o.tlf037 AND ale11=o.tlf01)",
                  "     WHERE (tlf13 = 'apmt150' OR tlf13='asft6201' OR tlf13='asft6231' OR tlf13 = 'apmt230') ",
                  "       AND trim(amt01) IS NULL"
       PREPARE q700_pre07 FROM l_sql
       EXECUTE q700_pre07

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT apb21,apb22,apb12,SUM(apb101) apb101_sum FROM apb_file,apa_file ",
                  "              WHERE apa01 = apb01 AND apa42 = 'N' AND apb29='1' ",
                  "                AND apa00 ='16' AND apb34 <> 'Y' ",
                  "                AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "              GROUP BY apb21,apb22,apb12 ) x ",
                  "         ON ( o.tlf036=x.apb21 AND o.tlf037=x.apb22 AND o.tlf01=x.apb12) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.apb101_sum, ",
                  "           o.code = '*' ",
                  "     WHERE (tlf13 = 'apmt150' OR tlf13='asft6201' OR tlf13='asft6231' OR tlf13 = 'apmt230') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre08 FROM l_sql
       EXECUTE q700_pre08

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT rvv01,rvv02,rvv04,rvv05,rvv39 FROM rvv_file,rva_file ",
                  "              WHERE rva01=rvv04 AND rvv25<>'Y' AND rva00<>'2'  ) x ",
                  "         ON ( o.tlf036=x.rvv01 AND o.tlf037=x.rvv02 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.rvv39* nvl((SELECT pmm42 FROM rvb_file,pmm_file,rva_file ",
                  "                               WHERE rvb01=x.rvv04 AND rvb02=x.rvv05 AND pmm01=rvb04 ",
                  "                                 AND rva01 = rvb01 AND rvaconf <> 'X'  AND pmm18 <> 'X'),1) ",
                  "     WHERE (tlf13 = 'apmt150' OR tlf13='asft6201' OR tlf13='asft6231' OR tlf13 = 'apmt230') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre09 FROM l_sql
       EXECUTE q700_pre09

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT rvv01,rvv02,rvv04,rvv05,rvv39 FROM rvv_file ",
                  "                LEFT OUTER JOIN rva_file ON rva01=rvv04 ",
                  "              WHERE rvv25<>'Y' AND nvl(rva00,'2')='2' ) x ",
                  "         ON ( o.tlf036=x.rvv01 AND o.tlf037=x.rvv02 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.rvv39* nvl((SELECT rva114 FROM rva_file,rvb_file ",
                  "                               WHERE rvb01=x.rvv04 AND rvb02=x.rvv05  ",
                  "                                 AND rva01 = rvb01   AND rvaconf <> 'X' ),1) ",
                  "     WHERE (tlf13 = 'apmt150' OR tlf13='asft6201' OR tlf13='asft6231' OR tlf13 = 'apmt230') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre10 FROM l_sql
       EXECUTE q700_pre10 

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT apb21,apb22,apa44 FROM apb_file,apa_file ",
                  "              WHERE apb01=apa01 AND apa42='N' AND apb34<>'Y' ) x ",
                  "         ON ( o.tlf026=x.apb21 AND o.tlf027=x.apb22 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.tlf65 = nvl(x.apa44,'UNAP') ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "       AND trim(tlf65) IS NULL "
       PREPARE q700_pre11 FROM l_sql
       EXECUTE q700_pre11 

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT apb21,apb22,apb12,SUM(apb101) apb101_sum FROM apb_file,apa_file ",
                  "              WHERE apb01=apa01 AND apa42 = 'N' AND apb29='3' AND apa00 ='21'",
                  "                 AND (apa58 ='2' OR apa58 = '3') AND apb34 <> 'Y' ",
                  "                 AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "               GROUP BY apb21,apb22,apb12 ) x ",
                  "         ON ( o.tlf026=x.apb21 AND o.tlf027=x.apb22 AND o.tlf01=x.apb12 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.apb101_sum ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') "
       PREPARE q700_pre12 FROM l_sql
       EXECUTE q700_pre12 


       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT apb21,apb22,apb12,SUM(ABS(apb101)) apb101_sum FROM apb_file,apa_file ",
                  "              WHERE apb01=apa01 AND apa42 = 'N' AND apb29='3' ",
                  "                 AND (apa00 ='11' OR apa00 = '26') AND apb34 <> 'Y' ",
                  "                 AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "               GROUP BY apb21,apb22,apb12 ) x ",
                  "         ON ( o.tlf026=x.apb21 AND o.tlf027=x.apb22 AND o.tlf01=x.apb12 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.apb101_sum ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "       AND trim(amt01) IS NULL"
       PREPARE q700_pre13 FROM l_sql
       EXECUTE q700_pre13 


       LET l_sql ="UPDATE q700_tmp o ",
                  "   SET o.tlf10  = o.tlf10 * o.tlf907, ",
                  "       o.tlf031 = o.tlf021, ",
                  "       o.imd02  = (SELECT x.imd02 FROM imd_file x WHERE x.imd01 = o.tlf021 AND ROWNUM=1 )",
                  " WHERE  (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') "
       PREPARE q700_pre14 FROM l_sql
       EXECUTE q700_pre14 

       LET l_sql ="UPDATE q700_tmp ",
                  "   SET tlf10  = 0 ",
                  " WHERE (tlf905,tlf906) IN (SELECT rvu01,rvv02 FROM rvu_file,rvv_file,sfb_file WHERE rvu01=rvv01 AND rvv18=sfb01 AND sfb99='Y') "
       PREPARE q700_pre140 FROM l_sql
       EXECUTE q700_pre140

#       LET l_sql ="UPDATE q700_tmp o ",
#                  "   SET o.amt01 = o.amt01 * o.tlf907 ",
#                  " WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
#                  "   AND o.amt01 > 0 "
#       PREPARE q700_pre15 FROM l_sql
#       EXECUTE q700_pre15 

       LET l_sql ="    UPDATE q700_tmp o ",
                  "       SET o.amt01 = (SELECT ale09 FROM ale_file ",
                  "                       WHERE tlf026=ale16 AND tlf027=ale17 AND tlf01=ale11) ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre16 FROM l_sql
       EXECUTE q700_pre16 

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT apb21,apb22,apb12,SUM(apb101) apb101_sum FROM apb_file,apa_file ",
                  "              WHERE apb01=apa01 AND apa42 = 'N' AND apb29='3' AND apa00 ='26' ",
                  "                 AND (apa58 ='2' OR apa58 = '3') AND apb34 <> 'Y' ",
                  "                 AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "               GROUP BY apb21,apb22,apb12 ) x ",
                  "         ON ( o.tlf026=x.apb21 AND o.tlf027=x.apb22 AND o.tlf01=x.apb12 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.apb101_sum, ",
                  "           o.code  = '*' ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre17 FROM l_sql
       EXECUTE q700_pre17 

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT rvv01,rvv02,rvv04,rvv05,rvv39 FROM rvv_file,rva_file ",
                  "              WHERE rva01=rvv04 AND (rvv04 IS NOT NULL OR rvv05 IS NOT NULL OR rvv39 IS NOT NULL) ",
                  "                AND rvv25<>'Y' AND rva00<>'2' ) x ",
                  "         ON ( o.tlf026=x.rvv01 AND o.tlf027=x.rvv02 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.rvv39* nvl((SELECT pmm42 FROM rvb_file,pmm_file,rva_file ",
                  "                               WHERE rvb01=x.rvv04 AND rvb02=x.rvv05 AND pmm01=rvb04 ",
                  "                                 AND rva01 = rvb01 AND rvaconf <> 'X'  AND pmm18 <> 'X'),1) ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre18 FROM l_sql
       EXECUTE q700_pre18

       LET l_sql =" MERGE INTO q700_tmp o ",
                  "      USING (SELECT rvv01,rvv02,rvv04,rvv05,rvv39 FROM rvv_file ",
                  "                LEFT OUTER JOIN rva_file ON rva01=rvv04 ",
                  "              WHERE (rvv04 IS NOT NULL OR rvv05 IS NOT NULL OR rvv39 IS NOT NULL)",
                  "                AND rvv25<>'Y' AND nvl(rva00,'2')='2' ) x ",
                  "         ON ( o.tlf036=x.rvv01 AND o.tlf037=x.rvv02 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = x.rvv39* nvl((SELECT rva114 FROM rva_file,rvb_file ",
                  "                               WHERE rva01 = rvb01 AND rvb01 = x.rvv04 ",
                  "                                 AND rvb02 = x.rvv05 AND rvaconf <> 'X' ),1) ",
                  "     WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "       AND trim(amt01) IS NULL "
       PREPARE q700_pre19 FROM l_sql
       EXECUTE q700_pre19 
       #free：q700_pre15下移,統一算入tlf907 ,避免重複運算的錯誤
       LET l_sql ="UPDATE q700_tmp o ",
                  "   SET o.amt01 = nvl(o.amt01 * o.tlf907,0) ",
                  " WHERE (tlf13 = 'apmt1072' OR tlf13 = 'asft6101') ",
                  "   AND o.amt01 > 0 "
       PREPARE q700_pre15 FROM l_sql
       EXECUTE q700_pre15 
       
       LET l_sql = 
                  " MERGE INTO q700_tmp o ",
                  "      USING (SELECT rvv01,rvv02 FROM rvv_file ",
                  "              WHERE rvv25 = 'Y' ) x ",
                  "         ON ( o.tlf905=x.rvv01 AND o.tlf906=x.rvv02 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = 0  ,",
                  "           o.code  = '%' "
       PREPARE q700_pre20 FROM l_sql
       EXECUTE q700_pre20

       IF tm.costdown='Y' AND tm.type MATCHES '[23]' THEN
          LET l_sql = 
                  " MERGE INTO q700_tmp o ",
                  "      USING (SELECT rvv01,rvv02,rvv39*-1 rvv39_new FROM rvv_file ",
                  "              WHERE rvv25 = 'Y' ) x ",
                  "         ON ( o.tlf026=x.rvv01 AND o.tlf027=x.rvv02 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.amt01 = nvl(x.rvv39_new,0) ",
#                 "     WHERE o.tlf13='apmt1072' AND (o.amt01=0 OR trim(o.amt01) IS NULL)"         #FUN-D20078 mark
                  "     WHERE (o.tlf13='asft6201' OR o.tlf13='apmt230') AND (o.amt01=0 OR trim(o.amt01) IS NULL)"         #FUN-D20078 add
          PREPARE q700_pre21 FROM l_sql
          EXECUTE q700_pre21
       END IF 
           
       LET l_sql =" UPDATE q700_tmp o ",
                  "    SET o.azf03 = (SELECT azf03 FROM azf_file WHERE azf01= o.ima12 AND azf02='G') "
       PREPARE q700_pre22 FROM l_sql
       EXECUTE q700_pre22  

     #FUN-D10022--add--end--
    #FUN-D50112 ---------Begin----------
       DELETE FROM q700_tmp_1
       LET l_sql1 = " SELECT * FROM q700_tmp " 

       LET l_sql = " INSERT INTO q700_tmp_1 ",
                 # " SELECT x.*,ROW_NUMBER() OVER (PARTITION BY tlf905,tlf01 ORDER BY tlf01, apa44) ",
                   " SELECT x.*,ROW_NUMBER() OVER (PARTITION BY tlf905,tlf906,tlf01 ORDER BY tlf01, apa44) ",#130628
                   "     FROM (",l_sql1 CLIPPED,") x "
       PREPARE q700_ins_01 FROM l_sql
       EXECUTE q700_ins_01

       LET l_sql = " MERGE INTO q700_tmp_1 o ",
                   "      USING (SELECT tlf905,wmsys.wm_con","cat(DISTINCT apa44) str_apa44 from tlf_file,apb_file,apa_file",
                   "              WHERE tlf905 = apb21 AND apa01 = apb01 ",
                   "           GROUP BY tlf905) n ",
                   "         ON (o.tlf905 = n.tlf905)",
                   " WHEN MATCHED ",
                   " THEN ",
                   "    UPDATE ",
                   "    SET o.apa44 = n.str_apa44"
              #    " WHERE o.apa44 IS NOT NULL "
       PREPARE q700_pre31 FROM l_sql
       EXECUTE q700_pre31
                   
     # SELECT COUNT(*) INTO l_cnt FROM q700_tmp_1  #lixh1
       LET l_sql =" DELETE FROM q700_tmp_1  ",
                  "  WHERE rowno > 1 "
       PREPARE q700_pre32 FROM l_sql
       EXECUTE q700_pre32

       SELECT COUNT(*) INTO l_cnt FROM q700_tmp_1  #lixh1
       DELETE FROM q700_tmp
       LET l_sql2 = " SELECT code,ima12,azf03,ima01,ima02,ima021,tlfccost,tlf021,tlf031,imd02,tlf06,",
                    "        tlf026,tlf027,tlf036,tlf037,tlf01,tlf10,tlfc21,tlf13,tlf65,tlf19,pmc03,tlf905,",
                    "        tlf906,tlf907,amt01,ima57,ima08,ima131,apa44",
                    "   FROM q700_tmp_1 "
       LET l_sql = " INSERT INTO q700_tmp ",
                   " SELECT x.* ",
                   "     FROM (",l_sql2 CLIPPED,") x "

       PREPARE q700_ins_02 FROM l_sql
       EXECUTE q700_ins_02
    #FUN-D50112 ---------End------------

#FUN-D10022--mark--str--
{
#     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#     PREPARE axcq700_prepare1 FROM l_sql
#     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#        CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
#        EXIT PROGRAM 
#     END IF
#     DECLARE axcq700_curs1 CURSOR FOR axcq700_prepare1
#     LET g_pageno = 0
#     FOREACH axcq700_curs1 INTO sr.*,l_ima57,l_ima08,l_ima131                         #FUN-8B0026 Add ,l_ima57,l_ima08
#       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#       LET x_flag = 'N'    #No:MOD-B10175 add
##free:寫入主sql中 
#       LET l_slip = s_get_doc_no(sr.tlf905)
#       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
#        WHERE smyslip = l_slip
#       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
#          CONTINUE FOREACH
#       END IF
##free:q700_pre01\q700_pre02\q700_pre01
#       IF tm.type = '3' THEN
#          IF sr.code = '1' THEN 
#             LET sr.tlf13 = 'asft6201'
#          ELSE
#             #FUN-BB0063(S)
#             IF sr.code = '3' THEN
#                LET sr.tlf13 = 'apmt1072'
#             ELSE
#             #FUN-BB0063(E)
#                LET sr.tlf13 = 'asft6101'
#             END IF
#          END IF
#       END IF       
# 
#       LET sr.code=' '
#       #-->採購入庫(內外購)
#       IF sr.tlf13 = 'apmt150' or sr.tlf13='asft6201' OR sr.tlf13='asft6231' #MOD-740381 add  tlf13='asft6231'
#          or sr.tlf13 = 'apmt230' THEN    #No.4681 add 
# 
#         #IF cl_null(sr.tlf65) OR sr.tlf65 = ' ' THEN                        #MOD-A40046 mark
#          IF cl_null(sr.tlf65) OR sr.tlf65 = ' ' OR sr.tlf65 = 'UNAP' THEN   #MOD-A40046 
#         #FUN-C80092--mark--121217--          
#         # LET l_sql = "SELECT apa44 ",                                                                              
#         # #FUN-A10098---BEGIN
#         # #           "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#         # #            l_dbs CLIPPED,"apa_file ",
#         #            #FUN-A70084--mod--str--
#         #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#         #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#         #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#         #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#         #            #FUN-A70084--mod--end
#         # #FUN-A10098---END
#         #             " WHERE apb21='",sr.tlf036,"'",
#         #             "   AND apb22='",sr.tlf037,"'",
#         #             "   AND apb01=apa01 ",
#         #             "   AND apa42 = 'N' ",
#         #             "   AND apb34 <> 'Y'"
#         #             ,"  AND apb29 = '1'"   #MOD-B80092 add
#         # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#         ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                                                 
#         ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#         # PREPARE apa_prepare3 FROM l_sql                                                                                          
#         # DECLARE apa_c3  CURSOR FOR apa_prepare3                                                                                 
#         # OPEN apa_c3                                                                                    
#         # FETCH apa_c3 INTO sr.tlf65
#         #FUN-C80092--mark--121217--
##free:q700_pre04\q700_pre05
#             EXECUTE apa_pre3 USING sr.tlf036,sr.tlf037 INTO sr.tlf65  #FUN-C80092 add 121217              
#          END IF
#          IF cl_null(sr.tlf65) THEN LET sr.tlf65 = 'UNAP' END IF
#          #LET l_sql = 
#          #           " MERGE INTO q700_tmp o ",
#          #           "      USING (SELECT apa01,apa42,apa44,apb01,apb21,apb22,apb29,apb34 FROM apb_file,apa_file ",
#          #           "      WHERE apb01 = apa01 AND apa42 = 'N' AND apb34 <> 'Y' AND apb29 = '1') x ",
#          #           "         ON ( x.apb21 = 0.tlf036
#          
#         #FUN-C80092--mark--121217--
#         # LET l_sql = "SELECT SUM(apb101) ",                       
#         # #FUN-A10098---BEGIN                                                       
#         # #            "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#         # #                      l_dbs CLIPPED,"apa_file ",
#         #            #FUN-A70084--mod--str--
#         #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#         #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#         #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#         #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#         #            #FUN-A70084--mod--end
#         # #FUN-A10098---END
#         #             " WHERE apa01 = apb01 AND apa42 = 'N'",
#         #             "   AND apb29='1' AND  apb21='",sr.tlf036,"'",
#         #             "   AND apb22='",sr.tlf037,"' AND apb12='",sr.tlf01,"' ",
#         #             "   AND (apa00 ='11' OR apa00 = '16') ",
#         #             "   AND apb34 <> 'Y'",
#         #             "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "       
#         # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#         ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                           
#         ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark 
#         # PREPARE apb_prepare3 FROM l_sql                                                                                          
#         # DECLARE apb_c3  CURSOR FOR apb_prepare3                                                                                 
#         # OPEN apb_c3                                                                                    
#         # FETCH apb_c3 INTO sr.amt01
#         #FUN-C80092--mark--121217-- 
##free:q700_pre06
#          EXECUTE apb_pre3 USING sr.tlf036,sr.tlf037,       #FUN-C80092 add 121217    
#                  sr.tlf01,tm.bdate,tm.edate INTO sr.amt01  #FUN-C80092 add 121217              
#          IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#
#         #IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF # MOD-580114    #No:MOD-B10175 mark
#         #IF  sr.amt01 = 0 THEN    #MOD-580114 add  #MOD-A40087 mark
#          IF x_flag = 'N' THEN                      #MOD-A40087
#            #FUN-C80092--mark--121217--  
#            # LET l_sql = "SELECT ale09 ",                                                                              
#            #            #"  FROM ",l_dbs CLIPPED,"ale_file ",    #FUN-A10098                                                                      
#            #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'ale_file'),  #FUN-A10098    #FUN-A70084                                                                  
#            #             "  FROM ",cl_get_target_table(m_plant[l_i],'ale_file'),  #FUN-A10098    #FUN-A70084                                                                  
#            #             " WHERE ale16='",sr.tlf036,"'",
#            #             "   AND ale17='",sr.tlf037,"'",
#            #             "   AND ale11='",sr.tlf01,"'" 
#            # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#            ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098      #FUN-A70084                                                                                                                                                                          
#            ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark 
#            # PREPARE ale_prepare3 FROM l_sql                                                                                          
#            # DECLARE ale_c3  CURSOR FOR ale_prepare3                                                                                 
#            # OPEN ale_c3                                                                                    
#            # FETCH ale_c3 INTO sr.amt01
#            #FUN-C80092--mark--121217--   
##free:q700_pre07
#             EXECUTE ale_pre3 USING sr.tlf036,sr.tlf037,sr.tlf01 INTO sr.amt01  #FUN-C80092 add 121217              
#             IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#                    
#            #IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF  #No:MOD-860019 add  #No:MOD-B10175 mark
#            #IF  sr.amt01 = 0 THEN  #MOD-580114 add  #MOD-A40087 mark
#             IF x_flag = 'N' THEN                    #MOD-A40087
#                LET sr.code='*'
#                #取暫估金額且當作未請款資料
#
#               #FUN-C80092--mark--121217--
#               # LET l_sql = "SELECT SUM(apb101) ",                                                                              
#               #            #FUN-A10098---BEGIN
#               #            #"  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#               #            #          l_dbs CLIPPED,"apa_file ",
#               #            #FUN-A70084--mod--str--
#               #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#               #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#               #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#               #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#               #            #FUN-A70084--mod--end
#               #            #FUN-A10098---END
#               #             " WHERE apa01 = apb01 AND apa42 = 'N'",
#               #             "   AND apb29='1' AND  apb21='",sr.tlf036,"'",
#               #             "   AND apb22='",sr.tlf037,"' AND apb12='",sr.tlf01,"' ",
#               #             "   AND apa00 ='16' ",
#               #             "   AND apb34 <> 'Y'",
#               #             "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "       
#               # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#               ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                                           
#               ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#               # PREPARE apb_prepare2 FROM l_sql                                                                                          
#               # DECLARE apb_c2  CURSOR FOR apb_prepare2                                                                                 
#               # OPEN apb_c2                                                                                    
#               # FETCH apb_c2 INTO sr.amt01
#               #FUN-C80092--mark--121217--
##free:q700_pre08
#                EXECUTE apb_pre2 USING sr.tlf036,sr.tlf037,sr.tlf01,tm.bdate,tm.edate INTO sr.amt01  #FUN-C80092 add 121217    
#                IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#                               
#               #IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 mark
#                #-->取採購單價
#               #IF sr.amt01 = 0 THEN  #No:MOD-860019 add  #MOD-A40087 mark
#                IF x_flag = 'N' THEN                      #MOD-A40087
#                  #FUN-C80092--mark--121217-- 
#                  # LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                              
#                  #            #"  FROM ",l_dbs CLIPPED,"rvv_file ", #FUN-A10098                                                                         
#                  #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvv_file'),#FUN-A10098   #FUN-A70084                                                                      
#                  #             "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),#FUN-A70084
#                  #             " WHERE rvv01='",sr.tlf036,"'",
#                  #             "   AND rvv02='",sr.tlf037,"'",
#                  #             "   AND rvv25<>'Y'"
#                  # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                  ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084                                                                                                                                                                                
#                  ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#                  # PREPARE rvv_prepare3 FROM l_sql                                                                                          
#                  # DECLARE rvv_c3  CURSOR FOR rvv_prepare3                                                                                 
#                  # OPEN rvv_c3                                                                                    
#                  # FETCH rvv_c3 INTO l_rvv04,l_rvv05,l_rvv39
#                  #FUN-C80092--mark--121217-- 
##free:q700_pre09\q700_pre10
#                   EXECUTE rvv_pre3 USING sr.tlf036,sr.tlf037 INTO l_rvv04,l_rvv05,l_rvv39  #FUN-C80092 add 121217    
#                        
#                         IF STATUS = 0 THEN
#                            SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01=l_rvv04   #MOD-C20103 add
#                           #FUN-C80092--mark--121217-- 
#                           # IF l_rva00 <> '2'THEN                                         #MOD-C20103 add 
#                           #   LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
#                           #              #FUN-A10098---BEGIN
#                           #              # "  FROM ",l_dbs CLIPPED,"rvb_file,",
#                           #              #           l_dbs CLIPPED,"pmm_file,",                                                                           
#                           #              #           l_dbs CLIPPED,"rva_file ",
#                           #              #FUN-A70084--mod--str--m_dbs-->m_plant
#                           #              #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvb_file'),",",
#                           #              #          cl_get_target_table(m_dbs[l_i],'pmm_file'),",",
#                           #              #          cl_get_target_table(m_dbs[l_i],'rva_file'),
#                           #               "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
#                           #                         cl_get_target_table(m_plant[l_i],'pmm_file'),",",
#                           #                         cl_get_target_table(m_plant[l_i],'rva_file'),
#                           #              #FUN-A70084--mod--end
#                           #              #FUN-A10098---END
#                           #               " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
#                           #               "   AND pmm01=rvb04 AND rva01 = rvb01",
#                           #               "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "     
#                           # #MOD-C20103 str  add------
#                           # ELSE
#                           #   LET l_sql = "SELECT rva113,rva06,rva114 ",
#                           #               "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
#                           #                         cl_get_target_table(m_plant[l_i],'rva_file'),
#                           #               " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
#                           #               "   AND rva01 = rvb01   AND rvaconf <> 'X'  "
#                           # END IF
#                           # #MOD-C20103 end  add------
#                           # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                           ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                           
#                           ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#                           # PREPARE pmm_prepare2 FROM l_sql                                                                                          
#                           # DECLARE pmm_c2  CURSOR FOR pmm_prepare2                                                                                 
#                           # OPEN pmm_c2                                                                                    
#                           # FETCH pmm_c2 INTO l_pmm22,l_rva06,l_pmm42
#                           #FUN-C80092--mark--121217--                  
#                           #FUN-C80092--add--121217--
#                           IF l_rva00 <> '2'THEN   
#                              EXECUTE pmm_pre2_1 USING l_rvv04,l_rvv05 INTO l_pmm22,l_rva06,l_pmm42
#                           ELSE
#                              EXECUTE pmm_pre2_2 USING l_rvv04,l_rvv05 INTO l_pmm22,l_rva06,l_pmm42
#                           END IF 
#                           #FUN-C80092--add--121217--
#                            
#                            IF STATUS <> 0 THEN
#                               LET l_pmm22=' '
#                               LET l_pmm42= 1
#                            END IF
#                            IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
#                            LET sr.amt01=l_rvv39*l_pmm42
#                         END IF
#                     END IF             #No.MOD-860019 add
#                 END IF
#             END IF
#             IF sr.amt01 IS NULL THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 add
#       END IF   
#       #-->倉庫退貨
#       IF sr.tlf13 = 'apmt1072' or sr.tlf13 = 'asft6101' THEN
#           IF cl_null(sr.tlf65) OR sr.tlf65 = ' ' THEN
#             #FUN-C80092--mark--121217--  
#             # LET l_sql = "SELECT apa44 ",                                                                              
#             #            #FUN-A10098---BEGIN
#             #            # "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#             #            #           l_dbs CLIPPED,"apa_file ",
#             #            #FUN-A770084--mod--str--m_dbs-->m_plant
#             #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#             #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#             #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#             #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#             #            #FUN-A70084--mod--end
#             #            #FUN-A10098---END
#             #             " WHERE apb21='",sr.tlf026,"' AND apb22='",sr.tlf027,"'",
#             #             "   AND apb01=apa01",
#             #             "   AND apa42 = 'N'  AND apb34 <> 'Y' "
#             # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#             ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                                  
#             ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#             # PREPARE apa_prepare2 FROM l_sql                                                                                          
#             # DECLARE apa_c2  CURSOR FOR apa_prepare2                                                                                 
#             # OPEN apa_c2                                                                                    
#             # FETCH apa_c2 INTO sr.tlf65
#             #FUN-C80092--mark--121217--
##free:q700_pre11
#              EXECUTE apa_pre2 USING sr.tlf026,sr.tlf027 INTO sr.tlf65  #FUN-C80092 add 121217   
#           END IF
#           IF cl_null(sr.tlf65) THEN LET sr.tlf65 = 'UNAP' END IF
#
#          #FUN-C80092--mark--121217 
#          # LET l_sql = "SELECT SUM(apb101) ",                                                                              
#          #            #FUN-A10098---BEGIN
#          #            #"  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#          #            #          l_dbs CLIPPED,"apa_file ",
#          #            #FUN-A70084--mod--str--m_dbs-->m_plant
#          #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#          #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#          #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#          #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#          #            #FUN-A70084--mod--end
#          #            #FUN-A10098---END
#          #             " WHERE apa01 = apb01 AND apa42 = 'N'",
#          #             "   AND apb29='3' AND  apb21='",sr.tlf026,"'",
#          #             "   AND apb22='",sr.tlf027,"' AND apb12='",sr.tlf01,"' ",
#          #             "   AND apa00 ='21' ",
#          #             "   AND (apa58 ='2' OR apa58 = '3') ",   #No.CHI-910019 add 
#          #             "   AND apb34 <> 'Y'",
#          #             "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "
#          # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#          ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098                                                                                                                                                                                   
#          ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084    #TQC-BB0182 mark 
#          # PREPARE apb_prepare1 FROM l_sql                                                                                          
#          # DECLARE apb_c1  CURSOR FOR apb_prepare1                                                                                 
#          # OPEN apb_c1                                                                                    
#          # FETCH apb_c1 INTO sr.amt01
#          #FUN-C80092--mark--121217
##free:q700_pre12
#           EXECUTE apb_pre1 USING sr.tlf026,sr.tlf027,sr.tlf01,tm.bdate,tm.edate INTO sr.amt01  #FUN-C80092 add 121217 
#           IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#
#         #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF  #No:MOD-860019 add  #No:MOD-B10175 mark
#          #抓取當月驗退沖帳的驗退金額
#         #IF sr.amt01 = 0 THEN   #MOD-A40087 mark
#          IF x_flag = 'N' THEN   #MOD-A40087
#            #FUN-C80092--mark--121217-- 
#            # LET l_sql = "SELECT SUM(ABS(apb101)) ",         #No.MOD-A80020                                                                      
#            #            #FUN-A10098---BEGIN
#            #            # "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#            #            #           l_dbs CLIPPED,"apa_file ",
#            #            #FUN-A70084--mod--str-- m_dbs-->m_plant
#            #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#            #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#            #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#            #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#            #            #FUN-A70084--mod--end
#            #            #FUN-A10098---END
#            #             " WHERE apa01 = apb01 AND apa42 = 'N'",
#            #             "   AND apb29='3' AND  apb21='",sr.tlf026,"'",
#            #             "   AND apb22='",sr.tlf027,"' AND apb12='",sr.tlf01,"' ",
#            #             "   AND (apa00 ='11' OR apa00 = '26') ",                          #TQC-970180 Add
#            #             "   AND apb34 <> 'Y'",
#            #             "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' " 
#            # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#            ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098       #FUN-A70084                                                                                                                                                                           
#            ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql     #FUN-A70084   #TQC-BB0182 mark 
#            # PREPARE apb_prepare4 FROM l_sql                                                                                          
#            # DECLARE apb_c4  CURSOR FOR apb_prepare4                                                                                 
#            # OPEN apb_c4                                                                                    
#            # FETCH apb_c4 INTO sr.amt01
#            #FUN-C80092--mark-- 
##free:q700_pre13
#             EXECUTE apb_pre4 USING sr.tlf026,sr.tlf027,sr.tlf01,tm.bdate,tm.edate INTO sr.amt01  #FUN-C80092 add 121217 
#             IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#
#          #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF  #No:MOD-B10175 mark
#          END IF
##free:q700_pre14,q700_pre15
#          LET sr.tlf10 = sr.tlf10 * sr.tlf907
#          IF sr.amt01 > 0 THEN                      #MOD-7B0184-add
#             LET sr.amt01 = sr.amt01 * sr.tlf907
#          END IF                                    #MOD-7B0184-add
#          LET sr.tlf031 = sr.tlf021
#          SELECT imd02 INTO sr.imd02 FROM imd_file WHERE imd01 = sr.tlf031  #cj
#          
#      #END IF    #No:MOD-B10175 mark
#       #IF cl_null(sr.amt01)  OR sr.amt01 = 0 THEN   #MOD-A40087 mark
#        IF x_flag = 'N' THEN                         #MOD-A40087
#          #FUN-C80092--mark--121217-- 
#          # LET l_sql = "SELECT ale09 ",                                                                              
#          #            #"  FROM ",l_dbs CLIPPED,"ale_file ",          #FUN-A10098                                                                  
#          #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'ale_file'),    #FUN-A10098   #FUN-A70084                                                                
#          #             "  FROM ",cl_get_target_table(m_plant[l_i],'ale_file'),    #FUN-A70084
#          #             " WHERE ale16='",sr.tlf026,"'",   #MOD-A70063 mod tlf036->tlf026
#          #             "   AND ale17='",sr.tlf027,"'",   #MOD-A70063 mod tlf037->tlf027
#          #             "   AND ale11='",sr.tlf01,"'"                             
#          # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#          ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                
#          ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql   #FUN-A70084   #TQC-BB0182 mark 
#          # PREPARE ale_prepare2 FROM l_sql                                                                                          
#          # DECLARE ale_c2  CURSOR FOR ale_prepare2                                                                                 
#          # OPEN ale_c2                                                                                    
#          # FETCH ale_c2 INTO sr.amt01
#          #FUN-C80092--mark--121217-- 
##free:q700_pre16
#           EXECUTE ale_pre2 USING sr.tlf026,sr.tlf027,sr.tlf01 INTO sr.amt01  #FUN-C80092 add 121217 
#           IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#              
#          #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF    #No:MOD-860019 add  #No:MOD-B10175 mark
#          #IF  sr.amt01 = 0 THEN  #MOD-580114 add  #MOD-A40087 mark
#           IF x_flag = 'N' THEN                    #MOD-A40087
#               LET sr.code='*'
#               #抓取倉退立暫估金額，且當作未請款金額
#              #IF sr.amt01 = 0 THEN   #MOD-A40087 mark
#                 #FUN-C80092--mark--121217--    
#                 # LET l_sql = "SELECT SUM(apb101) ",                                                                              
#                 #            #FUN-A10098---BEGIN
#                 #            # "  FROM ",l_dbs CLIPPED,"apb_file,",                                                                          
#                 #            #           l_dbs CLIPPED,"apa_file ",
#                 #            #FUN-A70084--mod--str--m_dbs-->m_plant
#                 #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'apb_file'),",",
#                 #            #          cl_get_target_table(m_dbs[l_i],'apa_file'),
#                 #             "  FROM ",cl_get_target_table(m_plant[l_i],'apb_file'),",",
#                 #                       cl_get_target_table(m_plant[l_i],'apa_file'),
#                 #            #FUN-A70084--mod--end
#                 #            #FUN-A10098---END
#                 #             " WHERE apa01 = apb01 AND apa42 = 'N'",
#                 #             "   AND apb29='3' AND  apb21='",sr.tlf026,"'",
#                 #             "   AND apb22='",sr.tlf027,"' AND apb12='",sr.tlf01,"' ",
#                 #             "   AND apa00 ='26' ",
#                 #             "   AND (apa58 ='2' OR apa58 = '3') ",   #No.CHI-910019 add
#                 #             "   AND apb34 <> 'Y'",
#                 #             "   AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' "     
#                 # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                 ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                           
#                 ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql   #FUN-A70084  #TQC-BB0182 mark      
#                 # PREPARE apb_prepare5 FROM l_sql                                           
#                 # DECLARE apb_c5  CURSOR FOR apb_prepare5                                                                                 
#                 # OPEN apb_c5                                                                                    
#                 # FETCH apb_c5 INTO sr.amt01
#                 #FUN-C80092--mark--121217-- 
##free:q700_pre17
#                  EXECUTE apb_pre5 USING sr.tlf026,sr.tlf027,sr.tlf01,tm.bdate,tm.edate INTO sr.amt01  #FUN-C80092 add 121217 
#                  IF cl_null(sr.amt01) THEN LET x_flag = 'N' ELSE LET x_flag = 'Y' END IF   #MOD-A40087 add
#       
#                 #IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 mark
#              #END IF   #MOD-A40087 mark
#               #-->取採購單價
#              #IF sr.amt01 = 0 THEN    #No:MOD-860019 add  #MOD-A40087 mark
#               IF x_flag = 'N' THEN                        #MOD-A40087
#                 #FUN-C80092--mark--121217--
#                 # LET l_sql = "SELECT rvv04,rvv05,rvv39 ",                                                                              
#                 #      #       "  FROM ",l_dbs CLIPPED,"rvv_file ",   #FUN-A10098                                                                        
#                 #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvv_file'),  #FUN-A10098  #FUN-A70084                                                                      
#                 #             "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'), #FUN-A70084 
#                 #             " WHERE rvv01='",sr.tlf026,"'",  #MOD-A70063 mod tlf036->tlf026
#                 #             "   AND rvv02='",sr.tlf027,"'",  #MOD-A70063 mod tlf037->tlf027
#                 #             "   AND rvv25<>'Y'"                                     
#                 # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#                 ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084     
#                 ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084   #TQC-BB0182 mark
#                 # PREPARE rvv_prepare2 FROM l_sql                                                                                          
#                 # DECLARE rvv_c2  CURSOR FOR rvv_prepare2                                                                                 
#                 # OPEN rvv_c2                                                                                    
#                 # FETCH rvv_c2 INTO l_rvv04,l_rvv05,l_rvv39
#                 #FUN-C80092--mark--121217-- 
#                  EXECUTE rvv_pre2 USING sr.tlf026,sr.tlf027 INTO l_rvv04,l_rvv05,l_rvv39  #FUN-C80092 add 121217 
#                  
#                  IF (l_rvv04 IS NOT NULL OR l_rvv05 IS NOT NULL OR l_rvv39 IS NOT NULL) THEN
#                      SELECT rva00 INTO l_rva00 FROM rva_file WHERE rva01=l_rvv04   #MOD-C20103 add
#                      #FUN-C80092--mark--121217-- 
#                      #IF l_rva00 <> '2'THEN                                         #MOD-C20103 add 
#                      #   LET l_sql = "SELECT pmm22,rva06,pmm42 ",                                                                              
#                      #              #FUN-A10098---BEGIN
#                      #              # "  FROM ",l_dbs CLIPPED,"rvb_file,",
#                      #              #           l_dbs CLIPPED,"pmm_file,",                                                                           
#                      #              #           l_dbs CLIPPED,"rva_file ",
#                      #              #FUN-A70084--mod--str--m_dbs--m_plant
#                      #              #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvb_file'),",",
#                      #              #          #cl_get_target_table(m_dbs[l_i],'pmm_file'),"pmm_file,",
#                      #              #          #cl_get_target_table(m_dbs[l_i],'rva_file'),"rva_file ",
#                      #              #          cl_get_target_table(m_dbs[l_i],'pmm_file'),",",   #FUN-A50102
#                      #              #          cl_get_target_table(m_dbs[l_i],'rva_file'),       #FUN-A50102
#                      #               "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
#                      #                         cl_get_target_table(m_plant[l_i],'pmm_file'),",", 
#                      #                         cl_get_target_table(m_plant[l_i],'rva_file'),    
#                      #              #FUN-A70084--mod--end
#                      #              #FUN-A10098---END
#                      #               " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
#                      #               "   AND pmm01=rvb04 AND rva01 = rvb01",
#                      #               "   AND rvaconf <> 'X'  AND pmm18 <> 'X' "   
#                      # #MOD-C20103 str  add------
#                      # ELSE
#                      #   LET l_sql = "SELECT rva113,rva06,rva114 ",
#                      #               "  FROM ",cl_get_target_table(m_plant[l_i],'rvb_file'),",",
#                      #                         cl_get_target_table(m_plant[l_i],'rva_file'),
#                      #               " WHERE rvb01='",l_rvv04,"' AND rvb02='",l_rvv05,"'",
#                      #               "   AND rva01 = rvb01   AND rvaconf <> 'X'  "
#                      # END IF
#                      # #MOD-C20103 end  add------                      
#                      # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102            
#                      ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                      
#                      ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084     #TQC-BB0182 mark 
#                      # PREPARE pmm_prepare1 FROM l_sql                                                                                          
#                      # DECLARE pmm_c1  CURSOR FOR pmm_prepare1                                                                                 
#                      # OPEN pmm_c1                                                                                    
#                      # FETCH pmm_c1 INTO l_pmm22,l_rva06,l_pmm42
#                      #FUN-C80092--mark--121217--
#                      #FUN-C80092--add--121217--
#                      IF l_rva00 <> '2' THEN  
#                         EXECUTE pmm_pre1_1 USING l_rvv04,l_rvv05 INTO l_pmm22,l_rva06,l_pmm42
#                      ELSE 
#                         EXECUTE pmm_pre1_2 USING l_rvv04,l_rvv05 INTO l_pmm22,l_rva06,l_pmm42
#                      END IF 
#                      #FUN-C80092--add--121217--
#                      IF STATUS <> 0 THEN
#                          LET l_pmm22=' '
#                          LET l_pmm42= 1
#                      END IF
#                      IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
##free:q700_pre18,q700_pre19
#                      LET sr.amt01=l_rvv39*l_pmm42
#                  END IF
#               END IF         #No.MOD-860019 add
##free:根據邏輯，將q700_pre15下調，統一算入tlf907, 包含nvl->0
#               IF sr.amt01 > 0 THEN                      
#                  LET sr.amt01 = sr.amt01 * sr.tlf907
#               END IF                                   
#           END IF
#       END IF
#       IF cl_null(sr.amt01) THEN LET sr.amt01 = 0 END IF   #No:MOD-B10175 add
#     END IF   #No:MOD-B10175 add
#
#       LET l_n = 0
#      #FUN-C80092--mark--121217-- 
#      # LET l_sql = "SELECT COUNT(*) ",                                                                              
#      #      #       "  FROM ",l_dbs CLIPPED,"rvv_file ",   #FUN-A10098
#      #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'rvv_file'),  #FUN-A10098  #FUN-A70084
#      #             "  FROM ",cl_get_target_table(m_plant[l_i],'rvv_file'),  #FUN-A70084
#      #             " WHERE rvv01 = '",sr.tlf905,"'",
#      #             "   AND rvv02 = '",sr.tlf906,"'",
#      #             "   AND rvv25 = 'Y' "   
#      # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102            
#      ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                           
#      ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#      # PREPARE rvv_prepare1 FROM l_sql                                                                                          
#      # DECLARE rvv_c1  CURSOR FOR rvv_prepare1                                                                                 
#      # OPEN rvv_c1                                                                                    
#      # FETCH rvv_c1 INTO l_n
#      #FUN-C80092--mark-121217--
##free:q700_pre20
#       EXECUTE rvv_pre1 USING sr.tlf905,sr.tlf906 INTO l_n  #FUN-C80092 add 121217       
#       IF l_n > 0 THEN
#          LET sr.amt01 = 0
#          LET sr.code = '%'     #樣品另外識別
#       END IF
#       
#
#      
#
##---------------------------------
#        LET g_msg=' '             #No.FUN-7C0090
##free:q700_pre21        
#       #FUN-BB0063(S)
#       #處理委外倉退
#       IF tm.costdown='Y' AND tm.type MATCHES '[23]' AND 
#          sr.tlf13='apmt1072' AND (sr.amt01=0 OR sr.amt01 IS NULL) THEN
#          SELECT rvv39*-1 INTO sr.amt01 FROM rvv_file 
#           WHERE rvv01=sr.tlf026 AND rvv02=sr.tlf027
#          IF sr.amt01 IS NULL THEN
#             LET sr.amt01 = 0
#          END IF
#       END IF
#       #FUN-BB0063(E)
##free:CASE中統一放入q700_pre22 
#       CASE tm.g
#       WHEN '2'
#          LET  wima01  = sr.ima01        
#         #FUN-C80092--mark--121217-- 
#         # LET l_sql = "SELECT azf03 ",                                                                              
#         #      #       "  FROM ",l_dbs CLIPPED,"azf_file ",   #FUN-A10098
#         #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),   #FUN-A10098  #FUN-A70084
#         #             "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'), #FUN-A70084
#         #             " WHERE azf01='",sr.ima12,"' AND azf02='G'"          
#         # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#         ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098     #FUN-A70084                                                                                                                                                                  
#         ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084   #TQC-BB0182 mark 
#         # PREPARE azf_prepare1 FROM l_sql                                                                                          
#         # DECLARE azf_c1  CURSOR FOR azf_prepare1                                                                                 
#         # OPEN azf_c1                                                                                    
#         # FETCH azf_c1 INTO g_msg
#         ##No.TQC-A40139  --End  
#         #FUN-C80092--mark--121217--
#          EXECUTE azf_pre1 USING sr.ima12 INTO g_msg  #FUN-C80092 add 121217       
#        
#    #free:此段無用，故未獨立修改臨時表語句    
#    #      IF  wima201 <> '99' THEN
#    #        #FUN-C80092--mark--121217--
#    #        # LET l_sql = "SELECT ima202 ",                                                                              
#    #        #        #     "  FROM ",l_dbs CLIPPED,"ima2_file ",  #FUN-A10098
#    #        #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'ima2_file'),  #FUN-A10098   #FUN-A70084
#    #        #             "  FROM ",cl_get_target_table(m_plant[l_i],'ima2_file'), #FUN-A70084 
#    #        #              " WHERE ima201= '",wima201,"'"                        
#    #        # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#    #        ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098      #FUN-A70084                                                                                                                                                   
#    #        ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql   #FUN-A70084  #TQC-BB0182 mark 
#    #        # PREPARE ima_prepare1 FROM l_sql                                                                                          
#    #        # DECLARE ima_c1  CURSOR FOR ima_prepare1                                                                                 
#    #        # OPEN ima_c1                                                                                    
#    #        # FETCH ima_c1 INTO wima202
#    #        #FUN-C80092--mark--121217-- 
#    #         EXECUTE ima_pre1 USING wima201 INTO wima202  #FUN-C80092 add 121217   
#    #      ELSE
#    #        #FUN-C80092--mark--121217--
#    #        # LET l_sql = "SELECT ima131 ",                                                                              
#    #        #         #    "  FROM ",l_dbs CLIPPED,"ima_file ",  #FUN-A10098
#    #        #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'ima_file'),  #FUN-A10098  #FUN-A70084
#    #        #             "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),  #FUN-A70084
#    #        #             " WHERE ima01 = '",sr.tlf01,"'"                          
#    #        # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#    #        ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                     
#    #        ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#    #        # PREPARE ima_prepare2 FROM l_sql                                                                                          
#    #        # DECLARE ima_c2  CURSOR FOR ima_prepare2                                                                                 
#    #        # OPEN ima_c2                                                                                    
#    #        # FETCH ima_c2 INTO wima202
#    #        #FUN-C80092--mark--121217-- 
#    #         EXECUTE ima_pre2 USING sr.tlf01 INTO wima202  #FUN-C80092 add 121217   
#    #      END IF
#    #      LET l_company=sr.tlf19,'  ',wpmc03
#    #     #FUN-C80092--mark--121217-- 
#    #     # LET l_sql = "SELECT azf03 ",                                                                              
#    #     #        #     "  FROM ",l_dbs CLIPPED,"azf_file ",   #FUN-A10098
#    #     #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),   #FUN-A10098  #FUN-A70084
#    #     #             "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'),   #FUN-A70084
#    #     #             " WHERE azf01='",sr.ima12,"' AND azf02='G'"                                                                                                                                                                                 
#    #     # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#    #     ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084
#    #     ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#    #     # PREPARE azf_prepare4 FROM l_sql                                                                                          
#    #     # DECLARE azf_c4  CURSOR FOR azf_prepare4                                                                                 
#    #     # OPEN azf_c4                                                                                    
#    #     # FETCH azf_c4 INTO g_msg
#    #     #FUN-C80092--mark--121217-- 
#    #      EXECUTE azf_pre4 USING sr.ima12 INTO g_msg  #FUN-C80092 add 121217 
#    #free:無用段 mark 結束
##free:統一放入q700_pre22    
#       OTHERWISE
#         #FUN-C80092--mark--121217--
#         # LET l_sql = "SELECT azf03 ",                                                                              
#         #       #      "  FROM ",l_dbs CLIPPED,"azf_file ",   #FUN-A10098
#         #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),   #FUN-A10098   #FUN-A70084
#         #             "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'), #FUN-A70084
#         #             " WHERE azf01='",sr.ima12,"' AND azf02='G'"             
#         # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#         ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                  
#         ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#         # PREPARE azf_prepare5 FROM l_sql                                                                                          
#         # DECLARE azf_c5  CURSOR FOR azf_prepare5                                                                                 
#         # OPEN azf_c5                                                                                    
#         # FETCH azf_c5 INTO g_msg
#         #FUN-C80092--mark--121217-- 
#          EXECUTE azf_pre5 USING sr.ima12 INTO g_msg  #FUN-C80092 add 121217 
#       END CASE
#        LET wpmc03  = ' '
#        LET wima202 = ' '
#        LET wima201 = sr.tlf01[1,2]
#
#       #FUN-C80092--mark--121217--                         
#       # LET l_sql = "SELECT pmc03,pmc903 ",                                                                              
#       #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'pmc_file'),  #FUN-A10098  #FUN-A70084
#       #             "  FROM ",cl_get_target_table(m_plant[l_i],'pmc_file'),  #FUN-A70084
#       #             " WHERE pmc01= '",sr.tlf19,"'"
#       # #No.TQC-A40139  --End  
#       # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
#       ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084                                                                                                                                                                                        
#       ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
#       # PREPARE pmc_prepare1 FROM l_sql                                                                                          
#       # DECLARE pmc_c1  CURSOR FOR pmc_prepare1                                                                                 
#       # OPEN pmc_c1  
#       # FETCH pmc_c1 INTO wpmc03,l_pmc903
#       #FUN-C80092--mark--121217-- 
#        EXECUTE pmc_pre1 USING sr.tlf19 INTO wpmc03,l_pmc903  #FUN-C80092 add 121217 
#
#        IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF
#        IF tm.type_1 = '1' THEN
#           IF l_pmc903 = 'N' THEN CONTINUE FOREACH END IF
#        END IF
#        IF tm.type_1 = '2' THEN
#           IF l_pmc903 = 'Y' THEN CONTINUE FOREACH END IF
#        END IF
#  
#          #FUN-C80092--modify--str--  #g_tlf->g_tlf_excel
#          LET g_tlf_excel[g_cnt].tlf031 = sr.tlf031
#          LET g_tlf_excel[g_cnt].imd02 = sr.imd02     #cj
#          LET g_tlf_excel[g_cnt].tlf905 = sr.tlf905
#          LET g_tlf_excel[g_cnt].tlf06  = sr.tlf06
#          LET g_tlf_excel[g_cnt].tlf19  = sr.tlf19
#          LET g_tlf_excel[g_cnt].wpmc03 = wpmc03
#          LET g_tlf_excel[g_cnt].tlf01  = sr.tlf01
#          LET g_tlf_excel[g_cnt].ima02  = sr.ima02
#          LET g_tlf_excel[g_cnt].ima021 = sr.ima021   #cj
#          LET g_tlf_excel[g_cnt].tlf10  = sr.tlf10
#          LET g_tlf_excel[g_cnt].tlf221 = sr.amt01
#          LET g_tlf_excel[g_cnt].ima57 = l_ima57      #cj
#          LET g_tlf_excel[g_cnt].ima131 = l_ima131    #cj
#          LET g_tlf_excel[g_cnt].ima12 = sr.ima12
#          LET g_tlf_excel[g_cnt].azf03 = g_msg        #cj
#          LET g_tlf_excel[g_cnt].ima08 = l_ima08      #cj
#          LET l_num = l_num + sr.tlf10
#          LET l_tot = l_tot + sr.amt01
#          IF g_bgjob <> 'Y' THEN
#             INSERT INTO q700_tmp VALUES(g_tlf_excel[g_cnt].*) #FUN-C80092 mark 121217
#          END IF
#          #FUN-C80092--add--121217--
#          IF g_cnt <= g_max_rec THEN 
#             LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
#          END IF 
#          #FUN-C80092--add--121217--
#          #FUN-C80092--modify--end--
#          IF g_auto_gen='Y' THEN
#             CASE tm.type
#                WHEN '1'  LET l_type1 = '399_1'
#                WHEN '2'  LET l_type1 = '399_2'
#                WHEN '3'  LET l_type1 = '399_3'
#             END CASE
#             INSERT INTO ckl_file VALUES(l_type1,sr.tlf905,sr.tlf906,sr.tlf01,sr.tlf10,sr.amt01,g_ccz.ccz01,g_ccz.ccz02)
#          END IF
#          LET g_cnt = g_cnt + 1
#     END FOREACH
}  #FUN-D10022--mark--
#  END FOR       
   #FUN-C80092--add--121217--
#CJ
#  IF g_cnt <= g_max_rec THEN 
#     CALL g_tlf.deleteElement(g_cnt)
#  END IF 
#  CALL g_tlf_excel.deleteElement(g_cnt)
#  LET g_cnt=g_cnt-1
#  LET g_rec_b = g_cnt
#  IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
#     CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
#     LET g_rec_b = g_max_rec
#  END IF
#CJ--
   #FUN-C80092--add--121217--  
   #FUN-8B0026     
   #写入ckk_file
   SELECT sum(tlf10),sum(amt01) INTO l_num,l_tot FROM q700_tmp   #FUN-D10022 add
   IF g_auto_gen = 'Y' THEN 
      CASE tm.type WHEN '1' LET l_type = '303'
                            LET l_msg1 = 'axc-454'
                   WHEN '2' LET l_type = '304' 
                            LET l_msg1 = 'axc-455'
                   WHEN '3' LET l_type = '305' 
                            LET l_msg1 = 'axc-456'
      END CASE
      CALL s_ckk_fill('',l_type,l_msg1,g_ccz.ccz01,g_ccz.ccz02,g_prog,tm.type1,l_num,l_tot,l_tot,0,0,
                      0,0,0,0,0,l_msg,g_user,g_today,g_time,'Y')
           RETURNING g_ckk.*
      IF NOT s_ckk(g_ckk.*,'') THEN END IF
   END IF 
   IF g_bgjob='Y' THEN CALL q700_b_fill() END IF  #FUN-D10022
   #CALL axcq700_b_fill()  #FUN-C80092
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
END FUNCTION
#No.FUN-A30008--end 

FUNCTION q700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
#FUN-D10002--chenjing--add--str--
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND NOT cl_null(g_auto_gen) AND g_flag != '1' THEN
      CALL q700_b_fill()
   END IF
#FUN-D10002--chenjing--add--end--
   LET g_action_choice = " "
   LET g_flag = " "    #chenjing
   IF cl_null(tm.s) THEN LET tm.s = '2' END IF   #chenjing
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY tm.bdate TO FORMONLY.bdate
   DISPLAY tm.edate TO FORMONLY.edate
   DISPLAY tm.type1 TO FORMONLY.type1     #TQC-D30024 

   DISPLAY g_rec_b TO FORMONLY.cnt  #FUN-C80092 g_cnt->g_rec_b
   DISPLAY l_num TO FORMONLY.num
   DISPLAY l_tot TO FORMONLY.tot
#chenjing--add--str--
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.s FROM s ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE s
            IF NOT cl_null(tm.s)  THEN 
               CALL q700_b_fill_2()
               CALL q700_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q700_b_fill()
               CALL g_tlf_1.clear()
            END IF
            DISPLAY BY NAME tm.s
            EXIT DIALOG
      END INPUT
#chenjing--add--end--
   DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A30008 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
#No.FUN-A30008 --end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY

#chenjing--add--
      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          
         #CALL q700_b_fill()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG
#chenjing--add-- 
  #   ON ACTION output
  #      LET g_action_choice="output"
  #      EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q700_b_fill()
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  i          LIKE type_file.num5
  DEFINE  l_tlf906   LIKE tlf_file.tlf906   #FUN-D10022 add
  DEFINE  l_type1    LIKE ckl_file.ckl01    #FUN-D10022 add
          
   LET g_sql = "SELECT ima12,azf03,ima01,ima02,ima021,ima57,ima08,tlf19, ",
               "       pmc03,tlf031,imd02,tlf905,tlf06,ima131,apa44,tlf10,amt01,tlf906 ",   #FUN-D50112 add apa44
               "  FROM q700_tmp  "
               
   PREPARE axcq700_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR axcq700_pb
 
   CALL g_tlf.clear()
   CALL g_tlf_excel.clear()  #FUN-C80092 add
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH tlf_curs INTO g_tlf_excel[g_cnt].*,l_tlf906
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      #FUN-C80092--add--str--
      IF g_cnt <= g_max_rec THEN 
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF 
      #FUN-C80092--add--end--
      #FUN-D10022--add--str--
      IF g_auto_gen='Y' THEN
         CASE tm.type
            WHEN '1'  LET l_type1 = '399_1'
            WHEN '2'  LET l_type1 = '399_2'
             WHEN '3'  LET l_type1 = '399_3'
         END CASE
         INSERT INTO ckl_file VALUES(l_type1,g_tlf_excel[g_cnt].tlf905,l_tlf906,g_tlf_excel[g_cnt].tlf01,g_tlf_excel[g_cnt].tlf10,g_tlf_excel[g_cnt].tlf221,g_ccz.ccz01,g_ccz.ccz02)
      END IF
      #FUN-D10022--add--end--
      LET g_cnt = g_cnt + 1
      #FUN-C80092--mark--str--
      #IF g_cnt > g_max_rec THEN
      #   CALL cl_err( '', 9035, 0 )
      #   EXIT FOREACH
      #END IF
      #FUN-C80092--mark--end--
   END FOREACH
   CALL cl_show_fld_cont()
   #CALL g_tlf.deleteElement(g_cnt)  #FUN-C80092 mark
   #FUN-C80092--add--str--
   IF g_cnt <= g_max_rec THEN 
      CALL g_tlf.deleteElement(g_cnt)
   END IF 
   CALL g_tlf_excel.deleteElement(g_cnt)
   #FUN-C80092--add--end--
   LET g_cnt=g_cnt-1
   LET g_rec_b = g_cnt
   #FUN-C80092--add--str--
   #IF g_rec_b > g_max_rec THEN  #FUN-C80092
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   #FUN-C80092--add--end--

END FUNCTION
 
FUNCTION q700_set_entry_1()
#   CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)   #chenjing
    CALL cl_set_comp_entry("g_auto_gen",TRUE)
    CALL cl_set_comp_entry('bdate,edate,type1',TRUE) #FUN-C80092 add
     
END FUNCTION
FUNCTION q700_set_no_entry_1()
    #FUN-C80092--add--by--free--
    IF NOT cl_null(g_argv8) AND NOT cl_null(g_argv9) AND NOT cl_null(g_argv17) THEN 
       CALL s_azn01(g_argv8,g_argv9) RETURNING tm.bdate,tm.edate
       LET tm.type1 = g_argv17
       DISPLAY BY NAME tm.*
       CALL cl_set_comp_entry('bdate,edate,type1',FALSE)
   END IF 
   #FUN-C80092--add--by--free--
    IF tm.bdate <> g_bdate OR tm.edate <> g_edate THEN
       CALL cl_set_comp_entry("g_auto_gen",FALSE)
       LET g_auto_gen = 'N'
       DISPLAY BY NAME g_auto_gen
    END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12 
#FUN-A70084--add--str--
FUNCTION q700_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group07,b",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION
{    #chenjing
#FUNCTION q700_set_visible()
#DEFINE l_cnt    LIKE type_file.num5
#DEFINE l_azw05  LIKE azw_file.azw05
#
#  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
#  SELECT count(*) INTO l_cnt FROM azw_file
#   WHERE azw05 = l_azw05
#
#  IF l_cnt > 1 THEN
#     CALL cl_set_comp_visible("group07",FALSE)
#  END IF
#  RETURN l_cnt
#END FUNCTION
#}#chenjing

FUNCTION q700_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF  
   END FOR 
   RETURN 1
END FUNCTION
FUNCTION q700_table()
   DROP TABLE q700_tmp;
   DROP TABLE q700_tmp_1; #FUN-D50112
   DROP TABLE q700_tmp_2; #FUN-D50112
   #FUN-D10022--mark--str--
   #CREATE TEMP TABLE q700_tmp(
   #                ima12         LIKE ima_file.ima12,      
   #                azf03         LIKE azf_file.azf03,
   #                tlf01         LIKE tlf_file.tlf01,  
   #                ima02         LIKE ima_file.ima02,  
   #                ima021        LIKE ima_file.ima021,
   #                ima57         LIKE ima_file.ima57,    
   #                ima08         LIKE ima_file.ima08,   
   #                tlf19         LIKE tlf_file.tlf19,    
   #                pmc03         LIKE pmc_file.pmc03,   
   #                tlf031        LIKE tlf_file.tlf026,       
   #                imd02         LIKE imd_file.imd02,       
   #                tlf905        LIKE tlf_file.tlf905,     
   #                tlf06         LIKE tlf_file.tlf06,     
   #                ima131        LIKE ima_file.ima131,    
   #                tlf10         LIKE tlf_file.tlf10,  
   #                amt01        LIKE tlf_file.tlf221)
   #FUN-D10022--mark--end--
   #FUN-D10022--add--str--
   CREATE TEMP TABLE q700_tmp(
             code     LIKE type_file.chr1,     
             ima12    LIKE ima_file.ima12,
             azf03    LIKE azf_file.azf03,      
             ima01    LIKE ima_file.ima01,
             ima02    LIKE ima_file.ima02,
             ima021   LIKE ima_file.ima021,  
             tlfccost LIKE tlfc_file.tlfccost,  
             tlf021   LIKE tlf_file.tlf021,
             tlf031   LIKE tlf_file.tlf031,
             imd02    LIKE imd_file.imd02,    
             tlf06    LIKE tlf_file.tlf06,
             tlf026   LIKE tlf_file.tlf026,
             tlf027   LIKE tlf_file.tlf027,
             tlf036   LIKE tlf_file.tlf036,
             tlf037   LIKE tlf_file.tlf037,
             tlf01    LIKE tlf_file.tlf01,
             tlf10    LIKE tlf_file.tlf10,
             tlfc21   LIKE tlfc_file.tlfc21,   
             tlf13    LIKE tlf_file.tlf13,
             tlf65    LIKE tlf_file.tlf65,
             tlf19    LIKE tlf_file.tlf19,
             pmc03    LIKE pmc_file.pmc03,
             tlf905   LIKE tlf_file.tlf905,
             tlf906   LIKE tlf_file.tlf906,
             tlf907   LIKE tlf_file.tlf907,
             amt01    LIKE tlf_file.tlf221,
             ima57    LIKE ima_file.ima57,
             ima08    LIKE ima_file.ima08,
             ima131   LIKE ima_file.ima131,
             apa44    LIKE type_file.chr200)   #FUN-D50112 add apa44
    #FUN-D10022--add--end--
  #FUN-D50112 ----------Begin--------
   CREATE TEMP TABLE q700_tmp_1(
             code     LIKE type_file.chr1,
             ima12    LIKE ima_file.ima12,
             azf03    LIKE azf_file.azf03,
             ima01    LIKE ima_file.ima01,
             ima02    LIKE ima_file.ima02,
             ima021   LIKE ima_file.ima021,
             tlfccost LIKE tlfc_file.tlfccost,
             tlf021   LIKE tlf_file.tlf021,
             tlf031   LIKE tlf_file.tlf031,
             imd02    LIKE imd_file.imd02,
             tlf06    LIKE tlf_file.tlf06,
             tlf026   LIKE tlf_file.tlf026,
             tlf027   LIKE tlf_file.tlf027,
             tlf036   LIKE tlf_file.tlf036,
             tlf037   LIKE tlf_file.tlf037,
             tlf01    LIKE tlf_file.tlf01,
             tlf10    LIKE tlf_file.tlf10,
             tlfc21   LIKE tlfc_file.tlfc21,
             tlf13    LIKE tlf_file.tlf13,
             tlf65    LIKE tlf_file.tlf65,
             tlf19    LIKE tlf_file.tlf19,
             pmc03    LIKE pmc_file.pmc03,
             tlf905   LIKE tlf_file.tlf905,
             tlf906   LIKE tlf_file.tlf906,
             tlf907   LIKE tlf_file.tlf907,
             amt01    LIKE tlf_file.tlf221,
             ima57    LIKE ima_file.ima57,
             ima08    LIKE ima_file.ima08,
             ima131   LIKE ima_file.ima131,
             apa44    LIKE type_file.chr200,
             rowno    LIKE type_file.num10)
   CREATE TEMP TABLE q700_tmp_2(
                   ima12         LIKE ima_file.ima12,  
                   azf03         LIKE azf_file.azf03, 
                   tlf01         LIKE tlf_file.tlf01,
                   ima02         LIKE ima_file.ima02,   
                   ima021        LIKE ima_file.ima021,
                   tlf19         LIKE tlf_file.tlf19,  
                   wpmc03        LIKE pmc_file.pmc03, 
                   tlf031        LIKE tlf_file.tlf026, 
                   imd02         LIKE imd_file.imd02, 
                   tlf905        LIKE tlf_file.tlf905,  
                   tlf06         LIKE tlf_file.tlf06,  
                   ima131        LIKE ima_file.ima131, 
                   apa44         LIKE type_file.chr200,
                   tlf10         LIKE tlf_file.tlf10, 
                   tlf221        LIKE tlf_file.tlf221, 
                   type          LIKE apa_file.apa44)
  #FUN-D50112 ----------End-----------
END FUNCTION
#{FUNCTION q700_b_fill()
#   LET g_sql = "SELECT ima12,azf03,tlf01,ima02,ima021,ima57,ima08,tlf19,pmc03,",
#               "       tlf031,imd02,tlf905,tlf06,ima131,tlf10,amt01",   
#               " FROM q700_tmp"
#
#   PREPARE axcq700_pb FROM g_sql
#   DECLARE tlf_curs CURSOR FOR axcq700_pb
#
#   CALL g_tlf_excel.clear()
#   LET g_cnt = 1
#   LET g_rec_b = 0
#   
#   FOREACH tlf_curs INTO g_tlf_excel[g_cnt].*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      IF g_cnt <= g_max_rec THEN 
#         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
#      END IF 
#      LET g_cnt = g_cnt + 1 
#   END FOREACH
#   SELECT nvl(SUM(tlf10),0),nvl(SUM(amt01),0) INTO l_num,l_tot
#     FROM q700_tmp 
#   IF g_cnt <= g_max_rec THEN 
#      CALL g_tlf.deleteElement(g_cnt)
#   END IF 
#   CALL g_tlf_excel.deleteElement(g_cnt)
#   LET g_cnt = g_cnt -1      
#   LET g_rec_b = g_cnt
#   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
#      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
#      LET g_rec_b  = g_max_rec 
#   END IF 
#   DISPLAY g_rec_b TO FORMONLY.cnt 
#END FUNCTION 
#}  #FUN-D10105 mark
FUNCTION q700_bp2()
   LET g_flag = " "   
   LET g_action_flag = "page2 "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q700_b_fill_2() 
   
   DISPLAY tm.s TO s
   DISPLAY g_rec_b2 TO FORMONLY.cnt  
   DISPLAY l_num TO FORMONLY.num
   DISPLAY l_tot TO FORMONLY.tot

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.s FROM s ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE s
            IF NOT cl_null(tm.s)  THEN
               CALL q700_b_fill_2()
               CALL q700_set_visible()
               LET g_action_choice = "page2"
            END IF
            DISPLAY BY NAME tm.s
            EXIT DIALOG
      END INPUT
     DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY
      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q700_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   

      ON ACTION refresh_detail
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG
         
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q700_b_fill_2()
   CALL g_tlf_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   SELECT nvl(SUM(tlf10),0),nvl(SUM(amt01),0) INTO l_num,l_tot
     FROM q700_tmp
   CALL q700_get_sum()
END FUNCTION

FUNCTION q700_get_sum()
   DEFINE l_sql   STRING
   DEFINE l_sql1  STRING    #FUN-D50112 add
   CASE tm.s
      WHEN '1'
         LET l_sql = "SELECT ima12,azf03,'','','','','','','','','','','',SUM(tlf10),SUM(amt01) ", #FUN-D50112
                     "  FROM q700_tmp ",
                     " GROUP BY ima12,azf03 ",
                     " ORDER BY ima12,azf03 "
      WHEN '2'
         LET l_sql = "SELECT '','',ima01,ima02,ima021,'','','','','','','','',SUM(tlf10),SUM(amt01) ", #FUN-D50112
                     "  FROM q700_tmp ",
                     " GROUP BY ima01,ima02,ima021 ",
                     " ORDER BY ima01,ima02,ima021 "
      WHEN '3'
         LET l_sql = "SELECT '','','','','','','','','',tlf905,tlf06,'','',SUM(tlf10),SUM(amt01) ",  #FUN-D50112
                     "  FROM q700_tmp ",
                     " GROUP BY tlf905,tlf06 ",
                     " ORDER BY tlf905,tlf06"
      WHEN '4'
         LET l_sql = "SELECT '','','','','',tlf19,pmc03,'','','','','','',SUM(tlf10),SUM(amt01) ",   #FUN-D50112
                     "  FROM q700_tmp ",
                     " GROUP BY tlf19,pmc03 ",
                     " ORDER BY tlf19,pmc03"
      WHEN '5'
         LET l_sql = "SELECT '','','','','','','','','','','',ima131,'',SUM(tlf10),SUM(amt01) ",     #FUN-D50112 
                     "  FROM q700_tmp ",
                     " GROUP BY ima131 ",
                     " ORDER BY ima131 "
   #FUN-D50112 --------Begin----------
      WHEN '6'
         DELETE FROM q700_tmp_2
         LET l_sql1 = "SELECT ima12,azf03,tlf01,ima02,ima021,tlf19,pmc03,tlf031,imd02,tlf905,",
                      "        tlf06,ima131,apa44,tlf10,amt01,substr(apa44,1,instr(apa44,',')-1) type",
                      "  FROM q700_tmp ",
                      " ORDER BY apa44 "
         LET l_sql = " INSERT INTO q700_tmp_2 ",
                     " SELECT x.* ",
                     "     FROM (",l_sql1 CLIPPED,") x "

         PREPARE q700_ins_03 FROM l_sql
         EXECUTE q700_ins_03
         LET l_sql = " SELECT '','','','','','','','','','','','',apa44,SUM(tlf10),SUM(tlf221) ",
                     "   FROM q700_tmp_2 ",
                   # "  WHERE trim(type) IS NULL ",
                     "  WHERE type IS NULL",
                     " GROUP BY apa44 ",
                     " ORDER BY apa44 " 
   #FUN-D50112 --------End------------
   END CASE
   PREPARE q700_pb FROM l_sql
   DECLARE q700_curs1 CURSOR FOR q700_pb
   FOREACH q700_curs1 INTO g_tlf_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
#FUN-D50112 -------Begin---------
   IF tm.s = '6' THEN
      LET l_sql = " SELECT '','','','','','','','','','','','',apa44,SUM(tlf10),SUM(tlf221) ",
                  "   FROM q700_tmp_2 ",
                # "  WHERE trim(type) IS NULL ",
                  "  WHERE type IS NOT NULL",
                  " GROUP BY apa44 ",
                  " ORDER BY apa44 "
   PREPARE q700_pb1 FROM l_sql
   DECLARE q700_curs2 CURSOR FOR q700_pb1
   FOREACH q700_curs2 INTO g_tlf_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   END IF
#FUN-D50112 -------End-----------
   DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT= g_cnt)   
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
   CALL g_tlf_1.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cnt
END FUNCTION

FUNCTION q700_set_visible()
   CALL cl_set_comp_visible("tlf905_1,tlf06_1,tlf19_1,wpmc03_1,tlf01_1,ima02_1,ima021_1,ima12_1,
                             azf03_1,ima131_1,tlf031_1,imd02_1,apa44_1",TRUE)   #FUN-D50112  add apa44_1
   CASE tm.s
      WHEN '1'
         CALL cl_set_comp_visible("tlf905_1,tlf06_1,tlf19_1,wpmc03_1,tlf01_1,ima02_1,ima021_1,
                                   ima131_1,tlf031_1,imd02_1,apa44_1",FALSE)    #FUN-D50112  add apa44_1
      WHEN '2'
         CALL cl_set_comp_visible("tlf905_1,tlf06_1,tlf19_1,wpmc03_1,ima12_1,azf03_1,
                                   ima131_1,tlf031_1,imd02_1,apa44_1",FALSE)    #FUN-D50112  add apa44_1                   
      WHEN '3'
         CALL cl_set_comp_visible("tlf06_1,tlf19_1,wpmc03_1,tlf01_1,ima02_1,ima021_1,ima12_1,
                                   azf03_1,ima131_1,tlf031_1,imd02_1,apa44_1",FALSE)  #FUN-D50112  add apa44_1
      WHEN '4'
         CALL cl_set_comp_visible("tlf905_1,tlf06_1,tlf01_1,ima02_1,ima021_1,ima12_1,
                                   azf03_1,ima131_1,tlf031_1,imd02_1,apa44_1",FALSE)  #FUN-D50112  add apa44_1
      WHEN '5'
         CALL cl_set_comp_visible("tlf905_1,tlf06_1,tlf19_1,wpmc03_1,tlf01_1,ima02_1,ima021_1,
                                   ima12_1,azf03_1,tlf031_1,imd02_1,apa44_1",FALSE)   #FUN-D50112  add apa44_1
   #FUN-D50112 -----Begin------
      WHEN '6'
         CALL cl_set_comp_visible("tlf905_1,tlf06_1,tlf19_1,wpmc03_1,tlf01_1,ima02_1,ima021_1,
                                   ima12_1,azf03_1,tlf031_1,imd02_1,ima131_1",FALSE) 
   #FUN-D50112 -----End--------
   END CASE
END FUNCTION

FUNCTION q700_show()
   DISPLAY tm.bdate,tm.edate,tm.type,tm.a,tm.costdown,tm.g,tm.type_1,tm.s,tm.type1 
        TO bdate,edate,type,a,costdown,g,type_1,s,type1
   IF cl_null(tm.s) THEN LET tm.s = '2' END IF
   IF cl_null(g_action_flag) OR g_action_flag="page2" THEN
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
       CALL q700_b_fill_2() 
   ELSE
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
       CALL q700_b_fill()  
   END IF   
   CALL q700_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION 

FUNCTION q700_filter_askkey()
   DEFINE l_wc  STRING
   CLEAR FORM 
   CONSTRUCT  l_wc ON ima12,tlf01,ima57,ima08,tlf19,
                          tlf031,tlf06,ima131,tlf10,tlf221,apa44     #FUN-D50112 add 
          FROM s_tlf[1].ima12,s_tlf[1].tlf01,s_tlf[1].ima57,s_tlf[1].ima08,s_tlf[1].tlf19,
               s_tlf[1].tlf031,s_tlf[1].tlf06,s_tlf[1].ima131,s_tlf[1].tlf10,s_tlf[1].tlf221,s_tlf[1].apa44  #FUN-D50112 add  apa44
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION locale
         CALL cl_show_fld_cont()                                     
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
        CONTINUE CONSTRUCT   
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tlf01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tlf"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf01
               NEXT FIELD tlf01
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1  = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            #FUN-D10022---xj---str---
            WHEN INFIELD(tlf031)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf031
               NEXT FIELD tlf031
            WHEN INFIELD(ima131)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131         
            #FUN-D10022---xj---end---
         #TQC-D30024--cj--add--
           WHEN INFIELD(tlf19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf19
              NEXT FIELD tlf19
         #TQC-D30024--cj--add--
 
    #FUN-D50112 --------Begin--------
           WHEN INFIELD(apa44)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa44"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa44 
              NEXT FIELD apa44 
    #FUN-D50112 --------End----------

         END CASE
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION controlg                    
         CALL cl_cmdask()                  
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT 
      ON ACTION qbe_select
         CALL cl_qbe_select()
   END CONSTRUCT 
   IF INT_FLAG THEN
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF
   LET l_wc = cl_replace_str(l_wc,'tlf031',"(CASE WHEN tlf13 = 'apmt1072' OR tlf13 = 'asft6101' THEN tlf021 ELSE tlf031 END)") #FUN-D10022
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED

END FUNCTION

FUNCTION q700_detail_fill(p_ac)
   DEFINE p_ac     LIKE type_file.num5
   DEFINE l_sql    STRING
   DEFINE l_sql1   STRING
   DEFINE l_tmp    STRING

   LET l_sql = "SELECT ima12,azf03,ima01,ima02,ima021,ima57,ima08,tlf19,pmc03,",
               "       tlf031,imd02,tlf905,tlf06,ima131,tlf10,amt01",
               " FROM q700_tmp"
   LET l_sql1 = "SELECT nvl(SUM(tlf10),0),nvl(SUM(amt01),0) ",
                "  FROM q700_tmp"

  CASE tm.s
     WHEN '1'
        IF cl_null(g_tlf_1[p_ac].ima12_1) THEN 
           LET g_tlf_1[p_ac].ima12_1 = ''
           LET l_tmp = " OR ima12 IS NULL"
        ELSE
           LET l_tmp = ''
        END IF
        LET l_sql = l_sql," WHERE (ima12 = '",g_tlf_1[p_ac].ima12_1 CLIPPED,"'",l_tmp," )",
                          " ORDER BY ima12 ,azf03"
        LET l_sql1 = l_sql1," WHERE (ima12 = '",g_tlf_1[p_ac].ima12_1 CLIPPED,"'",l_tmp," )"
     WHEN '2'
        IF cl_null(g_tlf_1[p_ac].tlf01_1) THEN
           LET g_tlf_1[p_ac].tlf01_1 =''
           LET l_tmp = "OR ima01 IS NULL"
        ELSE
           LET l_tmp = ''
        END IF
        LET l_sql = l_sql,"  WHERE (ima01 = '",g_tlf_1[p_ac].tlf01_1 CLIPPED,"'",l_tmp," )",
                          "  ORDER BY ima01,ima02,ima021"
        LET l_sql1 = l_sql1,"  WHERE (ima01 = '",g_tlf_1[p_ac].tlf01_1 CLIPPED,"'",l_tmp," )"
    WHEN '3'
       IF cl_null(g_tlf_1[p_ac].tlf905_1) THEN
          LET g_tlf_1[p_ac].tlf905_1 = ''
          LET l_tmp = "OR tlf905 IS NULL"
       ELSE
          LET l_tmp = ''
       END IF
       LET l_sql = l_sql,"  WHERE (tlf905 = '",g_tlf_1[p_ac].tlf905_1 CLIPPED ,"'",l_tmp,")",
                         "  ORDER BY tlf905,tlf06"
      LET l_sql1 = l_sql1,"  WHERE (tlf905 = '",g_tlf_1[p_ac].tlf905_1 CLIPPED ,"'",l_tmp,")" 
       WHEN '4'
       IF cl_null(g_tlf_1[p_ac].tlf19_1) THEN
          LET g_tlf_1[p_ac].tlf19_1 = ''
          LET l_tmp = "OR tlf19 IS NULL"
       ELSE
          LET l_tmp = ''
       END IF
       LET l_sql = l_sql,"  WHERE (tlf19 = '",g_tlf_1[p_ac].tlf19_1 CLIPPED ,"'",l_tmp,")",
                         "  ORDER BY tlf19,pmc03"
      LET l_sql1 = l_sql1,"  WHERE (tlf19 = '",g_tlf_1[p_ac].tlf19_1 CLIPPED ,"'",l_tmp,")"
    WHEN '5'
       IF cl_null(g_tlf_1[p_ac].ima131_1) THEN
          LET g_tlf_1[p_ac].ima131_1 = ''
          LET l_tmp = "OR ima131 IS NULL"
       ELSE
          LET l_tmp = ''
       END IF
       LET l_sql = l_sql,"  WHERE (ima131 = '",g_tlf_1[p_ac].ima131_1 CLIPPED ,"'",l_tmp,")",
                         "  ORDER BY ima131"
      LET l_sql1 = l_sql1,"  WHERE (ima131 = '",g_tlf_1[p_ac].ima131_1 CLIPPED ,"'",l_tmp,")"
   END CASE
   PREPARE axcq700_pb_detail FROM l_sql
   DECLARE tlf_curs_detail  CURSOR FOR axcq700_pb_detail        #CURSOR

   PREPARE axcq700_pb_det_sr1 FROM l_sql1                                                                                    
 
   DECLARE axcq700_cs_sr1 CURSOR FOR axcq700_pb_det_sr1                                                                      
 
   OPEN axcq700_cs_sr1
   FETCH axcq700_cs_sr1 INTO l_num,l_tot

   CALL g_tlf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH tlf_curs_detail INTO g_tlf_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_tlf.deleteElement(g_cnt)
   END IF
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
