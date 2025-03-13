# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_grw.4gl
# Descriptions...: Genero Report 樣板屬性設定作業
# Date & Author..: 10/12/01 JackLai
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80092 11/08/19 By jacklai GR簽核圖檔
# Modify.........: No.TQC-BC0014 11/12/01 By jacklai 修正上傳圖檔開窗無法顯示單頭資料的問題
# Modify.........: No:FUN-BC0063 11/12/19 By jacklai 未與EasyFlow整合的報表改為顯示簽核關卡文字
# Modify.........: No.FUN-C20112 12/02/23 By jacklai 上傳4rp改表格式比對
# Modify.........: No.FUN-C30005 12/03/01 By janet 加報表複製作業及將確認樣版是否default標準的gdw03='N' gdw06='std'
# Modify.........: No.FUN-C30143 12/03/13 By janet gdw04及gdw05欄位判斷，參考p_zaw的zaw04、zaw05
# Modify.........: No.FUN-C30205 12/03/20 By janet 樣版說明帶gfs_file.gfs03by語言別的資料
# Modify.........: No.FUN-C30290 12/03/20 By janet 報表複製作業，有Q出資料才可以執行
# Modify.........: No.TQC-C40053 12/04/11 By janet 增加gdw16欄位
# Modify.........: No:FUN-C50018 12/05/04 By janet 增加gfs帶預設值及i()判斷單頭是否重覆
# Modify.........: No:FUN-C50046 12/06/08 By janet 增加畫面report radio，判斷是否呼叫gr檢查機制
# Modify.........: No:FUN-C80015 12/08/20 By janet 增加畫面p_grw_gcw，可自訂命名歷史報表檔案
# Modify.........: No.FUN-CB0063 12/11/15 by stellar 4rp上傳改call s_gr_upload.4gl
# Modify.........: No.FUN-CC0005 12/12/07 by janet 在call s_gr_upload 前給gdw08值
# Modify.........: No.FUN-CC0081 12/12/19 by janet 刪除gdw_file時一同刪除gfs_file
# Modify.........: No.FUN-D10111 13/01/24 by odyliao 調整查詢時的排序方式
# Modify.........: No.FUN-D10108 13/01/24 by odyliao 增加預設樣板(gdw17)欄位
# Modify.........: No.CHI-D20028 13/02/27 by odyliao 刪除單身時，詢問是否一併刪除下游欄位資料(gdm_file)
# Modify.........: No.FUN-D20087 13/02/27 by odyliao 複製報表資訊時一起複製樣板說明(gfs_file)
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

#No.FUN-B40095
#假單頭
TYPE    gdw_head_type RECORD
        gdw01           LIKE gdw_file.gdw01,    # 程式代號
        gdw02           LIKE gdw_file.gdw02,    # 樣版代號
        gdw05           LIKE gdw_file.gdw05,    # 使用者
        gdw04           LIKE gdw_file.gdw04,    # 權限類別
        gdw06           LIKE gdw_file.gdw06,    # 行業別
        gdw03           LIKE gdw_file.gdw03,    # 客製否 #No.FUN-B80092
        gdw16           LIKE gdw_file.gdw16,     # 閒置時間 #No.TQC-C40053 ADD
        gdw14           LIKE gdw_file.gdw14,    # 列印簽核 #No.FUN-B80092
        gdw15           LIKE gdw_file.gdw15     # 列印簽核位置 #No.FUN-B80092
        END RECORD

#單身
TYPE    gdw_body_type   RECORD
        gdw07           LIKE gdw_file.gdw07,    # 序號
        gdw08           LIKE gdw_file.gdw08,    # 樣板ID
        gdw09           LIKE gdw_file.gdw09,    # 樣板名稱(4rp)
        gdw17           LIKE gdw_file.gdw17,    # 預設樣板  FUN-D10108
        #gdw10           LIKE gdw_file.gdw10,    # 樣板說明  #FUN-C30205 MARK
        gfs03           LIKE gfs_file.gfs03,    # 樣板說明   #FUN-C30205 ADD
        gdw11           LIKE gdw_file.gdw11,    # 標籤列印否
        gdw12           LIKE gdw_file.gdw12,    # 標籤X
        gdw13           LIKE gdw_file.gdw13,    # 標籤Y
        gdwdate         LIKE gdw_file.gdwdate,  # 最近修改日(上傳日期)
        gdwgrup         LIKE gdw_file.gdwgrup,  # 資料所有部門
        gdwmodu         LIKE gdw_file.gdwmodu,  # 資料修改者
        gdwuser         LIKE gdw_file.gdwuser,  # 資料所有者
        gdworig         LIKE gdw_file.gdworig,  # 資料修改者
        gdworiu         LIKE gdw_file.gdworiu   # 資料所有者
        END RECORD

DEFINE  g_gdw               gdw_head_type,                  # 假單頭
        g_gdw_t             gdw_head_type,                  # 假單頭(舊)
        g_gdw_lock          RECORD LIKE gdw_file.*,         # FOR LOCK CURSOR TOUCH
        g_gdw_b             DYNAMIC ARRAY OF gdw_body_type, # 程式變數
        g_gdw_bt            gdw_body_type,                  # 變數舊值
        g_wc                STRING,                         #No.FUN-580092 HCN
        g_wc2               STRING,
        g_sql               STRING,                         #No.FUN-580092 HCN
        g_ss                LIKE type_file.chr1,            # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
        g_rec_b             LIKE type_file.num5,            # 單身筆數     #No.FUN-680135 SMALLINT
        l_ac                LIKE type_file.num5,             # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
        g_cmd               LIKE type_file.chr1000
        
DEFINE  g_cnt               LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE  g_msg               LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE  g_argv1             LIKE gdw_file.gdw01
DEFINE  g_curs_index        LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE  g_row_count         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE  g_jump              LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE  g_no_ask            LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE  g_std_id            LIKE smb_file.smb01     #No.FUN-710055
DEFINE  g_db_type           LIKE type_file.chr3     #No.FUN-760049
DEFINE  g_gaz03             LIKE gaz_file.gaz03
DEFINE  g_zx02              LIKE zx_file.zx02
DEFINE  g_zw02              LIKE zw_file.zw02
DEFINE  g_zz011             LIKE zz_file.zz011      #模組 #No.FUN-B80092
DEFINE  g_open_cr_apr       LIKE type_file.chr1     #是否要開視窗p_cr_apr  #No.FUN-B80092
DEFINE  g_gdw08_v           LIKE gdw_file.gdw08     #畫面上的gdw08  #No.FUN-C30005 
DEFINE  g_gdw09_v           LIKE gdw_file.gdw09     #畫面上的gdw09  #No.FUN-C30005 




MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-73001
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    LET g_argv1 = ARG_VAL(1)

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AZZ")) THEN
        EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096

    #初始化假單頭
    INITIALIZE g_gdw.* TO NULL

    #一般行業別代碼
    #  SELECT smb01 INTO g_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"  #No.FUN-760049 mark
    LET g_std_id = "std"            #No.FUN-760049

    OPEN WINDOW p_grw_w WITH FORM "azz/42f/p_grw"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)

    CALL cl_ui_init()

     
    
    CALL p_grw_apr_act()   #報表簽核欄維護作業按鈕是否有效 #No.FUN-B80092

    # No.FUN-760049 行業別選項
    #  CALL p_grw_set_combobox()
    CALL cl_set_combo_industry("gdw06")    #No.FUN-750068
    LET g_db_type=cl_db_get_database_type()   #No.FUN-760049

    LET g_forupd_sql =  "SELECT * FROM gdw_file",
                        " WHERE gdw01=? AND gdw02=? AND gdw03=?",
                        " AND gdw04=? AND gdw05=? AND gdw06=?",
                        " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_grw_lock_u CURSOR FROM g_forupd_sql

    IF NOT cl_null(g_argv1) THEN
        CALL p_grw_q()
    END IF

    CALL p_grw_menu()

    CLOSE WINDOW p_grw_w                       # 結束畫面
    CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
END MAIN

FUNCTION p_grw_curs()                         # QBE 查詢資料
    CLEAR FORM                                    # 清除畫面
    CALL g_gdw_b.clear()

    IF NOT cl_null(g_argv1) THEN
        LET g_wc = "gdw01 = '",g_argv1 CLIPPED,"'"
    ELSE
        CALL cl_set_head_visible("","YES")   #No.FUN-6A0092

        #CONSTRUCT g_wc ON gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw14,gdw15,gdw07,gdw09,gdw10, #No.FUN-B80092 add gdw14,gdw15 #FUN-C30205 MARK
        #CONSTRUCT g_wc ON gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw14,gdw15,gdw07,gdw09, #No.FUN-B80092 add gdw14,gdw15  #FUN-C30205 ADD gdw10->gfs03 #TQC-C40053 MARK
        CONSTRUCT g_wc ON gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw16,gdw14,gdw15,gdw07,gdw09, #No.FUN-B80092 add gdw14,gdw15  #FUN-C30205 ADD gdw10->gfs03  #TQC-C40053 ADD gdw16
                          gdw17,       #FUN-D10108
                          gdwdate,gdwgrup,gdwmodu,gdwuser,gdworiu,gdworig
                    # FROM gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw14,gdw15,gdw07,gdw09,gdw10, #No.FUN-B80092 add gdw14,gdw15 #FUN-C30205 MARK 
                     #FROM gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw14,gdw15,gdw07,gdw09, #No.FUN-B80092 add gdw14,gdw15  #FUN-C30205 ADD gdw10->gfs03 ##TQC-C40053 MARK
                     FROM gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw16,gdw14,gdw15,gdw07,gdw09, #No.FUN-B80092 add gdw14,gdw15  #FUN-C30205 ADD gdw10->gfs03 #TQC-C40053 ADD gdw16
                          gdw17,       #FUN-D10108
                          gdwdate,gdwgrup,gdwmodu,gdwuser,gdworiu,gdworig
            ON ACTION controlp
                CASE
                    WHEN INFIELD(gdw01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gaz"
                        LET g_qryparam.state = "c"
                        LET g_qryparam.arg1 = g_lang
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gdw01
                        NEXT FIELD gdw01

                    WHEN INFIELD(gdw05)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zx"
                        LET g_qryparam.default1 = g_gdw.gdw05
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gdw05
                        NEXT FIELD gdw05

                    WHEN INFIELD(gdw04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zw"
                        LET g_qryparam.default1 = g_gdw.gdw04
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gdw04
                        NEXT FIELD gdw04
                    #FUN-C30205  ADD-START
                     #WHEN INFIELD(gdw10)
                       #CALL cl_init_qry_var()                    
                       #LET g_cmd = "p_gr_lang '",g_gdw08_v CLIPPED,"'"               
                           #CALL cl_cmdrun_wait(g_cmd)  
                           #CALL gfs_gfs03(l_ac)
                           #CALL p_grw_bp("G")             
                       #NEXT FIELD gdw10
                    #FUN-C30205  ADD-END 
                    OTHERWISE
                        EXIT CASE
                END CASE
            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
            ON ACTION HELP
                CALL cl_show_help()
            ON ACTION controlg
                CALL cl_cmdask()
            ON ACTION about
                CALL cl_about()
        END CONSTRUCT

        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030

        IF INT_FLAG THEN RETURN END IF
    END IF

    LET g_sql = "SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                "                gdw03,gdw16,gdw14,gdw15", #No.FUN-B80092 add gdw14,gdw15 #TQC-C40053 add gdw16
                " FROM gdw_file",
                " WHERE ",g_wc CLIPPED
               ," ORDER BY gdw01,gdw02,gdw05,gdw04,gdw06 "  #FUN-D10111
    PREPARE p_grw_prepare FROM g_sql          # 預備一下
    DECLARE p_grw_b_curs                      # 宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR p_grw_prepare
END FUNCTION

# 2004/09/29 MOD-490456 選出筆數直接寫入 g_row_count
FUNCTION p_grw_count()
    LET g_sql= "SELECT UNIQUE gdw01,gdw02,gdw05,gdw04,gdw06,gdw03",
               " FROM gdw_file",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY gdw01,gdw02,gdw03"

    PREPARE p_grw_precount FROM g_sql
    DECLARE p_grw_count CURSOR FOR p_grw_precount
    LET g_cnt=1
    LET g_rec_b=0
    FOREACH p_grw_count
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            LET g_rec_b = g_rec_b - 1
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_row_count=g_rec_b
END FUNCTION

FUNCTION p_grw_menu()
    DEFINE  ls_cmd  STRING

    WHILE TRUE
        CALL p_grw_bp("G")

        CASE g_action_choice
            WHEN "insert"                          # A.輸入
                IF cl_chk_act_auth() THEN
                    CALL p_grw_a()
                END IF
            WHEN "modify"                          # U.修改
                IF cl_chk_act_auth() THEN
                    CALL p_grw_u()
                END IF
            WHEN "reproduce"                       # C.複製
                IF cl_chk_act_auth() THEN
                    CALL p_grw_copy()
                END IF
            WHEN "delete"                          # R.取消
                IF cl_chk_act_auth() THEN
                    CALL p_grw_r()
                END IF
            WHEN "query"                           # Q.查詢
                IF cl_chk_act_auth() THEN
                    CALL p_grw_q()
                END IF
            WHEN "detail"
                IF cl_chk_act_auth() THEN
                    CALL p_grw_b()
                ELSE
                    LET g_action_choice = NULL
                END IF

            #No.FUN-B80092 --start--
            WHEN "cr_apr_act"                      #報表簽核欄維護作業            
                IF g_open_cr_apr = "Y" THEN
                    #LET ls_cmd = "p_cr_apr '",g_zz011 CLIPPED,"'"      #FUN-BC0063
                    LET ls_cmd = "p_cr_apr '",g_gdw.gdw01 CLIPPED,"'"   #FUN-BC0063
                    CALL cl_cmdrun(ls_cmd)
                END IF
            #No.FUN-B80092 --end--

            WHEN "help"                            # H.求助
                CALL cl_show_help()
            WHEN "exit"                            # Esc.結束
                EXIT WHILE
            WHEN "controlg"                        # KEY(CONTROL-G)
                CALL cl_cmdask()
            #WHEN "exporttoexcel"     #FUN-4B0049
            #   IF cl_chk_act_auth() THEN
            #       CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdw_b),'','')
            #   END IF
            WHEN "showlog"           #MOD-440464
                IF cl_chk_act_auth() THEN
                    CALL cl_show_log("p_grw")
                END IF
            #No.FUN-C30005 -START
            WHEN "copy4rp" #報表複製作業
                IF cl_chk_act_auth() THEN
                   IF g_cnt>0 OR NOT cl_null(g_gdw.gdw01) THEN  #FUN-C30290 ADD
                      #CALL s_gr_grw(g_gdw.gdw01,g_gdw08_v,g_gdw09_v)# FUN-C30290 MARK
                      CALL s_gr_grw(g_gdw08_v,g_gdw09_v)  #FUN-C30290 ADD
                      LET INT_FLAG =0  #FUN-C30290 ADD
                   END IF    #FUN-C30290 ADD
                END IF  
            #No.FUN-C30005 -END          
            #FUN-C80015   ADD-START
            WHEN "gcw_act" #報表複製作業
                IF cl_chk_act_auth() THEN
                   CALL p_grw_gcw()
                   CALL p_grw_filename_show()          #顯示報表檔案設定
                END IF
            #FUN-C80015   ADD-END
            #FUN-D10108---(S)
            WHEN "def_template"
                IF cl_chk_act_auth() THEN
                   CALL p_grw_def_template()          #預設樣板
                END IF
            #FUN-D10108---(E)
        END CASE

        CALL p_grw_apr_act()   #報表簽核欄維護作業按鈕是否有效 #No.FUN-B80092
    END WHILE
END FUNCTION

FUNCTION p_grw_a()                              # Add  輸入
    MESSAGE ""
    CLEAR FORM
    CALL g_gdw_b.clear()

    #預設值及將數值類變數清成零
    INITIALIZE g_gdw.gdw01 LIKE gdw_file.gdw01
    INITIALIZE g_gdw.gdw02 LIKE gdw_file.gdw02
    INITIALIZE g_gdw.gdw03 LIKE gdw_file.gdw03
    INITIALIZE g_gdw.gdw04 LIKE gdw_file.gdw04
    INITIALIZE g_gdw.gdw05 LIKE gdw_file.gdw05
    INITIALIZE g_gdw.gdw06 LIKE gdw_file.gdw06
    LET g_gdw.gdw16 = 20 #No.TQC-C40053 ADD
    LET g_gdw.gdw14 = "N" #No.FUN-B80092
    LET g_gdw.gdw15 = "1" #No.FUN-B80092

    CALL cl_opmsg('a')

    WHILE TRUE
        LET g_gdw.gdw03 = "N"                 # 客製否       
        LET g_gdw.gdw16 = 20                 # #No.TQC-C40053 ADD
        LET g_gdw.gdw05 = g_user
        LET g_gdw.gdw04 = 'default'
        LET g_gdw.gdw06 = g_std_id            # 行業別
        CALL p_gdw_desc("gdw04",g_gdw.gdw04)
        CALL p_gdw_desc("gdw05",g_gdw.gdw05)
        
        CALL p_grw_i("a")                       # 輸入單頭

        IF INT_FLAG THEN                        # 使用者不玩了
            INITIALIZE g_gdw.* TO NULL        # No.FUN-710055
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b = 0

        IF g_ss='N' THEN
            CALL g_gdw_b.clear()
        ELSE
            CALL p_grw_b_fill('1=1')            # 單身
        END IF

        CALL p_grw_b()                          # 輸入單身
        LET g_gdw_t.* = g_gdw.*
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION p_grw_i(p_cmd)                         # 處理INPUT
    DEFINE   p_cmd      LIKE type_file.chr1   # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
    DEFINE   l_zwacti   LIKE zw_file.zwacti

    LET g_ss = 'Y'

    DISPLAY BY NAME g_gdw.*

    CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
    INPUT BY NAME g_gdw.* WITHOUT DEFAULTS
        BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL p_grw_set_entry(p_cmd)
        CALL p_grw_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
        
        IF p_cmd = 'u' THEN
         IF g_gdw.gdw05 = 'default' THEN
            IF g_gdw.gdw04 <> 'default' THEN
               CALL cl_set_comp_entry("gdw04",TRUE)
               CALL cl_set_comp_entry("gdw05",FALSE)
            ELSE
               CALL cl_set_comp_entry("gdw04",TRUE)
               CALL cl_set_comp_entry("gdw05",TRUE)
            END IF
         ELSE
            IF g_gdw.gdw04 = 'default' THEN
               CALL cl_set_comp_entry("gdw05",TRUE)
               CALL cl_set_comp_entry("gdw04",FALSE)
            END IF
         END IF
        END IF
      
        #No.FUN-B80092 --start--
        IF cl_null(g_gdw.gdw14) THEN
           LET g_gdw.gdw14 = "N"
        END IF
        IF g_gdw.gdw14="Y" THEN
           CALL cl_set_comp_entry("gdw15",TRUE)
        ELSE
           CALL cl_set_comp_entry("gdw15",FALSE)
        END IF
        #No.FUN-B80092 --end--
      
        AFTER FIELD gdw01
           IF NOT cl_null(g_gdw.gdw01) THEN
              IF NOT p_grw_chkgdw01() THEN
                 CALL cl_err(g_gdw.gdw01,'azz-052',1)
                 #IF p_cmd = 'u' THEN
                 #   LET g_gdw.gdw05 = g_gdw_t.gdw05
                 #END IF
                 NEXT FIELD gdw01
              END IF
              CALL p_gdw_desc("gdw01",g_gdw.gdw01)               
           END IF
            
       AFTER FIELD gdw02
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM gdw_file
           WHERE gdw01 = g_gdw.gdw01 AND gdw02 = g_gdw.gdw02
             #AND gdw03 = g_gdw.gdw03 AND gdw04 = "default" #FUN-C30005 MARK
             AND gdw03 = 'N' AND gdw04 = "default"      #FUN-C30005 ADD
             AND gdw05 = "default"
             #AND gdw06 = g_gdw.gdw06  #FUN-C30005 MARK
             AND gdw06 = 'std'         #FUN-C30005 ADD
             
          IF g_cnt = 0 THEN
             LET g_gdw.gdw04 = "default"
             CALL p_gdw_desc("gdw04",g_gdw.gdw04)
             LET g_gdw.gdw05 = "default"
             CALL p_gdw_desc("gdw05",g_gdw.gdw05)
          END IF            
        #FUN-C30143 ADD START
        BEFORE FIELD gdw04
             CALL p_grw_set_entry(p_cmd)
        #FUN-C30143 ADD  START    
        AFTER FIELD gdw04
           IF NOT cl_null(g_gdw.gdw04) THEN
             #FUN-C30143 ADD-START
             IF g_gdw.gdw04 <> g_gdw_t.gdw04 OR cl_null(g_gdw_t.gdw04) THEN
                  IF g_gdw.gdw04 CLIPPED  ='default' AND g_gdw.gdw05 CLIPPED ='default' THEN
                    SELECT COUNT(*) INTO g_cnt FROM gdw_file
                      WHERE gdw01 = g_gdw.gdw01 
                        AND gdw02 = g_gdw.gdw02
                        AND gdw04 = 'default'
                        AND gdw05 = 'default'
                        AND gdw03 = 'N'   #FUN-C30005 add                 
                        AND gdw06 = 'std'  #FUN-C30005 add
                      IF (p_cmd = 'a' AND g_cnt = 0) OR 
                         (p_cmd = 'u' AND g_gdw_t.gdw04 = 'default' AND g_cnt = 1 )THEN
                         CALL cl_err(g_gdw.gdw04,'azz-086',0)                     
                         NEXT FIELD gdw04
                      END IF                 
                  END IF 
             END IF
              #FUN-C30143 ADD-END 
              IF g_gdw.gdw04 <> 'default' THEN
                 SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  WHERE gdw01 = g_gdw.gdw01 
                    AND gdw02 = g_gdw.gdw02
                    AND gdw04 = 'default'
                    AND gdw05 = 'default'
                   # AND gdw03 = g_gdw.gdw03     #FUN-C30005 mark                
                   # AND gdw06 = g_gdw.gdw06     #FUN-C30005 mark  
                    AND gdw03 = 'N'   #FUN-C30005 add                 
                    AND gdw06 = 'std'  #FUN-C30005 add
 
                  IF (p_cmd = 'a' AND g_cnt = 0) OR 
                     (p_cmd = 'u' AND g_gdw_t.gdw04 = 'default' AND g_cnt = 1 )THEN
                     CALL cl_err(g_gdw.gdw04,'azz-086',0)                     
                     NEXT FIELD gdw04
                  END IF
              END IF
                          
              IF g_gdw.gdw04 CLIPPED  <> 'default' THEN
               SELECT zwacti INTO l_zwacti FROM zw_file
                WHERE zw01 = g_gdw.gdw04
                IF STATUS THEN
                   CALL cl_err('select '||g_gdw.gdw04||" ",STATUS,0)
                   NEXT FIELD gdw04
                ELSE
                  IF l_zwacti != "Y" THEN
                     CALL cl_err_msg(NULL,"azz-218",g_gdw.gdw04 CLIPPED,10)
                     NEXT FIELD gdw04               
                  END IF
                END IF            
              END IF
              #CALL p_gdw_desc("gdw04",g_gdw.gdw04)  #FUN-C30143 MARK
            END IF 

        #FUN-C30143  ADD-START
             CALL p_gdw_desc("gdw04",g_gdw.gdw04)
             CALL p_grw_set_no_entry(p_cmd)
             IF g_gdw.gdw04 = 'default' THEN
                IF g_gdw.gdw05 <> 'default' THEN
                   CALL cl_set_comp_entry("gdw05",TRUE)
                   CALL cl_set_comp_entry("gdw04",FALSE)
                ELSE
                   CALL cl_set_comp_entry("gdw04",TRUE)
                   CALL cl_set_comp_entry("gdw05",TRUE)
                END IF
             ELSE
                IF g_gdw.gdw04 = 'default' THEN
                   CALL cl_set_comp_entry("gdw04",TRUE)
                   CALL cl_set_comp_entry("gdw05",FALSE)
                END IF
             END IF        

        #FUN-C30143  ADD-END
        
        #FUN-C30143 ADD   START 
        BEFORE FIELD gdw05
           CALL p_grw_set_entry(p_cmd)
        #FUN-C30143 ADD   END
        AFTER FIELD gdw05

            IF NOT cl_null(g_gdw.gdw05) THEN
               IF g_gdw.gdw05 <> g_gdw_t.gdw05 OR cl_null(g_gdw_t.gdw05) THEN       
                   # IF g_gdw.gdw05 <> 'default' THEN #FUN-C30143 MARK
                  #IF g_gdw_t.gdw04 CLIPPED = "default" AND g_gdw_t.gdw05 CLIPPED = "default" THEN #FUN-C30143 ADD
                  #     SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  #      WHERE gdw01 = g_gdw.gdw01 
                  #        AND gdw02 = g_gdw.gdw02
                  #        AND gdw04 = 'default'
                  #        AND gdw05 = 'default'
                  #          # AND gdw03 = g_gdw.gdw03     #FUN-C30005 mark                
                  #          # AND gdw06 = g_gdw.gdw06     #FUN-C30005 mark  
                  #        AND gdw03 = 'N'   #FUN-C30005 add                 
                  #        AND gdw06 = 'std'  #FUN-C30005 add
                  #         
                  #      IF (p_cmd = 'a' AND g_cnt = 0) OR 
                  #         (p_cmd = 'u' AND g_gdw_t.gdw05 = 'default' AND g_cnt = 1 )THEN
                  #         CALL cl_err(g_gdw.gdw05,'azz-086',0)                     
                  #         NEXT FIELD gdw05
                  #      END IF
                  #  END IF
                     
                     IF g_gdw.gdw05 <> 'default' THEN    
                        SELECT COUNT(*) INTO g_cnt FROM zx_file
                         WHERE zx01 = g_gdw.gdw05               
                         IF g_cnt = 0 THEN
                            CALL cl_err( g_gdw.gdw05,'mfg1312',0)
                            NEXT FIELD gdw05
                         END IF
                      END IF   
                      

                      #FUN-C30143 ADD START
                      IF g_gdw.gdw05 = 'default' THEN
                         IF g_gdw.gdw04 <> 'default' THEN
                            CALL cl_set_comp_entry("gdw04",TRUE)
                            CALL cl_set_comp_entry("gdw05",FALSE)
                         ELSE
                            CALL cl_set_comp_entry("gdw04",TRUE)
                            CALL cl_set_comp_entry("gdw05",TRUE)
                         END IF
                      ELSE
                         IF g_gdw.gdw04 = 'default' THEN
                            CALL cl_set_comp_entry("gdw05",TRUE)
                            CALL cl_set_comp_entry("gdw04",FALSE)
                         END IF
                      END IF            
                      #FUN-C30143 ADD END 
               END IF
            END IF            
            CALL p_gdw_desc("gdw05",g_gdw.gdw05)            
            CALL p_grw_set_no_entry(p_cmd)  #FUN-C30143 ADD
        #No.FUN-B80092 --start--
        ON CHANGE gdw14
            IF cl_null(g_gdw.gdw14) THEN
                LET g_gdw.gdw14 = "N"
            END IF
            IF g_gdw.gdw14="Y" THEN
                CALL cl_set_comp_entry("gdw15",TRUE)
                CALL cl_set_comp_required("gdw15", TRUE)  #預設為必填欄位
                IF cl_null(g_gdw.gdw15) THEN
                    LET g_gdw.gdw15 = "1" 
                END IF
            ELSE
                CALL cl_set_comp_entry("gdw15",FALSE)
                CALL cl_set_comp_required("gdw15", FALSE) #預設為非必填欄位
            END IF
      
        BEFORE FIELD gdw15
            IF cl_null(g_gdw.gdw14) THEN
                LET g_gdw.gdw14 = "N"
            END IF
            IF g_gdw.gdw14="Y" THEN
                CALL cl_set_comp_entry("gdw15",TRUE)
                CALL cl_set_comp_required("gdw15", TRUE)  #預設為必填欄位
                IF cl_null(g_gdw.gdw15) THEN
                    LET g_gdw.gdw15 = "1" 
                END IF
            ELSE
                CALL cl_set_comp_entry("gdw15",FALSE)
                CALL cl_set_comp_required("gdw15", FALSE) #預設為非必填欄位
            END IF
        #No.FUN-B80092 --end--

        AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
              EXIT INPUT
           END IF
           
           IF NOT cl_null(g_gdw.gdw01) THEN
              IF g_gdw.gdw04 <> 'default' OR g_gdw.gdw05 <> 'default'THEN
                 SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  WHERE gdw01 = g_gdw.gdw01
                    AND gdw02 = g_gdw.gdw02                    
                    AND gdw04 = 'default'
                    AND gdw05 = 'default'
                   # AND gdw03 = g_gdw.gdw03     #FUN-C30005 mark                
                   # AND gdw06 = g_gdw.gdw06     #FUN-C30005 mark  
                    AND gdw03 = 'N'   #FUN-C30005 add                 
                    AND gdw06 = 'std'  #FUN-C30005 add

                 IF (g_cnt = 0 ) THEN
                     CALL cl_err(g_gdw.gdw01,'azz-086',0)
                     NEXT FIELD gdw01
                 END IF
              END IF   

              IF (p_cmd = 'a') THEN
                ##FUN-C30005 MARK-START
                #FUN-C50018 add
                  SELECT COUNT(*) INTO g_cnt FROM gdw_file
                   WHERE gdw01 = g_gdw.gdw01 AND gdw02 = g_gdw.gdw02
                     AND gdw03 = g_gdw.gdw03 AND gdw04 = g_gdw.gdw04
                     AND gdw05 = g_gdw.gdw05 AND gdw06 = g_gdw.gdw06
                #FUN-C50018 add     
                  ##FUN-C30005 MARK-END 
                #FUN-C50018 add-start
                 #FUN-C30005 ADD-START
                 #SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  #WHERE gdw01 = g_gdw.gdw01
                    #AND gdw02 = g_gdw.gdw02                    
                    #AND gdw04 = 'default'
                    #AND gdw05 = 'default'
                    #AND gdw03 = 'N'                   
                    #AND gdw06 = 'std'  
                  #FUN-C30005 ADD-END
                 IF g_cnt > 0 THEN
                    CALL cl_err( '',-239,1)
                    NEXT FIELD gdw01
                 END IF                  
              END IF 
            
              IF g_gdw.gdw01 != g_gdw_t.gdw01 OR cl_null(g_gdw_t.gdw01) OR
                 g_gdw.gdw02 != g_gdw_t.gdw02 OR cl_null(g_gdw_t.gdw02) OR
                 g_gdw.gdw03 != g_gdw_t.gdw03 OR cl_null(g_gdw_t.gdw03) OR
                 g_gdw.gdw04 != g_gdw_t.gdw04 OR cl_null(g_gdw_t.gdw04) OR
                 g_gdw.gdw05 != g_gdw_t.gdw05 OR cl_null(g_gdw_t.gdw05) OR 
                 g_gdw.gdw06 != g_gdw_t.gdw06 OR cl_null(g_gdw_t.gdw06) THEN
                 
                ##FUN-C30005 MARK-START #FUN-C50018 add-start
                  SELECT COUNT(*) INTO g_cnt FROM gdw_file
                   WHERE gdw01 = g_gdw.gdw01 AND gdw02 = g_gdw.gdw02
                     AND gdw03 = g_gdw.gdw03 AND gdw04 = g_gdw.gdw04
                    AND gdw05 = g_gdw.gdw05 AND gdw06 = g_gdw.gdw06
                  ##FUN-C30005 MARK-END  #FUN-C50018 add-end
                  
                 #FUN-C30005 ADD-START #FUN-C50018 mark-start
                 #SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  #WHERE gdw01 = g_gdw.gdw01
                    #AND gdw02 = g_gdw.gdw02                    
                    #AND gdw04 = 'default'
                    #AND gdw05 = 'default'
                    #AND gdw03 = 'N'                    
                    #AND gdw06 = 'std'  
                  #FUN-C30005 ADD-END #FUN-C50018 mark-end 
                    IF g_cnt > 0 THEN                      
                       IF p_cmd = 'u' THEN
                          CALL cl_err( '',-239,0)
                          NEXT FIELD gdw01
                       END IF
                    END IF
              END IF
            END IF

        ON ACTION controlp
            CASE
                WHEN INFIELD(gdw01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1= g_gdw.gdw01
                   CALL cl_create_qry() RETURNING g_gdw.gdw01
                   NEXT FIELD gdw01
                                
                WHEN INFIELD(gdw04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zw"
                   LET g_qryparam.default1 = g_gdw.gdw04
                   CALL cl_create_qry() RETURNING g_gdw.gdw04
                   NEXT FIELD gdw04

                WHEN INFIELD(gdw05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zx"
                   LET g_qryparam.default1 = g_gdw.gdw05
                   CALL cl_create_qry() RETURNING g_gdw.gdw05
                   NEXT FIELD gdw05
                           
                OTHERWISE
                    EXIT CASE
            END CASE
        ON ACTION controlf                  #欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        ON ACTION about
            CALL cl_about()
        ON ACTION HELP
            CALL cl_show_help()
        ON ACTION controlg
            CALL cl_cmdask()
    END INPUT
END FUNCTION

FUNCTION p_grw_u()
   DEFINE l_gdw gdw_head_type #No.FUN-B80092

    IF s_shut(0) THEN
        RETURN
    END IF
    IF cl_null(g_gdw.gdw01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gdw_t.* = g_gdw.*

    BEGIN WORK
    OPEN p_grw_lock_u USING g_gdw.gdw01,g_gdw.gdw02,g_gdw.gdw03,
                            g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06
    IF STATUS THEN
        CALL cl_err("DATA LOCK:",STATUS,1)
        CLOSE p_grw_lock_u
        ROLLBACK WORK
        RETURN
    END IF
    FETCH p_grw_lock_u INTO g_gdw_lock.*
    IF SQLCA.sqlcode THEN
        CALL cl_err("gdw01 LOCK:",SQLCA.sqlcode,1)
        CLOSE p_grw_lock_u
        ROLLBACK WORK
        RETURN
    END IF

   #DISPLAY BY NAME g_gdw.* #FUN-C30143 ADD
    
    WHILE TRUE
        CALL p_grw_i("u")
        IF INT_FLAG THEN
            LET g_gdw.* = g_gdw_t.*
            DISPLAY BY NAME g_gdw.*
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE gdw_file
            SET gdw01 = g_gdw.gdw01,
                gdw02 = g_gdw.gdw02,
                gdw03 = g_gdw.gdw03,
                gdw04 = g_gdw.gdw04,
                gdw05 = g_gdw.gdw05,
                gdw06 = g_gdw.gdw06,
                gdw16 = g_gdw.gdw16, #TQC-C40053 ADD
                gdw14 = g_gdw.gdw14, #No.FUN-B80092
                gdw15 = g_gdw.gdw15, #No.FUN-B80092
                gdwmodu = g_user
            WHERE gdw01 = g_gdw_t.gdw01
            AND gdw02 = g_gdw_t.gdw02
            AND gdw03 = g_gdw_t.gdw03
            AND gdw04 = g_gdw_t.gdw04
            AND gdw05 = g_gdw_t.gdw05
            AND gdw06 = g_gdw_t.gdw06
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gdw_file",g_gdw_t.gdw01,g_gdw_t.gdw03,SQLCA.sqlcode,"","",1) #No.FUN-660081
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK

    #No.FUN-B80092 --start--
    LET l_gdw.* = g_gdw.*
    CLOSE p_grw_b_curs
    OPEN p_grw_b_curs
    CALL p_grw_fetch('F')
    WHILE TRUE
        IF l_gdw.gdw01 = g_gdw.gdw01 AND l_gdw.gdw02 = g_gdw.gdw02 AND l_gdw.gdw03 = g_gdw.gdw03
          AND l_gdw.gdw04 = g_gdw.gdw04 AND l_gdw.gdw05 = g_gdw.gdw05 AND l_gdw.gdw06 = g_gdw.gdw06
        THEN
            EXIT WHILE
        END IF
        CALL p_grw_fetch('N')
    END WHILE
    #No.FUN-B80092 --end--
END FUNCTION

FUNCTION p_grw_q()                              #Query 查詢
    MESSAGE ""
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CLEAR FORM  #NO.TQC-740075
    CALL g_gdw_b.clear()
    DISPLAY '' TO FORMONLY.cnt
    CALL p_grw_curs()                           #取得查詢條件
    IF INT_FLAG THEN                            #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN p_grw_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN                       #有問題
        CALL cl_err('',SQLCA.SQLCODE,0)
        INITIALIZE g_gdw.* TO NULL
    ELSE
        CALL p_grw_count()
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL p_grw_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF

    CALL p_grw_apr_act()   #報表簽核欄維護作業按鈕是否有效 #No.FUN-B80092
END FUNCTION

FUNCTION p_grw_fetch(p_flag)                        #處理資料的讀取
    DEFINE  p_flag   LIKE type_file.chr1            #處理方式     #No.FUN-680135 VARCHAR(1)

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_grw_b_curs INTO g_gdw.*   #No.FUN-710055
        WHEN 'P' FETCH PREVIOUS p_grw_b_curs INTO g_gdw.*   #No.FUN-710055
        WHEN 'F' FETCH FIRST    p_grw_b_curs INTO g_gdw.*   #No.FUN-710055
        WHEN 'L' FETCH LAST     p_grw_b_curs INTO g_gdw.*   #No.FUN-710055
        WHEN '/'
            IF (NOT g_no_ask) THEN          #No.FUN-6A0080
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                    ON ACTION controlp
                        CALL cl_cmdask()
                    ON ACTION HELP
                        CALL cl_show_help()
                    ON ACTION about
                        CALL cl_about()
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump p_grw_b_curs INTO g_gdw.*   #No.FUN-710055
            LET g_no_ask = FALSE    #No.FUN-6A0080
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gdw.gdw01,SQLCA.sqlcode,0)
        INITIALIZE g_gdw.* TO NULL  #TQC-6B0105
    ELSE
        CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
        END CASE

        CALL cl_navigator_setting(g_curs_index, g_row_count)

        CALL p_grw_show()
    END IF
END FUNCTION

#FUN-4A0088
FUNCTION p_grw_show()                         # 將資料顯示在畫面上
    DISPLAY BY NAME g_gdw.*
    CALL p_gdw_desc("gdw01",g_gdw.gdw01)
    CALL p_gdw_desc("gdw04",g_gdw.gdw04)
    CALL p_gdw_desc("gdw05",g_gdw.gdw05)
    CALL p_grw_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    CALL p_grw_apr_act() #報表簽核欄維護作業按鈕是否有效 #No.FUN-B80092
END FUNCTION

FUNCTION p_grw_r()        # 取消整筆 (所有合乎單頭的資料)
    DEFINE l_i   INTEGER   #FUN-CC0081 

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_gdw.gdw01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    #刪除時使用者=default + 權限類別=default 
    #檢查是否有其他使用者或權限類別的資料
    IF g_gdw.gdw04 = 'default' AND g_gdw.gdw05 = 'default' THEN
       SELECT COUNT(*) INTO g_cnt FROM gdw_file
        WHERE gdw01 = g_gdw.gdw01 
          AND gdw02 = g_gdw.gdw02
          AND gdw03 = g_gdw.gdw03
          AND (gdw04 <> 'default'
           OR  gdw05 <> 'default' )
          AND gdw06 = g_gdw.gdw06 
                  
          IF g_cnt > 0  THEN
             CALL cl_err(g_gdw.gdw05,'azz-086',1)                     
             RETURN
          END IF
    END IF
  
    SELECT COUNT(*) INTO g_cnt FROM gdm_file,gdw_file 
     WHERE gdm01 = gdw08
       AND gdw01 = g_gdw.gdw01
       AND gdw02 = g_gdw.gdw02
       AND gdw03 = g_gdw.gdw03
       AND gdw04 = g_gdw.gdw04
       AND gdw05 = g_gdw.gdw05
       AND gdw06 = g_gdw.gdw06

    IF g_cnt > 0 THEN
  #FUN-D20087 --(s)
       #CALL cl_err('','azz-913',1)
       #RETURN
       IF NOT cl_confirm('azz1314') THEN RETURN END IF
    ELSE
       IF NOT cl_delh(0,0) THEN RETURN END IF
  #FUN-D20087 --(e)
    END IF
           
    BEGIN WORK    
  # IF cl_delh(0,0) THEN   #FUN-D20087 mark
        DELETE FROM gdw_file WHERE gdw01 = g_gdw.gdw01
            AND gdw02 = g_gdw.gdw02 AND gdw03 = g_gdw.gdw03
            AND gdw04 = g_gdw.gdw04 AND gdw05 = g_gdw.gdw05
            AND gdw06 = g_gdw.gdw06
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","gdw_file",g_gdw.gdw01,g_gdw.gdw03,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
        ELSE
            #FUN-CC0081 add -(s)
            FOR l_i=1 TO g_gdw_b.getLength()  
                DELETE FROM gfs_file WHERE gfs01 = g_gdw_b[l_i].gdw08
                DELETE FROM gdm_file WHERE gdm01 = g_gdw_b[l_i].gdw08 #FUN-D20087
            END FOR 
            #FUN-CC0081 add -(e)        
            CLEAR FORM
            CALL g_gdw_b.clear()
            CALL p_grw_count()
            DISPLAY g_row_count TO FORMONLY.cnt
            #FUN-B50065-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50065-add-end-- 
            OPEN p_grw_b_curs
            IF g_curs_index = g_row_count + 1 THEN
                LET g_jump = g_row_count
                CALL p_grw_fetch('L')
            ELSE
                LET g_jump = g_curs_index
                LET g_no_ask = TRUE           #No.FUN-6A0080
                CALL p_grw_fetch('/')
            END IF

        END IF
  # END IF #FUN-D20087
    COMMIT WORK
END FUNCTION

FUNCTION p_grw_b()                            # 單身
    DEFINE  l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
    DEFINE  ls_msg_o        STRING
    DEFINE  ls_msg_n        STRING
    DEFINE  l_gdw08         LIKE gdw_file.gdw08

    LET g_action_choice = ""
    IF s_shut(0) THEN
        RETURN
    END IF
    IF cl_null(g_gdw.gdw01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    #FUN-C30205 MARK-START
    #LET g_forupd_sql =  "SELECT gdw07,gdw08,gdw09,gdw10,gdw11,",
                        #"       gdw12,gdw13,gdwdate,gdwgrup,gdwmodu,",
                        #"       gdwuser,gdworig,gdworiu",
                        #" FROM gdw_file",
                        #" WHERE gdw01=? AND gdw02=? AND gdw03=?",
                        #" AND gdw04=? AND gdw05=? AND gdw06=?",
                        #" AND gdw07=? ",
                        #" FOR UPDATE"
    #FUN-C30205 MARK-START
    #FUN-C30205 ADD-START    
    #LET g_forupd_sql =  "SELECT gdw07,gdw08,gdw09,'',gdw11,",       #FUN-D10108 mark
    LET g_forupd_sql =  "SELECT gdw07,gdw08,gdw09,gdw17,'',gdw11,",  #FUN-D10108 add gdw17
                        "       gdw12,gdw13,gdwdate,gdwgrup,gdwmodu,",
                        "       gdwuser,gdworig,gdworiu",
                        " FROM gdw_file ",
                        " WHERE gdw01=? AND gdw02=? AND gdw03=?",
                        " AND gdw04=? AND gdw05=? AND gdw06=?",
                        " AND gdw07=? ",
                        " FOR UPDATE"      
    #FUN-C30205 MARK-END                     
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_grw_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0

    INPUT ARRAY g_gdw_b WITHOUT DEFAULTS FROM s_gdw.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_gdw_bt.* = g_gdw_b[l_ac].*    #BACKUP
                OPEN p_grw_bcl USING g_gdw.gdw01,g_gdw.gdw02,g_gdw.gdw03,
                                     g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06,
                                     g_gdw_b[l_ac].gdw07   
                                     
                IF SQLCA.sqlcode THEN
                    CALL cl_err("OPEN p_grw_bcl:", STATUS, 1)
                    LET l_lock_sw = 'Y'
                ELSE
                    FETCH p_grw_bcl INTO g_gdw_b[l_ac].*
                    
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('FETCH p_grw_bcl:',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    
                END IF
                #CALL gfs_gfs03(l_ac)  #FUN-C30205 抓gfs03  #FUN-C30290 MARK
                IF l_ac<>0 THEN CALL gfs_gfs03(l_ac) END IF  #FUN-C30290 ADD
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE FIELD gdw07
            IF g_gdw_b[l_ac].gdw07 IS NULL THEN
               SELECT max(gdw07)+1
                 INTO g_gdw_b[l_ac].gdw07
                 FROM gdw_file
                WHERE gdw01 = g_gdw.gdw01
                  AND gdw02 = g_gdw.gdw02 AND gdw03 = g_gdw.gdw03
                  AND gdw04 = g_gdw.gdw04 AND gdw05 = g_gdw.gdw05
                  AND gdw06 = g_gdw.gdw06
               NEXT FIELD gdw09
            END IF

        AFTER FIELD gdw09
            IF NOT cl_null(g_gdw_b[l_ac].gdw09) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt
                 FROM gdw_file
                WHERE gdw01 = g_gdw.gdw01
                  AND gdw02 = g_gdw.gdw02 AND gdw03 = g_gdw.gdw03
                  AND gdw04 = g_gdw.gdw04 AND gdw05 = g_gdw.gdw05
                  AND gdw06 = g_gdw.gdw06 
                  AND gdw07 <> g_gdw_b[l_ac].gdw07
                  AND gdw09 = g_gdw_b[l_ac].gdw09
                  
               IF g_cnt>0 THEN
                  CALL cl_err( '','azz-910', 0)
                  NEXT FIELD gdw09
               END IF
            END IF



 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gdw_b[l_ac].* TO NULL       #900423
            LET g_gdw_bt.* = g_gdw_b[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            #CALL gfs_gfs03(l_ac)  #FUN-C30205 #FUN-C30290 MARK
            IF l_ac<>0 THEN CALL gfs_gfs03(l_ac) END IF  #FUN-C30290 ADD
            SELECT MAX(gdw08) + 1 INTO l_gdw08 FROM gdw_file
            IF l_gdw08 IS NULL THEN
               LET l_gdw08 = 1
            END IF
            LET g_gdw_b[l_ac].gdw08 = l_gdw08
            LET g_gdw_b[l_ac].gdw17 = "N"      #FUN-D10108
            LET g_gdw_b[l_ac].gdwuser = g_user
            LET g_gdw_b[l_ac].gdwgrup = g_grup
            LET g_gdw_b[l_ac].gdwdate = g_today
            LET g_gdw_b[l_ac].gdworiu = g_user
            LET g_gdw_b[l_ac].gdworig = g_grup
            LET g_gdw_b[l_ac].gdw11 = "N" 

            IF g_gdw_b[l_ac].gdw07 IS NULL THEN
               IF l_ac = 1 THEN
                  LET g_gdw_b[l_ac].gdw07 = 1
                  NEXT FIELD gdw09
               ELSE
                  NEXT FIELD gdw07
               END IF
            ELSE
               NEXT FIELD gdw09
            END IF    

        AFTER INSERT
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CANCEL INSERT
            END IF
            INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                                #  gdw06,gdw07,gdw08,gdw09,gdw10, #FUN-C30205 MARK
                                  gdw06,gdw07,gdw08,gdw09,        #FUN-C30205  ADD
                                  gdw11,gdw12,gdw13,gdwdate,gdwgrup,
                                  gdwmodu,gdwuser,gdworig,gdworiu,gdw14, #No.FUN-B80092
                                  #gdw15) #No.FUN-B80092
                                  gdw15,gdw17) #No.FUN-D10108 add gdw17
                VALUES (g_gdw.gdw01,g_gdw.gdw02,g_gdw.gdw03,g_gdw.gdw04,
                        g_gdw.gdw05,g_gdw.gdw06,g_gdw_b[l_ac].gdw07,
                        g_gdw_b[l_ac].gdw08,g_gdw_b[l_ac].gdw09,
                        #g_gdw_b[l_ac].gdw10,g_gdw_b[l_ac].gdw11,#FUN-C30205 MARK 
                        g_gdw_b[l_ac].gdw11,                    #FUN-C30205  ADD
                        g_gdw_b[l_ac].gdw12,g_gdw_b[l_ac].gdw13,
                        g_gdw_b[l_ac].gdwdate,g_gdw_b[l_ac].gdwgrup,
                        g_gdw_b[l_ac].gdwmodu,g_gdw_b[l_ac].gdwuser,
                        g_gdw_b[l_ac].gdworig,g_gdw_b[l_ac].gdworiu,g_gdw.gdw14, #No.FUN-B80092
                        #g_gdw.gdw15) #No.FUN-B80092
                        g_gdw.gdw15,g_gdw_b[l_ac].gdw17) #No.FUN-D10108 add gdw17
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","gdw_file",g_gdw.gdw01,g_gdw_b[l_ac].gdw07,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                CANCEL INSERT
            END IF
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_gdw_bt.gdw07) THEN              
               SELECT COUNT(*) INTO g_cnt FROM gdm_file
                WHERE gdm01 = g_gdw_b[l_ac].gdw08
                
                IF g_cnt > 0 THEN
              #CHI-D20028 add-------------(S)
                   #CALL cl_err("", 'azz-913', 1)
                   #CANCEL DELETE
                   IF NOT cl_confirm('azz1314') THEN
                      CANCEL DELETE
                   END IF 
                ELSE
                   IF NOT cl_delb(0,0) THEN
                       CANCEL DELETE
                   END IF
              #CHI-D20028 add-------------(E)
                END IF
                
              #CHI-D20028 add mark-------------(S)
               #IF NOT cl_delb(0,0) THEN
               #    CANCEL DELETE
               #END IF
              #CHI-D20028 add mark-------------(E)
                
                IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                END IF

                DELETE FROM gdw_file 
              #CHI-D20028 add mark-------------(S)
                #WHERE gdw01 = g_gdw.gdw01
                #  AND gdw02 = g_gdw.gdw02 AND gdw03 = g_gdw.gdw03
                #  AND gdw04 = g_gdw.gdw04 AND gdw05 = g_gdw.gdw05
                #  AND gdw06 = g_gdw.gdw06 AND gdw07 = g_gdw_b[l_ac].gdw07
                 WHERE gdw08 = g_gdw_b[l_ac].gdw08
              #CHI-D20028 add mark-------------(S)

                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","gdw_file",g_gdw.gdw01,g_gdw_b[l_ac].gdw09,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                    ROLLBACK WORK
                    CANCEL DELETE
              #CHI-D20028 add mark-------------(S)
                ELSE
                    DELETE FROM gdm_file 
                     WHERE gdm01 = g_gdw_b[l_ac].gdw08
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","gdm_file",g_gdw_b[l_ac].gdw08,'',SQLCA.sqlcode,"","",0) 
                        ROLLBACK WORK
                        CANCEL DELETE
                    END IF
              #CHI-D20028 add mark-------------(E)
                END IF
                #FUN-CC0081 add-(s)
                 COMMIT WORK
                 DELETE FROM gfs_file 
                 WHERE gfs01 = g_gdw_b[l_ac].gdw08

                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","gfs_file",g_gdw.gdw01,g_gdw_b[l_ac].gdw09,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                #FUN-CC0081 add-(e)
                LET g_rec_b = g_rec_b - 1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_gdw_b[l_ac].* = g_gdw_bt.*
                CLOSE p_grw_bcl
                ROLLBACK WORK
                EXIT INPUT
            END IF

            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_gdw_b[l_ac].gdw09,-263,1)
                LET g_gdw_b[l_ac].* = g_gdw_bt.*
            ELSE
                LET g_gdw_b[l_ac].gdwdate = g_today
                #CALL gfs_gfs03(l_ac) # FUN-C30205 #FUN-C30290 MARK
                IF l_ac<>0 THEN CALL gfs_gfs03(l_ac) END IF  #FUN-C30290 ADD
                UPDATE gdw_file
                    SET gdw07 = g_gdw_b[l_ac].gdw07,
                        gdw09 = g_gdw_b[l_ac].gdw09,
                        #gdw10 = g_gdw_b[l_ac].gdw10,     #FUN-C30205 MARK                    
                        gdw11 = g_gdw_b[l_ac].gdw11,
                        gdw12 = g_gdw_b[l_ac].gdw12,
                        gdw13 = g_gdw_b[l_ac].gdw13,
                        gdwdate = g_gdw_b[l_ac].gdwdate,
                        gdwgrup = g_gdw_b[l_ac].gdwgrup,
                        gdwmodu = g_gdw_b[l_ac].gdwmodu,
                        gdwuser = g_gdw_b[l_ac].gdwuser,
                        gdworig = g_gdw_b[l_ac].gdworig,
                        gdworiu = g_gdw_b[l_ac].gdworiu, #No.FUN-B80092
                        gdw14 = g_gdw.gdw14, #No.FUN-B80092
                        gdw15 = g_gdw.gdw15  #No.FUN-B80092
                WHERE gdw01 = g_gdw.gdw01 AND gdw02 = g_gdw.gdw02
                  AND gdw03 = g_gdw.gdw03 AND gdw04 = g_gdw.gdw04
                  AND gdw05 = g_gdw.gdw05 AND gdw06 = g_gdw.gdw06
                  AND gdw07 = g_gdw_b[l_ac].gdw07
                IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_gae[l_ac].gae02,SQLCA.sqlcode,0)  #No.FUN-660081
                   CALL cl_err3("upd","gdw_file",g_gdw.gdw01,g_gdw_b[l_ac].gdw09,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                   LET g_gdw_b[l_ac].* = g_gdw_bt.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                   LET ls_msg_n = g_gdw.gdw01 CLIPPED,"",g_gdw.gdw02 CLIPPED,"",
                                  g_gdw.gdw03 CLIPPED,"",g_gdw.gdw04 CLIPPED,"",
                                  g_gdw.gdw05 CLIPPED,"",g_gdw.gdw06 CLIPPED,"",
                                  g_gdw_b[l_ac].gdw07 CLIPPED,"",g_gdw_b[l_ac].gdw08 CLIPPED,"",
                                 # g_gdw_b[l_ac].gdw09 CLIPPED,"",g_gdw_b[l_ac].gdw10 CLIPPED,"", #FUN-C30205 MARK
                                  g_gdw_b[l_ac].gdw09 CLIPPED,"",                                     #FUN-C30205  ADD
                                  g_gdw_b[l_ac].gdw11 CLIPPED,"",g_gdw_b[l_ac].gdw12 CLIPPED,"",
                                  g_gdw_b[l_ac].gdw13 CLIPPED,"",g_gdw.gdw14 CLIPPED,"", #No.FUN-B80092
                                  g_gdw.gdw15 CLIPPED #No.FUN-B80092
                   LET ls_msg_o = g_gdw.gdw01 CLIPPED,"",g_gdw.gdw02 CLIPPED,"",
                                  g_gdw.gdw03 CLIPPED,"",g_gdw.gdw04 CLIPPED,"",
                                  g_gdw.gdw05 CLIPPED,"",g_gdw.gdw06 CLIPPED,"",
                                  g_gdw_bt.gdw07 CLIPPED,"",g_gdw_bt.gdw08 CLIPPED,"",
                                  #g_gdw_bt.gdw09 CLIPPED,"",g_gdw_bt.gdw10 CLIPPED,"",#FUN-C30205 MARK    
                                  g_gdw_bt.gdw09 CLIPPED,"",                                #FUN-C30205  ADD
                                  g_gdw_bt.gdw11 CLIPPED,"",g_gdw_bt.gdw12 CLIPPED,"",
                                  g_gdw_bt.gdw13 CLIPPED,"",g_gdw.gdw14 CLIPPED,"", #No.FUN-B80092
                                  g_gdw.gdw15 CLIPPED #No.FUN-B80092
                    #CALL cl_log("p_grw","U",ls_msg_n,ls_msg_o)            # MOD-440464 #FUN-C30290 MARK
                END IF
            END IF
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac          #FUN-D30034 mark
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_gdw_b[l_ac].* = g_gdw_bt.*
                #FUN-D30034---add---str---
                ELSE
                   CALL g_gdw_b.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30034---add---end---    
                END IF
                CLOSE p_grw_bcl
                ROLLBACK WORK
                EXIT INPUT
            END IF
            LET l_ac_t = l_ac          #FUN-D30034 add
            CLOSE p_grw_bcl
            COMMIT WORK
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(gae02) AND l_ac > 1 THEN
                LET g_gdw_b[l_ac].* = g_gdw_b[l_ac-1].*
                NEXT FIELD gae02
            END IF
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        ON ACTION HELP
            CALL cl_show_help()
        ON ACTION about
            CALL cl_about()
        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
        
        ON ACTION controlp
               CASE   #FUN-C50018 add
                  WHEN INFIELD(gfs03)  #FUN-C50018 add
                    #FUN-C30205  ADD-START
                       CALL cl_init_qry_var()
                       CALL p_grw_ins_gfs(g_gdw_b[l_ac].gdw08) ##FUN-C50018 add
                       LET g_cmd = "p_gr_lang '",g_gdw_b[l_ac].gdw08 CLIPPED,"'"               
                           CALL cl_cmdrun_wait(g_cmd)
                           #CALL gfs_gfs03(l_ac)  #FUN-C30290 MARK
                           IF l_ac<>0 THEN CALL gfs_gfs03(l_ac) END IF  #FUN-C30290 ADD
                           IF g_rec_b >= l_ac THEN #判斷若還有資料 則跳下一筆
                              NEXT FIELD gdw09
                           ELSE   #否則離開input
                              EXIT INPUT
                           END if
                       #EXIT INPUT     
                       #NEXT FIELD gdw11

                    #FUN-C30205  ADD-END 
              END CASE  #FUN-C50018 add
    END INPUT

    CLOSE p_grw_bcl
    #CALL gfs_gfs03(l_ac)   #FUN-C30205  ADD  #FUN-C30290 MARK
    IF l_ac<>0 THEN CALL gfs_gfs03(l_ac) END IF  #FUN-C30290 ADD
    COMMIT WORK
END FUNCTION


#FUN-C50018 ADD-START----
FUNCTION p_grw_ins_gfs(p_gdw08)
  DEFINE p_gdw08 LIKE gfs_file.gfs01
  DEFINE l_cnt,i,l_cnt1   LIKE type_file.num5
  DEFINE l_gfs  DYNAMIC ARRAY OF RECORD 
         gfs01   LIKE gfs_file.gfs01,
         gfs02   LIKE gfs_file.gfs02,
         gfs03   LIKE gfs_file.gfs03
         END RECORD 

  LET l_cnt=0  
  SELECT count(*) INTO l_cnt FROM gfs_file WHERE gfs01=p_gdw08  
  IF l_cnt>0 THEN RETURN END IF 
  IF l_cnt=0 THEN 
     IF cl_confirm("azz1228") THEN 
         DECLARE gfs01 SCROLL CURSOR FOR 
                 SELECT * FROM gfs_file WHERE gfs01='0'
         LET i=1 
         CALL l_gfs.clear()
         FOREACH gfs01 INTO l_gfs[i].*
           LET i=i+1
         END FOREACH 
         LET l_cnt1=i
         CALL l_gfs.deleteElement(l_cnt1)
         FOR i=1 TO  l_cnt1
         
           INSERT INTO gfs_file VALUES (p_gdw08,l_gfs[i].gfs02,l_gfs[i].gfs03)

           #INSERT INTO gfs_file(gfs01,gfs02,gfs03) VALUES (l_gfs[i].gfs01,l_gfs[i].gfs02,l_gfs[i].gfs03)
         END FOR 
         COMMIT WORK
     END IF 
  END IF 

  
END FUNCTION 
#FUN-C50018 ADD-END ----

FUNCTION p_grw_b_fill(p_wc)               #BODY FILL UP

    DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)
    #FUN-C30205  MARK-START
    #LET g_sql = "SELECT gdw07,gdw08,gdw09,gdw10,gdw11,",
                #"       gdw12,gdw13,gdwdate,gdwgrup,gdwmodu,",
                #"       gdwuser,gdworig,gdworiu",
                #" FROM gdw_file",
                #" WHERE gdw01=? AND gdw02=? AND gdw03=?",
                #" AND gdw04=? AND gdw05=? AND gdw06=?",
                #" AND ",p_wc CLIPPED,
                #" ORDER BY gdw07,gdw09"
    #FUN-C30205  MARK-END
    #FUN-C30205  ADD-START
    #LET g_sql = "SELECT gdw07,gdw08,gdw09,gfs03,gdw11,",
    LET g_sql = "SELECT gdw07,gdw08,gdw09,gdw17,gfs03,gdw11,", #FUN-D10108 add gdw17
                "       gdw12,gdw13,gdwdate,gdwgrup,gdwmodu,",
                "       gdwuser,gdworig,gdworiu",
                " FROM gdw_file left join gfs_file on gfs01=gdw08 AND gfs02=? ",
                " WHERE gdw01=? AND gdw02=? AND gdw03=?",
                " AND gdw04=? AND gdw05=? AND gdw06=?",
                " AND ",p_wc CLIPPED,
                " ORDER BY gdw07,gdw09"  

                
    #FUN-C30205  ADD-END
    PREPARE p_grw_prepare2 FROM g_sql           #預備一下
    DECLARE p_grw_bfill_curs CURSOR FOR p_grw_prepare2

    CALL g_gdw_b.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    #單身 ARRAY 填充
    OPEN p_grw_bfill_curs USING g_lang,g_gdw.gdw01,g_gdw.gdw02,g_gdw.gdw03,
                                #g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06 #FUN-C30205 MARK                               
                                g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06  #FUN-C30205 ADD
    FOREACH p_grw_bfill_curs INTO g_gdw_b[g_cnt].*
        
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #FUN-C30205  MARK-START
        ##FUN-C30205--ADD---START
       #SELECT gfs03 INTO g_gdw_b[g_cnt].gdw10
         #FROM gfs_file WHERE gfs01 = g_gdw_b[g_cnt].gdw08 AND gfs02=g_lang
        #IF SQLCA.SQLCODE=100 THEN
          #LET g_gdw_b[g_cnt].gdw10=NULL
          #
        #END IF

        ##FUN-C30205  ADD----END  
       #FUN-C30205  MARK-END      
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gdw_b.deleteElement(g_cnt)

    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION p_grw_bp(p_ud)
    DEFINE  p_ud    LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    CALL SET_COUNT(g_rec_b)
    CALL p_grw_apr_act()   #報表簽核欄維護作業按鈕是否有效 #No.FUN-B80092
    DISPLAY ARRAY g_gdw_b TO s_gdw.* ATTRIBUTE(UNBUFFERED)
        BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
        ON ACTION insert                           # A.輸入
            LET g_action_choice='insert'
            EXIT DISPLAY
        ON ACTION query                            # Q.查詢
            LET g_action_choice='query'
            EXIT DISPLAY
        ON ACTION modify                           # Q.修改
            LET g_action_choice='modify'
            EXIT DISPLAY
        ON ACTION reproduce                        # C.複製
            LET g_action_choice='reproduce'
            EXIT DISPLAY
        ON ACTION delete                           # R.取消
            LET g_action_choice='delete'
            EXIT DISPLAY
        ON ACTION detail                           # B.單身
            LET g_action_choice='detail'
            LET l_ac = ARR_CURR()
            EXIT DISPLAY
        ON ACTION ACCEPT
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DISPLAY
        ON ACTION CANCEL
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice="exit"
            EXIT DISPLAY
        #No.FUN-B80092 --start--
        ON ACTION cr_apr_act                       #報表簽核欄維護作業
            LET g_action_choice="cr_apr_act"
            EXIT DISPLAY
        #No.FUN-B80092 --end--
        ON ACTION first                            # 第一筆
            CALL p_grw_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
        ON ACTION previous                         # P.上筆
            CALL p_grw_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
        ON ACTION jump                             # 指定筆
            CALL p_grw_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
        ON ACTION next                             # N.下筆
            CALL p_grw_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
        ON ACTION last                             # 最終筆
            CALL p_grw_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(1)  ######add in 040505
            END IF
            ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
        ON ACTION help                             # H.說明
            LET g_action_choice='help'
            EXIT DISPLAY
        ON ACTION locale
            CALL cl_dynamic_locale()
#           CALL p_grw_set_combobox()              #No.FUN-760049
            CALL cl_set_combo_industry("gdw06")        #No.FUN-750068
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #CALL  gfs_gfs03(l_ac) #FUN-C30205 ADD #FUN-C30290 MARK
            IF l_ac<>0 THEN CALL gfs_gfs03(l_ac) END IF  #FUN-C30290 ADD  
            
            EXIT DISPLAY
        ON ACTION exit                             # Esc.結束
            LET g_action_choice='exit'
            EXIT DISPLAY
        ON ACTION close
            LET g_action_choice='exit'
            EXIT DISPLAY
        ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DISPLAY
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
        ON ACTION about
            CALL cl_about()
        ON ACTION exporttoexcel       #FUN-4B0049
            LET g_action_choice = 'exporttoexcel'
            EXIT DISPLAY
        #ON ACTION showlog             #MOD-440464
        #    LET g_action_choice = "showlog"
        #    EXIT DISPLAY
        # No.FUN-530067 --start--
        AFTER DISPLAY
            CONTINUE DISPLAY
      # No.FUN-530067 ---end---
        ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
        ON ACTION upload4rp
            LET g_action_choice = 'upload4rp'
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 AND NOT cl_null(g_gdw.gdw02) THEN
                   CALL p_grw_upload4rp()
                   LET INT_FLAG =0  #FUN-C30290 ADD
               END IF
            END IF

        ON ACTION replang
            LET g_action_choice = 'replang'
            IF cl_chk_act_auth() THEN
                IF l_ac > 0 AND NOT cl_null(g_gdw_b[l_ac].gdw08) THEN
                    CALL cl_cmdrun("p_replang "||g_gdw_b[l_ac].gdw08 CLIPPED)
                    LET INT_FLAG =0  #FUN-C30290 ADD
                END IF
            END IF

        ON ACTION paper
            LET g_action_choice = 'paper'
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("p_grwp")
            END IF
        #No.FUN-C30005  -START
        ON ACTION copy4rp  #4rp複製作業
            LET g_action_choice = 'copy4rp'
            #IF cl_chk_act_auth() THEN #FUN-C30290 ADD
                IF l_ac > 0  THEN  #FUN-C30290 ADD
                    LET g_gdw08_v=g_gdw_b[l_ac].gdw08
                    LET g_gdw09_v=g_gdw_b[l_ac].gdw09
                    EXIT DISPLAY
                END IF    #FUN-C30290 ADD

            #END IF    #FUN-C30290 ADD
        #No.FUN-C30005 -END
        #No.FUN-C80015 -START
        ON ACTION gcw_act
            LET g_action_choice='gcw_act'
            EXIT DISPLAY
        #No.FUN-C80015 -END

        #FUN-D10108 --- s
        ON ACTION def_template
            LET g_action_choice='def_template'
            EXIT DISPLAY
        #FUN-D10108 --- e

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
    
    CALL p_grw_apr_act()   #報表簽核欄維護作業按鈕是否有效 #No.FUN-B80092
END FUNCTION


FUNCTION p_grw_copy()
   
   DEFINE l_newno     LIKE gdw_file.gdw01
   DEFINE l_oldno     LIKE gdw_file.gdw01
   DEFINE l_gdw02     LIKE gdw_file.gdw02
   DEFINE l_gdw02_n   LIKE gdw_file.gdw02  #FUN-C30143 ADD
   DEFINE l_gdw03     LIKE gdw_file.gdw03
   DEFINE l_gdw03_n   LIKE gdw_file.gdw03 #FUN-C30143 ADD
   DEFINE l_gdw04     LIKE gdw_file.gdw04
   DEFINE l_gdw04_n   LIKE gdw_file.gdw04 #FUN-C30143 ADD
   DEFINE l_gdw05     LIKE gdw_file.gdw05 
   DEFINE l_gdw05_n   LIKE gdw_file.gdw05 #FUN-C30143 ADD
   DEFINE l_gdw06     LIKE gdw_file.gdw06
   DEFINE l_gdw06_n   LIKE gdw_file.gdw06 #FUN-C30143 ADD
   DEFINE l_gdw08     LIKE gdw_file.gdw08
   DEFINE l_gdw16     LIKE gdw_file.gdw16 #TQC-C40053 ADD
   DEFINE l_gdw16_n   LIKE gdw_file.gdw16 #TQC-C40053 ADD
   DEFINE l_gdw14     LIKE gdw_file.gdw14 #No.FUN-B80092
   DEFINE l_gdw15     LIKE gdw_file.gdw15 #No.FUN-B80092
   DEFINE l_gdw14_n   LIKE gdw_file.gdw14 #FUN-C30143 ADD
   DEFINE l_gdw15_n   LIKE gdw_file.gdw15 #FUN-C30143 ADD   
   DEFINE l_cnt       smallint
   DEFINE i           smallint
   DEFINE l_zwacti    LIKE zw_file.zwacti
   DEFINE   g_gfs         DYNAMIC ARRAY OF RECORD  #FUN-C30205 ADD
            gfs01         LIKE gfs_file.gfs01,
            gfs02         LIKE gfs_file.gfs02,
            gfs03         LIKE gfs_file.gfs03
                        END RECORD
   DEFINE lc_wc2      LIKE type_file.chr1000      #FUN-C30205 ADD
   DEFINE l_gfs_cnt   LIKE type_file.num5         #FUN-C30205 ADD
   DEFINE l_i         SMALLINT 

   IF s_shut(0) THEN RETURN END IF

   IF g_gdw.gdw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #FUN-C30143 MARK-START---
   #LET l_oldno = g_gdw.gdw01
   #LET l_gdw02 = g_gdw.gdw02
   #LET l_gdw05 = g_gdw.gdw05
   #LET l_gdw04 = g_gdw.gdw04
   #LET l_gdw06 = g_gdw.gdw06
   #LET l_gdw03 = 'N'
   #LET l_gdw14 = 'N' #No.FUN-B80092
   #LET l_gdw15 = '1' #No.FUN-B80092
   #FUN-C30143 MARK-END---
   CALL cl_set_comp_entry("gdw01,gdw02,gdw05,gdw04",TRUE)
   #INPUT l_newno,l_gdw02,l_gdw05,l_gdw04,l_gdw06,l_gdw03,l_gdw14,l_gdw15 WITHOUT DEFAULTS #No.FUN-B80092 #FUN-C30143 MARK
   INPUT l_newno,l_gdw02_n,l_gdw05_n,l_gdw04_n,l_gdw06_n,l_gdw03_n,L_gdw16_n,l_gdw14_n,l_gdw15_n WITHOUT DEFAULTS #No.FUN-B80092    #FUN-C30143 ADD #TQC-C40053 ADD l_gdw16_n
     FROM gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw16,gdw14,gdw15 #TQC-C40053 add gdw16
      #No.FUN-B80092 --start--
      BEFORE INPUT
      #FUN-C30143 ADD-START
           DISPLAY BY NAME g_gdw.gdw01,g_gdw.gdw02,g_gdw.gdw03,
                             g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06,g_gdw.gdw16,g_gdw.gdw14,g_gdw.gdw15 #FUN-C30205 ADD g_gdw.gdw14,g_gdw.gdw15 #TQC-C40053 add g_gdw.gdw16
           DISPLAY ' ' TO gaz03      
           LET l_newno = g_gdw.gdw01
           LET l_gdw02_n = g_gdw.gdw02
           LET l_gdw05_n = g_gdw.gdw05
           LET l_gdw04_n = g_gdw.gdw04
           LET l_gdw06_n = g_gdw.gdw06
           LET l_gdw03_n = g_gdw.gdw03
           LET l_gdw16_n = g_gdw.gdw16 #TQC-C40053 add
           LET l_gdw14_n = g_gdw.gdw14
           LET l_gdw15_n = g_gdw.gdw15
     
      #FUN-C30143 ADD-end
         IF NOT (g_gdw.gdw14="Y") AND  cl_null(g_gdw.gdw14) THEN 
            LET l_gdw14_n = "N"
         END IF

         IF l_gdw14_n = "Y" THEN
            CALL cl_set_comp_entry("gdw15",TRUE)
         ELSE
            CALL cl_set_comp_entry("gdw15",FALSE)
         END IF
         #DISPLAY l_gdw14_n TO gdw_file.gdw14 #FUN-C30205 MARK
      #No.FUN-B80092 --end--
	 
      AFTER FIELD gdw01
         IF NOT p_grw_chkgdw01() THEN
            LET g_gdw.gdw01 = l_newno
            CALL cl_err( l_newno,'azz-052',1)
            NEXT FIELD gdw01
         END IF        
         CALL p_gdw_desc("gdw01",l_newno)
        
      AFTER FIELD gdw02
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM gdw_file
          WHERE gdw01 = l_newno AND gdw02 = l_gdw02
            #AND gdw03 = l_gdw03 AND gdw04 = "default"  # FUN-C30005 MARK
            #AND gdw03 = 'N' AND gdw04 = "default"  # FUN-C30005 add            
            AND gdw03 = l_gdw03_n AND gdw04 = "default"  # FUN-C30005 add
            AND gdw05 = "default"
           # AND gdw06 = l_gdw06 #FUN-C30005 MARK
             AND gdw06 = 'std'   #FUN-C30005 ADD
               
         IF g_cnt = 0 THEN
            LET l_gdw04 = "default"
            CALL p_gdw_desc("gdw04",l_gdw04)
            LET l_gdw05 = "default"
            CALL p_gdw_desc("gdw05",l_gdw05)
         END IF  
        #FUN-C30143 ADD-START         
        BEFORE FIELD gdw04
            IF l_gdw04_n = 'default' THEN
               CALL cl_set_comp_entry("gdw04",TRUE)
            END IF
        #FUN-C30143 ADD-END 
        AFTER FIELD gdw04

           #FUN-C30143 MARK-START
           #IF NOT cl_null(l_gdw04) THEN
              #IF l_gdw04 <> 'default' THEN
                 #LET g_cnt = 0
                 #SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  #WHERE gdw01 = l_newno 
                    #AND gdw02 = l_gdw02                 
                    #AND gdw04 = 'default'
                    #AND gdw05 = 'default'
                    #AND gdw03 = l_gdw03  #FUN-C30005 MARK
                    #AND gdw06 = l_gdw06  #FUN-C30005 MARK
                    #AND gdw03 = 'N'       #FUN-C30005 ADD
                    #AND gdw06 = 'std'     #FUN-C30005 ADD                
                    #
                  #IF ( g_cnt = 0) THEN
                     #CALL cl_err(l_newno,'azz-086',0)                     
                     #NEXT FIELD gdw04
                  #END IF
              #END IF
                          #
              #IF l_gdw04 CLIPPED  <> 'default' THEN
               #SELECT zwacti INTO l_zwacti FROM zw_file
                #WHERE zw01 = l_gdw04
                #IF STATUS THEN
                   #CALL cl_err('select '||l_gdw04||" ",STATUS,0)
                   #NEXT FIELD gdw04
                #ELSE
                  #IF l_zwacti != "Y" THEN
                     #CALL cl_err_msg(NULL,"azz-218",l_gdw04 CLIPPED,10)
                     #NEXT FIELD gdw04               
                  #END IF
                #END IF            
              #END IF
              #CALL p_gdw_desc("gdw04",l_gdw04)
            #END IF 
             #FUN-C30143 MARK-END
            #FUN-C30143  ADD-START
                 IF cl_null(l_gdw04_n) THEN
                    NEXT FIELD gdw04
                 END IF
                 IF l_gdw04_n CLIPPED  <> 'default' THEN
                    SELECT zwacti INTO l_zwacti FROM zw_file
                     WHERE zw01 = l_gdw04_n 
                    IF STATUS THEN
                        CALL cl_err('select '||l_gdw04_n||" ",STATUS,0)
                        NEXT FIELD gdw04
                    ELSE
                       IF l_zwacti != "Y" THEN
                          CALL cl_err_msg(NULL,"azz-218",l_gdw04_n CLIPPED,10)
                          NEXT FIELD gdw4
                       END IF
                    END IF
                 END IF
                 CALL p_gdw_desc("gdw04",l_gdw04_n)
                 IF l_gdw04_n = 'default' THEN
                    IF l_gdw05_n <> 'default' THEN
                       CALL cl_set_comp_entry("gdw05",TRUE)
                       CALL cl_set_comp_entry("gdw04",FALSE)
                    ELSE
                       CALL cl_set_comp_entry("gdw04",TRUE)
                       CALL cl_set_comp_entry("gdw05",TRUE)
                    END IF
                 ELSE
        #            IF l_newfe4 = 'default' THEN   #No.TQC-960067 mark
                    IF l_gdw05_n = 'default' THEN    #No.TQC-960067 mod
                       CALL cl_set_comp_entry("gdw04",TRUE)
                       CALL cl_set_comp_entry("gdw05",FALSE)
                    END IF
                 END IF
            #FUN-C30143  ADD-END

        BEFORE FIELD gdw05
             IF l_gdw05_n = 'default' THEN
                CALL cl_set_comp_entry("gdw05",TRUE)
             END IF
            
        AFTER FIELD gdw05
          #FUN-C30143  MARK-START
           #IF l_gdw05 <> 'default' THEN
              #LET g_cnt = 0
              #SELECT COUNT(*) INTO g_cnt FROM gdw_file
               #WHERE gdw01 = l_newno
                 #AND gdw02 = l_gdw02
                 #AND gdw03 = l_gdw03  #FUN-C30005 MARK
                 #AND gdw03 = 'N'   #FUN-C30005 ADD
                 #AND gdw04 = 'default'
                 #AND gdw05 = 'default'
                 #AND gdw06 = l_gdw06 #FUN-C30005 MARK
                 #AND gdw06 = 'std'    #FUN-C30005 ADD
                 #
               #IF ( g_cnt = 0) THEN
                  #CALL cl_err(l_newno,'azz-086',0)                     
                  #NEXT FIELD gdw05
               #END IF
           #END IF
           #
           #IF l_gdw05 <> 'default' THEN    
              #SELECT COUNT(*) INTO g_cnt FROM zx_file
               #WHERE zx01 = l_gdw05
                 #
               #IF g_cnt = 0 THEN
                  #CALL cl_err( l_gdw05,'mfg1312',0)
                  #NEXT FIELD gdw05
               #END IF
            #END IF   
            #CALL p_gdw_desc("gdw05",l_gdw05)      
            #FUN-C30143 MARK-END
            #FUN-C30143 ADD-START
             IF cl_null(l_gdw05_n) THEN
                NEXT FIELD gdw05
             END IF
             IF l_gdw05_n CLIPPED  <>'default' THEN
                SELECT COUNT(*) INTO g_cnt FROM zx_file
                 WHERE zx01 = l_gdw05_n 
                IF g_cnt = 0 THEN
                    CALL cl_err(l_gdw05_n,'mfg1312',0)
                    NEXT FIELD gdw05
                END IF
             END IF
             CALL p_gdw_desc("gdw05",l_gdw05_n)
             IF l_gdw05_n = 'default' THEN
                IF l_gdw04_n <> 'default' THEN
                   CALL cl_set_comp_entry("gdw04",TRUE)
                   CALL cl_set_comp_entry("gdw05",FALSE)
                ELSE
                   CALL cl_set_comp_entry("gdw04",TRUE)
                   CALL cl_set_comp_entry("gdw05",TRUE)
                END IF
             ELSE
                IF l_gdw04_n = 'default' THEN
                   CALL cl_set_comp_entry("gdw05",TRUE)
                   CALL cl_set_comp_entry("gdw04",FALSE)
                END IF
             END IF     
            #FUN-C30143 ADD-END       
        #No.FUN-B80092 --start--
        ON CHANGE gdw03
            IF NOT cl_null(g_gdw.gdw03) THEN
              IF g_gdw.gdw03="N" THEN
                LET l_gdw03_n="Y"
              ELSE
                LET l_gdw03_n="N"
              END IF 
            END IF 
        ON CHANGE gdw14
           #FUN-C30143  MARK-START--
            #IF cl_null(l_gdw14) THEN
                #LET l_gdw14 = "N"
            #END IF
            #IF l_gdw14 = "Y" THEN
                #CALL cl_set_comp_entry("gdw15",TRUE)
                #CALL cl_set_comp_required("gdw15", TRUE)  #預設為必填欄位
                #IF cl_null(l_gdw15) THEN
                    #LET l_gdw15 = "1" 
                #END IF
            #FUN-C30143 MARK-END
            #FUN-C30143 ADD-START
            IF not(l_gdw14_n="Y") THEN
                LET l_gdw14_n = "N"
            END IF
            IF l_gdw14_n = "Y" THEN
                CALL cl_set_comp_entry("gdw15",TRUE)
                CALL cl_set_comp_required("gdw15", TRUE)  #預設為必填欄位
                IF cl_null(l_gdw15_n) THEN
                    LET l_gdw15_n = "1" 
                END IF
            
            #FUN-C30143 ADD-END
            ELSE
            
                CALL cl_set_comp_entry("gdw15",FALSE)
                CALL cl_set_comp_required("gdw15", FALSE) #預設為非必填欄位
            END IF
      
        BEFORE FIELD gdw15
            #FUN-C30143  MARK-START----
            #IF cl_null(l_gdw14) THEN
                #LET l_gdw14 = "N"
            #END IF
            #IF l_gdw14="Y" THEN
                #CALL cl_set_comp_entry("gdw15",TRUE)
                #CALL cl_set_comp_required("gdw15", TRUE)  #預設為必填欄位
                #IF cl_null(l_gdw15) THEN
                    #LET l_gdw15 = "1" 
                #END IF
            #FUN-C30143  MARK-END---- 
            #FUN-C30143  ADD START--
             IF cl_null(l_gdw14_n) THEN
                LET l_gdw14_n = "N"
            END IF
            IF l_gdw14_n="Y" THEN
                CALL cl_set_comp_entry("gdw15",TRUE)
                CALL cl_set_comp_required("gdw15", TRUE)  #預設為必填欄位
                IF cl_null(l_gdw15_n) THEN
                    LET l_gdw15_n = "1" 
                END IF           
            #FUN-C30143  ADD END ---            
            ELSE
                CALL cl_set_comp_entry("gdw15",FALSE)
                CALL cl_set_comp_required("gdw15", FALSE) #預設為非必填欄位
            END IF
        #No.FUN-B80092 --end--
        
        AFTER INPUT   
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF                  
           
           IF NOT cl_null(l_newno) THEN
              #FUN-C30143  MARK-START
              #IF l_gdw04 <> 'default' OR l_gdw05 <> 'default'THEN
                 #LET g_cnt = 0
                 #SELECT COUNT(*) INTO g_cnt FROM gdw_file
                  #WHERE gdw01 = l_newno AND gdw02 = l_gdw02
                    #AND gdw03 = l_gdw03  #FUN-C30005 MARK
                    #AND gdw03 = 'N'   #FUN-C30005 ADD
                    #AND gdw04 = 'default' AND gdw05 = 'default'
                    #AND gdw06 = l_gdw06 #FUN-C30005 MARK
                    #AND gdw06 = 'std'    #FUN-C30005 ADD
                  #IF ( g_cnt = 0) THEN
                     #CALL cl_err(l_newno,'azz-086',0)                     
                     #NEXT FIELD gdw01
                 #END IF 
              #END IF                
              #FUN-C30143 MARK-END
              #FUN-C30143  ADD -START----
                 IF l_gdw04_n <> 'default' OR l_gdw05_n <> 'default'THEN
                     LET g_cnt = 0
                     SELECT COUNT(*) INTO g_cnt FROM gdw_file
                      WHERE gdw01 = l_newno AND gdw02 = l_gdw02_n AND gdw03 = l_gdw03_n  
                        AND gdw04 = 'default' AND gdw05 = 'default'
                        AND gdw06 = l_gdw06_n 
                      IF ( g_cnt = 0) THEN
                         CALL cl_err(l_newno,'azz-086',0)                     
                         NEXT FIELD gdw01
                     END IF 
                  END IF                
              
              #FUN-C30143  ADD  ---END -----   
              LET g_cnt = 0
              # FUN-C30143  MARK-START
              #SELECT COUNT(*) INTO g_cnt FROM gdw_file
               #WHERE gdw01 = l_newno AND gdw02 = l_gdw02
                 #AND gdw03 = l_gdw03 AND gdw04 = l_gdw04  FUN-C30005 MARK
                 #AND gdw03 = 'N' AND gdw04 = l_gdw04   #FUN-C30005 ADD
                 #AND gdw05 = l_gdw05
                # AND gdw06 = l_gdw06   #FUN-C30005 MARK
                 #AND gdw06 = l_gdw06    #FUN-C30005 ADD
              # FUN-C30143  MARK-END
              #FUN-C30143 ADD -START
               SELECT COUNT(*) INTO g_cnt FROM gdw_file
               WHERE gdw01 = l_newno AND gdw02 = l_gdw02_n
                 AND gdw03 = l_gdw03_n AND gdw04 = l_gdw04_n 
                 AND gdw05 = l_gdw05_n AND gdw06 = l_gdw06_n   
              #FUN-C30143 ADD -END
                 IF g_cnt > 0 THEN
                    CALL cl_err( '',-239,1)
                    NEXT FIELD gdw01
                 END IF                  
           END IF
                        
       ON ACTION controlp
            CASE
                WHEN INFIELD(gdw01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.arg1 = g_lang
                   LET g_qryparam.default1= l_newno
                   CALL cl_create_qry() RETURNING l_newno
                   NEXT FIELD gdw01
                                
                WHEN INFIELD(gdw04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zw"
                   #LET g_qryparam.default1 = l_gdw04       #FUN-C30143 MARK
                   #CALL cl_create_qry() RETURNING l_gdw04  #FUN-C30143 MARK
                   LET g_qryparam.default1 = l_gdw04_n      #FUN-C30143 ADD
                   CALL cl_create_qry() RETURNING l_gdw04_n #FUN-C30143 ADD                
                   NEXT FIELD gdw04

                WHEN INFIELD(gdw05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zx"
                   #LET g_qryparam.default1 = l_gdw05      #FUN-C30143 MARK
                   #CALL cl_create_qry() RETURNING l_gdw05 #FUN-C30143 MARK
                   LET g_qryparam.default1 = l_gdw05_n       #FUN-C30143 ADD
                   CALL cl_create_qry() RETURNING l_gdw05_n  #FUN-C30143 ADD                   
                   NEXT FIELD gdw05
                #FUN-C30205  ADD-START
                 #WHEN INFIELD(gdw10)
                   #CALL cl_init_qry_var()
                  # LET g_qryparam.default1 = g_gdw_bt.gdw10      
                   #LET g_cmd = "p_gr_lang '",g_gdw08_v CLIPPED,"'"               
                       #CALL cl_cmdrun(g_cmd)  
                       #CALL gfs_gfs03(l_ac)                
                   #NEXT FIELD gdw10
                #FUN-C30205  ADD-END  
                OTHERWISE
                    EXIT CASE
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
      DISPLAY l_oldno TO gdw01
      DISPLAY BY NAME g_gdw.gdw02,g_gdw.gdw03,g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06
      ROLLBACK WORK
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM gdw_file      
    WHERE gdw01 = g_gdw.gdw01 AND gdw02 = g_gdw.gdw02
      AND gdw03 = g_gdw.gdw03 AND gdw04 = g_gdw.gdw04
      AND gdw05 = g_gdw.gdw05 AND gdw06 = g_gdw.gdw06

   FOR i = 1 TO l_cnt   
       SELECT MAX(gdw08) + 1 INTO l_gdw08 FROM gdw_file
       INSERT INTO gdw_file VALUES 
             #FUN-C30143 MARK-START
             #(l_newno,l_gdw02,l_gdw03,l_gdw04,
              #l_gdw05,l_gdw06,g_gdw_b[i].gdw07,l_gdw08,
              #g_gdw_b[i].gdw09,g_gdw_b[i].gdw10,g_gdw_b[i].gdw11,
              #g_gdw_b[i].gdw12,g_gdw_b[i].gdw13,g_today,g_grup,'',
              #g_user,g_grup,g_user,l_gdw14,l_gdw15)   #No.FUN-B80092 add l_gdw14,l_gdw15
             #FUN-C30143 MARK-END

             #FUN-C30143 ADD-START 
             (l_newno,l_gdw02_n,l_gdw03_n,l_gdw04_n,
              l_gdw05_n,l_gdw06_n,g_gdw_b[i].gdw07,l_gdw08,
              #g_gdw_b[i].gdw09,g_gdw_b[i].gdw10,g_gdw_b[i].gdw11, #FUN-C30205 MARK
              g_gdw_b[i].gdw09,'N',g_gdw_b[i].gdw11,   #FUN-C30205 ADD
              g_gdw_b[i].gdw12,g_gdw_b[i].gdw13,g_today,g_grup,'',
              #g_grup,g_user,g_user,l_gdw14_n,l_gdw15_n,l_gdw16_n)   #No.FUN-B80092 add l_gdw14,l_gdw15 #TQC-C40053 add l_gdw16_n              
              g_grup,g_user,g_user,l_gdw14_n,l_gdw15_n,l_gdw16_n,'N')   #No.FUN-D10108 add gdw17 default 'N'
             #FUN-C30143 ADD-END                    
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gdw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK
         RETURN
      END IF

      #FUN-C30205 ADD-START #新增gfs_file
          LET l_gfs_cnt=0
          SELECT count(*) INTO l_gfs_cnt FROM gfs_file WHERE gfs01=l_gdw08
          IF l_gfs_cnt=0 THEN 
              LET l_gfs_cnt=0
              SELECT count(*) INTO l_gfs_cnt FROM gfs_file WHERE gfs01=g_gdw_b[i].gdw08
              IF l_gfs_cnt>0 THEN  #有值才複製
                  #抓出舊的gfs值
                  LET lc_wc2=""
                  LET lc_wc2="gfs01=",g_gdw_b[i].gdw08
                  LET g_sql = "SELECT gfs01,gfs02,gfs03",
                               "  FROM gfs_file",
                               " WHERE ",lc_wc2 CLIPPED,
                               " ORDER BY gfs01"
                   PREPARE p_gfs_pb FROM g_sql
                   DECLARE gfs_curs CURSOR FOR p_gfs_pb
                 
                   CALL g_gfs.clear()
                 
                   LET g_cnt = 1                              
                   FOREACH gfs_curs INTO g_gfs[g_cnt].*                      
                      IF STATUS THEN
                         CALL cl_err('FOREACH gfs:',STATUS,1)
                         EXIT FOREACH
                      END IF
                      LET g_cnt = g_cnt + 1
                   END FOREACH
                   CALL g_gfs.deleteElement(g_cnt)
                   FOR l_i= 1 TO g_cnt 
                     INSERT INTO gfs_file VALUES (l_gdw08,g_gfs[l_i].gfs02,g_gfs[l_i].gfs03)
                   END  FOR 
              END IF   #IF l_gfs_cnt>0 THEN 第二個
          END IF  
      #FUN-C30205 ADD-END

      
   END FOR
   COMMIT WORK

   SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw16,gdw14,gdw15 #No.FUN-B80092 add l_gdw14,l_gdw15 #TQC-C40053 add gdw16
     INTO g_gdw.* FROM gdw_file
    #FUN-C30143 MARK-START 
    #WHERE gdw01 = l_newno AND gdw02 = l_gdw02
      #AND gdw03 = l_gdw03 AND gdw04 = l_gdw04
      #AND gdw05 = l_gdw05 AND gdw06 = l_gdw06 
    #FUN-C30143 MARK-START 
   #FUN-C30143 ADD-START 
    WHERE gdw01 = l_newno AND gdw02 = l_gdw02_n
      AND gdw03 = l_gdw03_n AND gdw04 = l_gdw04_n
      AND gdw05 = l_gdw05_n AND gdw06 = l_gdw06_n

   #FUN-C30143 ADD-END
     
   CALL p_grw_b()
   CALL p_grw_show()
END FUNCTION

#檢查程式代號是否重覆
FUNCTION p_grw_chkgdw01()
    DEFINE  li_cnt      LIKE type_file.num5
    DEFINE  li_cnt2     LIKE type_file.num5
    DEFINE  li_pos      LIKE type_file.num10
    DEFINE  li_flag     LIKE type_file.num5
    DEFINE  ls_str      STRING
    DEFINE  lc_gdw01    LIKE gdw_file.gdw01
    DEFINE  lc_zz08     LIKE zz_file.zz08

    LET li_flag = FALSE
    LET lc_zz08 = "%",g_gdw.gdw01 CLIPPED,"%"

    SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz08 LIKE lc_zz08

    SELECT COUNT(*) INTO g_cnt from zz_file where zz01= g_gdw.gdw01

    IF li_cnt > 0 THEN
        SELECT COUNT(*) INTO li_cnt2 FROM gak_file WHERE gak01 = g_gdw.gdw01
        IF li_cnt2 > 0 THEN
            LET li_flag = TRUE
        END IF
    ELSE
        IF li_cnt = 0 AND g_cnt = 0 THEN
            LET li_flag = FALSE
        ELSE
            SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01 = g_gdw.gdw01
            LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
            LET li_cnt = ls_str.getIndexOf("i/",1)
            LET li_pos = ls_str.getIndexOf(" ",li_cnt)
            IF li_pos <= li_cnt THEN LET li_pos = ls_str.getLength() END IF
            LET lc_gdw01 = ls_str.subString(li_cnt + 2, li_pos)
            CALL cl_err_msg(NULL,"azz-060",g_gdw.gdw01 CLIPPED|| "|" || lc_gdw01 CLIPPED,10)
            LET g_gdw.gdw01 = lc_gdw01 CLIPPED
            LET li_flag = TRUE
            DISPLAY g_gdw.gdw01 TO gdw01
        END IF
    END IF
    RETURN li_flag
END FUNCTION

FUNCTION p_gdw_desc(l_column,l_value)
    DEFINE  l_column    STRING,
            l_value     LIKE type_file.chr10

    CASE l_column
        WHEN "gdw01"
            SELECT gaz03 INTO g_gaz03 FROM gaz_file
             WHERE gaz01 = l_value AND gaz02 = g_lang
            IF SQLCA.SQLCODE THEN
                LET g_gaz03 = ""
            END IF
            DISPLAY g_gaz03 TO gaz03
        WHEN "gdw04"
            SELECT zw02 INTO g_zw02 FROM zw_file
             WHERE zw01 = l_value
            IF SQLCA.SQLCODE THEN
                LET g_zw02 = ""
            END IF
            IF l_value = "default" THEN
                LET g_zw02 = "default"
            END IF
            DISPLAY g_zw02 TO zw02
        WHEN "gdw05"
            SELECT zx02 INTO g_zx02 FROM zx_file
             WHERE zx01 = l_value
            IF SQLCA.SQLCODE THEN
                LET g_zx02 = ""
            END IF
            IF l_value = "default" THEN
                LET g_zx02 = "default"
            END IF
            DISPLAY g_zx02 TO zx02
   END CASE
END FUNCTION

#上傳4rp
FUNCTION p_grw_upload4rp()
   DEFINE ls_upload  STRING
   DEFINE li_cnt    LIKE type_file.num5
   DEFINE lc_zz011  LIKE zz_file.zz011
   DEFINE ls_path,ls_doc_path   STRING
   DEFINE ls_upload_file        STRING
   DEFINE ls_filelist           STRING
   DEFINE ls_dir                STRING
   DEFINE l_upname              STRING
   DEFINE l_result              BOOLEAN
   DEFINE l_rep                 LIKE type_file.chr1 #FUN-C50046
   DEFINE l_chk_err_msg        STRING   #FUN-C50046 #錯誤或警告訊息  
   DEFINE l_strong_err         INTEGER  #FUN-C50046 #強制錯誤訊息數  
   
    OPEN WINDOW p_grw_upload WITH FORM "azz/42f/p_grw_upload"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)

    CALL cl_ui_locale("p_grw_upload")


    #NO.TQC-BC0014 --start--
    #DISPLAY BY NAME g_gdw.*
    DISPLAY BY NAME g_gdw.gdw01, g_gdw.gdw02, g_gdw.gdw05, g_gdw.gdw04,
                    g_gdw.gdw06, g_gdw.gdw03
    #NO.TQC-BC0014 --end--

    DISPLAY BY NAME g_gdw_b[l_ac].gdw09
    CALL p_gdw_desc("gdw01",g_gdw.gdw01)
    CALL p_gdw_desc("gdw04",g_gdw.gdw04)
    CALL p_gdw_desc("gdw05",g_gdw.gdw05)
    CALL cl_set_combo_industry("gdw06")

    LET l_rep=1 #FUN-C50046 add
    
    INPUT ls_upload,l_rep WITHOUT DEFAULTS FROM upload,rep #FUN-C50046 add l_rep,rep
       ATTRIBUTES(UNBUFFERED=TRUE)
       #FUN-C50046 add-s
       ON CHANGE rep
          DISPLAY "rep:",l_rep
          IF cl_null(l_rep) OR  l_rep NOT MATCHES '[12]' THEN
             NEXT FIELD rep
          END IF 
       #FUN-C50046 add-e
      ON ACTION file_browse
         CALL cl_browse_file() RETURNING ls_doc_path
         IF ls_doc_path.getIndexOf(".4rp",2) > 0 THEN
            SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01= g_gdw.gdw01
            LET ls_upload_file = g_gdw.gdw02 CLIPPED,".4rp"
         ELSE
            CALL cl_err("Info:上傳檔案不是.4rp","!",1)
         END IF

         LET ls_dir  = os.Path.join(os.Path.join(FGL_GETENV(lc_zz011),"4rp"),"src")
         IF NOT os.Path.exists(ls_dir) THEN
            IF os.Path.mkdir(ls_dir) THEN     #make dir
               DISPLAY "make dir:",ls_dir
            END IF
         END IF
         
         LET ls_path = os.Path.join(ls_dir,ls_upload_file.trim())
         LET ls_upload = ls_doc_path

       ON ACTION file_upload
          IF cl_null(ls_upload) THEN CONTINUE INPUT END IF


          #去掉檔案目錄
          LET l_upname = os.Path.basename(ls_upload)
          #取得主檔名
          LET l_upname = os.Path.rootname(l_upname)
 
          LET l_result = FALSE
          #從單身中去尋找符合的樣版名稱
          FOR li_cnt = 1 TO g_gdw_b.getLength()
              IF l_upname == g_gdw_b[li_cnt].gdw09 THEN
                 LET l_result = TRUE
                 EXIT FOR
              END IF
          END FOR

          #舊檔路徑
          LET ls_path = os.Path.join(ls_dir, os.Path.basename(ls_upload))
          IF l_result THEN  
             #FUN-CB0063 121115 by stellar ----(S)
             #CALL p_grw_compare(ls_dir, ls_upload)
             # #FUN-C50046 -add---start
             #IF l_rep ="1" THEN  #標準報表才檢查
             #   #120611國羽:在grw此段上傳是src，不用檢查字體，所以傳S
             #   CALL p_replang_chk_grule(ls_path,g_gdw08_v,"S") RETURNING l_strong_err,l_chk_err_msg #GR檢查機制
             #    IF l_strong_err>0 THEN 
             #     #顯示檢查命名規則的錯誤訊息
             #     IF l_chk_err_msg IS NOT NULL THEN
             #        CALL cl_err(l_chk_err_msg,"!",-1)
             #        EXIT INPUT 
             #     END IF     
             #    END IF      
             #END IF 
             ##FUN-C50046 -add---end    
             LET g_gdw08_v= g_gdw_b[l_ac].gdw08       #FUN-CC0005 add 
             CALL s_gr_upload(ls_dir, ls_upload, g_gdw08_v, "S", l_rep) 
             #FUN-CB0063 121115 by stellar ----(E)
             EXIT INPUT
          ELSE
             CALL cl_err("", "azz1081", 1)
          END IF

########   mark by tommas ##############
#      ON ACTION file_upload
#         IF os.Path.exists(ls_path) THEN
#            #CALL cl_err("Error:該樣板已存在相同檔案!","!",1)   #mark by tommas 2011/02/16
#            #RETURN                       
#            #檔案存在時，進行新舊檔的比對  add by tommas 2011/02/16
#            CALL p_grw_compare(ls_dir,ls_doc_path)
#            EXIT INPUT
#         ELSE
#            IF cl_upload_file(ls_doc_path, ls_path) THEN
#               CALL cl_err("Info:上傳檔案成功","!",1)
#            END IF
#         END IF
#########################################

      ON ACTION cancel
         EXIT INPUT

    END INPUT

   CLOSE WINDOW p_grw_upload

END FUNCTION

#FUN-CB0063 121115 by stellar mark----(S)
#改用s_gr_upload.4gl，故此function用不到了
##開始進行新舊檔案比對  add by tommas 2011/02/16
#FUNCTION p_grw_compare(ps_dir, p_path)
#  DEFINE ps_dir      STRING,
#         p_path      STRING
#  DEFINE l_ori_file  STRING
#  DEFINE l_new_path  STRING
#  DEFINE l_tmp_dir   STRING
#  DEFINE l_str       STRING
#  DEFINE l_now_str   STRING
#  DEFINE l_cmd       STRING
#  DEFINE l_result    BOOLEAN
#  DEFINE l_gdw08     LIKE gdw_file.gdw08
#  DEFINE l_gdw09     LIKE gdw_file.gdw09
#  DEFINE l_basename  STRING
#  DEFINE l_i         INTEGER
#
#  LET l_basename = os.Path.basename(p_path)
#  LET l_ori_file = os.Path.join(ps_dir, l_basename)
#  LET l_gdw09 = os.Path.rootname(l_basename)
#
#  LET l_now_str = CURRENT
#  LET l_now_str = cl_replace_str(l_now_str, "-", "")
#  LET l_now_str = cl_replace_str(l_now_str, " ", "")
#  LET l_now_str = cl_replace_str(l_now_str, ":", "")
#  LET l_now_str = cl_replace_str(l_now_str, ".", "")
#  LET l_str = g_prog CLIPPED, "_", g_user CLIPPED, "_", l_now_str CLIPPED, ".4rp"
#  
#  #FUN-C20112 --start--
#  #LET l_new_path = FGL_GETENV("TEMPDIR"), "/", l_str
#  LET l_new_path = l_ori_file CLIPPED,".",l_now_str
#  IF os.Path.copy(l_ori_file, l_new_path) THEN END IF   #備份舊檔
#  
#  #如果檔案上傳成功，開始比對
#  #IF cl_upload_file(p_path, l_new_path) THEN  #FUN-C20112 mark
#  IF cl_upload_file(p_path, l_ori_file) THEN   #上傳新檔
#
#     #FUN-C20112 mark --start--
#     #改成666的權限
#     #IF NOT os.Path.chrwx(l_new_path, "438") THEN
#        #DISPLAY "無法更改權限:",l_new_path
#     #END IF
#     #檢查紙張格式
#
#     #IF NOT s_gr_diff_rep_chk_paper_size(l_new_path) THEN
#        #CALL cl_err("Info:取消上傳","!",1)
#        #CALL os.Path.delete(l_new_path) RETURNING l_result
#        #RETURN
#     #END IF
#     #FUN-C20112 mark --end--
#
#     LET l_cmd = "p_updml4rp '",l_ori_file CLIPPED,"' '",g_gdw_b[l_ac].gdw08 CLIPPED,"'"
#     DISPLAY "cmd: ",l_cmd
#     CALL cl_cmdrun_wait(l_cmd)  #FUN-C30205 ADD
#      #CALL cl_cmdrun(l_cmd)     #FUN-C30205  MARK
#     #FUN-C20112 mark --start--
#     #LET l_result = FALSE
#     #當使用者確認新檔案調整後無誤時，將舊檔備份，並使用新檔將舊檔覆蓋，再重新rescan
#     #IF os.Path.exists(l_ori_file) THEN
#        #IF s_gr_diff_rep(l_ori_file, l_new_path, g_gdw.gdw01, g_gdw.gdw02) THEN  
#          #將舊檔備份
#          #CALL os.Path.copy(l_ori_file, l_ori_file || "." || l_now_str) RETURNING l_result
#          #刪除舊檔
#          #CALL os.Path.delete(l_ori_file) RETURNING l_result
#          #暫存檔copy到舊檔
#          #CALL os.Path.copy(l_new_path, l_ori_file) RETURNING l_result
#          #刪除暫存檔
#          #CALL os.Path.delete(l_new_path) RETURNING l_result
#        #ELSE
#          #LET l_result = FALSE
#        #END IF
#     #ELSE
#        #CALL os.Path.copy(l_new_path, l_ori_file) RETURNING l_result
#     #END IF
#     
#     #IF l_result THEN 
#        #CALL cl_err("Info:上傳檔案成功", "!", 1)
#        #SELECT gdw08 INTO l_gdw08 FROM gdw_file WHERE gdw01 = g_gdw.gdw01
#        #LET l_cmd = "p_replang ", l_gdw08, " 0"
#        #CALL cl_cmdrun_wait(l_cmd)
#     #ELSE
#        #CALL cl_err("Info:檔案上傳失敗", "!", 1)
#     #END IF
#     #FUN-C20112 mark --end--
#     #FUN-C20112 --end--
#  END IF
#
#END FUNCTION
#FUN-CB0063 121115 by stellar mark----(E)

FUNCTION p_grw_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
   IF INFIELD(gdw05) THEN
      IF g_gdw.gdw05 = 'default' THEN
         CALL cl_set_comp_entry("gdw05",TRUE)
      END IF
   END IF
   
   IF INFIELD(gdw04) THEN
      IF g_gdw.gdw04 = 'default' THEN
         CALL cl_set_comp_entry("gdw04",TRUE)
      END IF
   END IF
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gdw01",TRUE)   
   END IF
END FUNCTION

FUNCTION p_grw_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
   

  #FUN-C30143-ADD STRART
   IF INFIELD(gdw05) THEN
      IF p_cmd = 'u' THEN
         IF g_gdw.gdw05 = 'default' THEN
            IF g_gdw.gdw04 <> 'default' THEN
               CALL cl_set_comp_entry("gdw04",TRUE)
               CALL cl_set_comp_entry("gdw05",FALSE)
            ELSE
               CALL cl_set_comp_entry("gdw04",TRUE)
               CALL cl_set_comp_entry("gdw05",TRUE)
            END IF
         ELSE
            IF g_gdw.gdw04 = 'default' THEN
               CALL cl_set_comp_entry("gdw05",TRUE)
               CALL cl_set_comp_entry("gdw04",FALSE)
            END IF
         END IF
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_gdw.gdw05) AND g_gdw.gdw05 <> 'default' THEN
               LET g_gdw.gdw04 = 'default'
               CALL cl_set_comp_entry("gdw04",FALSE)
            END IF
         END IF
      END IF
   END IF
 
   IF INFIELD(gdw04) THEN
      IF p_cmd = 'u' THEN
         IF g_gdw.gdw04 = 'default' THEN
            IF g_gdw.gdw05 <> 'default' THEN
               CALL cl_set_comp_entry("gdw05",TRUE)
               CALL cl_set_comp_entry("gdw04",FALSE)
            ELSE
               CALL cl_set_comp_entry("gdw04",TRUE)
               CALL cl_set_comp_entry("gdw05",TRUE)
            END IF
         ELSE
            IF g_gdw.gdw05 = 'default' THEN
               CALL cl_set_comp_entry("gdw04",TRUE)
               CALL cl_set_comp_entry("gdw05",FALSE)
            END IF
         END IF
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_gdw.gdw04) AND g_gdw.gdw04 <> 'default' THEN
               LET g_gdw.gdw05 = 'default'
               CALL cl_set_comp_entry("gdw05",FALSE)
            END IF
         END IF
      END IF
   END IF
  #FUN-C30143-ADD END
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gdw01",FALSE)
   END IF
END FUNCTION

#No.FUN-B80092 --start--
FUNCTION p_grw_apr_act()   #報表簽核欄維護作業按鈕是否有效
   DEFINE l_sys_apr         STRING                 #p_cr_apr可接受的模組
   DEFINE l_tok             base.StringTokenizer
   DEFINE l_tmp             STRING
   DEFINE l_c               STRING                 #標準客製模組  #FUN-A50047
   DEFINE l_g               STRING                 #大陸模組     #FUN-A50047
   DEFINE l_cg              STRING                 #大陸客製模組  #FUN-A50047
      
   LET g_open_cr_apr = "N"   #是否要開視窗p_cr_apr
   CALL cl_set_act_visible("cr_apr_act", FALSE)
   
   IF cl_null(g_gdw.gdw01) OR cl_null(g_gdw.gdw02) OR cl_null(g_gdw.gdw03) 
      OR cl_null(g_gdw.gdw04) OR cl_null(g_gdw.gdw05) OR cl_null(g_gdw.gdw06) 
   THEN       
      RETURN 
   END IF
   
   #模組  
   SELECT zz011 INTO g_zz011 FROM zz_file WHERE zz01=g_gdw.gdw01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","zz_file",g_gdw.gdw01,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF
 
   LET l_sys_apr = "AAP,ABX,ACO,AFA,ANM,APY,ARM,ABM,AIM,APM,ASF,AEM,ASR,AQC,AXM,AXR,AXS,AGL"   #可接受的模組：p_zaw、p_cr_apr設定值相同
                   #"CAP,CBX,CCO,CFA,CNM,CPY,CRM,CBM,CIM,CPM,CSF,CEM,CSR,CQC,CXM,CXR,CXS,CGL"  #FUN-970066 加入客製模組   #FUN-A50047 mark
   LET l_tok = base.StringTokenizer.createExt(l_sys_apr CLIPPED,",","",TRUE)	#指定分隔符號
   WHILE l_tok.hasMoreTokens()	#依序取得子字串
      LET l_tmp = l_tok.nextToken()
      LET l_tmp = l_tmp.trim()
      LET l_c = "C",l_tmp.substring(2,l_tmp.getlength())  #FUN-A50047
      LET l_g = "G",l_tmp.substring(2,l_tmp.getlength())  #FUN-A50047
      LET l_cg = "C",l_g                                  #FUN-A50047

      IF g_zz011 = l_tmp OR g_zz011 = l_c 
        OR g_zz011 = l_g OR g_zz011 = l_cg THEN           #FUN-A50047
         LET g_open_cr_apr = "Y"
      END IF
   END WHILE
     
   #顯示按鈕 
   IF g_open_cr_apr = "Y" THEN
      CALL cl_set_act_visible("cr_apr_act", TRUE)
   END IF
END FUNCTION
#No.FUN-B80092 --end--

#FUN-C30205   ADD-START
FUNCTION gfs_gfs03(p_ac)
   DEFINE   p_ac   SMALLINT
   #DISPLAY "" TO gdw_file[p_ac].gdw10
   SELECT gfs03 INTO g_gdw_b[p_ac].gfs03
     FROM gfs_file WHERE gfs01 = g_gdw_b[p_ac].gdw08 AND gfs02=g_lang
   IF SQLCA.SQLCODE=100 THEN
      LET g_gdw_b[p_ac].gfs03=" "
      #DISPLAY " " TO gdw_file[p_ac].gdw10
   ELSE 
      DISPLAY g_gdw_b[p_ac].gfs03 TO gfs03[p_ac]
   END IF
 
   #DISPLAY g_gdw_b[p_ac].gdw10 TO gdw_file[p_ac].gdw10

END FUNCTION
#FUN-C30205   ADD-END 

#FUN-C80015   ADD-START
FUNCTION p_grw_gcw()
   DEFINE ls_tmp           STRING
   DEFINE l_i,l_x,l_y      LIKE type_file.num5
   DEFINE l_gcw   RECORD
             gcw01         LIKE gcw_file.gcw01,      #程式代號
             gcw02         LIKE gcw_file.gcw02,      #樣板代號
             gcw03         LIKE gcw_file.gcw03,      #權限類別
             gcw04         LIKE gcw_file.gcw04,      #使用者
             gcw05         LIKE gcw_file.gcw05,      #報表檔案命名第一段
             gcw06         LIKE gcw_file.gcw06,      #報表檔案命名第二段
             gcw07         LIKE gcw_file.gcw07,      #報表檔案命名第三段
             gcw08         LIKE gcw_file.gcw08,      #報表檔案命名第四段
             gcw09         LIKE gcw_file.gcw09,      #報表檔案命名第五段
             gcw10         LIKE gcw_file.gcw10,      #報表檔案命名第六段
             gcw11         LIKE gcw_file.gcw11,      #重複時覆寫
             gcw12         LIKE gcw_file.gcw12       #行業別
             END RECORD

   IF cl_null(g_gdw.gdw01) or cl_null(g_gdw.gdw02) or cl_null(g_gdw.gdw03) or cl_null(g_gdw.gdw04) or cl_null(g_gdw.gdw06) THEN
      RETURN
   END IF

   OPEN WINDOW p_grw_gcw_w AT 10,03 WITH FORM "azz/42f/p_grw_gcw"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("p_grw_gcw")

   CALL cl_set_comp_entry("gcw11",TRUE)
   CALL cl_set_combo_industry("gdw06")   #行業別

   WHILE TRUE
      DECLARE p_grw_gcw_c CURSOR FOR
           SELECT gcw01,gcw02,gcw03,gcw04,gcw05,gcw06,gcw07,gcw08,gcw09,gcw10,gcw11,gcw12 
             FROM gcw_file
            WHERE gcw01 = g_gdw.gdw01 
              AND gcw02 = g_gdw.gdw02 
              AND gcw03 = g_gdw.gdw04 
              AND gcw04 = g_gdw.gdw05 
              AND gcw12 = g_gdw.gdw06

      LET l_i = 0
      FOREACH p_grw_gcw_c INTO l_gcw.*
         LET l_i = l_i + 1
      END FOREACH

      IF l_i = 0 THEN
         LET l_gcw.gcw11 = "Y"
      END IF

      DISPLAY g_gdw.gdw01,g_gdw.gdw02,g_gdw.gdw04,g_gdw.gdw05,g_gdw.gdw06,l_gcw.gcw11,g_gaz03,g_zx02,g_zw02
         TO gdw01,gdw02,gdw04,gdw05,gdw06,gcw11,gaz03,zx02,zw02

      INPUT BY NAME l_gcw.gcw05,l_gcw.gcw06,l_gcw.gcw07,l_gcw.gcw08,l_gcw.gcw09,l_gcw.gcw10,l_gcw.gcw11 WITHOUT DEFAULTS
         ON CHANGE gcw05
            #檢查檔名段落是否重覆
            IF l_gcw.gcw05=l_gcw.gcw06 OR l_gcw.gcw05=l_gcw.gcw07 OR l_gcw.gcw05=l_gcw.gcw08 OR l_gcw.gcw05=l_gcw.gcw09 OR l_gcw.gcw05=l_gcw.gcw10 THEN
              CALL cl_err('1','azz1000',1)
            END IF

         ON CHANGE gcw06
            #檢查檔名段落是否重覆
            IF l_gcw.gcw06=l_gcw.gcw05 OR l_gcw.gcw06=l_gcw.gcw07 OR l_gcw.gcw06=l_gcw.gcw08 OR l_gcw.gcw06=l_gcw.gcw09 OR l_gcw.gcw06=l_gcw.gcw10 THEN
              CALL cl_err('2','azz1000',1)
            END IF

         ON CHANGE gcw07
            #檢查檔名段落是否重覆
            IF l_gcw.gcw07=l_gcw.gcw05 OR l_gcw.gcw07=l_gcw.gcw06 OR l_gcw.gcw07=l_gcw.gcw08 OR l_gcw.gcw07=l_gcw.gcw09 OR l_gcw.gcw07=l_gcw.gcw10 THEN
              CALL cl_err('3','azz1000',1)
            END IF
            
         ON CHANGE gcw08
            #檢查檔名段落是否重覆
            IF l_gcw.gcw08=l_gcw.gcw05 OR l_gcw.gcw08=l_gcw.gcw06 OR l_gcw.gcw08=l_gcw.gcw07 OR l_gcw.gcw08=l_gcw.gcw09 OR l_gcw.gcw08=l_gcw.gcw10 THEN
              CALL cl_err('4','azz1000',1)
            END IF

         ON CHANGE gcw09
            #檢查檔名段落是否重覆
            IF l_gcw.gcw09=l_gcw.gcw05 OR l_gcw.gcw09=l_gcw.gcw06 OR l_gcw.gcw09=l_gcw.gcw07 OR l_gcw.gcw09=l_gcw.gcw08 OR l_gcw.gcw09=l_gcw.gcw10 THEN
              CALL cl_err('5','azz1000',1)
            END IF

         ON CHANGE gcw10
            #檢查檔名段落是否重覆
            IF l_gcw.gcw10=l_gcw.gcw05 OR l_gcw.gcw10=l_gcw.gcw06 OR l_gcw.gcw10=l_gcw.gcw07 OR l_gcw.gcw10=l_gcw.gcw08 OR l_gcw.gcw10=l_gcw.gcw09 THEN
              CALL cl_err('6','azz1000',1)
            END IF

      END INPUT

      IF cl_null(l_gcw.gcw11) THEN
         LET l_gcw.gcw11 = "N"
      END IF
      
      IF INT_FLAG THEN   #按"取消"
         LET INT_FLAG = 0
         CLOSE WINDOW p_grw_gcw_w
         RETURN
      ELSE

         #新增
         IF l_i = 0 THEN
            #設主鍵與zaw相同
            LET l_gcw.gcw01 = g_gdw.gdw01   #程式代號
            LET l_gcw.gcw02 = g_gdw.gdw02   #樣板代號
            LET l_gcw.gcw03 = g_gdw.gdw04   #權限類別
            LET l_gcw.gcw04 = g_gdw.gdw05   #使用者
            LET l_gcw.gcw12 = g_gdw.gdw06   #行業別

            INSERT INTO gcw_file (gcw01,gcw02,gcw03,gcw04,gcw05,gcw06,gcw07,gcw08,gcw09,gcw10,gcw11,gcw12)
               VALUES (l_gcw.gcw01,l_gcw.gcw02,l_gcw.gcw03,l_gcw.gcw04,l_gcw.gcw05,l_gcw.gcw06,l_gcw.gcw07,l_gcw.gcw08,l_gcw.gcw09,l_gcw.gcw10,l_gcw.gcw11,l_gcw.gcw12)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gcw_file",l_gcw.gcw01,l_gcw.gcw02,SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
         END IF
         
         #修改
         IF l_i > 0 THEN
            UPDATE gcw_file
               SET gcw05 = l_gcw.gcw05,
                   gcw06 = l_gcw.gcw06,
                   gcw07 = l_gcw.gcw07,
                   gcw08 = l_gcw.gcw08,
                   gcw09 = l_gcw.gcw09,
                   gcw10 = l_gcw.gcw10,
                   gcw11 = l_gcw.gcw11
               WHERE gcw01 = l_gcw.gcw01 
                 AND gcw02 = l_gcw.gcw02 
                 AND gcw03 = l_gcw.gcw03 
                 AND gcw04 = l_gcw.gcw04 
                 AND gcw12 = l_gcw.gcw12

            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gcw_file",l_gcw.gcw01,l_gcw.gcw02,SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
         END IF

      END IF
      EXIT WHILE
   END WHILE

   CLOSE WINDOW p_grw_gcw_w
   RETURN
END FUNCTION

FUNCTION p_grw_gcw_act ()
   #有資料才顯示"CR報表檔名設定"按鈕
   IF (NOT cl_null(g_gdw.gdw01)) AND (NOT cl_null(g_gdw.gdw02)) AND (NOT cl_null(g_gdw.gdw04)) AND (NOT cl_null(g_gdw.gdw05)) AND (NOT cl_null(g_gdw.gdw06)) THEN
      CALL cl_set_act_visible("gcw_act", TRUE)
         ELSE
      CALL cl_set_act_visible("gcw_act", FALSE)
   END IF
END FUNCTION

FUNCTION p_grw_filename_show()
   DEFINE l_gcw   RECORD   LIKE gcw_file.*
   DEFINE l_filename       STRING               #報表檔名設定
   DEFINE l_str            STRING

   INITIALIZE l_gcw.* TO NULL
   LET l_filename = NULL
   SELECT * INTO l_gcw.* FROM gcw_file          #FUN-920131 全型空白改成半型
      WHERE gcw01 = g_gdm.gdm01 
        AND gcw02 = g_gdm.gdm02 
        AND gcw03 = g_gdm.gdm04 
        AND gcw04 = g_gdm.gdm05 
        AND gcw12 = g_gdm.gdm06

   IF (NOT cl_null(l_gcw.gcw05)) OR (NOT cl_null(l_gcw.gcw06)) OR (NOT cl_null(l_gcw.gcw07)) OR (NOT cl_null(l_gcw.gcw08)) OR (NOT cl_null(l_gcw.gcw09)) OR (NOT cl_null(l_gcw.gcw10)) THEN
      CALL p_grw_filename_lang(l_gcw.gcw05) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED
      CALL p_grw_filename_lang(l_gcw.gcw06) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED
      CALL p_grw_filename_lang(l_gcw.gcw07) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED
      CALL p_grw_filename_lang(l_gcw.gcw08) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED
      CALL p_grw_filename_lang(l_gcw.gcw09) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED
      CALL p_grw_filename_lang(l_gcw.gcw10) RETURNING l_str
      LET l_filename = l_filename CLIPPED ,l_str  CLIPPED

      LET l_filename = l_filename.substring(1,l_filename.getLength()-1)   #刪除最後一個分隔符號
   ELSE
      LET l_filename = NULL
   END IF
   DISPLAY l_filename TO filename

END FUNCTION

FUNCTION p_grw_filename_lang(p_index)
   DEFINE p_index          LIKE    gcw_file.gcw05
   DEFINE l_sql            STRING
   DEFINE l_gae04          LIKE    gae_file.gae04

   IF NOT cl_null(p_index) THEN
      LET l_sql = "SELECT gae04 FROM gae_file"
      LET l_sql = l_sql ," WHERE gae01 = 'p_zaw_gcw' AND gae02 = 'gcw05_" ,p_index ,"' AND gae03 = '" ,g_lang ,"' AND gae12 = 'std'"
      LET l_sql = l_sql ," ORDER BY gae11"   #有客製p_perlang資料就先取客製的

      DECLARE p_zaw_filename_lang_curs CURSOR FROM l_sql
      FOREACH p_zaw_filename_lang_curs INTO l_gae04
      END FOREACH
   END IF

   IF NOT cl_null(l_gae04) THEN
      LET l_gae04 = l_gae04 CLIPPED,"_"
   END IF
   RETURN l_gae04
END FUNCTION
###FUN-8C0025 END #

#FUN-C80015   ADD-END


#FUN-D10108----s
#預設樣板
FUNCTION p_grw_def_template()          
DEFINE l_str   STRING
DEFINE l_msg   STRING
DEFINE l_cnt   LIKE type_file.num5

    IF l_ac <=0 THEN RETURN END IF
    IF cl_null(g_gdw.gdw01) THEN CALL cl_err('',-400,1) END IF

    LET l_str = g_gdw_b[l_ac].gdw09
    LET l_cnt = l_str.getIndexOf("subrep",1)
    IF l_cnt > 0 THEN
       CALL cl_err('','azz1303',1)
       RETURN
    END IF

  ##非tiptop使用者只能更改自己的預設
  # IF g_user<>'tiptop' AND g_user<>g_gdw.gdw05 THEN
  #    CALL cl_err('','azz1304',1)
  #    RETURN
  # END IF

    IF cl_null(g_gdw_b[l_ac].gdw17) OR g_gdw_b[l_ac].gdw17 = 'N' THEN
       LET l_msg = 'azz1305'
    ELSE
       LET l_msg = 'azz1306'
    END IF
    IF NOT cl_confirm(l_msg) THEN RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    IF cl_null(g_gdw_b[l_ac].gdw17) OR g_gdw_b[l_ac].gdw17 = 'N' THEN #不是預設，則UPDATE為Y，並把其它UPDATE為N
       UPDATE gdw_file SET gdw17='Y'
        WHERE gdw08 = g_gdw_b[l_ac].gdw08
       IF SQLCA.SQLERRD[3]=0 THEN
          LET g_success='N'
       END IF
       UPDATE gdw_file SET gdw17='N'
        WHERE gdw01 = g_gdw.gdw01
         #AND gdw02 = g_gdw.gdw02
          AND gdw04 = g_gdw.gdw04
          AND gdw05 = g_gdw.gdw05
          AND gdw06 = g_gdw.gdw06
          AND gdw08 <> g_gdw_b[l_ac].gdw08
    ELSE   #原本是預設樣板=Y，則取消預設
       UPDATE gdw_file SET gdw17='N'
        WHERE gdw08 = g_gdw_b[l_ac].gdw08
       IF SQLCA.SQLERRD[3]=0 THEN
          LET g_success='N'
       END IF
    END IF

    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL p_grw_b_fill('1=1')

END FUNCTION
#FUN-D10108----e
