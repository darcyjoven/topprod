# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfi412.4gl
# Descriptions...: 合拼版製程及料件維護作業
# Date & Author..: 08/01/11 By jan (FUN-A80054)
# Modify.........: No.FUN-A90035 10/09/17 By vealxu 新增列印功能
# Modify.........: No.FUN-A80060 10/09/28 By jan GP5.25工單間合拼
# Modify.........: No.FUN-AA0030 10/10/19 By jan 新增複製功能
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By huangtao 添加after field料號管控
# Modify.........: No.CHI-AC0037 10/12/31 By lixh1 控卡單身為回收料時,bmb06可以為負,但不可為0
# Modify.........: No.FUN-B10056 11/02/21 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B30055 11/03/07 By destiny 新增时orig,oriu没有值
# Modify.........: No.TQC-B40106 11/04/15 By lixia 查詢時orig,oriu無法下查詢條件
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-910088 11/12/01 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/14 By chenjing 數量欄位小數取位處理
# Modify.........: No.TQC-C30136 12/03/08 By xujing 處理ON ACITON衝突問題
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By xumm 修改FUN-D40030遗留问题
# Modify.........: No:TQC-D70064 13/07/22 By lujh 當asms280中設置不使用平行工藝時，asfi412中單頭的“被取代工藝段號”sfd07欄位應該隱藏
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_edg01         LIKE edg_file.edg01,   #料號 (假單頭)
       g_edg02         LIKE edg_file.edg02,   #供應商編號
       g_edg01_t       LIKE edg_file.edg01,   #料號(舊值)
       g_edg02_t       LIKE edg_file.edg02,   #供應商編號（舊值）
       g_edg1           RECORD LIKE edg_file.*,
       b_edh           RECORD LIKE edh_file.*,
       g_edg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         edg03		     LIKE edg_file.edg03,  #製程序
         edg04		     LIKE edg_file.edg04,  #作業編號
         edg45		     LIKE edg_file.edg45,  #作業名稱
         edg06		     LIKE edg_file.edg06,  #生產站別
         eca02		     LIKE eca_file.eca02,  #站別說明
         edg14		     LIKE edg_file.edg14,  #標準工時
         edg13		     LIKE edg_file.edg13,  #固定工時
         edg16		     LIKE edg_file.edg16,  #標準機時
         edg15		     LIKE edg_file.edg15,  #固定機時
         edg49		     LIKE edg_file.edg49,  #製程人力
         edg50		     LIKE edg_file.edg50,  #開工日
         edg51		     LIKE edg_file.edg51,  #完工日
         edg05		     LIKE edg_file.edg05,  #機械編號
         edg66		     LIKE edg_file.edg66,  #報工點否
         edg52		     LIKE edg_file.edg52,  #委外否
         edg67               LIKE edg_file.edg67,  #委外廠商
         edg321              LIKE edg_file.edg321, #委外加工量 
         edg53		     LIKE edg_file.edg53,  #PQC否
         edg54		     LIKE edg_file.edg54,  #check in
         edg55         LIKE edg_file.edg55,  #Hold for check in
         edg56         LIKE edg_file.edg56,  #Hold for check out(報工)
         edg58         LIKE edg_file.edg58,
         edg62         LIKE edg_file.edg62,  #组成用量
         edg63         LIKE edg_file.edg63,  #底数
         edg65         LIKE edg_file.edg65,  #标准产出量
         edg12         LIKE edg_file.edg12,  #固定损耗量
         edg34         LIKE edg_file.edg34,  #变动损耗率
         edg64         LIKE edg_file.edg64   #损耗批量
                       END RECORD,
       g_edg_t         RECORD                 #程式變數 (舊值)
         edg03		     LIKE edg_file.edg03,  #製程序
         edg04		     LIKE edg_file.edg04,  #作業編號
         edg45		     LIKE edg_file.edg45,  #作業名稱
         edg06		     LIKE edg_file.edg06,  #生產站別
         eca02		     LIKE eca_file.eca02,  #站別說明
         edg14		     LIKE edg_file.edg14,  #標準工時
         edg13		     LIKE edg_file.edg13,  #固定工時
         edg16		     LIKE edg_file.edg16,  #標準機時
         edg15		     LIKE edg_file.edg15,  #固定機時
         edg49		     LIKE edg_file.edg49,  #製程人力
         edg50		     LIKE edg_file.edg50,  #開工日
         edg51		     LIKE edg_file.edg51,  #完工日
         edg05		     LIKE edg_file.edg05,  #機械編號
         edg66		     LIKE edg_file.edg66,  #報工點否
         edg52		     LIKE edg_file.edg52,  #委外否
         edg67               LIKE edg_file.edg67,  #委外廠商
         edg321              LIKE edg_file.edg321, #委外加工量 
         edg53		     LIKE edg_file.edg53,  #PQC否
         edg54		     LIKE edg_file.edg54,  #check in
         edg55         LIKE edg_file.edg55,  #Hold for check in
         edg56         LIKE edg_file.edg56,  #Hold for check out(報工)
         edg58         LIKE edg_file.edg58,
         edg62         LIKE edg_file.edg62,  #组成用量
         edg63         LIKE edg_file.edg63,  #底数
         edg65         LIKE edg_file.edg65,  #标准产出量
         edg12         LIKE edg_file.edg12,  #固定损耗量
         edg34         LIKE edg_file.edg34,  #变动损耗率
         edg64         LIKE edg_file.edg64   #损耗批量
                       END RECORD,
       g_edh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)    	              
         edh02         LIKE edh_file.edh02,   #元件項次
         edh30         LIKE edh_file.edh30,   #計算方式 
         edh03         LIKE edh_file.edh03,   #元件料件
         ima02_b       LIKE ima_file.ima02,   #品名
         ima021_b      LIKE ima_file.ima021,  #規格
         ima08_b       LIKE ima_file.ima08,   #來源
         edh09         LIKE edh_file.edh09,   #作業編號
         edh16         LIKE edh_file.edh16,   #UTE/SUB
         edh14         LIKE edh_file.edh14,   #Required/Optional
         edh04         LIKE edh_file.edh04,   #生效日
         edh05         LIKE edh_file.edh05,   #失效日
         edh06         LIKE edh_file.edh06,   #組成用量
         edh07         LIKE edh_file.edh07,   #底數
         edh10         LIKE edh_file.edh10,   #發料單位
         edh08         LIKE edh_file.edh08,   #損耗率
         edh081        LIKE edh_file.edh081,
         edh082        LIKE edh_file.edh082,
         edh19         LIKE edh_file.edh19,
         edh24         LIKE edh_file.edh24,    #工程變異單號
         edh13         LIKE edh_file.edh13,    #insert_loc
         edh31         LIKE edh_file.edh31     #代買料否 
                       END RECORD,
       g_edh_t         RECORD                 #程式變數 (舊值)
         edh02         LIKE edh_file.edh02,   #元件項次
         edh30         LIKE edh_file.edh30,   #計算方式 
         edh03         LIKE edh_file.edh03,   #元件料件
         ima02_b       LIKE ima_file.ima02,   #品名
         ima021_b      LIKE ima_file.ima021,  #規格
         ima08_b       LIKE ima_file.ima08,   #來源
         edh09         LIKE edh_file.edh09,   #作業編號
         edh16         LIKE edh_file.edh16,   #UTE/SUB
         edh14         LIKE edh_file.edh14,   #Required/Optional
         edh04         LIKE edh_file.edh04,   #生效日
         edh05         LIKE edh_file.edh05,   #失效日
         edh06         LIKE edh_file.edh06,   #組成用量
         edh07         LIKE edh_file.edh07,   #底數
         edh10         LIKE edh_file.edh10,   #發料單位
         edh08         LIKE edh_file.edh08,   #損耗率
         edh081        LIKE edh_file.edh081,
         edh082        LIKE edh_file.edh082,
         edh19         LIKE edh_file.edh19,
         edh24         LIKE edh_file.edh24,    #工程變異單號
         edh13         LIKE edh_file.edh13,    #insert_loc
         edh31         LIKE edh_file.edh31     #代買料否 
                       END RECORD,
       g_edh_o         RECORD                 #程式變數 (舊值)
         edh02         LIKE edh_file.edh02,   #元件項次
         edh30         LIKE edh_file.edh30,   #計算方式 
         edh03         LIKE edh_file.edh03,   #元件料件
         ima02_b       LIKE ima_file.ima02,   #品名
         ima021_b      LIKE ima_file.ima021,  #規格
         ima08_b       LIKE ima_file.ima08,   #來源
         edh09         LIKE edh_file.edh09,   #作業編號
         edh16         LIKE edh_file.edh16,   #UTE/SUB
         edh14         LIKE edh_file.edh14,   #Required/Optional
         edh04         LIKE edh_file.edh04,   #生效日
         edh05         LIKE edh_file.edh05,   #失效日
         edh06         LIKE edh_file.edh06,   #組成用量
         edh07         LIKE edh_file.edh07,   #底數
         edh10         LIKE edh_file.edh10,   #發料單位
         edh08         LIKE edh_file.edh08,   #損耗率
         edh081        LIKE edh_file.edh081,
         edh082        LIKE edh_file.edh082,
         edh19         LIKE edh_file.edh19,
         edh24         LIKE edh_file.edh24,    #工程變異單號
         edh13         LIKE edh_file.edh13,    #insert_loc
         edh31         LIKE edh_file.edh31     #代買料否 
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
       g_edh11         LIKE edh_file.edh11,
       g_edh15         LIKE edh_file.edh15,
       g_edh18         LIKE edh_file.edh18,
       g_edh17         LIKE edh_file.edh17,
       g_edh23         LIKE edh_file.edh23,
       g_edh27         LIKE edh_file.edh27,
       g_edh28         LIKE edh_file.edh28, 
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
DEFINE g_edh10_fac     LIKE edh_file.edh10_fac
DEFINE g_edh10_fac2    LIKE edh_file.edh10_fac2
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_cott,g_sw     LIKE type_file.num5
DEFINE l_table         STRING
DEFINE g_str           STRING
DEFINE l_n3            LIKE type_file.num5
DEFINE g_sfdconf       LIKE sfd_file.sfdconf
DEFINE g_sfd03         LIKE sfd_file.sfd03
DEFINE g_sfd07         LIKE sfd_file.sfd07
DEFINE g_argv1         LIKE edg_file.edg01
DEFINE g_argv2         LIKE edg_file.edg02
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_edh10_t       LIKE edh_file.edh10    #FUN-910088--add--
DEFINE g_edg58_t       LIKE edg_file.edg58    #FUN-910088--add--
DEFINE g_b_flag        STRING                   #TQC-D40025
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

#FUN-A90035 ----------------add start------------------------
   LET g_sql="sfd01.sfd_file.sfd01,",
             "sfd02.sfd_file.sfd02,",
             "sfd03.sfd_file.sfd03,",
             "sfb05.sfb_file.sfb05,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "edh03.edh_file.edh03,",
             "ima02_s.ima_file.ima02,",
             "ima021_s.ima_file.ima021,",
             "ima08_s.ima_file.ima08,",
             "edh04.edh_file.edh04,",
             "edh05.edh_file.edh05,",
             "edh06.edh_file.edh06,",
             "edh07.edh_file.edh07 "  
   LET l_table = cl_prt_temptable('asfi412',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF   
#FUN-9A0035 ----------------add end------------------------

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_edg01= NULL                     #清除鍵值
   LET g_edg01_t = NULL
   LET g_edg02_t = NULL
 
   OPEN WINDOW i412_w WITH FORM "asf/42f/asfi412"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("edg66",g_sma.sma1431='Y')
   CALL cl_set_comp_visible("edg65,edh30,edh09",FALSE)
   CALL cl_set_comp_entry("edh14,edh16,edh19",FALSE)
   CALL cl_set_comp_visible("sfd07",g_sma.sma541='Y')     #TQC-D70064 add
   LET g_flag='N'
   LET g_argv1 = ARG_VAL(1) 
   LET g_argv2 = ARG_VAL(2)
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL i412_q()
   END IF
   CALL i412_menu()
   CLOSE WINDOW i412_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION i412_curs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM                             #清除畫面
   CALL g_edg.clear()
     IF cl_null(g_argv1) THEN
      DIALOG ATTRIBUTES(UNBUFFERED)
        CONSTRUCT g_wc ON edg01,edg02,edguser,edgmodu,edgacti,edggrup,edgdate,edgoriu,edgorig,#TQC-B40106 addorig oriu
                          edg03,edg04,edg45,edg06,edg14,edg13,edg16,
                          edg15,edg49,edg50,edg51,edg05,edg66,edg52,edg67,edg321,edg53,edg54,edg55,
                          edg56,edg58,edg62,edg63,edg65,edg12,edg34,edg64
                     FROM edg01,edg02,edguser,edgmodu,edgacti,edggrup,edgdate,edgoriu,edgorig,#TQC-B40106 addorig oriu
                          s_edg[1].edg03,s_edg[1].edg04,s_edg[1].edg45,
                          s_edg[1].edg06,s_edg[1].edg14,s_edg[1].edg13,	
                          s_edg[1].edg16,s_edg[1].edg15,s_edg[1].edg49,s_edg[1].edg50,
                          s_edg[1].edg51,s_edg[1].edg05,s_edg[1].edg66,s_edg[1].edg52,
                          s_edg[1].edg67,s_edg[1].edg321,s_edg[1].edg53,	
                          s_edg[1].edg54,s_edg[1].edg55,s_edg[1].edg56,s_edg[1].edg58,s_edg[1].edg62,  
                          s_edg[1].edg63,s_edg[1].edg65,s_edg[1].edg12,s_edg[1].edg34,s_edg[1].edg64
                BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        END CONSTRUCT
      
        CONSTRUCT g_wc2 ON edh02,edh30,edh03,
                         edh16,edh14,edh04,edh05,edh06,edh07,
                         edh10,edh08,edh081,edh082,edh19,edh24,   
                         edh13,edh31              
                  FROM s_edh[1].edh02,s_edh[1].edh30,s_edh[1].edh03, 
                       s_edh[1].edh16,s_edh[1].edh14,s_edh[1].edh04,
                       s_edh[1].edh05,s_edh[1].edh06,s_edh[1].edh07,
                       s_edh[1].edh10,s_edh[1].edh08,s_edh[1].edh081,
                       s_edh[1].edh082,s_edh[1].edh19,s_edh[1].edh24,
                       s_edh[1].edh13,s_edh[1].edh31
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)  
         END CONSTRUCT
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(edg01)     
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_sfc"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edg01
                     NEXT FIELD edg01
                 WHEN INFIELD(edg05)                 #機械編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_eci"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edg05
                      NEXT FIELD edg05
                 WHEN INFIELD(edg06)                 #生產站別
                      CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edg06
                      NEXT FIELD edg06
                 WHEN INFIELD(edg04)                 #作業編號
                      CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edg04
                      NEXT FIELD edg04
                 WHEN INFIELD(edg55)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sgg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edg55
                      NEXT FIELD edg55
                 WHEN INFIELD(edg56)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sgg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edg56
                      NEXT FIELD edg56
                 WHEN INFIELD(edg58)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_gfe"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edg58
                      NEXT FIELD edg58
                 WHEN INFIELD(edg67) #廠商編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_pmc"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret 
                      DISPLAY g_qryparam.multiret TO edg67 
                      NEXT FIELD edg67
                 WHEN INFIELD(edh03) #料件主檔
#FUN-AB0025---------mod---------------str----------------
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_ima"
#                     LET g_qryparam.state = 'c'
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025--------mod---------------end----------------
                      DISPLAY g_qryparam.multiret TO edh03
                      NEXT FIELD edh03
                 WHEN INFIELD(edh10) #單位檔
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gfe"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO edh10
                      NEXT FIELD edh10
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
        LET g_wc = " edg01='",g_argv1,"' AND edg02='",g_argv2,"'"
        LET g_wc2=' 1=1'
     END IF
      
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
      IF g_wc2 = ' 1=1' OR cl_null(g_wc2) THEN
         LET g_sql= "SELECT UNIQUE edg01,edg02 FROM edg_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY edg01,edg02"
      ELSE
         LET g_sql= "SELECT UNIQUE edg01,edg02 FROM edg_file,edh_file ",
                    " WHERE edg01=edh01 ",
                    "   AND edg02=edh011 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED,
                    " ORDER BY edg01,edg02"
      END IF
      PREPARE i412_prepare FROM g_sql      #預備一下
      DECLARE i412_b_curs                  #宣告成可捲動的
          SCROLL CURSOR WITH HOLD FOR i412_prepare
      
      IF g_wc2 = ' 1=1' OR cl_null(g_wc2) THEN
         LET g_sql1= "SELECT UNIQUE edg01,edg02 FROM edg_file ",
                    " WHERE ", g_wc CLIPPED,
                    #"INTO TEMP x "
                    "  INTO TEMP x "  #TQC-B40106
      ELSE
         LET g_sql1= "SELECT UNIQUE edg01,edg02 FROM edg_file,edh_file ",
                    " WHERE edg01=edh01 ",
                    "   AND edg02=edh011 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED,
                    #"INTO TEMP x "
                    "  INTO TEMP x "  #TQC-B40106
      END IF
      DROP TABLE x
      PREPARE i412_precount_x FROM g_sql1
      EXECUTE i412_precount_x
      LET g_sql="SELECT COUNT(*) FROM x"
      PREPARE i412_precount FROM g_sql
      DECLARE i412_count CURSOR FOR i412_precount
 
END FUNCTION
 
FUNCTION i412_menu()
DEFINE l_cmd LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i412_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i412_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i412_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i412_r()
            END IF
         WHEN "output"                      #FUN-A90035 取消mark
            IF cl_chk_act_auth() THEN       #FUN-A90035
               CALL i412_out()              #FUN-A90035
            END IF                          #FUN-A90035
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i412_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-AA0030--begin--add------
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i412_copy()
            END IF
         #FUN-AA0030--end--add------
         WHEN "next"
            IF cl_chk_act_auth() THEN
               CALL i412_fetch('N')
            END IF
         WHEN "previous"
            IF cl_chk_act_auth() THEN
               CALL i412_fetch('P')
            END IF
         WHEN "jump"
            IF cl_chk_act_auth() THEN
               CALL i412_fetch('/')
            END IF
         WHEN "first"
            IF cl_chk_act_auth() THEN
               CALL i412_fetch('F')
            END IF
         WHEN "last"
            IF cl_chk_act_auth() THEN
               CALL i412_fetch('L')
            END IF
        #@WHEN "明細單身"
         WHEN "contents"
            IF cl_chk_act_auth() THEN 
             IF l_ac >0 AND l_ac2 > 0 THEN
               LET l_cmd = "asfi413 "," '",g_edg01,"'",
                           " '",g_edg02,"' '",g_edg[l_ac].edg03,"' ",
                           " '",g_edh[l_ac2].edh03,"' "
               CALL cl_cmdrun(l_cmd)
               CALL i412_show()
              #CALL i412_b_fill_2(g_edg[l_ac].edg03)                                                                       
              #CALL i412_bp_refresh()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_edg),'','')
            END IF
  
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                IF g_edg01 IS NOT NULL THEN
                 LET g_doc.column1 = "edg01"
                 LET g_doc.value1 = g_edg01
                 CALL cl_doc()
                END IF 
              END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i412_a()
 
   MESSAGE ""
   CLEAR FORM
   LET g_edg01=''
   LET g_edg02=''
   CALL g_edg.clear()
   INITIALIZE g_edg01 LIKE edg_file.edg01
   INITIALIZE g_edg02 LIKE edg_file.edg02
   LET g_edg01_t = NULL
   LET g_edg02_t = NULL
   LET g_edg1.edgacti = 'Y'
   LET g_edg1.edguser = g_user
   LET g_edg1.edggrup = g_grup
   LET g_edg1.edgdate = TODAY
   LET g_edg1.edgoriu = g_user
   LET g_edg1.edgorig = g_grup
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i412_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_edg01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      CALL g_edg.clear()
 
      LET g_rec_b=0   LET g_rec_b2=0
      DISPLAY g_rec_b TO FORMONLY.cn2
      DISPLAY g_rec_b2 TO FORMONLY.cn3
      CALL i412_b()                   #輸入單身
 
      LET g_edg01_t = g_edg01            #保留舊值
      LET g_edg02_t = g_edg02
      EXIT WHILE
   END WHILE
 
END FUNCTION
  
FUNCTION i412_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,                  #a:輸入 u:更改  
       l_n             LIKE type_file.num5,                  #檢查重復用
       l_n1            LIKE type_file.num5                   #檢查重復用
       
 
   CALL cl_set_head_visible("","YES")           
   DISPLAY BY NAME g_edg1.edguser,g_edg1.edggrup,g_edg1.edgdate,g_edg1.edgacti,
                   g_edg1.edgoriu,g_edg1.edgorig                                #TQC-B30055
   INPUT g_edg01,g_edg02 WITHOUT DEFAULTS FROM edg01,edg02
 
      AFTER FIELD edg01                      
         IF NOT cl_null(g_edg01) THEN
            LET l_n = 0
            IF NOT cl_null(g_edg02) THEN
               SELECT count(*) INTO l_n FROM sfd_file
                WHERE sfd01=g_edg01
                  AND sfd02=g_edg02
                  AND sfdconf='N'
            ELSE
                SELECT count(*) INTO l_n FROM sfd_file
                 WHERE sfd01 = g_edg01
                   AND sfdconf = 'N'
            END IF
            IF l_n = 0 THEN
               CALL cl_err(g_edg01,'asf-432',1)
               NEXT FIELD edg01
            END IF
            IF NOT cl_null(g_edg02) THEN
               CALL i412_edg01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD edg01
               END IF
               LET l_n=0
               SELECT count(*) INTO l_n FROM edg_file
                WHERE edg01=g_edg01 AND edg02=g_edg02
               IF l_n > 0 THEN CALL cl_err('',-239,0) NEXT FIELD edg01 END IF
            END IF
         END IF
 
     AFTER FIELD edg02
      IF NOT cl_null(g_edg02) THEN
         LET l_n = 0
         SELECT count(*) INTO l_n FROM sfd_file
          WHERE sfd01=g_edg01
            AND sfd02=g_edg02
            AND sfdconf='N'
         IF l_n = 0 THEN
            CALL cl_err(g_edg01,'abx-064',1)
            NEXT FIELD edg02
         END IF
         IF NOT cl_null(g_edg01) THEN
            CALL i412_edg01()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD edg02
            END IF
            LET l_n=0
            SELECT count(*) INTO l_n FROM edg_file
             WHERE edg01=g_edg01 AND edg02=g_edg02
            IF l_n > 0 THEN CALL cl_err('',-239,0) NEXT FIELD edg02 END IF
         END IF
      END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(edg01) OR INFIELD(edg02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_edg"
               LET g_qryparam.default1 = g_edg01
               LET g_qryparam.default2 = g_edg02
               CALL cl_create_qry() RETURNING g_edg01,g_edg02
               DISPLAY g_edg01 TO edg01
               DISPLAY g_edg02 TO edg02
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

FUNCTION i412_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i412_curs()                    #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_edg01 TO NULL
      RETURN
   END IF
 
   OPEN i412_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_edg01 TO NULL
   ELSE
      OPEN i412_count
      FETCH i412_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i412_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i412_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i412_b_curs INTO g_edg01,g_edg02
       WHEN 'P' FETCH PREVIOUS i412_b_curs INTO g_edg01,g_edg02
       WHEN 'F' FETCH FIRST    i412_b_curs INTO g_edg01,g_edg02
       WHEN 'L' FETCH LAST     i412_b_curs INTO g_edg01,g_edg02
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
           FETCH ABSOLUTE g_jump i412_b_curs INTO g_edg01,g_edg02
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_edg01,SQLCA.sqlcode,0)
      INITIALIZE g_edg01 TO NULL
   ELSE
      CALL i412_show()
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
 
FUNCTION i412_show()
 
   SELECT DISTINCT edg01,edg02,edgorig,edgoriu,edguser,
                   edggrup,edgmodu,edgdate,edgacti
     INTO g_edg01,g_edg02,g_edg1.edgorig,g_edg1.edgoriu,
          g_edg1.edguser,g_edg1.edggrup,g_edg1.edgmodu,g_edg1.edgdate,g_edg1.edgacti
     FROM edg_file
    WHERE edg01=g_edg01
      AND edg02=g_edg02
   IF SQLCA.sqlcode THEN
      LET g_edg01=NULL
      LET g_edg02=NULL LET g_sfd07=NULL
      LET g_sfd03=NULL LET g_sfdconf=NULL
      INITIALIZE g_edg1.* TO NULL 
   END IF
   
   DISPLAY g_edg01 TO edg01               #單頭
   DISPLAY g_edg02 TO edg02
   DISPLAY BY NAME g_edg1.edgorig,g_edg1.edgoriu,
                   g_edg1.edguser,g_edg1.edggrup,g_edg1.edgmodu,g_edg1.edgdate,g_edg1.edgacti,
                   g_edg1.edgoriu,g_edg1.edgorig    #TQC-B30055
   CALL i412_edg01()
   CALL i412_b_fill(g_wc)                 #單身
   IF g_edg[1].edg03 > 0 THEN
      CALL i412_b_fill_2(g_edg[1].edg03)
   END IF
   CALL i412_show_pic()
   CALL cl_show_fld_cont()                   
 
END FUNCTION
 
FUNCTION i412_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_edg01 IS NULL THEN
      CALL cl_err("",-400,0)                 
      RETURN
   END IF

   IF g_sfdconf MATCHES '[YX]' THEN CALL cl_err('','alm-639',1) RETURN END IF

   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL 
       LET g_doc.column1 = "edg01" 
       LET g_doc.value1 = g_edg01
       CALL cl_del_doc() 
      DELETE FROM edg_file WHERE edg01 = g_edg01
                             AND edg02 = g_edg02
      DELETE FROM edh_file WHERE edh01 = g_edg01
                             AND edh011= g_edg02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","edh_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)  
      ELSE
         CLEAR FORM
         CALL g_edg.clear()
         CALL g_edh.clear()
         OPEN i412_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i412_b_curs
            CLOSE i412_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i412_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i412_b_curs
            CLOSE i412_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i412_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i412_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i412_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i412_b()
DEFINE l_ac_t,l_ac2_t  LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n,l_n2,l_i    LIKE type_file.num5,                #檢查重複用  
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_cmd           LIKE type_file.chr1000,             #可新增否  
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE l_flag          LIKE type_file.chr1   
DEFINE l_edgacti       LIKE edg_file.edgacti 
DEFINE l_buf           LIKE type_file.chr50
DEFINE l_case          STRING                 #FUN-910088--add--
DEFINE l_act_controls  LIKE type_file.chr1    #TQC-C30136

 
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_edg01 IS NULL THEN RETURN END IF
   IF g_sfdconf MATCHES '[YX]' THEN CALL cl_err('','alm-638',1) RETURN END IF
   SELECT ima55 INTO g_ima55 FROM ima_file,sfb_file
    WHERE sfb01=g_sfd03 AND sfb05=ima01
   CALL cl_opmsg('b')
   LET g_forupd_sql =
        "SELECT edg03,edg04,edg45,edg06,'',edg14,edg13,edg16,edg15,", 
        "       edg49,edg50,edg51,edg05,edg66,edg52,edg67,edg321,edg53,edg54,edg55,",
        "       edg56,edg58,edg62,edg63,edg65,edg12,edg34,edg64 FROM edg_file ", 
        " WHERE edg01 = ? AND edg02 = ? AND edg03 = ? FOR UPDATE" 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i412_edg_bcl CURSOR FROM g_forupd_sql
   
   LET g_forupd_sql = "SELECT * FROM edh_file ",
      "   WHERE edh01=?  AND edh011=? AND edh013=? ", 
      "     AND edh02=?  AND edh03 =? AND edh04 =? ",
      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i412_edh_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_flag = 'N'
   WHILE TRUE
    
   DIALOG ATTRIBUTES(UNBUFFERED)
    INPUT ARRAY g_edg FROM s_edg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        LET l_act_controls = TRUE   #TQC-C30136
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(l_ac)
        END IF
        LET g_b_flag = '1'     #TQC-D40025 Add
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = DIALOG.getCurrentRow("s_edg") 
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_edg_t.* = g_edg[l_ac].*  #BACKUP
            LET g_edg58_t = g_edg[l_ac].edg58    #FUN-910088--add--
            LET l_sql = "SELECT edg01,edg02,edg03 FROM edg_file",
                        " WHERE edg01 = '",g_edg01,"' ",
                        "   AND edg02 = '",g_edg02,"' ",
                        "   AND edg03 = '",g_edg_t.edg03,"' "
            PREPARE i412_prepare_r FROM l_sql
            EXECUTE i412_prepare_r INTO g_edg01,g_edg02,g_edg[l_ac].edg03
            OPEN i412_edg_bcl USING g_edg01,g_edg02,g_edg[l_ac].edg03
            IF STATUS THEN
               CALL cl_err("OPEN i412_edg_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i412_edg_bcl INTO g_edg[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_edg02_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i412_edg06('d')
                  CALL i412_b_fill_2(g_edg[l_ac].edg03)
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
         CALL i412_b_set_entry()
         CALL i412_b_set_no_entry(p_cmd)
         IF g_sma.sma901 = 'Y' THEN
            CALL i412_set_entry_b(p_cmd)
            CALL i412_set_no_entry_b(p_cmd)
         END IF
        
     BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            CALL g_edh.clear()
            INITIALIZE g_edg[l_ac].* TO NULL 
            LET g_edg[l_ac].edg14 = 0
            LET g_edg[l_ac].edg13 = 0
            LET g_edg[l_ac].edg16 = 0
            LET g_edg[l_ac].edg15 = 0
            LET g_edg[l_ac].edg49 = 0
            LET g_edg[l_ac].edg52 = 'N'
            LET g_edg[l_ac].edg53 = 'N'
            LET g_edg[l_ac].edg54 = 'N'
            LET g_edg[l_ac].edg62 = 1
            LET g_edg[l_ac].edg63 = 1
            LET g_edg[l_ac].edg321= 0
            LET g_edg[l_ac].edg65 = 0
            LET g_edg[l_ac].edg12 = 0
            LET g_edg[l_ac].edg34 = 0
            LET g_edg[l_ac].edg64 = 1
            LET g_edg[l_ac].edg66 = 'Y'
            LET g_edg[l_ac].edg58=g_ima55
            LET g_edg_t.* = g_edg[l_ac].*         #新輸入資料
            LET g_edg58_t = g_edg[l_ac].edg58   #FUN-910088--add--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD edg03

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            IF cl_null(g_edg[l_ac].edg66) THEN
               LET g_edg[l_ac].edg66 = 'Y'
            END IF
            IF cl_null(g_edg[l_ac].edg52) THEN
               LET g_edg[l_ac].edg52 = 'N'
            END IF
            IF cl_null(g_edg[l_ac].edg53) THEN
               LET g_edg[l_ac].edg53 = 'N'
            END IF
            IF cl_null(g_edg[l_ac].edg54) THEN
               LET g_edg[l_ac].edg54 = 'N'
            END IF
            DISPLAY "g_edg[l_ac].edg58=",g_edg[l_ac].edg58
            CALL i412_edg_init()
            IF cl_null(g_edg1.edg66) THEN LET g_edg1.edg66='N' END IF  #jan
            INSERT INTO edg_file VALUES (g_edg1.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","edg_file",g_edg01,g_edg[l_ac].edg03,SQLCA.sqlcode,"","ins edg:",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE FIELD edg03                        #default 序號
            IF g_edg[l_ac].edg03 IS NULL OR
               g_edg[l_ac].edg03 = 0 THEN
               SELECT max(edg03) INTO g_edg[l_ac].edg03 FROM edg_file
                WHERE edg01 = g_edg01
                  AND edg02 = g_edg02
                IF cl_null(g_edg[l_ac].edg03) THEN
                   LET g_edg[l_ac].edg03 = 0
                END IF
                LET g_edg[l_ac].edg03 = g_edg[l_ac].edg03 + g_sma.sma849
            END IF
	
        AFTER FIELD edg03
            IF NOT cl_null(g_edg[l_ac].edg03) THEN
               IF g_edg[l_ac].edg03 != g_edg_t.edg03  OR g_edg_t.edg03  IS NULL OR g_flag='Y' THEN
                  IF g_edg[l_ac].edg03 != g_edg_t.edg03  OR g_edg_t.edg03  IS NULL THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM edg_file
                      WHERE edg03 = g_edg[l_ac].edg03
                        AND edg02= g_edg02
                        AND edg01 = g_edg01
                     IF l_n > 0 THEN 
                        CALL cl_err('',-239,0)
                        NEXT FIELD edg03
                     END IF
                   END IF
                  #FUN-B10056 ------------mark start---------- 
                  #SELECT COUNT(*) INTO l_n FROM sfd_file,sfb_file,ecb_file
                  # WHERE sfd01=g_edg01  AND sfd02=g_edg02 AND sfd03=sfb01
                  #   AND sfb05=ecb01 AND sfb06=ecb02 AND sfd07=ecb012
                  #   AND ecb03=g_edg[l_ac].edg03
                  #IF l_n = 0 THEN CALL cl_err('','aec-301',1) NEXT FIELD edg03 END IF
                  #FUN-B10056 ------------mark end------------   
                   SELECT edg58
                     INTO g_edg[l_ac].edg58
                     FROM edg_file
                    WHERE edg01=g_edg01 AND edg02=g_edg02 AND edg03=g_edg[l_ac].edg03
                   IF cl_null(g_edg[l_ac].edg58) THEN
                      LET g_edg[l_ac].edg58=g_ima55
                   END IF
                   #FUN-910088--add--start--
                   LET l_case = NULL
                   IF NOT i412_edg321_check() THEN
                      LET l_case = 'edg321'
                   END IF
                   IF NOT i412_edg12_check() THEN
                      LET l_case = 'edg12' 
                   END IF
                   LET g_edg58_t = g_edg[l_ac].edg58
                   CASE l_case
                      WHEN "edg321"
                         NEXT FIELD edg321
                      WHEN "edg12"
                         NEXT FIELD edg12
                      OTHERWISE
                         EXIT CASE
                   END CASE
                   #FUN-910088--add--end--
               END IF
            END IF

        AFTER FIELD edg62
            IF NOT cl_null(g_edg[l_ac].edg62) THEN
               IF g_edg[l_ac].edg62 <= 0 THEN
                  CALL cl_err(g_edg[l_ac].edg62,'axr-034',0)
                  NEXT FIELD edg62
               END IF
            END IF

        AFTER FIELD edg63
            IF NOT cl_null(g_edg[l_ac].edg63) THEN
               IF g_edg[l_ac].edg63 <= 0 THEN
                  CALL cl_err(g_edg[l_ac].edg63,'axr-034',0)
                  NEXT FIELD edg63
               END IF
            END IF

        AFTER FIELD edg64
            IF NOT cl_null(g_edg[l_ac].edg64) THEN
               IF g_edg[l_ac].edg64 <= 0 THEN
                  CALL cl_err(g_edg[l_ac].edg64,'axr-034',0)
                  NEXT FIELD edg64
               END IF
            END IF

        AFTER FIELD edg12
           IF NOT i412_edg12_check() THEN NEXT FIELD edg12 END IF   #FUN-910088--add--
          #FUN-910088--mark--start--
          # IF NOT cl_null(g_edg[l_ac].edg12) THEN
          #    IF g_edg[l_ac].edg12 < 0 THEN
          #       CALL cl_err(g_edg[l_ac].edg12,'axm-179',0)
          #       NEXT FIELD edg12
          #    END IF
          # END IF
          #FUN-910088--mark--end--

        AFTER FIELD edg34
            IF NOT cl_null(g_edg[l_ac].edg34) THEN
               IF g_edg[l_ac].edg34 < 0 THEN
                  CALL cl_err(g_edg[l_ac].edg34,'axm-179',0)
                  NEXT FIELD edg34
               END IF
            END IF

        AFTER FIELD edg04
            IF NOT cl_null(g_edg[l_ac].edg04) THEN
               CALL i412_edg04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD edg04
               END IF
            END IF            

        AFTER FIELD edg06    
            IF NOT cl_null(g_edg[l_ac].edg06) THEN
               CALL i412_edg06('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_edg[l_ac].edg06 = g_edg_t.edg06
                  NEXT FIELD edg06
                  DISPLAY BY NAME g_edg[l_ac].edg06
               END IF
            END IF

        AFTER FIELD edg14
            IF g_edg[l_ac].edg14<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edg14
            END IF

        AFTER FIELD edg13
            IF g_edg[l_ac].edg13<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edg13
            END IF

        AFTER FIELD edg16
            IF g_edg[l_ac].edg16<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edg16
            END IF

        AFTER FIELD edg15
            IF g_edg[l_ac].edg15<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edg15
            END IF
        AFTER FIELD edg49
            IF g_edg[l_ac].edg49<0 THEN
               CALL cl_err('','aec-992',0)
               NEXT FIELD edg49
            END IF

        BEFORE FIELD edg50
            IF g_sma.sma901 = 'Y' THEN
                CALL i412_set_entry_b(p_cmd)
                CALL i412_set_no_entry_b(p_cmd)
            END IF
        BEFORE FIELD edg51
            IF g_sma.sma901 = 'Y' THEN
                CALL i412_set_entry_b(p_cmd)
                CALL i412_set_no_entry_b(p_cmd)
            END IF

        AFTER FIELD edg51
            IF g_edg[l_ac].edg51<g_edg[l_ac].edg50 THEN
               CALL cl_err('','aec-993',0)
               NEXT FIELD edg51
            END IF
            
        AFTER FIELD edg05
            IF NOT cl_null(g_edg[l_ac].edg05) THEN
               SELECT COUNT(*) INTO g_cott FROM eci_file
                WHERE eci01 = g_edg[l_ac].edg05
               IF g_cott IS NULL OR g_cott = 0  THEN
                  CALL cl_err('','aec-011',0)
                  LET g_edg[l_ac].edg05 = g_edg_t.edg05
                  NEXT FIELD edg05
                  DISPLAY BY NAME g_edg[l_ac].edg05
               END IF
            END IF

        AFTER FIELD edg66
            IF NOT cl_null(g_edg[l_ac].edg66) THEN
               IF g_edg[l_ac].edg66 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edg66
               END IF
            END IF
            
        BEFORE FIELD edg52
          CALL i412_b_set_entry()

       #AFTER FIELD edg52
        ON CHANGE edg52
            IF NOT cl_null(g_edg[l_ac].edg52) THEN
               IF g_edg[l_ac].edg52 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edg52
               END IF
               CALL i412_b_set_no_entry(p_cmd)
            END IF

        AFTER FIELD edg321
           IF NOT i412_edg321_check() THEN NEXT FIELD edg321 END IF   #FUN-910088--add--
           #FUN-910088--mark--start--
           #  IF NOT cl_null(g_edg[l_ac].edg321) THEN
           #     IF g_edg[l_ac].edg321 < 0 THEN
           #        CALL cl_err('','aec-020',0)
           #         NEXT FIELD edg321
           #     END IF
           # END IF 
           #FUN-910088--mark--end--

        AFTER FIELD edg67 
            IF NOT cl_null(g_edg[l_ac].edg67) THEN
               CALL i412_edg67()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edg[l_ac].edg67,g_errno,0)
                  NEXT FIELD edg67
               END IF
            END IF
        AFTER FIELD edg53
            IF NOT cl_null(g_edg[l_ac].edg53) THEN
               IF g_edg[l_ac].edg53 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edg53
               END IF
            END IF

        BEFORE FIELD edg54
            CALL i412_set_entry_b(p_cmd)

        AFTER FIELD edg54
            IF NOT cl_null(g_edg[l_ac].edg54) THEN
               IF g_edg[l_ac].edg54 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD edg54
               END IF

               IF g_edg[l_ac].edg54 ='N' THEN
                  LET g_edg[l_ac].edg55 = ' '
                  DISPLAY BY NAME g_edg[l_ac].edg55
               END IF

               CALL i412_set_no_entry_b(p_cmd)

            END IF

        AFTER FIELD edg55
            IF NOT cl_null(g_edg[l_ac].edg55) THEN
               CALL i412_sgg(g_edg[l_ac].edg55)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_edg[l_ac].edg55=g_edg_t.edg55
                  NEXT FIELD edg55
                  DISPLAY BY NAME g_edg[l_ac].edg55
               END IF
            END IF

        AFTER FIELD edg56
            IF NOT cl_null(g_edg[l_ac].edg56) THEN
               CALL i412_sgg(g_edg[l_ac].edg56)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_edg[l_ac].edg56=g_edg_t.edg56
                  NEXT FIELD edg56
                  DISPLAY BY NAME g_edg[l_ac].edg56
               END IF
            END IF

        AFTER FIELD edg58
            IF NOT cl_null(g_edg[l_ac].edg58) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                WHERE gfe01=g_edg[l_ac].edg58
               IF g_cnt=0 THEN
                  CALL cl_err(g_edg[l_ac].edg58,'mfg2605',0)
                  NEXT FIELD g_edg58
               END IF
          #FUN-910088--add--start--
               LET l_case = NULL
               IF NOT i412_edg321_check() THEN
                  LET l_case = 'edg321'
               END IF
               IF NOT i412_edg12_check() THEN
                  LET l_case = 'edg12' 
               END IF
               LET g_edg58_t = g_edg[l_ac].edg58
               CASE l_case
                  WHEN "edg321"
                     NEXT FIELD edg321
                  WHEN "edg12"
                     NEXT FIELD edg12
                  OTHERWISE
                     EXIT CASE
               END CASE
          #FUN-910088--add--end--
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_edg_t.edg03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF

               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM edg_file
                WHERE edg01 = g_edg01
                  AND edg02 = g_edg02
                  AND edg03 = g_edg_t.edg03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","edg_file",g_edg01,g_edg02,SQLCA.sqlcode,"","",1) 
                     ROLLBACK WORK
                     CANCEL DELETE
                  ELSE
                     DELETE FROM edh_file
                      WHERE edh01=g_edg01 
                        AND edh011=g_edg02
                        AND edh013=g_edg_t.edg03
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","edh_file",g_edg01,g_edg02,SQLCA.sqlcode,"","",1) 
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
               LET g_edg[l_ac].* = g_edg_t.*
               CLOSE i412_edg_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF

            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_edg[l_ac].edg03,-263,1)
               LET g_edg[l_ac].* = g_edg_t.*
            ELSE

               IF cl_null(g_edg[l_ac].edg66) THEN
                  LET g_edg[l_ac].edg66 = 'Y'
               END IF
               IF cl_null(g_edg[l_ac].edg52) THEN
                  LET g_edg[l_ac].edg52 = 'N'
               END IF
               IF cl_null(g_edg[l_ac].edg53) THEN
                  LET g_edg[l_ac].edg53 = 'N'
               END IF
               IF cl_null(g_edg[l_ac].edg54) THEN
                  LET g_edg[l_ac].edg54 = 'N'
               END IF

               UPDATE edg_file SET edg03=g_edg[l_ac].edg03,
                                   edg04=g_edg[l_ac].edg04,
                                   edg45=g_edg[l_ac].edg45,
                                   edg06=g_edg[l_ac].edg06,
                                   edg14=g_edg[l_ac].edg14,
                                   edg13=g_edg[l_ac].edg13,
                                   edg16=g_edg[l_ac].edg16,
                                   edg15=g_edg[l_ac].edg15,
                                   edg49=g_edg[l_ac].edg49,
                                   edg50=g_edg[l_ac].edg50,
                                   edg51=g_edg[l_ac].edg51,
                                   edg05=g_edg[l_ac].edg05,
                                   edg66=g_edg[l_ac].edg66,
                                   edg52=g_edg[l_ac].edg52,
                                   edg67=g_edg[l_ac].edg67,
                                   edg53=g_edg[l_ac].edg53,
                                   edg54=g_edg[l_ac].edg54,
                                   edg55=g_edg[l_ac].edg55,
                                   edg56=g_edg[l_ac].edg56,
                                   edg58=g_edg[l_ac].edg58,
                                   edg62 =g_edg[l_ac].edg62,
                                   edg63 =g_edg[l_ac].edg63,
                                   edg321=g_edg[l_ac].edg321,
                                   edg65 =g_edg[l_ac].edg65,
                                   edg12 =g_edg[l_ac].edg12,
                                   edg34 =g_edg[l_ac].edg34,
                                   edg64 =g_edg[l_ac].edg64
                WHERE edg01=g_edg01
                  AND edg02=g_edg02
                  AND edg03=g_edg_t.edg03

               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","edg_file",g_edg01,g_edg_t.edg03,SQLCA.sqlcode,"","",1) 
                  LET g_edg[l_ac].* = g_edg_t.*
               ELSE 
                  UPDATE edg_file SET edgmodu=g_user,edgdate=g_today
                   WHERE edg01=g_edg01 AND edg02=g_edg02
                  #FUN-A80060--begin--add------
                  IF g_edg[l_ac].edg04 <> g_edg_t.edg04 THEN
                     UPDATE edh_file SET edh09=g_edg[l_ac].edg04 
                      WHERE edh01=g_edg01 AND edh011=g_edg02 AND edh013=g_edg_t.edg03
                  END IF
                  #FUN-A80060--end--add--------
               END IF
              
            END IF

        AFTER ROW
            LET l_ac = DIALOG.getCurrentRow("s_edg")
           #LET l_ac_t = l_ac              #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_edg[l_ac].* = g_edg_t.*
               END IF
               CLOSE i412_edg_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            LET l_ac_t = l_ac              #FUN-D40030 Add
            CLOSE i412_edg_bcl
            COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(edg05)                 #機械編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_eci"
                   LET g_qryparam.default1 = g_edg[l_ac].edg05
                   CALL cl_create_qry() RETURNING g_edg[l_ac].edg05
                    DISPLAY BY NAME g_edg[l_ac].edg05 
                   NEXT FIELD edg05
              WHEN INFIELD(edg06)                 #生產站別
                   CALL q_eca(FALSE,TRUE,g_edg[l_ac].edg06) RETURNING g_edg[l_ac].edg06
                    DISPLAY BY NAME g_edg[l_ac].edg06 
                   NEXT FIELD edg06
              WHEN INFIELD(edg04)                 #作業編號
                   CALL q_ecd(FALSE,TRUE,g_edg[l_ac].edg04) RETURNING g_edg[l_ac].edg04
                   DISPLAY BY NAME g_edg[l_ac].edg04 
                   NEXT FIELD edg04
              WHEN INFIELD(edg55)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_edg[l_ac].edg55
                   CALL cl_create_qry() RETURNING g_edg[l_ac].edg55
                    DISPLAY BY NAME g_edg[l_ac].edg55 
                   NEXT FIELD edg55
              WHEN INFIELD(edg56)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgg"
                   LET g_qryparam.default1 = g_edg[l_ac].edg56
                   CALL cl_create_qry() RETURNING g_edg[l_ac].edg56
                    DISPLAY BY NAME g_edg[l_ac].edg56
                   NEXT FIELD edg56
              WHEN INFIELD(edg58)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = g_edg[l_ac].edg58
                   CALL cl_create_qry() RETURNING g_edg[l_ac].edg58
                   DISPLAY BY NAME g_edg[l_ac].edg58
                   NEXT FIELD edg58
              WHEN INFIELD(edg67) #廠商編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc"
                   LET g_qryparam.default1 = g_edg[l_ac].edg67
                   CALL cl_create_qry() RETURNING g_edg[l_ac].edg67
                   DISPLAY g_edg[l_ac].edg67 TO s_edg[l_ac].edg67
                   NEXT FIELD edg67 
           END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(edg03) AND l_ac > 1 THEN
                LET g_edg[l_ac].* = g_edg[l_ac-1].*
                NEXT FIELD edg03
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

    #    ON ACTION CONTROLG        #TQC-C30136
    #        CALL cl_cmdask()      #TQC-C30136


        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

    # ON ACTION controls                       #TQC-C30136
    #    CALL cl_set_head_visible("","AUTO")   #TQC-C30136

    END INPUT

    INPUT ARRAY g_edh FROM s_edh.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            LET l_act_controls = FALSE   #TQC-C30136
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM edg_file WHERE edg01=g_edg01 AND edg02=g_edg02
               AND edg03=g_edg[l_ac].edg03
            IF l_cnt=0 THEN LET l_flag = 'Y' EXIT DIALOG END IF
            CALL i412_b_fill_2(g_edg[l_ac].edg03)
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            LET g_b_flag = '2'     #TQC-D40025 Add

        BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = DIALOG.getCurrentRow("s_edh")
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n2  = ARR_COUNT()
            IF g_rec_b2 >= l_ac2 THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_edh_t.* = g_edh[l_ac2].*  #BACKUP
               LET g_edh_o.* = g_edh[l_ac2].*
               LET g_edh10_t = g_edh[l_ac2].edh10   #FUN-910088--add--
                OPEN i412_edh_bcl USING g_edg01,g_edg02,g_edg[l_ac].edg03,g_edh_t.edh02,g_edh_t.edh03,g_edh_t.edh04 
                IF STATUS THEN
                    CALL cl_err("OPEN i412_edh_bcl:", STATUS, 1)
                ELSE
                    FETCH i412_edh_bcl INTO b_edh.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_edh_t.edh02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL i412_b_move_to()
                    END IF
                    SELECT ima02,ima021,ima08 INTO g_edh[l_ac2].ima02_b,
                           g_edh[l_ac2].ima021_b,g_edh[l_ac2].ima08_b
                      FROM ima_file
                     WHERE ima01=g_edh[l_ac2].edh03
                END IF
                CALL cl_show_fld_cont()  
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            CALL i412_b_move_back() 
            LET b_edh.edh33 = '0'     
            INSERT INTO edh_file VALUES (b_edh.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","edh_file",g_edg01,g_edg02,SQLCA.sqlcode,"","",1) 
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
            INITIALIZE g_edh[l_ac2].* TO NULL     
            LET g_edh15 ='N'
            LET g_edh11 = NULL 
            LET g_edh[l_ac2].edh31 = 'N'
            LET g_edh18 = 0     LET g_edh17 = 'N'
            LET g_edh28 = 0 # 誤差容許率預設值應為 0
            LET g_edh10_fac = 1 LET g_edh10_fac2 = 1
            LET g_edh[l_ac2].edh16 = '0'
            LET g_edh[l_ac2].edh14 = '0'
            LET g_edh[l_ac2].edh30 = ' '
            LET g_edh[l_ac2].edh04 = g_today #Body default
            LET g_edh[l_ac2].edh06 = 1 
            LET g_edh[l_ac2].edh07 = 1 
            LET g_edh[l_ac2].edh08 = 0  
            LET g_edh[l_ac2].edh19 = '1'
            LET g_edh[l_ac2].edh081= 0
            LET g_edh[l_ac2].edh082= 1
            LET g_edh10_t = NULL   #FUN-910088--add--
            SELECT edg04 INTO g_edh[l_ac2].edh09 FROM edg_file
             WHERE edg01=g_edg01 AND edg02=g_edg02
               AND edg03=g_edg[l_ac].edg03
            LET g_edh_t.* = g_edh[l_ac2].*         #新輸入資料
            LET g_edh_o.* = g_edh[l_ac2].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD edh02

        BEFORE FIELD edh02                        #default 項次
            IF g_edh[l_ac2].edh02 IS NULL OR g_edh[l_ac2].edh02 = 0 THEN
                SELECT max(edh02)
                   INTO g_edh[l_ac2].edh02
                   FROM edh_file
                   WHERE edh01 = g_edg01
                     AND edh011 = g_edg02
                     AND edh013= g_edg[l_ac].edg03
                IF g_edh[l_ac2].edh02 IS NULL
                   THEN LET g_edh[l_ac2].edh02 = 0
                END IF
                LET g_edh[l_ac2].edh02 = g_edh[l_ac2].edh02 + g_sma.sma19
            END IF
 
        AFTER FIELD edh02                        #default 項次
            IF g_edh[l_ac2].edh02 IS NOT NULL AND
               g_edh[l_ac2].edh02 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM edh_file
                      WHERE edh01=g_edg01
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03
                        AND edh02=g_edh[l_ac2].edh02
               IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD edh02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b2
                       IF l_i <> l_ac2 THEN
                         IF g_edh[l_i].edh02 = g_edh[l_ac2].edh02 AND g_edh[l_i].edh04 <> g_edh[l_ac2].edh04 THEN
                            LET g_edh[l_i].edh05 = g_edh[l_ac2].edh04
                            DISPLAY BY NAME g_edh[l_i].edh04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF
            END IF
             #若有更新項次時,插件位置的key值更新為變動后的項次
             IF p_cmd = 'u' AND (g_edh[l_ac2].edh02 != g_edh_t.edh02) THEN
                SELECT COUNT(*) INTO l_n FROM edh_file
                       WHERE edh01=g_edg01
                         AND edh011= g_edg02
                         AND edh013= g_edg[l_ac].edg03  
                         AND edh02=g_edh[l_ac2].edh02 
                IF l_n>0 THEN
                  IF NOT cl_confirm('mfg-002') THEN 
                     NEXT FIELD edh02 
                  ELSE
                     FOR l_i = 1 TO g_rec_b2
                       IF l_i <> l_ac2 THEN
                         IF g_edh[l_i].edh02 = g_edh[l_ac2].edh02 AND g_edh[l_i].edh04 <> g_edh[l_ac2].edh04 THEN
                            LET g_edh[l_i].edh05 = g_edh[l_ac2].edh04
                            DISPLAY BY NAME g_edh[l_i].edh04
                         END IF
                       END IF
                     END FOR
                  END IF
                END IF
             END IF

        AFTER FIELD edh03                         #(元件料件)
               IF cl_null(g_edh[l_ac2].edh03) THEN
                  LET g_edh[l_ac2].edh03=g_edh_t.edh03
               END IF
               IF NOT cl_null(g_edh[l_ac2].edh03) THEN  
                  LET l_case = NULL   #FUN-910088--add--
                   IF cl_null(g_edh_t.edh03) OR g_edh_t.edh03 <> g_edh[l_ac2].edh03 THEN 
#FUN-AB0059 ---------------------start----------------------------
                      IF NOT s_chk_item_no(g_edh[l_ac2].edh03,"") THEN
                         CALL cl_err('',g_errno,1)
                         LET g_edh[l_ac2].edh03= g_edh_t.edh03
                         NEXT FIELD edh03
                      END IF
#FUN-AB0059 ---------------------end-------------------------------
                      LET l_n =0
                      SELECT COUNT(*) INTO l_n FROM sfb_file
                       WHERE sfb01=g_sfd03
                         AND sfb05=g_edh[l_ac2].edh03
                      IF l_n > 0 THEN
                         CALL cl_err(g_edh[l_ac2].edh03,'aec-059',0)
                         NEXT FIELD edh03
                      END IF
                      SELECT COUNT(*) INTO l_n FROM edh_file
                             WHERE edh01=g_edg01
                               AND edh011= g_edg02
                               AND edh013= g_edg[l_ac].edg03
                               AND edh03=g_edh[l_ac2].edh03
                      IF l_n>0 THEN
                         IF NOT cl_confirm('abm-728') THEN NEXT FIELD edh03 END IF
                      END IF
                   END IF
                   CALL i412_edh03(p_cmd)    #必需讀取(料件主檔) 
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_edh[l_ac2].edh03=g_edh_t.edh03
                      NEXT FIELD edh03
                   END IF
                   IF p_cmd = 'a' THEN LET g_edh15 = g_ima70_b END IF
                   IF g_edh[l_ac2].edh10 IS NULL OR g_edh[l_ac2].edh10 = ' '
                              OR g_edh[l_ac2].edh03 != g_edh_t.edh03
                             THEN LET g_edh[l_ac2].edh10 = g_ima63_b
                      #FUN-910088--add--start--  
                         IF NOT cl_null(g_edh[l_ac2].edh081) AND g_edh[l_ac2].edh081 <> 0 THEN    #FUN-C20068--add--
                            IF NOT i412_edh081_check() THEN
                               LET l_case = "edh081" 
                            END IF
                         END IF                                                                   #FUN-C20068--add--
                      #FUN-910088--add--end--
                   END IF
                   IF g_ima08_b = 'D' THEN
                      LET g_edh17 = 'Y'
                      ELSE LET g_edh17 = 'N'
                   END IF
                 #FUN-910088--add--start--
                   LET g_edh10_t = g_edh[l_ac2].edh10
                   IF NOT cl_null(l_case) AND l_case = "edh081" THEN
                      NEXT FIELD edh081
                   END IF
                 #FUN-910088--add--end--
               END IF

        AFTER FIELD edh04                        #check 是否重復
            IF NOT cl_null(g_edh[l_ac2].edh04) THEN
               IF NOT cl_null(g_edh[l_ac2].edh05) THEN
                  IF g_edh[l_ac2].edh05 < g_edh[l_ac2].edh04 THEN 
                     CALL cl_err(g_edh[l_ac2].edh04,'mfg2604',0)
                     NEXT FIELD edh04
                  END IF
               END IF
                IF g_edh[l_ac2].edh04 IS NOT NULL AND
                   (g_edh[l_ac2].edh04 != g_edh_t.edh04 OR
                    g_edh_t.edh04 IS NULL OR
                    g_edh[l_ac2].edh02 != g_edh_t.edh02 OR
                    g_edh_t.edh02 IS NULL OR
                    g_edh[l_ac2].edh03 != g_edh_t.edh03 OR
                    g_edh_t.edh03 IS NULL) THEN
                    SELECT count(*) INTO l_n
                        FROM edh_file
                        WHERE edh01 = g_edg01
                           AND edh011= g_edg02
                           AND edh013= g_edg[l_ac].edg03
                           AND edh02 = g_edh[l_ac2].edh02
                           AND edh03 = g_edh[l_ac2].edh03
                           AND edh04 = g_edh[l_ac2].edh04
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_edh[l_ac2].edh02 = g_edh_t.edh02
                        LET g_edh[l_ac2].edh03 = g_edh_t.edh03
                        LET g_edh[l_ac2].edh04 = g_edh_t.edh04
                        DISPLAY BY NAME g_edh[l_ac2].edh02 
                        DISPLAY BY NAME g_edh[l_ac2].edh03
                        DISPLAY BY NAME g_edh[l_ac2].edh04
                        NEXT FIELD edh02
                    END IF
                END IF
                CALL i412_bdate(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_edh[l_ac2].edh04,g_errno,0)
                   LET g_edh[l_ac2].edh04 = g_edh_t.edh04
                   DISPLAY BY NAME g_edh[l_ac2].edh04 
                   NEXT FIELD edh04
                END IF
            END IF
           
        AFTER FIELD edh05   #check失效日小于生效日
            IF NOT cl_null(g_edh[l_ac2].edh05) THEN
               IF NOT cl_null(g_edh[l_ac2].edh04) THEN
                  IF g_edh[l_ac2].edh05 < g_edh[l_ac2].edh04 THEN 
                     CALL cl_err(g_edh[l_ac2].edh05,'mfg2604',0)
                     NEXT FIELD edh05
                  END IF
               END IF
                IF g_edh[l_ac2].edh05 IS NOT NULL OR g_edh[l_ac2].edh05 != ' '
                   THEN IF g_edh[l_ac2].edh05 < g_edh[l_ac2].edh04
                          THEN CALL cl_err(g_edh[l_ac2].edh05,'mfg2604',0)
                          NEXT FIELD edh04
                        END IF
                END IF
                CALL i412_edgte(p_cmd)     #生效日
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_edh[l_ac2].edh05,g_errno,0)
                   LET g_edh[l_ac2].edh05 = g_edh_t.edh05
                   DISPLAY BY NAME g_edh[l_ac2].edh05 
                   NEXT FIELD edh04
                END IF
            END IF
 
        AFTER FIELD edh06    #組成用量不可小于零
          IF NOT cl_null(g_edh[l_ac2].edh06) THEN
             IF g_edh[l_ac2].edh14 <> '2' THEN   
                IF g_edh[l_ac2].edh06 <= 0 THEN
                   CALL cl_err(g_edh[l_ac2].edh06,'mfg2614',0)
                   LET g_edh[l_ac2].edh06 = g_edh_o.edh06
                   DISPLAY BY NAME g_edh[l_ac2].edh06
                   NEXT FIELD edh06
                END IF
             ELSE
               #IF g_edh[l_ac2].edh06 > 0 THEN     #CHI-AC0037
                IF g_edh[l_ac2].edh06 >= 0 THEN    #CHI-AC0037     
                   CALL cl_err('','asf-603',0)
                   NEXT FIELD edh06
                 END IF
             END IF             
          END IF
          LET g_edh_o.edh06 = g_edh[l_ac2].edh06
 
        AFTER FIELD edh07    #底數不可小于等于零
            IF NOT cl_null(g_edh[l_ac2].edh07) THEN
                IF g_edh[l_ac2].edh07 <= 0
                 THEN CALL cl_err(g_edh[l_ac2].edh07,'mfg2615',0)
                      LET g_edh[l_ac2].edh07 = g_edh_o.edh07
                      DISPLAY BY NAME g_edh[l_ac2].edh07
                      NEXT FIELD edh07
                END IF
                LET g_edh_o.edh07 = g_edh[l_ac2].edh07
            ELSE
               CALL cl_err(g_edh[l_ac2].edh07,'mfg3291',0)
               LET g_edh[l_ac2].edh07 = g_edh_o.edh07
               NEXT FIELD edh07
            END IF
 
        AFTER FIELD edh08    #損耗率
            IF NOT cl_null(g_edh[l_ac2].edh08) THEN
                IF g_edh[l_ac2].edh08 < 0 OR g_edh[l_ac2].edh08 > 100
                 THEN CALL cl_err(g_edh[l_ac2].edh08,'mfg4063',0)
                      LET g_edh[l_ac2].edh08 = g_edh_o.edh08
                      NEXT FIELD edh08
                END IF
                LET g_edh_o.edh08 = g_edh[l_ac2].edh08
            END IF
            IF cl_null(g_edh[l_ac2].edh08) THEN
                LET g_edh[l_ac2].edh08 = 0
            END IF
            DISPLAY BY NAME g_edh[l_ac2].edh08
            
        AFTER FIELD edh081    #固定損耗量
           IF NOT i412_edh081_check() THEN NEXT FIELD edh081 END IF   #FUN-910088--add--
         #FUN-910088--mark--start--
         #  IF NOT cl_null(g_edh[l_ac2].edh081) THEN
         #      IF g_edh[l_ac2].edh081 < 0 THEN 
         #         CALL cl_err(g_edh[l_ac2].edh081,'aec-020',0)
         #         LET g_edh[l_ac2].edh081 = g_edh_o.edh081
         #         NEXT FIELD edh081
         #      END IF
         #      LET g_edh_o.edh081 = g_edh[l_ac2].edh081
         #  END IF
         #  IF cl_null(g_edh[l_ac2].edh081) THEN
         #      LET g_edh[l_ac2].edh081 = 0
         #  END IF
         #  DISPLAY BY NAME g_edh[l_ac2].edh081
         #FUN-910088--mark--end--
            
        AFTER FIELD edh082    #損耗批量
            IF NOT cl_null(g_edh[l_ac2].edh082) THEN
                IF g_edh[l_ac2].edh082 <= 0 THEN 
                   CALL cl_err(g_edh[l_ac2].edh082,'alm-808',0)
                   LET g_edh[l_ac2].edh082 = g_edh_o.edh082
                   NEXT FIELD edh082
                END IF
                LET g_edh_o.edh082 = g_edh[l_ac2].edh082
            END IF
            IF cl_null(g_edh[l_ac2].edh082) THEN
                LET g_edh[l_ac2].edh082 = 1
            END IF
            DISPLAY BY NAME g_edh[l_ac2].edh082
 
        AFTER FIELD edh10   #發料單位
           IF g_edh[l_ac2].edh10 IS NULL OR g_edh[l_ac2].edh10 = ' '
             THEN LET g_edh[l_ac2].edh10 = g_edh_o.edh10
             DISPLAY BY NAME g_edh[l_ac2].edh10
             ELSE 
                 IF ((g_edh_o.edh10 IS NULL) OR (g_edh_t.edh10 IS NULL)
                      OR (g_edh[l_ac2].edh10 != g_edh_o.edh10)) THEN
                    CALL i412_edh10()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_edh[l_ac2].edh10,g_errno,0)
                       LET g_edh[l_ac2].edh10 = g_edh_o.edh10
                       DISPLAY BY NAME g_edh[l_ac2].edh10 
                       NEXT FIELD edh10
                     ELSE IF g_edh[l_ac2].edh10 != g_ima25_b
                            THEN CALL s_umfchk(g_edh[l_ac2].edh03,
                                 g_edh[l_ac2].edh10,g_ima25_b)
                                 RETURNING g_sw,g_edh10_fac  #發料/庫存單位
                                 IF g_sw THEN
                                   CALL cl_err(g_edh[l_ac2].edh10,'mfg2721',0)
                                   LET g_edh[l_ac2].edh10 = g_edh_o.edh10
                                   DISPLAY BY NAME g_edh[l_ac2].edh10 
                                   NEXT FIELD edh10
                                 END IF
                            ELSE   LET g_edh10_fac  = 1
                            END  IF
                            IF g_edh[l_ac2].edh10 != g_ima86_b  #發料/成本單位
                            THEN CALL s_umfchk(g_edh[l_ac2].edh03,
                                         g_edh[l_ac2].edh10,g_ima86_b)
                                 RETURNING g_sw,g_edh10_fac2
                                 IF g_sw THEN
                                   CALL cl_err(g_edh[l_ac2].edh03,'mfg2722',0)
                                   LET g_edh[l_ac2].edh10 = g_edh_o.edh10
                                   DISPLAY BY NAME g_edh[l_ac2].edh10 
                                   NEXT FIELD edh10
                                 END IF
                            ELSE LET g_edh10_fac2 = 1
                          END IF
                       END IF
                  END IF
         #FUN-910088--add--start--  
            IF NOT cl_null(g_edh[l_ac2].edh081) AND g_edh[l_ac2].edh081 <> 0 THEN
               IF NOT i412_edh081_check() THEN
                  LET g_edh10_t = g_edh[l_ac2].edh10
                  LET g_edh_o.edh10 = g_edh[l_ac2].edh10
                  NEXT FIELD edh081
               END IF
               LET g_edh10_t = g_edh[l_ac2].edh10
            END IF
         #FUN-910088--add--end--
          END IF
          LET g_edh_o.edh10 = g_edh[l_ac2].edh10
 

        BEFORE DELETE                            #是否取消單身
            IF g_edh_t.edh02 > 0 AND
               g_edh_t.edh02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM edh_file
                    WHERE edh01 = g_edg01
                      AND edh011= g_edg02
                      AND edh013= g_edg[l_ac].edg03               
                      AND edh02 = g_edh_t.edh02
                      AND edh03 = g_edh_t.edh03
                      AND edh04 = g_edh_t.edh04
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 OR g_success='N' THEN
                    LET l_buf = g_edh_t.edh02 clipped,'+',
                                g_edh_t.edh03 clipped,'+',
                                g_edh_t.edh04
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
               LET g_edh[l_ac2].* = g_edh_t.*
               CLOSE i412_edh_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_edh[l_ac2].edh02,-263,1)
                LET g_edh[l_ac2].* = g_edh_t.*
            ELSE
                CALL i412_b_move_back() 
                UPDATE edh_file SET * = b_edh.*
                 WHERE edh01 = g_edg01
                   AND edh011= g_edg02
                   AND edh013= g_edg[l_ac].edg03
                   AND edh02 = g_edh_t.edh02
                   AND edh03 = g_edh_t.edh03
                   AND edh04 = g_edh_t.edh04
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","edh_file",g_edg01,g_edg02,SQLCA.sqlcode,"","",1) 
                    LET g_edh[l_ac2].* = g_edh_t.*
                    
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_edh")
           #LET l_ac2_t = l_ac2          #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_edh[l_ac2].* = g_edh_t.*
               END IF
               CLOSE i412_edh_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
           #FUN-D40030--mark--str--
           #IF cl_null(g_edh[l_ac2].edh02) OR 
           #   cl_null(g_edh[l_ac2].edh03) THEN
           #   CALL g_edh.deleteElement(l_ac2)
           #END IF
           #FUN-D40030--mark--end--
            LET l_ac2_t = l_ac2          #FUN-D40030 Add
            CLOSE i412_edh_bcl
            COMMIT WORK
 
     ON ACTION CONTROLP
           CASE WHEN INFIELD(edh03) #料件主檔
#FUN-AB0025---------mod---------------str----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima01"   
#               LET g_qryparam.default1 = g_edh[l_ac2].edh03
#               CALL cl_create_qry() RETURNING g_edh[l_ac2].edh03
                CALL q_sel_ima(FALSE, "q_ima01","",g_edh[l_ac2].edh03,"","","","","",'' )
                  RETURNING g_edh[l_ac2].edh03 
#FUN-AB0025--------mod---------------end----------------
                DISPLAY g_edh[l_ac2].edh03 TO edh03
                NEXT FIELD edh03
               WHEN INFIELD(edh10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_edh[l_ac2].edh10
                  CALL cl_create_qry() RETURNING g_edh[l_ac2].edh10
                  DISPLAY g_edh[l_ac2].edh10 TO edh10
                  NEXT FIELD edh10
               OTHERWISE EXIT CASE
           END  CASE
  
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(edh02) AND l_ac2 > 1 THEN
               LET g_edh[l_ac2].* = g_edh[l_ac2-1].*
               LET g_edh[l_ac2].edh04 = g_today
               LET g_edh[l_ac2].edh02 = NULL
               LET g_edh[l_ac2].edh05 = NULL  
               NEXT FIELD edh02
           END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
       #ON ACTION CONTROLG      #TQC-C30136
       #    CALL cl_cmdask()    #TQC-C30136
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

    END INPUT
    #TQC-D40025--add--begin--
    BEFORE DIALOG
      CASE g_b_flag
           WHEN '1' NEXT FIELD edg03
           WHEN '2' NEXT FIELD edh02
      END CASE
    #TQC-D40025--add--end---
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
        #####TQC-C30136---add---str#####
        IF NOT cl_null(l_act_controls) AND l_act_controls THEN
           CALL cl_set_head_visible("","AUTO") 
        ELSE
        #####TQC-C30136---add---end#####
           CALL cl_set_head_visible("main,language,info","AUTO")
        END IF                                                     #TQC-C30136
  
     ON ACTION accept
        ACCEPT DIALOG

     ON ACTION cancel
        #TQC-D40025--------ADD----STR
        LET INT_FLAG = 0
        IF g_b_flag = '1' THEN
            IF p_cmd = 'u' THEN
               LET g_edg[l_ac].* = g_edg_t.*
            ELSE
               CALL g_edg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
               END IF
            END IF
            CLOSE i412_edg_bcl
            ROLLBACK WORK
         END IF
         IF g_b_flag = '2' THEN
            IF p_cmd = 'u' THEN
               LET g_edh[l_ac2].* = g_edh_t.*
            ELSE
               CALL g_edh.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
               END IF 
            END IF
            CLOSE i412_edh_bcl
            ROLLBACK WORK
         END IF
        #TQC-D40025--------ADD----END 
        EXIT DIALOG
     END DIALOG
    CLOSE i412_edg_bcl
    CLOSE i412_edh_bcl
    COMMIT WORK
    CALL i412_show()
    IF l_flag = 'Y' THEN  LET l_flag = 'N' CONTINUE WHILE END IF
    EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i412_b_fill(p_wc)              #BODY FILL UP
 
DEFINE p_wc            LIKE type_file.chr1000 
 
   IF cl_null(p_wc) THEN
      LET p_wc = " 1=1"
   END IF
   LET g_sql =
        "SELECT edg03,edg04,edg45,edg06,eca02,", 
        "       edg14,edg13,edg16,edg15,", 
        "       edg49,edg50,edg51,edg05,edg66,",
        "       edg52,edg67,edg321,edg53,edg54,edg55,edg56,edg58,",
        "       edg62,edg63,edg65,edg12,edg34,edg64      ",
        " FROM edg_file LEFT OUTER JOIN eca_file ON edg06 = eca01",
        " WHERE edg01 = '",g_edg01,"'",
        "   AND edg02 = '",g_edg02,"'",
        "   AND ",p_wc CLIPPED,
        " ORDER BY edg03" 
    PREPARE i412_pb FROM g_sql
    DECLARE edg_curs CURSOR FOR i412_pb
    
    CALL g_edg.clear()

    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH edg_curs INTO g_edg[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_edg.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i412_b_fill_2(p_edg03)              #BODY FILL UP
DEFINE  
    p_edg03    LIKE edg_file.edg03 
 
    IF cl_null(g_wc2) THEN LET  g_wc2=' 1=1' END IF
    LET g_sql =
        "SELECT edh02,edh30,edh03,ima02,ima021,ima08,edh09,edh16,edh14,edh04,edh05,edh06,edh07,",
        "       edh10,edh08,edh081,edh082,edh19,edh24,edh13,edh31  ", 
        " FROM edh_file,ima_file",
        " WHERE edh01 ='",g_edg01,"' ",
        "   AND edh011 =",g_edg02,
        "   AND edh013 =",p_edg03,
        "   AND edh03 = ima01 ",
        "   AND edh06 != 0 ",          #組成用量為零就不顯示了
        "   AND ",g_wc2 CLIPPED
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,1,3"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 6,1,3"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
    END CASE
 
    PREPARE i412_pb1 FROM g_sql
    DECLARE edh_curs                       #SCROLL CURSOR
        CURSOR FOR i412_pb1
 
    CALL g_edh.clear()
    LET g_cnt2 = 1
    LET g_rec_b2 = 0
    FOREACH edh_curs INTO g_edh[g_cnt2].*   #單身 ARRAY 填充
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
    CALL g_edh.deleteElement(g_cnt2)
    LET g_rec_b2 = g_cnt2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn3
    LET g_cnt2 = 0
 
END FUNCTION
 
FUNCTION i412_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_edg TO s_edg.* 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag = '1'     #TQC-D40025 Add
 
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_edg")
         LET l_ac2=0
         IF l_ac <> 0 THEN
            CALL i412_b_fill_2(g_edg[l_ac].edg03)
         END IF
      
      ON ACTION accept
         LET g_action_choice = "detail"
         EXIT DIALOG
   END DISPLAY
 
   DISPLAY ARRAY g_edh TO s_edh.* 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'   #TQC-D40025 Add

      BEFORE ROW
         LET l_ac2 = DIALOG.getCurrentRow("s_edh")
      
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
 
      ON ACTION output                         #FUN-A90035 取消mark
         LET g_action_choice="output"          #FUN-A90035
         EXIT DIALOG                           #FUN-A90035
         
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
         CALL i412_show_pic()
 
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

FUNCTION i412_edg04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1 

    LET g_errno = ''
    SELECT ecd01,ecd02 INTO g_edg[l_ac].edg04,g_edg[l_ac].edg45 FROM ecd_file
     WHERE ecd01 = g_edg[l_ac].edg04

    CASE WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'aec-015'
         LET g_edg[l_ac].edg04 = ' '
         LET g_edg[l_ac].edg45 = ' '
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY BY NAME g_edg[l_ac].edg04
    DISPLAY BY NAME g_edg[l_ac].edg45

END FUNCTION

FUNCTION i412_edg06(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_ecaacti       LIKE eca_file.ecaacti

    LET g_errno = ' '
    SELECT eca02,ecaacti INTO g_edg[l_ac].eca02,l_ecaacti FROM eca_file
     WHERE eca01 = g_edg[l_ac].edg06

         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-676'
                   LET g_edg[l_ac].eca02 = ' ' LET l_ecaacti = ' '
              WHEN l_ecaacti='N' LET g_errno = '9028'
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_edg[l_ac].eca02

END FUNCTION

FUNCTION i412_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("edg55",TRUE)
    END IF

    IF INFIELD(edg54) THEN
       CALL cl_set_comp_entry("edg55",TRUE)
    END IF
    IF g_sma.sma901 = 'Y' THEN
        CALL cl_set_comp_entry("edg50,edg51",TRUE)
    END IF
END FUNCTION

FUNCTION i412_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  DEFINE l_cnt   LIKE type_file.num5 

    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       IF g_edg[l_ac].edg54 ='N' THEN
          CALL cl_set_comp_entry("edg55",FALSE)
       END IF
    END IF

    IF INFIELD(edg54) THEN
       IF g_edg[l_ac].edg54 ='N' THEN
          CALL cl_set_comp_entry("edg55",FALSE)
       END IF
    END IF
END FUNCTION

FUNCTION i412_sgg(p_key)
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

FUNCTION i412_b_move_to()
   LET g_edh[l_ac2].edh02 = b_edh.edh02
   LET g_edh[l_ac2].edh30 = b_edh.edh30
   LET g_edh[l_ac2].edh03 = b_edh.edh03
   LET g_edh[l_ac2].edh09 = b_edh.edh09
   LET g_edh[l_ac2].edh16 = b_edh.edh16
   LET g_edh[l_ac2].edh14 = b_edh.edh14
   LET g_edh[l_ac2].edh04 = b_edh.edh04
   LET g_edh[l_ac2].edh05 = b_edh.edh05
   LET g_edh[l_ac2].edh06 = b_edh.edh06
   LET g_edh[l_ac2].edh07 = b_edh.edh07
   LET g_edh[l_ac2].edh10 = b_edh.edh10
   LET g_edh[l_ac2].edh08 = b_edh.edh08
   LET g_edh[l_ac2].edh19 = b_edh.edh19
   LET g_edh[l_ac2].edh24 = b_edh.edh24
   LET g_edh[l_ac2].edh13 = b_edh.edh13
   LET g_edh[l_ac2].edh31 = b_edh.edh31 
   LET g_edh[l_ac2].edh081 = b_edh.edh081
   LET g_edh[l_ac2].edh082 = b_edh.edh082 
   LET g_edh10_fac = b_edh.edh10_fac                                            
   LET g_edh10_fac2 = b_edh.edh10_fac2                                          
   LET g_edh11 = b_edh.edh11                                                    
   LET g_edh15 = b_edh.edh15                                                    
   LET g_edh17 = b_edh.edh17                                                    
   LET g_edh18 = b_edh.edh18                                                    
   LET g_edh23 = b_edh.edh23                                                    
   LET g_edh27 = b_edh.edh27                                                    
   LET g_edh28 = b_edh.edh28                                                    
END FUNCTION
 
FUNCTION i412_b_move_back()

   LET b_edh.edh01      = g_edg01    
   LET b_edh.edh011     = g_edg02     
   LET b_edh.edh013     = g_edg[l_ac].edg03     
   LET b_edh.edh02      = g_edh[l_ac2].edh02
   LET b_edh.edh03      = g_edh[l_ac2].edh03
   LET b_edh.edh04      = g_edh[l_ac2].edh04
   LET b_edh.edh05      = g_edh[l_ac2].edh05
   LET b_edh.edh06      = g_edh[l_ac2].edh06
   LET b_edh.edh07      = g_edh[l_ac2].edh07
   LET b_edh.edh08      = g_edh[l_ac2].edh08
   LET b_edh.edh09      = g_edh[l_ac2].edh09
   LET b_edh.edh10      = g_edh[l_ac2].edh10
   LET b_edh.edh10_fac  = g_edh10_fac      
   LET b_edh.edh10_fac2 = g_edh10_fac2     
   LET b_edh.edh11      = g_edh11          
   LET b_edh.edh13      = g_edh[l_ac2].edh13
   LET b_edh.edh14      = g_edh[l_ac2].edh14
   LET b_edh.edh15      = g_edh15          
   LET b_edh.edh16      = g_edh[l_ac2].edh16
   LET b_edh.edh17      = g_edh17          
   LET b_edh.edh18      = g_edh18          
   LET b_edh.edh19      = g_edh[l_ac2].edh19
   LET b_edh.edh20      = ''               
   LET b_edh.edh21      = ''               
   LET b_edh.edh22      = ''               
   LET b_edh.edh23      = g_edh23          
   LET b_edh.edh24      = ''               
   LET b_edh.edh25      = ''               
   LET b_edh.edh26      = ''               
   LET b_edh.edh27      = g_edh27          
   LET b_edh.edh28      = g_edh28          
   LET b_edh.edh30      = g_edh[l_ac2].edh30
   LET b_edh.edh31      = g_edh[l_ac2].edh31  
   LET b_edh.edhmodu    = g_user           
   LET b_edh.edhdate    = g_today          
   LET b_edh.edhcomm    = 'abmi412'  
   LET b_edh.edh081     = g_edh[l_ac2].edh081
   LET b_edh.edh082     = g_edh[l_ac2].edh082      

   IF cl_null(b_edh.edh02)  THEN
      LET b_edh.edh02=' '
   END IF
   SELECT ima910 INTO b_edh.edh29 FROM ima_file,sfb_file
    WHERE sfb01=g_sfd03
      AND sfb05=ima01
   IF cl_null(b_edh.edh29) THEN LET b_edh.edh29=' ' END IF
END FUNCTION

FUNCTION i412_edh03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,  
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima08,ima37,ima25,ima63,ima70,ima86,ima105,ima107,
           ima110,ima140,ima1401,imaacti 
        INTO g_edh[l_ac2].ima02_b,g_edh[l_ac2].ima021_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_ima86_b,g_edh27,g_ima107_b,l_ima110,l_ima140,l_ima1401,l_imaacti
        FROM ima_file
        WHERE ima01 = g_edh[l_ac2].edh03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_edh[l_ac2].ima02_b = NULL
                                   LET g_edh[l_ac2].ima021_b = NULL
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
 
    IF g_edh27 IS NULL OR g_edh27 = ' ' THEN LET g_edh27 = 'N' END IF
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN
       LET g_edh[l_ac2].edh19 = l_ima110
       DISPLAY BY NAME g_edh[l_ac2].edh19
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY BY NAME g_edh[l_ac2].ima02_b 
        DISPLAY BY NAME g_edh[l_ac2].ima021_b 
        LET g_edh[l_ac2].ima08_b = g_ima08_b
        DISPLAY BY NAME g_edh[l_ac2].ima08_b 
    END IF
END FUNCTION
 
FUNCTION  i412_bdate(p_cmd)
  DEFINE   l_edh04_a,l_edh04_i LIKE edh_file.edh04,
           l_edh05_a,l_edh05_i LIKE edh_file.edh05,
           p_cmd     LIKE type_file.chr1,  
           l_n       LIKE type_file.num10  
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM edh_file
                             WHERE edh01 = g_edg01         #主件   
                               AND edh011= g_edg02
                               AND edh013= g_edg[l_ac].edg03
                               AND edh02 = g_edh[l_ac2].edh02  #項次
                               AND edh04 = g_edh[l_ac2].edh04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT count(*) INTO l_n FROM edh_file
                      WHERE edh01 = g_edg01         #主件
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03    
                        AND edh02 = g_edh[l_ac2].edh02   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(edh04),MAX(edh05) INTO l_edh04_a,l_edh05_a
                       FROM edh_file
                      WHERE edh01 = g_edg01         #主件
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03    
                        AND edh02 = g_edh[l_ac2].edh02   #項次
                        AND edh04 < g_edh[l_ac2].edh04   #生效日
    IF l_edh04_a IS NOT NULL AND l_edh05_a IS NOT NULL
    THEN IF (g_edh[l_ac2].edh04 > l_edh04_a )
            AND (g_edh[l_ac2].edh04 < l_edh05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN
         END IF
    END IF
    IF g_edh[l_ac2].edh04 <  l_edh04_a THEN
        LET g_errno = 'mfg2737'
    END IF
    IF l_edh04_a IS NULL AND l_edh05_a IS NULL THEN
       RETURN
    END IF
 
    SELECT MIN(edh04),MIN(edh05) INTO l_edh04_i,l_edh05_i
                       FROM edh_file
                      WHERE edh01 = g_edg01         #主件
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03    
                       AND  edh02 = g_edh[l_ac2].edh02   #項次
                       AND  edh04 > g_edh[l_ac2].edh04   #生效日
    IF l_edh04_i IS NULL AND l_edh05_i IS NULL THEN RETURN END IF
    IF l_edh04_a IS NULL AND l_edh05_a IS NULL THEN
       IF g_edh[l_ac2].edh04 < l_edh04_i THEN
          LET g_errno = 'mfg2737'
       END IF
    END IF
    IF g_edh[l_ac2].edh04 > l_edh04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION  i412_edgte(p_cmd)
  DEFINE   l_edh04_i   LIKE edh_file.edh04,
           l_edh04_a   LIKE edh_file.edh04,
           p_cmd       LIKE type_file.chr1,   
           l_n         LIKE type_file.num5  
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM edh_file
                      WHERE edh01 = g_edg01         #主件
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03     
                        AND edh02 = g_edh[l_ac2].edh02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(edh04) INTO l_edh04_i
                       FROM edh_file
                      WHERE edh01 = g_edg01         #主件
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03        
                       AND  edh02 = g_edh[l_ac2].edh02   #項次
                       AND  edh04 > g_edh[l_ac2].edh04   #生效日
   SELECT MAX(edh04) INTO l_edh04_a
                       FROM edh_file
                      WHERE edh01 = g_edg01         #主件
                        AND edh011= g_edg02
                        AND edh013= g_edg[l_ac].edg03     
                        AND  edh02 = g_edh[l_ac2].edh02   #項次
                        AND  edh04 > g_edh[l_ac2].edh04   #生效日
   IF l_edh04_i IS NULL THEN RETURN END IF
   IF g_edh[l_ac2].edh05 > l_edh04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION

FUNCTION  i412_edh10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
LET g_errno = ' '
 
     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_edh[l_ac2].edh10
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION


FUNCTION i412_edg01()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
 
     SELECT sfd03,sfdconf,sfd07 INTO g_sfd03,g_sfdconf,g_sfd07 FROM sfd_file
       WHERE sfd01 = g_edg01 AND sfd02=g_edg02
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 100
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY g_sfd03 TO FORMONLY.sfd03
    DISPLAY g_sfd07 TO FORMONLY.sfd07
    DISPLAY g_sfdconf TO FORMONLY.sfdconf
END FUNCTION

FUNCTION i412_show_pic()                                                                                                            
DEFINE l_void    LIKE type_file.chr1
DEFINE l_confirm LIKE type_file.chr1

     LET l_void=NULL
     LET l_confirm=NULL
     IF g_sfdconf MATCHES '[Yy]' THEN
           LET l_confirm='Y'
           LET l_void='N'
     ELSE
        IF g_sfdconf ='X' THEN
              LET l_confirm='N'
              LET l_void='Y'
        ELSE
           LET l_confirm='N'
           LET l_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(l_confirm,"","","",l_void,"g_edg1.edgacti")                                                                
END FUNCTION              

FUNCTION i412_edg_init()
    LET g_edg1.edg01=g_edg01
    LET g_edg1.edg02=g_edg02
    LET g_edg1.edgconf='N'
    LET g_edg1.edg03=g_edg[l_ac].edg03
    LET g_edg1.edg04=g_edg[l_ac].edg04
    LET g_edg1.edg05=g_edg[l_ac].edg05
    LET g_edg1.edg06=g_edg[l_ac].edg06
    LET g_edg1.edg12=g_edg[l_ac].edg12
    LET g_edg1.edg13=g_edg[l_ac].edg13
    LET g_edg1.edg14=g_edg[l_ac].edg14
    LET g_edg1.edg15=g_edg[l_ac].edg15
    LET g_edg1.edg16=g_edg[l_ac].edg16  
    LET g_edg1.edg34=g_edg[l_ac].edg34
    LET g_edg1.edg49=g_edg[l_ac].edg49 
    LET g_edg1.edg52=g_edg[l_ac].edg52
    LET g_edg1.edg53=g_edg[l_ac].edg53
    LET g_edg1.edg54=g_edg[l_ac].edg54  
    LET g_edg1.edg58=g_edg[l_ac].edg58
    LET g_edg1.edg62=g_edg[l_ac].edg62
    LET g_edg1.edg63=g_edg[l_ac].edg63
    LET g_edg1.edg64=g_edg[l_ac].edg64
    LET g_edg1.edg65=g_edg[l_ac].edg65
    LET g_edg1.edg66=g_edg[l_ac].edg66
    LET g_edg1.edg67=g_edg[l_ac].edg67
    LET g_edg1.edg50=g_edg[l_ac].edg50
    LET g_edg1.edg51=g_edg[l_ac].edg51
    LET g_edg1.edg55=g_edg[l_ac].edg55
    LET g_edg1.edg56=g_edg[l_ac].edg56 
    LET g_edg1.edg45=g_edg[l_ac].edg45           
    LET g_edg1.edg321=g_edg[l_ac].edg321
    LET g_edg1.edg121='N'
    LET g_edg1.edg43='N'
    LET g_edg1.edg61='N'
    LET g_edg1.edg07=0
    LET g_edg1.edg08=0
    LET g_edg1.edg09=0
    LET g_edg1.edg10=0
    LET g_edg1.edg17=0
    LET g_edg1.edg18=0
    LET g_edg1.edg19=0
    LET g_edg1.edg20=0
    LET g_edg1.edg21=0
    LET g_edg1.edg22=0
    LET g_edg1.edg23=0
    LET g_edg1.edg24=0
    LET g_edg1.edg35=0
    LET g_edg1.edg37=0
    LET g_edg1.edg38=0
    LET g_edg1.edg39=0
    LET g_edg1.edg40=0
    LET g_edg1.edg301=0
    LET g_edg1.edg302=0
    LET g_edg1.edg311=0
    LET g_edg1.edg312=0
    LET g_edg1.edg313=0
    LET g_edg1.edg314=0
    LET g_edg1.edg315=0
    LET g_edg1.edg322=0
    LET g_edg1.edg291=0
    LET g_edg1.edg292=0
    LET g_edg1.edg303=0
    LET g_edg1.edg316=0
    LET g_edg1.edgslk01='N'
    LET g_edg1.edgslk02=0
    LET g_edg1.edgslk03=0
    LET g_edg1.edgslk04=0
    LET g_edg1.edgorig=g_grup
    LET g_edg1.edgoriu=g_user
    SELECT sfb05,sfb06 INTO g_edg1.edg031,g_edg1.edg11
      FROM sfb_file
     WHERE sfb01=g_sfd03                                
END FUNCTION

FUNCTION i412_b_set_entry()
    CALL cl_set_comp_entry("edg03",TRUE)
    CALL cl_set_comp_entry("edg321",FALSE)
END FUNCTION

FUNCTION i412_b_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    IF cl_null(g_flag) THEN LET g_flag='N' END IF
    IF p_cmd = 'u' AND g_flag='N' THEN  #FUN-AA0030
        CALL cl_set_comp_entry("edg03",FALSE)
    END IF
    IF l_ac > 0 THEN
       IF g_edg[l_ac].edg52 = 'Y' THEN
          CALL cl_set_comp_entry("edg321",TRUE)
       ELSE
          LET g_edg[l_ac].edg321=0
       END IF
    END IF
END FUNCTION

FUNCTION i412_bp_refresh()                                                                                                          
   DISPLAY ARRAY g_edh TO s_edh.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
   #BEFORE DISPLAY
   #     EXIT DISPLAY
     ON IDLE g_idle_seconds 
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY 

END FUNCTION 

FUNCTION i412_edg67()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05 
 
   LET g_errno=' '
   SELECT pmcacti,pmc05
     INTO l_pmcacti,l_pmc05
     FROM pmc_file
    WHERE pmc01=g_edg[l_ac].edg67
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
        WHEN l_pmc05='3'        LET g_errno='aap-033'
   END CASE
END FUNCTION
#FUN-A80054

#FUN-A90035 ------------------add start----------------
FUNCTION i412_out()
  DEFINE l_wc STRING 
  
     IF cl_null(g_edg01) OR cl_null(g_edg02) THEN
        CALL cl_err('','9057',0)
     END IF 
     IF cl_null(g_wc) THEN
        LET g_wc = ' sfd01 = "',g_edg01,'" AND sfd02  = "',g_edg02,'"'
        LET g_wc2 = ' 1=1'     
     END IF  
     LET l_wc = g_wc CLIPPED," AND ",g_wc2 CLIPPED
     LET l_wc = cl_replace_str(l_wc, "'", "\"")
     LET g_msg = "asfr412",
         " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",l_wc CLIPPED,"' "
          CALL cl_cmdrun(g_msg)
END FUNCTION
#FUN-A90035 ----------------add end---------------------

#FUN-AA0030--begin--add--------
FUNCTION i412_copy()
   DEFINE l_newno      LIKE edg_file.edg01,
          l_newedg02   LIKE edg_file.edg02,
          l_oldno      LIKE edg_file.edg01,
          l_oldedg02   LIKE edg_file.edg02
   DEFINE li_result    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_n          LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_edg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno,l_newedg02 FROM edg01,edg02
      
      AFTER FIELD edg01                      
         IF NOT cl_null(l_newno) THEN
            LET l_n = 0
            IF NOT cl_null(l_newedg02) THEN
               SELECT count(*) INTO l_n FROM sfd_file
                WHERE sfd01=l_newno
                  AND sfd02=l_newedg02
                  AND sfdconf='N'
            ELSE
                SELECT count(*) INTO l_n FROM sfd_file
                 WHERE sfd01 = l_newno
                   AND sfdconf = 'N'
            END IF
            IF l_n = 0 THEN
               CALL cl_err(l_newno,'asf-432',1)
               NEXT FIELD edg01
            END IF
            IF NOT cl_null(l_newedg02) THEN
               LET l_n=0
               SELECT count(*) INTO l_n FROM edg_file
                WHERE edg01=l_newno AND edg02=l_newedg02
               IF l_n > 0 THEN CALL cl_err('',-239,0) NEXT FIELD edg01 END IF
            END IF
         END IF
 
     AFTER FIELD edg02
      IF NOT cl_null(l_newedg02) THEN
         LET l_n = 0
         SELECT count(*) INTO l_n FROM sfd_file
          WHERE sfd01=l_newno
            AND sfd02=l_newedg02
            AND sfdconf='N'
         IF l_n = 0 THEN
            CALL cl_err(l_newno,'abx-064',1)
            NEXT FIELD edg02
         END IF
         IF NOT cl_null(l_newno) THEN
            LET l_n=0
            SELECT count(*) INTO l_n FROM edg_file
             WHERE edg01=l_newno AND edg02=l_newedg02
            IF l_n > 0 THEN CALL cl_err('',-239,0) NEXT FIELD edg02 END IF
         END IF
      END IF
         
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(edg01) OR INFIELD(edg02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_edg"
               LET g_qryparam.default1 = l_newno
               LET g_qryparam.default2 = l_newedg02
               CALL cl_create_qry() RETURNING l_newno,l_newedg02  
               DISPLAY l_newno TO edg01
               DISPLAY l_newedg02 TO edg02
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
      DISPLAY g_edg01 TO edg01
      DISPLAY g_edg02 TO edg02
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM edg_file         #單頭複製
       WHERE edg01=g_edg01
         AND edg02=g_edg02
       INTO TEMP y
 
   UPDATE y
       SET edg01=l_newno,    #新的鍵值
           edg02=l_newedg02,  #新的鍵值
           edgconf='N',
           edguser=g_user,   #資料所有者
           edggrup=g_grup,   #資料所有者所屬群
           edgmodu=NULL,     #資料修改日期
           edgdate=g_today,  #資料建立日期
           edgacti='Y',      #有效資料
           edgoriu=g_user,
           edgorig=g_grup
 
   INSERT INTO edg_file SELECT * FROM y
  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","edg_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM edh_file         #單身複製
    WHERE edh01=g_edg01
      AND edh011=g_edg02
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET edh01=l_newno,edh011=l_newedg02
 
   INSERT INTO edh_file
       SELECT * FROM x


   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","edh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129    #FUN-B80086   ADD
      ROLLBACK WORK #No:7857
     # CALL cl_err3("ins","edh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129   #FUN-B80086   MARK
      RETURN
   ELSE
       COMMIT WORK #No:7857
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_edg01  LET l_oldedg02=g_edg02
   LET g_edg01 = l_newno  LET g_edg02=l_newedg02
   CALL i412_show()
   LET g_flag='Y'
   CALL i412_b()
   LET g_flag='N'
   #LET g_edg01=l_oldno  LET g_edg02=l_oldedg02  #FUN-C80046
   #CALL i412_show()                             #FUN-C80046
 
END FUNCTION
#FUN-AA0030--end--add------------
#FUN-910088--add--start--
FUNCTION i412_edh081_check()
   IF NOT cl_null(g_edh[l_ac2].edh081) AND NOT cl_null(g_edh[l_ac2].edh10) THEN
      IF cl_null(g_edh_t.edh081) OR cl_null(g_edh10_t) OR g_edh_t.edh081 != g_edh[l_ac2].edh081 OR g_edh10_t != g_edh[l_ac2].edh10 THEN
         LET g_edh[l_ac2].edh081 = s_digqty(g_edh[l_ac2].edh081,g_edh[l_ac2].edh10) 
         DISPLAY BY NAME g_edh[l_ac2].edh081
      END IF
   END IF
   IF NOT cl_null(g_edh[l_ac2].edh081) THEN
       IF g_edh[l_ac2].edh081 < 0 THEN 
          CALL cl_err(g_edh[l_ac2].edh081,'aec-020',0)
          LET g_edh[l_ac2].edh081 = g_edh_o.edh081
          RETURN FALSE     
       END IF
       LET g_edh_o.edh081 = g_edh[l_ac2].edh081
   END IF
   IF cl_null(g_edh[l_ac2].edh081) THEN
       LET g_edh[l_ac2].edh081 = 0
   END IF
   DISPLAY BY NAME g_edh[l_ac2].edh081
   RETURN TRUE
END FUNCTION

FUNCTION i412_edg321_check()
   IF NOT cl_null(g_edg[l_ac].edg321) AND NOT cl_null(g_edg[l_ac].edg58) THEN
      IF cl_null(g_edg58_t) OR cl_null(g_edg_t.edg321) OR g_edg58_t != g_edg[l_ac].edg58 OR g_edg_t.edg321 != g_edg[l_ac].edg321 THEN
         LET g_edg[l_ac].edg321 = s_digqty(g_edg[l_ac].edg321,g_edg[l_ac].edg58) 
         DISPLAY BY NAME g_edg[l_ac].edg321
      END IF
   END IF
   IF NOT cl_null(g_edg[l_ac].edg321) THEN
      IF g_edg[l_ac].edg321 < 0 THEN
         CALL cl_err('','aec-020',0)
          RETURN FALSE     
      END IF
   END IF 
   RETURN TRUE
END FUNCTION
 
FUNCTION i412_edg12_check()
   IF NOT cl_null(g_edg[l_ac].edg12) AND NOT cl_null(g_edg[l_ac].edg58) THEN
      IF cl_null(g_edg58_t) OR cl_null(g_edg_t.edg12) OR g_edg58_t != g_edg[l_ac].edg58 OR g_edg_t.edg12 != g_edg[l_ac].edg12 THEN
         LET g_edg[l_ac].edg12 = s_digqty(g_edg[l_ac].edg12,g_edg[l_ac].edg58)
         DISPLAY BY NAME g_edg[l_ac].edg12
      END IF
   END IF
   IF NOT cl_null(g_edg[l_ac].edg12) THEN
      IF g_edg[l_ac].edg12 < 0 THEN
         CALL cl_err(g_edg[l_ac].edg12,'axm-179',0)
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION   
#FUN-910088-add--end--
