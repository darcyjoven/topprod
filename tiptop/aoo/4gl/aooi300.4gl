# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi300.4gl
# Descriptions...: 
# Date & Author..: 91/06/21 By Lee
# Modify 		 : 94/12/05 by Nick (Convert to Multiline Task)
#                  azf02 類別可為1/2/3/5/6/8/A/B/C/D/E/F/G
# Modify           azf02 類別可為2/3/5/6/8/A/B/C/D/E/F/G  1拿掉
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510041 05/01/20 By Carol 新增成本拋轉傳票功能 -- add azf05 for g_argv1 = 'G'
# Modify.........: No.FUN-530488 05/03/26 By CoCo 依不同的程式代號來產生不同的報表檔名
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main進入點跟退出點呼叫兩次
# Modify.........: No.TQC-5B0033 05/11/08 By Claire 修改表尾列印結束及接下頁位置
# Modify.........: No.FUN-5B0111 05/11/22 By kim 當不列印會科時,會科欄位要隱藏
# Modify.........: No.FUN-650001 06/05/24 By Sarah 當執行aooi312時(g_argv1='G'),畫面增加顯示、維護azf06(成本性質)
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680086 06/08/23 By Elva 兩套帳內容修改，新增azf051,aag021
# Modify.........: No.FUN-660073 06/09/04 By Nicola 訂單樣品，新增azf07,aag022,azf14,aag023
# Modify.........: No.FUN-680102 06/09/18 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0004 06/10/03 By Sarah 列印時報表名稱錯誤
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0023 06/11/20 By baogui 報表問題修改
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313
# Modify.........: No.TQC-6C0130 06/12/21 By Nicola 無法查詢
# Modify.........: No.TQC-6C0085 06/12/26 By chenl  開放azf01,azf03兩個欄位。
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740039 07/04/11 By Nicola azf08 預設為N
# Modify.........: No.FUN-850016 08/05/05 By mike 報表輸出方式轉為Crystal Reports 
# Modify.........: No.FUN-930106 09/03/16 By destiny 理由碼字段增加選項
# Modify.........: No.MOD-930299 09/03/30 By Dido 修改重複列印問題
# Modify.........: No.FUN-950077 09/05/22 By Ddongbg 理由碼費用原因和預算項目統一成一個類別
# Modify.........: No.FUN-870100 09/08/28 By cockroach 理由碼增加9:差異調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach aooi313 ADD POS?
# Modify.........: No.FUN-A70064 10/07/13 By shaoyong 用途欄加入'G.卡異動原因' 及 'H.商戶合約異動原因'
# Modify.........: No:MOD-A80122 10/08/16 By lilingyu 用途azf09為"返現"時,開放azf10輸入
# Modify.........: No:FUN-AA0025 10/11/11 By elva 成本改善
# Modify.........: No:TQC-AC0150 10/12/14 By Carrier aooi313时,'7.费用原因/预算项目'时开放'搭赠'字段的key in
# Modify.........: No:FUN-B10052 11/01/25 By lilingyu 科目查詢自動過濾
# Modify.........: No:TQC-B30004 11/03/10 By suncx 取消已傳POS否相關邏輯
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.MOD-B50073 11/05/10 By wujie azf09=7时，azf07按aglt600的逻辑控管 
# Modify.........: No.TQC-B50094 11/05/18 By wujie 将MOD-B50073中的修改由azf07改为azf14
# Modify.........: No.FUN-B80058 11/08/05 By lixia 兩套帳內容修改，新增azf071,aag0221,azf141,aag0231 
# Modify.........: No.FUN-B80051 11/09/30 By nanbing azf09欄加入'I.會員資料異動原因' 
# Modify.........: No.FUN-BA0109 11/11/20 By yinhy 增加主營業務收入科目，科目名稱欄位
# Modify.........: No.FUN-C90078 12/09/17 By minpp 增加azf21，azf211
# Modify.........: No.MOD-D10227 13/01/24 By bart 單身刪除段未串上代碼類別，會將其他類別同碼別代號刪除
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40121 13/06/24 By zhangweib 增加azf01的傳參
# Modify.........: No:MOD-D80090 13/08/14 By fengmy azf20清空后對應清空aag024
# Modify.........: No:FUN-D90021 13/09/05 By yuhuabao 修改aooi313,里面如果azf09=7,則azf14可以錄入科目，不必檢查此科目是否用做預算控制（aag21)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_argv1         LIKE azf_file.azf02,
    g_azf02         LIKE azf_file.azf02,
    g_azf02_t       LIKE azf_file.azf02,
    g_argv2         LIKE azf_file.azf01,   #No.FUN-D40121   Add
    g_azf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        azf01       LIKE azf_file.azf01,   #部門編號
        azf03       LIKE azf_file.azf03,   #全名
        azf05       LIKE azf_file.azf05,   #存貨差異科目   #FUN-510041 add
        aag02       LIKE aag_file.aag02,   #科目名稱   #FUN-510041 add
        azf051      LIKE azf_file.azf051,  #存貨差異科目二   #FUN-680086 add
        aag021      LIKE aag_file.aag02,   #科目二名稱   #FUN-680086 add
        azf07       LIKE azf_file.azf07,   #No.FUN-660073
        aag022      LIKE aag_file.aag02,   #No.FUN-660073
        azf071      LIKE azf_file.azf071,  #會計科目二  #FUN-B80058 add
        aag0221     LIKE aag_file.aag02,   #科目二名稱  #FUN-B80058 add
        azf14       LIKE azf_file.azf14,   #No.FUN-660073
        aag023      LIKE aag_file.aag02,   #No.FUN-660073
        azf141      LIKE azf_file.azf141,  #會計科目二  #FUN-B80058 add
        aag0231     LIKE aag_file.aag02,   #科目二名稱  #FUN-B80058 add
        azf20       LIKE azf_file.azf20,   #No.FUN-BA0109
        aag024      LIKE aag_file.aag02,   #No.FUN-BA0109
        azf201			LIKE azf_file.azf201,  #No.FUN-BA0109   
        aag025      LIKE aag_file.aag02,   #No.FUN-BA0109
        azf21       LIKE azf_file.azf21,   #FUN-C90078
        aag026      LIKE aag_file.aag02,   #FUN-C90078
        azf211      LIKE azf_file.azf211,  #FUN-C90078
        aag027      LIKE aag_file.aag02,   #FUN-C90078
        azf08       LIKE azf_file.azf08,   #No.FUN-660073
        azf06       LIKE azf_file.azf06,   #成本性質   #FUN-650001 add
        azf09       LIKE azf_file.azf09,   #No.FUN-6B0065
        azf10       LIKE azf_file.azf10,   #No.FUN-6B0065
        azf11       LIKE azf_file.azf11,   #No.FUN-6B0065
        azf12       LIKE azf_file.azf12,   #No.FUN-6B0065
        azf13       LIKE azf_file.azf13,   #No.FUN-6B0065
        azfacti     LIKE azf_file.azfacti,  #No.FUN-680102 VARCHAR(1)
        ta_azf01    LIKE azf_file.ta_azf01  #add by huanglf170315 
        #azfpos      LIKE azf_file.azfpos   #FUN-A30030 ADD pos?   #TQC-B30004 mark
                    END RECORD,
    g_azf_t         RECORD                 #程式變數 (舊值)
        azf01       LIKE azf_file.azf01,   #部門編號
        azf03       LIKE azf_file.azf03,   #全名
        azf05       LIKE azf_file.azf05,   #存貨差異科目   #FUN-510041 add
        aag02       LIKE aag_file.aag02,   #科目名稱   #FUN-510041 add
        azf051      LIKE azf_file.azf051,  #存貨差異科目二   #FUN-680086 add
        aag021      LIKE aag_file.aag02,   #科目二名稱   #FUN-680086 add
        azf07       LIKE azf_file.azf07,   #No.FUN-660073
        aag022      LIKE aag_file.aag02,   #No.FUN-660073
        azf071      LIKE azf_file.azf071,  #會計科目二  #FUN-B80058 add
        aag0221     LIKE aag_file.aag02,   #科目二名稱  #FUN-B80058 add
        azf14       LIKE azf_file.azf14,   #No.FUN-660073
        aag023      LIKE aag_file.aag02,   #No.FUN-660073
        azf141      LIKE azf_file.azf141,  #會計科目二  #FUN-B80058 add
        aag0231     LIKE aag_file.aag02,   #科目二名稱  #FUN-B80058 add
        azf20       LIKE azf_file.azf20,   #No.FUN-BA0109
        aag024      LIKE aag_file.aag02,   #No.FUN-BA0109
        azf201			LIKE azf_file.azf201,  #No.FUN-BA0109   
        aag025      LIKE aag_file.aag02,   #No.FUN-BA0109
        azf21       LIKE azf_file.azf21,   #FUN-C90078
        aag026      LIKE aag_file.aag02,   #FUN-C90078
        azf211      LIKE azf_file.azf211,  #FUN-C90078
        aag027      LIKE aag_file.aag02,   #FUN-C90078
        azf08       LIKE azf_file.azf08,   #No.FUN-660073
        azf06       LIKE azf_file.azf06,   #成本性質   #FUN-650001 add
        azf09       LIKE azf_file.azf09,   #No.FUN-6B0065
        azf10       LIKE azf_file.azf10,   #No.FUN-6B0065
        azf11       LIKE azf_file.azf11,   #No.FUN-6B0065
        azf12       LIKE azf_file.azf12,   #No.FUN-6B0065
        azf13       LIKE azf_file.azf13,   #No.FUN-6B0065
        azfacti     LIKE azf_file.azfacti,   #No.FUN-680102 VARCHAR(1)
        ta_azf01    LIKE azf_file.ta_azf01  #add by huanglf170315 
        #azfpos      LIKE azf_file.azfpos   #FUN-A30030 ADD pos?  #TQC-B30004 mark
                    END RECORD,
     g_wc2,g_sql     string,  #No.FUN-580092 HCN
    g_tit           LIKE type_file.chr20,      #No.FUN-680102 VARCHAR(10),
    g_tit1          LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(16),
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                   #No.FUN-850016                                                                    
DEFINE   g_str           STRING                   #No.FUN-850016                                                                    
DEFINE   g_prog1         STRING                   #No.FUN-850016    


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1) 
   LET g_azf02   = g_argv1
   LET g_azf02_t = g_azf02
   LET g_argv2   = ARG_VAL(2)   #No.FUN-D40121   Add
 
   CASE 
       WHEN g_argv1='2'
            LET g_prog='aooi301'
       WHEN g_argv1='3'
            LET g_prog='aooi302'
       WHEN g_argv1='5'
            LET g_prog='aooi303'
       WHEN g_argv1='6'
            LET g_prog='aooi304'
       WHEN g_argv1='8'
            LET g_prog='aooi305'
       WHEN g_argv1='A'
            LET g_prog='aooi306'
      #start FUN-6A0004 mark
      #WHEN g_argv1='B'
      #     LET g_prog='aooi307'
      #WHEN g_argv1='C'
      #     LET g_prog='aooi308'
      #end FUN-6A0004 mark
       WHEN g_argv1='D'
            LET g_prog='aooi309'
       WHEN g_argv1='E'
            LET g_prog='aooi310'
       WHEN g_argv1='F'
            LET g_prog='aooi311'
       WHEN g_argv1='G'
            LET g_prog='aooi312'
       #-----No.FUN-660073-----
       WHEN g_argv1='H'
            LET g_prog='aooi313'
            LET g_azf02 = "2"
       #-----No.FUN-660073 END-----
       OTHERWISE
            EXIT PROGRAM
   END CASE 
 
   LET g_tit = g_prog
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = "azf05.azf_file.azf05,",                                                                                             
               "azf07.azf_file.azf07,",   
               "azf071.azf_file.azf071,",       #No.FUN-BA0109                                                                                           
               "azf14.azf_file.azf14,", 
               "azf141.azf_file.azf141,",       #No.FUN-BA0109                                                                                                 
               "azf01.azf_file.azf01,",                                                                                             
               "azf02.azf_file.azf02,",                                                                                             
               "azf03.azf_file.azf03,",                                                                                             
               "azf09.azf_file.azf09,",                                                                                             
               "azf10.azf_file.azf10,",                                                                                             
               "azf11.azf_file.azf11,",                                                                                             
               "azf12.azf_file.azf12,",                                                                                             
               "azf13.azf_file.azf13,", 
               "azf20.azf_file.azf20,",     #No.FUN-BA0109
               "azf201.azf_file.azf201,",   #No.FUN-BA0109               
               "azf21.azf_file.azf21,",     #FUN-C90078
               "azf211.azf_file.azf211,",   #FUN-C90078                                                                                    
               "azfacti.azf_file.azfacti,",                                                                                         
               "azf06.azf_file.azf06,",                                                                                             
               "azf08.azf_file.azf08,",                                                                                             
               "l_aag02.aag_file.aag02,",                                                                                           
               "l_aag022.aag_file.aag02,",                                                                                          
               "l_aag023.aag_file.aag02,",  
               "l_aag024.aag_file.aag02,",   #No.FUN-BA0109
               "l_aag025.aag_file.aag02,",   #No.FUN-BA0109    
               "l_aag0221.aag_file.aag02,",   #No.FUN-BA0109    
               "l_aag0231.aag_file.aag02,",   #No.FUN-BA0109                                                                                                 
               "l_gae04.gae_file.gae04"                                                                                             
   LET l_table = cl_prt_temptable("aooi300",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"        #FUN-BA0109 add 8 ?                                                                    
   PREPARE insert_prep FROM g_sql                       
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i300_w WITH FORM "aoo/42f/aooi300"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("aooi300")
   CALL cl_ui_init()
 
   # 非成本用要將azf05,aag02隱藏
   IF g_argv1 !='G' THEN
      CALL cl_set_comp_visible("azf05,aag02,azf051,aag021",FALSE) #FUN-680086
   END IF

#str----add by huanglf170315
   IF g_argv1 !='D' THEN
      CALL cl_set_comp_visible("ta_azf01",FALSE) 
   ELSE 
      CALL cl_set_comp_visible("ta_azf01",TRUE) 
   END IF
#str----end by huanglf170315
 
   IF g_argv1 !='H' THEN
      CALL cl_set_comp_visible("azf07,aag022,azf14,aag023,azf08,azf20,azf201,azf21,azf211,aag024,aag025,aag026,aag027",FALSE)  #FUN-BA0109 add azf20,201,aag024,025 #FUN-C90078 Add azf21,211,aag026,027
      CALL cl_set_comp_visible("azf071,aag0221,azf141,aag0231",FALSE)  #FUN-B80058 add
   END IF
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("azf051,aag021,azf201,aag025,azf211,aag027",FALSE) #FUN-680086 #FUN-BA0109##FUN-C90078 add-azf211,aag027
   END IF

   CALL cl_set_comp_visible("azf06",g_argv1='G')   #FUN-650001 add
 
   IF g_argv1 = 'G' THEN
      CALL cl_set_comp_visible("azf07,aag022,azf14,aag023",TRUE)   #FUN-AA0025 
      CALL cl_set_comp_visible("azf071,aag0221,azf141,aag0231",TRUE)  #FUN-B80058 add
   END IF

   #FUN-B80058--add--str--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("azf071,aag0221,azf141,aag0231",FALSE)
   END IF
   #FUN-B80058--add--end--

   IF g_aza.aza50 = 'Y' THEN
      IF g_argv1 ='H' THEN
         CALL cl_set_comp_visible("azf09,azf10,azf11,azf12,azf13",TRUE)    
      ELSE
         CALL cl_set_comp_visible("azf09,azf10,azf11,azf12,azf13",FALSE) 
      END IF
   ELSE
      CALL cl_set_comp_visible("azf09,azf10,azf11,azf12,azf13",FALSE) 
   END IF

   IF g_argv1='2' OR g_argv1='H' THEN 
      CALL cl_set_comp_visible("azf09",TRUE)
   END IF 
 
  ##TQC-B30004 mark begin--------------------------
  ##FUN-A30030 ADD-------------------------
  # IF g_aza.aza88='Y' THEN
  #    CALL cl_set_comp_visible('azfpos',TRUE)
  # ELSE
  #    CALL cl_set_comp_visible('azfpos',FALSE)
  # END IF
  ##FUN-A30030 END------------------------
  ##TQC-B30004 mark end----------------------------

   DISPLAY g_azf02 TO azf02
   LET g_wc2 = " azf02 ='",g_azf02 CLIPPED,"' " 

   #No.FUN-D40121 ---Add--- Start
    IF NOT cl_null(g_argv2) THEN
       LET g_wc2 =g_wc2 CLIPPED, "  AND azf01 ='",g_argv2 CLIPPED,"' "
    END IF  
   #No.FUN-D40121 ---Add--- End
 
   CALL i300_b_fill(g_wc2)
 
   CALL i300_menu()
 
   CLOSE WINDOW i300_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i300_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_azf02 IS NOT NULL THEN
                  LET g_doc.column1 = "azf02"
                  LET g_doc.value1 = g_azf02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azf),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i300_q()
 
   CALL i300_b_askkey()
 
END FUNCTION
 
FUNCTION i300_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                      #FUN-510041 add azf05
   LET g_forupd_sql = " SELECT azf01,azf03,azf05,'',azf051,'',azf07,'',azf071,'',",   #No.FUN-660073 #FUN-B80058 addazf071
                      "        azf14,'',azf141,'',azf20,'',azf201,'',azf21,'',azf211,'',azf08,azf06,azf09,azf10,azf11,",   #No.FUN-660073 #FUN-BA0109 #FUN-B80058 addazf141 #FUN-C90078 add azf21,211,'',''
                      #"        azf12,azf13,azfacti,azfpos FROM azf_file ", #FUN-A30030 ADD POS   #FUN-650001 add azf06 #FUN-680086  #No.FUN-6B0065 #TQC-B30004 mark
                      "        azf12,azf13,azfacti,ta_azf01 FROM azf_file ",  #TQC-B30004  #add by huanglf170315
                      "  WHERE azf02= ? AND azf01= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_azf WITHOUT DEFAULTS FROM s_azf.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_azf_t.* = g_azf[l_ac].*  #BACKUP
            OPEN i300_bcl USING g_azf02,g_azf_t.azf01
            IF STATUS THEN
               CALL cl_err("OPEN i300_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl INTO g_azf[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_azf_t.azf01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_azf[l_ac].aag02 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf05)  #No.FUN-730020
                  LET g_azf[l_ac].aag021= i300_aag02(g_aza.aza82,g_azf[l_ac].azf051)  #FUN-680086 add #No.FUN-730020
                  LET g_azf[l_ac].aag022= i300_aag02(g_aza.aza81,g_azf[l_ac].azf07)   #No.FUN-660073 #No.FUN-730020
                  LET g_azf[l_ac].aag023= i300_aag02(g_aza.aza81,g_azf[l_ac].azf14)   #No.FUN-660073 #No.FUN-730020
                  LET g_azf[l_ac].aag024= i300_aag02(g_aza.aza81,g_azf[l_ac].azf20)     #No.FUN-BA0109
                  LET g_azf[l_ac].aag026= i300_aag02(g_aza.aza81,g_azf[l_ac].azf21)    #FUN-C90078
                  LET g_azf[l_ac].aag025= i300_aag02(g_aza.aza82,g_azf[l_ac].azf201)    #No.FUN-BA0109
                  LET g_azf[l_ac].aag0221= i300_aag02(g_aza.aza82,g_azf[l_ac].azf071)   #No.FUN-BA0109
                  LET g_azf[l_ac].aag0231= i300_aag02(g_aza.aza82,g_azf[l_ac].azf141)   #No.FUN-BA0109
                  LET g_azf[l_ac].aag027= i300_aag02(g_aza.aza82,g_azf[l_ac].azf211)    #FUN-C90078
                  DISPLAY BY NAME g_azf[l_ac].aag02,g_azf[l_ac].aag021,
                                  g_azf[l_ac].aag022,g_azf[l_ac].aag023,     #No.FUN-660073
                                  g_azf[l_ac].aag024,g_azf[l_ac].aag025,     #No.FUN-BA0109
                                  g_azf[l_ac].aag0221,g_azf[l_ac].aag0231    #No.FUN-BA0109
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_azf[l_ac].* TO NULL      #900423
         LET g_azf[l_ac].azfacti = 'Y'       #Body default
         #No.FUN-6B0065 --begin
         LET g_azf[l_ac].azf09  = '1'
         LET g_azf[l_ac].azf10  = 'N'
         LET g_azf[l_ac].azf11  = 'N'
         LET g_azf[l_ac].azf12  = 'N'
         LET g_azf[l_ac].azf13  = 'N'
         #No.FUN-6B0065 --end
         #LET g_azf[l_ac].azfpos= 'N'   #FUN-A30030 ADD  #TQC-B30004 mark
         LET g_azf[l_ac].azf08  = 'N'   #No.FUN-740039
         LET g_azf_t.* = g_azf[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD azf01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO azf_file(azf01,azf02,azf03,azf05,azf051,azf06,
                              azf07,azf071,azf14,azf141,azf08,azf09,azf10,azf11, #No.FUN-660073 #FUN-B80058 add 071 141
                              #azf12,azf13,azfacti,azfpos,azfuser,azfdate,azforiu,azforig) #FUN-A30030 ADD POS  #FUN-650001 add azf06 #FUN-680086    #No.FUN-6B0065 #TQC-B30004 mark
                              azf12,azf13,azf20,azf201,azf21,azf211,azfacti,ta_azf01,azfuser,azfdate,azforiu,azforig)  #add by huanglf170315#TQC-B30004  #FUN-BA0109 add azf20,201 #FUN-C90078 add-azf21,azf211
                       VALUES(g_azf[l_ac].azf01,g_azf02,g_azf[l_ac].azf03,
                              g_azf[l_ac].azf05,   #FUN-510041 add azf05
                              g_azf[l_ac].azf051,  #FUN-680086 add azf051
                              g_azf[l_ac].azf06,   #FUN-650001 add azf06
                              g_azf[l_ac].azf07,   #No.FUN-660073
                              g_azf[l_ac].azf071,  #No.FUN-B80058
                              g_azf[l_ac].azf14,   #No.FUN-660073
                              g_azf[l_ac].azf141,  #No.FUN-B80058 
                              g_azf[l_ac].azf08,   #No.FUN-660073
                              g_azf[l_ac].azf09,   #No.FUN-6B0065
                              g_azf[l_ac].azf10,   #No.FUN-6B0065
                              g_azf[l_ac].azf11,   #No.FUN-6B0065
                              g_azf[l_ac].azf12,   #No.FUN-6B0065
                              g_azf[l_ac].azf13,   #No.FUN-6B0065
                              g_azf[l_ac].azf20,   #No.FUN-BA0109
                              g_azf[l_ac].azf201,  #No.FUN-BA0109
                              g_azf[l_ac].azf21,   #No.FUN-C90078
                              g_azf[l_ac].azf211,  #No.FUN-C90078
                              #g_azf[l_ac].azfacti,g_azf[l_ac].azfpos,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig #TQC-B30004 mark
                              g_azf[l_ac].azfacti,g_azf[l_ac].ta_azf01,g_user,g_today, g_user, g_grup) #add by huanglf170315 #TQC-B30004
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_azf[l_ac].azf01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","azf_file",g_azf[l_ac].azf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD azf01                        #check 編號是否重複
         IF NOT cl_null(g_azf[l_ac].azf01) THEN
            IF g_azf[l_ac].azf01 != g_azf_t.azf01 
               OR g_azf_t.azf01 IS NULL THEN
               SELECT count(*) INTO l_n FROM azf_file
                WHERE azf01 = g_azf[l_ac].azf01
                  AND azf02 = g_azf02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_azf[l_ac].azf01 = g_azf_t.azf01
                  NEXT FIELD azf01
               END IF
            END IF
         END IF

      AFTER FIELD azf05
         IF NOT cl_null(g_azf[l_ac].azf05) THEN 
            LET g_azf[l_ac].aag02 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf05)   #No.FUN-730020
            DISPLAY BY NAME g_azf[l_ac].aag02
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_azf[l_ac].azf05,g_errno,0)
#FUN-B10052 --begin--               
#              LET g_azf[l_ac].azf05=g_azf_t.azf05
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_azf[l_ac].azf05
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf05 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81  
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf05 
                DISPLAY BY NAME g_azf[l_ac].azf05
                LET g_azf[l_ac].aag02 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf05)   
                DISPLAY BY NAME g_azf[l_ac].aag02               
#FUN-B10052 -end--               
               NEXT FIELD azf05
            END IF
         ELSE
            LET g_azf[l_ac].aag02 = ''
            DISPLAY BY NAME g_azf[l_ac].aag02
         END IF
 
      #FUN-680086  --begin
      AFTER FIELD azf051
         IF NOT cl_null(g_azf[l_ac].azf051) THEN 
            LET g_azf[l_ac].aag021= i300_aag02(g_aza.aza82,g_azf[l_ac].azf051)   #No.FUN-730020
            DISPLAY BY NAME g_azf[l_ac].aag021
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_azf[l_ac].azf051,g_errno,0)
#FUN-B10052 --begin--        
#              LET g_azf[l_ac].azf051=g_azf_t.azf051 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_azf[l_ac].azf051
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf051 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza82  
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf051 
                DISPLAY BY NAME g_azf[l_ac].azf051
                LET g_azf[l_ac].aag021= i300_aag02(g_aza.aza82,g_azf[l_ac].azf051)  
                DISPLAY BY NAME g_azf[l_ac].aag021
#FUN-B10052 --end--
               NEXT FIELD azf051
            END IF
         ELSE
            LET g_azf[l_ac].aag021= ''
            DISPLAY BY NAME g_azf[l_ac].aag021
         END IF
      #FUN-680086  --end
 
      #-----No.FUN-660073-----
      AFTER FIELD azf07
         IF NOT cl_null(g_azf[l_ac].azf07) THEN 
            LET g_azf[l_ac].aag022 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf07)  #No.FUN-730020
            DISPLAY BY NAME g_azf[l_ac].aag022
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_azf[l_ac].azf07,g_errno,0)
#FUN-B10052 --begin--
#               LET g_azf[l_ac].azf07=g_azf_t.azf07
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf07
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf07 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81 
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf07 
                DISPLAY BY NAME g_azf[l_ac].azf07
                LET g_azf[l_ac].aag022 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf07)  
                DISPLAY BY NAME g_azf[l_ac].aag022
#FUN-B10052 --end--
               NEXT FIELD azf07
            END IF
#No.TQC-B50094 --begin
#No.MOD-B50073 --begin
#            IF g_azf[l_ac].azf07 != g_azf_t.azf07 OR g_azf_t.azf07 IS NULL THEN
#               CALL i300_azf07(g_azf[l_ac].azf09,g_aza.aza81,g_azf[l_ac].azf07)
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(' ',g_errno,0)
#                  LET g_azf[l_ac].azf07 = g_azf_t.azf07
#                  DISPLAY BY NAME g_azf[l_ac].azf07
#                  NEXT FIELD azf07
#               END IF
#            END IF
#No.MOD-B50073 --end
#No.TQC-B50094 --end
         ELSE
            LET g_azf[l_ac].aag022 = ''
            DISPLAY BY NAME g_azf[l_ac].aag022
         END IF

      #FUN-B80058--add--str--
      AFTER FIELD azf071
         IF NOT cl_null(g_azf[l_ac].azf071) THEN 
            LET g_azf[l_ac].aag0221 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf071)  
            DISPLAY BY NAME g_azf[l_ac].aag0221
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_azf[l_ac].azf071,g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf071
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf071 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81 
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf071 
                DISPLAY BY NAME g_azf[l_ac].azf071
                LET g_azf[l_ac].aag0221 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf071)  
                DISPLAY BY NAME g_azf[l_ac].aag0221
               NEXT FIELD azf071
            END IF
         ELSE
            LET g_azf[l_ac].aag0221 = ''
            DISPLAY BY NAME g_azf[l_ac].aag0221
         END IF 
      #FUN-B80058--add--end--  
 
      AFTER FIELD azf14
         IF NOT cl_null(g_azf[l_ac].azf14) THEN 
            LET g_azf[l_ac].aag023 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf14) 
            DISPLAY BY NAME g_azf[l_ac].aag023
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_azf[l_ac].azf14,g_errno,0)
#FUN-B10052 --begin--
#               LET g_azf[l_ac].azf14=g_azf_t.azf14
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_azf[l_ac].azf14
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf14 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81  
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf14 
                DISPLAY BY NAME g_azf[l_ac].azf14
                LET g_azf[l_ac].aag023 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf14) 
                DISPLAY BY NAME g_azf[l_ac].aag023
#FUN-B10052 --end-- 
               NEXT FIELD azf14
            END IF
#No.TQC-B50094 --begin
            IF g_azf[l_ac].azf14 != g_azf_t.azf14 OR g_azf_t.azf14 IS NULL THEN
               CALL i300_azf14(g_azf[l_ac].azf09,g_aza.aza81,g_azf[l_ac].azf14)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(' ',g_errno,0)
                  LET g_azf[l_ac].azf14 = g_azf_t.azf14
                  DISPLAY BY NAME g_azf[l_ac].azf14
                  NEXT FIELD azf14
               END IF
            END IF
#No.TQC-B50094 --end
         ELSE
            LET g_azf[l_ac].aag023 = ''
            DISPLAY BY NAME g_azf[l_ac].aag023
         END IF
      #-----No.FUN-660073 END-----

      #FUN-B80058--add--str--
      AFTER FIELD azf141
         IF NOT cl_null(g_azf[l_ac].azf141) THEN 
            LET g_azf[l_ac].aag0231 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf141) 
            DISPLAY BY NAME g_azf[l_ac].aag0231
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_azf[l_ac].azf141,g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_azf[l_ac].azf141
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf141 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81  
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf141 
                DISPLAY BY NAME g_azf[l_ac].azf141
                LET g_azf[l_ac].aag0231 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf141) 
                DISPLAY BY NAME g_azf[l_ac].aag0231
               NEXT FIELD azf141
            END IF
            IF g_azf[l_ac].azf141 != g_azf_t.azf141 OR g_azf_t.azf141 IS NULL THEN
               CALL i300_azf14(g_azf[l_ac].azf09,g_aza.aza81,g_azf[l_ac].azf141)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(' ',g_errno,0)
                  LET g_azf[l_ac].azf141 = g_azf_t.azf141
                  DISPLAY BY NAME g_azf[l_ac].azf141
                  NEXT FIELD azf141
               END IF
            END IF
         ELSE
            LET g_azf[l_ac].aag0231 = ''
            DISPLAY BY NAME g_azf[l_ac].aag0231
         END IF 
      #FUN-B80058--add--end--  
 
      #No.FUN-6B0065 --begin
      BEFORE FIELD azf09
         CALL cl_set_comp_entry("azf10",TRUE)  
         CALL cl_set_comp_entry("azf11",TRUE) 
         CALL cl_set_comp_entry("azf13",TRUE) 
 
      AFTER FIELD azf09         
         IF cl_null(g_azf[l_ac].azf09) OR
           #g_azf[l_ac].azf09 not MATCHES '[123456]' THEN               #No.FUN-930106
           #g_azf[l_ac].azf09 not MATCHES '[123456789ABCDEF]' THEN        #No.FUN-930106  #FUN-950077 mark
           #g_azf[l_ac].azf09 not MATCHES '[12345678ABCDEF]' THEN        #No.FUN-950077  #FUN-870100 mark
           #g_azf[l_ac].azf09 not MATCHES '[123456789ABCDEFGH]' THEN        #No.FUN-870100 add   #FUN-A70064 add #FUN-B80051 mark
            # g_azf[l_ac].azf09 not MATCHES '[123456789ABCDEFGHI]' THEN    #FUN-B80051 add           
            g_azf[l_ac].azf09 not MATCHES '[123456789ABCDEFGHIJ]' THEN    #darcy:2023/05/23 add
            NEXT FIELD azf09 
         END IF
         #No.TQC-AC0150 --Begin
         #IF g_azf[l_ac].azf09 NOT MATCHES '[123]' THEN    #MOD-A80122 add '3'
         IF g_azf[l_ac].azf09 NOT MATCHES '[1237]' THEN    
         #No.TQC-AC0150 --End  
            LET g_azf[l_ac].azf10='N'
            CALL cl_set_comp_entry("azf10",FALSE)  
         END IF
         IF g_azf[l_ac].azf09='3' THEN
            LET g_azf[l_ac].azf11='N'
            CALL cl_set_comp_entry("azf11",FALSE)  
         END IF
         IF g_azf[l_ac].azf09<>'2' THEN
            LET g_azf[l_ac].azf13='N'
            CALL cl_set_comp_entry("azf13",FALSE)  
         END IF
      #No.FUN-6B0065 --end
#No.MOD-B50073 --begin
         IF g_azf[l_ac].azf09 != g_azf_t.azf09 OR g_azf_t.azf09 IS NULL THEN
#           CALL i300_azf07(g_azf[l_ac].azf09,g_aza.aza81,g_azf[l_ac].azf07)
            CALL i300_azf14(g_azf[l_ac].azf09,g_aza.aza81,g_azf[l_ac].azf14)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(' ',g_errno,0)
               LET g_azf[l_ac].azf09 = g_azf_t.azf09
               DISPLAY BY NAME g_azf[l_ac].azf09
               NEXT FIELD azf09
            END IF
         END IF
#No.MOD-B50073 --end
      #No.FUN-BA0109  --Begin
      AFTER FIELD azf20
         IF NOT cl_null(g_azf[l_ac].azf20) THEN 
            LET g_azf[l_ac].aag024 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf20)
            DISPLAY BY NAME g_azf[l_ac].aag024
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_azf[l_ac].azf20,g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf20
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = "aag20 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf20 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81 
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf20 
                DISPLAY BY NAME g_azf[l_ac].azf20
                LET g_azf[l_ac].aag024 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf20)
                DISPLAY BY NAME g_azf[l_ac].aag024
               NEXT FIELD azf20
            END IF
         ELSE
           #LET g_azf[l_ac].aag022 = ''     #MOD-D80090 mark
            LET g_azf[l_ac].aag024 = ''     #MOD-D80090 
            DISPLAY BY NAME g_azf[l_ac].aag024
         END IF
         
       AFTER FIELD azf201
         IF NOT cl_null(g_azf[l_ac].azf201) THEN 
            LET g_azf[l_ac].aag025= i300_aag02(g_aza.aza82,g_azf[l_ac].azf201)   #No.FUN-730020
            DISPLAY BY NAME g_azf[l_ac].aag025
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_azf[l_ac].azf201,g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_azf[l_ac].azf201
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf201 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza82  
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf201 
                DISPLAY BY NAME g_azf[l_ac].azf201
                LET g_azf[l_ac].aag025= i300_aag02(g_aza.aza82,g_azf[l_ac].azf201)  
                DISPLAY BY NAME g_azf[l_ac].aag025
               NEXT FIELD azf201
            END IF
         ELSE
            LET g_azf[l_ac].aag025= ''
            DISPLAY BY NAME g_azf[l_ac].aag025
         END IF
      #No.FUN-BA0109  --End
     #FUN-C90078--add---str
      AFTER FIELD azf21
         IF NOT cl_null(g_azf[l_ac].azf21) THEN
            LET g_azf[l_ac].aag026 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf21)
            DISPLAY BY NAME g_azf[l_ac].aag026
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_azf[l_ac].azf21,g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_azf[l_ac].azf21
                LET g_qryparam.construct = 'N'
                LET g_qryparam.where = "aag20 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf21 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf21
                DISPLAY BY NAME g_azf[l_ac].azf21
                LET g_azf[l_ac].aag026 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf21)
                DISPLAY BY NAME g_azf[l_ac].aag026
               NEXT FIELD azf21
            END IF
         ELSE
            LET g_azf[l_ac].aag026 = ''
            DISPLAY BY NAME g_azf[l_ac].aag026
         END IF

       AFTER FIELD azf211
         IF NOT cl_null(g_azf[l_ac].azf211) THEN
            LET g_azf[l_ac].aag027= i300_aag02(g_aza.aza82,g_azf[l_ac].azf211)
            DISPLAY BY NAME g_azf[l_ac].aag027
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_azf[l_ac].azf211,g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_azf[l_ac].azf211
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_azf[l_ac].azf211 CLIPPED,"%'"
                LET g_qryparam.arg1 = g_aza.aza82
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf211
                DISPLAY BY NAME g_azf[l_ac].azf211
                LET g_azf[l_ac].aag027= i300_aag02(g_aza.aza82,g_azf[l_ac].azf211)
                DISPLAY BY NAME g_azf[l_ac].aag027
               NEXT FIELD azf211
            END IF
         ELSE
            LET g_azf[l_ac].aag027= ''
            DISPLAY BY NAME g_azf[l_ac].aag027
         END IF
      #FUN-C90078--add---end 
      AFTER FIELD azfacti
         IF NOT cl_null(g_azf[l_ac].azfacti) THEN
            IF g_azf[l_ac].azfacti NOT MATCHES '[YN]' THEN 
               LET g_azf[l_ac].azfacti = g_azf_t.azfacti
               NEXT FIELD azfacti
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_azf_t.azf01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

           ##TQC-B30004 mark begin------------------- 
           ##FUN-A30030 ADD--------------------
           # IF g_aza.aza88 = 'Y' THEN
           #    IF g_azf[l_ac].azfacti='Y' OR g_azf[l_ac].azfpos='N' THEN
           #       CALL cl_err('','art-648',0)
           #      #ROLLBACK WORK
           #       CANCEL DELETE
           #    END IF
           # END IF
           ##FUN-A30030 END--------------------
           ##TQC-B30004 mark end---------------------

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM azf_file WHERE azf01 = g_azf_t.azf01
                                   AND azf02 = g_azf02  #MOD-D10227
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_azf_t.azf01,SQLCA.sqlcode,0)   #No.FUN-660131
               CALL cl_err3("del","azf_file",g_azf_t.azf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_azf[l_ac].* = g_azf_t.*
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_azf[l_ac].azf01,-263,1)
            LET g_azf[l_ac].* = g_azf_t.*
         ELSE
           ##TQC-B30004 mark begin---------------- 
           ##FUN-A30030 ADD--------------------
           # IF g_aza.aza88 = 'Y' THEN
           #    LET g_azf[l_ac].azfpos='N' 
           #    DISPLAY BY NAME  g_azf[l_ac].azfpos
           # END IF
           ##FUN-A30030 END--------------------
           ##TQC-B30004 mark end------------------
            UPDATE azf_file SET azf01=g_azf[l_ac].azf01,
                                azf02=g_azf02,
                                azf03=g_azf[l_ac].azf03,
                                azf05=g_azf[l_ac].azf05,   #FUN-510041 add
                                azf051=g_azf[l_ac].azf051,   #FUN-680086 add
                                azf06=g_azf[l_ac].azf06,   #FUN-650001 add
                                azf07=g_azf[l_ac].azf07,   #No.FUN-660073
                                azf071=g_azf[l_ac].azf071, #No.FUN-B80058
                                azf08=g_azf[l_ac].azf08,   #No.FUN-660073
                                azf09=g_azf[l_ac].azf09,   #No.FUN-6B0065
                                azf10=g_azf[l_ac].azf10,   #No.FUN-6B0065
                                azf11=g_azf[l_ac].azf11,   #No.FUN-6B0065
                                azf12=g_azf[l_ac].azf12,   #No.FUN-6B0065
                                azf13=g_azf[l_ac].azf13,   #No.FUN-6B0065
                                azf20=g_azf[l_ac].azf20,   #No.FUN-BA0109
                                azf201=g_azf[l_ac].azf201, #No.FUN-BA0109
                                azf21=g_azf[l_ac].azf21,   #No.FUN-C90078
                                azf211=g_azf[l_ac].azf211, #No.FUN-C90078
                                azf14=g_azf[l_ac].azf14,   #No.FUN-660073
                                azf141=g_azf[l_ac].azf141, #No.FUN-B80058
                                azfacti=g_azf[l_ac].azfacti,
                                ta_azf01=g_azf[l_ac].ta_azf01, #add by huanglf170315
                                #azfpos=g_azf[l_ac].azfpos,  #FUN-A30030 ADD  #TQC-B30004 mark
                                azfmodu=g_user,
                                azfdate=g_today
             WHERE azf02 = g_azf02
               AND azf01 = g_azf_t.azf01 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_azf[l_ac].azf01,SQLCA.sqlcode,0)   #No.FUN-660131
               CALL cl_err3("upd","azf_file",g_azf02,g_azf_t.azf01,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_azf[l_ac].* = g_azf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_azf[l_ac].* = g_azf_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_azf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D40030 Add
         CLOSE i300_bcl
         COMMIT WORK
 
      #FUN-510041 add
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(azf05)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf05
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730020
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf05 
                DISPLAY BY NAME g_azf[l_ac].azf05
                LET g_azf[l_ac].aag02 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf05)   #No.FUN-730020
                DISPLAY BY NAME g_azf[l_ac].aag02
                NEXT FIELD azf05
             #FUN-680086  --begin
             WHEN INFIELD(azf051)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf051
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                LET g_qryparam.arg1 = g_aza.aza82  #No.FUN-730020
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf051 
                DISPLAY BY NAME g_azf[l_ac].azf051
                LET g_azf[l_ac].aag021= i300_aag02(g_aza.aza82,g_azf[l_ac].azf051)   #No.FUN-730020
                DISPLAY BY NAME g_azf[l_ac].aag021
                NEXT FIELD azf051
             #FUN-680086  --end
             #-----No.FUN-660073-----
             WHEN INFIELD(azf07)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf07
#No.TQC-B50094 --begin
#No.MOD-B50073 --begin
#                IF g_azf[l_ac].azf09 ='7' THEN
#                   LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"
#                ELSE
#                   LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
#                END IF
#No.MOD-B50073 --end
#No.TQC-B50094 --end
                LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730020
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf07 
                DISPLAY BY NAME g_azf[l_ac].azf07
                LET g_azf[l_ac].aag022 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf07)  #No.FUN-730020
                DISPLAY BY NAME g_azf[l_ac].aag022
                NEXT FIELD azf07
             
             #FUN-C90078--add--str
             WHEN INFIELD(azf21)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_azf[l_ac].azf21
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf21
                DISPLAY BY NAME g_azf[l_ac].azf21
                LET g_azf[l_ac].aag026 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf21)
                DISPLAY BY NAME g_azf[l_ac].aag026
                NEXT FIELD azf21
             WHEN INFIELD(azf211)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.default1 = g_azf[l_ac].azf211
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                LET g_qryparam.arg1 = g_aza.aza82
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf211
                DISPLAY BY NAME g_azf[l_ac].azf211
                LET g_azf[l_ac].aag027= i300_aag02(g_aza.aza82,g_azf[l_ac].azf211)
                DISPLAY BY NAME g_azf[l_ac].aag027
                NEXT FIELD azf211
               #FUN-C90078--add--end
             #FUN-B80058--add--str--
             WHEN INFIELD(azf071)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf071
                LET g_qryparam.arg1 = g_aza.aza81  
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf071 
                DISPLAY BY NAME g_azf[l_ac].azf071
                LET g_azf[l_ac].aag0221 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf071) 
                DISPLAY BY NAME g_azf[l_ac].aag0221
                NEXT FIELD azf071

             WHEN INFIELD(azf141)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf141
                IF g_azf[l_ac].azf09 ='7' THEN
#                  LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  ##FUN-D90021 mark
                   #FUN-D90021 add ---- begin for 大陸版去掉aag21控管
                   IF g_aza.aza26 = '2' THEN
                      LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') "
                   ELSE
                      LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"
                   END IF
                   #FUN-D90021 add ---- end
                ELSE
                   LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                END IF
                LET g_qryparam.arg1 = g_aza.aza81 
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf141 
                DISPLAY BY NAME g_azf[l_ac].azf141
                LET g_azf[l_ac].aag0231 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf141) 
                DISPLAY BY NAME g_azf[l_ac].aag0231
                NEXT FIELD azf141  
             #FUN-B80058--add--end--
                
             WHEN INFIELD(azf14)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf14
#No.TQC-B50094 --begin
                IF g_azf[l_ac].azf09 ='7' THEN
#                  LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  #FUN-D90021 mark
                   #FUN-D90021 add ---- begin for 大陸版去掉aag21控管
                   IF g_aza.aza26 = '2' THEN
                      LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') "
                   ELSE
                      LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"
                   END IF
                   #FUN-D90021 add ---- end
                ELSE
                   LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                END IF
#No.TQC-B50094 --end
                LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730020
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf14 
                DISPLAY BY NAME g_azf[l_ac].azf14
                LET g_azf[l_ac].aag023 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf14)  #No.FUN-730020
                DISPLAY BY NAME g_azf[l_ac].aag023
                NEXT FIELD azf14
             #-----No.FUN-660073-----
             #No.FUN-BA0109  --Begin
              WHEN INFIELD(azf20)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf20
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf20 
                DISPLAY BY NAME g_azf[l_ac].azf20
                LET g_azf[l_ac].aag024 = i300_aag02(g_aza.aza81,g_azf[l_ac].azf20)
                DISPLAY BY NAME g_azf[l_ac].aag024
                NEXT FIELD azf20
             WHEN INFIELD(azf201)      #查詢科目代號不為統制帳戶'1'
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 = g_azf[l_ac].azf201
                LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
                LET g_qryparam.arg1 = g_aza.aza82
                CALL cl_create_qry() RETURNING g_azf[l_ac].azf201 
                DISPLAY BY NAME g_azf[l_ac].azf201
                LET g_azf[l_ac].aag025= i300_aag02(g_aza.aza82,g_azf[l_ac].azf201)
                DISPLAY BY NAME g_azf[l_ac].aag025
                NEXT FIELD azf201
               #No.FUN-BA0109  --End
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(azf01) AND l_ac > 1 THEN
            LET g_azf[l_ac].* = g_azf[l_ac-1].*
            NEXT FIELD azf01
         END IF
 
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
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i300_bcl
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_aag02(p_bookno,p_code)  #No.FUN-730020
  DEFINE p_bookno   LIKE aag_file.aag00
  DEFINE p_code     LIKE aag_file.aag01  
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag02    LIKE aag_file.aag02
 
   LET l_aag02 = ''
   LET l_aag07 = ''
   LET l_aag09 = ''
   LET l_aagacti = ''
   LET g_errno = ''
   SELECT aag02,aag07,aag09,aagacti
     INTO l_aag02,l_aag07,l_aag09,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00=p_bookno  #No.FUN-730020
 
   CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
        WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        WHEN l_aag09  = 'N'     LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   
   RETURN l_aag02
 
END FUNCTION
 
FUNCTION i300_b_askkey()
 
    CLEAR FORM
    CALL g_azf.clear()
    DISPLAY g_azf02 TO azf02
 
    CONSTRUCT g_wc2 ON azf01,azf03,azf05,azf051,azf07,azf071,azf14,azf141,azf20,azf201,azf08,azf21,azf211,   #No.FUN-660073  #No.TQC-6C0130 #FUN-B80058 add 071 141 #FUN-BA0109 add 20,201 #FUN-C90078 add azf21,azf211
                      azf06,azf09,azf10,azf11,azf12,azf13,azfacti,ta_azf01 #add by huanglf170315 #,azfpos  #FUN-A30030 ADD POS    #FUN-510041 add azf05   #FUN-650001 add azf06 #FUN-680086  #No.FUN-6B0065 #TQC-B30004 mark POS
         FROM s_azf[1].azf01,s_azf[1].azf03,s_azf[1].azf05,
              s_azf[1].azf051,s_azf[1].azf07,s_azf[1].azf071,s_azf[1].azf14,s_azf[1].azf141,   #No.FUN-660073 #FUN-B80058 add 071 141
              s_azf[1].azf20,s_azf[1].azf201,                 #No.FUN-BA0109
              s_azf[1].azf21,s_azf[1].azf211,      #No.FUN-C90078
              s_azf[1].azf08,s_azf[1].azf06,s_azf[1].azf09,s_azf[1].azf10,   #FUN-650001 add s_azf[1].azf06  #FUN-680086   #No.FUN-660073 #No.FUN-6B0065  #No.TQC-6C0130
              s_azf[1].azf11,s_azf[1].azf12,s_azf[1].azf13,   #No.FUN-6B0065
              s_azf[1].azfacti,s_azf[1].ta_azf01 #add by huanglf170315 #,s_azf[1].azfpos                    #FUN-A30030 ADD POS #TQC-B30004 mark POS
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        #FUN-510041 add 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(azf05)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf05
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf05
              #-----No.FUN-660073-----
              WHEN INFIELD(azf07)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf07
#No.TQC-B50094 --begin
#No.MOD-B50073 --begin
#                 IF g_azf[l_ac].azf09 ='7' THEN
#                    LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'" 
#                 ELSE
#                    LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
#                 END IF
#No.MOD-B50073 --end
#No.TQC-B50094 --end
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf07

              #FUN-B80058--add--str--
              WHEN INFIELD(azf071)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf071
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf071
              WHEN INFIELD(azf141)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf141
                 IF g_azf[l_ac].azf09 ='7' THEN
#                   LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  #FUN-D90021 mark
                    #FUN-D90021 add ---- begin for 大陸版去掉aag21控管
                    IF g_aza.aza26 = '2' THEN
                       LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') "
                    ELSE
                       LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"
                    END IF
                    #FUN-D90021 add ---- end
                 ELSE
                    LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 END IF
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf141
              #FUN-B80058--add--end--   
                 
              WHEN INFIELD(azf14)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf14
#No.TQC-B50094 --begin
#No.MOD-B50073 --begin
                 IF g_azf[l_ac].azf09 ='7' THEN
#                   LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"  #FUN-D90021 mark
                    #FUN-D90021 add ---- begin for 大陸版去掉aag21控管
                    IF g_aza.aza26 = '2' THEN
                       LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') "
                    ELSE
                       LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21='Y'"
                    END IF
                    #FUN-D90021 add ---- end
                 ELSE
                    LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 END IF
#No.MOD-B50073 --end
#No.TQC-B50094 --end
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf14
              #-----No.FUN-660073 END-----
              #No.FUN-BA0109  --Begin
               WHEN INFIELD(azf20)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf05
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf20
                WHEN INFIELD(azf201)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf05
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf201
                #No.FUN-BA0109  --End
                #FUN-C90078--add--str
               WHEN INFIELD(azf21)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf05
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf21
                WHEN INFIELD(azf211)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_azf[1].azf05
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO azf211
               #FUN-C90078--add--end
              OTHERWISE
           END CASE
         ##
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('azfuser', 'azfgrup') #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    LET g_wc2 =g_wc2 CLIPPED, "  AND azf02 ='",g_azf02 CLIPPED,"' " 
 
    CALL i300_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT azf01,azf03,azf05,'',azf051,'',azf07,'',azf071,'',azf14,'',azf141,'',",   #FUN-650001 add azf06 #FUN-680086   #No.FUN-660073
               "       azf20,'',azf201,'',azf21,'',azf211,'',azf08,azf06,azf09,azf10,azf11,azf12,azf13,azfacti,ta_azf01", #add by huanglf170315#,azfpos",  #FUN-A30030 ADD POS  #No.FUN-6B0065  #TQC-B30004 mark POS #FUN-BA0109 add 20,201 #FUN-C90078 add azf21,211
               "  FROM azf_file ",                                         #FUN-B80058 add azf071,azf141
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY azf01"
   PREPARE i300_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR i300_pb
 
   CALL g_azf.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_azf[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_azf[g_cnt].aag02 = i300_aag02(g_aza.aza81,g_azf[g_cnt].azf05)   #No.FUN-730020
      LET g_azf[g_cnt].aag021= i300_aag02(g_aza.aza82,g_azf[g_cnt].azf051)  #FUN-680086  #No.FUN-730020
      LET g_azf[g_cnt].aag022= i300_aag02(g_aza.aza81,g_azf[g_cnt].azf07)   #No.FUN-660073  #No.FUN-730020
      LET g_azf[g_cnt].aag023= i300_aag02(g_aza.aza81,g_azf[g_cnt].azf14)   #No.FUN-660073  #No.FUN-730020
      LET g_azf[g_cnt].aag024= i300_aag02(g_aza.aza81,g_azf[g_cnt].azf20)   #No.FUN-BA0109
      LET g_azf[g_cnt].aag026= i300_aag02(g_aza.aza81,g_azf[g_cnt].azf21)   #FUN-C90078
      LET g_azf[g_cnt].aag025= i300_aag02(g_aza.aza82,g_azf[g_cnt].azf201)   #No.FUN-BA0109
      LET g_azf[g_cnt].aag027= i300_aag02(g_aza.aza82,g_azf[g_cnt].azf211)   #FUN-C90078
      LET g_azf[g_cnt].aag0221= i300_aag02(g_aza.aza81,g_azf[g_cnt].azf071)   #No.FUN-BA0109
      LET g_azf[g_cnt].aag0231= i300_aag02(g_aza.aza82,g_azf[g_cnt].azf141)   #No.FUN-BA0109
      
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      
   END FOREACH
 
   CALL g_azf.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azf TO s_azf.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i300_out()
    DEFINE
        l_azf           RECORD LIKE azf_file.*,
        l_n,l_waitsec   LIKE type_file.num5,     #No.FUN-680102 SMALLINT,
        l_name          LIKE type_file.chr20,    #No.FUN-680102 VARCHAR(20),                # External(Disk) file name
        l_prog          LIKE type_file.chr20,    #No.FUN-680102 VARCHAR(20),                 
        l_buf           LIKE type_file.chr6,     #No.FUN-680102 VARCHAR(6),
        l_sw            LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        l_cmd           STRING
    DEFINE l_desc       LIKE type_file.chr1000   #No.FUN-850016                                                                     
    DEFINE l_aag02      LIKE aag_file.aag02      #No.FUN-850016                                                                     
    DEFINE l_aag022     LIKE aag_file.aag02     #No.FUN-850016                                                                      
    DEFINE l_aag023     LIKE aag_file.aag02     #No.FUN-850016  
    DEFINE l_aag024     LIKE aag_file.aag02     #No.FUN-BA0109                                                                      
    DEFINE l_aag025     LIKE aag_file.aag02     #No.FUN-BA0109                                                                    
    DEFINE l_gae04      LIKE gae_file.gae04      #No.FUN-850016                                                                     
    DEFINE l_aag026     LIKE aag_file.aag02    #FUN-C90078
    DEFINE l_aag027     LIKE aag_file.aag02    #FUN-C90078     
                                                                                                                                     
   CALL cl_del_data(l_table)  #No.FUN-850016                    
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN 
    END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * FROM azf_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i300_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i300_co                         # SCROLL CURSOR
         CURSOR FOR i300_p1
 
    LET g_rlang = g_lang                               #FUN-4C0096 add
    LET l_prog  = g_prog
    LET g_prog = 'aooi300'
 
#No.FUN-850016 --begin                                                                                                              
{    
    CALL cl_outnam('aooi300') RETURNING l_name
 
    #-----No.FUN-660073-----
    IF g_argv1 <> 'H' THEN
       LET g_zaa[38].zaa06='Y'
       LET g_zaa[39].zaa06='Y'
       LET g_zaa[40].zaa06='Y'
       LET g_zaa[52].zaa06='Y'
       LET g_zaa[53].zaa06='Y'
    END IF
    #-----No.FUN-660073 END-----
 
   #FUN-5B0111...............begin
     IF g_argv1 <> 'G' THEN
        LET g_zaa[35].zaa06='Y'
        LET g_zaa[36].zaa06='Y'
        LET g_zaa[37].zaa06='Y'   #FUN-650001 add
     END IF
   #FUN-5B0111...............end
   #No.FUN-6B0065 --begin
   IF g_aza.aza50 = 'Y' AND g_argv1 = 'H' THEN
      LET g_zaa[41].zaa06='N'
      LET g_zaa[42].zaa06='N'
      LET g_zaa[43].zaa06='N'
      LET g_zaa[44].zaa06='N'
      LET g_zaa[45].zaa06='N'
   ELSE
      LET g_zaa[41].zaa06='Y'
      LET g_zaa[42].zaa06='Y'
      LET g_zaa[43].zaa06='Y'
      LET g_zaa[44].zaa06='Y'
      LET g_zaa[45].zaa06='Y'
   END IF
   #No.FUN-6B0065 --end
     CALL cl_prt_pos_len()   #FUN-650001 add
 
 
 #####  MOD-530488   #####
    SELECT zz06 INTO l_sw
     FROM zz_FILE WHERE zz01 = g_tit 
 
    IF l_sw = '1' THEN   
        LET l_name = g_tit CLIPPED,'.out'
    ELSE
        SELECT zz16,zz24  INTO l_n,l_waitsec
            FROM zz_FILE WHERE zz01 = g_tit
        IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
        LET l_n = l_n + 1
        IF l_n > 30000 THEN  LET l_n = 0  END IF
        UPDATE zz_file SET zz16 = l_n WHERE zz01 = g_tit 
        LET l_buf = l_n USING "&&&&&&"
        LET l_name = g_tit CLIPPED,".",l_buf[5,6],"r"
   END IF
 
#    LET l_name = g_tit CLIPPED,l_name[8,11]
    LET g_xml_rep = l_name CLIPPED,".xml"
    LET l_cmd = 'rm -f ',l_name CLIPPED,'*'
    RUN l_cmd
    CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED))
 #####  MOD-530488   #####
    START REPORT i300_rep TO l_name
}                                                                                                                                   
    IF g_argv1 <> 'H' OR g_argv1 <> 'G' THEN                                                                                        
       LET l_name = "aooi300"                                                                                                       
    END IF                                                                                                                          
    IF g_argv1 = 'G' THEN                                                                                                           
       LET l_name = "aooi300_1"                                                                                                     
    END IF                                                                                                                          
    IF g_aza.aza50 = 'Y' AND g_argv1 = 'H' THEN                                                                                     
       LET l_name = "aooi300_2"                                                                                                     
    END IF                                                                                                                          
    IF g_aza.aza50 = 'N' AND g_argv1 = 'H' THEN                                                                                     
       LET l_name = "aooi300_3"                                                                                                     
    END IF                                                                                                                          
                                                                                                                                    
    CASE                                                                                                                            
       WHEN g_argv1='2'                                                                                                             
            CALL cl_getmsg('aoo-199',g_lang) RETURNING l_desc                                                                       
       WHEN g_argv1='3'                                                                                                             
            CALL cl_getmsg('aoo-200',g_lang) RETURNING l_desc                                                                       
       WHEN g_argv1='5'                                                                                                             
            CALL cl_getmsg('aoo-198',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi303'                                                                                                    
       WHEN g_argv1='6'                                                                                                             
            CALL cl_getmsg('aoo-197',g_lang) RETURNING l_desc 
        LET g_prog='aooi304'                                                                                                    
       WHEN g_argv1='8'                                                                                                             
            CALL cl_getmsg('aoo-196',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi305'                                                                                                    
       WHEN g_argv1='A'                                                                                                             
            CALL cl_getmsg('aoo-195',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi306'                                                                                                    
       WHEN g_argv1='D'                                                                                                             
            CALL cl_getmsg('aoo-194',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi309'                                                                                                    
       WHEN g_argv1='E'                                                                                                             
            CALL cl_getmsg('aoo-192',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi310'                                                                                                    
       WHEN g_argv1='F'                                                                                                             
            CALL cl_getmsg('aoo-191',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi311'                                                                                                    
       WHEN g_argv1='G'                                                                                                             
            CALL cl_getmsg('aoo-190',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi312'                                                                                                    
       WHEN g_argv1='H'                                                                                                             
            CALL cl_getmsg('aoo-193',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi313'                                                                                                    
       OTHERWISE                                                                                                                    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211     
       EXIT PROGRAM                    
    END CASE                                                                                                                         
#No.FUN-850016  --END 
   
    FOREACH i300_co INTO l_azf.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#No.FUN-850016  --BEGIN   
        #OUTPUT TO REPORT i300_rep(l_azf.*)
        LET l_aag02 = ''                                                                                                            
        SELECT aag02 INTO l_aag02 FROM aag_file                                                                                     
         WHERE aag01 = l_azf.azf05                                                                                                  
           AND aag00 = g_aza.aza81                                                                                                  
        LET l_aag022 = ''                                                                                                           
        SELECT aag02 INTO l_aag022 FROM aag_file                                                                                    
         WHERE aag01 = l_azf.azf07                                                                                                  
           AND aag00 = g_aza.aza81                                                                                                  
        LET l_aag023 = ''                                                                                                           
        SELECT aag02 INTO l_aag023 FROM aag_file                                                                                    
         WHERE aag01 = l_azf.azf14                                                                                                  
           AND aag00 = g_aza.aza81                                                                                                  
        #No.FUN-BA0109  --Begin
        LET l_aag024 = ''                                                                                                           
        SELECT aag02 INTO l_aag024 FROM aag_file                                                                                    
         WHERE aag01 = l_azf.azf20                                                                                                  
           AND aag00 = g_aza.aza81 
        LET l_aag025 = ''                                                                                                           
        SELECT aag02 INTO l_aag025 FROM aag_file                                                                                    
         WHERE aag01 = l_azf.azf201                                                                                                  
           AND aag00 = g_aza.aza82 
        #No.FUN-BA0109  --End                                                                                                         
        #FUN-C90078--add--str
        LET l_aag026 = ''
        SELECT aag02 INTO l_aag026 FROM aag_file
         WHERE aag01 = l_azf.azf21
           AND aag00 = g_aza.aza81
         LET l_aag027 = ''
        SELECT aag02 INTO l_aag027 FROM aag_file
         WHERE aag01 = l_azf.azf211
           AND aag00 = g_aza.aza82
        #FUN-C90078--add--end     
         IF g_argv1 = 'G' THEN                                                                                                        
               CASE l_azf.azf06                                                                                                     
                   WHEN 0                                                                                                           
                      SELECT gae04 INTO l_gae04 FROM gae_file                                                                       
                       WHERE gae01='aooi300' AND gae02='azf06_0' AND gae03=g_lang                                                   
                   WHEN 1                                                                                                           
                      SELECT gae04 INTO l_gae04 FROM gae_file                                                                       
                       WHERE gae01='aooi300' AND gae02='azf06_1' AND gae03=g_lang                                                   
                   WHEN 2                                    
                      SELECT gae04 INTO l_gae04 FROM gae_file                                                                       
                       WHERE gae01='aooi300' AND gae02='azf06_2' AND gae03=g_lang                                                   
                   WHEN 3                                                                                                           
                      SELECT gae04 INTO l_gae04 FROM gae_file                                                                       
                       WHERE gae01='aooi300' AND gae02='azf06_3' AND gae03=g_lang                                                   
               END CASE                                                                                                             
       END IF                                                                                                                       
       EXECUTE insert_prep USING l_azf.azf05,l_azf.azf07,l_azf.azf14,l_azf.azf01,                                                   
                                 l_azf.azf02,l_azf.azf03,l_azf.azf09,l_azf.azf10,                                                   
                                 l_azf.azf11,l_azf.azf12,l_azf.azf13,l_azf.azf20,l_azf.azf201,  #FUN-BA0109 add azf20,201
                                 l_azf.azfacti,l_azf.azf21,l_azf.azf211,     #FUN-C90078 add-azf21,azf211                                                
                                 l_azf.azf06,l_azf.azf08,l_aag02,l_aag022,l_aag023,       #FUN-BA0109 add azf20                                                 
                                 l_aag024,l_aag025,                                  #FUN-BA0109 add
                                 l_gae04                                                                                            
#No.FUN-850016  --END                              
    END FOREACH
 
    #FINISH REPORT i300_rep  #No.FUN-850016
 
    CLOSE i300_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)  #No.FUN-850016
    LET g_prog = l_prog
#No.FUN-850016   --begin                                                                                                            
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(g_wc2,'azf01,azf03,azf05,azf051,azf07,azf14,azf20,azf201,azf21,azf211,azf08,      #FUN-BA0109 add azf20,azf201    #FUN-C90078 ADD azf21,211                                                       
                            azf06,azf09,azf10,azf11,azf12,azf13,azfacti,azf02 ')                                                    
       #RETURNING g_wc2     #MOD-930299 mark                                                                                                             
        RETURNING g_str     #MOD-930299                                                                                                            
       #LET g_str = g_wc2   #MOD-930299 mark                                                                                                         
     END IF                                                                                                                         
     LET g_prog1 = g_prog                                                                                                           
     LET g_str=g_str CLIPPED,';',l_desc,';',g_argv1,';',g_prog1                                                                     
     LET g_prog = "aooi300"                                                                                                         
     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('aooi300',l_name,g_sql,g_str)                                                                                  
#No.FUN-850016   --end      
END FUNCTION
 
#No.FUN-850016  --BEGIN                                                                                                             
{      
REPORT i300_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        l_str           LIKE type_file.chr1000,  #No.FUN-680102 VARCHAR(40), 
        l_desc          LIKE type_file.chr1000,  #No.FUN-680102 VARCHAR(40), 
        l_aag02         LIKE aag_file.aag02,
        l_aag022        LIKE aag_file.aag02,   #No.FUN-660073
        l_aag023        LIKE aag_file.aag02,   #No.FUN-660073
        sr              RECORD LIKE azf_file.*,
        l_azf06         LIKE azf_file.azf06,    #No.FUN-680102 VARCHAR(2),              #FUN-650001 add
        l_gae04         LIKE gae_file.gae04,  #FUN-650001 add
        l_msg           STRING                #FUN-650001 add
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.azf01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
           #start FUN-6A0004 modify
            CASE
               WHEN g_argv1='2' LET g_x[1]=g_x[10]   #g_x[16]
               WHEN g_argv1='3' LET g_x[1]=g_x[11]   #g_x[17]
               WHEN g_argv1='5' LET g_x[1]=g_x[12]   #g_x[18]
               WHEN g_argv1='6' LET g_x[1]=g_x[13]   #g_x[19]
               WHEN g_argv1='8' LET g_x[1]=g_x[14]   #g_x[20]
               WHEN g_argv1='A' LET g_x[1]=g_x[15]   #g_x[21]
              #WHEN g_argv1='B' LET g_x[1]=g_x[22]
              #WHEN g_argv1='C' LET g_x[1]=g_x[23]
               WHEN g_argv1='D' LET g_x[1]=g_x[16]   #g_x[24]
               WHEN g_argv1='E' LET g_x[1]=g_x[17]   #g_x[25]
               WHEN g_argv1='F' LET g_x[1]=g_x[18]   #g_x[26]
               WHEN g_argv1='G' LET g_x[1]=g_x[19]   #g_x[27]
               WHEN g_argv1='H' LET g_x[1]=g_x[20]   #No.FUN-6B0065
            END CASE
           #end FUN-6A0004 modify
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash
 
            PRINT g_x[31], 
                  g_x[32],
                  g_x[33],
                  g_x[34];
            #IF g_argv1 = 'G' THEN 
               PRINT g_x[35],
                     g_x[36],
                     g_x[37];   #FUN-650001 add
               #No.FUN-6B0065 --begin
#              PRINT g_x[38],g_x[39],g_x[40]   #No.FUN-660073        #No.FUN-6B0065
               PRINT g_x[38],g_x[39],g_x[40],g_x[52],g_x[53],   #No.FUN-660073
                     g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]     #No.FUN-6B0065
               #No.FUN-6B0065 --end
 
            #ELSE
            #   PRINT ''
            #END IF
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
#TQC-6B0023-BEGIN-------                                                                                                            
   CASE                                                                                                                             
       WHEN g_argv1='2'                                                                                                             
            CALL cl_getmsg('aoo-199',g_lang) RETURNING l_desc                                                                       
       WHEN g_argv1='3'                                                                                                             
            CALL cl_getmsg('aoo-200',g_lang) RETURNING l_desc                                                                       
       WHEN g_argv1='5'                                                                                                             
            CALL cl_getmsg('aoo-198',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi303'                                                                                                    
       WHEN g_argv1='6'                                                                                                             
            CALL cl_getmsg('aoo-197',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi304'                                                                                                    
       WHEN g_argv1='8'                                                                                                             
            CALL cl_getmsg('aoo-196',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi305'                                                                                                    
       WHEN g_argv1='A'                                                                                                             
            CALL cl_getmsg('aoo-195',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi306'                                                                                                    
       WHEN g_argv1='D'                                                                                                             
            CALL cl_getmsg('aoo-194',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi309'                                                                                                    
       WHEN g_argv1='E'                                                                                                             
            CALL cl_getmsg('aoo-192',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi310'
       WHEN g_argv1='F'                                                                                                             
            CALL cl_getmsg('aoo-191',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi311'                                                                                                    
       WHEN g_argv1='G'                                                                                                             
            CALL cl_getmsg('aoo-190',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi312'                                                                                                    
       WHEN g_argv1='H'                                                                                                             
            CALL cl_getmsg('aoo-193',g_lang) RETURNING l_desc                                                                       
            LET g_prog='aooi313'                                                                                                    
       OTHERWISE                                                                                                                    
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211     
       EXIT PROGRAM
   END CASE                                                                                                                         
#TQC-6B0023-END-------
            LET l_aag02 = ''
            SELECT aag02 INTO l_aag02 FROM aag_file
             WHERE aag01 = sr.azf05
               AND aag00 = g_aza.aza81  #No.FUN-730020
            #-----No.FUN-660073-----
            LET l_aag022 = ''
            SELECT aag02 INTO l_aag022 FROM aag_file
             WHERE aag01 = sr.azf07
               AND aag00 = g_aza.aza81  #No.FUN-730020
            LET l_aag023 = ''
            SELECT aag02 INTO l_aag023 FROM aag_file
             WHERE aag01 = sr.azf14
               AND aag00 = g_aza.aza81  #No.FUN-730020
            #-----No.FUN-660073 END-----
            IF sr.azfacti = 'N'  THEN 
               LET l_str = '* ',sr.azf01
            ELSE 
               LET l_str = '  ',sr.azf01
            END IF
            PRINT COLUMN g_c[31],l_str CLIPPED,
                  COLUMN g_c[32],sr.azf02 CLIPPED,l_desc CLIPPED,   #TQC-6B0023   
                  COLUMN g_c[33],sr.azf03;
            #No.FUN-6B0065 --begin
            CASE 
                 WHEN sr.azf09 = '1'
                      PRINT COLUMN g_c[41],g_x[46];
                 WHEN sr.azf09 = '2'
                      PRINT COLUMN g_c[41],g_x[47];
                 WHEN sr.azf09 = '3'
                      PRINT COLUMN g_c[41],g_x[48];
                 WHEN sr.azf09 = '4'
                      PRINT COLUMN g_c[41],g_x[49];
                 WHEN sr.azf09 = '5'
                      PRINT COLUMN g_c[41],g_x[50];
                 WHEN sr.azf09 = '6'
                      PRINT COLUMN g_c[41],g_x[51];
            END CASE
            PRINT COLUMN g_c[42],sr.azf10,
                  COLUMN g_c[43],sr.azf11,
                  COLUMN g_c[44],sr.azf12,
                  COLUMN g_c[45],sr.azf13;
            #No.FUN-6B0065 --end  
            PRINT COLUMN g_c[34],sr.azfacti;
        
            IF g_argv1 = 'G' THEN 
              #start FUN-650001 add
               CASE sr.azf06
                   WHEN 0
                      SELECT gae04 INTO l_gae04 FROM gae_file
                       WHERE gae01='aooi300' AND gae02='azf06_0' AND gae03=g_lang
                   WHEN 1
                      SELECT gae04 INTO l_gae04 FROM gae_file
                       WHERE gae01='aooi300' AND gae02='azf06_1' AND gae03=g_lang
                   WHEN 2
                      SELECT gae04 INTO l_gae04 FROM gae_file
                       WHERE gae01='aooi300' AND gae02='azf06_2' AND gae03=g_lang
                   WHEN 3
                      SELECT gae04 INTO l_gae04 FROM gae_file
                       WHERE gae01='aooi300' AND gae02='azf06_3' AND gae03=g_lang
               END CASE
               LET l_azf06 = sr.azf06
               LET l_msg = l_azf06 CLIPPED,':',l_gae04 CLIPPED
              #end FUN-650001 add
               PRINT COLUMN g_c[35],sr.azf05,
                     COLUMN g_c[36],l_aag02 CLIPPED,
                     COLUMN g_c[38],sr.azf07,   #No.FUN-660073
                     COLUMN g_c[39],l_aag022 CLIPPED,   #No.FUN-660073
                     COLUMN g_c[38],sr.azf14,   #No.FUN-660073
                     COLUMN g_c[39],l_aag023 CLIPPED,   #No.FUN-660073
                     COLUMN g_c[40],sr.azf08,   #No.FUN-660073
                     COLUMN g_c[37],l_msg CLIPPED  #FUN-650001 add
            ELSE
               PRINT ''
            END IF
 
        ON LAST ROW
            PRINT g_dash
           #PRINT '(' CLIPPED,g_tit CLIPPED,')' CLIPPED,g_x[5] CLIPPED, COLUMN g_c[35], g_x[7] CLIPPED
            PRINT '(' CLIPPED,g_tit CLIPPED,')' CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #TQC-5B0033
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
               #PRINT '(' CLIPPED,g_tit CLIPPED,')' CLIPPED,g_x[5] CLIPPED, COLUMN g_c[35], g_x[6] CLIPPED
                PRINT '(' CLIPPED,g_tit CLIPPED,')' CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0033
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}                                                                                                                                   
#No.FUN-850016  --END   
#No.MOD-B50073 --begin
#FUNCTION i300_azf07(p_cmd,p_bookno,p_aag01)
FUNCTION i300_azf14(p_cmd,p_bookno,p_aag01)    #No.TQC-B50094
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE p_bookno   LIKE aag_file.aag00
   DEFINE p_aag01    LIKE aag_file.aag02
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag21    LIKE aag_file.aag21
   DEFINE l_aag03    LIKE aag_file.aag03
   DEFINE l_aag07    LIKE aag_file.aag07

   LET g_errno = ' '
   IF p_cmd <>'7' THEN RETURN END IF
   IF cl_null(p_aag01) THEN RETURN END IF
   SELECT aagacti,aag21,aag03,aag07
     INTO l_aagacti,l_aag21,l_aag03,l_aag07
     FROM aag_file
    WHERE aag00 = p_bookno AND aag01 = p_aag01
   CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-001'
        WHEN l_aagacti='N'       LET g_errno='9028'
        WHEN l_aag03 <> '2'      LET g_errno='agl-201'
        WHEN l_aag07 = '1'       LET g_errno='agl-238'
#       WHEN l_aag21 <> 'Y'      LET g_errno='agl-924'   #FUN-D90021 mark
        WHEN l_aag21 <> 'Y' AND g_aza.aza26 <> '2' LET g_errno='agl-924'   #FUN-D90021 add
        OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE

END FUNCTION
#No.MOD-B50073 --end
