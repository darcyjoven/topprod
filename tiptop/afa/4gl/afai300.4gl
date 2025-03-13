# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afai300.4gl
# Descriptions...: 模具資料維護作業
# Date & Author..: 00/2/29 By Alex Lin
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510035 05/01/31 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-590360 05/09/19 By Dido SQLCA.sqlcode 位置微調
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i300_q()一開始應清空g_fea.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/07/27 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-890096 08/09/22 BY DUKE add APS工模具主檔維護 ACTION
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0069 09/11/23 By jan 拿掉程式里feaoriu/feaorig 字段
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50046 11/05/10 by abby GP5.25 APS追版 str-----
# Modify.........: No:TQC-940012 09/04/02 BY DUKE 當無資料時,按下ACTION不造成作業CLOSE
# Modify.........: No.FUN-B50046 11/05/10 by abby GP5.25 APS追版 end-----
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C20289 12/02/22 By wangrr   修改操作時單頭主鍵fea01沒有更改 
# Modify.........: No.TQC-C50043 12/05/07 By xuxz feb06不可以小於feb12
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fea           RECORD LIKE fea_file.*,
    g_fea_t         RECORD LIKE fea_file.*,
    g_fea_o         RECORD LIKE fea_file.*,
    g_fea01_t       LIKE fea_file.fea01,
    g_feb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        feb02       LIKE feb_file.feb02,
        feb04       LIKE feb_file.feb04,
        feb05       LIKE feb_file.feb05,
        feb03       LIKE feb_file.feb03,
        feb06       LIKE feb_file.feb06,
        feb07       LIKE feb_file.feb07,
        feb09       LIKE feb_file.feb09,
        feb08       LIKE feb_file.feb08,
        pmc03       LIKE pmc_file.pmc03,
        feb10       LIKE feb_file.feb10,
        feb11       LIKE feb_file.feb11,
        feb12       LIKE feb_file.feb12,
        feb13       LIKE feb_file.feb13,
        febud01     LIKE feb_file.febud01,
        febud02     LIKE feb_file.febud02,
        febud03     LIKE feb_file.febud03,
        febud04     LIKE feb_file.febud04,
        febud05     LIKE feb_file.febud05,
        febud06     LIKE feb_file.febud06,
        febud07     LIKE feb_file.febud07,
        febud08     LIKE feb_file.febud08,
        febud09     LIKE feb_file.febud09,
        febud10     LIKE feb_file.febud10,
        febud11     LIKE feb_file.febud11,
        febud12     LIKE feb_file.febud12,
        febud13     LIKE feb_file.febud13,
        febud14     LIKE feb_file.febud14,
        febud15     LIKE feb_file.febud15
                    END RECORD,
    g_feb_t         RECORD                 #程式變數(Program Variables)
        feb02       LIKE feb_file.feb02,
        feb04       LIKE feb_file.feb04,
        feb05       LIKE feb_file.feb05,
        feb03       LIKE feb_file.feb03,
        feb06       LIKE feb_file.feb06,
        feb07       LIKE feb_file.feb07,
        feb09       LIKE feb_file.feb09,
        feb08       LIKE feb_file.feb08,
        pmc03       LIKE pmc_file.pmc03,
        feb10       LIKE feb_file.feb10,
        feb11       LIKE feb_file.feb11,
        feb12       LIKE feb_file.feb12,
        feb13       LIKE feb_file.feb13,
        febud01     LIKE feb_file.febud01,
        febud02     LIKE feb_file.febud02,
        febud03     LIKE feb_file.febud03,
        febud04     LIKE feb_file.febud04,
        febud05     LIKE feb_file.febud05,
        febud06     LIKE feb_file.febud06,
        febud07     LIKE feb_file.febud07,
        febud08     LIKE feb_file.febud08,
        febud09     LIKE feb_file.febud09,
        febud10     LIKE feb_file.febud10,
        febud11     LIKE feb_file.febud11,
        febud12     LIKE feb_file.febud12,
        febud13     LIKE feb_file.febud13,
        febud14     LIKE feb_file.febud14,
        febud15     LIKE feb_file.febud15
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING   , #TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_cmd           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
MAIN
DEFINE p_row,p_col LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_forupd_sql = " SELECT * FROM fea_file WHERE fea01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_cl CURSOR FROM g_forupd_sql
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                                              #NO.FUN-6A0069
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW i300_w AT p_row,p_col              #顯示畫面
        WITH FORM "afa/42f/afai300"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL i300_menu()
    CLOSE WINDOW i300_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                         #NO.FUN-6A0069    
END MAIN
 
#QBE 查詢資料
FUNCTION i300_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_feb.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fea.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON fea01,fea02,fea031,fea032,
                              #FUN-850068   ---start---
                              feaud01,feaud02,feaud03,feaud04,feaud05,
                              feaud06,feaud07,feaud08,feaud09,feaud10,
                              feaud11,feaud12,feaud13,feaud14,feaud15
                              #FUN-850068    ----end----
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON feb02,feb04,feb05,feb03,feb06,feb07,feb09,feb08,
                       pmc03,feb10,feb11,feb12,feb13
                       ,febud01,febud02,febud03,febud04,febud05
                       ,febud06,febud07,febud08,febud09,febud10
                       ,febud11,febud12,febud13,febud14,febud15
            FROM s_feb[1].feb02, s_feb[1].feb04, s_feb[1].feb05,
                 s_feb[1].feb03, s_feb[1].feb06, s_feb[1].feb07,
                 s_feb[1].feb09, s_feb[1].feb08, s_feb[1].pmc03,s_feb[1].feb10,
                 s_feb[1].feb11, s_feb[1].feb12, s_feb[1].feb13
                 ,s_feb[1].febud01,s_feb[1].febud02,s_feb[1].febud03
                 ,s_feb[1].febud04,s_feb[1].febud05,s_feb[1].febud06
                 ,s_feb[1].febud07,s_feb[1].febud08,s_feb[1].febud09
                 ,s_feb[1].febud10,s_feb[1].febud11,s_feb[1].febud12
                 ,s_feb[1].febud13,s_feb[1].febud14,s_feb[1].febud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    ON ACTION CONTROLP
          CASE
              WHEN INFIELD(feb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_faj"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO feb04
                   NEXT FIELD feb04
              WHEN INFIELD(feb08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_pmc"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO feb08
                   NEXT FIELD feb08
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('feauser', 'feagrup')
 
 
    IF g_wc2 = " 1=1 " THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fea01 FROM fea_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fea01 ",
                   "  FROM fea_file, feb_file",
                   " WHERE fea01 = feb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i300_prepare FROM g_sql
    DECLARE i300_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i300_prepare
 
    IF g_wc2 = " 1=1 " THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fea_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql=" SELECT COUNT(DISTINCT fea01) FROM fea_file,feb_file ",
                  " WHERE feb01=fea01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i300_precount FROM g_sql
    DECLARE i300_count CURSOR FOR i300_precount
END FUNCTION
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i300_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i300_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fea.fea01 IS NOT NULL THEN
                  LET g_doc.column1 = "fea01"
                  LET g_doc.value1 = g_fea.fea01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_feb),'','')
            END IF
         #FUN-890096 add APS工模具主檔維護
         WHEN "aps_tools_main"
               IF g_rec_b >0 THEN  #TQC-940012  ADD
                  SELECT g_feb[l_ac].feb02 FROM vnj_file WHERE vnj01 =g_feb[l_ac].feb02
                  IF SQLCA.SQLCODE=100 THEN
                     INSERT INTO vnj_file(vnj01)
                             VALUES(g_feb[l_ac].feb02)
                     IF STATUS THEN
                        CALL cl_err3("ins","vnj_file",g_feb[l_ac].feb02,"",SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
                  LET l_cmd = "apsi329 ","'", g_feb[l_ac].feb02,"'"
                  CALL cl_cmdrun(l_cmd)
                ELSE                           #TQC-940012 ADD
                  CALL cl_err('','arm-034',1)  #TQC-940012 ADD
                END IF                         #TQC-940012 ADD
         #FUN-890096 add APS工模具保修明細
         WHEN "aps_tools_fixeddtl"
               IF g_rec_b >0 THEN  #TQC-940012  ADD
                  LET l_cmd = "apsi332 ","'", g_feb[l_ac].feb02,"'"
                  CALL cl_cmdrun(l_cmd)
               ELSE                           #TQC-940012 ADD
                  CALL cl_err('','arm-034',1)  #TQC-940012 ADD
               END IF                         #TQC-940012 ADD
         #FUN-890096 add APS工模具產能型態維護作業                                     .
         WHEN "aps_tools_capicity"                           
              IF g_rec_b >0 THEN #TQC-940012 ADD                  
                 SELECT * FROM vno_file WHERE vno01 =g_fea.fea01
                 IF SQLCA.SQLCODE=100 THEN
                    INSERT INTO vno_file(vno01,vno02)
                            VALUES(g_fea.fea01,0)
                    IF STATUS THEN
                       CALL cl_err3("ins","vno_file",g_fea.fea01,"",SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
                 LET l_cmd = "apsi333 ","'", g_fea.fea01,"'"
                 CALL cl_cmdrun(l_cmd)
               ELSE                           #TQC-940012 ADD
                  CALL cl_err('','arm-034',1)  #TQC-940012 ADD
               END IF                         #TQC-940012 ADD 
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i300_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_feb.clear()
    INITIALIZE g_fea.* LIKE fea_file.*             #DEFAULT 設定
    LET g_fea01_t = NULL
    LET g_fea_o.* = g_fea.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fea.feaconf='Y'
        LET g_fea.feaacti='Y'
        LET g_fea.feauser=g_user
        LET g_fea.feagrup=g_grup
        LET g_fea.feamodu=''
        LET g_fea.feadate=g_today
        CALL i300_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fea.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fea.fea01 IS NULL THEN        # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO fea_file VALUES(g_fea.*)
        IF SQLCA.sqlcode THEN                           #置入資料庫不成功
            CALL cl_err3("ins","fea_file",g_fea.fea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        SELECT fea01 INTO g_fea.fea01 FROM fea_file
            WHERE fea01 = g_fea.fea01
        LET g_fea01_t = g_fea.fea01        #保留舊值
        LET g_fea_t.* = g_fea.*
        LET g_rec_b=0
        CALL i300_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i300_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fea.fea01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fea01_t = g_fea.fea01
    LET g_fea_o.* = g_fea.*
    BEGIN WORK
 
    OPEN i300_cl USING g_fea.fea01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_fea.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fea.fea01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i300_cl ROLLBACK WORK RETURN
    END IF
    CALL i300_show()
    WHILE TRUE
        LET g_fea_t.* = g_fea.*
        CALL i300_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fea.*=g_fea_t.*
            CALL i300_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fea.fea01 != g_fea_t.fea01 THEN
            UPDATE feb_file SET feb01 = g_fea.fea01
                WHERE feb01 = g_fea01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","feb_file",g_fea.fea01,"",SQLCA.sqlcode,"","feb",1)  #No.FUN-660136
                CONTINUE WHILE  
            END IF
        END IF
        UPDATE fea_file SET fea01 = g_fea.fea01,
                            fea02 = g_fea.fea02,
                            fea031 = g_fea.fea031,
                            fea032 = g_fea.fea032,
                            feamodu = g_user,
                            feadate = g_today,
                            feaud01 = g_fea.feaud01,feaud02 = g_fea.feaud02,
                            feaud03 = g_fea.feaud03,feaud04 = g_fea.feaud04,
                            feaud05 = g_fea.feaud05,feaud06 = g_fea.feaud06,
                            feaud07 = g_fea.feaud07,feaud08 = g_fea.feaud08,
                            feaud09 = g_fea.feaud09,feaud10 = g_fea.feaud10,
                            feaud11 = g_fea.feaud11,feaud12 = g_fea.feaud12,
                            feaud13 = g_fea.feaud13,feaud14 = g_fea.feaud14,
                            feaud15 = g_fea.feaud15
           #WHERE fea01 = g_fea.fea01   #TQC-C20289 mark--
            WHERE fea01 = g_fea01_t     #TQC-C20289
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","fea_file",g_fea01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i300_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i300_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
    l_count         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_n1            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
    INPUT BY NAME g_fea.fea01,g_fea.fea02,g_fea.fea031,g_fea.fea032, #g_fea.feaoriu,g_fea.feaorig, #TQC-9B0069
                  g_fea.feaud01,g_fea.feaud02,g_fea.feaud03,g_fea.feaud04,
                  g_fea.feaud05,g_fea.feaud06,g_fea.feaud07,g_fea.feaud08,
                  g_fea.feaud09,g_fea.feaud10,g_fea.feaud11,g_fea.feaud12,
                  g_fea.feaud13,g_fea.feaud14,g_fea.feaud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i300_set_entry(p_cmd)
           CALL i300_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD fea01
          IF NOT cl_null(g_fea.fea01) THEN
             IF p_cmd='a' OR (p_cmd='u'AND g_fea.fea01 != g_fea_t.fea01) THEN
                SELECT count(*) INTO g_cnt FROM fea_file
                 WHERE fea01 = g_fea.fea01
                IF g_cnt > 0 THEN   #資料重複
                   CALL cl_err('select fea',-239,0)
                   LET g_fea.fea01 = g_fea01_t
                   DISPLAY BY NAME g_fea.fea01
                   NEXT FIELD fea01
                END IF
             END IF
          END IF
	  LET g_fea_o.fea01 = g_fea.fea01
 
        AFTER FIELD feaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD feaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION i300_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fea01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fea01",FALSE)
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION i300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fea.* TO NULL             #No.FUN-6A0001    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i300_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fea.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fea.* TO NULL
    ELSE
        OPEN i300_count
        FETCH i300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     i300_cs INTO g_fea.fea01
    WHEN 'P' FETCH PREVIOUS i300_cs INTO g_fea.fea01
    WHEN 'F' FETCH FIRST    i300_cs INTO g_fea.fea01
    WHEN 'L' FETCH LAST     i300_cs INTO g_fea.fea01
    WHEN '/'
         IF (NOT mi_no_ask) THEN
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
         PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
        FETCH ABSOLUTE g_jump i300_cs INTO g_fea.fea01
         LET mi_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fea.fea01,SQLCA.sqlcode,0)
        INITIALIZE g_fea.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fea.* FROM fea_file WHERE fea01 = g_fea.fea01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fea_file",g_fea.fea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fea.* TO NULL
        RETURN
    END IF
    LET g_data_owner=g_fea.feauser   #FUN-4C0059
    LET g_data_group=g_fea.feagrup   #FUN-4C0059
    CALL i300_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i300_show()
    LET g_fea_t.* = g_fea.*                #保存單頭舊值
    DISPLAY BY NAME g_fea.fea01,g_fea.fea02,g_fea.fea031,g_fea.fea032, #g_fea.feaoriu,g_fea.feaorig, #TQC-9B0069
                    g_fea.feaud01,g_fea.feaud02,g_fea.feaud03,g_fea.feaud04,
                    g_fea.feaud05,g_fea.feaud06,g_fea.feaud07,g_fea.feaud08,
                    g_fea.feaud09,g_fea.feaud10,g_fea.feaud11,g_fea.feaud12,
                    g_fea.feaud13,g_fea.feaud14,g_fea.feaud15 
 
    CALL i300_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i300_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
           l_n          LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_feb12 LIKE feb_file.feb12,
           l_feb02 LIKE feb_file.feb02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fea.fea01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT COUNT(*) INTO l_n FROM feb_file
     WHERE feb01 = g_fea.fea01 AND feb12 > 0
    IF l_n > 0 THEN CALL cl_err('','afa-917',0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i300_cl USING g_fea.fea01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_fea.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fea.fea01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i300_cl ROLLBACK WORK RETURN
    END IF
    LET g_success='Y'
    WHILE TRUE
 
      OPEN i300_cl USING g_fea.fea01
      IF STATUS THEN
         CALL cl_err("OPEN i300_cl:", STATUS, 1)
         CLOSE i300_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i300_cl INTO g_fea.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_fea.fea01,SQLCA.sqlcode,0)  EXIT WHILE
      END IF
      CALL i300_show()
      IF cl_delete() THEN
          INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "fea01"         #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_fea.fea01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
         DELETE FROM fea_file WHERE fea01 = g_fea.fea01
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("del","fea_file",g_fea.fea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            LET g_success='N'
            EXIT WHILE
        END IF
 
        #FUN-890096 刪除對應之APS資料
        DECLARE i300_2_c2 CURSOR FOR
          SELECT feb02 FROM feb_file WHERE feb01 = g_fea.fea01
        FOREACH i300_2_c2 INTO l_feb02
          DELETE FROM vnj_file where vnj01 = l_feb02
          DELETE FROM vnn_file WHERE vnn01 = l_feb02
          DELETE FROM vno_file WHERE vno01 = l_feb02
        END FOREACH
 
        DELETE FROM feb_file WHERE feb01 = g_fea.fea01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","feb_file",g_fea.fea01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           LET g_success='N'
        END IF
      END IF
      EXIT WHILE
    END WHILE
    CLOSE i300_cl
    IF g_success='Y' THEN
       CLEAR FORM
       CALL g_feb.clear()
       INITIALIZE g_fea.* LIKE fea_file.*             #DEFAULT 設定
       COMMIT WORK
       CALL cl_cmmsg('4')
         OPEN i300_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i300_cs
             CLOSE i300_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i300_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i300_cs
             CLOSE i300_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i300_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i300_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i300_fetch('/')
         END IF
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg('4')
    END IF
END FUNCTION
 
FUNCTION i300_b()
 
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_fea.fea01 IS NULL THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT feb02,feb04,feb05,feb03,feb06,feb07,feb09,feb08, ",
                       " '',feb10,feb11,feb12,feb13, ",
                       "       febud01,febud02,febud03,febud04,febud05,",
                       "       febud06,febud07,febud08,febud09,febud10,",
                       "       febud11,febud12,febud13,febud14,febud15 ", 
                       " FROM feb_file ",
                       " WHERE feb02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_feb.clear() END IF
 
 
        INPUT ARRAY g_feb WITHOUT DEFAULTS FROM s_feb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i300_cl USING g_fea.fea01
            IF STATUS THEN
               CALL cl_err("OPEN i300_cl:", STATUS, 1)
               CLOSE i300_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i300_cl INTO g_fea.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fea.fea01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i300_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_feb_t.* = g_feb[l_ac].*  #BACKUP
 
                OPEN i300_bcl USING g_feb_t.feb02
                IF STATUS THEN
                   CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                   CLOSE i300_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i300_bcl INTO g_feb_t.*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_feb_t.feb02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_feb[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_feb[l_ac].* TO s_feb.*
              CALL g_feb.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
             INSERT INTO feb_file (feb01,feb02,feb03,feb04,feb05,feb06,feb07, #No.MOD-470041
                                  feb08,feb09,feb10,feb11,feb12,feb13,
                                  febud01,febud02,febud03,febud04,febud05,
                                  febud06,febud07,febud08,febud09,febud10,
                                  febud11,febud12,febud13,febud14,febud15)
                 VALUES (g_fea.fea01,g_feb[l_ac].feb02,g_feb[l_ac].feb03,
                         g_feb[l_ac].feb04,g_feb[l_ac].feb05,g_feb[l_ac].feb06,
                         g_feb[l_ac].feb07,g_feb[l_ac].feb08,g_feb[l_ac].feb09,
                         g_feb[l_ac].feb10,g_feb[l_ac].feb11,g_feb[l_ac].feb12,
                         g_feb[l_ac].feb13,
                         g_feb[l_ac].febud01,g_feb[l_ac].febud02,
                         g_feb[l_ac].febud03,g_feb[l_ac].febud04,
                         g_feb[l_ac].febud05,g_feb[l_ac].febud06,
                         g_feb[l_ac].febud07,g_feb[l_ac].febud08,
                         g_feb[l_ac].febud09,g_feb[l_ac].febud10,
                         g_feb[l_ac].febud11,g_feb[l_ac].febud12,
                         g_feb[l_ac].febud13,g_feb[l_ac].febud14,
                         g_feb[l_ac].febud15)
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","feb_file",g_fea.fea01,g_feb[l_ac].feb02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                  CANCEL INSERT
              ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_feb[l_ac].* TO NULL      #900423
            LET g_feb_t.* = g_feb[l_ac].*         #新輸入資料
            LET g_feb[l_ac].feb05=' '
            LET g_feb[l_ac].feb09 = 0
            LET g_feb[l_ac].feb10 = 0
            LET g_feb[l_ac].feb11 = 0
            LET g_feb[l_ac].feb12 = 0
            LET g_feb[l_ac].feb13 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD feb02
 
        AFTER FIELD feb02
            IF (p_cmd='a' AND NOT cl_null(g_feb[l_ac].feb02)) OR (p_cmd='u' AND
               g_feb[l_ac].feb02 != g_feb_t.feb02 )   #check 料號是否重複
            THEN
               SELECT COUNT(*) INTO l_n
                 FROM feb_file
                WHERE feb02 = g_feb[l_ac].feb02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_feb[l_ac].feb02 = g_feb_t.feb02
                  DISPLAY g_feb[l_ac].feb02 TO feb02
                  NEXT FIELD feb02
               END IF
            END IF
 
        BEFORE FIELD feb03
            IF cl_null(g_feb[l_ac].feb03)  THEN
               LET g_feb[l_ac].feb03=g_today
            DISPLAY BY NAME g_feb[l_ac].feb03
            END IF
 
        AFTER FIELD feb06
            IF NOT cl_null(g_feb[l_ac].feb06) THEN
               IF g_feb[l_ac].feb06 <= 0 THEN
                   CALL cl_err('','afa-037',0)
                   NEXT FIELD feb06
               END IF
               #TQC-C50043 --add--str
               IF g_feb[l_ac].feb06 < g_feb[l_ac].feb12 THEN
                   CALL cl_err('','afa-419',0)
                   NEXT FIELD feb06
               END IF
               #TQC-C50043 --add--end
            END IF
        AFTER FIELD feb04
            IF NOT cl_null(g_feb[l_ac].feb04) THEN
                IF (p_cmd='a' OR p_cmd='u' AND
                   (g_feb[l_ac].feb04 !=g_feb_t.feb04)) THEN
                    SELECT COUNT(*) INTO l_n FROM faj_file
                     WHERE faj02=g_feb[l_ac].feb04
                    IF l_n = 0 THEN
                       CALL cl_err('','afa-041',0)
                       LET g_feb[l_ac].feb04 = g_feb_t.feb04
                       NEXT FIELD feb04
                    END IF
                END IF
            END IF
        AFTER FIELD feb05
            IF cl_null(g_feb[l_ac].feb05)  THEN
               LET g_feb[l_ac].feb05=' '
               DISPLAY BY NAME g_feb[l_ac].feb05
            END IF
            IF NOT cl_null(g_feb[l_ac].feb05) THEN
                SELECT COUNT(*) INTO l_n FROM faj_file
                    WHERE faj02=g_feb[l_ac].feb04
                      AND faj022=g_feb[l_ac].feb05
                IF l_n = 0 THEN
                   CALL cl_err('','afa-041',0)
                   NEXT FIELD feb05
                END IF
            END IF
        AFTER FIELD feb07
            IF NOT cl_null(g_feb[l_ac].feb07) THEN
               IF g_feb[l_ac].feb07 <= 0 THEN
                   CALL cl_err('','afa-037',0)
                   NEXT FIELD feb07
               END IF
            END IF
         AFTER FIELD feb08
            IF NOT cl_null(g_feb[l_ac].feb08) THEN
               CALL i300_feb08('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_feb[l_ac].feb08,g_errno,0)
                   LET g_feb[l_ac].feb08 = g_feb_t.feb08
                   DISPLAY g_feb[l_ac].feb08 TO feb08
                   NEXT FIELD feb08
               END IF
 
               IF (p_cmd='a' OR p_cmd='u' AND
                  (g_feb[l_ac].feb08 !=g_feb_t.feb08)) THEN
                   SELECT COUNT(*) INTO l_n FROM pmc_file
                    WHERE pmc01=g_feb[l_ac].feb08
                   IF l_n = 0 THEN
                      CALL cl_err('','afa-044',0)
                      LET g_feb[l_ac].feb08 = g_feb_t.feb08
                      NEXT FIELD feb08
                   END IF
               END IF
            END IF
         AFTER FIELD feb10
            IF NOT cl_null(g_feb[l_ac].feb10) THEN
               IF g_feb[l_ac].feb10 < 0 THEN
                   CALL cl_err('','afa-040',0)
                   NEXT FIELD feb10
               END IF
            END IF
         AFTER FIELD feb11
            IF NOT cl_null(g_feb[l_ac].feb11) THEN
               IF g_feb[l_ac].feb11 < 0 THEN
                   CALL cl_err('','afa-040',0)
                   NEXT FIELD feb11
               END IF
            END IF
         AFTER FIELD feb13
            IF NOT cl_null(g_feb[l_ac].feb13) THEN
               IF g_feb[l_ac].feb13 <= 0 THEN
                   CALL cl_err('','afa-037',0)
                   NEXT FIELD feb13
               END IF
            END IF
 
         AFTER FIELD febud01
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud02
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud03
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud04
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud05
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud06
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud07
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud08
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud09
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud10
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud11
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud12
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud13
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud14
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD febud15
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_feb_t.feb02 IS NOT NULL THEN
               IF g_feb_t.feb12 > 0 THEN
                  CALL cl_err(' ','afa-916',0) RETURN END IF
               IF NOT cl_delb(0,0) THEN
                    COMMIT WORK
                     CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               #FUN-890096 DELETE 對應之APS工模具資料
               DELETE FROM vnj_file WHERE vnj01 = g_feb_t.feb02
               DELETE FROM vnn_file WHERE vnn01 = g_feb_t.feb02
               DELETE FROM vno_file WHERE vno01 = g_feb_t.feb02
 
               DELETE FROM feb_file WHERE feb02 = g_feb_t.feb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","feb_file",g_feb_t.feb02,"",SQLCA.sqlcode,"","del feb",1)  #No.FUN-660136
                  CANCEL DELETE
               ELSE
                  LET g_rec_b=g_rec_b-1
                  DISPLAY g_rec_b TO FORMONLY.cn2
                  COMMIT WORK
               END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_feb[l_ac].* = g_feb_t.*
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_feb[l_ac].feb02,-263,1)
               LET g_feb[l_ac].* = g_feb_t.*
            ELSE
               UPDATE feb_file SET
                  feb02=g_feb[l_ac].feb02,feb03=g_feb[l_ac].feb03,
                  feb06=g_feb[l_ac].feb06,feb04=g_feb[l_ac].feb04,
                  feb05=g_feb[l_ac].feb05,feb07=g_feb[l_ac].feb07,
                  feb08=g_feb[l_ac].feb08,feb10=g_feb[l_ac].feb10,
                  feb11=g_feb[l_ac].feb11,feb13=g_feb[l_ac].feb13,
                  feb09=g_feb[l_ac].feb09,
                  febud01 = g_feb[l_ac].febud01,febud02 = g_feb[l_ac].febud02,
                  febud03 = g_feb[l_ac].febud03,febud04 = g_feb[l_ac].febud04,
                  febud05 = g_feb[l_ac].febud05,febud06 = g_feb[l_ac].febud06,
                  febud07 = g_feb[l_ac].febud07,febud08 = g_feb[l_ac].febud08,
                  febud09 = g_feb[l_ac].febud09,febud10 = g_feb[l_ac].febud10,
                  febud11 = g_feb[l_ac].febud11,febud12 = g_feb[l_ac].febud12,
                  febud13 = g_feb[l_ac].febud13,febud14 = g_feb[l_ac].febud14,
                  febud15 = g_feb[l_ac].febud15
                 WHERE feb02=g_feb_t.feb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","feb_file",g_feb_t.feb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                  LET g_feb[l_ac].* = g_feb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                 LET g_feb[l_ac].* = g_feb_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_feb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i300_bcl
            COMMIT WORK
            CALL g_feb.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO   #沿用所有欄位
            IF INFIELD(feb02) AND l_ac > 1 THEN
                LET g_feb[l_ac].* = g_feb[l_ac-1].*
                LET g_feb[l_ac].feb02=''
                LET g_feb[l_ac].feb04=''
                LET g_feb[l_ac].feb05=''
                NEXT FIELD feb02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(feb04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_faj"
                    LET g_qryparam.default1 = g_feb[l_ac].feb04
                    LET g_qryparam.default2 = g_feb[l_ac].feb05
                    CALL cl_create_qry()
                         RETURNING g_feb[l_ac].feb04,g_feb[l_ac].feb05
                    DISPLAY g_feb[l_ac].feb04 TO feb04
                    DISPLAY g_feb[l_ac].feb05 TO feb05
                    NEXT FIELD feb04
               WHEN INFIELD(feb08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pmc"
                    LET g_qryparam.default1 =g_feb[l_ac].feb08
                    CALL cl_create_qry() RETURNING g_feb[l_ac].feb08
                    DISPLAY g_feb[l_ac].feb08 TO feb08
                    CALL i300_feb08('d')
                    NEXT FIELD feb08
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
        END INPUT
 
    CLOSE i300_bcl
    COMMIT WORK
    CALL i300_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i300_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fea_file WHERE fea01 = g_fea.fea01
         INITIALIZE g_fea.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i300_delall()
    SELECT COUNT(*) INTO g_cnt FROM feb_file
        WHERE feb01=g_fea.fea01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM fea_file WHERE fea01 = g_fea.fea01
       IF SQLCA.SQLCODE THEN 
          CALL cl_err3("del","feb_file",g_fea.fea01,"",SQLCA.sqlcode,"","DEL-fea",1)  #No.FUN-660136
       END IF
    END IF
END FUNCTION
 
FUNCTION i300_feb08(p_cmd)  #料件編號
    DEFINE l_pmc01    LIKE pmc_file.pmc01,
           l_pmc03    LIKE pmc_file.pmc03,
           l_pmcacti  LIKE pmc_file.pmcacti,
           p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT pmc01,pmc03,pmcacti
      INTO l_pmc01,l_pmc03,l_pmcacti
      FROM pmc_file WHERE pmc01 = g_feb[l_ac].feb08
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                   LET l_pmc03 = NULL
         WHEN l_pmcacti='N'        LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' OR p_cmd='u'
    THEN LET g_feb[l_ac].pmc03 = l_pmc03
        DISPLAY g_feb[l_ac].pmc03 TO pmc03
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN LET g_feb[l_ac].pmc03 = l_pmc03
        DISPLAY g_feb[l_ac].pmc03 TO pmc03
    END IF
END FUNCTION
 
FUNCTION i300_b_askkey()
DEFINE
    l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON feb02,feb03,feb06,feb04,feb05,feb07,feb08,feb10,
                       feb11,feb12,feb13,feb09,pmc03
                       ,febud01,febud02,febud03,febud04,febud05
                       ,febud06,febud07,febud08,febud09,febud10
                       ,febud11,febud12,febud13,febud14,febud15
            FROM s_feb[1].feb02,s_feb[1].feb03,s_feb[1].feb06,
                 s_feb[1].feb04,s_feb[1].feb05,s_feb[1].feb07,
                 s_feb[1].feb08,s_feb[1].feb10,s_feb[1].feb11,
                 s_feb[1].feb13,s_feb[1].feb09,s_feb[1].pmc03
                 ,s_feb[1].febud01,s_feb[1].febud02,s_feb[1].febud03
                 ,s_feb[1].febud04,s_feb[1].febud05,s_feb[1].febud06
                 ,s_feb[1].febud07,s_feb[1].febud08,s_feb[1].febud09
                 ,s_feb[1].febud10,s_feb[1].febud11,s_feb[1].febud12
                 ,s_feb[1].febud13,s_feb[1].febud14,s_feb[1].febud15
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING   , #TQC-630166
    l_flag          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_pmc03         LIKE pmc_file.pmc03
 
    LET g_sql =
        "SELECT feb02,feb04,feb05,feb03,feb06,feb07,feb09,feb08,",
        "       '',feb10,feb11,feb12,feb13, ",
        "       febud01,febud02,febud03,febud04,febud05,",
        "       febud06,febud07,febud08,febud09,febud10,",
        "       febud11,febud12,febud13,febud14,febud15 ", 
        " FROM feb_file",
        " WHERE feb01 ='",g_fea.fea01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE i300_pb FROM g_sql
    DECLARE feb_curs                       #SCROLL CURSOR
        CURSOR FOR i300_pb
 
    CALL g_feb.clear()	
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH feb_curs INTO g_feb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT pmc03 INTO l_pmc03 FROM pmc_file
         WHERE pmc01= g_feb[g_cnt].feb08
        LET g_feb_t.feb02= g_feb[g_cnt].feb02
        LET g_feb[g_cnt].pmc03=l_pmc03
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_feb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_feb TO s_feb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #FUN-890096  set action APS工模具主檔維護檔
         IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
             CALL cl_set_act_visible("aps_tools_main,aps_tools_fixeddtl,aps_tools_capicity",FALSE)
         END IF
 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
      #FUN-890096  add APS工模具主檔維護檔
      ON ACTION aps_tools_main
         LET g_action_choice = 'aps_tools_main'
         EXIT DISPLAY 
      #FUN-890096  add APS工模具保修明細檔
      ON ACTION aps_tools_fixeddtl
         LET g_action_choice = 'aps_tools_fixeddtl'
         EXIT DISPLAY
      #FUN-890096  add APS工模具產能型態維護作業
      ON ACTION aps_tools_capicity
         LET g_action_choice = 'aps_tools_capicity'
         EXIT DISPLAY
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i300_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        fea01       LIKE fea_file.fea01,
        fea02       LIKE fea_file.fea02,
        fea031      LIKE fea_file.fea031,
        fea032      LIKE fea_file.fea032,
        feb02       LIKE feb_file.feb02,
        feb03       LIKE feb_file.feb03,
        feb04       LIKE feb_file.feb04,
        feb07       LIKE feb_file.feb07,
        feb08       LIKE feb_file.feb08,
        feb10       LIKE feb_file.feb10,
        feb12       LIKE feb_file.feb12,
        feb06       LIKE feb_file.feb06,
        feb05       LIKE feb_file.feb05,
        feb09       LIKE feb_file.feb09,
        pmc03       LIKE pmc_file.pmc03,
        feb11       LIKE feb_file.feb11,
        feb13       LIKE feb_file.feb13
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #       #No.FUN-680070 VARCHAR(40)
DEFINE  g_str       STRING                              #No.FUN-770033
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT fea01,fea02,fea031,fea032,feb02,feb03,feb04,feb07,",
              " feb08,feb10,feb12,feb06,feb05,feb09,pmc03,feb11,feb13",
              " FROM fea_file,feb_file LEFT OUTER JOIN pmc_file ON feb08=pmc_file.pmc01 ",
              " WHERE fea01 = feb01 ",
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,2,3,4 "
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(g_wc,'fea01,fea02,fea031,fea032')                                                                   
             RETURNING g_wc                                                                                                              
        LET g_str = g_wc                                                                                          
     END IF 
    LET g_str=g_azi04,";",g_azi07,";",g_str
    CALL cl_prt_cs1('afai300','afai300',g_sql,g_str)      

END FUNCTION

#No.FUN-9C0077 程式精簡
#FUN-B50046
