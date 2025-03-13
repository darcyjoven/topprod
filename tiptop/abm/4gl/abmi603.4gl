# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi603.4gl
# Descriptions...: 產品結構元件說明維護作業
# Date & Author..: 91/08/06 By Wu
# Modify.........: No:8766 03/11/26 By ching bmbgrup nouse
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.FUN-550014 05/05/16 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.TQC-660046 06/06/14 By Jackho cl_err-->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740079 07/04/13 By Ray 報表格式調整
# Modify.........: No.TQC-740145 07/04/24 By johnray 打印時"結束"格式有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760129 07/06/14 By xufeng 主件編號新增開窗按鈕                                                                               
# Modify.........: No.FUN-770052 07/06/26 By xiaofeizhu 制作水晶報表
# Modify.........: No.TQC-790039 07/09/18 By Judy 復制時，"主件編號"無法開窗
# Modify.........: No.MOD-860127 08/06/13 By claire 序號計算考慮特性代碼
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-940293 09/04/29 By sherry abmi600在串abmi603的試候也要加上有效日期的判斷
# Modify.........: No.TQC-960268 09/06/23 By destiny 修改筆數計算方法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.TQC-AB0041 10/12/15 By lixh1  將i603_b_fill()中的SQL改為通用的SQL 
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bmb           RECORD LIKE bmb_file.*,
    g_bmb_t         RECORD LIKE bmb_file.*,
    g_bmb01_t       LIKE bmb_file.bmb01,   #主件編號-1 (舊值)
    g_bmb02_t       LIKE bmb_file.bmb02,   #項次-2 (舊值)
    g_bmb03_t       LIKE bmb_file.bmb03,   #元件編號-3 (舊值)
    g_bmb04_t       LIKE bmb_file.bmb04,   #生效日-4 (舊值)
    g_bmb29_t       LIKE bmb_file.bmb29,   #FUN-550014
    g_bmc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmc04       LIKE bmc_file.bmc04,   #行序
        bmc05       LIKE bmc_file.bmc05    #說明
                    END RECORD,
    g_bmc_t         RECORD                 #程式變數 (舊值)
        bmc04       LIKE bmc_file.bmc04,   #行序
        bmc05       LIKE bmc_file.bmc05    #說明
                    END RECORD,
    g_bmb01         LIKE bmb_file.bmb01,
    g_bmb02         LIKE bmb_file.bmb02,
    g_bmb03         LIKE bmb_file.bmb03,
    g_bmb04         LIKE bmb_file.bmb04,
    g_bmb29         LIKE bmb_file.bmb29,    #FUN-550014
    g_bmb05         LIKE bmb_file.bmb05,    #MOD-940293 add  
   #g_wc,g_wc2,g_sql    STRING,             #TQC-630166 
    g_wc,g_wc2,g_sql    STRING,             #TQC-630166
    g_flag,g_flag2  LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,    #單身筆數        #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5     #目前處理的SCREEN LINE      #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg         LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING                  ### FUN-770052 ###                                                                  
DEFINE   g_str          STRING                  ### FUN-770052 ###   
DEFINE   g_temp        STRING                  #No.TQC-960268
 
MAIN
# DEFINE                                    #No.FUN-6A0060 
#       l_time    LIKE type_file.chr8       #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_bmb01  = ARG_VAL(1)              #主件編號
    LET g_bmb02  = ARG_VAL(2)              #項次
    LET g_bmb03  = ARG_VAL(3)              #元件
    LET g_bmb04  = ARG_VAL(4)              #生效日
    LET g_bmb29  = ARG_VAL(5)              #FUN-550014
    LET g_bmb05  = ARG_VAL(6)              #失效日   #MOD-940293      
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_sql = " bmb01.bmb_file.bmb01,",                                                                                           
                " ima02.ima_file.ima02,",                                                                                         
                " ima021.ima_file.ima021,",                                                                                        
                " bmb02.bmb_file.bmb02,",                                                                                         
                " bmb03.bmb_file.bmb03,",       
                " ima02a.ima_file.ima02,",                                                                                           
                " ima021a.ima_file.ima021,",                                                                                      
                " bmb04.bmb_file.bmb04,",          
                " bmc04.bmc_file.bmc04,",       
                " bmc05.bmc_file.bmc05"                                                                                             
    LET l_table = cl_prt_temptable('abmi603',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"                                                                            
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060

    LET g_forupd_sql = "SELECT * FROM bmb_file ",
                       " WHERE bmb01 = ? AND bmb02 = ? AND bmb03 = ? AND bmb04 = ? AND bmb29 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i603_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i603_w WITH FORM "abm/42f/abmi603"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
 
    IF NOT cl_null(g_bmb01) THEN
        LET g_flag = 'Y'
        IF cl_null(g_bmb02) THEN LET g_flag2='N' ELSE LET g_flag2='Y' END IF
        CALL i603_q()
        IF g_flag2='Y' THEN
            CALL i603_b()
        ELSE
            CALL i603_menu()
        END IF
    ELSE
        LET g_flag = 'N'
        CALL i603_menu()    #中文
    END IF
 
    CLOSE WINDOW i603_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i603_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 CLEAR FORM                             #清除畫面
 CALL g_bmc.clear()
 
 IF cl_null(g_bmb01) THEN
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bmb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
          bmb01,bmb29,bmb02,bmb03,bmb04 #FUN-550014
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #TQC-760129   --begin
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmb01)
#FUN-AA0059 --Begin--
             #    CALL cl_init_qry_var()
             #    LET g_qryparam.form = "q_ima"
             #    LET g_qryparam.state = 'c'
             #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO bmb01
                 NEXT FIELD bmb01
           END CASE
       #TQC-760129   --end
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 ELSE
    LET g_wc = "     bmb01 ='",g_bmb01,"'",
               " AND bmb29 ='",g_bmb29,"'" #FUN-550014
    IF NOT cl_null(g_bmb02) THEN
       LET g_wc = g_wc CLIPPED, " AND bmb02 ='",g_bmb02,"'"
    END IF
    IF NOT cl_null(g_bmb03) THEN
       LET g_wc = g_wc CLIPPED, " AND bmb03 ='",g_bmb03,"'"
    END IF
    IF NOT cl_null(g_bmb04) THEN
       LET g_wc = g_wc CLIPPED, " AND bmb04 ='",g_bmb04,"'"
    END IF
    #MOD-940293---Begin                                                                                                             
    IF NOT cl_null(g_bmb05) THEN                                                                                                    
       LET g_wc = g_wc CLIPPED, " AND (bmb05 >'",g_bmb05,"' OR bmb05 IS NULL)"                                                      
    END IF                                                                                                                          
    #MOD-940293---End   
 END IF
    IF INT_FLAG THEN RETURN END IF
#No:8766
{
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bmbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bmbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bmbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmbuser', 'bmbgrup')
    #End:FUN-980030
 
}
    IF g_flag = 'N'
    THEN
       CONSTRUCT g_wc2 ON bmc04,bmc05                # 螢幕上取單身條件
                FROM s_bmc[1].bmc04,s_bmc[1].bmc05
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
        IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc2 = " 1=1"
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  bmb01,bmb02,bmb03,bmb04,bmb29 FROM bmb_file ", #TQC-870018                  #FUN-550014
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  bmb01, bmb02,bmb03,bmb04,bmb29 ", #TQC-870018      #FUN-550014
                   "  FROM bmb_file, bmc_file ",
                   " WHERE bmb01 = bmc01 AND bmb02 = bmc02",
                   " AND bmb03 = bmc021 AND bmb04 = bmc03",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i603_prepare FROM g_sql
    DECLARE i603_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i603_prepare
    #No.TQC-960268--begin
    IF g_wc2 = " 1=1" THEN			#    X G兵⑦撣計
#        LET g_sql="SELECT COUNT(*) FROM bmb_file WHERE ",g_wc CLIPPED
         LET g_temp="SELECT UNIQUE bmb01,bmb02,bmb03,bmb04,bmb29 FROM bmb_file WHERE ",g_wc CLIPPED,
                   " INTO TEMP x"
    ELSE
#        LET g_sql="SELECT UNIQUE COUNT(*) ",
#                  " FROM bmb_file,bmc_file WHERE ",
#                  " bmb01=bmc01 AND bmb02=bmc02",
#                  " AND bmb29=bmc06 ", #FUN-550014
#                  " AND bmb03=bmc021 AND bmb04=bmc03",
#                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         LET g_temp="SELECT UNIQUE bmb01,bmb02,bmb03,bmb04,bmb29 FROM bmb_file,bmc_file WHERE",
                   " bmb01=bmc01 AND bmb02=bmc02 AND bmb29=bmc06 ",
                   "  AND bmb03=bmc021 AND bmb04=bmc03 AND ",
                   g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " INTO TEMP x"
    END IF
    DROP TABLE x                                                                                                                     
    PREPARE i603_pre_x FROM g_temp                                                                                                   
    EXECUTE i603_pre_x                                                                                                               
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i603_precount FROM g_sql
    DECLARE i603_count CURSOR FOR i603_precount
    #No.TQC-960268--end
END FUNCTION
 
 
FUNCTION i603_menu()
 
   WHILE TRUE
      CALL i603_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i603_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i603_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i603_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i603_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmb.bmb01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmb01"
                  LET g_doc.value1  = g_bmb.bmb01
                  LET g_doc.column2 = "bmb02"
                  LET g_doc.value2  = g_bmb.bmb02
                  LET g_doc.column3 = "bmb03"
                  LET g_doc.value3  = g_bmb.bmb03
                  LET g_doc.column4 = "bmb04"
                  LET g_doc.value4  = g_bmb.bmb04
                  LET g_doc.column5 = "bmb29"           #FUN-550014
                  LET g_doc.value5  = g_bmb.bmb29       #FUN-550014
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i603_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmb.* TO NULL            #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bmc.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i603_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmb.* TO NULL
        RETURN
    END IF
    OPEN i603_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL
    ELSE
        OPEN i603_count
        FETCH i603_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i603_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i603_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1        #處理方式    #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i603_cs INTO g_bmb.bmb01,
                                                              g_bmb.bmb02,
                                                              g_bmb.bmb03,
                                                              g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 #TQC-870018
        WHEN 'P' FETCH PREVIOUS i603_cs INTO g_bmb.bmb01,
                                                              g_bmb.bmb02,
                                                              g_bmb.bmb03,
                                                              g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 #TQC-870018
        WHEN 'F' FETCH FIRST    i603_cs INTO g_bmb.bmb01,
                                                              g_bmb.bmb02,
                                                              g_bmb.bmb03,
                                                              g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 #TQC-870018
        WHEN 'L' FETCH LAST     i603_cs INTO g_bmb.bmb01,
                                                              g_bmb.bmb02,
                                                              g_bmb.bmb03,
                                                              g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 #TQC-870018
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i603_cs INTO g_bmb.bmb01,
                                                              g_bmb.bmb02,
                                                              g_bmb.bmb03,
                                                              g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 #TQC-870018
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_bmb.* FROM bmb_file WHERE bmb01 = g_bmb.bmb01 AND bmb02 = g_bmb.bmb02 AND bmb03 = g_bmb.bmb03 AND bmb04 = g_bmb.bmb04 AND bmb29 = g_bmb.bmb29
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02
                  CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) # TQC-660046
        CALL cl_err3("sel","bmb_file",g_msg,"",SQLCA.sqlcode,"","",1) # TQC-660046    
        INITIALIZE g_bmb.* TO NULL
        RETURN
    END IF
    CALL i603_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i603_show()
    DEFINE l_ima02   LIKE ima_file.ima02
    DEFINE l_ima021  LIKE ima_file.ima021
 
    LET g_bmb_t.* = g_bmb.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 #FUN-550014
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=g_bmb.bmb01
    DISPLAY l_ima02 TO FORMONLY.ima02_1
    DISPLAY l_ima021 TO FORMONLY.ima021_1
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=g_bmb.bmb03
    DISPLAY l_ima02 TO FORMONLY.ima02_2
    DISPLAY l_ima021 TO FORMONLY.ima021_2
    CALL i603_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i603_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態   #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否   #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否   #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0)  THEN RETURN END IF
    IF g_bmb.bmb01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT bmc04,bmc05 ",
      "   FROM bmc_file ",
      "    WHERE bmc01  = ? ",
      "    AND bmc02  = ? ",
      "    AND bmc021 = ? ",
      "    AND bmc03  = ? ",
      "    AND bmc04  = ? ",
      "    AND bmc06  = ? ",   #FUN-550014
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i603_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmc
              WITHOUT DEFAULTS
              FROM s_bmc.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bmc_t.* = g_bmc[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
                OPEN i603_bcl USING g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmc_t.bmc04,g_bmb.bmb29 #FUN-550014
                IF STATUS THEN
                    CALL cl_err("OPEN i603_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i603_bcl INTO g_bmc[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmc_t.bmc04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmc04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bmc_file(bmc01,bmc02,bmc021,
                                 bmc03,bmc04,bmc05,bmc06)                       #FUN-550014
            VALUES(g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,
                   g_bmb.bmb04,g_bmc[l_ac].bmc04,g_bmc[l_ac].bmc05,g_bmb.bmb29) #FUN-550014
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bmc[l_ac].bmc04,SQLCA.sqlcode,0) # TQC-660046
               CALL cl_err3("ins","bmc_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.sqlcode,"","",1) # TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmc[l_ac].* TO NULL      #900423
            LET g_bmc_t.* = g_bmc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmc04
 
        BEFORE FIELD bmc04                        #default 序號
            IF g_bmc[l_ac].bmc04 IS NULL OR
               g_bmc[l_ac].bmc04 = 0 THEN
                SELECT max(bmc04)+1
                   INTO g_bmc[l_ac].bmc04
                   FROM bmc_file
                   WHERE bmc01 = g_bmb.bmb01 AND bmc02 = g_bmb.bmb02 AND
                         bmc021 = g_bmb.bmb03 AND bmc03 = g_bmb.bmb04
                         AND bmc06 = g_bmb.bmb29  #MOD-860127 add 
                IF g_bmc[l_ac].bmc04 IS NULL THEN
                    LET g_bmc[l_ac].bmc04 = 1
                END IF
            END IF
 
        AFTER FIELD bmc04                        #check 序號是否重複
            IF g_bmc[l_ac].bmc04 != g_bmc_t.bmc04 OR
               g_bmc_t.bmc04 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM bmc_file
                    WHERE bmc01 = g_bmb.bmb01 AND bmc02 = g_bmb.bmb02 AND
                          bmc021 = g_bmb.bmb03 AND bmc03 = g_bmb.bmb04 AND
                          bmc04 = g_bmc[l_ac].bmc04
                          AND bmc06 = g_bmb.bmb29  #MOD-860127 add 
                IF l_n > 0 THEN
                    CALL cl_err(g_bmc[l_ac].bmc04,-239,0)
                    LET g_bmc[l_ac].bmc04 = g_bmc_t.bmc04
                    NEXT FIELD bmc04
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmc_t.bmc04 > 0 AND
               g_bmc_t.bmc04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bmc_file
                    WHERE bmc01  = g_bmb.bmb01
                      AND bmc02  = g_bmb.bmb02
                      AND bmc021 = g_bmb.bmb03
                      AND bmc03  = g_bmb.bmb04
                      AND bmc04  = g_bmc_t.bmc04
                      AND bmc06  = g_bmb.bmb29 #FUN-550014
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmc_t.bmc04,SQLCA.sqlcode,0) # TQC-660046
                    CALL cl_err3("del","bmc_file",g_bmb.bmb01,g_bmc_t.bmc04,SQLCA.sqlcode,"","",1) # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
	        COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmc[l_ac].* = g_bmc_t.*
               CLOSE i603_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmc[l_ac].bmc04,-263,1)
               LET g_bmc[l_ac].* = g_bmc_t.*
            ELSE
                UPDATE bmc_file SET
                   bmc04 = g_bmc[l_ac].bmc04,
                   bmc05 = g_bmc[l_ac].bmc05
                 WHERE bmc01 = g_bmb.bmb01
                   AND bmc02 = g_bmb.bmb02
                   AND bmc021= g_bmb.bmb03
                   AND bmc03 = g_bmb.bmb04
                   AND bmc04 = g_bmc_t.bmc04
                   AND bmc06 = g_bmb.bmb29 #FUN-550014
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmc[l_ac].bmc04,SQLCA.sqlcode,0) # TQC-660046
                    CALL cl_err3("upd","bmc_file",g_bmb.bmb01,g_bmc_t.bmc04,SQLCA.sqlcode,"","",1) # TQC-660046
                    LET g_bmc[l_ac].* = g_bmc_t.*
                ELSE
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
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmc[l_ac].* = g_bmc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i603_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_bmc_t.* = g_bmc[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i603_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i603_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmc04) AND l_ac > 1 THEN
                LET g_bmc[l_ac].* = g_bmc[l_ac-1].*
                NEXT FIELD bmc04
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
    CLOSE i603_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i603_b_askkey()
DEFINE
   #l_wc2           STRING #TQC-630166
    l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON bmc04,bmc05
            FROM s_bmc[1].bmc04,s_bmc[1].bmc05
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i603_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i603_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           STRING #TQC-630166   
    p_wc2           STRING    #TQC-630166
 
    LET g_sql =
        "SELECT bmc04,bmc05",
        " FROM bmc_file",
        " WHERE bmc01 ='",g_bmb.bmb01,"' AND",  #單頭-1
             #" bmc02 ='",g_bmb.bmb02,"' AND",  #單頭-2    #TQC-AB0041
              " bmc02 = ",g_bmb.bmb02,"  AND",             #TQC-AB0041 
              " bmc021='",g_bmb.bmb03,"' AND",  #單頭-3
              " bmc03 ='",g_bmb.bmb04,"' AND ",  #單頭-4
              " bmc06 ='",g_bmb.bmb29,"' AND ",  #FUN-550014 add
        p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i603_pb FROM g_sql
    DECLARE bmc_cs                       #SCROLL CURSOR
        CURSOR FOR i603_pb
 
    CALL g_bmc.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bmc_cs INTO g_bmc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #CKP
    CALL g_bmc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i603_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmc TO s_bmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i603_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i603_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i603_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i603_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i603_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i603_copy()
DEFINE
    l_oldno1         LIKE bmb_file.bmb01,
    l_oldno2         LIKE bmb_file.bmb02,
    l_oldno3         LIKE bmb_file.bmb03,
    l_oldno4         LIKE bmb_file.bmb04,
    l_newno1         LIKE bmb_file.bmb01,
    l_newno2         LIKE bmb_file.bmb02,
    l_newno3         LIKE bmb_file.bmb03,
    l_newno4         LIKE bmb_file.bmb04
 
    IF s_shut(0)  THEN RETURN END IF
    IF g_bmb.bmb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" TO bmb01
    DISPLAY "" TO bmb02
    DISPLAY "" TO bmb03
    DISPLAY "" TO bmb04
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT l_newno1,l_newno2,l_newno3,l_newno4 FROM bmb01,bmb02,bmb03,bmb04
        BEFORE FIELD bmb01
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(6,27,l_newno1) RETURNING l_newno1
	               DISPLAY l_newno1 TO bmb01
	       END IF
 
        AFTER FIELD bmb01
            IF l_newno1 IS NULL THEN
                NEXT FIELD bmb01
            END IF
            #FUN-AA0059 --------------------------add start----------------
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmb01
            END IF 
            #FUN-AA0059 -----------------------add end---------------------------  
	    SELECT * FROM ima_file WHERE ima01 = l_newno1
	    IF SQLCA.sqlcode THEN
#		CALL cl_err(l_newno1,'mfg0002',0)  TQC-660046
                CALL cl_err3("sel","ima_file",l_newno1,"","mfg0002","","",1) # TQC-660046
                NEXT FIELD bmb01
	    END IF
 
        BEFORE FIELD bmb02
	       IF g_sma.sma60 = 'Y'		# 若須分段輸入
	          THEN CALL s_inp5(7,27,l_newno2) RETURNING l_newno2
	               DISPLAY l_newno2 TO bmb02
	       END IF
 
        AFTER FIELD bmb02
            IF l_newno2 IS NULL THEN
                NEXT FIELD bmb02
            END IF
 
        AFTER FIELD bmb03
            IF l_newno3 IS NULL THEN
                NEXT FIELD bmb03
            END IF
            #FUN-AA0059 --------------------------add start------------------
            IF NOT s_chk_item_no(l_newno3,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmb03
            END IF 
            #FUN-AA0059 --------------------------add end----------------------  
	    SELECT * FROM ima_file WHERE ima01 = l_newno3
	    IF SQLCA.sqlcode THEN
#		CALL cl_err(l_newno3,'mfg0002',0) TQC-660046
                CALL cl_err3("sel","ima_file",l_newno3,"","mfg0002","","",1) # TQC-660046
                NEXT FIELD bmb03
	    END IF
 
        AFTER FIELD bmb04
            IF l_newno4 IS NULL THEN
                NEXT FIELD bmb04
            END IF
            SELECT bmb01 FROM bmb_file       #判斷元件資料是否存在
                WHERE bmb01 = l_newno1 AND bmb02 = l_newno2 AND
                      bmb03 = l_newno3 AND bmb04 = l_newno4
            IF SQLCA.sqlcode THEN
                LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',l_newno3
                            CLIPPED,'+',l_newno4
#               CALL cl_err(g_msg,'mfg2631',0) TQC-660046
                CALL cl_err3("sel","bmb_file",g_msg,"","mfg2631","","",1) # TQC-660046
                NEXT FIELD bmb01
            END IF
#.,+3s/bmb/bmc/g may modify
            SELECT count(*) INTO g_cnt FROM bmc_file     #check 是否重覆
                WHERE bmc01 = l_newno1 AND bmc02 = l_newno2 AND
                      bmc03 = l_newno3 AND bmc04 = l_newno4
            IF g_cnt > 0 THEN
                LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',l_newno3
                            CLIPPED,'+',l_newno4
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD bmb01
            END IF
#TQC-790039.....begin
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmb01)
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form = "q_ima"
               #  LET g_qryparam.state = 'c'
               #  CALL cl_create_qry() RETURNING l_newno1
                 CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING l_newno1  
#FUN-AA0059 --End--
                 DISPLAY l_newno1 TO bmb01
                 NEXT FIELD bmb01
           END CASE
#TQC-790039.....end
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
        DISPLAY BY NAME g_bmb.bmb01
        DISPLAY BY NAME g_bmb.bmb02
        DISPLAY BY NAME g_bmb.bmb03
        DISPLAY BY NAME g_bmb.bmb04
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM bmb_file         #單頭複製
        WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02
           AND bmb03=g_bmb.bmb03 AND bmb04 = g_bmb.bmb04
        INTO TEMP y
    UPDATE y
        SET y.bmb01=l_newno1,   #新的鍵值-1
            y.bmb02=l_newno2,   #新的鍵值-2
            y.bmb03=l_newno3,   #新的鍵值-3
            y.bmb04=l_newno4    #新的鍵值-4
 
    INSERT INTO bmb_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM bmc_file         #單身複製
        WHERE bmc01=g_bmb.bmb01 AND bmc02=g_bmb.bmb02 AND
              bmc021=g_bmb.bmb03 AND bmc03=g_bmb.bmb04
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02 CLIPPED,
                  '+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) TQC-660046
        CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1) # TQC-660046
        RETURN
    END IF
    UPDATE x
        SET bmc01=l_newno1, bmc02=l_newno2, bmc021=l_newno3,
            bmc03=l_newno4
    INSERT INTO bmc_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02 CLIPPED,'+',
                  g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) TQC-660046
        CALL cl_err3("ins","bmc_file",g_msg,"",SQLCA.sqlcode,"","",1) # TQC-660046
        RETURN
    END IF
    LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',
              l_newno3 CLIPPED,'+',l_newno4
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
    DISPLAY BY NAME g_bmb.bmb01
    DISPLAY BY NAME g_bmb.bmb02
    DISPLAY BY NAME g_bmb.bmb03
    DISPLAY BY NAME g_bmb.bmb04
    LET l_oldno1 = g_bmb.bmb01
    LET l_oldno2 = g_bmb.bmb02
    LET l_oldno3 = g_bmb.bmb03
    LET l_oldno4 = g_bmb.bmb04
    LET g_bmb.bmb01 = l_newno1
    LET g_bmb.bmb02 = l_newno2
    LET g_bmb.bmb03 = l_newno3
    LET g_bmb.bmb04 = l_newno4
    SELECT bmd01,bmd02,bmd03,bmd04
      INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04
      FROM bmd_file WHERE bmd01 = l_newno1 AND bmb02 = l_newno2
                      AND bmb03 = l_newno3 AND bmb04 = l_newno4
                      AND bmdacti = 'Y'                                           #CHI-910021
    CALL i603_show()
    CALL i603_b()
    #FUN-C30027---begin
    #LET g_bmb.bmb01 = l_oldno1
    #LET g_bmb.bmb02 = l_oldno2
    #LET g_bmb.bmb03 = l_oldno3
    #LET g_bmb.bmb04 = l_oldno4
    #SELECT bmd01,bmd02,bmd03,bmd04
    #  INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04
    #  FROM bmd_file WHERE bmd01 = l_oldno1 AND bmb02 = l_oldno2
    #                  AND bmb03 = l_oldno3 AND bmb04 = l_oldno4
    #                  AND bmdacti = 'Y'                                           #CHI-910021
    #CALL i603_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i603_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmb01       LIKE bmb_file.bmb01,   #主件編號
        bmb02       LIKE bmb_file.bmb02,   #項次
        bmb03       LIKE bmb_file.bmb03,   #元件編號
        bmb04       LIKE bmb_file.bmb04,   #生效日
        bmc04       LIKE bmc_file.bmc04,   #行序
        bmc05       LIKE bmc_file.bmc05    #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
    DEFINE l_ima02_a    LIKE ima_file.ima02  #FUN-770052                                                                            
    DEFINE l_ima021_a   LIKE ima_file.ima021 #FUN-770052                                                                            
    DEFINE l_ima02_b    LIKE ima_file.ima02  #FUN-770052                                                                            
    DEFINE l_ima021_b   LIKE ima_file.ima021 #FUN-770052                                                                            
    DEFINE l_sql        STRING               #FUN-770052 
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','abm-730',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'abmi603.out'
#   CALL cl_outnam('abmi603') RETURNING l_name                       #FUN-770052
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                     
    CALL cl_del_data(l_table)                                                                                                       
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                               
    #------------------------------ CR (2) ------------------------------#  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmc04,bmc05 ",
          " FROM bmb_file,bmc_file ",
          " WHERE bmc01=bmb01 AND bmc02=bmb02 ",
          " AND bmc021=bmb03 AND bmc03=bmb04 ",
          " AND bmb04=bmc03",
          " AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i603_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i603_co                         # CURSOR
        CURSOR FOR i603_p1
 
#   START REPORT i603_rep TO l_name                                 #FUN-770052
 
    FOREACH i603_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
     #--NO.FUN-770052--begin--#
            SELECT ima02,ima021 INTO l_ima02_a,l_ima021_a                                                                           
              FROM ima_file                                                                                                         
             WHERE ima01 = sr.bmb01                                                                                                 
            IF SQLCA.sqlcode THEN                                                                                                   
                LET l_ima02_a  = NULL                                                                                               
                LET l_ima021_a = NULL                                                                                               
            END IF                                                                                                                  
            SELECT ima02,ima021 INTO l_ima02_b,l_ima021_b                                                                           
              FROM ima_file                                                                                                         
             WHERE ima01 = sr.bmb03                                                                                                 
            IF SQLCA.sqlcode THEN                                                                                                   
                LET l_ima02_b  = NULL                                                                                               
                LET l_ima021_b = NULL                                                                                               
            END IF 
      #--NO.FUN-770052--end--# 
#       OUTPUT TO REPORT i603_rep(sr.*)                             #FUN-770052
    ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                       
           EXECUTE insert_prep USING                                                                                                
                   sr.bmb01,l_ima02_a,l_ima021_a,sr.bmb02,sr.bmb03,                                                                
                   l_ima02_b,l_ima021_b,sr.bmb04,sr.bmc04,sr.bmc05                                                                  
        #------------------------------ CR (3) ------------------------------# 
    END FOREACH
 
#   FINISH REPORT i603_rep                                          #FUN-770052
 
    CLOSE i603_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)                               #FUN-770052
 
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'bmb01,bmb29,bmb02,bmb03,bmb04')                                                                                      
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                     
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_wc                                                                                                                
    CALL cl_prt_cs3('abmi603','abmi603',l_sql,g_str)        #FUN-770052                                                             
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
