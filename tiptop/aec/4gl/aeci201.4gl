# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci201.4gl
# Descriptions...: 合拼版製程及料件維護作業
# Date & Author..: 08/01/11 By jan (FUN-A80054)
# Modify.........: No.FUN-A80060 10/09/28 By jan GP5.25工單間合拼
# Modify.........: No.FUN-AA0030 10/10/19 By jan 新增複製功能
# Modify.........: No.FUN-AAA059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.CHI-AC0037 10/12/31 By lixh1  控卡單身為回收料時,bmb06 可以為負,但不可為0
# Modify.........: No.TQC-B10216 11/01/20 By destiny orig,oriu新增时未付值
# Modify.........: No.TQC-B20161 11/02/23 By jan 製程序不須檢查是否存在于ecb_file
# Modify.........: No.FUN-B20080 11/02/25 By lixh1 aeci200串aeci201 時,新增時單頭def帶aeci200的資料,不提供輸入
# Modify.........: No.MOD-B30521 11/03/18 By lixh1 修改刪除時的BUG
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No:FUN-B90043 11/09/05 By lujh 程序撰寫規範修正
# MOdify.........: No:FUN-910088 11/12/19 By chenjing 增加數量欄位小數取位
# Modify.........: No.TQC-C30136 12/03/08 By xujing 處理ON ACITON衝突問題
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By lixiang 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_edc01         LIKE edc_file.edc01,   #合拼版號 (假單頭)
       g_edc02         LIKE edc_file.edc02,   #項次
       g_edcconf       LIKE edc_file.edcconf,
       g_edc01_t       LIKE edc_file.edc01, 
       g_edc02_t       LIKE edc_file.edc02,
       g_edc1           RECORD LIKE edc_file.*,
       b_edd           RECORD LIKE edd_file.*,
       g_edc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         edc03		     LIKE edc_file.edc03,  #製程序
         edc04		     LIKE edc_file.edc04,  #作業編號
         edc45		     LIKE edc_file.edc45,  #作業名稱
         edc06		     LIKE edc_file.edc06,  #生產站別
         eca02		     LIKE eca_file.eca02,  #站別說明
         edc14		     LIKE edc_file.edc14,  #標準工時
         edc13		     LIKE edc_file.edc13,  #固定工時
         edc16		     LIKE edc_file.edc16,  #標準機時
         edc15		     LIKE edc_file.edc15,  #固定機時
         edc49		     LIKE edc_file.edc49,  #製程人力
         edc05		     LIKE edc_file.edc05,  #機械編號
         edc66		     LIKE edc_file.edc66,  #報工點否
         edc52		     LIKE edc_file.edc52,  #委外否
         edc67               LIKE edc_file.edc67,  #委外廠商
         edc53		     LIKE edc_file.edc53,  #PQC否
         edc54		     LIKE edc_file.edc54,  #check in
         edc55         LIKE edc_file.edc55,  #Hold for check in
         edc56         LIKE edc_file.edc56,  #Hold for check out(報工)
         edc58         LIKE edc_file.edc58,
         edc62         LIKE edc_file.edc62,  #组成用量
         edc63         LIKE edc_file.edc63,  #底数
         edc65         LIKE edc_file.edc65,  #标准产出量
         edc12         LIKE edc_file.edc12,  #固定损耗量
         edc34         LIKE edc_file.edc34,  #变动损耗率
         edc64         LIKE edc_file.edc64   #损耗批量
                       END RECORD,
       g_edc_t         RECORD                 #程式變數 (舊值)
         edc03		     LIKE edc_file.edc03,  #製程序
         edc04		     LIKE edc_file.edc04,  #作業編號
         edc45		     LIKE edc_file.edc45,  #作業名稱
         edc06		     LIKE edc_file.edc06,  #生產站別
         eca02		     LIKE eca_file.eca02,  #站別說明
         edc14		     LIKE edc_file.edc14,  #標準工時
         edc13		     LIKE edc_file.edc13,  #固定工時
         edc16		     LIKE edc_file.edc16,  #標準機時
         edc15		     LIKE edc_file.edc15,  #固定機時
         edc49		     LIKE edc_file.edc49,  #製程人力
         edc05		     LIKE edc_file.edc05,  #機械編號
         edc66		     LIKE edc_file.edc66,  #報工點否
         edc52		     LIKE edc_file.edc52,  #委外否
         edc67               LIKE edc_file.edc67,  #委外廠商
         edc53		     LIKE edc_file.edc53,  #PQC否
         edc54		     LIKE edc_file.edc54,  #check in
         edc55         LIKE edc_file.edc55,  #Hold for check in
         edc56         LIKE edc_file.edc56,  #Hold for check out(報工)
         edc58         LIKE edc_file.edc58,
         edc62         LIKE edc_file.edc62,  #组成用量
         edc63         LIKE edc_file.edc63,  #底数
         edc65         LIKE edc_file.edc65,  #标准产出量
         edc12         LIKE edc_file.edc12,  #固定损耗量
         edc34         LIKE edc_file.edc34,  #变动损耗率
         edc64         LIKE edc_file.edc64   #损耗批量
                       END RECORD,
       g_edd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)    	              
         edd02         LIKE edd_file.edd02,   #元件項次
         edd30         LIKE edd_file.edd30,   #計算方式 
         edd03         LIKE edd_file.edd03,   #元件料件
         ima02_b       LIKE ima_file.ima02,   #品名
         ima021_b      LIKE ima_file.ima021,  #規格
         ima08_b       LIKE ima_file.ima08,   #來源
         edd09         LIKE edd_file.edd09,   #作業編號
         edd16         LIKE edd_file.edd16,   #UTE/SUB
         edd14         LIKE edd_file.edd14,   #Required/Optional
         edd04         LIKE edd_file.edd04,   #生效日
         edd05         LIKE edd_file.edd05,   #失效日
         edd06         LIKE edd_file.edd06,   #組成用量
         edd07         LIKE edd_file.edd07,   #底數
         edd10         LIKE edd_file.edd10,   #發料單位
         edd08         LIKE edd_file.edd08,   #損耗率
         edd081        LIKE edd_file.edd081,
         edd082        LIKE edd_file.edd082,
         edd19         LIKE edd_file.edd19,
         edd24         LIKE edd_file.edd24,    #工程變異單號
         edd13         LIKE edd_file.edd13,    #insert_loc
         edd31         LIKE edd_file.edd31     #代買料否 
                       END RECORD,
       g_edd_t         RECORD                 #程式變數 (舊值)
         edd02         LIKE edd_file.edd02,   #元件項次
         edd30         LIKE edd_file.edd30,   #計算方式 
         edd03         LIKE edd_file.edd03,   #元件料件
         ima02_b       LIKE ima_file.ima02,   #品名
         ima021_b      LIKE ima_file.ima021,  #規格
         ima08_b       LIKE ima_file.ima08,   #來源
         edd09         LIKE edd_file.edd09,   #作業編號
         edd16         LIKE edd_file.edd16,   #UTE/SUB
         edd14         LIKE edd_file.edd14,   #Required/Optional
         edd04         LIKE edd_file.edd04,   #生效日
         edd05         LIKE edd_file.edd05,   #失效日
         edd06         LIKE edd_file.edd06,   #組成用量
         edd07         LIKE edd_file.edd07,   #底數
         edd10         LIKE edd_file.edd10,   #發料單位
         edd08         LIKE edd_file.edd08,   #損耗率
         edd081        LIKE edd_file.edd081,
         edd082        LIKE edd_file.edd082,
         edd19         LIKE edd_file.edd19,
         edd24         LIKE edd_file.edd24,    #工程變異單號
         edd13         LIKE edd_file.edd13,    #insert_loc
         edd31         LIKE edd_file.edd31     #代買料否 
                       END RECORD,
       g_edd_o         RECORD                 #程式變數 (舊值)
         edd02         LIKE edd_file.edd02,   #元件項次
         edd30         LIKE edd_file.edd30,   #計算方式 
         edd03         LIKE edd_file.edd03,   #元件料件
         ima02_b       LIKE ima_file.ima02,   #品名
         ima021_b      LIKE ima_file.ima021,  #規格
         ima08_b       LIKE ima_file.ima08,   #來源
         edd09         LIKE edd_file.edd09,   #作業編號
         edd16         LIKE edd_file.edd16,   #UTE/SUB
         edd14         LIKE edd_file.edd14,   #Required/Optional
         edd04         LIKE edd_file.edd04,   #生效日
         edd05         LIKE edd_file.edd05,   #失效日
         edd06         LIKE edd_file.edd06,   #組成用量
         edd07         LIKE edd_file.edd07,   #底數
         edd10         LIKE edd_file.edd10,   #發料單位
         edd08         LIKE edd_file.edd08,   #損耗率
         edd081        LIKE edd_file.edd081,
         edd082        LIKE edd_file.edd082,
         edd19         LIKE edd_file.edd19,
         edd24         LIKE edd_file.edd24,    #工程變異單號
         edd13         LIKE edd_file.edd13,    #insert_loc
         edd31         LIKE edd_file.edd31     #代買料否 
                       END RECORD,
 
       g_ima08_h       LIKE ima_file.ima08,   #來源碼
       g_ima37_h       LIKE ima_file.ima37,   #補貨政策
       g_ima08_b       LIKE ima_file.ima08,   #來源碼
       g_ima37_b       LIKE ima_file.ima37,   #補貨政策
       g_ima25_b       LIKE ima_file.ima25,   #庫存單位
       g_ima63_b       LIKE ima_file.ima63,   #發料單位
       g_ima70_b       LIKE ima_file.ima63,   #消耗料件
       g_ima86_b       LIKE ima_file.ima86,   #成本單位
       g_ima107_b      LIKE ima_file.ima107,  #LOCATION 
       g_ima55         LIKE ima_file.ima55, 
       g_edd11         LIKE edd_file.edd11,
       g_edd15         LIKE edd_file.edd15,
       g_edd18         LIKE edd_file.edd18,
       g_edd17         LIKE edd_file.edd17,
       g_edd23         LIKE edd_file.edd23,
       g_edd27         LIKE edd_file.edd27,
       g_edd28         LIKE edd_file.edd28, 
       g_wc,g_wc2,g_sql,g_sql1      STRING,      
       g_rec_b,g_rec_b2       LIKE type_file.num5,                #單身筆數  
       l_sql           STRING,
       l_ac,l_ac2            LIKE type_file.num5                #目前處理的ARRAY CNT  
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt,g_cnt2    LIKE type_file.num10   
DEFINE g_msg           LIKE ze_file.ze03      
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10   
DEFINE g_jump          LIKE type_file.num10   
DEFINE g_no_ask        LIKE type_file.num5  
DEFINE g_edd10_fac     LIKE edd_file.edd10_fac
DEFINE g_edd10_fac2    LIKE edd_file.edd10_fac2
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_cott,g_sw     LIKE type_file.num5
DEFINE l_table         STRING
DEFINE g_str           STRING
DEFINE l_n3            LIKE type_file.num5
DEFINE g_argv1         LIKE edc_file.edc01
DEFINE g_argv2         LIKE edc_file.edc02
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_edd10_t       LIKE edd_file.edd10   #FUN-910088--add-  
DEFINE g_edc58_t       LIKE edc_file.edc58   #FUN-910088--add-
DEFINE g_flag_b        LIKE type_file.chr1   #TQC-D40025 add

MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF

   IF g_sma.sma541='N' OR cl_null(g_sma.sma541) THEN
      CALL cl_err('','aec-056',1)
      EXIT PROGRAM
   END IF

   LET g_sql="edc01.edc_file.edc01,", 
             "edc02.edc_file.edc02,",
             "edcconf.edc_file.edcconf,",
             "edc03.edc_file.edc03,",
             "edc04.edc_file.edc04,",
             "edc45.edc_file.edc45,",
             "edb07.edb_file.edb07,",
             "edd03.edd_file.edd03,",
             "edd04.edd_file.edd04,",
             "edd05.edd_file.edd05,",
             "edd06.edd_file.edd06,",
             "edd07.edd_file.edd07,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ima08.ima_file.ima08"
   LET l_table = cl_prt_temptable('aeci201',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_edc01= NULL                     #清除鍵值
   LET g_edc01_t = NULL
   LET g_edc02_t = NULL
 
   OPEN WINDOW i201_w WITH FORM "aec/42f/aeci201"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("edc66",g_sma.sma1431='Y')
   CALL cl_set_comp_visible("edc65,edd30,edd09",FALSE)
   CALL cl_set_comp_entry("edd14,edd16,edd19",FALSE)
   LET g_flag='N'
   LET g_argv1 = ARG_VAL(1) 
   LET g_argv2 = ARG_VAL(2)
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL i201_q()
   END IF
   CALL i201_menu()
   CLOSE WINDOW i201_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION i201_curs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM                             #清除畫面
   CALL g_edc.clear()
     IF cl_null(g_argv1) THEN
      DIALOG ATTRIBUTES(UNBUFFERED)
        CONSTRUCT g_wc ON edc01,edc02,edcconf,edcuser,edcmodu,edcacti,edcgrup,edcdate,
                          edc03,edc04,edc45,edc06,edc14,edc13,edc16,
                          edc15,edc49,edc05,edc66,edc52,edc67,edc53,edc54,edc55,
                          edc56,edc58,edc62,edc63,edc65,edc12,edc34,edc64
                     FROM edc01,edc02,edcconf,edcuser,edcmodu,edcacti,
                          edcgrup,edcdate,
                          s_edc[1].edc03,s_edc[1].edc04,s_edc[1].edc45,
                          s_edc[1].edc06,s_edc[1].edc14,s_edc[1].edc13,	
                          s_edc[1].edc16,s_edc[1].edc15,s_edc[1].edc49,
                          s_edc[1].edc05,s_edc[1].edc66,s_edc[1].edc52,s_edc[1].edc67,s_edc[1].edc53,	
                          s_edc[1].edc54,s_edc[1].edc55,s_edc[1].edc56,s_edc[1].edc58,s_edc[1].edc62,  
                          s_edc[1].edc63,s_edc[1].edc65,s_edc[1].edc12,s_edc[1].edc34,s_edc[1].edc64
                BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        END CONSTRUCT
      
        CONSTRUCT g_wc2 ON edd02,edd30,edd03,
                         edd16,edd14,edd04,edd05,edd06,edd07,
                         edd10,edd08,edd081,edd082,edd19,edd24,   
                         edd13,edd31              
                  FROM s_edd[1].edd02,s_edd[1].edd30,s_edd[1].edd03, 
                       s_edd[1].edd16,s_edd[1].edd14,s_edd[1].edd04,
                       s_edd[1].edd05,s_edd[1].edd06,s_edd[1].edd07,
                       s_edd[1].edd10,s_edd[1].edd08,s_edd[1].edd081,
                       s_edd[1].edd082,s_edd[1].edd19,s_edd[1].edd24,
                       s_edd[1].edd13,s_edd[1].edd31
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)  
         END CONSTRUCT
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(edc01)     
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_edc01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edc01
                     NEXT FIELD edc01
                 WHEN INFIELD(edc05)                 #機械編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_eci"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edc05
                      NEXT FIELD edc05
                 WHEN INFIELD(edc06)                 #生產站別
                      CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edc06
                      NEXT FIELD edc06
                 WHEN INFIELD(edc04)                 #作業編號
                      CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edc04
                      NEXT FIELD edc04
                 WHEN INFIELD(edc55)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sgg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edc55
                      NEXT FIELD edc55
                 WHEN INFIELD(edc56)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sgg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edc56
                      NEXT FIELD edc56
                 WHEN INFIELD(edc58)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_gfe"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edc58
                      NEXT FIELD edc58
                 WHEN INFIELD(edc67) #廠商編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_pmc"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret 
                      DISPLAY g_qryparam.multiret TO edc67 
                      NEXT FIELD edc67
                 WHEN INFIELD(edd03) #料件主檔
#FUN-AA0059 --Begin--
                 #     CALL cl_init_qry_var()
                 #     LET g_qryparam.form = "q_ima"
                 #     LET g_qryparam.state = 'c'
                 #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                      DISPLAY g_qryparam.multiret TO edd03
                      NEXT FIELD edd03
                 WHEN INFIELD(edd10) #單位檔
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gfe"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edd10
                      NEXT FIELD edd10
                OTHERWISE EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
            
         ON ACTION accept
            ACCEPT DIALOG

        ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG
      END DIALOG
     ELSE
        LET g_wc = " edc01='",g_argv1,"' AND edc02='",g_argv2,"'"
        LET g_wc2=' 1=1'
     END IF
      
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
      IF g_wc2 = ' 1=1' OR cl_null(g_wc2) THEN
         LET g_sql= "SELECT UNIQUE edc01,edc02 FROM edc_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY edc01,edc02"
      ELSE
         LET g_sql= "SELECT UNIQUE edc01,edc02 FROM edc_file,edd_file ",
                    " WHERE edc01=edd01 ",
                    "   AND edc02=edd011 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED,
                    " ORDER BY edc01,edc02"
      END IF
      PREPARE i201_prepare FROM g_sql      #預備一下
      DECLARE i201_b_curs                  #宣告成可捲動的
          SCROLL CURSOR WITH HOLD FOR i201_prepare
      
      IF g_wc2 = ' 1=1' OR cl_null(g_wc2) THEN
         LET g_sql1= "SELECT UNIQUE edc01,edc02 FROM edc_file ",
                    " WHERE ", g_wc CLIPPED,
                    "INTO TEMP x "
      ELSE
         LET g_sql1= "SELECT UNIQUE edc01,edc02 FROM edc_file,edd_file ",
                    " WHERE edc01=edd01 ",
                    "   AND edc02=edd011 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED,
                    "INTO TEMP x "
      END IF
      DROP TABLE x
      PREPARE i201_precount_x FROM g_sql1
      EXECUTE i201_precount_x
      LET g_sql="SELECT COUNT(*) FROM x"
      PREPARE i201_precount FROM g_sql
      DECLARE i201_count CURSOR FOR i201_precount
 
END FUNCTION
 
FUNCTION i201_menu()
DEFINE l_cmd LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i201_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i201_r()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i201_out()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-AA0030--begin--add------
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i201_copy()
            END IF
         #FUN-AA0030--end--add------
         WHEN "next"
            IF cl_chk_act_auth() THEN
               CALL i201_fetch('N')
            END IF
         WHEN "previous"
            IF cl_chk_act_auth() THEN
               CALL i201_fetch('P')
            END IF
         WHEN "jump"
            IF cl_chk_act_auth() THEN
               CALL i201_fetch('/')
            END IF
         WHEN "first"
            IF cl_chk_act_auth() THEN
               CALL i201_fetch('F')
            END IF
         WHEN "last"
            IF cl_chk_act_auth() THEN
               CALL i201_fetch('L')
            END IF
        #@WHEN "取消確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i201_y()
               CALL i201_show()
            END IF
        #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i201_z()
               CALL i201_show()
            END IF
        #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i201_x()    #CHI-D20010
               CALL i201_x(1)   #CHI-D20010 
               CALL i201_show()
            END IF
        #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL i201_x()    #CHI-D20010
               CALL i201_x(2)   #CHI-D20010
               CALL i201_show()
            END IF
       #CHI-D20010---end
        #@WHEN "明細單身"
         WHEN "contents"
            IF cl_chk_act_auth() THEN 
             IF l_ac >0 AND l_ac2 > 0 THEN
               LET l_cmd = "aeci202 "," '",g_edc01,"'",
                           " '",g_edc02,"' '",g_edc[l_ac].edc03,"' ",
                           " '",g_edd[l_ac2].edd03,"' "
               CALL cl_cmdrun(l_cmd)
               CALL i201_show()
              #CALL i201_b_fill_2(g_edc[l_ac].edc03)                                                                       
              #CALL i201_bp_refresh()
             END IF                                                                                                                 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_edc),'','')
            END IF
  
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                IF g_edc01 IS NOT NULL THEN
                 LET g_doc.column1 = "edc01"
                 LET g_doc.value1 = g_edc01
                 CALL cl_doc()
                END IF 
              END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i201_a()
 
   MESSAGE ""
   CLEAR FORM
   LET g_edc01=''
   LET g_edc02=''
   CALL g_edc.clear()
   INITIALIZE g_edc01 LIKE edc_file.edc01
   INITIALIZE g_edc02 LIKE edc_file.edc02
   LET g_edc01_t = NULL
   LET g_edc02_t = NULL
   LET g_edcconf = 'N'
   LET g_edc1.edcacti = 'Y'
   LET g_edc1.edcuser = g_user
   LET g_edc1.edcgrup = g_grup
   LET g_edc1.edcdate = TODAY
   LET g_edc1.edcoriu = g_user  #TQC-B10216 
   LET g_edc1.edcorig = g_grup  #TQC-B10216 
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i201_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_edc01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      CALL g_edc.clear()
 
      LET g_rec_b=0   LET g_rec_b2=0
      DISPLAY g_rec_b TO FORMONLY.cn2
      DISPLAY g_rec_b2 TO FORMONLY.cn3
      CALL i201_b()                   #輸入單身
 
      LET g_edc01_t = g_edc01            #保留舊值
      LET g_edc02_t = g_edc02
      EXIT WHILE
   END WHILE
 
END FUNCTION
  
FUNCTION i201_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改  
       l_n             LIKE type_file.num5,                  #檢查重復用
       l_n1            LIKE type_file.num5                   #檢查重復用
       
 
   CALL cl_set_head_visible("","YES")           
   DISPLAY g_edcconf TO edcconf
   DISPLAY BY NAME g_edc1.edcuser,g_edc1.edcgrup,g_edc1.edcdate,g_edc1.edcacti,g_edc1.edcoriu,g_edc1.edcorig #TQC-B10216
   INPUT g_edc01,g_edc02 WITHOUT DEFAULTS FROM edc01,edc02
 
      AFTER FIELD edc01                      
         IF NOT cl_null(g_edc01) THEN
            LET l_n = 0
            IF NOT cl_null(g_edc02) THEN
               SELECT count(*) INTO l_n FROM edb_file,eda_file
                WHERE edb01=g_edc01
                  AND edb02=g_edc02
                  AND eda01=edb01
                  AND edaconf='Y'
            ELSE
                SELECT count(*) INTO l_n FROM eda_file
                 WHERE eda01 = g_edc01
                   AND edaconf = 'Y'
            END IF
            IF l_n = 0 THEN
               CALL cl_err(g_edc01,'aec-057',1)
               NEXT FIELD edc01
            END IF
            CALL i201_chk_edc(g_edc01,g_edc02)
            IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,1) NEXT FIELD edc01 END IF
         END IF
 
     AFTER FIELD edc02
      IF NOT cl_null(g_edc02) THEN
         LET l_n = 0
         SELECT count(*) INTO l_n FROM edb_file,eda_file
          WHERE edb01=g_edc01
            AND edb02=g_edc02
            AND eda01=edb01
            AND edaconf='Y'
         IF l_n = 0 THEN
            CALL cl_err(g_edc01,'aec-058',1)
            NEXT FIELD edc02
         END IF
         CALL i201_chk_edc(g_edc01,g_edc02)
         IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,1) NEXT FIELD edc02 END IF
      END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(edc01) OR INFIELD(edc02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_edc"
               LET g_qryparam.default1 = g_edc01
               LET g_qryparam.default2 = g_edc02
               CALL cl_create_qry() RETURNING g_edc01,g_edc02
               DISPLAY g_edc01 TO edc01
               DISPLAY g_edc02 TO edc02
               NEXT FIELD CURRENT
            OTHERWISE EXIT CASE
         END CASE
 
 
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
 
END FUNCTION

FUNCTION i201_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i201_curs()                    #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_edc01 TO NULL
      RETURN
   END IF
 
   OPEN i201_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_edc01 TO NULL
   ELSE
      OPEN i201_count
      FETCH i201_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i201_fetch('F')            #讀出TEMP第一筆並顯示
#MOD-B30521 -------------------Begin--------------------
      IF NOT cl_null(g_argv1) AND cl_null(g_edc01) THEN
         LET g_edc01= g_argv1
         LET g_edc02= g_argv2
         LET g_edcconf = 'N'
         DISPLAY g_edc01 TO edc01
         DISPLAY g_edc02 TO edc02
         DISPLAY g_edcconf TO edcconf
      END IF 
#MOD-B30521 -------------------End----------------------
   END IF
 
END FUNCTION
 
FUNCTION i201_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i201_b_curs INTO g_edc01,g_edc02
       WHEN 'P' FETCH PREVIOUS i201_b_curs INTO g_edc01,g_edc02
       WHEN 'F' FETCH FIRST    i201_b_curs INTO g_edc01,g_edc02
       WHEN 'L' FETCH LAST     i201_b_curs INTO g_edc01,g_edc02
       WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                    CONTINUE PROMPT
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
 
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
 
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i201_b_curs INTO g_edc01,g_edc02
           LET g_no_ask = FALSE
   END CASE
 
#FUN-BN20080 ----------------------------Begin-----------------------------
   IF SQLCA.sqlcode THEN                         #有麻煩  #MOD-B30521 remark
      CALL cl_err(g_edc01,SQLCA.sqlcode,0)                #MOD-B30521 remark          
      INITIALIZE g_edc01 TO NULL                          #MOD-B30521 remark
#MOD-B30521 -------------Begin------------------
#   IF SQLCA.sqlcode = 100 THEN 
#      IF NOT cl_null(g_argv1) THEN 
#         LET g_edc01= g_argv1
#         LET g_edc02= g_argv2
#         LET g_edcconf = 'N'
#      END IF
#      DISPLAY g_edc01 TO edc01
#      DISPLAY g_edc02 TO edc02
#      DISPLAY g_edcconf TO edcconf 
#      CALL i201_bp("G")  
#MOD-B30521 -------------End--------------------
#FUN-BN20080 ----------------------------End-------------------------------
   ELSE
      CALL i201_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION i201_show()
 
   SELECT DISTINCT edc01,edc02,edcconf,edcorig,edcoriu,edcuser,
                   edcgrup,edcmodu,edcdate,edcacti
     INTO g_edc01,g_edc02,g_edcconf,g_edc1.edcorig,g_edc1.edcoriu,
          g_edc1.edcuser,g_edc1.edcgrup,g_edc1.edcmodu,g_edc1.edcdate,g_edc1.edcacti
     FROM edc_file
    WHERE edc01=g_edc01
      AND edc02=g_edc02
   IF SQLCA.sqlcode THEN 
      LET g_edc01=NULL
      LET g_edc02=NULL LET g_edcconf=NULL
      INITIALIZE g_edc1.* TO NULL
   END IF
   DISPLAY g_edc01 TO edc01               #單頭
   DISPLAY g_edc02 TO edc02
   DISPLAY g_edcconf TO edcconf
   DISPLAY BY NAME g_edc1.edcorig,g_edc1.edcoriu,
                   g_edc1.edcuser,g_edc1.edcgrup,g_edc1.edcmodu,g_edc1.edcdate,g_edc1.edcacti
   CALL i201_b_fill(g_wc)                 #單身
   IF g_edc[1].edc03 > 0 THEN
      CALL i201_b_fill_2(g_edc[1].edc03)
   END IF
   CALL i201_show_pic()
   CALL cl_show_fld_cont()                   
 
END FUNCTION
 
FUNCTION i201_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_edc01 IS NULL THEN
      CALL cl_err("",-400,0)                 
      RETURN
   END IF

   IF g_edcconf MATCHES '[YX]' THEN CALL cl_err('','alm-639',1) RETURN END IF

   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL 
       LET g_doc.column1 = "edc01" 
       LET g_doc.value1 = g_edc01
       CALL cl_del_doc() 
      DELETE FROM edc_file WHERE edc01 = g_edc01
                             AND edc02 = g_edc02
      DELETE FROM edd_file WHERE edd01 = g_edc01
                             AND edd011= g_edc02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","edd_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_edc.clear()
         CALL g_edd.clear()
         OPEN i201_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i201_b_curs
             CLOSE i201_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i201_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i201_b_curs
             CLOSE i201_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i201_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i201_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i201_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i201_b()
DEFINE l_ac_t,l_ac2_t  LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n,l_n2,l_i    LIKE type_file.num5,                #檢查重複用  
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_cmd           LIKE type_file.chr1000,             #可新增否  
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE l_flag          LIKE type_file.chr1   
DEFINE l_edcacti       LIKE edc_file.edcacti 
DEFINE l_buf           LIKE type_file.chr50
DEFINE l_tf            LIKE type_file.chr1                 #FUN-910088--add--
DEFINE l_tf1           LIKE type_file.chr1                 #FUN-910088--add--
DEFINE l_act_controls  LIKE type_file.chr1                 #TQC-C30136

 
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_edc01 IS NULL THEN RETURN END IF
   IF g_edcconf MATCHES '[YX]' THEN CALL cl_err('','alm-638',1) RETURN END IF
   SELECT ima55 INTO g_ima55 FROM ima_file,edb_file
    WHERE edb01=g_edc01 AND edb02=g_edc02
      AND edb03=ima01
   CALL cl_opmsg('b')
   LET g_forupd_sql =
        "SELECT edc03,edc04,edc45,edc06,'',edc14,edc13,edc16,edc15,", 
        "       edc49,edc05,edc66,edc52,edc67,edc53,edc54,edc55,",
        "       edc56,edc58,edc62,edc63,edc65,edc12,edc34,edc64 FROM edc_file ", 
        " WHERE edc01 = ? AND edc02 = ? AND edc03 = ? FOR UPDATE" 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_edc_bcl CURSOR FROM g_forupd_sql
   
   LET g_forupd_sql = "SELECT * FROM edd_file ",
      "   WHERE edd01=?  AND edd011=? AND edd013=? ", 
      "     AND edd02=?  AND edd03 =? AND edd04 =? ",
      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_edd_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_flag = 'N'
   WHILE TRUE
   
   IF g_rec_b > 0 THEN LET l_ac = 1 END IF    #TQC-D40025 add
   IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF  #TQC-D40025 add
 
   DIALOG ATTRIBUTES(UNBUFFERED)
    INPUT ARRAY g_edc FROM s_edc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        LET l_act_controls = TRUE  #TQC-C30136
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(l_ac)
        END IF
        LET g_flag_b = '1'  #TQC-D40025 add
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = DIALOG.getCurrentRow("s_edc") 
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_edc_t.* = g_edc[l_ac].*  #BACKUP
            LET g_edc58_t = g_edc[l_ac].edc58     #FUN-910088--add--
            LET l_sql = "SELECT edc01,edc02,edc03 FROM edc_file",
                        " WHERE edc01 = '",g_edc01,"' ",
                        "   AND edc02 = '",g_edc02,"' ",
                        "   AND edc03 = '",g_edc_t.edc03,"' "
            PREPARE i201_prepare_r FROM l_sql
            EXECUTE i201_prepare_r INTO g_edc01,g_edc02,g_edc[l_ac].edc03
            OPEN i201_edc_bcl USING g_edc01,g_edc02,g_edc[l_ac].edc03
            IF STATUS THEN
               CALL cl_err("OPEN i201_edc_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i201_edc_bcl INTO g_edc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_edc02_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i201_edc06('d')
                  CALL i201_b_fill_2(g_edc[l_ac].edc03)
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
         CALL i201_b_set_entry()
         CALL i201_b_set_no_entry(p_cmd)
         IF g_sma.sma901 = 'Y' THEN
            CALL i201_set_entry_b(p_cmd)
            CALL i201_set_no_entry_b(p_cmd)
         END IF
        
     BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            CALL g_edd.clear()
            INITIALIZE g_edc[l_ac].* TO NULL 
            LET g_edc[l_ac].edc14 = 0
            LET g_edc[l_ac].edc13 = 0
            LET g_edc[l_ac].edc16 = 0
            LET g_edc[l_ac].edc15 = 0
            LET g_edc[l_ac].edc49 = 0
            LET g_edc[l_ac].edc52 = 'N'
            LET g_edc[l_ac].edc53 = 'N'
            LET g_edc[l_ac].edc54 = 'N'
            LET g_edc[l_ac].edc62 = 1
            LET g_edc[l_ac].edc63 = 1
            LET g_edc[l_ac].edc65 = 0
            LET g_edc[l_ac].edc12 = 0
            LET g_edc[l_ac].edc34 = 0
            LET g_edc[l_ac].edc64 = 1
            LET g_edc[l_ac].edc66 = 'Y'
            LET g_edc[l_ac].edc58=g_ima55
            LET g_edc_t.* = g_edc[l_ac].*         #新輸入資料
            LET g_edc58_t = g_edc[l_ac].edc58     #FUN-910088--add--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD edc03

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            IF cl_null(g_edc[l_ac].edc66) THEN
               LET g_edc[l_ac].edc66 = 'Y'
            END IF
            IF cl_null(g_edc[l_ac].edc52) THEN
               LET g_edc[l_ac].edc52 = 'N'
            END IF
            IF cl_null(g_edc[l_ac].edc53) THEN
               LET g_edc[l_ac].edc53 = 'N'
            END IF
            IF cl_null(g_edc[l_ac].edc54) THEN
               LET g_edc[l_ac].edc54 = 'N'
            END IF
            DISPLAY "g_edc[l_ac].edc58=",g_edc[l_ac].edc58
            CALL i201_edc_init()
            INSERT INTO edc_file VALUES (g_edc1.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","edc_file",g_edc01,g_edc[l_ac].edc03,SQLCA.sqlcode,"","ins edc:",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE FIELD edc03                        #default 序號
            IF g_edc[l_ac].edc03 IS NULL OR
               g_edc[l_ac].edc03 = 0 THEN
               SELECT max(edc03) INTO g_edc[l_ac].edc03 FROM edc_file
                WHERE edc01 = g_edc01
                  AND edc02 = g_edc02
                IF cl_null(g_edc[l_ac].edc03) THEN
                   LET g_edc[l_ac].edc03 = 0
                END IF
                LET g_edc[l_ac].edc03 = g_edc[l_ac].edc03 + g_sma.sma849
            END IF
	
        AFTER FIELD edc03
            LET l_tf = NULL    #FUN-910088--add--
            IF NOT cl_null(g_edc[l_ac].edc03) THEN
              IF g_edc[l_ac].edc03 != g_edc_t.edc03 OR 
                 g_edc_t.edc03  IS NULL OR g_flag='Y' THEN
                 IF g_edc[l_ac].edc03 != g_edc_t.edc03 OR g_edc_t.edc03  IS NULL THEN
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM edc_file
                    WHERE edc03 = g_edc[l_ac].edc03
                      AND edc02= g_edc02
                      AND edc01 = g_edc01
                   IF l_n > 0 THEN 
                      CALL cl_err('',-239,0)
                      NEXT FIELD edc03
                   END IF
                  END IF
                  #TQC-B20161--begin--mark----
                  #SELECT COUNT(*) INTO l_n FROM edb_file,ecb_file
                  # WHERE edb01=g_edc01  AND edb02=g_edc02
                  #   AND edb03=ecb01 AND edb04=ecb02 AND edb07=ecb012
                  #   AND ecb03=g_edc[l_ac].edc03
                  #IF l_n = 0 THEN CALL cl_err('','aec-301',0) NEXT FIELD edc03 END IF
                  #TQC-B20161--end--mark-------
                   SELECT edc58
                     INTO g_edc[l_ac].edc58
                     FROM edc_file
                    WHERE edc01=g_edc01 AND edc02=g_edc02 AND edc03=g_edc[l_ac].edc03
                   IF cl_null(g_edc[l_ac].edc58) THEN
                      LET g_edc[l_ac].edc58=g_ima55
                   #FUN-910088--add--start--
                      CALL i201_edc12_check() RETURNING l_tf
                      LET g_edc58_t = g_edc[l_ac].edc58
                   #FUN-910088--add--end--
                   END IF
              END IF
            #FUN-910088--add--start--
              IF NOT cl_null(l_tf) AND NOT l_tf THEN 
                 NEXT FIELD edc12
              END IF
            #FUN-910088--add--end--
            END IF

        AFTER FIELD edc62
            IF NOT cl_null(g_edc[l_ac].edc62) THEN
               IF g_edc[l_ac].edc62 <= 0 THEN
                  CALL cl_err(g_edc[l_ac].edc62,'axr-034',0)
                  NEXT FIELD edc62
               END IF
            END IF

        AFTER FIELD edc63
            IF NOT cl_null(g_edc[l_ac].edc63) THEN
               IF g_edc[l_ac].edc63 <= 0 THEN
                  CALL cl_err(g_edc[l_ac].edc63,'axr-034',0)
                  NEXT FIELD edc63
               END IF
            END IF

        AFTER FIELD edc64
            IF NOT cl_null(g_edc[l_ac].edc64) THEN
               IF g_edc[l_ac].edc64 <= 0 THEN
                  CALL cl_err(g_edc[l_ac].edc64,'axr-034',0)
                  NEXT FIELD edc64
               END IF
            END IF

        AFTER FIELD edc12
            IF NOT i201_edc12_check() THEN NEXT FIELD edc12 END IF   #FUN-910088--add--
         #FUN-910088--mark--start--
         #  IF NOT cl_null(g_edc[l_ac].edc12) THEN
         #     IF g_edc[l_ac].edc12 < 0 THEN
         #        CALL cl_err(g_edc[l_ac].edc12,'axm-179',0)
         #        NEXT FIELD edc12
         #     END IF
         #  END IF
         #FUN-910088--mark--end--

        AFTER FIELD edc34
            IF NOT cl_null(g_edc[l_ac].edc34) THEN
               IF g_edc[l_ac].edc34 < 0 THEN
                  CALL cl_err(g_edc[l_ac].edc34,'axm-179',0)
                  NEXT FIELD edc34
               END IF
            END IF

        AFTER FIELD edc04
            IF NOT cl_null(g_edc[l_ac].edc04) THEN
               CALL i201_edc04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD edc04
               END IF
            END IF            

        AFTER FIELD edc06    
            IF NOT cl_null(g_edc[l_ac].edc06) THEN
               CALL i201_edc06('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_edc[l_ac].edc06 = g_edc_t.edc06
                  NEXT FIELD edc06
                  DISPLAY BY NAME g_edc[l_ac].edc06
               END IF
            END IF

        AFTER FIELD edc14
            IF g_edc[l_ac].edc14<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edc14
            END IF

        AFTER FIELD edc13
            IF g_edc[l_ac].edc13<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edc13
            END IF

        AFTER FIELD edc16
            IF g_edc[l_ac].edc16<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edc16
            END IF

        AFTER FIELD edc15
            IF g_edc[l_ac].edc15<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edc15
            END IF
        AFTER FIELD edc49
            IF g_edc[l_ac].edc49<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edc49
            END IF

        AFTER FIELD edc05
            IF NOT cl_null(g_edc[l_ac].edc05) THEN
               SELECT COUNT(*) INTO g_cott FROM eci_file
                WHERE eci01 = g_edc[l_ac].edc05
               IF g_cott IS NULL OR g_cott = 0  THEN
                  CALL cl_err('','aec-011',0)
                  LET g_edc[l_ac].edc05 = g_edc_t.edc05
                  NEXT FIELD edc05
                  DISPLAY BY NAME g_edc[l_ac].edc05
               END IF
            END IF

        AFTER FIELD edc66
            IF NOT cl_null(g_edc[l_ac].edc66) THEN
               IF g_edc[l_ac].edc66 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edc66
               END IF
            END IF
            
        AFTER FIELD edc52
            IF NOT cl_null(g_edc[l_ac].edc52) THEN
               IF g_edc[l_ac].edc52 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edc52
               END IF
            END IF

        AFTER FIELD edc67 
            IF NOT cl_null(g_edc[l_ac].edc67) THEN
               CALL i201_edc67()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edc[l_ac].edc67,g_errno,0)
                  NEXT FIELD edc67
               END IF
            END IF

        AFTER FIELD edc53
            IF NOT cl_null(g_edc[l_ac].edc53) THEN
               IF g_edc[l_ac].edc53 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edc53
               END IF
            END IF

        BEFORE FIELD edc54
            CALL i201_set_entry_b(p_cmd)

        AFTER FIELD edc54
            IF NOT cl_null(g_edc[l_ac].edc54) THEN
               IF g_edc[l_ac].edc54 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edc54
               END IF

               IF g_edc[l_ac].edc54 ='N' THEN
                  LET g_edc[l_ac].edc55 = ' '
                  DISPLAY BY NAME g_edc[l_ac].edc55
               END IF

               CALL i201_set_no_entry_b(p_cmd)

            END IF

        AFTER FIELD edc55
            IF NOT cl_null(g_edc[l_ac].edc55) THEN
               CALL i201_sgg(g_edc[l_ac].edc55)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_edc[l_ac].edc55=g_edc_t.edc55
                  NEXT FIELD edc55
                  DISPLAY BY NAME g_edc[l_ac].edc55
               END IF
            END IF

        AFTER FIELD edc56
            IF NOT cl_null(g_edc[l_ac].edc56) THEN
               CALL i201_sgg(g_edc[l_ac].edc56)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_edc[l_ac].edc56=g_edc_t.edc56
                  NEXT FIELD edc56
                  DISPLAY BY NAME g_edc[l_ac].edc56
               END IF
            END IF

        AFTER FIELD edc58
            IF NOT cl_null(g_edc[l_ac].edc58) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_edc[l_ac].edc58
               IF g_cnt=0 THEN
                  CALL cl_err(g_edc[l_ac].edc58,'mfg2605',0)
                  NEXT FIELD g_edc58
               END IF
            #FUN-910088--add--start--
               IF NOT i201_edc12_check() THEN
                  LET g_edc58_t = g_edc[l_ac].edc58
                  NEXT FIELD edc12
               END IF
               LET g_edc58_t = g_edc[l_ac].edc58
            #FUN-910088--add--end--
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_edc_t.edc03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF

               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM edc_file
                WHERE edc01 = g_edc01
                  AND edc02 = g_edc02
                  AND edc03 = g_edc_t.edc03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","edc_file",g_edc01,g_edc02,SQLCA.sqlcode,"","",1) 
                     ROLLBACK WORK
                     CANCEL DELETE
                  ELSE
                     DELETE FROM edd_file
                      WHERE edd01=g_edc01 
                        AND edd011=g_edc02
                        AND edd013=g_edc_t.edc03
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","edd_file",g_edc01,g_edc02,SQLCA.sqlcode,"","",1) 
                        ROLLBACK WORK
                        CANCEL DELETE
                     ELSE
                        LET g_rec_b=g_rec_b-1
                        DISPLAY g_rec_b TO FORMONLY.cn2
                        LET g_rec_b2=0
                        DISPLAY g_rec_b2 TO FORMONLY.cn3
                        COMMIT WORK
                     END IF
                  END IF
            END IF


        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_edc[l_ac].* = g_edc_t.*
               CLOSE i201_edc_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF

            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_edc[l_ac].edc03,-263,1)
               LET g_edc[l_ac].* = g_edc_t.*
            ELSE

               IF cl_null(g_edc[l_ac].edc66) THEN
                  LET g_edc[l_ac].edc66 = 'Y'
               END IF
               IF cl_null(g_edc[l_ac].edc52) THEN
                  LET g_edc[l_ac].edc52 = 'N'
               END IF
               IF cl_null(g_edc[l_ac].edc53) THEN
                  LET g_edc[l_ac].edc53 = 'N'
               END IF
               IF cl_null(g_edc[l_ac].edc54) THEN
                  LET g_edc[l_ac].edc54 = 'N'
               END IF

               UPDATE edc_file SET edc03=g_edc[l_ac].edc03,
                                   edc04=g_edc[l_ac].edc04,
                                   edc45=g_edc[l_ac].edc45,
                                   edc06=g_edc[l_ac].edc06,
                                   edc14=g_edc[l_ac].edc14,
                                   edc13=g_edc[l_ac].edc13,
                                   edc16=g_edc[l_ac].edc16,
                                   edc15=g_edc[l_ac].edc15,
                                   edc49=g_edc[l_ac].edc49,
                                   edc05=g_edc[l_ac].edc05,
                                   edc66=g_edc[l_ac].edc66,
                                   edc52=g_edc[l_ac].edc52,
                                   edc67=g_edc[l_ac].edc67,
                                   edc53=g_edc[l_ac].edc53,
                                   edc54=g_edc[l_ac].edc54,
                                   edc55=g_edc[l_ac].edc55,
                                   edc56=g_edc[l_ac].edc56,
                                   edc58=g_edc[l_ac].edc58,
                                   edc62 =g_edc[l_ac].edc62,
                                   edc63 =g_edc[l_ac].edc63,
                                   edc65 =g_edc[l_ac].edc65,
                                   edc12 =g_edc[l_ac].edc12,
                                   edc34 =g_edc[l_ac].edc34,
                                   edc64 =g_edc[l_ac].edc64
                WHERE edc01=g_edc01
                  AND edc02=g_edc02
                  AND edc03=g_edc_t.edc03

               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","edc_file",g_edc01,g_edc_t.edc03,SQLCA.sqlcode,"","",1) 
                  LET g_edc[l_ac].* = g_edc_t.*
               ELSE 
                  UPDATE edc_file SET edcmodu=g_user,edcdate=g_today
                   WHERE edc01=g_edc01 AND edc02=g_edc02
                  #FUN-A80060--begin--add----------------------
                  IF g_edc[l_ac].edc04 <> g_edc_t.edc04 THEN
                     UPDATE edd_file SET edd09=g_edc[l_ac].edc04
                      WHERE edd01=g_edc01 AND edd011=g_edc02 AND edd013=g_edc_t.edc03
                  END IF
                  #FUN-A80060--end--add-----------------------
               END IF
              
            END IF

        AFTER ROW
            LET l_ac = DIALOG.getCurrentRow("s_edc")
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_edc[l_ac].* = g_edc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_edc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i201_edc_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i201_edc_bcl
            COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(edc05)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.default1 = g_edc[l_ac].edc05
                   CALL cl_create_qry() RETURNING g_edc[l_ac].edc05
                    DISPLAY BY NAME g_edc[l_ac].edc05 
                   NEXT FIELD edc05
              WHEN INFIELD(edc06)                 #生產站別
                   CALL q_eca(FALSE,TRUE,g_edc[l_ac].edc06) RETURNING g_edc[l_ac].edc06
                    DISPLAY BY NAME g_edc[l_ac].edc06 
                   NEXT FIELD edc06
              WHEN INFIELD(edc04)                 #作業編號
                   CALL q_ecd(FALSE,TRUE,g_edc[l_ac].edc04) RETURNING g_edc[l_ac].edc04
                   DISPLAY BY NAME g_edc[l_ac].edc04 
                   NEXT FIELD edc04
              WHEN INFIELD(edc55)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_edc[l_ac].edc55
                   CALL cl_create_qry() RETURNING g_edc[l_ac].edc55
                    DISPLAY BY NAME g_edc[l_ac].edc55 
                   NEXT FIELD edc55
              WHEN INFIELD(edc56)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_edc[l_ac].edc56
                   CALL cl_create_qry() RETURNING g_edc[l_ac].edc56
                    DISPLAY BY NAME g_edc[l_ac].edc56
                   NEXT FIELD edc56
              WHEN INFIELD(edc58)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_edc[l_ac].edc58
                   CALL cl_create_qry() RETURNING g_edc[l_ac].edc58
                   DISPLAY BY NAME g_edc[l_ac].edc58
                   NEXT FIELD edc58
              WHEN INFIELD(edc67) #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_edc[l_ac].edc67
                 CALL cl_create_qry() RETURNING g_edc[l_ac].edc67
                 DISPLAY g_edc[l_ac].edc67 TO s_edc[l_ac].edc67
                 NEXT FIELD edc67 
           END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(edc03) AND l_ac > 1 THEN
                LET g_edc[l_ac].* = g_edc[l_ac-1].*
                NEXT FIELD edc03
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

       # ON ACTION CONTROLG       #TQC-C30136
       #     CALL cl_cmdask()     #TQC-C30136


        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      #ON ACTION controls                        #TQC-C30136
      #   CALL cl_set_head_visible("","AUTO")    #TQC-C30136

    END INPUT

    INPUT ARRAY g_edd FROM s_edd.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM edc_file WHERE edc01=g_edc01 AND edc02=g_edc02
               AND edc03=g_edc[l_ac].edc03
            IF l_cnt=0 THEN LET l_flag = 'Y' EXIT DIALOG END IF
            CALL i201_b_fill_2(g_edc[l_ac].edc03)
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            LET l_act_controls = FALSE    #TQC-C30136
            LET g_flag_b = '2'  #TQC-D40025 add

        BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = DIALOG.getCurrentRow("s_edd")
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n2  = ARR_COUNT()
            IF g_rec_b2 >= l_ac2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_edd_t.* = g_edd[l_ac2].*  #BACKUP
               LET g_edd_o.* = g_edd[l_ac2].*
               LET g_edd10_t = g_edd[l_ac2].edd10   #FUN-910088--add--
                OPEN i201_edd_bcl USING g_edc01,g_edc02,g_edc[l_ac].edc03,g_edd_t.edd02,g_edd_t.edd03,g_edd_t.edd04 
                IF STATUS THEN
                    CALL cl_err("OPEN i201_edd_bcl:", STATUS, 1)
                ELSE
                    FETCH i201_edd_bcl INTO b_edd.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_edd_t.edd02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i201_b_move_to()
                    END IF
                    SELECT ima02,ima021,ima08 INTO g_edd[l_ac2].ima02_b,
                           g_edd[l_ac2].ima021_b,g_edd[l_ac2].ima08_b
                      FROM ima_file
                     WHERE ima01=g_edd[l_ac2].edd03
                END IF
                CALL cl_show_fld_cont()  
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            CALL i201_b_move_back() 
            LET b_edd.edd33 = '0'     
            INSERT INTO edd_file VALUES (b_edd.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","edd_file",g_edc01,g_edc02,SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL INSERT  
             ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn3                       
             END IF                                  
             COMMIT WORK     
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n2 = ARR_COUNT()
            INITIALIZE g_edd[l_ac2].* TO NULL     
            LET g_edd15 ='N'
            LET g_edd11 = NULL 
            LET g_edd[l_ac2].edd31 = 'N'
            LET g_edd18 = 0     LET g_edd17 = 'N'
            LET g_edd28 = 0 # 誤差容許率預設值應為 0
            LET g_edd10_fac = 1 LET g_edd10_fac2 = 1
            LET g_edd[l_ac2].edd16 = '0'
            LET g_edd[l_ac2].edd14 = '0'
            LET g_edd[l_ac2].edd30 = ' '
            LET g_edd[l_ac2].edd04 = g_today #Body default
            LET g_edd[l_ac2].edd06 = 1 
            LET g_edd[l_ac2].edd07 = 1 
            LET g_edd[l_ac2].edd08 = 0  
            LET g_edd[l_ac2].edd19 = '1'
            LET g_edd[l_ac2].edd081= 0
            LET g_edd[l_ac2].edd082= 1
            SELECT edc04 INTO g_edd[l_ac2].edd09 FROM edc_file
             WHERE edc01=g_edc01 AND edc02=g_edc02
               AND edc03=g_edc[l_ac].edc03
            LET g_edd_t.* = g_edd[l_ac2].*         #新輸入資料
            LET g_edd_o.* = g_edd[l_ac2].*         #新輸入資料
            LET g_edd10_t = NULL                   #FUN-910088--add--
            CALL cl_show_fld_cont()     
            NEXT FIELD edd02

        BEFORE FIELD edd02                        #default 項次
            IF g_edd[l_ac2].edd02 IS NULL OR g_edd[l_ac2].edd02 = 0 THEN
                SELECT max(edd02)
                   INTO g_edd[l_ac2].edd02
                   FROM edd_file
                   WHERE edd01 = g_edc01
                     AND edd011 = g_edc02
                     AND edd013= g_edc[l_ac].edc03
                IF g_edd[l_ac2].edd02 IS NULL
                   THEN LET g_edd[l_ac2].edd02 = 0
                END IF
                LET g_edd[l_ac2].edd02 = g_edd[l_ac2].edd02 + g_sma.sma19
            END IF
 
        AFTER FIELD edd02                        #default 項次
            IF g_edd[l_ac2].edd02 IS NOT NULL AND
               g_edd[l_ac2].edd02 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM edd_file
                      WHERE edd01=g_edc01
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03
                        AND edd02=g_edd[l_ac2].edd02
               IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD edd02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b2
                       IF l_i <> l_ac2 THEN
                         IF g_edd[l_i].edd02 = g_edd[l_ac2].edd02 AND g_edd[l_i].edd04 <> g_edd[l_ac2].edd04 THEN
                            LET g_edd[l_i].edd05 = g_edd[l_ac2].edd04
                            DISPLAY BY NAME g_edd[l_i].edd04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF
            END IF
             #若有更新項次時,插件位置的key值更新為變動后的項次
             IF p_cmd = 'u' AND (g_edd[l_ac2].edd02 != g_edd_t.edd02) THEN
                SELECT COUNT(*) INTO l_n FROM edd_file
                       WHERE edd01=g_edc01
                         AND edd011= g_edc02
                         AND edd013= g_edc[l_ac].edc03  
                         AND edd02=g_edd[l_ac2].edd02 
                IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD edd02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b2
                       IF l_i <> l_ac2 THEN
                         IF g_edd[l_i].edd02 = g_edd[l_ac2].edd02 AND g_edd[l_i].edd04 <> g_edd[l_ac2].edd04 THEN
                            LET g_edd[l_i].edd05 = g_edd[l_ac2].edd04
                            DISPLAY BY NAME g_edd[l_i].edd04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF
             END IF

        AFTER FIELD edd03                         #(元件料件)
               LET l_tf1 = NULL    #FUN-910088--add--
               IF cl_null(g_edd[l_ac2].edd03) THEN
                  LET g_edd[l_ac2].edd03=g_edd_t.edd03
               END IF
               IF NOT cl_null(g_edd[l_ac2].edd03) THEN  
                  #FUN-AA0059 -------------add start------------------
                   IF NOT s_chk_item_no(g_edd[l_ac2].edd03,'') THEN
                      CALL cl_err('',g_errno,1)
                      LET g_edd[l_ac2].edd03=g_edd_t.edd03
                      NEXT FIELD edd03
                   END IF 
                  #FUN-AA0059 ---------------add end----------------------
                   IF cl_null(g_edd_t.edd03) OR g_edd_t.edd03 <> g_edd[l_ac2].edd03 THEN 
                      LET l_n =0
                      SELECT COUNT(*) INTO l_n FROM edb_file
                       WHERE edb01=g_edc01
                         AND edb02=g_edc02
                         AND edb03=g_edd[l_ac2].edd03
                      IF l_n > 0 THEN
                         CALL cl_err(g_edd[l_ac2].edd03,'aec-059',0)
                         NEXT FIELD edd03
                      END IF
                      SELECT COUNT(*) INTO l_n FROM edd_file
                             WHERE edd01=g_edc01
                               AND edd011= g_edc02
                               AND edd013= g_edc[l_ac].edc03
                               AND edd03=g_edd[l_ac2].edd03
                      IF l_n>0 THEN
                         IF NOT cl_confirm('abm-728') THEN NEXT FIELD edd03 END IF
                      END IF
                   END IF
                   CALL i201_edd03(p_cmd)    #必需讀取(料件主檔) 
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_edd[l_ac2].edd03=g_edd_t.edd03
                      NEXT FIELD edd03
                   END IF
                   IF p_cmd = 'a' THEN LET g_edd15 = g_ima70_b END IF
                   IF g_edd[l_ac2].edd10 IS NULL OR g_edd[l_ac2].edd10 = ' '
                              OR g_edd[l_ac2].edd03 != g_edd_t.edd03
                             THEN LET g_edd[l_ac2].edd10 = g_ima63_b
                   #FUN-910088--add--start--
                      CALL i201_edd081_check() RETURNING l_tf1 
                      LET g_edd10_t = g_edd[l_ac2].edd10
                   #FUN-910088--add--end--      
                   END IF
                   IF g_ima08_b = 'D' THEN
                      LET g_edd17 = 'Y'
                      ELSE LET g_edd17 = 'N'
                   END IF
               #FUN-910088--add--start--
                   IF NOT cl_null(l_tf1) AND NOT l_tf1 THEN
                      NEXT FIELD edd081
                   END IF
              #FUN-910088--add--end--
               END IF

        AFTER FIELD edd04                        #check 是否重復
            IF NOT cl_null(g_edd[l_ac2].edd04) THEN
               IF NOT cl_null(g_edd[l_ac2].edd05) THEN
                  IF g_edd[l_ac2].edd05 < g_edd[l_ac2].edd04 THEN 
                     CALL cl_err(g_edd[l_ac2].edd04,'mfg2604',0)
                     NEXT FIELD edd04
                  END IF
               END IF
                IF g_edd[l_ac2].edd04 IS NOT NULL AND
                   (g_edd[l_ac2].edd04 != g_edd_t.edd04 OR
                    g_edd_t.edd04 IS NULL OR
                    g_edd[l_ac2].edd02 != g_edd_t.edd02 OR
                    g_edd_t.edd02 IS NULL OR
                    g_edd[l_ac2].edd03 != g_edd_t.edd03 OR
                    g_edd_t.edd03 IS NULL) THEN
                    SELECT count(*) INTO l_n
                        FROM edd_file
                        WHERE edd01 = g_edc01
                           AND edd011= g_edc02
                           AND edd013= g_edc[l_ac].edc03
                           AND edd02 = g_edd[l_ac2].edd02
                           AND edd03 = g_edd[l_ac2].edd03
                           AND edd04 = g_edd[l_ac2].edd04
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_edd[l_ac2].edd02 = g_edd_t.edd02
                        LET g_edd[l_ac2].edd03 = g_edd_t.edd03
                        LET g_edd[l_ac2].edd04 = g_edd_t.edd04
                        DISPLAY BY NAME g_edd[l_ac2].edd02 
                        DISPLAY BY NAME g_edd[l_ac2].edd03
                        DISPLAY BY NAME g_edd[l_ac2].edd04
                        NEXT FIELD edd02
                    END IF
                END IF
                CALL i201_bdate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_edd[l_ac2].edd04,g_errno,0)
                   LET g_edd[l_ac2].edd04 = g_edd_t.edd04
                   DISPLAY BY NAME g_edd[l_ac2].edd04 
                   NEXT FIELD edd04
                END IF
            END IF
           
        AFTER FIELD edd05   #check失效日小于生效日
            IF NOT cl_null(g_edd[l_ac2].edd05) THEN
               IF NOT cl_null(g_edd[l_ac2].edd04) THEN
                  IF g_edd[l_ac2].edd05 < g_edd[l_ac2].edd04 THEN 
                     CALL cl_err(g_edd[l_ac2].edd05,'mfg2604',0)
                     NEXT FIELD edd05
                  END IF
               END IF
                IF g_edd[l_ac2].edd05 IS NOT NULL OR g_edd[l_ac2].edd05 != ' '
                   THEN IF g_edd[l_ac2].edd05 < g_edd[l_ac2].edd04
                          THEN CALL cl_err(g_edd[l_ac2].edd05,'mfg2604',0)
                          NEXT FIELD edd04
                        END IF
                END IF
                CALL i201_edcte(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_edd[l_ac2].edd05,g_errno,0)
                   LET g_edd[l_ac2].edd05 = g_edd_t.edd05
                   DISPLAY BY NAME g_edd[l_ac2].edd05 
                   NEXT FIELD edd04
                END IF
            END IF
 
        AFTER FIELD edd06    #組成用量不可小于零
          IF NOT cl_null(g_edd[l_ac2].edd06) THEN
             IF g_edd[l_ac2].edd14 <> '2' THEN   
                IF g_edd[l_ac2].edd06 <= 0 THEN
                   CALL cl_err(g_edd[l_ac2].edd06,'mfg2614',0)
                   LET g_edd[l_ac2].edd06 = g_edd_o.edd06
                   DISPLAY BY NAME g_edd[l_ac2].edd06
                   NEXT FIELD edd06
                END IF
             ELSE
              # IF g_edd[l_ac2].edd06 > 0 THEN        #CHI-AC0037
                IF g_edd[l_ac2].edd06 >= 0 THEN       #CHI-AC0037
                   CALL cl_err('','asf-603',0)
                   NEXT FIELD edd06
                 END IF
             END IF             
          END IF
          LET g_edd_o.edd06 = g_edd[l_ac2].edd06
 
        AFTER FIELD edd07    #底數不可小于等于零
            IF NOT cl_null(g_edd[l_ac2].edd07) THEN
                IF g_edd[l_ac2].edd07 <= 0
                 THEN CALL cl_err(g_edd[l_ac2].edd07,'mfg2615',0)
                      LET g_edd[l_ac2].edd07 = g_edd_o.edd07
                      DISPLAY BY NAME g_edd[l_ac2].edd07
                      NEXT FIELD edd07
                END IF
                LET g_edd_o.edd07 = g_edd[l_ac2].edd07
            ELSE
               CALL cl_err(g_edd[l_ac2].edd07,'mfg3291',0)
               LET g_edd[l_ac2].edd07 = g_edd_o.edd07
               NEXT FIELD edd07
            END IF
 
        AFTER FIELD edd08    #損耗率
            IF NOT cl_null(g_edd[l_ac2].edd08) THEN
                IF g_edd[l_ac2].edd08 < 0 OR g_edd[l_ac2].edd08 > 100
                 THEN CALL cl_err(g_edd[l_ac2].edd08,'mfg4063',0)
                      LET g_edd[l_ac2].edd08 = g_edd_o.edd08
                      NEXT FIELD edd08
                END IF
                LET g_edd_o.edd08 = g_edd[l_ac2].edd08
            END IF
            IF cl_null(g_edd[l_ac2].edd08) THEN
                LET g_edd[l_ac2].edd08 = 0
            END IF
            DISPLAY BY NAME g_edd[l_ac2].edd08
            
        AFTER FIELD edd081    #固定損耗量
            IF NOT i201_edd081_check() THEN NEXT FIELD edd081 END IF   #FUN-910088--add--
        #FUN-910088--mark--start--
        #   IF NOT cl_null(g_edd[l_ac2].edd081) THEN
        #       IF g_edd[l_ac2].edd081 < 0 THEN 
        #          CALL cl_err(g_edd[l_ac2].edd081,'aec-020',0)
        #          LET g_edd[l_ac2].edd081 = g_edd_o.edd081
        #          NEXT FIELD edd081
        #       END IF
        #       LET g_edd_o.edd081 = g_edd[l_ac2].edd081
        #   END IF
        #   IF cl_null(g_edd[l_ac2].edd081) THEN
        #       LET g_edd[l_ac2].edd081 = 0
        #   END IF
        #   DISPLAY BY NAME g_edd[l_ac2].edd081
        #FUN-910088--mark--end--
            
        AFTER FIELD edd082    #損耗批量
            IF NOT cl_null(g_edd[l_ac2].edd082) THEN
                IF g_edd[l_ac2].edd082 <= 0 THEN 
                   CALL cl_err(g_edd[l_ac2].edd082,'alm-808',0)
                   LET g_edd[l_ac2].edd082 = g_edd_o.edd082
                   NEXT FIELD edd082
                END IF
                LET g_edd_o.edd082 = g_edd[l_ac2].edd082
            END IF
            IF cl_null(g_edd[l_ac2].edd082) THEN
                LET g_edd[l_ac2].edd082 = 1
            END IF
            DISPLAY BY NAME g_edd[l_ac2].edd082
 
        AFTER FIELD edd10   #發料單位
           IF g_edd[l_ac2].edd10 IS NULL OR g_edd[l_ac2].edd10 = ' '
             THEN LET g_edd[l_ac2].edd10 = g_edd_o.edd10
             DISPLAY BY NAME g_edd[l_ac2].edd10
             ELSE 
                 IF ((g_edd_o.edd10 IS NULL) OR (g_edd_t.edd10 IS NULL)
                      OR (g_edd[l_ac2].edd10 != g_edd_o.edd10)) THEN
                    CALL i201_edd10()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_edd[l_ac2].edd10,g_errno,0)
                       LET g_edd[l_ac2].edd10 = g_edd_o.edd10
                       DISPLAY BY NAME g_edd[l_ac2].edd10 
                       NEXT FIELD edd10
                     ELSE IF g_edd[l_ac2].edd10 != g_ima25_b
                            THEN CALL s_umfchk(g_edd[l_ac2].edd03,
                                 g_edd[l_ac2].edd10,g_ima25_b)
                                 RETURNING g_sw,g_edd10_fac  #發料/庫存單位
                                 IF g_sw THEN
                                   CALL cl_err(g_edd[l_ac2].edd10,'mfg2721',0)
                                   LET g_edd[l_ac2].edd10 = g_edd_o.edd10
                                   DISPLAY BY NAME g_edd[l_ac2].edd10 
                                   NEXT FIELD edd10
                                 END IF
                            ELSE   LET g_edd10_fac  = 1
                            END  IF
                            IF g_edd[l_ac2].edd10 != g_ima86_b  #發料/成本單位
                            THEN CALL s_umfchk(g_edd[l_ac2].edd03,
                                         g_edd[l_ac2].edd10,g_ima86_b)
                                 RETURNING g_sw,g_edd10_fac2
                                 IF g_sw THEN
                                   CALL cl_err(g_edd[l_ac2].edd03,'mfg2722',0)
                                   LET g_edd[l_ac2].edd10 = g_edd_o.edd10
                                   DISPLAY BY NAME g_edd[l_ac2].edd10 
                                   NEXT FIELD edd10
                                 END IF
                            ELSE LET g_edd10_fac2 = 1
                          END IF
                       END IF
                  END IF
                  #FUN-910088--add--start--
                  IF NOT i201_edd081_check() THEN
                     LET g_edd10_t = g_edd[l_ac2].edd10
                     LET g_edd_o.edd10 = g_edd[l_ac2].edd10
                     NEXT FIELD edd081
                  END IF
                  LET g_edd10_t = g_edd[l_ac2].edd10
                  #FUN-910088--add--end--
          END IF
          LET g_edd_o.edd10 = g_edd[l_ac2].edd10
                 
         
#       AFTER FIELD edd14  
#          IF NOT cl_null(g_edd[l_ac2].edd14) THEN
#              IF g_edd[l_ac2].edd14 NOT MATCHES'[0123]' THEN  #FUN-910053 add 23
#                  LET g_edd[l_ac2].edd14 = g_edd_o.edd14
#                  DISPLAY BY NAME g_edd[l_ac2].edd14
#                  NEXT FIELD edd14
#              END IF
#             IF g_edd[l_ac2].edd14 = '2' THEN
#                LET g_edd[l_ac2].edd16 = '0'
#             END IF
#             IF cl_null(g_edd[l_ac2].edd06) OR g_edd[l_ac2].edd06=0 THEN
#                IF g_edd[l_ac2].edd14 = '2' THEN
#                   LET g_edd[l_ac2].edd06 = -1
#                ELSE
#                   LET g_edd[l_ac2].edd06 = 1
#                END IF
#             ELSE
#                IF g_edd[l_ac2].edd14 = '2' AND g_edd[l_ac2].edd06 > 0 THEN
#                   LET g_edd[l_ac2].edd06=g_edd[l_ac2].edd06 * (-1)
#                END IF
#                IF g_edd[l_ac2].edd14 <> '2' AND g_edd[l_ac2].edd06 < 0 THEN
#                   LET g_edd[l_ac2].edd06=g_edd[l_ac2].edd06 * (-1)
#                END IF
#             END IF
#          END IF
#
#       AFTER FIELD edd19
#         IF NOT cl_null(g_edd[l_ac2].edd19) THEN
#             IF g_edd[l_ac2].edd19 NOT MATCHES'[1234]' THEN
#                 LET g_edd[l_ac2].edd19 = g_edd_o.edd19
#                 DISPLAY BY NAME g_edd[l_ac2].edd19
#                 NEXT FIELD edd19
#             END IF
#         END IF

        BEFORE DELETE                            #是否取消單身
            IF g_edd_t.edd02 > 0 AND
               g_edd_t.edd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM edd_file
                    WHERE edd01 = g_edc01
                      AND edd011= g_edc02
                      AND edd013= g_edc[l_ac].edc03               
                      AND edd02 = g_edd_t.edd02
                      AND edd03 = g_edd_t.edd03
                      AND edd04 = g_edd_t.edd04
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 OR g_success='N' THEN
                    LET l_buf = g_edd_t.edd02 clipped,'+',
                                g_edd_t.edd03 clipped,'+',
                                g_edd_t.edd04
                    CALL cl_err(l_buf,SQLCA.sqlcode,0)   
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                   LET g_rec_b2=g_rec_b2-1
                   DISPLAY g_rec_b2 TO FORMONLY.cn3
                 END IF
            END IF
         COMMIT WORK
         
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_edd[l_ac2].* = g_edd_t.*
               CLOSE i201_edd_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_edd[l_ac2].edd02,-263,1)
                LET g_edd[l_ac2].* = g_edd_t.*
            ELSE
                CALL i201_b_move_back() 
                UPDATE edd_file SET * = b_edd.*
                 WHERE edd01 = g_edc01
                   AND edd011= g_edc02
                   AND edd013= g_edc[l_ac].edc03
                   AND edd02 = g_edd_t.edd02
                   AND edd03 = g_edd_t.edd03
                   AND edd04 = g_edd_t.edd04
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","edd_file",g_edc01,g_edc02,SQLCA.sqlcode,"","",1) 
                    LET g_edd[l_ac2].* = g_edd_t.*
                    
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_edd")
            #LET l_ac2_t = l_ac2  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_edd[l_ac2].* = g_edd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_edd.deleteElement(l_ac2)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac2 = l_ac2_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i201_edd_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_ac2_t = l_ac2  #FUN-D40030
            #FUN-D40030--mark--str--
            #IF cl_null(g_edd[l_ac2].edd02) OR 
            #   cl_null(g_edd[l_ac2].edd03) THEN
            #   CALL g_edd.deleteElement(l_ac2)
            #END IF
            #FUN-D40030--mark--end--
            CLOSE i201_edd_bcl
            COMMIT WORK
 
     ON ACTION CONTROLP
           CASE WHEN INFIELD(edd03) #料件主檔
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima01"   
              #  LET g_qryparam.default1 = g_edd[l_ac2].edd03
              #  CALL cl_create_qry() RETURNING g_edd[l_ac2].edd03
                CALL q_sel_ima(FALSE, "q_ima01", "", g_edd[l_ac2].edd03, "", "", "", "" ,"",'' )  RETURNING g_edd[l_ac2].edd03 
#FUN-AA0059 --End--
                DISPLAY g_edd[l_ac2].edd03 TO edd03
                NEXT FIELD edd03
               WHEN INFIELD(edd10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_edd[l_ac2].edd10
                  CALL cl_create_qry() RETURNING g_edd[l_ac2].edd10
                  DISPLAY g_edd[l_ac2].edd10 TO edd10
                  NEXT FIELD edd10
               OTHERWISE EXIT CASE
           END  CASE
  
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(edd02) AND l_ac2 > 1 THEN
               LET g_edd[l_ac2].* = g_edd[l_ac2-1].*
               LET g_edd[l_ac2].edd04 = g_today
               LET g_edd[l_ac2].edd02 = NULL
               LET g_edd[l_ac2].edd05 = NULL  
               NEXT FIELD edd02
           END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
   #    ON ACTION CONTROLG            #TQC-C30136
   #        CALL cl_cmdask()          #TQC-C30136
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

    END INPUT

   #TQC-D40025---add--begin---
    BEFORE DIALOG
       CASE g_flag_b
          WHEN '1' NEXT FIELD edc03
          WHEN '2' NEXT FIELD edd02
       END CASE
   #TQC-D40025---add--end---

    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()

     ON ACTION controls
        #TQC-C30136---add---str
        IF NOT cl_null(l_act_controls) AND l_act_controls THEN
           CALL cl_set_head_visible("","AUTO")
        ELSE
        #TQC-C30136---add---end
           CALL cl_set_head_visible("main,language,info","AUTO")
        END IF                                                  #TQC-C30136
   
     ON ACTION accept
        ACCEPT DIALOG

     ON ACTION cancel
       #TQC-D40025---add--begin---
        IF p_cmd = 'a' THEN
           IF g_flag_b = '1' AND g_rec_b != 0 THEN
              CALL g_edc.deleteElement(l_ac)
              LET g_action_choice = "detail"
           END IF
           IF g_flag_b = '2' AND g_rec_b2!= 0 THEN
              CALL g_edd.deleteElement(l_ac2)
              LET g_action_choice = "detail"
           END IF
        END IF
       #TQC-D40025---add--end---
        EXIT DIALOG
     END DIALOG
    CLOSE i201_edc_bcl
    CLOSE i201_edd_bcl
    COMMIT WORK
    CALL i201_show()
    IF l_flag = 'Y' THEN  LET l_flag = 'N' CONTINUE WHILE END IF
    EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i201_b_fill(p_wc)              #BODY FILL UP
 
DEFINE p_wc            LIKE type_file.chr1000 
 
   IF cl_null(p_wc) THEN
      LET p_wc = " 1=1"
   END IF
   LET g_sql =
        "SELECT edc03,edc04,edc45,edc06,eca02,", 
        "       edc14,edc13,edc16,edc15,", 
        "       edc49,edc05,edc66,",   
        "       edc52,edc67,edc53,edc54,edc55,edc56,edc58,",
        "       edc62,edc63,edc65,edc12,edc34,edc64      ",
        " FROM edc_file LEFT OUTER JOIN eca_file ON edc06 = eca01",
        " WHERE edc01 = '",g_edc01,"'",
        "   AND edc02 = '",g_edc02,"'",
        "   AND ",p_wc CLIPPED,
        " ORDER BY edc03" 
    PREPARE i201_pb FROM g_sql
    DECLARE edc_curs CURSOR FOR i201_pb
    
    CALL g_edc.clear()

    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH edc_curs INTO g_edc[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_edc.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i201_b_fill_2(p_edc03)              #BODY FILL UP
DEFINE  
    p_edc03    LIKE edc_file.edc03 
 
    IF cl_null(g_wc2) THEN LET  g_wc2=' 1=1' END IF
    LET g_sql =
        "SELECT edd02,edd30,edd03,ima02,ima021,ima08,edd09,edd16,edd14,edd04,edd05,edd06,edd07,",
        "       edd10,edd08,edd081,edd082,edd19,edd24,edd13,edd31  ", 
        " FROM edd_file,ima_file",
        " WHERE edd01 ='",g_edc01,"' ",
        "   AND edd011 =",g_edc02,
        "   AND edd013 =",p_edc03,
        "   AND edd03 = ima01 ",
        "   AND edd06 != 0 ",          #組成用量為零就不顯示了
        "   AND ",g_wc2 CLIPPED
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,1,3"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 6,1,3"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
    END CASE
 
    PREPARE i201_pb1 FROM g_sql
    DECLARE edd_curs                       #SCROLL CURSOR
        CURSOR FOR i201_pb1
 
    CALL g_edd.clear()
    LET g_cnt2 = 1
    LET g_rec_b2 = 0
    FOREACH edd_curs INTO g_edd[g_cnt2].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      LET g_cnt2 = g_cnt2 + 1
 
      IF g_cnt2 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_edd.deleteElement(g_cnt2)
    LET g_rec_b2 = g_cnt2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
    LET g_cnt2 = 0
 
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B20080 --------------------Begin-----------------------
   IF NOT cl_null(g_argv1) THEN
      CALL cl_set_act_visible("insert,query", FALSE) 
   END IF
#FUN-B20080 --------------------End-------------------------   
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_edc TO s_edc.* 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_flag_b = '1'   #TQC-D40025 add
 
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_edc")
         LET l_ac2=0
         IF l_ac <> 0 THEN
            CALL i201_b_fill_2(g_edc[l_ac].edc03)
         END IF
      
      ON ACTION accept
         LET g_action_choice = "detail"
         EXIT DIALOG
   END DISPLAY
 
   DISPLAY ARRAY g_edd TO s_edd.* 
      BEFORE ROW
         LET l_ac2 = DIALOG.getCurrentRow("s_edd")
         LET g_flag_b = '2'   #TQC-D40025 add
 
      ON ACTION accept
         LET g_action_choice = "detail"
         EXIT DIALOG
   END DISPLAY
   
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
         
      #FUN-AA0030--begin--add------
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
     #FUN-AA0030--end--add---------
        
      ON ACTION next
         LET g_action_choice="next"
         EXIT DIALOG   
 
      ON ACTION previous
         LET g_action_choice="previous"
         EXIT DIALOG
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DIALOG
      ON ACTION first
         LET g_action_choice="first"
         EXIT DIALOG
      ON ACTION last
         LET g_action_choice="last"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i201_show_pic()
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about   
         CALL cl_about()  
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      #AFTER DISPLAY
      #   CONTINUE DIALOG
 
      ON ACTION controls            
         CALL cl_set_head_visible("","AUTO")  
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
         
     #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG

     #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG

     #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG  
     #CHI-D20010---begin
     ON ACTION undo_void
        LET g_action_choice="undo_void"
        EXIT DIALOG 
     #CHI-D20010---end
         
     #@ON ACTION 明細單身
      ON ACTION contents
         LET g_action_choice="contents"
         EXIT DIALOG  

     ON ACTION close
        LET INT_FLAG=FALSE
        LET g_action_choice = "exit"
        EXIT DIALOG
     ON ACTION exit
        LET g_action_choice="exit"
        EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i201_edc04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1 

    LET g_errno = ''
    SELECT ecd01,ecd02 INTO g_edc[l_ac].edc04,g_edc[l_ac].edc45 FROM ecd_file
     WHERE ecd01 = g_edc[l_ac].edc04

    CASE WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'aec-015'
         LET g_edc[l_ac].edc04 = ' '
         LET g_edc[l_ac].edc45 = ' '
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY BY NAME g_edc[l_ac].edc04
    DISPLAY BY NAME g_edc[l_ac].edc45

END FUNCTION

FUNCTION i201_edc06(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_ecaacti       LIKE eca_file.ecaacti

    LET g_errno = ' '
    SELECT eca02,ecaacti INTO g_edc[l_ac].eca02,l_ecaacti FROM eca_file
     WHERE eca01 = g_edc[l_ac].edc06

         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-676'
                   LET g_edc[l_ac].eca02 = ' ' LET l_ecaacti = ' '
              WHEN l_ecaacti='N' LET g_errno = '9028'
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_edc[l_ac].eca02

END FUNCTION

FUNCTION i201_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("edc55",TRUE)
    END IF

    IF INFIELD(edc54) THEN
       CALL cl_set_comp_entry("edc55",TRUE)
    END IF
END FUNCTION

FUNCTION i201_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  DEFINE l_cnt   LIKE type_file.num5 

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       IF g_edc[l_ac].edc54 ='N' THEN
          CALL cl_set_comp_entry("edc55",FALSE)
       END IF
    END IF

    IF INFIELD(edc54) THEN
       IF g_edc[l_ac].edc54 ='N' THEN
          CALL cl_set_comp_entry("edc55",FALSE)
       END IF
    END IF
END FUNCTION

FUNCTION i201_sgg(p_key)
DEFINE
    p_key          LIKE sgg_file.sgg01,
    l_sgg01        LIKE sgg_file.sgg01,
    l_sggacti      LIKE sgg_file.sggacti

    LET g_errno = ' '
    SELECT sgg01,sggacti INTO l_sgg01,l_sggacti FROM sgg_file
     WHERE sgg01 = p_key

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-003'
                                   LET l_sggacti = NULL
         WHEN l_sggacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

END FUNCTION

FUNCTION i201_b_move_to()
   LET g_edd[l_ac2].edd02 = b_edd.edd02
   LET g_edd[l_ac2].edd30 = b_edd.edd30
   LET g_edd[l_ac2].edd03 = b_edd.edd03
   LET g_edd[l_ac2].edd09 = b_edd.edd09
   LET g_edd[l_ac2].edd16 = b_edd.edd16
   LET g_edd[l_ac2].edd14 = b_edd.edd14
   LET g_edd[l_ac2].edd04 = b_edd.edd04
   LET g_edd[l_ac2].edd05 = b_edd.edd05
   LET g_edd[l_ac2].edd06 = b_edd.edd06
   LET g_edd[l_ac2].edd07 = b_edd.edd07
   LET g_edd[l_ac2].edd10 = b_edd.edd10
   LET g_edd[l_ac2].edd08 = b_edd.edd08
   LET g_edd[l_ac2].edd19 = b_edd.edd19
   LET g_edd[l_ac2].edd24 = b_edd.edd24
   LET g_edd[l_ac2].edd13 = b_edd.edd13
   LET g_edd[l_ac2].edd31 = b_edd.edd31 
   LET g_edd[l_ac2].edd081 = b_edd.edd081
   LET g_edd[l_ac2].edd082 = b_edd.edd082 
   LET g_edd10_fac = b_edd.edd10_fac                                            
   LET g_edd10_fac2 = b_edd.edd10_fac2                                          
   LET g_edd11 = b_edd.edd11                                                    
   LET g_edd15 = b_edd.edd15                                                    
   LET g_edd17 = b_edd.edd17                                                    
   LET g_edd18 = b_edd.edd18                                                    
   LET g_edd23 = b_edd.edd23                                                    
   LET g_edd27 = b_edd.edd27                                                    
   LET g_edd28 = b_edd.edd28                                                    
END FUNCTION
 
FUNCTION i201_b_move_back()

   LET b_edd.edd01      = g_edc01    
   LET b_edd.edd011     = g_edc02     
   LET b_edd.edd013     = g_edc[l_ac].edc03     
   LET b_edd.edd02      = g_edd[l_ac2].edd02
   LET b_edd.edd03      = g_edd[l_ac2].edd03
   LET b_edd.edd04      = g_edd[l_ac2].edd04
   LET b_edd.edd05      = g_edd[l_ac2].edd05
   LET b_edd.edd06      = g_edd[l_ac2].edd06
   LET b_edd.edd07      = g_edd[l_ac2].edd07
   LET b_edd.edd08      = g_edd[l_ac2].edd08
   LET b_edd.edd09      = g_edd[l_ac2].edd09
   LET b_edd.edd10      = g_edd[l_ac2].edd10
   LET b_edd.edd10_fac  = g_edd10_fac      
   LET b_edd.edd10_fac2 = g_edd10_fac2     
   LET b_edd.edd11      = g_edd11          
   LET b_edd.edd13      = g_edd[l_ac2].edd13
   LET b_edd.edd14      = g_edd[l_ac2].edd14
   LET b_edd.edd15      = g_edd15          
   LET b_edd.edd16      = g_edd[l_ac2].edd16
   LET b_edd.edd17      = g_edd17          
   LET b_edd.edd18      = g_edd18          
   LET b_edd.edd19      = g_edd[l_ac2].edd19
   LET b_edd.edd20      = ''               
   LET b_edd.edd21      = ''               
   LET b_edd.edd22      = ''               
   LET b_edd.edd23      = g_edd23          
   LET b_edd.edd24      = ''               
   LET b_edd.edd25      = ''               
   LET b_edd.edd26      = ''               
   LET b_edd.edd27      = g_edd27          
   LET b_edd.edd28      = g_edd28          
   LET b_edd.edd30      = g_edd[l_ac2].edd30
   LET b_edd.edd31      = g_edd[l_ac2].edd31  
   LET b_edd.eddmodu    = g_user           
   LET b_edd.edddate    = g_today          
   LET b_edd.eddcomm    = 'abmi201'  
   LET b_edd.edd081     = g_edd[l_ac2].edd081
   LET b_edd.edd082     = g_edd[l_ac2].edd082      

   IF cl_null(b_edd.edd02)  THEN
      LET b_edd.edd02=' '
   END IF
   SELECT ima910 INTO b_edd.edd29 FROM ima_file,edb_file
    WHERE edb01=g_edc01 AND edb02=g_edc02
      AND edb03=ima01
   IF cl_null(b_edd.edd29) THEN LET b_edd.edd29=' ' END IF
END FUNCTION

FUNCTION i201_edd03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,  
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima08,ima37,ima25,ima63,ima70,ima86,ima105,ima107,
           ima110,ima140,ima1401,imaacti 
        INTO g_edd[l_ac2].ima02_b,g_edd[l_ac2].ima021_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_ima86_b,g_edd27,g_ima107_b,l_ima110,l_ima140,l_ima1401,l_imaacti
        FROM ima_file
        WHERE ima01 = g_edd[l_ac2].edd03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_edd[l_ac2].ima02_b = NULL
                                   LET g_edd[l_ac2].ima021_b = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN
       LET g_ima70_b = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
 
#   IF l_ima140  ='Y' AND l_ima1401 <= g_vdate THEN 
#      LET g_errno = 'aim-809'
#      RETURN
#   END IF
 
    IF g_edd27 IS NULL OR g_edd27 = ' ' THEN LET g_edd27 = 'N' END IF
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN
       LET g_edd[l_ac2].edd19 = l_ima110
       DISPLAY BY NAME g_edd[l_ac2].edd19
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY BY NAME g_edd[l_ac2].ima02_b 
        DISPLAY BY NAME g_edd[l_ac2].ima021_b 
        LET g_edd[l_ac2].ima08_b = g_ima08_b
        DISPLAY BY NAME g_edd[l_ac2].ima08_b 
    END IF
END FUNCTION
 
FUNCTION  i201_bdate(p_cmd)
  DEFINE   l_edd04_a,l_edd04_i LIKE edd_file.edd04,
           l_edd05_a,l_edd05_i LIKE edd_file.edd05,
           p_cmd     LIKE type_file.chr1,  
           l_n       LIKE type_file.num10  
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM edd_file
                             WHERE edd01 = g_edc01         #主件   
                               AND edd011= g_edc02
                               AND edd013= g_edc[l_ac].edc03
                               AND edd02 = g_edd[l_ac2].edd02  #項次
                               AND edd04 = g_edd[l_ac2].edd04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT count(*) INTO l_n FROM edd_file
                      WHERE edd01 = g_edc01         #主件
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03    
                        AND edd02 = g_edd[l_ac2].edd02   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(edd04),MAX(edd05) INTO l_edd04_a,l_edd05_a
                       FROM edd_file
                      WHERE edd01 = g_edc01         #主件
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03    
                        AND edd02 = g_edd[l_ac2].edd02   #項次
                        AND edd04 < g_edd[l_ac2].edd04   #生效日
    IF l_edd04_a IS NOT NULL AND l_edd05_a IS NOT NULL
    THEN IF (g_edd[l_ac2].edd04 > l_edd04_a )
            AND (g_edd[l_ac2].edd04 < l_edd05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN
         END IF
    END IF
    IF g_edd[l_ac2].edd04 <  l_edd04_a THEN
        LET g_errno = 'mfg2737'
    END IF
    IF l_edd04_a IS NULL AND l_edd05_a IS NULL THEN
       RETURN
    END IF
 
    SELECT MIN(edd04),MIN(edd05) INTO l_edd04_i,l_edd05_i
                       FROM edd_file
                      WHERE edd01 = g_edc01         #主件
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03    
                       AND  edd02 = g_edd[l_ac2].edd02   #項次
                       AND  edd04 > g_edd[l_ac2].edd04   #生效日
    IF l_edd04_i IS NULL AND l_edd05_i IS NULL THEN RETURN END IF
    IF l_edd04_a IS NULL AND l_edd05_a IS NULL THEN
       IF g_edd[l_ac2].edd04 < l_edd04_i THEN
          LET g_errno = 'mfg2737'
       END IF
    END IF
    IF g_edd[l_ac2].edd04 > l_edd04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION  i201_edcte(p_cmd)
  DEFINE   l_edd04_i   LIKE edd_file.edd04,
           l_edd04_a   LIKE edd_file.edd04,
           p_cmd       LIKE type_file.chr1,   
           l_n         LIKE type_file.num5  
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM edd_file
                      WHERE edd01 = g_edc01         #主件
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03     
                        AND edd02 = g_edd[l_ac2].edd02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(edd04) INTO l_edd04_i
                       FROM edd_file
                      WHERE edd01 = g_edc01         #主件
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03        
                       AND  edd02 = g_edd[l_ac2].edd02   #項次
                       AND  edd04 > g_edd[l_ac2].edd04   #生效日
   SELECT MAX(edd04) INTO l_edd04_a
                       FROM edd_file
                      WHERE edd01 = g_edc01         #主件
                        AND edd011= g_edc02
                        AND edd013= g_edc[l_ac].edc03     
                        AND  edd02 = g_edd[l_ac2].edd02   #項次
                        AND  edd04 > g_edd[l_ac2].edd04   #生效日
   IF l_edd04_i IS NULL THEN RETURN END IF
   IF g_edd[l_ac2].edd05 > l_edd04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION

FUNCTION  i201_edd10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
LET g_errno = ' '
 
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_edd[l_ac2].edd10
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i201_y()
DEFINE l_msg              STRING

    IF cl_null(g_edc01) OR cl_null(g_edc02) IS NULL THEN    
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
#CHI-C30107 ---------- add ------------ begin
    IF g_edcconf="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_edcconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    IF g_edc1.edcacti="N" THEN
       CALL cl_err("",'aim-153',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-222') THEN RETURN END IF  
    SELECT edcconf INTO g_edcconf FROM edc_file WHERE edc01 = g_edc01
                                                  AND edc02 = g_edc02
#CHI-C30107 ---------- add ------------ end
    IF g_edcconf="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN          
    END IF    
    IF g_edcconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    IF g_edc1.edcacti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1)                
       RETURN                                                                
    ELSE                                                                                                                            
#       IF cl_confirm('aap-222') THEN        #CHI-C30107 mark
            BEGIN WORK                                                                                                              
            UPDATE edc_file                                                                                                         
            SET edcconf="Y"                                                                                                       
            WHERE edc01=g_edc01
              AND edc02=g_edc02
        IF SQLCA.sqlcode THEN                                                                                                       
            CALL cl_err3("upd","edc_file",g_edc01,g_edc02,SQLCA.sqlcode,"","edcconf",1)                                            
            ROLLBACK WORK                                                                                                           
        ELSE                                                                                                                        
            COMMIT WORK                                                                                                             
            LET g_edcconf="Y"                                                                                                 
            DISPLAY g_edcconf TO FORMONLY.edcconf
        END IF
#       END IF    #CHI-C30107 mark
    END IF
END FUNCTION
 
FUNCTION i201_z()
    IF cl_null(g_edc01) OR cl_null(g_edc02) IS NULL THEN    
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF
    IF g_edcconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    IF g_edcconf="N" OR g_edc1.edcacti="N" THEN                                                                                  
        CALL cl_err("",'atm-365',1)                                                                                                 
        RETURN
    ELSE
        IF cl_confirm('aap-224') THEN                                                                                                
         BEGIN WORK                                                                                                                 
         UPDATE edc_file                                                                                                            
           SET edcconf="N"                                                                                                        
         WHERE edc01=g_edc01 
           AND edc02=g_edc02
        IF SQLCA.sqlcode THEN                                                                                                         
          CALL cl_err3("upd","edc_file",g_edc01,g_edc02,SQLCA.sqlcode,"","edcconf",1)                                               
          ROLLBACK WORK
        ELSE                                                                                                                          
          COMMIT WORK                                                                                                                
          LET g_edcconf="N"                                                                                                    
          DISPLAY g_edcconf TO FORMONLY.edcconf
        END IF
        END IF
    END IF
END FUNCTION

#FUNCTION i201_x()  #CHI-D20010
FUNCTION i201_x(p_type)  #CHI-D20010
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_edc01) OR cl_null(g_edc02) IS NULL THEN    
       CALL cl_err('',-400,0)                                                                                                         
       RETURN                                                                                                                         
    END IF                                                                                                
    IF g_edcconf="Y" THEN                                                                                                     
       CALL cl_err("",9023,1)                                                                                                       
       RETURN          
    END IF    
    #CHI-D20010---begin
    IF p_type = 1 THEN
       IF g_edcconf ='X' THEN RETURN END IF
    ELSE
       IF g_edcconf <>'X' THEN RETURN END IF
    END IF
    #CHI-D20010---end
    
   IF g_edc1.edcacti="N" THEN                                                                                                       
       CALL cl_err("",'aim-153',1)                
       RETURN                                                                
   ELSE 
      IF g_edcconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
     #IF cl_void(0,0,g_edcconf)   THEN  #CHI-D20010
      IF cl_void(0,0,l_flag)   THEN  #CHI-D20010
        LET g_chr=g_edcconf
       #IF g_edcconf ='N' THEN #CHI-D20010
        IF p_type = 1 THEN  #CHI-D20010
           LET g_edcconf='X'
        ELSE
           LET g_edcconf='N'
        END IF
        UPDATE edc_file
            SET edcconf=g_edcconf,
                edcmodu=g_user,
                edcdate=g_today
            WHERE edc01  =g_edc01
              AND edc02 = g_edc02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","edc_file",g_edc01,g_edc02,SQLCA.sqlcode,"","",1) 
            LET g_edcconf=g_chr
        END IF                                                            
      END IF
   END IF
END FUNCTION

#FUN-AA0030--begin--add--------
FUNCTION i201_copy()
   DEFINE l_newno      LIKE edc_file.edc01,
          l_newedc02   LIKE edc_file.edc02,
          l_oldno      LIKE edc_file.edc01,
          l_oldedc02   LIKE edc_file.edc02
   DEFINE li_result    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_n          LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_edc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno,l_newedc02 FROM edc01,edc02
 
       AFTER FIELD edc01                      
         IF NOT cl_null(l_newno) THEN
            LET l_n = 0
            IF NOT cl_null(l_newedc02) THEN
               SELECT count(*) INTO l_n FROM edb_file,eda_file
                WHERE edb01=l_newno
                  AND edb02=l_newedc02
                  AND eda01=edb01
                  AND edaconf='Y'
            ELSE
                SELECT count(*) INTO l_n FROM eda_file
                 WHERE eda01 = l_newno
                   AND edaconf = 'Y'
            END IF
            IF l_n = 0 THEN
               CALL cl_err(l_newno,'aec-057',1)
               NEXT FIELD edc01
            END IF
            CALL i201_chk_edc(l_newno,l_newedc02)
            IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,1) NEXT FIELD edc01 END IF
         END IF
 
     AFTER FIELD edc02
      IF NOT cl_null(l_newedc02) THEN
         LET l_n = 0
         SELECT count(*) INTO l_n FROM edb_file,eda_file
          WHERE edb01=l_newno
            AND edb02=l_newedc02
            AND eda01=edb01
            AND edaconf='Y'
         IF l_n = 0 THEN
            CALL cl_err(g_edc01,'aec-058',1)
            NEXT FIELD edc02
         END IF
         CALL i201_chk_edc(l_newno,l_newedc02)
         IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,1) NEXT FIELD edc02 END IF
      END IF
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(edc01) OR INFIELD(edc02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_edc"
               LET g_qryparam.default1 = l_newno
               LET g_qryparam.default2 = l_newedc02
               CALL cl_create_qry() RETURNING l_newno,l_newedc02  
               DISPLAY l_newno TO edc01
               DISPLAY l_newedc02 TO edc02
               NEXT FIELD CURRENT
            OTHERWISE EXIT CASE
         END CASE

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
      DISPLAY g_edc01 TO edc01
      DISPLAY g_edc02 TO edc02
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM edc_file         #單頭複製
       WHERE edc01=g_edc01
         AND edc02=g_edc02
       INTO TEMP y
 
   UPDATE y
       SET edc01=l_newno,    #新的鍵值
           edc02=l_newedc02,  #新的鍵值
           edcconf='N',
           edcuser=g_user,   #資料所有者
           edcgrup=g_grup,   #資料所有者所屬群
           edcmodu=NULL,     #資料修改日期
           edcdate=g_today,  #資料建立日期
           edcacti='Y',      #有效資料
           edcoriu=g_user,
           edcorig=g_grup
 
   INSERT INTO edc_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","edc_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM edd_file         #單身複製
    WHERE edd01=g_edc01
      AND edd011=g_edc02
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET edd01=l_newno,edd011=l_newedc02
 
   INSERT INTO edd_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","edd_file","","",SQLCA.sqlcode,"","",1)   #FUN-B80046
     ROLLBACK WORK #No:7857
    #  CALL cl_err3("ins","edd_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129    #FUN-B80046
      RETURN
   ELSE
       COMMIT WORK #No:7857
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_edc01  LET l_oldedc02=g_edc02
   LET g_edc01 = l_newno  LET g_edc02=l_newedc02
   CALL i201_show()
   LET g_flag='Y'
   CALL i201_b()
   LET g_flag='N'
   #LET g_edc01=l_oldno  LET g_edc02=l_oldedc02  #FUN-C30027
   #CALL i201_show()  #FUN-C30027
 
END FUNCTION
#FUN-AA0030--end--add------------
 
FUNCTION i201_show_pic()                                                                                                            
DEFINE l_void    LIKE type_file.chr1
DEFINE l_confirm LIKE type_file.chr1

     LET l_void=NULL
     LET l_confirm=NULL
     IF g_edcconf MATCHES '[Yy]' THEN
           LET l_confirm='Y'
           LET l_void='N'
     ELSE
        IF g_edcconf ='X' THEN
              LET l_confirm='N'
              LET l_void='Y'
        ELSE
           LET l_confirm='N'
           LET l_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(l_confirm,"","","",l_void,"g_edc1.edcacti")                                                                
END FUNCTION              

FUNCTION i201_edc_init()
    LET g_edc1.edc01=g_edc01
    LET g_edc1.edc02=g_edc02
    LET g_edc1.edcconf=g_edcconf
    LET g_edc1.edc03=g_edc[l_ac].edc03
    LET g_edc1.edc04=g_edc[l_ac].edc04
    LET g_edc1.edc05=g_edc[l_ac].edc05
    LET g_edc1.edc06=g_edc[l_ac].edc06
    LET g_edc1.edc12=g_edc[l_ac].edc12
    LET g_edc1.edc13=g_edc[l_ac].edc13
    LET g_edc1.edc14=g_edc[l_ac].edc14
    LET g_edc1.edc15=g_edc[l_ac].edc15
    LET g_edc1.edc16=g_edc[l_ac].edc16  
    LET g_edc1.edc34=g_edc[l_ac].edc34
    LET g_edc1.edc49=g_edc[l_ac].edc49 
    LET g_edc1.edc52=g_edc[l_ac].edc52
    LET g_edc1.edc53=g_edc[l_ac].edc53
    LET g_edc1.edc54=g_edc[l_ac].edc54  
    LET g_edc1.edc58=g_edc[l_ac].edc58
    LET g_edc1.edc62=g_edc[l_ac].edc62
    LET g_edc1.edc63=g_edc[l_ac].edc63
    LET g_edc1.edc64=g_edc[l_ac].edc64
    LET g_edc1.edc65=g_edc[l_ac].edc65
    LET g_edc1.edc66=g_edc[l_ac].edc66
    LET g_edc1.edc67=g_edc[l_ac].edc67
    LET g_edc1.edc55=g_edc[l_ac].edc55
    LET g_edc1.edc56=g_edc[l_ac].edc56 
    LET g_edc1.edc45=g_edc[l_ac].edc45           
    LET g_edc1.edc321=0
    LET g_edc1.edc121='N'
    LET g_edc1.edc43='N'
    LET g_edc1.edc61='N'
    LET g_edc1.edc07=0
    LET g_edc1.edc08=0
    LET g_edc1.edc09=0
    LET g_edc1.edc10=0
    LET g_edc1.edc17=0
    LET g_edc1.edc18=0
    LET g_edc1.edc19=0
    LET g_edc1.edc20=0
    LET g_edc1.edc21=0
    LET g_edc1.edc22=0
    LET g_edc1.edc23=0
    LET g_edc1.edc24=0
    LET g_edc1.edc35=0
    LET g_edc1.edc37=0
    LET g_edc1.edc38=0
    LET g_edc1.edc39=0
    LET g_edc1.edc301=0
    LET g_edc1.edc302=0
    LET g_edc1.edc311=0
    LET g_edc1.edc312=0
    LET g_edc1.edc313=0
    LET g_edc1.edc314=0
    LET g_edc1.edc315=0
    LET g_edc1.edc322=0
    LET g_edc1.edc291=0
    LET g_edc1.edc292=0
    LET g_edc1.edc303=0
    LET g_edc1.edc316=0
    LET g_edc1.edcslk01='N'
    LET g_edc1.edcslk02=0
    LET g_edc1.edcslk03=0
    LET g_edc1.edcslk04=0
    LET g_edc1.edcorig=g_grup
    LET g_edc1.edcoriu=g_user
    SELECT edb03,edb04 INTO g_edc1.edc031,g_edc1.edc11
      FROM edb_file
     WHERE edb01=g_edc01
       AND edb02=g_edc02                                 
END FUNCTION

FUNCTION i201_out()
DEFINE sr RECORD
          edc01    LIKE edc_file.edc01,
          edc02    LIKE edc_file.edc02,
          edcconf  LIKE edc_file.edcconf,
          edc03    LIKE edc_file.edc03,          
          edc04    LIKE edc_file.edc04,          
          edc45    LIKE edc_file.edc45,          
          edb07    LIKE edb_file.edb07,
          edd03    LIKE edd_file.edd03,
          edd04    LIKE edd_file.edd04,
          edd05    LIKE edd_file.edd05,
          edd06    LIKE edd_file.edd06,
          edd07    LIKE edd_file.edd07,
          ima02    LIKE ima_file.ima02,
          ima021   LIKE ima_file.ima021,
          ima08    LIKE ima_file.ima08
          END RECORD
DEFINE l_wc   STRING

    IF cl_null(g_edc01) OR cl_null(g_edc02) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" edc01='",g_edc01,"'",
                 " AND edc02= ",g_edc02
       LET g_wc2=" 1=1"   
    END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    CALL cl_del_data(l_table)
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90043
       EXIT PROGRAM
    END IF
    LET g_sql="SELECT edc01,edc02,edcconf,edc03,edc04,edc45,", 
              " edb07,edd03,edd04,edd05,edd06,edd07,ima02,ima021,ima08", 
              "  FROM edc_file,edd_file,edb_file LEFT OUTER JOIN ima_file ON edb03=ima01 ",  
              " WHERE edb01=edc01 AND edb02=edc02",
              "   AND edd01=edc01 AND edd011=edc02 AND edd013=edc03",   
              "   AND ",g_wc CLIPPED,"AND ",g_wc2 CLIPPED 
    LET g_sql = g_sql CLIPPED," ORDER BY edc01,edc02,edc03" 
    PREPARE i201_p1 FROM g_sql  
    IF STATUS THEN CALL cl_err('i201_p1',STATUS,0) END IF
 
    DECLARE i201_co                         # CURSOR
        CURSOR FOR i201_p1
 
 
    FOREACH i201_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        EXECUTE insert_prep USING sr.*
    END FOREACH
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'edc01,edc02,edcconf,edcuser,edcgrup,edcmodu,edcdate,edcacti')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
    LET g_str = l_wc CLIPPED
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aeci201','aeci201',g_sql,g_str) 
    CLOSE i201_co
    ERROR ""
END FUNCTION

FUNCTION i201_chk_edc(p_edc01,p_edc02)
DEFINE l_cnt   LIKE type_file.num5
DEFINE p_edc01 LIKE edc_file.edc01
DEFINE p_edc02 LIKE edc_file.edc02

  LET g_errno=''
  IF NOT cl_null(p_edc01) AND NOT cl_null(p_edc02) THEN
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM edc_file
      WHERE edc01=p_edc01
        AND edc02=p_edc02
     IF l_cnt > 0 THEN
        LET g_errno = -239
     END IF
  END IF

END FUNCTION

FUNCTION i201_b_set_entry()
    CALL cl_set_comp_entry("edc03",TRUE)
END FUNCTION

FUNCTION i201_b_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    IF cl_null(g_flag) THEN LET g_flag='N' END IF
    IF p_cmd = 'u' AND g_flag='N' THEN  #FUN-AA0030
        CALL cl_set_comp_entry("edc03",FALSE)
    END IF
END FUNCTION

FUNCTION i201_bp_refresh()                                                                                                          
   DISPLAY ARRAY g_edd TO s_edd.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
   #BEFORE DISPLAY
   #     EXIT DISPLAY
     ON IDLE g_idle_seconds 
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY 

END FUNCTION 

FUNCTION i201_edc67()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05 
 
   LET g_errno=' '
   SELECT pmcacti,pmc05
     INTO l_pmcacti,l_pmc05
     FROM pmc_file
    WHERE pmc01=g_edc[l_ac].edc67
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
        WHEN l_pmc05='3'        LET g_errno='aap-033'
   END CASE
END FUNCTION
#FUN-A80054

#FUN-910088--add--start--
FUNCTION i201_edd081_check()
   IF NOT cl_null(g_edd[l_ac2].edd081) AND NOT cl_null(g_edd[l_ac2].edd10) THEN
      IF cl_null(g_edd10_t) OR cl_null(g_edd_t.edd081) OR g_edd10_t != g_edd[l_ac2].edd10 OR g_edd_t.edd081 != g_edd[l_ac2].edd081 THEN
         LET g_edd[l_ac2].edd081 = s_digqty(g_edd[l_ac2].edd081,g_edd[l_ac2].edd10)
         DISPLAY BY NAME g_edd[l_ac2].edd081
      END IF
   END IF
   IF NOT cl_null(g_edd[l_ac2].edd081) THEN
       IF g_edd[l_ac2].edd081 < 0 THEN 
          CALL cl_err(g_edd[l_ac2].edd081,'aec-020',0)
          LET g_edd[l_ac2].edd081 = g_edd_o.edd081
          RETURN FALSE     
       END IF
       LET g_edd_o.edd081 = g_edd[l_ac2].edd081
   END IF
   IF cl_null(g_edd[l_ac2].edd081) THEN
       LET g_edd[l_ac2].edd081 = 0
   END IF
   DISPLAY BY NAME g_edd[l_ac2].edd081
   RETURN TRUE
END FUNCTION

FUNCTION i201_edc12_check()
   IF NOT cl_null(g_edc[l_ac].edc12) AND NOT cl_null(g_edc[l_ac].edc58) THEN
      IF cl_null(g_edc58_t) OR cl_null(g_edc_t.edc12) OR g_edc58_t != g_edc[l_ac].edc58 OR g_edc_t.edc12 != g_edc[l_ac].edc12 THEN
         LET  g_edc[l_ac].edc12 = s_digqty(g_edc[l_ac].edc12,g_edc[l_ac].edc58)
         DISPLAY BY NAME g_edc[l_ac].edc12
      END IF
   END IF
   IF NOT cl_null(g_edc[l_ac].edc12) THEN
      IF g_edc[l_ac].edc12 < 0 THEN
         CALL cl_err(g_edc[l_ac].edc12,'axm-179',0)
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
