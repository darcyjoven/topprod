# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: aicp050.4gl
# Descriptions...: 工單換批維護作業
# Date & Author..: 08/03/12 By kim (FUN-810038)
# Modify.........: No.FUN-830078 08/03/24 By bnlent 錯誤訊息修改
# Modify.........: No.FUN-870051 08/07/16 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.MOD-8B0086 08/11/07 By chenyu 沒有取替代時，讓sfs27=sfa27
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/17 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0049 10/11/03 by destiny  增加倉庫的權限控管 
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據`
# Modify.........: No.FUN-AB0001 11/04/25 By Lilan 新增EF(EasyFlow)整合功能
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)
# Modify.........: No.FUN-B70074 11/07/25 By lixh1 新增行業別TABLE
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:FUN-C30302 12/04/23 By bart 修改 s_icdout 回傳值
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk添加參數
# Modify.........: No:FUN-C70014 12/07/05 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No.FUN-D20060 13/02/21 By minpp 設限倉庫控卡
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-810038
#模組變數(Module Variables)
DEFINE
    g_sfb           RECORD
                    sfb01      LIKE sfb_file.sfb01,      #工單單號
                    sfbiicd09  LIKE sfbi_file.sfbiicd09,  #作業編號
                    sfb05      LIKE sfb_file.sfb05,      #成品料號
                    ima02_1    LIKE ima_file.ima02,      #品名
                    ima021_1   LIKE ima_file.ima021,     #規格
                    sfbiicd14  LIKE sfbi_file.sfbiicd14,  #母體料號
                    ima02_2    LIKE ima_file.ima02,      #品名
                    ima021_2   LIKE ima_file.ima021,     #規格
                    sfb08      LIKE sfb_file.sfb08,      #生產數量
                    sfb081     LIKE sfb_file.sfb081,     #已發套數
                    slip_1     LIKE sfp_file.sfp01,      #退料單別
                    slip_2     LIKE sfp_file.sfp01,      #發料單別
                    sfs07_1    LIKE sfs_file.sfs07,      #換批倉庫
                    sfs08_1    LIKE sfs_file.sfs08,      #換批儲位
                    sfs09_1    LIKE sfs_file.sfs09,      #換批批號
                    sfs07_2    LIKE sfs_file.sfs07,      #退料倉庫
                    sfs08_2    LIKE sfs_file.sfs08,      #退料儲位
                    sfs09_2    LIKE sfs_file.sfs09,      #退料批號
                    sfp03      LIKE sfp_file.sfp03       #扣帳日期
                    END RECORD,
    g_sfs           DYNAMIC ARRAY OF RECORD
                    sfs02     LIKE sfs_file.sfs02,    #項次(sfe28)
                    sfs26     LIKE sfs_file.sfs26,    #替代碼
                    sfs03     LIKE sfs_file.sfs03,    #工單單號(sfe01)
                    sfs01     LIKE sfs_file.sfs01,    #發料單號(sfe02) 
                    sfs04     LIKE sfs_file.sfs04,    #下階料號(sfe07)
                    ima02     LIKE ima_file.ima02,    #品名
                    ima021    LIKE ima_file.ima021,   #規格 
                    sfs06     LIKE sfs_file.sfs06,    #單位(sfe17) 
                    sfs10     LIKE sfs_file.sfs10,    #作業編號(sfe14)
                    sfa05     LIKE sfa_file.sfa05,    #應發量
                    sfs07     LIKE sfs_file.sfs07,    #倉庫(sfe08)   
                    sfs08     LIKE sfs_file.sfs08,    #儲位(sfe09)  
                    sfs09     LIKE sfs_file.sfs09,    #批號(sfe10) 
                    sfa06     LIKE sfa_file.sfa06,    #已發量 
                    sfs07_nw  LIKE sfs_file.sfs07,    #換批倉庫 
                    sfs08_nw  LIKE sfs_file.sfs08,    #換批儲位
                    sfs09_nw  LIKE sfs_file.sfs09,    #新批號  
                    sfs05     LIKE sfs_file.sfs05,    #發料量(sfe16)   
                    sfs05_nw  LIKE sfs_file.sfs05,    #換貨發料量
                    sfs30     LIKE sfs_file.sfs30,    #單位一(sfe30)
                    sfs31     LIKE sfs_file.sfs31,    #單位一換算率(sfe31)
                    sfs32     LIKE sfs_file.sfs32,    #單位一數量(sfe32) 
                    sfs33     LIKE sfs_file.sfs33,    #參考單位(sfe33) 
                    sfs34     LIKE sfs_file.sfs34,    #母/參考單位換算率(sfe34) 
                    sfs35     LIKE sfs_file.sfs35,    #參考數量(sfe35) 
                    sfs21     LIKE sfs_file.sfs21,    #備註    
                    img10     LIKE img_file.img10,    #庫存量 
                    img10_alo LIKE img_file.img10,    #在檢量 
                    sfs02_nw  LIKE sfs_file.sfs02     #新單據項次
                    END RECORD,
    g_t1            LIKE type_file.chr5,        
    g_sheet         LIKE type_file.chr5,                      #單別    (沿用)
    g_sql           STRING,                       #CURSOR暫存 
    g_rec_b         LIKE type_file.num5,                     #單身筆數
    l_ac            LIKE type_file.num5                      #目前處理的ARRAY CNT
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5             #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10              #總筆數
DEFINE g_jump              LIKE type_file.num10              #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5             #是否開啟指定筆視窗
 
DEFINE g_ida         RECORD LIKE ida_file.*
DEFINE g_idb         RECORD LIKE idb_file.*
DEFINE g_idd         RECORD LIKE idd_file.*
DEFINE b_sfp         RECORD LIKE sfp_file.*    
DEFINE b_sfq         RECORD LIKE sfq_file.*    
DEFINE b_sfs         RECORD LIKE sfs_file.*    
DEFINE g_ac          LIKE type_file.num5
DEFINE g_dies        LIKE sfs_file.sfs35
DEFINE g_img09       LIKE img_file.img09
DEFINE g_img10       LIKE img_file.img10
DEFINE g_gen         LIKE type_file.chr1  #Y:有成功的做到執行功能p050_gen()
DEFINE b_sfsi        RECORD LIKE sfsi_file.*   #FUN-B70074
 
DEFINE b_sfs07_2     LIKE sfs_file.sfs07,
       b_sfs08_2     LIKE sfs_file.sfs08,
       b_sfs09_2     LIKE sfs_file.sfs09
DEFINE g_yy          LIKE type_file.num5
DEFINE g_mm          LIKE type_file.num5
DEFINE g_b_ok        LIKE type_file.chr1 #Y:單身維護成功
DEFINE l_flag01      LIKE type_file.chr1                   #FUN-C80107 add
 
#主程式開始
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW p050_w AT p_row,p_col WITH FORM "aic/42f/aicp050"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("sfs30,sfs31,sfs32",FALSE)
 
   CALL p050_a()
 
   CALL p050_menu()
 
   #----產生不成功,還原所有動作----
   IF g_gen = 'N' THEN
      CALL p050_rollback_bin()
      DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_1
      DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_2
      CALL cl_err('rollback ok','!',0)
   END IF
 
   CLOSE WINDOW p050_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間) 
        RETURNING g_time
END MAIN
 
FUNCTION p050_menu()
 
   WHILE TRUE
      CALL p050_bp("G")
      CASE g_action_choice
         WHEN "insert"  #新增
            IF cl_chk_act_auth() THEN
               CALL p050_a()
            END IF
 
         WHEN "detail" #單身
            IF cl_chk_act_auth() THEN
               CALL p050_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "gen"    #執行
            IF cl_chk_act_auth() THEN
               CALL p050_gen()
            END IF
 
         WHEN "aic_s_icdout" #刻號/BIN號出庫明細
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_sfb.sfb01) AND 
                  g_rec_b > 0 AND g_b_ok = 'Y' AND
                  NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  #避免畫面資料是舊的,所以重撈
                  CALL p050_ins_idb()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_sfs),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p050_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
 
      ON ACTION insert  #新增
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION detail  #單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION gen     #執行
         LET g_action_choice="gen"
         EXIT DISPLAY
 
      ON ACTION aic_s_icdout  #刻號/BIN號出庫明細
         LET g_action_choice="aic_s_icdout"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
 
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
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p050_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
   DEFINE   l_cnt       LIKE type_file.num5
 
   #避免上一筆資料輸入後,沒有做執行,就直接按新增重新輸入資料
   #所以要先還原所有之前的動作
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM sfp_file
      WHERE sfp01 = g_sfb.slip_1   #退料單
         OR sfp01 = g_sfb.slip_2   #發料單
   IF l_cnt > 0 THEN
      CALL p050_rollback_bin()
      DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_1
      DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_2
      CALL cl_err('rollback ok','!',0)
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_sfs.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
  
   LET g_rec_b = 0 
   INITIALIZE g_sfb.* TO NULL             #DEFAULT 設定
 
   WHILE TRUE
      LET g_sfb.sfp03 = g_today
 
      LET g_sfb.sfs08_1 = ' '   #換貨儲位
      LET g_sfb.sfs08_2 = ' '   #退貨儲位
 
      CALL p050_i()                      #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_sfb.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_sfb.sfb01) THEN       #重要欄位不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      LET g_success = 'Y'
 
      #取得退料單單號
      CALL s_auto_assign_no("asf",g_sfb.slip_1,g_today,"","sfp_file",
                            "sfp01","","","")
           RETURNING li_result,g_sfb.slip_1
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
 
      #取得發料單單號
      CALL s_auto_assign_no("asf",g_sfb.slip_2,g_today,"","sfp_file",
                            "sfp01","","","")
           RETURNING li_result,g_sfb.slip_2
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sfb.slip_1
      DISPLAY BY NAME g_sfb.slip_2
      CALL p050_ins_sfp('6',g_sfb.slip_1)     #產生退料單頭檔
      IF g_success = 'Y' THEN
         CALL p050_ins_sfp('1',g_sfb.slip_2)  #產生發料單頭檔
      END IF
 
      LET g_gen = 'N'
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
         EXIT WHILE
      END IF
 
      CALL g_sfs.clear()
 
      LET g_rec_b = 0 
      CALL p050_b_fill()
      CALL p050_b()                   #輸入單身
      EXIT WHILE
   END WHILE
   #-------產生不成功,還原所有動作---------
   IF g_rec_b = 0 THEN
      DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_1
      DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_2
      CALL cl_err('rollback ok','!',0)
   END IF
END FUNCTION
 
FUNCTION p050_i()
   DEFINE l_n            LIKE type_file.num5
   DEFINE l_sfb09        LIKE sfb_file.sfb09
   DEFINE li_result      LIKE type_file.num5     
   DEFINE l_where        LIKE type_file.chr1000
   DEFINE l_sfa03        LIKE sfa_file.sfa03
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_smy73        LIKE smy_file.smy73    #TQC-AC0293 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INPUT BY NAME g_sfb.sfb01,g_sfb.slip_1,g_sfb.slip_2,
                 g_sfb.sfs07_1,g_sfb.sfs08_1,g_sfb.sfs09_1,
                 g_sfb.sfs07_2,g_sfb.sfs08_2,g_sfb.sfs09_2,g_sfb.sfp03
         WITHOUT DEFAULTS
 
      AFTER FIELD sfb01     #工單單號
         IF cl_null(g_sfb.sfb01) THEN
            NEXT FIELD sfb01
         END IF
         IF NOT cl_null(g_sfb.sfb01) THEN
            #取得該工單的資訊(成品料號,生產數量,母體料號...)
            SELECT sfb05,sfb08,sfb081,sfbiicd09,sfbiicd14,sfb09
               INTO g_sfb.sfb05,g_sfb.sfb08,g_sfb.sfb081,
                    g_sfb.sfbiicd09,g_sfb.sfbiicd14,l_sfb09
               FROM sfb_file,sfbi_file
              WHERE sfb01 = g_sfb.sfb01
                AND sfbi01=sfb01
            IF SQLCA.SQLCODE THEN
               CALL cl_err('sel sfb01',SQLCA.SQLCODE,1)
               NEXT FIELD sfb01
            END IF
            #該工單尚未發料,不可做換批,請查核!!
            IF cl_null(g_sfb.sfb081) OR g_sfb.sfb081 <= 0 THEN
               CALL cl_err('','aic-195',1) 
               NEXT FIELD sfb01
            END IF
            #判斷該工單是否已收貨,若有則err
            LET l_n = 0
            SELECT COUNT(*) INTO l_n 
               FROM rvb_file
              WHERE rvb34 IS NOT NULL
                AND rvb34 = g_sfb.sfb01
            #該工單已有收貨資料,不可做換批,請查核!!
            IF l_n > 0 THEN
               CALL cl_err('','aic-196',1)
               NEXT FIELD sfb01
            END IF
            #判斷該工單是否已入庫,若有則err
            LET l_n = 0
            SELECT COUNT(*) INTO l_n 
               FROM sfv_file
              WHERE sfv11 IS NOT NULL
                AND sfv11 = g_sfb.sfb01
            #該工單已有入庫資料,不可做換批,請查核!!
            IF l_sfb09 > 0 OR l_n > 0  THEN
               CALL cl_err('','aic-197',1)
               NEXT FIELD sfb01
            END IF 
            DISPLAY BY NAME g_sfb.sfb05,g_sfb.sfb08,g_sfb.sfb081,
                            g_sfb.sfbiicd09,g_sfb.sfbiicd14
            #取得成品料號的品名規格
            SELECT ima02,ima021 INTO g_sfb.ima02_1,g_sfb.ima021_1
               FROM ima_file
              WHERE ima01 = g_sfb.sfb05
            #取得母體料號的品名規格
            SELECT ima02,ima021 INTO g_sfb.ima02_2,g_sfb.ima021_2
               FROM ima_file
              WHERE ima01 = g_sfb.sfbiicd14
 
            DISPLAY BY NAME g_sfb.ima02_1,g_sfb.ima021_1,
                            g_sfb.ima02_2,g_sfb.ima021_2
 
            #取得該工單之備料料號
            LET l_sfa03 = ' '
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM sfa_file,ima_file,imaicd_file
               WHERE sfa01 = g_sfb.sfb01
                 AND ima01 = sfa03
                 AND imaicd00=ima01
                 AND imaicd04 IN ('0','1','2','3','4')
            #可做換批的工單,必須符合備料單身中只有一筆發料料號的狀態
            #是Matches '0-4'的,請查核!!
            IF l_cnt != 1 THEN
               CALL cl_err('imaicd04','aic-198',1)
               NEXT FIELD sfb01
            ELSE
               SELECT sfa03 INTO l_sfa03 
                 FROM sfa_file,ima_file,imaicd_file
                  WHERE sfa01 = g_sfb.sfb01
                    AND ima01 = sfa03
                    AND imaicd00=ima01
                    AND imaicd04 IN ('0','1','2','3','4')
               #LET l_where = " img10 > 0 AND img01 = '",l_sfa03,"'"  #No.FUN-AA0049
               LET l_where = " img10 > 0 AND img01 = '",l_sfa03,"' AND imgplant='",g_plant,"' "  #No.FUN-AA0049
            END IF
 
            #取得工單未換批發料倉儲批default至畫面退料倉儲批
            DECLARE sfe08_dec CURSOR FOR
               SELECT sfe08,sfe09,sfe10 
                 FROM sfe_file,sfp_file,ima_file,imaicd_file
                WHERE sfe02 = sfp01         #發料單號
                  AND sfe01 = g_sfb.sfb01   #工單
                  AND (sfp08 IS NULL OR sfp08 = ' ')
                  AND sfe07 = ima01
                  AND imaicd00=ima01
                  AND imaicd04 IN ('0','1','2','3','4')
            OPEN sfe08_dec
            FETCH sfe08_dec INTO g_sfb.sfs07_2,g_sfb.sfs08_2,g_sfb.sfs09_2
            DISPLAY BY NAME g_sfb.sfs07_2,g_sfb.sfs08_2,g_sfb.sfs09_2
         END IF
 
      AFTER FIELD slip_1    #退料單別
         IF NOT cl_null(g_sfb.slip_1) THEN
            LET g_t1 = s_get_doc_no(g_sfb.slip_1)
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM smy_file
               WHERE smyslip = g_t1
                 AND smysys = 'asf'
                 AND smykind = '4'   #退料
            IF l_n = 0 THEN
               CALL cl_err('','aap-009',1)   #單別性質不符,請重新輸入
               NEXT FIELD slip_1
            END IF
           #TQC-AC0293 ---------------add start----------
            SELECT smy73 INTO l_smy73 FROM smy_file
            WHERE smyslip = g_t1
           IF l_smy73 = 'Y' THEN
              CALL cl_err('slip_1','asf-874',0)
              NEXT FIELD slip_1 
           END IF 
           #TQC-AC0293 ---------------add end-------------
           #CALL s_check_no("asf",g_t1,"","","sfp_file","sfp01","")   #No.FUN-AA0049
            CALL s_check_no("asf",g_t1,"",'4',"sfp_file","sfp01","")  #No.FUN-AA0049
                 RETURNING li_result,g_sfb.slip_1
            DISPLAY BY NAME g_sfb.slip_1
            IF (NOT li_result) THEN
                NEXT FIELD slip_1
            END IF
         END IF
 
      AFTER FIELD  slip_2   #發料單別
         IF NOT cl_null(g_sfb.slip_2) THEN
            LET g_t1 = s_get_doc_no(g_sfb.slip_2)
            #檢查單據性質是否符合
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM smy_file
               WHERE smyslip = g_t1
                 AND smysys = 'asf'
                 AND smykind = '3'    #發料
            IF l_n = 0 THEN
               CALL cl_err('','aap-009',1)   #單別性質不符,請重新輸入
               NEXT FIELD slip_2
            END IF
           #TQC-AC0293 ---------------add start----------
            SELECT smy73 INTO l_smy73 FROM smy_file
            WHERE smyslip = g_t1
           IF l_smy73 = 'Y' THEN
              CALL cl_err('slip_2','asf-874',0)
              NEXT FIELD slip_2
           END IF
           #TQC-AC0293 ---------------add end-------------
            #CALL s_check_no("asf",g_t1,"","","sfp_file","sfp01","")  #No.FUN-AA0049
            CALL s_check_no("asf",g_t1,"",'3',"sfp_file","sfp01","")  #No.FUN-AA0049
                 RETURNING li_result,g_sfb.slip_2
            DISPLAY BY NAME g_sfb.slip_2
            IF (NOT li_result) THEN
                NEXT FIELD slip_2
            END IF
         END IF 
    
      AFTER FIELD sfs07_1     #換批倉庫
         IF NOT cl_null(g_sfb.sfs07_1) THEN
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(g_sfb.sfs07_1) THEN
               NEXT FIELD sfs07_1
            END IF
 
            #No.FUN-AA0049--end      

            #FUN-D20060---add---str
            #檢查料號預設倉儲及單別預設倉儲
            IF NOT s_chksmz(g_sfb.sfb05,g_sfb.sfb01,
                            g_sfb.sfs07_1,g_sfb.sfs08_1) THEN
               NEXT FIELD sfs07_1
            END IF      
            #FUN-D20060---add---end   
            SELECT imd02 FROM imd_file
               WHERE imd01=g_sfb.sfs07_1
                 AND imdacti = 'Y'
            IF SQLCA.SQLCODE THEN
               CALL cl_err('sel imd',STATUS,0) 
               NEXT FIELD sfs07_1
            END IF
         END IF
      
      AFTER FIELD sfs08_1    #換批儲位
         IF g_sfb.sfs08_1 = '　' THEN #全型空白
            LET g_sfb.sfs08_1 = ' '
         END IF
         IF g_sfb.sfs08_1 IS NULL THEN 
            LET g_sfb.sfs08_1 =' ' 
         END IF
         #FUN-D20060---add---str
          IF NOT cl_null(g_sfb.sfs07_1) THEN
          #檢查料號預設倉儲及單別預設倉儲 
             IF NOT s_chksmz(g_sfb.sfb05,g_sfb.sfb01,
                             g_sfb.sfs07_1,g_sfb.sfs08_1) THEN
                NEXT FIELD sfs07_1
             END IF
          END IF
          #FUN-D20060---add---end 
      AFTER FIELD sfs09_1   #換批批號
         IF g_sfb.sfs08_1 = '　' THEN #全型空白
            LET g_sfb.sfs08_1 = ' '
         END IF
         IF g_sfb.sfs08_1 IS NULL THEN
            LET g_sfb.sfs08_1 =' '
         END IF
         IF g_sfb.sfs09_1 = '　' THEN #全型空白
            LET g_sfb.sfs09_1 = ' '
         END IF
         #判斷該倉儲是否有庫存量
         LET l_n = 0 
 
         IF cl_null(l_sfa03) THEN
            SELECT COUNT(*) INTO l_n FROM img_file
               WHERE img02 = g_sfb.sfs07_1
                 AND img03 = g_sfb.sfs08_1
                 AND img04 = g_sfb.sfs09_1
                 AND img10 > 0
         ELSE 
            SELECT COUNT(*) INTO l_n FROM img_file
               WHERE img02 = g_sfb.sfs07_1
                 AND img03 = g_sfb.sfs08_1
                 AND img04 = g_sfb.sfs09_1
                 AND img10 > 0
                 AND img01 = l_sfa03
         END IF
         IF l_n = 0 THEN
            CALL cl_err('', 'aim-406',1)
            NEXT FIELD sfs07_1
         END IF
     
      AFTER FIELD sfs07_2    #退料倉庫
         IF NOT cl_null(g_sfb.sfs07_2) THEN
            SELECT imd02 FROM imd_file
               WHERE imd01=g_sfb.sfs07_2
                 AND imdacti = 'Y' 
            IF SQLCA.SQLCODE THEN
               CALL cl_err('sel imd',STATUS,0) 
               NEXT FIELD sfs07_2
            END IF

            #FUN-D20060---add---str
            #檢查料號預設倉儲及單別預設倉儲 
            IF NOT s_chksmz(g_sfb.sfb05,g_sfb.slip_1,
                            g_sfb.sfs07_2,g_sfb.sfs08_2) THEN
               NEXT FIELD sfs07_2
            END IF
            #FUN-D20060---add---end
         END IF
 
      AFTER FIELD sfs08_2    #退料儲位
         IF g_sfb.sfs08_2 = '　' THEN #全型空白
            LET g_sfb.sfs08_2 = ' '
         END IF
         IF g_sfb.sfs08_2 IS NULL THEN 
            LET g_sfb.sfs08_2 =' ' 
         END IF
         #FUN-D20060---add---str
         IF NOT cl_null(g_sfb.sfs07_2) THEN 
            #檢查料號預設倉儲及單別預設倉儲
            IF NOT s_chksmz(g_sfb.sfb05,g_sfb.slip_1,
                            g_sfb.sfs07_2,g_sfb.sfs08_2) THEN
               NEXT FIELD sfs07_2
            END IF
         END IF
         #FUN-D20060---add---end

      AFTER FIELD sfp03      #扣帳日期
         IF NOT cl_null(g_sfb.sfp03) THEN
            IF g_sma.sma53 IS NOT NULL AND g_sfb.sfp03 <= g_sma.sma53 THEN
               CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
            END IF
            CALL s_yp(g_sfb.sfp03) RETURNING g_yy,g_mm
            IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
               CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
            END IF
         END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfb01) #工單單號 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_sfb01_icd"
                 LET g_qryparam.default1 = g_sfb.sfb01
                 CALL cl_create_qry() RETURNING g_sfb.sfb01
                 DISPLAY BY NAME g_sfb.sfb01
                 NEXT FIELD sfb01
            WHEN INFIELD(slip_1) #查詢退料單別
                 LET g_t1 = s_get_doc_no(g_sfb.slip_1)  
                 LET g_chr = '4'
                 LET g_sql = " (smy73 <> 'Y' OR smy73 is null) "           #TQC-AC0293
                 CALL smy_qry_set_par_where(g_sql)      #TQC-AC0293
                 CALL q_smy( FALSE, TRUE,g_t1,'asf',g_chr) RETURNING g_t1
                 LET g_sfb.slip_1 = g_t1    
                 DISPLAY BY NAME g_sfb.slip_1
                 NEXT FIELD slip_1
            WHEN INFIELD(slip_2) #查詢發料單別
                 LET g_t1 = s_get_doc_no(g_sfb.slip_2)
                 LET g_chr = '3'
                 LET g_sql = " (smy73 <> 'Y' OR smy73 is null) "           #TQC-AC0293
                 CALL smy_qry_set_par_where(g_sql)      #TQC-AC0293
                 CALL q_smy( FALSE, TRUE,g_t1,'asf',g_chr) RETURNING g_t1
                 LET g_sfb.slip_2 = g_t1
                 DISPLAY BY NAME g_sfb.slip_2
                 NEXT FIELD slip_2
            WHEN INFIELD(sfs07_1) #換批倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_img7"
                  LET g_qryparam.default1 = g_sfb.sfs07_1
                  LET g_qryparam.default2 = g_sfb.sfs08_1
                  LET g_qryparam.default3 = g_sfb.sfs09_1
                  LET g_qryparam.where = l_where CLIPPED
                  CALL cl_create_qry() RETURNING g_sfb.sfs07_1,g_sfb.sfs08_1,
                                                g_sfb.sfs09_1
                  DISPLAY BY NAME g_sfb.sfs07_1,g_sfb.sfs08_1,g_sfb.sfs09_1
                  NEXT FIELD sfs07_1
            WHEN INFIELD(sfs08_1) #換批儲位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_img7"
                 LET g_qryparam.default1 = g_sfb.sfs07_1
                 LET g_qryparam.default2 = g_sfb.sfs08_1
                 LET g_qryparam.default3 = g_sfb.sfs09_1
                 LET g_qryparam.where = l_where CLIPPED
                 CALL cl_create_qry() RETURNING g_sfb.sfs07_1,g_sfb.sfs08_1,
                                                g_sfb.sfs09_1
                 DISPLAY BY NAME g_sfb.sfs07_1,g_sfb.sfs08_1,g_sfb.sfs09_1
                 NEXT FIELD sfs08_1
            WHEN INFIELD(sfs09_1) #換批批號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_img7"
                 LET g_qryparam.default1 = g_sfb.sfs07_1
                 LET g_qryparam.default2 = g_sfb.sfs08_1
                 LET g_qryparam.default3 = g_sfb.sfs09_1
                 LET g_qryparam.where = l_where CLIPPED
                 CALL cl_create_qry() RETURNING g_sfb.sfs07_1,g_sfb.sfs08_1,
                                                g_sfb.sfs09_1
                 DISPLAY BY NAME g_sfb.sfs07_1,g_sfb.sfs08_1,g_sfb.sfs09_1
                 NEXT FIELD sfs09_1
            WHEN INFIELD(sfs07_2)        #退料倉庫
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd"
                 LET g_qryparam.default1 = g_sfb.sfs07_2
                 LET g_qryparam.arg1 = 'WS'
                 CALL cl_create_qry() RETURNING g_sfb.sfs07_2
                 DISPLAY BY NAME g_sfb.sfs07_2
                 NEXT FIELD sfs07_2
            WHEN INFIELD(sfs08_2)        #退料儲位
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_sfb.sfs07_2) THEN
                    LET g_qryparam.form ="q_ime"
                    LET g_qryparam.default1 = g_sfb.sfs08_2
                    LET g_qryparam.arg1 = g_sfb.sfs07_2
                    LET g_qryparam.arg2 = 'WS'
                    CALL cl_create_qry() RETURNING g_sfb.sfs08_2
                    DISPLAY BY NAME g_sfb.sfs08_2
                 ELSE
                    LET g_qryparam.form ="q_ime1"
                    LET g_qryparam.default1 = g_sfb.sfs08_2
                    LET g_qryparam.arg1 = 'WS'
                    CALL cl_create_qry() RETURNING g_sfb.sfs07_2,g_sfb.sfs08_2
                    DISPLAY BY NAME g_sfb.sfs07_2
                    DISPLAY BY NAME g_sfb.sfs08_2
                 END IF
 
                 DISPLAY BY NAME g_sfb.sfs08_2
                 NEXT FIELD sfs08_2 
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about     
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help() 
 
   END INPUT
 
END FUNCTION
 
#單身
FUNCTION p050_b()
   DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,              #檢查重複用
          l_cnt           LIKE type_file.num5,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
          p_cmd           LIKE type_file.chr1,            #處理狀態
          l_misc          LIKE type_file.chr4,           #
          l_allow_insert  LIKE type_file.num5,              #可新增否
          l_allow_delete  LIKE type_file.num5               #可刪除否
   DEFINE l_ima108        LIKE ima_file.ima108
   DEFINE l_flag          LIKE type_file.num5,
          l_factor        LIKE ima_file.ima31_fac
   DEFINE l_ima906       LIKE ima_file.ima906   #FUN-C30300   
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_sfb.slip_1) OR cl_null(g_sfb.slip_2) THEN
      RETURN
   END IF
  
   LET g_b_ok = 'N'
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_sfs WITHOUT DEFAULTS FROM s_sfs.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
        #DISPLAY "BEFORE INPUT!"   #CHI-70049 mark
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
        #DISPLAY "BEFORE ROW!"     #CHI-A7049 mark
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
      AFTER FIELD sfs07_nw
         IF NOT cl_null(g_sfs[l_ac].sfs07_nw) THEN
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(g_sfs[l_ac].sfs07_nw) THEN
               NEXT FIELD sfs07_nw
            END IF 
            #No.FUN-AA0049--end         
            SELECT imd02 FROM imd_file
               WHERE imd01=g_sfs[l_ac].sfs07_nw
                 AND imdacti = 'Y' 
            IF STATUS THEN
               CALL cl_err('sel imd',STATUS,0) 
               NEXT FIELD sfs07_nw
            END IF
 
            SELECT ima108 INTO l_ima108 FROM ima_file
               WHERE ima01=g_sfs[l_ac].sfs04
            IF l_ima108='Y' THEN        #若為SMT料必須檢查是否會WIP倉
               SELECT COUNT(*) INTO l_n FROM imd_file
                  WHERE imd01=g_sfs[l_ac].sfs07_nw AND imd10='W'
                    AND imdacti = 'Y' 
               IF l_n = 0 THEN
                  CALL cl_err(g_sfs[l_ac].sfs07_nw,'asf-724',0) 
                  NEXT FIELD sfs07_nw
               END IF
            END IF
            #FUN-D20060----add--str
            #檢查料號預設倉儲及單別預設倉儲
            IF NOT s_chksmz(g_sfs[l_ac].sfs04,g_sfb.slip_2,
                            g_sfs[l_ac].sfs07_nw,g_sfs[l_ac].sfs08_nw) THEN
               NEXT FIELD sfs07_nw
            END IF
            #FUN-D20060----add--end
         END IF
         
      AFTER FIELD sfs08_nw
         IF g_sfs[l_ac].sfs08_nw = '　' THEN #全型空白
            LET g_sfs[l_ac].sfs08_nw = ' '
         END IF
         IF g_sfs[l_ac].sfs08_nw IS NULL THEN 
            LET g_sfs[l_ac].sfs08_nw = ' ' 
         END IF
         #檢查料號預設倉儲及單別預設倉儲
         IF NOT cl_null(g_sfs[l_ac].sfs07_nw) THEN              #FUN-D20060 
            IF NOT s_chksmz(g_sfs[l_ac].sfs04,g_sfb.slip_2,
                            g_sfs[l_ac].sfs07_nw,g_sfs[l_ac].sfs08_nw) THEN
               NEXT FIELD sfs07_nw
            END IF
         END IF                                                  #FUN-D20060 
  
      AFTER FIELD sfs09_nw 
         IF g_sfs[l_ac].sfs09_nw = '　' THEN #全型空白
            LET g_sfs[l_ac].sfs09_nw = ' '
         END IF
         IF g_sfs[l_ac].sfs09_nw IS NULL THEN 
            LET g_sfs[l_ac].sfs09_nw =' ' 
         END IF
 
         #庫存明細資料檢查
         CALL p050_chk_img('1',l_ac)
         IF g_success = 'N' THEN
            NEXT FIELD sfs07_nw
         END IF   
 
      AFTER ROW
        #DISPLAY  "AFTER ROW!!"   #CHI-A70049 mark
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET g_b_ok = 'N'
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         #庫存明細資料檢查
         CALL p050_chk_img('1',l_ac)
         IF g_success = 'N' THEN
            LET g_b_ok = 'N'
            NEXT FIELD sfs07_nw
         END IF
 
         ##檢查同工單發料料號需從相同換貨倉儲批做換貨發料
         CALL p050_chk_789('b')
 
         #維護出庫刻號明細
         CALL p050_ins_idb()
         LET g_b_ok = 'Y'
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfs07_nw) OR INFIELD(sfs08_nw) OR INFIELD(sfs09_nw)
               #FUN-C30300---begin
               LET l_ima906 = NULL
               SELECT ima906 INTO l_ima906 FROM ima_file
                WHERE ima01 = g_sfs[l_ac].sfs04
               #IF l_ima906='3' THEN   #TQC-C60028
                  CALL q_idc(FALSE,FALSE,g_sfs[l_ac].sfs04,g_sfs[l_ac].sfs07_nw,
                         g_sfs[l_ac].sfs08_nw, g_sfs[l_ac].sfs09_nw)
                  RETURNING g_sfs[l_ac].sfs07_nw,g_sfs[l_ac].sfs08_nw,
                         g_sfs[l_ac].sfs09_nw
               #TQC-C60028---begin mark
               #ELSE  
               #FUN-C30300---end
               #   CALL q_img4(FALSE,FALSE,g_sfs[l_ac].sfs04,
               #               g_sfs[l_ac].sfs07_nw,g_sfs[l_ac].sfs08_nw,
               #               g_sfs[l_ac].sfs09_nw,'A') 
               #        RETURNING g_sfs[l_ac].sfs07_nw,g_sfs[l_ac].sfs08_nw,
               #                  g_sfs[l_ac].sfs09_nw
               #END IF   #FUN-C30300  
               #TQC-C60028---end
                  DISPLAY g_sfs[l_ac].sfs07_nw TO sfs07_nw
                  DISPLAY g_sfs[l_ac].sfs08_nw TO sfs08_nw
                  DISPLAY g_sfs[l_ac].sfs09_nw TO sfs09_nw

                 IF INFIELD(sfs07_nw) THEN NEXT FIELD sfs07_nw END IF
                 IF INFIELD(sfs08_nw) THEN NEXT FIELD sfs08_nw END IF
                 IF INFIELD(sfs09_nw) THEN NEXT FIELD sfs09_nw END IF
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help() 
 
    END INPUT
    #自動執行
    IF g_b_ok = 'Y' THEN
       CALL p050_gen()
    END IF
 
END FUNCTION
 
FUNCTION p050_b_fill()              #BODY FILL UP
   DEFINE l_sfe16_back  LIKE sfe_file.sfe16
   DEFINE l_qty         LIKE sfe_file.sfe16
   DEFINE l_sfs03_t     LIKE sfs_file.sfs03  #工單
   DEFINE l_sfs04_t     LIKE sfs_file.sfs04  #料號 
   DEFINE l_sfs10_t     LIKE sfs_file.sfs10  #作業編號
   DEFINE l_sfs06_t     LIKE sfs_file.sfs06  #單位
   DEFINE l_sfs02_nw    LIKE sfs_file.sfs02  
   DEFINE l_sfs27       LIKE sfs_file.sfs27  
   
   LET g_sql = "SELECT sfe28,'',sfe01,sfe02,sfe07,'','',sfe17, ",
               "       sfe14,'',sfe08,sfe09,sfe10,'','','','', ",
               "       sfe16,sfe16,sfe30,sfe31,sfe32,sfe33,sfe34,sfe35,",
               "       '',0,0,0                        ",
               "   FROM sfe_file,sfp_file,ima_file,imaicd_file ",
               "  WHERE sfe01 = '",g_sfb.sfb01,"'",   #工單單號
               "    AND (sfp08 IS NULL OR sfp08 = ' ')  ",
               "    AND sfp06 IN('1','D') ",   #成套發料 #FUN-C70014 add D
               "    AND sfp01 = sfe02     ",   #單據編號
               "    AND sfe07 = ima01     ",   #發料料號
               "    AND imaicd00=ima01    ",
               "    AND imaicd04 IN ('0','1','2','3','4') ", #料件狀態
               "  ORDER BY sfe01,sfe07,sfe14,sfe17 "
  #DISPLAY g_sql   #CHI-70049 mark
 
   PREPARE p050_pb FROM g_sql
   DECLARE p050_cs                      #CURSOR
      CURSOR FOR p050_pb
 
   CALL g_sfs.clear()
   LET g_cnt = 1
   LET l_sfs02_nw = 0 
   LET l_sfs03_t = ' '
   LET l_sfs04_t = ' '
   LET l_sfs10_t = ' '
   LET l_sfs06_t = ' '
 
   FOREACH p050_cs INTO g_sfs[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF g_sfs[g_cnt].sfs03 != l_sfs03_t OR 
         g_sfs[g_cnt].sfs04 != l_sfs04_t OR 
         g_sfs[g_cnt].sfs10 != l_sfs10_t OR
         g_sfs[g_cnt].sfs06 != l_sfs06_t THEN
 
         #取得該工單已退料數(不含換批作業產生的退料)
         LET l_sfe16_back = 0
         SELECT SUM(sfe16) INTO l_sfe16_back
           FROM sfe_file,sfp_file
          WHERE sfe01 = g_sfb.sfb01         #工單
            AND sfe02 = sfp01
            AND sfp06 = '6'                 #成套退
            AND sfe07 = g_sfs[g_cnt].sfs04  #料
            AND sfe02 NOT IN (SELECT sfp08 FROM sfp_file
                                 WHERE sfp06 = '1'   #成套發
                                   AND sfp08 IS NOT NULL)
         IF cl_null(l_sfe16_back) THEN
            LET l_sfe16_back = 0
         END IF
         LET l_qty = 0 
 
         #給予新項次
         LET l_sfs02_nw = l_sfs02_nw + 1
 
         #備份
         LET l_sfs03_t = g_sfs[g_cnt].sfs03
         LET l_sfs04_t = g_sfs[g_cnt].sfs04
         LET l_sfs10_t = g_sfs[g_cnt].sfs10
         LET l_sfs06_t = g_sfs[g_cnt].sfs06
 
      END IF
      LET l_sfe16_back = l_sfe16_back - l_qty
      #計算此發料項次之換貨數量
      IF l_sfe16_back > 0 THEN
         IF g_sfs[g_cnt].sfs05 >= l_sfe16_back THEN
            LET g_sfs[g_cnt].sfs05_nw = g_sfs[g_cnt].sfs05 - l_sfe16_back
            LET g_sfs[g_cnt].sfs05_nw = s_digqty(g_sfs[g_cnt].sfs05_nw,g_sfs[g_cnt].sfs06)  #FUN-BB0084 
            LET l_qty = g_sfs[g_cnt].sfs05_nw
         ELSE
            LET g_sfs[g_cnt].sfs05_nw = 0
            LET l_qty = l_sfe16_back 
         END IF
      END IF
      IF g_sfs[g_cnt].sfs05_nw = 0 THEN
         CONTINUE FOREACH
      END IF
      LET g_sfs[g_cnt].sfs32 = g_sfs[g_cnt].sfs05_nw
      LET g_sfs[g_cnt].sfs32 = s_digqty(g_sfs[g_cnt].sfs32,g_sfs[g_cnt].sfs30)   #FUN-BB0084   
 
      #給予新的單據項次
      LET g_sfs[g_cnt].sfs02_nw = l_sfs02_nw
 
      #No.FUN-870051---Begin
      SELECT sfs27 INTO l_sfs27 FROM sfs_file 
       WHERE sfs01 = g_sfs[g_cnt].sfs01
         AND sfs02 = g_sfs[g_cnt].sfs02                         
         AND sfs012 = ' ' AND sfs013 = 0     #FUN-A60027 add 
      #No.FUN-870051---End
      #取得該工單備料資訊
      SELECT sfa05,sfa06 
         INTO g_sfs[g_cnt].sfa05,g_sfs[g_cnt].sfa06
         FROM sfa_file
        WHERE sfa01 = g_sfs[g_cnt].sfs03   #工單單號
          AND sfa03 = g_sfs[g_cnt].sfs04   #料件編號
          AND sfa08 = g_sfs[g_cnt].sfs10   #作業編號
          AND sfa12 = g_sfs[g_cnt].sfs06   #發料單位
          AND sfa27 = l_sfs27              #替代料號   #No.MOD-8B0086 add
      #取得料號之品名規格
      SELECT ima02,ima021 
         INTO g_sfs[g_cnt].ima02,g_sfs[g_cnt].ima021
         FROM ima_file 
        WHERE ima01 = g_sfs[g_cnt].sfs04
 
      #default換批倉庫儲位批號
      LET g_sfs[g_cnt].sfs07_nw = g_sfb.sfs07_1
      LET g_sfs[g_cnt].sfs08_nw = g_sfb.sfs08_1
      LET g_sfs[g_cnt].sfs09_nw = g_sfb.sfs09_1
 
      #取得該庫存明細之庫存量
      SELECT img09,img10 INTO g_img09,g_sfs[g_cnt].img10
         FROM img_file
        WHERE img01 = g_sfs[g_cnt].sfs04
          AND img02 = g_sfs[g_cnt].sfs07_nw
          AND img03 = g_sfs[g_cnt].sfs08_nw
          AND img04 = g_sfs[g_cnt].sfs09_nw
      IF cl_null(g_sfs[g_cnt].img10) THEN
         LET g_sfs[g_cnt].img10 = 0
      END IF
 
      #取得該庫存明細之在檢量
      SELECT SUM(sfs05) INTO g_sfs[g_cnt].img10_alo
         FROM sfs_file,sfp_file
        WHERE sfs04=g_sfs[g_cnt].sfs04
          AND sfs07=g_sfs[g_cnt].sfs07_nw
          AND sfs08=g_sfs[g_cnt].sfs08_nw
          AND sfs09=g_sfs[g_cnt].sfs09_nw
          AND sfp01=sfs01 AND sfp04!='X'
      IF cl_null(g_sfs[g_cnt].img10_alo) THEN
         LET g_sfs[g_cnt].img10_alo = 0
      END IF
 
      #作業編號(sfs10)
      IF g_sfs[g_cnt].sfs10 = '　' OR      #全型空白
         cl_null(g_sfs[g_cnt].sfs10) THEN 
         LET g_sfs[g_cnt].sfs10 = ' '
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_sfs.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
#執行
FUNCTION p050_gen()
   DEFINE l_sfp04   LIKE sfp_file.sfp04
   DEFINE l_sfp RECORD LIKE sfp_file.*     #FUN-C30302
   DEFINE l_o_prog   LIKE type_file.chr30  #FUN-C30302
 
   LET g_success = 'Y'
   
   IF g_rec_b = 0 THEN RETURN END IF  
 
   IF cl_sure(0,0) THEN
      LET g_gen = 'Y'
 
      BEGIN WORK
 
      IF g_success = 'Y' THEN
         CALL p050_gen_6()    #產生退料單
      END IF
      IF g_success = 'Y' THEN
         CALL p050_gen_1()    #產生發料單
      END IF
 

      #FUN-C30302---begin
      LET l_o_prog = g_prog
      LET g_prog = 'asfi526'
      IF g_success = 'Y' THEN
         CALL i501sub_y_chk(g_sfb.slip_1,NULL)  #TQC-C60079
         IF g_success = "Y" THEN
            CALL i501sub_y_upd(g_sfb.slip_1,NULL,TRUE)
              RETURNING l_sfp.*
         END IF
      #FUN-C30302---end   
         IF g_success = "Y" THEN
            CALL i501sub_s('2',g_sfb.slip_1,TRUE,FALSE)   #退料過帳
         END IF
      #FUN-C30302---begin
      END IF
       LET g_prog = 'asfi511' 
      IF g_success = 'Y' THEN
         CALL i501sub_y_chk(g_sfb.slip_2,NULL)  #TQC-C60079
         IF g_success = "Y" THEN
            CALL i501sub_y_upd(g_sfb.slip_2,NULL,TRUE)
              RETURNING l_sfp.*
         END IF
      #FUN-C30302---end 
         IF g_success = 'Y' THEN
            CALL i501sub_s('1',g_sfb.slip_2,TRUE,FALSE)   #發料過帳
         END IF
      
      END IF    #FUN-C30302
      LET g_prog = l_o_prog  #FUN-C30302
      
      IF g_success = 'Y' THEN
         #更新原發料單
         #將新產生之退料單號更新原發料單之PBI欄位(sfb08)
         CALL p050_upd_old_sfp()
      END IF
 
      IF g_success = 'Y' THEN
         #更新工單生產數量
         CALL p050_upd_sfb08()
      END IF
 
      IF g_success = 'Y' THEN
         #更新工單回貨批號
         CALL p050_upd_sfbiicd13()
      END IF  
 
      IF g_success='Y' THEN
         CALL cl_err('','abm-019',1)
         COMMIT WORK
      ELSE
         CALL cl_err('','abm-020',1)
         ROLLBACK WORK
         #---產生不成功,還原所有動作---
         CALL p050_rollback_bin()
         DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_1
         DELETE FROM sfp_file WHERE sfp01 = g_sfb.slip_2
         CALL cl_err('rollback ok','!',0)
      END IF
      CLEAR FORM
      CALL g_sfs.clear()
      INITIALIZE g_sfb.* TO NULL      #DEFAULT 設定
   END IF
END FUNCTION 
 
#產生退料單
FUNCTION p050_gen_6()
   DEFINE l_sfs02_nw  LIKE sfs_file.sfs02
 
   FOR g_ac = 1 TO g_rec_b
       IF g_ac = 1 THEN
          LET l_sfs02_nw = 0
       ELSE
          LET l_sfs02_nw = g_sfs[g_ac-1].sfs02_nw
       END IF
 
       IF g_success = 'Y' THEN
          #庫存明細資料檢查
          CALL p050_chk_img('6',g_ac)
       END IF
       IF g_success = 'Y' THEN
          #新增sfq_file
          CALL p050_ins_sfq('6',g_sfb.slip_1)  
       END IF
       IF g_success = 'Y' THEN
          #新增sfs_file
          CALL p050_ins_sfs('6',g_sfb.slip_1,l_sfs02_nw) 
       END IF
       IF g_success = 'Y' THEN
          #新增退料單入庫刻號明細資料
          CALL p050_ins_ida()
       END IF
   END FOR
   FOR g_ac = 1 TO g_rec_b
       IF g_ac = 1 THEN
          LET l_sfs02_nw = 0
       ELSE
          LET l_sfs02_nw = g_sfs[g_ac-1].sfs02_nw
       END IF
       IF g_success = 'Y' THEN
          #更新本次新增退料單項次之參考數量
          CALL p050_upd_sfs35(l_sfs02_nw)
       END IF
   END FOR
END FUNCTION
 
#產生發料單
FUNCTION p050_gen_1()
   DEFINE l_sfs02_nw  LIKE sfs_file.sfs02
 
   FOR g_ac = 1 TO g_rec_b
       IF g_ac = 1 THEN
          LET l_sfs02_nw = 0
       ELSE
          LET l_sfs02_nw = g_sfs[g_ac-1].sfs02_nw
       END IF
 
       IF g_success = 'Y' THEN
          #庫存明細資料檢查
          CALL p050_chk_img('1',g_ac)
       END IF
       IF g_success = 'Y' THEN
          #檢查同工單發料料號需從相同換貨倉儲批做換貨發料
          CALL p050_chk_789('g')
       END IF
       IF g_success = 'Y' THEN
          CALL p050_ins_sfq('1',g_sfb.slip_2)
       END IF
       IF g_success = 'Y' THEN
          CALL p050_ins_sfs('1',g_sfb.slip_2,l_sfs02_nw)
       END IF
   END FOR
END FUNCTION 
 
FUNCTION p050_ins_sfp(p_cmd,p_key)
   DEFINE p_cmd  LIKE type_file.chr1   #異動類別(1:成套發料 6:成套退料)
   DEFINE p_key  LIKE sfp_file.sfp01  
 
   INITIALIZE b_sfp.* TO NULL
 
   LET b_sfp.sfp01 = p_key          #發料單號 
   LET b_sfp.sfp02 = g_today        #輸入日期 
   LET b_sfp.sfp03 = g_sfb.sfp03    #扣帳日期 
   LET b_sfp.sfp04 = 'N'            #扣帳碼(Y/N/X)   
   LET b_sfp.sfp05 = 'N'            #列印碼(Y/N)
   LET b_sfp.sfp06 = p_cmd          #異動類別(1:成套發料 6:成套退料)
   LET b_sfp.sfp07 = ' '            #製造部門              
   LET b_sfp.sfp08 = ' '            #料表批號 
   LET b_sfp.sfp09 = 'N'            #挪料否  
   LET b_sfp.sfp10 = ' '            #序號   
   LET b_sfp.sfpuser = g_user       #資料所有者     
   LET b_sfp.sfpgrup = g_grup       #資料所有部門     
   LET b_sfp.sfpmodu = ' '          #資料修改者   
   LET b_sfp.sfpdate = g_today      #最近修改日    
   LET b_sfp.sfp11 = ' '            #理由碼         
   LET b_sfp.sfpplant = g_plant     #FUN-980004 add
   LET b_sfp.sfplegal = g_legal     #FUN-980004 add
   #FUN-AB0001--add---str---
   LET b_sfp.sfpconf = 'N'          #確認碼
   LET b_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET b_sfp.sfp15 = '0'            #簽核狀況
   LET b_sfp.sfp16 = g_user         #申請人
   #FUN-AB0001--add---end---
 
   LET b_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
   LET b_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO sfp_file VALUES (b_sfp.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = "[Type:",p_cmd,"   NO.",b_sfp.sfp01,"  ins sfp fail  ]"
      CALL cl_err(g_msg CLIPPED,SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 
 
FUNCTION p050_ins_sfq(p_cmd,p_key)
   DEFINE p_cmd  LIKE type_file.chr1   #異動類別(1:成套發料 6:成套退料)
   DEFINE p_key   LIKE sfp_file.sfp01
   DEFINE l_sfq03 LIKE sfq_file.sfq03   #發料套數
  
   #目前只處理一筆工單資料
   IF g_ac != 1 THEN RETURN END IF
   
   INITIALIZE b_sfq.* TO NULL
 
   LET b_sfq.sfq01 = p_key                #發料單號 
   LET b_sfq.sfq02 = g_sfs[g_ac].sfs03    #工單單號
   LET b_sfq.sfq03 = g_sfb.sfb081         #發料套數    
   LET b_sfq.sfq04 = g_sfs[g_ac].sfs10    #作業編號 
   #LET b_sfq.sfq05 = ' '                  #計劃日期    #FUN-C30302
   LET b_sfq.sfq05 = g_today     #FUN-C30302   
   LET b_sfq.sfq06 = NULL                 #No use  
   LET b_sfq.sfqplant = g_plant  #FUN-980004 add
   LET b_sfq.sfqlegal = g_legal  #FUN-980004 add
#FUN-B20095 --------------Begin---------------
   SELECT sfs012 INTO b_sfq.sfq012 FROM sfs_file
    WHERE sfs01 = p_key
      AND sfs02 = g_sfs[g_ac].sfs02
   IF cl_null(b_sfq.sfq012) THEN
      LET b_sfq.sfq012 = ' '
   END IF
#FUN-B20095 --------------End----------------- 
   LET b_sfq.sfq014 = ' '   #FUN-C70014 add
   INSERT INTO sfq_file VALUES (b_sfq.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = "[Type:",p_cmd,"   NO.",b_sfp.sfp01,"  ins sfq fail ]"
      CALL cl_err(g_msg,SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 
 
FUNCTION p050_ins_sfs(p_cmd,p_key,p_sfs02_nw)
   DEFINE p_cmd  LIKE type_file.chr1   #異動類別(1:成套發料 6:成套退料)
   DEFINE p_key  LIKE sfp_file.sfp01
   DEFINE l_sfs07    LIKE sfs_file.sfs07,
          l_sfs08    LIKE sfs_file.sfs08,
          l_sfs09    LIKE sfs_file.sfs09
   DEFINE p_sfs02_nw LIKE sfs_file.sfs02
   DEFINE l_sfp07    LIKE sfp_file.sfp07  #FUN-CB0087 製造部門
   DEFINE l_sfp16    LIKE sfp_file.sfp16  #FUN-CB0087 申請人
 
   IF p_cmd = '1' THEN   #發料
      LET l_sfs07 = g_sfs[g_ac].sfs07_nw
      LET l_sfs08 = g_sfs[g_ac].sfs08_nw
      LET l_sfs09 = g_sfs[g_ac].sfs09_nw
   END IF
   IF p_cmd = '6' THEN   #退料
      LET l_sfs07 = b_sfs07_2
      LET l_sfs08 = b_sfs08_2
      LET l_sfs09 = b_sfs09_2
   END IF
 
   #該新單據項次已存在則更新數量即可
   IF g_ac != 1 AND 
      g_sfs[g_ac].sfs02_nw = p_sfs02_nw THEN
#FUN-BB0084 ------------------------Begin----------------------
      LET g_sfs[g_ac].sfs05_nw = s_digqty(g_sfs[g_ac].sfs05_nw,g_sfs[g_ac].sfs06)  
      LET g_sfs[g_ac].sfs32 = s_digqty(g_sfs[g_ac].sfs32,g_sfs[g_ac].sfs30)   
      LET g_sfs[g_ac].sfs35 = s_digqty(g_sfs[g_ac].sfs35,g_sfs[g_ac].sfs33)
#FUN-BB0084 ------------------------End------------------------
      UPDATE sfs_file SET sfs05 = sfs05 + g_sfs[g_ac].sfs05_nw,
                          sfs32 = sfs32 + g_sfs[g_ac].sfs32,   #單位一數量
                          sfs35 = sfs35 + g_sfs[g_ac].sfs35    #單位二數量   
         WHERE sfs01 = p_key
           AND sfs02 = g_sfs[g_ac].sfs02_nw
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd sfs05',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      RETURN
   END IF
 
   INITIALIZE b_sfs.* TO NULL
 
   LET b_sfs.sfs01 = p_key                 #發料單號    
   LET b_sfs.sfs02 = g_sfs[g_ac].sfs02_nw  #項次  
   LET b_sfs.sfs03 = g_sfs[g_ac].sfs03     #工單單號     
   LET b_sfs.sfs04 = g_sfs[g_ac].sfs04     #料號 
   LET b_sfs.sfs05 = g_sfs[g_ac].sfs05_nw  #發料數量     
   LET b_sfs.sfs06 = g_sfs[g_ac].sfs06     #發料單位   
   LET b_sfs.sfs05 = s_digqty(b_sfs.sfs05,b_sfs.sfs06)    #FUN-BB0084
   LET b_sfs.sfs07 = l_sfs07               #倉庫 
   LET b_sfs.sfs08 = l_sfs08               #儲位 
   LET b_sfs.sfs09 = l_sfs09               #批號 
   LET b_sfs.sfs10 = g_sfs[g_ac].sfs10     #作業編號    
   LET b_sfs.sfs21 = g_sfs[g_ac].sfs21     #備註     
   LET b_sfs.sfs22 = ''                    #No use    
   LET b_sfs.sfs23 = ''                    #No use  
   LET b_sfs.sfs24 = ''                    #No use     
   LET b_sfs.sfs25 = ''                    #No use     
   LET b_sfs.sfs26 = g_sfs[g_ac].sfs26     #替代碼    
  #LET b_sfs.sfs27 = ''                    #被替代料號     #No.MOD-8B0086 mark 
   LET b_sfs.sfs27 = b_sfs.sfs04           #被替代料號     #No.MOD-8B0086 add
   LET b_sfs.sfs28 = 0                     #替代率    
   LET b_sfs.sfs30 = g_sfs[g_ac].sfs30     #單位一 
   LET b_sfs.sfs31 = g_sfs[g_ac].sfs31     #單位一換算率(與生產單位)   
   LET b_sfs.sfs32 = g_sfs[g_ac].sfs32     #單位一數量                
   LET b_sfs.sfs33 = g_sfs[g_ac].sfs33     #單位二                   
   LET b_sfs.sfs34 = g_sfs[g_ac].sfs34     #單位二換算率(與生產單位) 
   LET b_sfs.sfs35 = g_sfs[g_ac].sfs35     #單位二數量   
   LET b_sfs.sfsplant = g_plant  #FUN-980004 add
   LET b_sfs.sfslegal = g_legal  #FUN-980004 add
   LET b_sfs.sfs012 = ' '        #FUN-A60027 add
   LET b_sfs.sfs013 = 0          #FUN-A60027 add  
   LET b_sfs.sfs014 = ' '        #FUN-C70014 add
  
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT sfp07,sfp16 INTO l_sfp07,l_sfp16 FROM sfp_file WHERE sfp01 = p_key 
      CALL s_reason_code(b_sfs.sfs01,b_sfs.sfs03,'',b_sfs.sfs04,b_sfs.sfs07,l_sfp16,l_sfp07) RETURNING b_sfs.sfs37
      IF cl_null(b_sfs.sfs37) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfs_file VALUES (b_sfs.*) 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = "[Type:",p_cmd,"   NO.",b_sfp.sfp01,"  ins sfs fail ]"
      CALL cl_err(g_msg,SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
#FUN-B70074 -----------------Begin-----------------------
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE b_sfsi.* TO NULL
         LET b_sfsi.sfsi01 = b_sfs.sfs01
         LET b_sfsi.sfsi02 = b_sfs.sfs02
         IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#FUN-B70074 -----------------End--------------------------
   END IF
END FUNCTION 
 
#產生退料單之刻號BIN入庫明細
FUNCTION p050_ins_ida()
   DEFINE l_cnt  LIKE type_file.num5
 
   INITIALIZE g_idd.* TO NULL
 
   DECLARE ins_ida_dec CURSOR FOR
      SELECT * FROM idd_file,ima_file,imaicd_file
         WHERE idd10 = g_sfs[g_ac].sfs01   #單據編號(原發料單號)
           AND idd11 = g_sfs[g_ac].sfs02   #單據項次(原發料項次)
           AND idd01 = ima01               #料號
           AND imaicd00=ima01
           AND (imaicd08 = 'Y' OR imaicd09 = 'Y')         #FUN-BA0051
           #AND imaicd08 = 'Y'                 #展明細否   #FUN-BA0051 mark
           #AND imaicd04 IN ('0','1','2','4')  #料件狀態   #FUN-BA0051 mark
  
   FOREACH ins_ida_dec INTO g_idd.*
 
      #排除該發料單已被退料之刻號明細(不含換批退料的)
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
         FROM idd_file
        WHERE idd01 = g_idd.idd01  #料
          AND idd02 = g_idd.idd02  #倉
          AND idd03 = g_idd.idd03  #儲
          AND idd04 = g_idd.idd04  #批
          AND idd05 = g_idd.idd05  #刻號
          AND idd06 = g_idd.idd06  #BIN
          AND idd30 IS NOT NULL
          AND idd31 IS NOT NULL
          AND idd30 = g_sfs[g_ac].sfs01
          AND idd31 = g_sfs[g_ac].sfs02
      IF l_cnt > 0  THEN
         CONTINUE FOREACH
      END IF
      #檢查該刻號明細是否已被Hold住(存在其他未過帳的退料單中)
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt
         FROM ida_file
        WHERE ida01 = g_idd.idd01  #料
          AND ida02 = g_idd.idd02  #倉
          AND ida03 = g_idd.idd03  #儲
          AND ida04 = g_idd.idd04  #批
          AND ida05 = g_idd.idd05  #刻號
          AND ida06 = g_idd.idd06  #BIN
          AND ida30 IS NOT NULL
          AND ida31 IS NOT NULL
          AND ida30 = g_sfs[g_ac].sfs01
          AND ida31 = g_sfs[g_ac].sfs02
      IF l_cnt > 0 THEN
         #該刻號明細已被勾選至其他未過帳退料單中,請查核!!
         CALL cl_err('ins ida:','aic-199',1)
         LET g_success = 'N'
         RETURN
      END IF
 
      LET g_ida.ida01 = g_idd.idd01            #料號
      LET g_ida.ida02 = b_sfs.sfs07            #倉庫
      LET g_ida.ida03 = b_sfs.sfs08            #儲位
      LET g_ida.ida04 = b_sfs.sfs09            #批號
      LET g_ida.ida05 = g_idd.idd05            #刻號
      LET g_ida.ida06 = g_idd.idd06            #BIN
      LET g_ida.ida07 = g_sfb.slip_1           #單據編號(退料)
      LET g_ida.ida08 = g_sfs[g_ac].sfs02_nw   #單據項次
      LET g_ida.ida09 = g_idd.idd08            #異動日期
      LET g_ida.ida10 = g_idd.idd13            #實收數量
      LET g_ida.ida11 = g_idd.idd26            #不良數量
      LET g_ida.ida12 = g_idd.idd27            #報廢數量
      LET g_ida.ida13 = g_idd.idd07            #單位
      LET g_ida.ida14 = g_idd.idd15            #母體料號
      LET g_ida.ida15 = g_idd.idd16            #母批
      LET g_ida.ida16 = g_idd.idd17            #DATECODE
      LET g_ida.ida17 = g_idd.idd18            #DIE 數
      LET g_ida.ida18 = g_idd.idd19            #YIELD
      LET g_ida.ida19 = g_idd.idd20            #TEST #
      LET g_ida.ida20 = g_idd.idd21            #DEDUCT
      LET g_ida.ida21 = g_idd.idd22            #PASS BIN
      LET g_ida.ida22 = g_idd.idd23            #接單料號
      LET g_ida.ida27 = g_idd.idd28            #轉入否
      LET g_ida.ida28 = '1'                    #異動別(出入庫別)
      LET g_ida.ida29 = g_idd.idd25            #備註
      LET g_ida.ida26 = g_idd.idd24            #入庫否
      LET g_ida.ida30 = g_sfs[g_ac].sfs01      #來源單號
      LET g_ida.ida31 = g_sfs[g_ac].sfs02      #來源項次
      LET g_ida.idaplant = g_plant #FUN-980004 add
      LET g_ida.idalegal = g_legal #FUN-980004 add
 
      INSERT INTO ida_file VALUES(g_ida.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('ins ida',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      #FUN-C30302---begin
      LET g_ida.ida07 = g_sfs[g_ac].sfs03
      LET g_ida.ida08 = 1
      INSERT INTO ida_file VALUES(g_ida.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('ins ida',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      #FUN-C30302---end
   END FOREACH
END FUNCTION 
 
FUNCTION p050_ins_idb()
   DEFINE l_r               LIKE type_file.chr1     #FUN-C30302
   DEFINE l_qty             LIKE type_file.num15_3  #FUN-C30302
   DEFINE l_idb      RECORD LIKE idb_file.*              #FUN-C30302
   #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   #DEFINE l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark

   #FUN-BA0051 --START mark-- 
   #LET l_imaicd08 = NULL
   #LET l_imaicd04 = NULL
   #SELECT imaicd08,imaicd04
   #  INTO l_imaicd08,l_imaicd04
   #  FROM imaicd_file
   # WHERE imaicd00 = g_sfs[l_ac].sfs04
   # 
   #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' AND
   #   l_imaicd04 MATCHES '[0124]' THEN
   #FUN-BA0051 --END mark--
   IF s_icdbin(g_sfs[l_ac].sfs04) THEN   #FUN-BA0051   
      IF cl_confirm('aic-312') THEN    #No.FUN-830078
         LET g_dies = 0
         CALL s_icdout(g_sfs[l_ac].sfs04,       #料
                        g_sfs[l_ac].sfs07_nw,    #倉
                        g_sfs[l_ac].sfs08_nw,    #儲
                        g_sfs[l_ac].sfs09_nw,    #批
                        g_sfs[l_ac].sfs06,       #單位
                        #g_sfs[l_ac].sfa06,       #數量(已發數量)  #FUN-C30302
                        g_sfs[l_ac].sfs05,                       #FUN-C30302
                        g_sfb.slip_2,            #單號
                        g_sfs[l_ac].sfs02_nw,    #項次   
                        b_sfp.sfp02,'N','','','','')
              RETURNING g_dies,l_r,l_qty   #FUN-C30302
            
         CALL p050_upd_dies()

         #FUN-C30302---begin
         DELETE FROM idb_file WHERE idb07 = g_sfs[l_ac].sfs03 AND idb08 = 1
         
         DECLARE p050_idb_cs CURSOR FOR        
          SELECT * FROM idb_file
           WHERE idb07 = g_sfb.slip_2 AND idb08 = g_sfs[l_ac].sfs02_nw
   
         FOREACH p050_idb_cs INTO l_idb.*
             LET l_idb.idb07 = g_sfs[l_ac].sfs03
             LET l_idb.idb08 = 1
             IF cl_null(l_idb.idb02) THEN LET l_idb.idb02 = ' ' END IF
             IF cl_null(l_idb.idb03) THEN LET l_idb.idb03 = ' ' END IF 
             IF cl_null(l_idb.idb04) THEN LET l_idb.idb04 = ' ' END IF     
             INSERT INTO idb_file VALUES(l_idb.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","idb_file",l_idb.idb07,'1',SQLCA.sqlcode,"","ins idb",1)         
                LET g_success = 'N'
             END IF    
         END FOREACH   
         #FUN-C30302---end
      END IF  
   END IF
END FUNCTION 
 
#更新die數
#當料號為wafer段時imaicd04=0-1,用dice數量加總給原將單據的第二單位數量。
#當料號為wafer段時imaicd04=2,用pass bin = 'Y'數量加總給原將單據的第二單位數量。
FUNCTION p050_upd_dies()
   DEFINE l_ima906    LIKE ima_file.ima906,
          l_imaicd04  LIKE imaicd_file.imaicd04
   DEFINE i           LIKE type_file.num5
   DEFINE l_sfs35     LIKE sfs_file.sfs35
 
   IF g_sma.sma115 = 'Y' THEN
      LET l_ima906 = NULL
      LET l_imaicd04 = NULL
      SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04 
        FROM ima_file,imaicd_file
       WHERE ima01 = g_sfs[l_ac].sfs04
         AND imaicd00=ima01
      IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[13]' THEN
         IF l_imaicd04 MATCHES '[012]' THEN
            LET g_sfs[l_ac].sfs35 = g_dies             #數量
            LET g_sfs[l_ac].sfs35 = s_digqty(g_sfs[l_ac].sfs35,g_sfs[l_ac].sfs33)    #FUN-BB0084
            LET g_sfs[l_ac].sfs34 = g_sfs[l_ac].sfs32/g_sfs[l_ac].sfs35
            DISPLAY BY NAME g_sfs[l_ac].sfs34, g_sfs[l_ac].sfs35
         END IF
      END IF
   END IF
   #依比率重算參考數量
   LET l_sfs35 = g_sfs[l_ac].sfs35
   FOR i = 1 TO g_rec_b
       IF g_sfs[i].sfs02_nw = g_sfs[l_ac].sfs02_nw THEN
          LET g_sfs[i].sfs35 = l_sfs35 * 
                              (g_sfs[i].sfs05_nw/g_sfs[l_ac].sfa06)
          LET g_sfs[i].sfs34 = g_sfs[i].sfs32/g_sfs[i].sfs35
          LET g_sfs[i].sfs35 = s_digqty(g_sfs[i].sfs35,g_sfs[i].sfs33)   #FUN-BB0084 
          DISPLAY BY NAME g_sfs[i].sfs34
          DISPLAY BY NAME g_sfs[i].sfs35
       END IF
   END FOR
END FUNCTION
 
FUNCTION p050_rollback_bin()
 
   #還原退料單據的刻號明細資料(ida_file)
   DELETE FROM ida_file
      WHERE ida07 = g_sfb.slip_1
   
   #還原發料單據的刻號明細資料(idb_file)
   INITIALIZE g_idb.* TO NULL
 
   DECLARE del_idb CURSOR FOR
      SELECT * FROM idb_file
         WHERE idb07 = g_sfb.slip_2
   IF SQLCA.SQLCODE THEN
      CALL cl_err('del_idb',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   FOREACH del_idb INTO g_idb.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach del_idb',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN 
      END IF
 
      #更新idc21(已備置量)(扣除出貨數量)
      UPDATE idc_file
         SET idc21 = idc21 - g_idb.idb11
       WHERE idc01 = g_idb.idb01  #料號
         AND idc02 = g_idb.idb02  #倉庫
         AND idc03 = g_idb.idb03  #儲位
         AND idc04 = g_idb.idb04  #批號
         AND idc05 = g_idb.idb05  #刻號
         AND idc06 = g_idb.idb06  #BIN
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd idc21(-)',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN 
      END IF
   END FOREACH
 
   #刪除idb_file
   DELETE FROM idb_file
      WHERE idb07 = g_sfb.slip_2

   #FUN-C30302---begin
   DELETE FROM ida_file
      WHERE ida07 = g_sfs[g_ac].sfs03

   DELETE FROM idb_file
      WHERE idb07 = g_sfs[g_ac].sfs03
   #FUN-C30302---end
   
END FUNCTION 
 
#將新產生之退料單號更新原發料單之PBI欄位(sfp08)
FUNCTION p050_upd_old_sfp()
   FOR g_ac = 1 TO g_rec_b
       UPDATE sfp_file
          SET sfp08 = g_sfb.slip_1
        WHERE sfp01 = g_sfs[g_ac].sfs01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd sfp08(PBI)',SQLCA.SQLCODE,1)
          LET g_success = 'N'
          RETURN
       END IF
   END FOR
END FUNCTION 
 
#-----------------更新工單生產數量----------------------------------#
#3.3.1 若該生產工單之作業群組 = '3.DS' or '4.ASS',
#      將已挑選之Pass Bin之數量回寫至生產工工單及採購單
#3.3.1.1 檢查是否有數量: 檢查工單之生產數量(sfb08)及委外採購單(pmn20)
#        是否有數量,
#3.3.1.1.1 若有數量, 則顯示目前之發料數量及生產數料之差異,
#          若有差異, 則更新生產數量(sfb08)及委外採購單(pmn20),
#3.3.1.1.2若沒有數量, 則更新生產數量(sfb08)及委外採購單(pmn20)
FUNCTION p050_upd_sfb08()
   DEFINE l_yn         LIKE type_file.chr1    #Y:要更新sfb08,pmn20 N:不用更新
   DEFINE l_diff       LIKE sfb_file.sfb08   #差異數量
   DEFINE l_qty        LIKE sfb_file.sfb08  
   DEFINE l_ecdicd01   LIKE ecd_file.ecdicd01
   DEFINE l_sfb08      LIKE sfb_file.sfb08
   DEFINE l_sfbiicd04  LIKE sfbi_file.sfbiicd04
   DEFINE l_dies       LIKE sfs_file.sfs35      #FUN-C30302
   DEFINE l_sfa  RECORD LIKE sfa_file.*         #FUN-C30302
   DEFINE l_sfaiicd03  LIKE sfai_file.sfaiicd03 #FUN-C30302
   DEFINE l_pmn  RECORD LIKE pmn_file.*         #FUN-C30302
 
   LET l_yn = 'N'
 
   SELECT sfb08,sfbiicd04
     INTO l_sfb08,l_sfbiicd04
     FROM sfb_file,sfbi_file
    WHERE sfb01=g_sgb.sfb01
      AND sfbi01=sfb01
 
   #取得作業編號之作業群組
   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
      WHERE ecd01 = g_sfb.sfbiicd09   #作業編號
   IF l_ecdicd01 MATCHES '[34]' THEN
      IF l_sfbiicd04 IS NOT NULL AND l_sfbiicd04 <> 0 THEN
         IF cl_null(l_sfb08) OR l_sfb08 = 0 THEN   
            LET l_yn = 'Y'
         ELSE
            #參考數量
            SELECT SUM(sfe35) INTO l_qty FROM sfe_file
               WHERE sfe02 = g_sfb.slip_2
            IF cl_null(l_qty) THEN LET l_qty = 0 END IF
 
            IF l_qty != l_sfb08 THEN
               #目前之發料數量及生產數量有差異,
               #更新生產數量(sfb08),及委外採購單(pmn20)
               LET l_diff = l_qty - l_sfb08
               CALL cl_err_msg(NULL,"aic-204",
                               l_qty||"|"||l_sfb08||"|"||l_diff,10)
               LET l_yn = 'Y'
            END IF
         END IF
      END IF
   END IF
 
   IF l_yn = 'Y' THEN
      #更新工單生產數量
      UPDATE sfb_file SET sfb08 = l_qty
         WHERE sfb01 = g_sfb.sfb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd sfb08',SQLCA.SQLCODE,1)
         LET g_success = 'N' RETURN
      END IF  
      #更新委外採購單數量
      UPDATE pmn_file SET pmn20 = l_qty,
                          pmn87 = pmn20    #FUN-C30302
         WHERE pmn41 = g_sfb.sfb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd pmn20',SQLCA.SQLCODE,1)
         LET g_success = 'N' RETURN
      END IF
   END IF
   #FUN-C30302---begin
   DECLARE p050_sfa_dies CURSOR FOR
      SELECT sfa_file.*,sfaiicd03 FROM sfa_file,sfai_file
       WHERE sfa01 = g_sfb.sfb01
         AND sfa01 = sfai01
         AND sfa03 = sfai03
         AND sfa08 = sfai08
         AND sfa12 = sfai12
   INITIALIZE l_sfa.* TO NULL
   LET l_sfaiicd03 = ''
   FOREACH p050_sfa_dies INTO l_sfa.*,l_sfaiicd03
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,0) EXIT FOREACH
      END IF
      SELECT SUM(idb16) INTO l_dies FROM idb_file
       WHERE idb01 = l_sfa.sfa03
         AND idb02 = l_sfa.sfa30
         AND idb03 = l_sfa.sfa31
         AND idb04 = l_sfaiicd03
         AND idb07 = g_sfb.sfb01
         AND idb08 = 1  
         AND idb16 IS NOT NULL
         AND idb20 = 'Y' 
      IF cl_null(l_dies) THEN LET l_dies=0 END IF 
      
      UPDATE sfai_file SET sfaiicd01 = l_dies
       WHERE sfai01 = l_sfa.sfa01
         AND sfai03 = l_sfa.sfa03
         AND sfai08 = l_sfa.sfa08
         AND sfai12 = l_sfa.sfa12
         AND sfai27 = l_sfa.sfa27
         AND sfai012= l_sfa.sfa012
         AND sfai013= l_sfa.sfa013 

      UPDATE pmn_file SET pmn85 = l_dies,
                          pmn87 = pmn20
         WHERE pmn41 = g_sfb.sfb01
           AND pmn04 = l_sfa.sfa03
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd pmn85',SQLCA.SQLCODE,1)
         LET g_success = 'N' RETURN
      END IF

      DECLARE p050_pmn_cs CURSOR FOR
         SELECT *
           FROM pmn_file 
          WHERE pmn41 = g_sfb.sfb01
            AND pmn04 = l_sfa.sfa03

      FOREACH p050_pmn_cs INTO l_pmn.* 
         LET l_pmn.pmn88 = cl_digcut(l_pmn.pmn87 * l_pmn.pmn31, t_azi04)
         LET l_pmn.pmn88t = cl_digcut(l_pmn.pmn87 * l_pmn.pmn31t, t_azi04)
      
         UPDATE pmn_file SET pmn88 = l_pmn.pmn88,
                             pmn88t= l_pmn.pmn88t
            WHERE pmn01 = l_pmn.pmn01
              AND pmn02 = l_pmn.pmn02
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd pmn88',SQLCA.SQLCODE,1)
            LET g_success = 'N' RETURN
         END IF
      END FOREACH 
   END FOREACH                    
   #FUN-C30302---end
END FUNCTION
 
#---------------------更新工單回貨批號----------------------------------#
#3.5 回貨批號若該料號分批作委外, 則須賦予回貨批號, 
#    即發料批號+'01',以此類推; 由母工單號更為入庫單號作比較    
#3.5.2 比對庫存該批號數量是否和本工單之發料數是否相同
#3.5.2.1若相同, 則回貨批號 = 發料批號            
#3.5.2.2 若不同, 則至回貨批號檔(idl_file)取目前最大號碼, 
#        若取不到則從'01'開始編,  若取得到(idl02),                  
#        則回貨批號 = 回貨批號 + '.'+ to_str(最大碼(idl02)+1); 
#        取號後, 須回寫回貨批號檔(idl_file)       
#3.5.3若無庫存該批號數量, 則回貨批號 = 發料批號
FUNCTION p050_upd_sfbiicd13()
   DEFINE l_int       LIKE type_file.num10,
          l_idl02     LIKE idl_file.idl02,
          l_img09     LIKE img_file.img09,
          l_img10     LIKE img_file.img10,
          l_sfe07     LIKE sfe_file.sfe07,   #倉
          l_sfe08     LIKE sfe_file.sfe08,   #儲
          l_sfe09     LIKE sfe_file.sfe09,   #批
          l_sfe10     LIKE sfe_file.sfe10,   #單位
          l_sfe16     LIKE sfe_file.sfe16    #數量
   DEFINE l_lot_new   LIKE sfbi_file.sfbiicd13   #回貨批號
   DEFINE l_sfbiicd13 LIKE sfbi_file.sfbiicd13
 
   DECLARE upd_sfbiicd13 CURSOR FOR
      SELECT sfe07,sfe08,sfe09,sfe10,SUM(sfe16)
        FROM sfe_file
       WHERE sfe01 = g_sfb.sfb01            #工單單號
         AND sfe02 = g_sfb.slip_2           #異動單據編號
       GROUP BY sfe07,sfe08,sfe09,sfe10
   IF SQLCA.SQLCODE THEN
      CALL cl_err('dec upd_sfbiicd13',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   FOREACH upd_sfbiicd13 INTO l_sfe07,l_sfe08,l_sfe09,l_sfe10,l_sfe16
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach upd_sfbiicd13',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF 
 
      LET l_lot_new = l_sfe10
 
      #比對庫存該批號數量是否和本工單之發料數是否相同
      SELECT img09,img10 INTO l_img09,l_img10 FROM img_file
         WHERE img01 = l_sfe07   #料
           AND img02 = l_sfe08   #倉
           AND img03 = l_sfe09   #儲
           AND img04 = l_sfe10   #批
      IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
 
      LET l_img10 = l_img10 + l_sfe16
 
      #若無庫存該批號數量, 則回貨批號 = 發料批號
      IF SQLCA.sqlcode = 100 OR l_img10 = 0 THEN
         LET l_sfbiicd13 = l_lot_new
      ELSE
         IF l_img10 = l_sfe16 THEN
            #1.若相同, 則回貨批號 = 發料批號
            LET l_sfbiicd13 = l_lot_new
         ELSE
            #2.若不同,則至回貨批號檔(idl_file)取目前最大號碼,
            SELECT MAX(idl02) INTO l_idl02 FROM idl_file
               WHERE idl01 = l_lot_new
            IF cl_null(l_idl02) THEN
               #2-1.若取不到則從'01'開始編,
               LET l_idl02 = '01'
               LET l_sfbiicd13 = l_lot_new CLIPPED,'.',l_idl02
               #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
               INSERT INTO idl_file(idl01,idl02)
                  VALUES(l_lot_new,l_idl02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err('ins idl_file:',SQLCA.sqlcode,1)
                  LET g_success = 'N' RETURN
               END IF
            ELSE
               #2-2. 若取得到idl02,
               #     則回貨批號 = 回貨批號 + '.'+ to_str(MAX(idl02)+1)
               LET l_int = l_idl02
               LET l_int = l_int + 1
               LET l_idl02 = l_int USING '&&'
               LET l_sfbiicd13 = l_lot_new CLIPPED,'.',l_idl02
               #取號後, 須回寫回貨批號檔(idl_file)  用發料批號串idl01
               UPDATE idl_file SET idl02 = l_idl02
                  WHERE idl01 = l_lot_new
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err('upd idl_file:',SQLCA.sqlcode,1)
                  LET g_success = 'N' RETURN
               END IF
            END IF
         END IF
      END IF  
      #更新工單回貨批號(sfbiicd13)
      UPDATE sfb_file SET sfbiicd13 = l_sfbiicd13
        WHERE sfb01 = g_sfb.sfb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd sfbiicd13',SQLCA.SQLCODE,0)
         LET g_success = 'N' RETURN
      END IF
      #更新工單發料批號(sfaiicd03) 07/01/02
      UPDATE sfa_file SET sfaiicd03 = l_lot_new
        WHERE sfa01 = g_sfb.sfb01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd sfaiicd03',SQLCA.SQLCODE,0)
         LET g_success = 'N' RETURN
      END IF
      #更新採購單批號(pmniicd16) 07/01/02
      UPDATE pmn_file SET pmniicd16 = l_lot_new
        WHERE pmn01 = g_sfb.sfb01 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd pmniicd16',SQLCA.SQLCODE,0)
         LET g_success = 'N' RETURN
      END IF
 
   END FOREACH
 
END FUNCTION 
 
FUNCTION p050_chk_img(p_cmd,p_ac)
   DEFINE p_cmd        LIKE type_file.chr1   #1.發料   6.退料
   DEFINE p_ac         LIKE type_file.num5
   DEFINE l_flag       LIKE type_file.num5,
          l_factor     LIKE ima_file.ima31_fac
 
   LET g_success = 'Y'
 
   IF p_cmd = '1' THEN  #發料
      IF cl_null(g_sfs[p_ac].sfs07_nw) THEN #換貨倉庫
         CALL cl_err('','aic-205',1) #倉庫,批號欄位不可空白,請查核!!
         LET g_success = 'N'
         RETURN
      END IF
      IF g_sfs[p_ac].sfs08_nw = '　' OR    #換貨儲位
         g_sfs[p_ac].sfs08_nw IS NULL THEN 
         LET g_sfs[p_ac].sfs08_nw = ' '
      END IF 
      IF g_sfs[p_ac].sfs09_nw = '　' OR    #換貨批號
         g_sfs[p_ac].sfs09_nw IS NULL THEN
         LET g_sfs[p_ac].sfs09_nw =' '
      END IF
      IF cl_null(g_sfs[p_ac].sfs09_nw) THEN
         CALL cl_err('','aic-205',1) #倉庫,批號欄位不可空白,請查核!!
         LET g_success = 'N'
         RETURN
      END IF
      
      #檢查換貨倉儲批不可與原發料倉儲批相同
      IF g_sfs[p_ac].sfs07_nw = g_sfs[p_ac].sfs07 AND 
         g_sfs[p_ac].sfs08_nw = g_sfs[p_ac].sfs08 AND 
         g_sfs[p_ac].sfs09_nw = g_sfs[p_ac].sfs09 THEN
         CALL cl_err('','aic-206',1)
         LET g_success = 'N'
         RETURN
      END IF
 
      #取得庫存明細資料
      SELECT img09,img10 INTO g_img09,g_sfs[p_ac].img10
         FROM img_file
        WHERE img01 = g_sfs[p_ac].sfs04
          AND img02 = g_sfs[p_ac].sfs07_nw
          AND img03 = g_sfs[p_ac].sfs08_nw
          AND img04 = g_sfs[p_ac].sfs09_nw
      IF SQLCA.SQLCODE THEN
         CALL cl_err('sel img:',STATUS,0)
         LET g_success = 'N'
         RETURN
      END IF
      IF cl_null(g_sfs[p_ac].img10) THEN
         LET g_sfs[p_ac].img10 = 0 
      END IF
      #單位換算(發料單位<->庫存單位)
      IF g_sfs[p_ac].sfs06<>g_img09 THEN
         CALL s_umfchk(g_sfs[p_ac].sfs04,g_sfs[p_ac].sfs06,g_img09)
              RETURNING l_flag,l_factor
         IF l_flag THEN    
            CALL cl_err('sfs06<->img09:','asf-400',0) 
            LET g_success = 'N'
            RETURN
         END IF
      ELSE
         LET l_factor = 1
      END IF
 
      #取得該庫存明細在檢量
      SELECT SUM(sfs05) INTO g_sfs[p_ac].img10_alo
         FROM sfs_file,sfp_file
        WHERE sfs04=g_sfs[p_ac].sfs04
          AND sfs07=g_sfs[p_ac].sfs07_nw
          AND sfs08=g_sfs[p_ac].sfs08_nw
          AND sfs09=g_sfs[p_ac].sfs09_nw
          AND sfp01=sfs01 AND sfp04!='X'
      IF cl_null(g_sfs[p_ac].img10_alo) THEN
         LET g_sfs[p_ac].img10_alo = 0
      END IF
      DISPLAY BY NAME g_sfs[p_ac].img10_alo
      DISPLAY BY NAME g_sfs[p_ac].img10
 
      SELECT COUNT(*) INTO g_cnt FROM img_file
         WHERE img01 = g_sfs[p_ac].sfs04      #料號
           AND img02 = g_sfs[p_ac].sfs07_nw   #倉庫
           AND img03 = g_sfs[p_ac].sfs08_nw   #儲位
           AND img04 = g_sfs[p_ac].sfs09_nw   #批號
           AND img18 < b_sfp.sfp02            #有效日期
      IF g_cnt > 0 THEN    #大於有效日期
         CALL cl_err('','aim-400',0)   #須修改
         LET g_success = 'N'
         RETURN
      END IF
 
      #判斷庫存數量是否足夠
      IF (g_sfs[p_ac].sfs05_nw * l_factor) > g_sfs[p_ac].img10 THEN
         #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN  #FUN-C80107 mark
          LET l_flag01 = NULL    #FUN-C80107 add
          #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_sfs[p_ac].sfs07_nw) RETURNING l_flag01   #FUN-C80107 #FUN-D30024--mark
          CALL s_inv_shrt_by_warehouse(g_sfs[p_ac].sfs07_nw,g_plant) RETURNING l_flag01                   #FUN-D30024--add  #TQC-D40078 g_plant
          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
             CALL cl_err(g_sfs[p_ac].sfs05_nw,'mfg1303',0)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
   END IF
 
   IF p_cmd = '6' THEN #2.退料
      IF cl_null(g_sfb.sfs07_2) THEN  #退料倉庫
         LET b_sfs07_2 = g_sfs[p_ac].sfs07
      ELSE
         LET b_sfs07_2 = g_sfb.sfs07_2
      END IF
 
      IF cl_null(g_sfb.sfs08_2) THEN  #退料儲位
         LET b_sfs08_2 = ' '
      ELSE
         LET b_sfs08_2 = g_sfb.sfs08_2
      END IF
      IF b_sfs08_2 = '　' OR b_sfs08_2 IS NULL THEN
         LET b_sfs08_2 = ' '
      END IF
 
      #LET b_sfs09_2 = g_sfs[p_ac].sfs09  #退料批號
      IF cl_null(g_sfb.sfs09_2) THEN  #退料批號
         LET b_sfs09_2 =' '
      ELSE
         LET b_sfs09_2 = g_sfb.sfs09_2
      END IF
      IF b_sfs09_2 = '　' OR b_sfs09_2 IS NULL THEN
         LET b_sfs09_2 =' '
      END IF
 
      #取得庫存明細資料
      SELECT img09,img10 INTO g_img09,g_img10
         FROM img_file
        WHERE img01=g_sfs[p_ac].sfs04 
          AND img02=b_sfs07_2
          AND img03=b_sfs08_2
          AND img04=b_sfs09_2
      IF SQLCA.SQLCODE THEN
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF NOT cl_confirm('mfg1401') THEN 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         CALL s_add_img(g_sfs[p_ac].sfs04,b_sfs07_2,
                        b_sfs08_2,b_sfs09_2,
                        g_sfb.slip_1,g_sfs[p_ac].sfs02_nw,
                        b_sfp.sfp02)
         IF g_errno='N' THEN LET g_success = 'N' RETURN END IF
         SELECT img09,img10 INTO g_img09,g_img10
            FROM img_file
           WHERE img01=g_sfs[p_ac].sfs04 
             AND img02=b_sfs07_2
             AND img03=b_sfs08_2
             AND img04=b_sfs09_2
      END IF
 
      #判斷是否需有參考單位
      IF cl_null(g_sfs[p_ac].sfs33) THEN RETURN END IF    
  
      #參考單位檢查
      CALL s_chk_imgg(g_sfs[p_ac].sfs04,b_sfs07_2,
                      b_sfs08_2,b_sfs09_2,
                      g_sfs[p_ac].sfs33) 
           RETURNING l_flag
      IF l_flag = 1 THEN
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF NOT cl_confirm('aim-995') THEN 
               LET g_success = 'N'
               RETURN
            END IF
            CALL s_add_imgg(g_sfs[p_ac].sfs04,b_sfs07_2,
                            b_sfs08_2,b_sfs09_2,
                            g_sfs[p_ac].sfs33,g_sfs[p_ac].sfs34,
                            g_sfb.slip_1,
                            g_sfs[p_ac].sfs02_nw,0) 
                 RETURNING l_flag
            IF l_flag = 1 THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
   END IF
END FUNCTION 
 
#檢查同工單發料料號需從相同換貨倉儲批做換貨發料
FUNCTION p050_chk_789(p_cmd)
   DEFINE i  LIKE type_file.num5
   DEFINE p_cmd  LIKE type_file.chr1  #b:單身呼叫(警告不拒絕)
                                      #g:產生時總檢(警告且拒絕)
 
   FOR i = 1 TO g_rec_b
       IF g_sfs[l_ac].sfs03 = g_sfs[i].sfs03 AND    #工單單號
          g_sfs[l_ac].sfs04 = g_sfs[i].sfs04 AND    #發料料號
          g_sfs[l_ac].sfs06 = g_sfs[i].sfs06 AND    #發料單位
          g_sfs[l_ac].sfs10 = g_sfs[i].sfs10 THEN   #作業編號
          IF g_sfs[i].sfs07_nw != g_sfs[l_ac].sfs07_nw OR 
             g_sfs[i].sfs08_nw != g_sfs[l_ac].sfs08_nw OR 
             g_sfs[i].sfs09_nw != g_sfs[l_ac].sfs09_nw THEN
             #同工單發料料號需從相同換貨倉儲批做換貨發料,
             #目前有不相同情型,請查核!!
             CALL cl_err('','aic-207',1)
             IF p_cmd = 'g' THEN
                LET g_success = 'N'
             END IF
             EXIT FOR
          END IF 
       END IF
   END FOR
END FUNCTION 
 
#產生退料單之刻號BIN入庫明細
FUNCTION p050_upd_sfs35(p_sfs02_nw)
   DEFINE l_sfs35       LIKE sfs_file.sfs35
   DEFINE p_sfs02_nw    LIKE sfs_file.sfs02
   #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   #DEFINE l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
 
   #該新單據項次已存在
   IF g_sfs[g_ac].sfs02_nw = p_sfs02_nw THEN
      RETURN
   END IF
 
   #FUN-BA0051 --START mark--
   #LET l_imaicd08 = NULL
   #LET l_imaicd04 = NULL
   #SELECT imaicd08,imaicd04
   #  INTO l_imaicd08,l_imaicd04
   #  FROM imaicd_file
   # WHERE imaicd00 = g_sfs[g_ac].sfs04
   # 
   #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' AND
   #   l_imaicd04 MATCHES '[0-2]' THEN
   #FUN-BA0051 --END mark--
   IF s_icdbin(g_sfs[g_ac].sfs04) THEN   #FUN-BA0051 
      SELECT SUM(ida17) INTO l_sfs35
         FROM ida_file
        WHERE ida07 = g_sfb.slip_1         #單據編號
          AND ida08 = g_sfs[g_ac].sfs02_nw #單據項次 
 
      UPDATE sfs_file SET sfs35 = l_sfs35
         WHERE sfs01  = g_sfb.slip_1         #單據編號
           AND sfs02  = g_sfs[g_ac].sfs02_nw #單據項次 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd sfs35',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION 
