# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi310.4gl
# Descriptions...: 料件/製造商承認資料維護作業
# Input parameter:
# Return code....:
# Date & Author..: 97/10/28 CHIAYI
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.MOD-570314 05/07/22 By kim g_x[35] , g_x[36] , g_x[37] 值.改抓p_ze內資料
# Modify.........: No.MOD-570303 05/07/25 By kim "送樣人"不檢查必須存在員工檔
# Modify.........: No.MOD-570326 05/07/26 By kim 承認文號和承認狀態 應互相勾稽
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key可更改
# Modify.........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: No.TQC-640106 06/04/08 By Alexstar 處理進入單身後按取消，廠商和供應商簡稱的值會消失
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-690078 06/10/31 By pengu  製造商欄位NULL時存空白
# Modify.........: No.FUN-6B0033 06/11/28 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-690083 06/12/08 By pengu insert azv_file應不與sma102有關係
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.TQC-720052 07/03/20 By Judy 開窗字段"送樣人"錄入任何值不報錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/06/27 By xiaofeizhu 制作水晶報表
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: No.MOD-7B0188 07/11/21 By Pengu 當insert 到pmh_file 時,品管檢驗資料先抓ima_file 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.CHI-860042 08/07/17 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-890153 08/09/17 By Pengu pmh23的值若是null應該要LET l_pmh.pmh23=' '
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930109 09/04/01 By xiaofeizhu 增加對aza92的判斷和AVL否定判斷
# Modify.........: No.MOD-950068 09/05/08 By lutingting abmi310是假雙檔,所以修改單身時并不用update單頭資料
# Modify.........: No.FUN-980001 09/08/05 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:MOD-980225 09/11/25 By sabrina 修改製造商清為空時，程式會卡住強制要輸入
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:MOD-A10065 10/01/13 By Smapmin pmhacti預設為Y
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-AB0041 10/11/04 by sabrina 新增單身時，若發生key值重複時，mse02/pmc03應要一併清空
# Modify.........: No:CHI-AB0025 10/11/23 By Summer 報表改CALL abmr310
# Modify.........: No.TQC-AB0196 10/12/02 By vealxu 料件開窗時應過濾掉avl為否的資料，後台輸入有管控，但開窗時未管控
# Modify.........: No.TQC-AC0154 10/12/14 By vealxu pmh24(VMI)沒給值
# Modify.........: No.TQC-AC0222 10/12/15 By zhangll 完善画面显示
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40059 13/04/10 By bart 預設pmh17,pmh18

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cnt2,g_cnt3   LIKE type_file.num5,   #No.FUN-680096 SMALLINT #TQC-840066
    g_bmj01         LIKE bmj_file.bmj01,   #類別代號 (假單頭)
    g_bmj01_t       LIKE bmj_file.bmj01,   #類別代號 (舊值)
    g_ima02         LIKE ima_file.ima02,   #品名規格
    g_ima021        LIKE ima_file.ima021,  #品名規格(二)
    g_ima05         LIKE ima_file.ima05 ,  #目前使用版本
    g_ima08         LIKE ima_file.ima08 ,  #來源碼
    g_ima103        LIKE ima_file.ima103,  #購料採購特性:
                                           #    '0':內購 '1':外購 '2':其它
    g_bmj          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                bmj02       LIKE bmj_file.bmj02,
                mse02       LIKE mse_file.mse02,
                bmj03       LIKE bmj_file.bmj03,
                pmc03       LIKE pmc_file.pmc03,
                bmj04       LIKE bmj_file.bmj04,
                bmj05       LIKE bmj_file.bmj05,
                bmj06       LIKE bmj_file.bmj06,
                bmj07       LIKE bmj_file.bmj07,
                gen02       LIKE gen_file.gen02,
                bmj08       LIKE bmj_file.bmj08,
                bmj10       LIKE bmj_file.bmj10,
                bmj11       LIKE bmj_file.bmj11,
                bmj12       LIKE bmj_file.bmj12
   END RECORD,
    g_bmj_t         RECORD                 #程式變數 (舊值)
                bmj02       LIKE bmj_file.bmj02,
                mse02       LIKE mse_file.mse02,
                bmj03       LIKE bmj_file.bmj03,
                pmc03       LIKE pmc_file.pmc03,
                bmj04       LIKE bmj_file.bmj04,
                bmj05       LIKE bmj_file.bmj05,
                bmj06       LIKE bmj_file.bmj06,
                bmj07       LIKE bmj_file.bmj07,
                gen02       LIKE gen_file.gen02,
                bmj08       LIKE bmj_file.bmj08,
                bmj10       LIKE bmj_file.bmj10,
                bmj11       LIKE bmj_file.bmj11,
                bmj12       LIKE bmj_file.bmj12
   END RECORD,
    g_argv1                 LIKE bmj_file.bmj01,
    g_wc,g_sql              string,                #No.FUN-580092 HCN
    g_ss                    LIKE type_file.chr1,   #決定後續步驟    #No.FUN-680096 VARCHAR(1) 
    g_rec_b                 LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    l_ac                    LIKE type_file.num5    #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
 
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-680096 SMALLINT
#主程式開始
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #NO.MOD-580078        #No.FUN-680096 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03           #No.FUN-680096 VARCHAR(72)   
 
DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680096 SMALLINT
DEFINE   l_table         STRING                      ### FUN-770052 ###                                                                  
DEFINE   g_str           STRING                      ### FUN-770052 ### 
 
MAIN
DEFINE
    l_za05        LIKE type_file.chr1000      #No.FUN-680096 VARCHAR(40) 
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
#CHI-AB0025 mark --start--
### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##                                                       
#   LET g_sql = " bmj01.bmj_file.bmj01,",
#               " ima02.ima_file.ima02,",
#               " ima021.ima_file.ima021,",
#               " bmj02.bmj_file.bmj02,",      
#               " mse02.mse_file.mse02,",                          
#               " bmj03.bmj_file.bmj03,",  
#               " pmc03.pmc_file.pmc03,",                        
#               " bmj04.bmj_file.bmj04,",            
#               " bmj05.bmj_file.bmj05,",      
#               " bmj06.bmj_file.bmj06,", 
#               " bmj07.bmj_file.bmj07,",            
#               " gen02.gen_file.gen02,",  
#               " bmj08.bmj_file.bmj08,",
#               " bmj10.bmj_file.bmj10,",
#               " bmj11.bmj_file.bmj11,",
#               " bmj12.bmj_file.bmj12"
#   LET l_table = cl_prt_temptable('abmi310',g_sql) CLIPPED   # 產生Temp Table                                                      
#   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
#               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
#                        ?, ?, ?, ?, ?, ? )"                                                                            
#   PREPARE insert_prep FROM g_sql                                                                                                  
#   IF STATUS THEN                                                                                                                  
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
#   END IF                                                                                                                          
##----------------------------------------------------------CR (1) ------------# 
#CHI-AB0025 mark --end--
 
    LET g_argv1   = ARG_VAL(1)              #料件編號
    LET g_bmj01   = NULL                     #清除鍵值
    LET g_bmj01_t = NULL
    LET g_bmj01   = g_argv1
 
    LET p_row = 4 LET p_col = 3
 
    OPEN WINDOW i310_w AT p_row,p_col
         WITH FORM "abm/42f/abmi310"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_aza.aza71 MATCHES '[Yy]' THEN 
       CALL aws_gpmcli_toolbar()
       CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
    ELSE
       CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
    END IF
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
        CALL  i310_q()
    END IF
    CALL i310_menu()
    CLOSE WINDOW i310_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i310_curs()
    CLEAR FORM                             #清除畫面
    CALL g_bmj.clear()
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bmj01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bmj01,bmj02,bmj03,bmj04,bmj05,bmj06,bmj07,bmj08,
                      bmj10,bmj11,bmj12
                 FROM bmj01,s_bmj[1].bmj02,s_bmj[1].bmj03,s_bmj[1].bmj04,
                            s_bmj[1].bmj05,s_bmj[1].bmj06,s_bmj[1].bmj07,
                            s_bmj[1].bmj08,s_bmj[1].bmj10,
                            s_bmj[1].bmj11,s_bmj[1].bmj12
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmj01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = 'c'
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmj01
                     NEXT FIELD bmj01
                WHEN INFIELD(bmj02)     #廠商編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_mse"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmj02
                     NEXT FIELD bmj02
                WHEN INFIELD(bmj03)     #廠商編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmj03
                     NEXT FIELD bmj03
                WHEN INFIELD(bmj07)     #送樣人
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmj07
                     NEXT FIELD bmj07
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmjuser', 'bmjgrup') #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc = " bmj01 = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE bmj01 FROM bmj_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i310_prepare FROM g_sql      #預備一下
    DECLARE i310_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i310_prepare
    LET g_sql="SELECT COUNT(DISTINCT bmj01) FROM bmj_file WHERE ",g_wc CLIPPED
    PREPARE i310_precount FROM g_sql
    DECLARE i310_count CURSOR FOR i310_precount
    LET g_sql = "SELECT * FROM bmj_file  WHERE bmj01 = ? "
    PREPARE i310_r_pre FROM g_sql
    DECLARE i310_r_dec CURSOR WITH HOLD FOR i310_r_pre
END FUNCTION
 
FUNCTION i310_menu()
   DEFINE l_cmd    LIKE type_file.chr50      #No.FUN-680096 VARCHAR(50)
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE l_wc  STRING #CHI-AB0025 add
 
   WHILE TRUE
      IF g_aza.aza92 = 'Y' THEN
         CALL i310_bp2("G")
      ELSE
         CALL i310_bp("G")
      END IF
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i310_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i310_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i310_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i310_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i310_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i310_out() #CHI-AB0025 mark
               #CHI-AB0025 add --start--
               IF g_bmj01 IS NOT NULL THEN
                  LET l_wc=cl_replace_str(g_wc, "'", "\"")
                  LET g_msg = "abmr310",
                              " '",g_today CLIPPED,"' ''",
                              " '",g_lang CLIPPED,"' 'Y' '' '1'",
                              " '",l_wc CLIPPED,"' '5' " 
                  CALL cl_cmdrun(g_msg)
               END IF
               #CHI-AB0025 add --end--
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "controls"                         #No.FUN-6B0033
            CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
       #@WHEN "整批承認"
         WHEN "batch_approve"
            IF cl_chk_act_auth() THEN
               LET l_cmd = 'abmp310 ',g_bmj01
               #CALL cl_cmdrun(l_cmd)       #FUN-660216 remark
               CALL cl_cmdrun_wait(l_cmd)   #FUN-660216 add
               #Add No.TQC-AC0222
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
               CALL i310_b_fill(g_wc)                 #單身
               #End Add No.TQC-AC0222
            END IF
       #@WHEN "機種維護"
         WHEN "machine_model"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "abmi320 '",g_bmj01,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmj01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmj01"
                  LET g_doc.value1 = g_bmj01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmj),'','')
            END IF
 
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_supplierid = g_bmj[l_ac].bmj03 END IF
              LET l_partnum = g_bmj01
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_supplierid = g_bmj[l_ac].bmj03 END IF
              LET l_partnum = g_bmj01
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i310_a()
    IF g_aza.aza92 = 'Y' THEN                           #FUN-930109
       CALL cl_err('','abm-888',1)                      #FUN-930109
       RETURN                                           #FUN-930109
    END IF                                              #FUN-930109
    MESSAGE ""
    CLEAR FORM
    CALL g_bmj.clear()
    INITIALIZE g_bmj01 LIKE bmj_file.bmj01
    LET g_bmj01 = g_argv1
    LET g_bmj01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i310_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_bmj01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_bmj.clear()
            LET g_rec_b = 0
        ELSE
            CALL i310_b_fill('1=1')        #單身
        END IF
        CALL i310_b()                      #輸入單身
        LET g_bmj01_t = g_bmj01            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i310_i(p_cmd)
DEFINE
    p_cmd    LIKE type_file.chr1           #a:輸入 u:更改     #No.FUN-680096 VARCHAR(1)
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT g_bmj01
        WITHOUT DEFAULTS
        FROM bmj01
 
 
        BEFORE FIELD bmj01
          IF g_sma.sma60 = 'Y'          # 若須分段輸入
             THEN CALL s_inp5(8,15,g_bmj01) RETURNING g_bmj01
                  DISPLAY g_bmj01 TO bmj01
          END IF
 
        AFTER FIELD bmj01                  #料件編號
            IF NOT cl_null(g_bmj01) THEN
                #FUN-AA0059 -----------------------------add start-----------------------
                IF NOT s_chk_item_no(g_bmj01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bmj01=g_bmj01_t
                   NEXT FIELD bmj01
                END IF  
                #FUN-AA0059 ------------------------------add end---------------------------
                IF g_bmj01 != g_bmj01_t OR     #輸入後更改不同時值
                   g_bmj01_t IS NULL THEN
                    SELECT UNIQUE bmj01 INTO g_chr
                        FROM bmj_file
                        WHERE bmj01=g_bmj01
                    IF SQLCA.sqlcode THEN             #不存在, 新來的
                        IF p_cmd='a' THEN
                            LET g_ss='N'
                        END IF
                    ELSE
                        IF p_cmd='u' THEN
                            CALL cl_err(g_bmj01,-239,0)
                            LET g_bmj01=g_bmj01_t
                            NEXT FIELD bmj01
                        END IF
                    END IF
                END IF
                CALL i310_bmj01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_bmj01,g_errno,0)
                   NEXT FIELD bmj01
                END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(bmj01)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = ''
                 #   CALL cl_create_qry() RETURNING  g_bmj01
                 #   CALL q_sel_ima(FALSE,"q_ima", "", '', "", "", "", "" ,"",'' )  RETURNING g_bmj01   #TQC-AB0196 mark
                     CALL q_sel_ima(FALSE,"q_ima"," ima926 = 'Y' ",'', "", "", "", "" ,"",'' )  RETURNING g_bmj01   #TQC-AB0196  
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_bmj01
                    NEXT FIELD bmj01
               OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021
    END INPUT
END FUNCTION
 
FUNCTION  i310_bmj01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima05         LIKE ima_file.ima05,
    l_ima08         LIKE ima_file.ima08,
    l_ima103        LIKE ima_file.ima103,
    l_imaacti       LIKE ima_file.imaacti,   #資料有效碼
    l_ima926        LIKE ima_file.ima926     #FUN-930109 
 
    LET g_errno = ' '
    SELECT ima02, ima021, ima05, ima08,ima103,imaacti,ima926                        #FUN-930109 Add ima926
        INTO l_ima02, l_ima021, l_ima05, l_ima08, l_ima103,l_imaacti,l_ima926       #FUN-930109 Add l_ima926
        FROM ima_file
        WHERE ima01 = g_bmj01
    CASE WHEN SQLCA.SQLCODE=100  LET g_errno = 'mfg0002'
              LET l_ima02  = NULL LET l_ima021 = NULL
              LET l_ima05  = NULL LET l_ima08  = NULL
              LET l_ima103 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028' 
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN l_ima926 !='Y' LET g_errno = '9088'                                     #FUN-930109 Add
 
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02   TO FORMONLY.ima02
       DISPLAY l_ima021  TO FORMONLY.ima021
       DISPLAY l_ima05   TO FORMONLY.ima05
       DISPLAY l_ima08   TO FORMONLY.ima08
       CASE l_ima103
           WHEN '0' LET g_msg= cl_getmsg('aco-182',g_lang)
           WHEN '1' LET g_msg= cl_getmsg('agl-420',g_lang)
 #          WHEN '2' LET g_msg= cl_getmsg('apy-660',g_lang)      #CHI-B40058 mark 
           WHEN '2' LET g_msg= cl_getmsg('sub-067',g_lang)       #CHI-B40058
       OTHERWISE
            LET g_msg = ' '
      END CASE
      DISPLAY g_msg TO FORMONLY.desc
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmj01 TO NULL          #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i310_curs()                    #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bmj01 TO NULL
        RETURN
    END IF
    OPEN i310_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmj01 TO NULL
    ELSE
        CALL i310_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i310_count
        FETCH i310_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i310_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i310_b_curs INTO g_bmj01
        WHEN 'P' FETCH PREVIOUS i310_b_curs INTO g_bmj01
        WHEN 'F' FETCH FIRST    i310_b_curs INTO g_bmj01
        WHEN 'L' FETCH LAST     i310_b_curs INTO g_bmj01
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i310_b_curs INTO g_bmj01
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_bmj01,SQLCA.sqlcode,0)
        INITIALIZE g_bmj01 TO NULL
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT unique bmj01 INTO g_bmj01 FROM bmj_file WHERE bmj01=g_bmj01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bmj_file",g_bmj01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
        INITIALIZE g_bmj01 TO NULL
        RETURN
    ELSE
        SELECT bmjuser,bmjgrup INTO g_data_owner,g_data_group
          FROM bmj_file
         WHERE bmj01 = g_bmj01
    END IF
    CALL i310_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i310_show()
 DEFINE  l_tot    LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
    DISPLAY g_bmj01 TO bmj01    #單頭
    CALL i310_bmj01('d')                         #單身
    CALL i310_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i310_r()
  DEFINE l_cnt    LIKE type_file.num5,          #No.FUN-680096 SMALLINT
         l_pmc22  LIKE pmc_file.pmc22,
         l_bmj    RECORD LIKE bmj_file.*
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bmj01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_sma.sma102 = 'Y' THEN
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM pmh_file,pmc_file,bmj_file
        WHERE bmj01 = g_bmj01
          AND pmh01 = bmj01
          AND pmh02 = bmj03
          AND pmh07 = bmj02
          AND pmc01 = pmh02
          AND pmh13 = pmc22
          AND ( pmc22 IS NOT NULL AND pmc22 !=' ')
          AND pmh21 = " "                                             #CHI-860042                                                   
          AND pmh22 = '1'                                             #CHI-860042
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021
    ELSE
       LET l_cnt = 0
    END IF
 
    LET g_success = 'Y'
    BEGIN WORK
    IF l_cnt > 0 THEN
       IF NOT cl_confirm('abm-800') THEN
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       IF NOT cl_delh(0,0) THEN                   #確認一下
          ROLLBACK WORK
          RETURN
       END IF
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bmj01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bmj01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
    END IF
    IF l_cnt > 0 THEN
       CALL i310_r1()
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
    END IF
 
    DELETE FROM bmj_file WHERE bmj01 = g_bmj01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("del","bmj_file",g_bmj01,"",SQLCA.sqlcode,"","BODY DELETE:",1)   #No.TQC-660046
        ROLLBACK WORK
        RETURN
    ELSE
        CLEAR FORM
        CALL g_bmj.clear()
        OPEN i310_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i310_b_curs
           CLOSE i310_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i310_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i310_b_curs
           CLOSE i310_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i310_b_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i310_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i310_fetch('/')
        END IF
 
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
    END IF
    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980001 add plant & legal
       VALUES ('abmi310',g_user,g_today,g_msg,g_bmj01,'delete',g_plant,g_legal)  #FUN-980001 add plant & legal
 
    COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION i310_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,  #可新增否        #No.FUN-680096
    l_tot           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(80)
    l_cnt           LIKE type_file.num5,     #檢查重複用      #bugo:6831    #No.FUN-680096 SMALLINT
    l_pmc22         LIKE pmc_file.pmc22,     #bugno:6831
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bmj01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bmj02,'',bmj03,'',bmj04,bmj05,bmj06,bmj07,'',bmj08, ",
       "       bmj10,bmj11,bmj12 ",
       "  FROM bmj_file ",
       "  WHERE bmj01 = ? ",
       "   AND bmj02 = ? ",
       "   AND bmj03 = ? ",
       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmj
              WITHOUT DEFAULTS
              FROM s_bmj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac   = ARR_CURR()
            DISPLAY l_ac   TO FORMONLY.cnt2
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET g_bmj_t.* = g_bmj[l_ac].*  #BACKUP
                LET p_cmd='u'

                BEGIN WORK
                OPEN i310_bcl USING g_bmj01,g_bmj_t.bmj02,g_bmj_t.bmj03
                IF STATUS THEN
                    CALL cl_err("OPEN i310_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i310_bcl INTO g_bmj[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmj_t.bmj02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    CALL i310_bmj07('d')
                    LET g_bmj_t.*=g_bmj[l_ac].*
                    SELECT mse02 INTO g_bmj[l_ac].mse02   FROM mse_file
                             WHERE mse01 = g_bmj[l_ac].bmj02
                    IF SQLCA.sqlcode THEN LET g_bmj[l_ac].mse02=' ' END IF
                    SELECT pmc03 INTO g_bmj[l_ac].pmc03   FROM pmc_file
                             WHERE pmc01 = g_bmj[l_ac].bmj03
                    IF SQLCA.sqlcode THEN LET g_bmj[l_ac].pmc03=' ' END IF
                    LET g_bmj_t.mse02=g_bmj[l_ac].mse02  #TQC-640106
                    LET g_bmj_t.pmc03=g_bmj[l_ac].pmc03  #TQC-640106
                 END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

            CALL i310_set_entry() #MOD-570326
            CALL i310_set_no_entry() #MOD-570326
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            IF cl_null(g_bmj[l_ac].bmj02) THEN
               LET g_bmj[l_ac].bmj02 = ' '
            END IF
            INSERT INTO bmj_file(bmj01,bmj02,bmj03,bmj04,
                   bmj05,bmj06,bmj07,bmj08,bmj10,bmj11,
                   bmj12,bmj13,bmj14,bmj15,bmjacti,
                   bmjuser,bmjgrup,bmjmodu,bmjdate,bmjoriu,bmjorig)
            VALUES(g_bmj01,g_bmj[l_ac].bmj02,g_bmj[l_ac].bmj03,
                           g_bmj[l_ac].bmj04,g_bmj[l_ac].bmj05,
                           g_bmj[l_ac].bmj06,g_bmj[l_ac].bmj07,
                           g_bmj[l_ac].bmj08,
                           g_bmj[l_ac].bmj10,g_bmj[l_ac].bmj11,
                           g_bmj[l_ac].bmj12,"","","","Y",g_user,
                           g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmj_file",g_bmj01,g_bmj[l_ac].bmj02,SQLCA.sqlcode,"","",1)   #No.TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                CALL i310_ins_pmh()
                CALL i310_ins_azv('a')
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmj[l_ac].* TO NULL      #900423
            LET g_bmj[l_ac].bmj06 = today
            LET g_bmj[l_ac].bmj08 = '0'
            LET g_bmj[l_ac].bmj02 = ' '       #No.CHI-690078 add
            LET g_bmj_t.* = g_bmj[l_ac].*     #新輸入資料

            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmj02
 
        AFTER FIELD bmj02
            IF NOT cl_null(g_bmj[l_ac].bmj02) THEN
               SELECT mse02 INTO g_bmj[l_ac].mse02  FROM mse_file
                WHERE mse01 = g_bmj[l_ac].bmj02
                IF SQLCA.sqlcode THEN   #No:7234
                   CALL cl_err3("sel","mse_file",g_bmj[l_ac].bmj02,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
                   NEXT FIELD bmj02
                END IF
            ELSE
               LET g_bmj[l_ac].bmj02 = ' '
            END IF
 
        BEFORE FIELD bmj04
            IF (g_bmj[l_ac].bmj02 IS NOT NULL AND
               (g_bmj[l_ac].bmj02 != g_bmj_t.bmj02 OR
                g_bmj_t.bmj02 IS NULL))
               OR (g_bmj[l_ac].bmj03 IS NOT NULL AND
                  (g_bmj[l_ac].bmj03 != g_bmj_t.bmj03 OR
                   g_bmj_t.bmj03 IS NULL))
            THEN
                SELECT count(*) INTO l_n FROM bmj_file
                 WHERE bmj01 = g_bmj01
                   AND bmj02 = g_bmj[l_ac].bmj02
                   AND bmj03 = g_bmj[l_ac].bmj03
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bmj[l_ac].bmj02 = g_bmj_t.bmj02
                    LET g_bmj[l_ac].bmj03 = g_bmj_t.bmj03
                    LET g_bmj[l_ac].mse02 = g_bmj_t.mse02           #MOD-AB0041 add  
                    LET g_bmj[l_ac].pmc03 = g_bmj_t.pmc03           #MOD-AB0041 add   
                    NEXT FIELD bmj03
                END IF
            END IF
            IF g_sma.sma102='Y' AND cl_null(g_bmj[l_ac].bmj04) THEN
               SELECT pmh04 INTO g_bmj[l_ac].bmj04 FROM pmh_file,pmc_file
                WHERE pmh01 = g_bmj01
                  AND pmh02 = g_bmj[l_ac].bmj03
                  AND pmh02 = pmc01
                  AND pmh13 = pmc22
                  AND pmh21 = " "                                             #CHI-860042                                           
                  AND pmh22 = '1'                                             #CHI-860042
                  AND pmh23 = ' '                                             #No.CHI-960033
                  AND pmhacti = 'Y'                                           #CHI-910021
            END IF
 
        AFTER FIELD bmj03
              IF NOT cl_null(g_bmj[l_ac].bmj03) THEN
                    SELECT pmc03 INTO g_bmj[l_ac].pmc03  FROM pmc_file
                        WHERE pmc01 = g_bmj[l_ac].bmj03
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("sel","pmc_file",g_bmj[l_ac].bmj03,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
                        NEXT FIELD bmj03
                    END IF

              END IF
 
        AFTER FIELD bmj07
              IF NOT cl_null(g_bmj[l_ac].bmj07) THEN
                 CALL i310_bmj07('a')

                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_bmj[l_ac].bmj07,g_errno,0)
                    NEXT FIELD bmj07
                 END IF
              ELSE
                    LET g_bmj[l_ac].gen02 = ''
              END IF
              DISPLAY BY NAME g_bmj[l_ac].gen02
 
        AFTER FIELD bmj08
              IF NOT cl_null(g_bmj[l_ac].bmj08) THEN
                  IF g_bmj[l_ac].bmj08 NOT MATCHES "[01234X]"  THEN
                      NEXT FIELD bmj08
                  END IF
              END IF
               CALL i310_set_entry()      #MOD-570326
               CALL i310_set_no_entry()   #MOD-570326
               CALL i310_bmj08()          #MOD-570326
 
        BEFORE FIELD bmj10,bmj11
              IF g_bmj[l_ac].bmj08 = '3' THEN
                 CALL cl_err('','abm-013',0)
              END IF
 
        AFTER FIELD bmj10
              IF g_bmj[l_ac].bmj08 = '3' AND cl_null(g_bmj[l_ac].bmj10) THEN
                 NEXT FIELD bmj10
              END IF
 
        AFTER FIELD bmj11
              IF g_bmj[l_ac].bmj08 = '3' AND cl_null(g_bmj[l_ac].bmj11) THEN
                  NEXT FIELD bmj11
              END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bmj_t.bmj02) OR NOT cl_null(g_bmj_t.bmj03)
            THEN
               IF g_sma.sma102 = 'Y' THEN
                  LET l_cnt = 0
                  SELECT pmc22 INTO l_pmc22 FROM pmc_file
                   WHERE pmc01 = g_bmj_t.bmj03
                    IF NOT cl_null(l_pmc22) THEN
                       SELECT COUNT(*) INTO l_cnt FROM pmh_file
                        WHERE pmh01 = g_bmj01
                          AND pmh02 = g_bmj_t.bmj03
                          AND pmh13 = l_pmc22
                          AND pmh21 = " "                                             #CHI-860042                                   
                          AND pmh22 = '1'                                             #CHI-860042
                          AND pmh23 = ' '                                             #No.CHI-960033
                          AND pmhacti = 'Y'                                           #CHI-910021
                    END IF
               ELSE
                  LET l_cnt = 0
               END IF
               IF l_cnt > 0 THEN
                  IF NOT cl_confirm('abm-800') THEN
                     CANCEL DELETE
                  END IF
               ELSE
                  IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                  END IF
               END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               DELETE FROM bmj_file
                WHERE bmj01 = g_bmj01
                  AND bmj02 = g_bmj_t.bmj02
                  AND bmj03 = g_bmj_t.bmj03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","bmj_file",g_bmj01,g_bmj_t.bmj02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               CALL i310_ins_azv('d')
               IF g_sma.sma102='Y' AND l_cnt > 0 THEN
                  SELECT pmc22 INTO l_pmc22 FROM pmc_file
                   WHERE pmc01 = g_bmj_t.bmj03
                  UPDATE pmh_file SET
                         pmh05 = '1',
                         pmh06 = '',
                         pmhdate = g_today     #FUN-C40009 add
                   WHERE pmh01 = g_bmj01
                     AND pmh02 = g_bmj_t.bmj03
                     AND pmh13 = l_pmc22
                     AND pmh21 = " "                                             #CHI-860042                                        
                     AND pmh22 = '1'                                             #CHI-860042
                     AND pmh23 = ' '                                             #No.CHI-960033
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","pmh_file",g_bmj01,g_bmj_t.bmj03,SQLCA.sqlcode,"","del_upd_pmc",1)   #No.TQC-660046
                      ROLLBACK WORK
                      CANCEL DELETE
                  END IF
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cnt2
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmj[l_ac].* = g_bmj_t.*
               CLOSE i310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmj[l_ac].bmj02,-263,1)
                LET g_bmj[l_ac].* = g_bmj_t.*
            ELSE
                UPDATE bmj_file SET
                       bmj02=g_bmj[l_ac].bmj02,
                       bmj03=g_bmj[l_ac].bmj03,
                       bmj04=g_bmj[l_ac].bmj04,
                       bmj05=g_bmj[l_ac].bmj05,
                       bmj06=g_bmj[l_ac].bmj06,
                       bmj07=g_bmj[l_ac].bmj07,
                       bmj08=g_bmj[l_ac].bmj08,
                       bmj10=g_bmj[l_ac].bmj10,
                       bmj11=g_bmj[l_ac].bmj11,
                       bmj12=g_bmj[l_ac].bmj12,
                       bmjmodu=g_user,
                       bmjdate=g_today
                 WHERE bmj01=g_bmj01
                   AND bmj02=g_bmj_t.bmj02
                   AND bmj03=g_bmj_t.bmj03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bmj_file",g_bmj01,g_bmj_t.bmj02,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                    LET g_bmj[l_ac].* = g_bmj_t.*
                    ROLLBACK WORK
                ELSE
                    CALL i310_ins_pmh()
                    CALL i310_ins_azv('u')
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bmj[l_ac].* = g_bmj_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i310_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmj02)     #廠商編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_mse"
                     LET g_qryparam.default1 = g_bmj[l_ac].bmj02
                     CALL cl_create_qry() RETURNING g_bmj[l_ac].bmj02
                     DISPLAY g_bmj[l_ac].bmj02 TO bmj02
                     NEXT FIELD bmj02
                WHEN INFIELD(bmj03)     #廠商編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.default1 = g_bmj[l_ac].bmj03
                     CALL cl_create_qry() RETURNING g_bmj[l_ac].bmj03
                     DISPLAY g_bmj[l_ac].bmj03 TO bmj03
                     NEXT FIELD bmj03
                WHEN INFIELD(bmj07)     #送樣人
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_bmj[l_ac].bmj07
                     CALL cl_create_qry() RETURNING g_bmj[l_ac].bmj07
                     DISPLAY g_bmj[l_ac].bmj07 TO bmj07
                     NEXT FIELD bmj07
            END CASE
 
        ON ACTION mntn_brand     #廠牌
                CALL cl_cmdrun("amri504 ")
 
        ON ACTION mntn_vender_item       #廠商料號
                CALL cl_cmdrun("apmi253 ")
 

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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
    

    CLOSE i310_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i310_ins_azv(p_code)   #bugno:6831 add
  DEFINE l_azv    RECORD LIKE azv_file.*,
         l_azv10  LIKE azv_file.azv10,
         p_code   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1) 
 
  IF p_code != 'u' OR
     ( p_code = 'u' AND
     ( g_bmj[l_ac].bmj10 !=g_bmj_t.bmj10 OR g_bmj[l_ac].bmj11 !=g_bmj_t.bmj11
       OR g_bmj[l_ac].bmj08 !=g_bmj_t.bmj08 ))
  THEN
     LET l_azv.azv01 = g_bmj01
     LET l_azv.azv02 = g_bmj[l_ac].bmj02
     LET l_azv.azv03 = g_bmj[l_ac].bmj03
     LET l_azv.azv04 = g_bmj[l_ac].bmj10
     LET l_azv.azv05 = g_bmj[l_ac].bmj11
     LET l_azv.azv06 = g_bmj[l_ac].bmj08
     LET l_azv.azv07 = g_user
     LET l_azv.azv08 = TODAY
     LET l_azv.azv09 = TIME
     LET l_azv.azvplant = g_plant   #FUN-980001 add plant & legal
     LET l_azv.azvlegal = g_legal   #FUN-980001 add plant & legal
     CASE p_code
          WHEN 'a'   LET l_azv10 = g_x[39] CLIPPED
          WHEN 'u'   LET l_azv10 = g_x[40] CLIPPED
          WHEN 'd'   LET l_azv10 = g_x[41] CLIPPED
     END CASE
     LET l_azv.azv10 = l_azv10
     INSERT INTO azv_file VALUES(l_azv.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","azv_file",l_azv.azv01,l_azv.azv02,SQLCA.sqlcode,"","ins_azv",1)   #No.TQC-660046
     END IF
   END IF
END FUNCTION
 
FUNCTION i310_ins_pmh()                 #bugno:6831 add
  DEFINE  l_cnt      LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_pmh      RECORD LIKE pmh_file.*,
          l_pmh05    LIKE pmh_file.pmh05,
          l_pmh06    LIKE pmh_file.pmh06,
          l_pmc22    LIKE pmc_file.pmc22
 
     IF g_sma.sma102='N' THEN RETURN END IF
 
     SELECT pmc22 INTO l_pmc22 FROM pmc_file
      WHERE pmc01 = g_bmj[l_ac].bmj03
 
        SELECT COUNT(*) INTO l_cnt FROM pmh_file
         WHERE pmh01 = g_bmj01
           AND pmh02 = g_bmj[l_ac].bmj03
           AND pmh13 = l_pmc22
           AND pmh21 = " "                                             #CHI-860042                                                  
           AND pmh22 = '1'                                             #CHI-860042
           AND pmh23 = ' '                                             #No.CHI-960033
           AND pmhacti = 'Y'                                           #CHI-910021
        IF l_cnt > 0 THEN
           CASE WHEN g_bmj[l_ac].bmj08='3'
                     LET l_pmh05 = '0'
                     LET l_pmh06 = g_bmj[l_ac].bmj11
                WHEN g_bmj[l_ac].bmj08='4'
                     LET l_pmh05 = '2'
                     LET l_pmh06 = ''
                OTHERWISE
                     LET l_pmh05 = '1'
                     LET l_pmh06 = ''
                EXIT CASE
           END CASE
           UPDATE pmh_file SET
                  pmh05 = l_pmh05,
                  pmh06 = l_pmh06,
                  pmhdate = g_today     #FUN-C40009 add
            WHERE pmh01 = g_bmj01
              AND pmh02 = g_bmj[l_ac].bmj03
              AND pmh13 = l_pmc22
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","pmh_file",g_bmj01,g_bmj[l_ac].bmj03,SQLCA.sqlcode,"","upd_pmh_err",1)   #No.TQC-660046
              LET g_success = 'N'
           END IF
        ELSE
          LET l_pmh.pmh01 = g_bmj01
          LET l_pmh.pmh02 = g_bmj[l_ac].bmj03
          LET l_pmh.pmh04 = g_bmj[l_ac].bmj04
          LET l_pmh.pmh07 = g_bmj[l_ac].bmj02
          SELECT ima24 INTO l_pmh.pmh08 FROM ima_file
           WHERE ima01 = g_bmj01
          IF cl_null(l_pmh.pmh08) THEN LET l_pmh.pmh08 = 'Y' END IF
          LET l_pmh.pmh13 = l_pmc22
          IF g_aza.aza17 = l_pmh.pmh13 THEN   #本幣
             LET l_pmh.pmh14 = 1
          ELSE
             CALL s_curr3(l_pmh.pmh13,g_today,'S') RETURNING l_pmh.pmh14
          END IF
          CASE WHEN g_bmj[l_ac].bmj08='3'
                    LET l_pmh.pmh05 = '0'
                    LET l_pmh.pmh06 = g_bmj[l_ac].bmj11
               WHEN g_bmj[l_ac].bmj08='4'
                    LET l_pmh.pmh05 = '2'
                    LET l_pmh.pmh06 = ''
               OTHERWISE
                    LET l_pmh.pmh05 = '1'
                    LET l_pmh.pmh06 = ''
               EXIT CASE
          END CASE
          IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
 
          IF cl_null(l_pmh.pmh21) THEN LET l_pmh.pmh21=' ' END IF
          IF cl_null(l_pmh.pmh22) THEN LET l_pmh.pmh22='1' END IF
          SELECT ima100,ima101,ima102
             INTO l_pmh.pmh09,l_pmh.pmh15,l_pmh.pmh16
             FROM ima_file
            WHERE ima01=l_pmh.pmh01
          #MOD-D40059---begin
          SELECT pmc47,gec04
            INTO l_pmh.pmh17,l_pmh.pmh18
            FROM pmc_file,gec_file
           WHERE pmc01 = g_bmj[l_ac].bmj03
             AND gec011 = '1'
             AND gec01 = pmc47
          #MOD-D40059---end
          IF cl_null(l_pmh.pmh23) THEN LET l_pmh.pmh23=' ' END IF   #No.MOD-890153 add
          LET l_pmh.pmhoriu = g_user      #No.FUN-980030 10/01/04
          LET l_pmh.pmhorig = g_grup      #No.FUN-980030 10/01/04
          LET l_pmh.pmhacti='Y'   #MOD-A10065
          LET l_pmh.pmh25='N'     #No:FUN-AA0015
          LET l_pmh.pmh24 = 'N'   #No:TQC-AC0154 
          INSERT INTO pmh_file VALUES(l_pmh.*)
          IF SQLCA.sqlcode  THEN
             CALL cl_err3("ins","pmh_file",l_pmh.pmh01,l_pmh.pmh02,SQLCA.sqlcode,"","ins_pmh_err",1)  #No.TQC-660046
             LET g_success = 'N'
          END IF
        END IF
END FUNCTION
 
FUNCTION i310_r1()   #bugno:6831 add
  DEFINE  l_cnt      LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_bmj      RECORD LIKE bmj_file.*,
	  l_pmh      RECORD LIKE pmh_file.*,
          l_azv      RECORD LIKE azv_file.*,
          l_pmh05    LIKE pmh_file.pmh05,
          l_pmh06    LIKE pmh_file.pmh06,
          l_pmc22    LIKE pmc_file.pmc22
 
     IF g_sma.sma102='N' THEN RETURN END IF
 
     FOREACH i310_r_dec USING g_bmj01 INTO l_bmj.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF
        SELECT pmc22 INTO l_pmc22 FROM pmc_file
         WHERE pmc01 = l_bmj.bmj03
        SELECT COUNT(*) INTO l_cnt FROM pmh_file
         WHERE pmh01 = g_bmj01
           AND pmh02 = l_bmj.bmj03
           AND pmh13 = l_pmc22
           AND pmh21 = " "                                                #CHI-860042                                               
           AND pmh22 = '1'                                                #CHI-860042
           AND pmh23 = ' '                                                #No.CHI-960033
           AND pmhacti = 'Y'                                              #CHI-910021
        IF l_cnt > 0 THEN
           UPDATE pmh_file SET
                  pmh05 = '1',
                  pmh06 = '',
                  pmhdate = g_today     #FUN-C40009 add
            WHERE pmh01 = g_bmj01
              AND pmh02 = l_bmj.bmj03
              AND pmh13 = l_pmc22
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","pmh_file",g_bmj01,l_bmj.bmj03,SQLCA.sqlcode,"","r_upd_pmh",1)  #No.TQC-660046
              LET g_success = 'N'
           END IF
        END IF
 
        LET l_azv.azv01 = g_bmj01
        LET l_azv.azv02 = l_bmj.bmj02
        LET l_azv.azv03 = l_bmj.bmj03
        LET l_azv.azv04 = l_bmj.bmj10
        LET l_azv.azv05 = l_bmj.bmj11
        LET l_azv.azv06 = l_bmj.bmj08
        LET l_azv.azv07 = g_user
        LET l_azv.azv08 = TODAY
        LET l_azv.azv09 = TIME
        LET l_azv.azv10 = 'DELETE'
        LET l_azv.azvplant = g_plant   #FUN-980001 add plant & legal
        LET l_azv.azvlegal = g_legal   #FUN-980001 add plant & legal
 
        INSERT INTO azv_file VALUES(l_azv.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","azv_file",l_azv.azv01,l_azv.azv02,SQLCA.sqlcode,"","r_ins_azv",1)  #No.TQC-660046
        END IF
     END FOREACH
 
END FUNCTION
 
FUNCTION i310_bmj02(p_cmd)         #製造商代號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_mse02   LIKE mse_file.mse02
 
    LET g_errno = ''
    SELECT mse02 INTO l_mse02 FROM mse_file
     WHERE mse01 = g_bmj[l_ac].bmj02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET l_mse02 = ''
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_bmj[l_ac].mse02 = l_mse02
    END IF
END FUNCTION
 
FUNCTION i310_bmj07(p_cmd)         #人員代號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_errno = ''
    SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
     WHERE gen01 = g_bmj[l_ac].bmj07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET l_gen02 = ''
                                   LET l_genacti = ''
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       LET g_bmj[l_ac].gen02 = l_gen02
END FUNCTION
 
FUNCTION i310_b_askkey()
DEFINE
    l_wc      LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(200)
 
    CONSTRUCT l_wc ON bmj02,bmj03,bmj04,bmj05,bmj06,bmj07,bmj08,bmj10,
                      bmj11,bmj12
                 FROM s_bmj[1].bmj02,s_bmj[1].bmj03,s_bmj[1].bmj04,
                      s_bmj[1].bmj05,s_bmj[1].bmj06,s_bmj[1].bmj07,
                      s_bmj[1].bmj08,s_bmj[1].bmj10,
                      s_bmj[1].bmj11,s_bmj[1].bmj12
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i310_b_fill(l_wc)
END FUNCTION
 
FUNCTION i310_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000     #No.FUN-680096 VARCHAR(200)
 
    LET g_sql =
       "SELECT bmj02,'',bmj03,'',bmj04,bmj05,bmj06,bmj07,gen02,",
       "       bmj08,bmj10,bmj11,bmj12 ",
       " FROM bmj_file,OUTER gen_file",
       " WHERE bmj01 = '",g_bmj01,"'",
       "   AND bmj_file.bmj07=gen_file.gen01 ",
       "   AND ",p_wc CLIPPED,
       " ORDER BY bmj02"
 
    PREPARE i310_prepare2 FROM g_sql      #預備一下
    DECLARE bmj_curs CURSOR FOR i310_prepare2
    CALL g_bmj.clear()
    LET g_cnt = 1
    FOREACH bmj_curs INTO g_bmj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT mse02 INTO g_bmj[g_cnt].mse02   FROM mse_file
                 WHERE mse01 = g_bmj[g_cnt].bmj02
        IF SQLCA.sqlcode THEN LET g_bmj[g_cnt].mse02 = ' ' END IF
        SELECT pmc03 INTO g_bmj[g_cnt].pmc03   FROM pmc_file
                 WHERE pmc01 = g_bmj[g_cnt].bmj03
        IF SQLCA.sqlcode THEN LET g_bmj[g_cnt].pmc03 = ' ' END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bmj.deleteElement(g_cnt)
    LET g_cnt = g_cnt - 1
    LET g_rec_b = g_cnt
    DISPLAY g_cnt TO FORMONLY.cnt2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmj TO s_bmj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 整批承認
      ON ACTION batch_approve
         LET g_action_choice="batch_approve"
         EXIT DISPLAY
    #@ON ACTION 機種維護
      ON ACTION machine_model
         LET g_action_choice="machine_model"
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
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#使用料件承認申請時,錄入,更改,單身均不可維護
FUNCTION i310_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmj TO s_bmj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()     
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 整批承認
      ON ACTION batch_approve
         LET g_action_choice="batch_approve"
         EXIT DISPLAY
    #@ON ACTION 機種維護
      ON ACTION machine_model
         LET g_action_choice="machine_model"
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
 
 
       ON ACTION related_document       
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls     
         CALL cl_set_head_visible("","AUTO") 
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i310_copy()
DEFINE l_newno,l_oldno1  LIKE bmj_file.bmj01,
       l_n           LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021,
       l_ima05       LIKE ima_file.ima05,
       l_ima08       LIKE ima_file.ima08,
       l_ima103      LIKE ima_file.ima103
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bmj01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    DISPLAY ' ' TO bmj01
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
    INPUT l_newno FROM bmj01
        AFTER FIELD bmj01
            IF l_newno IS NULL THEN
                NEXT FIELD bmj01
            ELSE
               #FUN-AA0059 --------------------------add start-----------------------------
               IF NOT s_chk_item_no(l_newno,'') THEN
                  CALL cl_err('',g_errno,1) 
                  NEXT FIELD bmj01
               END IF 
               #FUN-AA0059 --------------------------add end--------------------------    
                SELECT count(*) INTO l_n FROM bmj_file WHERE bmj01 = l_newno
                 IF l_n > 0 THEN
                     CALL cl_err('',-239,0) NEXT FIELD bmj01
                 END IF
                 select ima01 from ima_file where ima01 = l_newno
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","ima_file",l_newno,"","mfg0002","","",1)   #No.TQC-660046
                    NEXT FIELD bmj01
                 END IF
            END IF
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmj01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.default1 = ''
                  #   CALL cl_create_qry() RETURNING l_newno
                  # CALL q_sel_ima(FALSE, "q_ima", "", '', "", "", "", "" ,"",'' )  RETURNING l_newno                #TQC-AB0196
                    CALL q_sel_ima(FALSE, "q_ima"," ima926 = 'Y' ",'', "", "", "", "" ,"",'' )  RETURNING l_newno    #TQC-AB0196
#FUN-AA0059 --End--
                     DISPLAY l_newno TO bmj01
                     NEXT FIELD bmj01
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY  g_bmj01 TO bmj01
            RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM bmj_file         #單身複製
        WHERE bmj01 = g_bmj01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_bmj01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
       RETURN
    END IF
    UPDATE x
        SET bmj01 = l_newno
    INSERT INTO bmj_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","bmj_file",g_bmj01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno1= g_bmj01
     LET g_bmj01=l_newno
     CALL i310_b()
     #LET g_bmj01=l_oldno1  #FUN-C30027
     #CALL i310_show()      #FUN-C30027
END FUNCTION
 
 
#CHI-AB0025 mark --start--
#FUNCTION i310_out()
#DEFINE
#    l_i             LIKE type_file.num5,          #No.FUN-680096 SMALLINT
#    sr              RECORD
#                bmj01       LIKE bmj_file.bmj01,
#                bmj02       LIKE bmj_file.bmj02,
#                bmj03       LIKE bmj_file.bmj03,
#                bmj04       LIKE bmj_file.bmj04,
#                bmj05       LIKE bmj_file.bmj05,
#                bmj06       LIKE bmj_file.bmj06,
#                bmj07       LIKE bmj_file.bmj07,
#                bmj08       LIKE bmj_file.bmj08,
#                sts         LIKE aab_file.aab02,
#                bmj10       LIKE bmj_file.bmj10,
#                bmj11       LIKE bmj_file.bmj11,
#                bmj12       LIKE bmj_file.bmj12,
#                bmjacti     LIKE bmj_file.bmjacti
#    END RECORD,
#    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680096 VARCHAR(20) 
#    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40) 
#    DEFINE l_ima02      LIKE ima_file.ima02  #FUN-770052                                                                            
#    DEFINE l_ima021     LIKE ima_file.ima021 #FUN-770052                                                                            
#    DEFINE l_mse02      LIKE mse_file.mse02  #FUN-770052                                                                            
#    DEFINE l_pmc03      LIKE pmc_file.pmc03  #FUN-770052                                                                            
#    DEFINE l_gen02      LIKE gen_file.gen02  #FUN-770052   
#    DEFINE l_sql        STRING               #FUN-770052
#    IF cl_null(g_wc) THEN
#        LET g_wc=" bmj01='",g_bmj01,"'"
#    END IF
#    CALL cl_wait()
#    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                     
#    CALL cl_del_data(l_table)                                                                                                       
#    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                               
#    #------------------------------ CR (2) ------------------------------#
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
# 
#    LET g_sql="SELECT bmj01,bmj02,bmj03,bmj04,bmj05,bmj06,",
#              "      bmj07,bmj08,'',",
#              "      bmj10,bmj11,bmj12,bmjacti ",
#              " FROM bmj_file ",  # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
# 
#   PREPARE i310_p1 FROM g_sql                # uUNTIME 編譯  
#    DECLARE i310_curo                         # CURSOR
#        CURSOR FOR i310_p1
# 
# 
#    FOREACH i310_curo INTO sr.*
#        IF SQLCA.sqlcode THEN                      
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF 
#        SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                                   
#         FROM ima_file                                                                                                             
#         WHERE ima01 = sr.bmj01                                                                                                     
#        IF SQLCA.sqlcode THEN                                                                                                       
#            LET l_ima02  = NULL                                                                                                     
#            LET l_ima021 = NULL                                                                                                     
#        END IF                                                                                                                      
#        SELECT mse02 INTO l_mse02                                                                                                   
#         FROM mse_file                                                                                                             
#         WHERE mse01 = sr.bmj02                                                                                                     
#        IF SQLCA.sqlcode THEN                                                                                                       
#            LET l_mse02  = NULL                                                                                                     
#        END IF                                                                                                                      
#        SELECT pmc03 INTO l_pmc03                                                                                                   
#         FROM pmc_file                                                                                                             
#         WHERE pmc01 = sr.bmj03                                                                                                     
#        IF SQLCA.sqlcode THEN                                                                                                       
#            LET l_pmc03  = NULL                                                                                                     
#        END IF                                                                                                                      
#        SELECT gen02 INTO l_gen02                                                                                                   
#         FROM gen_file                                                                                                             
#         WHERE gen01 = sr.bmj07   
#        IF SQLCA.sqlcode THEN                                                                                                       
#            LET l_gen02  = NULL                                                                                                     
#        END IF 
#    ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                       
#           EXECUTE insert_prep USING                                                                                                
#                   sr.bmj01,l_ima02,l_ima021,sr.bmj02,l_mse02,                                                                
#                   sr.bmj03,l_pmc03,sr.bmj04,sr.bmj05,sr.bmj06,sr.bmj07,
#                   l_gen02,sr.bmj08,sr.bmj10,sr.bmj11,sr.bmj12                                                                  
#        #------------------------------ CR (3) ------------------------------#
#
#    END FOREACH
#         IF g_zz05 = 'Y' THEN                                                                                                           
#        CALL cl_wcchp(g_wc,'bmj01,bmj02,bmj03,bmj04,bmj05,bmj06,bmj07,bmj08,bmj10,bmj11,bmj12')                                                              
#             RETURNING g_wc                                                                                                         
#        LET g_str = g_wc                                                                                                            
#     END IF 
#    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                     
#    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
#    CALL cl_prt_cs3('abmi310','abmi310',l_sql,g_str)        #FUN-770052                                                             
#    #------------------------------ CR (4) ------------------------------#
# 
#
#END FUNCTION
#CHI-AB0025 mark --end--
 
 
FUNCTION i310_set_entry()  #NO.MOD-580078 MARK
DEFINE p_cmd LIKE type_file.chr1   #TQC-5A0134 VARCHAR-->CHAR        #No.FUN-680096 VARCHAR(1)
 

   IF g_bmj[l_ac].bmj08='3' THEN
     CALL cl_set_comp_entry("bmj10,bmj11",TRUE)
   END IF
END FUNCTION
 
FUNCTION i310_set_no_entry()  #NO.MOD-580078 MARK
DEFINE p_cmd LIKE type_file.chr1   #TQC-5A0134 VARCHAR-->CHAR        #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bmj02,bmj03",FALSE)
   END IF
 
   IF g_bmj[l_ac].bmj08<>'3' THEN
     CALL cl_set_comp_entry("bmj10,bmj11",FALSE)
   END IF
END FUNCTION
 
FUNCTION i310_bmj08()
   IF g_bmj[l_ac].bmj08<>'3' THEN
      LET g_bmj[l_ac].bmj10=NULL
      LET g_bmj[l_ac].bmj11=NULL
   END IF
END FUNCTION
#No:FUN-9C0077
