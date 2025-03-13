# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aicp021.4gl
# Descriptions...: 回貨資料上傳與轉檔作業
# Date & Author..: 08/03/10 By kim (FUN-810038)
# Modify.........: No.CHI-830032 08/03/28 By kim GP5.1整合測試修改
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-8B0036 08/11/05 By chenyu 語言別的要根據不同的情況用不同的值，不能直接用BIG5
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920079 09/02/06 By chenyu 單身欄位編號不能選idh0011這個欄位
# Modify.........: No.CHI-920025 09/02/06 By chenyu 報表格式修改
# Modify.........: No.CHI-920040 09/02/09 By jan 回貨資料上傳時會因idh0011而造成資料重覆,無法上傳成功
# Modify.........: No.FUN-920080 09/02/10 By jan 回貨產生的收貨單應該是已確認的收貨單,但目前并非如此
# Modify.........: No.CHI-920047 09/02/12 By jan 產生出的idd07無資料,導致拋轉后的收貨單無法查出刻號/BIN資料
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153 
# Modify.........: No.CHI-920077 09/02/20 By kim 轉檔多筆會發生問題
# Modify.........: No.CHI-920083 09/02/23 By kim 倉儲為空時在uni-code環境會有問題
# Modify.........: No.CHI-940010 09/04/08 By hellen 修改SELECT ima或者imaicd欄位卻未JOIN相關表的問題
# Modify.........: No.FUN-950040 09/06/11 By jan 收貨單開立時，輸入收貨數量后，需作量的檢查控卡
# Modify.........: No.FUN-980004 09/08/10 By TSD.danny2000 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870100 09/08/12 By Cockroach  對rva29,rvb42在插入前賦初值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0151 09/12/19 by jan VMI在工單發料扣賬時會INSERT rva\rvb這幾個檔,把這幾個檔的NOT NULL的新增字段的值賦予初始值
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-980035 10/02/03 By chenmoyan 增加讀取XLS檔的方式
# Modify.........: No.FUN-A30038 10/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No.FUN-A10130 10/05/12 By jan 自動產生入庫單,以及入庫單確認
# Modify.........: No.FUN-A30066 10/05/12 By jan 加入自動化處理
# Modify.........: No.CHI-A30026 10/05/12 By jan 修改程序BUG
# Modify.........: No.TQC-A30130 10/05/12 By jan 刻號相同BIN不同,應產生在同一筆收貨單身
# Modify.........: No.FUN-A30092 10/05/12 By jan 增加非Pass Bin,寫入刻號/BIN明細的處理
# Modify.........: No.FUN-A60027 10/06/18 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........; No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-B30192 11/05/04 By shenyang       改icb05為imaicd14
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0083 11/12/01 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0084 11/12/21 By lixh1 增加數量欄位小數取位
# Modify.........: No.TQC-C20109 12/02/10 By jason INSERT INTO idg_file 前檢查idgplant,idgleagal預設值
# Modify.........: No.TQC-C20111 12/02/10 By jason INSERT INTO rva_file 前檢查rva33預設值
# Modify.........: No.TQC-C20110 12/02/13 By jason DSC0004的錯誤訊息標準化
# Modify.........: No.CHI-B90037 12/02/24 By bart 新增一段程式idh23
# Modify.........: No.FUN-C30213 12/03/16 By bart 移除上傳按鈕
# Modify.........: No.FUN-C30208 12/03/16 By bart 應於上傳時先維護回貨日期
# Modify.........: No.TQC-C30266 12/03/19 By destiny g_rvb05 调用前没有被赋值
# Modify.........: No.FUN-C30281 12/04/02 By bart 單身母批預設發料單的第一筆母批
# Modify.........: No.CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,新增t110sub_y_chk參數
# Modify.........: No.FUN-C30286 12/04/16 By bart 1.附檔名如果小寫程式會當機
#                                                 2.回貨上傳不自動確認
#                                                 3.回傳未定義的BIN值應拒絕
#                                                 4.rvbiicd03應給工單單頭的作業編號
#                                                 5.自動回貨
# Modify.........: No.TQC-C50095 12/05/10 By Sarah 新增回貨設定檔時自動產生UNIX目錄;設定檔刪除後也應同步刪除相關目錄
# Modify.........: No.FUN-C50106 12/05/24 By bart 產生收貨單資料前,清空g_rva、g_rvb、g_rvbi變數值
# Modify.........: No:TQC-C60190 12/07/11 By Sarah 調整UNIX目錄的路徑
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No:CHI-C80071 12/08/30 By bart ICD回貨資料cicp022資料無法匯入問題。
# Modify.........: No.FUN-C90121 12/10/17 By bart 依ica45參數更新收貨單之價格欄位
# Modify.........: No:MOD-CA0008 13/01/28 By Elise 增加抓取pmniicd03為rvbiicd03的預設值
# Modify.........: No:FUN-D20060 13/02/22 BY minpp 仓库储位控管
# Modify.........: No:MOD-D30215 13/03/25 By bart 1.mark  IF g_imaicd04 NOT MATCHES '[0-2]' THEN RETURN END IF
#                                                 2.沒有做刻號BIN管理的料號，但有做datecode控管的料號，刻號應要放000、BIN要放BIN00，現在都是放空白
# Modify.........: No:MOD-D30237 13/03/27 By bart 沒做刻號BIN，但有做datecode的料號也會被當成需刻號、BIN
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-D40141 13/04/19 By bart 檢查採購單廠商與畫面廠商不同時，顯示錯誤不可匯入

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ide        RECORD LIKE ide_file.*,
       g_ide_t      RECORD LIKE ide_file.*,
       g_ide_o      RECORD LIKE ide_file.*,
       g_idf2       RECORD LIKE idf_file.*,
       g_idh        RECORD LIKE idh_file.*,
       g_idg        RECORD LIKE idg_file.*,
       g_ida        RECORD LIKE ida_file.*,  #FUN-A10130
       g_rva        RECORD LIKE rva_file.*,
       g_rvb        RECORD LIKE rvb_file.*,
       g_rvbi       RECORD LIKE rvbi_file.*,
       g_idd        RECORD LIKE idd_file.*,
       g_ica        RECORD LIKE ica_file.*,
       g_ecm        RECORD LIKE ecm_file.*,
       g_idg04      LIKE idg_file.idg04,
       g_idg04_t    LIKE idg_file.idg04,
       g_idg05      LIKE idg_file.idg05,
       g_idg05_t    LIKE idg_file.idg05,
       g_idg42      LIKE idg_file.idg42,
       g_idg07      LIKE idg_file.idg07,
       g_idg07_t    LIKE idg_file.idg07,
       g_idg83      LIKE idg_file.idg83,     #FUN-C30286 add
       g_idg83_t    LIKE idg_file.idg83,     #FUN-C30286 add
       g_idg84      LIKE idg_file.idg84,     #FUN-C30286 add
       g_idg84_t    LIKE idg_file.idg84,     #FUN-C30286 add
       g_ide01_t    LIKE ide_file.ide01,
       g_ide02_t    LIKE ide_file.ide02,
       g_rva01_str  LIKE rva_file.rva01,
       g_rva01_end  LIKE rva_file.rva01,
       g_idf        DYNAMIC ARRAY OF RECORD
        idf03       LIKE idf_file.idf03,     #順序
        idf04       LIKE idf_file.idf04,     #檔案編號
        idf05       LIKE idf_file.idf05,     #欄位編號
        feldname    LIKE gaq_file.gaq03
                    END RECORD,
       g_idf_t      RECORD                   #程式變數 (舊值)
        idf03       LIKE idf_file.idf03,     #順序
        idf04       LIKE idf_file.idf04,     #檔案編號
        idf05       LIKE idf_file.idf05,     #欄位編號
        feldname    LIKE gaq_file.gaq03
                    END RECORD,
       g_idf_o      RECORD                   #程式變數 (舊值)
        idf03       LIKE idf_file.idf03,     #順序
        idf04       LIKE idf_file.idf04,     #檔案編號
        idf05       LIKE idf_file.idf05,     #欄位編號
        feldname    LIKE gaq_file.gaq03
                    END RECORD,
       g_field      DYNAMIC ARRAY OF RECORD
        seq         LIKE idf_file.idf03,
        name        LIKE idf_file.idf05
                    END RECORD,
       g_idg_s      DYNAMIC ARRAY OF RECORD
        idg20       LIKE idg_file.idg20,
        idg21       LIKE idg_file.idg21,
        idg22       LIKE idg_file.idg22,
        idg23       LIKE idg_file.idg23,
        idg24       LIKE idg_file.idg24
                    END RECORD
DEFINE g_data       DYNAMIC ARRAY OF LIKE type_file.chr1000
DEFINE g_table      LIKE type_file.chr20
DEFINE g_sql        STRING
DEFINE g_wc         STRING                   #單頭CONSTRUCT結果
DEFINE g_wc2        STRING                   #單身CONSTRUCT結果
DEFINE g_rec_b      LIKE type_file.num5      #單身筆數
DEFINE g_rec_b2     LIKE type_file.num5
DEFINE l_ac         LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE g_forupd_sql STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr        LIKE type_file.chr1
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5
DEFINE g_msg        LIKE ze_file.ze03
DEFINE g_msg1       LIKE ze_file.ze03
DEFINE g_curs_index LIKE type_file.num10
DEFINE g_row_count  LIKE type_file.num10     #總筆數
DEFINE g_jump       LIKE type_file.num10     #查詢指定的筆數
DEFINE g_no_ask     LIKE type_file.num5      #是否開啟指定筆視窗
DEFINE g_sfb05      LIKE sfb_file.sfb05
DEFINE g_imaicd04   LIKE imaicd_file.imaicd04
DEFINE g_imaicd08   LIKE imaicd_file.imaicd08
DEFINE g_pmm02      LIKE pmm_file.pmm02
DEFINE g_pmn09      LIKE pmn_file.pmn09
DEFINE g_pmn41      LIKE pmn_file.pmn41
DEFINE g_pmn13      LIKE pmn_file.pmn13
DEFINE g_pmn14      LIKE pmn_file.pmn14
DEFINE g_pmn20      LIKE pmn_file.pmn20
DEFINE g_pmn50_55   LIKE pmn_file.pmn50
DEFINE g_pmniicd03  LIKE pmni_file.pmniicd03
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_imf04      LIKE imf_file.imf04
DEFINE g_imf05      LIKE imf_file.imf05
DEFINE g_pmn38      LIKE pmn_file.pmn38
DEFINE g_ima906     LIKE ima_file.ima906
DEFINE g_img07      LIKE img_file.img07
DEFINE g_img09      LIKE img_file.img09
DEFINE g_img10      LIKE img_file.img10
DEFINE g_min_set    LIKE sfb_file.sfb08
DEFINE conf_qty     LIKE sfb_file.sfb08
DEFINE g_ecdicd01   LIKE ecd_file.ecdicd01   #作業編號之作業群組
DEFINE g_rvb05      LIKE rvb_file.rvb05      #採購料號
DEFINE g_pmniicd14  LIKE pmni_file.pmniicd14 #內編母體
DEFINE ms_codeset   STRING                   #No.MOD-8B0036 add
DEFINE ms_locale    STRING                   #No.MOD-8B0036 add
DEFINE g_idg21      LIKE idg_file.idg21      #FUN-A30066
#FUN-A30066--begin--add------
DEFINE g_location   STRING 
DEFINE g_dir        STRING                   #TQC-C50095 add
DEFINE g_csv        DYNAMIC ARRAY OF RECORD 
        csv         LIKE type_file.chr1000
                    END RECORD,
       g_cmd        STRING,
       g_index      LIKE type_file.num5,
       g_fpath      LIKE type_file.chr1000,
       g_fpath2     LIKE type_file.chr1000,
       g_fname      LIKE type_file.chr1000
#FUN-A30066--end--add----
DEFINE g_icf07      LIKE icf_file.icf07      #TQC-A30130
DEFINE g_icf04      LIKE icf_file.icf04      #FUN-A30092
DEFINE g_col        LIKE type_file.num5      #FUN-980035
DEFINE g_rvb07      LIKE rvb_file.rvb07      #FUN-C30286 add
DEFINE g_rvbiicd06  LIKE rvbi_file.rvbiicd06 #FUN-C30286 add
DEFINE g_rvbiicd07  LIKE rvbi_file.rvbiicd07 #FUN-C30286 add
DEFINE g_rvbiicd08  LIKE rvbi_file.rvbiicd08 #FUN-C30286 add
DEFINE g_idg56      LIKE idg_file.idg56      #FUN-C90121

MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #FUN-A30066--begin--add----
   LET g_bgjob = ARG_VAL(1)                                                                                                         
   IF cl_null(g_bgjob) THEN                                                                                                         
      LET g_bgjob = "N"                                                                                                             
   END IF
   #FUN-A30066--end--add---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-A30066--begin--add------
   IF g_bgjob = 'Y' THEN
      LET g_sma.sma892[2,2] = 'N'  #FUN-C30286
      CALL p021()
   ELSE
   #FUN-A30066--end--add------
      LET g_forupd_sql = "SELECT * FROM ide_file WHERE ide01= ? AND ide02= ? FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE p021_cl CURSOR FROM g_forupd_sql
      
      OPEN WINDOW p021_w WITH FORM "aic/42f/aicp021"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      
      CALL p021_menu()
      CLOSE WINDOW p021_w                 #結束畫面
   END IF  #FUN-A30066
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION p021_cs()
DEFINE lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE l_str      STRING
DEFINE l_t1        LIKE type_file.chr5
 
  CLEAR FORM                             #清除畫面
  CALL g_idf.clear()
 
  CONSTRUCT BY NAME g_wc ON ide01,ide02,ide03,ide04,ide05,
                           ide06,ide07,ide08,ide16  #FUN-A30066
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ide01) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pmc1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ide01
               NEXT FIELD ide01
 
            WHEN INFIELD(ide03) #收貨單號
              #FUN-A10130--begin--modify--------
              #LET l_t1 = s_get_doc_no(g_ide.ide03)
              #CALL q_smy(FALSE,FALSE,l_t1,'APM','3')
              #    RETURNING l_str
              #DISPLAY l_str TO ide03
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.where = "smysys = 'apm' AND smykind in ('3','B') "
               LET g_qryparam.form ="q_smy1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ide03
              #FUN-A10130--end--modify--------------
               NEXT FIELD ide03
 
            OTHERWISE
               EXIT CASE
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  IF INT_FLAG THEN
     RETURN
  END IF
 
  CONSTRUCT g_wc2 ON idf03,idf05
                FROM s_idf[1].idf03,
                     s_idf[1].idf05
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION controlp
            CASE
              WHEN INFIELD(idf04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gat"
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO idf04
                NEXT FIELD idf04
 
              WHEN INFIELD(idf05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gaq3"   #No.MOD-920079 add
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO idf05
                NEXT FIELD idf05
 
              OTHERWISE
                   EXIT CASE
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
  END CONSTRUCT
  IF INT_FLAG THEN
     RETURN
  END IF
  IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
     LET g_sql = "SELECT ide01,ide02 ",
                 "  FROM ide_file ",
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY ide01,ide02 "
  ELSE                                    # 若單身有輸入條件
     LET g_sql = "SELECT UNIQUE ide01,ide02 ",
                 "  FROM ide_file,idf_file ",
                 " WHERE ide01 = idf01 ",
                 "   AND ide02 = idf02 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED,
                 " ORDER BY ide01,ide02 "
  END IF
  PREPARE p021_prepare FROM g_sql
  DECLARE p021_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR p021_prepare
 
END FUNCTION
 
FUNCTION p021_count()
   DEFINE la_ide  DYNAMIC ARRAY OF RECORD
          ide01      LIKE ide_file.ide01,
          ide02      LIKE ide_file.ide02
                  END RECORD
   DEFINE li_cnt     LIKE type_file.num10
   DEFINE li_rec_b   LIKE type_file.num10
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT ide01,ide02 ",
                  "  FROM ide_file ",
                  " WHERE ",g_wc CLIPPED,
                  " GROUP BY ide01,ide02 "
   ELSE
      LET g_sql = "SELECT ide01,ide02 ",
                  "  FROM ide_file,idf_file ",
                  " WHERE ide01 = idf01 ",
                  "   AND ide02 = idf02 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  " GROUP BY ide01,ide02 "
   END IF
   PREPARE p021_precount FROM g_sql
   DECLARE p021_count CURSOR FOR p021_precount
   LET li_cnt = 1
   LET li_rec_b = 0
   FOREACH p021_count INTO la_ide[li_cnt].*
      IF STATUS THEN
         CALL cl_err('p021_count foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET li_rec_b = li_rec_b + 1
      LET li_cnt = li_cnt + 1
   END FOREACH
   LET g_row_count = li_rec_b
 
END FUNCTION
 
FUNCTION p021_menu()
   DEFINE l_cmd        STRING                  #TQC-C60190 add
 
   WHILE TRUE
      CALL p021_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p021_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p021_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p021_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p021_u()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL p021_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p021_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         #FUN-C30213---begin mark
         #WHEN "upload"
         #   IF cl_chk_act_auth() THEN
         #      CALL p021_upload(g_ide.ide05)  #FUN-A30066
         #   END IF
         #FUN-C30213---end

         WHEN "transreturn"
            IF cl_chk_act_auth() THEN
               CALL p021_upload(g_ide.ide05) #FUN-C30213
               IF g_success = 'Y' THEN         #FUN-C30213
                  CALL p021_trans(g_ide.ide05)  #FUN-A30066
               END IF                          #FUN-C30213
              #str TQC-C60190 add
               LET g_dir = FGL_GETENV("TOP"),"/doc/aic/aicp021/",g_ide.ide01 CLIPPED,"/",g_ide.ide02 CLIPPED,"/"
               LET g_location = g_dir CLIPPED,"upload","/"
               #回貨成功,要將檔案搬到trans目錄下;回貨失敗,要將檔案搬到error目錄下
               IF g_success = "Y" THEN
                  LET l_cmd="mv ",g_location,g_ide.ide05 CLIPPED," ",
                             g_dir,"trans","/",g_ide.ide05 CLIPPED
                  RUN l_cmd
               ELSE
                  LET l_cmd="mv ",g_location,g_ide.ide05 CLIPPED," ",
                             g_dir,"error","/",g_ide.ide05 CLIPPED
                  RUN l_cmd
               END IF
              #end TQC-C60190 add
            END IF

        #str TQC-C50095 add
         WHEN "create_dir"    #建立自動回貨目錄
            IF cl_chk_act_auth() THEN
               CALL p021_mkdir()
            END IF
        #end TQC-C50095 add
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p021_bp(p_ud)
   DEFINE p_ud            LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   CALL p021_act_visible()   #TQC-C50095 add

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_idf TO s_idf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL p021_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p021_act_visible()   #TQC-C50095 add
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL p021_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p021_act_visible()   #TQC-C50095 add
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL p021_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p021_act_visible()   #TQC-C50095 add
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL p021_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p021_act_visible()   #TQC-C50095 add
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL p021_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         CALL p021_act_visible()   #TQC-C50095 add
         ACCEPT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      #FUN-C30213---begin mark
      #ON ACTION upload
      #   LET g_action_choice="upload"
      #   EXIT DISPLAY
      #FUN-C30213---end
      ON ACTION transreturn
         LET g_action_choice="transreturn"
         EXIT DISPLAY
 
     #str TQC-C50095 add
      ON ACTION create_dir    #建立自動回貨目錄
         LET g_action_choice="create_dir"
         EXIT DISPLAY
     #end TQC-C50095 add

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
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION p021_a()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_idf.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
   INITIALIZE g_ide.* LIKE ide_file.*             #DEFAULT 設定
   LET g_ide01_t = NULL
   LET g_ide02_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_ide.ide02 = '0'
   LET g_ide.ide04 = g_today
   LET g_ide.ide06 = '0'
   LET g_ide.ide07 = '0'
   LET g_ide.ide08 = 'N'
   LET g_ide.ide10 =  0       # 上傳產生錯誤訊息檔的流水序號用
   LET g_ide.ide11 =  0       # 轉檔產生錯誤訊息檔的流水序號用	
   LET g_ide.ide16 = 1        #FUN-A30066
   LET g_ide.ideplant = g_plant    #FUN-980004
   LET g_ide.idelegal = g_legal    #FUN-980004
   LET g_ide_t.* = g_ide.*
   LET g_ide_o.* = g_ide.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p021_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_ide.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ide.ide01) OR         #KEY 不可空白
         cl_null(g_ide.ide02) THEN
         CONTINUE WHILE
      END IF
 
      INSERT INTO ide_file VALUES (g_ide.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN       #置入資料庫不成功
         CALL cl_err(g_ide.ide01,SQLCA.sqlcode,1)
         CONTINUE WHILE
      END IF
 
      #新增回貨設定檔時自動產生UNIX目錄
      CALL p021_mkdir()   #TQC-C50095 add

      LET g_ide01_t = g_ide.ide01        #保留舊值
      LET g_ide02_t = g_ide.ide02        #保留舊值
      LET g_ide_t.* = g_ide.*
      LET g_ide_o.* = g_ide.*
      CALL g_idf.clear()
      LET g_rec_b = 0
      CALL p021_b()                                 #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p021_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ide.ide01) OR
      cl_null(g_ide.ide02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ide01_t = g_ide.ide01
   LET g_ide02_t = g_ide.ide02
 
   BEGIN WORK
 
   OPEN p021_cl USING g_ide.ide01,g_ide.ide02
   IF STATUS THEN
      CALL cl_err("OPEN p021_cl:",STATUS,1)
      CLOSE p021_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p021_cl INTO g_ide.*                    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)    # 資料被他人LOCK
      CLOSE p021_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p021_show()
 
   WHILE TRUE
      CALL p021_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ide.* = g_ide_t.*
         CALL cl_err('','9001',0)
         CALL p021_show()
         EXIT WHILE
      END IF
 
      UPDATE ide_file SET ide_file.* = g_ide.*
       WHERE ide01 = g_ide01_t
         AND ide02 = g_ide02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE p021_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p021_i(p_cmd)
DEFINE  l_cnt      LIKE type_file.num5,
        p_cmd      LIKE type_file.chr1,               #a:輸入 u:更改
        li_result  LIKE type_file.num5
DEFINE  l_t1       LIKE type_file.chr5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INPUT BY NAME g_ide.ide01,g_ide.ide02,g_ide.ide03,
                 g_ide.ide04,g_ide.ide05,g_ide.ide06,
                 g_ide.ide07,g_ide.ide08,g_ide.ide16   #FUN-A30066 add ide16
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p021_set_entry(p_cmd)
         CALL p021_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD ide01
         IF NOT cl_null(g_ide.ide01) THEN
            CALL p021_ide01('a',g_ide.ide01)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ide.ide01,g_errno,0)
               LET g_ide.ide01 = g_ide_t.ide01
               DISPLAY BY NAME g_ide.ide01
               NEXT FIELD ide01
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.pmc03
         END IF
 
      AFTER FIELD ide02
         IF NOT cl_null(g_ide.ide02) THEN
            IF g_ide.ide02 NOT MATCHES '[012349]' THEN
               NEXT FIELD ide02
            END IF
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND ((g_ide.ide01 != g_ide_t.ide01) OR
                                (g_ide.ide02 != g_ide_t.ide02)))
              THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM ide_file
               WHERE ide01 = g_ide.ide01
                 AND ide02 = g_ide.ide02
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD ide01
              END IF
            END IF
         END IF
 
      AFTER FIELD ide03
         IF NOT cl_null(g_ide.ide03) THEN
            CALL p021_ide03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ide.ide03,g_errno,0)
               LET g_ide.ide03 = g_ide_t.ide03
               DISPLAY BY NAME g_ide.ide03
               NEXT FIELD ide03
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.smydesc
         END IF
 
      AFTER FIELD ide06
         IF NOT cl_null(g_ide.ide06) THEN
            IF g_ide.ide06 NOT MATCHES '[012]' THEN
               NEXT FIELD ide06
            END IF
         END IF
 
      AFTER FIELD ide07
         IF NOT cl_null(g_ide.ide07) THEN
            IF g_ide.ide07 NOT MATCHES '[01]' THEN
               NEXT FIELD ide07
            END IF
         END IF
 
      AFTER FIELD ide08
         IF NOT cl_null(g_ide.ide08) THEN
            IF g_ide.ide08 NOT MATCHES '[YN]' THEN
               NEXT FIELD ide08
            END IF
         END IF
 
      #FUN-A30066--begin------- 
      AFTER FIELD ide16
         IF NOT cl_null(g_ide.ide16) THEN 
            IF g_ide.ide16 < 1 THEN 
               CALL cl_err('','apm-528',1)
               NEXT FIELD ide16
            END IF
         ELSE
            CALL cl_err('','p_tar08',1)
            NEXT FIELD ide16
         END IF
      #FUN-A30066--end-------

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF p_cmd = 'a' OR
           (p_cmd = 'u' AND ((g_ide.ide01 != g_ide_t.ide01) OR
                             (g_ide.ide02 != g_ide_t.ide02)))
           THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM ide_file
             WHERE ide01 = g_ide.ide01
               AND ide02 = g_ide.ide02
            IF l_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD ide01
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ide01) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc1"
              LET g_qryparam.default1 = g_ide.ide01
              CALL cl_create_qry() RETURNING g_ide.ide01
              DISPLAY BY NAME g_ide.ide01
              NEXT FIELD ide01
 
            WHEN INFIELD(ide03) #收貨單別
             #FUN-A10130--begin--modify--------
             #LET l_t1 = s_get_doc_no(g_ide.ide03)
             #CALL q_smy(FALSE,FALSE,l_t1,'APM','3')
             #   RETURNING g_ide.ide03
              CALL cl_init_qry_var()
              LET g_qryparam.where = "smysys = 'apm' AND smykind in ('3','B') "
              LET g_qryparam.form ="q_smy1"
              CALL cl_create_qry() RETURNING g_ide.ide03
             #FUN-A10130--end--modify----------
              DISPLAY BY NAME g_ide.ide03
              NEXT FIELD ide03              
 
            OTHERWISE EXIT CASE
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
 
FUNCTION p021_ide01(p_cmd,p_key)
DEFINE  p_cmd      LIKE type_file.chr1
DEFINE  p_key      LIKE pmc_file.pmc01
DEFINE  l_pmc03    LIKE pmc_file.pmc03
DEFINE  l_pmc30    LIKE pmc_file.pmc30
DEFINE  l_pmcacti  LIKE pmc_file.pmcacti
 
   LET g_errno = ''
 
   SELECT pmc03,pmc30,pmcacti
     INTO l_pmc03,l_pmc30,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = p_key
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg3014'
        WHEN l_pmcacti = 'N'          LET g_errno = '9028'
        WHEN l_pmc30 = '2'            LET g_errno = 'mfg3290'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
 
END FUNCTION
 
FUNCTION p021_ide03(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1
DEFINE  l_smyacti  LIKE smy_file.smyacti
DEFINE  l_smysys   LIKE smy_file.smysys
DEFINE  l_smykind  LIKE smy_file.smykind
DEFINE  l_smyauno  LIKE smy_file.smyauno
DEFINE  l_smydesc  LIKE smy_file.smydesc
 
   LET g_errno = ''
 
   SELECT smysys,smydesc,smykind,smyauno,smyacti
     INTO l_smysys,l_smydesc,l_smykind,l_smyauno,l_smyacti
     FROM smy_file
    WHERE smyslip = g_ide.ide03
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100      LET g_errno = 'afa-094'
        WHEN l_smyacti = 'N'          LET g_errno = '9028'
        WHEN l_smysys != 'apm'        LET g_errno = 'aic-159'
        WHEN l_smykind != '3' AND l_smykind != 'B'   #FUN-A10130
                                      LET g_errno = 'aic-159'
        WHEN l_smyauno != 'Y'         LET g_errno = 'amm-107'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
END FUNCTION
 
FUNCTION p021_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_idf.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL p021_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ide.* TO NULL
      RETURN
   END IF
 
   OPEN p021_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ide.* TO NULL
   ELSE
      CALL p021_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p021_fetch('F')                 # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION p021_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p021_cs INTO g_ide.ide01,g_ide.ide02
      WHEN 'P' FETCH PREVIOUS p021_cs INTO g_ide.ide01,g_ide.ide02
      WHEN 'F' FETCH FIRST    p021_cs INTO g_ide.ide01,g_ide.ide02
      WHEN 'L' FETCH LAST     p021_cs INTO g_ide.ide01,g_ide.ide02
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about
                      CALL cl_about()
 
                   ON ACTION help
                      CALL cl_show_help()
 
                   ON ACTION controlg
                      CALL cl_cmdask()
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump p021_cs INTO g_ide.ide01,
                                               g_ide.ide02
            LET g_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
      INITIALIZE g_ide.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF
 
   SELECT * INTO g_ide.* FROM ide_file
    WHERE ide01 = g_ide.ide01
      AND ide02 = g_ide.ide02
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
      INITIALIZE g_ide.* TO NULL
      RETURN
   END IF
 
   CALL p021_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p021_show()
   LET g_ide_t.* = g_ide.*                #保存單頭舊值
   LET g_ide_o.* = g_ide.*                #保存單頭舊值
   DISPLAY BY NAME g_ide.ide01,g_ide.ide02,
                   g_ide.ide03,g_ide.ide04,
                   g_ide.ide05,g_ide.ide06,
                   g_ide.ide07,g_ide.ide08,
                   g_ide.ide16   #FUN-A30066
   CALL p021_ide01('d',g_ide.ide01)
   CALL p021_ide03('d')
   CALL p021_b_fill(g_wc2)                      #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION p021_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ide.ide01) OR
      cl_null(g_ide.ide02) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN p021_cl USING g_ide.ide01,g_ide.ide02
   IF STATUS THEN
      CALL cl_err("OPEN p021_cl:",STATUS,1)
      CLOSE p021_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p021_cl INTO g_ide.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p021_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM ide_file WHERE ide01 = g_ide.ide01
                             AND ide02 = g_ide.ide02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('del ide:',SQLCA.SQLCODE,0)
         CLOSE p021_cl
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM idf_file WHERE idf01 = g_ide.ide01
                             AND idf02 = g_ide.ide02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('del idf:',SQLCA.SQLCODE,0)
         CLOSE p021_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      #刪除回貨設定檔時自動刪除UNIX目錄
      CALL p021_rmdir()   #TQC-C50095 add

      CLEAR FORM
      CALL g_idf.clear()
      CALL p021_count()
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         LET g_ide.ide01 = ''   #TQC-C50095 add
         LET g_ide.ide02 = ''   #TQC-C50095 add
         CLOSE p021_cs
         CLOSE p021_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN p021_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL p021_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL p021_fetch('/')
      END IF
   END IF
 
   CLOSE p021_cl
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION p021_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_db            LIKE azp_file.azp03,
    li_inx          LIKE type_file.num5,
    ls_str          STRING,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5               #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_ide.ide01) OR
       cl_null(g_ide.ide02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT idf03,idf04,idf05,'' ",
                       "  FROM idf_file ",
                       "  WHERE idf01=? AND idf02=? AND idf03=?",
                       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p021_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_idf WITHOUT DEFAULTS FROM s_idf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN p021_cl USING g_ide.ide01,g_ide.ide02
           IF STATUS THEN
              CALL cl_err("OPEN p021_cl:",STATUS,1)
              CLOSE p021_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH p021_cl INTO g_ide.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)  # 資料被他人LOCK
              CLOSE p021_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_idf_t.* = g_idf[l_ac].*  #BACKUP
              LET g_idf_o.* = g_idf[l_ac].*  #BACKUP
              OPEN p021_bcl USING g_ide.ide01,
                                  g_ide.ide02,
                                  g_idf_t.idf03
              IF STATUS THEN
                 CALL cl_err("OPEN p021_bcl:",STATUS,1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH p021_bcl INTO g_idf[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_idf_t.idf03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT gaq03 INTO g_idf[l_ac].feldname
                   FROM gaq_file
                  WHERE gaq01=g_idf[l_ac].idf05
                    AND gaq02=g_lang
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_idf[l_ac].* TO NULL
           LET g_idf[l_ac].idf04 = 'idh_file'
           LET g_idf_t.* = g_idf[l_ac].*         #新輸入資料
           LET g_idf_o.* = g_idf[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD idf03
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_idf[l_ac].idf04) AND
              NOT cl_null(g_idf[l_ac].idf05) THEN
              CALL p021_idf05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_idf[l_ac].idf05,g_errno,0)
                 CANCEL INSERT
              END IF
           END IF
           INSERT INTO idf_file (idf01,idf02,idf03,idf04,idf05,idfplant,idflegal)    #FUN-980004 add plant & legal
           VALUES(g_ide.ide01,g_ide.ide02,
                  g_idf[l_ac].idf03,g_idf[l_ac].idf04,
                  g_idf[l_ac].idf05,g_plant,g_legal)     #FUN-980004 add plant & legal
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err(g_idf[l_ac].idf03,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD idf03                        #default 序號
           IF cl_null(g_idf[l_ac].idf03) OR
              g_idf[l_ac].idf03 = 0 THEN
              SELECT MAX(idf03)+1
                INTO g_idf[l_ac].idf03
                FROM idf_file
               WHERE idf01 = g_ide.ide01
                 AND idf02 = g_ide.ide02
              IF cl_null(g_idf[l_ac].idf03) THEN
                 LET g_idf[l_ac].idf03 = 1
              END IF
           END IF
 
        AFTER FIELD idf03                        #check 序號是否重複
           IF NOT cl_null(g_idf[l_ac].idf03) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND
                       g_idf[l_ac].idf03 != g_idf_t.idf03) THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM idf_file
                  WHERE idf01 = g_ide.ide01
                    AND idf02 = g_ide.ide02
                    AND idf03 = g_idf[l_ac].idf03
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_idf[l_ac].idf03,-239,0)
                    LET g_idf[l_ac].idf03 = g_idf_t.idf03
                    DISPLAY BY NAME g_idf[l_ac].idf03
                    NEXT FIELD idf03
                 END IF
              END IF
           END IF
 
        AFTER FIELD idf04
 
        AFTER FIELD idf05
           IF NOT cl_null(g_idf[l_ac].idf05) THEN
              IF g_idf[l_ac].idf05 = 'idh0011' THEN
                 CALL cl_err(g_idf[l_ac].idf05,'aic-214',0)
                 NEXT FIELD idf05
              END IF
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND
                       g_idf[l_ac].idf05 != g_idf_t.idf05) THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM idf_file
                  WHERE idf01 = g_ide.ide01
                    AND idf02 = g_ide.ide02
                    AND idf05 = g_idf[l_ac].idf05
                 IF l_cnt > 0 THEN
                    CALL cl_err(g_idf[l_ac].idf05,'aic-163',0)
                    LET g_idf[l_ac].idf05 = g_idf_t.idf05
                    DISPLAY BY NAME g_idf[l_ac].idf05
                    NEXT FIELD idf05
                 END IF
 
                 IF NOT cl_null(g_idf[l_ac].idf04) THEN
                    CALL p021_idf05('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_idf[l_ac].idf05,g_errno,0)
                       LET g_idf[l_ac].idf05 = g_idf_t.idf05
                       DISPLAY BY NAME g_idf[l_ac].idf05
                       NEXT FIELD idf05
                    END IF
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                      #是否取消單身
           IF g_idf_t.idf03 > 0 AND
              NOT cl_null(g_idf_t.idf03) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
              END IF
              DELETE FROM idf_file
               WHERE idf01 = g_ide.ide01
                 AND idf02 = g_ide.ide02
                 AND idf03 = g_idf_t.idf03
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err(g_idf_t.idf03,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_idf[l_ac].* = g_idf_t.*
              CLOSE p021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_idf[l_ac].idf03,-263,1)
              LET g_idf[l_ac].* = g_idf_t.*
           ELSE
              IF NOT cl_null(g_idf[l_ac].idf04) AND
                 NOT cl_null(g_idf[l_ac].idf05) THEN
                 CALL p021_idf05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_idf[l_ac].idf05,g_errno,0)
                    LET g_idf[l_ac].idf05 = g_idf_t.idf05
                    DISPLAY BY NAME g_idf[l_ac].idf05
                    NEXT FIELD idf05
                 END IF
              END IF
              UPDATE idf_file SET idf03=g_idf[l_ac].idf03,
                                  idf04=g_idf[l_ac].idf04,
                                  idf05=g_idf[l_ac].idf05
               WHERE idf01=g_ide.ide01
                 AND idf02=g_ide.ide02
                 AND idf03=g_idf_t.idf03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_idf[l_ac].idf03,SQLCA.sqlcode,0)
                 LET g_idf[l_ac].* = g_idf_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D40030 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_idf[l_ac].* = g_idf_t.*
             #FUN-D40030--add--str
              ELSE
                 CALL g_idf.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
             #FUN-D40030--add--end
              END IF
              CLOSE p021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac#FUN-D40030 add
           CLOSE p021_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(idf03) AND l_ac > 1 THEN
              LET g_idf[l_ac].* = g_idf[l_ac-1].*
              SELECT MAX(idf03)+5 INTO l_cnt
                FROM idf_file
               WHERE idf01 = g_ide.ide01
                 AND idf02 = g_ide.ide02
              LET g_idf[l_ac].idf03 = l_cnt
              DISPLAY BY NAME g_idf[l_ac].*
              NEXT FIELD idf03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
 
             WHEN INFIELD(idf05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq3"   #No.MOD-920079 add
               LET g_qryparam.arg1 = g_lang
               LET ls_str = g_idf[l_ac].idf04
               LET li_inx = ls_str.getIndexOf("_file",1)
               IF li_inx >= 1 THEN
                  LET ls_str = ls_str.subString(1,li_inx-1)
               ELSE
                  LET ls_str = ""
               END IF
               LET g_qryparam.arg2 = ls_str
               LET g_qryparam.default1 = g_idf[l_ac].idf05
               CALL cl_create_qry() RETURNING g_idf[l_ac].idf05
               DISPLAY BY NAME g_idf[l_ac].idf05
               NEXT FIELD idf05
 
             OTHERWISE
                EXIT CASE
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
    CLOSE p021_bcl
    COMMIT WORK
    CALL p021_delall()
 
END FUNCTION
 
FUNCTION p021_idf05(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1
DEFINE  l_gaq03   LIKE gaq_file.gaq03
DEFINE  li_inx    LIKE type_file.num5
DEFINE  ls_str    STRING
 
   LET g_errno = ''
 
   LET ls_str = g_idf[l_ac].idf04
   LET li_inx = ls_str.getIndexOf("_file",1)
   LET ls_str = ls_str.subString(1,li_inx-1)
 
   LET g_sql = "SELECT gaq03 FROM gaq_file ",
               " WHERE gaq01 LIKE '%",ls_str CLIPPED,"%'",
               "   AND gaq01 = '",g_idf[l_ac].idf05 CLIPPED,"'",
               "   AND gaq02 = ",g_lang
   PREPARE p021_idf05_pre FROM g_sql
   DECLARE p021_idf05_cs CURSOR FOR p021_idf05_pre
 
   OPEN p021_idf05_cs
   IF STATUS THEN
      CLOSE p021_idf05_cs
      LET g_errno = STATUS USING '------'
      RETURN
   END IF
   FETCH p021_idf05_cs INTO l_gaq03
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100            LET g_errno = 'aic-162'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
 
      IF cl_null(g_errno) THEN
         IF g_idf[l_ac].idf05 = 'idh001' OR
            g_idf[l_ac].idf05 = 'idh002' OR
            g_idf[l_ac].idf05 = 'idh003' OR
            g_idf[l_ac].idf05 = 'idh144' THEN
            LET g_errno = 'aic-164'
         END IF
      END IF
   END IF
   CLOSE p021_idf05_cs
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_idf[l_ac].feldname = l_gaq03
      DISPLAY BY NAME g_idf[l_ac].feldname
   END IF
END FUNCTION
 
FUNCTION p021_delall()
 
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM idf_file
     WHERE idf01 = g_ide.ide01
       AND idf02 = g_ide.ide02
 
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
       CALL cl_err('','9044',0)
       DELETE FROM ide_file WHERE ide01 = g_ide.ide01
                                 AND ide02 = g_ide.ide02
    END IF
 
END FUNCTION
 
FUNCTION p021_b_askkey()
 
 DEFINE l_wc2           STRING
 
  CONSTRUCT l_wc2 ON idf03,idf04,idf05
                FROM s_idf[1].idf03,s_idf[1].idf04,
                     s_idf[1].idf05
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
 
              WHEN INFIELD(idf05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gaq3"   #No.MOD-920079 add
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO idf05
                NEXT FIELD idf05
 
              OTHERWISE
                   EXIT CASE
 
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
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     RETURN
  END IF
 
  CALL p021_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION p021_b_fill(p_wc2)              #BODY FILL UP
 DEFINE p_wc2       STRING
 LET g_col = 0
 
   LET g_sql = "SELECT idf03,idf04,idf05,'' ",
               "  FROM idf_file ",
               " WHERE idf01 = '",g_ide.ide01 CLIPPED,"'",
               "   AND idf02 = '",g_ide.ide02 CLIPPED,"'"
 
    IF NOT cl_null(p_wc2) THEN
       LET g_sql = g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY idf03 "
 
    PREPARE p021_pb FROM g_sql
    DECLARE idf_cs CURSOR FOR p021_pb
 
    CALL g_idf.clear()
    LET g_cnt = 1
    FOREACH idf_cs INTO g_idf[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT gaq03 INTO g_idf[g_cnt].feldname
        FROM gaq_file
       WHERE gaq01=g_idf[g_cnt].idf05
         AND gaq02=g_lang
#FUN-980035 --Begin
      IF g_idf[g_cnt].idf03 > g_col THEN
         LET g_col = g_idf[g_cnt].idf03
      END IF
#FUN-980035 --End
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
   EXIT FOREACH
      END IF
    END FOREACH
    CALL g_idf.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p021_copy()
DEFINE  l_newno         LIKE ide_file.ide01,
        l_newkind       LIKE ide_file.ide02,
        l_oldno         LIKE ide_file.ide01,
        l_oldkind       LIKE ide_file.ide02
DEFINE  l_cnt           LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ide.ide01) OR
       cl_null(g_ide.ide02) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL p021_set_entry('a')
 
    INPUT l_newno,l_newkind FROM ide01,ide02
        AFTER FIELD ide01
          IF NOT cl_null(l_newno) THEN
             CALL p021_ide01('a',l_newno)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_newno,g_errno,0)
                LET l_newno = NULL
                DISPLAY l_newno TO ide01
                NEXT FIELD ide01
             END IF
          ELSE
             DISPLAY ' ' TO FORMONLY.pmc03
          END IF
 
        AFTER FIELD ide02
          IF NOT cl_null(l_newkind) THEN
             IF l_newkind NOT MATCHES '[012349]' THEN
                NEXT FIELD ide02
             END IF
          END IF
 
        AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt
            FROM ide_file
           WHERE ide01 = l_newno
             AND ide02 = l_newkind
          IF l_cnt > 0 THEN
             CALL cl_err('',-239,0)
             NEXT FIELD ide01
          END IF
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ide01) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc1"
              LET g_qryparam.default1 = l_newno
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO ide01
              NEXT FIELD ide01
 
            OTHERWISE
              EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_ide.ide01,g_ide.ide02
       RETURN
    END IF
 
    DROP TABLE y
 
    SELECT * FROM ide_file         #單頭複製
        WHERE ide01 = g_ide.ide01
          AND ide02 = g_ide.ide02
        INTO TEMP y
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    UPDATE y
        SET ide01=l_newno,   #新的鍵值
            ide02=l_newkind  #新的鍵值
 
    INSERT INTO ide_file
        SELECT * FROM y
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * FROM idf_file         #單身複製
        WHERE idf01=g_ide.ide01
          AND idf02=g_ide.ide02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    UPDATE x SET idf01=l_newno,
                 idf02=l_newkind
 
    INSERT INTO idf_file
        SELECT * FROM x
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(g_ide.ide01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,'+',l_newkind,') O.K'
 
    LET l_oldno = g_ide.ide01
    LET l_oldkind = g_ide.ide02

    SELECT * INTO g_ide.* FROM ide_file
     WHERE ide01 = l_newno AND ide02 = l_newkind

    #複製產生新的回貨設定檔時自動產生UNIX目錄
    CALL p021_mkdir()   #TQC-C50095 add

    CALL p021_u()
    CALL p021_b()

    #SELECT * INTO g_ide.* FROM ide_file           #FUN-C30027 
    # WHERE ide01 = l_oldno AND ide02 = l_oldkind  #FUN-C30027 

    #CALL p021_show()                              #FUN-C30027 
 
END FUNCTION
 
FUNCTION p021_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ide01,ide02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION p021_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ide01,ide02",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION p021_upload(p_ide05)  #FUN-A30066
   DEFINE l_name       LIKE type_file.chr20
   DEFINE l_rec_b      LIKE type_file.num5     #記錄g_field陣列的筆數
   DEFINE l_source     STRING                  #記錄C:\tiptop\的路徑
   DEFINE l_target     STRING                  #記錄$TEMPDIR的路徑
   DEFINE l_cmd        STRING                  #儲存UNIX指令
   DEFINE l_symbol     LIKE type_file.chr10    #記錄分隔符號
   DEFINE l_channel    base.Channel            #讀檔用的通道
   DEFINE l_fname      LIKE type_file.chr1000  #錯誤訊息存放的路徑及檔名
   DEFINE l_i          LIKE type_file.num5     #迴圈計數用
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_char       LIKE type_file.chr1000  #儲存資料中的每個單一資料
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_data       STRING                  #檔案中的每筆資料
   DEFINE l_type       LIKE type_file.chr10    #判斷欄位的資料型態
   DEFINE l_value      STRING                  #INSERT SQL中的values子句
   DEFINE l_count      LIKE type_file.num5     #筆數
   DEFINE l_source1    STRING                  #FUN-A30066
   DEFINE p_ide05      LIKE ide_file.ide05     #FUN-A30066
   DEFINE l_idh        RECORD LIKE idh_file.*
   DEFINE l_pmn02      LIKE pmn_file.pmn02
   DEFINE l_pmn04      LIKE pmn_file.pmn04
   DEFINE l_imaicd08   LIKE imaicd_file.imaicd08
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04
   DEFINE l_codeset    STRING                  #No.MOD-8B0036 add
   DEFINE l_length     LIKE type_file.num5     #FUN-980035
   DEFINE l_txt_path   STRING                  #FUN-980035
   DEFINE l_imd11      LIKE imd_file.imd11     #FUN-A30066 
   DEFINE l_imdacti    LIKE imd_file.imdacti   #FUN-A30066

   IF cl_null(g_ide.ide01) OR cl_null(g_ide.ide02) THEN
      IF g_bgjob = 'N' THEN  #FUN-C30286
         CALL cl_err('',-400,0)
      END IF  #FUN-C30286
      RETURN
   END IF
 
   #--無單身資料就RETURN-------------
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idf_file
    WHERE idf01 = g_ide.ide01 AND idf02 = g_ide.ide02
   IF g_cnt = 0 THEN
      IF g_bgjob = 'N' THEN  #FUN-C30286
         CALL cl_err('','aws-068',0)
      END IF  #FUN-C30286
      RETURN
   END IF
 
   #--檢查單身需有維護採購單號、PARTNO---
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idf_file
    WHERE idf01 = g_ide.ide01 AND idf02 = g_ide.ide02
      AND idf05 = 'idh004' #採購單號
   IF g_cnt = 0 THEN
      IF g_bgjob = 'N' THEN  #FUN-C30286
         CALL cl_err('','aic-165',0)
      END IF  #FUN-C30286
      LET g_success = 'N'   #FUN-A30066
      RETURN
   END IF
 
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idf_file
    WHERE idf01 = g_ide.ide01 AND idf02 = g_ide.ide02
      AND idf05 = 'idh105' #PARTNO
   IF g_cnt = 0 THEN
      IF g_bgjob = 'N' THEN  #FUN-C30286
         CALL cl_err('','aic-165',0)
      END IF  #FUN-C30286
      LET g_success = 'N'   #FUN-A30066
      RETURN
   END IF
 
   #--上傳資料若存在的處理方式為1時，則拒絕上傳
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idh_file
    WHERE idh001 = g_ide.ide05
   IF g_cnt > 0 AND g_ide.ide07 = '1' THEN
      IF g_bgjob = 'N' THEN  #FUN-C30286
         CALL cl_err(g_ide.ide05,'aic-166',0)
      END IF  #FUN-C30286
      LET g_success = 'N'   #FUN-A30066
      RETURN
   END IF
 
   #--詢問是否上傳---
   IF g_bgjob = 'N' THEN   #FUN-A30066
      IF NOT cl_confirm('aic-167') THEN
         RETURN
      END IF
   END IF   #FUN-A30066
 
   #--抓取上傳基本資料單頭資料-------
   SELECT * INTO g_ide.* FROM ide_file
    WHERE ide01 = g_ide.ide01 AND ide02 = g_ide.ide02
   IF g_bgjob = 'Y' THEN         #FUN-A30066
      LET g_ide.ide04 = g_today  #FUN-A30066
      LET g_ide.ide05 = p_ide05  #FUN-A30066
   END IF                        #FUN-A30066
   
   #FUN-C30208---begin
   IF g_bgjob = 'N' THEN
      INPUT g_ide.ide04 WITHOUT DEFAULTS FROM ide04
         BEFORE FIELD ide04
            LET g_ide.ide04 = g_today
            DISPLAY g_ide.ide04 TO ide04  
         
         AFTER INPUT 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_success = 'N'
               RETURN
            END IF 
            IF cl_null(g_ide.ide04) THEN
               CONTINUE INPUT
            ELSE
               UPDATE ide_file SET ide04 = g_ide.ide04
                WHERE ide01 = g_ide.ide01
                  AND ide02 = g_ide.ide02
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('',SQLCA.SQLCODE,0)
               END IF
            END IF 

         ON ACTION CONTROLG 
            CALL cl_cmdask()
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      END INPUT 
   END IF 
   #FUN-C30208---end
   
   #--上傳作業一律處理所有單身欄位，忽視user對單身下條件(g_wc2)------
   LET g_sql = "SELECT * FROM idf_file ",
               " WHERE idf01 = '",g_ide.ide01 CLIPPED,"'",
               "   AND idf02 = '",g_ide.ide02 CLIPPED,"'",
               " ORDER BY idf03 "
   PREPARE p021_prepare1 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('p021_prepare1:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p021_curs1 CURSOR FOR p021_prepare1
 
   # --判斷分隔符號---------
   CASE g_ide.ide06
     WHEN '0'  LET l_symbol = ' '          #TAB
     WHEN '1'  LET l_symbol = ';'          #分號
     WHEN '2'  LET l_symbol = ','          #分號
     OTHERWISE EXIT CASE
   END CASE
 
   #--做錯誤訊息列印的準備事項---
   LET g_pdate = g_today
   LET g_copies = '1'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_lang
   SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aicp021'
   IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 80 END IF
   FOR l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
 
   #--組錯誤訊息檔存放路徑，並開啟寫入錯誤訊息REPORT----
   CALL cl_outnam('aicp021') RETURNING l_name
   START REPORT p021_upload_rep TO l_name
 
   BEGIN WORK
   LET g_success = 'Y'
 
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idh_file
    WHERE idh001 = g_ide.ide05
   IF g_cnt > 0 THEN
      #--上傳資料若存在的處理方式為0時，則先刪除idh_file中檔名相符的資料
      IF g_ide.ide07 = '0' THEN
         DELETE FROM idh_file WHERE idh001 = g_ide.ide05
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('del idh:',SQLCA.SQLCODE,0)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   END IF
 
   #LET l_target = FGL_GETENV("TEMPDIR")  #FUN-C30286
   #LET l_target = l_target CLIPPED,"/",g_ide.ide05 CLIPPED   #FUN-C30286
   #---若檔案在c:/tiptop/下時，則先load到$TOP/doc/aic/aicp021/廠商編號/類別/upload目錄下-----------	
   IF g_bgjob = 'Y' THEN  #FUN-A30066
      LET l_source = g_location CLIPPED,g_ide.ide05 CLIPPED #FUN-A30066
      LET l_target = g_location CLIPPED,g_ide.ide05 CLIPPED #FUN-C30286
   ELSE  #FUN-A30066
      LET l_source = "c:/tiptop/",g_ide.ide05 CLIPPED    #FUN-980035
     #LET l_target = FGL_GETENV("TEMPDIR")  #FUN-C30286  #TQC-C60190 mark
      LET l_target = FGL_GETENV("TOP"),"/doc/aic/aicp021/",g_ide.ide01 CLIPPED,"/",g_ide.ide02 CLIPPED,"/upload"  #TQC-C60190
      LET l_target = l_target CLIPPED,"/",g_ide.ide05 CLIPPED   #FUN-C30286
   END IF #FUN-A30066

#FUN-980035 --Begin
   LET l_length = l_target.getLength()
   LET l_type   = l_target.subString(l_length-2,l_length)
#FUN-980035 --End
   IF g_bgjob = 'N' THEN  #FUN-C30286
      IF g_ide.ide08 = 'Y' THEN
#        LET l_source = "c:/tiptop/",g_ide.ide05 CLIPPED #FUN-980035
         IF NOT cl_upload_file(l_source,l_target) THEN
               CALL cl_err(g_ide.ide05,'lib-212',0)
            ROLLBACK WORK
            RETURN
         END IF
#FUN-980035 --Begin
      ELSE
         #IF l_type <> "txt" AND l_type <> "CSV" THEN  #FUN-C30286
         IF l_type <> "txt" AND l_type <> "CSV" AND l_type <> "csv" THEN  #FUN-C30286
            IF NOT cl_download_file(l_target,l_source) THEN
               CALL cl_err('',"amd-021",1)
               DISPLAY "Download fail!!"
               LET g_success = 'N'
               RETURN
            END IF
         END IF
#FUN-980035 --End
      END IF
   END IF  #FUN-C30286
 
   LET ms_codeset=cl_get_codeset()
   LET l_codeset = ms_codeset
   IF ms_codeset.getIndexOf("BIG5", 1) OR (ms_codeset.getIndexOf("GB2312", 1)
      OR ms_codeset.getIndexOf("GBK",1) OR ms_codeset.getIndexOf("GB18030",1))
   THEN
      IF ms_locale = "ZH_TW" AND g_lang = '2' THEN
         LET l_codeset = "GB2312"
      END IF
      IF ms_locale = "ZH_CN" AND g_lang = '0' THEN
         LET l_codeset = "BIG5"
      END IF
   END IF
#FUN-980035 --Begin
   #IF l_type <> "txt" AND l_type <> "CSV" THEN #FUN-A10130   #FUN-C30286
   IF l_type <> "txt" AND l_type <> "CSV" AND l_type <> "csv" THEN   #FUN-C30286
      LET l_target = l_target.subString(1,l_target.getLength()-3),"txt"
      CALL p021_excel_to_txt(l_source,l_target,l_symbol)
   END IF
#FUN-980035 --End
 
   #---將$TEMPDIR下欲處理的檔案先行轉換為Unicode，並刪除舊檔案---
   IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
      #LET l_cmd="iconv -f ",l_codeset," -t UTF-8 ",g_ide.ide05 CLIPPED," > ",  #No.MOD-8B0036 add  #FUN-C30286
      #                                    g_ide.ide05 CLIPPED,".tmp"           #FUN-C30286
      LET l_cmd="iconv -f ",l_codeset," -t UTF-8 ",l_target CLIPPED," > ",      #FUN-C30286
                                           l_target CLIPPED,".tmp"              #FUN-C30286
      RUN l_cmd   #FUN-C30286
   ELSE                                                                         #No.FUN-B30176
      #LET l_cmd = "java -cp zhcode.jar zhcode -u8 ",g_ide.ide05 CLIPPED," > ", #FUN-C30286
      #                                    g_ide.ide05 CLIPPED,".tmp"           #FUN-C30286
      LET l_cmd = "java -cp zhcode.jar zhcode -u8 ",l_target CLIPPED," > ",     #FUN-C30286
                                           l_target CLIPPED,".tmp"              #FUN-C30286
      RUN l_cmd
   END IF    #FUN-A30038 
 
   #LET l_cmd="rm ",g_ide.ide05 CLIPPED   #FUN-C30286
   LET l_cmd="rm ",l_target CLIPPED
   RUN l_cmd
 
   #LET l_cmd="mv ",g_ide.ide05 CLIPPED,".tmp ",g_ide.ide05 CLIPPED  #FUN-C30286
   LET l_cmd="mv ",l_target CLIPPED,".tmp ",l_target CLIPPED
   RUN l_cmd
 
   #--逐筆抓取上傳基本資料單身資料----
   LET l_i = 1
   FOREACH p021_curs1 INTO g_idf2.*
      IF STATUS THEN
         CALL cl_err('p021_curs1:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF l_i = 1 AND NOT cl_null(g_idf2.idf04) THEN
         LET g_table = g_idf2.idf04
      END IF
      LET g_field[l_i].seq = g_idf2.idf03
      LET g_field[l_i].name = g_idf2.idf05
      LET l_i = l_i + 1
   END FOREACH
   LET l_rec_b = l_i-1
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF

#FUN-980035 --Begin
#  LET l_length = l_target.getLength()
#  LET l_type   = l_target.subString(l_length-3,l_length)
#  IF l_type <> "txt" THEN
#     CALL p021_excel_to_txt(l_target,l_symbol)
#  END IF
#FUN-980035 --End
 
   #--開始讀檔並做insert to idh_file----
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_target,"r")
   IF STATUS THEN
      CALL cl_err(l_target,'-808',1)
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_cnt = 0        # 預設完成筆數為0筆
   LET l_count = 1
   WHILE l_channel.read([l_data])
     #FUN-A30066--begin--modify-----
     # #略過第一行抬頭的部份
     #IF l_count = 1 THEN
     #   LET l_count = l_count + 1
     #   CONTINUE WHILE
     #END IF
 
      #資料由第g_ide.ide16行開始抓
      IF l_count < g_ide.ide16 THEN 
         LET l_count = l_count + 1
         CONTINUE WHILE
      END IF
     #FUN-A30066--end--modify----
 
      INITIALIZE l_idh.* TO NULL
 
 
      LET g_cnt = g_cnt + 1
      LET l_flag = 'N'
 
      FOR l_i = 1 TO l_rec_b
          CALL p021_find_data(l_data,l_symbol,g_field[l_i].seq)
               RETURNING l_n,l_char
          IF l_n = 1 THEN
             #---每行最後一筆資料可能會有斷行符號'/r'，因此要去除---
             IF l_i = l_rec_b THEN
                CALL p021_find_data(l_char,'\n',1) RETURNING l_n,l_char
             END IF
             LET g_data[l_i] = l_char
 
             CASE g_field[l_i].name
                WHEN 'idh001'  LET l_idh.idh001   = l_char   #檔案名稱
                WHEN 'idh0011' LET l_idh.idh0011  = l_char   #資料順序
                WHEN 'idh002'  LET l_idh.idh002   = l_char   #路徑
                WHEN 'idh003'  LET l_idh.idh003   = l_char   #回貨狀態
                WHEN 'idh004'  LET l_idh.idh004   = l_char   #採購單號
                WHEN 'idh005'  LET l_idh.idh005   = l_char   #採購單項次
                WHEN 'idh006'  LET l_idh.idh006   = l_char   #PartNo
                WHEN 'idh007'  LET l_idh.idh007   = l_char   #批號
                WHEN 'idh008'  LET l_idh.idh008   = l_char   #Testing Program
                WHEN 'idh009'  LET l_idh.idh009   = l_char   #RunCard No
                WHEN 'idh010'  LET l_idh.idh010   = l_char   #Prober Card
                WHEN 'idh011'  LET l_idh.idh011   = l_char   #PASS BIN
                WHEN 'idh012'  LET l_idh.idh012   = l_char   #Temperature
                WHEN 'idh013'  LET l_idh.idh013   = l_char   #Alarm yield
                WHEN 'idh014'  LET l_idh.idh014   = l_char   #Hold Yield
                WHEN 'idh015'  LET l_idh.idh015   = l_char   #Load Board
                WHEN 'idh016'  LET l_idh.idh016   = l_char   #Finish date
                WHEN 'idh017'  LET l_idh.idh017   = l_char   #收貨單
                WHEN 'idh018'  LET l_idh.idh018   = l_char   #收貨單項次
                WHEN 'idh019'  LET l_idh.idh019   = l_char   #no use
                WHEN 'idh020'  LET l_idh.idh020   = l_char   #刻號
                WHEN 'idh021'  LET l_idh.idh021   = l_char   #BIN
                WHEN 'idh022'  LET l_idh.idh022   = l_char   #PASS BIN否
                WHEN 'idh023'  LET l_idh.idh023   = l_char   #收貨數量
                WHEN 'idh024'  LET l_idh.idh024   = l_char   #Pass-出貨數量
                WHEN 'idh025'  LET l_idh.idh025   = l_char   #不良品數
                WHEN 'idh026'  LET l_idh.idh026   = l_char   #報廢數量
                WHEN 'idh027'  LET l_idh.idh027   = l_char   #Gross die
                WHEN 'idh028'  LET l_idh.idh028   = l_char   #Datecode
                WHEN 'idh029'  LET l_idh.idh029   = l_char   #Yield
                WHEN 'idh030'  LET l_idh.idh030   = l_char   #Test#
                WHEN 'idh031'  LET l_idh.idh031   = l_char   #deduct
                WHEN 'idh032'  LET l_idh.idh032   = l_char   #no use
                WHEN 'idh033'  LET l_idh.idh033   = l_char   #no use
                WHEN 'idh034'  LET l_idh.idh034   = l_char   #no use
                WHEN 'idh035'  LET l_idh.idh035   = l_char   #no use
                WHEN 'idh036'  LET l_idh.idh036   = l_char   #Bin1
                WHEN 'idh037'  LET l_idh.idh037   = l_char   #Bin2
                WHEN 'idh038'  LET l_idh.idh038   = l_char   #Bin3
                WHEN 'idh039'  LET l_idh.idh039   = l_char   #Bin4
                WHEN 'idh040'  LET l_idh.idh040   = l_char   #Bin5
                WHEN 'idh041'  LET l_idh.idh041   = l_char   #Bin6
                WHEN 'idh042'  LET l_idh.idh042   = l_char   #Bin7
                WHEN 'idh043'  LET l_idh.idh043   = l_char   #Bin8
                WHEN 'idh044'  LET l_idh.idh044   = l_char   #Bin9
                WHEN 'idh045'  LET l_idh.idh045   = l_char   #Bin10
                WHEN 'idh046'  LET l_idh.idh046   = l_char   #Bin11
                WHEN 'idh047'  LET l_idh.idh047   = l_char   #Bin12
                WHEN 'idh048'  LET l_idh.idh048   = l_char   #Bin13
                WHEN 'idh049'  LET l_idh.idh049   = l_char   #Bin14
                WHEN 'idh050'  LET l_idh.idh050   = l_char   #Bin15
                WHEN 'idh051'  LET l_idh.idh051   = l_char   #Bin16
                WHEN 'idh052'  LET l_idh.idh052   = l_char   #Bin17
                WHEN 'idh053'  LET l_idh.idh053   = l_char   #Bin18
                WHEN 'idh054'  LET l_idh.idh054   = l_char   #Bin19
                WHEN 'idh055'  LET l_idh.idh055   = l_char   #Bin20
                WHEN 'idh056'  LET l_idh.idh056   = l_char   #Bin21
                WHEN 'idh057'  LET l_idh.idh057   = l_char   #Bin22
                WHEN 'idh058'  LET l_idh.idh058   = l_char   #Bin23
                WHEN 'idh059'  LET l_idh.idh059   = l_char   #Bin24
                WHEN 'idh060'  LET l_idh.idh060   = l_char   #Bin25
                WHEN 'idh061'  LET l_idh.idh061   = l_char   #Bin26
                WHEN 'idh062'  LET l_idh.idh062   = l_char   #Bin27
                WHEN 'idh063'  LET l_idh.idh063   = l_char   #Bin28
                WHEN 'idh064'  LET l_idh.idh064   = l_char   #Bin29
                WHEN 'idh065'  LET l_idh.idh065   = l_char   #Bin30
                WHEN 'idh066'  LET l_idh.idh066   = l_char   #Bin31
                WHEN 'idh067'  LET l_idh.idh067   = l_char   #Bin32
                WHEN 'idh068'  LET l_idh.idh068   = l_char   #Bin33
                WHEN 'idh069'  LET l_idh.idh069   = l_char   #Bin34
                WHEN 'idh070'  LET l_idh.idh070   = l_char   #Bin35
                WHEN 'idh071'  LET l_idh.idh071   = l_char   #Bin36
                WHEN 'idh072'  LET l_idh.idh072   = l_char   #Bin37
                WHEN 'idh073'  LET l_idh.idh073   = l_char   #Bin38
                WHEN 'idh074'  LET l_idh.idh074   = l_char   #Bin39
                WHEN 'idh075'  LET l_idh.idh075   = l_char   #Bin40
                WHEN 'idh076'  LET l_idh.idh076   = l_char   #Bin41
                WHEN 'idh077'  LET l_idh.idh077   = l_char   #Bin42
                WHEN 'idh078'  LET l_idh.idh078   = l_char   #Bin43
                WHEN 'idh079'  LET l_idh.idh079   = l_char   #Bin44
                WHEN 'idh080'  LET l_idh.idh080   = l_char   #Bin45
                WHEN 'idh081'  LET l_idh.idh081   = l_char   #Bin46
                WHEN 'idh082'  LET l_idh.idh082   = l_char   #Bin47
                WHEN 'idh083'  LET l_idh.idh083   = l_char   #Bin48
                WHEN 'idh084'  LET l_idh.idh084   = l_char   #Bin49
                WHEN 'idh085'  LET l_idh.idh085   = l_char   #Bin50
                WHEN 'idh086'  LET l_idh.idh086   = l_char   #Bin51
                WHEN 'idh087'  LET l_idh.idh087   = l_char   #Bin52
                WHEN 'idh088'  LET l_idh.idh088   = l_char   #Bin53
                WHEN 'idh089'  LET l_idh.idh089   = l_char   #Bin54
                WHEN 'idh090'  LET l_idh.idh090   = l_char   #Bin55
                WHEN 'idh091'  LET l_idh.idh091   = l_char   #Bin56
                WHEN 'idh092'  LET l_idh.idh092   = l_char   #Bin57
                WHEN 'idh093'  LET l_idh.idh093   = l_char   #Bin58
                WHEN 'idh094'  LET l_idh.idh094   = l_char   #Bin59
                WHEN 'idh095'  LET l_idh.idh095   = l_char   #Bin99(other)
                WHEN 'idh096'  LET l_idh.idh096   = l_char   #STK ID
                WHEN 'idh097'  LET l_idh.idh097   = l_char   #Alarm Bin
                WHEN 'idh098'  LET l_idh.idh098   = l_char   #STATUS
                WHEN 'idh099'  LET l_idh.idh099   = l_char   #ID
                WHEN 'idh101'  LET l_idh.idh101   = l_char   #pass
                WHEN 'idh102'  LET l_idh.idh102   = l_char   #skip
                WHEN 'idh103'  LET l_idh.idh103   = l_char   #invoice no
                WHEN 'idh104'  LET l_idh.idh104   = l_char   #os_part no
                WHEN 'idh105'  LET l_idh.idh105   = l_char   #finsh_partno
                WHEN 'idh106'  LET l_idh.idh106   = l_char   #Qty
                WHEN 'idh107'  LET l_idh.idh107   = l_char   #lot no
                WHEN 'idh108'  LET l_idh.idh108   = l_char   #ship_date
                WHEN 'idh109'  LET l_idh.idh109   = l_char   #Wafer_No
                WHEN 'idh110'  LET l_idh.idh110   = l_char   #receipt_no
                WHEN 'idh111'  LET l_idh.idh111   = l_char   #外包單號
                WHEN 'idh112'  LET l_idh.idh112   = l_char   #等級
                WHEN 'idh113'  LET l_idh.idh113   = l_char   #進貨數量
                WHEN 'idh114'  LET l_idh.idh114   = l_char   #進貨片數
                WHEN 'idh115'  LET l_idh.idh115   = l_char   #出貨數量
                WHEN 'idh116'  LET l_idh.idh116   = l_char   #良率
                WHEN 'idh117'  LET l_idh.idh117   = l_char   #單價
                WHEN 'idh118'  LET l_idh.idh118   = l_char   #金額
                WHEN 'idh119'  LET l_idh.idh119   = l_char   #df1(無探針痕跡)
                WHEN 'idh120'  LET l_idh.idh120   = l_char   #df2(墨跡污染)
                WHEN 'idh121'  LET l_idh.idh121   = l_char   #df3(銲墊污染)
                WHEN 'idh122'  LET l_idh.idh122   = l_char   #df4(刮  傷)
                WHEN 'idh123'  LET l_idh.idh123   = l_char   #df5(崩  裂)
                WHEN 'idh124'  LET l_idh.idh124   = l_char   #df6(矽粉污染)
                WHEN 'idh125'  LET l_idh.idh125   = l_char   #df7(護層不良)
                WHEN 'idh126'  LET l_idh.idh126   = l_char   #df8(外物污染)
                WHEN 'idh127'  LET l_idh.idh127   = l_char   #df9(破 片)
                WHEN 'idh128'  LET l_idh.idh128   = l_char   #df10(暗  裂)
                WHEN 'idh129'  LET l_idh.idh129   = l_char   #df11(焊墊氧化)
                WHEN 'idh130'  LET l_idh.idh130   = l_char   #df12(焊墊腐蝕)
                WHEN 'idh131'  LET l_idh.idh131   = l_char   #df13(切割偏移)
                WHEN 'idh132'  LET l_idh.idh132   = l_char   #df14(水  痕)
                WHEN 'idh133'  LET l_idh.idh133   = l_char   #df15(液  滴)
                WHEN 'idh134'  LET l_idh.idh134   = l_char   #df16(短  少)
                WHEN 'idh135'  LET l_idh.idh135   = l_char   #df17(溢  出)
                WHEN 'idh136'  LET l_idh.idh136   = l_char   #df18(探針突出)
                WHEN 'idh137'  LET l_idh.idh137   = l_char   #df19(缺  角)
                WHEN 'idh138'  LET l_idh.idh138   = l_char   #df20(其他1)
                WHEN 'idh139'  LET l_idh.idh139   = l_char   #df21(其他2)
                WHEN 'idh140'  LET l_idh.idh140   = l_char   #df22(其他3)
                WHEN 'idh141'  LET l_idh.idh141   = l_char   #df23(其他4)
                WHEN 'idh142'  LET l_idh.idh142   = l_char   #df24(其他5)
                WHEN 'idh143'  LET l_idh.idh143   = l_char   #不良品總數
                WHEN 'idh144'  LET l_idh.idh144   = l_char   #轉檔否
                WHEN 'idh145'  LET l_idh.idh145   = l_char   #倉庫  #FUN-A30066
                WHEN 'idh146'  LET l_idh.idh146   = l_char   #儲位  #FUN-C30286
 
             END CASE
          ELSE
             CALL cl_getmsg('aic-168',g_lang) RETURNING g_msg
             OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
             LET g_success = 'N'
             LET l_flag = 'Y'
             EXIT FOR
          END IF
      END FOR
      IF l_flag = 'Y' THEN
         CONTINUE WHILE
      END IF
 
      # ---檢查採購單號及PARTNO是否皆不為NULL值---
      IF cl_null(l_idh.idh004) OR
         cl_null(l_idh.idh105) THEN
         CALL cl_getmsg('aic-165',g_lang) RETURNING g_msg
         OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
         LET g_success = 'N'
         CONTINUE WHILE
      END IF
      #廠商不符
      #MOD-D40141---begin
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM pmm_file
       WHERE pmm01 = l_idh.idh004
         AND pmm09 = g_ide.ide01
      IF l_n = 0 THEN
         CALL cl_getmsg('mfg3020',g_lang) RETURNING g_msg
         OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
         LET g_success = 'N'
         CONTINUE WHILE
      END IF 
      #MOD-D40141---end
      #---檢查採購單號是否存在且狀態為已發出---
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM pmm_file
       WHERE pmm01 = l_idh.idh004
         AND pmm25 = '2'
      IF l_n = 0 THEN
         CALL cl_getmsg('aic-169',g_lang) RETURNING g_msg
         OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
         LET g_success = 'N'
         CONTINUE WHILE
      ELSE
         #---若該採購單的性質不為委外採購(SUB)時，則項次不可為NULL值---
         LET g_pmm02 = NULL
         SELECT pmm02 INTO g_pmm02
           FROM pmm_file
          WHERE pmm01 = l_idh.idh004
         IF g_pmm02 <> 'SUB' THEN
            IF cl_null(l_idh.idh005) THEN
               CALL cl_getmsg('aic-170',g_lang) RETURNING g_msg
               OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
               LET g_success = 'N'
               CONTINUE WHILE
            END IF
         ELSE
            #---委外採購且沒有項次時，就去抓pmn_file的項次---
            #---正常情況只有一筆，所以抓到多筆就是錯---
            IF cl_null(l_idh.idh005) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM pmn_file
                WHERE pmn01 = l_idh.idh004
               IF l_n <> 1 THEN
                  CALL cl_getmsg('aic-171',g_lang) RETURNING g_msg
                  OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
                  LET g_success = 'N'
                  CONTINUE WHILE
               ELSE
                  LET l_pmn02 = NULL
                  SELECT pmn02 INTO l_pmn02
                    FROM pmn_file
                   WHERE pmn01 = l_idh.idh004
                  IF SQLCA.SQLCODE OR cl_null(l_pmn02) THEN
                     CALL cl_getmsg('aic-172',g_lang) RETURNING g_msg
                     OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
                     LET g_success = 'N'
                     CONTINUE WHILE
                  END IF
               END IF
            END IF
         END IF
      END IF
 
      #---若採購單不為委外採購或委外採購單且有採購項次時，需存在採購單身中---
      IF g_pmm02 <> 'SUB' OR
        (g_pmm02 = 'SUB' AND NOT cl_null(l_idh.idh005)) THEN
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM pmn_file
          WHERE pmn01 = l_idh.idh004
            AND pmn02 = l_idh.idh005
         IF l_n = 0 THEN
            CALL cl_getmsg('aic-173',g_lang) RETURNING g_msg
            OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
            LET g_success = 'N'
            CONTINUE WHILE
         END IF
      END IF
 
      #---檢查PARTNO需與採購料號相符---
      IF g_pmm02 <> 'SUB' OR
        (g_pmm02 = 'SUB' AND NOT cl_null(l_idh.idh005)) THEN
         LET l_pmn04 = NULL  LET g_pmniicd03 = NULL
         SELECT pmn04,pmniicd03
           INTO l_pmn04,g_pmniicd03
           FROM pmn_file,pmni_file
          WHERE pmn01 = l_idh.idh004
            AND pmn02 = l_idh.idh005
            AND pmni01=pmn01
            AND pmni02=pmn02
 
      ELSE
         LET l_pmn04 = NULL  LET g_pmniicd03 = NULL
         SELECT pmn04,pmniicd03
           INTO l_pmn04,g_pmniicd03
           FROM pmn_file,pmni_file
          WHERE pmn01 = l_idh.idh004
            AND pmn02 = l_pmn02
            AND pmni01=pmn01
            AND pmni02=pmn02
      END IF
      IF cl_null(l_pmn04) OR l_pmn04 <> l_idh.idh105 THEN
         CALL cl_getmsg('aic-174',g_lang) RETURNING g_msg
         OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
         LET g_success = 'N'
         CONTINUE WHILE
      END IF
 
      #取得該ICD作業編號之作業群組
      LET g_ecdicd01 = NULL
      IF NOT cl_null(g_pmniicd03) THEN
         SELECT ecdicd01 INTO g_ecdicd01
            FROM ecd_file
           WHERE ecd01 = g_pmniicd03
      END IF
 
      #---若為Turkey時，採購單+檔名在idh_file只可有一筆---
      #Turkey的判斷:改用作業編號之作業群組='6'判斷
      IF g_pmm02 = 'SUB' AND g_ecdicd01 = '6' THEN
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM idh_file
          WHERE idh001 = g_ide.ide05
            AND idh004 = l_idh.idh004
         IF l_n > 0 THEN
            CALL cl_getmsg('aic-175',g_lang) RETURNING g_msg
            OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
            LET g_success = 'N'
            CONTINUE WHILE
         END IF
      END IF
 
      #FUN-A30066--begin--add-----
      #檢查倉庫合法性
      IF NOT cl_null(l_idh.idh145) THEN
          LET l_imdacti = NULL
          LET l_imd11 = NULL
          LET g_errno = NULL
          SELECT imdacti,imd11 INTO l_imdacti,l_imd11 FROM imd_file
           WHERE imd01 = l_idh.idh145
      
          CASE WHEN SQLCA.SQLCODE = 100  
                    LET g_errno = 'aic-034'
               WHEN l_imd11 <> 'Y'
                    LET g_errno = 'mfg6080'
               WHEN l_imdacti='N'
                    LET g_errno = '9028'
          END CASE
      
          IF NOT cl_null(g_errno) THEN 
             CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
             OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
             LET g_success = 'N'
             CONTINUE WHILE
          END IF
      END IF
       #FUN-A30066--end--add---

      # ---檢查此採購單號+項次所對應的料件需作刻號管理(imaicd08='Y')---
      LET l_imaicd08 = NULL
      LET l_imaicd04 = NULL
      SELECT imaicd08,imaicd04 INTO l_imaicd08,l_imaicd04
        FROM imaicd_file
       WHERE imaicd00 = l_pmn04
    #調整成:料件狀態為'[0-2]'者,才需檢查需做刻號管理(imaicd08='Y')
      #IF l_imaicd04 MATCHES '[0-2]' AND l_imaicd08 != 'Y' THEN #FUN-BA0051 mark
      #FUN-C30208---begin
      #IF NOT s_icdbin(l_pmn04) THEN   #FUN-BA0051
      #   CALL cl_getmsg('aic-176',g_lang) RETURNING g_msg
      #   OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
      #   LET g_success = 'N'
      #   CONTINUE WHILE
      #END IF
      #FUN-C30208---end
      #CHI-830032...............begin  #此段不依客製的作法
      LET l_idh.idh001  = g_ide.ide05 CLIPPED
      LET l_idh.idh0011 = 0
      IF g_ide.ide08 = 'Y' THEN
         LET l_idh.idh002  = "c:/tiptop/"
      ELSE
         LET l_idh.idh002  = FGL_GETENV("TEMPDIR")
      END IF
      #FUN-A30066--begin--add---
      IF g_bgjob = 'Y' THEN
         LET l_idh.idh002 = g_location
      END IF
      #FUN-A30066--end---add-
      LET l_idh.idh003  = '1'
      LET l_idh.idh144  = 'N'
      SELECT MAX(idh0011) INTO l_idh.idh0011 FROM idh_file
       WHERE idh001=g_ide.ide05
      IF cl_null(l_idh.idh0011) THEN LET l_idh.idh0011 = 0 END IF
      LET l_idh.idh0011 = l_idh.idh0011 + 1
 
      LET l_idh.idhplant = g_plant     #FUN-980004 add plant & legal
      LET l_idh.idhlegal = g_legal     #FUN-980004 add plant & legal
 
      INSERT INTO idh_file VALUES (l_idh.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
         LET g_msg = "insert into idh:fail! ",g_msg CLIPPED
         OUTPUT TO REPORT p021_upload_rep(g_cnt,g_msg)
         LET g_success = 'N'
      END IF
 
   END WHILE
   CALL l_channel.close()
   FINISH REPORT p021_upload_rep
   IF g_success = 'Y' THEN
      COMMIT WORK
      IF g_bgjob = 'N' THEN  #FUN-A30066
         CALL cl_getmsg('aic-177',g_lang) RETURNING g_msg
         CALL cl_getmsg('aic-178',g_lang) RETURNING g_msg1
         LET l_char = g_cnt
         CALL p021_find_data(l_char,'.',1) RETURNING l_n,l_char
         LET g_msg = g_msg CLIPPED,' ',l_char CLIPPED,' ',g_msg1 CLIPPED
         CALL cl_err(g_msg,'!',1)
      END IF   #FUN-A30066
   ELSE
      ROLLBACK WORK
      IF g_bgjob = 'N' THEN   #FUN-A30066
         CALL cl_err('','abm-020',1)
         CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      END IF #FUN-A30066
 
      #---將系統預設的錯誤訊息檔名更新為user指定的檔名
      LET l_fname = NULL
      SELECT ide10+1 INTO l_fname
        FROM ide_file
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
      #---去除後面的小數點---
      CALL p021_find_data(l_fname,'.',1) RETURNING l_i,l_fname
 
      LET l_fname = FGL_GETENV('TEMPDIR'),"/",g_ide.ide05 CLIPPED,
                                          ".err.unload.",l_fname
      LET l_name = FGL_GETENV('TEMPDIR'),"/",l_name CLIPPED
 
      LET l_cmd = "mv ",l_name CLIPPED," ",l_fname CLIPPED
      RUN l_cmd
 
      #--將錯誤訊息檔的權限設到最大---
      IF os.Path.chrwx(l_fname CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
      #---有產生錯誤訊息檔時，要將ide10累加，以備下次上傳時的錯誤訊息檔
      #能用新的序號---
      UPDATE ide_file SET ide10 = ide10 + 1
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
   END IF
END FUNCTION
 
# ---依分隔符號傳回字串中第N個資料---
FUNCTION p021_find_data(p_str,p_symbol,p_ary)
   DEFINE p_str      STRING
   DEFINE p_symbol   LIKE type_file.chr10
   DEFINE p_ary      LIKE type_file.num5
   DEFINE l_count    LIKE type_file.num5
   DEFINE l_char     LIKE type_file.chr1000
   DEFINE l_i        LIKE type_file.num10
   DEFINE l_len      LIKE type_file.num10
 
   CALL p_str.getLength() RETURNING l_len
   LET l_count = 0
   FOR l_i = 1 TO l_len
       IF p_str.subString(l_i,l_i) = p_symbol THEN
          LET l_count = l_count + 1
          IF l_count = p_ary THEN
             EXIT FOR
          ELSE
             LET l_char = ''
          END IF
       ELSE
          LET l_char = l_char CLIPPED,p_str.subString(l_i,l_i)
       END IF
   END FOR
 
   IF l_count = p_ary THEN
      RETURN 1,l_char
   ELSE
      LET l_count = l_count + 1
      IF l_count = p_ary THEN
         RETURN 1,l_char
      ELSE
         LET l_char = ''
         RETURN 0,l_char
      END IF
   END IF
 
END FUNCTION
 
REPORT p021_upload_rep(p_no,p_msg)
DEFINE  l_last_sw  LIKE type_file.chr1
DEFINE  p_no       LIKE type_file.num5
DEFINE  p_msg      LIKE type_file.chr1000
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN 0
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
 
  FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-length(g_company))/2)+1,g_company CLIPPED
         IF cl_null(g_towhom) THEN
            PRINT '';
         ELSE
            PRINT 'TO:',g_towhom CLIPPED;
         END IF
         PRINT COLUMN (g_len-length(g_user)-5),'FROM:',g_user CLIPPED
         PRINT COLUMN ((g_len-length(g_x[1]))/2)+1,g_x[1] CLIPPED
         PRINT ''
         PRINT COLUMN 01,g_x[3] CLIPPED,g_pdate,' ',TIME,
               COLUMN g_len-10,g_x[4] CLIPPED,PAGENO USING '<<<'  #No.CHI-920025 add
         PRINT g_dash[1,g_len]
         PRINT COLUMN 01,g_x[11] CLIPPED,
               COLUMN 07,g_x[12] CLIPPED
         PRINT COLUMN 01,'-----',
               COLUMN 07,'------------------------------------------------------------------------------------------------------------------'
         LET l_last_sw = 'n'
 
      ON EVERY ROW
         PRINT COLUMN 01,p_no USING '<<<<<',
               COLUMN 07,p_msg[1,114]
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT COLUMN 01,g_x[5] CLIPPED,
               COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT COLUMN 01,g_x[5] CLIPPED,
                  COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
 
FUNCTION p021_trans(p_ide05) 
DEFINE l_name       LIKE type_file.chr20
DEFINE l_fname      LIKE type_file.chr1000
DEFINE l_i          LIKE type_file.num5
DEFINE l_cmd        LIKE type_file.chr1000  # 儲存UNIX指令
DEFINE l_idg42      LIKE idg_file.idg42
DEFINE l_pmm02      LIKE pmm_file.pmm02
DEFINE li_result    LIKE type_file.num5
DEFINE l_sfb06      LIKE sfb_file.sfb06
DEFINE l_imaicd08   LIKE imaicd_file.imaicd08
DEFINE l_turkey     LIKE type_file.chr1
DEFINE l_rvb        RECORD LIKE rvb_file.*  #備份用
DEFINE l_rvbi       RECORD LIKE rvbi_file.*  #備份用
DEFINE p_ide05      LIKE ide_file.ide05
DEFINE l_idg83      LIKE idg_file.idg83    #FUN-A30066
DEFINE l_smykind    LIKE smy_file.smykind  #FUN-A10130
DEFINE l_smyslip    LIKE smy_file.smyslip  #FUN-C30286

   INITIALIZE g_rva.* TO NULL   #FUN-C50106
   INITIALIZE g_rvb.* TO NULL   #FUN-C50106
   INITIALIZE g_rvbi.* TO NULL  #FUN-C50106
   
   IF cl_null(g_ide.ide01) OR
      cl_null(g_ide.ide02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ide.* FROM ide_file
    WHERE ide01 = g_ide.ide01
      AND ide02 = g_ide.ide02
   IF g_bgjob = 'Y'  THEN    #FUN-A30066
      LET g_ide.ide04 = g_today  #FUN-A30066
      LET g_ide.ide05 = p_ide05  #FUN-A30066
   END IF   #FUN-A30066
 
   #---未完成上傳作業，不可執行轉檔作業---
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM idh_file
    WHERE idh001 = g_ide.ide05
   IF g_cnt = 0 THEN
      CALL cl_err(g_ide.ide05,'aic-179',0)
      LET g_success = 'N'  #FUN-A30066
      RETURN
   END IF
 
   #---已完成轉檔作業，不可重覆執行轉檔作業---
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM idh_file
    WHERE idh001 = g_ide.ide05
      AND idh144 = 'Y'
   IF g_cnt > 0 THEN
      CALL cl_err(g_ide.ide05,'aic-180',0)
      LET g_success = 'N'  #FUN-A30066
      RETURN
   END IF
   #FUN-C30213---begin mark
   #--詢問是否轉檔---
   #IF g_bgjob = 'N' THEN   #FUN-A30066
   #   IF NOT cl_confirm('aic-181') THEN
   #      RETURN
   #   END IF
   #END IF   #FUN-A30066
   #FUN-C30213---end
 
   SELECT * INTO g_ide.* FROM ide_file
    WHERE ide01 = g_ide.ide01
      AND ide02 = g_ide.ide02
   IF g_bgjob = 'Y'  THEN    #FUN-A30066
      LET g_ide.ide04 = g_today  #FUN-A30066
      LET g_ide.ide05 = p_ide05  #FUN-A30066
   END IF   #FUN-A30066
 
   #--做錯誤訊息列印的準備事項---
   LET g_pdate = g_today
   LET g_copies = '1'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aicp021'
   IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 80 END IF
 
   FOR l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
 
   #--組錯誤訊息檔存放路徑，並開啟寫入錯誤訊息REPORT----
   CALL cl_outnam('aicp021') RETURNING l_name
   START REPORT p021_trans_rep TO l_name
 
   DECLARE p021_trans_curs1 CURSOR FOR
      SELECT * FROM idh_file
       WHERE idh001 = g_ide.ide05
 
   BEGIN WORK
   LET g_success = 'Y'
 
   INITIALIZE l_rvb.* TO NULL
   INITIALIZE l_rvbi.* TO NULL

   # ---先抓取參數檔---
   INITIALIZE g_ica.* TO NULL                             #FUN-C30286 add
   SELECT * INTO g_ica.* FROM ica_file WHERE ica00 = '0'  #FUN-C30286 add
 
   FOREACH p021_trans_curs1 INTO g_idh.*
      IF STATUS THEN
         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
         LET g_msg = "p021_trans_curs1:fail! ",g_msg CLIPPED
        #OUTPUT TO REPORT p021_trans_rep('','','',g_msg)    #FUN-A10130
         CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      INITIALIZE g_idg.* TO NULL #CHI-920083
      #---做轉檔前的資料正確性檢查-------
 
      #---1.檢查採購單存在且需為已發出---
      SELECT pmn04 INTO g_rvb05 FROM pmn_file WHERE pmn01=g_idh.idh004 AND pmn02=g_idh.idh005 #TQC-C30266

      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt
        FROM pmm_file
       WHERE pmm01 = g_idh.idh004
         AND pmm25 = '2'
      IF g_cnt = 0 THEN
         CALL cl_getmsg('aic-169',g_lang) RETURNING g_msg
        #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,'',g_msg)  #FUN-A10130
         CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')  #FUN-A10130
         LET g_success = 'N'
         CONTINUE FOREACH
      ELSE
         #---取得該採購單的性質---
         LET g_pmm02 = NULL
         SELECT pmm02 INTO g_pmm02
           FROM pmm_file
          WHERE pmm01 = g_idh.idh004
      END IF
 
      # ---2.再次檢查項次不可為空值---
      IF cl_null(g_idh.idh005) THEN
         CALL cl_getmsg('aic-173',g_lang) RETURNING g_msg
        #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,'',g_msg)     #FUN-A10130
         CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130 
         LET g_success = 'N'
         CONTINUE FOREACH
      ELSE
      #---3.檢查採購單及採購項次，需存在採購單身中---
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM pmn_file
          WHERE pmn01 = g_idh.idh004
            AND pmn02 = g_idh.idh005
         IF g_cnt = 0 THEN
            CALL cl_getmsg('aic-173',g_lang) RETURNING g_msg
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,     #FUN-A10130
           #                                g_idh.idh005,g_msg)  #FUN-A10130
            CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')  #FUN-A10130
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF
 
      #---抓取該採購單+項次的料件的料件狀態與刻號管理---
      LET g_imaicd04 = NULL  LET g_imaicd08 = NULL
      SELECT imaicd04,imaicd08
        INTO g_imaicd04,g_imaicd08
        FROM imaicd_file,pmn_file
       WHERE imaicd00 = pmn04
         AND pmn01 = g_idh.idh004
         AND pmn02 = g_idh.idh005
 
      IF SQLCA.SQLCODE OR cl_null(g_imaicd04) OR cl_null(g_imaicd08) THEN
         CALL cl_getmsg('aic-182',g_lang) RETURNING g_msg
        #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,g_idh.idh005,g_msg) #FUN-A10130
         CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')   #FUN-A10130
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
      #---4.檢查實收數量，不可小於零，且比照sapmt110中AFTER FIELD rvb07的檢查---
      IF cl_null(g_idh.idh024) OR g_idh.idh024 < 0 THEN
         CALL cl_getmsg('aic-194',g_lang) RETURNING g_msg
        #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,g_idh.idh005,g_msg)  #FUN-A10130
         CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')         #FUN-A10130
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
      #---5.料件狀態=1時，檢查idh020的ID數是否等於實收數量idh024
      #---再檢查idh020的每個ID數，不可超過3位數---
      IF g_imaicd04 = '1' OR g_imaicd04 = '0' THEN
         CALL p021_chk_id('1')
         IF NOT cl_null(g_errno) THEN
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,     #FUN-A10130
           #                                g_idh.idh005,g_msg)  #FUN-A10130
            CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      ELSE
      #---5.料件狀態<>1時，檢查idh020的每個ID數，不可超過3位數---
      #---再檢查idh020只能有一個ID數---
         CALL p021_chk_id('2')
         IF NOT cl_null(g_errno) THEN
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,     #FUN-A10130
           #                                g_idh.idh005,g_msg)  #FUN-A10130
            CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF
 
      #---開始轉檔作業---
      #---STEP 1.將idh_file轉至idg_file---
      IF g_rec_b2 = 0 THEN
         INITIALIZE g_idg.* TO NULL
         CALL p021_idg_def('1')
        #檢查已測Wafer回貨刻號明細,Die數不可為空白
         IF NOT cl_null(g_errno) THEN
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg = "Sign NO:",g_idg.idg20 CLIPPED,
                        ",BIN:",g_idg.idg21 CLIPPED,
                        ",",g_msg CLIPPED
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,              #FUN-A10130
           #                                g_idh.idh005,g_msg)
            CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')  #FUN-A10130
            LET g_success = 'N'  
         END IF
        #已測Wafer回貨(CP)pass bin檢查:
        #由該料號串pass bin檔,找不到用該料號之Wafer料號,再找不到用母體料號,
        #如果還是找不到,則不允許收貨,請user補入pass bin檔
         CALL p021_passbin_chk(g_idg.idg21)
         IF NOT cl_null(g_errno) AND g_errno != 'aic-183' THEN
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg = "Item NO:",g_rvb05 CLIPPED,
                        ",BIN:",g_idg.idg21 CLIPPED,
                        ",",g_msg CLIPPED
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,     #FUN-A10130
           #                                g_idh.idh005,g_msg)  #FUN-A10130
            CALL p021_trans_rep1('',g_idh.idh004, g_idh.idh005,g_msg,'N')  #FUN-A10130
            LET g_success = 'N'  
         END IF
        #CP回貨刻號檢查:若回貨刻號不存在發料刻號,出現錯誤訊息,
        #並詢問是否要寫入,如果Y則照樣寫入,如果N則產生失敗
         CALL p021_sign_chk()
         IF NOT cl_null(g_errno) THEN
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg = "Item NO:",g_rvb05 CLIPPED,
                        ",Sign NO:",g_idg.idg20 CLIPPED,
                        ",",g_msg CLIPPED
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,      #FUN-A10130
           #                                g_idh.idh005,g_msg)   #FUN-A10130
            CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
            LET g_success = 'N'  
         END IF
 
         LET g_idg.idg01 = ' '  #CHI-830032 後面會更新成收貨單號,先暫時給個代碼以便INS
         LET g_idg.idg02 = 0    #CHI-830032 後面會更新成收貨項次,先暫時給個代碼以便INS
         
         IF cl_null(g_idg.idgplant) THEN LET g_idg.idgplant = g_plant END IF  #TQC-C20109
         IF cl_null(g_idg.idglegal) THEN LET g_idg.idglegal = g_legal END IF  #TQC-C20109         
 
         INSERT INTO idg_file VALUES(g_idg.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
            LET g_msg = "Insert into idg:fail! ",g_msg CLIPPED
           #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,              #FUN-A10130
           #                                g_idh.idh005,g_msg)           #FUN-A10130
            CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')  #FUN-A10130
            LET g_success = 'N'
         END IF
      ELSE
         FOR g_cnt = 1 TO g_rec_b2
             INITIALIZE g_idg.* TO NULL
             CALL p021_idg_def('2')
            #檢查已測Wafer回貨刻號明細,Die數不可為空白
             IF NOT cl_null(g_errno) THEN
                CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
                LET g_msg = "Sign NO:",g_idg.idg20 CLIPPED,
                            ",BIN:",g_idg.idg21 CLIPPED,
                            ",",g_msg CLIPPED
               #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,             #FUN-A10130
               #                                g_idh.idh005,g_msg)          #FUN-A10130
                CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
                LET g_success = 'N'
             END IF
            #已測Wafer回貨(CP)pass bin檢查:
            #由該料號串pass bin檔,找不到用該料號之Wafer料號,再找不到用母體料號,
            #如果還是找不到,則不允許收貨,請user補入pass bin檔
             CALL p021_passbin_chk(g_idg.idg21)
             IF NOT cl_null(g_errno) AND g_errno != 'aic-183' THEN
                CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
                LET g_msg = "Item NO:",g_rvb05 CLIPPED,
                            ",BIN:",g_idg.idg21 CLIPPED,
                            ",",g_msg CLIPPED
               #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,                #FUN-A10130
               #                                   g_idh.idh005,g_msg)          #FUN-A10130 
                CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')    #FUN-A10130
                LET g_success = 'N'
             END IF
            #CP回貨刻號檢查:若回貨刻號不存在發料刻號,出現錯誤訊息,
            #並詢問是否要寫入,如果Y則照樣寫入,如果N則產生失敗
             CALL p021_sign_chk()
             IF NOT cl_null(g_errno) THEN
                CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
                LET g_msg = "Item NO:",g_rvb05 CLIPPED,
                            ",Sign NO:",g_idg.idg20 CLIPPED,
                            ",",g_msg CLIPPED
                #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,       #FUN-A10130
                #                                   g_idh.idh005,g_msg) #FUN-A10130
                 CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
                LET g_success = 'N'
             END IF
 
             LET g_idg.idg01 = ' '  #CHI-830032 後面會更新成收貨單號,先暫時給個代碼以便INS
             LET g_idg.idg02 = 0    #CHI-830032 後面會更新成收貨項次,先暫時給個代碼以便INS

             IF cl_null(g_idg.idgplant) THEN LET g_idg.idgplant = g_plant END IF   #TQC-C20109
             IF cl_null(g_idg.idglegal) THEN LET g_idg.idglegal = g_legal END IF   #TQC-C20109
         
             INSERT INTO idg_file VALUES(g_idg.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
                LET g_msg = "Insert into idg:fail! ",g_msg CLIPPED
               #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,        #FUN-A10130
               #                                g_idh.idh005,g_msg)     #FUN-A10130
                CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
                LET g_success = 'N'
                EXIT FOR
             END IF
         END FOR
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      ROLLBACK WORK
      FINISH REPORT p021_trans_rep
      CALL cl_err('','abm-020',1)
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
      #---將系統預設的錯誤訊息檔名更新為user指定的檔名
      LET l_fname = NULL
      SELECT ide11+1 INTO l_fname
        FROM ide_file
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
      #---去除後面的小數點---
      CALL p021_find_data(l_fname,'.',1) RETURNING l_i,l_fname
 
      LET l_fname = FGL_GETENV('TEMPDIR'),"/",g_ide.ide05 CLIPPED,
                                          ".err.tf.",l_fname
      LET l_name = FGL_GETENV('TEMPDIR'),"/",l_name CLIPPED
 
      LET l_cmd = "mv ",l_name CLIPPED," ",l_fname CLIPPED
      RUN l_cmd
 
      #--將錯誤訊息檔的權限設到最大---
      IF os.Path.chrwx(l_fname CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
      #---有產生錯誤訊息檔時，要將ide11累加，以備下次轉檔時的錯誤訊息檔
      #能用新的序號---
      UPDATE ide_file SET ide11 = ide11 + 1
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
      RETURN
   END IF
 
   # ---先抓取參數檔---
  #INITIALIZE g_ica.* TO NULL                             #FUN-C30286 移到前面
  #SELECT * INTO g_ica.* FROM ica_file WHERE ica00 = '0'  #FUN-C30286 移到前面
 
   # --- 產生rva_file及rvb_file ---
 
   LET g_sql = "SELECT idg04,idg05,idg07,idg42,pmm02,idg83,idg84,icf04,icf07,idg56 ",  #FUN-A30066  #TQC-A30130 del idg21 #FUN-A30092 #FUN-C30286 add idg84 #FUN-C90121 #FUN-CC0091
               "  FROM pmm_file,idg_file ",
               "  LEFT OUTER JOIN icf_file ON (icf01=idg44 AND icf02=idg21) ",#TQC-A30130
               " WHERE idg17 = '",g_ide.ide05 CLIPPED,"'",
               "   AND idg04 = pmm01 ", #(本次轉檔範圍)
               "   AND idg01 =' ' ", #收貨單號' ',表示尚未轉過檔
               " GROUP BY idg04,idg05,idg07,idg42,pmm02,idg83,idg84,icf04,icf07,idg56", #FUN-A30066  #TQC-A30130 del idg21 #FUN-A30092  #FUN-C30286 add idg84 #FUN-C90121 #FUN-CC0091
               " ORDER BY idg42,pmm02 "
   PREPARE p021_idg_pre1 FROM g_sql
   DECLARE p021_idg_curs1 CURSOR FOR p021_idg_pre1
 
   LET l_idg42 = NULL
   LET l_pmm02 = NULL
   LET g_wc = NULL
   LET g_rva01_str = NULL
   LET g_rva01_end = NULL
   FOREACH p021_idg_curs1 INTO g_idg04,g_idg05,g_idg07,
                              #g_idg42,g_pmm02,l_idg83,           #FUN-C30286 mark
                               g_idg42,g_pmm02,g_idg83,g_idg84,   #FUN-C30286
                               g_icf04,g_icf07,g_idg56  #FUN-A30066  #TQC-A30130 del g_idg21 #FUN-A30092 #FUN-C90121
      IF STATUS THEN
         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
         LET g_msg = "p021_idg_curs1:fail!! ",g_msg CLIPPED
        #OUTPUT TO REPORT p021_trans_rep('','','',g_msg) #FUN-A10130
         CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')   #FUN-A10130
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      IF cl_null(g_idg42) THEN
         LET g_idg42 = '@'
      END IF
 
      LET l_turkey = 'N'
      LET g_pmniicd03 = NULL LET g_pmn41 = NULL
      #多取得採購料號
      LET g_rvb05 = NULL
      SELECT pmniicd03,pmn41,pmn04
        INTO g_pmniicd03,g_pmn41,g_rvb05
        FROM pmn_file,pmni_file
       WHERE pmn01 = g_idg04
         AND pmn02 = g_idg05
         AND pmni01=pmn01
         AND pmni02=pmn02
 
      #再取得採購料號之料件狀態與展明細否
      LET g_imaicd08 = NULL
      LET g_imaicd04 = NULL
      SELECT imaicd08,imaicd04
        INTO g_imaicd08,g_imaicd04
        FROM imaicd_file
       WHERE imaicd00 = g_rvb05
 
      #取得該ICD作業編號之作業群組
      LET g_ecdicd01 = NULL
      IF NOT cl_null(g_pmniicd03) THEN
         SELECT ecdicd01 INTO g_ecdicd01
            FROM ecd_file
           WHERE ecd01 = g_pmniicd03
      END IF
 
      #委外Turkey採購單
      #Turkey的判斷:改用作業編號之作業群組='6'判斷
      IF g_pmm02 = 'SUB' AND g_ecdicd01 = '6' AND NOT cl_null(g_pmn41) THEN
         LET l_sfb06 = NULL
         SELECT sfb06 INTO l_sfb06
           FROM sfb_file
          WHERE sfb01 = g_pmn41
         IF NOT cl_null(l_sfb06) THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt
              FROM ecm_file
             WHERE ecm01 = g_pmn41
            IF g_cnt = 0 THEN
               call cl_getmsg('aic-184',g_lang) RETURNING g_msg
              #OUTPUT TO REPORT p021_trans_rep(g_idg42,g_idg04,  #FUN-A10130
              #                                g_idg05,g_msg)    #FUN-A10130 
               CALL p021_trans_rep1(g_idg42,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
               LET g_success = 'N'
               CONTINUE FOREACH
            ELSE
               LET l_turkey = 'Y'
            END IF
         END IF
      END IF
      #一個委外採購Turkey採購項次 產生一張收貨單
      #除外,By INVOICE NO + 採購性質 產生一張收貨單
      IF (cl_null(l_idg42) AND cl_null(l_pmm02)) OR
         ((l_idg42 != g_idg42) OR (l_pmm02 != g_pmm02)) OR
         l_turkey = 'Y' THEN
 
          INITIALIZE g_rva.* TO NULL
          LET g_rva.rva00 = '1'   #FUN-A10130
          LET g_rva.rva02 = g_idg04  #FUN-C30286
          LET g_rva.rva04 = 'N'                  #是否為L/C收料
          LET g_rva.rva05 = g_ide.ide01   #供應廠商
          IF cl_null(g_ide.ide04) THEN    #收貨單期
             LET g_rva.rva06 = g_today
          ELSE
             LET g_rva.rva06 = g_ide.ide04
          END IF
          IF g_idg42 = '@' THEN              #INVOICE-->進口報單
             LET g_rva.rva08 = NULL
          ELSE
             LET g_rva.rva08 = g_idg42
          END IF
          LET g_rva.rva10 = g_pmm02              #採購性質
          LET g_rva.rvaprsw = 'Y'
          LET g_rva.rvaprno = 0
          LET g_rva.rvaconf = 'N'
          LET g_rva.rvauser = g_user
          LET g_rva.rvagrup = g_grup
          LET g_rva.rvadate = g_today
          LET g_rva.rvaacti = 'Y'
          LET g_rva.rva29 = ' '             #FUN-870100 ADD
          LET g_rva.rva32 = '0'             #TQC-9C0151
          LET g_rva.rva33 = g_user          #TQC-C20111
          LET g_rva.rvamksg = 'N'           #TQC-9C0151
          LET g_rva.rvaoriu = g_user  #TQC-9C0151
          LET g_rva.rvaorig = g_grup  #TQC-9C0151
          LET g_rva.rvaspc = '0'      #TQC-9C0151
 
          LET g_rva.rvaplant = g_plant   #FUN-980004 add plant
          LET g_rva.rvalegal = g_legal   #FUN-980004 add legal
 
          SELECT pmm02 INTO l_pmm02
            FROM pmm_file
           WHERE pmm01 = g_idh.idh004
 
           LET g_rva.rva20 = 'N'
           LET g_rva.rva10 = l_pmm02
 
          SELECT smykind INTO l_smykind FROM smy_file WHERE smyslip=g_ide.ide03  #FUN-A10130
          CALL s_auto_assign_no("apm",g_ide.ide03,g_rva.rva06,
                                l_smykind,"rva_file","rva01","","","")
               RETURNING li_result,g_rva.rva01
          IF (NOT li_result) THEN
             CALL cl_getmsg('aic-184',g_lang) RETURNING g_msg
            #OUTPUT TO REPORT p021_trans_rep('',g_idg04,g_idg05,g_msg)      #FUN-A10130
             CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
             LET g_success = 'N'
             CONTINUE FOREACH
          END IF
          
          INSERT INTO rva_file VALUES(g_rva.*)
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
             LET g_msg = "INSERT INTO rva_file:fail! ",g_msg CLIPPED
            #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04, #FUN-A10130
            #                                g_idg05,g_msg)       #FUN-A10130
             CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
             LET g_success = 'N'
             CONTINUE FOREACH
          END IF
 
          IF cl_null(l_idg42) AND cl_null(l_pmm02) THEN
             LET g_rva01_str = g_rva.rva01
             LET g_wc = g_wc CLIPPED,"'",g_rva.rva01 CLIPPED,"'"
          ELSE
             LET g_rva01_end = g_rva.rva01
             LET g_wc = g_wc CLIPPED,",'",g_rva.rva01 CLIPPED,"'"
          END IF
          LET l_idg42 = g_idg42
          LET l_pmm02 = g_pmm02
      END IF
 
      LET g_pmniicd03 = NULL LET g_pmn41 = NULL
      SELECT pmniicd03,pmn41
        INTO g_pmniicd03,g_pmn41
        FROM pmn_file,pmni_file
       WHERE pmn01 = g_idg04
         AND pmn02 = g_idg05
         AND pmni01=pmn01
         AND pmni02=pmn02
 
      #取得該ICD作業編號之作業群組
      LET g_ecdicd01 = NULL
      IF NOT cl_null(g_pmniicd03) THEN
         SELECT ecdicd01 INTO g_ecdicd01
            FROM ecd_file
           WHERE ecd01 = g_pmniicd03
      END IF
 
      #委外Turkey採購單
      ##Turkey的判斷:改用作業編號之作業群組='6'判斷
      IF g_pmm02 = 'SUB' AND g_ecdicd01 = '6' AND NOT cl_null(g_pmn41) THEN
         LET l_sfb06 = NULL
         SELECT sfb06 INTO l_sfb06
           FROM sfb_file
          WHERE sfb01 = g_pmn41
         IF NOT cl_null(l_sfb06) THEN   #走製程的工單=>Turnkey工單
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt
              FROM ecm_file
             WHERE ecm01 = g_pmn41
            IF g_cnt = 0 THEN    #沒有抓到製程相關資料
               call cl_getmsg('aic-184',g_lang) RETURNING g_msg
              #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,         #FUN-A10130
              #                                g_idg05,g_msg)               #FUN-A10130
               CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
               LET g_success = 'N'
               CONTINUE FOREACH
            ELSE                #依照製程檔產生Trunkey收貨單單身
               DECLARE p021_ecm_cs CURSOR FOR
                  SELECT * FROM ecm_file
                   WHERE ecm01 = g_pmn41
               FOREACH p021_ecm_cs INTO g_ecm.*
                  IF STATUS THEN
                     CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
                     LET g_msg = "p021_ecm_cs:fail! ",g_msg CLIPPED
                    #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,         #FUN-A10130
                    #                                g_idg05,g_msg)               #FUN-A10130 
                     CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
 
                  INITIALIZE g_rvb.* TO NULL
                  INITIALIZE g_rvbi.* TO NULL
                  LET g_rvb.rvb42 = ' '         #FUN-870100 ADD
                  CALL p021_rvb_def()
                 #CALL p021_rvb_def1(l_rvb.*)            #FUN-C30286 mark
                  CALL p021_rvb_def1(l_rvb.*,l_rvbi.*)   #FUN-C30286
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
                    #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,         #FUN-A10130
                    #                                g_idg05,                     #FUN-A10130 
                    #                                g_msg)                       #FUN-A10130
                     CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  IF cl_null(g_rvb.rvb36) THEN LET g_rvb.rvb36=' ' END IF
                  IF cl_null(g_rvb.rvb37) THEN LET g_rvb.rvb37=' ' END IF
                  IF cl_null(g_rvb.rvb38) THEN LET g_rvb.rvb38=' ' END IF
                 #FUN-A30066
                  IF NOT cl_null(g_idg83) AND g_rvb.rvb36!='MISC' THEN  #FUN-C30286 mod
                     LET g_rvb.rvb36 = g_idg83                          #FUN-C30286 mod l->g
                  END IF
                 #FUN-A30066
                 #str FUN-C30286 add
                  IF NOT cl_null(g_idg84) AND g_rvb.rvb37!='MISC' THEN
                     LET g_rvb.rvb37 = g_idg84
                  END IF
                 #end FUN-C30286 add
                  INSERT INTO rvb_file VALUES(g_rvb.*)
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                     CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
                     LET g_msg = "insert rvb:fail! ",g_msg CLIPPED
                    #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,  #FUN-A10130
                    #                                g_idg05,g_msg)    #FUN-A10130
                     CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
                     LET g_success = 'N'
                     EXIT FOREACH
                  ELSE
                     LET g_rvbi.rvbi01=g_rvb.rvb01
                     LET g_rvbi.rvbi02=g_rvb.rvb02
                     IF NOT s_ins_rvbi(g_rvbi.*,'') THEN
                        LET g_success = 'N'
                        EXIT FOREACH
                     END IF
                     # --- 回寫idg_file ---
                     UPDATE idg_file SET idg01 = g_rvb.rvb01,
                                         idg02 = g_rvb.rvb02
                      WHERE idg04 = g_idg04
                        AND idg05 = g_idg05
                        AND idg07 = g_idg07 
                        AND idg83 = g_idg83  #FUN-C30286 add
                        AND idg84 = g_idg84  #FUN-C30286 add
                        AND idg17 = g_ide.ide05
                       #AND idg01 = ' ' AND idg02 = 0  #CHI-830032  依上面INS idg給的     #FUN-C30286 mark
                        AND ((idg01 = ' ' AND idg02 = 0)  #CHI-830032  依上面INS idg給的  #FUN-C30286 add
                         OR  (idg01 = g_rvb.rvb01))                                       #FUN-C30286 add
                     IF SQLCA.SQLCODE THEN
                        CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
                        LET g_msg = "update idg:fail! ",g_msg CLIPPED
                       #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,     #FUN-A10130 
                       #                                g_idg04,         #FUN-A10130
                       #                                g_idg05,g_msg)   #FUN-A10130
                        CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
                        LET g_success = 'N'
                        EXIT FOREACH
                     END IF
 
                     # --- 當需做刻號管理時，要產生idd_file ---
                    #調整成:料件狀態'[0-4]'者,都要產生idd_file
                    #IF g_imaicd04 MATCHES '[0-4]' THEN #FUN-A10130
                     #IF g_imaicd08 = 'Y' THEN           #FUN-A10130 #FUN-BA0051 mark
                     IF s_icdbin(g_rvb05) THEN   #FUN-BA0051
                       #CALL p021_ins_idd()  #FUN-A10130
                        CALL p021_ins_ida()  #FUN-A10130
                        IF NOT cl_null(g_errno) THEN
                           LET g_success = 'N'
                           EXIT FOREACH
                        END IF
                     END IF
                  END IF
                  LET l_rvb.* = g_rvb.*  #備份
                  LET l_rvbi.* = g_rvbi.*  #備份
               END FOREACH
               IF g_success = 'N' THEN
                  CONTINUE FOREACH
               END IF
            END IF
         ELSE       #不走製程的工單=>一般委外工單
            INITIALIZE g_rvb.* TO NULL
            INITIALIZE g_rvbi.* TO NULL
 
            CALL p021_rvb_def()
            CALL p021_rvb_def2()
            IF NOT cl_null(g_errno) THEN
               CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
              #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,        #FUN-A10130
              #                                g_idg05,g_msg)              #FUN-A10130 
               CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
 
            IF cl_null(g_rvb.rvb36) THEN LET g_rvb.rvb36=' ' END IF
            IF cl_null(g_rvb.rvb37) THEN LET g_rvb.rvb37=' ' END IF
            IF cl_null(g_rvb.rvb38) THEN LET g_rvb.rvb38=' ' END IF
            IF NOT cl_null(g_idg83) THEN LET g_rvb.rvb36 = g_idg83 END IF  #FUN-A30066  #FUN-C30286 mod l->g
            IF NOT cl_null(g_idg84) THEN LET g_rvb.rvb37 = g_idg84 END IF  #FUN-C30286
            IF cl_null(g_rvb.rvb42) THEN LET g_rvb.rvb42=' ' END IF #FUN-870100 ADD 
            INSERT INTO rvb_file VALUES(g_rvb.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
               LET g_msg = "insert rvb:fail! ",g_msg CLIPPED
              #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,   #FUN-A10130
              #                                g_idg05,g_msg)         #FUN-A10130
               CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
               LET g_success = 'N'
               CONTINUE FOREACH
            ELSE
               LET g_rvbi.rvbi01=g_rvb.rvb01
               LET g_rvbi.rvbi02=g_rvb.rvb02
               IF NOT s_ins_rvbi(g_rvbi.*,'') THEN
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
 
               # --- 回寫idg_file ---
               UPDATE idg_file SET idg01 = g_rvb.rvb01,
                                   idg02 = g_rvb.rvb02
                WHERE idg04 = g_idg04
                  AND idg05 = g_idg05
                  AND idg17 = g_ide.ide05
                  AND idg07 = g_idg07 
                  AND idg83 = g_idg83  #FUN-C30286 add
                  AND idg84 = g_idg84  #FUN-C30286 add
                  AND idg01 = ' '      #FUN-920080
                  AND idg02 = 0        #FUN-920080                  
 
               IF SQLCA.SQLCODE THEN
                  CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
                  LET g_msg = "update idh:fail! ",g_msg CLIPPED
                 #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,  #FUN-A10130
                 #                                g_idg05,g_msg)        #FUN-A10130
                  CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
 
               # --- 當需做刻號管理時，要產生idd_file ---
             #調整成:料件狀態'[0-4]',都要產生idd_file
               #IF g_imaicd04 MATCHES '[0-4]' THEN #FUN-A10130
                #IF g_imaicd08 = 'Y' THEN           #FUN-A10130 #FUN-BA0051 mark
                IF s_icdbin(g_rvb05) THEN   #FUN-BA0051
                 #CALL p021_ins_idd()  #FUN-A10130
                  CALL p021_ins_ida()  #FUN-A10130
                  IF NOT cl_null(g_errno) THEN
                     LET g_success = 'N'
                     CONTINUE FOREACH
                  END IF
                END IF
            END IF
         END IF
      ELSE
         INITIALIZE g_rvb.* TO NULL
         INITIALIZE g_rvbi.* TO NULL
 
         CALL p021_rvb_def()
         CALL p021_rvb_def2()
         IF NOT cl_null(g_errno) THEN
            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
           #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,        #FUN-A10130
           #                                g_idg05,g_msg)              #FUN-A10130  
            CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
 
         IF cl_null(g_rvb.rvb36) THEN LET g_rvb.rvb36=' ' END IF
         IF cl_null(g_rvb.rvb37) THEN LET g_rvb.rvb37=' ' END IF
         IF cl_null(g_rvb.rvb38) THEN LET g_rvb.rvb38=' ' END IF
         IF cl_null(g_rvb.rvb42) THEN LET g_rvb.rvb42=' ' END IF #FUN-870100
         IF NOT cl_null(g_idg83) THEN LET g_rvb.rvb36 = g_idg83 END IF  #FUN-A30066  #FUN-C30286 mod l->g
         IF NOT cl_null(g_idg84) THEN LET g_rvb.rvb37 = g_idg84 END IF  #FUN-C30286
         INSERT INTO rvb_file VALUES(g_rvb.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
            LET g_msg = "insert rvb:fail! ",g_msg CLIPPED
           #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,        #FUN-A10130
           #                                g_idg05,g_msg)              #FUN-A10130 
            CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
            LET g_success = 'N'
            CONTINUE FOREACH
         ELSE
            LET g_rvbi.rvbi01=g_rvb.rvb01
            LET g_rvbi.rvbi02=g_rvb.rvb02
            IF NOT s_ins_rvbi(g_rvbi.*,'') THEN
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            # --- 回寫idg_file ---
            UPDATE idg_file SET idg01 = g_rvb.rvb01,
                                idg02 = g_rvb.rvb02
             WHERE idg04 = g_idg04
               AND idg05 = g_idg05
               AND idg07 = g_idg07 
               AND idg83 = g_idg83  #FUN-C30286 add
               AND idg84 = g_idg84  #FUN-C30286 add
               AND idg17 = g_ide.ide05
               AND idg01 = ' '      #CHI-830032
               AND idg02 = 0        #CHI-830032
            IF SQLCA.SQLCODE THEN
               CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
               LET g_msg = "update idg:fail! ",g_msg CLIPPED
              #OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_idg04,  #FUN-A10130
              #                                g_idg05,g_msg)        #FUN-A10130
               CALL p021_trans_rep1(g_rva.rva08,g_idg04,g_idg05,g_msg,'N') #FUN-A10130
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
 
            # --- 當需做刻號管理時，要產生idd_file ---
            #調整成:料件狀態'[0-4]'者,都要產生idd_file
           #IF g_imaicd04 MATCHES '[0-4]' THEN #FUN-A10130
            #IF g_imaicd08 = 'Y' THEN           #FUN-A10130 #FUN-BA0051
            IF s_icdbin(g_rvb05) THEN   #FUN-BA0051
              #CALL p021_ins_idd()   #FUN-A10130
               CALL p021_ins_ida()   #FUN-A10130
               IF NOT cl_null(g_errno) THEN
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      ROLLBACK WORK
      FINISH REPORT p021_trans_rep
      CALL cl_err('','abm-020',1)
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
      #---將系統預設的錯誤訊息檔名更新為user指定的檔名
      LET l_fname = NULL
      SELECT ide11+1 INTO l_fname
        FROM ide_file
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
      #---去除後面的小數點---
      CALL p021_find_data(l_fname,'.',1) RETURNING l_i,l_fname
 
      LET l_fname = FGL_GETENV('TEMPDIR'),"/",g_ide.ide05 CLIPPED,
                                          ".err.tf.",l_fname
      LET l_name = FGL_GETENV('TEMPDIR'),"/",l_name CLIPPED
 
      LET l_cmd = "mv ",l_name CLIPPED," ",l_fname CLIPPED
      RUN l_cmd
 
      #--將錯誤訊息檔的權限設到最大---
      IF os.Path.chrwx(l_fname CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
      #---有產生錯誤訊息檔時，要將ide11累加，以備下次轉檔時的錯誤訊息檔
      #能用新的序號---
      UPDATE ide_file SET ide11 = ide11 + 1
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
      RETURN
   END IF
 
   # ---將產生的收貨單據做確認---
   LET g_wc=g_wc.trim()
   IF g_wc.substring(1,1)=',' THEN
      LET g_wc=g_wc.substring(2,g_wc.getlength())
   END IF
 
   LET g_sql = "SELECT * FROM rva_file ",
               " WHERE rva01 IN(",g_wc CLIPPED,")"
   PREPARE p021_rva_conf_pre FROM g_sql
   DECLARE p021_rva_conf_cs CURSOR FOR p021_rva_conf_pre
   INITIALIZE g_rva.* TO NULL   #FUN-C50106
   FOREACH p021_rva_conf_cs INTO g_rva.*
      IF STATUS THEN
         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
         LET g_msg = "p021_rva_conf_cs:fail! ",g_msg CLIPPED
        #OUTPUT TO REPORT p021_trans_rep('','','',g_msg)  #FUN-A10130
         CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
#FUN-A10130--begin--modify-------
#     CALL p021_rva_conf()    
#     IF NOT cl_null(g_errno) THEN
#        LET g_success = 'N'
#        CONTINUE FOREACH
#     END IF

      #FUN-C30286---begin
      LET l_smyslip=s_get_doc_no(g_rva.rva01)
      SELECT smydmy4,smyapr INTO g_smy.smydmy4,g_smy.smyapr FROM smy_file WHERE smyslip = l_smyslip
      IF g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN
      #FUN-C30286---end
         CASE g_rva.rva10
           WHEN 'SUB'
             LET g_prog='apmt200_icd'
             #CALL t110sub_y_chk(g_rva.rva01,' ','SUB','1') #CHI-C30118 mark
             CALL t110sub_y_chk(g_rva.rva01,TRUE,'N',' ','SUB','1','1') #CHI-C30118 add
             IF g_success = "Y" THEN
                CALL t110sub_y_upd(g_rva.rva01,TRUE,'N',' ','SUB','1','1')
             END IF
           OTHERWISE
             LET g_prog='aict041'
             #CALL t110sub_y_chk(g_rva.rva01,' ','ICD','1') #CHI-C30118 mark
             CALL t110sub_y_chk(g_rva.rva01,TRUE,'N',' ','ICD','1','1') #CHI-C30118 add
             IF g_success = "Y" THEN
                CALL t110sub_y_upd(g_rva.rva01,TRUE,'N',' ','ICD','1','1')
             END IF
         END CASE
      END IF   #FUN-C30286
      LET g_prog='aicp021'
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
#FUN-A10130--end---modify--------------
   END FOREACH
   FINISH REPORT p021_trans_rep
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_getmsg('aic-185',g_lang) RETURNING g_msg
      LET g_msg = g_msg CLIPPED,' ',g_rva01_str CLIPPED
      IF NOT cl_null(g_rva01_end) THEN
         LET g_msg = g_msg CLIPPED,' ~ ',g_rva01_end CLIPPED
      END IF
      IF g_bgjob = 'N' THEN   #FUN-A30066
      CALL cl_err(g_msg,'!',1)
      END IF   #FUN-A30066
      UPDATE idh_file SET idh144 = 'Y'
       WHERE idh001 = g_ide.ide05
      IF g_bgjob = 'Y' THEN                        #FUN-A10130
         CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'Y')  #FUN-A10130
      END IF                                       #FUN-A10130
   ELSE
      ROLLBACK WORK
      IF g_bgjob = 'N' THEN   #FUN-A30066
      CALL cl_err('','abm-020',1)
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      END IF   #FUN-A30066
 
      IF g_bgjob = 'Y' THEN                        #FUN-A10130
         CALL cl_getmsg('abm-020',g_lang) RETURNING g_msg   #FUN-A10130
         CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')  #FUN-A10130
      END IF                                       #FUN-A10130
      #---將系統預設的錯誤訊息檔名更新為user指定的檔名
      LET l_fname = NULL
      SELECT ide11+1 INTO l_fname
        FROM ide_file
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
      #---去除後面的小數點---
      CALL p021_find_data(l_fname,'.',1) RETURNING l_i,l_fname
 
      LET l_fname = FGL_GETENV('TEMPDIR'),"/",g_ide.ide05 CLIPPED,
                                          ".err.tf.",l_fname
      LET l_name = FGL_GETENV('TEMPDIR'),"/",l_name CLIPPED
 
      LET l_cmd = "mv ",l_name CLIPPED," ",l_fname CLIPPED
      RUN l_cmd
 
      #--將錯誤訊息檔的權限設到最大---
      IF os.Path.chrwx(l_fname CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
      #---有產生錯誤訊息檔時，要將ide11累加，以備下次轉檔時的錯誤訊息檔
      #能用新的序號---
      UPDATE ide_file SET ide11 = ide11 + 1
       WHERE ide01 = g_ide.ide01
         AND ide02 = g_ide.ide02
 
   END IF
END FUNCTION
 
#FUNCTION p021_rvb07(p_cmd,p_key)
FUNCTION p021_rvb07(p_cmd,p_key,p_cmd2)
  DEFINE  p_cmd      LIKE type_file.chr1
  DEFINE  p_key      LIKE rvb_file.rvb07
  DEFINE  l_pmn07    LIKE pmn_file.pmn07
  DEFINE  l_pmn41    LIKE pmn_file.pmn41
  DEFINE  l_sfb05    LIKE sfb_file.sfb05
  DEFINE  l_sfb39    LIKE sfb_file.sfb39
  DEFINE  l_sfb93    LIKE sfb_file.sfb93
  DEFINE  l_rvb07    LIKE rvb_file.rvb07
  DEFINE  l_rvb07_1  LIKE rvb_file.rvb07
  DEFINE  l_rvb07_2  LIKE rvb_file.rvb07
  DEFINE  l_rvb07_3  LIKE rvb_file.rvb07
  DEFINE  l_rvb07_4  LIKE rvb_file.rvb07
  DEFINE  l_pmm02    LIKE pmm_file.pmm02
  DEFINE  l_pmniicd03 LIKE pmni_file.pmniicd03
  DEFINE  l_rvb01    LIKE rvb_file.rvb01
  DEFINE  l_rvb01_t  LIKE rvb_file.rvb01
  DEFINE  l_rvb02    LIKE rvb_file.rvb02
  DEFINE  l_imaicd04   LIKE imaicd_file.imaicd04  #料件狀態
  DEFINE  p_cmd2        LIKE type_file.chr1  #a:def rvb時  t:ins idd時
  DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053
  DEFINE  l_pmniicd13  LIKE pmni_file.pmniicd13 #FUN-950040
 
  LET g_errno = ''
 
  #取得料件狀態
  LET l_imaicd04 = ''
  SELECT imaicd04 INTO l_imaicd04
     FROM imaicd_file
    WHERE imaicd00 = g_rvb.rvb05
  #料件狀態='2'的,移到ins idd之後的upd_rvb()後再檢查數量正確性
  IF l_imaicd04 = '2' AND p_cmd2 = 'a' THEN RETURN END IF
 
  IF p_cmd = '1' THEN
     SELECT pmm02 INTO g_pmm02
       FROM pmm_file
      WHERE pmm01 = g_idh.idh004
 
     #取得部份交貨否資訊(pmn14)
     SELECT pmn07,pmn13,pmn20,pmn41,pmn50-pmn55,pmn14
       INTO l_pmn07,g_pmn13,g_pmn20,l_pmn41,g_pmn50_55,g_pmn14
       FROM pmn_file
      WHERE pmn01 = g_idh.idh004
        AND pmn02 = g_idh.idh005
  ELSE
     SELECT pmm02 INTO g_pmm02
       FROM pmm_file
      WHERE pmm01 = g_idg04
 
 
    #取得部份交貨否資訊(pmn14)
     SELECT pmn07,pmn13,pmn20,pmn41,pmn50-pmn55,pmn14
       INTO l_pmn07,g_pmn13,g_pmn20,l_pmn41,g_pmn50_55,g_pmn14
       FROM pmn_file
      WHERE pmn01 = g_idg04
        AND pmn02 = g_idg05
  END IF
  IF cl_null(g_pmn13) THEN
     LET g_pmn13 = 0
  END IF
  IF cl_null(g_pmn20) THEN
     LET g_pmn20 = 0
  END IF
  IF cl_null(g_pmn50_55) THEN
     LET g_pmn50_55 = 0
  END IF
 
  IF NOT cl_null(l_pmn41) THEN
     SELECT sfb05,sfb39,sfb93
       INTO l_sfb05,l_sfb39,l_sfb93
       FROM sfb_file
      WHERE sfb01 = l_pmn41
     IF SQLCA.SQLCODE THEN
        LET l_sfb05 = NULL
        LET l_sfb39 = NULL
        LET l_sfb93 = NULL
     END IF
  END IF
 
  IF p_cmd = '1' THEN
     LET l_pmm02 = NULL
     SELECT pmm02 INTO l_pmm02
       FROM pmm_file
      WHERE pmm01 = g_idh.idh004
 
     LET l_pmniicd03 = NULL
     SELECT pmniicd03 INTO l_pmniicd03
       FROM pmn_file
      WHERE pmn01 = g_idh.idh004
        AND pmn02 = g_idh.idh005
 
     IF NOT(l_pmm02 = 'SUB' AND l_pmniicd03 = '12') THEN
        SELECT SUM(rvb07) INTO l_rvb07_3
          FROM rva_file,rvb_file
         WHERE rva01 = rvb01
           AND rvaconf = 'N'
           AND rvb04 = g_idh.idh004
           AND rvb03 = g_idh.idh005
           AND rvb35 = 'N'
     ELSE
        LET l_rvb01_t = NULL
        LET l_rvb07_3 = 0
        DECLARE p021_rvb07_cs1 CURSOR FOR
          SELECT rvb01,rvb02,rvb07 FROM rva_file,rvb_file
           WHERE rva01 = rvb01
             AND rvaconf = 'N'
             AND rvb04 = g_idh.idh004
             AND rvb03 = g_idh.idh005
             AND rvb35 = 'N'
           ORDER BY rvb01,rvb02
 
        FOREACH p021_rvb07_cs1 INTO l_rvb01,l_rvb02,l_rvb07_4
          IF cl_null(l_rvb01_t) OR l_rvb01 != l_rvb01_t THEN
             LET l_rvb01_t = l_rvb01
          ELSE
             CONTINUE FOREACH
          END IF
 
          LET l_rvb07_3 = l_rvb07_3 + l_rvb07_4
        END FOREACH
     END IF
  ELSE
     LET l_pmm02 = NULL
     SELECT pmm02 INTO l_pmm02
       FROM pmm_file
      WHERE pmm01 = g_idg04
 
     LET l_pmniicd03 = NULL
     SELECT pmniicd03 INTO l_pmniicd03
       FROM pmni_file
      WHERE pmni01 = g_idg04
        AND pmni02 = g_idg05
 
     LET g_ecdicd01 = ''
     SELECT ecdicd01 INTO g_ecdicd01
        FROM ecd_file
      WHERE ecd01 = l_pmniicd03
 
     IF NOT(l_pmm02 = 'SUB' AND g_ecdicd01 = '6') THEN
        SELECT SUM(rvb07) INTO l_rvb07_3
          FROM rva_file,rvb_file
         WHERE rva01 = rvb01
           AND rvaconf = 'N'
           AND rvb04 = g_idg04
           AND rvb03 = g_idg05
           AND rvb35 = 'N'
           AND NOT (rvb01 = g_rva.rva01 AND rvb02 = g_rvb.rvb02)
     ELSE
        LET l_rvb01_t = NULL
        LET l_rvb07_3 = 0
        DECLARE p021_rvb07_cs2 CURSOR FOR
          SELECT rvb01,rvb02,rvb07 FROM rva_file,rvb_file
           WHERE rva01 = rvb01
             AND rvaconf = 'N'
             AND rvb04 = g_idg04
             AND rvb03 = g_idg05
             AND rvb35 = 'N'
             AND NOT (rvb01 = g_rva.rva01)
           ORDER BY rvb01,rvb02
 
        FOREACH p021_rvb07_cs2 INTO l_rvb01,l_rvb02,l_rvb07_4
          IF cl_null(l_rvb01_t) OR l_rvb01 != l_rvb01_t THEN
             LET l_rvb01_t = l_rvb01
          ELSE
             CONTINUE FOREACH
          END IF
 
          LET l_rvb07_3 = l_rvb07_3 + l_rvb07_4
        END FOREACH
     END IF
  END IF
  IF cl_null(l_rvb07_3) THEN
     LET l_rvb07_3 = 0
  END IF
 
  #本采購單累積被衝銷量
   SELECT pmniicd13 INTO l_pmniicd13 FROM pmni_file
    WHERE pmni01 = g_idg04
      AND pmni02 = g_idg05
 
   IF cl_null(l_pmniicd13) THEN
      LET l_pmniicd13 = 0
   END IF
  #--計算已交量---
  LET l_rvb07 = g_pmn50_55+l_rvb07_3+p_key+l_pmniicd13  #FUN-950040
  LET l_rvb07_1 = (g_pmn20*(100+g_pmn13))/100   #可交貨量
  LET l_rvb07_2 = (g_pmn20*(100-g_pmn13))/100
 
  IF g_pmn13 >= 0 THEN
     IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
        IF l_rvb07_2 > l_rvb07 THEN
           IF g_sma.sma85 MATCHES '[Rr]' THEN
              LET g_errno = 'mfg3038'
              RETURN
           END IF
        END IF
        # 樣品不檢查
        IF l_rvb07_1 < l_rvb07 THEN #超交
           IF g_sma.sma85 MATCHES '[Rr]' THEN
              LET g_errno = 'mfg3037'
              RETURN
           END IF
        END IF
     END IF
     IF g_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
        # 樣品不檢查
        IF l_rvb07_1 < l_rvb07 THEN #超交
           IF g_sma.sma85 MATCHES '[Rr]' THEN
              LET g_errno = 'mfg3037'
              RETURN
           END IF
        END IF
     END IF
  END IF
 
  IF g_pmn13 < 0 THEN    #控制超短交
     IF g_pmn14 = 'N' THEN   #不能部份交貨
        IF l_rvb07 - g_pmn20 < 0 THEN      #須>= 訂購量
           LET g_errno = 'mfg3335'
           RETURN
        END IF
     END IF
  END IF
 
  IF p_cmd = '2' AND l_sfb39 != '2' THEN   #工單完工方式為'2'
     IF g_pmm02 ='SUB' AND g_rvb.rvb05=l_sfb05 AND l_sfb93 != 'Y' THEN
        LET g_min_set = 0
        CALL s_get_ima153(g_rvb.rvb05) RETURNING l_ima153  #FUN-910053  
  #     CALL s_minp(g_rvb.rvb34,g_sma.sma73,l_ima153,'','','')   #FUN-A60027 #FUN-C70037 mark
        CALL s_minp(g_rvb.rvb34,g_sma.sma73,l_ima153,'','','',g_rva.rva06)       #FUN-C70037
             RETURNING g_cnt,g_min_set
     END IF
  END IF
 
  IF p_cmd = '2' THEN
     CALL p021_set_rvb87()
     IF cl_null(g_rvb.rvb86) THEN
        LET g_rvb.rvb86 = l_pmn07
        LET g_rvb.rvb87 = p_key
        LET g_rvb.rvb87 = s_digqty(g_rvb.rvb87,g_rvb.rvb86) #FUN-BB0083 add
     END IF
  END IF
END FUNCTION
 
FUNCTION p021_set_rvb87()
 DEFINE    l_item   LIKE img_file.img01,     #料號
           l_ima25  LIKE ima_file.ima25,     #ima單位
           l_ima44  LIKE ima_file.ima44,     #ima單位
           l_ima906 LIKE ima_file.ima906,
           l_fac2   LIKE img_file.img21,     #第二轉換率
           l_qty2   LIKE img_file.img10,     #第二數量
           l_fac1   LIKE img_file.img21,     #第一轉換率
           l_qty1   LIKE img_file.img10,     #第一數量
           l_tot    LIKE img_file.img10,     #計價數量
           l_factor LIKE ima_file.ima31_fac
 
 
   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=g_rvb.rvb05
   IF SQLCA.sqlcode = 100 THEN
      IF g_rvb.rvb05 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
 
   LET l_fac2=g_rvb.rvb84
   LET l_qty2=g_rvb.rvb85
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=g_rvb.rvb81
      LET l_qty1=g_rvb.rvb82
   ELSE
      LET l_fac1=1
      LET l_qty1=g_rvb.rvb07
      CALL s_umfchk(g_rvb.rvb04,g_rvb.rvb07,l_ima44)
            RETURNING g_cnt,l_fac1
      IF g_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
   END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   LET l_factor = 1
   CALL s_umfchk(g_rvb.rvb05,l_ima44,g_rvb.rvb86)
         RETURNING g_cnt,l_factor
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
 
   LET g_rvb.rvb87 = l_tot
 
END FUNCTION

#FUN-A10130--begin--mark---- 
#FUNCTION p021_rva_conf()
#DEFINE  l_flag    LIKE type_file.chr1
# 
#  LET g_errno = ''
# 
#  LET g_cnt = 0
#  SELECT COUNT(*) INTO g_cnt
#    FROM rvb_file
#   WHERE rvb01 = g_rva.rva01
#  IF g_cnt > g_sma.sma110 THEN
#     LET g_errno = 'axm-156'
#     CALL cl_getmsg('axm-156',g_lang) RETURNING g_msg
#     OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',g_msg)
#     RETURN
#  END IF
# 
#  # ---無單身資料不可確認---
#  LET g_cnt = 0
#  SELECT COUNT(*) INTO g_cnt
#    FROM rvb_file
#   WHERE rvb01 = g_rva.rva01
#  IF g_cnt = 0 THEN
#     LET g_errno = 'mfg-009'
#     CALL cl_getmsg('mfg-009',g_lang) RETURNING g_msg
#     OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',g_msg)
#     RETURN
#  END IF
# 
#  CALL p021_chk_over()
#  IF NOT cl_null(g_errno) THEN
#     RETURN
#  END IF
# 
#  #-->更新單頭確認碼
#  UPDATE rva_file SET rvaconf = 'Y' WHERE rva01 = g_rva.rva01
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     LET g_errno = 'aic-186'
#     CALL cl_getmsg('aic-186',g_lang) RETURNING g_msg
#     OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',g_msg)
#     RETURN
#  END IF
# 
#  CALL p021_y1()
#  IF NOT cl_null(g_errno) THEN
#     RETURN
#  END IF
# 
#  CALL p021_upd_pmn()
#  IF NOT cl_null(g_errno) THEN
#     RETURN
#  END IF
# 
#END FUNCTION
# 
## --- 確認時 check 超短交 & 可否提前交貨---
#FUNCTION p021_chk_over()
#   DEFINE  l_pmn34    LIKE pmn_file.pmn34,
#           l_pmn37    LIKE pmn_file.pmn37,
#           l_date     DATE,
#           l_pmn15    LIKE pmn_file.pmn15
# 
#   LET g_errno = ''
# 
#   DECLARE p021_chk_over_cs CURSOR FOR
#     SELECT * FROM rvb_file
#      WHERE rvb01 = g_rva.rva01
# 
#   FOREACH p021_chk_over_cs INTO g_rvb.*
#      IF STATUS THEN
#         LET g_errno = 'p021_chk_over_cs:fail!'
#         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
#         LET g_msg = "p021_chk_over_cs:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',g_msg)
#         EXIT FOREACH
#      END IF
# 
#      SELECT * INTO g_rvbi.*
#        FROM rvbi_file
#       WHERE rvbi01=g_rvb.rvb01
#         AND rvbi02=g_rvb.rvb02
# 
#      SELECT pmn13,pmn14,pmn15,pmn34,pmn37,pmn20,(pmn50-pmn55)
#        INTO g_pmn13,g_pmn14,l_pmn15,l_pmn34,l_pmn37,g_pmn20,g_pmn50_55
#        FROM pmn_file,pmm_file
#       WHERE pmn01 = g_rvb.rvb04
#         AND pmn02 = g_rvb.rvb03
#         AND pmn01 = pmm01
# 
#      IF g_rvb.rvb35 = 'N' THEN
#         CALL p021_chk_over_sub()
#         IF NOT cl_null(g_errno) THEN
#            EXIT FOREACH
#         END IF
#      END IF
# 
#      IF l_pmn15 = 'N' THEN  #可否提前交貨(Y/N)
#         IF cl_null(l_pmn37) THEN
#            LET l_date = l_pmn34
#         ELSE
#            LET l_date = l_pmn37
#         END IF
#         IF g_rva.rva06 < l_date THEN
#            LET g_errno = 'apm-285'
#            CALL cl_getmsg('apm-285',g_lang) RETURNING g_msg
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_rvb.rvb04,
#                                            g_rvb.rvb03,g_msg)
#            EXIT FOREACH
#         END IF
#      END IF
#   END FOREACH
# 
#END FUNCTION
# 
#FUNCTION p021_chk_over_sub()
#DEFINE l_sfb39    LIKE sfb_file.sfb39,
#       l_sfb05    LIKE sfb_file.sfb05,
#       l_sfb93    LIKE sfb_file.sfb93,
#       l_rvb07_1  LIKE rvb_file.rvb07,
#       l_rvb07_2  LIKE rvb_file.rvb07,
#       l_rvb07_3  LIKE rvb_file.rvb07,
#       l_rvb07_4  LIKE rvb_file.rvb07,
#       l_rvb07    LIKE rvb_file.rvb07,
#       l_pmm02    LIKE pmm_file.pmm02,
#       l_pmniicd03  LIKE pmni_file.pmniicd03,
#       l_rvb01    LIKE rvb_file.rvb01,
#       l_rvb01_t  LIKE rvb_file.rvb01,
#       l_rvb02    LIKE rvb_file.rvb02
# 
#   LET g_errno = ''
# 
#   IF cl_null(g_pmn13) THEN  #超交率
#      LET g_pmn13 = 0
#   END IF
# 
#   IF cl_null(g_pmn50_55) THEN
#      LET g_pmn50_55 = 0
#   END IF
# 
#   SELECT pmn20 INTO g_pmn20
#     FROM pmn_file
#    WHERE pmn01 = g_rvb.rvb04
#      AND pmn02 = g_rvb.rvb03
# 
#   LET l_pmm02 = NULL
#   SELECT pmm02 INTO l_pmm02
#     FROM pmm_file
#    WHERE pmm01 = g_rvb.rvb04
# 
#   LET l_pmniicd03 = NULL
#   SELECT pmniicd03 INTO l_pmniicd03
#     FROM pmni_file
#    WHERE pmni01 = g_rvb.rvb04
#      AND pmni02 = g_rvb.rvb03
# 
#   IF NOT(l_pmm02 = 'SUB' AND l_pmniicd03 = '12') THEN
#      SELECT SUM(rvb07) INTO l_rvb07_3
#        FROM rvb_file,rva_file
#       WHERE rvb04 = g_rvb.rvb04
#         AND rvb03 = g_rvb.rvb03
#         AND rvaconf = 'N'
#         AND rva01 = rvb01
#         AND rvb35 = 'N'
#         AND NOT (rvb01 = g_rva.rva01
#         AND rvb02 = g_rvb.rvb02)
#   ELSE
#      LET l_rvb01_t = NULL
#      LET l_rvb07_3 = 0
#      DECLARE p021_rvb07_cs3 CURSOR FOR
#       SELECT rvb01,rvb02,rvb07 FROM rva_file,rvb_file
#        WHERE rva01 = rvb01
#          AND rvaconf = 'N'
#          AND rvb04 = g_idg.idg04   #FUN-950040
#          AND rvb03 = g_idg.idg05   #FUN-950040
#          AND rvb35 = 'N'
#          AND NOT (rvb01 = g_rva.rva01)
#       ORDER BY rvb01,rvb02
# 
#      FOREACH p021_rvb07_cs3 INTO l_rvb01,l_rvb02,l_rvb07_4
#         IF cl_null(l_rvb01_t) OR l_rvb01 != l_rvb01_t THEN
#            LET l_rvb01_t = l_rvb01
#         ELSE
#            CONTINUE FOREACH
#         END IF
# 
#         LET l_rvb07_3 = l_rvb07_3 + l_rvb07_4
#      END FOREACH
#   END IF
#   IF cl_null(l_rvb07_3) THEN
#      LET l_rvb07_3 = 0
#   END IF
# 
#   #計算已交量
#   LET l_rvb07=g_pmn50_55+l_rvb07_3+g_rvb.rvb07
#   LET l_rvb07_1=(g_pmn20*(100+g_pmn13))/100   #可交貨量
#   LET l_rvb07_2=(g_pmn20*(100-g_pmn13))/100   #最少可交貨量
# 
#   IF g_pmn13 >= 0 THEN
#      IF g_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
#         IF l_rvb07_2 > l_rvb07 THEN
#            IF g_sma.sma85 MATCHES '[Rr]' THEN
#               LET g_errno = 'mfg3038'
#               CALL cl_getmsg('mfg3038',g_lang) RETURNING g_msg
#               OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_rvb.rvb04,
#                                               g_rvb.rvb03,g_msg)
#               RETURN
#            END IF
#         END IF
# 
#         IF l_rvb07_1 < l_rvb07 THEN #超交
#            IF g_sma.sma85 MATCHES '[Rr]' THEN
#               LET g_errno = 'mfg3037'
#               CALL cl_getmsg('mfg3037',g_lang) RETURNING g_msg
#               OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_rvb.rvb04,
#                                               g_rvb.rvb03,g_msg)
#               RETURN
#            END IF
#         END IF
#      END IF
# 
#      IF g_pmn14 = "Y" THEN          #可部份交貨, 則僅控制超交
#         IF l_rvb07_1 < l_rvb07 THEN #超交
#            IF g_sma.sma85 MATCHES '[Rr]' THEN
#               LET g_errno = 'mfg3037'
#               CALL cl_getmsg('mfg3037',g_lang) RETURNING g_msg
#               OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_rvb.rvb04,
#                                               g_rvb.rvb03,g_msg)
#               RETURN
#            END IF
#         END IF
#      END IF
#   END IF
# 
#   IF g_pmn13 < 0 THEN        #控制超短交
#      IF g_pmn14 = 'N' THEN   #不能部份交貨
#         IF l_rvb07 - g_pmn20 < 0 THEN      #須>= 訂購量
#            LET g_errno = 'mfg3335'
#            CALL cl_getmsg('mfg3335',g_lang) RETURNING g_msg
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,g_rvb.rvb04,
#                                            g_rvb.rvb03,g_msg)
#            RETURN
#         END IF
#      END IF
#   END IF
# 
#   SELECT sfb05,sfb39,sfb93
#     INTO l_sfb05,l_sfb39,l_sfb93
#     FROM sfb_file
#    WHERE sfb01 = g_rvb.rvb34
# 
#   LET l_pmm02 = NULL
#   SELECT pmm02 INTO l_pmm02
#     FROM pmm_file
#    WHERE pmm01 = g_rvb.rvb04
# 
#   IF l_sfb39 != '2' THEN   #工單完工方式為'2'
#      IF l_pmm02 ='SUB' AND g_rvb.rvb05 = l_sfb05 AND l_sfb93 != 'Y' THEN
#         CALL p021_get_min_set() #取得g_min_set的值
#      END IF
#   END IF
#END FUNCTION
# 
#FUNCTION p021_get_min_set()
#   DEFINE l_ima55      LIKE ima_file.ima55,
#          l_pmn07      LIKE pmn_file.pmn07,
#          l_fac        LIKE ima_file.ima31_fac,
#          l_i          LIKE type_file.num5
#   DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
# 
#   LET g_min_set = 0
# 
#   CALL s_get_ima153(g_rvb.rvb05) RETURNING l_ima153  #FUN-910053
#   CALL s_minp(g_rvb.rvb34,g_sma.sma73,l_ima153,'') #FUN-910053
#        RETURNING g_cnt,g_min_set
# 
#   SELECT ima55 INTO l_ima55
#     FROM ima_file
#    WHERE ima01 = g_rvb.rvb05
# 
#   LET l_pmn07 = NULL
#   SELECT pmn07 INTO l_pmn07
#     FROM pmn_file
#    WHERE pmn01 = g_rvb.rvb04
#      AND pmn02 = g_rvb.rvb03
# 
#   CALL s_umfchk(g_rvb.rvb05,l_pmn07,l_ima55)
#        RETURNING l_i,l_fac
# 
#   IF l_i = 1 THEN
#      #採購單位無法與料件的生產單位做換算,預設轉換率為1
#      LET l_fac = 1
#   END IF
# 
#   LET g_min_set = g_min_set / l_fac
# 
#   # 確認之(收貨-退貨)
#   SELECT SUM(rvb07-rvb29) INTO conf_qty FROM rvb_file,rva_file
#    WHERE rvb34 = g_rvb.rvb34
#      AND rvb01 = rva01
#      AND rvaconf = 'Y'
#      AND rvb05 = g_rvb.rvb05
#      AND rvb35 = 'N'
# 
#   IF cl_null(conf_qty) THEN
#      LET conf_qty = 0
#   END IF
# 
#   LET g_min_set = g_min_set - conf_qty
# 
#END FUNCTION
# 
#FUNCTION p021_y1()
# DEFINE  l_rvb           RECORD LIKE rvb_file.*,
#         l_rvbi          RECORD LIKE rvbi_file.*,
#         l_factor1       LIKE ima_file.ima31_fac,
#         l_cnt           LIKE type_file.num5,
#         l_sfa05         LIKE sfa_file.sfa05,
#         l_sfa065        LIKE sfa_file.sfa065,
#         l_rvb07         LIKE rvb_file.rvb07,
#         l_sfb04         LIKE sfb_file.sfb04,
#         l_sfb24         LIKE sfb_file.sfb24,
#         l_pmh08         LIKE pmh_file.pmh08,
#         l_pmn07         LIKE pmn_file.pmn07,    #採購單號
#         l_pmn51         LIKE pmn_file.pmn51,
#         l_pmn01         LIKE pmn_file.pmn01,    #採購單號
#         l_pmn02         LIKE pmn_file.pmn02,    #項次
#         l_pmn122        LIKE pmn_file.pmn122,   #專案號碼
#         l_pmn09         LIKE pmn_file.pmn09,    #轉換因子
#         l_pmn40         LIKE pmn_file.pmn40,    #會計科目
#         l_pmn011        LIKE pmn_file.pmn011,   #性質
#         l_pmm22         LIKE pmm_file.pmm22,
#         l_ima25         LIKE ima_file.ima25,    #庫存單位
#         l_ima86         LIKE ima_file.ima86,    #成本單位
#         l_ima906        LIKE ima_file.ima906,
#         l_code          LIKE type_file.chr1,
#         l_qc            LIKE type_file.chr1,
#         l_ins_rvu       LIKE type_file.chr1, #有免驗料,可直接入庫的資料設'Y'
#         l_fac           LIKE ima_file.ima31_fac,
#         l_ima44         LIKE ima_file.ima44,
#         l_ima55         LIKE ima_file.ima55
# DEFINE  l_msg           LIKE type_file.chr1000
# DEFINE  l_pmm04         LIKE pmm_file.pmm04
# DEFINE  l_flag          LIKE type_file.chr1
# 
#   LET g_errno = ''
# 
#   LET l_qc = 'N'
#   LET l_ins_rvu='N' #default可直接入庫碼設為'Y'
#   DECLARE p021_y CURSOR FOR
#     SELECT * FROM rvb_file WHERE rvb01=g_rva.rva01
#   DECLARE p021_y_n CURSOR FOR
#     SELECT * FROM rvb_file
#      WHERE rvb01=g_rva.rva01
#        AND rvb39='N' #檢驗否='N'
# 
#   FOREACH p021_y INTO l_rvb.*
#      IF STATUS THEN
#         LET g_errno = 'p021_y:fail!'
#         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
#         LET g_msg = "p021_y:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',g_msg)
#         EXIT FOREACH
#      END IF
# 
#      SELECT * INTO l_rvbi.*
#        FROM rvbi_file
#       WHERE rvbi01=l_rvb.rvb01
#         AND rvbi02=l_rvb.rvb02
# 
#      LET l_pmm04 =''
#      IF NOT cl_null(l_rvb.rvb04) THEN
#         SELECT pmm04 INTO l_pmm04 FROM pmm_file   #採購單據日期
#          WHERE pmm01 = l_rvb.rvb04
#         IF STATUS OR l_pmm04 > g_rva.rva06 THEN
#            #收貨日期不可小於採購單據日期
#            LET g_errno = 'apm-413'
#            CALL cl_getmsg('apm-413',g_lang) RETURNING g_msg
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                            l_rvb.rvb03,g_msg)
#            RETURN
#         END IF
#      END IF
# 
#      #-----委外處理
#      IF g_rva.rva10='SUB' THEN
#         LET l_cnt = 0
#         SELECT COUNT(*) INTO l_cnt
#           FROM sfa_file
#          WHERE sfa01=l_rvb.rvb34 AND sfa05!=sfa065
#         IF l_cnt > 0 THEN
#            LET l_cnt = 0
#            SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfq_file
#             WHERE sfp01 = sfq01
#               AND sfq02 = l_rvb.rvb34
#               AND sfp06 = '1'
#               AND sfp04 = 'Y'
#         END IF
# 
#         SELECT sfb04 INTO l_sfb04 FROM sfb_file   #工單
#          WHERE sfb01 = l_rvb.rvb34
#         IF l_sfb04 = "8" THEN
#            LET g_errno = 'asf-070'
#            CALL cl_getmsg('asf-070',g_lang) RETURNING g_msg
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                            l_rvb.rvb03,g_msg)
#            RETURN
#         END IF
# 
#         IF l_sfb24 ='N' OR cl_null(l_sfb24) THEN
#            SELECT sfb04,sfb05 INTO l_sfb04,g_sfb05 FROM sfb_file   #工單
#             WHERE sfb01 = l_rvb.rvb34
#            IF l_sfb04 < '6' THEN
#               UPDATE sfb_file SET sfb04 = '6'  #工單已完工,進入F.Q.C
#                WHERE sfb01 = l_rvb.rvb34
#               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                  LET g_errno = 'UPDATE fail sfb_file!'
#                  CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#                  LET g_msg = "UPDATE sfb_file:fail! ",g_msg CLIPPED
#                  OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                                  l_rvb.rvb03,g_msg)
#                  RETURN
#               END IF
#            END IF
#            CALL s_updsfb117(l_rvb.rvb34)
#            IF g_success='N' THEN
#               LET g_errno = 'UPDATE fail sfb_file!'
#               OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                               l_rvb.rvb03,
#                                              'UPDATE fail sfb_file!')
# 
#               RETURN
#            END IF
#         END IF
#      END IF
# 
#      #-->取採購單位(pmn07)與庫存單位(ima25)的轉換,且LOCK 此筆資料
#      LET g_forupd_sql = "SELECT pmn09,pmn011,pmn40,pmn07",
#                         "  FROM pmn_file",
#                         " WHERE pmn01=? AND pmn02=? FOR UPDATE"
#      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#      DECLARE p021_pmn1 CURSOR FROM g_forupd_sql                 # LOCK CURSOR
# 
#      OPEN p021_pmn1 USING l_rvb.rvb04,l_rvb.rvb03
#      IF STATUS THEN
#         LET g_errno = 'OPEN p021_pmn1'
#         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
#         LET g_msg = "OPEN p021_pmn1:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                         l_rvb.rvb03,g_msg)
#         CLOSE p021_pmn1
#         RETURN
#      END IF
#      FETCH p021_pmn1 INTO l_pmn09,l_pmn011,l_pmn40,l_pmn07
#      IF SQLCA.sqlcode THEN
#         LET g_errno = 'fetch p021_pmn1'
#         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#         LET g_msg = "fetch p021_pmn1:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                         l_rvb.rvb03,g_msg)
#         CLOSE p021_pmn1
#         RETURN
#      END IF
#      IF l_rvb.rvb05[1,4] != 'MISC' THEN
#         LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file",
#                            " WHERE ima01=? FOR UPDATE"
#         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#         DECLARE p021_ima1 CURSOR FROM g_forupd_sql              # LOCK CURSOR
#         OPEN p021_ima1 USING l_rvb.rvb05
#         IF STATUS THEN
#            LET g_errno = 'OPEN p021_ima1'
#            CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
#            LET g_msg = "OPEN p021_ima1:fail! ",g_msg CLIPPED
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                            l_rvb.rvb03,g_msg)
#            CLOSE p021_ima1
#            RETURN
#         END IF
# 
#         FETCH p021_ima1 INTO l_ima25,l_ima86
#         IF SQLCA.sqlcode THEN
#            LET g_errno = 'fetch p021_ima1'
#            CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#            LET g_msg = "fetch p021_ima1:fail! ",g_msg CLIPPED
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                            l_rvb.rvb03,g_msg)
#            CLOSE p021_ima1
#            RETURN
#         END IF
# 
#         CALL s_umfchk(l_rvb.rvb05,l_pmn07,l_ima25) RETURNING l_cnt,l_factor1
#         IF l_cnt = 1 THEN
#            LET g_errno = 'abm-731'
#            CALL cl_getmsg('abm-731',g_lang) RETURNING g_msg
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                            l_rvb.rvb03,g_msg)
#            RETURN
#         END IF
#      END IF
#      SELECT pmn122 INTO l_pmn122 FROM pmn_file
#       WHERE pmn01 = l_rvb.rvb04
#         AND pmn02 = l_rvb.rvb03
# 
#      #-->樣品不更新PO上的數量
#      IF l_rvb.rvb35='N' THEN
#         #-->(1-2)更新超短交量
#         CALL s_udpmn57(l_rvb.rvb04,l_rvb.rvb03)
# 
#         #-->(1-3)產生tlf_file
#         IF l_rvb.rvb05[1,4] != 'MISC' THEN
#            CALL p021_log(1,0,l_rvb.*,l_pmn011,l_pmn07,l_pmn40,l_ima86,l_pmn122)
# 
#            SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_rvb.rvb05
#            IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
#               IF NOT cl_null(l_rvb.rvb83) THEN
#                  IF NOT cl_null(l_rvb.rvb85) THEN                                   #CHI-860005
#                     CALL p021_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,
#                                    l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,'2')
#                  END IF
#               END IF
#               IF NOT cl_null(l_rvb.rvb80) THEN
#                  IF NOT cl_null(l_rvb.rvb82) THEN                                   #CHI-860005
#                     CALL p021_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,
#                                    l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,'1')
#                  END IF
#               END IF
#            END IF
#         END IF
#      END IF
# 
#      IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
#                              #                   2: 不作料件供應商管制
#         SELECT pmm22 INTO l_pmm22 FROM pmm_file
#          WHERE pmm01=l_rvb.rvb04
# 
#         SELECT pmh08 INTO l_pmh08 FROM pmh_file
#          WHERE pmh01=l_rvb.rvb05
#            AND pmh02=g_rva.rva05
#            AND pmh13=l_pmm22
#            AND pmhacti = 'Y'                                           #CHI-910021
#         IF cl_null(l_pmh08) THEN
#            LET l_pmh08 = 'N'
#         END IF
# 
#         IF l_rvb.rvb05[1,4] = 'MISC' THEN
#            LET l_pmh08='N'
#         END IF
#      ELSE
#         SELECT ima24 INTO l_pmh08 FROM ima_file
#          WHERE ima01=l_rvb.rvb05
#         IF cl_null(l_pmh08) THEN
#            LET l_pmh08 = 'N'
#         END IF
# 
#         IF l_rvb.rvb05[1,4] = 'MISC' THEN
#            LET l_pmh08='N'
#         END IF
#      END IF
# 
#      IF l_pmh08='N' OR     #免驗料
#         (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
#         l_rvb.rvb19='2' THEN                      #委外代買料
#         UPDATE rvb_file SET rvb33 = l_rvb.rvb07,  #實收數量
#                             rvb331 = l_rvb.rvb82, #實收數量
#                             rvb332 = l_rvb.rvb85, #實收數量
#                             rvb40 = g_today,      #檢驗日期
#                             rvb41 = 'OK'          #檢驗結果
#          WHERE rvb01 = l_rvb.rvb01
#            AND rvb02 = l_rvb.rvb02
#         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#            LET g_errno = 'UPDATE rvb_file:fail'
#            CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#            LET g_msg = "UPDATE rvb_file:fail! ",g_msg CLIPPED
#            OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                            l_rvb.rvb03,g_msg)
#            RETURN
#         END IF
#         LET l_ins_rvu='Y' #因為免驗料,所以可直接入庫碼設為'Y'
#      END IF
#      #check收貨和品管是否要檢查承認文號
#      IF l_pmh08 = 'Y' THEN
#         CALL s_chk_apprl(l_rvb.rvb05,g_rva.rva05,l_rvb.rvb04)
#         RETURNING l_code,l_msg
#         #需依照參數『收貨單無承認文號時0.不處理　1.警告　2.拒絕』的設定處理
#         CASE l_code
#            WHEN 1      #警告
#               CALL cl_err('',l_msg,1)
#            WHEN 2      #拒絕
#               LET g_errno = l_msg
#               CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
#               OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                               l_rvb.rvb03,g_msg)
#               RETURN
#            OTHERWISE
#               EXIT CASE
#         END CASE
#      END IF
#      CLOSE p021_pmn1
#      CLOSE p021_ima1
#   END FOREACH
# 
#   #-->不為 'MISC' 且 為免檢者須check img_file(因免檢可直接入庫)
#   IF l_ins_rvu='Y' THEN
#      FOREACH p021_y_n INTO l_rvb.*
#         IF l_rvb.rvb05[1,4] <>'MISC' THEN
#            LET g_cnt = 0
#            SELECT COUNT(*) INTO g_cnt
#              FROM img_file
#             WHERE img01 = l_rvb.rvb05
#               AND img02 = l_rvb.rvb36
#               AND img03 = l_rvb.rvb37
#               AND img04 = l_rvb.rvb38
#            IF g_cnt=0 AND ((g_rva.rva10<>'SUB') OR
#              (g_rva.rva10='SUB' AND l_sfb24='N')) THEN
#              LET g_errno = 'apm-259'
#              CALL cl_getmsg('apm-259',g_lang) RETURNING g_msg
#              OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb.rvb04,
#                                              l_rvb.rvb03,g_msg)
#              RETURN
#            END IF
#         END IF
#      END FOREACH
#      IF STATUS THEN
#         LET g_errno = 'p021_y_n:fail!'
#         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
#         LET g_msg = "p021_y_n:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',STATUS)
#         RETURN
#      END IF
#   END IF
# 
#END FUNCTION
# 
#FUNCTION p021_log(p_stdc,p_reason,p_rvb,
#                  p_pmn011,p_pmn07,p_pmn40,p_ima86,p_pmn122)
#   DEFINE
#      p_stdc          LIKE type_file.num5,             #是否需取得標準成本
#      p_reason        LIKE type_file.num5,             #是否需取得異動原因
#      p_code          LIKE type_file.chr4,
#      p_qty           LIKE pmn_file.pmn20,        #異動數量
#      p_rvb           RECORD LIKE rvb_file.*,
#      p_pmn011        LIKE pmn_file.pmn011,
#      p_pmn40         LIKE pmn_file.pmn40,  #會計科目
#      p_pmn07         LIKE pmn_file.pmn07,
#      p_ima86         LIKE ima_file.ima86,  #成本單位
#      p_pmn122        LIKE pmn_file.pmn122, #專案號碼
#      p_ac,l_sta      LIKE type_file.num5,
#      l_pmn65         LIKE pmn_file.pmn65
# 
#   IF cl_null(g_pmn09) OR g_pmn09 = 0 THEN
#      LET g_pmn09 = 1
#   END IF
#   LET g_tlf.tlf01=p_rvb.rvb05          #異動料件編號
#   CASE p_pmn011
#      WHEN 'REG ' LET g_tlf.tlf02=11    #資料來源
#      WHEN 'EXP ' LET g_tlf.tlf02=14
#      WHEN 'CAP ' LET g_tlf.tlf02=16
#      WHEN 'SUB '
#           SELECT pmn65 INTO l_pmn65
#             FROM pmn_file
#            WHERE pmn01 = p_rvb.rvb04
#              AND pmn02 = p_rvb.rvb03
#           IF l_pmn65 = '2' THEN
#               LET g_tlf.tlf02=18      #委外代買
#           ELSE
#               LET g_tlf.tlf02=60
#           END IF
#      OTHERWISE LET g_tlf.tlf02 = 10
#   END CASE
#   LET g_tlf.tlf020=g_plant             #工廠編號
#   LET g_tlf.tlf021=''                  #倉庫別
#   LET g_tlf.tlf022=''                  #儲位別
#   LET g_tlf.tlf023=''
#   LET g_tlf.tlf024=''
#   LET g_tlf.tlf025=''
#   IF p_pmn011='SUB' THEN
#      LET g_tlf.tlf026=p_rvb.rvb34
#      LET g_tlf.tlf027=p_rvb.rvb03
#      LET g_tlf.tlf03=25                 #F.Q.C.
#      LET g_tlf.tlf13='asft6001'            #異動命令代號
#   ELSE
#      LET g_tlf.tlf026=p_rvb.rvb04        #單據編號(採購單)
#      LET g_tlf.tlf027=p_rvb.rvb03        #項次(採購項次)
#      LET g_tlf.tlf03 =20                  #資料目的為檢驗區
#      LET g_tlf.tlf13='apmt1101'           #異動命令代號
#   END IF
#   LET g_tlf.tlf030=g_plant             #工廠編號
#   LET g_tlf.tlf031=p_rvb.rvb36         #倉庫別
#   LET g_tlf.tlf032=p_rvb.rvb37         #儲位別
#   LET g_tlf.tlf033=p_rvb.rvb38         #入庫批號
#   LET g_tlf.tlf034=''                  #庫存數量
#   LET g_tlf.tlf035=''                  #異動後庫存單位
#   LET g_tlf.tlf036=p_rvb.rvb01         #驗收單單據編號
#   LET g_tlf.tlf037=p_rvb.rvb02         #單據項次
#   LET g_tlf.tlf04=''                   #工作中心
#   LET g_tlf.tlf05=' '                  #作業編號
#   LET g_tlf.tlf06=g_rva.rva06          #異動日期=驗收單之收貨日期
#   LET g_tlf.tlf07=g_today              #異動數量=驗收單之實收數量
#   LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
#   LET g_tlf.tlf09=g_user               #產生人
#   LET g_tlf.tlf10=p_rvb.rvb07          #異動數量=驗收單之實收數量
#   LET g_tlf.tlf11=p_pmn07              #異動單位=採購單位
#   LET g_tlf.tlf12=g_pmn09              #收料單位/料件庫存轉換率
#   LET g_tlf.tlf14=' '                  #異動原因代碼
#   LET g_tlf.tlf17=''                   #非庫存性料件編號
#   CALL s_imaQOH(p_rvb.rvb05) RETURNING g_tlf.tlf18 #異動後總庫存量
#   LET g_tlf.tlf19=g_rva.rva05          #廠商編號
#   LET g_tlf.tlf20=p_pmn122             #專案號碼
#   LET g_tlf.tlf61=p_ima86              #成本單位
#   LET g_tlf.tlf62=p_rvb.rvb04          #單據編號(採購單)
#   LET g_tlf.tlf63=p_rvb.rvb03          #項次(採購項次)
#   LET g_tlf.tlf64=p_rvb.rvb25          #手冊 no.A050
#   CALL s_tlf(p_stdc,p_reason)
# 
#END FUNCTION
# 
#FUNCTION p021_tlff(p_pmn011,p_ima86,p_pmn122,p_rvb,p_unit,p_fac,p_qty,p_flag)
#   DEFINE
#      p_rvb           RECORD LIKE rvb_file.*,
#      p_unit          LIKE img_file.img09,
#      p_fac           LIKE img_file.img21,
#      p_qty           LIKE img_file.img10,
#      p_pmn011        LIKE pmn_file.pmn011,
#      p_ima86         LIKE ima_file.ima86,  #成本單位
#      p_pmn122        LIKE pmn_file.pmn122, #專案號碼
#      p_flag          LIKE type_file.chr1,
#      p_ac,l_sta      LIKE type_file.num5,
#      l_pmn65         LIKE pmn_file.pmn65
# 
#   LET g_tlff.tlff01=p_rvb.rvb05          #異動料件編號
#   CASE p_pmn011
#      WHEN 'REG ' LET g_tlff.tlff02=11    #資料來源
#      WHEN 'EXP ' LET g_tlff.tlff02=14
#      WHEN 'CAP ' LET g_tlff.tlff02=16
#      WHEN 'SUB '
#           SELECT pmn65 INTO l_pmn65
#             FROM pmn_file
#            WHERE pmn01 = p_rvb.rvb04
#              AND pmn02 = p_rvb.rvb03
#           IF l_pmn65 = '2' THEN
#               LET g_tlff.tlff02=18      #委外代買
#           ELSE
#               LET g_tlff.tlff02=60
#           END IF
#      OTHERWISE LET g_tlff.tlff02 = 10
#   END CASE
#   LET g_tlff.tlff020=g_plant             #工廠編號
#   LET g_tlff.tlff021=''                  #倉庫別
#   LET g_tlff.tlff022=''                  #儲位別
#   LET g_tlff.tlff023=''
#   LET g_tlff.tlff024=''
#   LET g_tlff.tlff025=''
# 
#   IF p_pmn011='SUB' THEN
#      LET g_tlff.tlff026=p_rvb.rvb34
#      LET g_tlff.tlff027=p_rvb.rvb03
#      LET g_tlff.tlff03=25                #F.Q.C.
#      LET g_tlff.tlff13='asft6001'        #異動命令代號
#   ELSE
#      LET g_tlff.tlff026=p_rvb.rvb04      #單據編號(採購單)
#      LET g_tlff.tlff027=p_rvb.rvb03      #項次(採購項次)
#      LET g_tlff.tlff03 =20               #資料目的為檢驗區
#      LET g_tlff.tlff13='apmt1101'        #異動命令代號
#   END IF
# 
#   LET g_tlff.tlff030=g_plant             #工廠編號
#   LET g_tlff.tlff031=p_rvb.rvb36         #倉庫別
#   LET g_tlff.tlff032=p_rvb.rvb37         #儲位別
#   LET g_tlff.tlff033=p_rvb.rvb38         #入庫批號
#   LET g_tlff.tlff034=''                  #庫存數量
#   LET g_tlff.tlff035=''                  #異動後庫存單位
#   LET g_tlff.tlff036=p_rvb.rvb01         #驗收單單據編號
#   LET g_tlff.tlff037=p_rvb.rvb02         #單據項次
#   LET g_tlff.tlff04=''                   #工作中心
#   LET g_tlff.tlff05=' '                  #作業編號
#   LET g_tlff.tlff06=g_rva.rva06          #異動日期=驗收單之收貨日期
#   LET g_tlff.tlff07=g_today              #異動數量=驗收單之實收數量
#   LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
#   LET g_tlff.tlff09=g_user               #產生人
#   LET g_tlff.tlff10=p_qty                #異動數量=驗收單之實收數量
#   LET g_tlff.tlff11=p_unit               #異動單位=採購單位
#   LET g_tlff.tlff12=p_fac                #收料單位/料件庫存轉換率
#   LET g_tlff.tlff14=' '                  #異動原因代碼
#   LET g_tlff.tlff17=''                   #非庫存性料件編號
# 
#   CALL s_imaQOH(p_rvb.rvb05) RETURNING g_tlff.tlff18 #異動後總庫存量
# 
#   LET g_tlff.tlff19=g_rva.rva05          #廠商編號
#   LET g_tlff.tlff20=p_pmn122             #專案號碼
#   LET g_tlff.tlff61=p_ima86              #成本單位
#   LET g_tlff.tlff62=p_rvb.rvb04          #單據編號(採購單)
#   LET g_tlff.tlff63=p_rvb.rvb03          #項次(採購項次)
#   LET g_tlff.tlff64=p_rvb.rvb25          #手冊
# 
#   IF cl_null(p_rvb.rvb85) OR p_rvb.rvb85 = 0 THEN
#      CALL s_tlff(p_flag,NULL)
#   ELSE
#      CALL s_tlff(p_flag,p_rvb.rvb83)
#   END IF
# 
#END FUNCTION
# 
#FUNCTION p021_upd_pmn()
#DEFINE l_rvb03    LIKE rvb_file.rvb03,
#       l_rvb04    LIKE rvb_file.rvb04,
#       l_rvb35    LIKE rvb_file.rvb35,
#       l_rvb07    LIKE rvb_file.rvb07,
#       l_rvb30    LIKE rvb_file.rvb30,
#       l_rvv17    LIKE rvv_file.rvv17,
#       l_pmn51    LIKE pmn_file.pmn51,
#       l_rvb30_t  LIKE rvb_file.rvb30,
#       l_rvb07_t  LIKE rvb_file.rvb07,
#       l_pmn51_t  LIKE pmn_file.pmn51,
#       l_rvb01    LIKE rvb_file.rvb01,
#       l_rvb01_t  LIKE rvb_file.rvb01,
#       l_pmm02    LIKE pmm_file.pmm02,
#       l_pmniicd03  LIKE pmni_file.pmniicd03
# 
#   #-->計算採購單之已交量/在驗量(已交量-退貨量-入庫量)
#   DECLARE p021_upd_pmn CURSOR WITH HOLD FOR
#     SELECT rvb03,rvb04,rvb35 FROM rvb_file WHERE rvb01 = g_rva.rva01
# 
#   FOREACH p021_upd_pmn INTO l_rvb03,l_rvb04,l_rvb35
#      IF STATUS THEN
#         LET g_errno = 'p021_upd_pmn:fail!'
#         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#         LET g_msg = "p021_upd_pmn:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,'','',g_msg)
#         EXIT FOREACH
#      END IF
#      #-->樣品不更新PO上的數量
#      IF l_rvb35 <> 'N' THEN
#         CONTINUE FOREACH
#      END IF
# 
#      LET l_pmm02 = NULL
#      SELECT pmm02 INTO l_pmm02
#        FROM pmm_file
#       WHERE pmm01 = l_rvb04
# 
#      LET l_pmniicd03 = NULL
#      SELECT pmniicd03 INTO l_pmniicd03
#        FROM pmni_file
#       WHERE pmni01 = l_rvb04
#         AND pmni02 = l_rvb03
# 
#      IF NOT(l_pmm02 = 'SUB' AND l_pmniicd03 = '12') THEN
#         SELECT SUM(rvb30),SUM(rvb07),SUM(rvb07-rvb29-rvb30)
#           INTO l_rvb30,l_rvb07,l_pmn51
#           FROM rva_file,rvb_file
#          WHERE rvb04 = l_rvb04
#            AND rvb03 = l_rvb03
#            AND rvb35 = 'N'
#            AND rvaconf = 'Y'
#            AND rva01 = rvb01
#      ELSE
#         LET l_rvb01_t = NULL
#         LET l_rvb30 = 0
#         LET l_rvb07 = 0
#         LET l_pmn51 = 0
#         DECLARE p021_upd_pmn_cs CURSOR FOR
#           SELECT rvb01,rvb30,rvb07,rvb07-rvb29-rvb30
#             FROM rva_file,rvb_file
#            WHERE rvb04 = l_rvb04
#              AND rvb03 = l_rvb03
#              AND rvb35 = 'N'
#              AND rvaconf = 'Y'
#              AND rva01 = rvb01
#            ORDER BY rvb01
# 
#         FOREACH p021_upd_pmn_cs INTO l_rvb01,l_rvb30_t,l_rvb07_t,l_pmn51_t
#           IF cl_null(l_rvb01_t) OR l_rvb01 != l_rvb01_t THEN
#              LET l_rvb01_t = l_rvb01
#           ELSE
#              CONTINUE FOREACH
#           END IF
# 
#           LET l_rvb30 = l_rvb30 + l_rvb30_t
#           LET l_rvb07 = l_rvb07 + l_rvb07_t
#           LET l_pmn51 = l_pmn51 + l_pmn51_t
#         END FOREACH
#      END IF
#      IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF
#      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
#      IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF
# 
#      SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
#        FROM rvv_file,rvu_file
#       WHERE rvv37 = l_rvb03
#         AND rvv36 = l_rvb04
#         AND rvv25 = 'N'
#         AND rvuconf = 'Y'
#         AND rvu01 = rvv01
#         AND rvu00 = '3'  #倉退
#      IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
# 
#      #-->(1-1)更新採購單已交量/在驗量
#      UPDATE pmn_file SET pmn50 = l_rvb07,    #已交量
#                          pmn51 = l_pmn51,    #在驗量
#                          pmn53 = l_rvb30     #入庫量
#       WHERE pmn01 = l_rvb04
#         AND pmn02 = l_rvb03
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         LET g_errno = 'upd pmn50:fail!'
#         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#         LET g_msg = "upd pmn50:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep(g_rva.rva08,l_rvb04,l_rvb03,g_msg)
#         RETURN
#      END IF
#   END FOREACH
# 
#END FUNCTION
#FUN-A10130--end--mark------
 
FUNCTION p021_idg_def(p_cmd)
DEFINE  p_cmd   LIKE type_file.chr1
DEFINE  l_imaicd08  LIKE imaicd_file.imaicd08  #MOD-D30215
DEFINE  l_imaicd09  LIKE imaicd_file.imaicd09  #MOD-D30215
 
   LET g_errno = ''
 
   IF p_cmd = '1' THEN
      LET g_idg.idg20 = NULL
      LET g_idg.idg21 = NULL
      LET g_idg.idg22 = 'N'
      LET g_idg.idg23 = 0
      LET g_idg.idg24 = 0
   ELSE
      LET g_idg.idg20 = g_idg_s[g_cnt].idg20
      LET g_idg.idg21 = g_idg_s[g_cnt].idg21
      LET g_idg.idg22 = g_idg_s[g_cnt].idg22
      LET g_idg.idg23 = g_idg_s[g_cnt].idg23
      LET g_idg.idg24 = g_idg_s[g_cnt].idg24
   END IF
 
  #多一rule:料件為IC時
   #IF g_imaicd04 NOT MATCHES '[0-2]' AND g_imaicd08 = 'N' THEN #FUN-BA0051 mark
   IF NOT s_icdbin(g_rvb05) THEN   #FUN-BA0051
      LET g_idg.idg20 = ' '                #刻號  
      LET g_idg.idg21 = ' '                #BIN值  
      LET g_idg.idg22 = g_idh.idh022 #PASS BIN否
      #LET g_idg.idg23 = g_idh.idh024 #收貨數量   #FUN-C30286
      #LET g_idg.idg24 = g_idh.idh024 #實收數量   #FUN-C30286
   END IF
   #FUN-C30286---begin
   IF g_idg.idg23 = 0 THEN
      LET g_idg.idg23 = g_idh.idh024
   END IF 
   IF g_idg.idg24 = 0 THEN
      LET g_idg.idg24 = g_idh.idh024
   END IF 
   #FUN-C30286---end
   #MOD-D30215---begin
   SELECT imaicd08,imaicd09 INTO l_imaicd08,l_imaicd09 
    FROM imaicd_file WHERE imaicd00 = g_rvb05
   IF l_imaicd08 = 'N' AND l_imaicd09 = 'Y' THEN 
      IF cl_null(g_idg.idg20) OR g_idg.idg20 = ' ' THEN 
         LET g_idg.idg20 = '000'  
      END IF 
      IF cl_null(g_idg.idg21) OR g_idg.idg21 = ' ' THEN
         LET g_idg.idg21 = 'BIN00'
      END IF   
   END IF 
   #MOD-D30215---end
   IF cl_null(g_idg.idg22) THEN LET g_idg.idg22 = 'N' END IF
   LET g_idg.idg03 = '1'                   # unconfirm
   LET g_idg.idg04 = g_idh.idh004
   LET g_idg.idg05 = g_idh.idh005
   LET g_idg.idg06 = g_idh.idh006
   LET g_idg.idg07 = g_idh.idh007
   IF cl_null(g_idg.idg07) THEN
      LET g_idg.idg07 = ' '   #批號
   END IF
   LET g_idg.idg08 = g_idh.idh008
   LET g_idg.idg09 = g_idh.idh009
   LET g_idg.idg10 = g_idh.idh010
   LET g_idg.idg11 = g_idh.idh011
   LET g_idg.idg12 = g_idh.idh012
   LET g_idg.idg13 = g_idh.idh013
   LET g_idg.idg14 = g_idh.idh014
   LET g_idg.idg15 = g_idh.idh015
   LET g_idg.idg16 = g_idh.idh016
   LET g_idg.idg17 = g_idh.idh001
   LET g_idg.idg25 = g_idh.idh025
   LET g_idg.idg26 = g_idh.idh026
   LET g_idg.idg27 = g_idh.idh027
 
   IF g_imaicd04 = '2' THEN
      IF cl_null(g_idg.idg27) THEN
         #已測Wafer回貨刻號明細,Die數不可為空白,請查核!!
         #LET g_errno = 'DSC0004' #TQC-C20110 mark
         LET g_errno = 'aic-302'  #TQC-C20110
         RETURN
      END IF
   END IF
 
   IF g_imaicd04 MATCHES '[0-1]' THEN
      #取得GROSSDIE
      IF cl_null(g_idg.idg27) THEN
     #FUN-B30192-mark
     #    SELECT icb05 INTO g_idg.idg27
     #      FROM icb_file,imaicd_file
     #     WHERE icb01 = imaicd01
     #       AND imaicd00 = g_idh.idh105
     #FUN-B30192-mark
         CALL s_icdfun_imaicd14(g_idh.idh105) RETURNING g_idg.idg27  #FUN-B30192
      END IF
   END IF
   LET g_idg.idg28 = g_idh.idh028
   LET g_idg.idg29 = g_idh.idh029
   LET g_idg.idg30 = g_idh.idh030
   LET g_idg.idg31 = g_idh.idh031
   LET g_idg.idg36 = g_idh.idh096
   LET g_idg.idg37 = g_idh.idh097
   LET g_idg.idg38 = g_idh.idh098
   LET g_idg.idg39 = g_idh.idh099
   LET g_idg.idg40 = g_idh.idh101
   LET g_idg.idg41 = g_idh.idh102
   LET g_idg.idg42 = g_idh.idh103
   IF cl_null(g_idg.idg42) THEN
      LET g_idg.idg42 = '@'
   END IF
 
   LET g_idg.idg43 = g_idh.idh104
   LET g_idg.idg44 = g_idh.idh105
   LET g_idg.idg45 = g_idh.idh106
   LET g_idg.idg46 = g_idh.idh107
   LET g_idg.idg47 = g_idh.idh108
   LET g_idg.idg48 = g_idh.idh109
   LET g_idg.idg49 = g_idh.idh110
   LET g_idg.idg50 = g_idh.idh111
   LET g_idg.idg51 = g_idh.idh112
   LET g_idg.idg52 = g_idh.idh113
   LET g_idg.idg53 = g_idh.idh114
   LET g_idg.idg54 = g_idh.idh115
   LET g_idg.idg55 = g_idh.idh116
   LET g_idg.idg56 = g_idh.idh117
   LET g_idg.idg57 = g_idh.idh118
   LET g_idg.idg58 = g_idh.idh119
   LET g_idg.idg59 = g_idh.idh120
   LET g_idg.idg60 = g_idh.idh121
   LET g_idg.idg61 = g_idh.idh122
   LET g_idg.idg62 = g_idh.idh123
   LET g_idg.idg63 = g_idh.idh124
   LET g_idg.idg64 = g_idh.idh125
   LET g_idg.idg65 = g_idh.idh126
   LET g_idg.idg66 = g_idh.idh127
   LET g_idg.idg67 = g_idh.idh128
   LET g_idg.idg68 = g_idh.idh129
   LET g_idg.idg69 = g_idh.idh130
   LET g_idg.idg70 = g_idh.idh131
   LET g_idg.idg71 = g_idh.idh132
   LET g_idg.idg72 = g_idh.idh133
   LET g_idg.idg73 = g_idh.idh134
   LET g_idg.idg74 = g_idh.idh135
   LET g_idg.idg75 = g_idh.idh136
   LET g_idg.idg76 = g_idh.idh137
   LET g_idg.idg77 = g_idh.idh138
   LET g_idg.idg78 = g_idh.idh139
   LET g_idg.idg79 = g_idh.idh140
   LET g_idg.idg80 = g_idh.idh141
   LET g_idg.idg81 = g_idh.idh142
   LET g_idg.idg82 = g_idh.idh143 
   #FUN-A30066--begin--add-----
   IF cl_null(g_idh.idh145) THEN
      LET g_idg.idg83 = g_ica.ica05
   ELSE
      LET g_idg.idg83 = g_idh.idh145
   END IF
   #FUN-A30066--end--add-----
   #FUN-C30286--begin--add-----
   IF cl_null(g_idh.idh146) THEN
      LET g_idg.idg84 = g_ica.ica06
   ELSE
      LET g_idg.idg84 = g_idh.idh146
   END IF
   IF cl_null(g_idg.idg84) THEN
      LET g_idg.idg84 = ' '
   END IF  
   IF cl_null(g_idg.idg20) THEN 
      LET g_idg.idg20 = ' '
   END IF 
   IF cl_null(g_idg.idg21) THEN 
      LET g_idg.idg21 = ' '
   END IF 
   #FUN-C30286--end--add-----
   LET g_idg.idgplant = g_plant  #FUN-980004 add plant & legal
   LET g_idg.idglegal = g_legal  #FUN-980004 add plant & legal
END FUNCTION
 
FUNCTION p021_rvb_def()
DEFINE  l_rvb07   LIKE rvb_file.rvb07
DEFINE  l_ima491  LIKE ima_file.ima491
DEFINE  l_ima906  LIKE ima_file.ima906
DEFINE  l_pmn88   LIKE pmn_file.pmn88
DEFINE  l_pmn88t  LIKE pmn_file.pmn88t
DEFINE  l_pmn65   LIKE pmn_file.pmn65
DEFINE  l_pmn07   LIKE pmn_file.pmn07
DEFINE  l_cnt     LIKE type_file.num5    #FUN-C30281
DEFINE  l_rvb     RECORD
          rvb34   LIKE rvb_file.rvb34,
          rvb30   LIKE rvb_file.rvb30,
          rvb29   LIKE rvb_file.rvb29,
          rvb35   LIKE rvb_file.rvb35,
          rvb83   LIKE rvb_file.rvb83,
          rvb84   LIKE rvb_file.rvb84,
          rvb85   LIKE rvb_file.rvb85,
          rvb80   LIKE rvb_file.rvb80,
          rvb81   LIKE rvb_file.rvb81,
          rvb82   LIKE rvb_file.rvb82,
          rvb86   LIKE rvb_file.rvb86,
          rvb87   LIKE rvb_file.rvb87,
          rvb10t  LIKE rvb_file.rvb10t,
          rvb25   LIKE rvb_file.rvb25
                  END RECORD

   IF cl_null(g_rvb.rvb36) THEN LET g_rvb.rvb36=' ' END IF
   IF cl_null(g_rvb.rvb37) THEN LET g_rvb.rvb37=' ' END IF
   IF cl_null(g_rvb.rvb38) THEN LET g_rvb.rvb38=' ' END IF
 
   SELECT pmn41,0,0,'N',pmn83,pmn84,pmn85,pmn80,pmn81,pmn82,
          pmn86,pmn87,pmn31t,pmn71,pmn65,pmn88,pmn88t,pmn07
          ,pmniicd16,pmn04,pmniicd03                            #MOD-CA0008 add pmniicd03
     INTO l_rvb.*,l_pmn65,l_pmn88,l_pmn88t,l_pmn07
          ,g_rvbi.rvbiicd16,g_rvb.rvb05,g_rvbi.rvbiicd03        #MOD-CA0008 add rvbiicd03
     FROM pmn_file,pmni_file
    WHERE pmn01 = g_idg04
      AND pmn02 = g_idg05
      AND pmni01=pmn01
      AND pmni02=pmn02
   #FUN-C30281---begin
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sfei_file         
    WHERE sfei02 IN (SELECT sfq01 FROM sfq_file WHERE sfq02=l_rvb.rvb34) 
   IF l_cnt = 1 THEN 
      SELECT sfeiicd029 INTO g_rvbi.rvbiicd16 FROM sfei_file
       WHERE sfei02 IN (SELECT sfq01 FROM sfq_file WHERE sfq02=l_rvb.rvb34)
   ELSE
      LET g_rvbi.rvbiicd16 = ' ' 
   END IF 
   #FUN-C30281---end
 
#FUN-A30066--begin--add-------    
    IF NOT cl_null(g_icf07) THEN  #TQC-A30130
       LET g_rvb.rvb05 = g_icf07
    END IF
#FUN-A30066--end--add--------
 
   LET l_rvb07 = 0
   SELECT SUM(rvb07) INTO l_rvb07 FROM rva_file,rvb_file
    #WHERE rvb04 = g_rvb.rvb04
    #  AND rvb03 = g_rvb.rvb03
    WHERE rvb04 = g_idg04
      AND rvb03 = g_idg05
      AND rva01 = rvb01
      AND rvaconf = 'N'
      AND rvb35 = 'N'
   IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF
   IF l_rvb07 != 0 THEN
      LET l_rvb.rvb85 = 0
      LET l_rvb.rvb82 = 0
      LET l_rvb.rvb87 = 0
   END IF
 
   IF g_rvb.rvb05[1,4] = 'MISC' THEN
      LET g_rvb.rvb35 = NULL
      LET l_rvb.rvb35 = NULL
   END IF
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima906 INTO l_ima906 FROM ima_file
       WHERE ima01 = g_rvb.rvb05
      IF g_sma.sma115 = 'N' OR cl_null(l_ima906) OR l_ima906 = '1' THEN
         LET l_rvb.rvb80 = l_pmn07
         LET l_rvb.rvb82 = g_rvb.rvb07
      END IF
      LET g_rvb.rvb80 = l_rvb.rvb80
      LET g_rvb.rvb81 = l_rvb.rvb81
      LET g_rvb.rvb82 = l_rvb.rvb82
      LET g_rvb.rvb83 = l_rvb.rvb83
      LET g_rvb.rvb84 = l_rvb.rvb84
      LET g_rvb.rvb85 = l_rvb.rvb85
      LET g_rvb.rvb88 = l_pmn88
      LET g_rvb.rvb88t = l_pmn88t
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN
      LET l_rvb.rvb86 = l_pmn07
      LET l_rvb.rvb87 = g_rvb.rvb07
   ELSE
      LET g_rvb.rvb86 = l_rvb.rvb86
      LET g_rvb.rvb87 = l_rvb.rvb87
   END IF
 
   IF cl_null(l_rvb.rvb86) THEN
      LET l_rvb.rvb86 = l_pmn07
      LET l_rvb.rvb87 = g_rvb.rvb07
      LET g_rvb.rvb86 = l_rvb.rvb86
      LET g_rvb.rvb87 = l_rvb.rvb87
   END IF
   LET g_rvb.rvb10t = l_rvb.rvb10t
   LET g_rvb.rvb11 = 0
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = g_rvb.rvb05
   IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
   IF l_ima491 > 0 THEN
      CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb.rvb12
   ELSE
      IF cl_null(g_rvb.rvb12) THEN
         LET g_rvb.rvb12 = g_rva.rva06
      END IF
   END IF
   LET g_rvb.rvb13 = NULL
   LET g_rvb.rvb14 = NULL
   LET g_rvb.rvb15 = 0
   LET g_rvb.rvb16 = 0
   LET g_rvb.rvb17 = NULL
   LET g_rvb.rvb18 = '10'
   LET g_rvb.rvb19 = l_pmn65
   LET g_rvb.rvb20 = NULL
   LET g_rvb.rvb21 = NULL
   LET g_rvb.rvb22 = NULL
   LET g_rvb.rvb25 = l_rvb.rvb25
   LET g_rvb.rvb26 = NULL
   LET g_rvb.rvb27 = 0
   LET g_rvb.rvb28 = 0
   LET g_rvb.rvb29 = 0
   LET g_rvb.rvb30 = 0
   LET g_rvb.rvb31 = g_rvb.rvb07
   LET g_rvb.rvb32 = 0
   LET g_rvb.rvb33 = 0
   LET g_rvb.rvb331 = 0
   LET g_rvb.rvb332 = 0
   LET g_rvb.rvb34 = l_rvb.rvb34
   LET g_rvb.rvb35 = 'N'
   LET g_rvb.rvb40 = NULL
   LET g_rvb.rvb89 = 'N'  #TQC-9C0151
   LET g_rvb.rvb90 = l_pmn07  #FUN-A10130
   
   LET g_rvb.rvbplant = g_plant   #FUN-980004 add plant
   LET g_rvb.rvblegal = g_legal   #FUN-980004 add legal
 
   SELECT ima35,ima36 INTO g_rvb.rvb36,g_rvb.rvb37
     FROM ima_file
    WHERE ima01=g_rvb.rvb05
 
   IF cl_null(g_rvb.rvb82) THEN
      LET g_rvb.rvb82 = 0
   END IF
 
   IF cl_null(g_rvb.rvb85) THEN
      LET g_rvb.rvb85 = 0
   END IF
 
   IF l_ima906 = '1' THEN
      LET g_rvb.rvb83 = NULL   #單位二
      LET g_rvb.rvb84 = NULL   #單位二換算率
      LET g_rvb.rvb85 = NULL   #單位二數量
   END IF
 
END FUNCTION
 
FUNCTION p021_rvb_def1(p_rvb,p_rvbi)   #FUN-C30286 add p_rvbi
  DEFINE l_rvb07_bef  LIKE rvb_file.rvb07
  DEFINE p_rvb        RECORD LIKE rvb_file.*
  DEFINE p_rvbi       RECORD LIKE rvbi_file.*   #FUN-C30286 add
 
  LET g_errno = NULL
  IF cl_null(p_rvb.rvb36) THEN LET p_rvb.rvb36=' ' END IF
  IF cl_null(p_rvb.rvb37) THEN LET p_rvb.rvb37=' ' END IF
  IF cl_null(p_rvb.rvb38) THEN LET p_rvb.rvb38=' ' END IF
 
  #委外Turkey採購單,一採購項次產生一張收貨單
  #收貨單身是展作業製程序來的ecm_file
  #所以同一收貨單的單身資料除了項次,單價,倉庫,儲位外,其餘欄位皆會相等
  IF NOT cl_null(p_rvb.rvb01) AND
     p_rvb.rvb04 = g_idg04 AND
     p_rvb.rvb03 = g_idg05 THEN
     LET g_rvb.* = p_rvb.*
     LET g_rvbi.* = p_rvbi.*   #FUN-C30286 add
     LET g_rvb.rvb02 = g_ecm.ecm03
  ELSE
     LET g_rvb.rvb01 = g_rva.rva01
     LET g_rvb.rvb02 = g_ecm.ecm03
     LET g_rvb.rvb03 = g_idg05
     LET g_rvb.rvb04 = g_idg04
 
     SELECT imaicd01 INTO g_rvbi.rvbiicd14
      FROM imaicd_file
     WHERE imaicd00 = g_rvb.rvb05
     LET g_rvb.rvb06 = 0
 
     SELECT SUM(idg24),SUM(idg23),SUM(idg25),SUM(idg26)
       INTO g_rvb.rvb07,g_rvb.rvb08,g_rvbi.rvbiicd06,g_rvbi.rvbiicd07
       FROM idg_file
      WHERE idg17 = g_ide.ide05
        AND idg04 = g_idg04
        AND idg05 = g_idg05
        AND idg42 = g_idg42
        AND idg07 = g_idg07
        AND idg83 = g_idg83  #FUN-C30286 add
        AND idg84 = g_idg84  #FUN-C30286 add
        AND idg01 = ' '      #FUN-920080
        AND idg02 = 0        #FUN-920080
     IF SQLCA.SQLCODE THEN
        LET g_rvb.rvb07 = 0
        LET g_rvb.rvb08 = 0
        LET g_rvbi.rvbiicd06 = 0
        LET g_rvbi.rvbiicd07 = 0
     END IF
     IF cl_null(g_rvb.rvb07) THEN
        LET g_rvb.rvb07 = 0
     END IF
     IF cl_null(g_rvb.rvb08) THEN
        LET g_rvb.rvb08 = 0
     END IF
     IF cl_null(g_rvbi.rvbiicd06) THEN
        LET g_rvbi.rvbiicd06 = 0
     END IF
     IF cl_null(g_rvbi.rvbiicd07) THEN
        LET g_rvbi.rvbiicd07 = 0
     END IF
     #實收數量(rvb07),不良數(rvbiicd06),報廢數(rvbiicd07)應呈現在最後一站才對
     LET g_rvb07 = g_rvb.rvb07           #FUN-C30286 add
     LET g_rvbiicd06 = g_rvbi.rvbiicd06  #FUN-C30286 add
     LET g_rvbiicd07 = g_rvbi.rvbiicd07  #FUN-C30286 add
 
     LET g_rvb.rvb31 = g_rvb.rvb07
     LET g_rvb.rvb82 = g_rvb.rvb07   #單位一數量
 
     # ---做實收數量的檢查---
     CALL p021_rvb07('2',g_rvb.rvb07,'a')
     IF NOT cl_null(g_errno) THEN
        RETURN
     END IF
 
     LET g_rvb.rvb09 = 0
 
     DECLARE p021_idg07_cs SCROLL CURSOR FOR
        SELECT idg07,idg28 FROM idg_file
          WHERE idg17 = g_ide.ide05
            AND idg04 = g_idg04
            AND idg05 = g_idg05
            AND idg42 = g_idg42
            AND idg07 = g_idg07
            AND idg83 = g_idg83  #FUN-C30286 add
            AND idg84 = g_idg84  #FUN-C30286 add
            AND idg01 = ' '      #FUN-920080
            AND idg02 = 0        #FUN-920080
     OPEN p021_idg07_cs
     FETCH FIRST p021_idg07_cs INTO g_rvb.rvb38,g_rvbi.rvbiicd08
     CLOSE p021_idg07_cs
     LET g_rvbiicd08 = g_rvbi.rvbiicd08  #FUN-C30286 add
 
     CALL p021_get_rvb39(g_rvb.rvb04,g_rvb.rvb05,g_rvb.rvb19)
        RETURNING g_rvb.rvb39
 
     LET g_rvbi.rvbiicd09 = 'Y'
  END IF
 
  LET g_rvb.rvb10 = 0  # unconfirm
  LET g_rvb.rvb10t = 0  # unconfirm
 
  LET g_rvb.rvb88 = g_rvb.rvb87 * g_rvb.rvb10
  LET g_rvb.rvb88t = g_rvb.rvb87 * g_rvb.rvb10t
 
 #str FUN-C30286 add
 #單位應參照製程檔設定來產生,單位換算率也需對應的重算
  LET g_rvb.rvb80 = g_ecm.ecm58
  LET g_rvb.rvb86 = g_ecm.ecm58
  LET g_rvb.rvb90 = g_ecm.ecm58
  LET g_rvb.rvb81 = 1 / g_ecm.ecm59
  LET g_rvb.rvb90_fac = 1 / g_ecm.ecm59
 #end FUN-C30286 add

  LET g_cnt = 0
  #COUNT一下還有沒有製程序值比現在這一筆大的資料存在,若有的話,表示不是Turnkey工單的最後一站
  SELECT COUNT(*) INTO g_cnt
    FROM ecm_file
   WHERE ecm01 = g_pmn41
     AND ecm03 > g_ecm.ecm03
  IF g_cnt = 0 THEN
     LET g_rvb.rvb36 = g_ica.ica05
     LET g_rvb.rvb37 = g_ica.ica06
     LET g_rvbi.rvbiicd13 = 'N'  #委外TKY非最終站否
     LET g_rvb.rvb07 = g_rvb07            #FUN-C30286 add
     LET g_rvbi.rvbiicd06 = g_rvbiicd06   #FUN-C30286 add
     LET g_rvbi.rvbiicd07 = g_rvbiicd07   #FUN-C30286 add
     LET g_rvbi.rvbiicd08 = g_rvbiicd08   #FUN-C30286 add
  ELSE
     LET g_rvb.rvb36 = 'MISC'
     LET g_rvb.rvb37 = 'MISC'
     LET g_rvbi.rvbiicd13 = 'Y'  #委外TKY非最終站否
     LET g_rvb.rvb07 = s_digqty((g_rvb07+g_rvbiicd06+g_rvbiicd07)*g_rvb.rvb81,g_rvb.rvb90)  #FUN-C30286 add
     LET g_rvbi.rvbiicd06 = 0             #FUN-C30286 add
     LET g_rvbi.rvbiicd07 = 0             #FUN-C30286 add
     LET g_rvbi.rvbiicd08 = ''            #FUN-C30286 add
  END IF
 #str FUN-C30286 add
  LET g_rvb.rvb08 = g_rvb.rvb07
  LET g_rvb.rvb31 = g_rvb.rvb07
  LET g_rvb.rvb82 = g_rvb.rvb07
  LET g_rvb.rvb87 = g_rvb.rvb07
 #end FUN-C30286 add
 
  #---做倉庫正確性檢查---
  IF g_rvb.rvb36 != 'MISC' OR cl_null(g_rvb.rvb36) THEN #CHI-920083
     CALL p021_rvb36()
     IF NOT cl_null(g_errno) THEN
        RETURN
     END IF
  END IF
 
  #---做倉儲正確性檢查---
  IF g_rvb.rvb37 != 'MISC' OR cl_null(g_rvb.rvb37) THEN #CHI-920083
     CALL p021_rvb37()
     IF NOT cl_null(g_errno) THEN
        RETURN
     END IF
  END IF
 
  # ---做料倉儲批正確性檢查---
  IF (g_rvb.rvb36 != 'MISC' OR cl_null(g_rvb.rvb36)) AND
     (g_rvb.rvb37 != 'MISC' OR cl_null(g_rvb.rvb37)) THEN  #CHI-920083
     CALL p021_rvb38()
     IF NOT cl_null(g_errno) THEN
        RETURN
     END IF
  END IF

  LET g_rvbi.rvbiicd03 = g_ecm.ecm04   #FUN-C30286
 
END FUNCTION
 
FUNCTION p021_rvb_def2()
DEFINE l_rvb07_bef   LIKE rvb_file.rvb07
DEFINE l_pmj09       LIKE pmj_file.pmj09  #FUN-C90121
DEFINE l_gec07       LIKE gec_file.gec07  #FUN-C90121
DEFINE l_pmm22       LIKE pmm_file.pmm22  #FUN-C90121
DEFINE l_pmm43       LIKE pmm_file.pmm43  #FUN-C90121
DEFINE l_sql         STRING               #FUN-C90121
 
  IF cl_null(g_rvb.rvb36) THEN LET g_rvb.rvb36=' ' END IF
  IF cl_null(g_rvb.rvb37) THEN LET g_rvb.rvb37=' ' END IF
  IF cl_null(g_rvb.rvb38) THEN LET g_rvb.rvb38=' ' END IF
 
   LET g_rvb.rvb01 = g_rva.rva01
 
   SELECT MAX(rvb02)+1 INTO g_rvb.rvb02
     FROM rvb_file
    WHERE rvb01 = g_rva.rva01
   IF SQLCA.SQLCODE OR cl_null(g_rvb.rvb02) THEN
      LET g_rvb.rvb02 = 1
   END IF
 
   LET g_rvb.rvb03 = g_idg05
 
   LET g_rvb.rvb04 = g_idg04
 
    SELECT imaicd01 INTO g_rvbi.rvbiicd14
     FROM imaicd_file
    WHERE imaicd00 = g_rvb.rvb05
 
   LET g_rvb.rvb06 = 0
 
   SELECT SUM(idg24),SUM(idg23),SUM(idg25),SUM(idg26)
     INTO g_rvb.rvb07,g_rvb.rvb08,g_rvbi.rvbiicd06,g_rvbi.rvbiicd07
     FROM idg_file
    WHERE idg17 = g_ide.ide05
      AND idg04 = g_idg04
      AND idg05 = g_idg05
      AND idg42 = g_idg42
      AND idg07 = g_idg07
      AND idg83 = g_idg83  #FUN-C30286 add
      AND idg84 = g_idg84  #FUN-C30286 add
      AND idg01 = ' '      #FUN-920080
      AND idg02 = 0        #FUN-920080
   IF SQLCA.SQLCODE  THEN
      LET g_rvb.rvb07 = 0
      LET g_rvb.rvb08 = 0
      LET g_rvbi.rvbiicd06 = 0
      LET g_rvbi.rvbiicd07 = 0
   END IF
   #CHI-C80071---begin
   IF g_imaicd04 = '2' THEN
      SELECT SUM(idh024) INTO g_rvb.rvb07 FROM idh_file
       WHERE idh001 = g_ide.ide05
         AND idh004 = g_idg04
          AND idh005 = g_idg05
      IF SQLCA.SQLCODE  THEN
         LET g_rvb.rvb07 = 0 
      END IF
   END IF
   #CHI-C80071---end
   IF cl_null(g_rvb.rvb07) THEN
      LET g_rvb.rvb07 = 0
   END IF
   IF cl_null(g_rvb.rvb08) THEN
      LET g_rvb.rvb08 = 0
   END IF
   IF cl_null(g_rvbi.rvbiicd06) THEN
      LET g_rvbi.rvbiicd06 = 0
   END IF
   IF cl_null(g_rvbi.rvbiicd07) THEN
      LET g_rvbi.rvbiicd07 = 0
   END IF
 
   LET g_rvb.rvb31 = g_rvb.rvb07
   LET g_rvb.rvb82 = g_rvb.rvb07
 
   # ---做實收數量的檢查---
   CALL p021_rvb07('2',g_rvb.rvb07,'a')
   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF
   
   LET g_rvb.rvb09 = 0
   #FUN-C90121---begin
   SELECT pmm22,pmm43 INTO l_pmm22,l_pmm43
     FROM pmm_file
    WHERE pmm01 = g_idg04
   
   IF g_ica.ica45 = '1' THEN
      SELECT gec07,gec05 INTO l_gec07
            FROM gec_file
           WHERE gec01 = g_idg04
             AND gec011='1'
      IF l_gec07 = 'Y' THEN
         LET g_rvb.rvb10t = g_idg56
         LET g_rvb.rvb10  = g_rvb.rvb10t* ( 1 - l_pmm43/100)
         LET g_rvb.rvb10  = cl_digcut(g_rvb.rvb10,g_azi03)    
      ELSE
         LET g_rvb.rvb10 = g_idg56
         LET g_rvb.rvb10t  = g_rvb.rvb10* ( 1 + l_pmm43/100)
         LET g_rvb.rvb10t  = cl_digcut(g_rvb.rvb10t,g_azi03)    
      END IF 
   END IF 
   IF g_ica.ica45 = '2' THEN
      SELECT MAX(pmj09)
        INTO l_pmj09
        FROM pmj_file,pmi_file
       WHERE pmi01=pmj01
         AND pmi03=g_rva.rva05
         AND pmj03=g_rvb.rvb05
         AND pmj05=l_pmm22
         AND pmj12='2'
         AND pmiconf='Y'
         AND pmiacti='Y'
         AND pmj09 <= g_rva.rva06

      IF cl_null(l_pmj09) THEN LET l_pmj09 = g_today END IF

      LET l_sql = " SELECT pmj07,pmj07t ",
                  " FROM pmj_file,pmi_file ",
                  " WHERE pmi01=pmj01 ",
                  "   AND pmi03='",g_rva.rva05,"' ",
                  "   AND pmj03='",g_rvb.rvb05,"' ",
                  "   AND pmj05='",l_pmm22,"' ",
                  "   AND pmj12='2' ",
                  "   AND pmiconf='Y' ",
                  "   AND pmiacti='Y' ",
                  "   AND pmj09 <='",g_rva.rva06,"' ",
                  "   AND pmj09 = '",l_pmj09,"'",
                  " ORDER BY pmj09 DESC,pmi01 DESC "
       
      PREPARE pmj_pre FROM l_sql
      DECLARE pmj_cur CURSOR FOR pmj_pre
      OPEN pmj_cur
      FETCH pmj_cur INTO g_rvb.rvb10,g_rvb.rvb10t
      IF SQLCA.SQLCODE OR cl_null(g_rvb.rvb10) THEN
         LET g_rvb.rvb10 = 0
         LET g_rvb.rvb10t = 0
      END IF
      CLOSE pmj_cur
   END IF 
   IF g_ica.ica45 = '3' THEN
   #FUN-C90121---end if 
      SELECT pmn31,pmn31t INTO g_rvb.rvb10,g_rvb.rvb10t
         FROM pmn_file
        WHERE pmn01 = g_idg04
          AND pmn02 = g_idg05
      IF SQLCA.SQLCODE OR cl_null(g_rvb.rvb10) THEN
         LET g_rvb.rvb10 = 0
         LET g_rvb.rvb10t = 0 #FUN-C90121
      END IF
   END IF  #FUN-C90121
 
  #str FUN-C30286 mod
  #LET g_rvb.rvb36 = g_ica.ica05
  #LET g_rvb.rvb37 = g_ica.ica06
   IF NOT cl_null(g_idg83) THEN
      LET g_rvb.rvb36 = g_idg83
   ELSE
      LET g_rvb.rvb36 = g_ica.ica05
   END IF
   IF NOT cl_null(g_idg84) THEN
      LET g_rvb.rvb37 = g_idg84
   ELSE
      LET g_rvb.rvb37 = g_ica.ica06
   END IF
  #end FUN-C30286 mod
 
   #---做倉庫正確性檢查---
   IF g_rvb.rvb36 != 'MISC' OR cl_null(g_rvb.rvb36) THEN #CHI-920083
      CALL p021_rvb36()
      IF NOT cl_null(g_errno) THEN
         RETURN
      END IF
   END IF
 
   #---做倉儲正確性檢查---
   IF g_rvb.rvb37 != 'MISC' OR cl_null(g_rvb.rvb37) THEN #CHI-920083
      CALL p021_rvb37()
      IF NOT cl_null(g_errno) THEN
         RETURN
      END IF
   END IF
 
   DECLARE p021_idg07_cs2 SCROLL CURSOR FOR
      SELECT idg07,idg28 FROM idg_file
       WHERE idg17 = g_ide.ide05
         AND idg04 = g_idg04
         AND idg05 = g_idg05
         AND idg42 = g_idg42
         AND idg07 = g_idg07
         AND idg83 = g_idg83  #FUN-C30286 add
         AND idg84 = g_idg84  #FUN-C30286 add
         AND idg01 = ' '      #FUN-920080
         AND idg02 = 0        #FUN-920080
   OPEN p021_idg07_cs2
   FETCH FIRST p021_idg07_cs2 INTO g_rvb.rvb38,g_rvbi.rvbiicd08
   CLOSE p021_idg07_cs2
 
   # ---做料倉儲批正確性檢查---
   IF (g_rvb.rvb36 != 'MISC' OR cl_null(g_rvb.rvb36)) AND
      (g_rvb.rvb37 != 'MISC' OR cl_null(g_rvb.rvb37)) THEN  #CHI-920083
      CALL p021_rvb38()
      IF NOT cl_null(g_errno) THEN
         RETURN
      END IF
   END IF
 
   CALL p021_get_rvb39(g_rvb.rvb04,g_rvb.rvb05,g_rvb.rvb19)
        RETURNING g_rvb.rvb39
 
   LET g_rvb.rvb88 = g_rvb.rvb87 * g_rvb.rvb10
   LET g_rvb.rvb88t = g_rvb.rvb87 * g_rvb.rvb10t
 
   LET g_rvbi.rvbiicd09 = 'Y'
   #FUN-C30286---begin
   SELECT pmniicd03 INTO g_rvbi.rvbiicd03 FROM pmni_file
    WHERE pmni01=g_rvb.rvb04 AND pmni02=g_rvb.rvb03
   #FUN-C30286---end
END FUNCTION

#FUN-A10130--begin--mark------ 
#FUNCTION p021_ins_idd()
#DEFINE  l_idg   RECORD LIKE idg_file.*
# 
#   LET g_errno = ''
# 
#   IF g_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF  #委外TKY非最終站不做
# 
#   DECLARE p021_idg_cs CURSOR FOR
#     SELECT * FROM idg_file
#      WHERE idg01 = g_rvb.rvb01
#        AND idg02 = g_rvb.rvb02
#  AND idg07 = g_rvb.rvb38
# 
#   FOREACH p021_idg_cs INTO l_idg.*
#      IF STATUS THEN
#         LET g_errno = 'p021_idg_cs:fail!'
#         CALL cl_getmsg(STATUS,g_lang) RETURNING g_msg
#         LET g_msg = "p021_idg_cs:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep('',g_idg04,g_idg05,g_msg)
#         EXIT FOREACH
#      END IF
# 
#      #已測Wafer回貨(CP)pass bin檢查:
#      #1.由該料號串pass bin檔,找不到用該料號之Wafer料號,再找不到用母體料號,
#      #  如果還是找不到,則不允許收貨,請user補入pass bin檔
#      #2.找到後,判斷非Pass Bin='Y'不寫入收貨刻號檔,是Pass Bin='Y'才需寫入
#      #  該收貨項次之刻號明細檔(idd_file)
#      LET g_rvb05 = l_idg.idg44
#      CALL p021_passbin_chk(l_idg.idg21)
#      IF NOT cl_null(g_errno) THEN
#         IF g_errno = 'aic-183' THEN
#            CONTINUE FOREACH
#         ELSE
#            CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
#            LET g_msg = "Item NO:",g_rvb05 CLIPPED,
#                        ",BIN:",g_idg.idg21 CLIPPED,
#                        ",",g_msg CLIPPED
#            OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,
#                                               g_idh.idh005,g_msg)
#            EXIT FOREACH
#         END IF
#      END IF
# 
#      INITIALIZE g_idd.* TO NULL
# 
#      LET g_idd.idd01 = g_rvb.rvb05
#      LET g_idd.idd02 = g_rvb.rvb36
#      LET g_idd.idd03 = g_rvb.rvb37
#      LET g_idd.idd04 = g_rvb.rvb38
#      LET g_idd.idd05 = l_idg.idg20
#      LET g_idd.idd06 = l_idg.idg21
#      SELECT img09 INTO g_idd.idd07
#        FROM img_file
#       WHERE img01 = g_rvb.rvb05
#         AND img02 = g_rvb.rvb36
#         AND img03 = g_rvb.rvb37
#         AND img04 = g_rvb.rvb38
#      LET g_idd.idd08 = g_rva.rva06
#      LET g_idd.idd09 = g_today
#      LET g_idd.idd10 = g_rvb.rvb01
#      LET g_idd.idd11 = g_rvb.rvb02
# 
#     #調整:料件狀態'[0-2]'(Wafer),類別=0
#     #     料件狀態'[34]'(IC),類別=7
#      IF g_imaicd04 MATCHES '[0-2]' THEN
#         LET g_idd.idd12 = 0
#      END IF
#      IF g_imaicd04 MATCHES '[34]' THEN
#         LET g_idd.idd12 = 7
#      END IF
# 
#      LET g_idd.idd13 = l_idg.idg24
#      LET g_idd.idd14 = ' '   #unconfirm
#      SELECT imaicd01 INTO g_idd.idd15
#        FROM imaicd_file
#       WHERE imaicd00 = g_rvb.rvb05
#      SELECT pmniicd15,pmniicd16
#        INTO g_idd.idd23,g_idd.idd16
#        FROM pmni_file
#       WHERE pmni01 = g_idg04
#         AND pmni02 = g_idg05
#      LET g_idd.idd17 = l_idg.idg28
#      LET g_idd.idd18 = l_idg.idg27
# 
#      LET g_idd.idd19 = l_idg.idg29
#      LET g_idd.idd20 = l_idg.idg30
#      LET g_idd.idd21 = l_idg.idg31
#      LET g_idd.idd22 = l_idg.idg22
#      #料件狀態= '2.已測Wafer'
#      IF g_imaicd04 = '2' THEN
#         #CP段料號數量(idd13)給 1(EA) Die數(idd18)給 1(PCS)
#         LET g_idd.idd13 = 1
#         LET g_idd.idd18 =  l_idg.idg24
#         LET g_idd.idd22 = 'Y'     #PASS BIN
#      END IF
# 
#      LET g_idd.idd24 = 'Y'
#      LET g_idd.idd25 = NULL
#      LET g_idd.idd26 = l_idg.idg25
#      LET g_idd.idd27 = l_idg.idg26
#      LET g_idd.idd28 = 'Y'
# 
#      IF cl_null(g_idd.idd02) THEN
#         LET g_idd.idd02=' '
#      END IF
#      IF cl_null(g_idd.idd03) THEN
#         LET g_idd.idd03=' '
#      END IF
#      IF cl_null(g_idd.idd04) THEN
#         LET g_idd.idd04=' '
#      END IF
# 
#      LET g_idd.iddplant = g_plant   #FUN-980004 add plant
#      LET g_idd.iddlegal = g_legal   #FUN-980004 add legal
# 
#      INSERT INTO idd_file VALUES(g_idd.*)
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         LET g_errno = 'ins idd:fail'
#         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#         LET g_msg = "ins idd:fail! ",g_msg CLIPPED
#         OUTPUT TO REPORT p021_trans_rep('',g_idg04,g_idg05,g_msg)
#         EXIT FOREACH
#      END IF
#   END FOREACH
#  #重新計算收貨刻號片數
#  #已測Wafer回貨(CP),刻號之片數計算:
#   IF cl_null(g_errno) OR g_errno = 'aic-183' THEN
#      CALL p021_upd_idd13()
#   END IF
#  #更新收貨單據之實收數量,收貨數量,單位一數量,單位二數量,計價數量
#   IF cl_null(g_errno) THEN
#      CALL p021_upd_rvb()
#   END IF
#END FUNCTION 
#FUN-A10130--end--mark---

#FUN-A10130--begin--add--------------
FUNCTION p021_ins_ida() # insert ida_file
DEFINE  l_idg     RECORD LIKE idg_file.*

   LET g_errno = ''

   IF g_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF  #委外TKY非最終站不做

   DECLARE p021_idg_cs CURSOR FOR
     SELECT * FROM idg_file
      WHERE idg01 = g_rvb.rvb01
        AND idg02 = g_rvb.rvb02
        AND idg07 = g_rvb.rvb38
        AND idg83 = g_rvb.rvb36   #FUN-C30286 add
        AND idg84 = g_rvb.rvb37   #FUN-C30286 add

   FOREACH p021_idg_cs INTO l_idg.*
      IF STATUS THEN
         LET g_success='N'
         EXIT FOREACH
      END IF

      #已測Wafer回貨(CP)pass bin檢查:
      #1.由該料號串pass bin檔,找不到用該料號之Wafer料號,再找不到用母體料號,
      #  如果還是找不到,則不允許收貨,請user補入pass bin檔
      #2.找到後,判斷非Pass Bin='Y'不寫入收貨刻號檔,是Pass Bin='Y'才需寫入
      #  該收貨項次之刻號明細檔(idd_file)
      LET g_rvb05 = l_idg.idg44
      CALL p021_passbin_chk(l_idg.idg21)
      IF NOT cl_null(g_errno) THEN
         IF g_errno = 'aic-183' THEN         
           #CONTINUE FOREACH #TQC-A30130 mark 註:非PASS BIN仍然寫入ida/idd,只是ida21='N'
         ELSE
             CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
             LET g_msg = "Item No.",g_rvb05 CLIPPED,
                         ",BIN:",g_idg.idg21 CLIPPED,
                         ",",g_msg CLIPPED
             CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N')
             EXIT FOREACH
             LET g_success='N'
         END IF
      END IF

      INITIALIZE g_ida.* TO NULL

      LET g_ida.ida01 = g_rvb.rvb05
      LET g_ida.ida02 = g_rvb.rvb36
      LET g_ida.ida03 = g_rvb.rvb37
      LET g_ida.ida04 = g_rvb.rvb38
      LET g_ida.ida05 = l_idg.idg20
      LET g_ida.ida06 = l_idg.idg21
      SELECT img09 INTO g_ida.ida13
        FROM img_file
       WHERE img01 = g_rvb.rvb05
         AND img02 = g_rvb.rvb36
         AND img03 = g_rvb.rvb37
         AND img04 = g_rvb.rvb38
      IF cl_null(g_ida.ida13) THEN      #FUN-C30286
         LET g_ida.ida13 = g_rvb.rvb90  #FUN-C30286
      END IF                            #FUN-C30286
      LET g_ida.ida09 = g_rva.rva06
      LET g_ida.ida07 = g_rvb.rvb01
      LET g_ida.ida08 = g_rvb.rvb02

      ##調整:料件狀態'[0-2]'(Wafer),類別=0
      ##     料件狀態'[34]'(IC),類別=7
      # IF g_imaicd04 MATCHES '[0-2]' THEN
      #    LET g_idd.idd12 = 0
      # END IF
      # IF g_imaicd04 MATCHES '[34]' THEN
      #    LET g_idd.idd12 = 7
      # END IF

      LET g_ida.ida10 = l_idg.idg24
      LET g_ida.ida10 = s_digqty(g_ida.ida10,g_ida.ida13)   #FUN-BB0084 
     #LET g_idd.idd14 = ' '   #unconfirm
      SELECT imaicd01 INTO g_ida.ida14
        FROM imaicd_file
       WHERE imaicd00 = g_rvb.rvb05
      SELECT pmniicd15,pmniicd16
        INTO g_ida.ida22,g_ida.ida15
        FROM pmni_file
       WHERE pmni01 = g_idg04
         AND pmni02 = g_idg05
      LET g_ida.ida16 = l_idg.idg28
      LET g_ida.ida17 = l_idg.idg27

      LET g_ida.ida18 = l_idg.idg29
      LET g_ida.ida19 = l_idg.idg30
      LET g_ida.ida20 = l_idg.idg31
      LET g_ida.ida21 = l_idg.idg22

      
      #料件狀態= '2.已測Wafer'
      IF g_imaicd04 = '2' THEN
         #CP段料號數量(idd13)給 1(EA) Die數(idd18)給 1(PCS)
         LET g_ida.ida10 = 1
         LET g_ida.ida17 =  l_idg.idg24
        #LET g_ida.ida21 = 'Y'     #PASS BIN  #TQC-A30130 mark
      END IF

      LET g_ida.ida26 = 'Y'
      LET g_ida.ida29 = NULL
      LET g_ida.ida11 = l_idg.idg25
      LET g_ida.ida12 = l_idg.idg26
      LET g_ida.ida11 = s_digqty(g_ida.ida11,g_ida.ida13)   #FUN-BB0084
      LET g_ida.ida12 = s_digqty(g_ida.ida12,g_ida.ida13)   #FUN-BB0084
      LET g_ida.ida27 = 'Y'

      #CHI-830032................begin
      IF cl_null(g_ida.ida02) THEN
         LET g_ida.ida02=' '
      END IF
      IF cl_null(g_ida.ida03) THEN
         LET g_ida.ida03=' '
      END IF
      IF cl_null(g_ida.ida04) THEN
         LET g_ida.ida04=' '
      END IF
      #CHI-830032................end 
      LET g_ida.idaplant = g_plant
      LET g_ida.idalegal = g_legal
      INSERT INTO ida_file VALUES(g_ida.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_errno = 'ins ida:fail'
         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
         LET g_msg = "ins idd:fail! ",g_msg CLIPPED
         CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')
         EXIT FOREACH
         LET g_success='N'
      END IF
   END FOREACH
  #重新計算收貨刻號片數
  #已測Wafer回貨(CP),刻號之片數計算:
   IF cl_null(g_errno) OR g_errno = 'aic-183' THEN
      CALL p021_upd_ida10()
   END IF
  #更新收貨單據之實收數量,收貨數量,單位一數量,單位二數量,計價數量
   IF cl_null(g_errno) THEN
      CALL p021_upd_rvb()
   END IF

END FUNCTION
#FUN-A10130--end--add----------------

#FUN-A10130--begin--add---------
#重新計算收貨刻號片數
#已測Wafer回貨(CP),刻號之片數計算:
FUNCTION p021_upd_ida10()
   DEFINE l_imaicd04      LIKE imaicd_file.imaicd04  #料件狀態
   DEFINE l_idd18_sum     LIKE idd_file.idd18  #DIE數總合
  #DEFINE l_idd           RECORD LIKE idd_file.*  #TQC-A30130
   DEFINE l_ida           RECORD LIKE ida_file.*  #TQC-A30130
   DEFINE l_idd05         LIKE idd_file.idd05  #刻號
   DEFINE l_idd13_sum     LIKE idd_file.idd13  #片數總合
   DEFINE l_idd13_nw      LIKE idd_file.idd13  #計算後片數
   DEFINE l_cnt_sum       LIKE type_file.num5  #筆數總合
   DEFINE l_cnt           LIKE type_file.num5  #筆數計數器
   DEFINE l_aa            LIKE type_file.num5  #計算用
   DEFINE l_bb            LIKE idd_file.idd13  #計算用
   DEFINE l_sql           STRING               #FUN-A30092
   DEFINE l_icf05         LIKE icf_file.icf05  #FUN-C30286 add

   LET g_errno = ''

   IF g_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF  #委外TKY非最終站不做

   #取得收貨料號之料件狀態
   LET l_imaicd04 = ' '
   SELECT imaicd04 INTO l_imaicd04
      FROM imaicd_file
     WHERE imaicd00 = g_rvb.rvb05   #料號

   IF l_imaicd04 != '2' THEN RETURN END IF #只for已測Wafer(CP)回貨

   #取得該收貨項次同刻號Die數總合
   LET l_idd05 = ''
   LET l_idd18_sum = 0
   LET l_cnt_sum = 0
   #FUN-A30092--begin--add---
   LET l_sql ="SELECT ida05,SUM(ida17),COUNT(*) ",
              "  FROM ida_file ",
              " WHERE ida07 = '",g_rvb.rvb01 ,"'",
              "   AND ida08 = ",g_rvb.rvb02 

   LET l_sql = l_sql , " GROUP BY ida05"
   PREPARE idd18_dec_p FROM l_sql
   DECLARE idd18_dec CURSOR FOR idd18_dec_p
   #FUN-A30092--end--add------
   #DECLARE idd18_dec CURSOR FOR  #FUN-A30092 mark
      #      刻號     ,Die數總合,     資料筆數
     #TQC-A30130(S)
     #SELECT idd05,SUM(idd18),COUNT(*)
     #   FROM idd_file
     #  WHERE idd10 = g_rvb.rvb01 #單號
     #    AND idd11 = g_rvb.rvb02 #項次
     #   GROUP BY idd05
     #   ORDER BY idd05
     #FUN-A30092--begin--mark---
     #SELECT ida05,SUM(ida17),COUNT(*)
     #   FROM ida_file
     #  WHERE ida07 = g_rvb.rvb01 #單號
     #    AND ida08 = g_rvb.rvb02 #項次
     #   GROUP BY ida05
     #   ORDER BY ida05
     #FUN-A30092--end--mark----
     #TQC-A30130(E)

   FOREACH idd18_dec INTO l_idd05,l_idd18_sum,l_cnt_sum

      #取得該收貨項次刻號的明細資料
      #FUN-A30092--begin--add------
      LET l_sql = "SELECT * FROM ida_file ",
                  " WHERE ida07 = '",g_rvb.rvb01 ,"'", #單號
                  "   AND ida08 = ",g_rvb.rvb02, #項次
                  "   AND ida05 = '",l_idd05,"'"  #刻號
      LET l_sql = l_sql ," ORDER BY ida17 DESC"  #依die數由大到小排序
      PREPARE idd_dec_p FROM l_sql
      DECLARE idd_dec CURSOR FOR idd_dec_p 
      #FUN-A30092--end--add---------
     #TQC-A30130(S)
     #DECLARE idd_dec CURSOR FOR
     #   SELECT * FROM idd_file
     #     WHERE idd10 = g_rvb.rvb01 #單號
     #       AND idd11 = g_rvb.rvb02 #項次
     #       AND idd05 = l_idd05 #刻號
     #     ORDER BY idd18 DESC  #依die數由大至小排序
     #FUN-A30092--begin--mark-----
     #DECLARE idd_dec CURSOR FOR
     #   SELECT * FROM ida_file
     #     WHERE ida07 = g_rvb.rvb01 #單號
     #       AND ida08 = g_rvb.rvb02 #項次
     #       AND ida05 = l_idd05 #刻號
     #     ORDER BY ida17 DESC  #依die數由大至小排序
     #FUN-A30092--end--mark------
     #TQC-A30130(E)

      #依各明細Die數占Die數總合比例推算片數
      #片數取到小數點第2位(無條件捨去)
      #同刻號總合是一片,餘數給同刻號的最後一筆明細
      LET l_cnt = 1             #筆數計數器
      LET l_idd13_sum = 0   #片數計數器
     #INITIALIZE l_idd.* TO NULL  #TQC-A30130
      INITIALIZE l_ida.* TO NULL  #TQC-A30130
      FOREACH idd_dec INTO l_ida.*
        #str FUN-C30286 add
        #當BIN的icf05=0.Good時,將算出來的片數寫到ida10
        #當BIN的icf05=1.D/G時,將算出來的片數寫到ida11
         LET l_icf05=NULL
         SELECT icf05 INTO l_icf05 FROM icf_file
          WHERE icf01=l_ida.ida01 AND icf02=l_ida.ida06
         IF cl_null(l_icf05) THEN
            SELECT icf05 INTO l_icf05 FROM icf_file
             WHERE icf01=l_ida.ida14 AND icf02=l_ida.ida06 
         END IF      
         IF cl_null(l_icf05) THEN LET l_icf05 = '0' END IF
        #end FUN-C30286 add

         LET l_idd13_nw = 0  #片數

         IF l_cnt_sum = l_cnt THEN
            LET l_idd13_nw = 1 - l_idd13_sum
         ELSE
           #LET l_idd13_nw = l_idd.idd18 / l_idd18_sum  #TQC-A30130
            LET l_idd13_nw = l_ida.ida17 / l_idd18_sum  #TQC-A30130
           ##--捨小數第二位無條件捨去的處理-----   #FUN-C30286 mark
           #LET l_aa = l_idd13_nw * 100            #FUN-C30286 mark
           #LET l_idd13_nw = l_aa / 100            #FUN-C30286 mark
         END IF
         LET l_idd13_nw = s_digqty(l_idd13_nw,l_ida.ida13)     #FUN-BB0084
         #更新刻號明細的片數值
         IF l_icf05 = '0' THEN   #FUN-C30386 add
           #UPDATE ida_file SET ida10 = l_idd13_nw                  #FUN-C30286 mark
            UPDATE ida_file SET ida10 = l_idd13_nw,ida11=0,ida12=0  #FUN-C30286
               WHERE ida07 = g_rvb.rvb01  #單號
                 AND ida08 = g_rvb.rvb02  #項次
                 AND ida01 = l_ida.ida01  #料      #TQC-A30130
                 AND ida02 = l_ida.ida02  #倉      #TQC-A30130
                 AND ida03 = l_ida.ida03  #儲      #TQC-A30130
                 AND ida04 = l_ida.ida04  #批      #TQC-A30130
                 AND ida05 = l_ida.ida05  #刻號    #TQC-A30130
                 AND ida06 = l_ida.ida06  #BIN     #TQC-A30130
        #str FUN-C30286 add
         ELSE
            UPDATE ida_file SET ida10=0,ida11 = l_idd13_nw,ida12=0
               WHERE ida07 = g_rvb.rvb01  #單號
                 AND ida08 = g_rvb.rvb02  #項次
                 AND ida01 = l_ida.ida01  #料      #TQC-A30130
                 AND ida02 = l_ida.ida02  #倉      #TQC-A30130
                 AND ida03 = l_ida.ida03  #儲      #TQC-A30130
                 AND ida04 = l_ida.ida04  #批      #TQC-A30130
                 AND ida05 = l_ida.ida05  #刻號    #TQC-A30130
                 AND ida06 = l_ida.ida06  #BIN     #TQC-A30130
         END IF
        #end FUN-C30286 add
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             LET g_errno = 'upd ida10:fail'
             CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
             LET g_msg = "upd ida10:fail! ",g_msg CLIPPED   #TQC-A30130
             CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')
             LET g_success='N'
             RETURN
          ELSE
             LET l_idd13_sum = l_idd13_sum + l_idd13_nw
             LET l_cnt = l_cnt + 1
          END IF
      END FOREACH
   END FOREACH
  
END FUNCTION
#FUN-A10130--end--add---------------
 
FUNCTION p021_get_rvb39(p_rvb04,p_rvb05,p_rvb19)
  DEFINE l_pmh08   LIKE pmh_file.pmh08
  DEFINE l_pmm22   LIKE pmm_file.pmm22
  DEFINE p_rvb04   LIKE rvb_file.rvb04
  DEFINE p_rvb05   LIKE rvb_file.rvb05
  DEFINE p_rvb19   LIKE rvb_file.rvb19
  DEFINE l_rvb39   LIKE rvb_file.rvb39
 
  IF g_sma.sma63 = '1' THEN
     SELECT pmm22 INTO l_pmm22 FROM pmm_file
      WHERE pmm01 = p_rvb04
 
     SELECT pmh08 INTO l_pmh08 FROM pmh_file
      WHERE pmh01 = p_rvb05
        AND pmh02 = g_rva.rva05
        AND pmh13 = l_pmm22
        AND pmhacti = 'Y'                                           #CHI-910021
 
     IF cl_null(l_pmh08) THEN
        LET l_pmh08 = 'N'
     END IF
 
     IF p_rvb05[1,4] = 'MISC' THEN
        LET l_pmh08 = 'N'
     END IF
  ELSE
     SELECT ima24 INTO l_pmh08 FROM ima_file
      WHERE ima01 = p_rvb05
 
     IF cl_null(l_pmh08) THEN
        LET l_pmh08 = 'N'
     END IF
 
     IF p_rvb05[1,4] = 'MISC' THEN
        LET l_pmh08 = 'N'
     END IF
  END IF
 
  IF l_pmh08 = 'N' OR
    (g_sma.sma886[6,6] = 'N' AND g_sma.sma886[8,8] = 'N') OR
     p_rvb19 = '2' THEN
     LET l_rvb39 = 'N'
  ELSE
     LET l_rvb39 = 'Y'
  END IF
 
  RETURN l_rvb39
END FUNCTION
 
FUNCTION p021_rvb36()
DEFINE  l_code   LIKE type_file.num5
DEFINE  l_sn1    LIKE type_file.num5
DEFINE  l_sn2    LIKE type_file.num5
 
 LET g_errno = ''
 
 #------>check-1  檢查該料是否可收至該倉
 IF NOT s_imfchk1(g_rvb.rvb05,g_rvb.rvb36) THEN
    LET g_errno = 'mfg9036'
    RETURN
 END IF
 #------>check-2  檢查倉庫須存在否
 CALL s_stkchk(g_rvb.rvb36,'A') RETURNING l_code
 IF NOT l_code THEN
    LET g_errno = 'mfg1100'
    RETURN
 END IF
 #------>check-3  檢查是否為可用倉
 CALL s_swyn(g_rvb.rvb36) RETURNING l_sn1,l_sn2
 IF l_sn1 = 1 THEN
    LET g_errno = 'mfg6080'
    RETURN
 ELSE
    IF l_sn2 = 2 THEN
       LET g_errno = 'mfg6085'
       RETURN
    END IF
 END IF
 #FUN-D20060----add---str
 IF NOT cl_null(g_rvb.rvb36) THEN 
 #--- 檢查料號預設倉儲及單別預設倉儲 ---
    IF NOT s_chksmz(g_rvb.rvb05,g_rva.rva01,g_rvb.rvb36,g_rvb.rvb37) THEN
       LET g_errno = 'aic-187'
       RETURN
    END IF
 END IF 
 #FUN-D20060----add----end
END FUNCTION
 
FUNCTION p021_rvb37()
DEFINE  l_sn1   LIKE type_file.num5
DEFINE  l_sn2   LIKE type_file.num5
 
   LET g_errno = ''
 
   IF g_rvb.rvb37 = '　' THEN #全型空白
      LET g_rvb.rvb37 = ' '
   END IF
   IF cl_null(g_rvb.rvb37) THEN
      LET g_rvb.rvb37 = ' '
   END IF
   IF NOT cl_null(g_rvb.rvb36) THEN
      #--- 檢查料號預設倉儲及單別預設倉儲 ---
      IF NOT s_chksmz(g_rvb.rvb05,g_rva.rva01,g_rvb.rvb36,g_rvb.rvb37) THEN
         LET g_errno = 'aic-187'
         RETURN
      END IF
   END IF
   #------>check-1  檢查該料是否可收至該倉/儲位
   IF NOT s_imfchk(g_rvb.rvb05,g_rvb.rvb36,g_rvb.rvb37) THEN
      LET g_errno = 'mfg6095'
      RETURN
   END IF
   #------>check-2  檢查該倉庫/儲位是否存在
   IF NOT cl_null(g_rvb.rvb37) THEN
      CALL s_hqty(g_rvb.rvb05,g_rvb.rvb36,g_rvb.rvb37)
           RETURNING g_cnt,g_imf04,g_imf05
      IF cl_null(g_imf04) THEN
         LET g_imf04 = 0
      END IF
      IF g_rva.rva10 != 'SUB' THEN   #FUN-C30286 add
         CALL s_lwyn(g_rvb.rvb36,g_rvb.rvb37)
              RETURNING l_sn1,l_sn2    #可用否
         SELECT pmn38 INTO g_pmn38 FROM pmn_file
          WHERE pmn01=g_rvb.rvb04
            AND pmn02=g_rvb.rvb03
         IF l_sn2 = 2 THEN
            IF g_pmn38 = 'Y' THEN
               LET g_errno = 'mfg9132'
               RETURN
            END IF
         ELSE
            IF g_pmn38 = 'N' THEN
               LET g_errno = 'mfg9131'
               RETURN
            END IF
         END IF
      END IF   #FUN-C30286 add
   END IF
   IF cl_null(g_rvb.rvb37) THEN
      LET g_rvb.rvb37=' '
   END IF
END FUNCTION
 
FUNCTION p021_rvb38()
 
   LET g_errno = ''
 
   IF g_rvb.rvb38 = '　' THEN #全型空白
      LET g_rvb.rvb38 = ' '
   END IF
   IF cl_null(g_rvb.rvb38) THEN
      LET g_rvb.rvb38=' '
   END IF
 
   IF NOT cl_null(g_rvb.rvb36) THEN
      SELECT img07,img10,img09
        INTO g_img07,g_img10,g_img09 #採購單位,庫存數量,庫存單位
        FROM img_file
       WHERE img01=g_rvb.rvb05 AND img02=g_rvb.rvb36
         AND img03=g_rvb.rvb37 AND img04=g_rvb.rvb38
      IF STATUS=100 AND NOT cl_null(g_rvb.rvb36) THEN
         #新增庫存明細檔時(img_file)是否需要維護相關資料
        #str TQC-C50095 mark
        #IF g_sma.sma892[2,2]='Y' THEN
        #   CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
        #                  g_rvb.rvb37,g_rvb.rvb38,
        #                  g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
        #END IF
        #end TQC-C50095 mark
        #str TQC-C50095 mod
         IF g_sma.sma892[3,3]='Y' THEN
            IF g_bgjob != 'Y' THEN 
               IF cl_confirm('mfg1401') THEN 
                  CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
                                 g_rvb.rvb37,g_rvb.rvb38,
                                 g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
               END IF
            ELSE
               CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
                              g_rvb.rvb37,g_rvb.rvb38,
                              g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
            END IF
         ELSE
            CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
         END IF
        #end TQC-C50095 mod
         IF g_errno='N' THEN
            LET g_errno = 'aic-188'
            RETURN
         END IF
         SELECT img07,img10,img09
           INTO g_img07,g_img10,g_img09
           FROM img_file
          WHERE img01 = g_rvb.rvb05
            AND img02 = g_rvb.rvb36
            AND img03 = g_rvb.rvb37
            AND img04 = g_rvb.rvb38
      END IF
 
      SELECT ima906 INTO g_ima906 FROM ima_file
       WHERE ima01 = g_rvb.rvb05
      IF g_ima906 = '2' THEN
         IF NOT cl_null(g_rvb.rvb83) THEN
            CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                            g_rvb.rvb37,g_rvb.rvb38,
                            g_rvb.rvb83) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                               g_rvb.rvb37,g_rvb.rvb38,
                               g_rvb.rvb83,g_rvb.rvb84,
                               g_rva.rva01,
                               g_rvb.rvb02,0)
                RETURNING g_flag   #CHI-920047
               IF g_errno='N' THEN
                  LET g_errno = 'aic-188'
                  RETURN
               END IF
            END IF
         END IF
         IF NOT cl_null(g_rvb.rvb80) THEN
            CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                            g_rvb.rvb37,g_rvb.rvb38,
                            g_rvb.rvb80) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                               g_rvb.rvb37,g_rvb.rvb38,
                               g_rvb.rvb80,g_rvb.rvb81,
                               g_rva.rva01,
                               g_rvb.rvb02,0)
               RETURNING g_flag   #CHI-920047
               IF g_errno='N' THEN
                  LET g_errno = 'aic-188'
                  RETURN
               END IF
            END IF
         END IF
      END IF
      IF g_ima906 = '3' THEN
         IF NOT cl_null(g_rvb.rvb83) THEN
            CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                            g_rvb.rvb37,g_rvb.rvb38,
                            g_rvb.rvb83) RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                               g_rvb.rvb37,g_rvb.rvb38,
                               g_rvb.rvb83,g_rvb.rvb84,
                               g_rva.rva01,
                               g_rvb.rvb02,0)
               RETURNING g_flag   #CHI-920047
               IF g_errno='N' THEN
                  LET g_errno = 'aic-188'
                  RETURN
               END IF
            END IF
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION p021_chk_id(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_n          LIKE type_file.num5
DEFINE  l_i          LIKE type_file.num5    # 迴圈用
DEFINE  l_cnt        LIKE type_file.num5    # 計算idh020每個ID的位元數(不可超過3位)
DEFINE  l_char       LIKE idh_file.idh020   # 儲存idh020的ID
DEFINE  l_len        LIKE type_file.num5    # 儲存idh020的長度
DEFINE  l_idg20      LIKE idg_file.idg20
 
   LET g_errno = NULL
   CALL g_idg_s.clear()
   LET g_rec_b2 = 0
   LET l_idg20 = NULL
 
   #IF g_imaicd04 NOT MATCHES '[0-2]' THEN RETURN END IF  #MOD-D30215
   IF NOT s_icdbin(g_rvb05) THEN RETURN END IF   #FUN-C30286 add
 
   IF NOT cl_null(g_idh.idh020) THEN
      LET l_cnt = 0
      LET l_char = NULL
      LET l_len = LENGTH(g_idh.idh020)
 
      FOR l_i = 1 TO l_len
          IF g_idh.idh020[l_i,l_i] != ';' THEN #unconfirm
             LET l_char = l_char CLIPPED,g_idh.idh020[l_i,l_i]
             LET l_cnt = l_cnt + 1
             IF l_cnt > 3 THEN 
                LET g_errno = 'aic-189'
                EXIT FOR
             END IF
          ELSE
             IF cl_null(l_char) THEN
                LET g_errno = 'aic-190'
                EXIT FOR
             END IF
             CALL p021_zero(l_char) RETURNING l_char
             LET g_rec_b2 = g_rec_b2 + 1
             IF p_cmd = '1' THEN
                LET g_idg_s[g_rec_b2].idg20 = l_char
                LET g_idg_s[g_rec_b2].idg21 = 'BIN00'
                LET g_idg_s[g_rec_b2].idg23 = 1
                LET g_idg_s[g_rec_b2].idg24 = 1
             ELSE
                LET l_idg20 = l_char
             END IF
             LET l_char = NULL
             LET l_cnt = 0
          END IF
      END FOR
      IF NOT cl_null(g_errno) THEN
         LET g_rec_b2 = 0
         CALL g_idg_s.clear()
         RETURN
      END IF
      IF cl_null(l_char) THEN
         LET g_errno = 'aic-190'
         LET g_rec_b2 = 0
         CALL g_idg_s.clear()
         RETURN
      ELSE
         CALL p021_zero(l_char) RETURNING l_char
         LET g_rec_b2 = g_rec_b2 + 1
         IF p_cmd = '1' THEN
            LET g_idg_s[g_rec_b2].idg20 = l_char
            LET g_idg_s[g_rec_b2].idg21 = 'BIN00'
            LET g_idg_s[g_rec_b2].idg23 = 1
            LET g_idg_s[g_rec_b2].idg24 = 1
         ELSE
            LET l_idg20 = l_char
         END IF
      END IF
   END IF
   IF g_imaicd08 = 'Y' THEN   # 需做刻號管理時 #FUN-BA0051 mark  #MOD-D30237 remark
   #IF s_icdbin(g_rvb05) THEN   #FUN-BA0051  #MOD-D30237
      IF g_rec_b2 = 0 THEN
         LET g_errno = 'aic-193'
         CALL g_idg_s.clear()
         RETURN
      END IF
   END IF
 
   IF p_cmd = '1' THEN
      IF g_rec_b2 != g_idh.idh024 THEN
         LET g_errno = 'aic-191'
         LET g_rec_b2 = 0
         CALL g_idg_s.clear()
         RETURN
      END IF
   ELSE
      IF g_rec_b2 > 1 THEN
         LET g_errno = 'aic-192'
         LET g_rec_b2 = 0
         CALL g_idg_s.clear()
         RETURN
      END IF
 
      LET l_n = 0
     #CHI-B90037---add---start---
      IF g_idh.idh023 > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN00'
         IF g_idh.idh011 = 'BIN00' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh023
         LET g_idg_s[l_n].idg24 = g_idh.idh023
      END IF
     #CHI-B90037---add--end---
      IF g_idh.idh036 > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN01'
         IF g_idh.idh011 = 'BIN01' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh036
         LET g_idg_s[l_n].idg24 = g_idh.idh036
      END IF
      IF g_idh.idh037 > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN02'
         IF g_idh.idh011 = 'BIN02' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh037
         LET g_idg_s[l_n].idg24 = g_idh.idh037
      END IF
      IF g_idh.idh038 > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN03'
         IF g_idh.idh011 = 'BIN03' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh038
         LET g_idg_s[l_n].idg24 = g_idh.idh038
      END IF
      IF g_idh.idh039 > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN04'
         IF g_idh.idh011 = 'BIN04' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh039
         LET g_idg_s[l_n].idg24 = g_idh.idh039
      END IF
      IF g_idh.idh040  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN05'
         IF g_idh.idh011 = 'BIN05' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh040
         LET g_idg_s[l_n].idg24 = g_idh.idh040
      END IF
      IF g_idh.idh041  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN06'
         IF g_idh.idh011 = 'BIN06' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh041
         LET g_idg_s[l_n].idg24 = g_idh.idh041
      END IF
      IF g_idh.idh042  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN07'
         IF g_idh.idh011 = 'BIN07' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh042
         LET g_idg_s[l_n].idg24 = g_idh.idh042
      END IF
      IF g_idh.idh043  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN08'
         IF g_idh.idh011 = 'BIN08' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh043
         LET g_idg_s[l_n].idg24 = g_idh.idh043
      END IF
      IF g_idh.idh044  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN09'
         IF g_idh.idh011 = 'BIN09' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh044
         LET g_idg_s[l_n].idg24 = g_idh.idh044
      END IF
      IF g_idh.idh045  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN10'
         IF g_idh.idh011 = 'BIN10' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh045
         LET g_idg_s[l_n].idg24 = g_idh.idh045
      END IF
      IF g_idh.idh046  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN11'
         IF g_idh.idh011 = 'BIN11' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh046
         LET g_idg_s[l_n].idg24 = g_idh.idh046
      END IF
      IF g_idh.idh047  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN12'
         IF g_idh.idh011 = 'BIN12' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh047
         LET g_idg_s[l_n].idg24 = g_idh.idh047
      END IF
      IF g_idh.idh048  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN13'
         IF g_idh.idh011 = 'BIN13' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh048
         LET g_idg_s[l_n].idg24 = g_idh.idh048
      END IF
      IF g_idh.idh049  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN14'
         IF g_idh.idh011 = 'BIN14' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh049
         LET g_idg_s[l_n].idg24 = g_idh.idh049
      END IF
      IF g_idh.idh050  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN15'
         IF g_idh.idh011 = 'BIN15' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh050
         LET g_idg_s[l_n].idg24 = g_idh.idh050
      END IF
      IF g_idh.idh051  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN16'
         IF g_idh.idh011 = 'BIN16' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh051
         LET g_idg_s[l_n].idg24 = g_idh.idh051
      END IF
      IF g_idh.idh052  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN17'
         IF g_idh.idh011 = 'BIN17' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh052
         LET g_idg_s[l_n].idg24 = g_idh.idh052
      END IF
      IF g_idh.idh053  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN18'
         IF g_idh.idh011 = 'BIN18' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh053
         LET g_idg_s[l_n].idg24 = g_idh.idh053
      END IF
      IF g_idh.idh054  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN19'
         IF g_idh.idh011 = 'BIN19' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh054
         LET g_idg_s[l_n].idg24 = g_idh.idh054
      END IF
      IF g_idh.idh055  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN20'
         IF g_idh.idh011 = 'BIN20' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh055
         LET g_idg_s[l_n].idg24 = g_idh.idh055
      END IF
      IF g_idh.idh056  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN21'
         IF g_idh.idh011 = 'BIN21' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh056
         LET g_idg_s[l_n].idg24 = g_idh.idh056
      END IF
      IF g_idh.idh057  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN22'
         IF g_idh.idh011 = 'BIN22' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh057
         LET g_idg_s[l_n].idg24 = g_idh.idh057
      END IF
      IF g_idh.idh058  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN23'
         IF g_idh.idh011 = 'BIN23' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh058
         LET g_idg_s[l_n].idg24 = g_idh.idh058
      END IF
      IF g_idh.idh059  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN24'
         IF g_idh.idh011 = 'BIN24' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh059
         LET g_idg_s[l_n].idg24 = g_idh.idh059
      END IF
      IF g_idh.idh060  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN25'
         IF g_idh.idh011 = 'BIN25' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh060
         LET g_idg_s[l_n].idg24 = g_idh.idh060
      END IF
      IF g_idh.idh061  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN26'
         IF g_idh.idh011 = 'BIN26' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh061
         LET g_idg_s[l_n].idg24 = g_idh.idh061
      END IF
      IF g_idh.idh062  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN27'
         IF g_idh.idh011 = 'BIN27' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh062
         LET g_idg_s[l_n].idg24 = g_idh.idh062
      END IF
      IF g_idh.idh063  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN28'
         IF g_idh.idh011 = 'BIN28' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh063
         LET g_idg_s[l_n].idg24 = g_idh.idh063
      END IF
      IF g_idh.idh064  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN29'
         IF g_idh.idh011 = 'BIN29' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh064
         LET g_idg_s[l_n].idg24 = g_idh.idh064
      END IF
      IF g_idh.idh065  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN30'
         IF g_idh.idh011 = 'BIN30' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh065
         LET g_idg_s[l_n].idg24 = g_idh.idh065
      END IF
      IF g_idh.idh066  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN31'
         IF g_idh.idh011 = 'BIN31' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh066
         LET g_idg_s[l_n].idg24 = g_idh.idh066
      END IF
      IF g_idh.idh067  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN32'
         IF g_idh.idh011 = 'BIN32' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh067
         LET g_idg_s[l_n].idg24 = g_idh.idh067
      END IF
      IF g_idh.idh068  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN33'
         IF g_idh.idh011 = 'BIN33' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh068
         LET g_idg_s[l_n].idg24 = g_idh.idh068
      END IF
      IF g_idh.idh069  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN34'
         IF g_idh.idh011 = 'BIN34' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh069
         LET g_idg_s[l_n].idg24 = g_idh.idh069
      END IF
      IF g_idh.idh070  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN35'
         IF g_idh.idh011 = 'BIN35' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh070
         LET g_idg_s[l_n].idg24 = g_idh.idh070
      END IF
      IF g_idh.idh071  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN36'
         IF g_idh.idh011 = 'BIN36' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh071
         LET g_idg_s[l_n].idg24 = g_idh.idh071
      END IF
      IF g_idh.idh072  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN37'
         IF g_idh.idh011 = 'BIN37' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh072
         LET g_idg_s[l_n].idg24 = g_idh.idh072
      END IF
      IF g_idh.idh073  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN38'
         IF g_idh.idh011 = 'BIN38' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh073
         LET g_idg_s[l_n].idg24 = g_idh.idh073
      END IF
      IF g_idh.idh074  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN39'
         IF g_idh.idh011 = 'BIN39' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh074
         LET g_idg_s[l_n].idg24 = g_idh.idh074
      END IF
      IF g_idh.idh075  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN40'
         IF g_idh.idh011 = 'BIN40' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh075
         LET g_idg_s[l_n].idg24 = g_idh.idh075
      END IF
      IF g_idh.idh076  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN41'
         IF g_idh.idh011 = 'BIN41' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh076
         LET g_idg_s[l_n].idg24 = g_idh.idh076
      END IF
      IF g_idh.idh077  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN42'
         IF g_idh.idh011 = 'BIN42' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh077
         LET g_idg_s[l_n].idg24 = g_idh.idh077
      END IF
      IF g_idh.idh078  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN43'
         IF g_idh.idh011 = 'BIN43' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh078
         LET g_idg_s[l_n].idg24 = g_idh.idh078
      END IF
      IF g_idh.idh079  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN44'
         IF g_idh.idh011 = 'BIN44' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh079
         LET g_idg_s[l_n].idg24 = g_idh.idh079
      END IF
      IF g_idh.idh080  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN45'
         IF g_idh.idh011 = 'BIN45' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh080
         LET g_idg_s[l_n].idg24 = g_idh.idh080
      END IF
      IF g_idh.idh081  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN46'
         IF g_idh.idh011 = 'BIN46' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh081
         LET g_idg_s[l_n].idg24 = g_idh.idh081
      END IF
      IF g_idh.idh082  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN47'
         IF g_idh.idh011 = 'BIN47' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh082
         LET g_idg_s[l_n].idg24 = g_idh.idh082
      END IF
      IF g_idh.idh083  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN48'
         IF g_idh.idh011 = 'BIN48' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh083
         LET g_idg_s[l_n].idg24 = g_idh.idh083
      END IF
      IF g_idh.idh084  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN49'
         IF g_idh.idh011 = 'BIN49' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh084
         LET g_idg_s[l_n].idg24 = g_idh.idh084
      END IF
      IF g_idh.idh085  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN50'
         IF g_idh.idh011 = 'BIN50' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh085
         LET g_idg_s[l_n].idg24 = g_idh.idh085
      END IF
      IF g_idh.idh086  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN51'
         IF g_idh.idh011 = 'BIN51' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh086
         LET g_idg_s[l_n].idg24 = g_idh.idh086
      END IF
      IF g_idh.idh087  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN52'
         IF g_idh.idh011 = 'BIN52' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh087
         LET g_idg_s[l_n].idg24 = g_idh.idh087
      END IF
      IF g_idh.idh088  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN53'
         IF g_idh.idh011 = 'BIN53' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh088
         LET g_idg_s[l_n].idg24 = g_idh.idh088
      END IF
      IF g_idh.idh089  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN54'
         IF g_idh.idh011 = 'BIN54' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh089
         LET g_idg_s[l_n].idg24 = g_idh.idh089
      END IF
      IF g_idh.idh090  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN55'
         IF g_idh.idh011 = 'BIN55' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh090
         LET g_idg_s[l_n].idg24 = g_idh.idh090
      END IF
      IF g_idh.idh091  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN56'
         IF g_idh.idh011 = 'BIN56' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh091
         LET g_idg_s[l_n].idg24 = g_idh.idh091
      END IF
      IF g_idh.idh092  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN57'
         IF g_idh.idh011 = 'BIN57' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh092
         LET g_idg_s[l_n].idg24 = g_idh.idh092
      END IF
      IF g_idh.idh093  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN58'
         IF g_idh.idh011 = 'BIN58' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh093
         LET g_idg_s[l_n].idg24 = g_idh.idh093
      END IF
      IF g_idh.idh094  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN59'
         IF g_idh.idh011 = 'BIN59' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh094
         LET g_idg_s[l_n].idg24 = g_idh.idh094
      END IF
      IF g_idh.idh095  > 0 THEN
         LET l_n = l_n + 1
         LET g_idg_s[l_n].idg20 = l_idg20
         LET g_idg_s[l_n].idg21 = 'BIN99'
         IF g_idh.idh011 = 'BIN99' THEN
            LET g_idg_s[l_n].idg22 = 'Y'
         ELSE
            LET g_idg_s[l_n].idg22 = 'N'
         END IF
         LET g_idg_s[l_n].idg23 = g_idh.idh095
         LET g_idg_s[l_n].idg24 = g_idh.idh095
      END IF
      IF g_imaicd08 = 'Y' THEN   #FUN-BA0051 mark  #MOD-D30237
      #IF s_icdbin(g_rvb05) THEN   #FUN-BA0051  #MOD-D30237
         IF l_n = 0 THEN
            LET g_errno = 'aic-193'
            LET g_rec_b2 = 0
            CALL g_idg_s.clear()
            RETURN
         END IF
      END IF
      LET g_rec_b2 = l_n
   END IF
END FUNCTION
 
# 將刻號中的ID補滿'0'
FUNCTION p021_zero(p_key)
DEFINE  p_key     LIKE ida_file.ida05
DEFINE  l_i       LIKE type_file.num5
DEFINE  l_length  LIKE type_file.num5
 
   LET l_length = 3 - length(p_key) 
   IF l_length <= 0 THEN
      RETURN p_key
   END IF
 
   FOR l_i = 1 TO l_length
       LET p_key = '0',p_key CLIPPED
   END FOR
 
   RETURN p_key
END FUNCTION
 
#1.1已測Wafer控卡: 用下列方式帶出該BIN值是否為Pass BIN,
#   如果所輸入之料號之Pass BIN(icf04) <> ‘Y’ , 則警告user輸入錯誤
#1.1.1用入庫料號串及BIN值(idc06)串BIN檔(icf_file)之
#     料件編號(icf01)及BIN值(icf02)帶出Pass BIN(icf04),
#     如果不存在, 用入庫料號串料件主檔帶出Wafer料號(imaicd06)
#1.1.2 如果Wafer料號<> ' ', 再用Wafer料號及BIN值(idc06)串
#      BIN檔(icf_file)之料件編號(icf01)及BIN值(icf02)
#      帶出Pass BIN(icf04)
#1.1.3 如果Wafer料號 = ' ', 再用母體料號(rvviicd03)及BIN值(idc06)
#      串BIN檔(icf_file)之料件編號(icf01)及BIN值(icf02)
#      帶出Pass BIN(icf04)
FUNCTION p021_passbin_chk(p_key)
   DEFINE l_imaicd06 LIKE imaicd_file.imaicd06,
          l_imaicd04 LIKE imaicd_file.imaicd04,
          l_icf04 LIKE icf_file.icf04
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE p_key       LIKE idg_file.idg21 #BIN值
 
   LET g_errno = ''
   LET l_imaicd06 = ''
   LET l_imaicd04 = ''
 
   LET g_rvb05 = ''
   LET g_pmniicd14 = ''
   LET g_pmn41 = ''
 
   IF NOT cl_null(g_rvb.rvb04)THEN
       SELECT pmn04,pmniicd14 INTO g_rvb05,g_pmniicd14
        FROM pmn_file,pmni_file
       WHERE pmn01 = g_rvb.rvb04
         AND pmn02 = g_rvb.rvb03
         AND pmni01=pmn01
         AND pmni02=pmn02
   ELSE
       SELECT pmn04,pmniicd14 INTO g_rvb05,g_pmniicd14
        FROM pmn_file,pmni_file
       WHERE pmn01 = g_idg.idg04
         AND pmn02 = g_idg.idg05
         AND pmni01=pmn01
         AND pmni02=pmn02
   END IF
 
 
   #取得該料件之內編子體(Wafer料號),料件狀態
   SELECT imaicd06,imaicd04 INTO l_imaicd06,l_imaicd04
      FROM imaicd_file
     WHERE imaicd00 = g_rvb05  #採購料件
 
   IF l_imaicd04 != '2' THEN RETURN END IF  #只for已測Wafer(CP)回貨料號
 
   LET l_flag = '1'
 
   #case1.先用該料號以及BIN值串icf_file
   LET l_icf04 = ''
   SELECT icf04 INTO l_icf04
     FROM icf_file
    WHERE icf01 = g_rvb05              #料件編號
      AND icf02 = p_key                #BIN值
   IF SQLCA.SQLCODE = 100 THEN
      LET l_flag = '2'
   ELSE
      IF SQLCA.SQLCODE != 0 THEN
         LET g_errno = SQLCA.SQLCODE
         RETURN
      END IF
   END IF
 
   #case2.case1串不到時,改用該料號的Wafer料號(imaicd06)串icf_file
   IF l_flag = '2' THEN
      IF NOT cl_null(l_imaicd06) THEN
         SELECT icf04 INTO l_icf04
            FROM icf_file
           WHERE icf01 = l_imaicd06
             AND icf02 = p_key       #BIN值
         IF SQLCA.SQLCODE = 100 THEN
            LET l_flag = '3'
         ELSE
            IF SQLCA.SQLCODE != 0 THEN
               LET g_errno = SQLCA.SQLCODE
               RETURN
            END IF
         END IF
      ELSE
         LET l_flag = '3'
      END IF
   END IF
 
   #case3.case2也串不到時,再改用傳入參數母體料號來串icf_file
   IF l_flag = '3' THEN
      SELECT icf04 INTO l_icf04
        FROM icf_file
       WHERE icf01 = g_pmniicd14          #母體料號
         AND icf02 = p_key                #BIN值
      IF SQLCA.SQLCODE THEN
         #該料件BIN值不存在passbin檔,請查核!!
         #boblee 061213 不檢查 bin 是否存在，只檢查是否有pass bin
         LET l_icf04 = 'N'
         LET g_errno = 'aic-132'  #FUN-C30286
      END IF
   END IF
 
   #Pass Bin不等於'Y'
   IF l_icf04 != 'Y' THEN
      IF cl_null(g_errno) THEN    #FUN-C30286
         LET g_errno = 'aic-183'
      END IF     #FUN-C30286
      LET g_idg.idg22 = 'N' #TQC-A30130
   ELSE
      LET g_idg.idg22 = 'Y'
   END IF
END FUNCTION
 
#CP回貨刻號檢查:若回貨刻號不存在發料刻號,出現錯誤訊息,並詢問是否要寫入,
#如果Y則照樣寫入,如果N則產生失敗
FUNCTION p021_sign_chk()
   DEFINE l_imaicd04  LIKE imaicd_file.imaicd04
   DEFINE l_cnt       LIKE type_file.num5
 
   LET g_errno = ''
   LET l_imaicd04 = ''
 
   LET g_rvb05 = ''
   LET g_pmniicd14 = ''
   LET g_pmn41 = ''
 
   #取得採購料號,母體料號,工單單號
   SELECT pmn04,pmniicd14,pmn41 INTO g_rvb05,g_pmniicd14,g_pmn41
     FROM pmn_file,pmni_file
    WHERE pmn01 = g_idg.idg04
      AND pmn02 = g_idg.idg05
      AND pmni01=pmn01
      AND pmni02=pmn02
 
   #取得該料件之料件狀態
   SELECT imaicd04 INTO l_imaicd04
      FROM imaicd_file
     WHERE imaicd00 = g_rvb05   #收貨料號
 
   IF l_imaicd04 != '2' THEN RETURN END IF  #只for已測Wafer(CP)回貨料號
END FUNCTION
 
#重新計算收貨刻號片數
#已測Wafer回貨(CP),刻號之片數計算:
#FUN-A10130--begin--mark-----------
#FUNCTION p021_upd_idd13()
#   DEFINE l_imaicd04      LIKE imaicd_file.imaicd04  #料件狀態
#   DEFINE l_idd18_sum     LIKE idd_file.idd18  #DIE數總合
#   DEFINE l_idd           RECORD LIKE idd_file.*
#   DEFINE l_idd05         LIKE idd_file.idd05  #刻號
#   DEFINE l_idd13_sum     LIKE idd_file.idd13  #片數總合
#   DEFINE l_idd13_nw      LIKE idd_file.idd13  #計算後片數
#   DEFINE l_cnt_sum       LIKE type_file.num5  #筆數總合
#   DEFINE l_cnt           LIKE type_file.num5  #筆數計數器
#   DEFINE l_aa            LIKE type_file.num5  #計算用
#   DEFINE l_bb            LIKE idd_file.idd13  #計算用
# 
#   LET g_errno = ''
# 
#   IF g_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF  #委外TKY非最終站不做
# 
#   #取得收貨料號之料件狀態
#   LET l_imaicd04 = ' '
#   SELECT imaicd04 INTO l_imaicd04
#      FROM imaicd_file
#     WHERE imaicd00 = g_rvb.rvb05   #料號
# 
#   IF l_imaicd04 != '2' THEN RETURN END IF #只for已測Wafer(CP)回貨
# 
#   #取得該收貨項次同刻號Die數總合
#   LET l_idd05 = ''
#   LET l_idd18_sum = 0
#   LET l_cnt_sum = 0
#   DECLARE idd18_dec CURSOR FOR
#      #      刻號     ,Die數總合,     資料筆數
#      SELECT idd05,SUM(idd18),COUNT(*)
#         FROM idd_file
#        WHERE idd10 = g_rvb.rvb01 #單號
#          AND idd11 = g_rvb.rvb02 #項次
#         GROUP BY idd05
#         ORDER BY idd05
# 
#   FOREACH idd18_dec INTO l_idd05,l_idd18_sum,l_cnt_sum
# 
#      #取得該收貨項次刻號的明細資料
#      DECLARE idd_dec CURSOR FOR
#         SELECT * FROM idd_file
#           WHERE idd10 = g_rvb.rvb01 #單號
#             AND idd11 = g_rvb.rvb02 #項次
#             AND idd05 = l_idd05 #刻號
#           ORDER BY idd18 DESC  #依die數由大至小排序
# 
#      #依各明細Die數占Die數總合比例推算片數
#      #片數取到小數點第2位(無條件捨去)
#      #同刻號總合是一片,餘數給同刻號的最後一筆明細
#      LET l_cnt = 1             #筆數計數器
#      LET l_idd13_sum = 0   #片數計數器
#      INITIALIZE l_idd.* TO NULL
#      FOREACH idd_dec INTO l_idd.*
#         LET l_idd13_nw = 0  #片數
# 
#         IF l_cnt_sum = l_cnt THEN
#            LET l_idd13_nw = 1 - l_idd13_sum
#         ELSE
#            LET l_idd13_nw = l_idd.idd18 / l_idd18_sum
#            #--捨小數第二位無條件捨去的處理-----
#            LET l_aa = l_idd13_nw * 100
#            LET l_idd13_nw = l_aa / 100
#         END IF
# 
#         #更新刻號明細的片數值
#         UPDATE idd_file SET idd13 = l_idd13_nw
#            WHERE idd10 = g_rvb.rvb01  #單號
#              AND idd11 = g_rvb.rvb02  #項次
#              AND idd01 = l_idd.idd01  #料
#              AND idd02 = l_idd.idd02  #倉
#              AND idd03 = l_idd.idd03  #儲
#              AND idd04 = l_idd.idd04  #批
#              AND idd05 = l_idd.idd05  #刻號
#              AND idd06 = l_idd.idd06  #BIN
#          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             LET g_errno = 'upd idd13:fail'
#             CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
#             LET g_msg = "upd idd13:fail! ",g_msg CLIPPED
#             OUTPUT TO REPORT p021_trans_rep('',g_idg04,g_idg05,
#                                             g_msg)
#             RETURN
#          ELSE
#             LET l_idd13_sum = l_idd13_sum + l_idd13_nw
#             LET l_cnt = l_cnt + 1
#          END IF
#      END FOREACH
#   END FOREACH
# 
#END FUNCTION   
#FUN-A10130--end--mark---------
 
#若料件狀態='2'並且需展明細,
#1.實收數量(rvb07):加總該收貨項次之刻號明細片數(idd13)總合
#2.收貨數量(rvb08):加總該收貨項次之刻號明細片數(idd13)總合
#3.單位一數量(rvb82):加總該收貨項次之刻號明細片數(idd13)總合
#4.單位二數量(rvb85):加總該收貨項次之刻號明細Die(idd18)數總合
#5.計價數量(rvb87):加總該收貨項次之刻號明細片數(idd13)總合
#若料件狀態='0-1'並且需展明細,
#1.單位二數量(rvb85):加總該收貨項次之刻號明細Die(idd18)數總合
FUNCTION p021_upd_rvb()
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04
   DEFINE l_imaicd08   LIKE imaicd_file.imaicd08
   DEFINE l_ima906     LIKE ima_file.ima906    #單位使用方式
   DEFINE l_ida17_sum  LIKE ida_file.ida17  #Die數總合
   DEFINE l_ida10_sum  LIKE ida_file.ida10  #片數總合
 
   LET g_errno = ''
 
   IF g_rvbi.rvbiicd13 = 'Y' THEN RETURN END IF  #委外TKY非最終站不做
   IF g_sma.sma115 != 'Y' THEN RETURN END IF    #不使用雙單位
 
   #取得收貨料號之料件狀態,展明細否
   LET l_imaicd04 = ' '
   #LET l_imaicd08 = ' '   #FUN-BA0051 mark
   LET l_ima906 = ' '
   SELECT imaicd04,imaicd08,ima906
      INTO l_imaicd04,l_imaicd08,l_ima906
      FROM imaicd_file,ima_file
     WHERE imaicd00 = g_rvb.rvb05   #料號
       AND ima01 = imaicd00         #CHI-940010 hellen add 
 
   #單一單位者,不更新
   IF l_ima906 != '3' OR cl_null(l_ima906) THEN RETURN END IF
   #料件狀態非='0-2',或不展明細者,不更新
   #IF l_imaicd04 NOT MATCHES '[0-2]' OR              #FUN-BA0051 mark
   #   l_imaicd08 ! = 'Y' OR cl_null(l_imaicd08) THEN #FUN-BA0051 mark
   IF NOT s_icdbin(g_rvb.rvb05) THEN   #FUN-BA0051
      RETURN
   END IF
 
   LET l_ida17_sum = 0
   LET l_ida10_sum = 0
  #SELECT SUM(ida17),SUM(ida10)              #die數總合,片數總合  #FUN-C30286 mark
   SELECT SUM(ida17),SUM(ida10)+SUM(ida11)   #die數總合,片數總合  #FUN-C30286
      INTO l_ida17_sum,l_ida10_sum
      FROM ida_file
     WHERE ida07 = g_rvb.rvb01   #收貨單號
       AND ida08 = g_rvb.rvb02   #收貨項次
 
   #更新收貨項次之數量資訊
   IF l_imaicd04 = '2' THEN
      LET g_rvb.rvb07 = l_ida10_sum                  #實收數量
      LET g_rvb.rvb07 = s_digqty(g_rvb.rvb07,g_rvb.rvb90) #FUN-BB0083 add
      LET g_rvb.rvb08 = l_ida10_sum                  #收貨數量
      LET g_rvb.rvb08 = s_digqty(g_rvb.rvb08,g_rvb.rvb90) #FUN-BB0083 add
      LET g_rvb.rvb82 = l_ida10_sum                  #單位一數量
      LET g_rvb.rvb82 = s_digqty(g_rvb.rvb82,g_rvb.rvb80) #FUN-BB0083 add
      LET g_rvb.rvb81 = g_rvb.rvb07/g_rvb.rvb82      #單位一換算率
      LET g_rvb.rvb85 = l_ida17_sum                  #單位二數量
      LET g_rvb.rvb84 = g_rvb.rvb82/g_rvb.rvb85      #單位二換算率
      LET g_rvb.rvb87 = l_ida10_sum                  #計價數量
      LET g_rvb.rvb87 = s_digqty(g_rvb.rvb87,g_rvb.rvb86) #FUN-BB0083 add
   ELSE
      LET g_rvb.rvb07 = g_rvb.rvb07                  #實收數量
      LET g_rvb.rvb07 = s_digqty(g_rvb.rvb07,g_rvb.rvb90) #FUN-BB0083 add
      LET g_rvb.rvb08 = g_rvb.rvb08                  #收貨數量
      LET g_rvb.rvb08 = s_digqty(g_rvb.rvb08,g_rvb.rvb90) #FUN-BB0083 add
      LET g_rvb.rvb82 = g_rvb.rvb82                  #單位一數量
      LET g_rvb.rvb82 = s_digqty(g_rvb.rvb82,g_rvb.rvb80) #FUN-BB0083 add
      LET g_rvb.rvb81 = g_rvb.rvb07/g_rvb.rvb82      #單位一換算率
      LET g_rvb.rvb85 = l_ida17_sum                  #單位二數量
      LET g_rvb.rvb84 = g_rvb.rvb82/g_rvb.rvb85      #單位二換算率
      LET g_rvb.rvb87 = g_rvb.rvb87                  #計價數量
      LET g_rvb.rvb87 = s_digqty(g_rvb.rvb87,g_rvb.rvb86) #FUN-BB0083 add
   END IF
 
   UPDATE rvb_file SET rvb07 = g_rvb.rvb07,       #實收數量
                       rvb08 = g_rvb.rvb08,       #收貨數量
                       rvb82 = g_rvb.rvb82,       #單位一數量
                       rvb81 = g_rvb.rvb81,       #單位一換算率
                       rvb85 = g_rvb.rvb85,       #單位二數量
                       rvb84 = g_rvb.rvb84,       #單位二換算率
                       rvb87 = g_rvb.rvb87        #計價數量
      WHERE rvb01 = g_rvb.rvb01
        AND rvb02 = g_rvb.rvb02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_errno = 'upd rvb85: fail!'
      CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
      LET g_msg = "upd rvb85:fail! ",g_msg CLIPPED
     #OUTPUT TO REPORT p021_trans_rep('',g_idg04,g_idg05,g_msg)  #FUN-A10130
      CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')   #FUN-A10130
      RETURN
   END IF
 
   #FUN-A30092--begin--add-----
   IF (g_icf04='N') AND (g_rvb.rvb36 <>'MISC') 
                    AND (NOT cl_null(g_ica.ica28))THEN
      UPDATE rvb_file SET rvb36=g_ica.ica28
                    WHERE rvb01 = g_rvb.rvb01
                      AND rvb02 = g_rvb.rvb02
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_errno = 'upd rvb36: fail!'
         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING g_msg
         LET g_msg = "upd rvb36:fail! ",g_msg CLIPPED
         CALL p021_trans_rep1('',g_idg04,g_idg05,g_msg,'N')
         RETURN
      END IF
   END IF
   #FUN-A30092--end--add-------
   # ---做實收數量的檢查---
   CALL p021_rvb07('2',l_ida10_sum,'t')
   IF NOT cl_null(g_errno) THEN
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
     #OUTPUT TO REPORT p021_trans_rep('',g_idh.idh004,       #FUN-A10130
     #                                   g_idh.idh005,g_msg) #FUN-A10130
      CALL p021_trans_rep1('',g_idh.idh004,g_idh.idh005,g_msg,'N') #FUN-A10130
      RETURN
   END IF
END FUNCTION
 
REPORT p021_trans_rep(p_invoice,p_no,p_seq,p_msg)
DEFINE  l_last_sw  LIKE type_file.chr1
DEFINE  p_invoice  LIKE idg_file.idg42
DEFINE  p_no       LIKE idg_file.idg04
DEFINE  p_seq      LIKE idg_file.idg05
DEFINE  p_msg      LIKE type_file.chr1000
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN 0
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
 
  FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-length(g_company))/2)+1,g_company CLIPPED
         IF cl_null(g_towhom) THEN
            PRINT '';
         ELSE
            PRINT 'TO:',g_towhom CLIPPED;
         END IF
         PRINT COLUMN (g_len-length(g_user)-5),'FROM:',g_user CLIPPED
         PRINT COLUMN ((g_len-length(g_x[2]))/2)+1,g_x[2] CLIPPED
         PRINT ''
         PRINT COLUMN 01,g_x[3] CLIPPED,g_pdate,' ',TIME,
               COLUMN g_len-10,g_x[4] CLIPPED,PAGENO USING '<<<'  #No.CHI-920025 add
         PRINT g_dash[1,g_len]
         PRINT COLUMN 01,g_x[15] CLIPPED,
               COLUMN 22,g_x[13] CLIPPED,
               COLUMN 39,g_x[14] CLIPPED,
               COLUMN 45,g_x[12] CLIPPED
         PRINT COLUMN 01,'--------------------',
               COLUMN 22,'----------------',
               COLUMN 39,'-----',
               COLUMN 45,'------------------------------------------------------------------------------------------------'
         LET l_last_sw = 'n'
 
      ON EVERY ROW
         PRINT COLUMN 01,p_invoice,
               COLUMN 22,p_no,
               COLUMN 39,p_seq USING '<<<<<',
               COLUMN 45,p_msg[1,96]
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT COLUMN 01,g_x[5] CLIPPED,
               COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT COLUMN 01,g_x[5] CLIPPED,
                  COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT

#FUN-980035 --Begin
FUNCTION p021_excel_to_txt(p_file_path,p_txt_path,p_symbol)

DEFINE p_file_path  STRING
DEFINE p_txt_path   STRING
DEFINE p_symbol     LIKE type_file.chr1
DEFINE l_txt_path   STRING
DEFINE ls_value     STRING
DEFINE ls_cell      STRING
DEFINE l_line       STRING
DEFINE li_result    LIKE type_file.num5
DEFINE l_channel    base.Channel
DEFINE l_r,l_c      LIKE type_file.num5
DEFINE l_cmd        STRING
   LET l_cmd = "rm -f ",p_txt_path
   RUN l_cmd
   LET l_channel  = base.Channel.create()                                       
   CALL l_channel.openFile(p_txt_path,"a")

   CALL ui.Interface.frontCall("standard","shellexec",[p_file_path] ,[li_result])
   CALL p021_checkError(li_result,"Open File")

   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",p_file_path],[li_result])
   CALL p021_checkError(li_result,"Connect File")

   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
   CALL p021_checkError(li_result,"Connect Sheet1")
   
   LET l_r = 1
   WHILE TRUE
      FOR l_c=1 TO g_col
         LET ls_cell = "R"||l_r||"C"||l_c
         CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",p_file_path,ls_cell],[li_result,ls_value])
         CALL p021_checkError(li_result,"Peek Cells")
         LET ls_value = ls_value.trim()
         IF l_c=1 AND cl_null(ls_value) THEN 
            EXIT WHILE
         END IF
         IF l_c = g_idf.getLength() THEN
            LET l_r = l_r +1
            LET l_line = l_line,ls_value
            CALL l_channel.write(l_line)
            LET l_line = ""
         ELSE
            LET l_line = l_line,ls_value,p_symbol
         END IF
      END FOR
   END WHILE

END FUNCTION
FUNCTION p021_checkError(p_result,p_msg)
   DEFINE   p_result   SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  SMALLINT

   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
   EXIT PROGRAM
END FUNCTION

#FUN-980035 --End

#FUN-A10130--begin--add----
FUNCTION p021_trans_rep1(p_invoice,p_no,p_seq,p_msg,p_flag)                                                                                   
DEFINE  p_invoice  LIKE idg_file.idg42                                                                                              
DEFINE  p_no       LIKE idg_file.idg04                                                                                              
DEFINE  p_seq      LIKE idg_file.idg05                                                                                              
DEFINE  p_msg      LIKE type_file.chr1000   
DEFINE  p_flag     LIKE type_file.chr1
DEFINE  l_idq      RECORD 
                   idq01   LIKE idq_file.idq01,
                   idq02   LIKE idq_file.idq02,
                   idq03   LIKE idq_file.idq03,
                   idq04   DATETIME YEAR TO MINUTE,
                   idq05   LIKE idq_file.idq05,
                   idq06   LIKE idq_file.idq06,
                   idq07   LIKE idq_file.idq07,
                   idq08   LIKE idq_file.idq08,
                   idq09   LIKE idq_file.idq09,
                   idq10   LIKE idq_file.idq10,
                   idq11   LIKE idq_file.idq11,
                   idq12   LIKE idq_file.idq12,
                   idq13   LIKE idq_file.idq13
                   END RECORD

    IF g_bgjob = 'Y' THEN
       INITIALIZE l_idq.* TO NULL
       SELECT MAX(idq03)+1 INTO l_idq.idq03
         FROM idq_file
        WHERE idq01 = g_ide.ide01
          AND idq02 = g_ide.ide02
          AND idq06 = p_no
          AND idq07 = p_seq
       IF cl_null(l_idq.idq03) THEN LET l_idq.idq03 = 1 END IF
       LET l_idq.idq01 = g_ide.ide01
       LET l_idq.idq02 = g_ide.ide02
       LET l_idq.idq04 = CURRENT YEAR TO MINUTE
       LET l_idq.idq05 = p_flag
       LET l_idq.idq06 = p_no
       LET l_idq.idq07 = p_seq
       LET l_idq.idq08 = ''
       LET l_idq.idq10 = ''
       LET l_idq.idq09 = ''
       LET l_idq.idq11 = ''
       LET l_idq.idq12 = p_msg
       LET l_idq.idq13 = ''
       INSERT INTO idq_file VALUES (l_idq.*)
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN       #置入資料庫不成功
          RETURN
       END IF
    ELSE
      OUTPUT TO REPORT p021_trans_rep(p_invoice,p_no,p_seq,p_msg)
    END IF
END FUNCTION
#FUN-A10130--end--add-----

#FUN-A30066--begin--add----
FUNCTION p021()
DEFINE l_sql,l_cmd  STRING
DEFINE l_tok        base.StringTokenizer
DEFINE l_ide05      LIKE ide_file.ide05 
DEFINE i            LIKE type_file.num5
DEFINE lch_pipe     base.Channel          #FUN-C30286
DEFINE gs_fname     STRING                #FUN-C30286
DEFINE l_target     STRING                #FUN-C30286
DEFINE l_type       LIKE type_file.chr10  #FUN-C30286
DEFINE l_length     LIKE type_file.num5   #FUN-C30286
       
   SELECT * INTO g_ica.* FROM ica_file WHERE ica00='0'
   LET l_sql = "SELECT * FROM ide_file"
   PREPARE p021_ide_pre1 FROM l_sql
   DECLARE p021_ide_cs1
      SCROLL CURSOR WITH HOLD FOR p021_ide_pre1
   FOREACH p021_ide_cs1 INTO g_ide.*
      LET g_success = 'Y'
      CALL p021_b_fill('')
      #str TQC-C50095 mod
      #組路徑
      #LET g_location = g_ica.ica43 CLIPPED,"\\",g_ide.ide01 CLIPPED,"\\",  #FUN-C30286
      #                 g_ide.ide02 CLIPPED,"\\"                            #FUN-C30286
      #LET g_location = FGL_GETENV("TEMPDIR"),"/",g_ide.ide01 CLIPPED,"/",  #FUN-C30286  #TQC-C50095 mark
      #                 g_ide.ide02 CLIPPED,"/","upload","/"                #FUN-C30286  #TQC-C50095 mark
       LET g_dir = FGL_GETENV("TOP"),"/doc/aic/aicp021/",g_ide.ide01 CLIPPED,"/",g_ide.ide02 CLIPPED,"/"  #TQC-C60190 mod
       LET g_location = g_dir CLIPPED,"upload","/" 
      #end TQC-C50095 mod
      #CALL cl_replace_str(g_location,"/","\\") RETURNING g_location        #FUN-C30286

      #FUN-C30286---begin
      #取得路徑下所有待轉檔的檔案,利用openpipe取得路徑下的所有檔案
   
      LET  l_cmd = "ls ",g_location CLIPPED
      LET  lch_pipe = base.Channel.create()
      CALL lch_pipe.openPipe(l_cmd,"r")
      LET  g_msg = ""
      #FUN-C30286---end
      #FUN-C30286---begin mark
      #找出指定路徑下所有的csv檔案
      #CALL p021_find_csv()     
      #SLEEP 1                 
      #讀取抓到的所有CSV檔名
      #CALL p021_load()        
      #IF g_success = 'N' THEN  
      #   CONTINUE FOREACH      
      #END IF                   
      
      #FOR i = 1 TO g_csv.getLength() - 1
      #    LET l_tok = base.StringTokenizer.createExt(g_csv[i].csv,",","",TRUE)  
      #    LET l_ide05 = l_tok.nextToken()
      #    LET g_ide.ide05 = l_ide05
      #FUN-C30286---end 
      WHILE lch_pipe.read(gs_fname)  #FUN-C30286
          LET g_ide.ide05 = gs_fname
          CALL p021_upload(g_ide.ide05)
          IF g_success = 'Y' THEN         #FUN-C30213     
             CALL p021_trans(g_ide.ide05)
          END IF                          #FUN-C30213
      
          IF g_success = "Y" THEN
             #已經轉檔的檔名改為bak
             #CALL p021_gen_bak()  #FUN-C30286
          #FUN-C30286---begin
             LET l_cmd="mv ",g_location,gs_fname CLIPPED," ",
                        g_dir,"trans","/",gs_fname CLIPPED                    #TQC-C50095
                       #FGL_GETENV("TEMPDIR"),"/",g_ide.ide01 CLIPPED,"/",    #TQC-C50095 mark
                       #g_ide.ide02 CLIPPED,"/","trans","/",gs_fname CLIPPED  #TQC-C50095 mark
             RUN l_cmd
          ELSE
             LET l_cmd="mv ",g_location,gs_fname CLIPPED," ",
                        g_dir,"error","/",gs_fname CLIPPED                    #TQC-C50095
                       #FGL_GETENV("TEMPDIR"),"/",g_ide.ide01 CLIPPED,"/",    #TQC-C50095 mark
                       #g_ide.ide02 CLIPPED,"/","error","/",gs_fname CLIPPED  #TQC-C50095 mark
             RUN l_cmd
          #FUN-C30286---end
          END IF
      #FUN-C30286---begin
      #END FOR  
          LET l_target = g_location CLIPPED,g_ide.ide05 CLIPPED 
          LET l_length = l_target.getLength()
          LET l_type   = l_target.subString(l_length-2,l_length)
          IF l_type <> "txt" AND l_type <> "CSV" AND l_type <> "csv" THEN
             LET l_target = l_target.subString(1,l_target.getLength()-3),"txt"
             LET l_cmd="rm ",l_target CLIPPED
             RUN l_cmd
          END IF
      END WHILE  
      CALL lch_pipe.close()
      #FUN-C30286--end
    END FOREACH
END FUNCTION

FUNCTION p021_find_csv()
   DEFINE l_channel     base.Channel,
          l_url         STRING,
          l_destination STRING,
          l_source      STRING,
          l_filename    STRING,
          l_cmd         STRING,
          l_bat         STRING,
          g_cmd         STRING

   LET l_url = g_location
   LET l_bat = "aicp021.bat" 
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_bat,"w" )
   CALL l_channel.setDelimiter("")
   LET l_filename = "aicp021_record.txt" 
   #LET l_cmd = "dir /b ",l_url CLIPPED,"*.csv > ", #FUN-C30286
   LET l_cmd = "dir ",l_url CLIPPED,"*.csv > ",     #FUN-C30286
               l_url CLIPPED,l_filename CLIPPED
   CALL l_channel.write(l_cmd)
   CALL l_channel.close()

   LET l_destination = l_url CLIPPED,l_bat CLIPPED
   LET l_source = "$TEMPDIR/",l_bat CLIPPED
   LET status = cl_download_file(l_source, l_destination)
   LET status = cl_open_prog("",l_destination)

END FUNCTION

FUNCTION p021_load()
  DEFINE ch base.Channel
  DEFINE i,l_n      INTEGER
  DEFINE l_len      INTEGER

  INITIALIZE g_fname TO NULL
  CALL g_csv.clear()
  LET g_fname = g_location CLIPPED,"aicp021_record.txt"
  LET g_fpath = FGL_GETENV("TEMPDIR")
  LET l_n = LENGTH(g_fpath)
  IF l_n>0 THEN
     IF g_fpath[l_n,l_n]='/' THEN
        LET g_fpath[l_n,l_n]=' '
     END IF
  END IF

  LET g_fpath = g_fpath CLIPPED,'/',"aicp021_record.txt" 
  IF NOT cl_upload_file(g_fname,g_fpath) THEN
     #CALL cl_err('', "lib-212", 1)  #FUN-C30286
     LET g_success = 'N' RETURN
  END IF

  LET g_cmd = "killcr ",g_fpath  
  RUN g_cmd

  LET g_fpath2 = g_fpath,'2'
  #LET g_cmd = "iconv -f BIG-5 -t UTF-8 ",g_fpath," > ",g_fpath2   #FUN-B30176 mark
  #No.FUN-B30176-add-start--
  IF os.Path.separator()= "/" THEN
     LET g_cmd = "iconv -f BIG-5 -t UTF-8 ",g_fpath," > ",g_fpath2
  ELSE 
     LET g_cmd = "java -cp zhcode.jar zhcode -u8 ",g_fpath," > ",g_fpath2
  END IF
  #No.FUN-B30176-add-end--
  RUN g_cmd

  LET ch= base.Channel.create()
  CALL ch.openFile(g_fpath2,"r")
  IF STATUS THEN
    CALL cl_err(g_fpath,-808,1)
    LET g_success='N'
    CALL ch.close()
    RETURN
  END IF

  LET g_index = 1
  WHILE ch.read([g_csv[g_index].csv])
      IF cl_null(g_csv[g_index].csv) THEN
         EXIT WHILE
      END IF
      IF g_csv[g_index].csv[LENGTH(g_csv[g_index].csv)] = '\r' THEN
         LET g_csv[g_index].csv =
                 g_csv[g_index].csv[1,LENGTH(g_csv[g_index].csv)-1]
      END IF
      LET g_index = g_index + 1
  END WHILE

  LET g_index = g_index - 1
  
  IF g_index = 0 THEN
     CALL cl_err('','-842',1)
     LET g_success='N'
     CALL ch.close()
     RETURN
  END IF
  CALL ch.close()
END FUNCTION

FUNCTION p021_gen_bak()
   DEFINE l_channel     base.Channel,
          l_url         STRING,
          l_destination STRING,
          l_source      STRING,
          l_filename    STRING,
          l_cmd         STRING,
          l_bat         STRING,
          l_bat2        STRING,
          g_cmd         STRING
   DEFINE l_ide05       STRING,              
          l_tok         base.StringTokenizer,
          i             LIKE type_file.num5 

   LET l_url = g_location
   LET l_bat2 = "aicp021.bat2" 
   LET l_bat = "aicp021.bat" 

   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_bat2,"w" )
   CALL l_channel.setDelimiter("")
          
   LET l_cmd = "ren ",l_url CLIPPED,g_ide.ide05 CLIPPED," ",
                                        g_ide.ide05 CLIPPED,".bak "
   CALL l_channel.write(l_cmd)
   LET l_cmd = "\r"
   CALL l_channel.write(l_cmd)

   CALL l_channel.close()

   LET l_destination = l_url CLIPPED,l_bat CLIPPED
   LET l_source = "$TEMPDIR/",l_bat CLIPPED

   LET g_fpath  = "$TEMPDIR/",l_bat2 CLIPPED
   LET g_fpath2 = "$TEMPDIR/",l_bat CLIPPED
   #LET g_cmd = "iconv -f UTF-8 -t BIG-5 ",g_fpath," > ",g_fpath2   #FUN-B30176 mark
   #No.FUN-B30176-add-start--
   IF os.Path.separator() = "/" THEN
      LET g_cmd = "iconv -f UTF-8 -t BIG-5 ",g_fpath," > ",g_fpath2
   ELSE 
      LET g_cmd = "java -cp zhcode.java zhcode -ub ",g_fpath," > ",g_fpath2
   END IF
   #No.FUN-B30176-add-end--
   RUN g_cmd

   LET status = cl_download_file(l_source, l_destination)

   LET status = cl_open_prog("",l_destination)
   SLEEP 1
END FUNCTION
#FUN-A30066--end--add-------------
#TQC-A30130
#CHI-A30026

#str TQC-C50095 add
FUNCTION p021_mkdir()   #建立目錄
    DEFINE l_docdir     STRING
    DEFINE l_file1      STRING
    DEFINE l_file2      STRING
    DEFINE l_file3      STRING
    DEFINE l_file4      STRING
    DEFINE l_file5      STRING
    DEFINE l_cmd        STRING
    DEFINE l_flag       LIKE type_file.num5

    #還沒新增或還沒查詢出資料，不可建立目錄
    IF cl_null(g_ide.ide01) OR cl_null(g_ide.ide02) THEN RETURN END IF

    #詢問"是否要建立自動回貨所需的相關目錄?",若不要則離開
    IF NOT cl_confirm('aic-250') THEN RETURN END IF

    #先找到 $TOP/doc/aic/aicp021 這個目錄,此目錄權限要為777,這樣才可以在底下開目錄
    LET l_docdir = os.Path.join(os.Path.join(os.Path.join(FGL_GETENV('TOP'),"doc"),"aic"),"aicp021")  #TQC-C60190 mod
    LET l_file1 = os.Path.join(l_docdir,g_ide.ide01)   #$TOP/doc/aic/aicp021/廠商
    LET l_file2 = os.Path.join(l_file1,g_ide.ide02)    #$TOP/doc/aic/aicp021/廠商/類別
    LET l_file3 = os.Path.join(l_file2,"upload")       #$TOP/doc/aic/aicp021/廠商/類別/upload
    LET l_file4 = os.Path.join(l_file2,"trans")        #$TOP/doc/aic/aicp021/廠商/類別/trans
    LET l_file5 = os.Path.join(l_file2,"error")        #$TOP/doc/aic/aicp021/廠商/類別/error

    #如果 $TOP/doc/aic/aicp021/廠商 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file1) THEN
       CALL os.Path.mkdir(l_file1) RETURNING l_flag   #建立廠商目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file1,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file1
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp021/廠商/類別 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file2) THEN
       CALL os.Path.mkdir(l_file2) RETURNING l_flag   #建立類別目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file2,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file2
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp021/廠商/類別/upload 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file3) THEN
       CALL os.Path.mkdir(l_file3) RETURNING l_flag   #建立上傳檔案放置的目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file3,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file3
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp021/廠商/類別/trans 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file4) THEN
       CALL os.Path.mkdir(l_file4) RETURNING l_flag   #建立上傳成功後檔案放置的目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file4,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file4
          RUN l_cmd
       END IF
    END IF

    #如果 $TOP/doc/aic/aicp021/廠商/類別/error 這個目錄不存在,那就要建目錄
    IF NOT os.Path.exists(l_file5) THEN
       CALL os.Path.mkdir(l_file5) RETURNING l_flag   #建立上傳失敗後檔案放置的目錄
       IF NOT l_flag THEN   #目錄建不成功,就秀錯誤訊息
          CALL cl_err_msg(NULL,"azz-284",l_file5,20)
          RETURN
       ELSE
          LET l_cmd="chmod 777 ",l_file5
          RUN l_cmd
       END IF
    END IF

END FUNCTION

FUNCTION p021_rmdir()   #刪除目錄
    DEFINE l_file       STRING
    DEFINE l_cmd        STRING

    #詢問"是否要刪除自動回貨的相關目錄?",若不要則離開
    IF NOT cl_confirm('aic-251') THEN RETURN END IF

    #找到 $TOP/doc/aic/aic/aicp021/廠商 這個目錄
    LET l_file = os.Path.join(os.Path.join(os.Path.join(os.Path.join(FGL_GETENV('TOP'),"doc"),"aic"),"aicp021"),g_ide.ide01)  #TQC-C60190 mod

    #將目錄與其底下所有東西都刪除
    LET l_cmd="rm -Rf ",l_file
    RUN l_cmd

END FUNCTION

FUNCTION p021_act_visible()   #控制"產生自動回貨目錄"ACTION的顯示與否
   DEFINE l_file1       STRING
   DEFINE l_file2       STRING

   IF cl_null(g_ide.ide01) OR cl_null(g_ide.ide02) THEN
      CALL cl_set_act_visible("create_dir",FALSE)
   ELSE
      #找到 $TOP/doc/aic/aicp021/廠商 與 $TOP/doc/aic/aicp021/廠商/類別 這兩個目錄
      LET l_file1 = os.Path.join(os.Path.join(os.Path.join(os.Path.join(FGL_GETENV('TOP'),"doc"),"aic"),"aicp021"),g_ide.ide01)  #TQC-C60190 mod
      LET l_file2 = os.Path.join(l_file1,g_ide.ide02)
      #如果目錄已存在,那就不顯示"建立自動回貨目錄"的ACTION
      IF os.Path.exists(l_file1) AND os.Path.exists(l_file2) THEN
         CALL cl_set_act_visible("create_dir",FALSE)
      ELSE
         CALL cl_set_act_visible("create_dir",TRUE)
      END IF
   END IF

END FUNCTION
#end TQC-C50095 add

#No.FUN-9C0072 精簡程式碼
