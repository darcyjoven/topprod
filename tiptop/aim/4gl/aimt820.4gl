# Prog. Version..: '5.30.06-13.04.12(00010)'     #
#
# Pattern name...: aimt820.4gl
# Descriptions...: 初盤點維護作業－現有庫存
# Date & Author..: 93/05/28 By Apple
# NOTE...........: 本程式的設計必須考慮使用者的操作輸入為主
# Modify.........: 95/07/08 By Danny (判斷pia10是否為null,將.per pia09 之
#                                     NOENTRY 拿掉)
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0248 04/10/27 By Yuna QBE開窗開不出來
# Modify.........: No.MOD-550014 05/05/03 By kim 欄位控管
# Modify.........: No.MOD-550024 05/05/04 By kim 會計科目開窗後,無法將正確值帶回欄位
# Modify.........: No.FUN-570082 05/07/14 By Carrier 多單位內容修改
# Modify.........: No.FUN-570025 05/07/04 By kim 快速輸入第一筆取消+1
# Modify.........: No.FUN-570192 05/08/10 By Sarah 若執行的是aimt821，則隱藏新增功能
# Modify.........: No.TQC-590017 05/09/20 By Claire [查詢](任意資料)->執行[快速輸入]->執行[放棄] 
#                                                   畫面資料即被被清空,但卻又可以按上一筆或下一筆...
# Modify.........: No.FUN-5B0137 05/11/28 By kim 增加 參考單位 ima906='3' 時 同 ima906='2' 時 處理
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: NO.MOD-610112 06/01/25 By PENGU 使用雙單位時最後會做t820_mul_unit() update回pia30,pia40但轉換單位
                                    #              為"料件庫存單位" 應該轉成"此盤點單使用單位"
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-670060 06/07/18 By Pengu 清除[新增]功能
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-710039 07/03/06 By pengu  登錄時會呼叫 t820_pia01() 會重新撈取 pia_file 資料導致在 t820_show()
#                                                   呼叫 t820_pia02() 所得到的 pia66 pia67 pia68 值皆被清空
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.FUN-6B0019 07/04/13 By rainy 改為單檔多欄方式
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改程序內有'(+)'的語法
# Modify.........: No.MOD-7C0085 07/12/17 By Pengu 在輸入盤點數量時會將pia10清為null
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810029 08/03/05 By Pengu 程式會用到g_pia08變數，但卻未給g_pia08值
# Modify.........: No.FUN-860001 08/06/02 By Sherry 批序號-盤點
# Modify.........: No.FUN-8A0147 08/11/10 By douzh 批序號-盤點調整參數傳入邏輯
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.CHI-910008 09/02/17 By jan 輸入新的倉儲批要詢問是否新增
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
# Modify.........: No.MOD-940074 09/05/25 By Pengu 只有需要做批序號的料件才需要呼叫s_lotcheck
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.TQC-A10113 10/05/12 By lilingyu 執行程式後,右邊ringmenu會出現btn01-btn10的action
# Modify.........: No.TQC-AA0119 10/10/21 By houlia 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/11/02 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B70032 11/08/11 By jason 刻號/BIN盤點
# Modify.........: No:FUN-BB0086 11/12/05 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-C30696 12/03/15 By xujing 修改t820_b_fill()抓資料sql條件
# Modify.........: No:CHI-C30068 12/06/15 By bart IF pia16='Y' THEN pia931可輸
# Modify.........: No:MOD-C60184 12/06/21 By bart  pia16='Y' 可執行lotcheck
# Modify.........: No.FUN-CB0087 12/12/14 By xujing 倉庫單據理由碼改善
# Modify.........: No:MOD-CC0235 13/01/09 By Elise AFTER ROW增加料倉儲批控卡
# Modify.........: No:MOD-CC0192 13/01/11 By Elise after field 倉庫/儲位新舊值的if判斷拿掉
# Modify.........: No.TQC-D10103 13/01/30 By xujing 處理理由碼改善控管的一些問題
# Modify.........: No.TQC-D20042 13/02/25 By xujing 處理理由碼改善問題
# Modify.........: No:CHI-B40010 13/04/12 By Alberti 查詢時應要可以輸入日期

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_pia    DYNAMIC  ARRAY OF  RECORD
           pia16     LIKE  pia_file.pia16,
           pia01     LIKE  pia_file.pia01,
           pia02     LIKE  pia_file.pia02,
           ima02     LIKE  ima_file.ima02,
           ima021    LIKE  ima_file.ima021,
           pia19     LIKE  pia_file.pia19,
           pia03     LIKE  pia_file.pia03,
           pia04     LIKE  pia_file.pia04,
           pia05     LIKE  pia_file.pia05,
           pia06     LIKE  pia_file.pia06,
           pia09     LIKE  pia_file.pia09,
           pia07     LIKE  pia_file.pia07,
           qty       LIKE  pia_file.pia30,
          #tagdate   LIKE  pia_file.pia45,        #CHI-B40010 mark
           pia35     LIKE  pia_file.pia35,        #CHI-B40010 add
           peo       LIKE  pia_file.pia44,
           gen02     LIKE  gen_file.gen02,
           pia930    LIKE  pia_file.pia930,
           gem02     LIKE  gem_file.gem02,
           pia931    LIKE  pia_file.pia931,                         #FUN-930122
           icdcnt    LIKE  type_file.chr1,                          #FUN-B70032
           pia70     LIKE  pia_file.pia70,                          #FUN-CB0087
           azf03     LIKE  azf_file.azf03                           #FUN-CB0087
            END RECORD,
    g_pia_t    RECORD
           pia16     LIKE  pia_file.pia16,
           pia01     LIKE  pia_file.pia01,
           pia02     LIKE  pia_file.pia02,
           ima02     LIKE  ima_file.ima02,
           ima021    LIKE  ima_file.ima021,
           pia19     LIKE  pia_file.pia19,
           pia03     LIKE  pia_file.pia03,
           pia04     LIKE  pia_file.pia04,
           pia05     LIKE  pia_file.pia05,
           pia06     LIKE  pia_file.pia06,
           pia09     LIKE  pia_file.pia09,
           pia07     LIKE  pia_file.pia07,
           qty       LIKE  pia_file.pia30,
          #tagdate   LIKE  pia_file.pia45,               #CHI-B40010 mark
           pia35     LIKE  pia_file.pia35,               #CHI-B40010 add
           peo       LIKE  pia_file.pia44,
           gen02     LIKE  gen_file.gen02,
           pia930    LIKE  pia_file.pia930,
           gem02     LIKE  gem_file.gem02,
           pia931    LIKE  pia_file.pia931,                        #FUN-930122
           icdcnt    LIKE  type_file.chr1,                         #FUN-B70032
           pia70     LIKE  pia_file.pia70,                          #FUN-CB0087
           azf03     LIKE  azf_file.azf03                           #FUN-CB0087
        END RECORD,
    g_pia_o    RECORD
           pia16     LIKE  pia_file.pia16,
           pia01     LIKE  pia_file.pia01,
           pia02     LIKE  pia_file.pia02,
           ima02     LIKE  ima_file.ima02,
           ima021    LIKE  ima_file.ima021,
           pia19     LIKE  pia_file.pia19,
           pia03     LIKE  pia_file.pia03,
           pia04     LIKE  pia_file.pia04,
           pia05     LIKE  pia_file.pia05,
           pia06     LIKE  pia_file.pia06,
           pia09     LIKE  pia_file.pia09,
           pia07     LIKE  pia_file.pia07,
           qty       LIKE  pia_file.pia30,
          #tagdate   LIKE  pia_file.pia45,                  #CHI-B40010 mark
           pia35     LIKE  pia_file.pia35,                  #CHI-B40010 add
           peo       LIKE  pia_file.pia44,
           gen02     LIKE  gen_file.gen02,
           pia930    LIKE  pia_file.pia930,
           gem02     LIKE  gem_file.gem02,
           pia931    LIKE  pia_file.pia931,                         #FUN-930122
           icdcnt    LIKE  type_file.chr1,                          #FUN-B70032
           pia70     LIKE  pia_file.pia70,                          #FUN-CB0087
           azf03     LIKE  azf_file.azf03                           #FUN-CB0087
        END RECORD,
    g_pia08             LIKE pia_file.pia08,    
    g_pia10             LIKE pia_file.pia10,    
    g_pia66             LIKE pia_file.pia66,
    g_pia67             LIKE pia_file.pia67,
    g_pia68             LIKE pia_file.pia68,
    g_wc,g_sql          string,                 #No.FUN-580092 HCN
    g_argv1             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_t1                LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_before_input_done LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_ima906            LIKE ima_file.ima906,   #No.FUN-570082
    g_ima25             LIKE ima_file.ima25
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql     STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_chr            LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_msg            LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5     #No.FUN-690026 SMALLINT
  DEFINE  l_ac     LIKE type_file.num5,
          l_ac_t   LIKE type_file.num5,
          g_rec_b  LIKE type_file.num5,
          g_wc2    STRING
DEFINE l_y         LIKE type_file.chr1     #No.FUN-8A0147
DEFINE l_qty       LIKE pia_file.pia30     #No.FUN-8A0147
DEFINE g_pia09_t   LIKE pia_file.pia09     #No.FUN-BB0086
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   IF g_argv1 = '1' THEN
      LET g_prog="aimt820"
   ELSE
      LET g_prog="aimt821"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
    INITIALIZE g_pia_t.* TO NULL
    INITIALIZE g_pia_o.* TO NULL
 
 
    CALL g_pia.CLEAR() 
 
 
    LET p_row = 3 LET p_col = 27
 
    OPEN WINDOW t820_w AT p_row,p_col WITH FORM "aim/42f/aimt820" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    #2004/06/02共用程式時呼叫
    CALL cl_set_locale_frm_name("aimt820")
    CALL cl_ui_init()

    CALL cl_set_comp_required('pia70',g_aza.aza115='Y')   #FUN-CB0087 

    CALL cl_set_comp_visible("pia930,gem02",g_aaz.aaz90='Y')  #FUN-670093
    #FUN_B70032 --START--
    IF s_industry('icd') THEN
       CALL cl_set_act_visible("icdcheck,icd_checking",TRUE)
       CALL cl_set_comp_visible("icdcnt",TRUE)       
    ELSE
       CALL cl_set_act_visible("icdcheck,icd_checking",FALSE)
       CALL cl_set_comp_visible("icdcnt",FALSE)
    END if 
    #FUN_B70032 --END--
    WHILE TRUE
      LET g_action_choice=""
      CALL t820_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t820_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
 
 
 
FUNCTION t820_menu()
  WHILE TRUE
    CALL t820_bp("G")
    CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t820_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t820_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "multi_unit_taking"
            IF g_rec_b <= 0 THEN RETURN END IF
            IF g_argv1='1' THEN
               LET g_sql = "aimt822"," '",g_pia[l_ac].pia01 CLIPPED,"'"
            ELSE
               LET g_sql = "aimt823"," '",g_pia[l_ac].pia01 CLIPPED,"'"
            END IF
            CALL cl_cmdrun_wait(g_sql)
            CALL t820_mul_unit('Y')
 
        WHEN "lot_checking"
            IF NOT cl_chk_act_auth() THEN RETURN END IF
            IF g_rec_b <= 0 THEN RETURN END IF
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM pias_file
             WHERE pias01=g_pia[l_ac].pia01
            IF g_cnt= 0 THEN RETURN END IF
            CALL s_lotcheck(g_pia[l_ac].pia01,
                            g_pia[l_ac].pia02,
                            g_pia[l_ac].pia03,
                            g_pia[l_ac].pia04,
                            g_pia[l_ac].pia05,            #No.FUN-8A0147
                            g_pia[l_ac].qty,'QRY')        #No.FUN-8A0147
                  RETURNING l_y,l_qty                     #No.FUN-8A0147
            IF l_y = 'Y' THEN                             #No.FUN-8A0147
               LET g_pia[l_ac].qty = l_qty                #No.FUN-8A0147
            END IF                                        #No.FUN-8A0147
        #FUN-B70032 --START--
        WHEN "icd_checking"
            IF NOT cl_chk_act_auth() THEN RETURN END IF
            IF g_rec_b <= 0 THEN RETURN END IF
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM piad_file
             WHERE piad01=g_pia[l_ac].pia01
            IF g_cnt= 0 THEN RETURN END IF
            CALL s_icdcount(g_pia[l_ac].pia01,
                            g_pia[l_ac].pia02,
                            g_pia[l_ac].pia03,
                            g_pia[l_ac].pia04,
                            g_pia[l_ac].pia05,            
                            g_pia[l_ac].qty,'QRY')        
                  RETURNING l_y,l_qty
        #FUN-B70032 --END--
        
        WHEN "related_document"  #No.MOD-470515
           IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
              IF g_pia[l_ac].pia01 IS NOT NULL THEN
                 LET g_doc.column1 = "pia01"
                 LET g_doc.value1 = g_pia[l_ac].pia01
                 CALL cl_doc()
              END IF
           END IF
        WHEN "exporttoexcel"   
           IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pia),'','')
           END IF
        WHEN "exit"
            EXIT WHILE
    END CASE
  END WHILE
END FUNCTION
 
FUNCTION  t820_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
  LET g_action_choice = " "
  IF g_sma.sma115 = 'N' THEN
     CALL cl_set_act_visible("multi_unit_taking",FALSE)
  ELSE
     CALL cl_set_act_visible("multi_unit_taking",TRUE)
  END IF
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
 
  DISPLAY ARRAY g_pia TO s_pia.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
     BEFORE ROW
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()
 
     ON ACTION query
        LET g_action_choice="query"
        EXIT DISPLAY
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
 
     ON ACTION detail
        LET g_action_choice = "detail"
        LET l_ac =1                    #FUN-AA0059
        EXIT DISPLAY
 
     ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DISPLAY
 
     ON ACTION multi_unit_taking
        LET g_action_choice = "multi_unit_taking"
        EXIT DISPLAY
 
     ON ACTION lot_checking
        LET g_action_choice = "lot_checking"
        IF g_rec_b != 0 THEN                                                                                                      
           CALL fgl_set_arr_curr(l_ac)                                                                                     
        END IF
        EXIT DISPLAY
 
     #FUN-B70032 --START--        
     ON ACTION icd_checking
        LET g_action_choice = "icd_checking"
        IF g_rec_b != 0 THEN                                                                                                      
           CALL fgl_set_arr_curr(l_ac)                                                                                     
        END IF
        EXIT DISPLAY        
     #FUN-B70032 --END--
     
     ON ACTION controlg
        CALL cl_cmdask()
     ON ACTION help
        CALL cl_show_help()
     ON ACTION related_document
        LET g_action_choice = "related_document"
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
     ON ACTION about        
        CALL cl_about()
     ON ACTION exporttoexcel   
        LET g_action_choice = "exporttoexcel"
        EXIT DISPLAY
     ON ACTION exit
        LET g_action_choice = "exit"
        EXIT DISPLAY
     ON ACTION cancel
        LET g_action_choice = "exit"
        EXIT DISPLAY
#      &include "qry_string.4gl"       #TQC-A10113
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION
 
FUNCTION t820_peo_show()
  DEFINE l_pia  RECORD LIKE pia_file.*
   SELECT * INTO l_pia.*  FROM pia_file
    WHERE pia01 = g_pia[l_ac].pia01
   IF g_argv1 = '1' THEN
     LET g_pia[l_ac].qty     = l_pia.pia30
     LET g_pia[l_ac].peo     = l_pia.pia34
    #LET g_pia[l_ac].tagdate = l_pia.pia35    #CHI-B40010 mark
   ELSE
     LET g_pia[l_ac].qty     = l_pia.pia40
     LET g_pia[l_ac].peo     = l_pia.pia44
    #LET g_pia[l_ac].tagdate = l_pia.pia45    #CHI-B40010 mark
   END IF
  #peo,gen02
   SELECT gen02  INTO  g_pia[l_ac].gen02
     FROM gen_file
    WHERE gen01  =  g_pia[l_ac].peo
  #gem02
   SELECT gem02  INTO g_pia[l_ac].gem02
     FROM gem_file 
    WHERE gem01 = g_pia[l_ac].pia930
END FUNCTION
 
 
FUNCTION t820_b_fill(p_wc2)
  DEFINE p_wc2  STRING     #NO.FUN-910082
  DEFINE l_pia  RECORD LIKE pia_file.*
  DEFINE l_cnt  LIKE type_file.num10   #FUN-B70032


  IF cl_null(p_wc2) THEN                #CHI-B40010 add
     LET p_wc2 = " 1=1 "                #CHI-B40010 add
  END IF                                #CHI-B40010 add
 
 
  IF g_argv1 = '1' THEN
     LET g_sql= "SELECT pia16,pia01,pia02,ima02,ima021,pia19,",
                "       pia03,pia04,pia05,pia06, ",
                "       pia09,pia07,pia30,pia35,pia34,gen02,pia930,gem02,pia931",#FUN-930122 Add pia931
                "       ,'0',pia70,azf03",                                                   #FUN-B70032  #FUN-CB0087 pia70,azf03
                "  FROM pia_file,OUTER ima_file,OUTER gen_file,OUTER gem_file,OUTER azf_file ", #TQC-780054  #FUN-CB0087 azf_file
                "  WHERE pia_file.pia02 = ima_file.ima01 ",                               #TQC-780054
                "    AND pia_file.pia34=gen_file.gen01 ",                               #TQC-780054
                "    AND pia_file.pia930=gem_file.gem01 ",                              #TQC-780054
                "    AND pia_file.pia70 = azf_file.azf01 ",                             #FUN-CB0087
                "    AND azf_file.azf02 = '2' ",                                        #FUN-CB0087
                "    AND ", p_wc2 CLIPPED, 
                "  ORDER BY pia01"
  ELSE
     LET g_sql= "SELECT pia16,pia01,pia02,ima02,ima021,pia19,",
                "       pia03,pia04,pia05,pia06, ",
                "       pia09,pia07,pia40,pia45,pia44,gen02,pia930,gem02,pia931",#FUN-930122 Add pia931
                "       ,'0',pia70,azf03",                                                   #FUN-B70032  #FUN-CB0087 pia70,azf03
                "  FROM pia_file,OUTER ima_file,OUTER gen_file,OUTER gem_file,OUTER azf_file ",#TQC-780054   #FUN-CB0087 azf_file
                "  WHERE pia_file.pia02 = ima_file.ima01 ",                              #TQC-780054
     #          "    AND pia_file.pia34=gen_file.gen01 ",                              #TQC-780054     #MOD-C30696 mark
                "    AND pia_file.pia44=gen_file.gen01 ",                                              #MOD-C30696 add
                "    AND pia_file.pia930=gem_file.gem01 ",                             #TQC-780054 
                "    AND pia_file.pia70 = azf_file.azf01 ",                             #FUN-CB0087
                "    AND azf_file.azf02 = '2' ",                                        #FUN-CB0087
                "    AND ", p_wc2 CLIPPED,
                "  ORDER BY pia01"
  END IF
  PREPARE t820_prepare FROM g_sql
  DECLARE t820_curs CURSOR FOR t820_prepare
        
 
   CALL g_pia.clear()
   LET g_cnt = 1
   FOREACH t820_curs INTO g_pia[g_cnt].*  #單身 ARRAY 填充
       IF STATUS THEN
           CALL cl_err('FOREACH:',STATUS,1)
           EXIT FOREACH
       END IF
 
      #FUN-B70032 --START--
      LET g_sql = "SELECT sum(piad30) FROM piad_file ",
                  "WHERE piad01 = '", g_pia[g_cnt].pia01, "' ",
                  " AND piad02 = '", g_pia[g_cnt].pia02, "' ",
                  " AND piad03 = '", g_pia[g_cnt].pia03, "' ",
                  " AND piad04 = '", g_pia[g_cnt].pia04, "' ",
                  " AND piad05 = '", g_pia[g_cnt].pia05, "' "
      DECLARE t820_piad_cl CURSOR FROM g_sql
      OPEN t820_piad_cl      
      FETCH t820_piad_cl INTO l_cnt
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF 
      IF l_cnt <= 0 THEN 
         LET g_pia[g_cnt].icdcnt = '1' 
      END IF
      CLOSE t820_piad_cl
      #FUN-B70032 --END--
    
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pia.deleteElement(g_cnt)
   IF STATUS THEN CALL cl_err('FOREACH:',STATUS,1) END IF
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt

END FUNCTION
 
FUNCTION t820_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

   CALL cl_set_comp_entry("qty",TRUE)
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pia01,pia02,pia03,pia04,pia05,pia06,pia09,pia07",TRUE)
   END IF 
   IF p_cmd = 'u' AND (g_pia[l_ac].pia16='Y') THEN   #FUN-6B0019
      CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07,pia931",TRUE)  #CHI-C30068 add pia931
   END IF
   IF p_cmd = 'z' THEN
      CALL cl_set_comp_entry("pia01",TRUE)
   END IF
   IF p_cmd = 'z' AND (g_pia[l_ac].pia16='Y') THEN   #FUN-6B0019
      CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07,pia931",TRUE) #CHI-C30068 add pia931
   END IF
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("qty",TRUE)
   END IF
END FUNCTION
 
FUNCTION t820_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pia01",FALSE)
   END IF
   IF g_pia[l_ac].pia16 = 'N' AND ((p_cmd = 'u') OR (p_cmd = 'z'))THEN   #FUN-6B0019
     CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07,pia931",FALSE) #CHI-C30068 add pia931
   END IF
   IF g_sma.sma12 = 'N' THEN
     CALL cl_set_comp_entry("pia03,pia04,pia05",FALSE)
   END IF
   IF INFIELD(qty) THEN
      IF g_sma.sma115='Y' AND g_ima906='2' THEN
         CALL cl_set_comp_entry("qty",FALSE)
      END IF
   END IF
     CALL cl_set_comp_entry("pia16,pia19",FALSE)
END FUNCTION

FUNCTION t820_pia02(p_cmd)  #料件編號        
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_ima08      LIKE ima_file.ima08,
           l_imaacti    LIKE ima_file.imaacti
    DEFINE l_cnt        LIKE type_file.num5    #FUN-6B0019 
 
    LET g_errno = ' '
	LET l_ima02=' '
	LET l_ima021=' '
    SELECT ima02,ima021,ima08,ima25,imaacti 
      INTO l_ima02,l_ima021,l_ima08,g_ima25,l_imaacti
      FROM ima_file 
     WHERE ima01 = g_pia[l_ac].pia02   #FUN-6B0019
    CASE 
      WHEN SQLCA.SQLCODE = 100 
        LET g_errno = 'mfg0002' 
	LET l_ima02 = NULL 
      WHEN l_imaacti='N' 
        LET g_errno = '9028' 
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
    CALL  s_cost('1',l_ima08,g_pia[l_ac].pia02) returning g_pia66 
    CALL  s_cost('2',l_ima08,g_pia[l_ac].pia02) returning g_pia67 
    CALL  s_cost('3',l_ima08,g_pia[l_ac].pia02) returning g_pia68 
    IF g_pia08 IS NULL OR g_pia08 =' '
    THEN LET g_pia08 = 0
    END IF
    IF p_cmd = 'a' THEN 
       LET g_pia[l_ac].pia09 = g_ima25   #FUN-6B0019
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_pia[l_ac].ima02 =  l_ima02  
       LET g_pia[l_ac].ima021 = l_ima021  
    END IF
END FUNCTION
 
 
#檢查單位是否存在於單位檔中
FUNCTION t820_unit(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gfe02      LIKE gfe_file.gfe02,
           l_gfeacti    LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = g_pia[l_ac].pia09   #FUN-6B0019
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
   
##盤點人員
FUNCTION t820_peo(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gen02      LIKE gen_file.gen02,
           l_genacti    LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_pia[l_ac].peo  #FUN-6B0019
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_pia[l_ac].gen02 = l_gen02
       DISPLAY BY NAME g_pia[l_ac].gen02
    END IF
END FUNCTION
 
FUNCTION t820_q()
    CALL t820_b_askkey()
END FUNCTION

FUNCTION t820_b_askkey()

  CLEAR FORM
  CALL g_pia.clear()
  CONSTRUCT g_wc2 ON                    # 螢幕上取條件
        pia16, pia01, pia02, pia19,  pia03, pia04, pia05,
        pia06, pia09, pia07, pia35,pia930, pia931,                    #FUN-930122 Add pia931    #CHI-B40010 add pia35
        pia70                                                   #FUN-CB0087 add
      FROM 
        s_pia[1].pia16, s_pia[1].pia01, s_pia[1].pia02, 
        s_pia[1].pia19, s_pia[1].pia03, s_pia[1].pia04, 
        s_pia[1].pia05, s_pia[1].pia06, s_pia[1].pia09, 
        s_pia[1].pia07, s_pia[1].pia35,s_pia[1].pia930,s_pia[1].pia931,        #FUN-930122 Add pia931  #CHI-B40010 add pia35
        s_pia[1].pia70                                          #FUN-CB0087 add
            
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION controlp
      CASE
          WHEN INFIELD(pia02) #查詢料件編號
#FUN-AA0059 --Begin--
         #   CALL cl_init_qry_var()
         #   LET g_qryparam.state    = "c"
         #   LET g_qryparam.form     ="q_ima"
         #   CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
            DISPLAY g_qryparam.multiret TO pia02 
            NEXT FIELD pia02
         WHEN INFIELD(pia03) #倉庫
#TQC-AA0119 --modify
#           CALL cl_init_qry_var()
#           LET g_qryparam.state    = "c"
#           LET g_qryparam.form     ="q_imd"
#           LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#           CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
#TQC-AA0119 --end
            DISPLAY g_qryparam.multiret TO pia03 
            NEXT FIELD pia03
         WHEN INFIELD(pia07) #會計科目
           CALL cl_init_qry_var()
           LET g_qryparam.state    = "c"
           LET g_qryparam.form     ="q_aag"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pia07 
           NEXT FIELD pia07
         WHEN INFIELD(pia09) #庫存單位
           CALL cl_init_qry_var()
           LET g_qryparam.state    = "c"
           LET g_qryparam.form     = "q_gfe"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pia09 
           NEXT FIELD pia09
         WHEN INFIELD(peo) #初盤人員
           CALL cl_init_qry_var()
           LET g_qryparam.state    = "c"
           LET g_qryparam.form     = "q_gen"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO peo
           NEXT FIELD peo
         WHEN INFIELD(pia04) #儲位
#TQC-AA0119  --modify
#          CALL cl_init_qry_var()
#          LET g_qryparam.state    = "c"
#          LET g_qryparam.form     = "q_ime"
#          CALL cl_create_qry() RETURNING g_qryparam.multiret
           CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
#TQC-AA0119  --end
           DISPLAY g_qryparam.multiret TO pia04
           NEXT FIELD pia04 
         WHEN INFIELD(pia05) #批號
           CALL cl_init_qry_var()
           LET g_qryparam.state    = "c"
           LET g_qryparam.form     = "q_img"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pia05
           NEXT FIELD pia05
         WHEN INFIELD(pia930)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_gem4"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_pia[l_ac].pia930   #FUN-6B0019
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia930
            NEXT FIELD pia930
         WHEN INFIELD(pia931)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_pia931"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia931
            NEXT FIELD pia931
         #FUN-CB0087---add---str
         WHEN INFIELD(pia70) #理由  
            CALL cl_init_qry_var()                                          
            LET g_qryparam.form     ="q_azf41"                        
            LET g_qryparam.state = "c"                                                                                                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                    
            DISPLAY g_qryparam.multiret TO pia70                                    
            NEXT FIELD pia70 
         #FUN-CB0087---add---end
         OTHERWISE EXIT CASE
     END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg    
        CALL cl_cmdask()     
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
     ON ACTION qbe_save
        CALL cl_qbe_save()
  END CONSTRUCT
  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     LET g_wc2 = NULL
     RETURN
  END IF
 #CHI-B40010---add---start---
  IF g_argv1 != '1' THEN
     LET g_wc2 = cl_replace_str(g_wc2, "pia35", "pia45")
  END IF
 #CHI-B40010---add---end---
  CALL t820_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t820_b()
  DEFINE
    l_ac_t       LIKE type_file.num5,          #未取消的ARRAY CNT
    l_n          LIKE type_file.num5,          #檢查重複用#No.FU
    l_lock_sw    LIKE type_file.chr1,          #單身鎖住否#No.F
    p_cmd        LIKE type_file.chr1,          #處理狀態#No.FUN
    l_flag       LIKE type_file.chr1,          #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1       
  DEFINE l_pia  RECORD LIKE pia_file.*,
         l_pia16    LIKE pia_file.pia16,
         l_pia19    LIKE pia_file.pia19
  DEFINE l_i,l_j    LIKE type_file.num5
  DEFINE l_cnt1     LIKE type_file.num5    #No.MOD-940074 add    
  DEFINE l_tf       LIKE type_file.chr1    #No.FUN-BB0086 
  DEFINE l_chk      LIKE type_file.chr1    #CHI-C30068 
  DEFINE l_ima918   LIKE ima_file.ima918   #MOD-C60184
  DEFINE l_ima921   LIKE ima_file.ima921   #MOD-C60184
  DEFINE l_flag1     LIKE type_file.chr1     #FUN-CB0087
  DEFINE l_where    STRING                  #FUN-CB0087   
  DEFINE l_sql      STRING                  #FUN-CB0087
  
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
#   LET l_allow_insert = TRUE                       #FUN-930109    #TQC-AA0119
    LET l_allow_insert = FALSE                       #TQC-AA0119
    LET l_allow_delete = TRUE                       #FUN-930109

   IF g_argv1 = '1' THEN         #CHI-B40010 add 
    LET g_forupd_sql = "SELECT pia16,pia01,pia02,'','',pia19,pia03,pia04,pia05,pia06,pia09,pia07,",
                       "       0,'','','',pia930,'',pia931,0,pia70,''",   #FUN-930122 Add pia931 #FUN-B70032 add 'N' #FUN-CB0087 add pia70,''
                       "  FROM pia_file WHERE pia01 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                   
   #CHI-B40010---add---start---
    ELSE
      LET g_forupd_sql = "SELECT pia16,pia01,pia02,'','',pia19,pia03,pia04,pia05,pia06,pia09,pia07,",
                         "       0,pia45,'','',pia930,'',pia931,0",   
                         "  FROM pia_file WHERE pia01 = ?  FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    END IF
   #CHI-B40010---add---end---
    
    DECLARE t820_bcl CURSOR FROM g_forupd_sql      # LOCK CU
 
    INPUT ARRAY g_pia WITHOUT DEFAULTS FROM s_pia.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW = l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac) 
         END IF
         LET g_pia09_t = NULL   #No.FUN-BB0086
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_before_input_done = FALSE
            CALL t820_set_entry(p_cmd)
            CALL t820_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            LET g_pia_t.* = g_pia[l_ac].*  #BACKUP
            LET g_pia_o.* = g_pia[l_ac].*  #BACKUP
            LET g_pia09_t = g_pia[l_ac].pia09   #No.FUN-BB0086
            SELECT pia08 INTO g_pia08 FROM pia_file WHERE pia01 = g_pia[l_ac].pia01    #No.MOD-810029 add
            IF g_pia[l_ac].pia19 = 'Y' THEN  #已過帳，不可更改
              CALL cl_err(g_pia[l_ac].pia01,'mfg0132',1) 
              LET l_j = 0
              FOR l_i = l_ac TO g_rec_b
                IF g_pia[l_i].pia19 = 'N' THEN
                  LET l_j = l_i
                  EXIT FOR
                END IF
              END FOR
              IF l_j <> 0 THEN
                  LET l_ac = l_j  
                  CALL fgl_set_arr_curr(l_ac)
                  CONTINUE INPUT                 #TQC-D10103 add
                  LET g_before_input_done = FALSE
                  CALL t820_set_entry(p_cmd)
                  CALL t820_set_no_entry(p_cmd)
                  LET g_before_input_done = TRUE
                  LET g_pia_t.* = g_pia[l_ac].*  #BACKUP
                  LET g_pia_o.* = g_pia[l_ac].*  #BACKUP
              ELSE
                  ROLLBACK WORK
                  EXIT INPUT
              END IF
            END IF
            OPEN t820_bcl USING g_pia_t.pia01
            IF STATUS THEN
               CALL cl_err("OPEN t820_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t820_bcl INTO g_pia[l_ac].*
               CALL t820_azf03_desc() #TQC-D20042 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pia_t.pia01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               LET g_pia[l_ac].icdcnt = g_pia_t.icdcnt
               
               CALL t820_pia02('d')
               CALL t820_peo_show()
               IF cl_null(g_pia[l_ac].peo) THEN 
                 IF l_ac > 1 THEN
                   LET g_pia[l_ac].peo = g_pia[l_ac-1].peo
                   LET g_pia[l_ac].gen02 = g_pia[l_ac-1].gen02
                 END IF
               END IF
              #LET g_pia[l_ac].tagdate = g_today                     #CHI-B40010 mark
              #DISPLAY BY NAME g_pia[l_ac].peo,g_pia[l_ac].tagdate   #CHI-B40010 mark
              DISPLAY BY NAME g_pia[l_ac].peo                        #CHI-B40010 add
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
 
         LET g_before_input_done = FALSE
         CALL t820_set_entry(p_cmd)
         CALL t820_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
         INITIALIZE g_pia[l_ac].* TO NULL      
         CALL cl_show_fld_cont()     
         NEXT FIELD pia01
 
 
        AFTER FIELD pia01 
           IF p_cmd='z' AND g_pia[l_ac].pia01 IS NULL OR g_pia[l_ac].pia01 = ' '
              THEN NEXT FIELD pia01
           END IF
            
           SELECT pia16,pia19 INTO l_pia16,l_pia19 FROM pia_file
            WHERE pia01=g_pia[l_ac].pia01
           LET g_pia[l_ac].pia16 = l_pia16
           LET g_pia[l_ac].pia19 = l_pia19
           DISPLAY BY NAME g_pia[l_ac].pia16,g_pia[l_ac].pia19
           CALL t820_set_entry(p_cmd)
           CALL t820_set_no_entry(p_cmd)
          
           IF g_pia[l_ac].pia19 ='Y' THEN 
              CALL cl_err(g_pia[l_ac].pia01,'mfg0132',1) 
              EXIT INPUT
           END IF
           LET g_pia_o.pia02 = g_pia[l_ac].pia02
 
 
        BEFORE FIELD pia02
	  IF g_sma.sma60 = 'Y' THEN 	# 若須分段輸入
	     CALL s_inp5(7,23,g_pia[l_ac].pia02) RETURNING g_pia[l_ac].pia02
	     DISPLAY BY NAME g_pia[l_ac].pia02
             IF INT_FLAG THEN LET INT_FLAG = 0 END IF
          END IF
 
        AFTER FIELD pia02      #料件編號
#FUN-AA0059 ---------------------start----------------------------
          IF NOT cl_null(g_pia[l_ac].pia02) THEN
            IF NOT s_chk_item_no(g_pia[l_ac].pia02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_pia[l_ac].pia02= g_pia_t.pia02
               NEXT FIELD pia02
            END IF
          END IF
#FUN-AA0059 ---------------------end-------------------------------
          IF g_pia_o.pia02 IS NULL OR (g_pia_o.pia02 != g_pia[l_ac].pia02) THEN 
            CALL t820_pia02('a')
            IF NOT cl_null(g_errno)  THEN 
               CALL cl_err(g_pia[l_ac].pia02,g_errno,1)
               LET g_pia[l_ac].pia02 = g_pia_o.pia02
               DISPLAY BY NAME g_pia[l_ac].pia02
               NEXT FIELD pia02
            END IF
          END IF
 
	#使用者為單倉時，只須檢查盤點資料檔中是否有此料號
          IF g_sma.sma12 = 'N' THEN
	    SELECT COUNT(*) INTO l_n FROM pia_file
                 	  WHERE pia02=g_pia[l_ac].pia02 
	     IF l_n IS NOT NULL AND l_n > 0 THEN
		CALL cl_err(g_pia[l_ac].pia02,'mfg0131',1)
                LET g_pia[l_ac].pia02 = g_pia_o.pia02
                DISPLAY BY NAME g_pia[l_ac].pia02
                NEXT FIELD pia02
             END IF
          END IF
          LET g_pia_o.pia02 = g_pia[l_ac].pia02
 
 
        #倉庫編號  
        AFTER FIELD pia03 
            #---->依系統參數的設定,檢查倉庫的使用
            IF NOT s_stkchk(g_pia[l_ac].pia03,'A') THEN 
                CALL cl_err(g_pia[l_ac].pia03,'mfg6076',1)    
                LET g_pia[l_ac].pia03 = g_pia_o.pia03
                DISPLAY BY NAME g_pia[l_ac].pia03
                NEXT FIELD pia03
            END IF
#TQC-AA0119 --add
            IF NOT s_chk_ware(g_pia[l_ac].pia03) THEN
               NEXT FIELD pia03
            END IF
#TQC-AA0119 --end
            LET g_pia_o.pia03 = g_pia[l_ac].pia03
                   
        AFTER FIELD pia04  #儲位
            IF g_pia[l_ac].pia04 IS NULL THEN LET g_pia[l_ac].pia04 = ' ' END IF
            IF g_pia[l_ac].pia04 IS NOT NULL AND  g_pia[l_ac].pia04 != ' ' THEN
             
              #---->檢查料件儲位的使用
              CALL s_prechk(g_pia[l_ac].pia02,g_pia[l_ac].pia03,g_pia[l_ac].pia04)
                   RETURNING g_cnt,g_chr  
                   IF NOT g_cnt THEN
                      CALL cl_err(g_pia[l_ac].pia04,'mfg1102',1)
                      LET g_pia[l_ac].pia04 = g_pia_o.pia04
                      DISPLAY BY NAME g_pia[l_ac].pia04
                      NEXT FIELD pia04
                   END IF
            END IF
            LET g_pia_o.pia04 = g_pia[l_ac].pia04
 
 
        AFTER FIELD pia05  #批號
            IF g_pia[l_ac].pia05 IS NULL THEN LET g_pia[l_ac].pia05 = ' ' END IF
           #MOD-CC0192 mark---S
           ##---->資料是否重複檢查
           #IF g_pia[l_ac].pia02 != g_pia_t.pia02 or g_pia_t.pia02 is null  
           #   or g_pia[l_ac].pia03 != g_pia_t.pia03 or g_pia_t.pia03 is null  
           #   or g_pia[l_ac].pia04 != g_pia_t.pia04 or g_pia_t.pia04 is null  
           #   or g_pia[l_ac].pia05 != g_pia_t.pia05 or g_pia_t.pia05 is null  
           #THEN 
           #MOD-CC0192 mark---E
                SELECT COUNT(*) INTO l_n
      		     FROM pia_file
                WHERE pia02=g_pia[l_ac].pia02 
                  AND pia03=g_pia[l_ac].pia03
     		  AND pia04=g_pia[l_ac].pia04
                  AND pia05=g_pia[l_ac].pia05
                  AND pia19 != 'Y' 
   	  	IF l_n > 0 THEN
   	  	    CALL cl_err(g_pia[l_ac].pia05,'mfg0131',1)
                    LET g_pia[l_ac].pia05 = g_pia_o.pia05
                    DISPLAY BY NAME g_pia[l_ac].pia05
                    NEXT FIELD pia02
                END IF
               IF NOT cl_null(g_pia[l_ac].pia03) THEN
                  IF NOT t820_add_img(g_pia[l_ac].pia02,g_pia[l_ac].pia03,g_pia[l_ac].pia04,
                                      g_pia[l_ac].pia05,g_today) THEN
                     NEXT FIELD pia02
                  END IF
               END IF
           #END IF   #MOD-CC0192 mark
            LET g_pia_o.pia05 = g_pia[l_ac].pia05
 
 
        AFTER FIELD pia09 
          LET l_tf = ""   #No.FUN-BB0086
          IF g_pia[l_ac].pia09 IS NOT NULL OR g_pia[l_ac].pia09 != ' ' THEN
             IF g_pia_o.pia09 IS NULL OR (g_pia[l_ac].pia09 !=g_pia_o.pia09) 
              THEN 
                CALL t820_unit('a') 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pia[l_ac].pia09,g_errno,1)
                   LET g_pia[l_ac].pia09 = g_pia_o.pia09
                   DISPLAY BY NAME g_pia[l_ac].pia09
                   NEXT FIELD pia09
                END IF
             END IF
             #No.FUN-BB0086--add--begin--
             IF g_sma.sma115='Y' AND g_ima906='2' THEN
                LET g_pia[l_ac].qty = s_digqty(g_pia[l_ac].qty,g_pia[l_ac].pia09)
                DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
             ELSE 
                CALL t820_qty_check(l_cnt1) RETURNING l_tf 
             END IF 
             #No.FUN-BB0086--add--end--
          END IF
          CALL s_umfchk(g_pia[l_ac].pia02,g_pia[l_ac].pia09,g_ima25)
                 RETURNING g_cnt,g_pia10
          IF g_cnt THEN 
               CALL cl_err('','mfg3075',1)
               LET g_pia[l_ac].pia09 = g_pia_o.pia09
               DISPLAY BY NAME g_pia[l_ac].pia09
               NEXT FIELD pia09
          END IF
          IF g_pia10 IS NULL OR g_pia10 = ' ' THEN 
            LET g_pia10 = 1
          END IF
          LET g_pia_o.pia09 = g_pia[l_ac].pia09
          #No.FUN-BB0086--add--begin--
          LET g_pia09_t = g_pia[l_ac].pia09
          IF NOT l_tf THEN 
             NEXT FIELD qty
          END IF 
          #No.FUN-BB0086--add--end--
 
 
        AFTER FIELD pia07  
          IF g_pia[l_ac].pia07 IS NOT NULL THEN
             IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_pia[l_ac].pia07,g_aza.aza81) THEN 
                     #CALL cl_err(g_pia[l_ac].pia07,'mfg0018',1)    #FUN-B10049
                     CALL cl_err(g_pia[l_ac].pia07,'mfg0018',0)     #FUN-B10049
                     #FUN-B10049--begin
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_pia[l_ac].pia07  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_aza.aza81  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_pia[l_ac].pia07 CLIPPED,"%' "            
                     CALL cl_create_qry() RETURNING g_pia[l_ac].pia07
                     DISPLAY BY NAME g_pia[l_ac].pia07  
                     #FUN-B10049--end                        
                     NEXT FIELD pia07 
                 END IF
             END IF
          END IF
            
       
        BEFORE FIELD qty
          IF g_sma.sma115='Y' THEN
             LET g_ima906=NULL
             SELECT ima906 INTO g_ima906 FROM ima_file
              WHERE ima01=g_pia[l_ac].pia02
           
             IF (g_ima906='2') OR (g_ima906='3') THEN
                IF g_argv1='1' THEN
                     LET g_sql = "aimt822"," '",g_pia[l_ac].pia01 CLIPPED,"'"
                ELSE
                     LET g_sql = "aimt823"," '",g_pia[l_ac].pia01 CLIPPED,"'"
                END IF
                CALL cl_cmdrun_wait(g_sql)
                CALL t820_mul_unit('N')
                CALL t820_set_entry(p_cmd)
                CALL t820_set_no_entry(p_cmd)
             END IF
          END IF
        
 
        AFTER FIELD qty
           IF NOT t820_qty_check(l_cnt1) THEN NEXT FIELD qty END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_pia[l_ac].qty) THEN
            #   IF g_pia[l_ac].qty < 0 THEN 
            #      LET g_pia[l_ac].qty = g_pia_t.qty
            #      NEXT FIELD qty
            #   END IF 
            #   IF g_pia[l_ac].qty != g_pia_t.qty OR g_pia_t.qty IS NULL THEN
            #      LET l_cnt1=0
            #      SELECT COUNT(*) INTO l_cnt1 FROM pias_file
            #       WHERE pias01=g_pia[l_ac].pia01
            #      IF l_cnt1 > 0 THEN
            #      CALL s_lotcheck(g_pia[l_ac].pia01,
            #                      g_pia[l_ac].pia02,
            #                      g_pia[l_ac].pia03,
            #                      g_pia[l_ac].pia04,
            #                      g_pia[l_ac].pia05,        
            #                      g_pia[l_ac].qty,'SET')   
            #           RETURNING l_y,l_qty  
            #      END IF           #No.MOD-940074 add
            #      #FUN-B70032 --START--
            #      IF s_industry('icd') THEN 
            #         LET l_cnt1=0
            #         SELECT COUNT(*) INTO l_cnt1 FROM piad_file
            #          WHERE piad01=g_pia[l_ac].pia01
            #         IF l_cnt1 > 0 THEN
            #            CALL s_icdcount(g_pia[l_ac].pia01,
            #                            g_pia[l_ac].pia02,
            #                            g_pia[l_ac].pia03,
            #                            g_pia[l_ac].pia04,
            #                            g_pia[l_ac].pia05,        
            #                            g_pia[l_ac].qty,'SET')   
            #             RETURNING l_y,l_qty 
            #             IF l_qty <=0 THEN
            #                LET g_pia[l_ac].icdcnt = '1' 
            #             ELSE
            #                LET g_pia[l_ac].icdcnt = '0' 
            #   END IF
            #             DISPLAY BY NAME g_pia[l_ac].icdcnt
            #         END IF
            #      END IF    
            #      #FUN-B70032 --END--
            #   END IF
            #   IF l_y = 'Y' THEN   
            #      LET g_pia[l_ac].qty = l_qty
            #      LET g_pia_t.qty =g_pia[l_ac].qty #FUN-B70032
            #      DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
            #   END IF
            #END IF 
            #No.FUN-BB0086--mark--end--
 
       AFTER FIELD peo    
            IF g_pia[l_ac].peo IS NOT NULL AND g_pia[l_ac].peo !=' ' THEN   
               CALL t820_peo('d')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_pia[l_ac].peo,g_errno,0)
                  LET g_pia[l_ac].peo = g_pia_o.peo
                  DISPLAY BY NAME g_pia[l_ac].peo 
                  NEXT FIELD peo  
                END IF
            END IF  
            IF g_pia[l_ac].peo IS NOT NULL THEN LET g_pia_o.peo = g_pia[l_ac].peo END IF

      #CHI-B40010---modify---start---       
      #AFTER FIELD tagdate #盤點日期 
      #   IF g_pia[l_ac].tagdate IS NULL THEN
      #      LET g_pia[l_ac].tagdate = g_today
      #      DISPLAY BY NAME g_pia[l_ac].tagdate 
      #      NEXT FIELD tagdate
      #   END IF
      #   IF g_pia[l_ac].tagdate IS NOT NULL THEN LET g_pia_o.tagdate = g_pia[l_ac].tagdate END IF
       AFTER FIELD pia35 #盤點日期 
          IF g_pia[l_ac].pia35 IS NULL THEN
             LET g_pia[l_ac].pia35 = g_today
             DISPLAY BY NAME g_pia[l_ac].pia35 
             NEXT FIELD pia35
          END IF
          IF g_pia[l_ac].pia35 IS NOT NULL THEN LET g_pia_o.pia35 = g_pia[l_ac].pia35 END IF
      #CHI-B40010---modify---end---          
       
       AFTER FIELD pia930
           IF NOT s_costcenter_chk(g_pia[l_ac].pia930) THEN
              LET g_pia[l_ac].pia930=g_pia_t.pia930
              DISPLAY NULL TO FORMONLY.gem02
              DISPLAY BY NAME g_pia[l_ac].pia930
              NEXT FIELD pia930
           ELSE
              DISPLAY s_costcenter_desc(g_pia[l_ac].pia930) TO gem02
           END IF
       #CHI-C30068---begin
       AFTER FIELD pia931
          IF NOT cl_null(g_pia[l_ac].pia931) THEN
             LET l_chk = 'N'
             SELECT 'Y' INTO l_chk
               FROM ima_file
              WHERE ima01 = g_pia[l_ac].pia02
                AND (ima06 = g_pia[l_ac].pia931
                 OR  ima09 = g_pia[l_ac].pia931
                 OR  ima10 = g_pia[l_ac].pia931
                 OR  ima11 = g_pia[l_ac].pia931
                 OR  ima12 = g_pia[l_ac].pia931
                 OR  ima23 = g_pia[l_ac].pia931
                 )
             IF l_chk <> 'Y' THEN
                CALL cl_err(g_pia[l_ac].pia931,'aco-058',1)
                NEXT FIELD pia931
             END IF 
          END IF 
       #CHI-C30068---end

       #FUN-CB0087---add---str---
        BEFORE FIELD pia70
            IF g_aza.aza115 = 'Y' AND cl_null(g_pia[l_ac].pia70) THEN 
               CALL s_reason_code(g_pia[l_ac].pia01,'','',g_pia[l_ac].pia02,g_pia[l_ac].pia03,
                                  g_pia[l_ac].gen02,g_pia[l_ac].gem02) RETURNING g_pia[l_ac].pia70
               DISPLAY BY NAME g_pia[l_ac].pia70
            END IF

        AFTER FIELD pia70
            IF t820_pia70_check() THEN
               CALL t820_azf03_desc()
            ELSE 
               NEXT FIELD pia70
            END IF
        #FUN-CB0087---end---end---
 
       AFTER INPUT
          IF g_pia[l_ac].pia03 IS NULL THEN LET g_pia[l_ac].pia03 = ' ' END IF
          IF g_pia[l_ac].pia04 IS NULL THEN LET g_pia[l_ac].pia04 = ' ' END IF
          IF g_pia[l_ac].pia05 IS NULL THEN LET g_pia[l_ac].pia05 = ' ' END IF
          LET l_flag='N'
          IF INT_FLAG THEN EXIT INPUT  END IF
         
          IF cl_null(g_pia10) THEN LET l_flag='Y' END IF
          IF l_flag='Y' THEN 
             CALL cl_err('','mfg2719',0) NEXT FIELD pia09 
          END IF
          LET l_flag='N'
           
          IF g_pia[l_ac].pia02 IS NULL OR g_pia[l_ac].pia02 = ' ' THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_pia[l_ac].pia02 
          END IF    
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD pia02
          END IF
 
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(pia02) #查詢料件編號
#FUN-AA0059 --Begin--
       #           CALL cl_init_qry_var()
       #           LET g_qryparam.form     ="q_ima"
       #           LET g_qryparam.default1 = g_pia[l_ac].pia02
       #           CALL cl_create_qry() RETURNING g_pia[l_ac].pia02
                  CALL q_sel_ima(FALSE, "q_ima", "", g_pia[l_ac].pia02, "", "", "", "" ,"",'' )  RETURNING g_pia[l_ac].pia02
#FUN-AA0059 --End-- 
		  CALL t820_pia02('a')
                  DISPLAY BY NAME g_pia[l_ac].pia02          
                  NEXT FIELD pia02
               WHEN INFIELD(pia03) #倉庫
#TQC-AA0119  --modify
       #          CALL cl_init_qry_var()
       #          LET g_qryparam.form     ="q_imd"
       #          LET g_qryparam.default1 = g_pia[l_ac].pia03
       #          LET g_qryparam.arg1     = 'SW'        #倉庫類別 
       #          CALL cl_create_qry() RETURNING g_pia[l_ac].pia03
                  CALL q_imd_1(FALSE,TRUE,g_pia[l_ac].pia03,"","","","") RETURNING g_pia[l_ac].pia03
#TQC-AA0119  --end
                  DISPLAY BY NAME  g_pia[l_ac].pia03        
                  NEXT FIELD pia03
               WHEN INFIELD(pia04) #儲位
#TQC-AA0119  --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     ="q_ime"
#                 LET g_qryparam.default1 = g_pia[l_ac].pia04
#                 LET g_qryparam.arg1     = g_pia[l_ac].pia03 #倉庫編號 
#                 LET g_qryparam.arg2     = 'SW'        #倉庫類別
#                 CALL cl_create_qry() RETURNING g_pia[l_ac].pia04
                  CALL q_ime_1(FALSE,TRUE,g_pia[l_ac].pia04,g_pia[l_ac].pia03,"",g_plant,"","","") RETURNING g_pia[l_ac].pia04
#TQC-AA0119  --end
                  DISPLAY BY NAME g_pia[l_ac].pia04          
                  NEXT FIELD pia04
               WHEN INFIELD(pia05) #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_img1"
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.default1 = g_pia[l_ac].pia03
                  LET g_qryparam.default2 = g_pia[l_ac].pia04
                  LET g_qryparam.default3 = g_pia[l_ac].pia05
                  LET g_qryparam.arg1     = g_pia[l_ac].pia02
                  IF g_pia[l_ac].pia03 IS NOT NULL THEN
                     LET g_qryparam.where = " img02='",g_pia[l_ac].pia03,"'"
                  END IF
                  IF g_pia[l_ac].pia04 IS NOT NULL THEN
                     IF cl_null(g_qryparam.where) THEN
                       LET g_qryparam.where = "img03='",g_pia[l_ac].pia04,"'"
                     ELSE
                       LET g_qryparam.where = g_qryparam.where CLIPPED,
                                              " AND img03='",g_pia[l_ac].pia04,"'"
                     END IF
                  END IF
                  CALL cl_create_qry() 
                  RETURNING g_pia[l_ac].pia03,g_pia[l_ac].pia04,g_pia[l_ac].pia05
                  DISPLAY BY NAME g_pia[l_ac].pia03,g_pia[l_ac].pia04,g_pia[l_ac].pia05
               WHEN INFIELD(pia07) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_aag"
                  LET g_qryparam.default1 = g_pia[l_ac].pia07
                  LET g_qryparam.arg1 = g_aza.aza81  
                   CALL cl_create_qry() RETURNING g_pia[l_ac].pia07 
                   DISPLAY BY NAME g_pia[l_ac].pia07     
                  NEXT FIELD pia07
               WHEN INFIELD(pia09) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_pia[l_ac].pia09
                  CALL cl_create_qry() RETURNING g_pia[l_ac].pia09
                   DISPLAY BY NAME g_pia[l_ac].pia09            
                  NEXT FIELD pia09
               WHEN INFIELD(peo) #初盤人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.default1 = g_pia[l_ac].peo
                  CALL cl_create_qry() RETURNING g_pia[l_ac].peo
                  DISPLAY BY NAME g_pia[l_ac].peo  
                  NEXT FIELD peo  
               
               WHEN INFIELD(pia930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_pia[l_ac].pia930
                  DISPLAY BY NAME g_pia[l_ac].pia930
                  NEXT FIELD pia930
               #FUN-CB0087---add---str
                WHEN INFIELD(pia70) #理由  
                 CALL s_get_where(g_pia[l_ac].pia01,'','',g_pia[l_ac].pia02,g_pia[l_ac].pia03,
                                  g_pia[l_ac].gen02,g_pia[l_ac].gem02) RETURNING l_flag1,l_where
                 IF l_flag1 AND g_aza.aza115 = 'Y' THEN 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ggc08"
                    LET g_qryparam.where = l_where
                    LET g_qryparam.default1 = g_pia[l_ac].pia70
                 ELSE
                    CALL cl_init_qry_var()                                          
                    LET g_qryparam.form     ="q_azf41"                        
                    LET g_qryparam.default1 = g_pia[l_ac].pia70                                                       
                 END IF                                                        
                 CALL cl_create_qry() RETURNING g_pia[l_ac].pia70   
                 DISPLAY BY NAME g_pia[l_ac].pia70                                    
                 CALL t820_azf03_desc() #TQC-D20042 add
                 NEXT FIELD pia70 
              #FUN-CB0087---add---end
               OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION mntn_unit
            CALL cl_cmdrun("aooi101 ")
 
       ON ACTION mntn_unit_conv
            CALL cl_cmdrun("aooi102 ")
 
       ON ACTION mntn_item_unit_conv
            CALL cl_cmdrun("aooi103")
   
       ON ACTION def_imf
          CALL cl_init_qry_var()
          LET g_qryparam.form     = "q_imf"
          LET g_qryparam.default1 = g_pia[l_ac].pia03       
          LET g_qryparam.default2 = g_pia[l_ac].pia04          
          LET g_qryparam.arg1     = g_pia[l_ac].pia02
          LET g_qryparam.arg2     = "A"
          IF g_qryparam.arg2 != 'A' THEN
              LET g_qryparam.where=g_qryparam.where CLIPPED, 
                   " AND ime04 matches'",g_qryparam.arg2,"'"
          END IF
          CALL cl_create_qry() 
             RETURNING g_pia[l_ac].pia03,g_pia[l_ac].pia04
 
 
          DISPLAY BY NAME g_pia[l_ac].pia03,g_pia[l_ac].pia04
          NEXT FIELD pia03 
 
       ON ACTION lotcheck
          #MOD-C60184---begin
          IF g_pia[l_ac].pia16 ='Y' THEN
             LET l_ima918 = 'N'
             LET l_ima921 = 'N'
             SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
              WHERE ima01=g_pia[l_ac].pia02
             IF l_ima918 = 'Y' OR l_ima921 ='Y' THEN
                CALL s_lotcheck(g_pia[l_ac].pia01,
                                g_pia[l_ac].pia02,
                                g_pia[l_ac].pia03,
                                g_pia[l_ac].pia04,
                                g_pia[l_ac].pia05,        
                                g_pia[l_ac].qty,'SET')   
                       RETURNING l_y,l_qty 
             END IF 
          ELSE 
          #MOD-C60184---end
             LET l_cnt1=0
             SELECT COUNT(*) INTO l_cnt1 FROM pias_file
              WHERE pias01=g_pia[l_ac].pia01
             IF l_cnt1 > 0 THEN
                CALL s_lotcheck(g_pia[l_ac].pia01,
                                g_pia[l_ac].pia02,
                                g_pia[l_ac].pia03,
                                g_pia[l_ac].pia04,
                                g_pia[l_ac].pia05,      
                                g_pia[l_ac].qty,'SET') 
                      RETURNING l_y,l_qty             
             END IF     #No.MOD-940074 add
          END IF  #MOD-C60184
          IF l_y = 'Y' THEN                    
             LET g_pia[l_ac].qty = l_qty      
          END IF                             
          
       #FUN-B70032 --START--
       ON ACTION icdcheck
          LET l_cnt1=0
          SELECT COUNT(*) INTO l_cnt1 FROM piad_file
           WHERE piad01=g_pia[l_ac].pia01
          IF l_cnt1 > 0 THEN
             CALL s_icdcount(g_pia[l_ac].pia01,
                             g_pia[l_ac].pia02,
                             g_pia[l_ac].pia03,
                             g_pia[l_ac].pia04,
                             g_pia[l_ac].pia05,      
                             g_pia[l_ac].qty,'SET') 
                   RETURNING l_y,l_qty           
              IF l_qty <=0 THEN
                 LET g_pia[l_ac].icdcnt = '1' 
              ELSE
                 LET g_pia[l_ac].icdcnt = '0' 
              END IF 
              DISPLAY BY NAME g_pia[l_ac].icdcnt     
          END IF     
          IF l_y = 'Y' THEN                    
             LET g_pia[l_ac].qty = l_qty   
             LET g_pia_t.qty =g_pia[l_ac].qty
             DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
          END IF                   
       #FUN-B70032 --END--
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
           CALL cl_cmdask()
 
       ON ACTION CONTROLF                        # 欄位說明
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
  
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pia[l_ac].* = g_pia_t.*
            CLOSE t820_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_pia[l_ac].pia01,-263,0)
            LET g_pia[l_ac].* = g_pia_t.*
         ELSE
             #CHI-910008--BEGIN--
             IF cl_null(g_pia[l_ac].pia03) THEN LET g_pia[l_ac].pia03 = ' ' END IF 
             IF cl_null(g_pia[l_ac].pia04) THEN LET g_pia[l_ac].pia04 = ' ' END IF 
             IF cl_null(g_pia[l_ac].pia05) THEN LET g_pia[l_ac].pia05 = ' ' END IF 
             IF NOT t820_add_img(g_pia[l_ac].pia02,g_pia[l_ac].pia03,g_pia[l_ac].pia04,
                                 g_pia[l_ac].pia05,g_today) THEN
                NEXT FIELD pia02
             END IF
             INITIALIZE l_pia.*  TO NULL
             SELECT * INTO l_pia.* FROM pia_file 
              WHERE pia01 = g_pia[l_ac].pia01            
             CALL s_umfchk(g_pia[l_ac].pia02,g_pia[l_ac].pia09,g_ima25)
                    RETURNING g_cnt,g_pia10
             IF g_pia10 IS NULL OR g_pia10 = ' ' THEN 
               LET g_pia10 = 1
             END IF
 
             LET l_pia.pia01 = g_pia[l_ac].pia01
             LET l_pia.pia02 = g_pia[l_ac].pia02
             LET l_pia.pia03 = g_pia[l_ac].pia03
             LET l_pia.pia04 = g_pia[l_ac].pia04
             LET l_pia.pia05 = g_pia[l_ac].pia05
             LET l_pia.pia06 = g_pia[l_ac].pia06
             LET l_pia.pia07 = g_pia[l_ac].pia07
             LET l_pia.pia08 = g_pia08
             LET l_pia.pia09 = g_pia[l_ac].pia09
             LET l_pia.pia10 = g_pia10
             LET l_pia.pia13 = g_today
             LET l_pia.pia16 = g_pia[l_ac].pia16
             LET l_pia.pia19 = g_pia[l_ac].pia19
             LET l_pia.pia66 = g_pia66
             LET l_pia.pia67 = g_pia67
             LET l_pia.pia68 = g_pia68
             LET l_pia.pia931 = g_pia[l_ac].pia931  #CHI-C30068
             LET l_pia.pia70 = g_pia[l_ac].pia70    #FUN-CB0087
 
             IF l_pia.pia03 IS NULL THEN LET l_pia.pia03 = ' ' END IF
             IF l_pia.pia04 IS NULL THEN LET l_pia.pia04 = ' ' END IF
             IF l_pia.pia05 IS NULL THEN LET l_pia.pia05 = ' ' END IF
             IF g_argv1 = '1' THEN 
                 LET l_pia.pia30 = g_pia[l_ac].qty
                 LET l_pia.pia31 = g_user
                 LET l_pia.pia32 = g_today
                 LET l_pia.pia33 = TIME  
                 LET l_pia.pia34 = g_pia[l_ac].peo
                #LET l_pia.pia35 = g_pia[l_ac].tagdate    #CHI-B40010 mark
                 LET l_pia.pia35 = g_pia[l_ac].pia35      #CHI-B40010 add
             ELSE 
                 LET l_pia.pia40 = g_pia[l_ac].qty
                 LET l_pia.pia41 = g_user
                 LET l_pia.pia42 = g_today
                 LET l_pia.pia43 = TIME
                 LET l_pia.pia44 = g_pia[l_ac].peo
                #LET l_pia.pia45 = g_pia[l_ac].tagdate    #CHI-B40010 mark
                 LET l_pia.pia45 = g_pia[l_ac].pia35      #CHI-B40010 add 
             END IF
             #FUN-CB0087---add---str---
             IF NOT t820_pia70_check() THEN
#               ROLLBACK WORK                    #TQC-D10103 mark
                NEXT FIELD pia70
             END IF 
             #FUN-CB0087---add---end---
            #MOD-CC0235---add---S
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM pia_file
              WHERE pia01 != g_pia[l_ac].pia01
                AND pia02  = g_pia[l_ac].pia02
                AND pia03  = g_pia[l_ac].pia03
                AND pia04  = g_pia[l_ac].pia04
                AND pia05  = g_pia[l_ac].pia05
                AND pia19 != 'Y'
             
             IF l_n > 0 THEN 
                 CALL cl_err(g_pia[l_ac].pia05,'mfg0131',1)
                 ROLLBACK WORK 
                 NEXT FIELD pia02
             END IF
            #MOD-CC0235---add---E
             UPDATE pia_file SET pia_file.* = l_pia.*    # 更新DB
                 WHERE pia01  = g_pia_t.pia01
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pia_file",g_pia_t.pia01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
                 LET g_pia[l_ac].* = g_pia_t.*
             ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
             END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()            # 新增
         LET l_ac_t = l_ac                # 新增
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_pia[l_ac].* = g_pia_t.*
            END IF
            CLOSE t820_bcl            # 新增
            ROLLBACK WORK         # 新增
            EXIT INPUT
        #MOD-CC0235---add---S
         ELSE
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM pia_file
             WHERE pia01 != g_pia[l_ac].pia01
               AND pia02  = g_pia[l_ac].pia02
               AND pia03  = g_pia[l_ac].pia03
               AND pia04  = g_pia[l_ac].pia04
               AND pia05  = g_pia[l_ac].pia05
               AND pia19 != 'Y'
            
            IF l_n > 0 AND g_pia[l_ac].pia19 = 'N' THEN      #TQC-D10103 add pia19
                CALL cl_err(g_pia[l_ac].pia05,'mfg0131',0)
                NEXT FIELD pia02
            END IF
        #MOD-CC0235---add---E
         END IF
         #FUN-CB0087---add---str---
         IF NOT t820_pia70_check() AND g_pia[l_ac].pia19 = 'N'THEN #TQC-D10103 add pia19
#           ROLLBACK WORK             #TQC-D10103 mark
            NEXT FIELD pia70
         END IF 
         #FUN-CB0087---add---end---
     
         CLOSE t820_bcl            # 新增
         COMMIT WORK
    
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
 
  END INPUT
  CLOSE t820_bcl
  COMMIT WORK
END FUNCTION

FUNCTION t820_mul_unit(p_flag)
  DEFINE p_flag    LIKE type_file.chr1   #'Y/N'是否update pia_file #FUN-5B0137  #No.FUN-690026 VARCHAR(1)
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima25   LIKE ima_file.ima25   #NO.MOD-610112 add
  DEFINE l_pia10   LIKE pia_file.pia10   #NO.MOD-610112 add
  DEFINE l_pia30   LIKE pia_file.pia30   #FUN-6B0019
  DEFINE l_pia40   LIKE pia_file.pia40   #FUN-6B0019

    SELECT ima25 INTO l_ima25 FROM pia_file,ima_file
       WHERE pia01=g_pia[l_ac].pia01 AND ima01=pia02   #FUN-6B0019
    CALL s_umfchk(g_pia[l_ac].pia02,l_ima25,g_pia[l_ac].pia09)     #FUN-6B0019
         RETURNING g_cnt,l_pia10
    IF g_cnt THEN
       LET l_pia10=1
    END IF
    IF cl_null(g_pia[l_ac].pia01) THEN RETURN END IF    #FUN-6B0019
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_pia[l_ac].pia02 #FUN-6B0019
    IF (l_ima906 = '2') OR (l_ima906='3') THEN #FUN-5B0137
       IF g_argv1='1' THEN
          SELECT SUM(piaa30*piaa10) INTO l_pia30 FROM piaa_file     
           WHERE piaa01=g_pia[l_ac].pia01
             AND piaa02=g_pia[l_ac].pia02
             AND piaa03=g_pia[l_ac].pia03
             AND piaa04=g_pia[l_ac].pia04
             AND piaa05=g_pia[l_ac].pia05
             AND piaa30 IS NOT NULL
             AND piaa10 IS NOT NULL
          LET l_pia30 = l_pia30*l_pia10    
          LET l_pia30=s_digqty(l_pia30,g_pia[l_ac].pia09)    #No.FUN-BB0086 add
 
          IF p_flag='Y' OR p_flag='y' THEN #FUN-5B0137
             UPDATE pia_file SET pia30=l_pia30           
              WHERE pia01=g_pia[l_ac].pia01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pia_file",g_pia[l_ac].pia01,"",SQLCA.sqlcode,"",  #FUN-6B0019
                             "update pia",1)   #NO.FUN-640266
             END IF
          END IF
          LET g_pia[l_ac].qty=l_pia30    #FUN-6B0019
       ELSE
          SELECT SUM(piaa40*piaa10) INTO l_pia40 FROM piaa_file
           WHERE piaa01=g_pia[l_ac].pia01
             AND piaa02=g_pia[l_ac].pia02
             AND piaa03=g_pia[l_ac].pia03
             AND piaa04=g_pia[l_ac].pia04
             AND piaa05=g_pia[l_ac].pia05
             AND piaa40 IS NOT NULL
             AND piaa10 IS NOT NULL
          LET l_pia40 = l_pia40*l_pia10   
          LET l_pia40=s_digqty(l_pia40,g_pia[l_ac].pia09)    #No.FUN-BB0086 add
          IF p_flag='Y' OR p_flag='y' THEN #FUN-5B0137
             UPDATE pia_file SET pia40=l_pia40
              WHERE pia01=g_pia[l_ac].pia01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pia_file",g_pia[l_ac].pia01,"",SQLCA.sqlcode,"",     #FUN-6B0019
                             "update pia",1)   #NO.FUN-640266
             END IF
          END IF
          LET g_pia[l_ac].qty=l_pia40    #FUN-6B0019
       END IF
    END IF
    DISPLAY BY NAME g_pia[l_ac].qty   #FUN-6B0019
END FUNCTION
 
FUNCTION t820_add_img(p_pia02,p_pia03,p_pia04,p_pia05,p_day)
   DEFINE p_pia02 LIKE pia_file.pia02,                                                                                              
          p_pia03 LIKE pia_file.pia03,                                                                                              
          p_pia04 LIKE pia_file.pia04,                                                                                              
          p_pia05 LIKE pia_file.pia05,                                                                                              
          p_day   LIKE type_file.dat                                                                                                
                                                                                                                                    
   SELECT img09,img10 FROM img_file                                                                            
    WHERE img01=p_pia02 AND img02=p_pia03                                                                       
      AND img03=p_pia04 AND img04=p_pia05                                                                       
   IF STATUS = 100 THEN                                                                                                             
      IF g_sma.sma892[3,3] = 'Y' THEN                                                                                               
         IF NOT cl_confirm('mfg1401') THEN                                                                                          
            RETURN FALSE                                                                                                            
         END IF                                                                                                                     
      END IF                                                                                                                        
      CALL s_add_img(p_pia02,p_pia03,                                                                           
                     p_pia04,p_pia05,                                                                           
                     '','',g_today)                                                                           
      IF g_errno='N' THEN
         RETURN FALSE                                                                                                               
      END IF                                                                                                                        
   END IF                                                                                                                           
   RETURN TRUE                                                                                                                      
END FUNCTION 
#No.FUN-9C0072 精簡程式碼

#No.FUN-BB0086--add--start--
FUNCTION t820_qty_check(l_cnt1)
DEFINE l_cnt1          LIKE type_file.num5
DEFINE l_ima918        LIKE ima_file.ima918   #MOD-C60184
DEFINE l_ima921        LIKE ima_file.ima921   #MOD-C60184
   IF NOT cl_null(g_pia[l_ac].qty) AND NOT cl_null(g_pia[l_ac].pia09) THEN
      IF cl_null(g_pia_t.qty) OR cl_null(g_pia09_t) OR g_pia_t.qty != g_pia[l_ac].qty OR g_pia09_t != g_pia[l_ac].pia09 THEN
         LET g_pia[l_ac].qty=s_digqty(g_pia[l_ac].qty,g_pia[l_ac].pia09)
         DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
      END IF
   END IF

   IF NOT cl_null(g_pia[l_ac].qty) THEN
      IF g_pia[l_ac].qty < 0 THEN 
         LET g_pia[l_ac].qty = g_pia_t.qty
         RETURN FALSE 
      END IF 
      IF g_pia[l_ac].qty != g_pia_t.qty OR g_pia_t.qty IS NULL THEN
         #MOD-C60184---begin
         IF g_pia[l_ac].pia16 ='Y' THEN
            LET l_ima918 = 'N'
            LET l_ima921 = 'N'
            SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
             WHERE ima01=g_pia[l_ac].pia02
            IF l_ima918 = 'Y' OR l_ima921 ='Y' THEN
               CALL s_lotcheck(g_pia[l_ac].pia01,
                               g_pia[l_ac].pia02,
                               g_pia[l_ac].pia03,
                               g_pia[l_ac].pia04,
                               g_pia[l_ac].pia05,        
                               g_pia[l_ac].qty,'SET')   
                      RETURNING l_y,l_qty 
            END IF 
         ELSE 
         #MOD-C60184---end
            LET l_cnt1=0
            SELECT COUNT(*) INTO l_cnt1 FROM pias_file
             WHERE pias01=g_pia[l_ac].pia01
            IF l_cnt1 > 0 THEN
            CALL s_lotcheck(g_pia[l_ac].pia01,
                            g_pia[l_ac].pia02,
                            g_pia[l_ac].pia03,
                            g_pia[l_ac].pia04,
                            g_pia[l_ac].pia05,        
                            g_pia[l_ac].qty,'SET')   
                 RETURNING l_y,l_qty  
            END IF           #No.MOD-940074 add
         #FUN-B70032 --START--
         END IF  #MOD-C60184
         IF s_industry('icd') THEN 
            LET l_cnt1=0
            SELECT COUNT(*) INTO l_cnt1 FROM piad_file
             WHERE piad01=g_pia[l_ac].pia01
            IF l_cnt1 > 0 THEN
               CALL s_icdcount(g_pia[l_ac].pia01,
                               g_pia[l_ac].pia02,
                               g_pia[l_ac].pia03,
                               g_pia[l_ac].pia04,
                               g_pia[l_ac].pia05,        
                               g_pia[l_ac].qty,'SET')   
                RETURNING l_y,l_qty 
                IF l_qty <=0 THEN
                   LET g_pia[l_ac].icdcnt = '1' 
                ELSE
                   LET g_pia[l_ac].icdcnt = '0' 
      END IF
                DISPLAY BY NAME g_pia[l_ac].icdcnt
            END IF
         END IF    
         #FUN-B70032 --END--
      END IF
      IF l_y = 'Y' THEN   
         LET g_pia[l_ac].qty = l_qty
         LET g_pia_t.qty =g_pia[l_ac].qty #FUN-B70032
         DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
      END IF
   END IF 
   RETURN TRUE 
END FUNCTION 
#No.FUN-BB0086--add--end--

#FUN-CB0087---add---str---
FUNCTION t820_pia70_check()   #理由碼
DEFINE
    l_n       LIKE type_file.num5,    #FUN-CB0087
    l_sql     STRING,                 #FUN-CB0087
    l_where   STRING,                 #FUN-CB0087          
    l_flag    LIKE type_file.chr1     #FUN-CB0087 

    LET l_flag = FALSE
    CALL s_get_where(g_pia[l_ac].pia01,'','',g_pia[l_ac].pia02,g_pia[l_ac].pia03,
#                            g_pia[l_ac].gen02,g_pia[l_ac].gem02) RETURNING l_flag,l_where  #TQC-D10103 mark
                             g_pia[l_ac].peo,'') RETURNING l_flag,l_where  #TQC-D10103 add
    IF NOT cl_null(g_pia[l_ac].pia70) THEN 
       LET l_n = 0
       IF g_aza.aza115='Y' AND l_flag THEN
          LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pia[l_ac].pia70,"' AND ",l_where
          PREPARE ggc08_pre2 FROM l_sql
          EXECUTE ggc08_pre2 INTO l_n
          IF l_n < 1 THEN 
             CALL cl_err(g_pia[l_ac].pia70,'aim-425',1)
             RETURN FALSE 
          END IF
       ELSE
          SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_pia[l_ac].pia70 AND azf02='2'
          IF l_n < 1 THEN
             CALL cl_err(g_pia[l_ac].pia70,'aim-425',1)
             RETURN FALSE
          END IF
       END IF
       #TQC-D20042---add---str---
    ELSE
       CALL t820_azf03_desc()
      #TQC-D20042---add---end---
    END IF
RETURN TRUE
END FUNCTION 
#FUN-CB0087---add---end---

#TQC-D20042---add---str---
FUNCTION t820_azf03_desc()
   IF NOT cl_null(g_pia[l_ac].pia70) THEN  
      SELECT azf03 INTO g_pia[l_ac].azf03 FROM azf_file WHERE azf01=g_pia[l_ac].pia70 AND azf02='2'
      DISPLAY BY NAME g_pia[l_ac].azf03 
   ELSE
      LET g_pia[l_ac].azf03 = ' '
      DISPLAY BY NAME g_pia[l_ac].azf03
   END IF
END FUNCTION
#TQC-D20042---add---end---
