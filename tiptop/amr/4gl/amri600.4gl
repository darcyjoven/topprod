# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amri600.4gl
# Descriptions...: 料件基本資料檢示/調整
# Date & Author..: 97/07/21 By Melody
# Modify.........: No.FUN-4C0042 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510046 05/03/01 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-650069 06/05/24 By Sarah 增加顯示ima133(產品測試料號)
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0066 06/10/20 By atsea 將g_no_ask修改為mi_no_ask
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0041 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6A0080 06/11/22 By xumin報表寬度不符問題修改
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah 沒有列印(接下頁)
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740341 07/05/08 By johnray 5.0版更，修改資料時料件編號欄位應不可輸入
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760042 07/06/05 By Judy 報表中，"FROM"在報表名之上
# Modify.........: No.TQC-770009 07/07/09 By wujie page頁簽不可以查詢 
# Modify.........: No.FUN-710073 07/11/30 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/16 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-850048 08/05/09 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-970029 09/07/09 By mike 7/9:將ima601放在ima60與ima61中間.         
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0005 10/11/01 By zhangll ima601增加控管，若为0则作为除数时将有异常情况发生
# Modify.........: No.FUN-BB0085 11/11/30 By xianghui 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ima   RECORD LIKE ima_file.*,
    g_ima_t RECORD LIKE ima_file.*,
    g_ima01_t      LIKE ima_file.ima01,
    g_wc           STRING,                 #No.FUN-580092 HCN   
    g_sql          STRING,                 #No.FUN-580092 HCN   
  # g_sta          VARCHAR(10)
    g_sta          LIKE type_file.chr20    #No.FUN-680082 VARCHAR(10)
 
DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   STRING
DEFINE g_chr                 LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10    #No.FUN-680082 INTEGER 
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose #No.FUN-680082 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_curs_index          LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_jump                LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5     #No.FUN-680082 SMALLINT   #No.FUN-6A0066
#No.FUN-850048--begin--
DEFINE l_sql            STRING                                                                                                      
DEFINE g_str            STRING                                                                                                      
DEFINE l_table          STRING 
#No.FUN-850048--end--
MAIN
#     DEFINE    l_time LIKE type_file.chr8                #No.FUN-6A0076
    DEFINE p_row,p_col       LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AMR")) THEN
       EXIT PROGRAM
    END IF
#No.FUN-850048--begin--
    LET g_sql="ima01.ima_file.ima01,",
              "ima05.ima_file.ima05,",
              "ima08.ima_file.ima08,",
              "ima25.ima_file.ima25,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ima03.ima_file.ima03,",
              "ima27.ima_file.ima27,", 
              "ima28.ima_file.ima28,",
              "ima37.ima_file.ima37,",
              "g_str.type_file.chr20,",
              "ima56.ima_file.ima56,",
              "ima45.ima_file.ima45,",
              "ima561.ima_file.ima561,",
              "ima46.ima_file.ima46,",
              "ima562.ima_file.ima562,",
              "ima47.ima_file.ima47,",
              "ima59.ima_file.ima59,",
              "ima48.ima_file.ima48,",
              "ima60.ima_file.ima60,",
              "ima49.ima_file.ima49,",
              "ima61.ima_file.ima61,",
              "ima491.ima_file.ima491,",
              "ima64.ima_file.ima64,",
              "ima50.ima_file.ima50,",
              "ima641.ima_file.ima641"         
    LET l_table = cl_prt_temptable('amri600',g_sql) CLIPPED                                                                         
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                                                                            
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF  
#No.FUN-850048--end--
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    INITIALIZE g_ima.* TO NULL
    INITIALIZE g_ima_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i600_w AT p_row,p_col
         WITH FORM "amr/42f/amri600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    LET g_chkey = 'N'             #No.TQC-740341
    CALL i600_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i600_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i600_cs()
    CLEAR FORM
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       ima01,ima37,ima139,ima45,ima46,ima47,ima48,
       ima49,ima491,ima50,ima27,ima28,ima64,ima641,ima56,ima561,ima562,ima59,
       ima60,ima601,ima61,imauser,imagrup,imamodu,imadate,imaacti    #No.TQC-770009  #FUN-970029 add ima601 
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
    LET g_sql="SELECT ima01 FROM ima_file WHERE ",g_wc CLIPPED
    PREPARE i600_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i600_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i600_prepare
 
    LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
    PREPARE i600_precount FROM g_sql
    DECLARE i600_count CURSOR FOR i600_precount
END FUNCTION
 
FUNCTION i600_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i600_q()
            END IF
        ON ACTION next
            CALL i600_fetch('N')
        ON ACTION previous
            CALL i600_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i600_u()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                 CALL i600_o()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i600_fetch('/')
        ON ACTION first
            CALL i600_fetch('F')
        ON ACTION last
            CALL i600_fetch('L')
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6B0041-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ima.ima01 IS NOT NULL THEN
                  LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6B0041-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i600_cs
END FUNCTION
 
FUNCTION i600_i(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
           l_flag          LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
           l_n             LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
    INPUT BY NAME
#No.FUN-570110 --start-
#          g_ima.ima27,g_ima.ima28,g_ima.ima37,g_ima.ima139,g_ima.ima45,
          g_ima.ima01,g_ima.ima27,g_ima.ima28,g_ima.ima37,g_ima.ima139,g_ima.ima45,
#No.FUN-570110 --end--
          g_ima.ima46,g_ima.ima47,g_ima.ima48,g_ima.ima49,g_ima.ima491,
          g_ima.ima50,g_ima.ima64,g_ima.ima641,g_ima.ima56,g_ima.ima561,
          g_ima.ima562,g_ima.ima59,g_ima.ima60,g_ima.ima601,g_ima.ima61 #FUN-970029 add ima601 
          WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i600_set_entry(p_cmd)
           CALL i600_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ima27
            IF g_ima.ima27 IS NULL THEN LET g_ima.ima27=0 END IF
            IF g_ima.ima27<0 THEN
               CALL cl_err(g_ima.ima27,'aim-391',0)
               NEXT FIELD ima27
            END IF
            LET g_ima.ima27 = s_digqty(g_ima.ima27,g_ima.ima25)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima27                            #FUN-BB0085
 
        AFTER FIELD ima28
            IF g_ima.ima28 IS NULL THEN LET g_ima.ima28=0 END IF
            IF g_ima.ima28<0 THEN
               CALL cl_err(g_ima.ima28,'aim-391',0)
               NEXT FIELD ima28
            END IF
            LET g_ima.ima28 = s_digqty(g_ima.ima28,g_ima.ima25)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima28                            #FUN-BB0085
 
        AFTER FIELD ima37
          IF g_ima.ima37 IS NOT NULL THEN
            IF g_ima.ima37 NOT MATCHES "[012345]"  THEN
               CALL cl_err(g_ima.ima37,'mfg1003',0)
               NEXT FIELD ima37
            END IF
            #CALL s_opc(g_ima.ima37) RETURNING g_sta
            #DISPLAY g_sta TO FORMONLY.ima37_d
            IF g_ima.ima37='0' AND g_ima.ima08 NOT MATCHES '[MPVZ]' THEN
               CALL cl_err(g_ima.ima37,'mfg3201',0)
               NEXT FIELD ima37
            END IF
          END IF
 
        AFTER FIELD ima45
            IF g_ima.ima45 IS NULL THEN LET g_ima.ima45=0 END IF
            IF g_ima.ima45 < 0 THEN
               CALL cl_err(g_ima.ima45,'mfg0013',0)
               NEXT FIELD ima45
            END IF
            LET g_ima.ima45 = s_digqty(g_ima.ima45,g_ima.ima44)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima45                            #FUN-BB0085
 
        AFTER FIELD ima46
            IF g_ima.ima46 < 0 THEN
               CALL cl_err(g_ima.ima46,'mfg0013',0)
               NEXT FIELD ima46
            END IF
            IF g_ima.ima45 != 0 THEN  #採購批量=0時,不控制
               IF g_ima.ima45>1 THEN
                  CALL amri600_size()
               END IF
            END IF
            LET g_ima.ima46 = s_digqty(g_ima.ima46,g_ima.ima44)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima46                            #FUN-BB0085
 
        AFTER FIELD ima47
            IF g_ima.ima47 < 0  OR g_ima.ima47 > 100 THEN
               CALL cl_err(g_ima.ima47,'mfg1332',0)
               NEXT FIELD ima47
            END IF
 
        AFTER FIELD ima48
            IF g_ima.ima48 < 0 THEN
               CALL cl_err(g_ima.ima48,'mfg0013',0)
               NEXT FIELD ima48
            END IF
 
        AFTER FIELD ima49
            IF g_ima.ima49 < 0 THEN
               CALL cl_err(g_ima.ima49,'mfg0013',0)
               NEXT FIELD ima49
            END IF
 
        AFTER FIELD ima491
            IF g_ima.ima491<0 THEN
               CALL cl_err(g_ima.ima491,'mfg0013',0)
               NEXT FIELD ima491
            END IF
 
        AFTER FIELD ima50
            IF g_ima.ima50 < 0 THEN
               CALL cl_err(g_ima.ima50,'mfg0013',0)
               NEXT FIELD ima50
            END IF
 
        AFTER FIELD ima56
            IF g_ima.ima56 < 0 THEN
               CALL cl_err(g_ima.ima56,'mfg0013',0)
               NEXT FIELD ima56
            END IF
            LET g_ima.ima56 = s_digqty(g_ima.ima56,g_ima.ima55)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima56                            #FUN-BB0085
 
        AFTER FIELD ima561
            IF g_ima.ima561< 0 THEN
               CALL cl_err(g_ima.ima561,'mfg0013',0)
               NEXT FIELD ima561
            END IF
            LET g_ima.ima561 = s_digqty(g_ima.ima561,g_ima.ima55)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima561                             #FUN-BB0085
 
        AFTER FIELD ima562
            IF g_ima.ima562< 0 THEN
               CALL cl_err(g_ima.ima562,'mfg0013',0)
               NEXT FIELD ima562
            END IF
 
        AFTER FIELD ima59
            IF g_ima.ima59 < 0 THEN
               CALL cl_err(g_ima.ima59,'mfg0013',0)
               NEXT FIELD ima59
            END IF
 
        AFTER FIELD ima60
            IF g_ima.ima60 < 0 THEN
               CALL cl_err(g_ima.ima60,'mfg0013',0)
               NEXT FIELD ima60
            END IF
 
       #FUN-970029   ---start
        AFTER FIELD ima601
           #Mod No.TQC-AB0005
           #IF g_ima.ima601 < 0 THEN
           #   CALL cl_err(g_ima.ima601,'mfg0013',0)
           #   NEXT FIELD ima601 
           #END IF
            IF cl_null(g_ima.ima601) OR g_ima.ima601 <= 0 THEN
               CALL cl_err(g_ima.ima601,'mfg9243',0)
               NEXT FIELD ima601
            END IF
           #End Mod No.TQC-AB0005

       #FUN-970029   ---end  
 
        AFTER FIELD ima61
            IF g_ima.ima61 < 0 THEN
               CALL cl_err(g_ima.ima61,'mfg0013',0)
               NEXT FIELD ima61
            END IF
 
        AFTER FIELD ima64
            IF g_ima.ima64 < 0 THEN
               CALL cl_err(g_ima.ima64,'mfg0013',0)
               NEXT FIELD ima64
            END IF
            LET g_ima.ima64 = s_digqty(g_ima.ima64,g_ima.ima63)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima64                            #FUN-BB0085
 
        AFTER FIELD ima641
            IF g_ima.ima641 < 0 THEN
               CALL cl_err(g_ima.ima641,'mfg0013',0)
               NEXT FIELD ima641
            END IF
            LET g_ima.ima641= s_digqty(g_ima.ima641,g_ima.ima63)    #FUN-BB0085
            DISPLAY BY NAME g_ima.ima641                            #FUN-BB0085
 
        AFTER INPUT
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD ima27
            END IF
 
	ON KEY(F1) NEXT FIELD ima37
 
        ON KEY(F2) NEXT FIELD ima56
 
         #MOD-480084
{
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(ima01) THEN
               LET g_ima.* = g_ima_t.*
               CALL i600_show()
            END IF
}
        #--
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
FUNCTION i600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ima.* TO NULL                          #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i600_cs()                                      #宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i600_count
    FETCH i600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i600_cs                                        #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('open i600_cs:',SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
    ELSE
       CALL i600_fetch('F')                              #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i600_fetch(p_flima)
    DEFINE #p_flima          VARCHAR(1),
            p_flima          LIKE type_file.chr1,   #No.FUN-680082 VARCHAR(1)
            l_abso           LIKE type_file.num10   #No.FUN-680082 INTEGER
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     i600_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS i600_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    i600_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     i600_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN       #No.FUN-6A0066
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
            FETCH ABSOLUTE g_jump i600_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flima
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660107
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE
       LET g_data_owner=g_ima.imauser           #FUN-4C0042權限控管
       LET g_data_group=g_ima.imagrup
       CALL i600_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i600_show()
    LET g_ima_t.* = g_ima.*
    DISPLAY BY NAME
        g_ima.ima01,g_ima.ima05,g_ima.ima08,g_ima.ima25,g_ima.ima02,
        g_ima.ima021, g_ima.ima03,
        g_ima.ima27,g_ima.ima28,g_ima.ima37,g_ima.ima139,g_ima.ima133,g_ima.ima45,   #FUN-650069 add g_ima.ima133
        g_ima.ima46,g_ima.ima47,g_ima.ima48,g_ima.ima49,g_ima.ima491,
        g_ima.ima50,g_ima.ima56,g_ima.ima561,g_ima.ima562,g_ima.ima59,
        g_ima.ima60,g_ima.ima601,g_ima.ima61,g_ima.ima64,g_ima.ima641, #FUN-970029 add ima601   
        g_ima.imauser,g_ima.imagrup,g_ima.imamodu,g_ima.imadate,g_ima.imaacti
    #CALL s_opc(g_ima.ima37) RETURNING g_sta
    #DISPLAY g_sta TO FORMONLY.ima37_d
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i600_u()
    IF g_ima.ima01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    BEGIN WORK
 
    OPEN i600_cl USING g_ima.ima01
    IF STATUS THEN
       CALL cl_err("OPEN i600_cl:", STATUS, 1)
       CLOSE i600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i600_cl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i600_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima.*=g_ima_t.*
            CALL i600_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_ima.imamodu = g_user
        LET g_ima.imadate = g_today
        UPDATE ima_file SET ima_file.* = g_ima.*  # 更新DB
            WHERE ima01 = g_ima.ima01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","ima_file",g_ima01_t,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        ELSE
            CALL i600_show()
            MESSAGE 'UPDATE OK!'
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION amri600_size()
DEFINE # l_count         SMALLINT,
         l_count         LIKE type_file.num5,    #No.FUN-680082 SMALLINT
         l_ima46         LIKE ima_file.ima46
 
   LET l_count = g_ima.ima46 MOD g_ima.ima45
   IF l_count != 0 THEN
      LET l_count = g_ima.ima46/ g_ima.ima45
      LET l_ima46 = ( l_count + 1 ) * g_ima.ima45
      CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
      WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,'(',l_ima46,')',':' FOR g_chr
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#                CONTINUE PROMPT
 
             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121
        
             ON ACTION help          #MOD-4C0121
                CALL cl_show_help()  #MOD-4C0121
        
             ON ACTION controlg      #MOD-4C0121
                CALL cl_cmdask()     #MOD-4C0121
 
          END PROMPT
          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      END WHILE
      IF g_chr ='Y' OR g_chr = 'y'  THEN
         LET g_ima.ima46 = l_ima46
         LET g_ima.ima46 = s_digqty(g_ima.ima46,g_ima.ima44)   #FUN-BB0085
      END IF
      DISPLAY BY NAME g_ima.ima46
   END IF
   LET g_chr = NULL
END FUNCTION
 
FUNCTION i600_o()
    DEFINE sr              RECORD LIKE ima_file.*,
         # l_name          VARCHAR(20),                # External(Disk) file name
           l_name          LIKE type_file.chr20,    #No.FUN-680082 VARCHAR(20)
         # l_za05          VARCHAR(40)                 #
           l_za05          LIKE type_file.chr1000   #No.FUN-680082 VARCHAR(40)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                             #No.FUN-850011                              
    CALL cl_del_data(l_table)                                                            #No.FUN-850011  
    IF cl_null(g_wc) THEN
#      CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('amri600') RETURNING l_name                                           #No.FUN-850011 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amri600'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF                             #No.FUN-850011   
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR                               #No.FUN-850011  
    LET g_sql="SELECT * FROM ima_file WHERE ",g_wc CLIPPED
    PREPARE amri600_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE amri600_curo                         # SCROLL CURSOR
        CURSOR FOR amri600_p1
#No.FUN-850048--begin--
#   START REPORT amri600_rep TO l_name
 
    FOREACH amri600_curo INTO sr.*
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       CALL s_opc(sr.ima37) RETURNING g_sta
#      OUTPUT TO REPORT amri600_rep(sr.*)
       EXECUTE insert_prep USING sr.ima01,sr.ima05,sr.ima08,sr.ima25,sr.ima02,sr.ima021,sr.ima03,sr.ima27,
                                 sr.ima28,sr.ima37,g_sta,sr.ima56,sr.ima45,sr.ima561,sr.ima46,sr.ima562,
                                 sr.ima47,sr.ima59,sr.ima48,sr.ima60,sr.ima49,sr.ima61,sr.ima491,sr.ima64,
                                 sr.ima50,sr.ima641
    END FOREACH
 
#    FINISH REPORT amri600_rep
 
    CLOSE amri600_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                                                                             
       CALL cl_wcchp(g_wc,'ima01,ima37,ima139,ima45,ima46,ima47,ima48,ima49,ima491,ima50,
                            ima27,ima28,ima64,ima641,ima56,ima561,ima562,ima59,ima60,ima601,ima61, #FUN-970029 add ima601   
                            imauser,imagrup,imamodu,imadate,imaacti')                                                                                                  
       RETURNING g_wc                                                                                                               
       LET g_str = g_wc                                                                                                             
    END IF                                                                                                                           
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                   
    LET g_str=g_str                                                                                                 
    CALL cl_prt_cs3('amri600','amri600',l_sql,g_str)
END FUNCTION
#No.FUN-850048--begin--
#REPORT amri600_rep(sr)
#   DEFINE  #l_last_sw       VARCHAR(1),
#            l_last_sw       LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
#            sr              RECORD LIKE ima_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ima01
 
#   FORMAT
#       PAGE HEADER
#          PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED   #No.TQC-6A0080
#          PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED  #TQC-760042 mark
#          PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED  #No.TQC-6A0080
#          PRINT ' '
#          PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN (g_len-FGL_WIDTH(g_user)-20),'FROM:',g_user CLIPPED, #TQC-760042
#                COLUMN g_len-11,g_x[3] CLIPPED,PAGENO USING '<<<'
#          PRINT g_dash[1,g_len]
#          LET l_last_sw = 'n'
#
#       BEFORE GROUP OF sr.ima01
#          SKIP TO TOP OF PAGE
#
#       ON EVERY ROW
#          CALL s_opc(sr.ima37) RETURNING g_sta
#          PRINT COLUMN 01,g_x[11] CLIPPED,sr.ima01,
#                COLUMN 35,g_x[12] CLIPPED,sr.ima05,
#                COLUMN 45,g_x[13] CLIPPED,sr.ima08,
#                COLUMN 55,g_x[14] CLIPPED,sr.ima25
#         #start TQC-5B0019
#          PRINT COLUMN 01,g_x[15] CLIPPED,sr.ima02 #,
#         #      COLUMN 45,g_x[16] CLIPPED,sr.ima03
#         #end TQC-5B0019
#          PRINT COLUMN 10,sr.ima021
#         #start TQC-5B0019
#          PRINT COLUMN 01,g_x[16] CLIPPED,sr.ima03
#         #PRINT COLUMN 01,g_x[17] CLIPPED,cl_numfor(sr.ima27,15,3),
#         #      COLUMN 45,g_x[18] CLIPPED,sr.ima28
#         #PRINT COLUMN 01,g_x[19] CLIPPED,sr.ima37,' ',g_sta,
#         #      COLUMN 45,g_x[20] CLIPPED,cl_numfor(sr.ima56,15,3)
#         #PRINT COLUMN 01,g_x[21] CLIPPED,cl_numfor(sr.ima45,15,3),
#         #      COLUMN 45,g_x[22] CLIPPED,cl_numfor(sr.ima561,15,3)
#         #PRINT COLUMN 01,g_x[23] CLIPPED,cl_numfor(sr.ima46,15,3),
#         #      COLUMN 45,g_x[24] CLIPPED,sr.ima562
#         #PRINT COLUMN 01,g_x[25] CLIPPED,sr.ima47,
#         #      COLUMN 45,g_x[26] CLIPPED,sr.ima59
#         #PRINT COLUMN 01,g_x[27] CLIPPED,sr.ima48,
#         #      COLUMN 45,g_x[28] CLIPPED,sr.ima60
#         #PRINT COLUMN 01,g_x[29] CLIPPED,sr.ima49,
#         #      COLUMN 45,g_x[30] CLIPPED,sr.ima61
#         #PRINT COLUMN 01,g_x[31] CLIPPED,sr.ima491,
#         #      COLUMN 45,g_x[32] CLIPPED,cl_numfor(sr.ima64,15,3)
#         #PRINT COLUMN 01,g_x[33] CLIPPED,sr.ima50,
#         #      COLUMN 45,g_x[34] CLIPPED,cl_numfor(sr.ima641,15,3)
#          PRINT COLUMN 01,g_x[17] CLIPPED,COLUMN 15,cl_numfor(sr.ima27,15,3),
#                COLUMN 45,g_x[18] CLIPPED,COLUMN 53,sr.ima28
#          PRINT COLUMN 01,g_x[19] CLIPPED,COLUMN 30,sr.ima37 CLIPPED,' ',g_sta CLIPPED,  #No.TQC-6A0080
#                COLUMN 45,g_x[20] CLIPPED,COLUMN 55,cl_numfor(sr.ima56,16,3)
#          PRINT COLUMN 01,g_x[21] CLIPPED,COLUMN 15,cl_numfor(sr.ima45,15,3),
#                COLUMN 45,g_x[22] CLIPPED,COLUMN 55,cl_numfor(sr.ima561,16,3)
#          PRINT COLUMN 01,g_x[23] CLIPPED,COLUMN 15,cl_numfor(sr.ima46,15,3),
#                COLUMN 45,g_x[24] CLIPPED,COLUMN 67,sr.ima562
#          PRINT COLUMN 01,g_x[25] CLIPPED,COLUMN 23,sr.ima47,
#                COLUMN 45,g_x[26] CLIPPED,COLUMN 64,sr.ima59
#          PRINT COLUMN 01,g_x[27] CLIPPED,COLUMN 21,sr.ima48,
#               #COLUMN 45,g_x[28] CLIPPED,COLUMN 64,(sr.ima60/sr.ima56)  #CHI-810015 mark     #FUN-710073 mod
#                COLUMN 45,g_x[28] CLIPPED,COLUMN 64,sr.ima60             #CHI-810015 mark還原 #FUN-710073 mark
#          PRINT COLUMN 01,g_x[29] CLIPPED,COLUMN 21,sr.ima49,
#               #COLUMN 45,g_x[30] CLIPPED,COLUMN 64,(sr.ima61/sr.ima56)  #CHI-810015 mark     #FUN-710073 mod
#                COLUMN 45,g_x[30] CLIPPED,COLUMN 64,sr.ima61             #CHI-810015 mark還原 #FUN-710073 mark
#          PRINT COLUMN 01,g_x[31] CLIPPED,COLUMN 21,sr.ima491,
#                COLUMN 45,g_x[32] CLIPPED,COLUMN 58,cl_numfor(sr.ima64,16,3)
#          PRINT COLUMN 01,g_x[33] CLIPPED,COLUMN 21,sr.ima50,
#                COLUMN 45,g_x[34] CLIPPED,COLUMN 58,cl_numfor(sr.ima641,16,3)
#         #end TQC-5B0019
#         #PRINT g_dash[1,g_len]   #TQC-6B0011 mark
 
#       ON LAST ROW
#          PRINT g_dash[1,g_len]   #TQC-6B0011 add
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#          LET l_last_sw = 'y'
 
#      #start TQC-6B0011 add
#       PAGE TRAILER
#          IF l_last_sw = 'n' THEN
#             PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE
#             SKIP 2 LINES
#          END IF
#      #end TQC-6B0011 add
 
#END REPORT
#No.FUN-850048--end--
FUNCTION i600_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
 
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("buk_code",TRUE)
   END IF
#No.FUN-570110 --start
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ima01",TRUE)
   END IF
#No.FUN-570110 --end
END FUNCTION
 
FUNCTION i600_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
 
   IF g_sma.sma31='N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ima50",FALSE)
   END IF
#No.FUN-570110 --start
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ima01",FALSE)
   END IF
#No.FUN-570110 --end
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#FUN-870144

