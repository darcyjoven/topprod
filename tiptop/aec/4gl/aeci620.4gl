# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aeci620.4gl
# Descriptions...: 作業資料維護作業
# Date & Author..: 91/11/07 By Nora
# Modify.........: 99/06/28 By Kammy
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.MOD-530132 05/03/17 By pengu 修改報表欄位寬度
# Modify.........: No.MOD-580278 05/08/29 By Rosayu a()段在INSERT完資料確定INSERT成功之後，沒有重抓一次ROWID,須重新查詢之後才可執行
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: NO.FUN-680010 06/08/05 By Joe SPC整合專案-基本資料傳遞
# Modify.........: No.FUN-680073 06/08/29 By hongmei 欄位類型轉換 
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/19 By lala   報表轉為使用p_query
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-810058 08/01/24 By lutingting 新增欄位ecdicd01 并且在非ICD作業時隱藏該欄位
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-870101 08/09/09 By jamie MES整合
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.TQC-920063 09/02/20 By shiwuying 修改 無效的資料也可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B10212 11/01/20 By destiny orig,oriu新增时未付值 
# Modify.........: No:FUN-9A0056 11/03/30 By abby MES功能補強 1.修改為副程式寫法
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:160704     16/07/04 By guanyao 增加栏位ta_ecd02 委外否
# Modify.........: No:160727     16/07/27 By guanyao 增加栏位ta_ecd03 转换否
# Modify.........: No:160806     16/08/06 By guanyao 增加栏位ta_ecd04 包装否

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecd   RECORD LIKE ecd_file.*,
    g_ecd_t RECORD LIKE ecd_file.*,
    g_ecd_o RECORD LIKE ecd_file.*,
    g_ecd01_t LIKE ecd_file.ecd01,
    g_wc,g_sql          STRING,    #TQC-630166
    g_d01               LIKE tod_file.tod08,            #成本基准之中文description #No.FUN-680073 VARCHAR(09) 
    l_cmd               LIKE type_file.chr1000          #No.FUN-680073 VARCHAR(60)
DEFINE g_row_count      LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE g_curs_index     LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE g_jump           LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE g_no_ask        LIKE type_file.num5             #No.FUN-680073 SMALLINT
DEFINE g_forupd_sql     STRING                          #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_chr                 LIKE type_file.chr1        #No.FUN-680073 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10       #No.FUN-680073 INTEGER
DEFINE g_i                   LIKE type_file.num5        #count/index for any purpose #No.FUN-680073 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000     #No.FUN-680073 VARCHAR(72)
DEFINE g_argv1               LIKE ecd_file.ecd01        #FUN-7C0050
DEFINE g_argv2               STRING                     #FUN-7C0050      #執行功能
DEFINE g_u_flag              LIKE type_file.chr1        #FUN-870101 add 
 
MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
 
    INITIALIZE g_ecd.* TO NULL
    INITIALIZE g_ecd_t.* TO NULL
    INITIALIZE g_ecd_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ecd_file WHERE ecd01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i620_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i620_w WITH FORM "aec/42f/aeci620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#No.FUN-810058--start--
   IF  s_industry("icd") THEN 
      CALL cl_set_comp_visible("ecdicd01",TRUE)
   ELSE 
      CALL cl_set_comp_visible("ecdicd01",FALSE)
   END IF
#No.FUN-810058--end
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i620_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i620_a()
            END IF
         OTHERWISE        
            CALL i620_q() 
      END CASE
   END IF
 
    LET g_action_choice=""
    CALL i620_menu()
 
    CLOSE WINDOW i620_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i620_cs()
    CLEAR FORM
   INITIALIZE g_ecd.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" ecd01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ecd01,ecd02,ecd05,ecd07,ecd09,ecd15,ecdicd01, #No.FUN-810058 新增ecdicd01
        ecduser,ecdgrup,ecdmodu,ecddate,ecdacti,ta_ecd02,ta_ecd03  #add ta_ecd02 by guanyao160704  #add ta_ecd03 by guanyao160727
        ,ta_ecd04,ta_ecd05,ta_ecd07   #add by guanyao160806   #tianry add end 161209
        ,ta_ecd08,ta_ecd10 #darcy:2023/06/25 add
              #No.FUN-580031 --start--     HCN 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ecd07) #工作站編號
#                 CALL q_eca(0,0,g_ecd.ecd07) RETURNING g_ecd.ecd07
                 CALL q_eca(TRUE,TRUE,g_ecd.ecd07) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ecd07
                 NEXT FIELD ecd07
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecdgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecdgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecduser', 'ecdgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ecd01", # 組合出 SQL 指令
              " FROM ecd_file ",
              " WHERE ",g_wc CLIPPED, " ORDER BY ecd01"
    PREPARE i620_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i620_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i620_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ecd_file WHERE ",g_wc CLIPPED
    PREPARE i620_precount FROM g_sql
    DECLARE i620_count CURSOR FOR i620_precount
END FUNCTION
 
FUNCTION i620_menu()
DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-820002
   #No.18010101--begin--
   DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
   DEFINE  l_time   LIKE type_file.chr100 
   #No.18010101---end---
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i620_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i620_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i620_fetch('N')
        ON ACTION previous
            CALL i620_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i620_u()
            END IF
            NEXT OPTION "next"
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i620_x()
            END IF
            NEXT OPTION "next"
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i620_r()
            END IF
            NEXT OPTION "next"
        ON ACTION reproduce
             LET g_action_choice="reproduce"
             IF cl_chk_act_auth() THEN
                  CALL i620_copy()
             END IF
        ON ACTION description
             LET g_action_choice="description"
             IF cl_chk_act_auth() THEN
                LET l_cmd = 'aeci625 ',"'",g_ecd.ecd01 CLIPPED,"'"
                CALL cl_cmdrun(l_cmd)
             END IF
        ON ACTION output
             LET g_action_choice="output"
             IF cl_chk_act_auth() THEN
                CALL i620_out()
             END IF
       #No.18010101--begin--
      ON ACTION transf2scm
            IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_ecd.ecd01) THEN
                    INITIALIZE l_ret TO NULL
                    SELECT to_char(sysdate,'yyyy-mm-dd`HH:MM:SS') INTO l_time FROM dual 
                    CALL cl_zmx_json_ecd(g_ecd.ecd01,l_time) RETURNING l_ret.*
                    IF l_ret.success = 'Y' THEN
                    ELSE
                       IF cl_null(l_ret.msg) THEN
                           LET l_ret.msg = "作业编号和线边仓对应资料(",g_ecd.ecd01 CLIPPED,")同步失败"
                       END IF
                    END IF
                    CALL cl_err(l_ret.msg,'!',1)
                END IF
            END IF
       #No.18010101---end---
             
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
            CALL i620_fetch('/')
        ON ACTION first
            CALL i620_fetch('F')
        ON ACTION last
            CALL i620_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0039-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ecd.ecd01 IS NOT NULL THEN
                  LET g_doc.column1 = "ecd01"
                  LET g_doc.value1 = g_ecd.ecd01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0039-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i620_cs
END FUNCTION
 
 
FUNCTION i620_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ecd.* LIKE ecd_file.*
    LET g_ecd01_t = NULL
    LET g_ecd_t.*=g_ecd.*
    LET g_ecd_o.*=g_ecd.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ecd.ecdacti ='Y'                   #有效的資料
        LET g_ecd.ecduser = g_user
        LET g_ecd.ecdoriu = g_user #FUN-980030
        LET g_ecd.ecdorig = g_grup #FUN-980030
        LET g_ecd.ecdgrup = g_grup               #使用者所屬群
        LET g_ecd.ecddate = g_today
        LET g_ecd.ta_ecd02 = 'N'    #add by guanyao160704
        LET g_ecd.ta_ecd03 = 'N'    #add by guanyao160727
        LET g_ecd.ta_ecd04 = 'N'    #add by guanyao160806
        LET g_ecd.ta_ecd05 = 'N'    #tianry add end 161209
        LET g_ecd.ta_ecd07 = 'N'    #tianry add end 161209
        CALL i620_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ecd.ecd01 IS NULL THEN  # KEY 不可空白
           CONTINUE WHILE
        END IF

        LET g_success = 'Y'  #FUN-9A0056 add
        
        BEGIN WORK     #NO.FUN-680010
 
        INSERT INTO ecd_file VALUES(g_ecd.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg=g_ecd.ecd01 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("ins","ecd_file",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
            ROLLBACK WORK    #NO.FUN-680010
            CONTINUE WHILE
         #MOD-580278 add
        ELSE
            SELECT ecd01 INTO g_ecd.ecd01 FROM ecd_file
                WHERE ecd01 = g_ecd.ecd01
         #MOD-580278(end)
            ##FUN-680010
            # CALL aws_spccli_base()
            # 傳入參數: (1)TABLE名稱, (2)新增資料,
            #           (3)功能選項：insert(新增),update(修改),delete(刪除)
            CASE aws_spccli_base('ecd_file',base.TypeInfo.create(g_ecd),'insert')    
               WHEN 0  #無與 SPC 整合
                    MESSAGE 'INSERT O.K'
                    LET g_success = 'Y'  #FUN-9A0056 add
                    #LET g_u_flag='0'    #FUN-870101 add #FUN-9A0056 mark
                    #COMMIT WORK         #FUN-870101 mark
               WHEN 1  #呼叫 SPC 成功
                    MESSAGE 'INSERT O.K, INSERT SPC O.K'
                    LET g_success = 'Y'  #FUN-9A0056 add
                    #LET g_u_flag='0'    #FUN-870101 add  #FUN-9A0056 mark
                    #COMMIT WORK         #FUN-870101 mark 
               WHEN 2  #呼叫 SPC 失敗
                    LET g_success = 'N'  #FUN-9A0056 add
                    #LET g_u_flag='1'    #FUN-870101 add  #FUN-9A0056 mark
                    #ROLLBACK WORK       #FUN-870101 mark
                    #CONTINUE WHILE      #FUN-9A0056 mark
            END CASE
            ##FUN-680010 
 
            IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN   #FUN-9A0056 add
              #FUN-9A0056 mark str------
            #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
               #FUN-870101---add---str---
               # CALL aws_mescli()
               # 傳入參數: (1)程式代號
               #           (2)功能選項：insert(新增),update(修改),delete(刪除)
               #           (3)Key
               #CASE aws_mescli('aeci620','insert',g_ecd.ecd01)
               #   WHEN 0  #無與 MES 整合
               #        LET g_u_flag='0'                  
               #        MESSAGE 'INSERT O.K'
               #   WHEN 1  #呼叫 MES 成功
               #        LET g_u_flag='0'                  
               #        MESSAGE 'INSERT O.K, INSERT MES O.K'
               #   WHEN 2  #呼叫 MES 失敗
               #        LET g_u_flag='1'                  
               #        CONTINUE WHILE
               #END CASE
               #FUN-870101---add---end---
               #FUN-9A0056 mark end -----
               CALL i620_mes('insert',g_ecd.ecd01)                   #FUN-9A0056 add
            END  IF  #TQC-8B0011 ADD
        END IF

       #IF g_u_flag='1' THEN ROLLBACK WORK ELSE COMMIT WORK END IF #FUN-870101 add #FUN-9A0056 mark
       #FUN-9A0056 -- add begin ----
        IF g_success = 'N' THEN
          ROLLBACK WORK
          CONTINUE WHILE
        ELSE
          COMMIT WORK
        END IF
       #FUN-9A0056 -- add end ------
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i620_i(p_cmd)
    DEFINE
        l_eca04         LIKE eca_file.eca04,     #工作站狀態
        l_eca06         LIKE eca_file.eca06,     #工作站產能型態
        l_ima08         LIKE ima_file.ima08,     #來源碼
        l_dir1          LIKE type_file.chr1,     #記錄游標的方向,應至[人工數]或[備注]欄位 #No.FUN-680073 VARCHAR(1) 
        l_sw            LIKE type_file.chr1,     #記錄是否有必須輸入之欄位尚未輸入 #No.FUN-680073 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680073 SMALLINT
 
    IF p_cmd = 'u' THEN  #若為更改狀況時,須先select 其工作區型態及產能型態
       SELECT eca04,eca06 INTO l_eca04,l_eca06 FROM eca_file
              WHERE eca01 = g_ecd.ecd07 AND ecaacti = 'Y'
    END IF
    DISPLAY BY NAME g_ecd.ecduser,g_ecd.ecdgrup,g_ecd.ecddate,
                    g_ecd.ecdacti,g_ecd.ecdorig,g_ecd.ecdoriu #TQC-B10212
                    ,g_ecd.ta_ecd02   #add by guanyao160704
                    ,g_ecd.ta_ecd03   #add by guanyao160727
                    ,g_ecd.ta_ecd04   #add by guanyao160806
                    ,g_ecd.ta_ecd05   #tianry add 161209
                      ,g_ecd.ta_ecd07   #tianry add 161209
                    ,g_ecd.ta_ecd08,g_ecd.ta_ecd10  #darcy:2023/06/25 add
 
    INPUT  BY NAME  g_ecd.ecd01,g_ecd.ecd02,g_ecd.ecd05,g_ecd.ecd07,
                    g_ecd.ecd09,g_ecd.ecd15,g_ecd.ecdicd01  #FUN-810058 增加g_ecd.ecdicd01
                    ,g_ecd.ta_ecd01     #add by guanyao160627
                    ,g_ecd.ta_ecd02   #add by guanyao160704
                    ,g_ecd.ta_ecd03   #add by guanyao160727
                    ,g_ecd.ta_ecd04   #add by guanyao160806
                    ,g_ecd.ta_ecd05   #tianry add 161209
                       ,g_ecd.ta_ecd07   #tianry add 161209
                    ,g_ecd.ta_ecd08,g_ecd.ta_ecd10  #darcy:2023/06/25 add
                    WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i620_set_entry(p_cmd)
           CALL i620_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
         AFTER FIELD ecd01
	  IF g_ecd.ecd01 IS NOT NULL THEN
            #檢查重複否
            IF p_cmd = "a" OR                # 若輸入或更改且改KEY
               (p_cmd = "u" AND (g_ecd.ecd01 != g_ecd01_t)) THEN
               SELECT count(*) INTO l_n FROM ecd_file
	        WHERE ecd01 = g_ecd.ecd01
               IF l_n > 0 THEN                  # Duplicated
	          LET g_msg=g_ecd.ecd01 CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  LET g_ecd.ecd01 = g_ecd01_t
	          DISPLAY BY NAME g_ecd.ecd01
		  NEXT FIELD ecd01
               END IF
            END IF
          END IF
 
          AFTER FIELD ecd05
             IF g_ecd.ecd05 IS NULL OR
	        g_ecd.ecd05 NOT MATCHES'[1234]' THEN
                LET g_ecd.ecd05 = g_ecd_o.ecd05
	        DISPLAY BY NAME g_ecd.ecd05
	        NEXT FIELD ecd05
	     END IF
             LET g_ecd_o.ecd05 = g_ecd.ecd05
 
          AFTER FIELD ecd07
           IF g_ecd.ecd07 IS NOT NULL THEN
             CALL i620_ecd07(l_eca04,l_eca06) RETURNING l_eca04,l_eca06
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_ecd.ecd07,'mfg4011',0)
                LET g_ecd.ecd07 = g_ecd_o.ecd07
                DISPLAY BY NAME g_ecd.ecd07
	        NEXT FIELD ecd07
	     END IF
             LET g_ecd_o.ecd07 = g_ecd.ecd07
	   END IF
		
          AFTER FIELD ecd09
             IF g_ecd.ecd09 IS NULL THEN
                LET g_ecd.ecd09 = 0
                DISPLAY BY NAME g_ecd.ecd09
             ELSE
                IF g_ecd.ecd09 > 100 OR g_ecd.ecd09 < 0 THEN
                   CALL cl_err(g_ecd.ecd09,'mfg4013',0)
                   LET g_ecd.ecd09 = g_ecd_o.ecd09
                   DISPLAY BY NAME g_ecd.ecd09
                   NEXT FIELD ecd09
                END IF
             END IF
             LET g_ecd_o.ecd09 = g_ecd.ecd09
 
             AFTER FIELD ecd15
	        LET l_dir1 = 'U'
 
        AFTER INPUT
           LET g_ecd.ecduser = s_get_data_owner("ecd_file") #FUN-C10039
           LET g_ecd.ecdgrup = s_get_data_group("ecd_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_ecd.ecd07 IS NULL THEN
               DISPLAY BY NAME g_ecd.ecd07
               LET l_sw = 'Y'
            END IF
            IF l_sw = 'Y' THEN
               CALL cl_err('','9033',0)
               LET l_sw = 'N'
               NEXT FIELD ecd01
            END IF
            IF g_ecd.ecd09 IS NULL THEN
               LET g_ecd.ecd09 = 0
               DISPLAY BY NAME g_ecd.ecd09
            END IF
 
#       ON ACTION CONTROLO                        # 沿用所有欄位
#           IF INFIELD(ecd01) THEN
#               LET g_ecd.* = g_ecd_t.*
#               DISPLAY BY NAME g_ecd.*
#               NEXT FIELD ecd01
#           END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ecd07) #工作站編號
#                 CALL q_eca(0,0,g_ecd.ecd07) RETURNING g_ecd.ecd07
                  CALL q_eca(FALSE,TRUE,g_ecd.ecd07) RETURNING g_ecd.ecd07
                  DISPLAY BY NAME g_ecd.ecd07
                  CALL i620_ecd07(l_eca04,l_eca06) RETURNING l_eca04,l_eca06
                  NEXT FIELD ecd07
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
#       ON ACTION maintain_work_center
#           CASE
#              WHEN INFIELD(ecd07) #工作區編號
#                   CALL cl_cmdrun('aeci600')
#              OTHERWISE EXIT CASE
#           END CASE
 
        ON ACTION CONTROLF                        # 欄位description
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
       
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
    END INPUT
END FUNCTION
 
 
#工作區若屬(廠外加工)則將廠外加工之相關欄位清為null
#否則將[排程設置時間] 及 [排程生產時間] 清為null
FUNCTION i620_ecd07(l_eca04,l_eca06)
    DEFINE l_eca04  LIKE eca_file.eca04,
           l_eca06  LIKE eca_file.eca06
    IF g_ecd_o.ecd07 IS NULL OR
       g_ecd_o.ecd07 != g_ecd.ecd07 THEN
       LET g_chr = ' '
       LET g_ecd_o.ecd07 = g_ecd.ecd07
       SELECT eca04,eca06 INTO l_eca04,l_eca06 FROM eca_file
              WHERE eca01 = g_ecd.ecd07 AND ecaacti = 'Y'
       IF SQLCA.sqlcode THEN
          LET g_chr = 'E'
          RETURN l_eca04,l_eca06
       END IF
{
       IF l_eca06 = '2' THEN
          LET g_ecd.ecd14 = 0
          LET g_ecd.ecd18 = 0  LET g_ecd.ecd19 = 0
          DISPLAY BY NAME g_ecd.ecd14,g_ecd.ecd18,
                          g_ecd.ecd19
       END IF
       IF l_eca04 = '0' THEN
          LET g_ecd.ecd20 = 0 LET g_ecd.ecd21 = 0
          LET g_ecd.ecd22 = NULL LET g_ecd.ecd23 = NULL
          LET g_ecd.ecd26 = 0
          DISPLAY BY NAME g_ecd.ecd20,g_ecd.ecd21,g_ecd.ecd22,
                          g_ecd.ecd23,g_ecd.ecd26
       ELSE
          LET g_ecd.ecd24 = 0 LET g_ecd.ecd25 = 0
          DISPLAY BY NAME g_ecd.ecd24,g_ecd.ecd25
       END IF
}
    END IF
    RETURN l_eca04,l_eca06
END FUNCTION
 
 
FUNCTION i620_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecd.* TO NULL              #No.FUN-6A0039
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i620_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i620_count
    FETCH i620_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i620_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecd.ecd01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_ecd.* TO NULL
    ELSE
        CALL i620_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i620_fetch(p_flecu)
    DEFINE
        p_flecu         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flecu
        WHEN 'N' FETCH NEXT     i620_cs INTO g_ecd.ecd01
        WHEN 'P' FETCH PREVIOUS i620_cs INTO g_ecd.ecd01
        WHEN 'F' FETCH FIRST    i620_cs INTO g_ecd.ecd01
        WHEN 'L' FETCH LAST     i620_cs INTO g_ecd.ecd01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i620_cs INTO g_ecd.ecd01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecd.ecd01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_ecd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flecu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecd.* FROM ecd_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ecd01 = g_ecd.ecd01
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecd.ecd01 CLIPPED
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("sel","ecd_file",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
    ELSE
        LET g_data_owner = g_ecd.ecduser      #FUN-4C0034
        LET g_data_group = g_ecd.ecdgrup      #FUN-4C0034
        CALL i620_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i620_show()
    LET g_ecd_t.* = g_ecd.*
    LET g_ecd_o.* = g_ecd.*
    DISPLAY BY NAME  g_ecd.ecd01,g_ecd.ecd02,g_ecd.ecd05,	 g_ecd.ecdoriu,g_ecd.ecdorig,
            g_ecd.ecd07,g_ecd.ecd09,g_ecd.ecd15,g_ecd.ecdicd01,   #No.FUN-810058 增加g_ecd.ecdicd01
            g_ecd.ecduser,g_ecd.ecdgrup,g_ecd.ecdmodu,
            g_ecd.ecddate,g_ecd.ecdacti
            ,g_ecd.ta_ecd01     #add by guanyao160627
            ,g_ecd.ta_ecd02   #add by guanyao160704
            ,g_ecd.ta_ecd03   #add by guanyao160727
            ,g_ecd.ta_ecd04   #add by guanyao160806
            ,g_ecd.ta_ecd05   #tianry add 161209
              ,g_ecd.ta_ecd07   #tianry add 161209
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i620_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ecd.ecd01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_ecd.ecdacti ='N' THEN    #檢查資料是否為無效
       LET g_msg=g_ecd.ecd01 CLIPPED
       CALL cl_err(g_msg,'9027',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ecd01_t = g_ecd.ecd01
 
    IF g_action_choice <> "reproduce" THEN    #FUN-680010
       BEGIN WORK
    END IF
 
    OPEN i620_cl USING g_ecd.ecd01
    IF STATUS THEN
       CALL cl_err("OPEN i620_cl:", STATUS, 1)
       CLOSE i620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i620_cl INTO g_ecd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecd.ecd01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       ROLLBACK WORK     #FUN-680010
       RETURN
    END IF
    LET g_ecd.ecdmodu=g_user                     #修改者
    LET g_ecd.ecddate = g_today                  #修改日期
    CALL i620_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_success = 'Y'                   #FUN-9A0056 add
        CALL i620_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ecd.*=g_ecd_t.*
           CALL i620_show()
           CALL cl_err('',9001,0)
           ROLLBACK WORK     #FUN-680010
           EXIT WHILE
        END IF
        #若更改KEY 值
        IF g_ecd.ecd01 != g_ecd01_t THEN
           UPDATE ecz_file SET (ecz01)=(g_ecd.ecd01)
               WHERE ecz01 = g_ecd01_t
           IF SQLCA.sqlcode THEN 
             #CALL cl_err('update:',SQLCA.sqlcode,0)  #No.FUN-660091
              CALL cl_err3("upd","ecz_file",g_ecd01_t,"",SQLCA.SQLCODE,"","update:",1) #FUN-660091          
              ROLLBACK WORK     #FUN-680010
              BEGIN WORK        #FUN-680010
              CONTINUE WHILE    #FUN-680010
           END IF
        END IF
        UPDATE ecd_file SET ecd_file.* = g_ecd.*    # 更新DB
            WHERE ecd01 = g_ecd.ecd01               # COLAUTH?
       #IF SQLCA.sqlcode THEN
        IF SQLCA.SQLERRD[3]=0 THEN   #FUN-680010
           LET g_msg=g_ecd.ecd01 CLIPPED
          #CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
           CALL cl_err3("upd","ecd_file",g_ecd01_t,"",SQLCA.SQLCODE,"","",1) #FUN-660091
           ROLLBACK WORK     #FUN-680010
           BEGIN WORK        #FUN-680010
           CONTINUE WHILE
        END IF
 
        #FUN-680010 
        IF g_action_choice <> "reproduce" THEN
           # CALL aws_spccli_base()
           # 傳入參數: (1)TABLE名稱, (2)修改資料,
           #           (3)功能選項：insert(新增),update(修改),delete(刪除)
           CASE aws_spccli_base('ecd_file',base.TypeInfo.create(g_ecd),'update')    
              WHEN 0  #無與 SPC 整合
                   #LET g_u_flag='0'                     #FUN-870101 add   #FUN-9A0056 mark
                   MESSAGE 'UPDATE O.K'
                   LET g_success = 'Y'                   #FUN-9A0056 add
                   #COMMIT WORK       #FUN-870101 mark
              WHEN 1  #呼叫 SPC 成功
                   #LET g_u_flag='0'                     #FUN-870101 add   #FUN-9A0056 mark
                   MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                   LET g_success = 'Y'                   #FUN-9A0056 add
                   #COMMIT WORK       #FUN-870101 mark
              WHEN 2  #呼叫 SPC 失敗
                   LET g_success = 'N'                   #FUN-9A0056 add
                   #LET g_u_flag='1'                     #FUN-870101 add   #FUN-9A0056 mark
                   #ROLLBACK WORK     #FUN-870101 mark
                   #BEGIN WORK        #FUN-870101 mark
                   #CONTINUE WHILE                       #FUN-9A0056 mark
           END CASE
 
           IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN  #FUN-9A0056 add
          #IF g_aza.aza90 MATCHES "[Yy]" THEN                      #TQC-8B0011 ADD #FUN-9A0056 mark
              CALL i620_mes('update',g_ecd.ecd01)                  #FUN-9A0056 add
              #FUN-870101---add---str---
              # CALL aws_mescli()
              # 傳入參數: (1)程式代號
              #           (2)功能選項：insert(新增),update(修改),delete(刪除)
              #           (3)Key
              #CASE aws_mescli('aeci620','update',g_ecd.ecd01)
              #   WHEN 0  #無與 MES 整合
              #        LET g_u_flag='0'                  
              #        MESSAGE 'UPDATE O.K'
              #   WHEN 1  #呼叫 MES 成功
              #        LET g_u_flag='0'                  
              #        MESSAGE 'UPDATE O.K, UPDATE MES O.K'
              #   WHEN 2  #呼叫 MES 失敗
              #        LET g_u_flag='1'                  
              #        CONTINUE WHILE
              #END CASE
              #FUN-870101---add---end---
           END IF  #TQC-8B0011  ADD
         END IF
        #END FUN-680010 
       #IF g_u_flag='1' THEN ROLLBACK WORK ELSE COMMIT WORK END IF #FUN-870101 add  #FUN-9A0056 mark

       #FUN-9A0056 add str ------
        IF g_success = 'N' THEN
           ROLLBACK WORK
           BEGIN WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
       #FUN-9A0056 add end ------
        EXIT WHILE
    END WHILE
    CLOSE i620_cl
   #COMMIT WORK      #FUN-680010
END FUNCTION
 
FUNCTION i620_x()
    DEFINE
        l_chr LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecd.ecd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_success = 'Y'  #FUN-9A0056 add
    BEGIN WORK
 
    OPEN i620_cl USING g_ecd.ecd01
    IF STATUS THEN
       CALL cl_err("OPEN i620_cl:", STATUS, 1)
       CLOSE i620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i620_cl INTO g_ecd.*
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecd.ecd01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i620_show()
    IF cl_exp(15,21,g_ecd.ecdacti) THEN
        LET g_chr=g_ecd.ecdacti
        IF g_ecd.ecdacti='Y' THEN
            LET g_ecd.ecdacti='N'
        ELSE
            LET g_ecd.ecdacti='Y'
        END IF
        UPDATE ecd_file
            SET ecdacti=g_ecd.ecdacti,
               ecdmodu=g_user, ecddate=g_today
            WHERE ecd01=g_ecd.ecd01
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_msg=g_ecd.ecd01 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("upd","ecd_file",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
            LET g_ecd.ecdacti=g_chr
        #FUN-870101---add---str---
            LET g_success = 'N'                 #FUN-9A0056 add
        ELSE
 
           IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
              #FUN-9A0056 mark str -------
              #FUN-870101---add---str---
              # CALL aws_mescli()
              # 傳入參數: (1)程式代號
              #           (2)功能選項：insert(新增),update(修改),delete(刪除)
              #           (3)Key
              #CASE aws_mescli('aeci620','delete',g_ecd.ecd01)
              #   WHEN 0  #無與 MES 整合
              #        MESSAGE 'DELETE O.K'
              #   WHEN 1  #呼叫 MES 成功
              #        MESSAGE 'DELETE O.K, DELETE MES O.K'
              #   WHEN 2  #呼叫 MES 失敗
              #        RETURN FALSE
              #END CASE
              #FUN-870101---add---end---a
              #FUN-9A0056 mark end -------

             #FUN-9A0056 add str ---------
             #當資料為有效變無效,傳送刪除給MES;反之,則傳送新增給MES
              IF g_ecd.ecdacti='N' THEN
                 CALL i620_mes('delete',g_ecd.ecd01)
              ELSE
                 CALL i620_mes('insert',g_ecd.ecd01)
              END IF
             #FUN-9A0056 add end --------
           END  IF  #TQC-8B0011  ADD
        END IF
        DISPLAY BY NAME g_ecd.ecdacti
    END IF
    CLOSE i620_cl
   #FUN-9A0056 -- add begin ----
    IF g_success = 'N' THEN
       ROLLBACK WORK
       RETURN
    ELSE
       COMMIT WORK
    END IF
   #FUN-9A0056 -- add end ------

   #COMMIT WORK     #FUN-9A0056 mark
END FUNCTION
 
FUNCTION i620_r()
    DEFINE  l_chr LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecd.ecdacti = 'N' THEN CALL cl_err('','9027',0) RETURN END IF #No.TQC-920063 ADD
    IF g_ecd.ecd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    LET g_success = 'Y'        #FUN-9A0056 add 
    BEGIN WORK
 
    OPEN i620_cl USING g_ecd.ecd01
    IF STATUS THEN
       CALL cl_err("OPEN i620_cl:", STATUS, 1)
       CLOSE i620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i620_cl INTO g_ecd.*
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecd.ecd01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       ROLLBACK WORK    #FUN-680010
       RETURN
    END IF
    CALL i620_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ecd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ecd.ecd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ecd_file WHERE ecd01 = g_ecd.ecd01
       #FUN-680010
       #IF SQLCA.sqlcode THEN       #FUN-680010
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","ecd_file",g_ecd.ecd01,"",SQLCA.sqlcode,"","",1)
         #ROLLBACK WORK                    #FUN-9A0056 mark
         #RETURN                           #FUN-9A0056 mark
          LET g_success = 'N'              #FUN-9A0056 add
       ELSE 
          # CALL aws_spccli_base()
          # 傳入參數: (1)TABLE名稱, (2)刪除資料,
          #           (3)功能選項：insert(新增),update(修改),delete(刪除)
          CASE aws_spccli_base('ecd_file',base.TypeInfo.create(g_ecd),'delete')   
             WHEN 0  #無與 SPC 整合
                  MESSAGE 'DELETE O.K'
             WHEN 1  #呼叫 SPC 成功
                  MESSAGE 'DELETE O.K, DELETE SPC O.K'
             WHEN 2  #呼叫 SPC 失敗
                 #ROLLBACK WORK             #FUN-9A0056 mark
                 #RETURN                    #FUN-9A0056 mark
                  LET g_success = 'N'       #FUN-9A0056 add
          END CASE
       #END FUN-680010 
 
          IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN    #FUN-9A0056 add
             CALL i620_mes('delete',g_ecd_t.ecd01)                  #FUN-9A0056 add
          END IF                                                    #FUN-9A0056 add

          CLEAR FORM         
          OPEN i620_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i620_cs
             CLOSE i620_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i620_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i620_cs
             CLOSE i620_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i620_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i620_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE
             CALL i620_fetch('/')
          END IF
       END IF
    END IF
    CLOSE i620_cl
   #COMMIT WORK                    #FUN-9A0056 mark

   #FUN-9A0056 -- add begin ----
    IF g_success = 'N' THEN
       ROLLBACK WORK
       RETURN
    ELSE
       COMMIT WORK
    END IF
   #FUN-9A0056 -- add end ------
END FUNCTION
 
FUNCTION i620_copy()
DEFINE  l_n             LIKE type_file.num5,         #No.FUN-680073 SMALLINT
        l_newno1        LIKE ecd_file.ecd01,
        l_oldno1        LIKE ecd_file.ecd01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecd.ecd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i620_set_entry('a')
    CALL i620_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1 FROM ecd01
        AFTER FIELD ecd01
            IF l_newno1 IS NULL THEN
                NEXT FIELD ecd01
            END IF
            SELECT count(*) INTO g_cnt FROM ecd_file
                WHERE ecd01 = l_newno1
            IF g_cnt > 0 THEN
                LET g_msg=l_newno1 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD ecd01
            END IF
 
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
        DISPLAY BY NAME g_ecd.ecd01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM ecd_file
        WHERE ecd01=g_ecd.ecd01
        INTO TEMP x
    UPDATE x
        SET ecd01=l_newno1,   #資料鍵值-1
            ecduser=g_user,   #資料所有者
            ecdgrup=g_grup,   #資料所有者所屬群
            ecdmodu=NULL,     #資料修改日期
            ecddate=g_today,  #資料建立日期
            ecdacti='Y'       #有效資料

    LET g_success = 'Y'      #FUN-9A0056 add 
    BEGIN WORK      #FUN-680010
 
    INSERT INTO ecd_file
        SELECT * FROM x
    #IF SQLCA.sqlcode THEN       #FUN-680010
    IF SQLCA.SQLERRD[3]=0 THEN     #FUN-680010
       LET g_msg=g_ecd.ecd01 CLIPPED
      #CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("ins","ecd_file",g_msg,"",SQLCA.SQLCODE,"","",1) #FUN-660091
      #ROLLBACK WORK        #FUN-680010        #FUN-9A0056 mark
       LET g_success = 'N'                     #FUN-9A0056 add
    ELSE
      #MESSAGE 'ROW(',l_newno1 CLIPPED,') O.K'    #FUN-680010
       LET l_oldno1 = g_ecd.ecd01
       SELECT ecd_file.* INTO g_ecd.* FROM ecd_file
              WHERE ecd01 =  l_newno1
       CALL i620_u()
       ##FUN-680010
      #CALL i620_show()      
 
       # CALL aws_spccli_base()
       # 傳入參數: (1)TABLE名稱, (2)新增資料,
       #           (3)功能選項：insert(新增),update(修改),delete(刪除)
       CASE aws_spccli_base('ecd_file',base.TypeInfo.create(g_ecd),'insert')    
          WHEN 0  #無與 SPC 整合
               MESSAGE 'INSERT O.K'
              #LET g_u_flag='0'     #FUN-870101 add     #FUN-9A0056 mark       
               #COMMIT WORK         #FUN-870101 mark
          WHEN 1  #呼叫 SPC 成功
               MESSAGE 'INSERT O.K, INSERT SPC O.K'
              #LET g_u_flag='0'     #FUN-870101 add     #FUN-9A0056 mark       
               #COMMIT WORK         #FUN-870101 mark  
          WHEN 2  #呼叫 SPC 失敗
               LET g_success = 'N'  #FUN-9A0056 add
              #LET g_u_flag='1'     #FUN-870101 add     #FUN-9A0056 mark            
               #ROLLBACK WORK       #FUN-870101 mark
       END CASE
       ##FUN-680010 

      ##FUN-9A0056 mark str --------------- 
      #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
      #    #FUN-870101---add---str---
      #    # CALL aws_mescli()
      #    # 傳入參數: (1)程式代號
      #    #           (2)功能選項：insert(新增),update(修改),delete(刪除)
      #    #           (3)Key
      #    CASE aws_mescli('aeci620','insert',g_ecd.ecd01)
      #       WHEN 0  #無與 MES 整合
      #            LET g_u_flag='0'                  
      #            MESSAGE 'INSERT O.K'
      #       WHEN 1  #呼叫 MES 成功
      #            LET g_u_flag='0'                  
      #            MESSAGE 'INSERT O.K, INSERT MES O.K'
      #       WHEN 2  #呼叫 MES 失敗
      #            LET g_u_flag='1'                  
      #    END CASE
      #    IF g_u_flag='1' THEN ROLLBACK WORK ELSE COMMIT WORK END IF  
      #    #FUN-870101---add---end---
      ##FUN-9A0056 mark end---------------

       IF g_aza.aza90 MATCHES "[Yy]" AND g_success = 'Y' THEN     #FUN-9A0056 add
          CALL i620_mes('insert',g_ecd.ecd01)                     #FUN-9A0056 add
       END IF  #TQC-8B0011  ADD
       #FUN-C30027---begin
       #LET g_ecd.ecd01 = l_oldno1
       #SELECT ecd_file.* INTO g_ecd.* FROM ecd_file
       #       WHERE ecd01 = g_ecd.ecd01
       #CALL i620_show()      #FUN-680010
       #FUN-C30027---end
    END IF

   #FUN-9A0056 -- add begin ----
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
   #FUN-9A0056 -- add end ------

    CALL i620_show()         #FUN-680010
    DISPLAY BY NAME g_ecd.ecd01
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION i620_out()
#    DEFINE
#        l_i               LIKE type_file.num5,    #No.FUN-680073 SMALLINT
#        l_ecd RECORD
#                  ecd01   LIKE  ecd_file.ecd01,   #作業編號
#                  ecd02   LIKE  ecd_file.ecd02,   #作業description
#                  ecd05   LIKE  ecd_file.ecd05,   #作業形態
#                  ecd07   LIKE  ecd_file.ecd07,   #工作中心
#                  ecd09   LIKE  ecd_file.ecd09,   #作業重疊程度
#                  ecdacti LIKE  ecd_file.ecdacti
#           END RECORD,
#        l_name            LIKE type_file.chr20,   #No.FUN-680073 VARCHAR(20)  # External(Disk) file name
#        l_za05            LIKE za_file.za05,      #No.FUN-680073 VARCHAR(40)  #
#        l_chr             LIKE type_file.chr1     #No.FUN-680073 VARCHAR(1)
DEFINE l_cmd           LIKE type_file.chr1000
     IF cl_null(g_wc) AND NOT cl_null(g_ecd.ecd01) THEN
        LET g_wc=" ecd01='",g_ecd.ecd01,"'"
     END IF
 
     IF g_wc IS NULL THEN
    #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
     END IF
      #報表轉為使用 p_query                                                       
    LET l_cmd = 'p_query "aeci620" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)                                                       
    RETURN
#    CALL cl_wait()
#   LET l_name = 'aeci620.out'
#    CALL cl_outnam('aeci620') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT ecd01,ecd02,ecd05,", # 組合出 SQL 指令
#              " ecd07,ecd09,ecdacti",
#              " FROM ecd_file ",
#              " WHERE ",g_wc CLIPPED
#    PREPARE i620_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i620_co                         # SCROLL CURSOR
#        CURSOR FOR i620_p1
 
#    START REPORT i620_rep TO l_name
 
#    FOREACH i620_co INTO l_ecd.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i620_rep(l_ecd.*)
#    END FOREACH
 
#    FINISH REPORT i620_rep
 
#    CLOSE i620_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i620_rep(sr)
#    DEFINE
#        l_trailer_sw      LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1)
#        sr RECORD
#                  ecd01   LIKE  ecd_file.ecd01,   #作業編號
#                  ecd02   LIKE  ecd_file.ecd02,   #作業description
#                  ecd05   LIKE  ecd_file.ecd05,   #作業形態
#                  ecd07   LIKE  ecd_file.ecd07,   #工作中心
#                  ecd09   LIKE  ecd_file.ecd09,   #作業重疊程度
#                  ecdacti LIKE  ecd_file.ecdacti
#           END RECORD,
#        l_sw1,l_sw2    LIKE type_file.chr1,       #No.FUN-680073 VARCHAR(1)
#        l_chr          LIKE type_file.chr1        #No.FUN-680073 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.ecd01,sr.ecd02
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
 
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
 
#        BEFORE GROUP OF sr.ecd01
#            LET l_sw1 = 'Y'
#
#        BEFORE GROUP OF sr.ecd02
#            LET l_sw2 = 'Y'
# 
#        ON EVERY ROW
#             IF sr.ecdacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF     #--MOD-530132
#            IF l_sw1 = 'Y' THEN
#               PRINT COLUMN g_c[32],sr.ecd01;
#               LET l_sw1 = 'N'
#            END IF
#            IF l_sw2 = 'Y' THEN
#               PRINT COLUMN g_c[33],sr.ecd02;
#               LET l_sw2 = 'N'
#            END IF
#            CASE sr.ecd05
#                 WHEN '1'  PRINT COLUMN g_c[34],g_x[9] CLIPPED;
#                 WHEN '2'  PRINT COLUMN g_c[34],g_x[10] CLIPPED;
#                 WHEN '3'  PRINT COLUMN g_c[34],g_x[11] CLIPPED;
#                 WHEN '4'  PRINT COLUMN g_c[34],g_x[12] CLIPPED;
#                 OTHERWISE EXIT CASE
#            END CASE
#            PRINT COLUMN g_c[35],sr.ecd07,
#                  COLUMN g_c[36],sr.ecd09
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash2[1,g_len] #No.TQC-5C0005
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#                  #IF g_wc[001,080] > ' ' THEN
#       	   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                  #IF g_wc[071,140] > ' ' THEN
#       	   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                  #IF g_wc[141,210] > ' ' THEN
#       	   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#           END IF
#           PRINT g_dash[1,g_len] #No.TQC-5C0005
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end--
 
FUNCTION i620_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ecd01",TRUE)
   END IF
END FUNCTION

#FUN-9A0056 add:FUNCTION i620_mes
FUNCTION i620_mes(p_key1,p_key2)
 DEFINE p_key1   VARCHAR(6)
 DEFINE p_key2   VARCHAR(500)
 DEFINE l_mesg01 VARCHAR(30)

 CASE p_key1
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli('aeci620',p_key1,p_key2)
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
 END CASE
END FUNCTION
FUNCTION i620_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1         #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ecd01",FALSE)
   END IF
END FUNCTION
 
#darcy:2023/06/25 add s---
##############################################################################
--              aeci620_set_como
--              Descripcion:设置下拉框资料内容
--              Autor:darcy
##############################################################################
FUNCTION aeci620_set_como()
   define l_fields,l_values varchar(200)
   define l_str  string

   

END FUNCTION     ###     aeci620_set_como()
#darcy:2023/06/25 add e---
