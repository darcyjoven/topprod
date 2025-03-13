# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli0011.4gl
# Descriptions...: 合併後財報會計科目資料維護作業
# Date & Author..: NO.FUN-920025 09/02/09 By jamie 新增
# Modify.........: NO.FUN-920065 09/02/13 BY jamie 增加報表
# Modify.........: NO.FUN-920144/FUN-920151 09/02/19 BY yiting aag02跨資料庫抓取處理 
# Modify.........: NO.FUN-950051 09/05/25 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查快科方式修改 
# Modify.........: NO.FUN-950049 09/06/12 By lutingting axe11/axe12欄位給預設值
# Modify.........: NO.FUN-980040 09/08/11 BY yiting 1.抓取axa09時應以單頭axa02為key
#                                                   2.自動產生時羅輯應與手動輸入一致
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No:MOD-9C0161 09/12/24 By Sarah SQL語法修改
# Modify.........: No.CHI-9C0038 10/01/26 By lutingting相關科目開啟可輸入結轉科目
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A60013 10/07/27 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: NO.MOD-A70031 10/07/27 by sabrina 當axee04新舊值不同時才需重帶axee11/axee12
# Modify.........: No.FUN-A30122 10/08/19 By vealxu 取合併帳別資料庫改由s_aaz641_dbs，s_get_aaz641取合併帳別
# Modify.........: NO.FUN-920065 10/09/01 BY chenmoyan 修改報表BUG
# Modify.........: NO.MOD-AA0186 10/10/29 by Dido 匯率異動判斷調整 
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No.MOD-B30236 11/03/12 By lutingting 跨库错误
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B60082 11/06/20 by belle axe04、axe06擷取aag_file 資料時加入條件aag09 = 'Y'
# Modify.........: NO.FUN-B90061 11/09/09 by belle 增加EXCEL匯入功能
# Modify.........: NO.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的的FUN,TQC,MOD單追齊
# Modify.........: NO.MOD-BB0273 11/11/26 by Dido 變數應用調整  
# Modify.........: No.MOD-C10085 12/01/10 By Polly i0011_g_pre改用s_aaz641_dbs取回的g_plant_axz03抓取aag_file
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90063 12/09/10 By Polly 調整會查到舊有架構資料錯誤，重新抓取aaz641，取出g_axee00變數作為實際帳別條件
# Modify.........: No.FUN-D20044 13/02/19 by apo 增加EXCEL匯入範本功能
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40018 13/04/15 By Lori excel匯出範本改使用sagli020()匯出Html格式的做法

IMPORT os   #FUN-D20044
DATABASE ds

GLOBALS "../../config/top.global"   
#FUN-BA0006

DEFINE g_axee13         LIKE axee_file.axee13,      #FUN-910001 add   #FUN-920151
       g_axee13_t       LIKE axee_file.axee13,      #FUN-910001 add
       g_axee01         LIKE axee_file.axee01,      
       g_axee01_t       LIKE axee_file.axee01, 
       g_axee01_o       LIKE axee_file.axee01,
       g_axee00         LIKE axee_file.axee00,      #No.FUN-730070
       g_axee00_t       LIKE axee_file.axee00,      #No.FUN-730070
       g_axee00_o       LIKE axee_file.axee00,      #No.FUN-730070
       #No.TQC-9B0015  --Begin
    #  g_axee_rowid     LIKE type_file.num10,     #ROWID   #No.FUN-680098 int # saki 20070821 rowid chr18 -> num10 
       #No.TQC-9B0015  --End  
       g_axee           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          #axee01_1     LIKE axee_file.axee01,      #FUN-D40018 add   #僅供匯出樣本excel時取得畫面欄位attibute,不做任何資料處理 
           axee04       LIKE axee_file.axee04,                 
           axee05       LIKE axee_file.axee05,                 
           axee06       LIKE axee_file.axee06,                  
           aag02        LIKE aag_file.aag02,
           axee11       LIKE axee_file.axee11,      #FUN-580063
           axee12       LIKE axee_file.axee12       #FUN-580063
          #axee13_1     LIKE axee_file.axee13       #FUN-D40018 add   #僅供匯出樣本excel時取得畫面欄位attibute,不做任何資料處理
                       END RECORD,
       g_axee_t         RECORD                    #程式變數 (舊值)
          #axee01_1     LIKE axee_file.axee01,      #FUN-D40018 add
           axee04       LIKE axee_file.axee04,                    
           axee05       LIKE axee_file.axee05,                    
           axee06       LIKE axee_file.axee06,
           aag02       LIKE aag_file.aag02,
           axee11       LIKE axee_file.axee11,      #FUN-580063
           axee12       LIKE axee_file.axee12       #FUN-580063
          #axee13_1     LIKE axee_file.axee13       #FUN-D40018 add   #僅供匯出樣本excel時取得畫面欄位attibute,不做任何資料處理
                       END RECORD,
       i               LIKE type_file.num5,      #No.FUN-680098 smallint
       g_wc,g_wc2      STRING,                   #TQC-630166      
       g_sql           STRING,                   #TQC-630166      
       g_sql_tmp       STRING,                   #No.FUN-730070
       g_rec_b         LIKE type_file.num5,      #單身筆數   #No.FUN-680098 smallint
       g_ss            LIKE type_file.chr1,      #No.FUN-680098  char(1)
       g_dbs_gl        LIKE aag_file.aag01,      #No.FUN-680098  char(24)
       l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT     #No.FUN-680098 smallint
       g_cnt           LIKE type_file.num5,      #目前處理的ARRAY CNT     #No.FUN-680098 smallint 
       tm              RECORD 
           axee13       LIKE axee_file.axee13,      #FUN-910001 add
           axee01       LIKE axee_file.axee01, 
           axee00       LIKE axee_file.axee00,      #No.FUN-730070
           y           LIKE type_file.chr1       #No.FUN-680098 char(1)
                       END RECORD
DEFINE g_forupd_sql    STRING                    #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done   LIKE type_file.num5 #No.FUN-680098 smallint
DEFINE g_axz03         LIKE axz_file.axz03       #FUN-760003 add    
DEFINE g_azp03         LIKE azp_file.azp03       #FUN-760003 add    
DEFINE g_str           STRING                    #FUN-760085 add    
DEFINE g_i             LIKE type_file.num5       #count/index for any purpose  #No.FUN-680098  smallint
DEFINE g_msg           LIKE type_file.chr1000    #No.FUN-680098  char(72)
DEFINE g_row_count     LIKE type_file.num10      #No.FUN-680098  integer
DEFINE g_curs_index    LIKE type_file.num10      #No.FUN-680098  integer
DEFINE g_jump          LIKE type_file.num10      #No.FUN-680098  integer
DEFINE mi_no_ask       LIKE type_file.num5       #No.FUN-680098  smallint
DEFINE g_aaz641        LIKE aaz_file.aaz641      #FUN-920035
DEFINE g_dbs_axz03     LIKE type_file.chr21      #FUN-920035
DEFINE g_axee00_def    LIKE axee_file.axee00     #FUN-920035
DEFINE g_axb_count     LIKE type_file.num5       #FUN-920025
DEFINE g_aaz641_g      LIKE aaz_file.aaz641      #FUN-920025
DEFINE g_axz03_g       LIKE axz_file.axz03       #FUN-920025   
DEFINE g_dbs_axz03_g   LIKE type_file.chr21      #FUN-920025
DEFINE g_axa_count     LIKE type_file.num5       #FUN-950051
DEFINE g_axz04         LIKE axz_file.axz04       #FUN-980040
DEFINE g_axz04_g       LIKE axz_file.axz04       #FUN-980040
DEFINE g_axz02         LIKE axz_file.axz02       #FUN-980040
DEFINE g_axz02_g       LIKE axz_file.axz02       #FUN-980040
DEFINE g_axa09         LIKE axa_file.axa09       #FUN-980040 
DEFINE g_axa02         LIKE axa_file.axa02       #FUN-A30122 add
DEFINE g_plant_axz03   LIKE type_file.chr21      #FUN-A30122
DEFINE g_plant_axz03_g LIKE type_file.chr21      #FUN-A30122 
#----以下為資料匯入時使用的變數----
#FUN-B90061--begin--
DEFINE g_file          STRING
DEFINE g_disk          LIKE type_file.chr1
DEFINE g_axeel         RECORD LIKE axee_file.*
DEFINE l_table         STRING
DEFINE gg_sql          STRING
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_choice        LIKE type_file.chr1
DEFINE g_i0011_01      LIKE type_file.chr1000
#FUN-B90061---end---
DEFINE g_cmd            LIKE type_file.chr100        #FUN-D20044
DEFINE sheet1           STRING                       #FUN-D20044
DEFINE li_result        LIKE type_file.num5          #FUN-D20044
DEFINE l_cmd            LIKE type_file.chr100        #FUN-D20044
DEFINE l_path           LIKE type_file.chr100        #FUN-D20044
DEFINE l_unixpath       LIKE type_file.chr100        #FUN-D20044

#主程式開始
MAIN          
DEFINE
    p_row,p_col   LIKE type_file.num5          #No.FUN-680098    smallint

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   LET i=0
   LET g_axee13_t = NULL  #FUN-910001 add
   LET g_axee01_t = NULL
   LET g_axee00_t = NULL  #No.FUN-730070
   
   LET p_row = 3 LET p_col = 16

   OPEN WINDOW i0011_w AT p_row,p_col
     WITH FORM "agl/42f/agli0011" ATTRIBUTE(STYLE = g_win_style)
   
   CALL cl_ui_init()

   CALL i0011_menu()

   CLOSE FORM i0011_w                      #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION i0011_cs()

   CLEAR FORM                            #清除畫面
   CALL g_axee.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 

   INITIALIZE g_axee13 TO NULL    #FUN-910001 add
   INITIALIZE g_axee01 TO NULL    #No.FUN-750051
   INITIALIZE g_axee00 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON axee13,axee01,axee00,axee04,axee05,axee06,axee11,axee12  #No.FUN-730070   #FUN-910001 add axee13
                FROM axee13,axee01,axee00,s_axee[1].axee04,s_axee[1].axee05,                  #FUN-910001 add axee13
                     s_axee[1].axee06,s_axee[1].axee11,s_axee[1].axee12  #No.FUN-730070

      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON ACTION CONTROLP
         CASE
           #str FUN-910001 add
            WHEN INFIELD(axee13) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_axa1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axee13
               NEXT FIELD axee13
           #end FUN-910001 add
            WHEN INFIELD(axee01)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"      #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axee01  
               NEXT FIELD axee01
           #FUN-920025---mark---str---
           ##No.FUN-730070  --Begin
           #WHEN INFIELD(axee00)  
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.state = "c"
           #   LET g_qryparam.form ="q_aaa"      #FUN-580063
           #   CALL cl_create_qry() RETURNING g_qryparam.multiret
           #   DISPLAY g_qryparam.multiret TO axee00  
           #   NEXT FIELD axee00
           ##No.FUN-730070  --End   
           #FUN-920025---mark---end---
            WHEN INFIELD(axee04)  
              #CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_axee[1].axee04,'23',g_axee00)     #FUN-920025 mark #No.MOD-480092  #No.FUN-730070
              #CALL q_m_aag2(TRUE,TRUE,g_dbs_gl,g_axee[1].axee04,'23',g_axee00)    #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070
              #CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_axee[1].axee04,'23',g_axee00)    #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070  #FUN-950051#TQC-9C0099
              #CALL q_m_aag2(TRUE,TRUE,g_axz03,g_axee[1].axee04,'23',g_axee00)     #FUN-B60082 mark #FUN-920025 mod  #No.MOD-480092  #No.FUN-730070  #FUN-950051 #TQC-9C0099
               CALL q_m_aag4(TRUE,TRUE,g_axz03,g_axee[1].axee04,'23',g_axee00)     #FUN-B60082 mod 
                    RETURNING g_qryparam.multiret    #No.MOD-480092
               DISPLAY g_qryparam.multiret TO axee04  #No.MOD-480092
               NEXT FIELD axee04
            WHEN INFIELD(axee06)  
            #--FUN-920035 start--
              #CALL q_m_aag(TRUE,TRUE,g_dbs_axz03,g_axee[1].axee06,'23',g_aaz641)   #FUN-920025 mark
              #CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-920025 mod#TQC-9C0099
              #CALL q_m_aag2(TRUE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-920025 mod  #TQC-9C0099  #FUN-B50001
              #CALL q_m_aag2(TRUE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaw01_g)   #FUN-B60082 mark #FUN-B50001
              #CALL q_m_aag4(TRUE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaw01_g)   #FUN-BA0012 mark #FUN-B60082 mod
               CALL q_m_aag4(TRUE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-BA0012      #FUN-B60082 mod
                    RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO axee06 
               NEXT FIELD axee06
            #--FUN-920035 end----
            ####FUN-920035 mark####
            #   CALL cl_init_qry_var()
            #   #No.MOD-480092
            #   LET g_qryparam.form ="q_aag"
            #  #LET g_qryparam.default1 = g_axee[l_ac].axee06   #MOD-710041
            #   LET g_qryparam.state = "c"
            #   CALL cl_create_qry() RETURNING g_qryparam.multiret 
            #   DISPLAY g_qryparam.multiret TO axee06
            #   NEXT FIELD axee06 
            #   #No.MOD-480092 (end)
            ####FUN-920035 mark####
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
     
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN 
   END IF

  #---------------------MOD-C90063------------------(S)
   LET g_sql = "SELECT UNIQUE axee13,axee01 ",
               "  FROM axee_file",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY axee13,axee01"
   PREPARE i0011_aaz641p FROM g_sql
   DECLARE i0011_aaz641c SCROLL CURSOR WITH HOLD FOR i0011_aaz641p
   OPEN i0011_aaz641c
   FETCH FIRST i0011_aaz641c INTO g_axee13,g_axee01
   CALL s_aaz641_dbs(g_axee13,g_axee01) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_axee00
  #---------------------MOD-C90063------------------(E)

   LET g_sql = "SELECT UNIQUE axee13,axee01,axee00 ",  #No.FUN-730070   #FUN-910001 add axee13
               "  FROM axee_file",
               " WHERE ", g_wc CLIPPED,
               "   AND axee00 = '",g_axee00,"'",               #MOD-C90063 add
               " ORDER BY axee13,axee01,axee00"    #No.FUN-730070   #FUN-910001 add axee13
   PREPARE i0011_prepare FROM g_sql        #預備一下
   DECLARE i0011_bcs SCROLL CURSOR WITH HOLD FOR i0011_prepare

   LET g_sql_tmp = "SELECT UNIQUE axee13,axee01,axee00 ",   #FUN-910001 add axee13
                   "  FROM axee_file WHERE ", g_wc CLIPPED,
                   "   AND axee00 = '",g_axee00,"'",           #MOD-C90063
                   "  INTO TEMP x "
   DROP TABLE x
   PREPARE i0011_pre_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i0011_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   #No.FUN-730070  --End  
   PREPARE i0011_precount FROM g_sql
   DECLARE i0011_count CURSOR FOR i0011_precount

END FUNCTION

FUNCTION i0011_menu()

   WHILE TRUE
      CALL i0011_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i0011_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i0011_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i0011_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i0011_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i0011_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        #FUN-920025---mark---
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i0011_out()   #FUN-920065 add
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL i0011_g()
            END IF
          WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_axee01 IS NOT NULL THEN
                  LET g_doc.column1 = "axee13"
                  LET g_doc.value1 = g_axee13
                  LET g_doc.column2 = "axee01"
                  LET g_doc.value2 = g_axee01
                  LET g_doc.column3 = "axee00"
                  LET g_doc.value3 = g_axee00
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axee),'','')
            END IF
        #FUN-B90061--begin--
         WHEN "dataload"                        # 資料匯入
            CALL i0011_dataload()
        #FUN-B90061---end---
        #FUN-D20044--
         WHEN "excelexample"                    # 匯出Excel範本
            #FUN-D40018 mark begin---
             LET l_unixpath = os.Path.join( os.Path.join( os.Path.join(FGL_GETENV("TOP"),"tool"),"report"),"aglsample.xls")
             LET l_path = "C:\\tiptop\\agli0011.xls"
             LET g_cmd = "EXCEL ",l_path
             LET sheet1 = "sheet1"
             LET li_result = cl_download_file(l_unixpath,l_path)
             IF STATUS THEN
                CALL cl_err('',"amd-021",1)
                DISPLAY "Download fail!!"
                LET g_success = 'N'
                RETURN
             END IF
             CALL ui.Interface.frontCall("standard","shellexec",[g_cmd],[])
             SLEEP 10
             CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet1],[li_result])
             CALL i0011_exceldata()
             CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,sheet1],[li_result])
            #FUN-D40018 mark end-----

           ##FUN-D40018 add begin---
           #IF cl_chk_act_auth() THEN
           #   CALL sagli020(ui.Interface.getRootNode(),base.TypeInfo.create(g_axee),'Y')
           #END IF
           ##FUN-D40018 add end-----
        #FUN-D20044--
      END CASE
   END WHILE
END FUNCTION

FUNCTION i0011_a()

   IF s_aglshut(0) THEN
      RETURN
   END IF  

   MESSAGE ""
   CLEAR FORM
   CALL g_axee.clear()
   INITIALIZE g_axee13 LIKE axee_file.axee13      #DEFAULT 設定  #FUN-910001 add
   INITIALIZE g_axee01 LIKE axee_file.axee01      #DEFAULT 設定
   INITIALIZE g_axee00 LIKE axee_file.axee00      #DEFAULT 設定  #No.FUN-730070

   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i0011_i("a")                         #輸入單頭

      IF INT_FLAG THEN                           #使用者不玩了
         LET g_axee13=NULL  #FUN-910001 add
         LET g_axee01=NULL
         LET g_axee00=NULL  #No.FUN-730070
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_axee.clear()
      ELSE
         CALL i0011_b_fill('1=1')         #單身
      END IF

      CALL i0011_b()                      #輸入單身

      LET g_axee13_t = g_axee13            #保留舊值  #FUN-910001 add
      LET g_axee01_t = g_axee01            #保留舊值
      LET g_axee00_t = g_axee00            #保留舊值  #No.FUN-730070
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i0011_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680098 char(1)
   l_n1,l_n        LIKE type_file.num5,          #No.FUN-680098  smallint
   p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680098 char(1)

   LET g_ss = 'Y'

   DISPLAY g_axee13 TO axee13   #FUN-910001 add
   DISPLAY g_axee01 TO axee01 
  #DISPLAY g_axee00 TO axee00   #No.FUN-730070
   DISPLAY g_axee00 TO FORMONLY.axee00   #No.FUN-730070
   CALL cl_set_head_visible("","YES")            #No.FUN-6B0029
   INPUT g_axee13,g_axee01,g_axee00 WITHOUT DEFAULTS FROM axee13,axee01,axee00 #No.FUN-730070  #FUN-910001

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i0011_set_entry(p_cmd) 
         CALL i0011_set_no_entry(p_cmd) 
         LET g_before_input_done = TRUE

      AFTER FIELD axee13   #族群代號
         IF cl_null(g_axee13) THEN
            CALL cl_err(g_axee13,'mfg0037',0)
            NEXT FIELD axee13
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=g_axee13
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err(g_axee13,'agl-223',0)
               NEXT FIELD axee13
            END IF
         END IF

      AFTER FIELD axee01 
         IF NOT cl_null(g_axee01) THEN 
          # CALL i0011_axee01('a',g_axee01)             #FUN-A30122 mark
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axee01,g_errno,0)
              NEXT FIELD axee01
            END IF
          # CALL i0011_getdbs(g_axee01,g_axee13) #FUN-980040 add     #FUN-A30122 mark
    
          #FUN-A30122 ----------------------------add start----------------------------
           SELECT axb02 INTO g_axa02  #上层公司                               
             FROM axb_file                                                    
            WHERE axb01 = g_axee13                                            
              AND axb04 = g_axee01                                            
           SELECT axz02,axz03,axz04                                            
             INTO g_axz02,g_axz03,g_axz04 FROM axz_file                        
            WHERE axz01 = g_axee01                                             
           CALL s_aaz641_dbs(g_axee13,g_axee01) RETURNING g_plant_axz03          
           CALL s_get_aaz641(g_plant_axz03) RETURNING g_axee00                   
           DISPLAY g_axz02 TO FORMONLY.axz02                                   
           DISPLAY g_axz03 TO FORMONLY.axz03                                   
           DISPLAY g_axee00 TO FORMONLY.axee00 
          #FUN-A30122 --------------------------add end--------------------------------------
   
            IF g_axee13 IS NOT NULL AND g_axee01 IS NOT NULL THEN 
               # AND g_axee00 IS NOT NULL THEN  #FUN-920025 mark
               LET l_n = 0  
               #FUN-920025--start-- 
               #LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_axee13 AND axa02=g_axee01
               #   AND axa03=g_axee00  
               #SELECT COUNT(*) INTO l_n1 FROM axb_file
               # WHERE axb01=g_axee13 AND axb04=g_axee01
               #   #AND axb05=g_axee00   #FUN-920025 mark
               #IF l_n+l_n1 = 0 THEN
               IF l_n = 0 THEN
               #FUN-920025--end
                  CALL cl_err(g_axee01,'agl-223',0)
                  LET g_axee13 = g_axee13_t
                  LET g_axee01 = g_axee01_t
                  LET g_axee00 = g_axee00_t
                  DISPLAY BY NAME g_axee13,g_axee01,g_axee00
                  NEXT FIELD axee01
               END IF
            END IF
         END IF

      AFTER FIELD axee00
         IF cl_null(g_axee01) THEN NEXT FIELD axee01 END IF
         IF NOT cl_null(g_axee00) THEN
          # CALL i0011_axee00('a',g_axee00)                  #FUN-A30122 mark
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axee00,g_errno,0)
               NEXT FIELD axee00
            END IF
            #增加公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axz_file
             WHERE axz01=g_axee01 AND axz05=g_axee00
            IF l_n = 0 THEN
               CALL cl_err(g_axee00,'agl-946',0)
               NEXT FIELD axee00
            END IF
            IF g_axee13 != g_axee13_t OR cl_null(g_axee13_t) OR 
               g_axee01 != g_axee01_t OR cl_null(g_axee01_t) OR 
               g_axee00 != g_axee00_t OR cl_null(g_axee00_t) THEN  
               LET g_cnt = 0 
               SELECT COUNT(*) INTO g_cnt FROM axee_file
                WHERE axee01=g_axee01
                  AND axee00=g_axee00 
                  AND axee13=g_axee13   #FUN-910001 add   
               IF g_cnt = 0  THEN             #不存在, 新來的  #No.TQC-740199
                  IF p_cmd = 'a' THEN 
                     LET g_ss = 'N' 
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_axee01,-239,0)
                     LET g_axee13=g_axee13_t   #FUN-910001 add
                     LET g_axee01=g_axee01_t
                     LET g_axee00=g_axee00_t
                     NEXT FIELD axee01
                  END IF
               END IF
               LET l_n = 0   LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM axa_file
                WHERE axa01=g_axee13 AND axa02=g_axee01
                  AND axa03=g_axee00    
               SELECT COUNT(*) INTO l_n1 FROM axb_file
                WHERE axb01=g_axee13 AND axb04=g_axee01
                  AND axb05=g_axee00  
               IF l_n+l_n1 = 0 THEN
                  CALL cl_err(g_axee01,'agl-223',0)
                  LET g_axee13 = g_axee13_t
                  LET g_axee01 = g_axee01_t
                  LET g_axee00 = g_axee00_t
                  DISPLAY BY NAME g_axee13,g_axee01,g_axee00
                  NEXT FIELD axee01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axee13) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_axee13
               CALL cl_create_qry() RETURNING g_axee13
               DISPLAY g_axee13 TO axee13
               NEXT FIELD axee13
            WHEN INFIELD(axee01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"     #FUN-580063 q_azp->q_axz
               LET g_qryparam.default1 = g_axee01
               CALL cl_create_qry() RETURNING g_axee01
               DISPLAY g_axee01 TO axee01 
               NEXT FIELD axee01
           #FUN-920025---mark---str---
           #WHEN INFIELD(axee00)  
           #   SELECT azp03 INTO g_azp03 FROM axz_file,azp_file
           #    WHERE axz01=g_axee01 AND axz03=azp01
           #   IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form ="q_aaa4"    #FUN-580063   #TQC-760205 q_aaa->q_aaa4
           #   LET g_qryparam.default1 = g_axee00
           #   LET g_qryparam.arg1 = g_azp03                  #TQC-760205 add
           #   CALL cl_create_qry() RETURNING g_axee00
           #   DISPLAY g_axee00 TO axee00 
           #   NEXT FIELD axee00
           #FUN-920025---mark---end---
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   
   END INPUT
 
END FUNCTION
   
FUNCTION i0011_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 char(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("axee13,axee01,axee00",TRUE)  
   END IF 

END FUNCTION

FUNCTION i0011_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 char(1)

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("axee13,axee01,axee00",FALSE) #FUN-920025 mark #No.FUN-73070  #FUN-910001 add axee13
   END IF 
    CALL cl_set_comp_entry("axee00",FALSE) #FUN-920025 mark #FUN-920035
   
END FUNCTION

FUNCTION i0011_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 char(1)
 
   CALL cl_set_comp_entry("axee05",TRUE)
END FUNCTION

FUNCTION i0011_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680098 char(1)
          l_axz04 LIKE axz_file.axz04

   SELECT axz04 INTO l_axz04 FROM axz_file   #使用TIPTOP
    WHERE axz01 = g_axee01
   IF l_axz04 = 'Y' THEN
      CALL cl_set_comp_entry ("axee05",FALSE)
   END IF
END FUNCTION

FUNCTION  i0011_axee01(p_cmd,p_axee01)   #FUN-580063 將本段中所有azp改成axz
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 CHAR(1)
       p_axee01        LIKE axee_file.axee01,
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz03_g       LIKE axz_file.axz03,   #
       l_axz05         LIKE axz_file.axz05,   #TQC-760205 add
       l_db            LIKE axz_file.axz03    #

    LET g_errno = ' '

  # CALL i0011_getdbs(g_axee01,g_axee13)   #FUN-980040    #FUN-A30122 mark 
    
#----FUN-980040 mark- 統一移至i0011_getdbs()處理
#   #SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05   #TQC-760205 add axz05 
#    SELECT axz02,axz03 INTO l_axz02,l_axz03   #TQC-760205 add axz05 
#      FROM axz_file
#     WHERE axz01 = p_axee01
#
#    LET g_plant_new = l_axz03      #營運中心
#    CALL s_getdbs()
#    LET g_dbs_axz03 = g_dbs_new    #所屬DB
#
#    #FUN-920025---add---
#     LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#                 " WHERE aaz00 = '0'"
#     PREPARE i0011_pre_05 FROM g_sql
#     DECLARE i0011_cur_05 CURSOR FOR i0011_pre_05
#     OPEN i0011_cur_05
#     FETCH i0011_cur_05 INTO l_axz05    #合併後帳別
#     IF cl_null(l_axz05) THEN
#         CALL cl_err(l_axz03_g,'agl-601',1)
#     END IF
#    #FUN-920025---add---
#  
#    LET g_axee00 = l_axz05 
#---FUN-980040 mark-----------------

   #FUN-920025---mark---str---
   #IF p_cmd = 'a' THEN 
   #   LET g_axee00 = l_axz05 
   #   #DISPLAY BY NAME g_axee00   
   #END IF
   #FUN-920025---mark---end---

    CASE
       WHEN SQLCA.SQLCODE=100 
          LET g_errno = 'mfg9142'
          LET l_axz02 = NULL
          LET l_axz03 = NULL 
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#---FUN-980040 start---
       DISPLAY g_axz02 TO FORMONLY.axz02 
       DISPLAY g_axz03 TO FORMONLY.axz03 
       DISPLAY g_axee00 TO FORMONLY.axee00  
#--FUN-980040 end------
       #--FUN-980040 mark------
       #DISPLAY l_axz02 TO FORMONLY.axz02 
       #DISPLAY l_axz03 TO FORMONLY.axz03 
       #DISPLAY l_axz05 TO  FORMONLY.axee00  #FUN-920035
       #DISPLAY g_axee00 TO FORMONLY.axee00   #FUN-920025 mod   #No.FUN-730070
       #--FUN-980040 mark------
    END IF

END FUNCTION

FUNCTION i0011_axee00(p_cmd,p_axee00)
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_axee00   LIKE axee_file.axee00,
         l_aaaacti LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_axee00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION

FUNCTION i0011_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axee13 TO NULL             #FUN-910001 add
   INITIALIZE g_axee01 TO NULL             #No.FUN-6B0040
   INITIALIZE g_axee00 TO NULL             #No.FUN-6B0040  #No.FUN-730070
   MESSAGE ""
   CLEAR FORM
   CALL g_axee.clear()

   CALL i0011_cs()                         #取得查詢條件

   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF

   OPEN i0011_bcs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axee13 TO NULL  #FUN-910001 add
      INITIALIZE g_axee01 TO NULL
      INITIALIZE g_axee00 TO NULL  #No.FUN-730070
   ELSE
      CALL i0011_fetch('F')                #讀出TEMP第一筆並顯示

      OPEN i0011_count
      FETCH i0011_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION

FUNCTION i0011_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 char(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680098 integer

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i0011_bcs INTO g_axee13,g_axee01,g_axee00  #No.FUN-730070   #FUN-910001 add axee13
      WHEN 'P' FETCH PREVIOUS i0011_bcs INTO g_axee13,g_axee01,g_axee00  #No.FUN-730070   #FUN-910001 add axee13
      WHEN 'F' FETCH FIRST    i0011_bcs INTO g_axee13,g_axee01,g_axee00  #No.FUN-730070   #FUN-910001 add axee13
      WHEN 'L' FETCH LAST     i0011_bcs INTO g_axee13,g_axee01,g_axee00  #No.FUN-730070   #FUN-910001 add axee13
      WHEN '/' 
         IF (NOT mi_no_ask) THEN 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
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
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               EXIT CASE 
            END IF
         END IF
         FETCH ABSOLUTE g_jump i0011_bcs INTO g_axee13,g_axee01,g_axee00  #No.FUN-730070  #FUN-910001 add axee13
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_axee01,SQLCA.sqlcode,0)
      INITIALIZE g_axee13 TO NULL  #FUN-910001 add
      INITIALIZE g_axee01 TO NULL  #TQC-6B0105
      INITIALIZE g_axee00 TO NULL  #TQC-6B0105  #No.FUN-730070
   ELSE
      CALL i0011_show()

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

FUNCTION i0011_show()
   
  #FUN-A30122 ----------------------add start--------------------------------
   SELECT axz02,axz03,axz04                                                     
     INTO g_axz02,g_axz03,g_axz04 FROM axz_file                                 
    WHERE axz01 = g_axee01                                                      
   CALL s_aaz641_dbs(g_axee13,g_axee01) RETURNING g_plant_axz03                   
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_axee00                            
   DISPLAY g_axz02 TO FORMONLY.axz02                                            
   DISPLAY g_axz03 TO FORMONLY.axz03 
  #FUN-A30122 ---------------------add end-------------------------------------  

   DISPLAY g_axee13 TO axee13      #FUN-910001 add
   DISPLAY g_axee01 TO axee01 
  #DISPLAY g_axee00 TO axee00            #FUN-920025 mark  #No.FUN-730070
   DISPLAY g_axee00 TO FORMONLY.axee00   #FUN-920025 mod   #No.FUN-730070

  #CALL i0011_axee01('d',g_axee01)                     #FUN-A30122 mark
  #CALL i0011_axee00('d',g_axee00)  #No.FUN-730070     #FUN-A30122 mark

   CALL i0011_b_fill(g_wc)        #單身

   CALL cl_show_fld_cont()       #No:FUN-550037 hmf
END FUNCTION

FUNCTION i0011_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 char(1)

   IF s_aglshut(0) THEN RETURN END IF

   IF cl_null(g_axee13) OR cl_null(g_axee01) OR cl_null(g_axee00) THEN   #No.FUN-730070  #FUN-910001
      CALL cl_err('',-400,0)
      RETURN 
   END IF

   BEGIN WORK

   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "axee13"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_axee13       #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "axee01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_axee01       #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "axee00"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_axee00       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      DELETE FROM axee_file WHERE axee01=g_axee01 
                             AND axee00=g_axee00  #No.FUN-730070
                             AND axee13=g_axee13  #FUN-910001 add
      IF SQLCA.sqlcode THEN
          CALL cl_err3("del","axee_file",g_axee01,g_axee00,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123  #No.FUN-730070
      ELSE
         CLEAR FORM
         CALL g_axee.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'

         DROP TABLE x
         PREPARE i003_pre_x2 FROM g_sql_tmp
         EXECUTE i003_pre_x2              
         OPEN i0011_count
         FETCH i0011_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt

         OPEN i0011_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i0011_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i0011_fetch('/')
         END IF
      END IF

      LET g_msg=TIME

      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)   #FUN-A60056 add plant,legal
                   VALUES ('agli0011',g_user,g_today,g_msg,g_axee01,'delete',g_plant,g_legal)   #FUN-A60056 add plant,legal
   END IF

   COMMIT WORK

END FUNCTION

FUNCTION i0011_b()
DEFINE
    l_axee05         LIKE axee_file.axee05,
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680098 smallint
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680098 smallint
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680098 char(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680098 char(1)
    l_sql           LIKE type_file.chr1000,   #No.FUN-680098   char(150)
    l_allow_insert  LIKE type_file.chr1,      #可新增否  #No.FUN-680098 char(1)
    l_allow_delete  LIKE type_file.chr1,      #可刪除否  #No.FUN-680098 char(1)
    l_axz04         LIKE axz_file.axz04,      #MOD-5A0443 
    l_axz03         LIKE axz_file.axz03       #TQC-660043
DEFINE l_aag04      LIKE aag_file.aag04       #FUN-950051

DEFINE l_axb02      LIKE axb_file.axb02       #FUN-920035
DEFINE l_axb02_g    LIKE axb_file.axb02       #FUN-920025
DEFINE l_axa09      LIKE axa_file.axa09       #FUN-950051

   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

  #CALL i0011_getdbs(g_axee01,g_axee13)   #FUN-980040 add        #FUN-A30122 amrk
  #FUN-A30122 ------------------------add start---------------------------------
   CALL s_aaz641_dbs(g_axee13,g_axee01) RETURNING g_plant_axz03                   
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                            
   CALL s_aaz641_dbs(g_axee13,g_axa02) RETURNING g_plant_axz03_g                  
   CALL s_get_aaz641(g_plant_axz03_g) RETURNING g_aaz641_g
  #FUN-A30122 -----------------------add end-------------------------------------   

#---FUN-980040 mark---移至i0011_getdbs()處理----
#   LET g_plant_new = g_axee01 
#
#   SELECT axz03,axz04 INTO l_axz03,l_axz04 FROM axz_file   #TQC-760205 add axz04
#     WHERE axz01 = g_plant_new
#
#   #使用tiptop否(axz04)=N,表示為非TIPTOP公司,預設目前所在DB給他
#   IF l_axz04 = 'N' THEN LET l_axz03=g_plant END IF        #TQC-760205 add
#   SELECT azp03 INTO g_dbs_new FROM azp_file
#    WHERE azp01 = l_axz03
#   IF STATUS THEN
#      CALL cl_err3("sel","azp_file",l_axz03,"",STATUS,"","",1)  #No.FUN-660123
#      LET g_dbs_new = NULL
#      LET g_action_choice = ""   #No:TQC-5B0064
#      RETURN
#   END IF
#   LET g_dbs_new[21,21] = ':'
#
#   LET g_dbs_gl = g_dbs_new 
#
#   #--FUN-950051 start---
#   SELECT COUNT(*) INTO g_axa_count                                                                                                 
#     FROM axb_file                                                                                                                  
#    WHERE axb04 = g_axee01   #公司編號                                                                                               
#      AND axb01 = g_axee13   #群組                                                                                                   
#
#   IF g_axa_count > 0 THEN        #為底層公司時                                                                                   
#       #先抓出上一層的公司是哪個PLANT                                                                                               
#       SELECT axb02 INTO l_axb02                                                                                                    
#         FROM axb_file                                                                                                              
#        WHERE axb01 = g_axee13  #族群                                                                                                
#          AND axb04 = g_axee01  #公司編號                                                                                            
#       SELECT axa09 INTO l_axa09 FROM axa_file,axb_file                                                                                          
#        WHERE axa01 = axb01 
#          AND axa02 = axb02
#          AND axa01 = g_axee13   #群組                                                                                                   
#          AND axb02 = l_axb02   #上層公司
#          AND axb04 = g_axee01   #下層公司編號                                                                                               
#   ELSE
#       SELECT axa09 INTO l_axa09 FROM axa_file                                                                                          
#        WHERE axa01 = g_axee13   #群組                                                                                                   
#          AND axa02 = g_axee01   #公司編號                                                                                               
#   END IF
#   #---FUN-950051 end------
#
#   IF l_axa09 = 'Y' THEN          #FUN-950051 
#       IF g_axa_count > 0 THEN        #為底層公司時                                                                                   
#           #來源營運中心DB 
#           SELECT axz03 INTO g_axz03 FROM axz_file
#            WHERE axz01 = g_axee01
#           LET g_plant_new = g_axz03      #營運中心
#           CALL s_getdbs()
#           LET g_dbs_axz03 = g_dbs_new    #所屬DB
#           LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#                       " WHERE aaz00 = '0'"
#           PREPARE i0011_pre_02 FROM g_sql
#           DECLARE i0011_cur_02 CURSOR FOR i0011_pre_02
#           OPEN i0011_cur_02
#           FETCH i0011_cur_02 INTO g_aaz641    #合併後帳別
#           IF cl_null(g_aaz641) THEN
#               CALL cl_err(g_axz03,'agl-601',1)
#           END IF
#   
##--FUN-950051 mark-------- 
##          SELECT COUNT(*) INTO g_axb_count
##            FROM axb_file
##           WHERE axb04 = g_axee01   #公司編號
##             AND axb01 = g_axee13   #群組
##   
##          #IF g_axb_count = 1 THEN   #為下層公司時      
##          IF g_axb_count > 0 THEN   #為下層公司時       #FUN-950051 mod
##              #先抓出上一層的公司是哪個PLANT
##              SELECT axb02 INTO l_axb02_g
##                FROM axb_file 
##               WHERE axb01 = g_axee13  #族群
##                 AND axb04 = g_axee01  #公司編號
##                 AND axb05 = g_axee00  #帳別
##--FUN-950051 mark---------
#
#            #上層公司編號在agli009中所設定工廠/DB
#            SELECT axz03 INTO g_axz03_g FROM axz_file
#             #WHERE axz01 = l_axb02_g
#             WHERE axz01 = l_axb02          #FUN-950051
#            LET g_plant_new = g_axz03_g    #營運中心
#            CALL s_getdbs()
#            LET g_dbs_axz03_g = g_dbs_new    #上層公司所屬DB
#         
#            #上層公司所屬合併帳別
#            LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03_g,"aaz_file",
#                        " WHERE aaz00 = '0'"
#            PREPARE i0011_pre_01 FROM g_sql
#            DECLARE i0011_cur_01 CURSOR FOR i0011_pre_01
#            OPEN i0011_cur_01
#            FETCH i0011_cur_01 INTO g_aaz641_g
#            IF cl_null(g_aaz641_g) THEN
#                CALL cl_err(g_axz03_g,'agl-601',1)
#            END IF
#        END IF
#    #FUN-950051--mod--str                                                                                                            
#    ELSE                                                                                                                             
#       LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  #當前DB                                                                                                    
#       LET g_dbs_axz03_g = s_dbstring(g_dbs CLIPPED) #當前DB
#       SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'                                                                   
#       LET g_aaz641_g = g_aaz641                                                                                                     
#       LET g_dbs_gl = g_dbs_axz03
#    END IF                                                                                                                           
#    #FUN-950051--mod--end 
#--FUN-980040 mark----------------------------------

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql =
       "SELECT axee04,axee05,axee06,'',axee11,axee12 FROM axee_file ",  #FUN-580063
       " WHERE axee13= ? AND axee01= ? AND axee00 = ? AND axee04 = ? FOR UPDATE "  #No.FUN-730070  #FUN-910001 add axee13
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i0011_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR

   LET l_ac_t = 0
   INPUT ARRAY g_axee WITHOUT DEFAULTS FROM s_axee.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,
                   DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_axee_t.* = g_axee[l_ac].*  #BACKUP

            OPEN i0011_bcl USING g_axee13,g_axee01,g_axee00,g_axee_t.axee04  #No.FUN-730070  #FUN-910001
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_axee_t.axee04,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i0011_bcl INTO g_axee[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_axee_t.axee04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
#--FUN-920144 start----
#                  CALL i0011_axee06(l_ac)
                   LET g_sql = "SELECT aag02 ",
                               #"  FROM ",g_dbs_axz03_g,"aag_file",
                              #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-950051  #FUN-A50102
                               "  FROM ",cl_get_target_table(g_axz03,'aag_file'),   #FUN-A50102
                               " WHERE aag01 = '",g_axee[l_ac].axee04,"'",
                               #"   AND aag00 = '",g_aaz641_g,"'"
                               "   AND aag00 = '",g_aaz641,"'"    #FUN-950051 
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql  #FUN-A50102
                   PREPARE i0011_pre_07 FROM g_sql
                   DECLARE i0011_cur_07 CURSOR FOR i0011_pre_07
                   OPEN i0011_cur_07
                   FETCH i0011_cur_07 INTO g_axee[l_ac].axee05
                   LET g_sql = "SELECT aag02 ",
                              #"  FROM ",g_dbs_axz03_g,"aag_file",   #FUN-A50102
                               "  FROM ",cl_get_target_table(g_axz03_g,'aag_file'),    #FUN-A50102
                               " WHERE aag01 = '",g_axee[l_ac].axee06,"'",
                               "   AND aag00 = '",g_aaz641_g,"'"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,g_axz03_g) RETURNING g_sql  #FUN-A50102
                   PREPARE i0011_pre_06 FROM g_sql
                   DECLARE i0011_cur_06 CURSOR FOR i0011_pre_06
                   OPEN i0011_cur_06
                   FETCH i0011_cur_06 INTO g_axee[l_ac].aag02
#--FUN-920144 end----
               END IF
            END IF

            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF 

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axee[l_ac].* TO NULL
         LET g_axee_t.* = g_axee[l_ac].*  
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD axee04

      AFTER INSERT
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         INSERT INTO axee_file(axee00,axee01,axee04,axee05,axee06,axee11,axee12,axeeacti,axeeuser,  #No.FUN-730070
                              axeegrup,axeemodu,axeedate,axee13)  #FUN-910001 add axee13
                       VALUES(g_axee00,g_axee01,g_axee[l_ac].axee04,g_axee[l_ac].axee05,  #No.FUN-730070
                              g_axee[l_ac].axee06,g_axee[l_ac].axee11,g_axee[l_ac].axee12,
                              'Y',g_user,g_grup,g_user,g_today,g_axee13)  #FUN-910001 add g_axee13

         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axee_file",g_axee01,g_axee[l_ac].axee04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      AFTER FIELD axee04
         IF NOT cl_null(g_axee[l_ac].axee04) THEN 
            #--FUN-950051 mark---
            #IF g_axee[l_ac].axee04 != g_axee_t.axee04 OR 
            #   g_axee_t.axee04 IS NULL THEN              
            #   SELECT count(*) INTO l_n FROM axee_file
            #    WHERE axee01 = g_axee01 AND axee04 = g_axee[l_ac].axee04
            #      AND axee00 = g_axee00 AND axee13 = g_axee13  #No.FUN-730070  #FUN-910001 add axee13
            #   IF l_n > 0 THEN
            #      CALL cl_err(g_axee[l_ac].axee04,-239,0)
            #      LET g_axee[l_ac].axee04 = g_axee_t.axee04
            #      NEXT FIELD axee04
            #   ELSE  
            #--FUN-950051 mark---
                 #MOD-5A0443
                  LET l_axz04 = ' '
                  SELECT axz04 INTO l_axz04 FROM axz_file
                   WHERE axz01 = g_axee01
                  LET g_errno = ' '
                  LET l_axee05 = ' '
                  #IF l_axz04 = 'Y' THEN 
                  IF l_axz04 = 'N' THEN   #FUN-950051
                    #CALL s_m_aag(g_dbs_gl,g_axee[l_ac].axee04,g_axee00) RETURNING l_axee05                 
                    #CALL s_m_aag(g_dbs_gl,g_axee[l_ac].axee04,g_aaz641) RETURNING l_axee05 #FUN-920025 add  #TQC-9C0099              
                    #CALL s_m_aag(g_plant,g_axee[l_ac].axee04,g_aaz641) RETURNING l_axee05 #FUN-920025 add   #TQC-9C0099 #CHI-9C0038             
                    #CALL i0011_axee04(g_dbs_gl,l_ac)    #CHI-9C0038 #FUN-A50102
                     CALL i0011_axee04(g_plant,l_ac)   #FUN-A50102 
                     #FUN-940047 start---
                     LET l_aag04 = ''
                    #LET l_sql = " SELECT aag04 FROM ",g_dbs_gl,"aag_file",  #FUN-A50102
                     LET l_sql = " SELECT aag04 FROM aag_file ",  #FUN-A50102 
                                 "  WHERE aag00 = '",g_aaz641,"'",
                                 "    AND aag01 = '",g_axee[l_ac].axee04,"'",
                                 "    AND aag09 = 'Y'"                       #FUN-B60082
                     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
                     DECLARE aag_sel_c1 CURSOR FROM l_sql
                     OPEN aag_sel_c1 
                     FETCH aag_sel_c1 INTO l_aag04
                     CLOSE aag_sel_c1 
                     #FUN-950049 end-----
                  ELSE                                                                                      
                    #CALL s_m_aag(g_dbs_axz03,g_axee[l_ac].axee04,g_aaz641) RETURNING g_axee[l_ac].axee05  #FUN-950051#TQC-9C0099
                    #CALL s_m_aag(g_axz03,g_axee[l_ac].axee04,g_aaz641) RETURNING g_axee[l_ac].axee05  #FUN-950051  #TQC-9C0099 #CHI-9C0038
                    #CALL i0011_axee04(g_dbs_axz03,l_ac)   #CHI-9C0038  #FUN-A50102
                     CALL i0011_axee04(g_axz03,l_ac)       #FUN-A50102 
                     #FUN-950049 start---
                     LET l_aag04 = ''
                    #LET l_sql = " SELECT aag04 FROM ",g_dbs_axz03,"aag_file",   #FUN-A50102
                     LET l_sql = " SELECT aag04 FROM ",cl_get_target_table(g_axz03,'aag_file'),  #FUN-A50102
                                 "  WHERE aag00 = '",g_aaz641,"'",
                                 "    AND aag01 = '",g_axee[l_ac].axee04,"'",
                                 "    AND aag09 = 'Y'"                           #FUN-B60082 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
                     CALL cl_parse_qry_sql(l_sql,g_axz03) RETURNING l_sql  #FUN-A50102
                          DECLARE aag_sel_c2 CURSOR FROM l_sql
                     OPEN aag_sel_c2 
                     FETCH aag_sel_c2 INTO l_aag04
                     CLOSE aag_sel_c2
                     #FUN-950049 end-----
                     #--FUN-950051 mark---
                     ##---FUN-920035 start----
                     #    LET g_sql = "SELECT aag02",
                     #                "  FROM ",g_dbs_axz03,"aag_file",
                     #                " WHERE aag01 = '",g_axee[l_ac].axee04,"'",
                     #                "   AND aag00 = '",g_aaz641,"'"
                     #    PREPARE i0011_pre_12 FROM g_sql
                     #    DECLARE i0011_cur_12 CURSOR FOR i0011_pre_12
                     #    OPEN i0011_cur_12
                     #    FETCH i0011_cur_12 INTO l_axee05
                     #--FUN-920035 end------------------------
                     #--FUN-950051 Mark-----------------------
                          DISPLAY BY NAME g_axee[l_ac].axee05
		     #SELECT aag02 INTO l_axee05 FROM aag_file WHERE aag01=g_axee[l_ac].axee04   #FUN-760053 add  #FUN-950051 mark
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_axee[l_ac].axee04,g_errno,0)
                    #FUN-B20004--begin
                    #CALL q_m_aag2(FALSE,FALSE,g_plant,g_axee[l_ac].axee04,'23',g_aaz641) #FUN-920025 mod  #TQC-9C0099   #FUN-B50001
                    #CALL q_m_aag2(FALSE,FALSE,g_plant,g_axee[l_ac].axee04,'23',g_aaw01)  #FUN-B60082 mark #FUN-B50001
                    #CALL q_m_aag4(FALSE,FALSE,g_plant,g_axee[l_ac].axee04,'23',g_aaw01)  #FUN-BA0012 mark #FUN-B60082 mod  #FUN-B50001
                     CALL q_m_aag4(FALSE,FALSE,g_plant,g_axee[l_ac].axee04,'23',g_aaz641) #FUN-BA0012
                     RETURNING g_axee[l_ac].axee04
                    #LET g_axee[l_ac].axee04=g_axee_t.axee04
                    #FUN-B20004--end
                     NEXT FIELD axee04
                  END IF
                  #IF cl_null(g_axee[l_ac].axee05) THEN    #FUN-950051 mark 
                  #   LET g_axee[l_ac].axee05 = l_axee05   #FUN-950051 mark
                  #END IF                                  #FUN-950051 mark
               #END IF   #FUN-950051 mark
            #END IF   #FUN-950051 mark
         END IF
         #FUN-950049 start---
        #IF g_axee[l_ac].axee04 != g_axee_t.axee04 THEN     #MOD-A70031 add                                           #MOD-AA0186 mark 
         IF (g_axee_t.axee04 IS NOT NULL AND g_axee[l_ac].axee04 != g_axee_t.axee04) OR g_axee_t.axee04 IS NULL THEN  #MOD-AA0186
            IF l_aag04 = '1' THEN
               LET g_axee[l_ac].axee11 = '1'
               LET g_axee[l_ac].axee12 = '1'
            ELSE
               LET g_axee[l_ac].axee11 = '3'
               LET g_axee[l_ac].axee12 = '3'
            END IF
         END IF       #MOD-A70031 add
         #FUN-950049 end-----------
         CALL i0011_set_entry_b(p_cmd)      #MOD-5A0443
         CALL i0011_set_no_entry_b(p_cmd)   #MOD-5A0443

      AFTER FIELD axee06
         IF NOT cl_null(g_axee[l_ac].axee06) THEN 
            CALL i0011_axee06(l_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axee[l_ac].axee06,g_errno,0)
              #FUN-B20004--begin
              #CALL q_m_aag2(FALSE,FALSE,g_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-B50001
              #CALL q_m_aag2(FALSE,FALSE,g_axz03_g,g_axee[1].axee06,'23',g_aaw01_g)   #FUN-B60082 mark #FUN-B50001
              #CALL q_m_aag4(FALSE,FALSE,g_axz03_g,g_axee[1].axee06,'23',g_aaw01_g)   #FUN-BA0012 mark #FUN-B60082 mod  #FUN-B50001
               CALL q_m_aag4(FALSE,FALSE,g_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-BA0012
                    RETURNING g_axee[l_ac].axee06
               #LET g_axee[l_ac].axee06=g_axee_t.axee06
               #FUN-B20004--end
               NEXT FIELD axee06
            END IF
         END IF
      
      BEFORE DELETE                            #是否取消單身
         IF g_axee_t.axee04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 

            DELETE FROM axee_file
             WHERE axee01 = g_axee01 AND axee04 = g_axee_t.axee04 
               AND axee00 = g_axee00 AND axee13 = g_axee13  #No.FUN-730070  #FUN-910001 add axee13
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axee_file",g_axee01,g_axee[l_ac].axee04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF

            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axee[l_ac].* = g_axee_t.*
            CLOSE i0011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN 
            CALL cl_err(g_axee[l_ac].axee04,-263,0)
            LET g_axee[l_ac].* = g_axee_t.*
         ELSE 
            UPDATE axee_file SET axee04 = g_axee[l_ac].axee04,
                                axee05 = g_axee[l_ac].axee05,
                                axee06 = g_axee[l_ac].axee06,
                                axee11 = g_axee[l_ac].axee11,   #FUN-580063
                                axee12 = g_axee[l_ac].axee12,   #FUN-580063
                                axeemodu = g_user,
                                axeedate = g_today
             WHERE axee01 = g_axee01 
               AND axee00 = g_axee00  #No.FUN-730070
               AND axee13 = g_axee13  #FUN-910001 add
               AND axee04 = g_axee_t.axee04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axee_file",g_axee01,g_axee_t.axee04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_axee[l_ac].* = g_axee_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_axee[l_ac].* = g_axee_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_axee.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i0011_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  
         CLOSE i0011_bcl
         COMMIT WORK
      
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axee04) AND l_ac > 1 THEN
            LET g_axee[l_ac].* = g_axee[l_ac-1].*
            NEXT FIELD axee04
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axee04)  
               #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_axee[l_ac].axee04,'23',g_axee00)  #FUN-920025 mark
               #CALL q_m_aag2(FALSE,TRUE,g_dbs_gl,g_axee[l_ac].axee04,'23',g_aaz641) #FUN-920025 mod#TQC-9C0099
               #CALL q_m_aag2(FALSE,TRUE,g_plant,g_axee[l_ac].axee04,'23',g_aaz641)  #FUN-920025 mod  #TQC-9C0099 #FUN-B50001 
               #CALL q_m_aag2(FALSE,TRUE,g_plant,g_axee[l_ac].axee04,'23',g_aaw01)   #FUN-B60082 mark #FUN-B50001
               #CALL q_m_aag4(FALSE,TRUE,g_plant,g_axee[l_ac].axee04,'23',g_aaw01)   #FUN-BA0012 mark #FUN-B60082 mod  #FUN-B50001
                CALL q_m_aag4(FALSE,TRUE,g_plant,g_axee[l_ac].axee04,'23',g_aaz641)  #FUN-BA0012
                    RETURNING g_axee[l_ac].axee04
                DISPLAY BY NAME g_axee[l_ac].axee04           #No:MOD-490344
                NEXT FIELD axee04
            WHEN INFIELD(axee06)  
            #--FUN-920035 start---
              #CALL q_m_aag(FALSE,TRUE,g_dbs_axz03,g_axee[1].axee06,'23',g_aaz641)   #FUN-920025 mark
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-920025 mod#TQC-9C0099
              #CALL q_m_aag2(FALSE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-920025 mod  #TQC-9C0099  #FUN-B50001
              #CALL q_m_aag2(FALSE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaw01_g)   #FUN-B60082 mark #FUN-B50001 
              #CALL q_m_aag4(FALSE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaw01_g)   #FUN-BA0012 mark #FUN-B60082 mod  #FUN-B50001 
               CALL q_m_aag4(FALSE,TRUE,g_axz03_g,g_axee[1].axee06,'23',g_aaz641_g)  #FUN-BA0012
                    RETURNING g_axee[l_ac].axee06
               DISPLAY g_qryparam.multiret TO axee06 
               NEXT FIELD axee06
            #--FUN-920035 end----
            ####FUN-920035 mark####
            #    #No.MOD-480092 (end)
            #    CALL cl_init_qry_var()
            #    LET g_qryparam.form ="q_aag"
            #    LET g_qryparam.default1 = g_axee[l_ac].axee06
            #   #LET g_qryparam.arg1 = g_axee00  #No.FUN-730070      #FUN-760003 mark
            #   #LET g_qryparam.arg1 = g_aaz.aaz64  #No.FUN-730070  #FUN-760003  #FUN-910001 mark
            #    LET g_qryparam.arg1 = g_aaz.aaz641 #No.FUN-730070  #FUN-760003  #FUN-910001
            #    CALL cl_create_qry() RETURNING g_axee[l_ac].axee06
            #    DISPLAY BY NAME g_axee[l_ac].axee06           #No:MOD-490344
            #    NEXT FIELD axee06 
            #    #No.MOD-480092 (end)
            ####FUN-920035 mark####
            OTHERWISE EXIT CASE
         END CASE

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
      #No.FUN-6B0029--begin                                             
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
      #No.FUN-6B0029--end 

   END INPUT

   CLOSE i0011_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i0011_axee06(l_cnt)
DEFINE
    l_cnt           LIKE type_file.num5,          #No.FUN-680098 smallint
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
#--FUN-920035 mark----
#    SELECT aag02,aag03,aag07,aagacti
#      INTO l_aag02,l_aag03,l_aag07,l_aagacti
#      FROM aag_file
#     WHERE aag01 = g_axee[l_cnt].axee06
#      #AND aag00 = g_axee00  #No.FUN-730070       #FUN-760003 mark
#      #AND aag00 = g_aaz.aaz64  #No.FUN-730070   #FUN-760003  #FUN-910001 mark
#       AND aag00 = g_aaz.aaz641 #No.FUN-730070   #FUN-760003  #FUN-910001
#--FUN-920035 mark-----

    #---FUN-920035 start----
        LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                   #"  FROM ",g_dbs_axz03_g,"aag_file",  #FUN-A50102
                    "  FROM ",cl_get_target_table(g_axz03_g,'aag_file'),   #FUN-A50102
                    " WHERE aag01 = '",g_axee[l_cnt].axee06,"'",
                    "   AND aag00 = '",g_aaz641_g,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,g_axz03_g) RETURNING g_sql  #FUN-A50102
        PREPARE i0011_pre_03 FROM g_sql
        DECLARE i0011_cur_03 CURSOR FOR i0011_pre_03
        OPEN i0011_cur_03
        FETCH i0011_cur_03 INTO l_aag02,l_aag03,l_aag07,l_aagacti
    #--FUN-920035 end------------------------

    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001' 
         WHEN l_aagacti = 'N'     LET g_errno = '9028' 
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
        #WHEN l_aag03 != '2'      LET g_errno = 'agl-201'    #MOD-760085
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE 

   #FUN-B60082--begin--
    IF SQLCA.sqlcode = 0 THEN
       LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                   "  FROM ",cl_get_target_table(g_axz03_g,'aag_file'),
                   " WHERE aag01 = '",g_axee[l_cnt].axee06,"'",
                  #"  AND aag00 = '",g_aaw01_g,"'",     #FUN-BA0012
				   "  AND aag00 = '",g_aaz641_g,"'",    #FUN-BA0012
                   "  AND aag09 = 'Y'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       PREPARE i0011_pre_04 FROM g_sql
       DECLARE i0011_cur_04 CURSOR FOR i0011_pre_04
       OPEN i0011_cur_04
       FETCH i0011_cur_04 INTO l_aag02,l_aag03,l_aag07,l_aagacti

       CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
            WHEN l_aagacti = 'N'     LET g_errno = '9028'
            WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
            OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------' 
       END CASE
    END IF
   #FUN-B60082---end---
    IF cl_null(g_errno) THEN
      #LET g_axee[l_cnt].aag02 = l_aag02
      LET g_axee[l_ac].aag02 = l_aag02      #FUN-920035
    END IF
    
END FUNCTION
   
#CHI-9C0038--add--str--
#FUNCTION i0011_axee04(l_dbs,l_cnt)  #FUN-A50102
FUNCTION i0011_axee04(l_plant,l_cnt)   #FUN-A50102
DEFINE
    l_cnt           LIKE type_file.num5,
   #l_dbs           LIKE type_file.chr21,
    l_plant         LIKE azp_file.azp01,    #FUN-A50102 
    l_aag02         LIKE aag_file.aag02,
    l_aag03         LIKE aag_file.aag03,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '

    LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
               #"  FROM ",l_dbs,"aag_file",   #FUN-A50102
                "  FROM ",cl_get_target_table(l_plant,'aag_file'),   #FUN-A50102
                " WHERE aag01 = '",g_axee[l_cnt].axee04,"'",
                "   AND aag00 = '",g_aaz641,"'"
    #CALL cl_replace_sqldb(l_plant) RETURNING g_sql   #FUN-A50102   #MOD-B30236
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #MOD-B30236
    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
    PREPARE i0011_sel_aag FROM g_sql
    DECLARE i0011_cur_aag CURSOR FOR i0011_sel_aag
    OPEN i0011_cur_aag
    FETCH i0011_cur_aag INTO l_aag02,l_aag03,l_aag07,l_aagacti

    CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
         WHEN l_aagacti = 'N'     LET g_errno = '9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE

   #FUN-B60082--begin--
    IF SQLCA.sqlcode = 0 THEN
       LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                   "  FROM ",cl_get_target_table(l_plant,'aag_file'),
                   " WHERE aag01 = '",g_axee[l_cnt].axee04,"'",
                  #"   AND aag00 = '",g_aaw01,"'",		#FUN-BA0012
                   "   AND aag00 = '",g_aaz641,"'",             #FUN-BA0012
                   "   AND aag09 = 'Y'" 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       PREPARE i0011_pre_05 FROM g_sql
       DECLARE i0011_cur_05 CURSOR FOR i0011_pre_05
       OPEN i0011_cur_05
       FETCH i0011_cur_05 INTO l_aag02,l_aag03,l_aag07,l_aagacti

       CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
            WHEN l_aagacti = 'N'     LET g_errno = '9028'
            WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
            OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------' 
       END CASE
    END IF
   #FUN-B60082---end---

    IF cl_null(g_errno) THEN
      LET g_axee[l_ac].axee05 = l_aag02
    END IF

END FUNCTION
#CHI-9C0038--add--end

FUNCTION i0011_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000    #No.FUN-680098 char(200)

   CLEAR FORM
   CALL g_axee.clear()
   CALL g_axee.clear()

   CONSTRUCT l_wc ON axee04,axee05,axee06,axee11,axee12  #螢幕上取條件
        FROM s_axee[1].axee04,s_axee[1].axee05,s_axee[1].axee06,s_axee[1].axee11,s_axee[1].axee12

      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121

      #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
         CALL cl_qbe_select() 
       ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN 
   END IF

   CALL i0011_b_fill(l_wc)
   
END FUNCTION

FUNCTION i0011_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc      LIKE type_file.chr1000 #No.FUN-680098  char(200)
DEFINE l_axb02   LIKE axb_file.axb02    #FUN-950051
DEFINE l_axb02_g LIKE axb_file.axb02    #FUN-920144
DEFINE l_axa09   LIKE axa_file.axa09     #FUN-950051

#---FUN-980040 mark---移至i0011_getdbs()處理--
#   #--FUN-950051 start---
#   SELECT COUNT(*) INTO g_axa_count                                                                                                 
#     FROM axb_file                                                                                                                  
#    WHERE axb04 = g_axee01   #公司編號                                                                                               
#      AND axb01 = g_axee13   #群組                                                                                                   
#
#   IF g_axa_count > 0 THEN        #為底層公司時                                                                                   
#       #先抓出上一層的公司是哪個PLANT                                                                                               
#       SELECT axb02 INTO l_axb02                                                                                                    
#         FROM axb_file                                                                                                              
#        WHERE axb01 = g_axee13  #族群                                                                                                
#          AND axb04 = g_axee01  #公司編號                                                                                            
#          AND axb05 = g_axee00  #帳別                                                                                                
#       SELECT axa09 INTO l_axa09 FROM axa_file,axb_file                                                                                          
#        WHERE axa01 = axb01 
#          AND axa02 = axb02
#          AND axa01 = g_axee13   #群組                                                                                                   
#          AND axb02 = l_axb02   #上層公司
#          AND axb04 = g_axee01   #下層公司編號                                                                                               
#   ELSE
#       SELECT axa09 INTO l_axa09 FROM axa_file                                                                                          
#        WHERE axa01 = g_axee13   #群組                                                                                                   
#          AND axa02 = g_axee01   #公司編號                                                                                               
#   END IF
#   #---FUN-950051 end------
#
#   IF l_axa09 = 'Y' THEN          #FUN-950051 
#       IF g_axa_count > 0 THEN        #為底層公司時                                                                                   
#           #來源營運中心DB 
#           SELECT axz03 INTO g_axz03 FROM axz_file
#            WHERE axz01 = g_axee01
#           LET g_plant_new = g_axz03      #營運中心
#           CALL s_getdbs()
#           LET g_dbs_axz03 = g_dbs_new    #所屬DB
#           LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#                       " WHERE aaz00 = '0'"
#           PREPARE i0011_pre_10 FROM g_sql
#           DECLARE i0011_cur_10 CURSOR FOR i0011_pre_10
#           OPEN i0011_cur_10
#           FETCH i0011_cur_10 INTO g_aaz641    #合併後帳別
#           IF cl_null(g_aaz641) THEN
#               CALL cl_err(g_axz03,'agl-601',1)
#           END IF
#   
##--FUN-950051 mark-------- 
##          SELECT COUNT(*) INTO g_axb_count
##            FROM axb_file
##           WHERE axb04 = g_axee01   #公司編號
##             AND axb01 = g_axee13   #群組
##   
##          #IF g_axb_count = 1 THEN   #為下層公司時      
##          IF g_axb_count > 0 THEN   #為下層公司時       #FUN-950051 mod
##              #先抓出上一層的公司是哪個PLANT
##              SELECT axb02 INTO l_axb02_g
##                FROM axb_file 
##               WHERE axb01 = g_axee13  #族群
##                 AND axb04 = g_axee01  #公司編號
##                 AND axb05 = g_axee00  #帳別
##--FUN-950051 mark---------
#
#            #上層公司編號在agli009中所設定工廠/DB
#            SELECT axz03 INTO g_axz03_g FROM axz_file
#             #WHERE axz01 = l_axb02_g
#             WHERE axz01 = l_axb02         #FUN-950051
#            LET g_plant_new = g_axz03_g    #營運中心
#            CALL s_getdbs()
#            LET g_dbs_axz03_g = g_dbs_new    #上層公司所屬DB
#         
#            #上層公司所屬合併帳別
#            LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03_g,"aaz_file",
#                        " WHERE aaz00 = '0'"
#            PREPARE i0011_pre_11 FROM g_sql
#            DECLARE i0011_cur_11 CURSOR FOR i0011_pre_11
#            OPEN i0011_cur_11
#            FETCH i0011_cur_11 INTO g_aaz641_g
#            IF cl_null(g_aaz641_g) THEN
#                CALL cl_err(g_axz03_g,'agl-601',1)
#            END IF
#        END IF
#    #FUN-950051--mod--str                                                                                                            
#    ELSE                                                                                                                             
#       LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  #當前DB                                                                                                    
#       LET g_dbs_axz03_g = s_dbstring(g_dbs CLIPPED) #當前DB
#       SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'                                                                   
#       LET g_aaz641_g = g_aaz641                                                                                                     
#    END IF                                                                                                                           
#    #FUN-950051--mod--end 
#----FUN-980040 mark----------------------------------

##--FUN-920144 start----
   LET g_sql = "SELECT axee04,axee05,axee06,'',axee11,axee12 ",  #FUN-580063
               "  FROM axee_file ",
               " WHERE axee01 = '",g_axee01,"' AND ", p_wc CLIPPED ,
               "   AND axee00 = '",g_axee00,"'", 
               "   AND axee13 = '",g_axee13,"'",   #FUN-910001 add
               " ORDER BY 1,2 "
   PREPARE i0011_prepare2 FROM g_sql      #預備一下
   DECLARE axee_cs CURSOR FOR i0011_prepare2

   CALL g_axee.clear()
   
  #FUN-A30122 ------------------------add start---------------------------
   CALL s_aaz641_dbs(g_axee13,g_axee01) RETURNING g_plant_axz03                   
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                            
   SELECT axb02 INTO g_axa02  #上层公司                                         
     FROM axb_file                                                              
    WHERE axb01 = g_axee13                                                      
      AND axb04 = g_axee01                                                      
   CALL s_aaz641_dbs(g_axee13,g_axa02) RETURNING g_plant_axz03_g                  
   CALL s_get_aaz641(g_plant_axz03_g) RETURNING g_aaz641_g 
  #FUN-A30122 ------------------------add end--------------------------------
     

   LET g_cnt = 1
   LET g_rec_b = 0

   CALL i0011_getdbs(g_axee01,g_axee13)   #FUN-980040 add

   FOREACH axee_cs INTO g_axee[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

#--FUN-920144 start----
#      CALL i0011_axee06(g_cnt)
       LET g_sql = "SELECT aag02 ",
                  #"  FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
                   "  FROM ",cl_get_target_table(g_axz03,'aag_file'),   #FUN-A50102
                   " WHERE aag01 = '",g_axee[g_cnt].axee04,"'",
                   "   AND aag00 = '",g_aaz641,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql  #FUN-A50102
       PREPARE i0011_pre_08 FROM g_sql
       DECLARE i0011_cur_08 CURSOR FOR i0011_pre_08
       OPEN i0011_cur_08
       FETCH i0011_cur_08 INTO g_axee[g_cnt].axee05
       LET g_sql = "SELECT aag02 ",
                  #"  FROM ",g_dbs_axz03_g,"aag_file",   #FUN-A50102
                   "  FROM ",cl_get_target_table(g_axz03_g,'aag_file'),   #FUN-A50102 
                   " WHERE aag01 = '",g_axee[g_cnt].axee06,"'",
                   "   AND aag00 = '",g_aaz641_g,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
       CALL cl_parse_qry_sql(g_sql,g_axz03_g) RETURNING g_sql  #FUN-A50102
       PREPARE i0011_pre_09 FROM g_sql
       DECLARE i0011_cur_09 CURSOR FOR i0011_pre_09
       OPEN i0011_cur_09
       FETCH i0011_cur_09 INTO g_axee[g_cnt].aag02
#--FUN-920144 end----

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_axee.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1

   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i0011_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 char(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
  #CALL cl_set_comp_visible("axee01_1,axee13_1",FALSE)   #FUN-D40018 add
   DISPLAY ARRAY g_axee TO s_axee.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL i0011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i0011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL i0011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION next
         CALL i0011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION last
         CALL i0011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
                              

      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY

#@    ON ACTION 相關文件  
      ON ACTION related_document  #No:MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel   #No:FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
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
     #FUN-B90061--begin--
      ON ACTION dataload
         LET g_action_choice = 'dataload'
         EXIT DISPLAY
     #FUN-B90061---end---
     #FUN-D20044--
      ON ACTION excelexample 
         LET g_action_choice = 'excelexample'
         EXIT DISPLAY
     #FUN-D20044--

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

     #No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
     #No.FUN-6B0029--end
   
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 

FUNCTION i0011_copy()
DEFINE l_axee          RECORD LIKE axee_file.*,
       l_sql          LIKE type_file.chr1000,     #No.FUN-680098 char(100)
       l_oldno0       LIKE axee_file.axee00,        #No.FUN-730070
       l_newno0       LIKE axee_file.axee00,        #No.FUN-730070
       l_oldno1       LIKE axee_file.axee01,
       l_newno1       LIKE axee_file.axee01,
       l_oldno2       LIKE axee_file.axee13,        #FUN-910001 add
       l_newno2       LIKE axee_file.axee13,        #FUN-910001 add
       l_n,l_n1       LIKE type_file.num5         #FUN-910001 add
 
   IF s_aglshut(0) THEN RETURN END IF

   IF cl_null(g_axee13) OR cl_null(g_axee01) OR cl_null(g_axee00) THEN  #No.FUN-730070  #FUN-910001
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
  #CALL i0011_set_entry('a') 
   CALL i0011_set_entry('u')   #FUN-920025 mod 
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

  #INPUT l_newno2,l_newno1,l_newno0 FROM axee13,axee01,axee00  #FUN-920025 mark
   INPUT l_newno2,l_newno1,l_newno0 WITHOUT DEFAULTS FROM axee13,axee01,axee00  #FUN-920025  

     #str FUN-910001 add
      AFTER FIELD axee13   #族群代號
         IF l_newno2 IS NULL THEN
            NEXT FIELD axee13
         END IF

      AFTER FIELD axee01
         IF l_newno1 IS NULL THEN 
            NEXT FIELD axee01
         END IF
       # CALL i0011_axee01('a',l_newno1)         #FUN-A30122 mark
       
        #FUN-A30122 --------------------add start---------------------------
         SELECT axb02 INTO g_axa02  #上层公司                                  
            FROM axb_file                                                       
           WHERE axb01 = l_newno2                                               
             AND axb04 = l_newno1                                               
         SELECT axz02,axz03,axz04                                               
           INTO g_axz02,g_axz03,g_axz04 FROM axz_file                           
          WHERE axz01 = l_newno1                                                
         CALL s_aaz641_dbs(l_newno2,l_newno1) RETURNING g_plant_axz03             
         CALL s_get_aaz641(g_plant_axz03) RETURNING l_newno0                      
         DISPLAY g_axz02 TO FORMONLY.axz02                                      
         DISPLAY g_axz03 TO FORMONLY.axz03                                      
         DISPLAY l_newno0 TO FORMONLY.axee00
        #FUN-A30122 -----------------  add end ----------------------------- 

        #LET l_newno0=g_axee00       #FUN-920025 add     #FUN-A30122 mark
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_newno1,g_errno,0)
            NEXT FIELD axee01
         END IF
         IF l_newno2 IS NOT NULL AND l_newno1 IS NOT NULL AND 
            l_newno0 IS NOT NULL THEN
           #FUN-920025---mod---str---
            LET l_n = 0   
            SELECT COUNT(*) INTO l_n FROM axee_file
             WHERE axee13=l_newno2 AND axee01=l_newno1
               AND axee00=l_newno0   
            IF l_n >0 THEN
               CALL cl_err(l_newno1,'-239',0)   #error
               NEXT FIELD axee01
            END IF
            LET l_n1 = 0
            SELECT COUNT(*) INTO l_n1 FROM axa_file
             WHERE axa01 = l_newno2 AND axa02 = l_newno1
            IF l_n1 = 0 THEN
               CALL cl_err(l_newno1,'agl-223',0)
               NEXT FIELD axee01
            END IF 
           #LET l_n = 0   LET l_n1 = 0
           #SELECT COUNT(*) INTO l_n FROM axa_file
           # WHERE axa01=l_newno2 AND axa02=l_newno1
           #   AND axa03=l_newno0
           #SELECT COUNT(*) INTO l_n1 FROM axb_file
           # WHERE axb01=l_newno2 AND axb04=l_newno1
           #   AND axb05=l_newno0
           #IF l_n+l_n1 = 0 THEN
           #   CALL cl_err(l_newno1,'agl-223',0)
           #   NEXT FIELD axee01
           #END IF
           #FUN-920025---mod---end---
         END IF
        #end FUN-910001 add

      AFTER FIELD axee00
         IF cl_null(l_newno1) THEN NEXT FIELD axee01 END IF
         IF NOT cl_null(l_newno0) THEN
          # CALL i0011_axee00('a',l_newno0)              #FUN-A30122 mark
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_newno0,g_errno,0)
               NEXT FIELD axee00
            END IF
            LET g_cnt = 0  #FUN-910001 add
            SELECT COUNT(*) INTO g_cnt FROM axee_file
             WHERE axee01 = l_newno1 
               AND axee00 = l_newno0  
               AND axee13 = l_newno2   #FUN-910001 add
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno1,-239,0)
               NEXT FIELD axee01
            END IF
           #str FUN-910001 add
            LET l_n = 0   LET l_n1 = 0
            SELECT COUNT(*) INTO l_n FROM axa_file
             WHERE axa01=l_newno2 AND axa02=l_newno1
               AND axa03=l_newno0  
            SELECT COUNT(*) INTO l_n1 FROM axb_file
             WHERE axb01=l_newno2 AND axb04=l_newno1
               AND axb05=l_newno0  
            IF l_n+l_n1 = 0 THEN
               CALL cl_err(l_newno1,'agl-223',0)
               NEXT FIELD axee01
            END IF
           #end FUN-910001 add
         END IF

      ON ACTION CONTROLP
         CASE
           #str FUN-910001 add
            WHEN INFIELD(axee13) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO axee13
               NEXT FIELD axee13
           #end FUN-910001 add
            WHEN INFIELD(axee01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz" 
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO axee01 
               NEXT FIELD axee01
            WHEN INFIELD(axee00)  
               #str FUN-760003 add
               SELECT azp03 INTO g_azp03 FROM axz_file,azp_file
                WHERE axz01=l_newno1 AND axz03=azp01
               IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
               #end FUN-760003 add
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa4"   #TQC-760205 q_aaa->q_aaa4
               LET g_qryparam.default1 = l_newno0
               LET g_qryparam.arg1 = g_azp03   #TQC-760205 add
               CALL cl_create_qry() RETURNING l_newno0
               DISPLAY l_newno0 TO axee00 
               NEXT FIELD axee00
            OTHERWISE EXIT CASE
         END CASE

      #No.FUN-730070  --End  

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
      DISPLAY g_axee01 TO axee01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM axee_file         #單身複製
    WHERE axee01=g_axee01 
      AND axee00=g_axee00  #No.FUN-730070
      AND axee13=g_axee13  #FUN-910001 add
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axee_file",g_axee01,g_axee00,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730070
      RETURN
   END IF

   UPDATE x SET axee01=l_newno1,axee00=l_newno0,axee13=l_newno2  #No.FUN-730070  #FUN-910001 add axee13

   INSERT INTO axee_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axee_file",l_newno1,l_newno0,SQLCA.sqlcode,"","axee:",1)  #No.FUN-660123  #No.FUN-730070
      RETURN
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]

   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
       
   LET l_oldno2 = g_axee13   #FUN-910001 add
   LET l_oldno1 = g_axee01 
   LET l_oldno0 = g_axee00   #No.FUN-730070
   LET g_axee13=l_newno2     #FUN-910001 add
   LET g_axee01=l_newno1
   LET g_axee00=l_newno0     #No.FUN-730070

   CALL i0011_b()
   #FUN-C30027---begin
   #LET g_axee13=l_oldno2     #FUN-910001 add
   #LET g_axee01=l_oldno1
   #LET g_axee00=l_oldno0     #No.FUN-730070
   #
   #CALL i0011_show()
   #FUN-C30027---end
END FUNCTION

FUNCTION i0011_out()
   DEFINE l_i             LIKE type_file.num5,          #No.FUN-680098  smallint
          l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680098 char(20)
          l_chr           LIKE type_file.chr1,          #No.FUN-680098   char(1)  
          sr RECORD 
               axee13     LIKE axee_file.axee13,     #族群代號  #FUN-910001 add
               axee01     LIKE axee_file.axee01,     #營運中心
               axee00     LIKE axee_file.axee00,     #帳套  #No.FUN-730070
               axee04     LIKE axee_file.axee04,     #科目編號
               axee05     LIKE axee_file.axee05,     #科目名稱
               axee06     LIKE axee_file.axee06,     #合併財報科目編號
               aag02     LIKE aag_file.aag02,     #合併財報科目名稱
               axee11     LIKE axee_file.axee11,     #再衡量匯率類別
               axee12     LIKE axee_file.axee12      #換算匯率類別
             END RECORD
#FUN-590124 End

   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

#FUN-590124
   LET g_sql="SELECT axee13,axee01,axee00,axee04,axee05,axee06,aag02,axee11,axee12 ", # 組合出 SQL 指令  #No.FUN-730070  #FUN-910001 add axee13
    #        " FROM axee_file, OUTER aag_file ",              #FUN-920065 mark
             " FROM axee_file LEFT OUTER JOIN aag_file ",     #FUN-920065 add
             "   ON axee_file.axee06 = aag_file.aag01",
             "  AND aag_file.aag00 = '",g_aaz.aaz641,"'",
             " WHERE ",g_wc CLIPPED ,
    #        "   AND axee_file.axee06 = aag_file.aag01",      #FUN-920065 mark 
    #        "   AND aag_file.aag00 = '",g_aaz.aaz641,"'",    #FUN-910001 #FUN-920065 mark
             " ORDER BY axee13,axee01,axee00,axee04 "    #No.FUN-730070  #FUN-910001 add axee13

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'axee13,axee01,axee00,axee04,axee05,axee06,axee11,axee12')  #FUN-910001 mod                                 
      RETURNING g_wc                                                          
      LET g_str = g_str CLIPPED,";", g_wc                                     
   END IF                                                                      
   LET g_str =  g_wc    
   CALL cl_prt_cs1('agli0011','agli0011',g_sql,g_str)  #FUN-920095 add
END FUNCTION

 
FUNCTION i0011_g()
   DEFINE l_sql    LIKE type_file.chr1000,   #No.FUN-680098 char(200)
          l_axee06  LIKE axee_file.axee06,
          l_aag01  LIKE aag_file.aag01,
          l_aag02  LIKE aag_file.aag02,
          l_flag   LIKE type_file.chr1,      #TQC-590045        #No.FUN-680098 char(1)
          l_axz03  LIKE axz_file.axz03,      #TQC-660043
          l_axz04  LIKE axz_file.axz04,      #FUN-760053 add
          l_n      LIKE type_file.num5,      #FUN-740173 add
          l_n1     LIKE type_file.num5       #FUN-910001 add
DEFINE l_axb02     LIKE axb_file.axb02       #FUN-950051 
DEFINE l_axa09     LIKE axa_file.axa09       #FUN-950051
DEFINE l_aag04     LIKE aag_file.aag04       #FUN-950049
DEFINE l_axee11    LIKE axee_file.axee11     #FUN-950049
DEFINE l_axee12    LIKE axee_file.axee12     #FUN-950049

   OPEN WINDOW i0011_w3 AT 6,11
     WITH FORM "agl/42f/agli0011_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_locale("agli0011_g")

   CALL cl_getmsg('agl-021',g_lang) RETURNING g_msg
   MESSAGE g_msg 

   LET g_success='Y'   #TQC-590045

   WHILE TRUE   #TQC-590045
      CONSTRUCT g_wc ON aag01 FROM aag01
         #No:FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No:FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
	 #No:FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
	    CALL cl_qbe_save()
	 #No:FUN-580031 --end--       HCN
      END CONSTRUCT
    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i0011_w3 
         RETURN 
      END IF

      INITIALIZE tm.* TO NULL   #FUN-920025 add
    
      LET tm.y='Y'
      DISPLAY tm.y TO FORMONLY.y 
      DISPLAY tm.axee13 TO FORMONLY.axee13 #FUN-920025 add
      DISPLAY tm.axee01 TO FORMONLY.axee01 #FUN-920025 add 
      DISPLAY tm.axee00 TO FORMONLY.axee00 #FUN-920025 add 
    
     #INPUT tm.axee13,tm.axee01,tm.axee00,tm.y WITHOUT DEFAULTS   #No.FUN-730070        #FUN-910001 add axee13  #FUN-920035 mark
     #FROM FORMONLY.axee13,FORMONLY.axee01,FORMONLY.axee00,FORMONLY.y  #No.FUN-730070  #FUN-910001 add axee13  #FUN-920035 mark

      INPUT tm.axee13,tm.axee01,tm.y WITHOUT DEFAULTS   #No.FUN-730070        #FUN-910001 add axee13
       FROM FORMONLY.axee13,FORMONLY.axee01,FORMONLY.y  #No.FUN-730070  #FUN-910001 add axee13  
    
         AFTER FIELD axee01
            IF NOT cl_null(tm.axee01) THEN 
              #FUN-A30122 ----------------------add start----------------------------
               SELECT axb02 INTO g_axa02  #上层公司                             
                 FROM axb_file                                                  
                WHERE axb01 = tm.axee13                                         
                  AND axb04 = tm.axee01                                         
              SELECT axz02,axz03,axz04                                          
                INTO g_axz02,g_axz03,g_axz04 FROM axz_file                      
               WHERE axz01 = tm.axee01                                          
              CALL s_aaz641_dbs(tm.axee13,tm.axee01) RETURNING g_plant_axz03      
              CALL s_get_aaz641(g_plant_axz03) RETURNING g_axee00
             #FUN-A30122 ---------------------add end-----------------------------
  
#---FUN-980040 start---
             # CALL i0011_getdbs(tm.axee01,tm.axee13)   #FUN-980040      #FUN-A30122 mark
               DISPLAY g_axz02 TO FORMONLY.axz02 
               DISPLAY g_axz03 TO FORMONLY.axz03 
               DISPLAY g_axee00 TO FORMONLY.axee00  
#--FUN-980040 end------
               #--FUN-980040 mark---
               #CALL i0011_axee01('a',tm.axee01)        
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err(tm.axee01,g_errno,0)
               #   NEXT FIELD axee01
               #--FUN-980040 mark

               ##--FUN-920035 start---
               # ELSE
               #    SELECT axz05 INTO g_axee00_def
               #      FROM axz_file
               #     WHERE axz01 = tm.axee01
               # END IF
               ##--FUN-920035 end----
               #--FUN-950051 start----
                LET l_n = 0
                SELECT COUNT(*) INTO l_n 
                  FROM axa_file
                 WHERE axa01=tm.axee13
                   AND axa02=tm.axee01
                IF cl_null(l_n) THEN LET l_n = 0 END IF
                IF l_n = 0 THEN
                   CALL cl_err(tm.axee13,'agl-223',0)
                   NEXT FIELD axee01
                END IF
              #--FUN-950051 end ----
            END IF
    
         #--FUN-920035 mark---
         #  #No.FUN-730070  --Begin
         #  AFTER FIELD axee00
         #     IF NOT cl_null(tm.axee00) THEN 
         #        CALL i0011_axee00('a',tm.axee00)
         #        IF NOT cl_null(g_errno) THEN
         #           CALL cl_err(tm.axee00,g_errno,0)
         #           NEXT FIELD axee00
         #        END IF
         #        #str FUN-740173 add
         #        #增加公司+帳別的合理性判斷,應存在agli009
         #        LET l_n = 0
         #        SELECT COUNT(*) INTO l_n FROM axz_file
         #         WHERE axz01=tm.axee01 AND axz05=tm.axee00
         #        IF l_n = 0 THEN
         #           CALL cl_err(tm.axee00,'agl-946',0)
         #           NEXT FIELD axee00
         #        END IF
         #        #end FUN-740173 add
         #     END IF
         #    #str FUN-910001 add
         #     IF tm.axee13 IS NOT NULL AND tm.axee01 IS NOT NULL AND
         #        tm.axee00 IS NOT NULL THEN
         #        LET l_n = 0   LET l_n1 = 0
         #        SELECT COUNT(*) INTO l_n FROM axa_file
         #         WHERE axa01=tm.axee13 AND axa02=tm.axee01
         #           AND axa03=tm.axee00
         #        SELECT COUNT(*) INTO l_n1 FROM axb_file
         #         WHERE axb01=tm.axee13 AND axb04=tm.axee01
         #           AND axb05=tm.axee00
         #        IF l_n+l_n1 = 0 THEN
         #           CALL cl_err(tm.axee01,'agl-223',0)
         #           NEXT FIELD axee00
         #        END IF
         #     END IF
         #    #end FUN-910001 add
         #  #No.FUN-730070  --Begin
         #--FUN-920035 mark--

         AFTER FIELD y
            IF NOT cl_null(tm.y) THEN 
               IF tm.y NOT MATCHES '[YN]' THEN
                  NEXT FIELD y
               END IF 
            END IF
    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
    
         ON ACTION CONTROLP
            CASE
              #str FUN-910001 add
               WHEN INFIELD(axee13) #族群編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axa1"
                  LET g_qryparam.default1 = tm.axee13
                  CALL cl_create_qry() RETURNING tm.axee13
                  DISPLAY tm.axee13 TO axee13
                  NEXT FIELD axee13
              #end FUN-910001 add
               WHEN INFIELD(axee01)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz"      #FUN-580063 q_azp->q_axz
                  LET g_qryparam.default1 = tm.axee01
                  CALL cl_create_qry() RETURNING tm.axee01
                  DISPLAY tm.axee01 TO axee01 
                  NEXT FIELD axee01
               
              #FUN-920025---mark---str---
              ##No.FUN-730070  --Begin
              #WHEN INFIELD(axee00)  
              #   #str FUN-760003 adend
              #   SELECT azp03 INTO g_azp03 FROM axz_file,azp_file
              #    WHERE axz01=tm.axee01 AND axz03=azp01
              #   IF cl_null(g_azp03) THEN LET g_azp03 = g_dbs END IF
              #   #end FUN-760003 add
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_aaa4"   #TQC-760205 q_aaa->q_aaa4
              #   LET g_qryparam.default1 = tm.axee00
              #   LET g_qryparam.arg1 = g_azp03   #TQC-760205 add
              #   CALL cl_create_qry() RETURNING tm.axee00
              #   DISPLAY tm.axee00 TO axee00 
              #   NEXT FIELD axee00
              ##No.FUN-730070  --End  
              #FUN-920025---mark---end---
               OTHERWISE EXIT CASE
            END CASE
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
        
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
      END INPUT
    
      IF INT_FLAG THEN 
         LET INT_FLAG=0
         CLOSE WINDOW i0011_w3
         RETURN
      END IF
    
      IF cl_sure(0,0) THEN 
         BEGIN WORK     #No.TQC-740199
       # CALL i0011_getdbs(tm.axee01,tm.axee13)   #FUN-980040      #FUN-A30122 mark

#--------------FUN-980040 mark----移至i0011_getdbs()----
#         LET g_plant_new = tm.axee01 
#         SELECT axz03,axz04 INTO l_axz03,l_axz04 FROM axz_file   #FUN-760053 add axz04
#          WHERE axz01 = g_plant_new
#
#         #使用tiptop否(axz04)=N,表示為非TIPTOP公司,預設目前所在DB給他
#	 IF l_axz04 = 'N' THEN LET l_axz03=g_plant END IF        #FUN-760053 add
#         #--FUN-950051 start---
#         SELECT COUNT(*) INTO g_axa_count                                                                                                 
#           FROM axb_file                                                                                                                  
#          WHERE axb04 = tm.axee01   #公司編號                                                                                               
#            AND axb01 = tm.axee13   #群組                                                                                                   
#
#         IF g_axa_count > 0 THEN        #為底層公司時                                                                                   
#             #先抓出上一層的公司是哪個PLANT                                                                                               
#             SELECT axb02 INTO l_axb02                                                                                                    
#               FROM axb_file                                                                                                              
#              WHERE axb01 = tm.axee13  #族群                                                                                                
#                AND axb04 = tm.axee01  #公司編號                                                                                            
#             SELECT axa09 INTO l_axa09 FROM axa_file,axb_file                                                                                          
#              WHERE axa01 = axb01 
#                AND axa02 = axb02
#                AND axa01 = tm.axee13   #群組                                                                                                   
#                AND axb02 = l_axb02   #上層公司
#                AND axb04 = tm.axee01   #下層公司編號                                                                                               
#         ELSE
#             SELECT axa09 INTO l_axa09 FROM axa_file                                                                                          
#              WHERE axa01 = tm.axee13   #群組                                                                                                   
#                AND axa02 = tm.axee01   #公司編號                                                                                               
#         END IF
#         
#         IF l_axa09 = 'Y' THEN  
#         #---FUN-950051 end------
#             SELECT azp03 INTO g_dbs_new FROM azp_file
#               WHERE azp01 = l_axz03
#             IF STATUS THEN LET g_dbs_new = NULL RETURN END IF
#         IF NOT cl_null(g_dbs_new) THEN 
#             LET g_dbs_new = s_dbstring(g_dbs_new CLIPPED)  #FUN-950051
#            #LET g_dbs_new=g_dbs_new CLIPPED,'.' 
#         END IF
#         #---FUN-950051 start---
#         ELSE
#             LET g_dbs_new = s_dbstring(g_dbs CLIPPED)  #FUN-950051
#             IF STATUS THEN LET g_dbs_new = NULL RETURN END IF
#         END IF
#         #--FUN-950051 end---- 
#
#        #FUN-920025---add---str---
#         LET g_sql = "SELECT aaz641 FROM ",g_dbs_new,"aaz_file",
#                     " WHERE aaz00 = '0'"
#         PREPARE i0011_pre_04 FROM g_sql
#         DECLARE i0011_cur_04 CURSOR FOR i0011_pre_04
#         OPEN i0011_cur_04
#         FETCH i0011_cur_04 INTO g_axee00_def    #合併後帳別
#         IF cl_null(g_axee00_def) THEN
#             CALL cl_err(g_dbs_new,'agl-601',1)
#         END IF
#        #FUN-920025---add---end---
#         LET g_dbs_gl = g_dbs_new 
#----------FUN-980040 mark------------------------------------
    
        #LET l_sql ="SELECT aag01,aag02 FROM ",g_dbs_gl,"aag_file ",
        #LET l_sql ="SELECT aag01,aag02,aag04 FROM ",g_dbs_gl,"aag_file ",  #FUN-950049
        #LET l_sql ="SELECT aag01,aag02,aag04 FROM ",g_dbs_axz03,"aag_file ", #FUN-980040           #FUN-A50102 
        #LET l_sql ="SELECT aag01,aag02,aag04 FROM ",cl_get_target_table(g_axz03,'aag_file'),       #FUN-A50102 #MOD-C10085 mark
         LET l_sql ="SELECT aag01,aag02,aag04 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), #MOD-C10085 add
                    " WHERE aag07 IN ('2','3') ",   #MOD-9C0161 mod
                    "  AND ",g_wc CLIPPED,
                   #"  AND aag00 = '",tm.axee00,"'",  #No.FUN-730070
                   #"  AND aag00 = '",g_axee00_def,"'",  #No.FUN-730070
                   #"  AND aag00 = '",g_aaz641,"'", #FUN-980040 mod #MOD-BB0273 mark
                    "  AND aag00 = '",g_axee00,"'", #MOD-BB0273
                    "  AND aag09 = 'Y'",            #FUN-B60082
                    " ORDER BY 1 "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add
         CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql  #FUN-A50102
         PREPARE i0011_g_pre  FROM l_sql
         DECLARE i0011_g CURSOR FOR i0011_g_pre 
         FOREACH i0011_g INTO l_aag01,l_aag02,l_aag04
            IF SQLCA.sqlcode THEN 
               CALL cl_err('i0011_g',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
    
            LET l_axee06 = NULL 
    
            IF tm.y = 'Y' THEN
               LET l_axee06 = l_aag01 
            ELSE 
               LET l_axee06 = ' '
            END IF
    
            #FUN-950049 start---
            IF l_aag04 = '1' THEN
               LET l_axee11 = '1'
               LET l_axee12 = '1'
            ELSE
               LET l_axee11 = '3'
               LET l_axee12 = '3'
            END IF
            #FUN-950049 end------

            IF NOT cl_null(l_aag01) THEN
                INSERT INTO axee_file (axee00,axee01,axee04,axee05,axee06,axee11,axee12,  #No.FUN-730070
                                      axeeacti,axeeuser,axeegrup,axeemodu,axeedate,axee13)   #FUN-910001 add axee13
                              #VALUES (g_axee00_def,tm.axee01,l_aag01,l_aag02,l_axee06,'1','1',  #No.FUN-730070  #FUN-920035
                              VALUES (g_axee00,tm.axee01,l_aag01,l_aag02,l_axee06,l_axee11,l_axee12,  #No.FUN-730070  #FUN-920035  #FUN-950049
                                      'Y',g_user,g_grup,' ',g_today,tm.axee13)   #FUN-910001 add tm.axee13
                #已存在者不作更新
                IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #FUN-770069
                   CONTINUE FOREACH
                ELSE
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","axee_file",tm.axee01,l_aag01,STATUS,"","ins axee",1)  #No.FUN-660123
                      LET g_success='N'   #TQC-590045
                      EXIT FOREACH
                   END IF
                END IF   #MOD-780106 add
            END IF       #FUN-950049
         END FOREACH
      END IF
    
      IF g_success='Y' THEN
         COMMIT WORK                             #No.TQC-740199
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK   #No.TQC-740199
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE

   CLOSE WINDOW i0011_w3

END FUNCTION

#--FUN-980040 start-----
FUNCTION i0011_getdbs(p_axee01,p_axee13)
DEFINE  p_axee01  LIKE axee_file.axee01
DEFINE  p_axee13  LIKE axee_file.axee13
DEFINE  l_cnt     LIKE type_file.num5
DEFINE  l_axa02   LIKE axa_file.axa02
DEFINE  l_axa02_cnt  LIKE type_file.num5

   SELECT axz02,axz03,axz04 INTO g_axz02,g_axz03,g_axz04 FROM axz_file 
     WHERE axz01 = p_axee01
   #使用tiptop否(axz04)=N,表示為非TIPTOP公司,
   #預設目前所在DB給他(g_dbs_axz03)
   IF g_axz04 = 'N' THEN LET g_axz03=g_plant    
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = g_axz03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET g_dbs_axz03 = s_dbstring(g_dbs_new CLIPPED) 
   ELSE
       #--判斷axa09(是否獨立合併會科)--
       #IF axa09 = 'Y' 則取p_axee01所屬DB，代表合併帳別建立於各上層公司
       #IF axa09 = 'N' 則取目前所在DB，代表合併帳別建立於最上層公司

       SELECT axa09 INTO g_axa09 FROM axa_file     
        WHERE axa01 = p_axee13  
          AND axa02 = p_axee01        #上層公司編號 
       IF g_axa09 = 'N' THEN          #合併會科不獨立
           LET g_axz03 = g_plant  #TQC-9C0099
           SELECT azp03 INTO g_dbs_new FROM azp_file
            WHERE azp01 = g_plant
           LET g_dbs_axz03 = s_dbstring(g_dbs_new CLIPPED) 
       ELSE
           SELECT azp03 INTO g_dbs_new FROM azp_file
            WHERE azp01 = g_axz03
           IF STATUS THEN
               LET g_dbs_new = NULL
           END IF
           LET g_dbs_axz03= s_dbstring(g_dbs_new CLIPPED) 
       END IF
   END IF
   #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_axz03,'aaz_file'),  #FUN-A50102
               " WHERE aaz00 = '0'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
   CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql  #FUN-A50102
   PREPARE i001_pre_11 FROM g_sql
   DECLARE i001_cur_11 CURSOR FOR i001_pre_11
   OPEN i001_cur_11
   FETCH i001_cur_11 INTO g_aaz641
   IF cl_null(g_aaz641) THEN
       CALL cl_err(g_axz03,'agl-601',1)
   ELSE
       LET g_axee00 = g_aaz641
   END IF

   #-----axa02的上層公司所屬DB及合併帳別(g_dbs_axz03_g,g_aaz641_g)
   SELECT axb02 INTO l_axa02  #上層公司
     FROM axb_file
    WHERE axb01 = p_axee13
      AND axb04 = p_axee01
   SELECT axz03,axz04               #上層公司資料庫
     INTO g_axz03_g,g_axz04_g 
     FROM axz_file 
     WHERE axz01 = l_axa02  

   #使用tiptop否(axz04)=N,表示為非TIPTOP公司,
   #預設目前所在DB給他(g_dbs_axz03)
   IF g_axz04_g = 'N' THEN LET g_axz03_g=g_plant    
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = g_axz03_g
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET g_dbs_axz03_g = s_dbstring(g_dbs_new CLIPPED) 
   ELSE
       #--判斷axa09(是否獨立合併會科)--
       #IF axa09 = 'Y' 則取p_axee01所屬DB，代表合併帳別建立於各上層公司
       #IF axa09 = 'N' 則取目前所在DB，代表合併帳別建立於最上層公司
       LET g_axa09 = ''
       SELECT axa09 INTO g_axa09 FROM axa_file     
        WHERE axa01 = p_axee13  
          AND axa02 = l_axa02         #上層公司編號 

       IF g_axa09 = 'N' THEN          #合併會科不獨立
           LET g_axz03_g = g_plant  #TQC-9C0099
           SELECT azp03 INTO g_dbs_new FROM azp_file
            WHERE azp01 = g_plant
           LET g_dbs_axz03_g = s_dbstring(g_dbs_new CLIPPED) 
       ELSE
           SELECT azp03 INTO g_dbs_new FROM azp_file
            WHERE azp01 = g_axz03_g
           IF STATUS THEN
              LET g_dbs_new = NULL
           END IF
           LET g_dbs_axz03_g = s_dbstring(g_dbs_new CLIPPED) 
       END IF
   END IF
   #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03_g,"aaz_file",  #FUN-A50102
   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_axz03_g,'aaz_file'),   #FUN-A50102
               " WHERE aaz00 = '0'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
   CALL cl_parse_qry_sql(g_sql,g_axz03_g) RETURNING g_sql  #FUN-A50102
   PREPARE i001_pre_13 FROM g_sql
   DECLARE i001_cur_13 CURSOR FOR i001_pre_13
   OPEN i001_cur_13
   FETCH i001_cur_13 INTO g_aaz641_g

END FUNCTION
#FUN-B90061--begin--
FUNCTION i0011_dataload()    #資料匯入
   OPEN WINDOW i0011_l_w AT p_row,p_col
     WITH FORM "agl/42f/agli0011_l" ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli0011_l")

   CLEAR FORM
   ERROR ''
   LET g_disk = "Y" 
   LET g_choice = '1'
    
   INPUT g_file WITHOUT DEFAULTS FROM FORMONLY.file
        
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         EXIT INPUT
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i0011_l_w
      RETURN
   END IF
  
   WHILE TRUE
   IF cl_sure(0,0) THEN
      LET g_success='Y'
      BEGIN WORK 
    
      CALL i0011_excel_bring(g_file)      

      DROP TABLE i0011_tmp
      CALL s_showmsg() 
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF

      CLOSE WINDOW i0011_l_w
   END IF
   EXIT WHILE  
   END WHILE  
   CLOSE WINDOW i0011_l_w    
END FUNCTION

FUNCTION i0011_ins_axee()
   SELECT * FROM axee_file
    WHERE axee00=g_axeel.axee00 AND axee01=g_axeel.axee01 AND axee04=g_axeel.axee04
      AND axee05=g_axeel.axee05 AND axee06=g_axeel.axee06 AND axee11=g_axeel.axee11
      AND axee12=g_axeel.axee12 AND axee13=g_axeel.axee13
   IF STATUS THEN
      LET g_axeel.axeeacti='Y'
      LET g_axeel.axeeuser=g_user
      LET g_axeel.axeegrup=g_grup
      LET g_axeel.axeedate=g_today

      INSERT INTO axee_file VALUES (g_axeel.*)
      IF STATUS THEN
         LET g_showmsg=g_axeel.axee00,"/",g_axeel.axee01,"/",g_axeel.axee04,"/",g_axeel.axee05,"/",
                       g_axeel.axee06,"/",g_axeel.axee11,"/",g_axeel.axee12,"/",g_axeel.axee13
         CALL s_errmsg('axee00,axee01,axee04,axee05,axee06,axee11,axee12,axee13'
                       ,g_showmsg,'ins axee_file',STATUS,1)
      END IF
   END IF
END FUNCTION

FUNCTION i0011_excel_bring(p_fname)
   DEFINE p_fname     STRING  
   DEFINE channel_r   base.Channel
   DEFINE l_string    LIKE type_file.chr1000
   DEFINE unix_path   LIKE type_file.chr1000
   DEFINE window_path LIKE type_file.chr1000
   DEFINE l_cmd       LIKE type_file.chr1000 
   DEFINE li_result   LIKE type_file.chr1 
   DEFINE l_column    DYNAMIC ARRAY of RECORD 
            col1      LIKE gaq_file.gaq01,
            col2      LIKE gaq_file.gaq03
                      END RECORD
   DEFINE l_cnt3      LIKE type_file.num5
   DEFINE li_i        LIKE type_file.num5
   DEFINE li_n        LIKE type_file.num5
   DEFINE ls_cell     STRING
   DEFINE ls_cell_r   STRING
   DEFINE li_i_r      LIKE type_file.num5
   DEFINE ls_cell_c   STRING
   DEFINE ls_value    STRING
   DEFINE ls_value_o  STRING
   DEFINE li_flag     LIKE type_file.chr1 
   DEFINE lr_data_tmp   DYNAMIC ARRAY OF RECORD
             data01     STRING
                    END RECORD
   DEFINE l_fname     STRING   
   DEFINE l_column_name LIKE zta_file.zta01
   DEFINE l_data_type LIKE ztb_file.ztb04
   DEFINE l_nullable  LIKE ztb_file.ztb05
   DEFINE l_flag_1    LIKE type_file.chr1  
   DEFINE l_date      LIKE type_file.dat
   DEFINE li_k        LIKE type_file.num5
   DEFINE l_err_cnt   LIKE type_file.num5
   DEFINE l_no_b      LIKE pmw_file.pmw01   
   DEFINE l_no_e      LIKE pmw_file.pmw01
   DEFINE l_old_no    LIKE type_file.chr50  
   DEFINE l_old_no_b  LIKE type_file.chr50  
   DEFINE l_old_no_e  LIKE type_file.chr50
   DEFINE lr_err      DYNAMIC ARRAY OF RECORD
          line        STRING,
          key1        STRING,
          err         STRING
                      END RECORD
   DEFINE m_tempdir   LIKE type_file.chr1000,    
          ss1         LIKE type_file.chr1000,
          m_sf        LIKE type_file.chr1000,
          m_file      LIKE type_file.chr1000,
          l_j         LIKE type_file.num5,
          l_n         LIKE type_file.num5
   DEFINE g_target    LIKE type_file.chr1000
   DEFINE tok         base.StringTokenizer
   DEFINE ss          STRING 
   DEFINE l_str       DYNAMIC ARRAY OF STRING  
   DEFINE ms_codeset  String  
   DEFINE l_txt1      LIKE type_file.chr1000
   DEFINE l_axz04     LIKE axz_file.axz04
   DEFINE l_sql       LIKE type_file.chr1000
   DEFINE
          l_cnt       LIKE type_file.num5,
          l_aag02     LIKE aag_file.aag02,
          l_aag03     LIKE aag_file.aag03,
          l_aag07     LIKE aag_file.aag07,
          l_aag09     LIKE aag_file.aag09,
          l_aagacti   LIKE aag_file.aagacti,
          l_axa02     LIKE axa_file.axa02
   DEFINE l_plant     LIKE azp_file.azp01

   LET m_tempdir = FGL_GETENV("TEMPDIR")
   LET l_n = LENGTH(m_tempdir)
   
   LET ms_codeset = cl_get_codeset()
   
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF

   IF m_tempdir is null THEN
      LET m_file=p_fname
   ELSE
      LET m_file=m_tempdir CLIPPED,'/',p_fname,".txt"
   END IF

   IF g_disk= "Y" THEN
      LET m_sf = "c:/tiptop/"
      LET m_sf = m_sf CLIPPED,p_fname CLIPPED,".txt"
      IF NOT cl_upload_file(m_sf, m_file) THEN
         CALL cl_err(NULL, "lib-212", 1)
      END IF
   END IF

   LET ss1="test -s ",m_file CLIPPED
   RUN ss RETURNING l_n

   IF l_n THEN
      IF m_tempdir IS NULL THEN
         LET m_tempdir='.'
      END IF

      DISPLAY "* NOTICE * No such excel file '",m_file CLIPPED,"'"
      DISPLAY "PLEASE make sure that the excel file download from LEADER"
      DISPLAY "has been put in the directory:"
      DISPLAY '--> ',m_tempdir
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
    
   LET channel_r = base.Channel.create()                                                                                         
   LET g_target  = FGL_GETENV("TEMPDIR"),"\/", p_fname,"_",g_dbs CLIPPED,".TXT"  
   
         
   IF m_sf IS NOT NULL THEN 
      IF NOT cl_upload_file(m_sf,g_target) THEN
         CALL cl_err("Can't upload file: ", m_sf, 0)
         RETURN 
      END IF
   END IF  
   
   LET l_txt1 = FGL_GETENV("TEMPDIR"),"\/",p_fname,"_",g_dbs CLIPPED,".txt"
   
   CASE ms_codeset
      WHEN "UTF-8"
         LET l_cmd = "cp ",g_target," ",l_txt1
         RUN l_cmd
         LET l_cmd = "ule2utf8 ",l_txt1
         RUN l_cmd
         #CHI-B50010 -- end --
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd   
      WHEN "BIG5"
         LET l_cmd = "iconv -f UNICODE -t BIG-5 " || g_target CLIPPED || " > " || l_txt1 CLIPPED  #MOD-AB0097
         RUN l_cmd
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd   
      WHEN "GB2312"
         LET l_cmd = "iconv -f UNICODE -t GB2312 " || g_target CLIPPED || " > " || l_txt1 CLIPPED  #MOD-AB0097
         RUN l_cmd
         LET l_cmd = "cp -f " || l_txt1 CLIPPED || " " || g_target CLIPPED  
         RUN l_cmd 
         LET l_cmd = " killcr " ||g_target CLIPPED     
         RUN l_cmd 
   END CASE
     
   LET g_success='Y' 
   CALL channel_r.openFile(g_target,  "r") 
   IF STATUS THEN
      CALL cl_err("Can't open file: ", STATUS, 0)
      RETURN
   END IF
   CALL channel_r.setDelimiter("")
   CALL s_showmsg_init()
   WHILE channel_r.read(ss)
      LET tok = base.StringTokenizer.create(ss,ASCII 9)
      LET l_j=0
      CALL l_str.clear()
      WHILE tok.hasMoreTokens()
         LET l_j=l_j+1
         LET l_str[l_j]=tok.nextToken()
      END WHILE
      LET g_axeel.axee01  = null
      LET g_axeel.axee04  = null
      LET g_axeel.axee06  = null
      LET g_axeel.axee11  = null
      LET g_axeel.axee12  = null
      LET g_axeel.axee13  = null
      LET g_axeel.axee01  = l_str[1] CLIPPED
      LET g_axeel.axee04  = l_str[2] CLIPPED
      LET g_axeel.axee06  = l_str[3] CLIPPED
      LET g_axeel.axee11  = l_str[4] CLIPPED
      LET g_axeel.axee12  = l_str[5] CLIPPED
      LET g_axeel.axee13  = l_str[6] CLIPPED
      IF cl_null(g_axeel.axee01) OR
         cl_null(g_axeel.axee04) OR cl_null(g_axeel.axee13) THEN
         CONTINUE WHILE
      END IF
      CALL s_aaz641_dbs(g_axee13,g_axee01) RETURNING g_plant_axz03
      CALL s_get_aaz641(g_plant_axz03) RETURNING g_axeel.axee00
      SELECT axb02 INTO l_axa02
        FROM axb_file
       WHERE axb01 = g_axeel.axee13
         AND axb04 = g_axeel.axee01
      CALL s_aaz641_dbs(g_axeel.axee13,l_axa02) RETURNING g_plant_axz03_g
     #CALL s_get_aaz641(g_plant_axz03_g) RETURNING g_aaw01_g      #FUN-BA0012
      CALL s_get_aaz641(g_plant_axz03_g) RETURNING g_aaz641_g     #FUN-BA0012
      IF cl_null(g_axeel.axee00) THEN
         CALL s_errmsg('axee00',g_showmsg,'','agl-095',1)
         CONTINUE WHILE
      END IF
      IF NOT cl_null(g_axeel.axee04) THEN
         LET l_axz04 = null
         SELECT axz04 INTO l_axz04 FROM axz_file
          WHERE axz01 = g_axee01
         LET g_errno = null
         LET l_aag02 = null
         LET l_aag03 = null
         LET l_aag07 = null
         LET l_aagacti = null
         IF l_axz04 = 'N' THEN
            LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                        "  FROM ",cl_get_target_table(l_plant,'aag_file'), 
                        " WHERE aag01 = '",g_axeel.axee04,"'",
                        "   AND aag00 = '",g_axeel.axee00,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
            PREPARE axee04_sel2 FROM g_sql
            DECLARE axee04_cur2 CURSOR FOR axee04_sel2
            OPEN axee04_cur2
            FETCH axee04_cur2 INTO l_aag02,l_aag03,l_aag07,l_aagacti
            LET g_axeel.axee05 = l_aag02
            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE
            CLOSE axee04_cur2
            IF NOT cl_null(g_errno) THEN
               LET g_showmsg = g_axeel.axee00,'/',g_axeel.axee04
               CALL s_errmsg('axee00,axee04',g_showmsg,'',g_errno,1)
               CONTINUE WHILE
            END IF
   
            IF SQLCA.sqlcode = 0 THEN
               LET g_errno = null 
               LET l_aag02 = null
               LET l_aag03 = null
               LET l_aag07 = null
               LET l_aagacti = null
               LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                           "  FROM ",cl_get_target_table(l_plant,'aag_file'), 
                           " WHERE aag01 = '",g_axeel.axee04,"'",
                           "   AND aag00 = '",g_axeel.axee00,"'",
                           "   AND aag09 = 'Y'" 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
               PREPARE axee04_sel3 FROM g_sql
               DECLARE axee04_cur3 CURSOR FOR axee04_sel3
               OPEN axee04_cur3
               FETCH axee04_cur3 INTO l_aag02,l_aag03,l_aag07,l_aagacti
               LET g_axeel.axee05 = l_aag02
               CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
                    WHEN l_aagacti = 'N'     LET g_errno = '9028'
                    WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                    OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
               END CASE
               CLOSE axee04_cur3
               IF NOT cl_null(g_errno) THEN
                  LET g_showmsg = g_axeel.axee00,'/',g_axeel.axee04
                  CALL s_errmsg('axee00,axee04',g_showmsg,'',g_errno,1)
                  CONTINUE WHILE
               END IF
            END IF
         ELSE
            LET g_errno = ' '
            LET l_aag02 = ' '
            LET l_aag03 = ' '
            LET l_aag07 = ' '
            LET l_aagacti = ' '
            LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                        "  FROM ",cl_get_target_table(g_axz03,'aag_file'),
                        " WHERE aag01 = '",g_axeel.axee04,"'",
                        "   AND aag00 = '",g_axeel.axee00,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
            PREPARE axee04_sel1 FROM g_sql
            DECLARE axee04_cur1 CURSOR FOR axee04_sel1
            OPEN axee04_cur1
            FETCH axee04_cur1 INTO l_aag02,l_aag03,l_aag07,l_aagacti
            LET g_axeel.axee05 = l_aag02
            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE
            CLOSE axee04_cur1
            IF NOT cl_null(g_errno) THEN
               LET g_showmsg = g_axeel.axee00,'/',g_axeel.axee04
               CALL s_errmsg('axee00,axee04',g_showmsg,'',g_errno,1)
               CONTINUE WHILE
            END IF

            IF SQLCA.sqlcode = 0 THEN
               LET g_errno = null 
               LET l_aag02 = null
               LET l_aag03 = null
               LET l_aag07 = null
               LET l_aagacti = null
               LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                           "  FROM ",cl_get_target_table(g_axz03,'aag_file'),
                           " WHERE aag01 = '",g_axeel.axee04,"'",
                           "   AND aag00 = '",g_axeel.axee00,"'",
                           "   AND aag09 = 'Y'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
               PREPARE axee04_sel4 FROM g_sql
               DECLARE axee04_cur4 CURSOR FOR axee04_sel4
               OPEN axee04_cur4
               FETCH axee04_cur4 INTO l_aag02,l_aag03,l_aag07,l_aagacti
               LET g_axeel.axee05 = l_aag02
               CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
                    WHEN l_aagacti = 'N'     LET g_errno = '9028'
                    WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                    OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
               END CASE
               CLOSE axee04_cur4
               IF NOT cl_null(g_errno) THEN
                  LET g_showmsg = g_axeel.axee00,'/',g_axeel.axee04
                  CALL s_errmsg('axee00,axee04',g_showmsg,'',g_errno,1)
                  CONTINUE WHILE
               END IF
            END IF
         END IF
      END IF
      IF NOT cl_null(g_axeel.axee06) THEN
         LET g_errno = ' '
         LET l_aag02 = ' '
         LET l_aag03 = ' '
         LET l_aag07 = ' '
         LET l_aagacti = ' '
         LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",
                     "  FROM ",cl_get_target_table(l_plant,'aag_file'), 
                     " WHERE aag01 = '",g_axeel.axee06,"'",                                                                           
                    #"  AND aag00 = '",g_aaw01_g,"'"       #FUN-BA0012
                     "  AND aag00 = '",g_aaz641_g,"'"      #FUN-BA0012
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql                                                 
         PREPARE axee06_sel2 FROM g_sql 
         DECLARE axee06_cur2 CURSOR FOR axee06_sel2                                                                                       
         OPEN axee06_cur2                                                                                                                 
         FETCH axee06_cur2 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         
         CLOSE axee06_cur2
         CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001' 
              WHEN l_aagacti = 'N'     LET g_errno = '9028' 
              WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
              OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
         END CASE 
         IF NOT cl_null(g_errno) THEN
            LET g_showmsg = g_axeel.axee00,'/',g_axeel.axee06
            CALL s_errmsg('axee00,axee06',g_showmsg,'',g_errno,1)
            CONTINUE WHILE
         END IF

         IF SQLCA.sqlcode = 0 THEN
            LET g_errno = ' '
            LET l_aag02 = ' '
            LET l_aag03 = ' '
            LET l_aag07 = ' '
            LET l_aagacti = ' '
            LET g_sql = "SELECT aag02,aag03,aag07,aagacti ",                                                                                 
                        "  FROM ",cl_get_target_table(l_plant,'aag_file'), 
                        " WHERE aag01 = '",g_axeel.axee06,"'",                                                                           
                       #"  AND aag00 = '",g_aaw01_g,"'",        #FUN-BA0012
                        "  AND aag00 = '",g_aaz641_g,"'",       #FUN-BA0012
                        "  AND aag09 = 'Y'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql               
            PREPARE axee06_sel3 FROM g_sql                                                                                                   
            DECLARE axee06_cur3 CURSOR FOR axee06_sel3
            OPEN axee06_cur3
            FETCH axee06_cur3 INTO l_aag02,l_aag03,l_aag07,l_aagacti                                                                         
            CLOSE axee06_cur3
            CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-214'
                 WHEN l_aagacti = 'N'     LET g_errno = '9028'
                 WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
                 OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
            END CASE 
         END IF
         IF NOT cl_null(g_errno) THEN
            LET g_showmsg = g_axeel.axee00,'/',g_axeel.axee06
            CALL s_errmsg('axee00,axee06',g_showmsg,'',g_errno,1)
            CONTINUE WHILE
         END IF
      END IF

      CALL i0011_ins_axee()
   END WHILE
   CALL channel_r.close()
   
   IF g_totsuccess="N" THEN 
     LET g_success="N" 
  END IF  

END FUNCTION
#FUN-B90061---end---

#FUN-D20044--
FUNCTION i0011_exceldata()  

DEFINE l_gaq03   LIKE gaq_file.gaq03
DEFINE l_str     STRING
DEFINE l_str1    STRING
DEFINE ls_cell   STRING
DEFINE l_gaq03_s STRING 
DEFINE i         LIKE type_file.num5

DEFINE l_gaq_feld   DYNAMIC ARRAY OF RECORD
        gaq01       LIKE gaq_file.gaq01,
        locate      LIKE gaq_file.gaq01
        END RECORD

   CALL l_gaq_feld.clear()

  #營運中心編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axee01'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C1'

  #來源營運中心會計科目編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axee04'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C2'

  #合併後財報會計科目編號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axee06'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C3'

  #再衡量匯率類別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axee11'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C4'

  #換算匯率類別
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axee12'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C5'

  #集團代號
   CALL l_gaq_feld.appendElement()
   LET l_gaq_feld[l_gaq_feld.getLength()].gaq01= 'axee13'
   LET l_gaq_feld[l_gaq_feld.getLength()].locate= 'R1C6'

   FOR i = 1 TO l_gaq_feld.getLength()
      SELECT gaq03 INTO l_gaq03 
        FROM gaq_file 
       WHERE gaq01 = l_gaq_feld[i].gaq01
         AND gaq02 = g_lang
      LET l_gaq03_s = l_gaq03       
      LET l_str = l_gaq03_s.trim() 
      LET ls_cell = l_gaq_feld[i].locate
      LET l_str1 = "DDEPoke Sheet1 "CLIPPED,l_gaq_feld[i].locate
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],li_result)
   END FOR

END FUNCTION
#FUN-D20044--
