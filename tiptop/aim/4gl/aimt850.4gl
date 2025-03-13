# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt850.4gl
# Descriptions...: 複盤點維護作業－現有庫存
# Date & Author..: 93/05/28 By Apple
# NOTE...........: 本程式的設計必須考慮使用者的操作輸入為主
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-570082 05/07/18 By Carrier 多單位內容修改
# Modify.........: No.FUN-570030 05/07/04 By kim 快速輸入第一筆取消+1
# Modify.........: No.FUN-5B0137 05/11/29 By kim 增加 參考單位 ima906='3' 時 同 ima906='2' 時 處理
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/28 By Carrier 會計科目加帳套
# Modify.........: No.FUN-6B0019 07/04/27 By rainy 將程式改為單檔多欄處理
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改程序中有'(+)'的語法
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-860001 08/06/02 By Sherry 批序號-盤點
# Modify.........: No.MOD-860285 08/06/24 By claire g_pia08需先給值
# Modify.........: No.CHI-8A0008 08/10/28 By jan 改復盤人員欄位不可為空
# Modify.........: No.MOD-8B0288 08/11/27 By sherry 在復盤的時候，不應該將pia10進行清空 
# Modify.........: No.FUN-8A0147 08/12/08 By douzh 批序號-盤點調整參數傳入邏輯
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930121 09/03/10 By zhaijie新增查詢字段pia931-底稿類型
# Modify.........: No.MOD-940074 09/05/25 By Pengu 只有需要做批序號的料件才需要呼叫s_lotcheck
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.TQC-A70018 10/07/05 By Carrier 加before display
# Modify.........: No.TQC-AA0119 10/10/22 By houlia 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/11/02 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B70032 11/08/12 By jason 刻號/BIN盤點
# Modify.........: No:CHI-B40016 11/11/23 By Vampire 多加"規格"欄位
# Modify.........: No:MOD-B80139 11/11/23 By Vampire (1)點進單身後，倉庫欄位會變成顯示在規格欄位
#                                                    (2)規格欄位不應該可以被修改
#                                                    (3)AFTER FIELD pia02 品名規格沒有資料
# Modify.........: No:FUN-BB0086 11/12/12 By tanxc 增加數量欄位小數取位 
# Modify.........: No:MOD-C30542 12/03/12 By xujing 处理AFTER FIELD peo 非空控管
# Modify.........: No:MOD-C30696 12/03/15 By xujing 修改t850_b_fill()抓資料sql條件
# Modify.........: No:TQC-C60221 12/06/26 By fengrui 使用多單位時按條件開啟aimt852、aimt853
# Modify.........: No:TQC-C70007 12/07/02 By fengrui 欄位跳轉添加判斷避免死循環
# Modify.........: No.FUN-CB0087 12/12/19 By xianghui 庫存理由碼改善
# Modify.........: No:MOD-CC0235 13/01/09 By Elise AFTER ROW增加料倉儲批控卡
# Modify.........: No:MOD-CC0192 13/01/11 By Elise after field 倉庫/儲位新舊值的if判斷拿掉
# Modify.........: No.TQC-D10103 13/01/30 By xianghui 處理庫存理由碼改善的一些問題
# Modify.........: No.TQC-D20042 13/02/25 By xianghui 理由碼調整


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pia    DYNAMIC  ARRAY OF  RECORD 
            pia01     LIKE  pia_file.pia01,
            pia02     LIKE  pia_file.pia02,
            ima02     LIKE  ima_file.ima02,
            ima021    LIKE  ima_file.ima021,     #CHI-B40016 add
            pia03     LIKE  pia_file.pia03,
            pia04     LIKE  pia_file.pia04,
            pia05     LIKE  pia_file.pia05,
            pia06     LIKE  pia_file.pia06,
            pia09     LIKE  pia_file.pia09,
            pia07     LIKE  pia_file.pia07,
            qty1      LIKE  pia_file.pia50,
            peo1      LIKE  pia_file.pia64,
            gen02_1   LIKE  gen_file.gen02,
            tagdate1  LIKE  pia_file.pia65,
            qty       LIKE  pia_file.pia50,
            peo       LIKE  pia_file.pia64,
            gen02_2   LIKE  gen_file.gen02,
            tagdate   LIKE  pia_file.pia65,
            pia930    LIKE  pia_file.pia930,
            gem02     LIKE  gem_file.gem02, 
            pia931    LIKE  pia_file.pia931,       #FUN-930121 add pia931
            pia70     LIKE  pia_file.pia70,        #FUN-CB0087
            azf03     LIKE  azf_file.azf03         #FUN-CB0087
                         END RECORD,
    g_pia_t              RECORD 
            pia01     LIKE  pia_file.pia01,
            pia02     LIKE  pia_file.pia02,
            ima02     LIKE  ima_file.ima02,
            ima021    LIKE  ima_file.ima021,     #CHI-B40016 add
            pia03     LIKE  pia_file.pia03,
            pia04     LIKE  pia_file.pia04,
            pia05     LIKE  pia_file.pia05,
            pia06     LIKE  pia_file.pia06,
            pia09     LIKE  pia_file.pia09,
            pia07     LIKE  pia_file.pia07,
            qty1      LIKE  pia_file.pia50,
            peo1      LIKE  pia_file.pia64,
            gen02_1   LIKE  gen_file.gen02,
            tagdate1  LIKE  pia_file.pia65,
            qty       LIKE  pia_file.pia50,
            peo       LIKE  pia_file.pia64,
            gen02_2   LIKE  gen_file.gen02,
            tagdate   LIKE  pia_file.pia65,
            pia930    LIKE  pia_file.pia930,
            gem02     LIKE  gem_file.gem02, 
            pia931    LIKE  pia_file.pia931,       #FUN-930121 add pia931
            pia70     LIKE  pia_file.pia70,        #FUN-CB0087
            azf03     LIKE  azf_file.azf03         #FUN-CB0087
                         END RECORD,
    g_pia_o             RECORD 
            pia01     LIKE  pia_file.pia01,
            pia02     LIKE  pia_file.pia02,
            ima02     LIKE  ima_file.ima02,
            ima021    LIKE  ima_file.ima021,     #CHI-B40016 add
            pia03     LIKE  pia_file.pia03,
            pia04     LIKE  pia_file.pia04,
            pia05     LIKE  pia_file.pia05,
            pia06     LIKE  pia_file.pia06,
            pia09     LIKE  pia_file.pia09,
            pia07     LIKE  pia_file.pia07,
            qty1      LIKE  pia_file.pia50,
            peo1      LIKE  pia_file.pia64,
            gen02_1   LIKE  gen_file.gen02,
            tagdate1  LIKE  pia_file.pia65,
            qty       LIKE  pia_file.pia50,
            peo       LIKE  pia_file.pia64,
            gen02_2   LIKE  gen_file.gen02,
            tagdate   LIKE  pia_file.pia65,
            pia930    LIKE  pia_file.pia930,
            gem02     LIKE  gem_file.gem02, 
            pia931    LIKE  pia_file.pia931,       #FUN-930121 add pia931
            pia70     LIKE  pia_file.pia70,        #FUN-CB0087
            azf03     LIKE  azf_file.azf03         #FUN-CB0087
                        END RECORD,
    g_pia08           LIKE  pia_file.pia08,
    g_pia10           LIKE  pia_file.pia10,    
    g_pia16           LIKE  pia_file.pia16,    
    g_pia19           LIKE  pia_file.pia19,    
    g_pia66           LIKE  pia_file.pia66,
    g_pia67           LIKE  pia_file.pia67,
    g_pia68           LIKE  pia_file.pia68,
   
    g_pia01_t           LIKE pia_file.pia01,
    g_peo,g_peo2        LIKE pia_file.pia64,
    g_peo_t,g_peo_o     LIKE pia_file.pia64,
    g_tagdate           LIKE pia_file.pia65,
    g_tagdate_o         LIKE pia_file.pia65,
    g_tagdate_t         LIKE pia_file.pia65,
    g_wc,g_sql          string,                 #No.FUN-580092 HCN
    g_qty               LIKE pia_file.pia50,
    g_argv1             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_ima906            LIKE ima_file.ima906,   #No.FUN-570082
    g_ima25             LIKE ima_file.ima25
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
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
       LET g_prog='aimt850'
    ELSE 
       LET g_prog='aimt851'
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
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW t850_w AT p_row,p_col WITH FORM "aim/42f/aimt850" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    #2004/06/02共用程式時呼叫
    CALL cl_set_locale_frm_name("aimt850")
    CALL cl_ui_init()
    CALL cl_set_comp_visible("pia930,gem02",g_aaz.aaz90='Y')  #FUN-670093
    
    #FUN_B70032 --START--
    IF s_industry('icd') THEN
       CALL cl_set_act_visible("icdcheck,icd_checking",TRUE)
    ELSE
       CALL cl_set_act_visible("icdcheck,icd_checking",FALSE)
    END if 
    #FUN_B70032 --END--
    IF g_aza.aza115 ='Y' THEN                    #FUN-CB0087
       CALL cl_set_comp_required('pia70',TRUE)   #FUN-CB0087
    END IF                                       #FUN-CB0087
    
    WHILE TRUE
      LET g_action_choice=""
    CALL t850_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t850_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
 
 
FUNCTION t850_menu()
 
  WHILE TRUE
    CALL t850_bp("G")
    CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t850_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t850_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "multi_unit_taking"
           IF g_rec_b <= 0 THEN RETURN END IF
            IF g_argv1='1' THEN
               LET g_sql = "aimt852"," '",g_pia[l_ac].pia01 CLIPPED,"'"
            ELSE
               LET g_sql = "aimt853"," '",g_pia[l_ac].pia01 CLIPPED,"'"
            END IF
            CALL cl_cmdrun_wait(g_sql)
            CALL t850_mul_unit('Y')
 
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
 
        WHEN "related_document"  
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
 
 
FUNCTION  t850_bp(p_ud)
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
  DISPLAY ARRAY g_pia TO s_pia.* ATTRIBUTE(COUNT=g_rec_b)
 
     #No.TQC-A70018  --Begin
     BEFORE DISPLAY
        CALL cl_show_fld_cont()      
     #No.TQC-A70018  --End  

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
        LET l_ac = 1                      #FUN-AA0059
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
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION
 
 
FUNCTION t850_b_fill(p_wc2)
  DEFINE p_wc2  STRING     #NO.FUN-910082
  DEFINE l_pia  RECORD LIKE pia_file.*
 
 
  IF g_argv1 = '1' THEN
     LET g_sql= "SELECT pia01,pia02,ima02,ima021,",     #CHI-B40016 add ima021
                "       pia03,pia04,pia05,pia06,",
                "       pia09,pia07,pia30,pia34,e.gen02,pia35,",
                "       pia50,pia54,g.gen02,pia55,",
                "       pia930,gem02,pia931,pia70,azf03",                     #FUN-930121 add pia931 #FUN-CB0087 add pia70,azf03
                "  FROM pia_file,OUTER ima_file,OUTER gen_file e,OUTER gem_file,OUTER gen_file g ",#No.TQC-780054
                "        ,OUTER azf_file f ",    #FUN-CB0087
                "  WHERE pia_file.pia02 = ima_file.ima01 ",                          #No.TQC-780054
                "    AND pia_file.pia34 = e.gen01 ",                                 #No.TQC-780054
                "    AND pia_file.pia54 = g.gen01 ",                                 #No.TQC-780054
                "    AND pia_file.pia930 = gem_file.gem01 ",                         #No.TQC-780054
                "    AND pia_file.pia70 = f.azf01 ",                                 #FUN-CB0087
                "    AND f.azf02 = '2' ",       #TQC-D10103
                "    AND ", p_wc2 CLIPPED,
                "  ORDER BY pia01"
  ELSE
     LET g_sql= "SELECT pia01,pia02,ima02,ima021,",     #CHI-B40016 add ima021
                "       pia03,pia04,pia05,pia06,",
                "       pia09,pia07,pia40,pia44,e.gen02,pia45,",
                "       pia60,pia64,g.gen02,pia65,",
                "       pia930,gem02,pia931,pia70,azf03",                 #FUN-930121 add pia931 #FUN-CB0087 add pia70,azf03
                "  FROM pia_file,OUTER ima_file,OUTER gen_file e,OUTER gem_file,OUTER gen_file g ",#No.TQC-780054
                "        ,OUTER azf_file f ",    #FUN-CB0087
                "  WHERE pia_file.pia02 = ima_file.ima01 ",                          #No.TQC-780054
     #          "    AND pia_file.pia34 = e.gen01 ",                                 #No.TQC-780054     #MOD-C30696 mark
     #          "    AND pia_file.pia54 = g.gen01 ",                                 #No.TQC-780054     #MOD-C30696 mark
                "    AND pia_file.pia44 = e.gen01 ",                                 #MOD-C30696 add
                "    AND pia_file.pia64 = g.gen01 ",                                 #MOD-C30696 add
                "    AND pia_file.pia930 = gem_file.gem01 ",                         #No.TQC-780054
                "    AND pia_file.pia70 = f.azf01 ",                                 #FUN-CB0087
                "    AND f.azf02 = '2' ",       #TQC-D10103
                "    AND ", p_wc2 CLIPPED,
                "  ORDER BY pia01"
  END IF
  PREPARE t850_prepare FROM g_sql
  DECLARE t850_curs CURSOR FOR t850_prepare
        
 
   CALL g_pia.clear()
   LET g_cnt = 1
   FOREACH t850_curs INTO g_pia[g_cnt].*  #單身 ARRAY 填充
      IF STATUS THEN
           CALL cl_err('FOREACH:',STATUS,1)
           EXIT FOREACH
      END IF
 
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
 
 
FUNCTION t850_pia01(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_imaacti    LIKE ima_file.imaacti,
           l_ima021     LIKE ima_file.ima021   #CHI-B40016 add
    DEFINE l_pia  RECORD LIKE pia_file.*     #FUN-6B0019 
    LET g_errno = ' '
 
    SELECT pia_file.*,ima02,ima021,ima25,imaacti           #CHI-B40016 add ima021 
      INTO l_pia.*, l_ima02,l_ima021,g_ima25,l_imaacti     #CHI-B40016 add l_ima021
      FROM pia_file, OUTER ima_file
      WHERE pia01 = g_pia[l_ac].pia01 AND pia_file_pia02 = ima_file.ima01    
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002' 
               LET g_pia[l_ac].pia02  = NULL 
              LET g_pia[l_ac].pia03 = NULL LET g_pia[l_ac].pia04 = NULL
              LET g_pia[l_ac].pia05 = NULL LET g_pia[l_ac].pia06 = NULL 
              LET g_pia[l_ac].pia07 = NULL LET g_pia[l_ac].pia09 = NULL  
              LET l_ima02     = NULL LET l_imaacti   = NULL
              LET l_ima021    = NULL                           #CHI-B40016 add
    	WHEN l_imaacti='N' LET g_errno = '9028' 
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
	OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
    LET g_pia_t.* = g_pia[l_ac].*   #FUN-6B0019
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pia[l_ac].pia02,g_pia[l_ac].pia03,g_pia[l_ac].pia04,
                       g_pia[l_ac].pia05,g_pia[l_ac].pia06,g_pia[l_ac].pia07,
                       g_pia[l_ac].pia09,g_pia[l_ac].pia930,g_pia[l_ac].pia931   #FUN-930121 add pia931 
       LET g_pia[l_ac].ima02 = l_ima02 
       LET g_pia[l_ac].ima021 = l_ima021           #CHI-B40016 add
       LET g_pia[l_ac].gem02 = s_costcenter_desc(g_pia[l_ac].pia930) 
       DISPLAY BY NAME g_pia[l_ac].ima02,g_pia[l_ac].gem02
       DISPLAY BY NAME g_pia[l_ac].ima021                     #CHI-B40016 add
       IF g_argv1 = '1' THEN 
 
          LET g_pia[l_ac].qty1     = l_pia.pia30
          LET g_pia[l_ac].peo1     = l_pia.pia34
          LET g_pia[l_ac].tagdate1 = l_pia.pia35
          LET g_pia[l_ac].qty     = l_pia.pia50
          LET g_pia[l_ac].peo     = l_pia.pia54
          LET g_pia[l_ac].tagdate = l_pia.pia55
          IF g_pia[l_ac].tagdate IS NULL OR g_pia[l_ac].tagdate = ' ' THEN
            LET g_pia[l_ac].tagdate = g_today
          END IF
          IF g_pia[l_ac].peo IS NULL OR g_pia[l_ac].peo = '' 
          THEN LET g_pia[l_ac].peo = g_pia_o.peo 
          END IF
          DISPLAY BY NAME g_pia[l_ac].qty 
          DISPLAY BY NAME g_pia[l_ac].peo  
          DISPLAY BY NAME g_pia[l_ac].tagdate 
          DISPLAY BY NAME g_pia[l_ac].qty1 
          DISPLAY BY NAME g_pia[l_ac].tagdate1
          DISPLAY BY NAME g_pia[l_ac].peo1
          LET g_peo2 = l_pia.pia34
       ELSE 
          LET g_pia[l_ac].qty1     = l_pia.pia40
          LET g_pia[l_ac].peo1     = l_pia.pia44
          LET g_pia[l_ac].tagdate1 = l_pia.pia45
          LET g_pia[l_ac].qty     = l_pia.pia60
          LET g_pia[l_ac].peo     = l_pia.pia64
          LET g_pia[l_ac].tagdate = l_pia.pia65
          IF g_pia[l_ac].tagdate IS NULL OR g_pia[l_ac].tagdate = ' ' THEN
            LET g_pia[l_ac].tagdate = g_today
          END IF
          IF g_pia[l_ac].peo IS NULL OR g_pia[l_ac].peo = '' 
          THEN LET g_pia[l_ac].peo = g_pia_o.peo 
          END IF
          DISPLAY BY NAME g_pia[l_ac].qty 
          DISPLAY BY NAME g_pia[l_ac].peo  
          DISPLAY BY NAME g_pia[l_ac].tagdate 
          DISPLAY BY NAME g_pia[l_ac].qty1 
          DISPLAY BY NAME g_pia[l_ac].tagdate1
          DISPLAY BY NAME g_pia[l_ac].peo1
          LET g_peo2 = l_pia.pia44
       END IF
       IF g_pia[l_ac].peo IS NOT NULL AND g_pia[l_ac].peo != ' ' THEN 
          CALL t850_peo('d','2',g_pia[l_ac].peo)
       END IF
       IF g_pia[l_ac].peo1 IS NOT NULL AND g_pia[l_ac].peo1 != ' ' THEN 
          CALL t850_peo('d','1',g_pia[l_ac].peo1)
       END IF
    END IF
END FUNCTION
   
FUNCTION t850_pia02(p_cmd)  #料件編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,     #CHI-B40016 add
           l_ima08      LIKE ima_file.ima08,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
	LET l_ima02=' '
    LET l_ima021=' '        #CHI-B40016 add
    SELECT ima02,ima021,ima08,ima25,imaacti           #CHI-B40016 add ima021
      INTO l_ima02,l_ima021,l_ima08,g_ima25,l_imaacti #CHI-B40016 add l_ima021
      FROM ima_file WHERE ima01 = g_pia[l_ac].pia02   #FUN-6B0019
    CASE 
      WHEN SQLCA.SQLCODE = 100 
         LET g_errno = 'mfg0002' 
         LET l_ima02 = NULL 
         LET l_ima021 = NULL          #CHI-B40016 add
      WHEN l_imaacti='N' LET g_errno = '9028' 
       WHEN l_imaacti MATCHES '[PH]'      
         LET g_errno = '9038'
	OTHERWISE          
          LET g_errno = SQLCA.SQLCODE USING '-------' 
    END CASE
    IF g_pia66 IS NULL OR g_pia66 = ' ' THEN            #FUN-6B0019
       CALL s_cost('1',l_ima08,g_pia[l_ac].pia02) RETURNING g_pia66   #FUN-6B0019
    END IF
    IF g_pia67 IS NULL OR g_pia67 = ' ' THEN             #FUN-6B0019
       CALL s_cost('2',l_ima08,g_pia[l_ac].pia02) RETURNING g_pia67    #FUN-6B0019
    END IF
    IF g_pia68 IS NULL OR g_pia68 = ' ' THEN              #FUN-6B0019
       CALL s_cost('3',l_ima08,g_pia[l_ac].pia02) RETURNING g_pia68    #FUN-6B0019
    END IF
    IF g_pia08 IS NULL OR g_pia08 = ' '              #FUN-6B0019
    THEN LET g_pia08 = 0                             #FUN-6B0019
    END IF
    LET g_pia[l_ac].ima02 = l_ima02           #MOD-B80139 add
    LET g_pia[l_ac].ima021 = l_ima021         #MOD-B80139 add
    IF p_cmd = 'a' THEN LET g_pia[l_ac].pia09 = g_ima25 END IF   #FUN-6B0019
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       #DISPLAY l_ima02 TO FORMONLY.ima02                       #MOD-B80139 mark
       DISPLAY BY NAME g_pia[l_ac].ima02,g_pia[l_ac].ima02      #MOD-B80139 add
       DISPLAY BY NAME g_pia[l_ac].pia09      #FUN-6B0019    
    END IF
END FUNCTION
 
 
#檢查單位是否存在於單位檔中
FUNCTION t850_unit(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gfe02      LIKE gfe_file.gfe02,
           l_gfeacti    LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = g_pia[l_ac].pia09    #FUN-6B0019
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
   
#盤點人員
FUNCTION t850_peo(p_cmd,p_code,p_peo)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_code       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_peo        LIKE gen_file.gen01,
           l_gen02      LIKE gen_file.gen02,
           l_genacti    LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = p_peo
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       IF p_code = '1' THEN 
            LET g_pia[l_ac].gen02_1 = l_gen02 
       ELSE LET g_pia[l_ac].gen02_2 = l_gen02 
       END IF
    END IF
END FUNCTION
 
 
FUNCTION t850_q()
 
    CALL t850_b_askkey()
END FUNCTION
 
 
FUNCTION t850_b_askkey()
DEFINE  l_flag          LIKE type_file.chr1,    #FUN-CB0087
        l_where         STRING                  #FUN-CB0087
  CLEAR FORM
  CALL g_pia.clear()
  CONSTRUCT g_wc2 ON                    # 螢幕上取條件
        pia01, pia02, pia03, pia04, pia05,
        pia06, pia09, pia07, pia930,pia931,pia70    #FUN-930121 add pia931  #FUN-CB0087 add pia70
      FROM 
        s_pia[1].pia01, s_pia[1].pia02, 
        s_pia[1].pia03, s_pia[1].pia04, 
        s_pia[1].pia05, s_pia[1].pia06, s_pia[1].pia09, 
        s_pia[1].pia07, s_pia[1].pia930,s_pia[1].pia931,   #FUN-930121 add pia931  
        s_pia[1].pia70                                     #FUN-CB0087 add pia70
            
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
          WHEN INFIELD(pia931) #查詢底稿類型
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form     ="q_pia931"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia931
            NEXT FIELD pia931
         #FUN-CB0087---add---str---
         WHEN INFIELD(pia70) #理由
            CALL cl_init_qry_var()
            LET g_qryparam.form     ="q_azf41"
            LET g_qryparam.state    = "c"
           #LET g_qryparam.default1 = g_pia[l_ac].pia70   #TQC-D20042
           #CALL cl_create_qry() RETURNING g_pia[l_ac].pia70  #TQC-D20042
           #DISPLAY g_pia[l_ac].pia70 TO pia70                 #TQC-D20042
            CALL cl_create_qry() RETURNING g_qryparam.multiret #TQC-D20042
            DISPLAY g_qryparam.multiret TO pia70               #TQC-D20042
           #CALL t850_azf03()  #TQC-D20042
            NEXT FIELD pia70
         #FUN-CB0087---add---end--- 
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
  CALL t850_b_fill(g_wc2)
END FUNCTION
 
 
FUNCTION t850_b()
  DEFINE
    l_ac_t       LIKE type_file.num5,          #未取消的ARRAY CNT
    l_n          LIKE type_file.num5,          #檢查重複用#No.FU
    l_lock_sw    LIKE type_file.chr1,          #單身鎖住否#No.F
    p_cmd        LIKE type_file.chr1,          #處理狀態#No.FUN
    l_flag       LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1       
  DEFINE l_pia  RECORD LIKE pia_file.*,
         l_pia16    LIKE pia_file.pia16,
         l_pia19    LIKE pia_file.pia19
  DEFINE l_i,l_j    LIKE type_file.num5
  DEFINE l_cnt1     LIKE type_file.num5    #No.MOD-940074 add 
  DEFINE l_tf       LIKE type_file.chr1    #No.FUN-BB0086  
  DEFINE l_where    STRING,                 #FUN-CB0087
         l_sql      STRING                  #FUN-CB0087
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
#   LET l_allow_insert = TRUE                   #FUN-930121   #TQC-AA0119
    LET l_allow_insert = FALSE                  #TQC-AA0119    沒有新增功能，所以為false
    LET l_allow_delete = TRUE                   #FUN-930121
 
    #LET g_forupd_sql = "SELECT pia01,pia02,'',pia03,pia04,pia05,pia06,pia09,pia07,",      #MOD-B80139 mark
    LET g_forupd_sql = "SELECT pia01,pia02,'','',pia03,pia04,pia05,pia06,pia09,pia07,",    #MOD-B80139 add
                       "       0,'','','',0,'','','',pia930,'',pia931,pia70,''",      #FUN-930121 add pia931#FUN-CB0087 add pia70,''
                       "  FROM pia_file WHERE pia01 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t850_bcl CURSOR FROM g_forupd_sql      # LOCK CU
 
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
            SELECT pia08,pia19,pia16 INTO g_pia08,g_pia19,g_pia16 FROM pia_file  #TQC-C70007 欄位開啟關閉用到相關變量 
             WHERE pia01 = g_pia[l_ac].pia01                                     #TQC-C70007
            LET g_before_input_done = FALSE
            CALL t850_set_entry(p_cmd)
            CALL t850_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            LET g_pia_t.* = g_pia[l_ac].*  #BACKUP
            LET g_pia_o.* = g_pia[l_ac].*  #BACKUP
            LET g_pia09_t = g_pia[l_ac].pia09   #No.FUN-BB0086
            #SELECT pia08,pia19,pia16 INTO g_pia08,g_pia19,g_pia16 FROM pia_file  #MOD-860285 add g_pia08 #TQC-C70007
            # WHERE pia01 = g_pia[l_ac].pia01                                                             #TQC-C70007
            IF g_pia19 = 'Y' THEN  #已過帳，不可更改
              CALL cl_err(g_pia[l_ac].pia01,'mfg0132',1) 
              LET l_j = 0
              FOR l_i = l_ac TO g_rec_b
                SELECT pia19 INTO l_pia19 FROM pia_file
                 WHERE pia01 = g_pia[l_i].pia01
                IF l_pia19 = 'N' THEN
                  LET l_j = l_i
                  EXIT FOR
                END IF
              END FOR
              IF l_j <> 0 THEN
                  LET l_ac = l_j  
                  CALL fgl_set_arr_curr(l_ac)
                  CONTINUE INPUT                #TQC-D10103 
                  SELECT pia08,pia19,pia16 INTO g_pia08,g_pia19,g_pia16 FROM pia_file  #TQC-C70007 add
                   WHERE pia01 = g_pia[l_ac].pia01                                     #TQC-C70007 add
                  LET g_before_input_done = FALSE
                  CALL t850_set_entry(p_cmd)
                  CALL t850_set_no_entry(p_cmd)
                  LET g_before_input_done = TRUE
                  LET g_pia_t.* = g_pia[l_ac].*  #BACKUP
                  LET g_pia_o.* = g_pia[l_ac].*  #BACKUP
              ELSE
                  ROLLBACK WORK
                  EXIT INPUT
              END IF
            END IF
            OPEN t850_bcl USING g_pia_t.pia01
            IF STATUS THEN
               CALL cl_err("OPEN t850_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t850_bcl INTO g_pia[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pia_t.pia01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL t850_pia02('d')
               CALL t850_azf03()      #FUN-CB0087
               CALL t850_peo_show()
               IF cl_null(g_pia[l_ac].peo) THEN 
                 IF l_ac > 1 THEN
                   LET g_pia[l_ac].peo = g_pia[ l_ac-1 ].peo
                   LET g_pia[l_ac].gen02_2 = g_pia[ l_ac-1 ].gen02_2
                 END IF
               END IF
               LET g_pia[l_ac].tagdate = g_today
               DISPLAY BY NAME g_pia[l_ac].peo,g_pia[l_ac].gen02_2,g_pia[l_ac].tagdate
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
 
         LET g_before_input_done = FALSE
         CALL t850_set_entry(p_cmd)
         CALL t850_set_no_entry(p_cmd)
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
           CALL t850_set_entry(p_cmd)
           CALL t850_set_no_entry(p_cmd)
          
           IF l_pia19 ='Y' THEN 
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
           LET l_tf = ""   #No.FUN-BB0086
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
            CALL t850_pia02('a')
            IF NOT cl_null(g_errno)  THEN 
               CALL cl_err(g_pia[l_ac].pia02,g_errno,1)
               LET g_pia[l_ac].pia02 = g_pia_o.pia02
               DISPLAY BY NAME g_pia[l_ac].pia02
               NEXT FIELD pia02
            END IF
            #No.FUN-BB0086--add--begin--
            IF g_sma.sma115='Y' AND g_ima906='2' THEN
               LET g_qty = s_digqty(g_qty,g_pia[l_ac].pia09)
               DISPLAY g_qty TO FORMONLY.qty 
            ELSE
               IF NOT t850_qty_check(l_cnt1) THEN 
                  LET l_tf = FALSE 
               END IF 
            END IF 
            LET g_pia09_t = g_pia[l_ac].pia09
            #No.FUN-BB0086--add--end--
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
          IF NOT l_tf THEN  NEXT FIELD qty END IF #FUN-BB0086 add
 
 
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
           #END IF   #MOD-CC0192 mark
            LET g_pia_o.pia05 = g_pia[l_ac].pia05
 
 
        AFTER FIELD pia09 
           LET l_tf = ""   #No.FUN-BB0086
          IF g_pia[l_ac].pia09 IS NOT NULL OR g_pia[l_ac].pia09 != ' ' THEN
             IF g_pia_o.pia09 IS NULL OR (g_pia[l_ac].pia09 !=g_pia_o.pia09) 
              THEN 
                CALL t850_unit('a') 
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pia[l_ac].pia09,g_errno,1)
                   LET g_pia[l_ac].pia09 = g_pia_o.pia09
                   DISPLAY BY NAME g_pia[l_ac].pia09
                   NEXT FIELD pia09
                END IF
             END IF
             #No.FUN-BB0086--add--start--
             IF g_sma.sma115='Y' AND g_ima906='2' THEN
                LET g_pia[l_ac].qty = s_digqty(g_pia[l_ac].qty,g_pia[l_ac].pia09)
                DISPLAY BY NAME g_pia[l_ac].qty
             ELSE
                CALL t850_qty_check(l_cnt1) RETURNING l_tf
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
          #No.FUN-BB0086--add--start--
          LET g_pia_t.pia09 = g_pia[l_ac].pia09
          IF NOT l_tf THEN 
             NEXT FIELD qty
          END IF 
          #No.FUN-BB0086--add--end--
 
 
        AFTER FIELD pia07  
          IF g_pia[l_ac].pia07 IS NOT NULL THEN
             IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_pia[l_ac].pia07,g_aza.aza81) THEN 
                     #FUN-B10049--begin
                     #CALL cl_err(g_pia[l_ac].pia07,'mfg0018',1)
                     CALL cl_err(g_pia[l_ac].pia07,'mfg0018',0)
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
                   #LET g_sql = "aimt822"," '",g_pia[l_ac].pia01 CLIPPED,"'"  #TQC-C60221 mark
                   LET g_sql = "aimt852"," '",g_pia[l_ac].pia01 CLIPPED,"'"   #TQC-C60221 add
                ELSE
                   #LET g_sql = "aimt823"," '",g_pia[l_ac].pia01 CLIPPED,"'"  #TQC-C60221 mark
                   LET g_sql = "aimt853"," '",g_pia[l_ac].pia01 CLIPPED,"'"   #TQC-C60221 add
                END IF
                CALL cl_cmdrun_wait(g_sql)
                CALL t850_mul_unit('N')
                CALL t850_set_entry(p_cmd)
                CALL t850_set_no_entry(p_cmd)
             END IF
          END IF
        
 
        AFTER FIELD qty
           IF NOT t850_qty_check(l_cnt1) THEN NEXT FIELD qty END IF   #No.FUN-BB0086
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
            #         CALL s_lotcheck(g_pia[l_ac].pia01,
            #                         g_pia[l_ac].pia02,
            #                         g_pia[l_ac].pia03,
            #                         g_pia[l_ac].pia04,
            #                         g_pia[l_ac].pia05,        
            #                         g_pia[l_ac].qty,'SET')   
            #              RETURNING l_y,l_qty  
            #      END IF       #No.MOD-940074 add
            #
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
            #   END IF
            #      END IF 
            #      #FUN-B70032 --END--
            #   END IF
            #   IF l_y = 'Y' THEN   
            #      LET g_pia[l_ac].qty = l_qty
            #      LET g_pia_t.qty =g_pia[l_ac].qty #FUN-B70032
            #      DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
            #   END IF
            #END IF 
 
       AFTER FIELD peo 
           #MOD-C30542---mark---add---
           #IF g_pia[l_ac].peo IS NULL THEN
           #   CALL cl_err('','aim-927',0)
           #   NEXT FIELD peo
           #END IF
           #MOD-C30542---mark---end---
            IF g_pia[l_ac].peo IS NOT NULL AND g_pia[l_ac].peo !=' ' THEN   
               CALL t850_peo('d','2',g_pia[l_ac].peo)
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_pia[l_ac].peo,g_errno,0)
                  LET g_pia[l_ac].peo = g_pia_o.peo
                  DISPLAY BY NAME g_pia[l_ac].peo 
                  NEXT FIELD peo  
                END IF
            END IF  
            IF g_pia[l_ac].peo IS NOT NULL THEN LET g_pia_o.peo = g_pia[l_ac].peo END IF
                   
       AFTER FIELD tagdate #盤點日期 
          IF g_pia[l_ac].tagdate IS NULL THEN
             LET g_pia[l_ac].tagdate = g_today
             DISPLAY BY NAME g_pia[l_ac].tagdate 
             NEXT FIELD tagdate
          END IF
          IF g_pia[l_ac].tagdate IS NOT NULL THEN LET g_pia_o.tagdate = g_pia[l_ac].tagdate END IF
          
       
       AFTER FIELD pia930
           IF NOT s_costcenter_chk(g_pia[l_ac].pia930) THEN
              LET g_pia[l_ac].pia930=g_pia_t.pia930
              DISPLAY NULL TO FORMONLY.gem02
              DISPLAY BY NAME g_pia[l_ac].pia930
              NEXT FIELD pia930
           ELSE
              DISPLAY s_costcenter_desc(g_pia[l_ac].pia930) TO gem02
           END IF
       
       #FUN-CB0087--add--str--
       BEFORE FIELD pia70
          IF g_aza.aza115 = 'Y' AND cl_null(g_pia[l_ac].pia70) THEN
             CALL s_reason_code(g_pia[l_ac].pia01,'','',g_pia[l_ac].pia02,
                                g_pia[l_ac].pia03,g_pia[l_ac].peo1,'') RETURNING g_pia[l_ac].pia70
             DISPLAY BY NAME g_pia[l_ac].pia70
             CALL t850_azf03()
          END IF

       AFTER FIELD pia70
          IF NOT t850_pia70_chk() THEN
             NEXT FIELD pia70
          ELSE
             CALL t850_azf03()
          END IF
       #FUN-CB0087--add--end--
			
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
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form     ="q_ima"
               #   LET g_qryparam.default1 = g_pia[l_ac].pia02
               #   CALL cl_create_qry() RETURNING g_pia[l_ac].pia02
                  CALL q_sel_ima(FALSE, "q_ima", "", g_pia[l_ac].pia02, "", "", "", "" ,"",'' )  RETURNING g_pia[l_ac].pia02 
#FUN-AA0059 --End--
		  CALL t850_pia02('a')
                  DISPLAY BY NAME g_pia[l_ac].pia02          
                  NEXT FIELD pia02
               WHEN INFIELD(pia03) #倉庫
#TQC-AA0119 --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     ="q_imd"
#                 LET g_qryparam.default1 = g_pia[l_ac].pia03
#                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#                 CALL cl_create_qry() RETURNING g_pia[l_ac].pia03
                  CALL q_imd_1(FALSE,TRUE,g_pia[l_ac].pia03,"","","","") RETURNING g_pia[l_ac].pia03
#TQC-AA0119 --end
                  DISPLAY BY NAME  g_pia[l_ac].pia03        
                  NEXT FIELD pia03
               WHEN INFIELD(pia04) #儲位
#TQC-AA0119 --modify 
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     ="q_ime"
#                 LET g_qryparam.default1 = g_pia[l_ac].pia04
#                  LET g_qryparam.arg1     = g_pia[l_ac].pia03 #倉庫編號 
#                  LET g_qryparam.arg2     = 'SW'        #倉庫類別
#                 CALL cl_create_qry() RETURNING g_pia[l_ac].pia04
                  CALL q_ime_1(FALSE,TRUE,g_pia[l_ac].pia04,g_pia[l_ac].pia03,"",g_plant,"","","") RETURNING g_pia[l_ac].pia04
#TQC-AA0119 --end
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
               #FUN-CB0087---add---str---
               WHEN INFIELD(pia70) #理由
                  CALL s_get_where(g_pia[l_ac].pia01,'','',g_pia[l_ac].pia02,
                                   g_pia[l_ac].pia03,g_pia[l_ac].peo1,'') RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_pia[l_ac].pia70
                  ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_azf41"
                      LET g_qryparam.default1 = g_pia[l_ac].pia70
                  END IF
                  CALL cl_create_qry() RETURNING g_pia[l_ac].pia70
                  DISPLAY g_pia[l_ac].pia70 TO pia70
                  CALL t850_azf03()
                  NEXT FIELD pia70
               #FUN-CB0087---add---end---               
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
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
 
       ON ACTION lotcheck
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
          END IF   #No.MOD-940074 add
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
          END IF     
          IF l_y = 'Y' THEN                    
             LET g_pia[l_ac].qty = l_qty   
             LET g_pia_t.qty =g_pia[l_ac].qty
             DISPLAY g_pia[l_ac].qty TO FORMONLY.qty
          END IF                   
       #FUN-B70032 --END--       
 
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
            CLOSE t850_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         #FUN-CB0087--add--str--
         IF NOT t850_pia70_chk() THEN
            NEXT FIELD pia70
         END IF
         #FUN-CB0087--add--end--
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_pia[l_ac].pia01,-263,0)
            LET g_pia[l_ac].* = g_pia_t.*
         ELSE
             INITIALIZE l_pia.*  TO NULL
             SELECT * INTO l_pia.* FROM pia_file 
              WHERE pia01 = g_pia[l_ac].pia01            
             CALL s_umfchk(g_pia[l_ac].pia02,g_pia[l_ac].pia09,g_ima25)                                                             
                  RETURNING g_cnt,g_pia10   
             IF g_cnt THEN                                                                                                          
                CALL cl_err('','mfg3075',1)                                                                                         
                LET g_pia[l_ac].pia09 = g_pia_o.pia09                                                                               
                DISPLAY BY NAME g_pia[l_ac].pia09                                                                                   
                #NEXT FIELD pia09  #TQC-C70007 mark                                                                                                  
                #TQC-C70007--add--str--
                IF g_pia16 != 'N' THEN  
                   NEXT FIELD pia09                                                                                                    
                ELSE 
                   LET g_pia[l_ac].* = g_pia_t.*
                   CLOSE t850_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                #TQC-C70007--add--end--
             END IF 
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
             LET l_pia.pia66 = g_pia66
             LET l_pia.pia67 = g_pia67
             LET l_pia.pia68 = g_pia68
             LET l_pia.pia70 = g_pia[l_ac].pia70  #FUN-CB0087
 
             IF l_pia.pia03 IS NULL THEN LET l_pia.pia03 = ' ' END IF
             IF l_pia.pia04 IS NULL THEN LET l_pia.pia04 = ' ' END IF
             IF l_pia.pia05 IS NULL THEN LET l_pia.pia05 = ' ' END IF
             
             IF g_argv1 = '1' THEN 
                 LET l_pia.pia50 = g_pia[l_ac].qty
                 LET l_pia.pia51 = g_user
                 LET l_pia.pia52 = g_today
                 LET l_pia.pia53 = TIME  
                 LET l_pia.pia54 = g_pia[l_ac].peo
                 LET l_pia.pia55 = g_pia[l_ac].tagdate
             ELSE 
                 LET l_pia.pia60 = g_pia[l_ac].qty
                 LET l_pia.pia61 = g_user
                 LET l_pia.pia62 = g_today
                 LET l_pia.pia63 = TIME
                 LET l_pia.pia64 = g_pia[l_ac].peo
                 LET l_pia.pia65 = g_pia[l_ac].tagdate
             END IF
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
            CLOSE t850_bcl            # 新增
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

            IF l_n > 0 THEN
                CALL cl_err(g_pia[l_ac].pia05,'mfg0131',0)
                NEXT FIELD pia02
            END IF
        #MOD-CC0235---add---E
         END IF
 
         CLOSE t850_bcl            # 新增
         COMMIT WORK
    
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
  END INPUT
  CLOSE t850_bcl
  COMMIT WORK
END FUNCTION
 
FUNCTION t850_peo_show()
  DEFINE l_pia  RECORD LIKE pia_file.*
   SELECT * INTO l_pia.*  FROM pia_file
    WHERE pia01 = g_pia[l_ac].pia01
   IF g_argv1 = '1' THEN
     LET g_pia[l_ac].qty1     = l_pia.pia30
     LET g_pia[l_ac].peo1     = l_pia.pia34
     LET g_pia[l_ac].tagdate1 = l_pia.pia35
     LET g_pia[l_ac].qty      = l_pia.pia50
     LET g_pia[l_ac].peo      = l_pia.pia54
     LET g_pia[l_ac].tagdate  = l_pia.pia55
   ELSE
     LET g_pia[l_ac].qty1     = l_pia.pia40
     LET g_pia[l_ac].peo1     = l_pia.pia44
     LET g_pia[l_ac].tagdate1 = l_pia.pia45
     LET g_pia[l_ac].qty      = l_pia.pia60
     LET g_pia[l_ac].peo      = l_pia.pia64
     LET g_pia[l_ac].tagdate  = l_pia.pia65
   END IF
  #peo,gen02
   SELECT gen02  INTO  g_pia[l_ac].gen02_2
     FROM gen_file
    WHERE gen01  =  g_pia[l_ac].peo
 
   SELECT gen02  INTO  g_pia[l_ac].gen02_1
     FROM gen_file
    WHERE gen01  =  g_pia[l_ac].peo1
  #gem02
   SELECT gem02  INTO g_pia[l_ac].gem02
     FROM gem_file 
    WHERE gem01 = g_pia[l_ac].pia930
END FUNCTION
 
 
#genero
FUNCTION t850_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("pia01",TRUE)
   END IF
   IF INFIELD(pia01) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07",TRUE)
   END IF
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("pia03,pia04,pia05",TRUE)
   END IF
   
   CALL cl_set_comp_entry("qty",TRUE)
 
END FUNCTION
 
FUNCTION t850_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("pia01",FALSE)
    END IF
   IF INFIELD(pia01) OR (NOT g_before_input_done) THEN
      IF g_pia16 = 'N' THEN           #FUN-6B0019
          CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07",FALSE)
      END IF
   END IF
   IF (NOT g_before_input_done) THEN
      IF g_sma.sma12 = 'N' THEN 
          CALL cl_set_comp_entry("pia03,pia04,pia05",FALSE)
      END IF
   END IF
 
   IF INFIELD(qty) THEN
      IF g_sma.sma115='Y' AND g_ima906='2' THEN
         CALL cl_set_comp_entry("qty",FALSE)
      END IF
   END IF
 
    CALL cl_set_comp_entry("qty1,peo1,tagdate1",FALSE)
END FUNCTION
 
FUNCTION t850_mul_unit(p_flag)
  DEFINE p_flag    LIKE type_file.chr1   #'Y/N'是否update pia_file #FUN-5B0137  #No.FUN-690026 VARCHAR(1)
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_qty     LIKE pia_file.pia50   #FUN-6B0019
 
    IF cl_null(g_pia[l_ac].pia01) THEN RETURN END IF  #FUN-6B0019
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_pia[l_ac].pia02   #TQC-740226
    IF (l_ima906 = '2') OR (l_ima906='3') THEN #FUN-5B0137
       IF g_argv1='1' THEN
          SELECT SUM(piaa50*piaa10) INTO l_qty FROM piaa_file          #FUN-6B0019
           WHERE piaa01=g_pia[l_ac].pia01
             AND piaa02=g_pia[l_ac].pia02
             AND piaa03=g_pia[l_ac].pia03
             AND piaa04=g_pia[l_ac].pia04
             AND piaa05=g_pia[l_ac].pia05
             AND piaa50 IS NOT NULL
             AND piaa10 IS NOT NULL
          IF p_flag='Y' THEN #FUN-5B0137
             UPDATE pia_file SET pia50=l_qty             #FUN-6B0019
              WHERE pia01=g_pia[l_ac].pia01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pia_file",g_pia[l_ac].pia01,"",SQLCA.sqlcode,    #FUN-6B0019
                             "","update pia",1)   #NO.FUN-640266 #No.FUN-660156
             END IF
          END IF
          LET g_pia[l_ac].qty=l_qty   #FUN-6B0019
       ELSE
          SELECT SUM(piaa60*piaa10) INTO l_qty FROM piaa_file         #FUN-6B0019
           WHERE piaa01=g_pia[l_ac].pia01
             AND piaa02=g_pia[l_ac].pia02
             AND piaa03=g_pia[l_ac].pia03
             AND piaa04=g_pia[l_ac].pia04
             AND piaa05=g_pia[l_ac].pia05
             AND piaa60 IS NOT NULL
             AND piaa10 IS NOT NULL
          IF p_flag='Y' THEN 
             UPDATE pia_file SET pia60=l_qty                 #FUN-6B0019
              WHERE pia01=g_pia[l_ac].pia01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pia_file",g_pia[l_ac].pia01,g_pia[l_ac].pia02,SQLCA.sqlcode,    #FUN-6B0019
                             "","update pia",1)   #NO.FUN-640266 #No.FUN-660156
             END IF
          END IF
          LET g_pia[l_ac].qty=l_qty   #FUN-6B0019
       END IF
    END IF
    DISPLAY BY NAME g_pia[l_ac].qty   #FUN-6B0019
END FUNCTION
#No.FUN-9C0072 精簡程式碼  

#No.FUN-BB0086--add--start--
FUNCTION t850_qty_check(l_cnt1)
DEFINE l_cnt1          LIKE type_file.num5
   IF NOT cl_null(g_pia[l_ac].qty) AND NOT cl_null(g_pia[l_ac].pia09) THEN
      IF cl_null(g_pia_t.qty) OR cl_null(g_pia09_t) OR g_pia_t.qty != g_pia[l_ac].qty OR g_pia09_t != g_pia[l_ac].pia09 THEN
         LET g_pia[l_ac].qty=s_digqty(g_pia[l_ac].qty,g_pia[l_ac].pia09)
         DISPLAY BY NAME g_pia[l_ac].qty
      END IF
   END IF
   
   IF NOT cl_null(g_pia[l_ac].qty) THEN
      IF g_pia[l_ac].qty < 0 THEN 
         LET g_pia[l_ac].qty = g_pia_t.qty
         RETURN FALSE 
      END IF 
      IF g_pia[l_ac].qty != g_pia_t.qty OR g_pia_t.qty IS NULL THEN
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
         END IF       #No.MOD-940074 add

         #FUN-B70032 --START--
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
#FUN-CB0087--add--str---
FUNCTION t850_pia70_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING

   IF NOT cl_null(g_pia[l_ac].pia70) THEN
      LET l_n = 0
      LET l_flag= FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(g_pia[l_ac].pia01,'','',g_pia[l_ac].pia02,
                          g_pia[l_ac].pia03,g_pia[l_ac].peo1,'') RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pia[l_ac].pia70,"' AND ",l_where
         PREPARE ggc08_pre1 FROM l_sql
         EXECUTE ggc08_pre1 INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_pia[l_ac].pia70,'aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_pia[l_ac].pia70 AND azf02='2'
         IF l_n < 1 THEN
            CALL cl_err(g_pia[l_ac].pia70,'aim-425',0)
            RETURN FALSE
         END IF
      END IF
   ELSE                                  #TQC-D20042
      LET g_pia[l_ac].azf03 = ' '        #TQC-D20042
      DISPLAY BY NAME g_pia[l_ac].azf03  #TQC-D20042  
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t850_azf03()
   LET g_pia[l_ac].azf03 = ' '
   SELECT azf03 INTO g_pia[l_ac].azf03 FROM azf_file
    WHERE azf01 = g_pia[l_ac].pia70
      AND azf02 = '2'
   DISPLAY BY NAME g_pia[l_ac].azf03
END FUNCTION
#FUN-CB0087--add--end---
