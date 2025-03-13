# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi650.4gl
# Descriptions...: 元件廠商資料維護
# Date & Author..: 93/01/11 By Lee
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/12 By douzh 修改cl_err()
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6C0221 06/12/29 By day "主要供應商"報錯信息有誤
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730082 07/03/22 By Ray 單身"預設上筆資料"后，確定未保存
# Modify.........: No.TQC-750041 07/05/16 By mike 報表格式修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/07/08 By xiaofeizhu 制作水晶報表
# Modify.........: No.TQC-790039 07/09/18 By Judy 復制時，"主件編號"和"元件編號"無法開窗
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-880052 09/01/13 By Arman 增加打印條件中單身字段
# Modify.........: No.FUN-930108 09/03/30 By zhaijie若此作業可錄入資料,則增加判斷此料件是否需要AVL,需要才可輸入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0084 09/10/21 By Smapmin 將CALL abmi604中,update bmb_file的動作,移到CALL abmi604之後才做
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30023 10/03/05 By lilingyu 新增單身資料時,"主要供應商名稱"未能根據供應商編號即時顯示在畫面上
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C40231 12/04/25 By fengrui BUG修改,連續刪除報-400錯誤、刪除后總筆數等於零時報無上下筆資料錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bml01         LIKE bml_file.bml01,    #規格主鍵編號 (假單頭)
    g_bml02         LIKE bml_file.bml02,    #規格主鍵編號 (假單頭)
    g_bml01_t       LIKE bml_file.bml01,    #特性料件編號 (舊值)
    g_bml02_t       LIKE bml_file.bml02,    #特性料件編號 (舊值)
    l_cnt           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
    l_cnt1          LIKE type_file.num5,    #No.FUN-680096 SMALLINT
    l_cmd           LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(100)
    g_bml           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        bml03       LIKE bml_file.bml03,    #行序
        bml04       LIKE bml_file.bml04,    #條件編號
        mse02       LIKE mse_file.mse02,
        bmj10       LIKE bmj_file.bmj10,    #承認文號
        bmj11       LIKE bmj_file.bmj11,    #承認日期
        wdesc       LIKE aab_file.aab02,    #狀態
        bml06       LIKE bml_file.bml06,    #主要供應商
        pmc03       LIKE pmc_file.pmc03
                    END RECORD,
    g_bml_t         RECORD                  #程式變數 (舊值)
        bml03       LIKE bml_file.bml03,    #行序
        bml04       LIKE bml_file.bml04,    #條件編號
        mse02       LIKE mse_file.mse02,
        bmj10       LIKE bmj_file.bmj10,    #承認文號
        bmj11       LIKE bmj_file.bmj11,    #承認日期
        wdesc       LIKE aab_file.aab02,    #狀態
        bml06       LIKE bml_file.bml06,    #主要供應商
        pmc03       LIKE pmc_file.pmc03
                    END RECORD,
    g_bml04_o       LIKE bml_file.bml04,
   #g_wc,g_wc2,g_sql    STRING,             #TQC-630166   #No.FUN-680096
    g_wc,g_wc2,g_sql    STRING,             #TQC-630166
    g_delete        LIKE type_file.chr1,    #若刪除資料,則要重新顯示筆數  #No.FUN-680096  VARCHAR(1)
    g_rec_b         LIKE type_file.num5,    #單身筆數   #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_succ          LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_comp          LIKE bml_file.bml01,
    g_item          LIKE bml_file.bml02,
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-680096  SMALLINT
DEFINE   l_table         STRING,                     ### FUN-770052 ###                                                             
         g_str           STRING                      ### FUN-770052 ###
 
 
#主程式開始
DEFINE g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
MAIN
# DEFINE                                     #No.FUN-6A0060 
#       l_time    LIKE type_file.chr8        #No.FUN-6A0060
 
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
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "bml01.bml_file.bml01,",
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",
                "bml02.bml_file.bml02,",                                                                                          
                "ima02s.ima_file.ima02,",                                                                                           
                "ima021s.ima_file.ima021,",
                "bml03.bml_file.bml03,",
                "bml04.bml_file.bml04,",  
                "bmj10.bmj_file.bmj10"                                                                         
    LET l_table = cl_prt_temptable('abmi650',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                       
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------# 
    LET g_bml01 = NULL                     #清除鍵值
    LET g_bml02 = NULL                     #清除鍵值
    LET g_bml01_t = NULL
    LET g_bml02_t = NULL
    #取得參數
    LET g_comp=ARG_VAL(1)	#元件
    IF g_comp=' ' THEN LET g_comp='' ELSE LET g_bml01=g_comp END IF
    LET g_item=ARG_VAL(2)	#主件
    IF g_item=' ' THEN LET g_item='' ELSE LET g_bml02=g_item END IF
    LET p_row = 4 LET p_col = 8
 
    OPEN WINDOW i650_w AT  p_row,p_col            #顯示畫面
         WITH FORM "abm/42f/abmi650"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #No.FUN-6C0055 --start--
    IF g_aza.aza71 MATCHES '[Yy]' THEN 
       CALL aws_gpmcli_toolbar()
       CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
    ELSE
       CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
    END IF
    #No.FUN-6C0055 --end--
 
    IF g_comp IS NOT NULL	#有傳入參數, 則將已存在的資料顯示出來
    THEN CALL i650_q()
         IF g_succ='N' THEN
            IF cl_chk_act_auth() THEN
               CALL i650_a()
            END IF
         END IF
    END IF
    LET g_delete='N'
    CALL i650_menu()
    CLOSE WINDOW i650_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i650_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
	IF g_comp IS NULL THEN
    	CLEAR FORM                             #清除畫面
        CALL g_bml.clear()
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bml02 TO NULL    #No.FUN-750051
   INITIALIZE g_bml01 TO NULL    #No.FUN-750051
    	CONSTRUCT g_wc ON bml01,bml02          #螢幕上取條件
        	FROM bml01,bml02
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bml01)
                 #CALL q_bmb2(10,3,'','') RETURNING g_bml02,g_bml01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmb201"
                  LET g_qryparam.arg1 = g_today
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bml01
                  NEXT FIELD bml01
                WHEN INFIELD(bml02)
                 #CALL q_bma1(10,3,g_bml02,'') RETURNING g_bml02
      		  IF g_bml02 IS NULL THEN
	             LET g_bml02 = g_bml02_t
       	  	  END IF
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma101"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bml02
                  NEXT FIELD bml02
                OTHERWISE
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
 
        CONSTRUCT g_wc2 ON bml03,bml04,bml06
                FROM s_bml[1].bml03,s_bml[1].bml04,s_bml[1].bml06
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(bml04)      #廠牌
#                 CALL q_mse(0,0,g_bml[1].bml04) RETURNING g_bml[1].bml04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_mse"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bml04
                  NEXT FIELD bml04
             WHEN INFIELD(bml06)
#                 CALL q_pmc1(0,0,g_bml[1].bml06) RETURNING g_bml[1].bml06
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bml06
                  NEXT FIELD bml06
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
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    	IF INT_FLAG THEN RETURN END IF
	ELSE
		LET g_wc=" bml01='",g_comp,"'"
		IF g_item IS NOT NULL THEN
			LET g_wc=g_wc CLIPPED," AND bml02='",g_item,"'"
		END IF
                LET g_wc2 = "1=1"
	END IF
 
    LET g_sql="SELECT UNIQUE bml02,bml01 FROM bml_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               "   AND ", g_wc2 CLIPPED,
               " ORDER BY bml01,bml02"
    PREPARE i650_prepare FROM g_sql      #預備一下
    DECLARE i650_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i650_prepare
    LET g_sql="SELECT UNIQUE bml01,bml02 ",
              "  FROM bml_file WHERE ", g_wc CLIPPED,
              " GROUP BY bml01,bml02 "
    PREPARE i650_precount FROM g_sql
    DECLARE i650_count CURSOR FOR i650_precount
END FUNCTION
 
 
FUNCTION i650_menu()
   #No.FUN-6C0055 --start--
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   #No.FUN-6C0055 --end--
   DEFINE l_n          LIKE type_file.num5   #MOD-9A0084
   DEFINE l_bmd02      LIKE bmd_file.bmd02   #MOD-9A0084
 
   WHILE TRUE
      CALL i650_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i650_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i650_q()
            END IF
            LET g_comp=''
            LET g_item=''
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i650_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i650_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i650_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i650_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "UTE/S"
         WHEN "rep_sub"
            IF cl_chk_act_auth() THEN
               LET l_cmd="abmi604 '",g_bml01,"' '",g_bml02,"'"
               #-----MOD-9A0084---------
               #CALL cl_cmdrun(l_cmd)   
               CALL cl_cmdrun_wait(l_cmd)  
               
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM bmd_file 
                WHERE bmd01=g_bml01  
                  AND bmdacti = 'Y'               
               IF l_n = 0 THEN
                  UPDATE bmb_file SET bmb16 = '0',
                                      bmbdate=g_today     #FUN-C40007 add
                   WHERE bmb01=g_bml02 AND bmb03=g_bml01
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","bmb_file",g_bml02,g_bml01,SQLCA.sqlcode,"","",0)
                   END IF
               ELSE 
                  LET l_bmd02 = ''
                  SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                     WHERE bmd01=g_bml01 AND bmd08 = g_bml02 
                       AND bmdacti = 'Y' 
                  IF NOT cl_null(l_bmd02) THEN
                     UPDATE bmb_file SET bmb16 = l_bmd02,
                                         bmbdate=g_today     #FUN-C40007 add
                      WHERE bmb01=g_bml02 AND bmb03=g_bml01
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","bmb_file",g_bml02,g_bml01,SQLCA.sqlcode,"","",0)
                     END IF
                  ELSE
                     LET l_bmd02 = ''
                     SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
                        WHERE bmd01=g_bml01 AND bmd08 = 'ALL' 
                          AND bmdacti = 'Y' 
                     IF NOT cl_null(l_bmd02) THEN
                        UPDATE bmb_file SET bmb16 = l_bmd02 ,
                                            bmbdate=g_today     #FUN-C40007 add
                         WHERE bmb01=g_bml02 AND bmb03=g_bml01
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","bmb_file",g_bml02,g_bml01,SQLCA.sqlcode,"","",0)
                        END IF
                     END IF
                  END IF  
               END IF 
               #-----END MOD-9A0084-----
            END IF
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bml01 IS NOT NULL THEN
                  LET g_doc.column1 = "bml01"
                  LET g_doc.value1  = g_bml01
                  LET g_doc.column2 = "bml02"
                  LET g_doc.value2  = g_bml02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bml),'','')
            END IF
 
         #No.FUN-6C0055 --start--
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_supplierid = g_bml[l_ac].bml06 END IF
              LET l_partnum = g_bml01
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_supplierid = g_bml[l_ac].bml06 END IF
              LET l_partnum = g_bml01
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
        #No.FUN-6C0055 --end--
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i650_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bml.clear()
    INITIALIZE g_bml01 LIKE bml_file.bml01
    INITIALIZE g_bml02 LIKE bml_file.bml02
    IF g_comp IS NOT NULL THEN LET g_bml01=g_comp
    DISPLAY g_bml01 TO bml01 END IF
    IF g_item IS NOT NULL THEN LET g_bml02=g_item
    DISPLAY g_bml02 TO bml02 END IF
    LET g_bml01_t = NULL
    LET g_bml02_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        IF g_comp IS NULL THEN
           CALL i650_i("a")                   #輸入單頭
           IF INT_FLAG THEN                   #使用者不玩了
              LET g_bml01 = NULL
              LET INT_FLAG = 0
              CALL cl_err('',9001,0)
              EXIT WHILE
           END IF
        ELSE
           CALL i650_bml01('d')
           IF g_errno='mfg9116' THEN CALL cl_err('',g_errno,1) END IF
           CALL i650_bml02('d')
        END IF
        CALL g_bml.clear()
        LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i650_b()                   #輸入單身
        LET g_bml01_t = g_bml01            #保留舊值
        LET g_bml02_t = g_bml02            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i650_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bml01 IS NULL OR g_bml02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bml01_t = g_bml01
    LET g_bml02_t = g_bml02
    WHILE TRUE
        CALL i650_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bml01=g_bml01_t
            LET g_bml02=g_bml02_t
            DISPLAY g_bml01 TO bml01      #單頭
            DISPLAY g_bml02 TO bml02      #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bml01 != g_bml01_t OR g_bml02 != g_bml02_t THEN #更改單頭值
            UPDATE bml_file SET bml01 = g_bml01,  #更新DB
		                bml02 = g_bml02
                WHERE bml01 = g_bml01_t          #COLAUTH?
	          AND bml02 = g_bml02_t
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_bml01 CLIPPED,' + ', g_bml02 CLIPPED
#               CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.TQC-660046
                CALL cl_err3("upd","bml_file",g_bml01_t,g_bml02_t,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i650_i(p_cmd)
DEFINE
    p_cmd      LIKE type_file.chr1,      #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
    l_bmb02    LIKE bmb_file.bmb02,
    l_bmb04    LIKE bmb_file.bmb04,
    l_bml04    LIKE bml_file.bml04
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bml01, g_bml02
        WITHOUT DEFAULTS
        FROM bml01,bml02
 
	    BEFORE FIELD bml01  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(8,29,g_bml01) RETURNING g_bml01
	            DISPLAY g_bml01 TO bml01
	    END IF
 
        AFTER FIELD bml01            #元件編號
            IF NOT cl_null(g_bml01) THEN
                #FUN-AA0059 ---------------------------add start---------------------------
                IF NOT s_chk_item_no(g_bml01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bml01 = g_bml01_t
                   DISPLAY g_bml01 TO bml01
                   NEXT FIELD bml01
                END IF 
                #FUN-AA0059 ---------------------------add end-----------------------------
                IF g_bml01 != g_bml01_t OR g_bml01_t IS NULL THEN
                    CALL i650_bml01('a')
                    IF NOT cl_null(g_errno) THEN
                       IF g_errno='mfg9116' THEN
                          IF NOT cl_confirm(g_errno)
                          THEN NEXT FIELD bml01
                          END IF
                       ELSE
                          CALL cl_err(g_bml01,g_errno,0)
                          LET g_bml01 = g_bml01_t
                          DISPLAY g_bml01 TO bml01
                          NEXT FIELD bml01
                       END IF
                    END IF
                END IF
            END IF
 
	    BEFORE FIELD bml02   # 是否可以修改 key
	    IF g_sma.sma60 = 'Y' # 若須分段輸入
	       THEN CALL s_inp5(11,29,g_bml02) RETURNING g_bml02
	            DISPLAY g_bml02 TO bml02
	    END IF
 
        AFTER FIELD bml02            #主件編號
            IF NOT cl_null(g_bml02) THEN
                #FUN-AA0059 --------------------------add start-------------------------
                IF NOT s_chk_item_no(g_bml02,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bml02 = g_bml02_t
                   DISPLAY g_bml02 TO bml02
                   NEXT FIELD bml02
                END IF 
                #FUN-A0059 --------------------------add end----------------------------
                IF g_bml02 IS NOT NULL AND
                   (g_bml01!=g_bml01_t OR g_bml02!=g_bml02_t
                    OR g_bml02_t IS NULL)
                    THEN                         # 若輸入或更改且改KEY
                    CALL i650_bml02('a')
                    IF NOT cl_null(g_errno) THEN
                       	CALL cl_err(g_bml02,g_errno,0)
                       	LET g_bml02 = g_bml02_t
                       	DISPLAY g_bml02 TO bml02
                       	NEXT FIELD bml02
	            		END IF
                    SELECT count(*) INTO g_cnt FROM bml_file
                        WHERE bml01 = g_bml01
                          AND bml02 = g_bml02
                    IF g_cnt > 0 THEN   #資料重複
	                LET g_msg = g_bml01 CLIPPED,' + ', g_bml02 CLIPPED
                        CALL cl_err(g_msg,-239,0)
                        LET g_bml01 = g_bml01_t
                        LET g_bml02 = g_bml02_t
                        DISPLAY  g_bml01 TO bml01
                        DISPLAY  g_bml02 TO bml02
                        NEXT FIELD bml01
                    END IF
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bml01)
                 #CALL q_bmb2(10,3,'','') RETURNING g_bml02,g_bml01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmb201"
                  LET g_qryparam.arg1 = g_today
                  CALL cl_create_qry() RETURNING g_bml02,g_bml01
                  #DISPLAY BY NAME g_bml01,g_bml02             #No.MOD-490371  #FUN-930108 mark
                  DISPLAY g_bml01,g_bml02 TO bml01,bml02       #FUN-930108 mod
                  CALL i650_bml01('d')
                  NEXT FIELD bml01
                WHEN INFIELD(bml02)
                 #CALL q_bma1(10,3,g_bml02,'') RETURNING g_bml02
      		  IF g_bml02 IS NULL THEN
	             LET g_bml02 = g_bml02_t
       	  	  END IF
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma101"
                  LET g_qryparam.default1 = g_bml02
                  CALL cl_create_qry() RETURNING g_bml02
                  #DISPLAY BY NAME g_bml02       #FUN-930108 mark
                  DISPLAY g_bml02 TO bml02       #FUN-930108 mod
                  CALL i650_bml02('d')
                  NEXT FIELD bml02
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
FUNCTION i650_bml01(p_cmd)  #規格主件編號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           l_ima926  LIKE ima_file.ima926,   #FUN-930108 add ima926
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima05,ima08,imaacti,ima926      #FUN-930108 add ima926
           INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti,l_ima926  #FUN-930108 add ima926
           FROM ima_file WHERE ima01 = g_bml01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima05 = NULL
                            LET l_ima021 = NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         WHEN l_ima926 != 'Y' LET g_errno = '9088'     #FUN-930108
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    SELECT COUNT(*) INTO l_cnt FROM bmb_file
        WHERE bmb03=g_bml01
    IF l_cnt=0 THEN LET g_errno='mfg5070' END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h
           DISPLAY l_ima021 TO FORMONLY.ima021_h
           DISPLAY l_ima05 TO FORMONLY.ima05_h
           DISPLAY l_ima08 TO FORMONLY.ima08_h
    END IF
END FUNCTION
 
FUNCTION i650_bml02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
      LET g_errno = ' '
      IF g_bml02=g_bml01 THEN LET g_errno='mfg2633' RETURN END IF
      IF g_bml02='all' THEN
         LET g_bml02='ALL'
         DISPLAY g_bml02 TO bml02
      END IF
      IF g_bml02='ALL' THEN
         DISPLAY '' TO FORMONLY.ima02_h2
         DISPLAY '' TO FORMONLY.ima021_h2
         DISPLAY '' TO FORMONLY.ima05_h2
         DISPLAY '' TO FORMONLY.ima08_h2
         RETURN
      END IF
    SELECT ima02,ima021,ima05,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bml02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima05 = NULL
                            LET l_ima021= NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    SELECT COUNT(*) INTO l_cnt FROM bmb_file
        WHERE bmb03=g_bml01 AND bmb01=g_bml02
    IF l_cnt=0 THEN LET g_errno='mfg5070' END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h2
           DISPLAY l_ima021 TO FORMONLY.ima021_h2
           DISPLAY l_ima05 TO FORMONLY.ima05_h2
           DISPLAY l_ima08 TO FORMONLY.ima08_h2
    END IF
    IF NOT cl_null(g_errno) THEN
      DISPLAY '' TO FORMONLY.ima02_h2
      DISPLAY '' TO FORMONLY.ima021_h2
      DISPLAY '' TO FORMONLY.ima05_h2
      DISPLAY '' TO FORMONLY.ima08_h2
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i650_q()
  DEFINE l_bml01  LIKE bml_file.bml01,
         l_bml02  LIKE bml_file.bml02,
         l_cnt    LIKE type_file.num10   #No.FUN-680096  INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bml01 TO NULL        #No.FUN-6A0002
    INITIALIZE g_bml02 TO NULL        #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i650_cs()                    #取得查詢條件
    IF INT_FLAG THEN                  #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bml01 TO NULL
        INITIALIZE g_bml02 TO NULL
        RETURN
    END IF
    OPEN i650_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bml01 TO NULL
        INITIALIZE g_bml02 TO NULL
    ELSE
        FOREACH i650_count INTO l_bml01,l_bml02
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i650_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i650_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i650_bcs INTO g_bml02,g_bml01
        WHEN 'P' FETCH PREVIOUS i650_bcs INTO g_bml02,g_bml01
        WHEN 'F' FETCH FIRST    i650_bcs INTO g_bml02,g_bml01
        WHEN 'L' FETCH LAST     i650_bcs INTO g_bml02,g_bml01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i650_bcs INTO g_bml02,g_bml01
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_bml01,SQLCA.sqlcode,0)
       INITIALIZE g_bml01 TO NULL  #TQC-6B0105
       INITIALIZE g_bml02 TO NULL  #TQC-6B0105
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
    CALL i650_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i650_show()
    DISPLAY g_bml01 TO bml01      #單頭
    DISPLAY g_bml02 TO bml02      #單頭
    CALL i650_bml01('d')
    CALL i650_bml02('d')
    CALL i650_b_fill(g_wc2)                 #單身
# genero  script marked     LET g_bml_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i650_r()
  DEFINE l_bml01  LIKE bml_file.bml01,
         l_bml02  LIKE bml_file.bml02
 
    IF s_shut(0) THEN RETURN END IF        #檢查權限
    IF g_bml01 IS NULL THEN
       CALL cl_err("",-400,0)              #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bml01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bml01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bml02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_bml02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bml_file WHERE bml01 = g_bml01 AND bml02 = g_bml02
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.TQC-660046
            CALL cl_err3("del","bml_file",g_bml01,g_bml02,SQLCA.sqlcode,"","BODY DELETE",1)  #No.TQC-660046
        ELSE
            CLEAR FORM
            CALL g_bml.clear()
            LET g_row_count = 0
            FOREACH i650_count INTO l_bml01,l_bml02
                LET g_row_count = g_row_count + 1
            END FOREACH
            #TQC-C40231--mark--str--
            ##FUN-B50062-add-start--
            #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            #   CLOSE i650_bcs 
            #   CLOSE i650_count
            #   COMMIT WORK
            #   RETURN
            #END IF
            ##FUN-B50062-add-end--
            #TQC-C40231--mark--end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i650_bcs
            IF g_row_count >= 1 THEN    #TQC-C40231 add
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL i650_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET mi_no_ask = TRUE
                  CALL i650_fetch('/')
               END IF
            ELSE
               LET g_bml01 = NULL       #TQC-C40231 add
               LET g_bml02 = NULL       #TQC-C40231 add
            END IF
            LET g_delete='Y'
            #TQC-C40231--mark--str--
            #LET g_bml01 = NULL
            #LET g_bml02 = NULL
            #LET g_cnt=SQLCA.SQLERRD[3]
            #MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #TQC-C40231--mark--end--
            MESSAGE 'DELETE O.K'  #TQC-C40231 add
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i650_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否     #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否     #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bml01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bml03,bml04,'','','','',bml06,'' ",
                       "FROM bml_file ",
                       " WHERE bml01= ? ",
                       "  AND bml02= ? ",
                       "  AND bml03= ? ",
                       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i650_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bml
              WITHOUT DEFAULTS
              FROM s_bml.*
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
               LET g_bml_t.* = g_bml[l_ac].*  #BACKUP
               LET g_bml04_o = g_bml[l_ac].bml04  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
                OPEN i650_bcl USING g_bml01,g_bml02,g_bml_t.bml03
                IF STATUS THEN
                    CALL cl_err("OPEN i650_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i650_bcl INTO g_bml[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bml_t.bml03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    SELECT mse02 INTO g_bml[l_ac].mse02
                      FROM mse_file WHERE mse01=g_bml[l_ac].bml04
                    DISPLAY g_bml[l_ac].mse02 TO FORMONLY.mse02
                    SELECT pmc03 INTO g_bml[l_ac].pmc03
                      FROM pmc_file WHERE pmc01=g_bml[l_ac].bml06
                    DISPLAY g_bml[l_ac].pmc03 TO FORMONLY.pmc03
                    CALL i650_bml04('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bml03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
             INSERT INTO bml_file (bml01,bml02,bml03,bml04,bml05,bml06)  #No.MOD-470041
                 VALUES(g_bml01,g_bml02,g_bml[l_ac].bml03,g_bml[l_ac].bml04,
                        "",g_bml[l_ac].bml06)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bml[l_ac].bml03,SQLCA.sqlcode,0)   #No.TQC-660046
                CALL cl_err3("ins","bml_file",g_bml01,g_bml02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
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
            INITIALIZE g_bml[l_ac].* TO NULL      #900423
            LET g_bml_t.* = g_bml[l_ac].*         #新輸入資料
            CASE
             WHEN g_bml[l_ac].wdesc = "0"
                  let g_bml[l_ac].wdesc = g_x[20]
             when g_bml[l_ac].wdesc = "1"
                  let g_bml[l_ac].wdesc = g_x[21]
             when g_bml[l_ac].wdesc = "2"
                  let g_bml[l_ac].wdesc = g_x[22]
             when g_bml[l_ac].wdesc = "3"
                  let g_bml[l_ac].wdesc = g_x[23]
             WHEN g_bml[l_ac].wdesc = "4"
                  let g_bml[l_ac].wdesc = g_x[24]
            END CASE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bml03
 
        BEFORE FIELD bml03                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(bml03)+1
                   INTO g_bml[l_ac].bml03
                   FROM bml_file
                   WHERE bml01 = g_bml01 AND bml02 = g_bml02
                IF g_bml[l_ac].bml03 IS NULL THEN
                    LET g_bml[l_ac].bml03 = 1
                END IF
            END IF
 
        AFTER FIELD bml03                        #check 序號是否重複
            IF NOT cl_null(g_bml[l_ac].bml03) THEN
                IF g_bml[l_ac].bml03 != g_bml_t.bml03 OR
                   g_bml_t.bml03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bml_file
                        WHERE bml01 = g_bml01
                          AND bml02 = g_bml02
                          AND bml03 = g_bml[l_ac].bml03
                    IF l_n > 0 THEN
                        CALL cl_err(g_bml[l_ac].bml03,-239,0)
                        LET g_bml[l_ac].bml03 = g_bml_t.bml03
                        NEXT FIELD bml03
                    END IF
                END IF
            END IF
 
        AFTER FIELD bml04  #廠牌
            IF NOT cl_null(g_bml[l_ac].bml04) THEN
                IF g_bml[l_ac].bml04 != g_bml_t.bml04 OR
                   g_bml_t.bml04 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bml_file
                        WHERE bml01 = g_bml01
                          AND bml02 = g_bml02
                          AND bml04 = g_bml[l_ac].bml04
                    IF l_n > 0 THEN
                        CALL cl_err(g_bml[l_ac].bml04,-239,0)
                        LET g_bml[l_ac].bml04 = g_bml_t.bml04
                        NEXT FIELD bml04
                    END IF
                END IF
                CALL i650_bml04('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_bml[l_ac].bml04=g_bml_t.bml04
                    NEXT FIELD bml04
                ELSE
                   SELECT mse02 INTO g_bml[l_ac].mse02
                     FROM mse_file WHERE mse01=g_bml[l_ac].bml04
                   DISPLAY g_bml[l_ac].mse02 TO FORMONLY.mse02
                END IF
            END IF
 
        AFTER FIELD bml06
            IF NOT cl_null(g_bml[l_ac].bml06) THEN
               #No.TQC-6C0221--begin
               CALL i650_bml06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('bml06:',g_errno,1)
                  LET g_bml[l_ac].bml06 = g_bml_t.bml06
                  NEXT FIELD bml06
               END IF
#              SELECT COUNT(*) INTO g_cnt FROM pmc_file
#               WHERE pmc01=g_bml[l_ac].bml06
#              IF g_cnt=0 THEN
#                 CALL cl_err(g_bml[l_ac].bml06,-239,0)
#                 LET g_bml[l_ac].bml06 = g_bml_t.bml06
#                 NEXT FIELD bml06
#              ELSE
#                 SELECT pmc03 INTO g_bml[l_ac].pmc03
#                   FROM pmc_file WHERE pmc01=g_bml[l_ac].bml06
#                 DISPLAY g_bml[l_ac].pmc03 TO FORMONLY.pmc03
#              END IF
               #No.TQC-6C0221--end  
#TQC-A30023 --begin--
            ELSE
               LET g_bml[l_ac].pmc03 = NULL
               DISPLAY BY NAME g_bml[l_ac].pmc03 
#TQC-A30023 --end--
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bml_t.bml03 > 0 AND
               g_bml_t.bml03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bml_file
                    WHERE bml01 = g_bml01 AND
                          bml02 = g_bml02 AND
                          bml03 = g_bml_t.bml03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bml_t.bml03,SQLCA.sqlcode,0)   #No.TQC-660046
                    CALL cl_err3("del","bml_file",g_bml01,g_bml02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
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
               LET g_bml[l_ac].* = g_bml_t.*
               CLOSE i650_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bml[l_ac].bml03,-263,1)
                LET g_bml[l_ac].* = g_bml_t.*
            ELSE
                UPDATE bml_file SET bml03 = g_bml[l_ac].bml03,
                                    bml04 = g_bml[l_ac].bml04,
                                    bml06 = g_bml[l_ac].bml06
                 WHERE bml01=g_bml01
                   AND bml02=g_bml02
                   AND bml03=g_bml_t.bml03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bml[l_ac].bml03,SQLCA.sqlcode,0)   #No.TQC-660046
                    CALL cl_err3("upd","bml_file",g_bml01,g_bml_t.bml03,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bml[l_ac].* = g_bml_t.*
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
                  LET g_bml[l_ac].* = g_bml_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bml.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i650_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_bml_t.* = g_bml[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i650_bcl
            COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL i650_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bml03) AND l_ac > 1 THEN
                LET g_bml[l_ac].* = g_bml[l_ac-1].*
#No.TQC-730082 --begin
                SELECT max(bml03)+1
                   INTO g_bml[l_ac].bml03
                   FROM bml_file
                   WHERE bml01 = g_bml01 AND bml02 = g_bml02
                IF g_bml[l_ac].bml03 IS NULL THEN
                    LET g_bml[l_ac].bml03 = 1
                END IF
#No.TQC-730082 --end
#               NEXT FIELD bml03      #No.TQC-730082
                NEXT FIELD bml04      #No.TQC-730082
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(bml04)      #廠牌
#                 CALL q_mse(0,0,g_bml[l_ac].bml04) RETURNING g_bml[l_ac].bml04
#                 CALL FGL_DIALOG_SETBUFFER( g_bml[l_ac].bml04 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_mse"
                  LET g_qryparam.default1 = g_bml[l_ac].bml04
                  CALL cl_create_qry() RETURNING g_bml[l_ac].bml04
#                  CALL FGL_DIALOG_SETBUFFER( g_bml[l_ac].bml04 )
                  DISPLAY g_bml[l_ac].bml04 TO bml04
                  NEXT FIELD bml04
             WHEN INFIELD(bml06)
#                 CALL q_pmc1(0,0,g_bml[l_ac].bml06) RETURNING g_bml[l_ac].bml06
#                 CALL FGL_DIALOG_SETBUFFER( g_bml[l_ac].bml06 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.default1 = g_bml[l_ac].bml06
                  CALL cl_create_qry() RETURNING g_bml[l_ac].bml06
#                  CALL FGL_DIALOG_SETBUFFER( g_bml[l_ac].bml06 )
                  DISPLAY g_bml[l_ac].bml06 TO bml06
                  NEXT FIELD bml06
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
 
    CLOSE i650_bcl
	COMMIT WORK
END FUNCTION
 
#No.TQC-6C0221--begin
FUNCTION i650_bml06(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,  
   l_pmc03    LIKE pmc_file.pmc03,
   l_pmcacti  LIKE pmc_file.pmcacti
 
   LET g_errno=''
   SELECT pmc03,pmcacti
     INTO l_pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01=g_bml[l_ac].bml06
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='mfg3014'
                                LET l_pmc03=NULL
       WHEN l_pmcacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
     #DISPLAY l_pmc03 TO FORMONLY.pmc03  #TQC-A30023 MARK
      LET g_bml[l_ac].pmc03 = l_pmc03          #TQC-A30023 ADD
      DISPLAY BY NAME g_bml[l_ac].pmc03        #TQC-A30023 ADD
   END IF
END FUNCTION
#No.TQC-6C0221--end  
 
FUNCTION  i650_bml04(p_cmd)
DEFINE
    p_cmd        LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
    l_aa         LIKE fan_file.fan02,       #No.FUN-680096 VARCHAR(4)
    l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    #-->check 存在於mse_file
    IF p_cmd = 'a' THEN
       SELECT mse02 FROM mse_file WHERE mse01 = g_bml[l_ac].bml04
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2603'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN RETURN END IF
    END IF
    # modi by kitty (by 373016)
 #--- OMAR 980911 應DCC & CE 需求取消Link機種 ---#
 #  LET l_aa=g_bml02[2,5]
 #  SELECT COUNT(*) INTO l_cnt FROM abmc_file
 #   WHERE abmc01=g_bml01 AND abmc03=l_aa
 #  LET l_aa=g_bml02[3,6]
 #  SELECT COUNT(*) INTO l_cnt1 FROM abmc_file
 #   WHERE abmc01=g_bml01 AND abmc03=l_aa
 #  IF (l_cnt+l_cnt1)>0 THEN
      #--->show data
      SELECT bmj10,bmj11,bmj08
       INTO g_bml[l_ac].bmj10,g_bml[l_ac].bmj11,g_bml[l_ac].wdesc
       FROM bmj_file
      WHERE bmj01 = g_bml01 AND bmj02 = g_bml[l_ac].bml04
        AND bmj03 = g_bml[l_ac].bml06      #No.TQC-730082
          IF SQLCA.sqlcode THEN
             LET g_bml[l_ac].bmj10 = ' '
             LET g_bml[l_ac].bmj11 = ' '
             LET g_bml[l_ac].wdesc   = ' '
          END IF
       CASE
       WHEN g_bml[l_ac].wdesc = "0"
            let g_bml[l_ac].wdesc = g_x[20]
       when g_bml[l_ac].wdesc = "1"
            let g_bml[l_ac].wdesc = g_x[21]
       when g_bml[l_ac].wdesc = "2"
            let g_bml[l_ac].wdesc = g_x[22]
       when g_bml[l_ac].wdesc = "3"
            let g_bml[l_ac].wdesc = g_x[23]
       WHEN g_bml[l_ac].wdesc = "4"
            let g_bml[l_ac].wdesc = g_x[24]
       WHEN g_bml[l_ac].wdesc = "X"
            let g_bml[l_ac].wdesc = g_x[25]
       END CASE
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_bml[l_ac].bmj10
       DISPLAY BY NAME g_bml[l_ac].bmj11
       DISPLAY BY NAME g_bml[l_ac].wdesc
       #------MOD-5A0095 END------------
  # ELSE
  #    CALL cl_err('','abm-009',0)
  #    LET g_bml[l_ac].bmj10 = ' '
  #    LET g_bml[l_ac].bmj11 = ' '
  #    LET g_bml[l_ac].wdesc   = ' '
  # END IF
  #--- OMAR 980911 應DCC & CE 需求取消Link機種 ---#
END FUNCTION
 
FUNCTION i650_b_askkey()
DEFINE
   #l_wc            STRING #TQC-630166 
    l_wc            STRING    #TQC-630166
 
    CONSTRUCT l_wc ON bml03,bml04,bml06             #螢幕上取條件
       FROM s_bml[1].bml03,s_bml[1].bml04,s_bml[1].bml06
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
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i650_b_fill(l_wc)
END FUNCTION
 
FUNCTION i650_b_fill(p_wc)              #BODY FILL UP
DEFINE
   #p_wc      STRING,    #TQC-630166
    p_wc      STRING,    #TQC-630166
    l_aa      LIKE fan_file.fan02  #No.FUN-680096  VARCHAR(4)
 
    LET g_sql = "SELECT bml03,bml04,'','','','',bml06,'' ",
                " FROM bml_file ",
                " WHERE bml01 = '",g_bml01,"' AND bml02 = '",g_bml02,
                "' AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE i650_prepare2 FROM g_sql      #預備一下
    DECLARE bml_cs CURSOR FOR i650_prepare2
    CALL g_bml.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH bml_cs INTO g_bml[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        # modi by kitty (by 373016)
  #--- OMAR 980911 應DCC & CE 需求取消Link機種 ---#
  #     LET l_aa=g_bml02[2,5]
  #     SELECT COUNT(*) INTO l_cnt FROM abmc_file
  #      WHERE abmc01=g_bml01 AND abmc03=l_aa
  #     LET l_aa=g_bml02[3,6]
  #     SELECT COUNT(*) INTO l_cnt1 FROM abmc_file
  #      WHERE abmc01=g_bml01 AND abmc03=l_aa
  #     IF (l_cnt+l_cnt1)>0 THEN
           SELECT bmj10,bmj11,bmj08
           INTO  g_bml[g_cnt].bmj10,g_bml[g_cnt].bmj11,g_bml[g_cnt].wdesc
           FROM bmj_file
           WHERE bmj01 = g_bml01 AND  bmj02 = g_bml[g_cnt].bml04
           CASE
            WHEN g_bml[g_cnt].wdesc = "0"
                LET g_bml[g_cnt].wdesc = g_x[20]
            WHEN g_bml[g_cnt].wdesc = "1"
                LET g_bml[g_cnt].wdesc = g_x[21]
            WHEN g_bml[g_cnt].wdesc = "2"
                LET g_bml[g_cnt].wdesc = g_x[22]
            WHEN g_bml[g_cnt].wdesc = "3"
                LET g_bml[g_cnt].wdesc = g_x[23]
            WHEN g_bml[g_cnt].wdesc = "4"
                LET g_bml[g_cnt].wdesc = g_x[24]
            WHEN g_bml[g_cnt].wdesc = "X"
                LET g_bml[g_cnt].wdesc = g_x[25]
           OTHERWISE
                LET g_bml[g_cnt].wdesc = ' '
           END CASE
   #   ELSE
   #      LET g_bml[g_cnt].bmj10 = ' '
   #      LET g_bml[g_cnt].bmj11 = ' '
   #      LET g_bml[g_cnt].wdesc   = ' '
   #  END IF
   #--- OMAR 980911 應DCC & CE 需求取消Link機種 ---#
 
        SELECT mse02 INTO g_bml[g_cnt].mse02
          FROM mse_file WHERE mse01=g_bml[g_cnt].bml04
        SELECT pmc03 INTO g_bml[g_cnt].pmc03
          FROM pmc_file WHERE pmc01=g_bml[g_cnt].bml06
 
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_bml.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i650_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bml TO s_bml.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i650_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i650_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i650_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i650_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i650_fetch('L')
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
         #No.FUN-6C0055 --start--
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         #No.FUN-6C0055 --end--
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION UTE/S
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
      #No.FUN-6C0055 --start--   
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
      #No.FUN-6C0055 --end--
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i650_copy()
DEFINE
    l_oldno1         LIKE bml_file.bml01,
    l_oldno2         LIKE bml_file.bml02,
    l_newno1         LIKE bml_file.bml01,
    l_newno2         LIKE bml_file.bml02
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bml01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT l_newno1,l_newno2  FROM bml01,bml02
 
        AFTER FIELD bml01
            IF cl_null(l_newno1) THEN
                NEXT FIELD bml01
            ELSE 
               #FUN-AA0059 -----------------------add start----------------------------
               IF NOT s_chk_item_no(l_newno1,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bml01
               END IF 
               #FUN-A0059 -----------------------add end-----------------------------
               SELECT count(*) INTO g_cnt FROM ima_file
                                WHERE ima01 = l_newno1
                                  AND imaacti = 'Y'
                                  AND ima08 IN ('P','V','Z','S')
                 IF g_cnt = 0 THEN
                    CALL cl_err(l_newno2,'mfg0002',0)
                    NEXT FIELD bml01
                 END IF
            END IF
	
        AFTER FIELD bml02
            IF cl_null(l_newno2) THEN
                NEXT FIELD bml02
            ELSE
               #FUN-AA0059 -----------------------add start-----------------------
                IF NOT s_chk_item_no(l_newno2,'') THEN
                   CALL cl_err('',g_errno,1)
                    NEXT FIELD bml02
                END IF 
               #FUN-AA0059 ----------------------add end--------------------------
                SELECT count(*) INTO g_cnt FROM ima_file
                                WHERE ima01 = l_newno2
                                  AND imaacti = 'Y'
                 IF g_cnt = 0 THEN
                    CALL cl_err(l_newno2,'mfg0002',0)
                    NEXT FIELD bml02
                 END IF
            END IF
            SELECT count(*) INTO g_cnt FROM bml_file
             WHERE bml01 = l_newno1
               AND bml02 = l_newno2
            IF g_cnt > 0 THEN
	        LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD bml01
            END IF
#No.TQC-750041 --BEGIN--
{
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bml01)
                 #CALL q_bmb2(10,3,'','') RETURNING g_bml02,g_bml01
                 #CALL FGL_DIALOG_SETBUFFER( g_bml02 )
                 #CALL FGL_DIALOG_SETBUFFER( g_bml01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmb201"
                  LET g_qryparam.arg1 = g_today
                  CALL cl_create_qry() RETURNING l_newno1,l_newno2
#                  CALL FGL_DIALOG_SETBUFFER( l_newno1 )
#                  CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                   DISPLAY l_newno1 TO bml01         #No.MOD-490371
                   DISPLAY l_newno2 TO bml02         #No.MOD-490371
                  NEXT FIELD bml01
                WHEN INFIELD(bml02)
                 #CALL q_bma1(10,3,g_bml02,'') RETURNING g_bml02
                 #CALL FGL_DIALOG_SETBUFFER( g_bml02 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma101"
                  LET g_qryparam.default1 = l_newno2
                  CALL cl_create_qry() RETURNING l_newno2
#                  CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                 #DISPLAY BY NAME g_bml02
                   DISPLAY l_newno2 TO bml02         #No.MOD-490371
                  NEXT FIELD bml02
                OTHERWISE
            END CASE
}
#No.TQC-750041  --END--
#TQC-790039.....begin
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bml01)
                 #CALL q_bmb2(10,3,'','') RETURNING g_bml02,g_bml01
                 #CALL FGL_DIALOG_SETBUFFER( g_bml02 )
                 #CALL FGL_DIALOG_SETBUFFER( g_bml01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmb201"
                  LET g_qryparam.arg1 = g_today
                  CALL cl_create_qry() RETURNING l_newno1,l_newno2
#                  CALL FGL_DIALOG_SETBUFFER( l_newno1 )
#                  CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                   DISPLAY l_newno1 TO bml01         #No.MOD-490371
                   DISPLAY l_newno2 TO bml02         #No.MOD-490371
                  NEXT FIELD bml01
                WHEN INFIELD(bml02)
                 #CALL q_bma1(10,3,g_bml02,'') RETURNING g_bml02
                 #CALL FGL_DIALOG_SETBUFFER( g_bml02 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma101"
                  LET g_qryparam.default1 = l_newno2
                  CALL cl_create_qry() RETURNING l_newno2
#                  CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                 #DISPLAY BY NAME g_bml02
                   DISPLAY l_newno2 TO bml02         #No.MOD-490371
                  NEXT FIELD bml02
                OTHERWISE
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
    IF INT_FLAG OR l_newno1 IS NULL THEN
        LET INT_FLAG = 0
    	CALL i650_show()
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM bml_file
        WHERE bml01=g_bml01
          AND bml02=g_bml02
        INTO TEMP x
    UPDATE x
        SET bml01=l_newno1,    #資料鍵值
    	    bml02=l_newno2
    INSERT INTO bml_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bml01,SQLCA.sqlcode,0)   #No.TQC-660046
        CALL cl_err3("ins","bml_file",g_bml01,g_bml02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
    ELSE
	LET g_msg = l_newno1 CLIPPED, ' + ', l_newno2 CLIPPED
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno1 = g_bml01
        LET l_oldno2 = g_bml02
        LET g_bml01 = l_newno1
        LET g_bml02 = l_newno2
	IF g_chkey = 'Y' THEN CALL i650_u() END IF
        CALL i650_b()
        #FUN-C30027---begin
        #LET g_bml01 = l_oldno1
        #LET g_bml02 = l_oldno2
        #CALL i650_show()
        #FUN-C30027---end
    END IF
END FUNCTION
 
FUNCTION i650_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bml01       LIKE bml_file.bml01,   #規格主件編號
        bml02       LIKE bml_file.bml02,   #特性料件編號
        bml03       LIKE bml_file.bml03,   #行序
        bml04       LIKE bml_file.bml04,   #條件編號
        bmj10       LIKE bmj_file.bmj10,   #承認文號
        wdesc       LIKE type_file.chr6,   #No.FUN-680096  VARCHAR(06),
        ima02       LIKE ima_file.ima02,   #FUN-510033
        ima021      LIKE ima_file.ima021,  #FUN-510033
        ima02s      LIKE ima_file.ima02,   #FUN-510033
        ima021s     LIKE ima_file.ima021   #FUN-510033
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096  VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096  VARCHAR(40)
    DEFINE l_sql    STRING                 #FUN-770052   
    DEFINE t_wc     STRING                 #FUN-880052
 
    IF g_wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------#   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bml01,bml02,bml03,bml04,bmj10,bmj08 ",
              " FROM bml_file,OUTER bmj_file ",    # 組合出 SQL 指令
              " WHERE bml_file.bml01=bmj_file.bmj01 AND bml_file.bml04 = bmj_file.bmj02",
              "   AND ",g_wc CLIPPED
    PREPARE i650_p1 FROM g_sql                      # RUNTIME 編譯
    DECLARE i650_co
        CURSOR FOR i650_p1
 
#   CALL cl_outnam('abmi650') RETURNING l_name                 #FUN-770052
#   START REPORT i650_rep TO l_name                            #FUN-770052
 
    FOREACH i650_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021
          FROM ima_file
         WHERE ima01 = sr.bml01
        SELECT ima02,ima021 INTO sr.ima02s,sr.ima021s
          FROM ima_file
         WHERE ima01 = sr.bml02
#       OUTPUT TO REPORT i650_rep(sr.*)                        #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.bml01,sr.ima02,sr.ima021,sr.bml02,sr.ima02s,sr.ima021s,                                                          
                   sr.bml03,sr.bml04,sr.bmj10                                                           
        #------------------------------ CR (3) ------------------------------#  
    END FOREACH
 
#   FINISH REPORT i650_rep                                     #FUN-770052
 
    CLOSE i650_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)                          #FUN-770052
    LET t_wc = g_wc CLIPPED," AND ",g_wc2 CLIPPED              #No.FUN-880052
 
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
#       CALL cl_wcchp(g_wc,'bml01,bml02')                      #No.FUN-880052                                                                             
        CALL cl_wcchp(t_wc,'bml01,bml02,bml03,bml04,bml06')    #No.FUN-880052
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                         
    LET g_str =sr.wdesc,";",t_wc                #No.FUN-880052 將g_wc改為t_wc                                                   
    CALL cl_prt_cs3('abmi650','abmi650',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
{REPORT i650_rep(sr)                                           #FUN-770052
DEFINE
    l_trailer_sw    LIKE type_file.chr1,  #No.FUN-680096  VARCHAR(1) 
    sr              RECORD
        bml01       LIKE bml_file.bml01,  #元件編號
        bml02       LIKE bml_file.bml02,  #主件編號
        bml03       LIKE bml_file.bml03,  #項次
        bml04       LIKE bml_file.bml04,  #廠牌
        bmj10       LIKE bmj_file.bmj10,  #承認文號
        wdesc       LIKE type_file.chr6,  #No.FUN-680096  VARCHAR(6)
        ima02       LIKE ima_file.ima02,  #FUN-510033
        ima021      LIKE ima_file.ima021, #FUN-510033
        ima02s      LIKE ima_file.ima02,  #FUN-510033
        ima021s     LIKE ima_file.ima021  #FUN-510033
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bml01,sr.bml02,sr.bml03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bml01
            PRINT COLUMN g_c[31],sr.bml01,
                  COLUMN g_c[32],sr.ima02,
                  COLUMN g_c[33],sr.ima021;
 
        BEFORE GROUP OF sr.bml02
            PRINT COLUMN g_c[34],sr.bml02,
                  COLUMN g_c[35],sr.ima02s,
                  COLUMN g_c[36],sr.ima021s;
 
        ON EVERY ROW
            CASE
               WHEN sr.wdesc = "0"  LET sr.wdesc = g_x[20] CLIPPED
               WHEN sr.wdesc = "1"  LET sr.wdesc = g_x[21] CLIPPED
               WHEN sr.wdesc = "2"  LET sr.wdesc = g_x[22] CLIPPED
               WHEN sr.wdesc = "3"  LET sr.wdesc = g_x[23] CLIPPED
               WHEN sr.wdesc = "4"  LET sr.wdesc = g_x[24] CLIPPED
            END CASE
            PRINT COLUMN g_c[37],sr.bml03 USING '###&',
                  COLUMN g_c[38],sr.bml04,
                  COLUMN g_c[39],sr.wdesc,
                  COLUMN g_c[40],sr.bmj10
 
        AFTER  GROUP OF sr.bml02
            SKIP 1 LINE
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
            END IF
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}                                                      #FUN-770052
#Patch....NO.MOD-5A0095 <001> #
